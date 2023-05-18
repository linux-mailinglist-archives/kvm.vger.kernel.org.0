Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D8E708100
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 14:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjERMQ3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 18 May 2023 08:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjERMQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 08:16:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D2D186
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 05:16:26 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QMTQf2LRDzLq4S;
        Thu, 18 May 2023 20:13:30 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 kwepemm000005.china.huawei.com (7.193.23.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 20:16:23 +0800
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.023;
 Thu, 18 May 2023 13:16:21 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Oliver Upton <oliver.upton@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "Sean Christopherson" <seanjc@google.com>
Subject: RE: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Topic: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Thread-Index: AQHZZwvyoTfThYxWf0yKNVt4c9uQr68cQ2uAgABJ1QCAQm5ckIAAAwIAgADh0gCAAB5bIP///H2AgAA2qwA=
Date:   Thu, 18 May 2023 12:16:21 +0000
Message-ID: <146e9efc278f4418a21415672715e3f6@huawei.com>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
        <20230404154050.2270077-9-oliver.upton@linux.dev>
        <87o7o26aty.wl-maz@kernel.org>        <86pm8iv8tj.wl-maz@kernel.org>
        <fd9aee7022ea47e29cbff3120764c2c6@huawei.com>
        <ZGUfFn0jai9n4eSF@linux.dev>        <86ilcqkqrf.wl-maz@kernel.org>
        <30eae0208b55463bb644c6700951d4b8@huawei.com>
 <86fs7ukmba.wl-maz@kernel.org>
In-Reply-To: <86fs7ukmba.wl-maz@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, May 18, 2023 10:43 AM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>; kvmarm@lists.linux.dev;
> kvm@vger.kernel.org; Paolo Bonzini <pbonzini@redhat.com>; James Morse
> <james.morse@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>; yuzenghui
> <yuzenghui@huawei.com>; Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for
> KVM_EXIT_HYPERCALL
> 

[...]


> > > > > > > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > > > > > > flag?
> > > > >
> > > > >
> > > > > I think we would need "Immediate value" of the ESR_EL2 register in the
> > > > > user-space/VMM to be able to construct the syndrome value. I cannot see
> > > > > where it is being sent?
> > > >
> > > > The immediate value is not exposed to userspace, although by definition
> > > > the immediate value must be zero. The SMCCC spec requires all compliant
> > > > calls to use an immediate of zero (DEN0028E 2.9).
> > > >
> > > > Is there a legitimate use case for hypercalls with a nonzero immediate?
> > > > They would no longer be considered SMCCC calls at that point, so they
> > > > wouldn't work with the new UAPI.
> > >
> > > I agree. The use of non-zero immediate has long been deprecated. I
> > > guess we should actually reject non-zero immediate for HVC just like
> > > we do for SMC.
> >
> >
> > Ok. Maybe I will hard code Immediate value as 0 to create a syndrome value
> > at the VMM/Qemu and will also put a note stating non-zero immediate for
> > HVC/SVC are not supported/deprecated.
> 
> Yes, because this should be the only situation where you should see
> such an exit to userspace.
> 
> > > If there is an actual need for a non-zero immediate to be propagated
> > > to userspace (want to emulate Xen's infamous 'HVC #0xEA1'?), then this
> > > should be an extension to the current API.
> >
> > Oh ok, then perhaps this new extension change should be simultaneously
> > committed to avoid breaking Xen?
> 
> How would that break Xen? I don't have any plan to emulate Xen in any
> shape or form, and I don't think anyone want to do that in userspace
> either.


Ok. I thought you are suggestion an exception which is already in use
and the current change might break it but now that does not seems to be
the case.


> I really want to see an actual use case to expand this stuff. Because
> so far, we follow the strict SMCCC spec, and nothing else. But if we
> admit deviations, do we also have to expose SMC and HVC as different
> instructions?


Ok got it. No problem and makes sense what you just said. Maybe in future
if it is really required then we can always come back to it. For now, I
will go ahead with the agreed change in the qemu.

Many thanks
Salil.


