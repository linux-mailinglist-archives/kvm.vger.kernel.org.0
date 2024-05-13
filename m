Return-Path: <kvm+bounces-17358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BF38C49B4
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 00:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E7B22826ED
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E2684DF3;
	Mon, 13 May 2024 22:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S/VqtakY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADB22AF09;
	Mon, 13 May 2024 22:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715640283; cv=fail; b=faqH/3ULJZzgHMT+v8jHlU8QDttAHi3LphBD/nRp73Hogp7lThyPqy1NBrBNOYg90b3Gy0d7dj4nnF7ug1Byy7WH1AbNDlvxsVKI1Q1X+IvG9pdZAcjuDg+MSyRkjyS6IlVJp2uhcJgQUIzoNmSjXqaheTk8cYRkvq8Z2l6/vQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715640283; c=relaxed/simple;
	bh=TwciVqrvNU7T2QKZuHGVcV6WmY+l3K7NBX3gxwAR0RA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lpjYC0/0Tjg97UiAIp+sxXYouQYt7lcw3SVd92Gljarrm7Ehvk9Ic/RmonEIvcMePp+KzwHmp7dyMcW9I1E/+IEEstwBsXOZKk5WBygiuORGuNZ1EwP+xjPTmBDqLt676gibXG/4OmoZDsJ5HMxJetsz0+rop+S6pcLdrqqjDek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S/VqtakY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715640282; x=1747176282;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TwciVqrvNU7T2QKZuHGVcV6WmY+l3K7NBX3gxwAR0RA=;
  b=S/VqtakY7OvSlKeDvmevbv97DgISqpANjp4AdJIyPGEXHDXCecv6CRnU
   xy0snuoF/ZVtlqQnp/8d0Qu9ziInBbfScre9SSAgQXrTCE0QPUOCzVsbg
   MDIx1pefbMLbEjIBHtKfMhbo4KT69Gr3bcsbTXP0IDE6YETzyk5qq2LnX
   rl+dyS5n9yXbWcLisCSY9XuQ6nlFhNhwYbvvYiBmQroKEYqaGDc864zyf
   zJMnxmIHpg4CaG/23Fr95+QQsJCZHOsFr9v6zQZdCNo2MyyT12VQuzpW6
   3IHEHMvy0yQWC304gzoFKEr/qeM/37HVyt6itzQQTomZh6g5g7CUJkvBp
   w==;
