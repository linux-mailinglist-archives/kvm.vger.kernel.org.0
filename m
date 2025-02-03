Return-Path: <kvm+bounces-37129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8140A25DD1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 16:04:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1303B3B22FF
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 14:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EC62080E3;
	Mon,  3 Feb 2025 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0gWaShIM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D128208A7;
	Mon,  3 Feb 2025 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738594134; cv=fail; b=vAQ9LkAdhIP36OJjr80qhbp0EwkjBzujk89cMfERkKAvSeX1Tfl3Y/tsxGKtY9wC2bFRQfNbynvaDUIJPt/eGDQlexXtYDGyrk7YrxOr4+fkBJz6vBRiBWkx2WiPDuCPWA425xjGQHDLYpG3GO67Z008jLAtAC1NHbsnZjLBYSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738594134; c=relaxed/simple;
	bh=HqM/tvLKdBro7vJ4p9aPiNFYqKp1cbH0IWB4zP+DHCc=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=H5r+H+0cVN0ME8DWiwwiGLiW5TlF9DanET3e0Oz6t8BfDs348J99QNIf63PqKGd6ZXmYJr0Lu/l7qmpdtFrPNepsWl/5RSFZphhKLhdrom+3BYeoZyeDdaWCYQ3f8J3c7QuiEw/r0r2pSUS4sf9jz57BqKj9xtfINS7jTzyS1V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0gWaShIM; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Novb7fr4vMfr6PAc7t26o822JKOLKePm9gSys9oq4R3pwA0yzWb8OPmz5ktFN1RIUqhrKUdz4LT5o2OERUHVfyCCvE4xD8uwCwljPPTY7W8Ec8/ygY+JMdzYjzmdJtNEHLee4Uzce+99UmvRbFkP8n575qhiOGQMlCNU5eYCKpKoqTrjrZHdeGCVGbelD2N1HlZ1kEgFIG/w0sRhyjId7JN0LJ66nz7Rlg7xJnlByVqvPTW50Y+cnGi47YUa50UwMV1BzRjRNlq2Z3usMutHL3GNA5a3ALrRRjYhKA2iat9YV6JJdTGRXC3G+A2Quo/HxSWqCZFXpXYr/rk5iCkhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r78YZbaeA7qB5IVVwH+4w/SZUJsyTdTm3w6XW88Llmo=;
 b=WcVwC85rzdkjLhG1MOcmWD8C8Av8ds8uiZB0QBasnZlEMay6QncAbuSmQF++NTHcFX74JjGPcK1w11c04tYGGZiT+Mpjp8ARG5JwCUmcHVIcSyWV8tJXqmt6k8LsxkDP62YB4699Z83Ndmxl9H7saI4mQG6HhcmSHP0PE3qBk0IkYfku7l7v+fEXQ2yAVlDwMi9V297kqDJTl3RyLgRpNccQBdM8r6ksy09bkmDbLX3UPSYmXyPHqNRyagkDUa3nF7SISLH7zAPY4SvSy955nHblvQSrKEQ290DQ5ZLKyUqSTqk0P7QyfChOEiJEjqtVX6Kydtbca35wV4+09rx4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r78YZbaeA7qB5IVVwH+4w/SZUJsyTdTm3w6XW88Llmo=;
 b=0gWaShIMOiq3DVjMXp6goyUryIijjtxS7tKF9334TkLhUYS32oQCVss0i4tksf3Q5A1LDJs4YkjNyxkI63LBC7FmKeb8Okvgeticc+R+93XkJvIbKUxYZOjG8SxOiEvmCCobldFMxiskevfuWLznedRTBzprCFLRXrgn4Ad13VY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7561.namprd12.prod.outlook.com (2603:10b6:930:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 14:48:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 14:48:49 +0000
Message-ID: <fb1d32fb-f213-350f-95a4-766c88a6249c@amd.com>
Date: Mon, 3 Feb 2025 08:48:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Juergen Gross <jgross@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.amakhalov@broadcom.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org,
 jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Nikunj A Dadhania <nikunj@amd.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-9-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 08/16] x86/tsc: Pass KNOWN_FREQ and RELIABLE as params to
 registration
