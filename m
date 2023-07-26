Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD5A762F71
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjGZIQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjGZIQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:16:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B37D2D63;
        Wed, 26 Jul 2023 01:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690358803; x=1721894803;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lYYLsKwE/7FCMx5+2B9ScqFLeyQNePS6kXATSCcGwBA=;
  b=Iw5/RkNWTqHK6/jHqEjcgz3memyix3pIo11PVBro8eqc1ru+LkCkgYjP
   6PPmAjif9WDFLJ3PZE7caqQsauxcdmAuI1BJTjjATZHM3tMDXpWgCJHgI
   /vKIBS0cACehMeROIB9/Obwk7rOToaMskqVhbWdWnTMg30LrEPD45EZ5Y
   LP3b7f3wBMvv6KAiNdi9BZtcRojmQ3J+URyguAw8z9x5pTTnhqJPgF3ig
   kAkLbLTVk+GmWX4aIPBXekuHirkcPC8pCofgaIIaiRTAZ6hvH12FJy9OG
   xa7lQ5jEJGY8i2zvnQm4DiBZHle/DrZtUEiltGR6BeOw24q9N9ebUGRyi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="352849887"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="352849887"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 01:06:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="726423313"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="726423313"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2023 01:06:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:06:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 01:06:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 01:06:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 01:06:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6vWdznIEvxyseYHNq4TorcV39ReRX1lVlXDYqdOyakl89WrN2uG6++iTQa17W5dHDluR4aVY/uPtetUuNIGR/EjvcD4n3+Ae5KOqdoETQGht/mWxy30pVAyKgAkorobiUQ+yzmZF+yXBPu4dZFpCd9HiysXEHGfYwWRjdWwyDe9UZ18hal3Iy2IDxk6RVwNRoJ/doQc55wfDdVD0T0qaqenxbS08ikaYFo6T1c7rrGhYTKd7bVtf7EzjgzrODsBnuWUWV3zl7Ct50VIjC+9iK4L/wi8BtnHzfrStzfU3IGciEv1z+vYzhB4zWOiuuj1CNiKTrkfj0Xwx7TVDqqGKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj4777tfc0aTtRcvyW6uQy3ZwI/6j3af2D8dvbiNv18=;
 b=CZ9mVA7teaUMbI5xCHscmC/4T6HrZM2Q1vWTIY7B2i+Fg8+yObQHS0TNCvAKNUtAYN4y4AvDvuzi6kydpp2FrOkdewci2iJ+HkJtKTqRtIw+HX1IzGIJk3AB7T6ICjq5ayA1LmqJ3kQW2WiWPscXjg7S7xtvykg1FFxsKtQZ/2LxownBnmBO1keqouMo5V6OASNkqaQuM4kTFEciNCtY3l2dOiRHUdtGlfNeLZvLwK96h/+yxoTcwUGIN1Q+uNZrcsMXUVojcbKX75CT/nEKS+XDg44zDkoEM7KzvalyzaLVNRg3CPlyxsUpfb7sh6YwADZwYR1m54XPfh7pwXqWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Wed, 26 Jul
 2023 08:06:32 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.032; Wed, 26 Jul 2023
 08:06:32 +0000
