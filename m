Return-Path: <kvm+bounces-24968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEAC095D9E1
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B0261C209FC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7660C1C93AF;
	Fri, 23 Aug 2024 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d/xNKJQE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38126149C4C
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456996; cv=none; b=WTN/aPccFKXCpDeNw/2R8Ij34m58t4GoWGcWLrkN8eFq4CisyLJ0EdVXJhY9OvwOJRDS9ycV3YqetpJA5AktkNrwqlcZS3iVFK/2feuvRjHq6pc8XJA2Elh0QPVLo/4b+/CDHGf6mOZr4vXFKAMb/bK0i9PADhOp96pPvcvU6qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456996; c=relaxed/simple;
	bh=5ocuxDCZOw3ZIFqYLiWdmWuds8/rDOyOjJDZjhds/iQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fPP1ui1y7sGXemuAvZQMyHZfz/Nvv9AUoYz/pkgHlZlD8SmuytNOa0W7UEcu83Js2gsD5iIDEOZvtGdP9H+jum/PTzwdK8MY65vVCUkKczNM13AnRna/AcKuAPmfzpWW2vA0HZdT3rdG2gWgaA5pfnjBqXLVPfLOODS93mMy0sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d/xNKJQE; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20353e5de9cso72355ad.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456994; x=1725061794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GL+ZvkphrtYI2AGt7Cux2hCNmAwRaDUiXvbeUWnxfz0=;
        b=d/xNKJQEBJLjI9E7IJ8c1mtjszFkh7N1+JfQUhdIkl6ldDIWk2l4jSHZ97kpL2OnAV
         p30QBJ9aEhVWm5KqZpeZzMOPL4CbOUzkqHxWnyuW9f+QDa+KOCMiuu3HkEJAIFrGZOXq
         HI9xKdm2uBMOBimhWi84msPTQSX5xWKRSJM/Oeb08dWKaKJanFkiqR12NfVA6zN7/88t
         meqSzl/sBfsxu36gePRx3XXOkaOSxkrbtUArunDhHEz0VgaMNYeHWCUBKmULwUEEIBDq
         a3nJ8sNjU5qZwSVttAw+QfsHHMpbii5xBcx6EQPvigbMzSwq+xBQhmctDoST4KM+gsZg
         umBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456994; x=1725061794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GL+ZvkphrtYI2AGt7Cux2hCNmAwRaDUiXvbeUWnxfz0=;
        b=po2Swq3swW4FE2ZMCIHpAOg3Avwwi+iOejrEw1hXwmako/7xNaSbonowQx70UKTABk
         R8kwbRtJK8P+DAQP/LSn926jTjXcLoXBV3q002b2PO+PyoYQ2slIgTv3VYe14VmaDA5I
         WjzruLQ4sDdekt8V9VGSVt3FeCv+GHi0iOUXTrZDr3FR7QImSuSu/n7XQF9cCcI1iDk8
         VV8hgPyJRHlDhs0x0TQ4VsF3+ZBO85YVXa8G0kginOfOvE1VsZIcFCNMf82H5BY2NXzg
         kjS42cgxo5Fp6SVyb8WF0+0w+JbcNZ2oI1YqxCzBxf0Pp2ttmsAyLuSzOxAR+85I9mMk
         9mSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb/XCfSAlfA7oxyeAM7gi1Whz3dOc21yXObPhz5hzqFsEHCuqGIUa412N/TqWUKO1ou50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1qxpeUok5HSAizxxeofK2Nb32WOCSrf22GnAdoMlm8rvVEm4P
	cz60mMzIemGs1Df75fuQbqcqe8KDLZe2E89LBxxXYbbBRrAkCjZbUhTPWnVxjQldutrpqzfHZir
	z5nhWYvLNXtDA8OCG/vk3+0T1tH5M7T031Gwu
X-Google-Smtp-Source: AGHT+IH7T/D3OPq+qArINfDflUCiD4Co7XCZAblkw1IcaBGIpd7ZEREuAv1eIqhjattHtSVnZ24/kUO+/gnJwo1h8TQ=
X-Received: by 2002:a17:902:ce86:b0:201:e2db:7bd1 with SMTP id
 d9443c01a7336-203b6d972e0mr511015ad.19.1724456994054; Fri, 23 Aug 2024
 16:49:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240823185323.2563194-1-jmattson@google.com> <20240823185323.2563194-5-jmattson@google.com>
 <26e72673-350c-a02d-7b77-ebfd42612ae6@amd.com> <Zsj2anWub8v9kwBA@google.com>
 <59449778-ad4e-69c6-d1dc-73dacb538e02@amd.com> <CALMp9eTNX7=siC=DtBOSDLr6Aswzsq0d6UAHQpEdTd2J8xXHuQ@mail.gmail.com>
