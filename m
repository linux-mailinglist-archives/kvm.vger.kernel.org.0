Return-Path: <kvm+bounces-24325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7958953986
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59FE9287217
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1196847A4C;
	Thu, 15 Aug 2024 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PUNi9dMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338141C64
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723744676; cv=none; b=bVgYiMffxRaUY26k2qHO0YSNQtq8TYZb0OmKg9pzE54bqlrebRgdL+QmfeCk0pDLutNy49QDDPlG53yJdN5qCoM3sCmAAc/lXJDK/Z8ZFmvhtyp8ZU68W//r2Hq2CVei0lJj6k3D4zQHM5/o/2fhdKwHhq118nR58Zc3NiwSHRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723744676; c=relaxed/simple;
	bh=g2zXSYbhmYF2CAYqRjJR/DpyeR0RGytNvb7sahLmXoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BRPaGIcmuB5gcum+ut4+BgATx5E5hdxZ+GfoKJWrMNP6yOPsDmks9Nyxer5FfsLSn23yi630LVV+jA575SpU1cHVATac4MjWr7CHa08hG20euBIxdrUsdF9G5zj5bQOenHX1znzp04iAfEvBv5mI2Jd5rWKBcfKg3Q3EuoQBKpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PUNi9dMc; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7c3ebba7fbbso977991a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723744674; x=1724349474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g2zXSYbhmYF2CAYqRjJR/DpyeR0RGytNvb7sahLmXoc=;
        b=PUNi9dMcS+fI8YS7a2Uv8RyY1UW5/eqCbXHD5Z3GyjGnxwQLQs7rvxWoyl7pjaZ2JL
         BUBmiuWmHDlRkdBBg9IVSFR8eSpnc5Ucaxne4nW0N0EbvwpzuVNUZzbyfn4VeoSgKUwe
         oIUF13i+urdTrwd30z6D0neBQOJtvVTS73fBveVaCajUc+fUV8r1WxSY/hHEI4vk9boz
         TabLrHioUD9kGY9Q12KH0ImMvDdGwSKgfp1P8igyTlzBEBlbvxyXUlduIdl6XrfwTWDt
         V9ri51IV+qeA9MaCJvF44B+6qkXRKVLCVEP32EzBWuceCXxzXgHRz/0Hr89b/X7e/Gvc
         GTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723744674; x=1724349474;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2zXSYbhmYF2CAYqRjJR/DpyeR0RGytNvb7sahLmXoc=;
        b=pzh3qffqS0mpvAsQgrTksaEHtGsgLs8w0Xo47z1bmnmdXCo9ufzU2st5VI3SMihXD1
         C7hL9RY326p/vdYVKlKQr1gT49Gy5Y0nEUKxHSKPSqare/fRbgrsL+g/DSoq/BVCr31u
         2pR4+Sg8DEX9ux+OjVKgcymZJssWwWppYm+rHZCNCbUBsAw17oOGcH6eWkjgIAm+yHpu
         XXS2mpo0dHwNmP0ewBBC1VzTH/X4k/qlRluPBoSbn0GzOftqcfKFBgDLukG84LrezGZJ
         mRrLY4Dbwi0KvZsU1ZLOUaRjv4T6q5BopgRVL9r7+bvDBD1/tQbym/so0cXV9O10fmgF
         zVKA==
X-Forwarded-Encrypted: i=1; AJvYcCXGji3+2pUH13ZB1/MxaPAWnhSUHKAyH7mykIbyAa5mtDSTmp6fW4VqordgruTqtNQsNwpMbY6/BhkT4wDoy2vNOKXi
X-Gm-Message-State: AOJu0YwXeLaURBatU2HSwqYYyft9n+esFWh1+CLyv31jwOoFAC9I4DSX
	RffvipvyAgmWj7RfHt8puub96R67uzFRrRkeFbZLw+A3dxm26pyWpVWQrIXBEX8=