In-Reply-To: <20250201021718.699411-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:806:130::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be59b7a-6776-4b7f-04ef-08dd4461de9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGVISlNTWTBKbkd2b0pEZk5zYTcrSFZYREEzUm9xNkVFcXBrZlM1N1VUNzBI?=
 =?utf-8?B?Y1VmUFFxT08rVGFSaGFZT25kSXY0dWZNOEZ5U2ZiMStMWUcwS0dUejI5UjNT?=
 =?utf-8?B?emx1dFB6cDMzSmt0a09FZGlhNVA2S0lmNlZnYWN5VFhDbmdmNVh0VUZpUGhS?=
 =?utf-8?B?eW05RkFMK1BoWk5FSUJEL0xhaStqbkZUbzFOQndGbnFzd0FKNVZ4ZGhRYnFS?=
 =?utf-8?B?UFpPcVo3MVRXd0dobGlpUVhoRmZaZGtnSTZFTlVheEFiRVQrMkpVYmN3TUFJ?=
 =?utf-8?B?MHN3dFpVMEttVEpIa040QnNwK0FFV0JmRWprV3VDRVNOT08yZm5iU1R4UGFH?=
 =?utf-8?B?OEM5Q2c1UXluS0RtVDBkOG8rR3MxQUpZVGdoWkc0VWI1cXd4cDJnRjcrcnh0?=
 =?utf-8?B?eEhFLy96MU9tcjV2Z3VXKzIvd3BjTlFkY3g0L0w0M1hUM2hIM0pWbS9MNnlG?=
 =?utf-8?B?VitIYW5pRjNML05URzl4QUFVYTVNREJ5RldVL003ZXRUMitxd2xLSjg1M2dP?=
 =?utf-8?B?bnN0NXB3M1dPQm1KMDRXR1BBOENpaEdMMkhKeEZERzYyZndxY0xsT1kveHVj?=
 =?utf-8?B?NjNWTUMreDVhT1VyVlNqMnFqUE9FQWtYQmcvNnZPOHZrOXJrWHpncVMyZkIz?=
 =?utf-8?B?ZTFpbGxkRFR5WTE4OGVwclpCS1ZmUHA3MDRnSGZZRHZNc29MZXZXY2c4R0JO?=
 =?utf-8?B?MUROUnFrNGJpZ0hUajE2dVA2VkN0RGNNQ0orbVVNTEJyQ2RZYTlsdW1uUjFR?=
 =?utf-8?B?dEtMWXpBeDdFcThyZTZ2N242NVpUS0ZOcm1DSG9pZ0M5MmszMjFzWG10bmgv?=
 =?utf-8?B?SXNFTnNMeVQyK3ZaSHdxaHR0d1dwY3pwU0JRVmpqM0RIVGRML3Rjb3orNVNp?=
 =?utf-8?B?OGc5OWtMTzVZcUtURlVJVE51d3FPdlVDVi93Qm1ONktiSFZxemJXbkR0RUtV?=
 =?utf-8?B?NVh2c0RpTjZKWkF2U3BNTDFLZWQ3aWF5bGxjSDd1dXZJR2dYdVdJcSttQjNW?=
 =?utf-8?B?aEprZUUrM2FYeno4VXMrem0vNFBERFk4bi9OUStlTUNrQjZWUU5HQ0FBajVG?=
 =?utf-8?B?d1p2dTQ1NFJxNGxWeUxpVTFUd21VYS9IV3R5N2krbTYvQ1NwaU1KVEFTd1JI?=
 =?utf-8?B?NG95V2V0U0NJeVd4cEk3WE56Rmczb0pPZW9yTElYNFdnR01Mc2RkK2YwVkJm?=
 =?utf-8?B?cGwySGQxbDcvTVBwS0ZmWm5BZ3h4L0VnYnd5WlBRd002MFRqTFN2TjJWMDJH?=
 =?utf-8?B?SkZiTFJscy8xTnVNd3gzbWtlcHZkbVJ4cGVuanNmQjdXbUhEOThNcmpoLzNy?=
 =?utf-8?B?NWQ5YjdGZ3A4RmVQVW5sRFZoam5kZngyYXRnL3pteGNhUWV4WU5RQ3pzMlht?=
 =?utf-8?B?QmNXZSs3OFNCa1ZIS2xoaGs2SmxTOFhKNGNrQTBjTkRvbmhhVyt2cERWTHEr?=
 =?utf-8?B?MnEyOFRNMktWMEJxV08rM3lZVXVoc2JES3VaVDBlS0cwWUYzVXRlUDQ0bXhy?=
 =?utf-8?B?VEk2TFFJc0hZWlhvMmFjQnpjVVVZenBid3EyeDQrbXJ5Tkw4TWlnTG0waU5W?=
 =?utf-8?B?VndieWNJVnUrdzJZQnhjSzkzcGRZK0RSeXlxUEo3RG9QejF3S1Y4WmRzMGJV?=
 =?utf-8?B?ZGYrYkd2V0J4TUtFWUlEeVNreDB6bnZvSjF2SVpaT0ZiZzE2bHpUNzd6RHlw?=
 =?utf-8?B?QUlYREdqTVpsK3UzSVBRNVVycmlhN1FXM0dPODRubU9ZQTFUck12UnNidW9a?=
 =?utf-8?B?STh6NkNzREc2RHBKeStTbXZLSFhGSUhMQVMvRW9RRE5iaXhGNkVLRHc5WCtk?=
 =?utf-8?B?TjNZTXdQcXlZNEZZd0FUUW9NUWFPckFrVTNCRFZ2NjRtTGVnVDJ4ZFczSkk5?=
 =?utf-8?B?RXQ4UWNYNHNPM3FOV3BiVGVQa1JkYmhGUlZRWnY0MlorakFDdThpTUgyQzh3?=
 =?utf-8?Q?RuRGtQKpSK8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW56MzZNV2xYNGRXMmtRU0tpT0RWNWcrWm8rTnk4SlZSdmpXOWZVaUt4eHY1?=
 =?utf-8?B?bHJmQ2lVeEpSZktzMStQL2xkOW1BTzBQcjYrVFpsMUVpNkkybCttYWlndXhj?=
 =?utf-8?B?UDcxb05HZEtQZFpHbFJRQ3IyemgwcXRaM0dRRjNwNkcyL2QwUTRTTmdRVnJy?=
 =?utf-8?B?SUFKQTdHS2JMWlVJbER2bENxais2UXFKazhvM0NQWWkzanQ0a0ZFNXVUTTc3?=
 =?utf-8?B?eE43NWlJYXg2NWVUenBMamFxdlR6OEFXSnV2QkN4cGdpRTJEZ3JEL2Z5aGI5?=
 =?utf-8?B?bWUwTkQ1YXY4MjlGeTQ3ZTV3eG9xbjdsRkhQTUx1T0NYcGpmcjBmdE0wV2lE?=
 =?utf-8?B?R01ZZHRlYnk4a2l1M2JVVldKTllyMnhkd0lZMk1wQTl0Y0E4d2ZLYnVvQ05u?=
 =?utf-8?B?QnJYZWwyNVdEOStudlhxZ2U3TitrMHRMaFYyNjdjejRGdXpYNzNaN3VDWVNm?=
 =?utf-8?B?cUxLdXRvWTVKdndFY0d0bVJSOTBVUmdKQ0hzZzRPdkpXZG1GR0lWSS9rakhM?=
 =?utf-8?B?NjFaVUhjQmhCM1BUUDVUd1VMalN4TXlSaWxRYUFIOXhHWmhic05GVHA4amdK?=
 =?utf-8?B?ZkFvaW1WSndzRyt5a1poaDU0bW5JWlFIakhzQjcwZTJWZXNDeFBDMlB3VzR0?=
 =?utf-8?B?UEg0N21aQjZrb1FGSWJWUzdCQ3VYcjZZUFdCZTM4M1pDclp3UGM5R0k3VE9S?=
 =?utf-8?B?ZnpIamY0bmJNNmF0eWREVHhYTFYzR2pTdXRmWFgwSk9lZHZyTnpDbW5BN0c4?=
 =?utf-8?B?b2dyeWxIdjU0UVhtSDZjbmJKMHdIc2g5SEV6aGNoV21CSWIwMHNwY0tMUStv?=
 =?utf-8?B?N0dVaDRaUFBiZE5DQ2Iyd3p0WFNKaTZjVDBLbW81YmJDN28vVjJsei93S3FK?=
 =?utf-8?B?VnUzMFhqYktPRjNnRmdjMXlsZXo3UU9tb3p0RHhudWhub3FTbDgwWmZJbito?=
 =?utf-8?B?b011bmpkTDFXYWpIYTd5bGtHSm80WUl3VmRwaWxxU2tRL2N3RUh0OFlCZlRs?=
 =?utf-8?B?NmlBQzE4OThub2R6Wlo5RU5RUW1XRS9rYTJEQXQyT0ZITkd3YTZpcVhWaTlj?=
 =?utf-8?B?WTJFaHRHQUFjclVZd0wxQ08rcWxSemUwNUp1MHF4bit4Z05Ra3FwNUxVMEx2?=
 =?utf-8?B?b0U2ZHd3YVJ4ckhzWXJuYjRXWmJpQmtzUFRoaHBadUcwZnBvcEp0VnhoUnRi?=
 =?utf-8?B?bkp0U1NQVVQ5SXlURVU0VjM2Q3JoZFNZTloramNwbXYwRklRV2t6Qk5zdk5Z?=
 =?utf-8?B?cTRHQXEwOElHTDRtVmxGRm5IVk14QmxWcWlKdG5hQWtPVzBrVUhPeGVSZmF0?=
 =?utf-8?B?Nm02VTRoNEMySzZ5V2JwcUt4UHpXYTV3VERscktCb3dKaU9HbFkydi9hVmtG?=
 =?utf-8?B?SWxhSVdWSkhoN1BrTUM5d0NWTC9mSW42U2hsQW5tT1ZCU3hiclVValBlU0Vx?=
 =?utf-8?B?L1V3Z3NiQlpFdGhIaE1MSTlIbW0zUGwzRlJzMSt2a0JpRWVaRlJrQkgxOVM0?=
 =?utf-8?B?MnlWejhxMzF3ZVNtS0txMTh4WjVxZ0Noa01hRjk0WE4vSkh3WjBxK2VuaVg4?=
 =?utf-8?B?NmIrM1dMRitFK2I5dXhSaVplTWdCMzM1SG5aTDBMQkxSejRYdFoxZFBMY01I?=
 =?utf-8?B?eEQyd2FCeHdsaGJkTHIrOVdlWnJiQzVoSEw0Q05Oa1cydXBBQ3ZHSGh1MHRK?=
 =?utf-8?B?ckdjaWt5VGZvUkFaQ0pLdGcyVUU2R01DM0RWVmZnK3FQMUtSemV4QnRPRjZZ?=
 =?utf-8?B?K2piOEhuZlQrU3NOY0kwVy9hOE1NZFdzTHJuS25icTBqVWhod1BQTGd5ZDFw?=
 =?utf-8?B?M3RJREFuWjduZHRjWmRRZVh2bW9KMEZoT0xDZDJCVkxJRWJpU0NMeXdONXBy?=
 =?utf-8?B?VjRrbldLREpPcUk2L0Q5NVFBeW52emhTcVFQYkxvQWRBbmt5aXkzUHI0YWhx?=
 =?utf-8?B?a3p4QkFYaElhLzh0dlBqMzBsallia0xEaWMvZjJnampaQ0xZL3NBS2txL2ht?=
 =?utf-8?B?QkxWVXhyd3R1VHVLNk1jQ0tKSHJEeVdnTHJxM25GNnpxYmJKcFE5ejlIQllZ?=
 =?utf-8?B?czhNYnA1Q2Q1cTlXYzg2OVUxWE92dXZ5TkNPOSt0WUNjMjJLZnJBVXRab0Zp?=
 =?utf-8?Q?ybPaDDH54z8L0iYkYQNigiqdQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be59b7a-6776-4b7f-04ef-08dd4461de9f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 14:48:49.6012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ek6RKNzoy2DrdFNa4zHbDGzVcDDHz/L4IbxaG0n0uv6SXsDohFzDMI8PghqCicr0LhHy+aGjFBdRqhK/ZK2D1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7561

