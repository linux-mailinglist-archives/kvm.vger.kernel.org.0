Return-Path: <kvm+bounces-38785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B43BA3E567
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0394701224
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D512F2641DB;
	Thu, 20 Feb 2025 19:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pk8WAd71"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366C213E80;
	Thu, 20 Feb 2025 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740081469; cv=fail; b=nVQJ9IVdFGJMAV0lHl7p291zt2eOMEyhaXRrW7CfbErBDqHFWUW4GC5VMhIxpYfK34ZzD935jMhGgBUqo3YbIsGjfakAF6u9diBRxxRok3u5hTKVwYfbHTxdgUi0IS5/oyrSpxuR13IQ/k1GUq7/GBgUJsqeqNywEAKjcC+eW20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740081469; c=relaxed/simple;
	bh=ThEfkrOalpp/PK20/rlPPoybKRXWYbVEWlTk6pVpEqA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=BrARl5h5IIepvcI3AZI3MlS7z30YYuy2ptu0D3+++CFKQ6hcJHASckWfrcmvPcWRBG0GDLLblJSyvfeoHxn5YP54A7FnzArcVOiffO8dCMRMGa1IGhV3G1JE8F6bqgcvLSQUXXjbG5QvTi2jR/dMpojl77h4GD/IqavEyjk8m9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pk8WAd71; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcjNBBtHRsEhAYwP/icmXzWdXlDOEh7XzuiZgsebrOmwV5V9CCp9K/wpwUEq/18Y7icaLzh5NlASs+XrHDWhATFCapW4Fh2M/TBYlu0bKaG6cn0tyJgoXpnRs4FQaliDdoKmhlK0uquF3cX8F0IWqJMdhh1zUPx4KNnuJlwftTwuwkwAoG37yeJVHWQ8dPVKR/w0yMa6AN6OtFbi/nknfOwuf2TWh/bs1hfQqcOEBZnmEm+wiOgsqZA8VUfXwm8wZerI2o0mFHFJVenjhX6NFbPIdZbIt13//xFCOWKLGxKNsgNb5LrtaxZSPiLH4I9xdo16KejV9nnDpG0y/5fIlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ud9e6ngC8JzZKUKVaz9pb6sFfgaJ5wZEE5tZpPp6ofs=;
 b=RL436qFVRxTlX+9tppSfn5PNSyQQtVvDbLJTQJjOhI7TeORX+QB2+vdNPt5yQlW0j8sNNwbO8gfxGCgQ4ffzEMeJQeNO9VzILPOuRJl7YRKrFpXz/D5D5/XdtaUxjU3DeO2Yrk5iH6A59CNiXJ+K6uvbXmdF4l1dpKqiJGRw8ddOfOriJcIqG4OBp7eR5bFFx/FRWUlj0ERe3UpY6ly8Azw4bW+/xfP1QM6c2/fEQY0a+it5cRZ7kyQSXpHAEv6q2WO7tkCk/855D0WVX+GL+dQizIPLp9zAiQvnb5fKJU/T70lsivoNyGa3UjcT4OItCF5QoR0yyHPpW0OdvKamlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ud9e6ngC8JzZKUKVaz9pb6sFfgaJ5wZEE5tZpPp6ofs=;
 b=pk8WAd71NorrpvBpz2AP1LAx7alNhnm2Ma3tKt/GgPHkDOElnrSfF0wYryA3rF+YIFLU1oyl/957k23XU5dIcY0qN4EPKBXnNQ67FPbFGqWG3c5VJJaAo6zh+jFrct1QIccQ8e8X95Sa11Y7BGK/F+LVeLaofzpuCTYTlzjfsXY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6980.namprd12.prod.outlook.com (2603:10b6:510:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Thu, 20 Feb
 2025 19:57:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 19:57:39 +0000
Message-ID: <22ac00dd-cd36-82af-0a72-86dc34c08e5a@amd.com>
Date: Thu, 20 Feb 2025 13:57:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <5346a666758c21ec25d26ae184a2d1a9324f3b55.1739997129.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
In-Reply-To: <5346a666758c21ec25d26ae184a2d1a9324f3b55.1739997129.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0104.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: ab8a5b4c-dba3-4af6-1cb7-08dd51e8d40c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHhjeENMMHRselZYZFhzem1xZ0MxMzBXY25LMGFjSXN6dDNhN1BNdUVqMS9D?=
 =?utf-8?B?LzN4cmQ0QXNhOXRySE5UL3VIT0NKMXY0TUVYalN0UXFCZ016OWxNd2JOaENS?=
 =?utf-8?B?QU9EOW5kdnhZcEdLZkV5WG1hTWRTSTdDSGh4Mml2ckZPVDloYkZSN0s4WEpv?=
 =?utf-8?B?c1RweFdJa0wzY2dLSU5PM21FYVBIeFhvWm44VUpUSXJ6TUZtTXdTT0VSaVo1?=
 =?utf-8?B?bGRQcGhUaWU5VFo4c0RtbTd3L0FwVHdSS1BnNjRYR052WmttaWxDQkIwUnM5?=
 =?utf-8?B?SlhiVC9ibGM2MlZ4RUZUaTNCelJFSXdQcUtDOC9La1RGdlhIZHNCOEVtVDdp?=
 =?utf-8?B?ai9aSUVXMC8yR2VEMXBxMGNsVmpKR1IrZXdyZ1M4aGFFUmZTSmo3WHo2eEgx?=
 =?utf-8?B?bHc4ZFFISEV1THFYa0UzTTlSY05MczRCMGtQZEVDRVhMRGlOczBsNUNmV09n?=
 =?utf-8?B?YkJ5TU1VN1M4aUNjc25EdmVkQXI4UjNjRDBEcC8rMHNZT29COEsrWHRRTU1l?=
 =?utf-8?B?bGpGSHNRQ0kvOHloSlJ3dzBvYU9PeDAvRUtBdGt2M2NsRWFDZWhLYmtRR3NU?=
 =?utf-8?B?Zi9DcmV4eWo1ZWgwVlFlSVp2YjNxL3NGNVBmSzhLSGgzVzJKUnhORG9aZU1q?=
 =?utf-8?B?L0E1N0dVeno3bUo1azlUV0IzTU1QNW9pTFZ3djlRU3VlOGRwM2ZWTkRGVWpO?=
 =?utf-8?B?bW16T0FESWdiVGcwQ1libTBCNHh4VzFUZjJ6Q21EWStzUllScWt3bDZ0cnZw?=
 =?utf-8?B?SXlHRTZnVlNTQ1VPYTZUOGlDTCtLdE4rb1N3ZHg3WU01V0dTcHMrWW9zc1dC?=
 =?utf-8?B?Q0RyWk1tY2pST0tpK3dXaktIOEpOaVlnNkR5V2g2YUswNEV0VGUxUEdPYXlE?=
 =?utf-8?B?c2cvODhhWjlZdVQzcmExWjZneEY5MHBmS29KY0NBak8ySmVFbjdyOXRxZHk0?=
 =?utf-8?B?MS9FWHd3SVJZTjRjTng3UVhwNFo4bDFGWGJwdTEvZ0JqTGRPUlV5bVZiOEdm?=
 =?utf-8?B?Mjk1VHhLNWFYUHMraVZwMjJyWDVmaXBtT1FLNDFHYWd1V3JjS0VJeEIrS3ZM?=
 =?utf-8?B?bHZiV0lnQmRQZW95MzR5OFFHRFg3RjlCQzFmNTNtSGF6R256Q1hWeXViTFBt?=
 =?utf-8?B?VTZHVEE0SUJQMlkvUnY3bXdxbTJ1Sys4S3M5MUJrL1lRUnhJSjlNc0NRY2JI?=
 =?utf-8?B?Y3BURGk2am82NmViVjB0NnE0bC8wTU5UbEkxOW9oNWlYMnN1UEhrMkx1YkF4?=
 =?utf-8?B?ZnY4TEp4MlhiUmZWY2xFazlrN2orU1QxNmhyOXJrYlYrTVJXYjFNblkwTStE?=
 =?utf-8?B?eGJkVTVzcHhIYThaMzdwbFVTd3RwYUNVSnVUWngzWnZuNnlMbHQ4NFdQaWI2?=
 =?utf-8?B?OW82T0E4VGVVZnovQ2JGdkUvSWtBbFlMNURvNG5WM2xITUhUNEpobHNpZEp3?=
 =?utf-8?B?L25sRUxMR2l6MDNKQ0pmbStrY0NZMjF2UURkVGppdjczZ09JVzc5QXEwaWZN?=
 =?utf-8?B?Uyt5ZmpVS1IxLzdsSkZYUkpWanV4NnNNVFZzbWZ4YWhJQ08rNUhjaGJTbmQ0?=
 =?utf-8?B?SXJEUlVOUDFoNEs1TmxEYU9RbVdUSlRiVDg1RGZQTmhtME5JbzBTVWVLaU1M?=
 =?utf-8?B?VWhUQ2RYYkt5aFcvb0h5S0JLOEYzSFZyc0VsVEFrNmN4MVNzR0ZmVjFvWDhN?=
 =?utf-8?B?aUpkQVU2UmtyNlJieUNURmR2bTh5b2s5N2NHUlNlcmhTYUVPZHVwYTFkVnkz?=
 =?utf-8?B?RGJSbUZ5UUxDcVEyZitJN2c0dzJEVGJSQUtQbjl6Sm1LMGt6V1VuNzRSdEpH?=
 =?utf-8?B?YlR1TnV6MGVFVHVWSS9FR3BvYWZzZlF3K2dtNlhDSHpxaWlmT2phUkhOY2Nx?=
 =?utf-8?B?QzJZZXFoY1dLZWxYMWZQcExoTjVxRU82NldselZwMnpmWXAxQnB3ZlhWN0ZC?=
 =?utf-8?Q?kdyCNsSHSy8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEowNUo2K29Ob2ZYVUdvTlN4ZHpwdFl3L29pcDNZTlQ4ZWkzcTZIcDd6MS9P?=
 =?utf-8?B?akZSWlE1b21vam1ScU9TcmtPazhzYVlYcmZTU3lCSUlGa2xUY0Fuakc0ZWNv?=
 =?utf-8?B?ay9OekwxaTFEZVoxUW1zVnhaM0I1TUFpMGtlK3lydWl5L0NvaHRFR3BmdFpU?=
 =?utf-8?B?NVFUbHZmTnNxdkxRclg3YW8yZzh4Yi9tV1RHeGhkM2J0UklXZU9QRnRVemZM?=
 =?utf-8?B?YjVUODQ4OGc5ZzBvQ1hNOVZITS9JWFA4L1ZzT0VPdTVLT0ZNZXhHUmh6K2dW?=
 =?utf-8?B?SXNOaFdpbExpdUp1T1hLT1V4MFpnUmM3RW0yMHhrT2h0UFF1NFR5ZDMxUXBk?=
 =?utf-8?B?amJZMVB4L2dwUW1xQkIwSWxhMitSMHk5eThVRHpTU2J4MW9kaDJMcDNFMWRG?=
 =?utf-8?B?U3JJM0JsYUNDY2RxeDVlaUJVV3N2cTI0OWswSGVWZlUzeEEzSzJhV2VUdnho?=
 =?utf-8?B?MHVNQ0d3WmVTUXVQYlJSY05MYTVvV0tVVXhHZzFZNXRwamhqdHRpaTF6L3I5?=
 =?utf-8?B?MUs2NEY5R2VaNUdwaC9tV3cwRUMwMks1dHRIZit3bkFRS20rMjdlTUR5Y1JR?=
 =?utf-8?B?MjFIUVdhN3V2bFhoUW9pWS9EQ2kyRFZJNEhKVmV5ZkxrRFpuYWlaM3QzRWpz?=
 =?utf-8?B?T2tNbzE0bUZPMkVHOFFnREM4STVyZGJ2TkJpbmtvVk9YZXRUSjJCVjl2SlZx?=
 =?utf-8?B?MFJ5T1FvOThKZTUwQnRXTmJ4RllodHMxNTVVVWcvaVJNYTEvcXBSZHFsZEJr?=
 =?utf-8?B?NXNoaSsxcWRhMUd6bTdJZFpmdHVlWnZDaGNjemhOYlJOSUdZVGhtd2ZxaEk2?=
 =?utf-8?B?dUpXOXhTazZ0YTNTdDFkZTBoS0cyYWhYYm55VDFjN1VtdW0rQkduTFVaN2dO?=
 =?utf-8?B?Z0luTVZXczF5ME1aTnJqb01kczBQSHdqWTlMWmo4c2ZoTUNWdjkrMWMxUXpI?=
 =?utf-8?B?VVlseE1ESndhUzQweXk4S2hKV3hDSG93R3pyckIxUkdCQUJKcXhlVDhtV2d4?=
 =?utf-8?B?SWxOSVByWVluYlFUdmlJM3grNFRSeEE0UWdmRXVZZUVDeXhRdUVSTGc5ckkv?=
 =?utf-8?B?YmdNNzY1d1JRREhTZkNqSlRTSXdHbUVLdjdwaGl2NFdJdFF3SkNmYzRybHdD?=
 =?utf-8?B?UnRMNFlwWXoydnVIaTVzQyt6NUhnRnZvd0x0U1FqbnpYanIwbmJwZjVGZk4v?=
 =?utf-8?B?ZlNCT2djN2cwN0VLZEd2YnVURjFjYUJibzZGU0hWSTV1TFhPdmVEdWNQT0p6?=
 =?utf-8?B?MDJhekU0dEY5Wi81LytrVEo5bHhWbXVrV1hydHU1MU1YQytHbExJblFqcmVL?=
 =?utf-8?B?MEtXQ2xDVHFvS1BKZjBpTFNrZ04yaXF0aTNmUFh4NHpyWWh6ZkV5cFQ5Rnpm?=
 =?utf-8?B?N0M3NlZDZmdubUM1YjVOZG9GdVJVV0JBNlh5ZDc2djdhK3VETDMyVVVCSytx?=
 =?utf-8?B?ZlBuTnJSRldFeWZueEtQY2ZKYjc5akFsZm5WQXkwZDBHUzVVdG53Sk9xNzFh?=
 =?utf-8?B?UTRwSFA3VGxHVHlUbzdzODRjdE43ZXBpaWZSNnRMVlovcHREQ0p0WkNYN2Qr?=
 =?utf-8?B?UlFFdmMzMlplem8vOFFnMHc5V0J0aEpoT3pPM2V4TjVVeDFGYkwzKzc2SjFi?=
 =?utf-8?B?T0IvRnV4Y3gyaExOaDNvNURhbmh5aHZzRnBmM0IwWUhEK2lPSjExY3hNbUFy?=
 =?utf-8?B?Tm1ZcnRoekdkTG40ZHhmbVBPNWpzRm1RYkJqRUFKSjV5VDdjeE1SQUtKZHc2?=
 =?utf-8?B?MXZnYjVBNUErZ2xyWGcwbTJHeC9CakZYelZ2ZmN5R085c0lyVGdFbTJZZzAw?=
 =?utf-8?B?SldDU2dBRjd2dlN5aHVkRzJaakpJYVo1TGdRZHBEREtZWGF3MFIrOVpUOW4r?=
 =?utf-8?B?MTRMT2JHRnNsWWsxYUZ2SjVFTi9MVGtXaGEvcGliQmFaYi9HOWdqL0FycDdV?=
 =?utf-8?B?VjRGU0ZnMzg3ekRjNDNaUDc0TXBaNllIRTdSSS9EN0hLZzgwb3oyNXl1YWwv?=
 =?utf-8?B?V01FeUhUU3hnako2YU83SlYwM0V1NzdsTnNZcVdGTVpFZlE2bVR4bTU5NkdY?=
 =?utf-8?B?VHFibXRuaUsvQWd0TTNEdlJsd2hiU0dnTU9BRENXZEVERy9Eb0llT3JBd3Zl?=
 =?utf-8?Q?t2vSRcy1MppZxQw9nWSVSRxS/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab8a5b4c-dba3-4af6-1cb7-08dd51e8d40c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 19:57:38.9718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r63i8EQAK+JBKJFBpCIg54U9Dsvn6PBclqtDutX+c6vWSjhv3sCiwD1e3Wl7JPzVp2K8jg8jZb3xaFlu90TBsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6980

On 2/19/25 14:54, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Move platform initialization of SEV/SNP from PSP driver probe time to

s/PSP/CCP/

> KVM module load time so that KVM can do SEV/SNP platform initialization
> explicitly if it actually wants to use SEV/SNP functionality.
> 
> Add support for KVM to explicitly call into the PSP driver at load time

s/PSP/CCP/

> to initialize SEV/SNP by default but this behavior can be altered with KVM

s/by default but this/. If required, this/

> module parameters to not do SEV/SNP platform initialization at module load
> time if required. Additionally SEV/SNP platform shutdown is invoked during

s/if required//
s/Additionally/Additionally, a corresponding/

> KVM module unload time.

Some commit message comments and a minor comment below, otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 74525651770a..213d4c15a9da 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2933,6 +2933,7 @@ void __init sev_set_cpu_caps(void)
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> +	struct sev_platform_init_args init_args = {0};
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3059,6 +3060,17 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (!sev_enabled)
> +		return;
> +
> +	/*
> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
> +	 * VMs in case SNP is enabled system-wide.
> +	 */

But won't this also do an SEV init as long as init_on_probe is true? And
isn't this true for even non-SEV VMs? You have to pause all VMs before
performing SNP INIT. In which case I don't see the point of this
comment. I think you really just want to say:

	/*
	 * Always perform SEV initialization at setup time to avoid
	 * complications with performing SEV initialization later
	 * (such as suspending active guests, etc.).
	 */

Not that that is much better... but it's more accurate.

Thanks,
Tom

> +	init_args.probe = true;
> +	sev_platform_init(&init_args);
>  }
>  
>  void sev_hardware_unsetup(void)
> @@ -3074,6 +3086,9 @@ void sev_hardware_unsetup(void)
>  
>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> +
> +	/* Do SEV and SNP Shutdown */
> +	sev_platform_shutdown();
>  }
>  
>  int sev_cpu_init(struct svm_cpu_data *sd)

