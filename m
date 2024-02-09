Return-Path: <kvm+bounces-8424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA69A84F23B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:24:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF5FF1C22766
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCAD67750;
	Fri,  9 Feb 2024 09:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UWJFW9bU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E551E664B1;
	Fri,  9 Feb 2024 09:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707470689; cv=fail; b=MzK89bKEnW+xleRuMeTro5nd5BokbA/9CjIJzdcY8ogZfU3dNhgU4/YQ56rQ6utb1PmeeSeU1J2s0nyT0AqtjmMvgyTImvX2cFDMk/Cg7zmnLtRm0OU9+EMyMtO4p2ZuDG0AivsBmlcUV9lluaCN97/5u5bodsaA930SSllVlaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707470689; c=relaxed/simple;
	bh=YymLysPctg7/1tTc2tLAHUueXK2dKzlIxWSqZKW/Q9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A1qwnLTIRpy00ArD2g6K4G8TyVPdLXl3COnt3q0lNfRyd9rhLaXEITGrcjvzISOyQxkjtNOBPT48mb7nRSSDcftAQP+zPHX3NC97N5TkjIsCSkgwOOy5XYhSXlVCZ3SkwzmM6usHsiZ4xgyHK+yBWNJ6jQFJiakRxLYpePgsMGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UWJFW9bU; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPWuZ3bPNboDdsJwmXrvPkerfBYrGyaUcGPyx4TvVM+beR3PR5GPv+0dc/c0Tby9NOwMedpBD20esE1TnDCjbq3wOpAAoeMQ7ipWmkkrlHA34/QvJWI385eThgpIPeNVJSTCJt6KXVxsAUHXl9rtuxH0ICWpz39IfTileeVgEFRuX6KCyAeuR2C5qSQjwcMFqgfxQXzh3jLhYeCZhh5HRdQRSrco9Hso+3Cj2xD8jJ/h4nlaHCdri82tzLec+rvC6ftg05Mk9MpI0tF74Pg4jUWt1QsrU5mphCZmhbbsoxopDqLyd6pCkPjwJzApwqQvXJgWLsbhLdX6h/0Ie6sqag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YymLysPctg7/1tTc2tLAHUueXK2dKzlIxWSqZKW/Q9E=;
 b=c451c4fRPLF2oUuaLOTVTaKepdE9/12rXrqguvqJrkh7xruePa7ggDFgXMn/YqOBT9bScDZhgRnLUxUBqR+xLYR11Uhh/6mbpXzpkp0Ab0G/pl7BpQ48hgtCaRRDWcqFYrHX/bKlgKQqI26fHpImbEP3DkRe5F6rAXyq/8cC5PrrWHG1NmlUDb5y2IAQw+HotEem3Wl2gAxsb52yms0eiIQt5kkffdqFn/FT0/N97CJv4ofE6jJSvbZeM3219WR/I+Q0cE0njgiSvYmXxj9b1kCV+0lYesfxOUGCMr+xWfkLWcDUbBCIs/F/nY+h+YT+4Lo+/Zk58D7/ua86Gh9l3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YymLysPctg7/1tTc2tLAHUueXK2dKzlIxWSqZKW/Q9E=;
 b=UWJFW9bUwKFNfxGkQRJ3RLhQR6uL+OMfyzG9PxV1qp4Q6Ra3NTm7soPA3sVcX3ZpyyEBFlU8FB2sfbt0infiP2UHrXuOhnLUlM2guTg2yNTdl8QLxmiZ6kaGNPziNHZozf8GAsn78kI65kVxfUyk/8nHZBIMBVelXrBCOBUeoRJ0bczOEzj2n2RdDOB4i+pZvuJ+cIJOQ9npFLIYxxKbmSGx4+lD4ncJXcs/mvpWVjp4oWT3AD87bRXtEDH1S7XsVPYXmEiyN98U3zFSzWl3KysNxaC/Y8fbWjeP4IjvwRi7/uVhfmhz62WXVIg+rop7wvGabotxpxUnKJPoMVREyQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB8156.namprd12.prod.outlook.com (2603:10b6:510:2b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Fri, 9 Feb
 2024 09:24:45 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::444d:2f33:a61b:3225%3]) with mapi id 15.20.7270.016; Fri, 9 Feb 2024
 09:24:45 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>, "Tian, Kevin"
	<kevin.tian@intel.com>
CC: Zhi Wang <zhi.wang.linux@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index:
 AQHaWIdUHF93rAkYa0SGXKd0AMy8rLD/eesAgAAPggCAAHxaWIAACBUAgACTjoCAASBDew==
Date: Fri, 9 Feb 2024 09:24:44 +0000
Message-ID:
 <SA1PR12MB7199E687F8F52552F27FE145B04B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
	<20240208003210.000078ba.zhi.wang.linux@gmail.com>
	<20240207162740.1d713cf0.alex.williamson@redhat.com>
	<SA1PR12MB7199A9470EC2562C5BCC2FAFB0442@SA1PR12MB7199.namprd12.prod.outlook.com>
	<BN9PR11MB527640ADE99D92210977E7CA8C442@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240208090947.1254e72c.alex.williamson@redhat.com>
