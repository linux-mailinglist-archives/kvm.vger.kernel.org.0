Return-Path: <kvm+bounces-52655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B086BB07BCE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 19:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A71B01AA502B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 17:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88722F5C2E;
	Wed, 16 Jul 2025 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="OAHyp/E6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158EF17ADF8
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 17:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685923; cv=none; b=DaxwXLwA6Ro+ZLSqblJwKdjHMFDIPmvC9jBXBVRnjmt1+B6+TkVUUIHOPjKciybcIBu47c8AatMQXkCTInvzQb0T0fxQ8YFmcjRlNVEgm15fhUeHqehbvdcZoNjEopmeBxEC5tAH7LaRZHZm4t+3eH0F2mSZ8do2Yrg5aLYyHSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685923; c=relaxed/simple;
	bh=l/nemJ4sgngnNXz5xHvyPBYXJczxoOk9SGrbKk1fbqs=;
	h=From:To:Subject:CC:Date:Message-ID:MIME-Version:Content-Type; b=WVfoJAckF0k7WEVACcZg4PtZwTomTtXrm4E9I6xhmVDOOWOkY2YrrAEVO+w6ZFNu3KW1m0Jn8UdgceySbiR0dGopOwAbWCj/4mhEIT9lT2vZzt1D8vdMQZ2YMhdZ8vGoJtHLYrQVSX8wYy8kRmsWcIPoidbv4MTDzQMaRqYBsSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=OAHyp/E6; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1752685919; x=1784221919;
  h=from:to:subject:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l/nemJ4sgngnNXz5xHvyPBYXJczxoOk9SGrbKk1fbqs=;
  b=OAHyp/E6TWK581jsQR9EWyAPa8phpVDK4+UowN57PhqY8kjp4Sl4Y5bm
   CtRRbm+763eQ0eXtS/HgCfPXbqI0CqQ5TNKjczhjR3WYH4JP/sSkPDbtg
   tXXyBZUqSuCBFKxJezDL1tVJrIrv1lEJou8qca/hUGZALwtExeUgRySMc
   GDCvl7CRwWkM8zG91KqfMxIgFlhY1ljlxHarGs6VhcM7qxbogJiQ5I4S0
   7Y/wldysCGGWXQ5/BaNMWHjs5uP2k0/QsqxeIquhHNxFS1p+FwKsrqhLc
   WDSZUIDd0ID3v/rZLCxqdYdRtNBTznSMgktGW3DrjvBK31boA18qR8vHW
   g==;
X-IronPort-AV: E=Sophos;i="6.16,316,1744070400"; 
   d="scan'208";a="423949776"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 17:11:57 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:23882]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.15.222:2525] with esmtp (Farcaster)
 id 2aad4cec-6dfd-47f5-8c0a-fb3af5b9b4dd; Wed, 16 Jul 2025 17:11:56 +0000 (UTC)
X-Farcaster-Flow-ID: 2aad4cec-6dfd-47f5-8c0a-fb3af5b9b4dd
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 16 Jul 2025 17:11:55 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 16 Jul 2025
 17:11:53 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
Subject: Revisiting WC mmap Support for VFIO PCI
CC: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson
	<alex.williamson@redhat.com>, Praveen Kumar <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Date: Wed, 16 Jul 2025 19:11:50 +0200
Message-ID: <lrkyq4ivccb6x.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Transfer-Encoding: base64

