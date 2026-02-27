Return-Path: <kvm+bounces-72240-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNw7HAwnommL0QQAu9opvQ
	(envelope-from <kvm+bounces-72240-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:21:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A20FA1BEFCB
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 02FB030288F9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7026E39A803;
	Fri, 27 Feb 2026 23:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eVgdZVua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DE9372B51
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772234502; cv=none; b=ctah7op7S6AK9mBb67Z16yr2rvKnEsEWNxZ1Qn+ITmgNjeEzJYwLpWw0fwsVJ+URaS3gmL+YHjU7TRrLTvhnmSJiHadKVitErYuaFTeUQXzVQs0jhz6sNZQBha43U1wMEMS0ObqRQjXn4CLBZNxec/9msSkk2Ip9CJzCvaWA9rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772234502; c=relaxed/simple;
	bh=Cx6Q1kucVzkTgQKLWqSfFr7o44p92dVv2IBCJ5MhYrs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pv5GlT0k1wk+mbwgdflXfNHh4ri8uMrHn9po7KhYzaFsfl0G7KWxJp1QJeIkqNCtM4RhlB6/SS8hxRSd4gu/XOmIf8HROxseYdgWf2S6n1w7oiYqgKRBWncfNRtxBNvwJsHhexpELc/Mjq6RHn8Ii6exELjczSwIBOOFTJUdnD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eVgdZVua; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70ea2f7d1bso1590789a12.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772234501; x=1772839301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H1z7ArV93oN1LUHXvok5tbiIFDmplItlW6BXRkqEjZQ=;
        b=eVgdZVuaDyCy2apjaLqqZlxoX6K4JnNOD5UlKTLzRtP6c9bEOyf5LDUvPAugeu9vTS
         yFMRGlVQdXvUHUrfDYUM+Phd0ejxsVlWuXVCfV4NxE03YUjJx1Uxg9slI6Img0qEFCjJ
         teEljvjb12Di7hnG/MtvwUANtTg63+VviwADolPRX3GaJ/2Pwiw3apsOq9KQAGDHbKDo
         1wQFeJlRQqvhSHH7fb3CVHLbxgbW1yEP84nBjNzjcwPiM+bKHCuLIOhloc9OVSy5UMLS
         +6W7SuG2fxZV4xYbrscZBlEBSvOCXPDMStp7oJ9E3JBkvu/elSVyNk8xBzrGRquanBzE
         pMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772234501; x=1772839301;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H1z7ArV93oN1LUHXvok5tbiIFDmplItlW6BXRkqEjZQ=;
        b=pGRAL4DE1y9G65axGILujdkUVUEJx1ly15aWfriN1vJ1/FAJlOwMZBOxuBnCF+6xui
         5qAvDHQR1CTp2drsXrLFyMXQJqXjYhoFoCytGdajKAINkCU3yzpKebpqAFj6VicWIMa+
         3kDtDcSStHsYxIN16m1kQZvOlpq/Rflgs+5FYhYWEn7Gv7U9aHHl00tJBTqDfFzuR8d/
         MN/B05SCyhppjWz6P6UPOdyuy06by0XuZcsPTrI0o19slNevD4+RKIyxMKgW3NbMxIR8
         Ccm5gKwkiLyWXH5J/lgGTAB96qCgalpWlv1fQdgeRxerzP7pzEGQOqMSNf0kFQ4YlaK2
         kGxw==
X-Gm-Message-State: AOJu0YzRrNMYHD13pR14gdWXPDQXjhTjPef1w8I19denE5zRd1OAOmgo
	Vnmt5aKAi9YLzIOfalUnYCobg8hebw7Oc0bkNYc0RxGT49gcRutk+tVCw6X+l0VUv6OG1tIyCrK
	2SfWzuw==
X-Received: from pgmt22.prod.google.com ([2002:a63:2256:0:b0:c70:e4b6:a276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1f8a:b0:371:8e6d:27fa
 with SMTP id adf61e73a8af0-395c3b0f129mr4334943637.47.1772234500765; Fri, 27
 Feb 2026 15:21:40 -0800 (PST)
Date: Fri, 27 Feb 2026 15:21:39 -0800
In-Reply-To: <aYp86UFynnoBLy3m@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-3-seanjc@google.com>
 <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com>
 <CABgObfbKh1Tbzv63GfopW3KQhYtfAGgXXBgGn6EiR2kSBgH_jA@mail.gmail.com> <aYp86UFynnoBLy3m@google.com>
Message-ID: <aaInA0WGEM3fVCNs@google.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72240-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A20FA1BEFCB
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Sean Christopherson wrote:
> On Mon, Feb 09, 2026, Paolo Bonzini wrote:
> > On Mon, Feb 9, 2026 at 6:38=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> > >
> > > On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >  - Document that vcpu->mutex is take outside of kvm->slots_lock, wh=
ich is all
> > > >    kinds of unintuitive, but is unfortunately the existing behavior=
 for
> > > >    multiple architectures, and in a weird way actually makes sense.
> > >
> > > I disagree that it is "arguably wrong" how you put it in the commit
> > > message. vcpu->mutex is really a "don't worry about multiple ioctls a=
t
> > > the same time" mutex that tries to stay out of the way.  It only
> > > becomes unintuitive in special cases like
> > > tdx_acquire_vm_state_locks().
> > >
> > > By itself this would not be a reason to resend, but while at it you
> > > could mention that vcpu->mutex is taken outside kvm->slots_arch_lock?
> >=20
> > ... as well as mention kvm_alloc_apic_access_page() in the commit messa=
ge.
>=20
> Ya, will do.

Finally got around to prepping a v2, and I realized that vcpu->mutex isn't =
held
when kvm_alloc_apic_access_page() is called, and thus isn't (currently) tak=
en
outside kvm->slots_arch_lock.

avic_init_backing_page() and kvm_alloc_apic_access_page() are called with a=
 vCPU,
but only via kvm_arch_vcpu_create(), when neither vcpu->mutex nor kvm->lock=
 are
held (the vCPU is still unreachable).

Given that locking.rst doesn't bother documenting that kvm->lock is taken o=
utside
kvm->slots_arch_lock (there's a whole section on slots locking), I'm inclin=
ed to
keep the new entry as just:

  - vcpu->mutex is taken outside kvm->slots_lock

But update the changelog to not claim that the behavior is "arguablyh wrong=
". =20

