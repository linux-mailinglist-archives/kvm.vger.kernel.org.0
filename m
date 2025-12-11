Return-Path: <kvm+bounces-65794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C35CCB6EB4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 19:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 95964302D2B1
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 18:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C67B2798E6;
	Thu, 11 Dec 2025 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FfCYuedE"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A13161A6;
	Thu, 11 Dec 2025 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.199.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765478224; cv=none; b=XvLG1Oa5FL5Sj7ur4Z+kJ2/m77j/8PZUbZXW77VPo1mlRjeLr1giIfdHJ7deoxCQ5+p6BkHOLDG8LLrQzjwdkk/nQ+XQp6vqbqu+1WumvJUmKhW3u3TRgSVV7+IfQp6PRfLUgxqbdFs42A5ZObl8FTCkptuW3Doe+1wnC5aueRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765478224; c=relaxed/simple;
	bh=BLZDrpTLctOjJeBQ7kE6MzOtoDaCfVtSLHJPEeFgVwM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTpVvp+Q+JerW9gvXxQLYq6BlE6rYQhek5R2gUDxGffMUkaHjl4iCVB7iHIlsbdWx+1z+gFBMc1BBEqA0a4oH8qGnTOGVw8oH4Ikvs3gng2JQRWM7aF2NB5n+wAaoVJQATPT7+Dre0StBc0CCBlGTO5iqj53HStKYElCgKfWY/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FfCYuedE; arc=none smtp.client-ip=18.199.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1765478220; x=1797014220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BLZDrpTLctOjJeBQ7kE6MzOtoDaCfVtSLHJPEeFgVwM=;
  b=FfCYuedERb3ocuEALDgRbCIYCN+VX+2oy+PvrjdgQQVzz93pTqkV5UBA
   cqJuS9Js/I72aqL0VdyzfLo+y1o5xAyqcbAqrI+Bwr9qSRecsP0rCAcPY
   CVY/Pni4vbvU8jO3JM0fCiwTgwiDyP6XzsuyeYRMCQ7FsDS/ohcoqjJJt
   no5Ai9Dpu6l654hbw/+FOAGULviheXNG33iOdrl5UVqSOpchTONUV3ESA
   VtC21yuY+N/G/nKR3NSsVFEnG37pEnh/9spPQMmV3XEdChVvRkmHp0ud8
   aoeEIpzBbtS1eeR5A5GVnumpHwdmvg1qZX4xKqYZxSwBTGY6IAaQOdTFi
   g==;
X-CSE-ConnectionGUID: SHdbm8raRsiy5x2EVMJI/g==
X-CSE-MsgGUID: 2+mG77+STLatB1e2eVkzXg==
X-IronPort-AV: E=Sophos;i="6.21,141,1763424000"; 
   d="scan'208";a="6480546"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:36:40 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:31663]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.7.166:2525] with esmtp (Farcaster)
 id 74c1f423-9f86-49eb-b782-e2459c470737; Thu, 11 Dec 2025 18:36:40 +0000 (UTC)
X-Farcaster-Flow-ID: 74c1f423-9f86-49eb-b782-e2459c470737
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 11 Dec 2025 18:36:32 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.111) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 11 Dec 2025 18:36:23 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <peterz@infradead.org>
CC: <abusse@amazon.de>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<dwmw@amazon.co.uk>, <hborghor@amazon.de>, <hpa@zytor.com>,
	<jschoenh@amazon.de>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <nh-open-source@amazon.com>, <nsaenz@amazon.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <sieberf@amazon.com>,
	<stable@vger.kernel.org>, <tglx@linutronix.de>, <x86@kernel.org>
