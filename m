Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194CC35F06B
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 11:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhDNJH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 05:07:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231793AbhDNJHZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 05:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618391223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DoVAi5Alafxdlk/2SmDHHA3YZcxtB3FE5/0Sm+ZUtDw=;
        b=io9i9z6iLQVc1Bz2eEbh2qQ/Zr9QBKyz4ThwsHhMxtASYLz67gicWDfqvfE7GoMrB9jipR
        UOHfRmkRM9zltWbIseWiTvlTssBSW23rql5IdPfQ3r6Yyj07ztVgdJFj78acknMW/v6AvL
        Wr68j1/c9WNZcpWOifDLw7raaLaA/Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-bJJngsOTP_yYbum120WSOg-1; Wed, 14 Apr 2021 05:07:01 -0400
X-MC-Unique: bJJngsOTP_yYbum120WSOg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 039C18189CB;
        Wed, 14 Apr 2021 09:07:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 380F25D9CC;
        Wed, 14 Apr 2021 09:06:55 +0000 (UTC)
Date:   Wed, 14 Apr 2021 11:06:47 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 8/8] arm/arm64: psci: don't assume method
 is hvc
Message-ID: <20210414090647.svahtx74dki3c3vq@kamzik.brq.redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-9-drjones@redhat.com>
 <660cfeb4-c411-8335-0351-716a98faf0ae@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <660cfeb4-c411-8335-0351-716a98faf0ae@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 10:46:33AM -0700, Nikos Nikoleris wrote:
> On 07/04/2021 19:59, Andrew Jones wrote:
> > The method can also be smc and it will be when running on bare metal.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >   arm/selftest.c     | 34 +++++++---------------------------
> >   lib/arm/asm/psci.h |  9 +++++++--
> >   lib/arm/psci.c     | 17 +++++++++++++++--
> >   lib/arm/setup.c    | 22 ++++++++++++++++++++++
> >   4 files changed, 51 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arm/selftest.c b/arm/selftest.c
> > index 4495b161cdd5..9f459ed3d571 100644
> > --- a/arm/selftest.c
> > +++ b/arm/selftest.c
> > @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
> >   	exit(report_summary());
> >   }
> > -static bool psci_check(void)
> > +static void psci_print(void)
> >   {
> > -	const struct fdt_property *method;
> > -	int node, len, ver;
> > -
> > -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
> > -	if (node < 0) {
> > -		printf("PSCI v0.2 compatibility required\n");
> > -		return false;
> > -	}
> > -
> > -	method = fdt_get_property(dt_fdt(), node, "method", &len);
> > -	if (method == NULL) {
> > -		printf("bad psci device tree node\n");
> > -		return false;
> > -	}
> > -
> > -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
> > -		printf("psci method must be hvc\n");
> > -		return false;
> > -	}
> > -
> > -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> > -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
> > -				       PSCI_VERSION_MINOR(ver));
> > -
> > -	return true;
> > +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> > +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
> > +					  PSCI_VERSION_MINOR(ver));
> > +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
> > +				       "hvc" : "smc");
> >   }
> >   static void cpu_report(void *data __unused)
> > @@ -465,7 +445,7 @@ int main(int argc, char **argv)
> >   	} else if (strcmp(argv[1], "smp") == 0) {
> > -		report(psci_check(), "PSCI version");
> > +		psci_print();
> >   		on_cpus(cpu_report, NULL);
> >   		while (!cpumask_full(&ready))
> >   			cpu_relax();
> > diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> > index 7b956bf5987d..e385ce27f5d1 100644
> > --- a/lib/arm/asm/psci.h
> > +++ b/lib/arm/asm/psci.h
> > @@ -3,8 +3,13 @@
> >   #include <libcflat.h>
> >   #include <linux/psci.h>
> > -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
> > -		       unsigned long arg1, unsigned long arg2);
> > +typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
> > +			      unsigned long arg1, unsigned long arg2);
> > +extern psci_invoke_fn psci_invoke;
> > +extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> > +			   unsigned long arg1, unsigned long arg2);
> > +extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> > +			   unsigned long arg1, unsigned long arg2);
> >   extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
> >   extern void psci_system_reset(void);
> >   extern int cpu_psci_cpu_boot(unsigned int cpu);
> > diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> > index 936c83948b6a..46300f30822c 100644
> > --- a/lib/arm/psci.c
> > +++ b/lib/arm/psci.c
> > @@ -11,9 +11,11 @@
> >   #include <asm/page.h>
> >   #include <asm/smp.h>
> > +psci_invoke_fn psci_invoke;
> > +
> >   __attribute__((noinline))
> > -int psci_invoke(unsigned long function_id, unsigned long arg0,
> > -		unsigned long arg1, unsigned long arg2)
> > +int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> > +		    unsigned long arg1, unsigned long arg2)
> >   {
> >   	asm volatile(
> >   		"hvc #0"
> > @@ -22,6 +24,17 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
> >   	return function_id;
> >   }
> > +__attribute__((noinline))
> 
> Is noinline necessary? We shouldn't be calling psci_invoke_smc and
> psci_invoke_hmc directly, it's unlikely that the compiler will have a chance
> to inline them. But I might be missing something here because I don't see
> why it was there in psci_invoke either.

The noinline ensures that function_id,arg0,arg1,arg2 are in r0-r3 without
us having to do something like

 "mov r0, %0"
 "mov r1, %1"
 "mov r2, %2"
 "mov r3, %3"

in the asm().

> 
> Otherwise Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks!
drew

