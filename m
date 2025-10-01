Return-Path: <kvm+bounces-59241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1C0BAF8F7
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67D3F1940C42
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012BF27B4F7;
	Wed,  1 Oct 2025 08:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="IVczpYBv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CEA279782
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306371; cv=none; b=dQEoT8brcbJz9KXNwUaWWhujIe8Nmk/pyzyWSGcFYYm8vJwMzFr5N2eCj9tvCPEMkqBZfM2UvAjLxYmg6HwrtY87XsqDxXnjUou+tiXX9zA+d+8YAZ/3WkiM3fRxNwkTYXXTkfRcb9C21fdN2syZF7+MOx5ujhWIRzJ7hQH+Lpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306371; c=relaxed/simple;
	bh=/ykmk2fkekJndu1S7aDPXYfJRdmiCohbXJjZADcy7R4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+vV3LJIQfbyOIrmaxBOc/THV05vDEV8ETpSZ3dHdS0gff7FRWZ5AIVakR0Pzs4kr8OpCzv7Fq0RBZim9Ao2VwrCbqLb1rEB9gWRq8KWZ8OrCNPAL4OczN+SeePJ/jx1CK81mEVh+LpXQBWoP+MerTB0n0RZSW/WOARlfL0Bsmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=IVczpYBv; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-634beb1a884so1079897a12.3
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1759306366; x=1759911166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wta+A7F956rwxD04gcs4FdCT+k6OzI/an4+vTIk+CQ=;
        b=IVczpYBv2qLCeWjInXrrmtVuhT8dPmMMc43wBtgblij+igRlqvbOk8RWyVYd6YXgAI
         l1Cn5c/nQNJspUmcT1yqY8/XFGPQPMeE4mFBTHelL1Hf9rdt0EctoG7v2djXU34NhIBM
         XsRGpGswui+f2xMtXvqNTi0b6ikh9VYaNl0hFPnyHE/VVRgFgE+tU0HhBM6mXrrAcwZA
         80365TNXfzZCHJF3hpDU4vMg7+Zb06avzz62QpmFTbUSrXp5c/ehSLwKbiSUSJpGQz1k
         d/3JpvGco+2DsAjnJ/SRpdYeHnIal82pq12B/mHTFbPxrjMcHNoFjPZkTpnLNDrZ/6uX
         IFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306366; x=1759911166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wta+A7F956rwxD04gcs4FdCT+k6OzI/an4+vTIk+CQ=;
        b=fPHLJJ7wF/Lzg3yapyck7dQXUq2e3HluvhK6r7RjbyRty5e+g3PH59wRmO8Ic4iJAe
         yIh3baPDb5HdT27xvYsjnDdqiyeyN1HHajbCSrTDOQW8g7HxmFbdg7CZ+xIvGeuVQmDZ
         pNJFIdc09M/1JczIiPfew1RiM/1By7vf5dBxNSViVmWGekV3uO8OmjC/TxJu37558cpJ
         zWB8geFWsG2OIF68A+Z55YgcO1HdRnojVbUUZ/eQruPbGXz1zIvlUdB0euEij1oPoPIC
         VCPW3VCyzKw4kuD1i3/yBmLXugVyX/UtIuxptO4Av8dZMBhPPYxfd981DdJOYGQp3Yfh
         64IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK6Bz0bfk9XSU919lfPzDGG2BbFR0pQw9cDE73wPHy//9IJjG9B1gDkbo2xluGxLC3bo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrZcYFtJGky0pOy8PciD8xDwA6wJi0SffpWMHMd2MqCM/93JSv
	zee5zvx+DrcGi5SN5Mz+fe0SY7FYJelMQucmSVOt74uVJ6VDEPWVcEuKgKgw5C1vSHULf9sih7e
	EDcGT4gHi732OtO1FO/KC2YZ1hsJVYfiaJ4MPObYW4A==
X-Gm-Gg: ASbGncsJzDjMkZ36LrvAcdbzgeSGcxkhVnu4O0fhQu3AXPs/cputuUXYuJO04xiBEoD
	OWS+0N1NLV9+2Q62kdQWH5pmXrFV3heFtcjds80J1V1MSmMZ0R4q8bwPDgrbv6edP8qJh7IR52J
	sbfqf3Jj5Ya8af+4dUEMW0547t+/ej6ut7/jR2xLvqwcFjHWQVhJoz4EaGawS2U0dnR+Y6AIYcM
	XcUU7EddDUyJdrG0cpTgIjACBol/9s=
X-Google-Smtp-Source: AGHT+IHxoxX3gNePX92jgrf3o5NGrsKnxP1/TaoEMmDFGG51CJYv4H8WcqjR9qqpRa0ecLRvIjN9Sz2BUF6bF5jNxvU=
X-Received: by 2002:a05:6402:354f:b0:62f:935e:5f56 with SMTP id
 4fb4d7f45d1cf-63678e7ba35mr1645295a12.7.1759306366111; Wed, 01 Oct 2025
 01:12:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com> <20250930012102.iayl5otar3lim23i@desk>
