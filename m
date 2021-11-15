Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E4A452862
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244141AbhKPDTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbhKPDSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:03 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3117EC125D5C
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:24 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id m16-20020a628c10000000b004a282d715b2so5365867pfd.11
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4sbG15/K0RC0hA1szqgTwpG7ttP6Yoxf33M0eCrVUVw=;
        b=Fdx+f6R0epGfm7e9048Z0TCAZY+74t7wZ+aic8nAfEQmn6Ukdy597iOd8j1SJoLPDz
         9ZVsc5kpQ7YXrMkWumaL1vKWO1MdPifALT/yhrRE04AdKahbmlLOArvU2ueB9gyTXlp4
         v/9wA/iyRTIh79KxfHcK7wSqCeLt8qAhyWEfRWVL0IkM8B9CxlP4P/AOD23vQBKjpZu1
         TnswFwNP8R12Cd/HkK3PKc8gbv/EpdbSZkCZz+QZpL8Ggj8uTybrTcq2z8Ru85oM4i1T
         PQY4HM1v2Hc5bLylx1BdDQx5+tvrabeoJ8f3f0B71M8+up7mOwBa4G2LuUSI2LOOj/D9
         qs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4sbG15/K0RC0hA1szqgTwpG7ttP6Yoxf33M0eCrVUVw=;
        b=MaHMgOu23Qe0A+zdBLDZwmnyJJ7E91eIv9D41cLWm7L3bN2Xfth8tR/5iqyEGYWcnO
         3t5Bw6JTsKLQn/5rcNeX1z+U+FVVmx7/X8NhPDRP0VCncZyrSu/TaA3i5QgCLp6UmcXn
         0zPfXoChhbDP867QJPFfbupj7cxEQDj0jROjqb8CJFHNul5TiEwSGNT5qR+KspBuF2Ij
         GY4o1Zs3OcxavY72X8k6DjycIdwiwCxA66qeQaC+PwXuQ1Jvw7eqWWZ7GlHILk+K0yKe
         ptT1fIYjHkpzZjxPk2w76OeQ7kCRqnhbPDjqEIyjDuqi0S5An2VI7CcT0Dukna2cj8fF
         XZgg==
X-Gm-Message-State: AOAM531FxCkf6gtyWZajc+KhW8f68Zq3uBAkYC0XHFtIDv2ZVMhyNJWU
        k9AYd52Dd/jy3IPIYZxYlAbl0ablYEGC
X-Google-Smtp-Source: ABdhPJxHcnpKZWE4BYEiOV5wXxvBj6tl6hlHLLr4T/NZSL33XrFN0YnkTklLBn54gdnLvMYjM9poeb8dMfGz
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:903:1c7:b0:141:e630:130c with SMTP id
 e7-20020a17090301c700b00141e630130cmr40070558plh.80.1637019983710; Mon, 15
 Nov 2021 15:46:23 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:45:57 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-10-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 09/15] KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the implementation of reset_tdp_shadow_zero_bits_mask to a
helper function which does not require a vCPU pointer. The only element
of the struct kvm_mmu context used by the function is the shadow root
level, so pass that in too instead of the mmu context.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e890509b93f..fdf0f15ab19d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4450,17 +4450,14 @@ static inline bool boot_cpu_is_amd(void)
  * possible, however, kvm currently does not do execution-protection.
  */
 static void
-reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-				struct kvm_mmu *context)
+build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
+				int shadow_root_level)
 {
-	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
-	shadow_zero_check = &context->shadow_zero_check;
-
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->shadow_root_level, false,
+					shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else
@@ -4470,12 +4467,20 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = shadow_root_level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
 }
 
+static void
+reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
+				struct kvm_mmu *context)
+{
+	build_tdp_shadow_zero_bits_mask(&context->shadow_zero_check,
+					context->shadow_root_level);
+}
+
 /*
  * as the comments in reset_shadow_zero_bits_mask() except it
  * is the shadow page table for intel nested guest.
-- 
2.34.0.rc1.387.gb447b232ab-goog

