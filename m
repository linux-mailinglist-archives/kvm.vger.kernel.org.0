Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017FA4064F9
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhIJBQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhIJBPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:15:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AB2C08ED4B
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 17:49:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j4-20020a258b84000000b005a203c5e066so173028ybl.19
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 17:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PnmYaOqrQjNWrJEqxLGOl8MYEOt5oEWk1M6ZydsFVAE=;
        b=TQM4yg1FQfOHBQ3ZAvGNocrqsOwJKAxncc4mbKyCgHs5sxi89dK2qKe5iyJqq1tvRR
         An/tkJry/YQJFz5NFvLeQWjiGWZV0FNQxX6QlpwEu0YEYlcLf/SL1VEosgZip9wKDt1o
         Qheb62L3ihr6th3Wp84yvD/P8BtLuGFAkktnoXOnaBiIIMQaGKUV/XNawWcPtC3IO1Zm
         0PKmKFlrBx8a1DpltbAaAi8pbfBr3joPqTjnBeN5wsA5zCOQ9NbF8ymQAuzxwkHJE4gc
         R4LfXayln5UN0nhCcF3OFkoL9yv7E/nF1z8EpdhuBipWE0CNvsIFi3c4iq0iRIHRk7ye
         J2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PnmYaOqrQjNWrJEqxLGOl8MYEOt5oEWk1M6ZydsFVAE=;
        b=oaSWA3DOn0RathJHVPb/Vuk7mefs1QXLoF1nghOU0gQo9ii3AYfJQ4FXOrnRxdL20W
         6Ti8/SPztFD9eTGbTZtdOYbrysCKbprt1MMXDAAMlv7rsnXZWSkgUreFWXB3FCBliL/A
         A+xZxHgDnf1Ibtv2UKWiLlS1lrLn75PACq5IpGUEzF8YfiWmh7FtjgNd3DS6C6oBL3yG
         jKBf1A7ScJCOegOqFzS5EHlPPJVnkZcNBLmX/qkfbXSVwIQnFVH3CJGPMGaf/OfjDOB8
         ZLvt392hyboV13Ymynf4VAsPp422xHRUTnyjsxxXo8dJTVd1DLQXIAzvX+9PFs1b9M55
         9qqQ==
X-Gm-Message-State: AOAM5302+F5sqAHD0RAeaGVPBLrSIJn7Upwl2jhOOA/fwmhHnTV1xZ9n
        vT9uOXQxjGgYUBEOF5CKzj8c5Ngr+MnP+7LWu2IFZtxxhr2NfF06LX71ZRa6Kyl5rLNXI8ChPOC
        13VD6E2FSGHgKJ1DwfILvB9T7tw436VhcGhtmw8/n0jjBq20eT89V/hQflS2VCJQ=
X-Google-Smtp-Source: ABdhPJwltqINxS2/XMXrxLmWX9yF6gQpclVmbDxaDjAl+YaM/CMRTWEuXw0zyveFYzixo9Vkn5FgkDdOFdD6Tg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:7409:: with SMTP id
 p9mr7587625ybc.462.1631234963645; Thu, 09 Sep 2021 17:49:23 -0700 (PDT)
Date:   Thu,  9 Sep 2021 17:49:18 -0700
In-Reply-To: <20210910004919.1610709-1-ricarkol@google.com>
Message-Id: <20210910004919.1610709-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210910004919.1610709-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 1/2] KVM: arm64: vgic: check redist region is not above the
 VM IPA size
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
VM-specified IPA size (phys_size). This can happen when using
KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with:

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_v3_alloc_redist_region() which is called
when setting the regions, and into vgic_v3_check_base() which is called
when attempting the first vcpu-run. The vcpu-run check does not apply to
KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
before the first vcpu-run. Finally, this patch also enables some extra
tests in vgic_v3_alloc_redist_region() by calculating "size" early for
the legacy redist api.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
 arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..055671bede85 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
 	struct list_head *rd_regions = &d->rd_regions;
-	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE :
+			nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
 	/* cross the end of memory ? */
@@ -834,6 +836,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	if (vgic_v3_rdist_overlap(kvm, base, size))
 		return -EINVAL;
 
+	if (base + size > kvm_phys_size(kvm))
+		return -E2BIG;
+
 	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
 	if (!rdreg)
 		return -ENOMEM;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 66004f61cd83..5afd9f6f68f6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
 		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
 			rdreg->base)
 			return false;
+
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
+			kvm_phys_size(kvm))
+			return false;
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
-- 
2.33.0.309.g3052b89438-goog

