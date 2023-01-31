Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4240868320D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjAaQAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjAaQAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:00:42 -0500
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7064C4FC16;
        Tue, 31 Jan 2023 08:00:37 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id B4843221B65;
        Tue, 31 Jan 2023 17:00:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1675180835;
        bh=f8+N+QlIuIQFbhMVMQyAXaOrIIwv00xABJZc2RkJ2pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mamH11c5t/CDNFa7C/309AitR/ZII/C1ASm+L+zIQ5yioW7LS94mESPbYva6hDl5a
         1X0xVrEqDQKbBzmJAIG7ThhVi+nVt1bjZef4vJGuptnci+GxuTadkp3Zck1N/bWdI6
         MDVUt66wZuXxW1vrFGnLwUIGzdzaw9dKllA2um4Eu4HOVsNyeEZlKv/azsh/9Vw7Vr
         npsf78xoXc4Y35IRY8OilVkX1R5+ATdTZfT1JlUWvAh8OV93lC2erD0k6oJ/WC5zvO
         Q9PR7X4/HnuQfnPcAS37a269TM0zKKVRVT+6Hfm+of8TIAjk3rjZEJ+a6sswXl78w+
         bFhruJwgylOiA==
Date:   Tue, 31 Jan 2023 17:00:29 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9k7HUA85bZKCEVn@8bytes.org>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
 <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
 <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
 <Y9jX9AKYP8H34wGI@8bytes.org>
 <Y9k5g5jYA/rjIwUj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9k5g5jYA/rjIwUj@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 03:53:39PM +0000, Sean Christopherson wrote:
> I don't think that is technically true.  A _well-behaved_ hypervisor will not
> intercept DR0-DR6 accesses for SEV-ES guests, but AFAICT nothing in the SEV-ES
> architecture enforces that behavior.

Not from the hardware architecture side, but the GHCB spec does not
list NAE events for DR0-DR6 accesses, so a guest is not required to
handle them in the VC handler.

Linux under SEV-ES will crash if the HV intercepts debug registers,
except DR7.

Regards,

	Joerg
