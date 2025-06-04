Return-Path: <kvm+bounces-48412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 443DBACE090
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9165C179C07
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 14:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C48293457;
	Wed,  4 Jun 2025 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Glaiifsz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50C829372B
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749047845; cv=fail; b=nnLrsjxjUnbcwHwVH22eOW++x4ijIekkLKrpUKvsOFq42l7/BwzVu4UoOFMKKEWRjgSxLeWKlD2zT4wEeFBL/LLLHbwgo5HQfJjLaXGkY1EVtwGvqqN9JnWg9P8HJIxI/7J5PifXsNLPlfsgKYye2tt13M1szCe5Hq/Y+VgNC7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749047845; c=relaxed/simple;
	bh=XweOihfq2VnkYi9a+/iREKpwy2+C0hmU45bmRtzT5Tg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uT/uKo7DElMoApKTZ6caUJnAY5pO0QM97+3QdMQg59h2CHca0JoKEheG0EjJ49bZJb50QbUZ/dbsITyiTkauXP2/XHv9w9kBq0Uo84pDBbkNzCEXi13bLe4XIFUfzNLXI2MSvV+DzAij7EghexAi2V4QlyflGv7gNTA6zKa0kRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Glaiifsz; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYJSZdnZQk13Nt92CcHefB8sq+3BpFfo8XhCGk1/3AMLQbTnlemR8V7ULhH7SHi1ao8VrFALs6QYXYaspIJaJKm4KOmf0NCTrP8N3geQFbSKuKusy95e+2/+JgpGlt7w4vAME4ju2CR6ktWX8/eok0VsZa2SsiGqDt87CgOnsR8IowYXtLVjNjQwY+bq8LUDg5iuvKlIs6YETuIJ3waCc2/AJ2sZKN/OpdGWa9ZEjcrsLc6FCaO/mgz9TQaBsUjZStz/SJ/PCFDYxejKIoFzBevyEMw2VRJBIaXdtgoAaxmXLASzkh//9f4M5YudJYLoc4lPAuRJMSmwOvcTl877TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLbwpTXNRFTTTJQAC99ms7gNL5PMtiEJYe/+g+g6grc=;
 b=oKtJu0vuYfkWHyzuRmDVSVsowWCDe+NLYuA/WAwBLp9aKrxD86hw0L55pE3Cbs/11zMA48b2JgC6gNbp0ADCtJU+nsgaP9KlOlEUC7eOYwWFDNq/wUnEKJ7nE6exotCF9rocR1szszZBa5j7AjwE0JCRh/j8xgCEh1loBBxlCTxWFiepEEGh2mjqTnlWo/ZoGWBrOtC2am6Q7oVVYM3IeE39KMuYCMyZVQm1p88cOVFggGmgkKzh/TD4364cAkWpfUUgSCIMe07waEuRxJu6n8FenzaoGKep88I5tiazVkaYW6p7hxQ0RLqRg0Nfl/nluuwvONH0sFyBaytPcyKwOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLbwpTXNRFTTTJQAC99ms7gNL5PMtiEJYe/+g+g6grc=;
 b=GlaiifszspLzRniODXrDxuGCAO5Mbvi3/WP+M4MF8KCcU43SLEiqvk4SODroGJ1/ip3/1KCa1V0Gc1c3LzMu2NiPl9oHamRqszt+jxD49eWbOdxkHIjHFcenEsnK86Slea5s43tps5e3C8dWrSyUhN+KmYzTPyJYZxuztKzugxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Wed, 4 Jun
 2025 14:37:19 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 14:37:18 +0000
