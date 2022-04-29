Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CABF51563B
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 22:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381126AbiD2VCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381021AbiD2VCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:02:39 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1740BD3AC7;
        Fri, 29 Apr 2022 13:59:20 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9FC4A1EC04F9;
        Fri, 29 Apr 2022 22:59:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651265954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rPJVnQz6WF2XoLt4utpn31qFBRwN/546ceU9c3UQzGU=;
        b=kGe8jU74DWllVPfCw4W7ntEWJl1ihsW5MjcDTA0/xI8/8pevBoR+E7XnOSoxA3ppfYEh0Q
        HsJz3nL93vU+czeu9YQZzSk/K0Af1sFpwN13hxS2RdBmL2hOOPclep7QFg2DQW5dNxCJmG
        5T0gcKhlWFjL2coD7uPW4cWacibqYUQ=
Date:   Fri, 29 Apr 2022 22:59:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <YmxRnwSUBIkOIjLA@zn.tnic>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YmxKqpWFvdUv+GwJ@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 08:29:30PM +0000, Sean Christopherson wrote:
> That's why there's a bunch of hand-waving.

Well, I'm still not sure what this patch is trying to fix but both your
latest replies do sound clearer...

> Can you clarify what "this" is?  Does "this" mean "this patch", or does it mean

This patch.

> "this IBPB when switching vCPUs"?  Because if it means the latter, then I think
> you're in violent agreement; the IBPB when switching vCPUs is pointless and
> unnecessary.

Ok, let's concentrate on the bug first - whether a second IBPB - so to
speak - is needed. Doing some git archeology points to:

  15d45071523d ("KVM/x86: Add IBPB support")

which - and I'm surprised - goes to great lengths to explain what
those IBPB calls in KVM protect against. From that commit message, for
example:

"    * Mitigate attacks from guest/ring3->host/ring3.
      These would require a IBPB during context switch in host, or after
      VMEXIT."

so with my very limited virt understanding, when you vmexit, you don't
do switch_mm(), right?

If so, you need to do a barrier. Regardless of conditional IBPB or not
as you want to protect the host from a malicious guest.

In general, the whole mitigation strategies are enumerated in

Documentation/admin-guide/hw-vuln/spectre.rst

There's also a "3. VM mitigation" section.

And so on...

Bottomline is this: at the time, we went to great lengths to document
what the attacks are and how we are protecting against them.

So now, if you want to change all that, I'd like to see

- the attack scenario is this

- we don't think it is relevant because...

- therefore, we don't need to protect against it anymore

and all that should be properly documented.

Otherwise, there's no surviving this mess.

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
