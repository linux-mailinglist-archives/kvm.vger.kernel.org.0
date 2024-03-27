Return-Path: <kvm+bounces-12888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E07A688EC5B
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 951B829F59D
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42AE14E2CB;
	Wed, 27 Mar 2024 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/MN+tdN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772ED13B59C
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559875; cv=none; b=TApyWMrX6DluX6pR+wSywDI8FOiTQl8IPvMdZHjIP9hNJYfDk4DGOF4DrBF3llpAYSizqQ7gcV63sw0ggWLPB+jiVE3mlgNK9ZXtEWyxcRfPh1DKbwYwDBut28T55kH9Lvpf16vPX7abmJV8VGT0Tua62hCa+Mca5KRl9YlX8Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559875; c=relaxed/simple;
	bh=EdfLc/3/vb1dGCMhQldF+qYp0nlkvEKp1oqt7MkvxwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WioNcqP3R8OIAFkxbxkrmXYdpwzsEQhm67KjxBAyorPEeTvbTtJXGU2pP/CDGDFwk32dKHvqaNePmQTdNsrgJ8SgzZfFkp5cAwSrzcvkYVy6QKaDXRqMiAjTRUSfXXbE2r588H+WcCN8jIQ5huqvZ3SEKxBR7ytQZ3NU0GHW24o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B/MN+tdN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711559872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gs7mz2T2Nzxhsdo7I/ZcfY9h1l0ujt1Yaj1fAdyaXDw=;
	b=B/MN+tdNGSzyoKJrLg3sKfcmxbx7/f/MD/0EKPLVndAZ1XeGmqTGLn22YOe7ATW3uQsEHw
	AE3eo5SNSeTHGV1wYvCMdvebHtxcWmUwhDDEHOSGmVoNRN2Xh/ChMCIxtFwORkG6pH2fKy
	X3keH86E6Z92LO+LjHGljBPAO67sik8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-ENn_kGGANHuMOOroM-8g4Q-1; Wed, 27 Mar 2024 13:17:49 -0400
X-MC-Unique: ENn_kGGANHuMOOroM-8g4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A686101A526;
	Wed, 27 Mar 2024 17:17:48 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.208])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EC5A1121312;
	Wed, 27 Mar 2024 17:17:43 +0000 (UTC)
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
Subject: [PATCH v2 0/2] s390/mm: shared zeropage + KVM fixes
Date: Wed, 27 Mar 2024 18:17:35 +0100
Message-ID: <20240327171737.919590-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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

Based on Linus master. Andrew agreed that both patches can go via the
s390x tree.

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
 arch/s390/include/asm/pgtable.h     |  15 ++-
 arch/s390/kvm/kvm-s390.c            |   4 +-
 arch/s390/mm/gmap.c                 | 163 +++++++++++++++++++++-------
 mm/userfaultfd.c                    |  34 ++++++
 7 files changed, 177 insertions(+), 47 deletions(-)

-- 
2.43.2


