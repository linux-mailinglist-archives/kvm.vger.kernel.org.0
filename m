Return-Path: <kvm+bounces-57859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF29B7F24D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:19:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E8C4A7BF3
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A84533AEAE;
	Wed, 17 Sep 2025 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="qNpm7Ef0"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB133AE94
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114011; cv=none; b=Ns2GBSx7lj3XkaUZeJt0nLPEaGXpFPDe6p7ykK+yYh3g3cksVipXdLs1P8eljHbNWwSnQsyol7MwayGVPREZASjjlaxXWJES3nMbHqQ/H6/gIRLsWNoK6xXwDCekEVDQ52v5wga4++QFyzbWzLkh1Eld35JRZVFhwlRPbVUW9dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114011; c=relaxed/simple;
	bh=hw8/Q0dqRUSD+WlgpPqSJDpboHvCIjU7wQ/08vLmiJ0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Z5VqzMEFcw8x+7acRMGTkuhAsouLROi8lfnGYdtXOok39D/UnQ8M2dD6KCWku6yak5t0IG8VredJMQ6ZIifLT6dZ9el8qACOHD6tkl3oOWFzMvZo/xw07X/SKQR5PkYkxIi6/t+Ul8yTIR0BNK+gMCDQt5L+DJ/YJknv0HsQQMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=qNpm7Ef0 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN6e008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:31 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=qUgDNts/pLAXfiQGYCf+Xi0EaL/7Ac8bseo+NFP/PSc=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Subject:Date:Message-Id:To;
        s=rs20250326; t=1758113792; v=1;
        b=qNpm7Ef0U7klFkwYiNP1zPEvVVcxKtxzCfA9mWNff7hVl7gkKQk6u15xwrz6zo39
         eLzbz+GcW4HpImOtDvQT/Nnz7BgUBdk2tJkJLHL5TmHPYyp48+ivXFX/5LAYxP7B
         5Vq4/k4lQrZys11cFTlX3cNJUJ1s7i7zwPWv48QD5LN456omn9h2MAua/U1KTKv7
         hIZ5oaMakj2MHUKOKhGlWPxOsqYFpk4DfGPhpZf7+YdF02ZVeD82nu48L3R2oRmN
         FiXHpNSI8zYr1M4zE0ABNoVuSveO9axxTUh8G0vu/Tyk5ycCNvhmQX8BSMhiShvY
         1MyA7TYRrp7XCIPztgcDfg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH 00/35] memory: QOM-ify AddressSpace
Date: Wed, 17 Sep 2025 21:56:12 +0900
Message-Id: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOyvymgC/0XMy27DIBCF4VexWBfE1QSrivIeVRZchgQ1mAZsq
 1KUdy+pK3X5j858D9SgJmhoGh6owpZaKnMP9jYgf7XzBXAKvRGnXFHDFL6XjEFH7y3XQQaH+vK
 rQkzfv8rHee8K97Vjy378t6Zhl+iI1wZYaPDeUGEN0GnjLyxDa/Zv++7LBpUwrZg0Qo6aXNJCn
 L3ZpcwnSJ/EZSDX9fh6dLaDvuSclmkARlkQQhuuBKVGREsdtSOoKAXIcPARpDowQOfn8wd/8d0
 CBQEAAA==
X-Change-ID: 20250915-qom-e7fcca27d4db
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

Based-on: <20250917-subregion-v1-0-bef37d9b4f73@rsg.ci.i.u-tokyo.ac.jp>
("[PATCH 00/14] Fix memory region use-after-finalization")

Make AddressSpaces QOM objects to ensure that they are destroyed when
their owners are finalized and also to get a unique path for debugging
output.

