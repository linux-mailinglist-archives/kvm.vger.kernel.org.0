Return-Path: <kvm+bounces-44844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3225DAA41C3
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 06:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B33F14E112F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 04:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3031DE884;
	Wed, 30 Apr 2025 04:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="s1LPyTtz"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010003.outbound.protection.outlook.com [52.103.12.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01DA32C85;
	Wed, 30 Apr 2025 04:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.12.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745986860; cv=fail; b=ACkfV35XPtc959Gip0vMi/PtyFno4BeNix7V921rG49hi4dV8MFcKN5+nldLBdBi3J6Cbh/hje8KuxfrwtwOQNo5zbx516mHCqbUb9cBpGujzzvF5kqXpm2rM6ZT7736Vwr6Qw6wjQJv14FILf0/1UYIeXOoG7zqwzRKNZExjT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745986860; c=relaxed/simple;
	bh=KWYz4HiFOZ3yX4G0KklaWry7u3sF9v0oz96ipPJ0Zqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J6ft6fIdRmo6TBDyolVI52SYB35Vx2j2uuTn1stfU/bT/xny/v1j7YSZuYbIDNwOJhvZMTkOcgnZq38l1E9eFBRQXhJLHn5Nf5TrIoz1Ipkw7Q632PmNqYPjCbGFdZqhyNLNoYjyxZwuvR0PscnPYkOL8Ld1TT8csO5hieM32Vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=s1LPyTtz; arc=fail smtp.client-ip=52.103.12.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ga/E4WGXqv5N4wpBc8DzychM63nQINi3PIZyQhvHEa/DI9rN/3dze5jz+be4ovRww5u7oV93YGi2/72Sz/v4GhJuYuG1Yxdk4vg9qGfOiAJqSGv/tamywScYyFaAyAJWWWe8+xE6gh3JhEuyB/RAWWoNz4GcxeGJbcqFOoWCtiHoWR5FJNXKbUafO9rUf/3A8r4Vdm4QujcxJOkUgMP2OSAmV2PB24uvvXFAhFeQBTojWVg0lfJ2MpNVv0YCPU/e+ngshY7cjd6AfzrRQ2enHaZ2y787IrXA8/gCVQzkOe/DPXoT3zyW0/8YYGnLZQn84Ltm8sJeYXJ7ZNYjJSHMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvK2r+/hEf2JsEW/4ID2HtZg7/lC0WNw/mRBGzmJ9UI=;
 b=HHSaZX2FdcEfRpDkg+44rRHuksrqoKqCQVU4akcJXqYupuuu8NeIAFCo2x5WDP3sMG7XuM+RBx2rk2fLzoVMmsiIBqrp/spZE0PkZbXctGsadAUn2YF/9xJVKY1YoOKmKqcBVVXfdAvtwpE0q1cqA19VUz7YK3ag+gUktPqn9wty8CXZc18Sr5rrwmKY2Mw3miOv7gv2w6rdwQaRP4v0ENP6V8K14QrSUHw1c1fhfla4r5seHFMMzHpV9BO7MrF7kKCU0eTexEdv5wQBlQY7HJNaznSaVG6bSTr/KtcfM6ijohzADpOx7p0t2Rebew4kXdk1Wj1yyKuS676JLToDYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvK2r+/hEf2JsEW/4ID2HtZg7/lC0WNw/mRBGzmJ9UI=;
 b=s1LPyTtzZMFRmWOY43AU9AHEdyANDTA2OH+M60JwjcHqAulz897g+WPHljm3SWLHlWD0DeZ5K/wncSS2kUtNYtjYI2ugYq/CuppAJUqbqXrzy7m/33EwkwATwHm2p+Lz3HYtKIiq1yS36yn4b88GL3g7aM049VGivZpb0IF7vU++ten7/7aB4rSvR5cL8pQCx/Dxr7HN51+xw2+ZXyxdXG+AP5pnM5c7hbL65j9yvB1nzOe9k3GFGXCUhfb+eNaJgoHWL7Rf6SiZ7QeLfJqoiGEuB/xAPexGd4Etmzysf292N3/HpjnSVN1EZW/J0jj5R54qnZ9vY85UJW0PkZh2Xw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CY8PR02MB9428.namprd02.prod.outlook.com (2603:10b6:930:75::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.18; Wed, 30 Apr
 2025 04:20:54 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%3]) with mapi id 15.20.8699.008; Wed, 30 Apr 2025
 04:20:54 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Xin Li
 (Intel)" <xin@zytor.com>
