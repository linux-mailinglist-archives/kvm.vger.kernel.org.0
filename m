Return-Path: <kvm+bounces-29439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AFD99AB7C7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5A57283829
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6451CC8A1;
	Tue, 22 Oct 2024 20:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tKu8tDOs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1DD1A2872
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629614; cv=none; b=bq5WdwNomjTXlQWipyBi72LrvCaUlii9bgmITHhByZtDgTFsZxi6zeP09sFCfPMxMYMeM9FHR5WTjnmxEqwYx0wBjnzc/vcKAqpSyazEHiPh/X9pEVI8zdlI9RjN4O6qhGjvSG+6EIf201YzTHRRpXEXlRwX0QMAw5BQkju7oKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629614; c=relaxed/simple;
	bh=qvG9H2rQCuMb8g+05Ev4U0/JOsAKRwDrwfS8a4lVJN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=suoCKJXnAyp/ylYn9kMAY8nA7CegqcimgFbmHFSzrkF6eJvwIKmBgzx+QrTgLlH5zXlTKZFBxQzjZCZhFyBfiY0M4fmgN8oJQVXGauSMwuRjhtggLZh8KmzvFF9nmGwX0kP9Kg3u39jwge9v8TbIa6L+zfm36x3ac++wl/HhQ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tKu8tDOs; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-208cf673b8dso59341855ad.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629612; x=1730234412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qvG9H2rQCuMb8g+05Ev4U0/JOsAKRwDrwfS8a4lVJN4=;
        b=tKu8tDOsrUa0lugH0gcsniE/7SanJBIFdcNL4lGUn5UvCu0QKtNtY7teZQftnLKzFN
         4OT64dkUu1rcbAPd5wZFz9kgLwQQxuJDGyk5lUYJjNqV0n4X9s7h9BW2YmsO5vDcHTEw
         GUQyOYeoU1k0bk4sf9pCSSoIw6H4XLJLpa5JUEcmr1+h9J1ZNGQ2sCMjQr5GHzeWmlmk
         ps0YywptNlJDO57LFzWg/j2squRsxK81k8dltb8bvXU8jewxK2bXmPKqBoA9joQlPJQi
         eeSy4Alqkal3iortBMQpkwkYDdrxSVjZnLcI1jMHswIuH9HQuP9QGL981q7sqEVGx3NY
         d/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629612; x=1730234412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvG9H2rQCuMb8g+05Ev4U0/JOsAKRwDrwfS8a4lVJN4=;
        b=A2AzKwQIBMT4B+xDX62RuFTqrmVQIkOseIBF3pxndDY6AC7Ee7x4tuyKJ/grfN2ihy
         ZExoJH8R2jf/az16uLIFFCW6ws0vH/3GTUqNjIFZFUC7qa0Kq6hatrsEh8RakU+EQ+Z/
         umzb2Io6n2IUJBEp/tyH07HEywI8FwJryDAQt4LZAb2s954J8Z+hDXffAxCJ3eIz2PNg
         kEJ6+EjZZ9jBsQqRxWNBFbPECdJpwvdG0wMQ0sanJ/bWFB0OlfzhwEmJtSweO/FMzJwW
         9WWP8xjnqJcigiOMsfN1+UYNE1AB0FlaNiKBRlhAuY8fUmYVKbLxU0QFRsCgHbsgaLak
         Ur2g==
X-Forwarded-Encrypted: i=1; AJvYcCUgkB2a2zZZUBB6i+GdAXDWJAg/oZzAs5ZrBaGJVaRk4I4jWxdvhpx1TwTD3m94ZEWw4MU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKaLsXZLP7mOBJOkHLaIGN1M0cyw1gnjo4MypzxKjql4znHOZ4
	yeidLyhCJG+mKTMjyMlEzIGcsXVaSZx6sbPFSzPrgcOKjwF5aFSzzlSMi6OheIU=
X-Google-Smtp-Source: AGHT+IGhsr68xM+2DHDRmM+aLh7jGtiUs902lD0R0BSuVY69oA/h0YUu892mfTNoYvuF23qCg4Pcxg==
X-Received: by 2002:a17:902:ecc5:b0:20c:e6e4:9daf with SMTP id d9443c01a7336-20fa9e48be4mr5302095ad.13.1729629612404;
        Tue, 22 Oct 2024 13:40:12 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0d9a67sm46441425ad.185.2024.10.22.13.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:40:11 -0700 (PDT)
Message-ID: <78c6f080-7722-48dc-a4c7-a7345155f2cf@linaro.org>
Date: Tue, 22 Oct 2024 13:40:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/20] MAINTAINERS: mention my plugins/next tree
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, Laurent Vivier <laurent@vivier.eu>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Yanan Wang <wangyanan55@huawei.com>,
 Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 devel@lists.libvirt.org, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Alexandre Iooss <erdnaxe@crans.org>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Riku Voipio <riku.voipio@iki.fi>, Zhao Liu <zhao1.liu@intel.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-17-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-17-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gTWFrZSBpdCBlYXNp
ZXIgdG8gZmluZCB3aGVyZSBwbHVnaW4gcGF0Y2hlcyBhcmUgYmVpbmcgc3RhZ2VkLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3Jn
Pg0KPiAtLS0NCj4gICBNQUlOVEFJTkVSUyB8IDEgKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRB
SU5FUlMNCj4gaW5kZXggODEzOTZjOWYxNS4uMDJiOGIyZGZkNiAxMDA2NDQNCj4gLS0tIGEv
TUFJTlRBSU5FUlMNCj4gKysrIGIvTUFJTlRBSU5FUlMNCj4gQEAgLTM3MDIsNiArMzcwMiw3
IEBAIEY6IGluY2x1ZGUvdGNnLw0KPiAgIA0KPiAgIFRDRyBQbHVnaW5zDQo+ICAgTTogQWxl
eCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiArVDogZ2l0IGh0dHBzOi8v
Z2l0bGFiLmNvbS9zdHNxdWFkL3FlbXUgcGx1Z2lucy9uZXh0DQo+ICAgUjogQWxleGFuZHJl
IElvb3NzIDxlcmRuYXhlQGNyYW5zLm9yZz4NCj4gICBSOiBNYWhtb3VkIE1hbmRvdXIgPG1h
Lm1hbmRvdXJyQGdtYWlsLmNvbT4NCj4gICBSOiBQaWVycmljayBCb3V2aWVyIDxwaWVycmlj
ay5ib3V2aWVyQGxpbmFyby5vcmc+DQoNClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVy
IDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo=

