Return-Path: <kvm+bounces-51004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF512AEBB07
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 17:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E652E3BC95D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326302E88B1;
	Fri, 27 Jun 2025 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WZL2Yr/J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935D62F1FCB;
	Fri, 27 Jun 2025 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036894; cv=fail; b=CwsO+Js4UL41hlqbYaumPubhFEO0aJuAL6O2+E1K0BuM01KzJWdqLoCsKimqwtuWVVTqGMAy6MCs/Q8zTU+ravqQqbvsaJ47/sNRUlYtRY6Dq072rKqYDbRZwFGCS3NQZnDb0URgrkeLVy/+vWIKDOOmp1tcxMmkhnCt9WNpDO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036894; c=relaxed/simple;
	bh=sX+XJq4dANl0cWcpE4jWhQvmx6vInsr531JoUNEydck=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EXTlU/jYPHS1O1vNLm3OH6IDIyLuOBpGlxXc1xSK1Om75DLBPnrwxqE8pkdjoo+Ke1qetb0aPHjP4JHWJzVbv+NTGDfK1tgyVbmgyhlvzT7dJfW+Y7Wp8jw97kY75/1oJKYXrQGZYJjyGaxRNMRsTaBe70E50Q7FXMX5QrublQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WZL2Yr/J; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZHz47vUXTXmXKpVM7h/ZG8i5MXjfgC7VLbBZM0z0itrUXwGRUjmDYla0FBXA92sw1OsmWKDcekEFTFNxuDloHAYyfrCeFM00qFDCU7pSJIT6CWrIpm7SEU47Aa42tmTB9IQCFtKV5YHzgS8Y1QDRd9C7RWiUR2++5tPe40WZGUwl1AK9TJU2VuzQvIV/zXfbKOH3AFzgvcVtuVXChTgVE4htA6G6eFSLWboailzIMQqWP1kfW01vZ6P6qKDHBUBNZnNX4mI2Jdpa3qYkrQSskXYiLgiDSvPDyzl6Ant9oCk9h8YQcnmy/YXc91ZFPl8DpBg/+14vvUEeeZjDJ3Fzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBAFp4kfNEXca9q9miqvbnqPXF45GPLeGSoAt3IbnA4=;
 b=f3GyNZKHhDG8OzJD7AENkVOY/Ue842JpfTJdYtUBHQeAIFS+FeCur2MfAVosRmPFTJ7OaAmNvBXOhibtVbclpauq4MNOBUHQl7YLZvajInCmpy391pC+rOvrtnbZUCM6d5cZxsU8XicJ+Fcm7eqS3t7qY1AFQxjNsR47Sxf0UTb9nrCJFU9Ab7rioq6TLWavlwvbG3ZAubDNCDJH1ByEpF0gLEyIpU9ZwxMZHx11HW0pO9/u2mpUgovJkrdzMcgQlAAlzg0uOgWsabpVIKOKnztBoh5bMbY1X0Hr/pHPJNAlGUr72FDqYJfznmz0snoFjaSHJcSmHCLVBgh24BFE4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBAFp4kfNEXca9q9miqvbnqPXF45GPLeGSoAt3IbnA4=;
 b=WZL2Yr/JVj3KOG5nYohmZflGXP9jZ/aGitw+F5mVu2xGBSk+WWAlhxl/StKOW1k//gBoN+T5avDh6rBCYUmKLI+2HrE2dWVQTsQ5hcaSSqIVtIqijdXRpQVBc10znCs62qFAL/QtI9SSQjUerQ9nVR196rV+m+NdYRdq81AoPuY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.25; Fri, 27 Jun 2025 15:08:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8880.021; Fri, 27 Jun 2025
 15:08:07 +0000
Message-ID: <c0b8e728-f775-1023-055c-4f879bbd784a@amd.com>
Date: Fri, 27 Jun 2025 10:08:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/6] x86/sme: Use percpu boolean to control wbinvd
 during kexec
