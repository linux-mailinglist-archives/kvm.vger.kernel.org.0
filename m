Return-Path: <kvm+bounces-3296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA162802D1A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFF87280D23
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 08:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EE9E552;
	Mon,  4 Dec 2023 08:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hcU0RzwW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20C4CB;
	Mon,  4 Dec 2023 00:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701678328; x=1733214328;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rRl/wmyw9p/0Pj5dYFRxUVRR36YGiszFCDFzJ5lHNig=;
  b=hcU0RzwWCw0EgVoYW+Bmi91TZ6iaJTRR2pjmHdHr47YFfpgCDuJv6RpO
   AYjWcuD+9egODcl5DuGVpSP/k5SvIGvrN7BGHnWeYL+GvkJ+LQD1t4Bh1
   UiOwjsWDoUBa+GrFj32qPonqDXfC/rGt2ysRA1o/9RHSnPJi/H1rzjqFX
   9eCU7oFzqn6dk5V0Jrlwl2YmkN2P4c+N0I9EmfjJPNS11uwVqUt/dsbSU
   wnzEAT//iNAfD+VX2JmWCNdkHFMjdBKShCepLrK1OSV2HMFQV6tPcjfpu
   1ayuG+x9OFr6F8StHnUoa2HCVyHF4aWahX2PzqHqMe3SKwhCMuPkrTb8u
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="384102672"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="384102672"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 00:25:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="836507777"
X-IronPort-AV: E=Sophos;i="6.04,249,1695711600"; 
   d="scan'208";a="836507777"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 00:25:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 00:25:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 00:25:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 00:25:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 00:25:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5LLEWX7dRObtsB6BJ1X+f2qvWqkVK4fLrD3hGvzey74cnV9asH2FnsSnzWTvNr4crgWbUUe5s8EqgKMZCXCgo3Ca1dP4Chv+U5KaP+n2MmltjbkA9kxiCyY/d8bI7+qpVpMT394TgbJ/uHZhjEe3aTSK7qnz8laA4IXakxwWeUx2dStpbU/m6BpssVs7W+Nn1MS9AmsDIoaFIxaqaigApur022LLZtc4LjPMivAbBjJK0hvQmgVWuJa8bL59jvI/3JY7/qouGcB5tQrx6D3/ARgWxiSwfumaOeI5YXDeiTeVraNfVz5N1YLf3GVrD9MLuYvUD0s+aUGAvkPKuutbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXWt9qWvYkX7EIuk0s/JxHCI6uT6KcxB9+Ou70jwlbA=;
 b=X3Pyv3jK2X0uKD5VJ6mt+WjTESi4yvW+sJGfcdJyPl4OmJd8bn3/QUhQbMOAwXbrnI3JEZzGFuVf+FCH/TZAx+HYy/FidKATbsPNPwECLajEQ2tQRpbDc/7fVZIlQwZnTI1wX0i/guf6GO7XjO8nk+8Ruf5uBMFzNaxkN+TIfckJqZh/CDWWN55WezpgWMXatf8ryQQJ2C0i7l4dnk3HCiYyqc8fv4Q+JRPGxFV0tbetcns/kd/rdl+fCswcLuNri1yBQUlOVF8WzwNXeKyCOfvDPRg/GsiXS4CSUUiG8Lw0eQFyNtVOazgmWDX/plRMHwRb1hayZFg/QQ0/B1OPnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN0PR11MB6133.namprd11.prod.outlook.com (2603:10b6:208:3cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 08:25:23 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 08:25:22 +0000
Date: Mon, 4 Dec 2023 16:25:11 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, David Matlack <dmatlack@google.com>, Kai Huang
	<kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
	<chen.bo@intel.com>, <hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v17 004/116] KVM: VMX: Reorder vmx initialization with
 kvm vendor initialization
