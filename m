Return-Path: <kvm+bounces-36314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B12EA19C04
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52DA63ABCCA
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617891F5F6;
	Thu, 23 Jan 2025 00:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tyiE09Wg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13191E495
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737593894; cv=none; b=lA0K6SeIQS/llKQqU7OZ0MtZmEgWZ7YhZb9L28ia1ptxXE/EwcwZC5WS+Rja5Ak6T+9NIllcX/2Sf+m7q4KbRN2oQfn2W+pnhlHcu/HsF/s1lmkcGsn1cOCiv04s5fCV/EYLAxmvD+EhXgITV4J+OzbtVKkSJIo9aJiqH+r2jlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737593894; c=relaxed/simple;
	bh=HM+jk/K8j/HxabpEKFcS792uzyrHixNC9CrL0OrqjsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBxeqxyGhQf5jL9kYAFFRsjU905BlgeuSiTQOPyRbT578j+kVSApqTBJQnop41xINRileZU2UTCGOu1nF6fdxTDy8dp3/WcTnrOgNydc262OL/QAujKQGyyc81X5j+FwOuiA/lUgAOZT1SlGLvOfRAMb1Ba24RShMgcwwM9jRfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tyiE09Wg; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5187f0b893dso129425e0c.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737593892; x=1738198692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qRv6cRxKS2UTaw+qkbA7NUKi+xp+j7RdbWUYMX53PJs=;
        b=tyiE09WgKyPpP5vZqv/Eq3fsVfWlF+wANG8o2iDLX7NNKlYkNjsrQwIWWEj3e8Vu6n
         fBYCT3uK19E0ZRjry8M6T/pdkoUDG+LPw1OUcZa/8tQK05SacfmjvCakhqNGJeVWMT60
         MZYKFSaNq68ah2xxvcAkKD1lAnvrG5hxy5ecxvf+Lm+yzitgBNJsT9wzKfTrgYuhyWCJ
         aO3VPJbSYTFI0Djc8YEYVMm7nw47M5i20BoHmqehJt2Za38qWzqXLEn3NVwpUWiCjyLD
         7n/0ZD11KUlRxShs1ij9AJfuD9I+uGtG//MFDn1yHCQxvjpY5i2JQD7uOn9870DZ9DDt
         U8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737593892; x=1738198692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRv6cRxKS2UTaw+qkbA7NUKi+xp+j7RdbWUYMX53PJs=;
        b=QLTgLShl3JxOSYAOtlOHO9FVtFI5xLrrg9oUB56M6C2qDgk2OECrBFRO/1FWCUnzT/
         wS2JHOMn511yhWGq5CGtIUT1FDrEQl8zhZdkVfA06d9zbHMAC++zYRWF/i67hI3cVCqU
         rKwrhsDNUIxjDXyD3MTwFpIYbmg0IGPDjr5A3JacESu63ISBXVh1vSaDlOI+CyCfzx8O
         sqF29XhFSz9FgdxTMFE4Jqie+dhIkwAT8bQKFX8lVRKXHo8XmfIyoZBBqA9G1PDW0XD+
         PNad7CcNwVybbYAQEgithqsV3X6sBXj1zAiF4Jai69UA7EzuoltlprpxJxq2FLs4Mvid
         bmKg==
X-Forwarded-Encrypted: i=1; AJvYcCXoBu6Mp84cnPStrVw0TNhfK0aFwQ5oaa6ocr7q5DAGaQeWOTxUsbqhB2+uq2fAwquX9mM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG2HKp7y2Eh8Y5EVQ+q3TyXuTVtRowRXsnltzs8JP1ZedwtC02
	A9kvppe3RE+XZlTi3o4dUX2f0TvAPocjy7WSvywkrDbxqhGiiMTURxyDmPuvEd5dl2PrLzM1qr/
	qijP4hOqGN3S4fJiEmWaMsB2O/gdt+rIYtwFV
X-Gm-Gg: ASbGncs3A0ER5VRxr+i3b/DnnMmZwEQYVume0CW+MLg8+76nL3eeM/tUqrt+FNauoFQ
	SFMEf1PMTNkIGX7GVs7HgoBeUE/DEwW5uZPgbxB2Lniv3plhif+ZCqe7XQqK3pVrLvCCYDaNJWC
	upSR8dqYHGgd+GpOHXLTc=
