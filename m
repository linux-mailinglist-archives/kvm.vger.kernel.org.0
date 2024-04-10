Return-Path: <kvm+bounces-14111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1518289EF9B
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 468581C22323
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91175158A03;
	Wed, 10 Apr 2024 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="KHQKN4Kz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E3713D606;
	Wed, 10 Apr 2024 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712743716; cv=none; b=E0LfA37/dVZQDwZetCGqEKRrME5/NDU5j680sUE2+yvSaRj3mC3bTRt4ik5P9LdHVsb304wE1TYv7nr4FALA7G4O09WA1oG1PR35yEKIHWjOUF7aMjEpVRn4JXK99ddmwDskRqPBl94hVWxP9rq1D0m1Q9p/U1H5fXytaodG7lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712743716; c=relaxed/simple;
	bh=MdY7f2CS0oM/qBYQJmxuEHZIKPaN2+Nt/Mnryzj2vZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version; b=XCG6QReq4RPXoYuG4BltFTtJ9j+vmWoN6wUEtYpsDPrhiZgg8v5X5cvY0MvBdnLNY37E10amDoJHDWTa+Iry69O51rEjq7Cqs9PhLRt9+OPzVuujdCc3YGLsehJaJNCZApePFq7iWJP7eG498hdmE0avMgKFXSIQJFpoXN6YV04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=KHQKN4Kz; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1712743716; x=1744279716;
  h=from:to:cc:subject:date:message-id:in-reply-to:reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=MdY7f2CS0oM/qBYQJmxuEHZIKPaN2+Nt/Mnryzj2vZA=;
  b=KHQKN4KzGVkTQ337aI3NcXRDiHIwaZ9uBYOxfkBdil2bjKKQbazuCC72
   L2yGQtT0QcXwtNYTHj65+Lc88Oim6I8rEj0dsX1JBozN47rhrxQWQdhL+
   4FFWG+Zv4N2VZm7bDD7cW+I5/GBskGhacgFfjvbaZ0m1+VZGnqz99yN26
   w=;
X-IronPort-AV: E=Sophos;i="6.07,190,1708387200"; 
   d="scan'208";a="650956112"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 10:08:32 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:19744]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.56:2525] with esmtp (Farcaster)
 id 1ca4204a-bdae-4bb4-b0a5-44dc75469cb8; Wed, 10 Apr 2024 10:08:30 +0000 (UTC)
