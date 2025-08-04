Return-Path: <kvm+bounces-53894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9715EB19FCC
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A02EF1699A2
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0118824BD00;
	Mon,  4 Aug 2025 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="IBk8jBGl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7022D7B6
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304057; cv=none; b=LBY8BtuXWmaz9raTup5FIYOP0jDyQHS8r7813j15JMtGeXbsRGnnucCduE1I3cNa5Iru/1JB9rj7aRsn7IQvtJ9XoT0YPIEp/tME/Q7sx5U0pqZWyKYdbh00en6LoOW+gCmlBe16h1G1UpYm1YPBpPAPik3f51S7kakif2ndjzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304057; c=relaxed/simple;
	bh=4iz19InG8gndeBe7O2NJqa7sN+JUVe/4L4WpHtJqvf4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VLYwiHzHQCT4erPbEKvX5qVUi5Vjq3xuh/fVYMeW+060NF/5Sg0giBQ7zUrsRcRaXjfM9BcYqBH4CIee1+Y1ZGI5lgBylHQqkGcHgjk14HZCvDijE/FIxU3KllHSLSPs0pzcofMss/JTlU8TZbU1n7zBoXBMSn2WJWS8tUW3Fz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=IBk8jBGl; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304055; x=1785840055;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4iz19InG8gndeBe7O2NJqa7sN+JUVe/4L4WpHtJqvf4=;
  b=IBk8jBGl2l1X9+W56ofVsRBZhUXA8Ur2LyWPrDVsaSbJSGOchllcMDkJ
   GKahBgh2/6XyazoFM1KjNFIG+io5yFw6tNNO1ZLyx31+BdjQnjiLyWN7e
   vVZSRdj4Y2ox/KN7bouQrsVoJ7Na5AlBEWc3jRYnTFTVaV0oLuLkSXsik
   ftAcOUhtB1ZerFlOy7u0BrF6eBSkxQhboPjmyDaBPJn/JhZsMjdTmCSy9
   BjhNsejHyF2dDaEUs33Po2J7Chh883dEjP6pZzSkbI9XmOavFyVu9PG57
   Yo1TYpOdMCroTFrZ1PbVt+vC4DUNz38F9AGlysr0x2d6v81LVqNNfrv4t
   g==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="745382763"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:40:51 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:41363]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.72:2525] with esmtp (Farcaster)
 id ec89664e-514e-4b62-ac7f-3c175393646f; Mon, 4 Aug 2025 10:40:49 +0000 (UTC)
