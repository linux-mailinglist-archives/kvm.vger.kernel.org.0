Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322B6339502
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhCLRch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:32:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231928AbhCLRcU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615570340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7rQ5JvwHZU2XBncrE7tSoBDfZg7trh611M/+N48Z8Y=;
        b=jLN3GtK82Xx9Fcg8m9RpQVHYpdzMYmDdnInp97I7FAqkv1UJwwZLhMwuGc8Gk7xMrIpOJ6
        ReMxA47oeW9tWJJ/ndzg88wyOnIunz1mWPV5i+3QyBmuOp6wV8Zz/NBm7gdCe9DZTSOg/y
        6q5z9XnTEl0xo/CRrM2wHyQ4qw2bnm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-SS01kqT_PZqmkhf2MiCfgA-1; Fri, 12 Mar 2021 12:32:18 -0500
X-MC-Unique: SS01kqT_PZqmkhf2MiCfgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B1493920;
        Fri, 12 Mar 2021 17:32:16 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF2EF1002388;
        Fri, 12 Mar 2021 17:32:13 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v3 1/8] KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
Date:   Fri, 12 Mar 2021 18:31:55 +0100
Message-Id: <20210312173202.89576-2-eric.auger@redhat.com>
In-Reply-To: <20210312173202.89576-1-eric.auger@redhat.com>
References: <20210312173202.89576-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 15a6c98ee92f..013b737b658f 100644
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
2.26.2

