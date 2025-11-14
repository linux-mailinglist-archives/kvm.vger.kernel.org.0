Return-Path: <kvm+bounces-63169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A03C5ADB7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EB7E14EA5CB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E781E991B;
	Fri, 14 Nov 2025 00:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BSqclE81"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C49621FF38
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081548; cv=none; b=gbXPoM912lnUbSolB2iT6w8h1L5G2Wm8S8hpPeyj4ckCTFEEBdKhcw2TYqqNFtKWx87Iq9sloo4XD/puB2s//WyIBhzkXqweX5qE8EtuAuuNByIXyAFHS6Nf2vVSJYtxhYp7+Y8ZhfoH9+JYqgrP08CzON/HuAccqQLVrTUX7oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081548; c=relaxed/simple;
	bh=48fvNpSUR/tSKUH5jpJzhHo460fRbXqe8GajHmRtJUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WcXQsZFNIaoiril5iM+E3ExDg3WgTjlU6ffoQ+ZbNFIXAvHXE5/2PxVBjtCy1pF8PbVuf/lsV555hKBJoAm+B2rX8IWTVTxwQ6fNGTWf1C0o+ENPlFBaIsChSymerCQwrYttznFgjsCRepcMIgvps9LTB6mmoA9SZ6pibdcOEhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BSqclE81; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956a694b47so17976315ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081547; x=1763686347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/TPA+SbvqNREHpFcNdmFscbiex0UCXC+hEdJT9/ovnQ=;
        b=BSqclE81WVT9iIXKxS6wEYe33Q++h1C2u9j8fsZqJf7X6Vza/ceGzYsitFq8YB2zdZ
         aQvvTikn9jLOukK8NHlWE8MZfLpr4MT5foFPIVjm47IYHfLs3le2uglveYecVp4nroq7
         5AZpNVUs8rRH28Z1hVCQQScXwgMJ+ce5cSm8R+HCEYYQAgKvLOEDziqu8QvwTtcB4DVk
         uKkQ4MwJVcZP2pejKkg1j0omXPLbIbmDKa7S342cLKVxNz8NvL60HZqd2Paxk6/kiiDf
         CcWr0ExEXxu4Xuum0uTMDXAMOxq0wlPYru00luv4PV12OXKCFnvtCM4CgEsy3AgAF+QN
         fZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081547; x=1763686347;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/TPA+SbvqNREHpFcNdmFscbiex0UCXC+hEdJT9/ovnQ=;
        b=M3/2se/SyacOUomO0Fctp9hdeveYMAOgZ+jLjwXLwejQO6Khjr3MIOHbSMIGFmzOGJ
         aWk6eok+KDj+twtFkr2MxMtg3bybIa/wWus7F1diPwsP1is6EL5krkgvBi+6DJXSU1kc
         QuCQbW81fyJBT6GMCgpuH0S0rVgEsr/8w0IMuXOAgHBtFQF5tiGTZqMxC1EuyovYs8LY
         vDW6amyF56pYAXac1bLUlOwB58Pvyj89U3OnDy/PuivIh0v/wUy1T2bbKVApFRkFzQP3
         HFFsVBiEdkR81EjUwJ9Ey7l9OiL0wLnicPV8dT4yUCJSagDJJV/aztuOv/KoIj7td3WG
         zomw==
X-Forwarded-Encrypted: i=1; AJvYcCWiZ6wW2/Ne7ssRkSwJjI323g1XEIHxT/Mc3hzfk3HRcgSA9YshFCapYTBWynYtIKsxCzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG5PMxFw+qk1sMS2iDQD+beSjORxv1TE6aKRMa8KkJvOJYxS9E
	jMs8akoX2NgyEZwLtfFqCAgoXeC3WVGsfT/vbuQE9qWLP8ZqreYCeKgwCoeicmg4GVtpydzVGPQ
	e/vCLng==
X-Google-Smtp-Source: AGHT+IGLVWzZcFvlcari672fVuzY1cTHp2qT0SnCsSIHeNMxH1YcSp/U/Uf2KDzI+67wEBxE6n1syvNyYxc=
X-Received: from plgz16.prod.google.com ([2002:a17:903:190:b0:296:18d:ea12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c5:b0:295:2c8e:8e44
 with SMTP id d9443c01a7336-2986a76bc1dmr11720965ad.59.1763081546590; Thu, 13
 Nov 2025 16:52:26 -0800 (PST)
Date: Thu, 13 Nov 2025 16:52:25 -0800
In-Reply-To: <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
Message-ID: <aRZ9SQ_G2lsmXtur@google.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025, David Matlack wrote:
> On Thu, May 1, 2025 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > On Thu, May 01, 2025, David Matlack wrote:
> > > This series renames types across all KVM selftests to more align with
> > > types used in the kernel:
> > >
> > >   vm_vaddr_t -> gva_t
> > >   vm_paddr_t -> gpa_t
> >
> > 10000% on these.
> >
> > >   uint64_t -> u64
> > >   uint32_t -> u32
> > >   uint16_t -> u16
> > >   uint8_t  -> u8
> > >
> > >   int64_t -> s64
> > >   int32_t -> s32
> > >   int16_t -> s16
> > >   int8_t  -> s8
> >
> > I'm definitely in favor of these renames.  I thought I was the only one=
 that
> > tripped over the uintNN_t stuff; at this point, I've probably lost hour=
s of my
> > life trying to type those things out.
>=20
> What should the next step be here? I'd be happy to spin a new version
> whenever on whatever base commit you prefer.

Sorry for the slow reply, I've had this window sitting open for something l=
ike
two weeks.

My slowness is largely because I'm not sure how to land/approach this.  I'm=
 100%
in favor of the renames, it's the timing and coordination I'm unsure of.

In hindsight, it probably would have best to squeeze it into 6.18, so at le=
ast
the most recent LTS wouldn't generate conflicts all over the place.  The ne=
xt
best option would probably be to spin a new version, bribe Paolo to apply i=
t at
the end of the next merge window, and tag the whole thing for stable@ (mayb=
e
limited to 6.18+?) to minimize downstream pain.

