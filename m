Return-Path: <kvm+bounces-54657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B670B261A3
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 11:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 692DC580CDB
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 09:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23682F83B3;
	Thu, 14 Aug 2025 09:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Xtqrqm7/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6EB2F6582
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755165148; cv=none; b=XCHS8lep/eCB8rquKaRgRjIl1wBk98UcoloP0PTYTM02yREO7fWG+pD3r5cGAT+7SeyFqQRz/Rv7RMFy70DJKF+r9Vly9ZyonHw6u74pJjbCAOshocHh6rWKs92y7In/Yno+0bETZfGQPGAwNB6YlFZDj5xjj9q1AUUgIXLwY9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755165148; c=relaxed/simple;
	bh=9WP7pEgZJhaginLi/+gzctK1Z1wRC9uN/gssAwSkriw=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EUJ5ULQVKhbq9V5SNVh60a81T7Xk45833ejkVf4CSPHgUpd/K9hzo5hd+9fld5k9A2gLSmNZxx9gxuAWYmqqolFwMCebhXuzJa91ktA0K1X7JeF45pWKwC/wzHHrgRBjntb1+v5fdzsJs9agYoGRfSH4GiHwaJaLx/QBt/aaAk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Xtqrqm7/; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755165146; x=1786701146;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=9WP7pEgZJhaginLi/+gzctK1Z1wRC9uN/gssAwSkriw=;
  b=Xtqrqm7/GDqFb8XRBG0EPaFed7x0/EgIxOpNPloCiFrkMcF/xCYswMZP
   o/9gSPKXNw7oKhP7OQaxEzbGg93c2uj24+QqhQoy+T3RtsE2YV2dUN+bh
   N07N+wU6pypC+Q9JMO0KCpPXe54agtlP6sCsyKcLddrs4p3NGbCVpxaJ5
   WHS2JqqDo7rW+AGnVMnQdN25UMM5QsHYlZS0QAtYO5/TzglH6fqr5lUNG
   PuqdcEnY3bXwQuH71vVPLoduJWT55MT1yStgKn/9aT6XMkz7hYeFaFr4f
   WU9/jNF3hctyRY6TpImY9ZIdkUuzbnaf0hgDVwKbMXUVvwzE8ixHyUlGj
   w==;
X-IronPort-AV: E=Sophos;i="6.17,287,1747699200"; 
   d="scan'208";a="224975874"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 09:52:25 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:45320]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.7.58:2525] with esmtp (Farcaster)
 id ea2f02d8-3853-482b-8d23-3fac6324a96d; Thu, 14 Aug 2025 09:52:24 +0000 (UTC)
X-Farcaster-Flow-ID: ea2f02d8-3853-482b-8d23-3fac6324a96d
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 14 Aug 2025 09:52:23 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Thu, 14 Aug 2025
 09:52:21 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt
	<benh@kernel.crashing.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Kumar, Praveen" <pravkmr@amazon.de>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
