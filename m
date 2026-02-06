Return-Path: <kvm+bounces-70523-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGMMONN2hmn/NQQAu9opvQ
	(envelope-from <kvm+bounces-70523-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:18:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2791041EC
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B6563052AEE
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 23:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5561430EF7A;
	Fri,  6 Feb 2026 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xCaLJMZL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801D323EA93
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 23:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419883; cv=none; b=kOgVTQTjWtM062psbBiCZSOSe2sAFVneTaeeRB7QWmR/M2VsZ4fGzlCcSY0pg1u4e8h3ZqcMLrs+/XPmB4o0BOJMmHnsLA0LiSk7NESfpuiPkpT5uZ+Pu63f2YafmtONLyI4+38LzIEir6o+AGIevLzcuYs1rNuP43TADKt6TGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419883; c=relaxed/simple;
	bh=vC+UzOiNSw7Ep+RaYvzyF57/776KykC+Gx/GSex0hQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=raBmjWLUwGuqWsZmAfjVBym6jD9jo9MFOg+af8OyIwWIhuvhDTFnX0VJyNFenzab3xerjKHa013hooZCYV6xlkjzjOz5N5XPzP2qmRF4ZqbzMZpW9dGuy1EOax1bqHDb1glrVIfUO3UqCtibHniCxpMB762AOmuAt7JdKjgVtcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xCaLJMZL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81ea3358dd3so910356b3a.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 15:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770419883; x=1771024683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iVZvicGY3dplrb5J2oNrXVVT3pZgPh6D3oyNVxQfbJc=;
        b=xCaLJMZLVV0GdEPrNz6y8QCH5ySwiUi6zT3lAsAZTEsO8S43ugG16CSJZq0+Ea0Xnu
         7FfJrZAkAAfn5fpS58+fHnRuCxQ4/HaMdo5QncpnpkDepHP+N/GIn5oei0AvET0SaBX8
         rhcXTQkQm4nlGeyUGSFtVqIwKSCVXfmTOy31Se/x6ixUbvO3ERY6Fn8yZMv0PJ/F48uL
         rE+Qxlk7epFf32QHZ1lGoIU3rraREPVy0yHG8mMKvmL54h0z2W3fKxbWHraAGSwRi/NV
         DgVDUfPrC6r4LxF/vix4W2FJcGxjm8k6sJ26cqpzOwRCACQPLZzXWx7SPQWt4Gbe2vc6
         ZrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770419883; x=1771024683;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iVZvicGY3dplrb5J2oNrXVVT3pZgPh6D3oyNVxQfbJc=;
        b=Kap+wrOey48t7/3PzB1GKuSffEZKgIah3ngkhuEofgGrEvGiHAyHIt0sU+5X71YSrd
         0mOzox9ymXU0ZYbL/woe6Z1B2xVVKsHprsi/59vjyLVmhPJoNu1Y83bus14/ozuh/BYM
         QtmA8mj8qrb3hwAOjyC8tuQIs24yQXPeRCrnZK1Gh7eEvMBc9kbGWfX42oJ9yNNYLjkH
         sEYABpd8FCRu5WpCvih3SXwxuGBNso0qhlu0MhezDylAAbMwJQjiK7hJfAmH4llPfrgZ
         QhLsGIbTsqHR2PwtIlEymJVk01ZviSvgbYT5bvI5/LUnxk5cJHjL8SvWWfpTEMWS8diM
         J7AQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhW8BCeMi2gsPqcPoLsiWosHKO9zjqr0FSrYpZi+ewauifatGjJy6He4VPFbEwkH2XtH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF7z6tqaXSNeT4uboUS3ZIZG89ntWHhkStKGQamBgDPDDNUUpX
	pN9gU5roiaAC3YryvHhLJGRwP64q+TeqqkdwOajIru4ZeYzFCTnjdVzv5E6nXjfYt8x4uSt6kuW
	mF2eCgg==
X-Received: from pglr14.prod.google.com ([2002:a63:514e:0:b0:c61:3a0e:23ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7001:b0:38b:e9eb:b12b
 with SMTP id adf61e73a8af0-393ad33a87bmr4315678637.41.1770419882896; Fri, 06
 Feb 2026 15:18:02 -0800 (PST)
Date: Fri, 6 Feb 2026 15:18:01 -0800
In-Reply-To: <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-23-seanjc@google.com>
 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com> <aYYQ7Vx95ZrsqwCv@google.com> <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
Message-ID: <aYZ2qft-akOYwkOk@google.com>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, 
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70523-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B2791041EC
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Rick P Edgecombe wrote:
> On Fri, 2026-02-06 at 08:03 -0800, Sean Christopherson wrote:
> > > If this external cache is for PAMT pages allocation for guest pages o=
nly,
> > > here
> > > the min count should be 1 instead of PT64_ROOT_MAX_LEVEL?
> >=20
> > Oh!=C2=A0 Right.=C2=A0 Hmm, with that in mind, it seems like topup_exte=
rnal_cache()
> > isn't
> > quite the right interace.=C2=A0 It's not at all clear that, unlike the =
other
> > caches,
> > the DPAMT cache isn't tied to the page tables, it's tied to the physica=
l
> > memory
> > being mapped into the guest.
> >=20
> > At the very least, it seems like we should drop the @min parameter?
> >=20
> > 	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu);
> >=20
> > Though if someone has a name that better captures what the cache is use=
d for,
> > without bleeding too many details into common x86...
>=20
> From the TDX perspective we have 4 types of pages that are needed to serv=
ice
> faults:
> 1. "Control pages" (i.e. external page tables themselves)
> 2. Private guest memory pages
> 3. DPAMT backing pages for control pages
> 4. DPAMT backing pages for private pages
>=20
> (3) is totally hidden now, but we need a hook to allocate (4). But from c=
ore
> MMU's perspective we hide the existence of DPAMT backing pages. So we don=
't want
> to leak that concept.

Heh, there is no way around that.  Common KVM needs to know that the cache =
is
tied to mapping a page into the guest, otherwise the parameters don't make =
any
sense whatsoever.  All we can do is minimize the bleeding.

> The page we need is kind of like something to "prepare" the private page =
before
> installing it. It actually isn't that related to the mirror/external conc=
ept. So
> if we separate it from "external" and make it about installing private gu=
est
> memory, it fits better conceptually I think. But it could be a bit confus=
ing for
> other types of VMs who have to trace to see if anything special is happen=
ing
> inside the op for their private memory. In that case it could be:
>=20
> (*topup_private_mem_prepare_cache)(struct kvm_vcpu *vcpu)

topup + prepare is redundant and confusing.

> The core MMU doesn't know about DPAMT backing pages, but it does know abo=
ut the
> set_external_spte op that consumes this cache. So how about the slightly
> misleading:
>=20
> (*topup_set_external_spte_cache)(struct kvm_vcpu *vcpu)

I really, really, want to avoid "SPTE", because the cache isn't for the SPT=
E in
any way, it's for the memory that's _pointed_ at by the SPTE.  And the conf=
usion
is exactly what prompted this thread: I forgot that it's not every SPTE in =
the
chain that needs DPAMT backing, it's only the page that's being mapped into=
 the
guest.

How about?

  (*topup_private_mapping_cache)

Because it's not just "private memory" it's specifically the mapping.  E.g.=
 for
the hugepage split case, the primary memory is already assigned and mapped =
into
the guest, but a topup is still needed because KVM is creating a new/differ=
ent
mapping.

> It is easier for other VM types to ignore, and not that semantically wron=
g from
> what is happening on the TDX side.

