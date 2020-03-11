Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B342F18174C
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 12:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgCKL7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 07:59:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729057AbgCKL7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 07:59:19 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 84AEF31DAF8532D5D5B4;
        Wed, 11 Mar 2020 19:59:14 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 19:59:07 +0800
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>
CC:     <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
Date:   Wed, 11 Mar 2020 19:59:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200310145410.26308-11-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/10 22:54, Eric Auger wrote:
> Triggers LPIs through the INT command.
> 
> the test checks the LPI hits the right CPU and triggers
> the right LPI intid, ie. the translation is correct.
> 
> Updates to the config table also are tested, along with inv
> and invall commands.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---

[...]

> +static void test_its_trigger(void)
> +{
> +	struct its_collection *col3, *col2;
> +	struct its_device *dev2, *dev7;
> +
> +	if (its_prerequisites(4))
> +		return;
> +
> +	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
> +	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
> +
> +	col3 = its_create_collection(3 /* col id */, 3/* target PE */);
> +	col2 = its_create_collection(2 /* col id */, 2/* target PE */);
> +
> +	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
> +	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
> +
> +	its_send_invall(col2);
> +	its_send_invall(col3);

These two INVALLs should be issued after col2 and col3 are mapped,
otherwise this will cause the INVALL command error as per the spec
(though KVM doesn't complain it at all).

> +
> +	report_prefix_push("int");
> +	/*
> +	 * dev=2, eventid=20  -> lpi= 8195, col=3
> +	 * dev=7, eventid=255 -> lpi= 8196, col=2
> +	 * Trigger dev2, eventid=20 and dev7, eventid=255
> +	 * Check both LPIs hit
> +	 */
> +
> +	its_send_mapd(dev2, true);
> +	its_send_mapd(dev7, true);
> +
> +	its_send_mapc(col3, true);
> +	its_send_mapc(col2, true);
> +
> +	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
> +	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
> +
> +	lpi_stats_expect(3, 8195);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("dev=2, eventid=20  -> lpi= 8195, col=3");
> +
> +	lpi_stats_expect(2, 8196);
> +	its_send_int(dev7, 255);
> +	check_lpi_stats("dev=7, eventid=255 -> lpi= 8196, col=2");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("inv/invall");
> +
> +	/*
> +	 * disable 8195, check dev2/eventid=20 does not trigger the
> +	 * corresponding LPI
> +	 */
> +	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~LPI_PROP_ENABLED);
> +	its_send_inv(dev2, 20);
> +
> +	lpi_stats_expect(-1, -1);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("dev2/eventid=20 does not trigger any LPI");
> +
> +	/*
> +	 * re-enable the LPI but willingly do not call invall
> +	 * so the change in config is not taken into account.
> +	 * The LPI should not hit
> +	 */
> +	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
> +	lpi_stats_expect(-1, -1);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("dev2/eventid=20 still does not trigger any LPI");
> +
> +	/* Now call the invall and check the LPI hits */
> +	its_send_invall(col3);
> +	lpi_stats_expect(3, 8195);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
> +
> +	report_prefix_pop();
> +
> +	report_prefix_push("mapd valid=false");
> +	/*
> +	 * Unmap device 2 and check the eventid 20 formerly
> +	 * attached to it does not hit anymore
> +	 */
> +
> +	its_send_mapd(dev2, false);
> +	lpi_stats_expect(-1, -1);
> +	its_send_int(dev2, 20);
> +	check_lpi_stats("no LPI after device unmap");
> +	report_prefix_pop();
> +
> +	/* Unmap the collection this time and check no LPI does hit */
> +	report_prefix_push("mapc valid=false");
> +	its_send_mapc(col2, false);

And as for the MAPC, the spec says:

" When V is 0:
Behavior is unpredictable if there are interrupts that are mapped to the
specified collection, with the restriction that further translation
requests from that device are ignored. "

So this collection-unmap test may not make sense?

> +	lpi_stats_expect(-1, -1);
> +	its_send_int(dev7, 255);
> +	check_lpi_stats("no LPI after collection unmap");
> +	report_prefix_pop();
> +}

[...]

Otherwise looks good.


Thanks,
Zenghui