In-Reply-To: <CALMp9eTNX7=siC=DtBOSDLr6Aswzsq0d6UAHQpEdTd2J8xXHuQ@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 23 Aug 2024 16:49:42 -0700
Message-ID: <CALMp9eQsekeoT_vm-oGTf4mja6UxsVg_WnvneT=M00rox2e+NA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 3:48=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Fri, Aug 23, 2024 at 3:12=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd=
.com> wrote:
> >
> > On 8/23/24 15:51, Sean Christopherson wrote:
> > > On Fri, Aug 23, 2024, Tom Lendacky wrote:
> > >> On 8/23/24 13:53, Jim Mattson wrote:
> > >>> From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > >>> enumerates support for indirect branch restricted speculation (IBRS=
)
> > >>> and the indirect branch predictor barrier (IBPB)." Further, from [2=
],
> > >>> "Software that executed before the IBPB command cannot control the
> > >>> predicted targets of indirect branches (4) executed after the comma=
nd
> > >>> on the same logical processor," where footnote 4 reads, "Note that
> > >>> indirect branches include near call indirect, near jump indirect an=
d
> > >>> near return instructions. Because it includes near returns, it foll=
ows
> > >>> that **RSB entries created before an IBPB command cannot control th=
e
> > >>> predicted targets of returns executed after the command on the same
> > >>> logical processor.**" [emphasis mine]
> > >>>
> > >>> On the other hand, AMD's IBPB "may not prevent return branch
> > >>> predictions from being specified by pre-IBPB branch targets" [3].
> > >>>
> > >>> However, some AMD processors have an "enhanced IBPB" [terminology
> > >>> mine] which does clear the return address predictor. This feature i=
s
> > >>> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
> > >>>
> > >>> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CP=
UID
> > >>> accordingly.
> > >>>
> > >>> [1] https://www.intel.com/content/www/us/en/developer/articles/tech=
nical/software-security-guidance/technical-documentation/cpuid-enumeration-=
and-architectural-msrs.html
> > >>> [2] https://www.intel.com/content/www/us/en/developer/articles/tech=
nical/software-security-guidance/technical-documentation/speculative-execut=
ion-side-channel-mitigations.html#Footnotes
> > >>> [3] https://www.amd.com/en/resources/product-security/bulletin/amd-=
sb-1040.html
> > >>> [4] https://www.amd.com/content/dam/amd/en/documents/processor-tech=
-docs/programmer-references/24594.pdf
> > >>>
> > >>> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and feat=
ures as derived in generic x86 code")
> > >>> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> > >>> ---
> > >>>  arch/x86/kvm/cpuid.c | 6 +++++-
> > >>>  1 file changed, 5 insertions(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > >>> index ec7b2ca3b4d3..c8d7d928ffc7 100644
> > >>> --- a/arch/x86/kvm/cpuid.c
> > >>> +++ b/arch/x86/kvm/cpuid.c
> > >>> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
> > >>>     kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
> > >>>     kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
> > >>>
> > >>> -   if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_=
IBRS))
> > >>> +   if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> > >>> +       boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
> > >>> +       boot_cpu_has(X86_FEATURE_AMD_IBRS))
> > >>>             kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
> > >>>     if (boot_cpu_has(X86_FEATURE_STIBP))
> > >>>             kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> > >>> @@ -759,6 +761,8 @@ void kvm_set_cpu_caps(void)
> > >>>      * arch/x86/kernel/cpu/bugs.c is kind enough to
> > >>>      * record that in cpufeatures so use them.
> > >>>      */
> > >>> +   if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> > >>> +           kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> > >>
> > >> If SPEC_CTRL is set, then IBPB is set, so you can't have AMD_IBPB_RE=
T
> > >> without AMD_IBPB, but it just looks odd seeing them set with separat=
e
> > >> checks with no relationship dependency for AMD_IBPB_RET on AMD_IBPB.
> > >> That's just me, though, not worth a v4 unless others feel the same.
> > >
> > > You thinking something like this (at the end, after the dust settles)=
?
> > >
> > >       if (WARN_ON_ONCE(kvm_cpu_cap_has(X86_FEATURE_AMD_IBPB_RET) &&
> > >                        !kvm_cpu_cap_has(X86_FEATURE_AMD_IBPB)))
> > >               kvm_cpu_cap_clear(X86_FEATURE_AMD_IBPB_RET);
> >
> > I was just thinking more along the lines of:
> >
> >         if (boot_cpu_has(X86_FEATURE_IBPB)) {
> >                 kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
> >                 if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> >                         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> >         }
>
> AFAICT, there are just two reasons that X86_FEATURE_IBPB gets set:
> 1. The CPU reports CPUID.(EAX=3D7,ECX=3D0):EDX[bit 26] (aka X86_FEATURE_S=
PEC_CTRL)
> 2. The CPU reports CPUID Fn8000_0008_EBX[IBPB] (aka X86_FEATURE_AMD_IBPB)
>
> Clearly, in the second case, the KVM cpu capability for AMD_IBPB will
> already be set, since it's specified in the mask for
> CPUID_8000_0008_EBX.
>
> If this block of code is just trying to populate CPUID Fn8000_0008_EBX
> on Intel processors, I'd rather change all of the predicates to test
> for Intel features, rather than vendor-neutral features, so that the
> derivation is clear. But maybe this block of code is also trying to
> populate CPUID Fn8000_0008_EBX on AMD processors that may have some of
> these features, but don't enumerate them via CPUID?

There's another argument for just nuking these cross-vendor
derivations. How do we factor in CVE-2022-26373 (Post-barrier Return
Stack Buffer Predictions)?
Intel CPUs without IA32_ARCH_CAPABILITIES.PBRSB_NO[bit 24] have a
weaker IBPB than AMD CPUs with CPUID Fn8000_0008_EBX[IBPB_RET], and
probably should not be enumerating that CPUID bit.

Trying to derive cross-vendor mitigation equivalence is just going to
end in tears.

> > Thanks,
> > Tom
> >
> > >>
> > >
> > >> Thanks,
> > >> Tom
> > >>
> > >>>     if (boot_cpu_has(X86_FEATURE_IBPB))
> > >>>             kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
> > >>>     if (boot_cpu_has(X86_FEATURE_IBRS))

