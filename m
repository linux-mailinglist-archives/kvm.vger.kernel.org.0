Return-Path: <kvm+bounces-34388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB889FD253
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 09:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CB903A0410
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 08:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC091553BC;
	Fri, 27 Dec 2024 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WeSCmZYd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938B1876;
	Fri, 27 Dec 2024 08:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735289940; cv=fail; b=bYojKVbxzRK516Qm1NAVhkhhOXMyhicDIUhv8hth1ogHOBr7leG2I4sRkt/rXaJ67qK4LV3zgvM3Td9aD6FCuVhA4/GKxoetK1oUYX/QBxBvuWNLq7T521rIHAgVk+KUhS5e/TS6aM7xuh544P441o+JQqMKIhY3B7Brwm0VGcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735289940; c=relaxed/simple;
	bh=EeHMxj0Huw4E7FWbpqklZAg2tluHhaqTeuUNuosVZ0Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HAo2jBqEeKCOCx5H65w5rLb3k/tXJ41tVbSaH9pGB3CmFWNjuzE7hvgdKEpljANklt97Zvcmo76ZGTPoLEnbaTM5zOnbmhMU3Mdo1JmYpS+UJa1pSny7zqIHJFwcH+f9AKbW+ZEna1mkLm3TMOlRrobAiCjRklgcNAmkISwq/os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WeSCmZYd; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RFIrZDuxQqN6Iq5GS6QTyNIXAPJkfkwYppEhunHdxFa74Xe7P5OAVk3Zb4QKlav1Agld7YGqM/8LnmOlevtKRI82f0GnJvG/BgJNqh1avGKyT6fxt/Y84abQgnWl14C6YIz5Xdw+uWTK5vNEtfP2ndyujI0ygDqxAkrLVQQA/xOcbfCE773vgAHr++YnrkwyRLxNkn0DilazF9qo6WgrcyqNGnZZTQylqSjkdXC7WWLeAN0qXGwuzLeKIvPkP5rGyVmp1CRYUuMd1V1Qej3zCpSEk1MJdH4JE1qlQ/QpQvx9eSV9JJ2nz/uK5iDYP3n4igi/9vQHL3D78NdI1/owMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qL5zWguhs+xxMTBSxGuAv/aive1wL9IcsfzNBNkkWvc=;
 b=fT6SLcj/Hnha2K4fmSPmVpVMmoun4/dR8JkFm5enGxwXBtXsPUrpS6SWiIiR4X+DbJweJRVDHNEDD7y7SRRL5hHANdBAkl5wMIWoqD332OrRnBE4MhZAoO2BWevwMNFxANba5sjIA74BBh+cvDGC1m2Ct8dymCuHz1kfjoNYajPqYb3tv9ohrk82GJnqH0F+sivCG8vppntAUS7NS1WPkBJvlpAZnrwKIGTQz3AN+2TqEN0Yo44+KfH4MLch5nCer7/0rMeBu5j+1kYAiBKj7R5O/22SnRa9QjXrAU1+w5uooINHcl5WIF0iwREHo/Rip/tsQnelATaIWhUYrUcwPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qL5zWguhs+xxMTBSxGuAv/aive1wL9IcsfzNBNkkWvc=;
 b=WeSCmZYdoIgNhVo8H4LRVZnxHvzL4fwUXibpPcNq19hYqjkrVUODDreZrtZHm5aSQuQDBuTe2/ok3E2mWLm/Y6F5tQCqVXx6Ojf2NXI5lzpTQqQIt3hRrVd2UGLoUGrwRTYvfjO5zhApa8Wo1SnGnHdK8mnBal4bCQM6N2EkzRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6987.namprd12.prod.outlook.com (2603:10b6:510:1be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 08:58:52 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 08:58:51 +0000
Message-ID: <08045113-a4a1-4dd6-be66-0c794559d212@amd.com>
Date: Fri, 27 Dec 2024 19:58:38 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 1/9] crypto: ccp: Move dev_info/err messages for
 SEV/SNP initialization
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <ddbf0b28d3c7127e0489ce7ec817b9b4f0c9d476.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ddbf0b28d3c7127e0489ce7ec817b9b4f0c9d476.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0032.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e421e72-7434-4abe-7fb2-08dd2654aece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXkzcUJPeWFDSG1hdkw4ZGY5ZVlobWxrellReFVBR0kvVXVjejZBbW1aOUh0?=
 =?utf-8?B?cFIrS1d5VUE0ZWhITEtZREx0RmJkUnB0d1ZJSTJabmJWbmRQaThoR1ovengv?=
 =?utf-8?B?UGp3SlYxVHBLMkNQalBiaUNwNzdIWGppQmJaK1U1ZTNwZEp1ZTUzaHBqazI5?=
 =?utf-8?B?SWZPYVZnL1NrSFJZUFI4eGhMZDVhalpvQ3pkQno2cFZEODVRaTRyNU83YzdF?=
 =?utf-8?B?RTcvZnNGTnJzODEzNWtkUklpbXNFaGg4bUkxSnlxeC91WURwdlFxZFNHeWh0?=
 =?utf-8?B?eks0M0FyNkEyWVhQZHN3a2tCOFFTTGFtV1VsWVY3Y0tZUndVZHE4SDl0QUpj?=
 =?utf-8?B?VTA1ZldmWDZWRE9WS2FwR0E1SCs5dFdHNWkxaTUvVDJjRkFXM0Y3YU4vRDhj?=
 =?utf-8?B?bGlPSDllQlAwYnBWNXZDaU00K0xxR3JmVUpXYXBVU1BKOFVUQkJOTlBkWG9W?=
 =?utf-8?B?ZXErZVlFcG5IVCt3SWlzcVdoZ3BXYWFiaEZyTTdLZ3c2NE0wL3pPZ08zTlZu?=
 =?utf-8?B?OG10NFhxdVdUa3RIaFR5cWo3dHJUbkp3cDNranFybFBxM1dDTzZQTGNOK0M0?=
 =?utf-8?B?VHNLRnAwUFFVSVp2Vyt5aEE4Zy9obHZicVVudWRFVis3cE4yaVpJWFhLREFZ?=
 =?utf-8?B?UE95ZFk0Y2s5WjBLYWQ2QWJDYnFoR2pFeFNNOTBVUVViOW1vTjFUUSsvWmNp?=
 =?utf-8?B?QlY0T2pzNEhDSHp6MHFsZUNRNStlaEhOS1RCcG9SQ25GUitYWEtBRTBSMzMr?=
 =?utf-8?B?dmZkT09TOGhSQUc3eVlTWEU1dmhSSHlIbW9nSWFKbGE4Wlk2VEJMOUhCck1i?=
 =?utf-8?B?YXNZU3ZCRXFMTmNTRlB6aTF6V2EvOUZRWFNCZXg4ZU5la2RQQjVJZ29ia2ln?=
 =?utf-8?B?NFd3dmU4OGtUN3ZFQk12cXhPQlpwdUtjMisyYitHdU8wMzhrTWhTRlVZNGZv?=
 =?utf-8?B?RjcxMjF0TkdId2JOQ1NQckIzVnIwRUVaLzc3aW5qVXY5ZGNPZlc1a1htVDFZ?=
 =?utf-8?B?Tm9FM2h2VTBOVFJQcEF5eHZKSzAzaTlGWlNpeDMwZGEzY0RNNnU2TlBrNUsv?=
 =?utf-8?B?YjBha1BQaWtYQm42Q0gvcEpoTWJGQXNDZFBweW9oak9nQU8yd1BWak9NS1hh?=
 =?utf-8?B?OSs5UmZ3ZjR3SUN2ZGFvM1Fsc2UxNWdOYUpkRlkwM1NGbFhLamxoM01DalRk?=
 =?utf-8?B?WEwrMm5WQTlwUFUxOFhKamlHV1lwZXlLODdWc2NxMG5SWEJUL3BKeURvcmZ3?=
 =?utf-8?B?blI4dFVvK0ZXTGR5bWxIdi9wRE1uL0RlRTVscklGNmlvVXRqOFRGVERuZDJt?=
 =?utf-8?B?SEVMZGdSZkl0Q1ltQzc2M0pRWlFNNDVadkIrUVBSdVVvWldkQjhub2xGYkN3?=
 =?utf-8?B?Vk5TcnpBWmYraE4wa1VBYWduMnhOU2FrN1ozNUJoTitveDRTUzQ2ajZxbEVz?=
 =?utf-8?B?OWVHK0loU1RWbVgrV3ZlUmpONWJKKzN5K3RVdTUwNGoybmt3Qi9Hb0MwTDVF?=
 =?utf-8?B?RmFrWHM0ZW1SaXo1Tng1eFJHbGd0V1B2eXBqV2hwVUxaSWh3MHJnMVg0OHU2?=
 =?utf-8?B?aTZ4TEwzcnh6dlp6OGpSV2Z6RU54RDJZeVpCK0RzRmhOOUhHVmdrNUFSOFVW?=
 =?utf-8?B?VTYycGV3YlBoN3NBdFRHNXcyRjdnd3dGTnRwWkVwTzAwUWVLQlBvdnJvU0lJ?=
 =?utf-8?B?eVMvOHZlaXpoV1BWdkFneFQzUE5FQmZHQzgvQW56TmltbFo2RGQ1U1lubTcx?=
 =?utf-8?B?T2lSSDZGSDA5a0tvaHNvdVlaeFRyU1k1ZU1tZ2hYb09ITEM1aEt6cXFVUXlJ?=
 =?utf-8?B?TkpjNEplR2NrazBNUGpsOWRzOUtHQXI0UmtSOHZ0T3BrVEhKQ2JmME42WWpG?=
 =?utf-8?B?enBiUForZjFrOUdkYVRrYkVXc3JtaU1sSTJjRFNOQzJoV212S1h1VWVtOEQ5?=
 =?utf-8?Q?girPoFQZXUQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVJiYVlGMm52OU5WOXFTM1ZtckdRSnhTcm5zOUZHYlZ1YmU2cStkM3ozNllY?=
 =?utf-8?B?Rm5RNERQRFVGSWtBak5yV014dnN6QXE2L09WeDJOL2xMTklXMGtCRVRpM3BN?=
 =?utf-8?B?d1h4VUI2TlJsTm1SUE1ma3RxMUlVT1lqT2ZkM1ZmdTZ4NWhpVWVvK0pnUTg2?=
 =?utf-8?B?U2N5eTltb1dCZFgva3FCdVV5Q1lEenFtcDJ0WjMyeVZtdU80V21mZndPZmJi?=
 =?utf-8?B?eUFMRzZQVUUrTVJnQ3pEenhZNDI2MVFDUVU4bzQ5aGZxT3JzM21WQXgyY3lt?=
 =?utf-8?B?NmJFT2w2UElNYU1DN1pJUHhXN3lxM1c5WTQxeXhHa3FTclBNVEFwOStTTllV?=
 =?utf-8?B?b3JTNXlwd1FXN29Tbnl2cGExSlJjSnVsVEpnMXc1S0ttZVh6VkNETlJ6Mm96?=
 =?utf-8?B?RVlCSTV3dEp6K3RzWmFMUFRqbmpYeENpSzdIRmVGRHVqMlA5c3ZMb2J2bzdk?=
 =?utf-8?B?WHRiZ091ODdZc0ZMV1ZEcEwzRnJBWElhRnJNNnVINThwcm50VjBiblM3dENp?=
 =?utf-8?B?aTRJU0tjSDF6RmxFRTRVUjVSZzlYRHJYaE5xVkdUbGNQTXRnMURieHR1Q0R2?=
 =?utf-8?B?eDhDQUY2MUNuelgwV2lQR2kzUGJmZEVIRWFyTm5nb1hXQzk4K2ZrbEE1WUhw?=
 =?utf-8?B?R3k3c1VDdUxKTytnSjFTU09heVlkc1hTTktGRkVLR2FpVmFsWWRoZ1BpVVFB?=
 =?utf-8?B?aytWcUFONElTZEkwMzBTWkpRTW9IY0Z2OW05aXFNMFB5STIxYUswdWQ2M3Fy?=
 =?utf-8?B?WktvYU8zNThXQkNhVFZYNWJ5OGZCWVB1N2lXT0xDZTllZDJsRUZlejdVZWFQ?=
 =?utf-8?B?clloaHdJaXltTERFL2M1OUVmR0hlUDRDdExiT0JLK1JiMVFJYzk3MzNqcVpX?=
 =?utf-8?B?c3RBN3hEQktWY3NRVVVWMmZZUmc3ZlF0Y001Mk56TllzL3d4aWZhTnFPY3dJ?=
 =?utf-8?B?Q1EzZHgrUEFqeDR5eFRqZXg2L3FPMmsyY0VtT1c1Q3N0S2FacmQ5UElsdXhL?=
 =?utf-8?B?NVZ4Tkl4MTNORHdQUk1rS01SM2YwTzVXWW5iR0RCanQ1dzdadXl4dzhBcm41?=
 =?utf-8?B?VVlDaTM4eUo0OHBwdTl1enZZYWpVQkpRMVJiMU9VekJaS1NQSFJJVjFYZW5Q?=
 =?utf-8?B?Q2p0QmowQ2kvZW1EUXc3RVNpYXVtOFRkRUNDcHpHSmxDaWNLUUREWS9DanZx?=
 =?utf-8?B?czlHVlk0Y3ZucHdYMkdMQ3RyUGpZeFhJaHhodXduR1RxR2p4NTI0ajgwSHpB?=
 =?utf-8?B?ajVsZzBwZXZGd2UwT0ZnVHRHdEZlVUxUS2k0S0FNVUt6OFQ4RDRNVjlLWCtI?=
 =?utf-8?B?ZFRuZkJkZExJSEdMTGFBcDRrY3lTTUtuRjBETmJiUTRkMk1zWDBnYzZnZDNy?=
 =?utf-8?B?V3loVHBTcmsvc1k1MnVSWUJLN1ovV0VpeHVlQk9UbTRGTE8veGJCNkg0VXNa?=
 =?utf-8?B?aHFqVUxKcjNPT1RPaGRscnp4WkozdmtHcDdVUXhWbnlEbnN1UE4xcU9CUHVQ?=
 =?utf-8?B?Y2JENVBrWnVCVmY3eFlmNTZzdXhLOGlXd01DY0tHbjFOdXQ3T0VMN3pJVEhk?=
 =?utf-8?B?Y252VXZhY1VHVXltZmZrL0NqRmVIN3BENWw3QlV3OXZYdExZY2RubG53cEVC?=
 =?utf-8?B?SitwNTdnbTRyaDU5TFM3aUhxT216a3U1dkJVYXJZRXZPcW5BRlNVR20rMEQx?=
 =?utf-8?B?N3I3U0EwVVZJNnNudmw4M2FNbVc5aG55UFFsQVpZTnhON2w4MUNwei9PODc3?=
 =?utf-8?B?SFlCVXdTT2hDUUROZXYrVk12RHozS1NFVy9jZnhoVitnbVRIUjdLZmE2akMx?=
 =?utf-8?B?YTVPUWVqeEFiazduNWhrdGJQRHhlalBvZlpla1JCcHlHakpQSXNWZVlJdmJ5?=
 =?utf-8?B?NFlsUFJ2VjZuODVkdkJraHdzQm10bGdyT3hUV1ZUaFVCMll3VExxWVUrK2Ft?=
 =?utf-8?B?TzZHWjdMeUgvbktXNkUrc3hVUXVsZFZMeTFDRVAzaE13OVM2U0FxV1lOOUUw?=
 =?utf-8?B?MU9OV3lSNDJ0NFBXdVdBM1VFTVV2NEExVUpVZmdCYTVyQmdBSVhicEJhMGRa?=
 =?utf-8?B?MFdNWHc1TkhNQXRwUi9tOTVCL0NrRVJtckFoQ015SG8rdGVQOE0reE95Um9W?=
 =?utf-8?Q?f5Qj0+fKYIvskwICgp6vYJthW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e421e72-7434-4abe-7fb2-08dd2654aece
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 08:58:51.4511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdIwn6QTt2YDEW8IifjVgUd34jkxMJlIknTwrqswD0/60voRBq7WA7C6ohXs/0J3NRgHuH1ySUO6cX9MSuQ3vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6987

