Return-Path: <kvm+bounces-9375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBEB385F627
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 716FA1F21B05
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D714177B;
	Thu, 22 Feb 2024 10:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="TYHKYtNR"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C564F38FA9;
	Thu, 22 Feb 2024 10:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599081; cv=none; b=DUhMSRhNzfm6Nnr9RqZPCITCASKsCe8fZ80/qi0mQVfgz85ijAyB5Ggyyy/l03sCSKOTnWehRCZBShO5PTQxPeP+M0dCHvu8BishmJ3zJjBlskUPh6pncDclO0k9ahgBurVsmE2PNXUKTcUEqn7BTKlJKJ81XOpUykVlXBWHRy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599081; c=relaxed/simple;
	bh=yOIwRd5ViCvQ9E5IPM/+zp/3BLFVwABgQS8E6A6HShU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=awNFV2m1ZE66mvWymod2F/yB0LE6zQhrM4+Lmh+zeGVfBiVOK0i1xdTNsrsveRoDPrL24rCsZrXfbozXGyr/x7QeQapo45pTear6pBa1J5KXaHRfWk7BLGmnF3gzkxN2pWPCl8DYY1yQPHLLHcsX/IG/kXAqRR88ANxyGR14Ivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=TYHKYtNR; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708599075; bh=yOIwRd5ViCvQ9E5IPM/+zp/3BLFVwABgQS8E6A6HShU=;
	h=From:To:Cc:Subject:Date:From;
	b=TYHKYtNR1nbu06VwzdMvhYZk/w3K1gfQCnxFmmbAN5WnDfCsl7Hbk/GPV1AAfMM+t
	 xVZ5PUr5DxlxPBvjReWLnwB6yCCcc2srYjaLBK+/AGagw4S6iWyQbMwHQd35qu8mQK
	 26ORXlJgEeeZ+GNzujl7cDwq/J1s36sJRxzTnVJs=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:58fe:4c0e:8c24:2aff])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id CE79860094;
	Thu, 22 Feb 2024 18:51:13 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v4 0/3] KVM: LoongArch: Fix wrong CPUCFG ID handling
Date: Thu, 22 Feb 2024 18:51:06 +0800
Message-ID: <20240222105109.2042732-1-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.2
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

The first patch contains the fix, while the rest are general
drive-by refactoring and comment cleanups.

Although it is currently the Chinese holiday season, Huacai told me
over IM that he's able to test the series and handle the upstreaming, so
going through the loongarch tree seems to be the way forward for the
series.

v4 changes:

- Restored the range check with `if` to simplify future additions to the
  switch cases according to Bibo's suggestion
- Require upper 32 bits of new CPUCFG values to be unset, according to
  off-list suggestion by Huacai

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

 arch/loongarch/kvm/vcpu.c | 81 +++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 41 deletions(-)

-- 
2.43.2


