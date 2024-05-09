Return-Path: <kvm+bounces-17138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2387B8C1992
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 00:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44C161C21795
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 22:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40CA712D745;
	Thu,  9 May 2024 22:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cI2mAntJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0EA770E0;
	Thu,  9 May 2024 22:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715294872; cv=fail; b=r6v0DQsV210EKYDoDqge+nC5VQ+mc+l7wtPLY4ULUsFT4J9m7KzX0xG2sxNp43M9VnqXHOiF9xwIH405HQCH/maIFy3Nutnuxc6DbW47P+WnRyKLXIVGPkMRk/lm/ytX79hNCIYV2sSIwpAizLSYNfesyoFaFgSrSNRZDdOQZBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715294872; c=relaxed/simple;
	bh=zpyqxGlmASClQmwzZHF22mZP234o2RLd+elfyhD2Tvk=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pJPXorEWYNgnB0z0shR5xLMBE6JR6L603Mrj1p6TvVYIhNRUsaUi4N4Mt+QTe2mylrV6orplUrSNlrbNW5BeMObJJWUehRESRi9oElN2nGr13s4hOghk7AfHfhzE1OybN/EuXWcFoUaeUeFPksgCGmvZJZJJjH9KCC7EO0Yxkss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cI2mAntJ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715294871; x=1746830871;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zpyqxGlmASClQmwzZHF22mZP234o2RLd+elfyhD2Tvk=;
  b=cI2mAntJumnT7JhikiFlD+54uV7MadW3AQCbqdxXn487prHH4waXH5Zd
   7BY3Jl8NtqeUYrS6CoILdMLou6jq1vc2Om/v9X5DwsqyRs0R3ljdiJjy5
   Y6LuoKJ0XRIamtCwC7r6EbQCLz7wkToI3JIDb4cT18CJc7C3P+zvyjn+I
   NILm2rq1AdEzTFqwzPL2gx0+Sm0cP4i4/ulNVoMmc1lByB2cvhwy+N3X1
   9W8vZx4C71l6KEH/i1lfoL4jD1Ve9HCwreRvtKia5Y9aS050SEmjyZ/A4
   /fQvElXxlhZRvkzVxfYtq4xPsmBaQeKkBJm95P+r4oNiUYZ7K0Gow8Zpg
   Q==;
X-CSE-ConnectionGUID: yVp9woUSRMqEKc8aIszMaQ==
X-CSE-MsgGUID: 5TLl4EaqRfmLy5z025CELQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11417950"
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="11417950"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 15:47:50 -0700
X-CSE-ConnectionGUID: sJcKuDyvStGm58ZD97agVg==
X-CSE-MsgGUID: 0w5akJCgRP+ohDx/kJdzCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="34071332"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 May 2024 15:47:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 15:47:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 9 May 2024 15:47:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 15:47:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtgRk96Rt1THCE/j4Mmx6AoZY1LtDP39vKbaWUnD70zW+lFXDNeX5ECw6i6HC3JRrSlNHojvq6u3hzA6+0LwGED6Mgvs6tz5cojvkFDyPaiV3b+3luQQMwPaqohT2kP/784OPPItfmcxhZaIvOUsEpvKkEqrcAKRhvkfhRYgXtx2k9jXFgN54ppjFTmLNvIW9g2g9VWdOfH6lyUZ0MkP7DC+oglmqlVya1pe88gNDeXnV1u2MblfFld+ABApFNv2up9/NvX822V7sfFoho3P5rvxnUTQ231YcD/KtY97ztVFb4rMNlI0zjS2BSZJxRXcoFIrnCe6EHVNyUZ14UE+fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHa8BF4s2pXzRaD52utjRbOX4TaskYd/0DJydczEhJI=;
 b=Rhcq4ajUb4E5/w26j5W01F0J7gqRNkDrL5rysH8NBqIabm3Nq3Nhb9bhjehZjKoiuDFFCUO7YBdLmcDFv4zsb9ScDGtIKWRZG9SQD1E3GVoOdBaoPelAN0//cDfL2KtsdsMUVfjbgNn0TjMW9ooUcclNwEqNbhSCWL1enl9Et7G4vQdLG6wn3vAwoq2F7vxtICevu+B3x1kbSJE+LzM0Gdvcx8vYmqe++4sRJJw4xilEa/4sDxcPmL4aDVnAI/qSoTbl6g9iGYK2M95DMvqqffq2mdJAD88kVgttL6VPm2TYiz5i8ORVpq6ezStZq4d2CK/j/Fdzr9ljBqxgu5TvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4667.namprd11.prod.outlook.com (2603:10b6:303:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Thu, 9 May
 2024 22:47:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.048; Thu, 9 May 2024
 22:47:46 +0000
