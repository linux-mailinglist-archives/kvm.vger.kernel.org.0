Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD54376AF6
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhEGUFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:05:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229905AbhEGUF1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620417867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UIav5HVsnw8DaGW40BBfIS/nkjpuzktpcWTdxzNgE2Q=;
        b=DHrTMGwVdNzkTDwX9mTmrYqYCkbw4ZKfz8Ot1/GXXCCvrQrbGdKYshSCXxoo1yw2tksCSM
        +RIv3EFcCGDj3r7839eH4ZWgW1ZabTB7ICv9fAkhxk3wT1qTvynRc6MA2iuv/A3hyWRl35
        Yil37u5/LhXBtpu2tmNZlmm/wXfJpnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-EJE1MZTGO6uU2r0tF88VGg-1; Fri, 07 May 2021 16:04:26 -0400
X-MC-Unique: EJE1MZTGO6uU2r0tF88VGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BD371854E21;
        Fri,  7 May 2021 20:04:24 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB40119D61;
        Fri,  7 May 2021 20:04:17 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH 0/6]  KVM: arm64: selftests: Fix get-reg-list
Date:   Fri,  7 May 2021 22:04:10 +0200
Message-Id: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

in prepare_vcpu_init(), but that's too easy, so here's a 6 patch patch
series instead :-)  The reason for all the patches and the heavy diffstat
is to prepare for other vcpu configuration testing, e.g. ptrauth and mte.
With the refactoring done in this series, we should now be able to easily
add register sublists and vcpu configs to the get-reg-list test, as the
last patch demonstrates with the pmu fix.

Thanks,
drew


Andrew Jones (6):
  KVM: arm64: selftests: get-reg-list: Factor out printing
  KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
  KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs
    at once
  KVM: arm64: selftests: get-reg-list: Provide config selection option
  KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
  KVM: arm64: selftests: get-reg-list: Split base and pmu registers

 tools/testing/selftests/kvm/.gitignore        |   1 -
 tools/testing/selftests/kvm/Makefile          |   1 -
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 -
 .../selftests/kvm/aarch64/get-reg-list.c      | 442 +++++++++++++-----
 4 files changed, 313 insertions(+), 134 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c

-- 
2.30.2

