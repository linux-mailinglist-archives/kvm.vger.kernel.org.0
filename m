Return-Path: <kvm+bounces-45590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A50A8AAC3A7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A0A47B9A20
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 12:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D7E201116;
	Tue,  6 May 2025 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dVCNL36G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F4527F744
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 12:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746533774; cv=none; b=PQjPh+elsO9fEP2bw3fw/T21MNLD4A+NQGopP8lf3J9/TSypYZQjDRPWb07uIMGc3wAZ+oMNJp9pFxQfyiV6TNAM72hlsjzx8RhsMrSWIPNsr4igPOl+6RbgROFpnAGFVaNyFq6ygAc73ibJSi41UbUczh5YmyDkb4255iQgCdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746533774; c=relaxed/simple;
	bh=0gj5it6bFF5wR47279deVjSN0PKeKmqzO18KDL2SWGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LVP+S53NnRdBAS3ZUtxa06G3MopIyoZ/V/M03KBHus/Dc6nude6BHIa8esEnrqaYnH6X9KIvbTXT7D6bkpyM6XHBXTfdl2zHVwWD2zFKqoOJvddXX1JVxdISDf7cTVbu9/L3mOk1DE82BN63v5JeC+dHcAUP21j/k1dGd6wC6Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dVCNL36G; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4774611d40bso305281cf.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 05:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746533771; x=1747138571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6f8Pkog9VRKxqJVqX7zIYOBYdtx7uWBL1I7B160ljq4=;
        b=dVCNL36GR4sJ0NSR9uL4ZukWs7MxVv7tAAgV3q4ltGOstNFbqYfaPZEXdVm2UL7iue
         RX6JSDFmaXXVLQBPJCDjbTKKXQ+x7T+R1rZe6zj7L17kr/GspN7nWtqNNwQGV/VH7ws+
         ZP8HjwuvnReC00NEh2K9IJwsNn5UKaHFEyfyih8dEiaA5FtgfbX17BRirPbS1tQkVB+U
         JWiow/UmE8hcBucWzRI7r+7I4QPGc9ACnQIHfV9i87BEDjR266iU3c/c/F/8JnJvBxXe
         3Qu87uYsfLIckR2CHp36rB3S+gJC5zvWIxOJt/Ke1FNvZR4QGErRy+bKfU/kvoa/WtIU
         TqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746533771; x=1747138571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6f8Pkog9VRKxqJVqX7zIYOBYdtx7uWBL1I7B160ljq4=;
        b=aj5m7oXsRoCFfdMpG0lHzZsSIuU8VuYyHInF5kNSnC3zYPfvgziaxh+5eTz8sjTTfk
         lpvz0bK9AexOdS9vfsUSy3CexEdW3JaaCBEwDjBjhhc1Fp2XdQcTI1ab5664fr4J0dr3
         8ZH+PZh+VROsTIfxnQIcikcdzPfj5et+PTfRFIK6yZpa0HQlF51lx5AAZhccLrHD8Oeq
         ivVFx/J2UyVzZz4ukfOpFoy640EuGFhYPFICQqK05C/GREBATBfPwzKrpDEN5oStxxD1
         ufDfyJnoj5Wousmsl7l5z2aEDejyHaD53F0i5wdt6LBLpi+94gElRM1geBqrdzwpDJo2
         X+Dw==
X-Gm-Message-State: AOJu0YwBIBZrjQtew0hAUMFftW5Eis+wyIUtNaPUGH+sE+x+XkQwAqtM
	83aSw0HVlwljvhRGlrySavmBzvDgYbMzxwNKtRowsAQidGJuuoyzX3dKPYuKwgpXq5L8YinAWCP
	72bPXzIchH3n9PZESEa3LBKIaQUKswLkzLFQY
X-Gm-Gg: ASbGncsx3HEL+4wBG7tvj2q8qVv1+SstT/fch4TJu72lCaPRlTqzvCE01UoxRl/lQw/
	BEKMiCyEMpK6XjKug5NS3jEEYtRp4TXIZ7wfII0f5SjJMMpMBzp+mhaDlEkJ5hYw3N9njgLsqwL
	UAPBmqKnVPgHrUFto85QyQkJrHDRPhEKqoWPNLWd6v5b+H61OgMls=
