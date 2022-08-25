Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD335A182A
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbiHYRxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 13:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiHYRxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 13:53:42 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8A7BC808
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:53:41 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 142so1407769pfu.10
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 10:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=90EPMom+jYdpBxTP3FD4EfoORY6QrTIXIC7G3bK5i0A=;
        b=L6nxnUiDyq/nkQIZIXWZYPZH3qDP9PJR0LwIB/l3ZCG1xLCYkNuv3hLyYuI4kHqTjM
         GuH2KQp6vq+nHI5v/UHpfFq04smWnKN1uTR+e9Ojy8RKoDE6CUQYj2uZXO1n8qiO5fGG
         BN/gOKQvvSrmaJakEHC6SPLv93ys6f31FpPTtFjXlsH4Is9hoaUfozTtaKur/F8KED6T
         UPTpK6y6R0VwV+MRP+ZvSbG71FqS0t0CpSBqgs20NmgV2YpuuMYH0HTDi3e5wLRYyZTH
         BOfNbsA+TcUOd40h0QUwXc/ALQdBnv1maoA4mhdLzP2Fp/LuIl9ZMLYZMYO9x4OxulIc
         gePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=90EPMom+jYdpBxTP3FD4EfoORY6QrTIXIC7G3bK5i0A=;
        b=H3Dot5Y8jE9pU3ub1W8inqNNbh/QGAkQ1clkNOzkKse+H70aHbIABCltli/G78zIIR
         M6L0P/zlV0Lgj/krpJRvyfQkmM14MUU7ubKUG115QGnID7xYpEblsgapOZTHSrudn1ox
         j3ZbkEG+2yvoo8wtU6uO1JGoO4Fg9LHRcjsjGyyntrJgQrL7ur6YEaUb7pKNSwBmk1uG
         0TB3Hysv2NPD83OFj94ffBPHlr6Cpn5ikVAOouQqp6z8/IZ9GW1SB9qlYqYygt4QsKIq
         4gMCPLhEh5exDyrvkHI1Kse+BVi26loDQbrL16iiaHCcJk0+IE7cTV1Vc211gW9Jtd8X
         ypjg==
X-Gm-Message-State: ACgBeo0pjZYa6/Byp7wj48hoOD/cqDs4JLEpJ90NJ8r9AU31w/dcONKK
        pTAFfZrLIPyXpBKv6ZsauTK2mg==
X-Google-Smtp-Source: AA6agR4zpkDCMUp1mZwYSQegasbdZPyw7MXkrTYAZpI7WXZOPru3TM4Ttm+x+vOzwr/vPWHTOnI0Lw==
X-Received: by 2002:a63:4558:0:b0:429:b6e6:6638 with SMTP id u24-20020a634558000000b00429b6e66638mr199821pgk.83.1661450020377;
        Thu, 25 Aug 2022 10:53:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id nh20-20020a17090b365400b001fbc350a223sm538783pjb.55.2022.08.25.10.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 10:53:39 -0700 (PDT)
Date:   Thu, 25 Aug 2022 17:53:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
Message-ID: <Ywe3IC7OlF/jYU1X@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
 <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
 <Ywa+QL/kDp9ibkbC@google.com>
 <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
 <YweJ+hX8Ayz11jZi@google.com>
 <CAL715WK4eqxX9EUHzwqT4o-OX4S_1-WcTr5UuGnc-KEb7pk6EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WK4eqxX9EUHzwqT4o-OX4S_1-WcTr5UuGnc-KEb7pk6EQ@mail.gmail.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Mingwei Zhang wrote:
> On Thu, Aug 25, 2022 at 7:41 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Aug 24, 2022, Jim Mattson wrote:
> > > On Wed, Aug 24, 2022 at 5:11 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > > @google folks, what would it take for us to mark KVM_REQ_GET_NESTED_STATE_PAGES
> > > > as deprecated in upstream and stop accepting patches/fixes?  IIUC, when we eventually
> > > > move to userfaultfd, all this goes away, i.e. we do want to ditch this at some point.
> > >
> > > Userfaultfd is a red herring. There were two reasons that we needed
> > > this when nested live migration was implemented:
> > > 1) our netlink socket mechanism for funneling remote page requests to
> > > a userspace listener was broken.
> > > 2) we were not necessarily prepared to deal with remote page requests
> > > during VM setup.
> > >
> > > (1) has long since been fixed. Though our preference is to exit from
> > > KVM_RUN and get the vCPU thread to request the remote page itself, we
> > > are now capable of queuing a remote page request with a separate
> > > listener thread and blocking in the kernel until the page is received.
> > > I believe that mechanism is functionally equivalent to userfaultfd,
> > > though not as elegant.
> > > I don't know about (2). I'm not sure when the listener thread is set
> > > up, relative to all of the other setup steps. Eliminating
> > > KVM_REQ_GET_NESTED_STATE_PAGES means that userspace must be prepared
> > > to fetch a remote page by the first call to KVM_SET_NESTED_STATE. The
> > > same is true when using userfaultfd.
> > >
> > > These new ordering constraints represent a UAPI breakage, but we don't
> > > seem to be as concerned about that as we once were. Maybe that's a
> > > good thing. Can we get rid of all of the superseded ioctls, like
> > > KVM_SET_CPUID, while we're at it?
> >
> > I view KVM_REQ_GET_NESTED_STATE_PAGES as a special case.  We are likely the only
> > users, we can (eventually) wean ourselves off the feature, and we can carry
> > internal patches (which we are obviously already carrying) until we transition
> > away.  And unlike KVM_SET_CPUID and other ancient ioctls() that are largely
> > forgotten, this feature is likely to be a maintenance burden as long as it exists.
> 
> KVM_REQ_GET_NESTED_STATE_PAGES has been uniformly used in
> KVM_SET_NESTED_STATE ioctl in VMX (including eVMCS) and SVM, it is
> basically a two-step setting up of a nested state mechanism.
> 
> We can change that, but this may have side effects and I think this
> usage case has nothing to do with demand paging.

There are two uses of KVM_REQ_GET_NESTED_STATE_PAGES:

  1. Defer loads when leaving SMM.

  2: Defer loads for KVM_SET_NESTED_STATE.

#1 is fully solvable without a request, e.g. split ->leave_smm() into two helpers,
one that restores whatever metadata is needed before restoring from SMRAM, and
a second to load guest virtualization state that _after_ restoring all other guest
state from SMRAM.

#2 is done because of the reasons Jim listed above, which are specific to demand
paging (including userfaultfd).  There might be some interactions with other
ioctls() (KVM_SET_SREGS?) that are papered over by the request, but that can be
solved without a full request since only the first KVM_RUN after KVM_SET_NESTED_STATE
needs to refresh things (though ideally we'd avoid that).

In other words, if the demand paging use case goes away, then KVM can get rid of
KVM_REQ_GET_NESTED_STATE_PAGES.  

> KVM_SET_NESTED_STATE in VMX, while in SVM implementation, it is simply
> just a kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);

svm_set_nested_state() very rougly open codes enter_svm_guest_mode().  VMX could
do the same, but that may or may not be a net positive.

> hmm... so is the nested_vmx_enter_non_root_mode() call in vmx
> KVM_SET_NESTED_STATE ioctl() still necessary? I am thinking that
> because the same function is called again in nested_vmx_run().

nested_vmx_run() is used only to emulate VMLAUNCH/VMRESUME and wont' be invoked
if the vCPU is already running L2 at the time of migration.
