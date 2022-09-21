Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04205BFAED
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 11:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiIUJ2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 05:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiIUJ2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 05:28:35 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDB88C028;
        Wed, 21 Sep 2022 02:28:34 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2BF601EC04E4;
        Wed, 21 Sep 2022 11:28:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663752509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mdVBhxnggDAzh319FYKahmYLw698VHxudoW2812kVhc=;
        b=q2RjQTCMTDM/aG8q+98Dk0Zfy6z6IJ2w1BF8lkfLv67o+A8Ob8aJLOfJ7HBJ+eQU+v6je2
        e6zC6/7hALIyLEiOTXoegU27AfUJxilXSd/4tZtCDyJwHm9s0pVvYWAmLRKztOTvLI9io9
        m+Ti+GnXHtltDpbdNPy4EO0JPTD6za0=
Date:   Wed, 21 Sep 2022 11:28:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
Message-ID: <YyrZOLq8z+lIORvP@zn.tnic>
References: <20220920205922.1564814-1-jmattson@google.com>
 <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 09:36:18PM +0000, Sean Christopherson wrote:
> Yes, but ideally KVM would explicitly tell the guest "you don't have LMSLE".
> Probably a moot point, but at the same time I don't see a reason not to be
> explicit.

Yes but...

On Tue, Sep 20, 2022 at 02:36:34PM -0700, Jim Mattson wrote:
> Reporting that CPUID bit gives us the right to raise #GP. AMD CPUs
> (going way back) that don't report EferLmsleUnsupported do not raise
> #GP.

... what does "gives us the right" mean exactly?

I'm pretty sure I'm missing something about how KVM works but wouldn't
it raise a guest #GP when the guest tries to set an unsupported EFER
bit? I.e., why do you need to explicitly do

	kvm_cpu_cap_set(X86_FEATURE_NO_LMSLE);

and not handle this like any other EFER reserved bit?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
