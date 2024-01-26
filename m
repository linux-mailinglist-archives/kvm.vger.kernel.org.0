Return-Path: <kvm+bounces-7044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A529683D2E8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3343C1F2557F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 03:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE659AD2C;
	Fri, 26 Jan 2024 03:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iz6yr+Y/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145DA8F45;
	Fri, 26 Jan 2024 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706239063; cv=fail; b=hf6vgPEVuXKXubMc1FZtjHme9m1Xe850SNvefRr2ZPCjRhaSwqPhmGj3cX6yJbJXoep98z9B7k60ZfybQ+RqhLfIt3BumYGeEXCOXa+0xxrVQGTYZk4p322r765vjTiE3n9f4sUlbLuFtQVHSh0wQni+RJ1cEvo1fcqtCHOFFvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706239063; c=relaxed/simple;
	bh=as87FZqGunAhcnMjQ+WJN4wYKcWdsL8CD0ERiMiQWU0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S251sgP9t/Iy2qA/ZY1ZMKwEcREmPsSgGgN6IVU2MvVua8r6bH9nA7qzGubimtZoQ1sZHZxIGyVBmUgOoiKKGAg1tUYeJGGLoSiDUOEX7cMDbbUHXYd6cSow+11EenI08f/2dZ/hCe5Ob9ia5Ec3qQ5o3PpMAtJmijrvuMjcxrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iz6yr+Y/; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706239061; x=1737775061;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=as87FZqGunAhcnMjQ+WJN4wYKcWdsL8CD0ERiMiQWU0=;
  b=Iz6yr+Y/O1Cqb+UCmz27GMdTVhFriUXbpn787GGt6KaxYLZGkQAhaah4
   4GEIy0oMKKO4FhlavgvVL84ZKurGmJgMitrDRDk+7BmoAMCGYXffZfABP
   ZOVXfQu7kjRt5LLNLBHS2w4ccfVlS2hE9daYQUbe7si5v6x2ZnlBvVWnu
   Vu0mNvbrTIhHSRKIAKL12/zl9fak9VerTTGUJpqRxfwG6yD1vOD99gTYR
   aK4sii5ui3lGEhzloMEwHk44y6d2KzxFcpVJn1yP/cMX5PrcF8rDLc0c0
   XukjTL64R2VBsXyi6qO1mdHJA/JqZXWkQs887+5hhhkXiFkcX6jcOFkBW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9029492"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9029492"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 19:17:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2558474"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 19:17:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 19:17:38 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 19:17:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 19:17:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 19:17:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjj7Y4XBoUuiFSy8p9hCVQIHOO93GDxCTHgUaWZgdpFcsEflUWwbp0p0/o4P8/U2O1uUb6FERp4ATGExrr75GZ9+7OHOjYdYPjmQ1PLVh3uryNWWnHJLeXfLjtXb+2YMYJXmkpvUrpIBnhDBA6m+oHzCWo2nnGLS8MA2XUEXczT0Q1Efm/PlL3Ak2d5q+npF0cuWqUds/ZqnsWw7MlYsnhy0rddaQUk4dz7FxMgF/2J5HKdoCju1elYPJ5BMyfdD34Kkt6TdIEwronrC5hLq40UVJzlnXO2QR2Oo7ZLZ/in+tubtAQgr0E1L88ESL0wtw+acQqvaYF127S37XQEdwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJ0k4lBYZ6DbRKG7+X/y9ylz5R5xekqmzMoN1/ZTXM8=;
 b=kr8en5aon0pmtz1xYNP/wJmBNDqY6GiW+cexJjpFUOvjvJkQ1CjocG2qCjZGcI44QawieQlp/DWwrNk1Bar9dnBMzdnBwB1peqSo3IL82hg/rlpNz/HhvmzwdTm6F+fhvbAHlnRbFKwr9FfQ48aSuAswg7mp/5HJLtE/tcqdeFtn73n/DqCA+THe/c7hKzUvM2iKge/PWJ/s4gVMbO50tc4VfG0EAFup8IiMz+XIuJhhEgbuZQ5uzok5EbCUGvTKvNVqM3K0ordN20Z/VkKoW8UIiEx88UQwlkKA/k7BXV7Eg2TW0Vd4urEagBUwnh2puzFBf23W2d52gW4lMaiLhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 PH8PR11MB6879.namprd11.prod.outlook.com (2603:10b6:510:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 03:17:35 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::c66e:b76c:59ae:2c5d]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::c66e:b76c:59ae:2c5d%7]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 03:17:35 +0000