On 1/31/25 20:17, Sean Christopherson wrote:
> Add a "tsc_properties" set of flags and use it to annotate whether the
> TSC operates at a known and/or reliable frequency when registering a
> paravirtual TSC calibration routine.  Currently, each PV flow manually
> sets the associated feature flags, but often in haphazard fashion that
> makes it difficult for unfamiliar readers to see the properties of the
> TSC when running under a particular hypervisor.
> 
> The other, bigger issue with manually setting the feature flags is that
> it decouples the flags from the calibration routine.  E.g. in theory, PV
> code could mark the TSC as having a known frequency, but then have its
> PV calibration discarded in favor of a method that doesn't use that known
> frequency.  Passing the TSC properties along with the calibration routine
> will allow adding sanity checks to guard against replacing a "better"
> calibration routine with a "worse" routine.
> 
> As a bonus, the flags also give developers working on new PV code a heads
> up that they should at least mark the TSC as having a known frequency.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/coco/sev/core.c       |  6 ++----
>  arch/x86/coco/tdx/tdx.c        |  7 ++-----
>  arch/x86/include/asm/tsc.h     |  8 +++++++-
>  arch/x86/kernel/cpu/acrn.c     |  4 ++--
>  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
>  arch/x86/kernel/cpu/vmware.c   |  7 ++++---
>  arch/x86/kernel/jailhouse.c    |  4 ++--
>  arch/x86/kernel/kvmclock.c     |  4 ++--
>  arch/x86/kernel/tsc.c          |  8 +++++++-
>  arch/x86/xen/time.c            |  4 ++--
>  10 files changed, 37 insertions(+), 25 deletions(-)
> 

> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index d6f079a75f05..6e4a2053857c 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -385,10 +385,10 @@ static void __init vmware_paravirt_ops_setup(void)
>   */
>  static void __init vmware_set_capabilities(void)
>  {
> +	/* TSC is non-stop and reliable even if the frequency isn't known. */
>  	setup_force_cpu_cap(X86_FEATURE_CONSTANT_TSC);
>  	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);

Should this line be deleted, too, or does the VMware flow require this
to be done separate from the tsc_register_calibration_routines() call?

Thanks,
Tom

> -	if (vmware_tsc_khz)
> -		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +
>  	if (vmware_hypercall_mode == CPUID_VMWARE_FEATURES_ECX_VMCALL)
>  		setup_force_cpu_cap(X86_FEATURE_VMCALL);
>  	else if (vmware_hypercall_mode == CPUID_VMWARE_FEATURES_ECX_VMMCALL)
> @@ -417,7 +417,8 @@ static void __init vmware_platform_setup(void)
>  
>  		vmware_tsc_khz = tsc_khz;
>  		tsc_register_calibration_routines(vmware_get_tsc_khz,
> -						  vmware_get_tsc_khz);
> +						  vmware_get_tsc_khz,
> +						  TSC_FREQ_KNOWN_AND_RELIABLE);
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
>  		/* Skip lapic calibration since we know the bus frequency. */

