Return-Path: <kvm+bounces-20966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B58927DF2
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 21:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 774661C22FF6
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 19:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6CC13CA81;
	Thu,  4 Jul 2024 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="WDIOgqFF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Sr7RX3Tf"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBD613212F;
	Thu,  4 Jul 2024 19:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720122293; cv=none; b=FewdVID05QhYghdJel9KnPrGSF4h+iVkHc8MTJ2CGMekPZUm1Uu/CV03kqf2/abgo1x3rjIsIsWLbwUx3WQQvwfjGb2zr0hsEtFyfdx+rCgkbe6IvArmci138mOfD103a8rUrJxiFQxEcjUaYyKOGoFU1kvizqtE5On86QT/Ul4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720122293; c=relaxed/simple;
	bh=SmcieX8hv9tdN+Usq0BGXgoTSAC4OEz9ArFb+VdWXhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sFLkywC1hmaFq6A3Yxydauw/69GvlJmIKZ8IS21C29WKch+vBjZTO9NqP30F76sk0S3xdSa5yiX6Uzb2ioeWOtnaeQoTyiryPFi+7saoF62pJp/FHxu7lVk1HEl5k9EUU8BBpfkbv7ZgK+mjUmyHl/prOg8xssRcC6Em95Sn1pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=WDIOgqFF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Sr7RX3Tf; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id EB04D114022D;
	Thu,  4 Jul 2024 15:44:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 04 Jul 2024 15:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1720122290;
	 x=1720208690; bh=Oov9piig11BcDOtLEPIu5MW4Xorms/bDxdNG3mKNI9Q=; b=
	WDIOgqFFHQmiy59uK1IVrEI9Le+Hi8fs8U1wqx4vhZzfPCiHZqi9u5gFc/7p9Bfe
	WsQqj+0nii/n7dnUcGr8M6YN3eErEcpqO6UT/GzpdRH67OCO65K+mgJRpg0VO1C5
	CP3X6e2kAKUsBDm2eCGJwNz0bAi0n7+iNO98lkmf1rgvoaxS/7GHnPXnFpcxlu74
	SafWYQvkruQsjwGB/vHPREo/sGGGKwvFRPDwlb0x00Rx5/p4qQ2bbvXynHocUpbI
	I6BG/z8G5LHWLK6tzEYYrLWdKSzjFyq3scyWycSZEeRKeJXhqDNxd0/3XhK85JoY
	HhIh/OuyjuW5EoVh4U7lxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1720122290; x=
	1720208690; bh=Oov9piig11BcDOtLEPIu5MW4Xorms/bDxdNG3mKNI9Q=; b=S
	r7RX3TfTtJ4t8Hy9P9UavQOtiP0Wd2rxCfu9K2QZEeXWvzYJ67IqkV/w+BUgqU1w
	4tNfBGYGBaLvMhMpVWs3d2yqlEROkszbeXdyVW+F3uvUottg/U5aXCYLdnG+xtDN
	HTl3Po7A8zwBIgVIV4MYBWSjjwUHBPykcLtDEUraiIescEVBTsCpr2DSHzG6ATNz
	JBCBZ0OHIYOOnHL9C7j7hSuHYZj8Hv0OtP/Or9uK1y5lES8KsXGXcvcXFoZS6fJp
	CCJRwPZqBKXBH2FJp9d4xl/Rvu8V/VqbFgzO382vwKtsn7X3+6eYFnWy02zF8ABt
	bsAVercGaagCZNofrkWZA==
X-ME-Sender: <xms:svuGZtujFJtj_ZRz2D4S-rS-_fs6Rn_hitFaQlKaarDiCetbNsEbDA>
    <xme:svuGZmei2tLZ_aChJ2Yf9d4MtX7yyQh9h65CwQwa324h9677unXJO5PJJMrH7LVew
    Qs4_WpuQmGnlvJgd3M>
X-ME-Received: <xmr:svuGZgwIVDWcmGE9JQTVz7qLyIFaMR9oGj0eYV9O_VQ2Bjrtzfa2ID3boxSaj_IT-dY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudelgddufeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhffpjggtgfesthekredttderjeenucfhrhhomheplfhi
    rgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpeefkefhgeeuieevtdeuhefhhfdtuddvleehvdffjedtieev
    ledvieegueejleejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:svuGZkOh9Uvypo74GRD2TQtqbN6DS6HnH9HxV7gBjwugDCEXgkO4Ug>
    <xmx:svuGZt-ffwYojsOv48S4-2250d49R3V7rPtYi3eYfo9Q8MW4rqkN_Q>
    <xmx:svuGZkUIdLImcqdW6LGDXOTbKHlxcZ_WokBnTzpr-nlp3VGU5AlrYg>
    <xmx:svuGZucUDyMsQ8drK1n3tIKhRMJ36zPvhAE5-oVrEu8X5K8x_1XCBw>
    <xmx:svuGZmOU3WfSKgl9-POpT5sbM9P3IyVBgSmjYwa9dIx69HOiWIGfOMtV>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Jul 2024 15:44:48 -0400 (EDT)
Message-ID: <ecb6df72-543c-4458-ba27-0ef8340c1eb3@flygoat.com>
Date: Fri, 5 Jul 2024 03:44:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240626063239.3722175-1-maobibo@loongson.cn>
 <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
 <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
 <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
 <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn>
 <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
 <059d66e4-dd5d-0091-01d9-11aaba9297bd@loongson.cn>
 <CAAhV-H41B3_dLgTQGwT-DRDbb=qt44A_M08-RcKfJuxOTfm3nw@mail.gmail.com>
 <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
 <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
 <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn>
 <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
 <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn>
 <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
 <bdcc9ec4-31a8-1438-25c0-be8ba7f49ed0@loongson.cn>
Content-Language: en-US
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Disposition-Notification-To: Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <bdcc9ec4-31a8-1438-25c0-be8ba7f49ed0@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2024/7/4 09:35, maobibo wrote:
> In another thread I found that Jiaxun said he has a solution to make
>> LBT be a vcpu feature and still works well. However, that may take
>> some time and is too late for 6.11.
>>
>> But we have another choice now: just remove the UAPI and vm.c parts in
>> this series, let the LBT main parts be upstream in 6.11, and then
>> solve other problems after 6.11. Even if Jiaxun's solution isn't
>> usable, we can still use this old vm feature solution then.

IMO this is the best approach to make some progress.

>
> I am sure it is best if it is VM feature for LBT feature detection, 
> LSX/LASX feature detection uses CPU feature, we can improve it later.

Please justify the reason, we should always be serious on UAPI design 
choices.
I don't really understand why the approach worked so well on Arm & 
RISC-V is not working
for you.

I understand you may have some plans in your mind, please elaborate so 
we can smash
them together. That's how community work.

>
> For host cpu type or migration feature detection, I have no idea now, 
> also I do not think it will be big issue for me, I will do it with 
> scheduled time. Of source, welcome Jiaxun and you to implement host 
> cpu type or migration feature detection.

My concern is if you allow CPU features to have "auto" property you are 
risking create
inconsistency among migration. Once you've done that it's pretty hard to 
get rid of it.

Please check how RISC-V dealing with CPU features at QMP side.

I'm not meant to hinder your development work, but we should always 
think ahead.

Thanks
- Jiaxun
>


