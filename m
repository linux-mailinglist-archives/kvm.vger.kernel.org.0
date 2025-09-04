Return-Path: <kvm+bounces-56800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 893D4B43569
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A25B170C03
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7A92C11C5;
	Thu,  4 Sep 2025 08:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F7/w6wpU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6232C028A
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973920; cv=none; b=lEPArG6A+fzFisnXPM4faR9xeJoVXWC1xerI/On7iJ7NVP0739y1Q2otFt9zP2mmNOnhFxNMFoa9k97zi2964G4w70x9OhGR4/gZkXMjKggO2C/0jeqXIs7iF609i0Q8LN5RQ+D3H7ThObjZiNV+H2t/UGSIi87y/mwR6sLKvbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973920; c=relaxed/simple;
	bh=+oFMDmPWrsOGEYfuovDcs5CPDY9/41AQ4NnxJoOpjlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3E8vHCj7sf70eFtLTvAVGTNQfFnJ5pcFOCOQ9yiH3FtRsrRK+yhFkGFVpQLpMDjW6Vd9LzLcHCAcnsKk3EEAn6njgx/DJYI8oVlVt/9YdoTaU51EQGMS+fk0/whe71nlh570L9hPEZ+plqekjjxsSf393BlFas0MK/NjjHNEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F7/w6wpU; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6188b6f501cso923744a12.2
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973916; x=1757578716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1Jmcmvj/wxtRZkBbPu5k8WLatNgN3qwXd3zyWr/Gsg=;
        b=F7/w6wpUSGyS6Ub+YOL6pppGO7Sy9QdzXljU0G7gOcgRGxUbzr5i45LAxAiHf9tdTm
         snrJCkx6VBcpLpBYKPAUWdATGZqkBIp2QckOa0IaZRwmB39RR460pLIpP/1/GuxowTVg
         VgJq0a7PatNobNTbzLMo+xdry3+yhdb/9EiVvL/9Urcoos/fzn8536VPEPPzn727EK3d
         eZe4dFDtOX96w87TQzkDq5cUGTuNHug6qcD0XlmjVxLGEJR5t+Oj6BOaoJSSqyl0MqwF
         9wS1IY1qJggGF/QiwLmqDLh0H+TO2nY1WenDACgT1tKm9uZn2OUAph/pKsud+0Xbch9p
         em4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973916; x=1757578716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1Jmcmvj/wxtRZkBbPu5k8WLatNgN3qwXd3zyWr/Gsg=;
        b=I3bMbjO8K7ZCPlbpTkw4lrlQkUZDI5V8uaGNFrSZYIWlsnSpAIJ5bXWiiQAXo6gewn
         SG73j5VSt4oL4RXPQXE1OuUJkhnPrU6Wk50h3/iIj0rmbMGzb295bxM6WoI+49KhET2K
         SPZMVq7vQaaLLGL+6nA13reSFukrBppaPcQwdBS8vr+fmQMdrYACfls+rBYZ2Kgn98Jw
         VzIHTiSIWEGOgwXi/GSZ6Y5yQ2DykqaZKgVP76aUHXPV4UPJMQtcF3KMbvwaNFSZ8Wzi
         8t/pC8naD1e2yDYaW1zYTJeqvKwVEWCV6d8GDMULpCcPU6HPp8Iyzgc8wQ5722e+IrCC
         06QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDdQxLErF9xin5wivpD2jvPxbRS4rUS2aOIa0cqPCM0hteuj4wetNJr3AMT5YhKZMrmoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKoNN69bafRIuXA9lb6CmxSv+Dlxv5Bw0Sm9p7rOKv9DlmEC16
	Vxdf1AwZ7yYEBWZUXKNmiXddS5DLF5jyFrT6Dd2SNi78n+Q1iP2ROV0xDzON55/bqSE=
