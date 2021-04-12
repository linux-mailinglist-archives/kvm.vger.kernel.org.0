Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E335C951
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbhDLPBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 11:01:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241096AbhDLPBJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 11:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618239650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VNdKS9KNgagmrHQvjGL4Hvng5mswnO3U1Do4oQAu2Vo=;
        b=CRkvwHs5cdZwe2Y7eBBxafI/FD11R5smXyqfnJ+DovWDjLnFvnr/RR8OabvKwIbwGhNvTg
        0EN676r7Bx9zAzgiwx248f20txp1KIZknlDclXVMyKWy5q7D0jU9pmPqVNxy6oMT+19IRB
        z0VNFl5UvzqIB2s+3rthM0ho+okjTQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-zHNgWqTNMCqnuTnLJSnPSQ-1; Mon, 12 Apr 2021 11:00:47 -0400
X-MC-Unique: zHNgWqTNMCqnuTnLJSnPSQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E157108C317;
        Mon, 12 Apr 2021 15:00:43 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-253.ams2.redhat.com [10.36.113.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95F165D6D1;
        Mon, 12 Apr 2021 15:00:39 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        james.morse@arm.com
Cc:     drjones@redhat.com, gshan@redhat.com
Subject: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
Date:   Mon, 12 Apr 2021 17:00:34 +0200
Message-Id: <20210412150034.29185-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When reading the base address of the a REDIST region
through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
redistributor region list to be populated with a single
element.

However list_first_entry() expects the list to be non empty.
Instead we should use list_first_entry_or_null which effectively
returns NULL if the list is empty.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: <Stable@vger.kernel.org> # v4.18+
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 44419679f91a..5eaede3e3b5a 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -87,8 +87,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
 			goto out;
 		}
-		rdreg = list_first_entry(&vgic->rd_regions,
-					 struct vgic_redist_region, list);
+		rdreg = list_first_entry_or_null(&vgic->rd_regions,
+						 struct vgic_redist_region, list);
 		if (!rdreg)
 			addr_ptr = &undef_value;
 		else
-- 
2.26.3

