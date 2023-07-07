Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8753A74A957
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 05:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjGGDYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 23:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjGGDYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 23:24:33 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D88DC1FC3
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 20:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=K1BmQ
        N6UzhwIggWAHir/kTdOpmmvmeW9cqyZO1NRX50=; b=Gn77yeFBcp4ydxanQ8UKp
        uxFLccN+hweALakVyUBpsLP04rHGiLzESUsWPZNhZDH3vKv4s+IV+Gl6dgOIo03g
        o8DsiT3xEsRv6LLMGqE2gMJNBruuSHuV64iFoQWKBgfG3ZR1+82cUFEyy7hDhGY4
        nrWGoDw5pX6ukIWDJWzQA8=
Received: from yangzhang2020.localdomain (unknown [60.24.208.92])
        by zwqz-smtp-mta-g1-4 (Coremail) with SMTP id _____wD3elEahadk1ZPOBw--.32303S2;
        Fri, 07 Jul 2023 11:23:13 +0800 (CST)
From:   "yang.zhang" <gaoshanliukou@163.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-riscv@nongnu.org, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        zhiwei_liu@linux.alibaba.com, dbarboza@ventanamicro.com,
        "yang.zhang" <yang.zhang@hexintek.com>
Subject: [PATCH] target/riscv KVM_RISCV_SET_TIMER macro is not configured correctly
Date:   Fri,  7 Jul 2023 11:23:06 +0800
Message-Id: <20230707032306.4606-1-gaoshanliukou@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wD3elEahadk1ZPOBw--.32303S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1ktry3WFy8ZF1fGF4xXrb_yoW3uFg_Gw
        40g3WxurWjvayYvFWUAw45Cryj9r95Ka1I93WrJFsxC34jgrWUJ3ZYgFn7Aryruw4xWr93
        Zr1xJr9xCryYyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUea0P7UUUUU==
X-Originating-IP: [60.24.208.92]
X-CM-SenderInfo: pjdr2x5dqox3xnrxqiywtou0bp/1tbiUQOl8mDESKYIsgAAs1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_L4,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "yang.zhang" <yang.zhang@hexintek.com>

Should set/get riscv all reg timer,i.e, time/compare/frequency/state.

Signed-off-by:Yang Zhang <yang.zhang@hexintek.com>
Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1688
---
 target/riscv/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 30f21453d6..0c567f668c 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -99,7 +99,7 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
 
 #define KVM_RISCV_SET_TIMER(cs, env, name, reg) \
     do { \
-        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg); \
+        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, name), &reg); \
         if (ret) { \
             abort(); \
         } \
-- 
2.25.1

