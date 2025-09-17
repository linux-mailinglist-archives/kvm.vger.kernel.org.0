Return-Path: <kvm+bounces-57852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D21B7F084
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8892D1C25F4C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D1C36999A;
	Wed, 17 Sep 2025 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="bberKOrO"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D49E33595A
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 12:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113972; cv=none; b=cC4EYsOyovEh0VNP6NMazm5ZxJLwdg3/rjC4S6ZmCY2wB2IPyKQJhxyv6FGzFCA12MMiXhsdhLHMv+tceCnh5yGSsZtSmTf21BoP6mNASUJ4dtkDa9ar55CcEv+A6u1DYRfPP9xxX/147TYyor7+a7KuiioIOfSl1A83+G1k3iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113972; c=relaxed/simple;
	bh=i7Yy9gb2doO+AUTEx+glLOIQJPVccsTf1WOdxMLVGps=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eHGvF96fXNNpjl+vE3/wu3k7fn9KKxvs3VNmwwVnc+/srM/VFCitNnwbsORBXixAOlQS6HG+ZacMS5+9VLWUUhL9pgZeDxXO0cY1q6Gu1C8r6lQAcFkoSsh8jhYSIFj1BMh463+hfmZlSJhlDzn+o5sajJUrr2LF1oSV9WXTEAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=bberKOrO reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6l008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:37 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=I0NMvF5OGZVy1ri6cDaaDK+4nakFScwWAWwMOrizyQw=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113797; v=1;
        b=bberKOrO6J7tY0L7zJPCCBce2lzuLyNtHl2vnIJUXIZZMwbfrJwuttLnlc9sonPs
         14JtvF6GMhefXFETjBqtOUjw14A2IcAg4+INF921qr21btTZ10oeoS6eqXhEYTpc
         d2+qDuD7DVPiUYKJcmYxuegzPPIPRVujjO8SrPvhayhKHi+7JNbbJ8+F88JzRNdg
         tZdN/NDdvDo+XlEfojYYM41UVanxTLjA+D/SRzZw2zeqJAQ8nsVebcxYrGGVVMh0
         7LIYrh0+uNGOWQXR1XPZA8cO1V4zTuMbGIifi4NtgOtyxInjjcjlxVpfI1G5DRRW
         TFV4JVQb0q8Jp6z3Ra2GfQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:19 +0900
Subject: [PATCH 07/35] hw/dma: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-7-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

The name arguments were used to distinguish AddresSpaces in debugging
output, but they will represent property names after QOM-ification and
debugging output will show QOM paths. So change them to make them more
concise and also avoid conflicts with other properties.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 hw/dma/bcm2835_dma.c   | 2 +-
 hw/dma/pl080.c         | 3 +--
 hw/dma/pl330.c         | 3 +--
 hw/dma/rc4030.c        | 5 ++---
 hw/dma/xilinx_axidma.c | 4 ++--
 hw/dma/xlnx-zdma.c     | 2 +-
 hw/dma/xlnx_csu_dma.c  | 2 +-
 7 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/hw/dma/bcm2835_dma.c b/hw/dma/bcm2835_dma.c
index ebef56d8d613..8ff266c48882 100644
--- a/hw/dma/bcm2835_dma.c
+++ b/hw/dma/bcm2835_dma.c
@@ -380,7 +380,7 @@ static void bcm2835_dma_realize(DeviceState *dev, Error **errp)
 
     obj = object_property_get_link(OBJECT(dev), "dma-mr", &error_abort);
     s->dma_mr = MEMORY_REGION(obj);
-    address_space_init(&s->dma_as, NULL, s->dma_mr, TYPE_BCM2835_DMA "-memory");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr,  "as");
 
     bcm2835_dma_reset(dev);
 }
diff --git a/hw/dma/pl080.c b/hw/dma/pl080.c
index cf02a484d6a6..1b6e9f741330 100644
--- a/hw/dma/pl080.c
+++ b/hw/dma/pl080.c
@@ -398,8 +398,7 @@ static void pl080_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->downstream_as, NULL, s->downstream,
-                       "pl080-downstream");
+    address_space_init(&s->downstream_as, OBJECT(s), s->downstream, "as");
 }
 
 static void pl081_init(Object *obj)
