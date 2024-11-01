Return-Path: <kvm+bounces-30296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C854A9B8DCF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 10:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B11C1F232F8
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D38158DC4;
	Fri,  1 Nov 2024 09:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VEqteZ1n"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A023FF1;
	Fri,  1 Nov 2024 09:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453207; cv=none; b=Ddmss3pmIHEi2YsOBHlxC6bcVqAegpp0tjmNp87OQkvK1itImtL0u0rvrO+oRbug/AsWfVoQYrgKyyx6oSikAt2SpHCqbNCgEzSz7ksxcXa69p+DLZmvsZVbNauR4oQcd2WgN+hWpmhqGhwcMsLxsfMPdX5DU3zMJKd7NHNZeMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453207; c=relaxed/simple;
	bh=foNT9LhMxcw9h0sgdEYN/DEg/68Idl66SQOZykSzYdY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JMrT//oWwNDpiaJnsMl3oeKg+1AWBzcvp+KwoMf7tZ8oDCh4rgGHNS0L47R9o5a0fhK4feUAi7t41J9zCrP9RdoKsMNQDV0PwW/dI0VfrdKw9hQBlcS2TU0br9cr6ffvcjCXzVpS5BHdJjMqAhWta4uwM0xTY2XWrLBkxQ1b7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VEqteZ1n; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=foNT9LhMxcw9h0sgdEYN/DEg/68Idl66SQOZykSzYdY=; b=VEqteZ1nroa64zIiP0nWJK/gEv
	/ILiwlDALMATwX1jgcMw2wjCho/f0L3Bm/FQYW/Hv77I9jJUgFPHVRtIBzkSPqv97Sr9YEoatezNs
	ZyZv56DnRg4SnEpSR/zcn/zJxmgXwglWj/HuMZAHtdH6au0axacaWbEx9r6JnG6z0+Dm27+xrJyBv
	EcGd+ntjyGo0QAlkK7m5iXBDQQoq1Zgd+fJ9VdOH9kRMOSgT0xZkDbeCBW3E3RnNnvXtOxxgPkCPk
	D4DkcD5BKhOMp17wLNPNv8Aag+2M1Dx92AIYOzdQThhZSOxVN2wIRxgLMrQeg5zTlNXshSIbvdCjj
	yJtgVhwA==;
Received: from [212.102.57.71] (helo=[172.31.28.190])
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t6nvJ-0000000Fhjf-3fug;
	Fri, 01 Nov 2024 09:26:30 +0000
Message-ID: <5c9714690d9395533373df0c366e9019f45a6689.camel@infradead.org>
Subject: Re: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and
 FLUSH_RAP_ON_VMRUN
From: Amit Shah <amit@infradead.org>
To: kernel test robot <lkp@intel.com>, amit.shah@amd.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	linux-doc@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
 peterz@infradead.org, 	jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, 	mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com, 
	sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com, 
	david.kaplan@amd.com
