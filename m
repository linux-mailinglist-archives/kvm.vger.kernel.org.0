Return-Path: <kvm+bounces-8434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00D3084F6D8
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACC39287B99
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 14:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093786F07A;
	Fri,  9 Feb 2024 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hmgXgDZI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5736EB50;
	Fri,  9 Feb 2024 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707487929; cv=fail; b=ty4R29OoVtG9OBs6xsLoqqO8ibPPWOBvmBzg69qpQxuuwqDh9NrEJ+7l6D9Z2HmfrxKjNMR2wUCqvDgyXeZBEdI+2HEKHyKEpkC7+ZfI3Oo+Kx+K50J9uVsi7JDnCPOv3X8BRCR0P+oWyuLTjix3jYgkbxPuPS/TjrmE6tZJ70k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707487929; c=relaxed/simple;
	bh=nZldan/vWQlag83bViKM8RzsXjhwWs6uyMwIzFLjciQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rfTjn2Ubc8JEzeb/pKU25Suz2rpe8umXAcc5dQDgS1/lZeEEX/73ozPQQd99g2UrZJy9+Uqv2EdB50O+XNGfKcbURcwD++VvedLcMThkp3Vma7TAu50aCUkWO79tFX4ajI85rE3Fvq4Dfd5I9x6jh88rU6/a3GViysm1kfLn/Tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hmgXgDZI; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA6z3a6mi0MQXW2yJ8ON1sLK+JIeUYTHW2dB2SJVWyU/RKXkCu84TCcijL6Er8x+KotrKsQ4kH7UE9wbhiVq/Qwzbr4l0bAN2Ws8PuOHaJfoC5OkbkCrTaRRnPjiLduOeA9SK+qbTsl8yc/Rdp1bABnKJ8emXrrWJJpeLxxvt6LvR5q7lWabcawiVcgUZmrFiUjuFILsMztSUl86WFlFg4LA1RgCv9qwpWEX/qr1N7Imxnd7cYu2yB7cg5rOnUt0qpbayRUSfJmQRow+bSx0fgJVLi5tRrDlWwgd7Kx1yIL8HTVKsDzo8uM4SWFlnkDJnMiOquJT1kv8ElB2iA2Qtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZldan/vWQlag83bViKM8RzsXjhwWs6uyMwIzFLjciQ=;
 b=dUjyFHxixOibpPAG6keFnIytj0QWx7iRGrwUyaPU/bDgQqht1DlfIUsKuSj/L4SEH0EJ7FAWO9lK6ymeOFxodmePrXD5SWNw6ltOv2mCbDTfKvGdtFE/TuMvc+mog6VdNFscqgTBkhOAjmimuiQ7XVA3bmUq7+zJhFxSlx6/UDhn4dmnmpVNIv69XiDpYHZnSIBQIQ0RdOJj1dib/xRuaiXzmXRNNamj9mEMVCq6LII8lbvnW3N2VJ6dC/cPM8OX9JuSUO/DrG5wJm90TY0wVSlFXfS46k4axUt6yPtqAn6o9TlS74kzSOhoQSeSuAT6W9xXvtELrFuiEf64KIYU/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZldan/vWQlag83bViKM8RzsXjhwWs6uyMwIzFLjciQ=;
 b=hmgXgDZI5PDzYsAwcB91mitJUZVZm4WSBoSrmxAUbbpaO3ekbBmxR6VFgmqk1ioFglleW+A5XM4w532bmJ9umwTCAQlg8+xJYfns+yrY77qk1NHKjXHMyGrg+EOTdK8Q33Ks6CqATuFDo/mbYK75ulqajyPpi891zM3wl1k4uaxjRl2txRfWI0hDqxt+lHIBxtRkGG0sTqqkIC5wUV2wtnn3hOg+HMh2R04iTOl0Iu6Km8znTiFQnGbUYSeBEWmljuTAQVLYIm0B8xqfk+blJed8BkkKv+nAjXR3H1vmNE9rWh+8uFk/qfG0fH0vfBbjqo2NUOzyQ8+s6MOU7btR5g==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Fri, 9 Feb
 2024 14:12:02 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7%6]) with mapi id 15.20.7270.012; Fri, 9 Feb 2024
 14:12:02 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Will Deacon <will@kernel.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"ricarkol@google.com" <ricarkol@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"rananta@google.com" <rananta@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Topic: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Index: AQHaWgbdhvpY3ycYrU2mOegquaqhOrEAbuKAgAGgqXg=
