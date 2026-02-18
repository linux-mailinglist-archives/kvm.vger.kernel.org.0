Return-Path: <kvm+bounces-71280-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHCGC6E6lmnQcgIAu9opvQ
	(envelope-from <kvm+bounces-71280-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:18:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A157615A95E
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 254323023070
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C86533556E;
	Wed, 18 Feb 2026 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ddEME7a8"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E3831D38B;
	Wed, 18 Feb 2026 22:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771453076; cv=fail; b=NfaGvE9auxf/+iksYqXTJO3SVOI1nQgdBZoHwoekw1vtzIoavMTUp4rcLJVGo0+380BkBUmITb3s76ppSv5eaOj0kdcmpsKQwh6GLuI1pRLs1nzmVoGN0ckpKZYGp6Rin+XLVydOxEmJ4EBHS6wR5W/y9EqEULCQBg88Bhj/Kn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771453076; c=relaxed/simple;
	bh=vijPwjES8UBBh2f2CoiElfbTruHE77TAy5aKL1oKOZQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vf7uKdra0i58qoz11kyB/tauyeA0yteJE7+Q83b1WXH7G8eclsNhYxxprYr4U0s4Q0tEXW79f42v35g78Xoi8wC+Qrjnjm+pKI7uxzCNBCcUT0qmGKBs8hU/mHAiCeowo4iK2efOZYiGesJ/7cd1/32IbRdFEfkiqd36nWCOGHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ddEME7a8; arc=fail smtp.client-ip=40.107.200.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z86gnu/ZnUEThV6Ci1N0wr9iXHQyJVeebNz6gYDqdR/bqKPVJnTmw/UmheupGFbOBNtxiOP2qJyu9oyOFJixkLQefKzwurYVBb6cDpG6jOY9CtM1tExgoe2mKY9njECsO6ivTkLsSeS2v3zbQ0eUADrlNFmTxm0S7Gteyj3KlLFNWWhw0rsKLDnlVW7FplMD7jIbjUqiD+0WNFuLYm46+lv32CNnZglQ8BSdAmB3nos4mG34dyfYKuelrfFeWykFkcVNpwnuRfVh2YVUW1dhsOle6dS/ecz84JMQwfRg+PGa1bglYmJ1ROx1rtpF6nc909xBY/kIBW44u+00w1EdUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOSQ8imS82iUlhuwLg9gFyt3EXN2YPQnKAW20FgngrE=;
 b=JAbRxocCIBNURqwaYWoF/wh+TgNErO/KTpQY2sgFGsn/LUYkrbf3/F6m3FdfZB0CmGRghiiyIcg5VF21wRZf2bfPd5Nld1yW/r1lcjuNIz4G6fLPu/5fogA8K8oeeFVUa/3bHb6vfVIqBJNjrafKfc/vh+1iRJ1Rzkv/7ks7TyZYyBK6qIeRru7G38nAU+FyFFTvEx19rylAILeM7PE1y94uSIYzbs8Vjs3xuemA8ihVRLI3M91ZLB/R8hceZoChuGPnjMut7WgGM6Lz4AW0yiPzQFRZd6chzJAho/LZng0mD59I2e/HxfTIuCLgYIqV0Y7lix/EYhHBnkSmsI5mzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOSQ8imS82iUlhuwLg9gFyt3EXN2YPQnKAW20FgngrE=;
 b=ddEME7a8bQhDaX2nA/kT53MS6lwtJmirhNHt/xb1FNNJserW5VjC3bruyasFlLROw1jDX+NlFyZLRiG8RY2mhNWp9hGIIaxxDnW0Y0lewSmjQIkMpU6uuPtGlsmsYoFAcVKNq6xzSbPfmAPDYIE3d9AAtsAWam8ScCsk7ktnbok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CYYPR12MB8654.namprd12.prod.outlook.com (2603:10b6:930:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 22:17:50 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 22:17:50 +0000
Message-ID: <bab6afd4-b197-4a7b-b9d1-f518d192524f@amd.com>
Date: Wed, 18 Feb 2026 16:17:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
 <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::33) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CYYPR12MB8654:EE_
X-MS-Office365-Filtering-Correlation-Id: 9267995e-e998-46f5-e3c4-08de6f3b8cbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emtiUjRCYlZwOVBuN0JZYVc0djJtMHBQMStWWjFsKzhUSFBsdHNNSThVQ1ZN?=
 =?utf-8?B?TUtNTS9jUEpocWdLRFV4TTh3YnhMR1Z2MFo3S0l3bFpkNHl0MWVTOGhObG8y?=
 =?utf-8?B?SzZHcXpJNFFLWmlISVBSMDJJelBwQlNSanRFRUNRT25teGJSREdFdFQ3UTFW?=
 =?utf-8?B?eHBzWjNEVFZFZVpGNmhhOTZrdi8za0dqZks3MERwZkQ0TXNiRGR5UEdnRTNs?=
 =?utf-8?B?QzdLQkhxMHozY09FNUpyT2UyR3ZIUU5CWGEwbXVCY1VxY2tzbWVmS2JvaUVM?=
 =?utf-8?B?ZWlETzJPVjIyOHNPcjl2d05xN1A4aG1TU25teUNYZjQzSEdMT2hXSitKS0lY?=
 =?utf-8?B?WEc3cnlDZ3gwMnVGRzh2b3hTZFpYNldXWUh3TTZwbkdBMnUvMlJ0TWxLbk4y?=
 =?utf-8?B?QUxVaGhPb3g1aDRwaGFHbTMwNkNBWWVpejdna1FoL1YvdDhjY0V5TGtVdnI4?=
 =?utf-8?B?U2NkaWFoeHUyYUMrZEtUZDNvMkNSTCs4dmVJUjRmMUdMdkluV3lzQXdmT1Bj?=
 =?utf-8?B?TVgzYXFCT0hsSTZkNm9jMnRVVjg1RllEWHQ2eHVwck8rUXV2WmJQSzh1SWg5?=
 =?utf-8?B?MkNxaHUyZTRtUUQ2bEVmbThPQzFNOWRFZDEra2xETVlkY0NTTFRHTjgvVUdq?=
 =?utf-8?B?VjB6eHdKS05IQmZENkVjRFNFRjROemkrWExEOEJYbjBIWWFBSGNvZXJpN1NU?=
 =?utf-8?B?TWJEdEo1Ni93MmN5SVRFWUJscWs4NWtMM1hFRDY4L0hwcUh4T1hTaVR3ZXZL?=
 =?utf-8?B?VXBJQk1YemxsMmZHSVZ3ZC83NEV1VDVNODh0dzBoRVo2aThvSVUxYnA2RHpt?=
 =?utf-8?B?TzdRaVg4Z25pT0VBUFVYcTltWVpnYjIvdCtBRTMrWkJ6aFY2bVdVVzc0cFJV?=
 =?utf-8?B?ckg5QXkxdk5aVmwweXliY3dZUEhRSk92WFFiQ2RvRjBwNEVGMk5sZ2dkdmd0?=
 =?utf-8?B?dVp4SUtSZ3hITHNvdURkNXhuWWZKNUZJc25RUmNRbkc3UUIvSllXeEVtYmpT?=
 =?utf-8?B?YzgyeGZOelI3L2tXY3o0alZORGVnMHl1VUtvdGNsZE0rZ1NUTFRlbDdsdTBW?=
 =?utf-8?B?Skt2SkVJVVdHK2VPemtOQ3QvRTJNNFFWeGRxWks3cnIraG10VWNXTlBralNV?=
 =?utf-8?B?RlVZYzRlTzlSNktwOFNTVFBrZmZMSy9DM0dCWE5hL3VkRzdmam5sTnIxSmxE?=
 =?utf-8?B?YzEzSjhFY1JNclJaaGxwMzZRY2VOaTVKUlFHSWRRWHdQQzB3dllKYkMrTjhl?=
 =?utf-8?B?VG40WUVGRGt6eEpRVTRDaml3S0dHL2ovQ3BtakI0TDNsc0VDZVJaVFlRSjA2?=
 =?utf-8?B?OG1PNngxS21aYXlMcmNwVXNlUXZYNGhGc2lxM0dWUHl2WnhweVVhQWNuaHo2?=
 =?utf-8?B?cUJ0RWVjNWVJZFVSSzdPN21BWFQrV0JUazhyblUvK1lXWFZhL2h4WE8vd09s?=
 =?utf-8?B?Z3FuSzdqbFlRTnN2ZHR1aWowbUtMZkJ4TDhiZzZROTl5ZTdDd3ZZR3FKck1m?=
 =?utf-8?B?eEZvQWRoOHFqekhtN2s2czRnbVhuWitqTVB3VmQxU2JPWCt3bHVjRDErYmxP?=
 =?utf-8?B?UGVndXRxb0FLQTVJVVBVaVgzbGU5Mi9jZnRtY1cyNHVTZVdkcE9DQU5hMlhL?=
 =?utf-8?B?M00wbU0zUDJqUGZuK1kxOURXUEdDVmVVRkQ3LzVVbUp0blAzenhCMHFFczBY?=
 =?utf-8?B?SThROHl1ZlNFZFVhTWp4c3VTbUZoK2YxM3hzd0tYeEptMHRuMmp3VXFyMGd6?=
 =?utf-8?B?SnpoRFllZE82ak5qekFJcUQ4dlk2ckk4WWRYVzhxd05uUnA0aW1kQTlldUpB?=
 =?utf-8?B?dFJNL25FQmJjUi9qVm5ISmJrYTEwV3dtT0pGUjZzOUxiVHhKaXUwb3VYV21L?=
 =?utf-8?B?bTFWQ2p6L1htN3RmR1BMU04rYnhKU0RHOWo1M0pOZm11b3dhYk9RWlk1Z090?=
 =?utf-8?B?dHg4RVc5T29vSTlQTkE1eHZNcDJlZlBPWEZLOVhNVkdZd3h2SlNQZ0E5ekpu?=
 =?utf-8?B?ZmVob3ppWWdENVFzNjd3aFRmRTJXT2IzMlhtZDBLR2tNdi9LM2x0UEFSVWFE?=
 =?utf-8?B?YVBsYWdJR3VFWEFBM09PZGdURlJ6NGY0U3E0ekpDZ2xpSzRPV3Z1U2d0RGhK?=
 =?utf-8?B?Rk10MHNRNnFuVDNvTXgzWWU2bnFMR2NYSVlPcnVMMkd0SnRkRXBQaDZUNVVR?=
 =?utf-8?B?UHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEFsZGRMcGZHMTdLMEhsMUFyMXI3UUtodTFmQ013WGZmSm9Fb2diUkZOc0Mv?=
 =?utf-8?B?QjNpN0pJamQyaFJBQTVRelhpSmtlazRDS2Nsd0ptVXVUNUVVRnVOY25hbzZj?=
 =?utf-8?B?SkJORVdIYkR5WXV5NmJTTENYQjQ3MmtpQlBCc29DcU8ySDZrV2VLTkY0N1RK?=
 =?utf-8?B?QTMvb1lNNlJvaDNyc01INEFQYUUzRGo0Wm5uNnA3TmFtQlJkRzJqWWZ5cGhz?=
 =?utf-8?B?anVwaVZBNDQ3UmhGRjBpNFNpRExDM0hxVWNqVUdST2JXSVVGL2E5YnUyWm56?=
 =?utf-8?B?VVl5WDdyZDZyUGhPL09HMythYis4WGVBWHdlVE9TY1htT2srazJBaTFsUGJY?=
 =?utf-8?B?Tlo3V0h2MU0yZTJqZkx4VWMybjdYWVpqbS9aZ3ZUZHV0ZTVUc1hESFBuQXFO?=
 =?utf-8?B?Y2NJdjNZNGJUMnAxM0NQOVZUSDNaSVEvQk5rbUxIYUV3QlFzTGFoeHFkTlFi?=
 =?utf-8?B?cW03Y2xrNmtpeVZidEV6N0orT2lIUDk3Z0xsTFNNaElxU1ZNTjhWUm5obHli?=
 =?utf-8?B?R0tpNkZmYlpwSzdqdDVMR1RPOVRzejAzd0Q5eUJjNzIyUE94TWJTdlVERUIr?=
 =?utf-8?B?bUliQ1dxYjZjVUNnUGZ0VjMySGFDMFJIVktJVzc5UHRIbGJqQ2c3NFNRRmIy?=
 =?utf-8?B?QXhSOC9PNTRSNHA4SzdqQmVrRnN2S29iZ1dicVVUMDZlU3k1ejA0WWdOc0oy?=
 =?utf-8?B?NEUrQ204dnFOTzhobzZyQVdYcUloVHRZMloyVU9uYURxUmY1Z3lUeG0yM0Rq?=
 =?utf-8?B?NW04SWhMRDdkWUlxOGg1Z092N2JwQ0tNK0NIdDBhdVQzY0xmMzFUSzF6eGJP?=
 =?utf-8?B?WnZvRGtEaXRaakttYkZhVTlCbEs1WTNPV1hLSXlhTUVDaG5NMnBXZUREdDNE?=
 =?utf-8?B?RmRmRVdoU3NHUWZDY2YyQUNaRU5WWHhmT2lTMjJqZitpNGhveU9QZmhac0Yw?=
 =?utf-8?B?ZjkxblBpa1dGNGtJdWQraE5DYXhNVkVLYUxiOFdIazJRSEo5d3d4d0tjbDVS?=
 =?utf-8?B?WXFUZklwV3NmSWg2dWJiYktVaFlEVlovYlpMaGQwTk1JcnVURHBTL3pUMTdR?=
 =?utf-8?B?SkhKT3Q5c0NtUm5uQTRlM0Z5d1Q2R2oxNFZWeU5HZGJVdi9MNkRuVnp3Q2xi?=
 =?utf-8?B?ZTJ1eVhqbkY2bm93OXJieERIRDdjNlV4YWlIaTF1QmtDazFtQUtlY0JEMDBU?=
 =?utf-8?B?R2FjTmxQRnNseXZGRGY0MGZtYlZzWk5qVlZSU0xpa3VLQ1hmZWJqNkVqUUdP?=
 =?utf-8?B?SzRRdjVlRFg5NGduT05rY1VnYlRCRWVpN2dJQ0Vra2lHV3NzYVdyNGI1TU5M?=
 =?utf-8?B?N3U5dWpkMnA3MDgzMlhtQk5QVTU2bmhvYnd5RGtxQ1hKdWd0UW1vaG5ZRDNl?=
 =?utf-8?B?eFo1ZXRydURyWGJWK3A4Tk0zekh3cmg4SFVONjZXclVFK1AxK3o4YzlZdEFt?=
 =?utf-8?B?QkdtQ3lOUFh3RFhTZnZTMXlXcmg2dVIvUC9wQTFjbE1lUFd6WmlsYm9STnM2?=
 =?utf-8?B?SFFyYmxrUHpEVTNCYk9wRVd3N0lpOGkwSmxsVnRnQ2dUMjZpSEd3Zjg1enB5?=
 =?utf-8?B?S3RyZTBiWWdHNjYzeGRCOXYvTDVJandQTXJ2Nm13ejR2S090aHlKd05ud3Bk?=
 =?utf-8?B?QS9IbTBKNXZOWUJ5aXN3ams0eXgvakJGVXhiRTAvNjNMYjIxcUM1RGRFR24y?=
 =?utf-8?B?YjY5cm9iRCtKblUwWEgvMThLamYxUmxnc01SSW5hUm4yYzRrUmNuaGF4Tm9m?=
 =?utf-8?B?TFJ0YmU1MHpQclM0d3h2bG9UaW4rTlRGeFNIVXNqNXhJWFN2RWwzbjhaOTNp?=
 =?utf-8?B?Z0RlSCtJZzlrUWxBU01mWnQ1OFB4emRIWVVDVVN5N2IyYWxpMi8wS1NYSFp0?=
 =?utf-8?B?TVN5TEFEMW1DaVpNSVpqUjhUWFYvcHVsbFNsRTNyRVZDWnF6Z3IrLzczcTYy?=
 =?utf-8?B?UTQraGxYNTczYXB4R001d1NVbWpKblRneHlBa3RMSUlWY01nWnVVb2I2ZFl0?=
 =?utf-8?B?anVVeUFGZXAwdHA1L28xM3V1aUZONit4R3piMkRKczF0MlRYRWdCWElGamcr?=
 =?utf-8?B?TjJtaUZjMUpuMVh3MFZaMHVZN2txTjJtTVZ6akk3VFVKSXZtSzE0K2MrMit3?=
 =?utf-8?B?Q2piaUMrWUZNZmo0eEhROHN2c3A5RS8rQmdsbStqZ29ZZEQwT3c3OVVCMVdz?=
 =?utf-8?B?WXY0dGs0em5jQmYwVmxDaGhSL3VWWjFTNzE3MWtCYVZuUElZa1RveGZ4NzNn?=
 =?utf-8?B?OVVTelJxejRRRjdpOWlhWmp2R2hNN0d4ZEhIQWFxZy8vM0RtOHAydEgrWXlL?=
 =?utf-8?B?RXJmWVhHT0VBREhiQnZnaXVWWUFjd1J3WE9tRk1EK1JXUDVaeG41dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9267995e-e998-46f5-e3c4-08de6f3b8cbb
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 22:17:50.4607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWkwSblWkt2vgHfkQOXWMEh10Nd5QQeQ+QCEMYJsPXJ7XGwd+pzVr+rmGktnnF18e5f2Bivb4Pa6JhUNAM0ekw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8654
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71280-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A157615A95E
X-Rspamd-Action: no action

Hello Dave,

On 2/17/2026 4:06 PM, Dave Hansen wrote:
>> +#define RMPOPT_TABLE_MAX_LIMIT_IN_TB	2
>> +#define NUM_TB(pfn_min, pfn_max)	\
>> +	(((pfn_max) - (pfn_min)) / (1 << (40 - PAGE_SHIFT)))
> 
> IMNHO, you should just keep these in bytes. No reason to keep them in TB.
> 
>> +struct rmpopt_socket_config {
>> +	unsigned long start_pfn, end_pfn;
>> +	cpumask_var_t cpulist;
>> +	int *node_id;
>> +	int current_node_idx;
>> +};
> 
> This looks like optimization complexity before the groundwork is in
> place. Also, don't we *have* CPU lists for NUMA nodes? This seems rather
> redundant.
> 

Yes, we do have CPU lists for NUMA nodes, but we need a socket specific 
cpumask, let me explain more about that below. 

>> +/*
>> + * Build a cpumask of online primary threads, accounting for primary threads
>> + * that have been offlined while their secondary threads are still online.
>> + */
>> +static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
>> +{
>> +	cpumask_t cpus;
>> +	int cpu;
>> +
>> +	cpumask_copy(&cpus, cpu_online_mask);
>> +	for_each_cpu(cpu, &cpus) {
>> +		cpumask_set_cpu(cpu, cpulist);
>> +		cpumask_andnot(&cpus, &cpus, cpu_smt_mask(cpu));
>> +	}
>> +}
> 
> Don't we have a primary thread mask already? I thought we did.
> 

Already discussed this. 

>> +static void __configure_rmpopt(void *val)
>> +{
>> +	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
>> +
>> +	wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>> +}
> 
> I'd honestly just make the callers align the address..
> 
>> +static void configure_rmpopt_non_numa(cpumask_var_t primary_threads_cpulist)
>> +{
>> +	on_each_cpu_mask(primary_threads_cpulist, __configure_rmpopt, (void *)0, true);
>> +}
>> +
>> +static void free_rmpopt_socket_config(struct rmpopt_socket_config *socket)
>> +{
>> +	int i;
>> +
>> +	if (!socket)
>> +		return;
>> +
>> +	for (i = 0; i < topology_max_packages(); i++) {
>> +		free_cpumask_var(socket[i].cpulist);
>> +		kfree(socket[i].node_id);
>> +	}
>> +
>> +	kfree(socket);
>> +}
>> +DEFINE_FREE(free_rmpopt_socket_config, struct rmpopt_socket_config *, free_rmpopt_socket_config(_T))
> 
> Looking at all this, I really think you need a more organized series.
> 
> Make something that's _functional_ and works for all <2TB configs. Then,
> go add all this NUMA complexity in a follow-on patch or patches. There's
> too much going on here.

Sure. 

> 
>> +static void configure_rmpopt_large_physmem(cpumask_var_t primary_threads_cpulist)
>> +{
>> +	struct rmpopt_socket_config *socket __free(free_rmpopt_socket_config) = NULL;
>> +	int max_packages = topology_max_packages();
>> +	struct rmpopt_socket_config *sc;
>> +	int cpu, i;
>> +
>> +	socket = kcalloc(max_packages, sizeof(struct rmpopt_socket_config), GFP_KERNEL);
>> +	if (!socket)
>> +		return;
>> +
>> +	for (i = 0; i < max_packages; i++) {
>> +		sc = &socket[i];
>> +		if (!zalloc_cpumask_var(&sc->cpulist, GFP_KERNEL))
>> +			return;
>> +		sc->node_id = kcalloc(nr_node_ids, sizeof(int), GFP_KERNEL);
>> +		if (!sc->node_id)
>> +			return;
>> +		sc->current_node_idx = -1;
>> +	}
>> +
>> +	/*
>> +	 * Handle case of virtualized NUMA software domains, such as AMD Nodes Per Socket(NPS)
>> +	 * configurations. The kernel does not have an abstraction for physical sockets,
>> +	 * therefore, enumerate the physical sockets and Nodes Per Socket(NPS) information by
>> +	 * walking the online CPU list.
>> +	 */
> 
> By this point, I've forgotten why sockets are important here.
> 
> Why are they important?
Because, Nodes per Socket (NPS) configuration is enabled by default, therefore, we have to
look at Sockets instead of simply NUMA nodes, and collect/aggregate all the Node data per Socket
and then accordingly setup the RMPOPT tables, so that the 2TB limit of RMPOPT tables is covered
appropriately and we try to map the maximum possible memory in RMPOPT tables per-Socket rather
than per-Node.

And as there is no per-Socket information available in kernel, we walk through the online
CPU list and collect all this per-Socket information (including socket's start, end addresses,
NUMA nodes in the socket, cpumask of the socket, etc.)

>  
>> +	for_each_cpu(cpu, primary_threads_cpulist) {
>> +		int socket_id, nid;
>> +
>> +		socket_id = topology_logical_package_id(cpu);
>> +		nid = cpu_to_node(cpu);
>> +		sc = &socket[socket_id];
>> +
>> +		/*
>> +		 * For each socket, determine the corresponding nodes and the socket's start
>> +		 * and end PFNs.
>> +		 * Record the node and the start and end PFNs of the first node found on the
>> +		 * socket, then record each subsequent node and update the end PFN for that
>> +		 * socket as additional nodes are found.
>> +		 */
>> +		if (sc->current_node_idx == -1) {
>> +			sc->current_node_idx = 0;
>> +			sc->node_id[sc->current_node_idx] = nid;
>> +			sc->start_pfn = node_start_pfn(nid);
>> +			sc->end_pfn = node_end_pfn(nid);
>> +		} else if (sc->node_id[sc->current_node_idx] != nid) {
>> +			sc->current_node_idx++;
>> +			sc->node_id[sc->current_node_idx] = nid;
>> +			sc->end_pfn = node_end_pfn(nid);
>> +		}
>> +
>> +		cpumask_set_cpu(cpu, sc->cpulist);
>> +	}
>> +
>> +	/*
>> +	 * If the "physical" socket has up to 2TB of memory, the per-CPU RMPOPT tables are
>> +	 * configured to the starting physical address of the socket, otherwise the tables
>> +	 * are configured per-node.
>> +	 */
>> +	for (i = 0; i < max_packages; i++) {
>> +		int num_tb_socket;
>> +		phys_addr_t pa;
>> +		int j;
>> +
>> +		sc = &socket[i];
>> +		num_tb_socket = NUM_TB(sc->start_pfn, sc->end_pfn) + 1;
>> +
>> +		pr_debug("socket start_pfn 0x%lx, end_pfn 0x%lx, socket cpu mask %*pbl\n",
>> +			 sc->start_pfn, sc->end_pfn, cpumask_pr_args(sc->cpulist));
>> +
>> +		if (num_tb_socket <= RMPOPT_TABLE_MAX_LIMIT_IN_TB) {
>> +			pa = PFN_PHYS(sc->start_pfn);
>> +			on_each_cpu_mask(sc->cpulist, __configure_rmpopt, (void *)pa, true);
>> +			continue;
>> +		}
>> +
>> +		for (j = 0; j <= sc->current_node_idx; j++) {
>> +			int nid = sc->node_id[j];
>> +			struct cpumask node_mask;
>> +
>> +			cpumask_and(&node_mask, cpumask_of_node(nid), sc->cpulist);
>> +			pa = PFN_PHYS(node_start_pfn(nid));
>> +
>> +			pr_debug("RMPOPT_BASE MSR on nodeid %d cpu mask %*pbl set to 0x%llx\n",
>> +				 nid, cpumask_pr_args(&node_mask), pa);
>> +			on_each_cpu_mask(&node_mask, __configure_rmpopt, (void *)pa, true);
>> +		}
>> +	}
>> +}
> 
> Ahh, so you're not optimizing by NUMA itself: you're assuming that there
> are groups of NUMA nodes in a socket and then optimizing for those groups.
>
Yes, by default Venice platform has the NPS2 configuration enabled by default,
so we have 'X' nodes per socket and we have to consider this NPSx configuration
and optimize for those groups. 

> It would have been nice to say that. It would make great material for
> the changelog for your broken out patches.

Ok. 

> 
> I have the feeling that the structure here could be one of these in a patch:
> 
>  1. Support systems with <2TB of memory
>  2. Support a RMPOPT range per NUMA node
>  3. Group NUMA nodes at socket boundaries and have them share a common
>     RMPOPT config.
> 
> Right?

Yes, sure.

> 
>> +static __init void configure_and_enable_rmpopt(void)
>> +{
>> +	cpumask_var_t primary_threads_cpulist;
>> +	int num_tb;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
>> +		pr_debug("RMPOPT not supported on this platform\n");
>> +		return;
>> +	}
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
>> +		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
>> +		return;
>> +	}
>> +
>> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
>> +		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");
>> +		return;
>> +	}
>> +
>> +	if (!zalloc_cpumask_var(&primary_threads_cpulist, GFP_KERNEL))
>> +		return;
>> +
>> +	num_tb = NUM_TB(min_low_pfn, max_pfn) + 1;
>> +	pr_debug("NUM_TB pages in system %d\n", num_tb);
> 
> This looks wrong. Earlier, you program 0 as the base RMPOPT address into
> the MSR. But this uses 'min_low_pfn'. Why not 0?

You are right, we should have used min_low_pfn earlier to program the 
base RMPOPT address into the MSR. 

> 
>> +	/* Only one thread per core needs to set RMPOPT_BASE MSR as it is per-core */
>> +	get_cpumask_of_primary_threads(primary_threads_cpulist);
>> +
>> +	/*
>> +	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory for RMP optimizations.
>> +	 *
>> +	 * Fastpath RMPOPT configuration and setup:
>> +	 * For systems with <= 2 TB of RAM, configure each per-core RMPOPT base to 0,
>> +	 * ensuring all system RAM is RMP-optimized on all CPUs.
>> +	 */
>> +	if (num_tb <= RMPOPT_TABLE_MAX_LIMIT_IN_TB)
>> +		configure_rmpopt_non_numa(primary_threads_cpulist);
> 
> this part:
> 
>> +	else
>> +		configure_rmpopt_large_physmem(primary_threads_cpulist);
> 
> ^^ needs to be broken out into a separate optimization patch.
> 

Ok.

Thanks,
Ashish

