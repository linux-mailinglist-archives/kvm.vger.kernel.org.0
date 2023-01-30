Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8484680855
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbjA3JRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjA3JRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:17:39 -0500
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F9F0166D4;
        Mon, 30 Jan 2023 01:17:35 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 18F7C2200F6;
        Mon, 30 Jan 2023 10:17:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1675070254;
        bh=NdvnNtJBmKggBnVTC20VlVWcPnkhTXkX4lMw5E2q6fw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SQbpOt7SgrJmEl39TNMMzQHHBQ2en4WNAymTD0e0U6iuiRzcaqQXPJKzd/QS+l8eH
         IRsOo/hmLutpBSsd+izIVLJJO7GOrvAKR0f0/7tsV0v8rygMy2PjxKxTH9zXBVLod/
         mIIFCxUgHhcxl9TsLcJDXMXpQCt8aOkPqAmhCse2/RR03dWskEdOc+DKeLJ8L/jAtf
         LGJ1cmqA8fgsXncho3nkN/jdtuqEG3Rmeb0Cq4v9shjKUohQcSP+KLlDlQSz3+mivB
         6FVj/JjvuanISAZ+WODsSuyfSOk98YL9u83t6WtHN87PgMOcxQT2vC2wB9DGkVoKk8
         JqFBi0Memi3XQ==
Date:   Mon, 30 Jan 2023 10:17:32 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9eLLGug11f+kOb+@8bytes.org>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
 <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
 <Y9UolYXFzvocxIcn@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9UolYXFzvocxIcn@8bytes.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 02:52:23PM +0100, Joerg Roedel wrote:
> Yeah, something like this will be the fix. I am still thinking about
> the right place to put the volatile to make it explicit to the situation
> we are encountering here (which is SEV-ES specific).
> 
> Best would be an explicit barrier in C code between sev_es_ist_enter()
> and the DR7 read, but all barriers I tried to far only seem to affect
> memory instructions and had no influence on the DR7 read (which is
> obviously not considered as a memory read by the compiler).
> 
> The best place to put the barrier is in the sev_es_ist_enter() inline
> function, right after the static_call to __sev_es_ist_enter().

Okay, after some investigation I was not able to find a compiler barrier
which affects DR7 read ordering. This leaves us with the only solution
of directly forbidding DR7 register access re-ordering by adding a
volatile to the asm, like you did before.

I will send a fix later today.

Regards,

	Joerg
