Return-Path: <kvm+bounces-33048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 767AD9E409F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1344B39AB2
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9728320CCD5;
	Wed,  4 Dec 2024 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Y7GsxTJU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E0615B10D;
	Wed,  4 Dec 2024 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330282; cv=none; b=cuj9EeCRPgAcJRJsrjJnFYFsEd/FLNCMjDpfkusgJHjuO4JamFuWIdwl3o/9unibyQ148xsAUrIrh9CINJWrFdhO+8pWv23cquf7J6aSmsfmKcnGYzoDwgCrI7l/dLJdBvtTk+qKoUSPck3aGdLpJtm2e0g1gP9irBczq5REtWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330282; c=relaxed/simple;
	bh=x+97R4+Qu2pFUYhYlj9AO6jmWcDs0wrX0RY+HiKcAFA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=IKgpLspmZNp4BSaSbXw0k58akXRPUKGI0m7mZvTfNCxQAs7dAVMIYFgThhtAz7uE+HmiebTvcVIgAGiKAStFeVxejJNPDhmSExEcCvbp634TJXIvq0albMR1yaL3lW8Nb3Mbu1ZQAm9pMdh/AqFdNw0eZv+RaIdnRmjtGR4PeL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Y7GsxTJU; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4B4GbNvO1111657
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Dec 2024 08:37:24 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4B4GbNvO1111657
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1733330245;
	bh=zUEN7Y+zdFzQNIkoosq21iA5Pa8Pqr2J5qBpK5Y272I=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Y7GsxTJUzd7tnZOvV4vTQGc+ZqIqIKUED8WoxyjNaD9/qwlJWnGMSVsDsR6xfo1NM
	 XwdaMDhlkQMFzQ/goZnyTulzCo0fSlk+acOc25XPc68WilK6UxXl9oOxRiTXa/b2l6
	 92fqn0VXHvhrbW4dPxcGapY9zTLvuZSJobPBBQ9E7p1eNsKDg73z5va/Z8iLxrzil7
	 KbBSX0DP89lVUbVMEbw3DEYqw5TLJNaWUj5dyEf4nRnmTFOTwC3Dd+DREmD/Ink4i1
	 WwdTyki9632ll2v+Mf5TUiBba9o0bZJqU3yHbZggPgpS0WzM+ENO1d8qqXWSL5mOX/
	 +XZl47y3EXMQg==
Date: Wed, 04 Dec 2024 08:37:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Brian Gerst <brgerst@gmail.com>, Arnd Bergmann <arnd@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Shevchenko <andy@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org> <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com>
Message-ID: <A0F192E7-EFD2-4DD4-8E84-764BF7210C6A@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On December 4, 2024 5:29:17 AM PST, Brian Gerst <brgerst@gmail=2Ecom> wrote=
:
>On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel=2Eorg> =
wrote:
>>
>> From: Arnd Bergmann <arnd@arndb=2Ede>
>>
>> The HIGHMEM64G support was added in linux-2=2E3=2E25 to support (then)
>> high-end Pentium Pro and Pentium III Xeon servers with more than 4GB of
>> addressing, NUMA and PCI-X slots started appearing=2E
>>
>> I have found no evidence of this ever being used in regular dual-socket
>> servers or consumer devices, all the users seem obsolete these days,
>> even by i386 standards:
>>
>>  - Support for NUMA servers (NUMA-Q, IBM x440, unisys) was already
>>    removed ten years ago=2E
>>
>>  - 4+ socket non-NUMA servers based on Intel 450GX/450NX, HP F8 and
>>    ServerWorks ServerSet/GrandChampion could theoretically still work
>>    with 8GB, but these were exceptionally rare even 20 years ago and
>>    would have usually been equipped with than the maximum amount of
>>    RAM=2E
>>
>>  - Some SKUs of the Celeron D from 2004 had 64-bit mode fused off but
>>    could still work in a Socket 775 mainboard designed for the later
>>    Core 2 Duo and 8GB=2E Apparently most BIOSes at the time only allowe=
d
>>    64-bit CPUs=2E
>>
>>  - In the early days of x86-64 hardware, there was sometimes the need
>>    to run a 32-bit kernel to work around bugs in the hardware drivers,
>>    or in the syscall emulation for 32-bit userspace=2E This likely stil=
l
>>    works but there should never be a need for this any more=2E
>>
>> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB=2E
>> PAE mode is still required to get access to the 'NX' bit on Atom
>> 'Pentium M' and 'Core Duo' CPUs=2E
>
>8GB of memory is still useful for 32-bit guest VMs=2E
>
>
>Brian Gerst
>

By the way, there are 64-bit machines which require swiotlb=2E

