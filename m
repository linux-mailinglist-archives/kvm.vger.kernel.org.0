Return-Path: <kvm+bounces-21252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D9692C874
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 04:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 067141F213E7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B03F10A09;
	Wed, 10 Jul 2024 02:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qAoXS1o1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B25D534;
	Wed, 10 Jul 2024 02:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720578344; cv=fail; b=sQ8ncG1AtidMQdtaLAl9yo7BRmk1fInvZURAetD1Z+mDy2UQ8F0bEAezqDcvtR53Hqwmyn6PAzwP+RgIGs86OuZGxOY9hNC0f8qfc7Cg6eyqzV3sdM4JwgAf/Vo+xOiiYuEb930YQNLoRUBynTxX0TP4SLIudghKD/AKDFOr9hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720578344; c=relaxed/simple;
	bh=vZqGA1QrtgA4vnQwdowggwMEDMIwLWO85NR6J2xuNd0=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eyt1dUoEOLNTwigrhOEakkY7dSMTYCxmo8KZywaMFQGb6QQqX+FEDn+9OAQNdP8lphdWoxmU9YldyCF3zfU+Boh1C3QVIMUuTk8KqSz1tz5JMB4HvVdIK1SlvFD7hP3ugmrM2b83kpPFEN8sKe1Zh70c2SuGq84OpXW3IjvZE8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qAoXS1o1; arc=fail smtp.client-ip=40.107.101.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hR0jYx41szIZ09gaL0gZ8cOKpyd9busrLhaZAM1diW+c+Zc28GHOq5Qc9qZVqsUjLq0FBcV6qIsUNPI3hjV8wqdmtd5IRFp87GueEWUhbMKz4gyXcLE/TIuRbA7CSMEwCbfTd1ey8sKNgAQTMzqJxvAGXdngZ9U04FAy3k/ALGuwZ9LB8mLLjYcJ0yMKFGUCSy6oEEOLzK706rdIC7TNZwGj5f0PTfyGKKO2gxgAWmQLsuBuJEzuYLFa5BL4nEm2XX5c8OhYX6xywS9ix/3n7r6P5tnNEKd1KwX+GBaG7ubMv6vWTLjGMxoDczrTvL1uVpR061KB73wXCVu4TpG2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4KhCBvZckT1KxLhCBl09HTi52/Ht1pLaQMTlI3XlBE=;
 b=DnVyXw6KBMCHvLTF7W+LturX71FZF7LTalFYyUGMDqUq9+IAEOC3Y/Z1K4C1ghUxOsqmByU0H2MKY3lDTESrMvNZux+plL/YUeVcl50tBTGDDn72dhu8vOFhrV1eQyHG9GgjYMD+8WpG5sXQvtN7eWaLEmDG0fmeyTqBfuYKwvzPW9+8JX+lFHOiTd+LF6DC9BBHfEGmm4bWVXP43vJJaAaODIrgUQbGR78M/QCpOlxFYW+tp6un2CipxmMtYwY4h6OZAnbACleFF82quiqsfpo3ivje8pEfI+BqavT05uakyQoORyZUwOKXh/zufW6ny8GKRlSVAF3+6QxfnC6Wyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4KhCBvZckT1KxLhCBl09HTi52/Ht1pLaQMTlI3XlBE=;
 b=qAoXS1o154AGa2mz5/uTy3sEsMEvWcUVY7jFV1ps/g6shdqmhLeUaEYk0JB0qNeBXry4RmX/WHu53VWFcZprr5KdK0NgQmHNR3mzTTpaPp8Yv+7C2s7RCwRPi6HYJVXBf8a0c2/aIn3wxzBxL/W6Gq97eya49C9vIgL1eCcQg4o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 02:25:39 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 02:25:37 +0000
Message-ID: <0b74d069-51ed-4e5e-9d76-6b1a60e689df@amd.com>
Date: Wed, 10 Jul 2024 07:55:24 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-4-ravi.bangoria@amd.com> <Zl5jqwWO4FyawPHG@google.com>
 <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com> <ZmB_hl7coZ_8KA8Q@google.com>
 <59381f4f-94de-4933-9dbd-f0fbdc5d5e4a@amd.com> <Zmj88z40oVlqKh7r@google.com>
