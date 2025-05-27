Return-Path: <kvm+bounces-47825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1CEAC5B91
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 22:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3CE87A6EC9
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E063A20A5F3;
	Tue, 27 May 2025 20:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wvi4V7qL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4632712B93;
	Tue, 27 May 2025 20:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748378847; cv=fail; b=HfptZU3P22/LJzBDjT7PeDKO0x5N5AGJrKom/+/NYhf4f6oTu8JC0eaNiHBHPT6Kw6GLayaYq553esl2G+tjbVSwarVkYsr84nY7kPIK0TAkFmQCcJy8gmWgZ9c8p2So+uOU5KwvkBXit7BDEzAGVnqCM5XvWkdnDaKloydYOho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748378847; c=relaxed/simple;
	bh=RllutO9Jv1b81TYFq2fGLiOtdIzkiPqyWinkhZHgweM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mUiI1b1az4xS02b51l2e5t23D6AbCXTjaJAw5I8uiQl+U3e1zOGX1rkL7j8T7ga3Ss9U+jiEiUwUadFfzqvnGSv8YhFc2MCUlPVWZFy2lFRaG1IRazPnXn9Gxuvn24Msg8pqPK57+IkwvT/tWnkL60S53Nx3TJl1tnYxty6lybo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wvi4V7qL; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kr4V3DnJ9PO1r2ltzy5BBvmr2s7RV8PD4FScFUW1JOwiA3PUaNKu7nqjHJCzEac3kRY+5L0RRcycj7sTvbeTNomqy53THRNOd8OU3cZ1MFVTYlKsSDwS90gicvKjkd9kszD7oiFwgV/0RJUm/Uf1sFrTNhn4uEcV5OS6BJjL58rLwzFbSYubRfoA1mVZ9gKnr4d0J5qoJTOMHwdErbs8VLNWKE4vDftI7oILhZED4BHlxHkk0YThgEA1R8eSty0Yny/hARnQzLkVmw3OCu2p53vchfWrj80P5X1bSUHk8ZDw8HcRt3Xv/1I2z5pMjT0grGVuN9XZkZYuO11mKJMlUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpNfr8TGc2/eWvDBGB7U6UGFhWDOPzixDDns9x9IsZE=;
 b=VFXlEYF72zW1ql1LuElGU7EnjtqhHBjTP4jCq29dYv3rFa9lHtKiM/kuH+UU4RPVSs2Rj0bf7z5VpQhtv0k9eyPgOIdhH2p3awALChAC1RSSV/SjwYyffeeUFjshH0IWySt3/ybd2Dqn45XQbJV8pn9C6hT0npG9gkOOrTndcFfdbq3IOT2tduEeXLDANCn6dSozJn/nEx5ba385f3iSFjRXqoYDnNUNZVTsT46AzfEqBHczMKCu3iJwRW1SawWqU/L10TPaJECPMuut8TsyKqhl2Ie2GwP3kvufr2DuPVO3AR54D2eJ8OT+KziltjlRxOt3XK/EStk6icctUABuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpNfr8TGc2/eWvDBGB7U6UGFhWDOPzixDDns9x9IsZE=;
 b=wvi4V7qLWaNRjlMlGylD53m3QUfztMwKSNeryAwc0wgTTWQpB4dqPvffcmi2VdrFh4DaX2E9qXpb79LNZtyjQ0+VRPvRk4JQT+kXjWKpygdYUTDjHgp0u3w2G0tWQJlVAFi//z7KX8V6mLsW9WDkRBaXcaEX4Pdqfae0cmTwGPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Tue, 27 May
 2025 20:47:22 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 20:47:22 +0000
