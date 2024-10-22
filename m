Return-Path: <kvm+bounces-29436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A82E9AB7BE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42A20282C9E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681611CC89F;
	Tue, 22 Oct 2024 20:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f0OtpP5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3D1A2872
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629463; cv=none; b=csqmbJQ8lREhHFQ6UT7wLNxqFsl55VpN87mTR2bZh8Y6BWGi9QJqRm9ytOLogyqRpQGpKMz5n3xqwiwlK+2Agl9kLCYtS5mWQvBGQMPL6PixeAn5H2M/pK39pcMafnvC6NyGBoSr49Wd0CZV0DpaDKT/jlZfNaSnoIP6k6n2xQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629463; c=relaxed/simple;
	bh=f5sdSPp62Q75k/UPTlmS2tewvumj3hSalan6FnEOZPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZ0B6PfnRD11bWgmUyozrL8WDrvWnB2RyjZI6LNvdJDxbhUj1q3IMZ6Wm1j4bxaWffMDOlqfSnVX3ma8IXbYnCJI1EseI3o8dvcAAYZ8fAM/8pIEZOt/qXsRfh786+rVGW8Jd/oI9FTQf+fYILzU2mlWvW4QUkx2iuf8MFMMxFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f0OtpP5w; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e93d551a3so4318545b3a.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629461; x=1730234261; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f5sdSPp62Q75k/UPTlmS2tewvumj3hSalan6FnEOZPk=;
        b=f0OtpP5wibMCfcx9tO5WXqaLiWgil3NcqvjUMcMTVFX5EyWIKwUJxfyBmX6neiouvy
         YpOGcJZ6yOwXLZdmWEEw5jVkcuDVExCSSCtfqcKtpFmZ1UY17NtG3cHGTdYETdgBNNhr
         gGdDrTwc0QZOxeq+Rfpv9ezMYlAhqoe33PcF4Uu7pwPt3m79G0L89peW917eh0j99fg0
         NTAZ0pwINhBEl+xD731mGE3N65UL3rJ2ubmTqIGpKfjVQd1XA6S+gSfimlh9vjwkijvh
         61kyw2K8I/JGfLFusSIW0L/vQqIZLi19jb+PCnxhmCb2AoFjXJF+9honFBFF8DKKU1jS
         idmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629461; x=1730234261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5sdSPp62Q75k/UPTlmS2tewvumj3hSalan6FnEOZPk=;
        b=aFhwEXD+9DyIYWC/zcGvG8VDPnSMl8Brv9jJYaOFyH/oMvK2733lCDiedAnwTRubAn
         GztikuUbcSsdB59uvebKtl9NKTR8Ms6lXDSrZqeKortvA7QeuvsxF/uCXU47S8yrHaCx
         RinErnrlRa9e6wxHNC/rpks/G499V3XmWp6wkK7UgPiF3+t0lTFF9zwsMnD1wOgxZIDF
         qFNTyQWClUjzFiduV2gvxztVg8v4JbLojwOGuc3SLm+gfH3gRVnHg4RBdgcoXupW2mbv
         09milndsszxdeEsr/f1JRf8ZMBBA2hhxnmDizJ59n5Rxf3OsDWr8Avx6wqt7sG1BXPkK
         OFsg==
X-Forwarded-Encrypted: i=1; AJvYcCVFOZb9R6a45w2LyU+TVEV9B7iK4Gp4rod5Kpg1lHwlKUrQtphARrEDlqAqjGtxTJzug7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvqDVWKGpPkfy2U5QBg7CPENroA+7Gmho/RONwhmrNEtSJ8THU
	TyizvkQiLykIVctC2Ho+/RDXxgYXCvx+bBEMYtHzk0Mu8NLbs1T1mSpN+/3zG3o=
X-Google-Smtp-Source: AGHT+IHBgvymnZDA1aAIEhXx4lrpTcO5QXRmbjHef4foA8M1Uym7OgXgjk3rpWC2gUn74uJXA5Ecbw==
X-Received: by 2002:a05:6a00:8c3:b0:71e:a3:935b with SMTP id d2e1a72fcca58-72030cd2654mr594674b3a.25.1729629461420;
        Tue, 22 Oct 2024 13:37:41 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec141507csm5125532b3a.215.2024.10.22.13.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:37:41 -0700 (PDT)
Message-ID: <10600e67-2d97-4cfb-829f-34e740e47e2b@linaro.org>
Date: Tue, 22 Oct 2024 13:37:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/20] config/targets: update aarch64_be-linux-user gdb
 XML list
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
 <20241022105614.839199-13-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-13-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gQXR0ZW1wdGluZyB0
byBydW4gdGhlIGJpbmFyeSBhc3NlcnRzIHdoZW4gaXQgY2FuJ3QgZmluZCB0aGUgWE1MIGVu
dHJ5Lg0KPiBXZSBjYW4gZml4IGl0IHNvIHdlIGRvbid0IGFsdGhvdWdoIEkgc3VzcGVjdCBv
dGhlciBzdHVmZiBpcyBicm9rZW4uDQo+IA0KPiBGaXhlczogaHR0cHM6Ly9naXRsYWIuY29t
L3FlbXUtcHJvamVjdC9xZW11Ly0vaXNzdWVzLzI1ODANCj4gU2lnbmVkLW9mZi1ieTogQWxl
eCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiAtLS0NCj4gICBjb25maWdz
L3RhcmdldHMvYWFyY2g2NF9iZS1saW51eC11c2VyLm1hayB8IDIgKy0NCj4gICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9jb25maWdzL3RhcmdldHMvYWFyY2g2NF9iZS1saW51eC11c2VyLm1hayBiL2NvbmZp
Z3MvdGFyZ2V0cy9hYXJjaDY0X2JlLWxpbnV4LXVzZXIubWFrDQo+IGluZGV4IDc3OGQyMmIy
YTkuLmRjZWY1OTdhODAgMTAwNjQ0DQo+IC0tLSBhL2NvbmZpZ3MvdGFyZ2V0cy9hYXJjaDY0
X2JlLWxpbnV4LXVzZXIubWFrDQo+ICsrKyBiL2NvbmZpZ3MvdGFyZ2V0cy9hYXJjaDY0X2Jl
LWxpbnV4LXVzZXIubWFrDQo+IEBAIC0xLDcgKzEsNyBAQA0KPiAgIFRBUkdFVF9BUkNIPWFh
cmNoNjQNCj4gICBUQVJHRVRfQkFTRV9BUkNIPWFybQ0KPiAgIFRBUkdFVF9CSUdfRU5ESUFO
PXkNCj4gLVRBUkdFVF9YTUxfRklMRVM9IGdkYi14bWwvYWFyY2g2NC1jb3JlLnhtbCBnZGIt
eG1sL2FhcmNoNjQtZnB1LnhtbCBnZGIteG1sL2FhcmNoNjQtcGF1dGgueG1sDQo+ICtUQVJH
RVRfWE1MX0ZJTEVTPSBnZGIteG1sL2FhcmNoNjQtY29yZS54bWwgZ2RiLXhtbC9hYXJjaDY0
LWZwdS54bWwgZ2RiLXhtbC9hYXJjaDY0LXBhdXRoLnhtbCBnZGIteG1sL2FhcmNoNjQtbXRl
LnhtbA0KPiAgIFRBUkdFVF9IQVNfQkZMVD15DQo+ICAgQ09ORklHX1NFTUlIT1NUSU5HPXkN
Cj4gICBDT05GSUdfQVJNX0NPTVBBVElCTEVfU0VNSUhPU1RJTkc9eQ0KDQpSZXZpZXdlZC1i
eTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0K

