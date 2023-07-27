Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C2D76455A
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjG0FSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjG0FSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:18:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526EDBA;
        Wed, 26 Jul 2023 22:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690435088; x=1721971088;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hlRyos7jpQu00uL4l7M1q/UCcoJbtHQoqg/Haspscvg=;
  b=Xe1QrzXKggStOxda4iyJfvZar+LsnJYDJQ25xiI16sZiMZ/R89tYh0W9
   pS/rH5srqZkV6N6qhYl6JGKUPNGHyw60GusFxkmvPLHuX2D4gkH+nXjYN
   bxs/xd8b3EC7qAbAMrnkzyDrpKaksfUXjyO4QbfbkVvLfqUteRQvM/9gn
   SAsIAjDy3A/cFjSYS8QI1ZBKsDwO98Q5uz5LRuTtyVGN1ZQE7U44p3iPn
   CcjWOKnZMkPyZQOU33Oxxx5DEeVPkkmh1zKxIhLkcQRn0lquggg35+w98
   NM4jLkBkWqnJQSfIRcVEprCy8e8bLjWVidRoLbFubetJn0ygIzFZ9h09n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="434484031"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="434484031"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:18:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="900727741"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="900727741"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 26 Jul 2023 22:16:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 22:16:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 22:16:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 22:16:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 22:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJbtg5sBK3u7tVBZLHAtkedldDnu+atCyVn2cFUPcJ7FE1U9z+jYRMgUu/W2AOQdQPQbEMEkAkuiTLAnQtV9odV5j/JQgKyzKViNsxmZaPTd9gxmy4DWemhZHqhtehKXRNfyNKytmEXbvC8FaJxEaItGVjp6XirZN9aaWrch07oyYSjxi5ZDbrII/TT2H1VvOD7rIPjEUt/98EHLYhS6PZSD9DyYlj2YmzGs2jrKxnJZ9+WTdhZorErjBWZbOC2prRnanPg3Shs5O8EYaoQF+5AP+X/XDEFJZ9zgg1KQMqyNyQLVJ3eQCRfyxCKXq8J3quiH3MpDEYmQmzL0FdfOXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ea2Rwct9wWvFGFzpoIK5jUjr2nbpp5ejDiEZzs220nU=;
 b=iVLJAIL89IaUl4KMUC0Rkc32MsAtRDR/Bsn4qNAkB5MUfVmh5SAtbj5qGguFtScKonLK/qOljeTfqcczC+2W0NF8mFkAr5WNy5GNVkKpNzchBaunuSHXej713SpDTg80eCbOep1//11COiMj5u1xjImcKXzy3GGVOQU7vDiwoFXmCuSSpNM75RL27JNry9436vrlLLqrPve3k4sW/MQYLhUYRLPEvb/cTWoWA4UtU9Vgb2E5cW2ETA+V7PXADn7eZ/Am60fLd6RMX+qVoGDVWcPSjyE+tgj762GhMnpcbR5f6nGRH6S/mRuuuonmGBsBDnA8Z7zu6U4L2AYV7jqtGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Thu, 27 Jul
 2023 05:16:45 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 05:16:44 +0000
Date:   Thu, 27 Jul 2023 13:16:36 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
Message-ID: <ZMH9tIXfPk0dl7ye@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-14-weijiang.yang@intel.com>
 <ZMDT/r4sEfMj5Bmu@chao-email>
 <3d5fdd07-563c-6841-a867-88369c4dbb36@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3d5fdd07-563c-6841-a867-88369c4dbb36@intel.com>
