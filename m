Return-Path: <kvm+bounces-61126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FDCC0BB2B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 03:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 13CE8349B85
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 02:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929932D3725;
	Mon, 27 Oct 2025 02:43:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545CB15C158
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 02:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761533036; cv=none; b=lmx0MtEOZO78VnyhC8tUym1gs5K8JQyyh1DjFEgfvUz4GfcHhiCmvVuXkrKilKdgLANgHKmzyknJM8H3DtTbI8YmZ/PSxwMMGzCQZF/g1XUigUJoWyLdwNI7Tn7Ht5M6bpkK3eggTWAgkLFyLnzrDf/GQUHp9ceeoGrypAQQfkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761533036; c=relaxed/simple;
	bh=2nmw82KF8nQ6wwMOzyGHOuZPjgDDNBy8unRuRksk+LI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tH4U1kghC0Qx8Binj9+Gxn6ft5pgI1qbYTLAZOV3qaxk7ErYi4z6PqzldJFuLCWiXopMNz9Ig8WK2ycObi1f/sljCiGRNiA3BSeSgI6jcLPVybrR3+f72FYQEDvFo78ATa+w3sVwm85/XB3EUNqpdrYAJwq5W2kRFCzgU07nzNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxO9Jl3P5oH+gaAA--.58342S3;
	Mon, 27 Oct 2025 10:43:49 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCx2sBk3P5oDqUPAQ--.47601S2;
	Mon, 27 Oct 2025 10:43:48 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Song Gao <gaosong@loongson.cn>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 0/2] target/loongarch: Add PTW feature support in KVM mode
Date: Mon, 27 Oct 2025 10:43:45 +0800
Message-Id: <20251027024347.3315592-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sBk3P5oDqUPAQ--.47601S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement Hardware page table walker(PTW for short) feature in KVM mode.
Use OnOffAuto type variable ptw to check the PTW feature. If the PTW
feature is not supported on KVM host, it reports error if there is ptw=on
option. By default PTW feature is disabled on la464 CPU type, and auto
detected on max CPU type.

With PTW enabled, there is no obvious performance improvement with
generic macro benchmark, and somewhat improvement with micro benchmark
such as test-tlb located at https://github.com/torvalds/test-tlb,
overwall there is no negative effective with PTW enabled.

Here is result about test-tlb with command ./test-tlb 0x40000000 0x8000
             host    VM without HW PTW    VM with HW PTW   improvement
cycles       180         320                 261              20%

And TLB miss rate is about 52% n this scenerary. Performance counter stats
for command './test-tlb 0x40000000 0x8000':
   67,724,819      dTLB-load-misses     #52.24% of all dTLB cache accesses
  129,639,899      dTLB-loads

Bibo Mao (2):
  linux-headers: Update to Linux v6.18-rc3
  target/loongarch: Add PTW feature support in KVM mode

 include/standard-headers/linux/ethtool.h      |  1 +
 include/standard-headers/linux/fuse.h         | 22 ++++++++++--
 .../linux/input-event-codes.h                 |  1 +
 include/standard-headers/linux/input.h        | 22 +++++++++++-
 include/standard-headers/linux/pci_regs.h     | 10 ++++++
 include/standard-headers/linux/virtio_ids.h   |  1 +
 linux-headers/asm-loongarch/kvm.h             |  1 +
 linux-headers/asm-riscv/kvm.h                 | 23 +++++++++++-
 linux-headers/asm-riscv/ptrace.h              |  4 +--
 linux-headers/asm-x86/kvm.h                   | 34 ++++++++++++++++++
 linux-headers/asm-x86/unistd_64.h             |  1 +
 linux-headers/asm-x86/unistd_x32.h            |  1 +
 linux-headers/linux/kvm.h                     |  3 ++
 linux-headers/linux/psp-sev.h                 | 10 +++++-
 linux-headers/linux/stddef.h                  |  1 -
 linux-headers/linux/vduse.h                   |  2 +-
 linux-headers/linux/vhost.h                   |  4 +--
 target/loongarch/cpu.c                        |  6 ++--
 target/loongarch/cpu.h                        |  1 +
 target/loongarch/kvm/kvm.c                    | 35 +++++++++++++++++++
 20 files changed, 169 insertions(+), 14 deletions(-)


base-commit: 36076d24f04ea9dc3357c0fbe7bb14917375819c
-- 
2.39.3


