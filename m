Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937EE79B79B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbjIKUtS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 11 Sep 2023 16:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241070AbjIKPBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 11:01:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C249D1B9
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 08:01:12 -0700 (PDT)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RkqYr5q77ztQSJ;
        Mon, 11 Sep 2023 22:57:04 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 11 Sep 2023 23:01:08 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 11 Sep 2023 16:01:06 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        yuzenghui <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: RE: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR
 values
Thread-Topic: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR
 values
Thread-Index: AQHZ4XN765G1jppQP0y0NbhsgeOcJrAVu9Iw
Date:   Mon, 11 Sep 2023 15:01:06 +0000
Message-ID: <ad086272325447c0909e270edeb3e663@huawei.com>
References: <20230907100931.1186690-1-maz@kernel.org>
In-Reply-To: <20230907100931.1186690-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 07 September 2023 11:09
> To: kvmarm@lists.linux.dev; linux-arm-kernel@lists.infradead.org;
> kvm@vger.kernel.org
> Cc: James Morse <james.morse@arm.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>; Oliver Upton <oliver.upton@linux.dev>;
> yuzenghui <yuzenghui@huawei.com>; Xu Zhao <zhaoxu.35@bytedance.com>
> Subject: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR
> values
> 
> Xu Zhao recently reported[1] that sending SGIs on large VMs was slower
> than expected, specially if targeting vcpus that have a high vcpu
> index. They root-caused it to the way we walk the vcpu xarray in the
> search of the correct MPIDR, one vcpu at a time, which is of course
> grossly inefficient.
> 
> The solution they proposed was, unfortunately, less than ideal, but I
> was "nerd snipped" into doing something about it.
> 
> The main idea is to build a small hash table of MPIDR to vcpu
> mappings, using the fact that most of the time, the MPIDR values only
> use a small number of significant bits and that we can easily compute
> a compact index from it. Once we have that, accelerating vcpu lookup
> becomes pretty cheap, and we can in turn make SGIs great again.
> 
> It must be noted that since the MPIDR values are controlled by
> userspace, it isn't always possible to allocate the hash table
> (userspace could build a 32 vcpu VM and allocate one bit of affinity
> to each of them, making all the bits significant). We thus always have
> an iterative fallback -- if it hurts, don't do that.
> 
> Performance wise, this is very significant: using the KUT micro-bench
> test with the following patch (always IPI-ing the last vcpu of the VM)
> and running it with large number of vcpus shows a large improvement
> (from 3832ns to 2593ns for a 64 vcpu VM, a 32% reduction, measured on
> an Ampere Altra). I expect that IPI-happy workloads could benefit from
> this.

Hi Marc,

Tested on a HiSilicon D06 test board using KUT micro-bench(+ the 
changes) with a 64 vCPU VM. From an avg. of 5 runs, observed around
~54% improvement for IPI (from 5309ns to 2413ns).

FWIW,
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer


