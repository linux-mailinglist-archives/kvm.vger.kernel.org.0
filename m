Return-Path: <kvm+bounces-61032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3545C07219
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BC773AD27B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 16:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0745633345D;
	Fri, 24 Oct 2025 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sTqbTBFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62E8313E0F
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761321740; cv=none; b=C0x9NUMMjbrmqP7huotSjmf9uSwKvSKurhdydyUsvREO7gOypNUxsIfFxbP2y+wAXf+vQq7/ysCT6i9h2oOHDa8gE4F8RTgiqtWenxRWMTsoB1qPVLt58O1ZQ7CmzBTQ8MEivzx7xfqFeCM73yczKl5ytize5djBpfj49LNSsPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761321740; c=relaxed/simple;
	bh=kz8737jx33Kz8tp/SyIDVxBRNflDp84kE5dHp/ycEQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cvEUqywWPVDtqnJG+isjfOm/k00Us5WZdrXusJtAaSs2F0w7VgJlv8yCIHLw9yBiCF9y+OL3Eiz9TB4CRQSSdhWKN2B1mtf0IzgdflwP384VIrgv2x55qRnKOcJj7sX2SFSIjgB5ZIdpzaPnMVyqXd4T5pwi/mkcBmlpLqES1X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sTqbTBFN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so1773167a91.2
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 09:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761321738; x=1761926538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P1MKrGdWjc8E/Ebl4vfeAKzWc5S72Fxhrb9RaFQ7z64=;
        b=sTqbTBFN393e5C3StI8G7zgDd9NSDlDoKAQMex/cNoevNpd/ke1ajBDzagoQMnPSqs
         EjcK87xKmKiOEQ1xMV20E7AUwNvv6KT3ZWyut4qrhNhfZxHq4ACEqpFudvxFQOJeYkOE
         7lhxeHNqIsGBhzaBDLF4ESkf6GsiXvlytFS9GGIyA1uTYVheTj4Q1snEwdpMWF7q0SqT
         hsUDtBYoZZqoyDd2ByllpOu3B9aA57+TrZ9rwhzDvVWNpIwNunDouSFYxwZlBBWnEJAM
         pvM5jD0XGVAcGvcE7KZdvlkUkViZuwT1FJ0emsX6qZfKfTUSdTMg2H7+o4y7q1QjvsQI
         pzHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761321738; x=1761926538;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P1MKrGdWjc8E/Ebl4vfeAKzWc5S72Fxhrb9RaFQ7z64=;
        b=Kiy3o6+ZM/WxVXU50iYNnKs1SdN+XWKoRs2aPIjrmzJYL4RqquCaaOGmCzWAjUxmBP
         7/4WKZQUSlDyaXkgKdEW6K8ZDpLwSpEV0AEu248loAkuVSXkKab80ks5vb2FvLaILekM
         P6jk1gm7m8C6gOjAMNHm7uNINmboiWKMBa5mcrtWsGAxndXiGgKjmDhoy20PKaroqZ7F
         XalwNi8Jazhp0yl2fT4P4hQ871fz81+rMurJjPhR44IfPVtizyI2d9Nij24pTdVQ1GHd
         X5XH6MKVyG+pf7uP+HTN3D15g0t6zIOJpZ1jKiffDGIETUPGgan+xDrqFHyzt+/X1roy
         PT+g==
X-Forwarded-Encrypted: i=1; AJvYcCWrNZIuPfaREAdoIdaDEzhcPh4z2JRpn/WiRawaZ4m9A3zU9pdz+oYzdczuatfzw4Bb9PI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxByCatbHADPo5NjfzAaK072SwgjbVTz/JuSxK0FteFFbVdf7fo
	HSEWz3bEXxPT97VetABwPJc3gaG1BDjrlzlr/ssQcISVKxsxNtthy476XAo0ti/ljtaLGavYuH1
	7fE+4Sg==
X-Google-Smtp-Source: AGHT+IEPJrBEzf9AFsnuAfARW2fQ8J+uVH9VRs0BFow9LMUVTh88VT5tvwRbbVcv0vCZSy2S66pTwnqydR4=
X-Received: from pjbrt12.prod.google.com ([2002:a17:90b:508c:b0:33b:bb95:de6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c0b:b0:32e:d599:1f66
 with SMTP id 98e67ed59e1d1-33bcf8fbaa0mr32076128a91.30.1761321737475; Fri, 24
 Oct 2025 09:02:17 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:01:43 -0700
In-Reply-To: <CAAhR5DGcz-2=a6Q2zZS_eP2ZjNNPs65jNG+K50tdVAQfC6AbbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com> <20250925172851.606193-14-sagis@google.com>
 <68efcb7ee33e5_cab031002e@iweiny-mobl.notmuch> <CAAhR5DGcz-2=a6Q2zZS_eP2ZjNNPs65jNG+K50tdVAQfC6AbbA@mail.gmail.com>
Message-ID: <aPui50JMEcuIl7-8@google.com>
Subject: Re: [PATCH v11 13/21] KVM: selftests: Add helpers to init TDX memory
 and finalize VM
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>, linux-kselftest@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025, Sagi Shahar wrote:
> On Wed, Oct 15, 2025 at 11:25=E2=80=AFAM Ira Weiny <ira.weiny@intel.com> =
wrote:
> >
> > Sagi Shahar wrote:
> > > From: Ackerley Tng <ackerleytng@google.com>
> > >
> >
> > [snip]
> >
> > > diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/too=
ls/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > > index 2551b3eac8f8..53cfadeff8de 100644
> > > --- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
> > > @@ -270,3 +270,61 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t =
attributes)
> > >
> > >       free(init_vm);
> > >  }
> > > +
> >
> > [snip]
> >
> > > +
> > > +void vm_tdx_finalize(struct kvm_vm *vm)
> >
> > Why is this not a new kvm_arch_vm_finalize_vcpu() call?
>=20
> What do you mean?

Ira is pointing out that upstream now has kvm_arch_vm_finalize_vcpus(), so =
you
can (and I agree, should) implement that for x86.c, and do vm_tdx_finalize(=
) from
there (based on the VM shape) instead of requiring the caller to manually f=
inalize
the TD.

Unlike SEV, where userspace can manipulate guest state prior to LAUNCH, TDX=
 guest
state is unreachable from time zero, i.e. there is unlikely to be many (any=
?) use
cases where a selftest wants to do something between creating vCPUs and fin=
alizing
the TD.

