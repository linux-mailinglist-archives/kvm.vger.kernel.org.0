Return-Path: <kvm+bounces-31768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E530D9C74FA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A95CE28AA05
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC96137932;
	Wed, 13 Nov 2024 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RGpNmf79"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2C61C695;
	Wed, 13 Nov 2024 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731510077; cv=fail; b=Oxuz/JW1rYrmymPv2D/1AbK7r/V8ao/cNth/GOK8DZxOoC8/bDRMUnSHJAfN/cZOAx6vXmTxAGUqtCxhg9njparQsGU3j1xKhE/vvNe83J9uwSBxUeoXvOuQyuTLylCcPLe6zjuBIKZ40W7bgcpAD7azqKJaVGxsPQNHf6lt5/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731510077; c=relaxed/simple;
	bh=EHJCMVipQ0oVywufdb5XmdghRWwg1WMIfdNCUbCkU2g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QLRhA2DXzfA55RnkZvfhzoPjmp2Ug5AEhaf4OxlSH7jKs7StxzkFHh431yCOs9tB4H7u/i6J6qx1aMKLtORvp13ivc4pzhuD6QUuUFhyXnXR3FE1LIDG7YvUzeh4GOORAciy/BS/RR4mPK4bNXuL7o/cmKuQzjxFUrVH122MDrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RGpNmf79; arc=fail smtp.client-ip=40.107.102.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1Fld1HWZb2nGw8W8ausvFQVc7lVxMsbYkaXQ65U0COMvXd/oDciJ0LgW30iPWQ10y2njusON1gw6zXS/DaPpwsvbpO9z+eznh3+KZVPszfUt0vL0EpeThnacuOGNZMtVOr1hgxRn4kUN2bQC4w3nBPsqxKUAosYVMyUVa7TKTqAalDU76YZaCWVlFDCdd4BVS0FZsHG9IHo5RMBD7wZ7KHE27pmUMQahCprDu19OTXNkY2/7pvvUVgXB1Drn2RyDcheFRe496VSJnkzWpKqydrLK6LlRLvvHDrB107s+oeSWTdYsliq6tC8pZJJY65Ondnsqf9ixV8/ifoyfA57zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gH6UMKw6upVS3pnCtSiYRYuE+MW5vpMcvVkolMm1jas=;
 b=XdzCaYegwGYPbQTJ8aN300eJ1AM4lzofb6RUNaTlnFaL6ZEgepFmK5eF6oOwXvwHg/UTlWM5OVXz3ZQyRgMUtwzNhKYaHOacGNw/8dNctC+sZTWK6ERbWQgjhxZCHKRmlGkTE2xWX45pCaW/0gaYwZbPK9UWPPL2kxo03Vk3oUTeMJPBrduADYaarC9QiYAapzhDQ5sOZL3dHzqZX7kNY/9SvmkdkY6Oie8/d+RP8YHwI3S42+dWbCEre9iea9ravKD3Q5rCoWmzp5fCevCQTAcM+29mqxJ9devR7TDnSTijSZ18zheF9HYt/cg0O9oam1OulTKQFKUlcpuVNQBZ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gH6UMKw6upVS3pnCtSiYRYuE+MW5vpMcvVkolMm1jas=;
 b=RGpNmf79ejEVCYP43P1hULwWwRAqjyz07qgvSSS5wa4nJuymtBAfzgc8VtSH/kS/28iXgcpw25XKVrQcjaKNZg4bHZBccDTogpZppJMyk/2AJz20kHEYq1CByU+ipXsi7TOUP/sFLwkVQvLRAaMS2gTA3n/eUdh4vY7LGqAzNC7vhoMf/FZkPgEGaieqJNmHU7XeS8NHOYlz4xqRVDumRkm0C/KOPDcl5QU708NTnBMcVJzoeJeo7M7KL7x1u3ESZo6vGIuVBATIVKVjafmmyDCj8FWwZ9rAcYetRW5NekgKaCnvyZvqFKCMW0Mv0CoGD/yQ31/O4BpKiM4cjMhetQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by IA1PR12MB7661.namprd12.prod.outlook.com (2603:10b6:208:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 15:01:10 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%6]) with mapi id 15.20.8158.017; Wed, 13 Nov 2024
 15:01:09 +0000
