Return-Path: <kvm+bounces-7080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3217D83D493
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:12:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0148287DFC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 08:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D30D17C65;
	Fri, 26 Jan 2024 06:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YAMWr8TP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985CC17585;
	Fri, 26 Jan 2024 06:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706251933; cv=fail; b=sbUcbv78ize74NGZKC9YPxA0YQgcCKrwZc5YXoeMcaoyiuFTU+xD0ErTN6sOGxldqaNOZRL34uCgK8fJzpxAmfUzyTKMXKhaIJzhO5hBN5I069VglQGzJJbmph25+aBC6/uw937JW9E+ll7ByZXfcJOgNRym5BxC+V64gGE3vRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706251933; c=relaxed/simple;
	bh=7WzdeSVuAzPFIl4ACzjyiWkEQCd7IyJW+gCSgQtkbVE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YEUsZ7mXybfpygpfSWD/mpVTB5Wnd9W6Bf6PRLL7Zv8xfcXRZYN3o5n5d8+mqNLjCH603A28XEkayjD1LcctvzHyjcAZ4CWJiJXA7V601dQGld7iIB+GV0bs/AJKzKtbkd0CST/Ia137tuw9kvl4OPOZ+GJmif+SMBI1k1zHvxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YAMWr8TP; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706251932; x=1737787932;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7WzdeSVuAzPFIl4ACzjyiWkEQCd7IyJW+gCSgQtkbVE=;
  b=YAMWr8TP/yqiTcduywTR923hrlaYd5eImDJh/gU+MPe84nGDZOU36j/h
   SaSFzGlsTeAn52XRbcL7U6nJtwi0kl6tXcjifQvEeAqEuA5aLxh+6u3qc
   FsUMFka6dnzdo2V8j2OidYFescmEgHY0OLREkjSE2NQpJMJGnNgd5ThFO
   MrZRN/vo78apH7BH7qH7OApnxHSnl4/lIEN1iMBTzvHiPFykivSPi6E0I
   1BF7E2RW8qKu4KAuUcc9odbM0QZ8rvA6HnHwSKS/ckXvGUZFSauF4/RB5
   Pf8BsFSFZ/udYcXzgOu64KnBdn0AJL39I/ZPtnR/l8xmnJ6gxW4DjLX7r
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2239825"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2239825"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 22:52:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="28737788"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 22:52:11 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 22:52:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 22:52:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 22:52:09 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 22:52:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IomK7vw/Nvz3VXwae6BHU2LaWqMWoM0myB3S3YsdoXdh5ybyrkQYyO4rlWdtByR1OtvWIciWWwJHRpLn1fo2Kwf6Gvfg1Ur0bbeCeZFg1MyDQIcy5ebug5/83J2lZJDsGf1t8/f3U7Lkzvr9mgD5lwTADb8KY31s7xpJFlslD07BebYAeEnYlcqrP8+CL1vCGXOfXzCAYazNQbEkPaBCvrz9PqA2RNhxC03ShtouaTUWQT7IcUXZllfXB4Q8MgGJbRTerFw/6GsN5J31/7d8f/ZFzVT0JbuQ6ehHp16d1n8yxks/kKAkBVvW7D4DJQqvr3JfMBZSxHnwZMdRRgVg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+9BDuY0xglbKXnFmiZyGIXGfEJvDRLL3uqBsKVPdcA=;
 b=CJrs5v2WGlWVTnI7uUMXElNKHQbPAX7vpC5jjV6W1/9Zd+G7l3qNne4O86iYgDsb0Hamoj3lXAQfmjV0vCl54oUv4qU3aUBdsSQuDBMJXvy3x4Ibu5zmDE9M2oEe6a0eKdq3ACopl/XW6Ghl27x0yaFAm1G64tFL3MyyMSgpdIUwa3rKLktkG80ofBnwJBYTFQ2LEFGtjmOjjVvnsDwTIoTUiBGOODI3tQ3BD94IO7p38U04s2qZVULfporipmsXfq4kadTZsAdfBoVUIlzx0OIJTm7jeJ7eEXf1GQBMjfyAJgLEZAwt+b28PoPUWCNSe+bshIkGjyFLJ9D3WLk7LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB6446.namprd11.prod.outlook.com (2603:10b6:8:c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 06:52:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 06:52:01 +0000
Date: Fri, 26 Jan 2024 14:51:52 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 21/27] KVM: x86: Save and reload SSP to/from SMRAM
Message-ID: <ZbNWiFt/azHuL1+f@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-22-weijiang.yang@intel.com>
 <ZbMkRKyhy3jdiuzx@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZbMkRKyhy3jdiuzx@chao-email>
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: 01508cbf-736c-4681-ca34-08dc1e3b4c8a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXKYUuPO8HTEb1RUvzZxoK/vgG6E9mTVfRHA0oSDzum47KabOmNczFZzqljlw0bipinTX63KFAGMm1QS8L3KmcQRYckUh+NoYwNNtNDJyExYfO8vsuEnq6crZ/i153JwbsoRA2CXjU5EW1Yz5vDP+TUay+cGLv/qgxVvaJRWMxkqhrnkakU0MBoejwmNAesOzfw8o3GTIWrniLRhLrksH22BLvngyaBTfmI5XGULuSMiw6t3z0ku9Y5sf20lCadKxfvCHHcFr4tQCVqIKo2FBRyJI5WOrtvpJZ+nhmeE8gYYrvxQ4JI7hu8wfuAuzeb+xvyDd/Qs3B6DQraU/DwO9AArTze+tJ2ojQ8I1jEXHAYtjZpkX0ju8vAmFHxWGww+f9npo860G6FX3W+UHroyIi5duVHBekDPP2B6h0bM3QSWB2ePPBSZd0GTLFG09mS+fSzbARw30k8hDxUQmi3eFVu7pZrRkIY43Bm9RFjgy+nAxEDUC0Oy3JWeF5lVZynYZIO76o8mGvQOswynUJ/PjNHAuQa3NU8BfhacHd/xVmoASn8uU2CpMNAzSsTdJnrQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(366004)(376002)(136003)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(6666004)(6486002)(478600001)(26005)(9686003)(6506007)(6512007)(83380400001)(316002)(6636002)(66556008)(66946007)(66476007)(5660300002)(8936002)(82960400001)(38100700002)(6862004)(8676002)(2906002)(86362001)(4326008)(41300700001)(33716001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKiRFZgZXkiuGmSwwT6vu7DBKPmELUv+mYBaERRRiO4z0Foyerl2b1EpG+WN?=
 =?us-ascii?Q?hxTjRC2yp5AtRNWL7XrsGdlDY5/kNR17WyKHBEVlmAP1krrsiPXfpSHSIyuX?=
 =?us-ascii?Q?NjQD5aUjgSwO7EMga1ilBLof9vSpA7Mbb6keh3mNQJKUI9TRwQz3rN8mqE0C?=
 =?us-ascii?Q?INp+YkMktn39e+4X5/bRrOzz1WnR3eURnUvvxSqdllpe376ut6WnqmMZNrpQ?=
 =?us-ascii?Q?ebo5KvZ5nAJ15bIE+HRA523nAjrqvEx4XSB3ehmnA12UkEq8eR8z2hIXDQ9U?=
 =?us-ascii?Q?FeGixH4/FnfNsn01HBIDSkZ/L6Wvom5K790yWfSs9AZROJm43Y100DU+4V2S?=
 =?us-ascii?Q?Mg/APU1sBnXpHyvAkrHF0Eybj3ylseOUj4/sIduuTYYwuhbk2G9chbTsTIZI?=
 =?us-ascii?Q?IyDVANYHuiwgYc+W/XmF1VnjbvVkEU7wMcCDOB2DJPECUk9Dsmo4qbVhm0AH?=
 =?us-ascii?Q?RlMn6ZboZT0KkcNTlzvo5P7vNAzMkjU7LW7Fr/8GZWw1COXf0OsD6eD+p2pW?=
 =?us-ascii?Q?Py+BN5p8Ag06MF/lfn7r2j8B2Jr07rURXivKjB1pMGDinHFOLtsB+34WWaJ1?=
 =?us-ascii?Q?k/aB9cEU0mj+P05ClHZCAV2kn8pxFmuFBjT2//L6LqdzuKRVKg2bw1THqAUf?=
 =?us-ascii?Q?7PwkAMcrCQ9o34TL/o+NieQZXiJtX2rQO7GMTQ2f0gXGd6taiflb1Noy7rHa?=
 =?us-ascii?Q?gL+W94R1U5HqLo+Q8GcbECaKzIjXeE+KQhnLmUIHIGk7d43a7LfFceoac8fA?=
 =?us-ascii?Q?1lkw+Ooz6Qn4iG6zmGjilnuWqeoE7/ZSZkyca5wrtEySmVabZEBfRAGylNko?=
 =?us-ascii?Q?GdjnpgKiwGlZRjpBDS+OwmzLvjVLeWt32k+gUm3mvAH9hyGfcEH0Mz2zYlWZ?=
 =?us-ascii?Q?0Q1MFsJXTzfqnCIM7NHglqyGAwyCHWSfAn5wazMG4iYkOnzzx8nw6Was+WW0?=
 =?us-ascii?Q?UU0QB3Jl7Ec/+aCt7t8VRDWdgoK4u7wHZLHAEPKqCrQJ1R5P5IWdykF2cH/J?=
 =?us-ascii?Q?5lMjklsQGn3S9b57A+bHhv1OHG8TSaytulsQJc90DGHjSoDuLptTzRMqRjg+?=
 =?us-ascii?Q?o4f7A+Uiqfu1qn0nao/JHnJbQl8MXGiU/o77uuKH5xyfStM1rgwASKg6DW4g?=
 =?us-ascii?Q?/SGpUPoZG2LfLB3JU/qxaAFru/KQ7UO+Ek5IE/0D4Gp0VZllp9jyMUtOCXGQ?=
 =?us-ascii?Q?YRUwIg5cUtVfsNWAupRgsbs3GOwOJQ+7EPQFy/B1DpawQcXkzQ/hw6+j/jcj?=
 =?us-ascii?Q?EcIgX5Zys5hTo4kZhJhaKw3tOMmriEvG83tcY9M9MlcSjWTCS5AwiDHcqXJK?=
 =?us-ascii?Q?6nzpuvQc0veyM6WRf8F3TCy9HTcNqaIwK9BFQX6jgMx61k021ai4Q9G3mcTx?=
 =?us-ascii?Q?dI1jVhbt8+qYH1iOG1avzi0nJkEmRSAIS7F7Uv6S8JqTi++AhAKHJE+eYqTd?=
 =?us-ascii?Q?CmiZFQXX+jvzxMz9t0A41XtN19llCeM6+0xsqo8RmGadPN4wsoLZ1PeczCPw?=
 =?us-ascii?Q?f4aV3T7aHxEg0fr4UBBLL9ScGqYbGOatE0LML0urMKjAWuXexaHfw8XEgBZm?=
 =?us-ascii?Q?GRTiNwz476O52i57C+0tARlFdM8fXdarzisnohP0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01508cbf-736c-4681-ca34-08dc1e3b4c8a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 06:52:01.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZTsJfaYDVBxySm6amypFnTHzSEFM7qsqX9No2xl9ZUdX1uklnTC3sdHtoloUIM/Vy/J3ZSlCexx+dvtG61F2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6446
X-OriginatorOrg: intel.com

On Fri, Jan 26, 2024 at 11:17:24AM +0800, Chao Gao wrote:
>On Tue, Jan 23, 2024 at 06:41:54PM -0800, Yang Weijiang wrote:
>>Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
>>behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
>>at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
>>one of such registers on 64-bit Arch, and add the support for SSP. Note,
>>on 32-bit Arch, SSP is not defined in SMRAM, so fail 32-bit CET guest
>>launch.
>>
>>Suggested-by: Sean Christopherson <seanjc@google.com>
>>Suggested-by: Chao Gao <chao.gao@intel.com>
>>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>>---
>> arch/x86/kvm/cpuid.c | 11 +++++++++++
>> arch/x86/kvm/smm.c   |  8 ++++++++
>> arch/x86/kvm/smm.h   |  2 +-
>> 3 files changed, 20 insertions(+), 1 deletion(-)
>>
>>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>index 3ab133530573..95233b0879a3 100644
>>--- a/arch/x86/kvm/cpuid.c
>>+++ b/arch/x86/kvm/cpuid.c
>>@@ -149,6 +149,17 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>> 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>> 			return -EINVAL;
>> 	}
>>+	/*
>>+	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
>>+	 * state is not defined for 32-bit SMRAM.
>>+	 */
>>+	best = cpuid_entry2_find(entries, nent, 0x80000001,
>>+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>>+	if (best && !(best->edx & F(LM))) {
>>+		best = cpuid_entry2_find(entries, nent, 0x7, 0);
>>+		if (best && (best->ecx & F(SHSTK)))
>
>F(LM) and F(SHSTK) are kernel-defined feature bits; they are not
>bit masks defined by the CPU.

Oops, my comment is wrong here. Please disregard it.

