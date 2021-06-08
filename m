Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA439F899
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhFHOOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbhFHOOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:06 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F91AC061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 07:11:58 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id k16-20020ae9f1100000b02903aa0311ef7bso12070282qkg.0
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PeB+UBqReCGwpCjLlz829AwM5AYc1PkEdvHShsb8BsY=;
        b=thWPfhDKbF5s/ofjUoC618+2dp0pJ6SpArtej3SQV13eC53nY4my1hjo7wNFpjVTmK
         yGHlTgow8y7JhOomXXHMNqFfSQSCw8cIokbKDoG5o8uO/iw7Qz6I7L8zrZxSbtXCzw1E
         kH/kMWS4ZwSMu1APA9ipWbzroPMlnqFDdilyUsvKU7we20dnh2MdNxQj/ueOjOzZIlce
         dvugoeETqCejcNqjuKVcyI7KqCyZqEpCBTDKP43wzWg0yoW2mQ6+Czg0ver96xkdKBTr
         aKVDAXeEKI+h1lKlx25/Q9MvHfUl61FiuWFkvdUtsjsPYMWPEP7y4r5aT8G48XkWtFRf
         d30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PeB+UBqReCGwpCjLlz829AwM5AYc1PkEdvHShsb8BsY=;
        b=dDiu+6F+UpSCxP4rzoKrG81AvQ8O9X2+pbBHHUjal8dXE1w1YvFuy5PUJyOTRDN8nt
         Ddm9cKT051jvUbUdHzA/L2Z6BFo0Xko6I2Gc7WLhrpuiVSHyNpiaMrDJBK5G3KVDSLFF
         DCG5XT2JsdLGGE60KVvj2VriMsXMXSiLx/C8a5j3i0shv652lap2oAm1VzL2UnXKTMa6
         h/ljPJBcgjX2SwWGlG/3ntCTWGQLZoES8bALu1wOE01HrOhvMzAQMmAXKVrFIdMog+jq
         DU1H0M0RtLQsO1Hg/2OE78lhwGHkEt+qvTYMRSrIFRjP2v6w5zxIheM/JuDl7Bc/bR+r
         V0mA==
X-Gm-Message-State: AOAM533svJyExhY0z4o4dLq1Cifi7FVDO+DSockwAXpJGxb6lGZ5uWGW
        3srA2PMef0dMeR3MIZrtugs8rnlwDQ==
X-Google-Smtp-Source: ABdhPJxb527Ok9dzKMDfpH0rL290/po/5ZdFVHy/rNH6MII/RtyWRGkp6JE/bCw5MFqPLrEii301dtlmdw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:5561:: with SMTP id w1mr23725500qvy.47.1623161517455;
 Tue, 08 Jun 2021 07:11:57 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:35 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-8-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 07/13] KVM: arm64: Add config register bit definitions
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add hardware configuration register bit definitions for HCR_EL2
and MDCR_EL2. Future patches toggle these hyp configuration
register bits to trap on certain accesses.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d140e3c4c34f..5bb26be69c3f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,7 +12,11 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA		(UL(1) << 56)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -280,7 +284,11 @@
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
+#define MDCR_EL2_MTPME		(UL(1) << 28)
+#define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_HPMD		(UL(1) << 17)
 #define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
-- 
2.32.0.rc1.229.g3e70b5a671-goog

