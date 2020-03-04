Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881FC179767
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 19:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgCDSBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 13:01:53 -0500
Received: from foss.arm.com ([217.140.110.172]:38022 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgCDSBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 13:01:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4703931B;
        Wed,  4 Mar 2020 10:01:52 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0A7E3F6C4;
        Wed,  4 Mar 2020 10:01:50 -0800 (PST)
Date:   Wed, 4 Mar 2020 18:01:44 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/9] arm: pmu: Let pmu tests take a
 sub-test parameter
Message-ID: <20200304180144.51fe2852@donnerap.cambridge.arm.com>
In-Reply-To: <20200130112510.15154-3-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
        <20200130112510.15154-3-eric.auger@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 12:25:03 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> As we intend to introduce more PMU tests, let's add
> a sub-test parameter that will allow to categorize
> them. Existing tests are in the cycle-counter category.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Did you change anything? Or just forgot to add my previous R-b?

Anyway,

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/pmu.c         | 24 +++++++++++++++---------
>  arm/unittests.cfg |  7 ++++---
>  2 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index d5a03a6..e5e012d 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -287,22 +287,28 @@ int main(int argc, char *argv[])
>  {
>  	int cpi = 0;
>  
> -	if (argc > 1)
> -		cpi = atol(argv[1]);
> -
>  	if (!pmu_probe()) {
>  		printf("No PMU found, test skipped...\n");
>  		return report_summary();
>  	}
>  
> +	if (argc < 2)
> +		report_abort("no test specified");
> +
>  	report_prefix_push("pmu");
>  
> -	report(check_pmcr(), "Control register");
> -	report(check_cycles_increase(),
> -	       "Monotonically increasing cycle count");
> -	report(check_cpi(cpi), "Cycle/instruction ratio");
> -
> -	pmccntr64_test();
> +	if (strcmp(argv[1], "cycle-counter") == 0) {
> +		report_prefix_push(argv[1]);
> +		if (argc > 2)
> +			cpi = atol(argv[2]);
> +		report(check_pmcr(), "Control register");
> +		report(check_cycles_increase(),
> +		       "Monotonically increasing cycle count");
> +		report(check_cpi(cpi), "Cycle/instruction ratio");
> +		pmccntr64_test();
> +	} else {
> +		report_abort("Unknown sub-test '%s'", argv[1]);
> +	}
>  
>  	return report_summary();
>  }
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index daeb5a0..79f0d7a 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -61,21 +61,22 @@ file = pci-test.flat
>  groups = pci
>  
>  # Test PMU support
> -[pmu]
> +[pmu-cycle-counter]
>  file = pmu.flat
>  groups = pmu
> +extra_params = -append 'cycle-counter 0'
>  
>  # Test PMU support (TCG) with -icount IPC=1
>  #[pmu-tcg-icount-1]
>  #file = pmu.flat
> -#extra_params = -icount 0 -append '1'
> +#extra_params = -icount 0 -append 'cycle-counter 1'
>  #groups = pmu
>  #accel = tcg
>  
>  # Test PMU support (TCG) with -icount IPC=256
>  #[pmu-tcg-icount-256]
>  #file = pmu.flat
> -#extra_params = -icount 8 -append '256'
> +#extra_params = -icount 8 -append 'cycle-counter 256'
>  #groups = pmu
>  #accel = tcg
>  

