Return-Path: <kvm+bounces-46010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CF6AB08D7
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 05:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4053552040F
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 03:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5E4239E7F;
	Fri,  9 May 2025 03:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bD6ITjB8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C50664A8F;
	Fri,  9 May 2025 03:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746760965; cv=fail; b=TbExfN76cKAaJF9appNErTa2RpX2K9czHsriuxYp0xs6xe82qXQtAmjvPZK0ZGT1KfVU3T+V+w/NtfKg1WNleFiZlZy2ULpMuks1dhFsyHivdlp9z7HRcnScXKhfqfAwkymKpPcAaim9GFpMtGeZ1wWJ4sk5znQ2Z0X/zAn9YxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746760965; c=relaxed/simple;
	bh=ORguD2cI/IZk5g5jVZG/W2zixD/3gF+KCie2FcBGlrk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EQNvQFuL3u5YA6MkTgI0LporLcqDPcv9gm7NZmqXtGsQqYm5zdSgs5/kmxnbyeRz0XizQBSxHTls4at0QXR5oK2L0X65Dbh8m9Gutx99N4QZLN++/fKw+UfceUQXQE93KRGMc6s/4MaXeVEoTQc9t4cNCLw23P+/y9c4djz3bTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bD6ITjB8; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746760962; x=1778296962;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ORguD2cI/IZk5g5jVZG/W2zixD/3gF+KCie2FcBGlrk=;
  b=bD6ITjB819DR2+y2h7FiNog2MXQ0rShrEuOtP6YQtqRqwqDvm7qXNws7
   BrM2TFQSb2OvJEmee5XZRNZmmXxPCf0MYAeEkGrevK15R/X/GTuCG1f+w
   WkZurTkeXmP/SkvLLSFlhMA93TQWcKweb+lwXrPTcklOziTjHoXDfucGe
   cl4p+YDTtjVnt2fPRdOaIG1tfMsmkH8loJUC0gjpOLKLUfOCTwcFx6mEL
   q+oSuH41KQ/92ZIA3zCmsVZWhhmHs2ofa9aC7+/yDp/RdRR3zM+a7WhEa
   PvU3lgx+ubG0nokWQ7qoSzqpktsljtjWSclRIJ/oBWanCHaVEbkTot9Y0
   Q==;
