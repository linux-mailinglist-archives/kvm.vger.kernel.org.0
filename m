Return-Path: <kvm+bounces-68810-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WO0kCTJRcWkKCQAAu9opvQ
	(envelope-from <kvm+bounces-68810-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:20:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A865EB3B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 97B03802076
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBEFF450905;
	Wed, 21 Jan 2026 22:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kCTbJJ1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1740743E485
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769033538; cv=none; b=XKEFEGsOspEzU1hCZqzu+9U+4GXFPeVH9lvykaDM+7A9cyeLdqHRMSC1ZdeBjBnYi6Y50y6pPiSct+4SqQ8Ft9oiFV0foAoV29JJlZvC+av4w9XxHFjPOf3gyt2fvfJIoc38KFmbQZU9J6qfGoT/g6pkCaVMxS+VfFuH27i0ORM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769033538; c=relaxed/simple;
	bh=tWIojze7Uj2EM7vNRu2AjQDw+wemuXBR7n+CBdw4tjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y/OCtzkWSmg1M65GqUZ+Ts0RzX0jYEbRuX4BUJ+fWKi2bQV8mtAdtne6xEF3ALUryqapE8tz8q4SexIbXgSW3bedGtHK3rwOBTKBY0PXdmRyBQJP5sLesjTnrK1V3Z1NOn3IULc9RzGbiovlYzsiu8d5xmeCN17Y1O6uKkqkG+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kCTbJJ1F; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0bb1192cbso2090085ad.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769033527; x=1769638327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6X4IkRQuNjfo8L0KHGq4+kOsjjdeSYBGnFI9g0tePg=;
        b=kCTbJJ1FCYTKxQGXh8Bq+ttAkMCMNGcpB0f9ZhxT/KBQEqZ47cpn/kz+2FPqX7zEV+
         xRvBaPhvAmCYbJyAzcOYi356Z3xS7B6ORyTcui5L5K3xkjCNIY2MseF1lWldwAMQnDZI
         TyVYr/S1UnKzbQ5huatI3x04H3Wqs+AmNlAx+NXXQ0jjTJf0Hk+AM76mQYiVK8kG/0/I
         EoOYpGL1rebs86RlNzmQwgl4doQdSZkCZXn7qpsv6MXbwwKfR/QIr4f2KM3bfuGPJ14L
         4MxaWn7RvAP1UBYoI3z6C6ZidkoeISKcT5xu0g9IDsEmYAYtxK1GngUKxwv2E/sE9K81
         yKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769033527; x=1769638327;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C6X4IkRQuNjfo8L0KHGq4+kOsjjdeSYBGnFI9g0tePg=;
        b=JCyrEuTsTwcz2qEBqiulu6r32KklqmWv4sNYI6AAVFF15OiLT4JpL6d7wNkK/8WORm
         vGX90J/4X1ZDlw46raX26WVysWqKJs9g38MUbysjqCSC8+T10J00U4kvgqHNHrzGS02L
         H3an9hFxFHPsw1+PbqARdnWbFyKd9Upha9Fc/BOCNr8L+S1/4frgmPV9gA3W0gMvRBJV
         vKbbd33WLTLBa4my/Br9oJIGiaTCFlI3QLvT+wYIAtAEDrP60mGgr5pNDt3c6zWiGsUr
         10ObFIdxU0S/UmAWxm/iZKYni0XRMUpIjFSgz+IQFpa+SI++tMq023vOUg37F9E7Ar/8
         ZggQ==
X-Gm-Message-State: AOJu0YxTDUsmnupCnuICYeeVKi/V7eX3wVlfFN6vD1GXeanLLjXHFVkw
	/dCHCbhECjIrjUPcbEllRUQhD+/FpAocdWfOLsAAZ6MHi3TenG8GBPw0clJCFuFMZ+pZrDwJ1nP
	1UqlisA==
X-Received: from plch11.prod.google.com ([2002:a17:902:f2cb:b0:2a7:61b8:be8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:9ce:b0:295:fc0:5a32
 with SMTP id d9443c01a7336-2a717518e27mr198109225ad.3.1769033526812; Wed, 21
 Jan 2026 14:12:06 -0800 (PST)
Date: Wed, 21 Jan 2026 14:12:05 -0800
In-Reply-To: <24665176b1e6b169441c9f6db9b5d02d073377a4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-12-rick.p.edgecombe@intel.com> <aWrdpZCCDDAffZRM@google.com>
 <24665176b1e6b169441c9f6db9b5d02d073377a4.camel@intel.com>
Message-ID: <aXFPNbCvKURxby1q@google.com>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Binbin Wu <binbin.wu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Chao Gao <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68810-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 10A865EB3B
X-Rspamd-Action: no action

On Tue, Jan 20, 2026, Rick P Edgecombe wrote:
> Sean, really appreciate you taking a look despite being overbooked.
>=20
> On Fri, 2026-01-16 at 16:53 -0800, Sean Christopherson wrote:
> > NAK.=C2=A0 I kinda sorta get why you did this?=C2=A0 But the pages KVM =
uses for page tables
> > are KVM's, not to be mixed with PAMT pages.
> >=20
> > Eww.=C2=A0 Definitely a hard "no".=C2=A0 In tdp_mmu_alloc_sp_for_split(=
), the allocation
> > comes from KVM:
> >=20
> > 	if (mirror) {
> > 		sp->external_spt =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> > 		if (!sp->external_spt) {
> > 			free_page((unsigned long)sp->spt);
> > 			kmem_cache_free(mmu_page_header_cache, sp);
> > 			return NULL;
> > 		}
> > 	}
>=20
> Ah, this is from the TDX huge pages series. There is a bit of fallout fro=
m TDX=20
> /coco's eternal nemesis: stacks of code all being co-designed at once.
>=20
> Dave has been directing us recently to focus on only the needs of the cur=
rent
> series. Now that we can test at each incremental step we don't have the s=
ame
> problems as before. But of course there is still desire for updated TDX h=
uge
> pages, etc to help with development of all the other WIP stuff.
>=20
> For this design aspect of how the topup caches work for DPAMT, he asked
> specifically for the DPAMT patches to *not* consider how TDX huge pages w=
ill use
> them.
>=20
> Now the TDX huge pages coverletter asked you to look at some aspects of t=
hat,
> and traditionally KVM side has preferred to=C2=A0look at how the code is =
all going to
> work together. The presentation of this was a bit rushed and confused, bu=
t
> looking forward, how do you want to do this?
>=20
> After the 130 patches ordeal, I'm a bit amenable to Dave's view. What do =
you
> think?

IMO, it's largely irrelevant for this discussion.  Bluntly, the code propos=
ed
here is simply bad.  S-EPT hugepage support just makes it worse.

The core issue is that the ownership of the pre-allocation cache is split a=
cross
KVM and the TDX subsystem (and within KVM, between tdx.c and the MMU), whic=
h makes
it extremely difficult to understand who is responsible for what, which in =
turn
leads to brittle code, and sets the hugepage series up to fail, e.g. by unn=
ecessarily
mixing S-EPT page allocation with PAMT maintenance.q

That aside, I generally agree with Dave.  The only caveat I'll throw in is =
that
I do think we need to _at least_ consider how things will likely play out w=
hen
all is said and done, otherwise we'll probably paint ourselves into a corne=
r.
E.g. we don't need to know exactly how S-EPT hugepage support will interact=
 with
DPAMT, but IMO we do need to be aware that KVM will need to demote pages ou=
tside
of vCPU context, and thus will need to pre-allocate pages for PAMT without =
having
a loaded/running vCPU.  That knowledge doesn't require active support in th=
e
DPAMT series, but it most definitely influences design decisions.

