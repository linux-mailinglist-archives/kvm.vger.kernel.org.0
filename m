Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512E019E599
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDDOh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:37:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58688 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726230AbgDDOh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5/6iYn1/X1EBmc0Lpb8aoWuiKLfFR+TAtLkxR7iQvU=;
        b=bZ0NsDvoyqGTYTUl/oppTRQ2PWqG0Qyt52gzFImh4oSRd9jxnPsZE6t8p9FWdiqB0E5/i2
        99SKxfAvEWKdvzq5ro140zvtIyFbJQfpiID3TxZMPG5n0u0HcVhN0UGyfCWsgX+drIoO0B
        H9yYgA8bF9Yaj6Mtd17NTLZofTAP3GA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-X8W0NQ34MnSb3nantdKhTg-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: X8W0NQ34MnSb3nantdKhTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FC01140B;
        Sat,  4 Apr 2020 14:37:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1CF29B912;
        Sat,  4 Apr 2020 14:37:41 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 02/39] arm/arm64: psci: Don't run C code without stack or vectors
Date:   Sat,  4 Apr 2020 16:36:54 +0200
Message-Id: <20200404143731.208138-3-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This =
is
done by setting the entry point for the CPU_ON call to the physical addre=
ss
of the C function cpu_psci_cpu_die.

The compiler is well within its rights to use the stack when generating
code for cpu_psci_cpu_die.  However, because no stack initialization has
been done, the stack pointer is zero, as set by KVM when creating the VCP=
U.
This causes a data abort without a change in exception level. The VBAR_EL=
1
register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
and we end up trying to fetch instructions from address 0x200.

At this point, a stage 2 instruction abort is generated which is taken to
KVM. KVM interprets this as an instruction fetch from an I/O region, and
injects a prefetch abort into the guest. Prefetch abort is a synchronous
exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x20=
0,
which is...  0x200. The VCPU ends up in an infinite loop causing a prefet=
ch
abort while fetching the instruction to service the said abort.

To avoid all of this, lets use the assembly function halt as the CPU_ON
entry address. Also, expand the check to test that we only get
PSCI_RET_SUCCESS exactly once, as we're never offlining the CPU during th=
e
test.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/psci.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index 5c1accb6cea4..ffc09a2e9858 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -79,13 +79,14 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] =3D psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[cpu] =3D psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
=20
 static bool psci_cpu_on_test(void)
 {
 	bool failed =3D false;
+	int ret_success =3D 0;
 	int cpu;
=20
 	cpumask_set_cpu(1, &cpu_on_ready);
@@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
 	cpu_on_start =3D 1;
 	smp_mb();
=20
-	cpu_on_ret[0] =3D psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[0] =3D psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(0, &cpu_on_done);
=20
 	while (!cpumask_full(&cpu_on_done))
@@ -113,12 +114,19 @@ static bool psci_cpu_on_test(void)
 	for_each_present_cpu(cpu) {
 		if (cpu =3D=3D 1)
 			continue;
-		if (cpu_on_ret[cpu] !=3D PSCI_RET_SUCCESS && cpu_on_ret[cpu] !=3D PSCI=
_RET_ALREADY_ON) {
+		if (cpu_on_ret[cpu] =3D=3D PSCI_RET_SUCCESS) {
+			ret_success++;
+		} else if (cpu_on_ret[cpu] !=3D PSCI_RET_ALREADY_ON) {
 			report_info("unexpected cpu_on return value: caller=3DCPU%d, ret=3D%d=
", cpu, cpu_on_ret[cpu]);
 			failed =3D true;
 		}
 	}
=20
+	if (ret_success !=3D 1) {
+		report_info("got %d CPU_ON success", ret_success);
+		failed =3D true;
+	}
+
 	return !failed;
 }
=20
--=20
2.25.1

