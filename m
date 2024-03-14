Return-Path: <kvm+bounces-11786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4726B87B952
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 09:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78EEF1C2154A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 08:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E479F6BB30;
	Thu, 14 Mar 2024 08:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C0JDhU3y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B061F6A8D1;
	Thu, 14 Mar 2024 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710405161; cv=fail; b=E/zSDGNexl0uEhZTTWEKFInoZu2H5wFNdQyE5eKNO69CVh8JOMwUxIFRksI/AulyHjbctFAzaRkEyMfMvSJdg0ADaZcv9q4QfINQPDTUnq5nFFQD9DKFZDGvXAwZj8A+5udvxejjS6UYmBrypPDkBmQ17G9d0e4aVxA8FHd1h28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710405161; c=relaxed/simple;
	bh=rJGUC7fz8LWAIcGYvoNjZ/QA9HpkeqyAVqS/OF+Cdo4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lZsO2DC82WpHJfWuT3u4UA0qkrwn36BzsGkoINCfRErk2VbxShioBzV4GigQJZbmlCa4R7Nn3MtC5Ng2Xz1QDQZjs96MkTVOAuI7N0fbHwnnTZ8YM0MiR1/wk9ImrtRUqv7QWBRh+Qn3m8cOA206CDffZpsuXX7TTq2ZRE2mvsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C0JDhU3y; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710405158; x=1741941158;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rJGUC7fz8LWAIcGYvoNjZ/QA9HpkeqyAVqS/OF+Cdo4=;
  b=C0JDhU3yfBR1dnEZ/17xbGS0tFw6cRG/5jBOjo7Rbu2ztIU2P6BxKGx/
   /dGv2WP9Gv0QPwbRdw2xImZn8yB5MiEKKLgOEOFf5ppLZOF4nZ2k4hfPI
   4X6mLJEtSpZiUksGi8h7fUIBmNpVj0WcliZn6J7ujaNCk7C6g7a4lP6xb
   zwLbun+4GDFWIq1MfW8+b2th8omzEMR7Mx0GtLv1GU+mBsJHyi6mW3y/R
   gnlvgCcDAR0yzVsdifSHBKcWRtki284Csdq7oA0tQOgpaVMNKzuXUwx8F
   p8isxfVHP3hMdOeG3/LkSKtWfFl/D6y1N0oomCywLf7CJYk1X+tWXiiTc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="9031926"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="9031926"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 01:32:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="16893783"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 01:32:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 01:32:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 01:32:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 01:32:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBdWEBvUXCjZ+ogSTdxL/sWEy/0NXigUPMCdRwKuxhzqEnQ38IGa7I8XmHSt/nak2LJCEnVGwSZ6giNfl0jcg5lbf8TmIPJVZOrIkzeBzO/5Z5yAwI6BxJVNUb6bE1VtmtIS+A65Jmjc4th1eneTLIANiwM1cfsmRS3zckkCJrv34bvBcHB56U1MeWMGibc+9MnHYiMcIzeIcxBq5c6xuS+C+tKKzjOmFcD2WNcmiyUIqgDMOXnix18cNw8cFmev+TVUx75prQL81UKnfcD2RoUoNlCARL7lVFOxlAvDwTJCukMl5tI+k3Ckhj/sJ5kKJxB2YSEoUPWptJuKD3OVNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JmNvcN1moLUYPhE7mO776JZTHfJ57U9IVKTNHgAUuyA=;
 b=LT+FKUiepUqhsGnUOF+EVloruFVgY/gL0Vy1kEYBPQOVdyyqz7bzphemX+TfWFHOc1kKORYW1ytOm+KoHGnLymyGZaxtkt77XyGg7EXs1VXMO1uHx3AtguQROd0UPJfDadHmuG5r+DQhw+nIGMMkADOmsGJ+MozKK3ouvl3fjaMotH2yQoqOZCHe930tl/bFZiDGPb8Bu2eMzpN2tJyE6laRjs1pNXs5EVHXwkrI9qCvo4slnWOrxrL4yGuHGPK3mCUp9dO8uh0KDXGDnNTt3nHOo3yI7nbH+Ifk07LZrS4A31d5HfdgmveW/Kl3KFLCesgW3srLZZRkJb0A7Nt9ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7512.namprd11.prod.outlook.com (2603:10b6:806:345::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Thu, 14 Mar
 2024 08:32:30 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 08:32:30 +0000
Date: Thu, 14 Mar 2024 16:32:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 019/130] KVM: x86: Add is_vm_type_supported callback
Message-ID: <ZfK2FCApVeB0xbAk@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <6712a8a18abb033b1c32b9b6579ac297e3b00ab6.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6712a8a18abb033b1c32b9b6579ac297e3b00ab6.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 71c68b89-0471-4f56-0e75-08dc440149a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gv8uUf4QrCm+0/VHhSIFydCMgf/H8J2te7Z798c6bwGAte9LyfgYxDytn4DSG3i6Nt7HD5/dwC9k6JAoCY4hwe91JCf9QsyYY9fQmGWo+sLEq3ztBmuqGaBRup3MHQP3+0LNHpkoQb23WUMl8P2jrfxvdiYWt8WArUY+9ZGuZRLHZYl920v/0LO1OieIvuhDdk2mc9+aTROMb5kzif3y6e+Q/F3KzQlGpDozb0hRMUcd5qyMB0CTmnxI/YCEFShPZyZJXKFfoDA8qgdJ3rw8Onk++tIudnjRQ7kZPUR+klax8DiTu5oIY/zwG/hD4dXoNXtveu5KRKGHw2T56mF2rLNYmj0WakbpdJgcx4WoYV+h3J+HR6kuIStpy1DHoubwMpEt/UaPpx4rMtFJJ8KMSn4C8vf60Hw20bEtQshGjUxYRIRmzOuSP2gO67/uKk5x2vdRojirQ5boRh4Qk+gorVe3v7VF6IaSpGnFUIj59G1EgeN84D16/Z2nTjrszFHfpoo2kzFlkRPOjwwDEmELyyT2EfK9SsShgufSIDiI2YcuhhMSYZywXjnq4xhpbUzHwvseAZCj9/XB1IKOnuk+OlGytIpUAZkiTX5845s7NbX9uSPKzQqfHhYk4OoYAVv5uF+zRmFkinlzIg27PvVDLzTK79xHm/po8KB6DkG4KPg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oei7QqfvptkZy0lFE0E+A5g6D4Sq/7eQsEmOSDQLssAIdVC0VdiUdfE2CUNe?=
 =?us-ascii?Q?9T/y4nV0d3KeBv2Y7ZkJ+vjjUMRiD9pMTPm8xaDynakB43KpJa5m6kytDj0B?=
 =?us-ascii?Q?3V6W1L9QE8kKOYmmNlRGtdP/PN1id9zZhXnVqpKxZv57rxLfkNSJ4YZEfa2L?=
 =?us-ascii?Q?RaflC4KNu+/HOn/W6nTt6UI2LFMsWk/aCqVhTvI4FwXetJIqBfnZC/IYyKIz?=
 =?us-ascii?Q?+APTgzK/rVjTRM8BN0zB/oYNxRF8bzz88yUlmn66UQP+HRqv3WcRV6BiiCh/?=
 =?us-ascii?Q?uLwpXYoNQCmciLPSGmKOXxK1z8kY3n1Rp0oDakvw3nMzClXaBiSst9J63pJT?=
 =?us-ascii?Q?QkzVCsCj0CqdfkxY/zMMGH464un0Z2aixkgOqHmZhGpzReDOFKJTsPJxzQYI?=
 =?us-ascii?Q?fj+5y4h4QH/PiXy66OpsbTACnemFADCn/s/jgw9921U7tePwPjbQmxmjh6RO?=
 =?us-ascii?Q?9yr4KbhRzHKrS2ERcI39TTzAhjgH6UsfPv759rZ3bldXNZrgomespOlQRbNi?=
 =?us-ascii?Q?O9uD7ph5oO7OZ0eABLdK67quRzQWwAtAMlJcRqm/5HpZs4iYeTir8nwkhQUS?=
 =?us-ascii?Q?rgHaKb9/+S1cC2XGd4sX/QpMmw5cvLAoWagIXgB99s+KBSvp1fGwOAdtHflp?=
 =?us-ascii?Q?OUj8ILPcYGeiO395AeuxFW+iJa+Mkxvy0lbmSK3RPp55lZABsWESRexN1cO5?=
 =?us-ascii?Q?ymzITmqy0DisASirxVoPHKF94BfuThiZgvvCkfG/33lCYwSwSyMIUjkaWA5n?=
 =?us-ascii?Q?lrsKBSJ8Aai3SPIUH9tPPpdwahHH50scs39CVU7ZpM4xPm0N2AqkF7r7/iXz?=
 =?us-ascii?Q?MSOPaPS5QNQHGCjko6lBlmie1aO3iSzCVYGYUZ6h8euLkGyydn8V473k0zHj?=
 =?us-ascii?Q?fDoNoykGLOKL4kzAXdthPKbka87b1NGoc1pnPUKUnakNg1DBXCyokIdkdrmk?=
 =?us-ascii?Q?amINoMn24lU8hr2Y+aopBdhhadU/elCQgplT1ogRHp1dSakLFCqCHICQHhRg?=
 =?us-ascii?Q?QsOYxXWrSBqRBlGumM+Ccz9kB+ZLqN0iN7OjpvhnuIKCoeTRyrRsUZraxgVA?=
 =?us-ascii?Q?cINhyHYbjsXEcqBYY/kARkQ3/XcA5hTf+/w23da2oXk65wKjXG41CNV6Cg8f?=
 =?us-ascii?Q?qp5HO3EQOALzK+z/PTRaKA1UfFFs9xMzO0ryQuEB5DypkAs87zyfiSw6Nc9D?=
 =?us-ascii?Q?7BaFlOZl+gmn8C/fPWvVVZUCBa7bEu/apTsN9y7sTzxTZq97jvrUNB1v0aAC?=
 =?us-ascii?Q?ayuGfGvrI7j4VPn0m8gYEDOcsoiYj0HJebznZyGOJdCZnC4o8Eg+DQFgVeIj?=
 =?us-ascii?Q?hJ1B3XtPpR+J7h11VUcTQC3QZoAFK2Dbl5l0vxus6Asm0Pqag40NxmYT83oP?=
 =?us-ascii?Q?mAJvd8NpbFQEQeF5qOWjg07BB7+yj8Gw1+XGRBq5jVy72T7nHQVsY4kFhGzL?=
 =?us-ascii?Q?7QtgOUBpQxC+hcKGC9V2f8tOeTwONXDZpjmLjQBZlocSsE4BlBrIeWyMWke8?=
 =?us-ascii?Q?VwH31xlz+CoNboD2CqsWk71URjdGqBTJvGBp2BuqBr9QK+8OrvKU6ijB0zjq?=
 =?us-ascii?Q?U5BP4dDbQJH9igWr/WdRl5l60WRbeeVp8/5PEotS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c68b89-0471-4f56-0e75-08dc440149a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 08:32:30.2335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDTM2LSK92xTefp3dr7FtrViELvnxPrtIqgxmRpTIewN19QRTzU14cNfNDDRWs3tfW6fxovEUuwi5erfnHuP3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7512
