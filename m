Return-Path: <kvm+bounces-28564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D3C99919A
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 21:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE8E1B2C4CC
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEB41EF953;
	Thu, 10 Oct 2024 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="InxodJSo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF291EF92D;
	Thu, 10 Oct 2024 18:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728585291; cv=fail; b=Gl9r2foueD3Wi0s3QCSzkqD5IhTAvaR/jR6aTdJxdjF0eu1TN0CfFDSE0Iqi1M0EOm1lSxUpZ5s2cOXi7k0XC0i5WjfNMebaHj8Iu+SieZAn2KXJiPPVGRQFLY+xYmtkLcV8/GCIdkw/jbaI+HU4WYmoLWTmydYVGe3JPAtv36s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728585291; c=relaxed/simple;
	bh=goWsLUwLH3Fl3WYoQwHi9Ja6BNpnpAJct3svvpATpBM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UwrrEhJ6jObEmD8t/A8msRaUW1n2I19z9dEVN51n+GyJrtVs6AA20sQuA+HkP9+W9C3jsmbGUneYNgVVWR6taswMGrP2dHw07BNmIypxmXLGZfBVD5J1Bzi3Sb0dGQV/nihx+bmeNF8i162tgeWzE4nuW0nt0y0E/kMHhTUIV8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=InxodJSo; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SuXmNVHC/Y74GuI3Fi0LhQLPeKy8VFEMWf7Im4X8cuuFhEtjo1h6GOiWJVoyQYInOBmiQHQgT5kUzxBFxIHMunI/KaqDXm3zOqSfO3V8QUvO1gCmeJRmjmu3Xlil4AL2Xjsr9Xegx7UL/lVitjLp6B+OgkL0OSuvBOIuWfKRogay5v+4P7Vi1826UPytLysamXb+HWYU+hMCwRgc4CgHP+XwsNU4CDlXx1iUnYGI9KiXLoTFKWN8TvVVEsU/VQKxAXN8wDDf/3irFshJsu6AvZibznJCzwzfb8a+f7jjykSdlbXUJs4M7qkmPZlF4GQm5BzK9yz1XoA6UaX5k3Eo7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAF3pMhm4oxkYxuLOrhKCdmTUdEJoUXAXmWXmACmvZY=;
 b=xmXlCbs8tGA9hbBBZ6fiqkz9DF9vO3W6Vif5UPcnbeF3rE/yTUl01wxBddG0C4o/7vBcEitaYrvtiyiy6MK0KwhAO62USY13JmD32io35io6EAIJ+i1pb3JjOQ2FW6eYs/jVRpINTVV91m/zuqBErvTvatB5xsv35Bakn2A25xbqTgq+avgw9X1htFDIr1q2see+9IYHkXikGfts5nk7c4YWIpj8qVBXS+tvrSH6n5gegzjF6G/08LVNPtvOvHUdYAmkJTqaVOaO3iWwGXAFv1GVU1pFKCMDO2wrCj8qO6NPzDArtkJOemtbdNC4zvBY20Ujcc4CHX+27oUWAD63Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAF3pMhm4oxkYxuLOrhKCdmTUdEJoUXAXmWXmACmvZY=;
 b=InxodJSohkWuZDfknqeO7/qUaJj2FROvDiMpns1wGHqOBMn4UG6Farvf/jmlFuA1Ydqo+yQTLHVBP37lDDaK0pbVzlMGMqKwd+vhCJPEQlc81qJUYq4VSlV7fmGM8SVvgawU9cDsI1H9aEupnzUWAOwdI5ghAQqY3jjvHpIrliU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 10 Oct
 2024 18:34:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8048.017; Thu, 10 Oct 2024
 18:34:47 +0000
