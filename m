Return-Path: <kvm+bounces-45433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9AAEAA997F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 308AA17D03C
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 16:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F5725DCEC;
	Mon,  5 May 2025 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vCtMBS4I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A3189916;
	Mon,  5 May 2025 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746463350; cv=fail; b=WOtM8F2aWGU7Oc6PNNiOblg694o5rwCTzbjYR3xXcX9zhTvv2Rrqtx1W/w0mVhd4MsrREg1NFpg3D1GBr2U6COAsoHWD3RBCHr1bmSfzETWXyQCCixFj0hasjrvwUktfFx1+5QRELOf+qGTr2oppyhd6f4bKTfs+QX+OJUqgN00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746463350; c=relaxed/simple;
	bh=7mv15oBoW4DR0vQt7FM4wfVqTnOWtQSftyQZsYa9fD4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P1q5vc4UdVUQqBfGqK1YI7F3S79e/EMEo6cIujiIBEa4tBKLmH0WDFzYk0hi3CMvFF4yDeyNu2FRpkq6kXpgQ4MkVZar+9AqhkOKXC9/PKPb0lv0JglBrixsmwKxY4c+oVRlE2FKu3OrMe2qVAvvJZsiBttnJeEHYD2/Pju+dI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vCtMBS4I; arc=fail smtp.client-ip=40.107.243.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dSXOB4MgOW/nN+Ma27YmQOqllnb35Q+FEicVAxuazdeEehJYPLd2aejGGOO1rWxsrVnBHv1bRd4RkmtXBsV9i3QgboX8H7IH6F5MKjOc03l8qsGHMs9VqsYnT1g+nJmSHZmTozHgxYWFV/uK6MZHMddqEkrT5hxZ0H/N1J9jxMZJ6YltsARuiMya1mTmSrvpM72HkMg75bXR9RiPAUvIgZH62JB/KMjr3LOnkmGrUv8xMd86/kes26ceSB/nwrVagrjV+GjdFx8i1cGdBAQZdxhGXFO0k7FYvNJwokUiKgqJMyNupfQRBD1kz/Tjc1kg6u/mo2mINRYf/gznqSmx9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MqPHQxpDyKt0Y/znhm+YfUlnZTH+Tkz0cNBONerM/U=;
 b=hVP96UHSWLFxtZn1Op37bUtJttx6EcAXrKCNeUNZBnFVF5W2I63Q56iCZz5IybA4PudsL1lfl/SlTBb0N7d9AwuZ+VQNacX6oKDUHSIL6hvddpUE4AQIY/ScAUdxV4VZ4Alws/9MsqPp+3bvoNYDEmITJd+A0LM6ynNEuQ1JRdp7K2FiD8SPWuAurdKJoS1eo4ReuN1+hR0xPuN532k7j4+VXLfkwn6F+nXaJt9hZeQi1v+ee+AFABhxkp3eOWqViEO5HJsudk0sC/u+8HGNDbyELKsJD/tonG3goQbuBIVgaM4mz+qX+pYBk2NkC/lkhy7gqd7BKjMe6NCBzjNHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MqPHQxpDyKt0Y/znhm+YfUlnZTH+Tkz0cNBONerM/U=;
 b=vCtMBS4IPk9SDqRILRlB6hVcjfv8jQH4aMsqsB7yt2Cvm2wILEKoP/kxFoItFT3DkG9vxkomfUmXmn5kSSXTn8c6gC0YupaDSLRXuNNJ3zVYsixb2JMm0QbvSYEWYBuOYOeD0GaddzQGBPODgnyW57Xu1sKQqJizlm9ny9TL0BA=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by DS7PR12MB5837.namprd12.prod.outlook.com (2603:10b6:8:78::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Mon, 5 May 2025 16:42:26 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%3]) with mapi id 15.20.8699.024; Mon, 5 May 2025
 16:42:25 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Borislav Petkov <bp@alien8.de>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Patrick Bellasi <derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>, Michael Larabel
	<Michael@michaellarabel.com>
