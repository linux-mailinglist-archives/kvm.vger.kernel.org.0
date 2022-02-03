Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21ED4A8A67
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353011AbiBCRmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353005AbiBCRmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:08 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7E5C06173B
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:08 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id 193-20020a6b01ca000000b00612778c712aso2438553iob.14
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V8BbjeU/NUjuU0PC2phaUtgSmpC9nGD4vm8lUsINuPc=;
        b=CquM8kVvpzZqCsqd3uTsfb/Kq+NX1L8Btg7Y4cIvmQCfpvGHXwVLO/7lenwDXHB8eq
         +zPvw2EGJWYdyXqu9YhkKlgMvyeX7KCDkq5pI+qkUQ5te6Azs6NyvqIERfSxZxAGSk3P
         wDkIuA/Q5meKfi+a9mjf2y7mIR7cjKwYlWfwd+PxKQaDDnBl2nkoaKd4IfwZ7MXgV7F5
         ASwYXKF6UNO7gZbDel/rBRqKxvbvPv4X6fIaSjuHTddVptehyzWbzTtEydDY5/AkyKF5
         yyg3zzFZdpU7Cs0gcfQMUq/U9PtFAdV612z0aA5iGaOKg4XC6TqsbxXnBSvR+InZy+8S
         phWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V8BbjeU/NUjuU0PC2phaUtgSmpC9nGD4vm8lUsINuPc=;
        b=Zdl8LNd4V+Q0HCOLfMiQkY5sGGmABdcYa5rvNGILYHQ8J15dRWCldqQWBAp/oUdJgD
         4/BCrTap6LL7zgjNdhDX/s2zfE0uU7TNxrxzjzTOrg3XAWwi9CXcz/+ObFVmxKx+2hIf
         GOyPKoOeAhVV5ScSLlBQOvosieWOVtVxPdHJPAAz90QtCy41yo5z4fQDD6afTFnLXO+i
         rVKjcivmcAH6O578aPaRq1GoPIsX4944fSigGc6N32ZwqCxRwnz8te1NAJPZ/Vf3PUJ9
         Wie68ZPrqKZbHoT4beRNzp0WKdZTOfezPt/dKn0TAsGnSO5Z2PEd5TZftlQiM8YgKQlI
         EKuw==
X-Gm-Message-State: AOAM533e1srx8KSnGkCpJ/uJ9KxopLYoenIsP00ZziBTkQeJnjBCuSnN
        bVFq3OQoMdupRxxWBTANr8BAVLZ/Dho=
X-Google-Smtp-Source: ABdhPJwvty3JHxDSDgNiODiOwQlb6U16qNxJc1J7l+iM6Xi2RAAcYFElWAr1Q86A+cSIHHHQIY21vcySbA0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:c24c:: with SMTP id k12mr9848406ilo.45.1643910127829;
 Thu, 03 Feb 2022 09:42:07 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:58 +0000
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
Message-Id: <20220203174159.2887882-6-oupton@google.com>
Mime-Version: 1.0
References: <20220203174159.2887882-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
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
        Mark Rutland <mark.rutland@arm.com>,
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
index f769fc6cd927..f12147c43464 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -760,6 +760,7 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(2, 0, 0, 15, 5),
 	ARM64_SYS_REG(2, 0, 0, 15, 6),
 	ARM64_SYS_REG(2, 0, 0, 15, 7),
+	ARM64_SYS_REG(2, 0, 1, 1, 4),	/* OSLSR_EL1 */
 	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
 	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
-- 
2.35.0.263.gb82422642f-goog

