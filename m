Return-Path: <kvm+bounces-9151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D13285B6D2
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4BD28F0FA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0624660EDE;
	Tue, 20 Feb 2024 09:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L3121SCD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B9460DF7;
	Tue, 20 Feb 2024 09:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420144; cv=fail; b=iKw3HqijDtXNLinKR0wo129iZQ7C/vdh0ga2KnAhOFW5wbyP1axkw6ggQSTqD4+PyWVjhcqkbDF3JVvI4nVnoRi5TD/R6bd1aPujOHceFzH4omfdwMZLCJjbE2RqWvax7gFd4Ms4Df6FPXkSoh+CEyai7WCrICpIi/Yx/NfKRM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420144; c=relaxed/simple;
	bh=HVTtgz1XaeBzGTBR5ZwJ1Q3P+Qtm3Ikv3kpaPMlzyRE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SaJ3ScP9fFWydDBoXY74cd/N2AjqEIPoDzEpAHWOQNciS5cll0qcqTiR2EHxomynvGVa9kOhFKjc0u2o1gfYMfh7UWwbsDC7gXgJiF1bcE8j5hl3emTj3n/L42MfZ89h3PBdL+MAa1QKunwNn3+tn4EU0T5lqPhFmyxU5qcFztY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L3121SCD; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lylgvfe8vuqDRhPiz6+vKi1jqC4Z25ZeIFpmVajTmA90ECQEI08hHvehpt06DNYeBaQlZ/cW20zKXTbtcvQQ8eXEpFLoJpi+M+A5IbkI2GSxpLWfdTLjiH9lmPFB7zrlupBg5rWzkt2msyQEnPYq1Wg9Ioz2CdmVf9+S+sn/IMsMoUONjcl5m9cjB1Y+hF9LPbiLHZ3U17h2LyHZQzCWR5wWPdq+WSsrCekEH67WgVLHXfOglN/9CpJUq+URwnDPLsoiV9OHQH6vojeAxRMB50eKPp68oNzew/JM6Dm8B9uQO9rBa0JFly74klMqp81Ik1Hw6Hd/xl9JL2nTJn3oGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVTtgz1XaeBzGTBR5ZwJ1Q3P+Qtm3Ikv3kpaPMlzyRE=;
 b=NvkIGrgyk2Bk1xVF0ujFx1h/0cjnHQ0qgzK/vtMBWf7kDU/sD9G+9nVWBPkLsllYFovA+4RbG3Mn/ooLvCg0P4fl3VGdv/FFhNgbc8ZV0tEGyxZbgg51lUwGb3buREv5AxybedYmc/FiNh3WjFUtrDUAf4VYDO8JcrfX2RF4cyBwp0D3PHRGimnxrFmJ8NGLrW3C1zQio+QQaDXmYggJb9LYCP3Xwy+vQP/b1BKNdkzpi6086XBZNRJp1BknJJ1BRZJVA5aWKjkXHuNSadwtDAfQiFPIaQ+Ot/cNEzOaoOPeuyJHFzTGQNHWovwoElt9M6b7K0jNF79SfA4JLreQ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVTtgz1XaeBzGTBR5ZwJ1Q3P+Qtm3Ikv3kpaPMlzyRE=;
 b=L3121SCDwrBdykMlI7qDoI/uGzeDj2Y3wQPU3a7p8TP+qLo2hZQPt4GtDFQHY1iWtiO3RlmazZm8QVFrpXYep7pLNyqW1QeM5B15GVJd9DXy+vD8bBoGlt2inLAkWeZf7q8RiOHXWVhhLVauJI/QUeffvvQ6o9+3f7Sg4Fp0Xeal/pupMsTR2E2Hl7Im7FrfN6Q/hQICYwOu5ZWZr2pvEcbSvrdIZ9GQdu5FKp0XFSA+Kj5Lk7eKLPhtMB9Mtozi1TarqwlclhbSCJfhGDmrKeuuQQ7BqzBEg2W2GFBpSZ3aKszPBLi8c4adwNPwcHQGC4ZcU3upaSsaYsDnzJaKKw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Tue, 20 Feb
 2024 09:08:58 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Tue, 20 Feb 2024
 09:08:58 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
	"david@redhat.com" <david@redhat.com>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Topic: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Index: AQHaY86qDQVcMVySRkSmtPnSJvq8YrES5W+AgAAGuiSAAAS3AIAAADHI
Date: Tue, 20 Feb 2024 09:08:58 +0000
Message-ID:
 <SA1PR12MB7199E64F383B1C3FFAAFA224B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
 <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
 <b8630236-a081-489e-86aa-efbb39d3d9fa@nvidia.com>
In-Reply-To: <b8630236-a081-489e-86aa-efbb39d3d9fa@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA1PR12MB8189:EE_
x-ms-office365-filtering-correlation-id: b63eff18-5520-4854-e7aa-08dc31f39276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xwh8ZgQbV0jnjuXVH1MgvyF1HGek9/LG9ronj8+u4zMgi4sBSvnCCxT5/kB3RVMahaeKDSIZ8x3Er8o4OwzM5xmSWfRr9YnAUZDTUwks+3u0m1tnMa8FYM5cUSdBr2jRlREx31E76Rl2oNxzqiO3M36/oqUI89wDQaf0CqWGy9l1Da59LIWEyxNM16YDRVASD5WT402RVS5/i1+YgUhShzFFgZtQDG6raQ6Dyn46BAXT0ff0V8ScWC+/HPk/298XL5A3FL8r0OOWkUAaFIgPqyAPZ6i/rBMKIrvIRAJPFbNQNzBhSFCXuGYt+5jpgz1thfKO5E4uHDhQ0thpsrpxaiZDl4/JdLFdBc8Bix+ka7wjHEeMExvKYoQoD5+gOh1wims5XhfVzWi7FvjHiXKr+ac+VHbn6llSr+B0hr8nmzELvOC2HjPiKAAqPW3axfExjZsik4U5C9r9XnmY7QdSfM/UBaK6yUTN6El/8tcGZkE8UCg0m/jP2zYEYGz0m7avrUlBEvsiqVmQhj7gDmKEbY88HZwYEiTHkomgELpl3v693YEIhAbILSYPMggItTh+WyrfGDoNoN+h1jT/a2umPcRyLyIt1ek8+CZRpBm5ZGkAS5NIJNQo24rm/XhJgsN4sy1amT2F94AQGpXqiBqZ0Q==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?K9extAav0tNrazX+jlkWLX8cEpFExJ9QFSuiQMf3NwbNLZj5jH6eQRPhun?=
 =?iso-8859-1?Q?r4mFD6OoNB/lCF/s5ogJ2C+iP+wVwkBHUYJBPnlibUEZ+5XeKHwYErqJ5q?=
 =?iso-8859-1?Q?inzkd8nK3V6yp0rAjQ1NHG/9NHFdltbIBOue8z81Lpdh2QmuPxOuX5H0J6?=
 =?iso-8859-1?Q?E9Td616oBWEV5uoB5yji+g/y4bIioAMmypfGgRkExoPzkK5mGQIJ1v+uah?=
 =?iso-8859-1?Q?LISGcwK96iF7qucRTwbEnqxzoed/WcaW0yjeLhnPSrfGzQ/KN3D/E6WyHR?=
 =?iso-8859-1?Q?xNl4rk7DMnjaA9lpxIRfiaJNW1yr0sYyuumCXiY7JLHmmqJ44ebHQipSKc?=
 =?iso-8859-1?Q?WI4Ijt4qP2+XpEIH2psgAqSnboh9S67QRVu4stqTDGSrDdrANxNxYcm7Re?=
 =?iso-8859-1?Q?gLzcFe/NhBNfZL8vPgsyD2OmfrVnCbf6g0zc4g9uCrXBTwvgg0JLCVGzMG?=
 =?iso-8859-1?Q?LRLd31IC8u8r67G4ikgmsMTi9/32c23O+ZdT3RwB9dH9C+jODH8WKAfex6?=
 =?iso-8859-1?Q?p4KcFxYJFa/hACBUCuItKSzTnnsD/PvMcIpuVuMi3AEQAlXg3jmq5dHTog?=
 =?iso-8859-1?Q?eSndWK+qt6bU/6oUxt26l34vsE1VV/84nUkm67OmBW6XNGE2ngHS2+M6Ba?=
 =?iso-8859-1?Q?HHPrmUVu3Hb1biaXYA8FNKyMm6eVkduRBXQrMdLP0jjvMP4Sj3klZMrKx7?=
 =?iso-8859-1?Q?dGJWGRlQmbbSjcttUXcJdU6rd3EI6dtxLPHGvAOoGPfZ0mGlytsQlf/tkE?=
 =?iso-8859-1?Q?zm+dR6P5ux3zmmmau6cy66j08aaop0M2pQ+CAht6e6ax/uRp/d6gvAoRNZ?=
 =?iso-8859-1?Q?eAj1k6x3tQ5bAVED9HpDSaJioX/o6So7g395yN4amyaP2yd2KbFNeQof/x?=
 =?iso-8859-1?Q?0MnQwMRcmcHEf647DAPcgnUa5B6+JFPntxxJ5jTWY+RwrvJusgfi/+BvV3?=
 =?iso-8859-1?Q?eG+IsPQdTjK2UDoiFyfiqRCM/Gh8k31v5iOypu2EznA3efV+7HMsUlx3E9?=
 =?iso-8859-1?Q?mfgRJ4/uHvWqs1J2EzdN1Ko3oW8SGWd/wGcI7+FeiXlqTfGxa3T4P+6UWK?=
 =?iso-8859-1?Q?CSECJFrsmn+mMQ575Wri9vhvBiB4WqU0uljjI8sBQCRNq0HH1oMyZKezUL?=
 =?iso-8859-1?Q?YsN+n/1Lb3WQ+G5GkyYb0uILf5wQFROsuRiag7IQWcgKdzCkrgOdyqCu3D?=
 =?iso-8859-1?Q?J5DPJsdKU+vynGMKXKX0xUMtMBXKQtDWArcvnsUo5xn5Rwk1+lQEWY795c?=
 =?iso-8859-1?Q?k0fQCmSiCiN95aHlf4QfBkNRghgFryGLRp5nieLIQZgbK5CPS+jxCLOPK2?=
 =?iso-8859-1?Q?HyT8qCXadIEYMXo6OonhW8GvIp6iWWl7FGe/z0XT2UBq2dqiKQA0f/RlYB?=
 =?iso-8859-1?Q?jdR7AHXU7udkXl8tysMwHKDfDOS94hMw/jm5mZzefuqIfc7CiLJum1Js4r?=
 =?iso-8859-1?Q?eOVE6ygkPDPp2/NyW11PtN4a/yni1Gg3P3pVZKMDh7zyhuDyFrs95sysZH?=
 =?iso-8859-1?Q?EjJdUZhJwD+sUg+nvRNb86Dhu2J6UWKvKSPq1UKuwSPo/dU/PsFdqaQpHU?=
 =?iso-8859-1?Q?0ma49mhsyk3Hp+BpxPF5deTGPGUVX3ixnCbGVhL8uafVCP5usKDGYt1kU5?=
 =?iso-8859-1?Q?CPv3rOqUIY8Tc=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b63eff18-5520-4854-e7aa-08dc31f39276
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 09:08:58.3343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUNk7ynX+46ORB+w8mDQUhWuYkEiVsZU/D0D4UyZQ6DbZ/Ob3rFTkiojIgHtNsbY71bTMZyS/O1/44hdD+rvfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8189

>>>> To safely use VFIO in KVM the platform must guarantee full safety in t=
he=0A=
>>>> guest where no action taken against a MMIO mapping can trigger an=0A=
>>>> uncontained failure. We belive that most VFIO PCI platforms support th=
is=0A=
>>>=0A=
>>> A nit, let's use passive voice in the patch comment. Also belive is mos=
tly=0A=
>>> a typo.=0A=
>>=0A=
>> Sure, will do.=0A=
>Also patch 4 has the same nit. It should be fixed as well.=0A=
=0A=
Yes.=

