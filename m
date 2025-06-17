Return-Path: <kvm+bounces-49693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E01CADC758
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 12:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C963A6E36
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 10:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB042C0322;
	Tue, 17 Jun 2025 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="joabD1Rt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1CC290098;
	Tue, 17 Jun 2025 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750154443; cv=fail; b=lunACTftLxZ5N9gm25g14KQcuT5dNYseXILida1GcfxEpoI4gHKa+8YxjF4HqUMsb7m95XPl7CsjeHlWiZnfgugPV1O6+kPNY7Xvp8Qg+OGtzOia+xDc4WrPB2jn7XVbpgg6oHQJwcbaDvi4FWJOucJNPT/tB+IT6leB+TO0Gkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750154443; c=relaxed/simple;
	bh=bdI7Y/vGE3BAfkkGy1ZwiMLlnC7Y1HIeRRGTsEh1Ios=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n58hLAd7cLYTUIvp52NvsZNr5IgN8mfOTfOY2sngG2pdch8VNfipr3UhjvadQUIdLM0twZ8Ti8Po4gV1py6sIKnvm6QqzuTolcbeEEfbD6gh0fczrhe9qFffSBzcptgEzrXfXcFRW+JHw8m0CM47walruJI1+KgXQRJIOhy02D4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=joabD1Rt; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750154442; x=1781690442;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=bdI7Y/vGE3BAfkkGy1ZwiMLlnC7Y1HIeRRGTsEh1Ios=;
  b=joabD1Rt1r0n8B2SmU2vIkCkYljhLrDoHAz9EZ0xGCQo3K+dt2HXciDk
   m8ODXESqw89y2dybDbK6/tdBSL6znMFY0+hWYxENXru+or/hzjwbTihHQ
   RKeEUUZRvQLu5yB+tCVVhqlPZ6qnEpF4yJQgpoWbnZ1N7MHj1LM1Wrozp
   h3xp3UHAlzZ1xbDCG8vJTKsY/0MSmi2lG1kl6GFiZBQw/8DGnFa44wOMV
   q+71rRRWp3MutNhlMN7ew/1pVzVoK1MdaHC/nEbKDP7t8lxhl3U3ucEAD
   9rT0nwPo0TlZSPkx1zPJsF1tZKbnwHNfuLJm44cMyuIHQZFlEE+I1fjAJ
   Q==;
