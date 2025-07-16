Return-Path: <kvm+bounces-52668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66C20B08033
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 00:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 664AAA42066
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE26E2EE5F5;
	Wed, 16 Jul 2025 22:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lxKaJGOF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C061C3C1F;
	Wed, 16 Jul 2025 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752703392; cv=fail; b=FwqlHKbA55/NgU03TGTLpS1JdJ5E6WQrKyzETGIzTDM4OcT+7rdRj2iDJq4cm08cFdwBttGx4Li7m06X++Ha+cvhQC+fPTvEWPE7qGAjckTol0g616ipQmjzfy0b9xexXsOvwCtmUZCFSvlU4j32sbpOKqGx6HQRfUdubsQY++A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752703392; c=relaxed/simple;
	bh=B85/wyF3+RuF7E2Op0krnUQBewjFSsWduSf50dO7kuM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P0dnwyNexr57XuPVucxWPzVPYCp/S1ZnF5b6TcBxwK+ZNMwslXTBsc0HisQ1gTzTu9zIK5LmEsBckI+EpzB7OdmVQeqH21FJRIO0aWP46nLbLCL1dYaMw14m+L8uQPQdygDbxY9ZOsPleABchX44SHPrpWH4/Yq9NEck85Eqv5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lxKaJGOF; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bc/AmrNalTXNY/njIWMIO074y19sL1Qsf+MrD4hN5a8iQ64JS7/NGoB/clZIkgl6Yil4br9T4yAmOYGcITMJVFh+uaxJXcfNL4X9iScWfDyV1cMGydA5eIDKT8m0YfObZd0ItgWXPex1oSqWb/Manw29eqiq9WYbvWw8D3fPR6rhXuBvWl6DSZ+KG6zG3fyj4q+BhkwO74VsZYep9vVwgTq5Y/dOwzubCbZHg2pU792X6DPJ0812qHb/ESdwMKy/RRwrjgy6ele0+NwaN7+Zf+Ad16lsXifn8mx1HBrdVFqLrhwHBv3MBaCQaCTMcWRNM3TZqmhqiepzA+QuU0JLag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFZMJuUOEjLa1eGIE+rMhSj0UIlX0qT+3mPzqMyr82A=;
 b=i6iMOVVNRUgQW+oVPQsRpvH9O2Y9wl4lKrcWmMY7GY4yDdUGlEbArOE5fByiIZpzhotLFDi4x9TispnYHgSParFfQ+JZ/CCaadjipktBUIuoI9qFBw3VLrphBT8OzaHm4s4OMCxbhXrmDHtHbNP8m22G3isCRfs1DF4Bl7zAs2kmsVcR1Rl9KbODOJvCNzY7KBEE7MDH4hMPBPvh58lm2+uGn1KkhkPgr5OwspDcj1JKdQTyOtOlGGo/YMuLU0ki5d0+KXft64WAca5AmbSMlSK9EIleZ/X6EED7jlW6GteLC2VJPr5zPclMkK2EgVXEInj/lcic4IwuBHuaURYDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFZMJuUOEjLa1eGIE+rMhSj0UIlX0qT+3mPzqMyr82A=;
 b=lxKaJGOFamitlw2qCkeTx77jvS7+RiNwTaejG5EwQ5DKv9mTRkqN06FEa9RZzhEv4kcB0d1FA/pP3MCBJ1wbxYZrVlCm9JoQhcb6FbYi8tQwM1m9OP/zdYE0a0JdvyQcnGBVMD0DD5e5PNws3xt9mwK6KSQeEuhdZbj2GpN50f0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB8528.namprd12.prod.outlook.com (2603:10b6:8:160::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 16 Jul
 2025 22:03:09 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Wed, 16 Jul 2025
 22:03:09 +0000
Message-ID: <d9638984-0d75-4887-8378-97807f6af2bd@amd.com>
Date: Wed, 16 Jul 2025 17:03:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] crypto: ccp: Skip SNP INIT for kdump boot
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ef1b21891b8aea8ffab90b521c37ab79d5513a7b.1752605725.git.ashish.kalra@amd.com>
 <d7b3e0d1-4a93-4245-b09a-701bb14553d4@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <d7b3e0d1-4a93-4245-b09a-701bb14553d4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0083.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::21) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB8528:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e9e9cd-96ab-46f3-576e-08ddc4b48ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3kzUUc5VkFRb2NOOGM4UzF2TFovY3liU05aVFkyMXh2dGFJV0VCdmZKVExy?=
 =?utf-8?B?NHNjOHZLajhDYWtXaDVjMzBzKzBXOUpBd0gwYU5sWlVuZW1XN2V5Zk1LKzNn?=
 =?utf-8?B?WkFSUWM5UlA3QUQybHppcXFDREQ2Uzc0RzloNmw4eGgxZlp6dGlIOE84VGkx?=
 =?utf-8?B?ZlRINmkyMmVSSndGTWRSNVZLVzBVdktrQnpROW5GUDJyLzNTTlloRnY2dDBO?=
 =?utf-8?B?KzRiRi9HVHY3MVJ2ckgzT0EwVjErMjRwV3Ixc3Y3R3p1Skt1YVVQNllxcTZH?=
 =?utf-8?B?Z1ZPK2dIKzh1cm5QeDRBK3ZPcFN4L1RoZVlrM1V6RmVidElXc3JGSFZTOXBh?=
 =?utf-8?B?Ni9YTXU3U09lcGU3NXZmREZHMXVaQUsyKzhhdHJOb0tSN0xWQXppYlhVd2V1?=
 =?utf-8?B?TVFzbm91RnJRTmppME9xSVpIb083R3VJWHZqTm0yZjI2cUJwL2lVZkp5RXNL?=
 =?utf-8?B?SmVvRW1sZXlCMUpWS0tMK015Si9xTGNjamc0bW12SWloYS9ld1hITkpmZ1hm?=
 =?utf-8?B?am5SY2FORjJ5a1lrMlhwU2lYbjVyeGp2QTZ6dWF0ekJLRlBYVTc3alhmT2wx?=
 =?utf-8?B?aG5iSEM1Znh3Q3k0Tk96MWthNWNDcWhhb3luUXB1dy92OTJIOG5qbCs0Tm1M?=
 =?utf-8?B?RVBJNFVKTlJLdndVaEliY1VnRW9wNTV4bTlqR0hmTWtxSUtrOEFnTU1ycmYz?=
 =?utf-8?B?MlJkek5yN0hoZFpjVm1sL1R5dkhIaTZWSDE3NTh1NnNOajFKWWJ0cG9OU0Ur?=
 =?utf-8?B?UXNQQTY3bVptM2duTmFBSm1takNCanVnQ1F1U2tXUkxDVkxieVh2c1RIVFhW?=
 =?utf-8?B?bTdsUHpSa2hLTStnNE9BekV6OXBuRitMT2J2NVZGaTFhSXRKZlFhaWJhRTlW?=
 =?utf-8?B?UXVrU25RMk5zU1ZaY3BPWDBRaEd3bjdmTHNOQWlOZGdqVzN5V0dJbSsxVmEy?=
 =?utf-8?B?bFArVEJML3E1UUFLZE1TVWVyOWplWDRRSmhSakdaZWsvWU5YZHpoK3J3SEQv?=
 =?utf-8?B?Yk1aTGprWEQ0ZUM2Q0drYTRoaVYwSEVwT2VNV1I1VzRINkRNbzZtRnV2U2ZB?=
 =?utf-8?B?K3lndGhHY3BTc2xZUjFlZWFCT3RMOXh1YUptcFJUUGxCK1phR3ZKMnRwNGFw?=
 =?utf-8?B?clp6RjBSMGU2cTU5cmc3T09FdWZEUjhRM1NRUS8yVVk4ZnFIam9ZQkhPbWhi?=
 =?utf-8?B?S3dBWHM1L2xuZVFuUnZjUlVZWHc0Tk5DM0dkOUJ5cks0VmVBSXdSTXlsY2t1?=
 =?utf-8?B?VEJ6VW1KSmducVh1VEw4SU0vOXF0SGc1ZWpQZGpMOWNod0I0RTNpM0o1S2RN?=
 =?utf-8?B?QzY0M1UwclFPWk5XOVRJQXVnakxDUE9USlY2RmNhd1UxUE5aMEh1NU1neXdm?=
 =?utf-8?B?cVB2RWcxOVZIU0pYSTNwcUFkaXBlM0pBRllWL0FycUFPQ3JZclp0SjcyeHhx?=
 =?utf-8?B?Q3NjTzNPS2VKRHNoeHNFYWRmaTA4RlpVZzk1RnJvaEd5VzY2TUwwMFVRaFpC?=
 =?utf-8?B?eS9IOUxnYXU4QlJpTFdhUEdjZk9VQ0NFNjdVNkQwd0Z1eVpQUzRFUnBUQlRh?=
 =?utf-8?B?RDVFaDErODdVSk9TRWZoVmlNU0ZkOWg3M2dTN2N3dFlPWDJjanpuZlZRZUNC?=
 =?utf-8?B?WEs1ajVTcWRMdmZ1N2hDc0lwUzN4b01tSnI4UXQwbVlwYkpzbmRFbllPd2FV?=
 =?utf-8?B?bHZpaHlZeG53bk9jSzV0OW4veEJrbzZWcEQvdW5ZbXdtL01yWGduaDdPazY5?=
 =?utf-8?B?YWJjVFUvMkI4UE5FNjNQT0VWNWliaTZWVkpxQWtWb09tMGhsbVd1UzlTYzdC?=
 =?utf-8?B?T0l6U3B5d1hPT3lPa3NKZWdmTjduMXJSTnM4S1RveURHUHdYTU12YUoxbExL?=
 =?utf-8?B?Wk9zM0tiVWlKZGg0azRMejBYWm9NbW5vREphTDZEZ2N1d2FjYUlHY1FDa1R3?=
 =?utf-8?Q?qHIBSxgsvHk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1cycFFXRXBUQWcxcXFIbXVJa0dSYnB2a2JoZTI1a0s2MVFrMGFVMEF1ODRs?=
 =?utf-8?B?OHBLSjY2ZjJXTHhSV0FPcGROb3MyVFpJV2ZSL21rRTdLMDFlZ2xqYWJjQUUy?=
 =?utf-8?B?L3I4RXF0RTRCUk5hNUp6SE9HbUJiL2lIRlhiL2hNUjIzVkg3ZCtGT284cUZM?=
 =?utf-8?B?Szh4WE44NmdoQ3ZoOVZkR1MxWFNpUUJiWGo3My9hUWQwQSsyczlGS0Z1SFVt?=
 =?utf-8?B?VU95MEhuNndoQ2srWlhEYjZLdDM0YUZEWjBwVkE3QkJ1c0RNbVlSWlRjVFBw?=
 =?utf-8?B?WGEvV2tXbHBkQkxYZFlLOHkxT3J5RmdubkJTSFN5cmgyUGhrOExVeitCZzFW?=
 =?utf-8?B?WmdWd0hETUpNWVZqenlHZlk5QlkvUmNDakUvWVpTZXRrY3VlZnhiNGF6bXFC?=
 =?utf-8?B?YlVRRmtvNGpRdU9wbk1hdHFBMDE5SUhkVmJJd0hsMzNEcVM5MUd3MjdhRmRs?=
 =?utf-8?B?TWxZV2c3RHVzZWhXRklnSENaZFVFWHdTaFAyZTdRM1pXNEhqKzUyQXdoZk8x?=
 =?utf-8?B?dG9sL2tZZlB4aEgvQ2N2anFwNEdiUlV2WW5qMUN6bURYamY2b3dMekc1ZEd2?=
 =?utf-8?B?NFZyOTZ3TGlJbC9mR0pxN0p1RUZZa3VMb2Q4VklOQnJ2UVhQZFlYR3ZJSHFx?=
 =?utf-8?B?Nk11S1RsQUtPR1J1aHRmck9hQlJBMlNNY2EvbHRVSVlha244dkNYOHAwenFD?=
 =?utf-8?B?Uk93cFBIRm41STFERTZMKzA0ZVcwT2orTkgxYmFrTEZUWWswS3lVdCtsNWxv?=
 =?utf-8?B?UmZKR1p0NWNuWUhKbFZRSFdhazZFbERGRG5mR2g0dXJtbE9tQ3RxSVE4VFNB?=
 =?utf-8?B?SzNjV0NVYjQvZDRsbnF5SXlFS1NDRzE3ZXVqYndra3o2YkZTZTJPS2NwOGIv?=
 =?utf-8?B?RFlTZzBrSUhNMTAwRWFDem1oWlBVMzVzYWJraWdzSmVDOUR5c3dzVlQ2NmMx?=
 =?utf-8?B?R0tJRkNxekE4dzZrWWxOVkdSbmlhNjEvZk9ZNGNaVVpxbmF6Z0VJYmlaZ2xt?=
 =?utf-8?B?ZHBFTGh1Y3EyWDBBMEdiSmVaQUhnc3RoZ0pzd1pMdzVaOEtwTnNXYlpJM1dy?=
 =?utf-8?B?U1k0SVo2QS9LUTRPNVNFeENvaDdQeExXb3dXc211czdQSWFxY2pGcC9BcndG?=
 =?utf-8?B?eHN0eVVKL1RteXJkS290SGFFcmJ6QVVxdlhjUklTaXBsRGNYcUpSWlNpQUdz?=
 =?utf-8?B?L1ovdk0vcFNLTXhubGVOdUl1N1poOTFONDRDWUFLNVd4V091REYyTWg4Vy9i?=
 =?utf-8?B?cEtGakorR0VWSFIvN0ZJYjhpKzVNQS8yZ1A0R0F0ZW1kRkRueUQxQkhxTmg4?=
 =?utf-8?B?bXJsYzRlWmNKT2IxZndPcXR4cnA4MkxrVzBHUnM5YWJGeE8wdHFGaTRPVFN6?=
 =?utf-8?B?TDdPMEpDL21SWEtxUzl6ZGFFcHFTa01ZUmQ1ZDkyc2lSY0k4RTMzUXh3dEo3?=
 =?utf-8?B?aXVzVnpRRndQUDUrSlZDYUtTV0RGNnB0bDNlYUF4cjlPcWlhejNaNzhUdTNR?=
 =?utf-8?B?VzFIZ1hua1VPSlFrZDV1ejl0TWdBLzlicVVPTEFZR3BKR0RKR1pqYi93TU9V?=
 =?utf-8?B?eWF5c2Q3NGlwalNHVkREM0Mwd0pOUkdwL0lrTGtvS1IwSWQ0SEZ1RFAzWXR1?=
 =?utf-8?B?WldFVWVaWUdKaDRzZzRmMGJoYUlsUjlsaXVxSTZrL0g0VkVnckFGeE9tKzdC?=
 =?utf-8?B?R29STFR5R2lKUlpDUXk1ZldnMTRtQkRic3ZCZkM1cmJjOXBhRlhsb1FJMEJI?=
 =?utf-8?B?M0R2ZlBNR2EveEJSNkFEOWkvbE9vUzExNjRlcHRlUEw3U29MRUtWZkNuUmhi?=
 =?utf-8?B?REFNWXNGRkVYK0JXU3FsTW0vZGxNeHVnbEdPaDJad3kyMWpsNytncUlEeW1m?=
 =?utf-8?B?VmovQS9wRmF0YysyNUNhOTF2RWRwTGk0TGF1ZVlJNkdoUStTV3pIMTRBeTN4?=
 =?utf-8?B?S2V1Y2JYU3dNaDJya2hxY1dreVdRdHZxdmk1NTRIYnNNUVd5YlpBSEExQ21X?=
 =?utf-8?B?c1N5dFZIQzFPYTZ1d090NjNwZU9Sb0VLQnBKUTBjZUFLckVzcFlXOW1WeW1K?=
 =?utf-8?B?eTVpbmRjVXRjOThiV2FGM3JnWG96QmpjdkI2T0pUL3VOYnlSRmZvZlZQMU5t?=
 =?utf-8?Q?ZXa9q3rMD3C9fFcGnbB1MytJC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e9e9cd-96ab-46f3-576e-08ddc4b48ca3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 22:03:09.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOoPacbW7HwwAe+nLy3nMzjTBsf5APVV4ua39fSMa8pgjdINLoRlE1PhcTAypRLfOwzoSc6NHLyY+jIZfrKANQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8528

