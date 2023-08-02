Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE476D3DB
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjHBQiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 12:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjHBQiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 12:38:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B463213D
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 09:38:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5704970148dso80779327b3.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 09:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690994297; x=1691599097;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bhAxG79ln/OT1XZbIKyPMlD/ARdBQPDPShAe6Ux7R2A=;
        b=t1lIodt24PPOq4J83mjwoMAF3n2b3EFrlvfoLm1VsqaKrXJLyXO5JgoZO0kQZ1/a2J
         kJAavTqR0M3Ru7RvgwIxlBKiiD9pOGjvbKowORXAnNUFhsyamRVifSFV9q3w/4A7EOcV
         x8/ciezMU4ar2XoLzhkzTbx04Xn77yDH7BIsJ9qOI9M+1t1iRuSVR3+Dj2pDED5elU+y
         SIPA9zJEmV+DG8fiRFBOnzXry5cpiULjZBuf5ZFnPNLBsTm64rUfV2quCCn4HUbg05hy
         iR7EouAoq5TwBApXUrNye9+TDs4iEtlg8TWV6TAMSCJU4Qhy39Bps3oRvnFz2J79CTDz
         lVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690994297; x=1691599097;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bhAxG79ln/OT1XZbIKyPMlD/ARdBQPDPShAe6Ux7R2A=;
        b=eAxWoccsyJltr5WMXT1zadqmFzSVlDHDdCN4nHA0kh4z7qLoDTkBHn3/5m8o9cDw+9
         QN1qmsEgqse8fBhuJ3tk1U2EQ7FBnszlngcXKnCBVY6hyTScqKqMiDXwK8ZI0qXL4jyE
         UsOoLnJJAzW8HZ+B7mryxMND0chMoJPsdYoJt9HVul8GbLa+BXpyq3IDp16s+y6Y0b0M
         rUnSPfe+LM7CmWsaT6WxbE8UrizSez22o5IYvbvaAmYjVfus9IOWap31SbsaKfoTHSsr
         O1H5HPkLWiZ4mVacIYPw/0MxYM3koggnCHdm9InRxq99fUhaNWNC1/K38kjqpSoZgFNO
         iLTw==
X-Gm-Message-State: ABy/qLaFx8xoRXdFu2nCVUuT5zQLBuNQHPxfjLdtDHTWxfcwOGOt2PTM
        0M6bO/dLlPg+c6/8/KYsYs+z7gs+xSE=
X-Google-Smtp-Source: APBJJlEGnD59wJivf/Pv2DTt0qOtIYNYkpj6BsdQ7swR6zdImLk31gkwfyRpBZex0ZamS1ASzWljMcblK54=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:bc0c:0:b0:586:4fbc:4367 with SMTP id
 a12-20020a81bc0c000000b005864fbc4367mr106449ywi.10.1690994297318; Wed, 02 Aug
 2023 09:38:17 -0700 (PDT)
Date:   Wed, 2 Aug 2023 09:38:15 -0700
In-Reply-To: <580d2f69-a282-9b01-cd2d-0c46d9e1e8dd@intel.com>
Mime-Version: 1.0
References: <20230524155339.415820-1-john.allen@amd.com> <20230524155339.415820-5-john.allen@amd.com>
 <ZJYKksVIORhPtD6T@google.com> <ZMkie3B7obtTTpLu@johallen-workstation>
 <ZMkymz22bHTsFCTD@google.com> <ZMk6xzfVF0C+sTuK@johallen-workstation> <580d2f69-a282-9b01-cd2d-0c46d9e1e8dd@intel.com>
Message-ID: <ZMqGd582DGxOvmBG@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on VMRUN
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     John Allen <john.allen@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Weijiang Yang wrote:
>=20
> On 8/2/2023 1:03 AM, John Allen wrote:
> > On Tue, Aug 01, 2023 at 09:28:11AM -0700, Sean Christopherson wrote:
> > > On Tue, Aug 01, 2023, John Allen wrote:
> > > > On Fri, Jun 23, 2023 at 02:11:46PM -0700, Sean Christopherson wrote=
:
> > > > > On Wed, May 24, 2023, John Allen wrote:
> > > > > As for the values themselves, the kernel doesn't support Supervis=
or Shadow Stacks
> > > > > (SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS s=
upport is added,
> > > > > I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can=
 probably be
> > > > > ignored entirely, and PL0_SSP might be constant per task?  In oth=
er words, I don't
> > > > > see any reason to try and track the host values for support that =
doesn't exist,
> > > > > just do what VMX does for BNDCFGS and yell if the MSRs are non-ze=
ro.  Though for
> > > > > SSS it probably makes sense for KVM to refuse to load (KVM contin=
ues on for BNDCFGS
> > > > > because it's a pretty safe assumption that the kernel won't regai=
n MPX supported).
> > > > >=20
> > > > > E.g. in rough pseudocode
> > > > >=20
> > > > > 	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> > > > > 		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);
> > > > >=20
> > > > > 		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
> > > > > 			return -EIO;
> > > > > 	}
> > > > The function in question returns void and wouldn't be able to retur=
n a
> > > > failure code to callers. We would have to rework this path in order=
 to
