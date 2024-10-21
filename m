Return-Path: <kvm+bounces-29298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ECCE9A6F1A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 18:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BAADB23239
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 16:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B161C1D432A;
	Mon, 21 Oct 2024 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tVYAqz5H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0271412D1FA
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 16:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729527145; cv=none; b=aaB8fXCwgCux3nSjNSPDvoFoPCLdCSzoLffpJt12eThZWI+MQBUU42Drt0R4TYwrBRs9Wz/SxA9pJlHgb0p+nhuvZF5reObGYkLecsMRbTjYTfKCxiKUeO/yo26jAoYJTT+iKdydOs9Ibbfv4x8nAAIJC2FYzlMaIlRkQikRwmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729527145; c=relaxed/simple;
	bh=4tyI9HMcw+oed3UoyTiS3Y+lP3POZ+ihsONfL3iJWRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSSrfO8Ss1v0DskFnqahAfroQesHKKEPHhGANhNvxEvF8Vwx7vVbXLwYqlwnKFW3KRuBaPPWNlatiCqnInPUFE0Pw6RIi+gGtFVK1CIcZdKlsWySATvBzTNMnFr9360nn2Z5iUdlbmkqAVEE0idNpTgkTWoGSSu0IQ5bDyktrsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tVYAqz5H; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e2b549799eso3388446a91.3
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 09:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729527143; x=1730131943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4tyI9HMcw+oed3UoyTiS3Y+lP3POZ+ihsONfL3iJWRs=;
        b=tVYAqz5Hsmmp8U4fNq6fzbR/gkywkhoTICVHSXgDeBhZixGFSsEgj2m2j0jHHpQQJz
         o7JBGP4qKYf9ODyq/krNBVXnW95mexYO5jQyj6OhzhD9zh1BnRDfbWgPF1ZWKsg1O1Gd
         BIRGoYmkwzSq0unaQD0/riXiKvfEpOmOAFl63UCaJ/rBBS3bjkIuXa0MsBZldGOOKTJ3
         ZMLivBNU4tFyQX0eQI2uap7gX/J4NhLg7nZNFQ0E0llJqx6Ge7Xpvwg2CB36Rn0QtG7P
         oMeRid7+W6sjdcF9VZPcZeAcq2CHTm/dSeXTOpmOSkKt7YDwE3Eff8fKp0Xxe8OaR5Wh
         kixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729527143; x=1730131943;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4tyI9HMcw+oed3UoyTiS3Y+lP3POZ+ihsONfL3iJWRs=;
        b=ST3huxrvbr6hCsPNhDx5/dGNIcTBZV5ODwv5PJTWnKocdjEwt8o/ocmxuwxQhTE17p
         CdgZxapsNt+6O9RhOGeyvzpKmWiIkMT+0lAU2hsHzZS9KkbxHuNlcd3D2cy6ENpAhbgR
         QMZl86DyFdLMPcpkjBTBDbal0s+YmLX7gmVHY5LD4v6Rcm4JXNmaFJUzIE99jJOp5UO9
         +4hUapGLmmN+5SGy0eg0l7boPl1i1KWAVbpvF1tmdWU0BXW+XM/Cxr6PxHyDD8OolThn
         e7CTzQGD+nPAoIEvlCxWjSsW1RTmQPfBXU87L4EiWPOXQp1EabN+UMMZ/jH/a3aBZXS9
         WW7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWu27nOUt321WBMEyzhR1Fg2gdLHG91N2nxAkILiwNHrSaa+HIz2HZvklYeWnN3TjTZ6cg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaNe2Bd7YDDCQj/lbr1P5VlNdMUgbXquC6XdYXmLLI1qapDqI8
	cwWA4ZHi6xN+lePw7eEeTSUPpSQzVC/WM6wF4G2+rsmmZOsa9rfj87T4EO2gFl4=
X-Google-Smtp-Source: AGHT+IEJ79rcO7UvywEBODvgpNUBrZrniDJFce4wT3Aa2wPLvxVw7ShFnIcwMRwswCfdTaS4rxYemg==
X-Received: by 2002:a17:90a:f30f:b0:2e2:bfb0:c06 with SMTP id 98e67ed59e1d1-2e5616e893fmr13956844a91.12.1729527143007;
        Mon, 21 Oct 2024 09:12:23 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad388effsm4015553a91.34.2024.10.21.09.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:12:22 -0700 (PDT)
Message-ID: <58f35342-76a1-4de2-901e-0e138232af57@linaro.org>
Date: Mon, 21 Oct 2024 09:12:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] build qemu with gcc and tsan
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-s390x@nongnu.org, Beraldo Leal <bleal@redhat.com>
References: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
 <87wmj0ypwe.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <87wmj0ypwe.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8yNS8yNCAwMzo0MywgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBBbGV4IEJlbm7DqWUg
PGFsZXguYmVubmVlQGxpbmFyby5vcmc+IHdyaXRlczoNCj4gDQo+IFF1ZXVlZCB0byB0ZXN0
aW5nL25leHQsIHRoYW5rcy4NCj4gDQoNCkdlbnRsZSBwaW5nLiBJIGNhbid0IHNlZSB0aGlz
IHNlcmllcyBvbiB0ZXN0aW5nL25leHQuIFdhcyBpdCBsb3N0IG9uIHRoZSANCndheT8NCg0K
VGhhbmtzLA0KUGllcnJpY2sNCg==

