Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6420919E5AF
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgDDOiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34265 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgDDOiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3BV988DpZ1VkA4WWHvhl1mOj9xBGw7xFZ3+tYvTVds=;
        b=i0nZFb2v/59MmX69hdE4+RVZcTvJBB3qHwm5JSgGUlPFFN9mm3qreznw4upG7UGxwCbk74
        VDLrLGZa1OoFlMSILNVgjuAIf0KyxnKxzBfv2Fn0U/aWifeoDYa3m47Tg+aro7zpunDoAy
        yvzgbglUEArAfEtDYPl8KUOiD5bfUcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-T2IZTTFqOt2WcY50aea6BQ-1; Sat, 04 Apr 2020 10:38:10 -0400
X-MC-Unique: T2IZTTFqOt2WcY50aea6BQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3BAF18AB2C0;
        Sat,  4 Apr 2020 14:38:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C67F69B912;
        Sat,  4 Apr 2020 14:38:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Zenghui Yu <yuzenghui@huawei.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 12/39] arm64: timer: Use the proper RDist register name in GICv3
Date:   Sat,  4 Apr 2020 16:37:04 +0200
Message-Id: <20200404143731.208138-13-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

We're actually going to read GICR_ISACTIVER0 and GICR_ISPENDR0 (in
SGI_base frame of the redistribitor) to get the active/pending state
of the timer interrupt.  Fix this typo.

And since they have the same value, there's no functional change.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c          | 4 ++--
 lib/arm/asm/gic-v3.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 94543f231ba9..10a88f3f1d19 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -351,8 +351,8 @@ static void test_init(void)
 		gic_icenabler =3D gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
-		gic_isactiver =3D gicv3_sgi_base() + GICD_ISACTIVER;
-		gic_ispendr =3D gicv3_sgi_base() + GICD_ISPENDR;
+		gic_isactiver =3D gicv3_sgi_base() + GICR_ISACTIVER0;
+		gic_ispendr =3D gicv3_sgi_base() + GICR_ISPENDR0;
 		gic_isenabler =3D gicv3_sgi_base() + GICR_ISENABLER0;
 		gic_icenabler =3D gicv3_sgi_base() + GICR_ICENABLER0;
 		break;
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 0dc838b3ab2d..e2736a12b319 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -32,6 +32,10 @@
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
 #define GICR_ICENABLER0			GICD_ICENABLER
+#define GICR_ISPENDR0			GICD_ISPENDR
+#define GICR_ICPENDR0			GICD_ICPENDR
+#define GICR_ISACTIVER0			GICD_ISACTIVER
+#define GICR_ICACTIVER0			GICD_ICACTIVER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
=20
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
--=20
2.25.1

