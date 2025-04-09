Return-Path: <kvm+bounces-43004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE21A8217D
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 11:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A94118A72A9
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 09:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4141525D8E5;
	Wed,  9 Apr 2025 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3DvFMcTs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6696E25B67E
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192646; cv=fail; b=qpK8E6ghVJqVSeLiTOKmBGwRxvqJd/XQna1c7TycV3L8Zj+poFTyHsarz9FmaPbE/kcko/jdtCwWrWqYG8RrAdaDqYenOPy1sGVPj4GPL/KrEdDKLr/uU3gDRt3rP43PSeXqU6NIZKWHQqvDXf+1eHd06q/e3dDjBxtm3cHiJDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192646; c=relaxed/simple;
	bh=eaWkcY7t617BtJ0SPq5j7gMSYQO0lsTiFz/fYf/16lc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gBKym2ukDUzuhpaNTvFhgw5FR/avIFtlVoDDImclm3HHmSO5XTsVGUjeUBZyfs4KfB/jhUxWtVQx2XEFMDG9umx62gG9fbE1+/7wsDocNe0knj9UkC8FcEtTt/N4MRHoJcTreISwn42tCoj+lW/isSUqdu9y/BURPJGX53nwiTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3DvFMcTs; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSUzHzeoIZS9GeE41MxDsfw27vCZFfwypf5xqdmqLSgPMAquuqtDrkCcXnbFKkKeURFmPEvS3Ktq8v4AIQmgLgVNn4ZaZDBef8rF0SJfcADiHLQCXvjlh1jeOzeV0PXXFe4tdkG5u0sfMZ0P28gMXgAXKpXRdz0YtO7Aqz/NiZz/jWG0JiwGs4jJfpxLS/FomJq1Hhbhw0n93pwfiFAc2FcdpsVXOzyS8dY6w4uyPCds2wemnJWxqGw2DlG1E9lKJvMxmVkibwmJQjPr9SalLSY/GprKEt0cffyc5I6zRwI6TuFiOvS1iLsJqXhMz1v2VIKhEpjdPdCcNeT4iJPhfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMtvWjO/n6fWBX3Gi1cCxW/bXEj9M1mqz/9cbtL9KK4=;
 b=U3VvOoiT88DkoBXPxR5/tf45q6RQh8c1ynR4t/yrXZVPsSid5wRtpTXUquoYBZD8BLeM3Rzhe5oU0tChTMEINpe2Us/B8vWF3sdimWoQar5cDmVxszng7xi/eFdxGO+WMDIHV4n6Ua2uoxUldNKukDxygwgeKUJErQjeEw9pf6aOUCOiurXtDV+8hAflsMrEOasFliFkFNe764mtTeq12ihqnErTLaSqUSoUbCti14OUarjYXOG7f+2wg6STAZIB1YreXBkiI1LztNhzHbP8qDFTj+mebyNdRLzEJYjcu/kwt4QJNB4gk8XoKmVVlU8KBaHSvvvID/k87L2asCq08Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMtvWjO/n6fWBX3Gi1cCxW/bXEj9M1mqz/9cbtL9KK4=;
 b=3DvFMcTsKGJGK9d/Gc212M5La69jKWHUkgnVRH2dkq4O8oOGgOrexe0+DDRyKar5cy7wdeSJriFv/DqYeYSC4u5hnPfMwYH6MaQhBOO+tSUlMSmOUQmiDaxNnKrf+azhfp7waKhRN5XMVHQDqteXivLGuj+/7cO1Kzo92hU73cE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Wed, 9 Apr
 2025 09:57:22 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 09:57:22 +0000
