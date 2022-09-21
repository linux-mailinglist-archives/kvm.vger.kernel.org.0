Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25E55BFF48
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 15:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiIUNyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 09:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIUNyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 09:54:08 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122C80F79;
        Wed, 21 Sep 2022 06:54:07 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 82B171EC04CB;
        Wed, 21 Sep 2022 15:54:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663768441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NyJ3We4i84fZUQ0U+Ihe3Gx3FwEoAlbx7LfzUFf3J+U=;
        b=Fwgg7F8XtuyuPfHuuwgrcKSg29/nPO9VcHNW3vjBj6dAmOyS5JkPb9pJ9G1xbyPgrqm+yD
        HeeMDNp0YFHk3z601+tEs7fXisOKzsF0adclUM04okVBZ1e2UrAhMuyPfTupF4jAVkqsjS
        R5Sihwp6jLB4kHWI48Be+J3fiTToLtA=
Date:   Wed, 21 Sep 2022 15:54:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
Message-ID: <YysXeXKY36yXj68q@zn.tnic>
References: <20220920205922.1564814-1-jmattson@google.com>
 <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
 <YyrZOLq8z+lIORvP@zn.tnic>
 <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 06:45:24AM -0700, Jim Mattson wrote:
> EFER.LMLSE is not a reserved bit on AMD64 CPUs, unless
> CPUID.80000008:EBX[20] is set (or you're running very, very old
> hardware).
> 
> We really shouldn't just decide on a whim to treat EFER.LMSLE as
> reserved under KVM. The guest CPUID information represents our
> detailed contract with the guest software. By setting
> CPUID.80000008:EBX[20], we are telling the guest that if it tries to
> set EFER.LMSLE, we will raise a #GP.

I understand all that. What I'm asking is, what happens in KVM *after*
your patch 1/3 is applied when a guest tries to set EFER.LMSLE? Does it
#GP or does it allow the WRMSR to succeed? I.e., does KVM check when
reserved bits in that MSR are being set?

By looking at it, there's kvm_enable_efer_bits() so it looks like KVM
does control which bits are allowed to set and which not...?

> If we don't set that bit in the guest CPUID information and we raise
> #GP on an attempt to set EFER.LMSLE, the virtual hardware is
> defective.

See, this is what I don't get - why is it defective? After the revert,
that bit to KVM is reserved.

> We could document this behavior as an erratum, but since a
> mechanism exists to declare that the guest can expect EFER.LMSLE to
> #GP, doesn't it make sense to use it?

I don't mind all that and the X86_FEATURE bit and so on - I'm just
trying to ask you guys: what is KVM's behavior when the guest tries to
set a reserved EFER bit.

Maybe I'm not expressing myself precisely enough...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
