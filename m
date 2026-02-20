Return-Path: <kvm+bounces-71416-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGWkJrSbmGkTKAMAu9opvQ
	(envelope-from <kvm+bounces-71416-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:36:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB26169C25
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04EB4308CE77
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B83F366060;
	Fri, 20 Feb 2026 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L1qfMPPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D63659FF
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771608980; cv=none; b=jOcDgHPMFXKVVx71TRIov1AlXsMZSHpXQqfgnIuvo1csk4Zg4uA6eJ6qULpVhIS0e/QC8+PXYW5U15r8eI7GEbpTqqPkeoo19Lkl1k5IwL3sWJ/2/+cLRcrvvqx8uzgeHBistWRFKt/xtiS9QYIdEP3v/Cex8YNoKQKI+OX2Vxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771608980; c=relaxed/simple;
	bh=hk7yXmM1aV9/FRe2EJXMXYJoy7A43ImHdOcEk/9ZdFM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VFKOIF7ZTsSOyyttB9Akig22NdJ4hLoymQfzqWVQMIRvnnE5wH1C3QWLsV33xAHUCbxOJRrtBdPMXvo2YhDs8SrfzJTZp3Nm61c4NPJZm0MSJlavse8g+WrsJJCOHYXuUi+ZEnlaKVWwLr6MVOg2eqEU72wip4LDAL2jkJOG8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L1qfMPPF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6136af8e06so1433202a12.1
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 09:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771608978; x=1772213778; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hk7yXmM1aV9/FRe2EJXMXYJoy7A43ImHdOcEk/9ZdFM=;
        b=L1qfMPPFcJoYeLbiti+bP6vb6ymgMCcdS5ZZWaWhp16pKhRDsjwQ44if9bT0KZdL2R
         zUr/x7jpRON5KBOUaWRiHtAgcwDLHyn4N0h38/CyGCJytJCWVgSkmmcNs+690FAValHO
         h0x5qIrLY6zL2gMOckvgMw/Br2iO7evJ4EEqSIs670kJngHXYvXDGUlhlHX4poG+beQb
         rox+bUtSbnSBNpEFyrDG4VPQiHfYRjdvJ6+K9naEhwckmad1673gRmJuP7TRrg7AOKrJ
         2YQM1uOSx/9XGcNBQLBVPX94B8a9SUEE/yEGZFeu8UDELAkqccPvs2+uOM82a/E+giBL
         zFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771608978; x=1772213778;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hk7yXmM1aV9/FRe2EJXMXYJoy7A43ImHdOcEk/9ZdFM=;
        b=urVdViWCppt41okEwcYS+9gnoDH1lghA/sbPnoQNg6kZuP8pW5NDvruza6N++4mTkd
         6ch1LisZXRnJYQjLao4JVi8Q0nqti0N5dg+mOnE3AkC7LBKxZjN16nlSwfVi27RFSTuP
         r2sjtmwmVDp6ETBAjVEzdkqr/jlFF8JrI5Z7v8mVLM2WY8t4hst2dt66afyMaFhFyBgY
         A1zOLJYsVE1SpG103oUd2het3oSMHvYM2fYvJyZodnQVC2xvGxuR+i+UzDCqP/QdIfPF
         FAKfI0eLdpZW5+d/ZUMBjEmCDT/L2YJ+fPyQgmqYDMXM1eOMBflXKHP70t52NC+kXnU/
         pDfg==
X-Forwarded-Encrypted: i=1; AJvYcCXzJ8ADAs756Vf16AGwIrCJQWZ9m7/J0s+q9WHc9bqDfjQsViVZCofjM8qq2FSO/HgF6UI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLDBe7m2pO6bBjl/8orBUQmWZjkAUiw8q6E59dPLOROWVafrMT
	Uo49aEi8f5+wpneiH7qkH4oJo9vQEdKe3AYMno4txQsHdwG/fHWk2HW4mSg8Uet9PCklKOTL2WU
	kO2rqNg==
X-Received: from pgbz2.prod.google.com ([2002:a63:6502:0:b0:c6e:4b29:e099])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e095:b0:366:14ac:8c6f
 with SMTP id adf61e73a8af0-39545fe80e9mr288982637.69.1771608978196; Fri, 20
 Feb 2026 09:36:18 -0800 (PST)
Date: Fri, 20 Feb 2026 09:36:16 -0800
In-Reply-To: <75fc3f45e24309abef6dae31809012440de6d4ee.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-6-seanjc@google.com>
 <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com> <aYJU8Som706YkIEO@google.com> <75fc3f45e24309abef6dae31809012440de6d4ee.camel@intel.com>
Message-ID: <aZibkNNI2Xu5oMTf@google.com>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop kvm_x86_ops.link_external_spt(),
 use .set_external_spte() for all
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71416-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
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
X-Rspamd-Queue-Id: 3EB26169C25
X-Rspamd-Action: no action

On Wed, Feb 18, 2026, Rick P Edgecombe wrote:
> On Tue, 2026-02-03 at 20:05 +0000, Sean Christopherson wrote:
> > > And mirror_spte --> new_spte?
> >=20
> > Hmm, ya, I made that change later, but it can probably be shifted here.
>=20
> Sorry for the late comment on the tiny detail, but things seemed to have =
calmed
> down enough to attempt to merge these discussions into the snarl.
>=20
> It doesn't quite fit in this patch=C2=A0because the set_external_spte() o=
p also uses
> the mirror_pte name. So then you need to either expand the scope of the p=
atch to
> change "mirror" to "new" across the callchain, or creating a small mismat=
ch
> between tdx_sept_set_private_spte() and tdx_sept_link_private_spt().
>=20
> The patch where it happens in this series needs to add the old_pte, forci=
ng
> mirror_spte to grow some new nomenclature. So on balance I think it fits =
better
> there, and we should leave it alone here. We can update it in
> tdx_sept_link_private_spt() in "KVM: x86/mmu: Plumb the old_spte into
> kvm_x86_ops.set_external_spte()".

No argument from me.

