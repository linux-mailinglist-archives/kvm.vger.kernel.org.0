Return-Path: <kvm+bounces-52522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 160D1B0643E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FCE6163763
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED012A1B2;
	Tue, 15 Jul 2025 16:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dMqV10vg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5283E2459F7;
	Tue, 15 Jul 2025 16:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596592; cv=fail; b=SH3uAprsUb5WGuE6HSwVpWQWxs/vLRiJTcWz98Xmp+95YCqGE4mZPW07zABOuuxc04SHEAFVo13Y+6GN0oE9E1F936+jN1dMvgW/BLYNCe/IafVDCfEe0kv8HIW/Mt+nS9MNsuoEUm9zCD0RNojevcqGLnPSZLqCCDrFEXSmfUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596592; c=relaxed/simple;
	bh=qcJHrzprImA2tzlbN4uVmy+LNqNtf+zKE6fm5vM/TPc=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=lKEBGAHvevqvoJOwU2y2PTAFF6FXor6o46E/S8OidWTyn0VB13oqVSX1vcvWwNbk15V/+ag3TeKdA7vJfpcmnpTgUD/fYyb7u+EXgOKyOhAWu8c+8pXtw7MMcN0UPq5VtwixJQq4sxJ7A9pA6ewTo5nLUpm2Ps3IUt/jhvguUZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dMqV10vg; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9yopb1OBDc0/ZrcONiB91yCaZDceDo7W6pFvWp3n/rqu6mWX0GwL4foAhsAuqGIquNiZQlZf26ZAFk0MC8xX7Bc+ZBT7TpZrgzrBC1h82fLGi+dUHlwe2zDccLL2ozwciPBbmew3vultS+aBSEA0g9eVhWuqHHDOVZG6aM+ARCJNlqDDg6ZL7vRF9s8iUSNjQadKdK53dSsmwXxh9HGFXfi4TiA2idjTf8gjRGn0cNVBvPX4tK4ZPJ52UIG3uet9db4xfK7m14EYFi7D9+bTpXnsjU2e9Pj1oLBU5Mu0/jV35Co0vh+MaN+r5F1x2Qb1BxdJnNTkCQkkuoJT4Sfag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1T3dJIDh1Lp0LMlAIHTw2DgkxYbL1/4o2khPRG4C9yE=;
 b=YSB6YxJhWUXyBcrLx7ioiq3zb0aD3KUwUR+Sc6Z/ok4MLHK8pCLSZgDWKnEV1xaH3rDX8rJ9BiF5hck5BPELDl8qjdcmi9IKKx4f4AaMkYC9xfwO/OypolvoXlYu44gg1wWzV7M45/mB4xSVQfbYrWEeTbiE3x0shWs6WNLobqi5Eptms+zdpJMVchGpK9nHb/a8lDd76frnGLwYlDRwtZ5BI22JmYJjfXRx+NZRTHrdXO6vQpzLlm6q82v2oZG6J0MJzr+5EnV3Ea8DtAC3sTePCR2clJh/wnOsPCcBA0vEAU3pBeP0QPmME03A+YHqbvfPJiYQcOQ/Pvr5LbqS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1T3dJIDh1Lp0LMlAIHTw2DgkxYbL1/4o2khPRG4C9yE=;
 b=dMqV10vgWsjPXn+lK3cXaehKsYYU0YqtP/M2X99gHcm1w5inGWOBQxAtdtRhHzPR93hBBPlOkFeKm6Bc1qV1Q2MkStssY6tMV0vG9WLNKsJjzLHULyr+P1VVuGzITZM/oCkzL79TrSRM6D6DZnQ5HGtcn5P5IZcbnHskVI0HAjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY1PR12MB9581.namprd12.prod.outlook.com (2603:10b6:930:fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Tue, 15 Jul
 2025 16:23:06 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Tue, 15 Jul 2025
 16:23:03 +0000
Message-ID: <46810e8f-eba7-69ac-e4ae-009c379aa960@amd.com>
Date: Tue, 15 Jul 2025 11:23:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752531191.git.ashish.kalra@amd.com>
 <7fe696f2cfda1e6cd3c24af5b0a93c70ac692667.1752531191.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v6 3/7] crypto: ccp - Add support for SNP_FEATURE_INFO
 command
