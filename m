Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172C819C909
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbgDBSs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:48:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45895 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732214AbgDBSs3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 14:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585853308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=in1JW2F7wVAjQuehuFAsT9rFLhWovQC510FWxPd6gOY=;
        b=O1td6uofzPDkkf8DBUfSMRG6TqLjXt4ED6F5Zj5J+V+BQn2ytmedCQZ+qeV7bhdgHU86Gg
        uoROf294H8qj0IfGr9UDOKtScC2lGLweQQeETBoQIe9gPPnJEck54j7R50WueEawPlU9ti
        PtriJx2um3O/hEhRYzwFLl/wHDIrF2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-U1l9J9PpNNeAqadNNHj6-Q-1; Thu, 02 Apr 2020 14:48:26 -0400
X-MC-Unique: U1l9J9PpNNeAqadNNHj6-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD031926DA0;
        Thu,  2 Apr 2020 18:48:25 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-29.ams2.redhat.com [10.36.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90D1E60BF4;
        Thu,  2 Apr 2020 18:48:20 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 0/5] KVM: s390: vsie: fixes and cleanups.
Date:   Thu,  2 Apr 2020 20:48:14 +0200
Message-Id: <20200402184819.34215-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

David Hildenbrand (5):
  KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
  KVM: s390: vsie: Fix delivery of addressing exceptions
  KVM: s390: vsie: Fix possible race when shadowing region 3 tables
  KVM: s390: vsie: Move conditional reschedule
  KVM: s390: vsie: gmap_table_walk() simplifications

 arch/s390/kvm/vsie.c |  4 ++--
 arch/s390/mm/gmap.c  | 14 ++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

--=20
2.25.1

