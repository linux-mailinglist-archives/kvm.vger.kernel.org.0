Return-Path: <kvm+bounces-13256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E44E8937FA
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 06:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D01B0281F79
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 04:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49BB8C1E;
	Mon,  1 Apr 2024 04:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WLvt0k+B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A3F137E;
	Mon,  1 Apr 2024 04:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711944675; cv=fail; b=bQBEklJPlvCP30mgArCuAjrt9FcpeMl3izIGVGMTZZRgecHrcCrQSly/69I2uv23w6g/L4WrS7m77UOJ4etC1FGle0HvzNewUSS4xrZhTmcNrbwyqz+P9QwI5F0lHkWUrSQa6hvD74NKLaIsfrUSl7weIWviRDkDCzH3g2JLCAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711944675; c=relaxed/simple;
	bh=cTDICmy19kFkbYibxCOC/cTv12Pkfvviwhrm0FvjQTE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lSzM/oYqJ0ZvF//Fv3z7aq3gT485F2RP6SWcU+3hG0RummKnsRSxAmTCS9XMHy/4s6bh2AZYmWNq3lF7MrZeN0LnsQ7i4aKpFs4Zvd6M6fYOMVPhIBNpBOsRrhXGtIsB9c2/P/lZSAq4mypQwcUk9a0genssV1s050VcprxBLBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WLvt0k+B; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711944673; x=1743480673;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cTDICmy19kFkbYibxCOC/cTv12Pkfvviwhrm0FvjQTE=;
  b=WLvt0k+BFDey7xjeFGc+QEipNAu6Q9dXafmvBLusfQlJcUjAhf5lCVrF
   X6DxjmGQVd5BFJSqN3OSLMdthxta6+W5BtVkJpiuUZy9hu5lECaWR33Gs
   1yVTf60ndnq/iyg2gzigBWgHM4q6LLMA5RqhP51lRPLkotLwTr9eDyMBR
   VZGqn0zzDPXp2PL5nuimrZo7s6Sbc/LdSjAGR6IMajFnaXZZgPiHUvJ35
   v23cha3DO8TuElct6xmHOBuTlzNZq+sbF94JMDigRbggVRtvHJHQ+Zhmx
   ZyHZvuexqu8OU22JOobxL3VS6qQBn1LNnNulS9m74VZQPtJkWtKl+7oqf
   g==;
