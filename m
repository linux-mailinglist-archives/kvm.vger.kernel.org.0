Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE7160552C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 03:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiJTBsm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 19 Oct 2022 21:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiJTBsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 21:48:41 -0400
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D594D1D2985
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 18:48:39 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: RE: [PATCH][RFC] KVM: x86: Don't reset deadline to period when timer
 is in one shot mode
Thread-Topic: [PATCH][RFC] KVM: x86: Don't reset deadline to period when timer
 is in one shot mode
Thread-Index: AQHY3lSBV3JkMQGyf0Sj/LaU+iedy64SXz/ggAMD4ACAASKXAA==
Date:   Thu, 20 Oct 2022 01:17:05 +0000
Message-ID: <8fffcf467eb442389b302a9a3071e1a8@baidu.com>
References: <1665579268-7336-1-git-send-email-lirongqing@baidu.com>
 <Y0bl2WjoG12WcCPv@google.com> <94584fc76a5f41629febc53615f82b6f@baidu.com>
 <Y1AdgCyCPINaTCgA@google.com>
In-Reply-To: <Y1AdgCyCPINaTCgA@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.53
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
> Sent: Wednesday, October 19, 2022 11:54 PM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: kvm@vger.kernel.org; Peter Shier <pshier@google.com>; Jim Mattson
> <jmattson@google.com>; Wanpeng Li <wanpengli@tencent.com>
> Subject: Re: [PATCH][RFC] KVM: x86: Don't reset deadline to period when timer
> is in one shot mode
> 
> On Mon, Oct 17, 2022, Li,Rongqing wrote:
> > > +Jim, Peter, and Wanpeng
> > >
> > > On Wed, Oct 12, 2022, Li RongQing wrote:
> > > > In one-shot mode, the APIC timer stops counting when the timer
> > > > reaches zero, so don't reset deadline to period for one shot mode
> > > >
> > > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > > 9dda989..bf39027 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -1840,8 +1840,12 @@ static bool set_target_expiration(struct
> > > > kvm_lapic
> > > *apic, u32 count_reg)
> > > >  		if (unlikely(count_reg != APIC_TMICT)) {
> > > >  			deadline = tmict_to_ns(apic,
> > > >  				     kvm_lapic_get_reg(apic, count_reg));
> > > > -			if (unlikely(deadline <= 0))
> > > > -				deadline = apic->lapic_timer.period;
> > > > +			if (unlikely(deadline <= 0)) {
> > > > +				if (apic_lvtt_period(apic))
> > > > +					deadline = apic->lapic_timer.period;
> > > > +				else
> > > > +					deadline = 0;
> > > > +			}
> > >
> > > This is not the standard "count has reached zero" path, it's the
> > > "vCPU is migrated and the timer needs to be resumed on the destination"
> path.
> > > Zeroing the deadline here will not squash the timer, IIUC it will
> > > cause the timer to immediately fire.
> > >
> > > That said, I think the patch is actually correct
> >
> > Should we set deadline to 0 when it is expired whether the timer is
> > one shot mode or period mode ?
> 
> I'm not sure I follow the question.  Are you asking if this path should set the
> deadline to '0' even if the timer is in periodic mode?

Yes

-Li

