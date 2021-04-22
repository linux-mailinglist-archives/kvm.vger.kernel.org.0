Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46549367EEA
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhDVKoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhDVKoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 06:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3FB613C3;
        Thu, 22 Apr 2021 10:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619088214;
        bh=R8WtOHNj+/vk47cusAz7Di0unsa6rOD5nce0ZJvBbNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pv3lOJjOC3h2kDfka9ri27gZcUMB8VEyrTNgwHgulcfk5rxqf4vWQAs+9f4/gOkt4
         q1K3IywZtSZmfuAuIV1QlMAUjPELcnGmE+E6Q026430OI045oc9fdo7XHAtntCWx98
         HrWrGalnCPFn5nmiuwtowUrC/HJgymZi/N/SPpHeF+WemaKXveP8zNQFVsLG2r+1U5
         HbcS8855VzvPFetj1B3nDnzltb2SYqfePUXA1jdPD22flPn/kWQngnV9RR9Z/YwqoY
         26f/HjDjK0J7nMqMw15ZClfInqScIhZ30PQLcQAPeEphwJqk8EnwbzQZC3oFbWjVKj
         m58DmUXn1KEpQ==
Date:   Thu, 22 Apr 2021 11:43:27 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, nathan@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/5] KVM: arm64: Divorce the perf code from oprofile
 helpers
Message-ID: <20210422104327.GC1442@willie-the-truck>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414134409.1266357-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021 at 02:44:05PM +0100, Marc Zyngier wrote:
> KVM/arm64 is the sole user of perf_num_counters(), and really
> could do without it. Stop using the obsolete API by relying on
> the existing probing code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/perf.c     | 7 +------
>  arch/arm64/kvm/pmu-emul.c | 2 +-
>  include/kvm/arm_pmu.h     | 4 ++++
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
> index 739164324afe..b8b398670ef2 100644
> --- a/arch/arm64/kvm/perf.c
> +++ b/arch/arm64/kvm/perf.c
> @@ -50,12 +50,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>  
>  int kvm_perf_init(void)
>  {
> -	/*
> -	 * Check if HW_PERF_EVENTS are supported by checking the number of
> -	 * hardware performance counters. This could ensure the presence of
> -	 * a physical PMU and CONFIG_PERF_EVENT is selected.
> -	 */
> -	if (IS_ENABLED(CONFIG_ARM_PMU) && perf_num_counters() > 0)
> +	if (kvm_pmu_probe_pmuver() != 0xf)

Took me a while to figure out that this returns 0xf if the hardware has a
PMUVer of 0x0, so it's all good:

Acked-by: Will Deacon <will@kernel.org>

Will
