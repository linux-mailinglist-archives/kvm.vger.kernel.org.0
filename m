Return-Path: <kvm+bounces-40449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE1DA573D0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A244618912E8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391062580CF;
	Fri,  7 Mar 2025 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v7cA2pwJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64F82405F9;
	Fri,  7 Mar 2025 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383602; cv=fail; b=i/bQH14l1V1ZdWszPgJkZz3317r9slaspXc334/jeH26zPvEOaQTMou4wkjbxV+MHnfLPzSEXkfqdMP2UiMGYH7a2A7O2uC8Y+Z5F5nR9CIR2I4NloVHtavZMPbYqU79Wd0Q3RF2Q42T4rFxnWfPitAk0E65UPf8MorkFCzg5sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383602; c=relaxed/simple;
	bh=iSjPvpL4JjZuQDlR8CYCOlctlQ7NHqR870k/GCJ8RqM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LC8uU56ma9pKzMw76iLFXMqHI56H46EL/7+m7cUbWhUZBxh69qIoHleFZaqgRYtVk/PwJ1KeDnF8njLvEXga85SwjHwywbCaCVbZdPvTztP81UVrTAt+cDR2e6o02ep9mrhvUXmrMfvhGWfLBcir90N+MyZux9fGDFhezjPpsQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v7cA2pwJ; arc=fail smtp.client-ip=40.107.101.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNU2bm6/XO01TfU/2vMCVHXa15Q4ilSuwhRYpT/EKl7c29oKqOC8oZFNmRS9TYJnFM7uaAXRe2Q0m8fOVqG6rjUaKKWNleIFzZ4WTv/D/aMp314UIAh5YuoLt5xxXM2FeyUaBCTONXQmYPQDQAedqAJjzG+zfkZMGDEs6YbckjuV6Q+owvxSjFoMKWRtGT6ICMfd4LrxndDkhtdpFgrzvUOySRJqX5CPa+oEG1+J2qZ3hUyND0EjzhiYF3ATCbi54J8QAAb9D4iA5cS45p8whTMNf1Op2yL99W/vDl1u/h1hemtwJlJtm2hNqiDykK48A8x9OMU+aNgylXgsBxERGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0T1+vM4FYvfYiHlxbxXBaXM5Yonq6p5GneQjeVNn9/c=;
 b=fRyrFlCCeOqQJnogNjQUimL3EsNimnNQr7XGVZNSQLw3eWMid1/Hg1JK2L6JLIs62JHGVt/sRLgzvCY4kq6HcqBF93nB4G7pLcDDgzLHJOgSgNTKEYTlLeDsdqBycOmgbdJEO9IndIFtxzpVye/dbSDdBNly+c6fmhzPuuVqzb0Q4QLpQqcKehBOac5y/XuNRxxVJILuIpn8ExEcFUN/onzH9aKAFKB7x6e9qBJIQHAvt/6CSYZIqWCgWqxUWBRklJvo51oEwDCiVigEsDsBzqhk+/3huk6Gc2efffEvPvxmeAmnZsaXrxkO5FMHqcGMd3foU5NlccCmNYmHLaUMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0T1+vM4FYvfYiHlxbxXBaXM5Yonq6p5GneQjeVNn9/c=;
 b=v7cA2pwJjOhEAY9s5q4/efQj4EckEBonTR1XhIlrwcEoJ26rchARLzLUoeRHdZO1GY/M5j1Xxl8zH4HS2GnpGqcJVrKFoCPrql8QDsIBl0aY/8LAKFARsxuLeIJQbSh+jJAT+xG/2XZgvvCnuuKFSO/+OL+I7ioCAlSZQJbbyOc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA5PPFAB8DFE4E8.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8db) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.24; Fri, 7 Mar
 2025 21:39:58 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 21:39:58 +0000
