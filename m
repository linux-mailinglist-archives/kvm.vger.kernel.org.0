Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024DD1B24E8
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgDULUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbgDULUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 07:20:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F4CC061A0F;
        Tue, 21 Apr 2020 04:20:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f20so387851pgl.12;
        Tue, 21 Apr 2020 04:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IJ6JZkiPYFKr9qoqt6fhwkwymZZp1I817zsI085cYIo=;
        b=ECVEWbexBcseymDuaNtzAX8DRgj4x6F5lrLy31bXwdmQ9Brgohq3AWboZMbe5FLtq0
         21Z/i34UeIffbCfSEGwJ/pbCe8Id9ptcVngWM1patsbr5cFKh2HLHpf5Yx9oy0BeA82b
         NbW3Tkk3IIfcZaD/0nrEANyb7s2R+fgaduJDnfkWunplVVfVWHe34VXp2Cr942yKMOqT
         OV0N7gqXKj3I6ROqa1xRf7tlZITQ6tWRPRczo8ncKRlMlDMMZepSsNB+WhbXIs1/5fKe
         lZ/R7/4yESf+59jDTH/XK8AU3yp0lr5K6rv89zKJnJPD/gZG8hB0UssblhJ/XVmZLLp0
         Q0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IJ6JZkiPYFKr9qoqt6fhwkwymZZp1I817zsI085cYIo=;
        b=E5UypdE0t3WnySIsQEIlak9H8y1f4QNIYdM/47VdiKGhHD3AR0PTjhuR6eBfo4FzXf
         6h1CQgfJoDcGos3SGt43XdCW1Va7EUcyFBiPWrFH11KU/hu7pKzFRKKvu/Ii6i+0tqNP
         mpv8HQBHSpdXAUvInL8n6OOwoFaAFDd0F7P+h1Ui3nL6X+9Fw0wL9+wU+IWNfz3Bbz0/
         I4oUxfxzRlcjZyOBa/7orXqitEXxk5YI1pV/vqGgHSEGQ68vLpBEpSEMBnXSPorjwh86
         KWD8J4UxxouHK0/95NLCkL7cytvnFRJ7yI86YW4NuUHo2Avbmbr6x39SLl0ZrKCBMCWF
         e2Pg==
X-Gm-Message-State: AGi0PuZoiZnHq9guh0W/5yeJ741sz+7tyu1IYkI5r0YR8OxXTQRUocBK
        q28bsT4BI7SwHgexCex5bR5pu/w7
X-Google-Smtp-Source: APiQypJY/VtK1rmXpeHsVWCjecFmk7L3oIOZ00v+D8RA2f62M4iRTOqukizWko3q6VDuP6l782PPOQ==
X-Received: by 2002:a65:49cf:: with SMTP id t15mr21026486pgs.39.1587468041852;
        Tue, 21 Apr 2020 04:20:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f74sm8643176pje.3.2020.04.21.04.20.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 04:20:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH 2/2] KVM: VMX: Handle preemption timer fastpath
Date:   Tue, 21 Apr 2020 19:20:26 +0800
Message-Id: <1587468026-15753-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
References: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch implements handle preemption timer fastpath, after timer fire 
due to VMX-preemption timer counts down to zero, handle it as soon as 
possible and vmentry immediately without checking various kvm stuff when 
possible.

Testing on SKX Server.

cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):

5632.75ns -> 4559.25ns, 19%

kvm-unit-test/vmexit.flat:

w/o APICv, w/o advance timer:
tscdeadline_immed: 4780.75 -> 3851    19.4%
tscdeadline:       7474    -> 6528.5  12.7%

w/o APICv, w/ adaptive advance timer default -1:
tscdeadline_immed: 4845.75 -> 3930.5  18.9%
tscdeadline:       6048    -> 5871.75    3%

w/ APICv, w/o avanced timer:
tscdeadline_immed: 2919    -> 2467.75 15.5%
tscdeadline:       5661.75 -> 5188.25  8.4%

w/ APICv, w/ adaptive advance timer default -1:
tscdeadline_immed: 3018.5  -> 2561    15.2%
tscdeadline:       4663.75 -> 4626.5     1%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7688e40..623c4a0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6593,12 +6593,53 @@ static void vmx_fast_deliver_interrupt(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
+
+static enum exit_fastpath_completion handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+
+	if (vmx_event_needs_reinjection(vcpu))
+		return EXIT_FASTPATH_NONE;
+
+	if (!vmx->req_immediate_exit &&
+		!unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
+		if (!vmx_interrupt_allowed(vcpu) ||
+			!apic_lvtt_tscdeadline(apic) ||
+			vmx->rmode.vm86_active ||
+			is_smm(vcpu) ||
+			!kvm_apic_hw_enabled(apic))
+			return EXIT_FASTPATH_NONE;
+
+		if (!apic->lapic_timer.hv_timer_in_use)
+			return EXIT_FASTPATH_CONT_RUN;
+
+		WARN_ON(swait_active(&vcpu->wq));
+		vmx_cancel_hv_timer(vcpu);
+		apic->lapic_timer.hv_timer_in_use = false;
+
+		if (atomic_read(&apic->lapic_timer.pending))
+			return EXIT_FASTPATH_CONT_RUN;
+
+		ktimer->expired_tscdeadline = ktimer->tscdeadline;
+		vmx_fast_deliver_interrupt(vcpu);
+		ktimer->tscdeadline = 0;
+		return EXIT_FASTPATH_CONT_RUN;
+	}
+
+	return EXIT_FASTPATH_NONE;
+}
+
 static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (!is_guest_mode(vcpu)) {
 		switch(to_vmx(vcpu)->exit_reason) {
 		case EXIT_REASON_MSR_WRITE:
 			return handle_fastpath_set_msr_irqoff(vcpu);
+		case EXIT_REASON_PREEMPTION_TIMER:
+			return handle_fastpath_preemption_timer(vcpu);
 		default:
 			return EXIT_FASTPATH_NONE;
 		}
-- 
2.7.4

