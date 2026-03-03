Return-Path: <kvm+bounces-72602-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8E+hDxBOp2nKggAAu9opvQ
	(envelope-from <kvm+bounces-72602-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:09:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A12991F732F
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5AA57316AA10
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75593A453E;
	Tue,  3 Mar 2026 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="IHz/bVEM"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCDB372695;
	Tue,  3 Mar 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772571954; cv=none; b=LZLcNQEVl1STNjyNqW9Y8Yvk9DkI2BMlemRyr39eOKhThHZ8OGaOdNEyLG0Rfq5T2vIrp4xOaxqIc4m3ORKkaKLFoaVvwNUKOYAhgXKxysVgMTPwLa9RYa6vEZ0bDmL89HigJGGiQE4/WefTLjQavva9DMf/3g809zJUt5OlqbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772571954; c=relaxed/simple;
	bh=xSbybZUSlysUSHT/3Zoqg8wWSZ0OyPjl8uxepV0vRFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FJPcld+qFUAiQ+DFy7e4SAbZhRjzM53N/ZZo9+reIo3PWtmQ8dk4GcvdaeJkTZZyiI0Sp15lt4Uiu7nLU/j2d0pD7ZhILACUY5svsU9SybfslpMAF8mHLHVtnuT0GD2xnUQIB6ruwbhGG11a1V8ihbOnQI13mkrcNXWJUi9fNww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=IHz/bVEM; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772571953; x=1804107953;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xSbybZUSlysUSHT/3Zoqg8wWSZ0OyPjl8uxepV0vRFk=;
  b=IHz/bVEMc2ZUTfNVdR8T1z+l69kxMrtd4vR6gLri4lNu9KLP+ApxY25w
   BIUfjRcMpd9VLhGOGrvRfHFV5mrd5QNlvoN65RkXCvIMbY72tcOrNv1vY
   +yy3NPuqMMGMKtXh590+C/AttM4SItOFrwhHh6BzBkEveuiSz+uYZnNvY
   kx4OyGx4uxmlbdN7m6TZoPmyZ7w5f6muLALyn7h1xlpNtT1xIPe2Aquqz
   B6qsL5lVkmGIyjeWhuUwHYuaOzRXD2Px3FTIR5dLXytGxINPCjKZD0LGb
   JUv2sudjduDFMosoRnRWz1zmSHz5abkGO3atIK6b8Dv3FQUMk0VzS3ftI
   A==;
X-CSE-ConnectionGUID: f4/R8bIuT3CV3Iy8xZkJqQ==
X-CSE-MsgGUID: qKzmmgJcQrSyEsgYO9rftA==
X-IronPort-AV: E=Sophos;i="6.21,322,1763424000"; 
   d="scan'208";a="14239868"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 21:05:50 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:7726]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.162:2525] with esmtp (Farcaster)
 id f77dbcf8-6c44-4c35-925d-643b3f86c8e1; Tue, 3 Mar 2026 21:05:50 +0000 (UTC)
X-Farcaster-Flow-ID: f77dbcf8-6c44-4c35-925d-643b3f86c8e1
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 3 Mar 2026 21:05:50 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 3 Mar 2026
 21:05:47 +0000