X-OriginatorOrg: intel.com

>-static bool kvm_is_vm_type_supported(unsigned long type)
>+bool __kvm_is_vm_type_supported(unsigned long type)
> {
> 	return type == KVM_X86_DEFAULT_VM ||
> 	       (type == KVM_X86_SW_PROTECTED_VM &&
> 		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);

maybe just do:
	switch (type) {
	case KVM_X86_DEFAULT_VM:
		return true;
	case KVM_X86_SW_PROTECTED_VM:
		return IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled;
	default:
		return static_call(kvm_x86_is_vm_type_supported)(type);
	}

There are two benefits
1) switch/case improves readability a little.
2) no need to expose __kvm_is_vm_type_supported()


> }
>+EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);

>+
>+static bool kvm_is_vm_type_supported(unsigned long type)
>+{
>+	return static_call(kvm_x86_is_vm_type_supported)(type);
>+}
> 
> int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> {
>@@ -4784,6 +4790,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> 		r = BIT(KVM_X86_DEFAULT_VM);
> 		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
> 			r |= BIT(KVM_X86_SW_PROTECTED_VM);
>+		if (kvm_is_vm_type_supported(KVM_X86_TDX_VM))
>+			r |= BIT(KVM_X86_TDX_VM);
>+		if (kvm_is_vm_type_supported(KVM_X86_SNP_VM))
>+			r |= BIT(KVM_X86_SNP_VM);

maybe use a for-loop?

