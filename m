Return-Path: <kvm+bounces-44340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E27A9D224
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 21:46:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71C5C3B9772
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 19:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DED21ADA6;
	Fri, 25 Apr 2025 19:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TJan4NrG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1B042A83;
	Fri, 25 Apr 2025 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745610373; cv=fail; b=Dg6Mc4F8mHM2WKH2M4NjUe+XqIBUopEtGzLsqKM3lm9Y/EbxglTW7bCrrhuAGURdKmigupcyDYJwnyveUQEPIfEjOh+LwEnOjnIjohTdQ7z++AQgj1dMA+qdZAjLviiYKkU9TnfjW1yIRjmix8iKI6FQ3y9aoLL0Sna7xgKeGk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745610373; c=relaxed/simple;
	bh=xqH67gEilDaNt7B07nekStIBwqGxi3Mrm9vL9S42Ivs=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hy6hmz8tmnenA0YXhYVdMJcqq3t+5ZUOTyTfPB8cSnxpcNgZTeJqIPJO2D7jRwEmv1jy7jazoEr4jjIOv+7Pbb8kNH02mWzRppEHCavmJ36XDWeNEbvxJ9GOxMFjqtK3LK/j1RHb3jlj8B3sA6MyPp2+x4KCKdfgPfGEaKlS4c8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TJan4NrG; arc=fail smtp.client-ip=40.107.243.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9l7R1AvcC451Wry+OLa1TP25qgz1yBrc8sCUVucp+p7XeaMoi3Ovf9PED8VIT6azHC2FfXi7I0ax3EKHFKk1JFwi06zFJJtXTzeHCkS0wQpG07Co+b2NXqW6oXHKd1P34rgmcIDcAgdUB3k6OaTRln2XEeWgE6MUEvHHnM2wf85ufMSSo11xU7442TEZ7RBLF1+heYerwAHq6VUVQlfHnuzcXC+f+dErVC/Te6P2JzuJHPVqRe+OGeUbcyH7Jmn/6OFw9qA9k+TYUPj8FyM3gqWJNrsnaHQ4Hdc6UYTDt7oRlAOtIj/WAfRzN3GuKT9nh0kE/LSMlYW461hu0ZwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihC8sFzBhw1eNicdsxe/wjz1igfwQb3XvFlaTXL6U5c=;
 b=wEAVeCtzYW2MsZkJIY+qd+9XNm7rg5LHBShbNk64KqifRJfWPmsknnDMEWJ68m48Hk6f97/u5nmLeCVG9cl5tr88DZUKdxxS1+XtemzDU+mmcJU6KnTA4Yyd9dfbQ2mtChk7jTLpGwoCdh8Ghgm2u4WtKowPkoJv6IT8VkpejhIKdgHauBoGIkcHZlgNqhp0eSpetNUzRZAhSOmvQlXf14F1TFEK+RGmXCJGluqXVaK+oH/QQaevlPhnxbTgxsA91sbuULiXfiBMHJlOY5YVZvrXigGvAve7LKtoNkpssjQgiis1n3k2Yot5aMT9AaG2KHVFa38J4ntsd7C1micSsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihC8sFzBhw1eNicdsxe/wjz1igfwQb3XvFlaTXL6U5c=;
 b=TJan4NrGgUiGNYaFwnGvS9/o2R0Sf60eq3b2vcPtkMegg6viVSFSvRtgk1dwHDQM5PVDmqn/Q5qGrhiuzSd24kCIyWHWGDJviem89qS0PzryJrc5nZD8V51VegGsYIkpyjRKPxvq0DFxxgJttMwu08QdBpUlp3eQndn65fMymFw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL3PR12MB6641.namprd12.prod.outlook.com (2603:10b6:208:38d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 19:46:06 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 19:46:06 +0000
Message-ID: <ff8408bb-b110-4930-b914-98afe605c112@amd.com>
Date: Fri, 25 Apr 2025 14:46:02 -0500
User-Agent: Mozilla Thunderbird
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Subject: Re: [PATCH v3 4/4] KVM: SVM: Add SEV-SNP CipherTextHiding support
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1745279916.git.ashish.kalra@amd.com>
 <b64d61cc81611addb88ca410c9374e10fe5c293a.1745279916.git.ashish.kalra@amd.com>
 <aAlYV-4q6ndhJAVe@google.com>
Content-Language: en-US
In-Reply-To: <aAlYV-4q6ndhJAVe@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:91::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL3PR12MB6641:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b12687b-f80a-45c2-43b4-08dd8431d1a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0NBbzZxUjhEamhKZ0JvVnlmcnJNTlF6ZVBTQUhpOGFtT1dtalNPRnZGYncx?=
 =?utf-8?B?c3dJU2xoN1lRNTRjaXJtemZvakxFV05yV3oyZjI0YU1VdlV1WFZWOUJDdXM3?=
 =?utf-8?B?d0RxQkFlZ2IyTG1OUVFnVmNZbmlpbVU1Q1JhTTJiZ1ZjZFBwNjRpb0JQWThy?=
 =?utf-8?B?UEhTYVFQRWQ0aFBKUjM5OHZNSEJXaVdBYWhXWjhZalVKR0w0cVMyQXd1c3d4?=
 =?utf-8?B?ZHpqZkkyTjFWby9aRk44ZUtoU0I2TUZGSlQ2MnZzREdoYTFVYlJSamx2R2dz?=
 =?utf-8?B?cFA4NVBObEkyTlh1NXNZSThDWDRyRjBWZEtxYm9PaFA1M0dkaWdBa0QyMVBF?=
 =?utf-8?B?alRrK3hEY29Ga0RReW1aUWdXQUJMVm1JRDFkSHh5UjF2MEdGMzd0d0FMaVl3?=
 =?utf-8?B?citRVnp1cmtVc0RRTTBwbnpVK0k3KzYrdHN0UnhTWlVBK1RGNW4za2pHb0Vj?=
 =?utf-8?B?d3Vld1F2a1dreklJbXRiNU5Bd0t4TDlLOHdZREY1YlZ1SythcUEvb2h5TEI4?=
 =?utf-8?B?NEVkOUszbHJnZytZeG56TklpTHZMVVc4NFE4TUlHSmpNTnBDRjNvRjlDbTd2?=
 =?utf-8?B?S1MyUThOb1BzMFRuMUFKcjVhVG1EVVdKK2FySndYT0ZKV2U4cldLZFkzK1h1?=
 =?utf-8?B?MnZqRWc4Qzh1bGNoN0tKVkxwdHhBRTVmemdmZkNCRW1NdE1rVGQzcjh5VFdY?=
 =?utf-8?B?Uk5zeU96dTMyaUxUTUIrdGZET3lQQW9BcStjTng5K2pNSnl4dHgvV2JHMjEv?=
 =?utf-8?B?QkJoWGF0MmpUYUFuT2I2QmV6SSt0cFhDTHMzQ3dOK3gvYnF3MDB6Y1BkZm9X?=
 =?utf-8?B?RXlyZ0xVYy9SM09VeXpkK0h5VWFwQzhGMXVKZkphZFoyYUViMHVzdTMxSzQy?=
 =?utf-8?B?VnZKTmRBVFEwMUxGOC95S3dkVkJ3bVp4L09Kc09wMkdCS0kwNHpLN3pZRmxJ?=
 =?utf-8?B?MGxvL3Bvc3A2dTJ2VTRKRFNSaXFGWU5SNDNpMWFuT29rbmxHZkliZ3VUeWJy?=
 =?utf-8?B?SnJFMWtjWjhWb3JVRmcwTTVieThTSFZ3ZjZXeWU0ZjB5Z2ZmMDZ5VmhpSHNi?=
 =?utf-8?B?SkhrcEJScTMzWlJSc1EwbDdHS1ZKNmJuMGZUNmJxQWZuT2VJcldaSnJiSDdp?=
 =?utf-8?B?OGZJbXNVU095T0hYc21VL0dJMmdKbzRnd0doeW9yUWVmeHhnMXNjZHcrWmp5?=
 =?utf-8?B?UjZSallpcTBvbEpqYWdUV25XM1EzWUZxRTdSOW9MZy9LamxBWHFSU2ROazZ2?=
 =?utf-8?B?d0RnVWFBNzVveWJpTlo4cy9aNXhxR2FKNzlVaDVPbStKT0F5QnF0dVRrK3hP?=
 =?utf-8?B?WXF2cUI2SkVESDRkZmdzbk9DdUpBNWI3TDJ0Sjl5aTg1Ylk0a3lOZzlZQUFr?=
 =?utf-8?B?S0hDTlcyU2NtZndkNWtWcVAvTkdzeXJBcUlvbVBhM1plZTV6emx2ZWNCVzBa?=
 =?utf-8?B?ZUdmb25aQkVXSDNpbzREdGtlTHpyaTR2S2k3eFJrOFkvMkVmYzhQZjV1eWdT?=
 =?utf-8?B?MkZPSEUxc2VVakRQRHB2MENtZjNJVUdUYVlSZDNTZ2Q2dDYwZHAwaTNIbmxn?=
 =?utf-8?B?RzBmejlBQ1BpWXprcXFjT1orV3Q2dnhMN1RtUlEvQVdIbjRVdU56bnpUOW9t?=
 =?utf-8?B?VC9SYVZlb0NYTnFHVHA4a3lRNDFYeS9senZBNWR4WjlXenpiRGRJU0h3MUJn?=
 =?utf-8?B?V05DeHBWclp3emZpSDVBdE9qeThzZC85TGo3aUV5QXdvYUFHK3hxQ05nclZI?=
 =?utf-8?B?RkpIYnlUUTFYOXhnWkcwS2xaS2tDYVJqWTBtcURuWHNtWlNBRXlZRlQvZHRm?=
 =?utf-8?B?ZlFhSnpOOHlSbmJqRWNxMHRpRmIvSXFhbExQeUFPRFZVNUoxeFJFOFErbXNZ?=
 =?utf-8?B?clcyK0s2WGRKSDd4ZC9lLzkrK3AxbTE5UzRoRGdZdTliQzVHSElFNVBPdmI5?=
 =?utf-8?Q?MOuDrR4iujI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2lSdHJMdlRhTUFEaUlQeWttU0JZVTB5T2R5NlBXcHFvTjRmNllHU3pDK3N0?=
 =?utf-8?B?REcwUXpOUUgzVS95MFpYOGV5cUY0aDdwaVNET1VYQ1JodGEvWkV1RjdWZWxp?=
 =?utf-8?B?WnFNQmEzdjRCZkxhL0VlL0J2SE11dHo0ckllMklKM2JRUngvWER6NWh0ZDhE?=
 =?utf-8?B?bWRlck42c1NLanlNeXVFTVB0WnZaZkQvZXR0Y1YyaVg4WGpZTk80TnZFR0pz?=
 =?utf-8?B?Z21HVWV3cHlmL3dORDZzbVVHUHNvOHkweUswUFR4QUI3UHJyaTBzeW1HSXhQ?=
 =?utf-8?B?QnJ6MWNzQ2g5N2VnczJwR0hXdStTWFBWeXhLTXFWT1Q0RFVpdmlJaEszZ1dr?=
 =?utf-8?B?azVlYzRITndDb29JcWR0QUtyblFPNjhGcktFS2hEUytQeE5QQlc2NjE0VUI0?=
 =?utf-8?B?L0JJUW5iSnFPYVdtdWJJRUdSVGgxNXFjYW8yRXNSNjQ4dkc5NkszZlE2Nklj?=
 =?utf-8?B?VnlmZzhZOHVEMjQ1Yk00b3UxQjliZXlBVSs2ODRTL3lXSzBpOGlOVzB5am55?=
 =?utf-8?B?alUxK1pMZ1N3SGdxYy9uYXhrcnpJUjJ3eHR6TFdJWld2a1gwUVBqSmZZTkJp?=
 =?utf-8?B?Z0dHRzExNW4rUE5NNzJXZCtCNzk1QmREdnlNYlBsU3NtclZKN3pLejVaMnFQ?=
 =?utf-8?B?N0xNUTZUT0ZNdldwLzVYVE14bENPUmd1Q1NrSlF2ZmN3ZDNkR1dpNUJaNGFM?=
 =?utf-8?B?WWRZcFdZaEcxd3oyQVZ0dkxJTG96U0JlR1c5RVl6TUUxQXZOQ2N3YVJuREs1?=
 =?utf-8?B?RDJMdTRKN0RONG9xOWVaTWdBY0p1N2lhNXBqakp2VzNxOFNsVXkvWCtpOTVL?=
 =?utf-8?B?bUM3NnViaHJyYWZxSTM3UXYyKzBtUitqelVaUEVMK1VDS2FGeDdaOTdJTlU2?=
 =?utf-8?B?aFZuYXlibk9tUm5vWEp3M1daRGduRHBMR0dHeFh0SU04UGRWdzQyNEh0ZmpR?=
 =?utf-8?B?YmQwOFdUVjlkYldsZldhcGgyWHQ0M3doT3d0bkUxUzVLMW9XRG9GL0tQY0Mx?=
 =?utf-8?B?N2ZHaHlqZXhoaGNyK0ZqdFFvM2F4WDVmTHpUdlRKaktyMnh4bzhmU0s0ZUNU?=
 =?utf-8?B?SURML2R6WjFXVUhJWGo1a0dkTDliTTFUK3JZVnJ2SExOOXY0N0xEZmI4SEly?=
 =?utf-8?B?ZWtDSzQ3WWJIWmVWY24vZEdjUWhabkNGSTdDU0QyMk1YVnV4cUFDb1NvWkRz?=
 =?utf-8?B?L2hUYjNiNXB2dERNL205ODc3SW1PeTNDV3I1WjBST1ZEWEFQRENrcThGM3Y3?=
 =?utf-8?B?NFllYjlJM293bVAyQTBHdFV2OFkydnlxZ1d3SWo0eC9tOGRpdFB0QklxZHNv?=
 =?utf-8?B?bXVrRVgyMG83K2p2V3gyRC91Qm5sbDV4eDc1S2FPMmNrK3J4bDRqekd1bURN?=
 =?utf-8?B?YUlVQzEyYXBXMlBUaEdtaGhDZXBTRnhsOE9FOGNlZ3Fxa2wvZ2VCY3Y5WnhH?=
 =?utf-8?B?RGVGTWRwM2xuMnZyaDZ0akc4dXdwM1FvTEJWTE1qVnVhYzBwMXJmTEZicnpa?=
 =?utf-8?B?c3UvQ1QyVVVWM1ZMSWVEMVpOcnRST3J6U1FiR2lUMEcyeEM3NnBCYXVsc1Fq?=
 =?utf-8?B?dmlaaTVWYkoyaG5jT0pKaVY5MDNPRzlVZEIzUVFuRFhtaGpoSEp6N0ZZcTBt?=
 =?utf-8?B?NG5pSkRhMzJ2Zy9NNVMzWlR1QlNLS1hIQ0VyRXJmcitvT0xxTi9QNGFWZ0xO?=
 =?utf-8?B?bkNIN1YzWnZNUVQ4TGxibkNnQVJtMnlYeEVCL09HWTY1d2Vmbkg2ajl5R0NI?=
 =?utf-8?B?ZXJJRUZQK3g2cXQ4STdVRDFGdWUyQlMzYjRmbk5JRExtMFNUcGlpeEZpdFVZ?=
 =?utf-8?B?SVpHYVFsTVFqNFpOWTBPNXdLbkprazJCcEQrNzRIN1E1MkwxWjZubEhsR1J1?=
 =?utf-8?B?MmM5azBCcVlBUERCaGRYRXNUYnIyMG5kSDU0OElMSHM1eUhWMENsUnpEZGgy?=
 =?utf-8?B?NTZFY1UvSFNhNEtsUFNZMmpoRkRIRE1IWkV1dlBlMW1CMzhvQXBqSTYyWUxq?=
 =?utf-8?B?dE5lb2VnRCt6Vkk1c1JuYUJmVFdMdDdYbWpmdDRUaCtCT0x5aVlSaFFQL0wy?=
 =?utf-8?B?Q0FGWGRMSTRyOU42YlBVYXJ0dG9vSTQ5NCtIVGtuNldEd2N5WFpFSkVyOStv?=
 =?utf-8?Q?nxM9oc8pc5c61/xoQcz7BlHgs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b12687b-f80a-45c2-43b4-08dd8431d1a9
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 19:46:06.3771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6PyMgM7k+Pb43zisFXxqCI2VMqqHa6mTV2DVlflfgih2wu9F+62CO9xl5xL2bsqtKtnMzgkYPKRPk/ZFP1RgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6641

Hello Sean,

On 4/23/2025 4:15 PM, Sean Christopherson wrote:
> On Tue, Apr 22, 2025, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding prevents host accesses from reading the ciphertext of
>> SNP guest private memory. Instead of reading ciphertext, the host reads
>> will see constant default values (0xff).
>>
>> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
>> ASIDs.
> 
> Uh, no.  The only "host" ASID is '0'.
> 
>> All SNP active guests must have an ASID less than or equal to MAX_SNP_ASID
>> provided to the SNP_INIT_EX command. All SEV-legacy guests (SEV and SEV-ES)
>> must be greater than MAX_SNP_ASID.
> 
> This is misleading, arguably wrong.  The ASID space is already split into legacy+SEV and
> SEV-ES+.  CTH further splits the SEV-ES+ space into SEV-ES and SEV-SNP+.
>>

But the above statement is practically correct, once CTH is enabled, 
SNP guests must have ASIDs less than or equal to MAX_SNP_ASID and SEV and SEV-ES
have to use ASIDs greater than MAX_SNP_ASID. 

And yes, CTH basically splits the SEV-ES ASID space further into SEV-ES and SEV-SNP.

>> This patch-set adds two new module parameters to the KVM module, first
> 
> No "This patch".
> 
>> to enable CipherTextHiding support and a user configurable MAX_SNP_ASID
>> to define the system-wide maximum SNP ASID value. If this value is not set,
>> then the ASID space is equally divided between SEV-SNP and SEV-ES guests.
> 

What i really mean is that if CTH support is enabled and this MAX_SNP_ASID
is not defined by the user then the ASID space is equally divided between SNP and SEV-ES.

> This quite, and I suspect completely useless for every production use case.  I
> also *really* dislike max_snp_asid.  More below.
> 
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 50 +++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 45 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 7a156ba07d1f..a905f755312a 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -58,6 +58,14 @@ static bool sev_es_debug_swap_enabled = true;
>>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>>  static u64 sev_supported_vmsa_features;
>>  
>> +static bool cipher_text_hiding;
>> +module_param(cipher_text_hiding, bool, 0444);
>> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
>> +
>> +static int max_snp_asid;
>> +module_param(max_snp_asid, int, 0444);
>> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
> 
> I'd much, much prefer proper document in Documentation/admin-guide/kernel-parameters.txt.
> The basic gist of the params is self-explanatory, but how all of this works is not.
> 
> And max_snp_asid is extremely misleading.  Pretty much any reader is going to expect
> it to do what it says: set the max SNP ASID.  But unless cipher_text_hiding is
> enabled, which it's not by default, the param does absolutely nothing.

Yes, that's what i said above. 

But i do agree it is confusing and misleading.

> 
> To address both problems, can we somehow figure out a way to use a single param?
> The hardest part is probably coming up with a name.  E.g.
> 
>   static int ciphertext_hiding_nr_asids;
>   module_param(ciphertext_hiding_nr_asids, int, 0444);
> 
> Then a non-zero value means "enable CipherTexthiding", and effects the ASID carve-out.
> If we wanted to support the 50/50 split, we would use '-1' as an "auto" flag,
> i.e. enable CipherTexthiding and split the SEV-ES+ ASIDs.

Ok, that makes sense.

Right, split the SEV-ES+ ASID space between SNP and SEV-ES.  

> Though to be honest,
> I'd prefer to avoid that unless it's actually useful.
> 
> Ha!  And I'm doubling down on that suggestion, because this code is wrong:

Where ?

> 
> 	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
> 		if (snp_max_snp_asid >= (min_sev_asid - 1))
> 			sev_es_supported = false;

SEV-ES is disabled if SNP is using all ASIDs upto min_sev_asid - 1.

> 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> 			str_enabled_disabled(sev_es_supported),
> 			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
> 							      0, min_sev_asid - 1);
> 	}
> 
> A non-zero snp_max_snp_asid shouldn't break SEV-ES if CipherTextHiding isn't supported.