CC: LKML <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-hwmon@vger.kernel.org"
	<linux-hwmon@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
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
	"dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>
Subject: RE: [PATCH v4 01/15] x86/msr: Add missing includes of <asm/msr.h>
Thread-Topic: [PATCH v4 01/15] x86/msr: Add missing includes of <asm/msr.h>
Thread-Index: AQHbt1dCxRX1SSJBLkyUN2kSfV4ndLO6aEuAgAE1BbA=
Date: Wed, 30 Apr 2025 04:20:53 +0000
Message-ID:
 <SN6PR02MB4157EA2E3B827141588DA310D4832@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-2-xin@zytor.com>
 <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com>
In-Reply-To: <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CY8PR02MB9428:EE_
x-ms-office365-filtering-correlation-id: 3d0d210a-0c2d-4037-26cd-08dd879e65cb
x-ms-exchange-slblob-mailprops:
 70qbaZjg4mvbis83qL2U5WvEmRMBS6Og9W/3014Us/uuwmhN2UMLRJLUTlmuqN5h9ehr8uc6w6voiES8QxIGpN0rfCSOM9sOOHGLjemzx5vQcTGO902AiVqPz2A3JQjnNpxe+TmFCiX45epvb1/3E/S3dfmB2IMc6Sb5ndzUEmhxssKtmEvp14NWRaHnFrw0WfyKXLFWZHE9acl4TNTQEsEu2HU3f0UKjU/UX+YJwX4k3uWTUqE0DZHWP69nVlSBLjWeBqPlZ6K1qpn77jaYLfB3Bz0dHAjXzcVxdtqb6xdBDnbSc0yNWRaBrkzWWu+H254LnHV+pHFD/oi59WsjdoBkyG6V20uf+TedjnyD3uFNl6uy6HCeWUb3GCb+Lb9FedlS9/k31aK78fViFEM9TLpwgQO5hAzNa+K5Web9rzREs0PzO5c6XoOeyaNpFknp3pT136KOQpfNix+EqD3O/JhBn7qKAgHbmirv3yzuoEtWGcn68EyMRjFfsGfLhZfEkseUv0Az7QRsqcwv3Q9HNGBWa3Xw5TjT7IVQn6byPyF/rDDHJXJb+Mwu4mQKJbokv5eZrLVW2qFYwPw7+8vJGo55OGPMzuDsYDZBugm826HQBw+0h8GCwcvrySV2YrD8kcpgITqSZ7kSsqNgyf9Jnbw4iT7xLfzQeVeRqwCe6RH/9SRKDXNJ4nD+ryVAdkLeYUb7GEDe/R3Z7K5AeleYFv+p4EhZtZdU3bI6e82Z4MHFIA+tdk5pzQ==
