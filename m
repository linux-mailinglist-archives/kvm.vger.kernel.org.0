Return-Path: <kvm+bounces-25058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0545195F59E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 17:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B74A1F22BF9
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 15:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1FB1946A2;
	Mon, 26 Aug 2024 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TAFJaw25"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FAE145B1D;
	Mon, 26 Aug 2024 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724687639; cv=fail; b=QpVwd+5xRnQDZgOXSVOoa0LTkE0pNkt86dzbsaO4P3HFBBpJvL74ZFB2i68A1WfNAJik01mxxORinhkyvtGciYCHhZpRUasYEtsNjptF0Nu6It1i+MD0nmSI3HSc2Dvfwvj4/xNTeqvegWg2E7zahLDy8VYbtDlZDEIo5T7h5nE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724687639; c=relaxed/simple;
	bh=FdFn0bys+BjcAl0p272kphb/gXWPwVCP9oKJGjkT6n8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lnpc2IUalW5LZVKq/mAytcHkTh1qVXuMEQW0GQ696DyIRfNlTOtMuxCwq/SBLoUUvnyRtKCXkoIdikE1aLGq5nCclwRDy1onyqhrW37VvYxVBtyxL/l2N8Us4DlWPZVLynOAtv8QiHWiu25txMW9LH3fA1wpnX/bKq0R9wPAdjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TAFJaw25; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMsROeDB+vouVYVRdZQ9Ua0I5QVjjst/PucItOxmmQaqJmTRzEpZU/EsSoYTXaUl9UOTQjdI2d+rzkQLJv6BBztHzGQ974BgN10fB9BDj6rXAB/EDPHnCAPNPFzcHjP5WIdepYFRZG4uCcdOVZZu72YSm/OuJzbMhU1TQeAfXGeLn9l6yl+I4C1eylpVaGj/DW6Z8Vp0IpjVud4Sw1iMNMT1tV8vwrlGrYDrLIW5T+Aue4j1MT9FZ+7W/hbQ4h1BnExe0lG4e17Md/M8O784pNR6N1i48qWyxFVMMT1+ZI1OEI31Q5Dv8csaKQciLoq8qQvtnZ5l1HK/i07j1QBJuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtYigxZYCTWOeVSVD2jPZOAHnw05tYsFTxZpAdwO9Tc=;
 b=Q62QpTBXY3poGFKt1nrIXAfNdiP3dEbLOxQEJdlI1lGNpbJu3hHjElzNIH9Y0YJ3enYjPORhVwc+4EJ4lpHacLyUvnedlibL2aUn6rh182T6U3jx5HIxle5eAHGf4Qnbj39mCCrACxp0GMRzO+v0uAeBriH92sT8E5QthI3+phSiA5h4+kKLcfPipwo97SVQCFe8kkca33xS6gFe7B0/2zz+ESK9xlyUXl6ueFi2NYDud44vJIaPk+WydPkny/vgkftJ1slqapjs76MeMOlKdvCtNmabufnQBcqJouLkBGq/aZneXYzmI9NXpVsxdZk3L2zRu36NvI+mhgspTq/4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtYigxZYCTWOeVSVD2jPZOAHnw05tYsFTxZpAdwO9Tc=;
 b=TAFJaw25JZDntK7T+Awr5juvsiMipGq4BE+KLd96ja8QuzfwmeY9UX6ogSIvobvNY4bZhqf7dFmac4K0kI0GziuHetnY1iX6JiCuoXa7GJ8D39eE9WF9fpBrVzcdszOD+6grndjJBiisxsvJSPLri+GZAH639znNtiVPyxHqrjrs0VeN3SRxuOznuq/etvVf+NPR7imHrzXBD4b1HFH8AXwyx8FVnPVoAvALZxzABPcDjWbJmm8o4tG/lrxssOfOVye1bC5vswhcTE5rrRbTPsxYPIDoUVbzHKhn1r/0PpKQCdSOAX9zZ/9BCWjjUuzD5w/GztyPazA4f5WHcYUqnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 26 Aug
 2024 15:53:53 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 15:53:53 +0000
