Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F625A04FD
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 02:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiHYALx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 20:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiHYALu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 20:11:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3DD74E30
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:11:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e19so17465855pju.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Kr/iBOV6OACQooe/bjMt6B5RcbZYHiiiJkvuq10TIwM=;
        b=UyQtK3sF6DmfBQiTrHNpCBtmCGNln+g77cqjB0aPsGs0VqwajW4bWNLlUE0dCp0ign
         UIioy1XqL9wFWL+AyFLKjpIY8wFbT0yQwn9s0jR15NI4HmisRJBgiSEC5swnu9mAEvZb
         Bnhs6hkrW/x7reyFhiw29cEOUFCXcJOAdylG9pHX3P9xF62trYvqVDVH/QQIxxCVrVKU
         y6Hd0hcAvTYV8rsKAHJmoxXuYc9MBcIGn9GtjmO5V5HB6B3SK3UMm1PuXgYtgNX+q838
         bQr8VOg1DcYrewJnuW/ic+CCUMR0x8YTMXnZxAksgMHIcX/hXOsrVs0P0eGKlPvbMUNH
         wb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Kr/iBOV6OACQooe/bjMt6B5RcbZYHiiiJkvuq10TIwM=;
        b=a9nyvrQVg0397GYtGCmpL+I1HsBqsg4OnOiM5FbLJo20RtDbHKtYwRJln8whEeoma1
         K1IjkEZNS7RRtz4nXWDdRjprcSDxp6a3b6DG492GKhbvbKnebx2KjWjTK8fDVmD3rNHZ
         as0YrGklo7W7N1k4gNWk3Q77OP1gt+v6Iyqx1JH/ARBDgqE3dXJmWbPnW238LLYs+qx+
         Ws9xZnbAL+sdSa8xwj/b28P6MK2aFXsH1wKqw6Rr2YCSi14rRVzXm9yJcNGpAwzMuKAY
         hjYk6+aR07YykhQaCNZhpk2R5b+AinFUOCCclIHTg4Xne7wZDbfQWupnC6x8MJ2Q59yC
         08SA==
X-Gm-Message-State: ACgBeo05p0ECy8T1TBP1sXN8/YxzD8U+jatFbS07kT4C8TaJREITd4ii
        5wBO6ETjQKtYQ7IdSL8u+kqpkg==
X-Google-Smtp-Source: AA6agR5PJ/jMrZLZNG/UEAyXv5e2OlAqKMnSP/uQmAR7NzvGNeTXHLyQ6mtFuACQBktDzAmoM8g8bg==
X-Received: by 2002:a17:903:32c3:b0:172:b1ca:7bec with SMTP id i3-20020a17090332c300b00172b1ca7becmr1343705plr.41.1661386309182;
        Wed, 24 Aug 2022 17:11:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902d4d000b0016d3935eff0sm13260871plg.176.2022.08.24.17.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 17:11:48 -0700 (PDT)
Date:   Thu, 25 Aug 2022 00:11:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
Message-ID: <Ywa+QL/kDp9ibkbC@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
 <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
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

On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-03 at 10:51 -0700, Mingwei Zhang wrote:
> > On Wed, Aug 3, 2022 at 10:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > On 8/3/22 01:07, Mingwei Zhang wrote:
> > > > +     /*
> > > > +      * We must first get the vmcs12 pages before checking for interrupts
> > > > +      * that might unblock the guest if L1 is using virtual-interrupt
> > > > +      * delivery.
> > > > +      */
> > > > +     if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> > > > +             /*
> > > > +              * If we have to ask user-space to post-copy a page,
> > > > +              * then we have to keep trying to get all of the
> > > > +              * VMCS12 pages until we succeed.
> > > > +              */
> > > > +             if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> > > > +                     kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > > > +                     return 0;
> > > > +             }
> > > > +     }
> > > > +
> > > 
> > > I think request handling (except for KVM_REQ_EVENT) could be more
> > > generically moved from vcpu_enter_guest() to vcpu_run().
> > 
> > Yeah, sounds good to me. I can come up with an updated version. At
> > least, I will remove the repeat request here.
> 
> Now it all makes sense. I do think that KVM_REQ_GET_NESTED_STATE_PAGES processing
> when the vCPU is halted is indeed missing.
> 
> This reminds me that I would be *very* happy to remove the KVM_REQ_GET_NESTED_STATE_PAGES,
> if by any chance there is an agreement to do so upstream.
> This is yet another reason to do so to be honest.
> Just my 0.2 cents of course.

+100

@google folks, what would it take for us to mark KVM_REQ_GET_NESTED_STATE_PAGES
as deprecated in upstream and stop accepting patches/fixes?  IIUC, when we eventually
move to userfaultfd, all this goes away, i.e. we do want to ditch this at some point.
