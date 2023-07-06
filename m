Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8044474A33B
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGFRjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjGFRjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:39:18 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16341FF3
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:39:02 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-777a4c8e8f4so37119539f.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665142; x=1691257142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=TEWDlG4oUegNL2J0vzFjS+W9KildvxTVcRfhBu7LbYWaIns006vSrEuXG1HdDMRWa8
         Rpz6hRxot/rbtP56LfycyOJuoS/WyjoAY4Fu4Oq4gywwbgpm3M2FxKH3cIP5YtHE+qM1
         +gmZVNWbqWXCQdnC6IvkjPZUc8FN3ce4GZ7z0/u9ZhhdlDejGfOuXCap/NH5Fr+ZuxLV
         f6LZV0l1wc1huObk84uXk/Hh+x2YnVGaM/vBpCtCMqsUURaL9rA7Ehp8VHodHIDN4z22
         FDkdlYPG6NANdIuxQfWKTBduVE2Y5FHb+xIugoZocwJZ639HjMQq9QmBojXdf1VR8d+g
         4dHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665142; x=1691257142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=FoZgb9EcfZFYg/FcREvfTDnuynXa0f8k/q+oU/HtFRRuKs2A6RdBqcWCRxyxzyd3yK
         KOCwocxN8ldmMHSxF/dfltikdpEbBRRtTj+xrSikCOGevZ94odx+/fIezZhItJYLiovG
         VEnnHOCvk1/bG7fw3eY9oe2qukHn6/r2JKvAUyokZ/wZAQnwUBfFEFVZEEN6SOykw6am
         CluKys+9B0JOWRLQDGfkJu1ZuBRCVAHPrFILZv0BQEamOqgVqZ/+euN0bjTaqAHx2fVO
         kPbmQPHThpsODLPSPXJSQTf8r/xlyoeZuyPXZfCO9HQEmcmRb9QirukuV3FNsEVcQ2pU
         zS2w==
X-Gm-Message-State: ABy/qLYd8FSjbZe6RWfGviPrAEB9HqgjPkzt1Z1LfNVfZ4MHu9wBLF2z
        nXH9l9W95mhH2DliCpYkHRSlOw==
X-Google-Smtp-Source: APBJJlFtADMUQS1jcq2ft4S/AVTrWLbxD9UF9L5+As8nlmdRCGnOWyRxrQJYo70BO2clMqPfsmpFqw==
X-Received: by 2002:a5e:891a:0:b0:785:ff35:f340 with SMTP id k26-20020a5e891a000000b00785ff35f340mr4337782ioj.14.1688665141990;
        Thu, 06 Jul 2023 10:39:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:39:01 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 7/8] riscv: Add Ssaia extension support
Date:   Thu,  6 Jul 2023 23:08:03 +0530
Message-Id: <20230706173804.1237348-8-apatel@ventanamicro.com>
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

When the Ssaia extension is available expose it to the guest.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index a76dc37..df71ed4 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -16,6 +16,7 @@ struct isa_ext_info {
 
 struct isa_ext_info isa_info_arr[] = {
 	/* sorted alphabetically */
+	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index b12605d..b0a7e25 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -25,6 +25,9 @@ struct kvm_config_arch {
 	OPT_U64('\0', "custom-mimpid",					\
 		&(cfg)->custom_mimpid,					\
 		"Show custom mimpid to Guest VCPU"),			\
+	OPT_BOOLEAN('\0', "disable-ssaia",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSAIA],	\
+		    "Disable Ssaia Extension"),				\
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
-- 
2.34.1

