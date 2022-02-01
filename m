Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47244A5CA1
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiBAM4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:56:13 -0500
Received: from mail.skyhub.de ([5.9.137.197]:41570 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238238AbiBAM4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 07:56:12 -0500
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 552CB1EC0441;
        Tue,  1 Feb 2022 13:56:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1643720166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nGtniP/ZuSvnwnPoaU4PQX/0piWBb9dVWe0n763a2eI=;
        b=W1yRP06VZIG2iZVXxUMtaGrrFhFQiW9wFWg8S4RXC5N+aRmQIUqZiNxIFGkx6dKsMT0jfG
        aF5AULNAcU9t7T7RhPGRrkoz3FAd9/2uMMNiKZdw3STZssNex4aZxo6UjNAJHN0qoW0B3F
        nYJF+mbZ+9U/S97CTSfM8kwokK9Um58=
Date:   Tue, 1 Feb 2022 13:56:02 +0100
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
Message-ID: <Yfkt4sX094so/Kub@zn.tnic>
References: <20211215145633.5238-7-dwmw2@infradead.org>
 <d10f529e-b1ee-6220-c6fc-80435f0061ee@amd.com>
 <f25c6ad00689fee6ce3e294393c13f3dcdd5985f.camel@infradead.org>
 <3d8e2d0d-1830-48fb-bc2d-995099f39ef0@amd.com>
 <e742473935bf81be84adea6fa8061ce0846cc630.camel@infradead.org>
 <330bedfee12022c1180d8752fb4abe908dac08d1.camel@infradead.org>
 <YffrVMiO/NalRZjL@zn.tnic>
 <3bc401a9f110a24a429316371c767507b493025a.camel@infradead.org>
 <YfkRyLV/auNzczfF@zn.tnic>
 <c83673d74bc161b8e5bfcc3049ccfecf5c9e96f5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c83673d74bc161b8e5bfcc3049ccfecf5c9e96f5.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 01, 2022 at 12:39:17PM +0000, David Woodhouse wrote:
> In the top of my git tree, you can see a half-baked 'parallel part 2'
> commit which introduces a new x86/cpu:wait-init cpuhp state that would
> invoke do_wait_cpu_initialized() for each CPU in turn, which *would*
> release them all into load_ucode_bsp() at the same time and have
> precisely the problem you're describing.

The load_ucode_bsp() is the variant that runs on the boot CPU but
yeah...

> I'll commit a FIXME comment now so that it doesn't slip my mind.

Yap, thank Cooper for pointing out that whole thing about how microcode
loading is special and can't always handle parallelism. :)

> Hm, not sure I see how that's protecting itself from someone
> simultaneously echoing 1 > /sys/devices/system/cpu/cpu${SIBLING}/online

So

echo 1 > ../online

means onlining the sibling.

But reload_store() grabs the CPU hotplug lock *first* and *then* runs
check_online_cpus() to see if all CPUs are online. It doesn't do the
update if even one CPU is missing. You can't offline any CPU for the
duration of the update...

So I guess you'd need to explain in more detail what protection hole
you're seeing because I might be missing something here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
