Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E31E60E644
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiJZRP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 13:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiJZRPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 13:15:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47B732059;
        Wed, 26 Oct 2022 10:15:12 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e7b8329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7b8:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 757FB1EC06BD;
        Wed, 26 Oct 2022 19:15:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666804511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hrN0nuSkWQ6arq9wRkypEi4ZMO2+zG5EuSmwR0ZDTh8=;
        b=DpLIRxo/4OegpIDbEPHKfGwBNI6CXjpVqJF/7BEWGKsl1kG3d+7EQWbXJHUqcMV9ItIO17
        gPiN5qUIiZY0ooioKOUFiX1LNVWlttZ5EeOpMG40r1gShpmN6pFYHjzL3OF8zTnX3iyPF2
        ht1nfxrRCqr6rc8wlKSORnmoBME4F5M=
Date:   Wed, 26 Oct 2022 19:15:06 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
Message-ID: <Y1lrGgyIcgweVGup@zn.tnic>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
 <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26, 2022 at 11:40:31AM +0800, Jiaxi Chen wrote:
> > What do you think about moving CPUID_7_1_EAX to be a KVM-only leaf too?  AFAICT,
> > KVM passthrough is the only reason the existing features are defined.

Yap, looking at the patches which added those 2 feature flags upstream,
they don't look like some particular use was the goal but rather to
expose it to guests. Besides, AVX512 apps do their own CPUID detection.

> Since CPUID_7_1_EAX has only 5 features now, it is a big waste,       
> should we move it to KVM-only leaf as Sean suggested. What's your     
> opinion about this?                                                   

Yes, pls do.

And when you do, make sure to undo what

  b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512 BFLOAT16 instructions")

added.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
