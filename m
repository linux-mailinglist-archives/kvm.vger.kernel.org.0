Return-Path: <kvm+bounces-32501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31EB79D94F6
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:57:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 930A7B2500E
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 09:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C811C7B8D;
	Tue, 26 Nov 2024 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="LGrtcgwG"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6A75C96;
	Tue, 26 Nov 2024 09:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732614326; cv=none; b=bWvSfKDzD4vb03769QXvcA97XNRJmEPfJ9SS5L3vta30lWVxaX+4U7NQ0bbyXfdxy4UentQ11bGwqhlCRqFQABhiSEqu2pigJo2pUi//biRs3MV+t8Yg2B5LoG9/s+BjPMjwTQ7P/K1T4jL0zbAz0/OeUodiFtaktGfEcTSbIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732614326; c=relaxed/simple;
	bh=k4Z20ShZgi2h5Jz35RXoIyjiUqdAwVqqdttoCscNx4w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Wmxb3BhwaKcfhavTHf5AO+DD4E7T2ACrXFl9OEj3xkXNIvtLVXP3IbS+G7AIZhSQqML7o1/dw1dCDtTX6aProFxKxSYMFUZH0bqW90XdAcF1Yl03kAqSM5JNQuzZukEMzb1NxqgDAyhPHWaGtKl1AJ/+YpoXb/JqAOgKGftMtAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=LGrtcgwG; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id BF37960AD7;
	Tue, 26 Nov 2024 12:45:13 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0jUcd53IW8c0-H9UhGOIM;
	Tue, 26 Nov 2024 12:45:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1732614313;
	bh=0XrNiuwphji9RmI/T/QPwFCG/6qCkSFrjJsE0HpN6p0=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=LGrtcgwG8/ovKoRMmfEWvX9b+0b+0u4IjByEzpOb4SxYQyYLe/ElDkYtaL2hSSuJN
	 D7oLKAlDoQDhCmdx/NDwCltfMQIucil1E24Gd6HZwLDkyiSTDBKo+L6cY+L/ukcCJ2
	 qh4w/pK1ngdvWB06l98M8Kc/hLsZQ3b4xuS6lIkA=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Maksim Davydov <davydov-max@yandex-team.ru>
To: kvm@vger.kernel.org
Cc: davydov-max@yandex-team.ru,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	babu.moger@amd.com,
	seanjc@google.com,
	mingo@redhat.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	jmattson@google.com,
	pbonzini@redhat.com
Subject: [PATCH v2 0/2] x86: KVM: Add missing AMD features
Date: Tue, 26 Nov 2024 12:44:22 +0300
Message-Id: <20241126094424.943192-1-davydov-max@yandex-team.ru>
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

v2 -> v1:
* fixed the bug in the FSRC definition

v1:
https://lore.kernel.org/kvm/20241113133042.702340-1-davydov-max@yandex-team.ru/

Maksim Davydov (2):
  x86: KVM: Advertise FSRS and FSRC on AMD to userspace
  x86: KVM: Advertise AMD's speculation control features

 arch/x86/include/asm/cpufeatures.h | 5 +++++
 arch/x86/kvm/cpuid.c               | 9 +++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.34.1


