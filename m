Return-Path: <kvm+bounces-41592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7781DA6ACCE
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 19:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D748488AC6
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47EC1226CF6;
	Thu, 20 Mar 2025 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5g2stWj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43731EB18F
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 18:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742494018; cv=none; b=Ai3zQo4m+DggpKM4hzJqp9KwZoz9cUtLllz3B6aI09QDPuhc0sydsjq+dokDlNFy12LyrzGeqeu9kwWvnx5Fmqtf+jemj/elKDTeaIGSJwU+0FryUfhZhVxaVQcxq8XF/nmy9v8mfMw4gF5I5DFu9fqlwPN7+mi/1EVeAdI41mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742494018; c=relaxed/simple;
	bh=VbcBXlqxQ8R1Ak3EnW4jRzK2MT9B93mYiE6a4eqTPeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M1NatakEDvdhtXBjq9KNJiaRDS3KePZQS/hNAzwUYDZW0TSHKsIyARiiV4wQv7ptbOtLFFNYGpIGmSMzkwETurWO1SzhZfP1s2P3Ug+pwBs3BRH82ikccnipiJC3TSzE/uy0duaLKMPkY4PTLIb8r0ru6hgwvBhFHcMLPp/b0d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5g2stWj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742494015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4KWDo96DATcrCi+aZaGajcdmZmzyQjrvIRx3fYoFil0=;
	b=G5g2stWjE1aTDWjIzLgcI6hVG/LtAQ4AeJtUUMPwy+cYOS1m4Hl8Zji9B5j0c5Inxvmm8S
	ZSemdO9P6CVwWDADfOjJaPtJo9LtZJdl8tDlmMrNbJ+PTEGw7WbVPHZawKXG0QXDtAMR1P
	F1IFXZoOd1Hz1DIF2JcWv4OLyS5Ky/U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-451-mhjdh0KtNu6c-5W776kB4Q-1; Thu,
 20 Mar 2025 14:05:25 -0400
X-MC-Unique: mhjdh0KtNu6c-5W776kB4Q-1
X-Mimecast-MFC-AGG-ID: mhjdh0KtNu6c-5W776kB4Q_1742493924
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 385AB1933B48;
	Thu, 20 Mar 2025 18:05:24 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91CAC1828A83;
	Thu, 20 Mar 2025 18:05:23 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM fix for Linux 6.14 final
Date: Thu, 20 Mar 2025 14:05:22 -0400
Message-ID: <20250320180522.155371-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Linus,

The following changes since commit 4701f33a10702d5fc577c32434eb62adde0a1ae1:

  Linux 6.14-rc7 (2025-03-16 12:55:17 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to abab683b972cb99378e0a1426c8f9db835fa43b4:

  Merge tag 'kvm-s390-master-6.14-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2025-03-19 09:01:53 -0400)

----------------------------------------------------------------
A lone fix for a s390 regression.  An earlier 6.14 commit stopped
taking the pte lock for pages that are being converted to secure,
but it was needed to avoid races.

The patch was in development for a while and is finally ready, but
I wish it was split into 3-4 commits at least.

----------------------------------------------------------------
Claudio Imbrenda (1):
      KVM: s390: pv: fix race when making a page secure

Paolo Bonzini (1):
      Merge tag 'kvm-s390-master-6.14-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/include/asm/uv.h   |   2 +-
 arch/s390/kernel/uv.c        | 136 ++++++++++++++++++++++++++++++++++++++++---
 arch/s390/kvm/gmap.c         | 103 ++------------------------------
 arch/s390/kvm/kvm-s390.c     |  25 ++++----
 arch/s390/mm/gmap.c          |  28 ---------
 6 files changed, 151 insertions(+), 144 deletions(-)


