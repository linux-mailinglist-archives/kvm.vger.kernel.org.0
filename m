Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D06635B05
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiKWLGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbiKWLGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:06:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F6203;
        Wed, 23 Nov 2022 03:05:07 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669201505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcER3N8cDEa5ruwNLbalLB6FHysI8rQ3znaigQw23Ow=;
        b=imY/83YtWewMzLLlfKCCCRgpd5s+66myNvNvZXrlB3ED6kcLt1pfIHRxLeG0PA5WpUhhWl
        ERGih1yCSpcA28yhf8n8JJR5kbFxdeEVV+0EQPncRn8HRDQZdOInb86qx6LTajvXsIdF/5
        TDP9BvgUnU6ZTC0prCHQLGBiBF6J3o2Q+HFfm5U/HcQOlSCaIo3zHxNKi1VSYMf77f2j0E
        mLvEDZgW4uqAtowxkKKVH3EryhE4ct8dqyq8RWfhWQ59XSmzJgqQKdtewurTbnPLkePrZ7
        Zy5sgvt+1K0AsnpENxt8nO1xOZo9G+qMhQi8iMkTK7RhKFM2cUhfynDusVANiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669201505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OcER3N8cDEa5ruwNLbalLB6FHysI8rQ3znaigQw23Ow=;
        b=ZAonvxhebaeZPjcPDItSb+9XL7EVzHztxRm0ZREcKWPjUpAYk2HtgbtA5uLBIBf8ggy1ak
        IjOVoXfMpu/gJqAQ==
To:     "Huang, Kai" <kai.huang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX
 on demand
In-Reply-To: <246a4eaac29855c522bd26627b03418cb7ead66f.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
 <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net> <87edtvgu1l.ffs@tglx>
 <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com> <87mt8ig3ja.ffs@tglx>
 <246a4eaac29855c522bd26627b03418cb7ead66f.camel@intel.com>
Date:   Wed, 23 Nov 2022 12:05:04 +0100
Message-ID: <87bkoyexsv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kai!

On Wed, Nov 23 2022 at 00:30, Kai Huang wrote:
> On Tue, 2022-11-22 at 21:03 +0100, Thomas Gleixner wrote:
>> Clearly that's nowhere spelled out in the documentation, but I don't
>> buy the 'architecturaly required' argument not at all. It's an
>> implementation detail of the TDX module.
>
> I agree on hardware level there shouldn't be such requirement (not 100% s=
ure
> though), but I guess from kernel's perspective, "the implementation detai=
l of
> the TDX module" is sort of "architectural requirement"

Sure, but then it needs to be clearly documented so.

> -- at least Intel arch guys think so I guess.

Intel "arch" guys? You might look up the meanings of "arch" in a
dictionary. LKML is not twatter.

>> Technically there is IMO ZERO requirement to do so.
>>=20
>> =C2=A01) The TDX module is global
>>=20
>> =C2=A02) Seam-root and Seam-non-root operation are strictly a LP propert=
y.
>>=20
>> =C2=A0=C2=A0=C2=A0 The only architectural prerequisite for using Seam on=
 a LP is that
>> =C2=A0=C2=A0=C2=A0 obviously the encryption/decryption mechanics have be=
en initialized
>> =C2=A0=C2=A0=C2=A0 on the package to which the LP belongs.
>>=20
>> I can see why it might be complicated to add/remove an LP after
>> initialization fact, but technically it should be possible.
>
> "kernel soft offline" actually isn't an issue.  We can bring down a logic=
al cpu
> after it gets initialized and then bring it up again.

That's the whole point where this discussion started: _AFTER_ it gets
initialized.

Which means that, e.g. adding "nosmt" to the kernel command line will
make TDX fail hard because at the point where TDX is initialized the
hyperthreads are not 'soft' online and cannot respond to anything, but
the BIOS already accounted them.

This is just wrong as we all know that "nosmt" is sadly one of the
obvious counter measures for the never ending flood of speculation
issues.

> Only add/removal of physical cpu will cause problem:=C2=A0

You wish.=20

> TDX MCHECK verifies all boot-time present cpus to make sure they are TDX-
> compatible before it enables TDX in hardware.  MCHECK cannot run on hot-a=
dded
> CPU, so TDX cannot support physical CPU hotplug.

TDX can rightfully impose the limitation that it only executes on CPUs,
which are known at boot/initialization time, and only utilizes "known"
memory. That's it, but that does not enforce to prevent physical hotplug
in general.

> We tried to get it clarified in the specification, and below is what TDX/=
module
> arch guys agreed to put to the TDX module spec (just checked it's not in =
latest
> public spec yet, but they said it will be in next release):
>
> "
> 4.1.3.2.  CPU Configuration
>
> During platform boot, MCHECK verifies all logical CPUs to ensure they
> meet TDX=E2=80=99s

That MCHECK falls into the category of security voodoo.

It needs to verify _ALL_ logical CPUs to ensure that Intel did not put
different models and steppings into a package or what?

> security and certain functionality requirements, and MCHECK passes the fo=
llowing
> CPU configuration information to the NP-SEAMLDR, P-SEAMLDR and the TDX Mo=
dule:
>
> =C2=B7         Total number of logical processors in the platform.

You surely need MCHECK for this

> =C2=B7         Total number of installed packages in the platform.

and for this...

> =C2=B7         A table of per-package CPU family, model and stepping etc.
> identification, as enumerated by CPUID(1).EAX.
> The above information is static and does not change after platform boot a=
nd
> MCHECK run.
>
> Note:     TDX doesn=E2=80=99t support adding or removing CPUs from TDX se=
curity
> perimeter, as checked my MCHECK.

More security voodoo. The TDX security perimeter has nothing to do with
adding or removing CPUs on a system. If that'd be true then TDX is a
complete fail.

> BIOS should prevent CPUs from being hot-added or hot-removed after
> platform boots.

If the BIOS does not prevent it, then TDX and the Seam module will not
even notice unless the OS tries to invoke seamcall() on a newly plugged
CPU.

A newly added CPU and newly added memory should not have any impact on
the TDX integrity of the already running system. If they have then
again, TDX is broken by design.

> The TDX module performs additional checks of the CPU=E2=80=99s configurat=
ion and
> supported features, by reading MSRs and CPUID information as described in=
 the
> following sections.

to ensure that the MCHECK generated table is still valid at the point
where TDX is initialized?=20

That said, this documentation is at least better than the existing void,
but that does not make it technically correct.

Thanks,

        tglx