X-CSE-ConnectionGUID: PoKsFYY/T7qhOVKrTnj6yA==
X-CSE-MsgGUID: 5H9vYj6dQeamFOxpUGsefQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48653919"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48653919"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 20:22:42 -0700
X-CSE-ConnectionGUID: mynk79U4SHSkSs54RCdK2A==
X-CSE-MsgGUID: VhDz5TCQQb2ab2aeUMwPdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="137419257"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 20:22:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 20:22:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 20:22:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 20:22:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JAEmoZir+UyrXw5Dp1Ij7rNx4lbJUlskwlZeQK5FAzptBg2oVGn9X4YAn8Drm/1ZtSyrX+syRzc5eM8ZLPZ4rcR6AkHTW0tPJlpNkdJD+ChCF/toqM5XjMsm6xVOMqxrBUVNT4QElAQqDyNBcBL/w9hX7C7j6zMfQ01A76WlG776drVYW+73EmMmWgIUPgRFvjc91z+1ZhOu4PPahnxPSWAJ2huJ2bnKdWyXnu+KDJ2ov7HW89QwqmLjYlfSCZTkzeHdxmMzc3nxaJOr22RCw9/teQpBr/r51lLJ0OAlMCbiOMLNOnLt/gPp4Gt2iNdVxxSkCzrY8z3/gfK4DjaxUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3AmXAe4UNWM5W7hpghTqlRWphDBJikVglKttBoFynXc=;
 b=nfCOVRLXPFCfLH+dTWNOBRRrDB0VrPiWCmC+vryRWk42bdKPGkuBUCskIiHAykHyaX+nyKtS8eNcrKdQv4xw7Tt7T9MQeVCC6sDcPOISCJwEW1zd3ERn5nHrQXU8IxiMQtEZYT9t33p4MZQKVyWU3MYlVqmcBKAhKxWcjV0yRBMdxRG7in/IL2NInlfgLf3wCagmYBYP8uiN94w2eKhuUKuQOYSR6cwrPD7uOlnA1FjqY6oTMORlSXITaOcDHhuHdDqCqaKMSCbjpnE38EQ/Eye/6Uq8Y93bC7n9+zpbBELgaHvuUbx4uTcoo/tbYLalStsAa0oPL2FFbOec4ah2KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7771.namprd11.prod.outlook.com (2603:10b6:610:125::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.20; Fri, 9 May 2025 03:22:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.020; Fri, 9 May 2025
 03:22:38 +0000
Date: Fri, 9 May 2025 11:20:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
 <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
 <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
X-ClientProxiedBy: KL1P15301CA0049.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: bc4c4104-008d-4e20-847b-08dd8ea8bfe0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3pqeFZPOHRITUpsNUpoRDliR3hxZnIrUk01SFNrTFFuanpqNEFCWDdvWDRy?=
 =?utf-8?B?VlFvbEpMT2FEMTNrNTdZazJlU3hIc2JCQ05JWldPVUZVNDFDN1hpcDRrYXdE?=
 =?utf-8?B?OHAwTE5TekpUZVRTUnQ3ZTFhRlNCb0VLMW5zWGJYbkZ4UWFaaGxZc01xN0NS?=
 =?utf-8?B?MWpyNU5vaG41ZWhRVkpkbVg2ZzlRa3I3T2laOUpUWm5GVElzdjBHYm1DVU5R?=
 =?utf-8?B?SFo4WVh1TXM5dlY0UHNsSm15L0dndlNBODFCR0RWUWNoRU8vdHh0a0h2TEJE?=
 =?utf-8?B?dGIzWVNuM043aHlBRThoQTJxeUMxVkRmL1QyNWVZU3pldldTdlovZU5qQkEv?=
 =?utf-8?B?REErYlJlbGovWFc2eVEvend6RXZlRzllODNxK0hLcGJDWXJMRW9lb2dWVTdC?=
 =?utf-8?B?ajY4KzI0NkJUekFhUXIwaG8xMW5CY3ZzeFNtZjRBNXVLcjVLdy9WWitXZFJz?=
 =?utf-8?B?bkNQK25JLzRJQUtKaU1xWWJrVEZZcnlET05ML1J5eDNpb1pMZFpOelE1ZlBx?=
 =?utf-8?B?Y0cvMFB2ZjJOeUxwZ0lZL2tsZmFseCtJSWNZNHVCM21hb01jMTcxc1p5MUtx?=
 =?utf-8?B?Znl2d1Fwbno2TVU4ZVpkelZlL0lnZnFPN3E4eTZwM25CRXArc24rbitHbWpu?=
 =?utf-8?B?Y1h2WWU1bHJQQTQ4alR6QjdQYXZSSzVEU2FBOU1RVEVHR2FIS2dmdmtybUxC?=
 =?utf-8?B?enBIa1VZQ2dyNXh0aXp1WVRQQ0hoOE85bVpGbTc4MGNWMzZZR25jeURZWXFR?=
 =?utf-8?B?T25xYi8wdDIwV2c3Yjd2MmpTRFRzVUhublJsenlDSWJHdUs4VFpyZVpZdzg2?=
 =?utf-8?B?c1docE9zZngzWlZka1JFb1Z6ZHhQVUFleExNbElmTjl4MmZhVnRvUFhoTVVw?=
 =?utf-8?B?WDE2RFd2MHU3aXk4eWU1djViMDVMSm12bDVmbitHbER4TEhQd2dlKzd3Vk1M?=
 =?utf-8?B?TGtDZDBELzJwSUhIa3psakhmd3FmQVc3dExQekpGRjZ5KzJkZkNJS2xEWGlP?=
 =?utf-8?B?WjAwVkFtelF2Zm9tcE1YT0R5TEF4aHN4bXFnc1JrcTJqODYxdENiZXFDaFhH?=
 =?utf-8?B?M0FYWGJPcm52TDlaOUxlTFhveUtpaUY3QVhqazZXdUZJc2pVWmd2ZUlDcHlu?=
 =?utf-8?B?RGFWSW5QMHp2b1FBQ2p1Z3RVRGlOU09ITDlMRU9MK3BEa0hWQ29rOGlXNFQ2?=
 =?utf-8?B?emlxakpJWDlCZFR3WFFyR09JMmZkbFNEcENpdEVGV3l6L0hwM1d3Q0hRWEZq?=
 =?utf-8?B?NWxpaGhNR0lHYzJkMmRKUXhDMWljSk14b1N4ZXBqU3NGZEFEdm5PQ2crdklx?=
 =?utf-8?B?c1hDaWFzUjBReDMrREgrbERVUUwrenRqVXVsVWpaNk1oMWtLR2ZOa3VrU3R0?=
 =?utf-8?B?RXE2Um1HZjJCcW5vV1BLNTBDZUlnNDVKVlJaUHoyQStWRDlNT2U1cHlPTUVu?=
 =?utf-8?B?S1JIamUrQ0lxVVArM0RIdXBCSFJJNXI3b09xeUptcmF3NXJDQTFnOTIvOEE0?=
 =?utf-8?B?c3QyODVtR3FGaE9mL1J4QXM2cmY3TExqcUNxcFNtUHZmSzlwaTFRWm01ZnQv?=
 =?utf-8?B?N0FNRjlYWk5yWk5uTjNzT2FaZjBnWlpacEhiQUp5V1ZyakZLQWQ5WGdEeHNk?=
 =?utf-8?B?ajdCbXZTR1hsWUhhL3NoN3FNSE14NlNwVFFkcjYzZVAzTDVySFliSTdkNC9h?=
 =?utf-8?B?SHFxM2g1L3VqdkFkeVk5SENFdHpLY29IZnhvbnFZdjk3TVViV21pUDI1RE9t?=
 =?utf-8?B?ZkhybDBLNHlUc1FXR0s3R01QODEwdU0weitiYkpRSHg4ZHdqdEIwM1VSUG1T?=
 =?utf-8?B?VEdsMEFIWFFXQm80VW9Ud3RUSCtuM2FnQ1RxOGVkU2tMVG9HVFNaaktQbkNm?=
 =?utf-8?Q?We+Wu0MPha//r?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mjc0MVdWNjZ6MWQzMUI2M0tHaFkrMGlVNkFVcHQ0WWFPRndFOEdxTklyV2FG?=
 =?utf-8?B?SC9CbDU5NGtxWjNvdFpmTmtuYTNVNDFSekczb2g5V0lIUTg2SkJSSFVBcjk2?=
 =?utf-8?B?SVQ2RkowWTVyOEsxajdILytjdndXaDAzWHJGaE1vK0JvZ0NrUk82VFozT0tw?=
 =?utf-8?B?VmJGOW1HN0hSSjlTQlg0MkJnUUNsZTBCOURndmpDODlDQ3gzNi80Ym1DVHBW?=
 =?utf-8?B?NDdBRHpiTllBMWFmVGFZWXdyQmRFSW9WSll5cklJOFphYWgyWmlLRkJvY04w?=
 =?utf-8?B?RlVCbFNPWFNBeUI3YVM2UUtVTTRBSVRRL0pjQUNtUHd4Qm85Z3JHWjQvM0Vq?=
 =?utf-8?B?bVJROXcwRVlFTmxRYzd0dVhXVHRsd1dXNEx4RkEzcCtlWm5rWG0yK0R3UFZ3?=
 =?utf-8?B?YndnYnZUYlFGNStybU1vNlNrUnhoZDhub1FONFRMQ1JVU2xJYkNlRjE1eEp5?=
 =?utf-8?B?cmgydE8ybGsrUGJWVXBhNEp1VmZTdjJnTUltbHFrTEp3cUhnalR6MEYwbC9C?=
 =?utf-8?B?Q0hoVTlpWmFROGtuL1ZqY1F0OHVnQW5HaUhsRUdyV295d3ZNUEZvVjBCSXFW?=
 =?utf-8?B?Y2JCTXhycVg1dllibTR6Z1UyejN3VW9lVUlVdnJNWU9UWEJoVmlLTlhrVmxj?=
 =?utf-8?B?bE1RM0piNzEwVVg3cXdsVGIyeEk5UDNYZ2tJVFpiK3MrMFU5czBHVVdhOGFR?=
 =?utf-8?B?V3o2RjE4dnNJMGZsWmR3VHFkQlg5aXo3bjhMc3p0OWtRRG1pNCtHREdjTzRh?=
 =?utf-8?B?WHI4V3BKOFFJVHFvVC9nYWI5WWlrMnFJS2RkZGUyWU9Wd3l0MmVjeDN2elNk?=
 =?utf-8?B?VnRGaTF1bEx5akV0Z0hSY3pPMjRKT1hOS3N5elFXU1hzeFV0Uk5leEhSNGRu?=
 =?utf-8?B?U25pbmhLZVpNbldORXpGZko3VERoU0pyOW1qTWJZTTMrTkZ2NGdQaVZvZXpW?=
 =?utf-8?B?OU13LzlqUlRrcjVvM0VFZWM3b2tnb1FPSWFIYmxWK1RuT3Bpbk9SanhZc1Ay?=
 =?utf-8?B?VmJCejhRa2R4R3lKdzJkMEErWW5aZGQ3TG1iQ3VteDU2VFpvQVZuVUZCQVJU?=
 =?utf-8?B?eXRYdkRBamdVdEFZbEk5WXlEREVmcVFENHFWdlU1UmZTRllQTnpTdFo1cnZV?=
 =?utf-8?B?MFUyTlZPMzFMV2R5dVo0dzZVQlY3UjVSeWplQ3BmeUdvM1dkRURRbDExN000?=
 =?utf-8?B?bkFjZ2JzOEYyUHNlaFVtRVpVOUx0dHowOXVpNi94OXV5c00ya3BBSXNUSUtN?=
 =?utf-8?B?c3AveGJRRnpIQ3BjUFhFYmFSTFovTzV2Mk9WOU1rQUJnNk9qQ1hjYzVUbzVU?=
 =?utf-8?B?NE45QXV3TFBRN2ZrQUwyWWdvZ3pla2NtTGhxVlZzMlV1Y0pwb2phQnhIVDEy?=
 =?utf-8?B?aUVkcDF3VGVybFVpbXp1VU5LbGRDSzcxZHh5WExablhyWkpHLzQ0NHdBcWxL?=
 =?utf-8?B?eW9QbUhzWjROdG1DNFBBU0FoUUFqdzlhemhNZ2ZFOHZPbE5qbUZ0K2VWMkc0?=
 =?utf-8?B?Q1AvZ2dPMUJDWXgzcjJjdjQ3Yy93WmFtNTYwTEJxNVRkYll6M2xoa3pBWW0r?=
 =?utf-8?B?cVlOa2tXaWN0NG5QSHBUamh1UWRXN3pZby9TbE1odWpJbG90VTBlUlZnQVIz?=
 =?utf-8?B?VXNGaXlZaXJMS3BON0xTQVVEZUlJZXZRRy9SeG5QTVZoTWFISEJmSVU3MUxI?=
 =?utf-8?B?NDRVcGVpOCtlUHVjcTFxdm5LUUFLRnJaOVV6b0o2STBSUmZKSXlYVVo1a05J?=
 =?utf-8?B?WWdCL1FHbFBJOVNra0tON2d0TzRtOHVVZXJoakxDWWV5ZXo0SDJkMUgyVkdJ?=
 =?utf-8?B?dVB3cU81Qm9zSGdHZG4wNTh5cmx6d0cvcE1VVE43V0p0dVNoU1FDRjdXcFN5?=
 =?utf-8?B?Z045NjBMcVBHYkJONXQ4UndudWpnVUkvTisxMjhnd0dETUxocEgrMnpwTXBv?=
 =?utf-8?B?djhyNFYzT1JROFdwT0JPSGpjVDZLaEZoQ25CeC9tek01Uy9tN2x1aXhRT2dm?=
 =?utf-8?B?WE83cUI0NUhMYnBwSit2TWpVV3FFdTJiK1h2Z1RPRFF4aElUQ3lVWUpUTzdY?=
 =?utf-8?B?cHprTkZ3QlhEM0ZmRGJQU0Nub2VVaitSaWx2dkxEeHJZRXhjbUp5WHRnQ2JB?=
 =?utf-8?Q?TrQEbg6nsfUNz0HgIXzS/wCSJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc4c4104-008d-4e20-847b-08dd8ea8bfe0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 03:22:38.2715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgN4B3rZi7GWOzwL83NAYArw75U1txzJh55qJy2AXvHGKoD5aTGonKv8hu54nzYoQht2oWoeJ85hBSUSHLDxtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7771
X-OriginatorOrg: intel.com

On Thu, May 08, 2025 at 07:10:19AM -0700, Vishal Annapurve wrote:
> On Wed, May 7, 2025 at 6:32 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Wed, May 07, 2025 at 07:56:08AM -0700, Vishal Annapurve wrote:
> > > On Wed, May 7, 2025 at 12:39 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Tue, May 06, 2025 at 06:18:55AM -0700, Vishal Annapurve wrote:
> > > > > On Mon, May 5, 2025 at 11:07 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wrote:
> > > > > > > On Mon, May 5, 2025 at 5:56 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > >
> > > > > > > > Sorry for the late reply, I was on leave last week.
> > > > > > > >
> > > > > > > > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> > > > > > > > > On Mon, Apr 28, 2025 at 5:52 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > > > So, we plan to remove folio_ref_add()/folio_put_refs() in future, only invoking
> > > > > > > > > > folio_ref_add() in the event of a removal failure.
> > > > > > > > >
> > > > > > > > > In my opinion, the above scheme can be deployed with this series
> > > > > > > > > itself. guest_memfd will not take away memory from TDX VMs without an
> > > > > > > > I initially intended to add a separate patch at the end of this series to
> > > > > > > > implement invoking folio_ref_add() only upon a removal failure. However, I
> > > > > > > > decided against it since it's not a must before guest_memfd supports in-place
> > > > > > > > conversion.
> > > > > > > >
> > > > > > > > We can include it in the next version If you think it's better.
> > > > > > >
> > > > > > > Ackerley is planning to send out a series for 1G Hugetlb support with
> > > > > > > guest memfd soon, hopefully this week. Plus I don't see any reason to
> > > > > > > hold extra refcounts in TDX stack so it would be good to clean up this
> > > > > > > logic.
> > > > > > >
> > > > > > > >
> > > > > > > > > invalidation. folio_ref_add() will not work for memory not backed by
> > > > > > > > > page structs, but that problem can be solved in future possibly by
> > > > > > > > With current TDX code, all memory must be backed by a page struct.
> > > > > > > > Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" rather
> > > > > > > > than a pfn.
> > > > > > > >
> > > > > > > > > notifying guest_memfd of certain ranges being in use even after
> > > > > > > > > invalidation completes.
> > > > > > > > A curious question:
> > > > > > > > To support memory not backed by page structs in future, is there any counterpart
> > > > > > > > to the page struct to hold ref count and map count?
> > > > > > > >
> > > > > > >
> > > > > > > I imagine the needed support will match similar semantics as VM_PFNMAP
> > > > > > > [1] memory. No need to maintain refcounts/map counts for such physical
> > > > > > > memory ranges as all users will be notified when mappings are
> > > > > > > changed/removed.
> > > > > > So, it's possible to map such memory in both shared and private EPT
> > > > > > simultaneously?
> > > > >
> > > > > No, guest_memfd will still ensure that userspace can only fault in
> > > > > shared memory regions in order to support CoCo VM usecases.
> > > > Before guest_memfd converts a PFN from shared to private, how does it ensure
> > > > there are no shared mappings? e.g., in [1], it uses the folio reference count
> > > > to ensure that.
> > > >
> > > > Or do you believe that by eliminating the struct page, there would be no
> > > > GUP, thereby ensuring no shared mappings by requiring all mappers to unmap in
> > > > response to a guest_memfd invalidation notification?
> > >
> > > Yes.
> > >
> > > >
> > > > As in Documentation/core-api/pin_user_pages.rst, long-term pinning users have
> > > > no need to register mmu notifier. So why users like VFIO must register
> > > > guest_memfd invalidation notification?
> > >
> > > VM_PFNMAP'd memory can't be long term pinned, so users of such memory
> > > ranges will have to adopt mechanisms to get notified. I think it would
> > Hmm, in current VFIO, it does not register any notifier for VM_PFNMAP'd memory.
> 
> I don't completely understand how VM_PFNMAP'd memory is used today for
> VFIO. Maybe only MMIO regions are backed by pfnmap today and the story
> for normal memory backed by pfnmap is yet to materialize.
VFIO can fault in VM_PFNMAP'd memory which is not from MMIO regions. It works
because it knows VM_PFNMAP'd memory are always pinned.

Another example is udmabuf (drivers/dma-buf/udmabuf.c), it mmaps normal folios
with VM_PFNMAP flag without registering mmu notifier because those folios are
pinned.

> >
> > > be easy to pursue new users of guest_memfd to follow this scheme.
> > > Irrespective of whether VM_PFNMAP'd support lands, guest_memfd
> > > hugepage support already needs the stance of: "Guest memfd owns all
> > > long-term refcounts on private memory" as discussed at LPC [1].
> > >
> > > [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3182/LPC%202024_%201G%20page%20support%20for%20guest_memfd.pdf
> > > (slide 12)
> > >
> > > >
> > > > Besides, how would guest_memfd handle potential unmap failures? e.g. what
> > > > happens to prevent converting a private PFN to shared if there are errors when
> > > > TDX unmaps a private PFN or if a device refuses to stop DMAing to a PFN.
> > >
> > > Users will have to signal such failures via the invalidation callback
> > > results or other appropriate mechanisms. guest_memfd can relay the
> > > failures up the call chain to the userspace.
> > AFAIK, operations that perform actual unmapping do not allow failure, e.g.
> > kvm_mmu_unmap_gfn_range(), iopt_area_unfill_domains(),
> > vfio_iommu_unmap_unpin_all(), vfio_iommu_unmap_unpin_reaccount().
> 
> Very likely because these operations simply don't fail.

I think they are intentionally designed to be no-fail.

e.g. in __iopt_area_unfill_domain(), no-fail is achieved by using a small backup
buffer allocated on stack in case of kmalloc() failure.


> >
> > That's why we rely on increasing folio ref count to reflect failure, which are
> > due to unexpected SEAMCALL errors.
> 
> TDX stack is adding a scenario where invalidation can fail, a cleaner
> solution would be to propagate the result as an invalidation failure.
Not sure if linux kernel accepts unmap failure.

> Another option is to notify guest_memfd out of band to convey the
> ranges that failed invalidation.
Yes, this might be better. Something similar like holding folio ref count to
let guest_memfd know that a certain PFN cannot be re-assigned.

> With in-place conversion supported, even if the refcount is raised for
> such pages, they can still get used by the host if the guest_memfd is
> unaware that the invalidation failed.
I thought guest_memfd should check if folio ref count is 0 (or a base count)
before conversion, splitting or re-assignment. Otherwise, why do you care if
TDX holds the ref count? :)


> >
> > > > Currently, guest_memfd can rely on page ref count to avoid re-assigning a PFN
> > > > that fails to be unmapped.
> > > >
> > > >
> > > > [1] https://lore.kernel.org/all/20250328153133.3504118-5-tabba@google.com/
> > > >
> > > >
> > > > > >
> > > > > >
> > > > > > > Any guest_memfd range updates will result in invalidations/updates of
> > > > > > > userspace, guest, IOMMU or any other page tables referring to
> > > > > > > guest_memfd backed pfns. This story will become clearer once the
> > > > > > > support for PFN range allocator for backing guest_memfd starts getting
> > > > > > > discussed.
> > > > > > Ok. It is indeed unclear right now to support such kind of memory.
> > > > > >
> > > > > > Up to now, we don't anticipate TDX will allow any mapping of VM_PFNMAP memory
> > > > > > into private EPT until TDX connect.
> > > > >
> > > > > There is a plan to use VM_PFNMAP memory for all of guest_memfd
> > > > > shared/private ranges orthogonal to TDX connect usecase. With TDX
> > > > > connect/Sev TIO, major difference would be that guest_memfd private
> > > > > ranges will be mapped into IOMMU page tables.
> > > > >
> > > > > Irrespective of whether/when VM_PFNMAP memory support lands, there
> > > > > have been discussions on not using page structs for private memory
> > > > > ranges altogether [1] even with hugetlb allocator, which will simplify
> > > > > seamless merge/split story for private hugepages to support memory
> > > > > conversion. So I think the general direction we should head towards is
> > > > > not relying on refcounts for guest_memfd private ranges and/or page
> > > > > structs altogether.
> > > > It's fine to use PFN, but I wonder if there're counterparts of struct page to
> > > > keep all necessary info.
> > > >
> > >
> > > Story will become clearer once VM_PFNMAP'd memory support starts
> > > getting discussed. In case of guest_memfd, there is flexibility to
> > > store metadata for physical ranges within guest_memfd just like
> > > shareability tracking.
> > Ok.
> >
> > > >
> > > > > I think the series [2] to work better with PFNMAP'd physical memory in
> > > > > KVM is in the very right direction of not assuming page struct backed
> > > > > memory ranges for guest_memfd as well.
> > > > Note: Currently, VM_PFNMAP is usually used together with flag VM_IO. in KVM
> > > > hva_to_pfn_remapped() only applies to "vma->vm_flags & (VM_IO | VM_PFNMAP)".
> > > >
> > > >
> > > > > [1] https://lore.kernel.org/all/CAGtprH8akKUF=8+RkX_QMjp35C0bU1zxGi4v1Zm5AWCw=8V8AQ@mail.gmail.com/
> > > > > [2] https://lore.kernel.org/linux-arm-kernel/20241010182427.1434605-1-seanjc@google.com/
> > > > >
> > > > > > And even in that scenario, the memory is only for private MMIO, so the backend
> > > > > > driver is VFIO pci driver rather than guest_memfd.
> > > > >
> > > > > Not necessary. As I mentioned above guest_memfd ranges will be backed
> > > > > by VM_PFNMAP memory.
> > > > >
> > > > > >
> > > > > >
> > > > > > > [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c#L6543
> > >

