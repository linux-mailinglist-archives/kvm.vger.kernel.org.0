Return-Path: <kvm+bounces-34455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4249C9FF377
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 09:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70CCC7A12C7
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA46038FB0;
	Wed,  1 Jan 2025 08:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="unurWnml"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ACC26289;
	Wed,  1 Jan 2025 08:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735721095; cv=fail; b=rBr8cXTz9nfNvAnhFMNwLURBRrSgvmvyEC/Ms49qqRfnI5HXNYCVyAFADu/Bk/+1h5KUR5N3LiyUzYeN9P0lXVKrqwuBovgio+RVVH/JF3mAt2O7BrYVQT2BCgksoxfKsSPr3FQH4dhY0/YtqNwdRvLoLwQwL7gs3/sM0d4pnQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735721095; c=relaxed/simple;
	bh=di0yxzJ+K9JXLHHUFTYe4uRUyMzqw1RRZq/5bl3+qLQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AEUCqsvO3cG3tJdje232ldf2S6f8krhVI1dwhxZ6EceJ3Aw6OHvK+OUps8k49TmPJhxlo+ixBXjRmsjE60BFRJPy3GQbOvMU3z7w3O1ny1BQ64H5eLmJQv+t/74sZlkyUCXBtSVE2MUD49wqwKlIfwCsJho1JvBDIK2R3pKHyJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=unurWnml; arc=fail smtp.client-ip=40.107.220.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EK7od+2/XF2jRoouPieT1Cu2F8PtAFhzlYvX0FZ8F8X/VFcxYaTi7ZRVUsTA7Pn7b7C71xUkKuTuoRLv67U8R4ld3XF2pARtMIYCWayUN+glHLsN5wy0cz3c+0+lpogp2QEwmC9ur4k1VMxxpYn3ct/+CuNrM5nDDfyvYuUKHV3w7C9R2CntnKFdB617FWRzMD6EM9pbU9wa9qlO01pY2iSnfzsiCN5aNndTtBvigBJEt1A+kdtTy1DlRMc6MlZ2rFks8/6HVRM9Cdq5XOq2BESY8KOFWQjWco3eSnU5Ty3G6JCbpjjmi956ed9yw4OHxefCqY1LZcSgXfpUdb7E6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9kEuE2QPO1FGuFlmbwMRiWiJbcWYVenc1Q72Cmd+3Q=;
 b=L+8hCbr7+j6w04JmoL2obHgohvsbjUtPPJ9Mi/92TsHEYzd33c4l7Nrk+inJBaSMqHR21hNpM6FJzMftE00tobVhz8QfQPa1f6cbMVI6o/+3YLXYoxl+ifkgo/4EG5xt9koUFGxEG80GTuWM/uxY9Fr/TZlORCXAqgfA2gbGRqn6Ubjgb3cVNk9O3zL31dbS1Y999TZyl+XImfSvTETC/UUHdcWleLRYgcyMsNd/fl979gjDtT7AUiZx5/9Pr+VD8+8RqwpNWuLvL+GLHhlb/SfgOflOtMvonTMIf77KRFLgEp4w0s7VIZkLZV9BM1WM3H0acNSaW4tXfVnP7YCCLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9kEuE2QPO1FGuFlmbwMRiWiJbcWYVenc1Q72Cmd+3Q=;
 b=unurWnmlgyoamMdwGc8w4XS/2Ytba0G7+V50oBcrk1sFx1fQkTPofMvCCmFPnnXlN7o0aKYz2ymg9oS3C/JliVV6w6VLFj20MbrWFIU3A6+thA1mun65DkePX6NhScl4/WmrLfTxxNQhuGQYAZLjwWPJ16+bR4RadXN01szqiw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB8595.namprd12.prod.outlook.com (2603:10b6:510:1b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.18; Wed, 1 Jan 2025 08:44:48 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8293.000; Wed, 1 Jan 2025
 08:44:47 +0000
Message-ID: <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
Date: Wed, 1 Jan 2025 14:14:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN1PEPF000067F4.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::35) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB8595:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e22996-03dc-4989-d727-08dd2a408c23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWxxQkI5c015R1BYMEswR1o0ME5POGVLVTMwRHNmZURERFdMM1ZTTVQyWStp?=
 =?utf-8?B?RVlzVXIvNUUwR0JaSnQvb1BOTnJKMzc4M3hIR2o2V1dTcE9XN3FqaUt5SFFp?=
 =?utf-8?B?VkI2TnB1YU1DcUZFUlJjQklVZFdBZVYvRHFSNzk4NVR4UU1LNURIZmwxczdM?=
 =?utf-8?B?Z0tqRjhFRjRvR0kya2FBVVFjSE1UVlFRWmpLZWw2ZXp2RGU4MzFPU2R3aTJy?=
 =?utf-8?B?VUh2ajZsUEMwc1ZIMkpaeVZkNUd2QmMzTUw4ZXYyVDdSWkZPZVpmVHJlUFEw?=
 =?utf-8?B?SURpRm5pUzk2M3FTTUtFcXFXOGcxQVpHWjIxK1hES0hBcmZ0K2xGdXM2c3JB?=
 =?utf-8?B?MU5rbVgzNlh2UGZDWVNGWWlLaDRPSk9GcGNsZ2I2MXhxWkIxdlZLY2pzU0xO?=
 =?utf-8?B?SUF1SzZNKzluLzVoeUtvZkhBV28yYlk5UVM1d0ZKL296c3dyVC9KQnkyZzNr?=
 =?utf-8?B?YzFFUStNYkRCczAxMGtjWVVIb1NHUnVoUTV5YWh4ZXZyVTJCNDdaS2dTTW1T?=
 =?utf-8?B?MzBPdGVGVXRuRnJYMlhMdVlEQm5lQTAvbHNHTUo4MmdlNDdWcnRPdkdpT1dB?=
 =?utf-8?B?YnFiQ0JYa0NLMTFEVjJqNHdicDd4Z2RJTWdIUkhoK1Y4UEp5SUVUdlFJalgy?=
 =?utf-8?B?V3I1dzJzWlpLQnJVQ2Rla2V3KzNlTm5VazU3VmVRMklVb3ZXdjlmTllzZHNI?=
 =?utf-8?B?bWJaY2NKTW9XVXFyQzh5a1BmNFRuRFhMQzErc1pQTkM0Ri9iRjVaL1F3YTJ5?=
 =?utf-8?B?YVFWRGZZUG51NkRFV1o1ejBkVFBkK2dsOThQQ3dDTDI1WjR2QVQ2bjNxeGt0?=
 =?utf-8?B?QTM5Z3MzSHRXQmJnR3p4d25Mam83eFlVbC96SnJJZU40RllUNDMxN0NycWVU?=
 =?utf-8?B?d0NFcHU3TVdYYThqL2NNOXJGR25YUXZPTzhlMnRPSzZsZ2Y5Vk1heDE1UUVE?=
 =?utf-8?B?a2hpZXVBQnFlUElmc2UrRmFDcXFxeCtsN1FTUFM2U0xMMlVISXNrd0RuSm1o?=
 =?utf-8?B?Zmw1Q3pFTUtVaHFlZTZjZitOSTYrTkJYZ0E3QVI4Mkh3eGJkc1dQeFptSG5q?=
 =?utf-8?B?cWZRcXU5UHdvSGZrdjJMYmNLOGE5SWhtNHRuNW9aS3hDRGdXL2dycDZWRG1K?=
 =?utf-8?B?OFYzRFJoTE9uaFB2ZE82UWxRMXFqL1ZSMEg4THYyejBSTWVuR2xqQUFZQ3VE?=
 =?utf-8?B?NnQySmtxVDd6TUwvZHNlRFdTUldTQXB2OFhreUYrTEhDd3B4cjdDcWxENGFu?=
 =?utf-8?B?NVNUNlpYU3ZtS1VpbDViZGNzY2hRbEJEeTJmL1BqaUg5ZEpiQ0tBUVpOb2Q2?=
 =?utf-8?B?dk12cW1pdkEweGxQUDN3Uk9TZUFkcm5hc0daaXpuOWxCT2h2YXZxblk4bFJl?=
 =?utf-8?B?ZUl6YVFsYjRFbWRUVlc3NmpZK1VBUU10RTFVQlRYbUk5QUZkRHBOR21iS3FD?=
 =?utf-8?B?OWRwd1oreGdXSzJqaWdEWUxTTTZ3dkRNRlcxZXJienZxM29pNkVYaWVaSjlE?=
 =?utf-8?B?U1JjSjdNbWJOWUhUVWZHVUs3b1l1dzVDL3k3c3ZqcjFwaFpEVVhhd0hCdWk3?=
 =?utf-8?B?K2VkekVuYUVHQUJIMWhqbWozYzQ2Wjh3UDc2T0JhZHhQVFRMa2I1MlVGQjlL?=
 =?utf-8?B?dFBjMGVkT3FSUEU3bk0ra1R1TjYrb2xOWW9PUWxVbW9MNFZjRWVTWUdtYWhp?=
 =?utf-8?B?UVBnZyttNWU3dVRha0EzU1VycUZ2Nzg3ZklEWGdSNGRMRnZkMjRRZE9JVVZr?=
 =?utf-8?B?SkNvNDhDQnE3ZENWdk9qb1l3bkZFeWt1T3VabnlUeC9oUkFDZEVxRmNNVXB1?=
 =?utf-8?B?aGRiYWpCNXdTa2t1R1JsdEJtR0g5TmNZb0dwNm9JR05udDdkd0pkYXZTZm5O?=
 =?utf-8?Q?5y1I/H2yJeSuf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3N4NXFsYzRQOWdsOFZnV3hscGR2S1VUT2poSUczYzFTYUh3Z1dyVjZjM1JL?=
 =?utf-8?B?M1QyYThPb2ZDVnl2ZHVBcTgvSHJuUnFITHBIQlluNUxUSUg2V1R1Y3RFck04?=
 =?utf-8?B?MlEzV0lDQ1pCYmJBVXhpcVNMUEk2MUx3Yk00YlNneFZReXNWSC9aSGtnNjZa?=
 =?utf-8?B?U0piVGo4c3BRRStrNjBtY0c5bnJ0b0dxc29iY0R2b3h0NVJ2VzVFZmUwN1JR?=
 =?utf-8?B?eW1rMnJ2T1pXM0FOaUpYQ0dzNFJqTm1xWGRQWXlGMlhSekhiL3l3dkNqeXdv?=
 =?utf-8?B?VEx3cCtTT1EybjU3Tmtic013YTcyNGZIeld6TjJBTHdXbWZ6bXBzeWplNnhs?=
 =?utf-8?B?N0FPajc3VDJmRERrenVBWk5yd2ZpaVVraitXR25yWjVFamU4dlFHc0QxWkt3?=
 =?utf-8?B?d1hRbVFzSmlIM3VYaW9nR2lJdnY0MFVlWkpnWG9pNk9jdjg3YmdXVmFNR0I3?=
 =?utf-8?B?cWl0MkNzRUZRdFh0RUJmMUpaWjdlWWlzQWp2MnBsczFFdTVuQ2Y3UE5RT2cz?=
 =?utf-8?B?bjlHWlA5dXMwNS92NWhjLzdZWCthaStMRk02L09SeTcybVRMNFBCMzc5NHFw?=
 =?utf-8?B?MkZkdDl0YmpxdzJTYitnQWRGbGJ0U1V6RnRCRnZDbWJpQklSYWFoYkdMOWpF?=
 =?utf-8?B?dFkwSVl4aUZmU2JSQndva3IyWk1RN2dBa1ErM1VNK0tnc3BNZ0hVRlB3b1B0?=
 =?utf-8?B?K1MwbnJjQUdhQ1k0L2VMaUJpQjlaMXJlKzllcENrbGZXWFRWYmpWTG82eEhv?=
 =?utf-8?B?M1ZPOERzZlI4eHRCNWFWRWVZeGY5aURDbUd3eEpsOXFMa28rSXBFUzM0RVV3?=
 =?utf-8?B?QXlIUWxSNTdLSStVWk9iZnlwNzBQK0pHaTRyaHIxdUx3SWF5YUcxQWVMNVVL?=
 =?utf-8?B?VE1SMHZndmRISlNTeDdXS3dWYitkY1Z3L0FZeHV3Tm1uY01vWDU2aThXSGQv?=
 =?utf-8?B?SjYrMUVpTVVBMGwrY0VSVmV4aEoyRnpESmdOZ2JkbUc5QVVydXg4c2hWc0lT?=
 =?utf-8?B?aDVURXF0Z1FGTkUzdWxjZitlZ2tCR2xrbit0dnEyYjRGWW1JbXpLVFJ6Rjdt?=
 =?utf-8?B?Q0wzQjNucmJqS2wrNituRnk0WFZiMTZzYmEyRFlOL2RZc1g1VFptZWlPMjV2?=
 =?utf-8?B?ZEx1VEN3WWY4NXhMKzcrZzczNVJWSG0xS0xya3ZtU2I4akdWSWtsdTBrRWlH?=
 =?utf-8?B?RmIvdWVscFUwMnhRUnZQYm4zTWYxWDFQZWRCVjNUMmo4NHlZVXh3Tjc3ejJF?=
 =?utf-8?B?cDVRa25vRUJRRmwvODJhNnAzbDVzaTVNSTRLSG8vNWxXMFkyL0k5eGdHa2dk?=
 =?utf-8?B?T1dGUm5OOVB4YXB3MVFRTHV2ZXhkTmJIcHRkcUs0ZmpXVFFaRGxhS25zTWUx?=
 =?utf-8?B?NmxJY1RpNjZpb0FHSkdVQ1FycnlxVHgvLzlubUJGUHpBRlovV0xLcWlXVC9j?=
 =?utf-8?B?b2IwT3dqYSs4WGtRc2Fud1IyUWpXbHkvNUE2NXNaUHVBdlFXRnRkcnpUdmJy?=
 =?utf-8?B?RWVwWk1qOGtTZGM3TUJubVp2WmZPUjE2bHBpcVZXUGNYMTZWY2JIS3JnWkx3?=
 =?utf-8?B?WG1RVCtEbTk4eVR2L05mc1JocnI0dVFDa2sxU083THVxTVJZTjJzR3E2SDh1?=
 =?utf-8?B?TDgwZEtIZGtyQTZwUnlzT3BzN21VVlptaVNmbHdJQTQ1MmwvTThPNjBoUklS?=
 =?utf-8?B?UkkzeWJYVktMNm5hQyt1dlJSQmx6QVNXa0kwTzVHZ0RSVmcyTGFxSlY2Y1ZV?=
 =?utf-8?B?M3RZYjh4bXA1Q1dPUHU5TlZpSHUyZmlXMiszMXpMRHRpTFhlUDlCMG1YT2pi?=
 =?utf-8?B?cEZyZGtsSjdhRWkzMlJwUUh5YTU1WnRMM25PdW9FOGUycDBjYXEwOVlPQy9Z?=
 =?utf-8?B?bENHdzNaTUtiUWFIdllaNTdGVDlBQXN1R2xQQXl3Q2VDQWxnLy9Od25ManRq?=
 =?utf-8?B?MWlSeDZZQmo3Wm42b2huSXRuU2Z5YktKWjVqQnpGZ0d5VlRHUUdwZDFRZTBV?=
 =?utf-8?B?RWRBcXJmKzhDMWpDaUtxQkFqQmhDZmRoQUhFWTRacldIams1bE9nRVVzUWxC?=
 =?utf-8?B?Z3pIcHJOc3h5REhlK2dFNVdOdFU4R3BLQlNaNWNMUDFKbW9SSzI0ZmlmaXJn?=
 =?utf-8?Q?i0KdT5tM2DovfhRUxrtcpmiGz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e22996-03dc-4989-d727-08dd2a408c23
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2025 08:44:47.7602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QoW21EZB4udR7cmkohQT4QU4t0bfDCwge5QxED7Ynt1ta+ca0efvkP4y6+xl1HRIocjDrWtbIoqwATw9s56Kdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8595



