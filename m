Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB044656493
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 19:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiLZSWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 13:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiLZSWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 13:22:09 -0500
Received: from out-217.mta0.migadu.com (out-217.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3815A1162
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 10:22:05 -0800 (PST)
Date:   Mon, 26 Dec 2022 19:21:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672078920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cj8fvcXIPRKjdcbdoKyucOKTny9ACesRtz6BgpVcVkM=;
        b=EIWyG69G/AZtzcWq5XIyBUSNRlQZDkyfc0U20LTF9fEMJl0FX0uOlJ/eAr9rqya/camTUG
        P+2F4Zq12xJ+DnTU/groB8gJHKmz/EnZ7/Oqqa66FkhngYxN7a/rJrXobamlTZBnn8glVM
        +7T7V3/Iiag3Ym7nSyg49j/ThSgmh2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <20221226182158.3azk5zwvl2vsy36h@orel>
References: <Y6GRXreBu56PqCyG@monolith.localdoman>
 <gsnt8rj2ghof.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsnt8rj2ghof.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 04:32:00PM +0000, Colton Lewis wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> 
> > Though I'm not sure how you managed to get MAX_SMP to go down to 6 cores
> > on
> > a 12 core machine. MAX_SMP is initialized to $(getconf _NPROCESSORS_ONLN),
> > so the body of the loop should never execute. I also tried it on a 6 core
> > machine, and MAX_SMP was 6, not 3.
> 
> > Am I missing something?
> 
> To be clear, 12 cores was a simplified example I did not directly
> verify. What happened to me was 152 cores being cut down to 4. I was
> confused why one machine was running a test with 4 cores when my other
> machines were running with 8 and traced it to that loop. In effect the
> loop was doing MAX_SMP=floor(MAX_SMP / 2) until MAX_SMP <= 8. I printed
> the iterations and MAX_SMP followed the sequence 152->76->38->19->9->4.

Ah, I think I understand now. Were you running 32-bit arm tests? If so,
it'd be good to point that out explicitly in the commit message (the
'arm:' prefix in the summary is ambiguous).

Assuming the loop body was running because it needed to reduce MAX_SMP to
8 or lower for 32-bit arm tests, then we should be replacing the loop with
something that caps MAX_SMP at 8 for 32-bit arm tests instead.

Thanks,
drew
