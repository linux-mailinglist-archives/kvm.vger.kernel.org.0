Return-Path: <kvm+bounces-57929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEFAB81E85
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B3CC7B8177
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A60309F08;
	Wed, 17 Sep 2025 21:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fRT8zgYp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D63081B5
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758143719; cv=none; b=UGPXiNjX006JTofkbS39PNBRAmP7l5/pIWLlT2uFdfHJ6DXoIkP7xwmi2xj5wjYOo6IRZQC6ojXD2L2v6vJjTgSXGbVa3wW0LLs4RKDybk2E8bYcqljTobB5NTjDRNUWEzl4oNyHS+ubxLRsLRbMbaZh51XNZRQoS0KuFKxkRbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758143719; c=relaxed/simple;
	bh=aOsBVV1Tpb4mhK2PfFogLLFA+uKbhmaEQcibYeJBiMc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YL6cu9lG3uAwLUk8hreQiR1GrXEVzXDEthqdDgTcO3+RUQQCRkHSodU4rdj2Aomwwc/0UQ8ZDrr3lYM+q3SaxDGI6Gv0M9OUKtq7s2TFtRSzpmLs1kfRI88yoRORLAC2o8l3YFeoH9HhQHoNY5Jcq8soxxh/9mnkLuh9OG0L7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fRT8zgYp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4f87c691a7so271948a12.3
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 14:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758143717; x=1758748517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf/y0HmWPOZ3dErMq/oUtcRItkhIQW6aNr62qVpQuQM=;
        b=fRT8zgYpLgCO77DcdRAFmm6LMK8e+40lsvfGOFFM49bwqpaQDpb263GPYNnoD6fwcn
         yH+7uOA9paLVsq6oljCxhOp2sBRvf+8te+AJHfr586nBzU0A5mlr3ezGqzFJQlhdK2TM
         OuSoJZ7AVIkhNp/sVI4NzZqexVGAhNeo3Jzq/b1taiuqa5gbZzA8/D05EXjqfa6bIlCr
         /ayi5vSBx9nVXSfqjAdxsuG9gGSqiOIflPi/i0i/l+WGFfmJbrgZRJt5BkX6YvdF1SJa
         O+SRk/eallZVUTntgulkpNZM0otK4aBuct+PNQOFGQ1c64tXzyBPEyt5otst5wTQXoKl
         yGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758143717; x=1758748517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf/y0HmWPOZ3dErMq/oUtcRItkhIQW6aNr62qVpQuQM=;
        b=ES3XYpC6fT6khl9y6XGW+FAbe/W0W6x4BIj3h6XXR0ypGklS6FPfQOkjrXCAHsZrnh
         KWVxR+eQNVz4Vkku7YKZW5EDqtTjJxlpXANZySA/jHtPDbVRCzL5foVufo/n5RHd52M2
         4AzzywT9g19APxM1rCtxoUfalDRi6lVOMnirvnbNUQ1WsHD39LyC/YnhlpcI+mvhO795
         do7TMyfzh64s0HaweeSd3ekDugRU3V35RJGCPX7hrPXjSkM3MpZFWKVYckM1RWpgyJcD
         +MrLRLulr8C35Zjflu2HoaMK3V2uEmc2IhvjakoqHvCy2nxpBRfWKvBiUrXmZAXgEAB0
         OAIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9k6i9A+DSMWP14fe7N+yObWrY/vZWiP9CJpOSHN8ynskSUnWKq7xYsLszdZn5Q5RjamU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKogxD84skegL9pOUzuTRqwjUEO91gUkPw8KFblQyFM7EeAV1S
	beg/GNbRJkW8PmT5gWqqQ3QtFLRjgzufUeqjtbQ/P++iRaz0UNHme78bsRPby18lttuFXpE0mA5
	jJQs2yg==
X-Google-Smtp-Source: AGHT+IEx2ToSGxWphNk2FKfxD2yst1MtFncBvHa8DVnpZZzTslJr/R25DqHaOFbX/k7CmOZUhV/Ax0gsm+0=
X-Received: from pjbst3.prod.google.com ([2002:a17:90b:1fc3:b0:330:49f5:c0b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d89:b0:252:525c:2c2c
 with SMTP id adf61e73a8af0-27a9f267877mr5474946637.14.1758143717363; Wed, 17
 Sep 2025 14:15:17 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:15:15 -0700
In-Reply-To: <aMpuaVeaVQr3ajvB@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-19-seanjc@google.com>
 <aMpuaVeaVQr3ajvB@intel.com>
Message-ID: <aMsk43I7UkGbmL88@google.com>
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 17, 2025, Chao Gao wrote:
> On Fri, Sep 12, 2025 at 04:22:56PM -0700, Sean Christopherson wrote:
> >From: Yang Weijiang <weijiang.yang@intel.com>
> >
> >Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
> >affected by Shadow Stacks and/or Indirect Branch Tracking when said
> >features are enabled in the guest, as fully emulating CET would require
> >significant complexity for no practical benefit (KVM shouldn't need to
> >emulate branch instructions on modern hosts).  Simply doing nothing isn't
> >an option as that would allow a malicious entity to subvert CET
> >protections via the emulator.
> >
> >Note!  On far transfers, do NOT consult the current privilege level and
> >instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
> >Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
> >can be in play for the target privilege level, i.e. checking the current
> >privilege could get a false negative, and KVM doesn't know the target
> >privilege level until emulation gets under way.
> 
> I modified KUT's cet.c to verify that near jumps, near returns, and far
> transfers (e.g., IRET) trigger the emulation failure logic added by this
> patch when guests enable Shadow Stack or IBT.
> 
> I found only one minor issue: near return instructions were not tagged with
> ShadowStack.

Heh, I had just found this through inspection.

> The following diff fixes this issue:
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index e4be54a677b0..b1c9816bd5c6 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4326,8 +4326,8 @@ static const struct opcode opcode_table[256] = {
> 	X8(I(DstReg | SrcImm64 | Mov, em_mov)),
> 	/* 0xC0 - 0xC7 */
> 	G(ByteOp | Src2ImmByte, group2), G(Src2ImmByte, group2),
> -	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch, em_ret_near_imm),
> -	I(ImplicitOps | NearBranch | IsBranch, em_ret),
> +	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch | ShadowStack, em_ret_near_imm),
> +	I(ImplicitOps | NearBranch | IsBranch | ShadowStack, em_ret),

Tangentially directly related to this bug, I think we should manual annotation
where possible.  I don't see an easy way to do that for ShadowStack, but for IBT
we can use IsBranch, NearBranch and the SrcXXX operance to detect IBT-affected
instructions.  It's obviously more complex, but programmatically detecting
indirect branches should be less error prone.  I'll do so in the next version.

> 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2ES, em_lseg),
> 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
> 	G(ByteOp, group11), G(0, group11),
> 
> 
> And for reference, below are the changes I made to KUT's cet.c

I now have a more comprehensive set of testcases, and it can be upstreamed
(relies on KVM's default behavior of injecting #UD at CPL==3 on failed emulation).

