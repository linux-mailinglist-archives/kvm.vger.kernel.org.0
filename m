Return-Path: <kvm+bounces-26954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51406979A79
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 06:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BDC71C223C0
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 04:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16DE282FD;
	Mon, 16 Sep 2024 04:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dmhscjNA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADE614AA9;
	Mon, 16 Sep 2024 04:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726462409; cv=fail; b=BMsXWBLYkqhTnb/nx9BJm+zBTXRrNfJ93KSnoBnFWShrcTvagS+LwvkgNxEj1p9+bTPklUgy4TW+w67Ix3MHdnaSXr9VI1kHXgE9KlIEMB9gPusKfRJHxqRqatuoygeDo2Bn25wexm1ZyJ9qJ9phkVS4I4SHngbXxuSfWLaO85M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726462409; c=relaxed/simple;
	bh=P4NxayCBBteMjlyuXx9nFuHW6ZLrGgn4c+PsrK0w3II=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=axzZb9tQ4zCyi80kRJyHm8xIW6lTGXRmmrNkezBHb2EqLlk9OB5TA6U5kWptnh5ogphmb4X27jaxvALBc11DV5rV7DNnXvV5jq0qr7hT5nMK6Lpz1K3iknCRLenP8WWP0xQVOoIKfToLLv2vQOPsxsTMS1kx8mBYXO5NmrDQ05E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dmhscjNA; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkQEhCe6anlNl6es4dGm2ILzcuAVr/kvSt0K3r0yLSPhCueyVnOw/A9BVDelOuaTbo3x9RyrjMSQ85Iw/2aXwhB/Z9SVJ3Ewu5Y7WrCDopg5rNJfO4HolCZq2EDRlWYFl0xCfeDhKfe0LB4KK/9MURRGFocHp988GhnP3na+cyVoGAQq6fbtbf/njyocfrJNxKnNFVUFrwdpFiYpHnJcBZAuYUSEqa2BXvHsCVJxfJNCH+dySBG0uNjl/G2U6+B1iMhuT6hcilBHqzJEYULmZkGwo65QMXo+qBKnJfAgYO63xHRzYKcGB5GNxnGduMTLBLH3fJtv5i80EvQb79jwrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAl7iDhn1Q5S6Go9H8x+oDQscArm/wGDG2VDo/xOf2E=;
 b=hggDRUUfbabdO2V/X3YeIbwORa7w13U6FSZWbqw8ghjJjaly/dHLxGU9S5a7mb29yzC81k8Xge7eO3rDYjaPVu13HAWHObCigZUvaXBw276eiaQtOVIWl+EF3mHhYg/xtNvWUB0G8jx2eztJgGqHJPwlnJ8Cuv3mTJ3aIoi//YfonlAyJoIfB22PRAQdZwhA/Fsy1sey4IMsYfP3kMAEr1oDfvqrHxsAHNNdQchDHGR79v865Ord26+FRKTCWKVOTmyoWOk29gMJoSlPdrnizC+5ODB8kXWKAOiVicLX/C9/FzGfZqRKhdEx5tI5/EawuM5eF2AHcXKpKLkVvepO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAl7iDhn1Q5S6Go9H8x+oDQscArm/wGDG2VDo/xOf2E=;
 b=dmhscjNAjZ/jVOn8zsW2D1eRyp2KgXZaS65S/4cG850gX9ad52kQaOEwTen6i3gYsO11DrAogUKBVesVhPbCVdiRDyBlSGV4Vt7ZVtnNHtDtfNR8oUBc8XMPzGa2g0EFHa8lkC2TqkzfmmBS/L8asusYkHGZgEAf1W2f1b4HNOA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SA0PR12MB4448.namprd12.prod.outlook.com (2603:10b6:806:94::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.23; Mon, 16 Sep 2024 04:53:24 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 04:53:23 +0000
Message-ID: <4af95c25-6dd7-924a-c17e-bee4d73e9728@amd.com>
Date: Mon, 16 Sep 2024 10:23:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 13/20] x86/cc: Add CC_ATTR_GUEST_SECURE_TSC
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-14-nikunj@amd.com>
 <96333d79-8ec3-44bf-7b74-33c67ff2d0df@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <96333d79-8ec3-44bf-7b74-33c67ff2d0df@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0211.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::6) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SA0PR12MB4448:EE_
