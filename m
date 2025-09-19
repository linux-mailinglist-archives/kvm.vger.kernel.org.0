Return-Path: <kvm+bounces-58224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4606AB8B750
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:14:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 041711C244B8
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF092C3278;
	Fri, 19 Sep 2025 22:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CVNFSSzb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A6C36B
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758320046; cv=none; b=s/76NMpL+s8gOxM/xp6+qv05dfXBuqQIqwXaTxW6rSE80J1aCpkPo34lyJ6p79AYwuftw749Qs8xp5YS7MHQeXcguybJM/GPfYsnc6WcKRKLydxnXyOOlFcshYNp/2x5f05jZPhAYKtnMIbIHR88Hyp5KVnyViFjSB/rQkP8m5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758320046; c=relaxed/simple;
	bh=W5b00jG9cpnQdZZ0siUFuEik0xREa3J4El0y3yw8L1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWwODs22mJje9ICaRicHvTx4n1G0DQbi1RTh/dy+jzFMjcz038lh7lg/RWMzH9i3VKVkl5XuiujtR3yPTv46X3b8k0r/9CyWWeIkXl0c5CWzisBf+DsstmP7vCeqqS7cJONGDa3NpK4Nje8gdRCZDlkmGY5U55aN1YbDhs0f5zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CVNFSSzb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758320042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Su/V4OUywtko7FbjZzoOIfFvGsKNTgMz+rLEULE8lk=;
	b=CVNFSSzbsSQjRgl/gDGDwdVo/hl9NLsDw0foMvO1Yahr2X53ZxZdrVMwG2XEp1bgLloL4t
	iJGyy+ExnIjG4IgM4FoXtVlGcB+CqPKkdNkwFm5alSkcxZPSKMWVsZ7krNWmFNaUG8D5F0
	cQNNHtLDgx8X7R7mLni9My10pWIDWSs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-PmMfWreKM_meOWvihV2kGw-1; Fri, 19 Sep 2025 18:14:01 -0400
X-MC-Unique: PmMfWreKM_meOWvihV2kGw-1
X-Mimecast-MFC-AGG-ID: PmMfWreKM_meOWvihV2kGw_1758320040
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so25530785e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758320040; x=1758924840;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Su/V4OUywtko7FbjZzoOIfFvGsKNTgMz+rLEULE8lk=;
        b=ppUhFWpr0jWMMp63+V9bjXCQW5KhmMhO/4n0JPBDYg+a3dB8/5zV332Hos3NIwz0ER
         2cMgbBf6uhSR6CxBclzLsmwDT1NbBfB+Zsucx7gwO3WLOMqeqhCkdoviLxWB8Jfk0VnW
         yjt50AobE0+t7VZGK1u4FdYRpGkonLZtM7rw+2rqyca6idNUVcDzrDLRe6PpnP0o5npc
         KuYJ3mH7ok4Txkb4w2fYEE/0HjFERd00mLht2ujRL2l/gkL8lW2C/CIqwRUlGmwtQ+md
         7fQxeVTvDeCB0QMUmUIcNtAZsSVtI6JuU+qyjB9Rw72s8oY0ZGdNhspISD6+GAzD2/BU
         getA==
X-Forwarded-Encrypted: i=1; AJvYcCVJkNwwTbR1sdBtDscndD2PYUIg8tIfjoqzoTjDXcx5R6ECd7y0VuokB6qc1gduaNinFKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYMsjglYPWBN8kSfNGDRDpEfsyV0OfbQiDc+GaXXJkji1ClIOD
	aqSi/wkt6n0Yaec9irT8EB39l7sVcys7lG1JdnJYsdvWaGV/kOBFNCIH2qbH/1tpp5SaoVtKQ+6
	hAoPnT0RQFwlZA6YWdLewkheKzIF791F1YQGUoL75BBhPi5OMtpLnHYcijoAlexujV44u13MxpR
	w77WOviNcYd1hL4EsZSmacwgMCg5OA
