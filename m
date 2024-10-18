Return-Path: <kvm+bounces-29162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7459A3ABE
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 12:02:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 881F0289A66
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9751201001;
	Fri, 18 Oct 2024 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S+Qi8/9t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDD51D63DF;
	Fri, 18 Oct 2024 10:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729245753; cv=fail; b=NlmN9E4VsvVzCVqAYmtDp5jeFo+0RSLl2anfIOl7ih+wDtKlyF3c1RLgE3tPs9lVfbZUOgbdVo8wkDCXhhTRR3EzpMnK5ihrVIhOioK4tWGmPcRsWBU8aJ6vBehYwAZTtJRybeb7htwWhhUqMgX53MRZlvgTT+CC2s4OD7ux2EQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729245753; c=relaxed/simple;
	bh=U/aUk7kQtEE9ZCzQF7nB4NW/XjuMp92wO6KJRdynOng=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f7Sf5z/HCwMlW0RyX7thYMQ/3CWVqVKFY3Eb2yYSkpUQRsm+7YtkZBkE4F73UGxCxYUfJO2UG7CXex1/WYm9yp3tRR0TdK4TfjJuDlw1t7K9ZfhbRWIIoRVNB8WSYcTLcs5ehG0saLhr2WfRwdWUcqN+rbhKrYQ5XpXC1JlPmzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S+Qi8/9t; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOecK54TnOwldn7dmfEZP2giLiIcGKHrK3iQyVuvuIs0Q00ndgaCzmUNcMprlQ9AxcSgHVEi0gThadjxlD6gZdrKxyf4PPOzgBza+G2ft66P8mOHogNPNmFwMipaE66OIaIdh0jloaM47a/4K3o+E9fuh5i9QHrRknYNpJfuZglSArE0IV4g8jXWwJDv3cmcSkX6x3sFPSjI36UHJwtBhhQ/b8FgyAPFET4AM7o1f7MTmvyqVNx9mDis3P+hjHn/CV9GfL13GnbVsFRV1kxW+LPquUGK34lKFMjmtgNEhG/CyxtEOhw5HM32FQvMn7ObkVcMMYkz5r839lmxI30NoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSYfuA6oAhIMp0ofJteb9kOPPrifcrTuYrtNG2pPgFs=;
 b=DgKFMHKB9/xVmyknXv9aiACDNCmLFhmB+2Pek8eF6ZptGf3nokuUSICoMqdOXC9CaMbKPFeY6nuOyyzd0QsCBiMojr+Ve259YqHd4fpKmpJEAd9wuuWzBZOgizLQndPco8x5w3D05TynhxYUqdDHRBRUDH29I94dfFXQvCOKpQnwSeQBoCcURM2LL/0KWRZOmMEMquCmgJTbSj0de72YXREdvNBMHCTdvgwoN13IU/u8YQEelv2K7PDXrEdfpT8CwrQnd9Rp03dm/6xhbR21NMmFKYHCk60sDYGkrQResmfm9HsMFx69jfDoPTzN0nG3pxp+kNBry6VuU2P1ZpJiAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSYfuA6oAhIMp0ofJteb9kOPPrifcrTuYrtNG2pPgFs=;
 b=S+Qi8/9tB9CjgsvKdcPS1hbpx0FjUh4vhojx/lCTi6XbyIVZ4jWyoOJ2DxX0wAeuvagDyZTTkyfv1aZr8yUusNcxSZgVYdoonJpry9ZnlTX4mjakDbQ8Odw16HEkEma1MlbNrRUiSeA3PJqsnwrnrQ7Sbkv00MVPb09v0pWB6gQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Fri, 18 Oct 2024 10:02:28 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6%4]) with mapi id 15.20.8069.016; Fri, 18 Oct 2024
 10:02:28 +0000
Message-ID: <b79eb294-0c03-47d6-9117-3e76c4b73dad@amd.com>
Date: Fri, 18 Oct 2024 17:02:20 +0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Disable AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
Content-Language: en-US
To: Joao Martins <joao.m.martins@oracle.com>
Cc: pbonzini@redhat.com, seanjc@google.com, david.kaplan@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
 <2d5f2f91-2c3a-4b0e-bacd-aeac6d4da724@oracle.com>
