Return-Path: <kvm+bounces-20614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7B991ADA8
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 19:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DC671C223CE
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 17:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A3819A294;
	Thu, 27 Jun 2024 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2V1wl8dG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E70D198828;
	Thu, 27 Jun 2024 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719508389; cv=fail; b=VrP37S/FJXmCVucUTgyLmOmlP/FvC+yXfTVbhkJXy4Gp14OzadSnygCKbfS2kWQ+knFoejndEgY7ojYlTQTBGNirfhb8BUU2g8XzYvdbaWoAmCE2sup+ydTTrnNRUnUqvPbKmKOvJbasLeK6A3vivvsU11lGCxTJB21RkR3le8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719508389; c=relaxed/simple;
	bh=33TSuJ4mYN11R7yyfpsWNUzVAKiZyqUWUTWHcbUOw8w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fIR4q5buaXhGc2lj2fHs2yIIyzoGipnTvAR4qL2l0qFJ4lfVtgxtBWNNIhn5VtTbwuE7/UfvdQAoAc0U2B4IHMLu505K5g2J8vRQLKDTorkuNBe4RX/UVIsJA3iC5HIVz95d4KO9cJfgHMPth/zW5Vf769xfSwfaZ1UsT+4LR98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2V1wl8dG; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaoJiazy0N2XWXnj1k5Qq6h4lvHj1ae/+C8p3NLQQjoFUcHdSKFkWzc5f1H0deAT7e5T5QxgM2RCq+fmuvNec/b/w0Yj5VNgEPxqahaiUWVsR2a+KbB1eJfksIoGyyfU3R6z24TaW3h1/ldikh91U/R3gjFIDFqeLdo3CgkvfLBNxz3AaIGDg6ucTBntGVNe4VkzSTYVnirbirrsZoztaP2yT0uxjVLz8jrV0dLUruQ8mi4dqTnROpjg7XUHF/ZFW33/C22SbCVMz3sdRh19zHeF/owXkQQek3hJbdGPQuiVbU1Q+8NB4l9dCS/iErbP9UgRBmX5UcDUtv00uv5xlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/hUHvhzfUdOJlSYwsng0Hl3WUCCKWnmqItvj83mrSA=;
 b=T2cBu30l112iANuVTr/ZAGuLi86C3yhRBCsa4Lq/5Mvi4BqIXV3lPsSppC3yb16BrixIA0lsejDmDvzFp+4arfSQeP9pLqnpCmf92QAK++eVpXKL0jr87CRwYZZmJAFabEWAGjt66HdmK63G2fR3idxaO+gGc3AUPao99gKNjjfK4akooUnE8z9iM1tKNUse/lD/axpA1C1DLNLz1IgfyRLqH76s34hsyR4lP/A18i+zqtDlP2UxvujSS37t3VIsT/Y27yX++eQsashIZHe96yF5Wu+9bUG+GtH6N6XXlsUnr3N0UyLCsQH3hw9ErpTifzhg8wp3+vT3aq4hINI43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/hUHvhzfUdOJlSYwsng0Hl3WUCCKWnmqItvj83mrSA=;
 b=2V1wl8dG6J3oTCvC0bMeshkPaiV47dG9MAwkFf5/eut+VsmoY+gXIrxLiBkdupZxQY3/E+jU64E1bZJCIdeW/epW+yaqXw7G0hHEbsImfgZhCAOD8FcqngIiTiXs+zaMvUttT4OYDDeFtginyGKYsCzeBw1Yksvqd2fJZRFe518=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DM3PR12MB9414.namprd12.prod.outlook.com (2603:10b6:0:47::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 17:13:01 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 17:13:00 +0000
Message-ID: <30988934-c325-64eb-a4b1-8f3e46b53a55@amd.com>
Date: Thu, 27 Jun 2024 12:13:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org,
 pbonzini@redhat.com, jroedel@suse.de, pgonda@google.com,
 ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, Brijesh Singh <brijesh.singh@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com> <ZnwecZ5SZ8MrTRRT@google.com>
 <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
 <ZnxMSEVR_2NRKMRy@google.com>
 <fbzi5bals5rmva3efgdpnljsfzdbehg4akwli7b5io7kqs3ikw@qfpdpxfec7ks>
 <ZnxyAWmKIu680R_5@google.com> <87320ee5-8a66-6437-8c91-c6de1b7d80c1@amd.com>
 <Zn2GpHFZkXciuJOw@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Zn2GpHFZkXciuJOw@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::19) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DM3PR12MB9414:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b4b73d-c129-4758-9e71-08dc96cc657a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3RTNTVFbUVFTlM3Y0M0M0xHbjdWZlNLUXBhb1ByMGdvL1FseVR2enpDamVF?=
 =?utf-8?B?aDlQZ0FPd2tIOXE0aTdmUkNoSTkxZGw5YzZ1ZG4xY2RTeTg0YkRIbGhYbXNP?=
 =?utf-8?B?dHkzK1F1eG8yNkRLU1FRVklQTDdEcXlzQWhDTUxTUzlFSVh6MEptaUVJQysw?=
 =?utf-8?B?Um51cHdicm4zb1RUUU4xbGhXejNJbFFZVjNiMzFnaDNDMndoYnJlMlRubXo2?=
 =?utf-8?B?NGEreVBjbkxrV0tHTlEyKzZtU2xyQnZmbWVySWlaMnVxVmhaRW92VndsWk1Q?=
 =?utf-8?B?MVlmaHBZSThzeXVabGpURDBwZDN2UzFRWUc4bG8xMDhvSFBvbEgzcEFhV25J?=
 =?utf-8?B?K1J4WFhjemF0Z1VzdHN0NlhVQlJucGJjTk56ckZlckpRMmRVMkhVb1lGRnVG?=
 =?utf-8?B?cC8zR0dTd2loTjh3WVdLUGlCQW9PS1RzSFJjYU15dEcvenVPY2lpUjR5K1NI?=
 =?utf-8?B?R1FkQXgyM2MySkZHaC9qVEl1N1ZIdFdkZ3NzZUJIOXZWOHJUY05TWTZ0SFlK?=
 =?utf-8?B?R3RQcTFwQlltRUV4ZlFUd2Z0R3hTSXFxdCtiZnhPb05mc1FXMm1iKzBrTUV3?=
 =?utf-8?B?WFY2UVI5VFgwaW1qSUlwSDFDQnd3S2hpZ0RxZmxqQUk4UVNGU3VWZGRKRnhy?=
 =?utf-8?B?QThRNnA4NEQvYjZYdmFDaGdCam5veWxsaWFUM0FOUUl1VmxaYXNEZXhoOW10?=
 =?utf-8?B?SXNab1B3LzU4NmRwT3J6TVRPa2pRZVNzS2ppRlVSeFkwY241OW95Y3pkLzlq?=
 =?utf-8?B?ZGdpRVZDc3c2bzJ6K0FxWGpyMW9tSzdFY1EvTHNwRmhjUlJURW9FWU9Ea2NK?=
 =?utf-8?B?Qy9NV1VBbnBLUVNOOGhGejlQZkplSE9VMnpOSWd0SnhTdXNhcUNUNzJiMGVa?=
 =?utf-8?B?aEx1dkVFMUhpQnZTSXJoTjl4RTlFNUhObjVPc2lGZE8zOE8xMnRERkVwRzRF?=
 =?utf-8?B?bHh1VGJINjNmeTgzdWhkZ2w1VzdSZ0lWbnFoekZCbDNLckV6dGZIbnJjNWlK?=
 =?utf-8?B?L0VDc2JoTGZIbzc0V0VlUndBb3BHa1Z2WGpncDZ5Q3pqdFBlTjV3V2JzZXE1?=
 =?utf-8?B?Y2dybVhSbjNLRFBqMXRjOXRISnBra2hJVHl1RzZ4MmxGUFBSK1VxR2ZuV3Iw?=
 =?utf-8?B?ZHJjSVpWOEVVM3NuYjlzSmg4cWFyNmZ0V0FpMzJoSERRZmp6TXlWT3ovR3Fy?=
 =?utf-8?B?dVpwOUV6WjJSamFuUVBVcXZmdjdKUDVpVEVKM3ltUGl5QmFPSHFMUTNNV1R3?=
 =?utf-8?B?V253VWc0cHd0dlQrU3NqQzIvclZSMVZabzMvWG9jeEV3UTFyc05xdHd0ci9U?=
 =?utf-8?B?ZitjUkRFbDkyMjFqMzJ2OGdueDdERHVLa0NlOVhvSkJLZG9FVWZVb1FxT0Rw?=
 =?utf-8?B?VDlxcklQTldFUEdvNDczbDRscEhiZWlBZU42SUNjS3Q0RFBLSHJRcFVUS0Zq?=
 =?utf-8?B?cXlaR25kQkhGVGxzYmJaSmo1K213RHU0QnRaWk9RbGRuT2c5QW5hZVVWUHY2?=
 =?utf-8?B?eTd5NjlCZ0VLZVY3TGlEMVREcFluVjFMTFptMFg3M0M4ZDZJcWZuRmFINHUy?=
 =?utf-8?B?akd2OThQeXlrQzdHQWhpNk5EYWF2NXBLL3NPOVBqVmk2S1ZZQUNUOHBzdjFn?=
 =?utf-8?B?UkFhaDRXVXdOVDd6aXZseTJUd0g5VGgrSm1vUWhvSkVzaWY5cGFLRGJTTmd6?=
 =?utf-8?B?NEJpYWtNc2ZQSkd5UTFiRERyNk1ZbUVsWnppYXUvSkwyUTVmZXBrWnBtbUxa?=
 =?utf-8?B?dGpuSGpqVytQVEYrQ29IcWdtcW9IelZGTGJJWVZBWGQ3Zyt1eVRZNlY1THhG?=
 =?utf-8?B?RTZoMGpHQ3B1RWZhbUxDZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFo1UExaM3BURjZUWmhxQ0ptY25RVjVrMmU3TFhjUEZLZGRHMnJOMy9WQjdB?=
 =?utf-8?B?ZE95NFBhNUFBMURqa1N0dGlzaUhJSCs4K2hlalFwYm5ZZVR6QWo2NHM3b1JN?=
 =?utf-8?B?K1FncmNvM2JzZW1YL1EvRXNBNWQyOXhnNExXTktxV2NJb1VvZ09tRnI5Y0tQ?=
 =?utf-8?B?M1JIUXFRQlZNQjNtaEF4S2FRK1R3TzB1bE9Mb1d6VmoyYjhiNExDdmRGNkpU?=
 =?utf-8?B?UlVkKzErN09rTkNMV2F4d0hsdmJuSEJ1WVk0WlgwcUhpbUFoZFpEWUZrT1lo?=
 =?utf-8?B?RWxDa2dkbjZXb0dMUVZUdFE0YW1sckNTVW9WWXBUSnRRa2Q0dm83TG91M294?=
 =?utf-8?B?RE9ocHg3c1R4a3Nkc2xkVFg1TlVJQ1Y0NDlYOHVmYmFFRE9URkFiQjdrZE80?=
 =?utf-8?B?Q2FHQkJ4K2pSQkxYVldibDdMcm9oaE82cnk1YWEweTllTlpmVjFVTlVjMi9y?=
 =?utf-8?B?eERldkJGYkRHdU1iVWwwRVNLZ3o4TVlOeXRWSWtETzhOV1l5Mlhad01uaGc1?=
 =?utf-8?B?bU40YnBjUDJJZ0FnZzZKL3lybUhFNVVLSS9WeU5SczV0aDVMTXp1MWVNcVpG?=
 =?utf-8?B?TmlHbzlMUERELzZyVjdleWFRVzJnVVRJbXFzWis5LzZhVDlVL0FJQ0FNaVl0?=
 =?utf-8?B?bGk4bkIwS2RqMGRDNGpiZXcwajhkcHBweElzc2hxU3V0VU1ERkdaL2xiOGRD?=
 =?utf-8?B?eVJtUWNOd3UyMUJwaWhjZ2M3aE02VW1EeVRYbE9nOUFzQ3FPWDBjTG1XY2Ez?=
 =?utf-8?B?SkZ5R09pYUcyVUVRbjVRL2tTWFVZcHhGUzRxS0FpUndCMWxvV0haZ1IxQU90?=
 =?utf-8?B?VFdqbURpMDE2bTNENzgrTnlPTmpTU3VUSkJoajZMZWFkd2cwanZsYmdlaUJB?=
 =?utf-8?B?bzl6WWswVVFvejlIaWZFeVpyQ2hLVG91WEtvSXYyT2JTM0ZucDJ3eFJWd2lp?=
 =?utf-8?B?NkVneExMQmxERjZGQ1kxeEl4WjhHeTVtNXZFRFRlNXAvK3VJdVAyNHdTK2l2?=
 =?utf-8?B?aHVmeU5LbVd0VG5xR3BkcWdveksyRDZSY3NqVzVqWFlOQlp2ckFmUEhPcGpp?=
 =?utf-8?B?S3VwSlpUUlhHME14WDBRT1VQcmtTZzBxMXVvZlhOQkhSRFpnZ3g0dHN3R3Z1?=
 =?utf-8?B?VGxHa25nRjczOWtmb3BmdUNFck1sS25WQ0xvdWcwTzh6OU1aQkk5K2FlNHhL?=
 =?utf-8?B?MEJzZGZuems5U0dvQ01obTRHNkdPRWl2NjFKMmxOMW1iUHVSUS9oUWlHOVlH?=
 =?utf-8?B?Q21NKzNLcGNmM0VpU3RBYVNaTm9ITi80S0d5cFFydWx2R2NXUWw3S0gweUJD?=
 =?utf-8?B?NHo3Q004eWtmWW5tRU0xdWFKSkFsUXp0Y3lmTHluUnI1S0FSNWFYcVJVUGd6?=
 =?utf-8?B?NFpEWmExeHBkWmJPRHhWR2xNWUw2eTJ5QldJY3B4bFhxMHcyK2RReGtOaVZ5?=
 =?utf-8?B?eFR0M25DNm15dHpaeHIzakh4djFvMHJUTks5R1dId0pRcW1tM3JCaFAzUlVm?=
 =?utf-8?B?QmhHV0lqL1RNbll5V0w4dkFHTzU1ZUVtWmtPWFlSYWV3cXJjWFgwK0Ewc0xI?=
 =?utf-8?B?MGlGZzNyeUQ4a3JnSmNNeU1oZE94WTRLRUt2VU1tVHdFSTN0a2gxc2MxK1Zs?=
 =?utf-8?B?RDJPZ2lzdWlHSlpIUUdReE9PS09BYk9kRWk2MTMvYWloOWZ1V2JJWHVJR25o?=
 =?utf-8?B?dmE4VzRPWjhGOU14WXEvV2Y4RlhzenpiaWUyZjFKWFNnM0xGT2RkWDg2WXAw?=
 =?utf-8?B?dDJjZ2lobzBCMlQ5cHQvODg3MFdieHBpaDdwa09QVmg1ZW5HMGNjcFR1ZnhG?=
 =?utf-8?B?bDNWc3ZvKzM4VzM3eDFEU2RyNXZrOEluVEFmNjlkL21DbFBSNWwwbWdnREM4?=
 =?utf-8?B?eDR4MVYwZzJUQlhMcmdJRzR5Q3lNbHNBcG5DL3ZuUk84OGp0US9ScmVQV3V4?=
 =?utf-8?B?Nmt0UjNZbFFzVExDdHV3SkF5TlpFR25RMUxKYVF3R25QU1RWLzI4OFBmdGxx?=
 =?utf-8?B?dUxUMjl0ekxGNmRYWVMxTUxRa3VBQ1V2TFc0VE85U0NyVmc0K0xjUDN5bmEv?=
 =?utf-8?B?M0VNMUlSbEswNlNTTFFTMW1mQ1ZOZDdNMWNBbW9zZ0JnWERIZ1NBZ0dVbmxU?=
 =?utf-8?Q?rQobPYB7S+4p0xp1I/H60I+vK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b4b73d-c129-4758-9e71-08dc96cc657a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 17:13:00.1103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQ0kr0rA8jVYqsAqhMbzIPJJpu8qT61pvH8qc/tggLD8AopSuJUxJZ3W5Vqa4a2uOWFy0xqyp/+qyl2artceag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9414

