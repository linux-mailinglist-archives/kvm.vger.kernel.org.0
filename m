Return-Path: <kvm+bounces-65230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64AA6CA0AD2
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 18:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 400113083328
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 17:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B743161A9;
	Wed,  3 Dec 2025 17:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="Hjgg+62H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E3D274658
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764782377; cv=none; b=fzLnZ52ZGDNfVtEvn9G24lenYsu/S1XnzjKCggB8mfVSHeITslOy0LOBxA/Bq65eV1ldYhM+AFBm8/8W4NiBj6H0AgL24trszSWzW3lbEQ1s1ty5AV24ujFkXTA2c8PWUVs5+oagjt0wO5Hrg0Nli31HPrdyKWpCeHiwlvBoSpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764782377; c=relaxed/simple;
	bh=CwA9Ys5uCmBjSmMP2RcG9FxDi2vRp38nNCScDl7Ne4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKxUqVccXOwdwYwlIFwSf2JoqktfmHJoj/gfzTScsZkSs9dY8/NcgLSqqF2YT/yBGcgHNRwbL9R+1HV8IiNmz1CbYRbVlsp0HUH0aD+fK5JNFPtT0hoJlRHGRQAd6qQvTUPLwkwMUYcBJ+BsX++wnYwP6Cw1uXaS/oJCvO8RIRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=Hjgg+62H; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297f35be2ffso106380755ad.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 09:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764782374; x=1765387174; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ntk4xZMcJdx9GyxuuhaDbNEO4dKaRG4g/4/eVizjmMk=;
        b=Hjgg+62HKTnyEzu5kmSlofkEsioAgC0rAc0wXBtDMFckRRzbLlJxkTEN1phMy14VVU
         JgF6tGBxauZZLfJe43QCqkuFbavS4MqSAo5AthVF9H2T9BNW1wmlY3WYq99ZJ5idA9f9
         FKHSCpdICyCjoDjXBTpnNXS/d0CcGfNpseDV48PUJnJ+cJo/2uX4IbADyYvFS87gWYNz
         TN28JBFiO85Wm15B7vQRpmdnbEY2+++Ch8kLvf1Li+TMsVQJ0nCOdyWLF9T/cf6VHmVV
         PDIREze8ZBjhT7C2o+5+8SQZ8xhFsiKYyCSefn4m9kusRc2NShwYg8bZKiAVlDT3/2/T
         eI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764782374; x=1765387174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntk4xZMcJdx9GyxuuhaDbNEO4dKaRG4g/4/eVizjmMk=;
        b=ndZk9V8Wk1g+wIv4/aPuWjf67GFzx8nDchaAOOKr4i6cqjqozzIKu2gahypt8m+bp2
         i6wteWikc04ZyvUVU0BmGF7xfrkZxiNQ4/dJRMse9YnTZT6hWU5nkLl7EKh3Wxn3xGUS
         YJSI5lkQa5IWog39e2f211IRlKy3C0N/IhAhv0+E3iQVZQ+T393M4sU+kCAh5n++cMIj
         0/G4KEpRY6tAGi5WiiobocQplOoJ1h7uhL3soZrAGZK9pY31/ihXUIkDYDG2m6MFAAbc
         RZPc52mFWe/eIv359a3TAHMqoixzY9hZElZiTk+31gcV9neB4pOowLyoSlc8q7YWay1v
         cGaA==
X-Forwarded-Encrypted: i=1; AJvYcCUj12vVfYImWuGXNTqwu+vfodX9LIbyAsxeGCcoX6VPBAhcyB0Zhqsa54wA/slIQ6zHEgI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYK5APx8wYdnMfnrIOyFbV7lGkmcaKwu8w310fRntHGxeYKyL6
	IZIc7hbc5iZNpJlxUX8c9JEutTT6PaAb+61mAxQaCCSRESxs/ZM7SMSSwXx80oINAQM=
X-Gm-Gg: ASbGncufHndNfI6utdy5yhRgk2P+a8dpnrJRVUGPRYIo/V9QACF7pR8XtgdSjUNELeg
	lI65geFtWrKN7kGE1uKNG6ml8d7Z28dZ0o1F/T2/GhHpg0XWm+kBnw+dJu7bbYRmm1qxzUqc2xW
	g4iBUQjYBjUIXqoqkU4Ymq5te/sDqwFZcBy18on0tgWYki6h4uTIjjop9VT2xwrMOqHZJIs4VPh
	eIbnnepLM99fv856dSyigXoiWgUfs52Z50xIfP/7z0uKKUWLADdNTm1Kqjg/14MRUBztwHvTh0v
	jql3cK4Yd+YaueMKmLCoJS5Pc11u+OAtxSX0Dn18vqf4mMqpbigBZ1PE6g7Vw6QY1a3KyfhIlc6
	p65bYrTy062zZcxSxzsfkizezkCzYq9yAmmD7hbzDZQGdm9g9hI1ms5IqZ8QguxqVukbMfbNoHl
	0vUrZwU6zTd+ciNA9g3Fj2
