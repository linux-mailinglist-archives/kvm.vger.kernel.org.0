Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF01846C73E
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242275AbhLGWNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 17:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242160AbhLGWNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 17:13:16 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83119C061746
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 14:09:45 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k11-20020a63d84b000000b003252e72da7eso145968pgj.23
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 14:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uF16Oxv6VV3ZC2VxAZ1WSj/36gf1pwNq03D2B8pq7CQ=;
        b=dwNTtTYKNZg2ogxqpqo+kgmhVGX0dGvDuL9/IB5EaLp/MKFz54Cp68CczXTbzQuDxf
         enVpIwazPtmn/7nKwlWSmXmbLJGGcrwAgUa/hbweGw8NmKv0t9tZIcQ6YpJR7N5HO6n6
         4LgSsRph4OVRbWGJzMrCUaNmDqhOCfG539i/WYsU4n925UP/OVwl8OAz3dZuc5xHv0Hn
         yYmoLqa9nIj2qQ6HXBW5PUCNZDfSchfLUvlkAE1TfXk3e7OqPsxpfFsBu9B+rApE/+up
         ffTctyVJsxm+D7CN8hBUcoUvkSFiXpbhJwflYlmMgtb9wths+JU/xgUpiwSN/35QZ2ub
         DesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uF16Oxv6VV3ZC2VxAZ1WSj/36gf1pwNq03D2B8pq7CQ=;
        b=eUUuixxq5q51dMtcMO6bizB/RFp77og1zanWXB3JlKdn1Pk1HpyWiHirx5JwXVSZfi
         nfzOmjSgglxLU/STrT2QcENkRU2+KiwgkRQDPMknlsfJwvvqS5GhASJSyhSm3YcnGTFI
         jQcrQBj8odkhMFYMgHmsoAiqoi4C9CMev5PIMcVxWfRRJBl9zp5zrZem2N9lHEaNyk/R
         Udt5hDwRNkwcV2CinLKaDDGiBFVTmdaab2PBJOI2qf32i89SbrH/UZazNYZztxIbFjCp
         k2RkvsYjoFUjRmJ55rC1hBsMgwVUtp2R38TQtWvkys9tnlrYbOt7oRhSN3GFm1OliVRM
         U6fg==
X-Gm-Message-State: AOAM530DtwmWSxeZLy29B3L9t5LO/o4EDBoCVVaMIXAJCCy/p647TRNV
        4N5tuy14TsJl5fhbDnqyv/ixPOLdDyk=
X-Google-Smtp-Source: ABdhPJy8yElcff+JtvEmSmZyuQO5eqvAAbkr68ZohfdG1rhfOZy7h03ST7rzPoHdCZCuQQpKoswF9MqageY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88a:b0:141:dfde:eed7 with SMTP id
 w10-20020a170902e88a00b00141dfdeeed7mr55226833plg.17.1638914985025; Tue, 07
 Dec 2021 14:09:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Dec 2021 22:09:23 +0000
In-Reply-To: <20211207220926.718794-1-seanjc@google.com>
Message-Id: <20211207220926.718794-6-seanjc@google.com>
Mime-Version: 1.0
References: <20211207220926.718794-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 5/8] KVM: x86: Don't bother reading sparse banks that end
 up being ignored
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling "sparse" VP_SET requests, don't read sparse banks that
can't possibly contain a legal VP index instead of ignoring such banks
later on in sparse_set_to_vcpu_mask().  This allows KVM to cap the size
of its sparse_banks arrays for VP_SET at KVM_HV_MAX_SPARSE_VCPU_SET_BITS.
Add a compile time assert that KVM_HV_MAX_SPARSE_VCPU_SET_BITS<=64, i.e.
that KVM_MAX_VCPUS<=4096, as the TLFS allows for at most 64 sparse banks,
and KVM will need to do _something_ to play nice with Hyper-V.

Reducing the size of sparse_banks fudges around a compilation warning
(that becomes error with KVM_WERROR=y) when CONFIG_KASAN_STACK=y, which
is selected (and can't be unselected) by CONFIG_KASAN=y when using gcc
(clang/LLVM is a stack hog in some cases so it's opt-in for clang).
KASAN_STACK adds a redzone around every stack variable, which pushes the
Hyper-V functions over the default limit of 1024.

Ideally, KVM would flat out reject such impossibilities, but the TLFS
explicitly allows providing empty banks, even if a bank can't possibly
contain a valid VP index due to its position exceeding KVM's max.

  Furthermore, for a bit 1 in ValidBankMask, it is valid state for the
  corresponding element in BanksContents can be all 0s, meaning no
  processors are specified in this bank.

Arguably KVM should reject and not ignore the "extra" banks, but that can
be done independently and without bloating sparse_banks, e.g. by reading
each "extra" 8-byte chunk individually.

Reported-by: Ajay Garg <ajaygargnsit@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 680ba3d5d2ad..a470cde7a7a7 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1754,11 +1754,16 @@ struct kvm_hv_hcall {
 static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
 				 u64 *sparse_banks, gpa_t offset)
 {
+	u16 var_cnt;
+
 	if (hc->var_cnt > 64)
 		return -EINVAL;
 
+	/* Ignore banks that cannot possibly contain a legal VP index. */
+	var_cnt = min_t(u16, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS);
+
 	return kvm_read_guest(kvm, hc->ingpa + offset, sparse_banks,
-			      hc->var_cnt * sizeof(*sparse_banks));
+			      var_cnt * sizeof(*sparse_banks));
 }
 
 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
@@ -1771,9 +1776,17 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 	unsigned long *vcpu_mask;
 	u64 valid_bank_mask;
-	u64 sparse_banks[64];
+	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	bool all_cpus;
 
+	/*
+	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
+	 * valid mask is a u64.  Fail the build if KVM's max allowed number of
+	 * vCPUs (>4096) would exceed this limit, KVM will additional changes
+	 * for Hyper-V support to avoid setting the guest up to fail.
+	 */
+	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
+
 	if (!ex) {
 		if (hc->fast) {
 			flush.address_space = hc->ingpa;
@@ -1895,7 +1908,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
 	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
 	unsigned long *vcpu_mask;
 	unsigned long valid_bank_mask;
-	u64 sparse_banks[64];
+	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
 	u32 vector;
 	bool all_cpus;
 
-- 
2.34.1.400.ga245620fadb-goog