x-microsoft-antispam:
 BCL:0;ARA:14566002|12121999004|19110799003|461199028|15080799006|8062599003|7072599006|8060799006|102099032|3412199025|440099028|19111999003|21061999003|12071999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?sAHcTpNlk86YDWmdOjpjnVGfqswYWqUmVVV01MSP5d+6CLugqu9DDRrRpW?=
 =?iso-8859-1?Q?uZZA1rl6GPfrNusZXaarGueIpwi8Q5ayKtp626EpHtCKvNCh/z9omy7Ip1?=
 =?iso-8859-1?Q?dNi9Vl1FcWAtvxkWHSdNEE7Hfxv/zNDKmPnqFIaBWnb/8w/M+Fo8/DhAkD?=
 =?iso-8859-1?Q?x1kOGshNgwS6F7jQSuf9Pa6AIACpt8WCaHG0f8XKmVWymesSmiBRtrbPmX?=
 =?iso-8859-1?Q?pjRhOfEe7fvI4MbaaeYiDrXKKltX9xDawlEiP2muaG4tDot/vad4XOzDV5?=
 =?iso-8859-1?Q?oDxyzf5WbsSzQeTrF9DR//PpQaO0MC6cX1Y0WDZ07zGJoAe1cCs8tiixaI?=
 =?iso-8859-1?Q?WgmHuWq+o2li88q4iq+9jlPtL3AEJCJMERnHfaHoPV6NY0awa6rwtI8DYp?=
 =?iso-8859-1?Q?wVmiG0VKOYaiVszrc1JHCnb2wUZAORWUwRsJBANUc7z945TjgjkIx6fNRx?=
 =?iso-8859-1?Q?PyRkALMTUxKeqcnJM7Jy/VymuYrnNoPHNm6h59YFI28VA69J36aUTug/Y1?=
 =?iso-8859-1?Q?hbDJKl9jFRUm6WrQbFvZN6omiAVR8PpCUWRljjjhgLCVIo5ta0QcDlPXjs?=
 =?iso-8859-1?Q?rsfmnL1o6skGx0vaa06y33p25QviLyrlqdev616BmETRtJ1YiGTwuD4GSo?=
 =?iso-8859-1?Q?LaueymHkPhouAVIGnKzPyS9hqFmkql7N53RaaAM5lJkf9xtQpExfrmq5zd?=
 =?iso-8859-1?Q?1jeqo+wfO83sVMoF7ha+nOa34GqzbtcJa2sEckN/90lbL5fRzgK/CsADRi?=
 =?iso-8859-1?Q?vHaMVScui45ypd0/T+g+xcnRqNdiJNhsC4E5Qz2EDI7+66pyxiTXigV2ds?=
 =?iso-8859-1?Q?w6FNILVJljSPTqKp/8NoUgVtHYPs7DzFYWyoH8PultihFHpn9giSm+ddPP?=
 =?iso-8859-1?Q?s4sst1NTjetFCCwqpp+GtZ8XOQ31E3s9GKHbN1lcGDhleXtsAMvPpw9fp+?=
 =?iso-8859-1?Q?84PamiJ43E7lAfpHbeSbwtZ78XHQh2a1aBRb1DfP9WtmymvkZ+5hiQ+Jtt?=
 =?iso-8859-1?Q?exCggCOz3vT5JSUMvjl9vC9i5WgIh+VrOo4/bWg/4zeaXIJBUa7u+Txtk8?=
 =?iso-8859-1?Q?3Ct8MUCtP3mg0j0gqB6TTFxY3IZHSrJ+uDIuepJd+8BqnErUTzv2cdODhU?=
 =?iso-8859-1?Q?AxL+0XrpyWwdc3zBYWl1cu/OmIkj8gdyAh2cKKG1ljZFKy0eefh/nD9N2Y?=
 =?iso-8859-1?Q?WBq1xgdNiTFaecZQGenBafpOQalkmcrrn8IkFuPwY3Ct0rvfhqzrSxVw3v?=
 =?iso-8859-1?Q?hscSj88xP6N7FqaOLiwt1fWf9jRQTG9RH0QKSkH4Q=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?46i1sKkGUf2Kl0zhlolABqRmtZzPSJWRjAt3BFRy8ECcgF+mQjobIr8cFQ?=
 =?iso-8859-1?Q?+xL9oK/IIbRvPY+mKZFTmaj2v7xwVnxmp5FLnoEHtjFro3dm6V664MBU+3?=
 =?iso-8859-1?Q?+wPEZkUsza3xlJCNL9TMoEJDpLke0A+mmjcDkB4kRERzec3xK39migWixJ?=
 =?iso-8859-1?Q?pg5WLKFxzHTPGcw1w3nXH9OHxmF3MHrXV2GSMo5xDw+ZR674xPhR3HKi+3?=
 =?iso-8859-1?Q?byXeWGntA73Y90gvA/KzHl27/g3QhxIbumHYJx02+nRDrPELJs5pOgfKhg?=
 =?iso-8859-1?Q?8as9Bh0H2ZTBKlto5EOzn9Sj+k9RlFIvp2h+TdByzwptC7+7jFk2Mmx9hf?=
 =?iso-8859-1?Q?ahypKdmrVptvlkMPgCJyizYP5ZAqlk3abvjfVjqDqlb6jZneUcJcyEByX9?=
 =?iso-8859-1?Q?1Pb+zpJtWKqj2u7rSUjduaK4jqrfZ/a2iY5G28cGyaUlHkIwZmU2kj/gYq?=
 =?iso-8859-1?Q?CEbNY10bJ8JbiO1eRntgpbuCj/c2VX5g+p6o6S5kvJ2iZ1TKI+8rTXyYEw?=
 =?iso-8859-1?Q?sfgLmQWoIhX/O/4kPtMMUS0GqX8pdwPHqalj3PlCd2XwMLG2Un7beBj5u6?=
 =?iso-8859-1?Q?fVNgjaQy/9+r1Nrkaqoh8nTd4pi3Y71sGpRLDhBN9tfZ9DHynMkc9gLNXV?=
 =?iso-8859-1?Q?ZLoTxKuHu2PCJuvV73F7LJNO1AN9ctVA66T9Y5CZv37eA0wxjOnJAXy9L9?=
 =?iso-8859-1?Q?+X2JXWnztCyw8Oau0IG/Db/UMzkXXXQ0ChVqnz40TvV/MlvlzKHhgegih3?=
 =?iso-8859-1?Q?qjTKwx2HkgXvMOHanw5rUpwOiTDWV0uyc+kAoOeUmZu68Uri9XOPO7XVd4?=
 =?iso-8859-1?Q?MF1FFTnKeanbFYR7K0SEvJr7gOTHl6rF0n4hb4A7olHugY6esyZjj//LmC?=
 =?iso-8859-1?Q?WuRnkqxBF7voOdjtfGN/YqMqHJ8m50DqyqoTnWtFNE05mxqFNmW/oxghUb?=
 =?iso-8859-1?Q?/IbP705YFTxIZyHYnEw+ClfPc9B+HvOSxdAVPVGbiZwWqp16xrAN9fxEe4?=
 =?iso-8859-1?Q?Z1cSzpkkI4v4KfI53O1bcxI7Nx/8xDZZVf7wE6+D2s4FGibs3bQMknxKaf?=
 =?iso-8859-1?Q?N4jVzDAQb32d4v0nmFp+Pj7NVGYtGk391AOzFilb844Vu9pgakBFAiHVjK?=
 =?iso-8859-1?Q?vxivww+0PJrUeh/POy7j7pEyrr/rYsJvl/6omeOiM9K79pBUxEHyBXaW4m?=
 =?iso-8859-1?Q?PEGHpafia27LjTH2/m1MbQ3fyjNt7F+AkithQGsohmUxpLpSmgPdAmdaw5?=
 =?iso-8859-1?Q?D7NbEddypJrHYEzE0DKSxbU0+RQIMRlu4i+2edvB0=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0d210a-0c2d-4037-26cd-08dd879e65cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 04:20:53.8258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR02MB9428

