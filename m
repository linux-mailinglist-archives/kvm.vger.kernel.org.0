Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45CCC0525
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfI0MaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:30:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfI0MaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:30:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A532BC05975D;
        Fri, 27 Sep 2019 12:30:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4BB760BF3;
        Fri, 27 Sep 2019 12:30:05 +0000 (UTC)
Date:   Fri, 27 Sep 2019 14:30:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 5/6] arm: selftest: Make MPIDR output
 stable
Message-ID: <20190927123003.jrtcqc3ruv5z64mg@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-6-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-6-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 27 Sep 2019 12:30:11 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 11:42:26AM +0100, Andre Przywara wrote:
> At the moment the smp selftest outputs one line for each vCPU, with the
> CPU number and its MPIDR printed in the same test result line.
> For automated test frameworks this has the problem of including variable
> output in the test name, also the number of tests varies, depending on the
> number of vCPUs.
> 
> Fix this by only generating a single line of output for the SMP test,
> which summarises the result. We use two cpumasks, to let each vCPU report
> its result and completion of the test (code stolen from the GIC test).
> 
> For informational purposes we keep the one line per CPU, but prefix it
> with an INFO: tag, so that frameworks can ignore it.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/selftest.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index a0c1ab8..e9dc5c0 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -17,6 +17,8 @@
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
>  
> +static cpumask_t ready, valid;
> +
>  static void __user_psci_system_off(void)
>  {
>  	psci_system_off();
> @@ -341,8 +343,11 @@ static void cpu_report(void *data __unused)
>  	uint64_t mpidr = get_mpidr();
>  	int cpu = smp_processor_id();
>  
> -	report("CPU(%3d) mpidr=%010" PRIx64,
> -		mpidr_to_cpu(mpidr) == cpu, cpu, mpidr);
> +	if (mpidr_to_cpu(mpidr) == cpu)
> +		cpumask_set_cpu(smp_processor_id(), &valid);
> +	smp_wmb();		/* Paired with rmb in main(). */
> +	cpumask_set_cpu(smp_processor_id(), &ready);
> +	report_info("CPU%3d: MPIDR=%010" PRIx64, cpu, mpidr);
>  }
>  
>  int main(int argc, char **argv)
> @@ -371,6 +376,11 @@ int main(int argc, char **argv)
>  
>  		report("PSCI version", psci_check());
>  		on_cpus(cpu_report, NULL);
> +		while (!cpumask_full(&ready))
> +			cpu_relax();
> +		smp_rmb();		/* Paired with wmb in cpu_report(). */
> +		report("MPIDR test on all CPUs", cpumask_full(&valid));
> +		report_info("%d CPUs reported back", nr_cpus);
>  
>  	} else {
>  		printf("Unknown subtest\n");
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