Message-ID: <5e4f2c14-dbc6-41e5-b322-b555ab9f02ac@amd.com>
Date: Thu, 5 Jun 2025 00:37:11 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v6 2/5] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-3-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250530083256.105186-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY2PR01CA0017.ausprd01.prod.outlook.com
 (2603:10c6:1:14::29) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 03d4eee0-abd7-4d39-b5e2-08dda3754ebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXFCUm5YeHdSUlNIZVRYOURudXo2MWdUVGFwR0pubHpNMFpBQkdSV3ZIN1hN?=
 =?utf-8?B?WTBncmhvc1M0M2J2ZERnZHFxclJ3aGRLQmR3RUN4OU5Qc1dNK0J1bTBvUWRZ?=
 =?utf-8?B?elAxMi94emU2ZG5UV1FFL2FOcXI1dkhSdGJRUnFpKzQ0M3orV1l1cG5ZSFFq?=
 =?utf-8?B?R1JuMkdNVUxoNHFKRUFBQU42Y293d01PbG4rOFlvTzdYUTh1N09XUzNnbUgv?=
 =?utf-8?B?cVpTQThRSVdRbU1VY2plSmFMY2Z1VzFXRS8wL1JaODhuQmowL284RUwxOXpF?=
 =?utf-8?B?K1dSUDVNRUgvR1JuUXk4RVYxNEZOYkhkNXMxNFZYM2hxZGtodTRza3ZORXdC?=
 =?utf-8?B?L1M4RTl6dkswdTRxSDdKM3R3elczZzNxSnR0bHd4TnBwT29NamtXeEZacUp6?=
 =?utf-8?B?QzdyeWUrT0hqc0sxM2lhckdyNnNRRXl5UUdRM2kwUXU4cytDR2M0NDJjUWNN?=
 =?utf-8?B?N3dtak5MdkxwTjZvR2hZVTZTbDVGSllzS3h1THFweEZadDRvNmROdkk2UWVN?=
 =?utf-8?B?UXFQcUpJLzF3aHNwanc3T21yTnU5V0VHZ0Ric3JJWXpJQWxsYnNhNVZpc2FM?=
 =?utf-8?B?ZXlraHpOTWhpRU5VS2xHa3RTM2MwMjZKZ0RwYlJmS1NHQ3BscmlUVFhKb1ln?=
 =?utf-8?B?RFBkK2Q4UDliWUtsRzRQSlV3Q3VPVVlZakh4SjRzMEVsVXNJTU1TVUZSeDg3?=
 =?utf-8?B?a0w0UW4wa0czdlNybTdhVlpDN1M0ZW1mZ0VxZG1mblYwU0JCSXd6QTg4OTNZ?=
 =?utf-8?B?MWo0ZEszSi82WU02Z3JDd1BmblFWMmw3dVgrQklHNkNlSEJjSFBGZUlkMVdE?=
 =?utf-8?B?SExDUnZkc1JhbVIwbEhMdU5uKy9Dd1l3UzJJTVdRK25mNTBoTVliZ2F3TXB6?=
 =?utf-8?B?ak00L3VUMjhkWXQ1STlNNW5uWi8yTzlMNXYzY2sxOXNheGFXbkh0UHFGK0Nn?=
 =?utf-8?B?U29OUlNTcjZKRG5aK2lHb01TVmV6dVAvaUdkVHBJZlRTeVhiWUJhek1ES1pS?=
 =?utf-8?B?L3ZHcEFQckRzeElQMUJuWFFYay9EeXQ1Z1pvbUMvSXFJRXROcGg4MWl1REJO?=
 =?utf-8?B?MW1EVjhoSUZUaDRyVWZTWm55MEZkbmxsdzR4ZzdBaFVKM0ZHbDMraWU0VzBq?=
 =?utf-8?B?QTVUc29zenpyUEhHazc5ZVN1K0I3NEFjV1A4akFIam5aTTFGVXl6U0kyZjBp?=
 =?utf-8?B?c1FVTXhPWkVFSEgxSXB0RExwQVp3cjRNSVAwTmUxS08rVDRZbFhxN3dqVHdh?=
 =?utf-8?B?TjVadGJZMjBPNWNvTSt4aGZWMW93L21uZ3BpQ3I4bG45R3lBcTVzaFAweVZC?=
 =?utf-8?B?aUtRMXFaS0F4Z3J6WEYza0pqVnROdnFvSjI3NHd4WnJLeTZqejBsdWhDa0Qx?=
 =?utf-8?B?d2lGMHJhb1g2VVJFaDkxbHM3NEthdXNZMElXSGljL3Q2VGZFOXMvNG4vOXlY?=
 =?utf-8?B?L3ZyUTJxNS9hVC9BZ2xvYWVMNU1pTXkwRHBYTkExbk92WlpDdnZGbHE2c0tF?=
 =?utf-8?B?NDdCRzdXb21VZm8zdkVUV2M0dnVBOE5IMFdqVXZxcDRidkkyc3pBcFMxM3Jv?=
 =?utf-8?B?NU9ybmtrc2lYVStaWk8weHdkdTJPTWlBYmdSbzlJbWl5aGxaWHBWZDNqWTJi?=
 =?utf-8?B?WDRieEdpNnJRRFFmWlpwVXZWWlVENzlEMDE4bHVGY054Y0c4dkRNUVBXejdJ?=
 =?utf-8?B?SklDUFg2Q3pGZnFLZC94dnhTOC9ZMyt6cWtSUE9xaVJaL1NHR1orSndKK0I2?=
 =?utf-8?B?cmwyQTV3V0doVjRYT292VVZFZjJmcC9heWw5UHR5RE41dkJIWnM0MmFvaXVS?=
 =?utf-8?B?Ry9WWVFRaTc1WG1rWm1uVnJ5TnFrVTFTR0N3ckN4cEc0cVFQS1dONkt3Ym5o?=
 =?utf-8?B?WlRZZG5PcU8zWUpYWW5id010dThCVGJUWEdIT25lT1V4aHUydUxQYlRqajRx?=
 =?utf-8?Q?QDSZCAD0/IM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YVNNNENMdXJhUk5SdkRWcWZyd0JrOWI2UWdQWE43cmc1RW9vbTBFd2R4V0Qy?=
 =?utf-8?B?cjhWOStsMlc5bE02cU5ERHNURld3ZjhPM2J6TCtPNlU0dnZIN1F5ZmVVS0do?=
 =?utf-8?B?UnhhaUh0dndva2ZGdDVTWkZHWkM3d2JHNzB2emtKaklpdUF1T0xVK0M5d2Mx?=
 =?utf-8?B?LzRkMnA1QzczZVltRGdlZktrRVhvVWVjK1UrMHFNb2RsUGVYZGNjRy82a1Z1?=
 =?utf-8?B?OW02b2N6K2pIaXF2ZVlheWZQNHJCNUR3elkzMzlWREh6dS8zbWl2UWxNZUZn?=
 =?utf-8?B?eEJZWDdONUZlVy9vUWZsRjBrVWFqRGpWV1ZXeHBnbWJIZGIxSEdBOFVhOUVl?=
 =?utf-8?B?bU40cEdmekFWZW40dDQwK2lwdStHcXI3Q2llUmxCZDNlbjhFMnFvTUFveDMv?=
 =?utf-8?B?UUczdEl3a2FXaFJ3b1BmaTdRenZ3NDY5OHp0dDVtb284T2k1TU1rWWp1SXF1?=
 =?utf-8?B?UHBIaGluSVhXNVdjOGQ3NkFKVExwMlZ4aTN2TFpiblJ4ZWZKSFduVkhKT3R4?=
 =?utf-8?B?czY2YzZRbnA0dCs1MDVsSEIvN2VPMGxtZUpLTXZ5RVdta2VjVE9BODFub2RT?=
 =?utf-8?B?ckdMRWhGdUFzMEhHQnRoVmhEWXkvNUtnZTROamZBKzVHZXFRbU9yYzZ2SEhr?=
 =?utf-8?B?d1JZdHM4WE5zbDZJbStIZ01pMytoVWljZlZYZGtBc255UlVuSGVEWmNGK3Z6?=
 =?utf-8?B?N3UwRm83YjZFUm4vbjhMMndydzJOYndPcURqUDdkUUtBN2tIV3FORll2SjVY?=
 =?utf-8?B?TjZYME1Dam5HSzBENlNQS1JxbU9tdEFDa2ZYTzNMenhDR2I2Q2ZsbEFUN3o0?=
 =?utf-8?B?UnJUOU1ieWRDcnRiRmgyRjhFNjlPUjlSUEdOak9Sa3VxUkFVOTh0Z1lnS3pY?=
 =?utf-8?B?N1krOVo1M1JXU1htcEZtRnlYM3JMMlJ4Yk1BM085S3Z1eHZNZ1hjNlFXMWhE?=
 =?utf-8?B?S085Y1E0TFNKaksvaGx5aWpXMDhFWS95azFZK1UyY2pCaDg1M1NEMkovMTJ2?=
 =?utf-8?B?UVZ4c0NxbWtkb1RzTmF1aTlpZEQ2aVE2bUtpZVVUNHFTZ284eDJYV2FXcXpt?=
 =?utf-8?B?SG43M29HV2RERFZQWFJaWm52ZHcwRWdFYk02dHlHRUZzbDlCc3NZUkVRcndw?=
 =?utf-8?B?bzlsRml4elFqaXlHWlFCcmovT3JRc2R0OW9SVmk0eTRpcGJndEVKcGlTditZ?=
 =?utf-8?B?eUNwMHdaTzM1WitKY3Bjc0hhdVBRc255SVRiMmV1VEpWeVZ0cVphSXZPanFt?=
 =?utf-8?B?akJnZ0oyOG1HNUtvREhVWlNSU1NtUWl3clh1OXU2eHUxYlM0V2FiQzN0WjBk?=
 =?utf-8?B?UzJQWjFKS2NnY2NlRFJPYzRpbTBCZ1JEV3crcndZTFh0aStUYW53ZUZhN3li?=
 =?utf-8?B?MGRIQUJXdkJQa3E4dzU4TEdOQlhESHB6dUZiMXErR2tOa3lkWTJTUUx6eTcr?=
 =?utf-8?B?NEMwMFl5U1dMYytqUWdkbWZDZGlPZFAzeUZSbGZvNE9RWGZKMVhITCtoUHFQ?=
 =?utf-8?B?TFV4S1lsTzA4cXRERmxOZ3Q3TDZFbGs5VTRjK2pGQXdFUHkrMXQwU05ZclJt?=
 =?utf-8?B?QzBkQkJNclljWmQ3YUROVkJjcVVKOXFoN2dpYm9SNlQyUGd4cnFXR1ZZb2ZF?=
 =?utf-8?B?djh5UFNONXk5N0pHZTgxR0lhcEJsdUxua0h1eGh1UHR1ZTRLdHJHMlBxZmRH?=
 =?utf-8?B?T2ZlRGptODV1cWl2SnN5QjNlU242MjBxNXdneGlydFpKTW5XV1h4aE1GNlFa?=
 =?utf-8?B?cGlCRHM1eEVaaUJpNW9pR1Fiemc0WTV6aEdDcEJLTC9IcmNrTGpDYVV5K2t5?=
 =?utf-8?B?SG1SZEN0Nm9hRjJyRDVPdE9MakVweW9vRTcyVU16aWJKbXlzR1R3YjZJYnNN?=
 =?utf-8?B?SkJJWDBqTjV6Z2pxRWlobFg1SDVvQU9jMDU1N0t2U0w1OFA1VG1XL3BLZnBo?=
 =?utf-8?B?M1FsdElDVFZtMVdtSWhoNE1XNThnaS9yUGJQenpGVnRzQXM5SEgwRFZNZ2M5?=
 =?utf-8?B?ZENGeUhVMnRJSGR6ZGxqd0xTMWtuYkVkSWV3NGlpM3NZZVE1d244U2hWNCs5?=
 =?utf-8?B?ZnBWM2wvZUtNMGNVdFRIMUR3V2pNQnFrZzVuMnFXR3RRQ3lWckkvYjYxRXo3?=
 =?utf-8?Q?YXsgzDorcXNHFCu1JL8HeS++v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d4eee0-abd7-4d39-b5e2-08dda3754ebe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 14:37:18.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9aGbKdYgHxvSXU1uXBCWlzatqNyPM7HD29A3DqyZAtTnZkz7H7dXVfNrUp0YFkFX8yzVfCbX6g4gtCy3D1A8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8178