On 17/12/24 10:57, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Remove dev_info and dev_err messages related to SEV/SNP initialization
> from callers and instead move those inside __sev_platform_init_locked()
> and __sev_snp_init_locked().

It is not actually removing anything, only adding.

> 
> This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
> to call __sev_platform_init_locked() and __sev_snp_init_locked() for
> implicit SEV/SNP initialization and shutdown without additionally
> printing any errors/success messages.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index af018afd9cd7..1c1c33d3ed9a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1177,19 +1177,27 @@ static int __sev_snp_init_locked(int *error)
>   
>   	rc = __sev_do_cmd_locked(cmd, arg, error);
>   	if (rc)
> -		return rc;
> +		goto err;

here ...

>   
>   	/* Prepare for first SNP guest launch after INIT. */
>   	wbinvd_on_all_cpus();
>   	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
>   	if (rc)
> -		return rc;
> +		goto err;
>   

... and here are different calls, and the message below is going to say 
"failed to INIT" when it actually failed to SEV_CMD_SNP_DF_FLUSH in this 
case. I'd like separate dev_err() for both. Other errors in this 
function do have own dev_err() already.


>   	sev->snp_initialized = true;
>   	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>   
> +	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
> +		 sev->api_minor, sev->build);
> +
>   	sev_es_tmr_size = SNP_TMR_SIZE;
>   
> +	return 0;
> +
> +err:
> +	dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> +		rc, *error);
>   	return rc;
>   }
>   
> @@ -1268,7 +1276,7 @@ static int __sev_platform_init_locked(int *error)
>   
>   	rc = __sev_platform_init_handle_init_ex_path(sev);
>   	if (rc)
> -		return rc;
> +		goto err;
>   
>   	rc = __sev_do_init_locked(&psp_ret);
>   	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
> @@ -1288,7 +1296,7 @@ static int __sev_platform_init_locked(int *error)
>   		*error = psp_ret;
>   
>   	if (rc)
> -		return rc;
> +		goto err;
>   
>   	sev->state = SEV_STATE_INIT;
>   
> @@ -1296,7 +1304,7 @@ static int __sev_platform_init_locked(int *error)
>   	wbinvd_on_all_cpus();
>   	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
>   	if (rc)
> -		return rc;
> +		goto err;
>   
>   	dev_dbg(sev->dev, "SEV firmware initialized\n");
>   
> @@ -1304,6 +1312,11 @@ static int __sev_platform_init_locked(int *error)
>   		 sev->api_minor, sev->build);
>   
>   	return 0;
> +
> +err:
> +	dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> +		psp_ret, rc);

The same comment here. For example, I saw the "invalid page state" error 
from the PSP soooo many times so I believe any command can return it :) 
Thanks,


> +	return rc;
>   }
>   
>   static int _sev_platform_init_locked(struct sev_platform_init_args *args)

-- 
Alexey


