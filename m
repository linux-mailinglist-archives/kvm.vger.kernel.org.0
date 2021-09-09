Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC8405ACA
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbhIIQZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234735AbhIIQYz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 12:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631204625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FZ2lw8Ps4o19sLYGx4L6VEw4MqECL9A7ahGOfDcjR0g=;
        b=MN0fizkQlgI74t7nbW22ascH4VLWb9ToAbDVy0ku4VGEViDcIFHPbQXmo/TirIf/Y3JUsL
        VbC/biZTi15FxAPzzyxKvdwADWTlQIj/IX5xWirvaHkBSC8WGhxX7ye7SxwqkXVOzcx+/3
        HKHYG51jsLkUgL1eRgbuMrS7J2DQJTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-2jRzvHDMMeGlCNaCTbIEsQ-1; Thu, 09 Sep 2021 12:23:41 -0400
X-MC-Unique: 2jRzvHDMMeGlCNaCTbIEsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C38F802C89;
        Thu,  9 Sep 2021 16:22:53 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED2EB18FD2;
        Thu,  9 Sep 2021 16:22:49 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Subject: [PATCH resend RFC 0/9] s390: fixes, cleanups and optimizations for page table walkers
Date:   Thu,  9 Sep 2021 18:22:39 +0200
Message-Id: <20210909162248.14969-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resend because I missed ccing people on the actual patches ...

RFC because the patches are essentially untested and I did not actually
try to trigger any of the things these patches are supposed to fix. It
merely matches my current understanding (and what other code does :) ). I
did compile-test as far as possible.

After learning more about the wonderful world of page tables and their
interaction with the mmap_sem and VMAs, I spotted some issues in our
page table walkers that allow user space to trigger nasty behavior when
playing dirty tricks with munmap() or mmap() of hugetlb. While some issues
should be hard to trigger, others are fairly easy because we provide
conventient interfaces (e.g., KVM_S390_GET_SKEYS and KVM_S390_SET_SKEYS).

Future work:
- Don't use get_locked_pte() when it's not required to actually allocate
  page tables -- similar to how storage keys are now handled. Examples are
  get_pgste() and __gmap_zap.
- Don't use get_locked_pte() and instead let page fault logic allocate page
  tables when we actually do need page tables -- also, similar to how
  storage keys are now handled. Examples are set_pgste_bits() and
  pgste_perform_essa().
- Maybe switch to mm/pagewalk.c to avoid custom page table walkers. For
  __gmap_zap() that's very easy.

Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>

David Hildenbrand (9):
  s390/gmap: validate VMA in __gmap_zap()
  s390/gmap: don't unconditionally call pte_unmap_unlock() in
    __gmap_zap()
  s390/mm: validate VMA in PGSTE manipulation functions
  s390/mm: fix VMA and page table handling code in storage key handling
    functions
  s390/uv: fully validate the VMA before calling follow_page()
  s390/pci_mmio: fully validate the VMA before calling follow_pte()
  s390/mm: no need for pte_alloc_map_lock() if we know the pmd is
    present
  s390/mm: optimize set_guest_storage_key()
  s390/mm: optimize reset_guest_reference_bit()

 arch/s390/kernel/uv.c    |   2 +-
 arch/s390/mm/gmap.c      |  11 +++-
 arch/s390/mm/pgtable.c   | 109 +++++++++++++++++++++++++++------------
 arch/s390/pci/pci_mmio.c |   4 +-
 4 files changed, 89 insertions(+), 37 deletions(-)


base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
-- 
2.31.1

