Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148935AAD51
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 13:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiIBLUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 07:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiIBLUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 07:20:22 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC3526548
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 04:20:20 -0700 (PDT)
Date:   Fri, 2 Sep 2022 13:20:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662117618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HNgu9Df3adMDi7xgKeHF7SXAhmudfftHtnrTIV+BzCQ=;
        b=ryX7YZNHQ6shkCVX/4W1B3xRJy+Nn/KMm3u5h0ldHVr0iShnDmq0hi/q+Qi81pPA5gVT+k
        DGUGJONUJWt5drUC8wAn39C+RTXvwTvh+pAo2KrGT3ZQp0j32Y8D6lWucpA3zHPjZJ8MHi
        CERyOznRe/FmFRvXosyJYsgU/NQrpFM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        alex.bennee@linaro.org
Subject: Re: [PATCH v2 1/3] KVM: selftests: Create source of randomness for
 guest code.
Message-ID: <20220902112016.tj2rfcnfse7ly2bj@kamzik>
References: <YwlCGAD2S0aK7/vo@google.com>
 <gsntk06pwo62.fsf@coltonlewis-kvm.c.googlers.com>
 <YxDxagzRx0opmBBy@google.com>
 <YxD4TcxXL38py7NS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxD4TcxXL38py7NS@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 06:22:05PM +0000, Sean Christopherson wrote:
> On Thu, Sep 01, 2022, Ricardo Koller wrote:
> > On Tue, Aug 30, 2022 at 07:01:57PM +0000, Colton Lewis wrote:
> > > David Matlack <dmatlack@google.com> writes:
> > > > I think this is broken if !partition_vcpu_memory_access. nr_randoms
> > > > (per-vCPU) should be `nr_vcpus * vcpu_memory_bytes >> vm->page_shift`.
> > > 
> > > 
> > > Agree it will break then and should not. But allocating that many more
> > > random numbers may eat too much memory. In a test with 64 vcpus, it would
> > > try to allocate 64x64 times as many random numbers. I'll try it but may
> > > need something different in that case.
> > 
> > You might want to reconsider the idea of using a random number generator
> > inside the guest. IRC the reasons against it were: quality of the random
> > numbers, and that some random generators use floating-point numbers. I
> > don't think the first one is a big issue. The second one might be an
> > issue if we want to generate non-uniform distributions (e.g., poisson);
> > but not a problem for now.
> 
> I'm pretty I had coded up a pseudo-RNG framework for selftests at one point, but
> I cant find the code in my morass of branches and stashes :-(

Here's an option that was once proposed by Alex Bennee for kvm-unit-tests.
(Someday we need to revisit that MTTCG series...)

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/2fc51790577c9f91214f72ef51ee5d0e8bbb1b7e

Thanks,
drew

>  
> Whatever we do, make sure the randomness and thus any failures are easily
> reproducible, i.e. the RNG needs to be seeded pseudo-RNG, not fully random.
