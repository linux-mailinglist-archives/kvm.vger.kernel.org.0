Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432D57A4664
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbjIRJwv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 18 Sep 2023 05:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbjIRJwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:52:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BECA8
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 02:52:16 -0700 (PDT)
Received: from lhrpeml500001.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rq0MM6V9Lz6D94m;
        Mon, 18 Sep 2023 17:47:27 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 10:52:13 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 18 Sep 2023 10:52:13 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 2/8] KVM: arm64: Add KVM_PGTABLE_WALK_HW_DBM for HW
 DBM support
Thread-Topic: [RFC PATCH v2 2/8] KVM: arm64: Add KVM_PGTABLE_WALK_HW_DBM for
 HW DBM support
Thread-Index: AQHZ1zeilF9wa540Qk+S//yC7PRGDLAcgkwAgAPj5GA=
Date:   Mon, 18 Sep 2023 09:52:13 +0000
Message-ID: <fa6333bf686646509c3300322fa69642@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-3-shameerali.kolothum.thodi@huawei.com>
 <ZQTVLiFK2dGBd87v@linux.dev>
In-Reply-To: <ZQTVLiFK2dGBd87v@linux.dev>
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
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> Sent: 15 September 2023 23:06
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> catalin.marinas@arm.com; james.morse@arm.com;
> suzuki.poulose@arm.com; yuzenghui <yuzenghui@huawei.com>; zhukeqian
> <zhukeqian1@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 2/8] KVM: arm64: Add
> KVM_PGTABLE_WALK_HW_DBM for HW DBM support
> 
> Hi Shameer,
> 
> On Fri, Aug 25, 2023 at 10:35:22AM +0100, Shameer Kolothum wrote:
> > KVM_PGTABLE_WALK_HW_DBM - Indicates page table walk is for HW
> DBM
> >  related updates.
> >
> > No functional changes here. Only apply any HW DBM bit updates to last
> > level only. These will be used by a future commit where we will add
> > support for HW DBM.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  3 +++
> >  arch/arm64/kvm/hyp/pgtable.c         | 10 ++++++++++
> >  2 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h
> b/arch/arm64/include/asm/kvm_pgtable.h
> > index d3e354bb8351..3f96bdd2086f 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -219,6 +219,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64
> addr, u64 end,
> >   * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table
> entries
> >   *					without Cache maintenance
> >   *					operations required.
> > + * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute
> update is
> > + *					HW DBM related.
> >   */
> >  enum kvm_pgtable_walk_flags {
> >  	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> > @@ -228,6 +230,7 @@ enum kvm_pgtable_walk_flags {
> >  	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
> >  	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
> >  	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
> > +	KVM_PGTABLE_WALK_HW_DBM			= BIT(7),
> >  };
> 
> Rather than making this DBM specific, call it
> KVM_PGTABLE_WALK_FORCE_PTE
> and get rid of stage2_map_data::force_pte. Then it becomes immediately
> obvious what this flag implies.

Ok. Will change accordingly.

Thanks,
Shameer
