Return-Path: <kvm+bounces-37394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8457AA29A05
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 20:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1043716308D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57DC20011A;
	Wed,  5 Feb 2025 19:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OMDZDYkF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A918D1FCFCB
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 19:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738783260; cv=none; b=ukAnHCFsIaxISIAEPYFhkOn3Ceb/ba5N1zE5KJBChL8F5sddBQ8DnsZ34SEDnROLOWDHMdVQ0Nt3ys+ZnzCkWsdGV/wzRIyv8iEJWsZvoo34eraNo551DMgM0dWwv9/9srlTHoBHJbWGavKlk672QtktfS42+AsLLmto2Kn7om0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738783260; c=relaxed/simple;
	bh=kDvlBu0p/FkDzNXaJi4kWYSqDbnMIAW2uaVUSHv9r8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CuG64MpPOuZYXPsTZD4J8fd89MYKCCIvBIHEduxm26gCxMWnzZj4Y15Q+0hxoZycPS7TdBVl30xdUaYgn6+gMQ0RtQZBGMVuh8y8dFCccBcWnxPPDDshsVqC96JuPsj8yJHK+y2yGBrlU5RM0Q+YkjE5CwaPZNCU0ImiJueFAuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OMDZDYkF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f02d17cd0so2692335ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 11:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738783258; x=1739388058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDvlBu0p/FkDzNXaJi4kWYSqDbnMIAW2uaVUSHv9r8E=;
        b=OMDZDYkFB6VsCFac8Ftgi58GxJE2TOpYrjuk5rDo/92VJdkiVOyz/US1BAwabTNZ0u
         kzCokzq8qsdlTN9E1lZihEE63EPSDJE0cmxLrHOo+tuDq6W8OSk+VnF0h9sUvapWS0jF
         IszVGdgWVP8NQggTTUYTJt33rIMxovyPBIvS/nz7cSWrmOmT87up4txXeQ+vKHv0Iuqj
         TKzusMvajRMWbmkqWP4AGhK6k8/YebmqwmTu5k11eZcrbjtzLrYLl2xRKal8vsbqBh3O
         AG0iOvb1x1A2C/n4ivtvh+y+zGWcgkbGQBnve392aW+8O4e276pH2TesQ9cbYq0rvq+S
         8zsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738783258; x=1739388058;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kDvlBu0p/FkDzNXaJi4kWYSqDbnMIAW2uaVUSHv9r8E=;
        b=JpqXAwEpgALsL7Fg0Zlq6PsCP+HDyJ+BbEuX7/RtIRASOSsjmVX6Rb5I0E+8tK2ToC
         kzQnciMqqsE7ipjtd6s5CbUQwWHGyEzpAJeDWTEjnQ7Hw4C2FsUTac4xC9to412AV9K1
         iiOmCW1Kl7tKfLP4KHJUo/P1GOips/HFXizbtic6U1OQi7mIucJQuDlm4u2SmNtgrtmb
         p/qwDD+kPV1FaBKyca8cI0USNeWVm/e3w92t9C70ueioR1F6/G45JzBDQRZy9RyogNpu
         zcMfo8I4tV60k/4OaCgjZv557z5o/jxf6po3gUYpicodh7jsS9OPbtlNHpv0ioPgp4cf
         BOIg==
X-Forwarded-Encrypted: i=1; AJvYcCVAzhXD+reVxolJyNkXIvrnsdgXggT7uE9kwqTX39szKGCu+HXU7jM1awxKUEH7XGNXevo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1S/UfZZmg6EOzcNHAAO8nZ4GoA/D7cHjaZNx7AVa+yj0UJlHL
	vdiCHwJan4hyslWvuSi6CgaFBYM7ic8wki24yz1innMB4Oc4YOwBzO4Oz2M1wO9HmcgyqGfDXZS
	1qQ==
X-Google-Smtp-Source: AGHT+IEAZ1wHSf7gtcHrdNx0NL50ZM8eSMsLUmpiBdmNjt9W5JcsIUMXm3ZgmSPou3U0ieAfghSkK4Qgeg0=
X-Received: from pjbsm8.prod.google.com ([2002:a17:90b:2e48:b0:2ea:6aa8:c4ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e886:b0:216:7d22:f69
 with SMTP id d9443c01a7336-21f17f06218mr50689615ad.50.1738783257944; Wed, 05
 Feb 2025 11:20:57 -0800 (PST)
Date: Wed, 5 Feb 2025 11:20:50 -0800
In-Reply-To: <85f8aaea4cb5918cef92309c8c1c26fc7fd113b8.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com> <20250201011400.669483-2-seanjc@google.com>
 <43f702b383fb99d435f2cdb8ef35cc1449fe6c23.camel@infradead.org>
 <Z6N-kn1-p6nIWHeP@google.com> <cd3fb8dd79d7766f383748ec472de3943021eb39.camel@infradead.org>
 <Z6OI5VMDlgLbqytM@google.com> <48FAD370-09F1-47AA-8892-8BE29DC8A949@infradead.org>
 <85f8aaea4cb5918cef92309c8c1c26fc7fd113b8.camel@infradead.org>
Message-ID: <Z6O6Evrdl9pPM3hX@google.com>
Subject: Re: [PATCH 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2025, David Woodhouse wrote:
> On Wed, 2025-02-05 at 16:18 +0000, David Woodhouse wrote:
> >=20
> > > Oh!=C2=A0 It doesn't help KVM avoid breaking userspace, but a way for=
 QEMU to avoid a
> > > future collision would be to have QEMU start at 0x40000200 when Hyper=
-V is enabled,
> > > but then use KVM_GET_MSR_INDEX_LIST to detect a collision with KVM Hy=
per-V, e.g.
> > > increment the index until an available index is found (with sanity ch=
ecks and whatnot).
> >=20
> > Makes sense. I think that's a third separate patch, yes?
>=20
> To be clear, I think I mean a third patch which further restricts
> kvm_xen_hvm_config() to disallow indices for which
> kvm_is_advertised_msr() returns true?
>=20
> We could roll that into your original patch instead, if you prefer.

Nah, I like the idea of separate patch.

> Q: Should kvm_is_advertised_msr() include the Xen hypercall MSR, if one
> is already configured? Life is easier if we answer 'no'...

No :-)

The idea with kvm_is_advertised_msr() is to ignore accesses to MSRs that do=
n't
exist according the to vCPU model, but that KVM advertised to userspace (vi=
a
KVM_GET_MSR_INDEX_LIST) and so may be saved/restored by a naive/unoptimized
userspace.

For the Xen MSR, KVM never advertises the MSR, and IIUC, KVM will never tre=
at
the MSR as non-existent because defining the MSR brings it into existence.=
=20

