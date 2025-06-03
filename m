Return-Path: <kvm+bounces-48300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87304ACC816
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 448EC16B656
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 13:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC3523505F;
	Tue,  3 Jun 2025 13:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VMViAS5u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9212040B6
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748958048; cv=fail; b=lFiBmmdqL8bumsSZfGNvYoqIaWJYLQdlZuMy1wfLGSaZHWu9uC+Db1N/IWaHxzxXOYTS2YFfgTzVRrVl+ig7Zc1VUgBuVrzljhYOUKzL8xVjgCS6+X/RN56M2HlDlo98gbkbHakc5Fu53W6B8/mRczMIUwzRd/X7SxHro5wMFhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748958048; c=relaxed/simple;
	bh=s2dSsIsDrwTDdPMmXzkS1L8IEjuVor6PDfZPDGgICsY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qg45TWdgqN1Qp5j1NGnqEdMgpTiPjuEZUSSsxdsToAGL+r79GWFqT5MatT07uzmLc9rml1hGolwzS/E4Yrv3e9tt4xM0b24juDWwJvgenn2oO9GKpBx1EQrdJRR9QpdBh6yoYKr/J8x0tUrdFxYkqdNjxUrC2XPbzJ79gVrNq+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VMViAS5u; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YgKMuehijd6F0eWGhIJM45c2At8GWlL+McnYcFIC3+H9Sm3toXFbLXrK8+5K/USbGpN3AzCYG03cAg98uwr+ZyLQYha8w5Ma1DVPaVvbldYNUFgAMwm827789+vzqwOKaNjNoa8aJROyTSBkAIZg4s7jXo6VzyPsvhomusXvaFI/xDMdildK3rryEzFze2jEj290ffhcmiNeiJ5oyKNw0+V836IaWlwu+i23EoRjGn7oopKIA08cATw4CWYjVMqwzBDdFKim0HUD/gr2BzvDPuXfcPyKs5gl2hdCDZff1JHg164754yR/XSlXIoAxzOl5qHEMC0WcKFB9VyXW2orQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIL1i7qe5jhCN3k9gUU15wlAu9xvK+Hv2GSerQ3nb0c=;
 b=vOD0P2LkBp7UHoFOsgO9p6KZosnVBESVrFv/klW8p9Esrdh6gP+aPhnwHjBmF2IdBWnORckiwBTVOLPqjyCi6r4MZuF83swRE0S07Q8/+kFZXFUqGFaO/o6gA0R7Sy8vaMjosx7tk9vyHiWMgDa0jG6ag9G6nMK/98ZQd/2HpdOaZ/3PpbAZBWc/7tJLtN2UIc6w6aQQz3xP+QHA3QECJVZ7/5r5O0NSWIKmlRtVnytKas+TDAPMnhKlp0WelSOGlBqXiXLBhZ8dEibDRnIonzDdTEOnof1NxEz19Uc+/dblcyWtqyPG/Xa8EiUC0pT2SCZeL5KEJK4JOQrYXpFxPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIL1i7qe5jhCN3k9gUU15wlAu9xvK+Hv2GSerQ3nb0c=;
 b=VMViAS5u+ZzPsa/3ve4B4j71W/xwhdAq/B9CeC8WL1pIhkAKog3Dulmu+WGikTWwn2gGGX4iyjc6fqssaZUM+eFJOVzIYYQiGEP8QhkMboSNj3g2xkPGylefilLYjMxvjsnH660faDs/oKwujzihADV+NPmIJ/R4lVG42GWmnlA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7928.namprd12.prod.outlook.com (2603:10b6:8:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Tue, 3 Jun
 2025 13:40:41 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 13:40:41 +0000
Message-ID: <18492ff6-7c4d-2384-71f4-e140834164d5@amd.com>
Date: Tue, 3 Jun 2025 08:40:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] i386/kvm: Prefault memory on page state change
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Michael Roth <michael.roth@amd.com>
References: <f5411c42340bd2f5c14972551edb4e959995e42b.1743193824.git.thomas.lendacky@amd.com>
 <4a757796-11c2-47f1-ae0d-335626e818fd@intel.com>
 <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <cc2dc418-8e33-4c01-9b8a-beca0a376400@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:806:120::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7928:EE_
