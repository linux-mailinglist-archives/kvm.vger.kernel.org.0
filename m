Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92853AD632
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 01:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhFSACE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 20:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhFSACD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 20:02:03 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C087BC061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 16:59:52 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id d12-20020ac8668c0000b0290246e35b30f8so6126863qtp.21
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 16:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QYeKq174KM5+fTY38SgJUZakLTmS4zF3GIxooJkhjrM=;
        b=sYWcM1384CTKDdsj7+0weHRC5heoI/ZpPY1S58rxhfrQyOviJJCEa1UkJS8eTJqMgx
         ARwpA6CLp07fvMT2ZU7oV+f3UKp5tyekWW+J0olaG8+9yYh6iO5PXRDkOIPqpbAkw3Rm
         6wDCKdYvKByd2a6ZHfmUrCZ6TN+HyR5LnfPlEwW5lammRffgHHGhHvAgs8ErreUBYwhr
         jGMEtguM/AlMfhw8AWQcNUlQlBS/o+1Tswcw85ceaIlqcthH/WH/WHKgDoeCequ2r/qN
         DllYSHuNyv8C8M/pvfNeklosl5Kp9yLsSJbeNOO/bY+NkUiLEEBn9Tz9DEO4TmWHkETA
         piTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QYeKq174KM5+fTY38SgJUZakLTmS4zF3GIxooJkhjrM=;
        b=bQChNv1YXDMYwfLOcfe4Eih4boEbQ8RWWjV93XwfFBz8b0a4disGTnLPDG2cOZke1x
         uHrZ5ORWaQu9dWCJDOIzqAvStfg3PdELdXf0JoxcQCPaZ5id+8/jJZEnF84uwVf3RKIh
         +LD5Zpf+gvbusQVwVAS8Gbx8PBWj4EmMzO5z2gE4f8z8raTUFfpr9hpc9SMEplSr3RdY
         1+caIekrGYZaPImNPsis2V2AlEvsvmseP+FjLbBsXjDtqWemRKir0vhNE/Dm+oO5Eigc
         FREKGSYGtNv0MZBWXBuLZT6PBtp18+rcgtxhpmUkXdy+0xABC30iofBvou1eQqpND5Iq
         f5PA==
X-Gm-Message-State: AOAM530BAPG4AFTL51tss6XRkpO4GtY79LZCm+EJa7vq748ZTIUfJ2+f
        6bFc2+HO7Rw+5wKqSMFsrOE1DiGRRZrPbL2oXKJgI+ooe6G8mzX+fZYj8PqqODqJrcw22/jygWf
        xm9erFgc244Fpa0J/SZuVQNqKT7hshNwVoXwWYLV2s8YwYLGdlsudWS7pn1Ss3Pg=
X-Google-Smtp-Source: ABdhPJzqnpfLzORH2YEVr9iBZrmkCCHIopIRGVDvE3rvmytT93hLRSh2mF3VGZmLKziCCsGv4l5aci8uQkTscA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:d0c3:: with SMTP id
 h186mr17222388ybg.150.1624060791835; Fri, 18 Jun 2021 16:59:51 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:59:41 -0700
Message-Id: <20210618235941.1041604-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH] KVM: VMX: Skip #PF(RSVD) intercepts when emulating smaller maxphyaddr
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As part of smaller maxphyaddr emulation, kvm needs to intercept
present page faults to see if it needs to add the RSVD flag (bit 3) to
the error code. However, there is no need to intercept page faults
that already have the RSVD flag set. When setting up the page fault
intercept, add the RSVD flag into the #PF error code mask field (but
not the #PF error code match field) to skip the intercept when the
RSVD flag is already set.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68a72c80bd3f..1fc28d8b72c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -747,16 +747,21 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu))
 		eb |= get_vmcs12(vcpu)->exception_bitmap;
         else {
-		/*
-		 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
-		 * between guest and host.  In that case we only care about present
-		 * faults.  For vmcs02, however, PFEC_MASK and PFEC_MATCH are set in
-		 * prepare_vmcs02_rare.
-		 */
-		bool selective_pf_trap = enable_ept && (eb & (1u << PF_VECTOR));
-		int mask = selective_pf_trap ? PFERR_PRESENT_MASK : 0;
+		int mask = 0, match = 0;
+
+		if (enable_ept && (eb & (1u << PF_VECTOR))) {
+			/*
+			 * If EPT is enabled, #PF is currently only intercepted
+			 * if MAXPHYADDR is smaller on the guest than on the
+			 * host.  In that case we only care about present,
+			 * non-reserved faults.  For vmcs02, however, PFEC_MASK
+			 * and PFEC_MATCH are set in prepare_vmcs02_rare.
+			 */
+			mask = PFERR_PRESENT_MASK | PFERR_RSVD_MASK;
+			match = PFERR_PRESENT_MASK;
+		}
 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, mask);
-		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, mask);
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, match);
 	}
 
 	vmcs_write32(EXCEPTION_BITMAP, eb);
-- 
2.32.0.288.g62a8d224e6-goog

