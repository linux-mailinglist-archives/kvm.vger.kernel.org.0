Return-Path: <kvm+bounces-28721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B190E99C696
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B03021C22E59
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 09:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE0D158D6A;
	Mon, 14 Oct 2024 09:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VLblCIhd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D64145B2D
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 09:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728899964; cv=fail; b=guydjjkZdmuqpyuXZoZHvUIipu3+7fgeFVCdGeCVmTQFZ1m3ncoWUtybV4/B4zTTXEwuVXkOh5EDyvDdocq6Kq28Blq0NWpo7Zge0BzIKJARVuRifwPL1SCQwmeyZlNCmdGXKCyhMyNpaLEYFvxGpMgTKfWkvbKVwH+07cxvHww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728899964; c=relaxed/simple;
	bh=Y8mjFmzh8ZbZWAIAAlrn5WnRKqMsrHL9k053BxphIGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lyblYaknVg1dd8THp6ijc6nce8qhBW8t169b18QTMMvWCYNh0QB1kwReeaHR3JeJ0q/8Skr4cAwFnJUqyGDIrgNHOdId3j9WZzX6vb3zDnOjYbrw+IjmK1jqkLFdNBIO0Iec0x5gl+P3bskGVNRllp9+xkpuU0R1Ttrrt0MHi6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VLblCIhd; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/OTSJmWPB855n7mFLGjjHqlQ8EGZnZ4GNUCj386kArHF2Nz5jnmdhRRgNf+7DJrluLweNJBHD3GrdZXMJvWxYklE6kH7jO4PGri3lUYcjGcQjvuKOH0q60b16t3or37fbLEpGIB56Add+UDl1dUhr8Mcmln/GciocSe4yCK8AcFcRyIjycXoZ8f0awF7XIE3Iew/K0Jj4qPVfvjW7vdHVxkQ/wvxTV8bzHHigYHFxYl+LeKgy0MGLCDCPZCLPtYCE+tM2M2jW/K7p/qHzX3pknRm9xTnr9iFjsk2gcxDYwPHUKcovG/4AruPCfcsLMaQuhymab0gODB9TTvKyjS8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8mjFmzh8ZbZWAIAAlrn5WnRKqMsrHL9k053BxphIGY=;
 b=xyZZf37Lzpj7YafFYCOhpIogH7BmKtvHcDssuFrbC66/iyiBRvyKD1I3jxYX4qWtDzgWVXLUvZM7j4TNn8sjrvPsh0t/m+3n0QGvGXHT2v6zvjJKR2vLDqO0m3ELqHbfGR9gwI2JO6fnhB1FkUejMyQd0sGvZeLSWgWgwlPImiv7C+Naw2HzDE40AMgJz7AH6vWKLM3nH7QPx1fXJqdPcQezGD3q1qKE68nKeZVmzXLOyDXnrOy1gGYF8Mrj85VF7Zq8udtFBay2zGnxusijJ2oeHiOGcY7RntN51qGW7SYnfWkhzYaFtjyVUZ4vD187KS5MOwc0RVcWWT+wgQkYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8mjFmzh8ZbZWAIAAlrn5WnRKqMsrHL9k053BxphIGY=;
 b=VLblCIhdJXYOt1AJdS/mkg9iAjNzgr7AkLHlzZuphzXpNLTlbzw0x5A2lojmcazo3ROQ9WwouW0gz0blR5hfl0/BDzdl8ygq/unSjgxdcZdxr9Y5bkwrRzu86R/UrL2YUZZrH7hBpW3HHD5y/nvBXlenYjFgHTMsQuhjdSfH9qlVPNNJeEqvo9SjFo9kMZXuaOE6piYdZPEtfDqx9XLKmta/tJ7z47L2xhh6FXl0FVXPZEL7/lLVMeZoiYv4jqIHAd/Iq1P56PYmoCzRyKiW29ukZ5rPCFjMRy+rTWKg5xY68EoNnTVN1kmZhynbCD2asOHJD0gFk41QX5tX8XITOQ==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by PH7PR12MB8040.namprd12.prod.outlook.com (2603:10b6:510:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 09:59:19 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 09:59:19 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Greg KH <greg@kroah.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "airlied@gmail.com" <airlied@gmail.com>, "daniel@ffwll.ch"
	<daniel@ffwll.ch>, Andy Currid <ACurrid@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 01/29] nvkm/vgpu: introduce NVIDIA vGPU support prelude
Thread-Topic: [RFC 01/29] nvkm/vgpu: introduce NVIDIA vGPU support prelude
Thread-Index: AQHbDO4DhFhVRvo/GEeNJLT9hImY8bJp0M0AgBxUz4A=
Date: Mon, 14 Oct 2024 09:59:18 +0000
Message-ID: <bab2ee27-059e-4f9b-a5f8-87cee04630d1@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-2-zhiw@nvidia.com>
 <2024092604-factor-pushpin-99ee@gregkh>