Content-Language: en-US
In-Reply-To: <Zmj88z40oVlqKh7r@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0146.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::16) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: fc71e7f0-83c2-4cac-6758-08dca0879545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1dDUlZqWXFhK0FsUWg0MU5xcG80cXZ2Z2wrcys0NjVrY3NXWUxQZW4yR244?=
 =?utf-8?B?cThFTnVMdHN3MFIxQlhBaUhmME9VV2x1Y1RUL1B6TVVoYkhnbmprY0V4RWgy?=
 =?utf-8?B?WEF6dlllcGkxNVVJTTBuU1hNMkNNZHJTTUpVbGllWjVyWTdvRzlTWHR0RTdD?=
 =?utf-8?B?VzREc3JqNjJ0S3RUQld2Q3NLbzRhUUNjUWluK1kwL2xCdndSV0FoeC95cFU2?=
 =?utf-8?B?bU55N1U4UzFTZWRhbzNnQ09va2RwWko3Um9GOVhTTm4vaDFWdmxjelRDSmJi?=
 =?utf-8?B?YWlZeFEyazFKQk9idDlFcVVFUXIwbnIrQ1lKYzhydkp3cW9RWnpXRWFpT1VN?=
 =?utf-8?B?OFRITG1WRUdNa3Ewa1BpS0psWU1CT1JOQitSMVFKWFhtRTZyOXdCc0NxS1Qr?=
 =?utf-8?B?K2lUdDE2RnM4K0kzK3I5OUFiTGowVEdHSEFjdkxnNjFIVkVCME1ka1NkMkRN?=
 =?utf-8?B?ZWlJV29IMGo0Q0RDVUxOV0VNNUs2OTJxOHVNT2Uya0pxWTNCVytCU21GbEpP?=
 =?utf-8?B?V1dEK21aVXFLWm9GNUdsVkFaRGJJR0U1dTBCaml3MXNmZm90d3crTXNjVkQ3?=
 =?utf-8?B?VWJaMDJxblhiNGkxeUxsOXRXbEFwbDdRRmxGUXBiakV1R004YW9yTTJOY1Ry?=
 =?utf-8?B?U3dxSHFPRzFoc2FRbkVMeXdWVkZ0VXMwNW5NMWtOZkt5Q0pOSHVWOVp2cjFR?=
 =?utf-8?B?UFlQQm50Z1BjaU9FbzBCQ1MzNW80bVRBbDR1bUNPUG9mc2dRNW5FZ3ZFREhD?=
 =?utf-8?B?S0ZTYitodjRXOFhCWW1hNUJxMmRyZnMxUW0xcDR2K05vV1BmRGNTMEZHeTJh?=
 =?utf-8?B?cVA0dXNFRG5JQzBFZ2QreDV1bHR4cVdMdWppTmVES09EWGFEN1h0WG1OWUhx?=
 =?utf-8?B?ZGdSeWoyWEQwSDEwS3hMdW1INmhlM1dqUWpUUUJHZjRWbENLbjFLcEdBcy9s?=
 =?utf-8?B?bE5IVHJtSjhxcVN6V3hiaHFPekYzYTFJeXlnN2NodEozVjNyMzJoM0JWbURI?=
 =?utf-8?B?aHl4NGtTNGdpTjdWUWU5aHhPM3NReENHSlVvMjJFTmFPWkpJR01zOEp4UW5H?=
 =?utf-8?B?Z3V5aERSWWx6QzlXcUo5bnNkbmlWMHhVT09UZlZSTmFMdHhtMWxZYUF2T0Uw?=
 =?utf-8?B?dFJRck5BbWlENXl4dWI3TzZ1V3k0Y2ZqZHdOWlBhMjZZR2xZeklSUzNGa0ZC?=
 =?utf-8?B?aWMySFpDdXFpbmpLQVFGN0VZOHZGbjJHNjBzSldCcXpHZTFJcnZ6aFQrblVN?=
 =?utf-8?B?NFpUeVpZUjk0N2ZuWTA1bmFWR3htTTFYTW01RmdoOXRYMDFxS2EwRFMwSkla?=
 =?utf-8?B?SUFVUTh1TXhaRXhCeFRneXhIa05SWUp2Vm1IMHFVRFlwaFJoSWRVZGhuRFRV?=
 =?utf-8?B?c2h0bkU4bndtUVVJMFZQTDAzZk1xY2lUYVVjRHdiZjhVLzAyNGc3NzRaaS9I?=
 =?utf-8?B?VlJsYzJmTnBsMkJSTVdHaFlzZ2I4UVpmcVBYNUY0akJBeEswOFRjTWRUVElC?=
 =?utf-8?B?VUpNeUptN3lqWXUxbUJFeG5Cd3YwREtiQkpSM3FqMXp5enhrb3N0NitlOGJH?=
 =?utf-8?B?cU9adGxNQlNjcU1mSEdtTzBwYU55WTBGQ1AyNG00SDdDZ1NucW9wdXZWNm1Y?=
 =?utf-8?B?am9TUzBtMTdWcEozcWw0dE94Z1RBK25HMUxrNWFmTm5aVithT2xpSG5hcmpw?=
 =?utf-8?B?R0VpRFpYOXhxRklLTllaOFFPT2xwSUxyMno4eUdVQXZndDE4LzNuOUJSQjNj?=
 =?utf-8?Q?2uc20evr2oRb6UpXLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dG9YbGFoZTcxeWgxYnJSbjhrblJrSzh0WGJVZ1lqK0Zqa2t3YlJVRUtMSDU1?=
 =?utf-8?B?YVdZQVlndFMzYmM4OHNDdGFTY3NDTnI5Ukt5MksvcHRjS0dWOStJUjJjbjU2?=
 =?utf-8?B?YjVjSVVib2NnNEhyaGZmV2xxcTIwM2VheXErQ2p5eGNSRW03TDR6ZlNESkhJ?=
 =?utf-8?B?MzZDY3RCYnRsMnQ2Rk5ZVUNVcVFZQzFxUTlONWpXN1BqajBRRnZPcktldy9Y?=
 =?utf-8?B?UkMrc1N4czRmUVc3THo4NjQyTVFmUHIyNEZvYWJ2eFoxZldHWXR1MjcyWE9Y?=
 =?utf-8?B?TEpJNllWRkJQQ2tKMVNCMmVwUkRIWjRsR20zelgwdkhzdkdaMzFuVzZqdnNU?=
 =?utf-8?B?NDVSRDMwVzN2eTI3K25aMFh6eW02WWZVYUVLNitNd0poNEEyU2xQR0JQMzVv?=
 =?utf-8?B?d1RYTDZZYkJqWkcrWUdURittOGZrSVpMYUgvOUlycGhyWjBSN2hYcEVjS2Zn?=
 =?utf-8?B?aG81OGdzc3h6NStDOTdwTzJqMm81VUtpRi9KOTk0blJZR2ZMbjhqanlSdjNO?=
 =?utf-8?B?OGFmamxEMXlFcEUzTUlKK05nbHZpQ2NGV1MyUElaWGczQUNVU3hTQVRoVWtF?=
 =?utf-8?B?SllkRFFldldlelNYamZ5cElVRUk3MlRuc0laaUpzTEVXNXNFWmdjYk1OZEVE?=
 =?utf-8?B?RndUMnlWYlJtc283MU5nN2F4NEdaaFlyTXNROEorYkt4LzlkTW9KSWpyM2lZ?=
 =?utf-8?B?Zll3QUxCd21LejZ5MENEemVyLzVLdHB3S3U3bStmdzRJU09oNktWR1Z4UWtC?=
 =?utf-8?B?ZkZPRnNwd1gweHNGYnc4NXlPb09ObWNVdTM4NjF5d0NoU00yNmxlREM0VTJW?=
 =?utf-8?B?eE5OdU5FT2cvOXQ4RzVoZ1NYSTBrRjhYdnhxTkwyTTdlVjJ3dU1Ta0lJeEtr?=
 =?utf-8?B?YTR3MHVvNmVNYVVnS0wzd3ArZ21RQlN0Q2ZweFYySXRJZWxWZmk3QklVQTZV?=
 =?utf-8?B?SUZDMzg2dkQrWWIzeFQ3UHdqRXlUbGpTWGgvYzQvMnRTdGtOR2k3ZDNYT2tO?=
 =?utf-8?B?RDh5T20wUjBReWZFalczeE1Md053YW85Z2pMalJVM2prNXZCRVZXMEdWSFdE?=
 =?utf-8?B?QUlSZHg1eDQ5bDEzMXdRbHpzZllha3hScE9xMFVlNnRKdW5qN1hBWkRYdkpT?=
 =?utf-8?B?bytIaXVOT0ErMjQxU1ZCM2JUMng1ZVorQlFiOUJEMk04MnJrOGE4aTV0Smdn?=
 =?utf-8?B?NE95bE9GWUlLQUtHMUR4RjNwZ1FlNUlXZ2pTZnhZeE9QZUVyaEdrN3VZYWVU?=
 =?utf-8?B?SXZGUm1OZ2lmeHN1anBOQUFIQUEzN1kwWkV5S0ZCYS9uUnlCS1EyanFuQlI1?=
 =?utf-8?B?cnYvc25hbi9Cbko0WTdxTEVWSzJzNXJDTHlTc0dtdTdMRzVDdXNYMFYwWTN2?=
 =?utf-8?B?M1Z3Wjk3SDNaaVFwNjVTSGg3YlgrajFaSnhJMnNtT3JJU0pvMlVmQmh5cE1W?=
 =?utf-8?B?RU9oeHBvVEhnZ2dxbnpocGZJc21wSDVqWmRiMWNHZVJQa0tuUGRRODViV2l6?=
 =?utf-8?B?aDlGZHB6ZGw2WnJoam9Zei9FcGR5WHNiRlVkUFlKdXNlWlk4d2RQQ0g4SWND?=
 =?utf-8?B?RzQrOUZnR0VHSkw4N2Z5Syt4TWhaMUErT0dSZmlvbUNkZk41Mk1CVFNQN0Rx?=
 =?utf-8?B?bmxUTE9VQ1UzR3A4UFZWMTBpb3hhTU1PR3BmYVNwZ2FVR09CZ0wrb1FnbTdL?=
 =?utf-8?B?Ymx5T1NBZlJFYW45ZWNucGhCcC9PbmJJTUh2VGNwL2lQZVcyYWVPVlRLUXdZ?=
 =?utf-8?B?NC94MGFpa2UwcWRsdVVwWVZCU2VSTGlCaDRaMGNJVEJTODhKaHBWbmkrOFRr?=
 =?utf-8?B?Zk1MVXBWMTBjMHhvdG9yUXUxeUtiejROTmJpZmY2Z3lpUzlhc2loL1BzdlpC?=
 =?utf-8?B?VWlnVUlyVUlrOXl1ZG1ySU5hdEY3a2pLU0wzU0hxQTlYc3JyaHFyU1NYaExD?=
 =?utf-8?B?dUd3dmt2UTFaSWFBdGdZb2NtQlYwSEJLOHdxVG1jRnJKSDhtTUtIMEd1WDFv?=
 =?utf-8?B?VEYzOVRWNmpFTEExazBhK05yOUNMamlJWTY3SytJR0hZaE5lZkhyWXpQM25V?=
 =?utf-8?B?ZVZGMFdIVlVNYnY4Ujl1N1hwSFhxV0tVL0Y0VHU0dUZWYWlxaCtNK2hxTXA3?=
 =?utf-8?Q?dVIxUt3blvj5r/3QIqI3KP5uE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc71e7f0-83c2-4cac-6758-08dca0879545
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 02:25:36.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g3wMyhvjT0Qtphg089AdgTwXtKJjNmJFlX77CTb9MFN1fQTZSBh/WKrsnTcqlxLA7Ry7z3lF3T7usSLmAvuDxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345

