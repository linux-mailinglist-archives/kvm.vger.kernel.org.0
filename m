Return-Path: <kvm+bounces-9067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB9AE859FCD
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0BD01C211AD
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E23028684;
	Mon, 19 Feb 2024 09:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iMsPSz5j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C76225627;
	Mon, 19 Feb 2024 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708335391; cv=fail; b=rZkLLVyzyi0X4KOFr2jRwm/dB1tjiATRh8Mk7tQRqdlfDzviN7o7d+3uRHvtZLB85dHeSaoRZ3gWP3JQWCmKheojeixnTjdHcRwoQGMd2vL1uIcFpfXZzjXjlUbLHsXtkdgpPTjwyApA+cI50b49u5Eb0B9f/a35OsQ7d6Xk57U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708335391; c=relaxed/simple;
	bh=Hu2ka960XbAcKJ3drws4ddvcTGReWGESk/w8lot58zQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lg6HciopezTO4LWYwJP6vy4ncDN0eIANm2j7r3zI0c//yf+s3861IhYFIc4hL/mpsg1eVkljFDtWn7RCMWoWPRLz0mqMACtQ0xGYJughEBkHcT5AEeQNuLL6//epwB9+Qte10fsldiaLm9gw8LnxAkfoW/xxBXgknVUk+QD0GAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iMsPSz5j; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U14QDRcDT2B/M4OOThqEZ9dgt3xoH/r66jrmYEst+XVcwxUciy+ldillui+TSepJ1IXLhFTCpN4RdmBEIa1XEnmwdsHRrGCQ6QMYPrl0BxVYKDfoizeWNzNoV30VyaFZKtmqaZ0KKm8k6RSHYl8qWZc3BRkGd6i0MLNrXM6HGdINPuF0kHNfAlupQ2pYvzArdYOCs2HeTK4qawC//0W60oUFetivnTWOufacBOFd5Pjye4VlGGe9nJdKJw3CIC9hnboEP62tJ6C+1f8+8Y+EM95l3g/jZ0p4EgF/hTP7pJ5mGz8BziDRrovMDJmjgXcP3mpusdwqtzB1fGZr6MfwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hu2ka960XbAcKJ3drws4ddvcTGReWGESk/w8lot58zQ=;
 b=V/xEc/qJDlQLghwIyAPn58cD7mjqhEM6k9l0UDTfqo+jbsxEzaP3ApGfz5oQNAW0vC4PbPSIaBdxCnrFmvU4eVUp9dKwswolAZYR/ynjJmt9qDxpbX855VxFH0vE6jdXqHNrlS+4+m8M1uMq60Igy+HPcTmdz6Lv6F047mxl/J4MXX8J4fh+Ax25U6/tcVTTHGSV+dZaKeg2hkk9f5uUaQftDKC0l/YiwJTgO+Q5EO3Wy69D11Tdf0ohzwPCMICSv+gFY7CPnPXTUQ0XYDrUMAPFmcrCDbVRHhIVP7CWWADPiy7xGtvN3GD6DPxbUpZdOdBiNRKYcE1dp+k+H94kRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu2ka960XbAcKJ3drws4ddvcTGReWGESk/w8lot58zQ=;
 b=iMsPSz5jijkHpbfK5dhnTHIIUDisL6BLSOX68fEO5V8F+u7OFpnRYZIhkZ0zSM+XX2Kh5I4I+sq53x+ppR1UwAce1Do1NBzCZht9vYH5CqH/VONY8DxiDQiPcRQBenGwo4Ls92w/xnhPQBaYKgvRIwOEmmNWttjnXO6VlwAyEyAGel2avUp+1V99nDZPvkQHLCS1l5w7eyPw8fEsA83obgwt1SZGTfFbJ1Al5ImtIA3/W0vb1X4Yq87iRfu/R9oYE7MCB3kZ4C00iR2OjpeEB9A0/WQxnv2hP/U2Xa5O1Yhu2kywKY4/stn6d/+EPFBfuom4jsCVLoBKOOP+/ctzAw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by LV2PR12MB5775.namprd12.prod.outlook.com (2603:10b6:408:179::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Mon, 19 Feb
 2024 09:36:26 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Mon, 19 Feb 2024
 09:36:26 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Zhi Wang <zhi.wang.linux@gmail.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "mst@redhat.com" <mst@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
	"clg@redhat.com" <clg@redhat.com>, "satyanarayana.k.v.p@intel.com"
	<satyanarayana.k.v.p@intel.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "horms@kernel.org" <horms@kernel.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v18 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v18 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaYISKEq7ts7f4oEyo6sBByW/RK7ERawGAgAABoO0=
Date: Mon, 19 Feb 2024 09:36:26 +0000
Message-ID:
 <SA1PR12MB7199C1C570B00C78311666D2B0512@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240216030128.29154-1-ankita@nvidia.com>
	<20240216030128.29154-4-ankita@nvidia.com>
 <20240219112839.000060df.zhi.wang.linux@gmail.com>
In-Reply-To: <20240219112839.000060df.zhi.wang.linux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|LV2PR12MB5775:EE_
x-ms-office365-filtering-correlation-id: 8a061421-59cf-43c6-0b0f-08dc312e3e60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 us8JyJM6KEd6TcE1UCPrXi5FFx8fiUb1ZBM5ynQilcBcitpJ1g2hZ33nxhrXrrFVzkPDWuRv/2DWa7ndlYhNMhYrX3ezCI+KqSM3MGtEj+cuPxZA/1jiu7BBZ7v6O/oSqT2yJUxDfFzwsyLzZOnXxjZ113YRGM0YEV9b30Gam85CnxVJbPzNsPs6ogtT8iAyyWCPdrs7QilnHPF/IxPixM+yRwvp2ogfKmwO0op1suqoao+oIxDu5VzV7ZUmNx0MdwKkYOt829EFGSjqyZSa+6tch4PN+N01XF4hmdmaXyh0bVKGCueQbCUo6P3cncIN8o6+AKcxxuQvYQ7Cjy1k2VEStKPKpRRheRpVS1+4uzFTaq1x+6cUsOyUKEYVk4VX3paGf+Cp50omNsAdtTCe26r9OIRHCeHYe6pouP34Dj9uoQHLxlCYQ159nEF4ShxY1+kHZ4RDbB99cjF/Y+V04r+w/4x54eyoH3zdMN8iKW/HM3XcPkZlh2427+gjjOF3n+qIk0cr5nQIzxU8APkKdwuBQNK+W2BYvyQrS9e40Ibrw7XbOCp9jYEvnddhTtyKb0zZk7Yh7rfxwMMKxUkTSL7+2AkTN0cYxT90v26GKa/T2SQf6nGMeKfARTtgpTN/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(376002)(396003)(366004)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(2906002)(5660300002)(7416002)(55016003)(26005)(66446008)(76116006)(91956017)(8936002)(64756008)(66556008)(66476007)(6916009)(4326008)(66946007)(316002)(52536014)(41300700001)(83380400001)(38070700009)(8676002)(86362001)(33656002)(9686003)(71200400001)(478600001)(54906003)(6506007)(7696005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?W7m6vDrpfM0WC7XfL2WutBCZ9MdXjSqfUJXRhOuqsQFtPo2CCzCznVsruA?=
 =?iso-8859-1?Q?4sru+OqzRgLAbIxlzRBkDbk0NORGLN5+jtPcOw641IKutIGhtII5njW59V?=
 =?iso-8859-1?Q?bfWYFQbLEaQj1OpF2gdZoYiLulpQpe8k8+vYvrEfZ4GvkCY5uYFQqEFzpE?=
 =?iso-8859-1?Q?iKblNFMFFAxb+os+NWtsYH8UfJHhnK+gR5UjJculFh2l20Ve3QihBBDp4j?=
 =?iso-8859-1?Q?kA3ceOE4FfYRCp4wjS9IpX8DGdbIZM3qwLk5fQ1MPUrFWfnT2zxHQ+LR/O?=
 =?iso-8859-1?Q?omzw7vvqOqs3FQZdH+JyfuLEGzIHWD6kIphUm+qU0CRviSoOsmaK/6/CPh?=
 =?iso-8859-1?Q?QsSYoVNYMHbliI3xPLPpq8xIxQK5GbINf2F14uuVjGg94Yl0FlQWB3OBZd?=
 =?iso-8859-1?Q?HBoMdC6WQb34k3IfFWRBMvfV/pThLPzheBaAm0dVfCvpy93CFVaCI9MXbR?=
 =?iso-8859-1?Q?mpz8LKgIFSBxF12uyMuYADZ0onaLJDWsZY/9EEXmVuFcPI5fKNjK09QOoT?=
 =?iso-8859-1?Q?UspJnxA6MYLG6nlw76hatxyLly78MHJy/X1IWS1/RrmwPNchKK5Z5yqaS3?=
 =?iso-8859-1?Q?HT5SHqZ3tyBwWiqxKll7g0h+ZUK1KEWSO87rRl7Wb1seHLno+xDVIACNop?=
 =?iso-8859-1?Q?s5qjQcguudJOZS2RZqpjgSP2aO8TeMEh0YxPlvkqmaW1Ln8yophcRvOPY5?=
 =?iso-8859-1?Q?a4bsVpiz6jKqM0jjhXAIqjnZaVra2kgRDrhVc7P2kQn/ew+kFrKTqRbmfQ?=
 =?iso-8859-1?Q?TYL6UYNaki3UC+myePWWm/Zsz9wsuRhElB6Oe3vH7eJzODRtdqGUmo3/C1?=
 =?iso-8859-1?Q?rvI6eW8mwrYIDHA1S5rXdWDJtRf+Pl+0XPKuUiSzYdPsU3cUi8p1iPBvGF?=
 =?iso-8859-1?Q?ADWZ7KA/zzfk423e2Clr6jn5LRD24CiFb/dqs8eQxE0AvCPBf9ezrqVDwI?=
 =?iso-8859-1?Q?k9fKnu38mv28YE4QWSQnM/dYrlampyiFRpf9DbaWvhqjBfgOzsoqttdxMj?=
 =?iso-8859-1?Q?iibjpkm0LbfBzMPTHJSIg8BM5AYiX6k7i2pMHxq9D545BYvZR+xU28eq0R?=
 =?iso-8859-1?Q?2Vwcj1DShmYasg/Ri/y9Pul0DabJ/d21+ZO7uq7qVgPRXNFhpoAxfpC44W?=
 =?iso-8859-1?Q?Og6oTNvE9+MuyKvbdBNJoERyebMOiaNlCSmCm0M6/Uu/I10033KZHM39NX?=
 =?iso-8859-1?Q?nT1ZMs2vArAKLnRaG1H7eqPjWVCT55LpmfnF/khyTs56XFQN0nAojYSadL?=
 =?iso-8859-1?Q?qSD6f6ZR9/ZwNtzNZudxV2MrMy30llgw/qf/0/MOPhtwclxFY/Qn2N3j6p?=
 =?iso-8859-1?Q?KI096Et/yiekF7ZBqFVMgs3/sAe9+s/dyDZ5NdRLbGE6ekM9hqVWjM72Yd?=
 =?iso-8859-1?Q?vB95Grj39/XQ5ROM/7NPkgBCbcYBdEIuvGHtgEEfD1a5v7mEnJIsZx2hTO?=
 =?iso-8859-1?Q?SrwNJmAvOenc5bpEDqnXbJBtd7ACHlq7PjvOVqITsu3mwJ02Ck0i7JXhoo?=
 =?iso-8859-1?Q?/wx9FkdsmzCtfjNa4W7Sd1zqq6NddMsb75x6RHlhT26w/pyqwZSGPf6Lzj?=
 =?iso-8859-1?Q?iTfL6IBa75pDfk6ShIUK4zVGdkq/vX8KVa1OrtIYuMAcdtoy5MorPA7btg?=
 =?iso-8859-1?Q?X/DhtmaEQkuWw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a061421-59cf-43c6-0b0f-08dc312e3e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2024 09:36:26.4475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JN19g+Mjaq3PNcxunR0eToRyBfiZvCsIIQHGySDzJMAhe70SOyOyyiLjya2JfKIxs+TiDoYK9uM6z7MjdySWjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5775

>> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
>> b/drivers/vfio/pci/nvgrace-gpu/main.c new file mode 100644=0A=
>> index 000000000000..5a251a6a782e=0A=
>> --- /dev/null=0A=
>> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
>> @@ -0,0 +1,888 @@=0A=
>> +// SPDX-License-Identifier: GPL-2.0-only=0A=
>> +/*=0A=
>> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights=0A=
>> reserved=0A=
>> + */=0A=
>> +=0A=
>> +#include <linux/vfio_pci_core.h>=0A=
>> +#include <linux/sizes.h>=0A=
>> +=0A=
>=0A=
> Let's keep the header inclusion in an alphabet order.=0A=
>=0A=
> With that addressed,=0A=
>=0A=
> Reviewed-by: Zhi Wang <zhi.wang.linux@gmail.com>=0A=
=0A=
Yes, will adjust that. Thanks!=0A=
=0A=
>> +/*=0A=
>> + * The device memory usable to the workloads running in the VM is=0A=
>> cached=0A=
>> + * and showcased as a 64b device BAR (comprising of BAR4 and BAR5=0A=
>> region)=0A=
>> + * to the VM and is represented as usemem.=0A=
>> + * Moreover, the VM GPU device driver needs a non-cacheable region to=
=0A=
>> + * support the MIG feature. This region is also exposed as a 64b BAR=0A=
>> + * (comprising of BAR2 and BAR3 region) and represented as resmem.=0A=
>> + */=0A=
>> +#define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX=0A=
>> +#define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX=0A=