Message-ID: <737f2d0a-bc82-4510-9804-10146e8d4546@amazon.com>
Date: Tue, 3 Mar 2026 22:05:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: Enable H2G override
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Bryan Tan <bryan-bt.tan@broadcom.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, "Broadcom
 internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason
 Wang <jasowang@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	<nh-open-source@amazon.com>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat> <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <aaW2FgoaXIJEymyR@sgarzare-redhat>
 <27dcad4e-d658-4b6b-93b2-44c64fcbeb11@amazon.com>
 <aaaqLbRNmoRHNTkh@sgarzare-redhat>
 <CAOuBmuaQwxKDJoirwtRwEP=690JcRX3Efk6z=udiOHsGr8u6ag@mail.gmail.com>
 <cc4093e8-31c8-4a14-80f9-034852cf54f7@amazon.com>
 <20260303155040-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20260303155040-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: A12991F732F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.06 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72602-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[graf@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

Ck9uIDAzLjAzLjI2IDIxOjUyLCBNaWNoYWVsIFMuIFRzaXJraW4gd3JvdGU6Cj4gT24gVHVlLCBN
YXIgMDMsIDIwMjYgYXQgMDk6NDc6MjZQTSArMDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+
IE9uIDAzLjAzLjI2IDE1OjE3LCBCcnlhbiBUYW4gd3JvdGU6Cj4+PiBPbiBUdWUsIE1hciAzLCAy
MDI2IGF0IDk6NDnigK9BTSBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6YXJlQHJlZGhhdC5jb20+
IHdyb3RlOgo+Pj4+IE9uIE1vbiwgTWFyIDAyLCAyMDI2IGF0IDA4OjA0OjIyUE0gKzAxMDAsIEFs
ZXhhbmRlciBHcmFmIHdyb3RlOgo+Pj4+PiBPbiAwMi4wMy4yNiAxNzoyNSwgU3RlZmFubyBHYXJ6
YXJlbGxhIHdyb3RlOgo+Pj4+Pj4gT24gTW9uLCBNYXIgMDIsIDIwMjYgYXQgMDQ6NDg6MzNQTSAr
MDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+Pj4+Pj4gT24gMDIuMDMuMjYgMTM6MDYsIFN0
ZWZhbm8gR2FyemFyZWxsYSB3cm90ZToKPj4+Pj4+Pj4gQ0NpbmcgQnJ5YW4sIFZpc2hudSwgYW5k
IEJyb2FkY29tIGxpc3QuCj4+Pj4+Pj4+Cj4+Pj4+Pj4+IE9uIE1vbiwgTWFyIDAyLCAyMDI2IGF0
IDEyOjQ3OjA1UE0gKzAxMDAsIFN0ZWZhbm8gR2FyemFyZWxsYSB3cm90ZToKPj4+Pj4+Pj4+IFBs
ZWFzZSB0YXJnZXQgbmV0LW5leHQgdHJlZSBmb3IgdGhpcyBuZXcgZmVhdHVyZS4KPj4+Pj4+Pj4+
Cj4+Pj4+Pj4+PiBPbiBNb24sIE1hciAwMiwgMjAyNiBhdCAxMDo0MTozOEFNICswMDAwLCBBbGV4
YW5kZXIgR3JhZiB3cm90ZToKPj4+Pj4+Pj4+PiBWc29jayBtYWludGFpbnMgYSBzaW5nbGUgQ0lE
IG51bWJlciBzcGFjZSB3aGljaCBjYW4gYmUgdXNlZCB0bwo+Pj4+Pj4+Pj4+IGNvbW11bmljYXRl
IHRvIHRoZSBob3N0IChHMkgpIG9yIHRvIGEgY2hpbGQtVk0gKEgyRykuIFRoZQo+Pj4+Pj4+Pj4+
IGN1cnJlbnQgbG9naWMKPj4+Pj4+Pj4+PiB0cml2aWFsbHkgYXNzdW1lcyB0aGF0IEcySCBpcyBv
bmx5IHJlbGV2YW50IGZvciBDSUQgPD0gMgo+Pj4+Pj4+Pj4+IGJlY2F1c2UgdGhlc2UKPj4+Pj4+
Pj4+PiB0YXJnZXQgdGhlIGh5cGVydmlzb3IuICBIb3dldmVyLCBpbiBlbnZpcm9ubWVudHMgbGlr
ZSBOaXRybwo+Pj4+Pj4+Pj4+IEVuY2xhdmVzLCBhbgo+Pj4+Pj4+Pj4+IGluc3RhbmNlIHRoYXQg
aG9zdHMgdmhvc3RfdnNvY2sgcG93ZXJlZCBWTXMgbWF5IHN0aWxsIHdhbnQKPj4+Pj4+Pj4+PiB0
byBjb21tdW5pY2F0ZQo+Pj4+Pj4+Pj4+IHRvIEVuY2xhdmVzIHRoYXQgYXJlIHJlYWNoYWJsZSBh
dCBoaWdoZXIgQ0lEcyB0aHJvdWdoCj4+Pj4+Pj4+Pj4gdmlydGlvLXZzb2NrLXBjaS4KPj4+Pj4+
Pj4+Pgo+Pj4+Pj4+Pj4+IFRoYXQgbWVhbnMgdGhhdCBmb3IgQ0lEID4gMiwgd2UgcmVhbGx5IHdh
bnQgYW4gb3ZlcmxheS4gQnkKPj4+Pj4+Pj4+PiBkZWZhdWx0LCBhbGwKPj4+Pj4+Pj4+PiBDSURz
IGFyZSBvd25lZCBieSB0aGUgaHlwZXJ2aXNvci4gQnV0IGlmIHZob3N0IHJlZ2lzdGVycyBhCj4+
Pj4+Pj4+Pj4gQ0lELCBpdCB0YWtlcwo+Pj4+Pj4+Pj4+IHByZWNlZGVuY2UuICBJbXBsZW1lbnQg
dGhhdCBsb2dpYy4gVmhvc3QgYWxyZWFkeSBrbm93cyB3aGljaCBDSURzIGl0Cj4+Pj4+Pj4+Pj4g
c3VwcG9ydHMgYW55d2F5Lgo+Pj4+Pj4+Pj4+Cj4+Pj4+Pj4+Pj4gV2l0aCB0aGlzIGxvZ2ljLCBJ
IGNhbiBydW4gYSBOaXRybyBFbmNsYXZlIGFzIHdlbGwgYXMgYQo+Pj4+Pj4+Pj4+IG5lc3RlZCBW
TSB3aXRoCj4+Pj4+Pj4+Pj4gdmhvc3QtdnNvY2sgc3VwcG9ydCBpbiBwYXJhbGxlbCwgd2l0aCB0
aGUgcGFyZW50IGluc3RhbmNlIGFibGUgdG8KPj4+Pj4+Pj4+PiBjb21tdW5pY2F0ZSB0byBib3Ro
IHNpbXVsdGFuZW91c2x5Lgo+Pj4+Pj4+Pj4gSSBob25lc3RseSBkb24ndCB1bmRlcnN0YW5kIHdo
eSBWTUFERFJfRkxBR19UT19IT1NUIChhZGRlZAo+Pj4+Pj4+Pj4gc3BlY2lmaWNhbGx5IGZvciBO
aXRybyBJSVJDKSBpc24ndCBlbm91Z2ggZm9yIHRoaXMgc2NlbmFyaW8KPj4+Pj4+Pj4+IGFuZCB3
ZSBoYXZlIHRvIGFkZCB0aGlzIGNoYW5nZS4gIENhbiB5b3UgZWxhYm9yYXRlIGEgYml0IG1vcmUK
Pj4+Pj4+Pj4+IGFib3V0IHRoZSByZWxhdGlvbnNoaXAgYmV0d2VlbiB0aGlzIGNoYW5nZSBhbmQK
Pj4+Pj4+Pj4+IFZNQUREUl9GTEFHX1RPX0hPU1Qgd2UgYWRkZWQ/Cj4+Pj4+Pj4gVGhlIG1haW4g
cHJvYmxlbSBJIGhhdmUgd2l0aCBWTUFERFJfRkxBR19UT19IT1NUIGZvciBjb25uZWN0KCkgaXMK
Pj4+Pj4+PiB0aGF0IGl0IHB1bnRzIHRoZSBjb21wbGV4aXR5IHRvIHRoZSB1c2VyLiBJbnN0ZWFk
IG9mIGEgc2luZ2xlIENJRAo+Pj4+Pj4+IGFkZHJlc3Mgc3BhY2UsIHlvdSBub3cgZWZmZWN0aXZl
bHkgY3JlYXRlIDIgc3BhY2VzOiBPbmUgZm9yCj4+Pj4+Pj4gVE9fSE9TVCAobmVlZHMgYSBmbGFn
KSBhbmQgb25lIGZvciBUT19HVUVTVCAobm8gZmxhZykuIEJ1dCBldmVyeQo+Pj4+Pj4+IHVzZXIg
c3BhY2UgdG9vbCBuZWVkcyB0byBsZWFybiBhYm91dCB0aGlzIGZsYWcuIFRoYXQgbWF5IHdvcmsg
Zm9yCj4+Pj4+Pj4gc3VwZXIgc3BlY2lhbC1jYXNlIGFwcGxpY2F0aW9ucy4gQnV0IHByb3BhZ2F0
aW5nIHRoYXQgYWxsIHRoZSB3YXkKPj4+Pj4+PiBpbnRvIHNvY2F0LCBpcGVyZiwgZXRjIGV0Yz8g
SXQncyBqdXN0IGNyZWF0aW5nIGZyaWN0aW9uLgo+Pj4+Pj4gT2theSwgSSB3b3VsZCBsaWtlIHRv
IGhhdmUgdGhpcyAob3IgcGFydCBvZiBpdCkgaW4gdGhlIGNvbW1pdAo+Pj4+Pj4gbWVzc2FnZSB0
byBiZXR0ZXIgZXhwbGFpbiB3aHkgd2Ugd2FudCB0aGlzIGNoYW5nZS4KPj4+Pj4+Cj4+Pj4+Pj4g
SU1ITyB0aGUgbW9zdCBuYXR1cmFsIGV4cGVyaWVuY2UgaXMgdG8gaGF2ZSBhIHNpbmdsZSBDSUQg
c3BhY2UsCj4+Pj4+Pj4gcG90ZW50aWFsbHkgbWFudWFsbHkgc2VnbWVudGVkIGJ5IGxhdW5jaGlu
ZyBWTXMgb2Ygb25lIGtpbmQgd2l0aGluCj4+Pj4+Pj4gYSBjZXJ0YWluIHJhbmdlLgo+Pj4+Pj4g
SSBzZWUsIGJ1dCBhdCB0aGlzIHBvaW50LCBzaG91bGQgdGhlIGtlcm5lbCBzZXQgVk1BRERSX0ZM
QUdfVE9fSE9TVAo+Pj4+Pj4gaW4gdGhlIHJlbW90ZSBhZGRyZXNzIGlmIHRoYXQgcGF0aCBpcyB0
YWtlbiAiYXV0b21hZ2ljYWxseSIgPwo+Pj4+Pj4KPj4+Pj4+IFNvIGluIHRoYXQgd2F5IHRoZSB1
c2VyIHNwYWNlIGNhbiBoYXZlIGEgd2F5IHRvIHVuZGVyc3RhbmQgaWYgaXQncwo+Pj4+Pj4gdGFs
a2luZyB3aXRoIGEgbmVzdGVkIGd1ZXN0IG9yIGEgc2libGluZyBndWVzdC4KPj4+Pj4+Cj4+Pj4+
Pgo+Pj4+Pj4gVGhhdCBzYWlkLCBJJ20gY29uY2VybmVkIGFib3V0IHRoZSBzY2VuYXJpbyB3aGVy
ZSBhbiBhcHBsaWNhdGlvbgo+Pj4+Pj4gZG9lcyBub3QgZXZlbiBjb25zaWRlciBjb21tdW5pY2F0
aW5nIHdpdGggYSBzaWJsaW5nIFZNLgo+Pj4+PiBJZiB0aGF0J3MgcmVhbGx5IGEgcmVhbGlzdGlj
IGNvbmNlcm4sIHRoZW4gd2Ugc2hvdWxkIGFkZCBhCj4+Pj4+IFZNQUREUl9GTEFHX1RPX0dVRVNU
IHRoYXQgdGhlIGFwcGxpY2F0aW9uIGNhbiBzZXQuIERlZmF1bHQgYmVoYXZpb3Igb2YKPj4+Pj4g
YW4gYXBwbGljYXRpb24gdGhhdCBwcm92aWRlcyBubyBmbGFncyBpcyAicm91dGUgdG8gd2hhdGV2
ZXIgeW91IGNhbgo+Pj4+PiBmaW5kIjogSWYgdmhvc3QgaXMgbG9hZGVkLCBpdCByb3V0ZXMgdG8g
dmhvc3QuIElmIGEgdnNvY2sgYmFja2VuZAo+Pj4+IG1tbSwgd2UgaGF2ZSBhbHdheXMgZG9jdW1l
bnRlZCB0aGlzIHNpbXBsZSBiZWhhdmlvcjoKPj4+PiAtIENJRCA9IDIgdGFsa3MgdG8gdGhlIGhv
c3QKPj4+PiAtIENJRCA+PSAzIHRhbGtzIHRvIHRoZSBndWVzdAo+Pj4+Cj4+Pj4gTm93IHdlIGFy
ZSBjaGFuZ2luZyB0aGlzIGJ5IGFkZGluZyBmYWxsYmFjay4gSSBkb24ndCB0aGluayB3ZSBzaG91
bGQKPj4+PiBjaGFuZ2UgdGhlIGRlZmF1bHQgYmVoYXZpb3IsIGJ1dCByYXRoZXIgcHJvdmlkZSBu
ZXcgd2F5cyB0byBlbmFibGUgdGhpcwo+Pj4+IG5ldyBiZWhhdmlvci4KPj4+Pgo+Pj4+IEkgZmlu
ZCBpdCBzdHJhbmdlIHRoYXQgYW4gYXBwbGljYXRpb24gcnVubmluZyBvbiBMaW51eCA3LjAgaGFz
IGEgZGVmYXVsdAo+Pj4+IGJlaGF2aW9yIHdoZXJlIHVzaW5nIENJRD00MiBhbHdheXMgdGFsa3Mg
dG8gYSBuZXN0ZWQgVk0sIGJ1dCBzdGFydGluZwo+Pj4+IHdpdGggTGludXggNy4xLCBpdCBhbHNv
IHN0YXJ0cyB0YWxraW5nIHRvIGEgc2libGluZyBWTS4KPj4+Pgo+Pj4+PiBkcml2ZXIgaXMgbG9h
ZGVkLCBpdCByb3V0ZXMgdGhlcmUuIEJ1dCB0aGUgYXBwbGljYXRpb24gaGFzIG5vIHNheSBpbgo+
Pj4+PiB3aGVyZSBpdCBnb2VzOiBJdCdzIHB1cmVseSBhIHN5c3RlbSBjb25maWd1cmF0aW9uIHRo
aW5nLgo+Pj4+IFRoaXMgaXMgdHJ1ZSBmb3IgY29tcGxleCB0aGluZ3MgbGlrZSBJUCwgYnV0IGZv
ciBWU09DSyB3ZSBoYXZlIGFsd2F5cwo+Pj4+IHdhbnRlZCB0byBrZWVwIHRoZSBkZWZhdWx0IGJl
aGF2aW9yIHZlcnkgc2ltcGxlIChhcyB3cml0dGVuIGFib3ZlKS4KPj4+PiBFdmVyeXRoaW5nIGVs
c2UgbXVzdCBiZSBleHBsaWNpdGx5IGVuYWJsZWQgSU1ITy4KPj4+Pgo+Pj4+Pj4gVW50aWwgbm93
LCBpdCBrbmV3IHRoYXQgYnkgbm90IHNldHRpbmcgdGhhdCBmbGFnLCBpdCBjb3VsZCBvbmx5IHRh
bGsKPj4+Pj4+IHRvIG5lc3RlZCBWTXMsIHNvIGlmIHRoZXJlIHdhcyBubyBWTSB3aXRoIHRoYXQg
Q0lELCB0aGUgY29ubmVjdGlvbgo+Pj4+Pj4gc2ltcGx5IGZhaWxlZC4gV2hlcmVhcyBmcm9tIHRo
aXMgcGF0Y2ggb253YXJkcywgaWYgdGhlIGRldmljZSBpbiB0aGUKPj4+Pj4+IGhvc3Qgc3VwcG9y
dHMgc2libGluZyBWTXMgYW5kIHRoZXJlIGlzIGEgVk0gd2l0aCB0aGF0IENJRCwgdGhlCj4+Pj4+
PiBhcHBsaWNhdGlvbiBmaW5kcyBpdHNlbGYgdGFsa2luZyB0byBhIHNpYmxpbmcgVk0gaW5zdGVh
ZCBvZiBhIG5lc3RlZAo+Pj4+Pj4gb25lLCB3aXRob3V0IGhhdmluZyBhbnkgaWRlYS4KPj4+Pj4g
SSdkIHNheSBhbiBhcHBsaWNhdGlvbiB0aGF0IGF0dGVtcHRzIHRvIHRhbGsgdG8gYSBDSUQgdGhh
dCBpdCBkb2VzIG5vdwo+Pj4+PiBrbm93IHdoZXRoZXIgaXQncyB2aG9zdCByb3V0ZWQgb3Igbm90
IGlzIHJ1bm5pbmcgaW50byAidW5kZWZpbmVkIgo+Pj4+PiB0ZXJyaXRvcnkuIElmIHlvdSBybW1v
ZCB0aGUgdmhvc3QgZHJpdmVyLCBpdCB3b3VsZCBhbHNvIHRhbGsgdG8gdGhlCj4+Pj4+IGh5cGVy
dmlzb3IgcHJvdmlkZWQgdnNvY2suCj4+Pj4gT2gsIEkgbWlzc2VkIHRoYXQuIEFuZCBJIGFsc28g
Zml4ZWQgdGhhdCBiZWhhdmlvdXIgd2l0aCBjb21taXQKPj4+PiA2NWI0MjJkOWI2MWIgKCJ2c29j
azogZm9yd2FyZCBhbGwgcGFja2V0cyB0byB0aGUgaG9zdCB3aGVuIG5vIEgyRyBpcwo+Pj4+IHJl
Z2lzdGVyZWQiKSBhZnRlciBJIGltcGxlbWVudGVkIHRoZSBtdWx0aS10cmFuc3BvcnQgc3VwcG9y
dC4KPj4+Pgo+Pj4+IG1tbSwgdGhpcyBjb3VsZCBjaGFuZ2UgbXkgcG9zaXRpb24gOy0pIChhbHRo
b3VnaCwgdG8gYmUgaG9uZXN0LCBJIGRvbid0Cj4+Pj4gdW5kZXJzdGFuZCB3aHkgaXQgd2FzIGxp
a2UgdGhhdCBpbiB0aGUgZmlyc3QgcGxhY2UsIGJ1dCB0aGF0J3MgaG93IGl0IGlzCj4+Pj4gbm93
KS4KPj4+Pgo+Pj4+IFBsZWFzZSBkb2N1bWVudCBhbHNvIHRoaXMgaW4gdGhlIG5ldyBjb21taXQg
bWVzc2FnZSwgaXMgYSBnb29kIHBvaW50Lgo+Pj4+IEFsdGhvdWdoIHdoZW4gSDJHIGlzIGxvYWRl
ZCwgd2UgYmVoYXZlIGRpZmZlcmVudGx5LiBIb3dldmVyLCBpdCBpcyB0cnVlCj4+Pj4gdGhhdCBz
eXNjdGwgaGVscHMgdXMgc3RhbmRhcmRpemUgdGhpcyBiZWhhdmlvci4KPj4+Pgo+Pj4+IEkgZG9u
J3Qga25vdyB3aGV0aGVyIHRvIHNlZSBpdCBhcyBhIHJlZ3Jlc3Npb24gb3Igbm90Lgo+Pj4+Cj4+
Pj4+PiBTaG91bGQgd2UgbWFrZSB0aGlzIGZlYXR1cmUgb3B0LWluIGluIHNvbWUgd2F5LCBzdWNo
IGFzIHNvY2tvcHQgb3IKPj4+Pj4+IHN5c2N0bD8gKEkgdW5kZXJzdGFuZCB0aGF0IHRoZXJlIGlz
IHRoZSBwcmV2aW91cyBwcm9ibGVtLCBidXQKPj4+Pj4+IGhvbmVzdGx5LCBpdCBzZWVtcyBsaWtl
IGEgc2lnbmlmaWNhbnQgY2hhbmdlIHRvIHRoZSBiZWhhdmlvciBvZgo+Pj4+Pj4gQUZfVlNPQ0sp
Lgo+Pj4+PiBXZSBjYW4gY3JlYXRlIGEgc3lzY3RsIHRvIGVuYWJsZSBiZWhhdmlvciB3aXRoIGRl
ZmF1bHQ9b24uIEJ1dCBJJ20KPj4+Pj4gYWdhaW5zdCBtYWtpbmcgdGhlIGN1bWJlcnNvbWUgZG9l
cy1ub3Qtd29yay1vdXQtb2YtdGhlLWJveCBleHBlcmllbmNlCj4+Pj4+IHRoZSBkZWZhdWx0LiBX
aWxsIGluY2x1ZGUgaXQgaW4gdjIuCj4+Pj4gVGhlIG9wcG9zaXRlIHBvaW50IG9mIHZpZXcgaXMg
dGhhdCB3ZSB3b3VsZCBub3Qgd2FudCB0byBoYXZlIGRpZmZlcmVudAo+Pj4+IGRlZmF1bHQgYmVo
YXZpb3IgYmV0d2VlbiA3LjAgYW5kIDcuMSB3aGVuIEgyRyBpcyBsb2FkZWQuCj4+PiAgIEZyb20g
YSBWTUNJIHBlcnNwZWN0aXZlLCB3ZSBvbmx5IGFsbG93IGNvbW11bmljYXRpb24gZnJvbSBndWVz
dCB0bwo+Pj4gaG9zdCBDSURzIDAgYW5kIDIuIFdpdGggaGFzX3JlbW90ZV9jaWQgaW1wbGVtZW50
ZWQgZm9yIFZNQ0ksIHdlIGVuZAo+Pj4gdXAgYXR0ZW1wdGluZyBndWVzdCB0byBndWVzdCBjb21t
dW5pY2F0aW9uLiBBcyBtZW50aW9uZWQgdGhpcyBkb2VzCj4+PiBhbHJlYWR5IGhhcHBlbiBpZiB0
aGVyZSBpc24ndCBhbiBIMkcgdHJhbnNwb3J0IHJlZ2lzdGVyZWQsIHNvIHdlCj4+PiBzaG91bGQg
YmUgaGFuZGxpbmcgdGhpcyBhbnl3YXlzLiBCdXQgSSdtIG5vdCB0b28gZm9uZCBvZiB0aGUgY2hh
bmdlCj4+PiBpbiBiZWhhdmlvdXIgZm9yIHdoZW4gSDJHIGlzIHByZXNlbnQsIHNvIGluIHRoZSB2
ZXJ5IGxlYXN0IEknZAo+Pj4gcHJlZmVyIGlmIGhhc19yZW1vdGVfY2lkIGlzIG5vdCBpbXBsZW1l
bnRlZCBmb3IgVk1DSS4gT3IgcGVyaGFwcwo+Pj4gaWYgdGhlcmUgd2FzIGEgd2F5IGZvciBHMkgg
dHJhbnNwb3J0IHRvIGV4cGxpY2l0bHkgbm90ZSB0aGF0IGl0Cj4+PiBzdXBwb3J0cyBDSURzIHRo
YXQgYXJlIGdyZWF0ZXIgdGhhbiAyPyAgV2l0aCB0aGlzLCBpdCB3b3VsZCBiZQo+Pj4gZWFzaWVy
IHRvIHNlZSB0aGlzIHBhdGNoIGFzIHByZXNlcnZpbmcgdGhlIGRlZmF1bHQgYmVoYXZpb3VyIGZv
cgo+Pj4gc29tZSB0cmFuc3BvcnRzIGFuZCBmaXhpbmcgYSBidWcgZm9yIG90aGVycy4KPj4KPj4g
SSB1bmRlcnN0YW5kIHdoYXQgeW91IHdhbnQsIGJ1dCBiZXdhcmUgdGhhdCBpdCdzIGFjdHVhbGx5
IGEgY2hhbmdlIGluCj4+IGJlaGF2aW9yLiBUb2RheSwgd2hldGhlciBMaW51eCB3aWxsIHNlbmQg
dnNvY2sgY29ubmVjdHMgdG8gVk1DSSBkZXBlbmRzIG9uCj4+IHdoZXRoZXIgdGhlIHZob3N0IGtl
cm5lbCBtb2R1bGUgaXMgbG9hZGVkOiBJZiBpdCdzIGxvYWRlZCwgeW91IGRvbid0IHNlZSB0aGUK
Pj4gY29ubmVjdCBhdHRlbXB0LiBJZiBpdCdzIG5vdCBsb2FkZWQsIHRoZSBjb25uZWN0IHdpbGwg
Y29tZSB0aHJvdWdoIHRvIFZNQ0kuCj4+Cj4+IEkgYWdyZWUgdGhhdCBpdCBtYWtlcyBzZW5zZSB0
byBsaW1pdCBWTUNJIHRvIG9ubHkgZXZlciBzZWUgY29ubmVjdHMgdG8gPD0gMgo+PiBjb25zaXN0
ZW50bHkuIEJ1dCBhcyBJIHNhaWQgYWJvdmUsIGl0J3MgYWN0dWFsbHkgYSBjaGFuZ2UgaW4gYmVo
YXZpb3IuCj4+Cj4+Cj4+IEFsZXgKPj4KPiBJIHRoaW5rIGl0IHdhcyB1bmludGVudGlvbmFsLCBi
dXQgaWYgeW91IHJlYWxseSB0aGluayBwZW9wbGUgd2FudCBhCj4gc3BlY2lhbCBtb2R1bGUgdGhh
dCBjaGFuZ2VzIGtlcm5lbCdzIGJlaGF2aW91ciBvbiBsb2FkLCB3ZSBjYW4gY2VydGFpbmx5Cj4g
ZG8gdGhhdC4gQnV0IGFueSBoYWNrIGxpa2UgdGhpcyB3aWxsIG5vdCBiZSBuYW1lc3BhY2Ugc2Fm
ZS4KCgpObywgSSB0aGluayBhbnkgYmVoYXZpb3IgdGhhdCBjaGFuZ2VzIGJhc2VkIG9uIHdoZXRo
ZXIgYSB2aG9zdCBrZXJuZWwgCm1vZHVsZSBpcyBsb2FkZWQgaXMgYnJva2VuIGJ5IGRlc2lnbiA6
KS4gSSdsbCBtYWtlIGl0IGNvbnNpc3RlbnQgaW4gdjMuIApKdXN0IHdhbnRlZCB0byBtYWtlIHN1
cmUgdGhhdCB3ZSdyZSBvbiB0aGUgc2FtZSBwYWdlIHRoYXQgaXQncyBub3QgIlZNQ0kgCmlzIG5v
dCBhZmZlY3RlZCBieSB0aGlzIi4gSXQgYWxzbyBoYXMgdGhlIHNhbWUgaW5jb25zaXN0ZW5jeSB0
b2RheS4KCgpBbGV4CgoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBH
ZXJtYW55IEdtYkgKVGFtYXJhLURhbnotU3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1
ZWhydW5nOiBDaHJpc3RvZiBIZWxsbWlzLCBBbmRyZWFzIFN0aWVnZXIKRWluZ2V0cmFnZW4gYW0g
QW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNpdHo6IEJlcmxp
bgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3Cg==


