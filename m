Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404B3718BCF
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 23:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjEaV3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 17:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjEaV3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 17:29:15 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2034612F;
        Wed, 31 May 2023 14:29:13 -0700 (PDT)
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 728F51EC0373;
        Wed, 31 May 2023 23:29:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1685568551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cCSCvMUJ37RrG4sztF6QhyhQ1BDqg4ZKC/u3DdWe32g=;
        b=mjuLMaR1e2IadpeC2YMylI51M24PqVdK3GsLZ+Pt63S54EcehZhUV81YAX21UFa2K5gzH6
        xUJ2Wju/+Ag8CXRKqWqYLjbFEv0WifotziO9DUOQUthCiE0oCkYbA+RyqqmVjDbqPEcAYe
        glM3L0dpYBFYcz8JvvABhrVP7YOposI=
Date:   Wed, 31 May 2023 23:29:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>,
        "neelnatu@google.com" <neelnatu@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
Message-ID: <20230531212907.GHZHe8I/DZUyzIXI2Q@fat_crate.local>
References: <20230530200152.18961-1-jon@nutanix.com>
 <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
 <ZHd2P6D142rCByrm@google.com>
 <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com>
 <ZHermsSGQBcDD07R@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZHermsSGQBcDD07R@google.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 08:18:34PM +0000, Sean Christopherson wrote:
> Assert that the to-be-checked bit passed to cpu_feature_enabled() is a
> compile-time constant instead of applying the DISABLED_MASK_BIT_SET()
> logic if and only if the bit is a constant.  Conditioning the check on
> the bit being constant instead of requiring the bit to be constant could
> result in compiler specific kernel behavior, e.g. running on hardware that
> supports a disabled feature would return %false if the compiler resolved
> the bit to a constant, but %true if not.

Uff, more mirroring CPUID inconsistencies.

So *actually*, we should clear all those build-time disabled bits from
x86_capability so that this doesn't happen.

> All current usage of cpu_feature_enabled() specifies a hardcoded
> X86_FEATURE_* flag, so this *should* be a glorified nop.

Also, pls add here the exact example which prompted this as I'm sure we
will forget why this was done.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
