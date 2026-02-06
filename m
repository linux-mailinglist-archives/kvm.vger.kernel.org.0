Return-Path: <kvm+bounces-70471-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kK9dJu8xhmmcKQQAu9opvQ
	(envelope-from <kvm+bounces-70471-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:24:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE73101C78
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07ACF3045219
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF2C413238;
	Fri,  6 Feb 2026 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gv4P5OBM"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBDE426D1F;
	Fri,  6 Feb 2026 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402230; cv=none; b=p/Ug+lDkwBPN5XoqhpCRrbmlfut1llb4ufM3N2rjfS7LpYlOPW+hzGcydBI+VaSqsZnpY2PHgNdrLDd95IhJ/mZV8dNlso4ilD8dzP3M/+L9GZY3DmhI7cVZewfM5FFfL3AxnHCDQlFVyRsGPL8/Z9VDM1WwOpYhh0eheq/CbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402230; c=relaxed/simple;
	bh=PPmf/TTwe2EPf5X2ReEiLE8ehMGgo5rNVgEZzhhuGAw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=eCmBvWIN8jhJFO+4x8kDwjszxTEvku28qbFiyjSdYqqdHddgLXx6ffJozgTU+OgYWLAtr7kocw4kC0lFLCAxt/eXADQIEm7RK751jbCZf6OSsUs6ikr9Zsu6re87DkzvuzdKeraYEkWBguRiifaamQA6m6yhlSUeJwXheIZU5oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gv4P5OBM; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770402217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j8eeD2/8SMFZNgS0pJi9UHSBdDAom1iHyyBEp3tHmS4=;
	b=Gv4P5OBMyA8MEpTQ3IJyh7Lc47yvlyQnmg10qe4R0sWzykYphIRwK3LanUcUMaIXRIajBQ
	OmTmSqezteSFncYhEQ8ccI0xyyUZVTYu0gDVMS5Sryn3ukafrg5qycxUFTOcoEom7KoFwk
	MbHU5YcArar7fkInc4t5m33uiofyOZA=
Date: Fri, 06 Feb 2026 18:23:35 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <fb750b1bb21bd47f85eb133d69b2c059188f4c05@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
To: "Sean Christopherson" <seanjc@google.com>, "Jim Mattson"
 <jmattson@google.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "Shuah Khan"
 <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
In-Reply-To: <aYYwwWjMDJQh6uDd@google.com>
References: <20260205214326.1029278-1-jmattson@google.com>
 <20260205214326.1029278-3-jmattson@google.com>
 <aYYwwWjMDJQh6uDd@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70471-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EAE73101C78
X-Rspamd-Action: no action

February 6, 2026 at 10:19 AM, "Sean Christopherson" <seanjc@google.com> w=
rote:


>=20
>=20On Thu, Feb 05, 2026, Jim Mattson wrote:
>=20
>=20>=20
>=20> Cache g_pat from vmcb12 in svm->nested.gpat to avoid TOCTTOU issues=
, and
> >  add a validity check so that when nested paging is enabled for vmcb1=
2, an
> >  invalid g_pat causes an immediate VMEXIT with exit code VMEXIT_INVAL=
ID, as
> >  specified in the APM, volume 2: "Nested Paging and VMRUN/VMEXIT."
> >=20=20
>=20>  Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> >  Signed-off-by: Jim Mattson <jmattson@google.com>
> >  ---
> >  arch/x86/kvm/svm/nested.c | 4 +++-
> >  arch/x86/kvm/svm/svm.h | 3 +++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >=20=20
>=20>  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> >  index f72dbd10dcad..1d4ff6408b34 100644
> >  --- a/arch/x86/kvm/svm/nested.c
> >  +++ b/arch/x86/kvm/svm/nested.c
> >  @@ -1027,9 +1027,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> >=20=20
>=20>  nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> >  nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> >  + svm->nested.gpat =3D vmcb12->save.g_pat;
> >=20=20
>=20>  if (!nested_vmcb_check_save(vcpu) ||
> >  - !nested_vmcb_check_controls(vcpu)) {
> >  + !nested_vmcb_check_controls(vcpu) ||
> >  + (nested_npt_enabled(svm) && !kvm_pat_valid(svm->nested.gpat))) {
> >  vmcb12->control.exit_code =3D SVM_EXIT_ERR;
> >  vmcb12->control.exit_info_1 =3D 0;
> >  vmcb12->control.exit_info_2 =3D 0;
> >  diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> >  index 986d90f2d4ca..42a4bf83b3aa 100644
> >  --- a/arch/x86/kvm/svm/svm.h
> >  +++ b/arch/x86/kvm/svm/svm.h
> >  @@ -208,6 +208,9 @@ struct svm_nested_state {
> >  */
> >  struct vmcb_save_area_cached save;
> >=20=20
>=20>  + /* Cached guest PAT from vmcb12.save.g_pat */
> >  + u64 gpat;
> >=20
>=20Shouldn't this go in vmcb_save_area_cached?

I believe Jim changed it after this discussion on v2: https://lore.kernel=
.org/kvm/20260115232154.3021475-4-jmattson@google.com/.

