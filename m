Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0B45ADC1
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhKWVEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbhKWVE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:26 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F07C061714
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:17 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id d2-20020a056e02214200b0029e6bb73635so237120ilv.4
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zz/xhPyoPXicYUMo26iz+W4ztk9QLIUECi8yH0EE7Hg=;
        b=FPW2vvMEF0DWDy4pjYuYom7O9yhLArCXJ1IIIMafjH4l9SQfuEz8J6FSjgPKgvHDaK
         DeBp6PeziJvrhgneRyz+rm+FkgN/NezBffwxGMpDfggznwqV99WmAWiZCD8N2DgV1bS8
         r2QDDazxIzsxwyPXvSZihMTMmtbjUrPbY83UArR2T/PZBc1y88t0Sc7je51Z/CSxSHai
         ZRcYz8NU/ysUeWm25rP3blxxgU8VDJdjei2+qBFGiFDtkXqyuiogjzH82aK/MyhahMWb
         4LPyjD+RYSfQeNq7mCdSe6sIs/C0e/fUK+K8PkaIOIWtK73aljR+R1fxD0uS0UQ/jq0U
         7Tpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zz/xhPyoPXicYUMo26iz+W4ztk9QLIUECi8yH0EE7Hg=;
        b=d8EmVj9yqyGLPjNdYqWuwifBJ1vRrOjZ9lh4zBS7ubffsqEF6wca/Ge1kHlN/jguls
         w5T93yPjspsFvkVyrm5DxdHdTUD9lh1h7rePtQKfR2HRiWSlPo0uiL8lvYHAPQ3Fhz1i
         hl4hSs3jWfyoTHk9lAdrvfQ1LX28cuQZE6cE410EjvBUmgMmHvQpPwfkIa0x7SEeSJsm
         Zojt9/L9XxWZd0x0GCeRzYL9Kgy+sRvCdcvVi33h5xJbZN21SxhHR8nepyURRQdF49Eo
         Ex/LIxEqqqzLFfzkJ8OpJXErezaZ5mhd3s/FIA3PsHQAh33YQ9IB4uNJi/VIMYZWHKLn
         WaSQ==
X-Gm-Message-State: AOAM531pSL17e303xJUX0fMCF3jwFStuGpkTuTZeGpRSj6ua8v48ldiI
        xjoLDoIQS8hsc7o1zCgMTiBzlP4czN8=
X-Google-Smtp-Source: ABdhPJx+by8JvSWhwxRKIldPBbHOsPDBS6NTTo+dJ01tZHkK4K1KEKpOIEbd3eNqZtzCQs9wCBQyxE4E9+Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2b10:: with SMTP id
 p16mr9105121iov.2.1637701277092; Tue, 23 Nov 2021 13:01:17 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:04 +0000
In-Reply-To: <20211123210109.1605642-1-oupton@google.com>
Message-Id: <20211123210109.1605642-2-oupton@google.com>
Mime-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
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

Any valid implementation of the architecture should generate an
undefined exception for writes to a read-only register, such as
OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
behavior.

Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
write ever traps to EL2, inject an undef into the guest and print a
warning.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..11b4212c2036 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
-		return ignore_write(vcpu, p);
+		return write_to_read_only(vcpu, p, r);
 	} else {
 		p->regval = (1 << 3);
 		return true;
-- 
2.34.0.rc2.393.gf8c9666880-goog

