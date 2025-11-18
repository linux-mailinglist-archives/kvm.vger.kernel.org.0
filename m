Return-Path: <kvm+bounces-63610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E486C6BEC0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C29CC35D3E1
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39E32F2610;
	Tue, 18 Nov 2025 23:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iFFwS36q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348021BDCF
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763506841; cv=none; b=fGNP7W9yoPUX/fQHmN3ezYNKnaNUr/a+SAO+N1gbre/W090evn+mvsZmJ1SJVtRLpCkU7J4H5G1pdix/WnsuoRKcQH1yz54Ej+EqLRqRXZ8LPT3n+bzfNMROy6CZzosbSLxPbKTNrTO06MTcf4/OG39R4TLQbLxth9XqN1VIreQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763506841; c=relaxed/simple;
	bh=nAjD86DHRxM+dwuhDgTc95KNI1joeOabaC5TRoT1JlM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eI26tBXgDg2bQdVueOt6/9zocgHDpV2F5GEryS6I/WVcQkS/El8qegYrwbqDjEH84OGVIiAfWNWGWgnXyS2hIPTKAEyq11ZjBgcj1y8jGl2kS1mzzac2JnXIDIHYBFSAua/90bOcQkiw2eQL0s6mZpIJPAWV76LgkMwU9vx0BSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iFFwS36q; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-644fbd758b3so3924a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763506838; x=1764111638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oI4AAb2ulwMtrjLr6WDItp1LYtXHBsviFCoX9AxfZ5g=;
        b=iFFwS36qq1lGM8B4BU+xwpssnAxhALL78CB1hqckpY0bUiVgqkNRp0VM2UwXLn06u5
         jR+qThpPSh1qyru5UMFCs82MoPqt6ra5f5sRgvpCJ9JKqzjZRHYtB0i8RZ5u3W7lVqKo
         gRsDBGYxMYI25pFIoDtk0w+wplVBsEDyl9oKPc/2qnqh10ZwhQnKHUFaomcRFGkiJfsT
         LcQ20yIe4dqnMj/UYIktgwmQ++w4B+DsGwSrGlnAPgVqtHBfYGGiys3M/1FfXIhidPuJ
         jMIVP8Zupw1aTHfSzIcxzx2Bu4sHHik26dmGTGC+xw6BKNaWdje99F6KZQPWpOi0JzsO
         hpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763506838; x=1764111638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oI4AAb2ulwMtrjLr6WDItp1LYtXHBsviFCoX9AxfZ5g=;
        b=ovR8hmO4Bhoy26c0/C6zH+BnR8MUVW7H59qcssAsMX1Q53nXguS+GNvUzCCWXRC47m
         eI/KPRKBT9vKrne7418vrTKoGSEAhToMeI9uIpYXaxHSqyzWNHZMnxqfDfxHXswZxwe6
         N6kuBANkqwU14ikB1ro1YFJokym+/nmdeLJgfaCPUKVpT7s7uDLAaQbUTuffg2B/hr4i
         Kc4l8myKFq9fopVMkfc3H1LuuipgWQWcIyh+m4l+QkZgufBny9Qya6NMZ7gyxHSuqIDm
         C+cU1i4EbthgdogLN4/z/5fhy66pJyIq8LB3/MhXSmu6PHcpZXu1ZWuU94MOjRHtFmMA
         kYyg==
X-Forwarded-Encrypted: i=1; AJvYcCUjSeD9c0aVblJ/6MPJiB2L3cCTE8Hk0doFEPQnpvDl6dIANQitQflLQp4HfTk8vADN9DQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgPQEBfhnZpKFVVaylDDRsAIgMnCQs3AT8C5KII7+CM7DnEufp
	Qh+Hf4pks0s42HEMe/8VaGJbLK9482Sn9eDN6kdLHvgcufvxmp5kYZdPF0rqjplN0QiZKWNA4F1
	cQM+3HNd10tkbA2uBS/5zDf8WsDASOVuMlbmjuJKg
X-Gm-Gg: ASbGncuuaaJJvqLml020vAI7V0WFz4wgbSTZpgTw5KYkqdZ7HKu8OpST9yN12XtUF5u
	j79sxinpUlKYoRecFwtNE6Q9JI7kmmSHrLoozOuEkOmTFkPqWCbY13f+JZPPuDcJ87LXJVvKHPD
	k6FGRg7tNVdxhRfliUVizFNpKTl/8i1NaHML/L7iPq2fOZiR8o2iVak3feMrvjwyoGyoKbyORp0
	5FHD6d9Cew48HTTVYSHg6+9+AxB2RjOqdI8nMrqgrAbypT8r7DOOD3Wa6zhq/HAGCBb7vFPu/rD
	5jKpxQ==
X-Google-Smtp-Source: AGHT+IHp1sSmoFXI27n4vbZ5XQRO9hUaf0mWkMT0Hx0tQE9X4axqZkaWCop/2WJBesjA63ARvjXx1a4aab5MXtpFggE=
X-Received: by 2002:aa7:c4ec:0:b0:643:bfa:62cd with SMTP id
 4fb4d7f45d1cf-6451eea508bmr7308a12.11.1763506838382; Tue, 18 Nov 2025
 15:00:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev> <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
In-Reply-To: <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 18 Nov 2025 15:00:26 -0800
X-Gm-Features: AWmQ_blhXozUuaFI8FFy1husDrsakPVVtPrt4Gd6JjH8a3RbmALvcx-iBD-zfG4
Message-ID: <CALMp9eQuWx--Ef7Sxasq=MZMGPTg2ZUL0CXHH+Hvj7YEL_ipVg@mail.gmail.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 2:26=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Tue, Oct 21, 2025 at 07:47:13AM +0000, Yosry Ahmed wrote:
> > There are multiple selftests exercising nested VMX that are not specifi=
c
> > to VMX (at least not anymore). Extend their coverage to nested SVM.
> >
> > This version is significantly different (and longer) than v1 [1], mainl=
y
> > due to the change of direction to reuse __virt_pg_map() for nested EPT/=
NPT
> > mappings instead of extending the existing nested EPT infrastructure. I=
t
> > also has a lot more fixups and cleanups.
> >
> > This series depends on two other series:
> > - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> > - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bi=
t L1" [3]
>
> v2 of Jim's series switches all tests to use 57-bit by default when
> available:
> https://lore.kernel.org/kvm/20251028225827.2269128-4-jmattson@google.com/
>
> This breaks moving nested EPT mappings to use __virt_pg_map() because
> nested EPTs are hardcoded to use 4-level paging, while __virt_pg_map()
> will assume we're using 5-level paging.
>
> Patch #16 ("KVM: selftests: Use __virt_pg_map() for nested EPTs") will
> need the following diff to make nested EPTs use the same paging level as
> the guest:
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing=
/selftests/kvm/lib/x86_64/vmx.c
> index 358143bf8dd0d..8bacb74c00053 100644
> --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> @@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(struct vm=
x_pages *vmx)
>                 uint64_t ept_paddr;
>                 struct eptPageTablePointer eptp =3D {
>                         .memory_type =3D X86_MEMTYPE_WB,
> -                       .page_walk_length =3D 3, /* + 1 */
> +                       .page_walk_length =3D get_cr4() & X86_CR4_LA57 ? =
4 : 3, /* + 1 */

LA57 does not imply support for 5-level EPT. (SRF, IIRC)

