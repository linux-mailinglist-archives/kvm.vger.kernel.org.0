Return-Path: <kvm+bounces-41520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 137C2A69A0B
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 21:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87A348856F1
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 20:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358312139CE;
	Wed, 19 Mar 2025 20:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dXWznSoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5CD155C97
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742415328; cv=none; b=Xv9sVlSjhwSWuycv+gcecOxfnbMd7jdi130L3XjXiM70Q0AF1Pt5cPnyjfZ/33fG5bPvlxWVRJba9E8KocbU+5O36aAGlUBCcvoE0OfCIUUWn/Hr5Zesja/72aXBYpUWMRmYefoadDn9N+cMyiVRbHnHoPS2VYd0C/ZKTwReVaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742415328; c=relaxed/simple;
	bh=jjJvlOnU49s+Zbb8733WbLiCItr7uaYdoO51OudCE6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MuELuXF9t9OqssKHdGrYj0FEqzl/SIMld56060OaJhJNY1JrHLn2jdJPc14Xc6wvf7qvUYzUVXgONlM6Y0LiBr1NOEu3TrTep7zqJoB/ZjBchJJNbVtFPAtxaKeeoy76+32qXLPDZ9g0gn7npCTMo/M05Vwa2Q4J7pbeLAqToFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dXWznSoO; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3014ae35534so100867a91.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 13:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742415326; x=1743020126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jjJvlOnU49s+Zbb8733WbLiCItr7uaYdoO51OudCE6k=;
        b=dXWznSoO1SDtdqLg7cgh0munNgBVwTLDLD8ESch8L2sdXWQ9IOSFMFOcwemWfaM0xg
         wlVuXQZtwmIH/i8l8Ls/kA3gW6PTbfHkccLWGMAlykkQnrC8CUhEsgrYVHlzzxvck1dm
         3SUMh8xfvX2CegCRX4+A9iB3P/27lImcL8qL+Bzhh4SGgdatWLJ0Nr8raMqWvrr3Ap4S
         FNarjI1X4rGOpX0YJw+iki95UiEWjNY72yKJiqqjWQRzBnCvuZf8yl3mGAf+ARuotkAC
         NjbbMAzUngvNZPN7/L5mtn1Jm7sFbgIRs0WRgBra2ryINRJTenOpRq9EoOPrD8z4qPJU
         nSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742415326; x=1743020126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jjJvlOnU49s+Zbb8733WbLiCItr7uaYdoO51OudCE6k=;
        b=uwMyUZ5JbqEd1CDT6Scjj5+PYyey+C8Jqx6vT1BnZNoLrWQ6xfUna2zL72qxhKy93O
         Cb2Y2z/xoX5U9wReosXMBcDDmMLRC5gyKjjreXuE1XkqgIQ7xNSn7XCDB/RbWGuGPwTL
         pKLFn5F1sQjBgoU3hV1XBkcZVoJ45eGJirdshrrpbw0rtJbfM1VJaOaKh8BNglo2OaeU
         zj2kbMmiiJqnWq66pvkMzUwWW0mReCQEGZPikCz+iIolccMV1tTYSvKRpHHeqgEpzlIz
         xZ1fOn37fu4OKdF9yAVcjmp2/9OcecsvHncAZ19ZOK3CwKtojmbNXuR0LBBusW63Hs+E
         IruA==
X-Forwarded-Encrypted: i=1; AJvYcCU6+8fqd5rnTG0iVGBylcX7BFDPjE8VBVpknLjadqpa1vrP5EAaU/1qf7cpcusAjlKZ0kQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZgYC39uirns7quEvJixOLAZRMIHjpJ3HNmJDRLS+c/fs4Dd43
	Li7cPDaFPh8R8YtWMkdRmZlwjyp3tcp4sFm9tPvn0psgSHkkGytd+bWgt+AEuF8=
X-Gm-Gg: ASbGncsidjeIY1aWzC4gqDPw9v1X96sEtleAbowONtRRS9t7Ea840v0ZaAPXukF2EW8
	m/eXpcWkYQwZ4VKYdJ+Bb1y8qkfdRkskooXq8s1N6gqkrU3iZY0f1zkHU+rV2Es+bbEHlUpkFuS
	u9WOGN7iEYx0+vgtb7YEv2TA5Zpp2SjMQv+ev7VEeWS3xg46IUJnPE7g8EtO9x17HoFTUnW0EQj
	ohrYEev+/6dPHf2xU/Bu1oIZqaiEbtXoohm/dxl9b6RzoFbBJMhCVVRE7PGAZjeOZINfqX0Q9M+
	OMIC6l7y1HRTm0GKoGzyJmhQphu6FluxoJquGyRj3Z2pIv40k9XzJZLoHw==
X-Google-Smtp-Source: AGHT+IG/qfPdy626hThIYa/RsoZd8+ixXNZ5S+14ncTQSUR3/THRotw28A4RHNR31RiMxmmch69q8w==
X-Received: by 2002:a17:90b:1a88:b0:2ff:7331:18bc with SMTP id 98e67ed59e1d1-301be202b7fmr5479737a91.26.1742415325934;
        Wed, 19 Mar 2025 13:15:25 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf5b80b5sm2116351a91.38.2025.03.19.13.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 13:15:25 -0700 (PDT)
Message-ID: <9c48029e-1921-447e-8b38-4b171dce1210@linaro.org>
Date: Wed, 19 Mar 2025 13:15:24 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 13/18] system/xen: remove inline stubs
Content-Language: en-US
To: Anthony PERARD <anthony.perard@vates.tech>
Cc: qemu-devel@nongnu.org, Paul Durrant <paul@xen.org>,
 xen-devel@lists.xenproject.org, David Hildenbrand <david@redhat.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, qemu-riscv@nongnu.org,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 manos.pitsidianakis@linaro.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Alistair Francis <alistair.francis@wdc.com>, qemu-ppc@nongnu.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Weiwei Li <liwei1518@gmail.com>, kvm@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Peter Xu <peterx@redhat.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
 <20250317183417.285700-14-pierrick.bouvier@linaro.org> <Z9rNBFsWR39czUGQ@l14>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <Z9rNBFsWR39czUGQ@l14>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOS8yNSAwNjo1NiwgQW50aG9ueSBQRVJBUkQgd3JvdGU6DQo+IE9uIE1vbiwgTWFy
IDE3LCAyMDI1IGF0IDExOjM0OjEyQU0gLTA3MDAsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6
DQo+PiBSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5h
cm8ub3JnPg0KPj4gU2lnbmVkLW9mZi1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2su
Ym91dmllckBsaW5hcm8ub3JnPg0KPiANCg0KVGhpcyB3YXMgYSBiYWQgY29weS1wYXN0ZSwg
dGhhbmtzLg0KDQo+IFJldmlld2VkLWJ5OiBBbnRob255IFBFUkFSRCA8YW50aG9ueS5wZXJh
cmRAdmF0ZXMudGVjaD4NCj4gDQo+IFRoYW5rcywNCj4gDQoNCg==

