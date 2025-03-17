Return-Path: <kvm+bounces-41262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DBEA659C0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 341A28881E2
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74FC1B0421;
	Mon, 17 Mar 2025 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MIkGkeMv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229851ADFE4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230964; cv=none; b=TsYEBbb+FJL2qyzuhY2GepXpzT+esnOoMRWxLyopm4H3vRTbc9hL+qiECIUIFPyCKx5eInWur0HZGeix7Wm73FyR3K74WzX1zV4wrSvGVWH9BF/1XyrAw8dv4coca1F+Q2JaQ31HDR0+6FrGYgzIysVl9ObAmdEidMRhxwLkvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230964; c=relaxed/simple;
	bh=0KdeYQZxMITCKW2YracoyMvGqqsB+WIg6tW1xi9WJ6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZpCpc0T2b9Fsqjg9uFGdePKWlT1R0WBVOOmvioEyfEv0MkTtR//2fDkXrHa+E5sMfDtFXkagL1FJ2RnTCtDBLfCfrO1hPPAg7WrSKL1p45HtlcwI+e70Ns2OG3c1sjwGYrDAMxbMW3YYmzfrSfpHKG+BJzpu4hTbpt5RZuWxEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MIkGkeMv; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-225477548e1so80463015ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742230962; x=1742835762; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0KdeYQZxMITCKW2YracoyMvGqqsB+WIg6tW1xi9WJ6o=;
        b=MIkGkeMvrSC82Q636XvPDYSgEPIHBlNVLiCZyvHoJ8oXluO7xCvSrRVbc5tDUDwZ3j
         mY99eebp2MRCfegJE1A1WepAibYMWLZOWmm+POfY+ENyJE2mpHt6X1MO9+JkJn+uC/z2
         LmpqA02kSIZZUHSZFcqqrV6z+og6CDm692+wP+8SLHdM4StbYskjkPdcjI3TgtGHrBh+
         8hPJ87vRAdUNuUd52Bv/W/xFn+LXNh28NVjE0yKl2AHK81OZMTRxBOg5fmrqlt5px1ZH
         AxGJturjMZnb2itV6xIf+xAYDMeumpSpPZrbXQ4YAMqvmmFxkaximCvUiZ3gMhIGs2qS
         K6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230962; x=1742835762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0KdeYQZxMITCKW2YracoyMvGqqsB+WIg6tW1xi9WJ6o=;
        b=GyZvlCGkkkt3bgzRU0JWWjpc9RTLbHBK9mc9+piDdn70UZQuTvHnPOVXGPwoVqdba1
         XxWsTs70whFsGgd+ZKIAI9UCwDJcrX/PlCbusHVo92H2jOSlxdZbqTFxjvTb7bk5B4xL
         WNo1sLVwTKixYK0KbudV+UuGU1nepW676vnhWHZf+NfSKPo31swFeWOGhUhmJsmwmU7s
         0sFddvSOsy3WlwLGAfn6IY4eKRguOiF4Ue9TkSulbAoMdlzMdMdWmZyIJbU/MyzxvIz+
         LBc7ZWfw2OZUw5b64XX+xY/ERARjzSTjhtm0u6oQ1h4kHBdRmNcOLb+EslEQstaSmDeS
         3YAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+KIOf3+kxsxY5E8zHJe8hsW8ovvACHWbk+PXi+QVPJpNFdNnFa/2eyo1Km/i9MoJQCgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjnz15eSty2o4PMIg8yNJ0nxK5P8EABSGNDsYho1oyjfXKOjn3
	h0+GJGGKUEDYTvySz7w1hQP7XAuv2BvVe0eYkk1vAdD23nqMcpDrMTOSuKWszjo=
X-Gm-Gg: ASbGncv5zlGq9kgZrFxwwY4qxyOL8Q06wHUj06bDXlx4HdckL37bPfNooI3yBy7quD2
	lW/Y4STfrwndbzbuGGYGKKl1fJle/4npzImh4nNVelcNYA4z8CpeVzUrHzYhO0A2ubTBIgjkc1l
	gypyVeZAN6mvAaqvSff5yMaVKS3lzEtUqSmEvTehp/vqsO6M7BFFtx22rtnze6NK8pzwr7lFNfh
	PQoRFjvNDmNq19kFl+8q5bsgsRrlYIK71sZ3lPs5DY2p3+2177aq5z/Ws8Oa9ReKNlnmrBoWLxQ
	7nfV7ifEynAqJcTqkbUvUpJTqt8J8ZB9U/Xm5rTGWz4AEMtsVgD6UvDk2g==
