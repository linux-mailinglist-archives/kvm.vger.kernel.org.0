Return-Path: <kvm+bounces-71668-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABT2DmUNnmkfTQQAu9opvQ
	(envelope-from <kvm+bounces-71668-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:43:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8966918C789
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A288E3052BAA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5407333B6C2;
	Tue, 24 Feb 2026 20:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TE+Tekd7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787D133AD92
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 20:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771965780; cv=none; b=YLeX+YTVCDu8lpwSjmlwqEC/XDR+56H/NfhGF+Uu1tCPfaXWhvXREuxe44MLrzqZ5629aluGl2OC6P5+MIFvrD8nPLLtqINRf8ppvCioBV2g/p59/3rP8nrs2Wvnmf0aEhuerAWnHINOHInBmDP62sFkvb5dzbDi5yJHE8FbGp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771965780; c=relaxed/simple;
	bh=FFSIws9UZGCXCXlSxRzmXwLBnorm0MrWfAEBYQi/VmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ojlzb7sI5UaOSRsmY3h6sb0qAH30T1aYgnfE4wyJWYUlTWi4ZLG2rpV8k/0S1IRdGpSV1ReObTIfDxPdaDoGLH2Lo3IYdrIoIk9CjAQJ31xkMzcnZyXvhMSEDbP0DigQ6IV54BdJCDuDISlvFz5wxnkUEZTid7hJ0Q8w0lq3PJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TE+Tekd7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso5236474a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 12:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771965779; x=1772570579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQvkurqnzRl0s4Cu5TERD53tESfJg6za9bkF8vg/CkM=;
        b=TE+Tekd7Wz7ojRzrcmmlV5AsSft7za7NWXFnkZj7xOJzugQ9Z1C0P5c9RZfeSRtPC5
         7dsZls594EkfmT6lYh2GT2uXwvWq0fRpFdLPudSeImbWVeTjSRsUM/m7felW4efxNZoU
         ZWpERE+O0HUsVF8bH2GibyFRAwKYOISoqWAkEMaVdKChk2akbuBPLOWtE9Q4bNhr247X
         9opT/Bv+rEDxy5ZwFUghPJCwNz6nzq4hscnN4fWFYPIK41acDf2jgYCyaq0qztnLRybN
         ZRitTEKJfb+MRwzMnEEkRz8i/WQgTlRLRn1lyt5n9/2/92oxNUsBd4AaF0I2tVGppXAI
         2VSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771965779; x=1772570579;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HQvkurqnzRl0s4Cu5TERD53tESfJg6za9bkF8vg/CkM=;
        b=Gv/wdO4dLonUKjopoWJb/9uV55avRp8SffdbgQInDjy2k99jqDoqUSS3Gm7/ZDzMQ5
         r2m9T/jrhSIh3RzjnNGNmZXC1oQNaivVM7qV9sywaWr7IRo/6HzlZpH0OaLjDwTNkLZR
         2dG7p23xKxP58JRfmSvCQg6xisVZN9obirYRLyUrkLwjU/UpcN084mymmtMeBylGmb+g
         eDQs9suC1th8MBY6/1K7eaN61XEl0ALzQnlSlgyMQ+vtQSclzq9w6c4k7tNLv0voOJ74
         bEwz32a5mUzXp22IVx0cs97IxO93qKMCdV1kIYdo/tZ/oy1XQUV4RGNpkMu1HPtuPRkY
         AYSw==
X-Forwarded-Encrypted: i=1; AJvYcCX+yaUEQG8efkcixlmDhzZaDzVSW8B8dsgOQb5MROg+RyZx/sWMPTZkqWsbfBt3vgSAnjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdZf/FoeDYKlC2318RtXvmg56rK6hz7P7cFwEYGhUCsQoJHYmk
	laopRfyAN0Pi1jhKpbI0AL839B/g6B34nxWohMJKeIoz462QsTQ8XMOblVu734ny0QkNwFGhT5y
	8kRtJcg==
X-Received: from pgeh26.prod.google.com ([2002:a05:6a02:53da:b0:c6e:1954:345])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c89:b0:364:be7:6fe9
 with SMTP id adf61e73a8af0-3959f2f33b9mr96391637.32.1771965778642; Tue, 24
 Feb 2026 12:42:58 -0800 (PST)
Date: Tue, 24 Feb 2026 12:42:57 -0800
In-Reply-To: <d6820308325d5f8fee7918996ef98ab3f7b6ce6d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223214336.722463-1-changyuanl@google.com>
 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
 <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com> <aZ3LxD5XMepnU8jh@google.com>
 <d6820308325d5f8fee7918996ef98ab3f7b6ce6d.camel@intel.com>
Message-ID: <aZ4NUZdbH6PPUr5K@google.com>
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"changyuanl@google.com" <changyuanl@google.com>, Binbin Wu <binbin.wu@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
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
	TAGGED_FROM(0.00)[bounces-71668-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
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
X-Rspamd-Queue-Id: 8966918C789
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Rick P Edgecombe wrote:
> On Tue, 2026-02-24 at 08:03 -0800, Sean Christopherson wrote:
> > > But adding the consistency check here would cause compatibility issue=
.
> > > Generally, if a new CPUID indexed function is added for some new CPU =
and
> > > the TDX module reports it, KVM versions without the CPUID function in
> > > the list will trigger the warning.
> >=20
> > IMO, that's a good thing and working as intended.=C2=A0 WARNs aren't in=
herently
> > evil. While the goal is to be WARN-free, in this case triggering the WA=
RN if
> > the TDX Module is updated (or new silicon arrives) is desirable, becaus=
e it
> > alerts us to that new behavior, so that we can go update KVM.
> >=20
> > But we should "fix" 0x23 and 0x24 before landing this patch.
>=20
> Would we backport those changes then? I would usually think that if the T=
DX
> module updates in such a way that triggers a warning in the kernel then i=
t's a
> TDX module bug.

To stable@?  No, I don't think see any reason to do that.

> I'm still not clear on the impact of this one, but assuming it's not too
> serious, could we discuss the WIP CPUID bit TDX arch stuff in PUCK before=
 doing
> the change?

Sure, I don't see a rush on the patch.

> We were initially focusing on the problem of CPUID bits that affect host =
state,
> but then recently were discussing how many other categories of potential
> problems we should worry about at this point. So it would be good to unde=
rstand
> the impact here.
>=20
> If this warn is a trend towards doubling back on the initial decision to =
expose
> the CPUID interface to userspace,

Maybe I'm missing something, but I think you're reading into the WARN waaaa=
y too
much.  I suggested it purely as a paranoid guard against the TDX Module doi=
ng
something bizarre and/or the kernel fat-fingering a CPUID function.  I.e. t=
here's
no ulterior motive here, unless maybe Changyuan is planning world dominatio=
n or
something. :-D

> which I think is still doable and worth considering as an alternative, th=
en
> this also affects how we would want the TDX module changes to work.

