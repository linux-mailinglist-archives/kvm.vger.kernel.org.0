Return-Path: <kvm+bounces-41241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA05A6579C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA0DC884B4A
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6E71991CF;
	Mon, 17 Mar 2025 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="axS6ohFC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1617A2E9
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742227644; cv=none; b=LjHOPn88oYRnWJgZid6xIxjmgKXMgn4I9B091BaVwamygwe2SKYTXT643iHTS5EvFAOH7SDG8oLGqeAI1N55H5WwvH+waa8YML3aIrouKrNHBB1rd9IM64IjPrwqdiQn2Kf5W2Gk4Ader1MeWGDBNL/sQxIlraCEKVI8mlBGJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742227644; c=relaxed/simple;
	bh=zBROt8Wvg39oI6RJKUKBStbr1ifb9ytbzgO6Y+lRt3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KBodDQP9KF6XfJzTituzcsKaCKWCh14aOV/KvvfhmBflo4SxRJQQzum6dDET/PYcMTjSi846jTX/c/Oj48GziSqjlY45Iwe/YTx8Yx+Iu2NahIQ9G6kyDlYPklvlQVb8QGd+kJ9YBfGbRUKUkDhEWnbOh/9wrkogOU25PTI6V94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=axS6ohFC; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso3803173a91.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742227642; x=1742832442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zBROt8Wvg39oI6RJKUKBStbr1ifb9ytbzgO6Y+lRt3Q=;
        b=axS6ohFCVQLtxuLzWvpUfLkDQf+9nK7vhBWO2k+It6JQuZzswJESp9IAPvxJ2arc6D
         HkFBv6xEjyVWzPIa5kfD+mA26ApePkM4bp7j1ioqPs+RpaHF2sguOfitpG5l1/Dy+jwg
         L6jF6VtxTUwJBXgwXYw3uMKRf3TAqqlTnmpmJsUG1mcfZ2eXMrvN+CME5L/5JCWErkV0
         4lhsxCmVcTrJXOxyvFsusmI/qgNrJS9rBgV9frPPEDE686h0QF2pjJmNjowCbL1kd96a
         v4RJvw4DWnuiGFh7X/y8UBEE52Zzz3WfG9YTg0cezrQaRPta3na/gzrkejqW67uDTuD0
         EsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742227642; x=1742832442;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBROt8Wvg39oI6RJKUKBStbr1ifb9ytbzgO6Y+lRt3Q=;
        b=fN6FaGqa6a63IplDHkUZPAQg8Lzd56M14qxwVCIIjkQSFPX+tQr4Mir34XMrQZzWPx
         8+ziSSj71VkQdlqPEDaugfccQalZvim9oiykmRLxKkIi7UL2eR5PCciGLDiwxQRXEGd2
         2aKKrF1sHRvjJjjkwtVcw/w4GOx48w9xbUaxyMPLFihtsvsVA2CHU1ZT4QniyRyr42Cf
         7BNAdAhOcAwQc8dPIySP/ITvKzZOVW/mbnlEZWr34uUdZVEfYJf5RsdNBpYH5tYro6IR
         BZxG//j/sF0lVl2H/goq9ESeDh5YrOSrzboMzYRqYUpku8NqawJ/1+kqB9r+btS7x7ad
         TDxg==
X-Forwarded-Encrypted: i=1; AJvYcCVEoDppps5lPrm2kqPtB4TIagVh0XKza7tDpTrbXc9eSI62knT/uXOJGypxvyS0n7w+Vj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YynWRssx1PWADklSg0PWXPrmelEaPS5PpBbQ0VLEHpyXKhq3Nw7
	Xs2u7hIM88Jj8aZqYC+zw5zSFOX4YLTSSd25Xbpo75scGQpESTdo1Q55sWj0iXE=
