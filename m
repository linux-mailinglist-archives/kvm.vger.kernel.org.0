Return-Path: <kvm+bounces-11396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2966876C3E
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 531A3B219BF
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 21:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91145F564;
	Fri,  8 Mar 2024 21:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="qYkZtV83"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFABD5F548
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709931924; cv=none; b=ojLLtMpKvOsbuODEh7hrj4lVTmi30JS9pnzGrHYw/6w44Ulk+joiGSUiGjZCUdTX+2LBm1dsRVS1dqg+e96ZKJx8OnLF9cB8IGxyz0byCPyW9EIg+tiLm9FzkW9scrPyV5GL2n5MR7J8Np0v8csQgP0B30a8sPFctOjYdiAHH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709931924; c=relaxed/simple;
	bh=HRn+4j3s0uvW5ahHq0WE6UyDKv//dbnY5NHz7Jy33W8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qTAze8nQBqW5NYqle4y97w7Q8VJaOUN5ydNnSJHbfGbvlTX/NVE+h2EonGa/AIOMRcm8nNm3fc22TAFh7LjCurFwo/iF7ubaGLSOiN9BILtE/+8/ws0WUGI+kzzd0w2tkKuBefCZSl4Vdotxi88VsYxG8Cy5F2aRr0Pn6In+bUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=qYkZtV83; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1709931922; x=1741467922;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=HRn+4j3s0uvW5ahHq0WE6UyDKv//dbnY5NHz7Jy33W8=;
  b=qYkZtV83Iw8rN5OnbxHbUxpR9J7lJKZGAQU49g0Pr2uI5v10ZaGx6XXc
   ah74ER9z4If3CrVJzBNlraNl1ALfsM/K1Wm0hn2jRin948HWpeFV1li0j
   dOel2ZTFEPzrBnHtbTSgnwbILKZ5d8S8KojNkR2vHBoy1VPfOmqcDteHE
   w=;
X-IronPort-AV: E=Sophos;i="6.07,110,1708387200"; 
   d="scan'208";a="71864338"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 21:05:22 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:33697]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.238:2525] with esmtp (Farcaster)
 id 0d5eeb03-8eea-46eb-993f-a3909d8a0217; Fri, 8 Mar 2024 21:05:21 +0000 (UTC)
X-Farcaster-Flow-ID: 0d5eeb03-8eea-46eb-993f-a3909d8a0217
Received: from EX19D022EUC001.ant.amazon.com (10.252.51.254) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 8 Mar 2024 21:05:21 +0000
Received: from EX19D003UWC002.ant.amazon.com (10.13.138.169) by
 EX19D022EUC001.ant.amazon.com (10.252.51.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 8 Mar 2024 21:05:20 +0000
Received: from EX19D003UWC002.ant.amazon.com ([fe80::ab31:cc39:59f9:18b3]) by
 EX19D003UWC002.ant.amazon.com ([fe80::ab31:cc39:59f9:18b3%3]) with mapi id
 15.02.1258.028; Fri, 8 Mar 2024 21:05:19 +0000
From: "Manwaring, Derek" <derekmn@amazon.com>
To: David Woodhouse <dwmw2@infradead.org>, David Matlack
	<dmatlack@google.com>, Brendan Jackman <jackmanb@google.com>,
	"tabba@google.com" <tabba@google.com>, "qperret@google.com"
	<qperret@google.com>, "jason.cj.chen@intel.com" <jason.cj.chen@intel.com>
CC: "Gowans, James" <jgowans@amazon.com>, "seanjc@google.com"
	<seanjc@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Roy, Patrick" <roypat@amazon.co.uk>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "lstoakes@gmail.com" <lstoakes@gmail.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "mst@redhat.com" <mst@redhat.com>,
	"somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvmarm@lists.cs.columbia.edu"
	<kvmarm@lists.cs.columbia.edu>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
Thread-Topic: Unmapping KVM Guest Memory from Host Kernel
Thread-Index: AQHacZxTeX10YUH0O0SiQBg1zQLaEw==
Date: Fri, 8 Mar 2024 21:05:19 +0000
Message-ID: <335E21FA-7F1E-4540-8A70-01A63D8C72FA@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <105008749F655A45808AA99CDA7541DE@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gMjAyNC0wMy0wOCBhdCAxMDo0Ni0wNzAwLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6DQo+IE9u
IEZyaSwgMjAyNC0wMy0wOCBhdCAwOTozNSAtMDgwMCwgRGF2aWQgTWF0bGFjayB3cm90ZToNCj4g
PiBJIHRoaW5rIHdoYXQgSmFtZXMgaXMgbG9va2luZyBmb3IgKGFuZCB3aGF0IHdlIGFyZSBhbHNv
IGludGVyZXN0ZWQNCj4gPiBpbiksIGlzIF9lbGltaW5hdGluZ18gdGhlIGFiaWxpdHkgdG8gYWNj
ZXNzIGd1ZXN0IG1lbW9yeSBmcm9tIHRoZQ0KPiA+IGRpcmVjdCBtYXAgZW50aXJlbHkuIEFuZCBp
biBnZW5lcmFsLCBlbGltaW5hdGUgdGhlIGFiaWxpdHkgdG8gYWNjZXNzDQo+ID4gZ3Vlc3QgbWVt
b3J5IGluIGFzIG1hbnkgd2F5cyBhcyBwb3NzaWJsZS4NCj4NCj4gV2VsbCwgcEtWTSBkb2VzIHRo
YXQuLi4NCg0KWWVzIHdlJ3ZlIGJlZW4gbG9va2luZyBhdCBwS1ZNIGFuZCBpdCBhY2NvbXBsaXNo
ZXMgYSBsb3Qgb2Ygd2hhdCB3ZSdyZSB0cnlpbmcNCnRvIGRvLiBPdXIgaW5pdGlhbCBpbmNsaW5h
dGlvbiBpcyB0aGF0IHdlIHdhbnQgdG8gc3RpY2sgd2l0aCBWSEUgZm9yIHRoZSBsb3dlcg0Kb3Zl
cmhlYWQuIFdlIGFsc28gd2FudCBmbGV4aWJpbGl0eSBhY3Jvc3Mgc2VydmVyIHBhcnRzLCBzbyB3
ZSB3b3VsZCBuZWVkIHRvDQpnZXQgcEtWTSB3b3JraW5nIG9uIEludGVsICYgQU1EIGlmIHdlIHdl
bnQgdGhpcyByb3V0ZS4NCg0KQ2VydGFpbmx5IHRoZXJlIGFyZSBhZHZhbnRhZ2VzIG9mIHBLVk0g
b24gdGhlIHBlcmYgc2lkZSBsaWtlIHRoZSBpbi1wbGFjZQ0KbWVtb3J5IHNoYXJpbmcgcmF0aGVy
IHRoYW4gY29weWluZyBhcyB3ZWxsIGFzIG9uIHRoZSBzZWN1cml0eSBzaWRlIGJ5IHNpbXBseQ0K
cmVkdWNpbmcgdGhlIFRDQi4gSSdkIGJlIGludGVyZXN0ZWQgdG8gaGVhciBvdGhlcnMnIHRob3Vn
aHRzIG9uIHBLVk0gdnMNCm1lbWZkX3NlY3JldCBvciBnZW5lcmFsIEFTSS4NCg0KRGVyZWsNCg0K

