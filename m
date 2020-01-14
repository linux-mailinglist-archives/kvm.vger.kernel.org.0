Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB88613B02D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgANRBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:01:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59331 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgANRBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 12:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579021301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vHjuEWuFFYMcYDoJXtNkBULEUG48WMDmQ3tXgYe6dCA=;
        b=Fc94iMyY8KoeDH79aBUmg2vYPzvRIij/TDHxnX7KoXiOUtTGGJk7uIsDci+I9TTs/UwwRd
        PcO8qFFNUiKQyApF9NuPDXeDCMXOmNApmqVin1xcx0ESV1Y8dc29z+Q5HcC/tk3sBQQC6n
        DgSOhBub72LDr1Yk7m+9skCVTW5h/lE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-LPYfDb6JN5-Ne0-ljYBwsw-1; Tue, 14 Jan 2020 12:01:39 -0500
X-MC-Unique: LPYfDb6JN5-Ne0-ljYBwsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 400E2A1728;
        Tue, 14 Jan 2020 17:01:38 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9892E60BF1;
        Tue, 14 Jan 2020 17:01:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: smp: Test all CRs on initial
 reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bec10775-3713-4604-1b49-27d49682db43@redhat.com>
Date:   Tue, 14 Jan 2020 18:01:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114153054.77082-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2020 16.30, Janosch Frank wrote:
> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
> so we also need to test 1-13 and 15 for 0.
>=20
> And while we're at it, let's also set some values to cr 1, 7 and 13, so
> we can actually be sure that they will be zeroed.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>=20
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 767d167..11ab425 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -175,16 +175,31 @@ static void test_emcall(void)
>  	report_prefix_pop();
>  }
> =20
> +static void test_func_initial(void)
> +{
> +	lctlg(1, 0x42000UL);
> +	lctlg(7, 0x43000UL);
> +	lctlg(13, 0x44000UL);
> +	testflag =3D 1;
> +	mb();
> +	cpu_loop();
> +}
> +
>  static void test_reset_initial(void)
>  {
>  	struct cpu_status *status =3D alloc_pages(0);
> +	uint8_t *nullp =3D alloc_pages(0);

Why not simply:

        uint64_t nullp[12];

?

>  	struct psw psw;
> =20
> +	memset(nullp, 0, PAGE_SIZE);
>  	psw.mask =3D extract_psw_mask();
> -	psw.addr =3D (unsigned long)test_func;
> +	psw.addr =3D (unsigned long)test_func_initial;
> =20
>  	report_prefix_push("reset initial");
> +	testflag =3D 0;
> +	mb();
>  	smp_cpu_start(1, psw);
> +	wait_for_flag();
> =20
>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
> @@ -195,6 +210,8 @@ static void test_reset_initial(void)
>  	report(!status->fpc, "fpc");
>  	report(!status->cputm, "cpu timer");
>  	report(!status->todpr, "todpr");
> +	report(!memcmp(&status->crs[1], nullp, sizeof(status->crs[1]) * 12), =
"cr1-13 =3D=3D 0");
> +	report(status->crs[15] =3D=3D 0, "cr15 =3D=3D 0");
>  	report_prefix_pop();
> =20
>  	report_prefix_push("initialized");
> @@ -204,6 +221,7 @@ static void test_reset_initial(void)
> =20
>  	report(smp_cpu_stopped(1), "cpu stopped");
>  	free_pages(status, PAGE_SIZE);
> +	free_pages(nullp, PAGE_SIZE);
>  	report_prefix_pop();
>  }
> =20
> @@ -219,6 +237,7 @@ static void test_reset(void)
> =20
>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>  	report(smp_cpu_stopped(1), "cpu stopped");
> +	smp_cpu_destroy(1);

Shouldn't that rather be part of patch 2/4 ? I'd maybe also move this to
the main() function instead since you've setup the cpu there...? Also is
it still ok to use smp_cpu_start() in test_reset_initial() after you've
destroyed the CPU here in test_reset()?

>  	report_prefix_pop();
>  }

 Thomas

