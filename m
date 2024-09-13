Return-Path: <kvm+bounces-26831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C94F2978534
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EE931F21763
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B08C6D1B4;
	Fri, 13 Sep 2024 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b0tOtKWt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576BC770FD;
	Fri, 13 Sep 2024 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726242804; cv=fail; b=VpZcuTQovFvTH96XJU+7u84mNWcCerM4iHGeZJXD9hhMZ3lzvrENpCM7cuXtPEtoj/tZYMTN9lqn/lb5iocX+vNfPP2zyVQM/rXM2zURMqjEqxHLkxtvJ2NiiQauAHoEXCUeSUBOVEFOnNv42pldcAideK1oV9Arsf5woppeHcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726242804; c=relaxed/simple;
	bh=nrKkP3QhB1pbYPaJP1NUif3e6j/2GexCyhf6PkCWwEU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EANOGkA794Eo8F4BFkodixbd3N+1ym3pmf+D9XXm5VjGo8zqHh/D8r+2LflBNrAjGDAQqaE9tkmunKxfduspngFq4vTL2I80GPwUOdM2xtBK8XkX0Boc0VLkgO3JSKSIVLMWfJHjVpIMzUjNJutW8RYhLGIN3ulOtRLNJBfTUSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b0tOtKWt; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PfU+yx+XNV9kebPB9A+DCOv9ri6jdAqIal8hL8wWG+Y5nur1SkYlP5FYYM4WFVoB8gmg7wTwkF/UbtxVN/grfVQzKy4/+GsDPuQtbwRCQIcdG+56urlyzQU4UHuq0XooilBQYhK1Z7a422Mm3hBri85VU6q5wTXjgAzDillfD6UM+JMwNyQrqpAdag8VJElQ1tGBx3Z0DLYCaVVWEdpwnT2zI/qHXG1mWBXI6Y8zMDS6FzC9psrNo9fPvCS8kM3SUL4VzhetccFu3T90nl5l/a0dDPNKKbcnxZr7u8KGxfV4hgtt+XIrsN/6OiVDUkoGT9SX5YV36+L61IQ33+Pw7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Va/rjDGo6SLTI4IdEcRjeJOqMEOYYeKjG3bNT6ZxWWQ=;
 b=w5JFGZBA7qRqaoTTU3wBH09AXaKsBn12hPWIeoCM8g0pDg9nLsxdxp3hxHIN1lVvmsX6Zk+3zP17Rx/fSU1xFa2m1BCTLiGUuhO1Nf7/pEw9ftCpAC3iTEIP6Girob6UQMZJ9P3vYZMozYZZOYC4KnPpJmKwScFj+6YPwzj8zJ01zya4KYEL+wVPBUHbKG57QsTkYLTL7yPZ5wUT4VFZcjsZ8wJRAAzDeOpceH+8QcsOqKW+hQ6JcW/7MwSbywc1vjCIMYEqfispFWPW1YlCJ62B+kvA7Vjks5+bG4YzlVH53glwbqncUUgH86H1Cx0L7k4dH46+sMtcjrUCvFKAsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Va/rjDGo6SLTI4IdEcRjeJOqMEOYYeKjG3bNT6ZxWWQ=;
 b=b0tOtKWtRbuaJ3KXxXzmNOFOnbXb+sHdEpNNgCMpqFGqn9nW7gyFGF1usFfDMoSPIJ3BCvHyaZHZpbfSwJYOsecUn/s3yerYXoQUu/fKZOVxCwsiNNNXpwOvCU5DEp9RP8oGYvEvtO3IBFrmuvad8uM3qiDduvmKugGyfk6pGOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB6656.namprd12.prod.outlook.com (2603:10b6:8:d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Fri, 13 Sep
 2024 15:53:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 15:53:20 +0000
Message-ID: <83ff0326-a423-38f2-9a35-7cb1da77e649@amd.com>
Date: Fri, 13 Sep 2024 10:53:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 11/20] x86/sev: Carve out and export SNP guest
 messaging init routines
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-12-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-12-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:806:130::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB6656:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c587d3e-dd10-47db-c236-08dcd40c30ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkVyVGVDZG80MWwvQWV5WkdOZUZ3Z2VQVGhwTHEwNDhuVjVYRGU2UmFDYWRY?=
 =?utf-8?B?STh3R1lQWVM1ZjJjZ1NoV0RmN3lDMDk0dXUvQm55R0lZN0NpZERLejB1Wlhj?=
 =?utf-8?B?Z0JsMU0rUEI0YWxDdU1Gc2dGU013TE9lL3hHT0N5MDBHS3gxRk1EcXJjd2pw?=
 =?utf-8?B?Qi9kcEhjU2VQQmxDWVhjZG5na3BHODZoRUtIVnRPaGtxNkswMnZaWVRJS3c3?=
 =?utf-8?B?NmZ1M1Y2WnF3U3l1TWNLN0ZwLzNxeFpEaEJDR2l6d3VOVCsySG5HNjBvSE9K?=
 =?utf-8?B?ZS9NbHF4SXlGUHJ4S0NNNHdEZ3NKbWZuZi9SaVpMMkMxVEdPeGJjVnc2YW1p?=
 =?utf-8?B?a2ZGSi83ZTc3Z1lER0V2eEkrMEJuOS9DSzhJdmw1bFQ1WVc1bmRrbklLWXNy?=
 =?utf-8?B?TElQQ0t1N1YwZ3RWNjhXREdGdDhIUm1tS2krYWhQUUttaVBDWkgyNFUzUEp4?=
 =?utf-8?B?ZWV1UGRVby9iN09nUzdqMFpKR1VaRzlsR2VwVG1lNTRuNS9WQUY5bzZKNk8w?=
 =?utf-8?B?NmxnL0lqYVREM1RTQUVSNDRlZ0hScUJ2MVN0UlAyVk40OVRVNTRXcjNVUUYw?=
 =?utf-8?B?bVJzSnVyTlYxOEZBRzF0UUp1ZHN3Njd4OXVTVXhtYTNxWmVXcVJrQ1RpOC9j?=
 =?utf-8?B?T3RmNlFDeGUydXkzeGJTNmdseDZKRU1WZVdybDVMbjBYRUtacWh1MGhEVXNN?=
 =?utf-8?B?UXRCby90USszSW45WnV6T1JONEwxTUpUTkJEd2VseFJNU2dRbG85M2tZMVhl?=
 =?utf-8?B?ei9qTHNXeEVBRjFqQTh4ejRlLzhCYjc3WkNQZWl3aDd5RkdsMlYzT01YQ2dX?=
 =?utf-8?B?VXV6eFFsRkQ5UFIwVUxkRnZXazFXb0NNTmhDWGZPYUx6K3VFYnQzQkZ1NUdD?=
 =?utf-8?B?a05ueDU0QXQreEcvNCtsajVBN0dxcDF5M3ZLeHgxZzk0OHlHT0FoUTBYWjRK?=
 =?utf-8?B?WHlEWXkrOUZ2L1VYRGpxVzJ1dFBkR0ZUT0w5YUU3RTF3WXE2Wk0vUUFqSTZU?=
 =?utf-8?B?TWFDOWpnbTVYVTlCamREOEZveUVpQ3V0QjJ1NENXN0xkVlN5NWNQUGpoODVP?=
 =?utf-8?B?eVBmeHpiUnd3SFlvNTlaZWFYZnFpUko5TWZkQklUcEJnbit3eXZCdFliLzlG?=
 =?utf-8?B?TElsMWZ1ZVl3UFlJMExCZVNFendCYTc1d25HbEVPdktvSGxndnBXSnhSbnl3?=
 =?utf-8?B?b2J2RmhuMUxSTGRMbExhYllvK3d0b0N0clZ5NmF3eG1lVk92Q0pZbDFHM1NB?=
 =?utf-8?B?OTFzamxsdDhoRjNwaEwxQzgxZUNOTlRXOUhWUWpKc2YwY2cxZHBTT0hTdnRB?=
 =?utf-8?B?dldZSWplTlcreWhCKzV2QWxxbytHUjJCRUw0WVY5MEUwMTJ4dElFYVJtbS9V?=
 =?utf-8?B?dXN1d1pGZWh2NjZ0YnFSMEFYbnZpbWVTb3BmNXQvblJFblBTemJoWXk1cFha?=
 =?utf-8?B?eTZ2aktpaUQ4cXFSVm9CU0piUTBhSXVmd0pBWG9RQTRVUk1LNVUzUlp1dmNJ?=
 =?utf-8?B?Tkdmb1F5ZjZzL1A3NXpEY1VnUHhXR0FWa2g4UjlBb01ic3c1eDZ0bk5JakV5?=
 =?utf-8?B?bFBGTzFCU1FvUzNiODFzYVpUMk9lNnl6amN5b2tHSVVrZnNIMEVOK1NUdURi?=
 =?utf-8?B?MjBiT1ZWVCtBM0I5ZzdFLzlZWjlUTkt0TFkrNWdIcWtocWFZajFyMW9jQkxC?=
 =?utf-8?B?RWxiT1FWa3lXUVFyd050bHQ5ai84bUlJOFMxUTB3ZGZaKzZMMitXRHlVWlRD?=
 =?utf-8?B?STMxNUFOOHBQdVRxL0pSdWlJSk5lRzV6UkVJQUpLWGZZdG1oWXJYUTdxbnpY?=
 =?utf-8?B?UGVWbXFOdkhCMEJJVnExZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDYvU01YcXgzRkhWNXNsczE0QU1yaUJ5bXdmZFZLQnhUUktVTGRtMjErbmtP?=
 =?utf-8?B?aVlGUVd2MXVQVWFHcDRMa2lKQkIvWlBZVVZKV3p1bm53RkFtSndFa2MwRkhL?=
 =?utf-8?B?OExUMXhORnNqc204dy9sZHRiZkU2bUxUTWlHQ3d2YWFEMlBONHJMR04ydG1G?=
 =?utf-8?B?WWMwcmtmd1E3QkxjVisxT3k3eHNkcFQ3K2tGZ2NVdkxPNEgzTlhOSTFGaGV2?=
 =?utf-8?B?c2xvbXlEZFE4TUU4YzNRbm42aTNFVHFrY2JqcGR1QXF4WmI4cEc4WnBhc1Ri?=
 =?utf-8?B?ZEprMncwTzJ2cmpJNXJmaXZRRDcyMFRwQktzTDgvVUVFbkJreXpHTjJUVTBL?=
 =?utf-8?B?WHRFN1c5V1BseWZ2bHF1STFyOUhhOGNCcWZ2eUlLMDArNzdLOUlaNGsxUXBp?=
 =?utf-8?B?N1E3Umw2ZDU5SWR6MEw3Yk1naE1TS2puaEN1NHN0RzhZb1FIL1JIZ0psRVhi?=
 =?utf-8?B?VHZwbXpUZU9ydDk3S1M3TFNZUXJtTjNHTGEyVW5md2drbEw5R3ArMDhuOUFl?=
 =?utf-8?B?VnZWalVVZy9ESFNjOUh5M3NoMlAvMHpwQ3dkUkszUi9NWlpWUVNjNnRhcEor?=
 =?utf-8?B?NzMrWEk3cHVmZ2UrTlUxNGJNT0pjN0dPTVlvaGZ6NWU3ZWU3c2xTWWtaTllJ?=
 =?utf-8?B?YXlMMnBibFhkbTR6ZHhpanZtOHlHdzV4L0FhMmdLcTNUcDBrR0pYaGdmaXJu?=
 =?utf-8?B?Z1EwY29yakVHdHdoQndVTGlJeldUTUk1UzF2VnpVZk4yUm45a01VWW5aMThm?=
 =?utf-8?B?ZlZmb0t6RDlXNFZoM00wR1hwS2RENnZMTkdoQit1U1cyL1V6dVRXbllSRnQr?=
 =?utf-8?B?UXBlWVRLZGU5VzIyRENMQWxqYTBxTXFLc3NUVzcxK08weTlwd2N2T3hVbHVv?=
 =?utf-8?B?blY4bURLZXA5NHZXU0dPU1ZGOTFBS0ZrZ1JWVlZiaGZJb3NEUVRrZlRNaDBm?=
 =?utf-8?B?eDNGTXFSaTZzVEgxMGwvQis2c3l0U2E0djd1b0Fmbkcvc01MQ2FMc24xUXB3?=
 =?utf-8?B?U0tjV1ZxNEtGNUs4Q2xFSTJCenRhSVRLMWdYQUNmLy80RmtxdjJUMDF3QjNN?=
 =?utf-8?B?WEdEd3BIY29WcllRR2ptZjZzWnZHbmdiZHZCMlYxbGxxOU91VUdQdnZGVTRZ?=
 =?utf-8?B?aGF4MFF2akZSSmZQcE5reG9nV0FQT1NJc1RMSVJObVJHT0xtejFOaWN1Qmlp?=
 =?utf-8?B?L1BmSEFUTjRZRmZ4d0Nwb1VVcnJ0K3JPS3pvMkFva0NkWDBEWG9Gc3cvd3A0?=
 =?utf-8?B?QkFNU3N6UGtSSUg0cUhWeFNaRHdQRzYrL3d1cWZpOFhaWWtzQlMzaUlpZzVQ?=
 =?utf-8?B?alJiWndabmIrKzczc282WmlYekNISHY4WUNsdzdQaVZzakk3cTdqWVJVaFFy?=
 =?utf-8?B?R1ViRjk0cGNnbVZBbTI2bE1URTMyTXR6cmM5c3JNMit6ZVZsY2h1YUpKVHU0?=
 =?utf-8?B?bW5HeDBvcTQ2U3V6Y3luY1I4QUs1azJvdjlZdGFVY0czNDA1MGFtMnowenEx?=
 =?utf-8?B?TjF5QkJ6ZlZwdFd6NkgzTjVFSGRaTGRQZXlFNXZNZnR1K0hDamZKMzNxaXI2?=
 =?utf-8?B?SnlaWXNLbzgwUi9acGV3K254TFE0bGx3cWZWSFYvUVJRTDhvL1ZZTnQ2L1Jx?=
 =?utf-8?B?Y0FLbjZNU2lxNG1rNEFJTHVqdTRIc2o4NE5rZGxnTHowaDR0T3p5STVIQ0ll?=
 =?utf-8?B?eTZ1R3dUOVdZN0crOW5wSWM1VWJYQkFUTnllMEFIY1BLUXllZTQ3KzhDWWly?=
 =?utf-8?B?MFFJOG82UFI0YjBFTURLTFZ2SGRzdm8rZXVkTWgxZkJwS3MrV3pXbDZFRnVV?=
 =?utf-8?B?SEJEMEUyVGFnTjJkT0ltYi9UTHlHNmZ6ZHRPQzlVUzVvS3pmeGl1MzFNWjhr?=
 =?utf-8?B?dlZGNEk3MjV1dW1vVjdway9sOS9yS0dwUExxMkMvRitnaFZRbitpdktQdlAr?=
 =?utf-8?B?bnNYb3gxbDVYQ3lsMmpDNDZLYVlNaG5JN0t1SEtkeEI2azgzRmVUc2lGWnZu?=
 =?utf-8?B?ZFQ3b3ovRTgvN0Rwdi9KbXVMOEJneEZuMFA4V2lKS3NrcDJ4clErZXJIaDdt?=
 =?utf-8?B?WGlXaDVYVkgzUGJVNm0zUXBFWE9qRzFBai9mTWlFMDE5eGh2OWh5Uktld0Rn?=
 =?utf-8?Q?Z4F5lKWLL0nMvihEzljqJ2ZEN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c587d3e-dd10-47db-c236-08dcd40c30ad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 15:53:20.2881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOgqpNXevZ5ZsdQEk99bY06yoDznJlgQgXThTaTDA4K28UxwrCCuambbwhm8HO0Z3OuK4vTL68kp1eoHLtu4Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6656

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> Currently, the SEV guest driver is the only user of SNP guest messaging.
> All routines for initializing SNP guest messaging are implemented within
> the SEV guest driver. To add Secure TSC guest support, these initialization
> routines need to be available during early boot.
> 
> Carve out common SNP guest messaging buffer allocations and message
> initialization routines to core/sev.c and export them. These newly added
> APIs set up the SNP message context (snp_msg_desc), which contains all the
> necessary details for sending SNP guest messages.
> 
> At present, the SEV guest platform data structure is used to pass the
> secrets page physical address to SEV guest driver. Since the secrets page
> address is locally available to the initialization routine, use the cached
> address. Remove the unused SEV guest platform data structure.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h              |  71 ++++++++-
>  arch/x86/coco/sev/core.c                | 133 +++++++++++++++-
>  drivers/virt/coco/sev-guest/sev-guest.c | 194 +++---------------------
>  3 files changed, 213 insertions(+), 185 deletions(-)
> 

