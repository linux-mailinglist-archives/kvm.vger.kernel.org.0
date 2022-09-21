Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4D85E55A2
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiIUVzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiIUVzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:55:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B8192F62
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:54:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o99-20020a17090a0a6c00b002039c4fce53so189903pjo.2
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ktAQp/cqUNax6F89ciMk5io9XS6O+IoDU1II6HgARlk=;
        b=SQEMJdZAxGZLgr10LuMDwKTK6WnB/iHH0F/XbZBnLhtsk4J9RkRaDB/8S59fu2bvkW
         T+GTfp5V+hhi71zNXY6WbofK00rZEfqdtw8pA4P0Wzr9Try2jGDApm2BQrjuu8euMhBk
         yZoFHMNBtPF7gP870Pz67atYHfqGG79eDhd04MoUTO+mYew6PrPR6NNI0+REGOUQJlAN
         PCNWJlfaruV0NIL6eAnQjufQJw4ddzljKoBygMsvenog8DVFmgMY2sn2d5Ui3Mqfxf/D
         EJWveRPWpqS8XThMM/pepjqjRGb6ZvWRi5MTpio7GEks4HIuQzVxCzIrjzh2R2YfJqS0
         r/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ktAQp/cqUNax6F89ciMk5io9XS6O+IoDU1II6HgARlk=;
        b=q4iqH3fPWRPrBNP2an3iMCIqpGNxiwcGP6MUECGMWj7yiwWK9aLHxYyGD1FR3unCQC
         Xc7pcZijRSYFteh20o2I2PWtQbuxkYXBGHWj0AqsqVt9uFdz6zqUZj8Wbgc60V9/YP89
         XRjopSe2+dr+F6XzOD2P6IC2bqhv62K5j2zvR2U+T7E6RzNbaYIlNkKlyY4e1zVZjR1j
         oTCqB+jv9O5Y5LdclIomBdUje7SkmB4uE/Zr+25YojiQIYT2rgr9FLyhqZBDO49lxuWo
         vc9HHMYT53FOw3KFubZSo/4O6QYw+HySSktZ1sKCaGwIYm2196fSeq8yU4AglTK6idzp
         01iQ==
X-Gm-Message-State: ACrzQf0xK5e8vQxS80KPThRixs464U84mbGulsY6HyaEQzgfnI8BS91g
        CgmZqb7pkPfU4oF/pfp/qDIlag==
X-Google-Smtp-Source: AMsMyM7EX7gXqZwatQYRLwQnKPNv/NMPRKHkABZjVRfo3abBbcBrIn6WEKrplk+J2Ts1/dkn3qOeqg==
X-Received: by 2002:a17:902:d512:b0:178:6946:a2aa with SMTP id b18-20020a170902d51200b001786946a2aamr139075plg.116.1663797295533;
        Wed, 21 Sep 2022 14:54:55 -0700 (PDT)
Received: from stillson.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79727000000b005484d133127sm2634536pfg.129.2022.09.21.14.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:54:55 -0700 (PDT)
From:   Chris Stillson <stillson@rivosinc.com>
Cc:     Vincent Chen <vincent.chen@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Chris Stillson <stillson@rivosinc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jisheng Zhang <jszhang@kernel.org>,
        Dao Lu <daolu@rivosinc.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Nick Knight <nick.knight@sifive.com>,
        Han-Kuan Chen <hankuan.chen@sifive.com>,
        Changbin Du <changbin.du@intel.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Yury Norov <yury.norov@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Vincenzo Frascino <Vincenzo.Frascino@arm.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Colin Cross <ccross@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Barret Rhoden <brho@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: [PATCH v12 15/17] riscv: Add V extension to KVM ISA allow list
Date:   Wed, 21 Sep 2022 14:43:57 -0700
Message-Id: <20220921214439.1491510-15-stillson@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921214439.1491510-1-stillson@rivosinc.com>
References: <20220921214439.1491510-1-stillson@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

Add V extension to KVM_RISCV_ISA_ALLOWED list to enable VCPU
to support V extension.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 6f59ec64175e..b242ed155262 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -35,6 +35,7 @@ extern unsigned long elf_hwcap;
 #define RISCV_ISA_EXT_m		('m' - 'a')
 #define RISCV_ISA_EXT_s		('s' - 'a')
 #define RISCV_ISA_EXT_u		('u' - 'a')
+#define RISCV_ISA_EXT_v		('v' - 'a')
 
 /*
  * Increse this to higher value as kernel support more ISA extensions.
-- 
2.25.1

