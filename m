Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BFC7987E6
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 15:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbjIHNbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 09:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjIHNbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 09:31:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BC619BC;
        Fri,  8 Sep 2023 06:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TQKWOfY+iS0XtMOemRYfYqcvGehYFsyz+lsbAvmWQBg=; b=IE4IuO3f7ZfICVOmPxBOxmPKMP
        BVvtm3tlC9Fkm6m023ngfZHnP4SnavAeqGqXpMV0meWCcNPgoI4uOXn0+Un9T1CTUtaLFrDIk6tp2
        Mf7opQjS3UB2Lm/YwkrPZt320KhUdv+Xu8824dvzDn9ufum8Bj5LvTES6PUFat9PUf9LYgnptHIpP
        QKcuAp4S/VEPeJj6RzFC7B0o6LTtqTD2VIIpuNNTKCXJFxU/vA1Qf6DShsIbOaWsKlUDlfVGJWqqp
        3LLjicSUT2MrAMTf09bgkh+N/P20mGxQ93DER4zLqktpngI2UoMCBy0d82hR7DN/2+RtwXoS1GM94
        0sSG2uXg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qebZr-002YCs-2e;
        Fri, 08 Sep 2023 13:31:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3FD52300472; Fri,  8 Sep 2023 15:31:15 +0200 (CEST)
Date:   Fri, 8 Sep 2023 15:31:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
Message-ID: <20230908133114.GK19320@noisy.programming.kicks-ass.net>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230905154744.GB28379@noisy.programming.kicks-ass.net>
 <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
 <20230906195619.GD28278@noisy.programming.kicks-ass.net>
 <188f7a79-ad47-eddd-a185-174e0970ad22@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <188f7a79-ad47-eddd-a185-174e0970ad22@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 09:19:51PM +0530, Manali Shukla wrote:

> > I'm not sure I'm fluent in virt speak (in fact, I'm sure I'm not). Is
> > the above saying that a host can never IBS profile a guest?
> 
> Host can profile a guest with IBS if VIBS is disabled for the guest. This is
> the default behavior. Host can not profile guest if VIBS is enabled for guest.
> 
> > 
> > Does the current IBS thing assert perf_event_attr::exclude_guest is set?
> 
> Unlike AMD core pmu, IBS doesn't have Host/Guest filtering capability, thus
> perf_event_open() fails if exclude_guest is set for an IBS event.

Then you must not allow VIBS if a host cpu-wide IBS counter exists.

Also, VIBS reads like it can be (ab)used as a filter.