Message-ID: <9e20e8b0-20f9-4e6a-ac98-0e126b79b202@amd.com>
Date: Wed, 9 Apr 2025 19:57:18 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBLock with guest_memfd
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250407074939.18657-8-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0054.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: f3a02a0b-47c6-44f6-1818-08dd774cec43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UC9vdC9sRTJOQnVka1dXYXNOdzZ5WjBtajlYdGtFRExURW9EdXlVNFJEblhN?=
 =?utf-8?B?dFhrQUNCWXJLdlhwNkUrcUh2ZnpzT2lrK2dXeDJJdC9kL1JSNktvazQ3bDdy?=
 =?utf-8?B?RFpCRHdMSUtJcnJNOWE5ZnNwdG52Vk1hQThFb092OVF4UjI0Zi9qb0xrNVFT?=
 =?utf-8?B?OGQxV3RGWkVRaFJGd1lidFhReVVPQXU3L2RTaGoreUlpK1NhdEJFenJYdVBk?=
 =?utf-8?B?TGJGMjF1V3F2L0w0WVcvSnV4Y2hPTE8yWlR1dGlia2JtZ0cvU1p2N3lHdEQw?=
 =?utf-8?B?a0d5c3ZBWTBzNjNIUVdCeUlMaktaQTRpa2pXeGpWYWZjL1V4R1N6QzVjYmg1?=
 =?utf-8?B?MkVEVlVDS2tieVNpeXcvdWYwL0IzUUNZWC9ObmFsa2tGVC9OYzFpMjRMWU9H?=
 =?utf-8?B?M0lTQ3lDZitnVHdEVGhHcmVNZjd5SDFZd1R2VkRVN0IveW8vaXNhOTZlMm5J?=
 =?utf-8?B?UGdkb3hWMlp5aFN1R3RWNFU4WGpvM04zVy9FQjRXWElxMXROVmtEeXhnd2hh?=
 =?utf-8?B?QjB3RC80d2xYRzZBdVNGeEVWbHVOVUd0N1NHd2dHT1VjRVloa09ZRXpVTFBv?=
 =?utf-8?B?c1EyZjcvbFdKUStsbmFhZDd5VkdKWVRwMS96VmhuUFI4L2NhNDBvb2t6SFNX?=
 =?utf-8?B?UW51N1R2TDVxbzRiRHNickFPTjQwc0E3Z0MydFdkNzlGcGdTaE9JaFVhZHZx?=
 =?utf-8?B?Y2s2Z2d6T1lkZ0M2bjYwRVQ0YnhQY2MzZ1hvRE4renBnT3VSZTRyMmNSUzls?=
 =?utf-8?B?Q3VaZHhSNkVpKzRoVk5xczNjeUFXSzh2TVJRSWcrWEF3UWRxcjRSRjZ0NXVH?=
 =?utf-8?B?R3VJSDA0dzBhQkVPUHM5RTVuZEtZLzlEU2tkNnphdXhFTXhjUE9aV2NDcXZO?=
 =?utf-8?B?M2VoRWsxTy96ZDJMZVBtMENlbXhjY0ZHMWJ4RzY2aHc2d1VUTWR2WDZ3NUpx?=
 =?utf-8?B?M3VOQ2xFQ3l5dXNDbFFWekQxS0VCY2loTDRRT1pPRUlnYXFDTHhDMGNoaHB6?=
 =?utf-8?B?M1JtS280RlVzQTMyU0R4YzBXcWRCZnJqUDg4VXdaSUNzTkcvcjFuMU9UYTVm?=
 =?utf-8?B?bzIrWGcxcnB2MDkzellMYWZJMmV3RTI3QXREbkU3YmJTMmdlSDBFdk5VdnFl?=
 =?utf-8?B?ZWJmck5CZCtHR0xBTXRkb3lSTjZmVVJMVWE2R1l4TjVCaXFGZkdmVHJtd0xR?=
 =?utf-8?B?Z093NGlQOFZFa1JMQjhWeDVBajhGbHhJa1o3L3FEbGhkcWpFTEJ0VTJzbkJl?=
 =?utf-8?B?Q2VVbFNHU3VXNFpBNkt2SlJYNUJzdDdJWEkrUXV5L1hBbzJTczVHdmRqOFlC?=
 =?utf-8?B?UFptUTYwVDZpUkF5RGxQUkV6aGlibFJsbG1jYktrc2R5blpicm5oalZZSVlK?=
 =?utf-8?B?d0U0Q0tsb1FEKzRyeFVid1NvZlFRdFR5WUJhYzE1Sm5NdE9uRXdMT0ZRb2d4?=
 =?utf-8?B?NkQyaDMwSTNFT3Vzc1MrMEh6U0cxNGxhcFh6NEZydzMxbmMyWHRlUDZITkFR?=
 =?utf-8?B?NjFzREY4MExZQzA1c0V5ZEZFUWZXblgyTitKYnBWU29jL3RyYXRJN2NIOHls?=
 =?utf-8?B?cURrZ1UxNjJIaXJHcWw2ajBZMVZUbHdSZXRlNVVWSmxHeHVwVkRkZ0h1a21x?=
 =?utf-8?B?K2pncHEwQVdwNzYxd3l4Rlg4MytrSThDemRrOG9WNFJTTlNzVnFoeUpFdFBw?=
 =?utf-8?B?WTF2SWY4VWY5UXpYa1VleFFwM3lLbmpEbnpjdStJU3pXQ3pRR0NFTXdIZmR4?=
 =?utf-8?B?Y0F4K2RLY3ZrZWNJMzk1aVJLRUl0c0g5T0ZKeWtNSmhDOXArUjRZQkxKaG83?=
 =?utf-8?B?SmthMk5aWGxaZC9NOUh1MFFyR2VKOW8yOUY1UTl2OTBTMlBBQXoyTjZnR3Zx?=
 =?utf-8?B?SFNYbC81SUI5N201U1JVMTRNYkNaWnlMMGlQcEswODJxNXdtWXVZVWRkSHpF?=
 =?utf-8?Q?+u+67nwQMgA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUhDNmp1bDI5NXh4Rk9XUG80UVNCRkQ2ZG1xMzQ3VzJHSzF4a2dXVVRUQVdW?=
 =?utf-8?B?aTNpZzlDQk4vZFlTSm1Kd1BhVkpEN3lUNkRnUDc1VW45Qi91eWkzekRFQjVt?=
 =?utf-8?B?TWZZWmF2cnE2UzloZmtRRmNWc0p3a3djbEZUOE1VOStwdHlLOHZzeUgyMW10?=
 =?utf-8?B?bk1GdkFYdGxJdTRLZk1VcFlvUGRxSHV5OG1rdzdxRmFMS1RRM0xYSjBTbGx2?=
 =?utf-8?B?SUhjcFhtY3FRZzVYZDQyVzNRdmpSWnJiK2xvYm9nOW82WVBmWmtVQjVOdXVS?=
 =?utf-8?B?RHdJOUo2Wm1PWXIwOXNLcjRWeFRYdzJjZW5MNTFwNUJCZlFBYkprTnVlT1JW?=
 =?utf-8?B?NEpNL1NFTDhvNmM2K25VL3ZCRElSQUF1SlVRYmxDOU9scG1MbnJjOUkzU05M?=
 =?utf-8?B?N2UxSHhPd2pFZEQxVHk5T3NkVXd1ek1ESWNod0hXMnlaOTN4N0ZLaTdINzdX?=
 =?utf-8?B?KzBZMEQ3Z2NLY0FHcG05MFlXK3p5NXpuN044OUJNT2lsVWlFa0tWb0ZBeXNT?=
 =?utf-8?B?dTNsaXRDZkFZd09NM085dEszdlJpUHFONFhPbFNwdGxBREYwK1VKaU03S3RV?=
 =?utf-8?B?dFdscWlVZFdOdE5MZVdCcGk1MGVoclM4ZURKaXZqcUQrU3puU1FzZUY0ZU0y?=
 =?utf-8?B?ZEdFelRKK1lqajUzaDJlbUI2WCtVdDU0U1ZwTC9Mdm9MSmovRFhVeUU3Ykhj?=
 =?utf-8?B?aElDQTdScU1aM0pDVVV2K3RxeHRoSS9acUZvQy9PZ2lLUWlwN1JzVGFjZXlF?=
 =?utf-8?B?NVUzZUkzblViUnE1TG55aUljcVhpR2RneGdoK0FzWjdUeW10RHZ3ZllUN0xa?=
 =?utf-8?B?RDMxTURuZzNHbkdGeXNiZ1NsR2FMUWRaVi9vL3ZGMHlpakJ5OVdrWkt3SDhC?=
 =?utf-8?B?RXgrQ3hnY3BOaGwwRTFYTHNBQ3l3VmsvS2tWWlUvTldPOTlkcGVBUFJDZFhW?=
 =?utf-8?B?dnNqdzdweVZSeVFCTXdxMkJZaUJjbUdyRGxwc1BWd3pTQlhFNGZLVlMySjZO?=
 =?utf-8?B?bnJjeXlxb1pWS1ZIZVcyMlFISHczUHk0WXcvdm5xb1pXVENVZzJBTWx5NkV2?=
 =?utf-8?B?Zi9yeWY2Z1Vqd0tZSjAxTURJT2xwQjM4QVhrTVJpbjg0WjRzc004WitDN2lX?=
 =?utf-8?B?dUdFbHFDSEJZNFhHZEVCRlhhckI5RGIreS9aVGRUVzNiMGxPMyt4cGVBd3V2?=
 =?utf-8?B?bjNGUGxiUGdhSmdNb29YTWtrWHJHN1Bjb05oS1hJaWJHRWtSanBNcUltOEIw?=
 =?utf-8?B?dVpnS0l1ZXNYcTNDc1c2cUh2SlNkeFJzOHc2bVpNRkRodHVDOUVMb3pqWVZu?=
 =?utf-8?B?bEhPeGJBc2ZsYnJFQ2J5RkJSeEZzMUM2T1dvY2ZoSnRLZjlHS1Y2MGdtb09K?=
 =?utf-8?B?eXhPKzg4YWxvbCtsRmJ1WElOSThIWDJWSXFUSnBTeGx6YjRUZklnWmtjcnVq?=
 =?utf-8?B?ejhFbWdjOHp5MjlBTEVST1lpWmNhbE9MbXhOUThtYkJTOUs2elNObDFFQWxE?=
 =?utf-8?B?c3IzTTh0MENQV1VpWmlVUk9CalBJaHhVV1BIQ0tiVkozV2szWHBCLys2bHJq?=
 =?utf-8?B?aStpWmUwUyt0cmk1aDYyaE16N3Ftbnh4alRDajZIZmZPVWxYUzJaTFhKWTFU?=
 =?utf-8?B?NU9NV0tzTUVpSG9zOGFYRzkydmpXUGpCSXR1eHhib3RaQkxPSkFWR0NYcE5t?=
 =?utf-8?B?S1dBRFdlcFEzWnAvY2FSV290VHhZWURnVi9ESHd1emhYTzFWYytucDN1Vkp4?=
 =?utf-8?B?K0RGYkZDM2dySVFaeUthTyt2ZHJyK282TlFUWm8rMmc0R0grK0hScllNM1pZ?=
 =?utf-8?B?K05FNHFycXFqWFFPcGErZktHRG5VMG53K3ZsTmVXSmRmYURSUVEreEtZc3ov?=
 =?utf-8?B?NzVua05EWlZDZVFaeEVWdEM2bnNJUmFaMlBpeXhPWFRtdTFHc2xUdnIrYURu?=
 =?utf-8?B?cjMyMEFNZkg5ZzlQSThUamNSeFJqTytHeXRBZ2wwSnhTTlltWlN5TlJXVXll?=
 =?utf-8?B?UjR6akdHbjB5bHZkNEtoVG1iS0VhbGV6M1VHeHdsUDZNbTgxVUVaNU4vNStw?=
 =?utf-8?B?OE5EdVN6SmZOQ0dwMktpL0ZqUXBCME1YZkdleFNzMU1rMHlrZkc2N1BUa1Q5?=
 =?utf-8?Q?v1NV26KxAWdE819Hk1VwjMM5Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a02a0b-47c6-44f6-1818-08dd774cec43
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 09:57:22.2753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggHtlRukx3cEgk70WIWE8MbtqTqo3umkDIo0u45rPgm1/+CbGukRBSQbCg2LJ6vDw+ImeevK/63i5d3H/IfmKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951



