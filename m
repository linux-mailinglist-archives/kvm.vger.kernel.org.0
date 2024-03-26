Return-Path: <kvm+bounces-12692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC5688C054
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 12:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16EF1B21D5E
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 11:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA00537F8;
	Tue, 26 Mar 2024 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X5kLpUr3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF5B3838C;
	Tue, 26 Mar 2024 11:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711451642; cv=fail; b=UZmBb4PocjkjnYO07j4GK0iYKxQWJXtk/Au6WtIvOOrei1SD+KgH973WZlCmFgaNYU91QnP38eu+6NzcKz9LebquMF5IIK5h02IL2xjCMZg1+jeZLTAWQ9sG4zO3y/idlVE1ENpUKu1onhchVU+BHxlX773aBkd25VhkVusZL30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711451642; c=relaxed/simple;
	bh=Voq/F4HSoH/FoGLRbbBGYC1nebWcks+Q8OWb5wjvhgI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KMM+GjHZT4/aTEPDqkEQST0hhqYNKCc8yaaxhLYv07P2Fn5xrHYTruhZESo6INlGnzRKDx2byJdm8yn+TqmPVvfRzT1TNyekg1WxQ9bD1PdBCuXgEaJ+JyWIWX9YNq/qAB1DUng1iXiTfTJNtmNU2AXtjEMoo6dBDFcSpESpnfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X5kLpUr3; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711451640; x=1742987640;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Voq/F4HSoH/FoGLRbbBGYC1nebWcks+Q8OWb5wjvhgI=;
  b=X5kLpUr3f682Op1cgJJRWfHf2u+yJSo0PQZlEQrfR53iLIk7hEvvKI/d
   xGScA7oYe05oxB5SuC+or0J+511SaDv7UbYNOPAXm6IRQ3TdpM4I4Iboj
   7kNF4CVhoJLM6ZzfGwXwpm/aZs8GH3nZqV+GrbW5AKRWSIn09S9uhJDqw
   e5OUGyklsFyaMyuhHSpE90LGcCKEN5cGJ2lB1sEeqPTvx+O5eWoTpXRBn
   h9BN79na3ooDIoC4EXwpAhppK9CDGooQGiulc8kAPvVs5iCS6CB/0WwKr
   XOS7B/RdPJhLIJGnOeLnBf8ulaAIWe8lo2cHF8mmLuZspYMNUUV6iIV7i
   Q==;
X-CSE-ConnectionGUID: XyciQPvnSUe4Dq/1kLKqJA==
X-CSE-MsgGUID: uVZ//+9XSaK6jvXS47SyZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6327494"
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="6327494"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 04:14:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,156,1708416000"; 
   d="scan'208";a="15904139"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Mar 2024 04:14:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Mar 2024 04:13:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Mar 2024 04:13:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 26 Mar 2024 04:13:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 04:13:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRvMrtOWQ2XAqnQKfP+xIboyXWYTS2O8JENeGBV1FxCBSg1u91cJ+12Bg/WBVXT1HSb8zLWzQ2RPRLQWplMPCvUufbakjR/Lh1l3pV+DKVWw/NWHCv32++wF1VSq0rReE0SelJB7S0T3XQ6DK1cm4HJ3yLPke01p+YtPx6XFYEAndmgyw4XBW832Ayw5tKw6ue36lITFlulh0ynkZTK3duGll6wwrRpzpjJSrnAeMqZR+cjPmUmeHnRc0/vmnuZSxK50jq7qnMNaNEO13uWUhyN/AKT/LFveJQ0jUYFoWEfVzA+wZlSpAoUbigTT33jN8kyg5Xxq07GeFYEqm5ZM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxeuZxhyeYeo9dFBL+JMu4gmb9t5wlhHNXLGwZ8Lyuw=;
 b=j3YFmOMIoN1T9uBpSHaLn19vjXP6c9vdp2wF5oVqEWVJKw/kGmpp/r26HwQWHgZB3P99NGb5nHjrVgssEXexW60gMXLl82n8IfjvUEqYdJcEUD4Gis8GqR18sRXOU4670xKZxWej9RotMhV2qMJDwCj3g+u1jZeFG0udM43G4yy1JuFHSJZ3+iulR+5WFqu7FBmC3xVKJoL5B0Ce8uPSV6W6EhUGBij1rEwU5M5dCb5i/GvZE7IsBdDf8QfzU30wB2JRgqD96WTS5PMhC0/raO2mXfU0Z4CAlQRiGZtYxqc4ZHZY1gK8WrG00J9xkfsphPSyWKbNa6aNd+Y7DF26cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 SA3PR11MB8004.namprd11.prod.outlook.com (2603:10b6:806:2f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 11:13:56 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::e2ff:bb0b:e1cc:b58d]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::e2ff:bb0b:e1cc:b58d%6]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 11:13:56 +0000
