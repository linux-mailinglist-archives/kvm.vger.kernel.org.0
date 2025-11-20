Return-Path: <kvm+bounces-63791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE7DC727DF
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 08:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id DDE352BCE6
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9811B2FFDD2;
	Thu, 20 Nov 2025 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PsJBc5Zp"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010030.outbound.protection.outlook.com [52.101.85.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46491221D92;
	Thu, 20 Nov 2025 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763622204; cv=fail; b=ocZrzjJ+iZCaTBxQyZHuNguXvXo1cCNGp5eIsuQRPt/NQJhKEglXT+KfkqkY+ZUGqPUTckLbo/lCVRLOhENXVGCQG2eieOV5AtQL7zErcWRmrnFu4pIprGjgHNXtR2kqJ5tvZ5vAPXQzSobTLl46NsWpiJKBPnSFYtCapcAzB/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763622204; c=relaxed/simple;
	bh=OPcLzPgyeLQomwp6VG2xpRqZOTP5XSIG9HCAKHFKOZE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XAPQ0TxFnFMWbY612zxfVdeHfd1Uw9PmImIdKPfjajvLKwqpkq9J+pHxsGjjoKjEO9jg967x1lm4/yD74QYpoamT0lH+5+GDZiOJGyxREcnHfUS5bZbC1y9x8o3n7pDR3N4dVrLR5T5CyIza5hV6frU79Dc+y2X3b3l5N9Cr2Ws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PsJBc5Zp; arc=fail smtp.client-ip=52.101.85.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWrU2AbUPPqC5xrFrdaBRniIhLlOAmPCkKP/TUnLX9P6sGoaEdUTf5f31RJ4Qk5KEEAbWA0nzKpZEyNoTBxGzmBSVvi0DNpkEdPJhXJ077CLkrxqlegEcuaLTA4JIDskIIzntoFO37v1Na9eKnMf3WNyQBZzBf7SsOgZ+gvFUEYo+KwgRSdRsIo6Z7OI6ayoXLWsIpXqG1xZnXD6yVsEJBFBaQyxF8RFnL46ihCFW43ISfXQQijpA+VdF3MsprOklz8dWDZ8VaOiYnHd7ofDWPI6mK2bRTFafJzZ08EGIDmArIJfTuyxJBM43EoJ2J48ypuSOqcy80lm5Ro2PhC1zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3MISL+mFyVTmzYzwazWG00wEiRxPhf8BM6JtrWjCIE=;
 b=AcQOcx4g5ZhtIKI+rjry/X3jkWn6KX7T4EzypXSp470mA7vSBZOVlse88hBbP6kAqnAWQG7lXSLjQ3ighqkTQ2AFvBgbWbWjQYPSdUkqO4PdHq7zikr5p6LD/3h7aCofNj+sOCrZ2WPXCN5hlxXo9qxHAzBAPqvUONk38TKMp1Y2+3ypA62XWSQzDPpxkRInGiKuD6/K/Fmm7pIDm305lB6v+hoEH0t2gu7Re/psM78panMc47Q1kfGfey8BuH/PMRXUiKIS/Pm4jLk5gW2IazRT2/9nQbe8maAR0zlN0j4IGW7M51IFxGf9kfR/LLwcPBSSpfKtbHYN+JoGKmpo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3MISL+mFyVTmzYzwazWG00wEiRxPhf8BM6JtrWjCIE=;
 b=PsJBc5Zpnve3aG93cj4gLJ7HLXXZnv4HCp218Cto7XLQRvWlgdpzEpfUC3ZOwoEZXnhN+3P8yuqB4W1f+5J04eDDcCGvsxw3r/FrnJFHhpoUlH8ybWsOr2zcZdM9LZmGmL3Oz1MPzW0ExNPCDiTVTHSaW9a4qInx/MeIr3N4MHw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 07:03:19 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9320.021; Thu, 20 Nov 2025
 07:03:18 +0000