X-Gm-Gg: ASbGncu/ptFe/OJ1KyFoZzHIuZQ/BmI40y3HA89DfJao5QykZmpU9Tk/tksKV9o+afB
	loOf+a6KNPOvfJv3Tv2HLVDZOeyEFTv1oZknMf8V93oVtjI9WI+D03ziL/SF28yeeONXtrJ6EQl
	G/xUwb1KGSQrWEo5JXqyaBJRo8xf2sDM5ENmtzzf+skplpRXiPS9p8OqYZBZ3BrQZMy9J/mbZ8M
	993EhHnYzE27Hy2bPZDuCDcqDlIoNSwhTQhUp0ZdtzOC+TUVempHp7U9iE0z7un+07XYWKQvRkC
	Q+gQerkm9JNy+eshc8DOa6AooFG4Z76unvT/GuKJMI81tFOnOqBMjOUW5/NSE/feOOl+wV5IOHF
	iobtatDc0uye8Ge1kfqGDPyK5a91uG7W9USeznT++dkzA
X-Google-Smtp-Source: AGHT+IGd7u3Qk721bQxPxAfrzD3eIhPfOWYwPcIsP6SkUyYfzaxGv5T68HkRcWFbq+cH9ffQb7YK1w==
X-Received: by 2002:a05:6402:847:b0:61d:144:81be with SMTP id 4fb4d7f45d1cf-61d2699473dmr17896861a12.16.1756973916345;
        Thu, 04 Sep 2025 01:18:36 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc4bbc51sm13480108a12.27.2025.09.04.01.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:18:34 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5F91E60135;
	Thu, 04 Sep 2025 09:11:32 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 034/281] tests/functional: Move x86_64 tests into target-specific folder
Date: Thu,  4 Sep 2025 09:07:08 +0100
Message-ID: <20250904081128.1942269-35-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Huth <thuth@redhat.com>