Message-ID: <2a1a4dfb-aef1-47c1-81ce-b29ed302c923@nvidia.com>
Date: Mon, 26 Aug 2024 17:53:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Carlos Bilbao <cbilbao@digitalocean.com>, eli@mellanox.com,
 mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
 sashal@kernel.org, yuehaibing@huawei.com, steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
 <8a15a46a-2744-4474-8add-7f6fb35552b3@digitalocean.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <8a15a46a-2744-4474-8add-7f6fb35552b3@digitalocean.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0275.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::17) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|IA1PR12MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: a3389f60-d84a-4fa5-8b5b-08dcc5e74927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWFheTU5dkR0Nk91UEJYNXRJbDdFTnYyTzJCZmppZXBsN1BmZUhXSUo4WkZN?=
 =?utf-8?B?V0VVL1c5K1BUd2FGbnYrRDhycG9QbmN2SzZHOUN1alFsM095Qzlxd09DUHBx?=
 =?utf-8?B?dktoQmJPNGplMzJQZTBjNkl6OHVwTXc3S1AraVFFc3p6c0cwQ1NJRVNONzhx?=
 =?utf-8?B?dHMrSjc2NlRsRnVJd1hJdWs4eTBydDMweHM5Y0hNK0RVVlAwUWs2bzFpbHMz?=
 =?utf-8?B?bTlBTnhCOHdBWXpKKzllYk55VFpObk1IU2w4a2tyT0w5YUhwaGpCNUk4RVk2?=
 =?utf-8?B?UVo5N3dTZUhmSFhNRVNXQ3Z1Mkl5TDQ3eitTZEo1V1RtQ0Q3OVRpaEhoblV1?=
 =?utf-8?B?Q24zUzFHbWwyakVBV1U3aDJMcmVsNGVIVDVwMmY3QndrQzNpUTVkK0JJMjY5?=
 =?utf-8?B?UWlEWk5mRE8wblB3azZKN2N4VkptWk1leHlOOWhEcXFHczk1aTZmcXFidldl?=
 =?utf-8?B?SlNuanl1YnIzd0MrRWxBZThNeWthd0cyVW4rV1pZR1hWOXZpOE5kcTVrcVRm?=
 =?utf-8?B?TzVycWorelJHOEszN3pybGl0QTl6Y2lrQkVnODdxdFMxYlRoWEJYZEFOZjRp?=
 =?utf-8?B?QkVJY2EwS0VTblJ1NHVRMERWSHRIZXJFOWxqTFB3aGVDU1BDbXpPZmJCbWJU?=
 =?utf-8?B?YXd3ajRaaVkvVDhEUi9kZFcwMng3clV4K0V4emJCTGJ0NWNhRStETmh4SjVH?=
 =?utf-8?B?UWtaMkgzRWNQVjl1TTlUZlhwWWpDQ3hpQlNvR1NHcDN0aGdVVW4rY0xnbk85?=
 =?utf-8?B?d2NTVitOemVua09PY255ZlhTQUpVY2x6b2ZSYkFCclBENHRtaU9Dd09YZktz?=
 =?utf-8?B?MjJXTEIrVVJRU0dZSmRUampjcFFjYmtpVEdacEFyV3FyeW0raFgxZUU2Q2lH?=
 =?utf-8?B?b011K2ZjbTJjMEFIOTBHRjNnOUtESjhNVGZmOXlEY2N0RW00am5mNWtzRGd3?=
 =?utf-8?B?d3ltWFF3WUpTZHhTK2hNdXRCdUM3WFpONUpEUUltczRvSXM1Z3FvV0gxRm8r?=
 =?utf-8?B?dmh5TkJabEtaRDcyZmtIakFac3htclFyNzFpZG85c1RLY2NUVXE3U3RhZllW?=
 =?utf-8?B?ZmdUWkY5VDB0N1hQWm1sYjR3VXBReWVsYUdjd215TGRVUzd4RlBTbkdWckVl?=
 =?utf-8?B?QzBiQ2hDa1Y1cFQwd1FZK1VySEdRVVM0cFpFN3RxV2wrR0xHbm9zaExWQnZ4?=
 =?utf-8?B?YzlzTFFKNy9RNFA1cWpCQnlaVnU0eng3RjVRYklLclNLdVgrdkYxNXZmbXZL?=
 =?utf-8?B?VkJYWUxBb1V3V0l4K1cyeXBIc2N0KzIxWnZFWUN6MXVlQ21uNHFCWnplN2xK?=
 =?utf-8?B?cTJUYmRwOHJMRVAranhnOGVNWGVTVkRtL01qdy9yQ3FVMHJCWHRWdDg4Rnln?=
 =?utf-8?B?YXdONUlHN1ZpSFRLNXFMRkU1RWk2ZGNvRUNlS21jbktpSXI5blh5L1RYS2Z5?=
 =?utf-8?B?VEo4b2dGYXBCU24rYk8rb3lNU3VkeFhmalZnc1lBQ3VuSkZXUGdMQWZrNzR3?=
 =?utf-8?B?S2w5MmR4SHJDWnUrMDNmVVVJMjZUY2w2TERJNE9zZUJlYitKUllaSXpJWit4?=
 =?utf-8?B?SE9FTTgrN0VzRU5kZmFZTTdNUWlzYW90cllFSkVsakpVOENPN3V1V0s5THlh?=
 =?utf-8?B?K1FaTktnanc5a1FrVUpndlpEbWtTZlNZYXFwTnh3a2pjbHhvTFhoZDF4OENK?=
 =?utf-8?B?Z0hLdHZuVS9vaTM4ZFYvMFdKcXZHbXdsNWpkM1czYXlmY05VM1lQRzVjTVBk?=
 =?utf-8?B?Z0tybGt5eFBSeG5sRWNnbXlHNG9oYjRQbE44enJMdlZwaEc1aWNVc0d2aWhE?=
 =?utf-8?B?bXJmRTB5SElxSWFrcWQydz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akF3aW1tUHIyWXhONEpyMGFjVE1zbDAya3pWbFYvVWIxSlo3eHZYWDdsVUJ2?=
 =?utf-8?B?UklyUnk0NDc0NWhNdWFGak8yOERSeEpvSEJtSTUrQlJySmk4VWlURFJLYzRk?=
 =?utf-8?B?Mmp6QzdXajRrbnZkZTVNanVnSEhQa2hyOEsvMTUyWFdubHB5dnFINkwwbndH?=
 =?utf-8?B?MWltOWpBYys0QmpqQ3luMzBlb3h3NE8wU0VCUWFNaVA4dFMrSFpxU3dhekRP?=
 =?utf-8?B?cVN0QS9CM095dXVBd3pqc2NZZjduMmZQRHduR3ZORFZyb2dPRjc1cm1BTmkr?=
 =?utf-8?B?UkFvbXhyUXFzNXNTUlhsMVlrd1lsQVVGNENCMGJXRlhhUTkycHRjdVJsZlJK?=
 =?utf-8?B?d2s5TW5JSkFOa3JDM3BkRms2T09xekNkU01kOXBVdzZVTXY1VWx6L3V0TDVG?=
 =?utf-8?B?dFRKRTNQMnIwczJFUURYK051ZlpwMHcxTEo0WW14SkhsczBpYVJFUVNqQWF4?=
 =?utf-8?B?anNOWWdldU50SnBVdUEwUHNpN2pHNDd3RzQ5TTJ1dkxuSVJWc3NnbW9pOUdo?=
 =?utf-8?B?S3RIVTBjd2hvbnUxRkM5a2tlZEE1cHplbjBSRm5OOWVDUlc3Q0lhMHkzUGN6?=
 =?utf-8?B?bnFFSUtWcGpYV0tmTXZZVFE4L2xVQUpxYW85am9pNlRPaTFramE0NWpZNHN5?=
 =?utf-8?B?TDMxUkNkeWZkcFBCSWZZaC9XYWc4ZktnOXZBb08wR0MyK2tWV1hFN3FCeEt0?=
 =?utf-8?B?bXRBRkJNZ1A0dzBPT3Y2NmwreDVRajYyUXZkQ0NleTRQellET21aSlZnU1Vx?=
 =?utf-8?B?UUtLeEFwbGdrV1NYa204OFVoYkk3UXlUcnNhUlY3MU96dmt5bnJEcHNlSXlU?=
 =?utf-8?B?bUZNMlpwbmkrTUx5QXltbFlQenpraXlUdDVKT2hsd1A2aUhqU21xSHNBMU4y?=
 =?utf-8?B?YkdreHBzRmwyNyt4alpvZEJsdFBUU3V0SXhOZTBhVXdUZGxDdGxWdEtURWJF?=
 =?utf-8?B?NUdmSjIxNUVYQ2N1M0huTkNGdWt5czl0YUVuUHp3YytodTZGQjQ5Q0ZtNmxS?=
 =?utf-8?B?Tkw5VDBpeE5OOXd1aXhsazhQSGJ4UE9lSzJ4RDNsUGltMTFrYUdBQTlXRHVG?=
 =?utf-8?B?bjlwUlZiRHVPQWF4TDdnNjBlamMzelFMbDh0alI1MVBOTUhFcU80ZFVMVVoz?=
 =?utf-8?B?dEVZMmRZZXcrbSt5cnFFdDZGOHBCQ2MyVllDYlZvQlZLUEUvaDhBNERpY1Z0?=
 =?utf-8?B?ZGpvQ010ZTViVkNneFRUVDd3bk82bkpPZU1XNktPaVJyeW1rMHd3b0twQzQr?=
 =?utf-8?B?ekV6SFJBYjVPaytDS1FCVUYzMGFaQXFqSXE5NEozYThHZWtlcHJwS1pybDFE?=
 =?utf-8?B?eDM4STJYMWxnRHlVaTNYSDRHbWRwQXQ2bVJ5WUd2ZjZ3MjNZQyttNG01TlJl?=
 =?utf-8?B?NEF1djdzcFZDcHdBTzFCY0lMRmNXY0F0YUJLdXlWOEdDeHlvWGVJWnJjNktj?=
 =?utf-8?B?ZGJ1ZXVqSkRtSzFMWWRGYll4RWRiSFFWaGREZzVObGc0THZ1eFE3S2NkckFp?=
 =?utf-8?B?cm9wQlZMQkdibWFhZTAvVWRNYkVBaGp0Z0hmUk9IcUw1Z2drUXFrSk9xU2Fq?=
 =?utf-8?B?Tjc4WWpHbENqVi9YbW1COXNzU1NPTW9CdmZLYmZCeUVybXR5RmdQbm84anpK?=
 =?utf-8?B?RlRNc2ZSMm9ZZXo1VHBTck91OExZbjRtVjZZYW5QeWxrUzVJZnIvb1VGdEw1?=
 =?utf-8?B?ZVZCSmlrQ1VLdEVRZGhzUndVQ2lESzVpRWlUZGc4VW53d3JJd3JyRnQ4bmx6?=
 =?utf-8?B?ZzFUTmJ6cDRzaytlT3BERzhFcjhlK1kxNkQ3Zm02WE5vdW5RUFZPcGFIMHV4?=
 =?utf-8?B?bCsxME51clJka1BGQVFNZC9ON3dVVUo4TXVuL29FaGlJQmpCV3VsTHNxQlF0?=
 =?utf-8?B?SWxERDlBWGRaQnNyeUphT25GZDIwS2F2OTVxeDlBWFQ1ZkN0aGxoOXYxeUMr?=
 =?utf-8?B?aWc1b2l5ZWZzOUlhUmtVdzA2TFVyY3psaS9BL1NtSW1PVlFValdMQXJNcHNO?=
 =?utf-8?B?bWtWbWNBbzE0ZDdGeXFvRjVGMllFcG5Nb2o4cDkwR1hiZERnd0pvcHkzT0Uz?=
 =?utf-8?B?VFVtT3VFQzA1UXhGZ2tvc3phbjVHZ1RlOHhVYVRpSWNKcHBsLzdoSnVwT0Y1?=
 =?utf-8?Q?W7Py12gMG5c2xsKOJe/ZZAMas?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3389f60-d84a-4fa5-8b5b-08dcc5e74927
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2024 15:53:53.7389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5wgn+qvxUe3ut4tl4AiPo8hjtPYJ2uroeMLhVBO/5kpvvcjN36dQONeKpd4tu8LbRb825KgGIhHY6gpuaX/3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190



