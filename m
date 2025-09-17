Return-Path: <kvm+bounces-57860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C985B7F0DB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F6516233AB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E963433AE94;
	Wed, 17 Sep 2025 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Bp8/LTMc"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C60E33AE83
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114012; cv=none; b=SqfyOZEGlrhmgfBPyMYxCB+hIlq/Qp/DpyesnBHfVTTBbVOkDIEtUiWtzRmbixppvCwydVmh/4FB0QqXWJHplfztIWUCxQt+kKN6GQvm5U/HAPEfSK2hsNLDRKFamRso8p/DJ+RTjcVO/2hb6m8uTbnmxn+Q3fCh/TWVfvuqh6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114012; c=relaxed/simple;
	bh=4AnESbRmLrUUQcPn0cQXwK9PVxH4rXmy+WEnEhB+UCA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QToJ0JhtxN55t9THg+UtTiLe9mjffQNqcluBtsHa8mt/G4mYS0cLPSJDrNnDKP6CDI/pyR1oGrs3G6s53pJpYRzsEKi9maYqGNdqD2XFagL1C5n7P0JS+QQ/lT0TSzJVpZeeandra/5krWhCK6bCDImqpoeFBot3nF/xq0E5PyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Bp8/LTMc reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6q008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:41 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=CpRCyRAYIH2JSKiVPg762a+pxdQx53RiD8R6KgThpvY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113801; v=1;
        b=Bp8/LTMcn2vA4okUjWIJFNCQxsm68Infpf0VwT0PCBkfO9mjQdG/rLrraYEGaNG3
         q4SE4xes/3fWF6rpDs8MnNhRye1BCMKZIXrwcaEqD7GtznBworqbGIzwIaMVpVCQ
         kX9VZ3kMlHj9yJ/tkjt+vo7JM13zXnbTvoN2saEfsqm2iPUdv4GgpfaFRTMzx/a0
         5+yV//9iZ2gLOziJXMgN9nieKgpDOSquK+ylIYdAvWbFETn5cSzduVn00rptlKaH
         2QDmXO1SBgg4zUaL3HWSGFrkQMyTKCnPKgqKq+MGhF6+db6mHCRNaOWFx3agUmTr
         8FoNIo97MC0qBPOHMuSUpg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:24 +0900
Subject: [PATCH 12/35] hw/loongarch: QOM-ify AddressSpace
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-12-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
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
 hw/loongarch/virt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
index 0bace2f54b49..f65c2da5c6dd 100644
--- a/hw/loongarch/virt.c
+++ b/hw/loongarch/virt.c
@@ -699,7 +699,8 @@ static void virt_init(MachineState *machine)
     /* Create IOCSR space */
     memory_region_init_io(&lvms->system_iocsr, OBJECT(machine), NULL,
                           machine, "iocsr", UINT64_MAX);
-    address_space_init(&lvms->as_iocsr, NULL, &lvms->system_iocsr, "IOCSR");
+    address_space_init(&lvms->as_iocsr, OBJECT(machine), &lvms->system_iocsr,
+                       "iocsr-as");
     memory_region_init_io(&lvms->iocsr_mem, OBJECT(machine),
                           &virt_iocsr_misc_ops,
                           machine, "iocsr_misc", 0x428);

-- 
2.51.0