In-Reply-To: <7fe696f2cfda1e6cd3c24af5b0a93c70ac692667.1752531191.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY1PR12MB9581:EE_
X-MS-Office365-Filtering-Correlation-Id: b1475e83-04e6-45b1-a9a6-08ddc3bbdfa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHBEYSs4c2l1Zk1kNGd3a1FQajM3OUZ6Zi9SSm0vK1VSMWRQV2daWnhZN0Vw?=
 =?utf-8?B?RmRlOWdFaVlHanM1WllSVE42QVVaNGhrUVh5YWlIbVJIK0FlSkdTMUdValdv?=
 =?utf-8?B?OXVOZVZWNSs5NndyanNudTlRRDV5MUJ3KzAzdGd3OVREbWZlZG5ldzlWb29O?=
 =?utf-8?B?TmhITTJCMEdqZytacVg3eTF4MTFZUjdQV1VqVG80UEoySVk5RUVEWVdVaS9o?=
 =?utf-8?B?TEtMRmVYWkM0KzRLaml4WXBuUENJTDdsSmI1SXMrQ3RhdDVzaUNnd2VHZnFz?=
 =?utf-8?B?WFZFRzlwK3ZHQlVydnRTbUFqeFBNZ3VJaEluc3hCYTBJZVpQaENsMG5yUGJr?=
 =?utf-8?B?MngrZ1pVd0VkVkZLaU9icWRjNklvSkhNL0krSEwxc0kySlRhN1Y5NHlwdDR6?=
 =?utf-8?B?TUtDQ3FkV1k4WmFLRXBSMnNuWGl1KzlGTDRyNEMyUTBZYW5JbU5NR1NDS0pO?=
 =?utf-8?B?T1l6ZWJmODFveTZoVTJ2djNwNFhHRHRvdWs4QS9UMVRYTkd0TVZTQ1MzVlhW?=
 =?utf-8?B?a2hPNTJGcU9PbXJqTHBmMnhpMDcwdGdjbm9RelFXQTIyNkVtWEF1dHdDRmlh?=
 =?utf-8?B?S3FBSER4eG14STJSTHhFdnVYTGJDWnhSa3J0cTlldnVyOUxNajc0VG8rWTVh?=
 =?utf-8?B?MmhPa1MvL2toYzh1dmM0OVRGaFVCZ2FZMDZPaG10RzJ6aERuZTFRMmJ0WG1X?=
 =?utf-8?B?a3BBT1BTdmVqTU9XZGZ2U2xNVFJtNG53NnJTQ1QxUWptbFRoeC9JRE1NNG91?=
 =?utf-8?B?eGw1Y05wLzdMMGRqWWdRN2M0b3kvR3hRYnlOQ0pLaFlZdmtVNEJLSlhGLzF2?=
 =?utf-8?B?bnV2eEhmMjRRQ0VUcmVVbjVtU0J1YThzQ3hhM21mQ1FRL2lpQURZb0hCcENL?=
 =?utf-8?B?YTZSbkhTZkFVQkFHT3Fxa3JJVXlBdTZHTUp3QU9BK2lwYXFwell3TWNlZFBj?=
 =?utf-8?B?NDQ0bG5EQTBFR2tZdFN3RTVQYWdCMVhDUllRWEpZV2JaeUFlRTI4clZnRENL?=
 =?utf-8?B?b1JjVTNIWm5tc0k4SzJXTFgzVy9Ub25YTC9QMm5VUENkQm4wRU1FNHhlQUJ2?=
 =?utf-8?B?Z0V6dnNQUnhQanRqOWxTQUNXYk8zNytQdEszV3Z5eDRDeWw0ZGJoQXNtL3dP?=
 =?utf-8?B?N2pqWktqcm40TXUxMUk0RE5mUjdqRHVLRTNPcGZvWVR6d0tYamc3RFZWRDJa?=
 =?utf-8?B?RjUrdC8wS212TmxWbXdMdzU5ZTk0T3NPaFN6ZU0yYzBrcDhxRnJrZWhCaHo2?=
 =?utf-8?B?dzZWNTZtQkZLUkU2aHJQSkRWVzFGNjFoczg4eUtSc3JWQmEwS1FhcnpJYjl6?=
 =?utf-8?B?a3hZSDR0amdTekwrTUt0MUVwQnpGQmVJZDdDNXN5OEFNWUVCU2dVWVhubERr?=
 =?utf-8?B?UEFtM3RZTTJRTldDYzV6RnAzUWlOcTBTZWl0Y3VRRXR3SE4zVi96QmVFLzVs?=
 =?utf-8?B?UWZtRVRzSS9ZSUh6VXFweUhycjZ0VXhzNUdyMkVNUFBwT0wxWFd6Sm9RQmZa?=
 =?utf-8?B?VFpQMDdzZ3UrYm54RklnNVBtWlJZS2ErMU8rYjJiNVZkc0lUZkRtOExsU2d2?=
 =?utf-8?B?L01uUE8zT0lKdlI0WENvL2x3bjRQb1lIODhseWlFN1RCRmtuRzZvMmRvQ2tY?=
 =?utf-8?B?T2xxNkluOWh0Wkx0UWZxSkxxZkxLWUlHWW1rdU50ajgvR0t2d1pwZTZwY3pE?=
 =?utf-8?B?UytVV1U5TU9ZWVBzdlBTYmxkQ0N6QmRFQ3k4NWcwVGFETUNmN2MvYkIwYjFp?=
 =?utf-8?B?b09BSHdYaVNKdERjZnM1Wkw1c0lRMkxwZDRWMWZRQk9NMldiK1VtbGVoZXBl?=
 =?utf-8?B?eUpsckRVQlN0N3ZoOFNkSUg5L1ZWSFhmcWV5YUJGakF2RE1TLy85MUNKeHZW?=
 =?utf-8?B?TUFHbzdUdjgyY09XMEhFWmZiUFhOVFFtK1VsNHp5STZuWUtrT1JCRlZmSW5q?=
 =?utf-8?B?Y3l3Vm9ZZVBNNldIRzd2WFdTQXFmTFR6OTN2ZTVXTjJhdzUxcmc4WjRENml2?=
 =?utf-8?B?czZnTWZYRWlnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk8zbHdWVDJ1emVMY3BHWHNPSm5HUERwMzVHYWZVRTVJeWZIdU00S0NFWjB2?=
 =?utf-8?B?amlkY0kzT3RzQkdjM0FBZE9LZE9WdndWMHRoUVF1OXZzb1p3NG9zY0FBdkxX?=
 =?utf-8?B?R2o5MjgxZURjRkMyaVhYM1Y0ODVEQVdDeVdYUUtGaWo1NldGRjFxbll4ei8x?=
 =?utf-8?B?MXNUM3VJd3dnWVhmbzk5UllvcEc1UlczMmR1c2tGWWEwOWZuUkU3T0RmRkVv?=
 =?utf-8?B?a0NnUndiN0VKVEsyTVBrV1d6NHJzOXZ6QTVZc0xhSVEyNXhsSVNHT2NEdTE4?=
 =?utf-8?B?eWkrSnNoOFdDVHRMdnh2LzNUd3BicTFxZnNNTW01VFQ1QVNlQlprczcvS1Uv?=
 =?utf-8?B?WHNhSmZXL3RrZmVQZmlwOUpKNWsxYkh0M3ZYSThUbkN6VHMrZlVGR05ZbWkw?=
 =?utf-8?B?aldST0pVYys3bnlwUTVTL2lwbkN2SHg4K2NBcm5ka25taDh2RklLNEVxbGVn?=
 =?utf-8?B?UHNhYlV6RjdySUJKcCt2eFpuam1OdkFHWTdzMW51ajRCOFB0Z2MvSzhtc21k?=
 =?utf-8?B?NFdIcGRRSnhncTZwMHZhbW53MmtEOHZ3eXVZanQvMXZhMWplcVRPRnlUMWxL?=
 =?utf-8?B?M1prZGhYRWovZVZTaDVzRlpEK0lPTG1CYVZCRFRpdUxOeDlocEF0TU50Skha?=
 =?utf-8?B?S3l6eEc2N0hIbzhFYWY0WDFrR29mTVJ6T2JsaFhiYTVvSEpXelFGRXcreUdC?=
 =?utf-8?B?N1Fmd09TQktkZzl2ajBaTU02eUV1eWFWNnZIQ05mSSt3Sjc3dDlQajRsV1F5?=
 =?utf-8?B?cDdGaTFoUjA4akhhamt5aWNwd1FkYjhSZms1Njg2YVBaT01uN3NubjNmZ0xC?=
 =?utf-8?B?bWVKT0NMMUlnLzQraFk4cHA2bWVBQ3kvdTFGcGY0ZVo1bi9RSnNJTUVQYXJi?=
 =?utf-8?B?OXA3aXdkQzlMYUVPazNnVEtGMXNISkFCOEE5aGFHdmREV1R5MkJlYkVOWkJ1?=
 =?utf-8?B?eDZNQStqMjVFVVIrOXFtQk9UbWwyeGl6d2YwaWJTbzF2aGRUT3NsY0h2ZEFv?=
 =?utf-8?B?SFBDckgzTXBLMGRLWUxZb1dHempQR1I4UU84ckp4OE5BTUIxUmhWb1N0ODQ0?=
 =?utf-8?B?aDUxSjNvVE5GZ0NrNDRIZ0VqSCtwdkR4UmFuODZyL3p1YW4xZ3BHelRWWEdI?=
 =?utf-8?B?MmNYaWxSeDMzemlDZEIyaU11TXFVS05kdUFDUUo4ZytCSDlYQmgyRVljN09r?=
 =?utf-8?B?aVErZnpyZHZnU2Z2d3FKdlRlNmlSYWl2YU5MUUxhMGpZUXluOEJLRVk5TXNU?=
 =?utf-8?B?cUQwTytocTJzVGVWcERTY2htQk1XbkpXQTVvQzBuaFlnYUduZVRORzlONlEw?=
 =?utf-8?B?NkpUUGN0Q0JmWE1Ga1VBd3BwM0t6NUZKK25Mdm4veEhUbHVQbUxkUGhwK3BN?=
 =?utf-8?B?TEYvcFhBRnVGY3drbTZKSUgvMUZ6UUhsb1hzSVIzcm5vajlHR3A4MlJqNkY0?=
 =?utf-8?B?L0pJYUJRMTZicTNVeFkyeXd5U0pMNTdFQkYxK2J5VVNkYXM5OE91YzM1ZUhP?=
 =?utf-8?B?Vm9XQzAvcmVQeFlUenZMQmc4akdWUm1DUDcyMzlnWktXTmFFMVpYSmNPSGdj?=
 =?utf-8?B?eTVUdzdXUk5rYWplWlhJSzUwR000VkdDYUh4OWtTayt6aHRManpMMmlYUTNi?=
 =?utf-8?B?OXZPTzFwL0ZpRlBpMFR2YUVRTVBaWllPRDVhMWNLbStsRFJVVXFnWStBMGRq?=
 =?utf-8?B?UzJ0eURSdTcwMG5jY0FUVG5zSXV0clZEUy9nNG12Z1I2NWZpc2hpRkNIRmhr?=
 =?utf-8?B?NHA0NzlzRVhHQVVDQU5EK2p3MldZUnd5cUFxNjlmbGNsTTJXQ1ptUldTbXFw?=
 =?utf-8?B?SUNQbTdId25Rbm12SnNPZ0tSQUZ4dE52SC8vQ3k1TG5WSTI0OEorUTBrSFRB?=
 =?utf-8?B?OGNKZzA3dEpxcVdxN1l1aGhNNWVaZHZ6MjBXc01lZkIwSHhRTEtlTDFKL3hU?=
 =?utf-8?B?QjhWN25RYitzb1FQM3l6M1lIcWZKem42R2ZMWjB1b0xMWkh6N1kwZk5nR0VB?=
 =?utf-8?B?cll1QmMrREt5dnFHZGE1YldTa0VQd3NVQ1o2aVNLR21xamU2clVNTm52Sjd1?=
 =?utf-8?B?ajVDeXErYnNSYXFjYm43MFZOYzBXSHh2OWViWjNDT3NQMXYzU0UweitzMHRl?=
 =?utf-8?Q?oh3GDxchDT3W6hJS2y/8UP06o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1475e83-04e6-45b1-a9a6-08ddc3bbdfa4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 16:23:03.6907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ru1YM4pd4Pq0oWgWXTu18OW1JFCp3EDpgZnYq1BHEbUHz8T+RrKsdVyosJ6AR2R6w+8Avi4ym9ClLIvtUcUjpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9581

