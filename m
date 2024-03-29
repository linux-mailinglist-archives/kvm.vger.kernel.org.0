Return-Path: <kvm+bounces-13046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C7B8911F4
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 04:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E98461C24D9D
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A3E38FB6;
	Fri, 29 Mar 2024 03:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JcvCSfyf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF3B33CC4;
	Fri, 29 Mar 2024 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711682712; cv=fail; b=dnPHD92XZj6YGV8QvqNzFtBbntVz56Fw+g4yzVkjZBEafD4qLP1IOl5Cb6lpc0y8RhtVdaodIcXg2Ubh1isbbJ3gzmZSNgW1Gv1P82iBZQHqwEqb3l6I8Nu9dYjmPjYDvMUe5EQs69UBJL+4pv8esa0CwZGs7/rgxy9WsujZxtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711682712; c=relaxed/simple;
	bh=YSx6a9q2mRrSFpDXBrQMfGxZTcL6EnNEODhoJHl6/io=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rVaKI1y9FakdKpIylij9qSUAKygP/axEdbsurLPIRfFqYKzX0k+NGIp9ZxJrmJPRNBlCNlNL7nIUO6YxadtbA3czLEqYWJmhfnf2AYfQ8gA4gtgi1NmQdbA574lheR4E936RkQ61a1/8IALIKto+ihsvWiOtaP1XL+vlzbLxGtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JcvCSfyf; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711682710; x=1743218710;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YSx6a9q2mRrSFpDXBrQMfGxZTcL6EnNEODhoJHl6/io=;
  b=JcvCSfyfEHXtqxZdsK18Up+9KROlvYHbtjU3IadGldiOx8rGSfdt6PJt
   7hrXvhYM+5VveJmjw3LnoV7SL4TyC+OSibzd5bXHAPcEOHv/9DXXt/dr/
   eB7k7QV19nU0Qr2C8vUsUhHW7xli/ilY5hpahozXz0mAC+HR91OplZCqO
   lManjzD0WIEuE6vxr+UzQLMRmHUrQqVIQ6zOPNhDY7JznE8hKQIDMvrCo
   wvC2/R16/sek3rkxPybdmE6KS8ksgyHCRBto50iaaE9q0ZPmGy0wMhczo
   nPOzA71NHwg28qwERXh5XZQY6S012Ol49exoI3SBNjZQwCoS64LJi5eTo
   g==;
X-CSE-ConnectionGUID: MzQO/v0qTG+McwFk9UHjlQ==
X-CSE-MsgGUID: CpPI25x9R1q/c/S07izBXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6808548"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6808548"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 20:25:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="17496139"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 20:25:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 20:25:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 20:25:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 20:25:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 20:25:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdsbwRC2qKoPERTigi5GOUO8Dse9Ys8lAes/WdpVvyxBq5OME8QIMJRqL4pRg2704cnlU9kRuF/5yxaevRdJsTnTgbFKEnF556g9eT1NsZcwMSILK6/+HMyRngWdKsgjQnVHCyEGMVNLzoJytb+lhEmokjQDhOq8COtf/Ud5kwDkLn/n62zfOvf1mnPxYRpHoglUC+jgOjbacss9XwgBnMHWQXauq5DB45FNnvIZpr1RavFmdUFILnsU9Cs4Nh4ekcqDYZSkckoqYVhGkzMIz+Ub1lnMSUykgx6n7HvhxKi/MdNUx0/r2R3MZatr/TZDkPFTN5R2bWMf2cZ2YzwJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ar6ZJtvES/Zi7vKxT/u/ThcA+CiiYTB+OYvaOFbiL9U=;
 b=U+Y3ijpsu2ogNJn2jR9/xeHUX6p0xWc53hoHO48DVmZnaoexdUodkzKq0RQPdV1XpiqE9fD6gtAkx7i+Is/ZKPja0hApdk2h+WG+CYSn3wdp9mw1mQ9brVdIuFYa8HA8YVQljRejOaVk+q5ejl1A7lJOAS4gflrRiuBpPj11uXUPbkw9GvJhZjCq5DQfBR0RbLeIJ/KkK4DhcCpukj01flcA+SXYOVHg4/mh90ItMWaiOVfki5lIDG9alFksD1cJLxJKadhBspL6FPshQEP4lfwWnQGilSF6ADl+n7UtT/bg0AlC79++uK8Faxug2zjXrdFt9w/bVbROmW3BANStNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB7711.namprd11.prod.outlook.com (2603:10b6:510:291::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 03:25:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 03:25:04 +0000
Date: Fri, 29 Mar 2024 11:24:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 097/130] KVM: x86: Split core of hypercall emulation
 to helper function
