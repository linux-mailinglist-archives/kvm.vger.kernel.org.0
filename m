Return-Path: <kvm+bounces-48670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09885AD06DB
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 957243B23D0
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 16:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F164289E3A;
	Fri,  6 Jun 2025 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cW8xEWO8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A76E289E23;
	Fri,  6 Jun 2025 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749228176; cv=fail; b=uBWDuvd27jMTcmjz2WKRFkwzH75qlLZpy3dIKC0Bmx+BVkzBMt38EWunmgr3g6E0tnz41/KtjLeM8kMRF1I86O+6kjSksogqBQJ7UegbIV1ctNnjjpWCZxzVsf3fy250LTwPOg/YunCJRsIdjzVn+G2jUXp+S8G/tp7qRkrIg6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749228176; c=relaxed/simple;
	bh=hBSvzWw02kN6qrkL4ejlOvZc5kzL/YwZT4OA4mPhS70=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gauG18ZY0QorfVj6E98hIkoFxHmiqW7gs5h0Habri8t9i/XvpK0jCxa7XDwvboeE/USMfiP4Hf/tBNd4MpB4TQJ3pRw06YhqiX/0e48LWE8qfblY0p/1o1F3gje4AHMDFc0+H1srvRvu/8F6XIc46pbsyDwZG5UgmQBdVqE6Gzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cW8xEWO8; arc=fail smtp.client-ip=40.107.95.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ft2YS0ul/1YPTEfKUHH0CYB8IZaJMFbE02o6W9AR7P1L2lypIa98a8oujA1cUpIEpDFLBtD/IJr78vGM9mTt7KF4w7ZxSb/1r6WaxQaRMc/g5oGMiIOtKvxRfkIm0OOA4deca1tEJwob/BuGYam//GJIww0fHFywyS8/mI36Y30hfKqDUOtkB9FZNUBq1j8ah+4jqv5OW1qTqrWUOJWS/yIXZ0r5gloIw60a49TJia5qfSCcYZkBjxIwdR9e3mKmVJ8Lrkg0s/fsfrgSyFfla+aHfgSE9Kgu+IpzPIfTXUlBScmtK/23YD80OlR13DC8FrCFk4HcAlbWuJkly2Wx3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBIiw5e9Gy+NLHnUC8CPOjdn5lfuxBFKDrvaPm5Ll9c=;
 b=pmTOw2EZFAPon+MAAFr7Kns5+36yvA+bgt+xmhK8ug+SJR9Onm1ktGM5tWjxJKgN1USqJbHNP50mdh5yE8jGSA0NQGrThZecvRq28q1N3n/jL0O5xx+mdReokmE0RSQseHdM14TGy3rBk1ZiNZNYEfr7KAPJ0F9OLqMRoJmEFmdab8qHJMYxUv9KYnOqbZr7XW1SqQ1UOLgOdvgfoxgW+REG4sTj1ShHpM/Ln0FxQ3w9sOJRDwYUVSq2C6r0n/xhGuOZHLRkgenfgujBGrvGMSy7DUDJiwJ51v7iyVah60XybyqX8DCU71bfPcpKQ6uMC96mSb26gHJzg3u5fnuEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBIiw5e9Gy+NLHnUC8CPOjdn5lfuxBFKDrvaPm5Ll9c=;
 b=cW8xEWO8IFEXLhrftUikJhorx94TMk45hmKGGpFWEHVBN4pP4cthLzSp5+ru5lWPcEzakGa9ODYTvRDcjv2f6CWwFV+qZN2g1xZsEQlYMkr0pjIpHOR4cNwdO5HPReYpg7fOBXoVDaDDl729Jy7jBy6k7O65q7qdvMvHGiKe8k0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.34; Fri, 6 Jun 2025 16:42:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 16:42:51 +0000
Message-ID: <4a7d3032-219e-c5fe-f230-78bc91eb70fe@amd.com>
Date: Fri, 6 Jun 2025 11:42:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH 00/29] KVM: VM planes
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0183.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 22a0eafc-649a-4cc8-0cbe-08dda5192d39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2hDcW5CTHRJZUpjUFhDWlNrc0xjZVZEV2MzM0J0cldZbWY1cHdraE4yampk?=
 =?utf-8?B?VkZuRW9uTTI5TTlrK0dveUEva05IZm5NSlBya1l5a1FYOWhlc09uUlVJUWNv?=
 =?utf-8?B?SlRLV0ZvaFVxb0Rac2laM1k2eDMrYjBDU1hoWDJ2U0c0b1YrMVZNUG51bnk0?=
 =?utf-8?B?aHBDbzM4NVFQYjBZcDQ2TTRYT3NJcFlYcFpHSjA2SThGblF3dVVjTEMvczlh?=
 =?utf-8?B?Qjg4WG9Va1B6ZkpHVmVBUm03ZytQUEpsU2JKSC9Xamp6SU1yZTQxeEpucXpX?=
 =?utf-8?B?RklldlZCanJ6M3VtcjhOMSs3RHRmMGp0cXdxelFRU2IyeUlDTU50aS9YU3dV?=
 =?utf-8?B?VCtNQzNOZGswaWEvQ2pBcTliNzNTOVcxM0tFMjFFbXBwZjk1bkNadUk0SEl3?=
 =?utf-8?B?REdrZDFPQ3B6L1NkTWtyNnk4WHE3UHVETFhWUWQzOUFCY1J4MVZHYWpBRnZ4?=
 =?utf-8?B?dFFnVXB4SXJTYW1QS2dCakJRc01QUHN1RmpNS3VsajJEdSt0MnR4R0Q4L2ZB?=
 =?utf-8?B?eStLSjBUQ0xNbmJyalp1d0ZyNTV0S0cwaEVaMlIzbWtMbmhrU0w4dUtLcGI3?=
 =?utf-8?B?MTc0NE1ObHBRTmMxZDJXTXE5eDE2ejcyYXUvdGZEZmR0aGhxcW40MUc1dlBL?=
 =?utf-8?B?L1dUcEg5Sk1IbGtHbjE3Yml4R3MvdktaMy9ReFFwOHlMSUZPYXMvQjR0RTY3?=
 =?utf-8?B?aGtBNmc5dThzVWNNSnlUS0YyWEJZT21obXRtMVdMb01QclI0amNBZ3hjUUxT?=
 =?utf-8?B?RGUrUG9JR2JDeTc0c0xoTU9IRVZmM3kwN1QydEZDZXRhWkVQNDBUNStsdmNQ?=
 =?utf-8?B?eG9GeTFoMytGTm9GU09iblNSZkYrYmkwMzNDUzJBSVB3YTRjUmNnVlh0Z3Rz?=
 =?utf-8?B?R1Fwa25yYU91Y0FtWWQxeW5mSWZzYVBPQ1M1K1piM0NaMjJmQzV5NmM2aUR1?=
 =?utf-8?B?c0VGY29YcmNtWi9mL3YySmg4dGxLQ1FsQjJCNksyTzgzOHJyN3RWRDJUTTR4?=
 =?utf-8?B?RnlGV3hWNngxV1dPSXcyckZNeFMyTVEzOTQxKy9VbWlBdDVPSlVRaG41YmZX?=
 =?utf-8?B?ODdmcW96QkFqeCtkbmhBaVFyL3JvS01EdHk0eFFTUmIyWmd5SW5mb3VyemRT?=
 =?utf-8?B?a0NQTE9UUGRuY2ZLVVNHc2xHZDFTL2RxL3ZDRUhpSERwdlhlcG5maHc0YWNH?=
 =?utf-8?B?TDQxcXhVUkpITWF3OVhHNGx2VGVIcm1DVkJNbmZiK09vWE9KSmpHcFVkR3Fl?=
 =?utf-8?B?MlpvZVFzZ0xOY1pwSUttM3lKc1RBY1RDRFkrNVlvQ2laaVNYMGVyUGlackFs?=
 =?utf-8?B?cjB1a0xtZ0VzM2hoLzEwa0owRVFTTXRSeUJRQnhJbUQzTHhvZnRQUmJGamxJ?=
 =?utf-8?B?K3dGaCtEeVltQmNSczBvU1JERlJWSytVQVp2QjA0bUJwM3RpTlpYSzE2WjdH?=
 =?utf-8?B?TXYwTDY4cm1zSFRNSEl4SjZpaUlYU0RTMm9ZOVc3VnFGQ0xaWS8xZStqWUti?=
 =?utf-8?B?d2o3eFhjdWlJSVVEY2JEbVgvZ05sVVUrZ2hLdGY5VEpBZklvb0RHV0hGSFNl?=
 =?utf-8?B?Qll6TUxUVDlMNTZiYS9JNSticGdOY1hnckJLcGZuOUlueUJ6RE8xU1FZOSs0?=
 =?utf-8?B?TW9NdGExbGRFUVYvTU5tbmQ0c296SDU1bzdSU25WMC9sL3Nja1VrcFhwTG1i?=
 =?utf-8?B?QUpNd1A3ekt6SGFCVGpYbXNhcVluMnQveENtYmtqOVVZMDFwZTlQMnYwTTY3?=
 =?utf-8?B?UUZQZC8xQU5ycCs4c2FUVG1EcEs5eGM1WVVpd2J1Nm5nYXJoVUx2K25BcVdr?=
 =?utf-8?B?ampjc1NmTmhDMXd6aXI3emVNOXIwQnp1YUFNTjJTSlBrQjYvbFdodDZiMFZY?=
 =?utf-8?B?ZVVHVExvSzdFWkFQTlV2TG1kS05HNklmc3RRcTRKVjZKd1R4Z2V2N21LVUJ3?=
 =?utf-8?Q?YYS9OGu94IY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTFOd2FoTmZSWDU1TkVoU0xUSjBoalRjeWJEc2xqK25pUk56eHN3MkJjSlJl?=
 =?utf-8?B?RmQrMmNENEhKL051eEFCcU5iRmx1WDBlOFIzV3hkSzRLZUJqQlJuV0hQR1hM?=
 =?utf-8?B?U0trdHAzOHdKRytOaGROVnhtZUhXWkV0KzZBRDNLSGwwRGpKdHBCNjMvYjRH?=
 =?utf-8?B?Uy94YSt6enpqb3hpSlFnbmRUY2haenVHV1kvS1dHeEE1bnVPRFIvR241UzlG?=
 =?utf-8?B?MUVXUDAwZEZDK3hjNFNFbE8vcXBGYmhQNndScGhGRjdSOHhGTEFMUFBYQzZs?=
 =?utf-8?B?MTI0Z2RXeFkxM1FldVM4TmovelpvcFBqU2Q5R2RUUGVsK1FQQk40RlBpRFF5?=
 =?utf-8?B?am43aG9McklwYXJteWxiam1TL1Fxa1FlUjZmeEFFSE1iUmNHb3BvaTdGYlRG?=
 =?utf-8?B?NTlrVXRIWE1RSTQxZ0VTZ2haeWl6eWtvQ3RjWm1ScHpMdlE2aGNUYVdLZkxV?=
 =?utf-8?B?cEZrbzhHWUt0SnliZW9YMzVPZDExbWxMZm9hbmhwZDZXbDU5QnlOYnFnZmxB?=
 =?utf-8?B?MENPOFdiengxcXIrL1BVb2p1azlPc2lDcVdyaVJWWjJsbTZEWFQyWVg0ckpQ?=
 =?utf-8?B?blhyM2hLckpOUlZ5R0lvUEhyVDNHbnhOK2hXMlNDYm5FalNlb1hueDBUcTk0?=
 =?utf-8?B?TXBNaTVmTkdMRFdtdFRXdW01UVlxRGs2dXZqcDR5eXBuMmpla0dpRW9mN1hx?=
 =?utf-8?B?TmxJdHNZYVRGRFk1SWlIckJwYnJBZUthTzV3MTZXRzZwaGNCZ2ZNZlBYMDZz?=
 =?utf-8?B?d09FcHhZNzlBRUE5R0ordkZwdHR6UEVFem1NUTBTZGdZVjk2NEJIaHp5NlpO?=
 =?utf-8?B?ZU90bzFORGw0RWpINElFa3djNGZvMHFEN3R6WWJTYVNqNytRcGwrQ0pFNEg3?=
 =?utf-8?B?TjRIUkdsMDNPOXY0cHM3YlZQWHBrOFlPTFlmdER3cUpYNWNhNGJtWjFEd09t?=
 =?utf-8?B?NmdOK1NSNUNGVGR0NmdtUFAxaU1iRlRrVDRkYzAvMCtSZkR3L0N3VHJoYVk3?=
 =?utf-8?B?SzFCdTFUSTV6djlHVWU5b2VBdSs2RE5KekQyWkFFSGNyWTFVRFVXQVY5Y2dy?=
 =?utf-8?B?dll3V0ZibWc1Y0tsRjhUY3JzOGVWTlRtb0JPMVNrcE9CMVN6YndQRThVSXZu?=
 =?utf-8?B?U05hMjZ1bnpkR1YvSEJEQU84b2Q5TmNCS0Jpc2pLYVRHV1MweDV2U0ppWGdG?=
 =?utf-8?B?TGFNTk9YWjZRRXhKdVY4YmJGL1JLdUIvcDhUaHBNMWUvUUZxT1RzZDNPWjk0?=
 =?utf-8?B?ZU5kbWViOWxIdnVheXZ5WTFuajhZSGQ1R1htNklNS0hTQ0d5bHUwVjUyUzk5?=
 =?utf-8?B?ajMrQ0VOVFBBaWY2VjBmdkQzMlFBTTRTdkUrVkVXMkkvNEJCbFZFQWx5VG1K?=
 =?utf-8?B?aVh6OEJ6aWZyNEttekZJWjlHa2txbWh4MDU0R2hSM0JvRXhUclBnYkZua3Fu?=
 =?utf-8?B?eDZNTG5rRW5pNG9IRDNLbWZ5TWFwRGo4Y2dUWTFkMzFORGFGcXptN2NsMzZM?=
 =?utf-8?B?dDVYQldnUFl2NDBiUG9xd0Jxdm1XM1NhcE5tVStYUUM0RUJSTjFzWllxSnBm?=
 =?utf-8?B?eVBBVnQ2N3V1SnZoOGx3YjhLRWR2M1pLM2p3YlRUS3RlV2cvR2IxK3RnMlU5?=
 =?utf-8?B?K3pwZGdOUzVmTlZuRi82dFB1ZlVHNGxGMU9qdzJ0bS9ZRGswVjFUU3R0Ynps?=
 =?utf-8?B?TGtFZ1NIbTNWMXlpSUFUem9qRk1QTUw2RG0vZWd5RDdrYTNTQ0RVcWJyU254?=
 =?utf-8?B?Mjk1cElHa0l3RnBtZVBtMXBiSURORHNHQkRGa2xlTUhoL0dQU3hDbGNwMVIr?=
 =?utf-8?B?bWJYYlFzR21JVzZ6WUo5NjhkMG4zbkxicTZoR2pZbzdhOGgrSkx5bzBxVFRX?=
 =?utf-8?B?N3NCSTJuSUtEbjhsaE1UbndNS2VJeEo0SWRJWTRETUY3UGFBNkRWN202cjNZ?=
 =?utf-8?B?SXoxeHJZMFVZaDcydktyRVdSNjl6Z0FDVEI0eDNHam1iK2dObmpNSDlmajVM?=
 =?utf-8?B?UHB4Mis1WUtBSHBZdUtudUYwYmdzVWwycittQ2FCVkJxc1VvdDNiTWU0SmRQ?=
 =?utf-8?B?aDZXdFladUhMY1NVS0tFc09ncVJYWnFQOGdTeGJwUXMwY0NXWHR6OEtvMmJ6?=
 =?utf-8?Q?JwmWtN/N5Wz71jNQcJUSXCwNM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a0eafc-649a-4cc8-0cbe-08dda5192d39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 16:42:51.0765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsVWF9Ns0Lef2K//ufATMyMaWqRQQ2Zv2gDdc012XsRpsll24zpfqBnPMMWJxbpnIkmDm5KXEEn5LBPhwd95oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6373