Message-ID: <3053398d-94d8-42fa-aedc-927746375521@amd.com>
Date: Thu, 20 Nov 2025 08:03:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>,
 Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119134245.GD18335@unreal>
 <6714dc49-6b5c-4d58-9a43-95bb95873a97@amd.com>
 <20251119145007.GJ18335@unreal>
 <26d7ecab-33ed-4aab-82d5-954b0d1d1718@amd.com>
 <20251119163326.GL18335@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251119163326.GL18335@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0132.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::10) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cfe9733-553b-41e2-48bc-08de2802e1e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tm5hOTQ0WnMzY1lta2N6K09oM0loQjNGVmxFR29oWmIzbWVVaDNGRzkycVdF?=
 =?utf-8?B?MHZyZzY0TFJPaXc1LzFWeEZFQk1PRlEzaFByYzdCRFdzbS9qUU1BeVpPWmlv?=
 =?utf-8?B?L1hWQTJ0cnJqVGNUQ1dZVkIwVnZPYWJNNmRXSUQwYUM5eUduYkEyWDh0b3c2?=
 =?utf-8?B?aFBubTV4S1EreTJlZlFUVjdJRTdKemwxQ1BQd3RyRDF4RG84TDB1VlRvdURE?=
 =?utf-8?B?R3Z1SFRRRVBPbzZkajQ2SEd5bS9WekNmaURIK2ZvM1prcWtER0VuM0JTZ3g5?=
 =?utf-8?B?MHNiUlZWTmk1NmxyWFdVUy9ZYWxseWE2cUpvcytiNG50eUg3anlndllYQkE0?=
 =?utf-8?B?SWVPb1pwa0xZSkQ1TVhkMjQzekhWS1ZscFEraEVob0VySGI2L2dUYWN6MlRW?=
 =?utf-8?B?cVFaMmhwNGo4ZnJLSkFXdnVDTGROVXJBOEkwdk1xL293N3o1bzI3TysvcGty?=
 =?utf-8?B?N0RWQ0w0WUNZYitBTkpHVEJSYVU2MVlpVUsrbkZWMiswK1BZVzBNK1NhNzBO?=
 =?utf-8?B?L1g3MDBlMkhITGlMSFhOZ2N3NlU1bVdnU3RvY2FMY0F3ZEJZdkNldDhsVWFD?=
 =?utf-8?B?eGlCZTFnaXdEenRsWU9OQVZVZ2VXQlMxS3RnOFc2eUpwUVpVMXJZaHNDWmlt?=
 =?utf-8?B?ZVp5bHJMLzN0aU5UdHVwS1pBb0ZrVXlZN2pXMmJDTXFybU83K3FwVFVWclM5?=
 =?utf-8?B?ZE01NU1DdlpMS0dSM1JJUXU4dzlrWFYxSFE0VlEvUm1MQ3FWclBmOUFjQUty?=
 =?utf-8?B?dWl1V1B5OFlsZlcrMzcwMHBTWm53V1lLOENFSFBjb1pjYnVxT3dMWndHV2lJ?=
 =?utf-8?B?MjFIS0FodmFQaURPWkxUZksyVThydU93MGRUcGcrcVVKNktSenBIMTRHTk93?=
 =?utf-8?B?L0pGR09XTVVycit1Uno0REpZcUQrdlJxeGRjaWFpcGoxU3pSWXRsOFlsSlo1?=
 =?utf-8?B?Qk8rSGdzUVE0YlVnOEhrM25UTVR1OEMyNmw4bDI4K2FOSlEzMnRiOExLdEFQ?=
 =?utf-8?B?bU5XcG45YVpJMy9qN0JTdG1UWm13OWpaeWxSc2MxQXdSSm9DcGdVTngxVG1x?=
 =?utf-8?B?aE1DR29BZTNiaDVJRGVCajBIRUJ5aDBaMkdHZDJHc1hydGpUakhFN1F6NzY2?=
 =?utf-8?B?MzRrdlMvNTB0UkxHZ3BhaGhIaFZZdllPcVE0cjJJVk1lN05XcmNaUzYzbThs?=
 =?utf-8?B?eTNTUjJZVWx1dGlaN2I2NFN4dWN0WWdndzNXenFBaE9uK1hQbWFVR05ZeFdW?=
 =?utf-8?B?amU2U3RMdHkvaGc1YWx1cXpETkR3eHBlSDkwN2dnU2VKc3ExdXdEdER2czVI?=
 =?utf-8?B?ck9veHVpQXBBSWpQeU1ZR1pzTk9MTThxQjNnL20yaWpuWmk1cmZxSmJ2REFP?=
 =?utf-8?B?alNlTWtRSFVucnRkdG16ek9VWHV2MDhnR2VLS0trTTgwd2ZJbjlpMjZRaTk1?=
 =?utf-8?B?NllNU2VQTWZOc2UwMzl2RmVwYy9RTGlKZmcvY1pub3lKUkZTang2djhMR3B4?=
 =?utf-8?B?cDM0bkRBbCt0Zjc0aGJuOXpiSXdkc0c2NEVjTmNBc3hRYUlnbUhobitORkY4?=
 =?utf-8?B?KzUxd1AvNjBFQWczK0dXalY2eWUwSWE2TG9aL25DVGdMU3VJT1ZoTHRtMjRY?=
 =?utf-8?B?VWJHZGtIcU53M1FSdlE2R0VaYnlPa1BnUU9UdXFKQmoyTC9qejZjUFM4eWZy?=
 =?utf-8?B?S1FkcHBBQjRVUWhHMGkzazFkWjZjUTNNVEVYdDB5YXRoS2F0Vko4VjdDU3RO?=
 =?utf-8?B?N3BXd29sa2oxQzBPOE9rWkZMZHZzMVN3d2FLWE5IRDVCbW5WYkJpZmNVVnNK?=
 =?utf-8?B?cFRMZCsvc1dOVnhPNXM1eUJKRExuRDdaOW5BeXpKRTYyeTlpWHBKd2lVcUtP?=
 =?utf-8?B?VnErWW5FekI4SXlIbXIwZ09za3dHMWUxbkp2NVZsN1pneHNtUG5zL1JESVJO?=
 =?utf-8?Q?G1YB0GXfWFiYQOGRgMzGc4IGsQqlRS8q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUI1K2ErR3ZUVlRDVFEybWd5N29iK2RzY2dudTBUMkw2Q1FUc1JZYlk0UjRR?=
 =?utf-8?B?MGdra0FkK0UrV3ZBUXRWeDE0a2M4VVFsYitsTmljbjdsdkJBandIZ1pwcy9F?=
 =?utf-8?B?WlJHTEhhZjdJQng3VGZ5TkpFWXBMT0oyRm1lczVoZEcyVGNsSVE1T2dmdmUy?=
 =?utf-8?B?Tk5ZWkJGaVd6L0xUcGlURC9BalN5K1d5M2hBMGkxSTlvSmo3RkNDRUUxZDNo?=
 =?utf-8?B?TzRCalZ3WGdLY0xyY3orNTUvc29YRGxUUEVCc2J6N2RZNDJNalUwVlJTRTF1?=
 =?utf-8?B?WDNrQko0N2RVTzltNk5YU1V6QWd4R09WUzJMNzEybDJHZ3N5WStsb0pYSytm?=
 =?utf-8?B?T1U3dWZkbzhrVW4raTc1V05LN1d3SzYrUHo1ZjlrajNLMjcyWWpOLzRSVWNu?=
 =?utf-8?B?UVRJZG1TRjNUMHlSQUNySDJTRjZyOWxrZytnS3k1d3J2ZzdmRS8wVUNzRTlX?=
 =?utf-8?B?YjU3a3VVcmJXQ1d2UnQ1ZTRNSW5ZR0NHZER4SUFIek80OGU4cW5KTTFscjJN?=
 =?utf-8?B?aTBzOXU3MzgrdFcxSzhGNW81cFZzR1pSckZ6UktyL2FNU011RG1CYVRxODlT?=
 =?utf-8?B?NHYzcWdSRWlUTHNQMXFuK2VNenZsTXBZem1oUmVtSnBwWFV3Ymt1S2VnWnZu?=
 =?utf-8?B?NUJobHJ4UlVJbk1hMkI2TkFXV25md2txTlh1bEtYK2t4RFVITjE1VzhZZWs2?=
 =?utf-8?B?OCtGejhycnJtYVBvZEpDSlc0ZlI0ZzBDeXo4SHlXcGVDTmRjSjE4eGt3cDUr?=
 =?utf-8?B?eGpzc1BSSGFFMDA1QklGZk1BSXNwakNRQ0lWS0gzdnBVQmNUSHBPVlRmL00x?=
 =?utf-8?B?MFBkbGIzdXhKV1FPbUZUREZGR29KNFBuamZuOTI5TmppU3BXTy8wTGgzc0M5?=
 =?utf-8?B?ZS9RSm9nUkt6ZDZoRDdaRlJGMGdKOEQrZjNVS3Q4QzRjejRYdkVSaUVVTXFC?=
 =?utf-8?B?VExyUmhUZjhvU0s0WTNsZnc1azFWU0lUaFZsZm5mNEtvN29BdkU3U2pMRTlT?=
 =?utf-8?B?TEZkTGRpeENqY3pnZ1cybUVTTGJoK1hFWVVBVElpc2ttL0dFWURjeFpzMXJ0?=
 =?utf-8?B?ZzZYSG9nUFJXVGlNTlo4bVNNZU01M0d4WFp4empyME1tL0xRYzFlK0lhVWZU?=
 =?utf-8?B?eWlXY0lEcEMrdkliMisyM1NndmR2WU90d0pSUTErQkZDS3oxcXAwRDNBMEZi?=
 =?utf-8?B?UVFSL0NmQTdxNmZEb0FmMXZkbnU2ZTVrQVlhM1FTT0xjRlhpcHViU0F0QzJv?=
 =?utf-8?B?WjNZN1FEU2Y2NTVaTFEvWHlIcnRkeWFCOWtmbC9XbWoybHo5VVFBekVlSDh4?=
 =?utf-8?B?ZVNJaXZjbkkwc25mUFB2R2hzS0pFOFpYdHRpNjF6dVM1QlRlQzJKTlBkb1FX?=
 =?utf-8?B?Tm5vdjFGTVVKUXg2RlphN3V5Z2FzMW5vR2llUSs0eTk4Z01NcUpUUHo5aG1a?=
 =?utf-8?B?aFMwb2RYdUxOQkVUQ3VaRk9PRUZWa0hhcGxDVnRuVDJoeGUrcGk1VjVSaEJL?=
 =?utf-8?B?ZGg2aGtUOHliYzdlVlIyYk1ld2VGTXZoQ3F2UHhyTnlxMHFrdUFobnMyUWY4?=
 =?utf-8?B?TStRN1dXSGtDakxDMlN2ditZTVJLYlB1UnFrOGpWNXpOcGJuYVFOYjJGV0Vl?=
 =?utf-8?B?Zk9GQmtuNmRMQXNaci9obDJCSjZiT2Q0T1dISDk0bjYxVGJrbkhjYUtOZWV4?=
 =?utf-8?B?TGFlM3FGdm9mbVhEZGRud3hLanp6Uk1GMXFmZXBPSVQ4Nkx0MW5LUW41UFg5?=
 =?utf-8?B?aUtrZzhlQXBFd3lGdTVMTGdRYjVhZThhTXJBYlJ4NktWckFieUMwWUNHem1k?=
 =?utf-8?B?SDJVNlVHeXdVS3VUUkpyS29ibmsrQWh2SklYbTFPVDhYV2JGS0xxZnRHeElR?=
 =?utf-8?B?cnlQa05lSTZYOGl2WkJBS25kUXY5TExLdmljRjhpRmlYKzJXbTB5U2xqdjUx?=
 =?utf-8?B?Tm4vRkhvZnpPc0JuYWRVcVJsTlFjczJMTVdYY0FFZytaamxnNHE3WE5uV2NZ?=
 =?utf-8?B?OXJNcXJ5RDhyQklFU2pSWmdhNXBhclpzcHRPbXZyZzBkdVNqV3p0YjkvZXpr?=
 =?utf-8?B?Y1FPbnNDc3luWlJTeW5WYXN4Z3dsRE5jMG9yQnNsVzVBcmVWaEFzSzRPcWl1?=
 =?utf-8?Q?IroW2k2FfVlwus1iQIF1W9JY6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfe9733-553b-41e2-48bc-08de2802e1e5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 07:03:17.9763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H0DQX/N9WFRfTPIiS6ZtXjmjv3u5g5R+ezsuEq9m6Ch3PxrNUoEac1wePxZnU1jN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850