On 6/27/24 10:35, Sean Christopherson wrote:
> On Thu, Jun 27, 2024, Tom Lendacky wrote:
>> On 6/26/24 14:54, Sean Christopherson wrote:
>>> On Wed, Jun 26, 2024, Michael Roth wrote:
>>>>> What about the host kernel though?  I don't see anything here that ensures resp_pfn
>>>>> isn't "regular" memory, i.e. that ensure the page isn't being concurrently accessed
>>>>> by the host kernel (or some other userspace process).
>>>>>
>>>>> Or is the "private" memory still accessible by the host?
>>>>
>>>> It's accessible, but it is immutable according to RMP table, so so it would
>>>> require KVM to be elsewhere doing a write to the page,
>>>
>>> I take it "immutable" means "read-only"?  If so, it would be super helpful to
>>> document that in the APM.  I assumed "immutable" only meant that the RMP entry
>>> itself is immutable, and that Assigned=AMD-SP is what prevented host accesses.
>>
>> Not quite. It depends on the page state associated with the page. For
>> example, Hypervisor-Fixed pages have the immutable bit set, but can be
>> read and written.
>>
>> The page states are documented in the SNP API (Chapter 5, Page
>> Management):
> 
> Heh, but then that section says:
> 
>   Pages in the Firmware state are owned by the firmware. Because the RMP.Immutable
>                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
>   bit is set, the hypervisor cannot write to Firmware pages nor alter the RMP entry
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   with the RMPUPDATE instruction.
> 
> which to me very clearly suggests that the RMP.Immutable bit is what makes the
> page read-only.
> 
> Can you ask^Wbribe someone to add a "Table 11. Page State Properties" or something?
> E.g. to explicitly list out the read vs. write protections and the state of the
> page's data (encrypted, integrity-protected, zeroed?, etc).  I've read through
> all of "5.2 Page States" and genuinely have no clue as to what protections most
> of the states have.