From: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <2d5f2f91-2c3a-4b0e-bacd-aeac6d4da724@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 700840a9-17e2-463c-ad11-08dcef5bf8e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUN4VTBiNnllZU9ZUHlDYWZGWFB1NUYyUjRlVHQwUTlxOU1JbVk0VjBDYmls?=
 =?utf-8?B?aXN5MFVmaDZwUUQyKytjRjNqeUhuK1prVU1qUXBCS1NFaGIxV0FndXZtZVEv?=
 =?utf-8?B?N0djOTkrRFRRdU9WamRHTnNNQTBQVG1vQm5yY3E4TFVhTTRhdE9ZMGVUMzlG?=
 =?utf-8?B?ZUZuYTJ0N011ajlyRitVMXVLeFhRK2U1S0VXMHRsWUNxZU9qcitFUzF5R1JY?=
 =?utf-8?B?SWNhMi9jaFdYdFlBekNvelBpWU91UHdEcnZobytmeU85akcwWGVCU2U1aTQ3?=
 =?utf-8?B?WDczcE9HY3lmTTdXc2NyNjhqSUpibFFFM0M0SCtYWTZCUHlxOCtjZ3YyTTkw?=
 =?utf-8?B?a0NoVlN6UHI1bEVMR3lPV1NncVVxQTYwbVBUemVJUXBXdmdxdmpVSmZtN1V2?=
 =?utf-8?B?Z1RQN1NmSGoxcTVZTVFoRUVOOWIzckdrWEhxYWJRck9ydVN3RU1CVUtzZ2NV?=
 =?utf-8?B?WkhEMXVEV0ZzdXdBY1VXS21iVjNuVjVQdUNSUUczS0xaOVJzaE9jUitXb3NZ?=
 =?utf-8?B?VGpFTXBPY0hJT0Q2RlJyS1ZXSDVjYWh0MURldkd2M3ZyOXRhN0JxY0RiU1ZJ?=
 =?utf-8?B?QmdNaklzRWJsZlJncVRzeFlyM0dyc2FiWE1LK0VFR1BQT3p4b2dWcW9kS2tn?=
 =?utf-8?B?OUNTamZBUmFZNEdZaUhqWk9OUmJvYXBMN21sdk96SW1LZkYzS3hLVkM1bUc1?=
 =?utf-8?B?RlZwdU8wS1dSbkVQWlpWc3JYbUxGVENTaUw2S2R4M2I1b095SnJVYUpMQnFh?=
 =?utf-8?B?ZXl1L201TlcxVDFkb2g0NlhaYkN0bHlvV0NybGdmdEdINmV3U0ZjenRCY0pJ?=
 =?utf-8?B?OTRNZllyWjdJa2p4OFBnd001OFRhVWNiTUtnTk5iNUUvZzlXck5DMzhJMVFj?=
 =?utf-8?B?UmUxTjlVWXhycVhkeUhWSW5hbkVvRTFkc2RmemtQLzZIYmc1ZTZnWGVoVTMv?=
 =?utf-8?B?aWFzaUVHTktaQThkaTZDVEJIWFBpYlAxSGlzS1NkYXJ5QlNmZTdCNHNzSHFo?=
 =?utf-8?B?L0JBYzFDS2xuK3JobElEVmh2clEwamZZNEMwR1hPRUw1YUliSTQ1RFNyTUhS?=
 =?utf-8?B?aFdLeGI2enRjN3JkWjBoemZWMGRhaW1oSjR6RkUySzJHNlcrKzZPdVk3Z2ZU?=
 =?utf-8?B?RWVMZG9FaXp2cVpjc1gxQ1NROGVCMVBTNDl2cGJZU25qeVJHdmdUL0dIcGFs?=
 =?utf-8?B?dXVoRDBnU3ZKVWdXWDdVRnRhcVFnYU4xWVRrNDduYW1NdEdvZHVaYkQzVXIx?=
 =?utf-8?B?eVppeXRDSmJtRHJLUzh5a2RXSUcyMXhFMHN0cHYwcDNRby9MSVNXa21CVTNs?=
 =?utf-8?B?UVJHR0hyOE90M1NKQUxhazlBM0pwN1VsRG9JWTcxZ2F6UmZWVUVNbTZML0V1?=
 =?utf-8?B?Q3hpbnN3bUt1WTlRTXpTUUU5SHRpU295Zmt2MmM1bUJDb3N6UnBuOC9LRHVa?=
 =?utf-8?B?aVpNNlI2MnFEbFFZQUdpM0FrRk1ybGJETWFLRC8zU3k2QS8zRUJjYWltaTlP?=
 =?utf-8?B?bWhUVDJ1aVhuUjBhbm9CcXFZeGFCNm5FUGhIcWNjcXZOeldhRElUM0VDZFpH?=
 =?utf-8?B?NEo1VHpGZGd6U1NKK1NrellLc1VrTHA1cGlQbTdCY3Noby9Yb25tckJSc05u?=
 =?utf-8?B?V1hRVUZMU3VkWGZVdFZ2U2NnRU5IVWlMcFY5V2FST2NYa0orZUI1TkVlUHVq?=
 =?utf-8?B?UjVBaWI1Zyt2VWJVT3hESkk3RjJLQ1dGQTNBQ1duTE1USWpqbmRwOTl0T2lz?=
 =?utf-8?Q?/FEh0C6xssvCHZDQxZOuDlQclwSisIyKBVaC6dK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MllydWdpdG1sdTliRGhpOFN2aUI1a1diODZpV0pGYjNuRGZKekNycmJ5UVA2?=
 =?utf-8?B?V25hdkhQSzl4MDZTaUYyeTBkRks5bFA0bVl6bkhEM3VxNm1vMmdjYW44VGw3?=
 =?utf-8?B?dlBJRVRzY0NzK0g3MVFlOEdmQUFheUdmVXZVUWVzY3A1TWNlRWhTUG5BS0Np?=
 =?utf-8?B?TEtrekNsenc2cWhtT0pFelJlYVduUGwwd3NBM3NjSmRUcHRNQzdNZ2pMTWFl?=
 =?utf-8?B?WTVwUzVINTdMRVBUOFNRM1IxY1pVdjJDaXN1c1ZIRWpJb3FEMjJXcWd5Mmg2?=
 =?utf-8?B?OGhVcGpBSzlDTHR5bndqZFBUL1ZRZHJhNDZIZndkVFIwc1IwV0l5UlA1b2F6?=
 =?utf-8?B?SWJZZk5UYVp3SjhhWnlwT2FPNVBJaGxVa1pEaDN2MXRXUm96MkFaYzU4SE9S?=
 =?utf-8?B?dmxRdkRsUisvQ1NFTWwyeXY1OW9CYTZtZDQxTFZhRXhaVmF2eUhyajhWYmhC?=
 =?utf-8?B?NTR0cmRXNlJaSjZGU254SXBYRUdhVVQydm1VSWkxM2Q5cFBNR1ljZ3JPNHpr?=
 =?utf-8?B?VnF5QVRNWUhWR0w0RFRSc29xQ1l1YVRoNDFJVEtCSUo5S0FYS0FZYmRKN0VE?=
 =?utf-8?B?d3NqQ2VPMjNzY1lOdS8rdjMwVk14aGRGYlg3cDk0eHlHS243UEpVK0EzUmtW?=
 =?utf-8?B?SjJEb0NQd0lrUDgxcmRjd0twZU1waW0rYlNZZ1B3YnMxTUFEUFhPVzJ5VWpi?=
 =?utf-8?B?VEV3UUxTdUg5VHRDRE9mcWl5OVczM0I3ay9TNVJUdy9hbDZ1am5xV3Z2TDBS?=
 =?utf-8?B?Zkc3WGpjL3plS2FMdWI0VFJjSUEwVjhxQUNmMHFacjNCN3dpSjkrWnlnYjFx?=
 =?utf-8?B?Wmk2OXg2Z28wbW5jYmFoNFhDMXArVnpTcUpndTRrczZweW1XNVM5MTIwcjB3?=
 =?utf-8?B?SVlTVzhUMzEveXlDeUtzdkNqRU9DTXBIVlMvZGlzdTg3dlVRbjNvZFhQRjhQ?=
 =?utf-8?B?MXM4R29YWi9rb3BkZVk2c2FKSHN0aXNoTEdrNDFaWGRqL3F0czZ3YmlzWHZQ?=
 =?utf-8?B?a2cxSG9UTitRZHNZWXRCdStVM3g3WGY5RHBuSW1uSFdJN2ZTQWx6UkM4NWc4?=
 =?utf-8?B?bVlDdXozRlY0RkFXNktYZ2pGZFVpVHpsV2NJNTY2cmVuWFI3UG9wL21tbHBP?=
 =?utf-8?B?cERyVzFEajdIcHZISWs1bjJaRnIzTUpyUHBDZCs2UnNVdWREKzlKdk5wc1Qy?=
 =?utf-8?B?RFhQMWwzTm1RdXlHM2xkMTVJQk4zaVlybHVDOFZpWHFPaGFSU29pY045bnJE?=
 =?utf-8?B?UjhndXIyRVFabzJobVYvVGtoWTRDV1gvN2xyaXE1a2NVZlFJMkhNWk9zdE02?=
 =?utf-8?B?Nnk5S2NtVEVZYTlJdmMyR3VXWHJ0dTJ3RmJLVHk5ZDFJRGYzSDNmclNGMlY5?=
 =?utf-8?B?WlBmSjFBcWhOcE4zWHF6cnBKelRndkpwNllVMldBOUNOYUpNaFRZYldjdnNN?=
 =?utf-8?B?b3hPeGRCUjBQU21vWGNWSldYRXRzanJ5Z2svVGNyUGlWb0srYVlyZHdtSXFl?=
 =?utf-8?B?cG5VMzM1Zk9ZN2JndzZnb2lsUkIvRUVxS1U0YVgweis2MHZNV1c4WGE4UmZQ?=
 =?utf-8?B?ZlVxTjdnZFYvQzR2YXFHK3lVZnhienAvV2M0OExna1pORHBsYjlwakplMHQ2?=
 =?utf-8?B?eERta0J0c3Nwd3hFR1NobzBHTTVrQWFZYnN4dVhWNWZaY0VkVzNYYWpCeWdq?=
 =?utf-8?B?QzU0QnZmVFUwa3NjaUxZU3Ixc2w3WkZIZk9jdWJVMnpsMFRneTlyalQyUmNF?=
 =?utf-8?B?OU45RktVeTh3VForSG1iajNicWtIa0hrdUY1YWVTYkd6d2pwN2E2UjNrS2o0?=
 =?utf-8?B?bUVYL01vWkh4c25XRGt4UlhOU3NnVmM0YkR4ejA2UkFTR2JsVWt2ZzFrU2w2?=
 =?utf-8?B?MGRiZW9oL05CT3pPWWVxcTM5TUpmUERpRmZFTHg3S1V2MkY4c0NVSlZZbUsz?=
 =?utf-8?B?YTN6NThha2NhR2FtSWxDYUx1d2RNQ0pWUUFkYWpMek5NL1pLbTVPTjZGeFdJ?=
 =?utf-8?B?ckFPUUtwNXlFOU1LRmVKUkM3eE0ydkhZbElrck1ES05Gdldmd05Idk5YUXRk?=
 =?utf-8?B?Snp6SUFWUVZDMWJEU1FMWGtmdWJKeFdyTEpFc2JaaytVbzViWXdGREJGaWoz?=
 =?utf-8?Q?t66/gQHDN8gX874qMlS0UeW5A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 700840a9-17e2-463c-ad11-08dcef5bf8e1
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 10:02:27.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mg8ukpbCvZGmTPv8F1qW2p4221t9V4M+6vr/MPfVYVy8oOENWjLWC9Ml4iK8i8rdCmHyKYq3dr112kCQZzXvtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128

Hi Joao,

On 10/1/2024 6:04 PM, Joao Martins wrote:
> On 30/09/2024 06:50, Suravee Suthikulpanit wrote:
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index dd4682857c12..921b6de80e24 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -448,6 +448,7 @@
>>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
>>   #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
>>   #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>> +#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Write to in-use hypervisor-owned pages allowed */
>>   
>>   /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>>   #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 4b74ea91f4e6..42f2caf17d6a 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -1199,6 +1199,12 @@ bool avic_hardware_setup(void)
>>   		return false;
>>   	}
>>   
>> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
>> +	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
>> +		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system");
>> +		return false;
>> +	}
>> +
> 
> Wouldn't be better to make this is APICv inhibit to allow non-SNP guests to work
> with AVIC?

I was considering the APICV inhibit as well, and decided to go with 
disabling AVIC since it does not require additional 
APICV_INHIBIT_REASON_XXX flag, and we can simply disable AVIC support 
during kvm-amd driver initialization.

After rethink this, it is better to use per-VM APICv inhibition instead 
since certain AVIC data structures will be needed for secure AVIC 
support in the future.

I will update this patch and send out V2.

Thanks,
Suravee

