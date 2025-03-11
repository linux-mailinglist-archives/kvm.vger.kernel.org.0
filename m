Return-Path: <kvm+bounces-40765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0252CA5BE79
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 12:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94B981897E77
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 11:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92CEF250C1F;
	Tue, 11 Mar 2025 11:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UCOXNMJt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC51224169D
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 11:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741691126; cv=fail; b=Jt6tm3AI1yMZr0V9yXuGwiS1M2ssm+MOvnjnUvXj9pC/et1Wkgkm7yN5h94wufREP/dolTMOCpb1YHk6XvGJDhFgy9HuDCv2yJ4CJ196+jaruhmFXyRclSLNrpsmEdxpvtnS9cCjbXpmx5ncE+UDoRcbdspgfTz52+w9EUcQzZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741691126; c=relaxed/simple;
	bh=P/ub/iWMFZBh6Eu72K2aaUpeM3VBRhgPR8j5I76tbfE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TbVrg9A3jcfiuXXx+f3Wh1RXzcvx4QspO3w+toGWH0Pm/j2/6FaRrx0CVCT4EOnTl2UxEPn+aNHVaEEa/OXav1lwkH9CB64/5eA2kxeRQQrtimNVhjBoLbq6PAlxP7l9RsbirCPSDq/7SU1Z8Dtp+wvzzgwdggYIk9m2jrZ0Q+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UCOXNMJt; arc=fail smtp.client-ip=40.107.100.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJv6UCe8j3cnpfo41H1FDXX/wqiR5MyZen9M47ZleFLIFNKKs2pvze6ya4PxUqEAXrvMtc5srA+MoFURb09O3S4q/Cf887+bFwfnsW6MV3Dm7ArM7cCfmrMMwa1edU582if0/D3OsYxnAJIOAkNAops7flQk4tJ95B9YyGJAo/R2fgQCnJ/paL5+GubnenptV0wow62V6mskUSYSoYYH8d4aVwSLZ3YQf8HYp6jZ6/HCgu0BH0JFB01oQ0dnK5oNJDrVqQc+MRW+xC2GyiJ4EatZP8os4m/rRTIor90o3EQcwPa4rz3LG1My02qfWeESOUlMvSthtGw/6l2Jzy/5UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdy4S5t+KGBntIamPoifaEaBKh1njjc/C8Lk/nxNbVg=;
 b=R3FFodpGRkwXUj2x2I28ZlHfOFbcvxRJEG/TU2UBZK68Wa/c/D4WKDD1avYQ4aIIaT1Jo79tU3IPGXGmxaj8zFD6ln2lb0HKkzaiBb7CSD60FT0dAsov2e0wOc5sQNUyi3X62rnQgU1yScE6Ifkd9zw+MIMlF4zfYcbPq/Fo2qgLhIYjZGSVPIkpflIPeB851hyJzTLfsZGnNoDTDPLk27gGLA824IvO5YBkMGqcC8CEqlmfDIRGOabtX9bERoaz0QE8soXQGcl6Jnpxs5mz/kKmNV0YaULnDdXjzcJXipfElnCSAHfI4wSmGEPYXVzH+zadAvRnRwW1719BtdQQoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdy4S5t+KGBntIamPoifaEaBKh1njjc/C8Lk/nxNbVg=;
 b=UCOXNMJtwu/xGVyHaTbIrR+GTDHyjvqY6WYr2eg7XLUE6ngaI+6/b/5MWGA8+ZB+VU4DvzWaWUX1qddiMAvI5Eihj/tVNvDkIg7xGbpOFr2X0CTQLr9Lh+W+EVIKKGo3XvGN7nTD4adoOTGu/favLbbropGfb6WzKy8UUjv7OME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 11:05:22 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%5]) with mapi id 15.20.8511.025; Tue, 11 Mar 2025
 11:05:21 +0000
Message-ID: <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
Date: Tue, 11 Mar 2025 16:35:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com>
 <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
 <cc076754-f465-426b-b404-1892d26e8f23@amd.com>
