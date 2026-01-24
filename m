Return-Path: <kvm+bounces-69052-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBmoFTA5dWmUCQEAu9opvQ
	(envelope-from <kvm+bounces-69052-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 22:27:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0A97F0D4
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 22:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B85C300C019
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 21:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A6528314C;
	Sat, 24 Jan 2026 21:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="NGTR6LGu"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505D233723;
	Sat, 24 Jan 2026 21:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769290017; cv=none; b=QgItPtVRFOzSx3ZKWcWjFvqZKsRj5qq7Rta2dzDVo+t8gOsXvlqR9oydyuPsKM8QZKQ2MxpUqPyAmZctW0i93Bl3JLBOf0nfJKqojbXRI5QsOTh8e9fgKOK/JwTcz4kkubNUU5RfchNiwCJJ83bnExt5eKjHKcxA9Bn9HGvPfZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769290017; c=relaxed/simple;
	bh=KhKfOzQAwRIB82NPQ1/iYVH/6XtXC0fC5zpZwYM9CSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ll6JBS4OSwwmL2oPexXeIjmRvSv3niTcHR4NE/1XMVdsehdvmke3uInayCVJrQcVQ0g0Z11piUQE7sb5e9y3iQ83lcgoKpwE9YGxZjkeYchHLaEuyMTiX9lWYE1UTJZN2sOhesKNfAhBq7vubs0qWQsHosMnwsvscTLnj5fl/ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=NGTR6LGu; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1769290015; x=1800826015;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KhKfOzQAwRIB82NPQ1/iYVH/6XtXC0fC5zpZwYM9CSg=;
  b=NGTR6LGuylG9TcFrYhwMd+0/Ir1O/7oEbFUiikh/zwn+Zna7/RDkEVdL
   VA/NVrYnoDlShRdSR9fL2QphRz5OjOX9u8vE8UThv989UQ9xnip6FuDkR
   5J0jSIqdDNh//SzASiUSAyyjdi6sHWKwMd8Q4sYH/1teWGQ5ub0P8zMc2
   ZeoFTvghCI9GTFL9KfN5vCfZbroSIeWrt/npD125cHoiFNQUL4zKw5wjH
   UsWE9VdIInG2BHpdu4WmaWziWIFMVtlluU7ktRc05GhhEfmmHarv1nJ+y
   LRTiuepODIMD1y3lIFxCkmHOB3BZx+BrH7j3C3JkVg4PpP0EiMgN3nA4y
   Q==;
X-CSE-ConnectionGUID: ev2ixXzSTtOTAeZFL/hDKg==
X-CSE-MsgGUID: DOZRryG+T7+TDyz7PtuOkw==
X-IronPort-AV: E=Sophos;i="6.21,251,1763424000"; 
   d="scan'208";a="11413957"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 21:26:53 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:27676]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.22.113:2525] with esmtp (Farcaster)
 id 68df5e67-7a21-4482-abc6-cb6f84042839; Sat, 24 Jan 2026 21:26:53 +0000 (UTC)
X-Farcaster-Flow-ID: 68df5e67-7a21-4482-abc6-cb6f84042839
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Sat, 24 Jan 2026 21:26:52 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Sat, 24 Jan 2026
 21:26:49 +0000
Message-ID: <769f538d-dd42-4d36-a4c5-7e6e48b209f6@amazon.com>
Date: Sat, 24 Jan 2026 22:26:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: hyper-v: Delay firing of expired stimers
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>,
	<x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, <nh-open-source@amazon.com>, <gurugubs@amazon.com>,
	<jalliste@amazon.co.uk>, Michael Kelley <mhklinux@outlook.com>, John Starks
	<jostarks@microsoft.com>
References: <20260115141520.24176-1-graf@amazon.com>
 <aXO8I6xuZyZB7CxV@google.com>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <aXO8I6xuZyZB7CxV@google.com>
X-ClientProxiedBy: EX19D033UWA003.ant.amazon.com (10.13.139.42) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
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
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-69052-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,zytor.com,kernel.org,redhat.com,amazon.com,amazon.co.uk,outlook.com,microsoft.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: BA0A97F0D4
X-Rspamd-Action: no action

