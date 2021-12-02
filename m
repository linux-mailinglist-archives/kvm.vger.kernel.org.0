Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D464663BF
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbhLBMjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 07:39:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346987AbhLBMjY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 07:39:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638448562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0mpOHYk8lkbksLNFuRRAbGk8/LJIx0YcL1usNRII56E=;
        b=JUD5VcmpQAENpMSPjxX2TqpuVJSYfiHAQTRmxVKfFB2WraraPJVSQFkMuwa+bK3qvjuQT1
        2IzbYGuTW6k4OJz1a0LxN1i7o69hlqxOXarfK2xVO/4UZJZ3o/r5E4xYWN0kQ6/WgAohQ5
        8H9jFpkNUJfJZfYECZBmAG9ar1xzgMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-wbjN7ks8OCCfptX0Lbb9dA-1; Thu, 02 Dec 2021 07:36:01 -0500
X-MC-Unique: wbjN7ks8OCCfptX0Lbb9dA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B20A3192FDA0;
        Thu,  2 Dec 2021 12:35:59 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FA881017CF1;
        Thu,  2 Dec 2021 12:35:54 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: firq: floating interrupt test
Date:   Thu,  2 Dec 2021 13:35:51 +0100
Message-Id: <20211202123553.96412-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From patch #2:

"
We had a KVM BUG fixed by kernel commit a3e03bc1368c ("KVM: s390: index
kvm->arch.idle_mask by vcpu_idx"), whereby a floating interrupt might get
stuck forever because a CPU in the wait state would not get woken up.

The issue can be triggered when CPUs are created in a nonlinear fashion,
such that the CPU address ("core-id") and the KVM cpu id don't match.

So let's start with a floating interrupt test that will trigger a
floating interrupt (via SCLP) to be delivered to a CPU in the wait state.
"

v1 -> v2:
- Remove flag logic
- Extend comments
- Minor cleanups
- sclp_clear_busy() before printing to the SCLP console

David Hildenbrand (2):
  s390x: make smp_cpu_setup() return 0 on success
  s390x: firq: floating interrupt test

 lib/s390x/sclp.c    |  11 ++--
 lib/s390x/sclp.h    |   1 +
 lib/s390x/smp.c     |   1 +
 s390x/Makefile      |   1 +
 s390x/firq.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  10 ++++
 6 files changed, 143 insertions(+), 3 deletions(-)
 create mode 100644 s390x/firq.c

-- 
2.31.1

