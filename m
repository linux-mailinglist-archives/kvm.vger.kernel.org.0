Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4132B4389
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbgKPMTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:19:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgKPMTx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:19:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7mt6aGqCxvZDfH2yiikjg7G5wIctdLOxkaOhYTJfOw0=;
        b=QV+8ez2Kf+B0dfXmCiYF77X5us5vtctJDu0lWB/dxQQd2esozgO7FO+UE+IZQ9K8m3OFaF
        TUgpEB/HhIThRgLxr4IOeU+xBfpkuzciMM17IuKD644tr5A/9SU+gvLMecWf3q3hCGP5a+
        B7DKp5jJFl0Ek6XHljR5XlFCvYveiaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-hCSP_0dMM4axlbHXv0GL9Q-1; Mon, 16 Nov 2020 07:19:50 -0500
X-MC-Unique: hCSP_0dMM4axlbHXv0GL9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7ACF1008550;
        Mon, 16 Nov 2020 12:19:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2071E60BF1;
        Mon, 16 Nov 2020 12:19:43 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
Date:   Mon, 16 Nov 2020 13:19:38 +0100
Message-Id: <20201116121942.55031-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series attempts to clean up demand_paging_test, dirty_log_perf_test,
and dirty_log_test by factoring out common code, creating some new API
along the way. It also splits include/perf_test_util.h into a more
conventional header and source pair.

I've tested on x86 and AArch64 (one config each), but not s390x.

v3:
 - Rebased remaining four patches from v2 onto kvm/queue
 - Picked up r-b's from Peter and Ben

v2: https://www.spinics.net/lists/kvm/msg228711.html   

Thanks,
drew


Andrew Jones (4):
  KVM: selftests: Factor out guest mode code
  KVM: selftests: dirty_log_test: Remove create_vm
  KVM: selftests: Use vm_create_with_vcpus in create_vm
  KVM: selftests: Implement perf_test_util more conventionally

 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 118 ++++--------
 .../selftests/kvm/dirty_log_perf_test.c       | 145 +++++---------
 tools/testing/selftests/kvm/dirty_log_test.c  | 179 +++++-------------
 .../selftests/kvm/include/guest_modes.h       |  21 ++
 .../testing/selftests/kvm/include/kvm_util.h  |   9 +
 .../selftests/kvm/include/perf_test_util.h    | 167 ++--------------
 tools/testing/selftests/kvm/lib/guest_modes.c |  70 +++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +-
 .../selftests/kvm/lib/perf_test_util.c        | 134 +++++++++++++
 10 files changed, 378 insertions(+), 476 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
 create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c

-- 
2.26.2

