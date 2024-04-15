Return-Path: <kvm+bounces-14642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5F08A5089
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50701B237F9
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EF813AA3F;
	Mon, 15 Apr 2024 12:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mSPe5As7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D7B6AF88;
	Mon, 15 Apr 2024 12:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185595; cv=fail; b=noG7hfqBNWm0+Q1XUUvki6/0/4xasaJwoHiEvswo9c1omMSbpNPVLHTUgfg4CDfv24+N2GriTnLgidXsPaoO/eXD9XLdyicGew8c0PKb0oIHGdratXGZzNMS6O2GsqlLEgwpPAjDOnZOGlrwQt1PefuSSxuzXsOEi24erPec37E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185595; c=relaxed/simple;
	bh=SOejPrh1oAcUeys+pF82fWydvPVfGi/hMf3Sx0c1YEk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q2zHpcgpX5jonhwJMnCqpa7XsyXuXqmpQtEyZgU2cqAdwUBE/Lmbln54blcYR6GT6R2TvHVeXfOzMBZBu3Y/rx1xjnk7nMlHLt+mCDCZIwvfTGA7aA18s3UtEbJZpJdoj6/6hGtZIBfKoiVQKXeagp3nYkaWVrnO1LB8q0+Ln3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mSPe5As7; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713185594; x=1744721594;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SOejPrh1oAcUeys+pF82fWydvPVfGi/hMf3Sx0c1YEk=;
  b=mSPe5As7oRycvHX6jPsdE4ObnqEPJ7R+UBxBypHnIthOBjXIaAM4q815
   U7wZ9AnBX/em5YZcWxw+EU4xj8fz9eqbm20a5oNNuWiKi80iMKpDHW6xk
   WFg8VHbrSSIpJwhGU7apH7FJiVDYx+hruPNI15uMvVU/qKwisgU7ywXb/
   ChwvArdgjfVxv65vFhU8lTS+Rx6XGE70FD7XLXawAC5b0iORwQmg5mh9i
   GoAvjvJ1bEuIpGH3mjt/55ncKB6KvxcEo2yWXxd5yv4DQ2vUwKukJAUvH
   JjkbFZJKhHbZ3b3+MInItebMlC9gGh5lkU+yWOy4dMSfyN1+j8Yj/4xZM
   A==;
X-CSE-ConnectionGUID: +gcmY7osSvCoMa1x6MCuCg==
X-CSE-MsgGUID: tyVgPQmyT9iNuH/A9XZiag==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="12352266"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="12352266"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 05:53:13 -0700
X-CSE-ConnectionGUID: ZFpVTGmnT5OP9bz9cdNJTg==
X-CSE-MsgGUID: H7iFZP24RlWpG38Z8zR7rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="26537652"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 05:53:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 05:53:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 05:53:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 05:53:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 05:53:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpkXEaVKsCLRkm4cr5Ds+BZxlkft1Qjo532HjNNTd6uyIK+SQNfOLQAaOL8dk2Vfqt6JGyurlfY1AFKdZDvx6MyEBqBNtDjnjV1y+Kv6g3611KMBKpc5AQT2KCfI6nFrQKQaFsI+s37Fim5FGG38qlIek8vhO/6gaWbIQFryRsloV4UySix8jOJosG1HNOVcFVG9XOAU8VEZ9BRD7oElChwB15xdBDBvcen3HyPwsaVLTtz3CBCmlR07zuG42oPDgLpudGw/w6yaCwhpPmiM5kScl7G6injx1hvGHA/P2VvxCSmtJ/7x9k5KVorCos6XFTAh2DFrEFfkzE6KkDVx7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twY8PSz4mBoJ7Ttf//cFiRt+sFGl5+o0XV5ecBLfuDA=;
 b=B+l0tFy2MqeCbpAiFr1Tt5vJqtP0YW6Hlxv+qcysbJ8srSB9xg4ijnIBq9MihxK3hZW81Io1lZWi7JvPeBmovFDWCWdGezjOkVDVLScv7GMQ4wf2RxG1RMjTJft0KUvCkTyNSKHOIF/u1nNGSTFZynrgWadEEnWzJMi0LS5o8M9P5IhIGRGlN5NpuKbRNk1E/tpL3gsZe2kACXyQPfQCUg5QvNgTwNAP9DwqLJVM+F9qXrGSFF5U9mWWBL9DUvomwj1DLFo5dlIVdMzF4E1LCAS8hEzEvcWzN0J/yA9EdaDe6aVqF3Mf3S0OAzwYFAG7OeMBnXLj5ORVQ7AntWUQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB5871.namprd11.prod.outlook.com (2603:10b6:303:188::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.30; Mon, 15 Apr
 2024 12:53:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.041; Mon, 15 Apr 2024
 12:53:09 +0000
Date: Mon, 15 Apr 2024 20:53:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 02/10] KVM: x86/mmu: Replace hardcoded value 0 for the
 initial value for SPTE
