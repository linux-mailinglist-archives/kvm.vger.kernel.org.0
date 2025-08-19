Return-Path: <kvm+bounces-54951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C729BB2B850
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 06:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B5C37B0E55
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 04:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25AB1D86DC;
	Tue, 19 Aug 2025 04:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oGvSJkUh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509BC38B;
	Tue, 19 Aug 2025 04:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755576920; cv=fail; b=i5TibHuRqa7EinAzKFppqdTyzLKY7Yx6hRUBGBow+R4ofmWQ5ksDn4AHQQtHcq+gLQepumW3HgEvfcnhameLQihi+POGJPImIlBnxHQ4wFalkuFKuVTc5wlvCO72z2Zp5LsJ9NhkgWo2C251gzpawRvQlMGVCf5BhinEkQoo7T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755576920; c=relaxed/simple;
	bh=C6jyCXtkDT4aB3KqeztDNk0BYIJvKU+DP6ihn1XkwZc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kan3xLtVOpdj6jgkEd1zSaKL0I7t0ZfCYcG7x8cFQaqA7UrEpJZDOxT285tQekXPgiZeJI4qDPbE1jabMPSQnxIZYC+htSssZgg6QJp8iuyGWeyhl6ip7ZOQjBeTOQ7Ts7NwBsqxJe1p43a2tnSmTQ6MzllsH1Pyf5rNVkU5fe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oGvSJkUh; arc=fail smtp.client-ip=40.107.95.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ueFxsTjBowiMwPmCeVaNsi51uFpzQer4oqbV4VSeBGJPL9/5g7JOaCPAw8XVFW7qo9Pvea1TR+0+N5x2CBsDY2E6snCCI4p8gFkGqgTp6CwalOp+8OCcsSm/YrUH0xnA6eDBQMVbpW+oSt5ymKPWyJp8Rh1R88WJ43xjgoLTB0Y+2QyBMxhmPCijMbFk4wYbsNCVJ4tslEfKwqPN7qqN+6hVUD6FpHoT1IKgGarsSfTYZSIVUV66/r3X5mJTl4QhXAc2mTY8Tt2vUQs/WqlI1N0zlk+xplG+0XzjXEDwQnBiSZjMjzRKLCgj3KyoSCXLQkUXzYtjF2tumklm8BMCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8AqGtqeFWQOETY65eYXos4FRwq3hUaZrxNcm7Eld5Ms=;
 b=Yo2DHbrusLD2MYhjauzfDkQhXDzgxzbWiwzmQ1Iwlf++Man4Dsd0vzothGHCNtmvCv+8W9p3RnCXhyjYTDV4ywKnQMRcjonJ6SoJSGZulLV32ylwrkKG7bXKrP4CGBtq6EsyOh77whZurU1EToP5I33xySkv2w0U7HkupZVbPn+3OvMXTIbz4mpQrZ9GKzFL9aLTYOzyXtUdrNEbI13cxLhF7J3YJtGJuOl+HW1tFPwT26TBhSlmfXKNwjXfLxX/wqQ3GK9B6Mevjh96U/Xr/xUYltUjeE1y4zKHXiiUjB/pde+m4paygilFWo5zcMoCZr59Jiz7KP8SCKn3D7792g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AqGtqeFWQOETY65eYXos4FRwq3hUaZrxNcm7Eld5Ms=;
 b=oGvSJkUhVWN7Nb0vGBEzPl4rYGQ3pIG1isIZ6VU/aKMSmBr4ahZPo5gKKdoEdkeHTVH34hyhdXA3JfVuKwbG8FySXM8KkEHmLLJDVN1FblSfzTlu8/UD9ek+h4+bTmLYeca+8c88d7iW1kc/UTj3Fs0W6kbqAYOefpJTPnr7NhE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DS0PR12MB7849.namprd12.prod.outlook.com (2603:10b6:8:141::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Tue, 19 Aug 2025 04:15:15 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 04:15:15 +0000
Message-ID: <964f3885-059e-4ab0-b8fc-1b949f0b853b@amd.com>
Date: Tue, 19 Aug 2025 09:45:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/18] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-4-Neeraj.Upadhyay@amd.com>
 <20250818112650.GFaKMN-kR_4SLxrqov@fat_crate.local>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <20250818112650.GFaKMN-kR_4SLxrqov@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0128.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::13) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: ada3956f-5e4b-463b-e6d3-08ddded6ff6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVp4SHJrWmdiRkxOZForMmhzMHBuN1gwS0RQaTdMWERqZmE2Mk8vTGRDeUlE?=
 =?utf-8?B?enR1b054eDBYS0ZRNUlBc0IxMmJOWXU0TFBUbmEvalBtUnFacm1xNXVySXZ1?=
 =?utf-8?B?OUJrN2ZDaGNNaTk5OTIrSGZPV0wzQlZCOWM1QWpNTFUyMjVrSHNlNVVFYy8r?=
 =?utf-8?B?Qm84MWttWFBJa3pVVHZuMzIzK1dQeWVZdkw4U1lTcGVyU2NjOFdtaU1lV055?=
 =?utf-8?B?R3BiYncvYmdRTlkyRzFlTlBSYUpnNFdhditaaVoxN0p6UFlRNjRJY0pnRXFG?=
 =?utf-8?B?bHJhQXhBd0JZZ1poMFAyVjVxc282R3hBNmdKQzJkVEw1VWxCVkpZWFJqWlRi?=
 =?utf-8?B?aEVmb1BTSW1jT1Z1U082bkRrR2YzWGZFdVVkV1NQejl4R2RlQ1ZIR0VDYThp?=
 =?utf-8?B?QlRBYmpiT3Q4eFdpWURsSXlxNmhXRE5XSUI1OXNrb3ZtZ0g3RVREc0lBcUtL?=
 =?utf-8?B?b0N6QWgzN3I2WkQ0QnVEOVBsNVUyTzl3Ly9jaVpPV2x5V3k3bkxlcUpPaUlQ?=
 =?utf-8?B?RXJnTVJsNXVMc3ZXaFBIL1E4SnNmZ2dReGg4enFUYTJRTVAySjlqQXpSZWFh?=
 =?utf-8?B?b2ZITHZuVVluWm5POXZFT0MraTNTOStoRngrMU5sNFptUE0xRk9kQjJpUnM5?=
 =?utf-8?B?Zk1odlJoMVQzSzNuVHlXNXRhaW1lYU1NSXBMYXlGMFRBdXAxUDJ1bFVvaU5Y?=
 =?utf-8?B?NHdBYUE4L2ZXaTdQakwwdWRSSGVSSlVhVHZGVWpwS3lTelJwK1RoTTl3V0lu?=
 =?utf-8?B?ejZyWmhJWURGTmQzQ2lNU1dERUc4aFhkU09ZVzl1ZkphVFFpNXd2YmVoam5I?=
 =?utf-8?B?bS8wVnhXTjR0aldwL0NZWXN6R2ZGWDJrcTJzSmFFc1F4bWxHY2dweHhhVVkz?=
 =?utf-8?B?aG5GQktuZXVWajZ0cGJQM3Z6K21ZM25MUlR6WnA5MFNzS2JTMWY3MU1hZVFW?=
 =?utf-8?B?UUNvc0lVZlEwU0pvYUdpZk42c3RNaWJOY1lSUE1CSUo1TFM5MHBRTnhsczNj?=
 =?utf-8?B?amd0MEVNMXFEam8yVnAvK1JPKy9ab1djemdKYjhrNkUxYk1JZkFSQ3A1MGU2?=
 =?utf-8?B?SmVtUFZRWVBvL0NpYmdtVmpSWkNodFlzZlgxWDJqdkFSYTFXbGlneVRYdUFv?=
 =?utf-8?B?dlA1VXVWUEdHL3pPLytISGdOVG03MzduOG1ZYmdWRXV4ODY5dkdxSU5ySjRW?=
 =?utf-8?B?Wmw3WENvSWQ5Nk92KzhEVDV6R1lSb2orMlpkT1l1eVhtUE8vMm8zSVJqeEta?=
 =?utf-8?B?WHJ1akxWODlLMXZGUG1ZVlY1TSsrRHhsbGhSVVZkNXpZY3JFTjcvdFNBVi9T?=
 =?utf-8?B?SzZGaVlqNUtCaDIxRk5xKzVGWHJZczJlNmV5OURvQW40ZkxFUEhrc3JGMHNV?=
 =?utf-8?B?TFN6OVc4REwvTFkxMUpSMzlNbjhxb25GY0I2U1JRa2Z6RUpOaGxQZkdPa2kv?=
 =?utf-8?B?Tkd5RG9ENHV0YlovOHRVbTRFLzgzNk1kL09PRTBZTDdENHFvd3lPVC8yTlJT?=
 =?utf-8?B?OWJ6TXJGRFBRTG1maHdQYi9VMzRSNGVhSFJaQnFPZzNxVXdkSUpZK3gxRmxj?=
 =?utf-8?B?Z0lCOEpIR2lOWGJucFRtREM1dXRnckw0ZStOYjlJLyt0STE3TjJIdC8vRWM5?=
 =?utf-8?B?VDFESmpETHNCLzNyRlNlTUdnZ1JlUmcwOXZZUm5RU3VuSk5GdTNzcmM5VCtD?=
 =?utf-8?B?UzlSUGFJZUFPNHFMWFZyVit5V0ZES1dHVlFEUnpKV21IeGVYemcwSE45QXJi?=
 =?utf-8?B?bGhkb2FCaUNZVk5LL2FYdHU3TzJ1bmpLN25sSzZwSUZyd1BpMThXRE1GeFR2?=
 =?utf-8?B?R3pRZmZFMDBXTUdZWVJaQkk1dmtYelhEaFlaWTg4d0d0OUFsLzZ2azBUV2lN?=
 =?utf-8?B?eDE0MkQ0eVVFTWRGTk1vdU45VU1vbGRUbWVJSXI3dmY0QUdJTlRPL1Z6eXFK?=
 =?utf-8?Q?5mS/ef7gGbM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ump1cWJvNVRhcWhTbGpPRDNIdVc5ZjRqQXpqNTMzNW9RWHh4RXJzbWpEL2Mz?=
 =?utf-8?B?U0JWS0ZxOFZoMU0xQWpBb2VmYjRBblRYTkJNWTY3aWNpNW1UR0pkanBjbEh4?=
 =?utf-8?B?ZGhMdkJPaGlwUTAvV3E3RFkydUI2QUtRTkE2c1AwOVdHY3N4RTNLakdkRTF3?=
 =?utf-8?B?Y0t0SEUzYk1uMXhndktNUHozMkE4aDF1S3pETTdQQkprSnNoTHJINFdnOWxr?=
 =?utf-8?B?NTFvZzgyNFVvUnBjcXpDMkUvZWgrNXIvdlpLVm5qMlZaQS9oUnEveHIxeVN0?=
 =?utf-8?B?OU1DZWkyeFJ5VllzOXNielpJdFY1RUNZSjBWMXlzMmNHQVdIb0RkYmhaNzBG?=
 =?utf-8?B?ZmV6eEV3MWxwQTM2QWlDL3RudkRhMW5xR0dmSWlSS2x2V1dIcU43L1hpN1la?=
 =?utf-8?B?aWsvMjhDOXlmNEFscEJCcnBtQTU2blRtNkV4QXlpZWxVeVd0eXBMM3FQQjBa?=
 =?utf-8?B?ZE44U0tFTWpBT2ZNVGo3dFk5TkdXVUY2M3BWTmJwTWxjY3VpT1h5enIyVG1j?=
 =?utf-8?B?QUVnT0FaaGFFREdPUCtZcm81djBhcWtkODFxYkJ6bDVOVUo4Z3VyNkZzYWRQ?=
 =?utf-8?B?Z0pVcXdJN25HVDJHZzF3eFVlbTZZd2FJYXBOemxIQllkWjJLcWFGazl5YVhM?=
 =?utf-8?B?WUlTekRwR2x4azIxdDh2TU4rWGFjcXlZVUZHSlVZMWZ5dndDQ3FjSkxuRWxx?=
 =?utf-8?B?eHQ1NzV1Vk9Xbm5Ucjc0U1dFTkxqeFNJWnJ5ZU85OUI1bGZEWkw2VzFnd2c1?=
 =?utf-8?B?WlpBQThQeEY4Q0hWRDJLS0F4cVB4SVR2OXN5QklTWC81WGFCa1I5dUs2aVdZ?=
 =?utf-8?B?U0FxVCtGNjZHNzRLN2tXbzFySVhPbEYvVWxnbUZ0WGY4SjY1SmorTnBVcXdp?=
 =?utf-8?B?Tm5IaFM1dlp3MmhOL2lPdWRUWHNkTzR6Tk4wUEhuWEI0M2FHc1YvTVBaRVdt?=
 =?utf-8?B?MHVTd2hRWUs1bitUMDdKZGZDZU5pcEcvNXdQY0RjRVF6MGlTSSszNWk1bVNT?=
 =?utf-8?B?YVJCbmxDREZrTnFpM0pEa09DNFh3LzhsNnFMVkJPUUVINVRDeXNLT093TW93?=
 =?utf-8?B?cG84dzYrc25VZnhjZUhJMjFvT0FSbk9BYUkrQlRPQldOMDB1OVBtVlh2eVJZ?=
 =?utf-8?B?R2FxRWUyK3JQeTRSRTJpVmVCbms2QkNEMTYrNDh1QWxIcWk5QWdyUmdtb2g5?=
 =?utf-8?B?RFdCN1RpYTZrZkNTaklOazFiYjRPZ2dJWEZyNGx2UU5NUXE4RXIvU0NERFVl?=
 =?utf-8?B?QlRCbjMyeHhBbVphTWNjRlRQdkdZR0Jpc3lGME9sOExpdTI5M3VwMzBkcWEz?=
 =?utf-8?B?NmFkNG1UYjM2dGFyMCtVS3pXOTg2cDdMV281UHJyT1E3dlBYNXV1a05uWGlO?=
 =?utf-8?B?ZVNhSW5jVEdWSzFWMVowNGtZSzRJTWJieWFaT20vYWNBeER1VzhIbUhNNkVW?=
 =?utf-8?B?dUhoQnkxYU1KN1FobGw5bVpqbFhJSVU3dEFSSXBnTWlocUhKdjljeDhGYlpQ?=
 =?utf-8?B?OC9VNlVtcmRJVSsycWttSnA4dk0wKzlrWnpLdzZCTklXUXB4b3orby9HQjFk?=
 =?utf-8?B?bEkxY010NFpiRHRYN1NPS2x2S2E0RXVMZktwQ1kyU1I4cVV3Rld6VE5qQ0s3?=
 =?utf-8?B?MmYzY2JwRTJBdkdqZmNVaGVaZEFoRXN6WXZHUlhwK2NTWmRWMVlzRm9VSnla?=
 =?utf-8?B?NHQxdlh1V1JrblFPOHlwMzFsZER5cXUzQVlYYXdUVHBkeGsvUENFQXhiYUxt?=
 =?utf-8?B?T29FaUI2MEs1aDVxRDBUcDZneUplQjVudnozUStaM3RSVFlPSE5oZWxvdVBH?=
 =?utf-8?B?NmNmTE5IMXFXeDVFVFNod0RuUzg2S05zZkZXMjhUNnZCYklSOUlWNVV1dzdj?=
 =?utf-8?B?cDc5UFB6bzlMTmdvOWxlMWZKRXNSbmk1RE1IcDE4U0c0Z202Y0RxcFJtc0w4?=
 =?utf-8?B?U0FINlNoNURIZlN3V0RpNE1iQTRWcThaV0pLMzhCOC9waWxuWVZZMmtRVGY2?=
 =?utf-8?B?MHF2dVVWdGpRaDFPT1NMS3FLdE1xbHdWNkh6dTBjMUl0aFY4SnlpRXdCaWRw?=
 =?utf-8?B?alNrU2VxdFMwVFdkSi9BSnRFQmxNZklSZHJNeDJSc1plME1NNUxKaUl2WUZI?=
 =?utf-8?Q?KQ8uAhVYaSzdIBhkou+p3uztT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada3956f-5e4b-463b-e6d3-08ddded6ff6e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 04:15:15.0090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eYXZG8+0RXjVcsQWlLg80oBsMP246Zy2UtrPHim3QmYFuczWDtha42oVdb1heCB1tPf4o9Qq6VcGfuuW2zz3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849