Date: Fri, 9 Feb 2024 14:12:01 +0000
Message-ID:
 <MW4PR12MB72133DAC9A35687D33DCCDC0B04B2@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-2-ankita@nvidia.com>
 <20240208131938.GB23428@willie-the-truck>
In-Reply-To: <20240208131938.GB23428@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|SA1PR12MB7296:EE_
x-ms-office365-filtering-correlation-id: cd5026b1-aba7-496b-5ece-08dc29791632
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 X7PaqzyNG+bV54ihtbYRo79iflm0C5XJ/CuOT7qYLoHrPZVEsHVTkB9uQ6lQwx6V5q+KCie8Um0BIotigzysn7+JC+JrgI7uDNoNXWGcCeZNpEeuMIWX8xoCOUfkmnzrnC//uiATMthu2tB+ZDiF1z9WKTDHtZt4EhDig9o1ax1f8MzNkFYiK+ITbM9t1dpma4ZrM2M0bhWF18S5Q5BN+UQPCu8NwDpwovN4zkLR08lg1eJ5zLsgBzVlqMXv/uq0WCDrcg4xJ/VpFTgxk+sNRxfo6JMO/7gry6CVo0C1RsZOYEWuCwIpfK2POG51CCZ8/FrtqOIq4ul67GsVnCM3dhvtsJVH+JxyepE+oGb0j1jBTFmOba91xVgHUNDSDTs7grv9i42bQLEfyhF+HrNwhf1khe7IUds/Pq1HesES1PTIEnKXzY5yusNocWfvCJaC2s9CdrW1yLLZ4HFA5rgD48aB3tJwwSV+38R3MJwE8dmgLZ6mV+k6izVJRLm2Bj8RlWh+UCAi53Kd/1AApQVp1rhxi9Kv/GHX/TYWsro7+YmuTXHH1D4V9vMvxwa79VUDFooBicbJqcvBCFpIJI+foyS80E5ejAlE+h6ptvaruT7gH0KOVFy9rSo8/OK5H8a4
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(33656002)(26005)(55016003)(83380400001)(7416002)(41300700001)(4744005)(8936002)(76116006)(54906003)(86362001)(66476007)(38070700009)(122000001)(91956017)(6916009)(66446008)(66946007)(7696005)(64756008)(6506007)(71200400001)(9686003)(66556008)(38100700002)(478600001)(4326008)(316002)(2906002)(5660300002)(52536014)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?7ksOlKLTNF/q2SBtGXGLvwVLX+FHqshhIHCSZNiuCjQ/JwFWeM6N0TSoZA?=
 =?iso-8859-1?Q?YmbIFPCLVaUwRBuFVT7XAJtgcY7bWHjsb8kN0ENdOfZG8fcO6PWNCezaqi?=
 =?iso-8859-1?Q?BVKNzbTVYpYMncfQhgIxO5JyOva5YNPjWPOLxv+4OJDpYZDLCkL8nFC5uq?=
 =?iso-8859-1?Q?U3YCqOz0JayCu7hGdL16zWCPDmwa2/rLPNVwe/ECSK3FaJLGkrANZqqb7i?=
 =?iso-8859-1?Q?HytLGnZ+DYItcE18VE/yfS4hv8b7zZKK7vWMP3DRX3KzFpE06MUKTCeSkb?=
 =?iso-8859-1?Q?4C9ONBJI3oRm9Sy6eBtwqCHiHjcNqEI3kfVA3iEjlv4PeHvgfMOv3pTwG2?=
 =?iso-8859-1?Q?GbgY/dUEnaPDbhYaA/4giFL+k4hymqwsA+bYtoTQpBBZv25uiaTYWRf6ov?=
 =?iso-8859-1?Q?Uviau13ehb98BPOgnPSNqXuuSAIwrijdZl2+JFcoWnGdIowskXVsM4g0Mm?=
 =?iso-8859-1?Q?J5BCZF26IqOrOI5ByBmL6M1uXU0SrNT/LUNdc4ivTyFzr4KEbLTOXvFSdm?=
 =?iso-8859-1?Q?1limyMUihOgcj+zCcJdahhdkAkNFFmo1L7bGjovA88LDt1Wa9RNqoez0e4?=
 =?iso-8859-1?Q?RCrCO4FHqJNWOBfTVCtTK61xtMBI6H4YZPLdxreQz9fgCH0jk1luMqqQN+?=
 =?iso-8859-1?Q?1HxQ3cAu3ydYaGm6Kdt+KfzIcuaFbjSMJ3kABD1bYjb2/kfLeZqkCgQk0a?=
 =?iso-8859-1?Q?5HzNDoghYaRzP/UlCrOjyNGjA68/BtHGk9pHnljuoru8IgPRI44S9W1HNh?=
 =?iso-8859-1?Q?kqpIe7t3vEJnNvEmMTNeS6bVcrn3jrfSPCURrcsw9GYxDmg35E6hh4KGbm?=
 =?iso-8859-1?Q?W+7IualG5Cctxb0Z+XWM/6ayz5tw7faH3AcEhQ7Nbg8/CCfIu8NxWdBHeC?=
 =?iso-8859-1?Q?tzku5VOU0cCHSAUH7s9iUIO3H6bUu6Swp7j6XHmDaerQbRgrL03ayrV2eI?=
 =?iso-8859-1?Q?b4cfgNaHYtKpJkK2CRQ2NofdhmAfBwwb/O4uy6R0BhvlQOZkBcsQ+0OiC+?=
 =?iso-8859-1?Q?qsGCh+TABVTyXtLWDsmp4IvWn/eETkNIQVpAddILSa33W0M2wUT+bUiXi6?=
 =?iso-8859-1?Q?LjidXmS0Kc9i56m4776HReMdVwdaA9N4Nj0hjxDIMgdnQxcRidNcAxq+Qg?=
 =?iso-8859-1?Q?W07pMMvfY5MSfSs/Ix6sgaff/ZRRbo6z5Bt0heSwUqwzTtGVZS2y7cs7UE?=
 =?iso-8859-1?Q?M5+ZbyssSJy4SJvyMoUzw4UZeFh1INoMDto1ZLp+yyPQqllr8TMWD7PMS6?=
 =?iso-8859-1?Q?yEMFiRKjdR3y+z/HmL2dkdEDVMFcgX286STynfPY+WeixDXE3edU5gFHdA?=
 =?iso-8859-1?Q?YaOuzuPj30fzQk0ZRaGYAt+7EOFOCxsjW2lGllhcekjvG1Ggq1MbjqiSMi?=
 =?iso-8859-1?Q?MhMtbVuWgR/i4FNon94uLNdDZ8AXLfyK+HPOk0nwzaoSQuQpdhyz3ZT3/Q?=
 =?iso-8859-1?Q?Y6e2XNW0c5/B1aFpbu1t5aa8p/QC7C5E//mMJ7DYSrX3BLgjlFlDpWDZma?=
 =?iso-8859-1?Q?WDRkx/zdLRX4ky0pnWAFfAEpLNKpzDryAkZ6zd0Ou2t5bLiDYNs7eZHiAl?=
 =?iso-8859-1?Q?zfU7ThFCo0Lv23Q9CKeZmCDfb8rdahwLm3bbzraprXs9b8Kzd3kARvKmYY?=
 =?iso-8859-1?Q?F/7FxI3ufYMr8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5026b1-aba7-496b-5ece-08dc29791632
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 14:12:01.9622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2iQKyM0YD9nOE6ggGp+XQHrblNXVSVSSSIwqFVBLEeb8BIuwog8XqU7lKU0OPdvVNDtedyp92o2Oe4evBhiAEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296

>>=0A=
>> +=A0=A0=A0=A0 switch (prot & (KVM_PGTABLE_PROT_DEVICE |=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 KVM_PGTABL=
E_PROT_NORMAL_NC)) {=0A=
>> +=A0=A0=A0=A0 case 0:=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 attr =3D KVM_S2_MEMATTR(pgt, NORMA=
L);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
>> +=A0=A0=A0=A0 case KVM_PGTABLE_PROT_DEVICE:=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (prot & KVM_PGTABLE_PROT_X)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EI=
NVAL;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 attr =3D KVM_S2_MEMATTR(pgt, DEVIC=
E_nGnRE);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
>> +=A0=A0=A0=A0 case KVM_PGTABLE_PROT_NORMAL_NC:=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 attr =3D KVM_S2_MEMATTR(pgt, NORMA=
L_NC);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
>> +=A0=A0=A0=A0 default:=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 WARN_ON_ONCE(1);=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> Cosmetic nit, but I'd find this a little easier to read if the normal=0A=
> case was the default (i.e. drop 'case 0') and we returned an error for=0A=
> DEVICE | NC.=0A=
=0A=
Makes sense, will update the logic accordingly.=

