Return-Path: <kvm+bounces-69005-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJ1DBMehc2lqxgAAu9opvQ
	(envelope-from <kvm+bounces-69005-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:28:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2C978817
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A9233024447
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA7E313E10;
	Fri, 23 Jan 2026 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sT5f2cYi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CBD265CA8
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769185721; cv=none; b=bF4m3uUQ+F7DieUtIiBgV49WcRM7KqQ2U8YKed/Vmjcd/DEpJAiDMkY32BomzYJAUgwri1kz3Xal+VCTpqcoKL5KOlU3Bs3jb++tfvYELbPjce/G2xmBUOpo1hejApVQIDNAJ/RbgZAD2NWzpd+XfKm5qq+EsKfSV8n0A1FrQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769185721; c=relaxed/simple;
	bh=ojtsfNCk0TQce85vSVCnHOTJK97VmGyljT4hKsA0Knc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RKZ9nH1TcMiuyWgIY2IlveVDokZdcoSghdRqstrY0FfC1+xe1IA9OTDgunVIWD7wnpo/FsJ7ntB5+c+Vyp+0N9uLCO0JKqrgrWu59UnPbgpItKzIwOKVqMwBeImaDhiVDHaAAuE6MzAsfz3UZlE0BDb0fG6YPEdMvngjj8IqCx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sT5f2cYi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c43f8ef9bso3102939a91.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 08:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769185720; x=1769790520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=he8XloOOWPSaOui0O7oaErIAKoE6NnMdJNO0Fc3CGTs=;
        b=sT5f2cYiHDlPz4t/TYQZO2rKcKlOWE2TekSgMSOg70/hSrxDdReCv+6sh6nkmoTFCA
         +UMsCgn+kkX4Yfo0wSyCWxzdRQkSlbbXq6r+w3coj3yqrqPSLLj4BEW9N1woaYVZDCsh
         wnqC1fLlsWQTBy7XmfEILkCV0XUFKjr87yis5EtsJjXeD95GDEN9AX7FkAJfVJfliYFg
         kHrPJuMqdDvsvN9dJWPJC3js02aPyXvGRIZwMK6Rmbet1+TLx0xUnNFlH9FGDGdx5iOA
         8ykL7QrJwv0mKpsmS0uvheCV8JFGJDlNtNYF+j36eGi6FoPF+th3qh7iSt30Gl7JgGLu
         j2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769185720; x=1769790520;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=he8XloOOWPSaOui0O7oaErIAKoE6NnMdJNO0Fc3CGTs=;
        b=eUi5Iy7oqxf1QUQ08o7yNl9qgXz9bGdh2My1e6ShuCiA1uO4byKa6rFP8InGF5mA2D
         UgiigNA87OztXT3XDxGJz2hd+d9oNK5rYEjgrm0Zbur8SWXfkJ409MzeRXZi9Y9T2hp2
         2QMNAexagiYZ9ZegC0jVeKnCr0WTIz035wTi2b/cnjyMhx3MxAQb+lAtf3YVu6df9pTp
         u8RuTDbLNoScQInGbPA7yHRdP64v0dsJFBJYTpFlm0K6bEg4/79dq2kOH5LPkomWO4v3
         GVa2gYvjXSuePqk9bfkv9Qpc3xvnNUnv3GQmTMyXPRKsQNsOpAJplXFcuH2VFXh1sWsH
         1UhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlYgyLvGkByrUkzTOr+adO2PtgPB4O30thxXeMYYx42j5GeHFodLwykrC+9bnD7Ivjg7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAwb8qBc++FnDt/qhXv8ks8zUaXKpWBOPNxBl2MMzyaQaKjJzV
	jfxncIvglnJdHmw4hNsbutn3sXUQhz1WVnBAexgFsThY1evDpzjHmKp9AvsAH2Tta3ThwiHeoWR
	i+1JfHA==
X-Received: from pjbqo8.prod.google.com ([2002:a17:90b:3dc8:b0:352:c99c:60b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384f:b0:32e:2fa7:fe6b
 with SMTP id 98e67ed59e1d1-3536acf4d36mr2783154a91.14.1769185719797; Fri, 23
 Jan 2026 08:28:39 -0800 (PST)
Date: Fri, 23 Jan 2026 08:28:38 -0800
In-Reply-To: <6752311d-f545-4148-a938-5c9690c31710@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122053551.548229-1-zhiquan_li@163.com> <aXJcpzcoHIRi3ojE@google.com>
 <6752311d-f545-4148-a938-5c9690c31710@163.com>
Message-ID: <aXOhtpyDMKwo0RLA@google.com>
Subject: Re: [PATCH] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some
 unpredictable test failures
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69005-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[plt:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7A2C978817
X-Rspamd-Action: no action

On Fri, Jan 23, 2026, Zhiquan Li wrote:
>=20
> On 1/23/26 01:21, Sean Christopherson wrote:
> > Is this needed for _all_ code, or would it suffice to only disable fort=
ification
> > when building LIBKVM_STRING_OBJ?  From the changelog description, it so=
unds like
> > we need to disable fortification in the callers to prevent a redirect, =
but just
> > in case I'm reading that wrong...
>=20
> Thanks for your review, Sean.
>=20
> Unfortunately, disabling fortification only when building LIBKVM_STRING_O=
BJ is
> insufficient, because the definitions of the fortified versions are inclu=
ded by
> each caller during the preprocessing stage.  I=E2=80=99ve done further in=
vestigation and
> found the off tracking since compilation stage with the GCC =E2=80=9C-c -=
fdump-tree-all=E2=80=9D
> options:
>=20
> I found memset() is replaced by __builtin___memset_chk in
> x86/nested_emulation_test.c.031t.einline phase by compiler and kept to th=
e end.
> At last, __builtin___memset_chk was redirected to __memset_chk@plt at GLI=
BC in
> linking stage.
>=20
> As a perfect reference substance, guest_memfd_test, which invokes memset(=
) in
> guest_code() as well.  I replayed the same steps and found memset() is re=
placed
> by __builtin___memset_chk in guest_memfd_test.c.031t.einline phase, but, =
it was
> redirect to __builtin_memset  in guest_memfd_test.c.103t.objsz1 phase aft=
er the
> compiler computing maximum dynamic object size for the destination.  Even=
tually,
> __builtin_memset was redirected to memset at lib/string_override.o in lin=
king stage.
>=20
> Whatever, the KVM selftests guest code should not reference to the fortif=
ied
> versions of string functions, let=E2=80=99s stop it at the beginning to a=
void the
> compiler dancing :-)  Indeed, disabling fortification for all code may se=
em
> overly aggressive.

Nah, that'll just turn into a game of whack-a-mole, and likely with extreme=
ly
random moles :-)

I verified the original patch fixes my problematic setup, I'll get it queue=
d up.

Thanks!

