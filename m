Return-Path: <kvm+bounces-34705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBEBA049E3
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10E3F3A2C8B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA401F428E;
	Tue,  7 Jan 2025 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zZlzU81M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D4218C937;
	Tue,  7 Jan 2025 19:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736276930; cv=fail; b=sHYpv7FPC6thl78n+9jVEZAtsQ1N82shPQKwhj0Fs1vtP8W8gEadJ6z7GGPYhQ428VtLPqsdCGZgpw21wv0tENLg4P0VbkdaBC3lzXJ+b+BCXRDUHUXMr5b7HDO+3ALTHHq9860ivR1lvOHTIyjp/LxFq1P0+X/oqW3uzwGPAxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736276930; c=relaxed/simple;
	bh=hhcV6xi8C03LeurOLRw6zzp8aIAdnq7Nhd/7IGnDTc4=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SJgcvi9UK/+l45ZzIYD/AmTz6fM5jvhoGPCzjYSKgrQjGU4VMNrJ5fwz1FB5bZYPDiwVJCQzZzukVxKd+KVJsE8VQtK+2AtkfzHEm6fJqEfIcMPY6KmuBvctMISHvaOXNEooSQWK/pX/HG9w1CNQYU5PGRS2K+SbJakLxg0/Ku8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zZlzU81M; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=olzT1XQkxji2xmtWGM6+VPnzclTSVsgt6drnixQtnkQ/SJAvJxylnASZVarqCDB9V6KdIrFUSHTOHg+ZTQ5mh3KuYArZ174ebCksScQQG3PaY8cjJpyWrE/84/Mz4WUFpDdw6Gs82aDbGGqK3cbMiTTDcqtnRog0h1pdMDToHCyp3IONeo6u7L+u4Xwyj3IWf6jOIDAJ4NFiQWEHllUBpNGokSLo3r/m9wcR2kLtVcAnYyZC29LL/g7YPJleb5SMP6t28gLAPMFP3uRYVu2vLuDIwuqPaAIzB6fZ90LyGEsghulJc5bAAj2Ws+fMDrgYbnp8wxs/1KOSW5jv5pqwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1lRpeKIFKiweKwPc9GyE06a4oZjw8lSVcdergy4Mbo=;
 b=Y1RLrXYt75W+25Di12E/DR1twxxTf48VTfHcJBKcp1VPTN8//m19xAxGYTZzvuzvyy5zrOisNeFE7EC+Xc0b18GF61EIvC408B5zo7Ko+SFuHJP45yuhzkFJGB5xX6teEGlIx7BsNZpw18BPuN5L2spPhS4nsclMB1kmZmP7oIz/pUiqUSTW9GMYrz+oMdi0fT7MspXJB8uQ0xISJTYleRdYeQW9BpGqriCD/XACh2DutjRU6Mg+ezIQJ7BLYVf87LEqh1ZBFNi1bldILzO3xNr5d01pLeQ91lCzrAWLWfyTtXDgw/7sR3N2VPytvu767Y74/mgvNCjaqXoasw2Xrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1lRpeKIFKiweKwPc9GyE06a4oZjw8lSVcdergy4Mbo=;
 b=zZlzU81MzuJyFRUGP3jpSj7sQ/jCeF6m7PDvXwTtl8IbDB1TCNrcbPOdeb42SIHxotoRt4MXlr4I4ufousOmpkFG4vnCP3rp+Dcy+/qdkoFLVAqu/s/yOnQq0hOlAtd1BKgc6NwzmUz/D5IWyxClB73tFIHQblmVjVx5gxpG6tg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 19:08:44 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 19:08:44 +0000
Message-ID: <2eef8079-71a1-411d-9a2e-3b3faa018e71@amd.com>
Date: Tue, 7 Jan 2025 13:08:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] crypto: ccp: Fix implicit SEV/SNP init and
 shutdown in ioctls
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <be4d4068477c374ca6aa5b173dc1ee46ca5af44d.1735931639.git.ashish.kalra@amd.com>
 <CAAH4kHaxpATK_dULAe67pV_k=r2LzFZrGn7pspQ2Bw0cUwo+kQ@mail.gmail.com>
 <9c63bf9c-2846-42f7-a934-262dc7858981@amd.com>
