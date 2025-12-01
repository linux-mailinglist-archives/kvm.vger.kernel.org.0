Return-Path: <kvm+bounces-65007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AB2C97D7B
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 15:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC6C14E1CE9
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 14:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3F331AF36;
	Mon,  1 Dec 2025 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ivo2SK6r"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8833531A7F6;
	Mon,  1 Dec 2025 14:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.72.182.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764599094; cv=none; b=X8Q7YmdKPnHnfsPsDY75oTSeGkaM2QfIaFzuKE3mLV1Fntx8kTgqJ4t6uhGqfSsoOuh443xwl9JdIS2jTkHETtobdXgvNIw9h/Yqc9VTUUFNNSza9P7SHRGVVuHSskC1zo5ge7de57EhftHRSsQ13kOzqvPl0qdku2M8ZPMVerw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764599094; c=relaxed/simple;
	bh=V3pCUcV0THf57Rt37Dp9v+liCAg9z5E32iBeAXB5cuo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lNEfEIhGYEiDvMCUmKbc46la8hoJx//ePqF3icGDWwI88cCZWfaKU49R7W9wbwnaQ6z/w6dseWfTYZAzz5Ga6vIZmwShW1njH2xVziIsHE7zuaBqF9kNXnkcQb1YvvQz1+uH5bdatNYZcNRpRj7BLoPiwrm1LlrtqHWCx5k5BTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ivo2SK6r; arc=none smtp.client-ip=3.72.182.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764599092; x=1796135092;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V3pCUcV0THf57Rt37Dp9v+liCAg9z5E32iBeAXB5cuo=;
  b=ivo2SK6rj68MAxi4m6QnqrIq0AM/uYw472Wfh0v9G9xj96a2UWoo05+T
   2+oZNqAqokPwLbTlvCPr8y6f5pE9lWV5O+/KygsztJNheGf9BwZ8VJpkk
   WLeeYCa0I2c71wq9GEE/kl8v4p27sFMYc+QuoklCPfDkoc2KekRZRg8k6
   jKY1mD3RQz4SA6PGcQmGy8m0zausauYi8CDvBZ2k71OkwYEVwWJsJ1uYM
   sE9Zy19pCq/Mvrh2kc/q8nIjS1LHbG3Pl99Q4d/m3AWA7SyeSFrPVQH+C
   IjmiNoTxKJXpT4fs4sWSaNG1PKGmb/DoSWPAGOgU+++mDY1oTSA+K0EtF
   Q==;
X-CSE-ConnectionGUID: X2fZYrEpTIGIAGP39BYxEg==
X-CSE-MsgGUID: LracZSpeS9qxt9IvmtlxPg==
X-IronPort-AV: E=Sophos;i="6.20,240,1758585600"; 
   d="scan'208";a="6063446"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:24:32 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:12457]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.168:2525] with esmtp (Farcaster)
 id b82bc2ab-6722-4032-ab95-79616369f5a6; Mon, 1 Dec 2025 14:24:32 +0000 (UTC)
X-Farcaster-Flow-ID: b82bc2ab-6722-4032-ab95-79616369f5a6
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 14:24:29 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.108) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 14:24:20 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
	<hborghor@amazon.de>, <sieberf@amazon.com>, <nh-open-source@amazon.com>,
	<abusse@amazon.de>, <nsaenz@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Date: Mon, 1 Dec 2025 16:23:57 +0200
