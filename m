Return-Path: <kvm+bounces-4418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 577E0812574
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0D941F219BD
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198B32106;
	Thu, 14 Dec 2023 02:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="E28tJ5RP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF5210B
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:39 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-425a2b4df7bso45273131cf.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522059; x=1703126859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTSAC8lorgQBroJi8wDtWTizY3Sq3NA2keDTcoNJeiU=;
        b=E28tJ5RP/YYloN5KYrVjjeROKlG/JunnuwxD6Il3I6T6YvRmpMq51N9KkkNBmNswzN
         wTmyjgWlSLk5HVBQshysM6JawkK8RDuhLi9in9RTT+YpePoVUerXU/4W58tKoxhAWrSh
         qXuFLVoVX79+Tyosr4QjXE1foejYZUjFxO/MIiOb02ccBOeZx/lkHZ3hkpn1wh932Fpi
         dvWa5tnyRQgnfZNel+URgPB05B5NbQ1oKEidcdVJWJBwmkxfuT0jwhF7FaMexfMSjX/F
         xlcOualUpnQUzK6XxMsS6Rbbb5+tMMEw9KzlPGpibeatp++uGyQghnczU1h9wIzyZgTB
         8Pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522059; x=1703126859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTSAC8lorgQBroJi8wDtWTizY3Sq3NA2keDTcoNJeiU=;
        b=FofifLVJNwrR3PL3hdLdeVjQ6mMw9jI33K+2OZDxFuU/gRlRfaixGcvvUcnrEYrz1j
         B0EpEV2/VMxdd0K5wNyAYbFV8VB0PapA0wj4KW4BwNmV5rg5j9hnR88r0aRw0Y4HrHIQ
         TLVoMxhshEOnF3d+JOFsmr1JO2eiUuubMEaYoEr8SN0jX1coL/ycoMi6MRH9rZ+V2Vsx
         rMdZNVIkP+Sr5ZzX0rnTdmZA02e+hLaVIxKWXkCWjQR5Je7CBfaHNM0KfWTdWV4mVx0m
         SScwMPiE6h+SiKsRiU5dDXQS6VnayfrqFFTze3KN2RPtbfn4ylzlvlb7KeqHDCEVAPwC
         xQjg==
X-Gm-Message-State: AOJu0YyuouQaJmGEEZ43LWnKEFyCREKgRYQmFCY9OwJ4tv99WrqvPI9y
	JPPBEq/S612E3UkFwRMp192UtA==
X-Google-Smtp-Source: AGHT+IFCknomeNY7bK13m6X0xaXsU9OorF5sm50ko/Fs0P9mA9ckrWT4Qq2LVghLRhWQezBZWpVAAQ==
X-Received: by 2002:ac8:5d4c:0:b0:423:7d72:6c8 with SMTP id g12-20020ac85d4c000000b004237d7206c8mr14420946qtx.53.1702522058661;
        Wed, 13 Dec 2023 18:47:38 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:38 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 4/8] kvm: x86: boost vcpu threads on latency sensitive paths
Date: Wed, 13 Dec 2023 21:47:21 -0500
Message-ID: <20231214024727.3503870-5-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Proactively boost the vcpu thread when delivering an interrupt so
that the guest vcpu gets to run with minimum latency and service the
interrupt. The host knows that guest vcpu is going to service an irq/nmi
as soon as its delivered and boosting the priority will help the guest
to avoid latencies. Timer interrupt is one common scenario which
benefits from this.

When a vcpu resumes from halt, it would be because of an event like
timer or irq/nmi and is latency sensitive. So, boosting the priority
of vcpu thread when it goes idle makes sense as the wakeup would be
because of a latency sensitive event and this boosting will not hurt
the host as the thread is scheduled out.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 arch/x86/kvm/i8259.c     | 2 +-
 arch/x86/kvm/lapic.c     | 8 ++++----
 arch/x86/kvm/svm/svm.c   | 2 +-
 arch/x86/kvm/vmx/vmx.c   | 2 +-
 include/linux/kvm_host.h | 8 ++++++++
 virt/kvm/kvm_main.c      | 8 ++++++++
 6 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 8dec646e764b..6841ed802f00 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -62,7 +62,7 @@ static void pic_unlock(struct kvm_pic *s)
 		kvm_for_each_vcpu(i, vcpu, s->kvm) {
 			if (kvm_apic_accept_pic_intr(vcpu)) {
 				kvm_make_request(KVM_REQ_EVENT, vcpu);
-				kvm_vcpu_kick(vcpu);
+				kvm_vcpu_kick_boost(vcpu);
 				return;
 			}
 		}
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e74e223f46aa..ae25176fddc8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1309,12 +1309,12 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		result = 1;
 		vcpu->arch.pv.pv_unhalted = 1;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_kick_boost(vcpu);
 		break;
 
 	case APIC_DM_SMI:
 		if (!kvm_inject_smi(vcpu)) {
-			kvm_vcpu_kick(vcpu);
+			kvm_vcpu_kick_boost(vcpu);
 			result = 1;
 		}
 		break;
@@ -1322,7 +1322,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_NMI:
 		result = 1;
 		kvm_inject_nmi(vcpu);
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_kick_boost(vcpu);
 		break;
 
 	case APIC_DM_INIT:
@@ -1901,7 +1901,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 	if (from_timer_fn)
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_kick_boost(vcpu);
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c8466bc64b87..578c19aeef73 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3566,7 +3566,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 	if (!READ_ONCE(vcpu->arch.apic->apicv_active)) {
 		/* Process the interrupt via kvm_check_and_inject_events(). */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_kick_boost(vcpu);
 		return;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bc6f0fea48b4..b786cb2eb185 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4266,7 +4266,7 @@ static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	if (vmx_deliver_posted_interrupt(vcpu, vector)) {
 		kvm_lapic_set_irr(vector, apic);
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		kvm_vcpu_kick(vcpu);
+		kvm_vcpu_kick_boost(vcpu);
 	} else {
 		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
 					   trig_mode, vector);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c6647f6312c9..f76680fbc60d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2296,11 +2296,19 @@ static inline bool kvm_vcpu_sched_enabled(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_vcpu_pv_sched_enabled(&vcpu->arch);
 }
+
+static inline void kvm_vcpu_kick_boost(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_set_sched(vcpu, true);
+	kvm_vcpu_kick(vcpu);
+}
 #else
 static inline int kvm_vcpu_set_sched(struct kvm_vcpu *vcpu, bool boost)
 {
 	return 0;
 }
+
+#define kvm_vcpu_kick_boost kvm_vcpu_kick
 #endif
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 37748e2512e1..0dd8b84ed073 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3460,6 +3460,14 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_check_block(vcpu) < 0)
 			break;
 
+		/*
+		 * Boost before scheduling out. Wakeup happens only on
+		 * an event or a signal and hence it is beneficial to
+		 * be scheduled ASAP. Ultimately, guest gets to idle loop
+		 * and then will request deboost.
+		 */
+		kvm_vcpu_set_sched(vcpu, true);
+
 		waited = true;
 		schedule();
 	}
-- 
2.43.0


