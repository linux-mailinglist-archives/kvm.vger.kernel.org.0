Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D39D45ADC7
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhKWVEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhKWVEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:30 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7C5C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:21 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id h11-20020a92c26b000000b0026c4b63618fso205168ild.15
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BwedrBbB5HTyTT2p4mXfIz5QYgjh9yNsR4b4hzDoNcc=;
        b=Qaaf+qNAHsw9kOiocwlPyQ0uu8vL8UJhBqb8PdL3yfi+rhltZxP2GUdFo8KKxXIF2y
         6IZ/uxBz0Ahn+4GR5yWfCfWrL5FHSvGty4CvmlOR4qAkUXmWWSnW2VS4HHgxJF3nAYup
         8230IweKBYk0p9mch3LGMraTTxEIO/uKA/L4wA8eXpXuoz23U2AkmV39GFksQQCQ8DhE
         WnE0rEBRBf4zorX53WPARK1svet5e8XOn3nqGqDjANt/uI7PgRy/KuUil9dGh1ZiLL9D
         IZnfjhI6ieihzJ92jh8EwquSdmAAvY8mdCwlu/6dhLJundiUSd5Dy3HfdQnBwv7ny618
         ZOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BwedrBbB5HTyTT2p4mXfIz5QYgjh9yNsR4b4hzDoNcc=;
        b=ORxrsJ0w8EqvIvUE4z0X+aK7TIVUhQZMxwbRqqUtuIejd4fhPgkA2TZbfiSG5AiO/f
         0jdfEEizbr2PCNUEtmbHRS8lwe8p/GZ4FiuvkkchfmXcO+7iKsYfr2942uLmqjwpNp/Y
         jlXVL0qEtNDpLEU5368wt5L724zrk/9oxlH3Hr6GSkbzwcpaWNK1dkAgXSF/RnktQaKA
         bXOkX8AP1WB7NzxRp3sfCG32R76SdZa/7Vw0fiohAL/DSkPQZEulYahabP36AKNLIXgN
         1BNFyxhspMn/r65jlrhyU1cpdmcLvFEaqQ2sAc7FO9dPFBJ5Xd+ENIcP9HtPdGDg+YFQ
         hEMA==
X-Gm-Message-State: AOAM532OsNVWzTGk11VUMmeSj14WPdmuTp19T2Hx8hPxri6In5FbyGM6
        0aW/y7Rf+Lap9bj1dGeetDlS+WAI9kQ=
X-Google-Smtp-Source: ABdhPJzaYhRodYov80jU9UDbdbd9k79+gVGKWsjAcZxXmdtDiHN7YN7VKm1c4GS5SZfFz37xFHlrrmZumXw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:8bc2:: with SMTP id n185mr8931449iod.174.1637701281216;
 Tue, 23 Nov 2021 13:01:21 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:08 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-6-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
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
2.34.0.rc2.393.gf8c9666880-goog

