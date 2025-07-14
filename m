Return-Path: <kvm+bounces-52267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F415B03638
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 07:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFD0B164FEE
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0DC20AF9A;
	Mon, 14 Jul 2025 05:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PjI5WHrs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D9A2046BA;
	Mon, 14 Jul 2025 05:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752471803; cv=fail; b=HOjY9Ev8D0sf2P8VNGTVKjJASLfHKUCewtAYPeVgKX42HIiHyRukBJRDfDt5Rp3o2/iIYLovmY99cQsn4pf7xNW7VJXOd10AR+pXgDaW0rTxtu6ZlTKXPUAlp056xldc72bKYX0a26Rcl0vpTEuG0+4DcostYyGc0MdC4vkxVP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752471803; c=relaxed/simple;
	bh=XxzEOANBz3iLAHY68aU3586eXCJNF09dtTjjmW4uQ3I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t9fFqmI1yO5sV20h0li1PzfQQURPHsmWKrQMv2yLbSFB6au2Y5k6IjvCE2bpPQSMtERIa2Cvdj12T9BXMitt6K9QG/USTMLTyl/mSrugrHBjt/QEeZzh9pgX/h5YXLh8UfJCPahSSPU3P2XoZbZXsAE6QzoYIv4gf0mwGILrWMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PjI5WHrs; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XaNugzId505NRsbcw+Jv+tIBqzb+ZBP1hxbsGhYA96BrrmUG/PltWiqOQ5t8TaERAuhNS1Gh06aZOrIBfHmQZlcHZcSAt941islFmwV215xzgyD4fMhS5K6TKgZzSmnmPxC7EmjvsJ1mv+oQghQDWvDEZNfQszQbMR4krX0G02Ix4rfuvccgTAH0Ojr3/GMADuKEx48z8OhRa9XT2HROocWdA1BswPdYPHdc6oaJE39esZPWElbc7HHFIfE0rju8dQuqYtYDmJWtEO2RuZOYpi/KZUAcudk6SZMXxaJ8SFp1gVziyi5wNeVq21jZ/tsv6Xv+cKRvypyZe38mqwCMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MULHtqelWof0fQOoG5qQd/eHhlSNI45B5FGli4mBEc=;
 b=QPapLku2n1OY+AukrhaP8cokXhcRC1hLVC32k9cT7Xl1QVVkgXr2qzqLTjGNrHYAvHck8jRLVMlxzO8/I1L9xFHzmpCmTjNuJXrEqC268R64plYYo/cS60L8MXonys6Dxn7/e8ZkvQuZkUOM0HI5v8dfKgVzQhUk85ifumQugsSZmoUbeuodoMOUwcw4cNUiFOTJQreRnDSV63OjRo6MJ8KnMLQ6buTgJzQpPAXODUYH0amvmN4twVJLqhmOVL/LWEhgZn4j/0ek8t6pHhFrgRsgTLUZ8a4y7BeHjO4ULwbO5jdDBiEmcleSm7135m9c71t7jdWBNjoMF8DAzXJCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MULHtqelWof0fQOoG5qQd/eHhlSNI45B5FGli4mBEc=;
 b=PjI5WHrsBBxElznCflePBhtlGyl5BKQFX2wyjBJmEw6CgCF/N54uz8KeAow8XEg2jIIvAUF1+opENDXEpHlFkawDtw3/08urTdnoW+WKbMUR4e0KZ3nwsP9O8grxfBJ2UP31DmIXObJWhrXOGL5ZmZGzKytIbOnuJOaxCPD6juE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by MW4PR12MB6779.namprd12.prod.outlook.com (2603:10b6:303:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 05:43:18 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%4]) with mapi id 15.20.8901.024; Mon, 14 Jul 2025
 05:43:18 +0000
Message-ID: <7ea7a720-1271-4021-b6e1-89b9aa3b69ba@amd.com>
Date: Mon, 14 Jul 2025 11:13:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when
 vCPUs have been created
