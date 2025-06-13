Return-Path: <kvm+bounces-49397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E06AD851D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:59:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B32317A6114
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924092DA765;
	Fri, 13 Jun 2025 07:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="FR0rsQrz"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2DD2DA742;
	Fri, 13 Jun 2025 07:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749801581; cv=none; b=TI5JoT72FHb5MxE3xRK9OHtUl5R2z2woLgGqQBxcigg/AOXe/NMgELm2cSaKTeKjKVjVFT55WTuVc6fCkdcJ/6bQdfwPucnTpMePwpnOQni72RVcMpb5ukLcIQdAZeOyQQ046CUmLl+fW5iOmueSQ+vYW8OWT/aVoSRFoSO+6UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749801581; c=relaxed/simple;
	bh=McDt6/W+t7nlPCwsFeEXv6YFx0GXNZG7meU5GlM6UyE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=fU7+cGQFcYrwhMynFJIpLCJ39R4bgc4FJ3iNcBkzFWwrfNX6sgzA+0SU6tHs9mPT0lzILFKRGPUt7xu5PMt8WlExms9jpzIMdp36k2i7M8UdoIk66YVVEnR8Zr037FqKOTCQhk+FgYy/ZWP3PguU6rVknxRI46zJkoz8Q/0N2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=FR0rsQrz; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D7x5GN3711682
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Jun 2025 00:59:06 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D7x5GN3711682
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749801546;
	bh=lbnQwynTa/B6ZoSlC7JbFa7/kdYpKx5Fq7CDYo42JEY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=FR0rsQrz+GJ0X6w+v6ybM29Adieb6GyuGSj/+DCrAaPMLMhdr2RxLyM98R/WJXO5Y
	 irvf/z0IgWrYzUromQG4KYMG3tfVag5PWpeM4kJqDfDkYIvTXEZVNtlmjU8f/vl+Vq
	 EzE4+aS/Dh3hGdY80Sp7m+hu4/TWQFXvSXBtx/UwQp66CcPaprw5nbhpUT6B8FYu6T
	 Bs4pSMJappNvXsfwzoU2mXKBdWigwy+gRXLkW5ovueyfyLTEfsoKNNM/9H2dHaGyAf
	 qlXRVYOoqrbVyZrD6X0FvMb9IcUOATIr2tMaB210kJYuv30tdDQZnv+yPz9kZbc2Ke
	 Yz0ii9Kyn2aGQ==
Date: Fri, 13 Jun 2025 00:59:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, seanjc@google.com, pbonzini@redhat.com,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v1_2/3=5D_x86/traps=3A_Initialize_D?=
 =?US-ASCII?Q?R7_by_writing_its_architectural_reset_value?=
User-Agent: K-9 Mail for Android
In-Reply-To: <f5ceeceb-d134-4d51-99d1-d8c6cfd7134f@zytor.com>
References: <20250613070118.3694407-1-xin@zytor.com> <20250613070118.3694407-3-xin@zytor.com> <20250613071536.GG2273038@noisy.programming.kicks-ass.net> <f5ceeceb-d134-4d51-99d1-d8c6cfd7134f@zytor.com>
Message-ID: <310B2567-8680-4E1D-B1BB-A56809466ED4@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 13, 2025 12:51:31 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 6/13/2025 12:15 AM, Peter Zijlstra wrote:
>> On Fri, Jun 13, 2025 at 12:01:16AM -0700, Xin Li (Intel) wrote:
>>=20
>>> While at it, replace the hardcoded debug register number 7 with the
>>> existing DR_CONTROL macro for clarity=2E
>>=20
>> Yeah, not really a fan of that=2E=2E=2E IMO that obfuscates the code mo=
re than
>> it helps, consider:
>>=20
>>> -	get_debugreg(dr7, 7);
>>> +	get_debugreg(dr7, DR_CONTROL);
>
>Actually I kind of agree with you that it may not help, because I had
>thought to rename DR7_RESET_VALUE to DR_CONTROL_RESET_VALUE=2E
>
>Yes, we should remember DR7 is the control register, however I also hate
>to decode it when looking at the code=2E
>
>
>>=20
>> and:
>>=20
>>> -	for (i =3D 0; i < 8; i++) {
>>> -		/* Ignore db4, db5 */
>>> -		if ((i =3D=3D 4) || (i =3D=3D 5))
>>> -			continue;
>>> +	/* Control register first */
>>> +	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
>>> +	set_debugreg(0, DR_STATUS);
>>>   +	/* Ignore db4, db5 */
>>> +	for (i =3D DR_FIRSTADDR; i <=3D DR_LASTADDR; i++)
>>=20
>> I had to git-grep DR_{FIRST,LAST}ADDR to double check this was correct =
:(
>>=20
>> Also, you now write them in the order:
>>=20
>>    dr7, dr6, /* dr4, dr5 */, dr0, dr1, dr2, dr3
>>=20
>> My OCD disagrees with this :-)
>>=20
>
>The order of the other debug registers doesn't seem critical, however
>the control debug register should be the first, right?
>
>Here I prefer to use "control register" rather than "dr7" here :)
>
>Thanks!
>    Xin

That's the real issue here, 7 is the control register and 6 is the status =
register; 4-5 and 8-15 don't even exist=2E=20

But we want to reset the control register first=2E

Incidentally, do you know the following x86 register sequences in the prop=
er order?

ax, cx, dx, bx, sp, bp, si, di, =2E=2E=2E
al, cl, dl, bl, ah, ch, dh, bh
es, cs, ss, ds, fs, gs