Subject: RE: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Thread-Topic: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
Thread-Index:
 AQHbuQpLRWo4+2NoWUeyEAzbBBOhObO83m2AgACS9QCAAJCSAIAGL9mAgAADC3CAAA79gIAAAeYg
Date: Mon, 5 May 2025 16:42:25 +0000
Message-ID:
 <LV3PR12MB9265029582484A4BC7B6FA7B948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
 <aBOnzNCngyS_pQIW@google.com>
 <20250505152533.GHaBjYbcQCKqxh-Hzt@fat_crate.local>
 <LV3PR12MB9265E790428699931E58BE8D948E2@LV3PR12MB9265.namprd12.prod.outlook.com>
 <aBjnjaK0wqnQBz8M@google.com>
In-Reply-To: <aBjnjaK0wqnQBz8M@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=3fb7e713-41a5-4c91-b627-eef1d756571c;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-05-05T16:36:52Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|DS7PR12MB5837:EE_
x-ms-office365-filtering-correlation-id: 3a6af677-8c9c-419d-466a-08dd8bf3d111
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?HGjmjlpH80ateCziPmRaT1KyeN+z8OkX0GAcoxavC/cCfFOAGnTY21hmnnlu?=
 =?us-ascii?Q?iA1ExQS8/MjiBIpXklGf3tbVJvyuSQj7OGc+xpxWu5rY4B5W64J1523v+1v/?=
 =?us-ascii?Q?Y1t65vPt65bwH7eVKjBJOIeHjcL2jJBs+e+chXqJXNjS42kl8XltSvQNpo8r?=
 =?us-ascii?Q?657u/m05uYumshxVnyFmrrr/qatMvTqPXBxrcSW56LiHVQ70qkF7QAic7GDZ?=
 =?us-ascii?Q?vV8GCD9TYCc65+G5t6BHfgHBsNwJhX2R9k/ErraxWQZhoEurWbJRf+wgDiDx?=
 =?us-ascii?Q?Efmva8R48/iR30SUuuxNgAlKXbr0nwm2JuGlJq014x7InERZUMTkPlPw5SIT?=
 =?us-ascii?Q?RwORxz1EQuWvhO6ISwLKxO3OkinYCyhQsJ/rveo/upI959P1D5n4DQUeDPLI?=
 =?us-ascii?Q?JnFdExIFHvDbFU7O8xOz+/pMdIP3KldOW/tMviSDin2Gv8BfrDusF49zq9lP?=
 =?us-ascii?Q?TwUE8PsWgw+myAuAaNYUiZXrCcu2hhX0A1DM5WqXXMYdIajXyq6dACGtuo7B?=
 =?us-ascii?Q?tCKFbu355adtZwK8WrQEEpgK8CI/KyRC6HgmV9XbIkL1auRN1yMLZAOq5qg2?=
 =?us-ascii?Q?4KNFjPLYEYrn5NXC/12NmeJjRWOQertowSGSx7M3+GFQEQ2TuccEf3/DkGRm?=
 =?us-ascii?Q?Wj58xxQa+sBHOcw1OzDwmRdFRxBx5WJUXJTCllABaPHs2HSbzS+AtO/422B1?=
 =?us-ascii?Q?I+9WzDeMPUUon4OxOI6ppopbybqVSUMekqpWP9/0pCE8Kw8YO4hjCi2BMp7E?=
 =?us-ascii?Q?j5FcCfUkm4B41zLl5hXKPjBlJD1Gf0snFu6YUD475SpyRiRksqQ8WhCfKu3t?=
 =?us-ascii?Q?ElnpsTG/O9jIIRq1Mkx/LLRgAYkeIzAZsPcunRsWyJVWMTGBdXGjFI8T4+n2?=
 =?us-ascii?Q?tiAU0Pv5ipy7Sz5hw0wwvMkolghOFrGe0bYPkY2zzu8ymNNVQ+qM4eBwabqs?=
 =?us-ascii?Q?EZGkBrkMwv8W+DBDu9vyV1pdqd7kzkP7ZW4g4SMlJhBMLiIJh6RaPtfwkgkn?=
 =?us-ascii?Q?P4MvgKq/TbcwrX4uiMmLKvu8udullbAU3nuA/VuNAu4WYTvq+ezUem+dYpJ0?=
 =?us-ascii?Q?ySYLVryHcji/K33gP5F9wYp66nPHJDqS0ls6Iw+Zyp8R/eeWTGzcIov8G9op?=
 =?us-ascii?Q?/nOApb/gxbuD7A/KGxejDqIs9Kj2DGsULFITzNLQf5czv1MU4GyQDkFgWDiO?=
 =?us-ascii?Q?Qbnc1p2DzM92TaEI53eqjw0MFPLOLkRTOp/2h85wR1SUo53Tbno1Zm1drQPn?=
 =?us-ascii?Q?D8y7QDMHbDST6DKtYwqRss7aUrVSg17cE77FlWGTZbW1x4EwcOmDLlVXC1vN?=
 =?us-ascii?Q?hEgKxjYIP8OPHxOybnuIo1yAQL+BQ11didOvlLw0Mkj51RhEA4Bi8P+dEk0C?=
 =?us-ascii?Q?obN0Wi8UC/0Beapb7THgv3QOOfNU+QddIuTqb4VXB1xh1LfZm2V5b541kAFb?=
 =?us-ascii?Q?Kr36kZy2kGw7w9stID6q6OTKjPw5EzOuk4YdM43Fuu/EK6g2tlzDqJT4MGSQ?=
 =?us-ascii?Q?1LBrlxeFaQCZz7k=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?51VBWL3YHatoS1TpVpi5JKZGBd1kh8Og09pJVurbYdEIyKeXsR2gSnkebFdm?=
 =?us-ascii?Q?QQme3uy84xBO7biKnHe0oKfIp5YSRhqenkCQAecRgSYNTHsmhLWGvWxmlaPL?=
 =?us-ascii?Q?+DH/A0c9sqdcOudxZ/45yhqO8YIgzSBQ5SHgVStyjrqUMUWa8MlUQJJ+755K?=
 =?us-ascii?Q?YBBBbyPmSkrUCB30J8EMRUW5EjGLvx+RcpIG7lcNg3VZeD31/wYp3UJXOgXR?=
 =?us-ascii?Q?i8/xQQQKghFM5g5ZCCSNLpNksQhgS/iFiXG7eXuTY441uPbJuk84ot5+AtqH?=
 =?us-ascii?Q?Zucq3QvZEU2CJOA+3NUcUxtwI1npq1jBkNHxd5eemVYs302yEPcRCt6U0GzZ?=
 =?us-ascii?Q?sig/a8Oda31QnCUUK5jdrWKn2ulHBrYQ8e6avjdcd00OPz1d1wnt+AbZc85y?=
 =?us-ascii?Q?//Zy9D0U824/+W4aPuOmhEwukDP1/seZDlSewFSQnKDNpyostL14R41Azmzh?=
 =?us-ascii?Q?CdJ2qcfY2BJ5Ch68uXmpsLZtYAi0C8qbJ7Ss9Y3fNQbY1wxn2WTT3gqicnHV?=
 =?us-ascii?Q?RNmt2t0N+zGDJ7P8cRcJm2u0ZzQtGt6oIlVCNTSvSPF5ZzqdGlkAwwQwlY68?=
 =?us-ascii?Q?+MMA+c9dasx9g1mzT+aX+m1Gz5y5CqfWuwfBi6hOoImCOevVoLUfROzUBFbx?=
 =?us-ascii?Q?AIdCTaAneO6NS/PtQqm84n1daJbsbQG1YkAIsidDSfg3da5T6Hh7I9ZbsvEl?=
 =?us-ascii?Q?sfxQpszGSpEABzIAWbCX0a3gB78NlJMRz6Agdnm0co9XWIR0IjU/5LN0VomB?=
 =?us-ascii?Q?vOW7mjjLOLMdpPsFonrAa6XoO5SvZaUHImHJQO1w6rWOm3GyTAFuZ6w53qyW?=
 =?us-ascii?Q?uzVx7Zu6BIKBjHDVOJXN20ih4pXEJiee7pjWjKI1QD8g1aMp0Vc4YPO8VqH3?=
 =?us-ascii?Q?gIbJna5oAGxoI6H7mUrk5QoQAWnT0gDn8eWioJj6fuYEEOUwvYYukna7ABUz?=
 =?us-ascii?Q?qZcSt2VyCbQM5LtNAcdNAdcLcGadpdfcLSx9QmE6ZgQwI4evKWM4B1N19nEJ?=
 =?us-ascii?Q?F/hdpqAydhUECVmP0O+VE0rPHKwtmT1jdJR5NZm3kxzjeAFNIo69d009qvSp?=
 =?us-ascii?Q?OwBuRbQd7SP5nBE1D7bgUZkkCAKdSPtl+bb1nfk8PVTCXZFLQBR5kAFC7GET?=
 =?us-ascii?Q?KrI7WUHW4KI5rrAnfQ6lVgIk7SqV1HCzd9VDL3uSs9USianTIV+Dbfr7yy2y?=
 =?us-ascii?Q?DB5HOVxpnbkMvb/wkzj1ChhzOMbuE+iPZIeCnySD/pc3ZKHINd8kPkyYDIK1?=
 =?us-ascii?Q?dEYOZdHVT/cZ2OS4TQOds9gOkO45+zXqKVOoJ5PW4PVVC1ZujEFRdCxV6Oc3?=
 =?us-ascii?Q?F3pf6L3yUts4RNkWFUo1xxst4PzupXa3uNeuSrrlE2/2CgMZ14X5xZKGUIMl?=
 =?us-ascii?Q?7HGEfd/memi/zraetHb+eTImpP/bZOwhJPH1ZVeMr0QqCHKUD2heVgddhC0m?=
 =?us-ascii?Q?k6yhOBtEDAphQ4Fan6svAwSCCoFAf3cmtW369Wik+09DRE+vkET2E05DQsvD?=
 =?us-ascii?Q?MvI23lXoGjk009do8/FVT91hvHFLcK7v/91MoQz2i6usa8G8pY7ZiqWmrCNs?=
 =?us-ascii?Q?HZ/gT9G11mbIQOwBw2c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6af677-8c9c-419d-466a-08dd8bf3d111
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2025 16:42:25.6805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qNyOLTDaW8JQt6W0UNdQBIEWD+KO7nEtYp8DQFyJ7Y8PwYe8RTVzl1gZvhAaywlj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5837

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, May 5, 2025 11:30 AM
> To: Kaplan, David <David.Kaplan@amd.com>
> Cc: Borislav Petkov <bp@alien8.de>; Yosry Ahmed <yosry.ahmed@linux.dev>;
> Patrick Bellasi <derkling@google.com>; Paolo Bonzini <pbonzini@redhat.com=
>;
> Josh Poimboeuf <jpoimboe@redhat.com>; Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com>; x86@kernel.org; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; Patrick Bellasi <derkling@matbug.net>; Bren=
dan
> Jackman <jackmanb@google.com>; Michael Larabel
> <Michael@michaellarabel.com>
> Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> On Mon, May 05, 2025, David Kaplan wrote:
> > > On Thu, May 01, 2025 at 09:56:44AM -0700, Sean Christopherson wrote:
> > > > Heh, I considered that, and even tried it this morning because I
> > > > thought it wouldn't be as tricky as I first thought, but turns
> > > > out, yeah, it's tricky.  The complication is that KVM needs to
> > > > ensure
> > > BP_SPEC_REDUCE=3D1 on all CPUs before any VM is created.
> > > >
> > > > I thought it wouldn't be _that_ tricky once I realized the 1=3D>0
> > > > case doesn't require ordering, e.g. running host code while other
> > > > CPUs have
> > > > BP_SPEC_REDUCE=3D1 is totally fine, KVM just needs to ensure no
> > > > guest code is
> > > executed with BP_SPEC_REDUCE=3D0.
> > > > But guarding against all the possible edge cases is comically diffi=
cult.
> > > >
> > > > For giggles, I did get it working, but it's a rather absurd amount
> > > > of complexity
> > >
> > > Thanks for taking the time to explain - that's, well, funky. :-\
> > >
> > > Btw, in talking about this, David had this other idea which sounds
> > > interesting:
> > >
> > > How about we do a per-CPU var which holds down whether
> > > BP_SPEC_REDUCE is enabled on the CPU?
> > >
> > > It'll toggle the MSR bit before VMRUN on the CPU when num VMs goes
> > > 0=3D>1. This way you avoid the IPIs and you set the bit on time.
> >
> > Almost.  My thought was that kvm_run could do something like:
> >
> > If (!this_cpu_read(bp_spec_reduce_is_set)) {
> >    wrmsrl to set BP_SEC_REDUCE
> >    this_cpu_write(bp_spec_reduce_is_set, 1) }
> >
> > That ensures the bit is set for your core before VMRUN.  And as noted
> > below, you can clear the bit when the count drops to 0 but that one is
> > safe from race conditions.
>
> /facepalm
>
> I keep inverting the scenario in my head.  I'm so used to KVM needing to =
ensure it
> doesn't run with guest state that I keep forgetting that running with
> BP_SPEC_REDUCE=3D1 is fine, just a bit slower.
>
> With that in mind, the best blend of simplicity and performance is likely=
 to hook