Sean,

Apologies for the delay. I was waiting for Bus Lock Threshold patches to be
posted upstream:

  https://lore.kernel.org/r/20240709175145.9986-1-manali.shukla@amd.com

On 12-Jun-24 7:12 AM, Sean Christopherson wrote:
> On Wed, Jun 05, 2024, Ravi Bangoria wrote:
>> On 6/5/2024 8:38 PM, Sean Christopherson wrote:
>>> Some of the problems on Intel were due to the awful FMS-based feature detection,
>>> but those weren't the only hiccups.  E.g. IIRC, we never sorted out what should
>>> happen if both the host and guest want bus-lock #DBs.
>>
>> I've to check about vcpu->guest_debug part, but keeping that aside, host and
>> guest can use Bus Lock Detect in parallel because, DEBUG_CTL MSR and DR6
>> register are save/restored in VMCB, hardware cause a VMEXIT_EXCEPTION_1 for
>> guest #DB(when intercepted) and hardware raises #DB on host when it's for the
>> host.
> 
> I'm talking about the case where the host wants to do something in response to
> bus locks that occurred in the guest.  E.g. if the host is taking punitive action,
> say by stalling the vCPU, then the guest kernel could bypass that behavior by
> enabling bus lock detect itself.
> 
> Maybe it's moot point in practice, since it sounds like Bus Lock Threshold will
> be available at the same time.
> 
> Ugh, and if we wanted to let the host handle guest-induced #DBs, we'd need code
> to keep Bus Lock Detect enabled in the guest since it resides in DEBUG_CTL.  Bah.
> 
> So I guess if the vcpu->guest_debug part is fairly straightforward, it probably
> makes to virtualize Bus Lock Detect because the only reason not to virtualize it
> would actually require more work/code in KVM.

