Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9B17F31
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfEHRhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:37:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:26513 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfEHRhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557337064; x=1588873064;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=c+DsD3oynd4fX57jTN4iPQjcJlLMooBB9yQT0Hkij+o=;
  b=esJHFNYYaGD4ZmX1qziavbncoWZoLl6hrcL8E602RzFk11jPhWwL1hEz
   rnIHuw1X9CmX4J8g8Uqr+Zm6aKnMobOE37EhoCVi/5M3eYh/b3wv/hT9v
   nxLlUPUzD6X0178BiMl2RFQ1+/du6jsRQ0NMYzFidAnrtk0rQuVZb9CmM
   o=;
X-IronPort-AV: E=Sophos;i="5.60,446,1549929600"; 
   d="scan'208";a="765292474"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 08 May 2019 17:37:42 +0000
Received: from u7588a65da6b65f.ant.amazon.com (iad7-ws-svc-lb50-vlan3.amazon.com [10.0.93.214])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x48Hbbcn050748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 8 May 2019 17:37:39 GMT
Received: from u7588a65da6b65f.ant.amazon.com (localhost [127.0.0.1])
        by u7588a65da6b65f.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x48Hba7l030610;
        Wed, 8 May 2019 19:37:36 +0200
Subject: Re: [PATCH 6/6] svm: Temporary deactivate AVIC during ExtINT handling
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-7-suravee.suthikulpanit@amd.com>
From:   =?UTF-8?Q?Jan_H=2e_Sch=c3=b6nherr?= <jschoenh@amazon.de>
Openpgp: preference=signencrypt
Message-ID: <a31f3f85-d94c-b139-ec69-d148dae5c67f@amazon.de>
Date:   Wed, 8 May 2019 19:37:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190322115702.10166-7-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suravee.

I wonder, how this interacts with Hyper-V SynIC; see comments below.

On 22/03/2019 12.57, Suthikulpanit, Suravee wrote:
> AMD AVIC does not support ExtINT. Therefore, AVIC must be temporary
> deactivated and fall back to using legacy interrupt injection via
> vINTR and interrupt window.
> 
> Introduce svm_request_activate/deactivate_avic() helper functions,
> which handle steps required to activate/deactivate AVIC.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm.c | 57 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f41f34f70dde..84116e689d5f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -391,6 +391,8 @@ static u8 rsm_ins_bytes[] = "\x0f\xaa";
>  static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
>  static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
>  static void svm_complete_interrupts(struct vcpu_svm *svm);
> +static void svm_request_activate_avic(struct kvm_vcpu *vcpu);
> +static bool svm_get_enable_apicv(struct kvm_vcpu *vcpu);
>  
>  static int nested_svm_exit_handled(struct vcpu_svm *svm);
>  static int nested_svm_intercept(struct vcpu_svm *svm);
> @@ -2109,6 +2111,9 @@ static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return;
> +
>  	svm->avic_is_running = is_run;
>  	if (is_run)
>  		avic_vcpu_load(vcpu, vcpu->cpu);
> @@ -2356,6 +2361,10 @@ static void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
>  
>  static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
> +	if (kvm_check_request(KVM_REQ_APICV_ACTIVATE, vcpu))
> +		kvm_vcpu_activate_apicv(vcpu);
> +	if (kvm_check_request(KVM_REQ_APICV_DEACTIVATE, vcpu))
> +		kvm_vcpu_deactivate_apicv(vcpu);
>  	avic_set_running(vcpu, true);
>  }
>  
> @@ -4505,6 +4514,15 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>  {
>  	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>  	svm_clear_vintr(svm);
> +
> +	/*
> +	 * For AVIC, the only reason to end up here is ExtINTs.
> +	 * In this case AVIC was temporarily disabled for
> +	 * requesting the IRQ window and we have to re-enable it.
> +	 */
> +	if (svm_get_enable_apicv(&svm->vcpu))
> +		svm_request_activate_avic(&svm->vcpu);
> +

Are we sure, we're not accidentally re-enabling AVIC, if it was disabled via
kvm_hv_activate_synic()?


>  	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
>  	mark_dirty(svm->vmcb, VMCB_INTR);
>  	++svm->vcpu.stat.irq_window_exits;
> @@ -5206,6 +5224,34 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>  {
>  }
>  
> +static bool is_avic_active(struct vcpu_svm *svm)
> +{
> +	return (svm_get_enable_apicv(&svm->vcpu) &&
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
> +	avic_setup_access_page(vcpu, false);
> +	kvm_make_apicv_activate_request(vcpu->kvm);
> +}
> +
> +static void svm_request_deactivate_avic(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || !is_avic_active(svm))
> +		return;
> +
> +	avic_destroy_access_page(vcpu);

Something like avic_destroy_access_page() is not called, when AVIC is
disabled via kvm_hv_activate_synic().

Is that an oversight in the other code path, is it not needed here,
or am I missing something?


> +	kvm_make_apicv_deactivate_request(vcpu->kvm);
> +}
> +
>  /* Note: Currently only used by Hyper-V. */

nit: This comment should probably go away, now.

Regards
Jan


>  static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  {
> @@ -5493,9 +5539,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if (kvm_vcpu_apicv_active(vcpu))
> -		return;
> -
>  	/*
>  	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
>  	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
> @@ -5505,6 +5548,14 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
>  	 * window under the assumption that the hardware will set the GIF.
>  	 */
>  	if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
> +		/*
> +		 * IRQ window is not needed when AVIC is enabled,
> +		 * unless we have pending ExtINT since it cannot be injected
> +		 * via AVIC. In such case, we need to temporarily disable AVIC,
> +		 * and fallback to injecting IRQ via V_IRQ.
> +		 */
> +		if (kvm_vcpu_apicv_active(vcpu))
> +			svm_request_deactivate_avic(&svm->vcpu);
>  		svm_set_vintr(svm);
>  		svm_inject_irq(svm, 0x0);
>  	}
> 

