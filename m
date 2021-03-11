Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52195337F0C
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 21:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhCKUc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 15:32:26 -0500
Received: from mail.skyhub.de ([5.9.137.197]:50856 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhCKUcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 15:32:12 -0500
Received: from zn.tnic (p200300ec2f0e1f00a86a11edd1796e13.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1f00:a86a:11ed:d179:6e13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3F4321EC041D;
        Thu, 11 Mar 2021 21:32:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615494730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=X0fH1nKE+B03jnhHgFBoQ/AhcZ8YeXX1uTmcsmmAkq0=;
        b=CZQq1kEt+fYlsQYDk8iKQIr7kZBShezRTt1o6/eFG3JHlcPrPYk8ZoICB6TmkumNZo/ATP
        TzZfnSAK8MKwQSY5P3MLo8QbjPJ8H/ge0JzXWSCPvw/+GCLu0tPWU0JidZ0Q2i+MX650rD
        LRjtyvvm9IOT+VRPl1dobHQNnCLeJ/I=
Date:   Thu, 11 Mar 2021 21:32:06 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
Message-ID: <20210311203206.GF5829@zn.tnic>
References: <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210311200755.GE5829@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 09:07:55PM +0100, Borislav Petkov wrote:
> On Wed, Mar 10, 2021 at 07:21:23PM -0600, Babu Moger wrote:
> > # git bisect good
> > 59094faf3f618b2d2b2a45acb916437d611cede6 is the first bad commit
> > commit 59094faf3f618b2d2b2a45acb916437d611cede6
> > Author: Borislav Petkov <bp@suse.de>
> > Date:   Mon Dec 25 13:57:16 2017 +0100
> > 
> >     x86/kaiser: Move feature detection up
> 
> What is the reproducer?
> 
> Boot latest 4.9 stable kernel in a SEV guest? Can you send guest
> .config?
> 
> Upthread is talking about PCID, so I'm guessing host needs to be Zen3
> with PCID. Anything else?

That oops points to:

[    1.237515] kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!

which is:

        local_flush_tlb();
        sync_core();
        /* Could also do a CLFLUSH here to speed up CPU recovery; but
           that causes hangs on some VIA CPUs. */
        for (i = 0; i < len; i++)
                BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);	<---
        local_irq_restore(flags);
        return addr;

in text_poke() which basically says that the patching verification
fails. And you have a local_flush_tlb() before that. And with PCID maybe
it is not flushing properly or whatnot.

And deep down in the TLB flushing code, it does:

        if (kaiser_enabled)
                kaiser_flush_tlb_on_return_to_user();

and that uses PCID...

Anyway, needs more info.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
