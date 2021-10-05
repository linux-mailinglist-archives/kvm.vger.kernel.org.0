Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE73421BBE
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhJEBVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhJEBVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:21 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E657C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a16-20020a63d410000000b00268ebc7f4faso11558581pgh.17
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Lp8fppr199NgsT/j3g+xAZeLiIny0nlTRqLnRB6Lf9o=;
        b=r8cy36ekkCRU7CK9x39r2ehmczVM4WYvdrpVCxCMQAGmXL8lkvN+gv5F/Exoy/06Jp
         JeiEZCbkC4yHKPpHZuSMjruHBOEd07wX7IDbnFhQR5LJn03nXb34CcbZYsKjscKUtC+i
         0/Q0JF1cimpivptb5ERCkMpjEgebxrP2Jsp3kMFn7iXl9wTn7i2MdsU5zQrZp8d8pCMH
         8kK9jnMmsQKQ250QGfK4a4X5fPLWM54G7FLRxs9KamWRjBkNx2OmUdO5h63bDHBZmKcx
         2YnypWDrfiIB+dDb96K3QMvLJ0/pykxn7g0tDqzvhtcRfBc7hZD1lQhWbBgAIOuTnY5P
         mkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Lp8fppr199NgsT/j3g+xAZeLiIny0nlTRqLnRB6Lf9o=;
        b=VVCkBLt/FECKI7Z1XB+XIvRXLmDMYTFw3r52HHNpYxUjQWsPbCn3Y7+CnoCqNSShch
         bpJUgE38J4xf+PbxyTRgyh5NqbYfeT6jbGYRCYzsXJ5JdozRKjK4xERysuilEQr8pYjy
         Xp8Rwx8eNwswE9Doum+FRICEBEjL39n5us95L0a/m6Y4q2oKHh4AbKMoYO9Jb6j+9AxX
         ldzedZOWL4sFnFh86sKEakX7LOZ9LBRi1Ozirw/KNd7GR1U9jmJDQXTyFV4Cc2UeZ2+8
         BlRzzfeIUStjMg5PN8y/DgVOV2MVPKPX/g3D6myEgNyjFYqFbFLMwlupQcFP97d8Tag5
         HdLg==
X-Gm-Message-State: AOAM530fZj5U2I+0HowMV0WPQPNP7UO0mN35L5N60f5FmE1heiqLEpwt
        pVDsOTad1GtHDolD5Dlr2V+s+GqT5EYvU1U10GDAJqRmHJaqi+yf14ny0S0O2JgABLQ52x15z53
        mtyoK4PYs9lQQFh2X2R5PhCWMgrCHY6cSqNoHXxcEm5NnipNOudwL09fFVFbMMuQ=
X-Google-Smtp-Source: ABdhPJxwdP9If/0J3kUi563HWaeI3qySO00OZJr5uPRW0Ggk3kGihGSs8tskW+HQKj1LI4MQKFwZS9DN0Mb7Mg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:9242:0:b0:446:5771:7901 with SMTP id
 o63-20020a629242000000b0044657717901mr27569603pfd.81.1633396771443; Mon, 04
 Oct 2021 18:19:31 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:15 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 05/11] KVM: arm64: vgic: Drop vgic_check_ioaddr()
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

There are no more users of vgic_check_ioaddr(). Move its checks to
vgic_check_iorange() and then remove it.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 26 ++++----------------------
 arch/arm64/kvm/vgic/vgic.h            |  3 ---
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 08ae34b1a986..0d000d2fe8d2 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -14,38 +14,20 @@
 
 /* common helpers */
 
-int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-		      phys_addr_t addr, phys_addr_t alignment)
-{
-	if (addr & ~kvm_phys_mask(kvm))
-		return -E2BIG;
-
-	if (!IS_ALIGNED(addr, alignment))
-		return -EINVAL;
-
-	if (!IS_VGIC_ADDR_UNDEF(*ioaddr))
-		return -EEXIST;
-
-	return 0;
-}
-
 int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 		       phys_addr_t addr, phys_addr_t alignment,
 		       phys_addr_t size)
 {
-	int ret;
-
-	ret = vgic_check_ioaddr(kvm, &ioaddr, addr, alignment);
-	if (ret)
-		return ret;
+	if (!IS_VGIC_ADDR_UNDEF(ioaddr))
+		return -EEXIST;
 
-	if (!IS_ALIGNED(size, alignment))
+	if (!IS_ALIGNED(addr, alignment) || !IS_ALIGNED(size, alignment))
 		return -EINVAL;
 
 	if (addr + size < addr)
 		return -EINVAL;
 
-	if (addr + size > kvm_phys_size(kvm))
+	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
 		return -E2BIG;
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4be01c38e8f1..3fd6c86a7ef3 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -172,9 +172,6 @@ void vgic_kick_vcpus(struct kvm *kvm);
 void vgic_irq_handle_resampling(struct vgic_irq *irq,
 				bool lr_deactivated, bool lr_pending);
 
-int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-		      phys_addr_t addr, phys_addr_t alignment);
-
 int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 		       phys_addr_t addr, phys_addr_t alignment,
 		       phys_addr_t size);
-- 
2.33.0.800.g4c38ced690-goog

