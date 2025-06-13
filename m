Return-Path: <kvm+bounces-49407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BFDAD8AA8
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 13:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9216188990D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 11:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5834D2D8DD0;
	Fri, 13 Jun 2025 11:38:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1CC18BC0C;
	Fri, 13 Jun 2025 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814730; cv=none; b=NZIaNLzLONf0t6FkXu76bXoYwqhU8LcHWCA+kL/OrcRUYNLGYb7H9cqPzLtHpTAT6g1FJSYY8mX2p+/ikE5oTWxH0gfXGELn8VvCS3R5TMFNMV8NxUS5ZTL1INSUof1gRizOjnUJ9+b5JzjLz6CpUZfpIxlBNV14zZmev8eUPQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814730; c=relaxed/simple;
	bh=LFiGEbOv0yEE6+gXbosvozR/D9umrkZb2ofxQGgFRMg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BEj02icceZUdoPhP+JZrV/wpfwr4jCuz8PpbCE/GVlsXXJmuHcWLOzp3roOQhlPw0gkRc5P3X2NE/PTzAjAaLMD1Nj+8jBCFMwE7QUVQ8LHVdPJmc7Nwx5iyQYtBM62fd86Zzos5xcEtAY2cHLbk7Jv+RUkXmYcS+L1qCkNNtoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.smartont.net (unknown [180.110.114.155])
	by APP-03 (Coremail) with SMTP id rQCowAC3CFG2DUxo0Ak5Bg--.60443S2;
	Fri, 13 Jun 2025 19:38:32 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH 0/2] RISC-V: KVM: Enable ring-based dirty memory tracking
Date: Fri, 13 Jun 2025 19:29:48 +0800
Message-Id: <cover.1749810735.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC3CFG2DUxo0Ak5Bg--.60443S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZw47ZryxGFWUZw18ArW3GFg_yoWxAFbEk3
	y8J397JrWxZa18XFW7Xan5XFWDKayfK34DXF1YvF15Kr1Dur47Ga1kZr1qvrWUCrs8X3sI
	yF4fZFySq347KjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoPEfDUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBg0MBmhL72JrpwAAsj

From: Quan Zhou <zhouquan@iscas.ac.cn>

Enable ring-based dirty memory tracking and add some
common KVM tests for riscv.

Quan Zhou (2):
  RISC-V: KVM: Enable ring-based dirty memory tracking
  KVM: riscv: selftests: Add common supported test cases

 Documentation/virt/kvm/api.rst                 |  2 +-
 arch/riscv/include/uapi/asm/kvm.h              |  1 +
 arch/riscv/kvm/Kconfig                         |  1 +
 arch/riscv/kvm/vcpu.c                          | 18 ++++++++++++++++--
 tools/testing/selftests/kvm/Makefile.kvm       | 12 ++++++++++++
 .../selftests/kvm/include/riscv/processor.h    |  2 ++
 tools/testing/selftests/rseq/rseq-riscv.h      |  3 +--
 7 files changed, 34 insertions(+), 5 deletions(-)

-- 
2.34.1


