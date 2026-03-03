Return-Path: <kvm+bounces-72490-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GJIBVxGpmlyNQAAu9opvQ
	(envelope-from <kvm+bounces-72490-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 03:24:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF871E7F8C
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 03:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94594308A42D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 02:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803933750DC;
	Tue,  3 Mar 2026 02:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Urvx+Gfx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F2158535
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 02:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772504656; cv=none; b=NDdYfMJPCZjwDnrlK4+EXvjojjZDB5bcnK5FhZnlEhlsUmf+6UEJfxZuQNHk32I6G+9T0VeV0UKDOgT5dUhwH3Um9aeTDds6wiUm9ZAWIQR5Spz+jSqXwPQiBYj8g993OsRz6oWBMv6TYGTvcGh3cm9cLgNMhnE5QQK4iZtZWoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772504656; c=relaxed/simple;
	bh=uZtpxAFpi1G6SUIWdfOSzJAaL5AiGi7GdvzVrHawOYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XGBwsZUkmSxM3Dyir6OHDm5IDyOz7ZDcsD0IvmCczL1JyWoCiMGwa1z9RBtungWPhqq1lyo6xBKZtp3O8AJ+gO06vwRRQkku7uG1aTXxFu8r4XRXTARzR2b2gE4mgROm69FMwoJ/eVANmeNh5UXU8g8hgpB6sQyBAdhafEyfKKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Urvx+Gfx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so4108155a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 18:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772504655; x=1773109455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hgEoULUEc/jsh9Z2U/YxOmzx6Hq08vsikzOFMt8dIRY=;
        b=Urvx+GfxXqd7qOYMf2GsZaY+OEp1xr6uEL+tYQpmFz7gekuDQ9jojxvGzimEC8t8Oo
         PSPx5PWC4BTGDu16DvWA2YiafR6BBP5q0LsyqmoyzpkiF2W93B71mZeQZHDuYNh6pN6D
         qxciI3wP6tgZJnjnGAfYXq4ipDO0g/6xYuYwNhKj84QjAI4R0+uXA6/hdnXpOBpnSDnQ
         rkgD4DNTAWYdFuvUGU3S2vutcH+8axBLt7tvFYrLvZtsyhO2PrdgKHgK6KDucm3Pe1fO
         LYbvYfuNMvXXi4Tyfo47kU7YP8oboeVx4/pZTmIM+dIbBnDpTFBBlGzkD9rKzdf/5VtA
         0BZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772504655; x=1773109455;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hgEoULUEc/jsh9Z2U/YxOmzx6Hq08vsikzOFMt8dIRY=;
        b=IVcyI/tWMX/uC02qqT/mVaSht6/hyGqkvgTVzfaP4t1aMd3sMKQVwpce3VbtfUSP+S
         iQEEKcFdfE5Kp/0qZWKHu5y5hXtlSkr3FhYqvCbtaJP17VpZ14G6ILxwONUtKfTSqY83
         Bw71Ql7YYKmlNfOdSEQYYrFvs7pelDK6uNutWAVq+WbmKrHuYi8EZuJlKV9KNAg6jFT0
         iIJ8YWUm8XLz96YibtnsT8WSTrXPGcK+6zRKIY3yLuC6Oh3AwGA5lydci7vfSXg7gnZY
         LSeJeBqf16OEmSPR6Ph2oR2YVO9Q8gDxNgAfLFvw0VEvCls2DY0YK8ww/IRAh5XodMZr
         LLQg==
X-Forwarded-Encrypted: i=1; AJvYcCXejxKpluQvrV38LaVfgbfZvWT8ilDWwGP3Bhw++IfH7AL7i6cwOpabCFtUQumkX41VIbE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+/eDcvsE9BQBe1YKBvgR78FxXP2Uq2usElfIQcwpfw3z3aAKv
	eNG1ODqb0KWoGv+uEK0yMijQ12eGlPCGRrWcSxuWBzC4W14lyROpqb744VwZ4b3HpIC+uadE4M2
	Jk1Iz7g==
X-Received: from pgnn19.prod.google.com ([2002:a05:6a02:4f13:b0:c5e:9fe:7560])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:258d:b0:395:151c:4eda
 with SMTP id adf61e73a8af0-395c3ae7748mr13870512637.45.1772504654755; Mon, 02
 Mar 2026 18:24:14 -0800 (PST)
Date: Mon, 2 Mar 2026 18:24:13 -0800
In-Reply-To: <aZ9MDxJ1iEhIbJJ6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225012049.920665-1-seanjc@google.com> <20260225012049.920665-15-seanjc@google.com>
 <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com> <aZ9MDxJ1iEhIbJJ6@google.com>
Message-ID: <aaZGTY3CzhaCb1lc@google.com>
Subject: Re: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org" <kas@kernel.org>, 
	"x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com" <zhangjiaji1@huawei.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6DF871E7F8C
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
	TAGGED_FROM(0.00)[bounces-72490-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
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
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, Sean Christopherson wrote:
> On Wed, Feb 25, 2026, Rick P Edgecombe wrote:
> > On Tue, 2026-02-24 at 17:20 -0800, Sean Christopherson wrote:
> > > +static inline void __kvm_prepare_emulated_mmio_exit(struct kvm_vcpu =
*vcpu,
> > > +						=C2=A0=C2=A0=C2=A0 gpa_t gpa, unsigned int len,
> > > +						=C2=A0=C2=A0=C2=A0 const void *data,
> > > +						=C2=A0=C2=A0=C2=A0 bool is_write)
> > > +{
> > > +	struct kvm_run *run =3D vcpu->run;
> > > +
> > > +	run->mmio.len =3D min(8u, len);
> >=20
> > I would think to extract this to a local var so it can be used twice.
>=20
> Ya, either way works for me.  The copy+paste is a little gross, but it's =
also
> unlikely that anyone is going to modify this code (or if they did, that a=
ny goofs
> wouldn't be immediately disastrous).

Ooh, better idea.  Since TDX is the only direct user of
__kvm_prepare_emulated_mmio_exit() and it only supports lenths of 1, 2, 4, =
and 8,
kvm_prepare_emulated_mmio_exit() is the only path that actually needs to ca=
p the
length.  Then the inner helper can assert a valid length.  Doesn't change a=
nything
in practice, but I like the idea of making the caller be aware of the limit=
ation
(even if that caller is itself a helper).

static inline void __kvm_prepare_emulated_mmio_exit(struct kvm_vcpu *vcpu,
						    gpa_t gpa, unsigned int len,
						    const void *data,
						    bool is_write)
{
	struct kvm_run *run =3D vcpu->run;

	KVM_BUG_ON(len > 8, vcpu->kvm);

	run->mmio.len =3D len;
	run->mmio.is_write =3D is_write;
	run->exit_reason =3D KVM_EXIT_MMIO;
	run->mmio.phys_addr =3D gpa;
	if (is_write)
		memcpy(run->mmio.data, data, len);
}

static inline void kvm_prepare_emulated_mmio_exit(struct kvm_vcpu *vcpu,
						  struct kvm_mmio_fragment *frag)
{
	WARN_ON_ONCE(!vcpu->mmio_needed || !vcpu->mmio_nr_fragments);

	__kvm_prepare_emulated_mmio_exit(vcpu, frag->gpa, min(8u, frag->len),
					 frag->data, vcpu->mmio_is_write);
}

