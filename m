Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D225EE6B8
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 22:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiI1Ulw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiI1Ulq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 16:41:46 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497078E4E8
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 13:41:45 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a29so13539962pfk.5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 13:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/NNblFt5ns9rlFXYqtWj/i2oVe4wzb7GDex70CTH3v0=;
        b=P/aBt6mT+WCaCxH+V1KwNWzKbB7UqQc7hOJ+SrXoiUP6ubp4Cu39FkvNm2hllmAfB0
         w9Jbbbu/4BQh6f120aAepVD5D3eQR1HxA3y51AZCci2P2ZWrQS0YM53c+8tYSwi/qvJP
         A1UJHXFG3/ivYmf6DPGn2LSntQb97sdDDGG33lu1+UTJuEuEJjv2eQwcjiNgMB0AvDnL
         VoDQ/JQE4WihBZAk4QfVEJVZg2ufJrXftpMj5t7ACjU/EcjYThRrY7ZiiHXP9eSlSKA3
         G+4spJ83hmlUMdTX9AM55kayOXcDln1AcgJtUIjiaVCwhzcpfl+SocfpC5KmJJaJzvAX
         CGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/NNblFt5ns9rlFXYqtWj/i2oVe4wzb7GDex70CTH3v0=;
        b=YNKVaFBb7eSQmxwUIgB3QmtOxwnfAAw30v8ch/JLRXyyyNryS0sPShuqTMtfqDAbdi
         YYeM8tBLNF8S/Orz8PP27p9Xvja+fNJDfiQjevzKeQbG8PbMgJsvIA8ad9Yx4g5ClpUs
         qKHGGFiVs62xomfbpoQTaArGr6NSJBJ3mSPa8fVYIl0LiH56p2RLGDPlUnhSFmHdfe0v
         /XLehWAGDb6JJQ9vc/0IvCEiDEQIpmbxc/VO7nSg4DTXiVjVOwOYhu0wJ3FTllxQNX1Y
         3+bmz57EaN3SlPYIeO6VU0KBNXWIE0yUSHfm+SsW+Osivb8JAR5qMIHmk0YHymPHhDJy
         rrMg==
X-Gm-Message-State: ACrzQf3a26X0NzSBxlKybTs6iSuJRwAlWWvFQbhWJi2m/vo9t7PZlWXo
        Y733S6205u5p2p4cdPh3PH7g1Q==
X-Google-Smtp-Source: AMsMyM5Z1S2Wcep+jZN4rKjyilbJuYj8aUNFDAXztw9e+n6QT8kw/d5Fn/NEWaPUMulEuIATWBky9w==
X-Received: by 2002:a63:2c6:0:b0:43c:1f18:a475 with SMTP id 189-20020a6302c6000000b0043c1f18a475mr28572736pgc.186.1664397704637;
        Wed, 28 Sep 2022 13:41:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 128-20020a620686000000b0053e4baecc14sm4470151pfg.108.2022.09.28.13.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 13:41:44 -0700 (PDT)
Date:   Wed, 28 Sep 2022 20:41:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Message-ID: <YzSxhHzgNKHL3Cvm@google.com>
References: <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022, Paolo Bonzini wrote:
> On 9/28/22 17:58, Sean Christopherson wrote:
> > I don't disagree that the memslots API is lacking, but IMO that is somewhat
> > orthogonal to fixing KVM x86's "code fetch to MMIO" mess.  Such a massive new API
> > should be viewed and prioritized as a new feature, not as a bug fix, e.g. I'd
> > like to have the luxury of being able to explore ideas beyond "let userspace
> > batch memslot updates", and I really don't want to feel pressured to get this
> > code reviewed and merge.
> 
> I absolutely agree that this is not a bugfix.  Most new features for KVM can
> be seen as bug fixes if you squint hard enough, but they're still features.

I guess I'm complaining that there isn't sufficient justification for this new
feature.  The cover letter provides a bug that would be fixed by having batched
updates, but as above, that's really due to deficiencies in a different KVM ABI.

Beyond that, there's no explanation of why this exact API is necessary, i.e. there
are no requirements given.

  - Why can't this be solved in userspace?

  - Is performance a concern?  I.e. are updates that need to be batched going to
    be high frequency operations?

  - What operations does userspace truly need?  E.g. if the only use case is to
    split/truncate/hole punch an existing memslot, can KVM instead provide a
    memslot flag and exit reason that allows kicking vCPUs to userspace if the
    memslot is accessed?  E.g. KVM_MEM_DISABLED that acts like an invalid memslot,
    but KVM exists with a dedicated exit reason instead of generating MMIO semantics.

  - What precisely needs to be atomic?  If updates only need to be "atomic" for
    an address space, does the API allowing mixing non-SMM and SMM memslots?

  - When is KVM required to invalidate and flush?  E.g. if a memslot is deleted
    and recreated with a different HVA, how does KVM ensure that there are no
    outstanding references to the old HVA without introducing non-determinstic
    behavior.  The current API works by forcing userspace to fully delete the
    memslot, i.e. KVM can ensure all references are gone in all TLBs before
    allowing userspace to create new, conflicting entries.  I don't see how this
    can work with batched updates.  The update needs to be "atomic", i.e. vCPUs
    must never see an invalid/deleted memslot, but if the memslot is writable,
    how does KVM prevent some writes from hitting the old HVA and some from hitting
    the new HVA without a quiescent period?

  - If a memslot is truncated while dirty logging is enabled, what happens to
    the bitmap?  Is it preserved?  Dropped?

Again, I completely agree that the current memslots API is far from perfect, but
I'm not convinced that simply extending the existing API to batch updates is the
best solution from a KVM perspective.

> > E.g. why do a batch update and not provide KVM_SET_ALL_USER_MEMORY_REGIONS to
> > do wholesale replacement?  That seems like it would be vastly simpler to handle
> > on KVM's end.  Or maybe there's a solution in the opposite direction, e.g. an
> > API that allows 1->N or N->1 conversions but not arbitrary batching.
> 
> Wholesale replacement was my first idea when I looked at the issue, I think
> at the end of 2020.  I never got to a full implementation, but my impression
> was that allocating/deallocating dirty bitmaps, rmaps etc. would make it any
> easier than arbitrary batch updates.

It's not obvious to me that the memslot metadata is going to be easy to handle
regardless of what we do.  E.g. I'm pretty sure that batching updates will "corrupt"
the dirty bitmap if a hole is punched in a memslot that's being dirty logged.
