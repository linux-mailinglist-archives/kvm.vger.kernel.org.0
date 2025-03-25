Return-Path: <kvm+bounces-41996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB545A70BC7
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BF007A5DF3
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 20:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F85266B50;
	Tue, 25 Mar 2025 20:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I5PeBlO1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934A342A82
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742935806; cv=none; b=JgQSUtr1cgwJ0GD8fZjo69QcQKlMC9CkocDuYYVb8D3j1AkyLKwQ/Qx3A9PtjiJSAlGVZGBA9AsqXNcH6QQcNofpvMc21VbWQkjS7wLesOuOBlroabyCsMB29yjEVZ00FNxDH3dQfXIq+VE/LI2owFYmztqLgVAa4H5H6298VME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742935806; c=relaxed/simple;
	bh=GCAhGVtueceq1ubCUXU7aIifbCxnCpAKEuI8oUAtt/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SeB0/aVaq4igWClDcTsun5nB0GtFka2bpCCRazVU0k5BSNwO8XEbiW8Z1AROJkgueDCEKRQj68VVprfuPe63qOWP5GNEoq/Xc/tPqKIGGxoANBAoD3l90r7+fy7mYxLXWwTLyja4DG/8nn1nPeKpLZOT80VPMmnm2ZNaD/CkDmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I5PeBlO1; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30bfc8faef9so61245301fa.1
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 13:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1742935802; x=1743540602; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K52xAWNW5IEkY2W6yv56tbrXz/O78EY3OFwe6Kmcp1A=;
        b=I5PeBlO121tWNWnCOPpvNhhC7A2kwp4AkNHxYQelcboaF6LexGVEP5BI/9zHdwIOyk
         0iun1gvkqDM+bhLxuKplWOS3ulwuuA7aeA0W1gKMDFLQbXBpz64wiwslXPm6ouvywoPC
         fHbXiEFTgGJPk2AFyvBrOEyUenp40rhwlULR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742935802; x=1743540602;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K52xAWNW5IEkY2W6yv56tbrXz/O78EY3OFwe6Kmcp1A=;
        b=KFlP/yE2jp0Voq1hKpJ5JY0CS3OqahWQaY3KzmfwOUBlIN3vYOaVbnybMEnbmqDpCe
         buVOL0Zg/S86BeHU+IA+pU4z95XNVTkP3CSlPmD3WUgB3ktJB4JxgWn3ikAfdwKpfwdR
         x1Ecxb+e1Fg9ghHa8KQBc/eLd9LQ+DkeIdtefpN9d6BG32V2K9qFiVhlqprRCg5E7+i0
         be2zZXfwGYVJriZ7MOpukZVc+p6mRzFqNleyfconhTByrSWN08tY9jCPlzosWoc8ec8v
         v91Kya8QunlDOnfSCtjN5xU2a7g1UQoj0N2MIidNoPXkbtJipjPYIRdIRkmGpiTD8jzB
         tmYw==
X-Forwarded-Encrypted: i=1; AJvYcCVorUqdxvVPldYlrE4IyNIaBLEu+1x3hN71pF3QaE8/EiRHVS+IPCE5jkV+ruQfe713poI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTZQdWFfEeAEQ5/95Wu4/9HH+kVCKauS9ZIr53ysOyndPEr1aJ
	oY5hY0KoKziXIGDtr6KVGO/TRGFKmzXkZTippmE66zsX8WewlUVCUc3mXhqgsD1OBT5PppcFQgh
	FDR9p8g==
X-Gm-Gg: ASbGncstfKZcQ10pqDfWLIOWBTxC+PNodhLfDHUspEgEarEn8K6ItBUb6UOQ8v1UVV3
	ck9BpcQ7lsuBnvWr+0pv0M69pkNyCrv0qxIJLKNM/MbRTcXKXrseuTZVDGBgF45Ol1T7O3u2ArB
	pK+Ds1+NThjeDWqhFSWF2D9JbQr7w0ijEgHmyeoZjXGPsP4EiNHl6eMFGix4Pu0eXsSA+pU+LzQ
	fP5WWOzgdTn3l9FDQ9jcUSbo+cgCrT21pTgjxRW+YMtUwbfHH86mx9JGXACaH6FkkFKIpmlIEa0
	SzoP+YEAfng18kPcFpJOnmSX61awiHU4teAi1xsBvEJ8XGUD9SeH69pBnR5dpiXoM/qNnUXvh+y
	v+Qgtm8z6lopflLX1g+yuOt4=
