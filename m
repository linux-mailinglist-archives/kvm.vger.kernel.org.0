Return-Path: <kvm+bounces-65231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 962F6CA103B
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 19:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C101233A3F5A
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 17:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805FE32861F;
	Wed,  3 Dec 2025 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="ZicQbala"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010193128CB
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764782728; cv=none; b=NlZlcNV7+7kDOJiTAWbLKnz9D7USmPuAD+n8CPa2abcWza6+JfgTzSzp046OMFfBvF/rkb+/6qmLtVQ1DPkIny/ZJ7ZhMGQpeHCM9H0HkX9SwfqiO+dCnmEl1K9PP3gyTjegoX8lFp/Pc/Q4aeJFykKDgSQd5AKYYdJNBgfOPDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764782728; c=relaxed/simple;
	bh=1uS7zIpg3SHft6jbeYESPJr7EbDeMuWzn39JYgziLn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jyhh9CWJjmyl1OlTHAD3IfBDbS3SF89/5QnxkW0G/mvUDUAbdvBPGgCoyaZVd/WoPn19s4ULA21wZmFtyMMFtvgFTi5jnYo3+2brGkbMAeWkA7L5Za82Rq9r0k+V6wqXQiuN0vHgYDBbAIwwB+lqv+6ZXy+8SXrGYLl772jI4Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=ZicQbala; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so8520996b3a.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 09:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764782726; x=1765387526; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqj8tfUGUnFRacbGDoJX9RLnVpHR5PEeHJuSOrLWuQ4=;
        b=ZicQbalaVstgZMI1CtCQ34fMs4x+HmNtXcP/8sHK9mnty24L5urNxEGQCVTMgC5HGb
         44P0xLhj/RrtdjsR/3MYwX5WkX4lnYl1z9R2Km91th2hYcmd5YxT6xnIhi3ULQv9LlBf
         hV3hJZCoacPcSlmEl5BNtJpAPA+Ix4wKPlAgotNJxUhqlVMBlh8tTTclNPsIq3afAjO/
         SImUilo/HtDdbLEExK7fqSRKYRwGL2EY6MPfae9bBNDx9Hqn7w61I/nGwVO1xStyokto
         WMiR39o+8S1T2ST+nrRs1Xi79efH/FwBiv9tokcAy1HfWpzKL9Id+gb4x1ZHUroHaiDa
         crJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764782726; x=1765387526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cqj8tfUGUnFRacbGDoJX9RLnVpHR5PEeHJuSOrLWuQ4=;
        b=nBxA0+/oXERuQPPYaVlFAFUnVfyUWpuXKJtSlNuFysyGCazPkGOaKik5+ppdvV8coS
         e3RJDE2N9ydUf0snZlP5m8IGNdbI8yJPWeqAYjkNL3fxcb9lv6xG49v6nNfYlbypsHgh
         OxYGRs4kJKQY9lJxk/b/8zfxJkfMghRUvGDfVDdlmGeJuIkWGOauUtzVFUEchUmWrxkz
         fTGKmvUMOFEuy9Cj5AzzsLmkc4r6s65L4lkRflbLIDT1t7iqCyhqx1g98RRL92qXle9Q
         g/8X1rGe5KBMr2D4F12+ytzATHwosDMzsqErJehsHvhagIbevi1XN4wCEZOJZlWP9QQW
         dSfA==
X-Forwarded-Encrypted: i=1; AJvYcCUVwJSJq8WIxIooT9i6T2Pw7ogqPTpONjkNKNcgHB8/i/gbP7AcRH7aHQJwT8iNO835ECo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv9p47NlwTi7FZ/g4Olk2a0oE2+Don9X1aoiknpY2TCMNqyuET
	R+3Bhy8E5y0IujNYSdgeWoQHjUBX975MVgq25gDTcvLTLkYh495O96uTW0WeDk70sWo=
X-Gm-Gg: ASbGncv7GBDD50O9FjN+40RQIbQBq9pWv5NQUVfo/+l6qknC1rFHrKUJwmKAg7Yo55l
	c6nx/ZWlG7OKzT/pbJRJ+0lWp7FRFQ2dE07zuJegQ9xHLtUgg6fy+D8TGzMW8z84o6VAR5Ovy+j
	4kNqiv8EFrZWYuRkQs0luNrJ7Pfxc1f1utRBXHAcZbUySNkB7EfhQ6F8vde1d7Yhn2gVrost50B
	WuqvBbFbJrj/BZ8QkOEQVfTbL+ThHuxcs1Mrd+PV7jHBtYi5tjVRaqd6P973T4wuHnLAnUiK41G
	PoutnWrbftkc/T/2QA/qUmO1RUrCisAQpkXlXsCl2f6Am4lFDAnEJ4jYg1hRGT6AHlapboNn2aQ
	sv7AUotX1VTHgCQkWEzV/w0UB6N+JYfWZZH4nHn7TWt4EipvrsbDbprE2I+LCTd9+DYBhBMt9mu
	zaWVm3CoddguM4bWi6B8rw
X-Google-Smtp-Source: AGHT+IEj7ZlMVNAKUdrjaY/3GBeXtLDCTgtcha8yiU2InhgEdRjJE8KlYZssUqB4vK/1rSlaM7FdcQ==
X-Received: by 2002:a05:6a00:c89:b0:770:fd32:f365 with SMTP id d2e1a72fcca58-7e00fbcf100mr3450321b3a.25.1764782726388;
        Wed, 03 Dec 2025 09:25:26 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e6e6e06sm20796471b3a.43.2025.12.03.09.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 09:25:26 -0800 (PST)
