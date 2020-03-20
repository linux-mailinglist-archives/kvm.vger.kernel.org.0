Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E407418CA29
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 10:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgCTJYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 05:24:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32257 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbgCTJYr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 05:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584696285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IeMxV+nJyYzaQLc3wwNQ9aEwBnBicqgUTnOCjDW6Sxo=;
        b=cDtHJOwdBSE+u1up9vDsINoYWQPnaF5lsTsjXGRsYWS1Wk0R0sHsv1EGA7UYj2Nb4NyEy7
        cer4cZJT2G0Mk97mnh6M4ho9+zBBMFEz2fWrP7tkb4/fs0P0+qpbTXwiXHm4zP7k9AiCyW
        owaex6uRxBgTGzqSQUvxlEgppl+lmtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-MnieVj2aM-qS15lDWykShA-1; Fri, 20 Mar 2020 05:24:41 -0400
X-MC-Unique: MnieVj2aM-qS15lDWykShA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75451083E80;
        Fri, 20 Mar 2020 09:24:39 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A84B45C1D8;
        Fri, 20 Mar 2020 09:24:32 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v7 00/13] arm/arm64: Add ITS tests
Date:   Fri, 20 Mar 2020 10:24:15 +0100
Message-Id: <20200320092428.20880-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

The series can be fount at:
https://github.com/eauger/kut/tree/its-v7

Applies on top of arm/queue.

Best Regards

Eric

History:
v6 -> v7:
- Fixed issue reported by Drew in its-migrate-unmapped-collection (a coll=
ection
  could be allocated twice depending on the SMP value)
- Integrated changes prepared by Drew
- Use for_each_present_cpu()

v5 -> v6:
- Took into account Zenghui's comments, mostly functional: see invidual
  history logs
- fix wrong assert!

v4 -> v5:
- 32b stubs moved back to arm/gic.c
- some changes reordering
- minor style issues

v3 -> v4:
- addressed comments from Drew and Zenghui
- added "page_alloc: Introduce get_order()"
- removed "arm: gic: Provide per-IRQ helper functions"
- ITS files moved to lib64
- and many more, see individual logs

v2 -> v3:
- fix 32b compilation
- take into account Drew's comments (see individual diff logs)

v1 -> v2:
- took into account Zenghui's comments
- collect R-b's from Thomas

References:
[1] [kvm-unit-tests RFC 00/15] arm/arm64: add ITS framework
    https://lists.gnu.org/archive/html/qemu-devel/2016-12/msg00575.html

Execution:
x For other ITS tests:
  ./run_tests.sh -g its

x non migration tests can be launched invidually. For instance:
  ./arm-run arm/gic.flat -smp 8 -append 'its-trigger'

x also tests can be compiled in standalone mode with
  "make standalone" and tests (even migration ones) can also be
  launched that way, for instance:
  MAX_SMP=3D4 tests/its-migrate-unmapped-collection

Eric Auger (13):
  libcflat: Add other size defines
  page_alloc: Introduce get_order()
  arm/arm64: gic: Introduce setup_irq() helper
  arm/arm64: gicv3: Add some re-distributor defines
  arm/arm64: gicv3: Set the LPI config and pending tables
  arm/arm64: ITS: Introspection tests
  arm/arm64: ITS: its_enable_defaults
  arm/arm64: ITS: Device and collection Initialization
  arm/arm64: ITS: Commands
  arm/arm64: ITS: INT functional tests
  arm/run: Allow Migration tests
  arm/arm64: ITS: migration tests
  arm/arm64: ITS: pending table migration test

 arm/Makefile.arm64         |   1 +
 arm/Makefile.common        |   2 +-
 arm/gic.c                  | 460 ++++++++++++++++++++++++++++++++++--
 arm/run                    |   2 +-
 arm/unittests.cfg          |  38 +++
 lib/alloc_page.c           |   7 +-
 lib/alloc_page.h           |   1 +
 lib/arm/asm/gic-v3-its.h   |  27 +++
 lib/arm/asm/gic-v3.h       |  29 +++
 lib/arm/asm/gic.h          |   1 +
 lib/arm/asm/processor.h    |   2 +
 lib/arm/gic-v3.c           |  78 +++++++
 lib/arm/gic.c              |  40 +++-
 lib/arm/io.c               |  28 +++
 lib/arm64/asm/gic-v3-its.h | 174 ++++++++++++++
 lib/arm64/gic-v3-its-cmd.c | 463 +++++++++++++++++++++++++++++++++++++
 lib/arm64/gic-v3-its.c     | 171 ++++++++++++++
 lib/libcflat.h             |   3 +
 18 files changed, 1496 insertions(+), 31 deletions(-)
 create mode 100644 lib/arm/asm/gic-v3-its.h
 create mode 100644 lib/arm64/asm/gic-v3-its.h
 create mode 100644 lib/arm64/gic-v3-its-cmd.c
 create mode 100644 lib/arm64/gic-v3-its.c

--=20
2.20.1