Date: Tue, 26 Mar 2024 19:13:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <ZgKt6ljcmnfSbqG/@chao-email>
References: <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|SA3PR11MB8004:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gRavpJBQZ9VFBsrBRZFQ9KASM4IBrplstPNIuy2D9ElIGnhL8ydWYPbg1be7sDMUetFXicJWN3Ilg6YDJUV1z7NY6WXhya7UZ24VFMSCmjwJkJd6YUce27NhIu/dQc56DYOQ/UNXVyVH7tma/bUxfViQ5KjiqMPs2YyIanpUnufzpXigHaQ6tXGwFJpVvERQ/VkUO7dSWcHVKoMrtZmy5rcq8jgFio6Qim8H3wKnLJ1oKzkva8jWuSEm0Q/sCseFkrfURtsqeM2ed1uaMScBzXt8s6FymQZ8EQo1CGS6e3W/RricKiBUjfB9tS27bYPOG8AvZfjIhzCnsxUEEvSYZAKkbQBugXYGJ47IfG8vaOJJrVSXyBF77RrVuXxupo1RxNYLk6WK2AKsAT3jAfagxHtOUL0PrkLQor9B4OQEU4enCy2H7RwPiCk540UmZbctNZAI8vlOBVYtdzB+pFgzKAOOulrz5EYOTWWPnNubuEWCosrD4nBySlpWwVOItl24MgYZjTO28ZI8Ghmz2Y8Afeq2qDeaUgd++YJX2IShgmndxphvWCNcp2qQZn4uSuwTrGcsqlTFyMza9WXqTnf9/cAu1OHbF6/7US1+AT2dJbOP3R2irG6SUqUG8jA2I9PwHi+ky6e8wUIzN9i6vE7zxjcqrH8demNvEgGUCH8JkX0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?QuwmKZ4foh6nxHICSskApc3CQUDaGxqLJdhFJonWLJCuBjMCbAC0wtp9Pw?=
 =?iso-8859-1?Q?I+OGqg5lPjJ1tNpW181pk6pgqToZ5P87NAVhGHkt4OkDfvcs+kQ4/+ZR2R?=
 =?iso-8859-1?Q?XBC6LQ7l6IHetKrYQSlsrlzVXQXWFITTQY1yBgZd5Q541fuqBgZFpiFryj?=
 =?iso-8859-1?Q?LHP0hwMkWpqtT7H1MFujrUhTLUNJO/sm4jHAGphx/vTjxIPgwh71vbSa8R?=
 =?iso-8859-1?Q?uyVs9errJOij8FcwHGoxyImuVp72wOZ1D9gMRwmIuUdFQcsxGRB0VAJQSF?=
 =?iso-8859-1?Q?6KZVx1DxDVh01yGBEOFN/eG+Xdh/S2y5oE/R3Q38v0bbRGZSyws7PxujPe?=
 =?iso-8859-1?Q?ev2O8CdsD0PAoojb1xanUi5mTyPTyNr5Ela1JnSYjyOW1FyooYoYIym1rU?=
 =?iso-8859-1?Q?o5Cg8tl07/yEcLLbF989sTr7yUpjPG7lAfZuVxM0NGD1cJ4EG2d6AM8fwe?=
 =?iso-8859-1?Q?ltBOit9/RPYzVWsgNNvwK1BW126cvgOBaj9bxpP2LD8xiiBpfjyyFxWQl8?=
 =?iso-8859-1?Q?CshvdCZi5CtKHPRGaZTlmNlBGBnHT43+swbWdNJSsn0hZ3i4HQX9agZr7P?=
 =?iso-8859-1?Q?/OMV9RUzAowjHLvuq7z1bTmqPJjenlRN0pGl6jFWXIxpl1MVzizq2IejGS?=
 =?iso-8859-1?Q?2JC8dIzLndpW2NdfCSho7ux/HTJoIUNlMowceTZFiNKwOdpF4nMZYBgcKZ?=
 =?iso-8859-1?Q?zWjBks5f+ssojtSzzHpzlf+A2iOAZNM9f9h24h1Fci50VS2Ufeklp9IeAH?=
 =?iso-8859-1?Q?w+ZkGSqNcrFNpSf8QLmxXmdpJ/viek/slwCgjC9hj21bN0Br+aY5y7kkYh?=
 =?iso-8859-1?Q?rRt1ZLHz8qOPdC7JA6oaXqZ2D+pGB2pbsaYBJPFLtjCRAkNGhDzVlhpq6U?=
 =?iso-8859-1?Q?4n127Ed/cq97MMkKFp6R3AUV4gBjyaopgxLVL3DXQAGfhdnXXK/xuNGDD+?=
 =?iso-8859-1?Q?JKvWuxFHv5Q2lhysy2ZBH4ViUPczJ+j75k07IbNBTiIwH92DeQCGROWp6i?=
 =?iso-8859-1?Q?4xosVjzEKPe/ihS9O/ql78XSohIijU4qGIsXEowAnUtDEV/d0L6KELRUNR?=
 =?iso-8859-1?Q?Teaoc7hQJAyT//DQrwh8xNF8z36IKFilLRtfLtVFS8PQ2IojaPRPUQp59S?=
 =?iso-8859-1?Q?oXlzw7fAt8XQm30906bh8Lb7rFP1BYFyGEJNsPAl1Fhfsq45Ux5FzVueLW?=
 =?iso-8859-1?Q?5BwEJMIrMchy1kB6jx+heYkHhE9Brv1Ce49Pzobpt6nlgJFHcVwwMUuTdm?=
 =?iso-8859-1?Q?ZJXBoyh5N2Gk3pL6ppftO0ZCZFwsS1B1Cpf/GTmDKt4al/2E94GmMFH7sV?=
 =?iso-8859-1?Q?dNRN0CouhqVPtKiaUTKbClaJPCksk/E9qrgxCFowZmF6PtR432j6A6Vv4C?=
 =?iso-8859-1?Q?fs3F0l1oH2F7pJn2SDu9Vec+Nk7S7Ws0WwAOZE8TUQ6cuGG6Aqs06CUHp+?=
 =?iso-8859-1?Q?ysJtvFMShw791WCf0xJ75Q4VLs+wB6sDB0+Qxmgt4+vC3zSihs8J6DA35D?=
 =?iso-8859-1?Q?cM6p08ja58G5l3Q+QcaF67WGBP8BJQnfzxQ6nLYmTvJMq/mOoO7DU//Ixd?=
 =?iso-8859-1?Q?57nJdTXm3vlGBaoahGH09B48iuFUip8BRAJLfChOZMhbHzg4b8IVbADg5v?=
 =?iso-8859-1?Q?HkBQN+S4MlhcnvHFVdNYtEeZyMxJVzpanj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a9894a-2d78-4deb-6f6b-08dc4d85d3ec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 11:13:56.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8q5yVuvAbj8FYbw3P1upLMj2HCw5S44cMRM/XvcH4An46AeV+317MZ0UiahS7BTCx9WrcSxFW7aM7reg7MwUMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8004