From: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com> Sent: Tuesday, April =
29, 2025 2:46 AM
>=20
> On Sun, 27 Apr 2025, Xin Li (Intel) wrote:
>=20
> > For some reason, there are some TSC-related functions in the MSR
> > header even though there is a tsc.h header.
> >
> > To facilitate the relocation of rdtsc{,_ordered}() from <asm/msr.h>
> > to <asm/tsc.h> and to eventually eliminate the inclusion of
> > <asm/msr.h> in <asm/tsc.h>, add <asm/msr.h> to the source files that
> > reference definitions from <asm/msr.h>.
> >
> > Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> > Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >
> > Change in v4:
> > *) Add missing includes in a different patch (Ilpo J=E4rvinen).
> > *) Add all necessary direct inclusions for msr.h (Ilpo J=E4rvinen).
> >
> > Change in v3:
> > * Add a problem statement to the changelog (Dave Hansen).
> > ---
> >  arch/x86/events/msr.c                                         | 3 +++
> >  arch/x86/events/perf_event.h                                  | 1 +
> >  arch/x86/events/probe.c                                       | 2 ++
>=20
> Under arch/x86/events/ a few files seem to be missing the include?
>=20
> >  arch/x86/hyperv/ivm.c                                         | 1 +
>=20
> Also under hyperv/ not all files are covered but I'm a bit hesitant to
> suggest a change there since I'm not sure if they (hypervisors) do
> something special w.r.t. msr.

I've worked on the Hyper-V code in Linux for 8 years or so, first as
a Microsoft employee, and more recently as a retiree. :-) I'm not
aware of anything special w.r.t. MSR access for Hyper-V guests.
All the normal Linux code for accessing MSRs just works. Hyper-V
*does* provide a set of synthetic MSRs that are unique to
Hyper-V, but they are also accessed using normal Linux code. Of
course, at runtime the access to these synthetic MSRs always
traps to the hypervisor.

I'm planning to apply Xin Li's patch set and make sure nothing
breaks for Hyper-V guests, and particularly when running as an
SEV-SNP or TDX guest. Hopefully I can do that by early next week
at the latest.

Michael