The tests/functional folder has become quite crowded, thus move the
x86_64 tests into a target-specific subfolder.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20250819112403.432587-23-thuth@redhat.com>
---
 MAINTAINERS                                   | 32 ++++++++--------
 tests/functional/meson.build                  | 37 +------------------
 tests/functional/x86_64/meson.build           | 37 +++++++++++++++++++
 .../functional/{ => x86_64}/test_acpi_bits.py |  0
 .../test_cpu_model_versions.py}               |  0
 .../{ => x86_64}/test_cpu_queries.py          |  0
 .../test_hotplug_blk.py}                      |  0
 .../test_hotplug_cpu.py}                      |  0
 .../{ => x86_64}/test_intel_iommu.py          |  0
 .../test_kvm_xen.py}                          |  0
 .../{ => x86_64}/test_linux_initrd.py         |  0
 .../{ => x86_64}/test_mem_addr_space.py       |  0
 tests/functional/{ => x86_64}/test_memlock.py |  0
 .../test_migration.py}                        |  0
 .../test_multiprocess.py}                     |  0
 .../{ => x86_64}/test_netdev_ethtool.py       |  0
 .../{ => x86_64}/test_pc_cpu_hotplug_props.py |  0
 .../test_replay.py}                           |  0
 .../test_reverse_debug.py}                    |  0
 .../test_tuxrun.py}                           |  0
 .../{ => x86_64}/test_virtio_balloon.py       |  0
 .../{ => x86_64}/test_virtio_gpu.py           |  0
 .../{ => x86_64}/test_virtio_version.py       |  0
 23 files changed, 55 insertions(+), 51 deletions(-)
 create mode 100644 tests/functional/x86_64/meson.build
 rename tests/functional/{ => x86_64}/test_acpi_bits.py (100%)
 rename tests/functional/{test_x86_cpu_model_versions.py => x86_64/test_cpu_model_versions.py} (100%)
 rename tests/functional/{ => x86_64}/test_cpu_queries.py (100%)
 rename tests/functional/{test_x86_64_hotplug_blk.py => x86_64/test_hotplug_blk.py} (100%)
 rename tests/functional/{test_x86_64_hotplug_cpu.py => x86_64/test_hotplug_cpu.py} (100%)
 rename tests/functional/{ => x86_64}/test_intel_iommu.py (100%)
 rename tests/functional/{test_x86_64_kvm_xen.py => x86_64/test_kvm_xen.py} (100%)
 rename tests/functional/{ => x86_64}/test_linux_initrd.py (100%)
 rename tests/functional/{ => x86_64}/test_mem_addr_space.py (100%)
 rename tests/functional/{ => x86_64}/test_memlock.py (100%)
 rename tests/functional/{test_x86_64_migration.py => x86_64/test_migration.py} (100%)
 rename tests/functional/{test_x86_64_multiprocess.py => x86_64/test_multiprocess.py} (100%)
 rename tests/functional/{ => x86_64}/test_netdev_ethtool.py (100%)
 rename tests/functional/{ => x86_64}/test_pc_cpu_hotplug_props.py (100%)
 rename tests/functional/{test_x86_64_replay.py => x86_64/test_replay.py} (100%)
 rename tests/functional/{test_x86_64_reverse_debug.py => x86_64/test_reverse_debug.py} (100%)
 rename tests/functional/{test_x86_64_tuxrun.py => x86_64/test_tuxrun.py} (100%)
 rename tests/functional/{ => x86_64}/test_virtio_balloon.py (100%)
 rename tests/functional/{ => x86_64}/test_virtio_gpu.py (100%)
 rename tests/functional/{ => x86_64}/test_virtio_version.py (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index b46445ff5c0..7b1a94f696c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -147,6 +147,7 @@ F: target/i386/Kconfig
 F: target/i386/meson.build
 F: tools/i386/
 F: tests/functional/i386/
+F: tests/functional/x86_64/
 
 Guest CPU cores (TCG)
 ---------------------
@@ -483,7 +484,7 @@ F: docs/system/i386/sgx.rst
 F: target/i386/kvm/
 F: target/i386/sev*
 F: scripts/kvm/vmxcap
-F: tests/functional/test_x86_64_hotplug_cpu.py
+F: tests/functional/x86_64/test_hotplug_cpu.py
 
 Xen emulation on X86 KVM CPUs
 M: David Woodhouse <dwmw2@infradead.org>
@@ -492,7 +493,7 @@ S: Supported
 F: include/system/kvm_xen.h
 F: target/i386/kvm/xen*
 F: hw/i386/kvm/xen*
-F: tests/functional/test_x86_64_kvm_xen.py
+F: tests/functional/x86_64/test_kvm_xen.py
 
 Guest CPU Cores (other accelerators)
 ------------------------------------
@@ -1894,11 +1895,11 @@ F: include/hw/isa/apm.h
 F: tests/unit/test-x86-topo.c
 F: tests/qtest/test-x86-cpuid-compat.c
 F: tests/functional/i386/test_tuxrun.py
-F: tests/functional/test_linux_initrd.py
-F: tests/functional/test_mem_addr_space.py
-F: tests/functional/test_pc_cpu_hotplug_props.py
-F: tests/functional/test_x86_64_tuxrun.py
-F: tests/functional/test_x86_cpu_model_versions.py
+F: tests/functional/x86_64/test_linux_initrd.py
+F: tests/functional/x86_64/test_mem_addr_space.py
+F: tests/functional/x86_64/test_pc_cpu_hotplug_props.py
+F: tests/functional/x86_64/test_tuxrun.py
+F: tests/functional/x86_64/test_cpu_model_versions.py
 
 PC Chipset
 M: Michael S. Tsirkin <mst@redhat.com>
@@ -1974,7 +1975,7 @@ F: include/hw/boards.h
 F: include/hw/core/cpu.h
 F: include/hw/cpu/cluster.h
 F: include/system/numa.h
-F: tests/functional/test_cpu_queries.py
+F: tests/functional/x86_64/test_cpu_queries.py
 F: tests/functional/test_empty_cpu_model.py
 F: tests/unit/test-smp-parse.c
 T: git https://gitlab.com/ehabkost/qemu.git machine-next
@@ -2159,7 +2160,7 @@ M: Ani Sinha <anisinha@redhat.com>
 M: Michael S. Tsirkin <mst@redhat.com>
 S: Supported
 F: tests/functional/acpi-bits/*
-F: tests/functional/test_acpi_bits.py
+F: tests/functional/x86_64/test_acpi_bits.py
 F: docs/devel/testing/acpi-bits.rst
 
 ACPI/HEST/GHES
@@ -2345,7 +2346,7 @@ F: net/vhost-user.c
 F: include/hw/virtio/
 F: docs/devel/virtio*
 F: docs/devel/migration/virtio.rst
-F: tests/functional/test_virtio_version.py
+F: tests/functional/x86_64/test_virtio_version.py
 
 virtio-balloon
 M: Michael S. Tsirkin <mst@redhat.com>
@@ -2357,7 +2358,7 @@ F: include/hw/virtio/virtio-balloon.h
 F: system/balloon.c
 F: include/system/balloon.h
 F: tests/qtest/virtio-balloon-test.c
-F: tests/functional/test_virtio_balloon.py
+F: tests/functional/x86_64/test_virtio_balloon.py
 
 virtio-9p
 M: Christian Schoenebeck <qemu_oss@crudebyte.com>
@@ -2380,7 +2381,7 @@ F: hw/block/virtio-blk.c
 F: hw/block/dataplane/*
 F: include/hw/virtio/virtio-blk-common.h
 F: tests/qtest/virtio-blk-test.c
-F: tests/functional/test_x86_64_hotplug_blk.py
+F: tests/functional/x86_64/test_hotplug_blk.py
 T: git https://github.com/stefanha/qemu.git block
 
 virtio-ccw
@@ -2604,7 +2605,7 @@ R: Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>
 S: Odd Fixes
 F: docs/system/devices/igb.rst
 F: hw/net/igb*
-F: tests/functional/test_netdev_ethtool.py
+F: tests/functional/x86_64/test_netdev_ethtool.py
 F: tests/qtest/igb-test.c
 F: tests/qtest/libqos/igb.c
 
@@ -2713,6 +2714,7 @@ F: hw/display/virtio-vga.*
 F: include/hw/virtio/virtio-gpu.h
 F: docs/system/devices/virtio-gpu.rst
 F: tests/functional/aarch64/test_virt_gpu.py
+F: tests/functional/x86_64/test_virtio_gpu.py
 
 vhost-user-blk
 M: Raphael Norwitz <raphael@enfabrica.net>
@@ -3856,7 +3858,7 @@ S: Supported
 F: hw/i386/intel_iommu.c
 F: hw/i386/intel_iommu_internal.h
 F: include/hw/i386/intel_iommu.h
-F: tests/functional/test_intel_iommu.py
+F: tests/functional/x86_64/test_intel_iommu.py
 F: tests/qtest/intel-iommu-test.c
 
 AMD-Vi Emulation
@@ -4330,7 +4332,7 @@ F: scripts/ci/
 F: tests/docker/
 F: tests/vm/
 F: tests/lcitool/
-F: tests/functional/test_*_tuxrun.py
+F: tests/functional/*/test_tuxrun.py
 F: scripts/archive-source.sh
 F: docs/devel/testing/ci*
 F: docs/devel/testing/main.rst
diff --git a/tests/functional/meson.build b/tests/functional/meson.build
index 00d18dba3ce..34e30239a6b 100644
--- a/tests/functional/meson.build
+++ b/tests/functional/meson.build
@@ -34,15 +34,7 @@ subdir('sh4')
 subdir('sh4eb')
 subdir('sparc')
 subdir('sparc64')
-
-test_x86_64_timeouts = {
-  'acpi_bits' : 420,
-  'intel_iommu': 300,
-  'netdev_ethtool' : 180,
-  'virtio_balloon': 120,
-  'x86_64_kvm_xen' : 180,
-  'x86_64_replay' : 480,
-}
+subdir('x86_64')
 
 tests_generic_system = [
   'empty_cpu_model',
@@ -56,33 +48,6 @@ tests_generic_linuxuser = [
 tests_generic_bsduser = [
 ]
 
-tests_x86_64_system_quick = [
-  'cpu_queries',
-  'mem_addr_space',
-  'x86_64_migration',
-  'pc_cpu_hotplug_props',
-  'virtio_version',
-  'x86_cpu_model_versions',
-  'vnc',
-  'memlock',
-]
-
-tests_x86_64_system_thorough = [
-  'acpi_bits',
-  'intel_iommu',
-  'linux_initrd',
-  'x86_64_multiprocess',
-  'netdev_ethtool',
-  'virtio_balloon',
-  'virtio_gpu',
-  'x86_64_hotplug_blk',
-  'x86_64_hotplug_cpu',
-  'x86_64_kvm_xen',
-  'x86_64_replay',
-  'x86_64_reverse_debug',
-  'x86_64_tuxrun',
-]
-
 tests_xtensa_system_thorough = [
   'xtensa_lx60',
   'xtensa_replay',
diff --git a/tests/functional/x86_64/meson.build b/tests/functional/x86_64/meson.build
new file mode 100644
index 00000000000..696a9ecab42
--- /dev/null
+++ b/tests/functional/x86_64/meson.build
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+test_x86_64_timeouts = {
+  'acpi_bits' : 420,
+  'intel_iommu': 300,
+  'kvm_xen' : 180,
+  'netdev_ethtool' : 180,
+  'replay' : 480,
+  'virtio_balloon': 120,
+}
+
+tests_x86_64_system_quick = [
+  'cpu_model_versions',
+  'cpu_queries',
+  'mem_addr_space',
+  'migration',
+  'pc_cpu_hotplug_props',
+  'virtio_version',
+  'vnc',
+  'memlock',
+]
+
+tests_x86_64_system_thorough = [
+  'acpi_bits',
+  'hotplug_blk',
+  'hotplug_cpu',
+  'intel_iommu',
+  'kvm_xen',
+  'linux_initrd',
+  'multiprocess',
+  'netdev_ethtool',
+  'replay',
+  'reverse_debug',
+  'tuxrun',
+  'virtio_balloon',
+  'virtio_gpu',
+]
diff --git a/tests/functional/test_acpi_bits.py b/tests/functional/x86_64/test_acpi_bits.py
similarity index 100%
rename from tests/functional/test_acpi_bits.py
rename to tests/functional/x86_64/test_acpi_bits.py
diff --git a/tests/functional/test_x86_cpu_model_versions.py b/tests/functional/x86_64/test_cpu_model_versions.py
similarity index 100%
rename from tests/functional/test_x86_cpu_model_versions.py
rename to tests/functional/x86_64/test_cpu_model_versions.py
diff --git a/tests/functional/test_cpu_queries.py b/tests/functional/x86_64/test_cpu_queries.py
similarity index 100%
rename from tests/functional/test_cpu_queries.py
rename to tests/functional/x86_64/test_cpu_queries.py
diff --git a/tests/functional/test_x86_64_hotplug_blk.py b/tests/functional/x86_64/test_hotplug_blk.py
similarity index 100%
rename from tests/functional/test_x86_64_hotplug_blk.py
rename to tests/functional/x86_64/test_hotplug_blk.py
diff --git a/tests/functional/test_x86_64_hotplug_cpu.py b/tests/functional/x86_64/test_hotplug_cpu.py
similarity index 100%
rename from tests/functional/test_x86_64_hotplug_cpu.py
rename to tests/functional/x86_64/test_hotplug_cpu.py
diff --git a/tests/functional/test_intel_iommu.py b/tests/functional/x86_64/test_intel_iommu.py
similarity index 100%
rename from tests/functional/test_intel_iommu.py
rename to tests/functional/x86_64/test_intel_iommu.py
diff --git a/tests/functional/test_x86_64_kvm_xen.py b/tests/functional/x86_64/test_kvm_xen.py
similarity index 100%
rename from tests/functional/test_x86_64_kvm_xen.py
rename to tests/functional/x86_64/test_kvm_xen.py
diff --git a/tests/functional/test_linux_initrd.py b/tests/functional/x86_64/test_linux_initrd.py
similarity index 100%
rename from tests/functional/test_linux_initrd.py
rename to tests/functional/x86_64/test_linux_initrd.py
diff --git a/tests/functional/test_mem_addr_space.py b/tests/functional/x86_64/test_mem_addr_space.py
similarity index 100%
rename from tests/functional/test_mem_addr_space.py
rename to tests/functional/x86_64/test_mem_addr_space.py
diff --git a/tests/functional/test_memlock.py b/tests/functional/x86_64/test_memlock.py
similarity index 100%
rename from tests/functional/test_memlock.py
rename to tests/functional/x86_64/test_memlock.py
diff --git a/tests/functional/test_x86_64_migration.py b/tests/functional/x86_64/test_migration.py
similarity index 100%
rename from tests/functional/test_x86_64_migration.py
rename to tests/functional/x86_64/test_migration.py
diff --git a/tests/functional/test_x86_64_multiprocess.py b/tests/functional/x86_64/test_multiprocess.py
similarity index 100%
rename from tests/functional/test_x86_64_multiprocess.py
rename to tests/functional/x86_64/test_multiprocess.py
diff --git a/tests/functional/test_netdev_ethtool.py b/tests/functional/x86_64/test_netdev_ethtool.py
similarity index 100%
rename from tests/functional/test_netdev_ethtool.py
rename to tests/functional/x86_64/test_netdev_ethtool.py
diff --git a/tests/functional/test_pc_cpu_hotplug_props.py b/tests/functional/x86_64/test_pc_cpu_hotplug_props.py
similarity index 100%
rename from tests/functional/test_pc_cpu_hotplug_props.py
rename to tests/functional/x86_64/test_pc_cpu_hotplug_props.py
diff --git a/tests/functional/test_x86_64_replay.py b/tests/functional/x86_64/test_replay.py
similarity index 100%
rename from tests/functional/test_x86_64_replay.py
rename to tests/functional/x86_64/test_replay.py
diff --git a/tests/functional/test_x86_64_reverse_debug.py b/tests/functional/x86_64/test_reverse_debug.py
similarity index 100%
rename from tests/functional/test_x86_64_reverse_debug.py
rename to tests/functional/x86_64/test_reverse_debug.py
diff --git a/tests/functional/test_x86_64_tuxrun.py b/tests/functional/x86_64/test_tuxrun.py
similarity index 100%
rename from tests/functional/test_x86_64_tuxrun.py
rename to tests/functional/x86_64/test_tuxrun.py
diff --git a/tests/functional/test_virtio_balloon.py b/tests/functional/x86_64/test_virtio_balloon.py
similarity index 100%
rename from tests/functional/test_virtio_balloon.py
rename to tests/functional/x86_64/test_virtio_balloon.py
diff --git a/tests/functional/test_virtio_gpu.py b/tests/functional/x86_64/test_virtio_gpu.py
similarity index 100%
rename from tests/functional/test_virtio_gpu.py
rename to tests/functional/x86_64/test_virtio_gpu.py
diff --git a/tests/functional/test_virtio_version.py b/tests/functional/x86_64/test_virtio_version.py
similarity index 100%
rename from tests/functional/test_virtio_version.py
rename to tests/functional/x86_64/test_virtio_version.py
-- 
2.47.2


