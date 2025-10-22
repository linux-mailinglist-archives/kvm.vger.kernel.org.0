Return-Path: <kvm+bounces-60852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67219BFDF90
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 21:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7696B1A605C9
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4910D34FF51;
	Wed, 22 Oct 2025 19:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="udGeY5Ml"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95BE34DB41
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761160129; cv=none; b=YD8mo2Pv0bsWR/+1ViAfhURjLlxlvoZe2d4EHNc8USYpEhg3v/CAcYDR6BrREtkv+pfS+Vy8TBvsO9A+2CulTfnTgjPVNtgF1VBAMN5PLJhKfTCam5wiFhKTxmqwIY8tOwTrnS8xnnYMtXfaUCxTmWCG+VblxaRhOWjANGDPqOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761160129; c=relaxed/simple;
	bh=k7EXMNgqSkOA+7R9iYr3lcFkZvZ8bFqZ1wal4qwtUZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GKOdEjr9TEHSYWaDKqkygtOfVayHOkv2+kLeeFrgOtgK1KcB/7iEx0tcefMaVwndKWRPJICXnVBgdFOBnMXx0D7ahhpxdUbXiLrEAE0CxyWlWSf8J3W/KLm9u0D/Vqch7ogsHvCe5Jc4f2mv/1PtpsLgkPTZPDyMs0mNyxR5AV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=udGeY5Ml; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b557abaad02so11518545a12.3
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 12:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761160127; x=1761764927; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wREzy7rE27X1qKmfXOWprRl7YFBX8aFkFx3LWlFCsNc=;
        b=udGeY5MltLB2RH7DvlzkYeooe4oQPtGy2PCB0U0b3erTRmgM+erdHz2iZCMZTsaaDV
         EXdNtXOC4rPXSS3OTmJgs+qkDUW+GS8NxMGCzHZE6cj7vveLI36tMLTkQU5tNnUTYmMG
         aal731M7rhqSCucFaC5bC3WRwV819eTUPSr16aEGUDMz2H7O7DwDTG4A1ySfaujrb2jg
         ktF/pwOk+mIPCm5GEkeAmcyAMM/JgbPoJ6Wtmz8ZVQKcldgcM/5cL2th1MkCJkQ4YPRm
         3EfDSq6C8M8IrcwuoWS8EQQNkeANRCVtyb8A06pxM0Lp/38WsH/22Hl4MIVcLxGQRgkb
         cxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761160127; x=1761764927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wREzy7rE27X1qKmfXOWprRl7YFBX8aFkFx3LWlFCsNc=;
        b=tIKJ5SEvoQZXbYsoCQoHVQLvzZYwvOtQMY6v/Q4iLj339b/fGlsK2Tkf74zyopQkl0
         bZcDPgdnlpwBa9TXLpO3qO0M0XXosj/W4Q97UnjZV9Uyc6wfX2/GmnUhyFSRnCGRz+rh
         NPgXpCVLjslvW4DkWBnTaTeoeSHhdsYTtg5rp1VP3xg4cHTJriYi8uIQG+K0+fMYYfL4
         K3Q3bJfBlGNXKOZCO//gOitTv/QqUsnAmVdWYfS7GZllkDu+MwtalmtRT0y76YoAaesV
         qN7IQygGZIJEj2zfGVMyiDwE/ptjoCkzJs1i1d81zOZB/fblWIkAFvicj9Uj3gccInVq
         /B2w==
X-Forwarded-Encrypted: i=1; AJvYcCWcqPqjg3WFp0Lts6Eo5sPeDTi9Fet5K55bEQO/Ge1r0jCDCE4/kN/zHP5riiv1NnQ0iVI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI9UmfDjUtShaOh994tzNjLRW+leNGav7D6JWot9ETft4z5IeW
	sXZ4edVgGvs7XymKqCS+9gWpDKKev7pL4WEF1GetZGPnm8ynD8xNwL9U9hVYoPJGcotCpnw91Te
	3KRy45w==
X-Google-Smtp-Source: AGHT+IG7bMbvOV7PjecaO9CgeAeXZcwC+wb3hcO8vOg4iH6Jor9tS/5vQmEcVRzTkSnVuCY2g2HzBv4NWV8=
X-Received: from pjbpc16.prod.google.com ([2002:a17:90b:3b90:b0:330:9870:9f18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:218a:b0:2e5:c9ee:96fa
 with SMTP id adf61e73a8af0-334a861743bmr28027967637.34.1761160127099; Wed, 22
 Oct 2025 12:08:47 -0700 (PDT)
Date: Wed, 22 Oct 2025 12:08:45 -0700
In-Reply-To: <aPiZ2DEQ6qW5r5rY@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-11-seanjc@google.com>
 <aPiZ2DEQ6qW5r5rY@yzhao56-desk.sh.intel.com>
Message-ID: <aPkrvWcm3JF9WlVd@google.com>
Subject: Re: [PATCH v3 10/25] KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 22, 2025, Yan Zhao wrote:
> On Thu, Oct 16, 2025 at 05:32:28PM -0700, Sean Christopherson wrote:
> > Opportunistically pass the spte instead of the pfn, as the API is clearly
> > about removing an spte.
> >From my perspective, "remove_external_spte" means removing an external SPTE (not
> a mirror SPTE). So passing in pfn_for_gfn seems reasonable as well.
> 
> Additionally, passing in the pfn eliminates potential concerns about incorrect
> spte content.

No, it just makes bugs harder to debug.  E.g. it doesn't magically guarantee the
@pfn matches the pfn that was mapped into the S-EPT.

> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 48598d017d6f..7e92aebd07e8 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1855,8 +1855,8 @@ struct kvm_x86_ops {
> >  				 void *external_spt);
> >  
> >  	/* Update external page table from spte getting removed, and flush TLB. */
> > -	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > -				    kvm_pfn_t pfn_for_gfn);
> > +	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				     u64 spte);

Thinking more about what "spte" actually tracks, I think I'll rename it to
"mirror_spte".

> Also update set_external_spte?

Ooh, yeah, good call.  And we can use the mirror_spte information to assert that
KVM expects full RWX permissions, e.g. that we aren't creation a security hole by
letting the guest write memory that KVM thinks is read-only (extreme paranoia,
more for documentation purposes).

