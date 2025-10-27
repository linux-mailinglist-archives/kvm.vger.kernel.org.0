Return-Path: <kvm+bounces-61214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44AE0C0FE54
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6374B19A7B6F
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11EE2D8364;
	Mon, 27 Oct 2025 18:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="teBjhj6j"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27AB2D77F1;
	Mon, 27 Oct 2025 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761589212; cv=none; b=euoEKN/kUC2F45QRn8kNACJeiIo8gyN7XpbyGzzMXwLQ3c7er/TqMHYnG7lrFqxsLkAH+DRb6FuXlBs0Ra6lj7Z7jOcYOu+acnpMUHlDZhvgsAIP0n9wU9i+4JVBwtFf8wGcilOm727AI8ehb5gnzZ+7VFlDmW1c8D6SmSwiGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761589212; c=relaxed/simple;
	bh=EwfAQ3UV0VxOljE92RZlWUtlSN/VMFEXd6TUFymRZQA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VsTVr+4cSxTMz6beQa4nopqaLxGOHMueAmDGSlnfe5pu2SrDm8iFTh2HbG9rq4uBxA6PCKhVVqH9EgBd5VE69R3Oa2fvs4kYfXcbbOMMJqfMbhYThgMOU1XQsH/m5QXMyjj3QlKHlFUiBp8WCKoS0C7YJJRDgUNLW7I44lK0NcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=teBjhj6j; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761589210; x=1793125210;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=EwfAQ3UV0VxOljE92RZlWUtlSN/VMFEXd6TUFymRZQA=;
  b=teBjhj6jduaWQ5Nz7o1liktMF7/LxpmqCbZLl8Iql9WMy0WCTU6JReef
   7ZNlyCwHm00SZoEX2R9CAzHpsDo0DSZYhwz6S709qOpdlsH1+mp5TXayL
   b/EAKlXS2/qCDBJTd+UqNHi7eOIZnllO0n06DB4uH/YrFRIZHtjx2W4Q2
   XDqWmgfuViMfYFqjaozN61ABk/qDuuEtkbrO1xgVGu6iIptjx3Mj1nDtD
   K3Ok7qZzVUdsyyQHQZvOSE2jYGjjUG6W1k/bXX+HOK7pttM6LEHvF8LUB
   S1SjC99x8f8OYiRGAcbOs8wCdVGurkbSm2KdxWlkqrFMksqqyCq1SCpM/
   A==;
X-CSE-ConnectionGUID: OqtavYX1S82H1G0ZzniyGA==
X-CSE-MsgGUID: 2ZvgsbarS422dYPMdfzFww==
X-IronPort-AV: E=Sophos;i="6.19,259,1754956800"; 
   d="scan'208";a="4287995"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 18:19:59 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:1706]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.32.243:2525] with esmtp (Farcaster)
 id 78409a69-aad3-4df8-a627-807c8738c31c; Mon, 27 Oct 2025 18:19:59 +0000 (UTC)
X-Farcaster-Flow-ID: 78409a69-aad3-4df8-a627-807c8738c31c
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 27 Oct 2025 18:19:59 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Mon, 27 Oct 2025
 18:19:55 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: David Matlack <dmatlack@google.com>
CC: <kvm@vger.kernel.org>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>,
	Alex Williamson <alex@shazbot.org>
