Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C250D67AA0D
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 06:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbjAYFoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 00:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAYFoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 00:44:19 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B755FCE;
        Tue, 24 Jan 2023 21:44:18 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 770381EC0426;
        Wed, 25 Jan 2023 06:44:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674625455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GwUh08hTRNU50lHF4Dlm/8cq5wklqj5AG5yaI65K080=;
        b=hrpxoM12OzWHXLJjLd/T55d1RFZyX2SJyZZBxgLURTEjSuwsqEab5iemi5sfJTIIaPa3Mo
        DZcBtmldrFvTlachXx/r82Ac4o8uJnnabNVnJNowAl7HfqSv9tZ6fMIgcuTyZSEqj9SaBa
        fwktG0Irrs+c31DhBuKrwtCbP+NyMTo=
Date:   Wed, 25 Jan 2023 06:44:10 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     "Nikunj A. Dadhania" <nikunj@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Message-ID: <Y9DBqqGT+GB1TLWL@zn.tnic>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-4-aik@amd.com>
 <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
 <533c5c83-b68b-eff0-d36d-9963194ab844@amd.com>
 <Y8qDqgzsAOgcckPW@zn.tnic>
 <7881a2d8-9655-31ad-27d0-5c30db7895fe@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7881a2d8-9655-31ad-27d0-5c30db7895fe@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 02:11:27PM +1100, Alexey Kardashevskiy wrote:
> The tip/master's head just a few days ago was 195df42eb64dcb "Merge branch
> into tip/master: 'x86/platform'" and did have dcf67f724b8ada "x86/cpu, kvm:
> Add the NO_NESTED_DATA_BP feature"  but now tip/master does not have it -

Yeah, it had to be backed out. A new version will be queued soon.

> 8272720be044 "Merge x86/cache into tip/master". /me confused. What tree is
> the tree?

It still is *the* tree - just there were some issues with the KVM side of Kim's
series so it had to be dropped but he sent a new version which I need to queue
soon. Then I'll have a look at yours.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