Message-ID: <473ccee3-81dd-4abf-829c-a0ce71c2ff7e@intel.com>
Date: Fri, 10 May 2024 10:47:37 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
From: "Huang, Kai" <kai.huang@intel.com>
To: Sean Christopherson <seanjc@google.com>, <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com>
 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
Content-Language: en-US
In-Reply-To: <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:303:8c::20) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW3PR11MB4667:EE_
X-MS-Office365-Filtering-Correlation-Id: f34bacd1-135c-4baf-f2f7-08dc707a0ba4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bEU2Tnh3S3JITHpoZHBMa1o4dDAzVVMzbGRKRmRsRGZIcnpUYXF5dVdYazlL?=
 =?utf-8?B?ZUhIaDkvZkgzeTR1dGJ0OTJPOVQxR2l2VDB0L1RpYWdmU2Q0M3VuRGhoUVJH?=
 =?utf-8?B?U1U3VmVpZ1NWV2dTdW81Q2JmRzU0bnZ3OTZXSXozZWViYkVOTmNCZWxGUlhO?=
 =?utf-8?B?bGVZTnRlRkcwOWdGNEZpVkVianRoUFZmVlFlbVhhSDh4alI3cngzM081akVX?=
 =?utf-8?B?ZEozTWZyUVROb3dTWE9wNFZaQkdKWVJiemIyanlzZDlwSkkvQTliZCs4b2lI?=
 =?utf-8?B?blBBWndDY3ZIeFRsekU3eWY0bmY3N1ltUzY3UzRuLzhMMldOUjdrbnNMKzJJ?=
 =?utf-8?B?MkVuRUFIMUFLYzdBWXhxYXNBSGk0SzYxUk1QcGo3UlRzcGhJZFVvUlFnRjhH?=
 =?utf-8?B?ODJQTi93SkdGb0pVYkZ6WFJ6RFpjWXp2WXdlRVo3QkNrQURVdlpoY0VkYkJV?=
 =?utf-8?B?OWRXVFVkTlNvWmlHTlhmQ0RIam4vV0NpZ0ZjM3hyTEFhSVNqS2JubmFITkpL?=
 =?utf-8?B?TjJTV1lIbG0zTUo0MkxSNEJueTR5QjM2RTQ3NzRvVzBOUmU5aXVzeCtMTGsz?=
 =?utf-8?B?Q1VCcm1hQTFtWWpNR3hMUUJyUFBaMzdranNIRGFJL3BoY2FKTnNBdVdka1dU?=
 =?utf-8?B?bjg2NWV2SkhvQXRXSmRWQTJ1YXFzV1diVlBGR2ZrYjhXdUFzTDVLWUUweU8y?=
 =?utf-8?B?OWJzejBkS3orQjFlWEVKd1V6K1N5UDVuZjdJN0J3STQ4UkUyQ2oxTHk1RURO?=
 =?utf-8?B?RERBZzJlUVZHdVJBVm0vbFFHSCtCd2pWWnU0RmlTQzE0ZVg3ODRLZWxYSHAx?=
 =?utf-8?B?aHorM2QzaUQvVFhpMjNKQVgrbzZyb2drNHJKYzRqazRJQTlVRDkzMFB1bDZa?=
 =?utf-8?B?azNEV204dnFLUmJFUlJnV1FhY2JubmdITUxLUTdyMFlIemZsa0NXNWlVNVBM?=
 =?utf-8?B?SjE4S2VsMkR3LzE1RDZvK2FpZkI2dHhrWDBiQlhEWTQvSlZqRkFyYWg4M3hX?=
 =?utf-8?B?VStYR2tiMHZGaDE1VC9mQzRaUUdnYVZZM3VSaWRzaG1qM2phNUxqWXoyOGpq?=
 =?utf-8?B?dURvODJhZFFQS201NWU3RUZpaHBQbWlEMHl1elUxaGMxRDdmNTV2YlF1eklx?=
 =?utf-8?B?cGdBR1RxTCtSVnhOSXRvM2pqdWlmeXhSZmVGd25rL3psZ1grNTltbkwyQkw2?=
 =?utf-8?B?WENmRDhHODNBOGgvcVRTR3FXNXQwQndBQWk0MlNSM1lBakdLaG13RGw5UG84?=
 =?utf-8?B?YnhIYlhjREVXT29QeWxlejRURGdyMmFNNHZrZVdkUCtPeUhHeVBDanJJdjd4?=
 =?utf-8?B?NVFZTzVWUmZRQ1h6c1l3bGdiaTlVR0YxS1o2VTYzRUN6QUgrVmNlZzQyZjBZ?=
 =?utf-8?B?YnFOYmJMQ1Q4V2JBSmd6eDhJRjZFZ09aYW9jU05uenRKR2ZMc1ZvVE40dG1V?=
 =?utf-8?B?SnBNb3NoYXhJM0Rra3FnQytHNzBLM0xvVmdqNE9pYmdBTTBkejJoNGd3NHNC?=
 =?utf-8?B?VDNQVDhWS3hXeU1KbEEzNkwyQUE0dzR0bStWTUJadll6dnhLSFZsV0pmemxt?=
 =?utf-8?B?RXFpZzlFLzkrTXg3NDBaa3dWSUw0QVFxam5PcS9QeGhYdEN1SjVDSmp0MUdz?=
 =?utf-8?B?bk1mdXNOZzN4eUhvcjNqUzFoVUNBeDFYbGRpNEFhN2tHVFMvQUc0U2R0NWpT?=
 =?utf-8?B?VVpQbmM3MVpzc1BCaUt5OXlsblorMnkyMmNBWEhubTdYQ3ZPMXdLcmNRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1veXBHc0lJVCtIQVJDdDlSOTJqdlR5ZGlEdnRweTI4RWdyamRvQ3FIN01Y?=
 =?utf-8?B?L1JvdytyNEhkV0lQNEFqdFFlMzA1TGVEeVdaeFM5ZHRDMnU4UjYvSUtPVzBP?=
 =?utf-8?B?eHZCUm1QWmN5SzR3TkpHWkRZT3VQOVUwWFM3WVhRaldBaHFIbzRPYlNlWW1H?=
 =?utf-8?B?MVdwaTlwSWEvblB5Vm9rUWZGM1JZOU9XQWxEdU9scWRWNXVtaUFxU3FJTFVp?=
 =?utf-8?B?Z1NzdDFoM1ZML05lUE91NDY1c0RPRWhOWTFnYW10aDA0VlI3S0VJc21kUk1X?=
 =?utf-8?B?Rmp5ZlA0TDI4VlZteG9mcjF4NC8zMk5HdDUzS2thUlFhWjJGSHlSb1lSaXRQ?=
 =?utf-8?B?Q0wzUy9Sck1nUFAzTEcvYUtDZlJkdnF1dzBBMFhxanFTd3pVVU1jSnhETzVJ?=
 =?utf-8?B?YWtaMTNxS1FzSC9ZRmNBQ25scTFGbUxLNXJSeC9LSEhpY2tReWQwcHZGVE9B?=
 =?utf-8?B?Sm5UV3Azcm4zTHpnSVQvMmRZZnR0cUdDU2Q0ZjZBczYvNUFjOEcvUEtJY1Zq?=
 =?utf-8?B?REZ0ejhvTml1ZjFlbGNUZEY3NFpKblBuRnU5RWNnZk5SbzlUeWN4blZXTWla?=
 =?utf-8?B?SURTVUIrSjZqNkVoZFM4eUZ1VTJvNGlNQkNxUFJ2RkxtOTBzVmljTVpRbjRK?=
 =?utf-8?B?bHJ6Mk9EU2dWYmFmR1huYk81MENaNjhBbEhmNDgzSmZDWDEvMU04VWNqWjVN?=
 =?utf-8?B?a1dSMTlFVE0reTYzVG9UKzBkSG1ocjNMUUxIelJKY0xDcVB2SzFDc3ZBQ1ht?=
 =?utf-8?B?eUp4c25mYkZGZVNTN09aUytrWElUOVNKSmRGVkRwbFJkd2hXYlpNLzkxbzMw?=
 =?utf-8?B?MU15czN0TG9FUXd6dWdGOXNsSTBFV3dhZDRnd28xc3RyUm9yOFpkSzhKM1hS?=
 =?utf-8?B?SnNtd1p1M2JUS3N5ZUhmZm1jeGI0WVR6V3RhdFRsVTdiaHNkb3grcjZOSm5r?=
 =?utf-8?B?dGlwazdnTjZxdDFaNlVzTkxSektzcDJOeElPMXBZeDAzVTdBdlhlOWxKRExS?=
 =?utf-8?B?WllXRi9haEJrZGZMRTFheUpoRHp5eDl5MDZud3J0RjdGVVNuSVY4N1VyUVVi?=
 =?utf-8?B?QlQyTUUxYjVCUWlQTzQ3N2cxYkJGUWhiZ3BaSVdkNUcxN1ZsaWVaaE5EdmlG?=
 =?utf-8?B?TER5TWxaNnFoUXdKTC9RMWNsVlhsVEV2aGpmcWR4Y2hZTTM1aGJmNkltbHlm?=
 =?utf-8?B?WnR1dXZWQml0VS9LWXRpYzJUdHJHSnJlR013K01IQnFTTWhNaHJyYWpvOEEy?=
 =?utf-8?B?eEN6QlkxMm43ZWs2cWJCSlFGZndJUFZJTWtzTzI5ZVcyZUt3NTlkbXpHR09P?=
 =?utf-8?B?bmc1SHR6SkRQRTc0YUk5Ullmd2FySXBBczQ2YkNkWkVJWTIvMUFhWWF0UkVJ?=
 =?utf-8?B?NFJ5R2tVcHVuZ09ESVl4aXVoZ29vblRGWUh5Y0RMRE1jTC96V0ZGbFU1SmRw?=
 =?utf-8?B?TzdUcGV3ZTkyOXNINjlrT2JXU29Ob2JvcExLZXNockxuOXlDT1Y5VlpVMk1O?=
 =?utf-8?B?N3Z1VjRCaTE2UVF3cmFsMVZJTFJTcWdMTkxqQjA2MTZSSms5QytVbmFPTFFq?=
 =?utf-8?B?R3JlVWpTS3NXeC85eEl1bklFeVZ3Rkpqd0JvcmFUanhnTTg1M2xMY2I3VEtL?=
 =?utf-8?B?bDlDRnZVMG12N0pwaWp0b3VpZEMrcGNrN09YalV5b0NxeTBMbkgwWnBmWWp3?=
 =?utf-8?B?TXdNWXEvMUZhRFROdmc2aFNMN25WQWw1NXlVZS9DMFZjbXVETHp6bHBVWUtG?=
 =?utf-8?B?OGdFUEU4ckc5bU5XM01uUGk3ZzR1ZVg0N2JOZFNId3FOY2FmamdpLzdOWnEz?=
 =?utf-8?B?c0paMzh4UGY4Mk85cGpxTFpTNmtYY1RnaDBpZjE4WE12azVCQzBuQlZzcm5N?=
 =?utf-8?B?Tlp0MTNmT1V5V1N2NjlvQUFTQkVRN0QyQzVocW5sTWVUbG1WVS9MRzFQUzBY?=
 =?utf-8?B?VmtJb3cxaGRUdU5ObklXcWFhUHdTN1dPZThzV0JaOG04Q0d1WUZSeWNIZ203?=
 =?utf-8?B?Y0Y1TnMybXRTenB1SFVRcjFoY29PQk9YTnRHd3VwcVV5VGJqVktMK3lScVBQ?=
 =?utf-8?B?VVF0OWJkUnN0WFh0VlJnMmQ5UktZYmJNZDRkME9XYWFYYnRUWGh1QnJjTmRa?=
 =?utf-8?Q?5e4Ad4MJBExPmNhNA3aDj5Szi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f34bacd1-135c-4baf-f2f7-08dc707a0ba4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 22:47:46.5256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhZN46WckB25CRQLIWIeVpgqQGqMhMq+YoEaVTCCsuw/0C+W2Q+LM+IcXeF38uV8Y8Vqb1rkAmxpZ9H/qRUAkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4667
X-OriginatorOrg: intel.com


> 
> Implement the callback for TDX guest to check whether the maximum vCPUs
> passed from usrspace can be supported by TDX, and if it can, override
> Accordingly, in the KVM_CHECK_EXTENSION IOCTL(), change to return the
> 'struct kvm::max_vcpus' for a given VM for the KVM_CAP_MAX_VCPUS.

Sorry some error during copy/paste.  The above should be:

Implement the callback for TDX guest to check whether the maximum vCPUs
passed from usrspace can be supported by TDX, and if it can, override
the 'struct kvm::max_vcpus'.  Leave VMX guests and all AMD guests
unsupported to avoid any side-effect for those VMs.

Accordingly, in the KVM_CHECK_EXTENSION IOCTL(), change to return the
'struct kvm::max_vcpus' for a given VM for the KVM_CAP_MAX_VCPUS.



