Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15F5FC65D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfKNMcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:32:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726139AbfKNMcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 07:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573734753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4bFwAknYoXAgoIVT6IR8TxKpQxjPgCeYexMYT/nB6jM=;
        b=PkEristcd4qCqzGes8QMksWxcuC3P7HkoAQodQJeyNBw0ijE7bLyXetl0iIH90Ryt55lDV
        bIzUYVNUX7CIs5LLIKTu2zCpVrhBRyr+zROBpR4iMFFg6cp0+nBmtCpVfaIrz4P89/nX1y
        8K9818T+FeNBZ2TJFt1hKTlkOgpa2Vw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-VPBqvAjWPvCmj8cUfEVnBg-1; Thu, 14 Nov 2019 07:32:30 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB417A41FD;
        Thu, 14 Nov 2019 12:32:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 319776B8CB;
        Thu, 14 Nov 2019 12:32:27 +0000 (UTC)
Date:   Thu, 14 Nov 2019 13:32:24 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH 07/17] arm: gic: Extend check_acked() to
 allow silent call
Message-ID: <20191114123224.2b5jr73qqtgtc7na@kamzik.brq.redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-8-andre.przywara@arm.com>
 <25598849-b195-3411-8092-b0656bcfb762@arm.com>
MIME-Version: 1.0
In-Reply-To: <25598849-b195-3411-8092-b0656bcfb762@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: VPBqvAjWPvCmj8cUfEVnBg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 03:23:04PM +0000, Alexandru Elisei wrote:
> check_acked is starting to become hard to read.

Agreed. check_acked() could probably have some of its subtests factored
out to improve its readability.

> The function itself is rather inconsistent, as it mixes regular
> printf's with report_info's.

Sounds good

> The return value is also never used:
>=20
> $ awk '/check_acked\(/ && !/const/' arm/gic.c
> =A0=A0=A0 check_acked("IPI: self", &mask);
> =A0=A0=A0 check_acked("IPI: directed", &mask);
> =A0=A0=A0 check_acked("IPI: broadcast", &mask);

That's good, since it's a void function :-)

>=20
> What I'm thinking is that we can rewrite check_acked to return true/false=
 (or
> 0/1), meaning success or failure, remove the testname parameter, replace =
the
> printfs to report_info, and have the caller do a report based on the valu=
e
> returned by check_acked.
>=20
> Rough version, compile tested only, I'm sure it can be improved:
>=20
> diff --git a/arm/gic.c b/arm/gic.c
> index adb6aa464513..5453f2fd3d5f 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -60,11 +60,11 @@ static void stats_reset(void)
> =A0=A0=A0=A0=A0=A0=A0 smp_wmb();
> =A0}
> =A0
> -static void check_acked(const char *testname, cpumask_t *mask)
> +static bool check_acked(cpumask_t *mask)

We have several check_* functions in arm/gic.c, and they're all void
functions. Changing this one to a bool would be inconsistent, but
maybe that consistency isn't that important, or maybe they should all
be bool?