Date:   Wed, 26 Jul 2023 16:06:22 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
Message-ID: <ZMDT/r4sEfMj5Bmu@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-14-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2P153CA0041.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::10)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|IA1PR11MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e4f219-1011-484a-33db-08db8daf3900
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNe7N0P9/mv9kQXQ4rMxErFnWR9dTBvziu+ueyOjcU8hjlNW8/It/eu35R/reiUw2ZPHK0vJj0+1TAypzZcCYdkV2IFRpEcdfvILrRxsctJ2FFUZqZt5sRT8P/Qw/NHlXMvBmAxvW0/DxqE2eZz2b52hH8jKWaLmUpqDVS4bdl3Ym3us8x8bWg7S8m6xY6RLwyApwllVdryoxLVEFL5MkLWhWrE62ptFS0Rv/hEKyUagsEkRt9Bvx1fWVzM/o1Cb6+U1XmKs2/jApJNGZ4zxE9JPNgyGaXuLgOK3/yH6hisPws8toUQVUIzCJaS8HHsgkyn5NSjrzBstvcqtj2S8q0T0BtDoKylV9XqRq0ezH5gHsHROGtJBegweIZNlRE8k7BXGxM/0l/l46DJeivK0Dv/BhU1yrwrQQ49H5MpzT30d/PBLdIfpG20SX5Ski//Mxt5dCy2SzA1gBYvOJJ+ydE442cvt1PpiZ3TEYaJQMTTN2q583xzFJynTx0yDdB7wYRJBu1FjGj1VmUqPaUupN2RDHcdWBrc1+ctgxrm0sjoBdQSAu1qwbT8pObQfn/J7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(44832011)(6862004)(8676002)(8936002)(41300700001)(5660300002)(316002)(4326008)(6636002)(2906002)(33716001)(66476007)(66556008)(66946007)(26005)(6486002)(6666004)(186003)(478600001)(9686003)(6506007)(6512007)(86362001)(83380400001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WFa61eoMpZLkDobtfUG6inXPZxi4aET9em65yoF762y23T+sj+avg3gcKD1E?=
 =?us-ascii?Q?cebCMb6bd5Yh52WRNWNVWSZCDXQa+9o7nVGT+rWI0t1k9jptckTB5BRJ0LpT?=
 =?us-ascii?Q?H87377rVBkTTDqch+HcBavBOcoeQnxFWbTVnqg2bhwIbfMJs54CdWjp4klia?=
 =?us-ascii?Q?zGSDSMQVZSvMC5dlo4+GVumTn5kKPxtH9qLlZkvnpzn+Vfm3N37SxE3iqJEx?=
 =?us-ascii?Q?Jvda5yuPTrC+7oKXbpnLvIlnqHQe3tzBBryP9pG2uhZ70ngBGNmAOS06jqPo?=
 =?us-ascii?Q?fnnWpsmibQ2oANgS/p9kU3XulFBDBGSbAJZOH0RzfbK6uLONjb/ablheIt+6?=
 =?us-ascii?Q?ZJQDQqiVcYRgs4ZysmZP6tybGbEbFc1YbrlRA7BakLiujqcQJ5xppqP5eYNH?=
 =?us-ascii?Q?3kRm+zUdlqlPry4in6KSMJqMH12AjGX8dcKRgE0FDfaGOEV12bCFsblEUqdp?=
 =?us-ascii?Q?hAhzyhUMdIbvItHaDi9Gf+CMKhKRl3FShZfMeXKSzIcJYJWS4KCw/5xTz74f?=
 =?us-ascii?Q?vOMOF9SAB1kqQ1a6QyAU1PGkc/j00ljw8ijE545KRfh/1nq3Yn6vk30zfUKt?=
 =?us-ascii?Q?/hXFS9UVFvtOOfcjRhNqlKojC57tNSjXdRyjlsSI7GiGtT4Krc3n5FqQawVu?=
 =?us-ascii?Q?wNWFrZ+Vyo1ikzaVl06JZ4TpIaa8OpGVvKR3SSunLmCdBnZYHMSYIZa8Vxta?=
 =?us-ascii?Q?1CmaOK5Rt5sVXy1mbx4I2kUpZRzHCyDflJA0zf8A0yIN1auaIYTqUHuhm3Tz?=
 =?us-ascii?Q?VzYtRZSbL9VPCTasYWeVmfiQPOuM3ZoRqru4zJY256/DnbkHj7Hp5sF7C7Yo?=
 =?us-ascii?Q?lPe1V9dq1QaNXdF75SarhFXjkiFzKKofVtA+91iuq+9rTDjXjDytaXFgb36L?=
 =?us-ascii?Q?y7rx2Lc6oYi90i8ChwZoFxVwjbm8G1lAN8Fw4HHOhy1IlBkcTYjuvXu8HcwQ?=
 =?us-ascii?Q?42MpIaXDy8ZUWYF2KB5+JbRAELfGMktEisJOBopRyWbqaEK0OOfYBaNyjcBs?=
 =?us-ascii?Q?vpai1Gg9HJq1BZ4lIS2w61OS3tfWuSi/7Y8Ow3a0RiHHQoIQ50NJaYNRVBe5?=
 =?us-ascii?Q?OIwcge9YjLf9jBY27VBGKyonAn3MP0n6+kd3X62Duo2F7rOJdDx1T9wBO+rN?=
 =?us-ascii?Q?NJc9x5/Xw96fuyac2mcRFf7DjdHGNAEWnNkhM8wxg8pjZZqdC7YXNtrLbwov?=
 =?us-ascii?Q?+TXV2+C6RL5L6txZmNIFOtfKWGdpNT31pKaJE395iqCbqZahA2cvoCzJRJ68?=
 =?us-ascii?Q?kWmIrpMTGp/TWU9Dd0jdPz4y6kD9pnE8gPxXU2Tm80iQqRQdQnJVI2HPERxC?=
 =?us-ascii?Q?rf3n92NQsoCkpzB5xD+DxbczwfSNT9IWURWtCVXom+yTUo4kKQUx5YUNmfI8?=
 =?us-ascii?Q?bS2dAbSNwaJukJmj3syPX28CE4Mm7GnGjYhmfHQxwGUxc/gUkxLkBfZDKVzk?=
 =?us-ascii?Q?bvhieDlgkn34Xid1VjrxKBGydEUq4uTgNKy8MuG4PdUURzUfRP8GrNS4KUMC?=
 =?us-ascii?Q?UhDJM3w8dC1muQy4ysIPAUhVvyk7oGKrWW/0d+U4sNIqOFZpDJkekNAhUq+D?=
 =?us-ascii?Q?DahS5XgI3pi9SVwozxlS78Q4rzBwfLmw6tWd7lAx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e4f219-1011-484a-33db-08db8daf3900
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 08:06:32.1084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mo9XVuwTrTfg5cRp5zNv5Mpd8fDdIk9XC8q7hPsKKMlJrwsiQEFIblU7TWMEPIBe1WaAl89fWWvZc32Il7y24w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 11:03:45PM -0400, Yang Weijiang wrote:
>Add VMX specific emulation for CET MSR read and write.
>IBT feature is only available on Intel platforms now and the
>virtualization interface to the control fields is vensor
>specific, so split this part from the common code.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 40 ++++++++++++++++++++++++++++++++++++++++
> arch/x86/kvm/x86.c     |  7 -------
> 2 files changed, 40 insertions(+), 7 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index c8d9870cfecb..b29817ec6f2e 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2093,6 +2093,21 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		else
> 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
> 		break;
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>+		return kvm_get_msr_common(vcpu, msr_info);

