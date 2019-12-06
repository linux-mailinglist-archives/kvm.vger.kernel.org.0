Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B339A115669
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfLFR1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:27:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbfLFR1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 12:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575653258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aakNe6ZpWKcgBnsHkUK2g0Vs/5LZCUeTONSVZshyz7w=;
        b=g/cX5IFRjINdqnxG1fMspMs+PpzWmjtELZ8nBFyg8kMZz/Sx+bvoPJIL7qMEXGtJrhgidB
        WKjACNnmknIXE3GAgSzNtTaRRGJOolLxvo91HSFowz6udq3s1af2r3ohGdoCtYsz+xz9ZV
        SRPQLMoEc9wPeoFRvYEvhG/riBV5XOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-mx1TiMz0PQSCxMj6L9ao7A-1; Fri, 06 Dec 2019 12:27:35 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBC14800597;
        Fri,  6 Dec 2019 17:27:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C6426CE40;
        Fri,  6 Dec 2019 17:27:28 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
Subject: [kvm-unit-tests RFC 00/10] KVM: arm64: PMUv3 Event Counter Tests
Date:   Fri,  6 Dec 2019 18:27:14 +0100
Message-Id: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: mx1TiMz0PQSCxMj6L9ao7A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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

Andre Przywara (1):
  arm: gic: Provide per-IRQ helper functions

Andrew Jones (1):
  arm64: Provide read/write_sysreg_s

Eric Auger (8):
  pmu: Let pmu tests take a sub-test parameter
  pmu: Add a pmu struct
  pmu: Check Required Event Support
  pmu: Basic event counter Tests
  pmu: Test chained counter
  arm: pmu: test 32-bit <-> 64-bit transitions
  arm/arm64: gic: Introduce setup_irq() helper
  pmu: Test overflow interrupts

 arm/gic.c              |  24 +-
 arm/pmu.c              | 754 ++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg      |  55 ++-
 lib/arm/asm/gic-v3.h   |   2 +
 lib/arm/asm/gic.h      |  12 +
 lib/arm/gic.c          | 101 ++++++
 lib/arm64/asm/sysreg.h |  11 +
 7 files changed, 922 insertions(+), 37 deletions(-)

--=20
2.20.1