KVM forwards #DB to Qemu when vcpu->guest_debug is set and it's Qemu's
responsibility to re-inject exception when Bus Lock Trap is enabled
inside the guest. I realized that it is broken so I've prepared a
Qemu patch, embedding it at the end.

> I'd still love to see Bus Lock Threshold support sooner than later though :-)

With Bus Lock Threshold enabled, I assume the changes introduced by this
patch plus Qemu fix are sufficient to support Bus Lock Trap inside the
guest?

Thanks,
Ravi

---><---
From 0b01859f99c4c5e18323e3f4ac19d1f3e5ad4aee Mon Sep 17 00:00:00 2001
From: Ravi Bangoria <ravi.bangoria@amd.com>
Date: Thu, 4 Jul 2024 06:48:24 +0000
Subject: [PATCH] target/i386: Add Bus Lock Detect support

Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
in AMD docs). Bus Lock Detect is enumerated with cpuid Fn0000_0007_ECX_x0
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM[1].

Qemu supports remote debugging through host gdb (the "gdbstub" facility)
where some of the remote debugging features like instruction and data
breakpoints relies on the same hardware infrastructure (#DB, DR6 etc.)
that Bus Lock Detect also uses. Instead of handling internally, KVM
forwards #DB to Qemu when remote debugging is ON and #DB is being
intercepted. It's Qemu's responsibility to re-inject the exception to
guest when some of the exception source bits (in DR6) are not being
handled by Qemu remote debug handler. Bus Lock Detect is one such case.

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 target/i386/cpu.h     | 1 +
 target/i386/kvm/kvm.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c64ef0c1a2..89bcff2fa3 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -271,6 +271,7 @@ typedef enum X86Seg {
                 | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
                 | CR4_LAM_SUP_MASK))
 
+#define DR6_BLD         (1 << 11)
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
 #define DR6_BT          (1 << 15)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6c864e4611..d128d4e5ca 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5141,14 +5141,14 @@ static int kvm_handle_debug(X86CPU *cpu,
     } else if (kvm_find_sw_breakpoint(cs, arch_info->pc)) {
         ret = EXCP_DEBUG;
     }
-    if (ret == 0) {
+    if (ret == 0 || !(arch_info->dr6 & DR6_BLD)) {
         cpu_synchronize_state(cs);
         assert(env->exception_nr == -1);
 
         /* pass to guest */
         kvm_queue_exception(env, arch_info->exception,
                             arch_info->exception == EXCP01_DB,
-                            arch_info->dr6);
+                            ret == 0 ? arch_info->dr6 ^ DR6_BLD : DR6_BLD);
         env->has_error_code = 0;
     }
 
-- 
2.34.1