X-Google-Smtp-Source: AGHT+IEYjObpdvvbSflNmE9KwuBlSmcKhM40rDsJNnKlAsOF3prcvHCtvMDWUtdwMrFrJos1d/Ogdw==
X-Received: by 2002:a05:6a21:2d8d:b0:1c2:8d91:634 with SMTP id adf61e73a8af0-1c90506e40cmr572811637.45.1723744673986;
        Thu, 15 Aug 2024 10:57:53 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::b861? ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127aef5229sm1254761b3a.107.2024.08.15.10.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 10:57:53 -0700 (PDT)
Message-ID: <9286d40e-f760-4219-b202-e1e892687086@linaro.org>
Date: Thu, 15 Aug 2024 10:57:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
Content-Language: en-US
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org, Wainer dos Santos Moschetta <wainersm@redhat.com>,
 qemu-s390x@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
 <8a987dbb-aff5-42dc-ae56-0b6b4e6a985a@redhat.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <8a987dbb-aff5-42dc-ae56-0b6b4e6a985a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8xNS8yNCAwMjo1MCwgVGhvbWFzIEh1dGggd3JvdGU6DQo+IE9uIDE1LzA4LzIwMjQg
MDAuNDEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBXaGVuIGJ1aWxkaW5nIHdpdGgg
Z2NjLTEyIC1mc2FuaXRpemU9dGhyZWFkLCBnY2MgcmVwb3J0cyBzb21lDQo+PiBjb25zdHJ1
Y3Rpb25zIG5vdCBzdXBwb3J0ZWQgd2l0aCB0c2FuLg0KPj4gRm91bmQgb24gZGViaWFuIHN0
YWJsZS4NCj4+DQo+PiBxZW11L2luY2x1ZGUvcWVtdS9hdG9taWMuaDozNjo1MjogZXJyb3I6
IOKAmGF0b21pY190aHJlYWRfZmVuY2XigJkgaXMgbm90IHN1cHBvcnRlZCB3aXRoIOKAmC1m
c2FuaXRpemU9dGhyZWFk4oCZIFstV2Vycm9yPXRzYW5dDQo+PiAgICAgIDM2IHwgI2RlZmlu
ZSBzbXBfbWIoKSAgICAgICAgICAgICAgICAgICAgICh7IGJhcnJpZXIoKTsgX19hdG9taWNf
dGhyZWFkX2ZlbmNlKF9fQVRPTUlDX1NFUV9DU1QpOyB9KQ0KPj4gICAgICAgICB8ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+IC0t
LQ0KPj4gICAgbWVzb24uYnVpbGQgfCAxMCArKysrKysrKystDQo+PiAgICAxIGZpbGUgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdp
dCBhL21lc29uLmJ1aWxkIGIvbWVzb24uYnVpbGQNCj4+IGluZGV4IDgxZWNkNGJhZTdjLi41
MmU1YWE5NWNjMCAxMDA2NDQNCj4+IC0tLSBhL21lc29uLmJ1aWxkDQo+PiArKysgYi9tZXNv
bi5idWlsZA0KPj4gQEAgLTQ5OSw3ICs0OTksMTUgQEAgaWYgZ2V0X29wdGlvbigndHNhbicp
DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJlZml4OiAnI2luY2x1ZGUgPHNh
bml0aXplci90c2FuX2ludGVyZmFjZS5oPicpDQo+PiAgICAgICAgZXJyb3IoJ0Nhbm5vdCBl
bmFibGUgVFNBTiBkdWUgdG8gbWlzc2luZyBmaWJlciBhbm5vdGF0aW9uIGludGVyZmFjZScp
DQo+PiAgICAgIGVuZGlmDQo+PiAtICBxZW11X2NmbGFncyA9IFsnLWZzYW5pdGl6ZT10aHJl
YWQnXSArIHFlbXVfY2ZsYWdzDQo+PiArICB0c2FuX3dhcm5fc3VwcHJlc3MgPSBbXQ0KPj4g
KyAgIyBnY2MgKD49MTEpIHdpbGwgcmVwb3J0IGNvbnN0cnVjdGlvbnMgbm90IHN1cHBvcnRl
ZCBieSB0c2FuOg0KPj4gKyAgIyAiZXJyb3I6IOKAmGF0b21pY190aHJlYWRfZmVuY2XigJkg
aXMgbm90IHN1cHBvcnRlZCB3aXRoIOKAmC1mc2FuaXRpemU9dGhyZWFk4oCZIg0KPj4gKyAg
IyBodHRwczovL2djYy5nbnUub3JnL2djYy0xMS9jaGFuZ2VzLmh0bWwNCj4+ICsgICMgSG93
ZXZlciwgY2xhbmcgZG9lcyBub3Qgc3VwcG9ydCB0aGlzIHdhcm5pbmcgYW5kIHRoaXMgdHJp
Z2dlcnMgYW4gZXJyb3IuDQo+PiArICBpZiBjYy5oYXNfYXJndW1lbnQoJy1Xbm8tdHNhbicp
DQo+PiArICAgIHRzYW5fd2Fybl9zdXBwcmVzcyA9IFsnLVduby10c2FuJ10NCj4+ICsgIGVu
ZGlmDQo+PiArICBxZW11X2NmbGFncyA9IFsnLWZzYW5pdGl6ZT10aHJlYWQnXSArIHRzYW5f
d2Fybl9zdXBwcmVzcyArIHFlbXVfY2ZsYWdzDQo+PiAgICAgIHFlbXVfbGRmbGFncyA9IFsn
LWZzYW5pdGl6ZT10aHJlYWQnXSArIHFlbXVfbGRmbGFncw0KPj4gICAgZW5kaWYNCj4+ICAg
IA0KPiANCj4gTm90IHN1cmUgaWYgd2Ugc2hvdWxkIGhpZGUgdGhlc2Ugd2FybmluZ3MgLi4u
IHRoZXkgc2VlbSB0byBiZSB0aGVyZSBmb3IgYQ0KPiByZWFzb24/IFBhb2xvLCBhbnkgaWRl
YXM/DQo+IA0KDQpUaGlzIGlzIGEgbmV3IHdhcm5pbmcgYWRkZWQgaW4gZ2NjLTExLCB0byBw
cmV2ZW50IHRoYXQgbm90IGFsbCANCmNvbnN0cnVjdGlvbnMgYXJlIHN1cHBvcnRlZCBieSB0
aHJlYWQgc2FuaXRpemVyLiBUaGlzIHdhcyB0cnVlIGJlZm9yZSwgDQphbmQgd2lsbCBiZSB0
cnVlIGFmdGVyLiBCYXNpY2FsbHksIG1hbnVhbCBtZW1vcnkgYmFycmllcnMgYXJlIG5vdCAN
CnN1cHBvcnRlZCB0byBtb2RlbCBjb25jdXJyZW5jeS4gV2UgY2FuIGhhcmRseSBjaGFuZ2Ug
c29tZXRoaW5nIG9uIFFFTVUgDQpzaWRlIGFzIGl0J3MgYSBsaW1pdGF0aW9uIG9mIHRzYW4g
aXRzZWxmLg0KDQpHb29kIG5ld3MgaXMgdGhhdCBpdCBkb2VzIG5vdCBzZWVtIHRvIGJyaW5n
IGZhbHNlIHBvc2l0aXZlcyB3aGVuIA0KZXhlY3V0aW5nIGEgcWVtdSB3aXRoIHRzYW4uIFRo
dXMsIHRoaXMgcGF0Y2ggdG8gaWdub3JlIHRoaXMgZm9yIG5vdy4NCg0KPiAgICBUaG9tYXMN
Cj4gDQo=

