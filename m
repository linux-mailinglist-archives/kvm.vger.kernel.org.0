Return-Path: <kvm+bounces-21039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F98928423
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 10:51:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A310728297A
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 08:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65694146015;
	Fri,  5 Jul 2024 08:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3zFrglX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3E0143887
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 08:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720169489; cv=none; b=nQZC5XSLtUFo89t0ZzaLdbiEl+BixsbY8P9zkGnQ4qjyiFdBJXsqDekOAFxfbU8pVvcHLf3qsmhQ1f/B/ikE/RPGXZdDwQ1TnPlbJVJMxjR/j3NktyA0Sl0hGhK9d35/qABMUm2uyLz2Uy/nrWsgPhhOd6nZdN/U71kkjCkhojc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720169489; c=relaxed/simple;
	bh=yCAsEHezoCR+kKRNTiPiuuofe/EEkQpu1kEAAD/EnZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AMKe/+cQOpDQYiVR+54n2+UyYnOhPFxyb1suQREHgAl6Nyv1rDTV9sLXBb/SqF47nwwLHbcoNe0m0QJFzFuYAcEcz23UB6vSQ4BlqWLebkWGM/tJzxD/ifIx/iZCRaU/x3a33NUll7N2DxvmbCsyGnpwm6ct01CHWZy9oA44spk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3zFrglX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720169486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2ZIuI/3g9f5a9v+/n87fy4Ud7Wmid1oVycdbOhxwppk=;
	b=I3zFrglX8SDZoUeqajm0iMDEcDyq1xtrzrtFRXcgzF9H8TZvST9AxMMjcEYRcIV/Occg8+
	42NAP4M5Iljuwioql0lZz+eXVp0nbBjlxyC9qEcdyTsZCBjx87Qr1GiZ8ufn+mDYvTl9C0
	pJ1220LO2htaOMuklCvQ1K33sMqxraY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-fcvxVuZoOsmA2XlaFqzf3g-1; Fri,
 05 Jul 2024 04:51:23 -0400
X-MC-Unique: fcvxVuZoOsmA2XlaFqzf3g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BE5B195608F;
	Fri,  5 Jul 2024 08:51:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.eng.rdu2.dc.redhat.com [10.6.68.74])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E9F81955F65;
	Fri,  5 Jul 2024 08:51:21 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.10-rc7
Date: Fri,  5 Jul 2024 04:51:20 -0400
Message-ID: <20240705085120.659090-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Linus,

The following changes since commit 22a40d14b572deb80c0648557f4bd502d7e83826:

  Linux 6.10-rc6 (2024-06-30 14:40:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 8ad209fc6448e1d7fff7525a8d40d2fb549f72d1:

  Merge tag 'kvm-s390-master-6.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2024-07-05 04:45:53 -0400)

Things have definitely calmed down. :)

Thanks,

Paolo

----------------------------------------------------------------
s390: fix support for z16 systems.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: fix LPSWEY handling

Paolo Bonzini (1):
      Merge tag 'kvm-s390-master-6.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
 arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+)


