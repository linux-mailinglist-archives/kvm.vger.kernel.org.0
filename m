Return-Path: <kvm+bounces-70083-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLUvNbZbgmlhSwMAu9opvQ
	(envelope-from <kvm+bounces-70083-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:33:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D05DDE861
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C14E330F20C1
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262E736680D;
	Tue,  3 Feb 2026 20:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="twRgEPQr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF891E8332
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 20:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770150729; cv=none; b=V53dj1pRCedLb4OVWDx8wj/keSC3hvcQ/Aw1ecrg2Ea1qK5C4iGhVTnP53SO5CBdNQi+qsxG044Nfu4KBwqdo64eeNeUSb1Vd+S2XUrdaGkR3JBM5RjgtQ4t287vO3hVifGcpK9YpN1N/k+ACkGfWDDPsYOwf9biuVaOzly/caU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770150729; c=relaxed/simple;
	bh=bKHWA8su8QIXIXtDVlgoocC0CLqf6RJFADPLXMN6Yqg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YOQnsOjS6gUZKDbv8ypfaK9whW0CKXYvgwoZLARCUIYt4XG3ZezwF49SgKTBuRFS9sOnmlTZ2auk3DUK1q7MjbFdJjkLW5wsLZ2PL2uY5A6TqCesjk7/3b6esACZa4TzNjr68C2i+/HA7osnZKr8azZqeGikh5pB1P+QdpCkydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=twRgEPQr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a75ed2f89dso52637505ad.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 12:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770150727; x=1770755527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sro3VZZ5Btk693WGQpZmCjZMxNDIjNnXRKqN3fdBlbA=;
        b=twRgEPQrx8ihipmSjeIbE43pizWMUk8KGSj42Ictd9w59m6GTbRfzKWdLBRMkgD0ZN
         oOklaLVgCcYYr9f5SReacSbDepVAniet8UfBCIXKuSfcfUBupdF8FQWTKThXcF+1/8Yv
         ENHw0Z1evIYIsoTaFH5vlDdTi+bZmUWOBMit45sHVMRT/k3UWXLAfKbt6Pmuyr++3UgM
         kBhOJfaUXbINgrdmmvqBfqWReL1wCjo2a8KOpcbiPf+FeqoF8Iym+SiKQdX+T7gtwM1d
         cqf9P6Q08ZjByCkoUIVV2003ImhnvS2MTLmjwfvo76aWncDnrETNm5TEOYweMeTWOQiY
         mUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770150727; x=1770755527;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Sro3VZZ5Btk693WGQpZmCjZMxNDIjNnXRKqN3fdBlbA=;
        b=u9n6ff8wbswLpF0gnX6TsAwXliO4vr/GuhwMoWiQCCmfoaq7UlO61o9CwtPJT4YoIJ
         ML7vk4MXFDDseTjYgBIzwquyR/2Ak+oWGUpitfxfrbph6y+/njTrV4AH+LzmvTttZ5Kf
         5YkC5/Fvzntcje/e9me+cAyVLE4l326m7hyE0v++Pq21oN/C96XmCDJjfjEXLCczhzVn
         umeD+dgL1lZzVmpsEDttlzH/ePWYGYrQAnFPgAA20bMVw1NOvl6HkJiPqiYGW6stfOZ6
         evRiQTJkPKZ/rz9bSE45xFTy8EPa9PHRCOGYXoyQ8E4vgxlKjTv+aySL2bojSTH6712p
         o+3w==
X-Forwarded-Encrypted: i=1; AJvYcCUHbBjWlxNO5RmKFk+FDjzcP93ZGR9jNtqm7dsVj/sT3u6vQiaMwibBQBmFAN9YUeGC/94=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVo0UnwfDIIvlZnRL6yBp8fz4228Sg1GgXoBU7rE7uzT9l1jt6
	1Y5YkOEzFngrexp12EEfL83GI7fUWbV6H696X0wGCrbE7ci8cenlUZSxn+tZ10AaQiC4apvPVdm
	YkaKWRw==
X-Received: from plav14.prod.google.com ([2002:a17:902:f0ce:b0:2a7:6eb5:7e34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e807:b0:2a7:b8f9:5a5e
 with SMTP id d9443c01a7336-2a933feb333mr5180435ad.46.1770150727058; Tue, 03
 Feb 2026 12:32:07 -0800 (PST)
Date: Tue, 3 Feb 2026 12:32:05 -0800
In-Reply-To: <8c5aca4bacb31475a510e6a109956e7fa4a63de5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-12-seanjc@google.com>
 <cd7c140a-247b-44a7-80cc-80fd177d22bb@intel.com> <aXvEgD69vDTPj4z5@google.com>
 <8c5aca4bacb31475a510e6a109956e7fa4a63de5.camel@intel.com>
Message-ID: <aYJbRTi_Z28F9is-@google.com>
Subject: Re: [RFC PATCH v5 11/45] x86/tdx: Add helpers to check return status codes
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	Vishal Annapurve <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70083-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3D05DDE861
X-Rspamd-Action: no action

On Fri, Jan 30, 2026, Rick P Edgecombe wrote:
> On Thu, 2026-01-29 at 12:35 -0800, Sean Christopherson wrote:
> > On Thu, Jan 29, 2026, Dave Hansen wrote:
> > > On 1/28/26 17:14, Sean Christopherson wrote:
> > > ...
> > > > =C2=A0=C2=A0	err =3D tdh_mng_vpflushdone(&kvm_tdx->td);
> > > > -	if (err =3D=3D TDX_FLUSHVP_NOT_DONE)
> > > > +	if (IS_TDX_FLUSHVP_NOT_DONE(err))
> > > > =C2=A0=C2=A0		goto out;
> > > > =C2=A0=C2=A0	if (TDX_BUG_ON(err, TDH_MNG_VPFLUSHDONE, kvm)) {
> > >=20
> > > I really despise the non-csopeable, non-ctaggable, non-greppable name=
s
> > > like this. Sometimes it's unavoidable. Is it really unavoidable here?
> > >=20
> > > Something like this is succinct enough and doesn't have any magic ##
> > > macro definitions:
> > >=20
> > > =C2=A0	TDX_ERR_EQ(err, TDX_FLUSHVP_NOT_DONE)
>=20
> I like the editor friendliness. The only downside is that it puts the onu=
s on
> the caller to make sure supported defines are passed into TDX_ERR_EQ().

Eh, that's easy enough to handle with a static_assert().

> Today there are a few special cases like IS_TDX_NON_RECOVERABLE().

Why bother with a wrapper for that one?  It's a single bit, just test that =
bit.
For me, providing IS_TDX_NON_RECOVERABLE() is _more_ confusing, because it
suggests that there's a NON_RECOVERABLE error, when in fact (IIUC) it's mor=
e or
less a modifier.

> I don't know, I'm ok either way. I lean towards keeping it as in this pat=
ch
> because we already had an error code bit interpretation bug:
> https://lore.kernel.org/kvm/24d2f165-f854-4996-89cf-28d644c592a3@intel.co=
m/
>=20
> So the centralization of bit interpretation seems like a real win.
>=09
> > FWIW, I have zero preference on this.=C2=A0 I included the patch purely=
 because it was
> > already there.
>=20
> Ha, actually we all had a long thread on this:
> https://lore.kernel.org/kvm/70484aa1b553ca250d893f80b2687b5d915e5309.came=
l@intel.com/

Oh, it's _that_ discussion :-)

What I meant was, "I don't have a strong preference between TDX_ERR_EQ() an=
d
this patch".  What I didn't like was tdx_operand_invalid(), because that re=
ads
like a command and it's not at all clear that it's macro-like in behavior.

I'd vote for IS_TDX_ERR() over TDX_ERR_EQ(), but either works for me (as do=
es
this patch).

> I see now that we closed it with you but never got Dave's final buy in.

