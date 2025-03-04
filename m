Return-Path: <kvm+bounces-40011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B71BA4D950
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98950188AD46
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B781FCFF5;
	Tue,  4 Mar 2025 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMYYAxB+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E5F1FCFCC
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741082017; cv=none; b=RN5soktRBIJuSA6LCmGP/0TmiXvpKJW0k9Kxq2WJUs6rnyHjCmv05KDVK2Cibi/TpX5tNQycJf62iBPveDebtSCeqkr6qrSD/ThJ6VsdfgG9u8FHAYvXg+Rksy3r3OZ9smzPLd0lHFCCNfBkc+ICuns6JGT/EdnQxoOMQu10BjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741082017; c=relaxed/simple;
	bh=H4417PY6+2X7uG+neL+rwMYSXBqY7SIhpfcmb+UdeDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i4TvIjb1SNMF/VDzzsm4sBJ0uWO6mhAC7rRYflxYZPDAVMxSboj1aJstct6e8ne30vtEj4CGHsH7PY3jbI1TSbj+w2YgePGnW+FspfyLKTDNZHIJpu7gH4Fy7yoDwwqCqrF0VVJNxtHzjFDirFoul3f0+XYh0pqr531df+N9Ews=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMYYAxB+; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-474fdb3212aso174551cf.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 01:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741082014; x=1741686814; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=66sMzp/Cm4wZveEwx3ZfvlhE5/yWt7J0oMl6pbCu+s0=;
        b=vMYYAxB+ev9YYofyaTp9Kp1PMRVHW7K3vITl8d2XNN8F1AHDjpQ/uLpp40rpWCG//e
         /xssh/XiBbAMFPY2P2WxHmjeSOvsnZK+Hy2V43cJNp9VpFuEOAAV+Y7JJPJk6AbhFJgu
         VCGNP1WHql/qQx/5Kz2YVRn8JJ432OjpWX3FTBeo911ZYpFBBWVx1sDfL9KKATAiX51b
         2SmGcWUlUu4JAmsWrD3p+KYIicRn3fthPTEdHlLf/IAlzT2ghaygPqGvUDIpomphGBM4
         2EmDsjlnk7jcEsmuXxFH8EYnSXDHCOUh2b5tn8tpW0XILlUjFEvKNOybK9uYO9iVU2Xh
         V3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741082014; x=1741686814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66sMzp/Cm4wZveEwx3ZfvlhE5/yWt7J0oMl6pbCu+s0=;
        b=wPHjPFiBokg9kFoJgl0EWGQvi66od3UwY5nJOsswGJwZ+CxDpg01qAOuzfeQ5tn4TJ
         5zyjfpL0zc2fRrfCdfkZjP86IlLtGF6HwYn3uNopzauAzk16HPNtEulJe6M21UjvgYKg
         DTjvrLzMIqU48sJ42xvqHa0ZvbgAM0SAYVuM0Y+Y9qgOMeiBNXFbJ85GSNIfKMySeHVO
         looGntVp0S0gN4Zubim2NgZwNcPLZiNitN2hVBI9h93Zb5jzLW0VBB7iLnq4eI81nf90
         WY6WyFjiVNfSg3lo3zE0FDYBz79jAWfP0Tqmw3dq/MVbLYcvbPRlgO9u1GS3qdyDoKoi
         FhMw==
X-Gm-Message-State: AOJu0YxuQH89civTeBkduwrpIAL224kr+ZKTHzYQq4+LNcyG6txA3Vkx
	e8xafMckmfvyt/aCbtTWFnfBKDwzCuD5bhNBwnTkkww5oxZmn7oex5C4eGoIsGjjcwdVjDn9T8o
	n6EHTflss2cTRUO4l7OfCV5RsDG17H+czVXN5s3/eSf3SZmHbDrbh