Message-ID: <700f57f7-7a36-444c-baae-b5c2f9f5da18@amd.com>
Date: Tue, 27 May 2025 15:47:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] Add SEV-SNP CipherTextHiding feature support
To: Kim Phillips <kim.phillips@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <ed35ce98-8f0a-4a64-b847-94d388da3b5c@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ed35ce98-8f0a-4a64-b847-94d388da3b5c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:5:177::37) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: 52fd7fb1-35e8-4c1d-16a2-08dd9d5fada7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SENJNnZnOUNrTUl5Z3kxdXlNQWo2V05VQ2x5VnNscHFqcXBLSHZZOXBVblhP?=
 =?utf-8?B?bytneVhJUmdVNGRtekxjWWVjbEsxdHJvd24reTVlcEFrV2dDYkFKVm92MnFB?=
 =?utf-8?B?eUtsWG51V01wcnk4ZUh1cG01TTYwVHJ6UVd6ZFhPZVpUc1BrWi8vd00xQ21X?=
 =?utf-8?B?S0xNYzZGSGR1RmZiRlpCTWVUYjNhZDVnNGlYZDdiMUYzWVdnT2hGVkdyOUEz?=
 =?utf-8?B?cjNvM0ttTVNUYnpvaEpOVWxtZ0lOSGdsNGp6a3VsTWhsMThiRGxIWWNiY2J3?=
 =?utf-8?B?WE55SVBjVTFFcW8wVldQd2RWaVFublhaYWxEblpPVVp3czdmUU9WQWlUMTJB?=
 =?utf-8?B?Ui91TzBCUEtTY0lkUWxOYi9SSEtTYTZKVTVLVTg4QW1IcUVIcnh5T2w5cFVj?=
 =?utf-8?B?bjJkbW5DZ2tPSzc4Y3NqQ2NtU245V1FlZzJ5R1d3ajRxK0NjWXRMVzFqZDgx?=
 =?utf-8?B?NEdnRDU5ZTRGelI4TGhFbjdDeUg5TW9yU0sxRUtCdmRETDhFb0dPK3dRYVJH?=
 =?utf-8?B?SkRicjA3T01VNTZXcXV3a2ROeUFpQkJwcnUrQ05yWmZ1RGgxWW5jL1dIb0dR?=
 =?utf-8?B?NHlwY1NpUFVHQW5JdDhFb1hPZWY0Mzk3NzBvWUJLbFFXN3hJM3NzYmRZb0RL?=
 =?utf-8?B?M3FFZVBwa0tSK2RlY0U5d0UvOUFhVDR0dDlaYWpKNFFJcW1wSm9tU1JETzBZ?=
 =?utf-8?B?Ui9KTjBYVDFyQXpxUlZnL2FZWlhqcFZDRjRRbHFZQXQ2NmFMdGlUSTJoUzJS?=
 =?utf-8?B?MWttY2ZlVFQ3OWJtck9YL2hhZUJIRUF0VjZZZXVlVVJGZlAzUG8xVDJmZHpW?=
 =?utf-8?B?d3R5TXFrY1V5Szd2MTVLQnBPL1dLUEpaalV2aDlsbjk2NFB1aVlzZU9oNmkx?=
 =?utf-8?B?L0hZNDBwbjJlYmVFcmllMWV5M21XYnJ1b1R1WDJkZkg0SmNQSFZIeU5FVVpi?=
 =?utf-8?B?c0hZSWc2WXZ1emh3V3NRTW5kSm1ZKzFNU25iRlRGbzY3Qkp1a2JuRUJrZ3Rj?=
 =?utf-8?B?ZEphendpRUpvM2d0SjYrSXhOaHFlRC9WZFQzRVcrbVpGc0E4UGVXR2RtUXRM?=
 =?utf-8?B?RW1lcU9YMWtqMmlGaU5VNkFmblFpUFg2NzRLTnVSWk9jN1pwL04zYzlXRk5n?=
 =?utf-8?B?SFEzdTk5cXF3L1MwNWRKZTYrZ0ZJd1pWYTR2VnpQdWxIeE9mQWFvYjJ4aG9J?=
 =?utf-8?B?d0JaN1psbmp4emcrUEdoSldzVkQwREhXT24wSkk2akRCaW51c1AweHY3amdR?=
 =?utf-8?B?NHIzb05JMlB6UC9WbWozSG14eCthVVlVb08zbU5PWUQydVUyUFhJY3dlZmlv?=
 =?utf-8?B?dUxRVDArSENCNVYyQ3oxYmJmR2N1WUJwZFpjOG9QSFdEb1VhZUIwZmhubCtV?=
 =?utf-8?B?SS9wNHRmRVlrVjJjR3dqSzlma2hZbXV0SE5JV1k0czBKREtXUC9HcHFYczVP?=
 =?utf-8?B?K2xDN0xVbVhZYnhrejVDSldQaitIYU9yOUNqREszM2c3clVMeEFKWEVXTnBE?=
 =?utf-8?B?RnByVkM2aDhRR0pOUENqbExkREZKekpRaG1kNWxGRDlsQ1BUcDEwaGs3VHdT?=
 =?utf-8?B?N3JtOGRFVDJRN0RBKzByamhJLzYwbmtlRTdKQ3EwdENGeUgycE9HVzBaWTdv?=
 =?utf-8?B?S290MXBnVjNzMW9POXF0VVJxMHhIajVYd1lrTWowWmdScnVpM3d2ZVhCQ2FK?=
 =?utf-8?B?c1pzVkZtdFVCZ1J1dmlQcmpWYmNTSGFuQWRtWHo0TVFTOG9ncnZQUWRRSWNh?=
 =?utf-8?B?SDRDeXZTbGE0cisxc201N0RjaE00U2ZiMk9td3lMSmR0SXFjWXJxem4xUG1z?=
 =?utf-8?B?N0c1SE80cENPL3B6djVRL2o2a1Vmam5GY0VKNGlSazlEUWdLVG9WQ3laVGR3?=
 =?utf-8?B?aTA3YUk3RnJRUExkUElGaGdVWGdDaVo5SXE0djhBOUExWkZjQWhxNmRoUGtr?=
 =?utf-8?Q?ci4bJ9P4jLQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3BUODlmSTBTT0I3cE5ySUdlSUNTZG4xZE9Va25Eelk5VURkMllLa2xVKzl6?=
 =?utf-8?B?MEF3SGQ4RTZ3VXBNdVdQU3VDaWZKYkpKZnppRDJ3cjlOUkdFYmhneStxWHlo?=
 =?utf-8?B?VHYxVDRhNmlTOXArWTVRYkIvT2NmalNrSXQydS9ZZFE3dzJzK1R3cjJmYVRP?=
 =?utf-8?B?Y1ZBWFNTSHRER0hYVVQvTFU5U3E3TU5iSExaUzU2UncyamVUOWRaSit4S2ZE?=
 =?utf-8?B?WDFwSlhFSDlVYkNROGIzL2ViQmREQkJCdTNuenNaU0hwd1dmVnhMSU0xQ1p1?=
 =?utf-8?B?OFJyUXpENmQ2cFlsc09mK0dpa1Uzam1UbjY1amVoVTFDSmRocjIrMjJPYktS?=
 =?utf-8?B?ajNaOUlqdk1EUUhnVmUwUzlYelN2emJpMFJnbWpIME4ycmh3V1lwSEpKUjZy?=
 =?utf-8?B?SnBEalc5TlZpZitvdHdwZlBTWEhiMUM2T1ZBNG5ZWjd4ckZncy9zb2VSU1p2?=
 =?utf-8?B?a1dmQVA5TFVvSDI3d2ZZeUNUa2hNZVdPcDhGeXo1QXg4TWtzcXNlZkZGZ3BS?=
 =?utf-8?B?eWNjbFg1R1E4cGNjVHk3UkJ0bndrQW4vZjlhUnlNY3h3S1ZmSm5mUjlhcHdD?=
 =?utf-8?B?WUx5VEhKTDQwVUo1aCs1Ujg4aTdodlhqUjRUTEhjeEg2aW84elRYcDl6K0tC?=
 =?utf-8?B?VlZ5aGVxM3NKTXZwVFVBN1Z6SkxYTGVIeVlTNFRVN1VFeWJOWDN2WVFuZTdW?=
 =?utf-8?B?eXNySWUrOTJRQWx1OUpIRUJJNXVFTHlSQzFoeUNYVW4rQXdHN3JzaGkvT1o5?=
 =?utf-8?B?cVBta055SWFFUk8zNHV4ckxkbktBK2ljT3NHY1haUUViNHB5ZHlzYnRxbk9q?=
 =?utf-8?B?aTR1d1NrS2V4NS9LSlNMYjBuYVhYaDd4Sld0c2lEQlp2SVF4N0QyV2Y2VUFK?=
 =?utf-8?B?QkhlY0ttVW9xUFRRUjBCdmtkWDdMSVZRM3R0QlJ5Mi8wNWRpeHlDZXZpZzNP?=
 =?utf-8?B?U0dBbnRDUndaNlNidTdRelZVNktNaFoxVEcyTERrSHM0VXFkdTNKa2xnQ1Ax?=
 =?utf-8?B?OHJWR2ovMDZrNlBkYWdRT2dZTlhiYUo4ZDdPbDQyY2ZtRHlEbjZUa0lSdXZl?=
 =?utf-8?B?bzhmMFdaTm9MZThhUnFmYXBzVzB2YmhLRjdIeGlyKzY1TXJIUzNwbU1DK0pJ?=
 =?utf-8?B?UTlaUWcxY0JpY21wTFRXZElrQ3pIbDUvbW10TnRERmZ0bHdianJ5N3czOGRE?=
 =?utf-8?B?SVJuQzRFWkhiWlBtMDJQSnNZYkNKcERVWUlpRzZsVGJxYjFWUEVQVzU0YXVz?=
 =?utf-8?B?R0xsYW1VMzZRSnRYRlNKbWVmVDVGVWZQVEZaNk84TWhXeUhZYjJTN0VVV0ZJ?=
 =?utf-8?B?U0s2azJKaG1GZ2ZWT1ErNHRSTGR0Ty9DMjBZSmZFNEd4ekJkbmxMc3o1Rk5P?=
 =?utf-8?B?SCtjN2ZobVlnWUtnMGQrZXgvdjBOSDdDMHB5YUwrTmFHL2UvbnN1Q0N0WjJs?=
 =?utf-8?B?eERBM0s3dnlwR2RUaW9YbEFjL1A2V3VUUG5Qdm5KakhVNFg1WE92RjBVZDV6?=
 =?utf-8?B?NzBsSzN0aDYrZkc1QjlBOVVDcUtGelhRUldiSHp4dDRBWE15aWt1eXVTQ0dW?=
 =?utf-8?B?R3hmQy81Yzh1SGN0NE93cWZ0cDdXR3AxSzZtb0pPQi9ISFh5QnNMVWg4OTFi?=
 =?utf-8?B?K0VOYk1OLzVoRlgycDdubVNFWmNHc0JoeDRSNVBQSkxtaU9lWWRqTkJIYmRy?=
 =?utf-8?B?THRIVHJLdEZuTmtQR05hbUxOYkh5UmZITVg3NkVoTzNaeEtORzd1QU1MTk1M?=
 =?utf-8?B?T3VHOU5DSC9iRVBLSFZTcHRmV3JsdUpzUDA4RmdMR0pPOXJQenNETTIwcWJF?=
 =?utf-8?B?bGI1Uzl3bVpDZUI5eWpablpYMG03QjhsT3BPaTFnTDRoem9URTczMENzcVQr?=
 =?utf-8?B?dklTYUIrMUQrZ3pRckprQWhUaENMMnU3TWRJQmtzWlhUTFA1UHRaL0lHWitF?=
 =?utf-8?B?VzMwS1hyMGw4SDR1SzU1Y0Eya3Z6R2JCVXVWZnR0WmhSQjhyZTRTQyt4cks4?=
 =?utf-8?B?Q0lUWmlpRHUwbmVJVlVBYlhscmJ3ZnRWQmRDZFVvSStGY1FnR2RZVGgzWG9z?=
 =?utf-8?B?SWFkV0FCUmMrMjgvZzNmQVBPd3ptYWN4SnJ6RTNQUnJ3TWdmeER3R1NVaDJj?=
 =?utf-8?Q?lrp5PXY2Fn5K9yzv3mf6FzM2u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fd7fb1-35e8-4c1d-16a2-08dd9d5fada7
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 20:47:21.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwTFTGkMJQ0d56li0+LaIYim4yCYGuzByr2i9+7A9z9iV7atbxMo13cBH4sUCFjosoiqD/NZS8sKCw9e+InTyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718

