Return-Path: <kvm+bounces-57893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E11CDB7F763
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A093A25EF
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555D23161BB;
	Wed, 17 Sep 2025 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="tFZy7oa+"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485630CB33
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116300; cv=none; b=bKzB8VWqA6XncOx7ZzY1zxYSE2WU2bFH/qhDmXXTI1V8GM5YceY1/pqP+/nO63Grvh3SZIAEbY7GH8S4bMVVoHGVmVw3WPL9lOh9eSvu+j/qFMJRhoXjOZaEqDi2V5l18+C2khG93B8dml1Ugcqh+3R3eWntnLrKKo49lPAWgGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116300; c=relaxed/simple;
	bh=KrKGau9duCBmX68h3kKovf1VxNPOOrhTj5obGGgSgaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tz2dYr0iUMaNPxALbGr0jBd/5Wnqx30Jon3Ii4n2X8nLAjvKVFgt7Z6i5dzkwgupB/YIniinXlBEB2KWW90+R+IzeBk8kWiaQQnQXIDJMtzEUeFamjNIfgiOGgzfMWtA4ktbg5K7m3Xvtc1rkiJm8Oak1UlTmVbvXbggJbCWH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=tFZy7oa+ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN74008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:50 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=IObcSxb1mEGR5pVanbHlUpUo799Y/B2tp5AzAzydRGA=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113811; v=1;
        b=tFZy7oa+nP+PtLJI2EIl6sGY+GMaHR/7ptxbf+ii5lc3dKpFVZ+4S2QOVk12hOme
         8FwO8O11BILpR094dmNm9daOQeTFpooTEiW4hoobEhu2S0jwte5AsLLc8nz8LFMa
         Cm96KElGwqbrlq1HZoI7iWC9SQW+OmSQsJHXuTpWLf4uThpEzfZbB3LBL+uLw+UR
         b4hErl+1sD+yjb/gYVMbmzvLUCHQa3/QTIqg3f6H0a+l2MlMkitW9hMmmMIL4wxj
         wSBGrblbGHzZXGUL8OEXNJn5GCjX9oO9BRS1KjL5f5zP8nq1OS1v/00XYWLPONkQ
         5k3CkYTpwPFwX04fT2TAlg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:36 +0900
Subject: [PATCH 24/35] hw/sd: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-24-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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
 hw/sd/allwinner-sdhost.c | 2 +-
 hw/sd/sdhci.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/sd/allwinner-sdhost.c b/hw/sd/allwinner-sdhost.c
index 158d434e7fde..c001dfd60203 100644
--- a/hw/sd/allwinner-sdhost.c
+++ b/hw/sd/allwinner-sdhost.c
@@ -832,7 +832,7 @@ static void allwinner_sdhost_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    address_space_init(&s->dma_as, NULL, s->dma_mr, "sdhost-dma");
+    address_space_init(&s->dma_as, OBJECT(s), s->dma_mr, "as");
 }
 
 static void allwinner_sdhost_reset(DeviceState *dev)
diff --git a/hw/sd/sdhci.c b/hw/sd/sdhci.c
index c6a203744463..1a6b6e1198f2 100644
--- a/hw/sd/sdhci.c
+++ b/hw/sd/sdhci.c
@@ -1594,7 +1594,7 @@ static void sdhci_sysbus_realize(DeviceState *dev, Error **errp)
 
     if (s->dma_mr) {
         s->dma_as = &s->sysbus_dma_as;
-        address_space_init(s->dma_as, NULL, s->dma_mr, "sdhci-dma");
+        address_space_init(s->dma_as, OBJECT(s), s->dma_mr, "as");
     } else {
         /* use system_memory() if property "dma" not set */
         s->dma_as = &address_space_memory;
@@ -1612,7 +1612,7 @@ static void sdhci_sysbus_unrealize(DeviceState *dev)
     sdhci_common_unrealize(s);
 
      if (s->dma_mr) {
-        address_space_destroy(s->dma_as);
+        object_unparent(OBJECT(s->dma_as));
     }
 }
 

-- 
2.51.0


