Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A7E92179
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 12:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfHSKgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 06:36:14 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49384 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfHSKgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 06:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566210972; x=1597746972;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Bfj+goveoEs32SLe7Qst3dXZt6qRhq7vby8Cj53EIrc=;
  b=XleG4ff7I7apibBux6xMR0lHEVPCputIAJvKl/fHT0w5MDlEmA0pPvXn
   Nwx3fh7wzryrv8bPDqkTLJQrlidOPNKv74TpHgGqBey56KyoxFRJi7z10
   VbyBRXifmhfcx0K/EtjXxf9oe5HVnoEao3nyjIZ6kO9A3tTJ/JG0GTwyc
   Q=;
X-IronPort-AV: E=Sophos;i="5.64,403,1559520000"; 
   d="scan'208";a="779890305"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Aug 2019 10:36:06 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id E4030A1F99;
        Mon, 19 Aug 2019 10:36:04 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:36:04 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.244) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 19 Aug 2019 10:36:01 +0000
Subject: Re: [PATCH v2 11/15] svm: Temporary deactivate AVIC during ExtINT
 handling
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1565886293-115836-12-git-send-email-suravee.suthikulpanit@amd.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <1ed5bf9c-177e-b41c-b5ac-4c76155ead2a@amazon.com>
Date:   Mon, 19 Aug 2019 12:35:59 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565886293-115836-12-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D15UWA003.ant.amazon.com (10.43.160.182) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15.08.19 18:25, Suthikulpanit, Suravee wrote:
> AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
> deactivated and fall back to using legacy interrupt injection via vINTR
> and interrupt window.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm.c | 49 +++++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index cfa4b13..4690351 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -384,6 +384,7 @@ struct amd_svm_iommu_ir {
>   static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
>   static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
>   static void svm_complete_interrupts(struct vcpu_svm *svm);
> +static void svm_request_activate_avic(struct kvm_vcpu *vcpu);
>   static bool svm_get_enable_apicv(struct kvm *kvm);
>   static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
>   
> @@ -4494,6 +4495,15 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>   {
>   	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>   	svm_clear_vintr(svm);
> +
> +	/*
> +	 * For AVIC, the only reason to end up here is ExtINTs.
> +	 * In this case AVIC was temporarily disabled for
> +	 * requesting the IRQ window and we have to re-enable it.
> +	 */
> +	if (svm_get_enable_apicv(svm->vcpu.kvm))
> +		svm_request_activate_avic(&svm->vcpu);

Would it make sense to add a trace point here and to the other call 
sites, so that it becomes obvious in a trace when and why exactly avic 
was active/inactive?

The trace point could add additional information on the why.

> +
>   	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
>   	mark_dirty(svm->vmcb, VMCB_INTR);
>   	++svm->vcpu.stat.irq_window_exits;
> @@ -5181,7 +5191,33 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>   {
>   }
>   
> -/* Note: Currently only used by Hyper-V. */
> +static bool is_avic_active(struct vcpu_svm *svm)
> +{
> +	return (svm_get_enable_apicv(svm->vcpu.kvm) &&
> +		svm->vmcb->control.int_ctl & AVIC_ENABLE_MASK);
> +}
> +
> +static void svm_request_activate_avic(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || is_avic_active(svm))
> +		return;
> +
> +	kvm_make_apicv_activate_request(vcpu);
> +}
> +
> +static void svm_request_deactivate_avic(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || !is_avic_active(svm))
> +		return;
> +
> +	/* Request temporary deactivate apicv */
> +	kvm_make_apicv_deactivate_request(vcpu, false);
> +}
> +
>   static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -5522,9 +5558,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> -	if (kvm_vcpu_apicv_active(vcpu))
> -		return;
> -
>   	/*
>   	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
>   	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
> @@ -5534,6 +5567,14 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
>   	 * window under the assumption that the hardware will set the GIF.
>   	 */
>   	if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
> +		/*
> +		 * IRQ window is not needed when AVIC is enabled,
> +		 * unless we have pending ExtINT since it cannot be injected
> +		 * via AVIC. In such case, we need to temporarily disable AVIC,
> +		 * and fallback to injecting IRQ via V_IRQ.
> +		 */
> +		if (kvm_vcpu_apicv_active(vcpu))
> +			svm_request_deactivate_avic(&svm->vcpu);

Did you test AVIC with nesting? Did you actually run across this issue 
there?


Alex

>   		svm_set_vintr(svm);
>   		svm_inject_irq(svm, 0x0);
>   	}
> 
