Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F83315D6DD
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 12:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgBNLvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 06:51:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30243 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727652AbgBNLvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 06:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581681068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRbqqZO6a+MeMwBgOzJgX5nq8QvwfWWd6YqYAkhAo+Q=;
        b=WWbQf7iN6nR1TxbNuDLHm2m96LR9yszCbNcAJtngQ7qRwWvV+OkqORwcyuMW6TNSfu53Iw
        R4apRpYWQiGz13BwGNKfAaLVYo2majhmjHatSn8isdUP5wEJ+k6oS1q5HCFzrSM8sRyq37
        YKzIkFGlTeiVcwFTJ1+2yX2yJOuQBvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-OpPM0aUlPwm3O5e9SU3lpw-1; Fri, 14 Feb 2020 06:51:01 -0500
X-MC-Unique: OpPM0aUlPwm3O5e9SU3lpw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A93D21005510;
        Fri, 14 Feb 2020 11:51:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2EEB5DA85;
        Fri, 14 Feb 2020 11:50:53 +0000 (UTC)
Date:   Fri, 14 Feb 2020 12:50:51 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
Message-ID: <20200214115051.o4t6ro55y42oztxf@kamzik.brq.redhat.com>
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
 <689d8031-22ac-c414-a3c3-e10567c3c9af@redhat.com>
 <20200214103853.ycxs4clif4gisk6i@kamzik.brq.redhat.com>
 <d04b6913-e71e-8983-e704-d956be12dac9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d04b6913-e71e-8983-e704-d956be12dac9@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:50:08AM +0100, Paolo Bonzini wrote:
> On 14/02/20 11:38, Andrew Jones wrote:
> > That was the way we originally planned on doing it when Alex Bennee posted
> > his patch. However since d4d34e648482 ("run_tests: fix command line
> > options handling") the "--" has become the divider between run_tests.sh
> > parameter inputs and individually specified tests.
> 
> Hmm, more precisely that is how getopt separates options from other 
> parameters.
> 
> Since we don't expect test names starting with a dash, we could do 
> something like (untested):
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 01e36dc..8b71cf2 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -35,7 +35,20 @@ RUNTIME_arch_run="./$TEST_DIR/run"
>  source scripts/runtime.bash
>  
>  only_tests=""
> -args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
> +args=""
> +vmm_args=""
> +while [ $# -gt 0 ]; do
> +   if test "$1" = --; then
> +       shift
> +       vmm_args=$*
> +       break
> +   else
> +       args="args $1"
> +       shift
> +   fi
> +done
> +
> +args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $args`
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do

Unfortunately it regresses the current command line. Here's what I tested

Before
------

$ ./run_tests.sh -j 2 -v pmu psci
VMM_PARAMS= TESTNAME=pmu TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1
VMM_PARAMS= TESTNAME=psci TIMEOUT=90s ACCEL= ./arm/run arm/psci.flat -smp $MAX_SMP
PASS pmu (3 tests)
PASS psci (4 tests)

$ ./run_tests.sh pmu psci -j 2 -v
VMM_PARAMS= TESTNAME=pmu TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1
VMM_PARAMS= TESTNAME=psci TIMEOUT=90s ACCEL= ./arm/run arm/psci.flat -smp $MAX_SMP
PASS pmu (3 tests)
PASS psci (4 tests)

$ ./run_tests.sh -j 2 -v -- pmu psci
VMM_PARAMS= TESTNAME=pmu TIMEOUT=90s ACCEL= ./arm/run arm/pmu.flat -smp 1
VMM_PARAMS= TESTNAME=psci TIMEOUT=90s ACCEL= ./arm/run arm/psci.flat -smp $MAX_SMP
PASS pmu (3 tests)
PASS psci (4 tests)

After
-----

$ ./run_tests.sh -j 2 -v pmu psci
PASS psci (4 tests)

$ ./run_tests.sh pmu psci -j 2 -v
$

(no output)

$ ./run_tests.sh -j 2 -v -- pmu psci
$

(no output)

> 
> > will run the test with "-foo bar" appended to the command line. We could
> > modify mkstandalone.sh to get that feature too (allowing the additional
> > parameters to be given after tests/mytest), but with VMM_PARAMS we don't
> > have to.
> 
> Yes, having consistency between standalone and run_tests.sh is a good thing.
>

So should we:

 1) try to get "--" working, but also keep the environment variable as
    an alternative which works with standalone?
 2) drop the environment variable, get "--" working and modify
    mkstandalone.sh?
 3) drop the environment variable, get "--" working, but forget about
    standalone?
 4) just keep the VMM_PARAMS approach and forget about "--"?

Thanks,
drew