On 7/14/25 17:39, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The FEATURE_INFO command provides hypervisors with a programmatic means
> to learn about the supported features of the currently loaded firmware.
> This command mimics the CPUID instruction relative to sub-leaf input and
> the four unsigned integer output values. To obtain information
> regarding the features present in the currently loaded SEV firmware,
> use the SNP_FEATURE_INFO command.
> 
> Cache the SNP platform status and feature information from CPUID
> 0x8000_0024 in the sev_device structure. If SNP is enabled, utilize
> this cached SNP platform status for the API major, minor and build
> version.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

with a minor comment below.

> ---
>  drivers/crypto/ccp/sev-dev.c | 72 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  3 ++
>  include/linux/psp-sev.h      | 29 +++++++++++++++
>  3 files changed, 104 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 528013be1c0a..8f4e22751bc4 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1073,6 +1074,67 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static int snp_get_platform_data(struct sev_device *sev, int *error)
> +{
> +	struct sev_data_snp_feature_info snp_feat_info;
> +	struct snp_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	struct page *page;
> +	int rc;
> +
> +	/*
> +	 * This function is expected to be called before SNP is not

s/not//

Someone else had made that comment, looks like you missed it.

Thanks,
Tom

> +	 * initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return -EINVAL;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +	if (rc) {
> +		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
> +			rc, *error);
> +		return rc;
> +	}
> +
> +	sev->api_major = sev->snp_plat_status.api_major;
> +	sev->api_minor = sev->snp_plat_status.api_minor;
> +	sev->build = sev->snp_plat_status.build_id;
> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,
> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (!sev->snp_plat_status.feature_info)
> +		return 0;
> +
> +	/*
> +	 * Use dynamically allocated structure for the SNP_FEATURE_INFO
> +	 * command to ensure structure is 8-byte aligned, and does not
> +	 * cross a page boundary.
> +	 */
> +	page = alloc_page(GFP_KERNEL);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	feat_info = page_address(page);
> +	snp_feat_info.length = sizeof(snp_feat_info);
> +	snp_feat_info.ecx_in = 0;
> +	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
> +	if (!rc)
> +		sev->snp_feat_info_0 = *feat_info;
> +	else
> +		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
> +			rc, *error);
> +
> +	__free_page(page);
> +
> +	return rc;
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -1599,6 +1661,16 @@ static int sev_get_api_version(void)
>  	struct sev_user_data_status status;
>  	int error = 0, ret;
>  
> +	/*
> +	 * Cache SNP platform status and SNP feature information
> +	 * if SNP is available.
> +	 */
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> +		ret = snp_get_platform_data(sev, &error);
> +		if (ret)
> +			return 1;
> +	}
> +
>  	ret = sev_platform_status(&status, &error);
>  	if (ret) {
>  		dev_err(sev->dev,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 24dd8ff8afaa..5aed2595c9ae 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -58,6 +58,9 @@ struct sev_device {
>  	bool snp_initialized;
>  
>  	struct sev_user_data_status sev_plat_status;
> +
> +	struct sev_user_data_snp_status snp_plat_status;
> +	struct snp_feature_info snp_feat_info_0;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0f5f94137f6d..5fb6ae0f51cc 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -814,6 +815,34 @@ struct sev_data_snp_commit {
>  	u32 len;
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
> + *
> + * @length: len of the command buffer read by the PSP
> + * @ecx_in: subfunction index
> + * @feature_info_paddr : System Physical Address of the FEATURE_INFO structure
> + */
> +struct sev_data_snp_feature_info {
> +	u32 length;
> +	u32 ecx_in;
> +	u64 feature_info_paddr;
> +} __packed;
> +
> +/**
> + * struct feature_info - FEATURE_INFO structure
> + *
> + * @eax: output of SNP_FEATURE_INFO command
> + * @ebx: output of SNP_FEATURE_INFO command
> + * @ecx: output of SNP_FEATURE_INFO command
> + * #edx: output of SNP_FEATURE_INFO command
> + */
> +struct snp_feature_info {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

