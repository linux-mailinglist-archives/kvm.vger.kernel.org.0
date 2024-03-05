Return-Path: <kvm+bounces-11024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC0A8724A6
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACB6A1F26A68
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC2214A9D;
	Tue,  5 Mar 2024 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gKNKc3xg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780C5C15D;
	Tue,  5 Mar 2024 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657199; cv=fail; b=BRZPGxpAU9sWB5TbKKi0IN9ylVuO9HpryufvmSRxoW6dFrCt5TCTNGk3nrap4kGP21QMv+U0rMkryGXrkBI0Z4qhnzuCWzj1pkCeAi72jmpquKlzfIKDADpnxLbO2LGKaGMP2uLhhMtCM23tSPkNRVfWuCx7/K0l23lTVHAQTLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657199; c=relaxed/simple;
	bh=DJcKai7m9LzOrJqGTKJOqgNJFd8P6xl9Guh1Ax4PQKU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hrh6Lxt3WbfYSpVYRo2kY/t43vr43MG6wN9Ei4WUmZnOXEYeuP7+ClxTx+ewRsUL8SvnuCGReskFu5d6fFMUqwHdhmorCttqwxMa7x/0AvkEcB3gA7gNDGD/fldOxvezYit7SwC36OgdWgUrKobyjWCfw/nX3mmavAzxKN1KPEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gKNKc3xg; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea1oUXhyvy7VPzfJRYvhi9mVTp1eHHe7jX1t3ltcw+U+aO8SttIQ8OO/KIvjimkKL2rsCWlZ0GNeivPJGhJsznzSdqoBFYn1zxCiENpSQ/qIQEvWbtf0/GUC1KMhMdmK7ZLEGNg/4AdiiQAc/Kkb76+lvF8xXfQU7ZLMogrqEbo8yXDK7D0ILglanujZQe/cWPzS06FOfA3HP/lE8l95I4aR53rwPj3rMhQT6tj3xRMpA+i76nc9dHt/S4YZoQTZ74TSIlc0szPzc/YPFqGS4+8ubqen9cAc3qAKUUOe5Vrj5tfOlnYLd682JDMN+6wZhgHsH2ukJWNeOXA3rSrFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJcKai7m9LzOrJqGTKJOqgNJFd8P6xl9Guh1Ax4PQKU=;
 b=BdpkTSRL97lvzzGv7Bf4yOA6tnsDNDX2zh3GlESYCYpbrXkop3bGpA97ViZEUzOt0HJ4leG3WR2Mw6xtq5kthLqZe9fSaStHSMRZfYvSrCZyeNhz+J1JJkkC+BDAK+yOTtaiVg9UL3jsHppxkr5PrlDYcH3VWxg+clIwBSmSZADYcmZ2WjPq9R0y4L5qXcwKLaQi7xrptsf8AKBVoc49aOpC9xTo6DwKNMQypcpdrM5AaJlAnosL+8rwhZmXmHlNI/KEc6GEDF6NOE/40T2iF1SI4KqWj4yP88hrgx+/+E1SNlMcVHHN4Q3AQWqxlQBABK0ZJYOW/jEcobXmjDksiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJcKai7m9LzOrJqGTKJOqgNJFd8P6xl9Guh1Ax4PQKU=;
 b=gKNKc3xg16ZpDY7aLkilz72VXxXmv1dMP961FmhQOFMAnaf7mdsAYnwehxbFdJojV2FxTP2bKDqMXr48jyFmt7CKkRFiALAMxb1CGC3ghwugRAozVw1+YcJ1GNIsNWKg/gDsFuYGoLnAkGyPKoYqVy2yhuTNmtbXvE6U6t88K8mjrmFryMBUsd5mgUYc3OaxEpi1GJebx/ziOtE3n4qQ1XsIr39DdavWtGjXgVL1rUqYV/kHN8cb1wrHgB4zzFYekwtAs2H0wT+RInfShMvVcL3MdeqWwzQBB3bHgbiEPByrwzdNY7Kv6P720jSeeJ6Ioo8p+kNh7ZKMaE6/1de23Q==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SA3PR12MB8763.namprd12.prod.outlook.com (2603:10b6:806:312::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 16:46:33 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::a1:5ecd:3681:16f2]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::a1:5ecd:3681:16f2%7]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 16:46:33 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Leon
 Romanovsky <leon@kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>, Marek
 Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>, Will
 Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet
	<corbet@lwn.net>, Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas
	<yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Bart Van
 Assche <bvanassche@acm.org>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>, "jack@suse.com" <jack@suse.com>,
	Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Thread-Topic: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Thread-Index: AQHabu8RTS4WklM5BkqSvNX/cXqR77EpTDsAgAAEsICAAAikAIAAAe0A
