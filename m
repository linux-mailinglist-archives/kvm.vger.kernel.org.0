Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19E72281E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjFEOCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjFEOCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:02:49 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAF6114
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:02:44 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1a1fa977667so5177736fac.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973763; x=1688565763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=YnMic8R/yZ2JVJq8xDm1NbuZhbrmUInzp4NxsbCyD9Y/uhknauvqBYsipxf9OwCqSE
         X2yMBEliAjKYzjQJyf10+ssPVmUfpeP1gnneO2BimxdplXmDutEIs64W4nwL0SIhX2Vi
         Z4wfB534s/sna4RuIBaBGfSa2FP/u0gstwdv47iLt2jhvkPL5Otd6HcXcrJdgODS8grG
         gL6Bze4n+rP5HymtAUZWWWb6DlSgSmDIqQYpQZwUSpWF3K83ljltO6PIi08TKKvXmzq0
         Pkoi7qmL9mhknLoJ1xU9Or/8M6glMuxXquJGtZ7q+7T3Mgt8gdhX/jJ0PoyJWd/6rA8V
         hy+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973763; x=1688565763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=NFadzVHqDLNVZqUsZAgJJV0es0q5PGiTzyVejQhzl1HMyDGzVK8MK5Kw/IHog8jKyM
         P16p/HT/GIbTwzeuOgOTCHRbe7FM/zBY+wXTE2oNMSvaxijsiZ7qjvxWwDw/jWVG/VMc
         KvO6Lf7N8xiR/0XhNdztu6M+cQgC+knvpkAmx+b9FwdLxBo7gpX5gIdBn+JC1d3Ee2Yr
         mWP4esmofD2tUHEdgutdsCx8TXd5a1M7JVVannyg6tuNN650ecKovPySVar1Rd9Noweg
         +QYrytM1v/E91Ts8TlcqSzLqkQM7y5XGuEaGid7QHTmSErdIFR9O2XbeAB5RLYmUOE83
         /ggQ==
X-Gm-Message-State: AC+VfDxoE+3uTVgp1Wvz1b+D/WikFTgRYjg1xBAf59EgSxpmBT9qzh/6
        R1wjl11ymNF5g3WpRN2z3+LOztjbpP6+QAcO5qFYQw==
X-Google-Smtp-Source: ACHHUZ6mwht1zonH2R3L/qxR+M13wiFxhacllWrDC6onv1y7/5hNJsknvAbpW3d7+TuMIU0AGMdMWQ==
X-Received: by 2002:a05:6870:4146:b0:1a3:74e:7863 with SMTP id r6-20020a056870414600b001a3074e7863mr2319857oad.4.1685973763467;
        Mon, 05 Jun 2023 07:02:43 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:43 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 5/8] riscv: Add zbb extension support
Date:   Mon,  5 Jun 2023 19:32:05 +0530
Message-Id: <20230605140208.272027-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230605140208.272027-1-apatel@ventanamicro.com>
References: <20230605140208.272027-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The zbb extension allows software to use basic bitmanip instructions.
Let us add the zbb extension to the Guest device tree whenever it is
supported by the host.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 977e962..17d6757 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 };
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 56676e3..8448b1a 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -34,6 +34,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zbb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
+		    "Disable Zbb Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zicbom",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
 		    "Disable Zicbom Extension"),			\
-- 
2.34.1