X-CSE-ConnectionGUID: aWGNFi+qQjeVuuXM4xnfig==
X-CSE-MsgGUID: nHiPqhnsQZ+nPPLfQXyZXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="63738083"
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="63738083"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 03:00:41 -0700
X-CSE-ConnectionGUID: aE9UXXk7TKqcNESHb9C71A==
X-CSE-MsgGUID: 0IExx46zQGynDOGH9LKQsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="154031101"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 03:00:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 03:00:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 03:00:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 03:00:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rrJb2nEmxdpz0ZrjVnyB/1EGFLOI8y/wEA15F2RWwCJcoslVOt7GL9CMMd4pUuEe780+5Kt/WPXhgV4VQVtR1mKchHbhPjYTqfSLWCfTW/Z1eZjSPhuf6T2Oz2ONH0bzNevO1DnqN3EM0k0ufmPdT9F1wcHuUaDZ1xJKHFEDTKD9h9do4mTFBCUBfDHs2q6fLKS3h6WkUrsEGXU0EwFv3fP/oIu8xCimor1g23YW0eiYXZe9Lcvg9wGKqpkRALDsOl6s3MaecG1WBrqRQXLLsMmnLjOd4M4T1VefT9ZdZySK3ws6apXzA9RyjNogeBeqZj6DnyvmfCnKHmFJ5V72sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vl+3Tw2Za1Yo5RAkR/1HgAexMiEuzH5B2KGQ9u1SuFI=;
 b=LIFdQm9x3K5DXn2tNGDC+VTy6WIggo7tcO/kopkdqEY43pghrpYbNlg6bLyzim1RK2jpmc1+ugmGahSs6d/Ss5GG9JeEYo2s52K4cwyc5TQ/+xj1GDCwnazTgi+jMNNove8vE980f1ULrhuzjvz6s0PB36AVzEMMndqJsMakybzED5pMqGaAIFZVY07iIb0n62jtyssqjAx9eGRIywga6shqVTKvwt1jf7Ags45VmMJNIEtlX6haEpy4HA59w8OD2h98BCsJPG/+8EhPpq61oQe8M3Rx4pyiCI1hwbq72r0SGr1tNocwUrljHrdRr+qzC3SntGdCdery1E4lE3OYHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7424.namprd11.prod.outlook.com (2603:10b6:510:287::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.25; Tue, 17 Jun 2025 10:00:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 10:00:21 +0000
Date: Tue, 17 Jun 2025 17:57:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFE8H0J7w+JEnxSq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <CAGtprH_SKJ4hbQ4aSxxybcsD=eSQraP7a4AkQ3SKuMm2=Oyp+A@mail.gmail.com>
 <aFEQy4g4Y2Rod5GV@yzhao56-desk.sh.intel.com>
 <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7424:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e53ae5-9478-4cb8-7262-08ddad85c575
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cGJXYXhHTGRVbi9DeEJtNkRHTDFVSXpMTDV3bndiWTdXcnZWK0lRR2pYSlh1?=
 =?utf-8?B?dzBxV29pbG1KWUE5ekpSZ0dZVG80bFBUQXZ6b0lzNDJUZFlFMnUveWJVcUtP?=
 =?utf-8?B?TDlLM2F2dDNZbjl5V002OU00ZGZkUEdxYTNFajJyZmkvU3pjTjllNkRXLzZm?=
 =?utf-8?B?M3VRSm5qS2F5OEQ0Y25DbFE3MVRYMTBXUWx1SElwcm1QekRyMFVkazVOMjhL?=
 =?utf-8?B?ZU42Tm9PL2pjRzIrOXozck1ycU96anVhaWE0N056VkJHUUVaMnFVVnRqWmVk?=
 =?utf-8?B?ZFdtL05GRFdEUHhFT1ZNR1h2bzE2R1FrVG9CZUtFQXF2c0tiZGNka2ZNcTBw?=
 =?utf-8?B?M1F0MDF4SjFIL0V5TlAxcTdKUk5oRkdvTURocFJGbHY5Q04wSmpqUGZrWEpT?=
 =?utf-8?B?cGVhSU9WTTBMUW5QRi9LK2tYOWttVHZ0RlhiWDBjNm1XbUdUK1gzaFBENnkz?=
 =?utf-8?B?YXQzMjlxOFFoQTRUWkNKeWpzbWs0MDNhZFJLVlpPcUdmbk9tNERnRmhmZ1Fw?=
 =?utf-8?B?NURXRnlkV3ArTkZBdjBBY0JVcTliVzlUcFluTEFzekp6SWdJMlBlU2RsRCtL?=
 =?utf-8?B?ck9jTXdkU3JIMFBaWmVqQ0lnSXc1UDZUQk9uMmhkcmpCaEs1dHdkZFFCWUtr?=
 =?utf-8?B?VlpwWCtOdngyNXAwS21ZeG1iSEU4eXZKdUlyQ1NITWp0WXJWeUtvTG9nZCs1?=
 =?utf-8?B?VGRGeEVhK29mRWp6ZGdrdmtmNUZtVjE4SHp5YjBkUWhITFd1VWtiU1ZUNmdQ?=
 =?utf-8?B?RDBtelZ3bUgrVnB1MXYvZmo0a29NVjJFSWUrVkFHQXlqWVk2RzRiNTRidHRO?=
 =?utf-8?B?NUphVEREdmpISWM1aFVqZzBDUlUzSzJqdkxzVW1rTlVQSmR3Q1d4UmRSdnFZ?=
 =?utf-8?B?dE5YaVk5RHFNMUcxc1p3eVRZUlpickRnblNYbTFaS1E1bis0djlWMGd4NzJD?=
 =?utf-8?B?dGVQcy9VYm9sN0RXamVuVG40bHQxTG5EVXp4M1QzQ2R3aEY3eG4yRHNyT1Z3?=
 =?utf-8?B?aWZuNHhMZzRNSW90S0ljaVV1NXlUR0dWZnhDTW4yOUNrT0JZdERkcE9jY0RH?=
 =?utf-8?B?dlVubkdJaERjcVdCK3VzMVF0VmNsNWZhZ0hGb0JrNUtmUU15Uk5pK3hNV3l3?=
 =?utf-8?B?UTRyWVVuWDNjWnVja0FRNnRZUkRCTmVwVmhQV2I3TlhyUWNNUHQyekdzWGV4?=
 =?utf-8?B?ZEpiTXlhNWJPRDJhREcvUVY4Ym1BZmlUeERzZ0ZNNm8yNys4SzBGTjhVSjFS?=
 =?utf-8?B?R2dkekdFRmZPR0ZEOXFYRXBuWXNVbXBKNVkzRXp0a0xWcFRtTXZRaDRxMnB4?=
 =?utf-8?B?YjhKR2dnNmo3RFRneHJWSUQ3bm9uOVJhWFl2YlphZWFQQzdJSzZ4cW9obXZN?=
 =?utf-8?B?dU1mL3cydDk1dTgyckNnQ1k4TTRacERJd1ZYSDNtamNUb3BFTFZ0NG42ekNF?=
 =?utf-8?B?SUdtTG5yV1pXWjRTdjhTbUQxbDZZMmszSWZRNEExZWtCSkN4UllGbUJxeFRn?=
 =?utf-8?B?OWw2L2xITkFEcWJDT1FmNTJvRmxWaVZkajlCc2lCSVk2RTFqc3Jxa0Z2OVZL?=
 =?utf-8?B?ZDlOYjVhZjI4Z3hEdHk5cGhzczVUVFUwcmpiVWxwajlxOGNXN2hGOHNzNmR6?=
 =?utf-8?B?Q0xUSEZEa1FLVkh4SmFMYXI2M3dXZm9aNStFeFdMUEdadjFNQnRGZUxGeWJu?=
 =?utf-8?B?YlllMHoyQjdhV2JncXV3VUFlSGFoazVSTDlxalduYkJyUWFubnVpMWJTcE0v?=
 =?utf-8?B?cFd6MTZXaktuOFp2bW01TzVqVG1GeFgveDNCaVZhVVY4dzYwQXk5MzJtYTVX?=
 =?utf-8?B?bE1pYlNIb2g2Z1d2TjZSb3BObndJL2FMaW5mVmNBcHYyQVFUME9iM2I1YkdT?=
 =?utf-8?B?OTBzSlZkNE5PcEVSdm1vdk1CM2VMak5FZ3JHcTg5VjhBdnFTdzN3Yk92ODRT?=
 =?utf-8?Q?dlVE7QuKKdk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2FuVmwxODdDZmI2YnY5eDdTbmtmRVhTZGZHeVA5c0docFFYR0ZIYVlZSzVJ?=
 =?utf-8?B?cmVEV0lRNmw2Wjc4VFJ1MUFPcGp4ZFhVNlUyMERCMEhicFJROWZURGh0R0xx?=
 =?utf-8?B?dFE4S0c1NlN5aDlaSW1TKytib2kwNy9LYlFnN05qc2d2SE9oOWt5YTY1d1o0?=
 =?utf-8?B?QVR6NStMekxaV1VwV0tWMFRRSmJQVi82UVZ2U3FwdG9TREhZU1l2bmNEU3BO?=
 =?utf-8?B?S3hXYVR3cXIwUW5nZmdXMEhVdkdyL2xWbFNvQXd2SzNDWHVMcjdONzcyK0RT?=
 =?utf-8?B?MXA5SnVYaDUwRVhBUzJqQW1tM0NyZE9zMXRwNWJJaVZjcEUrbXIzTjhFMW9p?=
 =?utf-8?B?Vm45c2UvNkxOZEtzQTdkdFhyWFM1TWZTZlhoYXhlS0lPVkN4K04yNk85YnAx?=
 =?utf-8?B?Q1U0K1NZTlY1QW54ZmtTRTAyK1R0MGgyRGxrSVlGRnFMbVNCRHljekdyN2dL?=
 =?utf-8?B?THBIMGxEL09Jb0hPTnVoR1hpV2RZTXNOVFdaRlJQMFg0VmlJMkVyLzlDY3VQ?=
 =?utf-8?B?OGhneE1sMGpkdTUrS04zV241T0lYeXlPVE9KSndIc1VRNTNVNkVKdHNaU3Jy?=
 =?utf-8?B?YmZNeWg0Qkc1NTFRU0VSd0kxQ1NWOCtMVFBaeldKS1JlK09xOVhXNTBSaXZt?=
 =?utf-8?B?MXBvV3JrSWFPZEtEcjlVSUNGbENuYjIrZ0U2SG9ralEvZFpHcjd4bUFvZktT?=
 =?utf-8?B?cG9OMDR2T0VKcU1mSGF5RXl6WnhYTVdJV2FHVDBPZ0c3UWNwaGdiUGREVlU2?=
 =?utf-8?B?SmFDUm9KZndVS1MvOFhTZmdlZGw4S0d0SXJQb2xMMHFMWndvcEhONUx3cTc5?=
 =?utf-8?B?WFhYa0x4OGU3SUdQWXA4SnRYZVA1TjFpMDQ3Mis3VEo0NXVHd0xwSys2V0FL?=
 =?utf-8?B?M3F2WllQc3phcmZNbnJULzBGUHd1MFlNeGtYUzR0bEdzTURIa1Q5OEoxMkpL?=
 =?utf-8?B?WlFTdlhsM2g1VDJXQTZuRzcyOVFtWHZYY3VCSVFSTzBNR1IwNTZIZUpnRGdo?=
 =?utf-8?B?OFJ5aEFGZnlJb0hNM0J3TVMwQzFRYmVBUDFGWk9QRGlXL3RPV3krdkVvdmJG?=
 =?utf-8?B?VVVCMnB2T0IvNC9UdjZRMXJqUFBUVkh4WmhmM3dpVjFHdnNvTGdpNE5UdTdT?=
 =?utf-8?B?dGFDZXc0ZzRmVS96ZVFrNW50YzJkbENWTUE0OWhhWktVSDllcDh3ZC9pL0xO?=
 =?utf-8?B?enNONzVENlllTnRUT01sMmR0VnhEY1hNeUtBNGh5eXp1c29FZGh1dGQvT05N?=
 =?utf-8?B?ZitCdVVPbWkybVpQTlFaWHlXZWZIWkhBbFhjKys0OWVnbjJ1U1ZNQzRVZlZL?=
 =?utf-8?B?SkhndHJoajhXRTRDWEhiNGcrLzlzaGgycFlzcTJUamRXT2ovSzlHTy96WFgz?=
 =?utf-8?B?MlRmcThiOTFFdmF2SDZXMVlaQ2plL2VQWWdqVDNHdURBamtzVXhEbVF5RjN3?=
 =?utf-8?B?NHVJcUxDVE9uZmFFR2ZvUWJKd0tyRUMrcXBYc3FGNFZlVW9lbUhHUlRBUndK?=
 =?utf-8?B?Wmc2NkdpSDNkaGNWNlVTOVJIOUdWUVhGQ3l3ZzFFdWhjbFNRck5IN3ZmazJQ?=
 =?utf-8?B?Vm1PejllVDVBNDY1WHdzaldHTFE2QUFJbWNjbmkwRTRVR3lSeE5RN1lXaXRn?=
 =?utf-8?B?bzB6YlFOUlpXdDR1NTBlWkRvbnliQnNSN1daVTJEeWlidjNxaHNVQUxyRmhu?=
 =?utf-8?B?ZXJwb1diWEhtbzc5ZVZjRGJPb2E0b2lsNWFTWHlackd4SjhpRDlhM1IyWDQ0?=
 =?utf-8?B?Mlhzd2VFK1hzM0VnTlpwWUZBdnp1angvYWdNQ253OXAwSnFaZlMwQzZ4Sitx?=
 =?utf-8?B?bGxQOTd5Tm9rYWhvcnRQckNEcTUrcmFqZklmRzFzK2QxSUdtZmdINHplYkgw?=
 =?utf-8?B?MHlXczRvTEoxRHdlUkQ3Tk9Md0hVcWZOeDR6MGZJRkd4YXU2Tlo0a1dQcURG?=
 =?utf-8?B?bFRZWis5RTB3M1JEZjBERDdQdVhucFN6ZkE0YWZ0SlFSQ2JBVFZ5K3E1OWdC?=
 =?utf-8?B?eFVaelhtSmJra210ZVFwYXh4RXd6UlRYZ0MwRXdBeEdNK3FCVDhaOGFlUjUy?=
 =?utf-8?B?MjJMand2TlZJYndlWWtVbGlkbUpDazJPSHRMVzFrTllsVWorTmJIWno4a1ZK?=
 =?utf-8?Q?vhqCxUPsTMeClSxWEUBZFFtcG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e53ae5-9478-4cb8-7262-08ddad85c575
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 10:00:21.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3i8EABBiRzTrPF0Dq4QYOSMQTrmh+XLzShTur0HPgtmw1Ey89dJ3bpphKij7S01hPAByimimK9QyaVC18RqRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7424
X-OriginatorOrg: intel.com

On Tue, Jun 17, 2025 at 01:09:05AM -0700, Vishal Annapurve wrote:
> On Mon, Jun 16, 2025 at 11:55 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Mon, Jun 16, 2025 at 08:51:41PM -0700, Vishal Annapurve wrote:
> > > On Mon, Jun 16, 2025 at 3:02 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Wed, Jun 11, 2025 at 07:30:10AM -0700, Vishal Annapurve wrote:
> > > > > On Wed, Jun 4, 2025 at 7:45 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > We need to restore to the previous status (which includes the host page table)
> > > > > > if conversion can't be done.
> > > > > > That said, in my view, a better flow would be:
> > > > > >
> > > > > > 1. guest_memfd sends a pre-invalidation request to users (users here means the
> > > > > >    consumers in kernel of memory allocated from guest_memfd).
> > > > > >
> > > > > > 2. Users (A, B, ..., X) perform pre-checks to determine if invalidation can
> > > > > >    proceed. For example, in the case of TDX, this might involve memory
> > > > > >    allocation and page splitting.
> > > > > >
> > > > > > 3. Based on the pre-check results, guest_memfd either aborts the invalidation or
> > > > > >    proceeds by sending the actual invalidation request.
> > > > > >
> > > > > > 4. Users (A-X) perform the actual unmap operation, ensuring it cannot fail. For
> > > > > >    TDX, the unmap must succeed unless there are bugs in the KVM or TDX module.
> > > > > >    In such cases, TDX can callback guest_memfd to inform the poison-status of
> > > > > >    the page or elevate the page reference count.
> > > > >
> > > > > Few questions here:
> > > > > 1) It sounds like the failure to remove entries from SEPT could only
> > > > > be due to bugs in the KVM/TDX module,
> > > > Yes.
> > > >
> > > > > how reliable would it be to
> > > > > continue executing TDX VMs on the host once such bugs are hit?
> > > > The TDX VMs will be killed. However, the private pages are still mapped in the
> > > > SEPT (after the unmapping failure).
> > > > The teardown flow for TDX VM is:
> > > >
> > > > do_exit
> > > >   |->exit_files
> > > >      |->kvm_gmem_release ==> (1) Unmap guest pages
> > > >      |->release kvmfd
> > > >         |->kvm_destroy_vm  (2) Reclaiming resources
> > > >            |->kvm_arch_pre_destroy_vm  ==> Release hkid
> > > >            |->kvm_arch_destroy_vm  ==> Reclaim SEPT page table pages
> > > >
> > > > Without holding page reference after (1) fails, the guest pages may have been
> > > > re-assigned by the host OS while they are still still tracked in the TDX module.
> > >
> > > What happens to the pagetable memory holding the SEPT entry? Is that
> > > also supposed to be leaked?
> > It depends on if the reclaiming of the page table pages holding the SEPT entry
> > fails. If it is, it will be also leaked.
> > But the page to hold TDR is for sure to be leaked as the reclaiming of TDR page
> > will fail after (1) fails.
> >
> 
> Ok. Few questions that I would like to touch base briefly on:
> i) If (1) fails and then VM is marked as bugged, will the TDX module
> actually access that page in context of the same VM again?
In TDX module, the TD is marked as TD_TEARDOWN after step (2) when hkid is
released successfully.
Before that, TD is able to access the pages even if it is marked as buggy by KVM.

