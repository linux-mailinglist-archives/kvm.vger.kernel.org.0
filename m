Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB154421BB8
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 03:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhJEBVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 21:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhJEBVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 21:21:17 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B718C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 18:19:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t4-20020a62ea04000000b0044b333f5d1bso10063190pfh.20
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 18:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s3xltIzsYJNvc5KBWR9SiqSnE8fIX4FxYbfqcY5QUX0=;
        b=I6/r3MzMU5CFY876x0aTrbmKMG/j/+Or+zP8y0iMwj6fg+wx7+vRtBMR4dw1KGMecs
         z35IocNtSKNOsk1oS3cmsjDvUWYcg8e8onvzb8nA4LX9HNLuWBjwAV/q8EVjYsNvnR5l
         YTUrHF0r07TOWN3T0iobAIGMCA/PN8RUXhLRxQW3XczLErvUxgawV/tKuze1yAqIWR1k
         PXSc7igTVU/Eu4bs3AOMjO4OcR3ErJCzTt25DFyvNqAYPul/PkqZKuqPuqwGZWEBobux
         8gCdhhbVjl6+YzQzHKntOkni8Msvq2vYwItGq6ks6IOeRvhyo2MH6sZWqtuR4/eyuG+2
         pOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s3xltIzsYJNvc5KBWR9SiqSnE8fIX4FxYbfqcY5QUX0=;
        b=DsdggwV88mbU8EY7j5MevaTuxl5OyVyyaEWmODP3i5NcXtE2u312F7v9lF0vse9MxS
         pDs88e7x0RSgssRGPrEntTng7uhXnXonhIafM2fwxQ8NNypU7nEU7PMeQ4nD7WiqjUVb
         pQqylJRnd40r07FAo/g3REX6QTfZFes/cANyhZJ8owjWiUFYSpGnK/xEoQs6TkXZOTPw
         PoMb3AKMMTxiTtrhiaP1mUvcf6z8SFctNab1NLCI7/NdYH+WvEZOkkr6HA8ZKs0pZKqU
         Tdhwrt33uqpx10uH0jWevYJ9fD54dEQnvgVLQN5IVqT13+rLw1JIL+AAUJBVBez7elMj
         /asg==
X-Gm-Message-State: AOAM532TcrRW+EXcaWOWLVA3GO6LedKTfleFm/Cd1u4+1dKx2KeUBLwr
        eUqgWDOZBogLh20p66T7dhk36f6oiI2I2CPHkqYXPLNyhupvdqL+2uCnsAhpfbJkeCCe7BUlMsD
        pUmxKEtgQ5k0nE03SSQAd1Po958wNNOW3ocrCjiB9K1GWidf6XV2xLalDOd5mavs=
X-Google-Smtp-Source: ABdhPJx0XFoNulJXBdAqxqOjZ6ph+wHgisGlOL9U1ysYd2LTNOvevol0FO9yBpx4Sppw6M5H7GCXXsB2v0HUHQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bd45:b0:13d:b4d1:eb39 with SMTP
 id b5-20020a170902bd4500b0013db4d1eb39mr2550140plx.53.1633396766782; Mon, 04
 Oct 2021 18:19:26 -0700 (PDT)
Date:   Mon,  4 Oct 2021 18:19:12 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 02/11] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
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

Verify that the redistributor regions do not extend beyond the
VM-specified IPA range (phys_size). This can happen when using
KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with:

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_v3_alloc_redist_region() which is called
when setting the regions, and into vgic_v3_check_base() which is called
when attempting the first vcpu-run. The vcpu-run check does not apply to
KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
before the first vcpu-run. Note that using the REDIST_REGIONS API
results in a different check, which already exists, at first vcpu run:
that the number of redist regions is enough for all vcpus.

Finally, this patch also enables some extra tests in
vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
redist api: like checking that the REDIST region can fit all the already
created vcpus.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..a9642fc71fdf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
 	struct list_head *rd_regions = &d->rd_regions;
-	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
+			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
 	/* cross the end of memory ? */
@@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 
 	rdreg->base = VGIC_ADDR_UNDEF;
 
-	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
+	ret = vgic_check_iorange(kvm, rdreg->base, base, SZ_64K, size);
 	if (ret)
 		goto free;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 21a6207fb2ee..960f51a8691f 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -483,8 +483,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
 		return false;
 
 	list_for_each_entry(rdreg, &d->rd_regions, list) {
-		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
-			rdreg->base)
+		size_t sz = vgic_v3_rd_region_size(kvm, rdreg);
+
+		if (vgic_check_iorange(kvm, VGIC_ADDR_UNDEF,
+				       rdreg->base, SZ_64K, sz))
 			return false;
 	}
 
-- 
2.33.0.800.g4c38ced690-goog