Date: Fri, 01 Nov 2024 10:26:28 +0100
In-Reply-To: <202411011119.l3yRJpht-lkp@intel.com>
References: <20241031153925.36216-3-amit@kernel.org>
	 <202411011119.l3yRJpht-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.54.1 (3.54.1-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gRnJpLCAyMDI0LTExLTAxIGF0IDEyOjE0ICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToKPiBIaSBBbWl0LAo+IAo+IGtlcm5lbCB0ZXN0IHJvYm90IG5vdGljZWQgdGhlIGZvbGxvd2lu
ZyBidWlsZCB3YXJuaW5nczoKPiAKPiBbYXV0byBidWlsZCB0ZXN0IFdBUk5JTkcgb24ga3ZtL3F1
ZXVlXQo+IFthbHNvIGJ1aWxkIHRlc3QgV0FSTklORyBvbiBtc3Qtdmhvc3QvbGludXgtbmV4dCB0
aXAvbWFzdGVyCj4gdGlwL3g4Ni9jb3JlIGxpbnVzL21hc3RlciB2Ni4xMi1yYzUgbmV4dC0yMDI0
MTAzMV0KPiBbY2Fubm90IGFwcGx5IHRvIGt2bS9saW51eC1uZXh0IHRpcC9hdXRvLWxhdGVzdF0K
PiBbSWYgeW91ciBwYXRjaCBpcyBhcHBsaWVkIHRvIHRoZSB3cm9uZyBnaXQgdHJlZSwga2luZGx5
IGRyb3AgdXMgYQo+IG5vdGUuCj4gQW5kIHdoZW4gc3VibWl0dGluZyBwYXRjaCwgd2Ugc3VnZ2Vz
dCB0byB1c2UgJy0tYmFzZScgYXMgZG9jdW1lbnRlZAo+IGluCj4gaHR0cHM6Ly9naXQtc2NtLmNv
bS9kb2NzL2dpdC1mb3JtYXQtcGF0Y2gjX2Jhc2VfdHJlZV9pbmZvcm1hdGlvbl0KPiAKPiB1cmw6
wqDCoMKgCj4gaHR0cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3AvbGludXgvY29tbWl0cy9B
bWl0LVNoYWgveDg2LWNwdS1idWdzLWFkZC1zdXBwb3J0LWZvci1BTUQtRVJBUFMtZmVhdHVyZS8y
MDI0MTAzMS0yMzQzMzIKPiBiYXNlOsKgwqAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L3ZpcnQva3ZtL2t2bS5naXTCoHF1ZXVlCj4gcGF0Y2ggbGluazrCoMKgwqAKPiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9yLzIwMjQxMDMxMTUzOTI1LjM2MjE2LTMtYW1pdCU0MGtlcm5lbC5vcmcK
PiBwYXRjaCBzdWJqZWN0OiBbUEFUQ0ggMi8yXSB4ODY6IGt2bTogc3ZtOiBhZGQgc3VwcG9ydCBm
b3IgRVJBUFMgYW5kCj4gRkxVU0hfUkFQX09OX1ZNUlVOCj4gY29uZmlnOiB4ODZfNjQta2V4ZWMK
PiAoaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9hcmNoaXZlLzIwMjQxMTAxLzIwMjQx
MTAxMTExOS5sM3lSSnAKPiBodC1sa3BAaW50ZWwuY29tL2NvbmZpZykKPiBjb21waWxlcjogY2xh
bmcgdmVyc2lvbiAxOS4xLjMKPiAoaHR0cHM6Ly9naXRodWIuY29tL2xsdm0vbGx2bS1wcm9qZWN0
wqBhYjUxZWNjZjg4ZjUzMjFlN2M2MDU5MWM1NTQ2YjI1Cj4gNGI2YWZhYjk5KQo+IHJlcHJvZHVj
ZSAodGhpcyBpcyBhIFc9MSBidWlsZCk6Cj4gKGh0dHBzOi8vZG93bmxvYWQuMDEub3JnLzBkYXkt
Y2kvYXJjaGl2ZS8yMDI0MTEwMS8yMDI0MTEwMTExMTkubDN5UkpwCj4gaHQtbGtwQGludGVsLmNv
bS9yZXByb2R1Y2UpCj4gCj4gSWYgeW91IGZpeCB0aGUgaXNzdWUgaW4gYSBzZXBhcmF0ZSBwYXRj
aC9jb21taXQgKGkuZS4gbm90IGp1c3QgYSBuZXcKPiB2ZXJzaW9uIG9mCj4gdGhlIHNhbWUgcGF0
Y2gvY29tbWl0KSwga2luZGx5IGFkZCBmb2xsb3dpbmcgdGFncwo+ID4gUmVwb3J0ZWQtYnk6IGtl
cm5lbCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPgo+ID4gQ2xvc2VzOgo+ID4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDI0MTEwMTExMTkubDN5UkpwaHQtbGtwQGlu
dGVsLmNvbS8KPiAKPiBBbGwgd2FybmluZ3MgKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KToKPiAK
PiDCoMKgIEluIGZpbGUgaW5jbHVkZWQgZnJvbSBhcmNoL3g4Ni9rdm0vY3B1aWQuYzoxMzoKPiDC
oMKgIEluIGZpbGUgaW5jbHVkZWQgZnJvbSBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0Lmg6MTY6Cj4g
wqDCoCBJbiBmaWxlIGluY2x1ZGVkIGZyb20gaW5jbHVkZS9saW51eC9tbS5oOjIyMTM6Cj4gwqDC
oCBpbmNsdWRlL2xpbnV4L3Ztc3RhdC5oOjUwNDo0Mzogd2FybmluZzogYXJpdGhtZXRpYyBiZXR3
ZWVuCj4gZGlmZmVyZW50IGVudW1lcmF0aW9uIHR5cGVzICgnZW51bSB6b25lX3N0YXRfaXRlbScg
YW5kICdlbnVtCj4gbnVtYV9zdGF0X2l0ZW0nKSBbLVdlbnVtLWVudW0tY29udmVyc2lvbl0KPiDC
oMKgwqDCoCA1MDQgfMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHZtc3RhdF90ZXh0W05SX1ZNX1pP
TkVfU1RBVF9JVEVNUyArCj4gwqDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH5+fn5+fn5+fn5+fn5+fn5+fn5+fiBe
Cj4gwqDCoMKgwqAgNTA1IHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaXRlbV07Cj4gwqDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH5+fn4KPiDCoMKgIGluY2x1
ZGUvbGludXgvdm1zdGF0Lmg6NTExOjQzOiB3YXJuaW5nOiBhcml0aG1ldGljIGJldHdlZW4KPiBk
aWZmZXJlbnQgZW51bWVyYXRpb24gdHlwZXMgKCdlbnVtIHpvbmVfc3RhdF9pdGVtJyBhbmQgJ2Vu
dW0KPiBudW1hX3N0YXRfaXRlbScpIFstV2VudW0tZW51bS1jb252ZXJzaW9uXQo+IMKgwqDCoMKg
IDUxMSB8wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gdm1zdGF0X3RleHRbTlJfVk1fWk9ORV9TVEFU
X0lURU1TICsKPiDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfn5+fn5+fn5+fn5+fn5+fn5+fn5+IF4KPiDCoMKg
wqDCoCA1MTIgfMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBOUl9WTV9OVU1BX0VWRU5UX0lURU1TICsKPiDCoMKgwqDCoMKgwqDCoMKgIHzCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfn5+fn5+
fn5+fn5+fn5+fn5+fn5+fgo+IMKgwqAgaW5jbHVkZS9saW51eC92bXN0YXQuaDo1MTg6MzY6IHdh
cm5pbmc6IGFyaXRobWV0aWMgYmV0d2Vlbgo+IGRpZmZlcmVudCBlbnVtZXJhdGlvbiB0eXBlcyAo
J2VudW0gbm9kZV9zdGF0X2l0ZW0nIGFuZCAnZW51bQo+IGxydV9saXN0JykgWy1XZW51bS1lbnVt
LWNvbnZlcnNpb25dCj4gwqDCoMKgwqAgNTE4IHzCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBub2Rl
X3N0YXRfbmFtZShOUl9MUlVfQkFTRSArIGxydSkgKyAzOyAvLwo+IHNraXAgIm5yXyIKPiDCoMKg
wqDCoMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfn5+fn5+fn5+fn4gXiB+fn4KPiDCoMKgIGluY2x1ZGUvbGludXgv
dm1zdGF0Lmg6NTI0OjQzOiB3YXJuaW5nOiBhcml0aG1ldGljIGJldHdlZW4KPiBkaWZmZXJlbnQg
ZW51bWVyYXRpb24gdHlwZXMgKCdlbnVtIHpvbmVfc3RhdF9pdGVtJyBhbmQgJ2VudW0KPiBudW1h
X3N0YXRfaXRlbScpIFstV2VudW0tZW51bS1jb252ZXJzaW9uXQo+IMKgwqDCoMKgIDUyNCB8wqDC
oMKgwqDCoMKgwqDCoCByZXR1cm4gdm1zdGF0X3RleHRbTlJfVk1fWk9ORV9TVEFUX0lURU1TICsK
PiDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfn5+fn5+fn5+fn5+fn5+fn5+fn5+IF4KPiDCoMKgwqDCoCA1MjUg
fMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBO
Ul9WTV9OVU1BX0VWRU5UX0lURU1TICsKPiDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfn5+fn5+fn5+fn5+fn5+
fn5+fn5+fgo+ID4gPiBhcmNoL3g4Ni9rdm0vY3B1aWQuYzoxMzYyOjM6IHdhcm5pbmc6IGxhYmVs
IGZvbGxvd2VkIGJ5IGEKPiA+ID4gZGVjbGFyYXRpb24gaXMgYSBDMjMgZXh0ZW5zaW9uIFstV2My
My1leHRlbnNpb25zXQo+IMKgwqDCoCAxMzYyIHzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB1bnNpZ25lZCBpbnQgZWJ4X21hc2sgPSAwOwo+IMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF4KPiDCoMKgIDUgd2FybmluZ3MgZ2VuZXJhdGVk
LgoKWy4uLl0KCj4gwqAgMTM2MQkJY2FzZSAweDgwMDAwMDIxOgo+ID4gMTM2MgkJCXVuc2lnbmVk
IGludCBlYnhfbWFzayA9IDA7Cj4gwqAgMTM2MwkKPiDCoCAxMzY0CQkJZW50cnktPmVjeCA9IGVu
dHJ5LT5lZHggPSAwOwo+IMKgIDEzNjUJCQljcHVpZF9lbnRyeV9vdmVycmlkZShlbnRyeSwKPiBD
UFVJRF84MDAwXzAwMjFfRUFYKTsKPiDCoCAxMzY2CQo+IMKgIDEzNjcJCQkvKgo+IMKgIDEzNjgJ
CQkgKiBCaXRzIDIzOjE2IGluIEVCWCBpbmRpY2F0ZSB0aGUgc2l6ZSBvZgo+IHRoZSBSU0IuCj4g
wqAgMTM2OQkJCSAqIEV4cG9zZSB0aGUgdmFsdWUgaW4gdGhlIGhhcmR3YXJlIHRvIHRoZQo+IGd1
ZXN0Lgo+IMKgIDEzNzAJCQkgKi8KPiDCoCAxMzcxCQkJaWYgKGt2bV9jcHVfY2FwX2hhcyhYODZf
RkVBVFVSRV9FUkFQUykpCj4gwqAgMTM3MgkJCQllYnhfbWFzayB8PSBHRU5NQVNLKDIzLCAxNik7
Cj4gwqAgMTM3MwkKPiDCoCAxMzc0CQkJZW50cnktPmVieCAmPSBlYnhfbWFzazsKPiDCoCAxMzc1
CQkJYnJlYWs7CgpSaWdodCAtIEknbGwgYWRkIGJyYWNlcyBhcm91bmQgdGhpcyBjYXNlIHN0YXRl
bWVudC4KCgkJQW1pdAo=