X-OriginatorOrg: intel.com

On Tue, Mar 26, 2024 at 10:42:36AM +0800, Edgecombe, Rick P wrote:
>On Tue, 2024-03-26 at 10:32 +0800, Chao Gao wrote:
>> > > > Something like this for "112/130 KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall"
>> > > > Compile only tested at this point.
>> > > 
>> > > Seems reasonable to me. Does QEMU configure a special set of MSRs to filter for TDX currently?
>> > 
>> > No for TDX at the moment.  We need to add such logic.
>> 
>> What if QEMU doesn't configure the set of MSRs to filter? In this case, KVM
>> still needs to handle the MSR accesses.
>
>Do you see a problem for the kernel? I think if any issues are limited to only the guest, then we
>should count on userspace to configure the msr list.

How can QEMU handle MTRR MSR accesses if KVM exits to QEMU? I am not sure if
QEMU needs to do a lot of work to virtualize MTRR.

If QEMU doesn't configure the msr filter list correctly, KVM has to handle
guest's MTRR MSR accesses. In my understanding, the suggestion is KVM zap
private memory mappings. But guests won't accept memory again because no one
currently requests guests to do this after writes to MTRR MSRs. In this case,
guests may access unaccepted memory, causing infinite EPT violation loop
(assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
the host. But I think it would be better if we can avoid wasting CPU resource
on the useless EPT violation loop.

>
>Today if the MSR access is not allowed by the filter, or the MSR access otherwise fails, an error is
>returned to the guest. I think Isaku's proposal is to return to userspace if the filter list fails,
>and return an error to the guest if the access otherwise fails. So the accessible MSRs are the same.
>It's just change in how error is reported.