Hello Kim,

On 5/22/2025 9:56 AM, Kim Phillips wrote:
> Hi Ashish,
> 
> On 5/19/25 6:56 PM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding prevents host accesses from reading the ciphertext
>> of SNP guest private memory. Instead of reading ciphertext, the host
>> will see constant default values (0xff).
> If I apply this on top of next-20250522, I get the following stacktrace,
> i.e., this assertion failure:
> 
> static int sev_write_init_ex_file_if_required(int cmd_id)
> {
>         lockdep_assert_held(&sev_cmd_mutex);
> 
> Config attached.
> 
> Thanks,
> 
> Kim

The lockdep assertion is triggered as snp_get_platform_data() issues SNP_PLATFORM_STATUS and SNP_FEATURE_INFO commands without acquiring sev_cmd_mutex and then sev_cmd_mutex being held check (lockdep_assert_held()) getting triggered as part of __sev_do_cmd_locked().

I will fix snp_get_platform_data() to issue SNP_PLATFORM_STATUS and SNP_FEATURE_INFO commands using sev_do_cmd() instead of using __sev_do_cmd_locked() for the next version of this patch-series.

Thanks,
Ashish

> 
> [   34.653536] ------------[ cut here ]------------
> [   34.653545] WARNING: CPU: 92 PID: 4581 at drivers/crypto/ccp/sev-dev.c:349 __sev_do_cmd_locked+0x7eb/0xb90 [ccp]
> [   34.653570] Modules linked in: binfmt_misc rapl wmi_bmof kvm ast drm_client_lib drm_shmem_helper drm_kms_helper ccp(+) i2c_algo_bit i2c_piix4 k10temp i2c_smbus acpi_ipmi ipmi_si(+) ipmi_devintf ipmi_msghandler mac_hid sch_fq_codel dm_multipath drm efi_pstore nfnetlink dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 linear dm_mirror dm_region_hash dm_log ghash_clmulni_intel nvme sha512_ssse3 ahci sha1_ssse3 libahci nvme_core wmi aesni_intel
> [   34.653645] CPU: 92 UID: 0 PID: 4581 Comm: (udev-worker) Not tainted 6.15.0-rc7-next-20250522+ #4 PREEMPT(voluntary) 849304994a065362c1f65db9527c0b4292d5aea6
> [   34.653651] Hardware name: AMD Corporation VOLCANO/VOLCANO, BIOS RVOT1005B 04/08/2025
> [   34.653653] RIP: 0010:__sev_do_cmd_locked+0x7eb/0xb90 [ccp]
> [   34.653661] Code: fa ff ff be ff ff ff ff 48 c7 c7 50 cd b1 c0 44 89 85 70 ff ff ff e8 c4 fe f3 f3 44 8b 85 70 ff ff ff 85 c0 0f 85 e2 fd ff ff <0f> 0b e9 db fd ff ff 48 8b 05 57 aa 12 00 8b 0d 95 82 0c f5 48 c7
> [   34.653664] RSP: 0018:ff51f9b5d9f37890 EFLAGS: 00010246
> [   34.653668] RAX: 0000000000000000 RBX: 0000000000000083 RCX: 0000000000000001
> [   34.653671] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000246
> [   34.653672] RBP: ff51f9b5d9f37940 R08: 0000000000000000 R09: 0000000000000000
> [   34.653674] R10: 0000000000000001 R11: 0000000000000001 R12: ff51f9b5d9f37954
> [   34.653676] R13: ff3121dada778000 R14: 0000000000000000 R15: ff3121dadb5c5028
> [   34.653677] FS:  00007f0ed64488c0(0000) GS:ff3121e9b1a00000(0000) knlGS:0000000000000000
> [   34.653679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   34.653681] CR2: 00005599a0790fc8 CR3: 0000000108cd8001 CR4: 0000000000771ef0
> [   34.653684] PKRU: 55555554
> [   34.653686] Call Trace:
> [   34.653687]  <TASK>
> [   34.653701]  sev_get_api_version+0xb2/0x2b0 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.653714]  ? __pfx_sp_mod_init+0x10/0x10 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.653727]  sev_pci_init+0x4a/0x320 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.653733]  ? preempt_count_sub+0x50/0x80
> [   34.653741]  ? _raw_write_unlock_irqrestore+0x53/0x90
> [   34.653748]  ? __pfx_sp_mod_init+0x10/0x10 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.653756]  psp_pci_init+0x2f/0x50 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.653763]  sp_mod_init+0x32/0xff0 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.653770]  do_one_initcall+0x5f/0x3c0
> [   34.653774]  ? __kmalloc_cache_noprof+0x331/0x430
> [   34.653784]  do_init_module+0x68/0x260
> [   34.653789]  load_module+0x22ea/0x2410
> [   34.653803]  ? kernel_read_file+0x2a4/0x320
> [   34.653811]  init_module_from_file+0x96/0xd0
> [   34.653815]  ? init_module_from_file+0x96/0xd0
> [   34.653825]  idempotent_init_module+0x117/0x330
> [   34.653836]  __x64_sys_finit_module+0x6f/0xe0
> [   34.653841]  x64_sys_call+0x1f9e/0x20c0
> [   34.653844]  do_syscall_64+0x8d/0x2d0
> [   34.653849]  ? local_clock_noinstr+0x12/0xc0
> [   34.653855]  ? rcu_read_unlock+0x1b/0x70
> [   34.653860]  ? sched_clock_noinstr+0xd/0x20
> [   34.653864]  ? local_clock_noinstr+0x12/0xc0
> [   34.653869]  ? exc_page_fault+0x95/0x230
> [   34.653876]  ? irqentry_exit_to_user_mode+0xb1/0x1e0
> [   34.653880]  ? irqentry_exit+0x6f/0xa0
> [   34.653882]  ? exc_page_fault+0xb4/0x230
> [   34.653886]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   34.653888] RIP: 0033:0x7f0ed632725d
> [   34.653892] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b bb 0d 00 f7 d8 64 89 01 48
> [   34.653894] RSP: 002b:00007ffe599733b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   34.653897] RAX: ffffffffffffffda RBX: 00005599a07b4370 RCX: 00007f0ed632725d
> [   34.653899] RDX: 0000000000000000 RSI: 00007f0ed662507d RDI: 0000000000000022
> [   34.653901] RBP: 00007ffe59973470 R08: 0000000000000040 R09: 00007ffe59973420
> [   34.653902] R10: 00007f0ed6403b20 R11: 0000000000000246 R12: 00007f0ed662507d
> [   34.653903] R13: 0000000000020000 R14: 00005599a07b6020 R15: 00005599a07b9230
> [   34.653913]  </TASK>
> [   34.653914] irq event stamp: 211387
> [   34.653916] hardirqs last  enabled at (211393): [<ffffffffb37a6786>] __up_console_sem+0x86/0x90
> [   34.653922] hardirqs last disabled at (211398): [<ffffffffb37a676b>] __up_console_sem+0x6b/0x90
> [   34.653923] softirqs last  enabled at (209856): [<ffffffffb36e364f>] handle_softirqs+0x32f/0x410
> [   34.653928] softirqs last disabled at (209833): [<ffffffffb36e3800>] __irq_exit_rcu+0xc0/0xf0
> [   34.653932] ---[ end trace 0000000000000000 ]---
> [   34.654388] ------------[ cut here ]------------
> [   34.654391] WARNING: CPU: 92 PID: 4581 at drivers/crypto/ccp/sev-dev.c:349 __sev_do_cmd_locked+0x7eb/0xb90 [ccp]
> [   34.654396] Modules linked in: binfmt_misc rapl wmi_bmof kvm ast drm_client_lib drm_shmem_helper drm_kms_helper ccp(+) i2c_algo_bit i2c_piix4 k10temp i2c_smbus acpi_ipmi ipmi_si(+) ipmi_devintf ipmi_msghandler mac_hid sch_fq_codel dm_multipath drm efi_pstore nfnetlink dmi_sysfs ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 linear dm_mirror dm_region_hash dm_log ghash_clmulni_intel nvme sha512_ssse3 ahci sha1_ssse3 libahci nvme_core wmi aesni_intel
> [   34.654430] CPU: 92 UID: 0 PID: 4581 Comm: (udev-worker) Tainted: G        W           6.15.0-rc7-next-20250522+ #4 PREEMPT(voluntary)  849304994a065362c1f65db9527c0b4292d5aea6
> [   34.654433] Tainted: [W]=WARN
> [   34.654435] RIP: 0010:__sev_do_cmd_locked+0x7eb/0xb90 [ccp]
> [   34.654439] Code: fa ff ff be ff ff ff ff 48 c7 c7 50 cd b1 c0 44 89 85 70 ff ff ff e8 c4 fe f3 f3 44 8b 85 70 ff ff ff 85 c0 0f 85 e2 fd ff ff <0f> 0b e9 db fd ff ff 48 8b 05 57 aa 12 00 8b 0d 95 82 0c f5 48 c7
> [   34.654440] RSP: 0018:ff51f9b5d9f37890 EFLAGS: 00010246
> [   34.654442] RAX: 0000000000000000 RBX: 00000000000000ce RCX: 0000000000000001
> [   34.654443] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000246
> [   34.654443] RBP: ff51f9b5d9f37940 R08: 0000000000000000 R09: 0000000000000000
> [   34.654444] R10: 0000000000000001 R11: 0000000000000001 R12: ff51f9b5d9f37968
> [   34.654445] R13: ff3121dada778000 R14: 0000000000000000 R15: ff3121dadb5c5028
> [   34.654446] FS:  00007f0ed64488c0(0000) GS:ff3121e9b1a00000(0000) knlGS:0000000000000000
> [   34.654447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   34.654448] CR2: 00005599a0790fc8 CR3: 0000000108cd8001 CR4: 0000000000771ef0
> [   34.654449] PKRU: 55555554
> [   34.654450] Call Trace:
> [   34.654451]  <TASK>
> [   34.654457]  sev_get_api_version+0x1e6/0x2b0 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.654463]  ? __pfx_sp_mod_init+0x10/0x10 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.654469]  sev_pci_init+0x4a/0x320 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.654473]  ? preempt_count_sub+0x50/0x80
> [   34.654475]  ? _raw_write_unlock_irqrestore+0x53/0x90
> [   34.654477]  ? __pfx_sp_mod_init+0x10/0x10 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.654482]  psp_pci_init+0x2f/0x50 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.654487]  sp_mod_init+0x32/0xff0 [ccp 3cf3cbacf97e77e53be58eab8d4f5347a13f205d]
> [   34.654491]  do_one_initcall+0x5f/0x3c0
> [   34.654493]  ? __kmalloc_cache_noprof+0x331/0x430
> [   34.654498]  do_init_module+0x68/0x260
> [   34.654500]  load_module+0x22ea/0x2410
> [   34.654509]  ? kernel_read_file+0x2a4/0x320
> [   34.654513]  init_module_from_file+0x96/0xd0
> [   34.654515]  ? init_module_from_file+0x96/0xd0
> [   34.654522]  idempotent_init_module+0x117/0x330
> [   34.654530]  __x64_sys_finit_module+0x6f/0xe0
> [   34.654532]  x64_sys_call+0x1f9e/0x20c0
> [   34.654534]  do_syscall_64+0x8d/0x2d0
> [   34.654536]  ? local_clock_noinstr+0x12/0xc0
> [   34.654539]  ? rcu_read_unlock+0x1b/0x70
> [   34.654541]  ? sched_clock_noinstr+0xd/0x20
> [   34.654544]  ? local_clock_noinstr+0x12/0xc0
> [   34.654547]  ? exc_page_fault+0x95/0x230
> [   34.654551]  ? irqentry_exit_to_user_mode+0xb1/0x1e0
> [   34.654553]  ? irqentry_exit+0x6f/0xa0
> [   34.654555]  ? exc_page_fault+0xb4/0x230
> [   34.654558]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   34.654559] RIP: 0033:0x7f0ed632725d
> [   34.654560] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b bb 0d 00 f7 d8 64 89 01 48
> [   34.654561] RSP: 002b:00007ffe599733b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   34.654563] RAX: ffffffffffffffda RBX: 00005599a07b4370 RCX: 00007f0ed632725d
> [   34.654564] RDX: 0000000000000000 RSI: 00007f0ed662507d RDI: 0000000000000022
> [   34.654565] RBP: 00007ffe59973470 R08: 0000000000000040 R09: 00007ffe59973420
> [   34.654566] R10: 00007f0ed6403b20 R11: 0000000000000246 R12: 00007f0ed662507d
> [   34.654566] R13: 0000000000020000 R14: 00005599a07b6020 R15: 00005599a07b9230
> [   34.654572]  </TASK>
> [   34.654573] irq event stamp: 212111
> [   34.654574] hardirqs last  enabled at (212117): [<ffffffffb37a6786>] __up_console_sem+0x86/0x90
> [   34.654576] hardirqs last disabled at (212122): [<ffffffffb37a676b>] __up_console_sem+0x6b/0x90
> [   34.654577] softirqs last  enabled at (209856): [<ffffffffb36e364f>] handle_softirqs+0x32f/0x410
> [   34.654579] softirqs last disabled at (209833): [<ffffffffb36e3800>] __irq_exit_rcu+0xc0/0xf0
> [   34.654581] ---[ end trace 0000000000000000 ]---


