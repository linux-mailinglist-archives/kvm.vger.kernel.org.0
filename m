Return-Path: <kvm+bounces-68186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A16D24E51
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 15:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A882330305A5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 14:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7833A1E90;
	Thu, 15 Jan 2026 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="AUbtnOVc"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B4E39C636;
	Thu, 15 Jan 2026 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768486528; cv=none; b=JhOFHsylzRLy/YMWIhioUhUwcqsdOMjGRXqOyYSo7Q9pSCowTnfWl+RP91KceJpyOQ5CUBkMcxzCTww9qVTpic0K1GS7Fv8U8UW+JvEzVyAQssu1vP03fRgfGoL4pSl6R1pVNzXUNS6/S2Lyf/PtX3nUUuruvP4oG2OD9URNGhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768486528; c=relaxed/simple;
	bh=TwCKSmjzMIbtWUecU+6xCW1eizZSP6AWdIVZfNzXWqc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AFNc8ZT15y6HzaKWwaATaSXq0poxm455iDVc5U4qu/2GqfL9elc61Rz524gQD+KXp4duB+ejql7X+G5R25bV2aq1Z+nV3Pb2T/r6Ny5PZEI0Zrc/OKE1DnYDOS6GBnp6UY/Mx2uMrHs1pbN2Y2MZ7mEXoTjNus9xe6HV7f/9V2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=AUbtnOVc; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768486526; x=1800022526;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TwCKSmjzMIbtWUecU+6xCW1eizZSP6AWdIVZfNzXWqc=;
  b=AUbtnOVcPU8Nyi3c1Tc524NuaPl41PxgHIEp/eWrPuw63eTodoggX6cc
   3hGnjsLQ2x0wbBYEWdxirHCTUcsw4tccFo9snXcgxE0zmMYmdRfBlQyDa
   B7z3b5MZ6I9UFa1gcgyCePW7U4yp+N2Sl6FapElvYI0vY1zyA3lL1FufA
   1aDLQ+mJlsV9iEeMPTyNPgEnlZXMH5CInTLw7cX8xZ6jeXeY2dR+bk/ci
   j2f93aD0bDUhetnE8aqG2TcfzgelGLO1cuDz7xc2XwiMD3y0PVmyUsiU4
   ra2/AwwrvCLyh+PNIFUm6SRsz1C9tp37UH9xj5/43P9lKIc5Ymx+KhGYK
   g==;
X-CSE-ConnectionGUID: QkUcPMgXTZCMt4avVCRudw==
X-CSE-MsgGUID: 0vJGAvcnSg+yGy0tQITfJQ==
X-IronPort-AV: E=Sophos;i="6.21,228,1763424000"; 
   d="scan'208";a="10459992"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 14:15:24 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:3945]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.37.11:2525] with esmtp (Farcaster)
 id e82e2b81-7724-4f9f-bc8c-7d262e21790e; Thu, 15 Jan 2026 14:15:24 +0000 (UTC)
X-Farcaster-Flow-ID: e82e2b81-7724-4f9f-bc8c-7d262e21790e
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 15 Jan 2026 14:15:23 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 15 Jan 2026 14:15:21 +0000
From: Alexander Graf <graf@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hpa@zytor.com>, <x86@kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>, <nh-open-source@amazon.com>,
	<gurugubs@amazon.com>, <jalliste@amazon.co.uk>, Michael Kelley
	<mhklinux@outlook.com>, John Starks <jostarks@microsoft.com>