Content-Language: en-US
In-Reply-To: <9c63bf9c-2846-42f7-a934-262dc7858981@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0077.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::24) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: e356d6cf-c3f4-4eb6-17a0-08dd2f4eb489
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clA3RFRMZ0VMclQwbFhjb2E4T09sUHFTTUFKcWFWZktCV0RYKy9vTFZEOWxt?=
 =?utf-8?B?enpYSzFUeHZRMWdBSEcwNHAvZ2NlQ2J5dGpRTFMyK3NERWhLaWtNU01CN25S?=
 =?utf-8?B?OVhEYk1OL2UyVVBtOFlxQllLTnFsbXd2TWwrcEVzbXpJcG8vSUtSZk5OL2Rp?=
 =?utf-8?B?alkxeWdxNk9GQUc4ZmRGcWRTZlYvOThZd2xzZzFJR0ZvWW5IR0RxMUZpSWZo?=
 =?utf-8?B?aldlZ2pyWk5qQjE5elNzQ1FrUE40SUNGbkV5SWlJSUpDekNTTktxTFNta20w?=
 =?utf-8?B?aDQwdmRUWlJkSGg5TkRtb3JDZVRWTTFTZjlPRk5yY1R2Z1NpQmJYM3dZZmd3?=
 =?utf-8?B?NFo4WjA4N1BPMmxHMmUwT1o0d1VvWUFCRW15VE5wVnl2VWFtbks0QnM2b0Z3?=
 =?utf-8?B?MUJma1l0UzdTSTY2SXJlRzJtMWJKREYvYXBpdXhKV3EyRU9kMThsRWZabU5l?=
 =?utf-8?B?ZHJxdG5YN2JIMmtsS3g2Z2dqN25pdUdOSmpBa2pxZGxwQ2VQRytpVDFRNklT?=
 =?utf-8?B?dXAxdGFwejlDUjNFdFBUeStTVW5iZE9waTVGdWtTS0p4eHN5a2NRMnVCcjZs?=
 =?utf-8?B?MEVuQ1RqL3dHaEw1QitDTHZKOHZ0eUFPQWxHRUVGZFVpbTJPaUx6RG1qODdn?=
 =?utf-8?B?VklhOXBoVkQrWXQyTE43TnMzakRIZmcxc1lHbW03cUFENW1uMXVqbEhnZCt3?=
 =?utf-8?B?bWMxL1NwM1RQQkQrTTJYdjgzaUN1QUx6YWViK2JjdHViU1FWNU1Bd2lQRHdN?=
 =?utf-8?B?ekF1NkNPVlNsMjNRRXRoRGJKS2ZyeTFlV2RiemdUQXE2WXhxaWtLV0lpZjQw?=
 =?utf-8?B?WTJySE5McVVORnVyZTAyYjhhcFVqaDgrV3ROQWZjSFFlMEVWU2twdlhGdEds?=
 =?utf-8?B?TU5QM2YwM1JyeTlRK25NL0FFamtIVmJiNGYvQXlORjBmR0d1SUd5cm0xTHds?=
 =?utf-8?B?UWpTOGNJVzUwU3BJVlJnbWpweVV3Wm93MVFuYjdBb3dNdkJicHBxbFowMlhR?=
 =?utf-8?B?dS9HNHVjazNjMmV0dm4zYnAyb0M1QkxZdjVxR0ZlR3A5cGx5aEc0b0g0M09u?=
 =?utf-8?B?dHNCdCtRaitZM0UwYitSNEk1dW8wY2N4b2c0Yk5nMmRuNnBzdnZWeEpOYXNO?=
 =?utf-8?B?YkJpKytsNWdYNzdWakRuSlU3M2ZBdTdHbWtzZWxuTk8rY3hvTWFuTWVCWFI5?=
 =?utf-8?B?L21YTzB4MEdGRzVRWDhOdVNwWVlOZmx4WFdXOTBnTEpPQ3VUczNtUlhINWlO?=
 =?utf-8?B?OEVhSXhueituZ3Z0YlIybEFKeXM0MXRrNTZXeks0VFZ3VUc1eFlPWkpsUzBi?=
 =?utf-8?B?Q3lyZ2JQUWV3OVpvbjFPVVVQeWJiTmZDOTJqVC9mZmdVaTNQWkxuQ2g2Tm9M?=
 =?utf-8?B?M2xzbCt3QkYzTjUvdVlVbElmWXhvZ1dsbjQ3TDhERUZkSmJ3WGlvT1FqY0J3?=
 =?utf-8?B?a1BNZUIxNk9EQXYxMC9wN1FONWY1N3J3NjhmZTFlN1lCdVgyK2kvS1ZJZU5X?=
 =?utf-8?B?QlRXRTdFMWNTdm12Mys0WEVuaFM4U0F1Wkd3ekkwZjRTTlJ1RUg2SEFkSFFm?=
 =?utf-8?B?NUk3SHpXQk4xZGZnUUhLT0FsY2dpZzhFam1saXFQRWdzQzE0UitMa21vaU1m?=
 =?utf-8?B?VWhxZXBIUW5NV3R4YWtVNXFkdXNiVFhLODd6aEFOYlp3VFlvVFpPeFhINUN5?=
 =?utf-8?B?eWZUNHg3TGdvd0NtL1dQNjFmSnRaUjByMWFkMkcxUGc4WXFBOW9udTBmSEtu?=
 =?utf-8?B?ZGNhckxEeGZVbmtGYS9tY3JneFNDSURoK1Vja1pBUTFmSjVRZUd2cldNVDlE?=
 =?utf-8?B?cWRaUUFvUVQxbVJ1YmZwc012c1pWZkd3WlpvSzl5UVZPekxDbU02bHJmY1Fo?=
 =?utf-8?Q?JaJtisEp5vbTH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWdYZ1JOcGJvMVkrb2E4ZWZVRmF4R2VINWxZTDhKZ0tsbGZGa29BS3FqbmJX?=
 =?utf-8?B?YUZQZXZUQTJHak12NG9idHJ2N0hJNTIxRHZ6QlEwcEgzYmQzaFF5WFhNUEpC?=
 =?utf-8?B?WDJIOXFxeWZnYys1Mkx6WW9ncmZrRGZoWEV5L1Y2Y3Y1c1c3QXZWZEFjenEx?=
 =?utf-8?B?YUFmYjVYZS81T1Ixd3FjaUlHOUE5czRsdWM5YWNsc2tZTGNJS2RRV0ZGS0cw?=
 =?utf-8?B?MWtPcmhRLzBaNnJlZUQvay9mVkJ6TE5XeE41NDB2OERTTlovK01mSnN5Q3ha?=
 =?utf-8?B?eWZNVG85QVRqM3graWI1b2JoMFVWb0RLM3kweWVFemI0OW5mRDdBR3p2ZzU4?=
 =?utf-8?B?NncyYUpqMWdzakV2aThneVVvZEF5clBCZHYzY0JVVEI5eFpVUFFxYjdrRWox?=
 =?utf-8?B?aDZ4b1Nwb1I3dFhYN0lpRkJ1OXh6T2wwRWJZbUlvMWZZUlYvQ1dFOWY3NGRz?=
 =?utf-8?B?d2JxUEQwMDVZaFowbFR4a3B4WitRaHQ3S3ZaM2VNbGxHSmNLcUdnMUEralpU?=
 =?utf-8?B?OEMyTG1HY2dOQWFtYmVweXRvL2V1bElBNWpaeDdBVkJPOHlORHluUGFLdUtJ?=
 =?utf-8?B?SGorSFdlUFFELzM0dGVYayt5dCs3SXdoRnpTMlZKSVZrWWUzMVlJRmw3OHRk?=
 =?utf-8?B?UThEL2VOY09nT3l1QzhaK3hVUkxqcGxBOFplMVBTRDcxVFR4bGxlV2JYQXJG?=
 =?utf-8?B?MW1GWEJyZGdoYkpFZnFDY0wyc3gxWU9YZ0MvUEdjTDk3UTZlS0JuMHdVU0JZ?=
 =?utf-8?B?UkNJaFNHUE9TTktiVks5K2RCUEJmZzEyNy9sTGZlQVFNb1lmTlhLS0M5ZVhE?=
 =?utf-8?B?bTQyd2lXcStMYnVuaU11eWZRcCs3UmJHeUJzMTJtOWhpNHhNMjV4d3h5Vks2?=
 =?utf-8?B?ZDNZS0NIMXZHQTJGZFVvMmxZQldubndWWU1zbHhFY1loWHhSVlBYc0Rab1c1?=
 =?utf-8?B?V2VudStxQWVYU3BoeXlMRlc5cElYVzN0VnNodGg2aXZJQ25nby9jZHRaZTcr?=
 =?utf-8?B?KzFPbFk0Qm5IaEdaTUpNS0p2d0ZDN0QwbkE4VmExYU0vT0g4MHZZeEFYQ3F1?=
 =?utf-8?B?emtpanA3NlpadjVWSFhEUWFjM21vNGtDbmtld3pabTYzOTF1RkllRFlveWcw?=
 =?utf-8?B?SldYY2FEM0FnZWR6b210TWxrb2x6MWZDV1dqeGV5THNtdGlwSmFlMVVhMHNq?=
 =?utf-8?B?aWwrUDRVVTZhZjZ1Zit1eVhwdXBmZ1BTcXczU0haSnBMaEpXTmVrTGpxZFRj?=
 =?utf-8?B?K0t0Ym1nZDVJb1lDS2hXQlhDWnFGU0FWeStvM2UzUk43dTNhTzltZTQybjRP?=
 =?utf-8?B?VTVZakd4TmdQSWdXTWFNZzB0dHY4bks5TmtJLzI0bnNUVEp2dkxZNlV5OW1n?=
 =?utf-8?B?U2MyQ3BJVHRqdjVaN1NvSHUvRFhXeFo5SmQxVWk4YmgwcXIyL3RjeWpMQmsx?=
 =?utf-8?B?VFJSdlVid0czSTJuVTEyeVA0UlpBcFJsRUY1Vis5N1JIOFkydW5HRmo5RWhE?=
 =?utf-8?B?emQ4T1IyRVV1YlI3YXFIbjN0aHJ2R3VyQkxhMS9CSkc0ZEJSb1dvblRUYy9N?=
 =?utf-8?B?TG1mVjNQemU2V3VFZGx2UGROZFFScG5XeHhuU1h5VTI4RW11REVjU3p0eTFw?=
 =?utf-8?B?aVhzVHVvSG01V3d1MDh4UFNtY08xY1liK0N3bmh2SWhOdkswZWlBYjg1all2?=
 =?utf-8?B?dkphRlNrY3NjcW9vTWxzTUVGSE5UVG9TZGZRTXJtN2RjZmRlbGUzWGV1bG5X?=
 =?utf-8?B?QUxKd3R1VkFjS0xORkduUi91Q2c4cTM3L2IzSlpOMy9WVnVVOWxqQUtITlhz?=
 =?utf-8?B?aTBRMUVjam54aERmcVdsQ1JVd0Vnc1pHNGFJUHk4OG50YTN6ZWhPMFhOZFNa?=
 =?utf-8?B?NEpvT1VCdlR6QkJ4ZTRsckVLM3cxWUlvNE5NSFZ4dXZGb0RFTXg5dWh2ZnA3?=
 =?utf-8?B?aXBFZGVlcXJ6RkpFSk1sR3I5RVI0Yk14WTl0RC9ScnFVdm1WL2ZuZ3RJSDls?=
 =?utf-8?B?Nkw0UnVLa21QTkRpTlpGVVI2RklFQ21WOGc5OWVoeTBhUklSQnA4eDRBRW5E?=
 =?utf-8?B?YzV4clJ2V2Jra3ZUNXlhQlZiOHJVVUFLUHIzTzdNUmlNanAyeGFKYW5Nckdt?=
 =?utf-8?Q?upVrNTHpv7CUNmnd0heRluO1j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e356d6cf-c3f4-4eb6-17a0-08dd2f4eb489
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 19:08:44.0547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZN/WpXmdDS0G/JnLLgsYxYNpQmiSiFl6jEkiEKE5yaq978q9gFcDIc8hZzLmQ2Gx7iUN+ye+YuDs2GTAm6hTBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564



