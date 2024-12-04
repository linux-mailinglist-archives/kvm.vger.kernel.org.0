Return-Path: <kvm+bounces-33044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EC59E3ECC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 16:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5D3128334D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 15:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F151120E00B;
	Wed,  4 Dec 2024 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="s+sjjrIP"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D42020D50E;
	Wed,  4 Dec 2024 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733327758; cv=none; b=W3AZFug9Of1+EoUv2OCWVYV/goC3e/3mtjcnAZGjFN3S1+DCsI9Q/9sa9teyU5MPhV9S6TEMMHWvw5Mu8BBpRe3FpyCOlASdfso3MviUju+0kBpJ+D6PVGuSdv+XRqaA07ibKtWmtgEWbJvcot6KUhAsHqfEGgkibHG7LYw6ShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733327758; c=relaxed/simple;
	bh=+ao8yIYq0jnUC9zR4DMAiRToYdKX5r7/FZ2+FiQsT6Q=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=UZDVoS0NLPkP/Ce5zLOczY+oaUJa1H+XpXT3glHHUB+02iYkjemCGD1wGHBLTmzHbG1BaQHWQUqU6g5QOhmhSewBcKlUIF0CjjlIt7efgF+OOk/zwxLJCEfAhGxZEKt/u0QS+dPZnPMP8M8IPCky2S0uKO7Tza2eoVdB7piN3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=s+sjjrIP; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 4B4FtOef1093966
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Dec 2024 07:55:24 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 4B4FtOef1093966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024111601; t=1733327725;
	bh=+ao8yIYq0jnUC9zR4DMAiRToYdKX5r7/FZ2+FiQsT6Q=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=s+sjjrIP9rSJYefnF8IVrpb/2ZPcJfvu64asTxYXRNOekma5CZHkHPWzoN0wrMBkA
	 aeIKV8Se3xxOz9L/WdyBYnW8UgwH3hYEbcUBIwZXyh02F07LHsWo4WxnW5OoNQ+9vI
	 4kRtCqHOseFGjc0wYk2g2YAu07HILuqaKRMx1+BPF4i/uLltXLWaFzm+HEIwBoZQqi
	 KDoYQp00QEXtZXXBaIcsm0t7SdQXumwzr7biWpdoqHlwmufR4x2ZCw0R2S3akuoyxK
	 I3Ut+R+nkrpvC2HQuNi0RTrC/uYAFyNZ+lx8ORqhMPJ/g6mCrsjCPyzt8lQzfHSSnk
	 PK82vFlPSrWgA==
Date: Wed, 04 Dec 2024 07:55:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Shevchenko <andy@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 03/11] x86: Kconfig.cpu: split out 64-bit atom
User-Agent: K-9 Mail for Android
In-Reply-To: <87ed2nsi4d.ffs@tglx>
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-4-arnd@kernel.org> <87ed2nsi4d.ffs@tglx>
Message-ID: <3B214995-70A6-4777-B7E3-F10018F7D71E@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On December 4, 2024 5:16:50 AM PST, Thomas Gleixner <tglx@linutronix=2Ede> =
wrote:
>On Wed, Dec 04 2024 at 11:30, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb=2Ede>
>>
>> Both 32-bit and 64-bit builds allow optimizing using "-march=3Datom", b=
ut
>> this is somewhat suboptimal, as gcc and clang use this option to refer
>> to the original in-order "Bonnell" microarchitecture used in the early
>> "Diamondville" and "Silverthorne" processors that were mostly 32-bit on=
ly=2E
>>
>> The later 22nm "Silvermont" architecture saw a significant redesign to
>> an out-of-order architecture that is reflected in the -mtune=3Dsilvermo=
nt
>> flag in the compilers, and all of these are 64-bit capable=2E
>
>In theory=2E There are quite some crippled variants of silvermont which
>are 32-bit only (either fused or at least officially not-supported to
>run 64-bit)=2E=2E=2E
>

Yeah=2E That was a sad story, which I unfortunately am not at liberty to s=
hare=2E