In-Reply-To: <20250930012102.iayl5otar3lim23i@desk>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Wed, 1 Oct 2025 10:12:33 +0200
X-Gm-Features: AS18NWDjsMAcIoTBRAqX3j_rJS61kSImXarv5R47JeNrqoZozENyZbt4z5E7ip0
Message-ID: <CAMGffEmJM+NZVM4HaXA6jmdjB1C6nPNxmLizD9P-3CojfVLsXw@mail.gmail.com>
Subject: Re: [PATCH 0/2] VMSCAPE optimization for BHI variant
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, asit.k.mallick@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tao1.zhang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2025 at 3:22=E2=80=AFAM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Mon, Sep 29, 2025 at 07:12:03AM +0200, Jack Wang wrote:
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> >
> > Hi Pawan,
> >
> > Thx for the patches, I tested them on our Intel SierraForest machine wi=
th
> > fio 4k randread/randwrite from guest, qemu virtio-blk, noticed nice
> > performance improvement comparing to the default IBPB before exit to
> > userspace mitigation. eg with default IBPB mitigation fio gets 204k IOP=
S,
> > with this new Clear BHB before exit to userspace gets 323k IOPS.
>
> Thanks for sharing the results.
>
> I realized the LFENCE in the clear_bhb_long_loop() is not required. The
> ring3 transition after the loop should be serializing anyways. Below patc=
h
> gets rid of that LFENCE. It should give some performance boost as well.
>
> --- 8< ---
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Subject: [PATCH] x86/vmscape: Remove LFENCE from BHB clearing long loop
>
> Long loop is used to clear the branch history when switching from a guest
> to host userspace. The LFENCE barrier is not required as ring transition
> itself acts as a barrier.
>
> Move the prologue, LFENCE and epilogue out of __CLEAR_BHB_LOOP macro to
> allow skipping the LFENCE in the long loop variant. Rename the long loop
> function to clear_bhb_long_loop_no_barrier() to reflect the change.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Yes, I can confirm with this change on top, I get almost same
performance as vmscape=3Doff for fio test.

Thx for pushing the performance further.
> ---
>  arch/x86/entry/entry_64.S            | 32 +++++++++++++++++-----------
>  arch/x86/include/asm/entry-common.h  |  2 +-
>  arch/x86/include/asm/nospec-branch.h |  4 ++--
>  3 files changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index f5f62af080d8..bb456a3c652e 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1525,10 +1525,6 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>   * Target Selection, rather than taking the slowpath via its_return_thun=
k.
>   */
>  .macro __CLEAR_BHB_LOOP outer_loop_count:req, inner_loop_count:req
> -       ANNOTATE_NOENDBR
> -       push    %rbp
> -       mov     %rsp, %rbp
> -
>         movl    $\outer_loop_count, %ecx
>         ANNOTATE_INTRA_FUNCTION_CALL
>         call    1f
> @@ -1560,10 +1556,7 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>         jnz     1b
>  .Lret2_\@:
>         RET
> -5:     lfence
> -
> -       pop     %rbp
> -       RET
> +5:
>  .endm
>
>  /*
> @@ -1573,7 +1566,15 @@ SYM_CODE_END(rewind_stack_and_make_dead)
>   * setting BHI_DIS_S for the guests.
>   */
>  SYM_FUNC_START(clear_bhb_loop)
> +       ANNOTATE_NOENDBR
> +       push    %rbp
> +       mov     %rsp, %rbp
> +
>         __CLEAR_BHB_LOOP 5, 5
> +
> +       lfence
> +       pop     %rbp
> +       RET
>  SYM_FUNC_END(clear_bhb_loop)
>  EXPORT_SYMBOL_GPL(clear_bhb_loop)
>  STACK_FRAME_NON_STANDARD(clear_bhb_loop)
> @@ -1584,8 +1585,15 @@ STACK_FRAME_NON_STANDARD(clear_bhb_loop)
>   * protects the kernel, but to mitigate the guest influence on the host
>   * userspace either IBPB or this sequence should be used. See VMSCAPE bu=
g.
>   */
> -SYM_FUNC_START(clear_bhb_long_loop)
> +SYM_FUNC_START(clear_bhb_long_loop_no_barrier)
> +       ANNOTATE_NOENDBR
> +       push    %rbp
> +       mov     %rsp, %rbp
> +
>         __CLEAR_BHB_LOOP 12, 7
> -SYM_FUNC_END(clear_bhb_long_loop)
> -EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
> -STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)
> +
> +       pop     %rbp
> +       RET
> +SYM_FUNC_END(clear_bhb_long_loop_no_barrier)
> +EXPORT_SYMBOL_GPL(clear_bhb_long_loop_no_barrier)
> +STACK_FRAME_NON_STANDARD(clear_bhb_long_loop_no_barrier)
> diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/e=
ntry-common.h
> index b7b9af1b6413..c70454bdd0e3 100644
> --- a/arch/x86/include/asm/entry-common.h
> +++ b/arch/x86/include/asm/entry-common.h
> @@ -98,7 +98,7 @@ static inline void arch_exit_to_user_mode_prepare(struc=
t pt_regs *regs,
>                 if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
>                         indirect_branch_prediction_barrier();
>                 else if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_T=
O_USER))
> -                       clear_bhb_long_loop();
> +                       clear_bhb_long_loop_no_barrier();
>
>                 this_cpu_write(x86_pred_flush_pending, false);
>         }
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/=
nospec-branch.h
> index 32d52f32a5e7..151f5de1a430 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -388,9 +388,9 @@ extern void write_ibpb(void);
>
>  #ifdef CONFIG_X86_64
>  extern void clear_bhb_loop(void);
> -extern void clear_bhb_long_loop(void);
> +extern void clear_bhb_long_loop_no_barrier(void);
>  #else
> -static inline void clear_bhb_long_loop(void) {}
> +static inline void clear_bhb_long_loop_no_barrier(void) {}
>  #endif
>
>  extern void (*x86_return_thunk)(void);