>=20
> >  arch/x86/include/asm/fred.h                                   | 1 +
> >  arch/x86/include/asm/microcode.h                              | 2 ++
> >  arch/x86/include/asm/mshyperv.h                               | 1 +
> >  arch/x86/include/asm/msr.h                                    | 1 +
> >  arch/x86/include/asm/suspend_32.h                             | 1 +
> >  arch/x86/include/asm/suspend_64.h                             | 1 +
> >  arch/x86/include/asm/switch_to.h                              | 2 ++
>=20
> arch/x86/kernel/acpi/ ?
> acrh/x86/kernel/cet.c ?
> ...
>=20
> There seem to be quite many under arch/x86/ that still don't have it, I
> didn't list them all as there were so many after this point.
>=20
> But that's up to x86 maintainers how throughout they want you to be.
>=20
> This command may be helpful to exclude the files which already have the
> include so you can focus on the ones that may still be missing it:
>=20
> git grep -l -e rdmsr -e wrmsr | grep -v -f <(git grep -l -e 'asm/msr\.h')
>=20
> >  arch/x86/kernel/cpu/resctrl/pseudo_lock.c                     | 1 +
> >  arch/x86/kernel/fpu/xstate.h                                  | 1 +
> >  arch/x86/kernel/hpet.c                                        | 1 +
> >  arch/x86/kernel/process_64.c                                  | 1 +
> >  arch/x86/kernel/trace_clock.c                                 | 2 +-
> >  arch/x86/kernel/tsc_sync.c                                    | 1 +
> >  arch/x86/lib/kaslr.c                                          | 2 +-
> >  arch/x86/mm/mem_encrypt_identity.c                            | 1 +
> >  arch/x86/realmode/init.c                                      | 1 +
> >  drivers/acpi/acpi_extlog.c                                    | 1 +
> >  drivers/acpi/processor_perflib.c                              | 1 +
> >  drivers/acpi/processor_throttling.c                           | 3 ++-
> >  drivers/char/agp/nvidia-agp.c                                 | 1 +
> >  drivers/cpufreq/amd-pstate-ut.c                               | 2 ++
> >  drivers/crypto/ccp/sev-dev.c                                  | 1 +
> >  drivers/edac/amd64_edac.c                                     | 1 +
> >  drivers/edac/ie31200_edac.c                                   | 1 +
> >  drivers/edac/mce_amd.c                                        | 1 +
> >  drivers/hwmon/hwmon-vid.c                                     | 4 ++++
> >  drivers/idle/intel_idle.c                                     | 1 +
> >  drivers/misc/cs5535-mfgpt.c                                   | 1 +
> >  drivers/net/vmxnet3/vmxnet3_drv.c                             | 4 ++++
> >  drivers/platform/x86/intel/ifs/core.c                         | 1 +
> >  drivers/platform/x86/intel/ifs/load.c                         | 1 +
> >  drivers/platform/x86/intel/ifs/runtest.c                      | 1 +
> >  drivers/platform/x86/intel/pmc/cnp.c                          | 1 +
> >  drivers/platform/x86/intel/speed_select_if/isst_if_common.c   | 1 +
> >  drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c | 1 +
> >  drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c   | 1 +
> >  drivers/platform/x86/intel/turbo_max_3.c                      | 1 +
> >  .../platform/x86/intel/uncore-frequency/uncore-frequency.c    | 1 +
> >  drivers/powercap/intel_rapl_common.c                          | 1 +
> >  drivers/powercap/intel_rapl_msr.c                             | 1 +
> >  .../thermal/intel/int340x_thermal/processor_thermal_device.c  | 1 +
> >  drivers/thermal/intel/intel_tcc_cooling.c                     | 1 +
> >  drivers/thermal/intel/x86_pkg_temp_thermal.c                  | 1 +
> >  drivers/video/fbdev/geode/display_gx.c                        | 1 +
> >  drivers/video/fbdev/geode/gxfb_core.c                         | 1 +
> >  drivers/video/fbdev/geode/lxfb_ops.c                          | 1 +
>=20
> Under drivers/ this looked pretty complete. Nice work.
>=20
> Acked-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com> # for pdx86
>=20
> I also noticed these files might not need to include msr.h:
>=20
> drivers/cpufreq/elanfreq.c
> drivers/cpufreq/sc520_freq.c
> drivers/accel/habanalabs/common/habanalabs_ioctl.c
>=20
> ...so if you want, you may consider optionally adding a cleanup patch to
> remove the include from them.
>=20
> > --- a/drivers/video/fbdev/geode/gxfb_core.c
> > +++ b/drivers/video/fbdev/geode/gxfb_core.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/cs5535.h>
> >
> >  #include <asm/olpc.h>
> > +#include <asm/msr.h>
>=20
> In wrong order.
> >
> >  #include "gxfb.h"
>=20
> --
>  i.

