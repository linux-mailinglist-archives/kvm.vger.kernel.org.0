Return-Path: <kvm+bounces-25379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33C99649F1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C66E28241F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FF81B3723;
	Thu, 29 Aug 2024 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pXlXf4ET"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE191B29AF;
	Thu, 29 Aug 2024 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724945178; cv=fail; b=lmWnE0Nt5aQfhCR6kPnp5oTAr+jk+q3Vd2NpT0TGniy0qNOYP3XfWeNu3AQKPjytrmpGifBt+KvozO4XY4/TuuHnCJ6uzOAkheu5cM650iwIzDTtBqLeRjkoay7zfV9kiCDtsUBYrug7bKf5NFit/A23rUdxiw9Cl8p4SmeVJGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724945178; c=relaxed/simple;
	bh=AeN6SRVnaYLg2EJYrU1TfVGhPWHJJTCb6T9UH6qW190=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q33RWwDFtrZTqfaxcE1bm9lYOlUuv30r8t3d4NcmiLCj9yPrG54M9EPoOSc2O1CJpDHDrwojcymmxK53ht4/W78YgIuKjesami4wr/cz0vx6w5hh9mhsaA70Y19QR/rZFyjh9xLmpSEaTBAV5fUoFq1Ajky6DiivDD6W8HnsYYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pXlXf4ET; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aah9EQqmNSVApPNL7lz7fK7LBUB0LwfhYgbUciTw2Uh+R81EJf6DzKiUJPhCqkoSCVVIOvk/HcsomPvnDFQEf6xumcMyHzrgRj5tv5kEw7jRYORJHnhFC1Wsm1b8KuQXQ14Nw27ITdZhbIYrOKdJ5zOa5wX5f7rsKW8S6uWJImXkDhaNf1XCNipCJsN2MsLUa8aRIFCecvQLqrpQB4Pqu+ccqfLjz/+HMivNGXC4CHlcZmeobH7eF6VsapaM7KE5AtFJiKdGoRzMQlUARX8yz4YEnDjHbfNL1CxF94f8aPa17J+kC+aSlT4X2yGeLjfqcIATeusZ/UZEG9fEYDFiGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nbu4NTSKp4c/SH3IrABvWpO1i6zh81TdTzACIo5aORk=;
 b=Y3GrPGWGTuJsmIYx0bUOsTjTbO2PB+sO17skYqiYhyZIvEnQP0IAE6MiBOFHKaKkG45htli+z1NC+/zDkcTDEpy5SPr3bJ6OM0Iu+jMxr6C888LJ3D31i5ZpqWFQ55GyVEreTPO/Mx0RiguALvLAPvmzASAr0FrsCvKE+aeKr9Ofhwm0x+DGWbt37s2AR3iIF1F0tlmGxHIEA3zvLMvkrO8CA/rWWno3p7C9KP9rdfbvg+MuqZbNbozSNi81zf4XXJ1VQcaK8NRZ2EgCOT2ZHv975VhOXnEJJobrzDy6OuJIPm11PIUvCcFSZidlSsssA2vVdgFtd1/Y6qbYb9lr/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nbu4NTSKp4c/SH3IrABvWpO1i6zh81TdTzACIo5aORk=;
 b=pXlXf4ETHVWmJU+rm6ERMNpdAzFYD7gVTeLDCXWuh2FB6bLcYKJrSAHi57txwPhQxl357ERzyy3zgc8Yr1MHRmmoOj6FRbBcT5QARz+ricd6cManuCs1z5TgR/NT/QOVctrNy3mD32AccjL60u+42nEnKTS5qBvK1m7FT5ylTsWJ7MkDU7/XqF2+Jk9XcbusXzw2gfuZbW3f8iby3nnnz6qxnVIySj1eU5ynp1WRQ8oZZlk4pAechm+SDP+nDDvdC/Yx0kv9simH98ZeR6QRv5cU9RDAvPfrTnmC433s/wc7Ru6fQo1EKIigmtm81pCa5Rck98QtliEssGEBdPvavQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by DM4PR12MB6159.namprd12.prod.outlook.com (2603:10b6:8:a8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.28; Thu, 29 Aug 2024 15:26:05 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 15:26:05 +0000
Message-ID: <1f9467a9-c42b-438b-afac-2b38b9862542@nvidia.com>
Date: Thu, 29 Aug 2024 17:25:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost 6/7] vdpa/mlx5: Introduce init/destroy for MR
 resources
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Si-Wei Liu <si-wei.liu@oracle.com>,
 virtualization@lists.linux-foundation.org, Gal Pressman <gal@nvidia.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Cosmin Ratiu <cratiu@nvidia.com>
