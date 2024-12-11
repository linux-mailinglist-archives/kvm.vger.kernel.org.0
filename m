Return-Path: <kvm+bounces-33485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AAF89ECEC1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 15:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68E75188257A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 14:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C050E195811;
	Wed, 11 Dec 2024 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UsIky6zH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21F1802AB;
	Wed, 11 Dec 2024 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733927854; cv=fail; b=E0TVytLPHo+FKeo4huMQiFf7/O3df7UXcpiUjQmZ4KSqq+RBMS0QnupEGaCokipCYhwP4/eJxsXy6a+WtWc2JfCMUqYpbEt4GxIKevrFKmYZ6lsp3zkN+76ZhjgDvsBOVzfAAxPvpnxu18M8hv1AutgrNzsBucMLpgZRwEudgz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733927854; c=relaxed/simple;
	bh=KukEGMtLXeqFpZ3TadZDc5cOfzdXMjkDrw2dgGTS7Go=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=Q3WOSVhWefjgp4jZgFmUuKrFZ4Bpo7VlkoOLNvEtDA3x+gmRrJVqlPGfiE6nv+uC9yxIdA9srGnZ0/gMTJqzQDHRmxOyYOX255tCyzN2c5GP3CD7KsmPIape/CV3hJMQSF8wv+fOUz2x/jKmGt8+V0wQ8/r9kLJJiiQuM6tunpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UsIky6zH; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VmTVECsR0+R9NGdnaAPTbpcIU3089WSJlzvPVTrSY0PiODosptOd3N4sr3QUJncSJ27vCvUDVdd7I8/0YOEvdPT4zpU2RpwAM7Weuzk3nKRXQ4TI/WK78tvByf96+63VCh31KOU8ECeOBYprOLdb8Hzh5iF6FXBTsjQlMlZHYKo5Q2e5Y7xxn9HPxZMZ+WACQCGLtx+X9hwv+5ODdk1z2/P3WYXUZg1UyKkwp+eu1RZ+kS4skPiPu6Qq8TBk7iZ91TEknzYBaYbBcVc6U3Vt9Pisj10JLcFiw5bMJwfj3Lu8+Q6NNCLXbH1p6IPq/l1GLBh2/URPdikhbIW91qkEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMv4iFTb1m6U/leJ0sl5ZvxLbpowdemdEfNdk1QiLX8=;
 b=h2XxkikDqF+aeo4sogJVlvWFxdzySf2NhP6FGT/1vMxKHP0Qx9oCKVVJ9qwLmIybaPuueq7+pXTsERqCB0bPn1sJOhFSyjNvEMYA4R01TJJD11Q1hLg1RYAzzu50KXGvRwVaJJxQc2sk2N/RUdMUbdbFR6PXpamA/QEFo08sehA49g7Jmh99TBQHrRHukJSI8ab3prbGvveqylsoPfv55Jw1nPBZO4U4RphK5IrhWQNWpmAdtfNpleLe/R9o53xf2B3XyJV1gEjhL/eKNAAtoKC0B30lsGO6kEzHOtPhiuCi1pzKWkNxo5Ibp8ysP+h1X6jiC+6I9DyemO2lodkmvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMv4iFTb1m6U/leJ0sl5ZvxLbpowdemdEfNdk1QiLX8=;
 b=UsIky6zHeF0NQdGT4AILE13m/CD38oGvAINWVuaS/IOSsUdcnguA+k7O4ixEAfYkaeX8TIDWQSpbDncT5abp47QkacE4YFrYhakwqe6Nn7GiULsP2uUKXfhMBZJp9Nh1gCAwIFM69UwhH08VkaYV0eBFAxTp3rxYIKBayiJBSnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 14:37:28 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 14:37:28 +0000
Message-ID: <c64099db-33b3-9438-536e-7882bae614e0@amd.com>
Date: Wed, 11 Dec 2024 08:37:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Simon Pilkington <simonp.git@mailbox.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, regressions@lists.linux.dev
References: <52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org>
 <Z1hiiz40nUqN2e5M@google.com>
 <93a3edef-dde6-4ef6-ae40-39990040a497@mailbox.org>
 <9e827d41-a054-5c04-6ecb-b23f2a4b5913@amd.com> <Z1jEDFpanEIVz1sY@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [REGRESSION] from 74a0e79df68a8042fb84fd7207e57b70722cf825: VFIO
 PCI passthrough no longer works