X-MS-Office365-Filtering-Correlation-Id: c868ac7a-32a5-4364-9053-08dda2a43b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUdHeTQ0bnRVNzZwZ2tzREljWGdjclIza3YzdHh6MVhteHBzSTRoNXNLQW9N?=
 =?utf-8?B?amgrZ3gxdWlPemkwQjZmTXVBU1hENElpeWFpZHpCN0FEYVZyNXFUY3FldnJW?=
 =?utf-8?B?Vld5NVpzOSsvYnJ5cHRZekdUN0owc0xaSGd3cVJmVzJBZGQxY0l0VUNoYXRD?=
 =?utf-8?B?YjRWd0tSREc1TnVYQUE4RXNDTU9kMFJCR1VBMTM4c0lRYUZqOTU2dXBWS2lI?=
 =?utf-8?B?emlzQ2g5QXR3WGtRdHhRYTZiNGtqWnc0eWowRWkvSG1XbUZ3UVdoYkJEU2ZP?=
 =?utf-8?B?c3pHQmhMWjNDVXR4UFc2MXpvb3RBbmlLS2h2T0I4WTkyc3dtMlhUU2ZXZU1r?=
 =?utf-8?B?MSt2RGJkSWNVc1lqdGp0aGZaT1hIaHNqRlcvMis5UG5oMmptTUxOeVdYdUdm?=
 =?utf-8?B?N2g0U2txdnRhYzBVR2h5MFpoc0Y1d3RhWWtJT1BqMXBWencvNENLNEhidnZo?=
 =?utf-8?B?UjFnaU9LT3dHSVh5S2p2cG5WTjFoZFFqUFBkTDQ3ZmppVnk2Uis5YVdOV2pz?=
 =?utf-8?B?eVpNc1hzRW5QOEFHVHN1RE5LNGlPcmxZQkt0NlZZUHlXRGhmbEJzSm5RTm0v?=
 =?utf-8?B?Rkp5Q3haVU9FSWY1YUVyQllrN0RqL2g2bVU1cE5zVVNVazI3a3BlQituVjVU?=
 =?utf-8?B?QkxjRzJIVld5ZVN4ak93VC84a2VXVU9SajFYN1E0RDRWR052ak1hTjdpQ0Fw?=
 =?utf-8?B?QU13QmJXM0xicjhxNzFmdjhGek5UeWlFc1QwUG5rZVNJYmxzZU5lRG5ZSjVU?=
 =?utf-8?B?N1JRcE1GTzNiZkJBSlc0L2tEOVdiMWVkVEtYYmIyZnV4L2FtMzJZOCtTcDJM?=
 =?utf-8?B?Zzh1cEVlbHhZeDBSL0NUbHlEd1E1VFd2eG5iM0diMm1tWkYxMVQxTFgzUklZ?=
 =?utf-8?B?VmMwaGpMWjRaZW1NNU9ENHRONWRVRGRZR1k3cjZobWFPU2NjNnk0cXliY051?=
 =?utf-8?B?WDF1YXZRZk5aaEc1U3ZwWXFzajNadzR2ZWo1VldpOFNLUTA4ZXBBa3JwN3Bt?=
 =?utf-8?B?K21FVTBDWTVtVUFyRnltL053V0gzZU5oTGRMMm1xZG9POUN6VCtIdmtadCtS?=
 =?utf-8?B?ekgxbXdnaHNwNmlDZGYvNUpab3B2NyszM01GOERBVXpFdVpjK3NOc1dxMEFZ?=
 =?utf-8?B?eHJZaUtHRG0wRElkeXJON21WdkNISiszdXVKSUpNUk1RdjdxdDNtM1BJY014?=
 =?utf-8?B?Zk45YVZBSE96SzZneEJuZFY4WWNDUTkxWnEzeWRmZ0VrZHVYRUtRbm12ZDk3?=
 =?utf-8?B?dUc2UmtIMjYrdTJCelN0NDVYR2VkMlpoYW5TUEhJUXNyNkZidTQ3ZHgyT0lu?=
 =?utf-8?B?dmp0RHhTek1Nd2Q1NmMxcjRRdDVEc3o3L0N2aUNDUGtmd0llWU1FUHNPYWcz?=
 =?utf-8?B?WFVTbmVjNFBGcDBKYk9SOTFwcWRiYkFjT3lyK1I3eDN4K1h1QzBPc0FDaFY2?=
 =?utf-8?B?K3lHcjYyeVpqZHc2K05PSFF5WDU1ZWdnM2ZKb01XcGRXeEEvRGIzQjFkeG0y?=
 =?utf-8?B?d0p4Nlh4RUx0U0tqM0ZuM2ZpSG91Y3laR1labTFMZHE1R1VhZUlVcW9mMnEx?=
 =?utf-8?B?OGVVQ2dSZDFweVhrMzRLZEhaNDZZOCtGVXRJcmhBWHRNRTBJWFlHcUsvdWti?=
 =?utf-8?B?OXJMRnpOMVVKSFZLcXZmR0tVeExMSmU5QnNpL0Y2RUxkUW1qYVJQN2ZnYjhS?=
 =?utf-8?B?aWtNQ2NpYXlUbDRWb095ei9WSC92aTZiNnhGd3ZaWU9EQ29kbjVqOW9DbTFN?=
 =?utf-8?B?YWdNM0p1WGNZdDdKajE4UUV1NXBCd0trWkMxbGdqWEdiZThKWG5SQksrQVZ4?=
 =?utf-8?B?UnYxS25LMTFSTitLZjczaHJXa24zTXBRMWs5S2ZlTGJjbUZtYlRVU3FJWlRS?=
 =?utf-8?B?MjlhZ0VaUHI1UTVLZDF1ZHFSVk5NeHl6NHBWQk9DL01INUt0bk9HSy81YVZq?=
 =?utf-8?Q?D92SucPjdJo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1lKd2p0ZmttNkdrUW1SVFRVckxUVzNIcFlIam95SUxkek8zYk9NNXp3dThY?=
 =?utf-8?B?UFhieDkrTHlYWlh1eU5CaTVwbnlqenZsSThTd3FlNi9OMUV1cFRGRzBRbkhP?=
 =?utf-8?B?eFRkL1o5QUhwckhzSHE5bkZKTCsyOEJSbUlWNXB1N01zaTdKRDREYlNqdk9y?=
 =?utf-8?B?SHRneHplTjNKU1NkZUdvY3JFK2owZjROQTFHQTlaR1JIaWk3cE1oczFUOUZk?=
 =?utf-8?B?RkRTZ1c3Y3g5TE5vVU1nbkd6MDRIS1lZZXhncmcwUk9VbndZb0pBdU5IVjV3?=
 =?utf-8?B?UFRMaHBkWU9JVjVuZXBjaGp1TjFtQVkrVEIycWQ0dlloa0wzKytMZGpoMmdS?=
 =?utf-8?B?YjR2V3VCREJlb1BTN3F2aTF3ZWh0R093M3hEa2NwZ0dkWE45RDhYejdNMTFZ?=
 =?utf-8?B?ZHJ6K1R3TFF2UFBrYnFUYzg4UnJTTE1iRURBWUlXT244aS9oZEVTRmg5MlJz?=
 =?utf-8?B?a2RpcHBCVXhXMHRCbkZSOW83QmZSeHhkTlJLcnU2eGowcVZQVC9FVnJ5Z1hm?=
 =?utf-8?B?REw0V2dVMlFtTHljN1haVjFLK0swSmZrcUpGNGQwMkhsY2gzRTdjMkdiOFBJ?=
 =?utf-8?B?NWFicXFZTVJlU0JFWS90Q2VqLzRVaXd3RlpaVnFuT0FLd0p4WGNGRWcwL2dr?=
 =?utf-8?B?T3o0dmt6dHpETnk2UXo0MlpGRnpIeVBrR3VzV1o0NTZjNXJXUHpoNFR0STRB?=
 =?utf-8?B?KzJ3ZklmRlFEV1RnRjA0enJEcy9KY3dpZGZ0WFM5MGdUbitHNnFNWlc0dXRw?=
 =?utf-8?B?L01taHU3WGE1R0FRU3JFemJLV1dhWGJDR0F6OTl0eExjNlkyYTExVW5FaU5P?=
 =?utf-8?B?VU5VRXcyeXBEVDdQdW1DWG1tMjRpdVZoejJLRDlTZnRQYno2R1ZBNnY0aU9l?=
 =?utf-8?B?QTVSa3d5MGNIZHlEYzRiRDZqcFNDbktoV3lWR1BmRlpJMkNxOHlRd1Q0QmVr?=
 =?utf-8?B?SVQ0YjIwbHVzcWxRMCtzaStyQXRLWDJHckdHTTRMM0k2R3lpZHFEUGxybmxt?=
 =?utf-8?B?Y1VGRTB1RTNHN2Y0SFFHWDY4Q1lYRzVOdUlTaUpKTzRNYzVoK2xOQ1daQ0lm?=
 =?utf-8?B?VG55bllCU3VQcWRwYVZQbGZVWmVYUHRlcTdLemIvVm5ycHRsc0c1SU5hbTJX?=
 =?utf-8?B?TytpR1ZhcWZtTnp6WDh6N1hEREJPMVZjaDZrZjJTb0l5Z09zVTBlMHh0WFM2?=
 =?utf-8?B?cS82ZXg0OUV2SC9ZMU80QmRKSnF5TXhzM1VoaXh6RW1vTVBaRmloUDRKVFBG?=
 =?utf-8?B?eFk5Z0FEMCsxU3FuZ2ZnaHBvK3hTQmMzZVBmT054YW5YVjFOUjlBbmhNQmxi?=
 =?utf-8?B?ZlJJTUcxbm1aZDkyaThoS2Z4QituWlpCR2p4WXo2elRJOFJ2emMzU2htSFFj?=
 =?utf-8?B?eVdpamdZZlgrYlRxcDJiUHJQbU5uR3BSUXhXaHM2QXk2U0o0K0pqZXd2RlFD?=
 =?utf-8?B?aERpZmpZVElpUjgzalVDMjVBME9JK3VVTS92UmoyU012OWhYUkx3OS9HSU50?=
 =?utf-8?B?cUhMYVZBQnppZHUxR0t4TXVhNGRrSWhBbHkwSm5LQnhpZDhydVBaN0YwQ3Jz?=
 =?utf-8?B?N1JwejV6QVFrcFJ1V1R2VFpRUnBuM0NhbG80R2pUU3BBeVVUVUdVNzc1SDNL?=
 =?utf-8?B?ZDkwWGtkRmlHSnBwOHpZZ1ZUekJPSFp5UzFmaHlMOHRua2luSkcyaEdmRTBp?=
 =?utf-8?B?VmY0WFlSa2cxVEdZRVFXUlZQaFZmSXZodkN5RkROR0NncVpvMHdFSFBjK1d4?=
 =?utf-8?B?OTJGQ3lteXNlMk42aUg0MW9Id1EzUDU1ZmtxcGFESXgvYkFJR2pLUC9VVmk2?=
 =?utf-8?B?K1RwTEl0RGpBTUxvY2poTEQxVDU3Q3VvU2dqYVNQM2Rob3pFbG1JMXdyNnh3?=
 =?utf-8?B?MkdkQ1d3WjlRRUp4c2NlajhqUGNYbkwvWHZaOVg5T0doc0U0bmJkNXM5RVp4?=
 =?utf-8?B?UWJJSkFwY0lCUEZXUyt0NVVWbUwrVWpMYk1BcHBjd3hEb3hBc2h2MWc0VHIz?=
 =?utf-8?B?NkFGWFpiMmxjemNTM2JiNnpidUYvVDNOREQ4QlBtakIvSU1rdFZ5M2didUxh?=
 =?utf-8?B?dE9YaTM0U2xwcnd5OW9MWTRYeGVFNjZUUmRWSkVkbTJ2UkIwVWNKNkZKNEdX?=
 =?utf-8?Q?2UxV3f5buSKUFa112ICOc+BNv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c868ac7a-32a5-4364-9053-08dda2a43b6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 13:40:41.4236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxfAg712anm7MzVKjqiubwJCzgGUPVTFAzRLD/m6qg+blwbmp35FAMJQACtM24FdGYhp28QarneYV+dVB6CkkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7928

