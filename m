Return-Path: <kvm+bounces-60481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F2ABEF6DE
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1909C4E7C21
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6D22D323F;
	Mon, 20 Oct 2025 06:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HeW7cECg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953071C3314
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 06:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760940667; cv=none; b=YYCnJjXbdJninzF1pCWFjAeNXK/fzQqW72eWF1jiNyYsDM2GOmZIAXraMUhMHcwEWVuGXJzyakN3LFsQU2YiluIHPVigd5y+LQUNnbATZhQFlHLfuPOZrCmd3U/m7yl/NgPw3IjLJm8e3OHgHiNoDOLljrKEVLaQN+TUu5UTtro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760940667; c=relaxed/simple;
	bh=T01d8e59ZtEuTm+OhQGUM45E4KMp/ScozHzX1NI3+/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRmMduoBfguQ2wosGoVcrpXQlsoTQZuAz0yRUG079agmFQqYv+je7AnUNXD8d1pmUciiCEY3InR1896NoWXQR6L/7X4tOTjaeL7BynRZlv7vkyPERtjm9ykMoN2/V0YDd8RQ5lZgtM9xNYl2VaqL87FgLDh0ZLzX/wmw+7l8SQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HeW7cECg; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47114a40161so42987495e9.3
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 23:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760940664; x=1761545464; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BXXOrptoc81LnYXKppppXYtM6aRpFMZHfbgbW/Xv7a4=;
        b=HeW7cECg9QQUTBTOJQ7Wuw0B3VyZYh2N4n0hiO5tdtyrppzT8HxqDq4NlOA92/Db1X
         Xy7xKvYmPfaqoibA7lbhlT9bMyhxq0szdpTzF/lJMOkvxAyB8Rcyk8lIFv5JrDUZL9nC
         R3VPUI9x4iOG5WgfpiUmjddt6v/9y82OTyAgxYBhWL7er8fFS72JW5JmXBPO5PcSa2kE
         +iLhI3tYModRCaX7zKif8UaehkJRmFVXpfRqGlpqCURV3RdYH2/DsJ4vaFt/TujzpLPL
         nbFNXzR7sTjUPnb3SVj+0MZAz59XHsWjRta2trWs5i3sgjKYb8u+UvIAXQLAu/4NnZRE
         TyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760940664; x=1761545464;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXXOrptoc81LnYXKppppXYtM6aRpFMZHfbgbW/Xv7a4=;
        b=eENdJsb9Qt8CY7m84por/4eXYRsRnLtw+4QpYclAtwgQ7DfzhgOIJVzadRJtddv9qm
         WsT9+W9kvUtZbvuTYLWp+x36u8fWUsxcTQTjmb4Is3gpMHmcxl+5lTfzJSDlRs7nogKF
         vCSjmoAvYVKKuWRvk0Nj6uDiC5yXGtaN+zBnI65uEeIp4LWwpa9c1djeOwgHdr+90yyE
         L3h5YomWCLEsCT5h32DMC6V/lRLrM7QiLQv0IUZklT92tZmBLUjv+IDOH+KZHg2NW9Bc
         CiR1QSiFoO3IQo8YTanOPqW5hWwLXdKkpitEQLO2w2N3QpiiJPzMhICSllboJ3psnzSB
         4rKg==
X-Forwarded-Encrypted: i=1; AJvYcCU7HU0U3xbd8kg3VfAElXprEnY7CI+87+a6QdOYgrDSdX6Bv2RCqGcKSva64o9JcTn6Amk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyYHd4tL7Yd7HH78UVMNPfzwQWEvRr3yEEkkthC7FrwFSN/4IQ
	mirrahWLfIlO5S7hUS75lXCRRZj8Gb6jjF16dSg+FCPcL2/Ej04a5CJrijwy62oAX5k=
X-Gm-Gg: ASbGncs2XIO2LKtVSLO90OcBf0SjYe0FE5mVIN815rrnOIBL4Y+NAMorfAMxX/V7Hkq
	AkJ0dMdelO/DWYQPn4M9QBwo+wEtnTZm3vW4VpiVrg2CmK3TBCRgj3RyQ9jlWBYW2yUlSfS1/Kx
	xCxd+nF1VE6ot1jAkO9xxUraIWN+czxbGjXcL3HOlA2o75VGpEQzzx2Y8cUxvgC1eM/EMsHT/Ii
	dk6/tx1KXddB2MNACWZ93SyLl7k9DU73s4K/a5Xk4j8O3Q3bNo0Fu9oeRISamplzUzNb3e3bHxF
	qDdL0yaytG1smInUux5mTVR6MM9bim1G8fNkjxdvdCPJts1rfa8jomD58TJWWLZWfSY8wmcB79Y
	pqtEuPXJRv8IdPhx04V1s6rD05gGnDhELAvhvMZAnGyw+lvmWL4bDTgR7LuWWJd5616XmGoNHMJ
	OIooSVQRQgfHBIPB0PadXROBOU0pU9mRzSIs2Y08s5vdgvVKochOblfg==
X-Google-Smtp-Source: AGHT+IF0GrnqoFiHhiKe1Ey1S/CfiDmlKMI9HdKRO5gAV9PLkQgkhZmoQt3Osb6YwY7GwqbTcbMXmg==
X-Received: by 2002:a05:600c:3550:b0:471:14f5:126f with SMTP id 5b1f17b1804b1-471179141cfmr94029375e9.33.1760940663812;
        Sun, 19 Oct 2025 23:11:03 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce3e2sm13494720f8f.47.2025.10.19.23.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 23:11:03 -0700 (PDT)
Message-ID: <127dca3e-bc84-4626-b0bb-50eb5267f878@linaro.org>
Date: Mon, 20 Oct 2025 08:11:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] tests/qtest/ds1338-test: Reuse from_bcd()
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-11-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-11-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:03, Bernhard Beschow wrote:
> from_bcd() is a public API function which can be unit-tested. Reuse it to avoid
> code duplication.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   tests/qtest/ds1338-test.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


