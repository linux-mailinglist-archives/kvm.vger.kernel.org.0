Return-Path: <kvm+bounces-31943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9F19CF0B3
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 16:52:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EBEC1F2A469
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 15:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE7E1D8E12;
	Fri, 15 Nov 2024 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="KxoVDOkt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2E81D63EA;
	Fri, 15 Nov 2024 15:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731685763; cv=none; b=eDFtyKVdM/hcPmTUzTk2tyOIz7lxqIdFdpQzAzj2Q9qX2mXQxqPy3p5hIbmYr14z8KX/B/2qy3oQSmafPzw8kk0I7sXfVsjyizPMctdLURUAE8FKRyK3i59sTSo2bP3kKoU7UsTrlltgDmBjkxV/hlBjPejGc/8l4Y6flDsoCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731685763; c=relaxed/simple;
	bh=iYOACs9xMrVgXBW4uhPq/UxYJunN8tuucmBnvwbczaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CU9l5pj0Jx8az9uO00ldpddRCG9/bMlnxAdp8x+RbcMSNPnm43ICYq5BjZD/emJ4EYREg0T5TrNtGJQ9CdjsH2bIOlOjCEbBMirM0U9ud56TCZK3+4Pis5N7LAJYIQdVc5PAk6TL7j7/Z5dp6hwqMSxe8Akd2lhmPRYipDFElPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=KxoVDOkt; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731685762; x=1763221762;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iYOACs9xMrVgXBW4uhPq/UxYJunN8tuucmBnvwbczaY=;
  b=KxoVDOkt/Ros62msaODMBWd8vdZimCliTFEgvVwOvsxTgyPwUn/8l54a
   FG/SvZmIMqGMhpouC76ztbrmW8Yd/AKXsJp6HS/2R3A5E35ycq+yVBuaK
   ppixYuANU9mfrDDROMo2YUlpdfRh7v3SppVdbCroporjqXvC2f7D4xBFj
   Y=;
X-IronPort-AV: E=Sophos;i="6.12,157,1728950400"; 
   d="scan'208";a="352876872"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 15:49:21 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:9895]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.41:2525] with esmtp (Farcaster)
 id 5c780039-7119-452e-a90f-ea79eb363424; Fri, 15 Nov 2024 15:49:19 +0000 (UTC)
X-Farcaster-Flow-ID: 5c780039-7119-452e-a90f-ea79eb363424
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 15 Nov 2024 15:49:19 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Fri, 15 Nov 2024
 15:49:16 +0000
Message-ID: <dca2f6ff-b586-461d-936d-e0b9edbe7642@amazon.com>
Date: Fri, 15 Nov 2024 16:49:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock/virtio: Remove queued_replies pushback logic
To: Stefano Garzarella <sgarzare@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <kvm@vger.kernel.org>, Asias He
	<asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Abeni
	<pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, "Stefan
 Hajnoczi" <stefanha@redhat.com>
References: <20241115103016.86461-1-graf@amazon.com>
 <yjhfe5bsnfpqbnibxl2urrnuowzitxnrbodlihz4y5csig7e7p@drgxxxxgokfo>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <yjhfe5bsnfpqbnibxl2urrnuowzitxnrbodlihz4y5csig7e7p@drgxxxxgokfo>
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

