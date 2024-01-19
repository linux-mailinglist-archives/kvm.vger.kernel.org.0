Return-Path: <kvm+bounces-6459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E40308323D1
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 04:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13C8A1C23728
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 03:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB94D51D;
	Fri, 19 Jan 2024 03:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U55HxV1K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB403C15B;
	Fri, 19 Jan 2024 03:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705635205; cv=fail; b=Yjn6U+VrB1gFmjgBtN8+IWTVSPWGOU4m5L1ip57lXsTxaBl56KdDTByyqexsDYusbdEl8CjFI18Eq4/wS55sLSldLNDAAu2gpdN2rxBqzj/JG2fg3MF0viOXSmvkw9NJTjHU3h4GP+kN6IavcaRLyy9NSHfjYu/qaae6zLOFBFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705635205; c=relaxed/simple;
	bh=oEypWlceux+8Q0kr+NNlvFgst2EyTqoiRP9cwhGvNNI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tDG3iVHs4U6HUkz3YkWOrJJCy4oz92evZX5Wcy8Nzq87n1kA5HtWOEDY8+CYH4hIszNRUEzWAMy2VciEo+Sr53VFBIXbjdlsnJT2dRKxytgYAQGsKqdSLCsaecRvlOCtT5IJwllxRuVJIl4+j+L93+GZAYGpQ+rB5LKRjka/1mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U55HxV1K; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdnNUpmUoRxUMZqaQXQi7orN4OipwEqp8dzhHHAtGAtyec/SNr10CoWFVYhPsu8ZEAvPcLg6TuCxIgQIY6/SNdomyZ3jqU2dN+MtXdoDag9DY8ikAUSwA6q2hTUicziU6diTt9P3BuFnIiUoAih5OOiHzm8tNzazPMvXGLAcq/zsvFug+fWJt7Y6yWElaHpq4UbUOQ4uK1UUQSK5jJbFV8aZBR45xwDs8uA+t7Oe3YX5zdng40qf0GkgHi47q2cxvSbMlYnfS+5tXJX5DA+SOzsgRTVtBZoX4avtHco2thmBSucBEawadPi7y52M0Zhqui1pOt5lpma5FFCPoekaQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3KyIOZFj91vXBMcRJi18jocjmkqDGtQv+YLJJtO0vk=;
 b=SgnK+YsP801/uDcvbAaHwwPILRKGS52WfjH55m7vNbCW3YS/3HcZRtgTp/lXRfvQUWVA+HVjd8wo5vc1ua9SlhQTkcQRrl4uFlNFiVuH8p+zVLFZjAQDPR9j8PkcTfDvaYg+lkzhIuvvV2V5eWK6nzoctWvIQl46e0I1x/eZXeeTZg9ckrThrjqSISTYZvhAKcuqs4PkI21ayDBXHW+ZpEI+7EOgZZm+3jKWoCgHEUPZZ0N1QWv7dMqORyw2bmogGfRshxu0FVnujSElzFoJ2iZWMs3AgX+3yTzVe7NLU+07VUiV0yaYdpqCM7BsGJrsfDrLOIWuxR/RkFG3sKlVcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3KyIOZFj91vXBMcRJi18jocjmkqDGtQv+YLJJtO0vk=;
 b=U55HxV1K8TDVj9eWqancu/zh5vd64rtlivqd1gqGgw6tGPcVoe/fujQpHBGHk3A61UvMVhWE3tWG2JSbr+lS03lKMyfA22LqSgJUPyMiZeCi5OU73s3lyLytsQEXxrxt1T2uJSLDXhG8howEahMZGtdABz6q/rT01oP8UAH67iwjv1cVRelZXOlzfC4119y9aKak1a6ycoxyA28dcj1g42LybZp9GPuAXxUfjkCVYi+28geU3m74EDN33ggrwGBARNDhUHicEser7Uc+u4vc0W+Fm2QdzaV4VnFIAhQKpi54QKdsyLMvr2BPJPyuTAKMMxIMHjQcWJn9n2Z+/1b9Xg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 03:33:20 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 03:33:20 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
	<horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaR/gAEOL7lpwjh0CYcImo8660H7Detk6AgAG/dl8=
