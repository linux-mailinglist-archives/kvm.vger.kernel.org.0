Return-Path: <kvm+bounces-7077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9600983D4B2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:30:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B16871C2061B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 08:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B756E134AF;
	Fri, 26 Jan 2024 06:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kezk12CF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E5AD59;
	Fri, 26 Jan 2024 06:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706250721; cv=fail; b=LhuuHqYs/gZti/QiDKhAqSU/++/l1fsNdef7F+C8Z3Mj+S3/p1PyZ/csDrvZhESFqXObiU3c7Ike8W8nBCX/MP8S/xl4mvpRBckymqmLWbr7lKN6g7FLcg8Y78I2xS3XKHkBG2Qhs7kg9ixNDRvTTwTw59PyV2YtLNnMukiAbrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706250721; c=relaxed/simple;
	bh=8gi41QMN6/IaCwodVVrGCAiFPXplx10jKlRKKSDvaKk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I1cE9esOEHaMqT/BNDXAkKwNKGiLqCWJ9zcs1QTyF77C8L/feZ8UaZ3/mb36ao+RQZotOJgY5uf5AxLxySVT22Hqm2XtMFKbzuR5mAqGLfDjKpEIItNRX1G9wR5fXajkMzzLsFiJ4L9WqfUazJBODJP2efHfNpb1lEJHvKE6vbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kezk12CF; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706250719; x=1737786719;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8gi41QMN6/IaCwodVVrGCAiFPXplx10jKlRKKSDvaKk=;
  b=kezk12CFTSQ4pp7kpVq0uFmWqr9V9DWKFgIttYPJ7yWi6T87ALJsuxyC
   6QsXE6l0PHbsscVwSsAG1i+WNqFXYi5Rs4++Xk1r/De3yYDg/Ia2UOvLi
   ys/HqC3B2P9pyYfsn/c7ooNWHdmZQZGCwrODZVYWTTK5i1ERQiyREEoNF
   STgMUe4EeiqGJjqRyWJxwcJzj9UjHAaR/zdiyMWMh5pTzW8eZmXIPJdyo
   q/JYpgp2/bKaVQuMpZ9kLgNkpjVSQPIH2oIJdlw0ddMA6SyJCKoWN+qSv
   xSDzRL1Ki4KVK3FN2u1znX611aRTrFTIpyTZ7nX//CBWCioI7ggYfv6tr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="402055339"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="402055339"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 22:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="29035842"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 22:31:58 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 22:31:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 22:31:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 22:31:57 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 22:31:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkwI6INMEelR6BPB5h4jLPm+jTLcFkkgUllMcGiaS5lHt5A9JujqAsqAV73zPtyUUwIQrurbWyWaHtMwZkIhYeEJWnHYbuKaCluxYCWmiVJs+pM3Meh19eJcNkG8x49jPGI/fzRiFPe6q3LrQ+rqhCaxg+wOOs2DrPTIa5vacaZfN+RhcPlUDJk5b7cXGhBssWbA+1vVVdT/ppj7oNMSIlsg/pvDCs6PuS5cwXRZ8wchv7twAF+Fl8kguJoG0g6eQXn0fbOIkmPQjEG06Jh8QG9n2sXgzMfduV1R04GzT7Gbr9XaIz+aSoK5k2yG7OkLu9wc5F8iTtZP5D3Ut+PsOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEiLL/RAqv8rmPPv8JuV2ltpdBidAYFhyUwHFNVwGZI=;
 b=m8y9W0xjGg0JA1hq0CPLwt82hzAqtvJG9zsYmTZNWwTVIIf/2w1n23DVWfPTreIynAxqsGNcuLQwdH+maKJP6zVFJIh+8tUaWivckj+enPklGx+cthnmatLq7167GUkR/IcTLpOa1M0rfAUcKUlNSeWHdDni7ZY1NiuQ9aW/lu6TWK8vokb0i2ZfsGnYalpDoATueiIMdbs31N/VemBlDkJ0N8yKXADgCbIWD4AadTvy88pH7vsUdpDqO1rgZ0FfZHyxSHloCxg+ddhja16reOVwiTpzPVrWzRjae5eYUvpvtZjbL8TGkeXsJTPdYyCZEn76dNAEvntnU0Exzw/PIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW6PR11MB8391.namprd11.prod.outlook.com (2603:10b6:303:243::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 06:31:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 06:31:55 +0000
Date: Fri, 26 Jan 2024 14:31:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 23/27] KVM: VMX: Set host constant supervisor states
 to VMCS fields