References: <20240821114100.2261167-2-dtatulea@nvidia.com>
 <20240821114100.2261167-8-dtatulea@nvidia.com>
 <CAJaqyWe29MmDZgUkrOKibWN4MGjt+sWvsNfk6SeRHhEHPJYC5g@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAJaqyWe29MmDZgUkrOKibWN4MGjt+sWvsNfk6SeRHhEHPJYC5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::11) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|DM4PR12MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 2676d161-ac29-471a-033d-08dcc83ee501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0RTSHFKa3pvU0Nmb2tOdy9KZ0ZEUnd1ckhrQ2dhRnFzM1k3YW1iQjRkNG02?=
 =?utf-8?B?dm4xNTRBdDZOSTZNdFh3UXh5S2pCN1QyVVRRWFMyRUkxODZhUC9BZ2tpZVY5?=
 =?utf-8?B?M284WHNBclEyajVoa1pWazI3YUk5OW1HNW5iVnJQRFpSUFlucFp6V3R1Zmwz?=
 =?utf-8?B?Kzg3ZWJBWjVvK1hWSGF6YmVMTEU1OWJhVE90SVJDR2grUk0xanRwQmtTTE9w?=
 =?utf-8?B?U1pjem4vU0xCR0JoMzJJWUU5dE5aUTZUbFFuZWtzdFpmN1NMMmRrQXN6MWZn?=
 =?utf-8?B?QkwxRnB4empTTjZ2dS9vcXRtUE1IQTEzbVZ3UXI0V2k2aTMwTy9QMzl5dDZ6?=
 =?utf-8?B?WlpOR0ViaDVNWE9BdGxUZjYwa3d2cEs5a3JBaUF2L0Z0dEhMdjdPVnJEd1Nt?=
 =?utf-8?B?K2VTbmJ3U24rcXMyazhvWEFlc21HdDh2TmNvbmdCbVNSbWw5MVVTajl5bE5j?=
 =?utf-8?B?dXp3d1hQSlFudjFHNFJBK3ljeitwdDlNaGF0UlRSd0hyTVJqWDI3bjZ0aDZo?=
 =?utf-8?B?N3lPMk9DTmJBZXowcy9FTHdNUC9mdlBNUE1JOW9DU1hvaWNwQUc1U2VGa2RN?=
 =?utf-8?B?ZVJ4VnEyckNmc1dyeWVvY0l4cGhOaU9WMDRpU1dIbDdkSE5ONmlHblAveHJp?=
 =?utf-8?B?R3ZFVDhoTHNjNDNGVHU5UWJ6YUNwWnN4VS9Pd2p3bGFDNzB6OFBJekVqUVd4?=
 =?utf-8?B?bXJYNzhwUGxvSFBFTkM1eFgrcUZxUkVjTU1kSG9JNWduYWhlMjJLeENnZ3Fy?=
 =?utf-8?B?dTFFK2sxYlhvMnBnS3F0M2ttaFdsU0JRcTFpTTAwRGJIZ3V3VHR6NHl4eHRE?=
 =?utf-8?B?U2FaRGh5bjZqVFVuNG0wOFJpTDY5RFRMZ25UWW4xR3p1azhrZGN5dXJjTFph?=
 =?utf-8?B?SnRtRmtEL2NJZ21VWVR6Yk5DVDR6N0ZON1U3bmwyREFBZVgzZjI1b1orK3hD?=
 =?utf-8?B?dHVnZ2hiNFNzSXI5UGFZdHYvaHlzNzJ6L2Zhbk5rQWV3MXBEdTdTWVplVzFN?=
 =?utf-8?B?Rml6c2VRa3BSRWRvb2I1Tk0xcE9GMU1SbVhvKytpZ0hpR3pReTE3c3FrYkhp?=
 =?utf-8?B?amp2YkVxRllnZ090R1piMWtWaU1GUk44R0lTMDYzbmRIS010NjZ6Z1B6SThm?=
 =?utf-8?B?SHFaTVBEWDFQVm9QbDVJL1hCOHhYVDZxYjgwdDNwRVh4a1RYdE1QZTNSaVVG?=
 =?utf-8?B?UDZnNmpwZHptMTNvNmRSdTlmMUhvZVBMdTFyRW5QeDJGTmpLSk9tTWpvS0Ny?=
 =?utf-8?B?VUxQbTczOUJ3OFhMc1VOcnFxRTdCQnpVbGc0dGhicEFPME8vY3VhZTZCUlVu?=
 =?utf-8?B?dExSSDc4by92MEZsSWdYcmIycW52WnQyanA5VHNWemJ0c2R6czFybGs5V3l5?=
 =?utf-8?B?QWhBKzBLRXBXSVN1NDYyYkQ0d1haRTAzcUsvdFg2c2dUZ2NWU2E0a3R2SjZU?=
 =?utf-8?B?OGRYYXVZYnpwOTVmTi9PWlNrSENETm8vUU9ic2F0eXRxRHR3TzdRRGVubkFz?=
 =?utf-8?B?U0ZZVnNOUWVLQWlIVFRFckZjNitIL0tGNUhYdTV6VzU0L0hjSnlFN2hlVFAy?=
 =?utf-8?B?anFPNzRhMCtENERwMVBWa0NkWmJnSnB1Wi9rMFZSWmpqa0ZDNkIya25FcVY4?=
 =?utf-8?B?TFAwcGMrK0NFRXhMdTN0LytIT244YVJOZ29VWHRLcWpPZmw3K0FaZVFHZ051?=
 =?utf-8?B?OC9oQ3ZtT2lLcjJpQWEwOWVGZGdGc29YMWw1OEtnaHNoMWV1ckVleXdKS2hp?=
 =?utf-8?B?WkNqelV1cHJvS3ZVamRIQS9vcGV0d1VVcmZQcXhlOWgraG00VDdBMHFFdWZa?=
 =?utf-8?B?ZDBIWWJkSHY4MzJWbHZuQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yys4SWlYd1NlQVN1WFc2U1pmaWRFRzc2WjhvMmlDTUF5TmlOYjdEMGxiYWtu?=
 =?utf-8?B?b3hsOFBaVEU3NGw5Y3AwRlV1TjBSaDhwSE5aRmlWWU9OZDA2b1hNMkR2ejAz?=
 =?utf-8?B?TkZGTm5GandTZjJCSnp4dVN4R2hDRlQzcGIvMjhUWWw1SXRUeFZVc1QxZnpp?=
 =?utf-8?B?RkhuMnNoZUo1dlFhOXhTemhVTzNIMER0eS9Udm9KcHRteHIvdHR4dFY3dEI5?=
 =?utf-8?B?SVVtdVpiY28yb0lFajhKenh6R2krSVNpMXRoNm5OaldyY0xuZnprdWN2dGI0?=
 =?utf-8?B?bTVGZlF0RGxMblpQd2Q4STZuQUU5eUc5SmdrUzBaZ1BIVkRveTlzdVprSm5J?=
 =?utf-8?B?aXFOYUVUQ0NOSkJBOENoL0lMd2RVVFNSbENVSWZRcURld0kwT280bzg4UU11?=
 =?utf-8?B?dFpBQ0lXd0w3T0svaHlWc29USHp1amZDbFY1N3A2blRUMVhveEd6dloyMk80?=
 =?utf-8?B?dElrdzhLK3RiN3I3VVpNSkVrWVZGU0Rtbk1tTG1pa2Vmc1VLdncrWnU0b2p0?=
 =?utf-8?B?dW5MSU5PL0tEUWdEbk9yVHZSZEc3TG9Ec21RTEZ0N1FkMUI2YWdWT0NRcGVn?=
 =?utf-8?B?NEFBVVJqdm5nZFlkbm01eFVNZ1BHQjZuOXNCRmg4RWpHVnkvQmloYmcvVUkv?=
 =?utf-8?B?QlJlVUVFd3pucENhWUxNOXlTZ085ZkdjSmtnNnNvd3FGbm5GcEpTV0hlZFg3?=
 =?utf-8?B?NW82bXdtRy9hbzRkSmxlK1pIMkFsQ3NiL3JNeE9Ud0hCdlVKV3Q4OUE5ZUtI?=
 =?utf-8?B?Y00vZHBBNnZNaXpYWmMvOHI0MHlGNzUvRC9pNnhycEhvSmNySFg3cWd2RHRx?=
 =?utf-8?B?M0NMVlBodXF3dFNESEtuemlET3lRakdwVFpkelN5STZnU3BPOWJDRUcwOGVv?=
 =?utf-8?B?WEJzZS8xbWI4VkpEYVZMU2kvdjhMYTRSRFA1ekRkRk0rQ2FTMlVrUEd5SjFX?=
 =?utf-8?B?cFJpcWNsVUVlbW1VdEt6cWIrWjJuM21uaFYzUzIvQU9KSDRKZGhkSkhJNDlO?=
 =?utf-8?B?bkRoZGZiZ3JlUDZ2WURTbko2V0ZNTU5pbW15VmFsRHJWYTNUVVJsODR4aGlq?=
 =?utf-8?B?TjYvdEtqN3ZLZTR5eWJSWTR5blNTZHZKaERiU3huZjU2RGQyUm1MaTVSVHdh?=
 =?utf-8?B?TmJCNTE5bklmWnNlcWxVRFc5ZUd4Ymg5SXQvM25jZmd3bTVCM0tYN3VGaWww?=
 =?utf-8?B?VU5SejZPOG1QemR2VXorZ3hxR3drVm5oaFk0TWxyQWJsdE9nZDlyU3RMbGFV?=
 =?utf-8?B?VXFwUWd6T1ExelBFdzB0d3FVWWoybmlnN0hMQzdWcXBSdWpXWVV6MldiK3JQ?=
 =?utf-8?B?RG1ManBnMVEwMXVyZTg2aUprZUREZDB6aDRJM3JVTEN4QVo0RmRDMFpjYnMx?=
 =?utf-8?B?SlEvTlA5WVA3MWNGT1RMZzlIZVIyTGFoTXhLeEM5REJ2Y01CQTZEZXMxbEVV?=
 =?utf-8?B?cHMzVkgyenBUWnE0Nm1vNHVqaThuS1Z2Tmk1UTFMNGdzMlJmV1lmb2dOMnZ2?=
 =?utf-8?B?WUc3QitSMmtubHZNS0dXcnNLNjRCWkdOd0grYXhBOWdkaWNnSWRkem5QODhh?=
 =?utf-8?B?OVljd1BaaXlKT0t4SEJYQTJzNFYvTThXUERlV0RxZW5rUDREcGdZSmpRWWhO?=
 =?utf-8?B?NDhKMDc5R0l6cnArVFVHeDZsMjhLTFpkSFJxY2xWRis3SUxVSElkR0JXWFFP?=
 =?utf-8?B?K3pGWXJwRHhwVzVOYXdtWUV0K0RTaCtyNE5adlN3YzJNZFZIWnd0NWc5RlJZ?=
 =?utf-8?B?NWh5bWJ0VkMya2pJbmpjWTZHZkd5WGY2TTVuaXJ0bFQvZTg0ck5WKzFNN0Rv?=
 =?utf-8?B?ZWlqL3VFek9aaVNPWis1WWxqd3VoZWoyY2RFeFk5alljbnFRZHdWNkZ1RHpL?=
 =?utf-8?B?U1pCb01jOEJzZEZrSkpWaG9vVWtWQW1WaitreTYrV2NXOVhJcnJoeHdBY2g4?=
 =?utf-8?B?TEdmejZsWElLajNPRm5XUUpZTSsyTDFWVERFaTY3aStEeDNmYXkzR3g1OThD?=
 =?utf-8?B?TmdOYUM4TXk0Q2hlUnZHRnZQeFovUnA5SlBtN1YxYTdQVDZ5Wng0bTJoa0tZ?=
 =?utf-8?B?ckJXRkFnZ005bTZUL2JIb0dBdVpnVURGTWV1RWVmcml5QjJFclFucXlhR2Nk?=
 =?utf-8?Q?JCKqrq6QaesK1pwzsLKtV7Q9w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2676d161-ac29-471a-033d-08dcc83ee501
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 15:26:04.2793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvRIP5DjIy9ixm23kOt5iuiUiy9oDylokFGt0mr7ivrXFdcF+yDJ3EoR6poMSAlaQIsjMCrsalzwkj0pCNNQbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6159



