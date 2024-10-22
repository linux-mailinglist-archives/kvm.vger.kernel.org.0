Return-Path: <kvm+bounces-29437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D529AB7C1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 012AE2836A5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836D81CC89F;
	Tue, 22 Oct 2024 20:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l9BNkWNg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F061A2872
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629551; cv=none; b=sW0qMb0mBlgpLAaBQmA4Ckx7DlRnJxUxnxqGlyMBV9stC7K7eI40u23IpFpgvc0TVWRqglHxnh7bEvzPT0Q9n/vlMdMQsvuxfiZOfcifFZqyCikXVkPZe2l7tyJBgETGCXC2s5LyQOQ0HqfbVQJAuBagQCdybQW0M4dMya198SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629551; c=relaxed/simple;
	bh=DRsAXIB9LEH0Kfq9Xvrtn7bNNQzcDG9pHn14Tu2bxqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NlCy5NhRigygfipIN/jZ1YAJvfD1NRVikYDx8pJO7bCE3WwbLOEph2GGLFn0cvM7Fs9d2b5fKE6TsQKsg9TMq+AYpKbLZFGX48fH+SRLFlRU6M31OipHVxrzyNbAOD+ZABNeBjjlyy2jSm+vaSyKiTb8s12EPC6nwltR17AsA8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l9BNkWNg; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20ceb8bd22fso52006595ad.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629549; x=1730234349; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DRsAXIB9LEH0Kfq9Xvrtn7bNNQzcDG9pHn14Tu2bxqA=;
        b=l9BNkWNgg5CP5wbuNPKquRvy6zWzyM8/D8Qe75ucGJwSoQz6MHo2Q8yi5px7omYCR1
         qFUtOBzGlPX0Fv0UPAODet377fsj4cm6zM1zGHTAcXMW3C5wcOpN9x6m3ON10cNJVpwS
         G2HC9GZoIlTWF6Dx9hlWvYkSHN9AKLVBIkf/mnikFQkObQql+nIg2Gb6yLzddnLDHLGs
         H96DxJasHtisKiHDiJ9p/1+0VQfev/UgD6O0IPlRbqH0ovSdXFaKEu5WEZKL5b/7tUmq
         vjdHTOkXlkZ2yqb00kZaFWZPP1XHcnfMoW2VTyEHxIrGLw7xq8G1Vt3kjSZee7H2kCJi
         WGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629549; x=1730234349;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRsAXIB9LEH0Kfq9Xvrtn7bNNQzcDG9pHn14Tu2bxqA=;
        b=MEASR9Tei9DxLdIIWB5ljNpneU8EqF9o9rZQHZCXf1AxDbVW1PZAklwheqisQ+chzB
         bb49N//OpLR1Wq2sF5gQlAzSYzoUE+yTllLYykvwb63NJiK9vIHqDF5YJDeUp6aBpW9E
         sSMKFAKpRTUOSQMZpTtalWLQkrdUvLnQ7PbyQs1hpGhhvVaPHxhKbyXQaFV6bHfHJQv+
         Wu/k0SQ99PsKi1pEVLflSJCptNp+7qz5KdzYpfOzItHI3dvqbA45xoX1V9RFmSgjq5+V
         s3N3XlU4pY34n1zIwupWNQhwb49pW1+rxT5c/ov8eM9ogVncQBiee8Gd4lClYnoPtk/C
         UwIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLvfQJRcpz7fRJwmWiEUsmtTwmgQh7D6KofjVmDL+GQKytl1G95nxD3gOTL7mgMeVH3kw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxibmX4QPW02ShfBDO7kmf2TO1kWWEncyqzFzDsuNQ+3zWQuUBy
	/mVcyICcWjVwElWQ/Xaycxib/K/ZPLmc+3z93q6FkxjL5QKPrmeEp9D66hJC7sk=
X-Google-Smtp-Source: AGHT+IGt1Fb3pmNoo//aQQQ1vhTFngF3b24t4YRnbyHlN1Y2Itc8Pn6rVe3o6fPJztzHIB3Y0riOFw==
X-Received: by 2002:a17:902:ecc5:b0:20c:c086:4998 with SMTP id d9443c01a7336-20fab31ce28mr5195635ad.55.1729629549291;
        Tue, 22 Oct 2024 13:39:09 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee6259sm46764265ad.53.2024.10.22.13.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:39:08 -0700 (PDT)
Message-ID: <408a8dc9-721e-43d6-806a-b8344d962271@linaro.org>
Date: Tue, 22 Oct 2024 13:39:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/20] tests/tcg: enable basic testing for
 aarch64_be-linux-user
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
 <20241022105614.839199-14-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-14-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gV2UgZGlkbid0IG5v
