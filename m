Return-Path: <kvm+bounces-19479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCF69057CB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F7B7282958
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D3A18133A;
	Wed, 12 Jun 2024 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="raf94pw9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5E116C872
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207802; cv=none; b=CTFr1Gb/vxXrNweNpjzR5CRcTVNiyqv2RvG6eoxo/JgbyNfR/9eSQBUnocriTKe829cy7ICOtM6Oau1ZyLU8dLpKprXlB+5kAysNXcaCYHS46nb68wPQx6Gc4Pdm9eZCTAzgb+CJW12jkJkyIvVRehuqdsSUWHJV/P51qd73IqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207802; c=relaxed/simple;
	bh=C/xS715ze4u55i++yoL/8pno/bPeipAfJy0uowYBN4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAiQOcvFHqvKFLclMLyUNMJQoUx25ugSk9Z3J1fLM6rf2oR/4ox+mKkqdo11p7ApqXy/uaNHWinrbjV9guXrbO1KJY32S1ypN4T7HUZFbK71XAXodQZHdklJ3vWhj+8rZtN2F/pauS7Kuq7V/zZ/gQA7DuSEr0x274bLwhnDMEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=raf94pw9; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-704313fa830so3294169b3a.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718207801; x=1718812601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C/xS715ze4u55i++yoL/8pno/bPeipAfJy0uowYBN4g=;
        b=raf94pw9vwYpMmWQaBsH4NoZJVHtL5hGmoK+oE7QzUlSBKlk2Pgwv/UQBgnsSHHjYq
         /27SJOqgvRagi0AlzMFaI8xNVzUXaGNq8fyYmRcj5Eiol/QvUp3qyIAH8n+8Gh3P5/Gt
         N5Kt/u1Jd82FWDufuv1k/QOctIOIdieeWQ7i04fXMGTiaXsYeqkP/VcAoeu6okExn99X
         gAJw5MLHd1EMQljbk8QdOkbuCXrkS9hsxAik/oCx6z43wB4a2Hj3jOeQJgLbF2wKZTAG
         aUv4aQTo/DGKpK89Q7DJLep4UARaVzXwCtseQXf2yNX/6zoMDUNIrjHPkFiER6r1fU0K
         lC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718207801; x=1718812601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/xS715ze4u55i++yoL/8pno/bPeipAfJy0uowYBN4g=;
        b=FezLs+PqwwvYGo77GNz4us75y1XRHk+JBegX3oBH0kILTH/oH1K8FM0/7/SLjBpYo0
         XWnHOkNFkVrJo8g/S2CYMsvP2Uk8WsUa7fUNa+lM5vegGn/fXNgdKtLe0ZQcyR66O7dd
         A5sDx9BdXBTTCMgzptOWyDt1tt9/Qd1rTONXQDo4tPMJQs5k5XjBAd4eql6V6mctii/a
         052EmYMp6c2/MdTQYhMt6FPOStrcAmb8pg8JPjz3crtBxw5ZWqCfOlzanNbUM9XHJ5Ch
         rGF6ORG1aIs2qyR7eEu5rOhxkFgLOsME4usn78mKWGPwFnq5zY3pVWsEWYVe3tJxy+/O
         r+Fg==
X-Forwarded-Encrypted: i=1; AJvYcCU/X4ZmbN8P9rLXtzMjU17oK2HZZDp3SRmhEWTTDu0Ur5DlZW869Glfi4zylVhyAl1k0DEa3LHnhLU/Bb/qdgGV4pX/
X-Gm-Message-State: AOJu0Yz6rmvceZlUYhEUf0g5JGpCO7dINCat7sUrHwwivf4IO12/3Xx+
	MxVMCc4lPP1pys4huaxVdUcD3ygc1mVsvFNryRr/lhYcFG16HOApcxA0Dj7cbwo=
X-Google-Smtp-Source: AGHT+IGMBCXE2LyecX+AfooXBwHBA7tsWopJGphYysIOn+9ELPlwsGk4Fvby1MO0dabHXRAuwqYMCQ==
X-Received: by 2002:a05:6a20:9183:b0:1b8:a0b3:c9d5 with SMTP id adf61e73a8af0-1b8a9c6891bmr2836434637.41.1718207800904;
        Wed, 12 Jun 2024 08:56:40 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-704140681e5sm9072922b3a.125.2024.06.12.08.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 08:56:40 -0700 (PDT)
Message-ID: <8da3efe5-27cc-4017-a6de-b78e1ad48317@linaro.org>
Date: Wed, 12 Jun 2024 08:56:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] include/exec: add missing include guard comment
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>, Ilya Leoshkevich
 <iii@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Laurent Vivier <lvivier@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Nicholas Piggin <npiggin@gmail.com>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Cameron Esfahani <dirty@apple.com>,
 Jamie Iles <quic_jiles@quicinc.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-2-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240612153508.1532940-2-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xMi8yNCAwODozNSwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBTaWduZWQtb2ZmLWJ5
OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGlu
Y2x1ZGUvZXhlYy9nZGJzdHViLmggfCAyICstDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9l
eGVjL2dkYnN0dWIuaCBiL2luY2x1ZGUvZXhlYy9nZGJzdHViLmgNCj4gaW5kZXggZWIxNGI5
MTEzOS4uMDA4YTkyMTk4YSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9leGVjL2dkYnN0dWIu
aA0KPiArKysgYi9pbmNsdWRlL2V4ZWMvZ2Ric3R1Yi5oDQo+IEBAIC0xNDQsNCArMTQ0LDQg
QEAgdm9pZCBnZGJfc2V0X3N0b3BfY3B1KENQVVN0YXRlICpjcHUpOw0KPiAgIC8qIGluIGdk
YnN0dWIteG1sLmMsIGdlbmVyYXRlZCBieSBzY3JpcHRzL2ZlYXR1cmVfdG9fYy5weSAqLw0K
PiAgIGV4dGVybiBjb25zdCBHREJGZWF0dXJlIGdkYl9zdGF0aWNfZmVhdHVyZXNbXTsNCj4g
ICANCj4gLSNlbmRpZg0KPiArI2VuZGlmIC8qIEdEQlNUVUJfSCAqLw0KDQpSZXZpZXdlZC1i
eTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0K

