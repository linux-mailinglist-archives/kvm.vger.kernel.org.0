Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E547BED93
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 23:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378826AbjJIVts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 17:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377858AbjJIVts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 17:49:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857DD9D;
        Mon,  9 Oct 2023 14:49:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D3AC433C8;
        Mon,  9 Oct 2023 21:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696888186;
        bh=/02JJBzcVaX1DU3waWXi0+UAJ2uTJXrVNatI5QxJLOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F/Xs7FkBE1RhCI+yrZYDvbixH88IPAMRZuA5C5fHFjtdn6wM+kN3H5iHzyXLt5tlY
         RcpQYCPVhMiyUhYkik8kF4FdX14XbCdk8OL2JPKdPBiwWNwKAusqydF1Fj/CV/RzwX
         F+CmAH2GKYl3s0dh6iy/6zpPfvctGccx6P41mdC8glBfMPEzb7h91+REyXxUpjQTN/
         0Nnqs6Te0Fhxvfq1KKg13OnLJ+LShGJQPkCjB1TLfgyrT1rVioW43ZN/nYf75BGp+k
         1avQBEtuCuA779PEPre7yuWs8DS5povIYfG9MToRHA4i+rL++p0I3u1+l8wLR0agsm
         0PiNbzP+m4baw==
Date:   Mon, 9 Oct 2023 14:49:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Christopherson <seanjc@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     pbonzini@redhat.com, workflows@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
Message-ID: <20231009144944.17c8eba3@kernel.org>
In-Reply-To: <ZSRVoYbCuDXc7aR7@google.com>
References: <20231006205415.3501535-1-kuba@kernel.org>
        <ZSQ7z8gqIemJQXI6@google.com>
        <20231009110613.2405ff47@kernel.org>
        <ZSRVoYbCuDXc7aR7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Oct 2023 12:33:53 -0700 Sean Christopherson wrote:
> > We do have sympathy for these folks, we are mostly volunteers after
> > all. At the same time someone's under-investment should not be causing
> > pain to those of us who _do_ build test stuff carefully.  
> 
> This is a bit over the top.  Yeah, I need to add W=1 to my build scripts, but that's
> not a lack of investment, just an oversight.  Though in this case it likely wouldn't
> have made any difference since Paolo grabbed the patches directly and might have
> even bypassed linux-next.  But again I would argue that's bad process, not a lack
> of investment.

If you do invest in build testing automation, why can't your automation
count warnings rather than depend on WERROR? I don't understand.

> > Rather than tweak stuff I'd prefer if we could agree that local -Werror
> > is anti-social :(
> > 
> > The global WERROR seems to be a good compromise.  
> 
> I disagree.  WERROR simply doesn't provide the same coverage.  E.g. it can't be
> enabled for i386 without tuning FRAME_WARN, which (a) won't be at all obvious to
> the average contributor and (b) increasing FRAME_WARN effectively reduces the
> test coverage of KVM i386.
> 
> For KVM x86, I want the rules for contributing to be clearly documented, and as
> simple as possible.  I don't see a sane way to achieve that with WERROR=y.

Linus, you created the global WERROR option. Do you have an opinion
on whether random subsystems should create their own WERROR flags?
W=1 warning got in thru KVM and since they have a KVM_WERROR which
defaults to enabled it broke build testing in networking.
Randomly sprinkled -Werrors are fragile. Can we ask people to stop
using them now that the global ERROR exists?
