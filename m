Return-Path: <kvm+bounces-60485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5265BBEFD59
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8145E3BBD63
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB5A2E9ECC;
	Mon, 20 Oct 2025 08:12:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10612E9737
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760947930; cv=none; b=VZnyvAuha8A7FrUlzPbjvDKW9qNajWQHXx2W2nZhCc1pXunN4RtQMU9VDm7droihzd1l5ZB6f76JBl1Jq7mtkWXUGF7fDiMu1tjoT/+vDytkv+l473snR93an3akwSeaMGSVjLJbBomuGLG00e2MpZ8jJofUP5hQy/KXGTiSTqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760947930; c=relaxed/simple;
	bh=A36wA+evTnsGrIkrjjELyh88jba5BcZsy3Jlm4Kdrrw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MIVdJ/y1vdA70HiMMWJq0y2M/Ac0etucuG317XMBFbWEmIL3iCMstXvdg2w9/937HtoAF7AdSR9k0U/AV1T8Sm6Yn6xlMaG10k9butvF0kyWOndwuEPYhMgsM4fP6JiQjRnSy6EOfIdUn7XzIEnmJA98jMkwKf2FzTORlXinSwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxF9HT7vVo_TQYAA--.52032S3;
	Mon, 20 Oct 2025 16:12:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxZOTQ7vVohSf4AA--.18451S2;
	Mon, 20 Oct 2025 16:12:01 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Song Gao <gaosong@loongson.cn>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [RFC 0/2] target/loongarch: Add PTW feature support in KVM mode
Date: Mon, 20 Oct 2025 16:11:57 +0800
Message-Id: <20251020081159.2370512-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxZOTQ7vVohSf4AA--.18451S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Implement Hardware page table walker(PTW for short) feature in KVM mode.
Use OnOffAuto type variable ptw to check the PTW feature. If the PTW
feature is not supported with KVM host, it reports error if there is
ptw=on option.

This patchset is based on PTW feature on TCG mode:
https://lore.kernel.org/qemu-devel/20251016015027.1695116-1-maobibo@loongson.cn/

With PTW enabled, there is no obvious performance improvement with
generic macro benchmark, and somewhat improvement with micro benchmark
such as test-tlb located at https://github.com/torvalds/test-tlb,
overwall there is no negative effective with PTW enabled.

Here is result about test-tlb with command ./test-tlb 0x40000000 0x8000
             host    VM without HW PTW    VM with HW PTW   improvement
cycles       180         320                 261              20%

And TLB miss rate is about 52% n this scenerary.
Performance counter stats for 'taskset 0xf ./test-tlb 0x40000000 0x8000':
   67,724,819      dTLB-load-misses     #52.24% of all dTLB cache accesses
  129,639,899      dTLB-loads 

Bibo Mao (2):
  linux-headers: Update to Linux v6.18-rc2
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
 target/loongarch/cpu.c                        |  5 +--
 target/loongarch/cpu.h                        |  1 +
 target/loongarch/kvm/kvm.c                    | 35 +++++++++++++++++++
 20 files changed, 169 insertions(+), 13 deletions(-)


base-commit: 36df9f3764a5d18683e79f743bc9fa1550d76da0
-- 
2.39.3


