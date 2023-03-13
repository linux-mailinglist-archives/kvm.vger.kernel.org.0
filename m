Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DF66B80C1
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 19:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCMSdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 14:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCMScd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 14:32:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A28388D
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:31:24 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id az5-20020a056a02004500b004fb64e929f2so1648972pgb.7
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678732264;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eH/yGFM7lophCaErSsS6qkaStiVBMUZG+SlmSnRtnLo=;
        b=kjW5HuVbS9hb3YNrUpO/PRw/CP778kbREXjjZmvTOI/nvHNDji68QpMHNQAry+6jkB
         dB9TzMA3uuyyhuE33ljhJs1Uza/C+jCQ2CBjQwr2hW1JTviZIgt9n4nmvFbAwBrzRIAf
         5Mrg9GKSNbnN/uoyXA8eE9Cf13578wopbjc71alN9VXQWCYTW8YODYxZEfOya1+A/uMg
         N4vDi0kbGoNd+dyS1PaXHq0jiuvslu5NhoBogINd8uh2KW/UL09khIT8lKVC43XzJGAy
         rUVdcoMoynQQQYqI2P81mGGNseJgn1iC18uUso0TP2pL3zuecVTbJapqf/JvjDzQPVP/
         huIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678732264;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eH/yGFM7lophCaErSsS6qkaStiVBMUZG+SlmSnRtnLo=;
        b=AaM4narKuUDDY117Isq35OHwcBTn5Y6y+STek4Vfw4rXBFczRIBg9yWRxF4YSf1qz4
         NfZx2ANxqjlxUdpFhTYPPGebdbYsC/KiS6LwlegehtUE6IXgr7xWN9eM35hxFzULLiZC
         44a9XHZF3npQO1u+SgEMRIKJU4Ki8ae7oAifvXkfu8ktbR8gZFSuVPJ6p9x41vPJzQCY
         Gh5s6/Ux5PiEms3rmyQwFaLH81AcaeItF1rt93swZHwrq1sYxVG3s9ALZZFwE2UwsGVu
         sKTHSbw9rqS4N5IdSG9Xvn3LDN6BLodkaqN9SIhoE54YVlkuJorTYCCQh3Da3I6rCgbZ
         1CWQ==
X-Gm-Message-State: AO0yUKVEMcpcb7K7tQWQmGYfKrZhD7R4LlGDVWYN0zaXkItyygZkoQNf
        VTsS+pgRkF1zAylbROkO16jLl/uOeM8=
X-Google-Smtp-Source: AK7set/VbSpElqSzWWeBBuvouqfYrImDwqs9dxkO5uUj2PkDYNlB6Z2CA0iJ1rWQE85qAqqnE4EFfLLS2Tw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1b0c:b0:23d:bd2:ab35 with SMTP id
 q12-20020a17090a1b0c00b0023d0bd2ab35mr1401323pjq.3.1678732263794; Mon, 13 Mar
 2023 11:31:03 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:31:02 -0700
In-Reply-To: <a3e58e90a6b26019633afeef9162720ef39c5e03.camel@intel.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com> <20230310214232.806108-3-seanjc@google.com>
 <a3e58e90a6b26019633afeef9162720ef39c5e03.camel@intel.com>
Message-ID: <ZA9rl1sp0l9oPoBm@google.com>
Subject: Re: [PATCH v2 02/18] x86/reboot: Expose VMCS crash hooks if and only
 if KVM_INTEL is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Huang, Kai wrote:
> Hi Sean,
>=20
> Thanks for copying me.
>=20
> On Fri, 2023-03-10 at 13:42 -0800, Sean Christopherson wrote:
> > Expose the crash/reboot hooks used by KVM to do VMCLEAR+VMXOFF if and
> > only if there's a potential in-tree user, KVM_INTEL.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---

...

> > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > index 299b970e5f82..6c0b1634b884 100644
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -787,6 +787,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
> >  }
> >  #endif
> > =20
> > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> >  /*
> >   * This is used to VMCLEAR all VMCSs loaded on the
> >   * processor. And when loading kvm_intel module, the
> > @@ -807,6 +808,7 @@ static inline void cpu_crash_vmclear_loaded_vmcss(v=
oid)
> >  		do_vmclear_operation();
> >  	rcu_read_unlock();
> >  }
> > +#endif
> > =20
> >  /* This is the CPU performing the emergency shutdown work. */
> >  int crashing_cpu =3D -1;
> > @@ -818,7 +820,9 @@ int crashing_cpu =3D -1;
> >   */
> >  void cpu_emergency_disable_virtualization(void)
> >  {
> > +#if IS_ENABLED(CONFIG_KVM_INTEL)
> >  	cpu_crash_vmclear_loaded_vmcss();
> > +#endif
> > =20
> >  	cpu_emergency_vmxoff();
>=20
> In the changelog you mentioned to expose the *hooks* (plural) used to do
> "VMCLEAR+VMXOFF" only when KVM_INTEL is on, but here only "VMCLEAR" is em=
braced
> with CONFIG_KVM_INTEL.  So either the changelog needs improvement, or the=
 code
> should be adjusted?

I'll reword the changelog, "hooks" in my head was referring to the regsiter=
 and
unregister "hooks", not the callback itself.

> Personally, I think it's better to move VMXOFF part within CONFIG_KVM_INT=
EL too,
> if you want to do this.

That happens eventually in the final third of this series.

> But I am not sure whether we want to do this (having CONFIG_KVM_INTEL aro=
und the
> relevant code).  In later patches, you mentioned the case of out-of-tree
> hypervisor, for instance, below in the changelog of patch 04:
>=20
> 	There's no need to attempt VMXOFF if KVM (or some other out-of-tree=EF=
=BF=BD
> 	hypervisor) isn't loaded/active...
>=20
> This means we want to do handle VMCLEAR+VMXOFF in case of out-of-tree hyp=
ervisor
> too.  So, shouldn't the hooks always exist but not only available when KV=
M_INTEL
> or KVM_AMD is on, so the out-of-tree hypervisor can register their callba=
cks?

Ah, I see how I confused things with that statement.  My intent was only to=
 call
out that, technically, a non-NULL callback doesn't mean KVM is loaded.  I d=
idn't
intend to sign the kernel up for going out of its way to support out-of-tre=
e hypervisors.

Does it read better if I add a "that piggybacked the callback" qualifier?

  There's no need to attempt VMXOFF if KVM (or some other out-of-tree hyper=
visor
  that piggybacked the callback) isn't loaded/active, i.e. if the CPU can't
  possibly be post-VMXON.=20
