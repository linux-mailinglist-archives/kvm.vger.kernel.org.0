Return-Path: <kvm+bounces-59549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FCBBBF390
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 22:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 215694EDEF8
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 20:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2BE2DE6FC;
	Mon,  6 Oct 2025 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V//GxPLa"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81371A0B15;
	Mon,  6 Oct 2025 20:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759783150; cv=fail; b=AcNQ7deS55Bl9YhKU4t5tanogNt3acCwpVmkHZNiSUgEy3xgq7pov+VcG8magLV+1+p88ATh3q6nj5Nq1higHB5JsfxBu3rTDqS/l9/siLWGs0Hpi3CUPAy0T1jjrLqLHw/UUogFjd+ff2wPcIO8Q6gBt9lbkM1UU32xEOxyYG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759783150; c=relaxed/simple;
	bh=veKhOglcHV3HoNQNxypdam/1Vd+98SGjwfcZv8eTzAI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tWJt8oBi6TS02QxbTTaGIAB2d1xbli7tJdCZ+FW5RsuINwRGJsmQyV8yMRihNkj/aWgFfDjFazDQqDEUyWWBKelX4dVTsLBPRQov4MQoUCtxK038Dn/8vF0IehTn6tMzwKGKKYHQKKFiBxHa9t30c+yobGEvE4Xk3EL5LVB0maA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V//GxPLa; arc=fail smtp.client-ip=40.93.195.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfIpYHmC3a3ZYgeenSwUmYxYo4ZRVCVIcVGothcKGwrf16xfnm6ebb4UGsz7yhXXDSWU8ACDwsrT+Iuhext/WwxWM6vtNeeI8U46vCcix+XBLatOyO5Fo1vOkMSFmUND/fVsfNTynhXSOz5D40J+g3i7xv2W8FVsYDedAhephJhjXa0f95fcCzYQP7r2PK8/eiK6/VvjF4QlV9l9B+aV/prNIedFnh+qQrBxGi171hTBJMwxUe6TLa3+uMOOp4zM2OoQYcGrF3+46lAnfRexg1pG0pyuxwyz8lLXL6zjiESK2QIQoVTel5BW5kalT3UoIXtVy2gFfX+d7qMkXpL6dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHEF9+KSwBuX11Q3aKxjNmJTGC3cJ7ECKjZn2llRdkg=;
 b=KUtPr1xijfwUtzRrWC84echmnOkDJ009UUridWfImADtAUDrBLpPOmM9fFglPIALLlJZJBRn5KQPrbjvJ+NltNhLUNhA1m+1XJyZVlrQZroVfQ9FPsA1V7IaXPL+i5W/TDBeWzqijnuMwc2jFbgZ0xOMjLrLPGL+F7guxoPhR61ybEjWOAyNY/OYooJ4ng0djvn5smgg4XejjJmLMDbiASf79IdME7DCuW9ypaOEc52BP+f20PxV3yR2kVAKCQnWwAoOAEX8W/w/lMy29nDNy15/SOGZ7AucZNfrYXmqKtOexeqMDAm01/R09ufv3yYntpI90pa9OOOdtgkKso37lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHEF9+KSwBuX11Q3aKxjNmJTGC3cJ7ECKjZn2llRdkg=;
 b=V//GxPLaxDbV29KRUQpyiLuzzUDJWXCbM3QXIQxttZeIffl57w8Fg5ZmWy52/UZppOqknd3+OcRr4cWrtwf6znehkt/W+j49HpMRQ7eNBTfxgbxPfKlnzuYFH+eW2pTCWIj8mfIMSxoSUTK6SiEm21msqcpcySLnar8n+hFs7NI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB8306.namprd12.prod.outlook.com
 (2603:10b6:610:12c::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 20:39:01 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Mon, 6 Oct 2025
 20:39:01 +0000
Message-ID: <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
Date: Mon, 6 Oct 2025 15:38:59 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, dave.hansen@linux.intel.com,
 bp@alien8.de
Cc: kas@kernel.org, rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0175.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::21) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB8306:EE_
X-MS-Office365-Filtering-Correlation-Id: 25cec890-1cc3-45af-33e2-08de051861ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHg4OGp5cmxFUVJISmhmWm9VTlkyK01saTNMVVI4QXBxRXVDNEpkQWRBM2tO?=
 =?utf-8?B?aC9CdkozY3dhSXlJZ3JIQ1JtVWI0OGxwcHdCZmV5dFp1MjNQVXJtVzM0OU1q?=
 =?utf-8?B?c3NXSklhY2J4cXZNUVBnQ0tmL3NUVHdxN2dqZlJDSzlnaEZzR1dGRTRpSVV2?=
 =?utf-8?B?cUZMdXZta3phRGErWmYraTZDcm42Z3B2T0t5UDFkaW9xUWFJK2FjRS96em9L?=
 =?utf-8?B?U09JVTNDT3l6azlscW9ucWdFZlgxcmZEQnNac3k0RHk2OVk2cyt3R3dET3p3?=
 =?utf-8?B?ZUpRZlFhbU5TZ2lDQ0ZSTEx2Z3kyUlRrQnJpYyt1cGpUbTcxdmpZV29nUlcz?=
 =?utf-8?B?azV6UkxXb0dzZVVVOUFreThycFNZcExVQXExVVpVTExBVlBtcUliTk80cnha?=
 =?utf-8?B?YTRPcjZONXJ0eFFlandxVFY0WEcwWk05dlI1UWhDNTVKMDE1VDcwTUkzbmxS?=
 =?utf-8?B?RE1ZNDJ6SnpzT2ZGbnJqOFpMTDlWZnFzdXhIdDFVelNmcDFWV0lOeFp2Z293?=
 =?utf-8?B?UUI3SW4zY3ZhNUorVnYzdHJsbXNTNTFLK05ZRmNHb3ZiSmQ2dmU0cCs3OHk1?=
 =?utf-8?B?VjgvNnN1bUtEdG55ekVkWWVLYVI4cC9aY0JWOFFRNlJicGdSd25SNzRTQW5p?=
 =?utf-8?B?VFZEVkhZNktyVUU0MmVhV0xQcUZNRHZ1TUEvWk10bzRFY0MrVmVod0hiT2h1?=
 =?utf-8?B?dis3YW1qWmZXRWRIeUk4OVdQcG12d0VzVVF4WlJzV1cwQ2JmZ1hlMEJmMmc2?=
 =?utf-8?B?NXp0UGNoQUtRd3JkWTFIWjRQTGlUN2hmYXorQTN4RXVqU3hCditONlljK1Fy?=
 =?utf-8?B?NG5PM0ppN0F3cERVdFY3MXRWdy96aXkxTWZFV3R4SHFqMEdyYmpxQW8xWWRP?=
 =?utf-8?B?KzRmL3BEZHpXMHNuWGRBYnBkOXlqczg0R2tScUtEZE9nZHRQN1RFcFJ5KzdO?=
 =?utf-8?B?anRkcDZ1QktvU2FlenpVZWJyMk5kRkgvVUdJWG03MmdjQUNRRElNVjhMTVZ4?=
 =?utf-8?B?VVdvZEtMYzcyWTlXNjFJaHQrNWpqdG14MFV2bFJIcnMxUXRjRC9hbDFFRzQ0?=
 =?utf-8?B?WUY2dnZHZHRudXIyTEpDbzRsVXdGcis0dHp6MXM3Mm9JWkFGTHJWSFh6UUJ1?=
 =?utf-8?B?RjVyQXV3TFBQMDNqZ3F3c1ozay8wME5vN013TXR4TEQrT2RLQUlYaE1sV3Rr?=
 =?utf-8?B?NXpJZ3JiYnJJKytzMG4zZS9pMVI5VTZVaEV1Rk90aWZEM3NMMS9VNGExZjNQ?=
 =?utf-8?B?UGFPYkdMakZBem5XTTVtUmZjUTZCV1ZrOUhUVXZKcjdKcXJjSGttRCtaaW1X?=
 =?utf-8?B?VVFTZ1llS2Raa3pXWHplb2crNkJ1RmJiRERXOUVyRFc5VXdpZVVVSElnbnNh?=
 =?utf-8?B?NS9DZWxzSzgwc2lxaG9xaHMrMVJaUFB4dEhoVmpqWDkzVnJqMUlPb216OWdF?=
 =?utf-8?B?SDZxYlBkTkdVQ3crZnNWdU5QVHp6a0k1cUI0ZG9hV2RNSzNCMlAyTGNHTWt3?=
 =?utf-8?B?QVIrVG5OQWFnQStrUEhpZXhvNHBpR2VmbmJsNENVMDRNL0FhTmF5U2g5ZGtT?=
 =?utf-8?B?bS9yRi90aGhteWl0WlRuUG1zTkk3OGd0SktjWkFvNDBlQXd6b0Rrcnh5VFAw?=
 =?utf-8?B?SEJPNVJWcEFjSGhrcW9RMTVWc0JZY2ZMK1p2ZS9xdWtiUnR5SFIxVXdVS3Zp?=
 =?utf-8?B?ZVRmaGRFZm9VMnFkKzFJSFhGckhkRlgvR1pldGkxUkRISU1HeXNOYitCQW5h?=
 =?utf-8?B?bEl0RThMQzQyS0YzMGZGMmc2Y2xsallFdWdJWEI5WWsxM0pFNE1wbjhqTllT?=
 =?utf-8?B?Y0x1U1dZK1laUUk5V0svc3RkUmRhUGhHM2F6eE9HNW5tbnh2S0F5S1ZrN0Ro?=
 =?utf-8?B?c3hEbUU3VWV4ZmhnODhsYzE4V0FZY2h2QVRhZjdPM0RvWk8vK1c1TmMxR01x?=
 =?utf-8?B?d0pFVXdXSFBwZnkyd3VjajIvMzJzbEowbW50N0hpNlNxYjYxT21EcjIyU01F?=
 =?utf-8?B?aisxZWlJcHRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWRsdTA2TU9ENFNzTFdtV1M2ZEZRVWdCVE5ZbkN2SEk2WEIzN1BLeUNNSnNt?=
 =?utf-8?B?Z25rWk54T0psRExhRFFPVHhmUVIxMTdyRlBBd01jcitwL3F3TDZzK0xOMGVj?=
 =?utf-8?B?enFzdU1WNVR2Zk9zQ3dnUUxVYU1Vd25qWUxveTJTR25Ncm83NS85WXpUUCtC?=
 =?utf-8?B?akd6Q1JFemthN2NMMU9Yd1Izem55Ykg5elE2Zll1ZUZ3VFVmVVA0dFN1YUE2?=
 =?utf-8?B?Y29MWWk1LzlxVE9GbkJIRWFDNVFjVEhYMVlpV01wT1lCMEc5czVCd09xZVgx?=
 =?utf-8?B?SDZSbk1FSTk2MlF6VDlyRW0yZW1DWldkc0lyRnFiU1FmMG1xYXVTS1dnNlJL?=
 =?utf-8?B?MURRaTVhTTFBSWVRaE5McUNsVDI3bUphazRoUDNJUmNnczVMNFdkSU5vZlRS?=
 =?utf-8?B?cktud243ZE5LdURCNnQ4N3Qrc0c1b3pvM3JzdVZHWWluUkFtU3N4RGZ6aE8r?=
 =?utf-8?B?WDBTWkFXS29vS002WXAxWDBYWkNFbFRwZWtQY1g0ODR4enF3eU5lb1I5QTIr?=
 =?utf-8?B?cHEwUDJ0NytZc1pHL0Y2WkhJM2Rwd0VidEtxOWFCaUF2aGIvcW85Sys3cWwz?=
 =?utf-8?B?aEpRUWdRcTY4TzJ2ZEJZZlpPSjRTbzcxTk50UzdEVUpScEhJOFQ4MTBCTnhs?=
 =?utf-8?B?cHUyZG5TdzRlMTdxdEpUbFM5dVFidVd0YzBaYlpiOFo2Sk1ncEVVS2VPa2g5?=
 =?utf-8?B?U2l3OGRyU3I4dFZFTGxNMXgrU2lySUlnb1ZYdXRZVFJ1N0tqYlM0NWFxRm1E?=
 =?utf-8?B?Mm41bDFHVDRaSlJZVWxtYzdIVU10ZXJacFRnQXZjMkd6U3NwNmJ0OGJBRTAr?=
 =?utf-8?B?a3huZDYzQ1FkZDM5bDlWRGZhRXljTWhSRGhQYWpmVTFDdS9vZHNZM1VSMHd2?=
 =?utf-8?B?cFgwb0hCZThWM25tbHdBVXFNQlNSdk1nQS9xWHIyS0hpVzc4NWcySEwyaGg3?=
 =?utf-8?B?dXQyRXBDNjN6NUVEaFBMMWFReU9LMEVaUmY2VHI1bHVVZXZWOFgzWEc5dHdG?=
 =?utf-8?B?VVFXcEFIOHhzdTM0R2cvRlJMRnVYdkE1ZFNOZFRTQmJmYXZpL09xQjFXMElE?=
 =?utf-8?B?NHo5VXlBOCtpVXBqamZQT0gvamFWTXN4MXdLVlJWS1RKa2VqMXlUL0tlYmxR?=
 =?utf-8?B?WVFjUjRtWU1KMnF6RWg1bHFJTDhGMm02QkgvWW1TSjl3U3pSL0VhUUNhbm9M?=
 =?utf-8?B?UnljM2xCeDg2N0VDVmhWNFZzSm5vaE9uQkZEbjlKcFZ5M3JBYk9UTU11T2hz?=
 =?utf-8?B?MkUrQStRVzlQMkRreW96WWtZcytGczRuWVFtN3V3M3V5dUd0OVVUamtYZklN?=
 =?utf-8?B?Y0hSWHN3SnM4MmttamsrendSUXVXVlZhODI5SEhaMmp4ZEsyWEpJcHBkWmlE?=
 =?utf-8?B?MFNGekxNYlZteHlmVUV1RlJuUnNvSmppSVdWMGg3WDd3ZlI0VVZ6UlF1NzlV?=
 =?utf-8?B?b0p3ei9TYUlpaWtjOVpMaTl2dnJrUEN2Y1FTQmRlR2E4NWQzQ3dHS1QxU3FV?=
 =?utf-8?B?T1U5S0haWFVpaFBRaGJxUU1qbXNwQzNJWFVYZ1Jla1hDbHhCd1hJNG9YNXBt?=
 =?utf-8?B?YUlpUWFVREhzQ3c3S3c5UWJvS1FtUENrcXZWaTJGL2w1aU1kaUtSQzNYUWZF?=
 =?utf-8?B?KzB5QkFzdnE3MHZHNjJJTUd3TlN4QWJ2NVlOekwzc2RldmZUSjY0M3FyUnNC?=
 =?utf-8?B?QmE1NzlvdFBkYkVoL0xmOFM1SStOV2txTTRwWTBJTE1QanVndTVHaSsyMXcy?=
 =?utf-8?B?dThBK2EvZjJyUTltYTVlSU5nTlIrdG1ZYXhrS0t0dVJtWFdTTlFNRFk0SDNm?=
 =?utf-8?B?RmUzeVZiVnBKdTUwZHRkblQwdFN4cUhPSWFMbFVKOEs2UUxydFdIMVg5T2NX?=
 =?utf-8?B?dmFNUU9aMGQ4VlI5cmlTYUZ2S0ZpQTNsajRLOTBBcitDWGxzMlVkKzJmMXZ3?=
 =?utf-8?B?YS9ITUNxNzNwd0VwUk9rMkQ0dHlpaWwzQUYyL0o1bmNMTURzUm5Hc2RXRUho?=
 =?utf-8?B?bTcwN1NPZStrNUVGRm5UTEJoS1h6NElSOEhZdG9PckJlMTl4YnZYNnRFWGpZ?=
 =?utf-8?B?TkVtOVNGSFNJa1RPSDhKZmQ1L3orMHBwenJjN3UrUmlzcEtFdW1CeXhQRGdj?=
 =?utf-8?Q?rjck=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cec890-1cc3-45af-33e2-08de051861ba
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 20:39:01.6595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5htXLbidLbNju9sJfEbYJyWPQ6+ekCghAXHAxKykZue3wL69F0G2UMBAksyPLLg1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8306

