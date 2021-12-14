Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DC447496F
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhLNR2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbhLNR2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 12:28:22 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E902C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:22 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id i11-20020a056e0212cb00b002ae39e26bb0so4520306ilm.4
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1Jwvt2jUDR/UART7D/evy6xX8nTOg9MzOLHWtI9aqPs=;
        b=SzpEesm+Mh2jg4QGy8qBWU5SuQUrhFLEHQSQshWM9fM4hoZ9A7wBdjrOY5vU7OIJ2h
         G3Ye+hM9b1QwZJvy9WGZyTpicP54IeYAVoMLcvcY2NYRkOVUvIILLL7dsfh0DbRNj/Wk
         LNfobwMekfHZuTNXHlaMmu+WlD2KONk+nM3s8drKYTagGFa/Mnpx1MhsVA9gyz2DxpsB
         A10VPKejwxiLgNvOm0pvoxY+xDNSPbwsxeDlIQYKhTl52zX5PoJsoIUx+od9VJELicAp
         IZYShzHylChaqzxJhRTArPhpSQxSRA6cbYBn7l+GjtDdkfZtQKph6JvnXFjoDiScnQpx
         2csg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1Jwvt2jUDR/UART7D/evy6xX8nTOg9MzOLHWtI9aqPs=;
        b=mHmtIUNKvbQ9Az8EHnBvqqYLD+qRXmYZanLDkOPJCVJhg2Gz1Re/9cN+1OtlWlnyYW
         lK2KhdyAEtRIWZ1bK9Zj3GOkaC3SjN2Q+/uJX5mj4D33vlx39vEWCxRxZ9su1xupLb3i
         otBgnOiPIgm1xNRWrWZb/0F8jaBhcb3G5ztbhHwPY7+PGFWSQbX3NWQo/lgjOhFD68tb
         LaABHt733vGfenJdlweWfjyKhN98v0OWQ5eCk1wSS3SHa4dX2TFU10X8WMinEBcVsXVg
         wOEanNvVUHDQwHaBipAEtoNVqrWToykBlAUnL/R2H+atBmv5K+G3L8hRY7EDqxJw9t/0
         2WLw==
X-Gm-Message-State: AOAM531k+aYkF2hsUXzs9zY/yMS/JlFVosoSazqL7BYEyxE72i4lDSMS
        LZsQJP8dknZzVNh2IqeNhBlZjR35gdQ=
X-Google-Smtp-Source: ABdhPJy18yNyWrBFa7EmeTStINtjn7maODxM/UjDHu9TWrMLPrCpYH3fBbsImp3Jixp6csA+szHEYxhmlG0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1604:: with SMTP id
 x4mr4626833iow.84.1639502901988; Tue, 14 Dec 2021 09:28:21 -0800 (PST)
Date:   Tue, 14 Dec 2021 17:28:11 +0000
In-Reply-To: <20211214172812.2894560-1-oupton@google.com>
Message-Id: <20211214172812.2894560-6-oupton@google.com>
Mime-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OSLSR_EL1 is now part of the visible system register state. Add it to
the get-reg-list selftest to ensure we keep it that way.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index cc898181faab..0c7c39a16b3f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -761,6 +761,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(2, 0, 0, 15, 6),
 	ARM64_SYS_REG(2, 0, 0, 15, 7),
 	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
+	ARM64_SYS_REG(2, 0, 1, 1, 4),	/* OSLSR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 1),	/* ID_PFR1_EL1 */
-- 
2.34.1.173.g76aa8bc2d0-goog