X-Google-Smtp-Source: AGHT+IE96+IQ6oKtgk11tBS7t87MDWjDBBfjgGEDyxjnsPlxW2vYa3f+I8+TbfFUdxKcglJZ9KvdSg==
X-Received: by 2002:a17:902:7488:b0:224:826:277f with SMTP id d9443c01a7336-225e0af5bc8mr124296695ad.33.1742230962248;
        Mon, 17 Mar 2025 10:02:42 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbe905sm77694415ad.190.2025.03.17.10.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 10:02:41 -0700 (PDT)
Message-ID: <476e8dd7-08fc-49a8-8596-41ae91321738@linaro.org>
Date: Mon, 17 Mar 2025 10:02:40 -0700
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
 <edc3bc03-b34f-4bed-be0d-b0fb776a115b@linaro.org>
 <9c55662e-0c45-4bb6-83bf-54b131e30f48@linaro.org>
 <d93f6514-6d42-467d-826b-c95c6efd66b1@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <d93f6514-6d42-467d-826b-c95c6efd66b1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xNy8yNSAwOToyMywgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE3LzMvMjUgMTc6MjIsIFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIHdyb3RlOg0KPj4gT24g
MTcvMy8yNSAxNzowNywgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+PiBPbiAzLzE3LzI1
IDA4OjUwLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4+Pj4gT24gMTQvMy8y
NSAxODozMSwgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+Pj4+IFJldmlld2VkLWJ5OiBS
aWNoYXJkIEhlbmRlcnNvbiA8cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZz4NCj4+Pj4+
IFNpZ25lZC1vZmYtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGlu
YXJvLm9yZz4NCj4+Pj4+IC0tLQ0KPj4+Pj4gIMKgwqAgaW5jbHVkZS9leGVjL3JhbV9hZGRy
LmggfCA4ICsrKysrKy0tDQo+Pj4+PiAgwqDCoCAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2V4ZWMvcmFtX2FkZHIuaCBiL2luY2x1ZGUvZXhlYy9yYW1fYWRkci5oDQo+Pj4+PiBp
bmRleCBmNWQ1NzQyNjFhMy4uOTJlODcwOGFmNzYgMTAwNjQ0DQo+Pj4+PiAtLS0gYS9pbmNs
dWRlL2V4ZWMvcmFtX2FkZHIuaA0KPj4+Pj4gKysrIGIvaW5jbHVkZS9leGVjL3JhbV9hZGRy
LmgNCj4+Pj4+IEBAIC0zMzksNyArMzM5LDkgQEAgc3RhdGljIGlubGluZSB2b2lkDQo+Pj4+
PiBjcHVfcGh5c2ljYWxfbWVtb3J5X3NldF9kaXJ0eV9yYW5nZShyYW1fYWRkcl90IHN0YXJ0
LA0KPj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0NCj4+Pj4+ICDCoMKgwqDCoMKgwqAg
fQ0KPj4+Pj4gLcKgwqDCoCB4ZW5faHZtX21vZGlmaWVkX21lbW9yeShzdGFydCwgbGVuZ3Ro
KTsNCj4+Pj4+ICvCoMKgwqAgaWYgKHhlbl9lbmFibGVkKCkpIHsNCj4+Pj4+ICvCoMKgwqDC
oMKgwqDCoCB4ZW5faHZtX21vZGlmaWVkX21lbW9yeShzdGFydCwgbGVuZ3RoKTsNCj4+Pj4N
Cj4+Pj4gUGxlYXNlIHJlbW92ZSB0aGUgc3R1YiBhbHRvZ2V0aGVyLg0KPj4+Pg0KPj4+DQo+
Pj4gV2UgY2FuIGV2ZW50dWFsbHkgaWZkZWYgdGhpcyBjb2RlIHVuZGVyIENPTkZJR19YRU4s
IGJ1dCBpdCBtYXkgc3RpbGwNCj4+PiBiZSBhdmFpbGFibGUgb3Igbm90LiBUaGUgbWF0Y2hp
bmcgc3R1YiBmb3IgeGVuX2h2bV9tb2RpZmllZF9tZW1vcnkoKQ0KPj4+IHdpbGwgYXNzZXJ0
IGluIGNhc2UgaXQgaXMgcmVhY2hlZC4NCj4+Pg0KPj4+IFdoaWNoIGNoYW5nZSB3b3VsZCB5
b3UgZXhwZWN0IHByZWNpc2VseT8NCj4+DQo+PiAtLSA+OCAtLQ0KPj4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvc3lzdGVtL3hlbi1tYXBjYWNoZS5oIGIvaW5jbHVkZS9zeXN0ZW0veGVuLW1h
cGNhY2hlLmgNCj4+IGluZGV4IGI2OGYxOTZkZGQ1Li5iYjQ1NGE3Yzk2YyAxMDA2NDQNCj4+
IC0tLSBhL2luY2x1ZGUvc3lzdGVtL3hlbi1tYXBjYWNoZS5oDQo+PiArKysgYi9pbmNsdWRl
L3N5c3RlbS94ZW4tbWFwY2FjaGUuaA0KPj4gQEAgLTE0LDggKzE0LDYgQEANCj4+DQo+PiAg
IMKgdHlwZWRlZiBod2FkZHIgKCpwaHlzX29mZnNldF90b19nYWRkcl90KShod2FkZHIgcGh5
c19vZmZzZXQsDQo+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmFtX2FkZHJf
dCBzaXplKTsNCj4+IC0jaWZkZWYgQ09ORklHX1hFTl9JU19QT1NTSUJMRQ0KPj4gLQ0KPj4g
ICDCoHZvaWQgeGVuX21hcF9jYWNoZV9pbml0KHBoeXNfb2Zmc2V0X3RvX2dhZGRyX3QgZiwN
Cj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHZvaWQgKm9wYXF1ZSk7DQo+PiAgIMKgdWludDhfdCAqeGVuX21hcF9jYWNoZShNZW1vcnlS
ZWdpb24gKm1yLCBod2FkZHIgcGh5c19hZGRyLCBod2FkZHIgc2l6ZSwNCj4+IEBAIC0yOCw0
NCArMjYsNSBAQCB2b2lkIHhlbl9pbnZhbGlkYXRlX21hcF9jYWNoZSh2b2lkKTsNCj4+ICAg
wqB1aW50OF90ICp4ZW5fcmVwbGFjZV9jYWNoZV9lbnRyeShod2FkZHIgb2xkX3BoeXNfYWRk
ciwNCj4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh3YWRkciBuZXdfcGh5c19hZGRyLA0KPj4gICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaHdhZGRyIHNpemUpOw0KPj4gLSNlbHNlDQo+PiAtDQo+PiAtc3RhdGljIGlu
bGluZSB2b2lkIHhlbl9tYXBfY2FjaGVfaW5pdChwaHlzX29mZnNldF90b19nYWRkcl90IGYs
DQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm9pZCAqb3BhcXVlKQ0KPj4gLXsNCj4+IC19
DQo+PiAtDQo+PiAtc3RhdGljIGlubGluZSB1aW50OF90ICp4ZW5fbWFwX2NhY2hlKE1lbW9y
eVJlZ2lvbiAqbXIsDQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh3YWRkciBwaHlzX2FkZHIs
DQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh3YWRkciBzaXplLA0KPj4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByYW1fYWRkcl90IHJhbV9hZGRyX29mZnNldCwNCj4+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdWludDhfdCBsb2NrLA0KPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBib29sIGRtYSwN
Cj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBpc193cml0ZSkNCj4+IC17DQo+PiAtwqDC
oMKgIGFib3J0KCk7DQo+PiAtfQ0KPj4gLQ0KPj4gLXN0YXRpYyBpbmxpbmUgcmFtX2FkZHJf
dCB4ZW5fcmFtX2FkZHJfZnJvbV9tYXBjYWNoZSh2b2lkICpwdHIpDQo+PiAtew0KPj4gLcKg
wqDCoCBhYm9ydCgpOw0KPj4gLX0NCj4+IC0NCj4+IC1zdGF0aWMgaW5saW5lIHZvaWQgeGVu
X2ludmFsaWRhdGVfbWFwX2NhY2hlX2VudHJ5KHVpbnQ4X3QgKmJ1ZmZlcikNCj4+IC17DQo+
PiAtfQ0KPj4gLQ0KPj4gLXN0YXRpYyBpbmxpbmUgdm9pZCB4ZW5faW52YWxpZGF0ZV9tYXBf
Y2FjaGUodm9pZCkNCj4+IC17DQo+PiAtfQ0KPj4gLQ0KPj4gLXN0YXRpYyBpbmxpbmUgdWlu
dDhfdCAqeGVuX3JlcGxhY2VfY2FjaGVfZW50cnkoaHdhZGRyIG9sZF9waHlzX2FkZHIsDQo+
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaHdhZGRyIG5ld19w
aHlzX2FkZHIsDQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aHdhZGRyIHNpemUpDQo+PiAtew0KPj4gLcKgwqDCoCBhYm9ydCgpOw0KPj4gLX0NCj4+IC0N
Cj4+IC0jZW5kaWYNCj4+DQo+PiAgIMKgI2VuZGlmIC8qIFhFTl9NQVBDQUNIRV9IICovDQo+
IA0KPiAoc29ycnksIHRoZSBpbmNsdWRlL3N5c3RlbS94ZW4tbWFwY2FjaGUuaCBjaGFuZ2Ug
aXMgZm9yIHRoZSBuZXh0IHBhdGNoKQ0KPiANCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3N5
c3RlbS94ZW4uaCBiL2luY2x1ZGUvc3lzdGVtL3hlbi5oDQo+PiBpbmRleCA5OTBjMTlhOGVm
MC4uMDRmZTMwY2NhNTAgMTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL3N5c3RlbS94ZW4uaA0K
Pj4gKysrIGIvaW5jbHVkZS9zeXN0ZW0veGVuLmgNCj4+IEBAIC0zMCwyNSArMzAsMTYgQEAg
ZXh0ZXJuIGJvb2wgeGVuX2FsbG93ZWQ7DQo+Pg0KPj4gICDCoCNkZWZpbmUgeGVuX2VuYWJs
ZWQoKcKgwqDCoMKgwqDCoMKgwqDCoMKgICh4ZW5fYWxsb3dlZCkNCj4+DQo+PiAtdm9pZCB4
ZW5faHZtX21vZGlmaWVkX21lbW9yeShyYW1fYWRkcl90IHN0YXJ0LCByYW1fYWRkcl90IGxl
bmd0aCk7DQo+PiAtdm9pZCB4ZW5fcmFtX2FsbG9jKHJhbV9hZGRyX3QgcmFtX2FkZHIsIHJh
bV9hZGRyX3Qgc2l6ZSwNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc3RydWN0IE1lbW9yeVJlZ2lvbiAqbXIsIEVycm9yICoqZXJycCk7DQo+PiAtDQo+PiAg
IMKgI2Vsc2UgLyogIUNPTkZJR19YRU5fSVNfUE9TU0lCTEUgKi8NCj4+DQo+PiAgIMKgI2Rl
ZmluZSB4ZW5fZW5hYmxlZCgpIDANCj4+IC1zdGF0aWMgaW5saW5lIHZvaWQgeGVuX2h2bV9t
b2RpZmllZF9tZW1vcnkocmFtX2FkZHJfdCBzdGFydCwgcmFtX2FkZHJfdA0KPj4gbGVuZ3Ro
KQ0KPj4gLXsNCj4+IC3CoMKgwqAgLyogbm90aGluZyAqLw0KPj4gLX0NCj4+IC1zdGF0aWMg
aW5saW5lIHZvaWQgeGVuX3JhbV9hbGxvYyhyYW1fYWRkcl90IHJhbV9hZGRyLCByYW1fYWRk
cl90IHNpemUsDQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBNZW1vcnlSZWdpb24gKm1yLCBFcnJvciAqKmVy
cnApDQo+PiAtew0KPj4gLcKgwqDCoCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpOw0KPj4gLX0N
Cj4+DQo+PiAgIMKgI2VuZGlmIC8qIENPTkZJR19YRU5fSVNfUE9TU0lCTEUgKi8NCj4+DQo+
PiArdm9pZCB4ZW5faHZtX21vZGlmaWVkX21lbW9yeShyYW1fYWRkcl90IHN0YXJ0LCByYW1f
YWRkcl90IGxlbmd0aCk7DQo+PiArdm9pZCB4ZW5fcmFtX2FsbG9jKHJhbV9hZGRyX3QgcmFt
X2FkZHIsIHJhbV9hZGRyX3Qgc2l6ZSwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgTWVtb3J5UmVnaW9uICptciwgRXJyb3IgKiplcnJwKTsNCj4+ICsNCj4+
ICAgwqBib29sIHhlbl9tcl9pc19tZW1vcnkoTWVtb3J5UmVnaW9uICptcik7DQo+PiAgIMKg
Ym9vbCB4ZW5fbXJfaXNfZ3JhbnRzKE1lbW9yeVJlZ2lvbiAqbXIpOw0KPj4gICDCoCNlbmRp
Zg0KPj4gLS0tDQo+IA0KDQpTb3VuZHMgZ29vZCENCkkgd2lsbCBpbmNsdWRlIGl0IGluIG5l
eHQgdmVyc2lvbi4NCg==