Message-ID: <83e533ff-e7cc-41e3-8632-7c4e3f6af8b7@nvidia.com>
Date: Wed, 13 Nov 2024 16:01:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb
 iteration
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev, Si-Wei Liu <si-wei.liu@oracle.com>,
 Jason Wang <jasowang@redhat.com>, Eugenio Perez Martin
 <eperezma@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
 <20241021134040.975221-3-dtatulea@nvidia.com>
 <20241113013149-mutt-send-email-mst@kernel.org>
 <195f8d81-36d8-4730-9911-5797f41c58ad@nvidia.com>
 <20241113094920-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20241113094920-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::14) To IA1PR12MB9031.namprd12.prod.outlook.com
 (2603:10b6:208:3f9::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|IA1PR12MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: cc235502-a76e-4abc-206e-08dd03f401d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGdTSE5KdVFub1VmRHNEbDNpN3hCNTdoZW9MajBBRjg0MndWRHE0K3lqeDZy?=
 =?utf-8?B?VzB2R1dpUVJ2QVdIVnJqQ2NUcVQ1RTFEdmcrVW5TSUlzVS9iVFExbUVSMjdU?=
 =?utf-8?B?WHJ5QW9YMWthTkNDMW84MXlrdncrc3N3d3RFUWR6c1Baem5kcEIyeXJQbis3?=
 =?utf-8?B?THY3RGJKeGxlRzd5SjJKV1hyTFhSQmtRWi9nWWN3UnZxNzlqai9USHA1Nzhr?=
 =?utf-8?B?OC82VVFJYmEzVVgyLzUwTXNUUmhiSlB3aXY4UG9PdmQyWVcwSG9uVm1Ed0Nu?=
 =?utf-8?B?YmJTczAxdDN5dzZLSENOTFI1R1ZKWUF0QTlQVzNjSlJNMEViOEJLQlptdDdK?=
 =?utf-8?B?MjU5UHhOaDFxSjJLaHBNMU93RklobzNGb0VIaFBtRFhUVVBCUlVOOGh2SSt4?=
 =?utf-8?B?ZGl2aThYMjZhZTBSVDJ6WlF0YXVrSys0c2xrc2VYM1JGajA0aGc2Sm5XcUlT?=
 =?utf-8?B?NGp5ajhBZmw2TFFxekpmNmVKSjBwMUFVMUExcnZNOFExOTYybkRUYXpEWjZ4?=
 =?utf-8?B?MXU2NXVqbFYyQmNjOWtvUG5qVTdWdExkTEpIRGlodjQyS0tLZTA4aEd5aEJj?=
 =?utf-8?B?R2lrWEhWUWF4VGtGR2lzSGJqSmhGOEVKTFphRUt5aGJQY25HenY1d1RnV3FW?=
 =?utf-8?B?MnF3eHhBODg1dHpzQTI3YjB3bUNqdnhLSlVETWFYREtwNDQrSElBYTIzVlVw?=
 =?utf-8?B?OEpQdlB0UW9sMXBCbkNBM0p2RUg5YkdFQWpac2tpYU56VTJXRFcrSmMxSmZC?=
 =?utf-8?B?eG9Rc0xzSTdPc0RtRm9nbXJJWkVPalRNY0RzUXFyTzBTZmpRNkJDUXQ5VXMv?=
 =?utf-8?B?dmk0ckV2bm9JTUYrUkJ6aWZUeFQ5TnBnS3BIYUVHdzVSdDdlR0w5NXZVbVhy?=
 =?utf-8?B?Mm5qQzFxS0RHQi9Bc0VIdC8xSGhGRzlXQmlIc3ozL1I0Q01oQ2lwWmNOa0Z4?=
 =?utf-8?B?bHI2amVDOVpySHA5VWRXK0VvRzJWMkRuMEVJZ2tCUVhPcmFlMHpZY3cwSEZR?=
 =?utf-8?B?UmQvdUtEcHc3c3hITGVWUlpXalRMLzVNNkJ1NVFIWUMvS0FPanhmTXBIdzVr?=
 =?utf-8?B?aG5yNWNLVEhkanlyem9YT3kxL0dkZVdMcWRkMzV4VEtXUFFKRmNnQURLVHRE?=
 =?utf-8?B?Q3ExNlp4Z0c1ZkdJdXFxRjloRHhzZXVjL3l4ZVpIWHlnL1JnR2cwZ2JsejFQ?=
 =?utf-8?B?bUt4L0RxMzBycjE1QVVwVGhRWFFJK3hMZFRuc2VCMTlVSGF0VExzWXNyL09O?=
 =?utf-8?B?RzR6bzR5K2FpRWFTVmY5MUh3N0U4WWFweTNYTHo1Z2xqaVp6aFRpWFRSVllW?=
 =?utf-8?B?K1EvdFhGc25mK2hncHFuTVdTdi8xVW1pZ0dETVdycXViVEd1R2o0dHEzVmVL?=
 =?utf-8?B?UEt1eDZSQTlmV3BqWWlLcC9uZWdvNGJ3dnZzNnhiZjg3NERjbk5XN2QrWGo5?=
 =?utf-8?B?THQxZXJ6LzRPaTVTS0l2OS95WkQ1eEpKSXpTaWpJTkJ0aGVueERNRUVjZi9F?=
 =?utf-8?B?UHVxZ3N4UVl0c0tmcGFOVTJrWklWTXdyV1JGRTNhNmI1VnBaeUcwSEYwN1Bk?=
 =?utf-8?B?QStOS1ZOaU9KZEp2YnpsMEVjNkszZHJleWF3SGJUTVFUay9ZOHhpNlBZNFFF?=
 =?utf-8?B?T2VubURPQnovazQxaGY2UDhOMDJCQit2Qm9WZTZTUkVDZjVrWHZWYnY0KzZj?=
 =?utf-8?B?d2hPSTRiTU5YRnFoNG1rdXNnd1pjUllPRkZFMjRmVGN3Sm43NVJaTm1KTVo1?=
 =?utf-8?Q?ctAAcOjzo0Zr3lN+HdYuJK+JOeqDBb7LoEn6oNw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MG9TcnJVNTZYMXQ0ZVJTQ2NBNjQwTEN3MWxaeTVyNzhBU21LQTg5b3hySmNR?=
 =?utf-8?B?bzJ2cGRVNDVuL0NWdERjRXdnL1d3bnRwLzBSL1NaZkFPMDBqRzhDZGJpR2hH?=
 =?utf-8?B?MnhVTDRBVEsxeSt1TGgxdm0xSmRrOWUzNVZSVVNGajc4TmgyNytsTG1lYzZy?=
 =?utf-8?B?YTJDKzVtNkZPMUc0K2NDRE0xd2MxbWdVVi8vc2ZGTjNpNGU5R1VlWmw4Mnht?=
 =?utf-8?B?ZXAxT3FLOFJPdzlCVHpybVRHcjY2VGxUY2lBSUU3VzM2UHJpMTR0OVdHc3B2?=
 =?utf-8?B?c1g2UTNoM1hTQ0NtZFkxdWk1amlvYXVTc01qR1liWUN2N3U5SG5mdHN5N2tF?=
 =?utf-8?B?TzdrYVdCV1hRdkppcWQyeEN0LzQwVU9xREc3U2RPSGE0WGpmeERNa0RCNXpw?=
 =?utf-8?B?MWdwa1RaZ0V2RDNkK0t2VkR5blQ3dUxub1hJbkg1QnFoNDVHVnNOZ3JmWlVY?=
 =?utf-8?B?K3JoM1RuVkVqdHd5Sk9tS1lBRk4ya0F2azZoOFZPMEhib1RYUU9Jc0FsSmdT?=
 =?utf-8?B?UHJYdmlPZ2dnMHR5cDdxUlIyVGR5M3dIYXlsaVZ2cG9oeXd1cGMzTmNKMmUw?=
 =?utf-8?B?MGFxZklMdnFLdlFoUXFucVAwN1FUcEVaR0c4d204Z0JjUzA1SEZqN3dNMXZh?=
 =?utf-8?B?a05Jakc4cVlEaUprQkp1WWJXK0J3TXFGL1hTclBhNk9mSGtySnkzQmRjWm5Z?=
 =?utf-8?B?eXpGY1FUUkVneWNIZ29LdU4ydysrMFRxSkV5Nnh3YThSdGJ0VXVtdmorQ29D?=
 =?utf-8?B?Q3NZUXVTdWtWWHh2REx3MDZsKzJYOTNLR1N4cUJST2E2MDhLSGFKSDlJMWd2?=
 =?utf-8?B?VWw3MDlJUDg5emdWN0Z5Mm5zUUxmeHM2WlhEMy9rNTVWdzh1d0Zkc0o3Y0Mr?=
 =?utf-8?B?MEUyUEdFblBhQzFlM3dndDFOYlBVc0VrYWprdmkxa05YaXJxVmlaUlhNMDBV?=
 =?utf-8?B?Yk1xUUNRTFdrN0hQN3RsR3FxcXFQMktoeHdzYWpwZjAyMXpyaEhueklNZWI2?=
 =?utf-8?B?bk4xeVRxU3lhUjZIN2hBbXU4NHF3Q0tiazUydml2QmU4Q3MvTFFocEtpTTJq?=
 =?utf-8?B?WXZhaFphWFV6VUhSWllWd1paeGlaTng0R2VEK0FOUnlWRzROZUw2aHFiT1c1?=
 =?utf-8?B?bVEvOEJMUWhBRHQ4TmpPOUpaMko5cGU0VEhxTzZTYk1qM2JuNmVrRlhHVHpH?=
 =?utf-8?B?RkkzZDRmMHRraVgrbTN3WGZuaVhmQ2g0NDI4cWhrdUFUR0ZvVklIV0NndGNR?=
 =?utf-8?B?SGpBdjFZTFhST3dzQUFaRmF6Y1FyYVR5YjlWMHZ5N2UyN2lUeURyTnFKeE1x?=
 =?utf-8?B?aFpxYlhpSzJxRjdEejJRSTU3VThtT2RDc2twMXNTZUdMWkFKd3dxOHpwMTBG?=
 =?utf-8?B?cDVHZXB1elpDWEFoWnA0NnI1d1puSTZ1aUM5RVk5cXlGV2lXdkc2M1JoOVdU?=
 =?utf-8?B?YnUrc0llMUtZWnMwUnBKVkw4d2t3cVQwbEVrZVdIb1hqOTlXL3ora1dpYjdw?=
 =?utf-8?B?NDVqYzRmR2ZjLzJMb0loRElOUkhpL25Fc0s3WS96UEVmREtmSDhBWVpsQXR4?=
 =?utf-8?B?L2ZOWkhVU1BWYk1LUTI3M0RYYjl0R3RRQThkZWZ3RG9UeFZHSFZCNkFHZ05h?=
 =?utf-8?B?OEVVL0VvOExhUklaeDdyM1pPNUZpcXNVZW5vNHlTeXBCZ0FyMXV0eHRPSFhw?=
 =?utf-8?B?VkZzRkVHUHBKQzBFZ2gzODJrbkg5K01sOEU2NjJNckRVSWxXYXViNW9uVDVC?=
 =?utf-8?B?LzlGWEo4cCtKaWlBamRIMk1PSFhONFN3K3QxUDRZS2dCQ0FhVVl6LzNycC83?=
 =?utf-8?B?ZEJ6cFNhbGtJamV5MkZCTHhUMW5Va2VnbkFLaUlEQlBxUFY3UHV1NnQ1alRu?=
 =?utf-8?B?dFJuL3dFWXJsVUdHS25FRUF5S29Cemc2TWdYYlVKZFhQZkswQTBFWTc4aXVi?=
 =?utf-8?B?c053SzQrNnRIbVBScXlvNFh3MnlmM3RqMnhXVzdtSndLeFl3S3hUcjE0WjBL?=
 =?utf-8?B?MHdLZ2FWQnVjeE53K2V6V1BwS1pxUDcvMXFwOERPWm9LVGIzMHg1cTRTR2hI?=
 =?utf-8?B?QmtJK1JIRVBoVnNmR3lpYU1STTRiOTh4aERDWGVNRGw4OTNYbURraUhFNnln?=
 =?utf-8?Q?QFOzXMJ0kaCXpCqpcXXQQqZ8E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc235502-a76e-4abc-206e-08dd03f401d5
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9031.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 15:01:09.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHcjFemtMrNJWYZ6ea+ZMRYs3zH71C8xsMNQGK1q5K7L71lgccWyKGD018eIi1cBKnRm/YrbWbBLlWcbyxYSXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7661



On 13.11.24 15:49, Michael S. Tsirkin wrote:
> On Wed, Nov 13, 2024 at 03:33:35PM +0100, Dragos Tatulea wrote:
>>
>>
>> On 13.11.24 07:32, Michael S. Tsirkin wrote:
>>> On Mon, Oct 21, 2024 at 04:40:40PM +0300, Dragos Tatulea wrote:
>>>> From: Si-Wei Liu <si-wei.liu@oracle.com>
>>>>
>>>> The starting iova address to iterate iotlb map entry within a range
>>>> was set to an irrelevant value when passing to the itree_next()
>>>> iterator, although luckily it doesn't affect the outcome of finding
>>>> out the granule of the smallest iotlb map size. Fix the code to make
>>>> it consistent with the following for-loop.
>>>>
>>>> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
>>>
>>>
>>> But the cover letter says "that's why it does not have a fixes tag".
>>> Confused.
>> Sorry about that. Patch is fine with fixes tag, I forgot to drop that
>> part of the sentence from the cover letter.
>>
>> Let me know if I need to resend something.
>>
>> Thanks,
>> Dragos
> 
> But why does it need the fixes tag? That one means "if you have
> that hash, you need this patch". Pls do not abuse it for
> optimizations.
> 
Well, it is a fix but it happens that the code around still works without
this fix. I figured that it would be better to take it into older stable kernels
just like the other one. But if you consider it an improvement I will send a v2
without the Fixes tag.

Thanks,
Dragos


