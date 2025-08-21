Return-Path: <kvm+bounces-55417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3ACB30937
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88ACFAC3C9D
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD412EAB6D;
	Thu, 21 Aug 2025 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9Yx9iYq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DAA2D3ED2
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 22:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815456; cv=none; b=sK5iaUOc0rbNzg2+zcDpq3sls5NPytCe/BZcLnyDuqailMVzG/ROwyUrouyXNhs4z43gqvLRlSU8idr5uzKDLDcxlxVb0bH9f34TScQ9nyDxh+yAcWJALCGSxAlU0GNGCuQloUCdIGmUlRXby2PzZwBMgkqvijXyl+XXcLzIg4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815456; c=relaxed/simple;
	bh=qrwTnPicyp9tNZ7V+qU5Qj6zOAnVLlyHrsqGuz2C1tQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irOKwkJjshwZU/vIfcRPDax8hJ72+bnMas7zY4mVWWJ/Y9BrKTQjcoLq1+hv9Gy3RS8r3dKAGDMGun6DwFgeN8dR/qg8UCU5rb5XsZKdOvHtrIw0kRWg8MuR5S/eCkWjKOgUrrRZX0NsdLOikedwMqU/vypCQoicroESQcOc06U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9Yx9iYq; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b12b123e48so115731cf.0
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 15:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755815453; x=1756420253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8MDguIpfB1tiwDQTj5aE/No4Z7doxG64RXtusp1FLM=;
        b=w9Yx9iYqWBuSxOxsfFF8k8P/YvFLmMjH9VYE1To1EKuzjCehrtfnhYR4pH/ZTQU+8i
         aS6Leayi2A8rqF2PKKNC16tQDJQWekVg0WT3myNJ44D5xb6WltMUJGK/UVlm+46sagQS
         HskVeDEvN2LcgZzg7XDJ2vv/DrdKAIvh1ZvZVf/W14lu+49O7IIE1sN0WouAJeuT1fKm
         VkrANHHl8rB9PosTYXqvfUJvQ+PtKndvcLpiHh9uxYZpSVVdv8tZQbAMQhKuxefXT3CR
         rReJInk76peqEellH39kHWgias42ULdQKpZBPU/75sjH5aADVUYoP41S2JT1nF4JljVX
         xgLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755815453; x=1756420253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8MDguIpfB1tiwDQTj5aE/No4Z7doxG64RXtusp1FLM=;
        b=WhyQJjef7FBXXr0b4tvO3SrG+OMT7Jhu/l35Jp+iv42X7jYTkAkapZ477sCeDgIgRO
         rVMTsyVr/Ed/L6T8OpvGlzouTNmCGCaCeFi0m4vD6seJMGU3hq7Ke75h0CYjmld8j4dq
         8jz6Kk+Om6ehXlHOhSBlxWFr4DFT7764GLB0Z6wjpc2a+8uw9Ogq3MbC/rbCLu5Z3SLT
         H4quZlL7sJ1N1nj9gX3R5TS4q31vBvfJ3QUKiF5h6etdOsNQuuwlQW75/Yuv7OGBj8n+
         Xyg4ghvS4vrHaEYkVMaShor68rVxPzISY5secLT3ns1aPmFeSizzrAwEM5fkaqOq0NtD
         QY6A==
X-Forwarded-Encrypted: i=1; AJvYcCWI4cA3Y6YFpvu5RQVq0wV3EahXJVJUy+9nrvyJDmlPRagtz1+D3IWRs8G/7Lx7VdOyukw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyku64L/e/Vye3jrRrQ/PxJK6IPM0rqoSzIdTSHkiWL6ryj0FA2
	JfrM1oIApfJfTZTZ1Bndo32zZHCFhH4YaK/BSqumBfG86VctBOLNDv7WqPlA6lgbcyF98xnVvxK
	UajTvXEpvhLXAiwdgVX1XcORwLLFMAAKQCqJuM9Q9
X-Gm-Gg: ASbGncvX9AVlh07NmPoeOQIPyTvB3gaVcVMwy49Pfa0Hkl4G+WqGI56YUEmYRL0x7zP
	3HcmnxW73NetAT25xzDDVWxhB3SXD3WLrCzV8CXCKb/iHVjXrf6wLk9zrFGK4insKuABcDfwcsE
	I/zifpl3k1p/fnqqEOT53q120zmS8x4d91uESKt+YuKJdfwZmYbF1zdtDPaWOk7Jd+GnUVmYJH7
	p9NSrPp+C0bSFOslZslpBsIL1MWjF6DQd4uqEXuF9DmQletxkjrDfYyfg==
X-Google-Smtp-Source: AGHT+IH2EHxRIc2XvOSnuoiOX6o9qCXNTtLKbVBQdBlpUCSlcPy+O7Gq5C+KP9ymQxWBlUK9RRR1skGgBYxWmAR+Khc=
X-Received: by 2002:a05:622a:118c:b0:4b0:82e5:946b with SMTP id
 d75a77b69052e-4b2aacd5a4emr2026071cf.4.1755815452896; Thu, 21 Aug 2025
 15:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-6-sagis@google.com>
 <68a7981019500_2be23a294ba@iweiny-mobl.notmuch>
In-Reply-To: <68a7981019500_2be23a294ba@iweiny-mobl.notmuch>
From: Sagi Shahar <sagis@google.com>
Date: Thu, 21 Aug 2025 17:30:42 -0500
X-Gm-Features: Ac12FXz2B1VmOXVRyb0Ok0u4rwStMH2RK2jNtJZ5p7yUkaK07yoWYHQtSWixBO4
Message-ID: <CAAhR5DGEUqHGvYztLZJKfY+Re-aq5ACC4++m_7+yeMsL+1E11g@mail.gmail.com>
Subject: Re: [PATCH v9 05/19] KVM: selftests: Update kvm_init_vm_address_properties()
 for TDX
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Roger Wang <runanwang@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 5:03=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Sagi Shahar wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Let kvm_init_vm_address_properties() initialize vm->arch.{s_bit, tag_ma=
sk}
> > similar to SEV.
> >
> > TDX sets the shared bit based on the guest physical address width and
> > currently supports 48 and 52 widths.
> >
> > Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Co-developed-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > ---
> >  .../selftests/kvm/include/x86/tdx/tdx_util.h       | 14 ++++++++++++++
> >  tools/testing/selftests/kvm/lib/x86/processor.c    | 12 ++++++++++--
> >  2 files changed, 24 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/x86/tdx/tdx_uti=
l.h
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/t=
ools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> > new file mode 100644
> > index 000000000000..286d5e3c24b1
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef SELFTESTS_TDX_TDX_UTIL_H
> > +#define SELFTESTS_TDX_TDX_UTIL_H
> > +
> > +#include <stdbool.h>
> > +
> > +#include "kvm_util.h"
> > +
> > +static inline bool is_tdx_vm(struct kvm_vm *vm)
> > +{
> > +     return vm->type =3D=3D KVM_X86_TDX_VM;
> > +}
>
> NIT: Might have been better to define this in 4/19 and use it there.  But
> looks like that logic is changed later on somewhere.  So...  meh.

We can skip the check for KVM_X86_TDX_VM entirely in 4/19 since like
you said, it's replaced with something different later on.

>
> Ira
>
> [snip]