After TD is marked as TD_TEARDOWN, since (1) fails, the problematic guest
private pages are still tracked in the PAMT entries.
So, re-assignment the same PFN to other TDs will fail.

> ii) What all resources should remain unreclaimed if (1) fails?
>      * page backing SEPT entry
>      * page backing PAMT entry
>      * TDMR
>     If TDMR is the only one that fails to reclaim, will the TDX module
> actually access the physical memory ever after the VM is cleaned up?
> Otherwise, should all of these be made unreclaimable?
From my understanding, they are
- guest private pages
- TDR page
- PAMT entries for guest private pages and TDR page


> iii) Will it be safe for the host to use that memory by proper
> WBINVD/memory clearing sequence if TDX module/TD is not going to use
> that memory?
I'm not sure. But it should be impossible for host to re-assign the pages to
other TDs as long as PAMT entries are not updated.


> > > > > 2) Is it reliable to continue executing the host kernel and other
> > > > > normal VMs once such bugs are hit?
> > > > If with TDX holding the page ref count, the impact of unmapping failure of guest
> > > > pages is just to leak those pages.
> > > >
> > > > > 3) Can the memory be reclaimed reliably if the VM is marked as dead
> > > > > and cleaned up right away?
> > > > As in the above flow, TDX needs to hold the page reference on unmapping failure
> > > > until after reclaiming is successful. Well, reclaiming itself is possible to
> > > > fail either.
> > > >
> > > > So, below is my proposal. Showed in the simple POC code based on
> > > > https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2.
> > > >
> > > > Patch 1: TDX increases page ref count on unmap failure.
> > >
> > > This will not work as Ackerley pointed out earlier [1], it will be
> > > impossible to differentiate between transient refcounts on private
> > > pages and extra refcounts of private memory due to TDX unmap failure.
> > Hmm. why are there transient refcounts on private pages?
> > And why should we differentiate the two?
> 
> Sorry I quoted Ackerley's response wrongly. Here is the correct reference [1].
> 
> Speculative/transient refcounts came up a few times In the context of
> guest_memfd discussions, some examples include: pagetable walkers,
> page migration, speculative pagecache lookups, GUP-fast etc. David H
> can provide more context here as needed.
GUP-fast only walks page tables for shared memory?
Can other walkers get a private folio by walking shared mappings?

