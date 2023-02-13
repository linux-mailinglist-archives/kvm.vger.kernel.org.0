Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB816946A6
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 14:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjBMNLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 08:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjBMNLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 08:11:21 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32BE1ADF8;
        Mon, 13 Feb 2023 05:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sY0Xw97tkK80XNIR32EODzqw53Y3bbnKuPghntbXvNM=; b=naakW9McTESgZUSXJL5EEszbPv
        5s89w5K+4FYADoJObYVIcxzM+mVhIROms2qhFrQpm92rlt1ycJUrdtyYh8dHrq8F3kk5J1Mp+SurC
        iHN4INvuOVfINKgJ/Gv8tCxehyqpZOFvw5TrYBzqYJ45fDI3BHIukQNsND0v3WjOza9kl1jYB3+YM
        p/4zTdQde4wNyAVDOi1LumVI0uAy/dvMa48pyV/JM2A3iietbnBaYK45o6ArSADz+N21NwlLBWuJF
        H4xSanFzENWT4SngvrApgnZa0i6CkVs1D0mKVqs3ogdY9qQJrjGBuc4nufQRQ/HsOSQIyJ52RmbYB
        d/rgW0NA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRYb0-009J8f-2S;
        Mon, 13 Feb 2023 13:10:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2306030020C;
        Mon, 13 Feb 2023 14:10:55 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F0907209F7549; Mon, 13 Feb 2023 14:10:54 +0100 (CET)
Date:   Mon, 13 Feb 2023 14:10:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     linux-kernel@vger.kernel.org, mingo@redhat.com, acme@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        sandipan.das@amd.com, jmattson@google.com, thomas.lendacky@amd.com,
        nikunj@amd.com, ravi.bangoria@amd.com, eranian@google.com,
        irogers@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH kernel 1/2] perf/x86/amd: Add
 amd_prevent_hostibs_window() to set per-cpu ibs_flags
Message-ID: <Y+o23lcYHbYWua62@hirez.programming.kicks-ass.net>
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <20230206060545.628502-2-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206060545.628502-2-manali.shukla@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 06:05:44AM +0000, Manali Shukla wrote:
> Add a function to set per-cpu ibs_flags based on an active or inactive
> PreventHostIBS window.
> 
> MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn] bits
> need to be cleared for PreventHostIBS feature to be enabled before VMRUN
> is executed.
> 
> ENABLE bit and VALID bit for MSR_AMD64_IBSFETCHCTL are contained in the
> same MSR and same is the case with MSR_AMD64_IBSOPCTL.
> 
> Consider the following scenario:
> - The IBS MSR which has ENABLE bit set and VALID bit clear is read.
> - During the process of clearing the ENABLE bit and writing the IBS MSR
>   to disable IBS, an IBS event can occur that sets the VALID bit.
> - The write operation on IBS MSR can clear the newly set VALID bit.
> - Since this situation is occurring in the CLGI/STGI window
>   (PreventHostIBS window), the actual NMI is not taken.
> - Once VMRUN is issued, it will exit with VMEXIT_NMI. As soon as STGI is
>   executed, the pending NMI will trigger.
> - The IBS NMI handler checks for the VALID bit to determine if the NMI
>   is generated because of IBS.
> - Since VALID bit is now clear, it doesn't recognize that an IBS event
>   is occurred. Due to this reason, the dazed and confused unknown NMI
>   messages are generated.
> 
> amd_prevent_hostibs_window() is added to avoid these messages when
> PreventHostIBS window is active and PreventHostIBS feature is enabled
> for the guest.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>

URGH... so am I reading this right that this is a sodding terrible
software implementation of perf_event_attr::exclude_guest ?
