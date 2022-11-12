Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1B062680D
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiKLIRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiKLIR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:29 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE1813F25
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:28 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c1-20020a170902d48100b0018723580343so5059281plg.15
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6sxJiifG/HbcI/kD9HXwh1w5rUr/VbuNcHdSSEcRpA=;
        b=FacScKAelNZrGtgwl8w+3ds6vKtyYp808JuUQWEzIIVYOOJlOjcRWuUTvbIoA3BtvV
         K3J0uCUKlxt5wvgfQMZm7xPR5YfJItnFP1kjZcOT+7su8jLIaXVWm+n4P2LFU8KIzFHW
         m4f/I1VNmAFezxGI67Z+iuWEGpH2YJQlhAlB7DTz7PqrUnrF23WwFZWVgBUTNFZIoAr4
         +g5eCvtaOf6vZoUeLPvZHrqlf9C3sd2ywaN0FRXaPkfbvTu1wdg314O5h+cGnkcOK3hB
         alv5KrakCKq94WoxhQ6EWq84sNAGs+cFc11nr109zSRgOi4O5L2vDw39F05glpPR+m23
         /9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L6sxJiifG/HbcI/kD9HXwh1w5rUr/VbuNcHdSSEcRpA=;
        b=kQzYYeOPDwmQg+9zD919CQzx6ypG6tVdQg6+uHTQCWsrnBEmrMWCZnrd4FNLciUxay
         kl+lS/bKoG/ZPcjkUqZjkisWGHE8DAgaXvZ1vgaojS3VstJllbuLDZIPF59akzzsNRhL
         OUgUVq4b0r4Va9/49/bz5juJJGVv2q1P6hjJu4SGiewZkcy8WawN7OZkPQrfpz0qRKI6
         8h3EWEZYmR1izovQ2i+CKpYcExny14KU5buS8CAy1Nf1j/GAp1YYYVtsgYJyKPANDlPV
         9ftI1onKIrVO5ceoXcXZLhS6y3I3Yfy6LYO9YKBvI4bofPsy1CoTvXpaGNe48IwK9MCi
         bi+w==
X-Gm-Message-State: ANoB5pnji0HAaO7M6k172PZdBN9VzZSwXKifnTBrqO5cNDr4oC+Y151H
        ALkU7gEmp+0A92J5FdagUFI+epZV56B6PQ==
X-Google-Smtp-Source: AA0mqf7aQpUifUSeHmW7DiqEX55OKzbVwNTuSNUOb6rC8J81HSb9LyTNzd73+bZceLSa4TYbJsj7t2D3QIZ4qw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7e01:b0:186:b38a:9c4a with SMTP
 id b1-20020a1709027e0100b00186b38a9c4amr5537618plm.163.1668241047863; Sat, 12
 Nov 2022 00:17:27 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:08 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-7-ricarkol@google.com>
Subject: [RFC PATCH 06/12] KVM: arm64: Split block PTEs without using break-before-make
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Breaking a huge-page block PTE into an equivalent table of smaller PTEs
does not require using break-before-make (BBM) when FEAT_BBM level 2 is
implemented. Add the respective check for eager page splitting and avoid
using BBM.

Also take care of possible Conflict aborts.  According to the rules
specified in the Arm ARM (DDI 0487H.a) section "Support levels for changing
block size" D5.10.1, this can result in a Conflict abort. So, handle it by
clearing all VM TLB entries.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/esr.h     |  1 +
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c     | 10 +++++++++-
 arch/arm64/kvm/mmu.c             |  6 ++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 15b34fbfca66..6f5b976396e7 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -114,6 +114,7 @@
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
+#define ESR_ELx_FSC_CONFLICT	(0x30)
 
 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV_SHIFT	(24)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 0df3fc3a0173..58e7cbe3c250 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,6 +333,7 @@
 #define FSC_SECC_TTW1	(0x1d)
 #define FSC_SECC_TTW2	(0x1e)
 #define FSC_SECC_TTW3	(0x1f)
+#define FSC_CONFLICT	ESR_ELx_FSC_CONFLICT
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c42eff6d42e..36b81df5687e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1267,6 +1267,11 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
 	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
 }
 
+static bool stage2_has_bbm_level2(void)
+{
+	return cpus_have_const_cap(ARM64_HAS_STAGE2_BBM2);
+}
+
 struct stage2_split_data {
 	struct kvm_s2_mmu		*mmu;
 	void				*memcache;
@@ -1308,7 +1313,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 */
 	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
 
-	stage2_put_pte(ctx, data->mmu, mm_ops);
+	if (stage2_has_bbm_level2())
+		mm_ops->put_page(ctx->ptep);
+	else
+		stage2_put_pte(ctx, data->mmu, mm_ops);
 
 	/*
 	 * Note, the contents of the page table are guaranteed to be made
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8f26c65693a9..318f7b0aa20b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1481,6 +1481,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	/* Conflict abort? */
+	if (fault_status == FSC_CONFLICT) {
+		kvm_flush_remote_tlbs(vcpu->kvm);
+		return 1;
+	}
+
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
-- 
2.38.1.431.g37b22c650d-goog

