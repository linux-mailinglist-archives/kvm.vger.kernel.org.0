Return-Path: <kvm+bounces-40451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA531A57411
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:55:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC723189A235
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A42520DD5B;
	Fri,  7 Mar 2025 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dyr+NKOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09C820C008
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384518; cv=none; b=fUBSRi8HId/MALRY8JBBOeb7TL5jT7HAtP9oW+8zWAe3lRme3KZQcRMTXq3PexA2Wb8eYzEjm4c8Yoz6b9n3MjruGI83em8M/RdDvk4XMG+AjQPjq9HsuEgBIVmbKrfzKZVQe2SqpwZ6P/bBvJat6PH6K1nWyMduy9hqOf0LXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384518; c=relaxed/simple;
	bh=iyKhzciLa27w8sC9sVDvMU2e3ZHeZ+YI/GDbHY0swV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMCvoPLn4h3wf6rYibeb2TZkRvkJqTOxV4B5VQDPbpH+UGQXer8q4NlcMR9BFhVJQ1Byh+58A6IALnSiGpMCzVh5+jHICJeUTTI/4lJrdottOSmj6xlm96RT05sBygh5lVxtbH5Tu/YroyopYtSQZHaYYFpkyaYTiLinaOOGM/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Dyr+NKOh; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223fb0f619dso49485205ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384515; x=1741989315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iyKhzciLa27w8sC9sVDvMU2e3ZHeZ+YI/GDbHY0swV0=;
        b=Dyr+NKOhaxclBY1LKJJjWBb1DvdIf1btJDFkVrFGgd6uF+NZU5Noz+DNewMURQ2+Wr
         tUxdo+uZlEuwFxgDNBT4CKjot+B0xxtJypgBm5xlH17GHwiKtlPxDrWArTKf8LJZ0ckW
         iBW+TzWTZB88vRAs9heZaAhrXZhFFyBs946uq8JaVyyU7TuoIuDqONus5aJiZMrKHvxu
         FZwJACgulmoDneBlvI9fV7NRYIMvmrz8nSEEmIK6+SraS1bo81u2wOFDgeNiMprYds1z
         9LvjFMVkQ3PNggQCPl+kAWSo9oozyiNJaFydMveR1w5eVXdkIcoq2bqlgUsaUnPyx4Rb
         bZmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384515; x=1741989315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iyKhzciLa27w8sC9sVDvMU2e3ZHeZ+YI/GDbHY0swV0=;
        b=f0N6dVCQASYSuluAIVzVQO/r1izXjJrWdPM7xzKMuMqsx7GU8fYPHL+/YstleQhuD7
         0ZARoxHuPoaHyiX1WAJfsWv8aM7J3f8R2odC8WHCExG3WzPcoJXX8AqOmvpW8AZ3YQZF
         g+j6k1YIo7vfPYWVhhcC7cJZ5Ho2hUXdT+kvPHh6eeo+uio88JOF18R1dhEUYtFLrQUS
         FUaBuMASPMxCmlAkch/05RQip4w7ea49oMKIYwUyHi+HNRLbkxuoBanqNI3+vVhdalIT
         alAXq+KJFeX5r1LMmACS3cOP4yRUZYWjq9xOERa9fSdYyYB7GjAOntcGo/agy5sSzNoL
         tUJw==
X-Forwarded-Encrypted: i=1; AJvYcCVCpJTV4SjX/tXST+NEgC9D0/VsD+hlEzS+Br020Q37lyopcXEvfjaOFz2/aO48EhoqmlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwENjX1jR7N08EHvGQFujr6/2ktQ0mtq7lTGo0WW+zhXVzEqLHJ
	oVg8pjTZ5bMNSAuVZRw4gD5C6Yj6KnBW4eJJ8ducyu0dCHiH3V33LncVlRL9Bog=
X-Gm-Gg: ASbGncsLFa1WIrf+aXb/wVLJ+yOLNdHcUJuu2cudVOS1pGPv78/cLnyaXCXHDyuHbZg
	p+nOpx7DRTfurX5lRy4GfFQEVecCZF0i4itDVVjCBNHzzCzEkymDuRD27DcELIKVrgchig+kPn1
	XuZwJ2vWAkKDJzzNLfXrFRU/6YZaiu9a+3NPCe4OZ49JarmkYHzi1t3t0m7II3EnG3o+4/Ymx1p
	B5K3EZLiE9hqneM87p1HDrp1LqKDtvXLz7rgNEirAvBG2BlTDOu65vMVWoXGMObfTdYKVq0sXs2
	aJMmUfA8VtXEOxo/XaDm4YA9tGzuWVuKJk6n4bsu4q8Kval/kFCx3gLuTg==
