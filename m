Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEF3130FEA
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgAFKD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:03:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24923 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726358AbgAFKD6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 05:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGq8jIO0VWZZTbw56WSpjkaJggbuvsp9A3LuUPZ0G4w=;
        b=TQJvHFVuCImrDqoQvheG0LPtGGGapSuS7QWM7A0P99nDFcOlvj+v2+tK1f5QrpCWYVT1XX
        PJ1Pb6sXHd3gYPu4j31EC9peWG/z3bNSX0MW7KXgAG0QOKv/uEkJRzs8B54wCqoDfBEmrp
        vJxECi5PWimCvLJTng0MRCckbwIrS4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-GmYwiBC3Ow633zNd9CiT6A-1; Mon, 06 Jan 2020 05:03:56 -0500
X-MC-Unique: GmYwiBC3Ow633zNd9CiT6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33E3B8024CD;
        Mon,  6 Jan 2020 10:03:55 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0456B63BCA;
        Mon,  6 Jan 2020 10:03:53 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Zeng Tao <prime.zeng@hisilicon.com>
Subject: [PULL kvm-unit-tests 04/17] devicetree: Fix the dt_for_each_cpu_node
Date:   Mon,  6 Jan 2020 11:03:34 +0100
Message-Id: <20200106100347.1559-5-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zeng Tao <prime.zeng@hisilicon.com>

If the /cpus node contains nodes other than /cpus/cpu*, for example:
/cpus/cpu-map/. The test will issue an unexpected assert error as
follow:
[root@localhost]# ./arm-run arm/spinlock-test.flat
qemu-system-aarch64 -nodefaults -machine virt,gic-version=3Dhost,accel=3D=
kvm
 -cpu host -device virtio-serial-device -device virtconsole,chardev=3Dctd
-chardev testdev,id=3Dctd -device pci-testdev -display none -serial stdio
-kernel arm/spinlock-test.flat # -initrd /tmp/tmp.mwPLiF4EWm
lib/arm/setup.c:64: assert failed: ret =3D=3D 0
        STACK:

In this patch, ignore the non-cpu subnodes instead of return an error.

Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devicetree.c b/lib/devicetree.c
index 2b89178a109b..102032491e26 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -225,7 +225,7 @@ int dt_for_each_cpu_node(void (*func)(int fdtnode, u6=
4 regval, void *info),
=20
 		prop =3D fdt_get_property(fdt, cpu, "device_type", &len);
 		if (prop =3D=3D NULL)
-			return len;
+			continue;
=20
 		if (len !=3D 4 || strcmp((char *)prop->data, "cpu"))
 			continue;
--=20
2.21.0