> > > > fail in this way. Is it sufficient to just WARN_ON_ONCE here or is =
there
> > > > some other way we can cause KVM to fail to load here?
> > > Sorry, I should have been more explicit than "it probably make sense =
for KVM to
> > > refuse to load".  The above would go somewhere in __kvm_x86_vendor_in=
it().
> > I see, in that case that change should probably go up with:
> > "KVM:x86: Enable CET virtualization for VMX and advertise to userspace"
> > in Weijiang Yang's series with the rest of the changes to
> > __kvm_x86_vendor_init(). Though I can tack it on in my series if
> > needed.
>=20
> The downside with above WARN_ON check is, KVM has to clear PL{0,1,2}_SSP =
for
> all CPUs when SVM/VMX module is unloaded given guest would use them, othe=
rwise,
> it may hit the check next time the module is reloaded.

Off topic, can you please try to fix your mail client?  Almost of your repl=
ies
have extra newlines.  I'm guessing something is auto-wrapping at 80 chars, =
and
doing it poorly.

> Can we add=C2=A0 check as below to make it easier?

Hmm, yeah, that makes sense.  I based my suggestion off of what KVM does fo=
r MPX,
but I forgot that KVM clears MSR_IA32_BNDCFGS on VM-Exit via the VMCS, i.e.
effectively does preserve the host value so long as the host value is zero.

Not clearing the MSRs on module exit is a bit uncouth, but this is more or =
less
the same situation/argument for not doing INVEPT on module exit.  It's unsa=
fe for
a module to assume that there aren't TLB entries for a given EP4TA, because=
 even
if all sources of EPTPs (hypervisor/KVM modules) are well-intentioned and *=
try*
to clean up after themselves, it's always possible that a module crashed or=
 was
buggy.  I.e. asserting the the PLx_SSP MSRs are zero is simply wrong, where=
as
asserting that SSS is not enabled is correct.

> @@ -9616,6 +9618,24 @@ static int __kvm_x86_vendor_init(struct
> kvm_x86_init_ops *ops)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return -EIO;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (boot_cpu_has(X86_FEATURE_SHSTK)=
) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 rdmsrl(MSR_IA32_S_CET, host_s_cet);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (host_s_cet & CET_SHSTK_EN) {

Make this a WARN_ON_ONCE() and drop the pr_err().  Hitting this would very =
much
be a kernel bug, e.g. either someone added SSS support and neglected to upd=
ate
KVM, or the kernel's MSR_IA32_S_CET is corrupted.

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Curren=
t CET KVM solution assumes host supervisor
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * shadow=
 stack is always disable. If it's enabled
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * on hos=
t side, the guest supervisor states would
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * confli=
ct with that of host's. When host
> supervisor
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * shadow=
 stack is enabled one day, part of guest
> CET
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * enabli=
ng code should be refined to make both
> parties
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * work p=
roperly. Right now stop KVM module loading
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * once h=
ost supervisor shadow stack is detected on.

I don't think we need to have a super elaborate comment, stating that SSS i=
sn't
support and so KVM doesn't save/restore PLx_SSP MSRs should suffice.

> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */

Put the comment above the if-statment that has the WARN.  That reduces the
indentation, and avoids the question of whether or not a comment above a si=
ngle
line is supposed to have curly braces.

E.g. something like this, though I think even the below comment is probably
unnecessarily verbose.

		/*
		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
		 * so KVM doesn't save/restore the associated MSRs, i.e. KVM
		 * may clobber the host values.  Yell and refuse to load if SSS
		 * is unexpectedly enabled, e.g. to avoid crashing the host.
		 */
		if (WARN_ON_ONCE(host_s_cet & CET_SHSTK_EN))

Thanks!
