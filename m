Return-Path: <kvm+bounces-67053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F67DCF42D8
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 15:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8502030B0889
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 14:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4362BEC2B;
	Mon,  5 Jan 2026 14:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sTG9AhL/"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FEE20DD51;
	Mon,  5 Jan 2026 14:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767623578; cv=none; b=oK3lwNwCa1uI5kqjAYm1ZrI71cZ5XAponWurr6iADu09IZDIIcED5MVxfi0FgLi7lEiwdsUqaUiY3BBUFhaxujzlIGAIN0fqT7trOf4ws17f0DvRz2OIVLfSLdPjchSLdKEo6lhRf9yh3kJL7Q3MBHRo1cSmly9CQNSVLQgp5dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767623578; c=relaxed/simple;
	bh=GLI5Ha0iW5+egqUQ1cB/MyMyjw4mcdnea9IZes0SXh0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bv5CMvolx8MF7/91jeMaAGmE2CijlhhbFLjln6KVglMyUX53rPwg+nKMBHplnnDNKXr03KjeJYiPizO6LTXAnktaOdTREnK6zoxHxxZOky0lOFxyabIspMFtHTBx3dYAWkYpXG8WlQmCqYzewBZwaRQELS+b0FV90gYw9tu0Npo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sTG9AhL/; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767623567; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=5joXXyv59ChfWJ+t1ELf3dssPeP3Cm1fUWtYyC4BYYM=;
	b=sTG9AhL/eo/XOyz6QrQvg86kwpOfeYOVSHehGmnCl/BK8DR5UNK1G+pETZ69NbnB49/nEQD53x4uilslPJz426jJCoP3RQEq6YzxebFeLaw3uv9B93wyYurVf/FC9D202L82Nps3zUEdxgY+AeI4wTHKwD97le+uSqh70RU3DgM=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WwPuTvR_1767623564 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 05 Jan 2026 22:32:45 +0800
From: fangyu.yu@linux.alibaba.com
To: pbonzini@redhat.com,
	corbet@lwn.net,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	ajones@ventanamicro.com,
	rkrcmar@ventanamicro.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v2] Support runtime configuration for per-VM's HGATP mode
Date: Mon,  5 Jan 2026 22:32:30 +0800
Message-Id: <20260105143232.76715-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Currently, RISC-V KVM hardcodes the G-stage page table format (HGATP mode)
to the maximum mode detected at boot time (e.g., SV57x4 if supported). but
often such a wide GPA is unnecessary, just as a host sometimes doesn't need
sv57.

This patch introduces per-VM configurability of the G-stage mode via a new
KVM capability: KVM_CAP_RISCV_SET_HGATP_MODE. User-space can now explicitly
request a specific HGATP mode (SV39x4, SV48x4, or SV57x4 on 64-bit) during
VM creation.

Fangyu Yu (2):
  RISC-V: KVM: Support runtime configuration for per-VM's HGATP mode
  RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE

 Documentation/virt/kvm/api.rst      | 14 +++++
 arch/riscv/include/asm/kvm_gstage.h | 12 ++---
 arch/riscv/include/asm/kvm_host.h   |  4 ++
 arch/riscv/kvm/gstage.c             | 82 +++++++++++++++++------------
 arch/riscv/kvm/main.c               |  4 +-
 arch/riscv/kvm/mmu.c                | 18 +++++--
 arch/riscv/kvm/vm.c                 | 28 ++++++++--
 arch/riscv/kvm/vmid.c               |  2 +-
 include/uapi/linux/kvm.h            |  1 +
 9 files changed, 113 insertions(+), 52 deletions(-)

-- 
2.50.1


