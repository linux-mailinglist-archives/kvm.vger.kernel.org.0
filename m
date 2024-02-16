Return-Path: <kvm+bounces-8860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 450FD8578F9
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 10:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB9C4B23980
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 09:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297171BC46;
	Fri, 16 Feb 2024 09:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="mOrfbXlS"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF441BDC9;
	Fri, 16 Feb 2024 09:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708076286; cv=none; b=Oz9qNlzq6D/oply0gxTtNE5c32b8x24jdQE9il/rHYGkO63GuJ+AGO4MfL1y4i40Qrn5a+23FEyysBhvJo9inMDhfBQOueAwvMGC9B+eVwzgemEDRuEZUbQy4vYWcrGYxqcf2+mTSZx4v/33cdmkSygQiBCgzavX53DBtYhHUO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708076286; c=relaxed/simple;
	bh=S4hpCs8mNTdKHxWWEnw+nDGq+xcgWq2m0IKCw72/mp8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TESluJq5zW9xYHUSP2v9VWz/zXgT/Y/o143o6MV1TAjx2HcN2IdU4IWI5tn1HWLszs9FcMCCMvJF3XvaF8F1jmOIWyw42b7yBd+xhZDf7WkJ/V9ShxpDFkxSzbUC+Qn+bTh+GuXlmIImm7odU7k4GAd9eheHxg9ZxaaBdUTjp1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=mOrfbXlS; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708076281; bh=S4hpCs8mNTdKHxWWEnw+nDGq+xcgWq2m0IKCw72/mp8=;
	h=From:To:Cc:Subject:Date:From;
	b=mOrfbXlSvKtZhwLbSLbBGTKJ/5vsHngfqKWqP/KaeMxMBwuu2ncaG8cc1IUopw162
	 3IgsuChX7PaksEF3Uf7S3rSjyZ0JN2jMtOzvnfUyXdsv3zHdtjkE0NuDeJPfjT7YS8
	 lzAJILesZ/KCskGt4d2GAnz13wBs1VyjUf5cWHgc=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:cda4:aa27:b0f6:1748])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 1240360114;
	Fri, 16 Feb 2024 17:38:00 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH RESEND for-6.8 v3 0/3] KVM: LoongArch: Fix wrong CPUCFG ID handling
Date: Fri, 16 Feb 2024 17:37:56 +0800
Message-ID: <20240216093759.3038760-1-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

Hi,

(Sorry for the noise; in the previous revision the patch 1 contained a
syntax error. I've also added a Fixes: tag for the KVM LASX support
commit while at it.)

While trying to add loongarch to the Rust kvm-bindings crate, I
accidentally discovered faulty logic in the handling of CPUCFG IDs
("leaves" for those more familiar with x86), that could result in
incorrectly accepting every possible int for the ID; fortunately it is
6.8 material that hasn't seen a release yet, so a fix is possible.

The first patch contains the fix, while the rest are general
drive-by refactoring and comment cleanups.

Although it is currently the Chinese holiday season, Huacai told me
over IM that he's able to test the series and handle the upstreaming, so
going through the loongarch tree seems to be the way forward for the
series.

v3 changes:

- Fixed the validation by accepting every CPUCFG IDs from 0 to 20
  inclusive, instead of only 2; this was a misunderstanding of mine
  regarding the userland. (currently the only known user, the QEMU
  target/loongarch KVM code, expects to be able to set all these 21
  CPUCFG leaves, even though 7~15 are undefined according to the
  LoongArch reference manual.) This also had the effect of squashing the
  first 2 patches.
- Made the _kvm_get_cpucfg_mask return a mask in all valid cases,
  allowing the mask check to be lifted out of the CPUCFG2 case.
- Swapped the "LoongArch:" and "KVM:" tags because right now the patches
  are likely to reach mainline through the loongarch tree, and having
  the "LoongArch:" prefix first is the convention here.

v2 changes:

- Squashed the v1 patches 4 and 5 according to Huacai's review
- Reworded comments according to Huacai's suggestion
- Use WARN_ON_ONCE (instead of BUG) to replace unreachable() for not
  crashing the kernel (per checkpatch.pl suggestion)

WANG Xuerui (3):
  LoongArch: KVM: Fix input validation of _kvm_get_cpucfg and
    kvm_check_cpucfg
  LoongArch: KVM: Rename _kvm_get_cpucfg to _kvm_get_cpucfg_mask
  LoongArch: KVM: Streamline kvm_check_cpucfg and improve comments

 arch/loongarch/kvm/vcpu.c | 81 ++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

-- 
2.43.0