dGljZSBicmVha2FnZSBvZiBhYXJjaDY0X2JlIGJlY2F1c2Ugd2UgZG9uJ3QgaGF2ZSBhbnkg
VENHDQo+IHRlc3RzIGZvciBpdC4gSG93ZXZlciB3aGlsZSB0aGUgZXhpc3RpbmcgYWFyY2g2
NCBjb21waWxlciBjYW4gdGFyZ2V0DQo+IGJpZy1lbmRpYW4gYnVpbGRzIG5vIG9uZSBwYWNr
YWdlcyBhIEJFIGxpYmMuIEluc3RlYWQgd2UgYmFuZyBzb21lDQo+IHJvY2tzIHRvZ2V0aGVy
IHRvIGRvIHRoZSBtb3N0IGJhc2ljIG9mIGhlbGxvIHdvcmxkIHdpdGggYSBub3N0ZGxpYg0K
PiBzeXNjYWxsIHRlc3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFs
ZXguYmVubmVlQGxpbmFyby5vcmc+DQo+IA0KPiAtLS0NCj4gdjINCj4gICAgLSBmaXggY2hl
Y2twYXRjaCBjb21wbGFpbnRzDQo+IC0tLQ0KPiAgIGNvbmZpZ3VyZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICA1ICsrKysNCj4gICB0ZXN0cy90Y2cvYWFyY2g2NF9iZS9oZWxs
by5jICAgICAgICAgfCAzNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAgdGVz
dHMvdGNnL01ha2VmaWxlLnRhcmdldCAgICAgICAgICAgIHwgIDcgKysrKystDQo+ICAgdGVz
dHMvdGNnL2FhcmNoNjRfYmUvTWFrZWZpbGUudGFyZ2V0IHwgMTcgKysrKysrKysrKysrKysN
Cj4gICA0IGZpbGVzIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvdGNnL2FhcmNoNjRfYmUvaGVsbG8uYw0K
PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0cy90Y2cvYWFyY2g2NF9iZS9NYWtlZmlsZS50
YXJnZXQNCj4gDQo+IGRpZmYgLS1naXQgYS9jb25maWd1cmUgYi9jb25maWd1cmUNCj4gaW5k
ZXggNzJkMWE5NDIyNS4uN2RkMzQwMGNjYiAxMDA3NTUNCj4gLS0tIGEvY29uZmlndXJlDQo+
ICsrKyBiL2NvbmZpZ3VyZQ0KPiBAQCAtMTQxOCw2ICsxNDE4LDcgQEAgcHJvYmVfdGFyZ2V0
X2NvbXBpbGVyKCkgew0KPiAgICAgdGFyZ2V0X2FyY2g9JHsxJSUtKn0NCj4gICAgIGNhc2Ug
JHRhcmdldF9hcmNoIGluDQo+ICAgICAgIGFhcmNoNjQpIGNvbnRhaW5lcl9ob3N0cz0ieDg2
XzY0IGFhcmNoNjQiIDs7DQo+ICsgICAgYWFyY2g2NF9iZSkgY29udGFpbmVyX2hvc3RzPSJ4
ODZfNjQgYWFyY2g2NCIgOzsNCj4gICAgICAgYWxwaGEpIGNvbnRhaW5lcl9ob3N0cz14ODZf
NjQgOzsNCj4gICAgICAgYXJtKSBjb250YWluZXJfaG9zdHM9Ing4Nl82NCBhYXJjaDY0IiA7
Ow0KPiAgICAgICBoZXhhZ29uKSBjb250YWluZXJfaG9zdHM9eDg2XzY0IDs7DQo+IEBAIC0x
NDQ3LDYgKzE0NDgsMTAgQEAgcHJvYmVfdGFyZ2V0X2NvbXBpbGVyKCkgew0KPiAgICAgICBj
YXNlICR0YXJnZXRfYXJjaCBpbg0KPiAgICAgICAgICMgZGViaWFuLWFsbC10ZXN0LWNyb3Nz
IGFyY2hpdGVjdHVyZXMNCj4gICANCj4gKyAgICAgIGFhcmNoNjRfYmUpDQo+ICsgICAgICAg
IGNvbnRhaW5lcl9pbWFnZT1kZWJpYW4tYWxsLXRlc3QtY3Jvc3MNCj4gKyAgICAgICAgY29u
dGFpbmVyX2Nyb3NzX3ByZWZpeD1hYXJjaDY0LWxpbnV4LWdudS0NCj4gKyAgICAgICAgOzsN
Cj4gICAgICAgICBocHBhfG02OGt8bWlwc3xyaXNjdjY0fHNwYXJjNjQpDQo+ICAgICAgICAg
ICBjb250YWluZXJfaW1hZ2U9ZGViaWFuLWFsbC10ZXN0LWNyb3NzDQo+ICAgICAgICAgICA7
Ow0KPiBkaWZmIC0tZ2l0IGEvdGVzdHMvdGNnL2FhcmNoNjRfYmUvaGVsbG8uYyBiL3Rlc3Rz
L3RjZy9hYXJjaDY0X2JlL2hlbGxvLmMNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5k
ZXggMDAwMDAwMDAwMC4uYTliMmFiNDVkZQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL3Rl
c3RzL3RjZy9hYXJjaDY0X2JlL2hlbGxvLmMNCj4gQEAgLTAsMCArMSwzNSBAQA0KPiArLyoN
Cj4gKyAqIE5vbi1saWJjIHN5c2NhbGwgaGVsbG8gd29ybGQgZm9yIEFhcmNoNjQgQkUNCj4g
KyAqDQo+ICsgKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0K
PiArICovDQo+ICsNCj4gKyNkZWZpbmUgX19OUl93cml0ZSA2NA0KPiArI2RlZmluZSBfX05S
X2V4aXQgOTMNCj4gKw0KPiAraW50IHdyaXRlKGludCBmZCwgY2hhciAqYnVmLCBpbnQgbGVu
KQ0KPiArew0KPiArICAgIHJlZ2lzdGVyIGludCB4MCBfX2FzbV9fKCJ4MCIpID0gZmQ7DQo+
ICsgICAgcmVnaXN0ZXIgY2hhciAqeDEgX19hc21fXygieDEiKSA9IGJ1ZjsNCj4gKyAgICBy
ZWdpc3RlciBpbnQgeDIgX19hc21fXygieDIiKSA9IGxlbjsNCj4gKyAgICByZWdpc3RlciBp
bnQgeDggX19hc21fXygieDgiKSA9IF9fTlJfd3JpdGU7DQo+ICsNCj4gKyAgICBhc20gdm9s
YXRpbGUoInN2YyAjMCIgOiA6ICJyIih4MCksICJyIih4MSksICJyIih4MiksICJyIih4OCkp
Ow0KPiArDQo+ICsgICAgcmV0dXJuIGxlbjsNCj4gK30NCj4gKw0KPiArdm9pZCBleGl0KGlu
dCByZXQpDQo+ICt7DQo+ICsgICAgcmVnaXN0ZXIgaW50IHgwIF9fYXNtX18oIngwIikgPSBy
ZXQ7DQo+ICsgICAgcmVnaXN0ZXIgaW50IHg4IF9fYXNtX18oIng4IikgPSBfX05SX2V4aXQ7
DQo+ICsNCj4gKyAgICBhc20gdm9sYXRpbGUoInN2YyAjMCIgOiA6ICJyIih4MCksICJyIih4
OCkpOw0KPiArICAgIF9fYnVpbHRpbl91bnJlYWNoYWJsZSgpOw0KPiArfQ0KPiArDQo+ICt2
b2lkIF9zdGFydCh2b2lkKQ0KPiArew0KPiArICAgIHdyaXRlKDEsICJIZWxsbyBXb3JsZFxu
IiwgMTIpOw0KPiArICAgIGV4aXQoMCk7DQo+ICt9DQo+IGRpZmYgLS1naXQgYS90ZXN0cy90
Y2cvTWFrZWZpbGUudGFyZ2V0IGIvdGVzdHMvdGNnL01ha2VmaWxlLnRhcmdldA0KPiBpbmRl
eCAyZGE3MGIyZmNmLi45NzIyMTQ1Yjk3IDEwMDY0NA0KPiAtLS0gYS90ZXN0cy90Y2cvTWFr
ZWZpbGUudGFyZ2V0DQo+ICsrKyBiL3Rlc3RzL3RjZy9NYWtlZmlsZS50YXJnZXQNCj4gQEAg
LTEwMyw5ICsxMDMsMTQgQEAgaWZlcSAoJChmaWx0ZXIgJS1zb2Z0bW11LCAkKFRBUkdFVCkp
LCkNCj4gICAjIHRoZW4gdGhlIHRhcmdldC4gSWYgdGhlcmUgYXJlIGNvbW1vbiB0ZXN0cyBz
aGFyZWQgYmV0d2Vlbg0KPiAgICMgc3ViLXRhcmdldHMgKGUuZy4gQVJNICYgQUFyY2g2NCkg
dGhlbiBpdCBpcyB1cCB0bw0KPiAgICMgJChUQVJHRVRfTkFNRSkvTWFrZWZpbGUudGFyZ2V0
IHRvIGluY2x1ZGUgdGhlIGNvbW1vbiBwYXJlbnQNCj4gLSMgYXJjaGl0ZWN0dXJlIGluIGl0
cyBWUEFUSC4NCj4gKyMgYXJjaGl0ZWN0dXJlIGluIGl0cyBWUEFUSC4gSG93ZXZlciBzb21l
IHRhcmdldHMgYXJlIHNvIG1pbmltYWwgd2UNCj4gKyMgY2FuJ3QgZXZlbiBidWlsZCB0aGUg
bXVsdGlhcmNoIHRlc3RzLg0KPiAraWZuZXEgKCQoZmlsdGVyICQoVEFSR0VUX05BTUUpLGFh
cmNoNjRfYmUpLCkNCj4gKy1pbmNsdWRlICQoU1JDX1BBVEgpL3Rlc3RzL3RjZy8kKFRBUkdF
VF9OQU1FKS9NYWtlZmlsZS50YXJnZXQNCj4gK2Vsc2UNCj4gICAtaW5jbHVkZSAkKFNSQ19Q
QVRIKS90ZXN0cy90Y2cvbXVsdGlhcmNoL01ha2VmaWxlLnRhcmdldA0KPiAgIC1pbmNsdWRl
ICQoU1JDX1BBVEgpL3Rlc3RzL3RjZy8kKFRBUkdFVF9OQU1FKS9NYWtlZmlsZS50YXJnZXQN
Cj4gK2VuZGlmDQo+ICAgDQo+ICAgIyBBZGQgdGhlIGNvbW1vbiBidWlsZCBvcHRpb25zDQo+
ICAgQ0ZMQUdTKz0tV2FsbCAtV2Vycm9yIC1PMCAtZyAtZm5vLXN0cmljdC1hbGlhc2luZw0K
PiBkaWZmIC0tZ2l0IGEvdGVzdHMvdGNnL2FhcmNoNjRfYmUvTWFrZWZpbGUudGFyZ2V0IGIv
dGVzdHMvdGNnL2FhcmNoNjRfYmUvTWFrZWZpbGUudGFyZ2V0DQo+IG5ldyBmaWxlIG1vZGUg
MTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAuLjI5N2QyY2Y3MWMNCj4gLS0tIC9kZXYvbnVs
bA0KPiArKysgYi90ZXN0cy90Y2cvYWFyY2g2NF9iZS9NYWtlZmlsZS50YXJnZXQNCj4gQEAg
LTAsMCArMSwxNyBAQA0KPiArIyAtKi0gTW9kZTogbWFrZWZpbGUgLSotDQo+ICsjDQo+ICsj
IEEgc3VwZXIgYmFzaWMgQUFyY2g2NCBCRSBtYWtlZmlsZS4gQXMgd2UgZG9uJ3QgaGF2ZSBh
bnkgYmlnLWVuZGlhbg0KPiArI2wgaWJjIGF2YWlsYWJsZSB0aGUgYmVzdCB3ZSBjYW4gZG8g
aXMgYSBiYXNpYyBIZWxsbyBXb3JsZC4NCj4gKw0KDQpzL2wgaWJjLyBsaWJjLw0KDQo+ICtB
QVJDSDY0QkVfU1JDPSQoU1JDX1BBVEgpL3Rlc3RzL3RjZy9hYXJjaDY0X2JlDQo+ICtWUEFU
SCArPSAkKEFBUkNINjRCRV9TUkMpDQo+ICsNCj4gK0FBUkNINjRCRV9URVNUX1NSQ1M9JChu
b3RkaXIgJCh3aWxkY2FyZCAkKEFBUkNINjRCRV9TUkMpLyouYykpDQo+ICtBQVJDSDY0QkVf
VEVTVFM9JChBQVJDSDY0QkVfVEVTVF9TUkNTOi5jPSkNCj4gKyNNVUxUSUFSQ0hfVEVTVFMg
PSAkKE1VTFRJQVJDSF9TUkNTOi5jPSkNCj4gKw0KPiArIyBXZSBuZWVkIHRvIHNwZWNpZnkg
YmlnLWVuZGlhbiBjZmxhZ3MNCj4gK0NGTEFHUyArPS1tYmlnLWVuZGlhbiAtZmZyZWVzdGFu
ZGluZw0KPiArTERGTEFHUyArPS1ub3N0ZGxpYg0KPiArDQo+ICtURVNUUyArPSAkKEFBUkNI
NjRCRV9URVNUUykNCg0KUmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNr
LmJvdXZpZXJAbGluYXJvLm9yZz4NCg==

