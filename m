Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0AC49D8D0
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 04:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiA0DJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 22:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiA0DJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 22:09:09 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EDC06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:08 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n9-20020a17090a73c900b001b5cafefa27so996514pjk.2
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QPrlx7WHIAMxZ0O9Mmyf5U2YjXNGMzfcwUvdJYaS1zI=;
        b=fhA0NR/VPVJDiuNh+ZXtLY1vNHbmDxiynQqQuaOu7UYvHGuxaZd6jVZjI/ea+aGRwZ
         61lOCTcrzAyX43PsleAzNi9Xm9/YZtw/GpaAXIgFVgcGIGNCu5/JR7VV5J8GwaxKJu+f
         tjuMBjRXn16zC+uIme146UtoZbzn29+gDFVdCKuwOyzetDQsnVZXi4CWqHT10qBY/XvG
         Aw/G8lcK+2nWPRlOHithMqFBQMVNb32esoa8sXHdak3D4GfeGH68iUSCgQgGxg9HDlgT
         J2CFep8xfZ9/YMi6gK60jdN4//1bfio32WkuqvdXpJUE4d9tP8FpDEJn4VTyeKBjRpFw
         INLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QPrlx7WHIAMxZ0O9Mmyf5U2YjXNGMzfcwUvdJYaS1zI=;
        b=P6xOYkvmoYmgXn/Fg+QO3GrPCJFFQD97dANrvkb5CkNrkW1WBcHYUWquvRYETgTu8k
         xsJ0sCpT4R907mXjFHZWDy0UxVMrIwCPF+R+S4+nMEGsxu7Um6iJvoLjQ/pMKq1PNktz
         5mdOGo7io2Sb7SBXt29lPTyrDOtPWI0stubdQSEpKdwKV63p/+N/hGp2K2JINK70VbQN
         vYI5S/bJU6GzakDpQ92bLP9DSAAlbDEtS1V0uPLiiFxSyjjEsGz7a+lZ9spoptwBZ07N
         7t8nto9BVF9wFNA0TLTOXbr7qSpV1hLo0jTjuoIdZ5Xij2C/wvgvkXHyrxFk0/CskkYM
         U6jw==
X-Gm-Message-State: AOAM531tT73bXKKmSI1kSAHGzMARSei35qUW7xP9ELnzqxTk5JPXDBOe
        pWBlUtS+S166H9BUjDb2WA3mFgup2oHiOwjXptNutLcwo5rFmquo44eXr5r94rOX/3wMFJh5uAn
        Cb10ah3xRVZYWETZ2xYm9oIK1DYtxLh0/mTz9I65Kc0h9nedJuzaZJJAexHjlJH4=
X-Google-Smtp-Source: ABdhPJwfM10RSJpC/YJ0gxNH0zBPwJaj1dw5B5vZEVnAFjcJjtuWKaQNHlWvaJebRY8Yo3QV6+aXBzoV+0HnRQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:74c2:: with SMTP id
 p2mr2043435pjl.155.1643252947940; Wed, 26 Jan 2022 19:09:07 -0800 (PST)
Date:   Wed, 26 Jan 2022 19:08:56 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 3/5] kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_set_gsi_routing_irqchip_check(expect_failure=true) is used to check
the error code returned by the kernel when trying to setup an invalid
gsi routing table. The ioctl fails if "pin >= KVM_IRQCHIP_NUM_PINS", so
kvm_set_gsi_routing_irqchip_check() should test the error only when
"intid >= KVM_IRQCHIP_NUM_PINS+32". The issue is that the test check is
"intid >= KVM_IRQCHIP_NUM_PINS", so for a case like "intid =
KVM_IRQCHIP_NUM_PINS" the test wrongly assumes that the kernel will
return an error.  Fix this by using the right check.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index b701eb80128d..0106fc464afe 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -573,8 +573,8 @@ static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
 		kvm_gsi_routing_write(vm, routing);
 	} else {
 		ret = _kvm_gsi_routing_write(vm, routing);
-		/* The kernel only checks for KVM_IRQCHIP_NUM_PINS. */
-		if (intid >= KVM_IRQCHIP_NUM_PINS)
+		/* The kernel only checks e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS */
+		if (((uint64_t)intid + num - 1 - MIN_SPI) >= KVM_IRQCHIP_NUM_PINS)
 			TEST_ASSERT(ret != 0 && errno == EINVAL,
 				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
 				"error: rc: %i errno: %i", intid, ret, errno);
-- 
2.35.0.rc0.227.g00780c9af4-goog

