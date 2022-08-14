Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D699592009
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 16:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbiHNOM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Aug 2022 10:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239472AbiHNOM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Aug 2022 10:12:57 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73839FCA
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:54 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay12so2782149wmb.1
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=qMUpNbdJFHkt8LehO+vj4FoNVMjMZ3b4RSV8Kbu/byM=;
        b=VU4X7ETrUmw6SeHfZ8AdO5lxQKOQF2HqiEeNSOaEO67IQgUu4al0l7Lp3vRJzsv8Ft
         148XhPJaK+g8F+K2pFvw/ibH2zC/GW6G3TP/Sub0QP9WkIpbzxC521jv+uLO/jzmgdCC
         diUBrwCfWZAKEoAmALJ7bywyWKZDHeo5iPTbotwxY1F/O5oI4I5Ic4VuSvMYwZdFUQh/
         ZEEUY4gc60LRUCvGwVdTLyUl+apOZQtsCzBQlH0d/e91I9A9waemfuZBe86cO8GtLRDm
         XrQDdAFcRZvf/GQyqSv1qssDXttkUmbTxG0amI78ugyDHn2eEBwwRt3ahtZMIU5vgAfm
         +YBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qMUpNbdJFHkt8LehO+vj4FoNVMjMZ3b4RSV8Kbu/byM=;
        b=WHkCQHtnOd6vqWKiqO0iXcm5EK21M2A5SL/LZ2EEPcj0s9v2fCaMkeyU+gCKHboVBg
         g0TCzkaqT2ONBr739pEI3N/ZqJAhDqGjY37nyOaRZEi1CZfmeyhomWgILGIWQivUb9W7
         f60Lz56RzJytIyz2zoCA94fnDp765ldieI3ctO/9uff+V1L1lK4CV3jdRFGX9Q/1cDG2
         8ZgkK3EZepb11+mlXqc7Yb4rCs28NIZM02ypZYHMIlvSVhx7QnaHEOS90Ss+/4nJtTSn
         bohoEZrzmz7DfkREt6c70BuTTIJdsvr8KQYbIplOFe1racuJt/sXnPtPPeefci5x3NW+
         zWaw==
X-Gm-Message-State: ACgBeo2O3aLHTDRbgEDIHEZsjBUQcsJQLECWTLg/7YjEdZLwtx8ZsbN9
        uthfiYsSTmbSE4Q5WnVC+PSzBA==
X-Google-Smtp-Source: AA6agR4TZ6OGzcxxznTc5xN2jS1X/dAKB1yFSxHRG1y13P0Di1gIIk68PUhQuEwPcdtEnEPKe4wd+Q==
X-Received: by 2002:a05:600c:a4c:b0:39c:34d0:fd25 with SMTP id c12-20020a05600c0a4c00b0039c34d0fd25mr7924157wmq.172.1660486373101;
        Sun, 14 Aug 2022 07:12:53 -0700 (PDT)
Received: from henark71.. ([109.76.58.63])
        by smtp.gmail.com with ESMTPSA id b8-20020adfde08000000b0021db7b0162esm4625419wrm.105.2022.08.14.07.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 07:12:52 -0700 (PDT)
From:   Conor Dooley <mail@conchuod.ie>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] riscv: kvm: move extern sbi_ext declarations to a header
Date:   Sun, 14 Aug 2022 15:12:36 +0100
Message-Id: <20220814141237.493457-3-mail@conchuod.ie>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220814141237.493457-1-mail@conchuod.ie>
References: <20220814141237.493457-1-mail@conchuod.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

Sparse complains about missing statics in the declarations of several
variables:
arch/riscv/kvm/vcpu_sbi_replace.c:38:37: warning: symbol 'vcpu_sbi_ext_time' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_replace.c:73:37: warning: symbol 'vcpu_sbi_ext_ipi' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_replace.c:126:37: warning: symbol 'vcpu_sbi_ext_rfence' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_replace.c:170:37: warning: symbol 'vcpu_sbi_ext_srst' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_base.c:69:37: warning: symbol 'vcpu_sbi_ext_base' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_base.c:90:37: warning: symbol 'vcpu_sbi_ext_experimental' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_base.c:96:37: warning: symbol 'vcpu_sbi_ext_vendor' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_hsm.c:115:37: warning: symbol 'vcpu_sbi_ext_hsm' was not declared. Should it be static?

These variables are however used in vcpu_sbi.c where they are declared
as extern. Move them to kvm_vcpu_sbi.h which is handily already
included by the three other files.

Fixes: a046c2d8578c ("RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file")
Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
Fixes: 3e1d86569c21 ("RISC-V: KVM: Add SBI HSM extension in KVM")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
 arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 83d6d4d2b1df..26a446a34057 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -33,4 +33,16 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     u32 type, u64 flags);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
 
+#ifdef CONFIG_RISCV_SBI_V01
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
+#endif
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
+
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d45e7da3f0d3..f96991d230bf 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -32,23 +32,13 @@ static int kvm_linux_err_map_sbi(int err)
 	};
 }
 
-#ifdef CONFIG_RISCV_SBI_V01
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
-#else
+#ifndef CONFIG_RISCV_SBI_V01
 static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
 	.extid_start = -1UL,
 	.extid_end = -1UL,
 	.handler = NULL,
 };
 #endif
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_v01,
-- 
2.37.1

