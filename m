Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C587C0224
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbjJJRFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjJJRFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:05:21 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC5F97
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:19 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c724577e1fso46632525ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696957519; x=1697562319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8bTrDTugOefVQ1gZ31VUL3xKHXyC/9v3hCQTi2FF0M=;
        b=jU5kqW5+yNfWXyrCBivpJvC6WFn8kuATscsBROojMz/mRH5v2/fAXFwz8y12CccoWJ
         Jf9kUJVveLhhjTZIhIGmzhi2PIHmqcU0yey+PIzlutgigyxExtvao35qm2vVKBHlj0M5
         80OItPZNkpj1AOWEtJNrhHi2/IOld306mc2QXADitvQQij7EcYmrVMsuTKiWy8/IwyRF
         +jF/FpsrO6boZuWHZ4Hp2HIcoT2fU1RGd8mLrl/mxlF6M7G52GTSCS7MxQtYzWhmSq2r
         g4rsQxODxOtVoFgX8GNihTrb/BCzJDZqzSMVUarbirZT5uVPB2+gZabqxBaiLqhYtD8J
         3ZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696957519; x=1697562319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8bTrDTugOefVQ1gZ31VUL3xKHXyC/9v3hCQTi2FF0M=;
        b=ZzAshhJnTHnMkraLcEHSHjKunR30cApQQeTuBuloetkzFiVZH0wS8OS6pWiu8uZKvP
         +boebER8rUSyaV3MfQcysZT9SPv9CtK98Ir9IzW19+FiRKIZ7XS9dTI/DMWZK0SVllqs
         JyvnQGf7duf13tf5r9hAJdPtrC4k1+6VXcEohlwfbV6wC5EN6hrObhUY+y+MH0zfZV7Z
         LoW7s4tJ7ENJ99AsBicX62SaTP5vDDGeij0kf/z0T4Vy3JkWflQU312ZIHK3hmDBUx9h
         6vlcPqnyxQzK6EegmvzXQI+ifYfTROQAYtQ2ZU0tcNKfVgV9Xtdyi4jzP/uz+41bHqNg
         HDJw==
X-Gm-Message-State: AOJu0Yz1j2mUqcYIZTmsyKv2SvYiztR0/ItVQqvxwDMfZrsrcWPCJm7L
        zhPwer5aG7hl6GBvzjLLBmP3aw==
X-Google-Smtp-Source: AGHT+IFL7+0d+NQPD7h5kg3nJxB/J3VP1OkPOJXtOKdl/WfOH7Q9zbTJf6UkIcSLTxobmxIUYWGImA==
X-Received: by 2002:a17:902:ea0a:b0:1bb:598a:14e5 with SMTP id s10-20020a170902ea0a00b001bb598a14e5mr24227444plg.43.1696957519183;
        Tue, 10 Oct 2023 10:05:19 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709027b9300b001b89536974bsm11979868pll.202.2023.10.10.10.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 10:05:18 -0700 (PDT)
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
Subject: [PATCH 1/6] RISC-V: Add defines for SBI debug console extension
Date:   Tue, 10 Oct 2023 22:34:58 +0530
Message-Id: <20231010170503.657189-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010170503.657189-1-apatel@ventanamicro.com>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add SBI debug console extension related defines/enum to the
asm/sbi.h header.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
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

