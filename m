Return-Path: <kvm+bounces-39078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2042DA432F8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 03:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E26C117B6A8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 02:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B611369A8;
	Tue, 25 Feb 2025 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aumYmi1X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC8813C9A4;
	Tue, 25 Feb 2025 02:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740450152; cv=fail; b=aY+yPsjwAkXedS6vTLmYDW9h2gtk0rGJzbC8MfjXV20f6Hdcy7JxsHyA+PuwhCUt443ySJqItghrYLI1EvaGEhhf9F0RyFaNtkVnRcgFoN9ufRXCeFcCCkRm8Qw/s35zfgj6KnGaPo3TLVLn5dPivryTXj8oXUjyXt8ymshBHGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740450152; c=relaxed/simple;
	bh=r10p+8VE1tsYpH4pJ2E7iVASUDFfPnw8o2I3JgqB4a8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=shA/+WZmBcf2n9yDnY2vZwWbOfqnlm//oRWUJWsFr0kX59XHmAwQXuk/e7TDwyb0isHmJ1PxDXFZuKw2kp7Us9OuBgCZlx2yPJUsepYd0xAWs/gpjudCyhSYsO9ucjyktdw23VS55fZF8+/VdHtCFdlb7lGQN2zNOQaN4pehWhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aumYmi1X; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoUo0/BCjIsrc+LHUXOi98gDX/q/dHUOygDhykUjX+4RSvAgnFZ5Ra+X1yfY7xbBryIJFnvgwe+A4d2avattnvNpsa9xLXbUoJEJ3bew5MExDaUvp+dWA/GgffLK6ktlvdaHjdLNRljLe22zoa3avdYb8iHQbRRisYXFaGgwLiazZb658sfbXGfvUddVZYn7hWdXsc+n++Xf2JlNarbld4/LE6+vaSo4yEbKFET2tK2j8NH+AsaAHX9uHR6NhvSf5ZpyxTY5QfXSm255lgklOMiQbA7CbJ+ap0oau6WUAWfdEyAhQO9Hxcc8sqS+Ly/9io4ZkYkptMbSqA3F8kgqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NzmYfqtaqBysZyDPO0EyKXFEd/GdMiz8xKN1N2Jfi8=;
 b=V0dCt5iNNhm15/dTIudF+87+TwcyWnn+abUZz123cs7xKn0tEkWVIoHa1i8cpiNNGnotshrhrritSO9uU+DTeQh6hYD27uCLML2Av1UMo0azUG7qkInPmhoiWqI8V2pOeQBPu27Y33Z+g01/1K7uU9IZfVMr9wQfOOeT5SWkI87e8iVCJ4U1WRRouBgrEjrcb0cebZY8uLDPvy1GIn7gh1FjIgt5a1p64SNTWAE5w0+VM26XX945qvqdY4mtRrpQeObSGZA4NuHmagZbnJvhQvlApuSvPZEL+bXVVadGUlOAXmypQY+AevxmQVxo1e01HTliHRtMwIUssURdt+3xgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NzmYfqtaqBysZyDPO0EyKXFEd/GdMiz8xKN1N2Jfi8=;
 b=aumYmi1X3Eo5nkY4FHY9p2PIQ74vhyMvlukbX61sP/tQMOX5US8IKRiJe9LTw+oHBllGCtYjnf7zCmkk5uh4X50q46pOXmiKupuCmcE/hAq+VgG8WpTtvFfHLnsUrNEX+8jRXFdnsbL4HvwSfNICOWrHUGpuphfq4PGCmLgqNoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 DM3PR12MB9436.namprd12.prod.outlook.com (2603:10b6:8:1af::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Tue, 25 Feb 2025 02:22:26 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 02:22:26 +0000
Message-ID: <3a1b6e1c-5a74-4c9d-81d2-7f9a34f58042@amd.com>
Date: Mon, 24 Feb 2025 20:22:19 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] KVM: SVM: Save host DR masks but NOT DRs on CPUs
 with DebugSwap
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-2-seanjc@google.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <20250219012705.1495231-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:806:120::26) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|DM3PR12MB9436:EE_
X-MS-Office365-Filtering-Correlation-Id: f01b5cba-682f-441a-f4cf-08dd55433edd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnF5RUVrZjFabjJGNHJCZUZlaHNxUUZtSTRKQWtIREVPT1o3blNiRk16UEFM?=
 =?utf-8?B?M1ZhSWczQWtYbXNMSWJOZ1NiWFFwWTU0VlBuclUybms5andWY001MU5ydnlJ?=
 =?utf-8?B?bmtvckFSWlBCejh6QmFTUVcxazI2a1pUeWY4NDBXdU5ETkMxZWJrTFZDRzRk?=
 =?utf-8?B?ZVA0ZjhId0Z4Wld0cUFpMlFITkx6cXhSTlc1K1pPUzZOdEVuVlc1d1Y0eDVu?=
 =?utf-8?B?YU9hSWtrL0RJb3p6cjZKU2RWYXNDbXhFU29BbkFzRGM5dEluK0kvcVNtc05s?=
 =?utf-8?B?RkNOb3QvSTBLTWtNcVdpbHZXbjd0aUE1dG1wSEZYRDZzRWxVc3E4YTZ1d3pS?=
 =?utf-8?B?c3BRaEJZVXBiN1NuWFhYRC9QYWtUV01uMXNkWGF0VUdVRXlsQmtoMFB4N2U3?=
 =?utf-8?B?VThSVjdORkx0azM5UDA1bEJXd28wRUZ0OXZ2SXFCRldLSkxXUkd2bUtKWFJC?=
 =?utf-8?B?Wk1CVHIrQmYxdUJzWUFBMnVGRHVDUnNXTzhyVmg3MGc4V3VhRTN0ZUlXY2Yw?=
 =?utf-8?B?L2ZoNlhWRStEWEJ1bnY3VlM4MzNqS3Z2bkZ2YW1OM01Ca3NrYmlvZzdEeVMw?=
 =?utf-8?B?ZGs4a0pHaDRGb0o4QkVHQzB2Z0xvWGlHVHBwUGkxQ0srbG9qNGpLZ3BMQ3hU?=
 =?utf-8?B?QnR1OWo3UkttRFF4aDc2S1Q4MzlySmpuT3B2bUFnNUpLUUJ6OWVBR09WcHN4?=
 =?utf-8?B?dXlBZEJKSDB6djAwbG5nOHJFKzVSOEQwSU95em1wVFlaYi9PbHVzSkRXdjgy?=
 =?utf-8?B?bkgyR1dYMDNvbktIVnNlTlNjU2V1Ky9xUzJNUXRGZEtxUWVMa1RVNzhuZytT?=
 =?utf-8?B?OXJ4bzV4RHFaOUppeFkya3hzM3o1UUJWVTNIMm13U0tQaWxFZkdGNkxwNkJv?=
 =?utf-8?B?TUZ3RlpFWVp2S3FucTlqUlFNaHJDeVFDYkhURmgrNWNRM1dPc3VZMnJmaUhx?=
 =?utf-8?B?R283OXpkQ0JTOVdtY2NqNWgrbHU3NG9QRDUzSnh5THBzL2RET3VLRk1lS0ZX?=
 =?utf-8?B?cFVUZFFJajBJSHFZWVBVd29yQlZlOEVWOE1HVkdsQ09FaWNRcWRHRG1CUFd6?=
 =?utf-8?B?T01wcWF6eWNmMlg2bzJnOUdQamRLYWpZVnVRcmVCUEFxUXdBbmRaUnNyc2pY?=
 =?utf-8?B?cVA3V3ovd1NiS0RTc1lrYWN6QXNDeGNCZCt4bXhKazJMOTNKNG1iOVprT0pF?=
 =?utf-8?B?djd6cVJGNWNKbG9YWXMvcVNuS3I1elRBbFFSczQ5OGc3bUMwUi9ybjYzNmMw?=
 =?utf-8?B?S1YxbXNOMG5VVUhCakpvdWw4Szh1TmVrY3FtOEdINU51MDdaNXBmQUYyaGxN?=
 =?utf-8?B?NXl0QmhFVjlOcVNSUHl3bW5wWUtQcXVoTnZscE15SG82S0JmN3ZWSzV6L1dZ?=
 =?utf-8?B?ZVRkNldCZ3BWdW1ma0p1UmRyYmwrQXZJWXE2eUNTckVEZFZXV1luelNTR2xW?=
 =?utf-8?B?SmdDQWpoaElHMmN5QmhuZ3FRbk9RcTkvOFdKWmxWUm9DekIvNWMvQ01TM3RZ?=
 =?utf-8?B?eTZNeFRaaU1DcXljQlZFQ2pwTXJ5T2R4SU56OTFtVVp0bkZtKzk5WGNlc3Yr?=
 =?utf-8?B?ZzBsVlY2M0tXWHBId1ZNVXRIUnIzUEFzRWRsM09wT2lMN2VLcStpcHhDTWVF?=
 =?utf-8?B?Y3owazdTVGxFdFNJajhTdHVpc28yd2VWNmJwcGVmb1g2b28rVU1aUUZnWFlF?=
 =?utf-8?B?aHhNMHFsdDFzaDFzamJjeU9lK3ZZaThsL2JhTWV4SjFPcXpMb21XdUNQMGVK?=
 =?utf-8?B?YmY1dHZyYXlwbDc3YjZoa3hzSlZXZ1QrY3YzRElIZmFXb2luR0xqY3RTODl2?=
 =?utf-8?B?TnF0elQrZ09SV3lQVFFEZHFZdGpaSC8yUkg1dXV0aFE1UUpzcnYra0dyVTdu?=
 =?utf-8?Q?4kcEKy4W+2MGP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2xia3FZdEI2Mlk2elVlbCtIRTcrYmNSOGpqeElPYktOSkFINk91ZStZanBt?=
 =?utf-8?B?TERlUEpUK2RZbTBBYzltU0w1SWNGS3B1eTYrRndpOWZFaE9wc1BpbjVhbGZr?=
 =?utf-8?B?ckhWNC9PRnh5ZWhPZW0yOEswWHZvVTZsdWdueVpjQXhQMFNBTkNzV1lUa1VZ?=
 =?utf-8?B?RytzcDEySVBXSVZBZU1zMm1yK2F3QlRHalp2ZjdPVjZXRGU5WU1pVnArRW4w?=
 =?utf-8?B?bzdwQk4vVzdEbDM1eVc2cmNTdFRPZzMwZkpnanl1eDU3Mk1vVUsrQmxTRUZh?=
 =?utf-8?B?cmRtTDg2aWdLMnd1azJqdW5oWGg5Q2tXWHdOUmcrRHBSc013aWJTY2xIWkVH?=
 =?utf-8?B?VUtVK1ZSamNhZmhNQjhHUDkwWlJLNHd1RXhIODBHcDM4OFpZNzZINUUvYS9z?=
 =?utf-8?B?aHhWMjBxYTZzbElva1ZweFRldzZVbXorTkdOQkpoQmh1ai9Ga2k5ZkF3ZDhQ?=
 =?utf-8?B?MFZPbUlLL2FPaGEzU0ZZYVJBNko1QzQ2OXlCZFBBOGFtRjFUckg5WXlFZUp2?=
 =?utf-8?B?aWVENHlTUmNoZ1h0QlRUb0lhbGY4eEdVN0JVVzZMdG02MEhwcndDZXRyaGxp?=
 =?utf-8?B?VllPRkNlZlhKeS9ZL3NJS3pmTVhzQUpIZEFraDJSU3VuT0RzeUZhQmRVV2No?=
 =?utf-8?B?YVpJNU01d2pDTlNmT0VLU0FIVEh5aFc4ZFM0VTNKeGZ0ZnRoL0xFM3pGU1pD?=
 =?utf-8?B?THRxL2R6WXY2a0ZNa1pzb2lzT2ltQmtmUXVIZGxweTJkR3o1MGhGVXE0WWlm?=
 =?utf-8?B?b3RpNnR2UTQwRDNJajArZU1NRHZiUG1vbGJvNXJ5Kys1VVNzV2szOTBqYlo2?=
 =?utf-8?B?YW91UEg1MEF3QVFvdUc5YTZLRVJyekJVcXdicHB4MnRPWDhkTGhoSDhiZmxm?=
 =?utf-8?B?Z21FRW5rTmxzUUk2c05FRUpaNE9yalpNalpZK1hrTWVPTm1PN2NRNWRJL05J?=
 =?utf-8?B?VUZkWUJFRGREaitnVmVQb25DVTRKY1FOTWE5RGRBUi93UUdPY2w5RnpJbUs1?=
 =?utf-8?B?dCtMVnBZWmZPaGJONmp0QkF3L0dWZXBoWXZ0ZTEvNXZKUFFHcVlGUmRJS240?=
 =?utf-8?B?NWVUZVhLS3Y5dUt5cnlNdnRWcGhOZWNGaEZoSjZwTGNZRnZTcFV1NFlORnZ4?=
 =?utf-8?B?ZnIwV3FCV0VQdU1MNmlPTWdUczRkNGQ5RzlFSTN4NHlaRGFzOU9INGFEa3NT?=
 =?utf-8?B?ejYzanFSN3NZTVB3NHB6MHNRTEhTSUgzclRxMUZ1eWRwTWlybGFqL1VEeFFy?=
 =?utf-8?B?TjRwV091QTB2aWJZMWRYelk0Tk9tYloxMjBoYitEbGtiOGZCRG5iVG5CWldC?=
 =?utf-8?B?QzhZWHhXNG5YeWp5bmpTc3ZBUmlvT3JkcldDand1NkF6RGtqS29FMEF6NVlU?=
 =?utf-8?B?OG0rSE1aV2FlN3IxVFRsSzhUV2dYYjRHMFNoWVowd3ZqVmhMQ1NwSUFSTEtV?=
 =?utf-8?B?c1FmT3hVOStuY0kvcUU3MmhFTnJrZHpjRjVOZDFWSFhqVFQ5dXkzVE1jb1Nk?=
 =?utf-8?B?cTc4RHduQkF2bXpJcFFrckpKSDZjZE9SMGdMK0hHK3RpWmd1OVlaa09oN3lI?=
 =?utf-8?B?ZjNjajh3amdMWjV1b2tmR3Fmb3dKcTdEbnhMaVRrc05FU3pXcExqMkpWeWFw?=
 =?utf-8?B?aDk1QXdnSWJzcWpGbmhuV1k5dS9tUWhtMklMYW9ERG53VlFBUGVkOUxkZTlk?=
 =?utf-8?B?OVlNZ1hmbHd2cE5ySnBpclRxTXZTaVFHWFJCZ1VFL0JqcHFIZWRldW4xU0RX?=
 =?utf-8?B?OGl6Zk1sdmt0RjdyZW53c3BQZFdNRHVjOEFWU2JmNFFyL041eWlZamtBcVY2?=
 =?utf-8?B?M0liSVkvVm4xNDBES2xRZmlLNGs5aDgzNi9zTXA2OCs2RHk2NTRYNXcwYWtQ?=
 =?utf-8?B?M1lBbEpJcXpNZ1U0UitTV3NNNERjZkFNYlArTGMxSm16citVc0RZOS9EWmp5?=
 =?utf-8?B?UnNEYkFoN21jUC9BK2NrZytJd1hYUjVWUVgxRzd3S2JnbU8xRkI3REFrYkNN?=
 =?utf-8?B?SEpvdUdpWTJIbVJQVXJoTFYzN01rMzV0b0FKaVVQaHpQdi9KS3BNbWFwWGRx?=
 =?utf-8?B?aEtvWGQyamdlN3g1RnhqdTdjc3N0K2hTcitxMzV2N2RsZ09wL0RQd2EwVmFO?=
 =?utf-8?Q?Yq5ad3U54GntpMHs8bGilCI0w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01b5cba-682f-441a-f4cf-08dd55433edd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 02:22:26.3782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvbAJpy0zkc/YgyWeSD2CEybsWX5fP4if/90HWYHi1aJSucXTzsbrIbSSdjAYFFfpwGk5QLXyrHF99TOIzrZcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9436

