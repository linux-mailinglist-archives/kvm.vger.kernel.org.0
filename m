Return-Path: <kvm+bounces-15021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 488118A8ED1
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76C101C21346
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6677D147C78;
	Wed, 17 Apr 2024 22:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TRvFn44g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8F21E484
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713392800; cv=none; b=omj+Lj5cAlVkO9hOqFFdHWJI2oQ+lSnFTNK9cd0N2TqWh+Vm9E3qkeAm/szUWtc2m/s9tcsqdPlsE1juFptLXsIq2xKpY4nKl0SjVqyCm53TOzQUKmV/tMKGxfo44ZXgfWtadkG0bbezwxOhMHJR3D8od93zdh0+aJcLnWD0Pw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713392800; c=relaxed/simple;
	bh=XmJUdCd/Xl3LfoQUvHoCZ8uS6N6zHJE4OLXgnHRlR/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lGPYBTVn6J7fjUxd/TDbrbb4TsZKyOvKTRebY3lRUaJ+XqluRUmzX4B1F14O0RwONljR7FEyjCw6fnYvHpT7hVfMWmEUfNpVU4yvNVHhBcXAmt1rGF/Jjt4pSVdPZjytmRQyGO63aDSbbCWkIW7+Xn8F2fvHBvH4ss6BcEUIrbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TRvFn44g; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61890f3180aso3292557b3.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 15:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713392798; x=1713997598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BiFELyysG8+48TNhbAr5tpc1m8bNuNEGFuwVu5J7UpA=;
        b=TRvFn44gPZyrGFTvHYx8L25f69jm3X1FB7kd35jCseL3yKvm6xyUKAO1ROw4FbsfJV
         a7VZQSSz8M/onglawRnAroFfoFZlyN1EhEaDIm1cKksmhGPDwqtChYSGvWncxDva1awR
         Lh1GOJbQlt3w6dNNRDFZjoBeWGIUCLzUUg3bUL7X2bUM+hZIsAbGcVYOwdbJUQUnB2Mv
         HKvhrXheD7KZQ/W1uoMIPTtHexXItTD5FQMagt+J/ZQlvV9YUCgxFNKXvnSAJ2IPtuD1
         HFrBe/x3wVN2vphfftMr73Bk7drMNXxuGv75rXxNvrFSmlMf/wdj9TZ1t30B+0jQs69c
         XaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713392798; x=1713997598;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BiFELyysG8+48TNhbAr5tpc1m8bNuNEGFuwVu5J7UpA=;
        b=BrBjXDXjeTDC+17G25u9TR/cBXKGh1TM0H8DMH/r2anBOWehcyVrg54eqR1tJAyoZx
         PgUnLn5rUOnWoHQrq9DAuqii+u1CPudEJevGxMVMbXfFbHOxtnS72bcYfB8Vww7bLt0X
         hZnKK4mZg6n1IakWHWyz4Buu9gstCy6swqsjHisLs5BFckXA/JQEfEB2rpSphLonu2kL
         rCvCYK2gKBqBmHt870XmJY00hwjiAVRC6OtIt+mbYZdMQo7djdD5UEi7nSfcuhKOhM04
         92Hmcx2JHI4VUxxtkWEA4Sd1Z+O7NqoIXH/5yaO7LWcXJGNREqrfd7UIXho4dOkiOxok
         xBsg==
X-Forwarded-Encrypted: i=1; AJvYcCVrK8CnGHRk6u/9kGQjErvtu1d0LuRAEGuiRtFq6fueIsy32kJQIif7TilyITrDDFHyW4AaGCHB8BrS+DwcXQ34n9YR
X-Gm-Message-State: AOJu0YwkQBJOUA/5RpV0+HqwhPxGBXNJLglLTJ/5NHvQbAfGhhm3DDNH
	/D+9YMpwY3lFCszat3dgMwEG7zvQPX2hCK7BjiA/gQdoyxz/iLpdpX1Qd1MNOd4iDsb8tjqgRU3
	JcQ==
X-Google-Smtp-Source: AGHT+IFkllFiRQzAztePeedBStPuMuyosO8Mm41hPtz3vxUqPqhc6YjEe96EAt6RMIol8O9rlxi5RI4mwCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ccce:0:b0:61b:1346:3cd5 with SMTP id
 o197-20020a0dccce000000b0061b13463cd5mr143602ywd.9.1713392798464; Wed, 17 Apr
 2024 15:26:38 -0700 (PDT)
Date: Wed, 17 Apr 2024 15:26:36 -0700
In-Reply-To: <CABgObfaoVMzEhu6O5HPe=GXH-bCkpTwSy8Ji0a1=je6f3eSqRQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-6-pbonzini@redhat.com>
 <ZiA-DQi52hroCSZ8@google.com> <CABgObfaoVMzEhu6O5HPe=GXH-bCkpTwSy8Ji0a1=je6f3eSqRQ@mail.gmail.com>
Message-ID: <ZiBMnHoyMsoRhLAL@google.com>
Subject: Re: [PATCH 5/7] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> On Wed, Apr 17, 2024 at 11:24=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > Do we want to restrict this to the TDP MMU?  Not for any particular rea=
son,
> > mostly just to keep moving towards officially deprecating/removing TDP
> > support from the shadow MMU.
>=20
> Heh, yet another thing I briefly thought about while reviewing Isaku's
> work. In the end I decided that, with the implementation being just a
> regular prefault, there's not much to save from keeping the shadow MMU
> away from this.

Yeah.

> The real ugly part is that if the memslots are zapped the
> pre-population effect basically goes away (damn
> kvm_arch_flush_shadow_memslot).=20

Ah, the eternal thorn in my side.=20

> This is the reason why I initially thought of KVM_CHECK_EXTENSION for the=
 VM
> file descriptor, to only allow this for TDX VMs.

I'm fairly certain memslot deletion is mostly a QEMU specific problem.  All=
egedly
(I haven't verified), our userspace+firmware doesn't delete any memslots du=
ring
boot.

And it might even be solvable for QEMU, at least for some configurations.  =
E.g.
during boot, my QEMU+OVMF setup creates and deletes the SMRAM memslot (desp=
ite my
KVM build not supporting SMM), and deletes the lower RAM memslot when reloc=
ating
BIOS.  The SMRAM is definitely solvable, and the BIOS relocation stuff seem=
s like
it's solvable too.

