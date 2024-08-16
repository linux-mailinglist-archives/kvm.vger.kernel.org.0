Return-Path: <kvm+bounces-24384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E38D495486F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19058B2185B
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 12:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0D0194124;
	Fri, 16 Aug 2024 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W4E3dpkY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D4E156F2B
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723809707; cv=fail; b=aCqj/vGZNCgixAMwJDTUUBqtnVDSuC4/sgR2Vbh0a0dzLa7NL7Xy6EoEtEO42UryDuEZlG25WWm+EpZazwKDPovlCSKG5+BTymuoTmmLzVswCZNSNwP8ENdgPzFPRpq7cGsUjI2qhN458NuxEWTqTVR2Kz7Kq3SjqzQJ0jqFhw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723809707; c=relaxed/simple;
	bh=1RQVnHrrx3np9hRTn0f5fwJZVcKwhdqRQocSWTTKT0c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UtQsOIa9wAiaqCdn1ZLTDBZAWkh3390tulZ8SLDTVtmOlPGvJiIvBSMyQhZSS00MA9hgMOtP5ZoouTYhMfX571W8xk+BY2MS34Vzs6VXoq1U40MMih9j3382KivkPvZ1wilFZ4iLA4qPjERZB9AQuDC/A/rDXi8mv/7OrKesZG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W4E3dpkY; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZcMznEaJV5QCbvCo5vXY4hwg4ZALbwwyyMcHaciV2K+CZDOIYzWNv5qQdQuhwVIWJsEvvxL4PPKM631UhLFUa7AIpLyajbH4W/5GGGx9t8Z056l6L0yBWhMlaQ2egbGknDqjuHyIuSQxUPZCqXSLvn1x539FErCmiq8RdOI6jqBIo3CgAxzHoo4xHJHC1a2hZdkw+HrBJGy9K+LiC3UdnzgMSki1x9c0UISkbRC7ZRyOTN6ULz0xLediMki1FVJnAPblpNfbmI5QI8R3K5g80TmnjCtJbh3FzY1GYRObJme5aA9DQneAvdgr0h/562jDPUyjdzchXsSD7IRZndJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2WhMlSEYokNB4HlBb/PDCw6frv1wDjqHR8MPe+kzqE=;
 b=xY83MDVjz9p6AaLalBasnhAOvn/NmLGx0GB3y1Xr60hHajs9+0Lk1NT9bgxHx08nyjUr1hUvBsgRBymNbePKbLwCU9K4xgJInJw2jklz9Kp3qhS97alp2Bc6YhxYA9Ly7DMelWrq1I+TIqFBTnSYOvkPuF+jj4GY0VGqNLziJBl/nhBd7cGaz8CvDFWv+BfpfHcksyh7sfJupBWgFW+9/DPtmPTP4LlkCmlx2sSTC12GNN4TzkJf+Jd1MHho/lFDMxVVfEXUnBhESsy2mNiU6saoXyrdusLNuojAFNrTo6D/X2zpkI+g2vJUWH3hrzhZhN3TrtBG8eHfcWQvaxG+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2WhMlSEYokNB4HlBb/PDCw6frv1wDjqHR8MPe+kzqE=;
 b=W4E3dpkYHdv8sBFhsuEsCJz5ukSmoB5Y1me4EAHGawYPqTO9yv1lFY1RLPoymIP75gPy+2D5kntxb4GcYLqPocfIE8ehN+t/enUlStSo4aWoPVqrsRzGXnXhjDLRRIdytzzq1QSQNPHz9odAvWROdAOUIkVO7IZ/oflS9cW73yk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH2PR12MB4248.namprd12.prod.outlook.com (2603:10b6:610:7a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.25; Fri, 16 Aug 2024 12:01:43 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 12:01:42 +0000
Message-ID: <f6c4e06e-e946-489f-8856-f18e1c1cc0aa@amd.com>
Date: Fri, 16 Aug 2024 17:31:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Baolu Lu <baolu.lu@linux.intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "joro@8bytes.org" <joro@8bytes.org>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
 "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
 <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
 <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
 <8a73ef9c-bd37-403f-abdf-b00e8eb45236@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <8a73ef9c-bd37-403f-abdf-b00e8eb45236@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0216.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::14) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH2PR12MB4248:EE_
