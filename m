Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70FE63D3FD
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 12:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiK3LJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 06:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbiK3LJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 06:09:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BD214D2D;
        Wed, 30 Nov 2022 03:09:33 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669806571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MvqyMuu+fchlheOOfrdAvjlih/M5WR5M5RpN8mJB+yY=;
        b=ghOwL7RD9WNURgySY1WKVGLrOID94BHn6fpmocLRPbGRFOeKZHUVq9aB3J1ZZ4L8o49VMm
        24ntzPWQ6niPefDsaISX4bF33A92fQvUKU4TXvr4rNVsp991VMrux0YnGJ6Mmsis+jquoG
        h5GvWPk8ZtIsMPgnrFpQaVF+H9vC0xQ6Je6HUmAmeBSEnKstrc7b+ollPuW/kqp1SNZ+V8
        yLBdGqp7SCtsGYvEj+oRBDkMWjh4tj5nPPGm7hx2ojLzWhCUFXqRhNhFlRfhOEgfe8atSS
        oEYpEjYQH6ppvFVmb5vUf+5dAAdcBunc4bvvatyZw2e++1NG5+Nf5X21cyB9kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669806571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MvqyMuu+fchlheOOfrdAvjlih/M5WR5M5RpN8mJB+yY=;
        b=gkI0qz9pbuppHopjt8ePUjiZ2Blkq12mTQAdsyRelbVT7N6T7rH4i8xfXoDnNLOoiGQhyZ
        HIkO9iflOdyoMiCQ==
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
In-Reply-To: <f3826824-3ce6-4317-bc43-e327da2d4417@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <Y30j/EJ9Y1/gWcXo@hirez.programming.kicks-ass.net>
 <f3826824-3ce6-4317-bc43-e327da2d4417@intel.com>
Date:   Wed, 30 Nov 2022 12:09:31 +0100
Message-ID: <87h6ygu2ac.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29 2022 at 13:40, Dave Hansen wrote:
> On 11/22/22 11:33, Peter Zijlstra wrote:
>> Can we get this limitiation removed and simply let the module throw a
>> wobbly (error) when someone tries and use TDX without that logical CPU
>> having been properly initialized?
>
> It sounds like we can at least punt the limitation away from the OS's
> purview.
>
> There's actually a multi-step process to get a "real" TDX module loaded.
>  There's a fancy ACM (Authenticated Code Module) that's invoked via
> GETSEC[ENTERACCS] and an intermediate module loader.  That dance used to
> be done in the kernel, but we talked the BIOS guys into doing it instead.
>
> I believe these per-logical-CPU checks _can_ also be punted out of the
> TDX module itself and delegated to one of these earlier module loading
> phases that the BIOS drives.
>
> I'm still a _bit_ skeptical that the checks are needed in the first
> place.  But, as long as they're hidden from the OS, I don't see a need
> to be too cranky about it.

Right.

> In the end, we could just plain stop doing the TDH.SYS.LP.INIT code in
> the kernel.

Which in turn makes all the problems we discussed go away.

> Unless someone screams, I'll ask the BIOS and TDX module folks to look
> into this.

Yes, please.

Thanks,

        tglx
