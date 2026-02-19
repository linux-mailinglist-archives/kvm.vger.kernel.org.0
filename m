Return-Path: <kvm+bounces-71370-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPkVG5F3l2nVywIAu9opvQ
	(envelope-from <kvm+bounces-71370-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 21:50:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64425162729
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 21:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 00D323009817
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 20:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E21326938;
	Thu, 19 Feb 2026 20:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gv/4Zx5D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B7C30DD1F;
	Thu, 19 Feb 2026 20:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771534218; cv=fail; b=kmSaIJtSjFsNglovGxQCWpWZCuvrh9BN/xQiP/YJecKS1VcC4wtpz0EFPcxjIRLQRVwwV3Sq2UXJzR3e9xOo0SzlOJltnqjLsupnG5Hz8YJBVqSXKxypPRrY3qs2KqFqWzoBnnrHRVng7MvVErVmWVOEgvIA8i83rkz69Y2R3Y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771534218; c=relaxed/simple;
	bh=TcdPW/LMmSZEWkD8FW1Y4LO4/DJqwJJaLELCxej6vxA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ezi67N8/AHc2m8tm23KAbXkkKQHZCKmtgMqKIqVHUZ4CiShaTgNppAfE5G5RVD/8auubySm2BxcDIzX5dqqA59C+612l2Y80hefuzvHb1CJ0dMhf7tKJbVdQ/v3SmlHruseAKMTnVA2j90fsLJToR34PS84fzBRRvdaWknz4xEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gv/4Zx5D; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771534217; x=1803070217;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TcdPW/LMmSZEWkD8FW1Y4LO4/DJqwJJaLELCxej6vxA=;
  b=Gv/4Zx5D/letoGj+CNgCNXgEkMBcviLHdTVPl1seMlTGIg0ueCo1+ZR8
   t2geWL6U4epxh90lYe37D8ram9o3QHFJryXNIqN9XKUgrGTjZBaSO+6xY
   kLq5zRMO8L0CXQBKU5nBmhn2dq4xDmVE2eZSA5vrd9F+GKzRboqp02oRk
   T0JK7/BS5dS+DGbzHwaZV0qYQORqMmGfdwi+OrCT7Pj93GXEAeN6OXU5F
   OMmnGQ6SlEQh0zwp1dfHL7AuKmsDE77wtxCf8uNp0DlUJYf8u/PGl28U7
   AifdVcelPfAe7nnKZPWKYKGjbPfslEum/vauXpwafk8LzNEsyWoK0nfeM
   A==;
X-CSE-ConnectionGUID: CVqnn4e9R1WwKP4hordggg==
X-CSE-MsgGUID: jbBy1VK6S+a6wR2vqbF/jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="76495093"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="76495093"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 12:50:16 -0800
X-CSE-ConnectionGUID: QfO8gTQNRY2V8yS9I4uT1A==
X-CSE-MsgGUID: 3jNu/YDkSJOu05Yv/FWwTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="213740932"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 12:50:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 12:50:15 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 12:50:15 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 12:50:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GquDmX5ANsQ9jg3KAOseYN/LosS9xYBXe/QMGVRoGMN7i1gPXLxLNo3J3Kgt6mEBl0T/1BZrG48X8gVEN1EzJW1Kn0akHQB+KxZfBRhAt4mT5O4aAL99qOuCmuW6qaZjqyRMnkVmaLwQVqDWyUP+Hp7IBr2XVZgSs2rNgNiWR7rPmXjkehqhtndVi0QnA+ZSysNAPGpi06Bsbht6yh81TMiIaW+0u5HdMly+AJ+BZexnm4xGdMTK6wZ5Ji4qC+d4srNkjCAYS4kPFcsi732N6J/oy9q6fd/UHHJaQ7yVfTCzdPzqOnTaK6yYKWIw0cIDbEm3z4rqLrxg2TnQXA3eyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JYEE0ueo3tyE85PBtlLtoDXCfVlf6jpw23qMnV5nqk=;
 b=peqLR/0RjReNa5GT2qklN7kWOPJcpnZPhuqELwe1I0gIJH/FgUCwAH/lm1V3aQT+TPqRngtjeuCWvyul0CMQZZTxkhkcgZOAs9u+bp5U30Smm4DItoPMrCwcoQr8W00T4ZIghxYSleoQ90gR+lyT0aOUqfU8RDvGnH1nvBef3NOgUStFvfmXa9FTBTSzT/jLU/T41FYuBKwv9btrrDnzP8enO2QDX0UMf0NI4J57b31vt0vVYoJlfXu671IKaIvz1elJtUt6O2y4PFDrgROFFUI30+gKt1LP2E6fNWZhFDyGXEFFd7HJ1yEQRDwIzIBGbr9VWX6M9KNfKph6xqZqxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by DM6PR11MB4595.namprd11.prod.outlook.com (2603:10b6:5:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Thu, 19 Feb
 2026 20:50:12 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246%4]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 20:50:11 +0000
Message-ID: <4b68d866-4475-44f7-852c-c5f58e09718b@intel.com>
Date: Thu, 19 Feb 2026 12:50:08 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, "Nikunj A. Dadhania"
	<nikunj@amd.com>, <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <xin@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<jon.grimm@amd.com>, <stable@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, <linux-kernel@vger.kernel.org>,
	<andrew.cooper3@citrix.com>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
 <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
 <103bc1df-4caf-430a-9c8b-fcee78b3dd1d@amd.com>
 <5cf9358a-a5c3-4d4b-b82f-16d69fa30f3e@amd.com>
 <317f7def-9ac7-41e1-8754-808cd08f88cb@amd.com>
 <f7595e7a-e956-426f-81cc-63d742330532@intel.com>
 <3e630286-880b-44e8-9d35-d46bc4744b2a@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <3e630286-880b-44e8-9d35-d46bc4744b2a@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::10) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|DM6PR11MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: cd843e8f-5e5c-46fb-983b-08de6ff879ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VkRXQ2g0NGc2bzFmWk5DSE5xT0hoRHZJRE5DZlByVW8ycUZRQ1dHR0MvQ2FL?=
 =?utf-8?B?OVZvR1FCZXNobTJUSnVSblhxZW1WZ3lMcWFjdE5qTGtjNUtOdEZid05aeUps?=
 =?utf-8?B?QTluQTdYRVIrb1F3RzRpNGVRWGZ5a3pwS28yM1puVzZPUTF6ZXh5ZTY2aFVD?=
 =?utf-8?B?VmlueGdncGk5UkpHYTFVdlRiOG8xZjc4a3pRWHJKcXU4eG9rVHhCMzVudjZI?=
 =?utf-8?B?eEF1ZlNJamZnakJXYzZldTF6VGtuVldYK3J3eXVCMnE4Nk5SK1RPaG02RUxi?=
 =?utf-8?B?OXdxTmw3ZDRWbjJuQS9Hd1dxNERubzJNS3pGd0l1OHk5OEpNdUMwN3JxSzZn?=
 =?utf-8?B?Q21hRnJOZ1FZbmdaM1dtTDNSZGN1QVZTR3RLZ2l2R2dGR0Z1d0M2OXFsNk1T?=
 =?utf-8?B?YnRzdEt5emo2Nyt1cHM1Z2FFWTZOa05MdlJ2Z2RseHRrWncvNmFsVzBFWVFn?=
 =?utf-8?B?QVZLODFLVFJyUnFzelB6TmxvWlV1cENkZkE0T0tYTlV3bUJCNzl5L0lKY0Zm?=
 =?utf-8?B?RGo2WGt1bWo4TGJQS1p1S29xZHJHSDd0NFJOSHhGZkhCUHlBamFqQ0dVY0NX?=
 =?utf-8?B?Q216dkRTMnpwTGVGdy80QlpteTRsZlRKcU5rSGxzNE5CS3U1WCt6d1BpUzZ3?=
 =?utf-8?B?eU5YQzNrMU1JZ0cwY1dtTjM0QjdQV0Vvc0RTbHlsMTA2Uk1DejRSYVUrQUVz?=
 =?utf-8?B?SWxiZXZvMlhucDBhUG9JZVJtMjgxL2xnbGN5UFRsYUgxc3QyOUYrU0d2VTNH?=
 =?utf-8?B?RnhUc2s5a3JvZGtGNGcyRHhQSWptenlCTEc0bGNNRDUyVm96NGpWWWtTNnEy?=
 =?utf-8?B?anFuTEk2Z281bU9WY1IycnIrbWNwTmNwVDFYekp1ZmthUW9lb2Q5emU5dkVR?=
 =?utf-8?B?N1dmdkRWMHlCTnRxRE8yMDFhSnl1TlFGM1Q1VFJRMHI1MnJlMk5od21GY2kv?=
 =?utf-8?B?ZExIMXZSc3A4QTlBaUhIcCtoQjJhVGdFNWcrVjIydU5DNXQ1UGhOcmtqMjFI?=
 =?utf-8?B?K2NLYlllN0ZaU0wxSHBSeG9qSU1sZmdOQVdON2NuVTVWL2Yzd05UWDVKQ01r?=
 =?utf-8?B?eHRyWGZvR0RFY1RveTJuTzRoeGU4Wmc4cjhheXk3S0RJOVhJUW4yOHh3MWZD?=
 =?utf-8?B?NWRZQTV2dDdkYWhBazEzd2Y2Y0prbzczWTA2Y0s2d0JjdWxrTEZLVlEyeldv?=
 =?utf-8?B?NHFUQ1o4SVV2UlRITUlGM0t2TU5jcExpMEVldTRTdEZoQXVQUS8ybUcxN2pt?=
 =?utf-8?B?UUJsdENVOVk5NFlQNllJeGVmSGJUdEx3a3BwZ2FMalFlNWVuMEMwTG85RkdR?=
 =?utf-8?B?ZVJWeVAwYWlXaVlkMEg5WnhJcytYNUMyYy9hcmRzVW5sdERiMGZqTC91di93?=
 =?utf-8?B?UmZSdnNIV3diRTFtWmVOMTNqWVZuWk5lVVJ6ZTlLaC9qT1lNU3ZQbThRbkla?=
 =?utf-8?B?cWRiaEJDWVQzYit5K29pR1Y4bDExT1RsSko0cXlZalEra1NLODdkb1pZVEVy?=
 =?utf-8?B?YnlENkJkMEJnVHh3YnJVRXJ1S0VWSStWYTJRYVhyazBjdUpKSUlCUlNzNEZx?=
 =?utf-8?B?dUNVRHdvS1R5M2NxLzBmc0FFWm1iQmhsOWhMUEgzQWVRYm5OdG01QnQwNDRZ?=
 =?utf-8?B?MUpZcUtvOFRhdEY4bmJ4YWliK0RVdFduOG9uR1N1blJvMjNMR2hjcFRraHlr?=
 =?utf-8?B?Q0pCQ2V1bTMwS3c2bEFLZFI3QllXZWZxaFdEYXBwMWVNSU1reFZpMG05Wnl0?=
 =?utf-8?B?a0dOekRva2ZVdmhQZVJITDZyMDFxZitsdTdpSU1pZjhUdW83QWdtaVFuL3A1?=
 =?utf-8?B?S3lETy94M3ZQTVg1T3pjVFZwZDlUZ1doY01aTjM1ajJTSzQ4RTN5eUJHeERs?=
 =?utf-8?B?NVRsQnNzZHRCUWliSmtXR2hpRFV3S2tnemh2Z250S2VseVkxRFdKSkFxZ3ND?=
 =?utf-8?B?eFZ1ODBlYkZLUXA5bmc4QnVzU3pyRE9uOTMwV2doVmlabkd0WEtFRDRySmcr?=
 =?utf-8?B?QTlhVFVId0tRSDF4YmhQS0l1bGl5MmREQnpkMTlDZGZ4OFRKdDk4dXdZOGNy?=
 =?utf-8?B?ejA1YmxPeVB5ZXpoUUsxdUFhNy8vNWlWeENWblZLSytGenQ0Z2d2U1drSGFJ?=
 =?utf-8?Q?99YI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGtuRklDUXJ3SUQ0Q1NJbGlFeDEyZEV3L0lMQzRxK1JWRzZybWN6UngyWHNT?=
 =?utf-8?B?TGVuR2ZaN1Exc1NUZ1dUd29qbTRGci9UdWZoQVJTTUR5ZzdHekdxYTc2dVF4?=
 =?utf-8?B?SStSa1FMZWdDRHN4MVFqMzB0Nk9uak03RTRSekp0V2hLWUx6SC9wUlU0Mmh5?=
 =?utf-8?B?L3IxSnVQL3A4KzRGUTN6alh3VjdMSGtwamd0c2RISDBvSnRqWHhaRHlXMHIw?=
 =?utf-8?B?dnVBTjR6OHluY2pQNWtaSDdhZHhFeGdKYytCZmJ5alVvcElaQzJHc2ZRYXEy?=
 =?utf-8?B?NFFlM1V1SjJTN2hWamVSUWs1VXNjQjdEcDJudjBKTUd4VFh1NktiTk9TWnBi?=
 =?utf-8?B?b3BIN2p1VU5uQUxlb0FGUmlSbjZvVnFYU05LRm9WTDJ2NUJmRU53cmRCK1lC?=
 =?utf-8?B?Rk9OMitRZGpPUS9rN2hRR0xVaVhyWndSTDY3TnZjY01iNDVoYnZVNlhrNHZZ?=
 =?utf-8?B?U1dWbU80czZWNTEvUUZ1eTE4WkpBaklVbmVHZE5wU01MV2hVWS9tMTRaSXk3?=
 =?utf-8?B?M2JzMDFTU09UYUUvY0ZKR0xYRDRiRGc0aGEwZWNNbElVcVFFcVNXYVdRYS8y?=
 =?utf-8?B?TzhFRVgxNk5PM25kM1crdmNXRkx2dGJVWWNyZ05WaVhZR01UVHlROGJ2UW8r?=
 =?utf-8?B?QlRHMGJ4SFlodW9tVmNCVVlCa3Q5V1Y2N3FTTTZhbXVmeWgwdjZBdmM1cjYz?=
 =?utf-8?B?N2lOcXRRR0wwOFdjTzZwczNsMjZ0dzk0U0dZK0xRck5qd1dlUEFpMHNLVitD?=
 =?utf-8?B?SnZJZUVLSGcvdzM3WWR2Q2Z2MWFQTy9iMzdkSXNndTNoRkR4d212YTlmOHA0?=
 =?utf-8?B?NllnZ0czUzl3eUxoamljNm1oRk5meGJHdlZOWHFWSXVMcGlYQlZLM0lvK25n?=
 =?utf-8?B?RC9tRFhlOWhXd3VQckR4dy82bSt6Skk5U3VFcXVYeW01azlsTUlMRGxTU1RF?=
 =?utf-8?B?Q0dkY3VVZXVWM29KOE5Bam5xOWY4dWt2RmVqQmg4VkZkeW01RXBTaWhMMTUr?=
 =?utf-8?B?TVViLzdQR1QvZ2dmUDZna0pNM1VLMDZlTlNPT1RvR29PakpHa1N0MzFXQUZp?=
 =?utf-8?B?QnpoZ3dwWUJ1ZUN4UkwyZ1BCUXg4cmVUSlU3RmFUd0pGeXR0YVZRM3Z3UnhI?=
 =?utf-8?B?bmtPMlFsRFp1dWZET01pL0psNmJ1L01NbmhxYTFsZWVoY296RXlQeUlJVis0?=
 =?utf-8?B?R0FCWnNXZzFnMklWV2Q3R1F0cGpPbmpLOFZqWXlaYTR1K2Jqck9Fa3BaWXNH?=
 =?utf-8?B?QWRMNkdJRVVScnJPRHl5bVNlanVaL0NWOW5YdVR1YlBYaEw3clRNNFN4b2pw?=
 =?utf-8?B?SGtibnZudC9xOHdkMjNSVG96TFArRFBtMTQ3RXQvR2VQMjRQSm0yZ0dmUzhq?=
 =?utf-8?B?S2dtSmN2RzNvMmdndnRTMlFtOUZWUy9GYkJKc1lZUmVZa0tLdkhkTy92UVE2?=
 =?utf-8?B?c0NKZ1dqbjY0UFF5WGtZMFF6bTFJSEVWZ0ZSZVdNc0tMem9rRGI0QlcwUit0?=
 =?utf-8?B?c0dLUVlKOGJ3NVlqZ2ZRRnhyL3JZbDkwZ1BHTGJjWUhVKzNJVHhHa0E2V25z?=
 =?utf-8?B?N3k1Vm8vai9kd01TYi9ENjNRWHV6QzJSa0NPS01EQnBWRWxhVEIzYWVxbzFu?=
 =?utf-8?B?c3lhMlNDVmJDd3BFUG5VOW40R1E5OWFaSmxOd3MrMW1tWGVSYmFKcVZVVHZH?=
 =?utf-8?B?NG9URXMzNkdzMmJtbVdhR0liMi9MNDltLzViaGdxOXNnK0lSd3B5M1IvV2dI?=
 =?utf-8?B?dzhMS1hMTTlCNFJ5dTY0bmF0N2dTSFVJbm9CZmthQUZuc3hydlBWWDRMSjZR?=
 =?utf-8?B?enl3OWhXU1RZbVMrVFNKaDBya1J6T3FhMm5MNHpoeEVjMDVBQkZ5cVB5ZGRq?=
 =?utf-8?B?RWlMT3U5L0JYTjd0TThGOHE0TE90dEhzMzJ6Tjh5THdUeE90dnhXQTBNTkJW?=
 =?utf-8?B?WEhqMHVWRThoWU43b21FOE8zMjJzQ21nL0RkTzlGYmZFc3RLNENOTEl6NkR4?=
 =?utf-8?B?M0cyMWJoR3JTRSswVWplQnVINE9ybGhIdDd6My9lODdxREx3MXRHanQyZTA5?=
 =?utf-8?B?UHhiY3h6ZHQ0UndLWjVpeXRtVmN6YVV6eUI4ZEtiL2xKeGZhVGh1eFZ2UGxL?=
 =?utf-8?B?bmF1ZzZtRGt4cDFnbDNMWStja1loeW8vSHNtRXgxMGhUNUVEU3hxeE5jV2wx?=
 =?utf-8?B?YUJPcXpNZHNKMXJnRzdNMkNJaWpsWHNFcTdpOVZ6TGZIK1lUaXpFSm1vc1NO?=
 =?utf-8?B?eDYxUWVrTmtkU2lPK0djN1hjckZLdmthZllOOUMxM05kZWpmMVlkTXJSYVBB?=
 =?utf-8?B?end2aDNtb25lRXBoZDFFZTA1blVoVTBYUHJmaUlaYjBkQzJsdjVYUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd843e8f-5e5c-46fb-983b-08de6ff879ad
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 20:50:11.8726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQssGCrcpxy8Z3F4mMBRNA1BtiShPwUi1qV9wY9QVIfLq9ck7t2Ua3LLvvOoLaexSfYAVAHh38YeunJtmorvAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4595
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71370-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sohil.mehta@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 64425162729
X-Rspamd-Action: no action

On 2/19/2026 12:22 PM, Dave Hansen wrote:
> On 2/19/26 11:27, Sohil Mehta wrote:
>> On 2/15/2026 9:16 PM, Nikunj A. Dadhania wrote:
>>> @@ -502,7 +517,7 @@ void cr4_init(void)
>>>  
>>>  	if (boot_cpu_has(X86_FEATURE_PCID))
>>>  		cr4 |= X86_CR4_PCIDE;
>>> -	if (static_branch_likely(&cr_pinning))
>>> +	if (cr_pinning_enabled())
>>>  		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
>>>  
>> Maybe I am missing something, but is there a reason to keep this check
>> anymore?
>>
>> AFAIU, cr_pinning_enabled() will always be false during cr4_init().
>> cr4_init() always happens during early bringup when the cpu is marked
>> offline.
> Yeah, that should be dead code now.
> 

With that change,

Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>

> It wouldn't hurt to say:
> 
> 	WARN_ON_ONCE(cr_pinning_enabled());
> 
> to kinda document that this code doesn't work with CR pinning.


