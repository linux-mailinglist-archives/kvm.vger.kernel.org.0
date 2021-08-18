Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11AA3F0D58
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhHRVcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHRVcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:32:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442D9C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:32:11 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id r13-20020ac85c8d0000b029028efef0404cso1631359qta.14
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ecRcCckqyWwTUzyjSNSqRmDARBDpmN5st2LAlkhtd3M=;
        b=rndIgZ9W3RXr8Fv3KFQJgk7GH7BdVZcJ9F3Vz208W/QTj7Gz33vs9KOTj/kgpPYeYJ
         go0/ouGDHDiRvhofKXAp7iydUAoi3pUwmkdwgD6MO5tMcgtneJiNJTEk4qMSr680997x
         FUxuoQKU7+yAaoChYMFkN8eZSyHcNKDJprNjgXMNLGAwiDryRoxuD/Bh7rI8UtmM6jHX
         7NtuG2NyjtygIO3hWqzhBnM9uZ80/2Y4nP2rf3xOshbtIjxbvtwREe39emDEXSZt5Ayq
         zwJS5nzD82mZjftx6rJVYWrH2kICdyw/Szpw0B64opeZB7L+1AvGMlAqqksdknF375aY
         TxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ecRcCckqyWwTUzyjSNSqRmDARBDpmN5st2LAlkhtd3M=;
        b=KpU/TeFr8Mk/URsBcpPgDAs9TptrmGwP+nWVTvO0npSTy78JGDWrAk7qHZIFK963t8
         KbVGqHPyBSieoZRMck2gtOayVMZK4gZy0LxYdieJVVk6St/dqJSJRQuuC9SeFhqUsopJ
         mfo8GcJ/H8JNoeSZd0hNDvHf02O0Cxl4OEJrszfgWa+oBZzbPTyox9+hRmWNNlet8k8W
         mtdBJABVEJPV1MF1WnvG62rSgm1LnWfoaCA3mozd2PGDn0AtJdbj0SWq6AyCKj6Kneb/
         YdxEZRnkVh7YJK26ePgn4q5TbwXvTZ5jEmM+hKCMTTVgN1p3eV8BsN99+eXNM17iSWvh
         O56A==
X-Gm-Message-State: AOAM533ymckjg7+Q5Thp8fvEqsx0WcTB19Xj2aD288r+Aw4PxZql+5jX
        QMftZ4+8ATdk8luiV55sQCc3/bNBX8ObIg==
X-Google-Smtp-Source: ABdhPJziTwCi/d/SGVcituWivK5VPhdCVw8HgSkbX/OjYax72lgG7DFYhq9ryf8JeuNmbcDbxIuMRNIUHygZ0Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:144e:: with SMTP id
 b14mr11084163qvy.44.1629322330417; Wed, 18 Aug 2021 14:32:10 -0700 (PDT)
Date:   Wed, 18 Aug 2021 14:32:05 -0700
Message-Id: <20210818213205.598471-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com, catalin.marinas@arm.com,
        suzuki.poulose@arm.com, oupton@google.com, jingzhangos@google.com,
        pshier@google.com, rananta@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vgic_get_irq(intid) is used all over the vgic code in order to get a
reference to a struct irq. It warns whenever intid is not a valid number
(like when it's a reserved IRQ number). The issue is that this warning
can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).

Drop the WARN call from vgic_get_irq.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 111bff47e471..81cec508d413 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	if (intid >= VGIC_MIN_LPI)
 		return vgic_get_lpi(kvm, intid);
 
-	WARN(1, "Looking up struct vgic_irq for reserved INTID");
 	return NULL;
 }
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

