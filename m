Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E687B10A3FD
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 19:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKZSOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 13:14:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:35839 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfKZSOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 13:14:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 10:14:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,246,1571727600"; 
   d="scan'208";a="211493575"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 26 Nov 2019 10:14:06 -0800
Date:   Tue, 26 Nov 2019 10:14:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 1/1] powerpc/kvm/book3s: Fixes possible 'use after
 release' of kvm
Message-ID: <20191126181406.GC22233@linux.intel.com>
References: <20191126175212.377171-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126175212.377171-1-leonardo@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 26, 2019 at 02:52:12PM -0300, Leonardo Bras wrote:
> Fixes a possible 'use after free' of kvm variable.
> It does use mutex_unlock(&kvm->lock) after possible freeing a variable
> with kvm_put_kvm(kvm).

Moving the calls to kvm_put_kvm() to the end of the functions doesn't
actually fix a use-after-free.  In these flows, the reference being
released is a borrowed reference that KVM takes on behalf of the entity it
is creating, e.g. device, vcpu, or spapr tce.  The caller of these create
helpers must also hold its own reference to @kvm on top of the borrowed
reference, i.e. these kvm_put_kvm() calls will never free @kvm (assuming
there are no refcounting bugs elsewhere in KVM).

If one these kvm_put_kvm() calls did unexpectedly free @kvm (due to a bug
somewhere else), KVM would still hit a use-after-free scenario as the
caller still thinks @kvm is valid.  Currently, this would only happen on a
subsequent ioctl() on the caller's file descriptor (which holds a pointer
to @kvm), as the callers of these functions don't directly dereference
@kvm after the functions return.  But, not deferencing @kvm isn't deliberate
or functionally required, it's just how the code happens to be written.

The intent of adding kvm_put_kvm_no_destroy() was primarily to document
that under no circumstance should the to-be-put reference be the *last*
reference to @kvm.  Moving the call to kvm_put_kvm{_no_destroy}() doesn't
change that

> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_64_vio.c | 3 +--
>  virt/kvm/kvm_main.c              | 8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 5834db0a54c6..a402ead833b6 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -316,14 +316,13 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  
>  	if (ret >= 0)
>  		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
> -	else
> -		kvm_put_kvm(kvm);
>  
>  	mutex_unlock(&kvm->lock);
>  
>  	if (ret >= 0)
>  		return ret;
>  
> +	kvm_put_kvm(kvm);
>  	kfree(stt);
>   fail_acct:
>  	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 13efc291b1c7..f37089b60d09 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2744,10 +2744,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	/* Now it's all set up, let userspace reach it */
>  	kvm_get_kvm(kvm);
>  	r = create_vcpu_fd(vcpu);
> -	if (r < 0) {
> -		kvm_put_kvm(kvm);
> +	if (r < 0)
>  		goto unlock_vcpu_destroy;
> -	}
>  
>  	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
>  
> @@ -2771,6 +2769,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	mutex_lock(&kvm->lock);
>  	kvm->created_vcpus--;
>  	mutex_unlock(&kvm->lock);
> +	if (r < 0)
> +		kvm_put_kvm(kvm);
>  	return r;
>  }
>  
> @@ -3183,10 +3183,10 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  	kvm_get_kvm(kvm);
>  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
>  	if (ret < 0) {
> -		kvm_put_kvm(kvm);
>  		mutex_lock(&kvm->lock);
>  		list_del(&dev->vm_node);
>  		mutex_unlock(&kvm->lock);
> +		kvm_put_kvm(kvm);
>  		ops->destroy(dev);
>  		return ret;
>  	}
> -- 
> 2.23.0
> 