In-Reply-To: <Z1jEDFpanEIVz1sY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:805:de::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e880088-5bdc-4326-ba74-08dd19f15654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnFDZkxCOXB1L0xqSFBoMEYraVZtZ1dvQlJpNzNuTTBXUm1oS010WlpsT0or?=
 =?utf-8?B?TVcvYUpvRVJjWmhaOXNsTC9hUDdNbmxtd1hQNmh4Ti8zblJDQU9BV1UwSTJM?=
 =?utf-8?B?UGppNmpNQkpDZkdkb2xQQjUwMHBRYXY3TGxsQVgvTE5ySExUejZZRjhFa2p6?=
 =?utf-8?B?aTU0MHdzQXQwQTRENWYxNlFmWitUR2lETGhlNTlpU2RGY1lsRlpUdURLR1ZH?=
 =?utf-8?B?dHBTa0diL1M5L1FwZXMwbmhuRFEyVmZ1bWsvVEk5bTFoeDVBdktpNFl4WVh4?=
 =?utf-8?B?dW9ZaWhqaGkrSEdMUGxhL3RXTE13dFBTNHZxZk4rRXl4UExHN3I0UWpuVzZl?=
 =?utf-8?B?KytDZVdzeXRmR1lkUFBlUGNKeFBZclNvTlprT1dJOEM5WnZQN2tKdUdFMmts?=
 =?utf-8?B?MDVMTklxNjNlVEVVbXNlaW5aT25Mdmw3UDIvSm4yR092dEFlMlhVcm43V3dz?=
 =?utf-8?B?MFdNcUxFK2w0VlVYRXhsbHArK2VFYnVSOWM0U1lucjZLVlpGWGh5UVlKR1hX?=
 =?utf-8?B?TmxVcVZhSkNDVkFaN3FNdEdLRE9ZRkZJajltMUhiNGRDOGRBa3FKd2E5eFFz?=
 =?utf-8?B?cUxGbi9aMHhpcktlVlFBTHBWb09ncFp6bTZvSnlzSE16NlVrdFdURWNUbTRC?=
 =?utf-8?B?V2wzUkVFU2hMWHFZRm9RSGNhWERQcTdtZU5SZm1uRGJyc2pUSkFTK1hjZ05q?=
 =?utf-8?B?WFIyazIvTTBXNGV2YWRwU21hcnBwcTluZFdSblg4dVY3ZnBtd0NRZHpxeGZ2?=
 =?utf-8?B?REtiWFdCTUE3Z2V2U2hWZXE3QzJaeDEzQUhua2h2UTdKS2ZNdW0wMFZGYzJr?=
 =?utf-8?B?VlJYNkR5WDljS0ptTUJRcXg0THo3Q2VBdzlqcGdYUzk2TmFHcjEyd291NW1G?=
 =?utf-8?B?WEc3Y1lUNmZ2cUo1dFlzZ0FzU3JUK2pjM0hSZGVjek81a0t1aHI1cVUva1E5?=
 =?utf-8?B?dkphZGJJdjZ3K0Z0K3NjbFVsRkVnYjRWN0l3STRHNGxyUDl3WnlhTXpuQzJM?=
 =?utf-8?B?N1hGR0NUR0wyOHhHY3FFR2IyWjlLOVRtN0lEM3VodVY3UHhWWm1BSjBBVnRR?=
 =?utf-8?B?YnZ3SW0xcTBWZnlQOGE1R01yQ2RocWxUcmR0UTViRVZhSTRSZ2REaWtWcXhz?=
 =?utf-8?B?UTY3NDZ5VTNteVZucHRkTlJKSlRmMVlKL0xTc3JDUWdaQzVkU2ZOSUtCaDVE?=
 =?utf-8?B?dmFqSHoxcTJ0NVExWmZ6RXNiM3Z4YXJ6SHZtNmtwM0FwMGhPRHpMVFo0Mkpy?=
 =?utf-8?B?bUtrWEU3ZEhCSy8vU0dWZm5vZGpxZjZtOTN4eDBFYlJ3U0FaRzByN2xsZjBV?=
 =?utf-8?B?eUkxSVZkU04xd2l3L29JUzZ1VnFFNFdnSlpQbFJQZ1FoQ1FlV211MWgvWS8w?=
 =?utf-8?B?VU1VNm9tOStiYjVPQmlZK3VUTHhoby83MUFLTjkyQnUvWXNmVmkyQ3k4RWVC?=
 =?utf-8?B?OExLdEtqV2FpcllsRlNqTWpjZG0zZEVyR2dBYUdROHpKb001RHZrZW1laUpi?=
 =?utf-8?B?WDhDU0dhVWJNb0svRHhDU1ZqNTg5Q2RCQ2YySlR6UHhUVmVFTnpGVGM0bjRT?=
 =?utf-8?B?U3cwTlM0VGJtVWR1Rlh6cm1Bb016YUJmVDYrd1dZQ3BqZ3dzb1RBWm9ybk1h?=
 =?utf-8?B?cXorc2lRb0xGUjVyd0FmMjZLdG5xNTR1MlpFbys3bzZicW9Rc2crdVZHWTQy?=
 =?utf-8?B?VWlYOW9PQUZuMWhMUk5ib1hLY1F0MExrcWdvZ3VNQ2FRbFN1UW1rUUI2RktG?=
 =?utf-8?B?dEU0WGowb0MxSVNteHp5NWRsUkhKc2IvZVB4NUcydHRaUy8wT3NzS0dkS3NT?=
 =?utf-8?B?UStzTnpScWM3QW4yQituZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bi9BUitCRHdKNGFra3d1WXovWW40K1czN0R6VTZDSVBjRFFxNlpId2hEemN5?=
 =?utf-8?B?N0ZMMzVIWDdjZ2VFZ1JDcmE4S0VZZWtMZTZlazFlelBpdTJnSGFqTTZLb0E0?=
 =?utf-8?B?UWxUb2FKL0hReGw4dnNVMitUMCsyb25SYkRxYW1WTDZrTDVqYXJ1cndXSzhy?=
 =?utf-8?B?VDZySUlLUUlJYTM0WEw2bnZjc1RlRFVGNmJYNUZ0dGU1anFBbHdTeFAwOW1m?=
 =?utf-8?B?YnZ1dndjMmJWODBlaHlxQTRBZDlHdHc1Y2lxSlBzVkN4ZXNIQ3RXSlFxVkYz?=
 =?utf-8?B?R290SnVFeERiTTArSVViRDB6aWROK0VIWVl5WVBBV1ovNnFpZHp3Y2JtdVlG?=
 =?utf-8?B?U3NTQ3krVmpxNGV4SWN3NDdKQXlpQnFEUHJqWnpXQmNFMVcxcC9xWCtENXYy?=
 =?utf-8?B?UmZBVC83b2R2RDdUZVdoZmp1L1ViZ2RwdU5QeG1RMExsemd0b3FUa2lrLy9v?=
 =?utf-8?B?bTdjRUoyV3lIZFpKd2djaXpQWWsrbXh2Q2IvQkdsZUx1NUd2VDNSTVVpSjds?=
 =?utf-8?B?dzBpVmcvemdUckcrTE1rd1QzVk5iMmxvcjFTOEt6S241NGVENUZLbEJ0bkhJ?=
 =?utf-8?B?VGlQL1RLUVJzeXZtNHZmajBjazJCenYvNWU5SjFDMC9GSTJMMnBSZ3VTOUpz?=
 =?utf-8?B?K1o5Uk94b1pYOE44SFVJSlEwVDd0QnpnM0MxM0FlN1FidENZeXY3NmRKWTRs?=
 =?utf-8?B?eHdERk9iblRwZndYMDNxVUJ1N0t0RlltQVlQejFWdmtkcUFiNVpmU0JqeFpn?=
 =?utf-8?B?ZFpwRWxFWGJhWE9nRGdPMEk5V2l0NXA4a1FNVGxzdTlJc21nT0JhYnZoaklL?=
 =?utf-8?B?VldBaWRmdGp3NDF0empJd1VRL20xcGRMdVZBY2dEQ1BIT0Mxa3Mrb09HbFNa?=
 =?utf-8?B?RCtXUFdBZFZDOGEyT0FLYWgyRHNVUXhwK21iNmpYYWgyYVV3Yjl5THFIOVNm?=
 =?utf-8?B?T1NFY1htK201NnhmVC9ha3NsU1dMQVJoQ2lLeVBHaG1xM3F1MEt3b2lxMDQ2?=
 =?utf-8?B?MXpQMXZGdTJsZkxROGdUeXQ0eENVejdyMGdzYm1nWEl0aFF1RzJGMkNmM1Q1?=
 =?utf-8?B?TC9ZZmhLZDNNV09qQW05aUpoSDZCaXM1VkxaQnR4bjlUNjhqK3ZIWjVGNVBK?=
 =?utf-8?B?T0RMLyswNXFNcUFrcHI2ZjV1d1lWZ1BTUVRzNXpCOC81cHdwTmhwQlptOVAx?=
 =?utf-8?B?MU0xaENqM0x0MGNXa3dvOVB4UVFZTGtkdHkvN0pOZ0pmMWE3V3lCSkU2YytQ?=
 =?utf-8?B?QjVsRTBZYU5ESVBCR2FkNmQ2OUtFTFJBNEhJOXpJeVI0bVBvcTdRc3FXZ0gr?=
 =?utf-8?B?VnpGNHpETFJiOTFxaTFUNG4wTVhKNUtlNHJyZzBIc3U2WDRpNXdzT00ra2lr?=
 =?utf-8?B?V0hwejVkRndDRXg0NjFCbmw0Zkx6ZHh3dFo4Q3JLSWNPbWtrVzVsQ2VkcEtB?=
 =?utf-8?B?UlREbjNGenZ4SnAwWE9BcVpXTEVSV0NJaWFyVEJ2MVdaeDRXWHJodEJUaE41?=
 =?utf-8?B?VlZXbjV0ZlloemlKZEVBUEhQaVk1MmREMWp4TXNpM1FDclV4c3BiOW5hVEo4?=
 =?utf-8?B?dG9yT1JtWkExV2xhVUZTT2MwK3M4ekpPRFZ3RXhocWdkTzkwL29xUXBRTkVp?=
 =?utf-8?B?SDRqdUFSN3NqN1ZlRUtlWVpoaGVlbi9tTGcweHhyVjg1ajlMdzJWWWV5eXpU?=
 =?utf-8?B?c2dnN0JsWWJmclFhRkR4OVlXdC8yQkdqU1ZwUll6S1BRMURheU9QU3hsbHF5?=
 =?utf-8?B?cWV6dGFERUxqdnliTmw2Lzl5cTJ2Q1FBblFWTWpXNGQxRGRqN3RZR083b1Bw?=
 =?utf-8?B?U3ROcnQwSXVobS9ZTXpvbzY2UnFjK2VSVE5temR5KzFqNndwZ1dHZS9aTmpz?=
 =?utf-8?B?V1JFUStSUGhmZVE5QW1tWHZKeXg5ZElNc251WGdkTUE3d2R0Z3d6eXlVbERH?=
 =?utf-8?B?U2RwMzczdzRLUWphdlJJWEd0dnE1d25paiszNDRmbjRBcHR5cGY1c0lIK3Fr?=
 =?utf-8?B?WHUvcnVKcXdia2xiSjhWL0hwdHlRODcwUXhYTWljM21lb2kwSXI0VFJNUG1r?=
 =?utf-8?B?eWJUcVNZL1ZKSG41VEQ0clY0amlrejBhNWVhNW1scDFrcTBoRFdqaXpUQnJ3?=
 =?utf-8?Q?x26E1M3wftAMJ1LcHxruupTFR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e880088-5bdc-4326-ba74-08dd19f15654
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 14:37:28.4259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCRWF94G2um6wIhpTXFWvhAF3/7o/KEn47K+hS6NTWK+wZiC8aZP2dVnXLvCvR+xrDY8pF+MXoH1tat0TZEPig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972

