Return-Path: <kvm+bounces-39049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E67AA42F25
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:32:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1D4A16E911
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A441EEA29;
	Mon, 24 Feb 2025 21:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IghBkc8l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EBA1DD88B;
	Mon, 24 Feb 2025 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432697; cv=fail; b=tQWxplXsqzFQxs2h7ZtPNgTs23VsjzhITaYT8Da+8RiF2rMpbGYkHHhIUPUy0sMhi9FtpJmNfWYLA+BFVwQD5j4ErGuYs33KcMfHNDrvmDjVCIR2ufuWWEnS0ZeM6AzEqoofbJ5mT25eNTHFh2yu8cXDrNhVGiOypTaLAYTzISM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432697; c=relaxed/simple;
	bh=rL7C9UY/6S5VdJNuDhnxjZO87xqh5peiG5DrixfDoaA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=Rut1shurNh1hyckZgRaQFwfQrwjwveLxmBQyNVbMFbTBa/jBNGEA3ZCL4v1NZZRq+Skc+8dlqbKDbyBm2aydy0JlI4JJuQTymupu9tkBNBJu6epGozmUh0ZiWyp4ECkEvpCQxt9bhSIOhfVh78QVqw/iSP88iS0jSSet+FdXDY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IghBkc8l; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DTE7qVqmyWWOv9biXM1GQ/OlPwmgwOiKeiwcmbQX40UEmQGFGDQNwU6E8NRBUodP9JTa4RD7usiq9ghIXlzRqF3Rwvs8aUMh3WxgGHmAC9tRnA2w+J2E+WuY2nFP1ttKXgTPchKkrp7b8+/fPVT+K0470SqtM1jVwMGaWDjMNKih5ny1/nQh5js+318MauotMFldzsBnqfHoLTDVn+5Kb6JsgMUTcPJG3a8uynzYeAYKT+15A00bhaDoo6dqsHgcmT71fpN5jUzoei8y9RYHcW4lyvI9Le2/DNKniTFYETOfPPrCeDm4btsDKMXgWrbQiAPWEYIb+LI2tl4mVzHPgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dEnm61h71jgyz6hFOQiMo4GNZ1OXQHqhZR6vTBUT68=;
 b=U0+J/mf2EHJSuJYlDaYWjOEYZ75g2kDExOkj0xMTAn4kimNUsYmTX3405cW+JogLMbWfmkGTOJoMs7SsQAVlutBC44gUWA8RBJbJbrsLy9pXdeeVxfKrrck5hP/+u3BDUv8gVXzrAOsQg4Vt/jcjDPTBOPL72P7omi8zmm50FQmrzIHH5fLNubddyEePtO8DcvwW48XVfKPBOJ1EzBo9ASQTOjcekF0SuoxOjZznlftG2UeguwzEf2gKAqrHmZaQpA5/Q6pkXpbttVkJBUr8Lf/en7Av9NUHGRt79nULOLm8bLSbjVj93i6raVwa1lTaW3nQNRDuRqYb/xUCWX4K0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dEnm61h71jgyz6hFOQiMo4GNZ1OXQHqhZR6vTBUT68=;
 b=IghBkc8lPU28rd27cWKH1IeJ9ocMqu+IJfKY4megqxzFgpFTbKE68eO8neDsllrOxXfjwxiZ9OS15Sphw4yPy/JwiMRn+/kS7WgLOEjLDPB6u5xH3Feorvqg2wx6pCPBFjSZWey7IbvW5icWy/XkKjSoP7rca/bz/eEPbkvyK+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Mon, 24 Feb 2025 21:31:28 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 21:31:28 +0000
Message-ID: <a9abbcd9-eced-596c-c457-324b2518c939@amd.com>
Date: Mon, 24 Feb 2025 15:31:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-5-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 04/10] KVM: SVM: Don't change target vCPU state on AP
 Creation VMGEXIT error
