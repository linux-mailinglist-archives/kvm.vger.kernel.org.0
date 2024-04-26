Return-Path: <kvm+bounces-16029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B79B38B3309
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 10:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EEE2285E2E
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 08:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF941422BC;
	Fri, 26 Apr 2024 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H6wycrMi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541E6140397;
	Fri, 26 Apr 2024 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714120370; cv=fail; b=JR3LX+vMoh3tOn5TMlvoXdjdkVepBIG0MWSGPd5sMbO1+rVkA4Di3R6WOSIIPVWUjUfzqOo1Zv1IUCPpjIxvu5Tdbnr/Ljn+ZDvtiiEhfZWY77k363J8W0najeJ9/b5x/AxeilagtAdEOOi6xCgZd6VhzItzY7xuiZ0RouU58QM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714120370; c=relaxed/simple;
	bh=KoHX/AFDfJTBXCOfyqqk32fLSH5Im3+LqULf40q+Yxw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hab+2HdJKpE4Y/QI0DNTIFf1j8y7VPaPOHZAt8RSARSUUSIAnVINSl+/ofsSM3rOEmp6t+KejDvaiusPdlHYoVJss32lCHVFJv4///fBArO2/2GmPimRQPgcyvbuia+cHIr6FFGXU/9xeWR8D66xd3xeVz11wLfmW/UhTlQU3Hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H6wycrMi; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714120368; x=1745656368;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KoHX/AFDfJTBXCOfyqqk32fLSH5Im3+LqULf40q+Yxw=;
  b=H6wycrMiJfTMRfLQJPqKLjNGzy0USF3OXVtDoNcsj2LHJUa6hrGNoKCD
   2u4tCJpII3xuHxzcQHxN0s9caQz29s+v43+1tQuBGkl5vS6flu3BYhwId
   4Fh7sHLTYVBB/JVQ0Cq/6fYWmMY8DusY8DjBGkfDI+AfmiJGl5M84NGDO
   sby6XUfuGt8hDAaNEzkTVH9bVIbCYclnoE2q+Il28g5GrMume+NI3KNz5
   ipHICrJaUj202l1FHoma5eHOofDDIPGPRScceq5/dKFtGuOM8FIQlHdod
   /DoJCN5fAPlpnUBPL1nVEB3xhFy3u0vhf/GeDS5uJMUJggwcI0o7ou93T
   Q==;
