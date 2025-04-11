Return-Path: <kvm+bounces-43177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1814EA864F8
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 19:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE58C3AB8A6
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 17:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A223B23AE84;
	Fri, 11 Apr 2025 17:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="KP6JkVGJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF562238D52;
	Fri, 11 Apr 2025 17:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744393343; cv=none; b=c0hDQzP0xk+CEXVquOg48OThOSBJwpj9lFpD1ZuZgX5kt13xt6eJehZgowFedQ6k0qNwIQ0L8gIXUGWZjTo4YL/RnHgg9Flo6ktuBfaq/hlVO7QL9EcoZrR6OL+l94MLI9LF6QvZ9zoISH3BehSF8Ju9wRyCjdOUEd/4zAYuIuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744393343; c=relaxed/simple;
	bh=vfPoSRfQH477/CFLb6ZTwRTcQNsLhqllklqufNLvGCM=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UkkXUgPiinaSOktvq5tka6wiq0C1CdDrNjPYIMgBHRFzrisEcvfqJcBUFATuNcoSlrgUHg5buUjc3z9F8Kn/n5DiHtuLYs4qJZbdwYorSibKNX964LpZvC7W4N8AcluQT6YYo+hzjP8NObkO8bi9r9j68UkBhDbVuTtcLxBU5CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=KP6JkVGJ; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744393342; x=1775929342;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=vfPoSRfQH477/CFLb6ZTwRTcQNsLhqllklqufNLvGCM=;
  b=KP6JkVGJ40qUHSJy1GeTNKbwfzY7Jg2TyujHgw/Xeptx0fQwNS5DA+1u
   KNI/8a3DxZz2nIMAPjNQrLeAz6JQTIV2VhyfJIufapAx+EDTNrfXCMo6L
   +7cjnE4mdX2IrErxyO/bxcKIMjuADtbeWN1JF9vGq8CFS5ZqX/Moo7rl7
   I=;
X-IronPort-AV: E=Sophos;i="6.15,205,1739836800"; 
   d="scan'208";a="82951899"
Subject: Re: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
Thread-Topic: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 17:42:19 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:8072]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.8.63:2525] with esmtp (Farcaster)
 id 0532a55d-5243-42fd-a042-f17c28a7bc62; Fri, 11 Apr 2025 17:42:18 +0000 (UTC)
