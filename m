Return-Path: <kvm+bounces-57875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 373CDB7F203
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99DC062616B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C0C32BC1A;
	Wed, 17 Sep 2025 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="VXF6Tg0S"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDFA319611
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114263; cv=none; b=dhcOqmJbnJ6JSZDOz/nKmnD7NlOJpBWUptXnLzKFptxnSO/kX0wEH5o0M+2LUj4plhWrdgCZe/f7CLADkrOSFViDMNCzzI8tGESQoUCqM9pchqeyzawADYwJnsFAgLgH/EyooRO3Wx0AK+gqYxVwpFHQl1kiwLjJeugOxXhkt60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114263; c=relaxed/simple;
	bh=YNXyXnq0aaYwLnJVmrInvXDlghil7iNl3UIE/vCya74=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ByVHHXvAR558HeVo4QOhxuot3QGIYyoagvdMaFajOnSQNjQ5gUAEXf46GpftQGzNOgntCgxh+E1SU12TX2CO/JFjXESJq0mlazaECu06GAJpVV1qPGq/5xryxuQYZNdPuVZ0WKunO/dXHIWNEiMJaI3p/vLDt2lHodjt9uQ43rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=VXF6Tg0S reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6t008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:43 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=sWk4ldwEm81hImY15fAdNE8225OgpgDTf9M1ok3ksHE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113804; v=1;
        b=VXF6Tg0S7zBBkDE/CiYfRzkWeTlFr+6ZEh0S38cyqbWHfQ9qiAMFVpkAJOLAEXEK
         lBdi5qNC3MVDlpeOnLWSjWB+Sj3UnThMpV4VLl/lYhvlrNvrqatOjYFv8re7wyyh
         +MskVKrweSLjtAJ0sBeEb3J8gy2SwTmMOLv0XiAERONyRyReQrrgJMGhp41Cv4ir
         n3itFG2r9Wml+iaqaEHfe43afKfRnZ1fFmgB4ApFBg3BlZ+hGElOqdDZW2OyeWk3
         P7f3YvvV3FBCo3vFmz2aOuPkPHx0i9PaavbQetA5oLiGDdtbwgq7DW8UjOOnWHtW
         ORd6gPdXrw9LTarykihkSg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:27 +0900
Subject: [PATCH 15/35] hw/net: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-15-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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
 hw/net/allwinner-sun8i-emac.c | 2 +-
 hw/net/cadence_gem.c          | 4 ++--
 hw/net/dp8393x.c              | 2 +-
 hw/net/msf2-emac.c            | 2 +-
 hw/net/mv88w8618_eth.c        | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/hw/net/allwinner-sun8i-emac.c b/hw/net/allwinner-sun8i-emac.c
index 27160c5ff2a4..4127fb55c817 100644
--- a/hw/net/allwinner-sun8i-emac.c
+++ b/hw/net/allwinner-sun8i-emac.c
@@ -820,7 +820,7 @@ static void allwinner_sun8i_emac_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, NULL, s->dma_mr, "emac-dma");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
 
     qemu_macaddr_default_if_unset(&s->conf.macaddr);
     s->nic = qemu_new_nic(&net_allwinner_sun8i_emac_info, &s->conf,
diff --git a/hw/net/cadence_gem.c b/hw/net/cadence_gem.c
index 3ba8ce017194..e1ff610b48da 100644
--- a/hw/net/cadence_gem.c
+++ b/hw/net/cadence_gem.c
@@ -1734,8 +1734,8 @@ static void gem_realize(DeviceState *dev, Error **errp)
     CadenceGEMState *s = CADENCE_GEM(dev);
     int i;
 
-    address_space_init(&s->dma_as, NULL,
-                       s->dma_mr ? s->dma_mr : get_system_memory(), "dma");
+    address_space_init(&s->dma_as, OBJECT(s),
+                       s->dma_mr ? s->dma_mr : get_system_memory(), "as");
 
     if (s->num_priority_queues == 0 ||
         s->num_priority_queues > MAX_PRIORITY_QUEUES) {
diff --git a/hw/net/dp8393x.c b/hw/net/dp8393x.c
index f65d8ef4dd45..9b9125954db8 100644
--- a/hw/net/dp8393x.c
+++ b/hw/net/dp8393x.c
@@ -908,7 +908,7 @@ static void dp8393x_realize(DeviceState *dev, Error **errp)
 {
     dp8393xState *s = DP8393X(dev);
 
-    address_space_init(&s->as, NULL, s->dma_mr, "dp8393x");
+    address_space_init(&s->as, OBJECT(s), s->dma_mr, "as");
     memory_region_init_io(&s->mmio, OBJECT(dev), &dp8393x_ops, s,
                           "dp8393x-regs", SONIC_REG_COUNT << s->it_shift);
 
diff --git a/hw/net/msf2-emac.c b/hw/net/msf2-emac.c
index 59c380db30dc..22a79d38403b 100644
--- a/hw/net/msf2-emac.c
+++ b/hw/net/msf2-emac.c
@@ -526,7 +526,7 @@ static void msf2_emac_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, NULL, s->dma_mr, "emac-ahb");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
 
     qemu_macaddr_default_if_unset(&s->conf.macaddr);
     s->nic = qemu_new_nic(&net_msf2_emac_info, &s->conf,
diff --git a/hw/net/mv88w8618_eth.c b/hw/net/mv88w8618_eth.c
index 1ea294bcced5..a02e7e60d562 100644
--- a/hw/net/mv88w8618_eth.c
+++ b/hw/net/mv88w8618_eth.c
@@ -348,7 +348,7 @@ static void mv88w8618_eth_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, NULL, s->dma_mr, "emac-dma");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
     s->nic = qemu_new_nic(&net_mv88w8618_info, &s->conf,
                           object_get_typename(OBJECT(dev)), dev->id,
                           &dev->mem_reentrancy_guard, s);

-- 
2.51.0


