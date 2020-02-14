Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE4E15DA0A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgBNO7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729475AbgBNO7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q8mBykA1ZCQGjZjERbWNXzyTekBEukYGYJt2eGuJVbA=;
        b=JAGZr0xTnxx3sFEBYNXUfvqQXDlgSpgLjZ1cdyysrxtBm6FRBSb9kwyrFjDMm7B2r1s2RS
        noDNcxD+IliPlR7bX/oOGMUIeP9BZVkDp1EprvlHN6C5x8JrsMVeudC5kzkKAeObzALAVV
        yhoO5/6I1TPpPun3GCPu+kS1odqmisI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-LK8OgRnePEKLOmp8raSWaw-1; Fri, 14 Feb 2020 09:59:27 -0500
X-MC-Unique: LK8OgRnePEKLOmp8raSWaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24D81A0CBF;
        Fri, 14 Feb 2020 14:59:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECDA419E9C;
        Fri, 14 Feb 2020 14:59:21 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 00/13] KVM: selftests: Various fixes and cleanups
Date:   Fri, 14 Feb 2020 15:59:07 +0100
Message-Id: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series has several parts:

 * First, a hack to get x86 to compile. The missing __NR_userfaultfd
   define should be fixed a better way.

 * Then, fixups for several commits in kvm/queue. These fixups correspond
   to review comments that didn't have a chance to get addressed before
   the commits were applied.

 * Next, a few unnecessary #define/#ifdef deletions.

 * Then, a rework of debug and info message printing.

 * Finally, an addition to the API, num-pages conversion utilities,
   which cleans up all the num-pages calculations.


Andrew Jones (13):
  HACK: Ensure __NR_userfaultfd is defined
  fixup! KVM: selftests: Add support for vcpu_args_set to aarch64 and
    s390x
  fixup! KVM: selftests: Support multiple vCPUs in demand paging test
  fixup! KVM: selftests: Add memory size parameter to the demand paging
    test
  fixup! KVM: selftests: Time guest demand paging
  KVM: selftests: Remove unnecessary defines
  KVM: selftests: aarch64: Remove unnecessary ifdefs
  KVM: selftests: aarch64: Use stream when given
  KVM: selftests: Rework debug message printing
  KVM: selftests: Convert some printf's to pr_info's
  KVM: selftests: Rename vm_guest_mode_params
  KVM: selftests: Introduce vm_guest_mode_params
  KVM: selftests: Introduce num-pages conversion utilities

 .../selftests/kvm/demand_paging_test.c        | 148 ++++++++----------
 tools/testing/selftests/kvm/dirty_log_test.c  |  78 +++++----
 .../testing/selftests/kvm/include/kvm_util.h  |  14 +-
 .../testing/selftests/kvm/include/test_util.h |  18 +++
 .../selftests/kvm/kvm_create_max_vcpus.c      |   8 +-
 .../selftests/kvm/lib/aarch64/processor.c     |  30 +---
 tools/testing/selftests/kvm/lib/kvm_util.c    |  89 +++++++----
 .../selftests/kvm/lib/kvm_util_internal.h     |  11 --
 tools/testing/selftests/kvm/lib/test_util.c   |  90 ++++++-----
 tools/testing/selftests/kvm/s390x/resets.c    |   6 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c  |   2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   2 +-
 .../testing/selftests/kvm/x86_64/state_test.c |   2 +-
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   4 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |   2 +-
 15 files changed, 258 insertions(+), 246 deletions(-)

--=20
2.21.1

