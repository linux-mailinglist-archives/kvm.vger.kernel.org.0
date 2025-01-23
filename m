Return-Path: <kvm+bounces-36341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40723A1A381
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F27237A11EE
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 11:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39B520E33A;
	Thu, 23 Jan 2025 11:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vLGh5QmU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7BC381AF
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 11:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737632855; cv=none; b=flDkr9/oVqyGb6x1Ty6nnoRsRN36exp//4W8/0cgrVweaTneTx52C+UJnc5quw7Bbn1hJnGKGtzXazR/a3ppbM97tYh3xgK3DBDIEL2yaYMcjRRWLyfTTFYCR3e4nUtznUQHpw3aWsY4jl7tdK1HFNZwiFtD3qoP+zfd4zCdHJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737632855; c=relaxed/simple;
	bh=3qbMM9Et/g9UUeXHn4xDax+QCA/WtNsET+jFuXVQ1xA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4SwUXUDnuIAJ2DDrfx6hfYdNd47z9nlQkQIfxJP6iNXVIdUwEMunXMa0sx33/n4g2cGELcB4sky4jY3C0G9IlgUclfefI/LCFglcsV/Cmhoo7816SB2g95ZrqhI0EFHKhnc1a4cpBrywmIal/688/4Kabp+OcrA3tCN7yLFM8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vLGh5QmU; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4678c9310afso177361cf.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 03:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737632852; x=1738237652; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oUVqFVxmb1EAaOFebcx8Nr0q/gpw1Rr4Fc7f6JrHKEo=;
        b=vLGh5QmUuQy/dz4lIE0VRFEfadCjlzXzkLBINlp1T5p2Gm918EXH2VqL01RtD7Q5ep
         UzpdzKfIfkSOisGsX57KceGGh3gh8SjlTmxtDSK7i5sOO0oVJijJglFsN4mN+tB0JRfN
         kATBaGSYhf2Zi6UVBkNagZVC4BSL8YmnaiLsr63b4y9xq3iOKGXBsmN7SA4dhYjWpAac
         JURSPdRHqLhUhGaG9ayixeNjCFXGz/DjsB8NUzPdbaNxBSKg7ye1rQi6HuMqyal6i6Fp
         g129Knti9gMZrjNi7vdKp+3M1o2mKrbVTcljrbRf04WXfaAIjMJ4HvMUGshRBzMCt3fc
         IMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737632852; x=1738237652;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oUVqFVxmb1EAaOFebcx8Nr0q/gpw1Rr4Fc7f6JrHKEo=;
        b=iO72LMx2BHWUa9xH4cp/ItNY5532dxncrEIAKcQUbfkDwuQo03rQ9Uog1tJ58AVxgt
         jikInHumK3xKeKCfSnJJa3oGyvoLphcO48NTIvwNPzCcoM22pQPBOFM8MhQ+cC7OLsGE
         edy2KzVBN5CIh+VmR3/DNpnOiw8Ed/7VKwxYjar7/mzXDA5VSwHe01BeIiFlB29poEUN
         l4iTBIcPaZsAM9wJJpAXL2PUZmXntc6M86/bsgyEE/kTPVVyn2M8qh6wlFiRm7pSIIL6
         Vzy9rIJ4gpuMrH5VMa+YnZOLd400nQn5QfxTFwaPegEb++unMyeE+uZtfDWrv7SexXLc
         VW9Q==
X-Gm-Message-State: AOJu0Yz4tktDdNzvvDLmngo4akC3X/X810aIQ97U4fmyg7vWSgtBuDfR
	nyjXXwxsfzBUmm0d6V0IsTaK6tDvalGTsNDf9udVPD3iYq32E7XqjmPclkRoX7hP+4uEDCR4gtB
	HJ8ufapz+/zt1Yiaj1JXXzeiwaD48TNOIKDZx
X-Gm-Gg: ASbGncvtQ4Nt3qPSnplbWsCltShVLVr4AwfCrf9yOGovbF2t9Rg9bzsJiEH+SU0nIAp
	Wd6mLnqN4gOrcjMnCcfYzXV+U0+4W7MsMrUtYfmzhj6KVaW1xo/XV71/EHpfa7MO9rynSNit4lg
	FyFjT5OthVUmoFUw==
X-Google-Smtp-Source: AGHT+IHrf2fO0f+3GeRPXsuikbZb1z5AoQaJbM5kT+yCrejX2PdJr1+/J//roRLkhL2uZ7DlYSC4SJvq5n/tuVKBP1g=
X-Received: by 2002:a05:622a:1494:b0:46c:7252:67dd with SMTP id
 d75a77b69052e-46e5c11175emr3394461cf.14.1737632852098; Thu, 23 Jan 2025
 03:47:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com> <20250122152738.1173160-4-tabba@google.com>
 <b3568243-5154-424b-9114-9c28588be588@redhat.com>
In-Reply-To: <b3568243-5154-424b-9114-9c28588be588@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jan 2025 11:46:54 +0000
X-Gm-Features: AWEUYZnHHqoWM7UI1GKFfRLElevYk4_AcCzNeEaQaSf-Dbe3feBq5a9ziJStCUg
Message-ID: <CA+EHjTyhPaVAr1SKq23YJM9PDuEgc00-8owrcyCxg0Cd7meVag@mail.gmail.com>
Subject: Re: [RFC PATCH v1 3/9] KVM: guest_memfd: Add KVM capability to check
 if guest_memfd is host mappable
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 11:42, David Hildenbrand <david@redhat.com> wrote:
>
> On 22.01.25 16:27, Fuad Tabba wrote:
> > Add the KVM capability KVM_CAP_GUEST_MEMFD_MAPPABLE, which is
> > true if mapping guest memory is supported by the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   include/uapi/linux/kvm.h | 1 +
> >   virt/kvm/kvm_main.c      | 4 ++++
> >   2 files changed, 5 insertions(+)
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 502ea63b5d2e..021f8ef9979b 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -933,6 +933,7 @@ struct kvm_enable_cap {
> >   #define KVM_CAP_PRE_FAULT_MEMORY 236
> >   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
> >   #define KVM_CAP_X86_GUEST_MODE 238
> > +#define KVM_CAP_GUEST_MEMFD_MAPPABLE 239
>
> Maybe similarly consider calling this something like
>
> KVM_CAP_GUEST_MEMFD_SHARED_MEM
>
> No strong opinion on this one, though.

Ack. That would make the naming consistent.
/fuad

> --
> Cheers,
>
> David / dhildenb
>

