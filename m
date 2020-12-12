Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F042D896C
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407759AbgLLSwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:52:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407744AbgLLSwE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BdGsydJTiQm/M6xJTXUVfv5CezsJI9l7viP4YuCYYo=;
        b=Hi4g1ilDsBnlbvHnHZv65RIAp+ApNcRB0E9o8pdRcb7+WxfkFkBIFrANA0tyZ1dhSgjiFt
        OSbLgnotjkWJP8vJfPGGXZFTs+4Jcmyl+/Q0zlwY5nimjfgQhobxJ/lJjNHsgti8F0iiHV
        +ThQb3OnRxpe3kvRftF+0Pm3DagjhS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-5mjWVj-oMSOIO5Qmv8Os0w-1; Sat, 12 Dec 2020 13:50:37 -0500
X-MC-Unique: 5mjWVj-oMSOIO5Qmv8Os0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 936C3180A087;
        Sat, 12 Dec 2020 18:50:35 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA1FB1F45B;
        Sat, 12 Dec 2020 18:50:32 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 3/9] KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
Date:   Sat, 12 Dec 2020 19:50:04 +0100
Message-Id: <20201212185010.26579-4-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vgic_register_all_redist_iodevs may succeed while
vgic_register_all_redist_iodevs fails. For example this can happen
while adding a redistributor region overlapping a dist region. The
failure only is detected on vgic_register_all_redist_iodevs when
vgic_v3_check_base() gets called.

In such a case, remove the newly added redistributor region and free
it.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 8e8a862def76..581f0f490000 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -866,8 +866,14 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 * afterwards will register the iodevs when needed.
 	 */
 	ret = vgic_register_all_redist_iodevs(kvm);
-	if (ret)
+	if (ret) {
+		struct vgic_redist_region *rdreg =
+			vgic_v3_rdist_region_from_index(kvm, index);
+
+		list_del(&rdreg->list);
+		kfree(rdreg);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.21.3

