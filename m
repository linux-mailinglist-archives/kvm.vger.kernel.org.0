Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957C0646DF1
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 12:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiLHLDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 06:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiLHLDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 06:03:04 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB33D7DA52;
        Thu,  8 Dec 2022 03:01:26 -0800 (PST)
Received: from zn.tnic (p200300ea9733e73d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e73d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3E3E81EC0674;
        Thu,  8 Dec 2022 12:01:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670497285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=p6BKp+lZFeo5nEHFN08b7A4qsOcg2h8Q5CIVmAU4Sgs=;
        b=GGUjKCnGXdu+GzGEeTcqNkIO5sq4pPUr18Wk+TEkqg1yuGkhVH2jOSjqsByLzbB/b5UJ3I
        QYwDvaXAAS9FhAViK5CWoQ47iKJFvMKqxgqyp7/no0NRYJCReDkNtBzsoQma0PdEWwmLa5
        izoyFevBhjUmohd6jCaOXHC8kE7SiW0=
Date:   Thu, 8 Dec 2022 12:01:21 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel 3/3] x86/sev: Do not handle #VC for DR7 read/write
Message-ID: <Y5HEAYjUorpZJGl+@zn.tnic>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-4-aik@amd.com>
 <Y4jmmfrUXAzydM0G@google.com>
 <Y5DjBAH1P38hjJRP@zn.tnic>
 <Y5Dke3WOpd8bJK9q@google.com>
 <ac5d066e-5c61-7afe-b496-8254633c24d1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac5d066e-5c61-7afe-b496-8254633c24d1@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 06:14:01PM +1100, Alexey Kardashevskiy wrote:
> Sorry, I am not following. How is moving the bit makes
> SEV_STATUS_TO_FEATURES() not needed?
> 
> When I am setting it in VMSA SEV_FEATURES - it is a bit 5.
> 
> Inside a SEV VM, it is SEV_STATUS MSR and there it is bit 7. Mentioned
> MSR_AMD64_SEV* are SEV_STATUS MSR bits.
> 
> Since the current patch is bad, I'd rather define the bit twice then:

Yes.

> arch/x86/include/asm/msr-index.h:
> #define MSR_AMD64_SEV_FEAT_DEBUG_SWAP    BIT_ULL(7)
> 
> arch/x86/include/asm/svm.h
> #define SVM_SEV_FEAT_DEBUG_SWAP         BIT(5)
> 
> as nothing really says that SEV_FEATURES is always going to be
> SEV_STATUS>>2, even though it is now.
> 
> Soooo what is acceptable solution here? Thanks,

Right, so since you're testing against sev_status which is a copy of
MSR_AMD64_SEV, then you use bit definitions which are for that MSR as
documented in the respective PPR section for "MSRC001_0131 [SEV Status]
(Core::X86::Msr::SEV_Status)"

When you're setting the VMSA's SEV_FEATURES field, then you need a
different define, ofc.

This also automatically takes care of SEV_FEATURES not being tied to
SEV_STATUS >> 2 forever, as you say.

So yes, do the twice thing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