Date: Fri, 26 Jan 2024 11:17:24 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 21/27] KVM: x86: Save and reload SSP to/from SMRAM
Message-ID: <ZbMkRKyhy3jdiuzx@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-22-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-22-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR01CA0153.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::33) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|PH8PR11MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f799347-dcf1-4391-c576-08dc1e1d570d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dACl94Hjo5wBSKKJX7PmkluAT8fGoVvhiQAqQC2s4SAcotCUdnXlKcp8lzsGHR6WXo9mJzfJXa9UQeQ2CcYoVMqun7QotOGlDm0PqBcp+dgwE0z/QEHbuNvEvVid86NYkaq7wg6OcWkJOsP8YAggB6S0BKzcuPyh9YLKNxrgrqEOMrqB+Won03KA7A+xerYhlaNRtlL6MY3Tu/kXn42Mt9yJz1xhAczAr2C+KH2sNlN7e9rxTSZ5ruQeT0nDcH3IXRidUrAyH3eO+OZZGrunAFHVqVhLtl1tw0yFIOwNQOw72o9QoAbB+w56RPLXo6AEsgIl8o2sT1qHvAALOZkVOSlxULH7t+6/RlOav9bJXD6TtqTP98cI0bzdcZM402qwpDpqBHon1UEQQzufoQ61fSpLdfbul5cM3sIvEOSlILVClLMixLEAXOPxPlChNwU+QHfmpn1LykHb3PdyQi1r3I8j+n9Rg0nWrLeoAF5xTOk7CdQDyh2qUOutCj3SZedr2QmIrvUTAe5kReFMwFYQOZWfudExTFtbMAa9/Az7FfNF9ixXkTqb37MaoKnaCgJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(366004)(346002)(396003)(136003)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(6636002)(66556008)(66946007)(6486002)(316002)(6506007)(5660300002)(41300700001)(82960400001)(86362001)(6512007)(6666004)(33716001)(9686003)(66476007)(83380400001)(2906002)(38100700002)(26005)(478600001)(4326008)(6862004)(44832011)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pjB8YFvyGaLMiVir5NaA9AQrom7fJXVkWZkvJ12mFgiLRDK79OXAMWtVAoQd?=
 =?us-ascii?Q?UVOLjl2pXjdCYqDBgz0AidGasQB89kRezTPzWpcW0vI7KALmlGykDY/XMOC3?=
 =?us-ascii?Q?OUjkHKNcdhi5RBHfkUXY8NV9g1o2fBSwK76SqsM2DE1hGSKIcuLpcWz4zm/A?=
 =?us-ascii?Q?O7TjrAWvaRSWele+NXaQ4ZpIePFJoWbWSPaDj/f5ekj8OcxJQGSQrbZ1f2BM?=
 =?us-ascii?Q?1E+YKteY9moCnNb/66/PB8zoWdgnqcOWddPNQqX1E6EpAHaQ+YVEwqAF4UMj?=
 =?us-ascii?Q?Lpmhy+jl+O76c5tEYJCHFyKitK5UKHAxSNHEDZQ+NAToZeGjSOAw8p7vDJyv?=
 =?us-ascii?Q?H+gZc1+aZB8F73Qk1HNi2hhw+sZbgOGE3EWg70OHoU7yNpHFiM2hDpxcHIuH?=
 =?us-ascii?Q?EqHJHBXPDJgLRaBEJYTG7gWMhVlsYjRYADAxcgVpHdxT2wBCqBzoub/YKk5D?=
 =?us-ascii?Q?H/SFQSjTFlBoJd/O+KGNzuqXWTlSXBUy+xD+8iS787FR6VuZIe+/arqfinTR?=
 =?us-ascii?Q?NCRCpY3zS0AP3IkkylYnuMBuM3HrqL40B71tx5ocFGzcpa2lxAEoaLmrD94L?=
 =?us-ascii?Q?fXm4bpIeIwv/5ED5A6owYdGqFdh7CqdD9kjQdeLiKRxTkOCnG4qdtBzmh4Na?=
 =?us-ascii?Q?AqF+KT3Iz10G8XjKsF+FDtneNLgLiJD+XcKatuegLTrXuncQ2qMcxsERLexx?=
 =?us-ascii?Q?0FS30AxaNVW5Y9xYApdBrWbpiOCnnYqNkygWXiLfLQDDOJh4a2tCT07cXHxk?=
 =?us-ascii?Q?+Eyojar3qyPTLxgkKBnG9yZfk8XxGtHXAeWGje0AC/pWYptQjd/yfDIMNo9+?=
 =?us-ascii?Q?ekbw+WrghyqQ6ONC+wNj7QimO4VeosCAshPS2XpRKvw+m+2QB2Z7ccy2njqE?=
 =?us-ascii?Q?MxVq38ioOoV4buNF/AUi0Zcb745pqNCJVADkzHGgSCPTIHgapSMQ1W2A+oTt?=
 =?us-ascii?Q?77yzdAtsyjLy7xTBncdSgCvmNCiWImQqG45WgZZEm1ufCvUYP87YL9PTXWps?=
 =?us-ascii?Q?qNwZKGPOzQxMSVaTIqTs1lLI1yNuCf76KqvpK+yurZSB2ydstHzFvOee6WU1?=
 =?us-ascii?Q?zqZaV0bzrUBpSGGoiwstrSR678TXMHbqQTBn+9LNGEcs7svTtlwa5AEeipwI?=
 =?us-ascii?Q?WMdcnzWAJEBcamUFy16xGCNgcx86IDbSWDNfSy8rgfzFpU8ARv8JCOm/Yyxv?=
 =?us-ascii?Q?h6PXgLEu65+EleVqAEUg0XndRApD9fJ+rnqARPk01B6lzKz0o7gBHu6HI3Tg?=
 =?us-ascii?Q?L8zEbIci2t0qKjiWi89Nq8Qh86ycaPQARvlR45moHSvznAU9fY/FqXXmbWOj?=
 =?us-ascii?Q?SvXnTFiOzLiMdPxEGcbeopVuZ8YrInE00o1g02Rm/CK1aNjFmdkHy+zcvp3q?=
 =?us-ascii?Q?XhzVcHBUyzt4dQp5P9dJeSFrb1evC5ObYMIyKSSepfWZXeFVlPN+mb4kiL9K?=
 =?us-ascii?Q?dD43ja/Ak6Nl8NGNczfX+A5yYHm4GDa1yQkV01zqlZjxVy93CWeg3XHI3acf?=
 =?us-ascii?Q?aCrGI1tsJKWIKdbMltIxigyVG51OqnO1J9M7c/sdxaAg8mpnE3m77NZXTVSp?=
 =?us-ascii?Q?Y9V/AVrK5Cl1tErgT0Z1Ywv4wPXYi4cCMjtXfW0X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f799347-dcf1-4391-c576-08dc1e1d570d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 03:17:35.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7cd0r453XN5JZaSSNvO+9vCm+3ONl34+LJSwh+4k/mox+HArgiFpxIqPJfh5JuWO39eHvRnbY302yno4cBzxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6879
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:54PM -0800, Yang Weijiang wrote:
>Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
>behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
>at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
>one of such registers on 64-bit Arch, and add the support for SSP. Note,
>on 32-bit Arch, SSP is not defined in SMRAM, so fail 32-bit CET guest
>launch.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/kvm/cpuid.c | 11 +++++++++++
> arch/x86/kvm/smm.c   |  8 ++++++++
> arch/x86/kvm/smm.h   |  2 +-
> 3 files changed, 20 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 3ab133530573..95233b0879a3 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -149,6 +149,17 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
> 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
> 			return -EINVAL;
> 	}
>+	/*
>+	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
>+	 * state is not defined for 32-bit SMRAM.
>+	 */
>+	best = cpuid_entry2_find(entries, nent, 0x80000001,
>+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>+	if (best && !(best->edx & F(LM))) {
>+		best = cpuid_entry2_find(entries, nent, 0x7, 0);
>+		if (best && (best->ecx & F(SHSTK)))

F(LM) and F(SHSTK) are kernel-defined feature bits; they are not
bit masks defined by the CPU. You can use cpuid_entry_has() instead.

Shouldn't we do this only if SMM is supported, i.e., when

static_call(kvm_x86_has_emulated_msr)(kvm, MSR_IA32_SMBASE) is true.

>+			return -EINVAL;
>+	}

> 
> 	/*
> 	 * Exposing dynamic xfeatures to the guest requires additional
>diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>index 45c855389ea7..7aac9c54c353 100644
>--- a/arch/x86/kvm/smm.c
>+++ b/arch/x86/kvm/smm.c
>@@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
> 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
> 
> 	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>+
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>+		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
>+			   vcpu->kvm);
> }
> #endif
> 
>@@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
> 	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> 	ctxt->interruptibility = (u8)smstate->int_shadow;
> 
>+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>+		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
>+			   vcpu->kvm);
>+
> 	return X86EMUL_CONTINUE;
> }
> #endif
>diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>index a1cf2ac5bd78..1e2a3e18207f 100644
>--- a/arch/x86/kvm/smm.h
>+++ b/arch/x86/kvm/smm.h
>@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
> 	u32 smbase;
> 	u32 reserved4[5];
> 
>-	/* ssp and svm_* fields below are not implemented by KVM */
> 	u64 ssp;
>+	/* svm_* fields below are not implemented by KVM */
> 	u64 svm_guest_pat;
> 	u64 svm_host_efer;
> 	u64 svm_host_cr4;
>-- 
>2.39.3
>