X-CSE-ConnectionGUID: ukXFq96qTdaLrL5Vk04Cyw==
X-CSE-MsgGUID: iv0FuvjXSi+iDF5fGlLiIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="22197544"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="22197544"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 15:44:40 -0700
X-CSE-ConnectionGUID: 8pSAa7r3Rpapafqs9zhNaw==
X-CSE-MsgGUID: 3U9kN4QvRWSqdMr3CV7boQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35226011"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 15:44:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 15:44:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 15:44:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 15:44:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 15:44:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiVX+ix62vL/H/cHFLVEoLCGUof0XAV2yB21C5mgvpzzDdyiLDXUnt8YMet9Lnf/dtD5oc4l0lj06pgaoe9sqacCtAtzcy+HcJqHM4MEOePEJ6LzBiVoUTTVaMrHNnh2U8JMqg1Y+NyWrPusG6T/o3NEJMBQxDtZhacsCJAqVJ4CG23VecDAIlHITnMHJWxY8W/4PJz7xKAbzDcLf3WKgVlTlGC+3H4aN+Jtp+7+sG+UxFoBjh42CuDHvHjhpCUklUNRyt0LlfOb71jzyRI4IvUG2QzTG/3DpGIrPK8aEZAb/4pQDF+vhko1+ImGkiDpMlnRdzdc2ycy47FJRvn3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8T5jPm1gRKCBkaOZ61OamWEwgv9hSTE+xDzB16FscLw=;
 b=hte4dCy5rbbiwaHknkPNElJZZ7j49YdnnnzoEzGyr1UN9EM5JqUcFZ8D6lIu6nA3c++bl/eVX+2tdIaIYXcb/e5utL96QdUz/MXPNeBhVDstnYc8ejb9412TgimMi/zGPcksPgLW6K3TAzuLdBO1erusn2Zx47jrOJpPETVgC2XnJoI7IbqB438xhjsSAl3shnoZrSJKBYZ/xVe6xAkegmbRE8ERhkkvbLl5SBMWow2PaKUi3KatFc8XwjF9vhXMwCw5f2ASmXndNSZy/acN/OfDeXL3gjQNoiTWtlsLleW2XZm+RVxmZADFOYv8eZsVEAEV9mHjiekd4GPhf1l2uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7649.namprd11.prod.outlook.com (2603:10b6:8:146::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 22:44:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 22:44:36 +0000
Message-ID: <6100e822-378b-422e-8ff8-f41b19785eea@intel.com>
Date: Tue, 14 May 2024 10:44:29 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240425233951.3344485-1-seanjc@google.com>
 <20240425233951.3344485-2-seanjc@google.com>
 <5dfc9eb860a587d1864371874bbf267fa0aa7922.camel@intel.com>
 <ZkI5WApAR6iqCgil@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkI5WApAR6iqCgil@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:303:8c::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7649:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f475ee9-9550-4d5c-fcea-08dc739e4448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UjQ3MkEzMi9POWRuRjgyN0RUQ0crVWZVekRBOHJUci84NER4VEdxc0c3NVRx?=
 =?utf-8?B?MXdxaEh4Y0VJQ1RjaWJtalVYNEtFNStocm1FODBtbjZDWVBnUDhzRm9leHcy?=
 =?utf-8?B?eHYvYmhuT3ZyNUFNTmlWMTU4MkFoYmZ0N3hodnIxMjhjKyt3a2RVNTBwNWxT?=
 =?utf-8?B?ZWlBS3ZWZ3J3TEgrQnRJdG9ZaVJGbzN4aFNZRGEzaEFXOW9QWHdFR3RsQjB5?=
 =?utf-8?B?RFprRDRFQll6SHd0dVF3ZGNlbHVnZzBENVI4ekVTRzdEb3MzS0ZFZjRLb1Rw?=
 =?utf-8?B?d0JXN0xCdi8zQTlyekI2RFlVa004N1B3cFFzdEtPQU5vaXRSZUdIcWdWemw3?=
 =?utf-8?B?RDlWeURaTjN5SlNSaHdxT0xGamZHK2QvQTNHdUpvRUFZaUQ4dzFEQlAyZ05V?=
 =?utf-8?B?TUs2QVFXUEpnY2tlVDZaTmNyL3dtcmNJak5pWVMvVmhlRWk4bkdwMkYwZkhr?=
 =?utf-8?B?bGZyd045WWo5V1g2eG96Qlo5eDJLYllUT25IL0xtUjJ0aHhUdHpPZlp4Q2pS?=
 =?utf-8?B?NVN4d1ExUU44Z2hYeDI3aHJVQ3g5a1pwMHNtVXF2MFNOb0pqMnF5K0pOZWQ5?=
 =?utf-8?B?ZGZqSlhtUUhHNVEvRzNZMldhQmNSRlRKdk1Dd25Pa3I3M3lwV1lGbEtPLzYv?=
 =?utf-8?B?YTlSYTF2Nldpb21DWEtsQTFObEUxMW51R2ZHWFplNEtkempTTlBsUzhLcWZK?=
 =?utf-8?B?YlJma1ZiaVVYcXlZQm80cHBFTUIxSE1HZlloZEl4WHRkTHd3MjFITjRXY3VX?=
 =?utf-8?B?T1YwZDBQNVJnUXZ0UForQ2FsWUVZdkFLcENVM29PRWxyY3dkOXA0Q2ZEZHp2?=
 =?utf-8?B?RUVGMHlVeFZyb2NBZ1RvY0R3T2x2ZHVDU2YvcGFpUEhINVdFYWRHRGVkQ1R5?=
 =?utf-8?B?TE00bkE3WGlpdGxLeUhRaEUzd1RSbVpTT0ROSDlLbzc5MXFLcFEwN053dnRq?=
 =?utf-8?B?WTBlZUNBNUJsUDJBR1BSN3Fvb241b2pENWQ5T3gwcmpYTDFJREljWmRhYWdz?=
 =?utf-8?B?THRoZzNNaEtpVEdRVG10dXFWWWowbmJCUVF3TUlacmY3TkliS1c0NWhmL1lF?=
 =?utf-8?B?dGlDaTkyWlVPUjJ6cXRGcTh6TlRmdVlLR3NXejBuN2tsS2dESDVWUC9BdXVU?=
 =?utf-8?B?M3psbGkrU1B6YUlpQ2dBZllXSFlBZktIbHdUR1hkVU4rcTkvdm5COUczM0pv?=
 =?utf-8?B?UzVRbTlpMXhGQ0J5RmI0TkNDYUFFSzFxdElDNUNuTERiL2lFMlJxbGxZaDJR?=
 =?utf-8?B?NW55VXB5RVFidVUwRno5VkNFendsRks1K3dsNlZ2UFEwd3VYZGZBQUlkcHp6?=
 =?utf-8?B?bXlneGRSeGJlSVZGVFk4V2o5azJJd1VMOE5FSnlaTFF5UEhGUlRiVGxQeUlt?=
 =?utf-8?B?TThLeTUzcU9zQUpsL1o1a2pCZGh5aVZzNU04NUpyaXZ0dGROZHB0SG1WRGlF?=
 =?utf-8?B?OHBOa21aMGU1TEZtTkpzUXYwSkRWbXlIcmhJMk1qSjJEOURrYUQ1endIUk1Z?=
 =?utf-8?B?Q0MwYzVYOXV0VnNaTGpwWnFMOUN4RWRnOWlEbGFUeHg4RkJ3eUREb2M4SFBL?=
 =?utf-8?B?ZDFkcjZJNGxnaDRyM3RxeTNOMGdjUXFnVWpJNDVKM0tqeEN6Um1EU2V4ejdN?=
 =?utf-8?Q?lZCE8+RhYEW0caxq6Xr7vCXnUQRlr/ff0DLvo+GGPsTE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXFtaE83eUI1UmxZRjk5ZzJlWG4wK21CeXgwRU1rZXpVMEFCZjQrV0RrVndj?=
 =?utf-8?B?NEhwR0FpYW5FWmNkTGJtVVZlS2VWZXZyQ2Z0TUk2OGtMZmtTeDlHUEkzMHd3?=
 =?utf-8?B?czZwVjEwaHZIcFZ5U1hUUHBKRWJWbklRVVNWTHYwZEl5dGloYUNMQVVuWTJQ?=
 =?utf-8?B?THk4aEJzek1hL1JuV2V2aitlWlFUSmVZUWYzc0VqY1VhYjc0TitZN2Z0TTJi?=
 =?utf-8?B?NW1CKzc5SDRCaDVwQjlWMFEvTkpRVHBiWUhXc0RjMnVLZU51YTFGbWlLWkQ1?=
 =?utf-8?B?WW1YWTVHZ1BzUjE5dEw4M05EdlhmdzQ0ditrV3NsdVJ2WXJJazJ6ZEhFcjhC?=
 =?utf-8?B?L2tCREYydjlsdGpTa3RGcXhzRjE0ZW1nWHFOQXRPeUFLY0ZaY2hPd3VrT3Mv?=
 =?utf-8?B?VlVSMldPQzFxMzJ6emJFM3J6VWtiZDgxSmx0SjlpZTN2VVYveUVVcnptM2pL?=
 =?utf-8?B?R3pEZmJQeHpza3Q4RnJtU1luVFg3WE0yalJMU3dvUC9HYndpcWtmTU10cjBW?=
 =?utf-8?B?TWtwQWV1M1lkT2FxQU1GVU5ybDFxdlBOZ3JhdkdGRXl1K2FHZkRYakNERlRj?=
 =?utf-8?B?YW9Qa1NlT1h1RU9iaG4wQStKQzA3RkZWUFFQbkh0TEU4RkltbG9vd0UyWDVh?=
 =?utf-8?B?NXVrcm5Ra2ZINlVONk13bjVjOHVnWEU3Nzk4UVVxMkpoZW9mdzd3QjN1eDcz?=
 =?utf-8?B?OFJZSEVzQ0djajZvbUpLbk5TWXYzTmdnMEszRjdkc0lnbHgxbVpaaFFabGFL?=
 =?utf-8?B?TXpEY3J5MVJ4dnhRSUs4VUJJR1hEcklLcFRTK1B4eVFDN3phNnF4TFhwNmdG?=
 =?utf-8?B?RldPSGZYQlhMYXBBMHp6d1Ftdk9FekhoS0J0akswOVBDamtSUFV3TmFYZkNw?=
 =?utf-8?B?WEhoNWhnZXBRRWY5TWpyVDlha0JvbkJJN0xCOXVzMW1EUVN0eWQ4Y1l1cVZO?=
 =?utf-8?B?S01oaC9oUWdJaTQ3OExPbmIyVkd1RDA4ZkNtK2x2QVhMK0ZwVlhtRmgxcTd2?=
 =?utf-8?B?SEZGamVwN3AzM2R3eVJVejRaQnplSDcyeWVvNTVqVWUyelJ5Mjk2YnlSSk53?=
 =?utf-8?B?bXBmOE9OR1A1THh6OTdweGdaVk5XZUg2WHE2Zzl5SW9sTHVYaUFOaTM0Wmxa?=
 =?utf-8?B?U0hDVHJxOVkwMi9ESFNwcU1GQS9NWE9LcXc0T0hhRThOTTd0UlJ3d29tRURQ?=
 =?utf-8?B?NExtVXhMczYzdmEyQzlnRDJkV0loOVR5dmZnMTZrUm0rR1B6UkZwZFlUVjZ2?=
 =?utf-8?B?WmZEZmR0dU5PTUVEeTliandHZWlTTFBSYkxpOXhjeHVhcEVjZ0laQ3dycDdt?=
 =?utf-8?B?RTVQdDBmU2NqNnhNYlhlT3BvN2V6ZCs3dHROZnF2eHJzRkJuQ3VYL1pDMFRh?=
 =?utf-8?B?VHRXY2t5NzJ0STZTR1pxM3ZaU1Q2Tk9QaUx2anB3L3FWYUFlTTZ3Vm4vQjM3?=
 =?utf-8?B?cFhDSGw4aTNjMjVTYTZaVE53TUJ0OU04ZkNPL0tRSXhPdkRLM3hsVE1aYW5m?=
 =?utf-8?B?S0crbzA2UVBsVXppaU9pcVFac25IUzdBK0JSa2FTR0NiWnM0Zjg0dUtOQnRx?=
 =?utf-8?B?SUhZUjI3MjdPZmcrL0RFQlk0OWlNM2Z2TFRNVk1MRXJEVHNGbXZYRHJtYzNK?=
 =?utf-8?B?WkJHVFA0cUNOREZ5bGM5OXUwZFdpVG5wN2cwbFZLMDE4aWRHYmRoUHVFNXpC?=
 =?utf-8?B?RWw0anB2Mno4eWpQdHowbXpEYnk5UnVaMjFFQjM2d01jdHJHTVNlbXYwcmxy?=
 =?utf-8?B?dUtmZnBOTHRQYW1pd2hxQUszT0liaExOQThRZ2F3cTdtMmJHaVpKSFJrZ0Yx?=
 =?utf-8?B?cFRGeU1UWmpkQkZ5L1h5eCtDR1RPbzVJRG1SdHp0UmpWd1RpQmxicFd1eDhM?=
 =?utf-8?B?VDkwcmZNMm5jazFxVGNqYkZ0cFRUZWdMQ1l2YnJYOXlKaGNHU3lGblhWWnZQ?=
 =?utf-8?B?UU5MS1BiVnJKeE53OGlXTUJlOXpQeW1hMHJhdzVLcXBMa1NSRzlEellhUFdT?=
 =?utf-8?B?aHN6QmZ0aVJ6d0xjSkptaW1OdEM4MVVDOGQ4VFdtdHZYUmhQVklqSit1b0lk?=
 =?utf-8?B?VE5KTTNrcHc2cjcvQnI3QUdLaUtBOVd0VEVtaktmUFlSQ1daZzRZdzVISTNv?=
 =?utf-8?Q?h4pMLOb2Bf7k6vPAlTH6pN1b0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f475ee9-9550-4d5c-fcea-08dc739e4448
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 22:44:36.9022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gDy6iKKhf3hGIqkTeFI2T/R7N0zBSICLJ5aXqRZMFhLnN2/QIA4SgKqum+8Sjm/cBgI7ruGrtpvEgX7Bk1FH/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7649
X-OriginatorOrg: intel.com



On 14/05/2024 4:01 am, Sean Christopherson wrote:
> On Mon, May 13, 2024, Kai Huang wrote:
>> On Thu, 2024-04-25 at 16:39 -0700, Sean Christopherson wrote:
>>> Define cpu_emergency_virt_cb even if the kernel is being built without KVM
>>> support so that KVM can reference the typedef in asm/kvm_host.h without
>>> needing yet more #ifdefs.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>   arch/x86/include/asm/reboot.h | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
>>> index 6536873f8fc0..d0ef2a678d66 100644
>>> --- a/arch/x86/include/asm/reboot.h
>>> +++ b/arch/x86/include/asm/reboot.h
>>> @@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
>>>   #define MRR_BIOS	0
>>>   #define MRR_APM		1
>>>   
>>> -#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>>>   typedef void (cpu_emergency_virt_cb)(void);
>>> +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>>>   void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
>>>   void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
>>>   void cpu_emergency_disable_virtualization(void);
>>
>> It looks a little it weird.  If other file wants to include
>> <asm/kvm_host.h> (directly or via <linux/kvm_host.h>) unconditionally then
>> in general I think <asm/kvm_host.h> or <linux/kvm_host.h> should
>> have something like:
>>
>> 	#ifdef CONFIG_KVM
>>
>> 	void func(void);
>> 	...
>>
>> 	#else
>>
>> 	static inline void func(void) {}
>>
>> 	#endif
>>
>> But it seems neither <asm/kvm_host.h> nor <linux/kvm_host.h> has this
>> pattern.
>>
>> I tried to build with !CONFIG_KVM with patch 2 in this series, and I got
>> below error:
> 
> Well, yeah.
> 
>> In file included from ./include/linux/kvm_host.h:45,
>>                   from arch/x86/events/intel/core.c:17:
>> ./arch/x86/include/asm/kvm_host.h:1617:9: error: unknown type name
>> ‘cpu_emergency_virt_cb’
>>   1617 |         cpu_emergency_virt_cb *emergency_disable;
>>        |         ^~~~~~~~~~~~~~~~~~~~~
>>
>>
>> Looking at the code, it seems it is because intel_guest_get_msrs() needs
>> 'struct kvm_pmu' (e.g., it accesses the members of 'struct kvm_pmu').  But
>> it doesn't look the relevant code should be compiled when !CONFIG_KVM.
>>
>> So looks a better way is to explicitly use #ifdef CONFIG_KVM around the
>> relevant code in the arch/x86/events/intel/core.c?
> 
> Eh, there's no right or wrong way to handle code that is conditionally compiled.
> There are always tradeoffs and pros/cons, e.g. the number of #ifdefs, the amount
> of effective code validation for all configs, readability, etc.
> 
> E.g. if there is only one user of a function that conditionally exists, then
> having the caller handle the situation might be cleaner.  But if there are
> multiple callers, then providing a stub is usually preferable.

Yeah.

> 
> IMO, the real problem is that perf pokes into KVM _at all_.  Same for VFIO.
> The perf usage is especially egregious, as there is zero reason perf should need
> KVM internals[1].  VFIO requires a bit more effort, but I'm fairly confident that
> Jason's file-based approach[2] will yield clean, robust code that minimizes the
> number of #ifdefs required.
> 
> I'm planning/hoping to get back to that series in the next few weeks.  As for
> this small series, I prefer to unconditionally define the typedef, as it requires
> no additional #ifdefs, and there are no meaningful downsides to letting the
> typedef exist for all kernel builds.

Seems the final target is to remove those <linux/kvm_host.h> users, or I 
think a safe-once-for-all solution is to provide the stubs in 
<linux/kvm_host.h> with:

	#ifdef CONFIG_KVM
	...
	#else
	#endif

In either way, my concerns is it seems modifying the <asm/reboot.h> is a 
temporary workaround.  And when we reach the final solution I suppose we 
will need to revert it back to the current way?

If so, how about manually add a temporary typedef in <asm/kvm_host.h> 
for now?

	#ifndef CONFIG_KVM
	typedef void (cpu_emergency_virt_cb)(void);
	#endif

Yes it's ugly, but it's KVM self-contained, and can be removed when ready.

Anyway, just my 2 cents.




> 
> [1] https://lore.kernel.org/all/20230916003118.2540661-21-seanjc@google.com
> [2] https://lore.kernel.org/all/ZXkVSKULLivrMkBl@google.com
> 
>> And it seems vfio does it in vfio_main.c:
>>
>> 	#if IS_ENABLED(CONFIG_KVM)
>> 	#include <linux/kvm_host.h>
>> 	#endif
>>
>> 	#if IS_ENABLED(CONFIG_KVM)
>> 	void vfio_device_get_kvm_safe(struct vfio_device *device,
>> 			struct kvm *kvm)
>> 	{
>> 		...
>> 	}
>> 	...
>> 	#endif
>>
>>
>> The only remaining weird thing is 'struct kvm *kvm' is still used
>> unconditionally in vfio_main.c, but I think the reason it builds fine with
>> !CONFIG_KVM is because <linux/vfio.h> declares it explicitly:
>>
>> 	struct kvm;
>> 	struct iommufd_ctx;
>> 	...
>>
>> So it seems to me that this patch around 'cpu_emergency_virt_cb' is more
>> like a workaround of existing non-perfect <linux/kvm_host.h> and/or
>> <asm/kvm_host.h>?
> 

