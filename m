Return-Path: <kvm+bounces-19921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C849790E2F9
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 07:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52F0F1F235CA
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 05:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F35C6F317;
	Wed, 19 Jun 2024 05:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5sYXhZM8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4D457C9F;
	Wed, 19 Jun 2024 05:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718776700; cv=fail; b=s8AHlHNyIQOrhghfZ+lScPQ/rE/pW0ccxt8ruSrMZyDaE94frk4io4KnsMLFhbeVV8faII+664diKW92BsYmHrLF8C8qbdfNxI9cqnsDXbXbgiSr7E4PyMA0Au1PkZUvGHlig/AVHCgn7gPw4zO/vu1WsWjGonAQQi4Q7I/aBbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718776700; c=relaxed/simple;
	bh=NdubEcfh/213v7THyhYK91ju26cuYxd/pVLhxSe7Ej8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bXiZncVJm72qDsjyihwr4BIillM4Hane2NILkPgyx4jFJmmwU4yeUgPzb105//1Be3PolohIlbBmuFM62vER40N6w1TkhbNh+7cHu70uY/xRZcMQd32sfsFy6NJvvtLybabmqJV3OEjjyZwKvbpP8EzwfJNmtaM7aIH2fn0rfqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5sYXhZM8; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hpnm3a2rjm2ltI1978bZXMTbTdDSfHf0N1brbcSjGIh2vGHItWlPrYYzQnftkQ+sireF2co1hp6RCE4y1CUOfFC5YHv4DqD+kPaTGNzOX/IvP6WwzeZvHYSK7tVgWc59HMevx7CG9EnmyKF42LrcQCCmxWKZFPq4RmfOm2wU+wwCgRGq2FRQsBVwgOfqQ+oxKw09GJSbPWhqk7sZDUGhPJ6894kBW2icnbWfEUmcVHlZUxZ2KaV6oEChGbk5L0FhI0a3MuU6diYs0qo5XUsg4Vkz7Kc2bXLML0jyDvioRUvoaTZcsKcON/3HrJF6vIlkvT2VdbG9hijhJ7k0AWS0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p60fwGzOOBDJu1YSybedJvBxXWu8Pcn5jBSZsavgdt4=;
 b=HY9DR0dTKPmVutSB3ct1zdrsh9zfqnarlo3U4EZ7tNVRhdd3LtAChkQ5dxWAR4rt98eVmYxiehvEHRX113jqi7kslwfAWQzaNjPiLC2cyd9qL3FEoxH8FKn5aTaYkmGi9gFH870ErjGAdqKjNki9dTJddQ4wplPR7NGvSuAMVqbZxIHRphsB0XXz3lbgRnctDkGT9OjE7swG3VkaHOwasrVlWRpZT2twX9bU1QhUfuj4OdinD6DHCs70XNDgjItdhGcYrUFy1ngwQDX9G54B5NKyyrqmTgTkb2HdfR+ARFOY+ixWy3dqjGWegOdq/dDyuFCkyymVHB37J7YxnF6Ezw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p60fwGzOOBDJu1YSybedJvBxXWu8Pcn5jBSZsavgdt4=;
 b=5sYXhZM8ehKd2uQ8R454NOxYSebil2uJpJFBGm/xGJ8vp4UrzmfNIKiuyszo8h5RyM3Ja1dTG1S1fJQVUgzaNX5R/TFJmxJ33LLNeWYnYlAIIZjXfWapgubD9D7BP00etkADZObHrdCRJMRRJMD89leHs5Bmhm1vBoUcE48JOfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB7132.namprd12.prod.outlook.com (2603:10b6:806:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Wed, 19 Jun
 2024 05:58:16 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7698.017; Wed, 19 Jun 2024
 05:58:16 +0000
Message-ID: <57a570e0-b58f-8f56-569e-eb8f6091c94d@amd.com>
Date: Wed, 19 Jun 2024 11:28:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v9 05/24] virt: sev-guest: Fix user-visible strings
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-6-nikunj@amd.com>
 <b4da8dc1-17ea-52da-c8f4-76a8bb6acb16@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <b4da8dc1-17ea-52da-c8f4-76a8bb6acb16@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0002.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::23) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB7132:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ac87a1-0bd5-4e7a-39c1-08dc9024d00b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVlzRnF3U2Noa2ZnUlMvY3hUTmhqTnk2dnk2a2VmTVgvUWFadTltUTBubXJj?=
 =?utf-8?B?NGlNK2ZCNjRUMVA0UE5kMzBmeXYvOGg2eFgrSmJ5RmhpYTk1MC9wd0kyQTRx?=
 =?utf-8?B?UTViMHZNQ1VHRTJmV05FaW9kdWdnSUdwQlNWK1hzOFJnam1XU0c0Y2Z0Zkpw?=
 =?utf-8?B?VUgvM2tMcEhIT2NWWkdYRlU4dVNsWXMyYVhzL3g2cU9KeGRSMFAzSGNtVFBH?=
 =?utf-8?B?ZHBNTnVneDFvcmxhbktOWCtlUFE0VkFkU0dIc0dGQ0wzTmFXR0o5dHp3bU40?=
 =?utf-8?B?cHgwNWJIZ3N0VWc0TlptL2FTUHhaRVQ4VjMzR1V0MnNJNC9Yb1p4YUIrN01k?=
 =?utf-8?B?bjFicEJYdldlZit5Szh3S1E3aThjSENzNERPaHVUeGZ4YlRFRlZQZy9Wd3NZ?=
 =?utf-8?B?OFlTUXhGOUwzSkZIM2NDUzcwanVzdVNhZXdsaUhXWUw5a3REWCtlL2hPdzRw?=
 =?utf-8?B?dksrQkM5di92emRNSktPWnhhcVoyNTNBaTVSR0xnYnAvdnBSZm1uMVl0eGhF?=
 =?utf-8?B?ejNCYlVZYjdCcXo3VmIrVTRxMmFDNTVlMVlyRHNYUmZzSUxYc2JUWDc3RFRV?=
 =?utf-8?B?b0pRQityUm0zUXdQY1RFOEd4REdjSGtpQVlVdmg4MnBNQk9qWmIxTHk4OW0w?=
 =?utf-8?B?d29QTUZEcmFQL3pLOU1iL2VONFhqenNLNEtuNjNIWWhTT0pGcllqU01lVzVB?=
 =?utf-8?B?MWZaNE5ndnFHQVZyVUZBSkpYN1IrN2NIZlc4b0hhVVZkRFp2WDB5cmFNdENG?=
 =?utf-8?B?TFIyQWdMSHIvRW1VaUdpSjB2STVjdW9QOHdmdHJmYkY4RFNJQTl4TnVjR3lO?=
 =?utf-8?B?RkhBeXJKVWxDYTlKclNtMTY4UWJ6Z2dNVVU2VVNoYmdUOWxiNkc2Ukpzclln?=
 =?utf-8?B?MTBiNVlmTkIyNVpmRm1Uc3hhbVFId21JSkpRd1B1VmRvU1pOaElkZWhFcFJE?=
 =?utf-8?B?OWo5QXR2Tm0zaGxCaWVyeGI2c2Z0TWliOGU0VVl6VnVGaWZBNEF4d3FneGFX?=
 =?utf-8?B?UTEvY3FhSGxWLzVqMS9pb1hvMzRMdFZFNmtTT2dQc0JUcERCTnAvdTVPcEor?=
 =?utf-8?B?bUsrY1FJMzI2a05LWTVFUjdDQU1GbnpTQ3hzcXI3aUZSUEZGSURiMkszWE5K?=
 =?utf-8?B?V0t6K1N5Um9FeUdZSUowSEZUcjlPbkJ3UEdsWTk1dDAxWjdvMElpSzNPeFpu?=
 =?utf-8?B?NzcxM2l5UE5FeG4wb0loZkFuWkROMTE0TDhMZURXZ1RIcG1UdVhiaXpzVW5n?=
 =?utf-8?B?M0t3STJIOXEvcjNwZzUxRkFYMjg4eE83a0tzRmxpM1cxbDFHQnkrWEt1TW1S?=
 =?utf-8?B?NHNCSjQ5Q2g2MDFkRExmQytzWTF1blhlZ1UyQlo3cVpvVHFrc2w2QXVrMXcv?=
 =?utf-8?B?d1dtKzNQcDg5UUM5TkxFLzRwUFNhMkJXVnRod3REU3lRUjFEMjlFV2Uvb1A2?=
 =?utf-8?B?Q3pPUCsvclpzaEduMTRkV2l3ZXBCV2pjS2JWcHhTeHNSWlhZaVJJN2svRDYy?=
 =?utf-8?B?Wk1zNk1PWDM1OGVkanpTUFVrTi9XQkdXbHFENnIyRFhvc2ZnRGhSa1FLUUYz?=
 =?utf-8?B?ZVh6a2JEZjVmbjI5Y25EcFJwRERqdlhxUnl3YTBCb2hGTnZOQVg0TTliendI?=
 =?utf-8?B?RXdiajUvOHpoZXUra1g3NGtxUHJFSXRTTmtJYmJLTzUzc2dvM1EwUmVtOUJ3?=
 =?utf-8?B?eVRLdmVVcDVyVHIzbWYzU0Z6TmFiVUI4RW5ldkFGTHJKZzdIWXNQS2VDNWdk?=
 =?utf-8?Q?lFXDUxzDUfay+rkXQHkqdUWAhFRZ+608TuSGfY/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzFGYm5YNzJneXZmOEdMemZROUN4NVdxK0FmS0hiLzFQbWF4Z1JibnIrYkVi?=
 =?utf-8?B?WlhITVBwaUpTcHNIMVN4a3ZFanpqUW1vdHZCSXd3bk1oSkhvMTBwK2N3MzdB?=
 =?utf-8?B?L1FTdjMvSWpvb0NmdnBOQWFwUDVXRzF1Y01GNkxPaGczSHpDTTgxNUtXbHZy?=
 =?utf-8?B?Rk9rVURrUW9uUEpwRDhPT2MyYnkySmVSd2MzQ1JPZ091NGJnL2xJOC8yQnR0?=
 =?utf-8?B?Q0w0WFhBNEFLSnZiWjZmaXFkbWhGY0ZqUTZXZHp5ZnQxZG8vUVAwMkNYUVBO?=
 =?utf-8?B?SGFzQ2RMblJaWVJSaStFb1V1bGMrWDJNS3UybE1DWktCaUVBOWoyNUZpcTdh?=
 =?utf-8?B?REhHMENKNm1UZFR2bjJ5a200N0lxOGtBeEtQSDlLcjFhbXBPVSttY2tWKzdM?=
 =?utf-8?B?VzcvNXFkN09QNnFEa0UzUFRrZjE0MXNpN0lKUnZ1eUFPRDZjWHh1Y0RqbTAy?=
 =?utf-8?B?a1NwS3RpSGpFN0NRSFlmVHBlL1paMGcwZjJkUXVva3I4dnFOMEpjcjIwWUs0?=
 =?utf-8?B?Q3paRmdoTHAzZFBmYTlhcXJYUEh0VTVVRzc0UlZKK2VQSmQxSHN3Ly91clBY?=
 =?utf-8?B?ejdNemNQZzhEdC90aDhaL2Qvck1MMHJVK042dFBBbzVCVXFzTjcyL2pFZ21Y?=
 =?utf-8?B?SnRZOHRPdU5lMUZHSXRKYy9laVo4anBDS2ErTmhHdzcxaFNqeFhwZnFqRTNK?=
 =?utf-8?B?cHI3aGJ0UlpMbTJmTFR1K2FMSnF2SmVEZEVzRUhwM3puUzVqbmlYc3hJU04r?=
 =?utf-8?B?MHorWmxQMWRQOTNLN0pheTJVZ1Jyd3BXaTM2SkJaNWNLUit1S1J1b094OWV5?=
 =?utf-8?B?TWUwVVNBRHNVb2NzWVNzVkRsL2tqenJnTVhRa0krajhwbUFMak9nUUVMYzFr?=
 =?utf-8?B?NjRqWDQ5aWxXUVR0N0ZvK2ExZE1OdHF1YS9Fb0hJcDdmeFY4em55ZTVEMCth?=
 =?utf-8?B?NUpVSFBHUjBOY0JCQXNtL05WblFLSWlKaHZHQnoxdks3RXRwcFYwZUJIU0pp?=
 =?utf-8?B?N3I3bDBXQklnTEdKRFFtMUIweFVaNW1tbVlhTGI3eUYxYUhIWG5CWk5rOHpF?=
 =?utf-8?B?ZnBuUHRzaEw1dGwrd2M0SEUvNzUxb2R6U3NBVmRZVHNWaFl0a0E4cXlLY3Bv?=
 =?utf-8?B?czBuL2twcVBoNm5QdndLajRPVHNGMHJtZUVOTjRnd3VrL3c1aWVCaUlZUGtT?=
 =?utf-8?B?RDVkUERHZ1R4K25GMlBCSUVGRm9nS3Z3V002RU5tNkRFekJZVURwU2o3dlBL?=
 =?utf-8?B?d1BHSU1wQnh3ZTZ5RjV1SjcrWGFQV21HOTJkbmZMNmMxT08yMENWL2VVa05O?=
 =?utf-8?B?QmVOeEVEVXZ1MDJITCtZcFF2RHplTC9JRkNTKzhTbnVTVmVvQTNWbURwQjd1?=
 =?utf-8?B?L2p4NU1iRDk2RXJVekFFNTFkVlpJNjh3OFNrVE8rS2c3blBaTG13Wlkra3l5?=
 =?utf-8?B?amNONm1pYkNYNHBmOUp4WWZqTzVqVzd4a3V4N05KYndETnhMRHJPd2dwYUNj?=
 =?utf-8?B?RHFNTnQwSDJyR1ZXb294SGNUbVhqV1BnYTFMWTlFK0g5MFF5b0cyc0JKa2tl?=
 =?utf-8?B?c0JLQVVzV3hmd1NKSjBSMXVweWRGenVVRnQ4YjFxT0dwQXhQcXo3d1l3ZXNm?=
 =?utf-8?B?KzhJQ0VtanJDRithTm9KRzRvc2Q0aWRqdm1GYm5KeW5IMjdKSzBMeVd2Wm5v?=
 =?utf-8?B?TkpiSzR0TGE1bllUeUlrSEZoT0lqbUdROVVrYzdMUHNhUkIwcld3YjEvcm0w?=
 =?utf-8?B?VXhhYzhHWS9Ob3l1eUJoaVBULy90NWF0eUtnNDQ3bDBqR3ZEYlpiNzNRK3VU?=
 =?utf-8?B?S0VKL2VBRWx2dWgyRGt5VXlpdHBwZ1QwUTVBZ2RTZ09mTkJWYmhDOUtNMEJj?=
 =?utf-8?B?eG5EalIrUkNmUnFvSUdSYTVBT0xuKzhITHAwQTBTbkN1ZG1MNWp3WkNqUFE0?=
 =?utf-8?B?MXVIaVd2OFFrendoVUV2UVlkSzVZU0syYTd6VVg5RUp0ZzlhUWhYZVh6VzFl?=
 =?utf-8?B?RXl6SEh0eEhxajM2Nk14ZkJoOGVwRGZieVpFY0R0QkF3MWVSSGhYQWhyMzVO?=
 =?utf-8?B?QW9sYmZKWEx5bHQxTWtnSWNTb2FyZDJoV1Q3cUFWOW9aeG9QZTdBSHZHK1p3?=
 =?utf-8?Q?GASZtIJRfmHGkovWu9MAshibI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ac87a1-0bd5-4e7a-39c1-08dc9024d00b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 05:58:16.7260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZ6P7/3wtqXDfdL9qnguX2a0zrF1DuMg6tGAZGdQHvXp7/AaQppskLzCJXmlDqI5/cz5+0mP/xgkOvQJqy4Buw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7132



On 6/19/2024 2:41 AM, Tom Lendacky wrote:
> On 5/30/24 23:30, Nikunj A Dadhania wrote:
>> User-visible abbreviations should be in capitals, ensure messages are
>> readable and clear.
>>
>> No functional change.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  drivers/virt/coco/sev-guest/sev-guest.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index b6be676f82be..5c0cbdad9fa2 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -95,7 +95,7 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>>   */
>>  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>>  {
>> -	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
>> +	dev_alert(snp_dev->dev, "Disabling VMPCK%d to prevent IV reuse.\n",
> 
> You use "communication key" after each VMPCK%d below. I prefer this
> shorter notation, but whichever way it goes, they should all be the same.

No particular preference, I had added "communication key" from more clarity to user
strings. I will add the same to the above string as well.

Regards
Nikunj

