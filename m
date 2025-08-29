Return-Path: <kvm+bounces-56366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17845B3C3C0
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A6741CC1B90
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B1F33436D;
	Fri, 29 Aug 2025 20:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UdYtPMGk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C84A11
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 20:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756499237; cv=none; b=H12eI9pRpYtUg1PEfaeis7Z811BUBX/DYXM8EtPBegZN+QaYyN3dbZUP+dLZBrLrJSqUO9Aad2EJ8DrctrzY5CI1gXO6dyoInVWdfDtiIw8tqT/Tpol8l1C+by6IhW/bMjPNJE0yHMvXUm7G3XJkNYegz3vEKCXxpF37+PTR1wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756499237; c=relaxed/simple;
	bh=HGrErruta9BLyAGXFyScIlRA1GZusgKiBzNwVvXwRRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZXUAmqsSQ26eUhV1Z9+Xwk7sFe6ZMoohJhgacC21EfX9ENK11jdIx/2gfDrP7SJEUZlszJGldcP7rBmtKhK46rnGg3nZVO9IpIcrARcVbkpdgKknARQadBAOuTVZj996uOyzoG6vuyLmzPe02QlmErBbVTRF3KJlUDPanMrUxbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UdYtPMGk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso2314070b3a.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 13:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756499235; x=1757104035; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OdBYPvREGDRz288uxZnpSHctaJ2tHLKHotng0Ydnk1E=;
        b=UdYtPMGk/+wDjhmuKOQcccGMCLvjXRbR+OykvwWS7Kw3InVRoXjfLxJneu5Q0NKP3n
         O9ERjYVL7O4tmjBsmXjSJwI+QOiBN5JH8H7PIlXRwJbnBVSXBa4DayP22nlBsloLbgrA
         RVMB3oJ8HcVnzQBumLkWiBDUv5ifrPIJcEXrfUtRCRuIk0vQgTo0lKB4NzoGlsM4eKz7
         6NP7m/5HYix7xpn8DxusMi8gFTo8DrrDZul2pA+Jrl2j8ZQZU7VBuK327/j4duXcv9C4
         X6O4PePJwagMZjxtGinVvY1tISyBMXdTb8HQxxiSAe3aO2sFIGTJK6/KFqGSGj260Z3t
         MtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756499235; x=1757104035;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OdBYPvREGDRz288uxZnpSHctaJ2tHLKHotng0Ydnk1E=;
        b=pooJJ1Ass6eER5E/Wuwe3y1wJO5c1u4GHqgOtINIRTpyza1H1XS4UMF9X5FO5iuwhN
         lPjMq4Y4k2inDIkW7drEw6czIYziCOzW4F75Tqu9pqKX64/CpPi+3bAn4WtA0NLlr+/U
         +BOlQgwQzYlFhI19TpD1AY0rUiTDS1tZJXVxVxBZ3hrpopqDhAYQNvmzzs0JAIimnf0X
         rZesgXs7akhk8oamSawVeSbFxD3ZbgcSTFcusXHBSvoPfomEdChxQQm2M97Z/Nx6tVUE
         f6mn+rAEqIQe5wlHgbUcPKkMDcabngJmTxACSLjOZgE2zplNMBbDWPZAYYn9JwrDTGcw
         gRlA==
X-Forwarded-Encrypted: i=1; AJvYcCWViMq+C//30KG0h3Vi770+jrdK1EH1N3xlf7za8fAZ6yokaggEDg6kpazpOtQjigKhODY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrM6ygJnh2nMgDekPVMBjzMDQtOPAKV37fMhExMBuVxYOtDeAy
	BAwvuyVNQTmHQrY7/WQNesrXTtG1YdFLdYtjWA+8vrxZhohZbB5QGCHf5wF1N8il0NbZhRvWpLZ
	f4csLrg==
X-Google-Smtp-Source: AGHT+IFlZtv3eeJTHDBu/mtV0FvR6bp7Y6pEXqOev9UpEsvaOfKTzG2+LKa/ZpjcGapBpiZaxiKlaZQ/TX4=
X-Received: from pfiu11.prod.google.com ([2002:a05:6a00:124b:b0:772:2981:e786])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:bd11:b0:771:ebf1:5e3b
 with SMTP id d2e1a72fcca58-771ebf16591mr18594746b3a.23.1756499235413; Fri, 29
 Aug 2025 13:27:15 -0700 (PDT)
Date: Fri, 29 Aug 2025 13:27:14 -0700
In-Reply-To: <0a7785b3e985ec98b7f94f149afabdb86efb08d5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-3-seanjc@google.com>
 <0a7785b3e985ec98b7f94f149afabdb86efb08d5.camel@intel.com>
Message-ID: <aLINIpCx7uBPtOUa@google.com>
Subject: Re: [RFC PATCH v2 02/18] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> On Thu, 2025-08-28 at 17:06 -0700, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4994,6 +4994,65 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_v=
cpu *vcpu,
> > =C2=A0	return min(range->size, end - range->gpa);
> > =C2=A0}
> > =C2=A0
> > +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_=
pfn_t pfn)
> > +{
> > +	struct kvm_page_fault fault =3D {
> > +		.addr =3D gfn_to_gpa(gfn),
> > +		.error_code =3D PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> > +		.prefetch =3D true,
> > +		.is_tdp =3D true,
> > +		.nx_huge_page_workaround_enabled =3D is_nx_huge_page_enabled(vcpu->k=
vm),
>=20
> These fault's don't have fault->exec so nx_huge_page_workaround_enabled
> shouldn't be a factor. Not a functional issue though. Maybe it is more ro=
bust?

Whether or not the fault itself is EXEC is irrelevant, nx_huge_page_workaro=
und_enabled
is used to ensure KVM doesn't create hugepage overtop an exiting EXEC 4KiB =
mapping.
Of course, this fault is irrelevant on that front as well.  But I don't see=
 any
reason to get cute and let .nx_huge_page_workaround_enabled be stale.

> > +
> > +		.max_level =3D PG_LEVEL_4K,
> > +		.req_level =3D PG_LEVEL_4K,
> > +		.goal_level =3D PG_LEVEL_4K,
> > +		.is_private =3D true,
> > +
> > +		.gfn =3D gfn,
> > +		.slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> > +		.pfn =3D pfn,
> > +		.map_writable =3D true,
> > +	};
> > +	struct kvm *kvm =3D vcpu->kvm;
> > +	int r;
> > +
> > +	lockdep_assert_held(&kvm->slots_lock);
> > +
> > +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> > +		return -EIO;
> > +
> > +	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
> > +		return -EPERM;
>=20
> If we care about this, why don't we care about the read only memslot flag=
?

Because private memory fundamentally can't support read-only memslots.  If =
we
wanted to be paranoid, this code could assert that the memslot can be priva=
te
but for me that reaches a pointless level of paranoia.

> TDX doesn't need this or the nx huge page part above. So this function is
> more general.

I don't see anything that makes nx_huge_page_workaround_enabled mutually ex=
clusive
with TDX though.

> What about calling it __kvm_tdp_mmu_map_private_pfn() and making it a pow=
erful
> "map this pfn at this GFN and don't ask questions" function. Otherwise, I=
'm not
> sure where to draw the line.

Eh, for me, the line is pretty clear.  This is obviously specific to privat=
e memory,
and so implies a guest_memfd source, a private pfn, and everything that com=
es
along with private gmem pfns.  Everything else should be accounted for.

