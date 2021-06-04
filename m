Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399FD39BEB4
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhFDR3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:21 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:43663 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFDR3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:21 -0400
Received: by mail-pj1-f74.google.com with SMTP id lb16-20020a17090b4a50b029016c399441a6so1563687pjb.8
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Afz60ODUyVuGs6cT0xPAEAAlQEDiab7pQP9o9bn171c=;
        b=jq5pmzzHyboRqtjbcyihIJHwv4HNkLGLSm7x4ZNim1ITmtsR/zk8TVwMESJzhd+a/3
         mSXx1kxdIsA/wPeSW3mSK3+H88LlvGF03mxu0gk5/8vocy0jf43XWZz/khsisiiOb8HO
         qTq5RgcflORARQv5qJFKtArGFOZt6RJ1vkwsoDrymbkC1FM+IXpCZM0KzhPBfKmfn620
         +b5Vns+m8VUwE2CuM/qIAJ3hTfsC68MbTdeWdW2o4JgNrOD+dahd3O9n2DdFZmoXyoTQ
         jh0rxtKOzbeDSMtEi67CjscRoYL4QtHbmpfDH2NgC671jrtzEwLuWM8e+pQwZDx3XeUQ
         P9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Afz60ODUyVuGs6cT0xPAEAAlQEDiab7pQP9o9bn171c=;
        b=eJi5UP/MHKn3p5Lq7DsuNlIMrTqSizwuF7pPjbhGR2RC3Mp7wIOux94Nem5OfPU5Yw
         /hI6c+UhBNLVjF7a+ETT/hSczv5wParCZyZS8+x2aFSnD4va4pVDTJ9CtWMZByLTIkbu
         63+BfXqtc53Q4pIdCeZWe3yUptLQDRJRdpWCJF6iqN+QUvfZRqjie7WseDW+JYYa3iSG
         xjc5Ka+XE898OBhFCtfRddLOB+tjMM4iVJVkG/SBbe3uR6+ZUnBuyP7WRlIrO2CESL4/
         RE0zTYe3KPUhsPdbAAtTMnQRJ8FnocvPC/9RsDFWjW8oxqZsFFUHtjPlbezvws97ugnG
         Ijhg==
X-Gm-Message-State: AOAM532pHBfYn7LQOrilwdIGntrhWL27VS/w0XhimJ7ZINQ8Ms1HEsTb
        NRDxGf19lEpMuN9+5m1Tapin7V1uo2pEDJVq+n3sxKs+BBHg4NnOQ4tJOgbr3LH1MRFkZ3H3gB1
        eLXB5xraQqpSSu0NDvovQ1U5W+b9W5AMTQnW4tovbj84FVJ8SpjO7XyniDDYe6rw=
X-Google-Smtp-Source: ABdhPJzourejcuLTj7/DSLVmJKeiPgsSnrAOzh2u8MRhD23sv23J9NsnKoiJTSLy7jW4sSqJQxYOQI5l3beHWg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:3b41:: with SMTP id
 ot1mr1545544pjb.1.1622827594107; Fri, 04 Jun 2021 10:26:34 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:03 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-5-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 04/12] KVM: x86: Add a return code to inject_pending_event
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended. At present, 'r' will always be -EBUSY
on a control transfer to the 'out' label.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83bc0a5b1aab..f9b3ea916344 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8550,7 +8550,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 	static_call(kvm_x86_queue_exception)(vcpu);
 }
 
-static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
+static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
 	bool can_inject = true;
@@ -8597,7 +8597,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (is_guest_mode(vcpu)) {
 		r = kvm_check_nested_events(vcpu);
 		if (r < 0)
-			goto busy;
+			goto out;
 	}
 
 	/* try to inject new event if pending */
@@ -8639,7 +8639,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (vcpu->arch.smi_pending) {
 		r = can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
-			goto busy;
+			goto out;
 		if (r) {
 			vcpu->arch.smi_pending = false;
 			++vcpu->arch.smi_count;
@@ -8652,7 +8652,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (vcpu->arch.nmi_pending) {
 		r = can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
-			goto busy;
+			goto out;
 		if (r) {
 			--vcpu->arch.nmi_pending;
 			vcpu->arch.nmi_injected = true;
@@ -8667,7 +8667,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	if (kvm_cpu_has_injectable_intr(vcpu)) {
 		r = can_inject ? static_call(kvm_x86_interrupt_allowed)(vcpu, true) : -EBUSY;
 		if (r < 0)
-			goto busy;
+			goto out;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
 			static_call(kvm_x86_set_irq)(vcpu);
@@ -8683,11 +8683,14 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 		*req_immediate_exit = true;
 
 	WARN_ON(vcpu->arch.exception.pending);
-	return;
+	return 0;
 
-busy:
-	*req_immediate_exit = true;
-	return;
+out:
+	if (r == -EBUSY) {
+		*req_immediate_exit = true;
+		r = 0;
+	}
+	return r;
 }
 
 static void process_nmi(struct kvm_vcpu *vcpu)
@@ -9248,7 +9251,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		inject_pending_event(vcpu, &req_immediate_exit);
+		r = inject_pending_event(vcpu, &req_immediate_exit);
+		if (r < 0) {
+			r = 0;
+			goto out;
+		}
 		if (req_int_win)
 			static_call(kvm_x86_enable_irq_window)(vcpu);
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

