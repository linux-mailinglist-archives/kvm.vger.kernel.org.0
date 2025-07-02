Return-Path: <kvm+bounces-51273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3169AAF0E8E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 10:57:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ED893B7645
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEDF23F409;
	Wed,  2 Jul 2025 08:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Au5fVGaN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4789238D32;
	Wed,  2 Jul 2025 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751446607; cv=fail; b=vCGISKE6VcO55xMrufcQmL8fEvCRdMw8MrpnSLgsCyUo7lzcMHLpGAset3C4mJyFMEe/ZxaGkpXqvfmgjeil1ai7QvGofE7dFzk6o5sH8wqJbX+3Gq5DBvO/ZQajcrAUOwN5GXkjl2d+1d52/RDLfyzdcqCxqAeqAb9PMGZq298=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751446607; c=relaxed/simple;
	bh=JchUFmHPO8cwI1DGMXo3MO0Me2g+tTCV0f10i13jffY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JrWACvHV1yZkSOtlLQea0U5sFC/f9VZvYRqGSLlxBbRYwERLgHZHDq9LPyeK1kqgZErIwGDElGl33QAXvQvGUYpoyaIJkXPEEq0qoyVimAz9wbDrimdJPxVQ0JLk1rKCxqUIs8xsJYhW7kWJ3RtTnlIcyjW342Addq1xsObQNjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Au5fVGaN; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751446606; x=1782982606;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=JchUFmHPO8cwI1DGMXo3MO0Me2g+tTCV0f10i13jffY=;
  b=Au5fVGaNUchjn1oYQbY1tXnTwSh79nCp3tgMPo1tNEpwEa6OLmwyChNd
   xljI5x0co3buFUKhyRnZ/uxWyOXR7xVAc3FOyKqlp83Ci7sukRRchS9/P
   2+G0c+iWr86wGEOdce+zgYVUldmxOCFcV3e9izdKDgmkO6+mSRiNA59Bs
   wUSMtOzcLXTs9ZXnEXRdhut4aRHEeGTJ0esdLQR0ODKflbyq2xL03DcP6
   Td8rrGdHEo6WmqP+7nwvyyWX7oQEFZCG3hKhBv0SRSfIeDHKHJnsu/qXg
   bgT4MHDsBKfuzYBt/kksx6RDpx4sVvPXgm7H1sTdaWNB+ytIveUxuXxTv
   w==;