Date: Wed, 3 Dec 2025 09:25:24 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, ajones@ventanamicro.com, atishp@atishpatra.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 1/4] RISC-V: KVM: Allow zicfiss/zicfilp exts for Guest/VM
Message-ID: <aTByhBmo_eOJnzZU@debug.ba.rivosinc.com>
References: <cover.1764509485.git.zhouquan@iscas.ac.cn>
 <103e156ea1f2201db52034e370a907f46edafb83.1764509485.git.zhouquan@iscas.ac.cn>
 <aTBxIBZ0Jwn67OcV@debug.ba.rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aTBxIBZ0Jwn67OcV@debug.ba.rivosinc.com>

On Wed, Dec 03, 2025 at 09:19:28AM -0800, Deepak Gupta wrote:
>On Mon, Dec 01, 2025 at 09:28:25AM +0800, zhouquan@iscas.ac.cn wrote:
>>From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>>Extend the KVM ISA extension ONE_REG interface to allow KVM user
>>space to detect and enable zicfiss/zicfilp exts for Guest/VM,
>>the rules defined in the spec [1] are as follows:
>>---
>>1) Zicfiss extension introduces the SSE field (bit 3) in henvcfg.
>>If the SSE field is set to 1, the Zicfiss extension is activated
>>in VS-mode. When the SSE field is 0, the Zicfiss extension remains
>>inactive in VS-mode.
>>
>>2) Zicfilp extension introduces the LPE field (bit 2) in henvcfg.
>>When the LPE field is set to 1, the Zicfilp extension is enabled
>>in VS-mode. When the LPE field is 0, the Zicfilp extension is not
>>enabled in VS-mode.
>>
>>[1] - https://github.com/riscv/riscv-cfi
>>
>>Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>>---
>>arch/riscv/include/uapi/asm/kvm.h | 2 ++
>>arch/riscv/kvm/vcpu.c             | 6 ++++++
>>arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>>3 files changed, 10 insertions(+)
>>
>>diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
>>index 759a4852c09a..7ca087848a43 100644
>>--- a/arch/riscv/include/uapi/asm/kvm.h
>>+++ b/arch/riscv/include/uapi/asm/kvm.h
>>@@ -190,6 +190,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>>	KVM_RISCV_ISA_EXT_ZFBFMIN,
>>	KVM_RISCV_ISA_EXT_ZVFBFMIN,
>>	KVM_RISCV_ISA_EXT_ZVFBFWMA,
>>+	KVM_RISCV_ISA_EXT_ZICFILP,
>>+	KVM_RISCV_ISA_EXT_ZICFISS,
>>	KVM_RISCV_ISA_EXT_MAX,
>>};
>>
>>diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>>index 5ce35aba6069..098d77f9a886 100644
>>--- a/arch/riscv/kvm/vcpu.c
>>+++ b/arch/riscv/kvm/vcpu.c
>>@@ -557,6 +557,12 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
>>	if (riscv_isa_extension_available(isa, ZICBOZ))
>>		cfg->henvcfg |= ENVCFG_CBZE;
>>
>>+	if (riscv_isa_extension_available(isa, ZICFILP))
>>+		cfg->henvcfg |= ENVCFG_LPE;
>
>Blindly enabling landing pad enforcement on guest kernel will lead to issues
>(a guest kernel might not be ready and compiled with landing pad enforcement).
>It must be done via a SSE interface where enable is requested by guest kernel.
>
>>+
>>+	if (riscv_isa_extension_available(isa, ZICFISS))
>>+		cfg->henvcfg |= ENVCFG_SSE;
>
>Same comment on shadow stack enable. While usually shadow stack usage is optin
>where explicityl sspush/sspopchk/ssamoswap has to be part of codegen to use the
>extension and not modifying existing instruction behavior (like zicfilp does on
>`jalr`)
>There is a situaion during early boot of kernel where shadow stack permissions
>for init shadow stack might not have been configured (or satp == BARE at that
>time), in those cases `sspush/sspopchk` in guest kernel will start faulting.
>
>So enabling shadow stack should also be done via SSE interface.

I meant FWFT (not SSE), sorry.

>
>That's how user cfi patchsets also do.
>
>>+
>>	if (riscv_isa_extension_available(isa, SVADU) &&
>>	    !riscv_isa_extension_available(isa, SVADE))
>>		cfg->henvcfg |= ENVCFG_ADUE;
>>diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
>>index 865dae903aa0..3d05a4bafd9b 100644
>>--- a/arch/riscv/kvm/vcpu_onereg.c
>>+++ b/arch/riscv/kvm/vcpu_onereg.c
>>@@ -72,6 +72,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
>>	KVM_ISA_EXT_ARR(ZICBOP),
>>	KVM_ISA_EXT_ARR(ZICBOZ),
>>	KVM_ISA_EXT_ARR(ZICCRSE),
>>+	KVM_ISA_EXT_ARR(ZICFILP),
>>+	KVM_ISA_EXT_ARR(ZICFISS),
>>	KVM_ISA_EXT_ARR(ZICNTR),
>>	KVM_ISA_EXT_ARR(ZICOND),
>>	KVM_ISA_EXT_ARR(ZICSR),
>>-- 
>>2.34.1
>>
>>

