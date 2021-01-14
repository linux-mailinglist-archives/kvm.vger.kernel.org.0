Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0D2F5F0C
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbhANKi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728611AbhANKi4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 05:38:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610620651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j9TnMIrfMqTIBlOW77DqorL571UxrU91q9rQs9SYttA=;
        b=Gj11UJS/pPAL0cx6EK6nbgKEDJ5WTDwpLeg+aTuqljD5wBj6phlR3dyfCLm6kp8W6sm/jR
        of2Rg6ZkdJdXQP3ph18d+RXVAstgMubCx93YvekVlZ5wq89RxfrGsvalaERQ04zQHOCWNE
        ZZToNbl+Rb038O5yCeoEmeD/WXmOTXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-hI1bxdpbMfCjvjfU-ZWXKQ-1; Thu, 14 Jan 2021 05:37:28 -0500
X-MC-Unique: hI1bxdpbMfCjvjfU-ZWXKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425861009446;
        Thu, 14 Jan 2021 10:37:26 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F17E12D7E;
        Thu, 14 Jan 2021 10:37:23 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v2 3/9] KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
Date:   Thu, 14 Jan 2021 11:37:02 +0100
Message-Id: <20210114103708.26763-4-eric.auger@redhat.com>
In-Reply-To: <20210114103708.26763-1-eric.auger@redhat.com>
References: <20210114103708.26763-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index 013b737b658f..987e366c8000 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -860,8 +860,14 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
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
2.21.3