In-Reply-To: <20250219012705.1495231-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:806:121::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7efa63-50fc-482b-030b-08dd551a9944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NElZcWpod3R2N0dOdmRlQ2tqbjNpMDhuRzZES1hVM2x3bWVuQjkvd0ViT1d5?=
 =?utf-8?B?N2pMTmFCNnpqdzRjS2NBMC9NRENwYW5nWWhMS3I1KzB0S0xCL0VsclBydGhz?=
 =?utf-8?B?bEZHZERLRWVVR3laSkRlOFdYQ0sxbkZyY2I0Q1ZDeVZOUFg4ZmhxRmVUdGpU?=
 =?utf-8?B?bWVjUTZEeVpudGI3bGcvREdHM0lQakNMcDVUY05OQ2JvT1hiUmozRDVjNytI?=
 =?utf-8?B?bE1VL1dFUUVQT0RQL2xVQkRGSXhUdnZaOTlsaFN1eEdubVR3TnVPVWhHVitS?=
 =?utf-8?B?VFd1N0ZBbWdvNzdQdURsVFA2ekJLNXhzajV4a2ErR0pDa2ZaeTFId04vQXFp?=
 =?utf-8?B?MGZTTjR4NzI3Wis0aS9UZHhxOHhYUGE5aWVCdDFuZk53MkFGODZPV1pEd2xn?=
 =?utf-8?B?QjFmUG1JeEV0RWY0L252K1E1V2RrOGVEOC9RajR2QXhOWTdMN05qUXFkbnhG?=
 =?utf-8?B?TERVYTZKWC9kNGYwSTJLcit6RlBZUjR4eTB4KzY1ZTl3dGVxYVM1VDgyVzgw?=
 =?utf-8?B?a1BYbzh2M2RhTVJmekZTVTMxSjN3YzE5K2Rncjh3ajJxdXAyckhhQURqcW9R?=
 =?utf-8?B?bG5FcUZkSkhYNTZiR01KV0ZTNWRXTzdrQ0JGWkZ2d1g5MDRKVytUQU0zTlJm?=
 =?utf-8?B?YUd2b0gxVEVUUTdxeVZMVE9ZOEp0VXh5aXpnR1hDSVNibkhHbTV3bHBwVlNq?=
 =?utf-8?B?Y2FoU0NTTDhGbFp2a1krdERHT3Roc05sVDB4ZXVadjU0am45bUlVY1lpcXNr?=
 =?utf-8?B?REhncG5QZ0ZEcDZZQ1dGMWFvcFhYRDhvbGZFSXBqNldlVE9xcm9HWnE3U0Za?=
 =?utf-8?B?cXl5Rlp3M2czdEkrSEZDa3QvWVNONUR4SC85aTZOTzd3STh3ZGFPbUp1c2pv?=
 =?utf-8?B?UmpQZkIrZ24wRnBhVDZoZERNdlNVeTg3WENYZ05OZ2cxZ3hlVWFrVExOSG15?=
 =?utf-8?B?Y3N5bnUwQWVqQ1d0MW5zTWZ3ZFdwT0dmSGcvV01oYS9icHFoZS9KMFZBZnlz?=
 =?utf-8?B?STk4dDRyU2loeFlycVV5WFhTeEtUeG1YTzRjQmVGNWJCNzYrSXY1S0s0eDdq?=
 =?utf-8?B?aEQvUHpSTUEyOGZkYmxQVjR1dEJTdjJaUkcyWGhUUm93QmhCd2FqUmY0NW4y?=
 =?utf-8?B?ZEtObFRXclM3ZlIveXRqWnY5b2Zjc2hvOENESGhEang4NzBkL2xYeDBqSkJF?=
 =?utf-8?B?bms0aUo3VHBvelJHQm05MXg1SDQ1MENLdzJPUFFaWU42ak5PNWtqSU8vUmRH?=
 =?utf-8?B?T1Z3c1ZKbmZwMFl3b2JZd3RjcVhIakNzb2hrZnNXb3M2cTFmNEVpcm9YS0Zt?=
 =?utf-8?B?dFN6MkhUSXUxWDJ4WWI1K3prU2FIWTJWRzF0c09lVjl2K2RidElFV2o3aWxs?=
 =?utf-8?B?MGcvdFRqa3pDZDltOTREdUUxNWorY0JBdW9Bc2NHVUlGWm56enhiZ1RmamNP?=
 =?utf-8?B?R0RrZlNGNjhLbG5CWkdqSitTaTBXTW4xRTdURSsraDRINGI2VXVFT3E4bFFo?=
 =?utf-8?B?WWk0MUNIK3phREtQeHJ4bXpwcy9SK21GUDVNcE4rd1AxU21yNDgxMnNteHJU?=
 =?utf-8?B?TVAwaHZ6bGFLYWp5cDN4eGh2NjZVR3l1d1N1QWVOZUZLclBoVXNzQTQ4M3dI?=
 =?utf-8?B?cE5MQ2V1ZVdLU2xMY3JUS09TYm84Ylk5bTRJVDNoTGdQQWc5V1VkVllPNFN4?=
 =?utf-8?B?WkpUQUZHcjRVY1BubllJdU9vMERzYi83QW5VUlJ0MTdUWDdkdWxUaFV4K3ZD?=
 =?utf-8?B?Vjd6UDc0ODdVUlRKUVovNVR5aEZoeStIU0NMSjlYU1hqcU93RVlJa1JCODgz?=
 =?utf-8?B?SjNBOW1saWRsQVhsUXNCSG9oVi8vMnZVb0ZpZGpnUXQ4SE1ISUZmSWV0ZjZi?=
 =?utf-8?Q?UL9d82PDTU2Og?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkVMdXpNa0UvQnJ0elo5VHNzSS9GemVjVDhhbERvNGRBaU43TXRraXRkaWdX?=
 =?utf-8?B?a2czVGhNdFZyY2NDMlUzSjNlWGVnU1NPQ3JCSGVMejBoQWIzQTZUblNJU3dK?=
 =?utf-8?B?OTNmd1NTeW1LK09hdmorZWpwd2oxSERzK2RGZ1crSEsvMTB3emhrWjBXYXNM?=
 =?utf-8?B?Z3pZRlVBc1hJQlAwc25KbEtjajlzd1JBWm1QTGxMUWFYeVkwQjA2L1V0MURw?=
 =?utf-8?B?RDN4QU9WSWhYRXhEOVUvdTVhd01tSFB6dTIwQjNGVEpoSEZRSWJtSzJteVhK?=
 =?utf-8?B?aE5YQ3R5NDdWT01zeTVFQUx5R0kvcEZWU1I5M1pmSEFQcERDYi9wVW1VaXFz?=
 =?utf-8?B?Si9TMG5pVmt6bXR0UlhEWVExazZ2a2xJODN0aXk5Z0xBNXJMaWtwQnZXU05L?=
 =?utf-8?B?VzFEZFEvTTBpRENtbkZoNE53WmN0RzBpck1relhvbC9jU2JpQ1NSWmx4UndD?=
 =?utf-8?B?VXlKTE1mMFB1N2NLUElWYzNBZlFTeFZpNHQ0WlQzblM0dDhRamJJN216L3dZ?=
 =?utf-8?B?d1dhdGhXOW9FUVk3QzJxbFc0YUxQYWQvLzFRMDl4WmZtOXptTjlDYzNsSGNq?=
 =?utf-8?B?SmREZTF5Z2N3T1JxdzJQc3pVOEFDU1dXb3JKWEJ4VUQxVlJmc2xtZ0w5ZTQx?=
 =?utf-8?B?Z0xYK05sWUt3dGxnZnVOUmJaZUlMNitNVmNxRzB4THRIRjM4RTFnbmF6Q1ZF?=
 =?utf-8?B?ZnNjNlkzU3U1YkRsWU1FdjI1TFFyMjZQTWgrNkpuV3hDckhrQVRHbWN6Szlp?=
 =?utf-8?B?QWg3S1R1eEVNWjdUaFIzNlhSakJjM21STVdxN2pkdXprUnh6M2M2K0NmR2Ns?=
 =?utf-8?B?MVNXUFJoR09KeXRUKzlkNGk0eFpqN2J2U1pPbGdHbzVSUU9vNFFmNWhDTkJR?=
 =?utf-8?B?SVcrV2NzRHhQdm0wNWZWdmJ1Tk9DU0NBUERIamlDYlpic1ppZms0czRkTDR2?=
 =?utf-8?B?bTZRUytHelorLzg2YUlGVW9kb0lNVnJzczBxNnFNTTBYcjNoY3l5TVdxNjJk?=
 =?utf-8?B?SFNyVHdVUzRpTTRJbnNFYnNqQU1mdXhFZ3JDZnJibk50a3lsdzhuRzZXWUZY?=
 =?utf-8?B?SmRJNTVtc25HTGNQUWFkS2N0akJza1pDU0RFNzFwZm0zd01QbG1xZG5RNmgw?=
 =?utf-8?B?U1FwOFc1RkJBZm9CZGY3N3kwc2YzWG1kUlQrZTBzM3FtQzh0c3hDYnNyekJs?=
 =?utf-8?B?MlJkcXRpaG1jUG84c1I4QTg4UnlGcFdxQTF6RXNsOHoxSkxGK1F5ZVBpNjVq?=
 =?utf-8?B?Q1N5QWNIZ0c2dUFaYTFLcSsrWnBJWDF4VFh2Q0pheitHSURmeVN2YXVEWlF6?=
 =?utf-8?B?VUJiSW1yWUlDd3hLdzkzdEZ5Uk9hUThUaWxmMXFUeThnYXEwenJQamNhVTk3?=
 =?utf-8?B?NjEzL29Demh2UWhjMVdhcmlTMnR1a3VZTkI5ckNvOHRsMDhvZmFuVHFCYldV?=
 =?utf-8?B?WC9sOHorT0RLaUFoVkI4VEs1WHI1bHlKaEZKNWxMaGR4S010RjVvNVBjekdu?=
 =?utf-8?B?cXJZckpjclduN3dpbENBK01vKzh3b0VRc3J0eWYvUFVPRkQzNURucTZucUtm?=
 =?utf-8?B?YnZBajBKOSs3Nkp0Ry9vaStpTmdhUU1rNmVzcVJES3hpL1g5VFROVkFZWGlT?=
 =?utf-8?B?ano0akZFWFJYdll5bkp4ZEtnTWRlVkcxaGsybXdhb3pPTEpPR1RUeGpQaCty?=
 =?utf-8?B?R1lyWnBST2Q4Zk5uT29VeHJWWCtOWVdFNml6MVFHWjkwbGpYRm5uMUR3eVdv?=
 =?utf-8?B?U0lkT0RYYXdkeXNFekU3UkVnSUtEMmxBUlRZTkU3dVNCaTN3cm1lRHNOazNW?=
 =?utf-8?B?Vi9veHpuL0lzMlFqR09qaldDTE4vbzk4eW9rR3BCVUdKUmU3V213dU1KTHFH?=
 =?utf-8?B?MXgvVlpHU0lZVWtMYWVsT2RITmdOSTJZRnIwRVVNbzVMV1VJV0h2RUtQTzhL?=
 =?utf-8?B?UHZLRDh1UW14akVQSUhKcEtaeldHa09QVVRkVm5QVzVtQmxpQ1BuNEd3RGR3?=
 =?utf-8?B?WDVCa2plbkFIVXpwNDFaWGt6ZXMrdW9CVTR4c0xjRk05bS9abEtsTVErRTcx?=
 =?utf-8?B?UWRrdUVOalFUVVVnN1VRTXdDY3FSREgxSHcxYzVEdEFkRE95QS9tSTdRWmV6?=
 =?utf-8?Q?lJa2OZAs3rJ/1bQE1wWQ7OVo8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7efa63-50fc-482b-030b-08dd551a9944
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 21:31:28.6678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tweq6tY+4REPdZ/ZvYxdIbF86lstqjhyJST/MM4+Zzr2j7Sv4Ue3hpHkSz+85Cf/hqiAUTHmtTUFiWXT+GeTqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344

