Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB37F9494
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfKLPl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 10:41:59 -0500
Received: from foss.arm.com ([217.140.110.172]:36308 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfKLPl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 10:41:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D98611FB;
        Tue, 12 Nov 2019 07:41:58 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8DB03F534;
        Tue, 12 Nov 2019 07:41:57 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 08/17] arm: gic: Add simple SPI MP test
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-9-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f7f11075-4313-dfc7-2e70-07c37fb61531@arm.com>
Date:   Tue, 12 Nov 2019 15:41:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-9-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

What does MP stand for in the subject? Multi-processor? I think changing it to SMP
makes more sense, as that is also in the test name that you've added.

On 11/8/19 2:42 PM, Andre Przywara wrote:
> Shared Peripheral Interrupts (SPI) can target a specific CPU. Test this
> feature by routing the test SPI to each of the vCPUs, then triggering it
> and confirm its reception on that requested core.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index 63aa9f4..304b7b9 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -620,16 +620,45 @@ static void spi_test_single(void)
>  	check_acked("now enabled SPI fires", &cpumask);
>  }
>  
> +static void spi_test_smp(void)
> +{
> +	int cpu;
> +	int cores = 1;
> +
> +	wait_on_ready();
> +	for_each_present_cpu(cpu) {
> +		if (cpu == smp_processor_id())
> +			continue;
> +		spi_configure_irq(SPI_IRQ, cpu);
> +		if (trigger_and_check_spi(NULL, IRQ_STAT_IRQ, cpu))
> +			cores++;
> +		else
> +			report_info("SPI delivery failed on core %d", cpu);
> +	}
> +	report("SPI delievered on all cores", cores == nr_cpus);
> +}
> +
>  static void spi_send(void)
>  {
>  	irqs_enable();
>  
>  	spi_test_single();
>  
> +	if (nr_cpus > 1)
> +		spi_test_smp();
> +
>  	check_spurious();
>  	exit(report_summary());
>  }
>  
> +static void spi_test(void *data __unused)
> +{
> +	if (smp_processor_id() == 0)
> +		spi_send();
> +	else
> +		irq_recv();
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (!gic_init()) {
> @@ -663,7 +692,7 @@ int main(int argc, char **argv)
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "irq") == 0) {
>  		report_prefix_push(argv[1]);
> -		spi_send();
> +		on_cpus(spi_test, NULL);

This is a bit strange. You call on_cpus here, which means you assume that you have
more than one CPU, but then you check if you have more than one CPU in spi_send,
which gets executed on CPU 0.

How about this instead (compile tested only):

diff --git a/arm/gic.c b/arm/gic.c
index 63aa9f4a9fda..7d2443b06ffa 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -620,12 +620,42 @@ static void spi_test_single(void)
        check_acked("now enabled SPI fires", &cpumask);
 }
 
-static void spi_send(void)
+static void spi_test_smp(void)
 {
-       irqs_enable();
+       int cpu;
+       int cores = 1;
+
+       for_each_present_cpu(cpu) {
+               if (cpu == smp_processor_id())
+                       continue;
+               smp_boot_secondary(cpu, irq_recv);
+       }
+       wait_on_ready();
 
+       for_each_present_cpu(cpu) {
+               if (cpu == smp_processor_id())
+                       continue;
+               spi_configure_irq(SPI_IRQ, cpu);
+               if (trigger_and_check_spi(NULL, IRQ_STAT_IRQ, cpu))
+                       cores++;
+               else
+                       report_info("SPI delivery failed on core %d", cpu);
+       }
+       report("SPI delievered on all cores", cores == nr_cpus);
+}
+
+static void spi_test(void)
+{
+       irqs_enable();
        spi_test_single();
+       if (nr_cpus == 1) {
+               report_skip("At least 2 cpus required to run the SPI SMP test");
+               goto out;
+       }
+
+       spi_test_smp();
 
+out:
        check_spurious();
        exit(report_summary());
 }
@@ -663,7 +693,7 @@ int main(int argc, char **argv)
                report_prefix_pop();
        } else if (strcmp(argv[1], "irq") == 0) {
                report_prefix_push(argv[1]);
-               spi_send();
+               spi_test();
                report_prefix_pop();
        } else {
                report_abort("Unknown subtest '%s'", argv[1]);

What do you think?

Thanks,
Alex
>  		report_prefix_pop();
>  	} else {
>  		report_abort("Unknown subtest '%s'", argv[1]);
