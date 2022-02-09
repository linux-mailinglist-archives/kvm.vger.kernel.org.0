Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214614AF290
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiBINVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 08:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBINVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 08:21:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97107C0613C9;
        Wed,  9 Feb 2022 05:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oeFFjFlQuMCb4LjY09Gt4tIG1cY81yS5diz3DP2Ve1k=; b=BGeyLh/eMBiT+JHvm2PcXjlCcz
        V1VCwafubxlWpyG51odgsFU0b+xm5Jd13JqbQsoWPEahsyrcgZ3JOXJEBg4AKiDCHHGFmwpCc11gg
        Eqj8jNfW4CCkqDMsE9DKma7sjBvklb5C8OsvggKr47rtysYiD1oj9iUuBb1NqAqjBWR2P1Fsu7nMZ
        vNHzA3SoEdJnNLroNJB8+OZIz9go5/JEDO4oBpncQgoljSh1ZMkroeH1KS4MmJoUqePSMJSNt53Q+
        rX1ixwocRSiZy3zEIop5g5xybLde3Dt/S2VNw0qfjLVhmOmAH3VQS8+nOj4r0HnTIpUI0pOE/8WPz
        ks/Mu1/Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHmuf-007mBs-MU; Wed, 09 Feb 2022 13:21:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 50CEA300478;
        Wed,  9 Feb 2022 14:21:36 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2F6FA20218D82; Wed,  9 Feb 2022 14:21:34 +0100 (CET)
Date:   Wed, 9 Feb 2022 14:21:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Message-ID: <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 02:35:45PM -0800, Jim Mattson wrote:
> 3) TDX is going to pull the rug out from under us anyway. When the TDX
> module usurps control of the PMU, any active host counters are going
> to stop counting. We are going to need a way of telling the host perf
> subsystem what's happening, or other host perf clients are going to
> get bogus data.

That's not acceptible behaviour. I'm all for unilaterally killing any
guest that does this.