X-MS-Office365-Filtering-Correlation-Id: fddab165-4410-4e42-c21e-08dcd60b7dd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHhWb3BhZkFtWEhqZDdBSHc4TmVYVjU4WmJkNEVLdGttT2I0ZlFiblVzaVFK?=
 =?utf-8?B?aHVQeFo4YTA2TWM5U2JnbmtTVlkwWHM2L1J3bFNhdEdVbjQyQ280K2JwM0FN?=
 =?utf-8?B?K3ZuS0JkdmlVL203K3VvQzV4bFZMRWYzU2FPUnU3aEZOM2dWajhWc1hxUnBS?=
 =?utf-8?B?UUpwYmV1Z3E4dFhCQ0dwUHVuMHdoSGFOTFowUnRVL3ppbU9mY3RVQ2Y5bDEr?=
 =?utf-8?B?ZGZIdFJtekFsYUpacTlnazlkU05wbEdIQlVyOHJaa1lsT2huMFB1RmNnNDlt?=
 =?utf-8?B?c3lvU0xveE9HVmNlUVhRbGpGaFlzYUlTelFpeXFjMUNsVnpETXJFMy92WHYr?=
 =?utf-8?B?bFZWODB2R2UzK1ZITE5MSUpsOXdieDRwUWFXOFpuSmcxWkd3allXTWk4Y2J4?=
 =?utf-8?B?bGo2THdYdDR6ZUVZV2cxdURuWHNmZk5MOEw2TVdQVm10NDVqc2lGVzR2L0JY?=
 =?utf-8?B?cDhVWnlBWVRRWmdxK0VmaFA2eHNHaHVXTmlLYUhtWlhTSWVvWEZFOW1RcWg5?=
 =?utf-8?B?b3ZzaWwrTkU1d2NMZGRPNmZIZU11b2QzUGswb0xXM3BGalZGYmk1Y1U4Wmo1?=
 =?utf-8?B?TnBpT2hBT29CUzdKOWtTRXZmS0JDbWZaL3RjVVlNa2NzOEMxWGlMSmoxa0sv?=
 =?utf-8?B?UkZucktHTFJhUEhlRnljemtOOFdqRTR5aFZxNitJYUF6eWdYam9FVHBZTERO?=
 =?utf-8?B?aEJSbkVnL1pDeFIrb1JqUnZwSDdVdEpmREIxbi91UGtESU5HclBuc2lyM3hw?=
 =?utf-8?B?MExiVWwxYkp3dThpcW1zcEo4NXJOOW9Id1pTbC9UMUg1RXdIU2o0R2NxUnhW?=
 =?utf-8?B?SUpsOXl5cUVTaFNPV1RvL0ZHQkFYV0s1V0U2STlhMGh6akxxN1FhVTBYWFdK?=
 =?utf-8?B?U3BxeHlvRndDakY5R2pyWWpOUkc1SUhkQ2RwVXpNMzRXeDVyNC9BVWFFd0dF?=
 =?utf-8?B?Mkwydk1yQmJiU1I4Smp2aEl4R2lwMk5oOHgvQXloR2psWWNsRjBLU1BydDJz?=
 =?utf-8?B?Z0pwNkdYeE1Fb3Q2dnVtbmdJYWlpVzY3QzdEZ2lVMUZKKzFkaXdrUi91bHM1?=
 =?utf-8?B?LzBReUhwVUdxRGNaU0FJNzdSR3dWSGF4LzBRQnZsd2NMbE9GaFdXbUNBWU1T?=
 =?utf-8?B?Mzl4MUJ6Mk43emhwWDkrYk9vUFFHbnlNWU5hbG1STjJCcjJTK3FaS1llUGxn?=
 =?utf-8?B?S1VRRmV2MFBxUFFJZHJqZ0grVDl5NEM0N3JSb1FKTEpyZWpFUGNIeUltZERZ?=
 =?utf-8?B?Q2ppbFRjQll5K2N3VFdmU2s2QnZwQytKSEdRZmJDTnM1dTA3azZDdG1CSnZq?=
 =?utf-8?B?bW51Zm1QYkgrU3BwakNFZURvSWE4Y2VuWTdYK2VRSVZqc0grM1FjR0RjRTQy?=
 =?utf-8?B?T3g0Sm9LQng2UlFPREYxdXlDQmxTdGlBMFFGNVRLcmpuM1BHVFVkVkY2NC9R?=
 =?utf-8?B?NnVBdTZVall2aTJlWEtvRFBRMmx1UmhwVEpkcFNHZ3NkMzRQUWsxa3kvT0lP?=
 =?utf-8?B?Mm43ZVp6b1VGUHM1c1cyUFNvck5VMndmVDcwWkJEcS9mS0JVcHk3NWdTMTdS?=
 =?utf-8?B?MmVBVko4NXR3cE0vN0NKNTRKUEFWRWhqWUROakFXOUZJZEo1allPT2Zoa29H?=
 =?utf-8?B?eS9BMDVSMXhYZVlqYUNkQSttVjZBL0MzS3hicDM3WHJ5V3BOemRzZ1gwVkRI?=
 =?utf-8?B?Ymg4NXVGK25ibW9yMTVSbzlJRWI5UU1WcHRUZzVoU2l4QTIyYXpBM0pGTzVZ?=
 =?utf-8?B?Z1RhdU9SVHgxUnN3czJsOGc2L2tXV3g2TGpjSEQwV1JMVGNqVFlQV1lWaUgz?=
 =?utf-8?B?OGVkT0xBUlVxTHZXc1Y5Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjlzYjJRQ2RSZnJKT3pKcmtyVXloak1Rc2dtZjBKcDU1T0Ftd1ZveERFeVJm?=
 =?utf-8?B?TVo0V1A3K0FIK3U4MjBjWWhjL2NJajZlRCtIWnE5NG40dUFZMDg5dnloS0wx?=
 =?utf-8?B?aFNUNlkxWTdoYmd1andmYnZSTlNLaDNhc2ZCblc3VzJoZ2xWbEpHNmRra0ZB?=
 =?utf-8?B?ZDYrZlVoN2FxZnlTTXpwb2pTdVR0NjVSTVhtL2xWdlpZTllyR0R6OHdEWVE2?=
 =?utf-8?B?bnk3TCtXQ2xnZWFZSUFyWVNOY240TkhmNUUxK3dpbVBNYTAyTXpSb3o5Yjll?=
 =?utf-8?B?emU3VWNkMnZCODFHRWNWTXNpT0hDd1FJNlhJS0l5SUJtQm9tUzFvQnFNM0Np?=
 =?utf-8?B?aHdGQUVqeU5tbk4xaHBvQlV0TGRXNDd0d1FrSFlBUmR6QVhoOGhGcnY3L2hJ?=
 =?utf-8?B?THViMldGM3VyODR0ek4vTnlXK0p5R1AvL21tN1hQQWlHaXlYRzZzNTVzZVJp?=
 =?utf-8?B?T3NGWFUrdU1rZkNqNGxOVWVldTdBYXN6UzY0RjVPOWlPLzZtNmxXTTRzMDRz?=
 =?utf-8?B?K2hjUGx3dkwrUEFqWlRDQ0dwam5GNDRFaDVBalBLamJoQ0tZQkdkYzVYVmNy?=
 =?utf-8?B?czF5Q0h1RWtHTEQ4cllEOGdZVlRMWCt0SWREMXVYSElmNGU1SUFrREY3bGh6?=
 =?utf-8?B?VmtLQnBUalBKbDlkMWFZVEpNWkloSzcyQnQxd0hKb0FPN0dEWTBycXBBOCtE?=
 =?utf-8?B?MXVxWFhEUVVXTWRoRzBtQVp5WDZYVkxZbjNRemhMa0NIV1RTNktCanRjeWR0?=
 =?utf-8?B?dUk1SlJtdnpWMytUTWUyaC9VVlhNNGV0ZGxSaVluczR3UjhhcVRKYTh5T1la?=
 =?utf-8?B?TzRpSDNMdFB2TE1xU1o4eTZPWWp0elhwUFc3RFNIOFoxTnNyTi9Ma2VkT0lL?=
 =?utf-8?B?cXhEU0I1SnJXV2Y4M3hSS3JtQ3Uwd1c4UVFqMTAyNzZKZ1hJemJ1Qm1PUUtZ?=
 =?utf-8?B?dEtYcGs0S1R2dHpsMnFyTGQ2VmZ4MERkVnF2bGhpNEdVdHNnc1R3cmVvaWlP?=
 =?utf-8?B?UFFlNUhFUmVBTTlyWlpwNnZLTjdVNTZpbzZiRUFwNStRSkRaTXYyc0JZMUlt?=
 =?utf-8?B?dDN6MXRtZWJIMlZSSWwxdlYvTm9hUjIyRlFSQXZWTnR5dXBONWRKMFJHY3c1?=
 =?utf-8?B?ODBvS0RkZkFCKzM2M2tQWkdqdXlrNzB2WkNqU0VDMFZtRUdqVHBiMzNzMGZ4?=
 =?utf-8?B?QUpPZTVZdjQzS2dZWDRXRmhKNmlCYlk3eTJVUTZQdjE2bGZQTXptTlBKdFlr?=
 =?utf-8?B?RUU2REx4RE9DNXFEelp4K2dPRWh3R01WU0Z5aWkrTW01d296QURFMi9jQlAz?=
 =?utf-8?B?cllMVUYrV1dvalRtTDlZZmhVZGNCcUYyY2hITzRQOU1HVCswL2c3ZzA4WDBi?=
 =?utf-8?B?NTZTRmFKSmlOTGxLemFMUU5PWERWc3U5bkNDZnZ6YzFBZnUzYTQ3VjZHZHB2?=
 =?utf-8?B?NkRBUEtwTXBCWk9XMzI2Z0p0V2hYSFkycUdZaWVYSHhoY2dMMVlCY1NzeitE?=
 =?utf-8?B?RmZ0V3UvNkU2aXlGdEZiZ04wdUM4N01KeEFGTS9Wc0w4WnB5WkhqK0N4Y21p?=
 =?utf-8?B?QWdTRmg2VDdlM3hLZUpTZERVSlM0bm9SZEx1NjY5M3luNWcvS2dUTThyMkxV?=
 =?utf-8?B?dVlPYlJUUi9qLzl6VE1QMXI3MGlJLzRxd1ZVT0ZyUm4yRlpLYmg1WUlSZkVZ?=
 =?utf-8?B?MGg0UXdQR2ViYnAvSnBrU3k3OStzRUJ2RS9SeC9OOUNvN2xBdGFCdnA1aTU3?=
 =?utf-8?B?bHZFMmhkQzBSWk5sQktYV2lKY3dONEtFcUJUVG52clVTN2NFbGI2RkwyZUly?=
 =?utf-8?B?SDFiVWd1SXJ5QkZXbHlINThKaXlrWUlkYmNROU5vVW5YL3g4cXBEOFRuOTl2?=
 =?utf-8?B?SjVGMVJnRGdBempYYzBybkhaNThXcXpqbzRJbnVNT2c0RWhMYzk2YjBNUktS?=
 =?utf-8?B?bTd3NVh1L1lVN3pRN3lBUXI1VWJjNnFKTnl6VGdLaE05amJJT1cweWk1ZTNa?=
 =?utf-8?B?dExhU3dsMVBvOUtUVWkwYktheEdWVnRtTmVOdHZ2bmZEWFNuZERJNEJkbUE2?=
 =?utf-8?B?dzFNT3R3bGRYZGwvNmNSU1d6dTIwQlF4YjJjbmRnbDVSKzcvdzU3MEpCTDlL?=
 =?utf-8?Q?AfPIQnzf+wnMT0TxjQsjg3PYY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddab165-4410-4e42-c21e-08dcd60b7dd7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 04:53:23.6843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcmK5pSiBuSsIN7pzFchkLlV4hSJoY+B9s0bSAYdgGYXSpzNSQv0JyoMezzZj89SC/FYHgTtGYMQrIh2UIXQSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4448



On 9/13/2024 8:51 PM, Tom Lendacky wrote:
> On 7/31/24 10:08, Nikunj A Dadhania wrote:

>> @@ -88,6 +88,14 @@ enum cc_attr {
>>  	 * enabled to run SEV-SNP guests.
>>  	 */
>>  	CC_ATTR_HOST_SEV_SNP,
>> +
>> +	/**
>> +	 * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
>> +	 *
>> +	 * The platform/OS is running as a guest/virtual machine and actively
>> +	 * using AMD SEV-SNP Secure TSC feature.
>> +	 */
>> +	CC_ATTR_GUEST_SECURE_TSC,
> 
> If this is specifically used for the AMD feature, as opposed to a generic
> "does your system have a secure TSC", then it should probably be
> CC_ATTR_GUEST_SNP_SECURE_TSC or CC_ATTR_GUEST_SEV_SNP_SECURE_TSC.

Sure, let me rename it to CC_ATTR_GUEST_SNP_SECURE_TSC.

Regards
Nikunj

