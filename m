Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60679407E3C
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 17:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhILQAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 12:00:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235852AbhILQAn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 12:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631462368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIz1j32cEU4UBvdCYECfO6tqdzMXyCcE0af4yJCjxKU=;
        b=NaJBkAPUc/7jyb+BfMkJCJuKTLZgdTvrLEUloHwSNjPUGAM6QPDGrB9LrI5/0Yy8GYPBP1
        44UXgJcO7Ot5xuwCtzMQd+glWuw9QnPhyb37AlwdHifrttXE5xIuzvKHcsF+OExTw4hYxM
        KEsPuDcvhyxaT2ZWGRX8et1E9RzM+Aw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-U3ByrgX4PzyX9lHqkewKHQ-1; Sun, 12 Sep 2021 11:59:25 -0400
X-MC-Unique: U3ByrgX4PzyX9lHqkewKHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 953AC1084683;
        Sun, 12 Sep 2021 15:59:24 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C3985D9D3;
        Sun, 12 Sep 2021 15:59:18 +0000 (UTC)
Message-ID: <37efb41fda41317bf04c0cb805792af261894a1a.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: nVMX: Track whether changes in L0 require MSR
 bitmap for L2 to be rebuilt
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Sun, 12 Sep 2021 18:59:17 +0300
In-Reply-To: <20210910160633.451250-4-vkuznets@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
         <20210910160633.451250-4-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 18:06 +0200, Vitaly Kuznetsov wrote:
> Introduce a flag to keep track of whether MSR bitmap for L2 needs to be
> rebuilt due to changes in MSR bitmap for L1 or switching to a different
> L2. This information will be used for Enlightened MSR Bitmap feature for
> Hyper-V guests.
> 
> Note, setting msr_bitmap_changed to 'true' from set_current_vmptr() is
> not really needed for Enlightened MSR Bitmap as the feature can only
> be used in conjunction with Enlightened VMCS but let's keep tracking
> information complete, it's cheap and in the future similar PV feature can
> easily be implemented for KVM on KVM too.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 9 ++++++++-
>  arch/x86/kvm/vmx/vmx.c    | 2 ++
>  arch/x86/kvm/vmx/vmx.h    | 6 ++++++
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ccb03d69546c..42cd95611892 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2053,10 +2053,13 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  	 * Clean fields data can't be used on VMLAUNCH and when we switch
>  	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
>  	 */
> -	if (from_launch || evmcs_gpa_changed)
> +	if (from_launch || evmcs_gpa_changed) {
>  		vmx->nested.hv_evmcs->hv_clean_fields &=
>  			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  
> +		vmx->nested.msr_bitmap_changed = true;
> +	}
> +
>  	return EVMPTRLD_SUCCEEDED;
>  }
>  
> @@ -3240,6 +3243,8 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  	else
>  		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
>  
> +	vmx->nested.msr_bitmap_changed = false;

Very minor nitpick: Maybe I would put this into nested_vmx_prepare_msr_bitmap,
a bit closer to the action, but this is fine like this as well.

> +
>  	return true;
>  }
>  
> @@ -5273,6 +5278,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
>  	}
>  	vmx->nested.dirty_vmcs12 = true;
> +	vmx->nested.msr_bitmap_changed = true;
>  }
>  
>  /* Emulate the VMPTRLD instruction */
> @@ -6393,6 +6399,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		goto error_guest_mode;
>  
>  	vmx->nested.dirty_vmcs12 = true;
> +	vmx->nested.msr_bitmap_changed = true;

Is this needed? Setting the nested state should eventually trigger call to
nested_vmx_handle_enlightened_vmptrld.

 

>  	ret = nested_vmx_enter_non_root_mode(vcpu, false);
>  	if (ret)
>  		goto error_guest_mode;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ad33032e8588..2dbfb5d838db 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3734,6 +3734,8 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  	 */
>  	if (static_branch_unlikely(&enable_evmcs))
>  		evmcs_touch_msr_bitmap();
> +
> +	vmx->nested.msr_bitmap_changed = true;
>  }
>  
>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 4858c5fd95f2..b6596fc2943a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -148,6 +148,12 @@ struct nested_vmx {
>  	bool need_vmcs12_to_shadow_sync;
>  	bool dirty_vmcs12;
>  
> +	/*
> +	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
> +	 * changes in MSR bitmap for L1 or switching to a different L2.
> +	 */
> +	bool msr_bitmap_changed;
> +
>  	/*
>  	 * Indicates lazily loaded guest state has not yet been decached from
>  	 * vmcs02.


Best regards,
	Maxim Levitsky

