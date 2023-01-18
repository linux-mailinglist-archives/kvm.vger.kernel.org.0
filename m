Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112236724B4
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjARRUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjARRUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:20:15 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6114EBE
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:20:13 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id z5so33613000wrt.6
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CPlZeDlP3K2O68f6cRu29S/V8m0qV1aEJTBSTQwuMVA=;
        b=p7g0n5dhXwa8i2YTjlfirOZDol5cFc/mF/G7Y41HP1JQgA5ToAucAlXZN6V3YsRxRy
         z2uWauyIyiEzAU3GjVKnApfwenUU1ZtER+skNG+TYBciTpQvEhEKA3nPygfIAIVhihYa
         omzz5C5JyOUvtALBascu5PmQkU3+V8M637WTNVtSqiVicABJyhjLfxuL9NuzxVigks9v
         S0mFLKu4rBDbLETtHs8IhyIARLWeS6CE9Rc8q9aj/zl6msTzyzyQO2GFzsxUZeBIJ06S
         jqDBMMfDFWcneVJdIoNpQgbEdyD7bSSVwmUPF/YFyLM8K9P+HkHDnG4/dSUnkIs8Vc1e
         FSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPlZeDlP3K2O68f6cRu29S/V8m0qV1aEJTBSTQwuMVA=;
        b=YdF+v1HvQMMQ0bv+tq1Ic9fT9/iOtS+QBXOqMUkwt+TPBWwVZ4pYxCj3NkA3ooBJqN
         UrDjMEsGCdwTGFrvFV28ojvIXcgv4Y/rm815NaoPz/7zBqpUXUW8tovxqvSo2JmkRbuN
         cX7xJooDOrFS43LjvMWZNkRaptAl5iCr188aZzcjaVnZO/fE1CKVxpQkQfKytWz8txlI
         +oM0Rp+1/t+Mfh1XeHstLzixE3IJBh1ulsLzHq69uFPA6RriGLITAi1NX6C4Rw+539uG
         9WBebTdtX09gJXLeqOP2IINF/lNgYkqesNRYnuAc/iwkdvZp4OA1/V5AMLBn/YFXaz51
         vq1A==
X-Gm-Message-State: AFqh2kqZL6BZLlup5soSwfoAN7cB6nqFuOpccnfFYNV/4sj82/hgAMZR
        Sh94yAQN+zoKsIiGBQMfj1Wb75Q87bdMiwKw
X-Google-Smtp-Source: AMrXdXuNNj38dSN82gGzVLj7c58r1shl8qKMa5J+t/eSpc5dFU/4QW3GQtqFQ87t51klO+k4vs++nw==
X-Received: by 2002:a5d:5584:0:b0:2bd:c19f:8e90 with SMTP id i4-20020a5d5584000000b002bdc19f8e90mr6848978wrv.7.1674062412561;
        Wed, 18 Jan 2023 09:20:12 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id w4-20020adfee44000000b0029100e8dedasm31631541wro.28.2023.01.18.09.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:20:12 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     apatel@ventanamicro.com, atishp@rivosinc.com, kvm@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH kvmtool 1/1] riscv: pci: Add --force-pci option for riscv VMs.
Date:   Wed, 18 Jan 2023 17:20:07 +0000
Message-Id: <20230118172007.408667-1-rkanwal@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding force-pci option to allow forcing virtio
devices to use pci as the default transport.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
 riscv/include/kvm/kvm-arch.h        | 6 ++++--
 riscv/include/kvm/kvm-config-arch.h | 7 ++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 1e130f5..2cf41c5 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -46,8 +46,10 @@
 
 #define KVM_VM_TYPE		0
 
-#define VIRTIO_DEFAULT_TRANS(kvm) \
-	((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO)
+#define VIRTIO_DEFAULT_TRANS(kvm)					\
+	((kvm)->cfg.arch.virtio_trans_pci ?				\
+	 ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :	\
+	 ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO))
 
 #define VIRTIO_RING_ENDIAN	VIRTIO_ENDIAN_LE
 
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 188125c..901a5e0 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -6,6 +6,7 @@
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
 	bool		ext_disabled[KVM_RISCV_ISA_EXT_MAX];
+	bool		virtio_trans_pci;
 };
 
 #define OPT_ARCH_RUN(pfx, cfg)						\
@@ -26,6 +27,10 @@ struct kvm_config_arch {
 		    "Disable Zicbom Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
-		    "Disable Zihintpause Extension"),
+		    "Disable Zihintpause Extension"),			\
+	OPT_BOOLEAN('\0', "force-pci",					\
+			&(cfg)->virtio_trans_pci,			\
+		    "Force virtio devices to use PCI as their "		\
+		    "default transport"),
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
-- 
2.25.1

