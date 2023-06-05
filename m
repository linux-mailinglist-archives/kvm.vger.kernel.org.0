Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4D7722820
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbjFEODR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjFEODA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:03:00 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015F099
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:02:53 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-546ee6030e5so2280341eaf.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973773; x=1688565773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=h1UIkEssFqK/OyGXZPvE+qf22Kj/gvX4gPEyPctsS6HDQbhR7m15U93R6kYSRzl+9E
         rap+p/DtXXIbc8wKDNK2atmsizapz+PL3QlX1nZrNn+FpKY2ATzS7bzxhnol5zVpLMT0
         VbXwP2FhJj/gZnP1a2sJL7gY3zWmGOoUZUeYc/bmVwd1ts8LTXOEV/6TdPPtCOxX2lER
         NY5PuMLhjjolPQMHFc04GkQUeCEOsc/BrT5LhMGO74oVctjqY8kC9Bnu4/JIe5zU8Id9
         eruXTBD4SOe0IYzUFJGyaz3aTXOtxsDcF4CrjLbdxGivmou2Kqn/X568EasCbYSCKNq2
         wt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973773; x=1688565773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=Y9wYieRQJVyWbwqmJac+kRtQqV41MV93fkfd0lYESB05E7SBXc4Rb7QrdTx7DuGJ7e
         NwLMihZ+rs/ChKkkHoRpZlk7SBhmoIVFtP74ao+SCG3wPNVqvjJVVw6UGlR8flYLrsEL
         bhHuXBbOBP88xUc3eHxtjRHTfIKy+j5htYZm1gOIw2hAlVbFyj7hFX6Q/v22BfLBnV+x
         yojxAi/M9T7Zi0rSV+a43XVT5TdzEXEPlOI6bUoqluRF3hQPeOCg+jTSG7I8f48l0Oia
         Toj5CdVPXlirPyaNvgd37Wl+rukpZPYhM+uW5Eypaimkj59npx3KqwfFt7JM85mhG/Xq
         UJtA==
X-Gm-Message-State: AC+VfDytQ7CFhrfhrbbBNphzQP0pGMI4++FMZACa24CpXHAAu3y4iX7c
        hg29Mw+x247Jwr0UudcGTfAn2N/OuaGHICqXwvqPRg==
X-Google-Smtp-Source: ACHHUZ5TqA+i3l8WYWBJJIozpVnN4+d7sRJ7TF5UIwRBbeTWKKCLvzTohF+i5gKrxUJIgVr6JlS2Fw==
X-Received: by 2002:a4a:d48b:0:b0:558:b482:c3b3 with SMTP id o11-20020a4ad48b000000b00558b482c3b3mr25427oos.1.1685973772504;
        Mon, 05 Jun 2023 07:02:52 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:52 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 7/8] riscv: Add Ssaia extension support
Date:   Mon,  5 Jun 2023 19:32:07 +0530
Message-Id: <20230605140208.272027-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230605140208.272027-1-apatel@ventanamicro.com>
References: <20230605140208.272027-1-apatel@ventanamicro.com>
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

