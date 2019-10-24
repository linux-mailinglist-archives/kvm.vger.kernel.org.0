Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B81E336D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393537AbfJXNHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39928 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393528AbfJXNHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mx2vnlJNR1H+BwVBhLpFkf4hbUqMBk6qNpXvPCTht54=;
        b=PqkQRrWHlg9djbi9XdY6ZmcAPFnjimUf8xbItOVa+a6LjK/UYwZkb7ISeuHjItEC9unEvP
        7FBtkdgEh3zXhdQjLNS4kTSKWfrWq0SxaN1JuSdHMUo1+cnToCakP6XAGf82rxeNiuKFzc
        cVwuvK5HeCLxefu1rVDY3KEd8JADPow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-WZ_bPr6_Og2X583XrRUEzQ-1; Thu, 24 Oct 2019 09:07:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 997031800E00;
        Thu, 24 Oct 2019 13:07:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9237354560;
        Thu, 24 Oct 2019 13:07:04 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Andre Przywara <andre.przywara@arm.com>
Subject: [PULL 01/10] arm: gic: check_acked: add test description
Date:   Thu, 24 Oct 2019 15:06:52 +0200
Message-Id: <20191024130701.31238-2-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: WZ_bPr6_Og2X583XrRUEzQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

At the moment the check_acked() IRQ helper function just prints a
generic "Completed" or "Timed out" message, without given a more
detailed test description.

To be able to tell the different IRQ tests apart, and also to allow
re-using it more easily, add a "description" parameter string,
which is prefixing the output line. This gives more information on what
exactly was tested.

This also splits the variable output part of the line (duration of IRQ
delivery) into a separate INFO: line, to not confuse testing frameworks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index ed5642e74f70..2ec4070fbaf9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -60,7 +60,7 @@ static void stats_reset(void)
 =09smp_wmb();
 }
=20
-static void check_acked(cpumask_t *mask)
+static void check_acked(const char *testname, cpumask_t *mask)
 {
 =09int missing =3D 0, extra =3D 0, unexpected =3D 0;
 =09int nr_pass, cpu, i;
@@ -88,7 +88,9 @@ static void check_acked(cpumask_t *mask)
 =09=09=09}
 =09=09}
 =09=09if (nr_pass =3D=3D nr_cpus) {
-=09=09=09report("Completed in %d ms", !bad, ++i * 100);
+=09=09=09report("%s", !bad, testname);
+=09=09=09if (i)
+=09=09=09=09report_info("took more than %d ms", i * 100);
 =09=09=09return;
 =09=09}
 =09}
@@ -105,8 +107,9 @@ static void check_acked(cpumask_t *mask)
 =09=09}
 =09}
=20
-=09report("Timed-out (5s). ACKS: missing=3D%d extra=3D%d unexpected=3D%d",
-=09       false, missing, extra, unexpected);
+=09report("%s", false, testname);
+=09report_info("Timed-out (5s). ACKS: missing=3D%d extra=3D%d unexpected=
=3D%d",
+=09=09    missing, extra, unexpected);
 }
=20
 static void check_spurious(void)
@@ -185,7 +188,7 @@ static void ipi_test_self(void)
 =09cpumask_clear(&mask);
 =09cpumask_set_cpu(smp_processor_id(), &mask);
 =09gic->ipi.send_self();
-=09check_acked(&mask);
+=09check_acked("IPI: self", &mask);
 =09report_prefix_pop();
 }
=20
@@ -200,7 +203,7 @@ static void ipi_test_smp(void)
 =09for (i =3D smp_processor_id() & 1; i < nr_cpus; i +=3D 2)
 =09=09cpumask_clear_cpu(i, &mask);
 =09gic_ipi_send_mask(IPI_IRQ, &mask);
-=09check_acked(&mask);
+=09check_acked("IPI: directed", &mask);
 =09report_prefix_pop();
=20
 =09report_prefix_push("broadcast");
@@ -208,7 +211,7 @@ static void ipi_test_smp(void)
 =09cpumask_copy(&mask, &cpu_present_mask);
 =09cpumask_clear_cpu(smp_processor_id(), &mask);
 =09gic->ipi.send_broadcast();
-=09check_acked(&mask);
+=09check_acked("IPI: broadcast", &mask);
 =09report_prefix_pop();
 }
=20
--=20
2.21.0