Ck9uIDIzLjAxLjI2IDE5OjIxLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOgo+IE9uIFRodSwg
SmFuIDE1LCAyMDI2LCBBbGV4YW5kZXIgR3JhZiB3cm90ZToKPj4gRHVyaW5nIFdpbmRvd3MgU2Vy
dmVyIDIwMjUgaGliZXJuYXRpb24sIEkgaGF2ZSBzZWVuIFdpbmRvd3MnIGNhbGN1bGF0aW9uCj4+
IG9mIGludGVycnVwdCB0YXJnZXQgdGltZSBnZXQgc2tld2VkIG92ZXIgdGhlIGh5cGVydmlzb3Ig
dmlldyBvZiB0aGUgc2FtZS4KPj4gVGhpcyBjYW4gY2F1c2UgV2luZG93cyB0byBlbWl0IHRpbWVy
IGV2ZW50cyBpbiB0aGUgcGFzdCBmb3IgZXZlbnRzIHRoYXQKPj4gZG8gbm90IGZpcmUgeWV0IGFj
Y29yZGluZyB0byB0aGUgcmVhbCB0aW1lIHNvdXJjZS4gVGhpcyB0aGVuIGxlYWRzIHRvCj4+IGlu
dGVycnVwdCBzdG9ybXMgaW4gdGhlIGd1ZXN0IHdoaWNoIHNsb3cgZG93biBleGVjdXRpb24gdG8g
YSBwb2ludCB3aGVyZQo+PiB3YXRjaGRvZ3MgdHJpZ2dlci4gVGhvc2UgbWFuaWZlc3QgYXMgYnVn
Y2hlY2tzIDB4OWYgYW5kIDB4YTAgZHVyaW5nCj4+IGhpYmVybmF0aW9uLCB0eXBpY2FsbHkgaW4g
dGhlIHJlc3VtZSBwYXRoLgo+Pgo+PiBUbyB3b3JrIGFyb3VuZCB0aGlzIHByb2JsZW0sIHdlIGNh
biBkZWxheSB0aW1lcnMgdGhhdCBnZXQgY3JlYXRlZCB3aXRoIGEKPj4gdGFyZ2V0IHRpbWUgaW4g
dGhlIHBhc3QgYnkgYSB0aW55IGJpdCAoMTDCtXMpIHRvIGdpdmUgdGhlIGd1ZXN0IENQVSB0aW1l
Cj4+IHRvIHByb2Nlc3MgcmVhbCB3b3JrIGFuZCBtYWtlIGZvcndhcmQgcHJvZ3Jlc3MsIGhvcGVm
dWxseSByZWNvdmVyaW5nIGl0cwo+PiBpbnRlcnJ1cHQgbG9naWMgaW4gdGhlIHByb2Nlc3MuIFdo
aWxlIHRoaXMgc21hbGwgZGVsYXkgY2FuIG1hcmdpbmFsbHkKPj4gcmVkdWNlIGFjY3VyYWN5IG9m
IGd1ZXN0IHRpbWVycywgMTDCtXMgYXJlIHdpdGhpbiB0aGUgbm9pc2Ugb2YgVk0KPj4gZW50cnkv
ZXhpdCBvdmVyaGVhZCAofjEtMiDCtXMpIHNvIEkgZG8gbm90IGV4cGVjdCB0byBzZWUgcmVhbCB3
b3JsZCBpbXBhY3QuCj4gVGhlcmUgaXMgYSBsb3Qgb2YgaG9wZSBwaWxlZCBpbnRvIHRoaXMuICBB
bmQgKmFsd2F5cyogcGFkZGluZyB0aGUgY291bnQgbWFrZXMgbWUKPiBtb3JlIHRoYW4gYSBiaXQg
dW5jb21mb3J0YWJsZS4gIElmIHRoZSBza2V3IGlzIHJlYWxseSBkdWUgdG8gYSBndWVzdCBidWcg
YW5kIG5vdAo+IHNvbWV0aGluZyBvbiB0aGUgaG9zdCdzIHNpZGUsIGkuZS4gaWYgdGhpcyBpc24n
dCBqdXN0IGEgc3ltcHRvbSBvZiBhIHJlYWwgYnVnIHRoYXQKPiBjYW4gYmUgZml4ZWQgYW5kIHRo
ZSBfb25seV8gb3B0aW9uIGlzIHRvIGNodWNrIGluIGEgd29ya2Fyb3VuZCwgdGhlbiBJIHdvdWxk
Cj4gc3Ryb25nbHkgcHJlZmVyIHRvIGJlIGFzIGNvbnNlcnZhdGl2ZSBhcyBwb3NzaWJsZS4gIEUu
Zy4gaXMgaXQgcG9zc2libGUgdG8KPiBwcmVjaXNlbHkgZGV0ZWN0IHRoaXMgc2NlbmFyaW8gYW5k
IG9ubHkgYWRkIHRoZSBkZWxheSB3aGVuIHRoZSBndWVzdCBhcHBlYXJzIHRvCj4gYmUgc3R1Y2s/
CgoKVGhpcyBwYXRjaCBvbmx5IHBhZHMgd2hlbiBhIHRpbWVyIGlzIGluIHRoZSBwYXN0LCB3aGlj
aCBJIGhhdmUgbm90IHNlZW4gCmhhcHBlbiBtdWNoIG9uIHJlYWwgc3lzdGVtcy4gVXN1YWxseSB5
b3UncmUgdHJ5aW5nIHRvIGNvbmZpZ3VyZSBhIHRpbWVyIApmb3IgdGhlIGZ1dHVyZSA6KS4KClRo
YXQgc2FpZCwgSSBoYXZlIGNvbnRpbnVlZCBkaWdnaW5nIGRlZXBlciBzaW5jZSBJIHBvc3RlZCB0
aGlzIHBhdGNoIGFuZCAKSSdtIHN0aWxsIHRyeWluZyB0byB3cmFwIG15IGhlYWQgYXJvdW5kIHVu
ZGVyIHdoaWNoIGV4YWN0IGNvbmRpdGlvbnMgYW55IApvZiB0aGlzIHJlYWxseSBkb2VzIGhhcHBl
bi4gTGV0J3MgcHV0IHRoaXMgcGF0Y2ggb24gaG9sZCB1bnRpbCBJIGhhdmUgYSAKbW9yZSByZWxp
YWJsZSByZXByb2R1Y2VyLgoKCkFsZXgKCgoKCkFtYXpvbiBXZWIgU2VydmljZXMgRGV2ZWxvcG1l
bnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFuei1TdHIuIDEzCjEwMjQzIEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdG9mIEhlbGxtaXMsIEFuZHJlYXMgU3RpZWdlcgpFaW5n
ZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMjU3NzY0IEIK
U2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1OTcK