Message-ID: <233f36d4-aab7-6b8d-c1c6-e46068d64618@amd.com>
Date: Thu, 10 Oct 2024 13:34:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v12 09/19] x86/cc: Add CC_ATTR_GUEST_SNP_SECURE_TSC
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-10-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241009092850.197575-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ab29ea-a53d-47d4-93ee-08dce95a3791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlRxT3Nsa1ZlQVp3RlFkRGdQMzgxcjlGanZXSTl3ZjZTTUlONEx4cTJkRmpE?=
 =?utf-8?B?cTBHQnUxMWZDUEppTWFJY0NNQStVd2llSndITjRzWERwKzFuaUNJMmVURy9M?=
 =?utf-8?B?a2FOZHJ6ZmdweUI0MCtJMEFjUjh0T2NGUzVCUjRkR0xSeFNQNTZOZjF0UkVX?=
 =?utf-8?B?eDhBNmhYeWg3MzBQN25sNVVNQ1RvTlcveHUzWjBkaElvRThmQ0NGZVhUUUEr?=
 =?utf-8?B?TXd2bVZ2V0JlRVgxczQrM1hzeUtIamVUNzNsdjM1cGV2SE8zemFwTXRtR3lH?=
 =?utf-8?B?dTc2ZSt3djcxMUN1bmlXQ3ZiK1lwTmdyZXU3ZnRDNUUvNlJZdTN4cVE4aXIz?=
 =?utf-8?B?S2FYdmlNWVVnL0UveDVzQ0N6YnY2YVhuZHFLMW9qdG94c3hwSWpZanpjaW9X?=
 =?utf-8?B?V2dRUEplQ1dXUWFPYWNVQlR4Um5kbStINE9LaXo0SDZHR1R1TExJRmRhVW5y?=
 =?utf-8?B?aDRtbTFlcHE3WkFSdkxVM2RoTGE4bkZST1c0Y3JabE1mWGg1Rlh2ZW1VVHh0?=
 =?utf-8?B?eWZPMTl3Ymp1NUNMa20vUlRzYVNWUm9jWDFZbUEzQ2xPSjM5K0UzZEZsNHgv?=
 =?utf-8?B?bDZmVVJkaThZaVBNeldIdnVBQmRUcmczejJydHFoQkdlK3VPT09WWVlueTVy?=
 =?utf-8?B?NDJaNnhQU3FyZytZSlYrN2haNkZRR3VuVERmRHFaemM4eGhHdDJyUkM1a2tt?=
 =?utf-8?B?aTBNNjFWbnFCajNaNkRUQ01KZ0d3dEdBbURoakVPWG1URk1mUFhIMTB5dy80?=
 =?utf-8?B?WEZtVStvMmU1N2h2N0dJTUFCVFJhU3ZRdWZlOUZvRHdIVVpCQk01eHNieXdv?=
 =?utf-8?B?YysvNDBKWnpJaVpJM0F2Tkg1eFZTZmRIaWpLbW5HbkhHZ1Z1T1ZTVGFDM3JK?=
 =?utf-8?B?YThTZEFtcGloNWZrMllsQ3hqbjdDc1NSNDFPTDFublJYdm1CdkVReVlWTGVs?=
 =?utf-8?B?WExremdQS2ZXeGZxV0EzMnVwVm1DTVJVbHVCU3F6Y1h3aUx5RGtoWHVMN2V5?=
 =?utf-8?B?alZoT0kyajVkZEF3VjBNR3NTZjZKWWY5YjBKR24zcDhxeUsrbG1JUm9FNFlV?=
 =?utf-8?B?cUduTGZtUXFKV1ZwWHplM1RLZDA5WjhNZzdBWmh1LzJESm1vL1o5ZlYzMzBq?=
 =?utf-8?B?SG9rMmhLdFVCM3RPUEw0UFhNaEYxcVNYOXZSZUpUdERHSVhOeUl1dXByR1Ex?=
 =?utf-8?B?dWlyRlFOdUY5YXNpZS9NWHZqSG9SUCtJQy8wZC9hcUtFQXhuMEhzb0xjMFBK?=
 =?utf-8?B?L0lUTXdwcWpaVXZYSnZQaWdRR2Vxd1VPV1Jpb1RuUFBJN3VUTWpadEkwRXdC?=
 =?utf-8?B?RENRSXpyMFhWMElZM3FUYkZTUmx0a3RPS0lDckkvdDVOUiswN3dhMFdPQ01E?=
 =?utf-8?B?QkdBazIzc2xxdHZ6aGNOdW1GbmlBZ1lwYVdCaW5rdlFDUVVwcktsZHpyaU9q?=
 =?utf-8?B?TDdFUFdyUUZsYTFESHVYS0RvSk9LejRHblJOdlpva1VDeHNBNVFyZUNRb2M4?=
 =?utf-8?B?Sk4vbFNJZXBIWjJjMFM3ZTUrSzNLRzFBMGt6WVFNdGdhYnJsQzJHdFZYQjFW?=
 =?utf-8?B?bjhndnJkYjBRb0pQeDg2Vng0OHlGNFJaN1Y1Z1U3bzI2M3laSW5lRFVpVTBt?=
 =?utf-8?B?eG44dmN0Yis5WCtsM1VNUFZranhTMzdJeE8wWlFHZkF4SXNydXpKVW9FUVdU?=
 =?utf-8?B?QU5TZzZKNUthNnRhUThCN2M3YXJCTE8vOVppQ3NHK1g0dk55bS9KNGRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnBOczA1TVlieFdMRmpWWDF3RGtDdVQxa2kwVmp5d3V6NHRhcThveGxMblEr?=
 =?utf-8?B?UFMySGRFMWFya01laXJEc3FEVEFGK0NEZUpzNXkvMGI2S09QR1B2azFYYTNI?=
 =?utf-8?B?djZqMEk3MThWcW1HcEs5a3A3NGpZVW4vZVBsUVlhcWlpUGgvV2FyRXFwL3ZZ?=
 =?utf-8?B?bnp1eTNPMXRiWllmSHhleTJJVnNYaWtKZlBPZnNYS1kreVJMdmx6ejExa3Nw?=
 =?utf-8?B?WUdtSEpKU3lXNXJTdlJnM3FnbGpXWmlERndEUHBtVGxqdXQ1SEpuQktXNlFQ?=
 =?utf-8?B?Q0tUbS9LNXR2eHZCY01hMWNmUTkyYWFGM1BnWWhJNFlNV3VTWFZIRkZQSDdx?=
 =?utf-8?B?dy9EVU43bTkyS0ptRTNVbnE1bWFNV2w4WVJoVzlYaVc3RUdLY3N2ck0zOU9Q?=
 =?utf-8?B?S2RvdU1RNEZlSWFPV2xkMllYM2FpeVkxdENGd1RmNGpKMitHWjVTWDZQNjhO?=
 =?utf-8?B?c2J0Uk1mRFMvS3RjUVBHQUtReFVUdUZiQTlWZndVYmp6cG90b1U1MzhkeVdj?=
 =?utf-8?B?Vy9mN2xaVnRBUGJGVkYwbm1nNUtpMUc1WTBNK3NnbDFWc2lrRnhPU2tzYnVl?=
 =?utf-8?B?WUdSaUhKeExmK1VvdENtMjZCU2tOL1ViQ0tNNytPR3ZPbVhhVHBEV0pJckpX?=
 =?utf-8?B?RlJxUGxqZ2pmSHVTY3lpdGoyNGRjMW5sZlMvZkhaaHBBejZTVkFEVFRKUVB0?=
 =?utf-8?B?bERmSHlOdlQvdlVKSEZPSU04YjFSK2lNSlAyNGEwL0JKbFVNTWp2ZnpYaFQv?=
 =?utf-8?B?dGZsZ2dRS1I0dEM4NTBpa2QwMWxNeHBaY1MzemRGWC9kU3hRUzdOZGdENCtY?=
 =?utf-8?B?WjZ4L2Z3d0VEQWtmVGdiS25rcG56ZnN3ZlozeGhvYjZ1K2kxUFhPSFRLc3Vy?=
 =?utf-8?B?eERGNllxQk5BSXBzUTdiS1NnOU15STg5OFgyOStPdjJkQitYWmJkQ2NVVDc4?=
 =?utf-8?B?ZVlZcFhtdFdESlZZOFUvRGFaSGxFRjlqUnh5SStCQUl3QmYwNUd0cTR1Skpi?=
 =?utf-8?B?TDFYbitTZHR2c1VROUVCaEtnS1hTVS9RSkV5dkZwczZHTEdoTHJsMGVOTWk3?=
 =?utf-8?B?RGg0cGhIYmNZMmJMdzFYczl6azFHRlJiclI2djlBQWVTbDZnbkFMN0FteHpG?=
 =?utf-8?B?R2hFeGxqUXdDYkVwWWU3ME5BYU8xMUdQOWZWWDJ4RnQzc2R1aGpGYVNtY1lM?=
 =?utf-8?B?RVVLcm1WS08wY1pmdWdxTU1qR0VqT2hWS3YvbnE2OGowUFNiM0c0YjF3RTE1?=
 =?utf-8?B?eXA2Uk1VdDd1TVFZdnNpcFBCdVAwRGpjK3dHUHN3RnowRkZCNGFHQWdWREo5?=
 =?utf-8?B?LzRaYXJQcDVsNWREZWJZZ2QydVZZU0owNUFRNG1Ra1AzUG8rT09xaVduS2VV?=
 =?utf-8?B?V0lwaGd5d0RxS2p1OE5lM2Y1cWxLbHFxd09md2ZDOFlraS9zYmdYMTlGTE1L?=
 =?utf-8?B?WHcvU2xjejFKa2dPcGdKckU2d01VQWo0dW1ITWlqUVNxQUxoaFRNUXl1SDgy?=
 =?utf-8?B?L2RYZ1h6VVFQOGlCMGpaaFh2NWZJeTRWdXhCUVVNWVZ6YVg4WDk0bjlkWEtv?=
 =?utf-8?B?cks4M1pCVnJNOFZmSERERkx6dGF2bWM3dXc5ZEFwRmNKNzlEb0ZOMWRjci9i?=
 =?utf-8?B?Tzk2Mmg4Zy9Hamo5VmFrZVo4SG96cXdkVkFpbWNzS004M1d1VUswSHU3MzU2?=
 =?utf-8?B?K2VPS2l6SGszZGI0clhoOURjWU42ZmZ3bUxQb3lkb0hPaC9CNGpncjJIKzk5?=
 =?utf-8?B?MS9BRTNHQWlvT1dXbFNaem5JOURZUDg1QXlZZEpsTzVsWHRxcVYzYkdTejJm?=
 =?utf-8?B?NE9QaENDcUN6WjhxeGFXS0dEcDduK2NMbnpvZHVNTW1kWlg2ZzdZVVF4SXdo?=
 =?utf-8?B?OWVuSUxUUUJUWmRFS0VJVklyYUpZcmtJTzFaeFBONUk2K2dWbjRiNEhlS0ZL?=
 =?utf-8?B?ZVhzYnhyc2E3cG1WaGZ6L0JrRk5PZHVqMzNMdXByV3RvM281bE1jVVc3alVj?=
 =?utf-8?B?S0RPQ2hXemFVYllpWmdCa20rNTllL0dNcEZNT1o2dEl6Z0R3QURZVVRqRTdM?=
 =?utf-8?B?cHM2dlc4UFc5allKcGNYb0tJbUczTDVMaUNOWUZxQ2F0eFhJNXpNVU8yc1Vv?=
 =?utf-8?Q?4ofGkOuSbfcIg2OKkDtJmUxwx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ab29ea-a53d-47d4-93ee-08dce95a3791
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 18:34:46.9714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9MXVnN3kb+DX0WUmdm+nVj0vaR0JveHY3M749s1VtP6lU5I20mBzf9mMpY3kAlneI1tRfZhKr2t0NjjjSCp8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143

On 10/9/24 04:28, Nikunj A Dadhania wrote:
> Add confidential compute platform attribute CC_ATTR_GUEST_SNP_SECURE_TSC
> that can be used by the guest to query whether the Secure TSC feature is
> active.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

(Although, this can probably be squashed into the next patch where it is
first used)

> ---
>  include/linux/cc_platform.h | 8 ++++++++
>  arch/x86/coco/core.c        | 3 +++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index caa4b4430634..cb7103dc124f 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -88,6 +88,14 @@ enum cc_attr {
>  	 * enabled to run SEV-SNP guests.
>  	 */
>  	CC_ATTR_HOST_SEV_SNP,
> +
> +	/**
> +	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine and actively
> +	 * using AMD SEV-SNP Secure TSC feature.
> +	 */
> +	CC_ATTR_GUEST_SNP_SECURE_TSC,
>  };
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 0f81f70aca82..5b9a358a3254 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>  	case CC_ATTR_HOST_SEV_SNP:
>  		return cc_flags.host_sev_snp;
>  
> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
> +		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
> +
>  	default:
>  		return false;
>  	}