On 2/18/25 19:26, Sean Christopherson wrote:
> If KVM rejects an AP Creation event, leave the target vCPU state as-is.
> Nothing in the GHCB suggests the hypervisor is *allowed* to muck with vCPU
> state on failure, let alone required to do so.  Furthermore, kicking only
> in the !ON_INIT case leads to divergent behavior, and even the "kick" case
> is non-deterministic.
> 
> E.g. if an ON_INIT request fails, the guest can successfully retry if the
> fixed AP Creation request is made prior to sending INIT.  And if a !ON_INIT
> fails, the guest can successfully retry if the fixed AP Creation request is
> handled before the target vCPU processes KVM's
> KVM_REQ_UPDATE_PROTECTED_GUEST_STATE.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e14a37dbc6ea..07125b2cf0a6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3959,16 +3959,12 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  
>  	/*
>  	 * The target vCPU is valid, so the vCPU will be kicked unless the
> -	 * request is for CREATE_ON_INIT. For any errors at this stage, the
> -	 * kick will place the vCPU in an non-runnable state.
> +	 * request is for CREATE_ON_INIT.
>  	 */
>  	kick = true;
>  
>  	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>  
> -	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> -	target_svm->sev_es.snp_ap_waiting_for_reset = true;
> -
>  	/* Interrupt injection mode shouldn't change for AP creation */
>  	if (request < SVM_VMGEXIT_AP_DESTROY) {
>  		u64 sev_features;
> @@ -4014,20 +4010,23 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
>  		break;
>  	case SVM_VMGEXIT_AP_DESTROY:
> +		target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
>  		break;
>  	default:
>  		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
>  			    request);
>  		ret = -EINVAL;
> -		break;
> +		goto out;
>  	}
>  
> -out:
> +	target_svm->sev_es.snp_ap_waiting_for_reset = true;
> +
>  	if (kick) {
>  		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
>  		kvm_vcpu_kick(target_vcpu);
>  	}
>  
> +out:
>  	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
>  
>  	return ret;

