Return-Path: <kvm+bounces-46772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9CFAB96D4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91BF27A2D47
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 07:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80DA22A4EF;
	Fri, 16 May 2025 07:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dB1QHQJX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EFB226D04;
	Fri, 16 May 2025 07:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747381750; cv=fail; b=qwqMgg+/HqzUn5UNzqVLs9S/d1bSxS/wfEFQoMXtuXeC5ZSoIbvr9rFgfJW+n6CVgUJL2FJw8/G/sMjrZ825ymfRcA920OjxcMJJGtEsvZxynnRBfuQhIPTFXdKdp6oj9Ev4klElxujH1K0X2ZEAdZcCLDzVPg4PAoU6MmUBVcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747381750; c=relaxed/simple;
	bh=9HwqJNK5V/ZTV6rsAp6L3/omNUKWUvTl6j//8CGcKOc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rUrmqOz1LYkOT7hjsOp0L4YNQYe4gM4NIBXpAf6IGsOfeAsUOGnwD99BWJC4YEZqpuJjMChYguS+MGNPdGyx6Tjodlrhcx6NEBqlLKBPgJCLuVWvui5WaKFctrMn0bIHiQaKZSWJ9mtRqwDyEwfPHByL4k7oWwKnbYYwBij9MLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dB1QHQJX; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747381747; x=1778917747;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9HwqJNK5V/ZTV6rsAp6L3/omNUKWUvTl6j//8CGcKOc=;
  b=dB1QHQJXh6pzzwHjdkdsE4gy1/ADf8+xL1FaWXktvaO/JCwGnFscuKJd
   zR/FoI7D50abM7N0sfGrMcKKjVia8xxQgPGWiHwkxKYpRyn/u+n2XHiym
   UfQmTguEkOr9z2o1oZ58cab8gaXgOeVsOZDLHVarkpqbPVS2+qSr4jtRc
   Ui4b9CUiCaZomk3IHYRJ/2/q35z5oKhQvNgpi2+YM6Lq8s6iBhkuxByZf
   7KygFmp5yCXdSAUH1q0jddhGiwx0tkSxfc2nZftoEvQOJXwjTDjK+uY+N
   SvynGGwzorvME7zW4nAg8DDotwmdYLH4r6BtlxWSr2knO1SOsYEbIJlX6
   w==;