SGkgU3RlZmFubywKCk9uIDE1LjExLjI0IDEyOjU5LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6
Cj4KPiBPbiBGcmksIE5vdiAxNSwgMjAyNCBhdCAxMDozMDoxNkFNICswMDAwLCBBbGV4YW5kZXIg
R3JhZiB3cm90ZToKPj4gRXZlciBzaW5jZSB0aGUgaW50cm9kdWN0aW9uIG9mIHRoZSB2aXJ0aW8g
dnNvY2sgZHJpdmVyLCBpdCBpbmNsdWRlZAo+PiBwdXNoYmFjayBsb2dpYyB0aGF0IGJsb2NrcyBp
dCBmcm9tIHRha2luZyBhbnkgbmV3IFJYIHBhY2tldHMgdW50aWwgdGhlCj4+IFRYIHF1ZXVlIGJh
Y2tsb2cgYmVjb21lcyBzaGFsbG93ZXIgdGhhbiB0aGUgdmlydHF1ZXVlIHNpemUuCj4+Cj4+IFRo
aXMgbG9naWMgd29ya3MgZmluZSB3aGVuIHlvdSBjb25uZWN0IGEgdXNlciBzcGFjZSBhcHBsaWNh
dGlvbiBvbiB0aGUKPj4gaHlwZXJ2aXNvciB3aXRoIGEgdmlydGlvLXZzb2NrIHRhcmdldCwgYmVj
YXVzZSB0aGUgZ3Vlc3Qgd2lsbCBzdG9wCj4+IHJlY2VpdmluZyBkYXRhIHVudGlsIHRoZSBob3N0
IHB1bGxlZCBhbGwgb3V0c3RhbmRpbmcgZGF0YSBmcm9tIHRoZSBWTS4KPgo+IFNvLCB3aHkgbm90
IHNraXBwaW5nIHRoaXMgb25seSB3aGVuIHRhbGtpbmcgd2l0aCBhIHNpYmxpbmcgVk0/CgoKSSBk
b24ndCB0aGluayB0aGVyZSBpcyBhIHdheSB0byBrbm93LCBpcyB0aGVyZT8KCgo+Cj4+Cj4+IFdp
dGggTml0cm8gRW5jbGF2ZXMgaG93ZXZlciwgd2UgY29ubmVjdCAyIFZNcyBkaXJlY3RseSB2aWEg
dnNvY2s6Cj4+Cj4+IMKgUGFyZW50wqDCoMKgwqDCoCBFbmNsYXZlCj4+Cj4+IMKgwqAgUlggLS0t
LS0tLS0gVFgKPj4gwqDCoCBUWCAtLS0tLS0tLSBSWAo+Pgo+PiBUaGlzIG1lYW5zIHdlIG5vdyBo
YXZlIDIgdmlydGlvLXZzb2NrIGJhY2tlbmRzIHRoYXQgYm90aCBoYXZlIHRoZSAKPj4gcHVzaGJh
Y2sKPj4gbG9naWMuIElmIHRoZSBwYXJlbnQncyBUWCBxdWV1ZSBydW5zIGZ1bGwgYXQgdGhlIHNh
bWUgdGltZSBhcyB0aGUKPj4gRW5jbGF2ZSdzLCBib3RoIHZpcnRpby12c29jayBkcml2ZXJzIGZh
bGwgaW50byB0aGUgcHVzaGJhY2sgcGF0aCBhbmQKPj4gbm8gbG9uZ2VyIGFjY2VwdCBSWCB0cmFm
ZmljLiBIb3dldmVyLCB0aGF0IFJYIHRyYWZmaWMgaXMgVFggdHJhZmZpYyBvbgo+PiB0aGUgb3Ro
ZXIgc2lkZSB3aGljaCBibG9ja3MgdGhhdCBkcml2ZXIgZnJvbSBtYWtpbmcgYW55IGZvcndhcmQK
Pj4gcHJvZ3Jlc3MuIFdlJ3JlIG5vdCBpbiBhIGRlYWRsb2NrLgo+Pgo+PiBUbyByZXNvbHZlIHRo
aXMsIGxldCdzIHJlbW92ZSB0aGF0IHB1c2hiYWNrIGxvZ2ljIGFsdG9nZXRoZXIgYW5kIHJlbHkg
b24KPj4gaGlnaGVyIGxldmVscyAobGlrZSBjcmVkaXRzKSB0byBlbnN1cmUgd2UgZG8gbm90IGNv
bnN1bWUgdW5ib3VuZGVkCj4+IG1lbW9yeS4KPgo+IEkgc3Bva2UgcXVpY2tseSB3aXRoIFN0ZWZh
biB3aG8gaGFzIGJlZW4gZm9sbG93aW5nIHRoZSBkZXZlbG9wbWVudCBmcm9tCj4gdGhlIGJlZ2lu
bmluZyBhbmQgYWN0dWFsbHkgcG9pbnRlZCBvdXQgdGhhdCB0aGVyZSBtaWdodCBiZSBwcm9ibGVt
cwo+IHdpdGggdGhlIGNvbnRyb2wgcGFja2V0cywgc2luY2UgY3JlZGl0cyBvbmx5IGNvdmVycyBk
YXRhIHBhY2tldHMsIHNvCj4gaXQgZG9lc24ndCBzZWVtIGxpa2UgYSBnb29kIGlkZWEgcmVtb3Zl
IHRoaXMgbWVjaGFuaXNtIGNvbXBsZXRlbHkuCgoKQ2FuIHlvdSBoZWxwIG1lIHVuZGVyc3RhbmQg
d2hpY2ggc2l0dWF0aW9ucyB0aGUgY3VycmVudCBtZWNoYW5pc20gcmVhbGx5IApoZWxwcyB3aXRo
LCBzbyB3ZSBjYW4gbG9vayBhdCBhbHRlcm5hdGl2ZXM/CgoKPgo+Pgo+PiBGaXhlczogMGVhOWUx
ZDNhOWUzICgiVlNPQ0s6IEludHJvZHVjZSB2aXJ0aW9fdHJhbnNwb3J0LmtvIikKPgo+IEknbSBu
b3Qgc3VyZSB3ZSBzaG91bGQgYWRkIHRoaXMgRml4ZXMgdGFnLCB0aGlzIHNlZW1zIHZlcnkgcmlz
a3kKPiBiYWNrcG9ydGluZyBvbiBzdGFibGUgYnJhbmNoZXMgSU1ITy4KCgpXaGljaCBzaXR1YXRp
b25zIGRvIHlvdSBiZWxpZXZlIGl0IHdpbGwgZ2VudWluZWx5IGJyZWFrIGFueXRoaW5nIGluPyBB
cyAKaXQgc3RhbmRzIHRvZGF5LCBpZiB5b3UgcnVuIHVwc3RyZWFtIHBhcmVudCBhbmQgZW5jbGF2
ZSBhbmQgaGFtbWVyIHRoZW0gCndpdGggdnNvY2sgdHJhZmZpYywgeW91IGdldCBpbnRvIGEgZGVh
ZGxvY2suIEV2ZW4gd2l0aG91dCB0aGUgZmxvdyAKY29udHJvbCwgeW91IHdpbGwgbmV2ZXIgaGl0
IGEgZGVhZGxvY2suIEJ1dCB5b3UgbWF5IGdldCBhIGJyb3duLW91dCBsaWtlIApzaXR1YXRpb24g
d2hpbGUgTGludXggaXMgZmx1c2hpbmcgaXRzIGJ1ZmZlcnMuCgpJZGVhbGx5IHdlIHdhbnQgdG8g
aGF2ZSBhY3R1YWwgZmxvdyBjb250cm9sIHRvIG1pdGlnYXRlIHRoZSBwcm9ibGVtIAphbHRvZ2V0
aGVyLiBCdXQgSSdtIG5vdCBxdWl0ZSBzdXJlIGhvdyBhbmQgd2hlcmUuIEp1c3QgYmxvY2tpbmcg
YWxsIApyZWNlaXZpbmcgdHJhZmZpYyBjYXVzZXMgcHJvYmxlbXMuCgoKPiBJZiB3ZSBjYW5ub3Qg
ZmluZCBhIGJldHRlciBtZWNoYW5pc20gdG8gcmVwbGFjZSB0aGlzIHdpdGggc29tZXRoaW5nCj4g
dGhhdCB3b3JrcyBib3RoIGd1ZXN0IDwtPiBob3N0IGFuZCBndWVzdCA8LT4gZ3Vlc3QsIEkgd291
bGQgcHJlZmVyCj4gdG8gZG8gdGhpcyBqdXN0IGZvciBndWVzdCA8LT4gZ3Vlc3QgY29tbXVuaWNh
dGlvbi4KPiBCZWNhdXNlIHJlbW92aW5nIHRoaXMgY29tcGxldGVseSBzZWVtcyB0b28gcmlza3kg
Zm9yIG1lLCBhdCBsZWFzdAo+IHdpdGhvdXQgYSBwcm9vZiB0aGF0IGNvbnRyb2wgcGFja2V0cyBh
cmUgZmluZS4KCgpTbyB5b3VyIGNvbmNlcm4gaXMgdGhhdCBjb250cm9sIHBhY2tldHMgd291bGQg
bm90IHJlY2VpdmUgcHVzaGJhY2ssIHNvIAp3ZSB3b3VsZCBhbGxvdyB1bmJvdW5kZWQgdHJhZmZp
YyB0byBnZXQgcXVldWVkIHVwPyBDYW4geW91IHN1Z2dlc3QgCm9wdGlvbnMgdG8gaGVscCB3aXRo
IHRoYXQ/CgoKQWxleAoKCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIg
R2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1
bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFt
dHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4K
VXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=


