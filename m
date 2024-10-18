Return-Path: <kvm+bounces-29126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92DA79A33F0
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11B561F2426D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 04:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AEA17837F;
	Fri, 18 Oct 2024 04:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iyHKrlNG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B3220E318;
	Fri, 18 Oct 2024 04:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226995; cv=fail; b=sucKL4aWlTHFyMh0iOHI2BQUeoc028ufYLFS4zEB3G5Zk9v1MsBy/PIjhwRGp15TGgOAQHhDVYCgxRQuDNT7UnlEeph6yVVXTlObEZo2PbMkZxtss2CDNIHNnTi7pjbBzFi2zdzrCTycHk+WFRAWdz8mGy44aQlgjnE3lFdQSf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226995; c=relaxed/simple;
	bh=pOdEw2WfeyKebxB6y222D9uF9tDg+gJU8/TkI20lR5k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gTNDULySaG3w0JIig1dXIswG2nVm06/BoIpf14sD5sgtKqvFth4y4qiaQFCNq5JwQnLLyYNNuic7oylfWHfTxaSEBuue5X/hPNImag8kuvEGeCPlZlAj8emwGaN0QXChSAzasilE+nNYDztV6PsdSvZ4bqiBN+lMMm+lLlMWJ8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iyHKrlNG; arc=fail smtp.client-ip=40.107.92.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s80wd7w29hLlGE0epYL1T4eTUNPzj5ymsP0b39lxVVt+q/BbFs83VJOGLwDxoo9pij9czFZCbZOPF/0SMesUkdwKq4cseDY6YaBLrul4mRWZCdNaFfrMeoz2isbrXNkRS25peJrxBVIp/A3StvCW/S1bQDrbGiCtW2bpZdw+q+uTpJK9yCgFjqxlqKResVBYw6npVV8lSQZbx5o5u2SiwfxOrVWjwsnZKrV7v0LrIGFvT0zjc6JlATnmGFnbJil+QlFI6cMwkU/25xEl00bAsB5i/tG3zs2NDQOi+9eZmFdcC0Pc4H30dztoAy77ZUWx/SS6xTPKowKDTV/owPep6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJblvmV3EJQcYSy5sq0+ZymLnXJLQAPZDZjC7Z7dKn0=;
 b=qiljfGLXElKZrhd9SEoQn4XZtzVW1dStBCR9zY1ClBOSmSJGnbNsz/qfQP0GL5qLpQy0u5XqPPO6Vflh9QKnn+zbGEoRyEPJRsX7GCLS/3GHsseF/ezEe+KwjdxsrRKlQIHG0tDqSOVn3M2MYnK4s1fku5sBRnoNYeWfO3xSOR+x56tH5u/X/FS1jYn9A1+8HPhmhUPsCWzsoqj2O/DJRNetWuNrEcb47reKZaTqXL0IZXpE0djV9mWa2QSuce0ntG+MdRjUgYS3esmoUrdPITJxkR5lDMS9xZZrGyekUtuRqk0YHlc8FkUcRut3GooRUylSEe9MUwIXtnp5CjNArg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJblvmV3EJQcYSy5sq0+ZymLnXJLQAPZDZjC7Z7dKn0=;
 b=iyHKrlNGiHQUh04RLJuysN+v8sKcl5U/WvcFbur8EO8uKYLTVIBlx1ZhH0SzdS1JjzaeFhG+ev2JWCteHXVSwK7P7d0eSdTEwwFsgn3MM33stfVKyUzFtFfH5O9T0gOUJrniRvtTStc6eD5ujbX9NnMUKZT70Oq8fQIkxwx3kJr8q4MfE1MCKjpyin/CJxQWUrziTcKFyfmA6eF5qWv9ZdcaviX9tJDo3iGG6jj9C+mkzJRwmVuWN5Xe7B27TggaCD2hNQZ6d2oJRd+fXdbyBSCQ1EYPPfJPGu2xGENoAuHzU/NoH6tjDv4bvShr+tuXnY+Du8YT8FWs0eBL+7N1wA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6228.namprd12.prod.outlook.com (2603:10b6:930:20::6)
 by DM4PR12MB6616.namprd12.prod.outlook.com (2603:10b6:8:8e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Fri, 18 Oct
 2024 04:49:50 +0000
Received: from CY5PR12MB6228.namprd12.prod.outlook.com
 ([fe80::cc6a:1278:b4ac:82e7]) by CY5PR12MB6228.namprd12.prod.outlook.com
 ([fe80::cc6a:1278:b4ac:82e7%3]) with mapi id 15.20.8069.016; Fri, 18 Oct 2024
 04:49:50 +0000
Message-ID: <ed65312a-245c-4fa5-91ad-5d620cab7c6b@nvidia.com>
Date: Thu, 17 Oct 2024 23:49:47 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/19] irqchip/gic-v3-its: Share ITS tables with a
 non-trusted hypervisor
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-18-steven.price@arm.com>
Content-Language: en-US
From: Shanker Donthineni <sdonthineni@nvidia.com>
In-Reply-To: <20240819131924.372366-18-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:805:f2::31) To CY5PR12MB6228.namprd12.prod.outlook.com
 (2603:10b6:930:20::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6228:EE_|DM4PR12MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: de3f1761-4b60-478a-ea27-08dcef304c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmNJWHpPNkdoMXBpQUVoK1Y1dGJRZFJQT2Zqc2puSDlUcFZCc1VkR096dndL?=
 =?utf-8?B?MUR0V3c1VVdwalArWGJaOVRTQkpUNHVINUZJK25WZGx4VlN6TzVMeWh3bGsz?=
 =?utf-8?B?cDJXUmVtengzbjBadlhLdVV5eStadHhWWHZyZm96Z3pzWkFSSXI3cmd5V1J3?=
 =?utf-8?B?aWNCTVY0Q3N1U25NY0RXM25pOS9GVEZQN2JUOUlPZ0hodzBBOXNpdTJUVWIv?=
 =?utf-8?B?clJFRnJiL2RUY0hKT3BOK0FxKzR5UG42V25ob0hOWVFwMzVNUXNHdjY2WDR5?=
 =?utf-8?B?TytzVUlsVEw2c0pMOVMyUm0wYTcreHN5UktVMjIyUXAvRGhjS3NsYnhQdHBB?=
 =?utf-8?B?NFY3SlFsNGRPRGJaVTdTRTBsSWFwalE2Q1JBc3M0QXFvTVZBUUFCRks0ZDN5?=
 =?utf-8?B?UGZEay9JT0g1ZU9tQUFwWWN1MERQdmV2bWh2R1BCYlhCeGlkdFVNdHArQlox?=
 =?utf-8?B?dzl5eHpSODEzVGZSSkowaENYYmVJM3YyUTBaMG5WUklVb1ZwU2xtaVkrMW8v?=
 =?utf-8?B?UGVEaWNaRmNnR3lUWFVqOXJHTVFOSGU4cXR5c0JDMHVRdEJhenZYdWZwaWFO?=
 =?utf-8?B?aGowZStRNFhWOW4yWHlIRE5EbVoxNlpWT1R6Z3B1VnNTeDFGNkk1c1QxSmhE?=
 =?utf-8?B?TEZ4U0h4bm1mRXo5SGx5bXVZRkZKcWFlZUo2N3hjQWNqNkFocmZmZTlVL1J0?=
 =?utf-8?B?Nmw3UUxGMGNrZWNSYkxYNngyTDNpVWRxOGR1bmg4Q3BDeEh2ODkxZjUvS1hB?=
 =?utf-8?B?Nk96OXhtRzBaYzR1UFlQSkNJTHRaT2tjRG1mc3NPYmFPNnk2NkloTnpGQktE?=
 =?utf-8?B?OFlCSi8rcmFtLzE4MDBjLzRSZ3NDcWphK0kxdEZpMUt6Z0ZaaEhDY0l0clYy?=
 =?utf-8?B?QmpXSDg1UzRBKzE2dkxMRDYzdDlkOTU4Ymkzc2hMZnlBcVNkMzNRdXhZa0xD?=
 =?utf-8?B?ODRZK3l2cGZEVFUweGlhNUtLTnFDMTlJTHlwVDhUbUE0NFBVM1E4OFA0SjN3?=
 =?utf-8?B?aWoyaitaT1R4eXl4V3JRTXBwa2F2N3l2VGFObFdUZ0ZOUTRBL1FMSEFLM2lK?=
 =?utf-8?B?V2RLVXliMEsxOXNCUzA2Q2lMQ3RvS3Q5M3hySGpoYS9oZWhDTEFmU1hTR1dv?=
 =?utf-8?B?Y29zTncvejhLeGJleTY2cWhSVTBIUzA3dysrenhMclJrYjdMbnlZbkZVZXAv?=
 =?utf-8?B?UjJlWjF4dFptcVZwQTVOWGFJZmdjNE1yY0Y4ZmlMOG5rQnJhY3g4TmI5Z082?=
 =?utf-8?B?N0d5S0hNWFpIZU1oNlBrSkJlTzdOUUVBMk1wRCtIdjY4YmpsclRzQXg2SW5T?=
 =?utf-8?B?Q3grb3cwWGM1VEtXNlFncEVzR2JoMzJHRjFaSTZOc3FqTUJQTXhkVEtBT0p4?=
 =?utf-8?B?emd2V2IvUWFQWjlpZ1U3Q0VjUUJNMEZpRUpvWHVCV1g0b0Jpc25BSCtkUkgz?=
 =?utf-8?B?eWpaYTR4RG1ZUGZ1MWFyOXFBeXBQelA2Tks5dE5haFNkRDlJTDUrbzN0bkpP?=
 =?utf-8?B?WFV5R1ppV2xoSFdlcW8xZXYrMEpDNTIrdE40YzhuQVAzMEdVNzJrSnA3aWQ2?=
 =?utf-8?B?MTRDbEQ5TThMdFhMN1dZV2NCcjBjTDJyTUxXdTRuTTE3Vm53SmVZQVFJWkpF?=
 =?utf-8?B?T3k5UnpsdEdIQnZMT0Jqd1hsU3VINFZvUXU4RW1vQ0YzakdrNmR3VHFSRDMx?=
 =?utf-8?B?dUFqMkFFelVxZ1VUdkxwb2tjbnIrdE5XL2J5a2tjM3Q4cldKVjJjM0krVjFr?=
 =?utf-8?Q?4dDUDJI8h/e8fczwJrTwa1pQSpYy38iy+BklQWJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2RIRmpoS0U0NDhkcHN3MVg1ZlVYUWV3Q2FvU3R3RHZycmtOekZHaVNOcVJ1?=
 =?utf-8?B?cDU4VC9EUWd0ejdEcTdGQkFMTmt4UFdaeUViR1h6R2lHSjZZcEJWMC9CVjY2?=
 =?utf-8?B?KzJwYXlGVVdGN3FYaHA1N09nc0FjOUpBdllUQmIwbjRpRURydzJpeG1HakFB?=
 =?utf-8?B?RjUrVzR1ZGh2YmZSSDdSZXJmeCtxRklwNTk2QjlhTm80OXpodmFmbXhtdHZ0?=
 =?utf-8?B?UkU3YXQzZVlHU3ViU0lrbkozcHdpOVRRMkVFcUFGaURqRUEyMHgxNiszNExO?=
 =?utf-8?B?azZ2UXB1Qk9OVGZheGx6WXBaS2JSV1BybUlUZ2M1aWpqTVRLWEhUajZidzlV?=
 =?utf-8?B?THVIM1hZZHNtV0ZlL2JnbDA0eWJxRkpHelYveE92V0E4QUNtN2wvUW91d2p4?=
 =?utf-8?B?YzhacWFNUSsrZVZNcVc0cjdFSWx2Z0RWcHIvUnJ2ZzZMK0ZJcVk3QnczaDJS?=
 =?utf-8?B?VUEycXNoVTlpbW1BdGJNMTc2ZHFERmJLUVIwNHJoUXBvZ0NTY1ZUL3VtZkZC?=
 =?utf-8?B?eHlkb1dpSmo3c3AvOXcyL3J6NS8yYzFydE5HUDVmZ2lzSG9hMGZqcGxhc09J?=
 =?utf-8?B?bXN0c1FPc0w3ZGxBQjkxTlpNYlB3S05NNjlWY05SWXlRcXF6VnR6eGZTOTBG?=
 =?utf-8?B?aSt5bFNqRWFuVG9HajVob2puNlRWN3FycHlLLytnT3JVeXRvTmJHREptQ1Nx?=
 =?utf-8?B?NnhhN0ZDYXlKemZYYlhSNitxb3RCd1FkUGxtY0J4TGROSTFCSHRrN0YxejJO?=
 =?utf-8?B?VUM0UWdYeUVrbUs2KzRjSW1GbXZzNW9NWEJlNnlhNkJQY2h4UjBERURGcnZx?=
 =?utf-8?B?MjFkUGVGZ216TWlEQmIranoxeVZiZDYrQ21ySXIvU09YZ2RDcDNvR0h2NzBI?=
 =?utf-8?B?c3dZOVl4aUs5Z1pidEJQcWZNZlNyV1FocUNWVW8rVVd2cGV5NVBQSUtzT3p5?=
 =?utf-8?B?SUlLUTlNSGVNVFFhWFl3eDJjVTNramh6UTlJUjMyWE5ZSkR0Nk5UWFlvQ1Ex?=
 =?utf-8?B?RUtVekpnWjhxeTVCUnprWkdMYVZMWjc1TjMwR2NZZUlTZ255TDZSLzc0c3Fa?=
 =?utf-8?B?bFNxcDZJZkxTQzdvUVhXcVdBUkNJWnJaeWZrZXZCMEFDSCtzSGx4ZEJjYkVE?=
 =?utf-8?B?R3RnUFphNnFiY1VpN1RtRmJIQm9NV2pFMTVaWkJNWXFYN0tSWUdOblpnSFNV?=
 =?utf-8?B?MEJMUmZvYWlHSjdYQlJVbUlzUnBqMnJpcGE5TFhOUUlsbTBvV1NWTFc0UE9X?=
 =?utf-8?B?Z09UM2NRWXlFQUljM1dGeWFHWDBYSGZEQmgwbkhuQ2RidEQ4RjY2K0J6eUhB?=
 =?utf-8?B?V00vbzNBR29jYkwvRW5UQ0RiYkFZYXBBRm5mdFJZSWVVZzR1a0xCRzdVVzM5?=
 =?utf-8?B?TTZWdmZMMDlEYjM5V1dvSk1yTkF2UE9ya0FzczJBMm1aOW4vd1M5UVdmeURk?=
 =?utf-8?B?eWFBLzltTC9PazdOUVJDcU85S3R0My9DbWxycGVYOWl1ZVZyZlZubTFmRmV3?=
 =?utf-8?B?OHdPMHNBdkEzN25RNnhWZDZPTDNuY3JYUGJUb0VNalJUSGJaWnlhQkpGSUQ0?=
 =?utf-8?B?S29qV1dpcjI3U2R4Y1RVUytSMW44MjJSUjNNdkkxRTRRZWgyaTdySTk2MGQ0?=
 =?utf-8?B?dGE4Qksra01zM1lSUjFkdWZHbHJWK1hvdURzTUFheFZqaVI1RFNXaENOZWNa?=
 =?utf-8?B?ZVk4OGErWWRoMHVsSG5EVTFmK2haNnR5dGRZZnQ5aUVURlRmdHp3Tjk0ZkNk?=
 =?utf-8?B?WFhiVS9neXhXZ3pyazhRc3J6Tml4d2FXRllsdnpMbTZibXBDRityMnN4V3dV?=
 =?utf-8?B?UXJVblhtNzAwODZPUW5IODN1MDRqcHZMeEx0Q1JFazVTSnl3Uk9TNGZVUTRZ?=
 =?utf-8?B?WTdGWXlkdXk2by9LN3VacDRIRE9LRVptZDIwZlk5ZytCd20xQkh6U3ovb243?=
 =?utf-8?B?Y01TSERpZWp3eEFDMWtQb2lWeWI3QVBxekx0SkV0enZCTDNQNlRmcjN3TGdh?=
 =?utf-8?B?cnZHdEJ6bWJDclNIZ29aME9wR0NsZnNYeWJKZWY0K0NuYmYvcG4yekJjTXVh?=
 =?utf-8?B?RFB0c0RZYXcxd1FFeEFnc2J2V2dvaUxGam8rY01kSnR6dXltTTVIQTQvcng3?=
 =?utf-8?Q?URDDZIegpR9UnX3VID8qZsKNA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3f1761-4b60-478a-ea27-08dcef304c8d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 04:49:50.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uzjapq7Ryn92etvcQrRgqxgkB5Twx0EG45VkbIQ4liZEzPMME8493jN8n+bplQDm38yT7G+mYAX+Nm7p4vRJGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6616

Hi Steve,

On 8/19/24 08:19, Steven Price wrote:
> External email: Use caution opening links or attachments
> 
> 
> Within a realm guest the ITS is emulated by the host. This means the
> allocations must have been made available to the host by a call to
> set_memory_decrypted(). Introduce an allocation function which performs
> this extra call.
> 
> For the ITT use a custom genpool-based allocator that calls
> set_memory_decrypted() for each page allocated, but then suballocates
> the size needed for each ITT. Note that there is no mechanism
> implemented to return pages from the genpool, but it is unlikely the
> peak number of devices will so much larger than the normal level - so
> this isn't expected to be an issue.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Tested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>   * Use BIT() macro.
>   * Use a genpool based allocator in its_create_device() to avoid
>     allocating a full page.
>   * Fix subject to drop "realm" and use gic-v3-its.
>   * Add error handling to ITS alloc/free.
> Changes since v2:
>   * Drop 'shared' from the new its_xxx function names as they are used
>     for non-realm guests too.
>   * Don't handle the NUMA_NO_NODE case specially - alloc_pages_node()
>     should do the right thing.
>   * Drop a pointless (void *) cast.
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 139 ++++++++++++++++++++++++++-----
>   1 file changed, 116 insertions(+), 23 deletions(-)
> 
...
> +
> +static void *itt_alloc_pool(int node, int size)
> +{
> +       unsigned long addr;
> +       struct page *page;
> +
> +       if (size >= PAGE_SIZE) {
> +               page = its_alloc_pages_node(node,
> +                                           GFP_KERNEL | __GFP_ZERO,
> +                                           get_order(size));
> +
> +               return page_address(page);
> +       }
> +
> +       do {
> +               addr = gen_pool_alloc(itt_pool, size);
> +               if (addr)
> +                       break;
> +
> +               page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 1);


Two (2^1) pages are allocated here, but only one page is being added to the pool.
Is this a typo or intentional?

> +               if (!page)
> +                       break;
> +
> +               gen_pool_add(itt_pool, (unsigned long)page_address(page),
> +                            PAGE_SIZE, node);
> +       } while (!addr);
> +
> +       return (void *)addr;
> +}
> +
> +static void itt_free_pool(void *addr, int size)

-Shanker

