Return-Path: <kvm+bounces-22057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D384793909B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01D981C212EE
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 14:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD63016DC12;
	Mon, 22 Jul 2024 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="gC7vVOEk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748EA16D4DF
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658390; cv=none; b=QOuyqB9VlxMFkY2TPNNc/5a4j1BpJKHnx/05tY2IM6edu2s51cgEvtr5QDGpuh3aTcqzvA1YdUR+d/F8K055pQmm0JjGCHo1Ewi/+pEA2mdKnQuiTaeC7XyWcBKiEoOXoDL8c9ece/ZrqVqOeDe0ZEzHuW3M9v4++P/VIIpRmlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658390; c=relaxed/simple;
	bh=L3vELbQaQH/HN6PrbWYQaK02xoL5wSf1Hk2fk0NM1NE=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nzDG/eYoLjzXGS7N9h4mR480QgWY+gaOAoEikuh8DkTf5/inv8UbtNHxoDjt/1rbo8Dv5HeWm4k/OAbRGr8XDy63adEQYi6S+VXbHUNwy2+Ega7KdkMUQJ/0IRvhvtefl1dab2gYPbJhRHlAYeKLTd3oWn0ExxqqOUPKpjX7Sxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=gC7vVOEk; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1721658388; x=1753194388;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=L3vELbQaQH/HN6PrbWYQaK02xoL5wSf1Hk2fk0NM1NE=;
  b=gC7vVOEkqS8PPcZs7uXowIIxV/rjjiforMamyM0aWHYgqxZ6QAk8iyWT
   uEFJw21l3m02kbt9tTwFqaBzYjVEnT5zf13ATTFmCulnJDbSi9M55RHmd
   +TVKGBWYAxM0nPeMGKJdETNT/xZzhwNEc23yG1kEvJgc/VLOPibq/X9pW
   c=;
X-IronPort-AV: E=Sophos;i="6.09,228,1716249600"; 
   d="scan'208";a="108448111"
Subject: Re: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
Thread-Topic: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 14:26:26 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:28322]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.42.47:2525] with esmtp (Farcaster)
 id 544f6169-c6ef-4194-932d-26e4e6dacd1d; Mon, 22 Jul 2024 14:26:25 +0000 (UTC)
