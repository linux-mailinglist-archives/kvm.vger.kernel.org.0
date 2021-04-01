Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD245351135
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 10:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhDAIxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 04:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233024AbhDAIwv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 04:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617267171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFDgWrjWMSMk4v/p6l+GMMcTkNEPFqFBG4PiCpy+Kw0=;
        b=d/wuCJFZYv0UnnB3OHCMqfXX09C9hyig/1F4xlb0VXkBW+vC+Tq62JdwKWue3gEZ7eU9St
        nZcisXiv0fyM2nWl6g1U2fUCNm4+9ywWSZUp6YBBjhMovPXSDxOF6FW+y+jv6oyDTZALSG
        T5WSCq2IqpAuNCsarT56QrRRyfkdDGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-p5EPH6ZUNQKtzQKx8K0sdQ-1; Thu, 01 Apr 2021 04:52:47 -0400
X-MC-Unique: p5EPH6ZUNQKtzQKx8K0sdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71D751005D54;
        Thu,  1 Apr 2021 08:52:46 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 692A45D9CC;
        Thu,  1 Apr 2021 08:52:43 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v4 1/8] KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
Date:   Thu,  1 Apr 2021 10:52:31 +0200
Message-Id: <20210401085238.477270-2-eric.auger@redhat.com>
In-Reply-To: <20210401085238.477270-1-eric.auger@redhat.com>
References: <20210401085238.477270-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_DEV_ARM_VGIC_GRP_ADDR group doc says we should return
-EEXIST in case the base address of the redist is already set.
We currently return -EINVAL.

However we need to return -EINVAL in case a legacy REDIST address
is attempted to be set while REDIST_REGIONS were set. This case
is discriminated by looking at the count field.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- simplify the check sequence
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 15a6c98ee92f0..013b737b658f8 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -791,10 +791,6 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
-	/* single rdist region already set ?*/
-	if (!count && !list_empty(rd_regions))
-		return -EINVAL;
-
 	/* cross the end of memory ? */
 	if (base + size < base)
 		return -EINVAL;
@@ -805,11 +801,14 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	} else {
 		rdreg = list_last_entry(rd_regions,
 					struct vgic_redist_region, list);
-		if (index != rdreg->index + 1)
-			return -EINVAL;
 
-		/* Cannot add an explicitly sized regions after legacy region */
-		if (!rdreg->count)
+		if ((!count) != (!rdreg->count))
+			return -EINVAL; /* Mix REDIST and REDIST_REGION */
+
+		if (!count)
+			return -EEXIST;
+
+		if (index != rdreg->index + 1)
 			return -EINVAL;
 	}
 
-- 
2.26.3

