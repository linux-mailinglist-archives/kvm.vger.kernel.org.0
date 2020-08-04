Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69323BE9B
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgHDRIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:08:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29339 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729305AbgHDRIX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Aug 2020 13:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596560902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ursdoHm0tMH2wXUeTBLWm59Mni6170SDHwjwgqHwT+o=;
        b=fREyw3tqR5I+Gw55wTs3dsCson+0OGrAXZ+t4inTxO/HhAwG0HQZSrnhfsUiXqHZbDqHRi
        /4fd0AGkbuHPg8oB9Dwfa5BbtjHi6/Jxp9Qur19i7BJZ6ZDzm6FzPcfETIqjVH0/LFD1GX
        pfMWniAgjpQkDLM1inLgAu4WKDdehdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-2ZsODA-iONy5CZ-XCCUzcA-1; Tue, 04 Aug 2020 13:06:08 -0400
X-MC-Unique: 2ZsODA-iONy5CZ-XCCUzcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8115B106B242;
        Tue,  4 Aug 2020 17:06:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 896CC72E48;
        Tue,  4 Aug 2020 17:06:05 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, steven.price@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 0/6] KVM: arm64: pvtime: Fixes and a new cap
Date:   Tue,  4 Aug 2020 19:05:58 +0200
Message-Id: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
  - ARM_SMCCC_HV_PV_TIME_FEATURES now also returns SMCCC_RET_NOT_SUPPORTED
    when steal time is not supported
  - Added READ_ONCE() for the run_delay read
  - Reworked kvm_put/get_guest to not require type as a parameter
  - Added some more text to the documentation for KVM_CAP_STEAL_TIME
  - Enough changed that I didn't pick up Steven's r-b's


The first four patches in the series are fixes that come from testing
and reviewing pvtime code while writing the QEMU support[*]. The last
patch is only a convenience for userspace, and I wouldn't be heartbroken
if it wasn't deemed worth it. The QEMU patches are currently written
without the cap. However, if the cap is accepted, then I'll change the
QEMU code to use it.

Thanks,
drew

[*] https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg03856.html
    (a v2 of this series will also be posted shortly)

Andrew Jones (6):
  KVM: arm64: pvtime: steal-time is only supported when configured
  KVM: arm64: pvtime: Fix potential loss of stolen time
  KVM: arm64: Drop type input from kvm_put_guest
  KVM: arm64: pvtime: Fix stolen time accounting across migration
  KVM: Documentation: Minor fixups
  arm64/x86: KVM: Introduce steal-time cap

 Documentation/virt/kvm/api.rst    | 22 ++++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           | 29 +++++++++++++----------------
 arch/x86/kvm/x86.c                |  3 +++
 include/linux/kvm_host.h          | 31 ++++++++++++++++++++++++++-----
 include/uapi/linux/kvm.h          |  1 +
 7 files changed, 65 insertions(+), 26 deletions(-)

-- 
2.25.4

