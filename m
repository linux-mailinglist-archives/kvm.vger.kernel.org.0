Return-Path: <kvm+bounces-18173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 602CD8CFA9F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF1F6B2158B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A92F044C9B;
	Mon, 27 May 2024 07:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Kw17CHn5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403D2E40E;
	Mon, 27 May 2024 07:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796472; cv=none; b=OeVb4xjBTY6Fh3M34QVYxG5V+guwG444RxsA+jIJsKZm1GrvVlbtk8qZr8iYOlyBigCsGCtKitS2UmdqyZPXW1drZKGzrO2twg21MR1kKA+Iu6+PqwecRgbukFHIj0a09zlDXvpv3Ow8X5SAKKgioZVwl6Lf4YxXs79SiKfOhNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796472; c=relaxed/simple;
	bh=vVmQM3KlSacYw9PT5Bt0doyYyXPgw3G8yA9jhQANLaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UQiQN5rKC6Kanq9E2xI41PezcNlhUWNJHvgQ2oz/ImADXQutf2kyniqJP2x+F2JLzHjXHfLr/gFUOfH78WHUR6S4aep1IUp82mJG20lbg1kYa1pWmV1ZEPzHpi5pI+CCuTJzJKTKI5RHEIkBdDc/WlRA9ep2ykbMHSoOhq/ryQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Kw17CHn5; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1716796470; x=1748332470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vVmQM3KlSacYw9PT5Bt0doyYyXPgw3G8yA9jhQANLaM=;
  b=Kw17CHn53UOcKSiO7sHc5SqfWNkJ3nQxBg9yWVbDnALqAdyXLpbf+KKQ
   iS94Qegf2E0+uHSUQn2ujh3iOi3AbbBAH5s3IgkD2lM7BMxhtzNIKH5O/
   BAOIz89dQxgrt/Z5PlSKhUOnBD4/ffBkqjGPwrKNfgdW0oAUdXxw8GIma
   A=;
X-IronPort-AV: E=Sophos;i="6.08,192,1712620800"; 
   d="scan'208";a="346759012"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 07:54:23 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.7.35:52970]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.14.80:2525] with esmtp (Farcaster)
 id d92451b3-065a-4ffb-a212-175080e118f9; Mon, 27 May 2024 07:54:21 +0000 (UTC)
X-Farcaster-Flow-ID: d92451b3-065a-4ffb-a212-175080e118f9
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 27 May 2024 07:54:21 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 27 May
 2024 07:54:19 +0000
Message-ID: <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
Date: Mon, 27 May 2024 09:54:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>, Alexander Graf <agraf@csgraf.de>
CC: Dorjoy Chowdhury <dorjoychy111@gmail.com>,
	<virtualization@lists.linux.dev>, <kvm@vger.kernel.org>,
	<netdev@vger.kernel.org>, <stefanha@redhat.com>
References: <CAFfO_h7xsn7Gsy7tFZU2UKcg_LCHY3M26iTuSyhFG-k-24h6_g@mail.gmail.com>
 <4i525r6irzjgibqqtrs3qzofqfifws2k3fmzotg37pyurs5wkd@js54ugamyyin>
 <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
 <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDI3LjA1LjI0IDA5OjA4LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPiBIZXkgU3RlZmFubywK
