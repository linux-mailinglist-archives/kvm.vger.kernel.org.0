Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E377A9AA0
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjIUSqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjIUSqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:46:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A908EE806
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:46:31 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RrqQ62yPlzNnnx;
        Thu, 21 Sep 2023 17:11:10 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 21 Sep 2023 17:14:56 +0800
Subject: Re: [PATCH v2 02/11] KVM: arm64: vgic-its: Treat the collection
 target address as a vcpu_id
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <kvm@vger.kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-3-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d1d5ba61-1fac-a701-38db-b8bd5dcebeb8@huawei.com>
Date:   Thu, 21 Sep 2023 17:14:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230920181731.2232453-3-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/21 2:17, Marc Zyngier wrote:
> Since our emulated ITS advertises GITS_TYPER.PTA=0, the target
> address associated to a collection is a PE number and not
> an address. So far, so good. However, the PE number is what userspace
> has provided given us (aka the vcpu_id), and not the internal vcpu
> index.
> 
> Make sure we consistently retrieve the vcpu by ID rather than
> by index, adding a helper that deals with most of the cases.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks good, with 2 more points:

- Like patch#1, we should have a go at all
  'target_addr >= kvm->online_vcpus' comparisons in vgic-its.c
- There is still a remaining kvm_get_vcpu() in vgic_its_restore_ite()
  which needs to be fixed

Thanks,
Zenghui
