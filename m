Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC93F97F7
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbhH0KRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244492AbhH0KRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:05 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778D9C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:16 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id k12-20020a05620a0b8c00b003d5c8646ec2so3266510qkh.20
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KX8dWkVT+7qp2o5wgzztnL/TjK4rsIbskb1FytAuhHQ=;
        b=IIOfuk/8nIQZSSjOcxde0I6sd1i3XbS/k4mpqYXVxXZs7bIPMgKrNkS3KWZcguE5eQ
         0Fa27eJ+SO0liN88PqhjvNhLct4wCDiroSiV9TFlHhQuFJrEv4ulviWgZPk8CT9Pumpm
         BJJ4iNC7UiJYT8tmQl2ni41OY6GsMh33R0FDK0wxiAHLd66DLL0sPupulyxZnDj4DE2s
         d68YtA5/ntycpLiPXcuQOKAhzEYo+IpYowcw8YXlYfVx0MrIUUJ6r7SIxGCSRWKk1w7D
         mnVKku6jOaNaSG4YMod+1f7XSvyDY9dmx0UdR1E9S/gV7xh9Vq63ZGTsq/oN8ETXelrl
         71RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KX8dWkVT+7qp2o5wgzztnL/TjK4rsIbskb1FytAuhHQ=;
        b=AdQaRi9ESaLKN9R72NTIvtMzKuSm+Z0zXom91v+Dag3p0TXGYak7lk0o34mI2LGc6F
         HjbthUQc3xa1yw2geaGA8QKBtGhmZbyjxF8Z2b0EZLuXXVVGDWpjXgy0XiTmahtOJIbv
         a+358pCpvhDQeC+GxyEXMnMGMLYE1cAbXLriC6iIw0dcgq8qPTKRqqeMMRQ2FtOD/73z
         tneyD6Hb+26TbO71B2vCJ66XggNCcXaKnsGiz4eamj0d+vXViLz+NBdqXgRpgS7Q/AiJ
         RaUs8QpUre0vZeEK/HfrXdoq0+JQKKLbrV1ik3Nce33mAe8QKSK9RN9piAWO+2YQL6fb
         mgJQ==
X-Gm-Message-State: AOAM532ZpG/VvirG+3UHWfjBxLZHURr8olQ4GWsFC5VCJyHj2fcmCIcw
        JU7soFxJGJrSfc3s/Puvm385RPTFpg==
X-Google-Smtp-Source: ABdhPJyLOQHqGi7X3qrRZ3x7KXpEc+43eQb9QgrNWhLDvOaIysfhOoD6wUPEKMylthJrErCd+rKMH1n+Og==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:e803:: with SMTP id y3mr9071549qvn.39.1630059375607;
 Fri, 27 Aug 2021 03:16:15 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:03 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-3-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 2/8] KVM: arm64: Add missing field descriptor for MDCR_EL2
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's not currently used. Added for completeness.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 327120c0089f..a39fcf318c77 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -295,6 +295,7 @@
 #define MDCR_EL2_HPMFZO		(UL(1) << 29)
 #define MDCR_EL2_MTPME		(UL(1) << 28)
 #define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HLP		(UL(1) << 26)
 #define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
 #define MDCR_EL2_HPMD		(UL(1) << 17)
-- 
2.33.0.259.gc128427fd7-goog

