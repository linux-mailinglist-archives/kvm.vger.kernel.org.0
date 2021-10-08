Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CE2426E3B
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbhJHQAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243213AbhJHQAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:42 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F0BC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:46 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso7654123wrg.1
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
        b=i/pRriXt3CHyKnmFS1FqK4spN9Y1lGyHor2YjbaqZJmPtizyGB5YVl2YWNQdDK2rED
         OjOfggwsChwZgWrO1lOFVRW0wuTBR/RmRTF42bJGDrG3qHafHvsfVwS52uiasBo4BcbQ
         9sBSimbSX/5vkRRqWl9kAr43lDwk23pKR0Ec2QLmvJIj1HvFc+xzBzvQLURwNBbY4aEi
         3tanzatP5/VfsUO0IQqkIBQTco3dk6QRc/NhX5JijcL+go6HzrB0gvdkhREFDrGeFitf
         e08mrjdfEyHTp5ALIukb1y9FvaO3nuCKfXdeyKvYNSfbFX++yeKnRdl/IGBNd5DjFrYW
         2VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QqmpVX9qKSHJfRrgop8+61xx9tI9wmt4M81OJFFu8Mc=;
        b=4Pb8RiAmSQVU18zyskDUye6m10C35RKGh2BfNVeXFjY6MYzP8y5aVt1kz9oiK3ykkP
         VuEBQvSjRdlT895dHsFCvXseJHbUxKTsJ5mZgLA47Pefa9O9NgJKCRahjUnKOBdTjTNA
         NGL3j9hvXs1Wor9YFA6OqSlw3zEp+Lo4p9biTosJGp4hVoOl7FnqCNyAXe7+V7dGTf8I
         f92fld30dYZniSmFQsUHHXyfshp43w/lH2IB2hsL/tXEZAPSOK7Y0JB5q3O6qzKDhyyv
         +fiwS8DVmS0PNkG+i4vy1ehWKQUJqQzE/cjN+tdHlw518rOkHofnZMn1SJBliRExsRbs
         tXxA==
X-Gm-Message-State: AOAM5331IicUJmLfoSNqWsJeRM7PjDbovNz2y1MN3sRxnAviRYgJDlPr
        E2DwTrtj2hVQFVbmfyP8SL6sWGuOzQ==
X-Google-Smtp-Source: ABdhPJxOsk7AO25uGgC6TRQuZfz5cGyFTJAhMct+vYAVjDxjkvjo/1Ci0Jb5yGJ/JlNHmxU68Ydzgx4w1g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:a54f:: with SMTP id j15mr5036651wrb.218.1633708725327;
 Fri, 08 Oct 2021 08:58:45 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:26 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-6-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 05/11] KVM: arm64: Add missing field descriptor for MDCR_EL2
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

