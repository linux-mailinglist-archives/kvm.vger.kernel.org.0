Return-Path: <kvm+bounces-55020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B865B2CAF1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F9593BE93C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A9D30E0FB;
	Tue, 19 Aug 2025 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/5VW533"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F8630E0DA
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755625052; cv=none; b=ZmNWTRqQG8m4hL6h3VIFORAQavti+RhmrfVW20jX0CGHwgsYe6769jbsWTvGxfw4v0RIBcv9SjZ7S5LGcwVr4WsYpQDDS4zT4nzClmuPQd4eHILkD/AR1SMF+X5W5AAG3M1s7HvMhZLX/Y106XFRITIJI6x5FiniTBjKLsXsnCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755625052; c=relaxed/simple;
	bh=Nek3Pvszbi5q4OIHQoHPCJUKyVyIMZNtiypwZkEUpNY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RZ8Zgg2b6xnrdNIFQECM1KM3y+QTpySmQ6/AarisPi88FZACxrWnekeBlKdenT8bYIREHRJXSY0fL8pooAFJVPf6SQADQ6nbE9j9CeFzWy1+yZms2H+2+w6D8gMkUTuFnvYyrutx9UhznSOTBiAh/8LdBXVdM42RvP/NcuoafLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/5VW533; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e5c4734so5452475b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755625050; x=1756229850; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tvwHDk/yqCRnqD+LedgU5w1dqUV12jvsCwg/W7+3EAE=;
        b=n/5VW533tuZZ19eBD4d6isht1reS+nB888fZqLF97jpWPEtdVju78dmub0Zmnju2Ey
         Cr5aARi4+fa9J5OClXaHR9qT5yDOvSzh6ryKwx8nAU6c1ugbsQV2FrDaV3EuJ7jsAytM
         qSAotzofjDoFxpxLeBpzQsyct7f1yOQvrBRoKpSl5Jtcg6/wgn/TyK989acsZhDsR4DP
         PkRzMQNVDCG2yYT3It3U/SGcfS8hKQn63tQeU2N5TTBpR6NIk0jzOoHZOxOumOQmNW57
         jwTMomEnD+t/2CA0Ytm/EN/KhUw0lZkvCq/NskWWwkIWDBcku/2o7X5bSKb5humC6qIz
         nFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755625050; x=1756229850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvwHDk/yqCRnqD+LedgU5w1dqUV12jvsCwg/W7+3EAE=;
        b=IO3Gd1oLtQDr+A5yoR/NeHZ1nXSf75flIGFMGSdODZDOFrb5u0Okw888CScf4rD3Ck
         Lc/Sls+sEPpr8WmVXoCdF94KClZtWfi08ayAXU52scr1A+hzuPGhmBb+ZX8aLIxOUf9m
         EzY26/j3B1EVE0WMskFwWZt2rcIqEJRadPgwPJQ3tPI1f96hp6l8vI76pjDnWP1Guyj7
         KughbJEnjztZrbyxVft9Pho9YlZncUffMRneAJQgNchLhgnF1aflFvaQRfjk84oL4JhJ
         V7qwxbQ5qDyX8xhqWem+ImNkik6/RpZPdC6lupjvH75/O0DPorZp5sXIbrdMDgYX+vzl
         kAJw==
X-Gm-Message-State: AOJu0YwJMQFxGt1onLQeKKBzmXggYTKeyoBq7l5hhbVrxPvd/7yxbgLp
	XMZSghmEk/iSAhmj/UQpBy8V2iVIanP5ThP0+Nx8QxYCzEe75GiA2h3d2sdXdgNuZETAFMyjtXA
	kEiziTg==
X-Google-Smtp-Source: AGHT+IFWoOsVQR5vLs1kkcy1LLRaJmXeYdHqmbqS2n7ben+PI7FVthnAUZylyprKBZj8jm5KAvMX4c12EeQ=
X-Received: from pfnj11.prod.google.com ([2002:aa7:83cb:0:b0:748:f030:4e6a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e97:b0:76c:1c69:1115
 with SMTP id d2e1a72fcca58-76e8dbf0488mr87280b3a.8.1755625049802; Tue, 19 Aug
 2025 10:37:29 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:37:28 -0700
In-Reply-To: <20250812025606.74625-7-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-7-chao.gao@intel.com>
Message-ID: <aKS2WKBbZn6U1uqx@google.com>
Subject: Re: [PATCH v12 06/24] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, xin@zytor.com, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
> KVM synthetic MSR through it.
> 
> In CET KVM series [1], KVM "steals" an MSR from PV MSR space and access
> it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
> and hides the difference of synthetic MSRs and normal HW defined MSRs.
> 
> Now carve out a separate room in KVM-customized MSR address space for
> synthetic MSRs. The synthetic MSRs are not exposed to userspace via
> KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
> composes the uAPI params. KVM synthetic MSR indices start from 0 and
> increase linearly. Userspace caller should tag MSR type correctly in
> order to access intended HW or synthetic MSR.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/ [1]
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 10 +++++
>  arch/x86/kvm/x86.c              | 66 +++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0f15d683817d..e72d9e6c1739 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -411,6 +411,16 @@ struct kvm_xcrs {
>  	__u64 padding[16];
>  };
>  
> +#define KVM_X86_REG_MSR			(1 << 2)
> +#define KVM_X86_REG_SYNTHETIC		(1 << 3)
> +
> +struct kvm_x86_reg_id {
> +	__u32 index;
> +	__u8 type;
> +	__u8 rsvd;
> +	__u16 rsvd16;
> +};

Some feedback from a while back never got addressed[*].  That feedback still
looks sane/good, so this for the uAPI:

--
#define KVM_X86_REG_TYPE_MSR	2ull

#define KVM_x86_REG_TYPE_SIZE(type) 						\
{(										\
	__u64 type_size = type;							\
										\
	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
		     0;								\
	type_size;								\
})

#define KVM_X86_REG_ENCODE(type, index)				\
	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)

#define KVM_X86_REG_MSR(index) KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
--

And then the kernel-only struct overlay becomes:

--
struct kvm_x86_reg_id {
	__u32 index;
	__u8  type;
	__u8  rsvd;
	__u8  rsvd4:4;
	__u8  size:4;
	__u8  x86;
}
--

[*] https://lore.kernel.org/all/ZuGpJtEPv1NtdYwM@google.com

