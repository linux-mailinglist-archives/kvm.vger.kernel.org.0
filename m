Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5448DF9BCC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfKLVO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:14:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726952AbfKLVOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573593264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0bsLDLGgwqWjvPt7yk6eXjGQ2Ee83dUoAWlp33AQHXo=;
        b=hSQ0Twzvd66PNVbf3X1AgRSy4P3LjStNICs4m1YCpoucPT7bI4ZfedWtwXDU6prmh95t8X
        JRNY43/HtVzUybymq3zm5TCsKWLE79tfR0syU5QrtLE7f3kqjES/We2meEdDMyqoOLsNBI
        fr0kiCVjryj/szcYeUwf9Fw2OkEXAQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-HqlNN2b1Nw-sGxj_LfAFhQ-1; Tue, 12 Nov 2019 16:14:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 785019266C;
        Tue, 12 Nov 2019 21:14:19 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2278B6018B;
        Tue, 12 Nov 2019 21:14:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 04/17] arm: gic: Support no IRQs test case
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-5-andre.przywara@arm.com>
 <db89b983-425c-8b45-3f26-1a33b9817836@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a8546125-1d41-559b-1085-9289868ad009@redhat.com>
Date:   Tue, 12 Nov 2019 22:14:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <db89b983-425c-8b45-3f26-1a33b9817836@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: HqlNN2b1Nw-sGxj_LfAFhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/12/19 2:26 PM, Alexandru Elisei wrote:
> Hi,
>=20
> On 11/8/19 2:42 PM, Andre Przywara wrote:
>> For some tests it would be important to check that an IRQ was *not*
>> triggered, for instance to test certain masking operations.
>>
>> Extend the check_added() function to recognise an empty cpumask to
>> detect this situation. The timeout duration is reduced, and the "no IRQs
>=20
> Why is the timeout duration reduced?
>=20
>> triggered" case is actually reported as a success in this case.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arm/gic.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index a114009..eca9188 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -66,9 +66,10 @@ static void check_acked(const char *testname, cpumask=
_t *mask)
>>  =09int missing =3D 0, extra =3D 0, unexpected =3D 0;
>>  =09int nr_pass, cpu, i;
>>  =09bool bad =3D false;
>> +=09bool noirqs =3D cpumask_empty(mask);
>> =20
>>  =09/* Wait up to 5s for all interrupts to be delivered */
>=20
> This comment needs updating.
>=20
>> -=09for (i =3D 0; i < 50; ++i) {
>> +=09for (i =3D 0; i < (noirqs ? 15 : 50); ++i) {
>>  =09=09mdelay(100);
>>  =09=09nr_pass =3D 0;
>>  =09=09for_each_present_cpu(cpu) {
>> @@ -88,7 +89,7 @@ static void check_acked(const char *testname, cpumask_=
t *mask)
>>  =09=09=09=09bad =3D true;
>>  =09=09=09}
>>  =09=09}
>> -=09=09if (nr_pass =3D=3D nr_cpus) {
>> +=09=09if (!noirqs && nr_pass =3D=3D nr_cpus) {
>=20
> This condition is pretty hard to read - what you are doing here is making=
 sure
> that when check_acked tests that no irqs have been received, you do the e=
ntire for
> loop and wait the entire timeout duration. Did I get that right?
>=20
> How about this (compile tested only):
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (noirqs)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Wait for th=
e entire timeout duration. */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 continue;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (nr_pass =3D=3D nr_cpus) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 report("=
%s", !bad, testname);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (i)
>=20
>>  =09=09=09report("%s", !bad, testname);
>>  =09=09=09if (i>>  =09=09=09=09report_info("took more than %d ms", i * 1=
00);
>> @@ -96,6 +97,11 @@ static void check_acked(const char *testname, cpumask=
_t *mask)
>>  =09=09}
>>  =09}
>> =20
>> +=09if (noirqs && nr_pass =3D=3D nr_cpus) {
>> +=09=09report("%s", !bad, testname);

This one looks at the result of the last iteration (on timeout).

In case of noirqs I think we should be able to return a failure as soon
as an irq is detected where we do not expect it, without waiting for the
full delay?

Thanks

Eric
>=20
> bad is true only when bad_sender[cpu] !=3D -1 or bad_irq[cpu] !=3D -1, wh=
ich only get
> set in the irq or ipi handlesr, meaning when you do get an interrupt. If =
nr_pass
> =3D=3D nr_cpus and noirqs, then you shouldn't have gotten an interrupt. I=
 think it's
> safe to write it as report("%s", true, testname). I think a short comment=
 above
> explaining why we do this check (timeout expired and we haven't gotten an=
y
> interrupts) would also improve readability of the code, but that's up to =
you.
>=20
> Thanks,
> Alex
>> +=09=09return;
>> +=09}
>> +
>>  =09for_each_present_cpu(cpu) {
>>  =09=09if (cpumask_test_cpu(cpu, mask)) {
>>  =09=09=09if (!acked[cpu])
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>=20

