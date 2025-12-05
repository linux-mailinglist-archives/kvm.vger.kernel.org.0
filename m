Return-Path: <kvm+bounces-65318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63376CA6591
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 08:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 720AE304C985
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 07:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949302BDC03;
	Fri,  5 Dec 2025 07:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6KJ8KRk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023372D73A3
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764918959; cv=none; b=JGhDvzx62XjdRndf3sqt9KRKnVzq8NSpg4CcenKcY5Y5JEvWljrUStrm24E1eizwWLRpTVQ5jstwvSPlPudOomN1BtMVA/MtYena2ljRtYnByJFsEtOxkeAyBlANH33R97K8opm2uo8c3pD3sk5sRBYjGQUfAYrFKPIPvl/TgtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764918959; c=relaxed/simple;
	bh=a+g5PqYgQ2xiTh3oOMNBb7FVVBwxlJcpvj/PQQU5xpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=elto5c5lQWhxsr8UK5/fTGj8OT9u05iUR3s0P8D3d95urM+Ys2Bs1XspcPsmLKM5jOZJLYoJm6AnSDVTP1vvdURQEE+opgjBBNRn0q7+Tkvglk2f1uTPvSLkR++IGfsBvIqBqDnxJgehPP+F8cdZw2aLDvDPMVYut/JO5Yo3Up0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6KJ8KRk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97277C4CEF1;
	Fri,  5 Dec 2025 07:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764918958;
	bh=a+g5PqYgQ2xiTh3oOMNBb7FVVBwxlJcpvj/PQQU5xpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H6KJ8KRkWUWqEVHPFyLg9y5J16i2rKuaGcdwtjoht61A7MOSLVdVYIWNF/kBlipmI
	 XFzxA4gLWm0bSzAVjyUAgOFMv8c+wM0hd3dg0CeVk3OsSve00jMIWIloHWwMMAUC8X
	 yKImQG5+2OIOkiYIHTnufDaKAWclX+nXI5hxC1TxzOC4y9Nwu4TfJZTsNCxBbs28j9
	 R8pDMkTD/o4Fy8+kO9BLZa7qzQraqPktg+gPv9Z8S+XwLowunARiRiUUu8ftMcGUKc
	 aGwN7gVDgfufA2/RaG9uH1FNYLQldNbd8friiVLv/sRogJOCOybxCcaeWAi25Lz8iK
	 6DnEKkbx2w9MQ==
Message-ID: <d07652fb-dece-4e9a-b307-ba018277bf8e@kernel.org>
Date: Fri, 5 Dec 2025 08:15:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] KVM: pfncache: Support guest_memfd without direct
 map
To: David Woodhouse <dwmw2@infradead.org>,
 Brendan Jackman <jackmanb@google.com>, Takahiro Itazuri <itazur@amazon.com>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
 Paul Durrant <pdurrant@amazon.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Patrick Roy <patrick.roy@campus.lmu.de>,
 Takahiro Itazuri <zulinx86@gmail.com>
References: <20251203144159.6131-1-itazur@amazon.com>
 <DEOPHISOX8MK.2YEMZ8XKLQGMC@google.com>
 <a07a6edf549cfed840c9ead3db61978c951b15e4.camel@infradead.org>
 <DEOQV1GRUTUX.1KJUWG1JTF1JJ@google.com>
 <cfdf2bfcacc8e0de20d97d126de4917eea720c5c.camel@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <cfdf2bfcacc8e0de20d97d126de4917eea720c5c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 23:31, David Woodhouse wrote:
> On Wed, 2025-12-03 at 17:06 +0000, Brendan Jackman wrote:
>> Makes sense. I didn't properly explore if there are any challenges with
>> making vmalloc aware of it, but assuming there are no issues there I
>> don't think setting up an mm-local region is very challinging [1]. I
>> have the impression the main reason there isn't already an mm-local
>> region is just that the right usecase hasn't come along yet?
> 
> I'm fairly sure we have a *usecase* for mm-local.

Haha, I just skimmed over this patch and wondered "is mm-local a new mm 
branch we want to have" :)

> 
> And since researchers dusted off our XSA-289 advisory from 2019,
> rediscovered it and called it 'L1TF reloaded' and then expressed
> surprise that environments which have been using mm-local ever since
> those days don't actually leak secrets from one guest to another... I'd
> kind of hope that everyone else has come round to our way of thinking
> that we have a usecase for mm-local too? :)

Yeah, I would assume that we have such use cases indeed.

-- 
Cheers

David

