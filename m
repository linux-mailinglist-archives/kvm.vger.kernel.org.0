Return-Path: <kvm+bounces-6326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E425D82EA4B
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 08:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D5D9B21473
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2852F111A6;
	Tue, 16 Jan 2024 07:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXIcR01n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4211184;
	Tue, 16 Jan 2024 07:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705391199; x=1736927199;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DlMeOBwBIW7XrqHJOHLn/avyaOUJRjKeyFHzCbAQxa8=;
  b=OXIcR01ne8OV2belH0Ic0UNVcDJhXMPk9kF6+JPJipCyUpCmADC+tJSM
   1FQut5qIEfxSGhVCWT1WL7V8c5W4GUiQwdWBllmbVDFNkpNffTKkxEok4
   c4JVO7RbGGWbqbdkRIh7cso4l8EuC4etlbI4qybQPUDBOcG6qzTpeCYk8
   htefim6hZcItPeiHh8YqDVpu3TU0FY/hFTB7NDuPnK7ukjcEG6rGBCzPr
   yE27Cq+y7eWO2DMb9GBj2QZRK8EuUacOk7f7ZRf+9zsAqjSUk9FjQ4ews
   Awgv2wxAfEbfiFcBiqY89Xt03eCSGpkgF25/7yFJYHRo7AlHZBZywQYEa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="390233263"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="390233263"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 23:46:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="776945343"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="776945343"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2024 23:46:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 23:46:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 23:46:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Jan 2024 23:46:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Jan 2024 23:46:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VooacNr6pcB3E7LSGiZG1ftdy0572MkNxVFtSPdij7esn7uEGm/EIL49yivNL3/q11hTdQahEzfy49GCx9Ydcdx8sYwuqkgylPx2ofO0tPc03Cu2x7siQfVW12VwWVk/kRlp/SRMLa+71dXPz6ASjpythBCbHBpsTwEr8ZjPlEwoMKZ1ydL4qsURFp+zotAh8IIlu33EqiNC6ZY5AqNgIkQx4JcOF9lcdgPuiLMEf8IHkY9owlo9vhoYGGyrKDcDiSQsrR1PKUQ9ec0h37cLvPTY8HixctJZdPSdUd/NpU85TCT0SiYp/pqX1da4wNWbrr3uQa464Cqr+DfnDtslGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcT5RBxJ7sBp4/YzO/xY4scrxrGphF2I/VmUxrs/YjM=;
 b=BXc7kcC2TRjRcW8+0mDgmQG/Wu0J4fRpheyFvanegLxvacGUbHcRHJs4ffwpY9O5GRnlV5LfGTvRLIw5gkHv0RHz71DW3RdmB9rKLtdt3iWtQ2xzd00KJcDV35MccS4HGxyBlVHKWF+Ta2vefOESqQTs7XRCB3TZTb78ZVyaN/f4C0wh94L9rUioifCq8sMxBTOKly1clBoidwm5+W9qrEbicmuada0Zl8vcfxru0t9QKDBe4No6kz+/MRIKKJdB0srUgGNX8dchaDf5Hg9M4PP9z156vqaNjz0ya2kuu5ku6aL61syealIuSvYzIzCaPd5fCQI0TbrvUzxJ0I1ZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN2PR11MB4727.namprd11.prod.outlook.com (2603:10b6:208:26f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.30; Tue, 16 Jan
 2024 07:46:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7181.018; Tue, 16 Jan 2024
 07:46:35 +0000
Date: Tue, 16 Jan 2024 15:46:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin3.li@intel.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <weijiang.yang@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Message-ID: <ZaY0UbFjwCYh4u/r@chao-email>
References: <20240112093449.88583-1-xin3.li@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240112093449.88583-1-xin3.li@intel.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN2PR11MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f056fd-08e2-44bd-ed2e-08dc1667439f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U883Q6nMirVOcA5CnEmhWqTgKNgUWw5hnsFAk9UE8sdhyQU4kYUGWKy+HlDlzk8F9rAHPT/pC0ycOvBz2RCEJsKBddK3vcVpx5wrC4HH84ZoKUL6FNv6KoCXcdtgZze4cyCo9MBOH/rN/xjz7NGI7jzIRXn9c18AptAgo0SUl4LBt763c9qwTehlEwQ53OiPQ6wRcudN8nNDuzsq8T7J2FHsstPOIEXSzMZoKkKhg+2FELnCBFOstaMNtOK6hfM3V4h0MKT82Z7sPUe8ChkNzDmE0QxUpaCpZ2IQPZJNdmWCPrz7OWZXPV++cr1Ee4E84nRufEhwmtsztl/anfgbXyZv+adgUnumb7TA3hoU/UOdtMA7rxyCgNL8V0nkxJQNmMCuS3kGZELeh266ZP9niBhJEh3YrONFmWkJzojk2V+t4ezylG87X4pFrDMUjiOwlb3i4PP7Mnr8JMuxgJwtDVzMBO4f7QNIraV2Kj7BSsfhH6CpdE8tJ9u6ErXvL6lg8gBhhywqcWBEk8EZhXC5I0wdnV3MhIRRgWSkNcnwg2jZE6F+iF+0qDcooUahfpY0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(33716001)(86362001)(83380400001)(26005)(82960400001)(38100700002)(44832011)(8936002)(8676002)(4326008)(6862004)(6636002)(316002)(5660300002)(7416002)(2906002)(9686003)(6666004)(6512007)(6506007)(66946007)(66556008)(6486002)(66476007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fsgVby6SyLEVCWy6x7UmjO08+2jWhJIhwv4GfqsT6LhiY4f/+8egCp4Ws43A?=
 =?us-ascii?Q?rresbvLFsc2LsqTNAf1puOBYGXgr/xPA1gxpapG3r9nCTyWTJVyBsD60DTMh?=
 =?us-ascii?Q?k/K+UIeB5wjglFoD+59MV0WzOGXStv+gdoJDim4E5iByKj28+FI4RFFikwIL?=
 =?us-ascii?Q?Hh5CI34lbdJc6pKv805hvmSt5ZXRuUTcrTCXQ27/ZIS/Wfwq10E/J9cIqJ4c?=
 =?us-ascii?Q?vRM/Jamiw/Gu7zSJtGiAX6X3lBkEjcrsggbO1t6jIMzIRB4DlblCSX9g5fjm?=
 =?us-ascii?Q?rsw3WFnfSN/vsYyLTQW4/5UXgXNav1apJDHUxj6J6LA8CJkJkZwFp6DC+dE3?=
 =?us-ascii?Q?+rfYA8k+Anh3pWMnmTpK4AKJWNozUWq+Wo8gUhFu9k2S+YB0V/9ekrTKPNns?=
 =?us-ascii?Q?MYruKG3ngSjA96Tg73Vgd/eBTdbJ3Sl+5ixQ9E2N6HFhL/rcj235ZgdbJSk0?=
 =?us-ascii?Q?wPzztyTMU97ddaurAuqJWLIvjdgI4FOYzBdGYRIfQfuYJeGoC8so8slpCe0d?=
 =?us-ascii?Q?MTmjHhpyRylZApbOHoKtAPY97Oj7Q1lYHbVIkQp85ycWFjVM+UlEqGfneu24?=
 =?us-ascii?Q?lCk3e/o7S8QNIFTdQzWinMThBerYOmWkftuSY0DyxvVDavSgAgTID/dXlfjo?=
 =?us-ascii?Q?qijfDKmpcMZPkFZMIH8QIDrHFOuar2BywXYnPb4ziLo1Vx1jZ78RTlB3GgO4?=
 =?us-ascii?Q?5v/9q9iOZy1XIJJSHPb3LB8a3U7KD09X4WRo8BWNO2q5qtTNWSyMO79Ui6J2?=
 =?us-ascii?Q?dT+zT68EJqoCVt8iHxKCJ8YWpIpS9Sqg0yf7BUl4lXg2VbPJj4rzmS9hlKfS?=
 =?us-ascii?Q?Dc6Rw9QREKaNFx56QUahIk+3W+NmDUCpuH+hDW06w1dqC1DMJkfvzyf16PK/?=
 =?us-ascii?Q?MRpgI+wwtrpdA6HxZoLgTbcXzUX4b812fadP6uEf6xuIkYH3wEQTzya86+kx?=
 =?us-ascii?Q?7ZK6G0qdUvAQo2xm9SUKachgN0FbAo9KLK7ZeZWHK0jvEk69soEgmniFWxQ+?=
 =?us-ascii?Q?fvtUcQzaSSktMvpIgNQcOIzxNooH9HB8UCCdXWfPx3CPGgtXJ7UTFLrrckmY?=
 =?us-ascii?Q?QxP9nGEZ7yT0+IqQJwAxXwZzlZk0E21JeFwcnb7Npd1HnwpqmZ4kRL10J9/9?=
 =?us-ascii?Q?O0CfNt0+70pa9CxT7uM7tqF1VI74RpyjbdacSiJBkN++TtakZWs6gzO12zRD?=
 =?us-ascii?Q?hkZDaoMTbVbUgy/U1z91gESUgzpD7Nfblj6kZwqO8Dd1lD4CtBuM7xXMRD25?=
 =?us-ascii?Q?rgxPXiFxMSijlNLZypc6kBz9dZVKGB5icLtplb1AFLAjqcFttTLpM6LloKDu?=
 =?us-ascii?Q?0XAnqOjWjrECQQ/iCBQ2bIRAkRL57o1srdnNn45sn5LZWfdhyGk5xzIsvjEm?=
 =?us-ascii?Q?tuafe+wAIireOaVuh+imXgK5qufTVLSinJxTjEQgFZx82Au7eFpPPDuxFRwU?=
 =?us-ascii?Q?ikNfMsUN8zmDjXphIJ5ZVc5RULfl/83iuBn6MVl01SnDSIXfATCyOz3SpiBH?=
 =?us-ascii?Q?c7Twc+mKoW4L5Zybkt5JDGYvQ/91o3/tdGUDSQR/DmTZqIOhC7gQc90iHASO?=
 =?us-ascii?Q?XxrGflx4uk4daaEkppWQDorCFFWOJ9ZvCJwhbbbU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f056fd-08e2-44bd-ed2e-08dc1667439f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 07:46:35.2846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5Z75q/EOlpcK7x51h8XheIwKKUvZ9S7OcA/sOEfwURngXjVF4KRLpFAxcdOY28u2BiTdeK8kXTDVZozjotU7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4727
X-OriginatorOrg: intel.com

On Fri, Jan 12, 2024 at 01:34:48AM -0800, Xin Li wrote:
> 
>+#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
>+#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
>+
>+#define VMX_BASIC_FEATURES_MASK			\
>+	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
>+	 VMX_BASIC_INOUT |			\
>+	 VMX_BASIC_TRUE_CTLS)
>+
>+#define VMX_BASIC_RESERVED_BITS			\
>+	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))

