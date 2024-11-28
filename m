Return-Path: <kvm+bounces-32714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E62BE9DB1D5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78D0B16744A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A3785626;
	Thu, 28 Nov 2024 03:23:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C280C433B1;
	Thu, 28 Nov 2024 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764210; cv=none; b=WZH0wkSMdinFZsr9FRWiJFJ3MN/I1/eslMXu+VFi/qhZu3C3Kh3nwh9lIuFnP2lBiGo+RwK0bwnqfUCaekaFwFshSNOjn5l/wIzarqa0XsmQj1xBB+WoFSA91h78jxgriQhnDx6mqurEttoU1DUH6ivBtC1C1KkhMLIFADXnZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764210; c=relaxed/simple;
	bh=f85oDLt2xEs2E9oKdtvBe662XTzaPN6ZYnbSK41aqLI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lPbOFlcJkLApj+K5e7JdVtRq58/nJeyKDxJ7Dr26LL03tWRJHtj09MWlXcB5fN/rKkKxUhMqjlbrplKDfvpMIhgXlIvA4auOETf8rLlKazbVy4KlADOTWpPT/zZ43G3ADEJdJvX+NRKqv4LXKxO+M2V3ghONJ3aZvx0/VpBYh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.. (unknown [180.111.103.148])
	by APP-05 (Coremail) with SMTP id zQCowAAXHkob4kdnsFUcBg--.352S2;
	Thu, 28 Nov 2024 11:23:08 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 0/4] RISC-V: KVM: Allow Svvptc/Zabha/Ziccrse exts for guests
Date: Thu, 28 Nov 2024 11:20:53 +0800
Message-Id: <cover.1732762121.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXHkob4kdnsFUcBg--.352S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYt7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z2
	80aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26F4j6r4UJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCF04k20xvY0x0EwIxGrw
	CF54CYxVCY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZ
	yCJUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBgoPBmdHkZDh4gAAsn

From: Quan Zhou <zhouquan@iscas.ac.cn>

Advertise Svvptc/Zabha/Ziccrse extensions to KVM guest
when underlying host supports it.

Quan Zhou (4):
  RISC-V: KVM: Allow Svvptc extension for Guest/VM
  RISC-V: KVM: Allow Zabha extension for Guest/VM
  RISC-V: KVM: Allow Ziccrse extension for Guest/VM
  KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts to get-reg-list
    test

 arch/riscv/include/uapi/asm/kvm.h                |  3 +++
 arch/riscv/kvm/vcpu_onereg.c                     |  6 ++++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 12 ++++++++++++
 3 files changed, 21 insertions(+)

-- 
2.34.1


