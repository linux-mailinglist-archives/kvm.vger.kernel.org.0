Return-Path: <kvm+bounces-52638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A394CB07654
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDEE94A5492
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2172F50AC;
	Wed, 16 Jul 2025 12:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o4h55GH9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E8A20110B
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670495; cv=none; b=fubcPcd9QZ7O2O2D5+dTDA1RlI1tnUtJQYb27m/6KTE1sm93RdZm5pNjc+W/xcVZpaz4ZGU6Lxe5vALOpRudVhACSLzz78sfLmnKS9XrF/ZkWrfNw5E8UeVt6AnMPXzLCkLKTcFCpf09lXWJZZ9eYFn7U+rt+ktIvpAVO/i76nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670495; c=relaxed/simple;
	bh=AAemU8l07qLqvOU5KWKHhv6y1M/uqASoO8wNBjzSk0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AFtfvWK/e/+6AfpYpNKGgSZ7AxHyjLEWO/JIu4feYzH0a3/pnlfiDEweJiNG9/YkUjnGW6ftRwwDf9/6laTitdIGzyvtfG7POtDHhiQMmi56yRE2rclubLX3od25Ntq5dxSHcN2N1yNCAnASP4muJrDV3JXTv6zdqudDCQbAGZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o4h55GH9; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ab3855fca3so192271cf.1
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 05:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752670493; x=1753275293; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j8ldmZ55jy5ZaXuomv0Qov+zBm2r6aMGVRc2HGPVpC4=;
        b=o4h55GH9odi2rx+j0LLRWvj0iA4WqyD87/vWEC9fmmlv7QUPar/UQecWOgEuplfUQG
         jnnTvz5kS9ZlDH2m1eJJeJjQtQDOU3aFDdmOWiwNmDlQrRLSodXnSaN30kFb+5uGkQt8
         97IUTOiCR9vf3mKit2JC1o7vhyJpXFfi6hB+z22qSVOXNO6w0yKIctoyiNCN/XE0+Ube
         qHbVbheo9tv/GcxeEhIhyjWdmTVWeq5PJeI98YurSPRZcCUk063kk0rCGAr/iVAhE56I
         bo5lCof73AG93mKV1r8Pc99Tobak1waSj5wI9T/uvbG96X70cFPzs/cpBvZOv6fwAY6x
         mUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752670493; x=1753275293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j8ldmZ55jy5ZaXuomv0Qov+zBm2r6aMGVRc2HGPVpC4=;
        b=qgncvYAhXTnLFbKqwgXSr9X1xhTq8Tth/SQQBNXrLepxA8G+sNRGoHAgQfDbBcfY8M
         l47pTl9PAolZRC5k8i8KxIfSRrw345/l/RFSM8sU/17o6a2M5169C81ioMJiBzoKBCtM
         PIJW0tV59GOwDBm3r/CxCCyucFXm0AxtNrlpl1ig12sE6lJ7wAlr3t3f+v0ry1+z5+OI
         jQx5VYknlXggfZFyyPkQjIJc4aQanZ7NpKhXrbt0vwAcpZLS1YtJbNip/ZoufdRmRCTI
         YVjri41S1OBkxDchNOl3/YmZaWFT6EoszTOgcqN1x95XtpOGX9aBryn9cGdiqQLX+QxJ
         v5cA==
X-Forwarded-Encrypted: i=1; AJvYcCVS+AMl+0Y+Tgvco0LOdtqNuaXg4BgEdxXxCmlReme8S6V7XSGTSFWZs630GdM7VxnEXgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDEEyGpglwkQeQcGZNZ8TkUDgwCqDmRG3Cmt1Q21/EOYTQK5Vm
	7rA+O4b8+ZtOOl7ncbpdhRn9SU0SyZasjl1P3yjy4SKuho7ZNcShOJFzJfn5MMlqwtBjM/QPmff
	FNdqyUmqQ1GjwJeodPZUoqquNLek77tiAMfUfACoC
X-Gm-Gg: ASbGncsYAWG7FHrZyJ8m5vKl/813+Qz268igmE1H334Epoxov5KkhYDyBIWsB+KiGTF
	Wt8RbjFEIs8Pc8O9/aIOjunhDkOq8uNnwlXrubf9bNInDiNPoK3LrvNwqAygpoCxwPeaqNaivLT
	aa1Or9y/WbYUSmq2LRbSlRkZO4QTVeQxQmTbbLmhn9017+4z/Do4NrpAr/yxOJpQGYl1cIHgXEa
	tQrHkJpKW0XIYPFVEug4yD9qlJwXo5kJuU=
X-Google-Smtp-Source: AGHT+IG5QZXwMh/pWZ7YvuTyEUvPla3aSmPB5N9IHixBAAJw9oVvqZOIDmKNLn+4MKe74P7oCrt5WimSbibRGo5z6oU=
X-Received: by 2002:a05:622a:1aa0:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ab954d8746mr2689661cf.24.1752670492218; Wed, 16 Jul 2025
 05:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com> <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com> <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com> <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
 <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com> <fa1ccce7-40d3-45d2-9865-524f4b187963@intel.com>
 <f7a54cc4-1017-4e32-85b8-cf74237db935@redhat.com> <CA+EHjTzOqCpcaNU4caddh6N3bCO0GvrOoZ+rMApdRh4=+BEXNA@mail.gmail.com>
 <c8b74572-3ed3-4a93-8433-1207e59f56e7@intel.com>
In-Reply-To: <c8b74572-3ed3-4a93-8433-1207e59f56e7@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 13:54:15 +0100
X-Gm-Features: Ac12FXyFhk5Ea2iRIAOGi8JPKWZm4iBDcstyagLqnmugwx2wsA5Hot8K1UY8_ZA
Message-ID: <CA+EHjTzjxGqkaUkGvsUn+GXgKxUh3nsajRSbVmOszsLcAqVzcA@mail.gmail.com>
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Xiaoyao,

<snip>
> Not really the same result.
>
> The two-step patches I proposed doesn't produce the below thing of this
> original patch. It doesn't make sense to select
> KVM_GENERIC_GMEM_POPULATE for KVM_SW_PROTECTED_VM from the name.

I think I see where you're going. That said, other than in the
configuration files, in all the actual code, the purpose of
KVM_GENERIC_PRIVATE_MEMis to guard  kvm_gmem_populate(). So
I disagree with you, and I think that this should be one patch that
fixes the name. That said, I agree with you regarding:

-       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
+       select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
+       select KVM_GMEM if KVM_SW_PROTECTED_VM

Cheers,
/fuad

