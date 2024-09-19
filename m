Return-Path: <kvm+bounces-27169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F0A97C41C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 08:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DC8E1F22BAA
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D30E14A4FF;
	Thu, 19 Sep 2024 06:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xzIg3PST"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3D914A088;
	Thu, 19 Sep 2024 06:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725751; cv=fail; b=AODmfdWG1zwcj1QdnSi9HUjaMrQWC3i3mJHTcotZoyNtQoHYWarQfITx7hQX6WaTATVYDA3Yw4UQxWjQ5WvygXXaux2KgGYdAdhGdxoWBrlTlbtEbcUQ7gE6R8H7sHO/j4+t3L0qWYEPPM5Ecl42gp2BoJSgudxOzjd38g32J4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725751; c=relaxed/simple;
	bh=9f+DvHNKRSi88zmQPpGqmGvTUFS3sOEQIlPwU8nOUKw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oG/MJt+9as6I/HcozntmUM1n0YRTcpTQK4lqY3jJsa4atrSHxUp2fsHDm2dv80SysclCs57GpoJUXC9fwyDBjEn4lyr4WtuUkkELDbDchU7cQ1rXKlU/+wxKg6KVL7Y76Yr7mc4MJWs9DO5VjPhtn9eGR0CjvHHHOyqDYVuZ5NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xzIg3PST; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zOf5aqr2wD9vavyTK1WwEzOiMRyIv8ks8RR+rK/B2ZVHphhFgQpwmvNQIVs7t7VLkgjuD/rozd6ggwj+Jh+zpal3KNmQzRz9OQj/esI42doYJsTxJ7052jYQEHnXvxM0hzT6cAR5MlXk5RmBqutDK7q6aL1h42m7N/xFfvLz3an1Os76hYVyOd4jqryezzfZLXLJAtEqQaw9kGOnhDzLuXtxWRSCujek2AJXuVgGF3lrXkT8lt2/0E5ARCD5nICrI5RP28fgBy/OvCokM5a44c9LzbSgtMglgpDD6f/gqzoOs6vqXn/IK97hMwI1Z8Y2+p39LTyln6QMXF+sRPs58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrUeeiy6EoZGUXR2QviWDliRSzDdY6g6dDIX9qutEAM=;
 b=tVcNqgCjFnSN6wrhQBzNpmP5giwUdFTO3jvo0hlhV88n2Lvg8mVyyx+g5cNi2uCmTcu4e8rK+iE3gbu3wwQN5SbWZlqOP5MyUWNolNoUNVFmAKBsgw23sCzpi3pFwNkBLA3Fzd4QQBWKCHtoevdngOw5FogjWAaAhStvra84FwPGnwwfWcNNkftI7enmg+GxDneNhPaUviRE4xnwswKkpo6KGSLMUcTHuQVtVMsYgGj5p8Mb407B5cCXDmxm7pwwSBOyAa/AOVY+3A0RKh2BMVrW641cbOeszaQWQXi+puJGouMnXhXmN+FHNLmCz6bHuPSDKDlFZEs1N+Oq7qSCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrUeeiy6EoZGUXR2QviWDliRSzDdY6g6dDIX9qutEAM=;
 b=xzIg3PSTjC3udvgwl9uBCYMJbSlDx/793G+bGn60Hq6+bktQC75/ENe0tHaYYSO3Ts2kHCXxyHnoQbGoyXb26cTR2jp5sks/BIKbsGODscGOZ7V50xg+NmEqxjVsAOUm9RFw5hIVAITMyoV3V5KK1qbe8MiRz/VwX6ysPZ9/CE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 IA0PR12MB7603.namprd12.prod.outlook.com (2603:10b6:208:439::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.16; Thu, 19 Sep 2024 06:02:25 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%5]) with mapi id 15.20.7982.016; Thu, 19 Sep 2024
 06:02:24 +0000
