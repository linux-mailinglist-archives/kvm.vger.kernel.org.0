Return-Path: <kvm+bounces-12212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E118880B11
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 07:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B6C28397F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 06:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460C8182D2;
	Wed, 20 Mar 2024 06:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZfHHDk03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D417999;
	Wed, 20 Mar 2024 06:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710915190; cv=fail; b=W5tk/TTWfyCUA2gG6DxP5STA6D9RbM8B+bHdbQQf9ZLzb70HllCHgBDlGglFMV36Xd5p7ovHy+kmMUiRn9AHDgf/rImL4lGk4VD2bUMNLqas4dUGJSHWTa2TJBjrhcbe1jAFtm8Y9dsAMWrxgqp8nQ68R1BPplQl/DlzJ5fIrCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710915190; c=relaxed/simple;
	bh=HMjO7cP9GO0XfIWxNVn+MVORVQAYvSx/aDqSw5Jb+zE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I7w6N+tb9w8S9pHMPsybndxB9kTv0atcGYKmaCodi57iXIXAgwujGFovLorNlrg1u+m+L2ZapW9AqkIuRobGtz0PcjF19LG3AJtK/jghngpilAu2R1pvu6xjAurbCEqwzhxMaoYT3Pd6arvitMPQM2bvX5Ma1hTlyiPDpMRlxo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZfHHDk03; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710915188; x=1742451188;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HMjO7cP9GO0XfIWxNVn+MVORVQAYvSx/aDqSw5Jb+zE=;
  b=ZfHHDk03FnvxAT+XvfAtylIavsU5uMBtMHLMlDK/9QGkehEM9iQqS+vF
   2mn8O3yoHbZPlKMwVBgaARuFTiipIU8475rXztkitxHK2Id5dMhB2eHGP
   zLt7HK70CcltDGmgXc2Qz/Xy2zA8xkSKFiqxIIytBVDKdgRM5G1pogJ5t
   q/Gr1oPSkc5NYBKjN/Xr9c6gWAh6ykmgFCJo+WZtV1lAalvohal2hwupT
   eM/UrwNqqKYFmjCV5Hcm47ukKeCuheCOcUWunGSf/vs5MCKqmkwTGfFx6
   8/bp1uPKbQNeWDGC4lc8LSJaHtn2rSsMWPF8CoMGkDbTm018JaLLQdGmV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5758670"
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="5758670"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 23:13:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="14075247"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 23:13:07 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 23:13:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 23:13:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 23:13:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhdoJi3owH8P++Fpy0g3WpdOikimJgmNfVK4HD03QCD4YMd3Ewo+xVnoUYlhmWAD+VN3DvkOVhPaSraS2OuwbmRcWyaKvAj+Mo1TEmFPRuNFcDGDIKoQagfSdRz550te7XqPoVdprK5rPo/yNFlACa3lHc4mO72ALWvW3IqN8hVZ79AFo8c4k4x9hFR4piDas+kucWnDhh8QZvD+egnHGwvfr5YCyv49VrF4uCYcNxcI+UmEI7hzAhXVvmLsgqPNvMqxEc0gyXp1e3CVy+O8XhEwsN5rIQaeqp6dIww+QEf0M7UmeWpbS8MWXdFdhlAffCoamz4sWE+0ABwTDLoVRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxV28YaS1Ub4KKHcRzMTJooDfN7BttluIPiOZuFLuZc=;
 b=XNCsOQBUdMA3tpnDYWFfldxgfXKQKX5oHw97a60+i3NGSrPbN6e9A+ptnjJhn73s4H+vonRLYXQO14q8VNsbriNQnodwrKeIvNKiXrnMNCrcaR7+7U3bP/PD1YPa9bb4uGbSG+FiqgEtFT7scK96FhXzLZSMt31I3esRID7DzN9V1bGjIz8c178cYTllM6u1yCKpawDPkIe8BvpQwXg4piGEPLuFJU4U3p80OrdE+1vkuq4hLQSeWUnQm78VP3Jv8CaZc5aSWEZNI9SvwMgqyKFL3e5iuo7L6bLNdPPSKK/HxkThhwUi+ZGIp+QvLVvnfcxP4j/VJM06KJbRiwALsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Wed, 20 Mar
 2024 06:12:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 06:12:59 +0000
