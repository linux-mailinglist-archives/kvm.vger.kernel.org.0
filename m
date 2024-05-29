Return-Path: <kvm+bounces-18336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D20A18D4000
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 23:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F284E1C21F35
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 21:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947E31C9EA0;
	Wed, 29 May 2024 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ijRmXGee"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5665016937B
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717016643; cv=none; b=RJRvs6kRQDSR5oAbvssHSQAVrzXqjOYkFBicq5mqhh4h19sTNM2un/l04MbBP5zeJH59LyrzHLpJjBA55JheKNLrPQK7CaxOnpUwjHxftMCDAMD3YtmRYso3tJnrtTsVKgoW6u5M7xBUvRw/kvvFwCxvgmZtfElQjYWWMT6LePg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717016643; c=relaxed/simple;
	bh=BCBSe826+nKw2daLQ4TIlXiD2I054RSipXGDwuLppXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egTcnN1UqHFtNdpncIU8I8EhkATSJhoSqvPOl400kLGxA8qrKy3sKAS24/XsKDEMpBJxnE/jW2MmEjHDzBBb/7tB+2ZnoGTQZKX20kL0/Y+eX9MTAs3xoWIgMSP2OlQG+srnEHSGAbDFdZ1TsiNX0XGwRYH9GtW2Z9+9OSA7M8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ijRmXGee; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-420107286ecso21555e9.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 14:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717016640; x=1717621440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCBSe826+nKw2daLQ4TIlXiD2I054RSipXGDwuLppXE=;
        b=ijRmXGeehgI5neC/TycAug7mg9rG5pDgOZvkwGtuJu0Mbm6pCFIKJJEmsjebY27VN4
         TYxqZUnaQwiGe0N4+pHJr9YfbZWWkpOIa0EAMt5v4sQgsxfOBGzB+ucbFyg4FVeEYAi0
         m4agMhgSlwT3Nh5p2vkLIV2K0te9MHyVdPh/jh7rj6CgsGecdwrVkD8XSYgOWjDYU3jf
         ME2TKK9utqccJwGFaIQsqjGIEe6xx5MDZQfupSmeD5MZkTY6bj6omccpJZg1KuTKpNsa
         LZJu/3OssGgYM8xlkEmpXmJYtJw0idtnC6CxfTQPi1TgVNLXCnCPBd/M3UljA9velwvc
         rbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717016640; x=1717621440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCBSe826+nKw2daLQ4TIlXiD2I054RSipXGDwuLppXE=;
        b=ETaHcyIcE2EvrevzgCrBTEu0/s/UptIV0Ch5nfYPIMz9lMn7ZDMZ2FEG65QjaijF1E
         UmedLyv/IjjkRwSRB1TwtMPp1gN3kGzJnNceArfEdEgPovvGaAZfldLUc7qEWxU0i8O1
         H6QymFC6yF07kkoI6dhdXLIWI0lhFbxKEKVZfmihyw0uOp0zn+HODOCHTqCPDZaezp2k
         TcLnE4gcvSJS9CEBBVYeIW5D0spVvs1sQ8xa7+OFUf2InKOvDUv9VQ9U3tFMXdpxrGOU
         ADqkk8Qc7gGg65qCIEXfETQ+Ff6HGzvFNCxNBCZnjZ2nbjT20FJhELC8Ys9hyfuOmoht
         GZQA==
X-Forwarded-Encrypted: i=1; AJvYcCWNUE9mvrV/3TANuh6MOLBNkZOupCb53p1+DVgSCwGy0JMGIjCIvZfxRcXxGhTtOYg1qrnjTcmuIvFJ8ltSTwk81l1O
X-Gm-Message-State: AOJu0Yw4Mr+iBrYj5fGd7g396Y2IXigQz4kf+Etgt68dWtsj9ny+il1p
	tktJ+6CLsElP0lF2xSMrPCT6NZHraRtqQ8Wn4VjFt0glKVMrNnuRt7QIzfisOvlrAarS5BfbG47
	owWvUGyg8RpK6gEJ/pIo3N36GHP1ySmkULuIE
X-Google-Smtp-Source: AGHT+IHwVBgFo5das5shZb/z5hgC8KCkV+Jkj5w99z9LyfmWhmSM4ldtkdm2dxotNGGlvICz4N/Nu5ZLrwoOjjiw7Io=
X-Received: by 2002:a05:600c:3b85:b0:41b:4c6a:de7a with SMTP id
 5b1f17b1804b1-42127ec7dbdmr148185e9.3.1717016639372; Wed, 29 May 2024
 14:03:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com> <20240529180510.2295118-3-jthoughton@google.com>
In-Reply-To: <20240529180510.2295118-3-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Wed, 29 May 2024 15:03:21 -0600
Message-ID: <CAOUHufYFHKLwt1PWp2uS6g174GZYRZURWJAmdUWs5eaKmhEeyQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 12:05=E2=80=AFPM James Houghton <jthoughton@google.=
com> wrote:
>
> Secondary MMUs are currently consulted for access/age information at
> eviction time, but before then, we don't get accurate age information.
> That is, pages that are mostly accessed through a secondary MMU (like
> guest memory, used by KVM) will always just proceed down to the oldest
> generation, and then at eviction time, if KVM reports the page to be
> young, the page will be activated/promoted back to the youngest
> generation.

Correct, and as I explained offline, this is the only reasonable
behavior if we can't locklessly walk secondary MMUs.

Just for the record, the (crude) analogy I used was:
Imagine a large room with many bills ($1, $5, $10, ...) on the floor,
but you are only allowed to pick up 10 of them (and put them in your
pocket). A smart move would be to survey the room *first and then*
pick up the largest ones. But if you are carrying a 500 lbs backpack,
you would just want to pick up whichever that's in front of you rather
than walk the entire room.

MGLRU should only scan (or lookaround) secondary MMUs if it can be
done lockless. Otherwise, it should just fall back to the existing
approach, which existed in previous versions but is removed in this
version.

> Do not do look around if there is a secondary MMU we have to interact
> with.
>
> The added feature bit (0x8), if disabled, will make MGLRU behave as if
> there are no secondary MMUs subscribed to MMU notifiers except at
> eviction time.
>
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

This is not what I suggested, and it would have been done in the first
place if it hadn't regressed the non-lockless case.

NAK.