X-Farcaster-Flow-ID: 544f6169-c6ef-4194-932d-26e4e6dacd1d
Received: from EX19D018EUA003.ant.amazon.com (10.252.50.163) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 22 Jul 2024 14:26:25 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA003.ant.amazon.com (10.252.50.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 22 Jul 2024 14:26:25 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.1258.034; Mon, 22 Jul 2024 14:26:25 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Stamatis, Ilias"
	<ilstam@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "nh-open-source@amazon.com" <nh-open-source@amazon.com>, "Durrant, Paul"
	<pdurrant@amazon.co.uk>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>
Thread-Index: AQHa2Un8G7tMctJJKkOA8APVVxEyWrH+15EAgAP8AwA=
Date: Mon, 22 Jul 2024 14:26:25 +0000
Message-ID: <4133f5277315b22fad4bc96b782ba9b431df5102.camel@amazon.co.uk>
References: <20240718193543.624039-4-ilstam@amazon.com>
	 <202407200922.pJAJMVRk-lkp@intel.com>
In-Reply-To: <202407200922.pJAJMVRk-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <683CD94C1E406B4C96249FEA7E658765@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gU2F0LCAyMDI0LTA3LTIwIGF0IDA5OjM1ICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToNCj4gSGkgSWxpYXMsDQo+IA0KPiBrZXJuZWwgdGVzdCByb2JvdCBub3RpY2VkIHRoZSBmb2xs
b3dpbmcgYnVpbGQgd2FybmluZ3M6DQo+IA0KPiBbYXV0byBidWlsZCB0ZXN0IFdBUk5JTkcgb24g
a3ZtL3F1ZXVlXQ0KPiBbYWxzbyBidWlsZCB0ZXN0IFdBUk5JTkcgb24gbmV4dC0yMDI0MDcxOV0N
Cj4gW2Nhbm5vdCBhcHBseSB0byBtc3Qtdmhvc3QvbGludXgtbmV4dCBsaW51cy9tYXN0ZXIga3Zt
L2xpbnV4LW5leHQgdjYuMTBdDQo+IFtJZiB5b3VyIHBhdGNoIGlzIGFwcGxpZWQgdG8gdGhlIHdy
b25nIGdpdCB0cmVlLCBraW5kbHkgZHJvcCB1cyBhIG5vdGUuDQo+IEFuZCB3aGVuIHN1Ym1pdHRp
bmcgcGF0Y2gsIHdlIHN1Z2dlc3QgdG8gdXNlICctLWJhc2UnIGFzIGRvY3VtZW50ZWQgaW4NCj4g
aHR0cHM6Ly9naXQtc2NtLmNvbS9kb2NzL2dpdC1mb3JtYXQtcGF0Y2gjX2Jhc2VfdHJlZV9pbmZv
cm1hdGlvbl0NCj4gDQo+IHVybDogICAgaHR0cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3Av
bGludXgvY29tbWl0cy9JbGlhcy1TdGFtYXRpcy9LVk0tRml4LWNvYWxlc2NlZF9tbWlvX2hhc19y
b29tLzIwMjQwNzE5LTAzNDMxNg0KPiBiYXNlOiAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS92aXJ0L2t2bS9rdm0uZ2l0IHF1ZXVlDQo+IHBhdGNoIGxpbms6ICAgIGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL3IvMjAyNDA3MTgxOTM1NDMuNjI0MDM5LTQtaWxzdGFtJTQwYW1hem9uLmNv
bQ0KPiBwYXRjaCBzdWJqZWN0OiBbUEFUQ0ggdjIgMy82XSBLVk06IFN1cHBvcnQgcG9sbCgpIG9u
IGNvYWxlc2NlZCBtbWlvIGJ1ZmZlciBmZHMNCj4gY29uZmlnOiB4ODZfNjQtcmFuZGNvbmZpZy0x
MjItMjAyNDA3MTkgKGh0dHBzOi8vZG93bmxvYWQuMDEub3JnLzBkYXktY2kvYXJjaGl2ZS8yMDI0
MDcyMC8yMDI0MDcyMDA5MjIucEpBSk1WUmstbGtwQGludGVsLmNvbS9jb25maWcpDQo+IGNvbXBp
bGVyOiBjbGFuZyB2ZXJzaW9uIDE4LjEuNSAoaHR0cHM6Ly9naXRodWIuY29tL2xsdm0vbGx2bS1w
cm9qZWN0IDYxN2ExNWE5ZWFjOTYwODhhZTVlOTEzNDI0OGQ4MjM2ZTM0YjkxYjEpDQo+IHJlcHJv
ZHVjZSAodGhpcyBpcyBhIFc9MSBidWlsZCk6IChodHRwczovL2Rvd25sb2FkLjAxLm9yZy8wZGF5
LWNpL2FyY2hpdmUvMjAyNDA3MjAvMjAyNDA3MjAwOTIyLnBKQUpNVlJrLWxrcEBpbnRlbC5jb20v
cmVwcm9kdWNlKQ0KPiANCj4gSWYgeW91IGZpeCB0aGUgaXNzdWUgaW4gYSBzZXBhcmF0ZSBwYXRj
aC9jb21taXQgKGkuZS4gbm90IGp1c3QgYSBuZXcgdmVyc2lvbiBvZg0KPiB0aGUgc2FtZSBwYXRj
aC9jb21taXQpLCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWdzDQo+ID4gUmVwb3J0ZWQtYnk6IGtl
cm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiA+IENsb3NlczogaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDI0MDcyMDA5MjIucEpBSk1WUmstbGtwQGludGVs
LmNvbS8NCj4gDQo+IHNwYXJzZSB3YXJuaW5nczogKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KQ0K
PiA+ID4gYXJjaC94ODYva3ZtLy4uLy4uLy4uL3ZpcnQva3ZtL2NvYWxlc2NlZF9tbWlvLmM6MjQx
OjIyOiBzcGFyc2U6IHNwYXJzZTogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVy
ZW50IGJhc2UgdHlwZXMpIEBAICAgICBleHBlY3RlZCByZXN0cmljdGVkIF9fcG9sbF90IFt1c2Vy
dHlwZV0gbWFzayBAQCAgICAgZ290IGludCBAQA0KPiAgICBhcmNoL3g4Ni9rdm0vLi4vLi4vLi4v
dmlydC9rdm0vY29hbGVzY2VkX21taW8uYzoyNDE6MjI6IHNwYXJzZTogICAgIGV4cGVjdGVkIHJl
c3RyaWN0ZWQgX19wb2xsX3QgW3VzZXJ0eXBlXSBtYXNrDQo+ICAgIGFyY2gveDg2L2t2bS8uLi8u
Li8uLi92aXJ0L2t2bS9jb2FsZXNjZWRfbW1pby5jOjI0MToyMjogc3BhcnNlOiAgICAgZ290IGlu
dA0KPiAgICBhcmNoL3g4Ni9rdm0vLi4vLi4vLi4vdmlydC9rdm0vY29hbGVzY2VkX21taW8uYzog
bm90ZTogaW4gaW5jbHVkZWQgZmlsZSAodGhyb3VnaCBpbmNsdWRlL2xpbnV4L21tem9uZS5oLCBp
bmNsdWRlL2xpbnV4L2dmcC5oLCBpbmNsdWRlL2xpbnV4L21tLmgsIC4uLik6DQo+ICAgIGluY2x1
ZGUvbGludXgvcGFnZS1mbGFncy5oOjI0MDo0Njogc3BhcnNlOiBzcGFyc2U6IHNlbGYtY29tcGFy
aXNvbiBhbHdheXMgZXZhbHVhdGVzIHRvIGZhbHNlDQo+ICAgIGluY2x1ZGUvbGludXgvcGFnZS1m
bGFncy5oOjI0MDo0Njogc3BhcnNlOiBzcGFyc2U6IHNlbGYtY29tcGFyaXNvbiBhbHdheXMgZXZh
bHVhdGVzIHRvIGZhbHNlDQo+IA0KPiB2aW0gKzI0MSBhcmNoL3g4Ni9rdm0vLi4vLi4vLi4vdmly
dC9rdm0vY29hbGVzY2VkX21taW8uYw0KPiANCj4gICAgMjMxDQo+ICAgIDIzMiAgc3RhdGljIF9f
cG9sbF90IGNvYWxlc2NlZF9tbWlvX2J1ZmZlcl9wb2xsKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1
Y3QgcG9sbF90YWJsZV9zdHJ1Y3QgKndhaXQpDQo+ICAgIDIzMyAgew0KPiAgICAyMzQgICAgICAg
ICAgc3RydWN0IGt2bV9jb2FsZXNjZWRfbW1pb19idWZmZXJfZGV2ICpkZXYgPSBmaWxlLT5wcml2
YXRlX2RhdGE7DQo+ICAgIDIzNSAgICAgICAgICBfX3BvbGxfdCBtYXNrID0gMDsNCj4gICAgMjM2
DQo+ICAgIDIzNyAgICAgICAgICBwb2xsX3dhaXQoZmlsZSwgJmRldi0+d2FpdF9xdWV1ZSwgd2Fp
dCk7DQo+ICAgIDIzOA0KPiAgICAyMzkgICAgICAgICAgc3Bpbl9sb2NrKCZkZXYtPnJpbmdfbG9j
ayk7DQo+ICAgIDI0MCAgICAgICAgICBpZiAoZGV2LT5yaW5nICYmIChSRUFEX09OQ0UoZGV2LT5y
aW5nLT5maXJzdCkgIT0gUkVBRF9PTkNFKGRldi0+cmluZy0+bGFzdCkpKQ0KPiAgPiAyNDEgICAg
ICAgICAgICAgICAgICBtYXNrID0gUE9MTElOIHwgUE9MTFJETk9STTsNCg0KDQpUaGlzIG11c3Qg
YmUgRVBPTExJTiB8IEVQT0xMUkROT1JNLCBidXQgSSB3aWxsIHdhaXQgZm9yIG1vcmUgZmVlZGJh
Y2sgLw0KcmV2aWV3cyBiZWZvcmUgc2VuZGluZyBhbm90aGVyIHZlcnNpb24uDQoNCg0KSWxpYXMN
Cg==

