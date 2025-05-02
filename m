Return-Path: <kvm+bounces-45234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B138AA74AE
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 16:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAC1517E0BB
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 14:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F2B256C76;
	Fri,  2 May 2025 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Ks6KMk1F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2058.outbound.protection.outlook.com [40.92.18.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492692528EF;
	Fri,  2 May 2025 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.18.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746195236; cv=fail; b=je5NSpi673x+duyXd7nBkokxnEZw9O7VKmEHcjq48/VxV+8IWLHQiRtGugVpp9s4tsq1W6zdh1UylsUR8QABHiLrb8iPRmWeN2xnh2hqFWCEGdx6pVFu7MqCoCWSP1g3Q/JX3Wl2yL5H6KfZottcs4WWPHXjmundAt/31DwGsWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746195236; c=relaxed/simple;
	bh=HPDPEHHNfaI6poBnOTe22WZK2ATvE4F3Z6XZcUYUgK8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y+U4dacxMBpifzVu+HYCQclo3ooSOJNKX/Tfq3PT96/CTc2Qe6zezy6ySPv2vuuMb80/ENSkBl4V7X/7lC2oMRXMGiBsUkHLPQin+QQ8xHf8YSXVR9UcwnPKZ+srZ7DQJnUzf9PpN6MbT3c+wLRDzS/1dOt4yW3Me1kLJw6IxPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Ks6KMk1F; arc=fail smtp.client-ip=40.92.18.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxcRbFILndfXwII9UXMBr1c+xXfsvRXh584O1ucvmg6EHyeOZ9/CDCSHgQHBrJT4qHMqDitX1ZBrlW55vO9OEo7ftszcQw/Z20kKAi1FuwG70NtBAbkw85qMYEVHz2Im96kG3trjzjp+NZZYUY9v+eN5F2cHlbS7Bnvcvg8Ai4wugByqHRiX6G3lfCZsV/jBX3fET1ca/qXr30VzyODTkHtrX7k7FBAiPCf5Fc6alN/jnhNEjlJCK1PBEBvfQy6d5m/xn7xhuFDfiSKpM8lL4lDP24mVV5r5fCDxQkOUoaU+1G2NB8g/gosTVyWm/h2r2oTWHinWuP1eptj6AjWazg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXX+mnG2WHo9t8x/IA8X75MEMzdHA2eYKWnGflsfPGc=;
 b=VVclVsNHgYSeKuehzEifcPzdiZQuHVUvDer1btQo+WEoJQGmW+EU0jvbPOJ9U60MpQhSvg3DMsr6MPu89tgeVKuR+vNQR9W6S9gnhFtJBRp5wAPBI9ocadvmwcMulAa+l7BesRW8etXiMNCWjPwYoHQpBw504FMHUvS+9zpL0czYDdKgKUjdtdtmTFG/UU3OypoJT6U9Wcb6KU/A0U8LNmeAf98Ko9QzadpQazyPEZvqz6l0DiMjJ4j72+d3MTsf3nG2xXAqlFXl8a1Wpd/Z8OvFRyny1RCZD8q7B4ERsQJ8baDF4o+rryzzy7KFv8bYi7IVictjAgMdDnl8aozIeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXX+mnG2WHo9t8x/IA8X75MEMzdHA2eYKWnGflsfPGc=;
 b=Ks6KMk1FkgYJMLPJx410idSYwcPSt597Z/J8Gq7kOnOAKprr/dfUNl2HxkCPt+L2wvqmPqR+HMSSbOreeQnuthI5M+rwhw6c8Rug9rjsaqmzlBNGL0sANt+fqeSCCA1NabbkJ0vpEr4mBTcpm7vMAZ8Na1x7FRA54MOh5R4EBBuh/u9yumrz8UOJePtCQRKqpcftkxXxQnFrUdXFCH79srYestSvsuQ0MyL92onzX81eLyDbObGZI3uu6eIzs9HeZU/SD5JoZCFO3ZcOBesOQHV1EW4W5KeYxeT6yLm7JiWnlnrslHdhA6vd/ejRrIfNDLDnMpkPzOTILTsEKpYCWQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by IA1PR02MB9158.namprd02.prod.outlook.com (2603:10b6:208:42d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Fri, 2 May
 2025 14:13:49 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 14:13:49 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: "Xin Li (Intel)" <xin@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "acme@kernel.org"
	<acme@kernel.org>, "jgross@suse.com" <jgross@suse.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "namhyung@kernel.org"
	<namhyung@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "irogers@google.com"
	<irogers@google.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"kan.liang@linux.intel.com" <kan.liang@linux.intel.com>, "wei.liu@kernel.org"
	<wei.liu@kernel.org>, "ajay.kaher@broadcom.com" <ajay.kaher@broadcom.com>,
	"bcm-kernel-feedback-list@broadcom.com"
	<bcm-kernel-feedback-list@broadcom.com>, "tony.luck@intel.com"
	<tony.luck@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "luto@kernel.org" <luto@kernel.org>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"kys@microsoft.com" <kys@microsoft.com>, "haiyangz@microsoft.com"
	<haiyangz@microsoft.com>, "decui@microsoft.com" <decui@microsoft.com>,
	"dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
	"ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>
Subject: RE: [PATCH v4 00/15] MSR code cleanup part one
Thread-Topic: [PATCH v4 00/15] MSR code cleanup part one
Thread-Index: AQHbt1Z92Fo/8zkiv0KdjUYDp5u46rO/aE4w
Date: Fri, 2 May 2025 14:13:49 +0000
Message-ID:
 <SN6PR02MB415763422E06220F9893BD77D48D2@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250427092027.1598740-1-xin@zytor.com>
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|IA1PR02MB9158:EE_
x-ms-office365-filtering-correlation-id: 3cbee300-ee01-41f7-303a-08dd89838f34
x-ms-exchange-slblob-mailprops:
 a+H6FLLcF3qJxlamga53fEWW0rZ5v6J0GJXP+PrHq6TbYR/PNxWQz8Npub/gV3qr+knoDxujy/GsTsGaOt+RDdN+aOx0mxpGGeHjSqIBdEqvu9cO//Sd04ETGN8XX7EG/QjTZdG54SgS7DLF+gLy1w6YE9fXQtoaWG9N0be13CcK53D/vhpX21C8bN8N9IAnML6gmDH/gCU/lTf/tVJf6lgoSmtxe2lQA2p5PAdr09R0z+oXB+/v+0/iWQpv0AjudzDVJ62Z6Fwzoj3raWZ2nAEtXnirfNBqfZotb4NIyJBxUB4CgK/l3lUagQA4NMUz8XMJjopKk0/ua7NctNUSUhex97XMI8j44+qcR8Jk5pHY26/2ZqiL64R/fUt0kyMwgM5AXZV/et5X55VqAKnEtKwjFrtH7u/VaLT6v7AQBGiEHbm5QgN1GDLLUrIHlBcKYkb+bQQ3Ek9qczDo+HcakAf/J+mSb0OUFzB1a3MGjKBc8o0PtvAs31Q/qHSClGc/N15RgMDj7tr2ApETiHZIVxQZmXSxl9yVxVmUh8zkHCvPIW8+sl6XkVzbT6f7B0Qa/vIh/CgNsuiQbcBp4Mf8lx9TylVHWxjVgW0DSWXnfhBWd2xuKuZL5XxFa9XALLY9YrqZ3vSAHhWv26QZEDjqlz8YDla/mN0qbIeKYIlbd0CKMipHKKbYaiSw/82uOMMUDatpQh4pUspxOjgUb8a/dmvEWMn7yAhj4h0dHxFYaBPIYYBTO2RcNw4E60poa/8z1tYxDHLg1HWJiqZvfVJhUicfs3LeDMK4OFK3sQXJw1ox7Q58453UCYkaE5q5IUbN
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599003|15080799006|8060799006|19110799003|461199028|102099032|1602099012|10035399004|4302099013|440099028|3412199025|41001999003|19111999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?5DACIFfVfInExwWvPhGZVFFHufnFUPIPl+lfb3KCfKLiM46EjtNXjkBuA0?=
 =?iso-8859-1?Q?i5MiB4+Cwds48YTLUPVxOjdxyLbqCrpRtxPSbScDUvGQ1QXm7r0SkPW73L?=
 =?iso-8859-1?Q?OIyROJHuAZMjoIAvKuyiV0Afpwg9JSzaOX2DDl40Mqbqub0xLyEnQcFIiy?=
 =?iso-8859-1?Q?H7cMt8j3WhV50YrRBYPvbVjs6b5iFX/14WKbJwxRCVHQEo5/Cc1lTWwOL0?=
 =?iso-8859-1?Q?LH8oCExSnCh2/U4f0R+Cl+kGYj6Md1Khla9O5Fygrx13IayTnbO5+XkZjA?=
 =?iso-8859-1?Q?pWQRjFquwbwKdbjU2eTu12JFYiEyDgF+AzN3tXlXN9FH+II306PTTi9Yr7?=
 =?iso-8859-1?Q?rFYQ9EzlcDF+nlrg6HTpe9NiuETA6EGU+1V2knkCARliS5NZXtUrp5RO58?=
 =?iso-8859-1?Q?DOGox/Ra8lrGlE9wdgsyBPJv6oDjzDbzIqQCZivHozzlYS1ru6HGAdQ5Qo?=
 =?iso-8859-1?Q?bh1Hr5PWBTF8qVI6S02oDSUatxEbjQWOYc581iWTHCkIIqPxvbw0Hact3V?=
 =?iso-8859-1?Q?Hgb9ei1j14HkdlWlZjIAj+4N1FNQ+zqY+tJQuA0GYMY9QJlMdbWL+U0mGB?=
 =?iso-8859-1?Q?4SCNVExftJO+0PM3gEp5fsAiD3OgtugsMNlwVJCAOiS0AcXcxAbqZ98kXN?=
 =?iso-8859-1?Q?TKmy5KSIa6uEVm6n2aq3EqRF6M8vvMfvqSHucl+ZzJn99pPYLc5NVlsEJu?=
 =?iso-8859-1?Q?DyKGUaHRhrqVvYTC/Vp166hbHBMvQXzClnGvvy3DQjPHfT7L64jBNWmRrv?=
 =?iso-8859-1?Q?OrdDOhty3SvtGjg5mct9aeSTslEgHF32l17S1IXbhyNrejWqQ0RPr4yeLs?=
 =?iso-8859-1?Q?wYy1rkwsKm4+tyiNekXPUKp/rsbQGLa/R/m8gEViLDK7o0LiM0aAphJAuA?=
 =?iso-8859-1?Q?+o2RKLVLUmrGL8f9NoMegP6PKhMcUES0m9LLzmxXfEbkTjSQKpZNFWx72w?=
 =?iso-8859-1?Q?YyqEceXMZOFqpXkywOG6p5CYMRROBRYiL8WmR7v3yoaH7HxFD2TwmGTa5d?=
 =?iso-8859-1?Q?rkTHZ5dHSpBrl9np6NUYlTRBjCkauPI5GAPiPVo7z+Plko/WNMQxJSHWsa?=
 =?iso-8859-1?Q?4PZj7xWEQZgHdsemqOWEMMYnqFV3dXg6QU0o7DOF2qUNUk+k9z4995/LJJ?=
 =?iso-8859-1?Q?2DiDlzOQXWxSCZnXWRGtyUg0WHlizRUfzSErsKAI79QbAE526oglsNcFGF?=
 =?iso-8859-1?Q?KAoqEysYC3jMhhWBzMr144DmzkXIkK/x3nyl/WBygNHcYxNQBTsiR+QpoN?=
 =?iso-8859-1?Q?UiFfp1sqvONXcUFJ7SIB76/jAK8W1tLVeke4C2BNafLLTQde8UE/H39spX?=
 =?iso-8859-1?Q?otjIkXkNysed68pjUcGNXXlaqyjP88Ifr5qaMuT5COE2lCYkWylmtfWgk6?=
 =?iso-8859-1?Q?GqolUhrFmY?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?KYlKITl/e96EgPF0jSFlU7K0zZcxHgH9+VQ3/DPucLcZfb4651FTbXZ5ux?=
 =?iso-8859-1?Q?dFPWVuFpAp7jVC6M/B66j21+DENs1c/bmGqw0PBudha6yqQ8xhMWKy7T2s?=
 =?iso-8859-1?Q?MSbYGrJEP2pSpjS6h1YituiMaQxOp9rSL9sLeFNW+Xp1weKTBb74sM5NLC?=
 =?iso-8859-1?Q?ynMet8Z9NXYGhBsubv2ViEWs9051C71l7j8JPzA7/1nsSMOv3URPKHnK2b?=
 =?iso-8859-1?Q?a6jOu3sMEowhrRUpDNEhjQg4eoeufukENJBeji04EAysiMN2/LuyYjFdul?=
 =?iso-8859-1?Q?DsumJI8KbVO1K/zJXDoK6vrsHcdc4C/OaHyhrraBxw9h/T1GXSJr3AC2J+?=
 =?iso-8859-1?Q?8k68aFh+7+NZeYiuquSitRniFu26YYG17K0E1BZowNZyQHViQXTtl1ydX8?=
 =?iso-8859-1?Q?iQQeWe6h+URxDXn8U5Dkkc9hHmCyPhMOp2B+zEuqaVn6n421gP9d9mWEal?=
 =?iso-8859-1?Q?fA/2h692XeYhfO33POp35q/v2JqgOlI3wBBjap8EOjZT7AQWlA7V7dbRkq?=
 =?iso-8859-1?Q?5ba3U9QnoUCg2b05QfTG+WfUyM0wiqfJUq++N3aXXzq733jTzYRmssZTs9?=
 =?iso-8859-1?Q?nBcP+27uNzZpctHpbSmv0g3hCNpdczhDvK9nV4Px+VAPXg9qd89F+kxS/b?=
 =?iso-8859-1?Q?7k8t6v6k3EQj47iLcStVqIl/iF8y43E0L0evOn1xMi2k+yfI+ZFn6ZHCE6?=
 =?iso-8859-1?Q?tV+adzkhDc5lHt8f5hbI3xSXsR1rJlJnDZ2L8ZWH9V68JmFAMGIjSKIXZV?=
 =?iso-8859-1?Q?abm1E+F1a4ou9pHOhUY+nI+yy32Ok/4ok9YkSQjHNqd7IkBU6dZbD2WGqF?=
 =?iso-8859-1?Q?02jMTlIYlStvjHzo3sav1yjgZcOVsDiXJyg8v/MK/fwgux7Kx8zBIEsqgn?=
 =?iso-8859-1?Q?nVU5PEZ1UTorfi4vlvnK2Yoxg7MdQWaEneoX7WGcs2BZZl4gc0O0JDlLHu?=
 =?iso-8859-1?Q?HDsRPhc9Opa+yPJqdxap/aXFUqqxMB2COdgtYAjPMgKkij6Y/OJfS6+UFv?=
 =?iso-8859-1?Q?rZNnNpbuTmaiiV39jpJrKRIjjPvg4jhJ/Gd0KE2cr/OZnvfdMl8kqIC/Gg?=
 =?iso-8859-1?Q?qEjeTju3pEF8jY+vKbOe5VNN6R8YNheeZtyH+K+G1F7jEmzZKEx0IO78Kr?=
 =?iso-8859-1?Q?B6x/6DrDMML9dXnmuG/usrwV9n0rbO5y+MGwGF6GAhXzHoVNLtkklpcTly?=
 =?iso-8859-1?Q?2OvBkCafFjOquWOqchHGrT4ycDBaa1RbhL+bSvWhcSCB6TfhRKuA8rzJCE?=
 =?iso-8859-1?Q?26rAdgteG1rpp74tRPcE8TS3JeNJrKW7yGSIioA7g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbee300-ee01-41f7-303a-08dd89838f34
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2025 14:13:49.2725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB9158

From: Xin Li (Intel) <xin@zytor.com> Sent: Sunday, April 27, 2025 2:20 AM
>=20
> This patch set is the first part of the patch set:
>=20
>   MSR refactor with new MSR instructions support
>=20
> @ https://lore.kernel.org/lkml/20250422082216.1954310-1-xin@zytor.com/=20
>=20
> It's getting *WAY* too big, and whether to zap the pv_ops MSR APIs is
> still under argument.  Dave Hansen suggested to focus on rename stuff
> first, most of which he acked.
>=20
> J=FCrgen Gro=DF also gave his RBs to the Xen MSR cleanup patches.
>=20
> So here comes the first MSR cleanup patch set with version 4.
>=20
>=20
> Changes in v4:
> 1) Add missing includes in a different patch (Ilpo J=E4rvinen).
> 2) Add all necessary direct inclusions for msr.h (Ilpo J=E4rvinen).
> 3) Remove two "else" that no longer make sense (Juergen Gross).
> 4) Collect RBs from J=FCrgen Gro=DF and ABs from Peter Zijlstra.
>=20
>=20
> Link to the previous v3 patch set:
> https://lore.kernel.org/lkml/20250425083442.2390017-1-xin@zytor.com/=20
>=20
>=20
> This patch series is based on:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/msr

