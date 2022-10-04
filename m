Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B055F4C61
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 01:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJDXFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 19:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJDXFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 19:05:48 -0400
Received: from zulu616.server4you.de (mail.csgraf.de [85.25.223.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAB2B275F9
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 16:05:42 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-005-115.95.117.pool.telefonica.de [95.117.5.115])
        by csgraf.de (Postfix) with ESMTPSA id F1386608062A;
        Wed,  5 Oct 2022 00:56:45 +0200 (CEST)
From:   Alexander Graf <agraf@csgraf.de>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladislav Yaroshchuk <yaroshchuk2000@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 1/3] x86: Implement MSR_CORE_THREAD_COUNT MSR
Date:   Wed,  5 Oct 2022 00:56:41 +0200
Message-Id: <20221004225643.65036-2-agraf@csgraf.de>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221004225643.65036-1-agraf@csgraf.de>
References: <20221004225643.65036-1-agraf@csgraf.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel CPUs starting with Haswell-E implement a new MSR called
MSR_CORE_THREAD_COUNT which exposes the number of threads and cores
inside of a package.

This MSR is used by XNU to populate internal data structures and not
implementing it prevents virtual machines with more than 1 vCPU from
booting if the emulated CPU generation is at least Haswell-E.

This patch propagates the existing hvf logic from patch 027ac0cb516
("target/i386/hvf: add rdmsr 35H MSR_CORE_THREAD_COUNT") to TCG.

Signed-off-by: Alexander Graf <agraf@csgraf.de>
---
 target/i386/tcg/sysemu/misc_helper.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
index 1328aa656f..e1528b7f80 100644
--- a/target/i386/tcg/sysemu/misc_helper.c
+++ b/target/i386/tcg/sysemu/misc_helper.c
@@ -450,6 +450,11 @@ void helper_rdmsr(CPUX86State *env)
      case MSR_IA32_UCODE_REV:
         val = x86_cpu->ucode_rev;
         break;
+    case MSR_CORE_THREAD_COUNT: {
+        CPUState *cs = CPU(x86_cpu);
+        val = (cs->nr_threads * cs->nr_cores) | (cs->nr_cores << 16);
+        break;
+    }
     default:
         if ((uint32_t)env->regs[R_ECX] >= MSR_MC0_CTL
             && (uint32_t)env->regs[R_ECX] < MSR_MC0_CTL +
-- 
2.37.0 (Apple Git-136)