In-Reply-To: <2024092604-factor-pushpin-99ee@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|PH7PR12MB8040:EE_
x-ms-office365-filtering-correlation-id: 67c0eaed-db4e-4123-6c9f-08dcec36dec6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QmlmVTdobE93L2luUkpDUDBNeUVBelRsQVBTOU9FMmRsM1RrQ2hKemdaeTlh?=
 =?utf-8?B?ME9pdW5CZU5xdGdBUlljN1BCSERSVlM0RFBsMHFmSHFydlZwa3lzejhwNG1n?=
 =?utf-8?B?aCt2VGtaTmFQUW5uK21Db0JIWjVmNXBiZy9qVUVaTlhkT1RISFhLL1pySjdR?=
 =?utf-8?B?akE0c3RUUXNRektPV3YxejIraXVMTUkrTEVqTlNFNE1tYnJHWnZXTVRSdGll?=
 =?utf-8?B?NURHeTJTUExWM1BMakI2YTVFK1dQSjRLQ0taSkw1bUE3SkJ5OUdmUlg2VXRI?=
 =?utf-8?B?eWQrQUVUekJuV3YrOGtRQTJjaTltSHZ5a09neXBLc3V6TVVwOG9TeXVOa2J6?=
 =?utf-8?B?QmRsMFdISlV5QXFKUXNUak13MzFhZlUxT0pPM1ZaUEljTHNwa0NZTlNNVlpp?=
 =?utf-8?B?ek4zd1JTUHZZb3pGbzRxWUEwNjV2MEl5WWdQeko2ajE0TER4ZHplUlkvSFZ4?=
 =?utf-8?B?Qnc5S0QrMUwyQ1pzQ0JKSDU4Q1JLdmYyNlBxSWZmS2w3TnRINFdpeWpYVktl?=
 =?utf-8?B?dndzQzRBTGYyNXhPRmk5TEhLSWVOVnFjL1RIK1oyYjZXYlBHVkRFOGg5ay81?=
 =?utf-8?B?dnpQL1lKOERuZFEzWVhPdmJYbWhCSHYvQytWQTJsaVZNeEJoSmFncTFvLzk3?=
 =?utf-8?B?Q2RublIvYmdQWWt4YXpVOURUTnRyT2VPVGJSenVJWjVJMHp2a2t3VE5kY0JS?=
 =?utf-8?B?dms4MnBnK2ZjK21BU1BtU0xDK2U1Y2pKc1UzRXh6YlduTWw4RFpWWTF3U0R2?=
 =?utf-8?B?YnpuTU9IaURDdE8xeGlnNzB3clh6d3BRVEtHY3k0Z3VjVnMxRHRWT1dtUzdL?=
 =?utf-8?B?NWMrRm01YzN2YTZZSHVPWnZQZ3RjbzJQY0dETkJzeUFMNGdwdEp2NHlEL1I0?=
 =?utf-8?B?TU9xd2E5b1RJSXFqZ1ZiNDdPRmNSUW9QZzVYU2RoUnliQWZsbWRNTlVFMzRV?=
 =?utf-8?B?SFEyT0treFJ2RHBrOU4zUWc3S053aSs5RndvZElpTzJyQkk1Z3ZHbFpaRmRt?=
 =?utf-8?B?WVFPSWliTVJpb0xVOWxBMnl0cEJUTnB2dy9USG1GeTdoVnU3Q3REV0g5dGsx?=
 =?utf-8?B?WlFBN0oxL2YwK2Y5Y3NFOHBOR2swNXZ0MHBOZDFYTDBEZDZ6YThCZ1lLSDFh?=
 =?utf-8?B?eml4VDl3YTFQenF6TGhJSnhqQ1pjbncvSHdyejJYY0JBMFloQW1CbEpPTnBr?=
 =?utf-8?B?NFBBVjRjZkc3UmxqaDBmRkQ1SUhUbHEwOTdCVUZ2TDZjQlQwSEJYRWNmVW9C?=
 =?utf-8?B?UDdIOVZUM3huY3FKYlk2ZzBJS2VReW9mbjZVdWRrdmd1V3FZcjcxSTFESzhv?=
 =?utf-8?B?bHU5Nk5yWlBPK3Z0Rnlwc2xucE5XYkF1aFZRbHowUWkxalJGRnN6MUNhSGlK?=
 =?utf-8?B?NEpmVVQ1dlpuaEVFc014b3h1TE9paE1KWU9qbmkwY3kyUFF0YmNrQ0RBaFFl?=
 =?utf-8?B?akxKell2Z1FqN2V6NmZhT1pqNTZEaWdpUWRMNFpVV3dGMFd3V2hMQms2b3Q1?=
 =?utf-8?B?VDl4dEZrK2tVSW1ENTErT0ZnQ0dKVCs1azRKMnBFa1Y3RFdzdGlXMGR0ZHdz?=
 =?utf-8?B?bGt2QVdUZnVsNTJqU0lObHdDWmtnUlRxTVBubHdFcWVRcG5icm5SRzMvRk9q?=
 =?utf-8?B?YjlxWFpFd2JHMEgvSEttaWNHbmZ0cjU5aUdsa3I0bk5xcDhmTXF4cE9mbG05?=
 =?utf-8?B?UFZZVSsrR0dINkJQK2xjQmtyYVh6VGtHMGNTMlZBbFBOaVIrc2lkZG0zUUdm?=
 =?utf-8?B?dXJEbGM2UTVUUkgvdXBOdzZ2MzcvbloyK0RCSS9CeUpodHhSaWRtZ04yTU9E?=
 =?utf-8?B?L1JZL3ZGc3RNQVJBOWVtdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QTdsUmFZYzJGUHN2Qnc3eno1UVg2VEVtd3BvZzNTZDNONm9tdmpHVnVOU0dr?=
 =?utf-8?B?NlpDOUhDMGdWOWdhMjFPcWUvVXpsNCt1U2tFYkdubTZxUE91anRWUHN1VTBL?=
 =?utf-8?B?VlFINWFtdzUzRktlM3hmaVVwa3lrMHFkd0VNMk9iNTVsR3hOaGxrM29SalRq?=
 =?utf-8?B?TkZZeWt4Z3dyTzFmdVd1R0RZNEpadmE2STJxUmpOUFFRUFZRSTV2L2sxTTFD?=
 =?utf-8?B?V1d6RHB1alNKcjlNOVBSeHhraDNNckQxbFVjUFhTWlhwMGJWblpEa0NOUGRL?=
 =?utf-8?B?UWQvTzJlN3MwSG9RUFh2Y0l4bVdTV253dVRPNjVlME12dUMrYnd2aklacEEv?=
 =?utf-8?B?dmtTbGFhUnJ1cFErVjJtUEc5QmQ3ZUdBaTAvLzFYY0REaXNxNHpJOFE0L2Jy?=
 =?utf-8?B?Y0sweHNneHRjYkRhYldBM2pXZVpUWTVuNHVnR1NvQXhuQmovclVlbVRHSFdM?=
 =?utf-8?B?Znk3ZkpmcDM2WkNhNEZiOHdySWh1amJuT2dLblhZSmFtTWV5UDdDMitlNXZr?=
 =?utf-8?B?T1JvVFZFVzM3ODEzVGFlWDdMMHI3bm9zZEpyNzdvbllQUDkzM05GL3pLbm4w?=
 =?utf-8?B?N1ptR0l6Y1I2UEt2c0hxWG5NdFBpb2RaSW5ISVk5emlrVkkwQ2NLbUVDM3Ny?=
 =?utf-8?B?c0FwWkw5N3JaTnJHd0l4MGk0OElRM3VZVWdDcG1HVmZ3QVNlUTRNbkpkdG9z?=
 =?utf-8?B?a3F1Q2tnMHZkM21WUkRqcnVKbFdOK2ZVK3BhVkdid20vekNtcEJBYUZFTFVD?=
 =?utf-8?B?OGFYZkp0blhaSzFhZE1uODJISWVMTURkVnR1ZzA2TDZGWjRCK2M1S1N3TXZv?=
 =?utf-8?B?NVpIcXRmZXNKYWFNcUhOSWdyWVpDTEpFSVpWTkxIcVIzUUZ6ZW9XZW1OenFK?=
 =?utf-8?B?WXc2ODlKSCtPZXAzb21UWWhvOEZ3bTJVWkRwSnNnbTlYK2JIQi9EczVhVkJJ?=
 =?utf-8?B?Mi9yNnIrcndZV29DUjdCa1pRNFNXblRLQ0Q2Rlcxa1B6K200dkkxZmF2WFAy?=
 =?utf-8?B?d2tOanFac0poc1lDN2dUQ09lMnhqL01mclk1dFpUblpPVkR4c2VET0xueFR6?=
 =?utf-8?B?dzVONlVMcjZRM0lzZ2k3WUF4ZUg3WWkzKzFQQWhobXkvZ3VYQ3YxeExtL3pS?=
 =?utf-8?B?UklWZEQ5WFhobTNSSXdRZlFFTm1zaUt6aXBPRUxYbUtDNk5QN25lNVFxY0I5?=
 =?utf-8?B?UHNDNmdMM3FCaDUxcFQ0bnJ1VzF4NWRvZ2wwczdLVzRNdDJWRE43RUxuME0y?=
 =?utf-8?B?T2ZkV3FTNlNKeWc3aGkzMzE4SzFYTUltSS9uSDlvK3JLdCtSUDV4b0sweVFw?=
 =?utf-8?B?OEFmRzNGUlJac1pQanNpYnMwdVVtT2xYOVNYWEpoRFBqeVdhODY3SFc4aGY4?=
 =?utf-8?B?NmZJVlo3N281cXpPUUdtaVJON0Jlc29FNDJYNTBuSGo2aWkwbG9TZlBaQXB2?=
 =?utf-8?B?ZjBoZERQeGdQd2xrK3RJb3NZRXpIU1J1V29mWFlvN2RDMXdxUHFlbTN4Z2dK?=
 =?utf-8?B?WVdScHMxcW1ncjdRRDZtdGIzWEpBZlE5SWpGd25ubm1zZGU2UGJYcTV1TVJG?=
 =?utf-8?B?d3dGeXdlM1d3d0NpK3RyeXJxZkNhRytGN1ZrTFRTQSt6ckRPc1VYRHh0bWVC?=
 =?utf-8?B?Y1BZMzF3eGFrYW0rbzZJcnk3YXVSY3JPRjBNUDRuN2lhdElJVnV4eEhXWjMx?=
 =?utf-8?B?SkowYmJFZ0dIK0RSL1Z4bTFRNm82ZkoyVWVycVc5NDNlY0NXaU5xM0ozWkpX?=
 =?utf-8?B?VXZUaUhzRjB2aUg0SmVwUGE5SStLZm1pZWxVV21iNWZUSnJqMzlTYlpEa0Nu?=
 =?utf-8?B?Tzc1VW9jdVNwWnZKOGlnZU84MHNSWEErQktISDhlSnNpOFFPUnVmaGxxbmxq?=
 =?utf-8?B?ZjdvRFZvaHppOXFjaE5BTlE2aWhrZTFoV1ZCMlBtdkxJNGkvUjRGUlQ5NUxp?=
 =?utf-8?B?OFA0Z09QcTIxNGoxMjB1ckJ0QmxFYXJjc3hYaFVVeUVCZHJwY2NxSnl5TDVr?=
 =?utf-8?B?MjlGTWJLODNzai9oaWFhWWZsMEdiYVVlSStrZjluSnlXeWprRlkzQUQxQW1L?=
 =?utf-8?B?SmpkaWE2THUzTjlhRnNBWnZGT1N2MzBkbjVVeWI4WG9CSDdheXdQSXV2UDFj?=
 =?utf-8?Q?7mDU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A0303B3374BE44BA33E314BE684EEBC@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c0eaed-db4e-4123-6c9f-08dcec36dec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 09:59:18.9257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1WwV5Pv8S6d5MqBmS3w0YiOLd5QWsi+mdq0u7scZWyeChOpX8toHXaq49c+QhvvQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8040