> svm_prepare_switch_to_guest() and svm_prepare_host_switch().
> switch_to_guest() is called when KVM is about to do VMRUN, and host_switc=
h() is
> called when the vCPU is put, i.e. when the task is scheduled out or when =
KVM_RUN
> exits to userspace.
>
> The existing svm->guest_state_loaded guard avoids toggling the bit when K=
VM
> handles a VM-Exit and re-enters the guest.  The kernel may run a non-triv=
ial
> amount of code with BP_SPEC_REDUCE, e.g. if #NPF triggers swap-in, an IRQ
> arrives while handling the exit, etc., but that's all fine from a securit=
y perspective.
>
> IIUC, per Boris[*] an IBPB is needed when toggling BP_SPEC_REDUCE on-
> demand:
>
>  : You want to IBPB before clearing the MSR as otherwise host kernel will=
 be
>  : running with the mistrained gunk from the guest.
>
> [*]
> https://lore.kernel.org/all/20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.l=
oc
> al
>
> Assuming that's the case...
>
> Compile-tested only.  If this looks/sounds sane, I'll test the mechanics =
and write a
> changelog.

I'm having trouble following the patch...where do you clear the MSR bit?

I thought a per-cpu "cache" of the MSR bit might be good to avoid having to=
 issue slow RDMSRs, if these paths are 'hot'.  I don't know if that's the c=
