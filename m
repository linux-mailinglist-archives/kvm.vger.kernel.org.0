Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BB5442AA6
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhKBJti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhKBJtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:36 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF7FC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:01 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id f19-20020a6b6213000000b005ddc4ce4deeso14733076iog.0
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1y+OLvxpVymtlL7fk66XN2cWX+vD2iLWE/0SkTIcu/U=;
        b=rzO1Y8VN0zUYuasfFoTvV/5jD+cKSRGlj/YpHnnIRuicH7JJIZ2PnY4j26AX38M33j
         w4phFGdJUTdXdCnx01ZxlpdHwuiZsF8zMYKIkTwU+Oz5ByP6W796mfarWTsctdFT1yL5
         pJlkmLGyfKzIN/D3syWMWYGFIs5YynzA0lsENVBa/R/bjXWIMJgrWc22lyZuS7vFVIUg
         Ry7VLJisteieRR96iKby/wvJE7vRkjfUTAUGZdOcr7NC6SQDX3vX+NM/RDeG4U1iWDnV
         FRGpQZQSdtyOqQAjD/sUYy8cu81WON1vWgsJcY7wvINgJ71tv806zzkalWbjsCPfged8
         +yUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1y+OLvxpVymtlL7fk66XN2cWX+vD2iLWE/0SkTIcu/U=;
        b=1oVD8aCoBXd2YiFLXv+jWsY3lfV+yhxkHOHugae/MQ/VE8qgS6s3v1GWOGXLlB9cEd
         Uk9dDCzIufsy5AX19vGw9YL9BeCjTKWhAFO2pVaszU8ykhpx0uimkBbvwJKx7SMMsaf9
         QKgBCzpjo0UcbSvib1uLmJq/ObqaAEGncWdRcuvFBkQqdDzz8f1V6ppZ0Pi4JdLbFsXH
         ZXbG/vLqyXmNb6NdbAkcet7Nnef+ifA+uKC0bJ4G4PNHhSmCrxGUPyAS97i4UVA6DmD2
         O3P20HAh+US8ugbtelXHQ1QZqW0rPuubr5VK+6xOn1QzIxx2IuNz7YvxhquP6aEsMybM
         PKkA==
X-Gm-Message-State: AOAM530iqr61RkkFrPj5F/Uf4fYZkXAzEyi3ALeryvqfUgDAlnDoJwxU
        mkKxnUwfo2fxoWuxT8FKPJsYB/A/Yb8=
X-Google-Smtp-Source: ABdhPJyayLrRnzjr+V0pA0yQ0Z4XEZRHuv5UbfBHmBUD+1GNwyAnZEMt4nk99gXUFzj3J+ZkE8WGDda50ZA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:148b:: with SMTP id
 a11mr26232858iow.85.1635846420975; Tue, 02 Nov 2021 02:47:00 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:46 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-2-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
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

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..17fa6ddf5405 100644
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
2.33.1.1089.g2158813163f-goog

