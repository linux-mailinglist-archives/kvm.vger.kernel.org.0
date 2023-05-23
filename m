Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D8570E0CC
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbjEWPob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 11:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjEWPo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 11:44:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CD611A
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 08:44:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba69d93a6b5so15186669276.1
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 08:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684856667; x=1687448667;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDHc53bZmqIqUAnat9C7bwzMrYIxO5J3dPTUYBJnfZE=;
        b=Vgn+Kkp741xrj6z/R/ZKC7DXK6xoGHPiPFCoYSF0v1JbJB54V+yJlynEPLJKvrumTL
         +AZi+cSGWfXYD5kq6DfwYMbU9DOYLKfW39Sxl9/NEsWpxLKqYCStTRjbAcfPMb3RVLo6
         Ry5ZUDJI8jIuJhEMwR8vHh8muGQ8+laQ9eI++Os2JlZ3SwfqSUmTWDLlxuLCpaqlRsez
         fJkn4tGnJ+gRUxG5EnOWDWZPpj4Udmlx/a3t0++443OpBL0Lba/782+QTe1jrqwspkXB
         nQQQNa7GePPjOlJJKpLVq238XomSml8qJgccIBYPvqXi3wS+Lp0DLN5M8iNlszCLbj9B
         Y3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684856667; x=1687448667;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QDHc53bZmqIqUAnat9C7bwzMrYIxO5J3dPTUYBJnfZE=;
        b=K6u27U9gz9PkN7ZJWVHjQJD9YTjcdGLFJXptrnJvTQI07WmQGrRpwbJjKjfa+pg62x
         yeOt/mMvLJuug+/CaG1u4X4j+/aqq2nj9ESEBRxH2X0s1FNn/0oCuPtNaHIIwW6KEz1i
         Zdk/Y2iUea8ZebpJeSRvQusa2UnIqlko9ubhX/Yo0dqMuEgTc9H/RMQo+FMaAvMeKi6g
         QElboALFMx58dKVi6cN+UPRhCoEjrxkoWuqw03EOnhvzDPIZfr0JNo7D98TkT9TsrI69
         NdBQGsdaGKmkVw1r/9QmlLvUFU4gqViER9Fa1p8+x9TFAL1LZaEEU+f1tgfyIprmQPU6
         70lg==
X-Gm-Message-State: AC+VfDy6nqh5DM8rLPW6jDbFyRc8aML4vZuchDmiqsIzNMifak5GSwMg
        11YO8uZtObZ0g9lNo8upON3kO5QfaJc=
X-Google-Smtp-Source: ACHHUZ6B3oaUsi+ZJMd0uNjJjb3QcQdYtrO1DvYWUMIB8rCIIDCduDFQNU4LDgknZQ0l7eadMQ8Xamj1gWw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c091:0:b0:ba8:92bd:134c with SMTP id
 c139-20020a25c091000000b00ba892bd134cmr8887577ybf.0.1684856667142; Tue, 23
 May 2023 08:44:27 -0700 (PDT)
Date:   Tue, 23 May 2023 08:44:25 -0700
In-Reply-To: <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-6-aik@amd.com>
 <ZGv9Td4p1vtXC0Hy@google.com> <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com>
Message-ID: <ZGzfWQub4FQOrEtw@google.com>
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023, Alexey Kardashevskiy wrote:
>=20
>=20
> On 23/5/23 09:39, Sean Christopherson wrote:
> > On Tue, Apr 11, 2023, Alexey Kardashevskiy wrote:
> > > Prior to SEV-ES, KVM saved/restored host debug registers upon switchi=
ng
> > > to/from a VM. Changing those registers inside a running SEV VM
> > > triggered #VMEXIT to KVM.
> >=20
> > Please, please don't make it sound like some behavior is *the* one and =
only behavior.
> > *KVM* *chooses* to intercept debug register accesses.  Though I would o=
mit this
> > paragraph (and largely the next) entirely, IMO it's safe to assume the =
reader has
> > a basic understanding of how KVM deals with DRs and #DBs.
>=20
> Out of curiosity - is ARM similar in this regard, interceptions and stuff=
?

Yes.  The granularity of interceptions varies based on the architectural re=
vision,
and presumably there are things that always trap.  But the core concept of =
letting
software decide what to intercept is the same.

> > > SEV-ES added encrypted state (ES) which uses an encrypted page
> > > for the VM state (VMSA). The hardware saves/restores certain register=
s
> > > on VMRUN/VMEXIT according to a swap type (A, B, C), see
> > > "Table B-3. Swap Types" in the AMD Architecture Programmer=E2=80=99s =
Manual
> > > volume 2.
> > >=20
> > > The DR6 and DR7 registers have always been swapped as Type A for SEV-=
ES
> >=20
> > Please rewrite this to just state what the behavior is instead of "Type=
 A" vs.
> > "Type B".  Outside of AMD, the "type a/b/c" stuff isn't anywhere near u=
biquitous
> > enough to justify obfuscating super simple concepts.
> >=20
> > Actually, this feature really has nothing to do with Type A vs. Type B,=
 since