I don't see above where SEV-ES is broken if snp_max_snp_asid is non-zero and CTH is enabled ?

If snp_max_snp_asid == min_sev_asid-1, then SEV-ES is going to be disabled, right ?

> 
>>  #define AP_RESET_HOLD_NONE		0
>>  #define AP_RESET_HOLD_NAE_EVENT		1
>>  #define AP_RESET_HOLD_MSR_PROTO		2
>> @@ -85,6 +93,8 @@ static DEFINE_MUTEX(sev_bitmap_lock);
>>  unsigned int max_sev_asid;
>>  static unsigned int min_sev_asid;
>>  static unsigned long sev_me_mask;
>> +static unsigned int snp_max_snp_asid;
>> +static bool snp_cipher_text_hiding;
>>  static unsigned int nr_asids;
>>  static unsigned long *sev_asid_bitmap;
>>  static unsigned long *sev_reclaim_asid_bitmap;
>> @@ -171,7 +181,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>>  	misc_cg_uncharge(type, sev->misc_cg, 1);
>>  }
>>  
>> -static int sev_asid_new(struct kvm_sev_info *sev)
>> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>>  {
>>  	/*
>>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>> @@ -199,6 +209,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>>  
>>  	mutex_lock(&sev_bitmap_lock);
>>  
>> +	/*
>> +	 * When CipherTextHiding is enabled, all SNP guests must have an
>> +	 * ASID less than or equal to MAX_SNP_ASID provided on the
> 
> Wrap at ~80, not
> 
>> +	 * SNP_INIT_EX command and all the SEV-ES guests must have
>> +	 * an ASID greater than MAX_SNP_ASID.
> 
> Please don't referense MAX_SNP_ASID.  The reader doesn't need to know what the
> PSP calls its parameter.  What matters is the concept, and to a lesser extent
> KVM's param.
>

Ok.

>> +	 */
>> +	if (snp_cipher_text_hiding && sev->es_active) {
>> +		if (vm_type == KVM_X86_SNP_VM)
>> +			max_asid = snp_max_snp_asid;
>> +		else
>> +			min_asid = snp_max_snp_asid + 1;
>> +	}
> 
> Irrespective of the module params, I would much prefer to have a max_snp_asid
> param that is kept up-to-date regardless of whether or not CipherTextHiding is
> enabled. 

param ?

From what i see with your suggestions below, you are suggesting adding new
{min,max}snp/sev_es/sev_asid to track min and max ASIDs for SNP, SEV-ES
and SEV separately. 

> Then you don't need a comment here, only a big fat comment in the code
> that configures the min/max ASIDs, which is going to be a gnarly comment no matter
> what we do.  Oh, and this should be done before the
> 
> 	if (min_asid > max_asid)
> 		return -ENOTTY;
> 
> sanity check.
> 
> And then drop the mix of ternary operators and if statements, and just do:
> 
> 	unsigned int min_asid, max_asid, asid;
> 	bool retry = true;
> 	int ret;
> 
> 	if (vm_type == KVM_X86_SNP_VM) {
> 		min_asid = min_snp_asid;
> 		max_asid = max_snp_asid;
> 	} else if (sev->es_active) {
> 		min_asid = min_sev_es_asid;
> 		max_asid = max_sev_es_asid;
> 	} else {
> 		min_asid = min_sev_asid;
> 		max_asid = max_sev_asid;
> 	}
> 
> 	/*
> 	 * The min ASID can end up larger than the max if basic SEV support is
> 	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> 	 * Ditto for SEV-ES guests when CipherTextHiding is enabled.
> 	 */

Ok, makes sense.

> 	if (min_asid > max_asid)
> 		return -ENOTTY;
> 
>> @@ -3040,14 +3074,18 @@ void __init sev_hardware_setup(void)
>>  								       "unusable" :
>>  								       "disabled",
>>  			min_sev_asid, max_sev_asid);
>> -	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>> +	if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
>> +		if (snp_max_snp_asid >= (min_sev_asid - 1))
>> +			sev_es_supported = false;
>>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>  			str_enabled_disabled(sev_es_supported),
>> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>> +			min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
>> +							      0, min_sev_asid - 1);
>> +	}
>>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>>  			str_enabled_disabled(sev_snp_supported),
>> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>> +			min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : min_sev_asid - 1);
> 
> Mixing in snp_max_snp_asid pretty much makes this is unreadable.  Please rework
> this code to generate {min,max}_{sev,sev_es,snp,}_asid (add prep patches if
> necessary).  I don't care terribly if ternary operators are used, but please
> don't chain them.
> 

Ok.

Thanks,
Ashish

>>  
>>  	sev_enabled = sev_supported;
>>  	sev_es_enabled = sev_es_supported;
>> @@ -3068,6 +3106,8 @@ void __init sev_hardware_setup(void)
>>  	 * Do both SNP and SEV initialization at KVM module load.
>>  	 */
>>  	init_args.probe = true;
>> +	init_args.cipher_text_hiding_en = snp_cipher_text_hiding;
>> +	init_args.snp_max_snp_asid = snp_max_snp_asid;
>>  	sev_platform_init(&init_args);
>>  }
>>  
>> -- 
>> 2.34.1
>>