Date: Wed, 20 Mar 2024 14:12:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <Zfp+YWzHV0DxVf1+@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: f4e52258-f8d9-45e5-dae5-08dc48a4ca60
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UKemRkOucroIOcr1KDe29BldEqyWch5LCvT/o4rNJNHBi/B6rHGRRoF3woEH1CWyrz1INge8/2OVT9SBzcVl4dD6VCXmocGAFdvHCUu6NNIDhQguDbTh1mBEIJeyfXpUPRScpg9fRG2rxGJqGM8WGF9RyMcCtW1FWTwURUVmRBideYjGXMF/+SuLnRxyxZwD4y9yfKTyT85PVFDFhxQT4/JwZMRPKnLE8WISG2Qhb9n4UtyiuYnjDECICJYKZo7C9O5N9reIG6zcNzdALcAee6StmK0pbZgUGLUHaylCEOwYBa/n13IKSQj2phSvy42nRcI4r1W3t73x7SIDx1Z9UO6vP6YnJDwEIG34etl1tQUdVzcSfwbQeIK0SXybabh2NO0v7Bz6CY97Gdmr5KU9J4tCLT8YjrE3ljSEPTcRCbN+nGaJvTWDkZnsZcX2cQw8y+MY3DqaazUsizsDiuTLrZwzD4Q4o2KPIlSVHRQBXu2Gha0qtsdw2fFY8CcSUMBLwNczCNIQ5t7QdaWPcY89XSF33Dz+CAIiXVhhzY5nGtQYl6rw5eze8bvWn/h1vYRdgLpxKFwjCnL/IUl4ijk9mSXTAx8XGlAldUpJ9iDUQH/q0E8eoSdERdCToB9KP0rr51X+5SwQN5ps0XRC1WpYUDHiMVOcnMahicu876o8m6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?elr4NxiGitdawmDNXxZpWQ9TxbQfFu6FuC8PD5XZmRvzNgnL3QBVeR6zxrB6?=
 =?us-ascii?Q?iDu8ysevCxYtwRrq3nx8E7qWjLdOcMLsEKQq/hEFwXGk9Av+Ppk143luxKkG?=
 =?us-ascii?Q?fvNx/8pSLkznBy3SZlObaXYiFH6zDo/ZWC8gU2ozPMH/6VZowU0GIg/XrFDO?=
 =?us-ascii?Q?y5Cjtj4W8Bm41e52HZ0mBHQAvkIf3UxOdxu1X6VzQqMrNYUKhuceSQMSn7iF?=
 =?us-ascii?Q?iCtKTp00W64CV2uLy0W5A3fV+4e7KcQ0HCjlebQIYrYa3tiZJKEDUC49uhEh?=
 =?us-ascii?Q?3UbA4Odzs43w6y2IVR0beL6sStzEhfBjGVGAaBK8PADXS2YBDBtpsp9lt2Yf?=
 =?us-ascii?Q?CeI5fd5p+XznTtnNNXcoUjjPPZ4LAwp20GpHkOfd/4cRxNDJte02Sc1x8ZJJ?=
 =?us-ascii?Q?VlyNjDdcs7xSWnxEIMT3VvDWWIflalEcbDZ5CWltIc1GRtgujYWjWpX+mfKe?=
 =?us-ascii?Q?3EbJeMFleW9+7hmAKwD15xzed6TjZiHhJPJAqLKsRnIolhBfNwA/C8qEXIsE?=
 =?us-ascii?Q?pQ2U+f8bdHuz2TibhyuZigTEnnYEXlErJbJrcjZ+lWVBkLUX30IAXgeL6fT2?=
 =?us-ascii?Q?HgtmaRkI/8hONu7RJfCoVGjTtHAEO8+pILi7ptFLqP7dSnvdD7hmf6+OF4jM?=
 =?us-ascii?Q?h6r8TrFy7YKvWXWynhHiTHW9fdVuNBFAtQPSDIxsjp3tW323j+Iueh9n77AT?=
 =?us-ascii?Q?ju3mSRY3sgtx41gxD8w0aJaSe6X+LVtYGzl3zDyGFa/ZE0nUlpY5H9A7fe3b?=
 =?us-ascii?Q?VN+WoAW/Fq92+HoiJhOwqVJ0pvvqrnVvAZB9mmpAslrkFPqybah5jJIg7Ccl?=
 =?us-ascii?Q?b6TWFyfYH1x3oempi5m6kSCt5HMnPJLdSt+DiqjR8RBCd1tSwg5xUs+bIzc0?=
 =?us-ascii?Q?RtjdPyiKxa/smjyvHYiyR2J6B52Q2YkekasBO9hEkgx6hc4Cbl7Bl0oGVWj2?=
 =?us-ascii?Q?7AWMPutMcHmtGfvojCP7dChwPgY2cs+sUIZHvIjb4FyWor2/mGSLuyJB3iyl?=
 =?us-ascii?Q?vbhqTt7dzm5fxj5dXvaOP/jA1JP5YEIAGdN+pnMRii00PfF/mzxipoE/pzcF?=
 =?us-ascii?Q?ErT9p4YJXzR2iN2F5mk+87y8sAUW32xthL+T9nc3L73u6C8QFN31fqgRsmd5?=
 =?us-ascii?Q?qo0us/la8/R6MtjSgnlpZL1Lhcf1HigRVRPQPfwWXfc9e4r+xUeNFJ4CuhpL?=
 =?us-ascii?Q?2JtdpvkF6ukyIzOevOROoZCwnE+OAQI2yqRFldspfbmBzRm710zmWikQ2hW2?=
 =?us-ascii?Q?loc+iP75xmUK8sTlX8slZVi/xZiDrZwl7iHDGgelDPlyigND6+SstiwffIjz?=
 =?us-ascii?Q?y1xil8IguoVooX44jQbpMFjR7DCzUffmgAQbQyLfROPAECCCRwZmGupCYrsS?=
 =?us-ascii?Q?G9ewlp7PMsgGj6j40VVyfdhyyfaQuoXI3VQHktnEybspcqAf2JPfe2O1OorZ?=
 =?us-ascii?Q?gmv6bYHemgA0Q4fZ9zA7CdJEZqa0G9/efw7Q+GVb1V8mjxckbhRv6IkQz9G9?=
 =?us-ascii?Q?gGhg8Z7J/mwTLwC0Q7rwnVLZ8Mg4JzEQRqKhPxsvMtpa3CFiOmDuQbQRn0tA?=
 =?us-ascii?Q?xnZhl4KPAcz8apNBEbtFoYTlz5C+C+6ST8IeumbJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e52258-f8d9-45e5-dae5-08dc48a4ca60
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 06:12:59.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOl1ys9QKckKhDBSsg9Hc2mlPR7VxTXLDIjyWtpP96H4t1tg089lIHQ7ssOwcdkO6jfEzLdETXY44tnFYb6lbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>