In-Reply-To: <20240208090947.1254e72c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB8156:EE_
x-ms-office365-filtering-correlation-id: c8cdbccb-9a7d-4774-d36e-08dc2950f422
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 JOOKGTayq/2izX2mNStN46NQIYCqgv58IVWd/yET5B66ZV9aTGCj+nXm89XEUN6vyKECk5PpAMCR/xtcmQSJ/CJLcolrcL0C303oi+Nn0XnDz5kjkRed8KZ/80l5813YtHEQSXNaS3wzjHLGpdALWZQbqP7nTieyr2Z9cF2/JdbfSDYKGKBx66jPWVcffEG8y5Kt99msIKcBlNidIufTN57SBA05eQYreEOcDHY4VTrtfDb72vBWvmUDUAzCYa/PdhN8NNI2yIcb3QNLYgsADpdLDpVyWzoOgAlvoMoQ+0rQtPJ7Ui10eMJ6oHz9fryzmy+z02THtsSt6ZnkQ4T2oopL16WGRtouhPfP5p6AW2opPmBc09dhQ4QSU60RlRGdNfwXMo421VaAR7SapRimjgy8AQJuEY2SQC9YMeELjBLur3Rux+kmeRyPJ6qxGvkVYwW84DE95At8j5fKCsz8JBxiGvKrovZF4ISnvnuQ/DD390eXJIiuWRXDVqo5Wb62DiTrp+wIRxJB0qe6YvzhCoGfCMxbMJoAuZqmF25+fb+Gp+haT9XLRwydg+ZhLZCK2QZwOu4dygm8B/1NE36p4ijNEVQb0yrjiNyGiepEhgL8YAIX0T9A2J+vMrdGeeda
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(376002)(39860400002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(38070700009)(6506007)(83380400001)(26005)(54906003)(122000001)(4326008)(76116006)(38100700002)(110136005)(64756008)(52536014)(5660300002)(66556008)(7696005)(66446008)(8936002)(316002)(7416002)(66946007)(66476007)(71200400001)(8676002)(91956017)(478600001)(86362001)(9686003)(41300700001)(33656002)(2906002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CjIafwOvgVTKa/wlkDbmHRbzKwW6ubAW9Qs0bkaEaqZN3f5XfBsRnDgG56?=
 =?iso-8859-1?Q?/uyiqPzfJm1GI5bm0xjFIFGdLMmcTwGwpLUJRo9y6J8IBTbxefKJUVHtFW?=
 =?iso-8859-1?Q?il7Bdp/oOWowqc8bGZD5PQdVckhMcAYXNkZ+hR9ddRGiq7UQBaWIKgwH2O?=
 =?iso-8859-1?Q?IqEV2+4qZ6JE2r4hOaVNfopfhNcDqlNBzPusscmXT4xOwPEf7jbUUSV6U9?=
 =?iso-8859-1?Q?04TgLSzI27jryQaQNc+JvlMNxvjm4+WXbfT+wOxdM95cHFyiux3Q6/U3Wi?=
 =?iso-8859-1?Q?v8p6n7UuQyduAtypqKBYPR4Nxo7JJ+8mdEtvOK5SWt3W3pn4jZOkWAWejN?=
 =?iso-8859-1?Q?hg3UMdy4BcEA+y9rFev+tV1kI5eoiLqfPyMc1K8nWP7/ZN8zx9cseeOFib?=
 =?iso-8859-1?Q?VgymPZVQG4kEHk/eGQpJflziek2eIX0d1b5ztZ3LPrMqkic10V9h3p8ZX9?=
 =?iso-8859-1?Q?RDx6lhiN/v3XZ/wREE30EOvDHUUcEpar6TCsUn/+rXPJZ3QA/WeiHAO1pd?=
 =?iso-8859-1?Q?MvMmRVyp9oFUAUZSN8GvQ2P3U5ZMV4kyohrDa8wJBGRPhyuEEthGe6BBw0?=
 =?iso-8859-1?Q?nUu8pzpx7s5bLKC63uGrymYzhpUPsYNcmCNs1clFESmcE1Zjokt28NuPzD?=
 =?iso-8859-1?Q?pdxF5Frm+s2HCxjmoGdcdqbvvUE5nFCqQnwBpRN78hUNuyOFFixk3HX07D?=
 =?iso-8859-1?Q?V66/DkVSdVXmyQJlIQ6nD80My89/MN3RULsqQRwqJmcnkOFv3PzkSzQcVn?=
 =?iso-8859-1?Q?Zc62AJb4CcowAiV394i5s5F8QSLQ4TnSAphvOWFk3X+SL3w/nnVMRzREpH?=
 =?iso-8859-1?Q?iKkEAJlA74TWntKXPgfOQIrtYcYQ5j6MT2CYiTi7548Mzzk6BkinD/y8fg?=
 =?iso-8859-1?Q?RsRl9aVnkr6Ue+6H9GyYMV4DElk1jCvXtFBeVBwOpqikCffQx1QetENTGe?=
 =?iso-8859-1?Q?Mq1OPWKEsdwy/13OCGksae0OD87zpIhP6dDFf3ha2d3U7h7gQaGy6OCnLW?=
 =?iso-8859-1?Q?qmbMOnW+13lMWNc3Pa4D+CMCqh+60DnKc42BDWGAiyd4/kSzX/9+iVrADK?=
 =?iso-8859-1?Q?h3WyQBX1FiksZpcVumV/vxeZnVXEtXKpVngRnhUuPE1vxIhumcpkN0adbW?=
 =?iso-8859-1?Q?a7tvZ1sUwnfwY+ZhZuhNcP0Muk/v9OA2BpsGvPlXAgYP9XX3O+uXDv4T7g?=
 =?iso-8859-1?Q?aY4eu09F/IzeUpLTdZjamhcC2qZFCR48j5X1XZTv344mUlIMqhcVzAA9CM?=
 =?iso-8859-1?Q?8BuZ0uVAktPf3R1vYXJhv2y8EduhgW3Mb9+iF88FRePx8devsWFkWdfeif?=
 =?iso-8859-1?Q?2yaThjrM3g9HzgVD5DmFhTCAEAXAsPDRWJURP1hnezfXAIVq7SkGD3TIim?=
 =?iso-8859-1?Q?4za0ddM4NqQipDj8gkKZSd7zA/wJSE1Q1d0++w1QY+68fC5l3uYxu7EThv?=
 =?iso-8859-1?Q?a1xzM9tcODLL1a4aU3RS3NnbIGizFnpLdD10mAg+JFhrIiCMKZMV6d5fou?=
 =?iso-8859-1?Q?m29GyJbBH/WddG53dYhpAS8eGtEKLNvFZ83kW7G80TRiYTyMJ8qWQBH6CH?=
 =?iso-8859-1?Q?OXWCG36hsXvqhgk9FmzyBnCkkwikn35j/p8iFpN35xmZM0fhpqLyfC4+Pp?=
 =?iso-8859-1?Q?l6pbMrulyyzEA=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c8cdbccb-9a7d-4774-d36e-08dc2950f422
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 09:24:44.9668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: df1RV/BEsIjeKdlpb4fyweyd96UPdGzciOyU0KcbbeH/JcCOfEQYxFtFnRMOCP0qwcnU+nDZIrttVDVVGazfZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8156

>> >=0A=
>> > IMO, this seems like adding too much code to reduce the call length fo=
r a=0A=
>> > very specific case. If there aren't any strong opinion on this, I'm pl=
anning to=0A=
>> > leave this code as it is.=0A=
>>=0A=
>> a slight difference. if mem_count=3D=3D0 the result should always succee=
d=0A=
>> no matter nvgrace_gpu_map_device_mem() succeeds or not. Of course=0A=
>> if it fails it's already a big problem probably nobody cares about the s=
ubtle=0A=
>> difference when reading non-exist range.=0A=
>>=0A=
>> but regarding to readability it's still clearer:=0A=
>>=0A=
>> if (mem_count)=0A=
>>=A0=A0=A0=A0=A0=A0 nvgrace_gpu_map_and_read();=0A=
>>=0A=
>=0A=
> The below has better flow imo vs conditionalizing the call to=0A=
> map_and_read/write and subsequent error handling, but I don't think=0A=
> either adds too much code.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
>=0A=
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
> @@ -429,6 +429,9 @@ nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_=
core_device *nvdev,=0A=
>=A0 =A0=A0=A0=A0=A0=A0 u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>=A0=A0 =A0=A0=A0=A0=A0 int ret;=0A=
>=0A=
> +=A0=A0=A0=A0=A0=A0 if (!mem_count)=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
> +=0A=
> =A0=A0=A0=A0=A0=A0=A0 /*=0A=
> =A0=A0=A0=A0=A0=A0=A0 * Handle read on the BAR regions. Map to the target=
 device memory=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 * physical address and copy to the request read =
buffer.=0A=
> @@ -547,6 +550,9 @@ nvgrace_gpu_map_and_write(struct nvgrace_gpu_vfio_pci=
_core_device *nvdev,=0A=
> =A0=A0=A0=A0=A0=A0=A0 loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
> =A0=A0=A0=A0=A0=A0=A0 int ret;=0A=
>=0A=
> +=A0=A0=A0=A0=A0=A0 if (!mem_count)=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;=0A=
> +=0A=
> =A0=A0=A0=A0=A0=A0=A0 ret =3D nvgrace_gpu_map_device_mem(index, nvdev);=
=0A=
> =A0=A0=A0=A0=A0=A0=A0 if (ret)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
=0A=
Sure, will update it as mentioned above.=

