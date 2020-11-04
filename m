Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691BE2A6F8F
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731945AbgKDVYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729828AbgKDVYJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CtHJUodkPPfSp3arc0rIE1/C6vgxP55R/RVEpoV7kdc=;
        b=e8+D35su0Ny7kAe/bs1g81mvgcWV0tz//GcgU/OPpDdwJwg/qpcXB5XLZB0TCqCiGncsWf
        5cccmSATKemGLMXB4YqFD9cFQbmDhtUUgJTWbU/Og7PyjokMtcISiclaPpv7z20PjTreXl
        350Z+MpMrAuRBV399P+XCJPAiFYs6g8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-dIEsXAIdMciSChjPFGPYCg-1; Wed, 04 Nov 2020 16:24:04 -0500
X-MC-Unique: dIEsXAIdMciSChjPFGPYCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78994184214C;
        Wed,  4 Nov 2020 21:24:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F0A65DA33;
        Wed,  4 Nov 2020 21:23:58 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 00/11] KVM: selftests: Cleanups
Date:   Wed,  4 Nov 2020 22:23:46 +0100
Message-Id: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series attempts to clean up demand_paging_test and dirty_log_test
by factoring out common code, creating some new API along the way. It's
main goal is to prepare for even more factoring that Ben and Peter want
to do. The series would have a nice negative diff stat, but it also
picks up a few of Peter's patches for his new dirty log test. So, the
+/- diff stat is close to equal. It's not as close as an electoral vote
count, but it's close.

I've tested on x86 and AArch64 (one config each), but not s390x.

Thanks,
drew


Andrew Jones (8):
  KVM: selftests: Add x86_64/tsc_msrs_test to .gitignore
  KVM: selftests: Drop pointless vm_create wrapper
  KVM: selftests: Make the per vcpu memory size global
  KVM: selftests: Make the number of vcpus global
  KVM: selftests: Factor out guest mode code
  KVM: selftests: Make vm_create_default common
  KVM: selftests: Introduce vm_create_[default_]vcpus
  KVM: selftests: Remove create_vm

Peter Xu (3):
  KVM: selftests: Always clear dirty bitmap after iteration
  KVM: selftests: Use a single binary for dirty/clear log test
  KVM: selftests: Introduce after_vcpu_run hook for dirty log test

 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   4 +-
 .../selftests/kvm/clear_dirty_log_test.c      |   6 -
 .../selftests/kvm/demand_paging_test.c        | 213 +++-------
 tools/testing/selftests/kvm/dirty_log_test.c  | 372 ++++++++++--------
 .../selftests/kvm/include/aarch64/processor.h |   3 +
 .../selftests/kvm/include/guest_modes.h       |  21 +
 .../testing/selftests/kvm/include/kvm_util.h  |  20 +-
 .../selftests/kvm/include/s390x/processor.h   |   4 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 .../selftests/kvm/lib/aarch64/processor.c     |  17 -
 tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  62 ++-
 .../selftests/kvm/lib/s390x/processor.c       |  22 --
 .../selftests/kvm/lib/x86_64/processor.c      |  32 --
 15 files changed, 445 insertions(+), 407 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c
 create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c

-- 
2.26.2