X-ClientProxiedBy: SA0PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:806:d3::9) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SN7PR11MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: f34772a5-14b3-4e82-08df-08db8e60ab25
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FwePd+ZhxzlQHWIQM0XQK2D0s+ft1LZd+ujXGrkZ92JBxtKlcEsDdPshjDasJtA6B0vdYiMeFMtSrna54lBhE4SGcghALoaJRmM9kKe9UpGUEchZJHbPGrTSiY49svl3E36u+iu+plebtMrj887i3aZJihRTsbbgXiy2c5Q56+a6eiuExyPnIXZgoC61KZDHMspzO7k5Fymv1w4ie80UiSTqJNOdjOA+3phFrZGyY/t2uKH/9Sh6pvT7ksYHGMYPTq90AljHrblo8wViXqqVdclZjtMBDI8QC7Si4XSnxMCHGThu08fCOyOCbV6YbWYAl04b2SXNvQ+lqpaom/H9wiT4m5cfUcKyhxt3vlLd3nMDZo6JvFgmhDiIxKomQ/PKP7QAP0VJ4xrXfb7kJx0goAj0bSdgDu4Nx9kam3L6YkIQYwuvjk2J54lh41MTEAYe02dvhjEPv1FHEkbCjggESrxpd2e2YH1QfOpnMkYuIikRd9tawc1bQqvi8ONF8kzmg7znbClRdzEpYbTq44+EtzGhlvw3VkE1o5CZB8kLbndWgdLcYDCmzPhNu3iV6p+M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199021)(5660300002)(8936002)(41300700001)(26005)(6862004)(6506007)(8676002)(186003)(4326008)(6636002)(316002)(33716001)(66946007)(66556008)(66476007)(86362001)(38100700002)(44832011)(6666004)(6512007)(9686003)(6486002)(82960400001)(2906002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZTA4ROTzagDUZKPVywaXd0a8KCGc+eHcaQhG4ApAFV1bNgccuK4TLcFm6UEJ?=
 =?us-ascii?Q?TUdBWl1h6hDX1P77mHsOfhM3qg6x5s1Q/KvOqsSWief0VMzbh+I2ZvFVShW2?=
 =?us-ascii?Q?atR+0XvQ2g8P5/y/scwv9n5kJDid/5edra4EcoFnNJR4LQ9mMf+QS1Sb+opW?=
 =?us-ascii?Q?d/Gnc59u1zi33daALDpyi6v2vZzd3k/Krj469hF1+qPd7pd4QbxIyu6K1lWY?=
 =?us-ascii?Q?pdgrgyv+CZZniO+gT0Qxr1kqZ9Dy0SibXXce+WEp18ZW12c5VVj8kGI46LV8?=
 =?us-ascii?Q?lcJuDR+m/FxmitfZINRYzpi04lunUCy4vtotXQbdYMmBkZcCqgomgQ0BPful?=
 =?us-ascii?Q?Ed2+VNK8VGY+Ip5jyDGoSMoHUC2LC6sJOp0QvGv1J7PbisIMTdyiGp9ir7C9?=
 =?us-ascii?Q?vOZcXH6cbQ6NXIxfbHNH8aVFcV5mz8sUk9ypScattysgnutL4abilJX4FMCv?=
 =?us-ascii?Q?Z+CvBffiKUL8i+SI7d3d9wEJ6nFUKKPsngSK82kaUK6r5S3Bs2eWKcj2t7xL?=
 =?us-ascii?Q?eaaUZh/odrdJUiJUb6qwZyPcJp404pFApD6f5cH8INdeyo5i6yfKeGaSLjFG?=
 =?us-ascii?Q?IMGOicW3x+B/y9n0RZtc0ApPy5ydFLCnVfc98xY6CZw6cjtKcHdUOH9/7o6g?=
 =?us-ascii?Q?gtkpJvT6+i9EUIAWUCUfRk/d8xc9W30wYVkse2j2KdvaFNIWgsct96FZ9HI6?=
 =?us-ascii?Q?sUuWJxhfOXVFtQhD0CqmmZtnUXtGaqUwNIJcnCbEK8irrhPkLMVovZ2N43+g?=
 =?us-ascii?Q?G1j9Mqzcxh77Pe1cdsGV4tz/tLfJQ0Z+VaUCkCuNuPnVsH9m/aeZZGmk+agw?=
 =?us-ascii?Q?/cAa4ked9Sj2yI1OYIYKa5SS4eK/cVPCTSW3h9d2RLBGzQ8sV6PGg8gzBSfF?=
 =?us-ascii?Q?BwCXOb4152CCSjviihGD2AoBFkXUhvDlId+UtmUBTPzuXAPfLO8DBkyaxiZ1?=
 =?us-ascii?Q?Kibi15IfRTClk4qQwbK+4FpT1b2BkFV/604nhIxKA0c4k87WBtGFZDn0U1QC?=
 =?us-ascii?Q?0KWM5DMqf+s3Ag/exE83I6gcGHDfZpb4WhkBN5Ebrp6YkMQC1twEgPx2mIZy?=
 =?us-ascii?Q?y5OoPVXK4tEiZpbH0GlR0fR0rknwdY1ckfNMpxDY+tGZQO65zuBDCua7Fg9g?=
 =?us-ascii?Q?TambJY2oCwQcj00KspBPsIKpIzOfHUOqxHqtwNz07iTtE/G+YJuw/tTIV+3w?=
 =?us-ascii?Q?cZiPiL3ovO8yiTAFR/eZgxecD2uV3bCEGvmabN4H3lkGllofnSQB0O6O0Yxm?=
 =?us-ascii?Q?yUG+Rpx+wAga+rOO4FdJBSAQCjmER+lx0W1/RsPXIbRG+4BeBlmev5KDHCyA?=
 =?us-ascii?Q?mTrz1b1m+DDf1BYDnjGqBWd7SY9mPMwv3hGxxTn7/6IH27zYUImKHl6VGbl+?=
 =?us-ascii?Q?8vwbi1ngGhKVD06nyZjio3wkYBSMfsTyGfRY9hW7K9v0Sw0AR31suWDfQgvQ?=
 =?us-ascii?Q?8lf8Wxd247KeBKwhvj2+pPpnrW45rfCzMvqNi2BJ4WAqIzy2mrbitYFCInc5?=
 =?us-ascii?Q?4O1tLjj8oC+Mo90J8RxfEOJS7KNmd9eEFJVICQugZqk7XV9llRHKjE4wQnGc?=
 =?us-ascii?Q?0aa+ovXsZ527GDqpS44YwnYO/Wpqvjg49vGkFUXd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f34772a5-14b3-4e82-08df-08db8e60ab25
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 05:16:44.3556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gfj3bIDNJH4yhmsV/Kar925IKPvXeleR28wT3MytJKGFhYz89uBcIZNfpBB6tvyH+HDIn8kTkpch7ri7x5a7ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6996
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > +	case MSR_IA32_S_CET:
>> > +	case MSR_KVM_GUEST_SSP:
>> > +	case MSR_IA32_INT_SSP_TAB:
>> > +		if (kvm_get_msr_common(vcpu, msr_info))
>> > +			return 1;
>> > +		if (msr_info->index == MSR_KVM_GUEST_SSP)
>> > +			msr_info->data = vmcs_readl(GUEST_SSP);
>> > +		else if (msr_info->index == MSR_IA32_S_CET)
>> > +			msr_info->data = vmcs_readl(GUEST_S_CET);
>> > +		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
>> > +			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> > +		break;
>> > 	case MSR_IA32_DEBUGCTLMSR:
>> > 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>> > 		break;
>> > @@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> > 		else
>> > 			vmx->pt_desc.guest.addr_a[index / 2] = data;
>> > 		break;
>> > +#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))
>> bits9-6 are reserved for both intel and amd. Shouldn't this check be
>> done in the common code?
>
>My thinking is, on AMD platform, bit 63:2 is anyway reserved since it doesn't
>support IBT,

You can only say

	bits 5:2 and bits 63:10 are reserved since AMD doens't support IBT.

bits 9:6 are reserved regardless of the support of IBT.

>
>so the checks in common code for AMD is enough, when the execution flow comes
>here,
>
>it should be vmx, and need this additional check.

The checks against reserved bits are common for AMD and Intel:

1. if SHSTK is supported, bit1:0 are not reserved.
2. if IBT is supported, bit5:2 and bit63:10 are not reserved
3. bit9:6 are always reserved.

There is nothing specific to Intel.

>
>> 
>> > +#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>> > +#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
>> > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> > +		return kvm_set_msr_common(vcpu, msr_info);
>> this hunk can be dropped as well.
>
>In patch 16, these lines still need to be added back for PL{0,1,2}_SSP, so
>would like keep it

If that's the case, better to move it to patch 16, where the change
can be justified. And PL3_SSP should be removed anyway. and then
"msr_index != MSR_IA32_PL3_SSP" check in the below code snippet in
patch 16 can go away.

+		/*
+		 * Write to the base SSP MSRs should happen ahead of toggling
+		 * of IA32_S_CET.SH_STK_EN bit.
+		 */
+		if (msr_index != MSR_IA32_PL3_SSP && data) {
+			vmx_disable_write_intercept_sss_msr(vcpu);
+			wrmsrl(msr_index, data);
+		}


>
>here.
>
>> 
>> > +		break;
>> > +	case MSR_IA32_U_CET:
>> > +	case MSR_IA32_S_CET:
>> > +	case MSR_KVM_GUEST_SSP:
>> > +	case MSR_IA32_INT_SSP_TAB:
>> > +		if ((msr_index == MSR_IA32_U_CET ||
>> > +		     msr_index == MSR_IA32_S_CET) &&
>> > +		    ((data & ~VMX_CET_CONTROL_MASK) ||
>> > +		     !IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
>> > +		     (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS))
>> > +			return 1;
>> how about
>> 
>> 	case MSR_IA32_U_CET:
>> 	case MSR_IA32_S_CET:
>> 		if ((data & ~VMX_CET_CONTROL_MASK) || ...
>> 			...
>> 
>> 	case MSR_KVM_GUEST_SSP:
>> 	case MSR_IA32_INT_SSP_TAB:
>
>Do you mean to use "fallthrough"?

Yes.