diff --git a/hw/dma/pl330.c b/hw/dma/pl330.c
index 4733799f4045..e9bf8f86ee5a 100644
--- a/hw/dma/pl330.c
+++ b/hw/dma/pl330.c
@@ -1569,8 +1569,7 @@ static void pl330_realize(DeviceState *dev, Error **errp)
         s->mem_as = &address_space_memory;
     } else {
         s->mem_as = g_new0(AddressSpace, 1);
-        address_space_init(s->mem_as, NULL, s->mem_mr,
-                           memory_region_name(s->mem_mr));
+        address_space_init(s->mem_as, OBJECT(s), s->mem_mr, "as");
     }
 
     s->timer = timer_new_ns(QEMU_CLOCK_VIRTUAL, pl330_exec_cycle_timer, s);
diff --git a/hw/dma/rc4030.c b/hw/dma/rc4030.c
index cf76f90f4d3b..65f2c7f1bd19 100644
--- a/hw/dma/rc4030.c
+++ b/hw/dma/rc4030.c
@@ -688,8 +688,7 @@ static void rc4030_realize(DeviceState *dev, Error **errp)
     memory_region_init_iommu(&s->dma_mr, sizeof(s->dma_mr),
                              TYPE_RC4030_IOMMU_MEMORY_REGION,
                              o, "rc4030.dma", 4 * GiB);
-    address_space_init(&s->dma_as, NULL, MEMORY_REGION(&s->dma_mr),
-                       "rc4030-dma");
+    address_space_init(&s->dma_as, o, MEMORY_REGION(&s->dma_mr), "as");
 }
 
 static void rc4030_unrealize(DeviceState *dev)
@@ -698,7 +697,7 @@ static void rc4030_unrealize(DeviceState *dev)
 
     timer_free(s->periodic_timer);
 
-    address_space_destroy(&s->dma_as);
+    object_unparent(OBJECT(&s->dma_as));
     object_unparent(OBJECT(&s->dma_mr));
 }
 
diff --git a/hw/dma/xilinx_axidma.c b/hw/dma/xilinx_axidma.c
index 0f340abc2c6f..5f85b686fd18 100644
--- a/hw/dma/xilinx_axidma.c
+++ b/hw/dma/xilinx_axidma.c
@@ -588,8 +588,8 @@ static void xilinx_axidma_realize(DeviceState *dev, Error **errp)
         ptimer_transaction_commit(st->ptimer);
     }
 
-    address_space_init(&s->as, NULL,
-                       s->dma_mr ? s->dma_mr : get_system_memory(), "dma");
+    address_space_init(&s->as, OBJECT(s),
+                       s->dma_mr ? s->dma_mr : get_system_memory(), "as");
 }
 
 static void xilinx_axidma_init(Object *obj)
diff --git a/hw/dma/xlnx-zdma.c b/hw/dma/xlnx-zdma.c
index 9b9ccd1e3c08..ad93bab5d4fa 100644
--- a/hw/dma/xlnx-zdma.c
+++ b/hw/dma/xlnx-zdma.c
@@ -769,7 +769,7 @@ static void zdma_realize(DeviceState *dev, Error **errp)
         error_setg(errp, TYPE_XLNX_ZDMA " 'dma' link not set");
         return;
     }
-    address_space_init(&s->dma_as, NULL, s->dma_mr, "zdma-dma");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
 
     for (i = 0; i < ARRAY_SIZE(zdma_regs_info); ++i) {
         RegisterInfo *r = &s->regs_info[zdma_regs_info[i].addr / 4];
diff --git a/hw/dma/xlnx_csu_dma.c b/hw/dma/xlnx_csu_dma.c
index 8b88392bb92b..8a0ec5bc5b94 100644
--- a/hw/dma/xlnx_csu_dma.c
+++ b/hw/dma/xlnx_csu_dma.c
@@ -653,7 +653,7 @@ static void xlnx_csu_dma_realize(DeviceState *dev, Error **errp)
         error_setg(errp, TYPE_XLNX_CSU_DMA " 'dma' link not set");
         return;
     }
-    address_space_init(&s->dma_as, NULL, s->dma_mr, "csu-dma");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
 
     reg_array =
         register_init_block32(dev, xlnx_csu_dma_regs_info[!!s->is_dst],

-- 
2.51.0


