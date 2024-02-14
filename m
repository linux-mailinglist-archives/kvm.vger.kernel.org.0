Return-Path: <kvm+bounces-8657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89318854712
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 11:24:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C1DF1F2A011
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 10:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96EE1863B;
	Wed, 14 Feb 2024 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="setR4T+X"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F2017552;
	Wed, 14 Feb 2024 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707906251; cv=none; b=FbII5D2SEfNdiGMw8wURJyA7EPZzHSBpIw6CsY7V6jyOxJr3Z3h59U+NB9tS3wSXuXEunN41kzxF0V35mKE1e04K0U5q5yraDIImUPQgnEFFmiJZi7gxe86lsTgzQAxliVdr9w9l5wF/BalMtXBCnxFP5lB/RVGg9K/31lLXNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707906251; c=relaxed/simple;
	bh=gifFn/80q51+NK0CjT7eHBD5A+SqG4W3WFxbem4VjfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HqElN2S9Wr8MWwk2nrx82w2Fug2zKePsEJDNDqC91V2a0bePuynBgghPxrnMpsqktI4qNQp+R6D1n8zaU04R8c5BIij/AGZIucZPwqpqg/51Ihcj20+TaNdVadsHdllRrQvOr8bqc/fBYG7SPnCBPAkaghTliNkWNI/IT6w28iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=setR4T+X; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707905763; bh=gifFn/80q51+NK0CjT7eHBD5A+SqG4W3WFxbem4VjfA=;
	h=From:To:Cc:Subject:Date:From;
	b=setR4T+XzQd+3Dsb6NQLwydEUmMUGSRoZZycHQcZWdsRvKwvSeUFhltRAqC8Tu/d4
	 JlDB2Fq+yZigcUGrViMvQ8GQNkH6Ii3vC8mZWlN0/NDM2P7NFUbXnuRxu6Thd4CRSM
	 dISIPx2Jaj9zrsxwmoXM3zpWWLJfDEVow5GeGusY=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:5531:eef6:1274:cebe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 8312C600CF;
	Wed, 14 Feb 2024 18:16:02 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 0/5] KVM: LoongArch: Fix wrong CPUCFG ID handling
Date: Wed, 14 Feb 2024 18:15:52 +0800
Message-ID: <20240214101557.2900512-1-kernel@xen0n.name>
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

WANG Xuerui (5):
  KVM: LoongArch: Fix input value checking of _kvm_get_cpucfg
  KVM: LoongArch: Fix kvm_check_cpucfg incorrectly accepting bad CPUCFG
    IDs
  KVM: LoongArch: Rename _kvm_get_cpucfg to _kvm_get_cpucfg_mask
  KVM: LoongArch: Streamline control flow of kvm_check_cpucfg
  KVM: LoongArch: Clean up comments of _kvm_get_cpucfg_mask and
    kvm_check_cpucfg

 arch/loongarch/kvm/vcpu.c | 72 ++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 43 deletions(-)

-- 
2.43.0


