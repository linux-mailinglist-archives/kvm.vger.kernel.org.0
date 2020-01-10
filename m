Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EEE13704D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgAJOzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:55:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52228 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728422AbgAJOzC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 09:55:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578668101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDvgNibxatEEV/F+WDrLb9KYif/63RzRdW4qJaHm4B8=;
        b=K8BdgWuptBdYE63G3iqJD0xUVK+55fFiMNY3cb5QeXGzqdkHoCtTuOnMup+u/NfdX++aZ0
        6BxadmuhF1hyPkRzRughHJguWLS2MMb5Sr3MWZZLj/AOaaUDP3CHeqvVVam+SgH8yDbiLZ
        53cpcB3Zb7g6D/0UDY4+bekf/uzlqDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-DYg8o0oeNLOx-mCafe7VpQ-1; Fri, 10 Jan 2020 09:55:00 -0500
X-MC-Unique: DYg8o0oeNLOx-mCafe7VpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 068151085984;
        Fri, 10 Jan 2020 14:54:59 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 989097BA5F;
        Fri, 10 Jan 2020 14:54:53 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 08/16] arm/arm64: ITS: Init the command queue
Date:   Fri, 10 Jan 2020 15:54:04 +0100
Message-Id: <20200110145412.14937-9-eric.auger@redhat.com>
In-Reply-To: <20200110145412.14937-1-eric.auger@redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the command queue and initialize related registers:
CBASER, CREADR, CWRITER.

The command queue is 64kB. This aims at not bothing with fullness.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- removed readr
---
 lib/arm/asm/gic-v3-its.h |  6 ++++++
 lib/arm/gic-v3-its.c     | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 2f8b8f1..93814f7 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -75,10 +75,16 @@ struct its_baser {
 	int esz;
 };
=20
+struct its_cmd_block {
+	u64     raw_cmd[4];
+};
+
 struct its_data {
 	void *base;
 	struct its_typer typer;
 	struct its_baser baser[GITS_BASER_NR_REGS];
+	struct its_cmd_block *cmd_base;
+	struct its_cmd_block *cmd_write;
 };
=20
 extern struct its_data its_data;
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 6c97569..3037c84 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -177,3 +177,25 @@ void set_pending_table_bit(int rdist, int n, bool se=
t)
 		byte &=3D ~mask;
 	*ptr =3D byte;
 }
+
+/**
+ * init_cmd_queue: Allocate the command queue and initialize
+ * CBASER, CREADR, CWRITER
+ */
+void init_cmd_queue(void);
+void init_cmd_queue(void)
+{
+	unsigned long n =3D SZ_64K >> PAGE_SHIFT;
+	unsigned long order =3D fls(n);
+	u64 cbaser;
+
+	its_data.cmd_base =3D (void *)virt_to_phys(alloc_pages(order));
+
+	cbaser =3D ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)	|
+			GITS_CBASER_VALID);
+
+	writeq(cbaser, its_data.base + GITS_CBASER);
+
+	its_data.cmd_write =3D its_data.cmd_base;
+	writeq(0, its_data.base + GITS_CWRITER);
+}
--=20
2.20.1