On 6/3/25 06:47, Xiaoyao Li wrote:
> On 6/3/2025 3:41 PM, Xiaoyao Li wrote:
>> On 3/29/2025 4:30 AM, Tom Lendacky wrote:
>>> A page state change is typically followed by an access of the page(s) and
>>> results in another VMEXIT in order to map the page into the nested page
>>> table. Depending on the size of page state change request, this can
>>> generate a number of additional VMEXITs. For example, under SNP, when
>>> Linux is utilizing lazy memory acceptance, memory is typically accepted in
>>> 4M chunks. A page state change request is submitted to mark the pages as
>>> private, followed by validation of the memory. Since the guest_memfd
>>> currently only supports 4K pages, each page validation will result in
>>> VMEXIT to map the page, resulting in 1024 additional exits.
>>>
>>> When performing a page state change, invoke KVM_PRE_FAULT_MEMORY for the
>>> size of the page state change in order to pre-map the pages and avoid the
>>> additional VMEXITs. This helps speed up boot times.
>>
>> Unfortunately, it breaks TDX guest.
>>
>>    kvm_hc_map_gpa_range gpa 0x80000000 size 0x200000 attributes 0x0
>> flags 0x1
>>
>> For TDX guest, it uses MAPGPA to maps the range [0x8000 0000,
>> +0x0x200000] to shared. The call of KVM_PRE_FAULT_MEMORY on such range
>> leads to the TD being marked as bugged
>>
>> [353467.266761] WARNING: CPU: 109 PID: 295970 at arch/x86/kvm/mmu/
>> tdp_mmu.c:674 tdp_mmu_map_handle_target_level+0x301/0x460 [kvm]
> 
> It turns out to be a KVM bug.
> 
> The gpa passed in in KVM_PRE_FAULT_MEMORY, i.e., range->gpa has no
> indication for share vs. private. KVM directly passes range->gpa to
> kvm_tdp_map_page() in kvm_arch_vcpu_pre_fault_memory(), which is then
> assigned to fault.addr
> 
> However, fault.addr is supposed to be a gpa of real access in TDX guest,
> which means it needs to have shared bit set if the map is for shared
> access, for TDX case. tdp_mmu_get_root_for_fault() will use it to
> determine which root to be used.
> 
> For this case, the pre fault is on the shared memory, while the fault.addr
> leads to mirror_root which is for private memory. Thus it triggers
> KVM_BUG_ON().

Is this something that can be fixed in KVM (determine if the range is
private or shared) or does the call to KVM_PRE_FAULT_MEMORY require
modification in some way that works for both TDX and SNP?

Thanks,
Tom

> 
> 
>> [353472.621399] WARNING: CPU: 109 PID: 295970 at arch/x86/kvm/../../../
>> virt/kvm/kvm_main.c:4281 kvm_vcpu_pre_fault_memory+0x167/0x1a0 [kvm]
>>
>>
>> It seems the pre map on the non MR back'ed range has issue. But I'm
>> still debugging it to understand the root cause.
>>
>>
> 

