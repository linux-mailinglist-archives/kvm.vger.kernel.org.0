Return-Path: <kvm+bounces-14272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F7508A1C47
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25E04284676
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9AE25575;
	Thu, 11 Apr 2024 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Is1qWto3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD5215D5C5
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712852098; cv=none; b=do0o3XxW/z9Pu0DIvx0c5AW+3cybyVqAeKrVpCpZO0+iGxNFNqiqg5Kf1eTf5qpQpJOkPNKWynIwfsrUwNoE/8bwhJgnFbJ5tocv23/9keD6XCz9jtZbfcCd+qyYey1HgHL9UlfKyCRxgnE6MnU7Cqn/ApsHVfB+7JpASgLs6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712852098; c=relaxed/simple;
	bh=bIGD7TEXYxMqNuHPxtOApDGnJHOvQ/kaNLS9oW0lEDg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DKL2w4xfedQKexhDzRoe+FGymwHQq0kdZyXiPF+4ruZXyBGobzOvm3pmgECrVGrfN5xP1kCWj0TvB7K9kB2QX0lWPN6SbabyJ+kfNnATpbyPQQ4kOSJGQA00kmSudY3qQjWrq1fYTunenRqHSf6LDAD61ezT37gpcOJNlIwkFQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Is1qWto3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712852096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZhbzH0ImR3r/1f0GcYB335mQQPuC0QvnUY34Zu4C8Ic=;
	b=Is1qWto3K3gtYPGh0EJ4HBsn6+/+WUpF1AIQZCzfF5eyAvmwqv9khhIUmdASm8+SDOJQMe
	PwxbXEp9vCjOYOO3lesXkqWMwYotYH+XVnJ/tjoRU6pAYc4ySwVJuY/RVSGHPdSPb+TZI8
	OfbLNhMLKI4W6ORrnkYPeSgdbca3poM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-0jne7cuaOEKLOPpDSddeiQ-1; Thu, 11 Apr 2024 12:14:51 -0400
X-MC-Unique: 0jne7cuaOEKLOPpDSddeiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30A7088E861;
	Thu, 11 Apr 2024 16:14:50 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.194.173])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2D60E10E4B;
	Thu, 11 Apr 2024 16:14:45 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH v3 0/2] s390/mm: shared zeropage + KVM fixes
Date: Thu, 11 Apr 2024 18:14:39 +0200
Message-ID: <20240411161441.910170-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

This series fixes one issue with uffd + shared zeropages on s390x and
fixes that "ordinary" KVM guests can make use of shared zeropages again.

userfaultfd could currently end up mapping shared zeropages into processes
that forbid shared zeropages. This only apples to s390x, relevant for
handling PV guests and guests that use storage kets correctly. Fix it
by placing a zeroed folio instead of the shared zeropage during
UFFDIO_ZEROPAGE instead.

I stumbled over this issue while looking into a customer scenario that
is using:

(1) Memory ballooning for dynamic resizing. Start a VM with, say, 100 GiB
    and inflate the balloon during boot to 60 GiB. The VM has ~40 GiB
    available and additional memory can be "fake hotplugged" to the VM
    later on demand by deflating the balloon. Actual memory overcommit is
    not desired, so physical memory would only be moved between VMs.

(2) Live migration of VMs between sites to evacuate servers in case of
    emergency.

Without the shared zeropage, during (2), the VM would suddenly consume
100 GiB on the migration source and destination. On the migration source,
where we don't excpect memory overcommit, we could easilt end up crashing
the VM during migration.

Independent of that, memory handed back to the hypervisor using "free page
reporting" would end up consuming actual memory after the migration on the
destination, not getting freed up until reused+freed again.

While there might be ways to optimize parts of this in QEMU, we really
should just support the shared zeropage again for ordinary VMs.

We only expect legcy guests to make use of storage keys, so let's handle
zeropages again when enabling storage keys or when enabling PV. To not
break userfaultfd like we did in the past, don't zap the shared zeropages,
but instead trigger unsharing faults, just like we do for unsharing
KSM pages in break_ksm().

Unsharing faults will simply replace the shared zeropage by a zeroed
anonymous folio. We can already trigger the same fault path using GUP,
when trying to long-term pin a shared zeropage, but also when unmerging
a KSM-placed zeropages, so this is nothing new.

Patch #1 tested on 86-64 by forcing mm_forbids_zeropage() to be 1, and
running the uffd selftests.

Patch #2 tested on s390x: the live migration scenario now works as
expected, and kvm-unit-tests that trigger usage of skeys work well, whereby
I can see detection and unsharing of shared zeropages.

Further (as broken in v2), I tested that the shared zeropage is no
longer populated after skeys are used -- that mm_forbids_zeropage() works
as expected:
  ./s390x-run s390x/skey.elf \
   -no-shutdown \
   -chardev socket,id=monitor,path=/var/tmp/mon,server,nowait \
   -mon chardev=monitor,mode=readline

  Then, in another shell:

  # cat /proc/`pgrep qemu`/smaps_rollup | grep Rss
  Rss:               31484 kB
  #  echo "dump-guest-memory tmp" | sudo nc -U /var/tmp/mon
  ...
  # cat /proc/`pgrep qemu`/smaps_rollup | grep Rss
  Rss:              160452 kB

  -> Reading guest memory does not populate the shared zeropage

  Doing the same with selftest.elf (no skeys)

  # cat /proc/`pgrep qemu`/smaps_rollup | grep Rss
  Rss:               30900 kB
  #  echo "dump-guest-memory tmp" | sudo nc -U /var/tmp/mon
  ...
  # cat /proc/`pgrep qemu`/smaps_rollup | grep Rsstmp/mon
  Rss:               30924 kB

  -> Reading guest memory does populate the shared zeropage

Based on s390/features. Andrew agreed that both patches can go via the
s390x tree.

v2 -> v3:
* "mm/userfaultfd: don't place zeropages when zeropages are disallowed"
 -> Fix wrong mm_forbids_zeropage check
* "s390/mm: re-enable the shared zeropage for !PV and !skeys KVM guests"
 -> Fix wrong mm_forbids_zeropage define

v1 -> v2:
* "mm/userfaultfd: don't place zeropages when zeropages are disallowed"
 -> Minor "ret" ahndling tweaks
* "s390/mm: re-enable the shared zeropage for !PV and !skeys KVM guests"
 -> Added Fixes: tag

Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org


David Hildenbrand (2):
  mm/userfaultfd: don't place zeropages when zeropages are disallowed
  s390/mm: re-enable the shared zeropage for !PV and !skeys KVM guests

 arch/s390/include/asm/gmap.h        |   2 +-
 arch/s390/include/asm/mmu.h         |   5 +
 arch/s390/include/asm/mmu_context.h |   1 +
 arch/s390/include/asm/pgtable.h     |  16 ++-
 arch/s390/kvm/kvm-s390.c            |   4 +-
 arch/s390/mm/gmap.c                 | 163 +++++++++++++++++++++-------
 mm/userfaultfd.c                    |  34 ++++++
 7 files changed, 178 insertions(+), 47 deletions(-)

-- 
2.44.0


