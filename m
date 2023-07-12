Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB7750EAE
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjGLQf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjGLQfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78E5212B
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:35 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8ad356f03so47381215ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179735; x=1691771735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=FS20krKxJ3LSntbyg3reAkL4AF6lSeclgAnHW79/6w/OZDRp+/KhloWrjw6CRauuOP
         YbUJ0pedzmFi5WsxRbzNVfKQth6xkohebLZv+AaMIH8ukMr51PLGfoj+gPwisdAEa+WJ
         s3/HKUfreYNt3UeexOg4VvBx/PxD1JYvqfx4akGUZfTTOvIGOSRKbYE9nHBdAhnLUW1e
         YpOU4s4rrSPIJwQcPQXYFES47T02NJ3mFkRcuulqCgadHIVdnzUzPe3KzMAS8tf88yhM
         18dBH9j0oYUak9QxUohvysxPwNIFnaKj8JchK3dV0igVtbOeTEgLhGpv1fQxgefTX5Xe
         YPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179735; x=1691771735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLxp3S0f1awUfUEHEN2CCeWxyqxQ+kK0R236OPFTD+Q=;
        b=laKPtDCPy9eu1XpHwA+tU793tzpYASWOi20+B9mSj3GIICXIh18E/1b8GScwBfKjAy
         FTEmwkDRRmkC3vdxaIU4luGqGndHAJofz5rrzc47SwY9SZ/SJUKpxP+4ECMk3YfJ3HXo
         dWxUv4RyFsFXJBQeOIc/PD3lGiORg3h3T+/hbSj93gAiiCat4M+MgQjJi0BYFXWqUMlo
         3XFnlliWJnDPzknQCnVVk5DR7ifqoGS2MI5Rl3vOdf8RiTwQxBBXcgQjq/4Xbqh+/0SF
         5ueHW+NH9TtOh7lbQ9YCtYFByYE8em835k/Rp0EM38LnZFQxPDfRPs/cISu6PDta4NT5
         NsDQ==
X-Gm-Message-State: ABy/qLa/j/ktWD02B+b7kaJyWKP+mF4Znsw1QUoSAbr1aLSYP33cRmtq
        uyqxxjOQqsD10MYjLDpl6RHQbg==
X-Google-Smtp-Source: APBJJlHqztFbz8SoI/m9yVzuLangP+E+KRDK3xl+4HB4gJ9UkMsZomgIo4odxhThZ2Hny0p/aE+HOQ==
X-Received: by 2002:a17:903:228d:b0:1b8:a3a6:df9c with SMTP id b13-20020a170903228d00b001b8a3a6df9cmr17068600plh.60.1689179734850;
        Wed, 12 Jul 2023 09:35:34 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:34 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 8/9] riscv: Add Ssaia extension support
Date:   Wed, 12 Jul 2023 22:05:00 +0530
Message-Id: <20230712163501.1769737-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