Message-ID: <20251201142359.344741-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWA001.ant.amazon.com (10.13.139.124) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogSmFuIEguIFNjaMO2bmhlcnIgPGpzY2hvZW5oQGFtYXpvbi5kZT4KCkl0IGlzIHBvc3Np
YmxlIHRvIGRlZ3JhZGUgaG9zdCBwZXJmb3JtYW5jZSBieSBtYW5pcHVsYXRpbmcgcGVyZm9ybWFu
Y2UKY291bnRlcnMgZnJvbSBhIFZNIGFuZCB0cmlja2luZyB0aGUgaG9zdCBoeXBlcnZpc29yIHRv
IGVuYWJsZSBicmFuY2gKdHJhY2luZy4gV2hlbiB0aGUgZ3Vlc3QgcHJvZ3JhbXMgYSBDUFUgdG8g
dHJhY2sgYnJhbmNoIGluc3RydWN0aW9ucyBhbmQKZGVsaXZlciBhbiBpbnRlcnJ1cHQgYWZ0ZXIg
ZXhhY3RseSBvbmUgYnJhbmNoIGluc3RydWN0aW9uLCB0aGUgdmFsdWUgb25lCmlzIGhhbmRsZWQg
YnkgdGhlIGhvc3QgS1ZNL3BlcmYgc3Vic3lzdGVtcyBhbmQgdHJlYXRlZCBpbmNvcnJlY3RseSBh
cyBhCnNwZWNpYWwgdmFsdWUgdG8gZW5hYmxlIHRoZSBicmFuY2ggdHJhY2Ugc3RvcmUgKEJUUykg
c3Vic3lzdGVtLiBJdApzaG91bGQgbm90IGJlIHBvc3NpYmxlIHRvIGVuYWJsZSBCVFMgZnJvbSBh
IGd1ZXN0LiBXaGVuIEJUUyBpcyBlbmFibGVkLAppdCBsZWFkcyB0byBnZW5lcmFsIGhvc3QgcGVy
Zm9ybWFuY2UgZGVncmFkYXRpb24gdG8gYm90aCBWTXMgYW5kIGhvc3QuCgpQZXJmIGNvbnNpZGVy
cyB0aGUgY29tYmluYXRpb24gb2YgUEVSRl9DT1VOVF9IV19CUkFOQ0hfSU5TVFJVQ1RJT05TIHdp
dGgKYSBzYW1wbGVfcGVyaW9kIG9mIDEgYSBzcGVjaWFsIGNhc2UgYW5kIGhhbmRsZXMgdGhpcyBh
cyBhIEJUUyBldmVudCAoc2VlCmludGVsX3BtdV9oYXNfYnRzX3BlcmlvZCgpKSAtLSBhIGRldmlh
dGlvbiBmcm9tIHRoZSB1c3VhbCBzZW1hbnRpYywKd2hlcmUgdGhlIHNhbXBsZV9wZXJpb2QgcmVw
cmVzZW50cyB0aGUgYW1vdW50IG9mIGJyYW5jaCBpbnN0cnVjdGlvbnMgdG8KZW5jb3VudGVyIGJl
Zm9yZSB0aGUgb3ZlcmZsb3cgaGFuZGxlciBpcyBpbnZva2VkLgoKTm90aGluZyBwcmV2ZW50cyBh
IGd1ZXN0IGZyb20gcHJvZ3JhbW1pbmcgaXRzIHZQTVUgd2l0aCB0aGUgYWJvdmUKc2V0dGluZ3Mg
KGNvdW50IGJyYW5jaCwgaW50ZXJydXB0IGFmdGVyIG9uZSBicmFuY2gpLCB3aGljaCBjYXVzZXMg
S1ZNIHRvCmVycm9uZW91c2x5IGluc3RydWN0IHBlcmYgdG8gY3JlYXRlIGEgQlRTIGV2ZW50IHdp
dGhpbgpwbWNfcmVwcm9ncmFtX2NvdW50ZXIoKSwgd2hpY2ggZG9lcyBub3QgaGF2ZSB0aGUgZGVz
aXJlZCBzZW1hbnRpY3MuCgpUaGUgZ3Vlc3QgY291bGQgYWxzbyBkbyBtb3JlIGJlbmlnbiBhY3Rp
b25zIGFuZCByZXF1ZXN0IGFuIGludGVycnVwdAphZnRlciBhIG1vcmUgcmVhc29uYWJsZSBudW1i
ZXIgb2YgYnJhbmNoIGluc3RydWN0aW9ucyB2aWEgaXRzIHZQTVUuIEluCnRoYXQgY2FzZSBjb3Vu
dGluZyB3b3JrcyBpbml0aWFsbHkuIEhvd2V2ZXIsIEtWTSBvY2Nhc2lvbmFsbHkgcGF1c2VzIGFu
ZApyZXN1bWVzIHRoZSBjcmVhdGVkIHBlcmZvcm1hbmNlIGNvdW50ZXJzLiBJZiB0aGUgcmVtYWlu
aW5nIGFtb3VudCBvZgpicmFuY2ggaW5zdHJ1Y3Rpb25zIHVudGlsIGludGVycnVwdCBoYXMgcmVh
Y2hlZCAxIGV4YWN0bHksCnBtY19yZXN1bWVfY291bnRlcigpIGZhaWxzIHRvIHJlc3VtZSB0aGUg
Y291bnRlciBhbmQgYSBCVFMgZXZlbnQgaXMKY3JlYXRlZCBpbnN0ZWFkIHdpdGggaXRzIGluY29y
cmVjdCBzZW1hbnRpY3MuCgpGaXggdGhpcyBiZWhhdmlvciBieSBub3QgcGFzc2luZyB0aGUgc3Bl
Y2lhbCB2YWx1ZSAiMSIgYXMgc2FtcGxlX3BlcmlvZAp0byBwZXJmLiBJbnN0ZWFkLCBwZXJmb3Jt
IHRoZSBzYW1lIHF1aXJrIHRoYXQgaGFwcGVucyBsYXRlciBpbgp4ODZfcGVyZl9ldmVudF9zZXRf
cGVyaW9kKCkgYW55d2F5LCB3aGVuIHRoZSBwZXJmb3JtYW5jZSBjb3VudGVyIGlzCnRyYW5zZmVy
cmVkIHRvIHRoZSBhY3R1YWwgUE1VOiBidW1wIHRoZSBzYW1wbGVfcGVyaW9kIHRvIDIuCgpUZXN0
aW5nOgpGcm9tIGd1ZXN0OgpgLi93cm1zciAtcCAxMiAweDE4NiAweDExMDBjNGAKYC4vd3Jtc3Ig
LXAgMTIgMHhjMSAweGZmZmZmZmZmZmZmZmAKYC4vd3Jtc3IgLXAgMTIgMHgxODYgMHg1MTAwYzRg
CgpUaGlzIHNlcXVlbmNlIHNldHMgdXAgYnJhbmNoIGluc3RydWN0aW9uIGNvdW50aW5nLCBpbml0
aWFsaXplcyB0aGUgY291bnRlcgp0byBvdmVyZmxvdyBhZnRlciBvbmUgZXZlbnQgKDB4ZmZmZmZm
ZmZmZmZmKSwgYW5kIHRoZW4gZW5hYmxlcyBlZGdlCmRldGVjdGlvbiAoYml0IDE4KSBmb3IgYnJh
bmNoIGV2ZW50cy4KCi4vd3Jtc3IgLXAgMTIgMHgxODYgMHgxMTAwYzQKICAgIFdyaXRlcyB0byBJ
QTMyX1BFUkZFVlRTRUwwICgweDE4NikKICAgIFZhbHVlIDB4MTEwMGM0IGJyZWFrcyBkb3duIGFz
OgogICAgICAgIEV2ZW50ID0gMHhDNCAoQnJhbmNoIGluc3RydWN0aW9ucykKICAgICAgICBCaXRz
IDE2LTE3OiAweDEgKFVzZXIgbW9kZSBvbmx5KQogICAgICAgIEJpdCAyMjogMSAoRW5hYmxlIGNv
dW50ZXIpCgouL3dybXNyIC1wIDEyIDB4YzEgMHhmZmZmZmZmZmZmZmYKICAgIFdyaXRlcyB0byBJ
QTMyX1BNQzAgKDB4QzEpCiAgICBTZXRzIGNvdW50ZXIgdG8gbWF4aW11bSB2YWx1ZSAoMHhmZmZm
ZmZmZmZmZmYpCiAgICBUaGlzIGVmZmVjdGl2ZWx5IHNldHMgdXAgdGhlIGNvdW50ZXIgdG8gb3Zl
cmZsb3cgb24gdGhlIG5leHQgYnJhbmNoCgouL3dybXNyIC1wIDEyIDB4MTg2IDB4NTEwMGM0CiAg
ICBVcGRhdGVzIElBMzJfUEVSRkVWVFNFTDAgYWdhaW4KICAgIFNpbWlsYXIgdG8gZmlyc3QgY29t
bWFuZCBidXQgYWRkcyBiaXQgMTggKDB4NCB0byAweDUpCiAgICBFbmFibGVzIGVkZ2UgZGV0ZWN0
aW9uIChiaXQgMTgpCgpUaGVzZSBNU1Igd3JpdGVzIGFyZSB0cmFwcGVkIGJ5IHRoZSBoeXBlcnZp
c29yIGluIEtWTSBhbmQgZm9yd2FyZGVkIHRvCnRoZSBwZXJmIHN1YnN5c3RlbSB0byBjcmVhdGUg
Y29ycmVzcG9uZGluZyBtb25pdG9yaW5nIGV2ZW50cy4KCkl0IGlzIHBvc3NpYmxlIHRvIHJlcHJv
IHRoaXMgcHJvYmxlbSBpbiBhIG1vcmUgcmVhbGlzdGljIGd1ZXN0IHNjZW5hcmlvOgoKYHBlcmYg
cmVjb3JkIC1lIGJyYW5jaGVzOnUgLWMgMiAtYSAmYApgcGVyZiByZWNvcmQgLWUgYnJhbmNoZXM6
dSAtYyAyIC1hICZgCgpUaGlzIHByZXN1bWFibHkgdHJpZ2dlcnMgdGhlIGlzc3VlIGJ5IEtWTSBw
YXVzaW5nIGFuZCByZXN1bWluZyB0aGUKcGVyZm9ybWFuY2UgY291bnRlciBhdCB0aGUgd3Jvbmcg
bW9tZW50LCB3aGVuIGl0cyB2YWx1ZSBpcyBhYm91dCB0bwpvdmVyZmxvdy4KClNpZ25lZC1vZmYt
Ynk6IEphbiBILiBTY2jDtm5oZXJyIDxqc2Nob2VuaEBhbWF6b24uZGU+ClNpZ25lZC1vZmYtYnk6
IEZlcm5hbmQgU2llYmVyIDxzaWViZXJmQGFtYXpvbi5jb20+ClJldmlld2VkLWJ5OiBEYXZpZCBX
b29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPgpSZXZpZXdlZC1ieTogSGVuZHJpayBCb3JnaG9y
c3QgPGhib3JnaG9yQGFtYXpvbi5kZT4KTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8y
MDI1MTEyNDEwMDIyMC4yMzgxNzctMS1zaWViZXJmQGFtYXpvbi5jb20KLS0tCiBhcmNoL3g4Ni9r
dm0vcG11LmMgfCAxMyArKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9wbXUuYyBiL2FyY2gveDg2L2t2bS9wbXUu
YwppbmRleCA0ODdhZDE5YTIzNmUuLjU0NzUxMjAyOGUyNCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a3ZtL3BtdS5jCisrKyBiL2FyY2gveDg2L2t2bS9wbXUuYwpAQCAtMjI1LDYgKzIyNSwxOSBAQCBz
dGF0aWMgdTY0IGdldF9zYW1wbGVfcGVyaW9kKHN0cnVjdCBrdm1fcG1jICpwbWMsIHU2NCBjb3Vu
dGVyX3ZhbHVlKQogewogCXU2NCBzYW1wbGVfcGVyaW9kID0gKC1jb3VudGVyX3ZhbHVlKSAmIHBt
Y19iaXRtYXNrKHBtYyk7CiAKKwkvKgorCSAqIEEgc2FtcGxlX3BlcmlvZCBvZiAxIG1pZ2h0IGdl
dCBtaXN0YWtlbiBieSBwZXJmIGZvciBhIEJUUyBldmVudCwgc2VlCisJICogaW50ZWxfcG11X2hh
c19idHNfcGVyaW9kKCkuIFRoaXMgd291bGQgcHJldmVudCByZS1hcm1pbmcgdGhlIGNvdW50ZXIK
KwkgKiB2aWEgcG1jX3Jlc3VtZV9jb3VudGVyKCksIGZvbGxvd2VkIGJ5IHRoZSBhY2NpZGVudGFs
IGNyZWF0aW9uIG9mIGFuCisJICogYWN0dWFsIEJUUyBldmVudCwgd2hpY2ggd2UgZG8gbm90IHdh
bnQuCisJICoKKwkgKiBBdm9pZCB0aGlzIGJ5IGJ1bXBpbmcgdGhlIHNhbXBsaW5nIHBlcmlvZC4g
Tm90ZSwgdGhhdCB3ZSBkbyBub3QgbG9zZQorCSAqIGFueSBwcmVjaXNpb24sIGJlY2F1c2UgdGhl
IHNhbWUgcXVpcmsgaGFwcGVucyBsYXRlciBhbnl3YXkgKGZvcgorCSAqIGRpZmZlcmVudCByZWFz
b25zKSBpbiB4ODZfcGVyZl9ldmVudF9zZXRfcGVyaW9kKCkuCisJICovCisJaWYgKHNhbXBsZV9w
ZXJpb2QgPT0gMSkKKwkJc2FtcGxlX3BlcmlvZCA9IDI7CisKIAlpZiAoIXNhbXBsZV9wZXJpb2Qp
CiAJCXNhbXBsZV9wZXJpb2QgPSBwbWNfYml0bWFzayhwbWMpICsgMTsKIAlyZXR1cm4gc2FtcGxl
X3BlcmlvZDsKLS0gCjIuNDMuMAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRyZSAoU291dGgg
QWZyaWNhKSAoUHJvcHJpZXRhcnkpIExpbWl0ZWQKMjkgR29nb3NvYSBTdHJlZXQsIE9ic2VydmF0
b3J5LCBDYXBlIFRvd24sIFdlc3Rlcm4gQ2FwZSwgNzkyNSwgU291dGggQWZyaWNhClJlZ2lzdHJh
dGlvbiBOdW1iZXI6IDIwMDQgLyAwMzQ0NjMgLyAwNwo=


