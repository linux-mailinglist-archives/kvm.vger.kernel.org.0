Return-Path: <kvm+bounces-25216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 738BE961B20
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 02:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31D562855B1
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D791799F;
	Wed, 28 Aug 2024 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VrV4C+by"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7566411CAF
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 00:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724805758; cv=none; b=KhEOq9kgTiOxxijxLqYMTiNIc6kgeTRNLqUio1liDOBh1Jq8lD+zA9Hk4XbPLIIVXUT7VHeNYPM/pcIJN04t96+rOhMe9G3DQZXRJYJN0YSSxZteceyIGQp/rBoitm5zhpm/gF9BV9H4XmuNZS3YyFupr3a9bC53qq+eVNlkPZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724805758; c=relaxed/simple;
	bh=4VsMSVQftnlr9QdT0CiWGqtoF39SGuCHkxj/8j+EtsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f0jyhOVzi5S7hhUMvCdGhfjlktMvoucETZ1ek0efAutjmkuL/+qP42OLEaBoC4xYq/D80+yurOuIcZFsY5hk7KRyVmTRL2hITk2fOQNaXpi+xCRSoItbHVZfMi8mujN+GmXxccwbWSL0sAP0cNAuHkrKOvwa/dnIReucoGXCjsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VrV4C+by; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-429d1a9363aso12095e9.1
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 17:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724805755; x=1725410555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VsMSVQftnlr9QdT0CiWGqtoF39SGuCHkxj/8j+EtsY=;
        b=VrV4C+byQdthICdmTbEp8cwOPzJQYIlOWATm+RZZV/EHNF5ORN/VO5NFWMOSt/SWgy
         hY/HFZdoxLOGUFULmw81DGYw/zrSVqg9tzFB47DCda2x5ksAExUatZJ3LhHRTOZ9v4Jf
         rM5KzMkjJZVE0EyLjgg2wQflniYh+KO9MfEef76BtdyZOuwflfGt2dlmoN3dFigZ4aqh
         Krrd2ZgW3gS2stVrKqFGLAbPU60VO/cI+gCZRtNkYrbt79A1MWRgIRnHrszwxLv9Pgcu
         YM7x0xKzfjIXQBW9PoXRLfqefWArO01Rg9CYopaJzGh3w9XkECQXqAr40mwRAq0HA/+O
         2Shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724805755; x=1725410555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4VsMSVQftnlr9QdT0CiWGqtoF39SGuCHkxj/8j+EtsY=;
        b=CidMBL7q/JKg09IIAyXpKAeGIZduKuHFvNArH9lN4ma5opklvMppOxG4WRnVSEVK+d
         p/B/UML5IXFdD1pdrXxVjwpc2zDKYd8C1Pyg9aFJGEk4JPkjgZ0jE3OBbGWrVmvpfrSv
         7E9wPHf+xHyegr25yqYNqDOa6uBvwp8gsbVTsZwkLjCYhuS/T8+OcKV1ObYIJfIOOuV2
         GfZ3d6jpiwZTNTcUxGFeJtTMctR8c64OUL2ozgciDfIJ9LfKCr1CVvtFHAmUkACrYDTr
         FkfdsA0JuLBMwm8kBlV847kpPxEcTSWDO8q3+LxuYAyDz4UNR+DtyTWqdIGMzgCQt9qZ
         NBZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFQvSWDCZSS1A9hLQVKXy/gcZWPFxkYJR9x4um0LGPQ6cga9TYZ+e0uyctLfKBtjN1X/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFXiAXoDxYbbA+O9fsjsikoa4/sI0nnfiHTAL/XswY+Uk55h2B
	Wv/YMcYEwRpsDrLetOTo2hTOMkOXDMNj6rGVtY/CMnuwoH3ZIrlffQKCxL3x0dC2qHa3ASS6HXN
	FXb9oHIqWa8pFPq992II8X5HYAJOT8GRJn0nn
X-Google-Smtp-Source: AGHT+IGrYlmUlXw/SqtUS/tOqUNPxxyajsxVgA4XCcv29hgIwhdGlTSkUs2Nj+Omxm+e5LsJNReaXIC2KatgimDrJgA=
X-Received: by 2002:a05:600c:5010:b0:426:7018:2e2f with SMTP id
 5b1f17b1804b1-42ba50d11e6mr306605e9.5.1724805754529; Tue, 27 Aug 2024
 17:42:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n>
In-Reply-To: <Zs5Z0Y8kiAEe3tSE@x1n>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 27 Aug 2024 17:42:21 -0700
Message-ID: <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Hildenbrand <david@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 3:57=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Aug 27, 2024 at 03:36:07PM -0700, Jiaqi Yan wrote:
> > Hi Peter,
>
> Hi, Jiaqi,
>
> > I am curious if there is any work needed for unmap_mapping_range? If a
> > driver hugely remap_pfn_range()ed at 1G granularity, can the driver
> > unmap at PAGE_SIZE granularity? For example, when handling a PFN is
>
> Yes it can, but it'll invoke the split_huge_pud() which default routes to
> removal of the whole pud right now (currently only covers either DAX
> mappings or huge pfnmaps; it won't for anonymous if it comes, for example=
).
>
> In that case it'll rely on the driver providing proper fault() /
> huge_fault() to refault things back with smaller sizes later when accesse=
d
> again.

I see, so the driver needs to drive the recovery process, and code
needs to be in the driver.

But it seems to me the recovery process will be more or less the same
to different drivers? In that case does it make sense that
memory_failure do the common things for all drivers?

Instead of removing the whole pud, can driver or memory_failure do
something similar to non-struct-page-version of split_huge_page? So
driver doesn't need to re-fault good pages back?


>
> > poisoned in the 1G mapping, it would be great if the mapping can be
> > splitted to 2M mappings + 4k mappings, so only the single poisoned PFN
> > is lost. (Pretty much like the past proposal* to use HGM** to improve
> > hugetlb's memory failure handling).
>
> Note that we're only talking about MMIO mappings here, in which case the
> PFN doesn't even have a struct page, so the whole poison idea shouldn't
> apply, afaiu.

Yes, there won't be any struct page. Ankit proposed this patchset* for
handling poisoning. I wonder if someday the vfio-nvgrace-gpu-pci
driver adopts your change via new remap_pfn_range (install PMD/PUD
instead of PTE), and memory_failure_pfn still
unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT, PAGE_SIZE,
0), can it somehow just work and no re-fault needed?

* https://lore.kernel.org/lkml/20231123003513.24292-2-ankita@nvidia.com/#t



>
> Thanks,
>
> --
> Peter Xu
>