Suggested by BALATON Zoltan:
https://lore.kernel.org/qemu-devel/cd21698f-db77-eb75-6966-d559fdcab835@eik.bme.hu/

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
Akihiko Odaki (35):
      memory: QOM-ify AddressSpace
      hw/core/loader: Use address_space_get_path()
      vfio: Use address_space_get_path()
      hw/alpha: QOM-ify AddressSpace
      hw/arm: QOM-ify AddressSpace
      hw/display: QOM-ify AddressSpace
      hw/dma: QOM-ify AddressSpace
      hw/fsi: QOM-ify AddressSpace
      hw/i2c: QOM-ify AddressSpace
      hw/i386: QOM-ify AddressSpace
      hw/intc: QOM-ify AddressSpace
      hw/loongarch: QOM-ify AddressSpace
      hw/mem: QOM-ify AddressSpace
      hw/misc: QOM-ify AddressSpace
      hw/net: QOM-ify AddressSpace
      hw/nubus: QOM-ify AddressSpace
      hw/pci: QOM-ify AddressSpace
      hw/pci-host: QOM-ify AddressSpace
      hw/ppc: QOM-ify AddressSpace
      hw/remote: QOM-ify AddressSpace
      hw/riscv: QOM-ify AddressSpace
      hw/s390x: QOM-ify AddressSpace
      hw/scsi: QOM-ify AddressSpace
      hw/sd: QOM-ify AddressSpace
      hw/sparc: QOM-ify AddressSpace
      hw/sparc64: QOM-ify AddressSpace
      hw/ssi: QOM-ify AddressSpace
      hw/usb: QOM-ify AddressSpace
      hw/usb: QOM-ify AddressSpace
      hw/virtio: QOM-ify AddressSpace
      system/physmem: QOM-ify AddressSpace
      target/i386: QOM-ify AddressSpace
      target/mips: QOM-ify AddressSpace
      target/xtensa: QOM-ify AddressSpace
      memory: Drop non-QOM AddressSpace support

 include/exec/cpu-common.h     |  4 +--
 include/system/memory.h       | 20 +++++++++------
 hw/alpha/typhoon.c            |  4 +--
 hw/arm/armv7m.c               |  2 +-
 hw/arm/aspeed_ast27x0.c       |  2 +-
 hw/arm/smmu-common.c          |  5 ++--
 hw/core/loader.c              |  8 +++---
 hw/display/artist.c           |  2 +-
 hw/display/bcm2835_fb.c       |  2 +-
 hw/dma/bcm2835_dma.c          |  2 +-
 hw/dma/pl080.c                |  2 +-
 hw/dma/pl330.c                |  3 +--
 hw/dma/rc4030.c               |  4 +--
 hw/dma/xilinx_axidma.c        |  4 +--
 hw/dma/xlnx-zdma.c            |  2 +-
 hw/dma/xlnx_csu_dma.c         |  2 +-
 hw/fsi/aspeed_apb2opb.c       |  2 +-
 hw/i2c/aspeed_i2c.c           |  3 +--
 hw/i386/amd_iommu.c           |  5 ++--
 hw/i386/intel_iommu.c         |  5 +++-
 hw/intc/arm_gicv3_common.c    |  3 +--
 hw/intc/pnv_xive.c            |  4 +--
 hw/loongarch/virt.c           |  3 ++-
 hw/mem/cxl_type3.c            | 44 +++++++++------------------------
 hw/mem/memory-device.c        |  4 +--
 hw/misc/aspeed_hace.c         |  2 +-
 hw/misc/auxbus.c              |  2 +-
 hw/misc/bcm2835_mbox.c        |  2 +-
 hw/misc/bcm2835_property.c    |  2 +-
 hw/misc/max78000_gcr.c        |  2 +-
 hw/misc/tz-mpc.c              |  6 ++---
 hw/misc/tz-msc.c              |  2 +-
 hw/misc/tz-ppc.c              |  5 +++-
 hw/net/allwinner-sun8i-emac.c |  2 +-
 hw/net/cadence_gem.c          |  4 +--
 hw/net/dp8393x.c              |  2 +-
 hw/net/msf2-emac.c            |  2 +-
 hw/net/mv88w8618_eth.c        |  2 +-
 hw/nubus/nubus-bus.c          |  4 +--
 hw/pci-host/astro.c           |  3 +--
 hw/pci-host/designware.c      |  5 ++--
 hw/pci-host/dino.c            |  4 +--
 hw/pci-host/gt64120.c         |  2 +-
 hw/pci-host/pnv_phb3.c        |  4 +--
 hw/pci-host/pnv_phb4.c        |  4 +--
 hw/pci-host/ppc440_pcix.c     |  2 +-
 hw/pci-host/ppce500.c         |  2 +-
 hw/pci-host/raven.c           |  2 +-
 hw/pci/pci.c                  |  6 ++---
 hw/pci/pci_bridge.c           | 10 ++++----
 hw/ppc/pnv_lpc.c              |  2 +-
 hw/ppc/pnv_xscom.c            |  2 +-
 hw/ppc/spapr_pci.c            |  5 ++--
 hw/ppc/spapr_vio.c            |  2 +-
 hw/remote/iommu.c             |  4 +--
 hw/riscv/riscv-iommu.c        |  9 ++++---
 hw/s390x/s390-pci-bus.c       |  9 ++-----
 hw/scsi/lsi53c895a.c          |  5 ++--
 hw/sd/allwinner-sdhost.c      |  2 +-
 hw/sd/sdhci.c                 |  4 +--
 hw/sparc/sun4m_iommu.c        |  2 +-
 hw/sparc64/sun4u_iommu.c      |  2 +-
 hw/ssi/aspeed_smc.c           |  6 ++---
 hw/usb/hcd-dwc2.c             |  2 +-
 hw/usb/hcd-xhci-sysbus.c      |  2 +-
 hw/vfio/listener.c            |  8 ++++--
 hw/virtio/vhost-vdpa.c        |  4 ++-
 hw/virtio/virtio-iommu.c      |  3 ++-
 hw/virtio/virtio-pci.c        | 12 ++++-----
 system/memory.c               | 57 ++++++++++++++++++++++++++++---------------
 system/physmem.c              | 24 ++++++++++--------
 target/i386/kvm/kvm.c         |  3 ++-
 target/mips/cpu.c             |  4 +--
 target/xtensa/cpu.c           |  2 +-
 74 files changed, 204 insertions(+), 195 deletions(-)