On 12/24/2024 5:23 PM, Borislav Petkov wrote:
> On Wed, Dec 18, 2024 at 10:50:07AM +0530, Nikunj A. Dadhania wrote:
>> With the condition inside the function, even tough the MSR is not
>> valid in this configuration, I am getting value 0. Is this behavior
>> acceptable ?
> 
> The whole untested diff, should DTRT this time:

I have tested the diff and ES_UNSUPPORTED causes unexpected termination of SNP guest(without SecureTSC).

$ sudo wrmsr 0x10 0
KVM: unknown exit reason 24
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
...

$ sudo wrmsr 0xc0010134 0
KVM: unknown exit reason 24
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
...

IMO, the below change appropriately handles all the conditions well and does not affect SNP guests without SecureTSC.

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 84e4e64decf7..a8977c68695b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1428,6 +1428,40 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
 	return ES_OK;
 }
 
+/*
+ * TSC related accesses should not exit to the hypervisor when a guest is
+ * executing with SecureTSC enabled, so special handling is required for
+ * accesses of MSR_IA32_TSC and MSR_AMD64_GUEST_TSC_FREQ:
+ *
+ * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+ *         of the TSC to return undefined values, so ignore all
+ *         writes.
+ * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+ *         value, use the value returned by RDTSC.
+ */
+static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
+{
+	u64 tsc;
+
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
+		return ES_VMM_ERROR;
+
+	if (write) {
+		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
+		return ES_OK;
+	}
+
+	tsc = rdtsc_ordered();
+	regs->ax = lower_32_bits(tsc);
+	regs->dx = upper_32_bits(tsc);
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
@@ -1437,8 +1471,16 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
-	if (regs->cx == MSR_SVSM_CAA)
+	switch (regs->cx) {
+	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
+	case MSR_IA32_TSC:
+	case MSR_AMD64_GUEST_TSC_FREQ:
+		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+			return __vc_handle_msr_tsc(regs, write);
+	default:
+		break;
+	}
 
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {


