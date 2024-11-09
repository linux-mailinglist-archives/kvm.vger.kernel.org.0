Return-Path: <kvm+bounces-31349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E0B9C2B79
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 10:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 962E11C20F82
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 09:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A3F148FE6;
	Sat,  9 Nov 2024 09:49:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E1713C9A9
	for <kvm@vger.kernel.org>; Sat,  9 Nov 2024 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731145750; cv=none; b=RBVm1/ttGsgOkHoO8KDgTbzKSg+b90JwS9VEox0z21fkQk9GjpEvZmlmpQvB6F4r8WdGtURL2XAX8cVCmFvLNe7FJWhLtvuFumbdfzs2O0OUElpZD9frT0NQXYlpLmGH2yU6APWqmpRA1Kn2SqMdm0JHUmT3Vpg+IEV/BPYMZ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731145750; c=relaxed/simple;
	bh=envogq3++8LebNDrbmjeOhu6ssKCirUoCREvmKhTbuU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=nKp8MuN2XpN9f9HmkN8wMs8r36S+0UL7t0hEaEi1787x7zEIr0CJnVUH0s8+9svNSkGcWqMp04U9YSi+tGQpJo+0vcRi2BlCNFO6VwdSFUFDO32XcNzA2CwPY215n0++clspksZNIB1oSc3mOIzbMATiKs7Uji/209NjysGcM14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-94-S7JoMMDMMHS9cQ8RB_P-nQ-1; Sat, 09 Nov 2024 09:49:05 +0000
X-MC-Unique: S7JoMMDMMHS9cQ8RB_P-nQ-1
X-Mimecast-MFC-AGG-ID: S7JoMMDMMHS9cQ8RB_P-nQ
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 9 Nov
 2024 09:49:04 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 9 Nov 2024 09:49:04 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Haris Okanovic' <harisokn@amazon.com>, "ankur.a.arora@oracle.com"
	<ankur.a.arora@oracle.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "arnd@arndb.de"
	<arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>, "cl@gentwo.org"
	<cl@gentwo.org>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "konrad.wilk@oracle.com"
	<konrad.wilk@oracle.com>
Subject: RE: [PATCH 2/5] arm64: add __READ_ONCE_EX()
Thread-Topic: [PATCH 2/5] arm64: add __READ_ONCE_EX()
Thread-Index: AQHbL7EN8akEXkbcIke1iZkICXXDerKutxnw
Date: Sat, 9 Nov 2024 09:49:03 +0000
Message-ID: <c2bee816a4a44d55951ca839fea0a6dd@AcuMS.aculab.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
 <20241105183041.1531976-3-harisokn@amazon.com>
In-Reply-To: <20241105183041.1531976-3-harisokn@amazon.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ueYVZkhixMSNNDT1vjfWyMWYftorTYz9sdihYJUnRh4_1731145744
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Haris Okanovic
> Sent: 05 November 2024 18:31
>=20
> Perform an exclusive load, which atomically loads a word and arms the
> exclusive monitor to enable wfet()/wfe() accelerated polling.
>=20
...
> +=09atomic ? (typeof(*__x))__u.__val : (*(volatile typeof(__x))__x);\

That doesn't do what you want it to do.
(It is wrong in READ_ONCE() as well.)

?: is treated like an arithmetic operator and the result will get
promoted to 'int'.
Moving the first cast outside the ?: probably works:
=09(typeof(*__x))(atomic ? __u.__val : (*(volatile typeof(__x))__x));

   David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


