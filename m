Return-Path: <kvm+bounces-49554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7219DAD99F5
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 05:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB26A7A9437
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 03:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9603518BC0C;
	Sat, 14 Jun 2025 03:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LNEMusXf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79582E11CB;
	Sat, 14 Jun 2025 03:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749872327; cv=none; b=HTD7v7DnBWNJFXSM14e3DFEYUWXa2NIr849NX1PVgdh06dAkIbrhXaR8BmlQkjadf8o2phj9UHgYF38FD4fuzItnB4Mjow9rzbGwMjlLwXHcJWQy7XeLr00VFxmH6PairrXd2eI3qyxzMbdP3HD50lsZSQ+0NkU8RIwtp9hHrmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749872327; c=relaxed/simple;
	bh=CTGpy3fNjoHFyN9tVmM18ZgNeMkkn1TEYFRM4ultmjM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=b8foGSVvzc3jiU30OyNoJVLRGPMpQ41jFtaNyQ5IcAzr6SpavHLOBUgklnCahetUMOiKAxHuDFNp5Y6S+w++z32erCrNR4bfJj0vSl45QICIuMyTNidgZSVkHVVaRAMX+MCMgUaPjuLwvq6sCtqz0h5iyvfB3RLA96/f4gm7N4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LNEMusXf; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55E3c2Z84045625
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 13 Jun 2025 20:38:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55E3c2Z84045625
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749872284;
	bh=324yp862AH/g/TmhsrFlhcT3qA+FlMLkzgPM9owphjI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=LNEMusXfakV909afh9NkF4LrrNnqNvAnybQPDBVtJavWVr5yXVPenz+5mTR5Kcoba
	 ki/fXyzKOIZ+vJ0S16/KSNWsMOLYvKcdRqUIsFIWyceE/EZYRvH9xBcVVxBTfdKqfR
	 5iPnnjNaVc16hLgwlc34bNjv2d+8/rCB7NaoZZOJDmRoZpqo5SdVmld1eMkrvSFKl8
	 YG49ZlFfceYWAw+Lon5Dy1YHx/zBoz5Sa0W7M5TMcWPSq8HA1LvWZmoF+KFPYe86lk
	 N+DxKkbhPAtlAZWIAOu2MVRZhe8t0YLzRbo+tAwmduPpaWpGZstnLX5M8pjWkI8Tsa
	 9QxiLnoX7eutg==
Date: Fri, 13 Jun 2025 20:38:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Sohil Mehta <sohil.mehta@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, brgerst@gmail.com,
        tony.luck@intel.com, fenghuay@nvidia.com
Subject: Re: [PATCH v1 0/3] x86/traps: Fix DR6/DR7 inintialization
User-Agent: K-9 Mail for Android
In-Reply-To: <c93b8a59-9466-4d2f-8141-81142f5ead8c@zytor.com>
References: <20250613070118.3694407-1-xin@zytor.com> <ac28b350-91a4-4e6d-bca6-4e0c80f4f503@intel.com> <c93b8a59-9466-4d2f-8141-81142f5ead8c@zytor.com>
Message-ID: <9D33DFBA-FE08-47B3-9663-7252B943F595@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 13, 2025 4:22:57 PM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 6/13/2025 3:43 PM, Sohil Mehta wrote:
>> On 6/13/2025 12:01 AM, Xin Li (Intel) wrote:
>>=20
>>>=20
>>> Xin Li (Intel) (3):
>>>    x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg=2Eh>
>>>    x86/traps: Initialize DR7 by writing its architectural reset value
>>>    x86/traps: Initialize DR6 by writing its architectural reset value
>>>=20
>>=20
>> The patches fix the false bus_lock warning that I was observing with th=
e
>> infinite sigtrap selftest=2E
>>=20
>> Tested-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>>=20
>> I'll try it out again once you send the updated version=2E
>
>Thank you very much!
>
>>=20
>> In future, should we incorporate a #DB (or bus_lock) specific selftest
>> to detect such DR6/7 initialization issues?
>
>
>I cant think of how to tests it=2E  Any suggestion about a new test?
>

You would have to map some memory uncached=2E