On 2/18/25 7:26 PM, Sean Christopherson wrote:
> When running SEV-SNP guests on a CPU that supports DebugSwap, always save
> the host's DR0..DR3 mask MSR values irrespective of whether or not
> DebugSwap is enabled, to ensure the host values aren't clobbered by the
> CPU.
> 
> SVM_VMGEXIT_AP_CREATE is deeply flawed in that it allows the *guest* to
> create a VMSA with guest-controlled SEV_FEATURES.  A well behaved guest
> can inform the hypervisor, i.e. KVM, of its "requested" features, but on
> CPUs without ALLOWED_SEV_FEATURES support, nothing prevents the guest from
> lying about which SEV features are being enabled (or not!).
> 
> If a misbehaving guest enables DebugSwap in a secondary vCPU's VMSA, the
> CPU will load the DR0..DR3 mask MSRs on #VMEXIT, i.e. will clobber the
> MSRs with '0' if KVM doesn't save its desired value.
> 
> Note, DR0..DR3 themselves are "ok", as DR7 is reset on #VMEXIT, and KVM
> restores all DRs in common x86 code as needed via hw_breakpoint_restore().
> I.e. there is no risk of host DR0..DR3 being clobbered (when it matters).
> However, there is a flaw in the opposite direction; because the guest can
> lie about enabling DebugSwap, i.e. can *disable* DebugSwap without KVM's
> knowledge, KVM must not rely on the CPU to restore DRs.  Defer fixing
> that wart, as it's more of a documentation issue than a bug in the code.
> 
> Note, KVM added support for DebugSwap on commit d1f85fbe836e ("KVM: SEV:
> Enable data breakpoints in SEV-ES"), but that is not an appropriate Fixes,
> as the underlying flaw exists in hardware, not in KVM.  I.e. all kernels
> that support SEV-SNP need to be patched, not just kernels with KVM's full
> support for DebugSwap (ignoring that DebugSwap support landed first).
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Cc: stable@vger.kernel.org
> Cc: Naveen N Rao <naveen@kernel.org>
> Cc: Kim Phillips <kim.phillips@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 74525651770a..e3606d072735 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4568,6 +4568,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>   
>   void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
>   {
> +	struct kvm *kvm = svm->vcpu.kvm;
> +
>   	/*
>   	 * All host state for SEV-ES guests is categorized into three swap types
>   	 * based on how it is handled by hardware during a world switch:
> @@ -4592,9 +4594,14 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
>   	/*
>   	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
>   	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
> -	 * saves and loads debug registers (Type-A).
> +	 * saves and loads debug registers (Type-A).  Sadly, on CPUs without
> +	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
> +	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create",
> +	 * and so KVM must save DRs if DebugSwap is supported to prevent DRs
> +	 * from being clobbered by a misbehaving guest.
>   	 */
> -	if (sev_vcpu_has_debug_swap(svm)) {
> +	if (sev_vcpu_has_debug_swap(svm) ||
> +	    (sev_snp_guest(kvm) && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {

Both ALLOWED_SEV_FEATURES and DEBUG_SWAP are also SEV-ES (not only SNP)
features, so s/sev_snp_guest/sev_es_guest/?

Thanks,

Kim

