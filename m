Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8FC3B0C48
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhFVSFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbhFVSEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:04:49 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FBEC0698CB
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:31 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id a12-20020ac8108c0000b029023c90fba3dcso95050qtj.7
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DcMbbuPBdfPM+4lhKP45794XPTQIo8DE9uxp3mrtfRE=;
        b=ZUTZm06KBeB9b7MlUTKQEHVR9WwluCSjklC225fpBVtq4CUgkjb4Re8U3IBnjKmymp
         lqb0kG/4H3yEwk/exFCc2Vp7i2hQPuoE814Rzf4AiZgEPs2h5hujtnsGhB0VaXYBmAjD
         7CGiJQkgpmqCo7Ao73Jzirh7kC41yaLz+EDpNUxNt1WmRZfIkb/PZ3PISpv1BWKmkEM4
         3OoaOEN+7eDVymRJ91TZ5yLI3Nyuq5d+W3MutyoJjB7KECLmUf8XPVsMxmwol0H7ZZ7N
         uKueQ4LUkpqu1Pvc+mk4v+/VA0yxI5gWJdln3rXdNAkYOeT6DEaJ5DgfDPBKJI8G44KB
         FzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DcMbbuPBdfPM+4lhKP45794XPTQIo8DE9uxp3mrtfRE=;
        b=SqqjTZ1BXFVEuW0w+ziqyr1RHw9umKIgJ4XsS0fFZdoiUyMl6XmcOYS71rYaKg0zVz
         vrzeBy/0oNTbz/f27dtiZGToZU+i5V3oiOWToASbA2nRO1R9zLlZt16F0qJ5YP7C7jlN
         jyOy4hBLuvQTBcmj14D4abnhz2N2uQb7Mzt1THbi0VARchtJWnPk9yg8g8+R4c3LCNjL
         VTMJxVOPb8tvZ26zp9jO9fOLNQXD+FvaQHg6x19x5LsMl/PPJO6d2tpOu9iMXQViLeAm
         flx0SV4bDA5DfBjkpIU+fvhTlkOB8vOxx9S2I8ga44SjyU+yvcTmVIzux7vDF9EIT5q3
         HylQ==
X-Gm-Message-State: AOAM533bMuwDmD/DbfgYWdegkV+Wpyl0glvT+hlXRSmt2HjXJrFpSgZk
        txJNHxb8tem9nNapa/JS2A65abeTmKk=
X-Google-Smtp-Source: ABdhPJxAqEDaFA+Cih4tUN7s9w+Yx69U6In3XMLv7KpllZiFI25rKVcydJAv9mkD6segs6qvdHXFPIE3eFI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:4181:: with SMTP id o123mr5893293yba.23.1624384770440;
 Tue, 22 Jun 2021 10:59:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:26 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-42-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 41/54] KVM: x86/mmu: Consolidate reset_rsvds_bits_mask() calls
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move calls to reset_rsvds_bits_mask() out of the various mode statements
and under a more generic !CR0.PG check.  This will allow for additional
code consolidation in the future.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30557b3e5c37..52311c2efd5d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4637,18 +4637,18 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	} else if (is_long_mode(vcpu)) {
 		context->root_level = ____is_cr4_la57(&regs) ?
 				PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
-		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 	} else if (is_pae(vcpu)) {
 		context->root_level = PT32E_ROOT_LEVEL;
-		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 	} else {
 		context->root_level = PT32_ROOT_LEVEL;
-		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging32_gva_to_gpa;
 	}
 
+	if (is_cr0_pg(context))
+		reset_rsvds_bits_mask(vcpu, context);
+
 	update_permission_bitmask(context, false);
 	update_pkru_bitmask(context);
 	update_last_nonleaf_level(context);
@@ -4890,18 +4890,17 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * nested page tables as the second level of translation. Basically
 	 * the gva_to_gpa functions between mmu and nested_mmu are swapped.
 	 */
-	if (!is_paging(vcpu)) {
+	if (!is_paging(vcpu))
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
-	} else if (is_long_mode(vcpu)) {
-		reset_rsvds_bits_mask(vcpu, g_context);
+	else if (is_long_mode(vcpu))
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
-	} else if (is_pae(vcpu)) {
-		reset_rsvds_bits_mask(vcpu, g_context);
+	else if (is_pae(vcpu))
 		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
-	} else {
-		reset_rsvds_bits_mask(vcpu, g_context);
+	else
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
-	}
+
+	if (is_cr0_pg(g_context))
+		reset_rsvds_bits_mask(vcpu, g_context);
 
 	update_permission_bitmask(g_context, false);
 	update_pkru_bitmask(g_context);
-- 
2.32.0.288.g62a8d224e6-goog

