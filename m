Return-Path: <kvm+bounces-72393-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKQhGESypWk8EgAAu9opvQ
	(envelope-from <kvm+bounces-72393-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:52:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C93571DC2FE
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD7713079FB9
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA4441B374;
	Mon,  2 Mar 2026 15:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="inwvzoRc"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C1441162B;
	Mon,  2 Mar 2026 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466525; cv=none; b=N91g1/Eroo37AvDeQpwfkp5FDZCeiasqay4op19KQBGxBRr/IELcbzglEG1ULBHnNAOWQykJRPwqVTuTuXTucs56znHzkRavct1bu+KviofUJ/X2CoCGhws7PdBcStdxmHIh8w6kGGenffPJdTpFOIxIAGyPT9IHXEKMb8og6xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466525; c=relaxed/simple;
	bh=8EQMj4FmOrOw4J9iY2p0liDTdDrXYJ6nkvLeacokY2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qJHGSsfwwGyAkM2uy+4lNpZw1ykkfazKXFJIV+ZWfMr6+Dc7Krn3L+ZM8sCJoBED6gNxQO+LwdEUQDwI6hDLquvMWwFpJg0n2+lbCTAD+59WEBtj0i0BPlwdnMZrmRQ1ObgJXrVvbLd+/NUM1bQIQr0IrnJX4qPBp+Pq9fECc/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=inwvzoRc; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772466523; x=1804002523;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8EQMj4FmOrOw4J9iY2p0liDTdDrXYJ6nkvLeacokY2Y=;
  b=inwvzoRc6qOZ9KCqu7QEuNNsO1COVlkmal8KFqHRLfiknlqY1dCPZyEx
   3APnC2EPHd69lv86QjA/2aTbSuMCFT0FOxHF56rpIe4DEFAMSUBDJy4FV
   Y0rWBK8L8EnOiIvblWak3Dy6d+jK7RIt6SlGRskPAMOqHqNXYXKBSFI2f
   k61g1Dk/iwq8RrKooK/AQCt/4T9FTZnLKCa2xSbRjxPOF4NF0rpgsgskr
   cVOWw7RQ7FQE0TwbNYMPCTcEv5Dr5T1/4wK1uDB5h7/xqWkIAhXBmOnnL
   xEePJUGvM44JYUTO/cAID47rX+cCtc57cueBc4G+h4uukfejgw+9kW8gz
   A==;
X-CSE-ConnectionGUID: wrPx9B80SO+qSMCxotxE0Q==
X-CSE-MsgGUID: G+phJaZHQpK6pXjaSzrRrQ==
X-IronPort-AV: E=Sophos;i="6.21,320,1763424000"; 
   d="scan'208";a="13639279"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 15:48:39 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:21011]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.26.67:2525] with esmtp (Farcaster)
 id c892480c-87df-4e06-bb74-5f135ad59b16; Mon, 2 Mar 2026 15:48:38 +0000 (UTC)
X-Farcaster-Flow-ID: c892480c-87df-4e06-bb74-5f135ad59b16
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 2 Mar 2026 15:48:38 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 2 Mar 2026
 15:48:35 +0000
Message-ID: <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
Date: Mon, 2 Mar 2026 16:48:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vsock: Enable H2G override
To: Stefano Garzarella <sgarzare@redhat.com>, Bryan Tan
	<bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, Broadcom
 internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
CC: <virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason
 Wang <jasowang@redhat.com>, <mst@redhat.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, <nh-open-source@amazon.com>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat> <aaV80wWlpjEtYCQJ@sgarzare-redhat>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <aaV80wWlpjEtYCQJ@sgarzare-redhat>
