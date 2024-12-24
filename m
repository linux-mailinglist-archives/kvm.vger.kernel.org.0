Return-Path: <kvm+bounces-34358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F749FBF5E
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 277111628EE
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 14:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA19F1D63F3;
	Tue, 24 Dec 2024 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rg8d9qTJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A68F7D
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735052293; cv=none; b=RKm9PmZILrFKlYQe48enV9D9tn1o5/8HGggGl+zg0Cxga7caW0eOXNLLD4tRT90LR93NekziCHWH469D92Srq26f8b5lSBWVZfaE2ZVj1k859ylhIhEshcERDFJZiwtSZ7ObdiMVSTKsFHwjYFwWy2xruenfAhYXH0g67yl9aLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735052293; c=relaxed/simple;
	bh=7NPrKV071iuvVUkWQTg8Ny3WXt/ckPWLuWjKAjsyf4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cwypZyW+f96aRVDs50b/K3N3fZ1+HEMwH7beuzwQY6G9gv42EYxaBdu6/uAA9fEFTJl0tNEW8gIMOs7JmGtmq7A3kbIyWRU8HjQzP75UB22eNW8psL7IRZMpggxd6zz+cqOY3UwDPwsyoqtcRn2oZaXjL6s2TRaEAk3sRYZD9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rg8d9qTJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735052291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9GmcE1Wl9cQayhqWKQMSrlNtAJr4CX3be6oP/dUzd18=;
	b=Rg8d9qTJLI+bkDc+6SW9o20qqm0QBjpYlbWsegaZnF5audJ8bGQmJkdmV/sN6W+sUgi9NV
	xFKU6n30ylsWHycji14d6YKkmrxkoVSx1sIi2vqWCVnh4u2G/i9wQRoQFRE+b23lmJQAOe
	9Kl3j8yepp7DWxfYD8weeg3XRclgSBs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-Z2OUz2pDNVqcksThOWTjOA-1; Tue, 24 Dec 2024 09:58:09 -0500
X-MC-Unique: Z2OUz2pDNVqcksThOWTjOA-1
X-Mimecast-MFC-AGG-ID: Z2OUz2pDNVqcksThOWTjOA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385e03f54d0so2345264f8f.3
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 06:58:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735052288; x=1735657088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9GmcE1Wl9cQayhqWKQMSrlNtAJr4CX3be6oP/dUzd18=;
        b=uUZIrD0SYk78/s6td+CshEoF4kPAJFD3CIc+vSY4n+lkt5DqsmwVyKynI6DSOHSpjt
         DJ+C5WkhC9KXbIKC3JUtaCpB7GpWJ4LwV7+i1MV+x4cyZFGircc2POMMlrUR4yHw6Pgp
         DT6Bmih3lIh1OqX80KF7ylHzgnWopbtbYKmHqiUzJklJJKZGItri9dmc1S+Lmz85VEyk
         zrUDWDefIghdToTFZPrPi/HBQs6Fmx2WeaJHgXd0kdRc2/551VFXwuvqGjj+eNR3AK/x
         3EushkKJuTg/Ey2sKw0a/vDpdQLJOOw7UFYjda7gk9qpor+5YHireg35krrct2WTiAOb
         0DHQ==
X-Gm-Message-State: AOJu0YzXXHlYJ3WkEbWhXHE80mVmsSY6BjssC3g/UPCxo4VzzynBV2Fr
	p64TPx9g3dBRe4vQKrn4qWo9e3+t34+nXWdFxX3qqOH8mUSa3YrbuCHlSpatBlnkWiRf5chc/rG
	+rBv4ittJPrMm75rjdC4iYw5XbDIzsiPXR7/+3XQwJi6bYFs8gKO3G13+fWYY2wVUq9OyHU570P
	QfbGHyF1fK+2484QLIWhPFyXNJ
X-Gm-Gg: ASbGncs10RcptHSmA2CUjR9iMYJh5vnWY0odNgfM7W1Nv7ex0LH8DWL5Hpwb1lV73Ps
	JUNEV2scOb6qVqvLs3p2Gv8HpUqwNte+lKdd9sw==
X-Received: by 2002:adf:b302:0:b0:38a:3732:444e with SMTP id ffacd0b85a97d-38a37324592mr2575947f8f.55.1735052288450;
        Tue, 24 Dec 2024 06:58:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESEnRIQNjq5s0z8w6E34YLz29zpKi9uBZVavwykYy2B//pJwHk+Hi20MTlj+qEyhbkS4Ue8ZTGnIROBVLiX6o=
X-Received: by 2002:adf:b302:0:b0:38a:3732:444e with SMTP id
 ffacd0b85a97d-38a37324592mr2575933f8f.55.1735052288080; Tue, 24 Dec 2024
 06:58:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 24 Dec 2024 15:57:56 +0100
Message-ID: <CABgObfZJKav=Lv10s1y__tpJC4wGkWhGYud4rxyZeDEgsFWZGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] SEAMCALL Wrappers
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, dave.hansen@intel.com, 
	isaku.yamahata@gmail.com, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com, 
	x86@kernel.org, adrian.hunter@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2024 at 9:20=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> Separate from discussions with Dave on the SEAMCALLs, there was some some
> suggestions on how we might remove or combine specific SEAMCALLs. I didn=
=E2=80=99t
> try this here, because this RFC is more about exploring in general how we
> want to distribute things between KVM and arch/x86 for these SEAMCALL
> wrappers.
>
> So in summary the RFC only has:
>  - Use structs to hold tdXYZ fields for TD and vCPUs
>  - Make helper to hold CLFLUSH_BEFORE_ALLOC comments
>  - Use semantic names for out args
>  - (Add Kai's sign-off that should have been in the last version)
>
> Patches 1 and 3 contain new commit log verbiage justifying specific desig=
n
> choices behind the struct definitions.
>
> I didn=E2=80=99t create enums for the out args. Just using proper names f=
or the
> args seemed like a good balance between code clarity and not
> over-engineering. But please correct if this was the wrong judgment.

Sounds good. I'll also convert

x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT pages
x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial contents
x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest

(which I've "extracted" from the TDX-KVM series and placed all at the
top of kvm-coco-queue).

Paolo

> Here is a branch for seeing the callers. I didn=E2=80=99t squash the call=
er
> changes into the patches yet either, the caller changes are all just in t=
he
> HEAD commit. I also only converted the =E2=80=9CVM/vCPU creation=E2=80=9D=
 SEAMCALLs to the
> approach described above:
> https://github.com/intel/tdx/tree/seamcall-rfc
>
> [0] https://lore.kernel.org/kvm/20241030190039.77971-1-rick.p.edgecombe@i=
ntel.com/
>
>
> Rick Edgecombe (6):
>   x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
>   x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
>   x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
>   x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
>   x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
>   x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
>
>  arch/x86/include/asm/tdx.h  |  29 +++++
>  arch/x86/virt/vmx/tdx/tdx.c | 224 ++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h |  38 ++++--
>  3 files changed, 284 insertions(+), 7 deletions(-)
>
> --
> 2.47.0
>


