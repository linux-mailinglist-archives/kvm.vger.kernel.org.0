Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B30A339505
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhCLRci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:32:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232217AbhCLRc3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615570348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfjQAaDuP/mR3DD+OPNLQ/Xq5ck0L3n/VihUobqZSI8=;
        b=d5R6HAPL32+pTxTqaXHYJ6RL5SJYgxhs4KNasVh2X9fkhnhc5sRF8bsvTto9AoHrkxvJs1
        KbtJailgGxdSkMUNQazo3Ky52wM5oXhfOAMm1717nlKudw/XMfUtgYvPnGaXvNyTplzsxS
        tyYxRRosiy6Uy/RhmxbkKHJc3cTev1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-0ug2o4rDM-GUI5JrHKAsvw-1; Fri, 12 Mar 2021 12:32:27 -0500
X-MC-Unique: 0ug2o4rDM-GUI5JrHKAsvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29D381015C85;
        Fri, 12 Mar 2021 17:32:25 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC73E1002EE6;
        Fri, 12 Mar 2021 17:32:21 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v3 3/8] KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
Date:   Fri, 12 Mar 2021 18:31:57 +0100
Message-Id: <20210312173202.89576-4-eric.auger@redhat.com>
In-Reply-To: <20210312173202.89576-1-eric.auger@redhat.com>
References: <20210312173202.89576-1-eric.auger@redhat.com>
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
2.26.2

