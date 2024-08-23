Return-Path: <kvm+bounces-24942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EA5E95D62A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 21:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 157C8282164
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D8F1925B6;
	Fri, 23 Aug 2024 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KmPfzK6r"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A416C186615;
	Fri, 23 Aug 2024 19:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724442096; cv=fail; b=Rv3MAIN7zQzB4Qrkc08W0cB1YKc9nHnP3OzrCN7vuhaYVMcUKh96ls2eRqE1qqq3b7FiKzqSfXWN5c47o9V/4XoPiGeD3Q2/mr3YEp/sF5+/0Hduz4y9igFGCbFAMabHKrZGLs5oqYCQ8TfGBc9c8LACtbUF+HoqwCPuPmTyxrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724442096; c=relaxed/simple;
	bh=bqdGYk1hKotWiliSUnCKOXq7bB4Oca3aRo1oGS7QLnE=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=id5P7qBcuiZEdB1OXf2LQSUju7PYcN5WKhAx4qvFLIYT2+CwO6qn1q/VzEK0abK6dt0vnShz5XbI4E1jvx02GgkkF28yxTjlgG02zTq4GdHdTSMhOJoDTCTC/3tZp/GWxKBQ52qN4CD1TJ0KXDFVjJb4EGJkQXJiEMy5oXDStWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KmPfzK6r; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQYT4BSPeZrOKUatPF8UdUF8zzWQuo7BbkhjzZqKpPxma/NYd/eze1qc7Ps/UwzYey0jNMMc1AG7KEhAjBj6m4/ar25qEU6nr2uqrmoITKMQjS745Fy51ZZz4mpnKLa8XAjpeEYeUCLBhYjJn1SNPQIWzviiz5vBeFObsauBaXPMv9YuXzniGasuruqS3OYH4LOEmbE4gvkZoMIklA02ySB8mJgYM+Ds6Nl4rPZEgN5y9hpxHu06pkGi0nZ4cN3ekmggkeK6uq/CtIi5TO00Ky0ve4KXM0AhSYAjNl2LW35rQwYYQBpBlCab5CbhWO4gRv0Q3ZWx9GjFo8yQw/sWBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDaCQVMckZzCjLs9a0kH8wiwq6McgkpoYSlm+rQ1ewA=;
 b=kQ6hVJjXo9rIRczoklqAw+gVkMuU71yFoQ0U1uHracKzfcr9lRxOnp7KWYAj5WvXy0ALls0v6JqAdYML20v4e3u4vaDS4yOiDMZkm88zf/b4rpMKgzfCbuRSOh4YS5H764L9+xuhzoSrmOgNv+HtJ6kVRXw+BFhU5bi83zgtz17arOfYEg2lbzLhifTiT9WgFbSq1KJabCJ+vIoycK1wuwMEvPbmPJRWrrvfJGhiFJVsCKgv3xpHk3QzUKBhxDFt0PKpntu3V6TJQCaNLAD6i5KLMM5VaxO76tSUj1FGlvhluczOu6V2aCbz4tst2Cq9AnNqmfw0rJGwAeR2+2gmJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDaCQVMckZzCjLs9a0kH8wiwq6McgkpoYSlm+rQ1ewA=;
 b=KmPfzK6rPu/uFl5Lr0h2P0Q7BXND7p9lH6O/bQGa5JaZMhbBW11cThHcf/CxjmdBrKIkh+76hoR+Q0DCCOFi9LqxH1c83XNd2L9xHEg2n9GrXL0Rhgf2VtUEq61w9JV6Y2ffGqnhuNyQcaxXJfQ2vobN6cakbn0ZBBNPUBKyWzg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB4280.namprd12.prod.outlook.com (2603:10b6:610:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.18; Fri, 23 Aug
 2024 19:41:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 19:41:29 +0000
Message-ID: <bd389021-48d8-26d0-875e-d69cc1d77f1a@amd.com>
Date: Fri, 23 Aug 2024 14:41:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 0/4] Distinguish between variants of IBPB
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sandipan Das <sandipan.das@amd.com>,
 Kai Huang <kai.huang@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240823185323.2563194-1-jmattson@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240823185323.2563194-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0028.namprd21.prod.outlook.com
 (2603:10b6:805:106::38) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB4280:EE_
