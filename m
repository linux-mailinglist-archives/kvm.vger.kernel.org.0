Return-Path: <kvm+bounces-49095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7193EAD5DEA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 996FC189F5B9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA3826B2C5;
	Wed, 11 Jun 2025 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndzXYe66"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A5A50
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665637; cv=none; b=V13u0lH1JtkGTm6s3fAk/SaXItl1Y0T0IQQiWsUwdGeE4myQvxUGZDg0WrCvMKo5LGHbRRzls8f14RMkTxV21V36+XQU6LyC0wV6uCvLONwGd4dGkUyEARM185YMNpeRuREWlp+61oeVuaLNp+MO1rqMdnEzegIvP7Eo8lvZ/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665637; c=relaxed/simple;
	bh=IeatVXM/VPJssVAVzMs9KocuyEJiD/TQkBaPU8yqP9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uiAjIXJ/eQZ5+dxiLve4LaMu8YW6CI3eb7PWQgG2Hm6B/vYzwyrFtO4J/6wmr9jCC549eMUwYdcdZe6k2zW1153hH2QQGAQP3GRbC9GwXiPG/kNHXjcuWo3uiahxqTyE0yi7EFZ4tSXHM6kOTbi+R07mLHgJlQKh4TWvynpEaew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndzXYe66; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so139432a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 11:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749665636; x=1750270436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9AP2CEelaM2vm+ln8/2uTSplrSdzavfE46dg+YRKF6M=;
        b=ndzXYe668sooADCn2WBwnrVPfUuujajE2G/4oR3/zAGlUEJXQjNsMC57m+vsx6zntP
         Kkr3mZVEOhYtnw3Di0PGZ7OI2MhRhckGWQHVqfDhE2HTZ6pYtSGMMXBKNNSj25nrzmP7
         Lb9opzc1hVnkI9WT+kfkVMiM9pcIuVjSwmNP3j4gA3a/W65AE12OejD8Lt20wNE1tDY1
         w04c2q2L+8f1xEPcajzCxHcwdtrEp0Rq43qJ9XpQKpsyRu7TDFwnyT4qfmwU7AqzOLVg
         aeZYnW45LDcbO2Ewn5CJp0gTuZKLmaqnYtc2AvAYj3xw6OPmvieh8nk0PX9r/LSZ/2Jb
         8lKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749665636; x=1750270436;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9AP2CEelaM2vm+ln8/2uTSplrSdzavfE46dg+YRKF6M=;
        b=UfMDUU9hBFo+Kp0h1/V959Go+NLu6I/Jmj2BtUWVQ/mfEiW5PjksMN2EPatWOdTf9A
         zaU9PF3DIHsaP8aFZHqcryGz32s8iJRhfKfYIDhx/uLvTpxrzenE0hh+WqXI69HMUK7i
         afch0CKcckSxQo9IctnP0iHbVLa+ui+7Q7cEE4zuLn/gqYfaZ8NEZ0mWqOC04d5HAFta
         s6zvI+ckouWRye7Bq/xWtGT6M1LOduR7QCxZ8cwSwOR9wiUXoNg5NJqb2XQbrYf/lCEf
         3Sdk1l8eXeIKWbMTsiCQ1Wohn/aeEJbva/L8fT52AjgOD8vsc/IXiUgThV6IdVu3uFnc
         tWIw==
X-Forwarded-Encrypted: i=1; AJvYcCUi3Vob9gYh3iG7yJjMNnM0Ya0XlFT0m0MxfQRnwE6SUb/1ETXMpmTKwnwvwy+4o3boM9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL5c2OGJtfYdtai8KSyBXxIZtFQWGOjgxQnSC/hPRCBMNLzhqS
	qb3weGhKQspfYD2TLffT3q1U2R9teW7EZmnl4Ps1rEd/c2kuBGOBSgpbl9CEeEP6kT+ni/4odgq
	pPwYYEw==
X-Google-Smtp-Source: AGHT+IFHVGTO4vjh2VGjTQJUjZQ7j92tMCP8tpw8KYudlqm/NMDL6qN15xcu4YOSiQLv7dKLIC6IDIM5PMg=
X-Received: from pjcc3.prod.google.com ([2002:a17:90b:5743:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5410:b0:312:e6f1:c05d
 with SMTP id 98e67ed59e1d1-313af0fce66mr6663752a91.2.1749665635713; Wed, 11
 Jun 2025 11:13:55 -0700 (PDT)
Date: Wed, 11 Jun 2025 11:13:54 -0700
In-Reply-To: <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com> <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com> <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
 <aEmYqH_2MLSwloBX@google.com> <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
 <aEmuKII8FGU4eQZz@google.com> <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
Message-ID: <aEnHYjTGofgGiDTH@google.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Jiewen Yao <jiewen.yao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tony Lindgren <tony.lindgren@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Kirill Shutemov <kirill.shutemov@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-06-11 at 09:26 -0700, Sean Christopherson wrote:
> > > GetQuote is not part of the "Base" TDVMCALLs and so has a bit in
> > > GetTdVmCallInfo. We could move it to base?
> >=20
> > Is GetQuote actually optional?=C2=A0 TDX without attestation seems rath=
er
> > pointless.
>=20
> I don't know if that was a consideration for why it got added to the opti=
onal
> category. The inputs were gathered from more than just Linux.

If there's an actual use case for TDX without attestation, then by all mean=
s,
make it optional.  I'm genuinely curious if there's a hypervisor that plans=
 on
productizing TDX without supporting attestation.  It's entirely possible (l=
ikely?)
I'm missing or forgetting something.

