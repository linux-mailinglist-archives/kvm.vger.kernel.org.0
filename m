Return-Path: <kvm+bounces-39551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26B12A477C9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB9B3B1E9D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1898F226534;
	Thu, 27 Feb 2025 08:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="bGjKnSIO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584092253BB;
	Thu, 27 Feb 2025 08:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740644827; cv=none; b=rvhh5S3sfxyS4CpkXrdD/hmkn3MoqSgOi7HiRxZS/mWGEgemKMahHB0bEpc214O74068obJ+AdrQcIP98SqTs2JCa0wsnXclkjJnhLolLcc0sop7SWkiVBU9YTaHkIpwFehcB9t1FpJ7vdPd8Pp5rAfhyXnsyYue/GC6OAoZthE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740644827; c=relaxed/simple;
	bh=tP9uRHvs555G5VvnDDdHN0idiabXISPpl80F9hoD84U=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=It2gK3t15+D/BZEdQkgeP49cUlq0hvJmCT9Y6pB630f46U+xt+1JOQMnUyRNgPAPnJCsuMtjxQD7xH07vr2eX62zlqfBfAuIf0vsGxW3qU+io0TnT/vYQAOyI4CafizJArqfDAJnoZDVQaYF5ZVJ2xV2vz/HDX++2fUhOSF+CHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=bGjKnSIO; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1740644825; x=1772180825;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=tP9uRHvs555G5VvnDDdHN0idiabXISPpl80F9hoD84U=;
  b=bGjKnSIOdw6yfD3qw0SzKPb7YU4BHKErkGXzlZEIhuFX1DTk0KUZDt+e
   l76LEAYXc8ZziCKtOM59fmSVNLe18cmR1EPl++C6D2Ma2h7IUZauV2a9p
   PlTMd15QkaxE02I/kQxPcxImtuiqpDFyThBsi/CTKB6vJ6obF716L7o2T
   Y=;
X-IronPort-AV: E=Sophos;i="6.13,319,1732579200"; 
   d="scan'208";a="475728317"
Subject: Re: [RFC PATCH 3/3] sched, x86: Make the scheduler guest unhalted aware
Thread-Topic: [RFC PATCH 3/3] sched, x86: Make the scheduler guest unhalted aware
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 08:27:01 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:55064]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.24.106:2525] with esmtp (Farcaster)
 id cc38097c-cce8-4160-b5b8-aa5e715157df; Thu, 27 Feb 2025 08:27:01 +0000 (UTC)
