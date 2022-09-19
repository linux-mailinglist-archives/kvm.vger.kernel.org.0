Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5325BCECF
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 16:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiISObi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 10:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiISObe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 10:31:34 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F4C2A413
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 07:31:32 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MWRrf6nWmzHnwW;
        Mon, 19 Sep 2022 22:29:22 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:30 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 22:31:29 +0800
Subject: Re: [kvm-unit-tests PATCH v4 08/12] arm: pmu: Test SW_INCR event
 count
To:     Eric Auger <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <maz@kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <andrew.murray@arm.com>, <andre.przywara@arm.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-9-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <64be8eda-a396-26a1-1a05-d43a3ed53c1d@huawei.com>
Date:   Mon, 19 Sep 2022 22:31:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200403071326.29932-9-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

> +static void test_sw_incr(void)
> +{
> +	uint32_t events[] = {SW_INCR, SW_INCR};
> +	int i;
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +		return;
> +
> +	pmu_reset();
> +
> +	write_regn_el0(pmevtyper, 0, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> +	/* enable counters #0 and #1 */
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +
> +	for (i = 0; i < 100; i++)
> +		write_sysreg(0x1, pmswinc_el0);
> +
> +	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> +	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +		"PWSYNC does not increment if PMCR.E is unset");
> +
> +	pmu_reset();
> +
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +
> +	for (i = 0; i < 100; i++)
> +		write_sysreg(0x3, pmswinc_el0);
> +
> +	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");

"counter #0 after + 100 SW_INCR"

> +	report(read_regn_el0(pmevcntr, 1)  == 100,
> +		"counter #0 after + 100 SW_INCR");

"counter #1 after + 100 SW_INCR"

> +	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> +		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> +	report(read_sysreg(pmovsclr_el0) == 0x1,
> +		"overflow reg after 100 SW_INCR");
> +}
> +
>  #endif
>  
>  /*

Zenghui
