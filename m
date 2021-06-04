Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4476E39BEA9
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFDR2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhFDR2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:28:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A2FC061767
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 10:26:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id jw3-20020a17090b4643b029016606f04954so6306287pjb.9
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rDhx1/I3uVd50WQu8s0ajnL0RFAgeDpmkbIdgj9rtVE=;
        b=i1V18uA4nxcgCUA6QIyUCnyBNwreGmHFm9Uh3Kr3ubb42mWqdXI1y1UtndN5VbACgh
         reRN+FsaRJEYUQkGJbnNVsWJmMs6gJqshJZPJJxYVJcQhjN7lrw+vADNHMgsOeRf6mvP
         MK+BKwjRHTA28pN1qSgOIGRBT/pXuLnuox38GOj6XaECX4qBwGU8w5++mnVPpNAWZEAE
         3RJ9WGzx11vRZyhkHdGj3HrL4OvfpdL8wX9OUWcUbsDvLQRo7QEaSnKKFOUbkMhrvyfR
         b2MIGkAO47oYJVHWLPKSNxAU5XH788zqbJCyckC+UvIjq9w6T5aAPGpLiDJN+iMyTdHB
         g6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rDhx1/I3uVd50WQu8s0ajnL0RFAgeDpmkbIdgj9rtVE=;
        b=EA4TUys1+a+tLv6PiDodF7AsUeFzWlM7PSUNKE2ZPX2l1KSANhzNvO9GHBzDZDGc2j
         4LQEELm9xSb0Zn69viQszvR6iTJ/YAx3fV/3T4JK8el3ovAMd1W91w29/MWMw4N+TJqX
         6HYvzqbYXV0ewbTJ3Hm6xJetbD2WPlEJstOLcT4ElJ4NfCLESW2PnzYP1cAUDcfubX1N
         S1nL710HSiSw9LlDbbY5g3yMza+lgwwdjlEAQPZcwjIi1j+PdRRvUxHtXX1Yh7GTxdOo
         pg7Yvk7FSwK/W9fH5ZOFzM4uhQJ+nM0U97gRcm3cAPDJCs9Dd6a9CBs7L5DfUeeysU15
         TM+A==
X-Gm-Message-State: AOAM5301ddg9MfSYNEnIng8d9YJVUnRnsc6iN0W3GsG4oeHhLVamidgl
        rJv0elFHBzdy6nIZuijIo+TBDm7FsBgieHrtL8hE0g+6NEsbOp/kwnQkkklsyjMavTv4aKqTjNU
        eefAzDvCVUWDsF/Ee6QvBvy6LKCrN5e97hc0uy0OcQHDPmSbMgFnMIdJVWKcfPqU=
X-Google-Smtp-Source: ABdhPJxpw06jOL/HSpoJoRz7FAh9kXbS1RFfsPh5kL1fb8L77jMaESKysGIrHb9an5g0uiriHFgrY3kE8IiWBA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90b:4504:: with SMTP id
 iu4mr6096631pjb.110.1622827599139; Fri, 04 Jun 2021 10:26:39 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:06 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-8-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't allow posted interrupts to modify a stale posted interrupt
descriptor (including the initial value of 0).

Empirical tests on real hardware reveal that a posted interrupt
descriptor referencing an unbacked address has PCI bus error semantics
(reads as all 1's; writes are ignored). However, kvm can't distinguish
unbacked addresses from device-backed (MMIO) addresses, so it should
really ask userspace for an MMIO completion. That's overly
complicated, so just punt with KVM_INTERNAL_ERROR.

Don't return the error until the posted interrupt descriptor is
actually accessed. We don't want to break the existing kvm-unit-tests
that assume they can launch an L2 VM with a posted interrupt
descriptor that references MMIO space in L1.

Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 706c31821362..632f0abfe154 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 				offset_in_page(vmcs12->posted_intr_desc_addr));
 			vmcs_write64(POSTED_INTR_DESC_ADDR,
 				     pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
+		} else {
+			/*
+			 * Defer the KVM_INTERNAL_EXIT until KVM tries to
+			 * access the contents of the VMCS12 posted interrupt
+			 * descriptor. (Note that KVM may do this when it
+			 * should not, per the architectural specification.)
+			 */
+			vmx->nested.pi_desc = NULL;
+			pin_controls_clearbit(vmx, PIN_BASED_POSTED_INTR);
 		}
 	}
 	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
@@ -3689,10 +3698,14 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	void *vapic_page;
 	u16 status;
 
-	if (!vmx->nested.pi_desc || !vmx->nested.pi_pending)
+	if (!vmx->nested.pi_pending)
 		return 0;
 
+	if (!vmx->nested.pi_desc)
+		goto mmio_needed;
+
 	vmx->nested.pi_pending = false;
+
 	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
 		return 0;
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

