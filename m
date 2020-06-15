Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9281F965A
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgFOMPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbgFOMPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 08:15:38 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D457C061A0E;
        Mon, 15 Jun 2020 05:15:38 -0700 (PDT)
Received: from zn.tnic (p200300ec2f063c0085fbd8d4455f52fc.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:3c00:85fb:d8d4:455f:52fc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7BB41EC0299;
        Mon, 15 Jun 2020 14:15:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1592223336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IvLplpOzdVR3pvv87mkIgy3s3a9HTre37RLfwpBuQDk=;
        b=plcRE/HT8GZ7mDZeXigYxsn/J0PdLHE1t9di7d6lkuXvUjT1Zof0zG7KP6SR3Uf+cE0Wjk
        l3L4tt5jYOsrc+gkBhllMZbwzxaGLpqY/tkVRGFNbVQdfyJTtWZOL1+0huSI5i62Hg7vzW
        CkJLUbF2zDsZnIDh3W8rolEcZRq2V8s=
Date:   Mon, 15 Jun 2020 14:15:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Liam Merwick <liam.merwick@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during
 wakeup
Message-ID: <20200615121524.GH14668@zn.tnic>
References: <20200605200728.10145-1-sean.j.christopherson@intel.com>
 <b2ac2400-dbc1-f6bc-a397-17f1ae10bd83@oracle.com>
 <20200608172921.GC8223@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200608172921.GC8223@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 10:29:21AM -0700, Sean Christopherson wrote:
> On Mon, Jun 08, 2020 at 11:12:35AM +0100, Liam Merwick wrote:
> > On 05/06/2020 21:07, Sean Christopherson wrote:
> > >Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the case
> > >where firmware doesn't initialize or save/restore across S3.  This fixes
> > >a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
> > >taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.
> > >
> > >Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already deals
> > >with the case where the MSR is locked, and because APs already redo
> > >init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow being
> > >used to reinitialize APs upon wakeup.  Do the call in the early wakeup
> > >flow to avoid dependencies in the syscore_ops chain, e.g. simply adding
> > >a resume hook is not guaranteed to work, as KVM does VMXON in its own
> > >resume hook, kvm_resume(), when KVM has active guests.
> > >
> > >Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
> > >Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > >Cc: Paolo Bonzini <pbonzini@redhat.com>
> > >Cc: kvm@vger.kernel.org
> > 
> > Should it have the following tag since it fixes a commit introduced in 5.6?
> > Cc: stable@vger.kernel.org # v5.6
> 
> It definitely warrants a backport to v5.6.  I didn't include a Cc to stable
> because I swear I had seen an email fly by that stated an explicit Cc is
> unnecessary/unwanted for tip-tree patches, but per a recent statement from
> Boris it looks like I'm simply confused[*].  I'll add the Cc in v2.
> 
> [*] https://lkml.kernel.org/r/20200417164752.GF7322@zn.tnic

Yeah, I was simply parroting what Greg has told me. Maybe he should
finally do that script. :-P

Also, I believe Sasha's Skynet machine already does that...

CCed both.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
