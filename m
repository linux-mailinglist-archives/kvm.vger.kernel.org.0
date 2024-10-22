Return-Path: <kvm+bounces-29433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5429AB7A1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E28DCB22C9D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CAF1CBEAF;
	Tue, 22 Oct 2024 20:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cqiNnxKS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629BB126C05
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629107; cv=none; b=rpeJmL2DolikJomFclvIfcCLvPRaZTbwxRNZH6Jpxo9TLPWCZ7uVdSpygqL4PkHoz1he8YloSJxQ/VUguBO/rAaF3UBK+if4AYoc96zxb4pG1E4nR4jwYKKTw9LGCb2zIMjnvI1lzN3cf9q/vF00wdHSYlM18icnu6jqPkmNADA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629107; c=relaxed/simple;
	bh=oB483hQexTEaOWDvU61A56qrwM7YWeWBfyueGHYezvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AzVquWxJGNwiCFqDJTgaF2yYw4XU0sgZL64j6YCQ+TEZigRqNVwIDJdk1qzn6Dj/EhXpKm+drArBm/9iNesZKIZkC4ERpSGjHu9QOyRMvZbeKqhLCvgFHCBPm3a1N5IDZ6ysVJjFzIrYTgxplsoNl/mWZ1EBPg6+oQmKGhZ1GWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cqiNnxKS; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e59746062fso2452054a91.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629106; x=1730233906; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oB483hQexTEaOWDvU61A56qrwM7YWeWBfyueGHYezvc=;
        b=cqiNnxKSxJetW7fgq+D1XaEJjX0sMak4BySLIiFz9wbWi1AnjnyzPu4gNKNg9hc9RV
         1Vb+aF3zrLjlLcYJyUDoJ04DGwmmZGMxqM5R5JwG27d/mKeS9BbCYl0BB4ZV+7HGHWZM
         zwD9Ws/Ni+ftmwmPYZC6vEyC8wKeud3iIaoTpevAEbJxYH6canx9e3v6luY6a2uBmft7
         E7I9t94C+LHgiCxpmwbWKE0JDtUb68H+r8J5eGqfc3KSJSbx0Fa21lYtaNuzmqzN4cYy
         2N7zWUyMO4eBbPMUHD52k2t7JW/FYm2t2D1TtHF31opGn1vLuBBuKDttft4QL9LIxgel
         fGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629106; x=1730233906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oB483hQexTEaOWDvU61A56qrwM7YWeWBfyueGHYezvc=;
        b=pubAmdzXojXf8u0shIHbftOjYUksxXg87v7ZMZijgP8dE8mtRTHLCs0H+cHFkr1agE
         hKluBMwRbkQpQlGBq+tEBeTz9OH/189D/bchVX+g42x5CF2LbTj0DZXHkm1Tm6TLNt3h
         HUEQ8BoLWoceC6QCrvGr8na2RLf20gNlgNOTSSYJsFU2/OcUdQDdLZXyI/LtFptwU5PQ
         aLAD8AyD38i6rf4YDsUkghMwx80HaDaJdFJ9VJ+iSBfOzkHCY3Q3K8l865CQbchhAnjm
         Sqx2IgGsNeREoj/FD9kd7TJb7O00Lo0uAquA2vmYkp8JC2/lN6vAQv1mKXgxLgahU/3C
         2Etg==
X-Forwarded-Encrypted: i=1; AJvYcCVBciuCOcl4xbgk3dP+HBBF4kwZHGcJ/nTE6oyLQy8L3z/vYt3K8+QCj4IIybkYpM0wa1U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGvCytGT74+YSeqX9dcbcBgBRPXncpwnhd8T00blNx1OtwIKMV
	++9wUyOAS0VFbz6CX8SCd0WyYloM8djinlqtLemjjpMxHPxzSBMpe8OcNlkFNGs=
X-Google-Smtp-Source: AGHT+IHOfhvheXJxw9in5Rg8Qqoc4W+j3iF1Z8mFQAoMgSmn+ZFqHHEv4hP0+Rc5vNRAQag4kQezkA==
X-Received: by 2002:a17:90b:4c4b:b0:2e2:d15c:1a24 with SMTP id 98e67ed59e1d1-2e76b618c40mr223184a91.23.1729629105804;
        Tue, 22 Oct 2024 13:31:45 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad388ea9sm6722471a91.29.2024.10.22.13.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:31:45 -0700 (PDT)
Message-ID: <20d8ac14-d920-4a21-a5cc-432acc7d582f@linaro.org>
Date: Tue, 22 Oct 2024 13:31:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/20] tests/docker: add NOFETCH env variable for
 testing
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
 <20241022105614.839199-3-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-3-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTUsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gVGVzdGluZyBub24t
