Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C005808A1
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 02:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiGZABW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 20:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiGZABJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 20:01:09 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137C21EC5E
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 17:01:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y15so11822055plp.10
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 17:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0dYvPu1lOmSURZ4u1yzsn5bYOoklceFkBHw6I6SfqqE=;
        b=sz3gGFksK1BfrO8x90Bhjlv/p0tPPvagwonKdWEQuRJeX5nF0oNoekwXs9h2vRXUqd
         PaYqu87ZDCZo540HyoopZk6LTHa3e5m1R+A2RQUQ9RMqx2/hsmMWl3PZsIutmjZlhfkf
         a5Gx2f3c3+Q5iPyJMTASG/4OXGocWp2qgTZ+OMIujwYuKYLZ5FmMlmDPNpX0oeWSGgbC
         af7gVPTPcQ2h9Bljguy1e2qOZvSygHOWWqFZKnaPWw70SXSDXmyOz3Bap+gzlrTyYnVi
         rKm6sjJfmWSgyvuhjC+u8sfNspeiDkpNLp7kt2nmwWimuEj0F+1Gv4ZlcimP9nvl0PNh
         5bVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0dYvPu1lOmSURZ4u1yzsn5bYOoklceFkBHw6I6SfqqE=;
        b=7LTcIbVXIRthogeoIf2ObAv3zmIPYcnAOe2iAFBKYtzva0Tsq4yrgpqOguovPGDZyU
         RwLa0uRD8MGCZsp2Mm/f6P/Hgpmo55WVzDZsR7GyORnOLKTLCn46YzpeY3Woy5DJna7A
         GKl1fsb3AoFUNESjJ5X/prAhfOL++x16wYktLsiqr1E4laF4TfjM3+s9aYDuszIo/Xnu
         wZs3D0aOuRV879vkOMhtCWv8KevdqR8deFOJZ5dj198TcCHLdu6vumjVzO2ikfuR4GGF
         M7HRuBnKwYQSdwDQwg7aiC8RIiOjhx5kWOw2KiDLKfXyp/hf3IqB/FKZQmCYAURKv3Eh
         bcTg==
X-Gm-Message-State: AJIora8imJgyViC0zaWmOs4Pf57pDhqYSpdzjtEe63j3Im4Dm3u6M77C
        ys9yQ3K9i56bfzvtkixOFI77vA==
X-Google-Smtp-Source: AGRyM1v3fX8z27lVE4u/pIWm/nIz9V+jtafbKCMd4teZyXoH+xJj3ZjgT6zzJsvERtFbk+h+yNi+hQ==
X-Received: by 2002:a17:90b:4f87:b0:1f2:8a32:ca06 with SMTP id qe7-20020a17090b4f8700b001f28a32ca06mr12286134pjb.242.1658793668453;
        Mon, 25 Jul 2022 17:01:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s27-20020a63525b000000b00419b02043e1sm8906139pgl.38.2022.07.25.17.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 17:01:07 -0700 (PDT)
Date:   Tue, 26 Jul 2022 00:01:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Tag disallowed NX huge pages even
 if they're not tracked
Message-ID: <Yt8uwMt/3JPrSWM9@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-2-seanjc@google.com>
 <Yt8eC2OyolG9QE3g@google.com>
 <Yt8mo6XbT/60UcpS@google.com>
 <CALzav=esXG1yekYk1zCtLt3VGsuGJKYycBhUgtgwiU8w1Anucw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=esXG1yekYk1zCtLt3VGsuGJKYycBhUgtgwiU8w1Anucw@mail.gmail.com>
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

On Mon, Jul 25, 2022, David Matlack wrote:
> On Mon, Jul 25, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
> > The only scenario that jumps to mind is the non-coherent DMA with funky MTRRs
> > case.  There might be others, but it's been a while since I wrote this...
> >
> > The MTRRs are per-vCPU (KVM really should just track them as per-VM, but whatever),
> > so it's possible that KVM could encounter a fault with a lower fault->req_level
> > than a previous fault that set nx_huge_page_disallowed=true (and added the page
> > to the possible_nx_huge_pages list because it had a higher req_level).
> 
> But in that case the lower level SP would already have been installed,
> so we wouldn't end up calling account_nx_huge_page() and getting to
> this point. (account_nx_huge_page() is only called when linking in an
> SP.)

Hrm, true.  I'm 99% certain past me was just maintaining the existing logic in
account_huge_nx_page()

	if (sp->lpage_disallowed)
		return;

Best thing might be to turn that into a WARN as the first patch?

> Maybe account_nx_huge_page() needs to be pulled out and called for
> every SP on the walk during a fault?

Eh, not worth it, the MTRR thing is bogus anyways, e.g. if vCPUs have different
MTRR settings and one vCPU allows a huge page but the other does not, KVM will
may or may not install a huge page depending on which vCPU faults in the page.
