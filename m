Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188FF1459F0
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 17:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgAVQcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 11:32:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31501 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725911AbgAVQcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 11:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579710735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJapYNAcxbRlzEJ21pZkklZIrAl5YRRL98gWAs4LZrQ=;
        b=VXr+eDpGmwyRqnX43lp8qEcSMjSgjKqMXBIrHwKIMjZDc9m1Zzl/TiaqEAXTsuqCmQrEbw
        KVBfHr9JcpHiFYZllCCWNBdn3MJY4Wlp4MPX7dM/U5nYiet6xEnIof7gL7Q2HhYOT3js1w
        1zP2AD6orZ27ibjhMiXSNFiiIRqX2KE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-eO0IjofBM_eqPI7Ywqitaw-1; Wed, 22 Jan 2020 11:32:11 -0500
X-MC-Unique: eO0IjofBM_eqPI7Ywqitaw-1
Received: by mail-wr1-f71.google.com with SMTP id k18so63599wrw.9
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 08:32:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pJapYNAcxbRlzEJ21pZkklZIrAl5YRRL98gWAs4LZrQ=;
        b=mQfHacS3phm6r1ef/qq6V+S0blSF1y77LTIse7INB/xXdwwjjx6bgRF4tHuelNcw4A
         PcjU63suChI5m8qLCWWGVwzyUExvposcWTwcj1tHU/WmnnHmH0NK0l3MN+2RSaJIp+vM
         A+Vx4eSFDToBMStv3dP9gWc+peSbtvLKfH6A/2GiEtAhvCa04P0ivPcPiSWjffxFxz83
         nYgFwOw76YnPgPYV3XRZ46nlZb/s64FHzvNh+lSAg+AzWB7dR5QPKSRtgtg9GaulFOUd
         bNF/LD/y4SwEMPpHYvPMfAipIenPl22k1vXPlcQljAM76GIAAHcs2b9Q415Tw4tdZ1R/
         6z7A==
X-Gm-Message-State: APjAAAVkXJ4c3bp3Ymnv2GOb/U/davlx2QArjzDOokOosjKjRGgSZ2YM
        48ncsR9DSYP5LvlGDQJuRN85ySFA0QhFiD4VMTNXIERH0XvkGBEYD/E0ED2j3PGIuB2kHpCgloz
        kdK/2Ttzz22ub
X-Received: by 2002:a05:600c:244:: with SMTP id 4mr3995325wmj.40.1579710730412;
        Wed, 22 Jan 2020 08:32:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqzl1j5jQgSqqV247GTkvpdF8xkuaCliY5K+4X+O4msjIFvEkPbiQAFHkSHJ1V2Z9iwMwQwQow==
X-Received: by 2002:a05:600c:244:: with SMTP id 4mr3995297wmj.40.1579710730026;
        Wed, 22 Jan 2020 08:32:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id k16sm60390183wru.0.2020.01.22.08.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 08:32:09 -0800 (PST)
Subject: Re: [PATCH v5 13/18] svm: Temporary deactivate AVIC during ExtINT
 handling
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        KVM list <kvm@vger.kernel.org>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1573762520-80328-14-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ec0d2d77-6c74-3c6e-5157-bc6b73a0b4bd@redhat.com>
Date:   Wed, 22 Jan 2020 17:32:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1573762520-80328-14-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 21:15, Suravee Suthikulpanit wrote:
> +	if (svm_get_enable_apicv(svm->vcpu.kvm))
> +		svm_request_update_avic(&svm->vcpu, true);

> +		if (kvm_vcpu_apicv_active(vcpu))
> +			svm_request_update_avic(vcpu, false);

In both cases, "if (avic)" is the right condition to test to ensure that 
the bit is kept in sync with whether we are or not in the interrupt 
window.  kvm_request_apicv_update will check whether APICv is already 
active or not.

In fact, the condition can be moved to svm_request_update_avic.  Putting
everything together, we get:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 375352d08545..7c316c4716f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -878,6 +878,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
 #define APICV_INHIBIT_REASON_NESTED     2
+#define APICV_INHIBIT_REASON_IRQWIN     3
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index af90f83d7123..6d300c16d756 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -387,6 +387,7 @@ struct amd_svm_iommu_ir {
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
 static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
@@ -4461,6 +4462,14 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 {
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	svm_clear_vintr(svm);
+
+	/*
+	 * For AVIC, the only reason to end up here is ExtINTs.
+	 * In this case AVIC was temporarily disabled for
+	 * requesting the IRQ window and we have to re-enable it.
+	 */
+	svm_toggle_avic_for_irq_window(&svm->vcpu, true);
+
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	mark_dirty(svm->vmcb, VMCB_INTR);
 	++svm->vcpu.stat.irq_window_exits;
@@ -5164,6 +5173,17 @@ static void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 }
 
+static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
+{
+	if (!avic || !lapic_in_kernel(vcpu))
+		return;
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_request_apicv_update(vcpu->kvm, activate,
+				 APICV_INHIBIT_REASON_IRQWIN);
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+}
+
 static int svm_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
@@ -5504,9 +5524,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
 	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
@@ -5516,6 +5533,13 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	 * window under the assumption that the hardware will set the GIF.
 	 */
 	if ((vgif_enabled(svm) || gif_set(svm)) && nested_svm_intr(svm)) {
+		/*
+		 * IRQ window is not needed when AVIC is enabled,
+		 * unless we have pending ExtINT since it cannot be injected
+		 * via AVIC. In such case, we need to temporarily disable AVIC,
+		 * and fallback to injecting IRQ via V_IRQ.
+		 */
+		svm_toggle_avic_for_irq_window(vcpu, false);
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
@@ -7328,7 +7352,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 {
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_NESTED);
+			  BIT(APICV_INHIBIT_REASON_NESTED) |
+			  BIT(APICV_INHIBIT_REASON_IRQWIN);
 
 	return supported & BIT(bit);
 }