X-Farcaster-Flow-ID: ec89664e-514e-4b62-ac7f-3c175393646f
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:40:49 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:40:46 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Date: Mon, 4 Aug 2025 12:39:53 +0200
Message-ID: <20250804104012.87915-1-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhpcyBSRkMgc2VyaWVzIHByb3Bvc2VzIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiBhIG5ldyBtZWNo
YW5pc20gZm9yCnJlZ2lvbiBtbWFwIGF0dHJpYnV0ZXMgdXNpbmcgbWFwbGUgdHJlZXMsIGJhc2Vk
IG9uIEphc29uJ3Mgc3VnZ2VzdGVkCm1hcGxlIHRyZWUgYW5kIG9mZnNldCBjb29raWUgYXBwcm9h
Y2hbMF0uIFRoZSBwcmltYXJ5IG1vdGl2YXRpb24gaXMgdG8KZW5hYmxlIHVzZXJzcGFjZSBhcHBs
aWNhdGlvbnMgdG8gc3BlY2lmeSBtbWFwIGF0dHJpYnV0ZXPigJRzdWNoIGFzIFdyaXRlCkNvbWJp
bmluZyAoV0Mp4oCUcHJpb3IgdG8gaW52b2tpbmcgbW1hcCBvbiBhIFZGSU8gcmVnaW9uLiBXaGls
ZSB0aGUKaW5pdGlhbCBmb2N1cyBpcyBvbiBXQyBzdXBwb3J0LCB0aGlzIGZyYW1ld29yayBjYW4g
YmUgZXh0ZW5kZWQgdG8Kc3VwcG9ydCBhZGRpdGlvbmFsIGF0dHJpYnV0ZXMgKGUuZy4sIGNhY2hh
YmxlKSBpbiB0aGUgZnV0dXJlLgoKQ29yZSBjb25jZXB0IGlzOiBhIG1hcGxlX3RyZWUgaW5zdGFu
Y2UgaXMgaW50cm9kdWNlZCBwZXIgZmlsZQpkZXNjcmlwdG9yIHdpdGhpbiB2ZmlvX2RldmljZV9m
aWxlLCBhbGxvd2luZyBwZXItcmVxdWVzdCBvd25lcnNoaXAgYW5kCmNvbnRyb2wgb2YgbW1hcCBh
dHRyaWJ1dGVzLiBWaWEgbmV3IFZGSU8gZGV2aWNlIG9wZXJhdGlvbnMgKGlvY3RsICYKbW1hcCks
IGVhY2ggdmZpbyBkZXZpY2UgcG9wdWxhdGVzIGl0cyBtYXBsZV90cmVlLCBwcmltYXJpbHkgZHVy
aW5nIHRoZQpERVZJQ0VfR0VUX1JFR0lPTl9JTkZPIGlvY3RsLiBUaGUga2VybmVsIHJldHVybnMg
YSB1bmlxdWUgb2Zmc2V0IGtleQp0byB1c2Vyc3BhY2U7IHVzZXJzcGFjZSBjYW4gdGhlbiBwYXNz
IHRoaXMgb2Zmc2V0IHRvIG1tYXAsIGF0IHdoaWNoCnBvaW50IHRoZSBrZXJuZWwgcmV0cmlldmVz
IHRoZSBjb3JyZWN0IG1hcGxlX3RyZWUgZW50cnkgYW5kIGludm9rZXMKdGhlIG5ldyBtbWFwIG9w
IG9uIHRoZSB2ZmlvIGRldmljZSB0byBtYXAgdGhlIHJlZ2lvbiB3aXRoIHRoZSBkZXNpcmVkCmF0
dHJpYnV0ZXMuCgpUaGlzIG1vZGVsIGFsc28gZW5hYmxlcyBhIG5ldyBVQVBJIGZvciB1c2Vyc3Bh
Y2UgdG8gc2V0IGF0dHJpYnV0ZXMgb24KYSBnaXZlbiBtbWFwIG9mZnNldCwgYWxsb3dpbmcgZmxl
eGliaWxpdHkgYW5kIHJvb20gZm9yIGZ1dHVyZSBmZWF0dXJlCmV4cGFuc2lvbi4KCkJlY2F1c2Ug
dGhlc2UgY2hhbmdlcyBhbHRlciBib3RoIGludGVybmFsIHJlZ2lvbiBvZmZzZXQgaGFuZGxpbmcg
YW5kCnRoZSBpb2N0bC9tbWFwIGludGVyZmFjZXMsIGEgc3RhZ2VkIGFwcHJvYWNoIGlzIG5lY2Vz
c2FyeSB0byBtYW5hZ2UKdGhlIGxhcmdlIHNjb3BlIG9mIHRoZSB1cGRhdGUuCgpUaGlzIFJGQyBp
bXBsZW1lbnRzOgogICAgLSBJbnRlZ3JhdGlvbiBvZiB0aGUgbWFwbGVfdHJlZSBtZWNoYW5pc20g
YW5kIG5ldyBWRklPIG9wcywgYWxvbmcKICAgICAgd2l0aCByZXF1aXJlZCBoZWxwZXJzLgogICAg
LSBJbml0aWFsIG9uYm9hcmQgc3VwcG9ydCBmb3IgdmZpby1wY2kuCiAgICAtIEludHJvZHVjdGlv
biBvZiB0aGUgbmV3IFVBUEkgc3VwcG9ydGluZyBXQy4KClBsYW5uZWQgZm9sbG93LXVwIHdvcms6
CiAgICAtIEV4dGVuZGluZyBuZXcgb3BzIHN1cHBvcnQgdG8gYWxsIHZmaW8tcGNpIGRldmljZXMu
CiAgICAtIFVwZGF0aW5nIHVzYWdlcyBvZiBWRklPX1BDSV9PRkZTRVRfVE9fSU5ERVggYW5kIFZG
SU9fUENJX0lOREVYX1RPX09GRlNFVC4KICAgIC0gTWlncmF0aW5nIGFkZGl0aW9uYWwgVkZJTyBk
ZXZpY2VzIHRvIHRoZSBuZXcgb3BzLgogICAgLSBGdWxseSByZW1vdmluZyBsZWdhY3kgaW9jdGwg
YW5kIG1tYXAgb3BzLCByZW5hbWluZyB0aGUgbmV3IG9wcwogICAgICBpbiB0aGVpciBwbGFjZSBv
bmNlIG1pZ3JhdGlvbiBpcyBjb21wbGV0ZS4KCgpGb3Igbm93LCBsZWdhY3kgYW5kIG5ldyBWRklP
IG9wcyBjb2V4aXN0LiBMZWdhY3kgb3BzIHdpbGwgYmUgcmVtb3ZlZApmb2xsb3dpbmcgZnVsbCBt
aWdyYXRpb24gYWNyb3NzIGFsbCByZWxldmFudCBkZXZpY2VzLgoKVGhpcyBSRkMgbWFya3MgdGhl
IHN0YXJ0IG9mIHRoaXMgdHJhbnNpdGlvbi4gSSBhbSBzZWVraW5nIGZlZWRiYWNrIG9uCnRoZSBj
b3JlIGltcGxlbWVudGF0aW9uIHRvIGVuc3VyZSB0aGUgZGlyZWN0aW9uIGFuZCBkZXNpZ24gYXJl
IGNvcnJlY3QKYmVmb3JlIHByb2NlZWRpbmcgd2l0aCBmdXJ0aGVyIGNvbnZlcnNpb24gYW5kIGNs
ZWFudXAgd29yay4gVGhhbmsgeW91CmZvciB5b3VyIHJldmlldyBhbmQgZ3VpZGFuY2UuCgpbMF06
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDgwMTE0MTkxNC5HQzMwMzA3NjFAemll
cGUuY2EvCgpyZWZlcmVuY2VzOgotIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDcz
MTE1NTM1Mi4zOTczODU3LTEta2J1c2NoQG1ldGEuY29tL1QvI3UKLSBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9rdm0vbHJreXE0aXZjY2I2eC5mc2ZAZGV2LWRzay1tbmd5YWRhbS0xYy1jYjNmNzU0
OC5ldS13ZXN0LTEuYW1hem9uLmNvbS8KCk1haG1vdWQgQWRhbSAoOSk6CiAgdmZpbzogYWRkIG1t
YXAgbWFwbGUgdHJlZSB0byB2ZmlvCiAgdmZpbzogYWRkIHRyYW5zaWVudCBvcHMgdG8gc3VwcG9y
dCB2ZmlvIG1tYXAgbXQKICB2ZmlvLXBjaS1jb3JlOiByZW5hbWUgdm0gb3BlcmF0aW9ucwogIHZm
aW8tcGNpLWNvcmU6IHJlbW92ZSByZWR1bmRhbnQgb2Zmc2V0IGNhbGN1bGF0aW9ucwogIHZmaW8t
cGNpLWNvcmU6IGFkZCB2ZmlvX3BjaV9tbWFwICYgaGVscGVycwogIHZmaW8tcGNpLWNvcmU6IHN1
cHBvcnQgdGhlIG5ldyB2ZmlvIG9wcwogIHZmaW8tcGNpOiB1c2UgdGhlIG5ldyB2ZmlvIG9wcwog
IHZmaW86IFVBUEkgZm9yIHNldHRpbmcgbW1hcCBhdHRyaWJ1dGVzCiAgdmZpb19wY2lfY29yZTog
c3VwcG9ydCBtbWFwIGF0dHJzIHVhcGkgJiBXQwoKIGRyaXZlcnMvdmZpby9wY2kvdmZpb19wY2ku
YyAgICAgIHwgICA0ICstCiBkcml2ZXJzL3ZmaW8vcGNpL3ZmaW9fcGNpX2NvcmUuYyB8IDE2NSAr
KysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCiBkcml2ZXJzL3ZmaW8vdmZpby5oICAgICAg
ICAgICAgICB8ICAgMSArCiBkcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgICAgICAgICB8ICA0MiAr
KysrKysrKwogaW5jbHVkZS9saW51eC92ZmlvLmggICAgICAgICAgICAgfCAgMjIgKysrKysKIGlu
Y2x1ZGUvbGludXgvdmZpb19wY2lfY29yZS5oICAgIHwgIDE0ICsrKwogaW5jbHVkZS91YXBpL2xp
bnV4L3ZmaW8uaCAgICAgICAgfCAgMTkgKysrKwogNyBmaWxlcyBjaGFuZ2VkLCAyNDggaW5zZXJ0
aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pCgotLSAKMi40Ny4zCgp0aGFua3MsCk1OQWRhbQoKCgpB
bWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKVGFtYXJh
LURhbnotU3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4g
U2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFy
bG90dGVuYnVyZyB1bnRlciBIUkIgMjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1
IDUzOCA1OTcK


