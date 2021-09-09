Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685F44042E4
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349485AbhIIBjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349331AbhIIBjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:39:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C032C061757
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e5-20020a255005000000b0059eef58e1eeso366227ybb.19
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zNHqAFnuHiggwZ7jn9N18KxilmXmaHVrWak3lSk+d74=;
        b=rKFntGWT7Zlr1j69UYRUvBr32BT0o9bmx5mTs/dXAaJ7tGkNGtdvXB7ckiyofZChKV
         7n52lUMs/NChF+8iAfWGVFmty6jb+kLonv/JDmnQso092hq5b3v+Rn6dR2u9pNlcJb32
         vyDtjMYhsYXNh/ccaY792PP4q4YjoqfVydlQw2NSiNBjJlVPLuidRcTObpascm5hLwn3
         x8aviO8LNf3odytaZJ7XuCObuChS5xmrQQIOr/xsJeiFeAvbvOMUF3HZBZV0Zp5KrxTi
         9xnbF76qFJKkIoIsC7tdccHakdVT2nlJz/kVIfoAIwNxLcl0JHNmxQ0Th6vOjH+sHCwy
         lJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zNHqAFnuHiggwZ7jn9N18KxilmXmaHVrWak3lSk+d74=;
        b=IFPWKusdnUnnd/1DYFj/IIlaW3ac65F6hlhAiF8plU7yVW9+QHoJAP/sKPdfWNloBV
         rCvEpirpa154z+jGoC8wLvApTXyG9txd98f6O9vvJYy/3AHgBfIKPgngn8OGluoW6KDZ
         ulESYm6JSEGZAV/kvP2T1rYnB5jvI9rIagLwwAWKt2EFWZzhkB0N8ESCDq6tUlr8hggW
         I3w6BJ0KL+eiXRiKhp5zyLQr0xG6iHjFJ7yg9geTEXuI8qS7eoBnLRhVZDzJkU7xyzU8
         yjEOwe/XiZCk8B2KNiyYhL8JIJV97tVlh26vla6m5Ej0dHWGCAfb7rTRyZIhp5d6XVVP
         YEnQ==
X-Gm-Message-State: AOAM532BkZ5gHtDwCojsf1dzzfnOhBWOwOdhfsBqc7OaEcdvUZ3R5w4q
        n3TSBBacq6YTL9EfHYhQFrgkNljAYFe4
X-Google-Smtp-Source: ABdhPJzqGHIW5BlqjxrpUF6cFXd1RySHNQzV5SgkIh3LB+LBsAvRqWs0V+o2D2lg90iac2o/nK8DBUg+bdAv
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:1845:: with SMTP id
 66mr543521yby.396.1631151514456; Wed, 08 Sep 2021 18:38:34 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:04 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-5-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 04/18] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the inclusion of sysreg.h, that brings in system register
encodings, it would be redundant to re-define register encodings
again in processor.h to use it with ARM64_SYS_REG for the KVM
functions such as set_reg() or get_reg(). Hence, add helper macro,
ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
into ARM64_SYS_REG definitions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index bed4ffa70905..ac8b63f8aab7 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -26,6 +26,20 @@
 
 #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
 
+/*
+ * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
+ * SYS_* register definitions in sysreg.h to use in KVM
+ * calls such as get_reg() and set_reg().
+ */
+#define ARM64_SYS_KVM_REG(sys_reg_id)			\
+({							\
+	ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),		\
+			sys_reg_Op1(sys_reg_id),	\
+			sys_reg_CRn(sys_reg_id),	\
+			sys_reg_CRm(sys_reg_id),	\
+			sys_reg_Op2(sys_reg_id));	\
+})
+
 /*
  * Default MAIR
  *                  index   attribute
-- 
2.33.0.153.gba50c8fa24-goog