On 12/10/24 16:43, Sean Christopherson wrote:
> On Tue, Dec 10, 2024, Tom Lendacky wrote:
>> On 12/10/24 14:33, Simon Pilkington wrote:
>>> On 10/12/2024 16:47, Sean Christopherson wrote:
>>>> Can you run with the below to see what bits the guest is trying to set (or clear)?
>>>> We could get the same info via tracepoints, but this will likely be faster/easier.
>>>>
>>>> ---
>>>>  arch/x86/kvm/svm/svm.c | 12 +++++++++---
>>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index dd15cc635655..5144d0283c9d 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -3195,11 +3195,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>>  	case MSR_AMD64_DE_CFG: {
>>>>  		u64 supported_de_cfg;
>>>>  
>>>> -		if (svm_get_feature_msr(ecx, &supported_de_cfg))
>>>> +		if (WARN_ON_ONCE(svm_get_feature_msr(ecx, &supported_de_cfg)))
>>>>  			return 1;
>>>>  
>>>> -		if (data & ~supported_de_cfg)
>>>> +		if (data & ~supported_de_cfg) {
>>>> +			pr_warn("DE_CFG supported = %llx, WRMSR = %llx\n",
>>>> +				supported_de_cfg, data);
>>>>  			return 1;
>>>> +		}
>>>>  
>>>>  		/*
>>>>  		 * Don't let the guest change the host-programmed value.  The
>>>> @@ -3207,8 +3210,11 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>>  		 * are completely unknown to KVM, and the one bit known to KVM
>>>>  		 * is simply a reflection of hardware capabilities.
>>>>  		 */
>>>> -		if (!msr->host_initiated && data != svm->msr_decfg)
>>>> +		if (!msr->host_initiated && data != svm->msr_decfg) {
>>>> +			pr_warn("DE_CFG current = %llx, WRMSR = %llx\n",
>>>> +				svm->msr_decfg, data);
>>>>  			return 1;
>>>> +		}
>>>>  
>>>>  		svm->msr_decfg = data;
>>>>  		break;
>>>>
>>>> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
>>>
>>> Relevant dmesg output with some context below. VM locked up as expected.
>>>
>>> [   85.834971] vfio-pci 0000:0c:00.0: resetting
>>> [   85.937573] vfio-pci 0000:0c:00.0: reset done
>>> [   86.494210] vfio-pci 0000:0c:00.0: resetting
>>> [   86.494264] vfio-pci 0000:0c:00.1: resetting
>>> [   86.761442] vfio-pci 0000:0c:00.0: reset done
>>> [   86.761480] vfio-pci 0000:0c:00.1: reset done
>>> [   86.762392] vfio-pci 0000:0c:00.0: resetting
>>> [   86.865462] vfio-pci 0000:0c:00.0: reset done
>>> [   86.977360] virbr0: port 1(vnet1) entered learning state
>>> [   88.993052] virbr0: port 1(vnet1) entered forwarding state
>>> [   88.993057] virbr0: topology change detected, propagating
>>> [  103.459114] kvm_amd: DE_CFG current = 0, WRMSR = 2
>>> [  161.442032] virbr0: port 1(vnet1) entered disabled state // VM shut down
>>
>> That is the MSR_AMD64_DE_CFG_LFENCE_SERIALIZE bit. Yeah, that actually
>> does change the behavior of LFENCE and isn't just a reflection of the
>> hardware.
>>
>> Linux does set that bit on boot, too (if LFENCE always serializing isn't
>> advertised 8000_0021_EAX[2]), so I'm kind of surprised it didn't pop up
>> there.
> 
> Linux may be running afoul of this, but it would only become visible if someone
> checked dmesg.  Even the "unsafe" MSR accesses in Linux gracefully handle faults
> these days, the only symptom would be a WARN.
> 
>> I imagine that the above CPUID bit isn't set, so an attempt is made to
>> set the MSR bit.
> 
> Yep.  And LFENCE_RDTSC _is_ supported, otherwise the supported_de_cfg check would
> have failed.  Which means it's a-ok for the guest to set the bit, i.e. KVM won't
> let the guest incorrectly think it's running on CPU for which LFENCE is serializing.
> 
> Unless you (Tom) disagree, I vote to simply drop the offending code, i.e. make
> all supported bits fully writable from the guest.  KVM is firmly in the wrong here,
> and I can't think of any reason to disallow the guest from clearing LFENCE_SERIALIZE.
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6a350cee2f6c..5a82ead3bf0f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3201,15 +3201,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                 if (data & ~supported_de_cfg)
>                         return 1;
>  
> -               /*
> -                * Don't let the guest change the host-programmed value.  The
> -                * MSR is very model specific, i.e. contains multiple bits that
> -                * are completely unknown to KVM, and the one bit known to KVM
> -                * is simply a reflection of hardware capabilities.
> -                */
> -               if (!msr->host_initiated && data != svm->msr_decfg)
> -                       return 1;
> -

That works for me.

Thanks,
Tom

>                 svm->msr_decfg = data;
>                 break;
>         }
> 