X-Google-Smtp-Source: AGHT+IEo+vTPKVv/7NyF9o/qHjjqcp1QHB5Guub4yZqdCMDObUhLxBf4EyFK3bOxxL56mMPdWsZDRg==
X-Received: by 2002:a05:6512:3b06:b0:549:b0f3:439c with SMTP id 2adb3069b0e04-54ad64869b7mr5535102e87.21.1742935802370;
        Tue, 25 Mar 2025 13:50:02 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54ad64fbc23sm1585776e87.143.2025.03.25.13.50.01
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 13:50:01 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30bfb6ab47cso58948841fa.3
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 13:50:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUv+p64K3m9mmVXKxfEemNJoK1BYC98v/WyyQvviwEgQLkcNuO9FPkIc7dMtYDuLDKrOxo=@vger.kernel.org
X-Received: by 2002:a17:907:95a4:b0:ac3:48e4:f8bc with SMTP id
 a640c23a62f3a-ac3f27fd3b3mr1859596466b.48.1742935307883; Tue, 25 Mar 2025
 13:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325121624.523258-1-guoren@kernel.org> <20250325121624.523258-2-guoren@kernel.org>
In-Reply-To: <20250325121624.523258-2-guoren@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Mar 2025 13:41:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVgTJpSxrQbEi28pUOmuWXrox45vV9kPhe9q5CcRxEbw@mail.gmail.com>
X-Gm-Features: AQ5f1JpwFc7ifwGuAhyrs4E5qPgHx1McCR38KFycRhkLFRMKTveHrmoaWi4zba4
Message-ID: <CAHk-=wiVgTJpSxrQbEi28pUOmuWXrox45vV9kPhe9q5CcRxEbw@mail.gmail.com>
Subject: Re: [RFC PATCH V3 01/43] rv64ilp32_abi: uapi: Reuse lp64 ABI interface
To: guoren@kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org, 
	oleg@redhat.com, kees@kernel.org, tglx@linutronix.de, will@kernel.org, 
	mark.rutland@arm.com, brauner@kernel.org, akpm@linux-foundation.org, 
	rostedt@goodmis.org, edumazet@google.com, unicorn_wang@outlook.com, 
	inochiama@outlook.com, gaohan@iscas.ac.cn, shihua@iscas.ac.cn, 
	jiawei@iscas.ac.cn, wuwei2016@iscas.ac.cn, drew@pdp7.com, 
	prabhakar.mahadev-lad.rj@bp.renesas.com, ctsai390@andestech.com, 
	wefu@redhat.com, kuba@kernel.org, pabeni@redhat.com, josef@toxicpanda.com, 
	dsterba@suse.com, mingo@redhat.com, peterz@infradead.org, 
	boqun.feng@gmail.com, xiao.w.wang@intel.com, qingfang.deng@siflower.com.cn, 
	leobras@redhat.com, jszhang@kernel.org, conor.dooley@microchip.com, 
	samuel.holland@sifive.com, yongxuan.wang@sifive.com, 
	luxu.kernel@bytedance.com, david@redhat.com, ruanjinjie@huawei.com, 
	cuiyunhui@bytedance.com, wangkefeng.wang@huawei.com, qiaozhe@iscas.ac.cn, 
	ardb@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, bpf@vger.kernel.org, 
	linux-input@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-atm-general@lists.sourceforge.net, linux-btrfs@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	linux-nfs@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 05:17, <guoren@kernel.org> wrote:
>
> The rv64ilp32 abi kernel accommodates the lp64 abi userspace and
> leverages the lp64 abi Linux interface. Hence, unify the
> BITS_PER_LONG = 32 memory layout to match BITS_PER_LONG = 64.

No.

This isn't happening.

You can't do crazy things in the RISC-V code and then expect the rest
of the kernel to just go "ok, we'll do crazy things".

We're not doing crazy __riscv_xlen hackery with random structures
containing 64-bit values that the kernel then only looks at the low 32
bits. That's wrong on *so* many levels.

I'm willing to say "big-endian is dead", but I'm not willing to accept
this kind of crazy hackery.

Not today, not ever.

If you want to run a ilp32 kernel on 64-bit hardware (and support
64-bit ABI just in a 32-bit virtual memory size), I would suggest you

 (a) treat the kernel as natively 32-bit (obviously you can then tell
the compiler to use the rv64 instructions, which I presume you're
already doing - I didn't look)

 (b) look at making the compat stuff do the conversion the "wrong way".

And btw, that (b) implies *not* just ignoring the high bits. If
user-space gives 64-bit pointer, you don't just treat it as a 32-bit
one by dropping the high bits. You add some logic to convert it to an
invalid pointer so that user space gets -EFAULT.

            Linus