X-MS-Office365-Filtering-Correlation-Id: ea25a139-b11f-48cb-f0a9-08dcc3ab9568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWc0eFR1blFlbUZjYXN3T2V1WFc1UzNBSzB3dzhodXN5aXQ2MGQ1NUZHUEVX?=
 =?utf-8?B?cmR3OHRqa29uZnJMbUNSQkVYUU9Odks1U3hMYS9DZlptK0ZFWlNBU3dvTHZL?=
 =?utf-8?B?bWtLZFBqT2FrcVV6UTljKzk4ZkMxNlpYY3FHOTZ0SkUweUo0cy9DMk9DNHJ6?=
 =?utf-8?B?TGlPNTkxeEt6cUpwejFicmYwZGZvRm4vNnl3VnA1czFHRFFOTXlvMkQ4Ujl1?=
 =?utf-8?B?MzBMbFNUQmg4cWtkZDl0WGpnNlVOMDhMWjgzQ3VqZTI1T2R1aitvREFmMGMr?=
 =?utf-8?B?YzNIdkV5SGI5ZnVML2ZJK0FudDE2aEx3YkxMN0NON1g3eDRSYytTTW5yR2lq?=
 =?utf-8?B?VDRiNHM4cWQ1ME1oOGFjSUlyYmJSOUxaemxubEE3aTU5bExGc3h2cUVtV1hG?=
 =?utf-8?B?ZXhCM3NrbVp1NDFCN0FwL1pzQ2FhRFRxTEpuMENpeEQ5cDk5SzR2VGJud3hB?=
 =?utf-8?B?cUtoUnNKN1p3MGxWYXdxT0ZiM0cwaVZPQTdSQzdWcjZZdzJkblFSc0M2R3cv?=
 =?utf-8?B?dTNLTmdXR3RmaTdZdzgrcmR0VHEva1owZm9WVFE5ZFpqUHZyWTRCQU05Y05y?=
 =?utf-8?B?L21wd2ZXWlRWOXVWZmFFdW13TFhGY1lZNlVYQlptTGg2TEpkYjU3Q1Y3REs5?=
 =?utf-8?B?d2RFcDlpM01LeW1wZTdlNzZtS1A5ZGJYRGhiVnRiWi9QOWpsTlcvMm9yeCtX?=
 =?utf-8?B?aEhsL1RyMDR5OWF6b3JYMHZ0OGE5K2tRcUJRT1U1TTJmSjRWa3NUT2ZWNEl6?=
 =?utf-8?B?VXA5VWY0cit6Mm5EUEVOQTNBeU9OY0NsSzduZ2xWTjVMaFRWM082eHptM0ts?=
 =?utf-8?B?a2EzdGVHc0cxb3p6aG9DYlpKalkwTVNoajhDblRRdW5TRUVhckhhRnBTdlI3?=
 =?utf-8?B?MFBEVW5laFZDZzZURE1kVmtKcG4wVWZrOFJMK2lBUHd2eHRDSzh6Wm1hUlVa?=
 =?utf-8?B?SlBjOEZCMXFNLzI2QVBQaDlqbjkxbm5nTGxOYlIxT1FySTF3TExKbWc5OXFV?=
 =?utf-8?B?VUVqZWRpZU5HWmJsaHE1SFBnT1c4MjFRNklTcFJLSW03NFRwNmxSY3RUYmJY?=
 =?utf-8?B?dWR3QjQvcFJBK2IzbGNGeGJDR1M1Vi8xS3J1L3lKaUlzclRnWE1zbS9xNDlw?=
 =?utf-8?B?Z200QVBSaEZyZFV4eXZET1hwd0VWcHNVTVJpUVVkZk1IZHBPcjNpbC9pT2dj?=
 =?utf-8?B?bVpneWdoWHJKQ2dyK3RiejQvMm5hdWNoZWN5T2txMm5CMnVvV0VDRHJwL3p3?=
 =?utf-8?B?V3ZrYnpGTHlGNnBaeFY5WktYaGRKQmNNUm9yYXNJNk5LZXZZTnlKWmUxeTU0?=
 =?utf-8?B?RE1JQWl4QzJibzZScWJVbTZTeGJ4c3hOS3NremRreE9tNmliTHdDc0VnRDNp?=
 =?utf-8?B?N3BsYnZSZ2xtWlhNeWxVRnB4MDdRR043bVFlNDBabE1UclRmM01mSiszQXVH?=
 =?utf-8?B?blkwcWlTZGk3NkU4VHMwV3FnZ08ySHVBYXpGamh4WDVyOHUyNDgzZkk1bUNS?=
 =?utf-8?B?aTh4UENaMG9BdW1QRGhEeWU3MkgwSmkwWEdTREZVUDM3UXphempSNFE2U3Fl?=
 =?utf-8?B?M3JxTWk5VkNNWDlqaitkNVpITnRwNXBqU0JQL2lzRDlnaVdIWE9lZCsvWUxz?=
 =?utf-8?B?VVRveTVVQmdnMk9sTS80STZlZ0RGTEhPeHRyRGJRaVFMQU5sNGJmMVpndjZy?=
 =?utf-8?B?YjFQMjNzVmN6Q0l2ejUwTjZXY0F3d2IySmhvbHpBUHZ3cmtoL0RMNUpHdEVZ?=
 =?utf-8?B?TjV0bGJlRTlaTjRpcWw5REdtbFdQeDU4bEIrejA2cUttZ2pGSE01NnVWbXVk?=
 =?utf-8?B?VW1qaEVNVnVqRWlYM3RTWVVaYk41bTBlN0hRL0J0VTdtN3hGbUNJdndZbWh0?=
 =?utf-8?Q?d8pDU6+T0NAPl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmFlNDBqZ24rMkF2SklzUEx3K1BlYnF6d2J2K0JTVkhwbXpUcHl2MnZXREdB?=
 =?utf-8?B?TVpXNVJrWVBCTnNia0RoZjlzMTY3MG8rbHZteVRsa1RDWWg1M0t1RVo5OSs2?=
 =?utf-8?B?bWwrWVBPSjcwVWdqQnN4QUVLUVBGVlp6VlRhNksvdm5RZ01XeFluODh5OC9I?=
 =?utf-8?B?cXhBTjVveEVYbi9KL3B2ZXA4S2VjekorLzB3RDgwVXRRWjF0RHJFQXJMbUgr?=
 =?utf-8?B?TnFmaG5oSkl6NFQvZDkzRC90dEhJdHRhWndGWVJ6Wi9tVm9hamRuL0h4VFBa?=
 =?utf-8?B?UkkvZEtkbFMxQXJoQmtsaFlpRlJJd0ZldGhqYjVXV3hSTC9nV3RUVG1Oc0JN?=
 =?utf-8?B?YjhyKzB0Vlg5dHNGOG9PZm5md1RnK1ExUUtSQlR1UzU3QzVZeFlFTjVIK3JE?=
 =?utf-8?B?OGhvYW5zNTlTZTh0OFplWU4vWURDUGNSbnRjdTZJVmJHSWZBN1RraDYvaC9M?=
 =?utf-8?B?TTJEY2NTZDlsYS9EZGppZFJYeG1sTWF3M3lnTUFOYm5XcDdhZEtaMS8rT0tv?=
 =?utf-8?B?YStlc2JBRFhnNHF6U2R5ak01cHlDOGhXL1FzR01kMGZ0VHkyMEw4eEhCRFpv?=
 =?utf-8?B?V2FBOXUyUFdPODJxT3diUEJBdnRRbldySTBjZU8rTFBSRWdvTDFwYUhyN3NR?=
 =?utf-8?B?ekp5MkFyenYzUWNvK21EMkc2WnNZTlVHOGNOZTlOb3VwL241OW00OVdwOWhx?=
 =?utf-8?B?MS9BcU1OWVBXeDAyL09USmVLeG5oQTZqRW5XdXUrVFhEM05iellLT0t1TkVE?=
 =?utf-8?B?eE9NSkpTRGt4dkg2bDcreHc1WHZyUHdIdHZ6VkpvM0JXbkhIbWRrRFU1M0xv?=
 =?utf-8?B?UWU1TnVmeHp0MHo5YkF2OEtaYmtMaGxDZEJjQUNOMHg2bnhzR3hZRkRMRXpF?=
 =?utf-8?B?dEI2aWJkWTFqMlFDaFZ3RStvOGtnRGNYM2cxaDBFeFFtaEZuY1MrTGRUQjc4?=
 =?utf-8?B?VzFDVG1OaUtyYlJtWjZkeWhmWmdmM05KbVFOL0QrTDhITDN1aUg4OXFjOEQw?=
 =?utf-8?B?YzgvMkpjSkh5QTViWWUyNHZsdFZ3VHFlekE1VDRZU3FjNnR3dFB1K25pUlJl?=
 =?utf-8?B?OFdjdUlrR2hqNUxXQzlreEp0TEw0blJtVXFmcDMvc0Z1c01nNFFpY1N5MUU4?=
 =?utf-8?B?c0ZzQUx1eGtWenppNGhsKzByYlhsSjN4UWhoR1FuZWp5MzZpT20rWE41cklF?=
 =?utf-8?B?dEhqYWxSdXJFa216bGpVU1hlVHVCTE9BSjVWdnJaKzJCUVVWT1BEb0kwK0dk?=
 =?utf-8?B?NzdYZDdoTGdjc0dNejJjVUZ1MkloVm5jM0F3bjE5VkVmbWRSc3c3T1VnQUhW?=
 =?utf-8?B?SWczQ2N1QXB4KzdGYmdtR1BxOUVscmMzLzVuUlZxMGt0ekhhNzVyRzhIRGQv?=
 =?utf-8?B?R1NjWjA0VWduNkhibkl3bFlVQkNibG5kZUEyeVFIcVl5Qk5nWDIyUTdyZEdK?=
 =?utf-8?B?OXdvQWFjdVlMRXRCRGNlOTVocHcxQTVabWZsaU9nZlcyY1J5dlZBMk5KbFFm?=
 =?utf-8?B?bG9OWS8wT09pZGtjN1BlcDNUQ1lBZWI4eWw2YkQxVEgwT1JsY08wUWxnY1B5?=
 =?utf-8?B?VjVOM09LVFVCcnpZZmkveU9xbGNyc0M2ZmprYVpjU2VRVzZmZm1NQjhvQzgv?=
 =?utf-8?B?bzhRQjUyeVk5Y25SQnFMVEpYWEM0M3B5RUQvbVBVWktWR2xscnJPRzNXaW1F?=
 =?utf-8?B?b3RGTU9TZnVpNDE1dmREbjUzcURkNDJOc3JVdTJTaHA2NDZjeDcrQXFOZ1NE?=
 =?utf-8?B?WmFnZzN6cmIxWm00NFcyMUoxdHpwT1R1dXJtaW9KekswUzEwVkViMUFRRk1K?=
 =?utf-8?B?a0RhNitpZjllbmFZNkpVdVMvMkRpR3g4YVdMVE9ZaUVid0d2bmpjYzJKd2NB?=
 =?utf-8?B?V3cxZlB2dG5zUVNXcVMwMkVnaVc0SlQxcExmbGxUWHFKMmlaMFMxSlJDM2F0?=
 =?utf-8?B?NldIMG12cnEyRFVaUkFBcXZuTldjc01NOTVDbW1SQjBCb1lkRHNPcGNEQU9Q?=
 =?utf-8?B?eGlaVElDS1JCT0Fnc29pbWtJcENWUG5iSDRNamxkMFdGSXczYVdMb2RmVGxx?=
 =?utf-8?B?dzA2SU9ETHJTZThIYVlDUEVRampLdjBvSUlDWEtlL1hqRjNTZ0EzS3VFWUlU?=
 =?utf-8?Q?3Q4AW8rJolUH6vPrta2JfbJPm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea25a139-b11f-48cb-f0a9-08dcc3ab9568
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 19:41:29.4150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEU1PGUFjEjAjRmR3ftqYfIDpo8J+NUNTtXLolLneoCiNX72NX6vPF+K//Imo4LZCufw3MvtHa4lxXcgq4OWWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4280

On 8/23/24 13:53, Jim Mattson wrote:
> Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
> terminology, the RSB). Hence, the older version of AMD's IBPB was not
> equivalent to Intel's IBPB. However, KVM has been treating them as
> equivalent, synthesizing Intel's CPUID.(EAX=7,ECX=0):EDX[bit 26] on any
> platform that supports the synthetic features X86_FEATURE_IBPB and
> X86_FEATURE_IBRS.
> 
> Equivalence also requires a previously ignored feature on the AMD side,
> CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.
> 
> v3: Pass through IBPB_RET from hardware to userspace. [Tom]
>     Derive AMD_IBPB from X86_FEATURE_SPEC_CTRL rather than
>     X86_FEATURE_IBPB. [Tom]
>     Clarify semantics of X86_FEATURE_IBPB.
> 
> v2: Use IBPB_RET to identify semantic equality. [Venkatesh]
> 
> Jim Mattson (4):
>   x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
>   x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
>   KVM: x86: Advertise AMD_IBPB_RET to userspace
>   KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
> 
>  arch/x86/include/asm/cpufeatures.h | 3 ++-
>  arch/x86/kvm/cpuid.c               | 8 ++++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)

For the series:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 