Content-Language: en-US
In-Reply-To: <cc076754-f465-426b-b404-1892d26e8f23@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|BY5PR12MB4226:EE_
X-MS-Office365-Filtering-Correlation-Id: a28253fe-a3b0-4003-cbab-08dd608c9d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUUvUy9IbjNUZHFZSTlISGxOR3laN0svdWlPdG1vSjlCWmJZazRyTEVhUWx5?=
 =?utf-8?B?blk0NVh5STdUUEdvaENWRVdja2VROHQ3aVNhUUs4M0NiRmFhS2cxUm91QXQ3?=
 =?utf-8?B?Y2JhSlplTzF6V3I0SmQvYlFnUVQ1MHFCNjRCNzhCNTBmcVYvajBFbmY5eHd3?=
 =?utf-8?B?UlZLTStDckZlU0FOOTBPMjVZV1VJQ1M2d2x0Z3NYVEZDcmZlYVE3ek50OFNs?=
 =?utf-8?B?MmxlVW9kYkpkNVovME54T2N0ZnJPRWNnWEYxdHJYWlNwUU5VaWFTalRJTGNS?=
 =?utf-8?B?SDVMVm5GdWtiVU5jRkZISXg4MG1yWGRIdWEvRWVCT0RTR2FrM1ppUVNvY0s4?=
 =?utf-8?B?Y21RdUdaRTAzV20waUlrR3I2enRhUGMwZVQrWHlDQnh0b0RFY2lBcmF0UlVD?=
 =?utf-8?B?NFMrYXd5eUUzaHc0ekFFUFVJOXkxbGZ1bE1BMVoybWJqT1hWS1RZKzB4V1hs?=
 =?utf-8?B?MHh4YnZTNG1nSzYvMmtIMS9nWHRndy9WeGNoajBVL29SOUlLN0h2N25oY3pp?=
 =?utf-8?B?aCtvNTZiREZsaGtNb2lsM0lzcG5VTDRPWnh4RDNzaS9weXE3OERja3JzakNq?=
 =?utf-8?B?NExsR2NXeCs2UkN5OXE4Y0t2M2tMeXE4RTJwamdiYkRRNzJ6SXN5RnZGN2JQ?=
 =?utf-8?B?WVZIK1ovbCttY3RQQnBqTU4yQU1xWGZ1OC9hUmVrRVdBM3FKRjdJNjU5dW1t?=
 =?utf-8?B?NGVUSmxzSGNhR2ZCSnpvc3gvMVFvb29zZGtSaTU3VU1CdjFlNmxmNTRDVVBJ?=
 =?utf-8?B?dEN4MlMvK1lPbTMwUVZoeWNxZTdBdVlBditFZXREamtTeW9SME1yYmJJL1Iy?=
 =?utf-8?B?eUE1RnY2Ynp3S0FsaGVKTTkwV1ROK0FCdFlQbi8vQWJBL2QzL1RDMnJoVitu?=
 =?utf-8?B?eHF2c2V0YTUxQjI4bGd3YVRqbFl0YVk1bnQrQ1VZNHg4eVlodlloMmVyeFdp?=
 =?utf-8?B?aUZSUE9Cb3IxZ3ZvT0pEbFpYRGdST2VtRmRNbExxdEE5UGoxbXlteFpjNlA1?=
 =?utf-8?B?K08vWVQ5SDdJZkxmWlFldzJTWDg3VjJ4d0tFMmlXQlJnKzBGdGl5TERMeTBV?=
 =?utf-8?B?V3EvT2pwekhzcTVmcnAvc0d5SEFJQUgrK1VRMlArRzhETWFad3VSMitheVhE?=
 =?utf-8?B?T2s0SENkQ0NudHdvcnZ1eWlGRGErY0lkUmJaSTJ1Nm1VNUVUOHZ3V2dScWs2?=
 =?utf-8?B?OEsxTHBOMjUrMklMV1ozcG82N3VCb0RDYldaVVd1YnEzN01VV3Nxeml6enMv?=
 =?utf-8?B?Mjc1WktsclhoK1lLYzhJeFRYNlNMQTl1dTI4d3dtSkRnUVZjeGRPWlgwdjl0?=
 =?utf-8?B?dys4R2Y1SFRBSW9UTHlwbWRLeVZSci83d3NjUXNLL2VOUG5OUkVScnZpcHYz?=
 =?utf-8?B?MTlRN2dGZnQwNEs0czRKanFYL0pnWTUwbjJjaFhYTHpxZUFybnJ6aWRqMlVP?=
 =?utf-8?B?SE52YkxnTmNqQnJtMW11WDlhWXdkL01YUHhpSmp3QURlOTBCKzZRS3pES2Ex?=
 =?utf-8?B?Q1laLzZWM1Uza1FVM3EyL0FjVFVjR3F1eGxIRGlzN0V2N1JyV0gwakx2dXBk?=
 =?utf-8?B?cWxCMTVvRGF4OHpsSkVzaFJETWZWZSszK0hENEV3UFRvOHVnU0lnOWpEaEcv?=
 =?utf-8?B?MjFESHdRN2lqSjhQM3BpQ1RRazFoZ0dzSlo4SGxQYlZFc3ljQUJjV1BKSEQ2?=
 =?utf-8?B?dnJjcC92K1NMb3RpWUZDV2dVVEg1S0hPU2lIM1ZTQUlsUFdTNkNyOUZOQjBE?=
 =?utf-8?B?SjJTQ2hUMHZxT0x2Q2JueXpnWmIyTWJ3MGZ4TFl0K0MwTjRrMHA0amJPdG1s?=
 =?utf-8?B?V1BlOGFsc2JlTkIzV3R4ZEJOd0IyZHFKWnQvVjIzZlVETitUT0Rub1Jacjd5?=
 =?utf-8?Q?9plpREHzgig0P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU1ZU2dZWFplVDBNM2dQS2V3a21IVk41MHZyMlVYRlc0ZlcwMHprU0Y0M0ZI?=
 =?utf-8?B?amFLd3FWMGpDWkJNSTFKMkp5S1ZUOUordTlRV3JQUHlsdk81Ykg5dUJSRDgy?=
 =?utf-8?B?TFRHZXJDblJmT3gvNzRDYnRhSUx0c1JRVVdEb1JaMUFPbzJlS0laVExBQklN?=
 =?utf-8?B?MGd2MDdOajczZnNPWUNld0NIbUJXSzRiTXJoM0pwR0taQ0tRQTZUV0ZYK3h5?=
 =?utf-8?B?OXpMQzdSNUhKaUNtV0tCZ2hYYmxhS1pVSFBTR2FMMURubWwxa1NzODBIc3VK?=
 =?utf-8?B?eGNDSDh2aVZMeXBUaWpDeWNCbFJ2Z0VZMGZaa2hwc0pDaVNtN3A0ZFQxV0lU?=
 =?utf-8?B?NFM0Z2hvNU9uOEtkWnhaQnVlSUVRMTkyM2pGcURVN3BUT3V5ZCtVRzRzVG9k?=
 =?utf-8?B?UmZCVkJEQjVsSnlHaFpIbTliaVZKNzNLSTFVNnZzb21UeVIzM0Y1M1dTaWNJ?=
 =?utf-8?B?SFJ6RjhqajZGNE9DVk9RWWZLWS91eitweEo3Mm1OR3JyNjB0SDBzRHA2SUlU?=
 =?utf-8?B?YmVLODBhd212ZXVzWmZCN2ozOVhOK2ZsSkJLQ3RJdzVvVGNZbjNsa3krdU1D?=
 =?utf-8?B?ZFdzSE1ZTlRLN2x0U0ZsS2pkRzdlQmJDT00xam5KWm9BeU1xcGdCeVEyOWs5?=
 =?utf-8?B?eWZPYXphRUJ2ZXIyYjJGREtFU0NtN3hiaTVvVURROUZqd3Jib1NqR2ozZmZy?=
 =?utf-8?B?djNjRkx2dEhJcGU1MGF0ZUk2eHlXUkxHVGEyWXJVdi9OK0JNSmxKbjVEdjdZ?=
 =?utf-8?B?aGlPbm9mLzJ4R3dTbU1WZ3N2aGlvT0htbVlXemtGNUZGUXVyTnF4K1lOVWpU?=
 =?utf-8?B?dUhXcUVOSk9sejg0L1NWVXBTUElidkRVMzlZVnNKS2tjb20vYk9BYnZPWEV5?=
 =?utf-8?B?Z3Vkank0aDNhVjBqbEx1ZEViMW1iUlJRRTV1cjZWUUNkQ2RDMGZ1eVREQ3BZ?=
 =?utf-8?B?RCs0RW9XSHRlWGlmdWFoTjdYVEcvRjhEMHZwWkMwNm9TZWVzOXlselhUZGNM?=
 =?utf-8?B?YTkrcWV1cStWV3A0amdCcXN2MXlXcDNPM2FtUllJTllGUmRxK2ZjeklBdzRr?=
 =?utf-8?B?LzRYL0p5OEVVcklQSkNlc25oSWlRdE04WjhQRTIrVC9uUG5BYUh2OFZCSmNx?=
 =?utf-8?B?Nm1yaW0vSVdIcGJoY3BIZHpyL090c3lobUlSMHBicXVqbGdZcVhMSlJYL01w?=
 =?utf-8?B?Y1JUemUyYjczdDNHbG1IcitGRkdGT3BNZVc5clF0OWFwTC9tcWlOVlR3V3lt?=
 =?utf-8?B?SlVNL1JWdmh5ejlSWWZtS054Q25Ea0srUHZIWS84d1NFMm10RElPbGhocjBC?=
 =?utf-8?B?dCthNnZRU210ME5ZMFU0V1lhOVdNZUxTV1Bza1RNdzcyVDRnZzRmVzREcXVQ?=
 =?utf-8?B?dU1ick02ZEJzQkR0RFdjS2FzeUJvV0N6eEtUUXNBZ1llUk50dHhPR3lkOGpD?=
 =?utf-8?B?YTNJMERpNU9LdndNbldGMFdsTnowS3BXU1cwQ0s4V25BcDJDNjM5dEtOV0F0?=
 =?utf-8?B?SXQzOTY4Nmg1Yis5QWRZbWJuSmhJbERtaFpBYlRPTkxOSmlBZXltcXpsakEz?=
 =?utf-8?B?dFVJczNYN2s3MVlZeG4xRCs4U0g5UXFxT241bkYvSkFsN2d6MENRRGJIZ2hm?=
 =?utf-8?B?T2xFZVNBT1hzdDFLVmVSNUdYeU9YTm5hQTZXME54UnlWUlFJdkRBLzlDN0xV?=
 =?utf-8?B?TzVsWVY2Q21oK0M1SkI2cXJQcDdFZXg4ZGxtZ0hpTUFYOTdPQ0lWdDNEOHZE?=
 =?utf-8?B?WCtwZG9iM1JDYmd2OUx6R2dhOGU3OG52aEhoMmhQRW8xc2JNOUlMY2RScURv?=
 =?utf-8?B?aGNYVWMvWkNNTHE5ZE1jelNLVEVNaEwxcTJGbno4QjE1RW9XMWFlTGdFc3BV?=
 =?utf-8?B?YUhMaFJJR0RXUDlnSWhyamRmUHRPdUpMQ2NRaUllWjlSVzVpMkhJMThZNGtW?=
 =?utf-8?B?bHR4N25LeEhQZnVXUVpZUHJpNERyYWJWdFZ3WVY5ZUx4YjBWVUVLenppSWZ2?=
 =?utf-8?B?Vm96bDNlTmdkdHAzNkkzeEc5Q21qcVBYMHZnbm1FcXMvSEhwdmRXS3RoQjdh?=
 =?utf-8?B?Y3pXRm94NEVIcWQ1ZGQwYTRRMlVZU2VHazZ3TCtRTFY4cEtaR3NDZm03WCs3?=
 =?utf-8?Q?BdakSFPWMCuaogWKE/KFITBVI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28253fe-a3b0-4003-cbab-08dd608c9d78
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 11:05:21.4672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hMxiNAhQJWBhR61LFfflYrUhtpBzoj2LziZwnfObRqLyDL7ebYeuD9YHb2YTthx71XK9KvS4RFOxrlrFvoryQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226



