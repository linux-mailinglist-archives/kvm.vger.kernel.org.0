Return-Path: <kvm+bounces-39186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FA1A44EE1
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B51D83AE01D
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F7D20E70C;
	Tue, 25 Feb 2025 21:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GdepzR04"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0118B1A23BD
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 21:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518942; cv=none; b=Of78qMfWnA9DX3WAUMD+cfepD5NqF3Ht6xxaSmM0OTVDMa5Rzb7slkOyaid//EqUog/26ihwNkAKzbetHiHiQQt11jC3p4TYUn01CZX0Ygcq1zkjnli0+SByvSOEUUFVieF9MFVSgrEF6jo5jlus1GOD0UORmBisPKM2b/0R6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518942; c=relaxed/simple;
	bh=H0nqRbCByViU1xjhp7Dx7fcYBfMIWPdsMoNXbbQoMlg=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=jpV29LMvA7lRArDJloApYFCAts1DEWTiYRr2s0Wevso8bRdZM1hZ8MhTiA9MfxYPl4wUvgsBwjWd8h4e/ugmIr9qkkKTNYxFYfdiG5EKumG0/LJyxryO+D+1y3eupFKu9p+1Pm28if0s7C6yTeDFzpuGD7fnazOxfZtGR3b3IDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GdepzR04; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740518939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/89WU6W64pAO6mTgkt5TaBrkeX/9/DXa+3FL51mqM/8=;
	b=GdepzR04DpXYaw7NLiPK67yqbgIcnWkHmV/HYvLDfKunHfcxjaVcJeyO+iuYZGxqAWZatA
	o57ffZulXDa+NUx3wx+4oLoIPc5A46dEmNjoDFF8i0illZwfzARbuzx7kA/31wCnN9NZG8
	m4yK4kutNeZoZyEKrpctBq6pfmR5NBw=
Date: Tue, 25 Feb 2025 21:28:56 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <76526510ba3a81f812d16aabb3b45e2dead2fa35@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 1/6] x86/bugs: Move the X86_FEATURE_USE_IBPB check into
 callers
To: "Sean Christopherson" <seanjc@google.com>
Cc: x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar"
 <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>, "Andy Lutomirski"
 <luto@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Z74eaeYm_EgHbmNn@google.com>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
 <20250219220826.2453186-2-yosry.ahmed@linux.dev>
 <Z74eaeYm_EgHbmNn@google.com>
X-Migadu-Flow: FLOW_OUT

February 25, 2025 at 11:47 AM, "Sean Christopherson" <seanjc@google.com> =
wrote:
>=20
>=20On Wed, Feb 19, 2025, Yosry Ahmed wrote:=20
>=20>=20
>=20> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >  index 6c56d5235f0f3..729a8ee24037b 100644
> >  --- a/arch/x86/kvm/vmx/vmx.c
> >  +++ b/arch/x86/kvm/vmx/vmx.c
> >  @@ -1478,7 +1478,8 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu,=
 int cpu,
> >  * may switch the active VMCS multiple times).
> >  */
> >  if (!buddy || WARN_ON_ONCE(buddy->vmcs !=3D prev))
> >  - indirect_branch_prediction_barrier();
> >  + if (cpu_feature_enabled(X86_FEATURE_USE_IBPB))
>=20
>=20Combine this into a single if-statement, to make it readable and beca=
use as-is
> the outer if would need curly braces.
> And since this check will stay around in the form of a static_branch, I=
 vote to
> check it first so that the checks on "buddy" are elided if vcpu_load_ib=
pb is disabled.
> That'll mean the WARN_ON_ONCE() won't fire if we have a bug and someone=
 is running
> with mitigations disabled, but I'm a-ok with that.


SGTM, will do that in the next version. Thanks!

