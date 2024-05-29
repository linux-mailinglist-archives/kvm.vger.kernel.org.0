Return-Path: <kvm+bounces-18274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CABD28D34C1
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDD141C2361F
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1295817B51C;
	Wed, 29 May 2024 10:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UEs3BvXI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85617B43A;
	Wed, 29 May 2024 10:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716979447; cv=none; b=cMYqqE3nGO3CaCSpXqJA0j8TyaUZGG8lHvLsCvPYsvZJA2lZs8JCi3E1UxaTtR0vtb+j00rKolwlQPlTUj90mUHWTlJiEcy7WC+2pULuUlFlk5lpvakA77JYaljc+CtFhzEvdsUycWYAOnlcHRhVYXDZczk7CLt0EDpYd281eSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716979447; c=relaxed/simple;
	bh=Xe+KvPT0VlpkIFzdkKtgchm88os6xAuCWXQsegL4ACU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jdIn+6gMJSldTbko+U0RhklQRf3b2Z3bLVamxamKh2eUhp0CW/4OcskRcbXTJwyymHff4O8tRhoC8gFQCVUVBJ8k3g/aBacVlvj1bNfJpY1YN5F25TZGDctyeamOkQuFnJ4EBW8YXNkUfQdNfKGRi6sO/skMBenD1K9YqX4zNmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=UEs3BvXI; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1716979446; x=1748515446;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xe+KvPT0VlpkIFzdkKtgchm88os6xAuCWXQsegL4ACU=;
  b=UEs3BvXIYLfuUq2gtT/dMEN5205bebix+cko07/xYRkPQlZD83Eg+Hhg
   lRKfTWpqFl9F3NQzt/7XTMngEzBJ6PWugd/B+iQ2LZRKS0ELd+2ZIqKWW
   guBpfG06Gzn9qfANNFjU8Grdqw3CHfMa8CBjkx3qQPkjZvKDecnodY2Km
   4=;
X-IronPort-AV: E=Sophos;i="6.08,198,1712620800"; 
   d="scan'208";a="208246025"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 10:44:04 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.38.20:44854]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.254:2525] with esmtp (Farcaster)
 id 3377ad01-ef86-4b4c-a352-82fbb1b96b24; Wed, 29 May 2024 10:44:02 +0000 (UTC)
X-Farcaster-Flow-ID: 3377ad01-ef86-4b4c-a352-82fbb1b96b24
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 29 May 2024 10:44:02 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Wed, 29 May
 2024 10:43:59 +0000
Message-ID: <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com>
Date: Wed, 29 May 2024 12:43:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: Alexander Graf <agraf@csgraf.de>, Dorjoy Chowdhury
	<dorjoychy111@gmail.com>, <virtualization@lists.linux.dev>,
	<kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <stefanha@redhat.com>
References: <CAFfO_h7iNYc3jrDvnAxTyaGWMxM9YK29DAGYux9s1ve32tuEBw@mail.gmail.com>
 <3a62a9d1-5864-4f00-bcf0-2c64552ee90c@csgraf.de>
 <6wn6ikteeanqmds2i7ar4wvhgj42pxpo2ejwbzz5t2i5cw3kov@omiadvu6dv6n>
 <5b3b1b08-1dc2-4110-98d4-c3bb5f090437@amazon.com>
 <554ae947-f06e-4b69-b274-47e8a78ae962@amazon.com>
 <14e68dd8-b2fa-496f-8dfc-a883ad8434f5@redhat.com>
 <c5wziphzhyoqb2mwzd2rstpotjqr3zky6hrgysohwsum4wvgi7@qmboatooyddd>
 <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
 <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDI5LjA1LjI0IDEwOjA0LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4KPiBPbiBUdWUs
