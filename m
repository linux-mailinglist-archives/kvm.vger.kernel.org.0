Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052E1351136
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 10:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhDAIxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 04:53:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233080AbhDAIww (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 04:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617267172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhZSXvwDwJuBlcRF91oEmJLWfxeMxVgFzfRQMi4oMHg=;
        b=bnlmMM8bKSmgyXa0S5ERLtkbXSlC7MajmZ39Yk2CC+Vo+uIR0etui9aOV1ee4zFaSY6ZOY
        fTLQ/unDHu0ilWmd9Wn/46jpPml3oSMV6kY2punmeET3rrBWEnMiAi6/ojQ9OiKMFCp/KN
        ahLnKXxO9IGhqqc/6dZ6GF5+iNRgADg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-808oxu-_OVaRBC5qHRnr9Q-1; Thu, 01 Apr 2021 04:52:50 -0400
X-MC-Unique: 808oxu-_OVaRBC5qHRnr9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 689B6108BD06;
        Thu,  1 Apr 2021 08:52:49 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C73AD5D9CC;
        Thu,  1 Apr 2021 08:52:46 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v4 2/8] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
Date:   Thu,  1 Apr 2021 10:52:32 +0200
Message-Id: <20210401085238.477270-3-eric.auger@redhat.com>
In-Reply-To: <20210401085238.477270-1-eric.auger@redhat.com>
References: <20210401085238.477270-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The doc says:
"The characteristics of a specific redistributor region can
 be read by presetting the index field in the attr data.
 Only valid for KVM_DEV_TYPE_ARM_VGIC_V3"

Unfortunately the existing code fails to read the input attr data.

Fixes: 04c110932225 ("KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION")
Cc: stable@vger.kernel.org#v4.17+
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

---

v1 -> v2:
- in the commit message, remove the statement that the index always is 0
- add Alexandru's R-b
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 44419679f91ad..2f66cf2472825 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -226,6 +226,9 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 		u64 addr;
 		unsigned long type = (unsigned long)attr->attr;
 
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
 		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
 		if (r)
 			return (r == -ENODEV) ? -ENXIO : r;
-- 
2.26.3

