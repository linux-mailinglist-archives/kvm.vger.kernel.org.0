Return-Path: <kvm+bounces-55123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4896B2DD41
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38CDF7205C8
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8009F31DDBD;
	Wed, 20 Aug 2025 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vCyZUaUF"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB631AF21;
	Wed, 20 Aug 2025 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755694802; cv=none; b=Bz+JCuYwi1asoUOtCCdDsZu4puUy7Rdt7ZrhdCPwDmOlWoG7mQ0Xbhmff2g3PDs+n05b715Z7pv8f6UBIjmtgTteNc8V9l7muH0xYUuFl++/JE1hQfWozfWKIJ89Jb9lSTONIVnQQC6EXYy5K/oKHdSH1H2KIBNy83ktzoNw2bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755694802; c=relaxed/simple;
	bh=xsoHPu8B4TNKWz7PuMS+ZiO+JRaUYHtcES3xeRbf6Nc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DeAXmmNwRzJwT4rnQ57UhQC54o5Gb4zf+6lnKEaa1Z5QHzbW/E7jutlnZTxIGwMUQQkUrx0wRxUudl4YsiiZXu1y3OD6ZWCxeF9crRxHDQ00rZyOJkauDIQEHHScE9BEs+QqdzE0Rd2Ziyrna4ZoaHwZXDTSh4LbceWWy/3PQ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vCyZUaUF; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755694796; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=XgpkwoPcHNm5bqngyKgaAijv3704PoYrCd7F3xEpnsE=;
	b=vCyZUaUFLsKNLyYEdqohwggSZ0kuP6oNvD4A1h6Q1B1YCrfdkBrv58Y7hQY+dJmyko0NC4/7HoX49CqiikLM60Q6bQ8uJwY2jBrpvKUiR6V6RhWE3dGMzeQtd4Ursb7Miz2Jj7iu/G+UEANAn/nE2KA17DrF/UQgGFsDMi4QNmA=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WmCQaZ-_1755694794 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 20:59:55 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v3 0/2] Fix hgatp mode settings within kvm_riscv_gstage_vmid_detect 
Date: Wed, 20 Aug 2025 20:59:50 +0800
Message-Id: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

According to the RISC-V Privileged Architecture Spec, when MODE=Bare
is selected,software must write zero to the remaining fields of hgatp.

So,use a valid mode when detecting vmids of the HW supported,meanwhile
remove unnecessary HGATP csr_read.

---
Changes in v3:
 - Add "Fixes" tag.
 - Involve("RISC-V KVM: Remove unnecessary HGATP csr_read"), which
   depends on patch 1.

Changes in v2:
 - Fixed build error since kvm_riscv_gstage_mode() has been modified.
---

Fangyu Yu (1):
  RISC-V: KVM: Write hgatp register with valid mode bits

Guo Ren (Alibaba DAMO Academy) (1):
  RISC-V KVM: Remove unnecessary HGATP csr_read

 arch/riscv/kvm/vmid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
2.49.0