On 1/6/2025 5:48 PM, Kalra, Ashish wrote:
> 
> 
> On 1/6/2025 12:01 PM, Dionna Amalie Glaze wrote:
>> On Fri, Jan 3, 2025 at 12:00 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>
>> The subject includes "Fix" but has no "Fixes" tag in the commit message.
>>
> 
> I will change the commit message to be more appropriate, it is not really
> a fix but a change to either add a SEV shutdown to some SEV ioctls and
> add SNP init and shutdown to some SNP ioctls.
>  
>>> Modify the behavior of implicit SEV initialization in some of the
>>> SEV ioctls to do both SEV initialization and shutdown and adds
>>> implicit SNP initialization and shutdown to some of the SNP ioctls
>>> so that the change of SEV/SNP platform initialization not being
>>> done during PSP driver probe time does not break userspace tools
>>> such as sevtool, etc.
>>>
>>
>> It would be helpful to update the description with the state machine
>> you're trying to maintain implicitly.
>> I think that this changes the uapi contract as well, so I think you
>> need to update the documentation.
>>
> How does this change the uapi contract, as the SEV init and shutdown
> is going to happen as a sequence and the platform state is going to 
> be consistent before and after the ioctl, the next ioctl if required
> will reissue SEV init.
> 
>> You have SEV shutdown on error for platform maintenance ioctls here,
>> which already have implicit init.
>> pdh_export gets an init if not in the init state, which wasn't already
>> implicit because there's a wrinkle WRT the writability permission.
>>