Hi Reinette,

On 10/6/25 12:56, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/30/25 1:26 PM, Babu Moger wrote:
>> resctrl features can be enabled or disabled using boot-time kernel
>> parameters. To turn off the memory bandwidth events (mbmtotal and
>> mbmlocal), users need to pass the following parameter to the kernel:
>> "rdt=!mbmtotal,!mbmlocal".
> 
> ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
> parameters was to connect them to the actual hardware features identified
> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.
> 
> 
>> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
>> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
>> unconditionally enables these events without checking if the underlying
>> hardware supports them.
> 
> Technically this is correct since if hardware supports ABMC then the
> hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
> and mbm_local_bytes. 
> 
> I can see how this may be confusing to user space though ...
> 
>>
>> Remove the unconditional enablement of MBM features in
>> resctrl_mon_resource_init() to fix the problem. The hardware support
>> verification is already done in get_rdt_mon_resources().
> 
> I believe by "hardware support" you mean hardware support for 
> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
> this then require any system that supports ABMC to also support
> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to 
> support mbm_total_bytes and mbm_local_bytes?

Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have not clearly
separated the that.

> 
> This problem seems to be similar to the one solved by [1] since
> by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
> but instead there only needs to be a check if the feature has been disabled
> by command line. That is, add a rdt_is_feature_enabled() check to the
> existing "!resctrl_is_mon_event_enabled()" check?

Enable or disable needs to be done at get_rdt_mon_resources(). It needs to
be done early in  the initialization before calling domain_add_cpu() where
event data structures (mbm_states aarch_mbm_states) are allocated.

> 
> But wait ... I think there may be a bigger problem when considering systems
> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
> Shouldn't resctrl prevent such a system from switching to "default" 
> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
> to default mode and when user attempts to read an event file resctrl will
> attempt to read it via MSRs that are not supported.
> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
> to handle this case in show() while preventing user space from switching to
> "default" mode on write()?

This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
events are not created.

> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/20250925200328.64155-23-tony.luck@intel.com/
> 
> 
> 

-- 
Thanks
Babu Moger