CkhpIGFsbCwKCknigJlkIGxpa2UgdG8gcmV2aXNpdCB0aGUgdG9waWMgb2YgYWRkaW5nIFdyaXRl
IENvbWJpbmluZyAoV0MpIG1tYXAKc3VwcG9ydCBmb3IgVkZJTyBQQ0kuIFdlIChBbWF6b24gTGlu
dXgpIGFyZSBjdXJyZW50bHkgd29ya2luZyBvbgphbGxvd2luZyB0aGlzIGZlYXR1cmUsIGFuZCBJ
IHdhbnRlZCB0byBzaGFyZSB0aGUgY3VycmVudCBhcHByb2FjaCBhbmQKZ2F0aGVyIGZlZWRiYWNr
IGZyb20gdGhlIGNvbW11bml0eS4KCkZyb20gZWFybGllciBkaXNjdXNzaW9ucyBhbmQgUkZDcywg
dGhlcmUgYXJlIHNldmVyYWwgY29uc2lkZXJhdGlvbnMgdGhhdApuZWVkIHRvIGJlIGFkZHJlc3Nl
ZCBmb3IgYSBjbGVhbiBpbXBsZW1lbnRhdGlvbiwgd2hpY2ggaW5jbHVkZXM6CgotIFJlY2Vpdmlu
ZyBtbWFwIGZsYWdzIGZyb20gdXNlcnNwYWNlIHdoaWNoIHdhcyBwcmV2aW91c2x5IGV4cGxvcmVk
WzBdLAogIGFuZCBwcm9wb3NlZCBhcHByb2FjaCBpcyB0byBleHBvc2UgYW4gaW9jdGwgdUFQSSB0
byBhbGxvdyB1c2Vyc3BhY2UgdG8KICBzZXQgZmxhZ3MgZm9yIGEgcmFuZ2UuIFRoZXJlIHdhcyBh
bHNvIGRpc2N1c3Npb24gYXJvdW5kCiAgZGlmZmVyZW50aWF0aW5nIFdDIGZyb20gcHJlZmV0Y2hh
YmxlIG1lbW9yeSDigJQgd2hpY2ggbWFrZXMgc2Vuc2Ug4oCUIGFuZAogIGxldHRpbmcgdXNlcnNw
YWNlIGV4cGxpY2l0bHkgY2hvb3NlIHdoaWNoIHJlZ2lvbiB0byB1c2UgV0MuCiAgCi0gRGVhbGlu
ZyB3aXRoIGxlZ2FjeSByZWdpb25zICYgZHJpdmVycyBjcmVhdGVkIHJlZ2lvbnMsIHRoaXMgY291
bGQgYmUKICBoYW5kbGVkIGFzIHN1Z2dlc3RlZFsxXSBmcm9tIEphc29uIHVzaW5nIG1hcGxlIHRy
ZWUsIHdoaWNoIEknbQogIGltcGxlbWVudGluZyB0byBpbnNlcnQgZmxhZ3MgZW50cnkgb2YgdGhl
IHJhbmdlIHRvIGJlIG1tYXBwZWQsIHNpbmNlCiAgdGhpcyB3b3VsZCBnaXZlIHVzIHRoZSBmbGV4
aWJpbGl0eSB0byBzZXQgdGhlIGZsYWdzIG9mIGFueSByYW5nZXMuCgotIFNjb3BpbmcgdGhlIG1t
YXAgZmxhZ3MgbG9jYWxseSBwZXIgcmVxdWVzdCBpbnN0ZWFkIG9mIGRlZmluaW5nIGl0CiAgZ2xv
YmFsbHkgb24gdmZpb19kZXZpY2UvdmZpb19wY2lfY29yZV9kZXZpY2UuIFRoaXMgYWZhaWN0IGZy
b20gdGhlCiAgY29kZSBjb3VsZCBiZSBoYW5kbGVkIGlmIHZmaW9fZGV2aWNlX2ZpbGUgc3RydWN0
IGlzIHVzZWQgd2l0aCB0aGUKICB2ZmlvX2RldmljZV9vcHMgaW5zdGVhZCBvZiB0aGUgdmZpb19k
ZXZpY2UsIHNwZWNpZmljYWxseSB0aGUgbW1hcCAmCiAgaW9jdGwgc2luY2UgdGhlc2UgdGhlIG9w
cyBvZiBpbnRlcmVzdCBoZXJlLCBzbyB0aGF0IHdlIGNvdWxkIGFjY2VzcyBpdAogIHRoZXJlIGFu
ZCBoYXZlIGEgcGVyIGZkIG1hcGxlIHRyZWUgdG8ga2VlcCB0aGUgZmxhZ3MgaW4uIFRoaXMgd2ls
bAogIGFsc28ga2VlcCB0aGUgbGlmZSB0aW1lIG9mIHRoZSBmbGFncyB0byB0aGUgRkQgbm90IHRv
IHRoZSBkZXZpY2Ugd2hpY2gKICBJIHRoaW5rIGlzIGJldHRlciBpbiB0aGlzIGNhc2UuCgpTaW5j
ZSBJJ20gaW4gdGhlIG1pZGRsZSBvZiBpbnZlc3RpZ2F0aW5nICYgaW1wbGVtZW50aW5nIHRoaXMg
dG9waWMsIEkKd291bGQgbGlrZSB0byBjb2xsZWN0IG9waW5pb25zIG9uIHRoZSBhcHByb2FjaCBz
byBmYXIsIHNwZWNpYWxseSB0aGUKbGFzdCBwb2ludC4gYmV0dGVyIGlkZWFzIG9yIG9iamVjdGlv
bnMgd2l0aCBkZWFsaW5nIHdpdGggbG9jYWwgZmxhZ3MKdXNpbmcgdmZpb19kZXZpY2VfZmlsZSBv
ciBvdGhlciBwb2ludHMgd291bGQgYmUgYXBwcmVjaWF0ZWQuCgpbMF06IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2t2bS8yMDI0MDczMTE1NTM1Mi4zOTczODU3LTEta2J1c2NoQG1ldGEuY29tLwpb
MV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDgwMTE0MTkxNC5HQzMwMzA3NjFA
emllcGUuY2EvCgpSZWdhcmRzLApNTkFkYW0KCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9w
bWVudCBDZW50ZXIgR2VybWFueSBHbWJIClRhbWFyYS1EYW56LVN0ci4gMTMKMTAyNDMgQmVybGlu
Ckdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MK
RWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2
NCBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3Cg==