Also note that it is important to do SEV Shutdown here with the SEV/SNP
init stuff moving to KVM, if we do an implicit SEV INIT here as part of
the SEV ioctls and do not follow it with SEV Shutdown then SEV will
remain in INIT state and then a future SNP INIT in KVM module load
will fail.

This was different earlier as SNP was initialized first when CCP
module is loaded, so SNP would already have been initialized when
the above SEV ioctls are issued.

Thanks,
Ashish

> 
> This patch only adds SEV shutdown to already implied init code as part
> of some of these SEV ioctls. 
> 
> If you see the behavior prior to this patch, SEV has always been initialized
> before these ioctls as SEV initialization is done as part of PSP module
> load, but now with SEV initialization being moved to KVM module load instead
> of PSP driver load, the implied SEV INIT actually makes sense and gets used
> and additionally we need to maintain SEV platform state consistency
> before and after the ioctl which needs the SEV shutdown to be done after
> the firmware call.
>  
>> snp_platform_status, snp_config, vlek_load, snp_commit now should be
>> callable any time, not just when KVM has initialized SNP? If there's a
>> caveat to the platform status, the docs need to reflect it.
>> I don't know how SNP_COMMIT makes sense as having an implicit
>> init/shutdown unless you're using it as SET_CONFIG, but I suppose it
>> doesn't hurt?
>>
> 
> Yes, and that is what this code is allowing, to call snp_platform_status,
> snp_config, vlek_load and snp_commit without KVM having initialized SNP.
> 
> If you see the behavior prior to this patch, SNP has always been initialized
> before these ioctls as SNP initialization is done as part of PSP module
> load, therefore, to keep a consistent behavior, SNP init is being done here 
> implicitly as part of these ioctls and then SNP shutdown before returning
> from the ioctl to maintain the consistent platform state before and
> after the ioctl. 
> 
> Additionally looking at the SNP firmware API specs, SNP_CONFIG needs
> SNP to be in INIT state. 
> 
> Thanks,
> Ashish
> 
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  drivers/crypto/ccp/sev-dev.c | 149 +++++++++++++++++++++++++++++------
>>>  1 file changed, 125 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 1c1c33d3ed9a..0ec2e8191583 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -1454,7 +1454,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>>>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>>>  {
>>>         struct sev_device *sev = psp_master->sev_data;
>>> -       int rc;
>>> +       bool shutdown_required = false;
>>> +       int rc, ret, error;
>>>
>>>         if (!writable)
>>>                 return -EPERM;
>>> @@ -1463,19 +1464,30 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>>>                 rc = __sev_platform_init_locked(&argp->error);
>>>                 if (rc)
>>>                         return rc;
>>> +               shutdown_required = true;
>>> +       }
>>> +
>>> +       rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
>>> +
>>> +       if (shutdown_required) {
>>> +               ret = __sev_platform_shutdown_locked(&error);
>>> +               if (ret)
>>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, ret);
>>>         }
>>>
>>> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>>> +       return rc;
>>>  }
>>>
>>>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>>  {
>>>         struct sev_device *sev = psp_master->sev_data;
>>>         struct sev_user_data_pek_csr input;
>>> +       bool shutdown_required = false;
>>>         struct sev_data_pek_csr data;
>>>         void __user *input_address;
>>> +       int ret, rc, error;
>>>         void *blob = NULL;
>>> -       int ret;
>>>
>>>         if (!writable)
>>>                 return -EPERM;
>>> @@ -1506,6 +1518,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>>                 ret = __sev_platform_init_locked(&argp->error);
>>>                 if (ret)
>>>                         goto e_free_blob;
>>> +               shutdown_required = true;
>>>         }
>>>
>>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>>> @@ -1524,6 +1537,13 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>>         }
>>>
>>>  e_free_blob:
>>> +       if (shutdown_required) {
>>> +               rc = __sev_platform_shutdown_locked(&error);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>>         kfree(blob);
>>>         return ret;
>>>  }
>>> @@ -1739,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>>         struct sev_device *sev = psp_master->sev_data;
>>>         struct sev_user_data_pek_cert_import input;
>>>         struct sev_data_pek_cert_import data;
>>> +       bool shutdown_required = false;
>>>         void *pek_blob, *oca_blob;
>>> -       int ret;
>>> +       int ret, rc, error;
>>>
>>>         if (!writable)
>>>                 return -EPERM;
>>> @@ -1772,11 +1793,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>>                 ret = __sev_platform_init_locked(&argp->error);
>>>                 if (ret)
>>>                         goto e_free_oca;
>>> +               shutdown_required = true;
>>>         }
>>>
>>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>>>
>>>  e_free_oca:
>>> +       if (shutdown_required) {
>>> +               rc = __sev_platform_shutdown_locked(&error);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>>         kfree(oca_blob);
>>>  e_free_pek:
>>>         kfree(pek_blob);
>>> @@ -1893,17 +1922,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>>         struct sev_data_pdh_cert_export data;
>>>         void __user *input_cert_chain_address;
>>>         void __user *input_pdh_cert_address;
>>> -       int ret;
>>> -
>>> -       /* If platform is not in INIT state then transition it to INIT. */
>>> -       if (sev->state != SEV_STATE_INIT) {
>>> -               if (!writable)
>>> -                       return -EPERM;
>>> -
>>> -               ret = __sev_platform_init_locked(&argp->error);
>>> -               if (ret)
>>> -                       return ret;
>>> -       }
>>> +       bool shutdown_required = false;
>>> +       int ret, rc, error;
>>>
>>>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>>                 return -EFAULT;
>>> @@ -1944,6 +1964,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>>         data.cert_chain_len = input.cert_chain_len;
>>>
>>>  cmd:
>>> +       /* If platform is not in INIT state then transition it to INIT. */
>>> +       if (sev->state != SEV_STATE_INIT) {
>>> +               if (!writable)
>>> +                       return -EPERM;
>>> +               ret = __sev_platform_init_locked(&argp->error);
>>> +               if (ret)
>>> +                       goto e_free_cert;
>>> +               shutdown_required = true;
>>> +       }
>>> +
>>>         ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>>>
>>>         /* If we query the length, FW responded with expected data. */
>>> @@ -1970,6 +2000,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>>         }
>>>
>>>  e_free_cert:
>>> +       if (shutdown_required) {
>>> +               rc = __sev_platform_shutdown_locked(&error);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>>         kfree(cert_blob);
>>>  e_free_pdh:
>>>         kfree(pdh_blob);
>>> @@ -1979,12 +2016,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>>  static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>>  {
>>>         struct sev_device *sev = psp_master->sev_data;
>>> +       bool shutdown_required = false;
>>>         struct sev_data_snp_addr buf;
>>>         struct page *status_page;
>>> +       int ret, rc, error;
>>>         void *data;
>>> -       int ret;
>>>
>>> -       if (!sev->snp_initialized || !argp->data)
>>> +       if (!argp->data)
>>>                 return -EINVAL;
>>>
>>>         status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>>> @@ -1993,6 +2031,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>>
>>>         data = page_address(status_page);
>>>
>>> +       if (!sev->snp_initialized) {
>>> +               ret = __sev_snp_init_locked(&argp->error);
>>> +               if (ret)
>>> +                       goto cleanup;
>>> +               shutdown_required = true;
>>> +       }
>>> +
>>>         /*
>>>          * Firmware expects status page to be in firmware-owned state, otherwise
>>>          * it will report firmware error code INVALID_PAGE_STATE (0x1A).
>>> @@ -2021,6 +2066,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>>                 ret = -EFAULT;
>>>
>>>  cleanup:
>>> +       if (shutdown_required) {
>>> +               rc = __sev_snp_shutdown_locked(&error, false);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>>         __free_pages(status_page, 0);
>>>         return ret;
>>>  }
>>> @@ -2029,21 +2081,38 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>>>  {
>>>         struct sev_device *sev = psp_master->sev_data;
>>>         struct sev_data_snp_commit buf;
>>> +       bool shutdown_required = false;
>>> +       int ret, rc, error;
>>>
>>> -       if (!sev->snp_initialized)
>>> -               return -EINVAL;
>>> +       if (!sev->snp_initialized) {
>>> +               ret = __sev_snp_init_locked(&argp->error);
>>> +               if (ret)
>>> +                       return ret;
>>> +               shutdown_required = true;
>>> +       }
>>>
>>>         buf.len = sizeof(buf);
>>>
>>> -       return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>>> +
>>> +       if (shutdown_required) {
>>> +               rc = __sev_snp_shutdown_locked(&error, false);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>> +       return ret;
>>>  }
>>>
>>>  static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>>>  {
>>>         struct sev_device *sev = psp_master->sev_data;
>>>         struct sev_user_data_snp_config config;
>>> +       bool shutdown_required = false;
>>> +       int ret, rc, error;
>>>
>>> -       if (!sev->snp_initialized || !argp->data)
>>> +       if (!argp->data)
>>>                 return -EINVAL;
>>>
>>>         if (!writable)
>>> @@ -2052,17 +2121,34 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>>>         if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>>>                 return -EFAULT;
>>>
>>> -       return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>>> +       if (!sev->snp_initialized) {
>>> +               ret = __sev_snp_init_locked(&argp->error);
>>> +               if (ret)
>>> +                       return ret;
>>> +               shutdown_required = true;
>>> +       }
>>> +
>>> +       ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>>> +
>>> +       if (shutdown_required) {
>>> +               rc = __sev_snp_shutdown_locked(&error, false);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>> +       return ret;
>>>  }
>>>
>>>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>>  {
>>>         struct sev_device *sev = psp_master->sev_data;
>>>         struct sev_user_data_snp_vlek_load input;
>>> +       bool shutdown_required = false;
>>> +       int ret, rc, error;
>>>         void *blob;
>>> -       int ret;
>>>
>>> -       if (!sev->snp_initialized || !argp->data)
>>> +       if (!argp->data)
>>>                 return -EINVAL;
>>>
>>>         if (!writable)
>>> @@ -2081,8 +2167,23 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>>
>>>         input.vlek_wrapped_address = __psp_pa(blob);
>>>
>>> +       if (!sev->snp_initialized) {
>>> +               ret = __sev_snp_init_locked(&argp->error);
>>> +               if (ret)
>>> +                       goto cleanup;
>>> +               shutdown_required = true;
>>> +       }
>>> +
>>>         ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>>>
>>> +       if (shutdown_required) {
>>> +               rc = __sev_snp_shutdown_locked(&error, false);
>>> +               if (rc)
>>> +                       dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>>> +                               error, rc);
>>> +       }
>>> +
>>> +cleanup:
>>>         kfree(blob);
>>>
>>>         return ret;
>>> --
>>> 2.34.1
>>>
>>
>>
>> --
>> -Dionna Glaze, PhD, CISSP, CCSP (she/her)
> 