kvm_get_msr_common() is called for the "default" case. so this can be dropped.

>+	case MSR_IA32_S_CET:
>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_INT_SSP_TAB:
>+		if (kvm_get_msr_common(vcpu, msr_info))
>+			return 1;
>+		if (msr_info->index == MSR_KVM_GUEST_SSP)
>+			msr_info->data = vmcs_readl(GUEST_SSP);
>+		else if (msr_info->index == MSR_IA32_S_CET)
>+			msr_info->data = vmcs_readl(GUEST_S_CET);
>+		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
>+			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
>+		break;
> 	case MSR_IA32_DEBUGCTLMSR:
> 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> 		break;
>@@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		else
> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
> 		break;
>+#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))

bits9-6 are reserved for both intel and amd. Shouldn't this check be
done in the common code?

>+#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>+#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)

>+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>+		return kvm_set_msr_common(vcpu, msr_info);

this hunk can be dropped as well.

>+		break;
>+	case MSR_IA32_U_CET:
>+	case MSR_IA32_S_CET:
>+	case MSR_KVM_GUEST_SSP:
>+	case MSR_IA32_INT_SSP_TAB:
>+		if ((msr_index == MSR_IA32_U_CET ||
>+		     msr_index == MSR_IA32_S_CET) &&
>+		    ((data & ~VMX_CET_CONTROL_MASK) ||
>+		     !IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
>+		     (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS))
>+			return 1;

how about

	case MSR_IA32_U_CET:
	case MSR_IA32_S_CET:
		if ((data & ~VMX_CET_CONTROL_MASK) || ...
			...

	case MSR_KVM_GUEST_SSP:
	case MSR_IA32_INT_SSP_TAB:
