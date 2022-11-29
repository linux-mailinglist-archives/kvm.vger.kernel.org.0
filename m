Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7935063C42B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 16:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiK2Pur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 10:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiK2Pud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 10:50:33 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE672AE1C;
        Tue, 29 Nov 2022 07:50:30 -0800 (PST)
Received: from zn.tnic (p200300ea9733e724329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e724:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D1AD01EC06D0;
        Tue, 29 Nov 2022 16:50:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669737028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=j5TXiePmxL91SlMInx0lOFxR9R7xf7CDOnkMDEo8NOo=;
        b=Ug7/ioDiJ/T09VA+AtfybQkW2YwL9YgxTYELmnFF8r+jaBqrkU+AQFPeTLo8qVJBWcp6gs
        aHItuRxbIdJ6etimD4uwbRIS2BEJfu3QTJM5RELq/MNqpYIVcvLbzVks3WKlUZMp1NBjvF
        UP+Pzmf4O5YrrB38kp4rtCeJUx9xl3E=
Date:   Tue, 29 Nov 2022 16:50:24 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/cpu, kvm: Use CPU capabilities for
 CPUID[0x80000021].EAX
Message-ID: <Y4YqQO/gGwAmn7jI@zn.tnic>
References: <20221124000449.79014-1-kim.phillips@amd.com>
 <20221124000449.79014-2-kim.phillips@amd.com>
 <Y39qUnlRx05eaGeb@zn.tnic>
 <849464c8-476a-9a14-afdb-cb8793dd6064@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <849464c8-476a-9a14-afdb-cb8793dd6064@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 05:00:43PM -0600, Kim Phillips wrote:
> > verify_tags: WARNING: Co-developed-by Babu Moger <Babu.Moger@amd.com> hasn't signed off on the patch!
> 
> OK, I'll add his signed-off-by.

You can't just add his SOB - he needs to give it himself.

"Certificate of Origin" in Documentation/process/submitting-patches.rst
needs brushing up on, it seems.

> Not sure I follow.  That code (originally from commit f144c49e8c39
> ("KVM: x86: synthesize CPUID leaf 0x80000021h if useful") doesn't
> negate that: the code is saying that if we don't have the bug, then
> set the feature bit that says we don't have the bug.

I was thinking of the case described here:

415de4407664 ("x86/cpu: Fix migration safety with X86_BUG_NULL_SEL")

but I guess we can do that on the host.

> > Which means, you'd have to update check_null_seg_clears_base() too.
> 
> Like this?:
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 73cc546e024d..bbe96d71ff5e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1682,11 +1682,6 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
>         if (!IS_ENABLED(CONFIG_X86_64))
>                 return;
> 
> -       /* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
> -       if (c->extended_cpuid_level >= 0x80000021 &&
> -           cpuid_eax(0x80000021) & BIT(6))
> -               return;
> -

No, not like this. The above you've removed needs to be

	if (cpu_has(c, X86_FEATURE_NULL_SEL_CLR_BASE))
		return;

so that you exit early.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