On 3/11/2025 2:41 PM, Nikunj A. Dadhania wrote:
> 
> 
> On 3/10/2025 9:09 PM, Tom Lendacky wrote:
>> On 3/10/25 01:45, Nikunj A Dadhania wrote:
> 
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 50263b473f95..b61d6bd75b37 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>  
>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>>  	start.policy = params.policy;
>>> +
>>> +	if (snp_secure_tsc_enabled(kvm)) {
>>> +		u32 user_tsc_khz = params.desired_tsc_khz;
>>> +
>>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
>>> +		if (!user_tsc_khz)
>>> +			user_tsc_khz = tsc_khz;
>>> +
>>> +		start.desired_tsc_khz = user_tsc_khz;
>>
>> Do we need to perform any sanity checking against this value?
> 
> On the higher side, sev-snp-guest.stsc-freq is u32, a Secure TSC guest boots fine with
> TSC frequency set to the highest value (stsc-freq=0xFFFFFFFF).
> 
> On the lower side as MSR_AMD64_GUEST_TSC_FREQ is in MHz, TSC clock should at least be 1Mhz. 

Something like this ?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b61d6bd75b37..c46b6afa969d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2213,6 +2213,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (!user_tsc_khz)
 			user_tsc_khz = tsc_khz;
 
+		/*
+		 * The minimum granularity for reporting Secure TSC frequency is
+		 * 1MHz. Return an error if the user specifies a TSC frequency
+		 * less than 1MHz.
+		 */
+		if (user_tsc_khz < 1000)
+			return -EINVAL;
+
 		start.desired_tsc_khz = user_tsc_khz;
 
 		/* Set the arch default TSC for the VM*/

Regards
Nikunj

