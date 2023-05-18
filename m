Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1ED8707C61
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjERIzO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 18 May 2023 04:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjERIzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 04:55:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32BC1FC2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 01:55:04 -0700 (PDT)
Received: from kwepemm000006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QMNwd0cZkz18LgT;
        Thu, 18 May 2023 16:50:41 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 kwepemm000006.china.huawei.com (7.193.23.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 16:55:01 +0800
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.023;
 Thu, 18 May 2023 09:54:59 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Sean Christopherson" <seanjc@google.com>
Subject: RE: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Topic: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Index: AQHZZwvyoTfThYxWf0yKNVt4c9uQr68cQ2uAgABJ1QCAQm5ckIAAAwIAgAD6+2A=
Date:   Thu, 18 May 2023 08:54:59 +0000
Message-ID: <d04f46d250df46579d640f7e052283fb@huawei.com>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
 <20230404154050.2270077-9-oliver.upton@linux.dev>
 <87o7o26aty.wl-maz@kernel.org> <86pm8iv8tj.wl-maz@kernel.org>
 <fd9aee7022ea47e29cbff3120764c2c6@huawei.com> <ZGUfFn0jai9n4eSF@linux.dev>
In-Reply-To: <ZGUfFn0jai9n4eSF@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.154.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Wednesday, May 17, 2023 7:38 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: Marc Zyngier <maz@kernel.org>; kvmarm@lists.linux.dev;
> kvm@vger.kernel.org; Paolo Bonzini <pbonzini@redhat.com>; James Morse
> <james.morse@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>; yuzenghui
> <yuzenghui@huawei.com>; Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for
> KVM_EXIT_HYPERCALL
> 
> Hi Salil,
> 
> On Wed, May 17, 2023 at 06:00:18PM +0000, Salil Mehta wrote:
> 
> [...]
> 
> > > > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > > > flag?
> >
> >
> > I think we would need "Immediate value" of the ESR_EL2 register in the
> > user-space/VMM to be able to construct the syndrome value. I cannot see
> > where it is being sent?
> 
> The immediate value is not exposed to userspace, although by definition
> the immediate value must be zero. The SMCCC spec requires all compliant
> calls to use an immediate of zero (DEN0028E 2.9).

Sure. I do understand this.

> Is there a legitimate use case for hypercalls with a nonzero immediate?


To be frank I was not sure of this either and therefore I thought it would
be safe to keep the handling in user-space/Qemu generic as it is now by
constructing a syndrome value depending upon immediate value and other
accompanying parameters from the KVM. 

Also, I am not sure what it could break or what platforms it could break.
I think we need some Qemu folks to pitch-in and comment on this.


> They would no longer be considered SMCCC calls at that point, so they
> wouldn't work with the new UAPI.

True. So should we do this change now?


Thanks
Salil


