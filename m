Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6965542820B
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhJJO6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbhJJO6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:49 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A75C061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:50 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id l10-20020a056402230a00b003db6977b694so5160255eda.23
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
        b=rp+JkjIo4z20TVZIDlSIwcTFY4aSNLPZRbRvWkOYVJDpTN4kkc4kXKzj4zL1XqqLD6
         MAwZqs/RrSgf0IYgMqBgWKZYmmpqhy3KmVaynpWh9HHyGMXUXUcM29ar8oufFOa5aQ2N
         lINiptI6aVJKGvrvTUjakeU3dSpiVoKdo/XZgog7T57pZp9EcAyJKpppiUM40z7tR80X
         1UftZdYHjRvUcOFi3KF74SM+84H4frlKpmMrGdCI1Cn+3svn0f/GGhiK5N/LeL1cKKDt
         qDhPHsxNNRvruisMmkCZJJclGsNKHNIAe4WG9EEW7err/CAn71dkVA66KFkvXOcuJysR
         L1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
        b=wIQCr9ST5U7KaLvPeX92GkSJeaIT/4H0vKlbnLiiCRtw8YS4qo+A4cVneTMgEohawr
         8XPbz5yRzgZl0zUTiauau6OdOhTjp5nGX31GQA6iApQJ/XA/NP22i/cbKxbcB+IK85d6
         ppHlyGLRqc0tVATzhZBbOL74zMp5fbzZgrVYCUiZiMoKupRCIxRQsD14CzZURWbQ+kMj
         bX7ft7D/bexIvineSsAhOXP9OIjcglxxWy5vPG7l7QeBBvpBRRni4zaqKtKW7NaDcR2K
         J9y/uztAaTTJUSjtf/g9u5wuRLkryR4aJMygyNaSOQDtmLmEsPJUgh7pApyiI24PaqkB
         dT4A==
X-Gm-Message-State: AOAM532q3sK9zrUKoMQ0WvZ0A9L3sCmjWNN4ILD1tQfzw05D/I6LoKPr
        mtOqWuml+oWhKB6PQX/LF5vbPdQ2tw==
X-Google-Smtp-Source: ABdhPJzpTkGFIK4j/LTFwoQ2gf1pAyDRXSmWmhJdD0DXhgP3O9zDkvzBU1J5GnrnGKvcXFBgRmmgtFV55w==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a50:be8a:: with SMTP id b10mr32770711edk.235.1633877809045;
 Sun, 10 Oct 2021 07:56:49 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:30 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-6-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 05/11] KVM: arm64: Add missing field descriptor for MDCR_EL2
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.33.0.882.g93a45727a2-goog