X-MS-Office365-Filtering-Correlation-Id: 19835256-550f-414b-1ef6-08dcbdeb3157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OURCbWczZ1BrYzUxZ3VycGFiMXBYUEFrU3d1eUlMVVdZSHN0YzJBek5WNVBI?=
 =?utf-8?B?cyt6TnR4S242SGx3dEgvZnhCVFYyTDJlRmo2bFhkdkQ1aGg1Mm5kVmk4R3hj?=
 =?utf-8?B?RkdneEd2UFdUTEZRbXZKOGxpQUNjeDJqYVhER1pLVWJLclQrblFWbU9xTkVG?=
 =?utf-8?B?SWNqR3o3SFlXQkgvQnV2UDNEVXpkZDRjcGFxN2l3WEFlVHRwbjBXcFFqN1JG?=
 =?utf-8?B?UmhOK3dOQmJZN2RKV21YdUM0c3JyaGJDY0ljd2NwUHR6empyMEZRbkJRNHVm?=
 =?utf-8?B?YVdJNUswS0x5RzdFTnZSSGZvV0JJNjlYdVhIa2VSRURaV2Mxd0RBbkd2ZmJY?=
 =?utf-8?B?eW5mTWVnN3VtdG5NK0VOM1JEanhZSUswV1drU1JFWnZ4T1ptQ1VpK2RQY25T?=
 =?utf-8?B?OVpwdDZhRm9mL2VRNllrUW9KMGRTTHd5L2FDY3hWVWJEenFaRDJsbys4eFNN?=
 =?utf-8?B?SWp5eTlHdkFHdUZjYjhrY3ZEeERZZW5PRzRrVk5FQmtWTHVIY2ovY2kzdWts?=
 =?utf-8?B?WUs4alFrZEFZOG5lWmo2OFkxOVVKdEZMNFFyRzFKazd4VXdDUEpzTlRlWlFx?=
 =?utf-8?B?Y2FvdThDclVlL0tveENCVjdIMElJOGNXK0NRWTdUc3RkTi9WMUQ4MkIyRC9G?=
 =?utf-8?B?SkhHZGNIWXhrUG9mdFJjajJpcTNhTVkvc3hFdkxaa3ByUWRlZDNqUlBHaXA1?=
 =?utf-8?B?ZDdsSHM4V0N1TDBQVE9EVEVDZWsxbTEreVpCM1JQOWoyZ0dLTlhhblhhZHU1?=
 =?utf-8?B?eC8yTS9GTS8rQlNJamVFYUtNQ01TVEFXdEFXU2pVUDVIVXM0eitDNEpXUGxS?=
 =?utf-8?B?czZodXZUWVlZN0lac3M5ZnZnYkpxTkZ3QTkraTVpRXdaOTdJTnZNRlI3RWJH?=
 =?utf-8?B?UmtKR3BjUkdmM1NZZkllTnJuaUZtTFE1dkZPMmdQSEV2aG9GR0NGcnlrVzdM?=
 =?utf-8?B?M2FObFJJcFRDcW5BOWozU0VyZ0o2NHVXS1gwMVYvcy9IMFhxa3BFajBKSVFt?=
 =?utf-8?B?WVRwdkJTYjJiTk43c2o0cXV2MDVzeno4WkpXTThVeDl1eDV0TWtvWUh5bXpq?=
 =?utf-8?B?d3BLWFNZa0VES2hLWmlJZTloM1hXYW1kRDBvNWdHdklSZENhd2xPUTlnVDZm?=
 =?utf-8?B?VWtiZ3NFNFR6NytZb1BoZzRwVWM2UHNKNU1JZmRsbWtFaWNWenNsUGV0RkJm?=
 =?utf-8?B?Z0JSQVZnWWY3K2R0cEY0MjJkOWo5WDRsYk1Ldmt5eGdwdEhxelUwYnBWWWIx?=
 =?utf-8?B?VmVWVlNLbnpQdDlKU2c2WS85VlE2bnJmMXcvaGZoTGVQTzljV3lpOFh3SVpR?=
 =?utf-8?B?UEN3YnFZenRnSjlmNi9ta0pKaVdydStvRFJ2aGpFL1N4ekY0ZW05U1c2dml3?=
 =?utf-8?B?YXY5NEhnaFdkV1dnR3ljYWhSV2FiV1Q1TlVtSG9Bd2VxWlppUnJNTkp4eUFk?=
 =?utf-8?B?RHcrb3RYd3QzUjNweTlLc0I3RDZNUkRTRTRxK05La250a0N5c0I1S0czNTBP?=
 =?utf-8?B?U3c0Y0t4RHdnb2pEMGMvZkYwL05QZnkvUVQ1Rzd4UndkVjJrRkVibngwbjgx?=
 =?utf-8?B?NEF2bXVFRE1Nck9kaExQaUhHbjdkZVJmU20rcGlMZnZRWjZpWTV0a0o2WTBT?=
 =?utf-8?B?aWpHUVJHTktjSWZwTFNhb1I2bWRvM2I1L3huM1ZlMklZbjVGVWdaMWdoYzlW?=
 =?utf-8?B?elBDK294YmU5RDFFR2tsYWdDODJ0RFgxcHVWS2t4aFRseHllV243TG9oOHFr?=
 =?utf-8?B?ZXlCSzJ2blNjb1dwQjBaVzk1eWZ4N2V5VmdGcHdDbUJ0V1c0TExuVzdtYXFz?=
 =?utf-8?B?NklSR2xmdEx5cmFmMFFXZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGlDRE9LVXZFRTdUQ2xvRGc3MFFCcHp6WjhXN1Y2SFpuamVzZ3Q0bGtjT28v?=
 =?utf-8?B?T09mTEFHNytwOC9nbER5OGhKQktUcUdFWXVqcUw1TUErRnpiLzBIbFVjQnVo?=
 =?utf-8?B?R0h3aVhqdFVnZ2hJeWk4bWJURndaS0F4SVB0UnB2SFhUM0EvcW5TeXZ6VWpN?=
 =?utf-8?B?UVVaT3kyM2g5UFVxVG9Ka0FBa1Y1MmhzZEVkZnJZL2VXWGZ5UUpIYTQrQmVq?=
 =?utf-8?B?SG0zQVBXTUdrU2R2SUdaOEtuMUREdzh5L1hzTHY1TCtMWUh1RnF4MWdpMzVy?=
 =?utf-8?B?dW9OSndnUUx4THdmNm1CWTZaMWFXSGtrd1Y1dHRZUEhyakdtN3l6bXF3UmN0?=
 =?utf-8?B?SUhPRHhQakF6TzFpVWNGaXNOQVRQTVR5WnhwVGw4YXdFSW54YXArNnpKZ0ls?=
 =?utf-8?B?bDI4aXJvcDg1cGlpWTVhREI1TzFTWW1xdGRjclliRVpLM3NSeXE5MTdlYVJ6?=
 =?utf-8?B?NHNrY3JVaDZkakpnZ0VETURQVC9sZFlrU2RrcDZubzlmSGcyaWl4L1l5d1E1?=
 =?utf-8?B?ZGJ1Y0NHMUZOMU9XWENtZTFpbTc1cTNnbUJhdTh3M2UyQU5QWnpBVTNjZHFy?=
 =?utf-8?B?c3lIYVdaT3VZSjlqK3ZnRzMrdURnZG83VjgzWjhrTFNKWUdLRzFRcnRiTXgw?=
 =?utf-8?B?TlAxSVM0ZzhMVUw5Zjc4TTZWNURMbGlUUWZ5RGVmT2J6MXo5T2dSVy9Jb0VR?=
 =?utf-8?B?OWNnRDVLeC9SVFBaVG0vMEduZURGSFB2UDlwWFI2Z0x0SXo1QzJoZk5SbjBF?=
 =?utf-8?B?bkNqa1QyZXo4T3ZCNWg4Q2VyY2l5dHN3ZGoyM0FXZUx1dzQyTDZvVTloS2lJ?=
 =?utf-8?B?Y1FFZkNDOE4vNkFPdU5oSDZ6L2h6LzhGWW8rUVlnNTJsc1hwemtLOEwzZVNS?=
 =?utf-8?B?QlZDVEJKTTE4VHFuOTN6RlUxdE1uMUo2M3dEcVA4SThYNzVBT0NOR2hJc0Zy?=
 =?utf-8?B?VVNQemxOaGdJZWprTGkrM3lpNEpBeE5lZjc5cDhFckVEWVk1b01oMXhLZHI3?=
 =?utf-8?B?em04anZSaVIxUkJ5Q0NRZ0c1TmpicDNCSGZ2NEt4a0VNNDFVbmU2MTJRN2Jo?=
 =?utf-8?B?RUpnWS9RdUdJYThPenE3UlBZNzFIOVpmOGJUbEovb3NZSmFWRlpGR2Zhd3A3?=
 =?utf-8?B?d1FmK2FiemhuanhKQXgzRFFxM1F6Z0NCYjVXd3pCSGtKSm5KV0d4cTNOMUhm?=
 =?utf-8?B?Mm9EczUxU1IxMVVXcStNMHFGMXBucTZJRmVUcWlCRm1hbklEVkdoL2FmR2sr?=
 =?utf-8?B?YllWSmh6bmZ1OXJzY2R0WFpYOUs4amNLNDQvUkdONkh1TDY1NkgwRnNHMHc4?=
 =?utf-8?B?bUdjeXk5enlnY2NnRVpSTXNlK1BOZFI4T1hRcnhCOFRreDN5bW9vS29kSmR3?=
 =?utf-8?B?Q2dsSFpKMUYvRDhQWTErcnlURTNjcDYzU2p1c3U5YzVKemVaT1I3NzBxVnhD?=
 =?utf-8?B?RW9BWVI0TXZXdHpnSUtQNFN1UDUvK1hHaDhTblVoSnd5Ym14cjNJMGFtSWww?=
 =?utf-8?B?THRjc1c2VGYxQTJSeDFKTEJuSW0xakRJMk1qanRZcDJPR3NhejQyaXFUam1V?=
 =?utf-8?B?eXpCMm1wRU9NSkdqeG9mdmNnbENVa0lRR3ErZUZCTXhuOVFqZ0tkN2tPYnBI?=
 =?utf-8?B?dXc5dzVkb3JSMmMxOUU2NkNJNzRDMVVnTktJNkY2RC9ubTZqODd3VDFUdGRp?=
 =?utf-8?B?elVxL0w4RENtM0pFMTBpNzVCN1BlZ1FzNUkrRW8xZ3JIMHdvczZBaU5PYTMr?=
 =?utf-8?B?Wi8xNlM0MTFocEdRWmlZUHlxeHlPNWJzZEFaYzU4bC9FKzlhdmYvdERBWjVW?=
 =?utf-8?B?aVU1OFRQMTQwVnBYOVFYdytRcEl2TC9WV3czcXFBcTMyVUphYWE4SUZlMzdo?=
 =?utf-8?B?aVN0OXpqOEtZMDFMV29XMkhZOUdZRTJNOFJ3bTRPUUZLc1lkR2l4V1pZeCti?=
 =?utf-8?B?eTlocHhxRzZ2QklZdUJaTE1YRjNjdGhFOHYvcVVWQVNiN1A2RjBlelQ0OG40?=
 =?utf-8?B?OGpGUnhkVnlrb3h6c3ZaZEtDd0cwQnRBVytUUXNURUlydHBlUkRtVHkwTUQ2?=
 =?utf-8?B?YnR0NS8rUFZXcUIyZnNsME43RWZZc08xRmgwUy9ReFIyMTUvQ2hvd045U2Vh?=
 =?utf-8?Q?MJJkhxlg3Zhh1xeENmh9j1nHQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19835256-550f-414b-1ef6-08dcbdeb3157
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 12:01:42.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmJweuW4a97z5g/dsqm4rkSm49M5sRnuQIoRSzDbeN+9WluCQX6FpDRynPSvTMkKeAKhYINhbhTZrC0M9gknQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4248