Tested this patch set (plus the v4A version of Patch 1) in VMs on
Hyper-V. Tested a normal VM, a TDX VM (with paravisor) and a
SEV-SNP VM (with paravisor). No issues found. Since this patch set is
just a rename, the risk should be low. But I wanted to make sure
there's nothing unexpected happening with Hyper-V and the
synthetic MSRs that it presents to guest VMs, as well as with the
paravisor configurations.

Tested-by: Michael Kelley <mhklinux@outlook.com>

>=20
>=20
> Xin Li (Intel) (15):
>   x86/msr: Add missing includes of <asm/msr.h>
>   x86/msr: Move rdtsc{,_ordered}() to <asm/tsc.h>
>   x86/msr: Remove rdpmc()
>   x86/msr: Rename rdpmcl() to rdpmc()
>   x86/msr: Convert the rdpmc() macro into an always inline function
>   x86/xen/msr: Return u64 consistently in Xen PMC read functions
>   x86/msr: Convert __wrmsr() uses to native_wrmsr{,q}() uses
>   x86/msr: Add the native_rdmsrq() helper
>   x86/msr: Convert __rdmsr() uses to native_rdmsrq() uses
>   x86/xen/msr: Remove calling native_{read,write}_msr{,_safe}() in
>     pmu_msr_{read,write}()
>   x86/xen/msr: Remove pmu_msr_{read,write}()
>   x86/xen/msr: Remove the error pointer argument from set_seg()
>   x86/pvops/msr: refactor pv_cpu_ops.write_msr{,_safe}()
>   x86/msr: Replace wrmsr(msr, low, 0) with wrmsrq(msr, low)
>   x86/msr: Change the function type of native_read_msr_safe()
>=20
>  arch/x86/coco/sev/core.c                      |   2 +-
>  arch/x86/events/amd/brs.c                     |   4 +-
>  arch/x86/events/amd/uncore.c                  |   2 +-
>  arch/x86/events/core.c                        |   2 +-
>  arch/x86/events/intel/core.c                  |   4 +-
>  arch/x86/events/intel/ds.c                    |   2 +-
>  arch/x86/events/msr.c                         |   3 +
>  arch/x86/events/perf_event.h                  |   1 +
>  arch/x86/events/probe.c                       |   2 +
>  arch/x86/hyperv/hv_apic.c                     |   6 +-
>  arch/x86/hyperv/hv_vtl.c                      |   4 +-
>  arch/x86/hyperv/ivm.c                         |   3 +-
>  arch/x86/include/asm/apic.h                   |   4 +-
>  arch/x86/include/asm/fred.h                   |   1 +
>  arch/x86/include/asm/microcode.h              |   2 +
>  arch/x86/include/asm/mshyperv.h               |   3 +-
>  arch/x86/include/asm/msr.h                    | 130 +++++-------------
>  arch/x86/include/asm/paravirt.h               |  57 ++++----
>  arch/x86/include/asm/paravirt_types.h         |  10 +-
>  arch/x86/include/asm/suspend_32.h             |   1 +
>  arch/x86/include/asm/suspend_64.h             |   1 +
>  arch/x86/include/asm/switch_to.h              |   4 +-
>  arch/x86/include/asm/tsc.h                    |  76 +++++++++-
>  arch/x86/kernel/cpu/amd.c                     |   2 +-
>  arch/x86/kernel/cpu/common.c                  |  10 +-
>  arch/x86/kernel/cpu/mce/core.c                |   6 +-
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  25 ++--
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c        |   2 +-
>  arch/x86/kernel/cpu/umwait.c                  |   4 +-
>  arch/x86/kernel/fpu/xstate.h                  |   1 +
>  arch/x86/kernel/hpet.c                        |   1 +
>  arch/x86/kernel/kvm.c                         |   2 +-
>  arch/x86/kernel/kvmclock.c                    |   2 +-
>  arch/x86/kernel/process_64.c                  |   1 +
>  arch/x86/kernel/trace_clock.c                 |   2 +-
>  arch/x86/kernel/tsc_sync.c                    |   1 +
>  arch/x86/kvm/svm/svm.c                        |  34 ++---
>  arch/x86/kvm/vmx/vmx.c                        |   4 +-
>  arch/x86/lib/kaslr.c                          |   2 +-
>  arch/x86/mm/mem_encrypt_identity.c            |   5 +-
>  arch/x86/realmode/init.c                      |   1 +
>  arch/x86/xen/enlighten_pv.c                   |  58 ++++----
>  arch/x86/xen/pmu.c                            |  72 +++-------
>  arch/x86/xen/xen-ops.h                        |   5 +-
>  drivers/acpi/acpi_extlog.c                    |   1 +
>  drivers/acpi/processor_perflib.c              |   1 +
>  drivers/acpi/processor_throttling.c           |   3 +-
>  drivers/char/agp/nvidia-agp.c                 |   1 +
>  drivers/cpufreq/amd-pstate-ut.c               |   2 +
>  drivers/crypto/ccp/sev-dev.c                  |   1 +
>  drivers/edac/amd64_edac.c                     |   1 +
>  drivers/edac/ie31200_edac.c                   |   1 +
>  drivers/edac/mce_amd.c                        |   1 +
>  drivers/hwmon/hwmon-vid.c                     |   4 +
>  drivers/idle/intel_idle.c                     |   1 +
>  drivers/misc/cs5535-mfgpt.c                   |   1 +
>  drivers/net/vmxnet3/vmxnet3_drv.c             |   4 +
>  drivers/platform/x86/intel/ifs/core.c         |   1 +
>  drivers/platform/x86/intel/ifs/load.c         |   1 +
>  drivers/platform/x86/intel/ifs/runtest.c      |   1 +
>  drivers/platform/x86/intel/pmc/cnp.c          |   1 +
>  .../intel/speed_select_if/isst_if_common.c    |   1 +
>  .../intel/speed_select_if/isst_if_mbox_msr.c  |   1 +
>  .../intel/speed_select_if/isst_tpmi_core.c    |   1 +
>  drivers/platform/x86/intel/turbo_max_3.c      |   1 +
>  .../intel/uncore-frequency/uncore-frequency.c |   1 +
>  drivers/powercap/intel_rapl_common.c          |   1 +
>  drivers/powercap/intel_rapl_msr.c             |   1 +
>  .../processor_thermal_device.c                |   1 +
>  drivers/thermal/intel/intel_tcc_cooling.c     |   1 +
>  drivers/thermal/intel/x86_pkg_temp_thermal.c  |   1 +
>  drivers/video/fbdev/geode/display_gx.c        |   1 +
>  drivers/video/fbdev/geode/gxfb_core.c         |   1 +
>  drivers/video/fbdev/geode/lxfb_ops.c          |   1 +
>  74 files changed, 308 insertions(+), 295 deletions(-)
>=20
>=20
> base-commit: a5447e92e169dafaf02fd653500105c7186d7128
> --
> 2.49.0
>=20