On 11/19/25 17:33, Leon Romanovsky wrote:
> On Wed, Nov 19, 2025 at 03:53:30PM +0100, Christian König wrote:
> 
> <...>
> 
>>>>>>> +struct sg_table *dma_buf_map(struct dma_buf_attachment *attach,
>>>>>>
>>>>>> That is clearly not a good name for this function. We already have overloaded the term *mapping* with something completely different.
>>>>>
>>>>> This function performs DMA mapping, so what name do you suggest instead of dma_buf_map()?
>>>>
>>>> Something like dma_buf_phys_vec_to_sg_table(). I'm not good at naming either.
>>>
>>> Can I call it simply dma_buf_mapping() as I plan to put that function in dma_buf_mapping.c
>>> file per-your request.
>>
>> No, just completely drop the term "mapping" here. This is about phys_vector to sg_table conversion and nothing else.
> 
> In order to progress, I renamed these functions to be
> dma_buf_phys_vec_to_sgt() and dma_buf_free_sgt(), and put everything in dma_buf_mapping.c file.

Yeah, the problem is I even thought more about it and came to the conclusion that this is still not sufficient for an rb or an Ack-by.

A core concept of DMA-buf is that the exporter takes care of all the mappings and not the framework.

Calling pci_p2pdma_bus_addr_map(), dma_map_phys() or dma_map_phys() from DMA-buf code is extremely questionable.

That should really be inside VFIO and not DMA-buf code, so to move forward I strongly suggest to either move that into VFIO or the DMA API directly.

Regards,
Christian.

> 
> Thanks


