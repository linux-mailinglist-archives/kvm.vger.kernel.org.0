Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5F4A7352
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 15:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiBBOhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 09:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiBBOha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 09:37:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE49C061714;
        Wed,  2 Feb 2022 06:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XU4E30VmAk4JZVSbcf6+v7UwHyq1GOzwWQ8ET0wddjk=; b=jcYMyMP7jGlMD5UcB8w29vteKo
        axDDmdgkITjEQUEKPjfRbwb+cLh4JUC8O7fsvZkbGaUFuQ97GqRzqy6xlZdXiII80Y1tR1cgbhZXO
        +qxT1vpIeS4D8wivMA0u0wAqs407UfA5bXisB/WCPZT8cvXtCsaRgm/9ZtoIPUTOk2Bt9Gv8BRVpw
        hh0nlTeEanfep0nRmiXPBzi+vse3rM/4XwU+hB/K6PfYpX42wHN2C11WDHzde7/2ZPxtyx2l2Zbdu
        rY6JKUz7GW6oNMtaqT7XZngshohL41+xTZOsS8dgiuH7Z+1nRF4foFxST2/8mW/edEUpZL2RxeKID
        yRqUtEAA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFGkm-00Enmt-Py; Wed, 02 Feb 2022 14:37:01 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id E8040984C61; Wed,  2 Feb 2022 15:36:57 +0100 (CET)
Date:   Wed, 2 Feb 2022 15:36:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     like.xu.linux@gmail.com, jmattson@google.com, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        mingo@redhat.com, alexander.shishkin@linux.intel.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Message-ID: <20220202143657.GA20638@worktop.programming.kicks-ass.net>
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
 <20220202105158.7072-1-ravi.bangoria@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202105158.7072-1-ravi.bangoria@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 04:21:58PM +0530, Ravi Bangoria wrote:
> +/* Overcounting of Retire Based Events Erratum */
> +static struct event_constraint retire_event_constraints[] __read_mostly = {
> +	EVENT_CONSTRAINT(0xC0, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC1, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC2, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC3, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC4, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC5, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC8, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xC9, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xCA, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xCC, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0xD1, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0x1000000C7, 0x4, AMD64_EVENTSEL_EVENT),
> +	EVENT_CONSTRAINT(0x1000000D0, 0x4, AMD64_EVENTSEL_EVENT),

Can't this be encoded nicer? Something like:

	EVENT_CONSTRAINT(0xC0, 0x4, AMD64_EVENTSEL_EVENT & ~0xF).

To match all of 0xCn ?


> +	EVENT_CONSTRAINT_END
> +};