On 8/18/2025 4:56 PM, Borislav Petkov wrote:
> On Mon, Aug 11, 2025 at 03:14:29PM +0530, Neeraj Upadhyay wrote:
>> Add read() and write() APIC callback functions to read and write x2APIC
>> registers directly from the guest APIC backing page of a vCPU.
>>
>> The x2APIC registers are mapped at an offset within the guest APIC
>> backing page which is same as their x2APIC MMIO offset. Secure AVIC
>> adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
>> within the IRR register offset range) and NMI_REQ to the APIC register
>> space.
>>
>> When Secure AVIC is enabled, guest's rdmsr/wrmsr of APIC registers
>> result in VC exception (for non-accelerated register accesses) with
> 
> s/VC/#VC/g since you're talking about an exception vector.
> 

Ok

>> error code VMEXIT_AVIC_NOACCEL. The VC exception handler can read/write
>> the x2APIC register in the guest APIC backing page to complete the
>> rdmsr/wrmsr.
> 
> All x86 insns in caps pls: RDMSR/WRMSR.
> 

Ok

>> +static u32 savic_read(u32 reg)
>> +{
>> +	void *ap = this_cpu_ptr(secure_avic_page);
>> +
>> +	/*
>> +	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers
>> +	 * result in VC exception (for non-accelerated register accesses)
>> +	 * with VMEXIT_AVIC_NOACCEL error code. The VC exception handler
>> +	 * can read/write the x2APIC register in the guest APIC backing page.
>> +	 * Since doing this would increase the latency of accessing x2APIC
>> +	 * registers, instead of doing rdmsr/wrmsr based accesses and
>> +	 * handling apic register reads/writes in VC exception, the read()
> 
> s/apic/APIC/g
> 
> Please be consistent across the whole set. Acronyms are in all caps. Insn
> names too.
> 

Ok

>> +	 * and write() callbacks directly read/write APIC register from/to
>> +	 * the vCPU APIC backing page.
>> +	 */
> 
> Move that comment above the function. And also split it in paragraphs: when it
> becomes more than 4-5 lines, split the next one with a new line.
> 

Ok

>> +	switch (reg) {
>> +	case APIC_LVTT:
>> +	case APIC_TMICT:
>> +	case APIC_TMCCT:
>> +	case APIC_TDCR:
>> +	case APIC_ID:
>> +	case APIC_LVR:
>> +	case APIC_TASKPRI:
>> +	case APIC_ARBPRI:
>> +	case APIC_PROCPRI:
>> +	case APIC_LDR:
>> +	case APIC_SPIV:
>> +	case APIC_ESR:
>> +	case APIC_LVTTHMR:
>> +	case APIC_LVTPC:
>> +	case APIC_LVT0:
>> +	case APIC_LVT1:
>> +	case APIC_LVTERR:
>> +	case APIC_EFEAT:
>> +	case APIC_ECTRL:
>> +	case APIC_SEOI:
>> +	case APIC_IER:
>> +	case APIC_EILVTn(0) ... APIC_EILVTn(3):
>> +		return apic_get_reg(ap, reg);
>> +	case APIC_ICR:
>> +		return (u32) apic_get_reg64(ap, reg);
> 			    ^
> 
> no need for that space.
> 

Ok, will remove.

>> +	case APIC_ISR ... APIC_ISR + 0x70:
>> +	case APIC_TMR ... APIC_TMR + 0x70:
>> +		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
>> +			      "APIC reg read offset 0x%x not aligned at 16 bytes", reg))
>> +			return 0;
>> +		return apic_get_reg(ap, reg);
>> +	/* IRR and ALLOWED_IRR offset range */
>> +	case APIC_IRR ... APIC_IRR + 0x74:
>> +		/*
>> +		 * Either aligned at 16 bytes for valid IRR reg offset or a
>> +		 * valid Secure AVIC ALLOWED_IRR offset.
>> +		 */
>> +		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
>> +				IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
>> +			      "Misaligned IRR/ALLOWED_IRR APIC reg read offset 0x%x", reg))
> 
> What is that second thing supposed to catch?
> 
> reg can be aligned to 16 but reg - SAVIC_ALLOWED_IRR cannot be?
> 

