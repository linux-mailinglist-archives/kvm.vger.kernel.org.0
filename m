Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6220D794403
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 21:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbjIFT4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 15:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242365AbjIFT4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 15:56:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794D51724;
        Wed,  6 Sep 2023 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tNQcoLWY9CzZHv+AXiRRCA7yaPZ7C/eBrW9+xao1bYk=; b=nU1fo0gn6cRebQhnfV67K0ys6o
        JAa/YH3FSm9R+6z2pjiEcXa9HbrD0VlOqAtWKoyI8r31RTASYFBRTV8Lx+umAc9hf6z6mE1W7tAEW
        0UJBYvFecnYMoQY404UkRYxaGqFasx7AybOI7NpCUcZvvpqJp/5p75yseHLrSPSQvUGPaJsPT9uwD
        cKL95XusxbRsadiaVqCdHKjbK3zicvtSpAnJ2O1Clasj7UAsmswcws5WfGUFXqxVTFQYjUCcSzb3n
        Vissht3242FaE7eS2TdEALwwM/2K/1nUsAjZa9FyOSLOiG2d0a+l8sfRrvFAg4qZH6WOVODF1X9BE
        poY0/AOg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qdydP-001Fl5-00;
        Wed, 06 Sep 2023 19:56:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id BD8FA3003F2; Wed,  6 Sep 2023 21:56:19 +0200 (CEST)
Date:   Wed, 6 Sep 2023 21:56:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
Message-ID: <20230906195619.GD28278@noisy.programming.kicks-ass.net>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230905154744.GB28379@noisy.programming.kicks-ass.net>
 <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012c9897-51d7-87d3-e0e5-3856fa9644e5@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023 at 09:08:25PM +0530, Manali Shukla wrote:
> Hi Peter,
> 
> Thank you for looking into this.
> 
> On 9/5/2023 9:17 PM, Peter Zijlstra wrote:
> > On Mon, Sep 04, 2023 at 09:53:34AM +0000, Manali Shukla wrote:
> > 
> >> Note that, since IBS registers are swap type C [2], the hypervisor is
> >> responsible for saving and restoring of IBS host state. Hypervisor
> >> does so only when IBS is active on the host to avoid unnecessary
> >> rdmsrs/wrmsrs. Hypervisor needs to disable host IBS before saving the
> >> state and enter the guest. After a guest exit, the hypervisor needs to
> >> restore host IBS state and re-enable IBS.
> > 
> > Why do you think it is OK for a guest to disable the host IBS when
> > entering a guest? Perhaps the host was wanting to profile the guest.
> > 
> 
> 1. Since IBS registers are of swap type C [1], only guest state is saved
> and restored by the hardware. Host state needs to be saved and restored by
> hypervisor. In order to save IBS registers correctly, IBS needs to be
> disabled before saving the IBS registers.
> 
> 2. As per APM [2],
> "When a VMRUN is executed to an SEV-ES guest with IBS virtualization enabled, the
> IbsFetchCtl[IbsFetchEn] and IbsOpCtl[IbsOpEn] MSR bits must be 0. If either of 
> these bits are not 0, the VMRUN will fail with a VMEXIT_INVALID error code."
> This is enforced by hardware on SEV-ES guests when VIBS is enabled on SEV-ES
> guests.

I'm not sure I'm fluent in virt speak (in fact, I'm sure I'm not). Is
the above saying that a host can never IBS profile a guest?

Does the current IBS thing assert perf_event_attr::exclude_guest is set?

I can't quickly find anything :-(
