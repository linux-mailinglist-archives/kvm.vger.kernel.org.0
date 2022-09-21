Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854BD5E5560
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiIUVqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiIUVp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:45:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3B2A6C17
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:45:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so148319pjq.3
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Mj3l9TL6WKmPWu+0iN9vSXqZMe6kPxftZnXjHP2P8BU=;
        b=gRooOxATLU9/plxfbBItc5MyPgEqAIU8yk7UUi6tX8/Sj5TPJ4jOh2lLNZLIq03yD/
         Anz/Evd4AH3ChAtCsJuDGmKHg+0rcdzi1lQKRfwjFD85+ZVWFk3CFtpS42CYRWzeuEfc
         oELczcbuVEbrDxXJldujOAbTmpHkCa1YbObrjZR7sqUTetjEfsRocYoGbfz6w58b4Eyc
         KSXltdTvPqvblVn5uIuiWudlA4rjbmTUDaOjtU+cebKWEStWWDZsMyb/IEnKhJkYDWg9
         xyUebBdly9VFkHNCzurtWPCABQx3Qgi03nhK7Xs1vx3Opd613fJpoPUWoPIusUNpdyXU
         5mXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Mj3l9TL6WKmPWu+0iN9vSXqZMe6kPxftZnXjHP2P8BU=;
        b=P/88Qp+WZr9lXHVXqrtkmaEZVV6tCCAeQXnlO2n3J7V1hqmFUYQA/DqDVuoxlngqJB
         sm9x7KDap4eXMyzwi5wtalEtzYM41qDylvrEc6m7JqPo75qlHC8f8NQ7YL9PhrG0Lprn
         7FdgZ/dW07LFs4KLjLOScANmfgpeXZTyZ84tPlSJoUY1Fye6MMV/P66AVNrh3WPrb5Me
         y7p+90hBQvJK9lAyYJ5XhdxIzaZ6z4xy9TO8cthiKBrgCODXH3whakBZcQqUcBkFdCrF
         iqVafACKAcqlgbAUs8hHa4NDGVU8nKirZRYjAfpnM4VaYMRkzPSgOvZtlkXdpeZjYUWj
         ViBw==
X-Gm-Message-State: ACrzQf02vxGO+4uq3jFyxbR1BhmZgODCLT+YX83JPKHsYvMtrp63TNCv
        eGrP1K0M7dwKxgs8t6CE+1i6mw==
X-Google-Smtp-Source: AMsMyM7vI5SJE0+lFi/SjzwB7byCbic4o87lhgQGCKazRPjoqX2GRJ8LTCmVDof9ZJUchurT/snvBQ==
X-Received: by 2002:a17:902:c792:b0:178:2bd6:c429 with SMTP id w18-20020a170902c79200b001782bd6c429mr201075pla.52.1663796751176;
        Wed, 21 Sep 2022 14:45:51 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:45:50 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Guo Ren <ren_guo@c-sky.com>, Guo Ren <guoren@linux.alibaba.com>,
        Anup Patel <anup@brainfault.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Chris Stillson <stillson@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Vincent Chen <vincent.chen@sifive.com>,
        Heiko Stuebner <heiko@sntech.de>, Dao Lu <daolu@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Nick Knight <nick.knight@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Changbin Du <changbin.du@intel.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Alexander Graf <graf@amazon.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Peter Collingbourne <pcc@google.com>,
        Colin Cross <ccross@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barret Rhoden <brho@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 02/17] riscv: Extending cpufeature.c to detect V-extension
Date:   Wed, 21 Sep 2022 14:43:44 -0700
Message-Id: <20220921214439.1491510-2-stillson@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921214439.1491510-1-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guo Ren <ren_guo@c-sky.com>

Current cpufeature.c doesn't support detecting V-extension, because
"rv64" also contain a 'v' letter and we need to skip it.

Signed-off-by: Guo Ren <ren_guo@c-sky.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 arch/riscv/include/uapi/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/hwcap.h b/arch/riscv/include/uapi/asm/hwcap.h
index 46dc3f5ee99f..c52bb7bbbabe 100644
--- a/arch/riscv/include/uapi/asm/hwcap.h
+++ b/arch/riscv/include/uapi/asm/hwcap.h
@@ -21,5 +21,6 @@
 #define COMPAT_HWCAP_ISA_F	(1 << ('F' - 'A'))
 #define COMPAT_HWCAP_ISA_D	(1 << ('D' - 'A'))
 #define COMPAT_HWCAP_ISA_C	(1 << ('C' - 'A'))
+#define COMPAT_HWCAP_ISA_V	(1 << ('V' - 'A'))
 
 #endif /* _UAPI_ASM_RISCV_HWCAP_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 553d755483ed..8d4448c2d4f4 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -83,6 +83,7 @@ void __init riscv_fill_hwcap(void)
 	isa2hwcap['f'] = isa2hwcap['F'] = COMPAT_HWCAP_ISA_F;
 	isa2hwcap['d'] = isa2hwcap['D'] = COMPAT_HWCAP_ISA_D;
 	isa2hwcap['c'] = isa2hwcap['C'] = COMPAT_HWCAP_ISA_C;
+	isa2hwcap['v'] = isa2hwcap['V'] = COMPAT_HWCAP_ISA_V;
 
 	elf_hwcap = 0;
 
-- 
2.25.1

