Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F319918E3EF
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 20:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgCUTWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 15:22:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:12555 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbgCUTWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 15:22:12 -0400
IronPort-SDR: e+ChXGDpA1IZeCpQ2VQHW5Rh7z/AdkhAwsz7gfb3OaExjlJ20UwHOfVBtCz2RZ16Mym6iR/o1n
 oyJLJ48jIoYw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 12:22:12 -0700
IronPort-SDR: 1ttO8Z2Ex+gtmDa7auMx+hMHFIl5rqjxJJfevaQ+xyAwTzjW0chX2llwSX+7R+kG/+t5Ml1dfT
 JLH1icf/5yjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="419065127"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 21 Mar 2020 12:22:12 -0700
Date:   Sat, 21 Mar 2020 12:22:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200321192211.GC13851@linux.intel.com>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318163720.93929-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 12:37:09PM -0400, Peter Xu wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e54c6ad628a8..a5123a0aa7d6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9786,7 +9786,34 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  	kvm_free_pit(kvm);
>  }
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> +
> +/**
> + * __x86_set_memory_region: Setup KVM internal memory slot
> + *
> + * @kvm: the kvm pointer to the VM.
> + * @id: the slot ID to setup.
> + * @gpa: the GPA to install the slot (unused when @size == 0).
> + * @size: the size of the slot. Set to zero to uninstall a slot.
> + *
> + * This function helps to setup a KVM internal memory slot.  Specify
> + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> + * slot.  The return code can be one of the following:
> + *
> + *   HVA:           on success (uninstall will return a bogus HVA)
> + *   -errno:        on error
> + *
> + * The caller should always use IS_ERR() to check the return value
> + * before use.  NOTE: KVM internal memory slots are guaranteed and

"are guaranteed" to ...

> + * won't change until the VM is destroyed. This is also true to the
> + * returned HVA when installing a new memory slot.  The HVA can be
> + * invalidated by either an errornous userspace program or a VM under
> + * destruction, however as long as we use __copy_{to|from}_user()
> + * properly upon the HVAs and handle the failure paths always then
> + * we're safe.

Regarding the HVA, it's a bit confusing saying that it's guaranteed to be
valid, and then contradicting that in the second clause.  Maybe something
like this to explain the GPA->HVA is guaranteed to be valid, but the
HVA->HPA is not.
 
/*
 * before use.  Note, KVM internal memory slots are guaranteed to remain valid
 * and unchanged until the VM is destroyed, i.e. the GPA->HVA translation will
 * not change.  However, the HVA is a user address, i.e. its accessibility is
 * not guaranteed, and must be accessed via __copy_{to,from}_user().
 */
