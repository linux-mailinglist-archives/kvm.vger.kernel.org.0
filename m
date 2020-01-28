Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD614B2AC
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 11:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgA1KfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 05:35:22 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725948AbgA1KfW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 05:35:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580207720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fkt49j2omiFhxKeCwkMFncGz7jKFhFRQ1Z0P3fqpgS4=;
        b=HQ8JFqMVz/ns9fq4gWHhXcFohEr8xe/M7Oc0Cvrk/AsEjkztK0r7RBoKi28blx7v2MVIPx
        5LDLYIqWe6DEqz1E0oM0yj97VtAPietFzGtQTJwL47GXFG/wVjMWGTpavgQt16+/sF0K9C
        IFfPap4htUFlWAuCEFcvKqk2RuKiv2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-iOkdwkQ5PaOa_EbpL-qEKQ-1; Tue, 28 Jan 2020 05:35:12 -0500
X-MC-Unique: iOkdwkQ5PaOa_EbpL-qEKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 357E618C43C0;
        Tue, 28 Jan 2020 10:35:10 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD6381001B08;
        Tue, 28 Jan 2020 10:35:01 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 00/14] arm/arm64: Add ITS tests
Date:   Tue, 28 Jan 2020 11:34:45 +0100
Message-Id: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a revival of an RFC series sent in Dec 2016 [1].
Given the amount of code and the lack of traction at that time,
I haven't respinned until now. However a recent bug found related
to the ITS migration convinced me that this work may deserve to be
respinned and enhanced.

Tests exercise main ITS commands and also test migration.
With the migration framework, we are able to trigger the
migration from guest and that is very practical actually.

What is particular with the ITS programming is that most of
the commands are passed through queues and there is real error
handling. Invalid commands are just ignored and that is not
really tester friendly.

This series includes Andre's patch: "arm: gic: Provide
per-IRQ helper functions" [2]

test_migrate_unmapped_collection is currently failing with
upstream kernel. See [3].

The series can be fount at:
https://github.com/eauger/kut/tree/its-v3

Best Regards

Eric

History:
v2 -> v3:
- fix 32b compilation
- take into account Drew's comments (see individual diff logs)

v1 -> v2:
- took into account Zenghui's comments
- collect R-b's from Thomas

References:
[1] [kvm-unit-tests RFC 00/15] arm/arm64: add ITS framework
    https://lists.gnu.org/archive/html/qemu-devel/2016-12/msg00575.html

[2] [kvm-unit-tests PATCH 00/17] arm: gic: Test SPIs and interrupt groups
    https://patchwork.kernel.org/cover/11234975/

[3] [PATCH] KVM: arm/arm64: vgic-its: Fix restoration of unmapped
    collections (https://lkml.org/lkml/2019/12/13/205)

Execution:
x For ITS migration testing use:
  ./run_tests.sh -g migration (block on TCG)

x For other ITS tests:
  ./run_tests.sh -g its

x non migration tests can be launched invidually. For instance:
  ./arm-run arm/gic.flat -smp 8 -append 'its-trigger'


Andre Przywara (1):
  arm: gic: Provide per-IRQ helper functions

Eric Auger (13):
  libcflat: Add other size defines
  arm/arm64: gic: Introduce setup_irq() helper
  arm/arm64: gicv3: Add some re-distributor defines
  arm/arm64: ITS: Introspection tests
  arm/arm64: gicv3: Set the LPI config and pending tables
  arm/arm64: gicv3: Enable/Disable LPIs at re-distributor level
  arm/arm64: ITS: its_enable_defaults
  arm/arm64: ITS: Device and collection Initialization
  arm/arm64: ITS: commands
  arm/arm64: ITS: INT functional tests
  arm/run: Allow Migration tests
  arm/arm64: ITS: migration tests
  arm/arm64: ITS: pending table migration test

 arm/Makefile.arm64         |   1 +
 arm/Makefile.common        |   2 +-
 arm/gic.c                  | 488 +++++++++++++++++++++++++++++++++++--
 arm/run                    |   2 +-
 arm/unittests.cfg          |  38 +++
 lib/arm/asm/gic-v3-its.h   | 167 +++++++++++++
 lib/arm/asm/gic-v3.h       |  25 ++
 lib/arm/asm/gic.h          |   8 +
 lib/arm/gic-v3-its-cmd.c   | 454 ++++++++++++++++++++++++++++++++++
 lib/arm/gic-v3-its.c       | 243 ++++++++++++++++++
 lib/arm/gic-v3.c           |  81 ++++++
 lib/arm/gic.c              | 120 ++++++++-
 lib/arm/io.c               |  28 +++
 lib/arm64/asm/gic-v3-its.h |   1 +
 lib/libcflat.h             |   3 +
 15 files changed, 1633 insertions(+), 28 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm/gic-v3-its-cmd.c
 create mode 100644 lib/arm/gic-v3-its.c
 create mode 100644 lib/arm64/asm/gic-v3-its.h

--=20
2.20.1

