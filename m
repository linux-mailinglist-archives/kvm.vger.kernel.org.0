Return-Path: <kvm+bounces-70816-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFh3FdPPi2kbbgAAu9opvQ
	(envelope-from <kvm+bounces-70816-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:39:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C799C12058F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44E5D3069D67
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15E821B905;
	Wed, 11 Feb 2026 00:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RJJ9kxfX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E481E1FE451
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 00:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770770372; cv=none; b=c+2xjdnWTCz1fQQQVgOZgTE/fpht6mIXIl7U7rnoaBvoUf+KPFdKv24x3NWpG9h7M6XGEXPEkL+qiJeLAKobwCWkX3KvrUeFWG5GYc6arQKY6Oq28NHT6+EttwmcuA74/hrSU9TSmS/J5PdosQANQP3vKe1s5zPf/mzuZe0pumc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770770372; c=relaxed/simple;
	bh=s2U9S1u3VhkDUIygI3Zcx38PmHTM+Bthud/9UyO7iso=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aj/G2Xiu7qfvjFyNeh4QrAOH/txp924hqiYefacKrU5gXB7b1KY4/RqEgcVaIGaBjPKz/fN+xwWAsJK74FGYGu1mSMNm9ooJ3fLEK/HTs+tqPA3xtPvsDgC4RJNHLjD1iOERmIdHwu/orGK4McYl9rEHdEn1DnDVa/prCSx17h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RJJ9kxfX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8c273332cso150505965ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 16:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770770370; x=1771375170; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlPZqqOFKtlyTJtQPaMC04tH30yMSKXkqW8o2Hw3yFU=;
        b=RJJ9kxfXO9fkA5U61fR+/vx5DUlcQ7q5xty7uFUJvLoHKl+nYJCHUw7F0djAVLLoiQ
         MIFVUrrWSiU30zAPKgdoVvfjc5y9IPMPIxnPnWhTagRmIBTzPFmWFcwEmTeGs3Nis/KH
         dQ9wIy2Ul4HY/n+bAX8ujsMXcVK5SIS3iC8LZVuwClydOFqTG4sSLyS0sqvJ5UeUlf2+
         z+nrO8IJ7HiFFDQsYw5AnN/3qEkH2r7MFaz1tVblXFAL+UmWcO2akrhYXd4INTy1Fpyh
         FmXB4tDBDSCHMpKT8tuup8KbbqAV97qLURKG2sffuCvGRG9HdmPM+Mra5gilYpmOk1o2
         SuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770770370; x=1771375170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jlPZqqOFKtlyTJtQPaMC04tH30yMSKXkqW8o2Hw3yFU=;
        b=vqkotA1SqNY30CQH+vjOKv0j+XaAjbN0dJCQ8PkcqAzWCT9CSKVf2mLXsAcwrlwxlw
         WkLAhzJnImLZsxW4ZNAJ4PpuuhWC4C3c5gSZZ18bJXB6CnkLbxiFi/BXkvKH8m7C3ONc
         qsiTOFHco2/JF92poi74KJCshaKIRwzkqCtSAZM0ZD2SWGwuoahl/wOB9ewmjGtiZAXy
         lQ1mYnwiJulCLWR1meMk9ejdxe1tflt8aoYBtV0/LLZK/c/ewESZcVLy649NcVI9fwUJ
         sZalCECZ1L8IuUPlECqZ/n1DDdxHV1V+yBi+Hd38dfm2XZ4RtERuuVhmUJLZVWUlGtMZ
         pPJA==
X-Forwarded-Encrypted: i=1; AJvYcCUslKuqGmh2jZ/TKv/L6qLro0fiDda1hlS37vH0ks4Qd0KsoMJ7Lt8xtN00P4pQTRTBois=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7WcdWa9HeGgbahrVhRNidRciZgnem+HOy93FKbCrhSPw5uLgG
	Ihm8Tvs8NnMXTorgs41bLT2hV3NIIul3rC/IstourguHntUUolSErqJ60unRKTaIMCNsTHVJysQ
	NkJDiCw==
X-Received: from plgo9.prod.google.com ([2002:a17:902:d4c9:b0:2a9:5e11:35e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:238b:b0:2aa:e7f3:fb05
 with SMTP id d9443c01a7336-2ab280e2dc9mr9332135ad.59.1770770370341; Tue, 10
 Feb 2026 16:39:30 -0800 (PST)
Date: Tue, 10 Feb 2026 16:39:28 -0800
In-Reply-To: <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev> <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com> <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
 <aYvIpwjsJ50Ns4ho@google.com> <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
Message-ID: <aYvPwH8JcRItaQRI@google.com>
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after VMRUN
 of L2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-70816-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C799C12058F
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Yosry Ahmed wrote:
> > > We can drop it and make it a local vaiable in nested_svm_vmrun(), and
> > > plumb it all the way down. But it could be too big for the stack.
> > 
> > It's 48 bytes, there's no way that's too big.
> 
> That's before my hardening series shoved everything in there. It's now
> 256 bytes, which is not huge, but makes me nervous. Especially that it
> may grow more in the future.
> 
> > > Allocating it every time isn't nice either.
> > 
> > > Do you mean to also make it opaque?
> > 
> > I'd prefer to drop it.
> 
> Me too, but I am nervous about putting it on the stack.

256 bytes should be tolerable.  500+ is where things tend to get dicey.

> > > > +       u8 __vmcb12_ctrl[sizeof(struct vmcb_ctrl_area_cached)];
> > > 
> > > We have a lot of accesses to svm->nested.ctl, so we'll need a lot of
> > > clutter to cast the field in all of these places.
> > > 
> > > Maybe we add a read-only accessor that returns a pointer to a constant
> > > struct?
> > 
> > That's what I said :-D
> > 
> > 	* All reads are routed through accessors to make it all but impossible
> > 	* for KVM to clobber its snapshot of vmcb12.
> > 
> > There might be a lot of helpers, but I bet it's less than nVMX has for vmcs12.
> 
> Oh I meant instead of having a lot of helpers, have a single helper that
> returns it as a pointer to const struct vmcb_ctrl_area_cached? Then all
> current users just switch to the helper instead of directly using
> svm->nested.ctl.
> 
> We can even name it sth more intuitive like svm_cached_vmcb12_control().

That makes it to easy to do something like:


	u32 *int_ctl = svm_cached_vmcb12_control(xxx).

	*int_ctl |= xxx;

Which is what I want to defend against.

> > > I think this will be annoying when new fields are added, like
> > > insn_bytes. Perhaps at some point we move to just serializing the entire
> > > combined vmcb02/vmcb12 control area and add a flag for that.
> > 
> > If we do it now, can we avoid the flag?
> 
> I don't think so. Fields like insn_bytes are not currently serialized at
> all. The moment we need them, we'll probably need to add a flag, at
> which point serializing everything under the flag would probably be the
> sane thing to do.
> 
> That being said, I don't really know how a KVM that uses insn_bytes
> should handle restoring from an older KVM that doesn't serialize it :/
> 
> Problem for the future, I guess :)

Oh, good point.  In that case, I think it makes sense to add the flag asap, so
that _if_ it turns out that KVM needs to consume a field that isn't currently
saved/restored, we'll at least have a better story for KVM's that save/restore
everything.

