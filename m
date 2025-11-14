Return-Path: <kvm+bounces-63275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 43EB8C5F637
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 22:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6BBBC4E5661
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904DF35C1B8;
	Fri, 14 Nov 2025 21:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0w1qzZ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1F235C187
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763156295; cv=none; b=DfUmlBlInCe2fhy/1jW2xTC8XwaMFhoY+Vu8vfzzrvqVu1juH6/0AZGdYa7KBvmk3zoZvPFZVe/aK/oW73SqJbl22m4Zq9RrH+ledndmNECFMnSxbLRlnELKZ1Il1bhtqX76o+pmHWl0jmXtQnw1a1W/FeuZwLtuJJbbFo+4CF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763156295; c=relaxed/simple;
	bh=NdC5qsF+daIwhv+jfvY4zcENzV+hiW0SWRKdXrzUDDM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=blZaay2WuaIAVwwxUmbc8t7jYvremzwAbBRyvNUNC+aMal3UWFh9a6DduIYXuBmFsygbg/UfnF+Uchz53RmLiLlKT3jZIl+6LSyte3vHfB2CjfzZ5yBRa/JV6AK8fl11f0JdUQlHmMVkjMtugzSJlCKbgN6xm4L4efhwjXQdT2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0w1qzZ6; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b3c965cc4so1248403f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 13:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763156290; x=1763761090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2AdOzp3Vu6NN0uDZN6wbKPsm+e3bm/G64aFJ2Czz/Dc=;
        b=Y0w1qzZ6IlxQlawgOU5uPcNW+qSEYGq/KcYSZKgMdHYozWsNQQ2Re6dTx9V67bURxh
         l0bPakAcvxyuyaLUfh6TsPF4D8f2yZ0EXSUprukx1c6oI0cOuWrOsgRltQuNpLAs7vkn
         UJfAOS7/pjceW7qpq+NEKsHAEPzAK7qyEIX/XpeFuBF2XGAhYoFweYfGrV8Yh02opHuJ
         h09ANC+HPQ8JRNVu9MHlYYYzanOQqUq6yQSppXWSXD8snwSnFEkZujJgqCpMJePplX+5
         zBso7EkKxyibBvPbIVPGVmni37f1hf93bh2duHi9MoKTlG+Z+NLk2xnetafht8MZUo99
         B6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763156290; x=1763761090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2AdOzp3Vu6NN0uDZN6wbKPsm+e3bm/G64aFJ2Czz/Dc=;
        b=L8qPw0UWxPeStCp8JvU6GZgGIFwRkFnJ8Ci8encZfyKrVODtVuSkBW2vAfDJzadQ+i
         9aWJ2n3ZfuHh0mHLw2k5PZmxEutWJm+iegHMxkV6RakfMbVGiaOA1zRjzTdc3bL97YYr
         eJGdwoEaC5iY93ZGez3oIteK36Q615QN3vQzsRhZk41qWbZEjc8LPkmZVM5pHxOseAbZ
         cV8a0pCOnWIsRK6lOZWZE+UJnG8PWOgN9hOybdPKOcP9ks9AFlCWjULrucb8MXdJc0j8
         +AdVmWSUJTWSSpLst59Q6i6fzvaWs5C7STFbEZxqoVZunk6zG9hMG8/Eq66Akqd2H0ZR
         2UZw==
X-Forwarded-Encrypted: i=1; AJvYcCVwC6Mxq3PwY2geejd0AjycDygCyXctLLFh+8RPy42kkDC3zuL11ucOm/WGDptsEWAOG6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5FBZqfHLlOuuDE0hQUTTPrdgmkBd7/U6LfTcPLAHkQbJsqAs2
	W13FjEAazsycV5Ha5ehLJMs9IZB6V5Tlz6GWbrMuViIlXGoaSsWpx2uP