...

>
>TDX requires additional parameters for TDX VM for confidential execution to
>protect the confidentiality of its memory contents and CPU state from any
>other software, including VMM.  When creating a guest TD VM before creating
>vcpu, the number of vcpu, TSC frequency (the values are the same among
>vcpus, and it can't change.)  CPUIDs which the TDX module emulates.  Guest
>TDs can trust those CPUIDs and sha384 values for measurement.
>
>Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
>guest.  It assigns an encryption key to the TDX guest for memory
>encryption.  TDX encrypts memory per guest basis.  The device model, say
>qemu, passes per-VM parameters for the TDX guest.  The maximum number of
>vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
>vcpu.  The TDX guest can not change it.), attributes (production or debug),
>available extended features (which configure guest XCR0, IA32_XSS MSR),
>CPUIDs, sha384 measurements, etc.
>
>Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
>configurations aren't available yet.  So CPUIDs configuration values need
>to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
>to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
>
>Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

the SOB chain makes no sense.

>+static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>+				  struct td_params *td_params)
>+{
>+	int i;
>+
>+	/*
>+	 * td_params.cpuid_values: The number and the order of cpuid_value must
>+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
>+	 * It's assumed that td_params was zeroed.
>+	 */
>+	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
>+		const struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
>+		/* KVM_TDX_CPUID_NO_SUBLEAF means index = 0. */
>+		u32 index = c->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF ? 0 : c->sub_leaf;
>+		const struct kvm_cpuid_entry2 *entry =
>+			kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
>+					      c->leaf, index);
>+		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
>+
>+		if (!entry)
>+			continue;
>+
>+		/*
>+		 * tdsysinfo.cpuid_configs[].{eax, ebx, ecx, edx}
>+		 * bit 1 means it can be configured to zero or one.
>+		 * bit 0 means it must be zero.
>+		 * Mask out non-configurable bits.
>+		 */
>+		value->eax = entry->eax & c->eax;
>+		value->ebx = entry->ebx & c->ebx;
>+		value->ecx = entry->ecx & c->ecx;
>+		value->edx = entry->edx & c->edx;

