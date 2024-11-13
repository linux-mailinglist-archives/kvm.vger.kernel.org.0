Return-Path: <kvm+bounces-31750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CFA9C70B9
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 901A61F27A4F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F28E1F77AF;
	Wed, 13 Nov 2024 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="bTeUY1ws"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019A11DF992;
	Wed, 13 Nov 2024 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504818; cv=none; b=TR1JvF0xFdh74HlwYpwU5LJpIIl1i7SAtjIcaWj6FhgPWp8uL0yks0GUTAbyb6zqmkfgwKn6Sg+FukPc273TZIWur/1wIEFXcfaPgAedwBMHs9KT1WD9Ucbgf7pw6g61BQS2iGlNEaf101Qpyy5LI5N1i2cW9blT98tJzKNMwx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504818; c=relaxed/simple;
	bh=7QrYuH7qPO04aYSErNInhDraIic64tBQjuKrkxmWST4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X91V9RoXVAa6foaHL1anu+7E8+83gp4o8IMePrQkvb6bihOMEXFwjJzADtQlrR0TVehHv6+xLoCgzQLnHLVxeIPJbV3UuQZ71b4ZYqPdP09W5QviIN1W16dK5Un50KPkfUxbsLyTPbQw2ZosVv1YIHRJatEJGngyZfslgdxlsCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=bTeUY1ws; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2711:0:640:16b3:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id B9E8E60B43;
	Wed, 13 Nov 2024 16:31:32 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id JVLWaO4DTW20-3d8zOL0z;
	Wed, 13 Nov 2024 16:31:32 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731504692;
	bh=ocH0TZiR1PWJ8d/4bYgFzugkS0llA8+nkkoz7/mVBlk=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=bTeUY1ws/q00pA7nEFZx/zJYQ+erHNQYEmRXGCIh+wK8lyLYQO8T83qGVS9XMIocI
	 a05e0jdsZB+3P1dldUWqkpYkWmKLYtQEURvXWZgIQGkHwzGMrSVZ/Ai4TBD+mblpyW
	 tEyT6PpkF2cqsMV9sGlGvniTcKW4gWcTdiZ3O4gA=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Maksim Davydov <davydov-max@yandex-team.ru>
To: kvm@vger.kernel.org
Cc: davydov-max@yandex-team.ru,
	linux-kernel@vger.kernel.org,
	babu.moger@amd.com,
	x86@kernel.org,
	seanjc@google.com,
	sandipan.das@amd.com,
	bp@alien8.de,
	mingo@redhat.com,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	pbonzini@redhat.com
Subject: [PATCH 0/2] x86: KVM: Add missing AMD features
Date: Wed, 13 Nov 2024 16:30:40 +0300
Message-Id: <20241113133042.702340-1-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds definition of some missing AMD features in
0x80000008_EBX and 0x80000021_EAX functions. It also gives an opportunity
to expose these features to userspace. 

Related discussion in QEMU:
https://lore.kernel.org/kvm/24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru/

Maksim Davydov (2):
  x86: KVM: Advertise FSRS and FSRC on AMD to userspace
  x86: KVM: Advertise AMD's speculation control features

 arch/x86/include/asm/cpufeatures.h | 5 +++++
 arch/x86/kvm/cpuid.c               | 9 +++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.34.1