Message-ID: <ZW2M55f/+m8dEQKE@chao-email>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <2ae2d7d2bdf795fe0e5ef648714d56bd1029755e.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2ae2d7d2bdf795fe0e5ef648714d56bd1029755e.1699368322.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:4:91::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN0PR11MB6133:EE_
X-MS-Office365-Filtering-Correlation-Id: 799d34ba-6b73-4bee-44b2-08dbf4a28e54
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s9VJNzxKvJKLW0PTY3oviz+rS0ALcZp83kanD3dBUm5R82etIBa/tt5zvo95gAp5iCxlmLMtwj2M66BrTxzoGLArRuNff0Whd95FcvfE8HwSbwp81hyLRLRWoztVHTpecq32YKA2OZi1f944MyZcgMNhJtWqtdUNw0P5CCeY9AYvPH65s83E7nnMcQqM0d7p56qhgvp8csP4pzYklyz5egOI+914+/fvFceAJY4atKQlUI9Oatoe6SvgQZHB6DYyBMnJ+q2HuekoP1snobR3FlluAdrbqkPwRXz26uQYc5dpgt9QqMIXvTY4G1io5bt3ZVB31JWCwcXyw4NWaFtj3b8eAtYaV0gXSfmYmDrI2p9Cikot7tNfBn7XCS803IrxFNb908kDvZ5Em0awyuGELkUWE3FA4ZcjlVNLG4CQLYQWlSRU9V7tnS05w5AF5YIkFqeUJ+dnKIoBnRoQP8W9ZlAoBtXChNYk5ynSs6e6T1OT/UpmhFpMCygtDdAPI80l99d5uhPTGWyZzcJU0mWDYIayRD5B/nL0WWFV2DqBJmcCv/ovFNPyR32R2b6VFBH0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(376002)(396003)(346002)(366004)(39860400002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66946007)(66556008)(66476007)(316002)(6636002)(54906003)(6486002)(38100700002)(2906002)(5660300002)(41300700001)(86362001)(33716001)(34206002)(4326008)(8936002)(8676002)(82960400001)(44832011)(6512007)(9686003)(6506007)(83380400001)(26005)(107886003)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JKW5BOBDI5dDB0zWGFLzGKqemP3eJCDk+Y9/Xab1i/Dnh96RTZy33yMqWTqV?=
 =?us-ascii?Q?pZ03DXRqqxlOLNKqPT4HD5/vjbpFH14Xy1SThAqq+d+Jb737W3tpXuSBMZsF?=
 =?us-ascii?Q?j6x/mQ6qMShkSjTdXBAn8Un+kFOia/6sBMLJp1ZxHAu4QN89nJTn6sYzwDUt?=
 =?us-ascii?Q?Cp8uYtc7nki5u6C2PqbnUxbMTIESgGtI+RHY6U8dFspEXZe7AHrCd8p7Y+vo?=
 =?us-ascii?Q?GuUJSG8x5z1qnMEn3cewskv2CnpzHt9HMcRri3ctARRft3g0h9ztVXx+52Rj?=
 =?us-ascii?Q?QIGVYImEDs0NINv3ncfFSNG0q2Bq7jl86fdhaFrLG6cJSeqS3spBzZtNkzr8?=
 =?us-ascii?Q?PdgrgpxdQ69NQvdrN1Dstq3LLlsyH3/FA6jVTrvSC3dLtChW/eQs+I095cpo?=
 =?us-ascii?Q?G4SftLzK3hRL8E5VCTivpa8+A6/WfBXXz3NIvo5DvZAHtdJl+tuzlozTE5tM?=
 =?us-ascii?Q?C4g7kuFj8MmleuKwIXHcMBkmdUu/r37nc0QJa8qJyRTfpExzfKoHQeLSZX3i?=
 =?us-ascii?Q?MY3A6BQXdQdGK0iYbTdOz8Hce3ZnDSXTBblU59QnuHe9D43TU1mLuekUQ38G?=
 =?us-ascii?Q?RxIK55E+BmZX/fcbqdEh4FH0Ns/hr51RSaGlUp1YFfk7ZNBquKFbJM4mvLcA?=
 =?us-ascii?Q?zGfsmx4++n1aIU6PzpWIZebTkkNz5qbC7qbWhfLN6Qvk0y2w7dlpzDmawHfn?=
 =?us-ascii?Q?Tf+GAPqV9qdCybXe37CDKY8/CUOZWe7kHvVlRNRlk0sIzK1ylpuoVS6BK12e?=
 =?us-ascii?Q?rcII4d62FwJwYfMdmflCOBpu8cBeITY85NnBt1B4q9D223W0Mo4SBjEdulBr?=
 =?us-ascii?Q?SUeHhaoFkLrRpJALF9zPVMKACWMKC5VcBM82LvQxwKfNTV/mAYG1wD1xw7vA?=
 =?us-ascii?Q?LH+iao2XF6KgyKsy1LKi8vu/G3gPpjDx1UvTIjWrF0vr61euEJ4ChzBatltF?=
 =?us-ascii?Q?aW0I//hJ6F7xbLnB/Crl23m6E9X43h5FGcTg3cFZz8RS9Tsa0W2yRMtEC/ei?=
 =?us-ascii?Q?rV3ITKfPU8xKMROXEOGRct42f9SZB91ReqhetqrxB+LeruqNyRbKx1o6KF1Q?=
 =?us-ascii?Q?pu1EsPJI9yK+0xplH+PfmSx9nAoCnwtcgMR9+mdFPrEQl+NDvjeP/Igy7a0o?=
 =?us-ascii?Q?laem053NYiQ/2iaakly+I3x1i0LWKdNs67HS1Q8MK2VXlHAx04szb6Nbu0x1?=
 =?us-ascii?Q?sr69RQuWmgHdoBDhzTNMxssP1WuVrr/9x2D/GZD0YQPAu6R0QfHcp0U+6kzb?=
 =?us-ascii?Q?fzD2KXRHdARTXRTlXL0anMpM3VZMndyfZu5ByLjT5IaLJY2J/kd/o+L3aDHd?=
 =?us-ascii?Q?//cEdf+2BBtTxVaxQjiZf+yD8ugqIO17k2PY4Y9bqgHlPD+gnR53rsOK3ekj?=
 =?us-ascii?Q?aBV8MhU2Rcsnoo6KjFR719GW6QcQXVK+UOQ/xPx8I1FnCTvyRH235A4Q8OU3?=
 =?us-ascii?Q?vdRzFzkf328CNf4eB2RPrcVzxX+8q0TNA3yJt4948lGW8Mt8qL1cpXihaoaE?=
 =?us-ascii?Q?Bmp+A23qYZiBhaBvKWxgm1vT8clNI7AM/dUtiEmhgvjcxLOUJlY2CrFlEBDE?=
 =?us-ascii?Q?kJkNdC+KNfCvhVvNlXc4lX0iXGSnjM3wzjwz5qSJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 799d34ba-6b73-4bee-44b2-08dbf4a28e54
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 08:25:21.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyEFC09eHak+Oh5XO0YOOotrLhS2F82mV1dTaNSlfehRpLpq9RR8ErPf+0W3uuuswasxNEVeLhWfRq9e8QL7cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6133
X-OriginatorOrg: intel.com

On Tue, Nov 07, 2023 at 06:55:30AM -0800, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>To match vmx_exit cleanup.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> arch/x86/kvm/vmx/main.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>index 266760865ed8..e07bec005eda 100644
>--- a/arch/x86/kvm/vmx/main.c
>+++ b/arch/x86/kvm/vmx/main.c
>@@ -180,11 +180,11 @@ static int __init vt_init(void)
> 	 */
> 	hv_init_evmcs();
> 
>-	r = kvm_x86_vendor_init(&vt_init_ops);
>+	r = vmx_init();

> 	if (r)
>-		return r;
>+		goto err_vmx_init;

this is incorrect. vmx_exit() shouldn't be called if
vmx_init() failed.

> 
>-	r = vmx_init();
>+	r = kvm_x86_vendor_init(&vt_init_ops);
> 	if (r)
> 		goto err_vmx_init;
> 
>@@ -201,9 +201,9 @@ static int __init vt_init(void)
> 	return 0;
> 
> err_kvm_init:
>-	vmx_exit();
>-err_vmx_init:
> 	kvm_x86_vendor_exit();
>+err_vmx_init:
>+	vmx_exit();
> 	return r;
> }
> module_init(vt_init);
>-- 
>2.25.1
>
>

