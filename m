Return-Path: <kvm+bounces-17270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CADD78C3573
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 10:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07E001C2093B
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 08:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FBF182B5;
	Sun, 12 May 2024 08:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIu4j1Ze"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116E168DA
	for <kvm@vger.kernel.org>; Sun, 12 May 2024 08:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715501707; cv=none; b=Rr5rQddK6Cg5TY5A9fYqkPs+EG91712pOHwvULEjDIHoZgWy281e7DKrs9T5mwB2ERZ8C6h6dW3rukK3rLA6QCa2Cpfkok1BGOHP2fVU4VZAcA5I14zTBFHlHBaKJLJyI1FqOO2Hmnk0ugCoPKDFasV4PF2ZjEsIrkP+nvAY/RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715501707; c=relaxed/simple;
	bh=zmyn4ldXcydGOu085bKLxBkxoeRgS7KGn+vebca4B1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lq6gMaHM97twqtx81d0djpGQdCT1jMLxbrQSHNNoSjY/+uKH9fYTejTGS/5V910yU12BSw25QeCbuMKjXxx7HAqiIpQA8rmJRLulGxmDtbKWnSUeZd2ZBR9XF94Kzk8SYitjT/d3kVvtWLd3ZUwhz67ez/LL3+LFMbtwnspLzvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DIu4j1Ze; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715501704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=meYZleFwX1lq0/EColt3Ez1OL0qo//O5LwnO/aFGWTg=;
	b=DIu4j1ZeMdJzj1CVS2wjsFrB94teFfBjNkEfHitq9AoD/7+eLQXIKjvcYAgh2pVwEorfqx
	GaMn0w2nAmVeV3dcG1VrZzmchHM/BMHbj80jY6eUNeiJKyHGZvddjpZmkfsizp0zAn6DzV
	6UL27WiZT5nTXYvPcG+K7hyD/m8uN6E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-7sa_3yHFN2yKCLApz7bdcQ-1; Sun,
 12 May 2024 04:14:59 -0400
X-MC-Unique: 7sa_3yHFN2yKCLApz7bdcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 341573801ED2;
	Sun, 12 May 2024 08:14:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 177F947B;
	Sun, 12 May 2024 08:14:59 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM change for Linux 6.9
Date: Sun, 12 May 2024 04:14:58 -0400
Message-ID: <20240512081458.4022758-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Linus,

The following changes since commit 16c20208b9c2fff73015ad4e609072feafbf81ad:

  Merge tag 'kvmarm-fixes-6.9-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-04-30 13:50:55 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-6.9

for you to fetch changes up to 0a9c28bec202bbd14ae3fd184522490e5f5498b5:

  Merge tag 'kvm-s390-master-6.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2024-05-07 13:01:39 -0400)

----------------------------------------------------------------
s390:

* Fix NULL pointer read on ioctl(KVM_CHECK_EXTENSION) for /dev/kvm.

----------------------------------------------------------------
Jean-Philippe Brucker (1):
      KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M

Paolo Bonzini (1):
      Merge tag 'kvm-s390-master-6.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