X-Gm-Gg: ASbGnctVCuvQ6zyZtRaSjt5LcM2wRM9LRfE4f1P7rw619kS8jk0/bj7Pql6zPYgBruL
	b6FY7QtnCjTqt8IxCtiEYVDliXCdslkVxSY0hZ2HRO+vTBH4QLAwC9AH7xCnBjf8EHL+dO0TUqr
	eyktqtPuiMqBuqtMjCs2d68Md5kd17ZF+xr3Jx5BsDZI45VVhVucYbCerH7h8nGKTYQLykOt8Hn
	UTSJ6p1hhcuo8z0qwLxsXHxEP638IEMjPIDlzb9V9cN5AqzrgBRRJqFF1jHdHJJW2qc54dAxNVZ
	+EK+fnKkEtb3t1PzIXvJK+F833qBPmwPiMF8WafRT5c1ZIuF1gAC09UGcnjxF1dq+TBMhMPTRBa
	8AZwgdwqGWub5QYcTux7Xsy+i8qNV8/IrN8izvewYVMTqW1LYakM7ajmYCYhn0LDETCdLumvrFA
	KC1toRi0uReEjW8e2nE8po7Nb2H8ESB/JFJFdW9BUzaNFz4YKssqhemBdD9wQML60=
X-Google-Smtp-Source: AGHT+IF4RUaKrhCIq/a+CQuzQOczqQ1I8RVr8VKrQgygddIe/fx8JxhllhOhRwXR1khsOJv2FxFapw==
X-Received: by 2002:a5d:584a:0:b0:429:cfa3:5fde with SMTP id ffacd0b85a97d-42b527be676mr8873626f8f.11.1763156290271;
        Fri, 14 Nov 2025 13:38:10 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f206e2sm12158736f8f.41.2025.11.14.13.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 13:38:10 -0800 (PST)
Date: Fri, 14 Nov 2025 21:38:08 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Kohler <jon@nutanix.com>, Jason Wang <jasowang@redhat.com>, "Michael
 S. Tsirkin" <mst@redhat.com>, Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Borislav
 Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user()
 and put_user()
Message-ID: <20251114213808.252fc8eb@pumpkin>
In-Reply-To: <CAHk-=whJ0T_0SMegsbssgtWgO85+nJPapn6B893JQkJ7x6K0Kw@mail.gmail.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
	<CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
	<E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
	<CAHk-=whkVPGpfNFLnBv7YG__P4uGYWtG6AXLS5xGpjXGn8=orA@mail.gmail.com>
	<20251114190856.7e438d9d@pumpkin>
	<CAHk-=whJ0T_0SMegsbssgtWgO85+nJPapn6B893JQkJ7x6K0Kw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Nov 2025 12:48:52 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 14 Nov 2025 at 11:09, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > I think that is currently only x86-64?
> > There are patches in the pipeline for ppc.
> > I don't think I've seen anything for arm32 or arm64.  
> 
> Honestly, the fact that it's mainly true on x86-64 is simply because
> that's the only architecture that has cared enough.
> 
> Pretty much everybody else is affected by the exact same speculation
> bugs. Sometimes the speculation window might be so small that it
> doesn't matter, but in most cases it's just that the architecture is
> so irrelevant that it doesn't matter.
> 
> So no, this is not a "x86 only" issue. It might be a "only a couple of
> architectures have cared enough for it to have any practical impact".
> 
> End result: if some other architecture still has a __get_user() that
> is noticeably faster than get_user(), it's not an argument for keeping
> __get_user() - it's an argument that that architecture likely isn't
> very important.

I was really thinking it was a justification to get the 'address masking'
implemented for other architectures.

It wouldn't surprise me if some of the justifications for the 'guard page'
at the top of x86-64 userspace (like speculative execution across the
user-kernel boundary) aren't a more general problem.

So adding support to arm32, arm64, riscV and 32bit x86 might be reasonable.
What does that really leave? sparc, m68k?

At that point requiring a guard page for all architectures starts looking
reasonable, and the non 'address masking' user access checks can all be
thrown away.
That isn't going to happen quickly, but seems a reasonable aim.

Architectures without speculation issues (old ones) can use a C compare.
I think this works for 32bit x86 (without cmov):
	mov $-guard_page, %guard_off
	add %user_addr, %guard_off
	sbb %mask, %mask
	and %mask, %guard_off
	sub %guard_off, %user_addr
mips-like architectures (no flags) probably require a 'cmp' and 'dec'
to generate the mask value.
(I'm not sure how that compares to any of the ppc asm blocks.)

	David

> 
>            Linus


