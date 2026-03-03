Return-Path: <kvm+bounces-72599-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHj4FARJp2m8gQAAu9opvQ
	(envelope-from <kvm+bounces-72599-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 21:48:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1341F6EF1
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 21:48:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F41BD30FAF01
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 20:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE37738836E;
	Tue,  3 Mar 2026 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="TIkAejtx"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B523264F0;
	Tue,  3 Mar 2026 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772570856; cv=none; b=RJoJyTbhTzBcMpU9CQfRrvFXZplGnZbMZdYoG8HghVc9JVwhNqDLwlntvmSC8Ku5ZJNkumPBOTEnNYbpbe2O78rpQxk/A0dR1QEQzm7ZDOe8ZhKBLclhsb5J2H7GSlLl1WRgrtLCi8VrmQ3e6XbgfnOEBrMVsRO9dp9691Ed89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772570856; c=relaxed/simple;
	bh=6g5JMU9KAMWLv1pTz/swanUPhp8AX49OO/kcdSwt73c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MxsgQxTs47Q5kUpvD53hXuxdMraTm1EQUBGeQ7ahT3KLK0eVpSC/msWoYzHUY2Q87OIh9bXJxuL/GPVzQPJ0Za4+5iwtT30wVAZ+pG49KE5gypJxfa3OMqH1/WOdg5242XAdinrQcYUT+ccdqx+B7PKuGvGEUpk5GmJUG/gbVTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=TIkAejtx; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772570854; x=1804106854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6g5JMU9KAMWLv1pTz/swanUPhp8AX49OO/kcdSwt73c=;
  b=TIkAejtxibXJrGdDOVObhdIVgEB0UXs2uFAScoxrKuGz6FGhCRTUCb2F
   4trK9t3d6FaHfwXTVHDlHJblWk9OMnp9Cw5sd51vQR69AlVtPxUMamCXw
   sU/p8H3R1XdoV57gcHcuFJzw4OHwSxGwyVmSbZAQUJwx39u/q1uaPy5o2
   BMTBNzFpB/iv4v/s8XCwRW5ScGBoEAybQ5b3TILsrcqISn6BCgjF8ZV36
   Q66gb89jSmGYrdEKKRORsVS+0bIRTuOFapIOTxWtR5FXO/ygP4mb1x4cQ
   lwqRL7XY3n6vTn3o+Ol7W9YQoRTscy0gynbhZ4lXUYeDwhOIg/WtENJAs
   A==;
X-CSE-ConnectionGUID: eg3vmT2FSiiiWlGvh9JtVw==
X-CSE-MsgGUID: VWhb44i0Qtasq8is3F2LsQ==
X-IronPort-AV: E=Sophos;i="6.21,322,1763424000"; 
   d="scan'208";a="14221848"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 20:47:32 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:13782]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.26.67:2525] with esmtp (Farcaster)
 id b7f6c1f4-cecc-4762-bf4e-a24993c8db36; Tue, 3 Mar 2026 20:47:31 +0000 (UTC)
X-Farcaster-Flow-ID: b7f6c1f4-cecc-4762-bf4e-a24993c8db36
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 3 Mar 2026 20:47:31 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 3 Mar 2026
 20:47:28 +0000
Message-ID: <cc4093e8-31c8-4a14-80f9-034852cf54f7@amazon.com>
Date: Tue, 3 Mar 2026 21:47:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: Enable H2G override
To: Bryan Tan <bryan-bt.tan@broadcom.com>, Stefano Garzarella
	<sgarzare@redhat.com>
CC: Vishnu Dasa <vishnu.dasa@broadcom.com>, "Broadcom internal kernel review
 list" <bcm-kernel-feedback-list@broadcom.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason
 Wang <jasowang@redhat.com>, <mst@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, <nh-open-source@amazon.com>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat> <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <aaW2FgoaXIJEymyR@sgarzare-redhat>
 <27dcad4e-d658-4b6b-93b2-44c64fcbeb11@amazon.com>
 <aaaqLbRNmoRHNTkh@sgarzare-redhat>
 <CAOuBmuaQwxKDJoirwtRwEP=690JcRX3Efk6z=udiOHsGr8u6ag@mail.gmail.com>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <CAOuBmuaQwxKDJoirwtRwEP=690JcRX3Efk6z=udiOHsGr8u6ag@mail.gmail.com>
