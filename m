Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D879B17976B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 19:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgCDSCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 13:02:22 -0500
Received: from foss.arm.com ([217.140.110.172]:38042 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgCDSCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 13:02:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B521C31B;
        Wed,  4 Mar 2020 10:02:21 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 604163F6C4;
        Wed,  4 Mar 2020 10:02:20 -0800 (PST)
Date:   Wed, 4 Mar 2020 18:02:15 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/9] arm: pmu: Add a pmu struct
Message-ID: <20200304180158.4d9e3b8c@donnerap.cambridge.arm.com>
In-Reply-To: <20200130112510.15154-4-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
        <20200130112510.15154-4-eric.auger@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 12:25:04 +0100
Eric Auger <eric.auger@redhat.com> wrote:

> This struct aims at storing information potentially used by
> all tests such as the pmu version, the read-only part of the
> PMCR, the number of implemented event counters, ...
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

As I stated already in v1:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/pmu.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index e5e012d..d24857e 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -33,7 +33,14 @@
>  
>  #define NR_SAMPLES 10
>  
> -static unsigned int pmu_version;
> +struct pmu {
> +	unsigned int version;
> +	unsigned int nb_implemented_counters;
> +	uint32_t pmcr_ro;
> +};
> +
> +static struct pmu pmu;
> +
>  #if defined(__arm__)
>  #define ID_DFR0_PERFMON_SHIFT 24
>  #define ID_DFR0_PERFMON_MASK  0xf
> @@ -265,7 +272,7 @@ static bool check_cpi(int cpi)
>  static void pmccntr64_test(void)
>  {
>  #ifdef __arm__
> -	if (pmu_version == 0x3) {
> +	if (pmu.version == 0x3) {
>  		if (ERRATA(9e3f7a296940)) {
>  			write_sysreg(0xdead, PMCCNTR64);
>  			report(read_sysreg(PMCCNTR64) == 0xdead, "pmccntr64");
> @@ -278,9 +285,22 @@ static void pmccntr64_test(void)
>  /* Return FALSE if no PMU found, otherwise return TRUE */
>  static bool pmu_probe(void)
>  {
> -	pmu_version = get_pmu_version();
> -	report_info("PMU version: %d", pmu_version);
> -	return pmu_version != 0 && pmu_version != 0xf;
> +	uint32_t pmcr;
> +
> +	pmu.version = get_pmu_version();
> +	report_info("PMU version: %d", pmu.version);
> +
> +	if (pmu.version == 0 || pmu.version == 0xF)
> +		return false;
> +
> +	pmcr = get_pmcr();
> +	pmu.pmcr_ro = pmcr & 0xFFFFFF80;
> +	pmu.nb_implemented_counters =
> +		(pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK;
> +	report_info("Implements %d event counters",
> +		    pmu.nb_implemented_counters);
> +
> +	return true;
>  }
>  
>  int main(int argc, char *argv[])