X-Google-Smtp-Source: AGHT+IFN/8L5ipl8LSAhDKsgsEYibVBuI1C2k3WcLscNtSHf62UJxx+ON7C9d8Euz3bZj5y8KmAaGBYOHhTnUuAnnhE=
X-Received: by 2002:a05:6122:9008:b0:51b:8949:c996 with SMTP id
 71dfb90a1353d-51d5b351af7mr20095541e0c.9.1737593891512; Wed, 22 Jan 2025
 16:58:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122001329.647970-1-kevinloughlin@google.com>
 <20250122013438.731416-1-kevinloughlin@google.com> <20250122013438.731416-2-kevinloughlin@google.com>
 <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
 <d2dce9d8-b79e-7d83-15a5-68889b140229@amd.com> <f98160b0-4f8b-41ab-b555-8e9de83c8552@intel.com>
 <CAGdbjm+syon_W0W_oEiDJBKu4s5q9JS9cKyPmPoqDAzeyMJf3Q@mail.gmail.com> <3dd183fa-df95-487e-a2e9-73579fa160be@intel.com>
In-Reply-To: <3dd183fa-df95-487e-a2e9-73579fa160be@intel.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 22 Jan 2025 16:58:00 -0800
X-Gm-Features: AWEUYZmARqPbpTHL5mkkhsizz3tgW_45BdkL-5FCZi574ZLsdbCiQdVfxkS7IJ0
Message-ID: <CAGdbjm+pBXysSJjt6GaJHFQB8S5857Yk3LVziXGOf7QH5SzyeQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kai.huang@intel.com, ubizjak@gmail.com, jgross@suse.com, 
	kvm@vger.kernel.org, pgonda@google.com, sidtelang@google.com, 
	mizhang@google.com, rientjes@google.com, manalinandan@google.com, 
	szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 4:33=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 1/22/25 16:06, Kevin Loughlin wrote:
> >> BTW, I don't think you should be compelled to use alternative() as
> >> opposed to a good old:
> >>
> >>         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
> >>                 ...
> > Agreed, though I'm leaving as alternative() for now (both because it
> > results in fewer checks and because that's what is used in the rest of
> > the file); please holler if you prefer otherwise. If so, my slight
> > preference in that case would be to update the whole file
> > stylistically in a separate commit.
>
> alternative() can make a _lot_ of sense.  It's extremely compact in the
> code it generates. It messes with compiler optimization, of course, just
> like any assembly. But, overall, it's great.
>
> In this case, though, we don't care one bit about code generation or
> performance. We're running the world's slowest instruction from an IPI.
>
> As for consistency, special_insns.h is gloriously inconsistent. But only
> two instructions use alternatives, and they *need* the asm syntax
> because they're passing registers and meaningful constraints in.
>
> The wbinvds don't get passed registers and their constraints are
> trivial. This conditional:
>
>         alternative_io(".byte 0x3e; clflush %0",
>                        ".byte 0x66; clflush %0",
>                        X86_FEATURE_CLFLUSHOPT,
>                        "+m" (*(volatile char __force *)__p));
>
> could be written like this:
>
>         if (cpu_feature_enabled(X86_FEATURE_CLFLUSHOPT))
>                 asm volatile(".byte 0x3e; clflush %0",
>                        "+m" (*(volatile char __force *)__p));
>         else
>                 asm volatile(".byte 0x66; clflush %0",
>                        "+m" (*(volatile char __force *)__p));
>
> But that's _actively_ ugly.  alternative() syntax there makes sense.
> Here, it's not ugly at all:
>
>         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
>                 asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
>         else
>                 wbinvd();
>
> and it's actually more readable with alternative() syntax.
>
> So, please just do what makes the code look most readable. Performance
> and consistency aren't important. I see absolutely nothing wrong with:
>
> static __always_inline void raw_wbnoinvd(void)
> {
>         asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
> }
>
> void wbnoinvd(void)
> {
>         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
>                 raw_wbnoinvd();
>         else
>                 wbinvd();
> }
>
> ... except the fact that cpu_feature_enabled() kinda sucks and needs
> some work, but that's a whole other can of worms we can leave closed toda=
y.

Thanks for the detailed explanation; you've convinced me. v6 coming up
shortly (using native_wbnoinvd() instead of raw_wbnoinvd(), as you
named the proposed wrapper in your reply to v5).

