Return-Path: <kvm+bounces-40447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FBEA573A4
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A53AA1899156
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFB0257AF8;
	Fri,  7 Mar 2025 21:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uFlFSNS1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3781B0416;
	Fri,  7 Mar 2025 21:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383028; cv=fail; b=EAWiD0cE5qqZfby7b0+itG0bf9LyTY/ca4PAqNn7uHwGyYRk0/psFalhjVYqiNC1sXkU7joMRMt1y6sM2OWxuESRsztIoP1P3ZTSHPa072j62BA+v1MgNSg/S1ZbgtEQfg7pF5huN5m5Q8+1np1XfTTeJwo1shiIjwEondWIDJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383028; c=relaxed/simple;
	bh=nPTY//vlUqDhugVLD3xb5ttN/UkTieCUUEdNiQ0Jyj8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S0l8i6o2jhdTISI/rgL4AHxrmiAoDfG8fBO9tXVXEvd1w/sNG8InzQGL3OFA6hNoTX6FXFgxfsVeX/6Tfx96EoKGqwmlB3G7VxVOrqb4xXWIw5Wb9hUPtSa9fURCFluVsk53srn+vDDhRtnbbscG1warjre0mrRQmUs4a/DdZ4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uFlFSNS1; arc=fail smtp.client-ip=40.107.93.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nU0imzbppKVTuk2UPkqJLP6q9vTDBHsewMzrE+NYngt9+Mfw6IUGCqkdXbU6VGSCmbKoT4VscucqLy7EptNlEQVVF/Cdww+29fPNFQ+Ol/Vp5CruX76ZbopN+VTxOuv1g+sIVz9zNihZt6e8iS47CGhR8V7SHhM768LKdRcYK5OsZerJvExUupNQiQkP/Hh53Z+EcJ2h7zS54LRNJxb34jmCeZZzUkBpvVSBPBWVO0MrPS2aiiisN/qlSRdKp5is4tDNHDo2bjHUuOpVaJJiGHA9/TTbktv1ebBYuGE9jJgR/QJazK47ry6zj7rY0WmTZFPAsBA1vopBIrWN3oGNUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXhmtLJ8paemzrY9kDI70jq+o8ag7Mtbud0fQ7EtaMY=;
 b=Bco+u6GRnr/nqmHsE7FXvL+LjQSOqjaMRNrUQXvdykLBwpTjzvM1gS0CXERjgd4BRrWZ9iPidEqcNN1U0OQS3vYNQWHtAAmMtSIS5Z1tgcGrna2F8TJO+rhbQ9tMQTLmBzzlwcg8etqRLeSNaIw+4H5Ux0OiQYbR9/2DxMNS00JigfmsVr6e9q8gzl5Qrok4xxPQW8jt5H4BPQ2oTC6qy+G5H+dti6wrk/XKEji9jAv+0lJlddZoqB7b4L8YLAde7aJuML0LGU0q3sAPD7NgZ1+Tyf5l4qjf2hRrd3pbv9DDFtdcpO8irU5zmvTxtaLUtzSuzTvT7rLQ8gWnWdVnug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXhmtLJ8paemzrY9kDI70jq+o8ag7Mtbud0fQ7EtaMY=;
 b=uFlFSNS1Gy9aMvILJxsBE6ccKTyNBEMDyN+jTW+ph2wJL+h0Tn2VGovphJDE+7lYlodPzJNY6lt3AiFuFg2H4UaIgILySbTB0ch+YLBxdpliN/rN7nfN25wWiXwjwlqZnCjcDzQFcBNpcGDrhPxAVU+aRG1uav0IqHOKLzWNy5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Fri, 7 Mar
 2025 21:30:24 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 21:30:24 +0000