X-CSE-ConnectionGUID: Wjfv5QnpTOempV3bsY8neQ==
X-CSE-MsgGUID: vtB4MR93SsKjZBdPQe99OQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="59574515"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="59574515"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 00:49:06 -0700
X-CSE-ConnectionGUID: oz8urAwJS8KGPjbIAOyTyg==
X-CSE-MsgGUID: Td69vTQ+RBazUWxqIRqvkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="143386985"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 00:49:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 00:49:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 00:49:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 00:49:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NlS3CcQt+QO7pogmDIRhtLUAukkrnmbySPwbvD9T3nFpF/iW+dtKEVbz0MDU5a1zvhdcd+pZc0myufVSHwivDHj+rO9d1JRrVV+unbRT0f2zUAQ/sdpt4a0b6y8MzQoIOlLLoo14SkW1CLfE6E84PF82yBVXIAu2m+Z24YPfmh1e24IWzSOlkIQA4igZTz6wuwMDaXOYXV4wNaNUXxb+j8imvzuknEZIhKR63oht8ksGJO7WzqfOCw2A7LzOj1kkDTIWxN2VgQpBTgAxIWQ2/HWSqZDlkuvpWYd2gYPO/lXQazr268fcesqcOg7qAglXKqRgGUSM7ilZQmIP2wQ0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfUG/wesnoaaNsVoqXSaIMxWmOsUFhLdKUZFPTZeY8g=;
 b=urzBOoUFxymDhKu8uc9ykrgdvxI2DTJr84T7QEQ526zzZteZesLcdYYYtE0TDD/hdgDScboUAIBmxyvxkhrP9dj3kKERPMFw8jzSokZMBvlC/BRabU8AQO00XiMOI4M6IGxf9rKRoCX8xFjVHfXCyPYwfitlo5e0F6uQF87M1KnjjuelRAP1hpX5Yzm4s8SdZOg38rdG/u97h5t0b+nLGOa7kHyrYtr/SXXlRwA1EI3gZkrSmrp1P9ETAhhUWLbmKlJlca/qt0uBC0SpbNXXEbJhasZ4/C34Y3VFCqIwNltugva+UdRaq/IcU/3Rpn6B6KLBTPUa86aNxZFGnUy8Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF93A1BBECD.namprd11.prod.outlook.com (2603:10b6:f:fc02::3c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 07:49:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 07:49:03 +0000
Date: Fri, 16 May 2025 15:46:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Message-ID: <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030816.470-1-yan.y.zhao@intel.com>
 <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0064.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF93A1BBECD:EE_
X-MS-Office365-Filtering-Correlation-Id: 22623fab-4adf-48ba-3df1-08dd944e20af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?t+fgyXgq5ldJthmKBM6/bkv+krypR4LzCCzYryVYP3Mk5fZOUfvvRPaF0h68?=
 =?us-ascii?Q?rzeyegJKgjfn1ZTXAiiyW/pFLic5z2d6smVGH7zld2eCaA7HQcFfZd8FLthj?=
 =?us-ascii?Q?wO+4RkD5n5e4iWFyH3g7MXn7kzUqYgAtST6H/pEc/cbCKkh4L29AwlJOrFJO?=
 =?us-ascii?Q?DsQ/d1jIJQ2xXfTJqAikpN+OEGeGDI2TMdFMRndukG0s1JWq7Dhgeahp0ayu?=
 =?us-ascii?Q?YHkgegBxueAKBwtKnGMXUKw3af7TsugYU+NK/FXLG29CxA0wcKtq6tfRWxcQ?=
 =?us-ascii?Q?moYtAyGxdWAgvXRQ6uOW5Qm3hGPiO+brTf6cnzP1ng91Omr6kWmtWVVJskdE?=
 =?us-ascii?Q?L6drdSo1pdCZ4LlD7P1ZUsuEygH0O+qsLMp5GgJO/OBVVfR5v/1b23LdmTK4?=
 =?us-ascii?Q?OKhHFzH0OIjuEe6+ndRbq5NvBlZRIssp8gcxqUc44mTU/NDdYHAriIuqffnG?=
 =?us-ascii?Q?E9HVm8vhZNMsTZF8JWwBcc13wVV4I4HZ9MDsiCo/BR7bqyxj798bwteHQ7Pc?=
 =?us-ascii?Q?Q8WOAEhyWFn+6o9ccoYKhe8wcojyrAO4Xtovlp4b3IogZaMzDIbqG8sKJXcI?=
 =?us-ascii?Q?v39yG+tUFZKZ6eGUwNdM4gEwVWYlQgDxeYlNXDdCh4Eo4k1EyIsoMlyvml5E?=
 =?us-ascii?Q?Ko0Y0EQ3Kkn5GZul+pemSlvpn2ON0+HbvGWN8Gh/88KyVK2VdgJkk0YN5v80?=
 =?us-ascii?Q?p61HRVt8L86HDej1gmXfwFX9FHLNVtPjNoDjt/zXRvoqTTxDAqE6WRIx7MGa?=
 =?us-ascii?Q?M1bPDybvOaeBkLyiw/1n/oVxo2dGXbedJo92Jey5QYqLxe2MtVnYPBZQS0zr?=
 =?us-ascii?Q?0Vl0x8SHbEUO3dxmTHupFwPRQ4d9dbtDPfHQ/9Yy/SSx7Z1/t4PqL6DJj8O+?=
 =?us-ascii?Q?ql/d4KkbSDHEZzAEBCeMEM401Bu7bueI555vHxODXRir3NuABvp1mQSDdUES?=
 =?us-ascii?Q?XN3ES4wt3zJzKQKzYLr3hKd+PM3fXPCXZwQ+n+G98vniCeXR9kOcdZM6cw8+?=
 =?us-ascii?Q?8NT2t7ZDRf6XTBhb89DxkPwBTyjHw3YxdY0YS/+4QEEQ/5KbjTB0O83mlFbH?=
 =?us-ascii?Q?PaoUuTbzMPt4Hhy2g5WKrKPjvpi88N7RFuMkgWGKM4/uXagVJuEnFgUBc23j?=
 =?us-ascii?Q?m4isrTZBfL1Z3B4xvciRkJyjI+3ih6wtRijmq4Z8LM58esMOgcnOkpVzDau2?=
 =?us-ascii?Q?IduxOTd5w7LG2rYrcdNydvISluizHO4RVNG4qbk1yHbJfP14kSebg228JN0E?=
 =?us-ascii?Q?2waKddR3vTDk7nRZuyKSuAaG52IquhY9zlwl/ZPjXeiIOXEHe7lefoASzC/2?=
 =?us-ascii?Q?TPQYANMiGLnAorwq6epMQ8Rj+5THoQDGzDEDKhsp+DiUCHcr6VK6oRZb/JSw?=
 =?us-ascii?Q?tmXVaUACqF/8fJ58PykHGOFug8007nsnGaQkrRSWY5exnkCT2WDCfCJcDS5m?=
 =?us-ascii?Q?1WODDfufUKA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rpohzC4bhdobp4jqlpGcQ2OvkFQvBOx4G4DaL51MVFA5zZgvKeEXQ3z/ALGC?=
 =?us-ascii?Q?Autpu1mzJBV9bhv+24wGQDYJ7p1TBk5EAfNROxKwc6K5yVZTwG6FokmboL4T?=
 =?us-ascii?Q?7rVy2QQglQDBSKM7XUCk9JFuysTHXM0ZnohnKj5f2mNkMHVI1IH1eGp4cN7s?=
 =?us-ascii?Q?y59nxuXyYRl+9JED8x3K/DvQfdaA8VZysYhR9QkAaVTmprmH++v3UDCS9Rgt?=
 =?us-ascii?Q?bLFy/8ddUw/8BOl2JVAC2X4w+/WK18nL6SR3/GOgCAGHSlb1xn9q4UJajmyv?=
 =?us-ascii?Q?2Nu7HRKnXsKYG4XwXL547gtDg0IScMwuyim1To23AROmadi2eSn/d5TjG5ea?=
 =?us-ascii?Q?eMpQV8L9zm6bsmv0l8IPt3VA4FOjof62Ud6LBH51jyFHYY+9wISxEaUMLewE?=
 =?us-ascii?Q?D2A5MI75qqyq+CcjK7Wqi6vVTRughvFbat7Nczq655YY7hOKaNAKq3stIl56?=
 =?us-ascii?Q?HTy3WHxP9GqgeRrdk3JmyzQ8ff9ftbirlKB69nvj2EAPQ5lBS46I4YoXo0Dv?=
 =?us-ascii?Q?0c50fCmMB21rnrOvzXem5rSb4bzDI9c5YDHeHM9e9BEMlypK20b8U0Lrppi4?=
 =?us-ascii?Q?7eQySnDM1b0M68Dwdk3o5kK/GBbrPTNXdto+a9PEGTOkIkXBVugrSlOkEK96?=
 =?us-ascii?Q?V7sbc1den2a5Ql3r0/RIPla/KMishFdy63TsqKsW+3gFF3RdkgXx2pFAiP4Y?=
 =?us-ascii?Q?q+Kq25xNKYs7EnCViPsfizfZ2LaRwq0WGFzdZNOJ7qtBqLWfADcAGE84NKFU?=
 =?us-ascii?Q?3dFz6XAbVoZfofKrwz+dCfnJzmie97Yh5ueLbslEk6CR18PQFsqmVbG3QZj7?=
 =?us-ascii?Q?Wf6iEWGmZTXd7lS3qlYO9f6ZIRliI3nQ0FyAm2iaDeqMpr/ndu+GswtEhJve?=
 =?us-ascii?Q?kwAKaG1MmMiT+7kT0ErGfKuJd1l/y4ivZkk7CCsk+04SMgUWaIzKT48Eu+TU?=
 =?us-ascii?Q?eNhD3GCDs7C5S//0GYzlzZF3SWfTelgad77LcfMVbo7H27rhvsvM3EoaZnZ1?=
 =?us-ascii?Q?CczPFjDEyVYlNCCc8mG8B1zmWVVKDri8w8ax2VHIbYT83xzmWxXgdnBJ1PcB?=
 =?us-ascii?Q?fwOxWfcmvSr8Sm8MZ8/E379tBJ5TbyiODSYOppg2TO9Vw+2dwCOlLiVyqarX?=
 =?us-ascii?Q?zMtKdDIKgYwp2v/GWPSaG7ROA0paiMYM/H+X0VBEGo18B9/sjf09+Ww5PIHj?=
 =?us-ascii?Q?0Oubrjgn45yN4/hcLKZI7miIjEu2itml/sOeSrskK159KudEEQQSz+p38du6?=
 =?us-ascii?Q?v2qn+N5p+wAfOcw8gV+sZg/VPVvbMtMVij6ZTFdKwsgr6/iIkTnP5HhLZ3lE?=
 =?us-ascii?Q?aDHhw1aJm+8IKajNHbiCJVOkIWcvPQVFuK4t9XbksyP8dbe6rD3gTO8+wgGV?=
 =?us-ascii?Q?VvaAAFEtwqsxbMSDubu+i/0aXwvwqtUKfXlX48TQlWc3zUUB0gPErOJwX7rf?=
 =?us-ascii?Q?52B6/CrpEtqcx5m+GO4P3mbwiI4/NfqON443NzLHu/ACVKJwlznxSwkscE/3?=
 =?us-ascii?Q?oEl9V6pVFI0unv1YIPR+aTJA8CCxBFdr92OUyOSv3vOzitVPSMroYYQfnHu/?=
 =?us-ascii?Q?J/Xll9V/a2YDSiBqVH7ySpDGAghu3iuEN0n93h+G?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22623fab-4adf-48ba-3df1-08dd944e20af
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 07:49:03.5703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSVbqeV8pN3JWyLA+NdJDe/moriqY7fyP8LAbcP17HC9ENsQzEPtO7QZryYukSU9st1LfWllg3PHEAHUPfPkhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF93A1BBECD
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 06:56:26AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:08 +0800, Yan Zhao wrote:
> > Introduce kvm_split_boundary_leafs() to manage the splitting of boundary
> > leafs within the mirror root.
> > 
> > Before zapping a specific GFN range in the mirror root, split any huge leaf
> > that intersects with the boundary of the GFN range to ensure that the
> > subsequent zap operation does not impact any GFN outside the specified
> > range. This is crucial for the mirror root as the private page table
> > requires the guest's ACCEPT operation after faulting back a GFN.
> > 
> > This function should be called while kvm->mmu_lock is held for writing. The
> > kvm->mmu_lock is temporarily released to allocate memory for sp for split.
> > The only expected error is -ENOMEM.
> > 
> > Opportunistically, WARN in tdp_mmu_zap_leafs() if zapping a huge leaf in
> > the mirror root affects a GFN outside the specified range.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     |  21 +++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c | 116 ++++++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.h |   1 +
> >  include/linux/kvm_host.h   |   1 +
> >  4 files changed, 136 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0e227199d73e..0d49c69b6b55 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1640,6 +1640,27 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
> >  				 start, end - 1, can_yield, true, flush);
> >  }
> >  
> > +/*
> > + * Split large leafs at the boundary of the specified range for the mirror root
> > + *
> > + * Return value:
> > + * 0 : success, no flush is required;
> > + * 1 : success, flush is required;
> > + * <0: failure.
> > + */
> > +int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range)
> > +{
> > +	bool ret = 0;
> > +
> > +	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> > +			    lockdep_is_held(&kvm->slots_lock));
> > +
> > +	if (tdp_mmu_enabled)
> > +		ret = kvm_tdp_mmu_gfn_range_split_boundary(kvm, range);
> > +
> > +	return ret;
> > +}
> > +
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> >  	bool flush = false;
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 0f683753a7bb..d3fba5d11ea2 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -324,6 +324,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >  				u64 old_spte, u64 new_spte, int level,
> >  				bool shared);
> >  
> > +static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> > +				   struct kvm_mmu_page *sp, bool shared);
> >  static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
> >  static void *get_external_spt(gfn_t gfn, u64 new_spte, int level);
> >  
> > @@ -962,6 +964,19 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  	return true;
> >  }
> >  
> > +static inline bool iter_split_required(struct kvm *kvm, struct kvm_mmu_page *root,
> > +				       struct tdp_iter *iter, gfn_t start, gfn_t end)
> > +{
> > +	if (!is_mirror_sp(root) || !is_large_pte(iter->old_spte))
> > +		return false;
> > +
> > +	/* Fully contained, no need to split */
> > +	if (iter->gfn >= start && iter->gfn + KVM_PAGES_PER_HPAGE(iter->level) <= end)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> >  /*
> >   * If can_yield is true, will release the MMU lock and reschedule if the
> >   * scheduler needs the CPU or there is contention on the MMU lock. If this
> > @@ -991,6 +1006,8 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> >  		    !is_last_spte(iter.old_spte, iter.level))
> >  			continue;
> >  
> > +		WARN_ON_ONCE(iter_split_required(kvm, root, &iter, start, end));
> > +
> 
> Kind of unrelated change? But good idea. Maybe for another patch.
Yes, will move it to a separate patch in a formal version.
As initial RFC, I hoped to show related changes in one patch to allow a whole
picture.


> >  		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> >  
> >  		/*
> > @@ -1246,9 +1263,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> >  	return 0;
> >  }
> >  
> > -static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> > -				   struct kvm_mmu_page *sp, bool shared);
> > -
> >  /*
> >   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> >   * page tables and SPTEs to translate the faulting guest physical address.
> > @@ -1341,6 +1355,102 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Split large leafs at the boundary of the specified range for the mirror root
> > + */
> > +static int tdp_mmu_split_boundary_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > +					gfn_t start, gfn_t end, bool can_yield, bool *flush)
> > +{
> > +	struct kvm_mmu_page *sp = NULL;
> > +	struct tdp_iter iter;
> > +
> > +	WARN_ON_ONCE(!can_yield);
> 
> Why pass this in then?
Right, can move the warning up to the caller.
Currently callers of kvm_split_boundary_leafs() are only
kvm_arch_pre_set_memory_attributes() and kvm_gmem_punch_hole(), so can_yield is
always false.

> > +
> > +	if (!is_mirror_sp(root))
> > +		return 0;
> 
> What is special about mirror roots here?
Hmm, I thought only the mirror root needs splitting before zapping of the
S-EPT, which requires guest's acceptance. Other roots could tolerate zapping of
a larger range than required.

Maybe AMD guys can shout out if I'm wrong.

> > +	end = min(end, tdp_mmu_max_gfn_exclusive());
> > +
> > +	lockdep_assert_held_write(&kvm->mmu_lock);
> > +
> > +	rcu_read_lock();
> > +
> > +	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
> > +retry:
> > +		if (can_yield &&
> 
> Do we need this part of the conditional based on the above?
No need if we don't pass in can_yield.

> > +		    tdp_mmu_iter_cond_resched(kvm, &iter, *flush, false)) {
> > +			*flush = false;
> > +			continue;
> > +		}
> > +
> > +		if (!is_shadow_present_pte(iter.old_spte) ||
> > +		    !is_last_spte(iter.old_spte, iter.level) ||
> > +		    !iter_split_required(kvm, root, &iter, start, end))
> > +			continue;
> > +
> > +		if (!sp) {
> > +			rcu_read_unlock();
> > +
> > +			write_unlock(&kvm->mmu_lock);
> > +
> > +			sp = tdp_mmu_alloc_sp_for_split(true);
> > +
> > +			write_lock(&kvm->mmu_lock);
> > +
> > +			if (!sp) {
> > +				trace_kvm_mmu_split_huge_page(iter.gfn, iter.old_spte,
> > +							      iter.level, -ENOMEM);
> > +				return -ENOMEM;
> > +			}
> > +			rcu_read_lock();
> > +
> > +			iter.yielded = true;
> > +			continue;
> > +		}
> > +		tdp_mmu_init_child_sp(sp, &iter);
> > +
> > +		if (tdp_mmu_split_huge_page(kvm, &iter, sp, false))
> 
> I think it can't fail when you hold mmu write lock.
You are right!
Thanks for catching it.

> > +			goto retry;
> > +
> > +		sp = NULL;
> > +		/*
> > +		 * Set yielded in case after splitting to a lower level,
> > +		 * the new iter requires furter splitting.
> > +		 */
> > +		iter.yielded = true;
> > +		*flush = true;
> > +	}
> > +
> > +	rcu_read_unlock();
> > +
> > +	/* Leave it here though it should be impossible for the mirror root */
> > +	if (sp)
> > +		tdp_mmu_free_sp(sp);
> 
> What do you think about relying on tdp_mmu_split_huge_pages_root() and moving
> this to an optimization patch at the end?
> 
> Or what about just two calls to tdp_mmu_split_huge_pages_root() at the
> boundaries?
Though the two generally look like the same, relying on
tdp_mmu_split_huge_pages_root() will create several minor changes scattering
in tdp_mmu_split_huge_pages_root().

