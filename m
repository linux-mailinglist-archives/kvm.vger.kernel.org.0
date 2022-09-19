Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68445BCEE9
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiISOcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 10:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiISOb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 10:31:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8048932DA9
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 07:31:54 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWRpq386lzlW1m;
        Mon, 19 Sep 2022 22:27:47 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:51 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:50 +0800
Subject: Re: [kvm-unit-tests PATCH v4 10/12] arm: pmu: test 32-bit <-> 64-bit
 transitions
To:     Eric Auger <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <maz@kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <andrew.murray@arm.com>, <andre.przywara@arm.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-11-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cead0930-958d-222d-d5c0-6dfe6f88f52f@huawei.com>
Date:   Mon, 19 Sep 2022 22:31:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200403071326.29932-11-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/4/3 15:13, Eric Auger wrote:

> +static void test_chain_promotion(void)
> +{

[...]

> +	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
> +	pmu_reset();
> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
> +	isb();
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn_el0(pmevcntr, 0));
> +
> +	/* 0 becomes CHAINED */

"1 becomes CHAINED"?

> +	write_sysreg_s(0x0, PMCNTENSET_EL0);

Writing 0 into PMCNTENSET_EL0 actually has no effect on the counter
status. What purpose does this serve?

> +	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn_el0(pmevcntr, 1, 0x0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn_el0(pmevcntr, 0));
> +
> +	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> +		"32b->64b: CHAIN counter incremented and no overflow");
> +
> +	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> +		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> +
> +	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
> +	pmu_reset();
> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("counter #0=0x%lx, counter #1=0x%lx",
> +			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> +
> +	write_sysreg_s(0x0, PMCNTENSET_EL0);

Ditto

> +	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(read_sysreg(pmovsclr_el0) == 1,
> +		"overflow is expected on counter 0");
> +	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
> +			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
> +			read_sysreg(pmovsclr_el0));
> +}
> +
>  #endif
>  
>  /*

Zenghui