X-Farcaster-Flow-ID: cc38097c-cce8-4160-b5b8-aa5e715157df
Received: from EX19D003EUB003.ant.amazon.com (10.252.51.36) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 27 Feb 2025 08:27:00 +0000
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19D003EUB003.ant.amazon.com (10.252.51.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 27 Feb 2025 08:27:00 +0000
Received: from EX19D003EUB001.ant.amazon.com ([fe80::f153:3fae:905b:eb06]) by
 EX19D003EUB001.ant.amazon.com ([fe80::f153:3fae:905b:eb06%3]) with mapi id
 15.02.1544.014; Thu, 27 Feb 2025 08:27:00 +0000
From: "Sieber, Fernand" <sieberf@amazon.com>
To: "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
CC: "peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>
Thread-Index: AQHbiOoaCizytckQ8k+KkTn+O93XSLNa0OUA
Date: Thu, 27 Feb 2025 08:27:00 +0000
Message-ID: <591b12f8c31264d1b7c7417ed916541196eddd58.camel@amazon.com>
References: <20250218202618.567363-1-sieberf@amazon.com>
	 <20250218202618.567363-4-sieberf@amazon.com>
	 <CAKfTPtDx3vVK1ZgBwicTeP82wL=wGOKdxheuBHCBjzM6mSDPOQ@mail.gmail.com>
In-Reply-To: <CAKfTPtDx3vVK1ZgBwicTeP82wL=wGOKdxheuBHCBjzM6mSDPOQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B4C7BCB3896EF47B7EEB99ED30234E0@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDI1LTAyLTI3IGF0IDA4OjM0ICswMTAwLCBWaW5jZW50IEd1aXR0b3Qgd3JvdGU6
DQo+IE9uIFR1ZSwgMTggRmViIDIwMjUgYXQgMjE6MjcsIEZlcm5hbmQgU2llYmVyIDxzaWViZXJm
QGFtYXpvbi5jb20+DQo+IHdyb3RlOg0KPiA+IA0KPiA+IFdpdGggZ3Vlc3QgaGx0L213YWl0L3Bh
dXNlIHBhc3MgdGhyb3VnaCwgdGhlIHNjaGVkdWxlciBoYXMgbm8NCj4gPiB2aXNpYmlsaXR5IGlu
dG8NCj4gPiByZWFsIHZDUFUgYWN0aXZpdHkgYXMgaXQgc2VlcyB0aGVtIGFsbCAxMDAlIGFjdGl2
ZS4gQXMgc3VjaCwgbG9hZA0KPiA+IGJhbGFuY2luZw0KPiA+IGNhbm5vdCBtYWtlIGluZm9ybWVk
IGRlY2lzaW9ucyBvbiB3aGVyZSBpdCBpcyBwcmVmZXJyYWJsZSB0bw0KPiA+IGNvbGxvY2F0ZQ0K
PiA+IHRhc2tzIHdoZW4gbmVjZXNzYXJ5LiBJLmUgYXMgZmFyIGFzIHRoZSBsb2FkIGJhbGFuY2Vy
IGlzIGNvbmNlcm5lZCwNCj4gPiBhDQo+ID4gaGFsdGVkIHZDUFUgYW5kIGFuIGlkbGUgcG9sbGlu
ZyB2Q1BVIGxvb2sgZXhhY3RseSB0aGUgc2FtZSBzbyBpdA0KPiA+IG1heSBkZWNpZGUNCj4gPiB0
aGF0IGVpdGhlciBzaG91bGQgYmUgcHJlZW1wdGVkIHdoZW4gaW4gcmVhbGl0eSBpdCB3b3VsZCBi
ZQ0KPiA+IHByZWZlcnJhYmxlIHRvDQo+ID4gcHJlZW1wdCB0aGUgaWRsZSBvbmUuDQo+ID4gDQo+
ID4gVGhpcyBjb21taXRzIGVubGlnaHRlbnMgdGhlIHNjaGVkdWxlciB0byByZWFsIGd1ZXN0IGFj
dGl2aXR5IGluDQo+ID4gdGhpcw0KPiA+IHNpdHVhdGlvbi4gTGV2ZXJhZ2luZyBndGltZSB1bmhh
bHRlZCwgaXQgYWRkcyBhIGhvb2sgZm9yIGt2bSB0bw0KPiA+IGNvbW11bmljYXRlDQo+ID4gdG8g
dGhlIHNjaGVkdWxlciB0aGUgZHVyYXRpb24gdGhhdCBhIHZDUFUgc3BlbmRzIGhhbHRlZC4gVGhp
cyBpcw0KPiA+IHRoZW4gdXNlZCBpbg0KPiA+IFBFTFQgYWNjb3VudGluZyB0byBkaXNjb3VudCBp
dCBmcm9tIHJlYWwgYWN0aXZpdHkuIFRoaXMgcmVzdWx0cyBpbg0KPiA+IGJldHRlcg0KPiA+IHBs
YWNlbWVudCBhbmQgb3ZlcmFsbCBzdGVhbCB0aW1lIHJlZHVjdGlvbi4NCj4gDQo+IE5BSywgUEVM
VCBhY2NvdW50IGZvciB0aW1lIHNwZW50IGJ5IHNlIG9uIHRoZSBDUFUuwqANCg0KSSB3YXMgZXNz
ZW50aWFsbHkgYWltaW5nIHRvIGFkanVzdCB0aGlzIGNvbmNlcHQgdG8gIlBFTFQgYWNjb3VudCBm
b3INCnRoZSB0aW1lIHNwZW50IGJ5IHNlICp1bmhhbHRlZCogb24gdGhlIENQVSIuIFdvdWxkIHN1
Y2ggYW4gYWRqdXN0bWVudHMNCm9mIHRoZSBkZWZpbml0aW9uIGNhdXNlIHByb2JsZW1zPw0KDQo+
IElmIHlvdXIgdGhyZWFkL3ZjcHUgZG9lc24ndCBkbyBhbnl0aGluZyBidXQgYnVybiBjeWNsZXMs
IGZpbmQgYW5vdGhlcg0KPiB3YXkgdG8gcmVwb3J0IHRoYXR0byB0aGUgaG9zdA0KDQpUaGUgbWFp
biBhZHZhbnRhZ2Ugb2YgaG9va2luZyBpbnRvIFBFTFQgaXMgdGhhdCBpdCBtZWFucyB0aGF0IGxv
YWQNCmJhbGFuY2luZyB3aWxsIGp1c3Qgd29yayBvdXQgb2YgdGhlIGJveCBhcyBpdCBpbW1lZGlh
dGVseSBhZGp1c3RzIHRoZQ0Kc2NoZWRfZ3JvdXAgdXRpbC9sb2FkL3J1bm5hYmxlIHZhbHVlcy4N
Cg0KSXQgbWF5IGJlIHBvc3NpYmxlIHRvIHNjb3BlIGRvd24gbXkgY2hhbmdlIHRvIGxvYWQgYmFs
YW5jaW5nIHdpdGhvdXQNCnRvdWNoaW5nIFBFTFQgaWYgdGhhdCBpcyBub3QgdmlhYmxlLiBGb3Ig
ZXhhbXBsZSBpbnN0ZWFkIG9mIHVzaW5nIFBFTFQNCndlIGNvdWxkIHBvdGVudGlhbGx5IGFkanVz
dCB0aGUgY2FsY3VsYXRpb24gb2Ygc2dzLT5hdmdfbG9hZCBpbg0KdXBkYXRlX3NnX2xiX3N0YXRz
IGZvciBvdmVybG9hZGVkIGdyb3VwcyB0byBpbmNsdWRlIGEgY29ycmVjdGluZyBmYWN0b3INCmJh
c2VkIG9uIHJlY2VudCBoYWx0ZWQgY3ljbGVzIG9mIHRoZSBDUFUuIFRoZSBjb21wYXJpc29uIG9m
IHR3bw0Kb3ZlcmxvYWRlZCBncm91cHMgd291bGQgdGhlbiBmYXZvciBwdWxsaW5nIHRhc2tzIG9u
IHRoZSBvbmUgdGhhdCBoYXMNCnRoZSBtb3N0IGhhbHRlZCBjeWNsZXMuIFRoaXMgYXBwcm9hY2gg
aXMgbW9yZSBzY29wZWQgZG93biBhcyBpdCBkb2Vzbid0DQpjaGFuZ2UgdGhlIGNsYXNzaWZpY2F0
aW9uIG9mIHNjaGVkdWxpbmcgZ3JvdXBzLCBpbnN0ZWFkIGl0IGp1c3QgY2hhbmdlcw0KaG93IG92
ZXJsb2FkZWQgZ3JvdXBzIGFyZSBjb21wYXJlZC4gSSB3b3VsZCBuZWVkIHRvIHByb3RvdHlwZSB0
byBzZWUgaWYNCml0IHdvcmtzLg0KDQpMZXQgbWUga25vdyBpZiB0aGlzIHdvdWxkIGdvIGluIHRo
ZSByaWdodCBkaXJlY3Rpb24gb3IgaWYgeW91IGhhdmUgYW55DQpvdGhlciBpZGVhcyBvZiBhbHRl
cm5hdGUgb3B0aW9ucz8NCg0KPiBGdXJ0aGVybW9yZSB0aGlzIGJyZWFrcyBhbGwgdGhlIGhpZXJh
cmNoeSBkZXBlbmRlbmN5DQoNCkkgYW0gbm90IHVuZGVyc3RhbmRpbmcgdGhlIG1lYW5pbmcgb2Yg
dGhpcyBjb21tZW50LCBjb3VsZCB5b3UgcGxlYXNlDQpwcm92aWRlIG1vcmUgZGV0YWlscz8NCg0K
PiANCj4gPiANCj4gPiBUaGlzIGluaXRpYWwgaW1wbGVtZW50YXRpb24gYXNzdW1lcyB0aGF0IG5v
bi1pZGxlIENQVXMgYXJlIHRpY2tpbmcNCj4gPiBhcyBpdA0KPiA+IGhvb2tzIHRoZSB1bmhhbHRl
ZCB0aW1lIHRoZSBQRUxUIGRlY2F5aW5nIGxvYWQgYWNjb3VudGluZy4gQXMgc3VjaA0KPiA+IGl0
DQo+ID4gZG9lc24ndCB3b3JrIHdlbGwgaWYgUEVMVCBpcyB1cGRhdGVkIGluZnJlcXVlbmx5IHdp
dGggbGFyZ2UgY2h1bmtzDQo+ID4gb2YNCj4gPiBoYWx0ZWQgdGltZS4gVGhpcyBpcyBub3QgYSBm
dW5kYW1lbnRhbCBsaW1pdGF0aW9uIGJ1dCBtb3JlIGNvbXBsZXgNCj4gPiBhY2NvdW50aW5nIGlz
IG5lZWRlZCB0byBnZW5lcmFsaXplIHRoZSB1c2UgY2FzZSB0byBub2h6IGZ1bGwuDQoKCgpBbWF6
b24gRGV2ZWxvcG1lbnQgQ2VudHJlIChTb3V0aCBBZnJpY2EpIChQcm9wcmlldGFyeSkgTGltaXRl
ZAoyOSBHb2dvc29hIFN0cmVldCwgT2JzZXJ2YXRvcnksIENhcGUgVG93biwgV2VzdGVybiBDYXBl
LCA3OTI1LCBTb3V0aCBBZnJpY2EKUmVnaXN0cmF0aW9uIE51bWJlcjogMjAwNCAvIDAzNDQ2MyAv
IDA3Cg==