On 30/5/25 18:32, Chenyi Qiang wrote:
> Modify memory_region_set_ram_discard_manager() to return -EBUSY if a
> RamDiscardManager is already set in the MemoryRegion. The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> one MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Tested-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>


> ---
> Changes in v6:
>      - Add Reviewed-by from David.
> 
> Changes in v5:
>      - Nit in commit message (return false -> -EBUSY)
>      - Add set_ram_discard_manager(NULL) when ram_block_discard_range()
>        fails.
> 
> Changes in v3:
>      - Move set_ram_discard_manager() up to avoid a g_free()
>      - Clean up set_ram_discard_manager() definition
> ---
>   hw/virtio/virtio-mem.c  | 30 +++++++++++++++++-------------
>   include/system/memory.h |  6 +++---
>   system/memory.c         | 10 +++++++---
>   3 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index b3c126ea1e..2e491e8c44 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1047,6 +1047,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> +    /*
> +     * Set ourselves as RamDiscardManager before the plug handler maps the
> +     * memory region and exposes it via an address space.
> +     */
> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> +                                              RAM_DISCARD_MANAGER(vmem))) {
> +        error_setg(errp, "Failed to set RamDiscardManager");
> +        ram_block_coordinated_discard_require(false);
> +        return;
> +    }
> +
>       /*
>        * We don't know at this point whether shared RAM is migrated using
>        * QEMU or migrated using the file content. "x-ignore-shared" will be
> @@ -1061,6 +1072,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
>           if (ret) {
>               error_setg_errno(errp, -ret, "Unexpected error discarding RAM");
> +            memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>               ram_block_coordinated_discard_require(false);
>               return;
>           }
> @@ -1122,13 +1134,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>       vmem->system_reset->vmem = vmem;
>       qemu_register_resettable(obj);
> -
> -    /*
> -     * Set ourselves as RamDiscardManager before the plug handler maps the
> -     * memory region and exposes it via an address space.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> -                                          RAM_DISCARD_MANAGER(vmem));
>   }
>   
>   static void virtio_mem_device_unrealize(DeviceState *dev)
> @@ -1136,12 +1141,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>   
> -    /*
> -     * The unplug handler unmapped the memory region, it cannot be
> -     * found via an address space anymore. Unset ourselves.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
> -
>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>       object_unref(OBJECT(vmem->system_reset));
>   
> @@ -1154,6 +1153,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       virtio_del_queue(vdev, 0);
>       virtio_cleanup(vdev);
>       g_free(vmem->bitmap);
> +    /*
> +     * The unplug handler unmapped the memory region, it cannot be
> +     * found via an address space anymore. Unset ourselves.
> +     */
> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>       ram_block_coordinated_discard_require(false);
>   }
>   
> diff --git a/include/system/memory.h b/include/system/memory.h
> index b961c4076a..896948deb1 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -2499,13 +2499,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>    *
>    * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
>    * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned.
> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>    *
>    * @mr: the #MemoryRegion
>    * @rdm: #RamDiscardManager to set
>    */
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm);
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a
> diff --git a/system/memory.c b/system/memory.c
> index 63b983efcd..b45b508dce 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2106,12 +2106,16 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>       return mr->rdm;
>   }
>   
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm)
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm)
>   {
>       g_assert(memory_region_is_ram(mr));
> -    g_assert(!rdm || !mr->rdm);
> +    if (mr->rdm && rdm) {
> +        return -EBUSY;
> +    }
> +
>       mr->rdm = rdm;
> +    return 0;
>   }
>   
>   uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,

-- 
Alexey