Date: Fri, 19 Jan 2024 03:33:19 +0000
Message-ID:
 <SA1PR12MB719904680D5961E6F1806F12B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-4-ankita@nvidia.com>
 <20240117171311.40583fa7.alex.williamson@redhat.com>
In-Reply-To: <20240117171311.40583fa7.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB5805:EE_
x-ms-office365-filtering-correlation-id: dabe70c8-2fb2-483c-21a8-08dc189f61d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 U5XuLCO/rUb0JZSUKfL0C0evfl6MyPjey04UPNHA0OOuCtrO6aePdmxg/dA9wZOZT/6gguS1Ty3FlZuF9fH6b70eerwP7MpPwLYvATFrUE8QxaOfwb7N++FSpqYFNUDxNEkWLwmSmDWb0E8JBV009hc/mmxKt/Zug8/WNucQd83J/1bwngG4VQSt+Osj3bkk/AAkoGdqI2t2pYWkBY9QFU09HdcG8MwvtAyF6q0ILJz5UzDNuA/8HNuXTJnDy3UzqsoCaTE0zJvMjI4pCfluWuqfvgYfh7hzb5aUb9WngBC0AheCl4srL6lASORvwF0rJAZtR/ZMIY8ONtVRUUrszBRpbhz5q1GfhYjre4ALhc+kHd99OEUdTtVT9T1r82NxSA8j6auQJFfb+k0m3GTk48mEs9VbuhL6FjAHh8RFu3Q1TTQjhJiVCRaihlQpaKM7XQlsJy4cp04/C654QSqHSHy2sNYL3q1ZizoWN/9m86Yu1G5wB5+ZAjM6xzPU/M9tSGzopWt9yBZlzteXjXBu7lFUF9wpYSKlHnXMHMERrH9jv/lsdthQ1eFOUFFEjDn3W5oK58curasNS9GeKi0aIz56fGaafgW4aLYMjdIZq2Omiur7YwWhxk1DOtaOqiaN
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(39860400002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(55016003)(83380400001)(38070700009)(33656002)(86362001)(316002)(5660300002)(26005)(9686003)(122000001)(4326008)(8936002)(478600001)(91956017)(66946007)(8676002)(7696005)(71200400001)(66446008)(54906003)(66556008)(76116006)(6916009)(64756008)(38100700002)(66476007)(41300700001)(6506007)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Uf+jnez+GV/R7nvC3sqR7wJB6OiNmA7wv7nL1UkKP1GwtpJCyxFWJIjdyl?=
 =?iso-8859-1?Q?wjMEf/wn2q6yzEhG88fYUDV3qM2aHOI0qpydLWfuVYlDxDKwlP5IjtaSPP?=
 =?iso-8859-1?Q?MEztg402wO1K4xU0E5LIdsB7qm7Oyh5/jEmVhziKfTANtR/zSE4clItv5G?=
 =?iso-8859-1?Q?12QYIOlD2krhkAVaue9FkpeC+0U1UROG3N6U15UFSVowrPnveRZBFycZIL?=
 =?iso-8859-1?Q?u6aklnQKiA7KkvLNw/BxQZZspvKnLCATSeQx99sTCfZD/QWmRlIpj/JkjG?=
 =?iso-8859-1?Q?gBuUiS/gbxUMDNviSN9CAs7l2Bc/mp86UeWNnPNeyT6QvVFyExNq4lM9qp?=
 =?iso-8859-1?Q?IuKr6jdUfA8/k3gx7S2mC1E5WkvZWUdlGQBzgmO4WzWh9b/GcwEBAOTeKr?=
 =?iso-8859-1?Q?WLgviw8udbwL0Ko+hFqi+h0INVWNuJQnHAaYVCkTDcMQ6qtHU08vRHCQsK?=
 =?iso-8859-1?Q?3vbiX+jh6o8VOBZbW+ToSJne1cBuEERYDtqvuH3P+T6vhA6AVInfi9fl42?=
 =?iso-8859-1?Q?2SpN4RoyacXz4NvPPLyxKSX1yFF4H4tbfiKk/fKDPi7numCrXs/XdSTP9r?=
 =?iso-8859-1?Q?rcYrm+jAEpR+aB3JuDFPbHiNR4r9styX2AmkEVMBHPEWvSxOkgdmib9F7P?=
 =?iso-8859-1?Q?2Y3VMMuqW/w+vXCxMjOO5+9WVROdD6YsFQMzxElB54i23dOD8us+D0VUdz?=
 =?iso-8859-1?Q?cZr86WuFUR4dHdswrC3GJhgmeSJDti7plHeHf8EAaJ7trEmJWCUNyVPkNN?=
 =?iso-8859-1?Q?Q/Qs0vPZroO4e0b7mHMj5AdeLoDku2l8AzdYe9FoxXrKGHX+K8Un5okzgr?=
 =?iso-8859-1?Q?hlNlj1DAvGk+RVsvzfv/XaCQNN3HnHU3bznvlEJBYdxg3gExkXfL8rzdwV?=
 =?iso-8859-1?Q?BU+JGAOt72bSAcqlH2DQSorLk+mObOfqUvxL6cHUNgvFZsrR3jTcT/umWR?=
 =?iso-8859-1?Q?7rWEVJN/jC1oiL+TufLpZqiVqTvaEhq/GDMiAtD6jo3YmETmSBiYYevBvW?=
 =?iso-8859-1?Q?st0omS1/erWuaAB41uYGjiDToLQ49FAYuTSs9/owV3CDV1Bi+Wh6rjLUrQ?=
 =?iso-8859-1?Q?5SBfGbi6NJZd+xQWSoyhkHcuy65ohpjD/X3M9Wfwoyb6NipGbYy3qi2xey?=
 =?iso-8859-1?Q?bfzg6D4ZTPdqeUeU2xr6fL3QwiGrGZ0O9JlLoEUTuOMDSGtn4eH2BmvnBF?=
 =?iso-8859-1?Q?G+GYV51yuqsWzdmx45sXMKbp1TtSPygY5gtVRD4sw4VvuizBC8JfrkZ76Q?=
 =?iso-8859-1?Q?TObveEC7VEa+ok8A9sXorMKNnq8kH4hJ2/QwYshI+DMQ4Uv2eRRJqPg0TL?=
 =?iso-8859-1?Q?3+hRLUGCjVYNNZuWvW+xatknwyV5xCNTkOhazGlH+moy3cpvTKWbBbjBf6?=
 =?iso-8859-1?Q?qEEi2iiYN/5PblgVf8W7UDGk5wZFgMqwtgotRjfNRjw3ybilpff4zqFj6Y?=
 =?iso-8859-1?Q?KvwJ4+ueaHwlAWwC8tR+k1iGcCS04AA9N5PgXOibBmFwFjmhR0lcFADlQo?=
 =?iso-8859-1?Q?/L/v2tGDKGx9rTg2pUcapjHW5eUWAXr5sEztLEo3qN5xreW1c5eLjzxbGo?=
 =?iso-8859-1?Q?COU1v38K4lS9gmlNOhoYq9I0TVG0AEl68RATFkQDoSx7RibL5j5qEokamr?=
 =?iso-8859-1?Q?jHQUwyE+nAJaA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dabe70c8-2fb2-483c-21a8-08dc189f61d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2024 03:33:19.9283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxyFK28IsHjFrmuGCShlRSTuQ+fG5CwK9i5IY1J9lnS6dr8bLzHcYKMfnIkXR2pMgKN4eVglhFyuBXhhYNfo8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805

>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>=0A=
>> Tested-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>=0A=
> Dunno about others, but I sure hope and assume the author tests ;)=0A=
> Sometimes I'm proven wrong.=0A=
=0A=
Yeah, does not hurt to keep it then I suppose. :)=0A=
=0A=
>> +=0A=
>> +#include "nvgrace_gpu_vfio_pci.h"=0A=
>=0A=
> Could probably just shorten this to nvgrace_gpu.h, but with just a=0A=
> single source file, we don't need a separate header.=A0 Put it inline her=
e.=0A=
=0A=
Ack.=0A=
=0A=
>> +=0A=
>> +/* Choose the structure corresponding to the fake BAR with a given inde=
x. */=0A=
>> +struct mem_region *=0A=
>=0A=
> static=0A=
=0A=
Yes.=0A=
=0A=
>> +=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0 * The available GPU memory size may not be power-of-2 a=
ligned. Map up=0A=
>> +=A0=A0=A0=A0=A0 * to the size of the device memory. If the memory acces=
s is beyond the=0A=
>> +=A0=A0=A0=A0=A0 * actual GPU memory size, it will be handled by the vfi=
o_device_ops=0A=
>> +=A0=A0=A0=A0=A0 * read/write.=0A=
>=0A=
> The phrasing "[m]ap up to the size" suggests the behavior of previous=0A=
> versions where we'd truncate mappings.=A0 Maybe something like:=0A=
>=0A=
>   =A0=A0=A0=A0 * The available GPU memory size may not be power-of-2 alig=
ned.=0A=
>=A0=A0=A0=A0=A0=A0=A0 * The remainder is only backed by read/write handler=
s.=0A=
=0A=
Got it. Will fix.=0A=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, =
sizeof(val64),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &register_offset)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val64 =3D nvgrace_gpu_get_read_val=
ue(roundup_pow_of_two(nvdev->resmem.memlength),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PC=
I_BASE_ADDRESS_MEM_TYPE_64 |=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PC=
I_BASE_ADDRESS_MEM_PREFETCH,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nv=
dev->resmem.u64_reg);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user(buf + copy_offset=
,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (void *)&val64 + register_offset, copy_count))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EF=
AULT;=0A=
>> +=A0=A0=A0=A0 }=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, =
sizeof(val64),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &register_offset)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val64 =3D nvgrace_gpu_get_read_val=
ue(roundup_pow_of_two(nvdev->usemem.memlength),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PC=
I_BASE_ADDRESS_MEM_TYPE_64 |=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PC=
I_BASE_ADDRESS_MEM_PREFETCH,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nv=
dev->usemem.u64_reg);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user(buf + copy_offset=
,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (void *)&val64 + register_offset, copy_count))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EF=
AULT;=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> Both read and write could be simplified a bit:=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_=
2, sizeof(val64),=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &register_offset))=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion =3D nvgrace_gpu_vf=
io_pci_fake_bar_mem_region(RESMEM_REGION_INDEX, nvdev);=0A=
>=A0=A0=A0=A0=A0=A0=A0 else if (range_intersect_range(pos, count, PCI_BASE_=
ADDRESS_4, sizeof(val64),=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &register_offset))=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion =3D nvgrace_gpu_vf=
io_pci_fake_bar_mem_region(USEMEM_REGION_INDEX, nvdev);=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (memregion) {=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val64 =3D nvgrace_gpu_get_re=
ad_value(roundup_pow_of_two(memregion->memlength),=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 PCI_BASE_ADDRESS_MEM_TYPE_64 |=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 PCI_BASE_ADDRESS_MEM_PREFETCH,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 memregion->u64_reg);=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user(buf + copy_=
offset,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 (void *)&val64 + register_offset, copy_count))=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retu=
rn -EFAULT;=0A=
>=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
Yes thanks, will make the change. =0A=
=0A=
>> +static ssize_t=0A=
>> +nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char __user *buf, size_t count, loff_t *ppos)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct nvgrace_gpu_vfio_pci_core_device *nvdev =3D=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 container_of(core_vdev, struct nvg=
race_gpu_vfio_pci_core_device,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 core_device.vdev);=0A=
>> +=A0=A0=A0=A0 u64 pos =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=A0=A0=A0=A0 size_t register_offset;=0A=
>> +=A0=A0=A0=A0 loff_t copy_offset;=0A=
>> +=A0=A0=A0=A0 size_t copy_count;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, =
sizeof(u64),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &register_offset)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user((void *)&nvdev-=
>resmem.u64_reg + register_offset,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 buf + copy_offset, copy_count))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EF=
AULT;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *ppos +=3D copy_count;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return copy_count;=0A=
>> +=A0=A0=A0=A0 }=0A=
>> +=0A=
>> +=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, =
sizeof(u64),=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count, &register_offset)) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user((void *)&nvdev-=
>usemem.u64_reg + register_offset,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 buf + copy_offset, copy_count))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EF=
AULT;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *ppos +=3D copy_count;=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return copy_count;=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> Likewise:=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (range_intersect_range(pos, count, PCI_BASE_ADDRE=
SS_2, sizeof(u64),=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &register_offset))=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion =3D nvgrace_gpu_vf=
io_pci_fake_bar_mem_region(RESMEM_REGION_INDEX, nvdev);=0A=
>=A0=A0=A0=A0=A0=A0=A0 else if (range_intersect_range(pos, count, PCI_BASE_=
ADDRESS_4, sizeof(u64),=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &copy_offset, &copy_count, &register_offset)) {=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion =3D nvgrace_gpu_vf=
io_pci_fake_bar_mem_region(USEMEM_REGION_INDEX, nvdev);=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (memregion) {=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user((void *)&=
memregion->u64_reg + register_offset,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 buf + copy_offset, copy_count))=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retu=
rn -EFAULT;=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *ppos +=3D copy_count;=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return copy_count;=0A=
>=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
Ack.=0A=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0 return vfio_pci_core_write(core_vdev, buf, count, ppos);=
=0A=
>> +}=0A=
>> +=0A=
>> +/*=0A=
>> + * Ad hoc map the device memory in the module kernel VA space. Primaril=
y needed=0A=
>> + * to support Qemu's device x-no-mmap=3Don option.=0A=
>=0A=
> In general we try not to assume QEMU is the userspace driver.=A0 This=0A=
> certainly supports x-no-mmap=3Don in QEMU, but this is needed because=0A=
> vfio does not require the userspace driver to only perform accesses=0A=
> through mmaps of the vfio-pci BAR regions and existing userspace driver=
=0A=
> precedent requires read/write implementations.=0A=
=0A=
Makes sense. Will rephrase it.=0A=
=0A=
>> + *=0A=
>> + * The usemem region is cacheable memory and hence is memremaped.=0A=
>> + * The resmem region is non-cached and is mapped using ioremap_wc (NORM=
AL_NC).=0A=
>> + */=0A=
>> +static int=0A=
>> +nvgrace_gpu_map_device_mem(struct nvgrace_gpu_vfio_pci_core_device *nvd=
ev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
nt index)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 int ret =3D 0;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 mutex_lock(&nvdev->remap_lock);=0A=
>> +=A0=A0=A0=A0 if (index =3D=3D USEMEM_REGION_INDEX &&=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0 !nvdev->usemem.bar_remap.memaddr) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->usemem.bar_remap.memaddr =
=3D=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memremap(n=
vdev->usemem.memphys,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 nvdev->usemem.memlength, MEMREMAP_WB);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!nvdev->usemem.bar_remap.memad=
dr)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -E=
NOMEM;=0A=
>> +=A0=A0=A0=A0 } else if (index =3D=3D RESMEM_REGION_INDEX &&=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !nvdev->resmem.bar_remap.ioaddr) {=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->resmem.bar_remap.ioaddr =3D=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ioremap_wc=
(nvdev->resmem.memphys,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->resmem.memlength);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!nvdev->resmem.bar_remap.ioadd=
r)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -E=
NOMEM;=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> With an anonymous union we could reduce a lot of the redundancy here:=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 struct mem_region *memregion;=0A=
>=A0=A0=A0=A0=A0=A0=A0 int ret =3D 0;=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 memregion =3D nvgrace_gpu_vfio_pci_fake_bar_mem_regi=
on(index, nvdev);=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (!memregion)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&nvdev->remap_lock);=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (memregion->memaddr)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto unlock;=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (index =3D=3D USEMEM_REGION_INDEX)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->memaddr =3D memre=
map(memregion->memphys,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->=
memlength,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 MEMREMAP_WB=
);=0A=
>=A0=A0=A0=A0=A0=A0=A0 else=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregion->ioaddr =3D iorema=
p_wc(memregion->memphys,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memregio=
n->memlength);=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0=A0 if (!memregion->memaddr)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -ENOMEM;=0A=
>=0A=
> unlock:=0A=
>=A0=A0=A0=A0=A0=A0=A0 ...=0A=
=0A=
Great suggestion, thanks. Will update.=0A=
=0A=
> BTW, why does this function have args (nvdev, index) but=0A=
> nvgrace_gpu_vfio_pci_fake_bar_mem_region has args (index, nvdev)?=0A=
=0A=
It shouldn't. Missed to maintain uniformity there.=0A=
=0A=
> nvgrace_gpu_vfio_pci_fake_bar_mem_region could also be shorted to just=0A=
> nvgrace_gpu_memregion and I think we could use nvgrace_gpu in place of=0A=
> nvgrace_gpu_vfio_pci for function names throughout.=0A=
=0A=
Ack.=0A=
=0A=
>> +static int=0A=
>> +nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device *nvdev=
,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char __=
user *buf, size_t mem_count, loff_t *ppos)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);=0A=
>> +=A0=A0=A0=A0 u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=A0=A0=A0=A0 int ret =3D 0;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0 * Handle read on the BAR regions. Map to the target dev=
ice memory=0A=
>> +=A0=A0=A0=A0=A0 * physical address and copy to the request read buffer.=
=0A=
>> +=A0=A0=A0=A0=A0 */=0A=
>> +=A0=A0=A0=A0 ret =3D nvgrace_gpu_map_device_mem(nvdev, index);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>> +=0A=
>=0A=
>=0A=
> This seems like a good place for a comment regarding COMMAND_MEM being=0A=
> ignored, especially since we're passing 'false' for test_mem in the=0A=
> second branch.=0A=
=0A=
Good point. Will add the comment.=0A=
=0A=
>> + *=0A=
>> + * A read from a negative or an offset greater than reported size, a ne=
gative=0A=
>> + * count are considered error conditions and returned with an -EINVAL.=
=0A=
>=0A=
> This needs some phrasing help, I can't parse.=0A=
=0A=
Yeah, I'll itemize the error conditions to make it more readable.=0A=
=0A=
>> +static int nvgrace_gpu_vfio_pci_probe(struct pci_dev *pdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct pci_device_id *id)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct nvgrace_gpu_vfio_pci_core_device *nvdev;=0A=
>> +=A0=A0=A0=A0 int ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 nvdev =3D vfio_alloc_device(nvgrace_gpu_vfio_pci_core_devi=
ce, core_device.vdev,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 &pdev->dev, &nvgrace_gpu_vfio_pci_ops);=0A=
>> +=A0=A0=A0=A0 if (IS_ERR(nvdev))=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return PTR_ERR(nvdev);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 dev_set_drvdata(&pdev->dev, nvdev);=0A=
>> +=0A=
>> +=A0=A0=A0=A0 ret =3D nvgrace_gpu_vfio_pci_fetch_memory_property(pdev, n=
vdev);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_put_vdev;=0A=
>=0A=
> As a consequence of exposing the device differently in the host vs=0A=
> guest, we need to consider nested assignment here.=A0 The device table=0A=
> below will force userspace to select this driver for the device, but=0A=
> binding to it would fail because these bare metal properties are not=0A=
> present.=A0 We addressed this in the virtio-vfio-pci driver and decided=
=0A=
> the driver needs to support the device regardless of the availability=0A=
> of support for the legacy aspects of that driver.=A0 There's no protocol=
=0A=
> defined for userspace to pick a second best driver for a device.=0A=
>=0A=
> Therefore, like virtio-vfio-pci, this should be able to register a=0A=
> straight vfio-pci-core ops when these bare metal properties are not=0A=
> present.=0A=
=0A=
Sounds reasonable, will make the change.=0A=
=0A=
>> +struct mem_region {=0A=
>> +=A0=A0=A0=A0 phys_addr_t memphys;=A0=A0=A0 /* Base physical address of =
the region */=0A=
>> +=A0=A0=A0=A0 size_t memlength;=A0=A0=A0=A0=A0=A0 /* Region size */=0A=
>> +=A0=A0=A0=A0 __le64 u64_reg;=A0=A0=A0=A0=A0=A0=A0=A0 /* Emulated BAR of=
fset registers */=0A=
>=0A=
> s/u64_reg/bar_val/ ?=0A=
=0A=
Fine with me.=0A=
=0A=
> We could also include bar_size so we don't recalculate the power-of-2 siz=
e.=0A=
=0A=
Sure.=