Date: Tue, 5 Mar 2024 16:46:33 +0000
Message-ID: <4abe98f4-8179-4422-aee5-ae47552e28b7@nvidia.com>
References: <cover.1709635535.git.leon@kernel.org>
 <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
 <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
 <06787e6a-4e78-4524-960d-ec24b9f38191@kernel.dk>
 <22a03aa8-f121-486e-8471-ceecbe452b35@nvidia.com>
In-Reply-To: <22a03aa8-f121-486e-8471-ceecbe452b35@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SA3PR12MB8763:EE_
x-ms-office365-filtering-correlation-id: f229ae99-f367-4f76-d9ca-08dc3d33d08e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KsjYwnfFRknABLNHqRFrVESNgfehX/yrXqmzA6+/Q0CT5oAuBVt6a1YVZgJFLSQZD62U0WojXPzbu2+qv1YglMRieJC83GXqa9/jh37ZYcge88sn7jA2n0oWsaAGB30dsh0No2WQQorhdn+9DYcoS2szGsoPVRfKkEFRYLtP1q9lVjUTOX5pBVxTZ1SYIzYeCin7noiWMJ/2fAZmrmN/6/LJpXkw6vmzQ23bO2cEsX5eu+edOFkUmIgHut5cxS80Bnrb4VpjSJCQJuKGxeU0CocpDPWpKsC6ulicflpVlPfH8l0fXRiPVaTk8YExxqUMr/qd+Ao7y2JapCj73wzyUwJrBR4rBqts4pzNLpJ0hpam04DZsnqdIM55y3m2zmqp5Pdwsu2u2up3bEdXXAQgRyvY5DlMBkiJXMxk33B9c0RZkBfjY2k7GCq6og5zeJpxMIZ5aNB+GmY5+6oTE+362HFlZ+bvn5GAyCybP/hPN5FQIiuwpHSAup1bkQrzWnC+rHVIFy3oBASPO6h8b7xc3nQ8m8dNzZcNHBDRuYrMpiOxJ4d5N8+8qP2FVxzhe7oMYPa0xYidFVp2iWAFTQD1UNat2W9LKJoLJ7j9niTz+WVdutc72QfsuFLDlkImc+NUgfbEJ9HRu1bTAsReWUcHRYQhpM1lyJFqG5Uyb5cvcK4lkoTW+ahUzZNTYwWEIqtz9E/zsi4HF86F2G52ccJyhpI6KoHYPKnhyQPHKdy0iYc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YzhGR21MQVlYTTNuN3kreW1YYmo4Tm5BQVlzMDliMDNROXNvcVRJazB1OGF0?=
 =?utf-8?B?VjBWTERldDlrcU5rRm9pWklkWUo4WEpLR0Y3SlpsQ2xZOUk5b0ZnQlBhNExR?=
 =?utf-8?B?cWlkRlczb2xNeHU1OXpneHdFZ1JuVHdzOFRhdFQ4OXJYd1dzWHJpNWtoTHdG?=
 =?utf-8?B?MjJyOTdOZnR2Qi9GTU5pT2dYRzJaU3cwbVNCZUZENWRRMkdoSk9RWEM4ZUpo?=
 =?utf-8?B?K2cyTmNlVFduNjN6aEpEMG4xbGc1Z2xibmN5bml1MGFVRy9tNDF1WDh3NHc0?=
 =?utf-8?B?V1pQSzNNUHFjMnhuN3psbm5PTEdnTDVURE1oVHMwelo4bVFYcUg3OFR5aWRt?=
 =?utf-8?B?RVYwTWpzM3VESml4NWM2cXh5OUZpcSt5eFlFeXIzVVgxZUV4USt5QWF4T0lI?=
 =?utf-8?B?RTVySWROeEhISFF4YmRlTEJiK3ZKaGNCWWNORFNlUzRuTWpIV2xET1hVMWMy?=
 =?utf-8?B?S2pRZ3lqQTYxUlRqa3JtZlZ3MWhqTXNFMmI3OW12QWMvOVMwbXlaNmRFNUkr?=
 =?utf-8?B?Ny9tdkRjRVQvL0RLTEpNb29pcVB2dkVSK0o5KzBPU3pVOU9yUkVOaVBsVkho?=
 =?utf-8?B?ZG5XL0N3elpicXIzZVUwd29tT1dieFRPTXB0cUVsMi83dFpyR0tmN1BwZW1K?=
 =?utf-8?B?eWNHU1FoSnZQbDZ0M052Y2hHOFlqYzB6UDNONzZ0cTZpZEZUTHRHeU03ZUxH?=
 =?utf-8?B?RzBHYzJkZkpkL2htdVFUa3JuaXR0UW1ZZXVWSVF2dWR1MlpkMktSOWhxVHZZ?=
 =?utf-8?B?K3R0T2RpRDNBb1NvajJMVWk0bDZZclBwcllrV1hOVThBMUdXdTVBNCtMRE5X?=
 =?utf-8?B?OUdROWtRdTE2MHZFNzBUN1BtckFVbzdOSmVSYUZLUzJUb0ppTG5nQmdxeGFx?=
 =?utf-8?B?bjVGSFNMTlE4N1R2TUFWd3pDNDNDY1VIZytZS1I1cGxRZlNJNHFra1NmaDA1?=
 =?utf-8?B?Sm84KytTVDl6Y0J6ZlI3NVEvMU1CMTd1QVk4b2FDYjIxak5jVkpIVnNGdlRH?=
 =?utf-8?B?SHd1QXU5aWVGbkVjK1RydnhhbmNST0hSVmVmeVdzSFo5QmUxOEMwb3YwbnlS?=
 =?utf-8?B?WUVVQUdtbzIxdUdiZk9JZmNLRmJydFl4d1FpT0liV2RGL3NDYlQ0aldrNFUv?=
 =?utf-8?B?b3gyWFNITDZsUVdSZWpkenYxaHJ6VkwzZWoxV1dSMlN4SytvL3hUeVhxdm9q?=
 =?utf-8?B?SmoxbkI2aEZRTUZENlRVQkhNK0tLUXJIRHlUTUhmT0JJbm5sZGJsVFRxUTBZ?=
 =?utf-8?B?SGNaM05Ub3EvSnhOZmlzRjdQa3Z0YXUxZDBDajQ0NlpvNmdVVUlFZ3RsSU1w?=
 =?utf-8?B?VHEybzNCTkJoclFQQkUvQlBUUTd1LzE1dWJvTnl4eDVzSW9HcVNCNjY5ZG0x?=
 =?utf-8?B?eUxhRE0vbmhVWStmYmlZUThtUzRwT1pFVEo2YithTmN4ZHBCdjBNQkJiWUdo?=
 =?utf-8?B?MCt5UXliL1JpRWE1WDRKSUtYNFQyL2hmUHdxKzJud1BJNTFxUUNZYzdOTDE5?=
 =?utf-8?B?b2ZwSjZRejc5NnU4MnN1eTJnUkFmUk1teHl5TmhOUGpSTW1vdVNESlZoVGR2?=
 =?utf-8?B?djBlcHhBQjFINmRYd3R4OUVINVdaSDk2QzdCbHI4ek1sUzNoNmtxOVZaZHFI?=
 =?utf-8?B?L25rdEQrZUdZalNiblZ1SVdWQ2RTRDRwZjBOSG90aTdVa3ZmTFVka2ozeGRs?=
 =?utf-8?B?WjhUdFZha3ZLTWtYOE9MaXhCVUNoaHNhbnJPcnN5Wi94aTFDL1Q1TDhtRUha?=
 =?utf-8?B?Ti81c08zaUlRMjlEUjRuZmFoTFJUakdkZ1dib3NsTmRUeEFtVk5xajQ3NWNz?=
 =?utf-8?B?RVRDTXdhbnpqaFR5Yk9Kc1BRbzdKa3RWbkdHSTZKMDdlY2krdFFlblgyN2xE?=
 =?utf-8?B?NDZNclhqTTlianhHQUZMV1lUUGdnS0NlMjUwYXFmTWkrWUZqWWtJSDNSNEpm?=
 =?utf-8?B?WGg0T1hGaXlUL3ltRkQwODVoMzF0YTZZRVhvSW96ZU1VbjVrNCtrWGJHbXFF?=
 =?utf-8?B?dzhlajEwaDFQaldRSnY2WmYvYTRlcXFhczdVSnBVSDFHUWpjWEljc0c0Wjd3?=
 =?utf-8?B?YTBvb0g2MnRLQkVQdWQxcUlrRENrYm1Dc1FUODVHZ3VjdTBwRzN2V0VZS3lu?=
 =?utf-8?B?a2ZsUXBuaWxET3pTZEFVQzhVTmxCVW45MHVkOFhienNhWG1OVy9QdkwvZ2hG?=
 =?utf-8?Q?WbXs0ZaUfvcp/+AIau8eAGSScElSJM349YoI+3a6RK+f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F4549C93F28564485E646B889C44D5F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f229ae99-f367-4f76-d9ca-08dc3d33d08e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 16:46:33.1393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9gR30T0zNoTr0BwuG6fYBEY3FJXv/dWeuL0ENuF8wgZVnNCLaQqVei5p+EITBUof9AxFfOj7ncU8TN9k4Lmosw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8763

