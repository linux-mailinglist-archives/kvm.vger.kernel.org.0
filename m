Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE7D35A4E1
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhDIRqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:46:54 -0400
Received: from foss.arm.com ([217.140.110.172]:56286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhDIRqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 13:46:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD1011FB;
        Fri,  9 Apr 2021 10:46:40 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09FC03F792;
        Fri,  9 Apr 2021 10:46:39 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 8/8] arm/arm64: psci: don't assume method
 is hvc
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-9-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <660cfeb4-c411-8335-0351-716a98faf0ae@arm.com>
Date:   Fri, 9 Apr 2021 18:46:33 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-9-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
> The method can also be smc and it will be when running on bare metal.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   arm/selftest.c     | 34 +++++++---------------------------
>   lib/arm/asm/psci.h |  9 +++++++--
>   lib/arm/psci.c     | 17 +++++++++++++++--
>   lib/arm/setup.c    | 22 ++++++++++++++++++++++
>   4 files changed, 51 insertions(+), 31 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 4495b161cdd5..9f459ed3d571 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
>   	exit(report_summary());
>   }
>   
> -static bool psci_check(void)
> +static void psci_print(void)
>   {
> -	const struct fdt_property *method;
> -	int node, len, ver;
> -
> -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
> -	if (node < 0) {
> -		printf("PSCI v0.2 compatibility required\n");
> -		return false;
> -	}
> -
> -	method = fdt_get_property(dt_fdt(), node, "method", &len);
> -	if (method == NULL) {
> -		printf("bad psci device tree node\n");
> -		return false;
> -	}
> -
> -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
> -		printf("psci method must be hvc\n");
> -		return false;
> -	}
> -
> -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
> -				       PSCI_VERSION_MINOR(ver));
> -
> -	return true;
> +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
> +					  PSCI_VERSION_MINOR(ver));
> +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
> +				       "hvc" : "smc");
>   }
>   
>   static void cpu_report(void *data __unused)
> @@ -465,7 +445,7 @@ int main(int argc, char **argv)
>   
>   	} else if (strcmp(argv[1], "smp") == 0) {
>   
> -		report(psci_check(), "PSCI version");
> +		psci_print();
>   		on_cpus(cpu_report, NULL);
>   		while (!cpumask_full(&ready))
>   			cpu_relax();
> diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> index 7b956bf5987d..e385ce27f5d1 100644
> --- a/lib/arm/asm/psci.h
> +++ b/lib/arm/asm/psci.h
> @@ -3,8 +3,13 @@
>   #include <libcflat.h>
>   #include <linux/psci.h>
>   
> -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
> -		       unsigned long arg1, unsigned long arg2);
> +typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
> +			      unsigned long arg1, unsigned long arg2);
> +extern psci_invoke_fn psci_invoke;
> +extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> +			   unsigned long arg1, unsigned long arg2);
> +extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> +			   unsigned long arg1, unsigned long arg2);
>   extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
>   extern void psci_system_reset(void);
>   extern int cpu_psci_cpu_boot(unsigned int cpu);
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 936c83948b6a..46300f30822c 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -11,9 +11,11 @@
>   #include <asm/page.h>
>   #include <asm/smp.h>
>   
> +psci_invoke_fn psci_invoke;
> +
>   __attribute__((noinline))
> -int psci_invoke(unsigned long function_id, unsigned long arg0,
> -		unsigned long arg1, unsigned long arg2)
> +int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> +		    unsigned long arg1, unsigned long arg2)
>   {
>   	asm volatile(
>   		"hvc #0"
> @@ -22,6 +24,17 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
>   	return function_id;
>   }
>   
> +__attribute__((noinline))

Is noinline necessary? We shouldn't be calling psci_invoke_smc and 
psci_invoke_hmc directly, it's unlikely that the compiler will have a 
chance to inline them. But I might be missing something here because I 
don't see why it was there in psci_invoke either.

Otherwise Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> +int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> +		    unsigned long arg1, unsigned long arg2)
> +{
> +	asm volatile(
> +		"smc #0"
> +	: "+r" (function_id)
> +	: "r" (arg0), "r" (arg1), "r" (arg2));
> +	return function_id;
> +}
> +
>   int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
>   {
>   #ifdef __arm__
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 5cda2d919d2b..e595a9e5a167 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -25,6 +25,7 @@
>   #include <asm/processor.h>
>   #include <asm/smp.h>
>   #include <asm/timer.h>
> +#include <asm/psci.h>
>   
>   #include "io.h"
>   
> @@ -55,6 +56,26 @@ int mpidr_to_cpu(uint64_t mpidr)
>   	return -1;
>   }
>   
> +static void psci_set_conduit(void)
> +{
> +	const void *fdt = dt_fdt();
> +	const struct fdt_property *method;
> +	int node, len;
> +
> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,psci-0.2");
> +	assert_msg(node >= 0, "PSCI v0.2 compatibility required");
> +
> +	method = fdt_get_property(fdt, node, "method", &len);
> +	assert(method != NULL && len == 4);
> +
> +	if (strcmp(method->data, "hvc") == 0)
> +		psci_invoke = psci_invoke_hvc;
> +	else if (strcmp(method->data, "smc") == 0)
> +		psci_invoke = psci_invoke_smc;
> +	else
> +		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
> +}
> +
>   static void cpu_set(int fdtnode __unused, u64 regval, void *info __unused)
>   {
>   	int cpu = nr_cpus++;
> @@ -259,6 +280,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>   	mem_regions_add_assumed();
>   	mem_init(PAGE_ALIGN((unsigned long)freemem));
>   
> +	psci_set_conduit();
>   	cpu_init();
>   
>   	/* cpu_init must be called before thread_info_init */
> 