e.g. update flush after tdp_mmu_iter_cond_resched(), check
iter_split_required(), set "iter.yielded = true".

So, it may be hard to review as a initial RFC.

I prefer to do that after Paolo and Sean have taken a look of it :)

> > +	return 0;
> > +}
> > +
> > +int kvm_tdp_mmu_gfn_range_split_boundary(struct kvm *kvm, struct kvm_gfn_range *range)
> > +{
> > +	enum kvm_tdp_mmu_root_types types;
> > +	struct kvm_mmu_page *root;
> > +	bool flush = false;
> > +	int ret;
> > +
> > +	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter) | KVM_INVALID_ROOTS;
> 
> What is the reason for KVM_INVALID_ROOTS in this case?
I wanted to keep consistent with that in kvm_tdp_mmu_unmap_gfn_range().
Yes, we can remove the KVM_INVALID_ROOTS.

> > +
> > +	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types) {
> 
> It would be better to check for mirror roots here, instead of inside
> tdp_mmu_split_boundary_leafs().
Ok.

> 
> > +		ret = tdp_mmu_split_boundary_leafs(kvm, root, range->start, range->end,
> > +						   range->may_block, &flush);
> > +		if (ret < 0) {
> > +			if (flush)
> > +				kvm_flush_remote_tlbs(kvm);
> > +
> > +			return ret;
> > +		}
> > +	}
> > +	return flush;
> > +}
> > +
> >  /* Used by mmu notifier via kvm_unmap_gfn_range() */
> >  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
> >  				 bool flush)
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index 52acf99d40a0..806a21d4f0e3 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -69,6 +69,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> >  void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
> >  				  enum kvm_tdp_mmu_root_types root_types);
> >  void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
> > +int kvm_tdp_mmu_gfn_range_split_boundary(struct kvm *kvm, struct kvm_gfn_range *range);
> >  
> >  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 655d36e1f4db..19d7a577e7ed 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -272,6 +272,7 @@ struct kvm_gfn_range {
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> >  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> >  bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> > +int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range);
> >  #endif
> >  
> >  enum {
> 

