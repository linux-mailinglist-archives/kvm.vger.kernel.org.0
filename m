Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E68930CAFD
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbhBBTI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbhBBTCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:02:20 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2675FC061A2A
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:19 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l7so2883810pjy.0
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AT93/ogWHXZz20/nWmto+tVuhh8JYGtfkCQW8Y2OAc4=;
        b=r5R8y+ePnaAaeFSdFKCGU7w4lreH34R3dbk7cfBMhYkTaOHLEhd2TwMXIbp2vgFYi3
         Gd/u1N8eXJchw09Pj82KEmSH5oCErngyK4OhDuq+mzuwOp3lpfgSp9+1HQ27i7YJXnmr
         k90Cuvq3phZ7aKAKk8rsgizzFnYhuzngDJeoGoxSPmCgG0nPlJsipQTbR/jfIztrVdmH
         PChpmj8LgDQ5h6LSSW2KJf/diK7nV4A5xnjbi3T91sat9hXOZuoS8B9rCG2oy0PPUbzE
         oeBetr1O4R4IPOqoZ61HiXZTMb2cSBR6jwSXXgE8SEYEVw4HV027RlgtmhDE63G10nUC
         4ISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AT93/ogWHXZz20/nWmto+tVuhh8JYGtfkCQW8Y2OAc4=;
        b=ETiyQP9flKGPoiSTAQeCo0H7fhWASYFgBkhg/F0j/d4Hnlm84Qef7w8ARKgKcMlO9E
         /UJaNI4nTiEoTQQKmhe+Uc38RRsJ1dCCQUzOFWMz8FEUjIj1K8OShvFuqJWXXNHSlEje
         Tzr7w5jNNVbvmZ7/svJ0WhKWDxf3NxNg6UZLgBSolQroxHunrLiOR/nIrPgCNSVfXPw4
         SBfisu2K0DWBV7QMi2ty66oMOfE9B4afhfYrInsiEe/2H3DElvlbktBIUtzcqIH+Opvj
         0GvIjBRJDjp3PfIwK/fa5IopKGMFVjHUGm/boeNs84ksa0K1gd4e8eBGW9rDxQ8smAyx
         WL0Q==
X-Gm-Message-State: AOAM531wnkp/xjgI9cNGcZoOZ3dnMZrfyk+hgK0Wn1jmhSHeu7Cu1wZV
        rcV8UrzZ/8OMv7cXt77f4iKkuMtdZ7KL
X-Google-Smtp-Source: ABdhPJwCA8GyUrhXpxf2tdjZ130kf6w37Af0AcDtX/wCAZtKVUM1t3M3pKL4+fHk82e59W3QYalqp5VOzjzD
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8d83:: with SMTP id
 d3mr614671pjo.0.1612292298314; Tue, 02 Feb 2021 10:58:18 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:28 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-23-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 22/28] KVM: x86/mmu: Mark SPTEs in disconnected pages as removed
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When clearing TDP MMU pages what have been disconnected from the paging
structure root, set the SPTEs to a special non-present value which will
not be overwritten by other threads. This is needed to prevent races in
which a thread is clearing a disconnected page table, but another thread
has already acquired a pointer to that memory and installs a mapping in
an already cleared entry. This can lead to memory leaks and accounting
errors.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7a2cdfeac4d2..0dd27e000dd0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -334,9 +334,10 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(pt);
 	int level = sp->role.level;
-	gfn_t gfn = sp->gfn;
+	gfn_t base_gfn = sp->gfn;
 	u64 old_child_spte;
 	u64 *sptep;
+	gfn_t gfn;
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
@@ -345,16 +346,39 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		sptep = pt + i;
+		gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
 
 		if (shared) {
-			old_child_spte = xchg(sptep, 0);
+			/*
+			 * Set the SPTE to a nonpresent value that other
+			 * threads will not overwrite. If the SPTE was
+			 * already marked as removed then another thread
+			 * handling a page fault could overwrite it, so
+			 * set the SPTE until it is set from some other
+			 * value to the removed SPTE value.
+			 */
+			for (;;) {
+				old_child_spte = xchg(sptep, REMOVED_SPTE);
+				if (!is_removed_spte(old_child_spte))
+					break;
+				cpu_relax();
+			}
 		} else {
 			old_child_spte = READ_ONCE(*sptep);
-			WRITE_ONCE(*sptep, 0);
+
+			/*
+			 * Marking the SPTE as a removed SPTE is not
+			 * strictly necessary here as the MMU lock should
+			 * stop other threads from concurrentrly modifying
+			 * this SPTE. Using the removed SPTE value keeps
+			 * the shared and non-atomic cases consistent and
+			 * simplifies the function.
+			 */
+			WRITE_ONCE(*sptep, REMOVED_SPTE);
 		}
-		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
-			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
-			old_child_spte, 0, level - 1, shared);
+		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
+				    old_child_spte, REMOVED_SPTE, level - 1,
+				    shared);
 	}
 
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
-- 
2.30.0.365.g02bc693789-goog

