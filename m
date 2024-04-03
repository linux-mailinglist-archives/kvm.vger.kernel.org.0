Return-Path: <kvm+bounces-13411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E69889622B
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 03:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F0B528BB70
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 01:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D121C291;
	Wed,  3 Apr 2024 01:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="YgwxdVkS"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418FE1BC20;
	Wed,  3 Apr 2024 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712108505; cv=none; b=p1oDtP+zymGzAMWVMMNujQfgwmdn0stRAAxOgTv2WYY4ZaPBXT0YZvE2lzwUeVdXMAVIXNYkP9wpIHp/4qGJ/d7HKdBKHOso6/+mOlI7XSTCVT2v/oVJjs4E7GxMkEwtIy74e8u3UkkhIgbnnRK6nNrc9woRpaj8kWH+NJFrf8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712108505; c=relaxed/simple;
	bh=9qzDJd4xv/KvBWlAYR/DxWB2jZFnJ/2Xwhpb1j5iYE8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=TFtTTlAlutyKr+7YVOPMMhopjGtDY9o+hsIYTi1tJR9J8s/4Igqd6C0ySUJ62C3ay4M2yk2grqWUCMmMMhqgKuXWffIqajAyo6VRFgLg7nWJUesbIMbZWpWZeadhkatNy4iXE6t1o4KjqKRqci1OrtnhYd2EXXh4R43AvfSChS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=YgwxdVkS reason="signature verification failed"; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=mp202wi81W+h68F3K6cSfB+qwXNEKfRZa04fWpo1DKk=; b=Y
	gwxdVkSuDajkGl1B4EHNLzqS83dUcJJEv8+EpWJXSVVvfjRDUR3nE0zoXyoBjeOf
	weCzWu0fA1LCCvsOt29lLz5PrWj27TsG/lwwdP8GqjhD/CQdJARyiYry1JqSRB9P
	LzakUMlIGmrwfXWg6Iapqczh+ETBJ6ypjzsDms4yZ8=
Received: from w_angrong$163.com ( [123.60.114.34] ) by
 ajax-webmail-wmsvr-40-109 (Coremail) ; Wed, 3 Apr 2024 09:41:20 +0800 (CST)
Date: Wed, 3 Apr 2024 09:41:20 +0800 (CST)
From: tab <w_angrong@163.com>
To: "Jason Wang" <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Cindy Lu" <lulu@redhat.com>
Subject: Re:Re: [PATCH v3] vhost/vdpa: Add MSI translation tables to iommu
 for software-managed MSI
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2024 www.mailtech.cn 163com
In-Reply-To: <CACGkMEvdw4Yf2B1QGed0W7wLhOHU9+Vo_Z3h=4Yr9ReBfvuh=g@mail.gmail.com>
References: <20240320101912.28210-1-w_angrong@163.com>
 <20240321025920-mutt-send-email-mst@kernel.org>
 <CACGkMEuHRf0ZfBiAYxyNHB3pxuzz=QCWt5VyHPLz-+-+LM=+bg@mail.gmail.com>
 <CACGkMEuM9bdvgH7_v6F=HT-x10+0tCzG56iuU05guwqNN1+qKQ@mail.gmail.com>
 <20240329051334-mutt-send-email-mst@kernel.org>
 <CACGkMEvdw4Yf2B1QGed0W7wLhOHU9+Vo_Z3h=4Yr9ReBfvuh=g@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2d5a774d.567.18ea19e282e.Coremail.w_angrong@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:_____wD338_AswxmOKEiAA--.20431W
