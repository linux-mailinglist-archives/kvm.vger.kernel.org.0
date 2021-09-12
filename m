Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB303407E34
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 17:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhILP74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 11:59:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234362AbhILP7z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 11:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631462320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0s/q0g+GZDm34hMz3jDp3wTZwL/80vFWdOcrszudbI=;
        b=RR7F7MlgTrhmSeX3SuokD3PY6MK7qaqAFkdjTYGs6s1IlEDVyPf9NbBPNB4UI12zDinqa3
        puwga4iFhI2h9v2BM0SbjQbyjdAKm/oaQ0M9ZnQ3969P3K7J0AcW9QAg4h/Wv4IWb+lzMU
        ro+rCYNRASV6IaJTFLjfrZ0bQy6ZW7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-GK24gwxlNj-kI2jiakzcqg-1; Sun, 12 Sep 2021 11:58:39 -0400
X-MC-Unique: GK24gwxlNj-kI2jiakzcqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 572501808300;
        Sun, 12 Sep 2021 15:58:38 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78B8110013C1;
        Sun, 12 Sep 2021 15:58:33 +0000 (UTC)
Message-ID: <891d961d8f25db09148ac939f0b688c94a1aa980.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed()
 helper
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Sun, 12 Sep 2021 18:58:33 +0300
In-Reply-To: <20210910160633.451250-3-vkuznets@redhat.com>
References: <20210910160633.451250-1-vkuznets@redhat.com>
         <20210910160633.451250-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 18:06 +0200, Vitaly Kuznetsov wrote:
> In preparation to enabling 'Enlightened MSR Bitmap' feature for Hyper-V
> guests move MSR bitmap update tracking to a dedicated helper.
> 
> Note: vmx_msr_bitmap_l01_changed() is called when MSR bitmap might be
> updated. KVM doesn't check if the bit we're trying to set is already set
> (or the bit it's trying to clear is already cleared). Such situations
> should not be common and a few false positives should not be a problem.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ae470afcb699..ad33032e8588 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3725,6 +3725,17 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
>  		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
>  }
>  
> +static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
> +{
> +	/*
> +	 * When KVM is a nested hypervisor on top of Hyper-V and uses
> +	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
> +	 * bitmap has changed.
> +	 */
> +	if (static_branch_unlikely(&enable_evmcs))
> +		evmcs_touch_msr_bitmap();
> +}
> +
>  void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3733,8 +3744,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
> -	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +	vmx_msr_bitmap_l01_changed(vmx);
>  
>  	/*
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
> @@ -3778,8 +3788,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
> -	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +	vmx_msr_bitmap_l01_changed(vmx);
>  
>  	/*
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



