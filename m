Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31E52DE3D2
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 15:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgLROTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 09:19:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbgLROTK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 09:19:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608301064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CmkwoaE0VgaOpvq0Fe5n9FUGHZ4XeJSYkI4GajNOFiY=;
        b=J+YPLyJK/e5XoAvF134yugWgFwVXIlAwWMKwGnpHiJQ53s/MSl8Pd1i+TL+cVgiZviQWcC
        8anNjRF2fIa4mgArUrnWK1K/B63nuqNnGy9b/bq8GHE6DLYYJySOgOrQDd76zrL06dUDTc
        AAtvuDCBUDHoNqzPBpvuseYJ9/wwP2g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-cfQbNb2ZML-NFCj6p709MQ-1; Fri, 18 Dec 2020 09:17:42 -0500
X-MC-Unique: cfQbNb2ZML-NFCj6p709MQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C19B8190A7A0;
        Fri, 18 Dec 2020 14:17:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B80A22CFB1;
        Fri, 18 Dec 2020 14:17:35 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v4 0/3] KVM: selftests: Cleanups, take 2
Date:   Fri, 18 Dec 2020 15:17:31 +0100
Message-Id: <20201218141734.54359-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series attempts to clean up demand_paging_test, dirty_log_perf_test,
and dirty_log_test by factoring out common code, creating some new API
along the way. It also splits include/perf_test_util.h into a more
conventional header and source pair.

I've tested on x86 and AArch64 (one config each), but not s390x.

v4:
 - dropped "KVM: selftests: dirty_log_test: Remove create_vm" patch
 - Rebased on latest kvm/queue (patches applied cleanly)
 - Ensured dirty-ring was enabled on x86 when testing

v3:
 - Rebased remaining four patches from v2 onto kvm/queue
 - Picked up r-b's from Peter and Ben

v2: https://www.spinics.net/lists/kvm/msg228711.html   

Thanks,
drew


Andrew Jones (3):
  KVM: selftests: Factor out guest mode code
  KVM: selftests: Use vm_create_with_vcpus in create_vm
  KVM: selftests: Implement perf_test_util more conventionally

 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 118 ++++---------
 .../selftests/kvm/dirty_log_perf_test.c       | 145 +++++----------
 tools/testing/selftests/kvm/dirty_log_test.c  | 125 ++++---------
 .../selftests/kvm/include/guest_modes.h       |  21 +++
 .../testing/selftests/kvm/include/kvm_util.h  |   9 +
 .../selftests/kvm/include/perf_test_util.h    | 167 ++----------------
 tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   9 +-
 .../selftests/kvm/lib/perf_test_util.c        | 134 ++++++++++++++
 10 files changed, 363 insertions(+), 437 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
 create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
 create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c

-- 
2.26.2