X-Gm-Gg: ASbGncsy/3FGu0PT6X+23pg1lnRw7hAK0nrzad6kUKbNy0WDfTT8fAUL3hFp479YGsI
	f8B6d2nIvgIEd5EYZ2NK8hBCaqdTvt2ERq/6JuwLMRG36yG8F8vf9ppXwUdHOnQTPcUcTHRoE7y
	aIA0vTNvkg3mhzS512O13/qeSaVhvjRpLXaKLBbUVFK0qly2ilKQCu79YNcittfOSKtrMc2Saqs
	93CSR72ikfZNq5wN8O1D4BA
X-Received: by 2002:a05:6000:186f:b0:3d3:b30:4cf2 with SMTP id ffacd0b85a97d-3ee194eed65mr4271619f8f.19.1758320040187;
        Fri, 19 Sep 2025 15:14:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP9qB7G3gKgYKe7whmDc86HxwaJfsP7eYHbgCEprc/xA4t463cWDmhbzW7+5Jy1Sfx+cvbbDp17osk3TiEixQ=
X-Received: by 2002:a05:6000:186f:b0:3d3:b30:4cf2 with SMTP id
 ffacd0b85a97d-3ee194eed65mr4271606f8f.19.1758320039753; Fri, 19 Sep 2025
 15:13:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f388d4de-4a16-4ba2-80ff-5aa9797d89ca@intel.com>
In-Reply-To: <f388d4de-4a16-4ba2-80ff-5aa9797d89ca@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 20 Sep 2025 00:13:47 +0200
X-Gm-Features: AS18NWApfhVRHYyiyFGPoqBE1E6ncVDteleEI1Lst5Z8fmSDcoO7aChQu8oE5qc
Message-ID: <CABgObfaHp9bH783Kdwm_tMBHZk5zWCxD7R+RroB_Q_o5NWBVZg@mail.gmail.com>
Subject: Re: [Discussion] x86: Guest Support for APX
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 19, 2025, 22:16 Chang S. Bae <chang.seok.bae@intel.com> wrote:
> Dear KVM maintainers,
>
> Since APX introduces new general-purpose registers (GPRs), legacy
> instructions are extended to access them, which may lead to associated
> VM exits. For example, MOV may now reference these registers in MMIO
> operations for emulated devices. The spec [3] lists other instructions
> that may similarly exit.

You're right that gets very complicated quickly, while most cases of
MMIO emulation are for legacy devices and R16-R31 are unlikely to
appear in MMIO instructions for these legacy devices.

However, at least MOVs should be extended to support APX registers as
source or destination operands, and there should also be support for
base and index in the addresses. This means you have to parse REX2,
but EVEX shouldn't be needed as these instructions are in "legacy map
0" (aka one-byte).

At this point, singling out MOVs is not useful and you might as well
implement REX2 for all instructions.  EVEX adds a lot of extra cases
including three operand integer instructions and no flag update, but
REX2 is relatively simple.

> In summary, we'd like to clarify:
>
>    * Should we target complete emulation coverage for all APX-induced
>      exits (from the start)?
>
>    * Or is a narrower scope (e.g., only MOV) practically a considerable
>      option, given the limited likelihood of other exits?

See above. I hope it answers both questions.

>    * Alternatively, can we even consider a pragmatic path like MOVDIR* --
>      supporting only when practically useful?

I think pragmatic is fine, but in some cases too restrictive makes it
harder to track what is implemented and what isn't. Again, see the
above comment about implementing REX2 fully while limiting EVEX
support to the minimum (or hopefully leaving it out altogether).

> [4] The MOVDIR64 opcode is "66 0F 38 F8 ..." but opcode_table[] in
>      emulate.c looks currently missing it:
>
>          /* 0x60 - 0x67 */
>          I(ImplicitOps | Stack | No64, em_pusha),
>          I(ImplicitOps | Stack | No64, em_popa),
>          N, MD(ModRM, &mode_dual_63),
>          N, N, N, N,

0x66 is a prefix so you have to look at F8 in the table for the 0F 38
three-byte opcodes (opcode_map_0f_38) and add a new
three_byte_0f_38_f8 table.

MOVDIR* and many other instructions are not implemented because they
are pretty much never used with emulated (legacy) MMIO such as VGA
framebuffers. By the way MOVDIR* is not a REX2-accepted instruction,
so you would have to implement EVEX in order to support it for APX
registers.

Paolo


