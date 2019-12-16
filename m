Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A08121B18
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 21:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfLPUsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 15:48:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22523 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727324AbfLPUsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 15:48:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576529290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+Fxv/08Xa0VbcqCSvsm0VgrWIKaPNFsllFhCVnw+YLI=;
        b=LAd5XuBoJG0V96QCFCi97ZHg6Um/NTWIVOwNmbZsNWJYj9CS5SRsy0QJ4C2c8+6F8KsA5i
        bgSKhLmDBYUWs0butAIbkl/0etKQEfBclrTfksfWcYk/WdHJ5oIT3i6nalIQecBMCnjgnx
        HU371tiYwqi51uy+o4iVYWUXhXD1N9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-_3L8DJ-vNPWrTcGnvlpMrw-1; Mon, 16 Dec 2019 15:48:09 -0500
X-MC-Unique: _3L8DJ-vNPWrTcGnvlpMrw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B4708D811D;
        Mon, 16 Dec 2019 20:48:07 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C11B5D9C9;
        Mon, 16 Dec 2019 20:48:01 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 00/10] KVM: arm64: PMUv3 Event Counter Tests
Date:   Mon, 16 Dec 2019 21:47:47 +0100
Message-Id: <20191216204757.4020-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements tests exercising the PMUv3 event counters.
It tests both the 32-bit and 64-bit versions. Overflow interrupts
also are checked. Those tests only are written for arm64.

It allowed to reveal some issues related to SW_INCR implementation
(esp. related to 64-bit implementation), some problems related to
32-bit <-> 64-bit transitions and consistency of enabled states
of odd and event counters.

Overflow interrupt testing relies of one patch from Andre
("arm: gic: Provide per-IRQ helper functions") to enable the
PPI 23, coming from "arm: gic: Test SPIs and interrupt groups"
(https://patchwork.kernel.org/cover/11234975/). Drew kindly
provided "arm64: Provide read/write_sysreg_s".

All PMU tests can be launched with:
./run_tests.sh -g pmu
Tests also can be launched individually. For example:
./arm-run arm/pmu.flat -append 'chained-sw-incr'

With KVM:
- chain-promotion and chained-sw-incr are known to be failing.
- Problems were reported upstream.
With TCG:
- pmu-event-introspection is failing due to missing required events
  (we may remove this from TCG actually)
- chained-sw-incr also fails. I haven't investigated yet.

The series can be found at:
https://github.com/eauger/kut/tree/pmu_event_counters_v1

History:
v1 -> v2:
- Use new report() proto
- Style cleanup
- do not warn about ARM spec recommendations
- add a comment about PMCEID0/1 splits

Andre Przywara (1):
  arm: gic: Provide per-IRQ helper functions

Andrew Jones (1):
  arm64: Provide read/write_sysreg_s

Eric Auger (8):
  arm: pmu: Let pmu tests take a sub-test parameter
  arm: pmu: Add a pmu struct
  arm: pmu: Check Required Event Support
  arm: pmu: Basic event counter Tests
  arm: pmu: Test chained counter
  arm: pmu: test 32-bit <-> 64-bit transitions
  arm/arm64: gic: Introduce setup_irq() helper
  arm: pmu: Test overflow interrupts

 arm/gic.c              |  24 +-
 arm/pmu.c              | 783 ++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg      |  55 ++-
 lib/arm/asm/gic-v3.h   |   2 +
 lib/arm/asm/gic.h      |  12 +
 lib/arm/gic.c          | 101 ++++++
 lib/arm64/asm/sysreg.h |  11 +
 7 files changed, 950 insertions(+), 38 deletions(-)

--=20
2.20.1