T24gMy81LzI0IDA4OjM5LCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6DQo+IE9uIDMvNS8yNCAw
ODowOCwgSmVucyBBeGJvZSB3cm90ZToNCj4+IE9uIDMvNS8yNCA4OjUxIEFNLCBLZWl0aCBCdXNj
aCB3cm90ZToNCj4+PiBPbiBUdWUsIE1hciAwNSwgMjAyNCBhdCAwMToxODo0N1BNICswMjAwLCBM
ZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+Pj4+IEBAIC0yMzYsNyArMjM2LDkgQEAgc3RydWN0IG52
bWVfaW9kIHsNCj4+Pj4gICAgCXVuc2lnbmVkIGludCBkbWFfbGVuOwkvKiBsZW5ndGggb2Ygc2lu
Z2xlIERNQSBzZWdtZW50IG1hcHBpbmcgKi8NCj4+Pj4gICAgCWRtYV9hZGRyX3QgZmlyc3RfZG1h
Ow0KPj4+PiAgICAJZG1hX2FkZHJfdCBtZXRhX2RtYTsNCj4+Pj4gLQlzdHJ1Y3Qgc2dfdGFibGUg
c2d0Ow0KPj4+PiArCXN0cnVjdCBkbWFfaW92YV9hdHRycyBpb3ZhOw0KPj4+PiArCWRtYV9hZGRy
X3QgZG1hX2xpbmtfYWRkcmVzc1sxMjhdOw0KPj4+PiArCXUxNiBucl9kbWFfbGlua19hZGRyZXNz
Ow0KPj4+PiAgICAJdW5pb24gbnZtZV9kZXNjcmlwdG9yIGxpc3RbTlZNRV9NQVhfTlJfQUxMT0NB
VElPTlNdOw0KPj4+PiAgICB9Ow0KPj4+IFRoYXQncyBxdWl0ZSBhIGxvdCBvZiBzcGFjZSB0byBh
ZGQgdG8gdGhlIGlvZC4gV2UgcHJlYWxsb2NhdGUgb25lIGZvcg0KPj4+IGV2ZXJ5IHJlcXVlc3Qs
IGFuZCB0aGVyZSBjb3VsZCBiZSBtaWxsaW9ucyBvZiB0aGVtLg0KPj4gWWVhaCwgdGhhdCdzIGp1
c3QgYSBjb21wbGV0ZSBub24tc3RhcnRlci4gQXMgZmFyIGFzIEkgY2FuIHRlbGwsIHRoaXMNCj4+
IGVuZHMgdXAgYWRkaW5nIDEwNTIgYnl0ZXMgcGVyIHJlcXVlc3QuIERvaW5nIHRoZSBxdWljayBt
YXRoIG9uIG15IHRlc3QNCj4+IGJveCAoMjQgZHJpdmVzKSwgdGhhdCdzIGp1c3QgYSBzbWlkZ2Ug
b3ZlciAzR0Igb2YgZXh0cmEgbWVtb3J5LiBUaGF0J3MNCj4+IG5vdCBnb2luZyB0byB3b3JrLCBu
b3QgZXZlbiBjbG9zZS4NCj4+DQo+IEkgZG9uJ3QgaGF2ZSBhbnkgaW50ZW50IHRvIHVzZSBtb3Jl
IHNwYWNlIGZvciB0aGUgbnZtZV9pb2QgdGhhbiB3aGF0DQo+IGl0IGlzIG5vdy4gSSdsbCB0cmlt
IGRvd24gdGhlIGlvZCBzdHJ1Y3R1cmUgYW5kIHNlbmQgb3V0IGEgcGF0Y2ggc29vbiB3aXRoDQo+
IHRoaXMgZml4ZWQgdG8gY29udGludWUgdGhlIGRpc2N1c3Npb24gaGVyZSBvbiB0aGlzIHRocmVh
ZCAuLi4NCj4NCj4gLWNrDQo+DQo+DQoNCkZvciBmaW5hbCB2ZXJzaW9uIHdoZW4gRE1BIEFQSSBp
cyBkaXNjdXNzaW9uIGlzIGNvbmNsdWRlZCwgSSd2ZSBwbGFuIHRvIHVzZQ0KdGhlIGlvZF9tZW1w
b29sIGZvciBhbGxvY2F0aW9uIG9mIG52bWVfaW9kLT5kbWFfbGlua19hZGRyZXNzLCBob3dldmVy
IEknDQpub3Qgd2FpdCBmb3IgdGhhdCBhbmQgc2VuZCBvdXQgYSB1cGRhdGVkIHZlcnNpb24gd2l0
aCB0cmltbWVkIG52bWVfaW9kIHNpemUuDQoNCklmIHlvdSBndXlzIGhhdmUgYW55IG90aGVyIGNv
bW1lbnRzIHBsZWFzZSBsZXQgbWUga25vdyBvciB3ZSBjYW4gDQpjb250aW51ZSB0aGUNCmRpc2N1
c3Npb24gb24gb25jZSBJIHBvc3QgbmV3IHZlcnNpb24gb2YgdGhpcyBwYXRjaCBvbiB0aGlzIHRo
cmVhZCAuLi4NCg0KVGhhbmtzIGEgbG9nIEtlaXRoIGFuZCBKZW5zIGZvciBsb29raW5nIGludG8g
aXQgLi4uDQoNCi1jaw0KDQoNCg==