Content-Language: en-US
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, kirill.shutemov@linux.intel.com,
 rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 reinette.chatre@intel.com, isaku.yamahata@intel.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com,
 sagis@google.com
References: <cover.1750934177.git.kai.huang@intel.com>
 <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: e21353cb-3fcb-4525-b935-08ddb58c6c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djVYSnk1cjZheHNlV3k3L2gvN1gzeVdCQkF4YTJZZDk2ci8vOHJVNEVzTkVo?=
 =?utf-8?B?VmlOaUN6TDdTanY2Z2dyaUVUMXlVQXBiNGNMYzZhcmRvMmJ0bkpieHNlclNK?=
 =?utf-8?B?WGZXTGNZWlVqT0tXblNJUjhDU1RpemhFdmw5dlphOUFMdDN4OUpWMUVJYkZY?=
 =?utf-8?B?bWhTakFrWXlUNzdneGk2cHYvZ1J5ajNuUE1vSVR3NEZMYmpVZ2pnYnNPZkpw?=
 =?utf-8?B?dzVCdktoYlo4OS9JNFJDN3V0TnMxWEMrYlZwOGtQUkRJMDhQN0VWdzBGRkps?=
 =?utf-8?B?MkV0aGVyK2pJV203TmM3a0U2Rmg1TW9pQzdDbXIzcG14MzM5RExkRkM5Q0N4?=
 =?utf-8?B?UkV1MUlneldqUlIrcks2bkNFZ0VZcm1NOUZlVGxmTWRUR21qcXQ3NGozbGJZ?=
 =?utf-8?B?dG4rdE90TmkyY09sZ2J3L2s3dmdpRThMQzRQdnI3VHRoNytja1hhTkJXYTd5?=
 =?utf-8?B?ckRQL0NtaTIwTnpHaW94cjN2bDl6V1Fya3BSYUZLck5sbFYvd1YxNU83bGpC?=
 =?utf-8?B?K0VuMDRTQ2VLU0krallqWkRhdUQ4eFJpVjhqZDgzTURJMTBab0h2WG15elUx?=
 =?utf-8?B?S1E3Mk8yaHpUQ3UxYmZRMnZZdm9BSlNlakJVSHRuSFcxL3Mra0s3dGNGdi81?=
 =?utf-8?B?a1c1aHVwV28xV2pCMG8zN0l4WkNvdjNiVEMwWXNFQVQ0WlNTZFU0OHV1VGE1?=
 =?utf-8?B?WDROajFtbUI3N0FqVFhJTTJtTHhRSEtiSGtwRi90RkRZN3BjcmNPeHYxVi9N?=
 =?utf-8?B?RThYRHovQVBJL2JLWU0yd1UvU1pBakloUnE2dlRnSjVhREd5V0hMSEdsSlpn?=
 =?utf-8?B?STJTNFpXQ3U5RkZ0UytCbnE5SDNLNEJHdkt0d3N1QVFrME5HajlyYmJHOE92?=
 =?utf-8?B?RmROd0lPOFpCQUJXUlJBbWRCdnpDN0M4TXkyL0lLdFcxQkEwU2lZVisvNjZE?=
 =?utf-8?B?cU0wMlA4S3BVL1lFcVBuTGIycXVKZUpQVFF5NThkK2NzWHNwcmdLYklDbEVE?=
 =?utf-8?B?dFdmNTdPSFM3ZU1FZjJlNzk5aGlLYXdBZWxBTjI2bFNhK1NBVk9JZmFLeVJH?=
 =?utf-8?B?c1poaU5SNWJVZ2VwbmpFbUk2Y2x6Ync2QjlUaS9QR1JhQzNVdHF0U1ZYUUlT?=
 =?utf-8?B?aytPSXZIMWNSZG9iQVgweWhadDgwZWx2Zkc0bUZwdGhJayswNHRHekwybWVM?=
 =?utf-8?B?R1dtT0VJTlBTK3ViQWdzdXR2cklXU3EvZHJyc1ltUm1DQ3lGZFg3NVZscUth?=
 =?utf-8?B?cVNTelJoSG9SWFdXM0graUpVRS91cTI5dm03ZlRocFJJTFdyMWhETWgva2NR?=
 =?utf-8?B?K3VaN3hFbkhiSmtSWmc0NXFlZGc2RVhyNW9BMXhuTVBDY3ovRlE3UlpRNXlv?=
 =?utf-8?B?bGtDM1pkUUM4Y0FROWM5Q3JjQkVzWmNsOWVaK2hrYmRrWEg0NzNrQzREV2U1?=
 =?utf-8?B?bEU0WWY1ek5KUnJOZk5wTDJBdElGL2ZLc0hTVmdscm1MOE9KNEJGeVhaeFNz?=
 =?utf-8?B?L3gvSUxJMmlTeGlaSS9tb2s3QmZCTExpb1RzUlE2SlhGWnNRY1M0eXU2NHps?=
 =?utf-8?B?VTJjVnNTTUw1WGJVbFQ3a2lYbmpqckNvTjA0Nzlkc2k2RlFDOWRDU2RBYytF?=
 =?utf-8?B?ZTc0dHNoVThyM0xzSGRlU0FnQTNpR3B2TVZhZEs5V0doeUJ1ZGFWLzRaZW0z?=
 =?utf-8?B?UU5Kd3VzL0lDSHo3NWd6amF5WCtralFmbkNJbitLbkUzSysyWk9LeE9DSnJz?=
 =?utf-8?B?N2R2SDBhR1pCRU8zY01qSFFUeE9pMUgybnVUMFJteXlDRExQcjRsb0ZYVHNM?=
 =?utf-8?B?cXpibVA3eDR5Zk9HcTY0L1NUK1BJL1VTYUxQYVVEd2J1MEtSQ1ZITUEvSGhT?=
 =?utf-8?B?YXlyaEMrZklQYlFudkdHTGVWT041bHZaZDBac0dxSndRRlNoL2p4T0Z1bWlq?=
 =?utf-8?Q?hwxNt6CqeJs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWVsTUJEemlIZ0hyWmdMZUEyM3hORnJnYk8zQmszSWJoMkMzVHpVdTFGR0xD?=
 =?utf-8?B?cDhkMVZOKzNDZjJodnNNbWw4dDRBcisxQkdaWkZITHdWVzg4K3ZJN0lNK1pr?=
 =?utf-8?B?UUF3NEZ4d0V2V3pPNUtqbkliWWJiVnhzOCtXU2ZBbmhWdktJNC81SG1FVjIy?=
 =?utf-8?B?dmVVWEhYYUpnRS9kTVAyUU9EckFXSXFxdnJ1d2U0enByRk1ucEg2cGhoK2hZ?=
 =?utf-8?B?VzQzS2hzc3dMdkxNMHpyNW5RM2FMLy9wM2NNQTJBWWNBTzAvN0VsTGV3RTYx?=
 =?utf-8?B?ZTJUYWx0dnlId1Nwd1hZM0VnTlVrUC96WkdFSzJrWEszZ0ZRN1BYanVRTDZB?=
 =?utf-8?B?NmloRENCRGZwd0pkYlc5WFp6Q3NMUk5MZFV5SWhrclBYYnRHNDFsOERKMVRl?=
 =?utf-8?B?TWlqSkRyT0FjcFlqWmtNVmEzYmI1L25GU1IzN0x6UGp4K3M4dmtuZWxOVCtV?=
 =?utf-8?B?SnZuOVZXb2VwVUFGRGdWQ3BRY2dlUFNBY3MzakJoN1dWOEpQazJSYWV5N091?=
 =?utf-8?B?VmgxSEJ3NkM4N1gxZnVDcUtaZ21hQXl3a1NvdXV4Y3BmUE1EUTdIK0RObS9W?=
 =?utf-8?B?L0g1QktXZlJTQ25ubmxzamtHdFVOQzZMQ3VoNmFhMURyYUdUS2dMZXVlYVNB?=
 =?utf-8?B?aG16QVJxYzQ4cS9YYjRUUlNoT0pDa05kRUU2Mi80N2hXYk5zeld2ZzU1UkdT?=
 =?utf-8?B?NUhLTWxkcGpETTJsUUwvblM4V29oeThFbENOMXdva09LV2FxSEw5akpCMEJw?=
 =?utf-8?B?aktVZVNoeGpQSG80Y1hRQnQyTFhrdzhKTFBjVnp5OWtSMUZiL2NSWHE2OVk3?=
 =?utf-8?B?UnJOendNWE5reG1UdGxwd1RabldyTkJ0N3IwQUdZSHBTeG5QUlM0N25XMkl1?=
 =?utf-8?B?MVJBT29kQkMrRFh1LzNHOFhzakFtZ1lRRzF6UUcxUTg2SkVYUk5iZFpTSStP?=
 =?utf-8?B?NUVVQU11L3pPSHVFaCtBT2drTTBhVkRoYlZjT3lRWVJVYkNWaGx0VzlSemJm?=
 =?utf-8?B?Wit0OCtzZHJpSnZVc09TWWh4Ym1KS0RUUGNsa3dEdUJ6c3JlVXFvTmkwQUkr?=
 =?utf-8?B?QW0yNWJOS3BacHByM0F6UmtHRmppYlQrZkVaWVRscm5BMjhEa3lCY25aakdu?=
 =?utf-8?B?VHROWXc0NFlwNHM1YkxNdUhiR0RLdjJ5SC9sRzVtck5WSE54RVQ1MCtwL3JG?=
 =?utf-8?B?TmdmdzliWUs5QlVxb1ZaU3ZtckQvSzR0Q2FZclJNNE9Cei9obkc1cFlMakRk?=
 =?utf-8?B?WFU1OURqYWMzTUVHemY1K0JsQXJsQXhPUlpzVHgzU2JteFR1SUl3emJWbFB2?=
 =?utf-8?B?eE15a1J3MUsvUGQvdkNXMFhSbEFvMTl1SThVbklPcUJPZC94emdFNFJOalhF?=
 =?utf-8?B?V0tQYmd5RnhZODI0M2ZzRXBsNWRZRGRxbGJJb3RmQmxucy9OZS9IUnhOR1Fr?=
 =?utf-8?B?YVZrMjVnMFNNMUZFd0xWZEZmd2lDWW1EcE9ENitzTUFVTXpzRFI2OGFVdlRn?=
 =?utf-8?B?M2FnekdXakZNR29kamxrRkRySVkwQXArZEVrcnR1cE9IWlB3U1R0bGZjOTg0?=
 =?utf-8?B?eDgxNU42UWNqWDhwTTNldnR3N0x2NjZSRnFoMGtvZmtLZjE2aUNvbmZmUW9L?=
 =?utf-8?B?TlJkKy9pUGJBaW9mQlA2WEVNcXF2Qk9UTFBkcUJFU01ZNWlYN1NUak9KWFI4?=
 =?utf-8?B?QzQxV3o2VDJ4ZkxZVFMvZXZuZzZlZ0svdkJDdnE3Tkc3NmM3OS9KNnNZK1U0?=
 =?utf-8?B?TnlXbmNDMVJCZ0ZhcGMwMXBSUEFRanc2eHExdE1reWYwdVBNQk1BR05rUFlh?=
 =?utf-8?B?Rng5V0xiOVZoNWN1R1ArVmowbkgzS3lFKzJ2MkhPb0ZUMWlwMXhBUXBETXRK?=
 =?utf-8?B?MUgzWE00Y3VKeHVYdlA3UXh2d1h2dFp1OG9kdkgxdnN0dTBVR1RDdk1MMEtk?=
 =?utf-8?B?ZllLNXl1TVBMUXQvamgvQXljMnN4YWZHTGhIdDhhNjBaN1RDWjhRZ0s4dzhL?=
 =?utf-8?B?djREZTRENHU5eWFqRVZwQThKYmN5Q0NHejZ0RldDeEhhV1dTdEVSNE5UYzRy?=
 =?utf-8?B?czBZQmR5NHZZQS9JeDdxR2pQTjAxa2NxMEorWG0xaVhHc0RWaWJpNkc4VFFt?=
 =?utf-8?Q?Zq4hOnNUIu1dbVyj4uEe6d/G4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21353cb-3fcb-4525-b935-08ddb58c6c49
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 15:08:07.5357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCpNzSJxQ5a2HFzt6JeT4NOA77FHAB03QIN80LhKz5w1L6XlxI5/sGd+tCMpXxQEB+t7qcQ5mXiRTATa5b5Otw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389