ase or not.

Also keep in mind this is a shared (per-core) MSR bit.  You can't just clea=
r it when you exit one guest because the sibling thread might be running an=
other guest.

So I think you still want the global count of VMs.  You clear the MSR bit w=
hen that count drops to 0.  But you can set the bit on your core before you=
 enter guest mode if needed.

There is still a race condition I suppose where the count drops to 0, and y=
ou go to send the IPI to clear the MSR bit, but in the meantime somebody el=
se starts a new VM.  However that probably works naturally because in order=
 to process the IPI you exit guest mode and on the next VMRUN, you'd check =
and see your MSR bit isn't set and go and set it.

--David Kaplan

>
> ---
>  arch/x86/include/asm/msr-index.h |  2 +-
>  arch/x86/kvm/svm/svm.c           | 26 +++++++++++++++++++-------
>  arch/x86/kvm/x86.h               |  1 +
>  arch/x86/lib/msr.c               |  2 --
>  4 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-=
index.h
> index e6134ef2263d..0cc9267b872e 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -725,7 +725,7 @@
>
>  /* Zen4 */
>  #define MSR_ZEN4_BP_CFG                 0xc001102e
> -#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
> +#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE BIT(4)
>  #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
>
>  /* Fam 19h MSRs */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c index
> cc1c721ba067..2d87ec216811 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
>         kvm_cpu_svm_disable();
>
>         amd_pmu_disable_virt();
> -
> -       if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> -               msr_clear_bit(MSR_ZEN4_BP_CFG,
> MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
>  }
>
>  static int svm_enable_virtualization_cpu(void)
> @@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
>                 rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, ms=
r_hi);
>         }
>
> -       if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> -               msr_set_bit(MSR_ZEN4_BP_CFG,
> MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> -
>         return 0;
>  }
>
> @@ -1550,12 +1544,25 @@ static void svm_prepare_switch_to_guest(struct
> kvm_vcpu *vcpu)
>             (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu-
> >kvm)))
>                 kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, =
-1ull);
>
> +       if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> +               wrmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg |
> +                                       MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE);
> +
>         svm->guest_state_loaded =3D true;
>  }
>
>  static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)  {
> -       to_svm(vcpu)->guest_state_loaded =3D false;
> +       struct vcpu_svm *svm =3D to_svm(vcpu);
> +
> +       if (!svm->guest_state_loaded)
> +               return;
> +
> +       if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> +               indirect_branch_prediction_barrier();
> +               rdmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg);
> +       }
> +       svm->guest_state_loaded =3D false;
>  }
>
>  static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu) @@ -5364,6 +53=
71,11
> @@ static __init int svm_hardware_setup(void)
>
>         init_msrpm_offsets();
>
> +       if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> +               rdmsrl(MSR_ZEN4_BP_CFG, kvm_host.zen4_bp_cfg);
> +               WARN_ON(kvm_host.zen4_bp_cfg &
> MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE);
> +       }
> +
>         kvm_caps.supported_xcr0 &=3D ~(XFEATURE_MASK_BNDREGS |
>                                      XFEATURE_MASK_BNDCSR);
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h index
> 88a9475899c8..629eae9e4f59 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -51,6 +51,7 @@ struct kvm_host_values {
>         u64 xcr0;
>         u64 xss;
>         u64 arch_capabilities;
> +       u64 zen4_bp_cfg;
>  };
>
>  void kvm_spurious_fault(void);
> diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c index
> 5a18ecc04a6c..4bf4fad5b148 100644
> --- a/arch/x86/lib/msr.c
> +++ b/arch/x86/lib/msr.c
> @@ -103,7 +103,6 @@ int msr_set_bit(u32 msr, u8 bit)  {
>         return __flip_bit(msr, bit, true);  } -EXPORT_SYMBOL_GPL(msr_set_=
bit);
>
>  /**
>   * msr_clear_bit - Clear @bit in a MSR @msr.
> @@ -119,7 +118,6 @@ int msr_clear_bit(u32 msr, u8 bit)  {
>         return __flip_bit(msr, bit, false);  } -EXPORT_SYMBOL_GPL(msr_cle=
ar_bit);
>
>  #ifdef CONFIG_TRACEPOINTS
>  void do_trace_write_msr(unsigned int msr, u64 val, int failed)
>
> base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
> --

