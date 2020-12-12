Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768432D8980
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407752AbgLLSwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:52:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgLLSv7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:51:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRu7FhoYj+iXi1m//Yx7IJ9OctRxhpZYB5NeyA8SUmk=;
        b=A0+KL0oe9NG5zExx2UkPnw7TeMzjNnciFy+QplK+cYVLLeUV4bin+iEFk3AjDcao6rP/Od
        Io74xXZYcLt2wIzQhhrRFZYlHg0NRuZNRAKh3wfXu+43WkbGh8cKzj2cjKvJW/jqa+mxQV
        ih1x0mqHBG1y0XuvhpftQZpsWbY5ork=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-HqWWyWeLNnqf-MJRL5v7cQ-1; Sat, 12 Dec 2020 13:50:30 -0500
X-MC-Unique: HqWWyWeLNnqf-MJRL5v7cQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3246A107ACE3;
        Sat, 12 Dec 2020 18:50:29 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 492F01F069;
        Sat, 12 Dec 2020 18:50:26 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 1/9] KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
Date:   Sat, 12 Dec 2020 19:50:02 +0100
Message-Id: <20201212185010.26579-2-eric.auger@redhat.com>
In-Reply-To: <20201212185010.26579-1-eric.auger@redhat.com>
References: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 15a6c98ee92f..8e8a862def76 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -792,8 +792,13 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
 	int ret;
 
 	/* single rdist region already set ?*/
-	if (!count && !list_empty(rd_regions))
-		return -EINVAL;
+	if (!count && !list_empty(rd_regions)) {
+		rdreg = list_last_entry(rd_regions,
+				       struct vgic_redist_region, list);
+		if (rdreg->count)
+			return -EINVAL; /* Mixing REDIST and REDIST_REGION API */
+		return -EEXIST;
+	}
 
 	/* cross the end of memory ? */
 	if (base + size < base)
-- 
2.21.3

