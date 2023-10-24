Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1483E7D594F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343978AbjJXRDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjJXRDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 13:03:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DCD123;
        Tue, 24 Oct 2023 10:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a8IeFdJ8fia0YpbA1ZcZvRmzA2TI5SE/1rrfo0EUgMw=; b=lcZZU9f+QLz2bVRJlnc/UxbjTE
        nMk0Ob5/6FcqIEwN0NPgITv3XKH/BkS47qVAJYnx8r3lhYpiDcxdS215jd9kuls2QSrsI1kslzSOB
        AUDZBvNIq8pu1syL0aXeyR/jcQYFauWKel20Qpjc4NBAErE6EFvPiTcplnLUwYvD3N/kEYrDIrrAZ
        73w6BQIh8IJLNn+c52e0IisU8xHm/kOo53LlbrKwj2m5QJvQ/LOmxrXFc91IcBMP3/5Prki0v4A55
        mnwHk9l8KjlmFYmlMWwPtsyIj5NyDz0JPghY/tylB+6DpMF7Sc87UMuH56nTJsx6A61Q1dy6IR40w
        mYFbWLfQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvKno-00FfSi-2Y;
        Tue, 24 Oct 2023 17:02:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7175B300451; Tue, 24 Oct 2023 19:02:48 +0200 (CEST)
Date:   Tue, 24 Oct 2023 19:02:48 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231024170248.GE40044@noisy.programming.kicks-ass.net>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231024163515.aivo2xfmwmbmlm7z@desk>
 <20231024163621.GD40044@noisy.programming.kicks-ass.net>
 <20231024164520.osvqo2dja2xhb7kn@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024164520.osvqo2dja2xhb7kn@desk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 09:45:20AM -0700, Pawan Gupta wrote:

> > > modules being within 4GB of kernel.

FWIW, it's 2G, it's a s32 displacement, the highest most address can
jump 2g down, while the lowest most address can jump 2g up. Leaving a 2G
directly addressable range.

And yeah, we ensure kernel text and modules are inside that 2G range.