X-CM-SenderInfo: xzbd0wpurqwqqrwthudrp/xtbBzxK0iGV4If3v6AABsm
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SSZuYnNwO25lZWQmbmJzcDt0byZuYnNwO2Rpc2N1c3MmbmJzcDtpbnRlcm5hbGx5LCZuYnNwO2Fu
ZCZuYnNwO3RoZXJlJm5ic3A7bWF5Jm5ic3A7YmUmbmJzcDtzb21lb25lJm5ic3A7ZWxzZSZuYnNw
O3dpbGwmbmJzcDtkbyZuYnNwO3RoYXQuCuWcqCAyMDI0LTAzLTI5IDE4OjM5OjU077yMIkphc29u
IFdhbmciIDxqYXNvd2FuZ0ByZWRoYXQuY29tPiDlhpnpgZPvvJoKT24gRnJpLCBNYXIgMjksIDIw
MjQgYXQgNToxM+KAr1BNIE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+IHdyb3Rl
Og0KPg0KPiBPbiBGcmksIE1hciAyOSwgMjAyNCBhdCAxMTo1NTo1MEFNICswODAwLCBKYXNvbiBX
YW5nIHdyb3RlOg0KPiA+IE9uIFdlZCwgTWFyIDI3LCAyMDI0IGF0IDU6MDjigK9QTSBKYXNvbiBX
YW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBPbiBUaHUsIE1h
ciAyMSwgMjAyNCBhdCAzOjAw4oCvUE0gTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNv
bT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IE9uIFdlZCwgTWFyIDIwLCAyMDI0IGF0IDA2OjE5
OjEyUE0gKzA4MDAsIFdhbmcgUm9uZyB3cm90ZToNCj4gPiA+ID4gPiBGcm9tOiBSb25nIFdhbmcg
PHdfYW5ncm9uZ0AxNjMuY29tPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT25jZSBlbmFibGUgaW9t
bXUgZG9tYWluIGZvciBvbmUgZGV2aWNlLCB0aGUgTVNJDQo+ID4gPiA+ID4gdHJhbnNsYXRpb24g
dGFibGVzIGhhdmUgdG8gYmUgdGhlcmUgZm9yIHNvZnR3YXJlLW1hbmFnZWQgTVNJLg0KPiA+ID4g
PiA+IE90aGVyd2lzZSwgcGxhdGZvcm0gd2l0aCBzb2Z0d2FyZS1tYW5hZ2VkIE1TSSB3aXRob3V0
IGFuDQo+ID4gPiA+ID4gaXJxIGJ5cGFzcyBmdW5jdGlvbiwgY2FuIG5vdCBnZXQgYSBjb3JyZWN0
IG1lbW9yeSB3cml0ZSBldmVudA0KPiA+ID4gPiA+IGZyb20gcGNpZSwgd2lsbCBub3QgZ2V0IGly
cXMuDQo+ID4gPiA+ID4gVGhlIHNvbHV0aW9uIGlzIHRvIG9idGFpbiB0aGUgTVNJIHBoeSBiYXNl
IGFkZHJlc3MgZnJvbQ0KPiA+ID4gPiA+IGlvbW11IHJlc2VydmVkIHJlZ2lvbiwgYW5kIHNldCBp
dCB0byBpb21tdSBNU0kgY29va2llLA0KPiA+ID4gPiA+IHRoZW4gdHJhbnNsYXRpb24gdGFibGVz
IHdpbGwgYmUgY3JlYXRlZCB3aGlsZSByZXF1ZXN0IGlycS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+
IENoYW5nZSBsb2cNCj4gPiA+ID4gPiAtLS0tLS0tLS0tDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiB2
MS0+djI6DQo+ID4gPiA+ID4gLSBhZGQgcmVzdiBpb3RsYiB0byBhdm9pZCBvdmVybGFwIG1hcHBp
bmcuDQo+ID4gPiA+ID4gdjItPnYzOg0KPiA+ID4gPiA+IC0gdGhlcmUgaXMgbm8gbmVlZCB0byBl
eHBvcnQgdGhlIGlvbW11IHN5bWJvbCBhbnltb3JlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU2ln
bmVkLW9mZi1ieTogUm9uZyBXYW5nIDx3X2FuZ3JvbmdAMTYzLmNvbT4NCj4gPiA+ID4NCj4gPiA+
ID4gVGhlcmUncyBpbiBpbnRlcmVzdCB0byBrZWVwIGV4dGVuZGluZyB2aG9zdCBpb3RsYiAtDQo+
ID4gPiA+IHdlIHNob3VsZCBqdXN0IHN3aXRjaCBvdmVyIHRvIGlvbW11ZmQgd2hpY2ggc3VwcG9y
dHMNCj4gPiA+ID4gdGhpcyBhbHJlYWR5Lg0KPiA+ID4NCj4gPiA+IElPTU1VRkQgaXMgZ29vZCBi
dXQgVkZJTyBzdXBwb3J0cyB0aGlzIGJlZm9yZSBJT01NVUZELiBUaGlzIHBhdGNoDQo+ID4gPiBt
YWtlcyB2RFBBIHJ1biB3aXRob3V0IGEgYmFja3BvcnRpbmcgb2YgZnVsbCBJT01NVUZEIGluIHRo
ZSBwcm9kdWN0aW9uDQo+ID4gPiBlbnZpcm9ubWVudC4gSSB0aGluayBpdCdzIHdvcnRoLg0KPiA+
ID4NCj4gPiA+IElmIHlvdSB3b3JyeSBhYm91dCB0aGUgZXh0ZW5zaW9uLCB3ZSBjYW4ganVzdCB1
c2UgdGhlIHZob3N0IGlvdGxiDQo+ID4gPiBleGlzdGluZyBmYWNpbGl0eSB0byBkbyB0aGlzLg0K
PiA+ID4NCj4gPiA+IFRoYW5rcw0KPiA+DQo+ID4gQnR3LCBXYW5nIFJvbmcsDQo+ID4NCj4gPiBJ
dCBsb29rcyB0aGF0IENpbmR5IGRvZXMgaGF2ZSB0aGUgYmFuZHdpZHRoIGluIHdvcmtpbmcgZm9y
IElPTU1VRkQgc3VwcG9ydC4NCj4NCj4gSSB0aGluayB5b3UgbWVhbiBzaGUgZG9lcyBub3QuDQoN
ClllcywgeW91IGFyZSByaWdodC4NCg0KVGhhbmtzDQoNCj4NCj4gPiBEbyB5b3UgaGF2ZSB0aGUg
d2lsbCB0byBkbyB0aGF0Pw0KPiA+DQo+ID4gVGhhbmtzDQo+DQo=

