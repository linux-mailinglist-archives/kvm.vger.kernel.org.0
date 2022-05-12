Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8358D524E8B
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354565AbiELNop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354574AbiELNoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:44:39 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C987248E36;
        Thu, 12 May 2022 06:44:37 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C7E1B1EC06DA;
        Thu, 12 May 2022 15:44:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1652363071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lPa7c9dHOHhN02kSSI97I/I6ysdJlQQ6rMlomVLCERk=;
        b=YpiYrIZyQx5NoGQ+fa+ZGRYPALgsEYRnvYQzOR7kwTe7p+yMa7bBgvE5/SF71E+fdAB1Sk
        jxMPlLLMyoMJthAGP4FvTQEc8uGEfIIOMoUmvBbXMOHt43tIxciJs1rGNhJE5/cIijH0p9
        lAyx3JfL5RPHB/mtRr7Ir8IywoWI3bQ=
Date:   Thu, 12 May 2022 15:44:33 +0200
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
Message-ID: <Yn0PQe48qczUMZoL@zn.tnic>
References: <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic>
 <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
 <Ym1fGZIs6K7T6h3n@zn.tnic>
 <Ynp6ZoQUwtlWPI0Z@google.com>
 <520D7CBE-55FA-4EB9-BC41-9E8D695334D1@nutanix.com>
 <YnqJx/5hos0lKqI9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnqJx/5hos0lKqI9@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 03:50:31PM +0000, Sean Christopherson wrote:
> >     x86/speculation, KVM: remove IBPB on vCPU load
> > 
> >     Remove IBPB that is done on KVM vCPU load, as the guest-to-guest
> >     attack surface is already covered by switch_mm_irqs_off() ->
> >     cond_mitigation().
> > 
> >     The original 15d45071523d ("KVM/x86: Add IBPB support") was simply wrong in
> >     its guest-to-guest design intention. There are three scenarios at play
> >     here:
> > 
> >     1. If the vCPUs belong to the same VM, they are in the same security 
> >     domain and do not need an IPBP.
> >     2. If the vCPUs belong to different VMs, and each VM is in its own mm_struct,
> >     switch_mm_irqs_off() will handle IBPB as an mm switch is guaranteed to
> >     occur prior to loading a vCPU belonging to a different VMs.
> >     3. If the vCPUs belong to different VMs, but multiple VMs share an mm_struct,
> >     then the security benefits of an IBPB when switching vCPUs are dubious, 
> >     at best.
> > 
> >     Issuing IBPB from KVM vCPU load would only cover #3, but there are no
> 
> Just to hedge, there are no _known_ use cases.
> 
> >     real world tangible use cases for such a configuration.
> 
> and I would further qualify this with:
> 
>       but there are no known real world, tangible use cases for running multiple
>       VMs belonging to different security domains in a shared address space.
> 
> Running multiple VMs in a single address space is plausible and sane, _if_ they
> are all in the same security domain or security is not a concern.  That way the
> statement isn't invalidated if someone pops up with a use case for running multiple
> VMs but has no security story.
> 
> Other than that, LGTM.
> 
> >     If multiple VMs
> >     are sharing an mm_structs, prediction attacks are the least of their
> >     security worries.
> > 
> >     Fixes: 15d45071523d ("KVM/x86: Add IBPB support")
> >     (Reviewedby/signed of by people here)
> >     (Code change simply whacks IBPB in KVM vmx/svm and thats it)

I agree with all that I've read so far - the only thing that's missing is:

	(Documentation in Documentation/admin-guide/hw-vuln/spectre.rst about what the use
	 cases are and what we're protecting against and what we're *not* protecting
	 against because <raisins>).

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