Hello Vasant,

On 7/16/2025 4:20 AM, Vasant Hegde wrote:
> 
> 
> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> If SNP is enabled and initialized in the previous kernel then SNP is
>> already initialized for kdump boot and attempting SNP INIT again
>> during kdump boot causes SNP INIT failure and eventually leads to
>> IOMMU failures.
>>
>> Skip SNP INIT if doing kdump boot.
> 
> Just double checking, do we need check for snp_rmptable_init()?
> 

Do you mean adding this check in snp_rmptable_init() ?

We already have a check there for kexec boot: 

snp_rmptable_init()
{
...
...
	/*
         * Check if SEV-SNP is already enabled, this can happen in case of
         * kexec boot.
         */
        rdmsrq(MSR_AMD64_SYSCFG, val);
        if (val & MSR_AMD64_SYSCFG_SNP_EN)
                goto skip_enable;

And we still have to map the RMP table in the kernel as SNP is still enabled
and initialized in this case for kdump boot, so that is still required as
part of snp_rmptable_init().

Additionally, for this patch i also have to skip SEV INIT similar to what we
are doing for SNP INIT as we get SEV INIT failure warnings as SEV is also
initialized during this kdump boot similar to SNP.

So will be moving this check and skip to _sev_platform_init_locked() to handle
both SEV and SNP INIT cases.

Thanks,
Ashish