X-Gm-Gg: ASbGncs2ExlNQvziyk6o80dytIs85nGjUXW8V+t+fH+Dbn7Ap7T6Niuu0P1OcrIGJLS
	mFQ9NkoSzvm+cNDSx5ECLx6X1VfIUhlqqUoloGMKgQ1qTFc8tAudAO8rU9U15BDjxrLoh62cqv4
	/tif5ofziGGUa44MatsTqi22EVSaKBjU/NbMy0jKI8/Y4dZo6B8rv39OM=
X-Google-Smtp-Source: AGHT+IGrXtdDmc7ougcgME9U9gWNQgnQWpiQy4ewD8JMak/fONOpZTSjqwjFN9mKks0LK3XoAW5XrwjgePJs1o7khAY=
X-Received: by 2002:a05:622a:654:b0:474:cd63:940d with SMTP id
 d75a77b69052e-474fc3ab73bmr3994181cf.0.1741082014352; Tue, 04 Mar 2025
 01:53:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com> <20250303171013.3548775-4-tabba@google.com>
 <dedrbmbqyvmsjywilcjvu4lt5a3vess3l4p6ygum62gfpmnyce@cgtpjwf4krfw>
 <CA+EHjTygT1eqQgg59NzUK3uonikKrgi8qDhojPVnONH3qS33mQ@mail.gmail.com> <nfil6ngejfz2ehruzbguin35hnbsidr5rxywruhmpbarpiyvlp@7yepe2euriff>
In-Reply-To: <nfil6ngejfz2ehruzbguin35hnbsidr5rxywruhmpbarpiyvlp@7yepe2euriff>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Mar 2025 09:52:56 +0000
X-Gm-Features: AQ5f1JoUAKEFllGljP-l76jRlZktNiKaaggLcPOt5R0-Wkx4-Odbdi8pyyWFZtc
Message-ID: <CA+EHjTyriA8VGs_yJdd5HF8FKyNyZswwd28sWt1hZaw4KF1z4Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, suzuki.poulose@arm.com, 
	steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, 
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Mar 2025 at 09:46, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> On Tue, Mar 04, 2025 at 09:27:06AM +0000, Fuad Tabba wrote:
> > Hi Kirill,
> >
> > On Tue, 4 Mar 2025 at 08:58, Kirill A. Shutemov
> > <kirill.shutemov@linux.intel.com> wrote:
> > >
> > > On Mon, Mar 03, 2025 at 05:10:07PM +0000, Fuad Tabba wrote:
> > > > Add support for mmap() and fault() for guest_memfd backed memory
> > > > in the host for VMs that support in-place conversion between
> > > > shared and private. To that end, this patch adds the ability to
> > > > check whether the VM type supports in-place conversion, and only
> > > > allows mapping its memory if that's the case.
> > > >
> > > > Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> > > > indicates that the VM supports shared memory in guest_memfd, or
> > > > that the host can create VMs that support shared memory.
> > > > Supporting shared memory implies that memory can be mapped when
> > > > shared with the host.
> > > >
> > > > This is controlled by the KVM_GMEM_SHARED_MEM configuration
> > > > option.
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  include/linux/kvm_host.h |  11 ++++
> > > >  include/uapi/linux/kvm.h |   1 +
> > > >  virt/kvm/guest_memfd.c   | 105 +++++++++++++++++++++++++++++++++++++++
> > > >  virt/kvm/kvm_main.c      |   4 ++
> > > >  4 files changed, 121 insertions(+)
> > > >
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 7788e3625f6d..2d025b8ee20e 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> > > >  }
> > > >  #endif
> > > >
> > > > +/*
> > > > + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> > > > + * private memory is enabled and it supports in-place shared/private conversion.
> > > > + */
> > > > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> > >
> > > Hm. Do we expect any caller for !CONFIG_KVM_PRIVATE_MEM?
>
> I think you missed this.

Yes I did :)

You're right (reading between the lines of where you're getting at
that is). This should be

+#if !defined(kvm_arch_gmem_supports_shared_mem) &&
!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)

I'll fix (if you agree with my understanding of your comment).

Cheers,
/fuad



> --
>   Kiryl Shutsemau / Kirill A. Shutemov

