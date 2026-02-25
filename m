Return-Path: <kvm+bounces-71879-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCDaDY1Qn2k7aAQAu9opvQ
	(envelope-from <kvm+bounces-71879-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:42:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4A619CD1E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8A9903025243
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2454A3EF0C3;
	Wed, 25 Feb 2026 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IIC5qwU1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DED13EF0BA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 19:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048519; cv=none; b=KVqzlmJDqQOf6ehEIRhd2W5RCCNmQ/2ot1tSo2plQh4VJaypZMZUVhA0jzLV5v/S6C/YgUsgMuClv5YfHfOF0/yv6pn7rngaYdXJ7oiMlZFQe0gJtnP1MZlc+Fkmlccw8NyanZrjvR64zIRV+f973vRChscFQkdzCkq+wMFrHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048519; c=relaxed/simple;
	bh=K/ngICjUIFnHkWw4WxJSucf/8kF/MXH2TmrDuxHK50I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSiiymoBY69h+5VsCYtmBZn04QoFo8U0uC8/oYNS1LMgaB/13VVvhx6RN1R1pS6yeRMLFaWFg7U/CkNZuVMrnznbtRlejZlrCPOfP87ZZquSP/3RdTtY2wEGLtyrHxGAHxiW1DJ66Hg6hZUN6rNXnuafPPDYjQe9ubFHiMRkk1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IIC5qwU1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2add623cb27so150625ad.3
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 11:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772048518; x=1772653318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+fBflHpWcOkIAca/ewhCzxrxnxZcU7j3YRsoFPNFwM0=;
        b=IIC5qwU1KaJbAQmLfRS/Pcm4ZmsP8+Jb3OKr7g5OOcGINLv/d1A+uNOoJre0+DXalE
         IJy/AdXb3MoDbTY/y59TZjUqCxSgRDGgySCRXEG7xOMUw1sqFAs+o5CiI4R/Tb1BTfDG
         4ggQiv22NBvnHMCjhkmbfGNtD6dP3Fg65SuVoUm7z+/XLlaf/llHjXoOJStDrSb2Z7xK
         Grl4D3ZbSG1/pdjcY64/Wyl2kXbLgjP+lA4IzX4m9oapMmUNDzuVA9kVKpGPg+k7MoBv
         vkBqbuohAi8y3EdYafT0s7xWeUvKrVFnnolMHNB0EUalWTSoPHXUgIsbqPx152/eHTt/
         ESaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772048518; x=1772653318;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fBflHpWcOkIAca/ewhCzxrxnxZcU7j3YRsoFPNFwM0=;
        b=FAxh6iHRK7vMQCONBZsD2PknEHFPyKfd8o8cEj+Grrkt6Q5qthwiU5YjsVf5rksX7J
         JH5LI0hYqt053k1xB/JWbqRX5TOwNpw5Ig0ynfL/apGX9KeLmfynIzNQDYgmd8g1orCr
         VDGHfcB1PWUiWApKoc0Gwa+KaisqHyRsEFj3wJW2osOVFmMdk3J/rAaJo4Y42Bw0nK2+
         GONaYkVx7bcFaTRoHYuuZp5o7RlwdHv2MRJsJqT0XY+5+r9mLbaIGIhlpy96l/UkabjO
         aIdj1sA11fnAn/qXVm5sp03UQ27Wv31HsPKq7rYUTE4Vy/iPpgAWnbexCFFz+PW4jGh3
         rg8g==
X-Gm-Message-State: AOJu0Ywo+e7PWuxJbwIUePz/P9StcqG46+Bl4Kg3dju+97NsE4x8hMwF
	zCW8/h3eCJ4przdekDQnn0v3CXq/eBgY6589vX+nhnmQ3EF9R8MK0j/MzyYPKrNhAD0=
X-Gm-Gg: ATEYQzxFhS8pCSoNOL0ac2IHX9V/+VtkV9TKFpeN12m9nI+RLDB+zb5UsRQCiwmWEZu
	wGthiiA1WiR2Biu8fnilv0+EbF8JkXiVL75iJtELsWCBQgUCjR+AxOGqZlYRf/+sWFHaveUn0N5
	xrYnK3jgTnRPiIJKVKDvatEiTn88S1qqWzxlcamST/V2Vg9yM67hdml8M/IAqIxyPEOnV+2HZ0h
	fzXP5WNX74u7Dadawd7Gy5dQmvpwcyP5+fStJ08Uegf9nA2w2saJo9PhB+dz6dxhot8m+LOxqE8
	bUiiO9+0/zNN2bKyZXIN3KFWGfDNFvMHiDoRhrBuOVhhG4DI/xiNUPwDbbUvqTuigvfxfOnvca1
	L+X04yibl0rCjejh/mMgvozBAEWTAVOAcytKhlM7kYSYxoEeThXvlsmhY4VzAd9y3HGn6f+yp50
	pAd95RbUSepwXkkZ2glLtO/shcl6bgjdx9tC59dubglrmPhfbiZmo1G79n3wbWGNLLC8sqWCFlx
	5x+b6k=
X-Received: by 2002:a17:903:18d:b0:2ad:ebfb:fee1 with SMTP id d9443c01a7336-2adebfc00c0mr11743705ad.41.1772048517580;
        Wed, 25 Feb 2026 11:41:57 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6b9b32sm113825ad.66.2026.02.25.11.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 11:41:57 -0800 (PST)
Message-ID: <25191af9-bcfe-491f-850e-d5a43fa89c6c@linaro.org>
Date: Wed, 25 Feb 2026 11:41:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] accel/hvf: Build without target-specific knowledge
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org, Cameron Esfahani <dirty@apple.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan <phil@philjordan.eu>
References: <20260225051303.91614-1-philmd@linaro.org>
 <20260225051303.91614-5-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260225051303.91614-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71879-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: CC4A619CD1E
X-Rspamd-Action: no action

On 2/24/26 9:13 PM, Philippe Mathieu-Daudé wrote:
> Code in accel/ aims to be target-agnostic. Enforce that
> by moving the MSHV file units to system_ss[], which is
> target-agnostic.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/hvf/meson.build | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