When we add a new feature (e.g., in CET series, bit 56 is added), the above
two macros need to be modified.

Would it be better to use a macro for bits exempt from the bitwise check below
e.g.,

#define VMX_BASIC_MULTI_BITS_FEATURES_MASK

	(GENMASK_ULL(53, 50) | GENMASK_ULL(44, 32) | GENMASK_ULL(30, 0))

and do
	if (!is_bitwise_subset(vmx_basic, data,
			       ~VMX_BASIC_MULTI_BITS_FEATURES_MASK)

then we don't need to change the macro when adding new features.

>+
> static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
> {
>-	const u64 feature_and_reserved =
>-		/* feature (except bit 48; see below) */
>-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>-		/* reserved */
>-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
> 	u64 vmx_basic = vmcs_config.nested.basic;
> 
>-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>+	static_assert(!(VMX_BASIC_FEATURES_MASK & VMX_BASIC_RESERVED_BITS));
>+
>+	if (!is_bitwise_subset(vmx_basic, data,
>+			       VMX_BASIC_FEATURES_MASK | VMX_BASIC_RESERVED_BITS))
> 		return -EINVAL;
> 
> 	/*
> 	 * KVM does not emulate a version of VMX that constrains physical
> 	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
> 	 */
>-	if (data & BIT_ULL(48))
>+	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
> 		return -EINVAL;

Side topic:

Actually, there is no need to handle bit 48 as a special case. If we add bit 48
to VMX_BASIC_FEATURES_MASK, the bitwise check will fail if bit 48 of @data is 1.

