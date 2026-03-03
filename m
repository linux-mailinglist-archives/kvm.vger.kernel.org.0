Return-Path: <kvm+bounces-72504-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CmhJSqFpmnaQwAAu9opvQ
	(envelope-from <kvm+bounces-72504-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:52:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4270E1E9CD9
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94DD3305BFC9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 06:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A903859D4;
	Tue,  3 Mar 2026 06:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FRy0N1mN"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10ED280037;
	Tue,  3 Mar 2026 06:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772520703; cv=none; b=SZg2wKd3I4tQBqzVzxisTC0WpoZ7/Lfol3n0E/a02RSGyx3pbj6FeAx10+k8SbIDh1OTZRXar9kYvmvpOKwl1XWlaoaWbYMRiGfr8KvnKqTSA+CwjLyli/hkRHXouvUvQngHvrBUv3HDMhLCTe48K8HPfbxFMYiwvSSGHEJ4MOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772520703; c=relaxed/simple;
	bh=XniAB7Nu709JmC3nBjM4MCHchvHwFSyw2Pkh2vpiQh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gIO9dzohG6cLw+CeyzeGpj9zbpkywHjAx2W0pzTy6TQ5vkSLEPGCJaezbyGYvneRhDcxT3s4CrizucRmE4ZXIpjorBOLfoh7Uw/1hU1uIRlapjhX6CFIb/4D0W5I/1F4/gvIHxZf0FTqgyjbiC9YkMn7V283N5Vz23fY+ik9PQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FRy0N1mN; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772520701; x=1804056701;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XniAB7Nu709JmC3nBjM4MCHchvHwFSyw2Pkh2vpiQh4=;
  b=FRy0N1mN9IQlHCfZL48e0GyMHPisKTAMQDa8iyT1/hndNgM399h+4db+
   m+jCLoVcI5k5RvKXhMxf0brFBwn+RawrkVsPCezNrvstzNC68x/B34Pjl
   HZOXKePv/wJP8Uxsxb6p3Y/NNE69CL6oIsJOzDdZqif4mwS6aKGFlydBo
   Y4oDjYpHaI4+5u/TVU+4ZBy37iVvVYZ4r1dsUq40CM62Hx2xnvR/M+MDz
   ofGSbUhUTY9Z7LxOs62QS/0FKsHQIr4ZnDxtVpMj3bhcGTMhGoSOJDMuC
   VWoyR+uBl1bAstgepozcJs1tbZoCP0P3T+Ub2goIdo+GQLE0G9ZWnv/Go
   w==;
X-CSE-ConnectionGUID: eQgtqNMKRxua6d485tgN7g==
X-CSE-MsgGUID: FQ/v0esXRzGnf2LAgztaKg==
X-IronPort-AV: E=Sophos;i="6.21,321,1763424000"; 
   d="scan'208";a="13992458"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 06:51:38 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:26483]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.153:2525] with esmtp (Farcaster)
 id b0c919eb-dfcb-4f13-89bc-ffc689a1743c; Tue, 3 Mar 2026 06:51:38 +0000 (UTC)
X-Farcaster-Flow-ID: b0c919eb-dfcb-4f13-89bc-ffc689a1743c
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 3 Mar 2026 06:51:38 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 3 Mar 2026
 06:51:34 +0000
