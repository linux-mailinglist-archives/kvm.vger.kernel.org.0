Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DDB12E9C0
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgABSLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 13:11:17 -0500
Received: from foss.arm.com ([217.140.110.172]:49154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgABSLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 13:11:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99E07328;
        Thu,  2 Jan 2020 10:11:16 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98E8E3F703;
        Thu,  2 Jan 2020 10:11:15 -0800 (PST)
Date:   Thu, 2 Jan 2020 18:11:13 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 05/18] lib: arm/arm64: Remove unused
 CPU_OFF parameter
Message-ID: <20200102181113.7721238e@donnerap.cambridge.arm.com>
In-Reply-To: <1577808589-31892-6-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
        <1577808589-31892-6-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Dec 2019 16:09:36 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> The first version of PSCI required an argument for CPU_OFF, the power_state
> argument, which was removed in version 0.2 of the specification [1].
> kvm-unit-tests supports PSCI 0.2,

You mean kvm-unit-tests *require* PSCI v0.2? I only see explicit checks for that in the PSCI portion of selftests, but not in the other tests using PSCI, for secondary core bringup. Judging by the code we seem to *rely* on the presence of PSCI >= v0.2 via smc (for instance by assuming the v0.2 function IDs), even though this is not documented.

I guess there is little point to provide support for PSCI v0.1, so we should just document this, possibly referring to the explicit PSCI test.

> and KVM ignores any CPU_OFF parameters,
> so let's remove the PSCI_POWER_STATE_TYPE_POWER_DOWN parameter.
>
> [1] ARM DEN 0022D, section 7.3.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Anyway, in case we decide on requiring PSCI v0.2, this seems to be right, so:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm/psci.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index c3d399064ae3..936c83948b6a 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -40,11 +40,9 @@ int cpu_psci_cpu_boot(unsigned int cpu)
>  	return err;
>  }
>  
> -#define PSCI_POWER_STATE_TYPE_POWER_DOWN (1U << 16)
>  void cpu_psci_cpu_die(void)
>  {
> -	int err = psci_invoke(PSCI_0_2_FN_CPU_OFF,
> -			PSCI_POWER_STATE_TYPE_POWER_DOWN, 0, 0);
> +	int err = psci_invoke(PSCI_0_2_FN_CPU_OFF, 0, 0, 0);
>  	printf("CPU%d unable to power off (error = %d)\n", smp_processor_id(), err);
>  }
>  

