Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890945A017A
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 20:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbiHXSkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 14:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiHXSkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 14:40:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8E877EB1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 11:40:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so2535615pjj.4
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 11:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=zKrcyI4NdZI9bZZEmwNsgQE4n+sk2wdFxpPb/RBahho=;
        b=gkBzGho07n2pnXH7iSbrOAxMTv9ZNEy7E4NneT3Q6BJcBU4kqTWYjlho5xKuxnQzOE
         3c/JAdsmNc1lvxS4LAi0aALGSZyJhUE5lNtJ+qkrcrS4DLRO78dxaNRqSOv0nor2JSue
         45GvxRk1T4Di03U9JksAYcTaThEXno/b18BsHGkAGTZ6hBpnPdr7ze9hAjFlrdTVnnSU
         SOSo/kidfJAbokaNSSs0zyu7RjthvY6nhPH7xF2jbdi2RcBTGzhqgWvDufJCJJM9JeRu
         z0TGJugEC7vjwbUsI+sxGROU/wWx4s6nNgjzkC8rN/TZbyOYuOR4iUaq4RIqanprPDG9
         YNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=zKrcyI4NdZI9bZZEmwNsgQE4n+sk2wdFxpPb/RBahho=;
        b=bGaHKMuWGd77yVfzUr+MRIkA9mAcwA1jdbgWSOYqnzs69f+yOp8JvUcZGSBN4Jcml8
         e8vIdWp8UKZZVIPW6lblp8p17SYGQHeo9G/zr4Pt+BpSu18FUeWbOdeuJ853WAoPZz6r
         hxTytzhrpfXoHt/mswzGGDwx1GMGKX/HoPKmbAYW+AAE776zAwN2PugFN3aGmc/H9Uog
         mWsPylz5PkfYoZ7lmqVWfl0gM4EI61G0GduzGBZXEALk2YgMyXO0veQ27Kq8UM/22cEK
         YyV3q3hSqOjBPhuhGTufHy8kN6MI7Mpj1Nezrl4z2fJ6ZO1yOwLBQlxdnP8lNWDoUe1N
         Yobw==
X-Gm-Message-State: ACgBeo0bAhokJmQCJfWQRVo/Qjf89yjixJQdwhlUXuSRYBmD57GUmU/j
        6gN9R0NfpO5Mj39JsLvayeXm5Qcahh6IzQ==
X-Google-Smtp-Source: AA6agR7rwZt6Zsn6B7NcjDmbQ6qvxGRFm9nsc3ccOesJTd/rgd2aVUB7WvutW1Gmt7sbM7jVM3Zqfg==
X-Received: by 2002:a17:90b:3684:b0:1fa:f48e:abd0 with SMTP id mj4-20020a17090b368400b001faf48eabd0mr466684pjb.180.1661366440946;
        Wed, 24 Aug 2022 11:40:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mz16-20020a17090b379000b001f50c1f896esm1780827pjb.5.2022.08.24.11.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 11:40:40 -0700 (PDT)
Date:   Wed, 24 Aug 2022 18:40:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <YwZwpA2Mg+IOprBp@google.com>
References: <20220316005538.2282772-2-oupton@google.com>
 <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
 <YjzBB6GzNGrJdRC2@google.com>
 <Yj5V4adpnh8/B/K0@google.com>
 <YkHwMd37Fo8Zej59@google.com>
 <YkH+X9c0TBSGKtzj@google.com>
 <48030e75b36b281d4441d7dba729889aa9641125.camel@redhat.com>
 <YwY5AxXHAAxjJEPB@google.com>
 <4c7f4ba7d6f4f796a2e7347113b280373a077d8a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c7f4ba7d6f4f796a2e7347113b280373a077d8a.camel@redhat.com>
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

On Wed, Aug 24, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-24 at 14:43 +0000, Sean Christopherson wrote:
> > On Wed, Aug 24, 2022, Maxim Levitsky wrote:
> > > I noticed that 'fix_hypercall_test' selftest fails if run in a VM. The reason is
> > > that L0 patches the hypercall before L1 sees it so it can't really do anything
> > > about it.
> > > 
> > > Do you think we can always stop patching hypercalls for the nested guest regardless
> > > of the quirk, or that too will be considered breaking backwards compatability?
> > 
> > Heh, go run it on Intel, problem solved ;-)
> > 
> > As discussed last year[*], it's impossible to get this right in all cases, ignoring
> > the fact that patching in the first place is arguably wrong.  E.g. if KVM is running
> > on AMD hardware and L0 exposes an Intel vCPU to L1, then it sadly becomes KVM's
> > responsibility to patch L2 because from L1's perspective, a #UD on Intel's VMCALL
> > in L2 is spurious.
> > 
> > Regardless of what path we take, I do think we should align VMX and SVM on exception
> > intercept behavior.
> 
> Maybe then we should at least skip the unit test if running nested (should be
> easy to check the hypervisor cpuid)?

My preference is to keep the test as is.  It's not completely useless in a VM,
e.g. Intel works (currently), non-KVM VMs may or may not work, and VMMs that disable
the quirk in L0 will also work.

max_guest_memory_test is in a similar boat.  Running that in L1 is not recommended
as KVM's shadow paging just can't keep up.  But that doesn't mean that the test
should _never_ be run in L1.

If we have the test skip itself, then opting in requires a code change.  On the
other hand, skipping the test in whatever script is being used to run selftests
is easy enough, e.g. `grep hypervisor /proc/cpuinfo`.  IMO running test via `make`
is a complete mess and should be avoided anyways :-)
