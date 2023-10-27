Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E0F7D9C1A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbjJ0OtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345848AbjJ0OtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:49:22 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CDAC4;
        Fri, 27 Oct 2023 07:49:20 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1343E40E01A4;
        Fri, 27 Oct 2023 14:49:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lB8tJ8G47sGK; Fri, 27 Oct 2023 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698418155; bh=efdni8LIyAk3uyY0PXBFr5y1EyWZiHVxkj/zu94sZSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hI/CIriGFipTm4+w04aK79z4ALAuJsHZtXxsgvOllb2FkSNGremvF+mmjzJpVHQ4z
         g+etOVjG05xesehCFpiKIrVmTr/138EMUkY9T0TKaAaEeAFl0FvbXFWTlvQJeJquiq
         VTYQs7pTj4x1nEOj7+dc5cpXlnhFnBZe/0zbgU+1FqimkY+kkKIiYXkdcDWin2sA07
         uf1cKnVwE5JwzZ/c9mAjXfjZVHzoz4hLSCid+5Bwx3MskFVIiXAaMIyiVTH/NOPxxj
         At8A9Qs83dCJYOzBMGhDNnIXTBf2EuCjyEAI+ojP0dlkErrtgAp7jKljk3ZsGETBai
         4Z/wDni69LP6NfG9IPIVne8tipYseBLGh7+deRmJ7jfJmMD++tChc7SUov6NgGLcVz
         7L1bNoptc9DV4KWz6KptH3IKBjDuxiN6bWJXdRtohmvQgLBGPbIDBps2HJsba52HPs
         7Qlmvaf0ivf4cMVd+EekmrCDzXqh35bux45jWG+C5ygeW0XCMNuKiAN46zzMmw2I21
         5j46AtX9XqHp+tTlnV/ZkQXsERdwxGG3BEe+Bgfu4TJN1hzHDus2jkpZ5mUWG5Q5gC
         GjjNECLta/uRhl33JosFgJKP02STN4oFmXcoX6+XwcQZ5ziIyCvlLaXOJ8i6VOrJC1
         nYjkTlrucCwH39lqpsCNMaE8=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5E53D40E018F;
        Fri, 27 Oct 2023 14:48:49 +0000 (UTC)
Date:   Fri, 27 Oct 2023 16:48:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alyssa Milburn <alyssa.milburn@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4 0/6] Delay VERW
Message-ID: <20231027144848.GGZTvN0AtGIQ9kBtkA@fat_crate.local>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 07:38:34AM -0700, Pawan Gupta wrote:
> v4:

Why are you spamming people with your patchset? You've sent it 4 times
in a week:

Oct 20               Pawan Gupta ( :  75|) [PATCH 0/6] Delay VERW
Oct 24               Pawan Gupta ( :7.3K|) [PATCH v2 0/6] Delay VERW
Oct 25               Pawan Gupta ( :7.5K|) [PATCH v3 0/6] Delay VERW
Oct 27               Pawan Gupta ( :8.8K|) [PATCH v4 0/6] Delay VERW

Is this something urgent or can you take your time like everyone else?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