X-CSE-ConnectionGUID: +YXDzRmrQw6A9hNWX/0v8A==
X-CSE-MsgGUID: uW/xu63hQTap5hYG0f2tew==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="65188688"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="65188688"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:56:45 -0700
X-CSE-ConnectionGUID: vB231ifmRW6+O4s8y8vrRg==
X-CSE-MsgGUID: sOfoFe1RR5COyIr1UUdJiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="159723363"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 01:56:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 01:56:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 01:56:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 01:56:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJRITBL8qJEKT3lShF+q4btyI99pgaE2KiQeaa9271a1r7a7h2nn4EFMlpwjL0NkudLt7NBduUI2uYfZ+d8UrdjNaWEN81aK0GmJjsgTp3FSt7idlkTB/Uki7OwsXVmnEtUXLMs6TIPuiRoOgxmFeydNZaRnIjoIi85FUuTA4wukXDJvAWfgHk1LfORzIexk7hlIAzrJ3R2wbQajf+V37wdz3O6g0Hmk5Je8hw/m08XFg5/gPFZvZVuuoinXFCz4KGm1X13W2rkGWNlHLCrXmxFV7jXhQjw3j1OP7oaFnMHpgUHvxspa+Oq1nm81qs4ri5jSDKziJ6wz960L99q5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRN/vlSg6hhlEOWleC4l9zrGlS3Weu4i4UJ1KvJUDYM=;
 b=CaAwgPMcvso1HUrTFZE3GtTbX5uGU4yxla+t+hp9tC6yiFIXjo11lE9mJ1JZPvb6BjF0kBeUxO7xRDzWeE5guePhjWyV3daB14TpOhajw761HgsKhhFAFiqvZKgC7pLctch9VlpgL3q8ReNcF+RC2Sz3WJZHixCTdx6F8y9jYtr0aet6tiiiId5RNR5mqMPfhqzj/3K/CyRE+necvKvp0qw/0RtVg4gN+f15ceCaD8hOEoJmD2gciTvOQy1qFjB9LPSnHECXNXANRN589K2+6nDGIBDqfM6osVBoRFSxV4DE0d5cFyg+LICgwInaZZjjNFra1+T1NYTTa2mo+ju7iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW6PR11MB8340.namprd11.prod.outlook.com (2603:10b6:303:23e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 08:56:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 08:56:41 +0000
Date: Wed, 2 Jul 2025 16:54:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGTzqyIYE4K+cR0M@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com>
 <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0004.APCP153.PROD.OUTLOOK.COM (2603:1096::14) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW6PR11MB8340:EE_
X-MS-Office365-Filtering-Correlation-Id: 8acda341-3b46-4d51-2a68-08ddb9465c8c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZkwwaldYSTVuMnpJa0VVa0RrLzV5R2hXVmZRVkxoMEhMSFQySGszVU5GL3ph?=
 =?utf-8?B?S0tPWVZ3RVQvYlVyWkpKbzZlSzREWHBJSVFCNmNydGppMjFua282eXk3Z0xy?=
 =?utf-8?B?N1ovU0xXbjJqK1N6UlNmb0FJa1lpTVBTUDNtVnIrRDJUNkhFYjI4bkFSSlhH?=
 =?utf-8?B?eStWaWNLTVZ0QTJKZWY1S2tKeHd6QmlRMlRla0FwVkw2cVVJQlZCOHcrRFN6?=
 =?utf-8?B?eDhZTGNzZ3FKQkFIRFdkWEJuYTZnUkNPUkRyZTlCUHI0UVE4M045Y3dRWDdQ?=
 =?utf-8?B?OE9JRjFoLzZZNE10TlA1aDhZU0xxazkyMnVjMjF5TDFaR3dLYlM1YU5mK0p1?=
 =?utf-8?B?VXQ2WnhnM0ExTEJwdG05V0VWRXZNbjFYS21VQUpVL3pua0VwNDFYcXhrdkVq?=
 =?utf-8?B?cFhRdVhrSHRKMFo0MDFWdlY3cGJUeTkxai9XT3lJbmM3cEtjRFZITEthU29N?=
 =?utf-8?B?N0VJQTVLZ1JKQWVSbEV2azVHOWloVW94OHNVNjBBZmtLTE9UMTRxc1VLNU9i?=
 =?utf-8?B?d2ZYVWc1QmpwZHRzZ1RLRkJRdmlCckI4c0pzSU00c2tFZlFoa0lSZ0hMdFdh?=
 =?utf-8?B?ejJITlF5U2pQVUx1TGZsVy92QllsY1lOZ1B2VkFyd3pMY09xSFR0Y0o0NVlO?=
 =?utf-8?B?U3lvTFpSeGNOUjBiaitudUFhemtDVzY1NFVudllvSjVlelR5ZUdwVTg1eVVJ?=
 =?utf-8?B?MW40dlFqSUkwQ0pHSDVYK2FqNWRzTW1NM0FOSjNIOUh6dUFxUFdYaVNUY01Q?=
 =?utf-8?B?bmczSm9VVCt2QXVMQWpLWjdOUU5GSDF6SVVKd3AwU1o2VjZ3WnBQc01DbVVh?=
 =?utf-8?B?aFFwOXEwejhPQWMwU0JkejhCMVZUTmpraUNqSFFmWVFCOHRjMDJ3WnFHQVJ1?=
 =?utf-8?B?U0l2VTRhRUZvSU9sZ3lMY1VRUUhYeU5hYUEzV0pWRzFmSEdnWUFpMEwzZUs3?=
 =?utf-8?B?dlFUdFM3SFZDYWRRdTI0cGp4ZjhVcm1SRFpnM05yWHVWOEh5NWxNV3dMZFI3?=
 =?utf-8?B?NlZJZFdTbGVkUWRLQjUwS25nMXhOZ1FLNmpWdk9vZm13OHhObDg2T1dWanBv?=
 =?utf-8?B?OGtkWnlQYUwyWHg1U2t5UjRBOThmYkxDSlB1TmVPbVJuWTJqODVUYzFBVFdk?=
 =?utf-8?B?WkdzR1Z0Nm9yQ0RNTERUOEJjbm4wc0pNeUF3SUVVcWJKQ0hCNkQzeFZpelcz?=
 =?utf-8?B?RW1mN05YVnVjYlNYbStxSjRUQjBFdDNnaG5mMjFRcUNMV0VqVGdLSkx5SkZs?=
 =?utf-8?B?TEtvTDUyWlhIYU1aNEEvQWJsb1hvb0lZeEVQOFEwNGVxMHpqTENOcVI3cDJN?=
 =?utf-8?B?M01XcnVRV3dLYnlsV2FBZ3R4WmdLd3hDVGlmMDQyWjFkc3dZcHVuU01WYThy?=
 =?utf-8?B?Sm1TelRLRi9UODR6NVhBdHAxaWxYOEhyK1VjVGZ5VjdGeER3QXVpM3VFVFpr?=
 =?utf-8?B?cXdWKzcvSGxNa0dCRC9sdExUN2ZLN3pHL2FMdnVENkR3bjl3dTJYTkV3N3NI?=
 =?utf-8?B?ZUNVcEt3aU81UGZjcjZLVzZjNFl0MzJOVUhZVzdaWmFxZTV1UUNSandTQzhC?=
 =?utf-8?B?ejhPT1N0djI2RlhEQ2FLTTd3djEvWG8wVC8zN2dTOHpEV0ZCSGZaSkRUSDI0?=
 =?utf-8?B?Z0Jlb1Vmb2ttQkNOUjhiM1pxV1FlcVBhajVpdC9NbTNLdG9oVFZSbUNvcUUx?=
 =?utf-8?B?L2NpdUtLREFiUHFuRXFsbGozYkZuN2VsMnBHWmxEdFRVTW5YOEhOT3l4VVV6?=
 =?utf-8?B?YWdJK2dueDZLeXZCMUYzWmIwWmdiV2YrZkNEYWxJQkczWGVzSlBVWE1GYzdI?=
 =?utf-8?B?TnhjeEZXWXhmN1FTRVdValB3SGphTkh6YjJDRmxBK2ZMTmZZOFoxR1hpc05p?=
 =?utf-8?B?ckk2UENaK1NUR3paOWloVUkrSkhUQk9vYjM1ZTRLVnJnb05CQTJ4Ym5QMG1L?=
 =?utf-8?Q?gRSmLB50J0pbVPUzQ6IpC0LeoF36uUgZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGpzVHRBSWpxWS9qRHlQd1hBWnZsOG5GVktWU05UaFhhRkVGdTd6NnNyT1U4?=
 =?utf-8?B?VGROK05vaGZqVUZjQmJKOU12NGdyV2N3WVJuWDNhZHJxSUZiTjNVMStSNnFV?=
 =?utf-8?B?bks5UElWclBwaEJRSUJGeE00QzVSalN5UHZleWl2S3paWVpsKzViUVJ2ZG80?=
 =?utf-8?B?UUR4bXZkRzNPaFVYT3BhQ0ZTSU1VL2N1RUxEMmQrVkFDU3pjSXI0bGFtbzhY?=
 =?utf-8?B?UTkwYkJTMyt0TFpMbzBEN0lITWM1Z0ZBUVdEcWJiajEwWGVVL1VYWU1kcE0r?=
 =?utf-8?B?MHN0UlR0OCtZdkl1Y1NTaE0zbjBWMmdZRXVydFJzZEdUQzBmUWRrRzVIYVRh?=
 =?utf-8?B?Z2R2dHFub1E4NCswWmlIQklNbnN6cGdsemVhSlZYY3pZaXBWekdET2VYVHFW?=
 =?utf-8?B?VHN4T0FWNmMzbVVqbjdDRXE2SXlheXNGVGJQcEV2dGhMRkw4MXhtRFlKWTBq?=
 =?utf-8?B?UktzYUczTVhsckQzR1VwUWhsbENBbGp5NWt3dGpVTGUwdEo3dWh0UGV2TXRz?=
 =?utf-8?B?eW1PMEhRbXBBTnJxWEpzQlVkaTRJWkRpR2U4cFNTT0llbG10d2lHdG9KQlVp?=
 =?utf-8?B?a2lWTUxaNlZLd1hCSHRqYnV0SHpNbkhXVTZYQzJKdktwUWgzaHRLQURPQnZ5?=
 =?utf-8?B?TWttalBWSEExOU11Z3BYbWZBYmEzVlUxL2QxSWw5Um10SzhHU2RwUTUzYnVB?=
 =?utf-8?B?WDY0QklyZERQRDU4ZkM1QWtaTWI0Yk1CQkxlaEFLN0RRQkRQYmk2OEV6Ym1m?=
 =?utf-8?B?cWRZM2hzSzh5dEtObUpJU1NwdVNUODZXeXAxdVFVNWJqSWJqQzYxcTV2YW9m?=
 =?utf-8?B?S0Uwank5Mm94MVl1cWhXN2RBcWRCRDVDVnAxU05WOHRIODJkUkwxWlFPc0dK?=
 =?utf-8?B?SVhOcXBjcXJNMWpyTkw1dDRkNEpIb2VzZGJzOUYxVVZKUm9CZGZPSk94OE5p?=
 =?utf-8?B?alBmdURCTCtyQ1NJWnp0TGlMeWprVk9OZDgxN3ZLU0dkQjlOMU9lWlVSVm1x?=
 =?utf-8?B?MUpRblZoS1Z3RzBETHBwUWdEd2Y4VytaNWlzQnJqZDlmM2psN1VoUjVveUk1?=
 =?utf-8?B?ZHNkQ1BNOFZUVzhuc1ZjVmYvck8rUWZuWWFtZkUyWHN1THo1TDJJVjlOQ09t?=
 =?utf-8?B?bEpaYVUxbWxNcWErV1lSVTVZTHVQK0lGMVJybURhWENwMDVPV1ZZUjN3VXh6?=
 =?utf-8?B?dUZqK1VxcTZ6WW0yUjlUNVo2QmhXZkRvNktzUi9IaHpSYzVxazNlRjJYL3Rj?=
 =?utf-8?B?RzM0OG44V3pkaDE2MDFEMXJKQW9RdWlZbGVHeWU3S1RVWlczZEFTaUdDbnFO?=
 =?utf-8?B?UzYvTlFQc0ZpOGJhNXVkdkliaE00MFZyUlZrSnlxVjhySXE4cGtLL0ZhcTNG?=
 =?utf-8?B?UW9hY0FZMzF0MmtIYTI2Y3JvdWcrYk1jZHhEMmxEK2xKcmJoTjM3UEpSaEZt?=
 =?utf-8?B?RUpUa3N1WjBObVBjcDhoWCtaMW9WbWJJcm5PRVJiZnpSdjhndjBhbTZkVnNC?=
 =?utf-8?B?MUMray9qQmFRWDlpV1pBbWpLNVlLaURDTUNiTCtOMnFrazV6S2trWWZlNFdX?=
 =?utf-8?B?WXZXR1B4Z3hKQmZiVHp2eFBWcFZxVmd4bk1yekhOYW5VcVpqYTFOVzZLVVMz?=
 =?utf-8?B?bWo3b0dkWXBiUU81ZFBZemZ2anh6L2U2WkppRnlyZHdrdUtNTzJOMHBJY2Jj?=
 =?utf-8?B?YmR3bjhTZ1FMWkJMZENHSnlwcmdTZ3Z2aHJkZ1V0UVJBdUhpMG9KQ2YvK2h1?=
 =?utf-8?B?dFI3bXBuc25TR1VsM2ZuWm1ibzJHL053V3dvcURiZ2hFTDFoc1pza3phdGF4?=
 =?utf-8?B?UDl3V0t3QTNveUIwQk4vKysyV2IyWXJjekRONGdkTlc1MEJ6VXovK1ltajJx?=
 =?utf-8?B?djM4eHVKYVpWQzlKNkY4cUVBSjZPeWlMQm8vRGxOcXg4VmpISStWZnRiNzVG?=
 =?utf-8?B?SW1JMVdiWmJxSjFlMUd1Y2ZULzhyUzBzZnNZOHMyMlJRMXB3N1VPWktwSVph?=
 =?utf-8?B?N0UvNzR5d0dFTG5tRGIzVXlGYXdCdWs0L1lzSHdQOVFBK3laaEk1L1ZCUTU3?=
 =?utf-8?B?MjRsZXNPa3hiMkZob0hLZFVMM3Rrd2lvY3BwYXk3eFJtSEt0UGNYTm54a253?=
 =?utf-8?Q?c9mlgXkBWjxq52H6eQiJr8lyU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acda341-3b46-4d51-2a68-08ddb9465c8c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 08:56:40.9665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYKGPsW1dox9hb9z4DEKzheUvhY6OCGMxGKUfPdIHIU6ew3Sl/PksDHKBbXZLgGocr5qX7m5trmCMMkQunb5/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8340
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 06:32:38AM -0700, Vishal Annapurve wrote:
> On Tue, Jul 1, 2025 at 2:38 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Jul 01, 2025 at 01:55:43AM +0800, Edgecombe, Rick P wrote:
> > > So for this we can do something similar. Have the arch/x86 side of TDX grow a
> > > new tdx_buggy_shutdown(). Have it do an all-cpu IPI to kick CPUs out of
> > > SEAMMODE, wbivnd, and set a "no more seamcalls" bool. Then any SEAMCALLs after
> > > that will return a TDX_BUGGY_SHUTDOWN error, or similar. All TDs in the system
> > > die. Zap/cleanup paths return success in the buggy shutdown case.
> > All TDs in the system die could be too severe for unmap errors due to KVM bugs.
> 
> At this point, I don't see a way to quantify how bad a KVM bug can get
> unless you have explicit ideas about the severity. We should work on
> minimizing KVM side bugs too and assuming it would be a rare
> occurrence I think it's ok to take this intrusive measure.
> 
> >
> > > Does it fit? Or, can you guys argue that the failures here are actually non-
> > > special cases that are worth more complex recovery? I remember we talked about
> > > IOMMU patterns that are similar, but it seems like the remaining cases under
> > > discussion are about TDX bugs.
> > I didn't mention TDX connect previously to avoid introducing unnecessary
> > complexity.
> >
> > For TDX connect, S-EPT is used for private mappings in IOMMU. Unmap could
> > therefore fail due to pages being pinned for DMA.
> 
> We are discussing this scenario already[1], where the host will not
> pin the pages used by secure DMA for the same reasons why we can't
> have KVM pin the guest_memfd pages mapped in SEPT. Is there some other
> kind of pinning you are referring to?
>
> If there is an ordering in which pages should be unmapped e.g. first
> in secure IOMMU and then KVM SEPT, then we can ensure the right
> ordering between invalidation callbacks from guest_memfd.
It's pinning from a different perspective.
Please check
https://lore.kernel.org/all/aGTvTbPHuXbvj59t@yzhao56-desk.sh.intel.com.

> [1] https://lore.kernel.org/lkml/CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com/#t
> 
> >
> > So, my thinking was that if that happens, KVM could set a special flag to folios
> > pinned for private DMA.
> >
> > Then guest_memfd could check the special flag before allowing private-to-shared
> > conversion, or punch hole.
> > guest_memfd could check this special flag and choose to poison or leak the
> > folio.
> >
> > Otherwise, if we choose tdx_buggy_shutdown() to "do an all-cpu IPI to kick CPUs
> > out of SEAMMODE, wbivnd, and set a "no more seamcalls" bool", DMAs may still
> > have access to the private pages mapped in S-EPT.
> 
> guest_memfd will have to ensure that pages are unmapped from secure
> IOMMU pagetables before allowing them to be used by the host.
> 
> If secure IOMMU pagetables unmapping fails, I would assume it fails in
> the similar category of rare "KVM/TDX module/IOMMUFD" bug and I think
> it makes sense to do the same tdx_buggy_shutdown() with such failures
> as well.
tdx_buggy_shutdown() should then
do an all-cpu IPI to kick CPU out of SEAMMODE, wbivnd, and set a "no more
seamcalls" bool" and informing IOMMUF/VFIO to stop devices.

BTW, is the "no more seamcall" set by KVM at the per-VM level?
If it's per-VM, other TDs could still entering SEAMMODE. So, potential
corruption is still possible.
Besides, with "no more seamcalls" upon unmapping failure of a GFN, how to
reclaim other pages which might succeed otherwise?

This approach seems very complex.

