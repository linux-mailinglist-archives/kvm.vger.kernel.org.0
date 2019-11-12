Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78EBF940E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 16:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKLPXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 10:23:08 -0500
Received: from foss.arm.com ([217.140.110.172]:35970 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfKLPXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 10:23:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 277391FB;
        Tue, 12 Nov 2019 07:23:07 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31A563F534;
        Tue, 12 Nov 2019 07:23:06 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 07/17] arm: gic: Extend check_acked() to
 allow silent call
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-8-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <25598849-b195-3411-8092-b0656bcfb762@arm.com>
Date:   Tue, 12 Nov 2019 15:23:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-8-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> For future tests we will need to call check_acked() twice for the same
> interrupt (to test delivery of Group 0 and Group 1 interrupts).
> This should be reported as a single test, so allow check_acked() to be
> called with a "NULL" test name, to suppress output. We report the test
> result via the return value, so the outcome is not lost.
>
> Also this amends the new trigger_and_check_spi() wrapper, to propagate
> the test result to callers of that function.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index 3be76cb..63aa9f4 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -62,7 +62,7 @@ static void stats_reset(void)
>  	smp_wmb();
>  }
>  
> -static void check_acked(const char *testname, cpumask_t *mask)
> +static int check_acked(const char *testname, cpumask_t *mask)
>  {
>  	int missing = 0, extra = 0, unexpected = 0;
>  	int nr_pass, cpu, i;
> @@ -91,16 +91,20 @@ static void check_acked(const char *testname, cpumask_t *mask)
>  			}
>  		}
>  		if (!noirqs && nr_pass == nr_cpus) {
> -			report("%s", !bad, testname);
> -			if (i)
> -				report_info("took more than %d ms", i * 100);
> -			return;
> +			if (testname) {
> +				report("%s", !bad, testname);
> +				if (i)
> +					report_info("took more than %d ms",
> +						    i * 100);
> +			}
> +			return i * 100;
>  		}
>  	}
>  
>  	if (noirqs && nr_pass == nr_cpus) {
> -		report("%s", !bad, testname);
> -		return;
> +		if (testname)
> +			report("%s", !bad, testname);
> +		return i * 100;
>  	}
>  
>  	for_each_present_cpu(cpu) {
> @@ -115,9 +119,11 @@ static void check_acked(const char *testname, cpumask_t *mask)
>  		}
>  	}
>  
> -	report("%s", false, testname);
> +	if (testname)
> +		report("%s", false, testname);
>  	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
>  		    missing, extra, unexpected);
> +	return -1;
>  }

check_acked is starting to become hard to read. The function itself is rather
inconsistent, as it mixes regular printf's with report_info's. The return value is
also never used:

$ awk '/check_acked\(/ && !/const/' arm/gic.c
    check_acked("IPI: self", &mask);
    check_acked("IPI: directed", &mask);
    check_acked("IPI: broadcast", &mask);

What I'm thinking is that we can rewrite check_acked to return true/false (or
0/1), meaning success or failure, remove the testname parameter, replace the
printfs to report_info, and have the caller do a report based on the value
returned by check_acked.

Rough version, compile tested only, I'm sure it can be improved:

diff --git a/arm/gic.c b/arm/gic.c
index adb6aa464513..5453f2fd3d5f 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -60,11 +60,11 @@ static void stats_reset(void)
        smp_wmb();
 }
 
-static void check_acked(const char *testname, cpumask_t *mask)
+static bool check_acked(cpumask_t *mask)
 {
        int missing = 0, extra = 0, unexpected = 0;
        int nr_pass, cpu, i;
-       bool bad = false;
+       bool success = true;
 
        /* Wait up to 5s for all interrupts to be delivered */
        for (i = 0; i < 50; ++i) {
@@ -76,22 +76,21 @@ static void check_acked(const char *testname, cpumask_t *mask)
                                acked[cpu] == 1 : acked[cpu] == 0;
 
                        if (bad_sender[cpu] != -1) {
-                               printf("cpu%d received IPI from wrong sender %d\n",
+                               report_info("cpu%d received IPI from wrong sender
%d\n",
                                        cpu, bad_sender[cpu]);
-                               bad = true;
+                               success = false;
                        }
 
                        if (bad_irq[cpu] != -1) {
-                               printf("cpu%d received wrong irq %d\n",
+                               report_info("cpu%d received wrong irq %d\n",
                                        cpu, bad_irq[cpu]);
-                               bad = true;
+                               success = false;
                        }
                }
                if (nr_pass == nr_cpus) {
-                       report("%s", !bad, testname);
                        if (i)
                                report_info("took more than %d ms", i * 100);
-                       return;
+                       return success;
                }
        }
 
@@ -107,9 +106,9 @@ static void check_acked(const char *testname, cpumask_t *mask)
                }
        }
 
-       report("%s", false, testname);
        report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
                    missing, extra, unexpected);
+       return false;
 }
 
 static void check_spurious(void)
@@ -183,13 +182,11 @@ static void ipi_test_self(void)
 {
        cpumask_t mask;
 
-       report_prefix_push("self");
        stats_reset();
        cpumask_clear(&mask);
        cpumask_set_cpu(smp_processor_id(), &mask);
        gic->ipi.send_self();
-       check_acked("IPI: self", &mask);
-       report_prefix_pop();
+       report("self", check_acked(&mask));
 }
 
 static void ipi_test_smp(void)
@@ -203,7 +200,7 @@ static void ipi_test_smp(void)
        for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
                cpumask_clear_cpu(i, &mask);
        gic_ipi_send_mask(IPI_IRQ, &mask);
-       check_acked("IPI: directed", &mask);
+       report("directed", check_acked(&mask));
        report_prefix_pop();
 
        report_prefix_push("broadcast");
@@ -211,7 +208,7 @@ static void ipi_test_smp(void)
        cpumask_copy(&mask, &cpu_present_mask);
        cpumask_clear_cpu(smp_processor_id(), &mask);
        gic->ipi.send_broadcast();
-       check_acked("IPI: broadcast", &mask);
+       report("broadcast", check_acked(&mask));
        report_prefix_pop();
 }
 
I've removed "IPI" from the report string because the prefixed was already pushed
in main.

Andrew, what do you think? Are we missing something obvious? Do you have a better
idea?

>  static void check_spurious(void)
> @@ -567,11 +573,12 @@ static void spi_configure_irq(int irq, int cpu)
>   * Wait for an SPI to fire (or not) on a certain CPU.
>   * Clears the pending bit if requested afterwards.
>   */
> -static void trigger_and_check_spi(const char *test_name,
> +static bool trigger_and_check_spi(const char *test_name,
>  				  unsigned int irq_stat,
>  				  int cpu)

Why did you change the return value from void to bool if you're not using it
anywhere? If it's because you need it in the next patch (#8), please make the
change there.

Thanks,
Alex
>  {
>  	cpumask_t cpumask;
> +	bool ret = true;
>  
>  	stats_reset();
>  	gic_spi_trigger(SPI_IRQ);
> @@ -584,11 +591,13 @@ static void trigger_and_check_spi(const char *test_name,
>  		break;
>  	}
>  
> -	check_acked(test_name, &cpumask);
> +	ret = (check_acked(test_name, &cpumask) >= 0);
>  
>  	/* Clean up pending bit in case this IRQ wasn't taken. */
>  	if (!(irq_stat & IRQ_STAT_NO_CLEAR))
>  		gic_set_irq_bit(SPI_IRQ, GICD_ICPENDR);
> +
> +	return ret;
>  }
>  
>  static void spi_test_single(void)