> > that's purely about host state.
>=20
> Mmm. Nothing? If the feature is enabled and DR[0-3] are not saved in HOST=
SA,
> then the host looses debug state because of the working feature.
>=20
> > I assume the switch from Type A to Type B is a
> > side effect, or an opportunistic optimization?
>=20
> There is no switch. DR[67] were and are one type, and the other DRs were =
not
> swapped and now are, but with a different Swap Type.

Ah, this is what I missed.

> And the patch saves DR[0-3] in HOSTSA but not DR[67] and this deserves so=
me
> explaining why is that.
>=20
> > Regardless, something like this is a lot easier for a human to read.  I=
t's easy
> > enough to find DebugSwap in the APM (literally took me longer to find m=
y copy of
> > the PDF).
>=20
> It is also easy to find "Swap Types" in the APM...

Redirecting readers to specs for gory details is fine.  Redirecting for bas=
ic,
simple functionality is not.  Maybe the swap types will someday be common k=
nowledge
in KVM, and an explanation will no longer be necessary, but we are nowhere =
near
that point.

> >    Add support for "DebugSwap for SEV-ES guests", which provides suppor=
t
> >    for swapping DR[0-3] and DR[0-3]_ADDR_MASK on VMRUN and VMEXIT, i.e.
> >    allows KVM to expose debug capabilities to SEV-ES guests.  Without
> >    DebugSwap support, the CPU doesn't save/load _guest_ debug registers=
,
>=20
> But it does save/load DR6 and DR7.
>=20
> >    and KVM cannot manually context switch guest DRs due the VMSA being
> >    encrypted.
> >=20
> >    Enable DebugSwap if and only if the CPU also supports NoNestedDataBp=
,
> >    which causes the CPU to ignore nested #DBs, i.e. #DBs that occur whe=
n
> >    vectoring a #DB.
>=20
> (english question) What does "vectoring" mean here precisely? Handling?
> Processing?

It's not really an English thing.  "Vectoring" is, or at least was, Intel t=
erminology
for describing the flow from the initial detection of an exception to the e=
xception's
delivery to software, e.g. covers the IDT lookup, any GDT/LDT lookups, push=
ing
information on the stack, fetching the software exception handler, etc.  Im=
portantly,
it describes the period where there are no instructions retired and thus uc=
ode doesn't
open event windows, i.e. where triggering another, non-contributory excepti=
on will
effectively "hang" the CPU (at least on CPUs without Intel's "notify" VM-Ex=
it support).

> >    the host by putting the CPU into an infinite loop of vectoring #DBs
> >    (see https://bugzilla.redhat.com/show_bug.cgi?id=3D1278496)
>=20
> Good one, thanks for the link.
>=20
> >=20
> >    Set the features bit in sev_es_sync_vmsa() which is the last point
> >    when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the mo=
st
> >    init happens) is called not only when VCPU is initialized but also o=
n
> >    intrahost migration when VMSA is encrypted.
> >=20
> > > guests, but a new feature is available, identified via
> > > CPUID Fn8000001F_EAX[14] "DebugSwap for SEV-ES guests", that provides
> > > support for swapping additional debug registers. DR[0-3] and
> > > DR[0-3]_ADDR_MASK are swapped as Type B when SEV_FEATURES[5] (DebugSw=
ap)
> > > is set.
> > >=20
> > > Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
> > > ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> > > supported by the SOC as otherwise a malicious SEV-ES guest can set up
> > > data breakpoints on the #DB IDT entry/stack and cause an infinite loo=
p.
> > > Set the features bit in sev_es_sync_vmsa() which is the last point
> > > when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the mos=
t
> > > init happens) is called not only when VCPU is initialized but also on
> > > intrahost migration when VMSA is encrypted.
> > >=20
> > > Eliminate DR7 and #DB intercepts as:
> > > - they are not needed when DebugSwap is supported;
> >=20
> > "not needed" isn't sufficient justification.  KVM doesn't strictly need=
 to do a
> > lot of things, but does them anyways for a variety of reasons.  E.g. #D=
B intercept
> > is also not needed when NoNestedDataBp is supported and vcpu->guest_deb=
ug=3D=3D0, i.e.
> > this should clarify why KVM doesn't simply disable #DB intercepts for _=
all_ VMs
> > when NoNestedDataBp is support.  Presumably the answer is "because it's=
 simpler
> > than toggling #DB interception for guest_debug.
>=20
> TBH I did not have a good answer but from the above I'd say we want to
> disable #DB intercepts in a separate patch, just as you say below.
>=20
> > Actually, can't disabling #DB interception for DebugSwap SEV-ES guests =
be a
> > separate patch?  KVM can still inject #DBs for SEV-ES guests, no?
>=20
> Sorry for my ignorance but what is the point of injecting #DB if there is=
 no
> way of changing the guest's DR7?

