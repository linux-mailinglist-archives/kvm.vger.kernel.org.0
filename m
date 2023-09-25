Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFFA7AD2A3
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 10:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjIYIEV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 25 Sep 2023 04:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjIYIET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 04:04:19 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768D8B3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 01:04:12 -0700 (PDT)
Received: from lhrpeml500003.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RvFhH0y0tz6HKDJ;
        Mon, 25 Sep 2023 16:01:51 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 25 Sep 2023 09:04:07 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 25 Sep 2023 09:04:07 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Thread-Topic: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Thread-Index: AQHZ1zeuYuzeI01Cc0itfn6DpxzudLAnFvmAgAQ/2cA=
Date:   Mon, 25 Sep 2023 08:04:06 +0000
Message-ID: <0149ecd0a88c4938b21169182e706fb9@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
        <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
 <ZQ21YYGqcAhOq/UO@arm.com>
In-Reply-To: <ZQ21YYGqcAhOq/UO@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.145.190]
Content-Type: text/plain; charset="iso-8859-1"
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
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: 22 September 2023 16:40
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> oliver.upton@linux.dev; james.morse@arm.com; suzuki.poulose@arm.com;
> yuzenghui <yuzenghui@huawei.com>; zhukeqian
> <zhukeqian1@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously
> writeable pages
> 
> On Fri, Aug 25, 2023 at 10:35:24AM +0100, Shameer Kolothum wrote:
> > We only set DBM if the page is writeable (S2AP[1] == 1). But once
> migration
> > starts, CLEAR_LOG path will write protect the pages (S2AP[1] = 0) and
> there
> > isn't an easy way to differentiate the writeable pages that gets write
> > protected from read-only pages as we only have S2AP[1] bit to check.
> 
> Don't we have enough bits without an additional one?
> 
> writeable: DBM == 1 || S2AP[1] == 1
>   clean: S2AP[1] == 0
>   dirty: S2AP[1] == 1 (irrespective of DBM)
> 
> read-only: DBM == 0 && S2AP[1] == 0
> 
> For S1 we use a software dirty bit as well to track read-only dirty
> mappings but I don't think it is necessary for S2 since KVM unmaps the
> PTE when changing the VMM permission.
> 

We don't set the DBM for all the memory. In order to reduce the overhead
associated with scanning PTEs, this series sets the DBM for the nearby pages
on page fault during the migration phase.

See patch #8,
  user_mem_abort()
     kvm_arm_enable_nearby_hwdbm()

But once migration starts, on CLEAR_LOG path,
   kvm_arch_mmu_enable_log_dirty_pt_masked()
    stage2_wp_range()  --> set the page read only
    kvm_mmu_split_huge_pages() --> split huge pages and pages are read only.

This in effect means there are no writeable-clean near-by pages to set the DBM on
kvm_arm_enable_nearby_hwdbm().

To identify the pages that can be set DBM, we provide a hint to
stage2_wp_range( ) --> kvm_pgtable_stage2_wrprotect() table walker and make
use of a new software bit to mark the PTE as writeable-clean.

Hope, I am clear.

Thanks,
Shameer
 


   