To: Kai Huang <kai.huang@intel.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, rick.p.edgecombe@intel.com,
 chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <cover.1752444335.git.kai.huang@intel.com>
 <135a35223ce8d01cea06b6cef30bfe494ec85827.1752444335.git.kai.huang@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <135a35223ce8d01cea06b6cef30bfe494ec85827.1752444335.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0098.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:278::7) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|MW4PR12MB6779:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a1192c-2858-4fc8-44b2-08ddc299559f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTROTzNFWGdaU1BYZU5TQlE0a2djTVAxcGhJanlNZzkweXIrVWk0dG1tZkVo?=
 =?utf-8?B?b2w0cGYvdFBwSXR6eXpkSVVNOW1ObytqMzJlb25aWVVxd0NaL2NyVkZOQ1dp?=
 =?utf-8?B?ZndPT2ZiQTM1RkgyNCtXcGJ3MVNVUmdnamtlT1c0aWZjbGpJUWRXc2JVVW1S?=
 =?utf-8?B?YklQQnZ3S3p1NkR6cjJGRjRkaE9vdmE3RVNMUHJ2cDRkOHpGUjhWVjd5cEgv?=
 =?utf-8?B?dTZHYjduWHRzTFcrbzRPQk5vdlZWanQ1a0Jxak84WXVwOFgwMUVNeVdIcDBP?=
 =?utf-8?B?cHZSY3lLSXl0L2tnR0QyMzdFUlNNRnZKa0E2bEd1Uis2cHdDQzBBTHJDTXg1?=
 =?utf-8?B?c2hISEVZK05uS0c5SDlBUlFpbEhsY2FRREhFblB0NENYQlRBSTl1eTU4NmpF?=
 =?utf-8?B?dEdHblF4VENmRUluQlBqYlRzQ0d2QnI4RWZickhKTm5xUkpWUWl6TE9SbXFm?=
 =?utf-8?B?dkhXMk5oMjFoWXoyaTZVT2p0QkxscUdEVG04dVZtREVSSCtjN1ZMY1VkWjM5?=
 =?utf-8?B?YmE1OCt0TVMveTNxZGZweVRzQlk5RDdIV3BzbW1jMjk3OXByT1M1V3dzQTd5?=
 =?utf-8?B?V0tiQkNXRTgzeU92eUhqSEgzbm90SEhPMjlxQzBlNE16dnVTM2xMeEVYazFn?=
 =?utf-8?B?T0NuUTZRVFFSTUJYL0xjL0dubWJJYlYwZkpPTjVJT0c4U1p2YkVMaWZCNWsx?=
 =?utf-8?B?VS9hVTArazRkZ0Y1dVo5ZjZNMy8vejZ3ZlBvQUo0S3hDQ3dSYVNMM3hEejd3?=
 =?utf-8?B?Y0M2VHg3Y2lQOWpRV0FTOUwzVVdhSEtjR0hOMXU2SDd0SEFLTy9KeGs5YVNs?=
 =?utf-8?B?VERtMWJjaWE0eWNwdG5HMDZycW1FSFFJVDR0c0UxTWQzek91Vnd1V202M2lY?=
 =?utf-8?B?U0h6U2pHUjRKeWgvRlVrUEtmUFF5T1hzdlZtbDRjTVovcDRnTnU1c0hVOFg1?=
 =?utf-8?B?TlQyTks5REFYUHdTdkpIdnQ3RXNwUkdiY1F3a3U5Y3BUTWRwazM4TSttQjF2?=
 =?utf-8?B?THdDUkpCdW5oeHJ0QU1ELzRMMWRna1hxK1JEQzdKWEoxWVp6RzYvOFBmZDJS?=
 =?utf-8?B?ckkxU0UrZXRzZEJzMnl2MGFZYU1WeXFrZzhDWlRPWnlRTk9yRVRicXZpZDVT?=
 =?utf-8?B?N2dRTGRFajJJU1MyMWtyYmJzblorTitCZllaWTZsZkY0MlRPQTRiVmR3UGtz?=
 =?utf-8?B?K1B5c0VvNWVZRTZXZWh4RDdxcktEVWNJbUM0YS9oY0RnbDd1Qlo3ZS8va25r?=
 =?utf-8?B?NmlVRGVWVlVMZWZ3bVB5MmRSRmxQblVXM3JnQUs3QUd5MHRESjU2MzlwTVRO?=
 =?utf-8?B?YlhWOVpRYnFpSjVJR1YxdTdCaU00dG0xei9yQmc3dGVWTUFlU0VCRHpZS0sv?=
 =?utf-8?B?aWlzeTVrSjdyV2w2dDRmRzJ1WGJVNllmNmVYRmtTUGc5U1M3MTFtY0tFZUM0?=
 =?utf-8?B?Q1c3ZDRJTm5DWW12Q2RjdkFXVUFwUFdqQjQrVTVrYlFBOGhJQUozVEpIOG1x?=
 =?utf-8?B?UFlSbE9zZFhlQWNodmtPU29WR29iTGJqVjdJZUFqM3gzTFVJbVY4MHlVWEFP?=
 =?utf-8?B?emxFc3Q2Mis3YkppamUreTFxWTVvZW1VeVgwQ1RJQkVJd3VMUTIxMXdoMEhP?=
 =?utf-8?B?ZC9OOXJzMkJFeDhTd2xSeUdBazhBSHR6dFh0ZDYwakVaMGlOeXpEMzB6cEhX?=
 =?utf-8?B?TEJ3cVNhdHluQWtHMDBHVGIzYVNacE4vU0E2dDBwaWRBenVDUEVCS1lDWFlN?=
 =?utf-8?B?dGt4MzcvdTJRcHJQVlo0OFJlQWNvc243NjhQc2N2MlI4RW10aU9HSTBUa1lv?=
 =?utf-8?B?SjlYV2ZSaVpnd2JUcDJXb0UvYkJLMUJnSUNKUDN6T0Q3SFpURExTSEdkWjVR?=
 =?utf-8?B?clYyU3BrcmFGcVZ2R0NWalQ0QURDWnZrSlZWQ3N3MVhUMHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVorTE1vZlJZODBPRzg3V1NyL1U1eUZiZHN5QUtwYUdKbFI1c0NkTm5kMEZl?=
 =?utf-8?B?dFVWQnBTVXRsTHkzQkx0ZDNBYXhpUXpYKzdtZTFSOHJpbFpIV0JBRCt3QVZ6?=
 =?utf-8?B?ak5Ec000a1JYQ2xuakZjQ1BCcGZXK3lrSjNTL1dYY2xmdlI0am0rbmdxUjZt?=
 =?utf-8?B?ZUx5TW1KbWNESFJPekJBZFo0UHlvaktDZTNjRHgzalJZQ2hyT2tRRnA5SmFB?=
 =?utf-8?B?MHNnaWJQb1hNNGJ0R2NtWW9ZcEtnNUprM1dDSUpYVFZHU0l3aU5pUXRoU2Q0?=
 =?utf-8?B?Snd2aDJvV2tQbmJyTlBwZ25XS3EzcmxZbG1NZVl2bFJuU3pOc1Ewa0dkd3A0?=
 =?utf-8?B?eXBFemp5U3VBWnFDcWFlVmE1eWYxUmt6RlZ1YWRsNFJpa1lPbVBCaDA2T0gx?=
 =?utf-8?B?a2xmczdSSU83NFJnWEF0Sm5tTXFmdDNVTVIxbGlIUUFlVm5HbU0zS2dDSEMw?=
 =?utf-8?B?dGtmbFpodlo5bGNEbE1PcjRQb1ZIL0ZOeGRzTEFqbVgxbms0NkF4cXJZd04r?=
 =?utf-8?B?TTJSTzNMVWo3bHBoN2RZbXg2N1lMNTBSYTlzTmM3Vlk5MnhjOU5wNUswQ2NQ?=
 =?utf-8?B?VWZQU1JpY0V4NkJYM0pLUTdxUy90QThYWDAxQVdudGh4aWM2cGw1R3VzVWR4?=
 =?utf-8?B?dDE5R1FlclJsNlpXNzdBL2Ixay9QbDNEcUhjeENwcDZTV0ZUbWlCYXBXbVZ2?=
 =?utf-8?B?SEhUMGVPSFhuWWxMZ3ZFQ2tka1BzdmtCdHJwS1JZVG5uZXNjMDZpR3lUMzE0?=
 =?utf-8?B?SnVQejhUaVhEMElxN2JqK054U0xnektQeHQyTkJFUzFsWEQwNklqZThHN3dz?=
 =?utf-8?B?U25PSXVPTGtaeWJEKzJEMFVGSkhteVNOTXZyclBhLzdtbWdZdHIxSEZmMWlk?=
 =?utf-8?B?YVhiRjFhRWJjbVlxSFdHY3FGaEtRZXpnT0lqV1ZkeTVvblk2cUhmZFlmZ3J4?=
 =?utf-8?B?ZjlneVdZVDdPb2pDTStIS0E3Qml5UlFUc0NYekFOTk1iUU5yV0tiWjFyZjZr?=
 =?utf-8?B?ci9CQ0V2aVl4YkRaOTZHWjVyNVk5bHNzQWtXWXdOaDlUV3dQbjY2dmw2Q0ww?=
 =?utf-8?B?VnFrN0pvc3grUVNUYkJ0RkNOREVMWXBGSzlJOFhMaG9jandBYzZpSW40U2F2?=
 =?utf-8?B?bG9lTm9XR3drVkdpT2FBQXBLVDA4Tm5MSmRzOHVGQnM4UVpSZVZ6OUFBTFVF?=
 =?utf-8?B?dGJrOWxvcy84dy9SeTZlRVVYSXlMVkU2dTJoUHBIREtkV2RPejdINkFBMnBv?=
 =?utf-8?B?TzI4OStvM2VwUmVOY1FENzZ6WmZLSmlJdWxuVkVNQmQzMTM0NkIrTWlRVjZx?=
 =?utf-8?B?MWQreWcvSDVva3F0NnplVHlKd25qdllFVStKQXlacVZLVE9wb0NTd2RMYjhY?=
 =?utf-8?B?bHlqTDJZS05ibm40QTlkbWFidTA5N0JUNDBtbFVkcmNhTWVRRllWcGJXbkhK?=
 =?utf-8?B?bURPakprS1M4NTBVOFYrR1ArS280WjVpMHdvZGFTZzAvOVIvRlg1amloZXB5?=
 =?utf-8?B?cUhMM1U3ZG00OGFQUUZIZWhnUnF0ZG1jTG5VUWlGMWNuNE5ZRjdFbi9kbi8v?=
 =?utf-8?B?NDF2MjcwYVRCSjZMcGRrZmhtN1dHdzlhWWdGRjVqa2pMYjdlWW11SGVLQ0ta?=
 =?utf-8?B?Rmw5ekxvRnllUHVnZEVHSHNZM1RzaXJQM0pwbzFWWWpBazdTRWlkRGVSS2g3?=
 =?utf-8?B?Vi95VHgvZDVTbENVRVNtdEZRejl6QlIxMmxCMUdaNEpGVU5yekRqdUh1di9J?=
 =?utf-8?B?VmJiV1FjZGppT2NHSGNVbTAxWTFSWWIwYTc4TVN4QUZpSWNQVVpxbVZjZkFZ?=
 =?utf-8?B?c0k3cnhFQnhPcncrUDRiZmVwbDJrOXk3YU8vTC9xUm9zcG5XcnRWRW8yQUxE?=
 =?utf-8?B?WEMxelRJYlFkMzlXVm82ZWlJWUY1c0s5cVhHTW8yU0U2QkdWd0x3TWlySTVO?=
 =?utf-8?B?SmdOU0RVQ0M0VlBORzRya29JZXdVQzZ4OXkzczN3UHZ2SEY5VWFoT2pJUUcz?=
 =?utf-8?B?SDR4K3hiZDhMZTBTWXdOSWVLNzY4b2pzd2lNZ1M3S0FlN0xZR016MEVpMGhM?=
 =?utf-8?B?ZFQ2aFhVZUs4N2dXaDlhNzB1aWg3NGRQVThNRURjM0wvL1g1d3VHbjFsT0NS?=
 =?utf-8?Q?9vDWVwHscyCbk6TA6DSzcZSqO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a1192c-2858-4fc8-44b2-08ddc299559f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 05:43:18.0243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nyft7ghQOzPgNDu5a6m6032kEQmX9ysdhxm9mQZkIBMoA6ZGnmO2nzWZABZbFDOmrdYgcC7kQTrzhskaJ+zOcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6779



