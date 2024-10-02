Return-Path: <kvm+bounces-27826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B22EE98E567
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34A4E1F21EA7
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 21:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F1421733C;
	Wed,  2 Oct 2024 21:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fbQJzCt6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30183216A32;
	Wed,  2 Oct 2024 21:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727905244; cv=fail; b=qUqjR817638gWzfvxDlbDvK31DFt36H//cO92+ecU+dkox7eUGmkbFLOM7vQC13cJjQTfLvHXuBCc/Q6npy9qehk/7C8aDDTbN2cd9Yt5uKW9es9BXvCD5zBxPxdvoQK7XWqMlaL9OvLzBCn1Ori6wy3o6gh19aJDEJ/H4i7umc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727905244; c=relaxed/simple;
	bh=huAPC9cYCu4YPpTE/jq3Ij57pSoeXhZEHHUGlr1udHA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AFmIpcMLZ5Fd3O/FRbiujiGIuhh9vxNL0K69rL4R3jnTj1CCs5ND3brmoQw7iLIyXFMrMT3WgMfIdCeVE//QVG6tkeZDSSZH5OaBriLUbtgXZwo8BUEuSNCbt8GgbiNGmFQHTNRArDxsP125SNsogoOSny/hu2yzJCRAGnykGMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fbQJzCt6; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dEM/Nm0ibnBOZBJE3RoteBbGqpG5e9Cz5eX5hyVOcBOBJdZjuSBd8SFvd9pDF+Xw1zp+hL3+h4qaxf+VWz9kHeWWosnH9vMv7lAI8Ee3QxlVU0zXcIpOG1+rxNUKubOktZEuEoohUUXB9m0rPyLhJPSu/b7Nd9a7ITlptUBg/hp33GnU1YVhsP0BwJB6ivSNPn+oPM96zstQfm2uOyvH6nd/kKKl17qKAcn4UW2slsuSV1WgdqlVAOhR0TIYc8hGGpa9TcfM/G47zvwajxHJMCQz+ZMc7lh3m2TLtuGG1s6NBu5iwYBNb9t2pdnckB/S0xTtzBExilHBkBXUM917fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uU55gwAhSyXywK5KNMVfNN1CLov2s63ad5sl+md7A5U=;
 b=qekr2fJKxrnpKzzdnP7KdmFri+c70ZuyWjSZhU3gEG1ipkwTek+xcaMzITd/JIY+4h9eGnMIo7jwoEqyyc03T1Mc4nnhHMpIx1HWAlmF4QF5aXRIwKsnasM1uV8/OSuCOZ0n93Si9wmyW7sy+5fe4PyBDTfRs4U+sbEJO9hD3F/V5Hi202eGkU+wF0LTHIaZMVesbAdgFR3+QJiD99+n1MeWEEGCp8OC62/7W614U05WajoczKwsGqdWuiogynHBGJvNBStafC3tVpFzHwf8s/sALTsfLZ3nUAkbkAeC45uKtDkY/IpRlv7qBUzU41BYQSyem1etmZPYhVZ9On2Arw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uU55gwAhSyXywK5KNMVfNN1CLov2s63ad5sl+md7A5U=;
 b=fbQJzCt6Vp95zLhNF58YhkBRSpBTiodU9BU4ZRd7x8kD2qDwPiOoQk9ci/Z6co/fDQ0mKYs/BUJT5leKWZq/FN3EValHGqL3N7PvCVsGNXTjZGGJFBuu0W7IuOYd74yCaiR6nlIZvQp8Ef/94HflYO5DAYrZosFx/lVgwoBeboc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 21:40:40 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8005.026; Wed, 2 Oct 2024
 21:40:40 +0000