T24gMjYvMDkvMjAyNCAxMi4yMCwgR3JlZyBLSCB3cm90ZToNCj4gRXh0ZXJuYWwgZW1haWw6IFVz
ZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiBTdW4s
IFNlcCAyMiwgMjAyNCBhdCAwNTo0OToyM0FNIC0wNzAwLCBaaGkgV2FuZyB3cm90ZToNCj4+IE5W
SURJQSBHUFUgdmlydHVhbGl6YXRpb24gaXMgYSB0ZWNobm9sb2d5IHRoYXQgYWxsb3dzIG11bHRp
cGxlIHZpcnR1YWwNCj4+IG1hY2hpbmVzIChWTXMpIHRvIHNoYXJlIHRoZSBwb3dlciBvZiBhIHNp
bmdsZSBHUFUsIGVuYWJsaW5nIGdyZWF0ZXINCj4+IGZsZXhpYmlsaXR5LCBlZmZpY2llbmN5LCBh
bmQgY29zdC1lZmZlY3RpdmVuZXNzIGluIGRhdGEgY2VudGVycyBhbmQgY2xvdWQNCj4+IGVudmly
b25tZW50cy4NCj4+DQo+PiBUaGUgZmlyc3Qgc3RlcCBvZiBzdXBwb3J0aW5nIE5WSURJQSB2R1BV
IGluIG52a20gaXMgdG8gaW50cm9kdWNlIHRoZQ0KPj4gbmVjZXNzYXJ5IHZHUFUgZGF0YSBzdHJ1
Y3R1cmVzIGFuZCBmdW5jdGlvbnMgdG8gaG9vayBpbnRvIHRoZQ0KPj4gKGRlKWluaXRpYWxpemF0
aW9uIHBhdGggb2YgbnZrbS4NCj4+DQo+PiBJbnRyb2R1Y2UgTlZJRElBIHZHUFUgZGF0YSBzdHJ1
Y3R1cmVzIGFuZCBmdW5jdGlvbnMgaG9va2luZyBpbnRvIHRoZQ0KPj4gdGhlIChkZSlpbml0aWFs
aXphdGlvbiBwYXRoIG9mIG52a20gYW5kIHN1cHBvcnQgdGhlIGZvbGxvd2luZyBwYXRjaGVzLg0K
Pj4NCj4+IENjOiBOZW8gSmlhIDxjamlhQG52aWRpYS5jb20+DQo+PiBDYzogU3VyYXRoIE1pdHJh
IDxzbWl0cmFAbnZpZGlhLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFpoaSBXYW5nIDx6aGl3QG52
aWRpYS5jb20+DQo+IA0KPiBTb21lIG1pbm9yIGNvbW1lbnRzIHRoYXQgYXJlIGEgaGludCB5b3Ug
YWxsIGFyZW4ndCBydW5uaW5nIGNoZWNrcGF0Y2ggb24NCj4geW91ciBjb2RlLi4uDQo+IA0KPj4g
LS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL25vdXZlYXUvaW5jbHVkZS9u
dmttL3ZncHVfbWdyL3ZncHVfbWdyLmgNCj4+IEBAIC0wLDAgKzEsMTcgQEANCj4+ICsvKiBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogTUlUICovDQo+IA0KPiBXYWl0LCB3aGF0PyAgV2h5PyAgSWNr
LiAgWW91IGFsbCBhbHNvIGZvcmdvdCB0aGUgY29weXJpZ2h0IGxpbmUgOigNCj4gDQoNCldpbGwg
Zml4IGl0IGFjY29yZGluZ2x5Lg0KDQpCYWNrIHRvIHRoZSByZWFzb24sIEkgYW0gdHJ5aW5nIHRv
IGZvbGxvdyB0aGUgbWFqb3JpdHkgaW4gdGhlIG5vdXZlYXUgDQpzaW5jZSB0aGlzIGlzIHRoZSBj
aGFuZ2Ugb2Ygbm91dmVhdS4NCg0KV2hhdCdzIHlvdXIgZ3VpZGVsaW5lcyBhYm91dCB0aG9zZSBh
bHJlYWR5IGluIHRoZSBjb2RlPw0KDQppbm5vQGlubm8tbGludXg6fi92Z3B1LWxpbnV4LXJmYy9k
cml2ZXJzL2dwdS9kcm0vbm91dmVhdSQgZ3JlcCAtQSAzIC1SIA0KIjogTUlUIiAqDQoNCg0KZGlz
cG52MDQvZGlzcC5oOi8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBNSVQgKi8NCmRpc3BudjA0
L2Rpc3AuaC0jaWZuZGVmIF9fTlYwNF9ESVNQTEFZX0hfXw0KZGlzcG52MDQvZGlzcC5oLSNkZWZp
bmUgX19OVjA0X0RJU1BMQVlfSF9fDQpkaXNwbnYwNC9kaXNwLmgtI2luY2x1ZGUgPHN1YmRldi9i
aW9zLmg+DQotLQ0KZGlzcG52MDQvY3Vyc29yLmM6Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IE1JVA0KZGlzcG52MDQvY3Vyc29yLmMtI2luY2x1ZGUgPGRybS9kcm1fbW9kZS5oPg0KZGlzcG52
MDQvY3Vyc29yLmMtI2luY2x1ZGUgIm5vdXZlYXVfZHJ2LmgiDQpkaXNwbnYwNC9jdXJzb3IuYy0j
aW5jbHVkZSAibm91dmVhdV9yZWcuaCINCi0tDQpkaXNwbnYwNC9LYnVpbGQ6IyBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogTUlUDQpkaXNwbnYwNC9LYnVpbGQtbm91dmVhdS15ICs9IGRpc3BudjA0
L2FyYi5vDQpkaXNwbnYwNC9LYnVpbGQtbm91dmVhdS15ICs9IGRpc3BudjA0L2NydGMubw0KZGlz
cG52MDQvS2J1aWxkLW5vdXZlYXUteSArPSBkaXNwbnYwNC9jdXJzb3Iubw0KLS0NCmRpc3BudjUw
L2NyYy5oOi8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBNSVQgKi8NCmRpc3BudjUwL2NyYy5o
LSNpZm5kZWYgX19OVjUwX0NSQ19IX18NCmRpc3BudjUwL2NyYy5oLSNkZWZpbmUgX19OVjUwX0NS
Q19IX18NCmRpc3BudjUwL2NyYy5oLQ0KLS0NCmRpc3BudjUwL2hhbmRsZXMuaDovKiBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogTUlUICovDQpkaXNwbnY1MC9oYW5kbGVzLmgtI2lmbmRlZiBfX05W
NTBfS01TX0hBTkRMRVNfSF9fDQpkaXNwbnY1MC9oYW5kbGVzLmgtI2RlZmluZSBfX05WNTBfS01T
X0hBTkRMRVNfSF9fDQpkaXNwbnY1MC9oYW5kbGVzLmgtDQotLQ0KZGlzcG52NTAvY3JjYzM3ZC5o
Oi8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBNSVQgKi8NCmRpc3BudjUwL2NyY2MzN2QuaC0N
CmRpc3BudjUwL2NyY2MzN2QuaC0jaWZuZGVmIF9fQ1JDQzM3RF9IX18NCmRpc3BudjUwL2NyY2Mz
N2QuaC0jZGVmaW5lIF9fQ1JDQzM3RF9IX18NCi0tDQpkaXNwbnY1MC9LYnVpbGQ6IyBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogTUlUDQpkaXNwbnY1MC9LYnVpbGQtbm91dmVhdS15ICs9IGRpc3Bu
djUwL2Rpc3Aubw0KZGlzcG52NTAvS2J1aWxkLW5vdXZlYXUteSArPSBkaXNwbnY1MC9sdXQubw0K
DQo+PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi9kcml2ZXJzL2dwdS9kcm0vbm91dmVhdS9udmtt
L3ZncHVfbWdyL3ZncHVfbWdyLmMNCj4+IEBAIC0wLDAgKzEsNzYgQEANCj4+ICsvKiBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogTUlUICovDQo+PiArI2luY2x1ZGUgPGNvcmUvZGV2aWNlLmg+DQo+
PiArI2luY2x1ZGUgPGNvcmUvcGNpLmg+DQo+PiArI2luY2x1ZGUgPHZncHVfbWdyL3ZncHVfbWdy
Lmg+DQo+PiArDQo+PiArc3RhdGljIGJvb2wgc3VwcG9ydF92Z3B1X21nciA9IGZhbHNlOw0KPiAN
Cj4gQSBnbG9iYWwgdmFyaWFibGUgZm9yIHRoZSB3aG9sZSBzeXN0ZW0/ICBBcmUgeW91IHN1cmUg
dGhhdCB3aWxsIHdvcmsNCj4gd2VsbCBvdmVyIHRpbWU/ICBXaHkgaXNuJ3QgdGhpcyBhIHBlci1k
ZXZpY2UgdGhpbmc/DQo+IA0KPj4gK21vZHVsZV9wYXJhbV9uYW1lZChzdXBwb3J0X3ZncHVfbWdy
LCBzdXBwb3J0X3ZncHVfbWdyLCBib29sLCAwNDAwKTsNCj4gDQo+IFRoaXMgaXMgbm90IHRoZSAx
OTkwJ3MsIHBsZWFzZSBuZXZlciBhZGQgbmV3IG1vZHVsZSBwYXJhbWV0ZXJzLCB1c2UNCj4gcGVy
LWRldmljZSB2YXJpYWJsZXMuICBBbmQgbm8gZG9jdW1lbnRhdGlvbj8gIFRoYXQncyBub3Qgb2sg
ZWl0aGVyIGV2ZW4NCj4gaWYgeW91IGRpZCB3YW50IHRvIGhhdmUgdGhpcy4NCj4gDQoNClRoYW5r
cyBmb3IgdGhlIGNvbW1lbnRzLiBJIGFtIG1vc3QgY29sbGVjdGluZyBwZW9wbGUgb3BpbmlvbiBv
biB0aGUgDQptZWFucyBvZiBlbmFibGluZy9kaXNhYmxpbmcgdGhlIHZHUFUsIHZpYSBrZXJuZWwg
cGFyYW1ldGVyIG9yIG5vdCBpcyANCmp1c3Qgb25lIG9mIHRoZSBvcHRpb25zLiBJZiBpdCBpcyBj
aG9zZW4sIGhhdmluZyBhIGdsb2JhbCBrZXJuZWwgDQpwYXJhbWV0ZXIgaXMgbm90IGV4cGVjdGVk
IHRvIGJlIGluIHRoZSAhUkZDIHBhdGNoLg0KDQo+PiArc3RhdGljIGlubGluZSBzdHJ1Y3QgcGNp
X2RldiAqbnZrbV90b19wZGV2KHN0cnVjdCBudmttX2RldmljZSAqZGV2aWNlKQ0KPj4gK3sNCj4+
ICsgICAgIHN0cnVjdCBudmttX2RldmljZV9wY2kgKnBjaSA9IGNvbnRhaW5lcl9vZihkZXZpY2Us
IHR5cGVvZigqcGNpKSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBkZXZpY2UpOw0KPj4gKw0KPj4gKyAgICAgcmV0dXJuIHBjaS0+cGRldjsNCj4+
ICt9DQo+PiArDQo+PiArLyoqDQo+PiArICogbnZrbV92Z3B1X21ncl9pc19zdXBwb3J0ZWQgLSBj
aGVjayBpZiBhIHBsYXRmb3JtIHN1cHBvcnQgdkdQVQ0KPj4gKyAqIEBkZXZpY2U6IHRoZSBudmtt
X2RldmljZSBwb2ludGVyDQo+PiArICoNCj4+ICsgKiBSZXR1cm5zOiB0cnVlIG9uIHN1cHBvcnRl
ZCBwbGF0Zm9ybSB3aGljaCBpcyBuZXdlciB0aGFuIEFEQSBMb3ZlbGFjZQ0KPj4gKyAqIHdpdGgg
U1JJT1Ygc3VwcG9ydC4NCj4+ICsgKi8NCj4+ICtib29sIG52a21fdmdwdV9tZ3JfaXNfc3VwcG9y
dGVkKHN0cnVjdCBudmttX2RldmljZSAqZGV2aWNlKQ0KPj4gK3sNCj4+ICsgICAgIHN0cnVjdCBw
Y2lfZGV2ICpwZGV2ID0gbnZrbV90b19wZGV2KGRldmljZSk7DQo+PiArDQo+PiArICAgICBpZiAo
IXN1cHBvcnRfdmdwdV9tZ3IpDQo+PiArICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCj4+ICsN
Cj4+ICsgICAgIHJldHVybiBkZXZpY2UtPmNhcmRfdHlwZSA9PSBBRDEwMCAmJiAgcGNpX3NyaW92
X2dldF90b3RhbHZmcyhwZGV2KTsNCj4gDQo+IGNoZWNrcGF0Y2ggcGxlYXNlLg0KPiANCg0KSSBk
aWQgYmVmb3JlIHNlbmRpbmcgaXQsIGJ1dCBpdCBkb2Vzbid0IGNvbXBsYWluIHRoaXMgbGluZS4N
Cg0KTXkgY29tbWFuZCBsaW5lDQokIHNjcmlwdHMvY2hlY2twYXRjaC5wbCBbdGhpcyBwYXRjaF0N
Cg0KPiBBbmQgIkFEMTAwIiBpcyBhbiBvZGQgI2RlZmluZSwgYXMgeW91IGtub3cuDQoNCkkgYWdy
ZWUgYW5kIHBlb3BsZSBjb21tZW50ZWQgYWJvdXQgaXQgaW4gdGhlIGludGVybmFsIHJldmlldy4g
QnV0IGl0IGlzIA0KZnJvbSB0aGUgbm91dmVhdSBkcml2ZXIgYW5kIGl0IGhhcyBiZWVuIHVzZWQg
aW4gbWFueSBvdGhlciBwbGFjZXMgaW4gDQpub3V2ZWF1IGRyaXZlci4gV2hhdCB3b3VsZCBiZSB5
b3VyIGd1aWRlbGluZXMgaW4gdGhpcyBzaXR1YXRpb24/DQoNCj4gDQo+PiArfQ0KPj4gKw0KPj4g
Ky8qKg0KPj4gKyAqIG52a21fdmdwdV9tZ3JfaXNfZW5hYmxlZCAtIGNoZWNrIGlmIHZHUFUgc3Vw
cG9ydCBpcyBlbmFibGVkIG9uIGEgUEYNCj4+ICsgKiBAZGV2aWNlOiB0aGUgbnZrbV9kZXZpY2Ug
cG9pbnRlcg0KPj4gKyAqDQo+PiArICogUmV0dXJuczogdHJ1ZSBpZiB2R1BVIGVuYWJsZWQuDQo+
PiArICovDQo+PiArYm9vbCBudmttX3ZncHVfbWdyX2lzX2VuYWJsZWQoc3RydWN0IG52a21fZGV2
aWNlICpkZXZpY2UpDQo+PiArew0KPj4gKyAgICAgcmV0dXJuIGRldmljZS0+dmdwdV9tZ3IuZW5h
YmxlZDsNCj4gDQo+IFdoYXQgaGFwcGVucyBpZiB0aGlzIGNoYW5nZXMgcmlnaHQgYWZ0ZXIgeW91
IGxvb2sgYXQgaXQ/DQo+IA0KDQpOaWNlIGNhdGNoLiBXaWxsIGZpeCBpdC4NCg0KPiANCj4+ICt9
DQo+PiArDQo+PiArLyoqDQo+PiArICogbnZrbV92Z3B1X21ncl9pbml0IC0gSW5pdGlhbGl6ZSB0
aGUgdkdQVSBtYW5hZ2VyIHN1cHBvcnQNCj4+ICsgKiBAZGV2aWNlOiB0aGUgbnZrbV9kZXZpY2Ug
cG9pbnRlcg0KPj4gKyAqDQo+PiArICogUmV0dXJuczogMCBvbiBzdWNjZXNzLCAtRU5PREVWIG9u
IHBsYXRmb3JtcyB0aGF0IGFyZSBub3Qgc3VwcG9ydGVkLg0KPj4gKyAqLw0KPj4gK2ludCBudmtt
X3ZncHVfbWdyX2luaXQoc3RydWN0IG52a21fZGV2aWNlICpkZXZpY2UpDQo+PiArew0KPj4gKyAg
ICAgc3RydWN0IG52a21fdmdwdV9tZ3IgKnZncHVfbWdyID0gJmRldmljZS0+dmdwdV9tZ3I7DQo+
PiArDQo+PiArICAgICBpZiAoIW52a21fdmdwdV9tZ3JfaXNfc3VwcG9ydGVkKGRldmljZSkpDQo+
PiArICAgICAgICAgICAgIHJldHVybiAtRU5PREVWOw0KPj4gKw0KPj4gKyAgICAgdmdwdV9tZ3It
Pm52a21fZGV2ID0gZGV2aWNlOw0KPj4gKyAgICAgdmdwdV9tZ3ItPmVuYWJsZWQgPSB0cnVlOw0K
Pj4gKw0KPj4gKyAgICAgcGNpX2luZm8obnZrbV90b19wZGV2KGRldmljZSksDQo+PiArICAgICAg
ICAgICAgICAiTlZJRElBIHZHUFUgbWFuYW5nZXIgc3VwcG9ydCBpcyBlbmFibGVkLlxuIik7DQo+
IA0KPiBXaGVuIGRyaXZlcnMgd29yayBwcm9wZXJseSwgdGhleSBhcmUgcXVpZXQuDQo+DQoNCkkg
dG90YWxseSB1bmRlcnN0YW5kIHRoaXMgcnVsZSB0aGF0IGRyaXZlciBzaG91bGQgYmUgcXVpZXQu
IEJ1dCB0aGlzIGlzIA0Kbm90IHRoZSBzYW1lIGFzICJkcml2ZXIgaXMgbG9hZGVkIi4gVGhpcyBp
cyBhIGZlYXR1cmUgcmVwb3J0aW5nIGxpa2UgDQptYW55IG90aGVycw0KDQpNeSBjb25jZXJuIGlz
IGFzIG5vdXZlYXUgaXMgYSBrZXJuZWwgZHJpdmVyLCB3aGVuIGEgdXNlciBtZXRzIGEga2VybmVs
IA0KcGFuaWMgYW5kIG9mZmVycyBhIGRtZXNnIHRvIGFuYWx5emUsIGl0IHdvdWxkIGJlIGF0IGxl
YXN0IG5pY2UgdG8ga25vdyANCmlmIHRoZSB2R1BVIGZlYXR1cmUgaXMgdHVybmVkIG9uIG9yIG5v
dC4gU3lzZnMgaXMgZG9hYmxlLCBidXQgaXQgaGVscHMgDQppbiBkaWZmZXJlbnQgc2NlbmFyaW9z
Lg0KPiBXaHkgY2FuJ3QgeW91IHNlZSB0aGlzIGFsbCBpbiB0aGUgc3lzZnMgdHJlZSBpbnN0ZWFk
IHRvIGtub3cgaWYgc3VwcG9ydA0KPiBpcyB0aGVyZSBvciBub3Q/ICBZb3UgYWxsIGFyZSBwcm9w
ZXJseSB0aWVpbmcgaW4geW91ciAic3ViIGRyaXZlciIgbG9naWMNCj4gdG8gdGhlIGRyaXZlciBt
b2RlbCwgcmlnaHQ/ICAoaGludCwgSSBkb24ndCB0aGluayBzbyBhcyBpdCBsb29rcyBsaWtlDQo+
IHRoYXQgaXNuJ3QgaGFwcGVuaW5nLCBidXQgSSBjb3VsZCBiZSBtaXNzaW5nIGl0Li4uKQ0KPiAN
Cj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg0K

