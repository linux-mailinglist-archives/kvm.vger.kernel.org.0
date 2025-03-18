Return-Path: <kvm+bounces-41433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CCFA67BB9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E1713B1771
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262EE212FAC;
	Tue, 18 Mar 2025 18:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KHV6gcuX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00755212D65
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321636; cv=none; b=FQzxI0AC/48Re/SSHZrxMkrjKXVaKGSGXHj3r8B23DdRBT4im80N+906/DggRCrR6wMJiUrz1J+fs8cXFLlAde3mZmmnOMy1grbcCo53fleDKG0l5HorBPYwUFXz7UBSWrEGFctMupQlYPJKcTSuNBGU9Z+JKuv6p+pY/A/vN+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321636; c=relaxed/simple;
	bh=lmUQbfDb36TKJU3sYGzcNnijG6zoXKkNnWbTZWel+Eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1keqq6yR1FQIbs82k9Sia0zQVHeXyEpV4SX34GQiJwapAsjpyzSyHwIZSalCLvAsaTNa+RyG33XtznYkUztvolND15nFPMC4/bCIvmAThjmcsPsW+pbB8LNRnUmIZ2LK0gw/VCh4M/CRS0mj/fNRSFYfySkPufp9LRSli5rjDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KHV6gcuX; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22403cbb47fso113523615ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742321633; x=1742926433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lmUQbfDb36TKJU3sYGzcNnijG6zoXKkNnWbTZWel+Eg=;
        b=KHV6gcuXYicOJ/WumIJcGTsZXBxYBW9wWSMbaENz+WCVammAtj82xF6Jd9/bJNHwVB
         staSBmnpg33Md5VbEayL6uAFgnSnMNHze7EcX+O2/kT7NL89AgoWm6NMyCeWRCoaylkJ
         Y5Zmp4e4p7JyKgHiR0JUfO3X3siLCK4DHt3Wjbd/f7sWu+9UCoSVQSuwj9b9Am1T5V4q
         X/9cV/AWiXwZXuCrsEL6pBgoTqnwVFmH527CrgpxllU8hU6PviBQASrz5/lhTWI0YeZd
         EvMFgaKt57vHjV6XHKCqgCuMehBDtwygQKERE+Yiy2uVBsxEqHO8UgseMODH4MWdkCvn
         YyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742321633; x=1742926433;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmUQbfDb36TKJU3sYGzcNnijG6zoXKkNnWbTZWel+Eg=;
        b=s3Rqa8u+XIn7xAVJr4IN+IcIQD+YzuBBcwbXccrwauY4oi2xJoz9pHthG9t+zIioO6
         /7lfb5a/nneT5etKzulcN+5WihiwjUCEPv849O+KlbPdg5aSBWz+mQbmoRtvyepHbd+Z
         YIXzeLy1f5l9BtHicT4tlWfxCJW1BDiM+GwE3FfWooIIjBppAO3+2vGJRXJLsJjp5cfe
         BSZecCbxtQQWPzkjWYIFELxqhENBcXKvuaX2dR79QyoVZ4xCNnDxV23RNF9U/vzPhFX/
         v2vzJHtYqkfB3Vky/LlWgWsWqWDSAkyhFKtFxPBErh6jEezSGzT+eq4WKtyz+S2Btum8
         sfiw==
X-Forwarded-Encrypted: i=1; AJvYcCW4z7x/pg2SovbyQiv4IipoRh5ILqjMxaieV4ToKCfgPhdOOHEhi0r1OTa2SuGSnUxkMoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhdbpiHe1b8bsCwW5M+bWsN9Kzy+9EQ4jFgenu+sU43RAcYXhD
	A32gH2fq7FQvYkrHyQ9W3759xB5IDEijhiPSkalNN0f2wXX4SjKdxM/oA05MJBo=
X-Gm-Gg: ASbGncumIRPPggJjXEY9AI5gYS8g1WYxQYT6sSiHUx6DxwThINGbQRiK3zm82he9sQK
	3nKhnsGrde7qymwDPC3iLfNLsd6qmKdFBlKE43Jy4G5rN0T7b5TNgJvoB6od8Fg+CcFrrRZga0q
	gxOm7z4yWI59YxrIig6hTbNbp4ohFKmLMMM88qwDlxNHb6NQuCyqKDG618pkM5jt4g6Ue5E/JAx
	fZKxDANCirsVBkoQyQZ17fEBoWV1agpGonx67bBBoylQcXCNJy95ypgBkoe6tRA2dlIuesLm5i+
	Y25aK5rZePabe6lBRx49HUiPfXr4vcG37TozQLgRzZJyzzUjKDedfmHfug==