X-Farcaster-Flow-ID: 0532a55d-5243-42fd-a042-f17c28a7bc62
Received: from EX19D032UWA003.ant.amazon.com (10.13.139.37) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 11 Apr 2025 17:42:18 +0000
Received: from EX19D032UWA003.ant.amazon.com (10.13.139.37) by
 EX19D032UWA003.ant.amazon.com (10.13.139.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Fri, 11 Apr 2025 17:42:17 +0000
Received: from EX19D032UWA003.ant.amazon.com ([fe80::8e94:8f60:9531:c497]) by
 EX19D032UWA003.ant.amazon.com ([fe80::8e94:8f60:9531:c497%5]) with mapi id
 15.02.1544.014; Fri, 11 Apr 2025 17:42:17 +0000
From: "Okanovic, Haris" <harisokn@amazon.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"xueshuai@linux.alibaba.com" <xueshuai@linux.alibaba.com>,
	"ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC: "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "maz@kernel.org"
	<maz@kernel.org>, "zhenglifeng1@huawei.com" <zhenglifeng1@huawei.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "cl@gentwo.org"
	<cl@gentwo.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "misono.tomohiro@fujitsu.com"
	<misono.tomohiro@fujitsu.com>, "daniel.lezcano@linaro.org"
	<daniel.lezcano@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "will@kernel.org"
	<will@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"Okanovic, Haris" <harisokn@amazon.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Thread-Index: AQHbgkz0Ww97KFD5dk6R1pgSTFxUF7OeIC2AgADtWYA=
Date: Fri, 11 Apr 2025 17:42:17 +0000
Message-ID: <87639d1b017b6032c1d5382567415fad4e2c9e4e.camel@amazon.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
	 <20250218213337.377987-11-ankur.a.arora@oracle.com>
	 <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
In-Reply-To: <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A0A36EF8CE7174988CDDF9482C3DAC5@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI1LTA0LTExIGF0IDExOjMyICswODAwLCBTaHVhaSBYdWUgd3JvdGU6DQo+ID4g
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
PiANCj4gPiANCj4gPiANCj4gPiDlnKggMjAyNS8yLzE5IDA1OjMzLCBBbmt1ciBBcm9yYSDlhpnp
gZM6DQo+ID4gPiA+IE5lZWRlZCBmb3IgY3B1aWRsZS1oYWx0cG9sbC4NCj4gPiA+ID4gDQo+ID4g
PiA+IEFja2VkLWJ5OiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwub3JnPg0KPiA+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBBbmt1ciBBcm9yYSA8YW5rdXIuYS5hcm9yYUBvcmFjbGUuY29tPg0KPiA+ID4g
PiAtLS0NCj4gPiA+ID4gICBhcmNoL2FybTY0L2tlcm5lbC9pZGxlLmMgfCAxICsNCj4gPiA+ID4g
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gPiA+ID4gDQo+ID4gPiA+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9pZGxlLmMgYi9hcmNoL2FybTY0L2tlcm5lbC9pZGxl
LmMNCj4gPiA+ID4gaW5kZXggMDVjZmIzNDdlYzI2Li5iODViYTBkZjliMDIgMTAwNjQ0DQo+ID4g
PiA+IC0tLSBhL2FyY2gvYXJtNjQva2VybmVsL2lkbGUuYw0KPiA+ID4gPiArKysgYi9hcmNoL2Fy
bTY0L2tlcm5lbC9pZGxlLmMNCj4gPiA+ID4gQEAgLTQzLDMgKzQzLDQgQEAgdm9pZCBfX2NwdWlk
bGUgYXJjaF9jcHVfaWRsZSh2b2lkKQ0KPiA+ID4gPiAgICAgICAgKi8NCj4gPiA+ID4gICAgICAg
Y3B1X2RvX2lkbGUoKTsNCj4gPiANCj4gPiBIaSwgQW5rdXIsDQo+ID4gDQo+ID4gV2l0aCBoYWx0
cG9sbF9kcml2ZXIgcmVnaXN0ZXJlZCwgYXJjaF9jcHVfaWRsZSgpIG9uIHg4NiBjYW4gc2VsZWN0
DQo+ID4gbXdhaXRfaWRsZSgpIGluIGlkbGUgdGhyZWFkcy4NCj4gPiANCj4gPiBJdCB1c2UgTU9O
SVRPUiBzZXRzIHVwIGFuIGVmZmVjdGl2ZSBhZGRyZXNzIHJhbmdlIHRoYXQgaXMgbW9uaXRvcmVk
DQo+ID4gZm9yIHdyaXRlLXRvLW1lbW9yeSBhY3Rpdml0aWVzOyBNV0FJVCBwbGFjZXMgdGhlIHBy
b2Nlc3NvciBpbg0KPiA+IGFuIG9wdGltaXplZCBzdGF0ZSAodGhpcyBtYXkgdmFyeSBiZXR3ZWVu
IGRpZmZlcmVudCBpbXBsZW1lbnRhdGlvbnMpDQo+ID4gdW50aWwgYSB3cml0ZSB0byB0aGUgbW9u
aXRvcmVkIGFkZHJlc3MgcmFuZ2Ugb2NjdXJzLg0KPiA+IA0KPiA+IFNob3VsZCBhcmNoX2NwdV9p
ZGxlKCkgb24gYXJtNjQgYWxzbyB1c2UgdGhlIExEWFIvV0ZFDQo+ID4gdG8gYXZvaWQgd2FrZXVw
IElQSSBsaWtlIHg4NiBtb25pdG9yL213YWl0Pw0KDQpXRkUgd2lsbCB3YWtlIGZyb20gdGhlIGV2
ZW50IHN0cmVhbSwgd2hpY2ggY2FuIGhhdmUgc2hvcnQgc3ViLW1zDQpwZXJpb2RzIG9uIG1hbnkg
c3lzdGVtcy4gTWF5IGJlIHNvbWV0aGluZyB0byBjb25zaWRlciB3aGVuIFdGRVQgaXMgbW9yZQ0K
d2lkZWx5IGF2YWlsYWJsZS4NCg0KPiA+IA0KPiA+IFRoYW5rcy4NCj4gPiBTaHVhaQ0KPiA+IA0K
PiA+IA0KDQpSZWdhcmRzLA0KSGFyaXMgT2thbm92aWMNCkFXUyBHcmF2aXRvbiBTb2Z0d2FyZQ0K
DQo=