X-ClientProxiedBy: EX19D039UWA003.ant.amazon.com (10.13.139.49) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: CE1341F6EF1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.06 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72599-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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

Ck9uIDAzLjAzLjI2IDE1OjE3LCBCcnlhbiBUYW4gd3JvdGU6Cj4gT24gVHVlLCBNYXIgMywgMjAy
NiBhdCA5OjQ54oCvQU0gU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPiB3
cm90ZToKPj4gT24gTW9uLCBNYXIgMDIsIDIwMjYgYXQgMDg6MDQ6MjJQTSArMDEwMCwgQWxleGFu
ZGVyIEdyYWYgd3JvdGU6Cj4+PiBPbiAwMi4wMy4yNiAxNzoyNSwgU3RlZmFubyBHYXJ6YXJlbGxh
IHdyb3RlOgo+Pj4+IE9uIE1vbiwgTWFyIDAyLCAyMDI2IGF0IDA0OjQ4OjMzUE0gKzAxMDAsIEFs
ZXhhbmRlciBHcmFmIHdyb3RlOgo+Pj4+PiBPbiAwMi4wMy4yNiAxMzowNiwgU3RlZmFubyBHYXJ6
YXJlbGxhIHdyb3RlOgo+Pj4+Pj4gQ0NpbmcgQnJ5YW4sIFZpc2hudSwgYW5kIEJyb2FkY29tIGxp
c3QuCj4+Pj4+Pgo+Pj4+Pj4gT24gTW9uLCBNYXIgMDIsIDIwMjYgYXQgMTI6NDc6MDVQTSArMDEw
MCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOgo+Pj4+Pj4+IFBsZWFzZSB0YXJnZXQgbmV0LW5l
eHQgdHJlZSBmb3IgdGhpcyBuZXcgZmVhdHVyZS4KPj4+Pj4+Pgo+Pj4+Pj4+IE9uIE1vbiwgTWFy
IDAyLCAyMDI2IGF0IDEwOjQxOjM4QU0gKzAwMDAsIEFsZXhhbmRlciBHcmFmIHdyb3RlOgo+Pj4+
Pj4+PiBWc29jayBtYWludGFpbnMgYSBzaW5nbGUgQ0lEIG51bWJlciBzcGFjZSB3aGljaCBjYW4g
YmUgdXNlZCB0bwo+Pj4+Pj4+PiBjb21tdW5pY2F0ZSB0byB0aGUgaG9zdCAoRzJIKSBvciB0byBh
IGNoaWxkLVZNIChIMkcpLiBUaGUKPj4+Pj4+Pj4gY3VycmVudCBsb2dpYwo+Pj4+Pj4+PiB0cml2
aWFsbHkgYXNzdW1lcyB0aGF0IEcySCBpcyBvbmx5IHJlbGV2YW50IGZvciBDSUQgPD0gMgo+Pj4+
Pj4+PiBiZWNhdXNlIHRoZXNlCj4+Pj4+Pj4+IHRhcmdldCB0aGUgaHlwZXJ2aXNvci4gIEhvd2V2
ZXIsIGluIGVudmlyb25tZW50cyBsaWtlIE5pdHJvCj4+Pj4+Pj4+IEVuY2xhdmVzLCBhbgo+Pj4+
Pj4+PiBpbnN0YW5jZSB0aGF0IGhvc3RzIHZob3N0X3Zzb2NrIHBvd2VyZWQgVk1zIG1heSBzdGls
bCB3YW50Cj4+Pj4+Pj4+IHRvIGNvbW11bmljYXRlCj4+Pj4+Pj4+IHRvIEVuY2xhdmVzIHRoYXQg
YXJlIHJlYWNoYWJsZSBhdCBoaWdoZXIgQ0lEcyB0aHJvdWdoCj4+Pj4+Pj4+IHZpcnRpby12c29j
ay1wY2kuCj4+Pj4+Pj4+Cj4+Pj4+Pj4+IFRoYXQgbWVhbnMgdGhhdCBmb3IgQ0lEID4gMiwgd2Ug
cmVhbGx5IHdhbnQgYW4gb3ZlcmxheS4gQnkKPj4+Pj4+Pj4gZGVmYXVsdCwgYWxsCj4+Pj4+Pj4+
IENJRHMgYXJlIG93bmVkIGJ5IHRoZSBoeXBlcnZpc29yLiBCdXQgaWYgdmhvc3QgcmVnaXN0ZXJz
IGEKPj4+Pj4+Pj4gQ0lELCBpdCB0YWtlcwo+Pj4+Pj4+PiBwcmVjZWRlbmNlLiAgSW1wbGVtZW50
IHRoYXQgbG9naWMuIFZob3N0IGFscmVhZHkga25vd3Mgd2hpY2ggQ0lEcyBpdAo+Pj4+Pj4+PiBz
dXBwb3J0cyBhbnl3YXkuCj4+Pj4+Pj4+Cj4+Pj4+Pj4+IFdpdGggdGhpcyBsb2dpYywgSSBjYW4g
cnVuIGEgTml0cm8gRW5jbGF2ZSBhcyB3ZWxsIGFzIGEKPj4+Pj4+Pj4gbmVzdGVkIFZNIHdpdGgK
Pj4+Pj4+Pj4gdmhvc3QtdnNvY2sgc3VwcG9ydCBpbiBwYXJhbGxlbCwgd2l0aCB0aGUgcGFyZW50
IGluc3RhbmNlIGFibGUgdG8KPj4+Pj4+Pj4gY29tbXVuaWNhdGUgdG8gYm90aCBzaW11bHRhbmVv
dXNseS4KPj4+Pj4+PiBJIGhvbmVzdGx5IGRvbid0IHVuZGVyc3RhbmQgd2h5IFZNQUREUl9GTEFH
X1RPX0hPU1QgKGFkZGVkCj4+Pj4+Pj4gc3BlY2lmaWNhbGx5IGZvciBOaXRybyBJSVJDKSBpc24n
dCBlbm91Z2ggZm9yIHRoaXMgc2NlbmFyaW8KPj4+Pj4+PiBhbmQgd2UgaGF2ZSB0byBhZGQgdGhp
cyBjaGFuZ2UuICBDYW4geW91IGVsYWJvcmF0ZSBhIGJpdCBtb3JlCj4+Pj4+Pj4gYWJvdXQgdGhl
IHJlbGF0aW9uc2hpcCBiZXR3ZWVuIHRoaXMgY2hhbmdlIGFuZAo+Pj4+Pj4+IFZNQUREUl9GTEFH
X1RPX0hPU1Qgd2UgYWRkZWQ/Cj4+Pj4+Cj4+Pj4+IFRoZSBtYWluIHByb2JsZW0gSSBoYXZlIHdp
dGggVk1BRERSX0ZMQUdfVE9fSE9TVCBmb3IgY29ubmVjdCgpIGlzCj4+Pj4+IHRoYXQgaXQgcHVu
dHMgdGhlIGNvbXBsZXhpdHkgdG8gdGhlIHVzZXIuIEluc3RlYWQgb2YgYSBzaW5nbGUgQ0lECj4+
Pj4+IGFkZHJlc3Mgc3BhY2UsIHlvdSBub3cgZWZmZWN0aXZlbHkgY3JlYXRlIDIgc3BhY2VzOiBP
bmUgZm9yCj4+Pj4+IFRPX0hPU1QgKG5lZWRzIGEgZmxhZykgYW5kIG9uZSBmb3IgVE9fR1VFU1Qg
KG5vIGZsYWcpLiBCdXQgZXZlcnkKPj4+Pj4gdXNlciBzcGFjZSB0b29sIG5lZWRzIHRvIGxlYXJu
IGFib3V0IHRoaXMgZmxhZy4gVGhhdCBtYXkgd29yayBmb3IKPj4+Pj4gc3VwZXIgc3BlY2lhbC1j
YXNlIGFwcGxpY2F0aW9ucy4gQnV0IHByb3BhZ2F0aW5nIHRoYXQgYWxsIHRoZSB3YXkKPj4+Pj4g
aW50byBzb2NhdCwgaXBlcmYsIGV0YyBldGM/IEl0J3MganVzdCBjcmVhdGluZyBmcmljdGlvbi4K
Pj4+PiBPa2F5LCBJIHdvdWxkIGxpa2UgdG8gaGF2ZSB0aGlzIChvciBwYXJ0IG9mIGl0KSBpbiB0
aGUgY29tbWl0Cj4+Pj4gbWVzc2FnZSB0byBiZXR0ZXIgZXhwbGFpbiB3aHkgd2Ugd2FudCB0aGlz
IGNoYW5nZS4KPj4+Pgo+Pj4+PiBJTUhPIHRoZSBtb3N0IG5hdHVyYWwgZXhwZXJpZW5jZSBpcyB0
byBoYXZlIGEgc2luZ2xlIENJRCBzcGFjZSwKPj4+Pj4gcG90ZW50aWFsbHkgbWFudWFsbHkgc2Vn
bWVudGVkIGJ5IGxhdW5jaGluZyBWTXMgb2Ygb25lIGtpbmQgd2l0aGluCj4+Pj4+IGEgY2VydGFp
biByYW5nZS4KPj4+PiBJIHNlZSwgYnV0IGF0IHRoaXMgcG9pbnQsIHNob3VsZCB0aGUga2VybmVs
IHNldCBWTUFERFJfRkxBR19UT19IT1NUCj4+Pj4gaW4gdGhlIHJlbW90ZSBhZGRyZXNzIGlmIHRo
YXQgcGF0aCBpcyB0YWtlbiAiYXV0b21hZ2ljYWxseSIgPwo+Pj4+Cj4+Pj4gU28gaW4gdGhhdCB3
YXkgdGhlIHVzZXIgc3BhY2UgY2FuIGhhdmUgYSB3YXkgdG8gdW5kZXJzdGFuZCBpZiBpdCdzCj4+
Pj4gdGFsa2luZyB3aXRoIGEgbmVzdGVkIGd1ZXN0IG9yIGEgc2libGluZyBndWVzdC4KPj4+Pgo+
Pj4+Cj4+Pj4gVGhhdCBzYWlkLCBJJ20gY29uY2VybmVkIGFib3V0IHRoZSBzY2VuYXJpbyB3aGVy
ZSBhbiBhcHBsaWNhdGlvbgo+Pj4+IGRvZXMgbm90IGV2ZW4gY29uc2lkZXIgY29tbXVuaWNhdGlu
ZyB3aXRoIGEgc2libGluZyBWTS4KPj4+Cj4+PiBJZiB0aGF0J3MgcmVhbGx5IGEgcmVhbGlzdGlj
IGNvbmNlcm4sIHRoZW4gd2Ugc2hvdWxkIGFkZCBhCj4+PiBWTUFERFJfRkxBR19UT19HVUVTVCB0
aGF0IHRoZSBhcHBsaWNhdGlvbiBjYW4gc2V0LiBEZWZhdWx0IGJlaGF2aW9yIG9mCj4+PiBhbiBh
cHBsaWNhdGlvbiB0aGF0IHByb3ZpZGVzIG5vIGZsYWdzIGlzICJyb3V0ZSB0byB3aGF0ZXZlciB5
b3UgY2FuCj4+PiBmaW5kIjogSWYgdmhvc3QgaXMgbG9hZGVkLCBpdCByb3V0ZXMgdG8gdmhvc3Qu
IElmIGEgdnNvY2sgYmFja2VuZAo+PiBtbW0sIHdlIGhhdmUgYWx3YXlzIGRvY3VtZW50ZWQgdGhp
cyBzaW1wbGUgYmVoYXZpb3I6Cj4+IC0gQ0lEID0gMiB0YWxrcyB0byB0aGUgaG9zdAo+PiAtIENJ
RCA+PSAzIHRhbGtzIHRvIHRoZSBndWVzdAo+Pgo+PiBOb3cgd2UgYXJlIGNoYW5naW5nIHRoaXMg
YnkgYWRkaW5nIGZhbGxiYWNrLiBJIGRvbid0IHRoaW5rIHdlIHNob3VsZAo+PiBjaGFuZ2UgdGhl
IGRlZmF1bHQgYmVoYXZpb3IsIGJ1dCByYXRoZXIgcHJvdmlkZSBuZXcgd2F5cyB0byBlbmFibGUg
dGhpcwo+PiBuZXcgYmVoYXZpb3IuCj4+Cj4+IEkgZmluZCBpdCBzdHJhbmdlIHRoYXQgYW4gYXBw
bGljYXRpb24gcnVubmluZyBvbiBMaW51eCA3LjAgaGFzIGEgZGVmYXVsdAo+PiBiZWhhdmlvciB3
aGVyZSB1c2luZyBDSUQ9NDIgYWx3YXlzIHRhbGtzIHRvIGEgbmVzdGVkIFZNLCBidXQgc3RhcnRp
bmcKPj4gd2l0aCBMaW51eCA3LjEsIGl0IGFsc28gc3RhcnRzIHRhbGtpbmcgdG8gYSBzaWJsaW5n
IFZNLgo+Pgo+Pj4gZHJpdmVyIGlzIGxvYWRlZCwgaXQgcm91dGVzIHRoZXJlLiBCdXQgdGhlIGFw
cGxpY2F0aW9uIGhhcyBubyBzYXkgaW4KPj4+IHdoZXJlIGl0IGdvZXM6IEl0J3MgcHVyZWx5IGEg
c3lzdGVtIGNvbmZpZ3VyYXRpb24gdGhpbmcuCj4+IFRoaXMgaXMgdHJ1ZSBmb3IgY29tcGxleCB0
aGluZ3MgbGlrZSBJUCwgYnV0IGZvciBWU09DSyB3ZSBoYXZlIGFsd2F5cwo+PiB3YW50ZWQgdG8g
a2VlcCB0aGUgZGVmYXVsdCBiZWhhdmlvciB2ZXJ5IHNpbXBsZSAoYXMgd3JpdHRlbiBhYm92ZSku
Cj4+IEV2ZXJ5dGhpbmcgZWxzZSBtdXN0IGJlIGV4cGxpY2l0bHkgZW5hYmxlZCBJTUhPLgo+Pgo+
Pj4KPj4+PiBVbnRpbCBub3csIGl0IGtuZXcgdGhhdCBieSBub3Qgc2V0dGluZyB0aGF0IGZsYWcs
IGl0IGNvdWxkIG9ubHkgdGFsawo+Pj4+IHRvIG5lc3RlZCBWTXMsIHNvIGlmIHRoZXJlIHdhcyBu
byBWTSB3aXRoIHRoYXQgQ0lELCB0aGUgY29ubmVjdGlvbgo+Pj4+IHNpbXBseSBmYWlsZWQuIFdo
ZXJlYXMgZnJvbSB0aGlzIHBhdGNoIG9ud2FyZHMsIGlmIHRoZSBkZXZpY2UgaW4gdGhlCj4+Pj4g
aG9zdCBzdXBwb3J0cyBzaWJsaW5nIFZNcyBhbmQgdGhlcmUgaXMgYSBWTSB3aXRoIHRoYXQgQ0lE
LCB0aGUKPj4+PiBhcHBsaWNhdGlvbiBmaW5kcyBpdHNlbGYgdGFsa2luZyB0byBhIHNpYmxpbmcg
Vk0gaW5zdGVhZCBvZiBhIG5lc3RlZAo+Pj4+IG9uZSwgd2l0aG91dCBoYXZpbmcgYW55IGlkZWEu
Cj4+Pgo+Pj4gSSdkIHNheSBhbiBhcHBsaWNhdGlvbiB0aGF0IGF0dGVtcHRzIHRvIHRhbGsgdG8g
YSBDSUQgdGhhdCBpdCBkb2VzIG5vdwo+Pj4ga25vdyB3aGV0aGVyIGl0J3Mgdmhvc3Qgcm91dGVk
IG9yIG5vdCBpcyBydW5uaW5nIGludG8gInVuZGVmaW5lZCIKPj4+IHRlcnJpdG9yeS4gSWYgeW91
IHJtbW9kIHRoZSB2aG9zdCBkcml2ZXIsIGl0IHdvdWxkIGFsc28gdGFsayB0byB0aGUKPj4+IGh5
cGVydmlzb3IgcHJvdmlkZWQgdnNvY2suCj4+IE9oLCBJIG1pc3NlZCB0aGF0LiBBbmQgSSBhbHNv
IGZpeGVkIHRoYXQgYmVoYXZpb3VyIHdpdGggY29tbWl0Cj4+IDY1YjQyMmQ5YjYxYiAoInZzb2Nr
OiBmb3J3YXJkIGFsbCBwYWNrZXRzIHRvIHRoZSBob3N0IHdoZW4gbm8gSDJHIGlzCj4+IHJlZ2lz
dGVyZWQiKSBhZnRlciBJIGltcGxlbWVudGVkIHRoZSBtdWx0aS10cmFuc3BvcnQgc3VwcG9ydC4K
Pj4KPj4gbW1tLCB0aGlzIGNvdWxkIGNoYW5nZSBteSBwb3NpdGlvbiA7LSkgKGFsdGhvdWdoLCB0
byBiZSBob25lc3QsIEkgZG9uJ3QKPj4gdW5kZXJzdGFuZCB3aHkgaXQgd2FzIGxpa2UgdGhhdCBp
biB0aGUgZmlyc3QgcGxhY2UsIGJ1dCB0aGF0J3MgaG93IGl0IGlzCj4+IG5vdykuCj4+Cj4+IFBs
ZWFzZSBkb2N1bWVudCBhbHNvIHRoaXMgaW4gdGhlIG5ldyBjb21taXQgbWVzc2FnZSwgaXMgYSBn
b29kIHBvaW50Lgo+PiBBbHRob3VnaCB3aGVuIEgyRyBpcyBsb2FkZWQsIHdlIGJlaGF2ZSBkaWZm
ZXJlbnRseS4gSG93ZXZlciwgaXQgaXMgdHJ1ZQo+PiB0aGF0IHN5c2N0bCBoZWxwcyB1cyBzdGFu
ZGFyZGl6ZSB0aGlzIGJlaGF2aW9yLgo+Pgo+PiBJIGRvbid0IGtub3cgd2hldGhlciB0byBzZWUg
aXQgYXMgYSByZWdyZXNzaW9uIG9yIG5vdC4KPj4KPj4+Cj4+Pj4gU2hvdWxkIHdlIG1ha2UgdGhp
cyBmZWF0dXJlIG9wdC1pbiBpbiBzb21lIHdheSwgc3VjaCBhcyBzb2Nrb3B0IG9yCj4+Pj4gc3lz
Y3RsPyAoSSB1bmRlcnN0YW5kIHRoYXQgdGhlcmUgaXMgdGhlIHByZXZpb3VzIHByb2JsZW0sIGJ1
dAo+Pj4+IGhvbmVzdGx5LCBpdCBzZWVtcyBsaWtlIGEgc2lnbmlmaWNhbnQgY2hhbmdlIHRvIHRo
ZSBiZWhhdmlvciBvZgo+Pj4+IEFGX1ZTT0NLKS4KPj4+Cj4+PiBXZSBjYW4gY3JlYXRlIGEgc3lz
Y3RsIHRvIGVuYWJsZSBiZWhhdmlvciB3aXRoIGRlZmF1bHQ9b24uIEJ1dCBJJ20KPj4+IGFnYWlu
c3QgbWFraW5nIHRoZSBjdW1iZXJzb21lIGRvZXMtbm90LXdvcmstb3V0LW9mLXRoZS1ib3ggZXhw
ZXJpZW5jZQo+Pj4gdGhlIGRlZmF1bHQuIFdpbGwgaW5jbHVkZSBpdCBpbiB2Mi4KPj4gVGhlIG9w
cG9zaXRlIHBvaW50IG9mIHZpZXcgaXMgdGhhdCB3ZSB3b3VsZCBub3Qgd2FudCB0byBoYXZlIGRp
ZmZlcmVudAo+PiBkZWZhdWx0IGJlaGF2aW9yIGJldHdlZW4gNy4wIGFuZCA3LjEgd2hlbiBIMkcg
aXMgbG9hZGVkLgo+ICBGcm9tIGEgVk1DSSBwZXJzcGVjdGl2ZSwgd2Ugb25seSBhbGxvdyBjb21t
dW5pY2F0aW9uIGZyb20gZ3Vlc3QgdG8KPiBob3N0IENJRHMgMCBhbmQgMi4gV2l0aCBoYXNfcmVt
b3RlX2NpZCBpbXBsZW1lbnRlZCBmb3IgVk1DSSwgd2UgZW5kCj4gdXAgYXR0ZW1wdGluZyBndWVz
dCB0byBndWVzdCBjb21tdW5pY2F0aW9uLiBBcyBtZW50aW9uZWQgdGhpcyBkb2VzCj4gYWxyZWFk
eSBoYXBwZW4gaWYgdGhlcmUgaXNuJ3QgYW4gSDJHIHRyYW5zcG9ydCByZWdpc3RlcmVkLCBzbyB3
ZQo+IHNob3VsZCBiZSBoYW5kbGluZyB0aGlzIGFueXdheXMuIEJ1dCBJJ20gbm90IHRvbyBmb25k
IG9mIHRoZSBjaGFuZ2UKPiBpbiBiZWhhdmlvdXIgZm9yIHdoZW4gSDJHIGlzIHByZXNlbnQsIHNv
IGluIHRoZSB2ZXJ5IGxlYXN0IEknZAo+IHByZWZlciBpZiBoYXNfcmVtb3RlX2NpZCBpcyBub3Qg
aW1wbGVtZW50ZWQgZm9yIFZNQ0kuIE9yIHBlcmhhcHMKPiBpZiB0aGVyZSB3YXMgYSB3YXkgZm9y
IEcySCB0cmFuc3BvcnQgdG8gZXhwbGljaXRseSBub3RlIHRoYXQgaXQKPiBzdXBwb3J0cyBDSURz
IHRoYXQgYXJlIGdyZWF0ZXIgdGhhbiAyPyAgV2l0aCB0aGlzLCBpdCB3b3VsZCBiZQo+IGVhc2ll
ciB0byBzZWUgdGhpcyBwYXRjaCBhcyBwcmVzZXJ2aW5nIHRoZSBkZWZhdWx0IGJlaGF2aW91ciBm
b3IKPiBzb21lIHRyYW5zcG9ydHMgYW5kIGZpeGluZyBhIGJ1ZyBmb3Igb3RoZXJzLgoKCkkgdW5k
ZXJzdGFuZCB3aGF0IHlvdSB3YW50LCBidXQgYmV3YXJlIHRoYXQgaXQncyBhY3R1YWxseSBhIGNo
YW5nZSBpbiAKYmVoYXZpb3IuIFRvZGF5LCB3aGV0aGVyIExpbnV4IHdpbGwgc2VuZCB2c29jayBj
b25uZWN0cyB0byBWTUNJIGRlcGVuZHMgCm9uIHdoZXRoZXIgdGhlIHZob3N0IGtlcm5lbCBtb2R1
bGUgaXMgbG9hZGVkOiBJZiBpdCdzIGxvYWRlZCwgeW91IGRvbid0IApzZWUgdGhlIGNvbm5lY3Qg
YXR0ZW1wdC4gSWYgaXQncyBub3QgbG9hZGVkLCB0aGUgY29ubmVjdCB3aWxsIGNvbWUgCnRocm91
Z2ggdG8gVk1DSS4KCkkgYWdyZWUgdGhhdCBpdCBtYWtlcyBzZW5zZSB0byBsaW1pdCBWTUNJIHRv
IG9ubHkgZXZlciBzZWUgY29ubmVjdHMgdG8gCjw9IDIgY29uc2lzdGVudGx5LiBCdXQgYXMgSSBz
YWlkIGFib3ZlLCBpdCdzIGFjdHVhbGx5IGEgY2hhbmdlIGluIGJlaGF2aW9yLgoKCkFsZXgKCgoK
CkFtYXpvbiBXZWIgU2VydmljZXMgRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1h
cmEtRGFuei1TdHIuIDEzCjEwMjQzIEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdG9m
IEhlbGxtaXMsIEFuZHJlYXMgU3RpZWdlcgpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1
IDUzOCA1OTcK


