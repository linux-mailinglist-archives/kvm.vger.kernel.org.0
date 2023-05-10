Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33A76FD9A4
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbjEJIjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbjEJIjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:13 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536BAE76
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:32 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6ab13810d34so1502848a34.0
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707911; x=1686299911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=JxCgASziri3weB4Vu1dJjlEzQBoDekv7AMkt4P2rTJf3OfOSBxFNyITmnUtPMvrpIi
         RA2JDlm+UsV+6lxNoIftjTbPE/pf4G8oZf3wNouGisjOJzLHV7qjDGrgMw141IzlgRMY
         MrZSY+cXlUblAjyu61nNjpw0PITtIwVAZdRNmeadIN3XxcnnzNUOOgMXTXgK3IQ4dCmx
         MO2gQ4YdWzX7kk/G2cNE6bAFL4aI8phwRkYYzynoUvJZ79pNsOmzf7lZZlyxWz6wi0EB
         cD5RpNVdXYGjok39W6dsUdkvOJ/xYwJniZ4QcHULtkNmOvBZpdM0gneTVU1ggygW5Z5s
         0oMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707911; x=1686299911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=AWmIUuUXLW6v4dFjGuADvyH/tbKh7ag2hobAH1M0Kq+DcLOAkfrmnZPA4SC/0Qv08c
         104tN7X3w2O4y0RDisOu8TDR9Jkuxa5Zc9z7FcoSCDd8dTOrVPjcGEBQTcSpPDzn6bXk
         WrWIXFL01D48cjposQo1kJeM2D1/DatbV+UEnslMYtwQGtva1cdrX1Xc/g++qLah2OVL
         mgBLJfZPZimBARumBYF2LZVRUX8wzG6TogafI+CqtqPxbIAqMAJ+qHTRuAsywFc4UnHd
         rrN87cOtB1LCkmc3AnqKulTjcdV6WtJ7s6HSBU0JIfVPXwlmWCu3zVH0Gx10soOpltUA
         s4bg==
X-Gm-Message-State: AC+VfDyQTXSCmSmoJxf9dKCLUlQOhDEz4Pf8iO6ICgfbxTD7eG3qMau7
        vbqQWUnXl47C2Zii1kpoK4SoTQZZibDqjcZRjUE=
X-Google-Smtp-Source: ACHHUZ5vghWiHKJMTwFxxDpmAaPOUSO7RWEiLkUF6ExcD3o52ijUX+uEgKjYkFf+IvjSadfu6qv5eQ==
X-Received: by 2002:a9d:7489:0:b0:6a7:b2d1:9bb1 with SMTP id t9-20020a9d7489000000b006a7b2d19bb1mr2514672otk.38.1683707911431;
        Wed, 10 May 2023 01:38:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:31 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 5/8] riscv: Add zbb extension support
Date:   Wed, 10 May 2023 14:07:45 +0530
Message-Id: <20230510083748.1056704-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510083748.1056704-1-apatel@ventanamicro.com>
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

