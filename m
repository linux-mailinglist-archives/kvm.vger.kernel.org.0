Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A9A353914
	for <lists+kvm@lfdr.de>; Sun,  4 Apr 2021 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhDDRXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 13:23:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhDDRXI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Apr 2021 13:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617556983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEFChuAVCf9U3ksntSEVq3EEZP4wMNr2xt1gXOCeheg=;
        b=jKynAAD6yEdi9Vhqy4nH0GURDVjE9WVkgf/9WLuRyQuxl7lgYHoD1VYsREO3xBIHEL7N5d
        lbyltA56oPdzfu/eOJDt2NIvKg//saK8xuflm7x1haxZlORBB7Jz/yzd6qzDdan5aOH8d+
        IZvKU/7ks2nd3OQjTV205EMBE5OT4Rs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-ILd6NC2wPaKEScSDD53Wag-1; Sun, 04 Apr 2021 13:22:59 -0400
X-MC-Unique: ILd6NC2wPaKEScSDD53Wag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE4B984B9A0;
        Sun,  4 Apr 2021 17:22:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3166B10027C4;
        Sun,  4 Apr 2021 17:22:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v5 2/8] KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
Date:   Sun,  4 Apr 2021 19:22:37 +0200
Message-Id: <20210404172243.504309-3-eric.auger@redhat.com>
In-Reply-To: <20210404172243.504309-1-eric.auger@redhat.com>
References: <20210404172243.504309-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vgic_v3_insert_redist_region() may succeed while
vgic_register_all_redist_iodevs fails. For example this happens
while adding a redistributor region overlapping a dist region. The
failure only is detected on vgic_register_all_redist_iodevs when
vgic_v3_check_base() gets called in vgic_register_redist_iodev().

In such a case, remove the newly added redistributor region and free
it.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- fix the commit message and split declaration/assignment of rdreg
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ef9baf0d01b5..fec0555529c0 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -861,8 +861,14 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 * afterwards will register the iodevs when needed.
 	 */
 	ret = vgic_register_all_redist_iodevs(kvm);
-	if (ret)
+	if (ret) {
+		struct vgic_redist_region *rdreg;
+
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+		list_del(&rdreg->list);
+		kfree(rdreg);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.26.3