---
base-commit: e101d33792530093fa0b0a6e5f43e4d8cfe4581e
change-id: 20250915-qom-e7fcca27d4db
prerequisite-change-id: 20250906-use-37ecc903a9e0:v2
prerequisite-patch-id: d464fda86a3c79ff8e6d7a2e623d979b2a47019b
prerequisite-patch-id: 17b153237f69c898b9c5b93aad0d5116d0bfe49f
prerequisite-patch-id: a323f67e01c672ab2958a237ea54b77f1443e2d1
prerequisite-patch-id: 822094864ad7a6a702fee098e4835621bd8092fe
prerequisite-patch-id: 5757efd81557b060257b5db6dec6fd189076ee77
prerequisite-patch-id: bd912830a326f13186bf38e916655ec980e11af8
prerequisite-patch-id: fe6b92112288829e60f10c305742a544f45e8984
prerequisite-patch-id: ac4ff0c11dcc1fc5d08b4fc480c14721fde574ad
prerequisite-patch-id: ff398fa97b5f2feee85372fdf108d82d8d5526b0
prerequisite-patch-id: 7ac446ae76e05dd267a63889ff775ac609712c31
prerequisite-patch-id: b49a74cd5f31348c3dc13dcfd1dad629e6b30387
prerequisite-patch-id: 8f61fe1b81cf3ec906ebbf61776573edd96c1e8c
prerequisite-patch-id: 01fb8ccbe7326021a94a8d7531189568d2e311a7
prerequisite-patch-id: 974b0fc6d7c8d6d56b8f44597260647e1a53cf38
prerequisite-patch-id: 55c4711a2a4e6b02b8b512e0283f8feaf7d3bfa3
prerequisite-message-id: <cover.1751493467.git.balaton@eik.bme.hu>
prerequisite-patch-id: f9c7e666c59cdc8a561d6d122e7937648da490e1
prerequisite-patch-id: 9b52629b6d9d32e71e5c416aead9aadb0e3c7ae2
prerequisite-patch-id: 16467219e7dd93204cec6ceb6d69577e3e86c03a
prerequisite-patch-id: 37a3ee3288d2cda8303c9c9e3d5ec9d813b05ef6
prerequisite-patch-id: b707ebf05289b55e8458b6b3515aa0fc559c7c88
prerequisite-patch-id: 721e733f06ce38375881520725177c9da9c22633
prerequisite-patch-id: 3cd399b599a9ff57066d820b1e6504b335be4f79
prerequisite-patch-id: 8a607cc6e52a6a6958a73cd1a1b824b52a4f4582
prerequisite-patch-id: af3976b1c4c3ef4859f2371a318214af5418e97d
prerequisite-patch-id: 76c6e115f8771f31c99f454fd3188ca49e283025
prerequisite-patch-id: 488b5dd5a90070331daae2e22f7c1f6419a7e428
prerequisite-patch-id: 53b85575018fecb94e208bdb5d3047b8d66fb4dd
prerequisite-patch-id: 0426e04bb68376f2d4fad6ade4ac641202172396
prerequisite-patch-id: 6ba40a4bf6e2b0ba3d4ecf9a1c4fed7f46e5730c

Best regards,
--  
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>


