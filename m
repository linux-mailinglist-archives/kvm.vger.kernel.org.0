Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAFE74A338
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjGFRjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjGFRix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:38:53 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD612108
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:38:47 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-76c64da0e46so34295739f.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665127; x=1691257127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=mlDe1KkQEhdZ43yhPQMieB0kT72hWPFQGa3i146VWbtpFy7rTAkCslnHTVk6JQ+HGA
         OzC0WhPsP9KtHr4YxSJ65+Tk5OueI9rjhFVhyxKgYUEbnpNZuCEluAt3EJTh2TmVI5nB
         4wc6R+kFHMYUKzv19RBGHUxSofoxAQRyeYaHuT5h6bE737Pz/P3SzlrrwMc/tEaYOJZ0
         dUYvO521r+ks7YvTG08jVBjF39/OrFJNrpx34sjPFjO+HRQEUV1h+ifTUTPBqAlZzQ3I
         pmTi8r1I/DAIRkSMWrIKb6J3oe87iORIsYxbDSwMgRPtzNGXP+V3w2zGTrHw1sWuLv2f
         gzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665127; x=1691257127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ur/4nc0WWZqL23flua+8noNR16SuSLq+XhY4yLBLAT8=;
        b=Ckgbz2sHiQu/N/qP99omkmbROUszZ2AUEfVtuWLgSHRtVkfRdBx4NP6J4ZdCdkzGXs
         VxqIb/2LP3r7Y9kIsHnY+HYz0NykTTrnOQ8A5k03nM3Oam/mqRuZAilTR2zs/Cly5VOs
         nMOtflWIeHih555OmHNZ9BiBTYNjO6J+8O6R60UbOs0TjW6gH1NXwDT68hGm3mNf4HBB
         tnpursEb8wsl9HRGjv3N4AYes0FQO+YBiZnos0Da2KNmGx2OgS9cF4lsBxWBfExC9o3Y
         ulreWdOZfx/oCYtUF/jhtAAU3/cdGUGkAJn0T5yItuoD8hSaahtPN5wi7SJUMG5i96BK
         C9mw==
X-Gm-Message-State: ABy/qLY0toPyQ852uoia9oMV4XWYQE6vf7kDpCJaMXf7EED8T0p+93n2
        G4/2DRoK70uNQsxWjSN/xoL8Og==
X-Google-Smtp-Source: APBJJlEMDZl4DmMf0qoBSalbRnBjZSFumP5Iwjd9jWeED+ZkP1pelDswvjypqt97iZM0Fcx/Q8Dc/Q==
X-Received: by 2002:a6b:4102:0:b0:786:267e:bd4 with SMTP id n2-20020a6b4102000000b00786267e0bd4mr2630097ioa.10.1688665126900;
        Thu, 06 Jul 2023 10:38:46 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:38:46 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 4/8] riscv: Sort the ISA extension array alphabetically
Date:   Thu,  6 Jul 2023 23:08:00 +0530
Message-Id: <20230706173804.1237348-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230706173804.1237348-1-apatel@ventanamicro.com>
References: <20230706173804.1237348-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let us follow alphabetical order for listing ISA extensions in
the isa_info_arr[] array.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 3cdb95c..977e962 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -15,11 +15,12 @@ struct isa_ext_info {
 };
 
 struct isa_ext_info isa_info_arr[] = {
-	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	/* sorted alphabetically */
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
-	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
+	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
+	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
 
 static void dump_fdt(const char *dtb_file, void *fdt)
-- 
2.34.1