Message-ID: <079fcb93-cd01-45db-9ff7-d6cafd8fb7d5@amazon.com>
Date: Tue, 3 Mar 2026 07:51:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: Enable H2G override
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefano Garzarella <sgarzare@redhat.com>, Bryan Tan
	<bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, Broadcom
 internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason
 Wang <jasowang@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	<nh-open-source@amazon.com>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat> <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
 <20260302145121-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20260302145121-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: EX19D046UWB002.ant.amazon.com (10.13.139.181) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 4270E1E9CD9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.06 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72504-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[graf@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

Ck9uIDAyLjAzLjI2IDIwOjUyLCBNaWNoYWVsIFMuIFRzaXJraW4gd3JvdGU6Cj4gT24gTW9uLCBN
YXIgMDIsIDIwMjYgYXQgMDQ6NDg6MzNQTSArMDEwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+
IE9uIDAyLjAzLjI2IDEzOjA2LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4+PiBDQ2luZyBC
cnlhbiwgVmlzaG51LCBhbmQgQnJvYWRjb20gbGlzdC4KPj4+Cj4+PiBPbiBNb24sIE1hciAwMiwg
MjAyNiBhdCAxMjo0NzowNVBNICswMTAwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4+Pj4g
UGxlYXNlIHRhcmdldCBuZXQtbmV4dCB0cmVlIGZvciB0aGlzIG5ldyBmZWF0dXJlLgo+Pj4+Cj4+
Pj4gT24gTW9uLCBNYXIgMDIsIDIwMjYgYXQgMTA6NDE6MzhBTSArMDAwMCwgQWxleGFuZGVyIEdy
YWYgd3JvdGU6Cj4+Pj4+IFZzb2NrIG1haW50YWlucyBhIHNpbmdsZSBDSUQgbnVtYmVyIHNwYWNl
IHdoaWNoIGNhbiBiZSB1c2VkIHRvCj4+Pj4+IGNvbW11bmljYXRlIHRvIHRoZSBob3N0IChHMkgp
IG9yIHRvIGEgY2hpbGQtVk0gKEgyRykuIFRoZSBjdXJyZW50IGxvZ2ljCj4+Pj4+IHRyaXZpYWxs
eSBhc3N1bWVzIHRoYXQgRzJIIGlzIG9ubHkgcmVsZXZhbnQgZm9yIENJRCA8PSAyIGJlY2F1c2Ug
dGhlc2UKPj4+Pj4gdGFyZ2V0IHRoZSBoeXBlcnZpc29yLiAgSG93ZXZlciwgaW4gZW52aXJvbm1l
bnRzIGxpa2UgTml0cm8KPj4+Pj4gRW5jbGF2ZXMsIGFuCj4+Pj4+IGluc3RhbmNlIHRoYXQgaG9z
dHMgdmhvc3RfdnNvY2sgcG93ZXJlZCBWTXMgbWF5IHN0aWxsIHdhbnQgdG8KPj4+Pj4gY29tbXVu
aWNhdGUKPj4+Pj4gdG8gRW5jbGF2ZXMgdGhhdCBhcmUgcmVhY2hhYmxlIGF0IGhpZ2hlciBDSURz
IHRocm91Z2ggdmlydGlvLXZzb2NrLXBjaS4KPj4+Pj4KPj4+Pj4gVGhhdCBtZWFucyB0aGF0IGZv
ciBDSUQgPiAyLCB3ZSByZWFsbHkgd2FudCBhbiBvdmVybGF5LiBCeSBkZWZhdWx0LCBhbGwKPj4+
Pj4gQ0lEcyBhcmUgb3duZWQgYnkgdGhlIGh5cGVydmlzb3IuIEJ1dCBpZiB2aG9zdCByZWdpc3Rl
cnMgYSBDSUQsCj4+Pj4+IGl0IHRha2VzCj4+Pj4+IHByZWNlZGVuY2UuICBJbXBsZW1lbnQgdGhh
dCBsb2dpYy4gVmhvc3QgYWxyZWFkeSBrbm93cyB3aGljaCBDSURzIGl0Cj4+Pj4+IHN1cHBvcnRz
IGFueXdheS4KPj4+Pj4KPj4+Pj4gV2l0aCB0aGlzIGxvZ2ljLCBJIGNhbiBydW4gYSBOaXRybyBF
bmNsYXZlIGFzIHdlbGwgYXMgYSBuZXN0ZWQgVk0gd2l0aAo+Pj4+PiB2aG9zdC12c29jayBzdXBw
b3J0IGluIHBhcmFsbGVsLCB3aXRoIHRoZSBwYXJlbnQgaW5zdGFuY2UgYWJsZSB0bwo+Pj4+PiBj
b21tdW5pY2F0ZSB0byBib3RoIHNpbXVsdGFuZW91c2x5Lgo+Pj4+IEkgaG9uZXN0bHkgZG9uJ3Qg
dW5kZXJzdGFuZCB3aHkgVk1BRERSX0ZMQUdfVE9fSE9TVCAoYWRkZWQKPj4+PiBzcGVjaWZpY2Fs
bHkgZm9yIE5pdHJvIElJUkMpIGlzbid0IGVub3VnaCBmb3IgdGhpcyBzY2VuYXJpbyBhbmQgd2UK
Pj4+PiBoYXZlIHRvIGFkZCB0aGlzIGNoYW5nZS4gIENhbiB5b3UgZWxhYm9yYXRlIGEgYml0IG1v
cmUgYWJvdXQgdGhlCj4+Pj4gcmVsYXRpb25zaGlwIGJldHdlZW4gdGhpcyBjaGFuZ2UgYW5kIFZN
QUREUl9GTEFHX1RPX0hPU1Qgd2UgYWRkZWQ/Cj4+Cj4+IFRoZSBtYWluIHByb2JsZW0gSSBoYXZl
IHdpdGggVk1BRERSX0ZMQUdfVE9fSE9TVCBmb3IgY29ubmVjdCgpIGlzIHRoYXQgaXQKPj4gcHVu
dHMgdGhlIGNvbXBsZXhpdHkgdG8gdGhlIHVzZXIuIEluc3RlYWQgb2YgYSBzaW5nbGUgQ0lEIGFk
ZHJlc3Mgc3BhY2UsIHlvdQo+PiBub3cgZWZmZWN0aXZlbHkgY3JlYXRlIDIgc3BhY2VzOiBPbmUg
Zm9yIFRPX0hPU1QgKG5lZWRzIGEgZmxhZykgYW5kIG9uZSBmb3IKPj4gVE9fR1VFU1QgKG5vIGZs
YWcpLiBCdXQgZXZlcnkgdXNlciBzcGFjZSB0b29sIG5lZWRzIHRvIGxlYXJuIGFib3V0IHRoaXMK
Pj4gZmxhZy4gVGhhdCBtYXkgd29yayBmb3Igc3VwZXIgc3BlY2lhbC1jYXNlIGFwcGxpY2F0aW9u
cy4gQnV0IHByb3BhZ2F0aW5nCj4+IHRoYXQgYWxsIHRoZSB3YXkgaW50byBzb2NhdCwgaXBlcmYs
IGV0YyBldGM/IEl0J3MganVzdCBjcmVhdGluZyBmcmljdGlvbi4KPj4KPj4gSU1ITyB0aGUgbW9z
dCBuYXR1cmFsIGV4cGVyaWVuY2UgaXMgdG8gaGF2ZSBhIHNpbmdsZSBDSUQgc3BhY2UsIHBvdGVu
dGlhbGx5Cj4+IG1hbnVhbGx5IHNlZ21lbnRlZCBieSBsYXVuY2hpbmcgVk1zIG9mIG9uZSBraW5k
IHdpdGhpbiBhIGNlcnRhaW4gcmFuZ2UuCj4+Cj4+IEF0IHRoZSBlbmQgb2YgdGhlIGRheSwgdGhl
IGhvc3QgdnMgZ3Vlc3QgcHJvYmxlbSBpcyBzdXBlciBzaW1pbGFyIHRvIGEKPj4gcm91dGluZyB0
YWJsZS4KPiBJZiB0aGlzIGlzIHdoYXQncyBkZXNpcmVkLCBzb21lIGJpdHMgY291bGQgYmUgc3Rv
bGVuIGZyb20gdGhlIENJRAo+IHRvIHNwZWNpZnkgdGhlIGRlc3RpbmF0aW9uIHR5cGUuIFdvdWxk
IHRoYXQgYWRkcmVzcyB0aGUgaXNzdWU/Cj4gSnVzdCBhIHRob3VnaHQuCgoKSWYgd2UgaGFkIHRo
b3VnaHQgb2YgdGhpcyBmcm9tIHRoZSBiZWdpbm5pbmcsIHllcy4gQnV0IG5vdyB0aGF0IGV2ZXJ5
b25lIAp0aGlua3MgQ0lEIChndWVzdCkgPT0gQ0lEIChob3N0KSwgSSBiZWxpZXZlIHRoaXMgaXMg
bm8gbG9uZ2VyIGZlYXNpYmxlLgoKCkFsZXgKCgoKCkFtYXpvbiBXZWIgU2VydmljZXMgRGV2ZWxv
cG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFuei1TdHIuIDEzCjEwMjQzIEJlcmxp
bgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdG9mIEhlbGxtaXMsIEFuZHJlYXMgU3RpZWdlcgpF
aW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMjU3NzY0
IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1OTcK