Yi,


On 8/16/2024 5:22 PM, Yi Liu wrote:
> On 2024/8/16 16:29, Vasant Hegde wrote:
>> Yi,
>>
>>
>> On 8/15/2024 7:42 AM, Yi Liu wrote:
>>> On 2024/8/14 22:40, Jason Gunthorpe wrote:
>>>> On Wed, Aug 14, 2024 at 04:19:13PM +0800, Yi Liu wrote:
>>>>
>>>>> /**
>>>>>    * enum iommufd_hw_capabilities
>>>>>    * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
>>>>>    *                               If available, it means the following APIs
>>>>>    *                               are supported:
>>>>>    *
>>>>>    *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
>>>>>    *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
>>>>>    *
>>>>>    */
>>>>> enum iommufd_hw_capabilities {
>>>>>      IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
>>>>> };
>>>>
>>>> I think it would be appropriate to add the flag here
>>>
>>> ok.
>>>
>>>> Is it OK to rely on the PCI config space PASID enable? I see all the
>>>> drivers right now are turning on PASID support during probe if the
>>>> iommu supports it.
>>>
>>> Intel side is not ready yet as it enables pasid when the device is attached
>>> to a non-blocking domain. I've chatted with Baolu, and he will kindly to
>>> enable the pasid cap in the probe_device() op if both iommu and device has
>>> this cap. After that, Intel side should be fine to rely on the PASID enable
>>> bit in the PCI config space.
>>>
>>> How about SMMU and AMD iommu side? @Jason, @Suravee, @Vasant?
>>
>> AMD driver currently discovers capability in probe_device() and enabled it in
>> attach_dev() path.
> 
> I see. So AMD side also has a gap. Is it easy to make it suit Jason's
> suggestion in the above?

We can do that. We can enable ATS, PRI and PASID capability during probe time
and keep it enabled always.

-Vasant