Message-ID: <aab18e65-d311-436e-b291-efe3660a5b92@amd.com>
Date: Fri, 7 Mar 2025 15:39:54 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT
 fails
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
 <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
 <fefc1f1f-fc06-a69b-3820-0180a1e597ce@amd.com>
 <151f5519-c827-4c55-b0e0-9fb3101f35d4@amd.com>
 <8d1884d7-f0a4-07b0-c674-584f9c724f89@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <8d1884d7-f0a4-07b0-c674-584f9c724f89@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:806:28::21) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA5PPFAB8DFE4E8:EE_
X-MS-Office365-Filtering-Correlation-Id: d9051ab4-d03c-4a4f-8ce5-08dd5dc09b44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QzgwMWNmZVlKQ3BGNmN6LzN5ZlAvNjdiR25sMW5Ib2pGMGIvYzBXT2t3RjhE?=
 =?utf-8?B?a1FUbk9NQktINkw5bUhiVDVYSnovTzkzNVQzd3ozVXNZZ0hLWWdWV2Zydk00?=
 =?utf-8?B?M1pRUXJYVWlzTXpiZnIxbVdJUkVPOCs3ZVhGcFVXK3ZhcVZXQ01yZFpkSzk2?=
 =?utf-8?B?dUFsdTJueDJvSGgzR1hEODVOUC82Y1B3bjl0Y3kwWnV5K1Y0dlF4VUQxL1V1?=
 =?utf-8?B?aTU2dEhKeHBwbGE1NnM4RFR2UXZYMnVjSmsyZzFyM1drRERjUXF4NE9wVUNh?=
 =?utf-8?B?dHNaRzVWRkYzaHl5c2h5RHp2MFI3V3BXSGM5cThsY1ZOV0VTaVd2NEl0ZlQ5?=
 =?utf-8?B?a0FQaGNLSGZYUzE1dkJEZmo2dEZwcVRFVm9HR0VRMm5DMU9CRkdWem5PWm9S?=
 =?utf-8?B?bzFsSzJTQzdON25MTC8rQXY3cUtScXN6ZUtQbzhUSDk2ZTQzeVBaeE5Wb3Zs?=
 =?utf-8?B?VXZ6RlVXQzlCOWpscnNSbmI0V0c0RXlKZmt0OURqRTIxbXlnTmhRSzc5N1Ay?=
 =?utf-8?B?WExzTnFuZ0FOc3B4ditxR0dsSVZ3Qm1MVFJQa3dtVTFoeTNlbWEyaHFPclhv?=
 =?utf-8?B?VTdXQjlwbGhWU0duNzhsMDUvWlJUSU1WSWs2MVlxazNKTGs0RktaclhQTGdJ?=
 =?utf-8?B?czRNYXRzSE52WXhMd1hHQ1RYL1BVdEVnTUp5dmRQRVlsQlYzZXpGSEVFN2JG?=
 =?utf-8?B?b1g1OHM4MWhFWDZ5Z3VqdWVqTitobGNCSFdTbU1obnNNYW1NQjJaMkRDYVJz?=
 =?utf-8?B?cDJCMEw3Q3BGNE5CbTk4dTJIOWlEQWpVZlo1WkgxdkNlMGRpSkV4WlNiQWRJ?=
 =?utf-8?B?YzBMRnVWaDN0N0hVZm5aU1dQL0Jsb28vZGs4ZTEzRzNZN0IrWk5RcytIeU5S?=
 =?utf-8?B?aEZjMzVZSGF2WEVPZ0UydGhvcCtjWThFWHpXQ2FTeHRIM081NnNHellqVld3?=
 =?utf-8?B?TTBqN2JISHZjaE91LzNDWjFmdGQ4Y1NlSkY3RnVxVjlkRmkzbHRBVEh2dzFn?=
 =?utf-8?B?UURwSnYzMloxVEVxSGJYUWhicTh4YWdyN0VDcW1ON0pRWElHYmhPU2FJam5r?=
 =?utf-8?B?Qkl1ZnpRTXo0cHVZM3V5S3BhbE5qZTcxM2YxN0pySU1QTjRzMWZITXR6MkY3?=
 =?utf-8?B?SktVOUlaZWFjM3I3cWp3RzFDaWdjSW5SNUxEVGliZHhYZ2hpdTlBNzFYeHps?=
 =?utf-8?B?anptVHhtaXhpNUlZK0Y3dlhrT0hYWU9hYWJ3M3UwM25sVTRLakw0dDdFR1ZS?=
 =?utf-8?B?RWJSMmwvbEs0NDcxbE1xTFNHelpXYkxCVDBYcUVPdlpnb3FseFVPdVVaL3pI?=
 =?utf-8?B?MFV4amhJU2RRZTNvMjFNOEcxYTA5MWllWlh5LzgyQ2hMYk5nb3lURkZhaGZ5?=
 =?utf-8?B?cmhVWkZnTngwN3VLdk53c1UvNjRCZWlLZXQvM3ZjUUNUbWxWRkU4dW1HODhH?=
 =?utf-8?B?RjJxTXpkT0NSNW9rUjFIMWNBelFTWU1UeWZmaVlvSmtVZFZ6QVpjYmYrdFc4?=
 =?utf-8?B?MzdLeGx5Lzcxa0dXN1h0K1RMVVlPS0ZqMHVHaHdvTEgvamxjN1plS0NPd2JQ?=
 =?utf-8?B?cnhMaEUwTklWNGhwajZMS0F3WUJIT0xrN2QxWUVIeHdMUFRMV285S0ZPNGdR?=
 =?utf-8?B?QTh0MDJoVlpKNzFETkE1bHNCOFlIWXdPb2tHa1FaOTlyRmcvR1UxcEJDa3Yx?=
 =?utf-8?B?U0VVUDROUVcvSk1BZitRUDRMSnhUeUFrajBaVVcwMFd6NWxxc2M2NUROUUpn?=
 =?utf-8?B?TTJONEJwcWRLUE9vd1pjemh4RFZHMlRSUk95UVJYZGkza1o1N3h4SVI2UVVD?=
 =?utf-8?B?QnpkdlZoYU14SlhQSDRRQ2haSVpZMmZVa2pJWlRKU0JEU1VQN25yd1AyczQ3?=
 =?utf-8?B?UzZQY1Jzc2gvd1gyaU80Ry9lOVVWSHcvdU9ZbGRSbWhrMENVUDVrZWNLbWpQ?=
 =?utf-8?Q?F0FZCw3k0BA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b09mQ2tCc2JyOVF4aEJMSjEyQkJIb082bHNveHlJMlhsU3VXUHNNZXI1dm9I?=
 =?utf-8?B?RVFPYmZJeEVYbHpVZ1FkY1padHpJN2xnK2dDZWs4aWluaU04bmd3VXk0N3Ft?=
 =?utf-8?B?OTdZTEpBSkVrTHhHNW5DVTlySDJUd2lvZUtwOXl6OGNXTk5KaVZCOXFlbjBM?=
 =?utf-8?B?amxLMTZtWnE2UXdZQ2YzZG1QRTU5WmNOaEpnSWR1cEc2WkdKRU1TemFsaUpB?=
 =?utf-8?B?cmhNT25yRjJsU1dYUWZMZ1A1VkV2ZjNGWnRNQmFIczB2VFdXenhtMmJEbk9I?=
 =?utf-8?B?R2xseW8wS2R4SWcxem1qczdFbStuSUorMGZkdFdUOTBuWERObGM4WEFsRW95?=
 =?utf-8?B?WGNwajNwNDFlSXZiR3k1Ump5dXhKcjJXb3RwWFlnMzRuWk9sK1Q0NWFqNmJl?=
 =?utf-8?B?YVc0dElXN1VVQk0ra1drSklaUTFsQXpKNityVHJQT3VtL0tsTXNsTUZtR1Bh?=
 =?utf-8?B?b0FpajhPdXR1NEthdnZxZU80aEM0QzE1M1dHekhRMDZXM2tKTHhMYXJBSWpD?=
 =?utf-8?B?Y3JubzVOSUdhSXdFL2lOS0VaT2NzaUlOcXZUZ3E4TUJBNFBxWURWOFcyeElH?=
 =?utf-8?B?ZkNHRCtabnFIZTM2aUdmTS9DWDl2WGNocVFPeDhzU0s3dUVuMmRza21rcWRt?=
 =?utf-8?B?MC9IRFppY2RyU21Pd3NVS1d1K1ZrM0Y2eXBIeEJXbEpnV3lKZlpJN25DWmlG?=
 =?utf-8?B?YmlqS0VlVzVOZXRGK0ZabklIdnlEaGJwaFQ1NC9rcXNORHhWSUpoK0djVENV?=
 =?utf-8?B?Y1JUc0Z3STEydmt4OXloMW1ydkNDWVFzU2VLTFFYL3FZVmFBR1g1dTZtZnNn?=
 =?utf-8?B?cTVUTjZZNHJrTWtmdXQ2YTFMaEQ5VHRKQmxmS3hWdHFzSndBVGE4Z3NvbDhG?=
 =?utf-8?B?cmk0YWNJT254bzd4UkRlc2pvMzVLUFFtd0Q2Qkc1VTdGMkdhMWFYQWU5VzE0?=
 =?utf-8?B?WS8xaG04N1FRR1g2eXphTjVyQnZqelNOUmJSa3haa3VVeGJqRFdqVWRjSTV3?=
 =?utf-8?B?dFo3Q1Y2NWlGR1N6d1RHcXdNYm5nQ0tjNzBjM3NVZld2TmNmVzhwK2NFTWZZ?=
 =?utf-8?B?ekI5WU5qZlNYencrTWQ1Uy8rSDIrNHVDejJRbFgvS29MTVNvck9NbytvN1pB?=
 =?utf-8?B?MTRwUWxYcWN0VEFhd3FGYWZEUlJQZ1ZHRm5wYU5pT3hKV0ZUTUJqVCt1ZklM?=
 =?utf-8?B?L3ZNSC94bnBJOEFpL1hjVFNBRVlmZTdTay9qUzRpaWlYeHg2R1M5cHpuWVY1?=
 =?utf-8?B?OVlJOHhUbllVZmlmRHc4QXVnd3ZkMUJUbTVJdEEwOTNjcGNmT3J0clVrZkRU?=
 =?utf-8?B?MWlsbjdvbmpDK2FVTDBSWmQ2V3JFUTF6L2pVbFNwZWVUVnJJc2sxaGtGUjUz?=
 =?utf-8?B?L2N4c3NHdUdVU0QzSmdiOURUM1BIRjBsSnlGR1VvMVFvMlM1YUJGc1BBTkZ6?=
 =?utf-8?B?dlA4bXk4WXgzaCtSc3BwcityTXRrOTVrOFhKUEpQckNRZTVKUm1NOHgzYXRs?=
 =?utf-8?B?NVAzdjFrWW8rckxFbTJoeG9iY05xamN0aFREZmw4bTMzZnh1c2tQNThSRFpw?=
 =?utf-8?B?QVI0SEJLQzAxRklDMDYzWGdDWjZlWFkvKzFWNDByQ1RBMDVnYUhQSk5wZGpp?=
 =?utf-8?B?c0k2bDJEL28waWlISHQ3emhBb3F6cnQ4R1FSemxTSVJqMUlwdUYwWlZxeVV4?=
 =?utf-8?B?MTBTenRtWldXcGtRazczNXN0OXBSVVBHcFZ6VEsrTlZEN2pGSTBqWUR5dHYz?=
 =?utf-8?B?SVJTWXZXbmRYRGx0ODdGekF2bC9KNEtlTHcwSkNVWVpyNmYvWFNlTEd5d1BT?=
 =?utf-8?B?a0p0KytEVVRNeE1vbGJoR3hsK05mNzJLRENGTk9qRFgxZEtZdHBQa0trTjNv?=
 =?utf-8?B?emdPLzNTT1dXclhzZnQrNkcxTWRDc2ZMVnlIQTlTNzhLK2RMbGdZN2hjZjB1?=
 =?utf-8?B?c0JSMURVbXpsREZNM3pLajFlVThTeUlSMncvQjNRYk51dDZNMnlNTWh3ckdV?=
 =?utf-8?B?cmtibHI3dDgrdFdrdHhqTk0yM1BHdmQ3Y3ArT2o0NVhmRDV2RW11a3BLcU5h?=
 =?utf-8?B?bkcvV3o4NnlEYUQ0eDNjZE16azNGRmI4aU9Qbzk1YWpWamdKcHZDb2pRRmdT?=
 =?utf-8?Q?XC4rEpiG8p4zcHrtENiodM4aY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9051ab4-d03c-4a4f-8ce5-08dd5dc09b44
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:39:57.8494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afmkJi/x++gxd7ocLZLT5JrdVTLNXuotAj9hJGiickunAzRSmaU8bY28nplqW1Reg7mEBUpg65YY2/5DTnOlmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFAB8DFE4E8