X-Google-Smtp-Source: AGHT+IGC4O6xkU9iAtNKj1qbqiWAy/fyUW5mk3mtgeMn6dcnh9ulFRbfkTwNDCZJfKmGVlCQn/E7NQ==
X-Received: by 2002:a05:6a00:4f92:b0:736:532b:7c10 with SMTP id d2e1a72fcca58-737223fccabmr22570526b3a.21.1742321633062;
        Tue, 18 Mar 2025 11:13:53 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737116b1103sm9939246b3a.167.2025.03.18.11.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 11:13:52 -0700 (PDT)
Message-ID: <8291b89a-9e97-47e6-9ee6-fd407066c3bf@linaro.org>
Date: Tue, 18 Mar 2025 11:13:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32
 emulation
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, qemu-arm@nongnu.org, alex.bennee@linaro.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org>
 <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
 <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com>
 <a3b61916-2466-4ec8-a4e1-567581be7a2b@linaro.org>
 <CAFEAcA9jsFqD-BR+zTzWV1V92fJqpghaOrGq1rDcdidm=R94Pw@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <CAFEAcA9jsFqD-BR+zTzWV1V92fJqpghaOrGq1rDcdidm=R94Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxMTowNiwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToNCj4gT24gVHVlLCAxOCBN
YXIgMjAyNSBhdCAxNzo1MiwgUGllcnJpY2sgQm91dmllcg0KPiA8cGllcnJpY2suYm91dmll
ckBsaW5hcm8ub3JnPiB3cm90ZToNCj4+DQo+PiBPbiAzLzE4LzI1IDEwOjUwLCBQZXRlciBN
YXlkZWxsIHdyb3RlOg0KPj4+IE9uIFR1ZSwgMTggTWFyIDIwMjUgYXQgMTc6NDIsIFBoaWxp
cHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4gd3JvdGU6DQo+Pj4+DQo+
Pj4+IE9uIDE4LzMvMjUgMDU6NTEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+Pj4+PiBE
aXJlY3RseSBjb25kaXRpb24gYXNzb2NpYXRlZCBjYWxscyBpbiB0YXJnZXQvYXJtL2hlbHBl
ci5jIGZvciBub3cuDQo+Pj4+Pg0KPj4+Pj4gU2lnbmVkLW9mZi1ieTogUGllcnJpY2sgQm91
dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPj4+Pj4gLS0tDQo+Pj4+PiAg
ICAgdGFyZ2V0L2FybS9jcHUuaCAgICB8IDggLS0tLS0tLS0NCj4+Pj4+ICAgICB0YXJnZXQv
YXJtL2hlbHBlci5jIHwgNiArKysrKysNCj4+Pj4+ICAgICAyIGZpbGVzIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4+Pj4+DQo+Pj4+PiBkaWZmIC0tZ2l0
IGEvdGFyZ2V0L2FybS9jcHUuaCBiL3RhcmdldC9hcm0vY3B1LmgNCj4+Pj4+IGluZGV4IDUx
YjY0MjhjZmVjLi45MjA1Y2JkZWM0MyAxMDA2NDQNCj4+Pj4+IC0tLSBhL3RhcmdldC9hcm0v
Y3B1LmgNCj4+Pj4+ICsrKyBiL3RhcmdldC9hcm0vY3B1LmgNCj4+Pj4+IEBAIC0xMjIyLDcg
KzEyMjIsNiBAQCBpbnQgYXJtX2NwdV93cml0ZV9lbGYzMl9ub3RlKFdyaXRlQ29yZUR1bXBG
dW5jdGlvbiBmLCBDUFVTdGF0ZSAqY3MsDQo+Pj4+PiAgICAgICovDQo+Pj4+PiAgICAgdm9p
ZCBhcm1fZW11bGF0ZV9maXJtd2FyZV9yZXNldChDUFVTdGF0ZSAqY3B1c3RhdGUsIGludCB0
YXJnZXRfZWwpOw0KPj4+Pj4NCj4+Pj4+IC0jaWZkZWYgVEFSR0VUX0FBUkNINjQNCj4+Pj4+
ICAgICBpbnQgYWFyY2g2NF9jcHVfZ2RiX3JlYWRfcmVnaXN0ZXIoQ1BVU3RhdGUgKmNwdSwg
R0J5dGVBcnJheSAqYnVmLCBpbnQgcmVnKTsNCj4+Pj4+ICAgICBpbnQgYWFyY2g2NF9jcHVf
Z2RiX3dyaXRlX3JlZ2lzdGVyKENQVVN0YXRlICpjcHUsIHVpbnQ4X3QgKmJ1ZiwgaW50IHJl
Zyk7DQo+Pj4+PiAgICAgdm9pZCBhYXJjaDY0X3N2ZV9uYXJyb3dfdnEoQ1BVQVJNU3RhdGUg
KmVudiwgdW5zaWduZWQgdnEpOw0KPj4+Pj4gQEAgLTEyNTQsMTMgKzEyNTMsNiBAQCBzdGF0
aWMgaW5saW5lIHVpbnQ2NF90ICpzdmVfYnN3YXA2NCh1aW50NjRfdCAqZHN0LCB1aW50NjRf
dCAqc3JjLCBpbnQgbnIpDQo+Pj4+PiAgICAgI2VuZGlmDQo+Pj4+PiAgICAgfQ0KPj4+Pj4N
Cj4+Pj4+IC0jZWxzZQ0KPj4+Pj4gLXN0YXRpYyBpbmxpbmUgdm9pZCBhYXJjaDY0X3N2ZV9u
YXJyb3dfdnEoQ1BVQVJNU3RhdGUgKmVudiwgdW5zaWduZWQgdnEpIHsgfQ0KPj4+Pj4gLXN0
YXRpYyBpbmxpbmUgdm9pZCBhYXJjaDY0X3N2ZV9jaGFuZ2VfZWwoQ1BVQVJNU3RhdGUgKmVu
diwgaW50IG8sDQo+Pj4+PiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBpbnQgbiwgYm9vbCBhKQ0KPj4+Pj4gLXsgfQ0KPj4+Pj4gLSNlbmRpZg0KPj4+Pj4g
LQ0KPj4+Pj4gICAgIHZvaWQgYWFyY2g2NF9zeW5jXzMyX3RvXzY0KENQVUFSTVN0YXRlICpl
bnYpOw0KPj4+Pj4gICAgIHZvaWQgYWFyY2g2NF9zeW5jXzY0X3RvXzMyKENQVUFSTVN0YXRl
ICplbnYpOw0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2hlbHBlci5j
IGIvdGFyZ2V0L2FybS9oZWxwZXIuYw0KPj4+Pj4gaW5kZXggYjQ2YjJiZmZjZjMuLjc3NGUx
ZWUwMjQ1IDEwMDY0NA0KPj4+Pj4gLS0tIGEvdGFyZ2V0L2FybS9oZWxwZXIuYw0KPj4+Pj4g
KysrIGIvdGFyZ2V0L2FybS9oZWxwZXIuYw0KPj4+Pj4gQEAgLTY1NjIsNyArNjU2Miw5IEBA
IHN0YXRpYyB2b2lkIHpjcl93cml0ZShDUFVBUk1TdGF0ZSAqZW52LCBjb25zdCBBUk1DUFJl
Z0luZm8gKnJpLA0KPj4+Pj4gICAgICAgICAgKi8NCj4+Pj4+ICAgICAgICAgbmV3X2xlbiA9
IHN2ZV92cW0xX2Zvcl9lbChlbnYsIGN1cl9lbCk7DQo+Pj4+PiAgICAgICAgIGlmIChuZXdf
bGVuIDwgb2xkX2xlbikgew0KPj4+Pj4gKyNpZmRlZiBUQVJHRVRfQUFSQ0g2NA0KPj4+Pg0K
Pj4+PiBXaGF0IGFib3V0IHVzaW5nIHJ1bnRpbWUgY2hlY2sgaW5zdGVhZD8NCj4+Pj4NCj4+
Pj4gICAgIGlmIChhcm1fZmVhdHVyZSgmY3B1LT5lbnYsIEFSTV9GRUFUVVJFX0FBUkNINjQp
ICYmIG5ld19sZW4gPCBvbGRfbGVuKSB7DQo+Pj4+DQo+Pj4NCj4+PiBUaGF0IHdvdWxkIGJl
IGEgZGVhZCBjaGVjazogaXQgaXMgbm90IHBvc3NpYmxlIHRvIGdldCBoZXJlDQo+Pj4gdW5s
ZXNzIEFSTV9GRUFUVVJFX0FBUkNINjQgaXMgc2V0Lg0KPj4+DQo+Pg0KPj4gV2UgY2FuIHRo
ZW4gYXNzZXJ0IGl0LCB0byBtYWtlIHN1cmUgdGhlcmUgaXMgbm8gcmVncmVzc2lvbiBhcm91
bmQgdGhhdC4NCj4gDQo+IFdlIGhhdmUgYSBsb3Qgb2Ygd3JpdGUvcmVhZC9hY2Nlc3MgZm5z
IGZvciBBQXJjaDY0LW9ubHkgc3lzcmVncywgYW5kDQo+IHdlIGRvbid0IG5lZWQgdG8gYXNz
ZXJ0IGluIGFsbCBvZiB0aGVtIHRoYXQgdGhleSdyZSBjYWxsZWQgb25seSB3aGVuDQo+IHRo
ZSBDUFUgaGFzIEFBcmNoNjQgZW5hYmxlZC4NCj4gDQo+PiBXZSBub3cgaGF2ZSBhbm90aGVy
IGNvbnZlcnNhdGlvbiBhbmQgc29tZXRoaW5nIHRvIGRlY2lkZSBpbiBhbm90aGVyDQo+PiBm
aWxlLCBhbmQgdGhhdCdzIHdoeSBJIGNob3NlIHRvIGRvIHRoZSBtaW5pbWFsIGNoYW5nZSAo
ImlmZGVmIHRoZQ0KPj4gaXNzdWUiKSBpbnN0ZWFkIG9mIHRyeWluZyB0byBkbyBhbnkgY2hh
bmdlLg0KPiANCj4gSSB0aGluayB3ZSBjYW4gZmFpcmx5IGVhc2lseSBhdm9pZCBpZmRlZmZp
bmcgdGhlIGNhbGxzaXRlIG9mDQo+IGFhcmNoNjRfc3ZlX25hcnJvd192cSgpLiBDdXJyZW50
bHkgd2UgaGF2ZToNCj4gICAqIGEgcmVhbCB2ZXJzaW9uIG9mIHRoZSBmdW5jdGlvbiwgd2hv
c2UgZGVmaW5pdGlvbiBpcyBpbnNpZGUNCj4gICAgIGFuIGlmZGVmIFRBUkdFVF9BQVJDSDY0
IGluIHRhcmdldC9hcm0vaGVscGVyLmMNCj4gICAqIGEgc3R1YiB2ZXJzaW9uLCBpbmxpbmUg
aW4gdGhlIGNwdS5oIGhlYWRlcg0KPiANCj4gSWYgd2UgZG9uJ3Qgd2FudCB0byBoYXZlIHRo
ZSBzdHViIHZlcnNpb24gd2l0aCBpZmRlZnMsIHRoZW4gd2UgY2FuDQo+IG1vdmUgdGhlIHJl
YWwgaW1wbGVtZW50YXRpb24gb2YgdGhlIGZ1bmN0aW9uIHRvIG5vdCBiZSBpbnNpZGUgdGhl
DQo+IGlmZGVmIChtYXRjaGluZyB0aGUgZmFjdCB0aGF0IHRoZSBwcm90b3R5cGUgaXMgbm8g
bG9uZ2VyIGluc2lkZQ0KPiBhbiBpZmRlZikuIFRoZSBmdW5jdGlvbiBkb2Vzbid0IGNhbGwg
YW55IG90aGVyIGZ1bmN0aW9ucyB0aGF0IGFyZQ0KPiBUQVJHRVRfQUFSQ0g2NCBvbmx5LCBz
byBpdCBzaG91bGRuJ3QgYmUgYSAibm93IHdlIGhhdmUgdG8gbW92ZQ0KPiA1MCBvdGhlciB0
aGluZ3MiIHByb2JsZW0sIEkgaG9wZS4NCj4gDQoNCkknbGwgdHJ5IHRvIGp1c3QgbGV0IHRo
ZSBjYWxsIGJlIGRvbmUsIGFuZCBzZWUgd2hhdCBoYXBwZW5zLg0KQnV0IGlmIEkgbWVldCBh
IHJlZ3Jlc3Npb24gc29tZXdoZXJlIGluIHRhcmdldC9hcm0vKiwgSSdsbCBzaW1wbHkNCmxl
dCB0aGUgY3VycmVudCBpZmRlZiBmb3Igbm93Lg0KDQpJIHVuZGVyc3RhbmQgaXQgInNob3Vs
ZCBiZSBvayIsIGJ1dCBJIGp1c3Qgd2FudCB0byBmb2N1cyBvbiBody9hcm0sIGFuZCANCm5v
dCBzdGFydCBmdXJ0aGVyIGNoYW5nZXMgaW4gdGFyZ2V0L2FybS9oZWxwZXIuYyBhcyBhIHNp
ZGUgZWZmZWN0IG9mIA0Kc2ltcGx5IG1vdmluZyBhbiBpZmRlZiBpbiBhIGhlYWRlci4NCg0K
PiB0aGFua3MNCj4gLS0gUE1NDQoNCg==