On those speculative/transient refcounts came up, can't the 
kvm_gmem_convert_should_proceed() wait in an interruptible way before returning
failure?

The wait will anyway happen after the conversion is started, i.e.,
in filemap_remove_folio_for_restructuring().
       while (!folio_ref_freeze(folio, filemap_refcount)) {
                /*
                 * At this point only filemap refcounts are expected, hence okay
                 * to spin until speculative refcounts go away.
                 */
                WARN_ONCE(1, "Spinning on folio=%p refcount=%d", folio, folio_ref_count(folio));
        }


BTW, I noticed that there's no filemap_invalidate_lock_shared() in
kvm_gmem_fault_shared() in 
https://lore.kernel.org/all/20250611133330.1514028-9-tabba@google.com/.

Do you know why?

> Effectively some core-mm features that are present today or might land
> in the future can cause folio refcounts to be grabbed for short
> durations without actual access to underlying physical memory. These
> scenarios are unlikely to happen for private memory but can't be
> discounted completely.
> 
> Another reason to avoid relying on refcounts is to not block usage of
> raw physical memory unmanaged by kernel (without page structs) to back
> guest private memory as we had discussed previously. This will help
> simplify merge/split operations during conversions and help usecases
> like guest memory persistence [2] and non-confidential VMs.
Ok.
Currently, "letting guest_memfd know exact ranges still being under use by the
TDX module due to unmapping failures" is good enough for TDX, though full
tracking of each GFN is even better.