YXV0byBidWlsdCBkb2NrZXIgY29udGFpbmVycyAoaS5lLiBjdXN0b20gYnVpbHQgY29tcGls
ZXJzKQ0KPiBpcyBhIGJpdCBmaWRkbHkgYXMgeW91IGNvdWxkbid0IGNvbnRpbnVlIGEgYnVp
bGQgd2l0aCBhIHByZXZpb3VzbHkNCj4gbG9jYWxseSBidWlsdCBjb250YWluZXIuIFdoaWxl
IHlvdSBjYW4gcGxheSBnYW1lcyB3aXRoIFJFR0lTVFJZIGl0cw0KPiBzaW1wbGVyIHRvIGFs
bG93IGEgTk9GRVRDSCB0aGF0IHdpbGwgZ28gdGhyb3VnaCB0aGUgY2FjaGVkIGJ1aWxkDQo+
IHByb2Nlc3Mgd2hlbiB5b3UgcnVuIHRoZSB0ZXN0cy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgdGVz
dHMvZG9ja2VyL01ha2VmaWxlLmluY2x1ZGUgfCA1ICsrKy0tDQo+ICAgMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS90ZXN0cy9kb2NrZXIvTWFrZWZpbGUuaW5jbHVkZSBiL3Rlc3RzL2RvY2tlci9NYWtlZmls
ZS5pbmNsdWRlDQo+IGluZGV4IDY4MWZlYWU3NDQuLmZlYWQ3ZDNhYmUgMTAwNjQ0DQo+IC0t
LSBhL3Rlc3RzL2RvY2tlci9NYWtlZmlsZS5pbmNsdWRlDQo+ICsrKyBiL3Rlc3RzL2RvY2tl
ci9NYWtlZmlsZS5pbmNsdWRlDQo+IEBAIC05MiwxMCArOTIsMTAgQEAgZW5kaWYNCj4gICBk
b2NrZXItaW1hZ2UtYWxwaW5lOiBOT1VTRVI9MQ0KPiAgIA0KPiAgIGRlYmlhbi10b29sY2hh
aW4tcnVuID0gXA0KPiAtCSQoaWYgJChOT0NBQ0hFKSwgCQkJCQkJXA0KPiArCSQoaWYgJChO
T0NBQ0hFKSQoTk9GRVRDSCksCQkJCQlcDQo+ICAgCQkkKGNhbGwgcXVpZXQtY29tbWFuZCwJ
CQkJCVwNCj4gICAJCQkkKERPQ0tFUl9TQ1JJUFQpIGJ1aWxkIC10IHFlbXUvJDEgLWYgJDwg
CVwNCj4gLQkJCSQoaWYgJFYsLC0tcXVpZXQpIC0tbm8tY2FjaGUgCQkJXA0KPiArCQkJJChp
ZiAkViwsLS1xdWlldCkgJChpZiAkKE5PQ0FDSEUpLC0tbm8tY2FjaGUpCVwNCj4gICAJCQkt
LXJlZ2lzdHJ5ICQoRE9DS0VSX1JFR0lTVFJZKSAtLWV4dHJhLWZpbGVzCVwNCj4gICAJCQkk
KERPQ0tFUl9GSUxFU19ESVIpLyQxLmQvYnVpbGQtdG9vbGNoYWluLnNoLAlcDQo+ICAgCQkJ
IkJVSUxEIiwgJDEpLAkJCQkgICAgICAgIFwNCj4gQEAgLTE3Nyw2ICsxNzcsNyBAQCBkb2Nr
ZXI6DQo+ICAgCUBlY2hvICcgICAgTkVUV09SSz0kJEJBQ0tFTkQgICAgIEVuYWJsZSB2aXJ0
dWFsIG5ldHdvcmsgaW50ZXJmYWNlIHdpdGggJCRCQUNLRU5ELicNCj4gICAJQGVjaG8gJyAg
ICBOT1VTRVI9MSAgICAgICAgICAgICBEZWZpbmUgdG8gZGlzYWJsZSBhZGRpbmcgY3VycmVu
dCB1c2VyIHRvIGNvbnRhaW5lcnMgcGFzc3dkLicNCj4gICAJQGVjaG8gJyAgICBOT0NBQ0hF
PTEgICAgICAgICAgICBJZ25vcmUgY2FjaGUgd2hlbiBidWlsZCBpbWFnZXMuJw0KPiArCUBl
Y2hvICcgICAgTk9GRVRDSD0xICAgICAgICAgICAgRG8gbm90IGZldGNoIGZyb20gdGhlIHJl
Z2lzdHJ5LicNCj4gICAJQGVjaG8gJyAgICBFWEVDVVRBQkxFPTxwYXRoPiAgICBJbmNsdWRl
IGV4ZWN1dGFibGUgaW4gaW1hZ2UuJw0KPiAgIAlAZWNobyAnICAgIEVYVFJBX0ZJTEVTPSI8
cGF0aD4gWy4uLiA8cGF0aD5dIicNCj4gICAJQGVjaG8gJyAgICAgICAgICAgICAgICAgICAg
ICAgICBJbmNsdWRlIGV4dHJhIGZpbGVzIGluIGltYWdlLicNCg0KUmV2aWV3ZWQtYnk6IFBp
ZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCg==