On 3/7/2025 3:29 PM, Tom Lendacky wrote:
> On 3/7/25 15:06, Kalra, Ashish wrote:
>> On 3/7/2025 2:57 PM, Tom Lendacky wrote:
>>> On 3/7/25 14:54, Tom Lendacky wrote:
>>>> On 3/6/25 17:09, Ashish Kalra wrote:
>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>
>>>>> If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be
>>>>
>>>> s/RMP/the RMP/
>>>>
>>>>> initialized up before calling SEV INIT.
>>>>
>>>> s/up//
>>>>
>>>>>
>>>>> In other words, if SNP_INIT(_EX) is not issued or fails then
>>>>> SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.
>>>>
>>>> s/once/if/
>>>>
>>>>>
>>>>> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>> ---
>>>>>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>>>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>>> index 2e87ca0e292a..a0e3de94704e 100644
>>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>>> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>>>>>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>>>>>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>>>>>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>>>>> -		return 0;
>>>>> +		return -EOPNOTSUPP;
>>>>>  	}
>>>>>  
>>>>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>>>>> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>>>  	 */
>>>>>  	rc = __sev_snp_init_locked(&args->error);
>>>>>  	if (rc && rc != -ENODEV) {
>>>>
>>>> Can we get ride of this extra -ENODEV check? It can only be returned
>>>> because of the same check that is made earlier in this function so it
>>>> doesn't really serve any purpose from what I can tell.
>>>>
>>>> Just make this "if (rc) {"
>>>
>>> My bad... -ENODEV is returned if cc_platform_has(CC_ATTR_HOST_SEV_SNP) is
>>> false, never mind.
>>
>> Yes, that's what i was going to reply with ... we want to continue with
>> SEV INIT if SNP host support is not enabled.
> 
> Although we could get rid of that awkward if statement by doing...
> 
> 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> 		rc = __sev_snp_init_locked(&args->error);
> 		if (rc) {
> 			dev_err(sev->dev, ...
> 			return rc;
> 		}
> 	}
> 
> And deleting the cc_platform_has() check from __sev_snp_init_locked().

We probably have to keep the cc_platform_has() check in
__sev_snp_init_locked() for the implicit SNP INIT being issued
for various SNP specific ioctl's (via snp_move_to_init_state()).

Thanks,
Ashish

>>>>
>>>>> -		/*
>>>>> -		 * Don't abort the probe if SNP INIT failed,
>>>>> -		 * continue to initialize the legacy SEV firmware.
>>>>> -		 */
>>>>>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>>>>  			rc, args->error);
>>>>> +		return rc;
>>>>>  	}
>>>>>  
>>>>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
>>


