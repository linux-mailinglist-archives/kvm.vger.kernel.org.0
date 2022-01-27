Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B064B49D8D3
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 04:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiA0DJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 22:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiA0DJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 22:09:12 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C9C06173B
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z37-20020a056a001da500b004c74e3fd644so895886pfw.1
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GwfeejbMqNEQvaZ8Yfe9ml4jBewW/ulWJB+/b/aTwrs=;
        b=EtpS3gSBZUOjBB1L/nudYXj30b9atzdjUMoj0Vv7eotLi8QKfuVja6weD7hkUnZI0v
         jftGfz5POew9BfPZJCZpWWTYSQUgj9hZNhEmXqLLReVz1zIy8PO2r9qhg/ZY1aYPlqUn
         Qrwygd5W2/GdFzsPv3b8dlZ7+CF8A3y0ctD18o8RywKqD0Us6tq/eClsMvWSERUqEolK
         GStpjjO3ZcLhQIpM81/O48PGIOdpJVk0qfgBwH1NFjLf8kR4xu7EyNDj3mdLqxVcwAZJ
         eF/z8aW8VLIHxZInFiBqS7QkFEMQrVg4GGZnUrHi0dPtueK3M+TmevW1KNI5aN3wwAXH
         /zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GwfeejbMqNEQvaZ8Yfe9ml4jBewW/ulWJB+/b/aTwrs=;
        b=VjOZ9rSS3ri6Hq11MX7xMeDnze7sMy3b2pZWUxyZsChCQKQxZFQEyOlsm29Go4JL9Z
         If+xYCPnl3FxNWHOCITKGWXOZlc+N/+xWx4Tpq+RyhaiKZQm2Vo9NAv9kuIafQgzk6ZI
         CKQuT4qHAMOIjrwDZTlXvi2uZv3WdeXRBsw2M9YTFN8cOkIagx9I4SwziSGTDQy6xjIb
         omTl7Durqk00Zn4U36ZG6TO5YUEsrD7zpXGBMOn1KBPol5XySXOF/yEDYyTZpAlTEp41
         9QUpku9K5z0de9i3DVlHeqLAVW1w7oaGLrVtGMuDGWiOa8y9YVDyT6NhdqOAQ3NHMiqy
         rKAA==
X-Gm-Message-State: AOAM532mfToFY8VMVAANwTkAAeY/8bPaYokn5ahLswpowo93Ezj5Yi+9
        nsvvpqyJHQhGpo4vpSJX1+b9ep+ZE2jbaDewesfn2wW3cn0xbELDHFyGaNywL5qCx/gYJLd0TEc
        6QMIjrCI2qhYM+R8LGeSr6AWjd58vAbqMoGJXFFOsNyA30Qyw+T12hojetPpeN+M=
X-Google-Smtp-Source: ABdhPJy3JpRpBg4WMXBaYNzVrdWKDl4Dc5lDHaJc1a/ZjIUD9OyrnUNOAFFGNGVpScKQcaVXo9pxXppP2Sh1oA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4d82:: with SMTP id
 oj2mr1328529pjb.1.1643252951408; Wed, 26 Jan 2022 19:09:11 -0800 (PST)
Date:   Wed, 26 Jan 2022 19:08:58 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 5/5] kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()
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

vgic_poke_irq() checks that the attr argument passed to the vgic device
ioctl is sane. Make this check tighter by moving it to after the last
attr update.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/vgic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 79864b941617..f365c32a7296 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -138,9 +138,6 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 	uint64_t val;
 	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
 
-	/* Check that the addr part of the attr is within 32 bits. */
-	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
-
 	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
 					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
 
@@ -150,6 +147,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
+	/* Check that the addr part of the attr is within 32 bits. */
+	assert((attr & ~KVM_DEV_ARM_VGIC_OFFSET_MASK) == 0);
+
 	/*
 	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
-- 
2.35.0.rc0.227.g00780c9af4-goog