On 7/4/25 17:49, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") highlighted that subsystems like VFIO may disable RAM block
> discard. However, guest_memfd relies on discard operations for page
> conversion between private and shared memory, potentially leading to
> stale IOMMU mapping issue when assigning hardware devices to
> confidential VMs via shared memory. To address this, it is crucial to
> ensure systems like VFIO refresh its IOMMU mappings.
> 
> PrivateSharedManager is introduced to manage private and shared states in
> confidential VMs, similar to RamDiscardManager, which supports
> coordinated RAM discard in VFIO. Integrating PrivateSharedManager with
> guest_memfd can facilitate the adjustment of VFIO mappings in response
> to page conversion events.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> PrivateSharedManager interface. Implementing it in HostMemoryBackend is
> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
> have a memory backend while others do not. 

HostMemoryBackend::mr::ram_block::guest_memfd?
And there is HostMemoryBackendMemfd too.

> Notably, virtual BIOS
> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
> backend.

I thought private memory can be allocated from guest_memfd only. And it 
is still not clear if this BIOS memory can be discarded or not, does it 
change state during the VM lifetime?
(sorry I keep asking but I do not remember definitive answer).

> To manage RAMBlocks with guest_memfd, define a new object named
> RamBlockAttribute to implement the RamDiscardManager interface. This
> object stores guest_memfd information such as shared_bitmap, and handles
> page conversion notification. The memory state is tracked at the host
> page size granularity, as the minimum memory conversion size can be one
> page per request. Additionally, VFIO expects the DMA mapping for a
> specific iova to be mapped and unmapped with the same granularity.
> Confidential VMs may perform partial conversions, such as conversions on
> small regions within larger regions. To prevent invalid cases and until
> cut_mapping operation support is available, all operations are performed
> with 4K granularity.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - Change the name from memory-attribute-manager to
>        ram-block-attribute.
>      - Implement the newly-introduced PrivateSharedManager instead of
>        RamDiscardManager and change related commit message.
>      - Define the new object in ramblock.h instead of adding a new file.
> 
> Changes in v3:
>      - Some rename (bitmap_size->shared_bitmap_size,
>        first_one/zero_bit->first_bit, etc.)
>      - Change shared_bitmap_size from uint32_t to unsigned
>      - Return mgr->mr->ram_block->page_size in get_block_size()
>      - Move set_ram_discard_manager() up to avoid a g_free() in failure
>        case.
>      - Add const for the memory_attribute_manager_get_block_size()
>      - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>        callback.
> 
> Changes in v2:
>      - Rename the object name to MemoryAttributeManager
>      - Rename the bitmap to shared_bitmap to make it more clear.
>      - Remove block_size field and get it from a helper. In future, we
>        can get the page_size from RAMBlock if necessary.
>      - Remove the unncessary "struct" before GuestMemfdReplayData
>      - Remove the unncessary g_free() for the bitmap
>      - Add some error report when the callback failure for
>        populated/discarded section.
>      - Move the realize()/unrealize() definition to this patch.
> ---
>   include/exec/ramblock.h      |  24 +++
>   system/meson.build           |   1 +
>   system/ram-block-attribute.c | 282 +++++++++++++++++++++++++++++++++++
>   3 files changed, 307 insertions(+)
>   create mode 100644 system/ram-block-attribute.c
> 
> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 0babd105c0..b8b5469db9 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -23,6 +23,10 @@
>   #include "cpu-common.h"
>   #include "qemu/rcu.h"
>   #include "exec/ramlist.h"
> +#include "system/hostmem.h"
> +
> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
> +OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass, RAM_BLOCK_ATTRIBUTE)
>   
>   struct RAMBlock {
>       struct rcu_head rcu;
> @@ -90,5 +94,25 @@ struct RAMBlock {
>        */
>       ram_addr_t postcopy_length;
>   };
> +
> +struct RamBlockAttribute {
> +    Object parent;
> +
> +    MemoryRegion *mr;
> +
> +    /* 1-setting of the bit represents the memory is populated (shared) */

It is either RamBlockShared, or it is a "generic" RamBlockAttribute 
implementing a bitmap with a bit per page and no special meaning 
(shared/private or discarded/populated). And if it is a generic 
RamBlockAttribute, then this hunk from 09/13 (which should be in this 
patch) should look like:


--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -46,6 +46,7 @@ struct RAMBlock {
      int fd;
      uint64_t fd_offset;
      int guest_memfd;
+    RamBlockAttribute *ram_shared; // and not "ram_block_attribute"

Thanks,


> +    unsigned shared_bitmap_size;
> +    unsigned long *shared_bitmap;
> +
> +    QLIST_HEAD(, PrivateSharedListener) psl_list;
> +};
> +
> +struct RamBlockAttributeClass {
> +    ObjectClass parent_class;
> +};
> +
> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr);
> +void ram_block_attribute_unrealize(RamBlockAttribute *attr);
> +
>   #endif
>   #endif
> diff --git a/system/meson.build b/system/meson.build
> index 4952f4b2c7..50a5a64f1c 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -15,6 +15,7 @@ system_ss.add(files(
>     'dirtylimit.c',
>     'dma-helpers.c',
>     'globals.c',
> +  'ram-block-attribute.c',
>     'memory_mapping.c',
>     'qdev-monitor.c',
>     'qtest.c',
> diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
> new file mode 100644
> index 0000000000..283c03b354
> --- /dev/null
> +++ b/system/ram-block-attribute.c
> @@ -0,0 +1,282 @@
> +/*
> + * QEMU ram block attribute
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "exec/ramblock.h"
> +
> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(RamBlockAttribute,
> +                                   ram_block_attribute,
> +                                   RAM_BLOCK_ATTRIBUTE,
> +                                   OBJECT,
> +                                   { TYPE_PRIVATE_SHARED_MANAGER },
> +                                   { })
> +
> +static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
> +{
> +    /*
> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
> +     * Use the host page size as the granularity to track the memory attribute.
> +     */
> +    g_assert(attr && attr->mr && attr->mr->ram_block);
> +    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
> +    return attr->mr->ram_block->page_size;
> +}
> +
> +
> +static bool ram_block_attribute_psm_is_shared(const GenericStateManager *gsm,
> +                                              const MemoryRegionSection *section)
> +{
> +    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    const int block_size = ram_block_attribute_get_block_size(attr);
> +    uint64_t first_bit = section->offset_within_region / block_size;
> +    uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
> +    unsigned long first_discard_bit;
> +
> +    first_discard_bit = find_next_zero_bit(attr->shared_bitmap, last_bit + 1, first_bit);
> +    return first_discard_bit > last_bit;
> +}
> +
> +typedef int (*ram_block_attribute_section_cb)(MemoryRegionSection *s, void *arg);
> +
> +static int ram_block_attribute_notify_shared_cb(MemoryRegionSection *section, void *arg)
> +{
> +    StateChangeListener *scl = arg;
> +
> +    return scl->notify_to_state_set(scl, section);
> +}
> +
> +static int ram_block_attribute_notify_private_cb(MemoryRegionSection *section, void *arg)
> +{
> +    StateChangeListener *scl = arg;
> +
> +    scl->notify_to_state_clear(scl, section);
> +    return 0;
> +}
> +
> +static int ram_block_attribute_for_each_shared_section(const RamBlockAttribute *attr,
> +                                                       MemoryRegionSection *section,
> +                                                       void *arg,
> +                                                       ram_block_attribute_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const int block_size = ram_block_attribute_get_block_size(attr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_bit(attr->shared_bitmap, attr->shared_bitmap_size, first_bit);
> +
> +    while (first_bit < attr->shared_bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_zero_bit(attr->shared_bitmap, attr->shared_bitmap_size,
> +                                      first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
> +                         strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_bit(attr->shared_bitmap, attr->shared_bitmap_size,
> +                                  last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static int ram_block_attribute_for_each_private_section(const RamBlockAttribute *attr,
> +                                                        MemoryRegionSection *section,
> +                                                        void *arg,
> +                                                        ram_block_attribute_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const int block_size = ram_block_attribute_get_block_size(attr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_zero_bit(attr->shared_bitmap, attr->shared_bitmap_size,
> +                                   first_bit);
> +
> +    while (first_bit < attr->shared_bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_bit(attr->shared_bitmap, attr->shared_bitmap_size,
> +                                      first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
> +                         strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_zero_bit(attr->shared_bitmap, attr->shared_bitmap_size,
> +                                       last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static uint64_t ram_block_attribute_psm_get_min_granularity(const GenericStateManager *gsm,
> +                                                            const MemoryRegion *mr)
> +{
> +    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +
> +    g_assert(mr == attr->mr);
> +    return ram_block_attribute_get_block_size(attr);
> +}
> +
> +static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
> +                                                      StateChangeListener *scl,
> +                                                      MemoryRegionSection *section)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> +    int ret;
> +
> +    g_assert(section->mr == attr->mr);
> +    scl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
> +
> +    ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
> +                                                      ram_block_attribute_notify_shared_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +}
> +
> +static void ram_block_attribute_psm_unregister_listener(GenericStateManager *gsm,
> +                                                        StateChangeListener *scl)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> +    int ret;
> +
> +    g_assert(scl->section);
> +    g_assert(scl->section->mr == attr->mr);
> +
> +    ret = ram_block_attribute_for_each_shared_section(attr, scl->section, scl,
> +                                                      ram_block_attribute_notify_private_cb);
> +    if (ret) {
> +        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +
> +    memory_region_section_free_copy(scl->section);
> +    scl->section = NULL;
> +    QLIST_REMOVE(psl, next);
> +}
> +
> +typedef struct RamBlockAttributeReplayData {
> +    ReplayStateChange fn;
> +    void *opaque;
> +} RamBlockAttributeReplayData;
> +
> +static int ram_block_attribute_psm_replay_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamBlockAttributeReplayData *data = arg;
> +
> +    return data->fn(section, data->opaque);
> +}
> +
> +static int ram_block_attribute_psm_replay_on_shared(const GenericStateManager *gsm,
> +                                                    MemoryRegionSection *section,
> +                                                    ReplayStateChange replay_fn,
> +                                                    void *opaque)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == attr->mr);
> +    return ram_block_attribute_for_each_shared_section(attr, section, &data,
> +                                                       ram_block_attribute_psm_replay_cb);
> +}
> +
> +static int ram_block_attribute_psm_replay_on_private(const GenericStateManager *gsm,
> +                                                     MemoryRegionSection *section,
> +                                                     ReplayStateChange replay_fn,
> +                                                     void *opaque)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == attr->mr);
> +    return ram_block_attribute_for_each_private_section(attr, section, &data,
> +                                                        ram_block_attribute_psm_replay_cb);
> +}
> +
> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr)
> +{
> +    uint64_t shared_bitmap_size;
> +    const int block_size  = qemu_real_host_page_size();
> +    int ret;
> +
> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
> +
> +    attr->mr = mr;
> +    ret = memory_region_set_generic_state_manager(mr, GENERIC_STATE_MANAGER(attr));
> +    if (ret) {
> +        return ret;
> +    }
> +    attr->shared_bitmap_size = shared_bitmap_size;
> +    attr->shared_bitmap = bitmap_new(shared_bitmap_size);
> +
> +    return ret;
> +}
> +
> +void ram_block_attribute_unrealize(RamBlockAttribute *attr)
> +{
> +    g_free(attr->shared_bitmap);
> +    memory_region_set_generic_state_manager(attr->mr, NULL);
> +}
> +
> +static void ram_block_attribute_init(Object *obj)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(obj);
> +
> +    QLIST_INIT(&attr->psl_list);
> +}
> +
> +static void ram_block_attribute_finalize(Object *obj)
> +{
> +}
> +
> +static void ram_block_attribute_class_init(ObjectClass *oc, void *data)
> +{
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_CLASS(oc);
> +
> +    gsmc->get_min_granularity = ram_block_attribute_psm_get_min_granularity;
> +    gsmc->register_listener = ram_block_attribute_psm_register_listener;
> +    gsmc->unregister_listener = ram_block_attribute_psm_unregister_listener;
> +    gsmc->is_state_set = ram_block_attribute_psm_is_shared;
> +    gsmc->replay_on_state_set = ram_block_attribute_psm_replay_on_shared;
> +    gsmc->replay_on_state_clear = ram_block_attribute_psm_replay_on_private;
> +}

-- 
Alexey