X-Google-Smtp-Source: AGHT+IHDrXYCnpd+cmLlmmfRn7Cqm+elPiQIIfu6ZdtRoOJxPEmvoxTqenGi2jJ5QT75juc7SA60bA==
X-Received: by 2002:a05:6a21:6d96:b0:1ee:c7c8:ca4 with SMTP id adf61e73a8af0-1f544c92b65mr10302325637.36.1741384515168;
        Fri, 07 Mar 2025 13:55:15 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73698451b53sm3763823b3a.75.2025.03.07.13.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 13:55:14 -0800 (PST)
Message-ID: <98804c05-f3e4-4c64-83e1-df3dbe6c7034@linaro.org>
Date: Fri, 7 Mar 2025 13:55:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] hw/hyperv/syndbg: common compilation unit
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org, kvm@vger.kernel.org,
 richard.henderson@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
 <20250307193712.261415-6-pierrick.bouvier@linaro.org>
 <0e40276f-c9e6-47e1-b70b-5a8b5f8fb30b@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <0e40276f-c9e6-47e1-b70b-5a8b5f8fb30b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEyOjU2LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gT24g
Ny8zLzI1IDIwOjM3LCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4gUmVwbGFjZSBUQVJH
RVRfUEFHRS4qIGJ5IHJ1bnRpbWUgY2FsbHMNCj4+IFdlIGFzc3VtZSB0aGF0IHBhZ2Ugc2l6
ZSBpcyA0S0Igb25seSwgdG8gZGltZW5zaW9uIGJ1ZmZlciBzaXplIGZvcg0KPj4gcmVjZWl2
aW5nIG1lc3NhZ2UuDQo+Pg0KPj4gUmV2aWV3ZWQtYnk6IFJpY2hhcmQgSGVuZGVyc29uIDxy
aWNoYXJkLmhlbmRlcnNvbkBsaW5hcm8ub3JnPg0KPj4gU2lnbmVkLW9mZi1ieTogUGllcnJp
Y2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPj4gLS0tDQo+PiAg
ICBody9oeXBlcnYvc3luZGJnLmMgICAgfCAxMCArKysrKysrLS0tDQo+PiAgICBody9oeXBl
cnYvbWVzb24uYnVpbGQgfCAgMiArLQ0KPj4gICAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2h3L2h5cGVy
di9zeW5kYmcuYyBiL2h3L2h5cGVydi9zeW5kYmcuYw0KPj4gaW5kZXggZDNlMzkxNzA3NzIu
LjBlYzcxZDliZmI4IDEwMDY0NA0KPj4gLS0tIGEvaHcvaHlwZXJ2L3N5bmRiZy5jDQo+PiAr
KysgYi9ody9oeXBlcnYvc3luZGJnLmMNCj4+IEBAIC0xNCw3ICsxNCw3IEBADQo+PiAgICAj
aW5jbHVkZSAibWlncmF0aW9uL3Ztc3RhdGUuaCINCj4+ICAgICNpbmNsdWRlICJody9xZGV2
LXByb3BlcnRpZXMuaCINCj4+ICAgICNpbmNsdWRlICJody9sb2FkZXIuaCINCj4+IC0jaW5j
bHVkZSAiY3B1LmgiDQo+PiArI2luY2x1ZGUgImV4ZWMvdGFyZ2V0X3BhZ2UuaCINCj4+ICAg
ICNpbmNsdWRlICJody9oeXBlcnYvaHlwZXJ2LmgiDQo+PiAgICAjaW5jbHVkZSAiaHcvaHlw
ZXJ2L3ZtYnVzLWJyaWRnZS5oIg0KPj4gICAgI2luY2x1ZGUgImh3L2h5cGVydi9oeXBlcnYt
cHJvdG8uaCINCj4+IEBAIC0xODMsMTIgKzE4MywxNCBAQCBzdGF0aWMgYm9vbCBjcmVhdGVf
dWRwX3BrdChIdlN5bkRiZyAqc3luZGJnLCB2b2lkICpwa3QsIHVpbnQzMl90IHBrdF9sZW4s
DQo+PiAgICAgICAgcmV0dXJuIHRydWU7DQo+PiAgICB9DQo+PiAgICANCj4+ICsjZGVmaW5l
IE1TR19CVUZTWiA0MDk2DQo+IA0KPiAoNCAqIEtpQikgaXMgbW9yZSByZWFkYWJsZSwgYnV0
LCBhcyBhIG1hdHRlciBvZiBzdHlsZSwgSSB3b24ndA0KPiBvYmplY3QgaWYgeW91IGluc2lz
dC4NCj4gDQoNClN1cmUsIEkgY2FuIGNoYW5nZSB0byB0aGF0Lg0KDQo+IFJldmlld2VkLWJ5
OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IA0KDQo=


