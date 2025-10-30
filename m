Return-Path: <kvm+bounces-61616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C407C22B97
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1F314E2127
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 23:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237F233E378;
	Thu, 30 Oct 2025 23:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LNWX650V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FB033E356
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761867644; cv=none; b=TKs976ouyhAqGGSajzX/10ft+arZyn8awLSu+9NRArcmMxV/xiI5ujEWgnuSLF8wlyYDdAECrwF6M9EEPkxP8Z1VJ4plAda7IQ5FHL6fIcwGosCtGF5dB0Fc/Rjq8TsV0Osq6GEo0JmfanC35RxPB/0JVbX0neQwtKdGz8iBiyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761867644; c=relaxed/simple;
	bh=eUlRvGsTDsOghmrMBild//Vvtgn5Z9S+p8wIvknhN0Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UbDllee8eVGyjY03obT+PQY6EqSs08HNpm3p4rHjxnVNbCAuPaKD7/eHhI5MN8G+7VZiLhJ8YZ+Jidn6OIxCOBp2JmdHf3ZYyyUrqbhBbc+rH3z+p6tB6SiH7or6kxCjqE2NIGVens8/kmfwkRLevJqVoUfbYi5vhxDUaEOiKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LNWX650V; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-792722e4ebeso1604388b3a.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 16:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761867642; x=1762472442; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hANv7xEJBy7S5lh8h/UQF87h23G6mY0gbFBLav72O2Q=;
        b=LNWX650VW7tHQNQnj4IWOW6VMCQLlPemGs7QajRKIzNpaKp0vl3fEWZcdp4Ls+MH74
         tBfSq73CaaIgj+dNyGgZKtOtiacb2G5/40vQwjw+rmkhRFZ92QI4Jo5HuzuaQLp/CMGE
         B9IXAIyxgPcPCwaNoX7UMi6Sl9C8AXP/tlgaxoFJfgYrvout7QvNnliiBvx7NVq85Rcq
         R0cziLkrvm6GwOiC77h70HwpBMeLTW8loNJWZernZqoQDjXB6NmmqasFoJLz+SNAJESI
         5l1TNl5dIQ/cUzczfTfM6SQL1kX5vVo8oEH33LpBmICpVHvaWyK77vzr2A9nl8HQ7heE
         faFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761867642; x=1762472442;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hANv7xEJBy7S5lh8h/UQF87h23G6mY0gbFBLav72O2Q=;
        b=rmuzkR/QBle1y8fE1MpACUQlS+zE+lkRrR/cq8dXKFCRhpINBChnsMf9kmxYFCBZAn
         SV10419uTusdMMLtuguLHwS6jtSXXMRQkF6r9lGB+JPaKlmMNGdZ3DMftUOD1iTjzPXX
         IaS+OOYjx74S6l19nPkW6AJl7Lb7qa0mgiNCREGpzj240+6yLmbz7Os9FVvef236R/U+
         RwlfjUTpS1MVbYTs7vS55iOllcwNcW0jxXmACAcs38dns9g3nt8tU+mGzxlZFJmzeNd/
         /GfVHwfX7uWe0ecE1VaflqfmYaqNQ2RDGJR1LW7sXAH+Y4CAPMHzw5/cG4YDmkTDZRSP
         0n9w==
X-Forwarded-Encrypted: i=1; AJvYcCXeKJdv40viPuTSRwglIOpb9WBlPA9H+oJ09w43Viq1nrv5dVeHPVHOjt2SCWlYt/HWtJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3DrgqWmdGcIwZczlONsKflXQaM7HFCg2Ow7cXEy2uT+V3wtu8
	RSjuFajxvhzn7D+71b4IJ0AAxaT7dGZ2RNPO5Kregw3dQugRIXH9Pw6S2h/ODQPbVz/1pAD8isD
	i+YprdQ==
X-Google-Smtp-Source: AGHT+IH6kktSpJB8uW8dOccHej0bRJlF9t4mdGsOdXoLRdKSPbgGpCfMdKkfH5SPES5/Onbr9IfT7/Ky4i8=
X-Received: from pfbhm7.prod.google.com ([2002:a05:6a00:6707:b0:77e:40c7:d12e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3996:b0:7a4:460e:f86a
 with SMTP id d2e1a72fcca58-7a7796c8a99mr1645968b3a.25.1761867642073; Thu, 30
 Oct 2025 16:40:42 -0700 (PDT)
Date: Thu, 30 Oct 2025 16:40:40 -0700
In-Reply-To: <6572689b28a76bd95bc653b1fc1131fa57ed7669.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com> <20251030200951.3402865-13-seanjc@google.com>
 <6572689b28a76bd95bc653b1fc1131fa57ed7669.camel@intel.com>
Message-ID: <aQP3eJmLTHscDoI4@google.com>
Subject: Re: [PATCH v4 12/28] KVM: TDX: WARN if mirror SPTE doesn't have full
 RWX when creating S-EPT mapping
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kas@kernel.org" <kas@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, 
	"zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, Vishal Annapurve <vannapurve@google.com>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025, Kai Huang wrote:
> On Thu, 2025-10-30 at 13:09 -0700, Sean Christopherson wrote:
> > Pass in the mirror_spte to kvm_x86_ops.set_external_spte() to provide
> > symmetry with .remove_external_spte(), and assert in TDX that the mirro=
r
> > SPTE is shadow-present with full RWX permissions (the TDX-Module doesn'=
t
> > allow the hypervisor to control protections).
> >=20
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Reviewed-by: Kai Huang <kai.huang@intel.com>
>=20
> [...]
>=20
> >  static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > -				     enum pg_level level, kvm_pfn_t pfn)
> > +				     enum pg_level level, u64 mirror_spte)
> >  {
> >  	struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> > +	kvm_pfn_t pfn =3D spte_to_pfn(mirror_spte);
> > =20
> >  	/* TODO: handle large pages. */
> >  	if (KVM_BUG_ON(level !=3D PG_LEVEL_4K, kvm))
> >  		return -EIO;
> > =20
> > +	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
> > +		     (mirror_spte & VMX_EPT_RWX_MASK) !=3D VMX_EPT_RWX_MASK);
> > +
>=20
> Nit:=C2=A0
>=20
> I am a little bit confused about when to use WARN_ON_ONCE() and
> KVM_BUG_ON(). :-)

Very loosely: WARN if there's a decent chance carrying on might be fine,
KVM_BUG_ON() if there's a good chance carrying on will crash the host and/o=
r
corrupt the guest, e.g. if KVM suspects a hardware/TDX-Module issue.