Message-ID: <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
Date: Thu, 19 Sep 2024 11:32:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Manali Shukla <manali.shukla@amd.com>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20240801045907.4010984-15-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0018.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::33) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|IA0PR12MB7603:EE_
X-MS-Office365-Filtering-Correlation-Id: e66ad0e7-1212-48c6-fbdb-08dcd870a193
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z003QXhnckd6NHNwT0RlOG51eS9QbkFDN2Vhd0MvcDdFMitqR2Y3Z2huNjVE?=
 =?utf-8?B?Y0FmcVA3Zk8wcVNZazN4dHZWMytkczk2RnQ0aCt4SjFQM0FBN0RRemRZS2Z6?=
 =?utf-8?B?MnVBc2FWLzg2RGlla0hZSjZMWC83Q2Zoa3hMejYrTzRZY1VUQ1B3NitsQW5y?=
 =?utf-8?B?MFlrc1MwOTBOcmNlZWZ3aU9MRDdkeDluSmpUT2lscDhEMTBjeHRTaEFWQzRn?=
 =?utf-8?B?Z0JZR1ZxR0JJWUMvdWVBbFMwVmlqZ2psMGR6WkE1TWRRUmJ2bzY5a2JraGh6?=
 =?utf-8?B?MXRSSklOam0yb0d4Z2RPOEdzUXozVWo0WlhlSktDUDFXT0lIbW5lb25Nc1Jx?=
 =?utf-8?B?bDdSRCtLcDh6cUtRczZ6RUo2VUtHaElJUEpOWVJWR0E5OURPSkdCRnpUMTZm?=
 =?utf-8?B?UkdiNVhNb3QrMkhNSVNvZzBtYVNjVTJYeDJSYWpOWFhCNEpKWXVSamtyTlA0?=
 =?utf-8?B?cEpvdlcxVWFWTUtLdmcxUXhLY1lBQks3MFNuaW05a3hvUE1aUnBQWWNXcHZa?=
 =?utf-8?B?Zkx6bStaTXVNcHN4MG9MdTBDeGlKR1lpTGQxNllienhobXRETVFpTll3bDM5?=
 =?utf-8?B?ZFdKU1JsdlJxS2U3WjVrSXpDSyszd0NVK2tDVDI2dHp3eThWb0RGbVBYaGtr?=
 =?utf-8?B?NG5OZnpvNDhGb1BkeEtxdnQyaHBaLytFTi95NVZaYW5yMndMRzRWTDc3U2Vr?=
 =?utf-8?B?OU91RENKOVAvcTBZVEt6WVRWdkMyMVp6bDBjUUlJSFZ0ZVpxMFJuQ3ZJRGJl?=
 =?utf-8?B?dlMrQnhHcW84UmxuUTVGK05kTkUxSWlwSHVxZEFTYTE4eFBab1NzQ2F2blJH?=
 =?utf-8?B?RnVDa1FlcjdWQ3dtdlVvOFVUWlR1TGx4aG5DTnJra1VKREdKdXdzVHM1NGk2?=
 =?utf-8?B?SitKSHN2ajN0R0tEVjQ0bmppNDhEUjBSM0FVbDJJb1dpOEZNRi94N2ZLVDVG?=
 =?utf-8?B?Q01qU0lLczRiMmtuTml3SmpXcS8wMUhRbVVZdGxkeG9ZWVc1dVVNdTBwdDZl?=
 =?utf-8?B?SjhoemU1SlcwendmMGFHcnRtWi9IR3V6Z3Q1SXh1bEwzOU9jeTU5MTUybzFr?=
 =?utf-8?B?YlRpOGFWRXNqdDZ5dWtDN2lRanNsZmlNSlpGT1ROTjBZUnFlWEdXbHIzaHV6?=
 =?utf-8?B?eTFDclUxcVNRVU42MDk5WHdhVTdXY3RWN3h5Tkp6dW1vSWJFMGtLNFp5QmlP?=
 =?utf-8?B?ZGttMEVBT2MvRGtjWkhlUzVBMVR5Yjk0LzRoVUFkdklzZGtZRmxteUxGUDRl?=
 =?utf-8?B?cTdYa25qWEtVRm5Pa2tpaHpSZEd5Z2YyNG1ybk5DYys1ZVhzZUtraGR3UkZL?=
 =?utf-8?B?YktkazM5UVNCb2p4YmUyZXRNQXhJRWovTEwra2JFV0hQbHJzS1VseFgvb2dX?=
 =?utf-8?B?cThld01RV05iczBRNTgrL09OTFZJR0FSVFRwaW5tY1BzbHYvVTljR3hXUmxP?=
 =?utf-8?B?bzBick9wWlFZa1NDQTBOb1diV1Q0TG96RnU1WW45SVlVQmtydER1Yll6OXNp?=
 =?utf-8?B?Z2MrR2pvVFpBSC82c2pUNmp0M2RHQ0RZbFVMSEJoV3BXSnRIdmplY3VGNjNu?=
 =?utf-8?B?K1NnbnFRSzJtVXVNekRtdy9qcys0RnptNzAvWkdBVFRMOUJFb2oyOFNmbi9P?=
 =?utf-8?B?Z1ZBWVNEVEpoZkNGNFdEOVR2NHVkWHZOK21PaFdZQjNnTm85bithb2tMc2hl?=
 =?utf-8?B?cU8xb2lDOGZBMzFLWE1OVHQzcStVTWxWbmJmR2RabjlFdXU5UnFBVUpLY0h4?=
 =?utf-8?B?ZmNLZldZdUx0a0huR2NIT2hmOG9nem9ZWGxqOUIyMWU5WjMwRDUybW94dUJ3?=
 =?utf-8?B?ZFlMR2JGR0dicm5VYjlwdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFlkVVp3ZkJWMXloRGVDUmFic1BxZWZDcUR4ZjlhOVRxcjVsN1hzRVNsU3N3?=
 =?utf-8?B?bS9hQVJvbzdpcGZmdTBjV1JOU2VER0JrbkJ2bENpTkdHdkVlTG04aHpFaXJQ?=
 =?utf-8?B?NGYzcm1QTjlBZk50NG5UQzV1K2dDNStLNUVObHdTNDlMK2ZrQ2g2ZEhIWFpv?=
 =?utf-8?B?WUc3eEY2ckE1Y1pvK3B0MVg5b25BOWtWOG9YSVJFQmdXbCt5Wm1ScWRXSVdS?=
 =?utf-8?B?VzJpQVpiSkJ3cTNKU0FlcGM2Y1NMTjcvQUp3enpNakRhZFR0VENQaDVvL0R6?=
 =?utf-8?B?N0dIWlQ2V21ROGsyeCs1MlRkVklwc1R2Slkwc1hZSDNMRVkwQ2xKdXh6S2Ry?=
 =?utf-8?B?VzhBT2lLSDVvNjRKL0hkblZOc211MkpETUZYUkM1SW8rTHU4aWNRbFd1Q2Ew?=
 =?utf-8?B?R3cySmF5QXF5eGJVM1h4RWJZVENicytBZzJtUEN2dTl3ZzYwQ2JjUU5UM0hY?=
 =?utf-8?B?c2U1bkF1WDdXb0x0TXBpNWJISnY0b1NJR0JFWFhnZnhiYTVxOGhBbHltWlpL?=
 =?utf-8?B?YXhINEpoNktkblJlNmRHVXVoVjkrc0lBMVd4WS9rck9xSUdUaFNycXBkbDBm?=
 =?utf-8?B?V0J3NTlhSlR0eWNWUnJRa3N6RkFsWVRXckpsWDhCUXVaMDJSVmZWbE1qdmpI?=
 =?utf-8?B?VUl0MHR2d1U4VUFPVStrUUNGRk51WHR1d2ZYLzNwRU5OYnkvWjNlU2VwYmxi?=
 =?utf-8?B?MW93NzFabFdXZ3U3M1g2Z3dxNnI2UFkxVkdoZFIyMjhjbXJxSFdsVzhHYWpF?=
 =?utf-8?B?Zy9XNFgxanhHa1JUMDVBTnVuTUxXTmdwNkxSMkVhYkIrVmJpdUg1RDFzR3Y5?=
 =?utf-8?B?YUdmNGZpVkUrT0NzVlZmTm1XdUM2alUzUjB4VERxUkpTTWZGMTNlZlVlQlY3?=
 =?utf-8?B?THB0YTlJZkppRlBrVnpiQ1E4VWU3WDU4U1JMTlcrRWJMdlhCTEppc3pqTkt6?=
 =?utf-8?B?S3ZlK0JCTkJKSi9oOXhzUlpKWjEyWVBLcm9nTmtCa3dFTXRKeURyaVdvR2p5?=
 =?utf-8?B?MXliOElwNVN2ei9Xd0c1QUJSQ0ZtblJrMzMyb0lLYURkMDRLRjNVNytOSE5p?=
 =?utf-8?B?Y2pBWWFRSVJiK3FYQUNaZDczbWFOSVZIYWNsQ1doUC9vL0VCUzlZMnFiTzFI?=
 =?utf-8?B?NHZRdjFKamlRNm5lTTBjNmFkT0RCL1hEWkR5R3ZaT1FOekdVRUp6UjNGd2hW?=
 =?utf-8?B?VXRqNEdKZklDUEdZdzVKL1JISDlHSDFpVCtHZWF1cldjTElVQ3pMRldCdVFp?=
 =?utf-8?B?QW1IMnEzYzNCc1psQVM0U3pibG5GMzBhbWJmTWhLM1VQTDVkWWJzNDRnQ2ZS?=
 =?utf-8?B?blhlSnkvMmlkb0UwaDBqeUxyZU40VkNkTWl5S01MQnJ1b1ZHMVdnQW1qMHpC?=
 =?utf-8?B?RFhyVUdsTFRLdW9velVEYTRJNHlHN21DMGk5VEMvWC8yNGdUU0RhTnhyMFpB?=
 =?utf-8?B?Yk95b3NVUTlwVHJEMUNBdkNTTVdEUkxnc3ZLZ2krN250NVMrQzVyV2t4TUMz?=
 =?utf-8?B?d0VqR2hVc3ZycHNpc2I3OVdGY2VheGJZNFNpeHNPczkwWEdSTWNWamlMOGR3?=
 =?utf-8?B?SHB2YXNRY0lnbGlPWkwyMGFFSmlzem9hLzJ6MGt6Wml0b09nNGEweEt5Wklo?=
 =?utf-8?B?YU0vMi9Kbml1cGJCbnB4bGU1MlRBckVBeHpoeFArTi94TWdPNi84YnFWS2Y2?=
 =?utf-8?B?emJOWXVYa2l5cWF3ak10dHgvelRybWQ3c2hwZlgyYld0K2w0QkNnTzZmRUFW?=
 =?utf-8?B?L0tRRzB3ZDFKdVFSak5ZVVFqWWliYnVRR3F0QktJdFdFNnM0b293M0JDRjlJ?=
 =?utf-8?B?c28yZjUrTzhMSWE3Uk1PVjM1bDM2M0xsOGs1SXg2Q20vMURJY3lTK0pIbzZS?=
 =?utf-8?B?TzNob1ZER0UxbUxPekpicU0vK2puREtBUXNoU1Zaa2ZHb3hHOTM4MFdVdHQv?=
 =?utf-8?B?MDU3VzIvSjd2VWYwZ08wU05Ga3c3c3JWUDBtWis0VVQ0SVg5WFRWSXpQaWc2?=
 =?utf-8?B?WXU5RnpHU0NnemE3QTJtUkRnWUpsZjlsM1pBQStwc0dXeVAybHNRWmZ1WGt0?=
 =?utf-8?B?cFBRT05rejJITjU5ZnZCSG9DTm9BaGRFOEl5L2phYUxGNGZTNWlaaEMxMEJW?=
 =?utf-8?Q?pf+KEHBwpTc4vL0DVQONrVAZd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66ad0e7-1212-48c6-fbdb-08dcd870a193
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 06:02:24.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0U0xqD1mxHvjyZqGAp5Z2zkmie3cei+6FSU/4bOgq490YeQVyU3Ggmn4bj+yc8d3gqgNyfEK11jOCBddLCjxlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7603

