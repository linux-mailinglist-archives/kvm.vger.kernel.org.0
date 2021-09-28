Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA0241B69A
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbhI1Sty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhI1Stx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA2BC061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id h9-20020a17090a470900b001791c0352aaso15050310pjg.2
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8STNvO/W+/tH6mis7cVRJ3Dc57rX86y55WPHAXp51vA=;
        b=Lav0bpVUN4Oquga0REUXCMujWYzDDRnjAT62pSHmfoEUa2PIvfp5F1Kg5ACJCpAnD4
         FEZ/u0KXIJBayfxa6jngfiCpFXBZUcXykEXCfoh7PXPN41Qq7vRH2/ReasumUTEaWYdI
         mNoM+eXzdtyivAAja4vueOaveB5fw8w7VHhOM3Kf4cSAOpQakJydLynyPsdi9C6oZkXQ
         TZUeOKehykE2VXamGR/qCyEXKALLGpkm17079iaWStaKFhhMpRVJX8ObbSNn5QFlPeJ9
         /QQCSCi3J4lmBixTTGe30U5Geh+CA5mU4u1bEr4HzLZcvBgROIvE0+LDV/sXEEqQI7qF
         dNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8STNvO/W+/tH6mis7cVRJ3Dc57rX86y55WPHAXp51vA=;
        b=wyAwBWuFjfuJvlklyJHGlMh5Lx18EOrZFrEVS3M+Is0ECsMQqumyyu5iNsiaZ3muBU
         3vnDEtrsGQUJOILp7ZiGWKCWvQk4FR67lILWek2YNw8vUutLBaE02Vo7k3edPVcU0M5F
         J/Zt9Sqw+zukQsJCqKJVWhDJ+hc0XgDi4KnKbj+govEahx/gPOU74XCReQujZ02VT9dP
         5PtuJ3mEJmFVYRd2nmF9hZVNskY+esNMlFBjfn/lbbjAt5qIODul4sYzAqpzpd6qYa3X
         +gXFMXmzvT9ql7xzZ2V/JQY6+4V6X9irfvkZ12CzIpyXl5U9X0AQUEZI9qRPDKavhfT/
         kziA==
X-Gm-Message-State: AOAM531ndoCBq/7/Mw4WcBL0KpQYzdjzLT7KvXsOMlpDzoaLowZnBmC+
        6ldnKkhpEsgxz6ZAnio5wI62qrScFmzr2whLwWXrJa39i8Mtuqg3rQsU85QR746d2nDXN0yZjf0
        y3sI0KUproYuEoynwQVlx4J4fpDaxH0Jo8GE038UJbFQunqdRc5UkwXUfOxKDBLY=
X-Google-Smtp-Source: ABdhPJxUvKbejiUbAT4D+8m44/T92Bf4fwoQkvcqyb2zCtR582bmgXPXtYeU7QXWaMMliTmrlAoIrINN/fDsIQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with
 SMTP id l6-20020a056a0016c6b029032de1909dd0mr7029829pfc.70.1632854893435;
 Tue, 28 Sep 2021 11:48:13 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:47:58 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 04/10] KVM: arm64: vgic-v3: Check ITS region is not above
 the VM IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the ITS region does not extend beyond the VM-specified IPA
range (phys_size).

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_its_set_attr() which is called when
setting the region.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..321743b87002 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2710,8 +2710,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (copy_from_user(&addr, uaddr, sizeof(addr)))
 			return -EFAULT;
 
-		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
-					addr, SZ_64K);
+		ret = vgic_check_iorange(dev->kvm, &its->vgic_its_base,
+					 addr, SZ_64K, KVM_VGIC_V3_ITS_SIZE);
 		if (ret)
 			return ret;
 
-- 
2.33.0.685.g46640cef36-goog

