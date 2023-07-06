Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6D074A339
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjGFRjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjGFRjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:39:02 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1184C210C
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:38:53 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-76c64da0e46so34299739f.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665132; x=1691257132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=ChscjS7xi5bWmvQTkCoaq5iCQEbC5OT6Xz3XIIzxZUMAfpHKTvMjKVhf6LQNlPdWj6
         TH9OpwTyo5iLGye2nNSnWhH2GrlYlxzlvL2a7csv4BtK6aQQ3U4uLv5wqz7gM/VuTCsF
         UFA04oojXHHalyFp0TGhjDGUoiS/2IOq/StS/2uOMZ18LxqLyjc+ZtHHDjCorEoJD/k8
         pKUbKswxqWsB8FVYwWGMM8q1Zy53vk5lAzdy0I9H49PKwHxHmVt5Pc/TemhIn0zBylD4
         1dhOMdpJR5U4vCDN19mwnKJgyXT0YGDzgAVX8ZHytbaJzMcax1LksRojqcD/SlCUr8ZM
         +N7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665132; x=1691257132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPQWdMrB3vJlDcEi+yFf+uGq+ry4kW1YJbGepQr4/gM=;
        b=YkZ+j0w38YROfcKvLpBoVjaplEHn20TX+AEHqoM65D7c+7jg3UQKfHyaBD4yUkwUzS
         /lb3RWfmksLOjCBXK2zLg/NVwuL998US0GTt/kvqNjuJX66r2VjiKGDvoa4eUG0vkFJq
         WnP8SA6LTWfTBJKIUqBLwpz4moEz+ci7DrCcVWFcZ9JtyHEbNMRlgvPN+YPm0XyL8wQe
         RYXSqN+gik2mVom9ByCwrFETpwmezVHyXoNZyKG4/rnkk/4PvN/Tw94qoiCCxqzxOHYA
         Yx0sdmbDOZUvSsnLci7cRfL+3Bo3RKiYhzTluNuDhoQdC3DaaDco/PMmQieC688yq+7z
         qgeQ==
X-Gm-Message-State: ABy/qLZzUQuCOotGTKmw87+rKhBorR8DVlad0dqKvb8gMCoAe8rgGkko
        7A5l/D3goxsLdWE46XnHeRNKaA==
X-Google-Smtp-Source: APBJJlFfZyjnNopBMKmNevv6TQ/29A1wln9nnX8dJFl55R0cckpdRWcJmQr4+RgdeLoztFzWF3cQKg==
X-Received: by 2002:a5d:9e1a:0:b0:783:491a:13fe with SMTP id h26-20020a5d9e1a000000b00783491a13femr2743227ioh.5.1688665132238;
        Thu, 06 Jul 2023 10:38:52 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:38:52 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 5/8] riscv: Add zbb extension support
Date:   Thu,  6 Jul 2023 23:08:01 +0530
Message-Id: <20230706173804.1237348-6-apatel@ventanamicro.com>
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

