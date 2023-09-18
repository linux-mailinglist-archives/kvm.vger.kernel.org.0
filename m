Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA37A49D6
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbjIRMhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241510AbjIRMhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:37:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAEA10D
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:36:57 -0700 (PDT)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rq44T6JnMzrS9t;
        Mon, 18 Sep 2023 20:34:49 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 20:36:53 +0800
Subject: Re: [PATCH] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
To:     Colton Lewis <coltonlewis@google.com>
CC:     <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>, <kvmarm@lists.linux.dev>
References: <20230516213731.387132-1-coltonlewis@google.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5c38294c-7418-2677-aa65-24b67be876cf@huawei.com>
Date:   Mon, 18 Sep 2023 20:36:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230516213731.387132-1-coltonlewis@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/5/17 5:37, Colton Lewis wrote:

> +/*
> + * Should be called with IRQs masked.
> + *
> + * Note that this can hang forever, so we rely on having a timeout mechanism in
> + * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
> + */
> +static void wait_for_non_spurious_irq(void)
> +{
> +	int h;
> +
> +	spin_lock(&shared_data.lock);

You grab the shared_data.lock here...

> +	for (h = shared_data.handled; h == shared_data.handled;) {
> +		asm volatile ("wfi\n"
> +			      "msr daifclr, #2\n"
> +			      /* handle IRQ */

and grab it again in the IRQ handler. How does it work?

> +			      "msr daifset, #2\n":::"memory");
> +	}
> +	spin_unlock(&shared_data.lock);
> +}

[...]

> +static bool parse_args(int argc, char *argv[])
> +{
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "bhi:l:pvw:")) != -1) {
> +		switch (opt) {
> +		case 'b':
> +			test_args.test_physical_only = false;
> +			test_args.test_virtual_only = false;

Missing a 'break'?

Zenghui