On 29.08.24 16:37, Eugenio Perez Martin wrote:
> On Wed, Aug 21, 2024 at 1:42 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>> There's currently not a lot of action happening during
>> the init/destroy of MR resources. But more will be added
>> in the upcoming patches.
> 
> If the series doesn't receive new patches, it is just the next patch :).
> 
>>
>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
>> ---
>>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
>>  drivers/vdpa/mlx5/core/mr.c        | 17 +++++++++++++++++
>>  drivers/vdpa/mlx5/core/resources.c |  3 ---
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 10 ++++++++--
>>  4 files changed, 27 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
>> index 89b564cecddf..c3e17bc888e8 100644
>> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
>> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
>> @@ -138,6 +138,8 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, u32 *in,
>>  int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
>>  struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
>>                                          struct vhost_iotlb *iotlb);
>> +int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev);
>> +void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
>>  void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev);
>>  void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
>>                       struct mlx5_vdpa_mr *mr);
>> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
>> index f20f2a8a701d..ec75f165f832 100644
>> --- a/drivers/vdpa/mlx5/core/mr.c
>> +++ b/drivers/vdpa/mlx5/core/mr.c
>> @@ -843,3 +843,20 @@ int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid)
>>
>>         return 0;
>>  }
>> +
>> +int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
>> +{
>> +       struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
>> +
>> +       INIT_LIST_HEAD(&mres->mr_list_head);
>> +       mutex_init(&mres->lock);
>> +
>> +       return 0;
> 
> I'd leave this function return void here and remove the caller error
> control path.
> 
It is like this because the next patch adds an error path.

>> +}
>> +
>> +void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
>> +{
>> +       struct mlx5_vdpa_mr_resources *mres = &mvdev->mres;
>> +
>> +       mutex_destroy(&mres->lock);
>> +}
>> diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
>> index fe2ca3458f6c..aeae31d0cefa 100644
>> --- a/drivers/vdpa/mlx5/core/resources.c
>> +++ b/drivers/vdpa/mlx5/core/resources.c
>> @@ -256,7 +256,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
>>                 mlx5_vdpa_warn(mvdev, "resources already allocated\n");
>>                 return -EINVAL;
>>         }
>> -       mutex_init(&mvdev->mres.lock);
>>         res->uar = mlx5_get_uars_page(mdev);
>>         if (IS_ERR(res->uar)) {
>>                 err = PTR_ERR(res->uar);
>> @@ -301,7 +300,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
>>  err_uctx:
>>         mlx5_put_uars_page(mdev, res->uar);
>>  err_uars:
>> -       mutex_destroy(&mvdev->mres.lock);
> 
> Maybe it is just me, but this patch is also moving the lock lifetime
> from mlx5_vdpa_alloc_resources / mlx5_vdpa_free_resources to
> mlx5_vdpa_dev_add / mlx5_vdpa_free. I guess it has a justification we
> can either clarify in the patch message or split in its own patch.
> 
Good point. Will do.

>>         return err;
>>  }
>>
>> @@ -318,7 +316,6 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *mvdev)
>>         dealloc_pd(mvdev, res->pdn, res->uid);
>>         destroy_uctx(mvdev, res->uid);
>>         mlx5_put_uars_page(mvdev->mdev, res->uar);
>> -       mutex_destroy(&mvdev->mres.lock);
>>         res->valid = false;
>>  }
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 8a51c492a62a..1cadcb05a5c7 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -3434,6 +3434,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
>>
>>         free_fixed_resources(ndev);
>>         mlx5_vdpa_clean_mrs(mvdev);
>> +       mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
>>         if (!is_zero_ether_addr(ndev->config.mac)) {
>>                 pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
>>                 mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
>> @@ -3962,12 +3963,15 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
>>         if (err)
>>                 goto err_mpfs;
>>
>> -       INIT_LIST_HEAD(&mvdev->mres.mr_list_head);
>> +       err = mlx5_vdpa_init_mr_resources(mvdev);
>> +       if (err)
>> +               goto err_res;
>> +
> 
> Extra newline here.
> 
Seems like I'm keen on these extra newlines. Will fix.

Thanks,
Dragos
>>
>>         if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
>>                 err = mlx5_vdpa_create_dma_mr(mvdev);
>>                 if (err)
>> -                       goto err_res;
>> +                       goto err_mr_res;
>>         }
>>
>>         err = alloc_fixed_resources(ndev);
>> @@ -4009,6 +4013,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
>>         free_fixed_resources(ndev);
>>  err_mr:
>>         mlx5_vdpa_clean_mrs(mvdev);
>> +err_mr_res:
>> +       mlx5_vdpa_destroy_mr_resources(mvdev);
>>  err_res:
>>         mlx5_vdpa_free_resources(&ndev->mvdev);
>>  err_mpfs:
>> --
>> 2.45.1
>>
> 


