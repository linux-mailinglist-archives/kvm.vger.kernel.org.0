Return-Path: <kvm+bounces-69289-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2naeNncmeWkHvwEAu9opvQ
	(envelope-from <kvm+bounces-69289-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 21:56:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 223789A7DD
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 21:56:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AFD4C3030E8B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2950299923;
	Tue, 27 Jan 2026 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l8MAuoD4"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB12199949;
	Tue, 27 Jan 2026 20:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769547370; cv=fail; b=NdehnJSmFMBCV6eVRj7Z+U/M3FQdQnc+C0ccrtgIn1/ql77e93e+yipVOBMFCB0gKGYXY353fhjUEgCWuEQG6cpB7sRk+I9qkt5IFG1HsL6ziASILP5puTPGnazHGIEazLfJ/jCanR2Jl1+TL/jo4qBxq6oR8IxA+R0/BWDxIkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769547370; c=relaxed/simple;
	bh=r+l0caBIFdCPx1PSPXJwW+WoFfHnAhQDra8U7vYS94Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KTffmg4LO84DZ0uDqc0v5mEydf2Re1MJ5+q7IMnQs7V6ygyhB/g16LfDxFrrnbDtVbtF+li6vCHlyIoUteKvxfBRoSYnoQYb9kpsBqC1jXrJxWr3Zk8jsf9OtucaHZVRkioMPo/nzhutEopHwQnCL9RxDNtBTQdUmCf0RsTUDlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l8MAuoD4; arc=fail smtp.client-ip=40.93.195.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y5i05op0VeGSVaTSWe2rMDgsLWNiLYcRE/TG7NIpjJP07CooAVdCF//KVONL9Vc57CgzkygT34+cYNmUdg1rLizge7lYQacc8e56VDOoLlE0AczUfBBWKI2hAc0FB75auwx3f8+3ZPh9jpTEAuZjI2LHQc91nXufg3pme/JTPDW8H60eNdX87SxVGmRw8hEjZfgF0VbJ5GMPsu9yiNDrHtog0X69+O+jBGsL9vY9U4ZRyXsou6OQBzU2kbjqGj/WY/iB/tbdBt8ID4wSJZMzIIhSYy/tZrUocXe3CwMRcg8sb4tmMO08fT6IqbC5Xzg/CPMwtwIGG//m4UT8fkrvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5oY6MnhiP/imZzWGyzOQIzriDG7RE0aWN4fuNLJujA=;
 b=NHtc2ZXt2fYD1HbkxZH2Dq2PF8Sm5kLiLvjqQl8S4FemYEbH10g5lNF0fPYXEOxbqlBeJcRLdMwKtsdFY2Zvh7qOqqKwRAtjbdmyJJASSTGx9zBTzSLK3j4LeU2Vep14HJy9vUbcEn8JvP+IXEMx56bdiP6eUVFHNpiZFg4LPuLS3E1YPG/9SVdlImjbe32idBrIkXszJ2vOGreI1pKI/8pIK3PB+hCToxPxIG3T9B2+Fg5CcFMRr8tfau/0WscJ86SYjwjBX4nJ0P0PO9l6HeaK1AJzbnkvFlS+pRxOkf9hG6CFLALYafc+QjxxgDhwa63UwUYUocJys2eIet2wDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5oY6MnhiP/imZzWGyzOQIzriDG7RE0aWN4fuNLJujA=;
 b=l8MAuoD4xsGMLtwBV4SYP5+hZKcv/Cxc+ecVzPEgrwBSIySvDOjakz9f9glt3rdpPsljoN5bUQST3GIBQIoWYGF5kJKqAPqAJL9Q7+s4RXcmDPzFYdylow7VcEBN3+kkIBOVkdGDQbqA+xWO48LnYfJvK5K2X09p36a4mShtVvA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 PH7PR12MB5831.namprd12.prod.outlook.com (2603:10b6:510:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 20:56:05 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::c748:abd5:8638:f377]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::c748:abd5:8638:f377%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 20:56:04 +0000
Message-ID: <727a7d5d-53f2-4575-b55a-f2b5422e5674@amd.com>
Date: Tue, 27 Jan 2026 14:56:02 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SEV: Add support for IBPB-on-Entry
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak
 <kprateek.nayak@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>,
 Borislav Petkov <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-3-kim.phillips@amd.com>
 <4dea11f9-6034-489b-acaf-9a150818d1a1@amd.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
In-Reply-To: <4dea11f9-6034-489b-acaf-9a150818d1a1@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0143.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::19) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|PH7PR12MB5831:EE_
X-MS-Office365-Filtering-Correlation-Id: f25d319f-cb30-48a9-00db-08de5de67c70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEhDWFZJSHBHdHBGQ1hoTW9wVDBuWWY4TTJleVZxdDR1QWM4VmhyZTJ6UVFs?=
 =?utf-8?B?S0M2TklGc3Zsd2UxVkY1cEs5SmFQMFVtZW1OaUVFUEtXaXlhTkI4ajhiblBl?=
 =?utf-8?B?TFhVbG5POWg0T0pyN1JwWXczYXNXVDZUZldhWVFTQ25HQUlFbEZ4REtZSlMy?=
 =?utf-8?B?YWZ3bG1hWVFUWHpIMnF6d0FwNTRYK2pWOHRzOVRmWnk2VU5hN2dkYW5zZjhy?=
 =?utf-8?B?ZnNyWE5ibUVmNE5RNUIxYVdJYWRFaitEY0VUSTNFZWhEREFHYXY5cTdONm4v?=
 =?utf-8?B?RG51Zkxjc1dvMFpIdWhob0s3K29MUklIMTdycDQ2ajhYV3lCTW5XNGR4VHht?=
 =?utf-8?B?cjVtZ0ErenBqSGUzbituYWRhZzUwZjg5Y204em9xb1FPL2ZRSGRkYjVQZFhv?=
 =?utf-8?B?bjdXbnBweUY3RHo0aWFJcFIvNTNndUNUaXR6Q254TjQ2T0pXa0p0Nk4ydlJi?=
 =?utf-8?B?VVRUdUh2Nm1MVWxrMThyeFFoeXQvNGtIaytaVkdGSUlBbHcrK25KekxJTUFp?=
 =?utf-8?B?bTFhZ05GbEE4ZTBXVjRkUUptdjZVS09DWlF5Ky9zOHV4LytpZW1vSHhVOGUw?=
 =?utf-8?B?eitOcUNicWs4Zms5R2NFZ3FIM2FhN2xSZVd3bFNCazRFUWN5eHpDTjFKbkE1?=
 =?utf-8?B?dXhKVlI0UmNyNmJad05YM0RHYjhZQXRYaEZseFJyMi9Wd2cvYldaMm5EbVRi?=
 =?utf-8?B?SHZUK29jZEVPY1E5dUV1OURBZTVLcDNwRGkrYzJWbEJTYmdoWXNnblNoK2VC?=
 =?utf-8?B?aFhWRSsva2wwRXp5REdXUHlWZHJOc0hCTC9wS1NLVmF4bTlzTjIxWkFEQlAv?=
 =?utf-8?B?dVJvRi92d0lveHQ5UHB3RzAzcmNabTJyTHVHZFNaclpxMUh1Q2tmVmRlanht?=
 =?utf-8?B?YjNLVFo5VkhnZlc0QnRMYnhtOTBuZy9Uc2lscTc1Uis2dTRUZjV6aGRwbXVY?=
 =?utf-8?B?ZTRERkZWQmFpQ0ZwTmM2dXE2TWh0emJ3NkJLb2ZiaDMzREh4MDB1VjdvSE9E?=
 =?utf-8?B?YkkwQ0NuQUQ4SHF5bC9LRnFaTzVFOWRIRjMxbCtMOEsxN2FxZEcwbjl5aVI1?=
 =?utf-8?B?ckNzSWN6UWtPUmY3cVJCTnFiWEN6V09HNklLellxbVNvekU3MzFVQzlIZDg4?=
 =?utf-8?B?alR0dG5uOW1MbnlMeHR4bTRVS3B2c2tmd09GZUtLajgzajlKNmY1elJWMzk0?=
 =?utf-8?B?emMweS9RTnByQnNoQjhmanZ5WHYxY0lwS0tYRXJrcGhNZ1NDQlUrbEFCSkJl?=
 =?utf-8?B?R0VFTGZFMHVaVHMrVzlveS81ZHhWK21IeWVYZHVIQXBJS3JwMjNxMWxGejZC?=
 =?utf-8?B?OTErc3hxWE05MHJTMzEyTkRTeGdLMS9rbWZmQzd1VmF4Ym5ZWjduc0IrMXhK?=
 =?utf-8?B?bnk3ZFUrVm1EZnJhZHk2SjZKS3pKbC92UHBiSGlRV3dDRW1nZUNzeWlnNmJV?=
 =?utf-8?B?NE9RdFdQc2lhUHB4Nkk0OFNhdkJ1VThZYVBGVlc5a2JvR25IM1MxRFFlN0hx?=
 =?utf-8?B?OUlJT2FIT2RsRDIxV3gzMFhIVmM4YkZ4U3VONWJ4UUgza1kybXpJS0xiTUVO?=
 =?utf-8?B?ZmY0UjlSak5xejJJSElSMHdBREphRUg2MW5pazB2dGJJcVpmaEZRdlJ5M2FZ?=
 =?utf-8?B?cXFNaWZRUWVSVk5tbXpVbmNHVkpwZkhzek11YkdLVk5oS3ZGaEx5Nm04cE9Y?=
 =?utf-8?B?ZmZoY2Vla3VkSWw1U2UrVWF1UGlyMEp0a1Zjb2VyVGVpa0twMmlrSDc2V1Rp?=
 =?utf-8?B?b00rUVJWWlhqaXVYNm15b3FWYVl0ZnZ5SEFJeHg2YmpaKyt4TUFQRDlpU0p6?=
 =?utf-8?B?ZEE2eU9HQnFRUDA0SFhiWEZWbW4xbGlMT3pJYWZ6bVpacXBmK1ZMY1k2VzVa?=
 =?utf-8?B?VDBGYVk1NFlGUXdTYUtZOVhLVHpVdVYxYWNYOGtsTUpndUxpVFlBMTMyejNV?=
 =?utf-8?B?NjA2RWhMeWwrbHpTdFhSRXVLRHZmM0ZqT3B2QWVzZXFYNTIrWCtqWk9lTUhX?=
 =?utf-8?B?Q2IrOHY5cTNCNCtpNlU0cjUzOXFrV2trUEpQcWY4QUt3N1FyU2h0YzNyR3BQ?=
 =?utf-8?B?Vk9MZzc4T1pFM2lUemw0ai9MN29JbUh2VERyRVNQN085aWZuVmE1TjAvN1Ew?=
 =?utf-8?Q?/P6o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTEyS3M1TmtJUTB4QkNyTE5haDRENnJ3R21QaDNIclhtejVwSzkxNDMxK29N?=
 =?utf-8?B?VjdYOEM0czVhOFR4WDhQU2JPSkg2MzU3VlpDWGM0b3JLU2cvbmVuY28vLzN5?=
 =?utf-8?B?WHZoQjZ4OFNIUU5vQ25VYTFUUXpRQkJuZnF6R3YyYkFkRFRmM083d3VDQTNG?=
 =?utf-8?B?MVdneEhjNGY4VVdPL3BHcW84QU16Vld4Nm9mdExwMlRCUHNzclFOUHludExU?=
 =?utf-8?B?aFk0a0x6SWVBWGZOTkh2eWYzL3p0V1N1YTVDLzB4dTE1WDFYQ28vV0tXZ1ZO?=
 =?utf-8?B?VFpOR3E2ZENoVi9uKyt0TVdYZFlzeHM2K3ZQSUZrR1paMU5uTGxHekw5V29B?=
 =?utf-8?B?U0ovOUwvdmtFV0JvblV2SURyUFZiTVJlT1FUUENjbzhiaFl3VmVuZEprb3dx?=
 =?utf-8?B?eC9zR3lwSW9XSzRnUFdveVhtdHlhRlpTK2cxS2w1TWpDeVZ4aitMU3BpRzlX?=
 =?utf-8?B?eVNjek1LaFYrRXNmNnRMS2Y2WlBncFZMSDZuR1ZWRTBqNXV4UGVJWFpleHVp?=
 =?utf-8?B?eW1vUjVVMkxKSFR2SW54ZUMwNE5sL21FWXJKSmRCRGpXVFdUdVRxcW9vQnJu?=
 =?utf-8?B?eHo4aEkwZ1VybHBFd1dIdGpGcHNFbkx6bjdkd2NSRFUvRGdEUGNKSGhwYTVi?=
 =?utf-8?B?Zk5EbEJaNDFCb1dBQU0rOTdSTXVSbkZHTnNlZXBkNUVRSmh3SlErM0pxYlRa?=
 =?utf-8?B?Y3NVcFErbnk5V0xRdzlMTEVlaFdaZ1gxQnBENk9hbGFxMGJ2cE4wcTQ2Q3VQ?=
 =?utf-8?B?U0g3Wi8xWjU0YVd2Q1ZZc1p6dTlTdTh3WmJGbUhJcEJwMGh2YmViTUZwNmFL?=
 =?utf-8?B?bzFlRVZLbkhYSHFyNDJoaEEveExvUVhpYVJ5MDYvQW9OKzh4eDRicGltL1ov?=
 =?utf-8?B?N2dJY0Y1WSt6VWUrUnMvb3l6S1hKTDd5WTB2eGM5OXQxdHltaHlQTytVTFRJ?=
 =?utf-8?B?cGFEWTMrS0ZIQVJxSnZMb0JHOUhlN1oxd0pZRm1pN296MUM5UmR6N2hTTFVJ?=
 =?utf-8?B?VTc2d3JXRVNJZHZHczlBNlRraFlqSnRhV0hzbWErTU1pL3UwZ3llRllmQ3Vr?=
 =?utf-8?B?REJjUDYxZlVSVnVGdTBBc2crQkhNSzk5MHRvRTNsWW42VW9EK2pmYXJFQkgv?=
 =?utf-8?B?aWN2YkpDb05EdXZ5YUpxYnpyTTdXZEh3Q08xUW9rTkRIbExHRHZkRzI2bWoz?=
 =?utf-8?B?SlVOMDEwaGp0RTJGemtLRnV1K1dMSlFtMnFlR3dsRmgxbXlWVmRBVjR0OEg2?=
 =?utf-8?B?Vkc5aTBvbG5hWTRoRjV6VFVDSmNobktzejRTNjdqRlB4Z1ZJeVJhWlFhaWND?=
 =?utf-8?B?cGFmNlF5Qk1TWnJlYjZncTlxaVpzK256WllNOXlveTVSa3FaT1dXaVFTY0R1?=
 =?utf-8?B?emU2UFZFLzY1ejd1NGZyamoxcFQ4ZUNEQmt5WHhpRzZHa2dxTXN3Smo0d2ZD?=
 =?utf-8?B?Z2F5dzExY2V1OWJMV0N2N1p3b3ZqNFlHUlFUcThreVNHN2VUdWMxZnpnS0ZV?=
 =?utf-8?B?SjB2TCtTNUtvVkRXMTFYSkhsWW9valdIRlAwclIwNCtkaG5vZ3gyNEUrdllm?=
 =?utf-8?B?cllTeEM4SU55emZYQUFIWG5tVWJBNEt4L0hoU3RxUXdORmZpTHFidklBVFFy?=
 =?utf-8?B?aWNrUWQzRVRyekRtNlRSdGNOL1pOV2ZvRXQwUC9lTXZGdWJ1ZWE3cHBvM1ov?=
 =?utf-8?B?d1p2SzVVZHE3elRyaitUUGtET1lXQStGcytETkhZYlUvMDlzVjBUbkpZQ3BL?=
 =?utf-8?B?QmNTenc4RjIxby80Umk0cTA5WEFxTEpTelpEYW4yK3pSd0Y0anZpa2JNUXNO?=
 =?utf-8?B?UVhvNUM3dGd5SndoemNETThiVHE0Szl5SkNCSVlUT0kxRFd5MG9qTkNaZ1dV?=
 =?utf-8?B?a2N0SHcxTHMzbzFQRHNUNGZSS29hYUdTa1gxTzFBT3FpSkNGUTdPL1VCWit0?=
 =?utf-8?B?K2doYTR5RlhTY1JZMDM4TUs0c1JYSk9Ba21kbk1iNGV0a29XS0p2SVZPc0FV?=
 =?utf-8?B?UHl1T25ZY0lUWnJ3UjBYWGVKVXZOV2I1QjJvWmR3alkyakFTTzZaN1A5aU9O?=
 =?utf-8?B?SHVOVnh1S1ZTOUw4K0pZcm1UOG9iWVRzdVRBMkRtUndUVnhxYVdrQTV5c3RW?=
 =?utf-8?B?azV3SnNLWEVrMnJIWUZydi9HVXVlY255U0dlaUJiOC96eHdNQUFhUlY5YXRa?=
 =?utf-8?B?ZHdKYU9ycXM4Rk55Mmt0WUJHSStEMmNXdm8yclNHMGFSVjNUNGw2d3FQVDFO?=
 =?utf-8?B?V2FCZm9DdDdzRmMxaGJLOTlJbk5qRzBkUUFhWnpZeGxodm5pcGZFQWN2YlA0?=
 =?utf-8?B?eHpUeEc2QmE5REFHY1BRTG4zZmRjS3gyUVRyWkF5blhKTk5IdGpGQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25d319f-cb30-48a9-00db-08de5de67c70
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 20:56:04.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAfPe0BFWjaRmfPP+d/dfYWVag4mO6a3Fo1Zm24x1gE1UcsQs9aLp3j2JD9dI66g2PKJemvJwq9OON24CljBzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5831
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69289-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 223789A7DD
X-Rspamd-Action: no action

On 1/27/26 12:38 AM, Nikunj A. Dadhania wrote:

Hi Nikunj,

> On 1/27/2026 4:12 AM, Kim Phillips wrote:
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index ea515cf41168..8a6d25db0c00 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
>>   	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>>   		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>   
>> -	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>> +	if (!sev_snp_enabled)
>> +		return;
>> +	/* the following feature bit checks are SNP specific */
>> +
> 
> The early return seems to split up the SNP features unnecessarily.
> 
> Keeping everything under `if (sev_snp_enabled)` is cleaner IMO -
> it's clear that these features belong together. Plus, when
> someone adds the next SNP feature, they won't have to think about
> whether it goes before or after the return. The comment about
> "SNP specific" features becomes redundant as well.
The SNP 'togetherness' semantics are maintained whether under an
'if (sev_snp_enabled)' body, or after an 'if (!sev_snp_enabled) return;'.

Only SNP-specific things are being done in the trailing part of the function,
so it naturally lends itself to do the early return.  It  makes it more
readable by eliminating the unnecessary indentation created by an
'if (sev_snp_enabled)' body.

Meanwhile, I agree with your comments on the first patch in the series.

Thanks for your review,

Kim


