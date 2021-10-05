Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8014D421BBC
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhJEBVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhJEBVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF236C061749
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i21-20020a253b15000000b005b9c0fbba45so8852254yba.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xl+JM51DQgbfallo08wfmsOs83iQ7ZmJKM3bqS9Rg80=;
        b=ACyxOvGJNJ/NV7aFVA2v8u3c9Hf+IHSFlCixQBLv4NGV5jGHsoIUVkvmuoZDIa6hwF
         ptuGSBXeCteSoDg8JLQ5z+Hm5rgxwYGdOjgOyyG6PxyWwrbSHSz/otcscd3V4akBVAeH
         zDa/YosAJcnG3ZoWIX5UH501yW5u4Jq0lVTDuExVgXcOrO1sgmJ8O79J7x/wi6FPLWkZ
         VJDqnsN8IpppfcrVeBCk8R04m0GWyYH5qC22UxYo/iQiSs0BmXMtrXmTymovuJ5yIHf8
         c70QcNdMAlNuVLLAf6zcmfOhd0nF+0YsjAsND+4WEmiqRu4FShbvseHuuAm8xa4HRqaE
         s2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xl+JM51DQgbfallo08wfmsOs83iQ7ZmJKM3bqS9Rg80=;
        b=Vg0SbQArb6f+8cABn3D4AsarJrV+NVDmAoK5bgYbA3al3D1sbGpUBNf5BlSx6F0UNg
         oId2G5w3qxm9ZNLH3/jr9zH5DAO+OY9Wdmw7Hfg/SGFqNcQIDqs7BKPLGOfs49QaOBgs
         4yHJgXIAoll2N/yuSd/ZQLL7wMbdmIZmjSaBxA4SVUrlp+Dk9Tp3OlWYBccJGsy7OAtC
         KqLa6EegNKt4Y7lQWxYqh3yrV5J3rLnIiUUvyEHRTKBPrER0F2UrcfVOzEzQFhinEeyr
         E91sttNIXqhWKUBtgLDsEZxFyQLQWnhKkbLoJ8Mn9f9keGCgZ0N6rDZokiWwnfyTz9qf
         r+zw==
X-Gm-Message-State: AOAM530Wyti1j2xnZUJyWlUPT/SPg5P/T2/HgDiKzzuljdKfB8uiu1r1
        jmWG6E8GiE4KddLsNCKUB+4GPCJRTfTWVYEJ3VuJfGb08WpQxH/cYDs4fQi080mxOGZev3VhRMa
        E4VnJN1Stc9ysWsVh586fSRceSL4oOjndp9Kh2mt8PmBHtt+TmxY5dpbIRA8lAzI=
X-Google-Smtp-Source: ABdhPJxq8mn6fuMbbdu1h5R7+zyV5d25xOeWf4zul6b0LU+hwH25JEt9XvBSD8OaMKnqhafSgAtnacns6f3GUQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:afcf:: with SMTP id
 d15mr18248796ybj.320.1633396769892; Mon, 04 Oct 2021 18:19:29 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:14 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 04/11] KVM: arm64: vgic-v3: Check ITS region is not above
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

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 61728c543eb9..ad55bb8cd30f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2710,8 +2710,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (copy_from_user(&addr, uaddr, sizeof(addr)))
 			return -EFAULT;
 
-		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
-					addr, SZ_64K);
+		ret = vgic_check_iorange(dev->kvm, its->vgic_its_base,
+					 addr, SZ_64K, KVM_VGIC_V3_ITS_SIZE);
 		if (ret)
 			return ret;
 
-- 
2.33.0.800.g4c38ced690-goog

