Return-Path: <kvm+bounces-52193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCC9B023F4
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F4135C70E9
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8724E2F85E0;
	Fri, 11 Jul 2025 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uz+SxpuO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4005C2F7D07
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752259104; cv=none; b=SIVRZ15iSEvRn3mcynLZJtGcRlm0NYCONfdBXo/7SAAU7D3PmcmUNsdUP5jgL48qurlsKxkoo7Qk1IpExuqyfLA/nlf4JoWCCH7dy2IdScFcMvkVxte00+uT6wAA1R9yN2sLTns3JWz8OfGgg/uajhlrs+xM7CspI15uUZGe+6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752259104; c=relaxed/simple;
	bh=KsKnsKGUi1F4lD4jyihaduxyCksjkhEdPI8sb5wYzkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=drVVqZ9fXiaYjNVBBgjHcBwgKFRpHDAIZGDwaKqh+FCHitXaWXR6AV618MOnCY+x00AdHretPLW7BrF1C4W2nlq8ykpq/bUVLkWgf5Y1IZFoKCnSZweWr30+jJtA3RyxSzQth8FqeSRveafXG8uQKBbNaxe14qiQ++/vKz08DuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uz+SxpuO; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235e389599fso27285ad.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 11:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752259102; x=1752863902; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y75aBbK6qJ4jIj5tJXhEU3PzErB73/x9/veiIRAROC4=;
        b=uz+SxpuOqvCybR+FYYLtEuS4QfvZnJwhFe7sfNCwWzrTlTNJ1F8Jc22qfHgZHhq5Cc
         CmiNSHZCPQwGdNF1jQGJ8uUZusVxcryZh0TO6cyKxaRXbYlMQq/Yra5HQiQvlmloi5IA
         qZapyn/cPEqm2bX2ppXapJMZ97hU4eBQLXZnBZ46L+h9tcyfT4rHevjxObomGVYy43IW
         xo7r6/yAu5pzjceb1VKk0dumF9sZTT4QNI4p+chyjUcz+7HoCJF7vjTGhciZciagEScJ
         AS8i6fY/hhGcTM4+vOpkJ8XEDMuqg4DIrkN79r5a3Ojee1sPTlLUbUtEGSvHn0qbhNF+
         cEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752259102; x=1752863902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y75aBbK6qJ4jIj5tJXhEU3PzErB73/x9/veiIRAROC4=;
        b=pbqyA/zbN+3lrvVgRZfTHMXiar6yECrxRT7v3IJA6PEHLjgpyVbv7Cplf0X85fFitl
         K9W2El5wGbxbVo5Gi3f6cRTfR3WKhInhP2qZ8WsIi6LClPYl3/nwotHlLGskLoW4IrwN
         z84y9FvlG0fsjAvwYsXF1POxXDP5pPQJZk20i/mWrl6iiQftLYpt0USrzcV/1vxf8T8L
         NeAi98uIlvElFKh1dKZNkDvOpKmsXET/NaHeIjuaj8byHKSjiVoHRFCIbbYsXaa93PLd
         RGnv4Dnf9Z1Uvz0xMLFX9G4m4mDzqMCXB2aMGwl612koynR1jodqZFxAc9pd5V2KSEwz
         1j4A==
X-Forwarded-Encrypted: i=1; AJvYcCUlAY/yLT321cs7mwE2P5ieW1AdtHqDqI2rQGCVgF1O6HCuBEyDAfW4PtedRQWS2iygyWE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhr8vQ7o6E7PUg+wHF7VtIE2oKfJYWfXPQ5IPVStvAfU2Aiw0u
	ICEVVrJUng6RwnzouaJUxaZSVwJ0TY/2dSHXE95NndeIyMsGjV14ygyOL1mL2T4+cm3Km2gOBIZ
	95Gjjz3WAjzS1DHqYVAtIGSOklqIex+bXmymFbYPt
X-Gm-Gg: ASbGncsENZ1uqjZtTOC5oGsChI7PYpOpKfl/zFk/NkksNN8bvG8+DQd7Kz2Dwmby+wK
	GofjDVcNXQPbo9PNcH2z1qMoE7+xSCUVat8QNoulRXMwnJtLg3E034Nbwp5R1JDIXm5W0F9dboJ
	G9mYN+chrMyM8CSXeuccb70ybaBT8zOCsE0MJPfgqI/W6chNzd9gt0fUCRTIUAxCJ0nYe8mpcJU
	7nkoToQ7H8mQFhC37cmBSYLGeuLWmdxE/jjoA==
X-Google-Smtp-Source: AGHT+IGsu8dSs8HJE5goCzoJkCBjTvbHWuRcDJlMXLNqwNbWfzgwWgKINnvVish1bZEUN4Zyz8kT0A+nnxPAT2pqPWY=
X-Received: by 2002:a17:903:1a28:b0:231:d0ef:e8ff with SMTP id
 d9443c01a7336-23df6954266mr236965ad.8.1752259102079; Fri, 11 Jul 2025
 11:38:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com> <20250711163440.kwjebnzd7zeb4bxt@amd.com>
In-Reply-To: <20250711163440.kwjebnzd7zeb4bxt@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 11 Jul 2025 11:38:10 -0700
X-Gm-Features: Ac12FXwD76UGHX5gmLSUps735MnaXyS3ozgzuTfC8AJyvzOHbfbFx5Je1WNljjM
Message-ID: <CAGtprH9dCCxK=GwVZTUKCeERQGbYD78-t4xDzQprmwtGxDoZXw@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 9:37=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> >
> > static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot=
 *slot,
> >                               struct file *file, gfn_t gfn, void __user=
 *src,
> >                               kvm_gmem_populate_cb post_populate, void =
*opaque)
> > {
> >       pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
> >       struct page *src_page =3D NULL;
> >       bool is_prepared =3D false;
> >       struct folio *folio;
> >       int ret, max_order;
> >       kvm_pfn_t pfn;
> >
> >       if (src) {
> >               ret =3D get_user_pages((unsigned long)src, 1, 0, &src_pag=
e);
> >               if (ret < 0)
> >                       return ret;
> >               if (ret !=3D 1)
> >                       return -ENOMEM;
> >       }
>
> One tricky part here is that the uAPI currently expects the pages to
> have the private attribute set prior to calling kvm_gmem_populate(),
> which gets enforced below.
>
> For in-place conversion: the idea is that userspace will convert
> private->shared to update in-place, then immediately convert back
> shared->private; so that approach would remain compatible with above
> behavior. But if we pass a 'src' parameter to kvm_gmem_populate(),
> and do a GUP or copy_from_user() on it at any point, regardless if
> it is is outside of filemap_invalidate_lock(), then
> kvm_gmem_fault_shared() will return -EACCES.

I think that's a fine way to fail the initial memory population, this
simply means userspace didn't pass the right source address. Why do we
have to work around this error? Userspace should simply pass the
source buffer that is accessible to the host or pass null to indicate
that the target gfn already has the needed contents.

That is, userspace can still bring a separate source buffer even with
in-place conversion available.

> The only 2 ways I see
> around that are to either a) stop enforcing that pages that get
> processed by kvm_gmem_populate() are private for in-place conversion
> case, or b) enforce that 'src' is NULL for in-place conversion case.
>

