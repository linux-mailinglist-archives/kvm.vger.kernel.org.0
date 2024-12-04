Return-Path: <kvm+bounces-33043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DBA9E3EB9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BC2F1657FB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ED420C48F;
	Wed,  4 Dec 2024 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WhJhohOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5811FA16B;
	Wed,  4 Dec 2024 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733327697; cv=none; b=KLubh+kgC7/vs/z6BL3U8t+0Vt3gcPYi1qHJsjPFms+EpE3jXx0eeYQEGEJxODyJvHo0zEjPsYpS7Vgc4CFYd663Yd2AGb38Dfo8kmqau5ToMmTbKkbD0qI4gOSmm+Df0TbTqXhp1dFwUgxzRhGC4GGktik3D1JX7RnPJSVlXEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733327697; c=relaxed/simple;
	bh=9Pow6k65nRmJ7jJKQmjfsRvWtHyOg8AZItDZER8eJAU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=i1nq9NTi8ZnXfwBBg7EQr0t82rS3p0mcSLvjJjviXryqUZ4yk2JQx1sP+Xu687L57Occ/uEJGJrSZK5PY1juEJOhC2MZKKIMdfe22r0/A5e+4D8v2Szqgzto78BNqV1kWLTudsQlOGreTUGfQh2OQDYJe0objiG1yJpDbMk0IcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WhJhohOB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4B4FroTQ1093386
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Dec 2024 07:53:51 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4B4FroTQ1093386
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1733327632;
	bh=TVvEsO4ehvXFJZo4F/lcbSnfyqO1B3TFGIRqUVjNtsE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=WhJhohOBQ8UXRuprzVrD5Mc3tCkF6QV5Xlw8MN/QbqCO2Rq23xRDtTKpJPe7Exy4s
	 CtqHOlSxGWkqsOJ3KIY6PK858oT3whXCa36FiDcBmI4sO+q1PM1tjCY1nGca42PJyJ
	 r5EtkFDE4no6b4OC8IePlVkI0A0oRWUPmJT01nTKb9fD6LAX/LH2+ecaKdBiyzd90k
	 +/IGRkn77s9U36wVYy4I5q4k/IRv3bi3XvU+oInSmZs2AkTnpQvy10jzUSK+TIKtHr
	 4TMREUEeXxMy7t/QVRiGZf3v7pOZ3ESwd+922y5bDWbWXJQnFluoOcVXXmLggrgRKe
	 Ish1swMXtShkw==
Date: Wed, 04 Dec 2024 07:53:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Arnd Bergmann <arnd@arndb.de>, Brian Gerst <brgerst@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Shevchenko <andy@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
User-Agent: K-9 Mail for Android
In-Reply-To: <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org> <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com> <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com>
Message-ID: <64221AAE-4A99-42D8-A78F-9B1B866CB24A@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On December 4, 2024 5:43:28 AM PST, Arnd Bergmann <arnd@arndb=2Ede> wrote:
>On Wed, Dec 4, 2024, at 14:29, Brian Gerst wrote:
>> On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel=2Eorg=
> wrote:
>>>
>>>  - In the early days of x86-64 hardware, there was sometimes the need
>>>    to run a 32-bit kernel to work around bugs in the hardware drivers,
>>>    or in the syscall emulation for 32-bit userspace=2E This likely sti=
ll
>>>    works but there should never be a need for this any more=2E
>>>
>>> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB=2E
>>> PAE mode is still required to get access to the 'NX' bit on Atom
>>> 'Pentium M' and 'Core Duo' CPUs=2E
>>
>> 8GB of memory is still useful for 32-bit guest VMs=2E
>
>Can you give some more background on this?
>
>It's clear that one can run a virtual machine this way and it
>currently works, but are you able to construct a case where this
>is a good idea, compared to running the same userspace with a
>64-bit kernel?
>
>From what I can tell, any practical workload that requires
>8GB of total RAM will likely run into either the lowmem
>limits or into virtual addressig limits, in addition to the
>problems of 32-bit kernels being generally worse than 64-bit
>ones in terms of performance, features and testing=2E
>
>      Arnd
>

The biggest proven is that without HIGHMEM you put a limit of just under 1=
 GB (892 MiB if I recall correctly), *not* 4 GB, on 32-bit kernels=2E That =
is *well* below the amount of RAM present in late-era 32-bit legacy systems=
, which were put in production as "recently" as 20 years ago and may still =
be in niche production uses=2E Embedded systems may be significantly more r=
ecent; I know for a fact that 32-bit systems were put in production in the =
2010s=2E


