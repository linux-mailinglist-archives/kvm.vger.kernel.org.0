Return-Path: <kvm+bounces-8856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA24857842
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 09:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31F622896C2
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 08:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411301B974;
	Fri, 16 Feb 2024 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="NLQtBI3X"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C40B1B952;
	Fri, 16 Feb 2024 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708073915; cv=none; b=fTcQc4Y6PH5/+N1oxNTJ/Ll6/uS9zr0qhC7SleJqq3IvKtl5bWoaDHNkqkq+fsEFh5iBFcYqar7ACLybk3o5CtVkZp7VE9qjrPH5jgdHd6LmN5gIuQGE2jBLWqBKeoiJfEHS+B/oM1O7xScgQQp/fQyPPKBPaO0LmCrH5vyOGy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708073915; c=relaxed/simple;
	bh=6rGzVUEnAIPXFTtTRrlSD4OhQqOoYi3GoHpLdubGYK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EFBGKIooXE3tKpCJ3BE7LsCbVDs49DAPMXkHlb8WMxDx/ZVTX9ohrGwmcyii3bvYZvJcm8Gx2erxGUYYpA/mzw0HZqqETKgBYy0DWKc4pTYgsI/sWMvfvdY6ozNVs8hL2jsmiZHjrGHnIcSIq2K5Me6qwUZw2dUPHX+n0H70qcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=NLQtBI3X; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708073909; bh=6rGzVUEnAIPXFTtTRrlSD4OhQqOoYi3GoHpLdubGYK8=;
	h=From:To:Cc:Subject:Date:From;
	b=NLQtBI3X1DWM6UJ8hj3z7FZFI5vgib6gb868bu/iQRvEdicp3LOtgbUdzBnGVDqpi
	 IbwoKZDGgBscy1jAumcWEoUpfVUJlzva0C7PEEVUItMRweNOTTEGFMoyUt5iDiBdmd
	 WmJd7iSmggXf/bMQruItZCRZ8T5PtqyTSJopcX4s=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:cda4:aa27:b0f6:1748])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 2A2E06011B;
	Fri, 16 Feb 2024 16:58:26 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 v3 0/3] KVM: LoongArch: Fix wrong CPUCFG ID handling
Date: Fri, 16 Feb 2024 16:58:19 +0800
Message-ID: <20240216085822.3032984-1-kernel@xen0n.name>
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