On 4/1/25 11:10, Paolo Bonzini wrote:
> I guess April 1st is not the best date to send out such a large series
> after months of radio silence, but here we are.

There were some miscellaneous fixes I had to apply to get the series to
compile and start working properly. I didn't break them out by patch #,
but here they are:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 21dbc539cbe7..9d078eb001b1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1316,32 +1316,35 @@ static void kvm_lapic_deliver_interrupt(struct kvm_vcpu *vcpu, struct kvm_lapic
 {
 	struct kvm_vcpu *plane0_vcpu = vcpu->plane0;
 	struct kvm_plane *running_plane;
+	int irr_pending_planes;
 	u16 req_exit_planes;
 
 	kvm_x86_call(deliver_interrupt)(apic, delivery_mode, trig_mode, vector);
 
 	/*
-	 * test_and_set_bit implies a memory barrier, so IRR is written before
+	 * atomic_fetch_or implies a memory barrier, so IRR is written before
 	 * reading irr_pending_planes below...
 	 */
-	if (!test_and_set_bit(vcpu->plane, &plane0_vcpu->arch.irr_pending_planes)) {
-		/*
-		 * ... and also running_plane and req_exit_planes are read after writing
-		 * irr_pending_planes.  Both barriers pair with kvm_arch_vcpu_ioctl_run().
-		 */
-		smp_mb__after_atomic();
+	irr_pending_planes = atomic_fetch_or(BIT(vcpu->plane), &plane0_vcpu->arch.irr_pending_planes);
+	if (irr_pending_planes & BIT(vcpu->plane))
+		return;
 
-		running_plane = READ_ONCE(plane0_vcpu->running_plane);
-		if (!running_plane)
-			return;
+	/*
+	 * ... and also running_plane and req_exit_planes are read after writing
+	 * irr_pending_planes.  Both barriers pair with kvm_arch_vcpu_ioctl_run().
+	 */
+	smp_mb__after_atomic();
 
-		req_exit_planes = READ_ONCE(plane0_vcpu->req_exit_planes);
-		if (!(req_exit_planes & BIT(vcpu->plane)))
-			return;
+	running_plane = READ_ONCE(plane0_vcpu->running_plane);
+	if (!running_plane)
+		return;
 
-		kvm_make_request(KVM_REQ_PLANE_INTERRUPT,
-				 kvm_get_plane_vcpu(running_plane, vcpu->vcpu_id));
-	}
+	req_exit_planes = READ_ONCE(plane0_vcpu->req_exit_planes);
+	if (!(req_exit_planes & BIT(vcpu->plane)))
+		return;
+
+	kvm_make_request(KVM_REQ_PLANE_INTERRUPT,
+			 kvm_get_plane_vcpu(running_plane, vcpu->vcpu_id));
 }
 
 /*
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9d4492862c11..130d895f1d95 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -458,7 +458,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	INIT_LIST_HEAD(&sev->mirror_vms);
 	sev->need_init = false;
 
-	kvm_set_apicv_inhibit(kvm->planes[[0], APICV_INHIBIT_REASON_SEV);
+	kvm_set_apicv_inhibit(kvm->planes[0], APICV_INHIBIT_REASON_SEV);
 
 	return 0;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 917bfe8db101..656b69eabc59 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3252,7 +3252,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	 * All vCPUs which run still run nested, will remain to have their
 	 * AVIC still inhibited due to per-cpu AVIC inhibition.
 	 */
-	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+	kvm_clear_apicv_inhibit(vcpu->kvm->planes[vcpu->plane], APICV_INHIBIT_REASON_IRQWIN);
 
 	++vcpu->stat->irq_window_exits;
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65bc28e82140..704e8f80898f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11742,7 +11742,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * the other side will certainly see the cleared bit irr_pending_planes
 		 * and set it, and vice versa.
 		 */
-		clear_bit(plane_id, &plane0_vcpu->arch.irr_pending_planes);
+		atomic_and(~BIT(plane_id), &plane0_vcpu->arch.irr_pending_planes);
 		smp_mb__after_atomic();
 		if (kvm_lapic_find_highest_irr(vcpu))
 			atomic_or(BIT(plane_id), &plane0_vcpu->arch.irr_pending_planes);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3a04fdf0865d..efd45e05fddf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4224,7 +4224,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm_plane *plane, struct kvm_vcpu *pl
 	 * release semantics, which ensures the write is visible to kvm_get_vcpu().
 	 */
 	vcpu->plane = -1;
-	if (plane->plane)
+	if (!plane->plane)
 		vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
 	else
 		vcpu->vcpu_idx = plane0_vcpu->vcpu_idx;
@@ -4249,7 +4249,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm_plane *plane, struct kvm_vcpu *pl
 	if (r < 0)
 		goto kvm_put_xa_erase;
 
-	if (!plane0_vcpu)
+	if (!plane->plane)
 		atomic_inc(&kvm->online_vcpus);
 
 	/*

Thanks,
Tom

> 

