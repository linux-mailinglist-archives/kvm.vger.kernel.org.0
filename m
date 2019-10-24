Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B857E336E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393538AbfJXNHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51908 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393536AbfJXNHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iriwzjYTJKLukOOoYgMkAJzxOyOd26UcbojrjnQjMwQ=;
        b=P/5vJLbKoJdeqP7re1oU/QPqujjMzEoGCS1Dkth3Xj50O7ZA0WyCSHFWwr1hmvIBoz6XAH
        pCJAJ2gUQYpOiCrtOrRoqkNOgeJdpG0KC6NjnvEWa1Iztz0tRmCR+QQrhSEVWeU3QY92su
        hNgGyNCYxXPUmOBCinFHsCdqIdEUtRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-0RbiYxizOuynws5Q0-hp4A-1; Thu, 24 Oct 2019 09:07:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08A9A80183D;
        Thu, 24 Oct 2019 13:07:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07E2562A66;
        Thu, 24 Oct 2019 13:07:10 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Andre Przywara <andre.przywara@arm.com>
Subject: [PULL 06/10] arm: Add missing test name prefix calls
Date:   Thu, 24 Oct 2019 15:06:57 +0200
Message-Id: <20191024130701.31238-7-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 0RbiYxizOuynws5Q0-hp4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

When running the unit tests in TAP mode (./run_tests.sh -t), every single
test result is printed. This works fine for most tests which use the
reporting prefix feature to indicate the actual test name.
However psci and pci were missing those names, so the reporting left
people scratching their head what was actually tested:
...
ok 74 - invalid-function
ok 75 - affinity-info-on
ok 76 - affinity-info-off
ok 77 - cpu-on

Push a "psci" prefix before running those tests to make those report
lines more descriptive.
While at it, do the same for pci, even though it is less ambigious there.
Also the GIC ITARGETSR test was missing a report_prefix_pop().

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c      | 2 ++
 arm/pci-test.c | 2 ++
 arm/psci.c     | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 02d292807c9b..adb6aa464513 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -480,6 +480,8 @@ static void test_targets(int nr_irqs)
 =09test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
=20
 =09writel(orig_targets, targetsptr + GIC_FIRST_SPI);
+
+=09report_prefix_pop();
 }
=20
 static void gic_test_mmio(void)
diff --git a/arm/pci-test.c b/arm/pci-test.c
index cf128ac1b032..7c3836e5cd63 100644
--- a/arm/pci-test.c
+++ b/arm/pci-test.c
@@ -19,6 +19,8 @@ int main(void)
 =09=09return report_summary();
 =09}
=20
+=09report_prefix_push("pci");
+
 =09pci_print();
=20
 =09ret =3D pci_testdev();
diff --git a/arm/psci.c b/arm/psci.c
index 5cb4d5c7c233..536c9b742033 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -126,6 +126,8 @@ int main(void)
 {
 =09int ver =3D psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
=20
+=09report_prefix_push("psci");
+
 =09if (nr_cpus < 2) {
 =09=09report_skip("At least 2 cpus required");
 =09=09goto done;
--=20
2.21.0

