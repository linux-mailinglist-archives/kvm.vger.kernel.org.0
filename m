Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E8462E291
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbiKQRHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbiKQRHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:07:15 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B5574AB5;
        Thu, 17 Nov 2022 09:07:13 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7de329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7de:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 711661EC04CB;
        Thu, 17 Nov 2022 18:07:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668704831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IwsBrupBKGDExJ0jOHnOGr0FcQMCStxLIP7mgxO9ptw=;
        b=SnIyULoqABEtCUPcoQMC5Kee1zP3M65nfTwCBHMVkiJGP2ifnpqLK2PxuRo1ujkRAICmut
        rxij+U97Rou+Wl3tnRtmJwa80MAJvsEmI+oXlmj9p33b+nGEhM5NjK+9VKH07WQi8bAvPR
        hJafUZKHZONO6gXRRWL71J093jx1mbQ=
Date:   Thu, 17 Nov 2022 18:07:06 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 06/13] KVM: SVM: Add VNMI bit definition
Message-ID: <Y3ZqOvg2mlBmXAlW@zn.tnic>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-7-mlevitsk@redhat.com>
 <Y3ZHKVq8enyxJmVu@zn.tnic>
 <Y3Zkkc1edwYtpk+N@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3Zkkc1edwYtpk+N@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 04:42:57PM +0000, Sean Christopherson wrote:
> Why? This is rarely run code, won't cpu_feature_enabled()
> unnecessarily require patching?

Because we want one single interface to test X86_FEATURE flags. And
there's no need for the users to know whether it wants patching or not -
we simply patch *everywhere* and that's it.

> And while we're on the topic... https://lore.kernel.org/all/Y22IzA9DN%2FxYWgWN@google.com

Because static_ or boot_ is not relevant to the user - all she
wants to know is whether a cpu feature has been enabled. Thus
cpu_feature_enabled().

And yes, at the time I protested a little about unnecessary patching.
And tglx said "Why not?". And I had no good answer to that. So we can
just as well patch *everywhere*.

And patching is soo not a big deal anymore considering all the other
things we do to kernel code at build time and runtime. objdump output
compared to what's actually running has in some cases no resemblance
whatsoever.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
