Return-Path: <kvm+bounces-71053-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGpAFTQ+j2llOAEAu9opvQ
	(envelope-from <kvm+bounces-71053-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:07:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0158B137690
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B7CC302C90F
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C522A36215B;
	Fri, 13 Feb 2026 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3mkf3Fn9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD23612D2
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770995205; cv=none; b=Llip7UcgPbzbS18K6Cr6n3Usf3Lrl3enwm4cfIYE6xeVTzzYon/bc4EGJED26Kb6NWB2oJTjhfu8IDNi9ZP0xOeBYG6mbzgQmZnkjDlkR22XYNryz3W+p27drwK32EBMz2WyySo3zFeX52qxnaVJAjDLQJ8822NunCubfq3tsiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770995205; c=relaxed/simple;
	bh=8pfSjJh0W2hd/22J4dDbqMZWMTyz+iOZ6B1Md5NWHC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NSGsNX2V0KoEv3VpCThxUmxD1UmCsxBSr1j+cnwUmpX9QYaTOBnDJTpBQOEpVuVx/2DBvka7psT7AekVP/7TBrpLvgqNUouFsDjFWlKItoNrvk4NoulBreQ+QUl4Ig97lFJlKgf0sbtHGZKe7nqBSAoRj8kuWbQdhw+hOCHtHa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3mkf3Fn9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a90510a6d1so9426655ad.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 07:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770995203; x=1771600003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FBbTNJ5LwbpwkPVPXZiu1SaHZNUbBizs1w9VZrFcsgc=;
        b=3mkf3Fn9w/HWN79jA5R0Sq1fW8x3xeV/dwnGnDU0nFHIYzuFP6zY5dAnf5jBAC8uKK
         QTSIR5MFaehf4CCYjvWJuUcEHpl7AJvAKA63EPru/dcn3xL4vi35m4KpIyX3oEVZGwuh
         6uu9Eh4O9GWD0bAYHD3rT18IJvP1uIte6beOyR3VNkAwEk3WmH0cSp+Yft7nc2XFZ+4/
         wdfRnYgw3CN39aMva/EVRwaTUW/LP/X+AYXOi6yMyqz1tEtQg8D3oV2T5dkUhKlPxgOj
         ec4275fjk7WZXuVqTh85f0I/lzdFvnBDpp4t1E+y/LeuWcsF5hbBgLtYgsAsexr2QCUd
         BB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770995203; x=1771600003;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FBbTNJ5LwbpwkPVPXZiu1SaHZNUbBizs1w9VZrFcsgc=;
        b=W8zV/svC+0sGLFSgnXonoUStGwMiE+ZovMEvcFtD60wtrCs4EesUkYHBiXOGklFa4c
         vc9ewl3VurNXKMiDjG/EXNK9AcT3LGEITXnQ8DLc4B8a4LC1BSDt/X0E/k4EnsSJUeeU
         t4PXsjPgEbrxzhTrFiHYJfoteS64Cjawe7k2Z6z1QaVjV9VJbTpJUG2btZJ2nzEx+B7u
         h6VtG7M0W2ZypIL10bwExGLVk8LUBdq5gVS+izaQPLTwkkFqzu/E/W6Jx7gV9W7RNn71
         ZqvPWnzMhsbTCWF3r4AOBY41p5u2hg0vd26xeNZwwuglcfjCj7rBb9nrhS64XfmSp+Yq
         XPpQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7TdQ/aeaADYYLDCVWsvE7T7Jg6YAJo/9A7uOWsK2+14395XsZDJHBYcj+YJ9bRglZFyg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwpEYgMCBrfK9WWzCSSSeVPhW5vBAhxlI5o/wrFS0jROpeS07y
	bmMBahdvNHREuKso5iJkN0Y3OpRnm2Y/Vf2QiCS/I2NOgbFtOHGJzqB8u95K+hvt4qsDdZ8xGu0
	s6FCftg==
X-Received: from plbje12.prod.google.com ([2002:a17:903:264c:b0:2a9:3211:e2f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32d0:b0:2aa:e1f0:5481
 with SMTP id d9443c01a7336-2acba598d5fmr3891305ad.30.1770995203219; Fri, 13
 Feb 2026 07:06:43 -0800 (PST)
Date: Fri, 13 Feb 2026 07:06:41 -0800
In-Reply-To: <CAE6NW_afk_zv=-qtz13x6qEDiBanaZGEUou1G4euQpqwJS8DxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com> <20260122045755.205203-3-chengkev@google.com>
 <aY5DHUQl3jWnk3TN@google.com> <aY5DoEINs4PhXv7_@google.com> <CAE6NW_afk_zv=-qtz13x6qEDiBanaZGEUou1G4euQpqwJS8DxQ@mail.gmail.com>
Message-ID: <aY8799P0Ui12R9IG@google.com>
Subject: Re: [PATCH V3 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and
 SVM Lock and DEV are not available
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
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
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71053-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0158B137690
X-Rspamd-Action: no action

On Thu, Feb 12, 2026, Kevin Cheng wrote:
> On Thu, Feb 12, 2026 at 4:18=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Feb 12, 2026, Sean Christopherson wrote:
> > > On Thu, Jan 22, 2026, Kevin Cheng wrote:
> > > > The AMD APM states that STGI causes a #UD if SVM is not enabled and
> > > > neither SVM Lock nor the device exclusion vector (DEV) are supporte=
d.
> > > > Support for DEV is part of the SKINIT architecture. Fix the STGI ex=
it
> > > > handler by injecting #UD when these conditions are met.
> > >
> > > This is entirely pointless.  SVML and SKINIT can never bet set in gue=
st caps.
> > > There are many things that are documented in the SDM/APM that don't h=
ave "correct"
> > > handling in KVM, because they're completely unsupported.
> > >
> > > _If_ this is causing someone enough heartburn to want to "fix", just =
add a comment
> > > in nested_svm_check_permissions() stating that KVM doesn't support SV=
ML or SKINIT.
> >
> > Case in point, patch 4 is flawed because it forces interception of STGI=
 if
> > EFER.SVME=3D0.  I.e. by trying to handle the impossible, you're introdu=
cing new
> > and novel ways for KVM to do things "wrong".
>=20
> Just to clarify, do you mean patch 4 is flawed with patch 2? Or is the
> forcing of STGI interception flawed regardless? I am assuming the
> former here

Yes, the former.  Checking only SVME here:

	if (guest_cpuid_is_intel_compatible(vcpu) || !(efer & EFER_SVME)) {
		svm_set_intercept(svm, INTERCEPT_CLGI);
		svm_set_intercept(svm, INTERCEPT_STGI);
		svm_set_intercept(svm, INTERCEPT_VMLOAD);
		svm_set_intercept(svm, INTERCEPT_VMSAVE);

is confusing, because KVM's logic for injecting the #UD would be:

	if (!(vcpu->arch.efer & EFER_SVME) &&
	    !guest_cpu_cap_has(vcpu, X86_FEATURE_SVML) &&
	    !guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT))
		<#ud>

which raises the question of why the interception code doesn't factor in SV=
ML and
SKINIT.  "wrong" was in quotes, because there's no functional bug, but it's=
 weird
and confusing because KVM is blatantly contradicting itself.

