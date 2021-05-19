Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE60388FE0
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 16:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353874AbhESOIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 10:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353848AbhESOIw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 10:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621433252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w6Ik3ix00seen7f0ACeVszG5V6/4OpjDNwj8RlI2yS0=;
        b=DYzzXSY/0ivsrY71xJGQc3i51sSTOk3RWV/piOgUJACnTlXQlieBTbpMJCyuuU2ob+hEwh
        AbsLoHNQzbLQZl51BZ1f4FCGN+GVrr32bNWDVY5nHPJAB4auySmlQQf45L/AEhxwiMAYfA
        fE9mD4bIC9N4ZBZfmhjRrJQCy4zFIc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-CPE_d8ZRPu6BV6ilekZGDg-1; Wed, 19 May 2021 10:07:30 -0400
X-MC-Unique: CPE_d8ZRPu6BV6ilekZGDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 479B0180FD68;
        Wed, 19 May 2021 14:07:29 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 350C710013C1;
        Wed, 19 May 2021 14:07:27 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 0/5] KVM: arm64: selftests: Fix get-reg-list
Date:   Wed, 19 May 2021 16:07:21 +0200
Message-Id: <20210519140726.892632-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
 - Removed some cruft left over from a previous more complex design of the
   config command line parser
 - Dropped the list printing factor out patch as it's not necessary
 - Added a 'PASS' output for passing tests to allow testers to feel good
 - Changed the "up to date with kernel" comment to reference 5.13.0-rc2


Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
userspace when not available") the get-reg-list* tests have been
failing with

  ...
  ... There are 74 missing registers.
  The following lines are missing registers:
  ...

where the 74 missing registers are all PMU registers. This isn't a
bug in KVM that the selftest found, even though it's true that a
KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
flag, but still expecting the PMU registers to be in the reg-list,
would suddenly no longer have their expectations met. In that case,
the expectations were wrong, though, so that KVM userspace needs to
be fixed, and so does this selftest.

We could fix the test with a one-liner since we just need a

  init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;

in prepare_vcpu_init(), but that's too easy, so here's a 5 patch patch
series instead :-)  The reason for all the patches and the heavy diffstat
is to prepare for other vcpu configuration testing, e.g. ptrauth and mte.
With the refactoring done in this series, we should now be able to easily
add register sublists and vcpu configs to the get-reg-list test, as the
last patch demonstrates with the pmu fix.

Thanks,
drew


Andrew Jones (5):
  KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
  KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs
    at once
  KVM: arm64: selftests: get-reg-list: Provide config selection option
  KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
  KVM: arm64: selftests: get-reg-list: Split base and pmu registers

 tools/testing/selftests/kvm/.gitignore        |   1 -
 tools/testing/selftests/kvm/Makefile          |   1 -
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 -
 .../selftests/kvm/aarch64/get-reg-list.c      | 388 ++++++++++++------
 4 files changed, 271 insertions(+), 122 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c

-- 
2.30.2