Message-ID: <ZgY0hy6Io72yZ9dF@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB7711:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTZdxKLmow+fbAD4gJJFg6RI0BoUS8MiW1daUfYz2K/QXsPbdkJIMhzXlrBBUyidbrggLtwmO2SqSYxa3Xvi8R8eU5xwoafxqLTrHUbPZCRH+SNqQp2A3TMGPJKyzAFLtRCOmdXwxzZ54xiFhA5v5qrRR/Dg7vmWPb8MBopdPTJ8su2zMW4bejaMZKwFbWgchAOuLWKXDkZZk+TzvgDttIjZ2CI0xZkW97SthXPgJNuFrEOhjFbRGScRVnkTVk2lWbpkYnvDyNwEAfQJUKGQeaqAUwoiqiBIWRQkWZIJPGOFOH5wsE2i3s3o2n6kEoROzfnEifUhDZWPNb4sscrp/BN8DuM0kV7l05WdekY2BMYGXYPU58ZufvuW0c0cabZIwq/8mJGKkkpcVbFCWFMOYvH5qiS8i0YOiVULCoKwbBDe8roAlUgf4+hUyN0wc1wYskSWLSaOvrCZbXNvlwaGxdikXyOO7OStqWkhbOZNZb1EKn6cQpOpVjD6LmhrQ+StnvIAVxbaoFdPmXUmhRQBaokR7qF2CE+tCFr2dbk1vQzE8BFQYIVZgz2y3Ih0XpSjkJTzMh/y6LyWMuVsHKqcsjMp/mVVLN1jp/Kosd3AI+Ew2leZrel4wWheeO2FSigArXWoonpDpPpuUbku6KDg2dJUDnEExwmDsDfZJ0JdO/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iMX9Wuqx5Zs2tPy825weMjD607neOLtgkcpdQykztrn90AD1tTmDahdR5ni+?=
 =?us-ascii?Q?8EZoUMpxAjAOR2KaadZC8wp6WLkQlj7uSlW77zaBz4MthtkXhTqxtROYgLyH?=
 =?us-ascii?Q?9/OZATdlpfdQjbwBUdrE4GE1qx/C9ptIa4p2FDzsqZ2jYfmUrqMaM0tEmGZ8?=
 =?us-ascii?Q?2Yz9TlRg6VZCP0JLkgYVeie8DCv2Je0VrGwSqfkcMMw7wiYBxki/mq0rzszm?=
 =?us-ascii?Q?0Y1wJtg+OBTmiOIeqQIxPFlLEq76OYkNxdw/F7tzk29HiWUlCPzxvbaOqRU6?=
 =?us-ascii?Q?npB+5jxF6DwWd0YDr6iTNmFIJkyDTd0qvP8z1h7StMnRSpqdk+hvaJ3NhD3k?=
 =?us-ascii?Q?mwX0/cnI9zBr6buLc3OBQ2yV77A/66TVyffBJ8s4S34b48jtqs2kjG4Gjjnc?=
 =?us-ascii?Q?g3H688pXMPSmYDA7mA5U2anNcIXMEvc8XfswveY3KXMVQVf23Fl3lh1wDhdS?=
 =?us-ascii?Q?JGtiSHQNuxVOW1sorCpIqOyMVi0XJq7/1ypgHa9I44oZgUB1U1rTnrjIxlDM?=
 =?us-ascii?Q?Kblp6/SlGRabAOo5SV61pxu1h2FG7iiRBdZtpJFJ/1E2h1sCAf/5TevOUFvx?=
 =?us-ascii?Q?PYbUsH3QZLXx6GbCVseOjoULtRlWqTk4H+DRGKLn5c/joP6DkDw1Z5hj8kTz?=
 =?us-ascii?Q?J2uY5FLd9ibXPNXyDybdVIa5x/6FrJvHgBSpcgkZcqKqW4/yrC/M+q6/vXqL?=
 =?us-ascii?Q?43HiA0scBND81Jo38vd0AGbJICqGnkTdaFmCAKw5seIaI5s2Tf3d1aLJmAkX?=
 =?us-ascii?Q?RSlJXp8FoY1FlWCxFY6Fep5+A8JOYthPgjnON7If8rqRYNj8clviNQ+ASz4I?=
 =?us-ascii?Q?YMnEiCxJzTMRFyzhQ6iu4bVJNmz6ZCoS9Zuhwcm9NaLtINKTuFpA5B+Gjoxe?=
 =?us-ascii?Q?Fw6qzSpOpHKScyfsRG39L+KqmlC/b3bje1yVn2pxc6la/rxi1Hccnas8RN+V?=
 =?us-ascii?Q?4/9UlFQgg92O3IFUZYk9sRWJmcWXGVu5eYcBgfrIjUESFsb/RdsEcccNVdm6?=
 =?us-ascii?Q?7qVvHBK1NBh+j/JoYXPRc3CqjyJDIuoDvfhAsqssJzu8Gb2BARdGyzyxboOb?=
 =?us-ascii?Q?jFvmpKuMXWEF9zrRlrI1ycjtmM8Es4X55g0EhJchTVlT14gUk/b5Noha8qRy?=
 =?us-ascii?Q?A5ExeQmb/A4HdGWVkyTJwzBaoigpdecuEhlvUj4JNnFWzbkEZl8KcUwBesuD?=
 =?us-ascii?Q?Z3TGhHlwtOYudz+P+8rOtFsadF0Pcu7N7sTwe20XCFnZ43uxGMmrsPvsA37C?=
 =?us-ascii?Q?WEYhnfyG+wzPfRUK36B5vkoT2BuTziCAhR6RgUcSLnVZaQ2HjR94p4XA45qZ?=
 =?us-ascii?Q?JNTjnncyvXt9jy3gWKdAQ1ZivCdmkLQuf+ypUtHifmnjRBmSzp29dFuqfo8t?=
 =?us-ascii?Q?nQewa475eOb9qso5cThi4g9qpyihLDD189dvVps/9i5Fvidh69ecKRTMfVNU?=
 =?us-ascii?Q?SjjWNeZsm5F4TZqzQOG0APibVpVjb7xtDrSQRczXgPN7mecf+rKIxaCqfMmC?=
 =?us-ascii?Q?zKOf4llxMTHQgte8EJD1A7D6YyOMP7R1SESFP5GijjFzDupcyZ0aQGBicDts?=
 =?us-ascii?Q?eFoR9Mz3aHufTet9gkcEAMfvZMKiPPQ0KktkhHmp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d3aa9e-f07a-4598-c6e3-08dc4f9fd394
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 03:25:04.9020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QQw5BhmpvY92i/mRtPpEhlI6tN332Q44kqTZ1Y8jaWGxV3xE5SY25mwrsq25n9VwhRFbLmnfsGvG/0OdZbDwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7711
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:39AM -0800, isaku.yamahata@intel.com wrote:
>@@ -10162,18 +10151,49 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> 
> 		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
> 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
>+		/* stat is incremented on completion. */