On 7/14/2025 3:50 AM, Kai Huang wrote:
> Reject the KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created and
> update the documentation to reflect it.
> 
> The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
> frequency that all subsequently created vCPUs can use.  It is only
> intended to be called before any vCPU is created.  Allowing it to be
> called after that only results in confusion but nothing good.
> 
> Note this is an ABI change.  But currently in Qemu (the de facto
> userspace VMM) only TDX uses this VM ioctl, and it is only called once
> before creating any vCPU, therefore the risk of breaking userspace is
> pretty low.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

LTGM:

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  arch/x86/kvm/x86.c             | 9 ++++++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 43ed57e048a8..e343430ccb01 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2006,7 +2006,7 @@ frequency is KHz.
>  
>  If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
>  be used as a vm ioctl to set the initial tsc frequency of subsequently
> -created vCPUs.
> +created vCPUs. The vm ioctl must be called before any vCPU is created.
>  
>  4.56 KVM_GET_TSC_KHZ
>  --------------------
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2806f7104295..4051c0cacb92 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7199,9 +7199,12 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		if (user_tsc_khz == 0)
>  			user_tsc_khz = tsc_khz;
>  
> -		WRITE_ONCE(kvm->arch.default_tsc_khz, user_tsc_khz);
> -		r = 0;
> -
> +		mutex_lock(&kvm->lock);
> +		if (!kvm->created_vcpus) {
> +			WRITE_ONCE(kvm->arch.default_tsc_khz, user_tsc_khz);
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
>  		goto out;
>  	}
>  	case KVM_GET_TSC_KHZ: {


