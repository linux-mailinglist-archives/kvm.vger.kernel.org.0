Return-Path: <kvm+bounces-33046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B889E3F23
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 17:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB96028407F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F147920CCDA;
	Wed,  4 Dec 2024 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TjlzRkgx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF936209F5B;
	Wed,  4 Dec 2024 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733327960; cv=none; b=u8twmeKDTWprOBJSUE3CjK1O72PrM63U80296RBD8RVXzyeoMzeaisHL0s+37xPrBKnd0Lg6LUZz7fOaHUsh1pOG5exD7Ij5Zcn4OnON+J+DcK2ODUr0nxnhp92qRJxQRdHvBBeUNZgXYKiN92YkXoAtzbKBmaEk8YVCTimPnyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733327960; c=relaxed/simple;
	bh=1zKufKTfxz+zYrP4NUPN5UlRR0iBb0ohMo3/bMnR9/0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=uMF4dO6Dj4IFyw4EcCK5cuXYbQ3J1HR4WiOyGEMQiYZvvvH+XMrahZM1k6Jzs5NNMdft/BnhDrxLFgEvXB9Jp4DvK8FBjx/sV1cAEcO+x2q81XTjyjo8ix99fmsn0BljPCi5S1MAE6KOcr+hxgoViFP/MrOJGijHvlaAT+Ok1k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TjlzRkgx; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4B4FwiJg1094772
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Dec 2024 07:58:44 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4B4FwiJg1094772
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1733327925;
	bh=+w9QJAmcwmakY/9Bi3MHTU/eGSlPBFIuIJ8G5y+/sug=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=TjlzRkgxqetsF/hXvvR5Wmvsa4WxA36Nb/XDt+H3ax3ISsjZkzBE9XWL2VfuSAnNL
	 X7hrueWEy8tlTku3Sw05807cl+8ZtSNzKhuTTFSpVYmxoMH+zTWQRKRszQbTdp3fqZ
	 qj1lZAiLdKVntjDyvIl53jEZNif1vjdaCi9bRmmngm3rrjhjKKxs6tabCMMjJC2JKT
	 QfXTvcUBtM2VaXi8eFC0W3wZ91azqEs4Szn2uVGdQWk47cxs1DHNzWLBrhcY8iwtlt
	 LfKRkyuBMMpnoVjQEggh5AmIwZ9vUeR+3I5HxSn1b3ly7aJagKPbwApqR53zf9Otpq
	 HTCzVVhV1tiwQ==
Date: Wed, 04 Dec 2024 07:58:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Brian Gerst <brgerst@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <CAMzpN2gTUks3K3Hvwq3MEVBCN-9HHTLM4+FNdHkuQOmgX0Tfjg@mail.gmail.com>
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-6-arnd@kernel.org> <CAMzpN2joPcvg887tJLF_4SU4aJt+wTGy2M_xaExrozLS-mvXsw@mail.gmail.com> <00e344d7-8d2f-41d3-8c6a-1a828ee95967@app.fastmail.com> <CAMzpN2gTUks3K3Hvwq3MEVBCN-9HHTLM4+FNdHkuQOmgX0Tfjg@mail.gmail.com>
Message-ID: <FEB8B811-EA8F-41B4-B423-DBDE85AFA936@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On December 4, 2024 6:02:48 AM PST, Brian Gerst <brgerst@gmail=2Ecom> wrote=
:
>On Wed, Dec 4, 2024 at 8:43=E2=80=AFAM Arnd Bergmann <arnd@arndb=2Ede> wr=
ote:
>>
>> On Wed, Dec 4, 2024, at 14:29, Brian Gerst wrote:
>> > On Wed, Dec 4, 2024 at 5:34=E2=80=AFAM Arnd Bergmann <arnd@kernel=2Eo=
rg> wrote:
>> >>
>> >>  - In the early days of x86-64 hardware, there was sometimes the nee=
d
>> >>    to run a 32-bit kernel to work around bugs in the hardware driver=
s,
>> >>    or in the syscall emulation for 32-bit userspace=2E This likely s=
till
>> >>    works but there should never be a need for this any more=2E
>> >>
>> >> Removing this also drops the need for PHYS_ADDR_T_64BIT and SWIOTLB=
=2E
>> >> PAE mode is still required to get access to the 'NX' bit on Atom
>> >> 'Pentium M' and 'Core Duo' CPUs=2E
>> >
>> > 8GB of memory is still useful for 32-bit guest VMs=2E
>>
>> Can you give some more background on this?
>>
>> It's clear that one can run a virtual machine this way and it
>> currently works, but are you able to construct a case where this
>> is a good idea, compared to running the same userspace with a
>> 64-bit kernel?
>>
>> From what I can tell, any practical workload that requires
>> 8GB of total RAM will likely run into either the lowmem
>> limits or into virtual addressig limits, in addition to the
>> problems of 32-bit kernels being generally worse than 64-bit
>> ones in terms of performance, features and testing=2E
>
>I use a 32-bit VM to test 32-bit kernel builds=2E  I haven't benchmarked
>kernel builds with 4GB/8GB yet, but logically more memory would be
>better for caching files=2E
>
>
>Brian Gerst
>

For the record, back when kernel=2Eorg was still a 32-bit machine which, o=
nce would have thought, would have been ideal for caching files, rarely ach=
ieved more than 50% memory usage with which I believe was 8 GB RAM=2E The n=
ext generation was 16 GB x86-64=2E

