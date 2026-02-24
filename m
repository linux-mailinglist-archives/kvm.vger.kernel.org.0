Return-Path: <kvm+bounces-71667-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOwtJ+EJnmnkTAQAu9opvQ
	(envelope-from <kvm+bounces-71667-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:28:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB8018C5D5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 184303053E0A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51E1A33A037;
	Tue, 24 Feb 2026 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vCgjv5Ty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9633A028
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 20:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771964884; cv=none; b=shaOYHACj4HvAIDBrrIBv1xxCkTIz6xriJQdYZEOWlWNlPfxIzVNCmNfDH31TlVlT7aO9BDnyYXCEBRP25ciYp6/Tk62NCOAs2J17y7WNJU4+tMiIfXbZHHlSHkE5341y/zDtjpGktqrKvRVXGcu5J/yMgW6iPTFztlfYtdo0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771964884; c=relaxed/simple;
	bh=H8Z/wHLxfxbn474umNh3WAH4BiduAReGh1P42RVVsV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Okl81+RO4HguOuUOr5dJh+WqEzlBFS/HiJ3n1KXmQRiTUkq0oD/aqjXpTs0KUuybRnF+M07Iz7jf/RhcGGkWzY78Tv0wgVO8OyUS2zwLEpwy0MuPBBYEhyKxgYFeA05EHBYh2noUm4Tbc0I3KRtZ3XDABZInGKGOn/tpE6HqrwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vCgjv5Ty; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a784b2234dso166787625ad.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 12:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771964883; x=1772569683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GskECAkP1j4sD1Dc3We/Ha9bUAOBCBlhdIAksTGltow=;
        b=vCgjv5Ty9jvvCmQdbEdjxMDUxji6rjtV/JMBX2CX3PHXMzjIts0UXArbauAVp1B2sv
         x1Mq+R7HDdQ44R1ZLIqegftlMt4OdnQ2iuCyNQMlBoXVWLwgP9CGs02e1qEYjJY9RJ6E
         LA1AKadvZhXEy8LwKkIhgYsAZEy4tjYYwEqlouy8Y5KTIM+xNNSXsGUOxb92CVQsKtpZ
         OKqccgE+5z2PBJJaN/SlCcxTaYVLgjT/wAcqvsLCIJ5WHD2vahGczMQ60KdEXbeDSTz+
         3NRiEwsq1ErXWl3zEAxm/0HEgGtIQA77m7MWUR4WMd2/Uz6OqNoQuCjRM/sBJ4bz+uc1
         w+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771964883; x=1772569683;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GskECAkP1j4sD1Dc3We/Ha9bUAOBCBlhdIAksTGltow=;
        b=GAE21nR9jKwuvKjjdJFH0hoBJJcfxFVRgRUFQSxnOgXyOKdwkAI44cyPng4nUhKVE6
         /6eq68SZ6BqW9HTvf9AjNVSaBB3VjJsph1F9x53cNKoO4jJVV5v35F4z1CIrYM4Nn9lX
         ovglBtl5a+UAGTefcQ0XG+jJGErQRSAyz+w4rdX3pSQz8emI6pk8GhqHAhtRZ1tw2nT7
         pPZjXeRzMCZXKRgf/fWoYWEklpoUA0o/XaByptu5PFBkxU7y/vD0DFvhVipx3LbAvPAI
         vyyvlI7gd9x/ilwQGzGjy260LaPIARi/vzNougS0H/sPgZMn4dJfG7HEZsOh+DMdbmeD
         QueA==
X-Forwarded-Encrypted: i=1; AJvYcCVa4yb/W2ASeBYKpu8lvABlVTh3CRFfPtKWha07A00bnPJ8o4F1DVKrZKnVP68gQ1GlAjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA0OPd/UFt8Qjz4Z96RYde7zAOG+4EEa3EC2uVPoZhbtzVUn06
	J+lpmriKvt/61EsYLXfAm5PLCecIDQRf8pDbdyIs/uOilTup/ZDwc0qd8m9DWApToaZhT9hOvUJ
	SJA2afA==
X-Received: from pgvt10.prod.google.com ([2002:a65:64ca:0:b0:c6d:b680:d2ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4782:b0:38e:9e55:6dee
 with SMTP id adf61e73a8af0-39545f7b042mr11615641637.57.1771964882568; Tue, 24
 Feb 2026 12:28:02 -0800 (PST)
Date: Tue, 24 Feb 2026 12:28:01 -0800
In-Reply-To: <CAO9r8zPvUW0TxohX8Xw6Vi8NgNgWPHfxzsSp0kSVxU5hi7H8QA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-4-chengkev@google.com>
 <aZ3gg2VsrWGKrX4l@google.com> <CAO9r8zNrQGKM0N345+KG=W72FyV1pp2EqOLcTMUZkz6bCA3MgQ@mail.gmail.com>
 <aZ3-AqK3liE1XNGB@google.com> <CAO9r8zPvUW0TxohX8Xw6Vi8NgNgWPHfxzsSp0kSVxU5hi7H8QA@mail.gmail.com>
Message-ID: <aZ4J0flo0SwjAWgW@google.com>
Subject: Re: [PATCH V2 3/4] KVM: VMX: Don't consult original exit
 qualification for nested EPT violation injection
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71667-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0BB8018C5D5
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> On Tue, Feb 24, 2026 at 11:37=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> > > > > @@ -496,7 +510,7 @@ static int FNAME(walk_addr_generic)(struct gu=
est_walker *walker,
> > > > >        * [2:0] - Derive from the access bits. The exit_qualificat=
ion might be
> > > > >        *         out of date if it is serving an EPT misconfigura=
tion.
> > > > >        * [5:3] - Calculated by the page walk of the guest EPT pag=
e tables
> > > > > -      * [7:8] - Derived from [7:8] of real exit_qualification
> > > > > +      * [7:8] - Set at the kvm_translate_gpa() call sites above
> > > > >        *
> > > > >        * The other bits are set to 0.
> > > > >        */
> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.=
c
> > > > > index 248635da67661..6a167b1d51595 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -444,9 +444,6 @@ static void nested_ept_inject_page_fault(stru=
ct kvm_vcpu *vcpu,
> > > > >                       exit_qualification =3D 0;
> > > > >               } else {
> > > > >                       exit_qualification =3D fault->exit_qualific=
ation;
> > > > > -                     exit_qualification |=3D vmx_get_exit_qual(v=
cpu) &
> > > > > -                                           (EPT_VIOLATION_GVA_IS=
_VALID |
> > > > > -                                            EPT_VIOLATION_GVA_TR=
ANSLATED);
> > > >
> > > > Hmm, this isn't quite correct.  If KVM injects an EPT Violation (or=
 a #NPF) when
> > > > handling an EPT Violation (or #NPF) from L2, then KVM _should_ foll=
ow hardware.
> > > >
> > > > Aha!  I think the easiest way to deal with that is to flag nested p=
age faults
> > > > that were the result of walking L1's TDP when handling an L2 TDP pa=
ge fault, and
> > > > then let vendor code extract the fault information out of hardaware=
.
> > >
> > > Is it not possible that KVM gets an EPT Violation (or a #NPF) on an L=
2
> > > memory access while the CPU is walking L2's page tables, then KVM
> > > walks L1's TDP and finds mappings for the L2 page tables but not the
> > > final translation? Or will KVM always just fixup the immediate EPT
> > > Violation (or #NPF) by inserting a shadow mapping of L2's page tables
> > > and retry the instruction immediately?
> >
> > The latter, assuming by "shadow mapping of L2's page tables" out meant =
"installing
> > a shadow mapping of the faulting L2 GPA according to L1's TDP page tabl=
es".
> >
> > I.e. when servicing an L2 TDP fault, KVM is only resolving the fault fo=
r the reported
> > L2 GPA, _not_ the originating L2 GVA (if there is one).
>=20
> I see. Does this need special handling when forwarding #NPFs to L1 as
> well? Or will fault->error_code have the HW fault bits in
> nested_svm_inject_npf_exit() in this case?

Yes, sorry for not making that it explicit.  nested_svm_inject_npf_exit() w=
ould
also need to consult hardware_nested_page_fault.