Any reason to mask off non-configurable bits rather than return an error? this
is misleading to userspace because guest sees the values emulated by TDX module
instead of the values passed from userspace (i.e., the request from userspace
isn't done but there is no indication of that to userspace).

>+	}
>+}
>+
>+static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
>+{
>+	const struct kvm_cpuid_entry2 *entry;
>+	u64 guest_supported_xcr0;
>+	u64 guest_supported_xss;
>+
>+	/* Setup td_params.xfam */
>+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
>+	if (entry)
>+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
>+	else
>+		guest_supported_xcr0 = 0;
>+	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
>+
>+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
>+	if (entry)
>+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
>+	else
>+		guest_supported_xss = 0;
>+
>+	/*
>+	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
>+	 * and, CET support.
>+	 */
>+	guest_supported_xss &=
>+		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
>+
>+	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
>+	if (td_params->xfam & XFEATURE_MASK_LBR) {
>+		/*
>+		 * TODO: once KVM supports LBR(save/restore LBR related
>+		 * registers around TDENTER), remove this guard.
>+		 */
>+#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
>+		pr_warn(MSG_LBR);

Drop the pr_warn() because userspace can trigger it at will.

I don't think KVM needs to relay TDX module capabilities to userspace as-is.
KVM should advertise a feature only if both TDX module's and KVM's support
are in place. if KVM masked out LBR and PERFMON, it should be a problem of
userspace and we don't need to warn here.

>+		return -EOPNOTSUPP;
>+	}
>+
>+	return 0;
>+}
>+
>+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>+			struct kvm_tdx_init_vm *init_vm)
>+{
>+	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
>+	int ret;
>+
>+	if (kvm->created_vcpus)
>+		return -EBUSY;

-EINVAL

>+
>+	if (init_vm->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
>+		/*
>+		 * TODO: save/restore PMU related registers around TDENTER.
>+		 * Once it's done, remove this guard.
>+		 */
>+#define MSG_PERFMON	"TD doesn't support perfmon yet. KVM needs to save/restore host perf registers properly.\n"
>+		pr_warn(MSG_PERFMON);

drop the pr_warn().

>+		return -EOPNOTSUPP;
>+	}
>+
>+	td_params->max_vcpus = kvm->max_vcpus;
>+	td_params->attributes = init_vm->attributes;
>+	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;
>+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
>+
>+	ret = setup_tdparams_eptp_controls(cpuid, td_params);
>+	if (ret)
>+		return ret;
>+	setup_tdparams_cpuids(cpuid, td_params);
>+	ret = setup_tdparams_xfam(cpuid, td_params);
>+	if (ret)
>+		return ret;
>+
>+#define MEMCPY_SAME_SIZE(dst, src)				\
>+	do {							\
>+		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
>+		memcpy((dst), (src), sizeof(dst));		\
>+	} while (0)
>+
>+	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
>+	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
>+	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
>+
>+	return 0;
>+}
>+
>+static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>+			 u64 *seamcall_err)
> {
> 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>+	struct tdx_module_args out;
> 	cpumask_var_t packages;
> 	unsigned long *tdcs_pa = NULL;
> 	unsigned long tdr_pa = 0;
>@@ -426,6 +581,7 @@ static int __tdx_td_init(struct kvm *kvm)
> 	int ret, i;
> 	u64 err;
> 
>+	*seamcall_err = 0;
> 	ret = tdx_guest_keyid_alloc();
> 	if (ret < 0)
> 		return ret;
>@@ -540,10 +696,23 @@ static int __tdx_td_init(struct kvm *kvm)
> 		}
> 	}
> 
>-	/*
>-	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
>-	 * ioctl() to define the configure CPUID values for the TD.
>-	 */
>+	err = tdh_mng_init(kvm_tdx->tdr_pa, __pa(td_params), &out);
>+	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
>+		/*
>+		 * Because a user gives operands, don't warn.
>+		 * Return a hint to the user because it's sometimes hard for the
>+		 * user to figure out which operand is invalid.  SEAMCALL status
>+		 * code includes which operand caused invalid operand error.
>+		 */
>+		*seamcall_err = err;
>+		ret = -EINVAL;
>+		goto teardown;
>+	} else if (WARN_ON_ONCE(err)) {
>+		pr_tdx_error(TDH_MNG_INIT, err, &out);
>+		ret = -EIO;
>+		goto teardown;
>+	}
>+
> 	return 0;
> 
> 	/*
>@@ -586,6 +755,76 @@ static int __tdx_td_init(struct kvm *kvm)
> 	return ret;
> }
> 
>+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>+{
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>+	struct kvm_tdx_init_vm *init_vm = NULL;

no need to initialize it to NULL.

>+	struct td_params *td_params = NULL;
>+	int ret;
>+
>+	BUILD_BUG_ON(sizeof(*init_vm) != 8 * 1024);
>+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
>+
>+	if (is_hkid_assigned(kvm_tdx))
>+		return -EINVAL;
>+
>+	if (cmd->flags)
>+		return -EINVAL;
>+
>+	init_vm = kzalloc(sizeof(*init_vm) +
>+			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
>+			  GFP_KERNEL);

no need to zero the memory given ...

>+	if (!init_vm)
>+		return -ENOMEM;
>+	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {

... this.

>+		ret = -EFAULT;
>+		goto out;
>+	}
>+	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
>+		ret = -E2BIG;
>+		goto out;
>+	}
>+	if (copy_from_user(init_vm->cpuid.entries,
>+			   (void __user *)cmd->data + sizeof(*init_vm),
>+			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
>+		ret = -EFAULT;
>+		goto out;
>+	}
>+
>+	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
>+		ret = -EINVAL;
>+		goto out;
>+	}