X-Farcaster-Flow-ID: 1ca4204a-bdae-4bb4-b0a5-44dc75469cb8
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 10:08:30 +0000
Received: from EX19D033EUC004.ant.amazon.com (10.252.61.133) by
 EX19D033EUC004.ant.amazon.com (10.252.61.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 10:08:29 +0000
Received: from EX19D033EUC004.ant.amazon.com ([fe80::8359:4d84:fb19:f6e9]) by
 EX19D033EUC004.ant.amazon.com ([fe80::8359:4d84:fb19:f6e9%3]) with mapi id
 15.02.1258.028; Wed, 10 Apr 2024 10:08:29 +0000
From: "Allister, Jack" <jalliste@amazon.co.uk>
To: "dongli.zhang@oracle.com" <dongli.zhang@oracle.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, "corbet@lwn.net"
	<corbet@lwn.net>, "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Allister,
 Jack" <jalliste@amazon.co.uk>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"paul@xen.org" <paul@xen.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for KVM clock
 drift fixup
Thread-Topic: [PATCH 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for KVM clock
 drift fixup
Thread-Index: AQHaiy8JAO8/ipIGdEOLJ/xYGG5T6A==
Date: Wed, 10 Apr 2024 10:08:29 +0000
Message-ID: <586c04a6672bf15d4bc82d64d96aed6417b6e874.camel@amazon.co.uk>
In-Reply-To: <1195c194-a2cc-6793-009c-376f091be7f0@oracle.com>
Reply-To: "1195c194-a2cc-6793-009c-376f091be7f0@oracle.com"
	<1195c194-a2cc-6793-009c-376f091be7f0@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4FC65780C6CC94AA93C826E162C2506@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

PiBXb3VsZCB0aGUgYWJvdmUgcmVseSBub3Qgb25seSBvbiBUU0MgY2xvY2tzb3VyY2UsIGJ1dCBh
bHNvDQo+IGthLT51c2VfbWFzdGVyX2Nsb2NrPT10cnVlPw0KDQpZZXMgdGhpcyBzaG91bGQgb25s
eSBiZSBpbiB0aGUgY2FzZSBvZiBtYXN0ZXIgY2xvY2suIEV4dHJhIHZlcmlmaWNhdGlvbg0KdG8g
Y2hlY2sgdGhpcyBmb3IgYm90aCBHRVQvU0VUIHNob3VsZCBiZSBwcmVzZW50Lg0KDQo+IFdoYXQg
d2lsbCBoYXBwZW4gaWYgdGhlIHZDUFU9MCAoZS5nLiwgQlNQKSB0aHJlYWQgaXMgcmFjaW5nIHdp
dGggaGVyZQ0KPiB0byB1cGRhdGUgdGhlIHZjcHUtPmFyY2guaHZfY2xvY2s/DQoNCj4gSW4gYWRk
aXRpb24gdG8gbGl2ZSBtaWdyYXRpb24sIGNhbiB0aGUgdXNlciBjYWxsIHRoaXMgQVBJIGFueSB0
aW1lDQo+IGR1cmluZyB0aGUgVk0gaXMgcnVubmluZyAodG8gZml4IHRoZSBjbG9jayBkcmlmdCk/
IFRoZXJlZm9yZSwgYW55DQo+IHJlcXVpcmVtZW50IHRvIHByb3RlY3QgdGhlIHVwZGF0ZSBvZiBr
dm1jbG9ja19vZmZzZXQgZnJvbSByYWNpbmc/DQoNClRoaXMgc2hvdWxkIG9jY3VyIHdoZW4gbm9u
ZSBvZiB0aGUgdkNQVXMgYXJlIHJ1bm5pbmcsIGluIHRoZSBjb250ZXh0IG9mDQphIGxpdmUtbWln
cmF0aW9uL3VwZGF0ZSB0aGlzIHdvdWxkIGJlIGFmdGVyIGRlc2VyaWFsaXphdGlvbiBiZWZvcmUg
dGhlDQpyZXN1bWUuIEkgbWF5IGhhdmUgYmVlbiB1bmludGVudGlvbmFsbHkgbWlzbGVhZGluZyBo
ZXJlIGRlc2NyaWJpbmcgc29tZQ0Kb2YgdGhlIHByb2JsZW0gc3BhY2UuIFRoZXJlIGlzbid0IGEg
ImRyaWZ0IiBwZXIgc2F5IHdoZW4gYSBWTSBpcw0KcnVubmluZyBhbmQgdGhlIFBWVEkgc3RheXMg
Y29uc3RhbnQuIEl0J3MgbW9yZSB0aGUgcmVsYXRpb25zaGlwIGJldHdlZW4NCnRoZSBUU0MgJiBQ
ViBjbG9jayBjaGFuZ2VzIGR1ZSB0byBpbmFjY3VyYWN5IHdoZW4gS1ZNIGRlY2lkZXMgdG8NCmdl
bmVyYXRlIHRoYXQgaW5mb3JtYXRpb24sIGUuZyBvbiBhIGxpdmUtdXBkYXRlL21pZ3JhdGlvbiBL
Vk0gd2lsbA0KcGVyZm9ybSB0aGUgdXBkYXRlLiBUaGUgS1ZNX1JFUV9NQVNURVJDTE9DS19VUERB
VEUgaXMganVzdCBhbiBleGFtcGxlDQphcyB0byBob3cgdG8gc2ltdWxhdGUvdHJpZ2dlciB0aGlz
Lg0KDQpJJ3ZlIHBvc3RlZCBhIFYyIHdoaWNoIGhvcGVmdWxseSBhZGRyZXNzZXMgc29tZSBvZiBh
Ym92ZSBhbmQgbWFrZXMgaXQNCmNsZWFyZXIgb3ZlcmFsbCB0aGUgYWltIGJlaGluZCB0aGUgcGF0
Y2hlcy4NCg==

