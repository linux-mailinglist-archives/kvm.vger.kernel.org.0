Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1732D8979
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404770AbgLLSzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:55:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407763AbgLLSwX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:52:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlbOv5ii6grQlFjgIBY+uOK3pf0pS/ezgT4J4s7SvgU=;
        b=gwHB8pmrvj9YDNwZkbtBbkMZJ53z9oSWeuN/dbmqnenFBl1Do4gOTwd0dnYWZlTFl+rVat
        qPn5d+hVoyYdJfubpeVc+fLxYGrPvdvbPSJMRsZAtN8cha/lUHsoeNG+NDHbgs2yY2g2EQ
        9FZaALo/xWzdKz4WWnjFfecRbTrE49U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-8mLKiPbROjeUz8Ab6OySaQ-1; Sat, 12 Dec 2020 13:50:55 -0500
X-MC-Unique: 8mLKiPbROjeUz8Ab6OySaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF599107ACE3;
        Sat, 12 Dec 2020 18:50:53 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFA9F1F069;
        Sat, 12 Dec 2020 18:50:48 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 7/9] KVM: arm64: Simplify argument passing to vgic_uaccess_[read|write]
Date:   Sat, 12 Dec 2020 19:50:08 +0100
Message-Id: <20201212185010.26579-8-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of converting the vgic_io_device handle to a kvm_io_device
handled and then do the oppositive, pass a vgic_io_device pointer all
along the call chain.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b2d73fc0d1ef..48c6067fc5ec 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -938,10 +938,9 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 	return region;
 }
 
-static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 			     gpa_t addr, u32 *val)
 {
-	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
 	const struct vgic_register_region *region;
 	struct kvm_vcpu *r_vcpu;
 
@@ -960,10 +959,9 @@ static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	return 0;
 }
 
-static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 			      gpa_t addr, const u32 *val)
 {
-	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
 	const struct vgic_register_region *region;
 	struct kvm_vcpu *r_vcpu;
 
@@ -986,9 +984,9 @@ int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
 		 bool is_write, int offset, u32 *val)
 {
 	if (is_write)
-		return vgic_uaccess_write(vcpu, &dev->dev, offset, val);
+		return vgic_uaccess_write(vcpu, dev, offset, val);
 	else
-		return vgic_uaccess_read(vcpu, &dev->dev, offset, val);
+		return vgic_uaccess_read(vcpu, dev, offset, val);
 }
 
 static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
-- 
2.21.3