I'll get with the document owner and provide that feedback and see what we
can do to remove some of the ambiguity and improve upon it.

> 
> Ah, never mind, I found "Table 15-39. RMP Memory Access Checks" in the APM.  FWIW,
> that somewhat contradicts this blurb from the SNP ABI spec:
> 
>   The content of a Context page is encrypted and integrity protected so that the
>   hypervisor cannot read or write to it.
> 
> I also find that statement confusing.  IIUC, the fact that the Context page is
> encrypted and integrity protected doesn't actually have anything to do with the
> host's ability to access the data.  The host _can_ read the data, but it will get
> ciphertext.  But the host can't write the data because the page isn't HV-owned.
> 
> Actually, isn't the intregrity protected part wrong?  I thought one of the benefits

The RMP protection is what helps provide the integrity protection. So if a
hypervisor tries to write to a non-hypervisor owned page, it will generate
an RMP #PF. If the page can't be RMPUPDATEd (the immutable bit is set for
the page in the RMP), then the page can't be written to by the hypervisor.

If the page can be RMPUPDATEd and made hypervisor-owned and was previously
PVALIDATEd, then a guest access (as private) will generate a #NPF. If the
hypervisor then assigns the page to the guest (after having possibly
written to the page), the guest will then get a #VC and detect that the
integrity of the page may have been compromised and it should take action.

> of SNP vs. ES is that the RMP means the VMSA doesn't have to be integrity protected,
> and so VMRUN and #VMEXIT transitions are faster because the CPU doesn't need to do
> as much work.

That is one of the benefits. A page can only be turned into a VMSA page
via an SNP_LAUNCH_UPDATE (becoming part of the guest measurement) or via
RMPADJUST (which can only be executed in the guest), making it a guest
private page. If an RMPUPDATE is done by the hypervisor, the VMSA bit will
be cleared and the VMSA won't be runnable anymore.

Thanks,
Tom