APIC_IRR register offsets are:

#Offset    #bits         Description

0x200      31:0         vectors 0-31
0x210      31:0         vectors 32-63
...
0x270      31:0         vectors 224-255

ALLOWED_IRR register offsets are:

#Offset    #bits         Description

0x204      31:0         vectors 0-31
0x214      31:0         vectors 32-63
...
0x274      31:0         vectors 224-255

IS_ALIGNED(reg, 16) is when 'reg' is an APIC_IRR register, which are 16 
byte aligned.

IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16) is for the case when 'reg' is
a SAVIC_ALLOWED_IRR register. which are at 16 byte strides from the 
SAVIC_ALLOWED_IRR base offset. Expected values of (reg - 
SAVIC_ALLOWED_IRR) are 0, 0x10, 0x20, ..., 0x70.

If both checks fail, that is a invalid offset ('!' is on the final ORed
value).

!(IS_ALIGNED(reg, 16) || IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16))




> I can't follow the comment... perhaps write it out and not try to be clever.
> 

Maybe change it to below?

/*
  * Valid APIC_IRR/SAVIC_ALLOWED_IRR registers are at 16 bytes strides
  * from their respective base offset.
  */

if (WARN_ONCE(!(IS_ALIGNED(reg - APIC_IRR, 16) ||
                 IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
               "Misaligned APIC_IRR/ALLOWED_IRR APIC register read 
offset 0x%x",
               reg))

>> +			return 0;
>> +		return apic_get_reg(ap, reg);
>> +	default:
>> +		pr_err("Permission denied: read of Secure AVIC reg offset 0x%x\n", reg);
> 
> Permission denied?
> 
> "Error reading unknown Secure AVIC reg offset..."
> 
> I'd say.
> 

Ok, yes it is clearer.

- Neeraj

