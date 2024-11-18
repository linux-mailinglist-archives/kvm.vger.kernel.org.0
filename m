Return-Path: <kvm+bounces-32014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CF19D12A4
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 15:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B2041F2256F
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 14:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9452D1A9B59;
	Mon, 18 Nov 2024 14:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="OCIxLpQi"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B61A9B3D;
	Mon, 18 Nov 2024 14:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731938847; cv=none; b=miNcda2vcfJoLsjrHpE8zoElugWUmXzWB+6eY9binacFeImDOsBXQ05uTYUR0Z/cIzit3BiMIGNJaJAgsN0kIqCzJdkHzibD9eODWSevuUtWNRgAPk+cUa3wiTcjcVR2HSWGIcitf6HxfjqTWYZ9rWcWvLZuimEGzI6aGm6mQe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731938847; c=relaxed/simple;
	bh=3z/fVqingyODNLkesaCYnIB/Qxlla4k8wlBWn8qBctg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9pegQ2LqpwAWxHzJ7y8itJmwxyql1/Lp5Zq7MW1djbzAwAl3gYKs5LSqwlYHhL/88Qtv9V0s8XwhB97IHOH5zJE3EuKnn8U1VPG7GlffC4khDDL649O3M9yK0A2OPTQbfuGw+t/APKTIySqb6ammTiRA6h/atamevhJyEojoWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=OCIxLpQi; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:1814:0:640:37e9:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 2F67E60D0B;
	Mon, 18 Nov 2024 17:07:13 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8011:701:66e1:20a5:ba04:640b] (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id B7RqxU8MbSw0-WRKDLfld;
	Mon, 18 Nov 2024 17:07:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731938832;
	bh=t97plkG1BrE7Xma2RzL1YP2+9jrAMXHtSV6iBBEet0I=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=OCIxLpQiomRWmpBFZ1UcAx+a7csJ+Pw31RldWiawoJkbu5+N2FZXQ2g/cUvUpSOng
	 Ut0fPTjaQvLlZJtniwa5PliUJTdFiFXRr6L4vytQNHvorz7aT6giHzVmn9j2/aYjDn
	 QwB0wsVY2DPgPLg+EZBy4Hm5Iy+ZaFkGhdBa/2+U=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <80e826c5-5f0b-4d6b-b69c-96226cab0adf@yandex-team.ru>
Date: Mon, 18 Nov 2024 17:07:11 +0300
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
 <4d58d221-5327-4090-926e-a9c21c334ed4@yandex-team.ru>
 <20241116121053.GBZziLzfKuQ7lyTrdX@fat_crate.local>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <20241116121053.GBZziLzfKuQ7lyTrdX@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/16/24 15:10, Borislav Petkov wrote:
> On Sat, Nov 16, 2024 at 03:02:47PM +0300, Maksim Davydov wrote:
>> Yes, BTC_NO and AMD_IBPB_RET are used by guests while choosing mitigations.
> 
> How?
> 
> Basically what the current code does to do retbleed or IBPB on entry? Where
> latter means the HV allows writes to MSR_IA32_PRED_CMD...?
>

Not sure If I understood your question correctly, but I meant these two 
examples:
* BTC_NO. For instance, we want to create Zen2 (family 17h) guest on 
host with Zen4 (family 19h) processor. If guest doesn't have 
X86_FEATURE_BTC_NO, blacklist will be used to determine whether CPU 
model is vulnerable to retbleed or not. 17h family is in the blacklist. 
So, the guest will use "untrained return thunk" or another retbleed 
mitigation. But we can expose to the guest that host processor (family 
19h) isn't vulnerable to rebleed and improve guest performance without 
any security risks
* AMD_IBPB_RET. On AMD we can pass through MSR_IA32_PRED_CMD. So, the 
guest can use IBPB on entry to mitigate SRSO (instead of the default 
mitigation). In this case I don't see any problems, because KVM allows 
writes to MSR_IA32_PRED_CMD. But AMD_IBPB_RET is used to determine the 
appropriate stub in end of entry_ibpb. Without exposing AMD_IBPB_RET, 
the guest will use stronger mitigation.

I don't have access to Zen4 host now, but it seems that both of these 
cases can have an impact on performance. I can try to measure this 
impact later if needed.

-- 
Best regards,
Maksim Davydov

