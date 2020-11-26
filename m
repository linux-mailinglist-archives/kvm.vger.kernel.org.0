Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC52C514A
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 10:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733081AbgKZJao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 04:30:44 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8408 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732405AbgKZJao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 04:30:44 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ChXY95fs7z741P;
        Thu, 26 Nov 2020 17:30:21 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 17:30:31 +0800
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To:     Alexandru Elisei <alexandru.elisei@arm.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <drjones@redhat.com>
CC:     <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
Date:   Thu, 26 Nov 2020 17:30:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-11-alexandru.elisei@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/25 23:51, Alexandru Elisei wrote:
> The reason for the failure is that the test "dev2/eventid=20 now triggers
> an LPI" triggers 2 LPIs, not one. This behavior was present before this
> patch, but it was ignored because check_lpi_stats() wasn't looking at the
> acked array.
> 
> I'm not familiar with the ITS so I'm not sure if this is expected, if the
> test is incorrect or if there is something wrong with KVM emulation.

I think this is expected, or not.

Before INVALL, the LPI-8195 was already pending but disabled. On
receiving INVALL, VGIC will reload configuration for all LPIs targeting
collection-3 and deliver the now enabled LPI-8195. We'll therefore see
and handle it before sending the following INT (which will set the
LPI-8195 pending again).

> Did some more testing on an Ampere eMAG (fast out-of-order cores) using
> qemu and kvmtool and Linux v5.8, here's what I found:
> 
> - Using qemu and gic.flat built from*master*: error encountered 864 times
>    out of 1088 runs.
> - Using qemu: error encountered 852 times out of 1027 runs.
> - Using kvmtool: error encountered 8164 times out of 10602 runs.

If vcpu-3 hadn't seen and handled LPI-8195 as quickly as possible (e.g.,
vcpu-3 hadn't been scheduled), the following INT will set the already
pending LPI-8195 pending again and we'll receive it *once* on vcpu-3.
And we won't see the mentioned failure.

I think we can just drop the (meaningless and confusing?) INT.


Thanks,
Zenghui
