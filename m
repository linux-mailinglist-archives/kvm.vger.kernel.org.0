Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C1163AD69
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 17:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiK1QO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 11:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiK1QOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 11:14:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AE522B1B
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:47 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso14533098pjt.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 08:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7G5jJwuL5a/PRNCMiCmBEuKFRdtzizPv7c8U41zNCGg=;
        b=lrhiGfsIfOZZ6ZSUfqLx0rHc7pIdz7RcfT9qTrum1U7zEbSdCBeuIAffCX9Zp8ALzF
         QijgFUXavVRujVGmYAnKR1lA7+nl0rsXn93dezLwx1IfkYQzPwSBifIe80oHP5YPSNfc
         knJREFODU6y9oD6lGpxSJe1Z11OJ6f2uhBT+lDLN5hl+0oVV4AfxOOWa3kwft1/6s6lx
         aTDoavz9I3OMPVZ9lBIUtc5Ojne1pFtIbwfL9S3hme8LFnTWMBEPkv0ZxJO9IERhQXKD
         LrpdyEUC76y9Wc7Qr2xmmRCricyYcugnKM711T3L0zNHCOD60LH6Nf7/CUcYy2YCLjPs
         1heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7G5jJwuL5a/PRNCMiCmBEuKFRdtzizPv7c8U41zNCGg=;
        b=veTrDt1yciY58+k9sEK/OFH0pM1Q2LKBS1j5UNJ3mDRMpqfO0fxg1IZO7xx7brnKws
         iEfYZ1dn6ODI8S3aT7WJbWkQ+vwwk3+NBSNs18RI77D9ttei/jB1Y2+yUhHmtm+EZEAB
         Rtfj7Zu9lsW886OO9DhlaVIwopOxbFS9xS1ChkFCsokwWBrIdKWNZDaBKyMqIIQCBFrz
         kkuRHzwzf5SAv9mRB2swjFKGzBa5i3RjrMTRqBUe3pQdL3HqmuIqEbDUFJBactIFCd2f
         md7hjWHqDZ+QghfD6wjphjH5bJifurG1fGhyiJ5JfvReLySScCeCMymYe91+3gt5ImOX
         AwmQ==
X-Gm-Message-State: ANoB5pnDHpDWGVzPivZqrUs6BPOiHu1EhCzSgfUiiMBLuxJR/GdSkoI5
        mnu0/0M9zxsKE81TV2UpQ5h/hQ==
X-Google-Smtp-Source: AA0mqf4SMYv7flwkn7gbi28fGz5UIiTwFY/3HWCe4s9O1TbUPNOiBEY7kreAHjSDAfxZZdMvCv4byA==
X-Received: by 2002:a17:902:9307:b0:189:9284:2140 with SMTP id bc7-20020a170902930700b0018992842140mr2574760plb.111.1669652087098;
        Mon, 28 Nov 2022 08:14:47 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.85.0])
        by smtp.gmail.com with ESMTPSA id k145-20020a628497000000b0056246403534sm8210805pfd.88.2022.11.28.08.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:14:46 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/9] RISC-V: KVM: Remove redundant includes of asm/csr.h
Date:   Mon, 28 Nov 2022 21:44:18 +0530
Message-Id: <20221128161424.608889-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should include asm/csr.h only where required so let us remove
redundant includes of this header.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h | 1 -
 arch/riscv/kvm/vcpu_sbi_base.c    | 1 -
 arch/riscv/kvm/vcpu_sbi_hsm.c     | 1 -
 arch/riscv/kvm/vcpu_sbi_replace.c | 1 -
 arch/riscv/kvm/vcpu_sbi_v01.c     | 1 -
 5 files changed, 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index dbbf43d52623..6502f9099965 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -13,7 +13,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
 #include <linux/spinlock.h>
-#include <asm/csr.h>
 #include <asm/hwcap.h>
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index 22b9126e2872..0c806f61c629 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -10,7 +10,6 @@
 #include <linux/err.h>
 #include <linux/kvm_host.h>
 #include <linux/version.h>
-#include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
 
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 239dec0a628a..2e915cafd551 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -9,7 +9,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
-#include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
 
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 4c034d8a606a..03a0198389f0 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -9,7 +9,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
-#include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_sbi.h>
diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 8a91a14e7139..489f225ee66d 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -9,7 +9,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
-#include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_sbi.h>
-- 
2.34.1

