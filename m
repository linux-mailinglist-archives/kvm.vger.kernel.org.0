Return-Path: <kvm+bounces-72701-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0E7dMAZkqGmduAAAu9opvQ
	(envelope-from <kvm+bounces-72701-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:55:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72406204B04
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:55:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15140305E9DF
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC1B2DCC13;
	Wed,  4 Mar 2026 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="SUcVizHl"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8975372B28;
	Wed,  4 Mar 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.197.217.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772643058; cv=none; b=qZjAJY8A6Ltnwzp2mhVIgMw/fQNkDC82HTYExqU66Wf5GcQwQMcX+B/pKo+BOzCd/8lUeD+y7W8gjdJd+DQVhossLJFUOPTfFgeO0z5v3nb7dku+4tqcyZ+NR9bfjC7AUIz9D+ObUJZ9hl1ar9mDL7HotcLjAFjoy0Cy1a8m2qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772643058; c=relaxed/simple;
	bh=TSJEzLisChRwIKbS4tNTrQ3lRrAttafPT50LExE7m2I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ui5FUAksPBvxoz6Oi/LTs07FXhRQsj0nIx9KAnyp0ZtPE7GK1HfumKBVOgLisdK3cCPTaCcCES79Y0qr3r4BFN1A8aH0ME/W04EjcMyci80xw95nVEMHbrAo/6AAofMFVIy6LIAe26hWedeXmz+wizNQVKmyfDopEfM3bLDqZ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=SUcVizHl; arc=none smtp.client-ip=18.197.217.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1772643056; x=1804179056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TSJEzLisChRwIKbS4tNTrQ3lRrAttafPT50LExE7m2I=;
  b=SUcVizHlFfCUKYUexf36/Y9Wvn9AW6ZLEZWU283DZqwuwSQkilw4In0u
   0FJtQabKVndOE0RFtP/9TyON1306Qx7yoFpkzIxV6GGeDeXv/yh5Baxly
   vA0f5eMwaoxT0joUXk0xRxQmTCYDKCmNLC9T6Ky4bYfuPJv9kPk4z0ZuH
   EoDyotncUyh/jp3Z6NGVjuHIEebGln5QShhU2uyUqmNdPEWLvPRUyNmOW
   3XcewUgw5AIciNCmct913UiqKle80suh5nItJhpGeYrQaSWZhqZoVp99I
   yBTijLP8FWl3fHylGPEzs0ie+h4OsOnC2c0ptxby2X01tQcU/m4UNRMJP
   Q==;
X-CSE-ConnectionGUID: xHqRYF9pR42yiWvNAbl2Vg==
X-CSE-MsgGUID: 08s3AjMGRtuBrNR4iOuN8A==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="10326686"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 16:50:52 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:27252]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.35.199:2525] with esmtp (Farcaster)
 id 2fc45bde-6d52-4055-b37a-7f01721fad01; Wed, 4 Mar 2026 16:50:52 +0000 (UTC)
X-Farcaster-Flow-ID: 2fc45bde-6d52-4055-b37a-7f01721fad01
Received: from EX19D006EUC001.ant.amazon.com (10.252.51.203) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 16:50:51 +0000
Received: from dev-dsk-dssauerw-1b-2c5f429c.eu-west-1.amazon.com
 (10.13.238.31) by EX19D006EUC001.ant.amazon.com (10.252.51.203) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 4 Mar 2026
 16:50:49 +0000
From: David Sauerwein <dssauerw@amazon.de>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, David Woodhouse
	<dwmw@amazon.co.uk>, <nh-open-source@amazon.com>, David Sauerwein
	<dssauerw@amazon.de>, =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?=
	<jschoenh@amazon.de>
Subject: [PATCH] x86: kvm: Initialize static calls before SMP boot
Date: Wed, 4 Mar 2026 16:50:12 +0000
Message-ID: <20260304165012.13660-1-dssauerw@amazon.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D006EUC001.ant.amazon.com (10.252.51.203)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 72406204B04
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.de,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.de:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72701-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amazon.de:dkim,amazon.de:email,amazon.de:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amazon.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dssauerw@amazon.de,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

