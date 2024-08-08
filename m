Return-Path: <kvm+bounces-23647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5918B94C40E
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 20:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBFB21F261C6
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 18:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A90146A73;
	Thu,  8 Aug 2024 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qSd5i5VD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2839033F7;
	Thu,  8 Aug 2024 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723140252; cv=fail; b=c02T6PZsL5UOoaA6s9pz3OjL7tSXOtls6FvmaHx1eH6TjjWLYQ+yGNg50d9TiExttooAsCcIuNz57JIwFqXAcvcr6pcSxwwS9oSRLEbpFW187G142qvu4hEItOHYW35IiNu943bQvqXh4USQq1o9FFKbNd78qNFXq3IM9yrAjsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723140252; c=relaxed/simple;
	bh=jQ3fKatCzq+uPRe0HREy5tqQoAW7E+za+3pluq/xP5E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R4tG6rCEjR9zJZ8YBDx8DkGGML20MmZhYcydE1PoOUcf5Vv0MxgwqHrpikgnWRKrQAOPZfZE1go5JuYlNPK/Qe/dr7j3b50t1zcxfu6Edw+A+crFfZARQ7dmvZbRDO7GXvCUD8KvPSP4qfBSJu9Wni8zVL80h3fxOCfNLAjYHT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qSd5i5VD; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hLkHI31lpN8OwOXtntnI2xRNrRXgFYPB4p4AQMFfYPOs0muH/582XV22Q2S8dd7bElEo8CK8SCvj3ea9t0d9sVfHqXC8e0SZSwdgt9cAYFMY1kk1LwvbI/cRQ4eftPA+FZscJuogTUgNy/JkrksmEN/lHi0jW/+fgxo6L4/mh8ySKnyjmmJK+odLz/hem2x4MzcgdP8bVFTUDIGc77zJy/mHfGAcobj3nBbZ20bbVTW++hmIt5RxTW1s+Cbh0U436ENUyjQAPc3MpWra4+OIrFNhhxueZ/ujo+b6UoU6uQizp9g87PZjmTV5tdydfPio1pVjr4QN7Pe5Zc1zwv7vaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdAofM7MDhUZ88cazV58UNzk4XAlj1fswhTBg2wBm7c=;
 b=Y9HMPWb2L1e3/IZjLhKPRo1sbW6LCZUJjg2c8UilJx6Llg12ZRyj5IwpPFA5B4yo26MrZZcBUSxGBzX8maAb13jv5o/6G88wmaBAtPmfXGjYjBI1UFz77r10pgWIskJzz0M9VgS5WkFEoFRPlihVGgtkZ1vB5LZVBm65RV6G6N4SZAa2AewH5xKW1RFH5mpI1opb1AxbBfdjOGvgwOrDOQqrekPNtOC+uXRBAJpsdWwB1TttWIhfJ08FbTtOF1c2QV0FNAWX5ZLnzdaCJsejuqyXKceg/l6jdCJu8ilcLExmbhTBkhuNe07ulbwBRjyDHQg497smMfL0LUExex++vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdAofM7MDhUZ88cazV58UNzk4XAlj1fswhTBg2wBm7c=;
 b=qSd5i5VDs6g72mzS+giJTYq/qzBp4KmjmHIkJai7S02JUvVDgcwMVEeqhjyQ9qT3mP9hFRngaIdLbEdVuQhfS2PzZ2QXkniX+R06r/m9ii8P+Rt0s0VSZ8OZ1uM5gzoQop1GIGtPirfDgqD4p/UbPtt7pvJMMmDamiDfvR4vT3aR6MbhDP9VIemC2u1HBRX1FfZJJDY33HVEsUkEb6hDJ7nI06oYYrBcfbxP/A8OTnkOOkVV9RB6DxGvDyYHcMfaOy3UWM9uqAdDWF0xOgNqLDmXi2l+DtO+JyViRLERXFdPjxn+KfYN+108I+ZXyOpUM8VFf+y9OlY6oNVTWwerng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by CY8PR12MB8068.namprd12.prod.outlook.com (2603:10b6:930:75::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Thu, 8 Aug
 2024 18:04:06 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%7]) with mapi id 15.20.7849.008; Thu, 8 Aug 2024
 18:04:06 +0000
Message-ID: <9da68127-23d8-48a4-b56f-a3ff54fa213c@nvidia.com>
Date: Thu, 8 Aug 2024 20:04:01 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token
 correctly
To: Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc: lingshan.zhu@intel.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240808082044.11356-1-jasowang@redhat.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20240808082044.11356-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0258.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::12) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|CY8PR12MB8068:EE_
X-MS-Office365-Filtering-Correlation-Id: 466513d3-cba6-4943-e254-08dcb7d47e8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alMyVEpDc0tUdEtIdy9nRHR2em1nQ3p3ajRyaEVDK2lDTE4yOStob2VadXcw?=
 =?utf-8?B?MXlEckpRWFljYjVBQlJkYUNzWkFER1cycnFSRTZvdjNmMTdoTzlJVnhBV1RD?=
 =?utf-8?B?QzlTL3hlREoxRW1MUkZISXlYUFE0a0NqaXpCWXQxem9KUlNDRVBpaFQ2MEo2?=
 =?utf-8?B?NDRGdnMyb0Vrbi9jWGNTZHBWL2JqT3FnUXlTTEM5NklwWTNEVkNFcy9nTGdP?=
 =?utf-8?B?QUsrL3RabnIxTG14ZldDNnpvSnJoQjRNNDdEeDRvVk80K29qQnpxTkhyUzVo?=
 =?utf-8?B?ME0vUzFrSzgxNXorZG8zQ1dWNXB3QnlhTlBHS0xlSllUYmdRVjd0MG16cFBh?=
 =?utf-8?B?elIzSWpWRVJrNVpKSkRwYjdwMmF1cTRCV2NpWnZqU1dCblJydmNjdjAvQkJx?=
 =?utf-8?B?S2JnQ1JpNnhaa1Z6eWQ0RXgxbU1GTDZBSWlnMHpXODlTRGo3ME5VcHRDdUJa?=
 =?utf-8?B?L0NIblp2bUJ1TGdUL1FzeTdBSk50dXg0bmExK0ZpTEgzb2RQNzJycWtjTnFU?=
 =?utf-8?B?R0Z0UkVSQnlCb0VLbU9lQmVKN3hLcnZRaW1uT3BYR0tjUys2aGlTM0c2YkNv?=
 =?utf-8?B?ZEdPSDZBMk96NDB1ZXNENTc4RHdDUTFjNjl4V0JkVDZUMXRVd1kvQWdFZEdG?=
 =?utf-8?B?amdMemxSbVdmdzNOdmFWSDlPTVUvMHlPSVk1TkFFbDRGOGxEazhVU3RaSjVy?=
 =?utf-8?B?WlhQdzRLVjBUdzFDOVBNWVp0WDVrMzlKT2p2MlhZMzBHVEJlSnlSNVFCaGVL?=
 =?utf-8?B?ZTFyWDR4VFhmcmJITkNYM3JPcU1BdlhkTG0xelFuZkJkKzlCdDh0OXU5S3Rp?=
 =?utf-8?B?dEVZUCtmMzRhZFJrejZpa2NmOG9tLy9yOXlrcjBmZkJheTN5VEN3c2xTbVZi?=
 =?utf-8?B?MXFUcTBtb3ZJaDY2cGtVK0J0cjZKRytyOFZacGxLbUUrbHhpZHgyT1FvMHFa?=
 =?utf-8?B?cGpzVVoxb0lrcVVId3I4S0RNRlN6VEJGNDFhTWI1dHp2bUtFZHlsUEVTT1BW?=
 =?utf-8?B?YmEydk9oV1owdHZQUy84ZVo4aWNCQ3kxSWgrbGszVDNSNVNVNFZFbHNiTk1E?=
 =?utf-8?B?NStaN3lGMnJRc2hCMHFjOVpFeU1peXY0Tm5xcFVSSzRjR2o4aFhNVkpzZDQ1?=
 =?utf-8?B?c1NOQmR1cFVURmxvY21odTV6SUErK1BPRzZkTnJCTUd1cjBkTEhOL0t5WjBk?=
 =?utf-8?B?eVA0S1ovWUx2eVdHKzFIWjJ5eFY3OFhsd1Z1a1JoTUFzS2IxTmtNbkx0Nmg4?=
 =?utf-8?B?ZkF1VmNTWkZDVUtjUkVCZWhzNFMzYWRhZk1NZzU4RWFXMlJGbnd1Y1F0b1U4?=
 =?utf-8?B?UDR1aERuUkpxcVZnN21vc3ZlSzZ6eVc1d0oyaUVySEpIRnJQQmEzcWJHMVRW?=
 =?utf-8?B?dSthWFQxeS92bU9lcDZ3all4YTJOdmxnRDlQZG5ydE40eHBLeHhxaUtEL1oy?=
 =?utf-8?B?SllqeVV5bEpoR0VqczZNS3ZMOWxOYmd1NGszcC8yZGRoZjAzc0hMV3crZkdn?=
 =?utf-8?B?Nlp3dUlxS0FMeU1vMndmb2k2aXdxTVZiSU9RdHRLUmYza0s2Vkk2V3BubUFq?=
 =?utf-8?B?M3dQSnNwNkFoU0lPNHpqVTN5NVlwTmJNczZ1NmgrSzF4cllJdEFhN2NLd3N5?=
 =?utf-8?B?YmtYMUhGYVVtbU9ZODhFVExKTUo2TGlRdHIxZ25kSUtSb2dqdGhtSFdiTjlK?=
 =?utf-8?B?VEJYN1N2OCs4RW5ML0ZTVzdDTkI2WDBGcFUvZmVLbUhwMVJDNGpDWkJNa3lU?=
 =?utf-8?B?bmJFc2RYZ25TZjQyK2dnWElpVlpsbkxidzY2M3pyYnkrbGRJMXg2UGt3VHpI?=
 =?utf-8?B?dFZPNU9IM3E2b3I3Z1pmdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGVXazJlc0hSTm55bExGQS9SeHpxYXNodTZVNXFYNHpwOVNNako2dE8ybkdz?=
 =?utf-8?B?WkVZV1V0QXYrT3NEazFNWWtlNGprT20wT0wvZTcxdW8vcnZMY09Ba09rbTU2?=
 =?utf-8?B?LzE4OTlwMXZaR24zdXo0Ymd6VDY4cFFKK0gxRDdReEM1MFZPMTlsSHo1UnJC?=
 =?utf-8?B?ZEhJc0VkZGsyOUtteTA5WktNd3o4WjBTWkJtcThyY3RCM2FqS1JNWTJxdGMy?=
 =?utf-8?B?Sjd4NEdUdG5XLzF4QWFPNTZDK21aSmQvR01OTy9JeGRjNTM3THkwNWc1Q0JU?=
 =?utf-8?B?NmNBdjBXMFJXRkl3ZzlOV3IxTVppWndqTHBkTC9xNmx2bjJvZnRxQnBHNzNh?=
 =?utf-8?B?b0pOTjkzQVpVUmpBRkVZSC9OemQ3bk40WkIvaXFkZWRRWkwyS2JhOXZtOFdG?=
 =?utf-8?B?enZKdm1hdHZaU0ZSZUt3TzVnR3J5ZG0xUzlDZDYySSszT3lsZVFCSUp6WFJS?=
 =?utf-8?B?VW9KNTdGSEpEUmpWSEE0QXpqMWNrb21kNjEwelFtVlJjdEJiODBmVHpreWhN?=
 =?utf-8?B?SmszOS9NelhQa2d1QW1Cd29udVE3cTN1VmpyajltbVo0YkZlRzE0aXlpUGtG?=
 =?utf-8?B?R1Zkb2dwRSt1dEFQcTdNUkZaMEhFS3pPelpPTUVDMk1VSlFEN0hwaTBmd281?=
 =?utf-8?B?Nm11T2JWV0o3Q1NsZ1A5YlY5eUZBeUlxRjFnZ3B4WjYxaFVPVlRYMGhGMmNC?=
 =?utf-8?B?MDNzN0l2NjdvTGlwanZNRWRINnhlWXJtcmd0M21BTzVxRzRJaWhTcjFPOGtL?=
 =?utf-8?B?SnpWNXZzd28vYWdKS1RzVHJObi9UYTgwd01ieG5WTmVnTkZIcGNJSTRUNUQ0?=
 =?utf-8?B?eDlEUFdGZEtnOWJWejgxblB4Z0hYaFlIRG9QYzVoZFZYUG5jbW5udlRUbTZ2?=
 =?utf-8?B?b0dEMlFJK2Fycm5oNVJqUEJVZDd5NllQSWJ1YlZrRFo1cndqdnMxaWRXSHdM?=
 =?utf-8?B?SkF5ckt3VzcwVWpXUk5wRHFwWEMwMGt3ZkxlRG9jajFzVFNneEJEMldSMGk0?=
 =?utf-8?B?Q2M0V0tRbm9ZUysrT2JOY3hKZWRwaXU3dTVFWS8yR1ZERTFzdHlhbExUSGhh?=
 =?utf-8?B?VFNNenlWWjFtYm43YytXQnFZZ3hadUJ4UkJzMzNOVUJSSlRsRXd2UHpHdk9W?=
 =?utf-8?B?eGxSbzJxaEQ3RmNaVWFsVURWNzJNUFlnZEx5WFBoKzZrRnh4QlNqTldiWmI4?=
 =?utf-8?B?ci8zSW1tYVozVkdKVDIreWtHWnkzQk9CalVMbjFPdTZrS3EzS0huakNrbFJk?=
 =?utf-8?B?Vzc4N3cyc3ZmZlZYRlVJV0ZBL3YzYW5ReVdhTXdmaWRleUhMdjBQV1ZEbVZm?=
 =?utf-8?B?ajNlV1NLQU1zMEwvb1AxRWlMcnZRZDAyZ1FNc3FUNHpUR0lLcmhya1lTUTRU?=
 =?utf-8?B?L1BmOS9GMUVCMlE0bnBtL3lTbWlWbXhUWmwyMUpXY2lkZzNucWluNUNrNlVx?=
 =?utf-8?B?Ui9PQjJUcnNrZkYyTS9CVjduajlyMmJCZEp3RExSbWtlWWpOSjZ1UDh3dVda?=
 =?utf-8?B?M0RWeTh2WXF3cGIyN1NHZmtLNWZDMFBkeWZFTC9SYkN1WUFYMUQ4b1puL3Nj?=
 =?utf-8?B?NTIreElIcDU3QXlRQmJaWVNhSEQ0alV3RDQ3Z0Z2VG1nVUdxRnQ4MktvMkVj?=
 =?utf-8?B?VVpGNmlCQnJtQ0c2MTZXekpCZFk3dGE5RDFpVjlxdkc2cU81aGhnTzZldHI1?=
 =?utf-8?B?S3hkTkxySjE5ZDdOcUlGWnJGUE1qZmlwMTdRdWpuamRQSk9XT3pOK1NmcUVR?=
 =?utf-8?B?SlgwMHM2OVBYY3VNNFYzdFV2ZVJyMG9ERld3TElvSHBXU045R25JY08xWGdU?=
 =?utf-8?B?WFNYdEJZNmVvQ0kwL09ENGlUSkF2dHR5MEU0R3lqdzhOb2ZlV3lEeDBkeGVM?=
 =?utf-8?B?YTMyTTVoaUNDSnJOU3EzKzZsUTRQQ3E4dG0zNElRbU5UVmM3ZXhkbXB6QmVs?=
 =?utf-8?B?YlFYbEpMVTVJVTRCblVubDQ5cXFabXFzOWNkZ0laelRkLy8yaVU3K01KOG5W?=
 =?utf-8?B?NmVKVDBGRVdxSkhDVVlPOTliRFJjQXhtenNBaVdFMEJCTis3VnNtRE1CWG5k?=
 =?utf-8?B?Tm55dU5SVEc3NUlxZEY0bmFmTVY3cDc1bWxMbm1FZlQzSnJ4dUo5RkNDbWFj?=
 =?utf-8?Q?31BBQMrp8xpilaIpCE5tbxXHP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466513d3-cba6-4943-e254-08dcb7d47e8d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 18:04:06.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwePpbGz4/1M5Dk68HrMHKT/yJwcxO9hwwvC4OJFCAfWXS/VR7vc/0PPIjS9TUIwtDg50FMhpAuyCOxWMehY4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8068