X-ClientProxiedBy: EX19D038UWB002.ant.amazon.com (10.13.139.185) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: C93571DC2FE
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
	TAGGED_FROM(0.00)[bounces-72393-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

Ck9uIDAyLjAzLjI2IDEzOjA2LCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4gQ0NpbmcgQnJ5
YW4sIFZpc2hudSwgYW5kIEJyb2FkY29tIGxpc3QuCj4KPiBPbiBNb24sIE1hciAwMiwgMjAyNiBh
dCAxMjo0NzowNVBNICswMTAwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4+Cj4+IFBsZWFz
ZSB0YXJnZXQgbmV0LW5leHQgdHJlZSBmb3IgdGhpcyBuZXcgZmVhdHVyZS4KPj4KPj4gT24gTW9u
LCBNYXIgMDIsIDIwMjYgYXQgMTA6NDE6MzhBTSArMDAwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6
Cj4+PiBWc29jayBtYWludGFpbnMgYSBzaW5nbGUgQ0lEIG51bWJlciBzcGFjZSB3aGljaCBjYW4g
YmUgdXNlZCB0bwo+Pj4gY29tbXVuaWNhdGUgdG8gdGhlIGhvc3QgKEcySCkgb3IgdG8gYSBjaGls
ZC1WTSAoSDJHKS4gVGhlIGN1cnJlbnQgbG9naWMKPj4+IHRyaXZpYWxseSBhc3N1bWVzIHRoYXQg
RzJIIGlzIG9ubHkgcmVsZXZhbnQgZm9yIENJRCA8PSAyIGJlY2F1c2UgdGhlc2UKPj4+IHRhcmdl
dCB0aGUgaHlwZXJ2aXNvci7CoCBIb3dldmVyLCBpbiBlbnZpcm9ubWVudHMgbGlrZSBOaXRybyAK
Pj4+IEVuY2xhdmVzLCBhbgo+Pj4gaW5zdGFuY2UgdGhhdCBob3N0cyB2aG9zdF92c29jayBwb3dl
cmVkIFZNcyBtYXkgc3RpbGwgd2FudCB0byAKPj4+IGNvbW11bmljYXRlCj4+PiB0byBFbmNsYXZl
cyB0aGF0IGFyZSByZWFjaGFibGUgYXQgaGlnaGVyIENJRHMgdGhyb3VnaCB2aXJ0aW8tdnNvY2st
cGNpLgo+Pj4KPj4+IFRoYXQgbWVhbnMgdGhhdCBmb3IgQ0lEID4gMiwgd2UgcmVhbGx5IHdhbnQg
YW4gb3ZlcmxheS4gQnkgZGVmYXVsdCwgYWxsCj4+PiBDSURzIGFyZSBvd25lZCBieSB0aGUgaHlw
ZXJ2aXNvci4gQnV0IGlmIHZob3N0IHJlZ2lzdGVycyBhIENJRCwgaXQgCj4+PiB0YWtlcwo+Pj4g
cHJlY2VkZW5jZS7CoCBJbXBsZW1lbnQgdGhhdCBsb2dpYy4gVmhvc3QgYWxyZWFkeSBrbm93cyB3
aGljaCBDSURzIGl0Cj4+PiBzdXBwb3J0cyBhbnl3YXkuCj4+Pgo+Pj4gV2l0aCB0aGlzIGxvZ2lj
LCBJIGNhbiBydW4gYSBOaXRybyBFbmNsYXZlIGFzIHdlbGwgYXMgYSBuZXN0ZWQgVk0gd2l0aAo+
Pj4gdmhvc3QtdnNvY2sgc3VwcG9ydCBpbiBwYXJhbGxlbCwgd2l0aCB0aGUgcGFyZW50IGluc3Rh
bmNlIGFibGUgdG8KPj4+IGNvbW11bmljYXRlIHRvIGJvdGggc2ltdWx0YW5lb3VzbHkuCj4+Cj4+
IEkgaG9uZXN0bHkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgVk1BRERSX0ZMQUdfVE9fSE9TVCAoYWRk
ZWQgCj4+IHNwZWNpZmljYWxseSBmb3IgTml0cm8gSUlSQykgaXNuJ3QgZW5vdWdoIGZvciB0aGlz
IHNjZW5hcmlvIGFuZCB3ZSAKPj4gaGF2ZSB0byBhZGQgdGhpcyBjaGFuZ2UuwqAgQ2FuIHlvdSBl
bGFib3JhdGUgYSBiaXQgbW9yZSBhYm91dCB0aGUgCj4+IHJlbGF0aW9uc2hpcCBiZXR3ZWVuIHRo
aXMgY2hhbmdlIGFuZCBWTUFERFJfRkxBR19UT19IT1NUIHdlIGFkZGVkPyAKCgpUaGUgbWFpbiBw
cm9ibGVtIEkgaGF2ZSB3aXRoIFZNQUREUl9GTEFHX1RPX0hPU1QgZm9yIGNvbm5lY3QoKSBpcyB0
aGF0IAppdCBwdW50cyB0aGUgY29tcGxleGl0eSB0byB0aGUgdXNlci4gSW5zdGVhZCBvZiBhIHNp
bmdsZSBDSUQgYWRkcmVzcyAKc3BhY2UsIHlvdSBub3cgZWZmZWN0aXZlbHkgY3JlYXRlIDIgc3Bh
Y2VzOiBPbmUgZm9yIFRPX0hPU1QgKG5lZWRzIGEgCmZsYWcpIGFuZCBvbmUgZm9yIFRPX0dVRVNU
IChubyBmbGFnKS4gQnV0IGV2ZXJ5IHVzZXIgc3BhY2UgdG9vbCBuZWVkcyB0byAKbGVhcm4gYWJv
dXQgdGhpcyBmbGFnLiBUaGF0IG1heSB3b3JrIGZvciBzdXBlciBzcGVjaWFsLWNhc2UgCmFwcGxp
Y2F0aW9ucy4gQnV0IHByb3BhZ2F0aW5nIHRoYXQgYWxsIHRoZSB3YXkgaW50byBzb2NhdCwgaXBl
cmYsIGV0YyAKZXRjPyBJdCdzIGp1c3QgY3JlYXRpbmcgZnJpY3Rpb24uCgpJTUhPIHRoZSBtb3N0
IG5hdHVyYWwgZXhwZXJpZW5jZSBpcyB0byBoYXZlIGEgc2luZ2xlIENJRCBzcGFjZSwgCnBvdGVu
dGlhbGx5IG1hbnVhbGx5IHNlZ21lbnRlZCBieSBsYXVuY2hpbmcgVk1zIG9mIG9uZSBraW5kIHdp
dGhpbiBhIApjZXJ0YWluIHJhbmdlLgoKQXQgdGhlIGVuZCBvZiB0aGUgZGF5LCB0aGUgaG9zdCB2
cyBndWVzdCBwcm9ibGVtIGlzIHN1cGVyIHNpbWlsYXIgdG8gYSAKcm91dGluZyB0YWJsZS4KCgo+
Pgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciBHcmFmIDxncmFmQGFtYXpvbi5jb20+
Cj4+PiAtLS0KPj4+IGRyaXZlcnMvdmhvc3QvdnNvY2suY8KgwqDCoCB8IDExICsrKysrKysrKysr
Cj4+PiBpbmNsdWRlL25ldC9hZl92c29jay5owqDCoCB8wqAgMyArKysKPj4+IG5ldC92bXdfdnNv
Y2svYWZfdnNvY2suYyB8wqAgMyArKysKPj4+IDMgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9u
cygrKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L3Zzb2NrLmMgYi9kcml2ZXJz
L3Zob3N0L3Zzb2NrLmMKPj4+IGluZGV4IDA1NGY3YTcxOGY1MC4uMjIzZGE4MTdlMzA1IDEwMDY0
NAo+Pj4gLS0tIGEvZHJpdmVycy92aG9zdC92c29jay5jCj4+PiArKysgYi9kcml2ZXJzL3Zob3N0
L3Zzb2NrLmMKPj4+IEBAIC05MSw2ICs5MSwxNiBAQCBzdGF0aWMgc3RydWN0IHZob3N0X3Zzb2Nr
ICp2aG9zdF92c29ja19nZXQodTMyIAo+Pj4gZ3Vlc3RfY2lkLCBzdHJ1Y3QgbmV0ICpuZXQpCj4+
PiDCoMKgwqDCoHJldHVybiBOVUxMOwo+Pj4gfQo+Pj4KPj4+ICtzdGF0aWMgYm9vbCB2aG9zdF90
cmFuc3BvcnRfaGFzX2NpZCh1MzIgY2lkKQo+Pj4gK3sKPj4+ICvCoMKgwqAgYm9vbCBmb3VuZDsK
Pj4+ICsKPj4+ICvCoMKgwqAgcmN1X3JlYWRfbG9jaygpOwo+Pj4gK8KgwqDCoCBmb3VuZCA9IHZo
b3N0X3Zzb2NrX2dldChjaWQpICE9IE5VTEw7Cj4+Cj4+IFdlIHJlY2VudGx5IGFkZGVkIG5hbWVz
cGFjZXMgc3VwcG9ydCB0aGF0IGNoYW5nZWQgdmhvc3RfdnNvY2tfZ2V0KCkgCj4+IHBhcmFtcy4g
VGhpcyBpcyBhbHNvIGluIG5ldCB0cmVlIG5vdyBhbmQgaW4gTGludXMnIHRyZWUsIHNvIG5vdCBz
dXJlIAo+PiB3aGVyZSB0aGlzIHBhdGNoIGlzIGJhc2VkLCBidXQgdGhpcyBuZWVkcyB0byBiZSBy
ZWJhc2VkIHNpbmNlIGl0IGlzIAo+PiBub3QgYnVpbGRpbmc6Cj4+Cj4+IC4uL2RyaXZlcnMvdmhv
c3QvdnNvY2suYzogSW4gZnVuY3Rpb24g4oCYdmhvc3RfdHJhbnNwb3J0X2hhc19jaWTigJk6Cj4+
IC4uL2RyaXZlcnMvdmhvc3QvdnNvY2suYzo5OToxNzogZXJyb3I6IHRvbyBmZXcgYXJndW1lbnRz
IHRvIGZ1bmN0aW9uIAo+PiDigJh2aG9zdF92c29ja19nZXTigJk7IGV4cGVjdGVkIDIsIGhhdmUg
MQo+PiDCoCA5OSB8wqDCoMKgwqDCoMKgwqDCoCBmb3VuZCA9IHZob3N0X3Zzb2NrX2dldChjaWQp
ICE9IE5VTEw7Cj4+IMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBe
fn5+fn5+fn5+fn5+fn4KPj4gLi4vZHJpdmVycy92aG9zdC92c29jay5jOjc0OjI4OiBub3RlOiBk
ZWNsYXJlZCBoZXJlCj4+IMKgIDc0IHwgc3RhdGljIHN0cnVjdCB2aG9zdF92c29jayAqdmhvc3Rf
dnNvY2tfZ2V0KHUzMiBndWVzdF9jaWQsIAo+PiBzdHJ1Y3QgbmV0ICpuZXQpCj4+IMKgwqDCoMKg
IHwKCgpEJ29oLiBTb3JyeSwgSSBidWlsdCB0aGlzIG9uIDYuMTkgYW5kIG9ubHkgcmVhbGl6ZWQg
YWZ0ZXIgdGhlIHNlbmQgdGhhdCAKbmFtZXNwYWNlIHN1cHBvcnQgZ290IGluLiBXaWxsIGZpeCB1
cCBmb3IgdjIuCgoKPj4KPj4+ICvCoMKgwqAgcmN1X3JlYWRfdW5sb2NrKCk7Cj4+PiArwqDCoMKg
IHJldHVybiBmb3VuZDsKPj4+ICt9Cj4+PiArCj4+PiBzdGF0aWMgdm9pZAo+Pj4gdmhvc3RfdHJh
bnNwb3J0X2RvX3NlbmRfcGt0KHN0cnVjdCB2aG9zdF92c29jayAqdnNvY2ssCj4+PiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEpCj4+PiBA
QCAtNDI0LDYgKzQzNCw3IEBAIHN0YXRpYyBzdHJ1Y3QgdmlydGlvX3RyYW5zcG9ydCB2aG9zdF90
cmFuc3BvcnQgPSB7Cj4+PiDCoMKgwqDCoMKgwqDCoCAubW9kdWxlwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgID0gVEhJU19NT0RVTEUsCj4+Pgo+Pj4gwqDCoMKgwqDCoMKgwqAg
LmdldF9sb2NhbF9jaWTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gdmhvc3RfdHJhbnNwb3J0X2dl
dF9sb2NhbF9jaWQsCj4+PiArwqDCoMKgwqDCoMKgwqAgLmhhc19jaWTCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgID0gdmhvc3RfdHJhbnNwb3J0X2hhc19jaWQsCj4+Pgo+Pj4gwqDC
oMKgwqDCoMKgwqAgLmluaXTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ID0gdmlydGlvX3RyYW5zcG9ydF9kb19zb2NrZXRfaW5pdCwKPj4+IMKgwqDCoMKgwqDCoMKgIC5k
ZXN0cnVjdMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gdmlydGlvX3RyYW5zcG9y
dF9kZXN0cnVjdCwKPj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9hZl92c29jay5oIGIvaW5j
bHVkZS9uZXQvYWZfdnNvY2suaAo+Pj4gaW5kZXggNTMzZDhlNzVmN2JiLi40Y2RjYjcyZjk3NjUg
MTAwNjQ0Cj4+PiAtLS0gYS9pbmNsdWRlL25ldC9hZl92c29jay5oCj4+PiArKysgYi9pbmNsdWRl
L25ldC9hZl92c29jay5oCj4+PiBAQCAtMTc5LDYgKzE3OSw5IEBAIHN0cnVjdCB2c29ja190cmFu
c3BvcnQgewo+Pj4gwqDCoMKgwqAvKiBBZGRyZXNzaW5nLiAqLwo+Pj4gwqDCoMKgwqB1MzIgKCpn
ZXRfbG9jYWxfY2lkKSh2b2lkKTsKPj4+Cj4+PiArwqDCoMKgIC8qIENoZWNrIGlmIHRoaXMgdHJh
bnNwb3J0IHNlcnZlcyBhIHNwZWNpZmljIHJlbW90ZSBDSUQuICovCj4+PiArwqDCoMKgIGJvb2wg
KCpoYXNfY2lkKSh1MzIgY2lkKTsKPj4KPj4gV2hhdCBhYm91dCAiaGFzX3JlbW90ZV9jaWQiID8K
Pj4KPj4+ICsKPj4+IMKgwqDCoMKgLyogUmVhZCBhIHNpbmdsZSBza2IgKi8KPj4+IMKgwqDCoMKg
aW50ICgqcmVhZF9za2IpKHN0cnVjdCB2c29ja19zb2NrICosIHNrYl9yZWFkX2FjdG9yX3QpOwo+
Pj4KPj4+IGRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zz
b2NrL2FmX3Zzb2NrLmMKPj4+IGluZGV4IDJmN2Q5NGQ2ODJjYi4uOGIzNGIyNjRiMjQ2IDEwMDY0
NAo+Pj4gLS0tIGEvbmV0L3Ztd192c29jay9hZl92c29jay5jCj4+PiArKysgYi9uZXQvdm13X3Zz
b2NrL2FmX3Zzb2NrLmMKPj4+IEBAIC01ODQsNiArNTg0LDkgQEAgaW50IHZzb2NrX2Fzc2lnbl90
cmFuc3BvcnQoc3RydWN0IHZzb2NrX3NvY2sgCj4+PiAqdnNrLCBzdHJ1Y3QgdnNvY2tfc29jayAq
cHNrKQo+Pj4gwqDCoMKgwqDCoMKgwqAgZWxzZSBpZiAocmVtb3RlX2NpZCA8PSBWTUFERFJfQ0lE
X0hPU1QgfHwgIXRyYW5zcG9ydF9oMmcgfHwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAo
cmVtb3RlX2ZsYWdzICYgVk1BRERSX0ZMQUdfVE9fSE9TVCkpCj4+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG5ld190cmFuc3BvcnQgPSB0cmFuc3BvcnRfZzJoOwo+Pj4gK8KgwqDCoMKgwqDCoMKg
IGVsc2UgaWYgKHRyYW5zcG9ydF9oMmctPmhhc19jaWQgJiYKPj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgIXRyYW5zcG9ydF9oMmctPmhhc19jaWQocmVtb3RlX2NpZCkpCj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBuZXdfdHJhbnNwb3J0ID0gdHJhbnNwb3J0X2cyaDsKPj4KPj4gV2Ug
c2hvdWxkIHVwZGF0ZSB0aGUgY29tbWVudCBvbiB0b3Agb2YgdGhpcyBmdWN0aW9uLCBhbmQgbWF5
YmUgYWxzbyAKPj4gdHJ5IHRvIHN1cHBvcnQgdGhlIG90aGVyIEgyRyB0cmFuc3BvcnQgKGkuZS4g
Vk1DSSkuCj4+Cj4+IEBCcnlhbiBAVmlzaG51IGNhbiB0aGUgbmV3IGhhc19jaWQoKS9oYXNfcmVt
b3RlX2NpZCgpIGJlIHN1cHBvcnRlZCBieSAKPj4gVk1DSSB0b28/Cj4KPiBPb3BzLCBJIGZvcmdv
dCB0byBDQyB0aGVtLCBub3cgdGhleSBzaG91bGQgYmUgaW4gY29weS4KCgpBY2suIEkgY2FuIGFs
c28gdGFrZSBhIHF1aWNrIGxvb2sgaWYgaXQncyB0cml2aWFsIHRvIGFkZC4KCgpBbGV4CgoKCgoK
QW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJIClRhbWFy
YS1EYW56LVN0ci4gMTMKMTAyNDMgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0b2Yg
SGVsbG1pcywgQW5kcmVhcyBTdGllZ2VyCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJs
b3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUg
NTM4IDU5Nwo=


