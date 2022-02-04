Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330D44AA278
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243671AbiBDVm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243656AbiBDVmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:17 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F803C061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:16 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i16-20020aa78d90000000b004be3e88d746so3554461pfr.13
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=p3Z6O75re3IQ8juMy/+Hv5kJ3ZZM2tN3/sbXR6UdChM=;
        b=OqFSaHhg6jDceD8xwX61EkGcVN+NRXKuZkupxENrtfRyM1KBNs8CQvPYLv/to3hxix
         CcbUEwlLLx/+h6eP+od/HxKqfh8JdkLxi5zJD7/Lsimfu70I23kDblPXbKnXYZpOKNOY
         kidISSbBJwYjca7Z2m73W5LzdolscVGWmJ8yFV9pFNvML7A1MOX7PtS/7Pp7QJ3opOIx
         Qks7nQDvZ9B/VCWAMzWihEy7YofJhUG3xacaMcuVX95hNisW9onhz7KxRW4bDtx120Ng
         KwCJ5s4FTi8uVdUnKsYj+ZhPyQrKgHCGBf9ko1iMeN272cbkTNOPYaJ2dcz5ZvDbj58o
         6nPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=p3Z6O75re3IQ8juMy/+Hv5kJ3ZZM2tN3/sbXR6UdChM=;
        b=xS8OtALzSJ5ljsfcRcS+C3fMskAACW20IF3C0QsXi0W/CjPj5RdWu7iB/aB2cgi7bD
         rNoVvA0ap8jE99r5Kp8C9NPEqg6bhPv3rhA3yZXp2wZNrF6VS2lmywlbNmn1JKZE+AEi
         qlhMMhGjYifXXzQ8ggosbri0HEEPZiXPw600WLUcE5JfSPXrDh/ddc7efCL+oRgFgt6k
         6IVnFLeqNqh9Ip9/j40oE7AX+3WFAyYRbbI4QSB+GG/j0DASaH/8PZOweYvI9swlqZ3a
         S+3k8/sxu11ziSY82dADzhO0iSK/y0Jl+rX3t7Id3Z8mu6mlxhW1mKf9DXyY+bui3iQV
         nn3A==
X-Gm-Message-State: AOAM530MguNCB+HkS7+mrlEMirih/jAQhf4VRKG7Z+BSKWxgTTd/P0B0
        kLzNJISz0C5tUbKJEDTkQ8Wqc1pJlQg=
X-Google-Smtp-Source: ABdhPJx49xfC3QGWQrD5qw/HulHKEjcYP4p7BcA1ouksEtvbUDV0tOQaIb1UA3svH8/Zu7ocQNCRP13Vh3Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c08d:: with SMTP id
 o13mr1024956pjs.187.1644010935993; Fri, 04 Feb 2022 13:42:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:41:59 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 05/11] KVM: SVM: Don't rewrite guest ICR on AVIC IPI
 virtualization failure
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't bother rewriting the ICR value into the vAPIC page on an AVIC IPI
virtualization failure, the access is a trap, i.e. the value has already
been written to the vAPIC page.  The one caveat is if hardware left the
BUSY flag set (which appears to happen somewhat arbitrarily), in which
case go through the "nodecode" APIC-write path in order to clear the BUSY
flag.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c    |  1 +
 arch/x86/kvm/svm/avic.c | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2c88815657a9..6e1f9e83eb68 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1298,6 +1298,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_apic_send_ipi);
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 462ab073db38..82d56f8055de 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -323,18 +323,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	switch (id) {
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
-		 * AVIC hardware handles the generation of
-		 * IPIs when the specified Message Type is Fixed
-		 * (also known as fixed delivery mode) and
-		 * the Trigger Mode is edge-triggered. The hardware
-		 * also supports self and broadcast delivery modes
-		 * specified via the Destination Shorthand(DSH)
-		 * field of the ICRL. Logical and physical APIC ID
-		 * formats are supported. All other IPI types cause
-		 * a #VMEXIT, which needs to emulated.
+		 * Emulate IPIs that are not handled by AVIC hardware, which
+		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
+		 * a trap, e.g. ICR holds the correct value and RIP has been
+		 * advanced, KVM is responsible only for emulating the IPI.
+		 * Sadly, hardware may sometimes leave the BUSY flag set, in
+		 * which case KVM needs to emulate the ICR write as well in
+		 * order to clear the BUSY flag.
 		 */
-		kvm_lapic_reg_write(apic, APIC_ICR2, icrh);
-		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
+		if (icrl & APIC_ICR_BUSY)
+			kvm_apic_write_nodecode(vcpu, APIC_ICR);
+		else
+			kvm_apic_send_ipi(apic, icrl, icrh);
 		break;
 	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
 		/*
-- 
2.35.0.263.gb82422642f-goog