Message-ID: <dc97bb4b-e36a-8799-7317-660b473cc7b5@amd.com>
Date: Fri, 7 Mar 2025 15:30:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 3/8] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <4a94e1d47b5ac270d47b87d7b38be0aca11779a6.1741300901.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <4a94e1d47b5ac270d47b87d7b38be0aca11779a6.1741300901.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0148.namprd11.prod.outlook.com
 (2603:10b6:806:131::33) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: b6075f7b-a677-42e6-e654-08dd5dbf45b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bU11NFdSTWZKcUljSHZUbUd3T2piZElSb2FXUkhuMDRMdms2bDBXUm5ybS9i?=
 =?utf-8?B?UE5mcFVuYkMzR3hvZTVpemM3cXFCN3UxTzA5RkwwYWZaSENObkZZREt3U0xS?=
 =?utf-8?B?bGMyQldEQ09sZmovZVpZbzRLTlIzbE1KdGoxRTJ6MTcwQjg0cWpNbXdLdVlp?=
 =?utf-8?B?MktRaXQrYlhvMWdMYlhiL1NOdjAvODg0VkxSUlZNVTRqVXBsUHBMRW1BZXpu?=
 =?utf-8?B?RlZrNGpRY2dyMU1DdjZIMWFHOEptMllGKzV1b0lyK2xZQnNRUnFJMDN6Tms1?=
 =?utf-8?B?WU5xcUhRYVpNUmlOcjc4QjE3cTVNWnhJd294c2FES0pKejBtdkZEd0h4ZmtC?=
 =?utf-8?B?bVhQUGwxRjZhNkpZWEVnMnRPS0pkdnE5RWtzSzdtY3pZaThXcGMyanB5ekJO?=
 =?utf-8?B?Z3o2djlmRFFPK3J0ZGxhQkhnclhVVlBVcURSQlNhWklZajZGNjRHZFNEdytN?=
 =?utf-8?B?ZFhyZlFEL3JXcmxRZ1Z5YXQvU0RRZWpoVHNxNVNBUG1FRWlhTDZHVmdoWGlz?=
 =?utf-8?B?d3c0VHJtS001L003bHlXTE5KRVlpMzBadkdYUTg1VkZDQ01POElNcHdTOHM0?=
 =?utf-8?B?VmJDeDZZNWNONlZVMmxTNkt4Y3BuNURlQURxbndVK2dxeHhNc3g4dDVWQWU4?=
 =?utf-8?B?NnR1TThGdGlPK2tqSGhmSG1zbzBTMHU1OCtnbHI0OEpMQ3dDb2NsVER1dTlC?=
 =?utf-8?B?QnVPaGdPN3hBcW1DcVRpdVcrdlpPYm5ncjU4T2pNSlh0S1JiUHllbEZsQlNV?=
 =?utf-8?B?WVhidEFRRFlaYmNkNW1FVDBNZVdlRm9WZ21rZm0xK0d6QWVJNlVyU3hLUWpY?=
 =?utf-8?B?V2ZCN0pKNDZweDRmVFJWUFdpcW8xdnJBck5xYnFDcUlqZ2NzVXB3aU4rMCsw?=
 =?utf-8?B?Y09ITXFOY2x3ZHg3d2xpMEhSbWJLVFc2aEcwajRWeW00a21zT0R5cEFGVzZP?=
 =?utf-8?B?QVFQakJ6bFBxMjBPVWZxY1FZTXFCTkZQTFcxcDBURW44YmU2L0QyYmYwU2FW?=
 =?utf-8?B?QTNkdUVnbUN4eHRMT1Nwb0dlRXFTR0VBVlVySEJDMElUMlhmby9iTGxsTHdq?=
 =?utf-8?B?ZG55VFd3L1hrTWZJd3duVnQwVERVRTdoeUxZNEUwTnhxV245a01WdUU2WmtW?=
 =?utf-8?B?SEhXdmZERktuVnRZTWt6d3VPOUVBeHlNWUl3c05GNk80T3ZaZTRIUDBsNzNv?=
 =?utf-8?B?eU5raHZlYTNzUytVdGZRSkdJQ1hhRGhjMzlrRSt0OWhja3hiRENUS2hGQVhp?=
 =?utf-8?B?NVJFcXoyLy94dFVqN3N6cHM0ZDFSWUhIenRDR25MYmorMVA3TVZLdHFwUUdF?=
 =?utf-8?B?QWloK2xWTmlCN00xVXFwWHpPN055YW9jSlZsOGZzZFJaQzF3eHVVYU5QWW0x?=
 =?utf-8?B?bWJlbm92a3FCc3pLQ1VCZGhlZlhVc1ZOSlhLYmxTYzVpVksxRGhHcS92U2Q2?=
 =?utf-8?B?Q2s3VTZJM04wUE8xWUs2ZEl0VEZQZFl2U3hVWlZ1Z1pidW1DTUt0RXRsMlZG?=
 =?utf-8?B?Vmdockg1ZytQZDZaaHZSVnp6enpmbU1YaFRZVzZESzhIYXl6djQwMWxrekpE?=
 =?utf-8?B?cEdObkFWMmxsMnhReVF2RmJ1bXFmN0dxVGNlMG1iVDkwUXMyUC9hZW1heEFL?=
 =?utf-8?B?V1ZxS2xGWjU2ZVpTcFVHRnVNU3FzeGphck9xTFlNR3lkVUoxMFlaamlZZnFO?=
 =?utf-8?B?RkhudU5ZYnNwUGJzdmV5aDhzT3dONGJNWjYyZXlrUlFLQTFCcTJEeXRvdzlS?=
 =?utf-8?B?aFhZbXFqa0E4Z1hWTkYrakRNZVBDNW1RN29lWHRDYm5FSFVaeTg3WVNSYUlx?=
 =?utf-8?B?bXFmcElwNzA1Q1Vxb2U5d2ZGM2JQRmhQTW1WdngvdHI4ZFRoMEdISTB2K2M0?=
 =?utf-8?B?eWs1a3ZZQWZKWDc4N1JMWmJJYVVCMk1rcDAzSHNHYjZrMGU2a1FORmZBbyts?=
 =?utf-8?Q?kdfD5GMC758=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWJrcmZJQ1ZsZnlCUUczYVc0NnZQeWFlZ0JZNkRDS1RhQ0paY2dvWkszZGVo?=
 =?utf-8?B?aGtpUEl2Y0JqZko5S0ZXeVBHQ0ZkOWZ0QUE2a3JLYW5hS0MxaWpaUXBzb2tz?=
 =?utf-8?B?QjlQcWhoTTBsMkZZeG5tUm1zdFVWZkwxQTlqczZOamhtbk5jbEY1ODFHWTc4?=
 =?utf-8?B?M1l6N1lHOGxwNVNVaENVelFqMldoZ0o1aUdpQmdYbW9EWjcwZEo1VnJPYnZi?=
 =?utf-8?B?NmVLK2l6Q3JrNlZmcVhlTWh0L3BIeUorSmpRUjc5dWJSWkxzYmErd093akdt?=
 =?utf-8?B?ZDViOExQOS9MOTRrcmFBajZod0k1Y2cyQnEwTWRWTWIzWDZmQ3R4UDZaeTE0?=
 =?utf-8?B?MGZBUThEeXZDTVhxRFk0RnZLRS8vaFFlSHZ2aHFXQzdVbGIxVHZEKysvR0ps?=
 =?utf-8?B?a29WdVlGNmtXRlprdHYyK1d5VHpGRmt1NTFWYityQTRaSEtmV1lHaVA3cHM1?=
 =?utf-8?B?cTdraEpqRERMMVRKVEdYaXVLUWJzb29rUnhycGYzeUhRVk5DcXZJZlk1NGFB?=
 =?utf-8?B?RUJFbFhEV3doaWczVWZibHkzZ2gvblY4NTR6WU9UUnlQUWs0ZklaamVLdHlI?=
 =?utf-8?B?WUcwQmhsWnBaSHgyRVIxaWJuakRidUFlSWtVZkp5ZEV5WndqNXppU2JUZ2gy?=
 =?utf-8?B?eGlzc1A2SVUzdGZNUEx4ZDRPc2toeU9FMldYV0luUCtNYzJReDc1YXQ5cEtF?=
 =?utf-8?B?Rmx0MjhjdmpseXVuQU0zdFp6OEc0QlJXV3ZEVW5wbGhNbG5XSGJ5cGw2V2lX?=
 =?utf-8?B?RkhTaXRTRGdtWXFvRTd5bDlWSWpRb1VGYjdtNkJVUjhxOTdKTkhmUHR3RkJP?=
 =?utf-8?B?cmVnQ0dCR3FOQlNiNDFDQm1JTGJXQXp5RjFuK2tQU3hKb0VhV0pvcTdhVGFI?=
 =?utf-8?B?dGNXKzk0UnAycWdXZ3NzTERFT3lkc2dYbk42NWtPdEYvVXRPZ2RNNDlta0w1?=
 =?utf-8?B?WTZ0VVQ2ekpMSzhvVzl2Qjl1T0NmOVhGWFI1U0xwRmpMbWI0ZTBiWm1FMVB3?=
 =?utf-8?B?U0VkYnFkSlllcVJiekNUVDcwcFFabUJQUG5qZkFwZjNhNkIxbzloWEk1cFZ6?=
 =?utf-8?B?R2tPWXlMMWk2K09uYWNWSDRWWWpKMlo0RXY2NzJrSFU5TTYrSzNKcHFjT3A5?=
 =?utf-8?B?UlBlWGdxTUJMSldnUFZIRklFRjRscVp6c2duZEVZQThzeFB6U2tPK0hlRE1q?=
 =?utf-8?B?WnZpNy9RV0NaR1VQWUJIYVkyeWNrOGhxUDBQdEhwVzNSSjJ4ZFdIVXE4UklP?=
 =?utf-8?B?aWFnNDdVamtLREloUk9wdmR1bFhwUEFwNzR0WGtPYW1UbHAyam9Rd2lQeHUw?=
 =?utf-8?B?dVRVc2hEWldCOUVrVjJSS0JaZFJBUHFGN05hL0JMT3k1N1VTZ2FVNWxDVyto?=
 =?utf-8?B?bmhLZ2krSmUvQS9KRmNoeUt5WndRSHp6T3h4bE8zQ0RBMCtaY3JxWUY3TnpX?=
 =?utf-8?B?RXpSSXJpZmVncjN3VVkydkZOVVA5cXB1VVVtcUhBRktvdis5NER2Z1o0ZXhV?=
 =?utf-8?B?bUlZWXRRanlYOTRMVnk2YnVvRXZmblIzRkNmSktHZTZjV3FDSVg0K21HTzZD?=
 =?utf-8?B?N0gwejVORDFna0hEN29pazJCWjlEUnVhVVZtbzNTTkhqNFgweXVqOXlVNWo0?=
 =?utf-8?B?ejM5Y0x4UFJyMDlYZUlhaHF4ZXVWR0FNaDIrZlpZY3NZT2dleWp2TVpDRk54?=
 =?utf-8?B?bHhpb1pub2ttdGlCUWo1ZCtnOTRnVysrOGpBUDF5K05xejFJbWlTd0JBelZ3?=
 =?utf-8?B?cEZJZGhUS2Uvb1pCOFYxUmFTVlJBbXpTWXZLTC8yL3NHTmljeEVYUnEyN1FQ?=
 =?utf-8?B?akxRTU1UbVJMVXgxSnpwOWlYZG52WUhLbUFOMklMZFM3cTh3ZFVzWU5Na3Fn?=
 =?utf-8?B?LzlQdktkcmI3clpPaWtDMnZ5amhiVEx2bjNTUS8xOWRRdXVwYXJRUEJKUHlj?=
 =?utf-8?B?Ti8rb2UrQnVwMXkrMUY5UGxJUlJGRVFlWHk4czYxZjE1eGV6MVNEQTE2ZFJz?=
 =?utf-8?B?NmhNZVdBaGRuZzJPS3ZLaEtTSURMMWNWdVo0ZTErUm5DSWlzaHdQSHVnd1l4?=
 =?utf-8?B?aUNyZWRTQmIxV2hxWVhTQ0RVdjc1ZzNVdUxNNVo1RDJNanNaaXppZHN1TFoy?=
 =?utf-8?Q?VHe+NkhWwKDrID9M4F+uVYV3h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6075f7b-a677-42e6-e654-08dd5dbf45b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:30:24.7808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQmi5Y3/X59a0yELxcYyf5BlGZy7GZwQK9xZRNvYCIWLZRu+otLcU2gBSfuQIWbcKLBeQaiio8psNcliMp3hBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314