Subject: [PATCH] kvm: hyper-v: Delay firing of expired stimers
Date: Thu, 15 Jan 2026 14:15:20 +0000
Message-ID: <20260115141520.24176-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RHVyaW5nIFdpbmRvd3MgU2VydmVyIDIwMjUgaGliZXJuYXRpb24sIEkgaGF2ZSBzZWVuIFdpbmRv
d3MnIGNhbGN1bGF0aW9uCm9mIGludGVycnVwdCB0YXJnZXQgdGltZSBnZXQgc2tld2VkIG92ZXIg
dGhlIGh5cGVydmlzb3IgdmlldyBvZiB0aGUgc2FtZS4KVGhpcyBjYW4gY2F1c2UgV2luZG93cyB0
byBlbWl0IHRpbWVyIGV2ZW50cyBpbiB0aGUgcGFzdCBmb3IgZXZlbnRzIHRoYXQKZG8gbm90IGZp
cmUgeWV0IGFjY29yZGluZyB0byB0aGUgcmVhbCB0aW1lIHNvdXJjZS4gVGhpcyB0aGVuIGxlYWRz
IHRvCmludGVycnVwdCBzdG9ybXMgaW4gdGhlIGd1ZXN0IHdoaWNoIHNsb3cgZG93biBleGVjdXRp
b24gdG8gYSBwb2ludCB3aGVyZQp3YXRjaGRvZ3MgdHJpZ2dlci4gVGhvc2UgbWFuaWZlc3QgYXMg
YnVnY2hlY2tzIDB4OWYgYW5kIDB4YTAgZHVyaW5nCmhpYmVybmF0aW9uLCB0eXBpY2FsbHkgaW4g
dGhlIHJlc3VtZSBwYXRoLgoKVG8gd29yayBhcm91bmQgdGhpcyBwcm9ibGVtLCB3ZSBjYW4gZGVs
YXkgdGltZXJzIHRoYXQgZ2V0IGNyZWF0ZWQgd2l0aCBhCnRhcmdldCB0aW1lIGluIHRoZSBwYXN0
IGJ5IGEgdGlueSBiaXQgKDEwwrVzKSB0byBnaXZlIHRoZSBndWVzdCBDUFUgdGltZQp0byBwcm9j
ZXNzIHJlYWwgd29yayBhbmQgbWFrZSBmb3J3YXJkIHByb2dyZXNzLCBob3BlZnVsbHkgcmVjb3Zl
cmluZyBpdHMKaW50ZXJydXB0IGxvZ2ljIGluIHRoZSBwcm9jZXNzLiBXaGlsZSB0aGlzIHNtYWxs
IGRlbGF5IGNhbiBtYXJnaW5hbGx5CnJlZHVjZSBhY2N1cmFjeSBvZiBndWVzdCB0aW1lcnMsIDEw
wrVzIGFyZSB3aXRoaW4gdGhlIG5vaXNlIG9mIFZNCmVudHJ5L2V4aXQgb3ZlcmhlYWQgKH4xLTIg
wrVzKSBzbyBJIGRvIG5vdCBleHBlY3QgdG8gc2VlIHJlYWwgd29ybGQgaW1wYWN0LgoKVG8gc3Rp
bGwgcHJvdmlkZSBzb21lIGxldmVsIG9mIHZpc2liaWxpdHkgd2hlbiB0aGlzIGhhcHBlbnMsIGFk
ZCBhIHRyYWNlCnBvaW50IHRoYXQgY2xlYXJseSBzaG93cyB0aGUgZGlzY3JlcGFuY3kgYmV0d2Vl
biB0aGUgdGFyZ2V0IHRpbWUgYW5kIHRoZQpjdXJyZW50IHRpbWUuCgpTaWduZWQtb2ZmLWJ5OiBB
bGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgotLS0KIGFyY2gveDg2L2t2bS9oeXBlcnYu
YyB8IDIyICsrKysrKysrKysrKysrKysrKy0tLS0KIGFyY2gveDg2L2t2bS90cmFjZS5oICB8IDI2
ICsrKysrKysrKysrKysrKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDQ0IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5cGVydi5j
IGIvYXJjaC94ODYva3ZtL2h5cGVydi5jCmluZGV4IDcyYjE5YTg4YTc3Ni4uYzQxMDYxYWNiY2Jj
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0vaHlwZXJ2LmMKKysrIGIvYXJjaC94ODYva3ZtL2h5
cGVydi5jCkBAIC02NjYsMTMgKzY2NiwyNyBAQCBzdGF0aWMgaW50IHN0aW1lcl9zdGFydChzdHJ1
Y3Qga3ZtX3ZjcHVfaHZfc3RpbWVyICpzdGltZXIpCiAJc3RpbWVyLT5leHBfdGltZSA9IHN0aW1l
ci0+Y291bnQ7CiAJaWYgKHRpbWVfbm93ID49IHN0aW1lci0+Y291bnQpIHsKIAkJLyoKLQkJICog
RXhwaXJlIHRpbWVyIGFjY29yZGluZyB0byBIeXBlcnZpc29yIFRvcC1MZXZlbCBGdW5jdGlvbmFs
Ci0JCSAqIHNwZWNpZmljYXRpb24gdjQoMTUuMy4xKToKKwkJICogSHlwZXJ2aXNvciBUb3AtTGV2
ZWwgRnVuY3Rpb25hbCBzcGVjaWZpY2F0aW9uIHY0KDE1LjMuMSk6CiAJCSAqICJJZiBhIG9uZSBz
aG90IGlzIGVuYWJsZWQgYW5kIHRoZSBzcGVjaWZpZWQgY291bnQgaXMgaW4KIAkJICogdGhlIHBh
c3QsIGl0IHdpbGwgZXhwaXJlIGltbWVkaWF0ZWx5LiIKKwkJICoKKwkJICogSG93ZXZlciwgdGhl
cmUgYXJlIGNhc2VzIGR1cmluZyBoaWJlcm5hdGlvbiB3aGVuIFdpbmRvd3MncworCQkgKiBpbnRl
cnJ1cHQgY291bnQgY2FsY3VsYXRpb24gY2FuIGdvIG91dCBvZiBzeW5jIHdpdGggS1ZNJ3MKKwkJ
ICogdmlldyBvZiBpdCwgY2F1c2luZyBXaW5kb3dzIHRvIGVtaXQgdGltZXIgZXZlbnRzIGluIHRo
ZSBwYXN0CisJCSAqIGZvciBldmVudHMgdGhhdCBkbyBub3QgZmlyZSB5ZXQgYWNjb3JkaW5nIHRv
IHRoZSByZWFsIHRpbWUKKwkJICogc291cmNlLiBUaGlzIHRoZW4gbGVhZHMgdG8gaW50ZXJydXB0
IHN0b3JtcyBpbiB0aGUgZ3Vlc3QKKwkJICogd2hpY2ggc2xvdyBkb3duIGV4ZWN1dGlvbiB0byBh
IHBvaW50IHdoZXJlIHdhdGNoZG9ncyB0cmlnZ2VyLgorCQkgKgorCQkgKiBJbnN0ZWFkIG9mIHRh
a2luZyBUTEZTIGxpdGVyYWxseSBvbiB3aGF0ICJpbW1lZGlhdGVseSIgbWVhbnMsCisJCSAqIGdp
dmUgdGhlIGd1ZXN0IGF0IGxlYXN0IDEwwrVzIHRvIHByb2Nlc3Mgd29yay4gV2hpbGUgdGhpcyBj
YW4KKwkJICogbWFyZ2luYWxseSByZWR1Y2UgYWNjdXJhY3kgb2YgZ3Vlc3QgdGltZXJzLCAxMMK1
cyBhcmUgd2l0aGluCisJCSAqIHRoZSBub2lzZSBvZiBWTSBlbnRyeS9leGl0IG92ZXJoZWFkICh+
MS0yIMK1cykuCiAJCSAqLwotCQlzdGltZXJfbWFya19wZW5kaW5nKHN0aW1lciwgZmFsc2UpOwot
CQlyZXR1cm4gMDsKKwkJdHJhY2Vfa3ZtX2h2X3N0aW1lcl9zdGFydF9leHBpcmVkKAorCQkJCQlo
dl9zdGltZXJfdG9fdmNwdShzdGltZXIpLT52Y3B1X2lkLAorCQkJCQlzdGltZXItPmluZGV4LAor
CQkJCQl0aW1lX25vdywgc3RpbWVyLT5jb3VudCk7CisJCXN0aW1lci0+Y291bnQgPSB0aW1lX25v
dyArIDEwMDsKIAl9CiAKIAl0cmFjZV9rdm1faHZfc3RpbWVyX3N0YXJ0X29uZV9zaG90KGh2X3N0
aW1lcl90b192Y3B1KHN0aW1lciktPnZjcHVfaWQsCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
dHJhY2UuaCBiL2FyY2gveDg2L2t2bS90cmFjZS5oCmluZGV4IDU3ZDc5ZmQzMWRmMC4uZjllNjlj
NGQ5ZTliIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rdm0vdHJhY2UuaAorKysgYi9hcmNoL3g4Ni9r
dm0vdHJhY2UuaApAQCAtMTQwMSw2ICsxNDAxLDMyIEBAIFRSQUNFX0VWRU5UKGt2bV9odl9zdGlt
ZXJfc3RhcnRfb25lX3Nob3QsCiAJCSAgX19lbnRyeS0+Y291bnQpCiApOwogCisvKgorICogVHJh
Y2Vwb2ludCBmb3Igc3RpbWVyX3N0YXJ0KG9uZS1zaG90IHRpbWVyIGFscmVhZHkgZXhwaXJlZCku
CisgKi8KK1RSQUNFX0VWRU5UKGt2bV9odl9zdGltZXJfc3RhcnRfZXhwaXJlZCwKKwlUUF9QUk9U
TyhpbnQgdmNwdV9pZCwgaW50IHRpbWVyX2luZGV4LCB1NjQgdGltZV9ub3csIHU2NCBjb3VudCks
CisJVFBfQVJHUyh2Y3B1X2lkLCB0aW1lcl9pbmRleCwgdGltZV9ub3csIGNvdW50KSwKKworCVRQ
X1NUUlVDVF9fZW50cnkoCisJCV9fZmllbGQoaW50LCB2Y3B1X2lkKQorCQlfX2ZpZWxkKGludCwg
dGltZXJfaW5kZXgpCisJCV9fZmllbGQodTY0LCB0aW1lX25vdykKKwkJX19maWVsZCh1NjQsIGNv
dW50KQorCSksCisKKwlUUF9mYXN0X2Fzc2lnbigKKwkJX19lbnRyeS0+dmNwdV9pZCA9IHZjcHVf
aWQ7CisJCV9fZW50cnktPnRpbWVyX2luZGV4ID0gdGltZXJfaW5kZXg7CisJCV9fZW50cnktPnRp
bWVfbm93ID0gdGltZV9ub3c7CisJCV9fZW50cnktPmNvdW50ID0gY291bnQ7CisJKSwKKworCVRQ
X3ByaW50aygidmNwdV9pZCAlZCB0aW1lciAlZCB0aW1lX25vdyAlbGx1IGNvdW50ICVsbHUgKGV4
cGlyZWQpIiwKKwkJICBfX2VudHJ5LT52Y3B1X2lkLCBfX2VudHJ5LT50aW1lcl9pbmRleCwgX19l
bnRyeS0+dGltZV9ub3csCisJCSAgX19lbnRyeS0+Y291bnQpCispOworCiAvKgogICogVHJhY2Vw
b2ludCBmb3Igc3RpbWVyX3RpbWVyX2NhbGxiYWNrLgogICovCi0tIAoyLjQ3LjEKCgoKCkFtYXpv
biBXZWIgU2VydmljZXMgRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFu
ei1TdHIuIDEzCjEwMjQzIEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdG9mIEhlbGxt
aXMsIEFuZHJlYXMgU3RpZWdlcgpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVu
YnVyZyB1bnRlciBIUkIgMjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1
OTcK


