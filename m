Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46586D0EB9
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjC3T0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 15:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjC3T0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 15:26:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAEEF768
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:26:20 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5458201ab8cso200960027b3.23
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680204379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mDqy/zO0+enXcGKLRtxJvV3PzG+7NCTB2uihe9uEug0=;
        b=mD9WiYNFs9YXgVidQOqHiSgxwrALjjNUaPHjjW6zqoRZpR7Cs6nlEsJ/hvqEJoiWlg
         b140NlTl/SZ40i59proI0ioSllElZ7scAm4/PP3JoqxLi4Y0NllW1aAO9jYgmoLF1A8T
         h5oBa08A6IpVVydQ9o0qBcUt7qilVNdp5Rrynkl7V7uTErQlh23ZE2Nu9C6NGaF92rrD
         hBGVuoPFRhY+yUYTuJv3P2rQAzmpJ+PZPAcVJJdBWEWeRVqcPLisa4mJsbeY/JErcqDl
         vW3zz+e26FteeikI7Ryz6Ppp/MeEFlIeEd4lPd4BX8gGyflt1WLDmaMUQJ7AYdHYLHZO
         a1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680204379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mDqy/zO0+enXcGKLRtxJvV3PzG+7NCTB2uihe9uEug0=;
        b=XMwZra985o+shOU17oVbTkYhCwwyp/VNyPnYvmoowBt1niquS1hyiUobsK6ND2/d6l
         Tw68l0CCIMioAxConNgfLxFnZAOrlI5pS8/N86EBp73uOgn7zP3Vhu4dXQv+kiR7Rq18
         3BrLbjr+6gfCZHkPHKua04Yh7vqkpZPV3oQepiQJErExox2j1V0aRzEAOHO1+SDKr+Tw
         xWVyv4wg+FNQGgxmUSiXslWdK/sfZhieNZHLIv1ZOtfJRpbPTJRdddNRB3mSD+smmhL9
         T7S9dmxgfoV1gOEJfIEl8Hz3C7zgueGrhxJZX3AkK4n4//hkmdGPgijHyCejsGx6wLxz
         DyBw==
X-Gm-Message-State: AAQBX9cSxzSOZHQDKuq2r7DAXPd4v89Cprkgv9i5uUX+TK/YKYdpbYnl
        75KPDIYLMvSnPvUbUSnWRZbEdlJbkK0=
X-Google-Smtp-Source: AKy350b1GBuDMn1Vl7DfigbNtIjP1NANBHeZgGWxD6RTFF2Wuh/4DjsO4gY/1LbZJ1WK41EZrRh7za7JpsM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c9:b0:b75:760a:964e with SMTP id
 ck9-20020a05690218c900b00b75760a964emr13187154ybb.13.1680204379810; Thu, 30
 Mar 2023 12:26:19 -0700 (PDT)
Date:   Thu, 30 Mar 2023 12:26:18 -0700
In-Reply-To: <1c0da615bafa4b238fc028870e23aba2@baidu.com>
Mime-Version: 1.0
References: <20230215121231.43436-1-lirongqing@baidu.com> <ZBEOK6ws9wGqof3O@google.com>
 <01086b8a42ef41659677f7c398109043@baidu.com> <ZBHjNuQhqzTx13wX@google.com>
 <9fccf93dd8be42279ec4c4565b167aa9@baidu.com> <ZBMw94f2B1hiNnMC@google.com> <1c0da615bafa4b238fc028870e23aba2@baidu.com>
Message-ID: <ZCXhFdihHNpVTR07@google.com>
Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
From:   Sean Christopherson <seanjc@google.com>
To:     Rongqing Li <lirongqing@baidu.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Li,Rongqing wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > On Thu, Mar 16, 2023, Li,Rongqing wrote:
> > > > From: Sean Christopherson <seanjc@google.com> On Wed, Mar 15, 2023,
> > > > Li,Rongqing wrote:
> > > > > > Rather than have the guest rely on host KVM behavior clearing
> > > > > > PV_UNHALT when HLT is passed through), would it make sense to
> > > > > > add something like KVM_HINTS_HLT_PASSTHROUGH to more explicitly
> > > > > > tell the guest that HLT isn't intercepted?
> > > > >
> > > > > KVM_HINTS_HLT_PASSTHROUGH is more obvious, but it need both kvm
> > > > > and guest support
> > > >
> > > > Yeah, that's the downside.  But modifying KVM and/or the userspace
> > > > VMM shouldn't be difficult, i.e the only meaningful cost is the
> > > > rollout of a new kernel/VMM.
> > > >
> > > > On the other hand, establishing the heuristic that !PV_UNHALT ==
> > > > HLT_PASSTHROUGH could have to subtle issues in the future.  It
> > > > safe-ish in the context of this patch as userspace is unlikely to
> > > > set KVM_HINTS_REALTIME, hide PV_UNHALT, and _not_ passthrough HLT.
> > > > But without the REALTIME side of things, !PV_UNHALT ==
> > HLT_PASSTHROUGH is much less likely to hold true.
> > >
> > > Ok, could you submit these codes
> > 
> > I'd like to hear from others first, especially Paolo and/or Wanpeng.
> 
> I see no progress
> How about to adopt this patch at first, it can give small performance for existing KVM and setup
> Then you continue to modify the kernel/VMM to give better support for KVM/guest

Guest-side KVM stuff is not my maintenance domain, i.e. this needs Paolo's
attention no matter what.
