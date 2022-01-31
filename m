Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B6D4A48E5
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 15:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359353AbiAaN77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 08:59:59 -0500
Received: from mail.skyhub.de ([5.9.137.197]:41116 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348918AbiAaN75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 08:59:57 -0500
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B1C931EC0347;
        Mon, 31 Jan 2022 14:59:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1643637591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=OiqGrPMnbQIGw2+zC+4XudA/cLM9mrsP0jF/0Bd4QuQ=;
        b=B1bfoGuvGOFIzbVcNaBP0Z+si2wluMNhvOWIaHfam12kzi8OhDQJzZzYFskxalWY3v/4qM
        9Qo7hkumcoibiHxtCvVrlvKKDUEQxhWIx/KwrVoGGy7ZSSCr/1g1jtlzZAzV5ZptuacS1F
        nGg+nK3P5+PoYvWU2nuxS3TDH2dVBeM=
Date:   Mon, 31 Jan 2022 14:59:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 6/9] x86/smpboot: Support parallel startup of
 secondary CPUs
Message-ID: <YffrVMiO/NalRZjL@zn.tnic>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <20211215145633.5238-7-dwmw2@infradead.org>
 <d10f529e-b1ee-6220-c6fc-80435f0061ee@amd.com>
 <f25c6ad00689fee6ce3e294393c13f3dcdd5985f.camel@infradead.org>
 <3d8e2d0d-1830-48fb-bc2d-995099f39ef0@amd.com>
 <e742473935bf81be84adea6fa8061ce0846cc630.camel@infradead.org>
 <330bedfee12022c1180d8752fb4abe908dac08d1.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <330bedfee12022c1180d8752fb4abe908dac08d1.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 29, 2022 at 12:04:19PM +0000, David Woodhouse wrote:
> I've rebased and pushed to
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-5.17
> 
> I'll do some more testing and repost the series during next week. The
> win is slightly more modest than the original patch sets because it now
> only parallelises x86/cpu:kick. I'm going to do more careful review and
> testing before doing the same for x86/cpu:wait-init in a later series.
> You can see that coming together in the git tree but I'm only going to
> post up to the 'Serialise topology updates' patch again for now.

Btw, Mr. Cooper points out a very important aspect and I don't know
whether you've verified this already or whether this is not affected
by your series ... yet. In any case it should be checked: microcode
loading.

See __reload_late() and all that dance we do to keep SMT siblings do
nothing at the same time while updating microcode.

With the current boot order, the APs should all do nothing so they won't
need that sync for early loading - load_ucode_{ap,bsp} - but I don't
know if you're changing that order with the parallel startup.

If you do, you'll probably need such syncing for the early loading
too...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