> [1] https://lore.kernel.org/lkml/diqz7c2lr6wg.fsf@ackerleytng-ctop.c.googlers.com/
> [2] https://lore.kernel.org/lkml/20240805093245.889357-1-jgowans@amazon.com/
> 
> >
> >
> > > [1] https://lore.kernel.org/lkml/diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com/
> > >
> > > > Patch 2: Bail out private-to-shared conversion if splitting fails.
> > > > Patch 3: Make kvm_gmem_zap() return void.
> > > >
> > > > ...
> > > >         /*
> > > >
> > > >
> > > > If the above changes are agreeable, we could consider a more ambitious approach:
> > > > introducing an interface like:
> > > >
> > > > int guest_memfd_add_page_ref_count(gfn_t gfn, int nr);
> > > > int guest_memfd_dec_page_ref_count(gfn_t gfn, int nr);
> > >
> > > I don't see any reason to introduce full tracking of gfn mapping
> > > status in SEPTs just to handle very rare scenarios which KVM/TDX are
> > > taking utmost care to avoid.
> > >
> > > That being said, I see value in letting guest_memfd know exact ranges
> > > still being under use by the TDX module due to unmapping failures.
> > > guest_memfd can take the right action instead of relying on refcounts.
> > >
> > > Does KVM continue unmapping the full range even after TDX SEPT
> > > management fails to unmap a subrange?
> > Yes, if there's no bug in KVM, it will continue unmapping the full ranges.

