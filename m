Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F45E19DA1D
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404268AbgDCPbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 11:31:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728203AbgDCPbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 11:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585927862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oH2OHy+Eyviif1iebcrHo18si9PoFShEfkJbOhyf4JQ=;
        b=HISUh9lnLvk4QM0SD2MbZd9P4/7lWnvAaDY4Giz8iRLBdHG8jW1m1dOCrK3uuvy61oBR4g
        OtKvBw9/48HNk+PnaDpuDKfnTZ+99qqzyBZolbl477+CgZf5gYyCnwEQlBchK3ZmOgvDFj
        sY1ShPBcDUg9Xn30CChf4xOgA1WMRlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-UbVvYl2_PIi2GI5z_52vtQ-1; Fri, 03 Apr 2020 11:30:58 -0400
X-MC-Unique: UbVvYl2_PIi2GI5z_52vtQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6082C190B2A2;
        Fri,  3 Apr 2020 15:30:57 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-213.ams2.redhat.com [10.36.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AF0A26DC4;
        Fri,  3 Apr 2020 15:30:51 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 0/5] KVM: s390: vsie: fixes and cleanups
Date:   Fri,  3 Apr 2020 17:30:45 +0200
Message-Id: <20200403153050.20569-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some vsie/gmap fixes and two cleanups/improvements.

Patch #1 fixes an issue reported by Janosch. It was never observed so far=
,
because KVM usually doesn't use a region 1 table for it's guest (unless
memory would be exceeding something like 16 EB, which isn't even supporte=
d
by the HW). Older QEMU+KVM or other hypervisors can trigger this.

Patch #2 fixes a code path that probably was never taken and will most
probably not be taken very often in the future - unless somebody really
messes up the page tables for a guest (or writes a test for it). At some
point, a test case for this would be nice.

Patch #3 fixes a rare possible race. Don't think this is stable material.

Gave it some testing with my limited access to somewhat-fast s390x
machines. Booted a Linux kernel, supplying all possible number of
page table hiearchies.

v1 -> v2:
- "KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks"
-- Fix WARN_ON_ONCE
- "gmap_table_walk() simplifications"
-- Also init "table" directly

David Hildenbrand (5):
  KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
  KVM: s390: vsie: Fix delivery of addressing exceptions
  KVM: s390: vsie: Fix possible race when shadowing region 3 tables
  KVM: s390: vsie: Move conditional reschedule
  KVM: s390: vsie: gmap_table_walk() simplifications

 arch/s390/kvm/vsie.c |  4 ++--
 arch/s390/mm/gmap.c  | 17 +++++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

--=20
2.25.1

