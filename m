Return-Path: <kvm+bounces-29432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D979AB7A0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 517201C23002
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39341CBEA0;
	Tue, 22 Oct 2024 20:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p/qogEv6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EF51442E8
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629059; cv=none; b=FUUiFiKRiRHBeTzebaYq4jflu3MXlym+TTI2kTc2ke7dYheQJjSGSBCXqUy5FWoeuSZCr+bMDBruXFZH4k+DNFMzqmNOBxH8CpiKsVeyvNAS+I88s+iU4ldpksh7QLcTxV3AqImieyuz+j0ou2YvfVy8aWjYJjvDOH0oSd4xlqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629059; c=relaxed/simple;
	bh=mn0yUv/VNueViYeILhO/lJwpnkY1E2U10JXud4XZBsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I4UK/nTA9rP89zUeCfdTXyD8EUu9QVxGKYPKl72w6c9SRXNqbLOYd1BfGvNBmwN3xpf0ux6tQUxOOyOYw6UPi19cncXHFPFjYEpBjp21JqVFYHmALowpMYTWBKPzFO7dgtW1YMb5VzRC54mnE7NGF0JaQ8e1eD89xUlHlWASUgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p/qogEv6; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e59746062fso2451480a91.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629056; x=1730233856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mn0yUv/VNueViYeILhO/lJwpnkY1E2U10JXud4XZBsk=;
        b=p/qogEv6FKrtF7ChXeGWx68JLrHRWYv7VYYHlCPmlY4VTMV1WkSLwxsmjxUb6Ry2bK
         tKNZfvSdRQvCbQVPI49+J/1NB4QALCA6ePGWOmZKtyPrJh8Ch8dilbpGC2aFxFTCpJ0t
         lbhwkOLIZzq8srcHjVHEe/jQCNqcxMnY0eTvMvV+h1S6fHoB+Hxzif1xuy/EnmUKoics
         NKICHyzs8SaJtlz2lCHZj7TPVnMMMGzxl1x/RnIooyigbo6jZmlOfhVGFHzKvtPCQtTg
         E/f3jTsyDl2eSqYcBk3ztdL1IarPrFk3NAxBkAJKCqITrkBkXNimzUtuEkxOZGhhCHkf
         lYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629056; x=1730233856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mn0yUv/VNueViYeILhO/lJwpnkY1E2U10JXud4XZBsk=;
        b=gkie9UvQC+VBoWmCqIz1hAVskBQ6gU06ctsZxl/7szzOB25bI4wLUSmGRzNBGjm3I+
         autuIqlU5JKgU5HXIocxJ7I2gKMswGAOQVcI/lbn0NqW9CJgSs8J5M7mYffYFWTpmBY/
         zcL0P7VGXPRGh0Pcm5ve18q501ymBMu+hr/BZtKp9Qsg26QNhXTYEBQZA/Q6e957gnlW
         08BkRTj0OYJIpshowTPgESbZ3oNKxaabFxPMRn0O6qXQqgmB2uG3z7NReQyv3vXAKQ5P
         a/cfUM/5fHYxc0W2Hi1qY+WFug91J7ApvamaEY4OEx4ks1HDwx4pArl120+ijWkpkV+e
         562w==
X-Forwarded-Encrypted: i=1; AJvYcCXCd0Xf7GOlwA6BAftCTTVTjLYSx3F//QY7R5jXYEh1dTH6sVTOjj4qy8yu1rnmeJGDtZk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVjzVbhpqu//YWDgGLUIJavg7Envq5EWwGEseWhuqqO/4fkEu1
	IRRIXCRW3a80fHZhrvhRM6W3Nz/+nIhgkS1pvMcf0e28XygsesQdIReWIj13atw=
X-Google-Smtp-Source: AGHT+IFStsDu3D39MVTj4FAFck5GuxbFhm8mNq6Eqrj528hfwM/5gYgTzL2d2fBLL6mi8NCVKZcbZA==
X-Received: by 2002:a17:90a:ca08:b0:2e2:8995:dd1b with SMTP id 98e67ed59e1d1-2e76b5b67aamr216165a91.3.1729629056298;
        Tue, 22 Oct 2024 13:30:56 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm6673854a91.14.2024.10.22.13.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:30:55 -0700 (PDT)
