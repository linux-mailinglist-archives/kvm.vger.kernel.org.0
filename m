Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF864059D7
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhIIPBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:01:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236425AbhIIPBH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xs2SVTgBq7Vx1ySawCfwpzsExlEbPS/kiK1uV7V/sfI=;
        b=UeNNnLU6A2wVYOQ7wXcgcMqx+Q5bBcYrDAAis2CA9jqenKxomMJHmOIwd6O9LaeTb5C/bq
        eRk+RTLvZsyga0ej6d5GMG/GESmmcc+E9F1w8Y1CEAmYCfaSzHiQz4M+PiGzcaSWSbVyRk
        axGDW3yFb46F825+o1iIjHH95kQTDNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-ItPiY0keN0C6pc0gHxBjsg-1; Thu, 09 Sep 2021 10:59:54 -0400
X-MC-Unique: ItPiY0keN0C6pc0gHxBjsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6CAD8145E7;
        Thu,  9 Sep 2021 14:59:52 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9123869FAE;
        Thu,  9 Sep 2021 14:59:46 +0000 (UTC)
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
Subject: [PATCH RFC 0/9] s390: fixes, cleanups and optimizations for page table walkers
Date:   Thu,  9 Sep 2021 16:59:36 +0200
Message-Id: <20210909145945.12192-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

