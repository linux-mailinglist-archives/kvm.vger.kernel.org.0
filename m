Return-Path: <kvm+bounces-53441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36593B11C44
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 12:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A690564191
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 10:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7673C2DE712;
	Fri, 25 Jul 2025 10:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b="FDfbOLPt"
X-Original-To: kvm@vger.kernel.org
Received: from dane.soverin.net (dane.soverin.net [185.233.34.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0922DC348
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.233.34.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753439102; cv=none; b=C7PlUPnFNqk1kLnYFfvpMCTzFhXN7qmhNY2U9+TgM1+TM8WsI/ILEPcYg4Zzoa84pvJPF/VwUrLtA5i27QK0UgzePw2BNllssbJUtglVCwPtVDi4rk0YZ4GGioU33lt48tiEx2rdO/+ULqqedYtUcz3EXzq49ZuEOvVO2HAMYV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753439102; c=relaxed/simple;
	bh=wuGhjS5e4r6kwMpZoARntB0hKB+IVvKoz++SaVJBTro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tu87i4r4trb+bpkvDHtxoId70VIXxf5oEQBaWuEv/XWCYAdlFFZ89HjxNQZnphbF+K5a2t7ocrNrhdgBkd9TJ46CGAgsygG5Kr3nRZC45NwWv6fiUHTxUwtoOZDDHK5ZLYVaXpe91cUh4PSER1CrY89BOBR793Vmg754RYaDURg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl; spf=pass smtp.mailfrom=raymakers.nl; dkim=pass (2048-bit key) header.d=raymakers.nl header.i=@raymakers.nl header.b=FDfbOLPt; arc=none smtp.client-ip=185.233.34.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raymakers.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raymakers.nl
Received: from smtp.soverin.net (unknown [10.10.4.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	by dane.soverin.net (Postfix) with ESMTPS id 4bpPBd37Dkz13MJ;
	Fri, 25 Jul 2025 10:24:57 +0000 (UTC)
Received: from smtp.soverin.net (smtp.soverin.net [10.10.4.100]) by soverin.net (Postfix) with ESMTPSA id 4bpPBc4fw9zNG;
	Fri, 25 Jul 2025 10:24:56 +0000 (UTC)
Authentication-Results: smtp.soverin.net;
	dkim=pass (2048-bit key; unprotected) header.d=raymakers.nl header.i=@raymakers.nl header.a=rsa-sha256 header.s=soverin1 header.b=FDfbOLPt;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raymakers.nl;
	s=soverin1; t=1753439097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwGBKoGSK5hyhrXBFhC000DvuldOUGiw3VO4vaObOn8=;
	b=FDfbOLPtQAJA+j90HOxJzn6xXRqeaKF1BALyG/yzSFwq7B24NcQG0BClde3TCfFUls1rQl
	KEDFT2qhJimNGXjJ17CoOVKLdBD9wkgJC25kh47leJM7s0Ir05BhcztpNcLKmP07vYYaw2
	4kixUgzz5h+kJyMIIszCirHMjtztQjJkvHRT2LP0/6F1FQeNHpoTuUYNatGWrmKQt3usHd
	bEfmVqDX6lITg3agShXonT2gNTlPuT2WPBrtNDVFDo2M+o/P55VQwE/E/aE5NspQ11uu9D
	Ll05KZIAgcjIAbmMGkzyIpH0n0Su/wKCGy97/4GX1eHtzaQ94RNSKXxDYJCZ3A==
X-CM-Envelope: MS4xfLSOwqEs7vPO8vLGkdw3VVXIL7sFXZzQZprzYM9VIZ/gw57aWVBgiUw9DRRyu7M0mk0NaZqvZta/iretyDeIV5vE6+cAMDfoSyNJxuuK92AWZL7T18uA 5xqUqkXH1tMZPyVmAQd5JQ2IuAiaYbec8O00/bvKQo+6p9+HXS1470+4jJfavQYQ14POi8U8a+QCH3byX8N7Uc9nRb+he00tdqScFu2q8eVZHO25J4kknK22 EqetgNLaas5ofCwTFa+BjqpBHxl5XX83WMkfvT6ao4zhmn2d3HtQ72U2cBpAriV58Jke/VhSlp8+DYXl+iJfoA==
X-CM-Analysis: v=2.4 cv=UsCZN/wB c=1 sm=1 tr=0 ts=68835b79 a=XOmTiIAKWumpY28wnlWq/Q==:117 a=XOmTiIAKWumpY28wnlWq/Q==:17 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=eMcEbXDZAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=UVw58GM76ilsUMV6UqoA:9 a=QEXdDO2ut3YA:10 a=Ff6uVGclmHxgYidJvOUY:22 a=Yupwre4RP9_Eg_Bd0iYG:22
Message-ID: <8743b6be-3c28-43c0-aec7-948ae1d2d026@raymakers.nl>
Date: Fri, 25 Jul 2025 12:24:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, stable <stable@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <aII3WuhvJb3sY8HG@google.com>
 <20250724142227.61337-1-thijs@raymakers.nl>
 <2025072441-degrease-skipping-bbc8@gregkh> <aIKDr_kVpUjC8924@google.com>
 <2025072540-eggbeater-crate-50af@gregkh>
Content-Language: en-US
From: Thijs Raymakers <thijs@raymakers.nl>
In-Reply-To: <2025072540-eggbeater-crate-50af@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spampanel-Class: ham


On 7/25/25 6:42 AM, Greg Kroah-Hartman wrote:
> On Thu, Jul 24, 2025 at 12:04:15PM -0700, Sean Christopherson wrote:
>> On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
>>> On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
>>>> min and dest_id are guest-controlled indices. Using array_index_nospec()
>>>> after the bounds checks clamps these values to mitigate speculative execution
>>>> side-channels.
>>>>
>>>> Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
>>>> Cc: stable <stable@kernel.org>
>>>> Cc: Sean Christopherson <seanjc@google.com>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Nit, you shouldn't have added my signed off on a new version, but that's
>>> ok, I'm fine with it.
>> Want me to keep your SoB when applying, or drop it?
> Keep it please, I was just letting Thijs know.
Sorry about that. I was not entirely sure whether tags like Signed-Off 
should
be kept or removed in a new revision. Thanks for the feedback.
>>>> ---
>>>>   arch/x86/kvm/lapic.c | 2 ++
>>>>   arch/x86/kvm/x86.c   | 7 +++++--
>>>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>> You also forgot to say what changed down here.
>>>
>>> Don't know how strict the KVM maintainers are, I know I require these
>>> things fixed up...
>> I require the same things, but I also don't mind doing fixup when applying if
>> that's the path of least resistance (and it's not a recurring problem).

Changes in v2:
- As noted by Sean Christopherson, max_apic_id is inclusive but array_index_nospec is not.
   v2 adds one to the array_index_nospec size so the bounds do include max_apic_id
- Link to v1: https://lore.kernel.org/kvm/2025072540-eggbeater-crate-50af@gregkh/T/#u

>> I also strongly dislike using In-Reply-To for new versions, as it tends to confuse
>> b4, and often confuses me as well.

Noted, will not do it like that next time.

>>
>> But for this, I don't see any reason to send a v3.
> That's great, thanks.

Thanks. I'm fairly new to the process of submitting patches over email, 
so apologies for my mistakes. Thank you for your patience and feedback, 
it is much appreciated. If you do prefer a v3 that does include the 
change log, just let me know.

- Thijs



