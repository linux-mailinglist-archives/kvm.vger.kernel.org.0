Return-Path: <kvm+bounces-65253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB8CCA2035
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 01:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B24F300A877
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 00:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128E3A95E;
	Thu,  4 Dec 2025 00:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VxKlo3bA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD1C1C01
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 00:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764806719; cv=none; b=rtdxeM29Jq6n4ECktiemSh+AG6bBG1iNReTjXhPZkrS3lWdvH4cQsnURkeSe3++iGJGVueGhmtckyjv2SSpJ5DoySdnA3k7kll/pdm0udMX5WwP2vySfHvUMsEUh/SFryUbkTd4XbWJBsM8K6BHmzgnwQ5lagjETjLNIwXparno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764806719; c=relaxed/simple;
	bh=x5mBtF42C9vuyDFwHE+YA3ZE08rnQOGA8Etyfdi9gMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=My2ZTQra5mO+XJJX3Je1nJPKjYs8Y4NeOwr7bCLGjGIVC7u6uO5b4xAgRwqbKqg9lNqT99TgV/yZm3Sonk7Kv654SdVJ2Nv4SUTqXS+cpOSrJbY45bU47q/CzBCXvdEaP/fYAg3npb8H6UBI1wvYvamrJNM/yZyCI2z3ooBIYhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VxKlo3bA; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5942a631c2dso492626e87.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 16:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764806716; x=1765411516; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zd9WoFQTvNfYXS0FutJkOHLRDDNZG45Z8fkn2eFEtfA=;
        b=VxKlo3bAnMBMTcaMzjjibtBVyNDq49O5+aRyDG8IPwQK5pOKYmtfHwCGTopdHj4Qr3
         clVhLWIB5S8x0eEOIU1y/lld8DVG3UlhtIelIPYrRlvZHJgl5pdyAHVc8U1/b6SYCM8I
         tDnuHZ/uEAk7/y2kYTrs/+9N2E2zQwHgw2Zj0fzpL+e/zBqNfh4KmN5kIYigml2WO0b5
         MYEX58NC5OXdYECAuaveJIdxjmD/8v8Lt1VfRSYJ9Q9syvret/oFaDGywQQ55wsMQ5VT
         dDWnKPobqsOpPy5vZ8o+pCe+dCuKgttJ5poqPG2sLg3f2Mz01YnYA/hiJsz/0BNbYr2x
         e+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764806716; x=1765411516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zd9WoFQTvNfYXS0FutJkOHLRDDNZG45Z8fkn2eFEtfA=;
        b=qBNlCXR7i06rkph7f0T7pX2n1gIonH5qqL96oztDEPC4FpRY9Ei5Za6tki58uHCP8O
         VKXkQTi99WslT7njMS/JSTSvL0GXDP/HL6lz4SvLL7pENsY2A2AiNMdhSDoC1VSb9wT5
         FSpQg7NSBvKzUkiokgKqVK21e7OtMEDkXqwaK/thrtzkT4r+g/r7QZ/mY8kGcXcuiOli
         CWbJPMcOnpdmgMRSv3L4IZKhUUUdqeAFp3G8PbRNL3+B4rfsRLS+F2KqSey/LtS1p+sb
         Vtk5NNw4ZYiYpX0//RZa/962vEH6AUITMw4CEIsJHuz/NMCf1Tmm/Xnnax8l9gQsHDvi
         ik9g==
X-Forwarded-Encrypted: i=1; AJvYcCV5KDL/PB/AP+FV5rCB3Nw6/V1OXm1UUZWf+D85EULFhePP139Kc/5iFtHaJCnDXG9ZDCk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEWqgoSb4i5XfDxBvC2Cd2qEZGvyuwDImcZ6I9o154fg5HT41B
	NTxKtZyS9hovgQBIkkVM3xQdqore7N2GUNeVfFxlS8J7rAFWrcnY+OM9PtiNQ9neJxS/2VBVRVX
	V/4b79V9WpbXs2DmUDOsHKUIRMRQV0zHrx611ESAs
X-Gm-Gg: ASbGncuv/aLLvlfN9T5LZrWL/UU6k483bu7S9+qymtSVQMAvnIVGuRUGHoVevMi5QYM
	rlqzxNlt4a2IQCV0SDcJ3dSp/XIUkF1e0ZZg+KJ4mJFIDq9kp+8W5Xu30pLUpIbidRS9mIvlOVv
	NeW124UScYytHlxxAW+mnlMYVTtFD9JvT7CuWsoYsQFgwKQwZAd1peKVOqeBNMwKOgbBJIIh5jz
	uL7X/ZGsA39TYmwRD3W9GLXSSiYYv4vWvf/5fFbpAKRp97OaEabQpwMlB+Yh+MtHf8lSOpX
X-Google-Smtp-Source: AGHT+IF4CyNFKv3NT4Ky0XeOn1TQzX5YXD6kxpQuevTbiLqvfi0Z1H0r6mqBjI/VHgPS5RUsjZgaT368W08YU9UmgDU=
X-Received: by 2002:a05:6512:12c4:b0:578:ed03:7b5f with SMTP id
 2adb3069b0e04-597d3f7b821mr1673675e87.26.1764806715139; Wed, 03 Dec 2025
 16:05:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com> <aRZ9SQ_G2lsmXtur@google.com>
In-Reply-To: <aRZ9SQ_G2lsmXtur@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 3 Dec 2025 16:04:47 -0800
X-Gm-Features: AWmQ_blvUOA-vJuP7PArgXkGtxVwcyZaljS6okCvAjRlV-VnKxXpsCQN-Lg9GyA
Message-ID: <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Oct 17, 2025, David Matlack wrote:
> > On Thu, May 1, 2025 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > On Thu, May 01, 2025, David Matlack wrote:
> > > > This series renames types across all KVM selftests to more align wi=
th
> > > > types used in the kernel:
> > > >
> > > >   vm_vaddr_t -> gva_t
> > > >   vm_paddr_t -> gpa_t
> > >
> > > 10000% on these.
> > >
> > > >   uint64_t -> u64
> > > >   uint32_t -> u32
> > > >   uint16_t -> u16
> > > >   uint8_t  -> u8
> > > >
> > > >   int64_t -> s64
> > > >   int32_t -> s32
> > > >   int16_t -> s16
> > > >   int8_t  -> s8
> > >
> > > I'm definitely in favor of these renames.  I thought I was the only o=
ne that
> > > tripped over the uintNN_t stuff; at this point, I've probably lost ho=
urs of my
> > > life trying to type those things out.
> >
> > What should the next step be here? I'd be happy to spin a new version
> > whenever on whatever base commit you prefer.
>
> Sorry for the slow reply, I've had this window sitting open for something=
 like
> two weeks.

No worries, thanks for taking a look :)

>
> My slowness is largely because I'm not sure how to land/approach this.  I=
'm 100%
> in favor of the renames, it's the timing and coordination I'm unsure of.
>
> In hindsight, it probably would have best to squeeze it into 6.18, so at =
least
> the most recent LTS wouldn't generate conflicts all over the place.  The =
next
> best option would probably be to spin a new version, bribe Paolo to apply=
 it at
> the end of the next merge window, and tag the whole thing for stable@ (ma=
ybe
> limited to 6.18+?) to minimize downstream pain.

With LPC coming up I won't have cycles to post a new version before
the 6.19 merge window closes.

I'm tempted to say let's just wait for the next LTS release and merge
it in then. This is low priorit, so I'm fine with waiting.