On 08.08.24 10:20, Jason Wang wrote:
> We used to call irq_bypass_unregister_producer() in
> vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
> token pointer is still valid or not.
> 
> Actually, we use the eventfd_ctx as the token so the life cycle of the
> token should be bound to the VHOST_SET_VRING_CALL instead of
> vhost_vdpa_setup_vq_irq() which could be called by set_status().
> 
> Fixing this by setting up  irq bypass producer's token when handling
> VHOST_SET_VRING_CALL and un-registering the producer before calling
> vhost_vring_ioctl() to prevent a possible use after free as eventfd
> could have been released in vhost_vring_ioctl().
> 
> Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Note for Dragos: Please check whether this fixes your issue. I
> slightly test it with vp_vdpa in L2.
> ---
>  drivers/vhost/vdpa.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index e31ec9ebc4ce..388226a48bcc 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	if (irq < 0)
>  		return;
>  
> -	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>  	if (!vq->call_ctx.ctx)
>  		return;
>  
> -	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>  	vq->call_ctx.producer.irq = irq;
>  	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>  	if (unlikely(ret))
> @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  			vq->last_avail_idx = vq_state.split.avail_index;
>  		}
>  		break;
> +	case VHOST_SET_VRING_CALL:
> +		if (vq->call_ctx.ctx) {
> +			vhost_vdpa_unsetup_vq_irq(v, idx);
> +			vq->call_ctx.producer.token = NULL;
> +		}
> +		break;
>  	}
>  
>  	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
> @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  			cb.callback = vhost_vdpa_virtqueue_cb;
>  			cb.private = vq;
>  			cb.trigger = vq->call_ctx.ctx;
> +			vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +			vhost_vdpa_setup_vq_irq(v, idx);
>  		} else {
>  			cb.callback = NULL;
>  			cb.private = NULL;
>  			cb.trigger = NULL;
>  		}
>  		ops->set_vq_cb(vdpa, idx, &cb);
> -		vhost_vdpa_setup_vq_irq(v, idx);
>  		break;
>  
>  	case VHOST_SET_VRING_NUM:
> @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  	for (i = 0; i < nvqs; i++) {
>  		vqs[i] = &v->vqs[i];
>  		vqs[i]->handle_kick = handle_vq_kick;
> +		vqs[i]->call_ctx.ctx = NULL;
>  	}
>  	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>  		       vhost_vdpa_process_iotlb_msg);

No more crashes, but now getting a lot of:
 vhost-vdpa-X: vq Y, irq bypass producer (token 00000000a66e28ab) registration fails, ret =  -16

... seems like the irq_bypass_unregister_producer() that was removed
might still be needed somewhere?

Thanks,
Dragos


