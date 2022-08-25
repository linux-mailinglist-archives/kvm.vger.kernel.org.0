Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7FE5A148F
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 16:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiHYOnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 10:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242608AbiHYOmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 10:42:45 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3852BB81F4
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 07:41:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d71so18051387pgc.13
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 07:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ZbQl5zmcQJYLrJInunPEiMFIWd9Xor7csOXerZPZEys=;
        b=Y5yVxnEfhqYg2VzNtwH3XMv1GhyAfwGAK9sKYjHECt3tGSTlM8/jHpaJ/RPHG9QSz0
         to4y3mp5uLhUUXaLCxd/nkp+Hmjce8XXsze0vkJhV0dwKK9DUt7jHaQCYY27ATKLgS7A
         jtaiS6QU0ypyCmP0meBxTp6VRT9g6u5PDKGQXpZKgwkpeX5B07/FpfLyetM8EhKI0TdP
         4fHkOuv7ceFmC/Wrbxbmn17N5OPQETlK4iaNPXONDzpmbLTfwtPlwdVHQcxmntM0VBmC
         1pnrH7IlaJ0TqdXPjM/NsN5epj8IIt2UcdiQ0kJc+B9yezkUPKD7RoX6wNmjPMjFgEld
         trXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ZbQl5zmcQJYLrJInunPEiMFIWd9Xor7csOXerZPZEys=;
        b=JeCFTex/v825ZvKCuT6jn7ooUOBaRBrqK61GovlWPBm8Rr1Qz/DaBxVRTULimRU60o
         aM71PkGRa5aYrufGEbs2NJbHLSgG2MFRAonog/p6wH+sfZ88+li78wfOuW2qSTxJLpLS
         v2CVrLnBB6Jnktgn+u/aPAU5uPcCHTQFfbM1UUzcrJmPuI9uwZmlJK4QXmzMSFz6slpz
         Wv+qM5K8JwfValDK0Fy2nLzAHMck0PBKD4BbOYizUa8KHFPvNu2xFnI5NduvnXAkOp7b
         MIji0EtKmAYRHfa/A5PNtum8yNp8WaLLWfRUjdJ3lLLSJ1eqcKqYHjAvE/z4GQJkXpnH
         uVOw==
X-Gm-Message-State: ACgBeo14EikFqBfLT7IYdz8k0GDZ7l1nY/hm+avTECTNPalds/QODOlp
        +84wINHhuZ86CRI6MHvRXxAoow==
X-Google-Smtp-Source: AA6agR4Ka0ia2RlVLxccKqyQLqGJRXHZxx+pW2ufMgWCmxj1CFpAQiHUKWE3BTbxQkewk98fa1GugQ==
X-Received: by 2002:a63:5c42:0:b0:42b:452f:8e66 with SMTP id n2-20020a635c42000000b0042b452f8e66mr3578134pgm.323.1661438463043;
        Thu, 25 Aug 2022 07:41:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v68-20020a626147000000b0052e6c058bccsm13273939pfb.61.2022.08.25.07.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 07:41:02 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:40:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
Message-ID: <YweJ+hX8Ayz11jZi@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
 <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com>
 <Ywa+QL/kDp9ibkbC@google.com>
 <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
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

On Wed, Aug 24, 2022, Jim Mattson wrote:
> On Wed, Aug 24, 2022 at 5:11 PM Sean Christopherson <seanjc@google.com> wrote:
> 
> > @google folks, what would it take for us to mark KVM_REQ_GET_NESTED_STATE_PAGES
> > as deprecated in upstream and stop accepting patches/fixes?  IIUC, when we eventually
> > move to userfaultfd, all this goes away, i.e. we do want to ditch this at some point.
> 
> Userfaultfd is a red herring. There were two reasons that we needed
> this when nested live migration was implemented:
> 1) our netlink socket mechanism for funneling remote page requests to
> a userspace listener was broken.
> 2) we were not necessarily prepared to deal with remote page requests
> during VM setup.
> 
> (1) has long since been fixed. Though our preference is to exit from
> KVM_RUN and get the vCPU thread to request the remote page itself, we
> are now capable of queuing a remote page request with a separate
> listener thread and blocking in the kernel until the page is received.
> I believe that mechanism is functionally equivalent to userfaultfd,
> though not as elegant.
> I don't know about (2). I'm not sure when the listener thread is set
> up, relative to all of the other setup steps. Eliminating
> KVM_REQ_GET_NESTED_STATE_PAGES means that userspace must be prepared
> to fetch a remote page by the first call to KVM_SET_NESTED_STATE. The
> same is true when using userfaultfd.
> 
> These new ordering constraints represent a UAPI breakage, but we don't
> seem to be as concerned about that as we once were. Maybe that's a
> good thing. Can we get rid of all of the superseded ioctls, like
> KVM_SET_CPUID, while we're at it?

I view KVM_REQ_GET_NESTED_STATE_PAGES as a special case.  We are likely the only
users, we can (eventually) wean ourselves off the feature, and we can carry
internal patches (which we are obviously already carrying) until we transition
away.  And unlike KVM_SET_CPUID and other ancient ioctls() that are largely
forgotten, this feature is likely to be a maintenance burden as long as it exists.