IE1heSAyOCwgMjAyNCBhdCAwNjozODoyNFBNIEdNVCwgUGFvbG8gQm9uemluaSB3cm90ZToKPj4g
T24gVHVlLCBNYXkgMjgsIDIwMjQgYXQgNTo1M+KAr1BNIFN0ZWZhbm8gR2FyemFyZWxsYSAKPj4g
PHNnYXJ6YXJlQHJlZGhhdC5jb20+IHdyb3RlOgo+Pj4KPj4+IE9uIFR1ZSwgTWF5IDI4LCAyMDI0
IGF0IDA1OjQ5OjMyUE0gR01ULCBQYW9sbyBCb256aW5pIHdyb3RlOgo+Pj4gPk9uIFR1ZSwgTWF5
IDI4LCAyMDI0IGF0IDU6NDHigK9QTSBTdGVmYW5vIEdhcnphcmVsbGEgCj4+PiA8c2dhcnphcmVA
cmVkaGF0LmNvbT4gd3JvdGU6Cj4+PiA+PiA+SSB0aGluayBpdCdzIGVpdGhlciB0aGF0IG9yIGlt
cGxlbWVudGluZyB2aXJ0aW8tdnNvY2sgaW4gdXNlcnNwYWNlCj4+PiA+PiAKPj4+ID4oaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8zMGJhZWI1Ni02NGQyLTRlYTMtOGU1My02YTVj
NTA5OTk5NzlAcmVkaGF0LmNvbS8sCj4+PiA+PiA+c2VhcmNoIGZvciAiVG8gY29ubmVjdCBob3N0
PC0+Z3Vlc3QiKS4KPj4+ID4+Cj4+PiA+PiBGb3IgaW4gdGhpcyBjYXNlIEFGX1ZTT0NLIGNhbid0
IGJlIHVzZWQgaW4gdGhlIGhvc3QsIHJpZ2h0Pwo+Pj4gPj4gU28gaXQncyBzaW1pbGFyIHRvIHZo
b3N0LXVzZXItdnNvY2suCj4+PiA+Cj4+PiA+Tm90IHN1cmUgaWYgSSB1bmRlcnN0YW5kIGJ1dCBp
biB0aGlzIGNhc2UgUUVNVSBrbm93cyB3aGljaCBDSURzIGFyZQo+Pj4gPmZvcndhcmRlZCB0byB0
aGUgaG9zdCAoZWl0aGVyIGxpc3RlbiBvbiB2c29jayBhbmQgY29ubmVjdCB0byB0aGUgaG9zdCwK
Pj4+ID5vciB2aWNlIHZlcnNhKSwgc28gdGhlcmUgaXMgbm8ga2VybmVsIGFuZCBubyBWTUFERFJf
RkxBR19UT19IT1NUCj4+PiA+aW52b2x2ZWQuCj4+Pgo+Pj4gSSBtZWFudCB0aGF0IHRoZSBhcHBs
aWNhdGlvbiBpbiB0aGUgaG9zdCB0aGF0IHdhbnRzIHRvIGNvbm5lY3QgdG8gdGhlCj4+PiBndWVz
dCBjYW5ub3QgdXNlIEFGX1ZTT0NLIGluIHRoZSBob3N0LCBidXQgbXVzdCB1c2UgdGhlIG9uZSB3
aGVyZSBRRU1VCj4+PiBpcyBsaXN0ZW5pbmcgKGUuZy4gQUZfSU5FVCwgQUZfVU5JWCksIHJpZ2h0
Pwo+Pj4KPj4+IEkgdGhpbmsgb25lIG9mIEFsZXgncyByZXF1aXJlbWVudHMgd2FzIHRoYXQgdGhl
IGFwcGxpY2F0aW9uIGluIHRoZSBob3N0Cj4+PiBjb250aW51ZSB0byB1c2UgQUZfVlNPQ0sgYXMg
aW4gdGhlaXIgZW52aXJvbm1lbnQuCj4+Cj4+IENhbiB0aGUgaG9zdCB1c2UgVk1BRERSX0NJRF9M
T0NBTCBmb3IgaG9zdC10by1ob3N0IGNvbW11bmljYXRpb24/Cj4KPiBZZXAhCj4KPj4gSWYKPj4g
c28sIHRoZSBwcm9wb3NlZCAiLW9iamVjdCB2c29jay1mb3J3YXJkIiBzeW50YXggY2FuIGNvbm5l
Y3QgdG8gaXQgYW5kCj4+IGl0IHNob3VsZCB3b3JrIGFzIGxvbmcgYXMgdGhlIGFwcGxpY2F0aW9u
IG9uIHRoZSBob3N0IGRvZXMgbm90IGFzc3VtZQo+PiB0aGF0IGl0IGlzIG9uIENJRCAzLgo+Cj4g
UmlnaHQsIGdvb2QgcG9pbnQhCj4gV2UgY2FuIGFsc28gc3VwcG9ydCBzb21ldGhpbmcgc2ltaWxh
ciBpbiB2aG9zdC11c2VyLXZzb2NrLCB3aGVyZSBpbnN0ZWFkCj4gb2YgdXNpbmcgQUZfVU5JWCBh
bmQgZmlyZWNyYWNrZXIncyBoeWJyaWQgdnNvY2ssIHdlIGNhbiByZWRpcmVjdAo+IGV2ZXJ5dGhp
bmcgdG8gVk1BRERSX0NJRF9MT0NBTC4KPgo+IEFsZXggd2hhdCBkbyB5b3UgdGhpbms/IFRoYXQg
d291bGQgc2ltcGxpZnkgdGhpbmdzIGEgbG90IHRvIGRvLgo+IFRoZSBvbmx5IGRpZmZlcmVuY2Ug
aXMgdGhhdCB0aGUgYXBwbGljYXRpb24gaW4gdGhlIGhvc3QgaGFzIHRvIHRhbGsgdG8KPiBWTUFE
RFJfQ0lEX0xPQ0FMICgxKS4KCgpUaGUgYXBwbGljYXRpb24gaW4gdGhlIGhvc3Qgd291bGQgc2Vl
IGFuIGluY29taW5nIGNvbm5lY3Rpb24gZnJvbSBDSUQgMSAKKHdoaWNoIGlzIHByb2JhYmx5IGZp
bmUpIGFuZCB3b3VsZCBzdGlsbCBiZSBhYmxlIHRvIGVzdGFibGlzaCBvdXRnb2luZyAKY29ubmVj
dGlvbnMgdG8gdGhlIGFjdHVhbCBWTSdzIENJRCBhcyBsb25nIGFzIHRoZSBFbmNsYXZlIGRvZXNu
J3QgY2hlY2sgCmZvciB0aGUgcGVlciBDSUQgKEkgaGF2ZW4ndCBzZWVuIGFueW9uZSBjaGVjayB5
ZXQpLiBTbyB5ZXMsIGluZGVlZCwgdGhpcyAKc2hvdWxkIHdvcmsuCgpUaGUgb25seSBjYXNlIHdo
ZXJlIEkgY2FuIHNlZSBpdCBicmVha2luZyBpcyB3aGVuIHlvdSBydW4gbXVsdGlwbGUgCkVuY2xh
dmUgVk1zIGluIHBhcmFsbGVsLiBJbiB0aGF0IGNhc2UsIGVhY2ggd291bGQgdHJ5IHRvIGxpc3Rl
biB0byBDSUQgMyAKYW5kIHRoZSBzZWNvbmQgdGhhdCBkb2VzIHdvdWxkIGZhaWwuIEJ1dCBpdCdz
IGEgd2VsbCBzb2x2YWJsZSBwcm9ibGVtOiAKV2UgY291bGQgKGluIGFkZGl0aW9uIHRvIHRoZSBz
aW1wbGUgaW4tUUVNVSBjYXNlKSBidWlsZCBhbiBleHRlcm5hbCAKZGFlbW9uIHRoYXQgZG9lcyB0
aGUgcHJveHlpbmcgYW5kIGhlbmNlIG93bnMgQ0lEMy4KClNvIHRoZSBpbW1lZGlhdGUgcGxhbiB3
b3VsZCBiZSB0bzoKCiDCoCAxKSBCdWlsZCBhIG5ldyB2aG9zdC12c29jay1mb3J3YXJkIG9iamVj
dCBtb2RlbCB0aGF0IGNvbm5lY3RzIHRvIAp2aG9zdCBhcyBDSUQgMyBhbmQgdGhlbiBmb3J3YXJk
cyBldmVyeSBwYWNrZXQgZnJvbSBDSUQgMSB0byB0aGUgCkVuY2xhdmUtQ0lEIGFuZCBldmVyeSBw
YWNrZXQgdGhhdCBhcnJpdmVzIG9uIHRvIENJRCAzIHRvIENJRCAyLgogwqAgMikgQ3JlYXRlIGEg
bWFjaGluZSBvcHRpb24gZm9yIC1NIG5pdHJvLWVuY2xhdmUgdGhhdCBhdXRvbWF0aWNhbGx5IApz
cGF3bnMgdGhlIHZob3N0LXZzb2NrLWZvcndhcmQgb2JqZWN0LiAoZGVmYXVsdDogb2ZmKQoKClRo
ZSBhYm92ZSBtYXkgbmVlZCBzb21lIGZpZGRsaW5nIHdpdGggb2JqZWN0IGNyZWF0aW9uIHRpbWVz
IHRvIGVuc3VyZSAKdGhhdCB0aGUgZm9yd2FyZCBvYmplY3QgZ2V0cyBDSUQgMywgbm90IHRoZSBF
bmNsYXZlIGFzIGF1dG8tYXNzaWduZWQgQ0lELgoKClRoYW5rcywKCkFsZXgKCgoKCkFtYXpvbiBX
ZWIgU2VydmljZXMgRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAz
OAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBK
b25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1
bnRlciBIUkIgMjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1OTcK


