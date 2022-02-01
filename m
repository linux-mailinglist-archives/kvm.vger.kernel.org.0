Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F24A5AB8
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 11:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiBAK4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 05:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbiBAK4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 05:56:17 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AEDC061714;
        Tue,  1 Feb 2022 02:56:17 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EB4FE1EC04AD;
        Tue,  1 Feb 2022 11:56:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1643712972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=46aTMocMoAPOjkzOyW549Rg/pu0OxKnDcuckgk6b6E0=;
        b=KX/7ShJt2YcMVtPaBZxAu52wRHUwNWk17MoeOKO7euO4o8CkggePNJzOO556ySLF708u6Q
        ek2Kk9Kla3IO2X/9qJMSEn8YNcOw9E3qBggMCKUULGsqesAxEslwNFmLExPajRAnYksDsr
        wW31SFVfgnyYqCxCpopoHnWWK+gaHfU=
Date:   Tue, 1 Feb 2022 11:56:08 +0100
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
Message-ID: <YfkRyLV/auNzczfF@zn.tnic>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <20211215145633.5238-7-dwmw2@infradead.org>
 <d10f529e-b1ee-6220-c6fc-80435f0061ee@amd.com>
 <f25c6ad00689fee6ce3e294393c13f3dcdd5985f.camel@infradead.org>
 <3d8e2d0d-1830-48fb-bc2d-995099f39ef0@amd.com>
 <e742473935bf81be84adea6fa8061ce0846cc630.camel@infradead.org>
 <330bedfee12022c1180d8752fb4abe908dac08d1.camel@infradead.org>
 <YffrVMiO/NalRZjL@zn.tnic>
 <3bc401a9f110a24a429316371c767507b493025a.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3bc401a9f110a24a429316371c767507b493025a.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 01, 2022 at 10:25:01AM +0000, David Woodhouse wrote:
> Thanks. It looks like that is only invoked after boot, with a write to
> /sys/devices/system/cpu/microcode/reload.
>
> My series is only parallelising the initial bringup at boot time, so it
> shouldn't make any difference.

No, I don't mean __reload_late() - I pointed you at that function to
show the dance we must do when updating microcode late.

The load_ucode_{ap,bsp}() routines are what is called when loading ucode
early.

So the question is, does the parallelizing change the order in which APs
are brought up and can it happen that a SMT sibling of a two-SMT core
executes *something* while the other SMT sibling is updating microcode.

If so, that would be bad.

> However... it does look like there's nothing preventing a sibling being
> brought online *while* the dance you mention above is occurring.

Bottom line is: of the two SMT siblings, one needs to be updating
microcode while the other is idle. I.e., what __reload_late() does.

> Shouldn't __reload_late() take the device_hotplug_lock to prevent that?

See reload_store().

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
