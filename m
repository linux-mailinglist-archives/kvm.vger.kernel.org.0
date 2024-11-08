Return-Path: <kvm+bounces-31268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC9F9C1D5E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 274851F25A44
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 12:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB4F1E882B;
	Fri,  8 Nov 2024 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xHpUFsyw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2082.outbound.protection.outlook.com [40.107.212.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD961D0F5C
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 12:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731070393; cv=fail; b=fwmoTrsiU8c0PUwN7s0K6SyaNZ8nJ9pwKIi2qj2RhOqbw3PA508CsZ1ixzvvTZJfMdeNl4FpK6YL/C8puh6JWm16W/APLlmIC4tAqpLhQ2K+HfbVY4ugfQsjj22PLDo20WwL2Xr8rJUCfqIajBg6nsJNBBe3jiNo/if79+cVJKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731070393; c=relaxed/simple;
	bh=wYRhmo+l/yhEqa7h2XSsNlwuGVTU/bPWsVJBvdZ+97Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RrgRTOhZuE0CCyoC1xThgt3Tm/p7BmgOJW+72jVz5V7AGJI7wZvA7VeWHb3Al+JWB/+6VPlh0CcYfRcQxm72K+4va09OmnPAbEbvdP7fZRRPI8gjDd/FpLGCLu1Fpoq35yNk8x5SsVuZhff4jDdFCGTbpqbAyoHBgl56knL6M3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xHpUFsyw; arc=fail smtp.client-ip=40.107.212.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IheTNJ9PmHYVqjPUoXRJ2GgT5EYHO4RrMfoTPVLJGn+qkCNiNS74xu3COOjoN9bCUPwbGpfDjp8JEmgx04TzCwdTDVYXMm3tVWXuGGIur7JnTD+nmKxS43mhzX2sKHRP5IHz/LgmpqnuykMy12LRhsclsCN2SfofEaEiE978BvflHvaA98aixI14dXeImMlm/7WcoSjcuRZkqI3xaWU0ERMa2DYxoTlCj3VV2F5tcbvAMeWORYiCSCI/LddyLVa4Ku7XDXbRSrUAVkLVpBv8PcI2ZLs/9VHZyVjiEB0EXZ3o3maBkFL62fyxsF0MPzGI+uqFqFWM7fMyr5ffXhUb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNpneZBTmUk7ktxzoCcAra5HX9zSjMnWZg4w9ZRhOmI=;
 b=XJN/LIXGVEglgpfBS6Y6xhSU7hsjSuG6Y197HAs/cIDwsvENeB4xHx4Q+XQmWnX1n5g/62lxUmx2WTrMEODX0+FKOk1EEIV0wcmXCVqgysjGUI1sbHGWAPRroxE1R9zt07NOpRcjjm5Tkx0xS/5pJAZKIQazJa9+m4HSg0gSfgmb9nQWFH1k1MhrQheissiTOAOib5a0IMU6spYYWj5Sc+gFPUaIdi4GCVpTbWkX7O7J11LGTcg+f1a/5A5D6GZ/q9wKBKiIKQb41FG6tY279+ymdetFtXb3xtxj8nymqDFWp5tyhwIenTFsHAI+chxJPURfHMzOzsm3aTg715Tlsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNpneZBTmUk7ktxzoCcAra5HX9zSjMnWZg4w9ZRhOmI=;
 b=xHpUFsywA4PuRlKmrHVXZEJEvo4OZqNNWBu6X7aosfTysZJE0C4b/Z9c2cnoMOQEvtkgz+AcUKdKkP95+RREQFZMLuYTt/H5gj2lZEcM86aMktChKMTRV7cXwY4zyiZLH763D3k9u+DQwAVcDZlLXlpIe9wAbJIfnZ//X9AR9+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Fri, 8 Nov
 2024 12:53:05 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 12:53:05 +0000
Message-ID: <0bf54df0-7ee4-4814-94ab-ea970073403a@amd.com>
Date: Fri, 8 Nov 2024 18:22:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
To: dongli.zhang@oracle.com, Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 lyan@digitalocean.com, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
 davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, zide.chen@intel.com
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com> <ZyxxygVaufOntpZJ@intel.com>
 <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|PH0PR12MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e22a80-bbff-4dc7-e7c4-08dcfff449b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3c0eTRnSnRrK1k3alp4NStYMm5CYTBnai9Leld3b2Q3NG5LL2hReFRiT1Zo?=
 =?utf-8?B?QXdkRjVsM2VTaGJSaTNJNGhGQS9ndDdrejgzZVN0bUd1TG5rZ25lMmNMQ2Iw?=
 =?utf-8?B?WEFibWVlbWphWS91czdvc0pDK0YrVnhmbmxPNU8rYUQvZ1hZemF6RjlSZFp5?=
 =?utf-8?B?T1lIR3NoRG1MYk9PS0RoUUJGRjdWSWY4ampaOUNnY0pjVFpBcEhTYllQRFM3?=
 =?utf-8?B?U0xCQ2dxVUNldGplRXFyR05UeGt0RHkvRFp3cHVWc3JQYTVkWmlWaEF6eHdB?=
 =?utf-8?B?ZXIyNEdZZ25IU1grd2ExTUZBVzBBckt2ZFErMy9oV2ZLelZHS2JRQVlrbWpt?=
 =?utf-8?B?OGJ2ZmJqN0ZaRmg1SzhiaVc3eGw2RUdpSUdvL0JQVlhoWlJmdjBoWFVNcHdl?=
 =?utf-8?B?bVY5NFhpVHBrSm5Wc3lqS0JGTUJUMkdzM040MC84VTNRNkxRMlVzd1pDQnNw?=
 =?utf-8?B?WVdHaFFsV1FOam5uZVJtV1llWjRLRE8yRXlGUmlZb1JPWkltTHRYT1RNRVpm?=
 =?utf-8?B?M3kzY2RYczBLcTJvR3M3dXBXUTlndHUrYmViVFdFZHFSQTdzNVoyeFJwbW84?=
 =?utf-8?B?QmlTRm8zTkhpYzFOc0VqSFVuN1NzRWRzaXhzSE1oOFRoMTNWaG1ZVE1ua2hU?=
 =?utf-8?B?enBJbEd0dlV3Z1VnUmZiaUJNVUVGUVZYYTZ4TXQvWW9SUHlFK2FJaCt3eDRT?=
 =?utf-8?B?VFdwRmJRNGo2dXgvbFVWMTNldFg2L1dRMDJlUjRZU0hCLzVWRjA4WXZBS3NF?=
 =?utf-8?B?bmlHbHozVnVzakxwa0YyQ1daTTNLMGtNSHBzTWtKV3hEME5GL0d0Y0c4WVRC?=
 =?utf-8?B?d3YyQzdMZjJFUWxtdHZQRHY0eUtUUUJ1QjIyby9PTWdjbFQ4NFF6Q1JTNFk2?=
 =?utf-8?B?ZVJXM09RZkp3UXFoUmlPZVJqWGdncVljQWd3YjZUN3NtamxESDE1TG13Qk05?=
 =?utf-8?B?Y3NVSXVMcUhkczF6ZzZoaEVNcm85eGRiY2d0aWpFWWtXQk1XNjBwMHN1Um1T?=
 =?utf-8?B?a2E0NDlRSUN2KzRkMnpTRFI0RFA2MmdlRVZhd1lvSzNsMm9STndYMzRTalRS?=
 =?utf-8?B?akc2bUE4QWwzeGRtTkxKSVRoRFFCbVBVUGJKUFVXdmNmU0o1WmE2ZExqditx?=
 =?utf-8?B?TG90a052SStmamRCMGl4RnBWQVBmWVJ4Nm11RitRNFpYU0xwYXJjLytGdmtH?=
 =?utf-8?B?aXpGV0xERnNYa2kvdStqazd0cjZqTG82ZXliZmMyYS9VYjNacmtMV2VmR2Ux?=
 =?utf-8?B?emlPRGpCSWNqcVdtVlRieWxOc3Vja3B5MkthYXFzN29kY3hraVVJeWcxWUxL?=
 =?utf-8?B?WVhzK1pZakpNM1FZdWRxUDZXRXJvekFua0M3dy9GcXdMb0ZOUjl1SDlKSTF0?=
 =?utf-8?B?VFpYNkRqOHk4a2NLQlc2UjQ5RW5lS1lnemFYc2FjUG5ncEJuUUFwQjVzQjlL?=
 =?utf-8?B?c3VCWndsMmtFU1RtdndDQ0RoNlF3YlhLcDlJOVdaNGM1R3F4MjYvOUp3ZWNq?=
 =?utf-8?B?N2tYanp3aTVJUDA3bkZObUIwd2lvZVRoSHNSbEdxUFJDMkhpMENlbjI3RGFS?=
 =?utf-8?B?THNyVUFjMTc0VWlMZ3V1UzEyMHBQU09mTVQ4emgzNEdDd3dOalhycDBSOGlp?=
 =?utf-8?B?bis5RTA5UTJwLzRHUGdHd1V0aW5LTjMySHg1YXF6a1psNnNRTUsrbGsyaUtO?=
 =?utf-8?B?eENyRy95Mi9zSTBxc3BSRjR1ZGVjZXdRRTJ0Vk5haTRseG1Ib3ZlSjRqY1dZ?=
 =?utf-8?Q?/5b0h7ZMg4a46FVnU7jzSTQpA3vzeNr49qo5mm5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXBKQVl6elg3SU5Pa0gwWC9FWFJRZWFOaGFLVjRUMXh4amZvSHE2SThMcW5M?=
 =?utf-8?B?MHVSN3RRSWgyN09XK1UvV2RIbHlPWXJYZmxSNnBCOFJ1UGpoQ1JDbTVqWjBz?=
 =?utf-8?B?aEFLWHNNV25jQ2p6bzFBWjhJbkZCT2t0a1dEa0FNL3c3WWZsNTBFUFVjZXdG?=
 =?utf-8?B?VVdUS2NRcHI0d2g2cVVDMllLOXhZMDVtK1owZnRqM1Z0Ykp2S3J1ZkdtZHlz?=
 =?utf-8?B?S1o3VG4vUE4xem5kNWUwcUR2bGYyUzNzeEFjNCs4aWVpdUw3MFpucm9wL3Vi?=
 =?utf-8?B?ZXc1VnZNWDhMWENubXZvZVRTYzgrY0gyTHhFbm1rL0thZFgyTCtIZ3J6TU1N?=
 =?utf-8?B?ZW5kcU5Oam9sbEdEdGQram5WeVNyMWF0ZXlxaXZUdzBaZHQySHFWcHNJUXlS?=
 =?utf-8?B?MC9xZWlvWmlhTzJqMzYxNk8wT0c4b3dFWkxuV0V2SWVYbFFrdTVNV2VuaTEz?=
 =?utf-8?B?ZkZBcTg1ZHJnTG82UWNCSkcxdEtzTG03ekNZY0tNV2hCeGdodGxNZHNxNW94?=
 =?utf-8?B?dUp2RjgxaGROeTNPdTRhS0RzeGNQenlrRjY4dnhUNXhManNCdERJRlJTaUt5?=
 =?utf-8?B?L3h6YXFzMW43MDVRZ3h0YjAzamQ4c0xDMWJrWkhmY05uTlhvMllqU0lYZUd2?=
 =?utf-8?B?WFZlMWxTdkZML1BZc3dHejVXUWJMalZkL3FKNEtRWmwvU3dXcVdFcSthcXho?=
 =?utf-8?B?N25KTjFKRmVFMnF5UmV0RUdjMFFQWmtTUlM3dXFaak9NVWprdU5VZnNaYXdZ?=
 =?utf-8?B?SHlKejJST2Rqem01T09OUFpEajlZUG1CSy9lTzFFTGE0b0lON3NWR1ZXRnBx?=
 =?utf-8?B?WksvdFIvNWJyUjdXS1dkSm5KcDZHbUdWTmdZTFlLcmlWcmQvUzN6amdkbktx?=
 =?utf-8?B?dk9hS3owZXFESHZWK2FSN1NqdTRKV1BGRlFTaExGZXFBL0p5elg1c1RjdVpw?=
 =?utf-8?B?eXhWY2NRRXdmbnFTOHRHUHlNOEFNKzNnYTJPTDFFdHpvMTVPOTE0Qjc2YWxI?=
 =?utf-8?B?MkQ5K3AyaWx6V3pEb1lqaHdHRHRwQXlxdVNhMjQ2TTIxZ2NyUll6aExXNFE3?=
 =?utf-8?B?TGI2c2c0KzdqbmppeXNvTkNWbVF4aEhCMjR3VTN1RmRSaHZwMUQ1bTc0WlAr?=
 =?utf-8?B?bGRhbktVM1FUOC9ocnk5aGg4TUJvTVY5cFBOL1ZvZnJOd3hFNmFqWjc5S0lv?=
 =?utf-8?B?aVVTb092Y1VGVTFNb2srMXhRVmRRbGlLb2czdGZtanBnUHFkMjRGQ1Z2QmZC?=
 =?utf-8?B?YWtLQUNuMmNSWHNId3VOZUFvZXFMaEZ3dHJTUW1mY1krdFZoTzZZRW1FRjUz?=
 =?utf-8?B?bE5YRFcvUVdTdGxZUmdRQXB6WUt5UTRnczc1OGFxeHEwZURhWkRaSlVCWE1U?=
 =?utf-8?B?L1JnRENxRmtsK1hzOVozUmthWXRXNzRweXhtbU93VElJUXpJQTI5TlVyOGtE?=
 =?utf-8?B?dkhXQlR0cGk4UTVUT3NLN2UwSXhuUlNwNjZ1TTNIQ2I4a29ZNkVxU2pCMlAx?=
 =?utf-8?B?NU5hQjBMekI1bDlZK2VpRnlFMGl1M3Z0cUJJY1VxbFArMlB1b2FkUzRkT2Ny?=
 =?utf-8?B?bTk2QTd1TzF1N3BNeTloTWxuWng4dkFiTzBnQVVsci9TNmdxdERoMW1rUnpw?=
 =?utf-8?B?TUUxbUdXS1hPVUpNU0hNRjE5VCt2dU1RbmNsRHdnWEJhTkRBSytqQzUyZENO?=
 =?utf-8?B?MWJhTWtGNXIycjJ6SU9rN0thVnVPSUhWaVVtN3g5Lzh3dVlPZzdjMnlNU3g1?=
 =?utf-8?B?SjFhaXQ5L1F4Z0pyZTBpWGlOaVJFd2Y3WUFBRDhvdXdYR1pUc3ZRQlZxRFdu?=
 =?utf-8?B?NjFjWVljZWpUTGxFb2pWSlRzbFJVb0xBQm1tQ01iR0hxZmQ4eTloNXR4NVBi?=
 =?utf-8?B?MUUyWHh0N1YvOXVaQVBuL3NneGwrNFhvNjhlNG53b3FtMnVqdzdJb2Vxc2hH?=
 =?utf-8?B?MXFiTVhCN04xVGVXWFloVnU4RktxQ3U3R0xiZnUzNXluelFOaGJzejh3NzNJ?=
 =?utf-8?B?WW41MDBUcnkwdmdqeDlCN3BySDloYjNGQ0x2WlNnZ0ZZclhVSXIyK1hNL3hr?=
 =?utf-8?B?ZWQ1Y1NRU05NZktnT1pmTFNwTjRCVXE3Sm9RQzRXTUNFcmFLQ1BnNjBMT0Z6?=
 =?utf-8?Q?9+tlJZXA7WnnMVpT9x+AwtfVz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e22a80-bbff-4dc7-e7c4-08dcfff449b0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 12:53:05.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mx8e0i0Ahqm2MMJV0i7PmJudb0b3/JI8YtQDzhkM98R/fKuvNYFolhdlw66Faa7v2VY0XXy91j9ieRytLQ0Cjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646

On 11/8/2024 5:14 AM, dongli.zhang@oracle.com wrote:
> Hi Zhao,
> 
> 
> On 11/6/24 11:52 PM, Zhao Liu wrote:
>> (+Dapang & Zide)
>>
>> Hi Dongli,
>>
>> On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
>>> Date: Mon,  4 Nov 2024 01:40:17 -0800
>>> From: Dongli Zhang <dongli.zhang@oracle.com>
>>> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>>>  KVM_PMU_CAP_DISABLE
>>> X-Mailer: git-send-email 2.43.5
>>>
>>> The AMD PMU virtualization is not disabled when configuring
>>> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
>>> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
>>> virtualization in such an environment.
>>>
>>> As a result, VM logs typically show:
>>>
>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>
>>> whereas the expected logs should be:
>>>
>>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>
>>> This discrepancy occurs because AMD PMU does not use CPUID to determine
>>> whether PMU virtualization is supported.
>>
>> Intel platform doesn't have this issue since Linux kernel fails to check
>> the CPU family & model when "-cpu *,-pmu" option clears PMU version.
>>
>> The difference between Intel and AMD platforms, however, is that it seems
>> Intel hardly ever reaches the “...due virtualization” message, but
>> instead reports an error because it recognizes a mismatched family/model.
>>
>> This may be a drawback of the PMU driver's print message, but the result
>> is the same, it prevents the PMU driver from enabling.
>>
>> So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
>> behavior on Intel platform because current "pmu" property works as
>> expected.
> 
> Sure. I will mention this in v2.
> 
>>
>>> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
>>> acceleration. This property sets KVM_PMU_CAP_DISABLE if
>>> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
>>> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
>>> x86 systems.
>>>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>> Another previous solution to re-use '-cpu host,-pmu':
>>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Nm8Db-mwBoMIwKkRqzC9kgNi5uZ7SCIf43zUBn92Ar_NEbLXq-ZkrDDvpvDQ4cnS2i4VyKAp6CRVE12bRkMF$ 
>>
>> IMO, I prefer the previous version. This VM-level KVM property is
>> difficult to integrate with the existing CPU properties. Pls refer later
>> comments for reasons.
>>
>>>  accel/kvm/kvm-all.c        |  1 +
>>>  include/sysemu/kvm_int.h   |  1 +
>>>  qemu-options.hx            |  9 ++++++-
>>>  target/i386/cpu.c          |  2 +-
>>>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>>>  target/i386/kvm/kvm_i386.h |  2 ++
>>>  6 files changed, 65 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 801cff16a5..8b5ba45cf7 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>>>      s->xen_evtchn_max_pirq = 256;
>>>      s->device = NULL;
>>>      s->msr_energy.enable = false;
>>> +    s->pmu_cap_disabled = false;
>>>  }
>>
>> The CPU property "pmu" also defaults to "false"...but:
>>
>>  * max CPU would override this and try to enable PMU by default in
>>    max_x86_cpu_initfn().
>>
>>  * Other named CPU models keep the default setting to avoid affecting
>>    the migration.
>>
>> The pmu_cap_disabled and “pmu” property look unbound and unassociated,
>> so this can cause the conflict when they are not synchronized. For
>> example,
>>
>> -cpu host -accel kvm,pmu-cap-disabled=on
>>
>> The above options will fail to launch a VM (on Intel platform).
>>
>> Ideally, the “pmu” property and pmu-cap-disabled should be bound to each
>> other and be consistent. But it's not easy because:
>>  - There is no proper way to have pmu_cap_disabled set different default
>>    values (e.g., "false" for max CPU and "true" for named CPU models)
>>    based on different CPU models.
>>  - And, no proper place to check the consistency of pmu_cap_disabled and
>>    enable_pmu.
>>
>> Therefore, I prefer your previous approach, to reuse current CPU "pmu"
>> property.
> 
> Thank you very much for the suggestion and reasons.
> 
> I am going to follow your suggestion to switch back to the previous solution in v2.
> 
>>
>> Further, considering that this is currently the only case that needs to
>> to set the VM level's capability in the CPU context, there is no need to
>> introduce a new kvm interface (in your previous patch), which can instead
>> be set in kvm_cpu_realizefn(), like:
>>
>>
>> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
>> index 99d1941cf51c..05e9c9a1a0cf 100644
>> --- a/target/i386/kvm/kvm-cpu.c
>> +++ b/target/i386/kvm/kvm-cpu.c
>> @@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>  {
>>      X86CPU *cpu = X86_CPU(cs);
>>      CPUX86State *env = &cpu->env;
>> +    KVMState *s = kvm_state;
>> +    static bool first = true;
>>      bool ret;
>>
>>      /*
>> @@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>       *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
>>       *   cpu_common_realizefn() (via xcc->parent_realize)
>>       */
>> +
>> +    if (first) {
>> +        first = false;
>> +
>> +        /*
>> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
>> +         * disable PMUs; however, QEMU has been providing PMU property per
>> +         * CPU since v1.6. In order to accommodate both, have to configure
>> +         * the VM-level capability here.
>> +         */
>> +        if (!cpu->enable_pmu &&
>> +            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>> +            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                      KVM_PMU_CAP_DISABLE);
>> +
>> +            if (r < 0) {
>> +                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
>> +                           strerror(-r));
>> +                return false;
>> +            }
>> +        }
>> +    }
>> +
>>      if (cpu->max_features) {
>>          if (enable_cpu_pm) {
>>              if (kvm_has_waitpkg()) {
>> ---
> 
> Sure. I will limit the change within only x86 + KVM.
> 
>>
>> In addition, if PMU is disabled, why not mask the perf related bits in
>> 8000_0001_ECX? :)
>>
> 
> My fault. I have masked only 0x80000022, and I forgot 0x80000001 for AMD.
> 
> Thank you very much for the reminder.
> 
> 

I think this may not show a functional impact because the guest kernel
would anyway not register the core PMU because of being unable to access
the PMC MSRs as a result of KVM_PMU_CAP_DISABLE but its the right thing
to do because the guest OS may not always be Linux-based :)