Message-ID: <7fcd1db2-3df8-4d1b-8651-ba8bea1abd83@linaro.org>
Date: Tue, 22 Oct 2024 13:30:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/20] tests/docker: Fix microblaze atomics
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
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-2-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-2-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTUsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gRnJvbTogSWx5YSBM
ZW9zaGtldmljaCA8aWlpQGxpbnV4LmlibS5jb20+DQo+IA0KPiBHQ0MgcHJvZHVjZXMgaW52
YWxpZCBjb2RlIGZvciBtaWNyb2JsYXplIGF0b21pY3MuDQo+IA0KPiBUaGUgZml4IGlzIHVu
Zm9ydHVuYXRlbHkgbm90IHVwc3RyZWFtLCBzbyBmZXRjaCBpdCBmcm9tIGFuIGV4dGVybmFs
DQo+IGxvY2F0aW9uIGFuZCBhcHBseSBpdCBsb2NhbGx5Lg0KPiANCj4gU3VnZ2VzdGVkLWJ5
OiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+DQo+IFNpZ25lZC1v
ZmYtYnk6IElseWEgTGVvc2hrZXZpY2ggPGlpaUBsaW51eC5pYm0uY29tPg0KPiBNZXNzYWdl
LUlkOiA8MjAyNDA5MTkxNTIzMDguMTA0NDAtMS1paWlAbGludXguaWJtLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiAt
LS0NCj4gICAuLi4vZGViaWFuLW1pY3JvYmxhemUtY3Jvc3MuZC9idWlsZC10b29sY2hhaW4u
c2ggICAgICAgICAgfCA4ICsrKysrKysrDQo+ICAgdGVzdHMvZG9ja2VyL2RvY2tlcmZpbGVz
L2RlYmlhbi10b29sY2hhaW4uZG9ja2VyICAgICAgICAgIHwgNyArKysrKysrDQo+ICAgMiBm
aWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGVz
dHMvZG9ja2VyL2RvY2tlcmZpbGVzL2RlYmlhbi1taWNyb2JsYXplLWNyb3NzLmQvYnVpbGQt
dG9vbGNoYWluLnNoIGIvdGVzdHMvZG9ja2VyL2RvY2tlcmZpbGVzL2RlYmlhbi1taWNyb2Js
YXplLWNyb3NzLmQvYnVpbGQtdG9vbGNoYWluLnNoDQo+IGluZGV4IDIzZWMwYWE5YTcuLmM1
Y2QwYWE5MzEgMTAwNzU1DQo+IC0tLSBhL3Rlc3RzL2RvY2tlci9kb2NrZXJmaWxlcy9kZWJp
YW4tbWljcm9ibGF6ZS1jcm9zcy5kL2J1aWxkLXRvb2xjaGFpbi5zaA0KPiArKysgYi90ZXN0
cy9kb2NrZXIvZG9ja2VyZmlsZXMvZGViaWFuLW1pY3JvYmxhemUtY3Jvc3MuZC9idWlsZC10
b29sY2hhaW4uc2gNCj4gQEAgLTEwLDYgKzEwLDggQEAgVE9PTENIQUlOX0lOU1RBTEw9L3Vz
ci9sb2NhbA0KPiAgIFRPT0xDSEFJTl9CSU49JHtUT09MQ0hBSU5fSU5TVEFMTH0vYmluDQo+
ICAgQ1JPU1NfU1lTUk9PVD0ke1RPT0xDSEFJTl9JTlNUQUxMfS8kVEFSR0VUL3N5cy1yb290
DQo+ICAgDQo+ICtHQ0NfUEFUQ0gwX1VSTD1odHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVu
dC5jb20vWGlsaW54L21ldGEteGlsaW54L3JlZnMvdGFncy94bG54LXJlbC12MjAyNC4xL21l
dGEtbWljcm9ibGF6ZS9yZWNpcGVzLWRldnRvb2xzL2djYy9nY2MtMTIvMDAwOS1QYXRjaC1t
aWNyb2JsYXplLUZpeC1hdG9taWMtYm9vbGVhbi1yZXR1cm4tdmFsdWUucGF0Y2gNCj4gKw0K
PiAgIGV4cG9ydCBQQVRIPSR7VE9PTENIQUlOX0JJTn06JFBBVEgNCj4gICANCj4gICAjDQo+
IEBAIC0zMSw2ICszMywxMiBAQCBtdiBnY2MtMTEuMi4wIHNyYy1nY2MNCj4gICBtdiBtdXNs
LTEuMi4yIHNyYy1tdXNsDQo+ICAgbXYgbGludXgtNS4xMC43MCBzcmMtbGludXgNCj4gICAN
Cj4gKyMNCj4gKyMgUGF0Y2ggZ2NjDQo+ICsjDQo+ICsNCj4gK3dnZXQgLU8gLSAke0dDQ19Q
QVRDSDBfVVJMfSB8IHBhdGNoIC1kIHNyYy1nY2MgLXAxDQo+ICsNCj4gICBta2RpciAtcCBi
bGQtaGRyIGJsZC1iaW51IGJsZC1nY2MgYmxkLW11c2wNCj4gICBta2RpciAtcCAke0NST1NT
X1NZU1JPT1R9L3Vzci9pbmNsdWRlDQo+ICAgDQo+IGRpZmYgLS1naXQgYS90ZXN0cy9kb2Nr
ZXIvZG9ja2VyZmlsZXMvZGViaWFuLXRvb2xjaGFpbi5kb2NrZXIgYi90ZXN0cy9kb2NrZXIv
ZG9ja2VyZmlsZXMvZGViaWFuLXRvb2xjaGFpbi5kb2NrZXINCj4gaW5kZXggNjg3YTk3ZmVj
NC4uYWI0Y2UyOTUzMyAxMDA2NDQNCj4gLS0tIGEvdGVzdHMvZG9ja2VyL2RvY2tlcmZpbGVz
L2RlYmlhbi10b29sY2hhaW4uZG9ja2VyDQo+ICsrKyBiL3Rlc3RzL2RvY2tlci9kb2NrZXJm
aWxlcy9kZWJpYW4tdG9vbGNoYWluLmRvY2tlcg0KPiBAQCAtMTAsNiArMTAsOCBAQCBGUk9N
IGRvY2tlci5pby9saWJyYXJ5L2RlYmlhbjoxMS1zbGltDQo+ICAgIyA/Pz8gVGhlIGJ1aWxk
LWRlcCBpc24ndCB3b3JraW5nLCBtaXNzaW5nIGEgbnVtYmVyIG9mDQo+ICAgIyBtaW5pbWFs
IGJ1aWxkIGRlcGVuZGllbmNpZXMsIGUuZy4gbGlibXBjLg0KPiAgIA0KPiArUlVOIHNlZCAn
cy9eZGViIC9kZWItc3JjIC8nIDwvZXRjL2FwdC9zb3VyY2VzLmxpc3QgPi9ldGMvYXB0L3Nv
dXJjZXMubGlzdC5kL2RlYi1zcmMubGlzdA0KPiArDQo+ICAgUlVOIGFwdCB1cGRhdGUgJiYg
XA0KPiAgICAgICBERUJJQU5fRlJPTlRFTkQ9bm9uaW50ZXJhY3RpdmUgYXB0IGluc3RhbGwg
LXl5IGVhdG15ZGF0YSAmJiBcDQo+ICAgICAgIERFQklBTl9GUk9OVEVORD1ub25pbnRlcmFj
dGl2ZSBlYXRteWRhdGEgXA0KPiBAQCAtMzMsNiArMzUsMTEgQEAgUlVOIGNkIC9yb290ICYm
IC4vYnVpbGQtdG9vbGNoYWluLnNoDQo+ICAgIyBhbmQgdGhlIGJ1aWxkIHRyZWVzIGJ5IHJl
c3RvcmluZyB0aGUgb3JpZ2luYWwgaW1hZ2UsDQo+ICAgIyB0aGVuIGNvcHlpbmcgdGhlIGJ1
aWx0IHRvb2xjaGFpbiBmcm9tIHN0YWdlIDAuDQo+ICAgRlJPTSBkb2NrZXIuaW8vbGlicmFy
eS9kZWJpYW46MTEtc2xpbQ0KPiArUlVOIGFwdCB1cGRhdGUgJiYgXA0KPiArICAgIERFQklB
Tl9GUk9OVEVORD1ub25pbnRlcmFjdGl2ZSBhcHQgaW5zdGFsbCAteXkgZWF0bXlkYXRhICYm
IFwNCj4gKyAgICBERUJJQU5fRlJPTlRFTkQ9bm9uaW50ZXJhY3RpdmUgZWF0bXlkYXRhIFwN
Cj4gKyAgICBhcHQgaW5zdGFsbCAteSAtLW5vLWluc3RhbGwtcmVjb21tZW5kcyBcDQo+ICsg
ICAgICAgIGxpYm1wYzMNCj4gICBDT1BZIC0tZnJvbT0wIC91c3IvbG9jYWwgL3Vzci9sb2Nh
bA0KPiAgICMgQXMgYSBmaW5hbCBzdGVwIGNvbmZpZ3VyZSB0aGUgdXNlciAoaWYgZW52IGlz
IGRlZmluZWQpDQo+ICAgQVJHIFVTRVINCg0KUmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZp
ZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCg==

