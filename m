Return-Path: <kvm+bounces-22182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F44993B617
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20F81C239DC
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 17:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B59A169AD0;
	Wed, 24 Jul 2024 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWmZivoC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F105015FA74
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721842860; cv=none; b=LNly0B6cKHDxDHwEtnQ4W38jYCdL4pqSeZ5OQKm/+HKSh0mHBVBVzRMdAQhDp2dd6CK8o8sTu2ia4SoLn6HuCH1s7poQj7wV5n5D+xhgse9AWUlOSm5CPP6kvk1Nd0CtVLceAkXYV+40vhjh6VQlgsn2BAAkg0jIYGqjMsPXS2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721842860; c=relaxed/simple;
	bh=OYhf9i9zA5SgHVdUG4+f7oWNo/fKoU8Py2NSvpMpCg0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mrhx8XxLHQ8pPWwysp2e7oXeLVYW90INAhB0sgH5TVWaCSR3EEbrOjVIhcQazxbKdppk1nU3YZRzpiD5uG0Mt9yDHM9LzRwmUZeXnD+pl79ASNTttCtS3XyK60iedgmaEDvVt7kX1jdxR5DrcfcOU0uu6CI5JLxw2287p51SKcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWmZivoC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721842857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=owQmW2FeZvZ65U+s4o+FvJjOZqmyBhsCVfnDoijmjRA=;
	b=PWmZivoCkz1I7rrSFnhaWH77idXXDrQF/Td80zqYUVEkG6fLdG7+UGcjgFn/hwUPsUIaXH
	Z3IO2xw3r4QmVCOOBGeEsyxRX+nF62AlubEjLhzpdvo6+3RHmoll4uik7TxiENxaNGDKPh
	tPh12JkWgPseoQ68Sc5V/fDHMrD/GSs=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-sHtlpasJP2OIWQhnhqeyow-1; Wed, 24 Jul 2024 13:40:56 -0400
X-MC-Unique: sHtlpasJP2OIWQhnhqeyow-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5c67ee6ed02so73674eaf.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 10:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721842854; x=1722447654;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=owQmW2FeZvZ65U+s4o+FvJjOZqmyBhsCVfnDoijmjRA=;
        b=r0hn9hbS1lCmsExslPj3v42kcZoz24Lzbial/xC+nfifwIiYWwIuJ5/agZbjlmfBma
         r3nEegap0F0s1IDQBxZr6J2xttgUn7pCNEz0gxHjrHe0ZYXesNyoWktIXmDA7kfn34YU
         mKdnmIVcJ36it15MfMjxjHdDeY0ChUFmaXF0DIuscObwTPbAUfNt95etUprc98kgbDUQ
         FEeqHpj3apiSssmmK12KCgNsLZnta3jSPzN7YumXXXAwquwmM3lT4H9j8BUjcxwdbGHh
         5VnNio4BK8cyswe6OW7Y8B71xG1875Fi4MW1rf8jGbNc1yYBXfS7jpxLkyqSPM+RhOn7
         FJCw==
X-Forwarded-Encrypted: i=1; AJvYcCWZRhPXOPZvnwye8igPZ76+PzmxiTPqkugZBIatwfzh5k/FhkAgEA7U/L7r6VTVHQyaK6p/b4voCbEPOOCS3TtIw6Fj
X-Gm-Message-State: AOJu0Yyr0bpBaoGN7C8QFMcg+zd3xyr1kkBWC8Nfsrakcm7MwfpHGBRm
	589Dfb252zqy9aHiFfNoQbvB8tESdH1mDaAVNNzIwje6v/+pHa/0SeTS8z3+CdSntLi+f8003gW
	1JA3KYaMhB7O8iETesXwAiYHJVYdg7di7FAfsfgzsYIM3q0ucHpC69zie0A==
X-Received: by 2002:a05:6359:4c1f:b0:1ac:65e7:9399 with SMTP id e5c5f4694b2df-1acf8a1406emr72921155d.9.1721842853807;
        Wed, 24 Jul 2024 10:40:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHep2kCnDTBvGNQu8jrzcXjMYD6HPrxfTzgyc4VtAPE3854fhISzuH2gLZrO+wCBXfMX9cTmA==