VXBkYXRpbmcgc3RhdGljIGNhbGxzIGlzIGV4cGVuc2l2ZSBvbiB3aWRlIFNNUCBzeXN0ZW1zIGJl
Y2F1c2UgYWxsCm9ubGluZSBDUFVzIG5lZWQgdG8gYWN0IGluIGEgY29vcmRpbmF0ZWQgbWFubmVy
IGZvciBjb2RlIHBhdGNoaW5nIHRvCndvcmsgYXMgZXhwZWN0ZWQuCgpTdGF0aWMgYXJlIGluaXRp
YWxpemVkIG9ubHkgYWZ0ZXIgU01QIGJvb3QsIHdoZXJlIHRoZSBjb2RlIHBhdGNoaW5nCm92ZXJo
ZWFkIGlzIG5vdGljZWFibGUuIFByZS1pbml0aWFsaXplIHRoZSBtYWpvcml0eSBvZiB0aGVzZSBz
dGF0aWMKY2FsbHMgYmVmb3JlIFNNUCBib290IHRvIGdldCByaWQgb2YgdGhhdCBvdmVyaGVhZC4K
ClRoZSBwcmUtaW5pdGlhbGl6YXRpb24gbW9zdCBsaWtlbHkgYWxyZWFkeSBzZXRzIHRoZSBjb3Jy
ZWN0IHZhbHVlLiBUbwpzdGlsbCBoYW5kbGUgYW55IHBvdGVudGlhbCBkaWZmZXJlbmNlcywgbWFr
ZSB0aGUgc3RhdGljIGNhbGwKaW5pdGlhbGl6YXRpb24gcmUtZW50cmFudCBzbyB0aGF0IHRoZSBk
aWZmZXJlbmNlcyBhcmUgY29ycmVjdGVkIGR1cmluZwpwb3N0LVNNUC1ib290IGluaXRpYWxpemF0
aW9uLiBWYWx1ZXMgdGhhdCBhcmUgYWxyZWFkeSBzZXQgY29ycmVjdGx5IGFyZQpza2lwcGVkLgoK
VGhpcyBwYXRjaCB3YXMgdGVzdGVkIG9uIGEgNnRoIEdlbiBJbnRlbCBYZW9uIFBsYXRpbnVtIDgz
NzVDIENQVSB3aXRoCjEyOCBTTVQgY29yZXMuIFdoZW4gY29tcGFyaW5nIGJlZm9yZSBhbmQgYWZ0
ZXIgd2Ugc2VlIHRoYXQgODUlIGxlc3MgdGltZQppcyBzcGVudCBpbiBrdm1fb3BzX3VwZGF0ZSAo
MjkuNW1zIC0+IDQuMm1zKS4KCkNvLWRldmVsb3BlZC1ieTogSmFuIEguIFNjaMO2bmhlcnIgPGpz
Y2hvZW5oQGFtYXpvbi5kZT4KU2lnbmVkLW9mZi1ieTogSmFuIEguIFNjaMO2bmhlcnIgPGpzY2hv
ZW5oQGFtYXpvbi5kZT4KU2lnbmVkLW9mZi1ieTogRGF2aWQgU2F1ZXJ3ZWluIDxkc3NhdWVyd0Bh
bWF6b24uZGU+Ci0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCB8ICAxICsKIGFy
Y2gveDg2L2t2bS9zdm0vc3ZtLmMgICAgICAgICAgfCAxMSArKysrKysrKysrKwogYXJjaC94ODYv
a3ZtL3ZteC92bXguYyAgICAgICAgICB8IDE4ICsrKysrKysrKysrKysrKysrKwogYXJjaC94ODYv
a3ZtL3g4Ni5jICAgICAgICAgICAgICB8IDE5ICsrKysrKysrKysrKysrKysrKy0KIGtlcm5lbC9l
dmVudHMvY29yZS5jICAgICAgICAgICAgfCAgNiArKysrKy0KIDUgZmlsZXMgY2hhbmdlZCwgNTMg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAppbmRl
eCA0ODU5OGQwMTdkNmYuLjE4MDcyZDdiZWQzNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCkBA
IC0yMDAwLDYgKzIwMDAsNyBAQCBleHRlcm4gc3RydWN0IGt2bV94ODZfb3BzIGt2bV94ODZfb3Bz
OwogI2RlZmluZSBLVk1fWDg2X09QX09QVElPTkFMX1JFVDAgS1ZNX1g4Nl9PUAogI2luY2x1ZGUg
PGFzbS9rdm0teDg2LW9wcy5oPgogCitpbnQga3ZtX3g4Nl92ZW5kb3JfaW5pdF9lYXJseShzdHJ1
Y3Qga3ZtX3g4Nl9pbml0X29wcyAqb3BzKTsKIGludCBrdm1feDg2X3ZlbmRvcl9pbml0KHN0cnVj
dCBrdm1feDg2X2luaXRfb3BzICpvcHMpOwogdm9pZCBrdm1feDg2X3ZlbmRvcl9leGl0KHZvaWQp
OwogCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2
bS9zdm0uYwppbmRleCA5ZDI5YjJlN2U4NTUuLmRlN2FhNGQxZjBlNiAxMDA2NDQKLS0tIGEvYXJj
aC94ODYva3ZtL3N2bS9zdm0uYworKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jCkBAIC01NDUy
LDYgKzU0NTIsMTcgQEAgc3RhdGljIHZvaWQgX19zdm1fZXhpdCh2b2lkKQogCWt2bV94ODZfdmVu
ZG9yX2V4aXQoKTsKIH0KIAorI2lmbmRlZiBNT0RVTEUKK3N0YXRpYyBpbnQgX19pbml0IHN2bV9v
cHNfZWFybHlfaW5pdCh2b2lkKQoreworCWlmICgha3ZtX2lzX3N2bV9zdXBwb3J0ZWQoKSkKKwkJ
cmV0dXJuIC1FT1BOT1RTVVBQOworCisJcmV0dXJuIGt2bV94ODZfdmVuZG9yX2luaXRfZWFybHko
JnN2bV9pbml0X29wcyk7Cit9CitlYXJseV9pbml0Y2FsbChzdm1fb3BzX2Vhcmx5X2luaXQpOwor
I2VuZGlmCisKIHN0YXRpYyBpbnQgX19pbml0IHN2bV9pbml0KHZvaWQpCiB7CiAJaW50IHI7CmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXgu
YwppbmRleCA5MWI2ZjJmM2VkYzIuLjU2OTU0NTg1NGUxNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a3ZtL3ZteC92bXguYworKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jCkBAIC04NjE3LDYgKzg2
MTcsOCBAQCBfX2luaXQgaW50IHZteF9oYXJkd2FyZV9zZXR1cCh2b2lkKQogCQl2dF94ODZfb3Bz
LnNldF9odl90aW1lciA9IE5VTEw7CiAJCXZ0X3g4Nl9vcHMuY2FuY2VsX2h2X3RpbWVyID0gTlVM
TDsKIAl9CisJV0FSTl9PTihlbmFibGVfcHJlZW1wdGlvbl90aW1lciAmJiB2dF94ODZfb3BzLnNl
dF9odl90aW1lciA9PSBOVUxMKTsKKwlXQVJOX09OKGVuYWJsZV9wcmVlbXB0aW9uX3RpbWVyICYm
IHZ0X3g4Nl9vcHMuY2FuY2VsX2h2X3RpbWVyID09IE5VTEwpOwogCiAJa3ZtX2NhcHMuc3VwcG9y
dGVkX21jZV9jYXAgfD0gTUNHX0xNQ0VfUDsKIAlrdm1fY2Fwcy5zdXBwb3J0ZWRfbWNlX2NhcCB8
PSBNQ0dfQ01DSV9QOwpAQCAtODY5OCw2ICs4NzAwLDIyIEBAIHZvaWQgdm14X2V4aXQodm9pZCkK
IAlrdm1feDg2X3ZlbmRvcl9leGl0KCk7CiB9CiAKKyNpZm5kZWYgTU9EVUxFCitzdGF0aWMgaW50
IF9faW5pdCB2bXhfb3BzX2Vhcmx5X2luaXQodm9pZCkKK3sKKwlpZiAoIWt2bV9pc192bXhfc3Vw
cG9ydGVkKCkpCisJCXJldHVybiAtRU9QTk9UU1VQUDsKKworCWlmICghZW5hYmxlX3ByZWVtcHRp
b25fdGltZXIpIHsKKwkJdnRfeDg2X29wcy5zZXRfaHZfdGltZXIgPSBOVUxMOworCQl2dF94ODZf
b3BzLmNhbmNlbF9odl90aW1lciA9IE5VTEw7CisJfQorCisJcmV0dXJuIGt2bV94ODZfdmVuZG9y
X2luaXRfZWFybHkoJnZ0X2luaXRfb3BzKTsKK30KK2Vhcmx5X2luaXRjYWxsKHZteF9vcHNfZWFy
bHlfaW5pdCk7CisjZW5kaWYKKwogaW50IF9faW5pdCB2bXhfaW5pdCh2b2lkKQogewogCWludCBy
LCBjcHU7CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2
LmMKaW5kZXggYzljMmFhNmY0NzA1Li5kYmQwMGEyNjUzOGYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L2t2bS94ODYuYworKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMKQEAgLTk5NzEsNiArOTk3MSwyMiBA
QCBzdGF0aWMgdm9pZCBrdm1feDg2X2NoZWNrX2NwdV9jb21wYXQodm9pZCAqcmV0KQogCSooaW50
ICopcmV0ID0ga3ZtX3g4Nl9jaGVja19wcm9jZXNzb3JfY29tcGF0aWJpbGl0eSgpOwogfQogCitp
bnQga3ZtX3g4Nl92ZW5kb3JfaW5pdF9lYXJseShzdHJ1Y3Qga3ZtX3g4Nl9pbml0X29wcyAqb3Bz
KQoreworCWd1YXJkKG11dGV4KSgmdmVuZG9yX21vZHVsZV9sb2NrKTsKKworCWlmIChrdm1feDg2
X29wcy5lbmFibGVfdmlydHVhbGl6YXRpb25fY3B1KSB7CisJCXByX2VycigiYWxyZWFkeSBsb2Fk
ZWQgdmVuZG9yIG1vZHVsZSAnJXMnXG4iLCBrdm1feDg2X29wcy5uYW1lKTsKKwkJcmV0dXJuIC1F
RVhJU1Q7CisJfQorCisJa3ZtX29wc191cGRhdGUob3BzKTsKKwlrdm1fcmVnaXN0ZXJfcGVyZl9j
YWxsYmFja3Mob3BzLT5oYW5kbGVfaW50ZWxfcHRfaW50cik7CisKKwlyZXR1cm4gMDsKK30KK0VY
UE9SVF9TWU1CT0xfRk9SX0tWTV9JTlRFUk5BTChrdm1feDg2X3ZlbmRvcl9pbml0X2Vhcmx5KTsK
KwogaW50IGt2bV94ODZfdmVuZG9yX2luaXQoc3RydWN0IGt2bV94ODZfaW5pdF9vcHMgKm9wcykK
IHsKIAl1NjQgaG9zdF9wYXQ7CkBAIC05OTc4LDcgKzk5OTQsOCBAQCBpbnQga3ZtX3g4Nl92ZW5k
b3JfaW5pdChzdHJ1Y3Qga3ZtX3g4Nl9pbml0X29wcyAqb3BzKQogCiAJZ3VhcmQobXV0ZXgpKCZ2
ZW5kb3JfbW9kdWxlX2xvY2spOwogCi0JaWYgKGt2bV94ODZfb3BzLmVuYWJsZV92aXJ0dWFsaXph
dGlvbl9jcHUpIHsKKwlpZiAoa3ZtX3g4Nl9vcHMuZW5hYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSAm
JgorCSAgICBrdm1feDg2X29wcy5lbmFibGVfdmlydHVhbGl6YXRpb25fY3B1ICE9IG9wcy0+cnVu
dGltZV9vcHMtPmVuYWJsZV92aXJ0dWFsaXphdGlvbl9jcHUpIHsKIAkJcHJfZXJyKCJhbHJlYWR5
IGxvYWRlZCB2ZW5kb3IgbW9kdWxlICclcydcbiIsIGt2bV94ODZfb3BzLm5hbWUpOwogCQlyZXR1
cm4gLUVFWElTVDsKIAl9CmRpZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRzL2NvcmUuYyBiL2tlcm5l
bC9ldmVudHMvY29yZS5jCmluZGV4IDJjMzVhY2MyNzIyYi4uNzMxOTc1NzkxODk1IDEwMDY0NAot
LS0gYS9rZXJuZWwvZXZlbnRzL2NvcmUuYworKysgYi9rZXJuZWwvZXZlbnRzL2NvcmUuYwpAQCAt
NzM3OCw3ICs3Mzc4LDggQEAgREVGSU5FX1NUQVRJQ19DQUxMX1JFVDAoX19wZXJmX2d1ZXN0X2hh
bmRsZV9pbnRlbF9wdF9pbnRyLCAqcGVyZl9ndWVzdF9jYnMtPmhhbmQKIAogdm9pZCBwZXJmX3Jl
Z2lzdGVyX2d1ZXN0X2luZm9fY2FsbGJhY2tzKHN0cnVjdCBwZXJmX2d1ZXN0X2luZm9fY2FsbGJh
Y2tzICpjYnMpCiB7Ci0JaWYgKFdBUk5fT05fT05DRShyY3VfYWNjZXNzX3BvaW50ZXIocGVyZl9n
dWVzdF9jYnMpKSkKKwlpZiAoV0FSTl9PTl9PTkNFKHJjdV9hY2Nlc3NfcG9pbnRlcihwZXJmX2d1
ZXN0X2NicykgJiYKKwkJcmN1X2FjY2Vzc19wb2ludGVyKHBlcmZfZ3Vlc3RfY2JzKSAhPSBjYnMp
KQogCQlyZXR1cm47CiAKIAlyY3VfYXNzaWduX3BvaW50ZXIocGVyZl9ndWVzdF9jYnMsIGNicyk7
CkBAIC03Mzg5LDYgKzczOTAsOSBAQCB2b2lkIHBlcmZfcmVnaXN0ZXJfZ3Vlc3RfaW5mb19jYWxs
YmFja3Moc3RydWN0IHBlcmZfZ3Vlc3RfaW5mb19jYWxsYmFja3MgKmNicykKIAlpZiAoY2JzLT5o
YW5kbGVfaW50ZWxfcHRfaW50cikKIAkJc3RhdGljX2NhbGxfdXBkYXRlKF9fcGVyZl9ndWVzdF9o
YW5kbGVfaW50ZWxfcHRfaW50ciwKIAkJCQkgICBjYnMtPmhhbmRsZV9pbnRlbF9wdF9pbnRyKTsK
KwllbHNlCisJCXN0YXRpY19jYWxsX3VwZGF0ZShfX3BlcmZfZ3Vlc3RfaGFuZGxlX2ludGVsX3B0
X2ludHIsCisJCQkJICAgKHZvaWQgKilfX3N0YXRpY19jYWxsX3JldHVybjApOwogfQogRVhQT1JU
X1NZTUJPTF9HUEwocGVyZl9yZWdpc3Rlcl9ndWVzdF9pbmZvX2NhbGxiYWNrcyk7CiAKLS0gCjIu
NDcuMwoKCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBH
bWJIClRhbWFyYS1EYW56LVN0ci4gMTMKMTAyNDMgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzog
Q2hyaXN0b2YgSGVsbG1pcywgQW5kcmVhcyBTdGllZ2VyCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJp
Y2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJsaW4KVXN0LUlE
OiBERSAzNjUgNTM4IDU5Nwo=


