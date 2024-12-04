Return-Path: <kvm+bounces-33035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D19909E3B95
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9665D285F39
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B481EE00E;
	Wed,  4 Dec 2024 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="nn4gQnVB"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3201E49F;
	Wed,  4 Dec 2024 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733319954; cv=none; b=Jf2/d719CXgqHDBF15tvRToh2uOGHJW0ufcZL7HK39j0mmCPU+piIyZNBUO3T+8sH1eOLxryaBiFEXgyMhF67Qa/zuyw6stbVhTTNaQfDkJMutP9sWbleCaJ4ANB+kNyojaLVvG6kS7Ty4K2uGnS3768LeDceqI3XzBO2Sh+1As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733319954; c=relaxed/simple;
	bh=g8AvYIW7jH+ii3UmW0T9VTZeV7PGvLHweWjBnNIFyv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IXSfe9vnMZc6I3ewW8Tecw2KW8PtZ0wIFEVSyShm1dmR8SUltY/dR+z2H9WLfB89uHeJSARKoTrTc1Pfpr3HAWtE7VZwfElcODLuxLDaHjWS4Fmjwnz8fhKyTIep7DCyyayDWR1Orp0P3jqnEgMmXPgRvQXwi+xxH7dF4zfUwqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=nn4gQnVB; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2e8b:0:640:9795:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 3BAAB60A5A;
	Wed,  4 Dec 2024 16:43:58 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lhgH281Ia8c0-9M2fCnfb;
	Wed, 04 Dec 2024 16:43:57 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1733319837;
	bh=Kvl3o13+wUbdHQxbdlklNiUKst3/boeificR7MkTy2U=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=nn4gQnVBWxmBDeSxz4o8bb4JnJZVKk5iuGrfWb/N01CM83Z6+1rbHVJoMjLSAsiz0
	 yMOXTZGRILyAccyHZlHO1sM53hLANQMeEBzp0roZxuWJEnXgK0mN4HznjKmq1g5yBG
	 dBpgHiEHTbxzozqinMq13sLF63XhRwmPv1B4VJiY=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v3 0/2] x86: KVM: Add missing AMD features
Date: Wed,  4 Dec 2024 16:43:43 +0300
Message-Id: <20241204134345.189041-1-davydov-max@yandex-team.ru>
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

v3 -> v2:
* rebased onto the newest master
* AMD_IBPB_RET was removed because all work had been done in 71dd5d5300d2
* renamed "IBRS provides same mode protection" bit

v2 -> v1:
* fixed the bug in the FSRC definition

v2:
https://lore.kernel.org/kvm/20241126094424.943192-1-davydov-max@yandex-team.ru/

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


