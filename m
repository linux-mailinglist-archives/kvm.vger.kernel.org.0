Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0543F3F8
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 02:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhJ2AfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 20:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhJ2AfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 20:35:12 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A969DC061714
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:44 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id u20-20020a5ec014000000b005df4924e18dso5347232iol.17
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Oy01IknDRFVJKLSnWHmExcfPSXKDoq8nS6BDKnDz0O8=;
        b=i4SQt8b1AkstVV8CAePyo55dLl6VOqR1QVAiVbqgmCto/zYMwI9p6BgIoTIFAPZXvC
         RYV9R9Ieg85IjpWwhQ80iBwhSdmiRXDjZ4Cn6EKwvCQ4VFzULIRTbQVedU4MI34xHFpE
         knIqoBIrFOrTTrlhR63X91EXWeHBrqc8Wy44sc0gQ2InrMkPC7POadxyO/T73FTHi0Uz
         U1XBNc8ODIfe3BJS4+JTlNavF3j1xjXWmuzWnVVrW+KmGUeZemgl6ZxQKNUlvzmsAt2S
         XJRivugCqYaiWWIKtuyQlzaOJghDbN2iENFoRYExbkDSbvRJj/hVa65/XRo4FEamT4QT
         hQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Oy01IknDRFVJKLSnWHmExcfPSXKDoq8nS6BDKnDz0O8=;
        b=LiM84x+9dYJK6cfdrM6YOoZBuRLxOKh6s7AVbA3ACBhAsmDhRXjMNWkQsBnBg4o7+j
         D0E06pMAKEEow3XvMDqZ/gkvxu1h9mf5Nn0IPiS+JU+BU19sHDDhh7qz4OGEAZd5oECu
         R1PP2mJK8lR6NaK/H5EwRHLq3fGzRvN7f4YMVtB6YwpXaKmL9SDx3EAoVu2A5XfzBsgj
         hi45KbuQvM3wyAlaLx3Rczjg2Gcch7C5MVstKg11xLa33+jdSJjnhT0bpPENFTcporbG
         flFW1olRnC1bP3W8WeiQBV9QWkh9jbs41GiuL6RXZN3UBDwlQmyRL55UJFK3nU0eG3LX
         kBbQ==
X-Gm-Message-State: AOAM531gGlqjLinYK3xqSvBdzB67IfOFOoHGmVV4SL7tVyDl0dgIW0QR
        L/5I8bl2cPSLOoAE54wSpesirp3faVE=
X-Google-Smtp-Source: ABdhPJyxXD1Yuus5/OHrCt1h6LMDXta7JdKp3vcZcLarAByoLzOk+GrzMDSQpNSt9IwjFcgVU85NVKnra50=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:329e:: with SMTP id
 f30mr4310865jav.63.1635467564021; Thu, 28 Oct 2021 17:32:44 -0700 (PDT)
Date:   Fri, 29 Oct 2021 00:32:02 +0000
In-Reply-To: <20211029003202.158161-1-oupton@google.com>
Message-Id: <20211029003202.158161-4-oupton@google.com>
Mime-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 3/3] KVM: arm64: Raise KVM's reported debug architecture to v8.2
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

The additions made to the Debug architecture between v8.0 and v8.2 are
only applicable to external debug. KVM does not (and likely will never)
support external debug, so KVM can proudly report support for v8.2 to
its guests.

Raise the reported Debug architecture to v8.2. Additionally, v8.2 makes
FEAT_DoubleLock optional. Even though KVM never supported it in the
first place, report DoubleLock as not implemented now as the
architecture permits it for v8.2.

Cc: Reiji Watanabe <reijiw@google.com>
Cc: Ricardo Koller <ricarkol@google.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0840ae081290..f56ee5830d18 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1109,9 +1109,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
 		break;
 	case SYS_ID_AA64DFR0_EL1:
-		/* Limit debug to ARMv8.0 */
+		/* Limit debug to ARMv8.2 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 8);
+
+		/* Hide DoubleLock from guests */
+		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), 0xf);
+
 		/* Limit guests to PMUv3 for ARMv8.4 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_AA64DFR0_PMUVER_SHIFT,
-- 
2.33.0.1079.g6e70778dc9-goog