On 8/1/2024 10:28 AM, Mingwei Zhang wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> There will be a dedicated interrupt vector for guests on some platforms,
> e.g., Intel. Add an interface to switch the interrupt vector while
> entering/exiting a guest.
> 
> When PMI switch into a new guest vector, guest_lvtpc value need to be
> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
> bit should be cleared also, then PMI can be generated continuously
> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
> and switch_interrupt().
> 
> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
> be found. Since only one passthrough pmu is supported, we keep the
> implementation simply by tracking the pmu as a global variable.
> 
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> 
> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
> supported.]
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  include/linux/perf_event.h |  9 +++++++--
>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 75773f9890cc..aeb08f78f539 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -541,6 +541,11 @@ struct pmu {
>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>  	 */
>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
> +
> +	/*
> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
> +	 */
> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
>  };
>  
>  enum perf_addr_filter_action_t {
> @@ -1738,7 +1743,7 @@ extern int perf_event_period(struct perf_event *event, u64 value);
>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
>  int perf_get_mediated_pmu(void);
>  void perf_put_mediated_pmu(void);
> -void perf_guest_enter(void);
> +void perf_guest_enter(u32 guest_lvtpc);
>  void perf_guest_exit(void);
>  #else /* !CONFIG_PERF_EVENTS: */
>  static inline void *
> @@ -1833,7 +1838,7 @@ static inline int perf_get_mediated_pmu(void)
>  }
>  
>  static inline void perf_put_mediated_pmu(void)			{ }
> -static inline void perf_guest_enter(void)			{ }
> +static inline void perf_guest_enter(u32 guest_lvtpc)		{ }
>  static inline void perf_guest_exit(void)			{ }
>  #endif
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 57ff737b922b..047ca5748ee2 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -422,6 +422,7 @@ static inline bool is_include_guest_event(struct perf_event *event)
>  
>  static LIST_HEAD(pmus);
>  static DEFINE_MUTEX(pmus_lock);
> +static struct pmu *passthru_pmu;
>  static struct srcu_struct pmus_srcu;
>  static cpumask_var_t perf_online_mask;
>  static struct kmem_cache *perf_event_cache;
> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
>  }
>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>  
> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
> +{
> +	/* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
> +	if (!passthru_pmu)
> +		return;
> +
> +	if (passthru_pmu->switch_interrupt &&
> +	    try_module_get(passthru_pmu->module)) {
> +		passthru_pmu->switch_interrupt(enter, guest_lvtpc);
> +		module_put(passthru_pmu->module);
> +	}
> +}
> +
>  /* When entering a guest, schedule out all exclude_guest events. */
> -void perf_guest_enter(void)
> +void perf_guest_enter(u32 guest_lvtpc)
>  {
>  	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>  
> @@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>  	}
>  
> +	perf_switch_interrupt(true, guest_lvtpc);
> +
>  	__this_cpu_write(perf_in_guest, true);
>  
>  unlock:
> @@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
>  	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
>  		goto unlock;
>  
> +	perf_switch_interrupt(false, 0);
> +
>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>  	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
>  	if (!pmu->event_idx)
>  		pmu->event_idx = perf_event_idx_default;
>  
> -	list_add_rcu(&pmu->entry, &pmus);
> +	/*
> +	 * Initialize passthru_pmu with the core pmu that has
> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
> +	 */
> +	if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
> +		if (!passthru_pmu)
> +			passthru_pmu = pmu;
> +
> +		if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
> +			ret = -EINVAL;
> +			goto free_dev;
> +		}
> +	}


Our intention is to virtualize IBS PMUs (Op and Fetch) using the same framework. However, 
if IBS PMUs are also using the PERF_PMU_CAP_PASSTHROUGH_VPMU capability, IBS PMU registration
fails at this point because the Core PMU is already registered with PERF_PMU_CAP_PASSTHROUGH_VPMU.

> +
> +	list_add_tail_rcu(&pmu->entry, &pmus);
>  	atomic_set(&pmu->exclusive_cnt, 0);
>  	ret = 0;
>  unlock:


