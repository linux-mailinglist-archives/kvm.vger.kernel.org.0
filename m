Return-Path: <kvm+bounces-8590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E708527D9
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 04:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27DB9B25132
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAFBAD24;
	Tue, 13 Feb 2024 03:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZFqHhjf/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A98813;
	Tue, 13 Feb 2024 03:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707795711; cv=fail; b=SG6j3aggI6alqzMIr7Gqibd2ETmsEtDIn7zb6BV745Xbfy8TWv5rTRrROwvacdsSNbVqYEHYTRfp2tLaLRl/lp+YAuFsBOAoi9Z05gJbr31i5uAULt068IhpBKhfIXnCUxu3dLJKTvrySfMjT7UMN3znvNsi/wlcuyzh3IyD0uU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707795711; c=relaxed/simple;
	bh=vvWElk+K9dEeLOUSRodsgfz251pXvDybxPzVJKz8xnk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ioYzlEQf+DsD8gUYxmicwWCE3wHnfAiqIrwQTVgrbFHjQojkt+k4F9LTJGegApm2Jbyf4Xu50xCLsdoJ980sv/XGwdqYsyxfsTVaxB83nIeTg30n3h+aRHcm9+nNh26oRAmAC5m3I17ZxCtl+bqq2fDqPvypLh3pHyyrGtkk8ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZFqHhjf/; arc=fail smtp.client-ip=40.107.243.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUkT0BKlXpg1YUk7DVektq5jL1xaw0NqZDjJvsAARQqYiwMPXPL90H/kv0rrNQBwaTPMUUYHaai5nTLOvJoypNJyAcHR6VbNjsFFva/pBbGS/41EW9yXzLfqrqH/pdRIMYhNhNp9yRO3vAdOchabXJmDcmEVAOujToFT+5Ln03FfoMUIOOI6e9XDPtw8l20V1WMlfMMdIwU7DTKNuFLxloMddqqWMtrSw58To7YSvBmV5GJpon0WhKnEAjiN0zehrpnltWeRSTtHNPBxx3lA2nJsZ2OQror9BKkZJ8srDMT2afNxB7diF5YdDgeGKH/p8ScZMDnpGlxUpxtz/x8BrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvWElk+K9dEeLOUSRodsgfz251pXvDybxPzVJKz8xnk=;
 b=UgcQkuY9bSRBKAFNHHSRTdAEZAAW1POJAfjVseH+funKzm380fiuPbicDmXgc+Xsw2P9ln527w9DleEFNJvaiQBEwo49+CG9v2gQu8JwtB3dOLUroBqgvORLdjahGcGGkKTB12QmJfyeOSq22q4u1+YLhweh91nF/Kc2ju9HNH6Naovt7BZfcbrzrzp4h+G2fKdlznp8JDH739ruKz8+iXoANZCMNsxGSziskf15N1Mp2lUtWmUmnROsQhf2gRkORpSrjbi/y4msVHMAh6hwADKX5GHIV6LdPUyL74NF3bFR9/DGX7qutqalYfc0CDlISvxYgF3CCB7frbKmpx051g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvWElk+K9dEeLOUSRodsgfz251pXvDybxPzVJKz8xnk=;
 b=ZFqHhjf/wD23BJ315rL/Ah76Fvi72F56n+fri9fDIZv+cV9gxDQUax+l69cF9m7WsXZ/eE57YggVq8jHHSQAgphZa/bEZsyHuBCK3V08uh+9Z6fUcPcceVyB3nkNq7rDXmekK0UDRH/ifMkm0d5FxZrERUBP8D1oZO1mlw7ApAvPqU+f3lgNck1fbwrcn7e7JXAFShaeBdMtsgo3aNyB3a+6dlUghDDrEI0z7KswjZy+ViEw/fMY5HyHPSA3I2VXw4BjdZ++vKMP2/nIDsto58MssRrzic2qCljfib3QK5UL5au4xw0iSTVrqsvMBTRh5/I+UPxKUJQdXrsiJL7nvA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CY8PR12MB7195.namprd12.prod.outlook.com (2603:10b6:930:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.35; Tue, 13 Feb
 2024 03:41:47 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7292.013; Tue, 13 Feb 2024
 03:41:47 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>, "bhe@redhat.com"
	<bhe@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 2/4] mm: introduce new flag to indicate wc safe
Thread-Topic: [PATCH v7 2/4] mm: introduce new flag to indicate wc safe
Thread-Index: AQHaXRJrmN1T1MCUwUqcUxbrSRtzmbEGsEcAgADxJG4=
Date: Tue, 13 Feb 2024 03:41:47 +0000
Message-ID:
 <SA1PR12MB7199CEFA3E0920120BFC2BBEB04F2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
 <20240211174705.31992-3-ankita@nvidia.com>
 <165363ba-d6cc-47a7-ab2a-d3a27a42f739@redhat.com>