Message-ID: <c80e8b87-cd39-4d6f-a170-19e66d83c273@amd.com>
Date: Wed, 2 Oct 2024 16:40:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <0f225b9d547694cc473ec14d90d1a821845534c3.1726602374.git.ashish.kalra@amd.com>
 <3b2e58da-33da-1b40-2599-e7992e1674c7@amd.com>
 <5ac11cd9-dfd5-499f-b232-5c9d0ed485eb@amd.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <5ac11cd9-dfd5-499f-b232-5c9d0ed485eb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:806:130::31) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aec5aab-59f7-4fd7-aa5c-08dce32adc59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1FWdysyV215cVBVUDRnOGRvbkZwM1B3dXc2VnBMRlIxMVdac2ZOSlVDODVK?=
 =?utf-8?B?VDB5ODRZMUNqZzZlUHYwOGFtTEhkQ0RWWFJHK0hEcGdlMTJRRHVMUFVwUDJr?=
 =?utf-8?B?Nm8yZVh4MXF3NkI1RmVWSzJTUFhuZityVkIzUENuNkRKYk9rZnZXUGtLWGp0?=
 =?utf-8?B?U3h0bHdtK3FkakZQdElzbGdmZlpoY1QrOFgvVE1JS2JTSDVoRHIwUDA5WXEv?=
 =?utf-8?B?RU1IY3BReFVaVzYzN2Z2OW9pcjU0OEJ0SUsyWXFJZkdYWHJGNmNrWERKbXZQ?=
 =?utf-8?B?ZzA5WlR4dVZWK0hOVkJhazBMaXFaQkVYY1NCeWlVbnVRcThkWkRzOHJobldr?=
 =?utf-8?B?eHZMUVZROG1iRzM1NncxQUdGdmhrbXYzTlQybEIwQlNwampIaWZCanZ3Yk0z?=
 =?utf-8?B?b2wrbDBSaElEZ1RManZwZ2wrYldvejMyV2FIYkJmUks5Q2FvT1RSdlVKM3RJ?=
 =?utf-8?B?Tjh1L3dLWVVjT0Y4MWhpUE0ycit0eWRjaEZ5UFB1dHpyNkxOdlJmcCtCaXJz?=
 =?utf-8?B?VVoxbmpPK1hIdU1IV0gyYURKTExrajZGY2NudkpMRHlTaysvSEN6VzN2eTR0?=
 =?utf-8?B?bzhoc3IyN2xsTG5pU1U2RDdKVW1MRjh0U09uYlREZUprK2FkQXYxSDhFL3lW?=
 =?utf-8?B?S3YvUHp5ZThFNXFTSUFwZTE0bU5PdU9JWTFFVkxNeE91cVJiZ1pXRmVremlT?=
 =?utf-8?B?bUluWnhnTGQ0c1M3a2k4WEExV0gwV1ZVUVJoME9DcXRibFhvaVE0Q0pMS2VT?=
 =?utf-8?B?d08wWkNIcDNMSXFxMTlSZFl6ME5UTDBGNTMrK01hSW9nK2RJMUVMMlRyR3U1?=
 =?utf-8?B?dkszM1ZoUWtVMXNMUUtZbDRjSUR0MUwwMkN5aGNveE1VMHZIakRtUG50R2U1?=
 =?utf-8?B?OWVXczgwdXJqQVVJTHhmYkpFOTBBOTJDWDlMT2NNN08xMnN6azdtcU9LOENk?=
 =?utf-8?B?cEZMdU1UTExoUkhweE1xVExFMHRiTVZkL0hZeVFzcWJqc1hlTjJ4Lzh5bHpX?=
 =?utf-8?B?R3F1WFhMdUpvK0N0K25pSkFicFFGajVDWEgrT09sZnprV0VHY3B6T1UrT1Iz?=
 =?utf-8?B?RDVWYjQrY2FORFEzOWZHay9Qdnc5YjA2U0xnWUtHZFVNUFl2MEt4YXd0UE85?=
 =?utf-8?B?TWtNTjlBSkxMTUlmRWoxbEozUjdPMVUrN1lmSFRKbXBjMmhTQU9iMUI4ajlw?=
 =?utf-8?B?ak5tcHVCUEZnc3o0YzFMaTBMYm5JVmFmS3dGNXUyVGdmUDA1N1JVSGJ0bi9K?=
 =?utf-8?B?bnd2Kzd3VHBVeVZMWlYvUnF5VGdQNWFESG1jY0dxcFI0UWhEblZnVWZVcXZ4?=
 =?utf-8?B?WElSVVZZSHNnUURHZ3ArTDNLSGFHTkV4RzFTZUc5RkJodXpxdEZRQktJMkhP?=
 =?utf-8?B?MDlhYUhPM3cwWXZmRzVhd0pDb005VmJ5NUNWTkg2TTFEN1IvT0F4ZzZPY3NL?=
 =?utf-8?B?UjZ6UzVHS2YxaTdNMzNGenJJU3ZYLzVrYUZzNTdyVGJtbmpwNmZ1MTRaMmdP?=
 =?utf-8?B?ZGswenRidWdiRk14NkpzRWJjL3VFM0RCRnJMYUNiQXpHdGhvcHhrQ1hFUGI2?=
 =?utf-8?B?dVUxZCtEamQyQmhoUDFWMDY3TGVnaUpZS0tFa0FlWkdaWlBqdzF1T0p5QTV5?=
 =?utf-8?B?dWlDZ0dKbHJzeXdrYWloSjJCSXNzZ2dkYmw3S3ppc1FGWTZyU3poL0kxQ3pC?=
 =?utf-8?B?b3ltK1g3WS85STJHUXJ1QzM2eFpVSkpkaUllRmkvVmt4aDMwOXZpUUNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEFWcm9QR2krWlpadC9rc3l1OGt6TktNU1BwMkc5WG9LM0dTcVR0NDNrYnM5?=
 =?utf-8?B?NmtIS2JRcjRreDhmMFVzOUIzSUxKSzRiVXNmZndjVHFMRkFkN2tjUkYwdnJB?=
 =?utf-8?B?bFZCc05DUUJtQXdPVS9RTGxObjBoUUJ5MzFXblNzSjNDd20wNUduMG1Hai9C?=
 =?utf-8?B?UXgrU0F5MkNpWXkySFlxSi9aeER1WkN5aXBibUpTTlBFSlhOVmFhNUZPeHov?=
 =?utf-8?B?UzdnYzl4ek4rT2lka0h4TmFBNXJDbnZYMCtLVEprNFMweXJjb2hIY2gxVGVr?=
 =?utf-8?B?ZGdOaWpDWi9WTUdHWCtXUGhIcnVJQ25xSXdrWWtnaThCb1ZtdmIydWY5NHhr?=
 =?utf-8?B?U0pZYys2K1ZtdklpSjJhdHdDS3VaTHM5NFM2NUFHT0c2L1BucHo3dzBPbEI0?=
 =?utf-8?B?MjNEalFKejlQMVpUZXVFZjNnbEhsQk9YRk1QRzBYbVVsYmRwcHRoZ2wySUc3?=
 =?utf-8?B?dnh4UlczM2RwQTBlbFFwMndQcC8rNTg3QzhKNkpJcXF1aXNVZXZlWWhIeVF1?=
 =?utf-8?B?Z0RmYmRnS3k4a0ozbEtaME1VZmxnWHRKSDlPenl4UXJ3MktIMEtnM2lzTkJm?=
 =?utf-8?B?T1RHVkZOdkJJOGRzZllOTmdMQzRZSUJudU9pVXFzUVBLdjEyK2hiUGFiYlZy?=
 =?utf-8?B?MWQ1bTNhb2RjK21hbWoycmZYc2xvV0pLT3I5RHY0ZkJQdGhTdTYyaUorN2k0?=
 =?utf-8?B?YlVpcjJZalMrWjNLbk1La1VaamxPRU9NZjBNVHhnQ0NDR1A4dTljbzVWd3dO?=
 =?utf-8?B?ZFdFOGhIMFdWU2tTZzlmdCtEdEN4WjlEMElyRWM3MWlTc1d2L0F1OUZEOEhH?=
 =?utf-8?B?R3VpMXV3SjVodmx0Uk1nZHY2b0hpSHhsaGlDOGtBd1RhdTBHN3NQTE93MDdo?=
 =?utf-8?B?VmxiOGI3bkY3a2FuNGJmdk0rN0NybDVPcjdWdUdxLzluYVE2alQ4amJpZUZQ?=
 =?utf-8?B?VzB6NVZPZjEwWWxucUs0TVpjcVFrREFoeWlMQk00TnVsSW9KRTZESVpTeStl?=
 =?utf-8?B?dU9uTE5uaGZlbkdKbGI5OWZJaXNvK0hKaElmR1dCQ2JxdkNKQjVvbVBBME5B?=
 =?utf-8?B?K1hYdDl6cU54Y1NlSmtZZHlwZ2hDMkhjZUVBWStJVmE5VEVTeUtSWkcwOGhp?=
 =?utf-8?B?SGhteUdmMGNzMmZETGNGVFNlbGRTNEZrVyt1NjlMVGhydHNwblNYZTNHVE82?=
 =?utf-8?B?NzhLNUVFMlVUMGREUmlJWExRRU5GWUpHK1hZSnRUcUZycXREd21ZZHNJMzdh?=
 =?utf-8?B?QXBPbnU1R2FqN3RGa0xCeU5vN2IrL2l0aStLeUhRbGNCRS9Eem1hc0g1L2h3?=
 =?utf-8?B?RWNJNGtLZXFrdVZ4TjJFUVhKYkNyZWlhRk9iNWxiVW1vQmJqaU1YbkJReUNW?=
 =?utf-8?B?bnBuc2lNNFdiMFM5OFJNeHFrZElOUFV2VXlwQzNLdGs4MXczY1VFN3VhZjhw?=
 =?utf-8?B?YlF2cnExU2tHOEQ2MnBCcTY2UXh6U2ZSZzUxRHpCb2tOVFd5WW5rSWJwMDJR?=
 =?utf-8?B?b3NEc0dwbTZJR1lVN0pad25NVlJtbVphUVBFclJ6TVVxZzNpMmVnRjh6UzZN?=
 =?utf-8?B?MUhWZWZBVUJmUUM3Wk1janV1eXZ4Um1GNHJMMmpsZnhpdzBHZXNDN2YyUTFE?=
 =?utf-8?B?akdZRm1EOCt2R09VNHJoL1hSL2lNdTBsWUY0WnRzVTljdmJpWHhvTkhZeFRF?=
 =?utf-8?B?OXdGMDFpWnQ5TzR2Q2RYbzc1MHBkYkgwVW1vU0Nma29odXBxUGoxT01LLytT?=
 =?utf-8?B?dVdDQXVWYkIzNkszR0l4a2ZESjlIYkEzVzBzM21IU09NYk1TVFZ0K3ZsOTFk?=
 =?utf-8?B?Ym9zZEo4azBjOEZSR0VXS3A2TkE5NGg3TkFCYUJobTZEaVNESmxxcmZrUnVt?=
 =?utf-8?B?S1k4OU14ZFR1NHFFNGh1R3VTMERIaWZ1ekx1MTlmeituY3cvRVlPMzZkdEwx?=
 =?utf-8?B?RUpFK05rV1ZWWnF6ay8wS3UzWnM5bThYYlZzdTJ1c1dKUTFrYjhJLzNqZmIx?=
 =?utf-8?B?ZE1FV014YytvV0lwTmVJdHc5dmRNTUNOVzVobk12UzJIKzNVUlpKd2svVTZZ?=
 =?utf-8?B?aEQ0dWw0TkZCZ0pIa0prcityckVweWJ2Q25pS0pXWmR6cXFCYUduUkE4bS9E?=
 =?utf-8?Q?rHWPABNmHDZjCLhnMpn4/ZzGO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aec5aab-59f7-4fd7-aa5c-08dce32adc59
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 21:40:40.6420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5Ogy/Liov6Na/9zL0SBTeoVuoB+dLeX0Oy901pilLV7Y5KHVtHNGc25iCFoOSj2yCirpu1nfdhsvsfc7ABhLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452

