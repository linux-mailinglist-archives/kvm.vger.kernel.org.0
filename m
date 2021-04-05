Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D078635455A
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242462AbhDEQkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234129AbhDEQkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 12:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEFChuAVCf9U3ksntSEVq3EEZP4wMNr2xt1gXOCeheg=;
        b=FXZASvyAYoupHq7TpkTFly6V+TWoCGKkSyyHFOS67fbaHQL6mEmRs/AQHJhEg4qDzGeOQl
        5GZhuQD7y+ValSirzIPFQCUO8u41yhAbO8QN06h/WXZT8tece09KvdCK9QnQcahqYHDvcg
        +2yUTjfiB4Za6J74OFO3GKiMpeY7vTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-SCwVWr90NKeDSh9oP89Tmw-1; Mon, 05 Apr 2021 12:40:03 -0400
X-MC-Unique: SCwVWr90NKeDSh9oP89Tmw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B6B3108BD09;
        Mon,  5 Apr 2021 16:40:02 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBF0519715;
        Mon,  5 Apr 2021 16:39:59 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v6 3/9] KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
Date:   Mon,  5 Apr 2021 18:39:35 +0200
Message-Id: <20210405163941.510258-4-eric.auger@redhat.com>
In-Reply-To: <20210405163941.510258-1-eric.auger@redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

