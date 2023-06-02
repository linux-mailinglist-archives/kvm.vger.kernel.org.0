Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE571FAD5
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 09:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbjFBHSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbjFBHSv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 03:18:51 -0400
X-Greylist: delayed 912 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Jun 2023 00:18:46 PDT
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFAF128
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 00:18:45 -0700 (PDT)
From:   Gao Shiyuan <gaoshiyuan@baidu.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>
CC:     <likexu@tencent.com>, Shiyuan Gao <gaoshiyuan@baidu.com>
Subject: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL bit35
Date:   Fri, 2 Jun 2023 15:02:24 +0800
Message-ID: <20230602070224.92861-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex03.internal.baidu.com (172.31.51.43) To
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42)
X-FEAS-Client-IP: 172.31.51.22
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shiyuan Gao <gaoshiyuan@baidu.com>

When live-migrate VM on icelake microarchitecture, if the source
host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
number of vPMU fixed counters to 3") and the dest host kernel after this
commit, the migration will fail.

The source VM's CPUID.0xA.edx[0..4]=4 that is reported by KVM and
the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest VM's
CPUID.0xA.edx[0..4]=3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x7000000ff.
This inconsistency leads to migration failure.

The QEMU limits the maximum number of vPMU fixed counters to 3, so ignore
the check of IA32_PERF_GLOBAL_CTRL bit35.

Fixes: 2e8cd7a3b828 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")

Signed-off-by: Shiyuan Gao <gaoshiyuan@baidu.com>
---
 arch/x86/kvm/pmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5c7bbf03b599..9895311d334e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -91,7 +91,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
 						 u64 data)
 {
-	return !(pmu->global_ctrl_mask & data);
+	return !(pmu->global_ctrl_mask & (data & ~(1ULL << 35)));
 }
 
 /* returns general purpose PMC with the specified MSR. Note that it can be
-- 
2.36.1

