Return-Path: <kvm+bounces-31988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B20E29CFEB8
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 13:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C1B288250
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 12:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A74192B85;
	Sat, 16 Nov 2024 12:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="CVJsLSh7"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01819161;
	Sat, 16 Nov 2024 12:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731758575; cv=none; b=OVhBxGrYyZyrxIZk2WI06hW70JKyJwIOAxJXA4mk1cKE9qLyH/8nkspvtWCv2uSuJKFhcPum5ML1Vea2omZ63uAQ47IHAYyUUJu3x9Y9jPnv1iAcJNOPFSKOBR0+1Ny8UI5feNQgMuiaf4VUzdVgNp2QF/MfptMd9ruGHzKZDzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731758575; c=relaxed/simple;
	bh=+6BwE+j7SFSJBdNyvj9o//BTS/JqF77TAt/XJWkTcQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ILJuvlFuaIuQulzL7qF/YrjhcfR+rQVmvoUNqlznhNhdZlKmXZm85QLaeqEins3uvanVPIApvErkHQPRX19K4Cm8c4wEJAoUAUKzEgUhmKg20oS8amyUpe3zt7Q12aUSvcZpKLA7EDfDyOIYOowQt9qpXEXbEPUaz5Pim+gQRek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=CVJsLSh7; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:4fa4:0:640:dbe3:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 1264F60B90;
	Sat, 16 Nov 2024 15:02:49 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:31::1:15] (unknown [2a02:6b8:b081:31::1:15])
	by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id l2N6KV0IfW20-Gtqliq6K;
	Sat, 16 Nov 2024 15:02:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731758568;
	bh=CbLqFp8H8sKI46dz9m1uDWAKRsbldfMKqdxquVnHhKk=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=CVJsLSh7jF4f4rdWP7xa//jccFzMgvmz/fXtVoHa1oDseHrYMgE47jsqm/K8BkbKb
	 613qj+FOFRmCvG3BTJRZ/iBgqZFoRHbTzLcjujwfqKLk/KQFD5UQ/WTspOYsEqawre
	 +QOYHEP9C/7u86LuOwq+j+n93yhTnEcUBu0drcjE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <4d58d221-5327-4090-926e-a9c21c334ed4@yandex-team.ru>
Date: Sat, 16 Nov 2024 15:02:47 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] x86: KVM: Add missing AMD features
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
 x86@kernel.org, seanjc@google.com, sandipan.das@amd.com, mingo@redhat.com,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241116114754.GAZziGausNsHqPnr3j@fat_crate.local>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <20241116114754.GAZziGausNsHqPnr3j@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Hi!

On 11/16/24 14:47, Borislav Petkov wrote:
> On Wed, Nov 13, 2024 at 04:30:40PM +0300, Maksim Davydov wrote:
>> This series adds definition of some missing AMD features in
>> 0x80000008_EBX and 0x80000021_EAX functions. It also gives an opportunity
>> to expose these features to userspace.
> 
> Any particular, concrete use for them in luserspace or this is a just-for-fun
> exercise?
> 

Yes, BTC_NO and AMD_IBPB_RET are used by guests while choosing mitigations.

-- 
Best regards,
Maksim Davydov