X-CSE-ConnectionGUID: kAywV+g8TAW+NTEsp0jykA==
X-CSE-MsgGUID: zoFQmYsYTeum6BkXbYns+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9719653"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9719653"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 01:32:47 -0700
X-CSE-ConnectionGUID: /hfn5CPbQ/ez0/FN8gfTOA==
X-CSE-MsgGUID: kYq7gNkWRqCXuEXgeyf2zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25226755"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 01:32:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 01:32:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 01:32:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 01:32:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu6hUljJP29q/ZD18RwBIm4nVr0vTs2n3GYFlm4FYo5iD7M+uR0LkQAMfbxvO6THdom/eJNSie8j5RzFi+ANNUzrMtyvx02n/CprBz5nuT+fhKYeaiWVZH5yfIuXD5zgrxHilLlxoJc7C1UilCR2l6jfhwYRb4XBesE1TvrF6QCvJ7T+tWtYiiJxvxIwwYiCOKH+eDaZhhiRWASZNqVUs7b3vKN5cBlPxKZuv1b9o5EdmTQEGMpkdJDucEoXpGGgQXcRtPjlmlNA58aSSB+x+JEFvyj5U9xsdfVtwUBHYsAJutDYFhag9iybbxanqzITQrYGwElJbcN7rL9PCtMNNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdwXhGBigjFiXm2rqQE8J1qHHH4OMlFT9l89sbBiCUc=;
 b=PApuj4vF7dg9rhp1sosQBg0qtTHEsny+g4nMXK+0g9QLHlSog75iopakakkWngggxO9gYRxVcaDi5Gry28XqMqyxEgqSMwx0SyVwTHdYsBbgg0NCNBSdLhcX92/NK7lXWtCWxrFaOusBrj65WKwXQMF6JCpKy8pFQdjoj5Fl9aBn8tqPHlB2BmFCgxwl3mlHMHGq7YFxOibuM9968Dbu/nJwGqTIGBaG7VTn3lniJSLDcdZ9yqFE0chLyHS82dIr0/AiW8TgOLY3N8+TijpvM+2/qWnOGVjl8eiVR8MZlGRg7c5s6TMxDZt8in6MMV47AzVIU1Zd+oNXoNx1mBHk2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB4977.namprd11.prod.outlook.com (2603:10b6:303:6d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.19; Fri, 26 Apr
 2024 08:32:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7519.030; Fri, 26 Apr 2024
 08:32:44 +0000
Date: Fri, 26 Apr 2024 16:32:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Message-ID: <ZitmpS0lt+wVjRwl@chao-email>
References: <20240425233951.3344485-1-seanjc@google.com>
 <20240425233951.3344485-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240425233951.3344485-4-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0130.apcprd02.prod.outlook.com
 (2603:1096:4:188::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB4977:EE_
X-MS-Office365-Filtering-Correlation-Id: 9608dbe8-a805-4c34-8448-08dc65cb71fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mlbSQU4bToopukNMAE3aqtPt97RmVNhHkSvMz58U1XGHKrk2X1Q0/yfJ5bA/?=
 =?us-ascii?Q?Y18Gm8qj43I0HSfNo1I6D4FQHhVDi4Sw1k1CN/qvQ1+8wfYUKU8XlX/QT4tt?=
 =?us-ascii?Q?FhpIprCjcHcvgOgF1zFjwunoGT0Pig6a5+bbQt3/nHzJoE80Ysd13eI+FMG5?=
 =?us-ascii?Q?pp6kkCVRzgMhvdqkyS/k5uioli71Vho7YxDCcBcpp7kkRZwA+JqW3nlvhpE8?=
 =?us-ascii?Q?wMc6GU3Ozthmc/DYAKfaR4PQUaothY7ns/sPNYYVeHncjrKw3aHWhGgIWogj?=
 =?us-ascii?Q?SBkd5BZN57Pl/GILBciQswAGq4jtDckr9dZV7n3n7xvFBJyh47YMLyh+4AHT?=
 =?us-ascii?Q?2ZviN+f46D/f++TFxO8Ak1jlxlaLnuTyJd0yL5n806nfjwhLvV/0GQGrhm9j?=
 =?us-ascii?Q?n6YEh8coFA8UW2ZiqKmwaB2JNL8SjY7EkbV/1YwTBCnyP+VqVqvQxXEU80DY?=
 =?us-ascii?Q?L08V/Y2jgJnfw12ni5RWyuWSaSQfOmyZrd+QkZfYWWikbblnkQ/VpHLpeAxq?=
 =?us-ascii?Q?5xDi+yNAGy0AkG6XXag4Tw3SG3ggcx6E8qUGw+DGYZqwVfCUVb0+GHOvhrTJ?=
 =?us-ascii?Q?oYXDXtWzXP/AlIF8wAvsBSz1KJVbziRpe8x3UPP6f5mbPyC0gequL5BrXtfb?=
 =?us-ascii?Q?jJbORfPBankRP20akgeFsNtq/A2hDdphnmVprtM8gh5B/BdbmSZVfSPv2wPb?=
 =?us-ascii?Q?6dbxJuoLLloEN0h98TP9JXNhPKmf/ahy0JaSkMrv6kiusBbdmQAQ0Zu7IeYK?=
 =?us-ascii?Q?lI7UCGO7uv2iCjSiuCNVOfSMYTQ4HwGMht6YJsbCqqNM+MQOcJB0I05gPFp/?=
 =?us-ascii?Q?v+G7KqxeGvvhPsBu58QFTLVcpqppHzj+xa7RTuuQtSqoFWpfYc6+6J4mQg0y?=
 =?us-ascii?Q?UFlo84wqf3IBWX1n3W6n3BvnIFH8vhigBkxT3vJZdOuGzmcfZecpcacPDYNa?=
 =?us-ascii?Q?f8eQkjTS2Oc+nCZxvCoPuFikZAF3OuG+KRd91cODocPZvIgDKis4o7EzlBN+?=
 =?us-ascii?Q?uqzuoIoSm9Xk/kvlTMRPdu9Wt6RNXCxRoqaILBxXOvEiJFSu2MYapbSULc3t?=
 =?us-ascii?Q?6CVW11I0eg2LvWEZgyRLRyhJgXes/MmvbbPoYAaeE9PerN15A+CAoMqfnfDU?=
 =?us-ascii?Q?SI7koVVpz6Mv+KqyAJ6k+fNvV3su5EHUib9SsSjA9XLAXEGlR9HS5LYfITa5?=
 =?us-ascii?Q?mPnOytYhxpSKNh3bNI6wOfpucfwCt2YAbv9KPe+ePqWULpQI6l0BlvIRuF5S?=
 =?us-ascii?Q?HJJw1xfoxGoSFNF5lmgpftIGMWG+ZaEgyz72TXkitg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k1ynHgLQKTth9aqt+Z2GLpeG0Uh9NlfcBuNmDYf126kQtZ07B6FaufaEDEWl?=
 =?us-ascii?Q?izziKFBZhaUkN6GmVtCCOD6L4QvalRe9gwjOQuCWNXwXDSqzc2m+JvSuX7JE?=
 =?us-ascii?Q?q6dKItRVN4oQFiDZ7+TB7nKlSn+AbM+MCJl7VgQGplSPgsICMAW7W7ga8xfh?=
 =?us-ascii?Q?AEXm2G1x0R+pXrOKqFOiapwVDA0oedZcGdOZe1rwW/hNdieCkkoFX4za6GD2?=
 =?us-ascii?Q?BOnmfZtkQjNCAzpAEPaLp6RCsZ+E4bwdjoWSnL3SvzaE4Vp6LEbdcGTzNL6A?=
 =?us-ascii?Q?mOxep7EYFVktsalLKsw/wkhkyW8eMbDYpvru+xDjz9UXiMrJTQcHyMeV0c3J?=
 =?us-ascii?Q?PABklIFVNM+NzmMul2c1h/aUA86KXuYZJq0L0t03mj71u2PKHnnZIBUPISEo?=
 =?us-ascii?Q?epiK8VvbaNRalJOyslhg1FwNiaZy3WT6d9DFl9kdvqDyB15jLUZM+4h4BI18?=
 =?us-ascii?Q?bCCM1sQ7tHMiP/vlHwvgT7l6WNIwzXbbYm0fJuYZMsQ94YdYfBQc5i/BUmH6?=
 =?us-ascii?Q?SNw/fyL0kB01FRJiNlh5pH6ntDY9vPsua26o+O1Txv24zTMsFeasJUrhtW2k?=
 =?us-ascii?Q?7LOMJBhQQ+S1Gp9GzZVhqRXPe+OzaexN/6BcxZZEgIk/yA9I1dsvidkNR5cP?=
 =?us-ascii?Q?xgXGTI1oPHgbz7TkjOqSxrW6tPsO+9I6F/G8vURHzDcxrfWwwc8oHjNuG0a9?=
 =?us-ascii?Q?rE6/vi3yzKxkp1Cb8tGsz1vEIF6XrGxe6QP8g9mmbOaKm4hJ6QHvVgtC3W24?=
 =?us-ascii?Q?qPHfm/+azbmiWD6XgnExacKs7UFCxmFYxWL+QRHHY8pXuwkaqwUAUrCnc3w7?=
 =?us-ascii?Q?NBqEY0zMHNLOjv+gIfdqkFusjZRYv/ipz1zgGeukivhygtUf1NPHAJLztN7C?=
 =?us-ascii?Q?gcu0euEOWUzZZiW/xMkPI2HUZXwrixcapPOhx11nCA6hhAI+LD/DB2M0xwzb?=
 =?us-ascii?Q?Eb0e3xicLAWWNLWALA/pgKQP1HIESCDsqTTxprr0ZDea27lh1NK7par0Does?=
 =?us-ascii?Q?/iKPpX6Ye36PjnRMggbXinKCPrwbVY32AW1ofICfUDPovzTRJd4HOlarb34Z?=
 =?us-ascii?Q?Dc0SrAC76SqWE3uFr0pUXUIU7zM83Vs90oAUw0L3cVWhYVrpEYkXy7vDYyCi?=
 =?us-ascii?Q?aE6z68esK7dggKzKgp+AEiKpWnIPzft7ZNWsRpyEHeNtOLN6WNfI6A/14CPD?=
 =?us-ascii?Q?e0bKtx/I+PNvcKHsCgwwY3phAMpufhmp3LJl4/idrgcbtEmcx3wEWewRQUGH?=
 =?us-ascii?Q?Hx94B1vXObi4+3iUKI9T0WdA09GKVOj72KTMbjw9EJirxyj2K8HivHRkpr7H?=
 =?us-ascii?Q?HGp63mFb5/VZ4CHf2TSzrbgg7lLUYULEVLlGcmAaOl3uMEFbUyZpoRMaVpw7?=
 =?us-ascii?Q?HoQ9ckeK8GE3Mj+HlrLpy/XKdQEE87fJqK4qQ8xEuW7+8ZVTerlaIxBniZTk?=
 =?us-ascii?Q?d9MfE/75Lwa9HhIyLkOi2RgYXgjAdt3KD1A+kp0WoDmCZPqTa3HliG6noaLk?=
 =?us-ascii?Q?Dt2akEDnQ2BcdN1NKC3ZLI5xDDnNi24/UDoXRN7zsEb3UYQ1GZFu+mfdRyYl?=
 =?us-ascii?Q?iw/d5m8O0B83iCUUiAPi3NFpdPUzcT9S9kT7yuxB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9608dbe8-a805-4c34-8448-08dc65cb71fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 08:32:44.5846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyw5GTAyfwFDCBg2eX05Jq26FafLZOEsKnH1hKtpNIAe3cQoseVfUb3iBK7jxmvXwQWKNf6K+SilMlsJRBPVyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4977
X-OriginatorOrg: intel.com

>+static int hardware_enable_all(void)
>+{
>+	int r;
>+
>+	guard(mutex)(&kvm_lock);
>+
>+	if (kvm_usage_count++)
>+		return 0;
>+
>+	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
>+			      kvm_online_cpu, kvm_offline_cpu);

A subtle change is: cpuhp_setup_state() calls kvm_online_cpu() serially
on all CPUs. Previously, hardware enabling is done with on_each_cpu().
I assume performance isn't a concern here. Right?

>+	if (r)
>+		return r;

decrease kvm_usage_count on error?

>+
>+	register_syscore_ops(&kvm_syscore_ops);
>+
>+	/*
>+	 * Undo virtualization enabling and bail if the system is going down.
>+	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
>+	 * possible for an in-flight operation to enable virtualization after
>+	 * syscore_shutdown() is called, i.e. without kvm_shutdown() being
>+	 * invoked.  Note, this relies on system_state being set _before_
>+	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
>+	 * or this CPU observes the impending shutdown.  Which is why KVM uses
>+	 * a syscore ops hook instead of registering a dedicated reboot
>+	 * notifier (the latter runs before system_state is updated).
>+	 */
>+	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
>+	    system_state == SYSTEM_RESTART) {
>+		unregister_syscore_ops(&kvm_syscore_ops);
>+		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
>+		return -EBUSY;

ditto

>+	}
>+
>+	return 0;
>+}