On 6/26/25 05:48, Kai Huang wrote:
> On SME platforms, at hardware level dirty cachelines with and without
> encryption bit of the same memory can coexist, and the CPU can flush
> them back to memory in random order.  During kexec, the caches must be
> flushed before jumping to the new kernel to avoid silent memory
> corruption when a cacheline with a different encryption property is
> written back over whatever encryption properties the new kernel is
> using.
> 
> TDX also needs cache flush during kexec for the same reason.  It would
> be good to implement a generic way to flush cache instead of scattering
> checks for each feature all around.
> 
> During kexec, the kexec-ing CPU sends IPIs to all remote CPUs to stop
> them before it boots to the new kernel.  For SME the kernel basically
> encrypts all memory including the kernel itself by manipulating page
> tables.  A simple memory write from the kernel could dirty cachelines.
> 
> Currently, the kernel uses WBINVD to flush cache for SME during kexec in
> two places:
> 
> 1) the one in stop_this_cpu() for all remote CPUs when the kexec-ing CPU
>    stops them;
> 2) the one in the relocate_kernel() where the kexec-ing CPU jumps to the
>    new kernel.
> 
> Unlike SME, TDX can only dirty cachelines when it is used (i.e., when
> SEAMCALLs are performed).  Since there are no more SEAMCALLs after the
> aforementioned WBINVDs, leverage this for TDX.
> 
> In order to have a generic way to cover both SME and TDX, use a percpu
> boolean to indicate the cache may be in an incoherent state thus cache
> flush is needed during kexec, and turn on the boolean for SME.  TDX can
> then leverage it by also turning the boolean on.
> 
> A percpu boolean isn't strictly needed for SME since it is activated at
> very early boot time and on all CPUs.  A global flag would be
> sufficient.  But using a percpu variable has two benefits.  Foremost,
> the state that is being tracked here (percpu cache coherency situation
> requiring a flush) is percpu, so a percpu state is a more direct and
> natural fit.
> 
> Secondly, it will fit TDX's usage better since the percpu var can be set
> when a CPU makes a SEAMCALL, and cleared when another WBINVD on the CPU
> obviates the need for a kexec-time WBINVD.  Saving kexec-time WBINVD is
> valuable, because there is an existing race[*] where kexec could proceed
> while another CPU is active.  WBINVD could make this race worse, so it's
> worth skipping it when possible.
> 
> Today the first WBINVD in the stop_this_cpu() is performed when SME is
> *supported* by the platform, and the second WBINVD is done in
> relocate_kernel() when SME is *activated* by the kernel.  Make things
> simple by changing to do the second WBINVD when the platform supports
> SME.  This allows the kernel to simply turn on this percpu boolean when
> bringing up a CPU by checking whether the platform supports SME.
> 
> No other functional change intended.
> 
> Also, currently machine_check() has a comment to explain why no function
> call is allowed after load_segments().  After changing to use the new
> percpu boolean to control whether to perform WBINVD when calling the
> relocate_kernel(), that comment isn't needed anymore.  But it is still a
> useful comment, so expand the comment around load_segments() to mention
> that due to depth tracking no function call can be made after
> load_segments().
> 
> [*] The "race" in native_stop_other_cpus()
> 
> Commit
> 
>   1f5e7eb7868e: ("x86/smp: Make stop_other_cpus() more robust")
> 
> introduced a new 'cpus_stop_mask' to resolve an "intermittent lockups on
> poweroff" issue which was caused by the WBINVD in stop_this_cpu().
> Specifically, the new cpumask resolved the below problem mentioned in
> that commit:
> 
>     CPU0                                    CPU1
> 
>      stop_other_cpus()
>        send_IPIs(REBOOT);                   stop_this_cpu()
>        while (num_online_cpus() > 1);         set_online(false);
>        proceed... -> hang
>                                               wbinvd()
> 
> While it fixed the reported issue, that commit explained the new cpumask
> "cannot plug all holes either".
> 
> This is because it doesn't address the "race" mentioned in the #3 in the
> comment in native_stop_other_cpus():
> 
>         /*
>          * 1) Send an IPI on the reboot vector to all other CPUs.
>          *
>          *    The other CPUs should react on it after leaving critical
>          *    sections and re-enabling interrupts. They might still hold
>          *    locks, but there is nothing which can be done about that.
>          *
>          * 2) Wait for all other CPUs to report that they reached the
>          *    HLT loop in stop_this_cpu()
>          *
>          * 3) If #2 timed out send an NMI to the CPUs which did not
>          *    yet report
>          *
>          * 4) Wait for all other CPUs to report that they reached the
>          *    HLT loop in stop_this_cpu()
>          *
>          * #3 can obviously race against a CPU reaching the HLT loop late.
>          * That CPU will have reported already and the "have all CPUs
>          * reached HLT" condition will be true despite the fact that the
>          * other CPU is still handling the NMI. Again, there is no
>          * protection against that as "disabled" APICs still respond to
>          * NMIs.
>          */
> 
> Consider below case:
> 
>     CPU 0					CPU 1
> 
>     native_stop_other_cpus()			stop_this_cpu()
> 
> 	// sends REBOOT IPI to stop remote CPUs
> 						...
> 						wbinvd();
> 
> 	// wait timesout, try NMI
> 	if (!cpumask_empty(&cpus_stop_mask)) {
> 		for_each_cpu(cpu, &cpus_stop_mask) {
> 
> 						...
> 						cpumask_clear_cpu(cpu,
> 							&cpus_stop_mask);
> 						hlt;
> 
> 			// send NMI 	--->
> 						wakeup from hlt and run
> 						stop_this_cpu():
> 
> 			// WAIT CPUs TO STOP
> 			while (!cpumask_empty(
> 			    &cpus_stop_mask) &&
> 				...)
> 		}
> 						...
> 		proceed ...			wbinvd();
> 						...
> 						hlt;
> 
> The "WAIT CPUs TO STOP" is supposed to wait until all remote CPUs are
> stopped, but actually it quits immediately because the remote CPUs have
> been cleared in cpus_stop_mask when stop_this_cpu() is called from the
> REBOOT IPI.
> 
> Doing WBINVD in stop_this_cpu() could potentially increase the chance to
> trigger the above "race" despite it's still rare to happen.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/kexec.h         |  2 +-
>  arch/x86/include/asm/processor.h     |  2 ++
>  arch/x86/kernel/cpu/amd.c            | 16 ++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c   | 15 ++++++++++-----
>  arch/x86/kernel/process.c            | 16 +++-------------
>  arch/x86/kernel/relocate_kernel_64.S | 15 +++++++++++----
>  6 files changed, 43 insertions(+), 23 deletions(-)
> 