> =A0{
> =A0=A0=A0=A0=A0=A0=A0 int missing =3D 0, extra =3D 0, unexpected =3D 0;
> =A0=A0=A0=A0=A0=A0=A0 int nr_pass, cpu, i;
> -=A0=A0=A0=A0=A0=A0 bool bad =3D false;
> +=A0=A0=A0=A0=A0=A0 bool success =3D true;
> =A0
> =A0=A0=A0=A0=A0=A0=A0 /* Wait up to 5s for all interrupts to be delivered=
 */
> =A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < 50; ++i) {
> @@ -76,22 +76,21 @@ static void check_acked(const char *testname, cpumask=
_t *mask)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 acked[cpu] =3D=3D 1 : acked[cpu] =3D=3D 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(bad_sender[cpu] !=3D -1) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 printf("cpu%d received IPI from wrong sender %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 report_info("cpu%d received IPI from wrong sender
> %d\n",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpu, bad_sender[cpu]);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 bad =3D true;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 success =3D false;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(bad_irq[cpu] !=3D -1) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 printf("cpu%d received wrong irq %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 report_info("cpu%d received wrong irq %d\n",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpu, bad_irq[cpu]);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 bad =3D true;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 success =3D false;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (nr_pass =3D=3D nr_cpus)=
 {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 repor=
t("%s", !bad, testname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(i)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 report_info("took more than %d ms", i * 100);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retur=
n;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retur=
n success;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0 }
> =A0
> @@ -107,9 +106,9 @@ static void check_acked(const char *testname, cpumask=
_t *mask)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0 }
> =A0
> -=A0=A0=A0=A0=A0=A0 report("%s", false, testname);
> =A0=A0=A0=A0=A0=A0=A0 report_info("Timed-out (5s). ACKS: missing=3D%d ext=
ra=3D%d unexpected=3D%d",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 missing, extra,=
 unexpected);
> +=A0=A0=A0=A0=A0=A0 return false;
> =A0}
> =A0
> =A0static void check_spurious(void)
> @@ -183,13 +182,11 @@ static void ipi_test_self(void)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0 cpumask_t mask;
> =A0
> -=A0=A0=A0=A0=A0=A0 report_prefix_push("self");
> =A0=A0=A0=A0=A0=A0=A0 stats_reset();
> =A0=A0=A0=A0=A0=A0=A0 cpumask_clear(&mask);
> =A0=A0=A0=A0=A0=A0=A0 cpumask_set_cpu(smp_processor_id(), &mask);
> =A0=A0=A0=A0=A0=A0=A0 gic->ipi.send_self();
> -=A0=A0=A0=A0=A0=A0 check_acked("IPI: self", &mask);
> -=A0=A0=A0=A0=A0=A0 report_prefix_pop();
> +=A0=A0=A0=A0=A0=A0 report("self", check_acked(&mask));
> =A0}
> =A0
> =A0static void ipi_test_smp(void)
> @@ -203,7 +200,7 @@ static void ipi_test_smp(void)
> =A0=A0=A0=A0=A0=A0=A0 for (i =3D smp_processor_id() & 1; i < nr_cpus; i +=
=3D 2)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(i, &mask)=
;
> =A0=A0=A0=A0=A0=A0=A0 gic_ipi_send_mask(IPI_IRQ, &mask);
> -=A0=A0=A0=A0=A0=A0 check_acked("IPI: directed", &mask);
> +=A0=A0=A0=A0=A0=A0 report("directed", check_acked(&mask));
> =A0=A0=A0=A0=A0=A0=A0 report_prefix_pop();

Shouldn't we also drop the "target-list" prefix push/pop?

> =A0
> =A0=A0=A0=A0=A0=A0=A0 report_prefix_push("broadcast");
> @@ -211,7 +208,7 @@ static void ipi_test_smp(void)
> =A0=A0=A0=A0=A0=A0=A0 cpumask_copy(&mask, &cpu_present_mask);
> =A0=A0=A0=A0=A0=A0=A0 cpumask_clear_cpu(smp_processor_id(), &mask);
> =A0=A0=A0=A0=A0=A0=A0 gic->ipi.send_broadcast();
> -=A0=A0=A0=A0=A0=A0 check_acked("IPI: broadcast", &mask);
> +=A0=A0=A0=A0=A0=A0 report("broadcast", check_acked(&mask));
> =A0=A0=A0=A0=A0=A0=A0 report_prefix_pop();
> =A0}

Shouldn't we also drop the "broadcast" prefix push/pop?

> =A0
> I've removed "IPI" from the report string because the prefixed was alread=
y pushed
> in main.
>=20
> Andrew, what do you think? Are we missing something obvious? Do you have =
a better
> idea?

I'm happy to see cleanups and haven't had a chance to look too closely at
the gic tests in a while so I have no better ideas :-)

Thanks,
drew

