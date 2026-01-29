Return-Path: <kvm+bounces-69596-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gIAQOo2we2mSHwIAu9opvQ
	(envelope-from <kvm+bounces-69596-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:10:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CB8B3CE9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B9D2301225B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3976B311C32;
	Thu, 29 Jan 2026 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rjq0ixXG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128C431281B
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 19:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769713788; cv=none; b=Ktn/htG2OC2q+GpQHaqcq0BDSbeCEWmugGdlrIC/n1vQ9KBgG9XRaqjF9ywP4fK/gwrKU5J9Qh9JBqW+F49oDTcsKCaM1jL0RE+NxajQXo3OO+Ytc7h2E+TVZx5idaDhLhweUw6Yx46mhs/8pn+35lGy5Yc/ZLyLYpQqlVSw51g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769713788; c=relaxed/simple;
	bh=GWnKwGp1pTa5H5pvTE4nXJQ/OO60moc7qn2x3KKqBE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cfVrLVyL1kXQB5DoM0jmrc1mKk/RS05UwDw8p3SM8ZbgDH9c88q7FukFC1kOhrxmoTqjXzk6bYDiyo8AXFNEu5W7pwDc9ZjYOIiUCw/xfGJph9oCVI7E1eGaoNpnFa3IKNA1ysZWrTHBy1NZmWe2U9JS49G8pua4/FMz5mQuxDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rjq0ixXG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0f47c0e60so29260885ad.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 11:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769713786; x=1770318586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wI6/cCp+y2hcCdfZTiCNenInU6VMtVbMj61ls3UA2Zc=;
        b=Rjq0ixXGG7ewXIHUjYw3wviCW+JgSaXWoOyXHFVN+7qiH5CxQoYR6VUVKwmZefv9EV
         5K0OZfEThR8SQSSIj9z/bndQ9GrJK1ujyizlJHCxT87ZMxkCg5OgKJ1DorkhlHi47j0d
         D+c4sq+MqKHe2GGrjME+2fpDp2cvGPFHhdfBhwlb9Kmgf45Lh+5lHkqTCe9QbSvmk63Y
         cE4ecpeBZ6UiCmyu2YbH3P/DNEwrgrQ2MonbjRQOXd/4J2NXb+w+MhBMwb7+WeRVq4US
         +STaENdunMRLbPO/TrYxyUSEi9iidykmsTbBJUq8Z3DxK8DJH/BOu4kbneJC77B4gLHh
         v/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769713786; x=1770318586;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wI6/cCp+y2hcCdfZTiCNenInU6VMtVbMj61ls3UA2Zc=;
        b=vkZ6SfXN4URQ/X9A0XunGaNPwHH4jD/JsO4sdbE1WtlVWWXw+djsvW8EE9gHWZcRz3
         YyBMK4tdHFuyNKZNmY3r/vmUbFxY19ZYaYZcCkaDGIijd6Jcpz3OAZB3oKdgGERjen+O
         iTeY2tcXu8uy/8ylNOr+2yA/pNr8iWTfImsjLA1P2VAt31XzRaL6OIDMmNliFKZnPe17
         n9+TnIa/wJoVT1bPGIWqT+aWYrxtQEPOXH7qj8vh0iWoP7S1FHBrT1NfNqDgZzYbzOE0
         uvYRHD+yLbpdpW0BSTs8sD5SxyGS1CIKIPSOcQH0MjInI85ZuY14T7vbCJfr7OoH+gS2
         0TNQ==
X-Gm-Message-State: AOJu0Yyk4WmmwVcurG9oxjpKduetYOZNT0dFIZ48q9N0hNN5GSOMVMXF
	KJyV/RVbM0pyDbNIf39ac1+kG2/eIqAy+knDeJDM2d0vQtnRmdXF0ZKL3IVANQ1pcEHf+ydBoxQ
	xz8HZ+A==
X-Received: from pldv14.prod.google.com ([2002:a17:902:ca8e:b0:2a0:a01a:4ee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11d0:b0:295:745a:8016
 with SMTP id d9443c01a7336-2a8d959c542mr1979725ad.11.1769713786398; Thu, 29
 Jan 2026 11:09:46 -0800 (PST)
Date: Thu, 29 Jan 2026 11:09:44 -0800
In-Reply-To: <9096e7a47742f4a46a7f400aac467ac78e1dfe50.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com> <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
 <67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com>
 <aXq1qPYTR8vpJfc9@google.com> <9096e7a47742f4a46a7f400aac467ac78e1dfe50.camel@intel.com>
Message-ID: <aXuweFnbPhoG4Jbk@google.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Binbin Wu <binbin.wu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Chao Gao <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-69596-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 66CB8B3CE9
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Rick P Edgecombe wrote:
> On Wed, 2026-01-28 at 17:19 -0800, Sean Christopherson wrote:
> > Honestly, the entire scheme is a mess.=C2=A0 Four days of staring at th=
is
> > and I finally undertand what the code is doing.=C2=A0 The whole "struct
> > tdx_module_array_args" union is completely unnecessary, the resulting
> > args.args crud is ugly, having a pile of duplicate accessors is
> > brittle, the code obfuscates a simple concept, and the end result
> > doesn't provide any actual protection since the kernel will happily
> > overflow the buffer after the WARN.
>=20
> The original sin for this, as was spotted by Nikilay in v3, is actually
> that it turns out that the whole variable length thing was intended to
> give the TDX module flexibility *if* it wanted to increase it in the
> future. As in it's not required today. Worse, whether it would actually
> grow in the specific way the code assumes is not covered in the spec.
> Apparently it was based on some past internal discussions. So the
> agreement on v3 was to just support the fixed two page size in the
> spec.

Heh, I was _this_ close to suggesting we add a compile-time assert on the i=
ncoming
size of the array (and effective regs array), with a constant max size supp=
orted
by the kernel.  It wouldn't eliminate the array shenanigans, but it would l=
et us
make them more or less bombproof.

> Yea it could probably use another DEFINE or two to make it less error
> prone. Vanilla DPAMT has 4 instances of rdx.

For me, it's not just a syntax problem.  It's the approach of getting a poi=
nter
to the middle of structure and then doing a memcpy() at a later point in ti=
me.
More below.

> What you have here is close to what I had done when I first took this
> series. But it ran afoul of FORTIFY_SOUCE and required some horrible
> casting to trick it. I wonder if this code will hit that issue too.

AFAICT, FORTIFY_SOURCE doesn't complain.

> Dave didn't like the solution and suggested the union actually:
> https://lore.kernel.org/kvm/355ad607-52ed-42cc-9a48-63aaa49f4c68@intel.co=
m/#t

What you proposed is fundamentally quite different than what I'm proposing.=
  I'm
not complaining about the union, I'm complaining about providing a helper t=
o grab
a pointer to the middle of a struct and then open coding memcpy() calls usi=
ng
that pointer.  I find that _extremely_ difficult to grok, because it does a=
 poor
job of capturing the intent (copy these values to this sequence of register=
s).

The decouple pointer+memcpy() approach also bleeds gory details about how P=
AMT
pages are passed in multiple args throughout all SEAMCALL APIs that have su=
ch
args.  I want the APIs to not have to care about the underlying mechanics o=
f how
PAMT pages are copied from an array to registers, e.g. so that readers of t=
he
code can focus on the semantics of the SEAMCALL and the pieces of logic tha=
t are
unique to each SEAMCALL.

In other words, I see the necessity for a union as being a symptom of the f=
lawed
approach.

> I'm aware of your tendency to dislike union based solutions. But since
> this was purely contained to tip, I went with Dave's preference.

