Return-Path: <kvm+bounces-56050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C90B39789
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32EC41C270CD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D032EB5C6;
	Thu, 28 Aug 2025 08:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="YDTI/s9R"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22B1C01
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 08:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.65.3.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756371229; cv=none; b=c2yDhZbgi8eZrS8OZyfRKry0KXCKJjL7r6BWUrdo+CJ8t9/NqplKOjxyMmA6rc/FnFN3Ep7nXVpVh3LKHjLTL8G2fej9M3Jc4hjgbBaWk+jxswf21tmD5T1Db/PSZT6CXz+uKVrKLVWAIscZNyeAk2baV9OKFeudpGpDY+WPjns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756371229; c=relaxed/simple;
	bh=3yN3xMyWtPviipPaPcoPriyQWbShrW1Be3cr65pjFWI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Nrvt34idvATVpZjVLyGh/KfljJER5pxg1jyuCPAjt4U7eGiLMzQNIuULImqcfkelVJwHHoV/7sYx+8efQ0JopTgo1lGVdwJdZ3R8g+jlerr9f0SflLt8ITUwsSyxncBpU74INCdmPwzsMvWv9/RugUmZBNIx/mFhhVKgHgJxWPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=YDTI/s9R; arc=none smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1756371227; x=1787907227;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=3yN3xMyWtPviipPaPcoPriyQWbShrW1Be3cr65pjFWI=;
  b=YDTI/s9R1Bp/MGbRWTWsk9hlyo6FiPHC3M9lpyhhiDQ9gGc2Cg2SU502
   +8ikS4oGNLs0w2vLcmMTzQM4zO0ezQzX/Rio6P3iHcPpBTYJrP1+AYDLl
   4DcN31Ls6Wvv+w4o4a2mWNHGwp794TBGbX3AHLx5SNbGfKQ8iuAxDGAnp
   6vKQRrTLQZCJYQsJtG/6yauTbAfWPqdepgBKc5eygjw1tBf3JzcqpNg5s
   yIlJWaTKk+cqSUgGPWpcUMbN6ZqX1vCb1WC9ydVl3yeGTXg3QZ/BGWW/A
   ChB24dIGJwSnx8KU1GaOo2WGs/bAU3qQT4xjVkrNatS7yVRkFpPzAfDC/
   g==;
X-CSE-ConnectionGUID: AHmztq9aSq2jUnGoaJ0jlA==
X-CSE-MsgGUID: IxSr7trOR1GR6lLH6wW22g==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1299986"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:53:33 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:23017]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.37:2525] with esmtp (Farcaster)
 id 90e75ac9-b3a0-42e0-8e3f-8af2a1aaba5d; Thu, 28 Aug 2025 08:53:33 +0000 (UTC)
X-Farcaster-Flow-ID: 90e75ac9-b3a0-42e0-8e3f-8af2a1aaba5d
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 08:53:31 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Thu, 28 Aug 2025
 08:53:28 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt
	<benh@kernel.crashing.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Kumar, Praveen" <pravkmr@amazon.de>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
In-Reply-To: <20250814115247.4458764a.alex.williamson@redhat.com> (Alex
	Williamson's message of "Thu, 14 Aug 2025 11:52:47 -0600")
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
	<20250807130605.644ac9f6.alex.williamson@redhat.com>
	<20250811155558.GF377696@ziepe.ca>
	<20250811160710.174ca708.alex.williamson@redhat.com>
	<lrkyq349uut66.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250814115247.4458764a.alex.williamson@redhat.com>
Date: Thu, 28 Aug 2025 10:53:24 +0200
Message-ID: <lrkyq8qj33jzv.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Transfer-Encoding: base64

CkhpIGFsbCwKClNpbmNlIGl0IGxvb2tzIGxpa2UgY3JlYXRpbmcgYWxpYXMgcmVnaW9ucyBpcyB0
aGUgcGF0aCBmb3J3YXJkLCBJ4oCZZCBsaWtlCnRvIHN1bW1hcml6ZSB0aGUgZGlzY3Vzc2lvbiB0
byBtYWtlIHN1cmUgd2XigJlyZSBhbGwgYWxpZ25lZC4gRnJvbSBteQp1bmRlcnN0YW5kaW5nLCB0
aGUgbWFpbiBzdGVwcyBhcmU6CgogICAgLSBJbnRyb2R1Y2UgaGVscGVycyB0byBjcmVhdGUgY29t
cGFjdCBvZmZzZXRzLCBsaWtlbHkgbGV2ZXJhZ2luZwogICAgbXQuIE5vIGNoYW5nZXMgdG8gdGhl
IHZmaW8gb3BzIEFQSXMgYXJlIHJlcXVpcmVkLCBzaW5jZSB0aGUgbXQgc2hvdWxkCiAgICBsaXZl
IHdpdGhpbiB0aGUgdmZpbyBzdHJ1Y3QgaXRzZWxmLgoKICAgIC0gQWRkIGEgV0MgZmxhZyB0byBy
ZWdpb25zLgoKICAgIC0gRGVmaW5lIGEgbmV3IFVBUEkgZm9yIGNyZWF0aW5nIGFsaWFzIHJlZ2lv
bnMgd2l0aCBuZXcKICAgIG9mZnNldHMuIFRoaXMgVUFQSSBzaG91bGQgc3VwcG9ydCBhbGlhc2lu
ZyBleGlzdGluZyByZWdpb25zIGFzIHdlbGwKICAgIGFzIHNwZWNpZnlpbmcgYWRkaXRpb25hbCBm
bGFncyBzdWNoIGFzIFdDLgoKICAgIC0gRW5hYmxlIFdDIHN1cHBvcnQgZm9yIG1tYXAuCgpJIHBs
YW4gdG8gc3RhcnQgd29ya2luZyBvbiBhbiBSRkMgY292ZXJpbmcgdGhlc2UgcG9pbnRzIG92ZXIg
dGhlIG5leHQKMeKAkzIgd2Vla3MuCgpUaGFua3MsCk1OQWRhbQoKCgpBbWF6b24gV2ViIFNlcnZp
Y2VzIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKVGFtYXJhLURhbnotU3RyLiAxMwox
MDI0MyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25h
dGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRl
ciBIUkIgMjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1OTcK


