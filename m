Return-Path: <kvm+bounces-8690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A1FC854EAB
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06FA928D955
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 16:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E2F63116;
	Wed, 14 Feb 2024 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="QqaH5u+X"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5014D612E3;
	Wed, 14 Feb 2024 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707928447; cv=none; b=FDjyjZ5IOO10Qa0E0cWjHwmhG319D+2A/ZdUhBNCr2Lm7R9sTvtnI/a42Q3It5rj+qzn68Nta6hetFScH3nwPd8ZowrosaqXiy7BMxB0YFwPB5pWM+XSzOW0Ex/kILeLYzzaMx94mL+3nj3MSFK4QqokOuXN18iG1wcQvjexDgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707928447; c=relaxed/simple;
	bh=1XKtHdaBogGBmhevzOA+1J0TfVkkoFlByHGLSLFpVbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rL9KHAyKyYtLx6o/17cuxJj+VKg79RUCYvz0VlR05989+S5boXKPa8SQgM7GGZtMNxxgYkY7m+TQhapVzFrxEqwLn6Q5vsVvae2PEQ856O7+HT6sM8ughFCKaKdZIPss5kik9WVpJdb187mQNiVMNIT/utt/5dcI7phmJXAxEZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=QqaH5u+X; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707928440; bh=1XKtHdaBogGBmhevzOA+1J0TfVkkoFlByHGLSLFpVbk=;
	h=From:To:Cc:Subject:Date:From;
	b=QqaH5u+Xo/W9IJRaaHTp6Ju4nqebG3xvKSTIwxz831cpCmcUQVG91DIGbxk3Zm8Iv
	 nh+RTfX8v1mqXpodNLsMwpHBRpXl4+vgEpG68T45ufcRD/DkSQverm2FYO6dZP461a
	 7QKm9YZerI3YHGQ2zuB9GGe9jjUI87GKlhr1EY1U=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:42e8:c06f:a0dc:12f8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id ABC0B60114;
	Thu, 15 Feb 2024 00:33:59 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v2 0/4] KVM: LoongArch: Fix wrong CPUCFG ID handling
Date: Thu, 15 Feb 2024 00:33:53 +0800
Message-ID: <20240214163358.2913090-1-kernel@xen0n.name>
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

While trying to add loongarch to the Rust kvm-bindings crate, I
accidentally discovered faulty logic in the handling of CPUCFG IDs
("leaves" for those more familiar with x86), that could result in
incorrectly accepting every possible int for the ID; fortunately it is
6.8 material that hasn't seen a release yet, so a fix is possible.

The first two patches contain the fix, while the rest are general
drive-by refactoring and comment cleanups.

(As it is currently the Chinese holiday season, it is probably best for
this series to go through the kvm tree, instead of the loongarch one
even though they seem to like prefer collecting every loongarch patch.)

v2 changes:

- Squashed the v1 patches 4 and 5 according to Huacai's review
- Reworded comments according to Huacai's suggestion
- Use WARN_ON_ONCE (instead of BUG) to replace unreachable() for not
  crashing the kernel (per checkpatch.pl suggestion)

WANG Xuerui (4):
  KVM: LoongArch: Fix input value checking of _kvm_get_cpucfg
  KVM: LoongArch: Fix kvm_check_cpucfg incorrectly accepting bad CPUCFG
    IDs
  KVM: LoongArch: Rename _kvm_get_cpucfg to _kvm_get_cpucfg_mask
  KVM: LoongArch: Streamline kvm_check_cpucfg and improve comments

 arch/loongarch/kvm/vcpu.c | 68 ++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 41 deletions(-)

-- 
2.43.0


