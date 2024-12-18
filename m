Return-Path: <kvm+bounces-34059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 063FD9F6AA1
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87EEB7A6A88
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 15:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F219E1F427B;
	Wed, 18 Dec 2024 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b8mUUmR9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C991F3D4A
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734537570; cv=none; b=IK3743+K0mgwVCau56aQHtVBgfnHtnYUE7aaOpLgTHXNyu9sX0Cevny9vR/GgggcXsUUv9goYMrVKhkqlW9rIXE/Mzu73Tkew7gGsDHLFTGZa1tW+uwno85yA1uyvrlSqKf1Q6tfd3Fz/gY+bx+EPsHHWINTDHkE/BCZsavspoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734537570; c=relaxed/simple;
	bh=v8hqcuzrZzr4qwVBd7sj2nNF4HhDfzu2xRy0ZI6lxjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OM3EmwCXdHto0RKYwOMaibik8w8x+T58w+S8OnqqL16xE1NalbJLgEG1fQ4UTGZHHhSKfYbPsQ9xQu3GX0hCWm9F4Z96rDhtG/xF2loDOLvxTXMi/bFj5v+pGLCELs0YVEpIJagK0tbsZ1CGH2enWVGZ0mkztl3MC3RSYP1t5zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b8mUUmR9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4361dc6322fso44790345e9.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 07:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734537565; x=1735142365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVrC/xB4J4W5X585RY4Zqal4Bi+Ph7neB+RzuTzMwMY=;
        b=b8mUUmR9MvS8kBXh3NAhL6pLGmxgwXPeXJLAZLjIM+eGJ/NU/h0i32i9hZmgngeoOu
         4YPwHZAEgzBwsRM+Qy4BhpwcEHfN4jblsZQXnEuxO/NzbAIbNMwZzy/drMppwBYL8sNz
         z2c1JYGDnwTad1TJfi9ZVRa1xoruk4RtXv+RBdR9TEh40glRqd7+Ed9lRUxMIZH7Xazy
         zgr9G5Zog3heZk1MUGQe2wp0EbAgH7MKnFhoS3/O9hQu5NaCTlnoPz8GoVdptPkFw2Pe
         Mh6Mw3BIYHx/hnMWg441kDTbw1cPqTRfrk6qiZx+6MpEDhYmP00ykjQiGNgm0OC4ahE6
         aF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734537565; x=1735142365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HVrC/xB4J4W5X585RY4Zqal4Bi+Ph7neB+RzuTzMwMY=;
        b=uLv/lIaGtlDbOYldFciePTrwEjuF0lmLrEs+HbKou9FpkIxL2VNf/uzJs8L89ZIZ51
         pVA34k2Kfr+RgiT3YP2ZYrwcdnp/XKIDW50bBmNX7NqJOq1hDdHiRAWlt0lEqp9I46s8
         cMqMsFpbtM0rVx19Zx9Jp1wmD6HFA/nRzu6RSZ76W9NjvN1q3VeXhP9jLotYSNuxpg/n
         ejrAazJqjMbqocrLhx6lEZ/n9F4/b9txDjfbcQURaKYUbGiJSaQiip78qkopinm0cKcV
         C6zDbda2TVNmFpQT3MWJCr/UeV14sJnSEeii7xYl5aYTsnU+cch5x6brh5wNac98kk9r
         1sjw==
X-Forwarded-Encrypted: i=1; AJvYcCWzzQVgfcHpgjKNPpHhBcgn1/2GMeTcjT7L/YuhRIhYLiw7/spvwXg9M/UPnU9ZbPztLZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuOIXHO/ZivxstCbzWjMm44gO6Rkh/zTEJq4RciaWepbbQ2xBL
	ZdlkB/dgh374+gsAuTxc5U4On+j0H4NYsjs2rMBGf9P/9GyAHsUpg/yDGI10MMI=
X-Gm-Gg: ASbGncv5oABos5uOOnsePYgcdnnRi9+aPGQlO56wFzfkkYILCQOZI4HSGM6AVAj01AU
	TgX63hBsrp8n+2NGFRhq/cGHSmFkWTckj8l4IShtVxvo/46PPxBTNW1/LhpjTEFBX4kOFm3rISw
	s7IVzVvesIEMuRr4vCZ2ZmeZ+4xUnfZoMFUp76Rv7wJmLjekKHEvp4DsMDtysY+A0HD6idWoobE
	Nn+de3evfPCbYCPzSnypXPHxXnT2YWBVdHX7lWMi4/57vc+y/51JzTuvVqhtRD6ZnZp/Rfe2sei
	FWQI
X-Google-Smtp-Source: AGHT+IE/GsnVIVpBHu0FzqISExQ4TN/zyNddvEngW8uvxopkfrRRPMhL0arlvZB2uk9iMPH3fG20pg==
X-Received: by 2002:a05:600c:35cb:b0:434:ff9d:a370 with SMTP id 5b1f17b1804b1-436550b0fe8mr35114405e9.0.1734537565061;
        Wed, 18 Dec 2024 07:59:25 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b01b73sm24760955e9.14.2024.12.18.07.59.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 07:59:24 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Eric Farman <farman@linux.ibm.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-s390x@nongnu.org,
	Yanan Wang <wangyanan55@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
Date: Wed, 18 Dec 2024 16:59:13 +0100
Message-ID: <20241218155913.72288-3-philmd@linaro.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241218155913.72288-1-philmd@linaro.org>
References: <20241218155913.72288-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

"system/confidential-guest-support.h" is not needed,
remove it. Reorder #ifdef'ry to reduce declarations
exposed on user emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/sev.h  | 29 ++++++++++++++++-------------
 hw/i386/pc_sysfw.c |  2 +-
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/target/i386/sev.h b/target/i386/sev.h
index 2664c0b1b6c..373669eaace 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -18,7 +18,17 @@
 #include CONFIG_DEVICES /* CONFIG_SEV */
 #endif
 
-#include "system/confidential-guest-support.h"
+#if !defined(CONFIG_SEV) || defined(CONFIG_USER_ONLY)
+#define sev_enabled() 0
+#define sev_es_enabled() 0
+#define sev_snp_enabled() 0
+#else
+bool sev_enabled(void);
+bool sev_es_enabled(void);
+bool sev_snp_enabled(void);
+#endif
+
+#if !defined(CONFIG_USER_ONLY)
 
 #define TYPE_SEV_COMMON "sev-common"
 #define TYPE_SEV_GUEST "sev-guest"
@@ -45,18 +55,6 @@ typedef struct SevKernelLoaderContext {
     size_t cmdline_size;
 } SevKernelLoaderContext;
 
-#ifdef CONFIG_SEV
-bool sev_enabled(void);
-bool sev_es_enabled(void);
-bool sev_snp_enabled(void);
-#else
-#define sev_enabled() 0
-#define sev_es_enabled() 0
-#define sev_snp_enabled() 0
-#endif
-
-uint32_t sev_get_cbit_position(void);
-uint32_t sev_get_reduced_phys_bits(void);
 bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
 
 int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp);
@@ -68,4 +66,9 @@ void sev_es_set_reset_vector(CPUState *cpu);
 
 void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size);
 
+#endif /* !CONFIG_USER_ONLY */
+
+uint32_t sev_get_cbit_position(void);
+uint32_t sev_get_reduced_phys_bits(void);
+
 #endif
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index da7ed121292..1eeb58ab37f 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -36,7 +36,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/block/flash.h"
 #include "system/kvm.h"
-#include "sev.h"
+#include "target/i386/sev.h"
 
 #define FLASH_SECTOR_SIZE 4096
 
-- 
2.45.2


