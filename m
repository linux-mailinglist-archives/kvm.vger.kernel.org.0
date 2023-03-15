Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21A26BA5E2
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 05:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjCOEHD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Mar 2023 00:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCOEHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 00:07:02 -0400
X-Greylist: delayed 917 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 21:07:00 PDT
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7231D41B5C
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 21:07:00 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: RE: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Topic: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Index: AQHZVtNJrQ6fv1AjakuDDwKmmMwANK77MVQQ
Date:   Wed, 15 Mar 2023 03:49:32 +0000
Message-ID: <01086b8a42ef41659677f7c398109043@baidu.com>
References: <20230215121231.43436-1-lirongqing@baidu.com>
 <ZBEOK6ws9wGqof3O@google.com>
In-Reply-To: <ZBEOK6ws9wGqof3O@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.56
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, March 15, 2023 8:16 AM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: kvm@vger.kernel.org; x86@kernel.org; Paolo Bonzini
> <pbonzini@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Vitaly
> Kuznetsov <vkuznets@redhat.com>
> Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
> 
> +Paolo, Wanpeng, and Vitaly
> 
> In the future, use get_maintainers.pl to build To: and Cc: so that the right folks
> see the patch.  Not everyone habitually scours the KVM list. :-)
> 
Ok

> On Wed, Feb 15, 2023, lirongqing@baidu.com wrote:
> > From: Li RongQing <lirongqing@baidu.com>
> >
> > Check whether vcpu is preempted or not when HLT is trapped or there is
> > not realtime hint.
> 
> Please explain _why_ there's no need to check for preemption in this setup.
> What may be obvious to you isn't necessarily obvious to reviewers or readers.
> 

I will rewrite the changelog

> > In other words, it is unnecessary to check preemption if HLT is not
> > intercepted and guest has realtime hint
> >
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> >  arch/x86/kernel/kvm.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c index
> > 1cceac5..1a2744d 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -820,8 +820,10 @@ static void __init kvm_guest_init(void)
> >  		has_steal_clock = 1;
> >  		static_call_update(pv_steal_clock, kvm_steal_clock);
> >
> > -		pv_ops.lock.vcpu_is_preempted =
> > -			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> > +		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
> 
> Rather than have the guest rely on host KVM behavior clearing PV_UNHALT
> when HLT is passed through), would it make sense to add something like
> KVM_HINTS_HLT_PASSTHROUGH to more explicitly tell the guest that HLT isn't
> intercepted?

KVM_HINTS_HLT_PASSTHROUGH is more obvious, but it need both kvm and guest support

Thanks

-Li

> 
> > +		     !kvm_para_has_hint(KVM_HINTS_REALTIME))
> 
> Misaligned indentation (one too many spaces).
> 
> > +			pv_ops.lock.vcpu_is_preempted =
> > +				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> >  	}
> >
> >  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > --
> > 2.9.4
> >