X-Google-Smtp-Source: AGHT+IEe8eF4GziUIN/tZf4C7cxJ7AWiVvXbtx1ZH0D0GFwoa/koUU4cjSVlt3/dzy7oD7pGBcV8s+6Nzx0ShmO/HV8=
X-Received: by 2002:a05:622a:553:b0:486:8d63:2dfc with SMTP id
 d75a77b69052e-490f4729ab9mr4853121cf.2.1746533770768; Tue, 06 May 2025
 05:16:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com> <20250430165655.605595-9-tabba@google.com>
 <6819283cc31f0_28880f2944f@iweiny-mobl.notmuch>
In-Reply-To: <6819283cc31f0_28880f2944f@iweiny-mobl.notmuch>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 6 May 2025 13:15:33 +0100
X-Gm-Features: ATxdqUH8kDs1bsapOMm1wv2xmE__aC-8T_lWieo1BBZsq2lh3T9YXMXc-QxkqaQ
Message-ID: <CA+EHjTzwfnvYBPNyDFDOkSeKGSu6U2sajfQsYuhW-n_C35KXmQ@mail.gmail.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Ira Weiny <ira.weiny@intel.com>
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
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ira,

On Mon, 5 May 2025 at 22:05, Ira Weiny <ira.weiny@intel.com> wrote:
>
> Fuad Tabba wrote:
> > Add support for mmap() and fault() for guest_memfd backed memory
> > in the host for VMs that support in-place conversion between
> > shared and private. To that end, this patch adds the ability to
> > check whether the VM type supports in-place conversion, and only
> > allows mapping its memory if that's the case.
> >
> > This patch introduces the configuration option KVM_GMEM_SHARED_MEM,
> > which enables support for in-place shared memory.
> >
> > It also introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> > indicates that the host can create VMs that support shared memory.
> > Supporting shared memory implies that memory can be mapped when shared
> > with the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h | 15 ++++++-
> >  include/uapi/linux/kvm.h |  1 +
> >  virt/kvm/Kconfig         |  5 +++
> >  virt/kvm/guest_memfd.c   | 92 ++++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c      |  4 ++
> >  5 files changed, 116 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 9419fb99f7c2..f3af6bff3232 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -729,6 +729,17 @@ static inline bool kvm_arch_supports_gmem(struct k=
vm *kvm)
> >  }
> >  #endif
> >
> > +/*
> > + * Arch code must define kvm_arch_gmem_supports_shared_mem if support =
for
> > + * private memory is enabled and it supports in-place shared/private c=
onversion.
> > + */
> > +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_=
KVM_GMEM_SHARED_MEM)
>
> Perhaps the bots already caught this?
>
> I just tried enabling KVM_GMEM_SHARED_MEM on x86 with this patch and it f=
ails with:
>
> || In file included from arch/x86/kvm/../../../virt/kvm/binary_stats.c:8:
> || ./include/linux/kvm_host.h: In function =E2=80=98kvm_mem_from_gmem=E2=
=80=99:
> include/linux/kvm_host.h|2530 col 13| error: implicit declaration of func=
tion =E2=80=98kvm_arch_gmem_supports_shared_mem=E2=80=99 [-Wimplicit-functi=
on-declaration]
> ||  2530 |         if (kvm_arch_gmem_supports_shared_mem(kvm))
> ||       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> || make[4]: *** Waiting for unfinished jobs....
>
>
> I think the predicate on !CONFIG_KVM_GMEM_SHARED_MEM is wrong.
>
> Shouldn't this always default off?  I __think__ this then gets enabled in
> 11/13?

You're right. With the other comments from David and Ackerley, this
functions is gone, replaced by checking a per-vm flag.

Thanks,
/fuad

> IOW
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3af6bff3232..577674e95c09 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -733,7 +733,7 @@ static inline bool kvm_arch_supports_gmem(struct kvm =
*kvm)
>   * Arch code must define kvm_arch_gmem_supports_shared_mem if support fo=
r
>   * private memory is enabled and it supports in-place shared/private con=
version.
>   */
> -#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KV=
M_GMEM_SHARED_MEM)
> +#if !defined(kvm_arch_gmem_supports_shared_mem)
>  static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
>  {
>         return false;

