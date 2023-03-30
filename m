Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1946CFE4E
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjC3IcB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 30 Mar 2023 04:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjC3Ibd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:31:33 -0400
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F183D6
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:31:00 -0700 (PDT)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: RE: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Topic: [PATCH] x86/kvm: refine condition for checking vCPU preempted
Thread-Index: AQHZVtNJrQ6fv1AjakuDDwKmmMwANK77MVQQgABACwCAAVPt4IAAWJWAgBXD3WA=
Date:   Thu, 30 Mar 2023 08:15:01 +0000
Message-ID: <1c0da615bafa4b238fc028870e23aba2@baidu.com>
References: <20230215121231.43436-1-lirongqing@baidu.com>
 <ZBEOK6ws9wGqof3O@google.com> <01086b8a42ef41659677f7c398109043@baidu.com>
 <ZBHjNuQhqzTx13wX@google.com> <9fccf93dd8be42279ec4c4565b167aa9@baidu.com>
 <ZBMw94f2B1hiNnMC@google.com>
In-Reply-To: <ZBMw94f2B1hiNnMC@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.27]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex15_2023-03-30 16:15:01:519
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.38
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Friday, March 17, 2023 1:01 AM
> To: Li,Rongqing <lirongqing@baidu.com>
> Cc: kvm@vger.kernel.org; x86@kernel.org; Paolo Bonzini
> <pbonzini@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Vitaly
> Kuznetsov <vkuznets@redhat.com>
> Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
> 
> On Thu, Mar 16, 2023, Li,Rongqing wrote:
> > > From: Sean Christopherson <seanjc@google.com> On Wed, Mar 15, 2023,
> > > Li,Rongqing wrote:
> > > > > Rather than have the guest rely on host KVM behavior clearing
> > > > > PV_UNHALT when HLT is passed through), would it make sense to
> > > > > add something like KVM_HINTS_HLT_PASSTHROUGH to more explicitly
> > > > > tell the guest that HLT isn't intercepted?
> > > >
> > > > KVM_HINTS_HLT_PASSTHROUGH is more obvious, but it need both kvm
> > > > and guest support
> > >
> > > Yeah, that's the downside.  But modifying KVM and/or the userspace
> > > VMM shouldn't be difficult, i.e the only meaningful cost is the
> > > rollout of a new kernel/VMM.
> > >
> > > On the other hand, establishing the heuristic that !PV_UNHALT ==
> > > HLT_PASSTHROUGH could have to subtle issues in the future.  It
> > > safe-ish in the context of this patch as userspace is unlikely to
> > > set KVM_HINTS_REALTIME, hide PV_UNHALT, and _not_ passthrough HLT.
> > > But without the REALTIME side of things, !PV_UNHALT ==
> HLT_PASSTHROUGH is much less likely to hold true.
> >
> > Ok, could you submit these codes
> 
> I'd like to hear from others first, especially Paolo and/or Wanpeng.

I see no progress
How about to adopt this patch at first, it can give small performance for existing KVM and setup
Then you continue to modify the kernel/VMM to give better support for KVM/guest

-Li
