Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B737E0576
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732144AbfJVNuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 09:50:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732125AbfJVNuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 09:50:01 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B5BA85538
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 13:50:01 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id m68so2547549wme.7
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3c9XeML5CjP2VNMoX20tRhRC9ZOt/gSgNIomZ/IX/KQ=;
        b=irhaQMEQtfW1dF8mwgoG3KD2GRebJLWHoIhayzJPT9T5D16gYGOeBFE2qBkoPFoYLs
         pfuoKKqTbgu/f6XRNS8cM17zjcJ79df9LfHGPodRnLQ+5WU4+iXffsiPXWDNTYKnADUp
         nJnbvDg84z3Epa9AjXPr8I4lUPbE1bHIpO7nxHXXjF800O6GifTT4LAyFamHXqYNAhim
         6jnMSChIPN5GpN3TSpt3I5OtZTRLaf1Gfa7T/jd9emkREbd3QPtQXhxRDqVXfudSWLQK
         d/bpopounx96birKt+mEhxQwhg8mhPc3cFPp3QqIGkEtR3SVcvp7PdABEsICmk/FL2fI
         6KYA==
X-Gm-Message-State: APjAAAUls2aduT8LThnrGqb8+pa0y3nhkJk/rE94PFDGuA0DNCdA7Lu/
        KNz3q5hF62ooeD234oSq4A5Lr3AJ8coopEyLqmxpTLfivPI5dwZn66vCvSWCIKqdHnaOey2ldQT
        pC60mleA79/Fm
X-Received: by 2002:a7b:c846:: with SMTP id c6mr3333948wml.68.1571752199710;
        Tue, 22 Oct 2019 06:49:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwpZeWf9siyfF8zHfI2gJYK3W+BaDfTN9X194fXdua91Mf2zmTVr+dTirEp9YI7yL1+8RYFYg==
X-Received: by 2002:a7b:c846:: with SMTP id c6mr3333921wml.68.1571752199316;
        Tue, 22 Oct 2019 06:49:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id u7sm11923745wre.59.2019.10.22.06.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 06:49:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5fe693ca-4699-778e-3f37-54d42adb1b4f@redhat.com>
Date:   Tue, 22 Oct 2019 15:49:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021225842.23941-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 00:58, Sean Christopherson wrote:
> Add a new helper, kvm_put_kvm_no_destroy(), to handle putting a borrowed
> reference[*] to the VM when installing a new file descriptor fails.  KVM
> expects the refcount to remain valid in this case, as the in-progress
> ioctl() has an explicit reference to the VM.  The primary motiviation
> for the helper is to document that the 'kvm' pointer is still valid
> after putting the borrowed reference, e.g. to document that doing
> mutex(&kvm->lock) immediately after putting a ref to kvm isn't broken.
> 
> [*] When exposing a new object to userspace via a file descriptor, e.g.
>     a new vcpu, KVM grabs a reference to itself (the VM) prior to making
>     the object visible to userspace to avoid prematurely freeing the VM
>     in the scenario where userspace immediately closes file descriptor.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c |  2 +-
>  arch/powerpc/kvm/book3s_64_vio.c    |  2 +-
>  include/linux/kvm_host.h            |  1 +
>  virt/kvm/kvm_main.c                 | 16 ++++++++++++++--
>  4 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 9a75f0e1933b..68678e31c84c 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -2000,7 +2000,7 @@ int kvm_vm_ioctl_get_htab_fd(struct kvm *kvm, struct kvm_get_htab_fd *ghf)
>  	ret = anon_inode_getfd("kvm-htab", &kvm_htab_fops, ctx, rwflag | O_CLOEXEC);
>  	if (ret < 0) {
>  		kfree(ctx);
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  		return ret;
>  	}
>  
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 5834db0a54c6..883a66e76638 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -317,7 +317,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  	if (ret >= 0)
>  		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
>  	else
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  
>  	mutex_unlock(&kvm->lock);
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 719fc3e15ea4..90a2102605ef 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -622,6 +622,7 @@ void kvm_exit(void);
>  
>  void kvm_get_kvm(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
> +void kvm_put_kvm_no_destroy(struct kvm *kvm);
>  
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ef3f2e19e8..b8534c6b8cf6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -772,6 +772,18 @@ void kvm_put_kvm(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_put_kvm);
>  
> +/*
> + * Used to put a reference that was taken on behalf of an object associated
> + * with a user-visible file descriptor, e.g. a vcpu or device, if installation
> + * of the new file descriptor fails and the reference cannot be transferred to
> + * its final owner.  In such cases, the caller is still actively using @kvm and
> + * will fail miserably if the refcount unexpectedly hits zero.
> + */
> +void kvm_put_kvm_no_destroy(struct kvm *kvm)
> +{
> +	WARN_ON(refcount_dec_and_test(&kvm->users_count));
> +}
> +EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);
>  
>  static int kvm_vm_release(struct inode *inode, struct file *filp)
>  {
> @@ -2679,7 +2691,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	kvm_get_kvm(kvm);
>  	r = create_vcpu_fd(vcpu);
>  	if (r < 0) {
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  		goto unlock_vcpu_destroy;
>  	}
>  
> @@ -3117,7 +3129,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
>  	kvm_get_kvm(kvm);
>  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
>  	if (ret < 0) {
> -		kvm_put_kvm(kvm);
> +		kvm_put_kvm_no_destroy(kvm);
>  		mutex_lock(&kvm->lock);
>  		list_del(&dev->vm_node);
>  		mutex_unlock(&kvm->lock);
> 

Queued, thanks.

Paolo