X-CSE-ConnectionGUID: 0NcJAIfaSfOct/kyTkvUTQ==
X-CSE-MsgGUID: hP9B7WiISGOut2xSpCKOXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="7273515"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="7273515"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 21:11:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="22036498"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Mar 2024 21:11:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 21:11:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 31 Mar 2024 21:11:11 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 31 Mar 2024 21:11:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8tl/K80RmlpZzEaFpo4+XeR3OSvRjPaXNgA4ZYqbXbkeLIAfda8pp3xxz+KIGI2ue9Pi+6anDkfIghWQwsA0lnalbHU6VVs7GVLE5i4ocuKcQ4PkFJ/mtWkgeZDBGnjRumVJG2N/9xiKMferT/JjT7ZPwy1dW1Y2ACe47CWIOMi2fRJlza4Lb6/QXpdg/IDGVjmohza1lJoNgoMqKxqCc9O5TmtDV2uADPpHNo0AvSvow8nGNAAGvNP3E4fyOeyUac2LkIAACLSTNoTunQEJgcNK1EKI3zeUW19PCPjqt6iA7hejk6orxcoXkcy4BEnCQQENguE426P8PPkKBZJFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMAx18D6o23uMDdZ/B8+YW0ZoRQZpdElh0Vj0y0cIUU=;
 b=XXiRtuu7j0ySs/bO5P3dkQcqZI9UNd/ffMftWq1XJxfWmVT6sDY4LeFXun+i71In2JO5Jjm+Ei4VIYNqf7kS/qMZKjcSwqtvwY+w9p53XUymd6LzDchIU6L8y4J0n86XDbCjKpMfqc+7soqJPePFnxPYxe5+t/k+z8FK0Y9uxtgo5oLZgC6eWi9WPTOsOBN5FZuNDAJmocNyzapIW6KZTkmFssx/YvYOqhqgmrZBIJ231c8VUd4bO0LT8DlN4bz9seEt4/auPkAgRDjkeNf44jTU0QM/6Xf/fYZyMNa0kOgvcelLhJy/59PAtg2wlJw0HD28eDwujgFXnYSOiUov7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB4900.namprd11.prod.outlook.com (2603:10b6:303:9e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.43; Mon, 1 Apr
 2024 04:11:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Mon, 1 Apr 2024
 04:11:08 +0000
Date: Mon, 1 Apr 2024 12:10:58 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Message-ID: <Zgoz0sizgEZhnQ98@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB4900:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F95ATfWgmAGuMhE6cWWqF1lwp6oxPTgMXHvQ5D5KGA7cKciLqx+bpURn1oE/EjzhCQzjIB9SZd9XIlf1+XOW+XWe4iiZ3Ip0m3h8mV632wRCzLGcg1suxiWUE6JJj6k6RLnG7sMAQ+NoyUPV7PGNB1fwrhaPW4o93EGa8GKYGdJMQnwq/p4pqInkd+4ta4Grk7aJg7QacPHbrq6sYWHWIjFgoK4cneeQT6AbMfbcXAlVgbQrhnH4DNY3OgAOBmiWQIBm9CiyU3ncppr7dvE2wHoko4zuYxDCqJFVFeJUCngPoPBmdEdczH3UeRpph9yJw2mZz0F8pCxymcFh+53TjTxGkKRbXRLAx5NQUlYlTVnB/rGQnFnwE5gNQSXvIsHDMStDtjZSnF46jJPcfUdUjPazIrn7NxaoVaMbH9hDRqelL0v0yLpSycFSeTg9USg9zPMXuWrrmpNeMJBiFVcAb/AjSZku6XT2RaHpIBNGn9AeNX01f3ttBHmej9I0kc8ctbMadfdPYcI0Mt00FS03YQiuarNpvkPFbHGvTubC9+i3uj3pLkEwdq54PoufliGpFh5Zakue5XUnSsGmekxJFfVD1vpAtVZgTHtyrvDpXnAaWv8hr+T+QwnFNUbL/d+j1m9leFHAmR3nQd7AUyehQihY+QoXSdteslw0y4iShE4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BuLORrxWSyU5vtXi7bmtokRJjH84yEAOI3dV4avoMO7e/jpeNyg0uPEjEwrO?=
 =?us-ascii?Q?xZrZ9axuvbCDtwXMPOvp4mf5mOc7in6j0SAbO2Bmnymzorcnoz8XmJWqGTXy?=
 =?us-ascii?Q?3FpioOweyPql4I9nA247YMDvY04qNR7vl/8Xx7Znz1a+M4jlyzIMrQdAgy4h?=
 =?us-ascii?Q?RADxZJsDRCSo7rbVktz/dQ+mfSZetVzozWFju2jhB8Im4ycXAI5dxlSjkkPp?=
 =?us-ascii?Q?/MbTand/8nDtnVxK2CR/EoO0pBoVJIrZi2qxUM9qq2Ui5nwFjDMDtCu4cYf7?=
 =?us-ascii?Q?ua7+aEOmmwTWaffqO+NYX/9+6eEoCILc5tEJi+NcZ+4OZAE8BCi/aD81AYLw?=
 =?us-ascii?Q?Bd8phzwzHO7/+whmP2YVTGWKfKZe60z+J86xrAj28cbqOlz2zAWeuLYtl2fC?=
 =?us-ascii?Q?RHcfawrZ0HqUS0GNtPhuMH5UK6UGByPIIOJiyugrx70zM56CVj+4IPZ3kjqq?=
 =?us-ascii?Q?cXQcxsSJZvu8ygbC2vZyfjyoR2YnKEyM0gG0AkxiWq4d9nHOyn914oZ9nn63?=
 =?us-ascii?Q?7KHOk5gI40CmDB1exOtm1wKuLpO5ql+eIrg+hr+RXyj2t+ivWRLmrFkFBuXx?=
 =?us-ascii?Q?WkS26HM1vSA4SLmE7YZCGuczNjpvvdkOCEn6nbXDbAp5RIEvLHDNsiuvfbg6?=
 =?us-ascii?Q?wlrQ63MjCD+hmW05luu2SE+9BfsR8HSliuGzPrhURB0C17nNY7eKJfCi21SX?=
 =?us-ascii?Q?vlusck2HezvAtvAFY71n1i+b+UKKrqRhnkWbregsNOjzHLq1Hwf6ycBCVeSp?=
 =?us-ascii?Q?GkCRnhxjEyfs0QaRvcQO8zkgQJi9yf8HTTejgmByPgnOX6xNm+is1JInHcqv?=
 =?us-ascii?Q?QM5sf5HY8yNBNjLdGWO+T2dOtCI+4KvNqMIrKeIohho/djJP1L4jmREW2gvl?=
 =?us-ascii?Q?07PBO1+cShrsj6VEbPBMVjNr4IdarqslFm1nVjg+RNYrrjerz/OT5RssUacq?=
 =?us-ascii?Q?haqi86x05O+drms1RHZqjLpg6i4J6b090mf4lZsSuR4I4rrCoxDvnlklOAsf?=
 =?us-ascii?Q?ukDzDJFdaw7ki2L7QdMxEzs5OPK7qNciUBntzICnOV801Q/p07g5cawDhPM1?=
 =?us-ascii?Q?WQTd6HET+CHR+M/evTg6VsBFgal6HQ0L18PccH7TO+JZUxgiDHEprYD+Vpwy?=
 =?us-ascii?Q?p/0vMEIq3xUqolfrnCbcn3Ep+Xae3rZxkvtmynSwRab6JZ/pz0HvM+hKbU4v?=
 =?us-ascii?Q?opZt/zOaDkEC07vtrfBJzoC+zsgZJm0/6BL6f8w1cdOttjdBVg7CS83aXvqU?=
 =?us-ascii?Q?3BNPQYP8VX+LGsvtWi2YEcToiQzndEHlupSIFbT5AR7QSSsuUwJT/Z8VrLUV?=
 =?us-ascii?Q?DbsyIqjd5Me/4/8RVoDjeh/SyilduJ8+0/iB1fmJmrySGL7XM874QOn8Of5A?=
 =?us-ascii?Q?5zO9zQASMYQov97Sm4KI1Oh1JwRGuIbcTzjbloSxDbc8iuzrnYwF3u5PW5GZ?=
 =?us-ascii?Q?ZSQTBsDxABDDHEQllwgJsx4GeGGggcvUJwTK7ByPUKQVzLi4+yPdgvFfMAXP?=
 =?us-ascii?Q?8UUNNtbQuQ3gfXQDHJH+HEmvOXelwXLyEndkVj2UbnZpBf9dufFVRKw1xUeP?=
 =?us-ascii?Q?ns+UQ/42VbrdkcqhcW5KMfTSxyrWV0m/PvDzKjlf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c68f1f5b-ff8b-4a78-cf3f-08dc5201c1a4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2024 04:11:07.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8aJvBRUjOBTH4MzJ4zrMLfrSXFb7kx9URkWw+J2sOjIRxwIuEaccv5sgmTDWOMpfBmpEY2PrRHFUSCWeZE7Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4900
X-OriginatorOrg: intel.com

>+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>+{
>+	unsigned long exit_qual;
>+
>+	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
>+		/*
>+		 * Always treat SEPT violations as write faults.  Ignore the
>+		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
>+		 * TD private pages are always RWX in the SEPT tables,
>+		 * i.e. they're always mapped writable.  Just as importantly,
>+		 * treating SEPT violations as write faults is necessary to
>+		 * avoid COW allocations, which will cause TDAUGPAGE failures
>+		 * due to aliasing a single HPA to multiple GPAs.
>+		 */
>+#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
>+		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
>+	} else {
>+		exit_qual = tdexit_exit_qual(vcpu);
>+		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {

Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
#PF. I think you can add a comment for this.

Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.

>+			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
>+				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
>+			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
>+			vcpu->run->ex.exception = PF_VECTOR;
>+			vcpu->run->ex.error_code = exit_qual;
>+			return 0;
>+		}
>+	}
>+
>+	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
>+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
>+}
>+
>+static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
>+{
>+	WARN_ON_ONCE(1);
>+
>+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>+	vcpu->run->internal.ndata = 2;
>+	vcpu->run->internal.data[0] = EXIT_REASON_EPT_MISCONFIG;
>+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
>+
>+	return 0;
>+}
>+
> int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> {
> 	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
>@@ -1345,6 +1390,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
> 
> 	switch (exit_reason.basic) {
>+	case EXIT_REASON_EPT_VIOLATION:
>+		return tdx_handle_ept_violation(vcpu);
>+	case EXIT_REASON_EPT_MISCONFIG:
>+		return tdx_handle_ept_misconfig(vcpu);

Handling EPT misconfiguration can be dropped because the "default" case handles
all unexpected exits in the same way


> 	case EXIT_REASON_OTHER_SMI:
> 		/*
> 		 * If reach here, it's not a Machine Check System Management
>-- 
>2.25.1
>
>