In-Reply-To: <165363ba-d6cc-47a7-ab2a-d3a27a42f739@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CY8PR12MB7195:EE_
x-ms-office365-filtering-correlation-id: 05cad48c-c041-4497-380c-08dc2c45b47f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 rewoy7j/lzh4JRw1Lu3kdoCnnQdoqg0z5wF2MnPMGi3MpdtGIGMYdH5AQCBSmrAyf5FsQFmdDmu79bQqvRxq0i6V3zPt+EgFmE+o8sQJrgoWY7Fc2nB/pQsLXL0xBn6+pMNSd8X/AsPQah0cKtY1d9hk8kj1es7ctub6UNIExPSdV+JA4SlfVP6VwxpzN8B1ZdCTVmWoWswtg1+m/JFiib5FIwSdf7u4Z7HTjkPnGvfv+1j+q5ax2FKIlvh33Ki85aLYmdmj3q7GbwbGDojhSEx8zP7CjpAR7Hipmg22jojJSQAfMBnXt+qEoga9tEBA7z98lSUn2xQaf+U5fBb247AqnIFXLBjVVnyhlMPO6P1OoTOhahBKr1l3XqrBJo93LDJggePgKIn6qXITz2sAL3TGZtfAAVmLsK7do8/pXDV+K/bTOFCW5QhMuqb2LbBiTaGeVlmpcIaLKx5v89GVBr3tfmz8B34rGcNmcMcFXyd54oi++3rAxWXCsee0i0/fuFnpQHkkaOleOlwTByh7du2atgteTNY20vUo+XGw4qthGzmfsv3fWANo0cjmS2M8+IP2gPvUQCYk/kMKnB8R73t90hQKBv/c1Vc/9LjCVYklA6ccilQzNA9FluAVcJFoghE+vEYDtHgWrEkiygZA6g==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(376002)(136003)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(71200400001)(86362001)(41300700001)(55016003)(52536014)(2906002)(5660300002)(7406005)(7416002)(316002)(91956017)(110136005)(76116006)(38070700009)(33656002)(54906003)(66476007)(66946007)(7696005)(6506007)(4326008)(8936002)(8676002)(66446008)(66556008)(64756008)(38100700002)(9686003)(26005)(921011)(83380400001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Lf4diYf5d7DtaxKM7uElMHRa4cS+nvgBYwXUoG1Wv7k+6bPWmyNB/Ss4Xy?=
 =?iso-8859-1?Q?YYSuhu06L7uCpp2CXM1mJK2OersmeL6G2yUdgbYr6RGVbPpaBrvcwmTfw1?=
 =?iso-8859-1?Q?osT90uQtpG4IMHFypo0S8aylYSPTj7Hr2vmkEj48nAirka6BizINxsrCOr?=
 =?iso-8859-1?Q?ljLuq3WKRB5BKMh/OWRAcFm9+px4YFDeO+DzkxtewAeWKkJRN9MkhlgMhD?=
 =?iso-8859-1?Q?AOAgwMtm1WJ6ia6SfdGrxuhrL27+fkGVN9W2mk3G5faku5fYbe/NH8CH50?=
 =?iso-8859-1?Q?9vTNT3TME6fYUjzUDYqNnW/gOCG+Eo1/PMrHi8LGmgdz+LWEBAU2EElFtc?=
 =?iso-8859-1?Q?vMC7wUpnxeHq9ZRUL0FCcWfMMUeFjWS7ypCPqZPeX0F+7A5blrh89wywsJ?=
 =?iso-8859-1?Q?H7i1MpDwiNreWrKukc9BcFDkJ41qYhVcGgLhmfnoC/9acLssR4rADw8+cX?=
 =?iso-8859-1?Q?8Id1cgyYipknQkLDs4FPCLNAt+BBltpx41XBeepwdIwGO2G4uv6vvIO1wH?=
 =?iso-8859-1?Q?UXukro/zTlbJkuaygjSoO6dBH3PZ/H4h0i07Mh/YSkpfeQmluO7QRQ8sBi?=
 =?iso-8859-1?Q?NCaM4ldld0hUxfFFBnGxQWWYl6r3hG6EOaKypj6AI+7nzcGe0u8IXfJHVP?=
 =?iso-8859-1?Q?Bqw78l36I2pJV1Ws2D7ZuEkfWJ2NwFydpYxYEuFgHZrSLwrilcJh/5hZ4t?=
 =?iso-8859-1?Q?LHu1I8Tt8CCXlPgQrZACV4puB2HH/RcZV6yiCJTncCa5AhAXSgD56Y8jMH?=
 =?iso-8859-1?Q?dcxrldHXBzWFwl/GFIeLS7WuQk3tkA90t4hC6Sn0YqXL5Jc3Ohqm9VCXOb?=
 =?iso-8859-1?Q?h9i3WJAtbpFaOP25uaRI9g87S1v8QOEj99ez//3F8TBT9u83LX6FTWWeN+?=
 =?iso-8859-1?Q?75dJmnSw70IETs9F5IIktVxeor0fARGq6Q2MuhV5C9u5ZwNDpPdX7h9wZ+?=
 =?iso-8859-1?Q?83nPcaLwzMxYHRrbfadrkuZcznd1v4AH2F5CPkoPcaSD7ZYBsxdZDaNoma?=
 =?iso-8859-1?Q?GNB++BYb7Tl1YkjXJeA4jW/2XHAS4LOORWhucr+drJuKyOKAFVWh782Kyc?=
 =?iso-8859-1?Q?OhDFILGOIbGdtBmbM1Hm3ltqnCv4rc3QTaJ0hSj15oa3FGfcFa97wj+OFV?=
 =?iso-8859-1?Q?LE1TOh71Qou7iHPcnfpXaz8jpl0lN1x1aTqZlW1Q3XZKKAu6ewCoDz3owo?=
 =?iso-8859-1?Q?67/YX2KUQYP8PF5hMz1doYvXfwP4rAJQxaepoNjjJcQVn7b693gnZP0Q2j?=
 =?iso-8859-1?Q?ekhsvaAHU3/s+xeoJteirk4aFcmywg7yqPfSXh+jFvlABJOKZgkGwhjs6k?=
 =?iso-8859-1?Q?YRt47VCNFpm3snT8Gkm17zNHOUYw/ukEjbBNuf4aUzoX5aR9WW3o7wN6jT?=
 =?iso-8859-1?Q?/JJanswQhVOon5gZ/fepnkfIHV8/R7MzN0Hg+t/XuSKt3hZmbalAA06w/X?=
 =?iso-8859-1?Q?X7++EfzGaCf/9+cLyqFHt66QTFl5BEboHH7hTAgB083EsktM71Xcowmn6e?=
 =?iso-8859-1?Q?7goxQjmg3UtwzDY5DID2Tl6NF1pfpuIxBvaaB8J1NerWG6n+lfncjjZzi0?=
 =?iso-8859-1?Q?YNMgjv+olk3w1CmPDIUPa0G8KgngywBd3H8+ThO9tiaphwfWLDdXMeXAd7?=
 =?iso-8859-1?Q?Sw2iMEVobHUCI=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05cad48c-c041-4497-380c-08dc2c45b47f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2024 03:41:47.2171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSI7xA6M8SovDwl6J16hHJXHH4/S3ZzzayU2TX8HCa2DHmu0FbrFW4eMjrEEJY1/xmR/q3Qp2U3ZbHt7R8pQxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7195

>> insufficient information and uncertainity in the behavior of=0A=
>=0A=
> s/uncertainity/uncertainty/=0A=
=0A=
Ack.=0A=
=0A=
>> non PCI drivers.=0A=
>>=0A=
>> Add a new flag VM_ALLOW_ANY_UNCACHED to indicate KVM that the device=0A=
>> is WC capable and these S2 changes can be extended to it. KVM can use=0A=
>> this flag to activate the code.=0A=
>>=0A=
>=0A=
> MM people will stumble only over this commit at some point, looking for=
=0A=
> details. It might make sense to add a bit more details on the underlying=
=0A=
> problem (user space tables vs. stage-1 vs. stage-2) and why we want to=0A=
> have a different mapping in user space compared to stage-1.=0A=
>=0A=
> Then, describe that the VMA flag was found to be the simplest and=0A=
> cleanest way to communicate this information from VFIO to KVM.=0A=
=0A=
Okay, I'll work on the commit message and describe in more details in=0A=
the next version.=0A=
=0A=
>> +/*=0A=
>> + * This flag is used to connect VFIO to arch specific KVM code. It=0A=
>> + * indicates that the memory under this VMA is safe for use with any=0A=
>> + * non-cachable memory type inside KVM. Some VFIO devices, on some=0A=
>> + * platforms, are thought to be unsafe and can cause machine crashes=0A=
>> + * if KVM does not lock down the memory type.=0A=
>> + */=0A=
>> +#ifdef CONFIG_64BIT=0A=
>> +#define VM_ALLOW_ANY_UNCACHED_BIT=A0=A0=A0 39=0A=
>> +#define VM_ALLOW_ANY_UNCACHED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 BIT(VM_ALLOW_ANY_UNCACHED_BIT)=0A=
>> +#else=0A=
>> +#define VM_ALLOW_ANY_UNCACHED=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 VM_NONE=0A=
>> +#endif=0A=
>> +=0A=
>>=A0=A0 /* Bits set in the VMA until the stack is in its final location */=
=0A=
>>=A0=A0 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM=
_STACK_EARLY)=0A=
>>=0A=
>=0A=
> It's not perfect (very VFIO <-> KVM specific right now, VMA flags feel a=
=0A=
> bit wrong), but it certainly easier and cleaner than any alternatives I=
=0A=
> could think of.=0A=
>=0A=
> Acked-by: David Hildenbrand <david@redhat.com>=0A=
=0A=
Thanks! FWIW, it was found the cleanest way to restrict the changes to vfio=
-pci.=