Subject: [PATCH v2] perf/x86/intel: Do not enable BTS for guests
Date: Thu, 11 Dec 2025 20:36:04 +0200
Message-ID: <20251211183604.868641-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251210111655.GB3911114@noisy.programming.kicks-ass.net>
References: <20251210111655.GB3911114@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QnkgZGVmYXVsdCB3aGVuIHVzZXJzIHByb2dyYW0gcGVyZiB0byBzYW1wbGUgYnJhbmNoIGluc3Ry
dWN0aW9ucwooUEVSRl9DT1VOVF9IV19CUkFOQ0hfSU5TVFJVQ1RJT05TKSB3aXRoIGEgc2FtcGxl
IHBlcmlvZCBvZiAxLCBwZXJmCmludGVycHJldHMgdGhpcyBhcyBhIHNwZWNpYWwgY2FzZSBhbmQg
ZW5hYmxlcyBCVFMgKEJyYW5jaCBUcmFjZSBTdG9yZSkKYXMgYW4gb3B0aW1pemF0aW9uIHRvIGF2
b2lkIHRha2luZyBhbiBpbnRlcnJ1cHQgb24gZXZlcnkgYnJhbmNoLgoKU2luY2UgQlRTIGRvZXNu
J3QgdmlydHVhbGl6ZSwgdGhpcyBvcHRpbWl6YXRpb24gZG9lc24ndCBtYWtlIHNlbnNlIHdoZW4K
dGhlIHJlcXVlc3Qgb3JpZ2luYXRlcyBmcm9tIGEgZ3Vlc3QuIEFkZCBhbiBhZGRpdGlvbmFsIGNo
ZWNrIHRoYXQKcHJldmVudHMgdGhpcyBvcHRpbWl6YXRpb24gZm9yIHZpcnR1YWxpemVkIGV2ZW50
cyAoZXhjbHVkZV9ob3N0KS4KClJlcG9ydGVkLWJ5OiBKYW4gSC4gU2Now7ZuaGVyciA8anNjaG9l
bmhAYW1hem9uLmRlPgpTdWdnZXN0ZWQtYnk6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFk
ZWFkLm9yZz4KU2lnbmVkLW9mZi1ieTogRmVybmFuZCBTaWViZXIgPHNpZWJlcmZAYW1hem9uLmNv
bT4KLS0tCiBhcmNoL3g4Ni9ldmVudHMvcGVyZl9ldmVudC5oIHwgMTMgKysrKysrKysrKystLQog
MSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvZXZlbnRzL3BlcmZfZXZlbnQuaCBiL2FyY2gveDg2L2V2ZW50cy9wZXJm
X2V2ZW50LmgKaW5kZXggMzE2MWVjMGEzNDE2Li5mMmUyZDliMDMzNjcgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L2V2ZW50cy9wZXJmX2V2ZW50LmgKKysrIGIvYXJjaC94ODYvZXZlbnRzL3BlcmZfZXZl
bnQuaApAQCAtMTU3NCwxMyArMTU3NCwyMiBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaW50ZWxfcG11
X2hhc19idHNfcGVyaW9kKHN0cnVjdCBwZXJmX2V2ZW50ICpldmVudCwgdTY0IHBlcmlvZAogCXN0
cnVjdCBod19wZXJmX2V2ZW50ICpod2MgPSAmZXZlbnQtPmh3OwogCXVuc2lnbmVkIGludCBod19l
dmVudCwgYnRzX2V2ZW50OwogCi0JaWYgKGV2ZW50LT5hdHRyLmZyZXEpCisJLyoKKwkgKiBPbmx5
IHVzZSBCVFMgZm9yIGZpeGVkIHJhdGUgcGVyaW9kPT0xIGV2ZW50cy4KKwkgKi8KKwlpZiAoZXZl
bnQtPmF0dHIuZnJlcSB8fCBwZXJpb2QgIT0gMSkKKwkJcmV0dXJuIGZhbHNlOworCisJLyoKKwkg
KiBCVFMgZG9lc24ndCB2aXJ0dWFsaXplLgorCSAqLworCWlmIChldmVudC0+YXR0ci5leGNsdWRl
X2hvc3QpCiAJCXJldHVybiBmYWxzZTsKIAogCWh3X2V2ZW50ID0gaHdjLT5jb25maWcgJiBJTlRF
TF9BUkNIX0VWRU5UX01BU0s7CiAJYnRzX2V2ZW50ID0geDg2X3BtdS5ldmVudF9tYXAoUEVSRl9D
T1VOVF9IV19CUkFOQ0hfSU5TVFJVQ1RJT05TKTsKIAotCXJldHVybiBod19ldmVudCA9PSBidHNf
ZXZlbnQgJiYgcGVyaW9kID09IDE7CisJcmV0dXJuIGh3X2V2ZW50ID09IGJ0c19ldmVudDsKIH0K
IAogc3RhdGljIGlubGluZSBib29sIGludGVsX3BtdV9oYXNfYnRzKHN0cnVjdCBwZXJmX2V2ZW50
ICpldmVudCkKLS0gCjIuNDMuMAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRyZSAoU291dGgg
QWZyaWNhKSAoUHJvcHJpZXRhcnkpIExpbWl0ZWQKMjkgR29nb3NvYSBTdHJlZXQsIE9ic2VydmF0
b3J5LCBDYXBlIFRvd24sIFdlc3Rlcm4gQ2FwZSwgNzkyNSwgU291dGggQWZyaWNhClJlZ2lzdHJh
dGlvbiBOdW1iZXI6IDIwMDQgLyAwMzQ0NjMgLyAwNwo=


