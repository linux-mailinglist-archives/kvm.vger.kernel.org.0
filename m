Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DDF3602D8
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 08:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhDOG7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 02:59:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16921 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhDOG7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 02:59:54 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FLVXK11HGzjYhv;
        Thu, 15 Apr 2021 14:57:37 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 14:59:26 +0800
Subject: Re: [PATCH 1/5] KVM: arm64: Divorce the perf code from oprofile
 helpers
To:     Marc Zyngier <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-sh@vger.kernel.org>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-2-maz@kernel.org>
CC:     Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>, <nathan@kernel.org>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        <kernel-team@android.com>, Will Deacon <will@kernel.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <baa268cf-c92d-6b97-da4c-e7da2a9ccb7a@huawei.com>
Date:   Thu, 15 Apr 2021 14:59:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210414134409.1266357-2-maz@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/4/14 21:44, Marc Zyngier wrote:
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
The probe() function may be called many times (kvm_arm_pmu_v3_set_attr also calls it).
I don't know whether the first calling is enough. If so, can we use a static variable
in it, so the following calling can return the result right away?

Thanks,
Keqian
