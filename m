Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10FA575839
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 02:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiGOAA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 20:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240994AbiGOAAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 20:00:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5405766B91
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 17:00:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e132so2975967pgc.5
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 17:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7kQcbuUpYF4D2BnaWIUhPJeFUYzIn6+Qgr3BLmvM4Yw=;
        b=Ww/hsP1MY82xo12KIVt4OgyeqvT1sRQBHFWuE8zAZHSRmd/pig+6qvG/tUm+17L6Xq
         kOpudqH7nzu0nHLkbvZlGTUMLA2dfpMf/iKXHonqjpTdUm9HXYntGUWpOu8S1ep9s0ap
         SgJ+I0gUVrRwJPfvv7bxqaSEi9tNAL/XHGDxO/qQTrdFxSjqjImw9NH5xNmW4aGQ5KN4
         shUtsd6TrEC5yZyv0AhxuKD0hzzdGOnXIazAI92IRdOZp2cKSVhiLzBOJxypbeIyUMas
         i7N1nnnbSLyvJtmpAJc3JagJQN5r8k/QDU2P2OK68VuW84jUNq9O2VpSoSz80c+lutN9
         RVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7kQcbuUpYF4D2BnaWIUhPJeFUYzIn6+Qgr3BLmvM4Yw=;
        b=oyVPV33bPX6dMgWJ4TAuRVlERwmQcygJovBwXSy8qlSK4nMeK4APLl3OlmTZWiLeef
         bDl8GKFbFj6aq1qkAgFfsJ35LmDt5dWpJ++Mqwp+yUs1xuSi+6LpGNSeKkgrRRwANdAn
         qBYeXquzkz4Ad+aZWlA2FOEeE1/6h/00/c9D/Wqcq3P+3GUePGlad19GoyD+VXAz91r/
         HZTklY5TfC3qd/e1P0d1E1j3hJL9odVcpSx2qouoGrB8ZFplFBgOL/uRiGWPoOr20hon
         vxeVV5bDC8bciSzpXpMPo2PecX5Bvgop0jbcTZBWRI/i0Iszk20DXrBr0haLswng34sD
         m3yg==
X-Gm-Message-State: AJIora8eLlIFMVLJwXJ31llHMlonLS6s81vB1wS0dcinVMLNU8egPJLB
        erBmLUPhFgZHRWvWaBITDxbxng==
X-Google-Smtp-Source: AGRyM1vB1Bx0JIdA2uKlH7N/GZYabyRhn+4zGmjeXbgLfPo6T5PvUMOywAs5A1ZieCWcXkppBuQHvg==
X-Received: by 2002:a05:6a00:998:b0:52a:db4c:541b with SMTP id u24-20020a056a00099800b0052adb4c541bmr10834227pfg.35.1657843249678;
        Thu, 14 Jul 2022 17:00:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w6-20020a17090a780600b001f09d9b6673sm2029731pjk.7.2022.07.14.17.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 17:00:47 -0700 (PDT)
Date:   Fri, 15 Jul 2022 00:00:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix task switch emulation on INTn instruction.
Message-ID: <YtCuK36YnKp/sojH@google.com>
References: <20220714124453.188655-1-mlevitsk@redhat.com>
 <52d44630-21ad-1291-4185-40d5728eaea6@maciej.szmigiero.name>
 <034401953bc935d997c143153938edb1034b52cd.camel@redhat.com>
 <84646f56-dcb0-b0f8-f485-eb0d69a84c9c@maciej.szmigiero.name>
 <YtClmOgBV8j3eDkG@google.com>
 <CALMp9eTZKyFM4oFNJbDDe69xfqtSmj5jZnPbe0aQaxxCvqdFTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTZKyFM4oFNJbDDe69xfqtSmj5jZnPbe0aQaxxCvqdFTA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Jim Mattson wrote:
> On Thu, Jul 14, 2022 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Jul 15, 2022, Maciej S. Szmigiero wrote:
> > > On 14.07.2022 15:57, Maxim Levitsky wrote:
> > > > On Thu, 2022-07-14 at 15:50 +0200, Maciej S. Szmigiero wrote:
> > > > > On 14.07.2022 14:44, Maxim Levitsky wrote:
> > > > > > Recently KVM's SVM code switched to re-injecting software interrupt events,
> > > > > > if something prevented their delivery.
> > > > > >
> > > > > > Task switch due to task gate in the IDT, however is an exception
> > > > > > to this rule, because in this case, INTn instruction causes
> > > > > > a task switch intercept and its emulation completes the INTn
> > > > > > emulation as well.
> > > > > >
> > > > > > Add a missing case to task_switch_interception for that.
> > > > > >
> > > > > > This fixes 32 bit kvm unit test taskswitch2.
> > > > > >
> > > > > > Fixes: 7e5b5ef8dca322 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")
> > > > > >
> > > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > > ---
> > > > >
> > > > > That's a good catch, your patch looks totally sensible to me.
> > > > > People running Win 3.x or OS/2 on top of KVM will surely be grateful for it :)
> > > >
> > > > Yes and also people who run 32 bit kvm unit tests :)
> > >
> > > It looks like more people need to do this regularly :)
> >
> > I do run KUT on 32-bit KVM, but until I hadn't done so on AMD for a long time and
> > so didn't realize the taskswitch2 failure was a regression.  My goal/hope is to
> > we'll get to a state where we're able to run the full gamut of tests before things
> > hit kvm/queue, but the number of permutations of configs and module params means
> > that's easier said than done.
> >
> > Honestly, it'd be a waste of people's time to expect anyone else beyond us few
> > (and CI if we can get there) to test 32-bit KVM.  We do want to keep it healthy
> > for a variety of reasons, but I'm quite convinced that outside of us developers,
> > there's literally no one running 32-bit KVM.
> 
> It shouldn't be necessary to run 32-bit KVM to run 32-bit guests! Or
> am I not understanding the issue that was fixed here?

Ah, no, I'm the one off in the weeds.  I only ever run 32-bit KUT on 32-bit VMs
because I've been too lazy to "cross"-compile.  Time to remedy that...
