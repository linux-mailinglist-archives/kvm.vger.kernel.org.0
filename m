Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB557A4674
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbjIRJzA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 18 Sep 2023 05:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbjIRJyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:54:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315E2A6
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 02:54:34 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rq0Q21XVHz6D9BK;
        Mon, 18 Sep 2023 17:49:46 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 10:54:32 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 18 Sep 2023 10:54:31 +0100
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
Subject: RE: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Thread-Topic: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Thread-Index: AQHZ1zeuYuzeI01Cc0itfn6DpxzudLAcj9iAgAPhe+A=
Date:   Mon, 18 Sep 2023 09:54:31 +0000
Message-ID: <731949dbc1d44925af40acc0d4f7650a@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
 <ZQTgi/lsClyM6b1j@linux.dev>
In-Reply-To: <ZQTgi/lsClyM6b1j@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
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
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> Sent: 15 September 2023 23:54
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> catalin.marinas@arm.com; james.morse@arm.com;
> suzuki.poulose@arm.com; yuzenghui <yuzenghui@huawei.com>; zhukeqian
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
> >
> > Introduced a ctx->flag KVM_PGTABLE_WALK_WC_HINT to identify the
> dirty page
> > tracking related write-protect page table walk and used one of the
> "Reserved
> > for software use" bit in page descriptor to mark a page as
> "writeable-clean".
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 25
> ++++++++++++++++++++++---
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h
> b/arch/arm64/include/asm/kvm_pgtable.h
> > index a12add002b89..67bcbc5984f9 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -190,6 +190,8 @@ enum kvm_pgtable_prot {
> >  #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R |
> KVM_PGTABLE_PROT_W)
> >  #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW |
> KVM_PGTABLE_PROT_X)
> >
> > +#define KVM_PGTABLE_PROT_WC	KVM_PGTABLE_PROT_SW0
> /*write-clean*/
> > +
> >  #define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
> >  #define PKVM_HOST_MMIO_PROT	KVM_PGTABLE_PROT_RW
> >
> > @@ -221,6 +223,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64
> addr, u64 end,
> >   *					operations required.
> >   * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute
> update is
> >   *					HW DBM related.
> > + * @KVM_PGTABLE_WALK_WC_HINT:		Update the page as
> writeable-clean(software attribute)
> > + *					if we are write protecting a writeable page.
> 
> This really looks like a permission bit, not a walker flag. This should
> be defined in kvm_pgtable_prot and converted to the hardware definition
> in stage2_set_prot_attr(). Also, the first time I saw 'WC' I read it as
> 'write-combine', not writable-clean.

Ok. I will have a go as suggested above. In fact "writeable-clean" is an
ARM ARM term, I will make it more specific.

> 
> As I understand it, the only need for an additional software bit here is
> to identify neighboring PTEs that can have DBM set while we're in the
> middle of the walk right?

Yes, that is the purpose.

Thanks,
Shameer
