Return-Path: <kvm+bounces-22043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 289E7938E86
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 13:56:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 599B01C21114
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 11:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEF516D337;
	Mon, 22 Jul 2024 11:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JO8Kt4ES"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CECB16CD3B;
	Mon, 22 Jul 2024 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721649355; cv=none; b=euBWtocYV6a2oiyvzqOcbPaQ38VmYiMe6L8wZsZZzMHpNC26+dX0KFcR63Wpj8h6LfdzxFf/Jiuv8AauW5njM7yCApHGizCBpOCyzHgfyPzOF9o2P/bLT9SEyn0h7LxSy7VLgFXR5PHA4z52SxuputqiAeozF60quJsRuyOZBzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721649355; c=relaxed/simple;
	bh=jdZOd+1x/UUwORwUz2YLmGgfUG/GAuQjIIUf2/RLMD8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iarpYOb0BnY8++Xo5uDcys2fuc5YhfTCRNbSyub13ABnQIqE6FEIopAFBVPQGwId1A9qao8HPoTTAAVwxakAJ8O9dJ+AbfqWZJc+0u3r40ScbDl1IK+3A8M3Wp/wUP4BkWnA7dYtGyHe89khco+BON+epKhNdI/f86i/O4oULYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JO8Kt4ES; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6701C116B1;
	Mon, 22 Jul 2024 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721649354;
	bh=jdZOd+1x/UUwORwUz2YLmGgfUG/GAuQjIIUf2/RLMD8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=JO8Kt4ESCie2QzLgfzTe+N+WlH/PTKW+HGMPmphWK6eRrsqvSp9v43TyCR3ri+dFB
	 1gGTcwpV9XATI4RVtCuapHxp+o6R0wExoj1M+gY1eHytMfw8vKE03Km8oq/c193cN2
	 3Qz5tdHCQ9pQrOfoLa7bPa2JNFdauo7pmEwIuEnNdqwy4MmwP9j2U54hJ4xrkt3w7E
	 qRH+zodkwDXs6azmgWSO+6hzQZtdvK7K8/VSfeL3Ju44purrQ9W7GyWoMBkGbxKvVl
	 5i+w9pPvUOfLKNhYekwgco7ZVGIiSXl19KAOG/LXWOI2kAZOM9ABY9XZT+HyVIFSuL
	 rYjmN3iQ+9I4g==
Message-ID: <1cd7516391a4c51890c5b0c60a6f149b00cae3af.camel@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
From: Amit Shah <amit@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: David Kaplan <David.Kaplan@amd.com>, Jim Mattson <jmattson@google.com>, 
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org"
 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,  "mingo@redhat.com"
 <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, Kim Phillips <kim.phillips@amd.com>
Date: Mon, 22 Jul 2024 13:55:49 +0200
In-Reply-To: <ZpbFvTUeB3gMIKiU@google.com>
References: <20240626073719.5246-1-amit@kernel.org>
	 <Zn7gK9KZKxBwgVc_@google.com>
	 <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
	 <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org>
	 <DS7PR12MB57665C3E8A7F0AF59E034B3C94D32@DS7PR12MB5766.namprd12.prod.outlook.com>
	 <Zow3IddrQoCTgzVS@google.com> <ZpTeuJHgwz9u8d_k@t470s.drde.home.arpa>
	 <ZpbFvTUeB3gMIKiU@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 (3.52.3-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-07-16 at 12:10 -0700, Sean Christopherson wrote:
> On Mon, Jul 15, 2024, Amit Shah wrote:
> > On (Mon) 08 Jul 2024 [11:59:45], Sean Christopherson wrote:
> > > On Mon, Jul 01, 2024, David Kaplan wrote:
> > > > > >=20

(snipped to what is now emerging as the core of the discussion)


> > Also - reviewers of code will get confused, wondering why this code
> > for AMD exists when the CPU vuln does not.
> >=20
> > I get that we want to write defensive code, but this was a very
> > special condition that is unlikely to happen in this part of the
> > code,
> > and also this was missed by the devs and the reviewers.
>=20
> Defensive code is only part of it, and a minor part at that.=C2=A0 The
> main "issue" is
> having divergent VM-Enter/VM-Exit code for Intel vs. AMD.=C2=A0 To those
> of us that
> care primarily about virtualization and are only passingly familiar
> with the myriad
> speculation bugs and mitigations, omitting RSB_VMEXIT_LITE _looks_
> wrong.
>=20
> To know that the omission is correct, one has to suss out that it's
> (supposed to
> be) impossible for RSB_VMEXIT_LITE to be set on AMD.=C2=A0 And as a KVM
> person, that's
> a detail I don't want to care about.

OK - I get that.  Cognitive overload is a real thing, and the less of
it the better.

Since this isn't a discussion about any AMD bug or implementation
detail, but rather a uniformity in KVM code across different CPU
implementations from different vendors, I prefer someone else code up
the patch to add that uniformity.  I don't have an objection to that.

I can of course offer a comment in this hunk, though, that says AMD
does not have the bug that necessitates VMEXIT_LITE, and that should
help in the meantime.  You've not queued this patch yet, right?  Do you
think it's better I do a v3 with this comment update?

> FWIW, I feel the same way about all the other post-VM-Exit
> mitigations, they just
> don't stand out in the same way because the entire mitigation
> sequence is absent
> on one vendor the other, i.e. they don't look wrong at first glance.=C2=
=A0
> But if KVM
> could have a mostly unified VM-Enter =3D> VM-Exit assembly code, I
> would happliy eat
> a dead NOP/JMP or three.=C2=A0 Now that I look at it, that actually seems
> very doable...

Sure.  I think some of the fallacy there is also to treat VMX and SVM
as similar (while not treating the Arm side as similar).  They are
different implementations, with several overlapping details - but it's
perilous to think everything maps the same across vendors.


		Amit