Well, _injecting_ the #DB is necessary for correctness from the guest's per=
spective.
"What's the point of _intercepting_ #DB" is the real question.  And for SEV=
-ES guests
with DebugSwap, there is no point, which is why I agree that KVM should dis=
able
interception in that case.  What I'm calling out is that disabling #Db inte=
rception
isn't _necessary_ for correctness (unless I'm missing something), which mea=
ns that
it can and should go in a separate patch.

> > As for DR7, the real justification is that, as above, KVM can't modify =
guest DR7,
> > and intercepting DR7 would completely defeat the purpose of enabling De=
bugSwap.
> >=20
> > > - #VC for these intercepts is most likely not supported anyway and
> > > kills the VM.
> >=20
> > I don't see how this is relevant or helpful.  What the guest may or may=
 not do in
> > response to a #VC on a DR7 write has no bearing on KVM's behavior.
>=20
> Readers of the patch may wonder of the chances of breaks guests. Definite=
ly
> helps me to realize there is likely to be some sort of panic() in the gue=
st
> if such intercept happens.

But that's irrelevant.  Intercepting DR7 writes will break the guest regard=
less
of how the guest deals with the #VC.  If the guest eats the #VC and continu=
es on,
the debug capabilities expected by the guest will still be missing, i.e. KV=
M has
broken the functionality of the guest.  I am total ok if the changelog desc=
ribes
the _possible_ scenarios (within reason), e.g. that the guest will either p=
anic
on an unexpected #VC or lose debug capabilities that were promised.  What I=
'm
objecting to is speculating on what the guest is _likely_ to do, and especi=
ally
using that speculation as justification for doing something in KVM.

> > > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > > ---
> >=20
> > ...
> >=20
> > > @@ -3048,6 +3066,18 @@ void sev_es_prepare_switch_to_guest(struct sev=
_es_save_area *hostsa)
> > >   	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value=
 */
> > >   	hostsa->xss =3D host_xss;
> > > +
> > > +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
> >=20
> > Since dangling a carrot didn't work[*], I'm going to resort to extortio=
n :-)
> > Can you fold the below somewhere before this patch, and then tweak this=
 comment
> > to say something like:
> >=20
> > 	/*
> > 	 * If DebugSwap is enabled, debug registers are loaded but NOT saved b=
y
> > 	 * the CPU (Type-B).  If DebugSwap is disabled/unsupported, the CPU bo=
th
> > 	 * saves and loads debug registers (Type-A).
> > 	 */
>=20
> Sure but...
>=20
> >=20
> > [*] https://lore.kernel.org/all/YzOTOzUzKPQSqURo@google.com/
> >=20
> >=20
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Mon, 22 May 2023 16:29:52 -0700
> > Subject: [PATCH] KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s c=
omment
> >   about swap types
>=20
>=20
> ... I am missing the point here. You already wrote the patch below which =
1)
> you are happy about 2) you can push out right away to the upstream. Are y=
ou
> suggesting that I repost it?

I am asking you to include it in your series because the comment I suggeste=
d above
(for DebugSwap) loosely depends on the revamped comment for sev_es_prepare_=
switch_to_guest()
as a whole.  I would like to settle on the exact wording for all of the com=
ments
in sev_es_prepare_switch_to_guest() in a single series instead of having di=
sjoint
threads.

> > Rewrite the comment(s) in sev_es_prepare_switch_to_guest() to explain t=
he
> > swap types employed by the CPU for SEV-ES guests, i.e. to explain why K=
VM
> > needs to save a seemingly random subset of host state, and to provide a
> > decoder for the APM's Type-A/B/C terminology.
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/sev.c | 25 +++++++++++++++----------
> >   1 file changed, 15 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 69ae5e1b3120..1e0e9b08e491 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3017,19 +3017,24 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
> >   void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> >   {
> >   	/*
> > -	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT=
,
> > -	 * of which one step is to perform a VMLOAD. KVM performs the
> > -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
> > -	 * traditional and SEV-ES guests.
>=20
>=20
> When I see "traditional", I assume there was one single x86 KVM before sa=
y
> 2010 which was slow, emulated a lot but worked exactly the same on Intel =
and
> AMD. Which does not seem to ever be the case. May be say "SVM" here?

This is the code being removed.  I agree that "traditional" is ambiguous, w=
hich
is why I want to delete it :-)

> > +	 * All host state for SEV-ES guests is categorized into three swap ty=
pes
> > +	 * based on how it is handled by hardware during a world switch:
> > +	 *
> > +	 * A: VMRUN:   Host state saved in host save area
> > +	 *    VMEXIT:  Host state loaded from host save area
> > +	 *
> > +	 * B: VMRUN:   Host state _NOT_ saved in host save area
> > +	 *    VMEXIT:  Host state loaded from host save area
> > +	 *
> > +	 * C: VMRUN:   Host state _NOT_ saved in host save area
> > +	 *    VMEXIT:  Host state initialized to default(reset) values
> > +	 *
> > +	 * Manually save type-B state, i.e. state that is loaded by VMEXIT bu=
t
> > +	 * isn't saved by VMRUN, that isn't already saved by VMSAVE (performe=
d
> > +	 * by common SVM code).
