Return-Path: <kvm+bounces-70135-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YB0fBASfgmlgWwMAu9opvQ
	(envelope-from <kvm+bounces-70135-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:21:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE001E0679
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7284D31101B2
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BBB2701DC;
	Wed,  4 Feb 2026 01:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ew+HJTEz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49FF263F44
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770167794; cv=none; b=Rhimdik5CCtYkTtEqxKWVE4Qt9vHleZXLO4tIlZg3CNFyybvzB61XpybGZFVyoSdoZNFD2l0em8TZl2g1abSNdA7YlMWQnK7CpY3wu4VeVdZR5Ua1WxorZhRFuwov/Y1yto37iytrncbVklzsSPPV6yqu6ZJr1CKC6gNuJzaCt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770167794; c=relaxed/simple;
	bh=ChG3/8B1IJ9YT6VcPtOFh51Ez1qY+VBv1xR91btVjlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eJJVEWPw7+88TrZysk2fcNy+1Hd+2RpguSiMG7OlYORBh5oHfgQqIGXjnmEIh2XA9ECznh851q1YqW/O/c4FYNOfUzYCfX4OXID9MtCyHTGYyh4L+41Ahj3vefFJ7nlPL7w+B6mxnY+fOsReM4qnYoEwotCA1bw2QYrQnffu4rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ew+HJTEz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso16613914a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770167792; x=1770772592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mEfaDVPh64vLaMwr0r7Iy/qbZqBS6ygDFXVfCEVBmSo=;
        b=ew+HJTEzAr3yCbKZKM/ey7QB7nz3tlkQatjds68+kgJ3v9P29PEVisZhTii+e5Dj+e
         hh0PCDsR6+iT+ZP+V0bVup/ficMLXvjyT1WPEs31HDKqCiZrcrMSR4X0o2hL8SYYCCZC
         17d12SwVetKlS7lrfS/UkU2DBmAl5aVtYGyJaWucoB/XHqUqDkvIf8Waa27M/K26ku0w
         oasutRzbhOq0wjXfB8bhkSo3vf8Rbag/n/dHzkUDnYtCb94vZQH/VZ4WT1vlnzgGs2yi
         sdrGh0r2m6TPkuiIzqHOmgBKHNfB9WA50dcARpM4J5qZm7gp+qpZrIiK8soa5xTwcmJG
         U/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770167792; x=1770772592;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mEfaDVPh64vLaMwr0r7Iy/qbZqBS6ygDFXVfCEVBmSo=;
        b=vaK8sFR2y88tDIBOcR7m9GAOp2KPAKSLwXF4rEeFTzZNs0Y01PWXKi3zBY6jYKvG57
         htNb70DZ3jc5RBFZZFTA+oeoiiBIccW+m5N3krHoDROivWHsD+U2DnUtoBXcTom0k4pb
         49CCiCb52vP8TbI0vee8rLhspG+EsmDPXPmfTEdUoad+uXTdKzqKFn5vC/Y7IqtZwLvh
         O3HFyk/oviFVeRa0ZRw0m6Q6/zRMooRIml3rqr2FraJKExKiRhBdJyHg9yh5XCnhO3AA
         ljshBlWtLsYRgHMV0A2FUg0I4B6LQiKiGXUJWa1Gw3qfbfAzq84n9PA2HRBg2oyaadRC
         SOGw==
X-Gm-Message-State: AOJu0YyY9XKoWQCqwd/TRizVHW0/urbCUO5rPcluLbVCn+TopFVYuHZ/
	E6WUPiCp4QFIKokJmXm9hjYXNlKDergusYQDGGJpSwaVUuCvCYvRsPBOyctexKM4Qqgowl70Xk7
	kzhOvHA==
X-Received: from pjro9.prod.google.com ([2002:a17:90a:b889:b0:34c:567d:ede4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270d:b0:34e:808c:95eb
 with SMTP id 98e67ed59e1d1-354871bef6bmr1029972a91.32.1770167792234; Tue, 03
 Feb 2026 17:16:32 -0800 (PST)
Date: Tue, 3 Feb 2026 17:16:30 -0800
In-Reply-To: <e3feb0224cf2665a71ba6147e4e3e3bb30f96760.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-5-seanjc@google.com>
 <f9f65b0fad57db12e21d2168d02bac036615fb7f.camel@intel.com>
 <aXwJIkFJw_4mRl70@google.com> <e3feb0224cf2665a71ba6147e4e3e3bb30f96760.camel@intel.com>
Message-ID: <aYKd7qSExlJrbolH@google.com>
Subject: Re: [RFC PATCH v5 04/45] KVM: x86: Make "external SPTE" ops that can
 fail RET0 static calls
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "tglx@kernel.org" <tglx@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	Vishal Annapurve <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70135-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AE001E0679
X-Rspamd-Action: no action

On Fri, Jan 30, 2026, Rick P Edgecombe wrote:
> On Thu, 2026-01-29 at 17:28 -0800, Sean Christopherson wrote:
> >=20
> > Hmm, that's probably doable, but definitely in a separate patch.=C2=A0
> > E.g. something
> > like:
>=20
> I think it would be a good change. But after more consideration, I
> think the original patch is good on its own. Better to turn a bug into
> a deterministic thing, than an opportunity to consume stack. Seems to
> be what you intended.
>=20
> Another idea would be to have a variant that returns an error instead
> of 0 so the callers can have there error logic triggered, but it's all
> incremental value on top of this.

I don't like that idea, at all.  First and foremost, I don't want to litter=
 KVM
with WARNs for things that simply can't happen.  I'm fine adding infrastruc=
ture
that hides the sanity checks, but I don't want to bleed that into callers.

The other aspect I dislike is that returning a specific errno could lead to=
 all
sorts of weirdness and hidden dependencies.

All in all, I think we'd be increasing the chances of creating bugs just to=
 harden
against issues that in all likelihood will never happen.