On 3/6/25 17:10, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Modify the behavior of implicit SEV initialization in some of the
> SEV ioctls to do both SEV initialization and shutdown and add
> implicit SNP initialization and shutdown to some of the SNP ioctls
> so that the change of SEV/SNP platform initialization not being
> done during PSP driver probe time does not break userspace tools
> such as sevtool, etc.
> 
> Prior to this patch, SEV has always been initialized before these
> ioctls as SEV initialization is done as part of PSP module probe,
> but now with SEV initialization being moved to KVM module load instead
> of PSP driver probe, the implied SEV INIT actually makes sense and gets
> used and additionally to maintain SEV platform state consistency
> before and after the ioctl SEV shutdown needs to be done after the
> firmware call.
> 
> It is important to do SEV Shutdown here with the SEV/SNP initialization
> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
> followed with SEV Shutdown will cause SEV to remain in INIT state and
> then a future SNP INIT in KVM module load will fail.
> 
> Also ensure that for these SEV ioctls both implicit SNP and SEV INIT is
> done followed by both SEV and SNP shutdown as RMP table must be
> initialized before calling SEV INIT if SNP host support is enabled.
> 
> Similarly, prior to this patch, SNP has always been initialized before
> these ioctls as SNP initialization is done as part of PSP module probe,
> therefore, to keep a consistent behavior, SNP init needs to be done
> here implicitly as part of these ioctls followed with SNP shutdown
> before returning from the ioctl to maintain the consistent platform
> state before and after the ioctl.
> 
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 142 +++++++++++++++++++++++++++++------
>  1 file changed, 119 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ccd7cc4b36d1..5bd3df377370 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,8 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1402,6 +1404,37 @@ static int sev_get_platform_state(int *state, int *error)
>  	return rc;
>  }
>  
> +static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
> +{
> +	struct sev_platform_init_args init_args = {0};
> +	int rc;
> +
> +	rc = _sev_platform_init_locked(&init_args);
> +	if (rc) {
> +		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +		return rc;
> +	}
> +
> +	*shutdown_required = true;
> +
> +	return 0;
> +}
> +
> +static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
> +{
> +	int error, rc;
> +
> +	rc = __sev_snp_init_locked(&error);
> +	if (rc) {
> +		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> +		return rc;
> +	}
> +
> +	*shutdown_required = true;
> +
> +	return 0;
> +}
> +
>  static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
>  {
>  	int state, rc;
> @@ -1454,24 +1487,31 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> +	bool shutdown_required = false;
>  	int rc;
>  
>  	if (!writable)
>  		return -EPERM;
>  
>  	if (sev->state == SEV_STATE_UNINIT) {
> -		rc = __sev_platform_init_locked(&argp->error);
> +		rc = sev_move_to_init_state(argp, &shutdown_required);
>  		if (rc)
>  			return rc;
>  	}
>  
> -	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +
> +	if (shutdown_required)
> +		__sev_firmware_shutdown(sev, false);
> +
> +	return rc;
>  }
>  
>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_csr input;
> +	bool shutdown_required = false;
>  	struct sev_data_pek_csr data;
>  	void __user *input_address;
>  	void *blob = NULL;
> @@ -1503,7 +1543,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  
>  cmd:
>  	if (sev->state == SEV_STATE_UNINIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> +		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
>  			goto e_free_blob;
>  	}
> @@ -1524,6 +1564,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  e_free_blob:
> +	if (shutdown_required)
> +		__sev_firmware_shutdown(sev, false);
> +
>  	kfree(blob);
>  	return ret;
>  }
> @@ -1743,6 +1786,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_cert_import input;
>  	struct sev_data_pek_cert_import data;
> +	bool shutdown_required = false;
>  	void *pek_blob, *oca_blob;
>  	int ret;
>  
> @@ -1773,7 +1817,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  
>  	/* If platform is not in INIT state then transition it to INIT */
>  	if (sev->state != SEV_STATE_INIT) {
> -		ret = __sev_platform_init_locked(&argp->error);
> +		ret = sev_move_to_init_state(argp, &shutdown_required);
>  		if (ret)
>  			goto e_free_oca;
>  	}
> @@ -1781,6 +1825,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>  
>  e_free_oca:
> +	if (shutdown_required)
> +		__sev_firmware_shutdown(sev, false);
> +
>  	kfree(oca_blob);
>  e_free_pek:
>  	kfree(pek_blob);
> @@ -1897,18 +1944,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_data_pdh_cert_export data;
>  	void __user *input_cert_chain_address;
>  	void __user *input_pdh_cert_address;
> +	bool shutdown_required = false;
>  	int ret;
>  
> -	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->state != SEV_STATE_INIT) {
> -		if (!writable)
> -			return -EPERM;
> -
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>  		return -EFAULT;
>  
> @@ -1948,6 +1986,17 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	data.cert_chain_len = input.cert_chain_len;
>  
>  cmd:
> +	/* If platform is not in INIT state then transition it to INIT. */
> +	if (sev->state != SEV_STATE_INIT) {
> +		if (!writable) {
> +			ret = -EPERM;
> +			goto e_free_cert;
> +		}
> +		ret = sev_move_to_init_state(argp, &shutdown_required);
> +		if (ret)
> +			goto e_free_cert;
> +	}
> +
>  	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>  
>  	/* If we query the length, FW responded with expected data. */
> @@ -1974,6 +2023,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  e_free_cert:
> +	if (shutdown_required)
> +		__sev_firmware_shutdown(sev, false);
> +
>  	kfree(cert_blob);
>  e_free_pdh:
>  	kfree(pdh_blob);
> @@ -1983,12 +2035,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> +	bool shutdown_required = false;
>  	struct sev_data_snp_addr buf;
>  	struct page *status_page;
> +	int ret, error;
>  	void *data;
> -	int ret;
>  
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>  		return -EINVAL;
>  
>  	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> @@ -1997,6 +2050,12 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  
>  	data = page_address(status_page);
>  
> +	if (!sev->snp_initialized) {
> +		ret = snp_move_to_init_state(argp, &shutdown_required);
> +		if (ret)
> +			goto cleanup;
> +	}
> +
>  	/*
>  	 * Firmware expects status page to be in firmware-owned state, otherwise
>  	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
> @@ -2025,6 +2084,9 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  		ret = -EFAULT;
>  
>  cleanup:
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
>  	__free_pages(status_page, 0);
>  	return ret;
>  }
> @@ -2033,21 +2095,33 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_data_snp_commit buf;
> +	bool shutdown_required = false;
> +	int ret, error;
>  
> -	if (!sev->snp_initialized)
> -		return -EINVAL;
> +	if (!sev->snp_initialized) {
> +		ret = snp_move_to_init_state(argp, &shutdown_required);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	buf.len = sizeof(buf);
>  
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
> +	return ret;
>  }
>  
>  static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_config config;
> +	bool shutdown_required = false;
> +	int ret, error;
>  
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>  		return -EINVAL;
>  
>  	if (!writable)
> @@ -2056,17 +2130,29 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>  		return -EFAULT;
>  
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +	if (!sev->snp_initialized) {
> +		ret = snp_move_to_init_state(argp, &shutdown_required);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
> +	return ret;
>  }
>  
>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_vlek_load input;
> +	bool shutdown_required = false;
> +	int ret, error;
>  	void *blob;
> -	int ret;
>  
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>  		return -EINVAL;
>  
>  	if (!writable)
> @@ -2085,8 +2171,18 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  
>  	input.vlek_wrapped_address = __psp_pa(blob);
>  
> +	if (!sev->snp_initialized) {
> +		ret = snp_move_to_init_state(argp, &shutdown_required);
> +		if (ret)
> +			goto cleanup;
> +	}
> +
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>  
> +	if (shutdown_required)
> +		__sev_snp_shutdown_locked(&error, false);
> +
> +cleanup:
>  	kfree(blob);
>  
>  	return ret;