X-Received: by 2002:a05:6359:4c1f:b0:1ac:65e7:9399 with SMTP id e5c5f4694b2df-1acf8a1406emr72918355d.9.1721842853384;
        Wed, 24 Jul 2024 10:40:53 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a19907507esm593718485a.108.2024.07.24.10.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 10:40:52 -0700 (PDT)
Message-ID: <3e17a33c59c6a57a836c92c1bddc9bd6d36cafca.camel@redhat.com>
Subject: Re: [PATCH v2 19/49] KVM: x86: Add a macro to init CPUID features
 that ignore host kernel support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Wed, 24 Jul 2024 13:40:51 -0400
In-Reply-To: <Zoxp4ahfifWA-P34@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-20-seanjc@google.com>
	 <2a4052ba67970ce41e79deb0a0931bb54e2c2a86.camel@redhat.com>
	 <Zoxp4ahfifWA-P34@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-07-08 at 15:36 -0700, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > +/*
> > > + * Raw Feature - For features that KVM supports based purely on raw host CPUID,
> > > + * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> > > + * Simply force set the feature in KVM's capabilities, raw CPUID support will
> > > + * be factored in by kvm_cpu_cap_mask().
> > > + */
> > > +#define RAW_F(name)						\
> > > +({								\
> > > +	kvm_cpu_cap_set(X86_FEATURE_##name);			\
> > > +	F(name);						\
> > > +})
> > > +
> > >  /*
> > >   * Magic value used by KVM when querying userspace-provided CPUID entries and
> > >   * doesn't care about the CPIUD index because the index of the function in
> > > @@ -682,15 +694,12 @@ void kvm_set_cpu_caps(void)
> > >  		F(AVX512VL));
> > >  
> > >  	kvm_cpu_cap_mask(CPUID_7_ECX,
> > > -		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> > > +		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> > >  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> > >  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> > >  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> > >  		F(SGX_LC) | F(BUS_LOCK_DETECT)
> > >  	);
> > > -	/* Set LA57 based on hardware capability. */
> > > -	if (cpuid_ecx(7) & F(LA57))
> > > -		kvm_cpu_cap_set(X86_FEATURE_LA57);
> > >  
> > >  	/*
> > >  	 * PKU not yet implemented for shadow paging and requires OSPKE
> > 
> > Putting a function call into a macro which evaluates into a bitmask is somewhat misleading,
> > but let it be...
> 
> And weird.  Rather than abuse kvm_cpu_cap_set(), what about adding another variable
> scoped to kvm_cpu_cap_init()?
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0e64a6332052..b8bc8713a0ec 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -87,12 +87,10 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  /*
>   * Raw Feature - For features that KVM supports based purely on raw host CPUID,
>   * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
> - * Simply force set the feature in KVM's capabilities, raw CPUID support will
> - * be factored in by __kvm_cpu_cap_mask().
>   */
>  #define RAW_F(name)                                            \
>  ({                                                             \
> -       kvm_cpu_cap_set(X86_FEATURE_##name);                    \
> +       kvm_cpu_cap_passthrough |= F(name);                     \
>         F(name);                                                \
>  })
>  
> @@ -737,6 +735,7 @@ do {                                                                        \
>  do {                                                                   \
>         const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);    \
>         const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;   \
> +       u32 kvm_cpu_cap_passthrough = 0;                                \
>         u32 kvm_cpu_cap_emulated = 0;                                   \
>         u32 kvm_cpu_cap_synthesized = 0;                                \
>                                                                         \
> @@ -745,6 +744,7 @@ do {                                                                        \
>         else                                                            \
>                 kvm_cpu_caps[leaf] = (mask);                            \
>                                                                         \
> +       kvm_cpu_caps[leaf] |= kvm_cpu_cap_passthrough;                  \
>         kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |                   \
>                                kvm_cpu_cap_synthesized);                \
>         kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;                     \
> 

I agree, this is better.

Best regards,
	Maxim Levitsky




