Return-Path: <kvm+bounces-54197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41FE3B1CE25
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FFD6627D27
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C9522422D;
	Wed,  6 Aug 2025 20:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Eg+ryKK9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2045.outbound.protection.outlook.com [40.107.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E81821CC64;
	Wed,  6 Aug 2025 20:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513915; cv=fail; b=TGWK51qBfARKZah7ehuL7YRacjj0cl9zMrQaJ7J0tjEdL2Ra5MpElHoXeMoWiRLWBry/vWoEHgX0GubjES58kjfyWYSKp5JcTQrdJJ9KbkHRk3dKS7KI38KpRqxXJx1WasLIgskpiaIaWa9JLINXp10qrzvD1OH9vsuMoqeRS7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513915; c=relaxed/simple;
	bh=ktRJRBq5SbaIGxFutR22jMTT4kI/M5SWUBM5rra62Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p+DebKtf6+ACEOBxo9IPHr+Cp2LbPRyQVisvT0a0EOeoSCQPjkSXXC158ywDIunFrYGiSzudO91YkHRRBVFGYAZtQrQJjhIkso7wEQbBnJEkqolebQ4CFXTrnNxYyHhg1S6G0//UFRpOBtFVbHDHSi02X4/g85ELZQfSiT4NYRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Eg+ryKK9; arc=fail smtp.client-ip=40.107.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ty7MFck0xN2E23T3u/T2j0sSaWTWmJWJPseHUdTVcMhH8/4X8qnGuqsXbDrKkBTF4LVxEsRNCGGbPSoB/GKpG4PAYUUkvOZpC4dF8CxgmrFxLFpVv3MdJLzq0HueM2bRitWJhrUh0Obp3BX6ukeHwjiOLAGtV7xOdssQMU79aB1exWRJSegZn8tv2nDeqFNXg28uQlrTO0Bq36lXLYkUV20bca26joy+bLlcEVGBhy5AkbdoP9NNzaq6iwt0Xd2OhjcFcl7MmPPCdJjcsN7a/aoX9QGaE61skLJCgqYZjEEiZ0aGb979zAfdPkVPFjkAxSrbn1qfqkfiKAkQJUbp4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsiDGmJ5UkBmdWMPnXu5ZHNwCefF6FbGwfd04cc+QuM=;
 b=DdDApl9y0G4nIcN75VVLIDkgelYi/JbBgQbjf7Sly0uYAZdLr4aVTCtp4K+LLa3nmmCM7YLb0gbMLWIl+D/+YbcvtRnm4gvMuuvlchnuZtRX1veB1Pcio64M06aGIOqBTyT6GMmBCtQ2bPfDUsWOuug8Y/aGDbJjl9o3UkX68xRsgmuMmNTiyH/wXGQ/CdTjq0nZ/yOf/Vw/MtLTKxXHj6C9YvDpSaS+Rx6tNi9ylxkxK5fr8goatbAz85JSWCA4jyHO/NgIzr9tlB8lhiLjioGcIeszDneVTp806v90qZJBqie+CWM+1IttMPpr2V7m9ZbRV3eQ5fQxqoElTqIKiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsiDGmJ5UkBmdWMPnXu5ZHNwCefF6FbGwfd04cc+QuM=;
 b=Eg+ryKK90V4prhBZiukJiDU/QPWI/0TdASG+IGmRiH583TO63Kd5NuBjdbSSOnHd5joftXfyjoEpTYXT2UdYySlOizON6hH5rx0wmJf77rksd5PAfXGLvy73xW2+0b0IHwMBy0WAIc78LQXbxPBYeARJ/briZzYKAYB3YtCbkeQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by SA1PR12MB8119.namprd12.prod.outlook.com (2603:10b6:806:337::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Wed, 6 Aug
 2025 20:58:30 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%3]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 20:58:30 +0000
Date: Wed, 6 Aug 2025 15:58:24 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, minipli@grsecurity.net, xin@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v11 19/23] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Message-ID: <aJPB8Jd5AFKdIua3@AUSJOHALLEN.amd.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-20-chao.gao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704085027.182163-20-chao.gao@intel.com>
X-ClientProxiedBy: SJ0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::33) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|SA1PR12MB8119:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d5187a-fc46-4678-ec03-08ddd52bff6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yr0hsoJJEdCeasSH598RrF4kh/l68PU6RTm/DEYkfw9trHnCMIbbazinQphR?=
 =?us-ascii?Q?CnJ8q0V6iUBggVaVO1w3EFti3gyivWhNfAWEVnvuRSJFLJbM3RpQd+Tmc2T9?=
 =?us-ascii?Q?pR2aWTp+drT/zl57gsu/1ZVdGCv7+UN1SLuMT55E8UJtAWMS+qmFMNmHXkc2?=
 =?us-ascii?Q?a6/XDgUhEy4cEKAlv5PZAx3CUF0K+OSWX/AaX5xJ06we0+WJeBtVx59aXlwz?=
 =?us-ascii?Q?YKeNaI1tg4aCb3JwUkH0YTIDeKZfKsee83J17qDdnky7GAMo/q936tSUCqxT?=
 =?us-ascii?Q?mYPcPTDxVb6mSc9vUmTYwebE8WJ6spYHxhtWivs06Klda2MVe6dUGSIYnYpZ?=
 =?us-ascii?Q?Z8N3JtMBuSs2LdV95Y7cFxhU5CmyEBMc1j2AqutokmJRQ3l3AfVowc+CSDrQ?=
 =?us-ascii?Q?UJyXs1Je4FCou3+9g/YekXqmNzfJhSNtPSF86oR0o7BONaTT3d76xqClac/d?=
 =?us-ascii?Q?Z101PxaGJyf7akLJIVbiysdNqRSABHFYc0GXAFHuEORJ3vFiSn+zA/1rijBS?=
 =?us-ascii?Q?1GZ/G/J9+Q583p/XyYQHsd87ifRYW0YjwvmD8rrN0nTy+sQHK/KLacgnZWv+?=
 =?us-ascii?Q?TXCj2HB4P1g92B08sjW88raO+56lrMGwXwHabr9vSb9JdVCigJWUJIC5TD6h?=
 =?us-ascii?Q?haR5wH2tIkciPc5Xi0a6chHNAWVuBcLSjY4F9lVb23B5oZvP/tljr4kD4wAn?=
 =?us-ascii?Q?BjxqC/IbFgqkJtqx1b3fpzFh+IWTFqd96F+7v9RDF6U2/Tzi7Mpwdi7j7i7+?=
 =?us-ascii?Q?p7qYWfnCjgURWaVQbPAfuFVTO3jmwH93UhGmkYlt1MiWer7jhbw9c36NTJze?=
 =?us-ascii?Q?O88PH5/KHRiWyuDqyDd4maCI6U/u3BVrlTK7AB6PGfGTm9h5pSuoh3FZSNsi?=
 =?us-ascii?Q?SKpVJ8RGS4EV1Ie7r5J1aqdzqySMInGtobfjPvtH+QOkiRvSlnIRhG0xVcK1?=
 =?us-ascii?Q?zMnkX935SzNrIcxaWWAIi+GB4qpoq86WynJ1qdU+UgaXBUDXOLtlrtV4hd80?=
 =?us-ascii?Q?qJ/RBjuGYL5tVQuVThUnBUrvGkFP9ZGupxqNJf92SYC8QQ5UMt4cNAsYjkng?=
 =?us-ascii?Q?bX8RyROxgzAXKYte7Q9RCHXORV6WiPHR/CZg3jA68aDQzJvtBXBjM7t+nPXI?=
 =?us-ascii?Q?YI1CeH/8J3eBXf+dL5gF/iVWeZ5A3aHUpVhzPubgCLpiSAQv/FbQJ6OvhryJ?=
 =?us-ascii?Q?jEGC1QaxJIdD4xnouRp9eDVvTQ565fJ7tSw0zm9CjFtPkS2fr7jdUk2gpvFh?=
 =?us-ascii?Q?HiwPhjse8fJNkEWi5i8DRTrd83PIOSvctVH7S0MTThSi5ydN2rz2lxGfmlsv?=
 =?us-ascii?Q?HEQEMQbKvL7KTaYYDTA6A3AaN171zbsQ6xTJ+b4RU1ZUAQBSlJpgCUrijiDW?=
 =?us-ascii?Q?YBwuQovf8uJBLNOyhhRt5kEF0Ftz93F2KQqna43l/x8H9POGaxLSrl+b+pnM?=
 =?us-ascii?Q?b4GHwaxlJp8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ODv5+0t2bkkbYZ6oI1kAAkJOy5MoicveRkIQHLQBMpesy8LjjiUdNani3g8s?=
 =?us-ascii?Q?Uukt5VZ2hF626FiuqndgGjPI4eUFTcS0+l2YMkzEYY4xpZXE0cq6eL2xCZvt?=
 =?us-ascii?Q?zwg8zuUreHE0ISrE0RhN4qNXwXthZh7T+ziA8xi5Aig/p/BERc5V/ER1SB6X?=
 =?us-ascii?Q?fTNOK40XZpxI896H620UzMFGv5ALY69wZJf0ZrG5dS5RQLnww0mrCqIkuzM/?=
 =?us-ascii?Q?D5+tTc0OBSSIstrz9bQGX3BRc2Y4cIIuIUEX0X8JdW0PFTEKFz45tSA5Z/Aq?=
 =?us-ascii?Q?yHQW84pv73v4RfUdW7S8Moop4KjSMpPQoPs2jrb7QOV1JcDt3T8H/DB4YEF9?=
 =?us-ascii?Q?BGCWgqbUgx7q2hBKWlP7FyoT1WDcMXAbZbsOWMSIR1oKOZsEYM3pxnZdfH0p?=
 =?us-ascii?Q?qkrN7DvxjNpjmSPgcTMd8Jx4f1Wnl9GAyrppHc8/o0bUL6LLO7mozxjASaTv?=
 =?us-ascii?Q?HiEzVilA+1PVc0bVi6VuELpVMMsb2RI63rup/9tzuIwu/BMm5R8SvENyMpuo?=
 =?us-ascii?Q?lfiRPrrSGIPnkujmiCdNW/Z2EVhiEwlvgAm6VabIdew48SVqLz3ruTkLDYK3?=
 =?us-ascii?Q?lphaJRK1TB8bZHlpJCMMcINMEdTUiBMAjf6N7k3IGSDHPnaLq7AiEdHRHiy9?=
 =?us-ascii?Q?k29678ovJoICjdwY6eRNkrHHO5HALUCiU3CMst6+IsmLPggygbJTItHQfQVa?=
 =?us-ascii?Q?WpJV7cZ/7eerEz966aOA4e1DYJ3tQ7ZsMCm0Ac6flrGoFRfATPZPNbsRKk6A?=
 =?us-ascii?Q?JVcIF8Blb2E/+vllA5kIspLD3GHZvjQ2sEjtEWHrrXTxjZPqe0kGGKp3PV/D?=
 =?us-ascii?Q?MHEOkdRVIy+tl+U8divWzlfk0TExv7Ng6+ccpyIedpzrgoDqPEyYFjY7VK1Z?=
 =?us-ascii?Q?w+zFUxXyGvmK3z44kBaLSMnI7N7gY+4RIaH3fXBQQJIOXp/8w8yerRvcpuBD?=
 =?us-ascii?Q?WdE0Z+NVq+2G3akp3ayjuUQj8rHGYpmcb0nJ/CnS0K36gKu2zYrr6Iri/sjo?=
 =?us-ascii?Q?OEQDD3JHkxFz8ZD/H1k2Z+q1jBMwBJtRAuXvUVoNwv0d+wveutZD3CFDjCdu?=
 =?us-ascii?Q?77het08G4N7h0qyResD/OZ6sefH3a8devqVJa8+F8BjLKdIheTAFB3H19bxZ?=
 =?us-ascii?Q?yh7M/a149B+bilyUx5Dk+RI/hPAImV/QL5gtthmJY3bhddthI7YiU1990jMQ?=
 =?us-ascii?Q?gel45iU07zH0nnauhujbDjQCU8LWIOLOgwt3o+Bjm2RGyB+B/Pl7S0cr199h?=
 =?us-ascii?Q?zpBkov2kFwtcsHlptDn4fNygBtDwuyb5vtXNIurIy8XbiCwvYtDHWIvmp0fr?=
 =?us-ascii?Q?2F06r8VfRiHLv0tCZBX3dWGjKqeVsXMELkejY5ilYkHWJF0/ryhKGBbUAHSO?=
 =?us-ascii?Q?X0eeniFdkokfAlXzP0q5YhroaFjsNI1LaUEOlK9fF7WYzUmDYYt23Id9jms8?=
 =?us-ascii?Q?ey5easKHFHDtb8HYkWsFjebbG4yBWxH+QdLwWVpLpHswDy8ox4/TD3x2dCEE?=
 =?us-ascii?Q?5TcUODdXI+Uqa5qVuMsjv9htcG/LV1nHwCPgQPxmuf3RVVOIDKVQsy2vIORc?=
 =?us-ascii?Q?HDsZdwz+TH4ZoV94nZAJSBghzK0fkduEXUzlulfl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d5187a-fc46-4678-ec03-08ddd52bff6a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:58:30.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQyj3I4xdDDSR/w9ShZ3I3ZlzdOPQJKIP3+yiteZET/VTAIG3SE3ATHEyU+yDmZpqW8AnK+hiQqVxJ6Ez8Kfcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8119

On Fri, Jul 04, 2025 at 01:49:50AM -0700, Chao Gao wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 803574920e41..6375695ce285 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5223,6 +5223,10 @@ static __init void svm_set_cpu_caps(void)
>  	kvm_caps.supported_perf_cap = 0;
>  	kvm_caps.supported_xss = 0;
>  
> +	/* KVM doesn't yet support CET virtualization for SVM. */
> +	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +	kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +

Since AMD isn't supporting IBT, not sure if it makes sense to clear IBT
here since it doesn't look like we're clearing other features that we
don't support in hardware. For compatibility, my series just removes
both lines here, but the IBT clearing is probably not needed in this
series.

Thanks,
John