Perhaps we could use a distinct return value to signal that the request is redirected
to userspace. This way, more cases can be supported, e.g., accesses to MTRR
MSRs, requests to service TDs, etc. And then ...

> 		return 0;
> 	}
> 	default:
> 		ret = -KVM_ENOSYS;
> 		break;
> 	}
>+
> out:
>+	++vcpu->stat.hypercalls;
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
>+
>+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>+{
>+	unsigned long nr, a0, a1, a2, a3, ret;
>+	int op_64_bit;
>+	int cpl;
>+
>+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>+		return kvm_xen_hypercall(vcpu);
>+
>+	if (kvm_hv_hypercall_enabled(vcpu))
>+		return kvm_hv_hypercall(vcpu);
>+
>+	nr = kvm_rax_read(vcpu);
>+	a0 = kvm_rbx_read(vcpu);
>+	a1 = kvm_rcx_read(vcpu);
>+	a2 = kvm_rdx_read(vcpu);
>+	a3 = kvm_rsi_read(vcpu);
>+	op_64_bit = is_64_bit_hypercall(vcpu);
>+	cpl = static_call(kvm_x86_get_cpl)(vcpu);
>+
>+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>+	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>+		/* MAP_GPA tosses the request to the user space. */

no need to check what the request is. Just checking the return value will suffice.

>+		return 0;
>+
> 	if (!op_64_bit)
> 		ret = (u32)ret;
> 	kvm_rax_write(vcpu, ret);
> 
>-	++vcpu->stat.hypercalls;
> 	return kvm_skip_emulated_instruction(vcpu);
> }
> EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>-- 
>2.25.1
>
>

