Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1138FE336F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393541AbfJXNHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:07:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393527AbfJXNHQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 09:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571922435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90nJ7SduaEl/Ta4vW3TrQn+5ds5ba8O0P0WMbTveFi0=;
        b=R6ZYQmvjw9Ywi5lQCu+jUByI9/EO8xyXHdDqi5/Ctvc13EcxfBZNDhsHvYUXh7yd5Rovtw
        zHfGRMPvpRfhRlUFnX+qGoGgLIOF3u0jy/ipKRzWUW8hsn458CXUx6VhqFyJTzvuyTFi4N
        xDspu3BZiuQGKSLs0fFj/kM1NWacx0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134--9aE3u-SM8aHHNzbQEdgUQ-1; Thu, 24 Oct 2019 09:07:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B414E100550E;
        Thu, 24 Oct 2019 13:07:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8AAE62A66;
        Thu, 24 Oct 2019 13:07:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Andre Przywara <andre.przywara@arm.com>
Subject: [PULL 05/10] arm: selftest: Make MPIDR output stable
Date:   Thu, 24 Oct 2019 15:06:56 +0200
Message-Id: <20191024130701.31238-6-drjones@redhat.com>
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
References: <20191024130701.31238-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: -9aE3u-SM8aHHNzbQEdgUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

At the moment the smp selftest outputs one line for each vCPU, with the
CPU number and its MPIDR printed in the same test result line.
For automated test frameworks this has the problem of including variable
output in the test name, also the number of tests varies, depending on the
number of vCPUs.

Fix this by only generating a single line of output for the SMP test,
which summarises the result. We use two cpumasks, to let each vCPU report
its result and completion of the test (code stolen from the GIC test).

For informational purposes we keep the one line per CPU, but prefix it
with an INFO: tag, so that frameworks can ignore it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/selftest.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index a0c1ab8180bc..e9dc5c0cab28 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -17,6 +17,8 @@
 #include <asm/smp.h>
 #include <asm/barrier.h>
=20
+static cpumask_t ready, valid;
+
 static void __user_psci_system_off(void)
 {
 =09psci_system_off();
@@ -341,8 +343,11 @@ static void cpu_report(void *data __unused)
 =09uint64_t mpidr =3D get_mpidr();
 =09int cpu =3D smp_processor_id();
=20
-=09report("CPU(%3d) mpidr=3D%010" PRIx64,
-=09=09mpidr_to_cpu(mpidr) =3D=3D cpu, cpu, mpidr);
+=09if (mpidr_to_cpu(mpidr) =3D=3D cpu)
+=09=09cpumask_set_cpu(smp_processor_id(), &valid);
+=09smp_wmb();=09=09/* Paired with rmb in main(). */
+=09cpumask_set_cpu(smp_processor_id(), &ready);
+=09report_info("CPU%3d: MPIDR=3D%010" PRIx64, cpu, mpidr);
 }
=20
 int main(int argc, char **argv)
@@ -371,6 +376,11 @@ int main(int argc, char **argv)
=20
 =09=09report("PSCI version", psci_check());
 =09=09on_cpus(cpu_report, NULL);
+=09=09while (!cpumask_full(&ready))
+=09=09=09cpu_relax();
+=09=09smp_rmb();=09=09/* Paired with wmb in cpu_report(). */
+=09=09report("MPIDR test on all CPUs", cpumask_full(&valid));
+=09=09report_info("%d CPUs reported back", nr_cpus);
=20
 =09} else {
 =09=09printf("Unknown subtest\n");
--=20
2.21.0

