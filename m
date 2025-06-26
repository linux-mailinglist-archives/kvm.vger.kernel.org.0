Return-Path: <kvm+bounces-50836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF02AE9F5C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:49:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DBC45A2F3D
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 13:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF852E6133;
	Thu, 26 Jun 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tum.de header.i=@tum.de header.b="jEZ9FNYI"
X-Original-To: kvm@vger.kernel.org
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F212E762B;
	Thu, 26 Jun 2025 13:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750945753; cv=none; b=lAAIMbwkR0eoVTgk6Rv8o9dtPNdOshpfsMOA/Ttkg1AmSqWazkMdSwCMqgxMl/QBxetmxw3Lrjh8AG+k5F2wwvGXToAV0EsOPesWXBTCF8vs5/ym9IP5AbVmrqOsAbs7X2p3zJz2TKnvP2o0k6AYWQqoYtOgHRPxrfh8thLqriI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750945753; c=relaxed/simple;
	bh=9ETa/aMCfVnorl4nBQFB5QCxuCy0bZmquwrSjwaYyjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2aTVK8jwUn5ZJfbkeVUaKzvy5oUTsTk3o5GGQhAcg/ReIFg+L0uftaTxCY+Zcbpj27Iv4Pxr5QpGpwZn95mfvL6b2NF26n/USObKwOpe2hbpdFNB2AGiYFvB0EI7c3EXSIJoWNzPKuj0ElG+ICcHJ+Zq4lu9VWStiaMZMkcQdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tum.de; spf=pass smtp.mailfrom=tum.de; dkim=pass (2048-bit key) header.d=tum.de header.i=@tum.de header.b=jEZ9FNYI; arc=none smtp.client-ip=129.187.255.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tum.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tum.de
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4bSg5X3Kg3zyTW;
	Thu, 26 Jun 2025 15:49:04 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tum.de; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=tu-postout21; t=1750945743; bh=Vb0qfFuOWjHfY85Vsrj1qe50SGMWpv
	uFukEEzkrwbjs=; b=jEZ9FNYIQaR4FmC1BeBaDukV2FkAwkzNuwJK2y0e9k6S4c
	eWKr6WGJdicdljqHFiH+IybG3EBpX2U4WHMeJFBwJwYDC8Be5HUkQQT6u7SGuIZM
	kP6Hs/PDHTNhROt1rGSUULiAcMr4mQA+fYJdRID55DDVoZl3V8MM4kGqTsqWNH0g
	m3ivgNmaCOr4Wdm5HmgLUHqT3B8F5ZxbpIXa0cRTtt9t2R5jhcfPhuQdr+DxfnYA
	fkgRL7KQC1zHvMxpyNAwGWu4MbvOzd5JUFlGKYvi4byD2ByOYaX2bX8Id4R6zUt+
	7P+MRoe3MstEHtCN34vYpWLpOLL6US0zCPEpy1DQ==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.868
X-Spam-Level:
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id 774kSpfJgTYp; Thu, 26 Jun 2025 15:49:03 +0200 (CEST)
Received: from [IPV6:2a02:2455:1858:e00::6d26] (unknown [IPv6:2a02:2455:1858:e00::6d26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4bSg5W2QzNzyTJ;
	Thu, 26 Jun 2025 15:49:03 +0200 (CEST)
Message-ID: <15fa8a27-958f-42d2-ac1f-0fce248cfc1f@tum.de>
Date: Thu, 26 Jun 2025 15:49:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/hyper-v: Filter non-canonical addresses passed via
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST(_EX)
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, pbonzini@redhat.com
References: <c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de>
 <175088956523.720749.10160134537876951534.b4-ty@google.com>
Content-Language: en-US
From: Manuel Andreas <manuel.andreas@tum.de>
Autocrypt: addr=manuel.andreas@tum.de; keydata=
 xjMEY9Zx/RYJKwYBBAHaRw8BAQdALWzRzW9a74DX4l6i8VzXGvv72Vz0qfvj9s7bjBD905nN
 Jk1hbnVlbCBBbmRyZWFzIDxtYW51ZWwuYW5kcmVhc0B0dW0uZGU+wokEExYIADEWIQQuSfNX
 11QV6exAUmOqZGwY4LuingUCY9Zx/QIbAwQLCQgHBRUICQoLBRYCAwEAAAoJEKpkbBjgu6Ke
 McQBAPyP530S365I50I5rM2XjH5Hr9YcUQATD5dusZJMDgejAP9T/wUurwQSuRfm1rK8cNcf
 w4wP3+PLvL+J+kuVku93CM44BGPWcf0SCisGAQQBl1UBBQEBB0AmCAf31tLBD5tvtdZ0XX1B
 yGLUAxhgmFskGyPhY8wOKQMBCAfCeAQYFggAIBYhBC5J81fXVBXp7EBSY6pkbBjgu6KeBQJj
 1nH9AhsMAAoJEKpkbBjgu6Kej6YA/RvJdXMjsD5csifolLw53KX0/ElM22SvaGym1+KiiVND
 AQDy+y+bCXI+J713/AwLBsDxTEXmP7Cp49ZqbAu83NnpBQ==
In-Reply-To: <175088956523.720749.10160134537876951534.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/25 12:25 AM, Sean Christopherson wrote:
> On Wed, 25 Jun 2025 15:53:19 +0200, Manuel Andreas wrote:
>> In KVM guests with Hyper-V hypercalls enabled, the hypercalls
>> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX
>> allow a guest to request invalidation of portions of a virtual TLB.
>> For this, the hypercall parameter includes a list of GVAs that are supposed
>> to be invalidated.
>>
>> However, when non-canonical GVAs are passed, there is currently no
>> filtering in place and they are eventually passed to checked invocations of
>> INVVPID on Intel / INVLPGA on AMD.
>> While the AMD variant (INVLPGA) will silently ignore the non-canonical
>> address and perform a no-op, the Intel variant (INVVPID) will fail and end
>> up in invvpid_error, where a WARN_ONCE is triggered:
>>
>> [...]
> 
> Applied to kvm-x86 fixes, with a massaged changelog, e.g. to call out that
> "real" Hyper-V behaves this way.  Thanks!
> 
> [1/1] x86/hyper-v: Filter non-canonical addresses passed via HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST(_EX)
>        https://github.com/kvm-x86/linux/commit/fa787ac07b3c

Thanks for the quick approval and Vitaly for the Hyper-V testing!

