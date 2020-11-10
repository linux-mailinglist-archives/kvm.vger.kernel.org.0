Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7052AE0F7
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 21:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgKJUsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 15:48:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgKJUsN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 15:48:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605041292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yD3ERpKzQDHedcF9/ZJkd6ntCshIVv0hhLeGQJV6/wY=;
        b=cd4kUI1dlARe3wIz5VFYmGdsbfLxkGDf71kD+wVY2eOnhVEEDN8Uh5nA7fYomMvSAVD1Rb
        73wXUygxn5Cei38INtQ2R61gIXoE3WDbY0cdfqaHnt+CWogmNc1EHLjcsOa+R9/oAmOWV8
        yfupPSVXIicujgLejeC8rgQxNZftM4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-JNHkX94HMd-txTqm1rwpxA-1; Tue, 10 Nov 2020 15:48:10 -0500
X-MC-Unique: JNHkX94HMd-txTqm1rwpxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A73CA87951F;
        Tue, 10 Nov 2020 20:48:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B82910016DA;
        Tue, 10 Nov 2020 20:48:04 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 0/8] KVM: selftests: Cleanups, take 2
Date:   Tue, 10 Nov 2020 21:47:54 +0100
Message-Id: <20201110204802.417521-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series attempts to clean up demand_paging_test, dirty_log_perf_test,
and dirty_log_test by factoring out common code, creating some new API
along the way.  It also splits include/perf_test_util.h into a more
conventional header and source pair. There's still some stuff I don't
like, for example the unbalanced ucall_uninit we now get for tests using
the perf_test API, but I'll maybe revisit that stuff again some other day.

I've tested on x86 and AArch64 (one config each), but not s390x.

Thanks,
drew


Andrew Jones (8):
  KVM: selftests: Update .gitignore
  KVM: selftests: Remove deadcode
  KVM: selftests: Factor out guest mode code
  KVM: selftests: Make vm_create_default common
  KVM: selftests: Introduce vm_create_[default_]_with_vcpus
  KVM: selftests: dirty_log_test: Remove create_vm
  KVM: selftests: Use vm_create_with_vcpus in create_vm
  KVM: selftests: Implement perf_test_util more conventionally

 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 115 +++--------
 .../selftests/kvm/dirty_log_perf_test.c       | 174 ++++-------------
 tools/testing/selftests/kvm/dirty_log_test.c  | 179 +++++-------------
 .../selftests/kvm/include/guest_modes.h       |  21 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  42 +++-
 .../selftests/kvm/include/perf_test_util.h    | 170 +----------------
 .../selftests/kvm/lib/aarch64/processor.c     |  17 --
 tools/testing/selftests/kvm/lib/guest_modes.c |  70 +++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  60 +++++-
 .../selftests/kvm/lib/perf_test_util.c        | 134 +++++++++++++
 .../selftests/kvm/lib/s390x/processor.c       |  22 ---
 .../selftests/kvm/lib/x86_64/processor.c      |  32 ----
 14 files changed, 451 insertions(+), 589 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
 create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c

-- 
2.26.2