Hello Tom,

On 10/2/2024 4:19 PM, Tom Lendacky wrote:
> On 10/2/24 16:18, Tom Lendacky wrote:
>> On 9/17/24 15:16, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> The FEATURE_INFO command provides host and guests a programmatic means
>>> to learn about the supported features of the currently loaded firmware.
>>> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
>>> Instead of using the CPUID instruction to retrieve Fn8000_0024,
>>> software can use FEATURE_INFO.
>>>
>>> Host/Hypervisor would use the FEATURE_INFO command, while guests would
>>> actually issue the CPUID instruction.
>>>
>>> The hypervisor can provide Fn8000_0024 values to the guest via the CPUID
>>> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
>>> the hypervisor can filter Fn8000_0024. The firmware will examine
>>> Fn8000_0024 and apply its CPUID policy.
>>>
>>> During CCP module initialization, after firmware update, the SNP
>>> platform status and feature information from CPUID 0x8000_0024,
>>> sub-function 0, are cached in the sev_device structure.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
>>>  drivers/crypto/ccp/sev-dev.h |  3 +++
>>>  include/linux/psp-sev.h      | 29 ++++++++++++++++++++++
>>>  3 files changed, 79 insertions(+)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index af018afd9cd7..564daf748293 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>>>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>>> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
>>>  	default:				return 0;
>>>  	}
>>>  
>>> @@ -1063,6 +1064,50 @@ static void snp_set_hsave_pa(void *arg)
>>>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>>>  }
>>>  
>>> +static void snp_get_platform_data(void)
>>> +{
>>> +	struct sev_device *sev = psp_master->sev_data;
>>> +	struct sev_data_snp_feature_info snp_feat_info;
>>> +	struct snp_feature_info *feat_info;
>>> +	struct sev_data_snp_addr buf;
>>> +	int error = 0, rc;
>>> +
>>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>> +		return;
>>> +
>>> +	/*
>>> +	 * The output buffer must be firmware page if SEV-SNP is
>>> +	 * initialized.
>> This comment is a little confusing relative to the "if" check that is
>> performed. Add some more detail about what this check is for.
>>
>> But... would this ever need to be called after SNP_INIT? Would we want
>> to call this again after, say, a DOWNLOAD_FIRMWARE command?
> Although, as I hit send I realized that we only do DOWNLOAD_FIRMWARE
> before SNP is initialized (currently).

We do have DOWNLOAD_FIRMWARE_EX support coming up which can/will happen after SNP_INIT, but there we can still use SEV's PLATFORM_DATA command to get (updated) SEV/SNP firmware version.

Thanks, Ashish

>
> Thanks,
> Tom
>
>> Thanks,
>> Tom
>>
>>> +	 */
>>> +	if (sev->snp_initialized)
>>> +		return;
>>> +
>>> +	buf.address = __psp_pa(&sev->snp_plat_status);
>>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);
>>> +
>>> +	/*
>>> +	 * Do feature discovery of the currently loaded firmware,
>>> +	 * and cache feature information from CPUID 0x8000_0024,
>>> +	 * sub-function 0.
>>> +	 */
>>> +	if (!rc && sev->snp_plat_status.feature_info) {
>>> +		/*
>>> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
>>> +		 * command to handle any alignment and page boundary check
>>> +		 * requirements.
>>> +		 */
>>> +		feat_info = kzalloc(sizeof(*feat_info), GFP_KERNEL);
>>> +		snp_feat_info.length = sizeof(snp_feat_info);
>>> +		snp_feat_info.ecx_in = 0;
>>> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>>> +
>>> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
>>> +		if (!rc)
>>> +			sev->feat_info = *feat_info;
>>> +		kfree(feat_info);
>>> +	}
>>> +}
>>> +
>>>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>>  {
>>>  	struct sev_data_range_list *range_list = arg;
>>> @@ -2415,6 +2460,8 @@ void sev_pci_init(void)
>>>  			 api_major, api_minor, build,
>>>  			 sev->api_major, sev->api_minor, sev->build);
>>>  
>>> +	snp_get_platform_data();
>>> +
>>>  	/* Initialize the platform */
>>>  	args.probe = true;
>>>  	rc = sev_platform_init(&args);
>>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>>> index 3e4e5574e88a..1c1a51e52d2b 100644
>>> --- a/drivers/crypto/ccp/sev-dev.h
>>> +++ b/drivers/crypto/ccp/sev-dev.h
>>> @@ -57,6 +57,9 @@ struct sev_device {
>>>  	bool cmd_buf_backup_active;
>>>  
>>>  	bool snp_initialized;
>>> +
>>> +	struct sev_user_data_snp_status snp_plat_status;
>>> +	struct snp_feature_info feat_info;
>>>  };
>>>  
>>>  int sev_dev_init(struct psp_device *psp);
>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>> index 903ddfea8585..6068a89839e1 100644
>>> --- a/include/linux/psp-sev.h
>>> +++ b/include/linux/psp-sev.h
>>> @@ -107,6 +107,7 @@ enum sev_cmd {
>>>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>>>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>>>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>>> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>>>  
>>>  	SEV_CMD_MAX,
>>>  };
>>> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>>>  	u32 len;
>>>  } __packed;
>>>  
>>> +/**
>>> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
>>> + *
>>> + * @length: len of the command buffer read by the PSP
>>> + * @ecx_in: subfunction index
>>> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
>>> + */
>>> +struct sev_data_snp_feature_info {
>>> +	u32 length;
>>> +	u32 ecx_in;
>>> +	u64 feature_info_paddr;
>>> +} __packed;
>>> +
>>> +/**
>>> + * struct feature_info - FEATURE_INFO structure
>>> + *
>>> + * @eax: output of SNP_FEATURE_INFO command
>>> + * @ebx: output of SNP_FEATURE_INFO command
>>> + * @ecx: output of SNP_FEATURE_INFO command
>>> + * #edx: output of SNP_FEATURE_INFO command
>>> + */
>>> +struct snp_feature_info {
>>> +	u32 eax;
>>> +	u32 ebx;
>>> +	u32 ecx;
>>> +	u32 edx;
>>> +} __packed;
>>> +
>>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>  
>>>  /**