Message-ID: <ZbNRz/c207HYuHxi@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-24-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-24-weijiang.yang@intel.com>
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW6PR11MB8391:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ce12a1-fb82-45d9-68c0-08dc1e387c86
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1wBePWmrVuvagKVNtzbRebtrUgU825PcQnny4tZsvPHFbS5Sum1S3jiJg2NQ5QqzvpbCUlSnaNltwOwk8KoqkLrrJaCynw1fRKOeNFdym7PGKMpHd/x5E9UCc9CI7WU3jh9z75PRouJ6xI0GqTAph1crBkfkQwr7h53eEryCkfQISIeuJVzds6BJv0Z3cf1n3tOu6v05Pa/hbo5bpP0x4l5WjA9AYNHM4SUIPaHZdwB0mFGuzRAED162Zil5wSDgi8w81F4rkQEnSucPtAlizgF/otJLkNhorpsK+yT+fOmJOffQTYNgb864IgRyPchvhtlLSCsJviB1vJD9oLM6lS9XlGVpdTJVfcG2GjQ5kYMM6Jg1dyRWaaQt89JvKVXEce5vL/UsCoUQED3Ga6XzhFjgAhFwocxrC7MDH8ENX306DDdd+nWk3a7Pzn9H/LlKoFcqNeQgEhrD/r0k1b7js33DSWKts6+hludEqCn2HOZXYN9B9lRgxBzgclRtB/NhsBtBQ4YsNb/AWq2ConuEvrp4rImdjCvQOF/sH+0FWulIzUkuI0Ww5sls1e8rHbW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(39860400002)(136003)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(41300700001)(83380400001)(478600001)(82960400001)(86362001)(9686003)(33716001)(38100700002)(6512007)(66556008)(66476007)(2906002)(66946007)(6506007)(6666004)(316002)(26005)(44832011)(4326008)(8936002)(6636002)(8676002)(6862004)(5660300002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+oFGFpfRkqrvw9obSmo/szy8vFnJLUoju5Bdgmnl6/H0VKx7/9C/jzjY4Qi+?=
 =?us-ascii?Q?zaSJ+WywJmY0Pa+iQZCGsj3F8NxHS2PZg7pe7Tx3i6tPgqztfxocj50s+bju?=
 =?us-ascii?Q?viJ2jw4MqxLoaYBI9Cw1PZPTvE3iBhqauBWQj4xhMCNlfp5XN6XNVKOEujnJ?=
 =?us-ascii?Q?iXHgHTxxcxjeo/4aqSzIEeBmdzixGQfb8iUpdl7wKVSzoficcyjJjIJKRQLP?=
 =?us-ascii?Q?Sh/N9xj9iZyL0HyCmrqD+3H9AJq3jpkedEz6WuefZMS5oXZrF+um536xJBx3?=
 =?us-ascii?Q?Adglp+iE7amfkUrrl80NkeWhN+jzWc20frVvLyjyr8wGj417Aqt/2xVKYFtz?=
 =?us-ascii?Q?irbtWiFhBeE5JtSi3MGkqdhqkeZImq2HBUGUcyQkliy/KA2vh8KiVvTWID0o?=
 =?us-ascii?Q?ALXTgVUN6gi+STEtiGccS2b21bFu1KcaeLb0SYcLkfi49MqiwvmE7pBvoJaG?=
 =?us-ascii?Q?a0NThaB1jed2LdoN9r4nm8cs0odqnKZyvja5iZe7YugmQb1vJOl9Zizy1KDf?=
 =?us-ascii?Q?Fgw5Z9nJ+FbXpVhuU5c9Z1ViLonE6aKezKjlHqeqvqHDHe71CjyaCZJ0+/5b?=
 =?us-ascii?Q?Jlexq/OeJplcDBBaszMPezmmY2wDoMKGIkdW7r2mA1qxPBvG0sz9XZSn2zBP?=
 =?us-ascii?Q?mLIPf/cu2WgFOLoCDW3iEzomeX9dU636z1XBEvYKs36KrXiPpnASn1hO5CfH?=
 =?us-ascii?Q?X1SKInNJoez92xHNRXnsmrr9SiKq9tCtY7n7ktEv5rMh67edMs+YR4o6dTsp?=
 =?us-ascii?Q?zbc2yHvry7YoBCSisPjo0cU9kOuqXSyKl/PzX+XeCDlbSTtVO9NMjhNbXRp7?=
 =?us-ascii?Q?Z/LpS9he3frONy7lzIrulFpeVdBh+nS7nluyyRFFu7N8j4EOTtNl/eYIpcDo?=
 =?us-ascii?Q?NM2RonJrHv/xzgyzj7ZCWmfK2ajhcd3l6ILPHwYWn7nYnrXZ2O7/29SMmq6p?=
 =?us-ascii?Q?LJR5XsTyyPgBeK8K9Jko1z9l1vmCXICh66GM/Vc0/PdzAAVvtS+DWUVrbK0o?=
 =?us-ascii?Q?RuH5Y8qiffKYIGiilLagZf+fNyZFIF+ECvjNnmHP42FnzPD4fAYWmsA5259o?=
 =?us-ascii?Q?R6jPzyJsoCOO50/cY0G6mhCmMTLmQigY4QoFwTsqSO7fffV5327cIXrmjOjM?=
 =?us-ascii?Q?lgpivEDPqMQQ54jZxhcUKl2lOy7Hz1U+X9d5vGjCGbrODV7c+l9vacz3MP6+?=
 =?us-ascii?Q?/hRNkgdCSl73i5dQS9eoBzrsyx5mMGc7CQtVyiErjFY5ghuA1PhszMxmkteZ?=
 =?us-ascii?Q?dEYVowzhquVsh9nZ2nF+wDj3thpWHYo89FG6BiB1v45QAEb98E8RUb+PA/uW?=
 =?us-ascii?Q?dl3FJ/zBlTfSzvfjpszrT12YTkSVE8qkEE12fRL0O7fNFFYc7Gov5R0tdjEO?=
 =?us-ascii?Q?cFofXXWV9/VPu7RwzxPD/Nk+1qIyspux52G5xvSN3mQxeuMhNzJDB5l3d/pn?=
 =?us-ascii?Q?IeFjiEi5f6C6BidK3xByz9J7cM62pzOSDr12pC0jWMiiC3E+dVL+3au8RgvB?=
 =?us-ascii?Q?aPYXN6PW69eGn2H38mXCV1NynOickhqy94B5ZVCCZSvfnHKmBhWCS9AdQLNO?=
 =?us-ascii?Q?9tU415oUybBItBxiMrwsreY90NxbIJRp9Rq8oy67?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ce12a1-fb82-45d9-68c0-08dc1e387c86
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 06:31:55.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8W3I4+nzxhlNmSgB5z6RiSKio0tAvRG5l0uwidRu6GUNYelcYAdpls2uW9Z41keimC6nj/LA993SbfnXNy3EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8391
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:56PM -0800, Yang Weijiang wrote:
>Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
>Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
>post-boot(The exception is BIOS call case but vCPU thread never across it)
>and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
>VM-Exit sequence.
>
>Host supervisor shadow stack is not enabled now and SSP is not accessible
>to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
>to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
>before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
>SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.
>
>Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
>in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

two nits below.

>---
> arch/x86/kvm/vmx/capabilities.h |  4 ++++
> arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
> arch/x86/kvm/x86.c              | 14 ++++++++++++++
> arch/x86/kvm/x86.h              |  1 +
> 4 files changed, 34 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>index 41a4533f9989..ee8938818c8a 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
> 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> }
> 
>+static inline bool cpu_has_load_cet_ctrl(void)

s/cet_ctrl/cet_state

>+{
>+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);

nit: unnecessary brackets.