In-Reply-To: <20250811160710.174ca708.alex.williamson@redhat.com> (Alex
	Williamson's message of "Mon, 11 Aug 2025 16:07:10 -0600")
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
Date: Thu, 14 Aug 2025 11:52:17 +0200
Message-ID: <lrkyq349uut66.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Transfer-Encoding: base64

VGhlIGxhc3QgZW1haWwgd2FzIGEgZHJhZnQgc2VudCBieSBtaXN0YWtlLiBUaGlzIGlzIHRoZSBm
dWxsIHZlcnNpb24uCgpBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29t
PiB3cml0ZXM6Cgo+IEN1cnJlbnRseSB3ZSBoYXZlIGEgc3RydWN0IHZmaW9fcGNpX3JlZ2lvbiBz
dG9yZWQgaW4gYW4gYXJyYXkgdGhhdCB3ZQo+IGR5bmFtaWNhbGx5IHJlc2l6ZSBmb3IgZGV2aWNl
IHNwZWNpZmljIHJlZ2lvbnMgYW5kIHRoZSBvZmZzZXQgaXMKPiBkZXRlcm1pbmVkIHN0YXRpY2Fs
bHkgZnJvbSB0aGUgYXJyYXkgaW5kZXguICBXZSBjb3VsZCBlYXNpbHkgc3BlY2lmeSBhbgo+IG9m
ZnNldCBhbmQgYWxpYXMgZmllbGQgb24gdGhhdCBvYmplY3QgaWYgd2Ugd2FudGVkIHRvIG1ha2Ug
dGhlIGFkZHJlc3MKPiBzcGFjZSBtb3JlIGNvbXBhY3QgKHdpdGhvdXQgYSBtYXBsZSB0cmVlKSBh
bmQgZmFjaWxpdGF0ZSBtdWx0aXBsZQo+IHJlZ2lvbnMgcmVmZXJlbmNpbmcgdGhlIHNhbWUgZGV2
aWNlIHJlc291cmNlLiAgVGhpcyBpcyBhbGwganVzdAo+IGltcGxlbWVudGF0aW9uIGRlY2lzaW9u
cy4gIFdlIGFsc28gZG9uJ3QgbmVlZCB0byBzdXBwb3J0IHJlYWQvd3JpdGUgb24KPiBuZXcgcmVn
aW9ucywgd2UgY291bGQgaGF2ZSB0aGVtIGV4aXN0IGFkdmVydGlzaW5nIG9ubHkgbW1hcCBzdXBw
b3J0IHZpYQo+IFJFR0lPTl9JTkZPLCB3aGljaCBzaW1wbGlmaWVzIGFuZCBpcyBjb25zaXN0ZW50
IHdpdGggdGhlIGV4aXN0aW5nIEFQSS4KPgoKV2hhdCBJIHVuZGVyc3RhbmQgaXMgdGhhdCB5b3Xi
gJlyZSBwcm9wb3NpbmcgYW4gQVBJIHRvIGNyZWF0ZSBhIG5ldwpyZWdpb24uICBUaGUgdXNlciB3
b3VsZCB0aGVuIGZldGNoIGEgbmV3IGluZGV4IGFuZCB1c2UgaXQgd2l0aApSRUdJT05fSU5GTyB0
byBvYnRhaW4gdGhlIHBnb2ZmLiAgVGhpcyBmZWVscyBsaWtlIGFkZGluZyBhbm90aGVyIGxheWVy
Cm9uIHRvcCBvZiB0aGUgcGdvZmYsIHdoaWxlIHRoZSBlbmQgZ29hbCByZW1haW5zIHRoZSBzYW1l
LgoKSSdtIG5vdCBzdXJlIGFuIGFsaWFzIHJlZ2lvbiBvZmZlcnMgbW9yZSB2YWx1ZSB0aGFuIHNp
bXBseSBjcmVhdGluZyBhbgphbGlhcyBwZ29mZi4gIEl0IG1heSBldmVuIGJlIG1vcmUgY29uZnVz
aW5nLCBzaW5jZeKAlEFGQUlV4oCUdXNlcnMgZXhwZWN0CmluZGV4ZXMgdG8gYWxpZ24gd2l0aCBQ
Q0kgQkFSIGluZGV4ZXMgaW4gdGhlIFBDSSBjYXNlLiAgV2Ugd291bGQgYWxzbwpuZWVkIGVpdGhl
ciBhIG5ldyBBUEkgb3IgYW4gYWRkaXRpb25hbCBSRUdJT05fSU5GTyBtZW1iZXIgdG8gdGVsbCB0
aGUKdXNlciB3aGljaCBpbmRleCB0aGUgYWxpYXMgcmVmZXJzIHRvIGFuZCB3aGF0IGV4dHJhIGF0
dHJpYnV0ZXMgaXQgaGFzLgoKVWx0aW1hdGVseSwgYm90aCBhcHByb2FjaGVzIGFyZSB2ZXJ5IHNp
bWlsYXI6IG9uZSBjcmVhdGVzIGEgZnVsbCBhbGlhcwpyZWdpb24sIHRoZSBvdGhlciBqdXN0IGEg
cGdvZmYgYWxpYXMsIGJ1dCBib3RoIHdvdWxkIHJlcXVpcmUgbmVhcmx5IHRoZQpzYW1lIGludGVy
bmFsIGltcGxlbWVudGF0aW9uIGZvciBwZ29mZiBoYW5kbGluZy4KClRoZSBrZXkgcXVlc3Rpb24g
aXM6IGRvZXMgYSBmdWxsIHJlZ2lvbiBhbGlhcyBwcm92aWRlIGFueSB0YW5naWJsZQpiZW5lZml0
cyBvdmVyIGEgcGdvZmYgYWxpYXM/CgpJbiBteSBvcGluaW9uLCBpdOKAmXMgY2xlYXJlciB0byBz
aW1wbHkgaGF2ZSB0aGUgdXNlciBjYWxsIGUuZwpSRVFVRVNUX1JFR0lPTl9NTUFQICh3aGljaCBy
ZXR1cm5zIGEgcGdvZmYgZm9yIG1tYXApIHJhdGhlciB0aGFuIHJlcXVlc3QKZnVsbCByZWdpb24g
Y3JlYXRpb24uCgotIE1OQWRhbQoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVsb3BtZW50IENl
bnRlciBHZXJtYW55IEdtYkgKVGFtYXJhLURhbnotU3RyLiAxMwoxMDI0MyBCZXJsaW4KR2VzY2hh
ZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRy
YWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMjU3NzY0IEIKU2l0
ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1OTcK