Subject: Re: [RFC PATCH 0/7] vfio: Add alias region uapi for device feature
In-Reply-To: <CALzav=cuhzsTu7pZSae_6EpbJ1KWq7Th3Puk2n=TEbWN6LWh-g@mail.gmail.com>
	(David Matlack's message of "Mon, 27 Oct 2025 09:32:17 -0700")
References: <20250924141018.80202-1-mngyadam@amazon.de>
	<CALzav=cuhzsTu7pZSae_6EpbJ1KWq7Th3Puk2n=TEbWN6LWh-g@mail.gmail.com>
Date: Mon, 27 Oct 2025 19:19:51 +0100
Message-ID: <lrkyqecqoky0o.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: EX19D044UWA004.ant.amazon.com (10.13.139.7) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Transfer-Encoding: base64

RGF2aWQgTWF0bGFjayA8ZG1hdGxhY2tAZ29vZ2xlLmNvbT4gd3JpdGVzOgoKPiBPbiBXZWQsIFNl
cCAyNCwgMjAyNSBhdCA3OjEx4oCvQU0gTWFobW91ZCBBZGFtIDxtbmd5YWRhbUBhbWF6b24uZGU+
IHdyb3RlOgo+Pgo+PiBUaGlzIFJGQyBwcm9wb3NlcyBhIG5ldyB1YXBpIFZGSU8gREVWSUNFX0ZF
QVRVUkUgdG8gY3JlYXRlIHBlci1yZWdpb24KPj4gYWxpYXNlcyB3aXRoIHNlbGVjdGFibGUgYXR0
cmlidXRlcywgaW5pdGlhbGx5IGVuYWJsaW5nIHdyaXRlLWNvbWJpbmUKPj4gKFdDKSB3aGVyZSBz
dXBwb3J0ZWQgYnkgdGhlIHVuZGVybHlpbmcgcmVnaW9uLiBUaGUgZ29hbCBpcyB0byBleHBvc2Ug
YQo+PiBVQVBJIGZvciB1c2Vyc3BhY2UgdG8gcmVxdWVzdCBhbiBhbGlhcyBvZiBhbiBleGlzdGlu
ZyBWRklPIHJlZ2lvbiB3aXRoCj4+IGV4dHJhIGZsYWdzLCB0aGVuIGludGVyYWN0IHdpdGggaXQg
dmlhIGEgc3RhYmxlIGFsaWFzIGluZGV4IHRocm91Z2gKPj4gZXhpc3RpbmcgaW9jdGxzIGFuZCBt
bWFwIHdoZXJlIGFwcGxpY2FibGUuCj4KPiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIGJ1aWxkIHRo
aXMgb24gdG9wIG9mIExlb24ncyBkbWEtYnVmIHNlcmllcyBbMV0/Cj4gTXkgdW5kZXJzdGFuZGlu
ZyBpcyB0aGF0IGRtYS1idWYgY2FuIHN1cHBvcnQgbW1hcCwgc28gV0MgY291bGQganVzdCBiZQo+
IGEgcHJvcGVydHkgYXR0YWNoZWQgdG8gYSBkbWEtYnVmIGZkIGFuZCBwYXNzZWQgYnkgdXNlcnNw
YWNlIHZpYQo+IFZGSU9fREVWSUNFX0ZFQVRVUkVfRE1BX0JVRi4gVGhlbiBWRklPIHdvdWxkbid0
IGhhdmUgdG8gY3JlYXRlIG9yCj4gbWFuYWdlIHJlZ2lvbiBhbGlhc2VzLgo+CgpUaGUgbW90aXZh
dGlvbiBmb3IgdGhpcyBwcm9wb3NhbCBpcyB0aGF0IGl0IHdvdWxkIGludGVncmF0ZSBzZWFtbGVz
c2x5CndpdGggRFBESy4gSSBoYXZlbuKAmXQgeWV0IGludmVzdGlnYXRlZCB0aGUgbmV3IGRtYS1i
dWYgc2VyaWVzIGFzIGEKc29sdXRpb24sIGJ1dCBteSBpbml0aWFsIGltcHJlc3Npb24gaXMgdGhh
dCBpdCBkb2VzbuKAmXQgZml0IHdlbGwgd2l0aApEUERL4oCZcyBleGlzdGluZyBtb2RlbC4KRW5h
Ymxpbmcgd3JpdGUtY29tYmluZSB3aXRoIGRtYS1idWYgd2FzIGFsc28gcHJvcG9zZWQgaGVyZVsx
XSBhbmQgSQphZ3JlZSB0aGF04oCZcyBhIGdlbmVyYWxseSBnb29kIGlkZWEgYW5kIGZpdHMgbmF0
dXJhbGx5IHdpdGggZG1hLWJ1Zi4gSQp0aGluayBpdCB3b3VsZCBiZSB2YWx1YWJsZSB0byBzdXBw
b3J0IFdDIHdpdGggYm90aCByZWdpb24gYWxpYXNpbmcgYW5kCmRtYS1idWYsIEJ1dCBtYXliZSBB
bGV4IGhhdmUgYSBkaWZmZXJlbnQgb3BpbmlvbiBvbiB0aGF0LgoKWzFdOiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vMjAyNTA5MTgyMTQ0MjUuMjY3NzA1Ny0xLWFtYXN0cm9AZmIuY29tLwoK
PiBBcG9sb2dpZXMgaWYgdGhpcyBoYXMgYWxyZWFkeSBiZWVuIGRpc2N1c3NlZCwgSSBkaWQgbm90
IGdvIHRocm91Z2ggYWxsCj4gdGhlIHBhc3QgZGlzY3Vzc2lvbi4KPgo+IFsxXSBodHRwczovL2xv
cmUua2VybmVsLm9yZy9rdm0vNzJlY2FhMTM4NjRjYTM0Njc5N2UzNDJkMjNhNzkyOTU2Mjc4ODE0
OC4xNzYwMzY4MjUwLmdpdC5sZW9uQGtlcm5lbC5vcmcvCgpUaGFua3MsCk1OQWRhbQoKCgpBbWF6
b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKVGFtYXJhLURh
bnotU3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2No
bGFlZ2VyCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhS
QiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=