On 26.08.24 16:26, Carlos Bilbao wrote:
> Hello Dragos,
> 
> On 8/26/24 4:06 AM, Dragos Tatulea wrote:
>>
>> On 23.08.24 18:54, Carlos Bilbao wrote:
>>> Hello,
>>>
>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
>>> configuration, I noticed that it's running in half duplex mode:
>>>
>>> Configuration data (24 bytes):
>>>   MAC address: (Mac address)
>>>   Status: 0x0001
>>>   Max virtqueue pairs: 8
>>>   MTU: 1500
>>>   Speed: 0 Mb
>>>   Duplex: Half Duplex
>>>   RSS max key size: 0
>>>   RSS max indirection table length: 0
>>>   Supported hash types: 0x00000000
>>>
>>> I believe this might be contributing to the underperformance of vDPA.
>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
>> feature which reports speed and duplex. You can check the state on the
>> PF.
> 
> 
> According to ethtool, all my devices are running at full duplex. I assume I
> can disregard this configuration output from the module then.
> 
Yep.

> 
>>
>>> While looking into how to change this option for Mellanox, I read the following
>>> kernel code in mlx5_vnet.c:
>>>
>>> static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
>>>                  unsigned int len)
>>> {
>>>     /* not supported */
>>> }
>>>
>>> I was wondering why this is the case.
>> TBH, I don't know why it was not added. But in general, the control VQ is the
>> better way as it's dynamic.
>>
>>> Is there another way for me to change
>>> these configuration settings?
>>>
>> The configuration is done using control VQ for most things (MTU, MAC, VQs,
>> etc). Make sure that you have the CTRL_VQ feature set (should be on by
>> default). It should appear in `vdpa mgmtdev show` and `vdpa dev config
>> show`.
> 
> 
> I see that CTRL_VQ is indeed enabled. Is there any documentation on how to
> use the control VQ to get/set vDPA configuration values?
> 
>
You are most likely using it already through through qemu. You can check
if the CTR_VQ feature also shows up in the output of `vdpa dev config show`.

What values are you trying to configure btw?

Thanks,
Dragos

