Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA4F7D0951
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376403AbjJTHWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376406AbjJTHV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:21:58 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D7E1AE
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:21:56 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3b3e7f56ca4so326133b6e.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697786514; x=1698391314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFjlFx01Ut+IIk7lMz+iwDuvVBUbWHCR3u/gBbk/FU0=;
        b=cb8kwDbfcMYKuSbeSM4vmK4dk5HzH6+UGU9Z4Cm9buYLbisAywChN7kMLnISn5KVCX
         4iEg08DokJN7xvb1BkDT73ttxPDnbStGLtP/6xk0fZaF1syrUmO1QYmkRXv8jbLIqPGI
         7g8Fv5F/gIwBBHj59qwC3zPpZC5m9kKpl6dNSQpenDmKNCFPLr0RMNrcAX4wXpCNBrvW
         eqk79GYyEO9VH4V8sC52dBFkZr60OL+mAUu7j9ytcxNFJF7NHpm9yIMJO7aiWPZwAHkv
         q45YENrxvOIK0hLlEQSOwLCkrqjqbKDiBokIL35OGLchAHkXvgTwUgqFi5BI9UU6NkIV
         74UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786514; x=1698391314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFjlFx01Ut+IIk7lMz+iwDuvVBUbWHCR3u/gBbk/FU0=;
        b=pfbO4xiMmQEw0dZh/B1XQoUr58UJh2xmOYTwF1WW8p954azDfozP6r+EIf/zwJiqDl
         dAtMinLXMs/ZO/KqPBtjWwGNVHF+7iM77skkO75SJLC1vL9UDMwmNzrk9ofKldiMPtOa
         cQBGDJ8tGMAUrNUY4rdKQAc0FIgojq1lMcqwmkkfgk1Y14frKlhiPk3MiGDYjY51c+dq
         mb46fNR1NTeOvMsPszeB6ieJuqKrvTWHi8PLbyHdaM9e0zMYqibafHiwSQEDzec6aA4P
         jKWE4CRvN7vjP7jaV68hULPdVOOmNrJCjXD7V2sUfDgQvVc567Ut5wcuue3+wvqpBOiv
         IbFw==
X-Gm-Message-State: AOJu0Yxl/0VQeowQqA2cylzBoe761rZ4OSQsJY+sGhnpesLm/ZwwbIVD
        3lCJeGFmu2vXpZEGoy/GcRvadA==
X-Google-Smtp-Source: AGHT+IHCf4SRFvcjUaBZbUoLW1qmUD5qW9WnhX5EFjNLnYxx3oBY2eRFWdyPRUuwwRReyZ05UhdEZg==
X-Received: by 2002:a05:6808:15a3:b0:3ad:ffa4:dfee with SMTP id t35-20020a05680815a300b003adffa4dfeemr1187937oiw.51.1697786514419;
        Fri, 20 Oct 2023 00:21:54 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.81])
        by smtp.gmail.com with ESMTPSA id v12-20020a63f20c000000b005b32d6b4f2fsm828204pgh.81.2023.10.20.00.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 00:21:54 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 1/9] RISC-V: Add defines for SBI debug console extension
Date:   Fri, 20 Oct 2023 12:51:32 +0530
Message-Id: <20231020072140.900967-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020072140.900967-1-apatel@ventanamicro.com>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
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

We add SBI debug console extension related defines/enum to the
asm/sbi.h header.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 5b4a1bf5f439..12dfda6bb924 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -30,6 +30,7 @@ enum sbi_ext_id {
 	SBI_EXT_HSM = 0x48534D,
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_PMU = 0x504D55,
+	SBI_EXT_DBCN = 0x4442434E,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -236,6 +237,12 @@ enum sbi_pmu_ctr_type {
 /* Flags defined for counter stop function */
 #define SBI_PMU_STOP_FLAG_RESET (1 << 0)
 
+enum sbi_ext_dbcn_fid {
+	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
+	SBI_EXT_DBCN_CONSOLE_READ = 1,
+	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE = 2,
+};
+
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
 #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
-- 
2.34.1