X-Gm-Gg: ASbGncupXhyhjTJ4ieENCATSRX5zeH8OWJohRHKekBu8R5vjz6tm36Bo6ttQL+nQ5iC
	rXdiURvzqpAAjKzWB0ihsf2A2l0RJIEf7tLYXgci2ovPnxay9Du1MnrhbCPihT15t2OxPFknGgW
	fO+WfbBJKJx3SDj/Lvco8UQvy8wGxoWdcmOLfRbgZpK49Lo4IxtNBMi/VyZixnLkOKfiFWsRat0
	IQJ7Jt56BP1+RltHoCBAnsNb5L4ujA6HOFIAeaaMTzgQYaxBLQeI9BIN9/xRubDnkBoeEmygtSs
	zhhqKLSjvFtX7EVRvHYr08KyAmx8Pf0SDU8+fPyrkGk9n5Xh2QKlTkuO5A==
X-Google-Smtp-Source: AGHT+IGu7JBcnuWnMPBuU7hiTo93qu/WDWnwnWY6VP9EN/eE9EF8eTD0WKyIrv4I/zgNLAfNvjqk7A==
X-Received: by 2002:a17:90a:fc43:b0:2ee:c2b5:97a0 with SMTP id 98e67ed59e1d1-30151d3e018mr16040542a91.25.1742227641697;
        Mon, 17 Mar 2025 09:07:21 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30153519fefsm6256238a91.12.2025.03.17.09.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 09:07:21 -0700 (PDT)
Message-ID: <edc3bc03-b34f-4bed-be0d-b0fb776a115b@linaro.org>
Date: Mon, 17 Mar 2025 09:07:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] exec/ram_addr: call xen_hvm_modified_memory only
 if xen is enabled
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <20250314173139.2122904-12-pierrick.bouvier@linaro.org>
 <ad7cdcaf-46d6-460f-8593-a9b74c600784@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <ad7cdcaf-46d6-460f-8593-a9b74c600784@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xNy8yNSAwODo1MCwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE0LzMvMjUgMTg6MzEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBSZXZpZXdlZC1i
eTogUmljaGFyZCBIZW5kZXJzb24gPHJpY2hhcmQuaGVuZGVyc29uQGxpbmFyby5vcmc+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxp
bmFyby5vcmc+DQo+PiAtLS0NCj4+ICAgIGluY2x1ZGUvZXhlYy9yYW1fYWRkci5oIHwgOCAr
KysrKystLQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9leGVjL3JhbV9hZGRyLmgg
Yi9pbmNsdWRlL2V4ZWMvcmFtX2FkZHIuaA0KPj4gaW5kZXggZjVkNTc0MjYxYTMuLjkyZTg3
MDhhZjc2IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9leGVjL3JhbV9hZGRyLmgNCj4+ICsr
KyBiL2luY2x1ZGUvZXhlYy9yYW1fYWRkci5oDQo+PiBAQCAtMzM5LDcgKzMzOSw5IEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBjcHVfcGh5c2ljYWxfbWVtb3J5X3NldF9kaXJ0eV9yYW5nZShy
YW1fYWRkcl90IHN0YXJ0LA0KPj4gICAgICAgICAgICB9DQo+PiAgICAgICAgfQ0KPj4gICAg
DQo+PiAtICAgIHhlbl9odm1fbW9kaWZpZWRfbWVtb3J5KHN0YXJ0LCBsZW5ndGgpOw0KPj4g
KyAgICBpZiAoeGVuX2VuYWJsZWQoKSkgew0KPj4gKyAgICAgICAgeGVuX2h2bV9tb2RpZmll
ZF9tZW1vcnkoc3RhcnQsIGxlbmd0aCk7DQo+IA0KPiBQbGVhc2UgcmVtb3ZlIHRoZSBzdHVi
IGFsdG9nZXRoZXIuDQo+DQoNCldlIGNhbiBldmVudHVhbGx5IGlmZGVmIHRoaXMgY29kZSB1
bmRlciBDT05GSUdfWEVOLCBidXQgaXQgbWF5IHN0aWxsIGJlIA0KYXZhaWxhYmxlIG9yIG5v
dC4gVGhlIG1hdGNoaW5nIHN0dWIgZm9yIHhlbl9odm1fbW9kaWZpZWRfbWVtb3J5KCkgd2ls
bCANCmFzc2VydCBpbiBjYXNlIGl0IGlzIHJlYWNoZWQuDQoNCldoaWNoIGNoYW5nZSB3b3Vs
ZCB5b3UgZXhwZWN0IHByZWNpc2VseT8NCg0KPj4gKyAgICB9DQo+PiAgICB9DQoNCg==