Pgo+IE9uIDIzLjA1LjI0IDEwOjQ1LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4+IE9uIFR1
ZSwgTWF5IDIxLCAyMDI0IGF0IDA4OjUwOjIyQU0gR01ULCBBbGV4YW5kZXIgR3JhZiB3cm90ZToK
Pj4+IEhvd2R5LAo+Pj4KPj4+IE9uIDIwLjA1LjI0IDE0OjQ0LCBEb3Jqb3kgQ2hvd2RodXJ5IHdy
b3RlOgo+Pj4+IEhleSBTdGVmYW5vLAo+Pj4+Cj4+Pj4gVGhhbmtzIGZvciB0aGUgcmVwbHkuCj4+
Pj4KPj4+Pgo+Pj4+IE9uIE1vbiwgTWF5IDIwLCAyMDI0LCAyOjU1IFBNIFN0ZWZhbm8gR2FyemFy
ZWxsYSAKPj4+PiA8c2dhcnphcmVAcmVkaGF0LmNvbT4gd3JvdGU6Cj4+Pj4+IEhpIERvcmpveSwK
Pj4+Pj4KPj4+Pj4gT24gU2F0LCBNYXkgMTgsIDIwMjQgYXQgMDQ6MTc6MzhQTSBHTVQsIERvcmpv
eSBDaG93ZGh1cnkgd3JvdGU6Cj4+Pj4+PiBIaSwKPj4+Pj4+Cj4+Pj4+PiBIb3BlIHlvdSBhcmUg
ZG9pbmcgd2VsbC4gSSBhbSB3b3JraW5nIG9uIGFkZGluZyBBV1MgTml0cm8gRW5jbGF2ZVsxXQo+
Pj4+Pj4gZW11bGF0aW9uIHN1cHBvcnQgaW4gUUVNVS4gQWxleGFuZGVyIEdyYWYgaXMgbWVudG9y
aW5nIG1lIG9uIHRoaXMgCj4+Pj4+PiB3b3JrLiBBIHYxCj4+Pj4+PiBwYXRjaCBzZXJpZXMgaGFz
IGFscmVhZHkgYmVlbiBwb3N0ZWQgdG8gdGhlIHFlbXUtZGV2ZWwgbWFpbGluZyAKPj4+Pj4+IGxp
c3RbMl0uCj4+Pj4+Pgo+Pj4+Pj4gQVdTIG5pdHJvIGVuY2xhdmVzIGlzIGFuIEFtYXpvbiBFQzJb
M10gZmVhdHVyZSB0aGF0IGFsbG93cyAKPj4+Pj4+IGNyZWF0aW5nIGlzb2xhdGVkCj4+Pj4+PiBl
eGVjdXRpb24gZW52aXJvbm1lbnRzLCBjYWxsZWQgZW5jbGF2ZXMsIGZyb20gQW1hem9uIEVDMiAK
Pj4+Pj4+IGluc3RhbmNlcywgd2hpY2ggYXJlCj4+Pj4+PiB1c2VkIGZvciBwcm9jZXNzaW5nIGhp
Z2hseSBzZW5zaXRpdmUgZGF0YS4gRW5jbGF2ZXMgaGF2ZSBubyAKPj4+Pj4+IHBlcnNpc3RlbnQg
c3RvcmFnZQo+Pj4+Pj4gYW5kIG5vIGV4dGVybmFsIG5ldHdvcmtpbmcuIFRoZSBlbmNsYXZlIFZN
cyBhcmUgYmFzZWQgb24gCj4+Pj4+PiBGaXJlY3JhY2tlciBtaWNyb3ZtCj4+Pj4+PiBhbmQgaGF2
ZSBhIHZob3N0LXZzb2NrIGRldmljZSBmb3IgY29tbXVuaWNhdGlvbiB3aXRoIHRoZSBwYXJlbnQg
Cj4+Pj4+PiBFQzIgaW5zdGFuY2UKPj4+Pj4+IHRoYXQgc3Bhd25lZCBpdCBhbmQgYSBOaXRybyBT
ZWN1cmUgTW9kdWxlIChOU00pIGRldmljZSBmb3IgCj4+Pj4+PiBjcnlwdG9ncmFwaGljCj4+Pj4+
PiBhdHRlc3RhdGlvbi4gVGhlIHBhcmVudCBpbnN0YW5jZSBWTSBhbHdheXMgaGFzIENJRCAzIHdo
aWxlIHRoZSAKPj4+Pj4+IGVuY2xhdmUgVk0gZ2V0cwo+Pj4+Pj4gYSBkeW5hbWljIENJRC4gVGhl
IGVuY2xhdmUgVk1zIGNhbiBjb21tdW5pY2F0ZSB3aXRoIHRoZSBwYXJlbnQgCj4+Pj4+PiBpbnN0
YW5jZSBvdmVyCj4+Pj4+PiB2YXJpb3VzIHBvcnRzIHRvIENJRCAzLCBmb3IgZXhhbXBsZSwgdGhl
IGluaXQgcHJvY2VzcyBpbnNpZGUgYW4gCj4+Pj4+PiBlbmNsYXZlIHNlbmRzIGEKPj4+Pj4+IGhl
YXJ0YmVhdCB0byBwb3J0IDkwMDAgdXBvbiBib290LCBleHBlY3RpbmcgYSBoZWFydGJlYXQgcmVw
bHksIAo+Pj4+Pj4gbGV0dGluZyB0aGUKPj4+Pj4+IHBhcmVudCBpbnN0YW5jZSBrbm93IHRoYXQg
dGhlIGVuY2xhdmUgVk0gaGFzIHN1Y2Nlc3NmdWxseSBib290ZWQuCj4+Pj4+Pgo+Pj4+Pj4gVGhl
IHBsYW4gaXMgdG8gZXZlbnR1YWxseSBtYWtlIHRoZSBuaXRybyBlbmNsYXZlIGVtdWxhdGlvbiBp
biAKPj4+Pj4+IFFFTVUgc3RhbmRhbG9uZQo+Pj4+Pj4gaS5lLiwgd2l0aG91dCBuZWVkaW5nIHRv
IHJ1biBhbm90aGVyIFZNIHdpdGggQ0lEIDMgd2l0aCBwcm9wZXIgdnNvY2sKPj4+Pj4gSWYgeW91
IGRvbid0IGhhdmUgdG8gbGF1bmNoIGFub3RoZXIgVk0sIG1heWJlIHdlIGNhbiBhdm9pZCAKPj4+
Pj4gdmhvc3QtdnNvY2sKPj4+Pj4gYW5kIGVtdWxhdGUgdmlydGlvLXZzb2NrIGluIHVzZXItc3Bh
Y2UsIGhhdmluZyBjb21wbGV0ZSBjb250cm9sIAo+Pj4+PiBvdmVyIHRoZQo+Pj4+PiBiZWhhdmlv
ci4KPj4+Pj4KPj4+Pj4gU28gd2UgY291bGQgdXNlIHRoaXMgb3Bwb3J0dW5pdHkgdG8gaW1wbGVt
ZW50IHZpcnRpby12c29jayBpbiBRRU1VIAo+Pj4+PiBbNF0KPj4+Pj4gb3IgdXNlIHZob3N0LXVz
ZXItdnNvY2sgWzVdIGFuZCBjdXN0b21pemUgaXQgc29tZWhvdy4KPj4+Pj4gKE5vdGU6IHZob3N0
LXVzZXItdnNvY2sgYWxyZWFkeSBzdXBwb3J0cyBzaWJsaW5nIGNvbW11bmljYXRpb24sIHNvIAo+
Pj4+PiBtYXliZQo+Pj4+PiB3aXRoIGEgZmV3IG1vZGlmaWNhdGlvbnMgaXQgZml0cyB5b3VyIGNh
c2UgcGVyZmVjdGx5KQo+Pj4+Pgo+Pj4+PiBbNF0gaHR0cHM6Ly9naXRsYWIuY29tL3FlbXUtcHJv
amVjdC9xZW11Ly0vaXNzdWVzLzIwOTUKPj4+Pj4gWzVdIAo+Pj4+PiBodHRwczovL2dpdGh1Yi5j
b20vcnVzdC12bW0vdmhvc3QtZGV2aWNlL3RyZWUvbWFpbi92aG9zdC1kZXZpY2UtdnNvY2sKPj4+
Pgo+Pj4+Cj4+Pj4gVGhhbmtzIGZvciBsZXR0aW5nIG1lIGtub3cuIFJpZ2h0IG5vdyBJIGRvbid0
IGhhdmUgYSBjb21wbGV0ZSBwaWN0dXJlCj4+Pj4gYnV0IEkgd2lsbCBsb29rIGludG8gdGhlbS4g
VGhhbmsgeW91Lgo+Pj4+Pgo+Pj4+Pgo+Pj4+Pj4gY29tbXVuaWNhdGlvbiBzdXBwb3J0LiBGb3Ig
dGhpcyB0byB3b3JrLCBvbmUgYXBwcm9hY2ggY291bGQgYmUgdG8gCj4+Pj4+PiB0ZWFjaCB0aGUK
Pj4+Pj4+IHZob3N0IGRyaXZlciBpbiBrZXJuZWwgdG8gZm9yd2FyZCBDSUQgMyBtZXNzYWdlcyB0
byBhbm90aGVyIENJRCBOCj4+Pj4+IFNvIGluIHRoaXMgY2FzZSBib3RoIENJRCAzIGFuZCBOIHdv
dWxkIGJlIGFzc2lnbmVkIHRvIHRoZSBzYW1lIFFFTVUKPj4+Pj4gcHJvY2Vzcz8KPj4+Pgo+Pj4+
Cj4+Pj4gQ0lEIE4gaXMgYXNzaWduZWQgdG8gdGhlIGVuY2xhdmUgVk0uIENJRCAzIHdhcyBzdXBw
b3NlZCB0byBiZSB0aGUKPj4+PiBwYXJlbnQgVk0gdGhhdCBzcGF3bnMgdGhlIGVuY2xhdmUgVk0g
KHRoaXMgaXMgaG93IGl0IGlzIGluIEFXUywgd2hlcmUKPj4+PiBhbiBFQzIgaW5zdGFuY2UgVk0g
c3Bhd25zIHRoZSBlbmNsYXZlIFZNIGZyb20gaW5zaWRlIGl0IGFuZCB0aGF0Cj4+Pj4gcGFyZW50
IEVDMiBpbnN0YW5jZSBhbHdheXMgaGFzIENJRCAzKS4gQnV0IGluIHRoZSBRRU1VIGNhc2UgYXMg
d2UKPj4+PiBkb24ndCB3YW50IGEgcGFyZW50IFZNICh3ZSB3YW50IHRvIHJ1biBlbmNsYXZlIFZN
cyBzdGFuZGFsb25lKSB3ZQo+Pj4+IHdvdWxkIG5lZWQgdG8gZm9yd2FyZCB0aGUgQ0lEIDMgbWVz
c2FnZXMgdG8gaG9zdCBDSUQuIEkgZG9uJ3Qga25vdyBpZgo+Pj4+IGl0IG1lYW5zIENJRCAzIGFu
ZCBDSUQgTiBpcyBhc3NpZ25lZCB0byB0aGUgc2FtZSBRRU1VIHByb2Nlc3MuIFNvcnJ5Lgo+Pj4K
Pj4+Cj4+PiBUaGVyZSBhcmUgMiB1c2UgY2FzZXMgaGVyZToKPj4+Cj4+PiAxKSBFbmNsYXZlIHdh
bnRzIHRvIHRyZWF0IGhvc3QgYXMgcGFyZW50IChkZWZhdWx0KS4gSW4gdGhpcyBzY2VuYXJpbywK
Pj4+IHRoZSAicGFyZW50IGluc3RhbmNlIiB0aGF0IHNob3dzIHVwIGFzIENJRCAzIGluIHRoZSBF
bmNsYXZlIGRvZXNuJ3QKPj4+IHJlYWxseSBleGlzdC4gSW5zdGVhZCwgd2hlbiB0aGUgRW5jbGF2
ZSBhdHRlbXB0cyB0byB0YWxrIHRvIENJRCAzLCBpdAo+Pj4gc2hvdWxkIHJlYWxseSBsYW5kIG9u
IENJRCAwIChoeXBlcnZpc29yKS4gV2hlbiB0aGUgaHlwZXJ2aXNvciB0cmllcyB0bwo+Pj4gY29u
bmVjdCB0byB0aGUgRW5jbGF2ZSBvbiBwb3J0IFgsIGl0IHNob3VsZCBsb29rIGFzIGlmIGl0IG9y
aWdpbmF0ZXMKPj4+IGZyb20gQ0lEIDMsIG5vdCBDSUQgMC4KPj4+Cj4+PiAyKSBNdWx0aXBsZSBw
YXJlbnQgVk1zLiBUaGluayBvZiBhbiBhY3R1YWwgY2xvdWQgaG9zdGluZyBzY2VuYXJpby4KPj4+
IEhlcmUsIHdlIGhhdmUgbXVsdGlwbGUgInBhcmVudCBpbnN0YW5jZXMiLiBFYWNoIG9mIHRoZW0g
dGhpbmtzIGl0J3MKPj4+IENJRCAzLiBFYWNoIGNhbiBzcGF3biBhbiBFbmNsYXZlIHRoYXQgdGFs
a3MgdG8gQ0lEIDMgYW5kIHJlYWNoIHRoZQo+Pj4gcGFyZW50LiBGb3IgdGhpcyBjYXNlLCBJIHRo
aW5rIGltcGxlbWVudGluZyBhbGwgb2YgdmlydGlvLXZzb2NrIGluCj4+PiB1c2VyIHNwYWNlIGlz
IHRoZSBiZXN0IHBhdGggZm9yd2FyZC4gQnV0IGluIHRoZW9yeSwgeW91IGNvdWxkIGFsc28KPj4+
IHN3aXp6bGUgQ0lEcyB0byBtYWtlIHJhbmRvbSAicmVhbCIgQ0lEcyBhcHBlYXIgYXMgQ0lEIDMu
Cj4+Pgo+Pgo+PiBUaGFuayB5b3UgZm9yIGNsYXJpZnlpbmcgdGhlIHVzZSBjYXNlcyEKPj4KPj4g
QWxzbyBmb3IgY2FzZSAxLCB2aG9zdC12c29jayBkb2Vzbid0IHN1cHBvcnQgQ0lEIDAsIHNvIGlu
IG15IG9waW5pb24KPj4gaXQncyBlYXNpZXIgdG8gZ28gaW50byB1c2VyLXNwYWNlIHdpdGggdmhv
c3QtdXNlci12c29jayBvciB0aGUgYnVpbHQtaW4KPj4gZGV2aWNlLgo+Cj4KPiBTb3JyeSwgSSBi
ZWxpZXZlIEkgbWVhbnQgQ0lEIDIuIEVmZmVjdGl2ZWx5IGZvciBjYXNlIDEsIHdoZW4gYSBwcm9j
ZXNzIAo+IG9uIHRoZSBoeXBlcnZpc29yIGxpc3RlbnMgb24gcG9ydCAxMjM0LCBpdCBzaG91bGQg
YmUgdmlzaWJsZSBhcyAzOjEyMzQgCj4gZnJvbSB0aGUgVk0gYW5kIHdoZW4gdGhlIGh5cGVydmlz
b3IgcHJvY2VzcyBjb25uZWN0cyB0byA8Vk0gQ0lEPjoxMjM0LCAKPiBpdCBzaG91bGQgbG9vayBh
cyBpZiB0aGF0IGNvbm5lY3Rpb24gY2FtZSBmcm9tIENJRCAzLgoKCk5vdyB0aGF0IEknbSB0aGlu
a2luZyBhYm91dCBteSBtZXNzYWdlIGFnYWluOiBXaGF0IGlmIHdlIGp1c3QgaW50cm9kdWNlIAph
IHN5c2ZzL3N5c2N0bCBmaWxlIGZvciB2c29jayB0aGF0IGluZGljYXRlcyB0aGUgImhvc3QgQ0lE
IiAoZGVmYXVsdDogCjIpPyBVc2VycyB0aGF0IHdhbnQgdmhvc3QtdnNvY2sgdG8gYmVoYXZlIGFz
IGlmIHRoZSBob3N0IGlzIENJRCAzIGNhbiAKanVzdCB3cml0ZSAzIHRvIGl0LgoKSXQgbWVhbnMg
d2UnZCBuZWVkIHRvIGNoYW5nZSBhbGwgcmVmZXJlbmNlcyB0byBWTUFERFJfQ0lEX0hPU1QgdG8g
Cmluc3RlYWQgcmVmZXIgdG8gYSBnbG9iYWwgdmFyaWFibGUgdGhhdCBpbmRpY2F0ZXMgdGhlIG5l
dyAiaG9zdCBDSUQiLiAKSXQnZCBuZWVkIHNvbWUgbW9yZSBjYXJlZnVsIG1hc3NhZ2luZyB0byBu
b3QgYnJlYWsgbnVtYmVyIG5hbWVzcGFjZSAKYXNzdW1wdGlvbnMgKDw9IENJRF9IT1NUIG5vIGxv
bmdlciB3b3JrcyksIGJ1dCB0aGUgaWRlYSBzaG91bGQgZmx5LgoKVGhhdCB3b3VsZCBnaXZlIHVz
IGFsbCAzIG9wdGlvbnM6CgoxKSBVc2VyIHNldHMgdnNvY2suaG9zdF9jaWQgPSAzIHRvIHNpbXVs
YXRlIHRoYXQgdGhlIGhvc3QgaXMgaW4gcmVhbGl0eSAKYW4gZW5jbGF2ZSBwYXJlbnQKMikgVXNl
ciBzcGF3bnMgVk0gd2l0aCBDSUQgPSAzIHRvIHJ1biBwYXJlbnQgcGF5bG9hZCBpbnNpZGUKMykg
VXNlciBzcGF3bnMgcGFyZW50IGFuZCBlbmNsYXZlIFZNcyB3aXRoIHZob3N0LXZzb2NrLXVzZXIg
d2hpY2ggCmNyZWF0ZXMgaXRzIG93biBDSUQgbmFtZXNwYWNlCgoKU3RlZmFubywgV0RZVD8KCgpB
bGV4CgoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdt
YkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0
aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQg
Q2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERF
IDM2NSA1MzggNTk3Cg==


