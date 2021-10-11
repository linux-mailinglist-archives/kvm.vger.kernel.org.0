Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519454296E6
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 20:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhJKSbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 14:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhJKSa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 14:30:59 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BDCC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 11:28:58 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m26so15567985pff.3
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 11:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bOgrf0vCcS0nDoEQKqJrhzvhgl7B+OzU3kwGKzv9V4k=;
        b=IDx02X2BDJucdWqDPDARblaJY7PEA4qY5KK2wFXJhdGUaHg/8VRKYa9ioOlVI+63dh
         THYp3NQJQfMq9Y8atB3LgnwjOr9SLapy36UPkei5cyCJ2zv8fWjoBQq+eCSzQTLPzdH4
         bUmucH/UNP2tOG/5wTJ8xThQWUYxCuy7QZ/lM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bOgrf0vCcS0nDoEQKqJrhzvhgl7B+OzU3kwGKzv9V4k=;
        b=WDdQkZoOmq63Yxd2vrcJ6M7+5wUFPk/L+xSjRbnoHALpRmzefJhNJfXsidmJtIvtSF
         LWfl7QsqQRjVOXagV3BXkAMpO2Bz+sRpPmmLnjFU2pNJiymGqWgpwxX1dhwpkkuABBMm
         9iMBV8r2JnWQi6eIDXr87JW3T4JqyIjGvwoeDTzpyOEVP0PZ6vV5Y6n7ZRaDra++3Hcd
         pLBtt7XgWGeBjb6+/pIr+yrp0JdG3TKAqDarTbUwTTJrU+5iqx5CREiKBI+25bBZ6TAn
         p4aOY/QrALGkU4suAy7Qsr8rIJ+qq422JZ2UOdfISFP5uKrxxdT00uq3IViieMBaXgFD
         PAtw==
X-Gm-Message-State: AOAM530B1m1PoZ96jczLeYK2oSrhcEv6EGNhzQ4kqcUGlthZgmgqqpGQ
        bqyanDk6isQtePhKMwmjcf6ZWecQWLGVIQ==
X-Google-Smtp-Source: ABdhPJy81hp5mvm4xj3HpVd8uLSIPn/G7fKR8PNZwlZa27WJezdnTv/bflRPFDsVNIzV8OUwTqqVWg==
X-Received: by 2002:a63:490d:: with SMTP id w13mr19645130pga.481.1633976938248;
        Mon, 11 Oct 2021 11:28:58 -0700 (PDT)
Received: from portland.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id x7sm8567230pfj.28.2021.10.11.11.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 11:28:57 -0700 (PDT)
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org, marcorr@google.com, venkateshs@chromium.org,
        pbonzini@redhat.com
Subject: [PATCH] kvm: Inject #GP on invalid writes to x2APIC registers
Date:   Mon, 11 Oct 2021 18:28:53 +0000
Message-Id: <20211011182853.978640-1-venkateshs@chromium.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upper 7 bytes pf the x2APIC self IPI register and the upper 4
bytes of any 32-bit x2APIC register are reserved. Inject a #GP into the
guest if any of these reserved bits are set.

Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 arch/x86/kvm/lapic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..96e300acf70a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2126,13 +2126,15 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			ret = 1;
 		break;
 
-	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic)) {
+	case APIC_SELF_IPI: {
+		/* Top 7 bytes of val are reserved in x2apic mode */
+                if (apic_x2apic_mode(apic) && !(val & GENMASK(31, 8))) {
 			kvm_lapic_reg_write(apic, APIC_ICR,
 					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
 		} else
 			ret = 1;
 		break;
+	}
 	default:
 		ret = 1;
 		break;
@@ -2797,6 +2799,9 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data & GENMASK_ULL(63, 32))
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
-- 
2.33.0.882.g93a45727a2-goog