Message-ID: <Zh0jLB5Ym8eUPLp2@chao-email>
References: <20240412173532.3481264-1-pbonzini@redhat.com>
 <20240412173532.3481264-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240412173532.3481264-3-pbonzini@redhat.com>
X-ClientProxiedBy: SI1PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a116fd-0f4e-44ed-9265-08dc5d4b0045
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKQHMl1yEsp+3kTODcNdE2gHFMMO7aYM8o5kVtxu+SauLm7zj2wHb6x0hUvLgjZspbyd5e6eMCh8y0H99wTZdH97dkHeThA/xNlMHDdCzlra1aoshiXzh28XIzIMeJ48ftLxsj8TLzltewBcx95yVA/QHR2ogoPE9smaCWh8XEjIIuoMEcMbeamEjEDUerbkAM0gDPTn3mvs4WLlsV7pOdMAd0S53nj+J/c2nWfNN+8/dZRTcV946I3FHtvg3rUwr5j13aGhS9i7UdDpjOvs7vVK3e+dCVp8C2xlQYNtNn3OjEmeuAmRqTrozNTUUnBopp7VJXUPmzRDvz/hcec7qTC8QBykwlOF0gV5E4tv5/RVP76BNtCXQRfx3HmGWyfOD4IN5DRcZw+L5FQF0xvrsiRRR/6DLEpGsrvukCTI9aMW/LtroR5GPEJWQFV0ld5OSxsBUqtefVAxxSqpMXjwBPNMA3KbCPHu8bMeM4naXd7f8FcslC8S9KPj0t4wn9FVPteDKr+CW0pnGp464XKAvlRpWCyxtbdmIFr94p/VdbmtsEQEPNLb0enVnrlr4q5/xeIFQ33+K4p5YUEcE3skURlXpFtU91qeTxuq9iJ6y6WXh78O6wm5SSOAMWlKY4EqobPb/XC6p6EM1n6nIJKK/oFOzYcYKGzykLt4N2QsBiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gdCoXttBU+QN0aPow9Kel2LGNqGUVC/Ut52zot/Eb7LB/vhdhmg9j8u05ZCg?=
 =?us-ascii?Q?jUN72FnkqxYSc54+yrOFQUVYvPvmjqLzKLYf774Buv5/3FxUB430JlWNpXOW?=
 =?us-ascii?Q?8T9VQLx7FhcgwlbfLPf3eJV1fBnKjPxWO6QyOX8wIFQimVdOUgTwPEzA+eQJ?=
 =?us-ascii?Q?qQuwtLKOyDXzCCNd0MPOK4w1vcjWdoNUhLU2tbohbLpI2eiL+koU47pGzSpb?=
 =?us-ascii?Q?VsnNS6v246Ii48NLKkRyI8b/jIj2hSLrHm/NMF59xd4yW3Bp6cKKx3EK7LWs?=
 =?us-ascii?Q?s/mkIuY2uqx0OF2JJOr8hFUd1p0nb7sAFuqQMfnlCLxpJ9UNAJFabhISS/ym?=
 =?us-ascii?Q?iuWF7wTg6HMDES9VbpO88t/99XZfeHUS5wgSBAwfLl3kP6NEbRuvqJv44N8r?=
 =?us-ascii?Q?gF6GsWSVnJptEJjkzZaZ6rGCjj3tt1Ui34oPKCpxxJE3B4teSzAI/XhGFokK?=
 =?us-ascii?Q?60l+IvBqiOB+Y6GveGtarHbPHV9k77u1iXTm2szxYsYwaevbSfXToISncLCc?=
 =?us-ascii?Q?iNpKeQRGlRHRwNb82+UFIHSW0lGI4H/u9KKjplujS9ppxSNbIBJYg11ohTCG?=
 =?us-ascii?Q?akO5mFxgMX04f2uq+4WqBp0Z8b36kjr+mNnBuuiKZhASQ/URAV57YGGz8pbL?=
 =?us-ascii?Q?Q8Br4TmjGIpRaTJKVCfraHoA9lQng51nXk48PgACZsZqyJHs/6y8UELVG+3y?=
 =?us-ascii?Q?cm/+oB/VzcFcI9kLt79lB2WHzK5EX2JTtGMEY1rweI20nEVgSBIMr2PNnrk/?=
 =?us-ascii?Q?YMYqLAkMKbOrGL7bHfykTcOi+SNI3Z7+9S9oRjklE4GooxNjcYVN4m+FYgds?=
 =?us-ascii?Q?P7HY+Dn4I1hlEpRz5g1Z0pVyA0XDwG1JEzMZXtgUWJ6jNEckzBQSA5zS8TtZ?=
 =?us-ascii?Q?H4yDVERnVdc+acEGKReD0lkPg/1io63oJSkXmp9YjHXPXxUoMpZhPif75yFG?=
 =?us-ascii?Q?yZug6kxdaI/trCniR5au81SPiuTCWA9/MqXj4WJjwJLYfn0Exk+5xLEIKjA3?=
 =?us-ascii?Q?VONrnmQ4xuClPhYqfngYau+52H65MhrEPCKIPTxKtfSq53rFCXAzfXyV04G9?=
 =?us-ascii?Q?GIr1DeVrtjke6f03J1rVc1fJIOsceGiWZlqrykUGNYzESfAH98jG6NUvfgT1?=
 =?us-ascii?Q?UZ3RN+g8CmhM2CfNRpWU+rmtpY7ITK54mEj2d00dn0QCY4m4AMxHEw4DvXhy?=
 =?us-ascii?Q?W3VrGtgN8UX6pdPua6BhD/kiGcJHE484fvgfvBRQuCtA3QxLuNNIU4rICwDP?=
 =?us-ascii?Q?O3430+Uvq4pKYKkiYwhyZuNaF59vB4HMgsZS2KEJ7plTTCuveJ/XyZfFTEo+?=
 =?us-ascii?Q?B/r0/L3/wxCZSWgXg/LfHgOI4LhyagpgJjU+vSViyboRx4qGQ7XhuUiHqClT?=
 =?us-ascii?Q?YgjAMRDtSw9Ki9zuytRP+rXT+HIjMLeurML7iKxLUBbK0aURRseu3EoAzUDm?=
 =?us-ascii?Q?ZjRZqgkHtPQEoNaNWmRwGHrSeOT32n6E2DU/DbIL3clob2HvBfKBxUrDpZON?=
 =?us-ascii?Q?jH+jizfWPapLpXfQJW5fVIldosDH6f6F8nxjHcpv5rho1RRpssz9wjWsi3wQ?=
 =?us-ascii?Q?PfQBnSm2wX4E03EHlGxvYQ4vkRbuzmJydQxCecD5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a116fd-0f4e-44ed-9265-08dc5d4b0045
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2024 12:53:08.9862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BhpRwOabtypBK94g8z7FodTt+aDYgoXjo/QtmeQjmdYFahVG47uM9gn5hbf1jhWAJcw3CmaAchgVBQIxsGzazQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5871
X-OriginatorOrg: intel.com

>@@ -194,7 +196,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>  *
>  * Only used by the TDP MMU.
>  */
>-#define REMOVED_SPTE	0x5a0ULL
>+#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> 

"Use only low bits to avoid 64-bit immediates" in the comment above becomes
stale w/ patch 3 applied.