X-Google-Smtp-Source: AGHT+IEJ2Iti/5YvIxdDWKb+Z7naCD/zlmjgrBAtvofU3TTuAmsOEg1X1az1RgMcBWVQzA1qII+ZbQ==
X-Received: by 2002:a17:903:40cf:b0:29d:65ed:f481 with SMTP id d9443c01a7336-29d681418femr39682905ad.0.1764782373529;
        Wed, 03 Dec 2025 09:19:33 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce442691sm188814395ad.28.2025.12.03.09.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 09:19:33 -0800 (PST)
Date: Wed, 3 Dec 2025 09:19:28 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, ajones@ventanamicro.com, atishp@atishpatra.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 1/4] RISC-V: KVM: Allow zicfiss/zicfilp exts for Guest/VM
Message-ID: <aTBxIBZ0Jwn67OcV@debug.ba.rivosinc.com>
References: <cover.1764509485.git.zhouquan@iscas.ac.cn>
 <103e156ea1f2201db52034e370a907f46edafb83.1764509485.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <103e156ea1f2201db52034e370a907f46edafb83.1764509485.git.zhouquan@iscas.ac.cn>

On Mon, Dec 01, 2025 at 09:28:25AM +0800, zhouquan@iscas.ac.cn wrote:
>From: Quan Zhou <zhouquan@iscas.ac.cn>
>
>Extend the KVM ISA extension ONE_REG interface to allow KVM user
>space to detect and enable zicfiss/zicfilp exts for Guest/VM,
>the rules defined in the spec [1] are as follows:
>---
>1) Zicfiss extension introduces the SSE field (bit 3) in henvcfg.
>If the SSE field is set to 1, the Zicfiss extension is activated
>in VS-mode. When the SSE field is 0, the Zicfiss extension remains
>inactive in VS-mode.
>
>2) Zicfilp extension introduces the LPE field (bit 2) in henvcfg.
>When the LPE field is set to 1, the Zicfilp extension is enabled
>in VS-mode. When the LPE field is 0, the Zicfilp extension is not
>enabled in VS-mode.
>
>[1] - https://github.com/riscv/riscv-cfi
>
>Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>---
> arch/riscv/include/uapi/asm/kvm.h | 2 ++
> arch/riscv/kvm/vcpu.c             | 6 ++++++
> arch/riscv/kvm/vcpu_onereg.c      | 2 ++
> 3 files changed, 10 insertions(+)
>
>diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
>index 759a4852c09a..7ca087848a43 100644
>--- a/arch/riscv/include/uapi/asm/kvm.h
>+++ b/arch/riscv/include/uapi/asm/kvm.h
>@@ -190,6 +190,8 @@ enum KVM_RISCV_ISA_EXT_ID {
> 	KVM_RISCV_ISA_EXT_ZFBFMIN,
> 	KVM_RISCV_ISA_EXT_ZVFBFMIN,
> 	KVM_RISCV_ISA_EXT_ZVFBFWMA,
>+	KVM_RISCV_ISA_EXT_ZICFILP,
>+	KVM_RISCV_ISA_EXT_ZICFISS,
> 	KVM_RISCV_ISA_EXT_MAX,
> };
>
>diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>index 5ce35aba6069..098d77f9a886 100644
>--- a/arch/riscv/kvm/vcpu.c
>+++ b/arch/riscv/kvm/vcpu.c
>@@ -557,6 +557,12 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
> 	if (riscv_isa_extension_available(isa, ZICBOZ))
> 		cfg->henvcfg |= ENVCFG_CBZE;
>
>+	if (riscv_isa_extension_available(isa, ZICFILP))
>+		cfg->henvcfg |= ENVCFG_LPE;

Blindly enabling landing pad enforcement on guest kernel will lead to issues
(a guest kernel might not be ready and compiled with landing pad enforcement).
It must be done via a SSE interface where enable is requested by guest kernel.

>+
>+	if (riscv_isa_extension_available(isa, ZICFISS))
>+		cfg->henvcfg |= ENVCFG_SSE;

Same comment on shadow stack enable. While usually shadow stack usage is optin
where explicityl sspush/sspopchk/ssamoswap has to be part of codegen to use the
extension and not modifying existing instruction behavior (like zicfilp does on
`jalr`)
There is a situaion during early boot of kernel where shadow stack permissions
for init shadow stack might not have been configured (or satp == BARE at that
time), in those cases `sspush/sspopchk` in guest kernel will start faulting.

So enabling shadow stack should also be done via SSE interface.

That's how user cfi patchsets also do.

>+
> 	if (riscv_isa_extension_available(isa, SVADU) &&
> 	    !riscv_isa_extension_available(isa, SVADE))
> 		cfg->henvcfg |= ENVCFG_ADUE;
>diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
>index 865dae903aa0..3d05a4bafd9b 100644
>--- a/arch/riscv/kvm/vcpu_onereg.c
>+++ b/arch/riscv/kvm/vcpu_onereg.c
>@@ -72,6 +72,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
> 	KVM_ISA_EXT_ARR(ZICBOP),
> 	KVM_ISA_EXT_ARR(ZICBOZ),
> 	KVM_ISA_EXT_ARR(ZICCRSE),
>+	KVM_ISA_EXT_ARR(ZICFILP),
>+	KVM_ISA_EXT_ARR(ZICFISS),
> 	KVM_ISA_EXT_ARR(ZICNTR),
> 	KVM_ISA_EXT_ARR(ZICOND),
> 	KVM_ISA_EXT_ARR(ZICSR),
>-- 
>2.34.1
>
>

