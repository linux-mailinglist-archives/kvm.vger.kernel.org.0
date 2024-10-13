Return-Path: <kvm+bounces-28701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F8799BAF9
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 20:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 233182813FF
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2024 18:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A71D1494D8;
	Sun, 13 Oct 2024 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fICAdxNg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D25013DDAA
	for <kvm@vger.kernel.org>; Sun, 13 Oct 2024 18:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845683; cv=fail; b=mp9D1vIlOFIIG7VFoOt/SMVyijiITPTUxir1ikE+CJ4/TFO7rDNjiq8Eb80jjLqNWWS4BTLKhCvvj0e14eqAoR3GUbR3X+8HAYcViC0BlqCsyk9uHywxsTAS/tn9NiVX3RYDOkiGF8vEw8hY0zmFT1Ho9dz6dogqjh34eGa97m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845683; c=relaxed/simple;
	bh=5FBHTZLRHdXLNg3iu90VpoEC7Vnqthmf5Jk0xwfBtN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q+gqcxJsmNc0J2bF6vJRNM+s2QglNjAf6BIe9WsXQwUCbwU1XEVmggqyEGAK1LCEkBSRXJgWUH9efcOs9glEc5SU8TjPi326hkzGbmYaol3BLM+X2Sq07IuMUxm+7kPC1p14XXpT+nRmL6ndOUXqp73XclcI3ZlfV9v6hnRQaMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fICAdxNg; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=chv3b8Gc/LgnvcHdLXknLFldpBv2Wjp7hJ+u63hhCsvCf39AoQ62vWwjqZj1zguBo6Z+zVpUGoM60IIm4qubPUmLW8PJnCAfGDcid8h8UR38zi1vVoOKofz1NxPRG4JmwwYeV4GMj2RGHKU8ZD2haXUQ5h2tK/lvQ7PXzEmw4S7vNpvr9QoXqyCgRVJB2IbPyIKiiuAxTg2wMKgoKnidwbzLYutGZT5fHo3z86Y+44tclO6snojTVA4xdklRCFLTxzedKGp+HfAOUPZaUeItDxfweZeOF6u/NED+O/zvLCQD9nRiEmcFDTK/6rtLeAkp25iP5eYSBCLlWgVMwA8P2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FBHTZLRHdXLNg3iu90VpoEC7Vnqthmf5Jk0xwfBtN4=;
 b=eJFH7+NIP6H6d+7+U9HKNrK9Xv35VvXgL1H7ZnGBEvxXxnOSJP5OrIBao5qucAmMvHV06uhYc962C8Q7E6Q9WTbfrocOgZzdE+n+6GX5e6UWIpYeUaVswrDi+GNylEeCk9VRkU9SI9JBcJu5ERCQTd0Kj/6QUZwOz/BksHUsq2ZF65TrKgPmNsZAM0h0/EVG7RI+mLJ9px6PqL6Ud85crG79nihl0AzKKiF3YPLbRy4kw0A3zrF7M7LKQwBGRFhugU44CILqBcA7rSPEt2AG6YY6o311ZBEn8dkErp17wbYf6RsXK5RWPpl3VvHPDcuruU0yYb+wJLqphPzgpLtDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FBHTZLRHdXLNg3iu90VpoEC7Vnqthmf5Jk0xwfBtN4=;
 b=fICAdxNgFXi9Hi2+xQ22aWBcJWsx4KV44mOxNZ3GVmSqQwkjMtQ504YjpKGxLsZevjSmJULgFo4OJDBWJrFXtj6neqYf9/goe2aVLHb0YG9kWbDNlH1FKHYooocxA3Dul5xnHcb2rvV/kHqi1xLVZ+sT/9yqjQgscI1GGUNky/Q4Zy19VO6RRC1laRi2eacIR/5p+LvZwN0qw96CnAx6ys4M5Ehth2gQbNd8gNUmvi5C7jk2WI/8Vhh3M0LQrxLtvO3wPdW0KOhVyr4Nj70L2SyqY4x6oVWQZclgFmKCecBpwqSqukfhAEWRwqen4MlA7ZGORI/Wi0c6etX9X78EPA==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by IA1PR12MB7733.namprd12.prod.outlook.com (2603:10b6:208:423::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Sun, 13 Oct
 2024 18:54:38 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Sun, 13 Oct 2024
 18:54:32 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "airlied@gmail.com"
	<airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>, Andy Currid
	<ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>, Surath Mitra
	<smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Thread-Topic: [RFC 04/29] nvkm/vgpu: set the VF partition count when NVIDIA
 vGPU is enabled
Thread-Index: AQHbDO4HAXykAyawME28ijfgNcpxfbJqs0AAgBp1kQA=
Date: Sun, 13 Oct 2024 18:54:32 +0000
Message-ID: <e76bf5fe-4ac7-44e3-a032-35f04249355f@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-5-zhiw@nvidia.com> <20240926225100.GT9417@nvidia.com>
In-Reply-To: <20240926225100.GT9417@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|IA1PR12MB7733:EE_
x-ms-office365-filtering-correlation-id: fa4f5c9a-8cb9-48de-33d3-08dcebb8797d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VldYbExkSUs1dVpkMEJwRlNTSlc3U09jYmlKV2s0MTJtTnpvaUp0YVkrM0h1?=
 =?utf-8?B?dzY1R08yZjhVbE5tVTlWaXFwOXFSVlg0TmJYYm41RlZxbmtEdDlQTTBtUnBH?=
 =?utf-8?B?VTUrUjcrZmE3NHUwNFBkSnQyR25mMUZyZEFjbEZaVk16enIwK3dyaytNNGVU?=
 =?utf-8?B?UDM3amxYYzFHOFFMb3l6dXd0bUdWQWxhc3dhTlNlRTQ4RU5vV3BiSVYzUjNs?=
 =?utf-8?B?RG5ySkFoOEZjSUVtV205VUhHZlhwSUxKWTNiWmI0ZC9TZUtpc21uK1JaanM4?=
 =?utf-8?B?OG9qaWR1WUc5T1NmaytPZmtERDNpOWt2S2t6MUorM24rNEtHTDZsdUlLdTVJ?=
 =?utf-8?B?NGVQWXBWRWM3NnlyRVVpektoRCtmVnN6RFFIYndURXVTbEZNNlJLOW9OblBK?=
 =?utf-8?B?VnlSSjRJd2JYenFybk1vYnpyeEpNS2xxZ2pCK0NacElkSzJjcEJabnJXMnJh?=
 =?utf-8?B?b2ZoNktnZVJaQ3YxaE4xcnBmNnNhTXBUdHhQMVluNGJxeHVZZVZrbi93UCtH?=
 =?utf-8?B?ZWlER3Nib3FIUmJKZmo2VEgwNjRQQWgwYXFxSWljYVhKS2s0R3A4TzhmSmVM?=
 =?utf-8?B?d0lENjdUdmlUeG05c2d2V3c5QzZhRjE5Z2NNZEk3emxEZi8wcHdaLzZBWEkx?=
 =?utf-8?B?RnZvZExZdlR1QmtYclkzcUdhOEVZSXdmai9uUlg5N0NjZmQ3dXpBMnpWYjNs?=
 =?utf-8?B?ZjlvdlFzODhzbXNHNDF0NGNlY2FkL25DbGd2dTFUNHdoNUtoeFpUMjVnZ3Q5?=
 =?utf-8?B?VmlDa3lZbnZHdHNHWWJGcHpZclY4Zm1PRkx2dER5UXhxYWVhK2JxWFI3TWZ2?=
 =?utf-8?B?NnhHSmdaVEY0cXRDbnJGcHg0bGFkYk81M0lxZEF4bzd5ZDBSc2tJZUlMMGVB?=
 =?utf-8?B?bkY1aWMxUlpGS3R4Y1M3a0RrQkpvcnVWTHdqd2FFZlFpZFNzVUhxNWJreThW?=
 =?utf-8?B?d2dlWXREN1BpdFJWbjJiTDd2M0RUdHk2SkVOZ2F5bE9KSnRwQ253aGE1VURX?=
 =?utf-8?B?Q2FKWHJKbXhjYldWRmhLUDFuZTRrZHQ5VkluV1prVHl5MkRQbm1hZnlmbzhJ?=
 =?utf-8?B?R3pqSUZuek1CTmRVMmI1NHNFR2NSMzJyaElGaUp6MXZMcnJXYktwOXhQb29l?=
 =?utf-8?B?Rnd1blFvanN3OW5YK3ZqbTdxUzNDQXl0cE9yY09idUNHOS9ybi95VVJJRHo5?=
 =?utf-8?B?MHdaVzVIWmFjenM1Z0VqcW1QWlpzc0k0QnR4cGlzbUR5OFRDR040WlFOQkpw?=
 =?utf-8?B?clFNdmlWTkhjd2xxODJxUGhOSnN6dlhIWWg3dkYzYzF1TCt2ejJ5Q3NrVGZj?=
 =?utf-8?B?LzJVKzJpbW9wS3RPcmdBdENZdElOa2lGalI3R0VUY29abkNUOWZjS3VrVlBs?=
 =?utf-8?B?TGFxZ1BhL0tJZXBiUzNTZElrNUxnNmdyZCt4V20rOW1qc0lpcEZwbktCcVR3?=
 =?utf-8?B?ZUNLMGRmM3FkY0NVVysxQWhlUVFlRkdtYmY3aHhQU1ZjSWVBV05PNWpUT0Z3?=
 =?utf-8?B?SUxVZS9CQVQzMm1LcFV6aWhhN3JGQ2lud3FiV0ora2J4NXBXRDZNWEhpSGtM?=
 =?utf-8?B?VE5pWWxzaklZdlRibS9nbFlaOHh3NDFtbk5hVTJoaGpaa205czBmTFI2dzNu?=
 =?utf-8?B?amJkdTNDbHZrUVIyTUxJclJ0Q0V4UkMvd05QU0NhQVhZUXl6TTBESHJGVmlZ?=
 =?utf-8?B?aHlwWUhyeXYxdER1SWJRWEFreTlxdmlJczF2a3pQS0RWUnVPNHdzSHg5UlJl?=
 =?utf-8?Q?Rz3xIY35tfWwOTPI3GBuchtktaWdh5r0+TjdcaN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bnJaVFNET2lqY25NdWV6ZjM1SHorT1Qyam9VWFJHR2h3VFFIVFkxd3A5Qmpu?=
 =?utf-8?B?U3VUOWRvRVYrMWdZdTlkL3VabG02UGZNSTZWN2oyUW96VklZUDhGZUhNUjJN?=
 =?utf-8?B?cHVtQlA1dkxCb24rUllIdUhKT1IrWmhRYzgvUFFRQVFWL3I1cnljSm9scHo3?=
 =?utf-8?B?aFpiRmZkWEEyUm5ISEZLTU5sdkRCQVVieURZbE9xbHRCUTJpNFFXT0RMVFc2?=
 =?utf-8?B?Q1NWQ2ozL0h4OGNMbVl5U2gzZTlJM0w3cFkwbUFPUk9hMFFSYXQxcTY0OER3?=
 =?utf-8?B?M3kwTC9RU0ZoSFVJcE8yRXlMOWZwNldWUG5GT1BYb0xwMDVnSkhXRUI1bkhH?=
 =?utf-8?B?TGpaM1NlVFlrbHc3RDhTbVVoem9vZUFpemd2MHF0OUd2M20zY3NtdTloMk1w?=
 =?utf-8?B?djVmNkp5VE8rejU4ajhsMkRVZ2pwdkVQdDc4RGlod3UvK3VmUjEyMTlsdFJZ?=
 =?utf-8?B?NEUwQkJmTDhTVnoyMTJwM2dxYUVlNUk1cEtjMys5clowbUlvbVVET2djZHFG?=
 =?utf-8?B?YnN2T1RxR014cTRhMjc5WXQ4ZGdFNWJBOEx0VENibkRnSGd0N21IOTk5TGlj?=
 =?utf-8?B?NEp6UHhkZTFqZ080cUJXeC9OOUdyb0RQWUdLM3owUjRPdmgydlFDQkF3MGNy?=
 =?utf-8?B?Rm95WGlMZENxT2NIWkdoTjI1a25pdTFDUlBZVDBUSVRXcmJ6ZDJSd1hCaFVh?=
 =?utf-8?B?anVMZkQxOEZGcS9FaFAvMk95RWtYYVNVdUJ3WDlMd0E3dGNMNStGRy9CSUx2?=
 =?utf-8?B?TFdON1FKbVRHc2ZKRE1WRTJGdWdZM1ppeFNSdGxTZHk5ZFI0L1pXWmVOS3l0?=
 =?utf-8?B?aWhvTnBXN3BlWk1KbS8wSTVRcGo4RHZRT0VVNHd2bHFBdS9FNHFablFNUTZR?=
 =?utf-8?B?bm03VTJxNmpKcm9qejFJRVA2VE1mcUJ3RUw5Q3I0OXA0VnN3YjVKamZBS3BH?=
 =?utf-8?B?Vm5TdURHL1VLRmtTSWNmVW5lVkFlL29hYzRVVjUzVGFMVHFTVzgxWHd5dGRv?=
 =?utf-8?B?RmlWaVlMcEFGUkZsMHlrbGRjRFF5akQ1VDZuTStrU21DTk5uaCtSK1k2UURt?=
 =?utf-8?B?S1N6bi85d3FSOXp0WitzZXBIT0lFYm1uZWR3TGNyNUE3bmpVQjI2YkZrMUgr?=
 =?utf-8?B?MkJRZkQxMFo1amNCZkJQUVBIaWZLMDJjME5KSkVYc3hmN3F3VFBPUld3bWlq?=
 =?utf-8?B?cXBVSFJRQlJkRE0vRzdRbmxHZmNwZTgxUm5yQk10MHV1Y29FaWdwK2RTVllp?=
 =?utf-8?B?VkxyaWFFZ3VDSWZLNzd2ZWZaWTNKd1Y4Wm9abGw1Nk16UDFZaG91YTZrT2ts?=
 =?utf-8?B?ZkgySUxMdHhoN0Z6REhvVlcyVnBMY3BqOXhLck9CNEtySmJPU01YazZUTGM0?=
 =?utf-8?B?RWJVNWpxYWNGeHBOeGloTER6azJYM09EZ1U2QWNvdGtMOERDOW9xbWJmeWU0?=
 =?utf-8?B?NTA0bDErS1ZHdit5QXB4ZkxlSXJ0U3ZEUzk2S3crOXB6YW9Fd3JpNG5ZaFRX?=
 =?utf-8?B?T3RudGw1bXczQkRGNngwYUhNUGZjaDRvSkZOa2Q4NDZXaTJyQnpVclZhWEFl?=
 =?utf-8?B?Ym5ybXhzUTlCWHFlcnQvUXdQRmtxcDU5L25rZDhhMU43MlpKZDh1QzFOekRm?=
 =?utf-8?B?N3hqV1JtU1JHaXJzK1pWd2JSMnhyQmRnOUcxOU1xY3NvOHAvZE5WcVkxdEdK?=
 =?utf-8?B?WGYwc1YvY09nWVRxdzNaeUtxMUJzYjdMYjRFS2dHVEdxMS9pUWY2UHBONzFT?=
 =?utf-8?B?Q25oSGdxMjJRRTE0ZUg0citjbmVHQm9KYVlvVzdLUjRyYUFrSVdqNUxKdEx6?=
 =?utf-8?B?S05RemtlYllHaERtQkUxMHg4Tis0QnhzZFFCNStIQzk1c3djOTBrc0wxanFC?=
 =?utf-8?B?Y1FiL2pCZ0FsQWo2NDF5aUV6L0RIeHBtNUZIdEd5V0NCQTI1NHhLY256R3dJ?=
 =?utf-8?B?VlphcEw3L2tBSE5VblFKUUdtOVdzejRIMjVCZGxoZktyaDYzWEVhRVNDSitQ?=
 =?utf-8?B?TGh2NHRBN1NxblIxTUJ4UktrY0Z0Tks4QzZheTk1Mmx6REU4R002UGpVNzN5?=
 =?utf-8?B?Uk1CbGxlYW94Njh1REUxM0R0bG1uMnl3TVF1ZFY3cGNtZFliWVVHMzIzZ01S?=
 =?utf-8?Q?2FK0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D2CBFCD8F67EB43BE5FE58B61CCD869@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4f5c9a-8cb9-48de-33d3-08dcebb8797d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2024 18:54:32.3935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MESG/9f8R1fc0uL1YCdcjDQnX2Um9Zu2tq4KhwxfD/4eZaEPpvKUjteT5BxKnXdh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7733

T24gMjcvMDkvMjAyNCAxLjUxLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+IE9uIFN1biwgU2Vw
IDIyLCAyMDI0IGF0IDA1OjQ5OjI2QU0gLTA3MDAsIFpoaSBXYW5nIHdyb3RlOg0KPj4gR1NQIGZp
cm13YXJlIG5lZWRzIHRvIGtub3cgdGhlIG51bWJlciBvZiBtYXgtc3VwcG9ydGVkIHZHUFVzIHdo
ZW4NCj4+IGluaXRpYWxpemF0aW9uLg0KPj4NCj4+IFRoZSBmaWVsZCBvZiBWRiBwYXJ0aXRpb24g
Y291bnQgaW4gdGhlIEdTUCBXUFIyIGlzIHJlcXVpcmVkIHRvIGJlIHNldA0KPj4gYWNjb3JkaW5n
IHRvIHRoZSBudW1iZXIgb2YgbWF4LXN1cHBvcnRlZCB2R1BVcy4NCj4+DQo+PiBTZXQgdGhlIFZG
IHBhcnRpdGlvbiBjb3VudCBpbiB0aGUgR1NQIFdQUjIgd2hlbiBOVktNIGlzIGxvYWRpbmcgdGhl
IEdTUA0KPj4gZmlybXdhcmUgYW5kIGluaXRpYWxpemVzIHRoZSBHU1AgV1BSMiwgaWYgdkdQVSBp
cyBlbmFibGVkLg0KPiANCj4gSG93L3doeSBpcyB0aGlzIGRpZmZlcmVudCBmcm9tIHRoZSBTUklP
ViBudW1fdmZzIGNvbmNlcHQ/DQo+IA0KDQoxKSBUaGUgVkYgaXMgY29uc2lkZXJlZCBhcyBhbiBI
VyBpbnRlcmZhY2Ugb2YgdkdQVSBleHBvc2VkIHRvIHRoZSBWTU0vVk0uDQoNCjIpIE51bWJlciBv
ZiBWRiBpcyBub3QgYWx3YXlzIGVxdWFsIHRvIG51bWJlciBvZiBtYXggdkdQVSBzdXBwb3J0ZWQs
IA0Kd2hpY2ggZGVwZW5kcyBvbiBhKSB0aGUgc2l6ZSBvZiBtZXRhZGF0YSBvZiB2aWRlbyBtZW1v
cnkgc3BhY2UgYWxsb2NhdGVkIA0KZm9yIEZXIHRvIG1hbmFnZSB0aGUgdkdQVXMuIGIpIGhvdyB1
c2VyIGRpdmlkZSB0aGUgcmVzb3VyY2VzLiBFLmcuIGlmIGEgDQpjYXJkIGhhcyA0OEdCIHZpZGVv
IG1lbW9yeSwgYW5kIHVzZXIgY3JlYXRlcyB0d28gdkdQVXMgZWFjaCBoYXMgMjRHQiANCnZpZGVv
IG1lbW9yeS4gT25seSB0d28gVkZzIGFyZSB1c2FibGUgZXZlbiBTUklPViBudW1fdmZzIGNhbiBi
ZSBsYXJnZSANCnRoYW4gdGhhdC4NCg0KPiBUaGUgd2F5IHRoZSBTUklPViBmbG93IHNob3VsZCB3
b3JrIGlzIHlvdSBib290IHRoZSBQRiwgc3RhcnR1cCB0aGUNCj4gZGV2aWNlLCB0aGVuIHVzZXJz
cGFjZSBzZXRzIG51bV92ZnMgYW5kIHlvdSBnZXQgdGhlIFNSSU9WIFZGcy4NCj4gDQo+IFdoeSB3
b3VsZCB5b3Ugd2FudCBsZXNzL21vcmUgcGFydGl0aW9ucyB0aGFuIFZGcz8NCg0KSXMgdGhlcmUg
c29tZSB3YXkgdG8NCj4gY29uc3VtZSBtb3JlIHRoYW4gb25lIHBhcnRpdGlvbiBwZXIgVkY/DQoN
Ck5vLg0KDQo+IA0KPiBBdCBsZWFzdCBiYXNlZCBvbiB0aGUgY29tbWl0IG1lc3NhZ2UgdGhpcyBz
ZWVtcyBsaWtlIGEgdmVyeSBwb29yIEZXDQo+IGludGVyZmFjZS4NCj4gPiBKYXNvbg0KDQo=

