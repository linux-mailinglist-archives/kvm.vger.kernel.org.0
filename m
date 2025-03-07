Return-Path: <kvm+bounces-40432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A5AA57355
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66779188D754
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2439E25743D;
	Fri,  7 Mar 2025 21:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y6JZmJRB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF049192B7F;
	Fri,  7 Mar 2025 21:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741381582; cv=fail; b=AWbpXr9rZh8HrhEkzTq/ocgnoRusklhvEE0IviaZFr0XYhvptFZxdSaAl4F7T4ScdKco5J5bj8QE9AFKNyQxrM4z0EZRL+rE1M78wYeBGfJ3ruUUQYPRTmVrHxxy0GcObGWy26x4VIs9N8qeEOLpMIahzy/fG8h94U4pnUQqoE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741381582; c=relaxed/simple;
	bh=GVu1LXVOtm0Rb0bNHh45DegKRYQeSAQ7zqHqWhqWruo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TKgLLTtHoxa6GatePh2oqx7P5MjRuP8LYkIyJNFptVFWXiWkk/dNOOxSk+XdHdk9xw6++ywZPB9Uw7kYmp8SEglcftu1oCMI+GgvKDC4NzovQCk8H39h6E/Fh60qVrKIsFfY7koBcvah6lRpDx0GE1Z24GmHel+oho22Y31t39Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y6JZmJRB; arc=fail smtp.client-ip=40.107.236.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELhN2PmEnyRZ5Hh4xJRjCsmikYHvNS44jUTj3EXxqyn4Vbs2K87ksBEWhZwDcTROKTdGoEktIl1BN2+hGiVmBXER71zx2YJVO2Ndj61bshmPIlJvi8MVkjylrU62mlSN+IfDOmKlEfaS5eIi7Et1jtVUzdbX+KS+iWZVxMBdCVHFhDNVMRy6PIfqV7+nUYzg/+w3iVLffhKCrSNrjVJnKdd/ZXLS6J3O+M4jQMCqu/xmrwqux/b+ZLq4uoQMQQ00UpJC6gwhjHajHvL/pyim6kneDEXtnIwc81wNeFXC942Bzv7FlIYWjEBNt0wOVgFX21iBtrPtXrJSUF4cKOioPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zA8YGB78Jwqsy2Hzc6kUPxEb9kQXcvbKFvqfsZWSEgQ=;
 b=F/ywiNps8ebiOYQdhhQzfrNnLq43us5WCulFpUJB3+lT78gh2Iujf27xBL1o/FgviHq/onpueSoBYYBWh+8e7ZVCfAm1OYjdHwjGooYovNfMPlnd5A9GCrJbR18uXxCyUAXHemMTb/V3RrA85kcXXIYXBHPilNVQQCbS29I1NVyhEH317FgWw6imUb26M/ZBVHb2VUl7Chb5iDxqS2NpjeSuF5TZ+vhGARmFwBQazYEiFco0PjDW62YUMOKNd7aLTcIO6dpVK7RLwQx5eja3kFx6IdBBiyGHCG/a0Mhyxpc6s9QFAUrgoE9tTkRkOZLHw3Kre1AOWBifVSiBm5nRBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zA8YGB78Jwqsy2Hzc6kUPxEb9kQXcvbKFvqfsZWSEgQ=;
 b=y6JZmJRBacPi3lryPn/N0Qu68rw78LQwxlPE+f5ViqIyN1i3iVrl8dEcOPatHZWDzSfo/pEZIwTAPstzHSnB+c/U/P50pfU/m13WecjjdU1sE1RMDhqzh8VZMhHeOwZcbl9KBekr3ruICSdWwDLCYUqmcP2ZImpnyRBPiAYBQsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA3PR12MB7976.namprd12.prod.outlook.com (2603:10b6:806:312::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 21:06:13 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 21:06:12 +0000
Message-ID: <151f5519-c827-4c55-b0e0-9fb3101f35d4@amd.com>
Date: Fri, 7 Mar 2025 15:06:07 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT
 fails
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
 <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
 <fefc1f1f-fc06-a69b-3820-0180a1e597ce@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <fefc1f1f-fc06-a69b-3820-0180a1e597ce@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P221CA0015.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA3PR12MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: 221c6547-bdc4-4681-a831-08dd5dbbe3f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHdPeGE3UDNsd2hVOXIvRzlJcnBmdXdWaU8wWXVCcjNvMzdLeGF6UDFLT25L?=
 =?utf-8?B?TDRxcW8vTUVHRDBxaWw5MHZVZGZQMkdKWDV3YkhNZUE0WU5BMzZwc2FzM0E5?=
 =?utf-8?B?dHpxZmF6WUVIYmt3QUZESW00YzJ2SU8vV2lUQjY2SGdmTjExTjZSRmxPQnY3?=
 =?utf-8?B?MDFiWVgvMGdIckN4aG1zakpDa29ONlBNamhmNXI0WFgvZzJwdnpEQkhIdFRQ?=
 =?utf-8?B?Q3NQNWw5dmZsbHREa0pVa3BmMEl5S3pBSmtRTWs1cnZSQlRwMHN1U0RTQWtu?=
 =?utf-8?B?MGJ3QmoyeXVGREcvN2RiWEI1S29MWk40SmQ5WWtNMGV6WWFoNTRHaVp6eUVu?=
 =?utf-8?B?QjFtVDlyd0toeXUzSUl4UWczeWJHSDU3S2ovYVZRRlZKaHNYakpuN2NaWXJX?=
 =?utf-8?B?aDZwQUcrSThZY2FTbzNDcE93SkZXNG1wT1lmY0x2ck1sNGozNm0xMWhvRnlL?=
 =?utf-8?B?QjVuYU1DTFN6c1dITlV0cFhQOFBrSm12OUQ4ekZKMFdFUStwWkgxOEFHQmI2?=
 =?utf-8?B?eVRjam9tcXlSYThSWTJnRDBOY3ZmYnMvcGt1U2JYQllQVk9WbGtVdlpYUGlI?=
 =?utf-8?B?N1JuVm1Cb3lxTXp5UmVCMngvSGVSUkZOSVVGN2JZdUF4QjEvYXNqQmtvVG5W?=
 =?utf-8?B?Y3Y0YXFzaTdRdVo1YWliMS90ZDA0ZWlUYnBlWDJLWlBJNE9lZFIzdHN2QUFQ?=
 =?utf-8?B?Z2cwSXd5aFA1TkJwbnpDa0tSaE1YRVlPN3lJMDJmTklzME4veHpqOTdneXNW?=
 =?utf-8?B?WDJiQW1HaGFIYWR2aDRVZ00xYWlOVnBzOVlDZDh4OENnbmI2bnpKa2t1NkNi?=
 =?utf-8?B?UWFkMytCcmIvSkVSQjFUVERjZG1MSnRnUVErb0VHMEpxSU5pdmxOeDYxbWla?=
 =?utf-8?B?aURSK3V1VVdLMHRjeGFoanc0THp5dnNydmdLRTU2eE4yZ0xvQ3hieTRjVVRz?=
 =?utf-8?B?bk42cnBQSHFNZ3hKeWJ3ZTBwNG9XV2E4emQ2cldjTkRwOVRCeTlUQUFCeWRu?=
 =?utf-8?B?UW5FV1h2WTd5cnhkQ0V2MFBQZnBNMk5HR1RvT3FWYVh3UG00RW1NTVNIV2Nm?=
 =?utf-8?B?SVdRalZ4K2tlcWFjZUxtSllESU1tTTZlNDhhZG1Ub1JSVEpsVTJIY0l1Rlpa?=
 =?utf-8?B?TkpuQ3JiL2hQUnRzdWxjd3dEQmRtUDEzZStxaXJGaEJiT1BDTnQ4VllWb2hn?=
 =?utf-8?B?ZTJ2QjROYk5qb1FpclBjL2Yzc1F0WUxrTTM0Y1VUV2ZSdm5oYXBXYnY3MTBs?=
 =?utf-8?B?VG1mR1d6Nlg5U204OSt3TTU4Z0lQb2FORnNmcVBmL3VmcFloY2t1UDZSdDVp?=
 =?utf-8?B?VWgvQnozZnpMMmc1azV6YnNGaE5jT0RPT09tUS9SNkZIRHFXUksyYUx5aDlE?=
 =?utf-8?B?OVlEQjI4T0x5N0NvQ0hMSXFvcmZkWERPSDA3R05kcXBpVGpGU29ieW1wNUpC?=
 =?utf-8?B?VVY2SkIycmtQVjBzRFBZcmRXdS81UVlROGptcVExSmh3dDgwR0hNNkF6UG5C?=
 =?utf-8?B?ejZjUkhRUjVvenFSNWxqaVVLZCs2Y2xwVFNSMlRzT0l1U3BWZllEWHA3NzVy?=
 =?utf-8?B?WUtNQmZ6L3UvT0ZSbm84cGdQT3dURzBqazl0akRLSWdhT29tcXVNcUNURUdD?=
 =?utf-8?B?dDRWRDJML2tuZ0hCd0R3Q0lVeVhUSTNWZm5RNWwxOStkTDZIeGd6K3F6N0Z0?=
 =?utf-8?B?OUJ5Uk1PaVlrT3krWXJxeGJYS1dOY0U1bG1KaG1YclZuenU5Uk02V0crSm5R?=
 =?utf-8?B?ZTlGb2tYS3dlNzM4NkNnMXlmdWRPL3g3eWl6SkxmU2UyeS9CQW5NWkJ6d3pL?=
 =?utf-8?B?NzU2T0hyYUdKUXF4RERMazlTVW4wNkdXbzM2SEpLQmxVY05oVDFvYUtKN3hN?=
 =?utf-8?B?VXFOSFZBVnFVUzBkT0hiSFdURHAyUlN0TkNNTStkR1ZKZkNvelNnWVJTY05z?=
 =?utf-8?Q?VWW/b6Xa274=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkhuZ0FDZUlGbXBUaUloemRQN2Rnek14dS9ySVg5U0dnRW5aL3NEL0xoc0tj?=
 =?utf-8?B?Ti8wSlNiMTB4c29jem5maHY3a1IwZWJFTnR3YzJQYWIzVTR3M2NpRDJBNFoy?=
 =?utf-8?B?SHNGMlJPV2krV2s1WDFJQjkyNFVWazkvYjNQaEpqWVpzcm5zNDh6aGdxRlps?=
 =?utf-8?B?OS9mSnBPYWRoaTJCWWgwSW5PTkU3YVQxT2U0ZXZVcTc4TWJGQjFsREFjTGNR?=
 =?utf-8?B?TjIvZzYvS2o5U2JkeXZDUlF4YlVoVGxnU08rdVBqeVdwcVZYUnZrNGdWQUlX?=
 =?utf-8?B?ZDhuSkZFMnR5WVRBZWZvQTBoMDRjUk9rOEt4VjhqL25EaUpkdG9zOXl3TlZz?=
 =?utf-8?B?cUpDRjJITm5tdi93NkdEeUxldVZDYVNXSVNCVCtTN0FLd3FjWU1QemsxZ2tC?=
 =?utf-8?B?RmtxcStJLzVhV0E0OVplZTFaWnVRbCtLY2N6alErSFpQM1ZKWlBXZy9nTzdx?=
 =?utf-8?B?d3dBNDl1VktFM2k4aFN5UFg2RWlZMEtCcktRbGJqWUp3d3IybzVqNWpZODNQ?=
 =?utf-8?B?aEhnRUp6WHBlZUU2Z2ppdFV6dS9kSWNEVEsveWJFY0xwd1BkRkcveGhBNFAx?=
 =?utf-8?B?eXlLdkV1NkZJdXU0SHdIMUZYKzdQU0JCalZwblp4R2hVdzZwTVRZd0RocGhs?=
 =?utf-8?B?SnJycWNQZnJVdTBBWWEzbnIwN3ZsVVRwME5pc2xYTWZ0RVhjUllpWGZZZS9F?=
 =?utf-8?B?MFRFSEkweXBTd0x2cUN3WEI5TnJCRlRhMmw2U21Nc2MvTFAyRTlHQ0N1NmYw?=
 =?utf-8?B?LzMzYzF1Q3JkbjBheVN6ekt1dDd4SVJ6SERkN0lldFFKZmpJU0R1am5ZYUpy?=
 =?utf-8?B?ZmdkSVptamtNaTdrYzNTb3FZWmgxWFZReVNUQzVKNzRMTVVyaGEvNEtBYWg1?=
 =?utf-8?B?YWY0djlYcVRPSFlJWG1vd0tVejQwSEZKZDdLbDVVNktiaExDbm05U24xK3Rk?=
 =?utf-8?B?UVA3eHBkcTZOVW1yNnJQQ3NOSkhDSXErL3ZQVC9RZ0dtVGtLS2dTT0MxNjJ3?=
 =?utf-8?B?MmNNcnFwRFYzZisyUkd3cFFCTTlLckpRdnREdVl0UG5MN1R5eU9GeTFsU2Qx?=
 =?utf-8?B?NTQvSnhsY3U5TlRadlJYallFSWVjVFhHUGdIMFZMT2tiWllrbTU3YkxHZng4?=
 =?utf-8?B?aGMzd2s3WURqZmxiSGFMaUpmaU03OXdickdxWkt0ZmdYbW9kb05GUUduWTlk?=
 =?utf-8?B?a0l4NlJtSVlEeGtDRDY2L2VjTTY5VU9PRHRmL3hPeUEwUVhMbzIwZC9zemZP?=
 =?utf-8?B?VHlwSjJxREhKbTFqTlBTMkVCMnBqa2ZESEI0VkJPSlJFcUlmOGxXT09pOTJj?=
 =?utf-8?B?QXhPT2ZSbkRwekxZZzMveHROQzV1Uy9BOGNXNmxSUnVFRm9SamRHUDVUbldW?=
 =?utf-8?B?YytCQTd2a2tOdW43T2xiZUR1bEJ5TDk0dEFWVGozVmpwMmZTU0NFT0JqYVNR?=
 =?utf-8?B?RnlYdGdESEFSdVh6TlBDcHdJamJIYk5pTW5aVDUwTE02RmZOK0hzVUZ0alNa?=
 =?utf-8?B?SS8vbkxmWExmb1M1bWJpK1Y4a1ZITmRqdTQwbFdWeG54M2hNbUZlSkwybHB4?=
 =?utf-8?B?dEF6VUgzRkV3Skg2RnZkQUtCYzhNRjhKUXNuZVBVNXVPV2hRNFJBNW43QnF3?=
 =?utf-8?B?NlJUN09YcDdmY0gwZm42Nk1MMWxqRVQ3am1JbGpieENUTGFSZzRsRUNiVEkr?=
 =?utf-8?B?Zkd4TXhMVGlTS09FM0JqNndkdzdFT05qcTFXbmJrN0x5WHdWNUxlbjg2RjEx?=
 =?utf-8?B?K2VJRVpXbVRiQzNRdWI2bEovQ1RJM0FPWmJvdXRUVW1QeVducFlSU3U4R0I4?=
 =?utf-8?B?dCtSQVNGUXJtK0h4ZXlBbmlQM1VMaHFXa2hKQXZ4Z3RvcHExd1ZLYkJ0RXpS?=
 =?utf-8?B?Yjg1NDFSajBxRzZmY2M1Y090OWI5aHB4Y2ZrSWhIOHByZERLUXFsTjNQa1Rn?=
 =?utf-8?B?ZGZwTkJYNU1hMXI1a3FVRk5PTjhRRU9vQm5IMnY3dFNiT2V1RkJrWU5oSDhz?=
 =?utf-8?B?ejZvYkY3WkRhaXFXMkpXQURQemlDYjJGWUx1RGJBV3A5WEkyaXgvbDk5T2NI?=
 =?utf-8?B?dWx5NzN0K0RZc2JQTzd6RG5zQUFTUVNsUERaUzhxU2ptMjZhZCtqSmN6MTY1?=
 =?utf-8?Q?9JheMvnVFAg8AjVsgsAr1utEj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221c6547-bdc4-4681-a831-08dd5dbbe3f2
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:06:12.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGdrW/aRBNkeD89iUrxbjU+aNSwX1YW7S5fnMpHL4f+q0xQxFr4D6O2fHFIAI7BKf+IWZGFF3657YaFqNl1GhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7976



On 3/7/2025 2:57 PM, Tom Lendacky wrote:
> On 3/7/25 14:54, Tom Lendacky wrote:
>> On 3/6/25 17:09, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be
>>
>> s/RMP/the RMP/
>>
>>> initialized up before calling SEV INIT.
>>
>> s/up//
>>
>>>
>>> In other words, if SNP_INIT(_EX) is not issued or fails then
>>> SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.
>>
>> s/once/if/
>>
>>>
>>> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 2e87ca0e292a..a0e3de94704e 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>>>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>>>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>>>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>>> -		return 0;
>>> +		return -EOPNOTSUPP;
>>>  	}
>>>  
>>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>>> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>  	 */
>>>  	rc = __sev_snp_init_locked(&args->error);
>>>  	if (rc && rc != -ENODEV) {
>>
>> Can we get ride of this extra -ENODEV check? It can only be returned
>> because of the same check that is made earlier in this function so it
>> doesn't really serve any purpose from what I can tell.
>>
>> Just make this "if (rc) {"
> 
> My bad... -ENODEV is returned if cc_platform_has(CC_ATTR_HOST_SEV_SNP) is
> false, never mind.

Yes, that's what i was going to reply with ... we want to continue with
SEV INIT if SNP host support is not enabled.

Thanks,
Ashish

> 
> Thanks,
> Tom
> 
>>
>> Thanks,
>> Tom
>>
>>> -		/*
>>> -		 * Don't abort the probe if SNP INIT failed,
>>> -		 * continue to initialize the legacy SEV firmware.
>>> -		 */
>>>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>>  			rc, args->error);
>>> +		return rc;
>>>  	}
>>>  
>>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */


