Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5086805ED
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 07:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbjA3GS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 01:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjA3GS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 01:18:56 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A20E193DF;
        Sun, 29 Jan 2023 22:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675059535; x=1706595535;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k2hGBmVX85AfnAAVhMVxnLon+OO8/p5S88VSu4lae5U=;
  b=i9xeb0ulvMuxipH+dRfBOvIFdav2tHDWeHIZerdlkGFresESwI6bINxs
   u87nnMf8y1FPW2A0y1jT7DgDUhzAXouHKOt5C+2NfdUrdDWMMlaIitl0S
   wKJ4ODnXmp0ykzDGsitMuI18nX08i4Xx8bxX9RWaT78pQTB3RkT45x1cN
   0fI0wh8wtYbRoDxcOQFq6q1G94Wiqa5GbPJLrhsi9nX/rlwLGuiJBBCtR
   8uJMumqhKWih28MPDxYjeyeRqGACX4a2HPMWtU9UYI16kCH0JP5sHZARu
   dp66iMOoQlvpVSopi31Iz//Fs1fvXUoKlE8QGUaM2W089swTk22PJfs9a
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="329603215"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="329603215"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 22:18:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="663982012"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="663982012"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 29 Jan 2023 22:18:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 22:18:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 22:18:53 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 29 Jan 2023 22:18:53 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 29 Jan 2023 22:18:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRZpAC/CgsM+5ZphPdTRJytGmfNEe/sxnV0JkhKbLQX5yJ+jh4rbJ8dRM4bqsI73bEltz7+L2f0sCiC1FPnBuemb6TJJm5PczBEZyQqGA/OF/Poy6UniJgQzg4z5aW7DWN3rJ/8+BHzgqh7Uz2jyM8GllXXMXFEy9IWkR+Kv7Z66i3X8Ms1MTTUMJnKEVocRQDA8ZnjXmqNJ13XPKAdSMhTESYfyCQQxY3ykfKFfj2oO84I+4jrw7Kn0YJbLBy7cDKtytQ8/uhDfP553HiaMofvsREdDV7NcGfg/lsgtAyMszUITKaoT9s7I55R0FfYW43MO0SLaz5SjnA9MjFT9tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4S9IQZ8TY05hlH4XQ+DcUPl12WV0LCmwiRAf005tHZc=;
 b=N5VqY8pH0JrRcAqjVviYU476PO3s9NYebPKEcC37NAK0vfp91nOjYEr1DtiXa27a5ZG8JnM+8v541jxdMycsjjCXzQbIc4yd20N/fFqht94oe+RLvXAU9gdgnYHtk2XzyxZUt3NoOwbMM6pOsaFpHwwPhedp6+EQSIVC8l4qHaFHlub2Dm3RgYKksLWjuARgI92Vas4gOjmXwB8Ikr68Nx6kBk2OCSxFD4i67JiyDmNjOvMEAeHeW7UIrh0IwCMHPMXy8Y91gU2HJyHH/pNbtjh17F0c2pXcLc/px38lLLhuFMtcOw16B4LZSAdvrlQzMCDG1l597sbskGMHnySQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH7PR11MB6331.namprd11.prod.outlook.com (2603:10b6:510:1fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Mon, 30 Jan
 2023 06:18:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee%2]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 06:18:49 +0000
Date:   Mon, 30 Jan 2023 14:19:03 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <zhi.wang.linux@gmail.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 4/6] KVM: x86: Let userspace re-enable previously
 disabled exits
Message-ID: <Y9dhV3dBpRYQ2jJv@gao-cwp>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-5-kechenl@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230121020738.2973-5-kechenl@nvidia.com>
X-ClientProxiedBy: SG2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::23)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH7PR11MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e28cde-cd93-4172-89f7-08db0289d97c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kicDLmh0dwUjJktHKYfaG5KZ/UzAthaK/lZ3c/S4LRyzxImwniFgLiwl36XExsfuiTMyflIzhb3ucmoomacVZiSlhxXfuV6xX3ZcwQzEA5ACVJvB0sL0S4WnZYfLICCLjjzevllv1A6bJNVb2Hp1738GylbYeDLoPSh161nQRSli3nI/L648hRG+N1wjrUU8dwDHCNImcMH5igIa8cOhkgwrFhJWObOUHVQIAVYuJxoSLmcGGn+oXuhife1+LA82bnJAhEQCdZMzylRLRdcVN1cqrCeuNYj3LIWQldLp65ObGOPzu3gx50+3svVTNVnxnmbIxy/9nMvuDo9lFcSJu1pcKthlWKOf1OevR4EQMO55RWuC+SDRxHeHZcndmwMLCB9LDqzVaxz2Me/a8W2kt9XGQwJdBZ5NhT+yCkYL6rkeiKfDlxMT/JAouXTzIje8v+RxuqEoXH5Kkrq8NPywc5u6vPnKtsfzc+Evu+gIiNVgAkG6J0MUL5oHZZhbJ5oDbYXNytECU4om7p5sHIjzbcneQfj3lJqTCyrU7Yssnliz6SCpEmdERG56myv12MYdx0iiE9WKScp+atlRdu8urTaMyQk6kXxNG/DDN992VRkUKfXQKYBYfZIIUkNIE6KRxbmZc6v4e+3jTQFIfPROjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199018)(316002)(38100700002)(41300700001)(8936002)(2906002)(44832011)(5660300002)(82960400001)(33716001)(83380400001)(66556008)(66476007)(8676002)(66946007)(4326008)(6916009)(26005)(186003)(6506007)(6486002)(478600001)(6512007)(6666004)(86362001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XkQowUNmsA7+DywSydaFng6FkpiLb/ZSqaEW8n11dN3k8GK5QsELQrxj6sh3?=
 =?us-ascii?Q?shd199Tu1VtF2ZD007WEP0oCkgUjYCI2Es8Z1BCFM8WnN140StUYyYeON66g?=
 =?us-ascii?Q?1XqbObCQOE48nY6YWMFIssuzF1OJlujozFAUbILFvX67dDThxxOkmAoHI23V?=
 =?us-ascii?Q?lwF3b/v6rB8Gd+3hoEZuSLGPd0Bd6IsITzTBpRBtcN8wr0fwd8un+665Cowu?=
 =?us-ascii?Q?2+LxR86k+cSpQ8zMvtBE7/YOknA6wX7HACUuMbqGoyyo7JeDAlgVxnF7N6+T?=
 =?us-ascii?Q?2+O6SGCfs/IEuyQTajb6Qy/OOAJdqYTdifmHZGdvieApWUnp9r9isbI3/LVc?=
 =?us-ascii?Q?SOFDEy6KYjO8wEGrcTnPoPkpQKB2pVd6jrRJdEFvSZK6v4jw7/XKPPnoStna?=
 =?us-ascii?Q?40KXBFjPCyf/Sj7OocyAqXnZw4VoL+rLuLZ3OIpog3JFifgbvb53/CvwLyEI?=
 =?us-ascii?Q?QXMx66DuCgrF2nZ8sXEsBAf1dcUuyQezKfywUUOTbdgpQfDS+uw+RS4KZAss?=
 =?us-ascii?Q?FppYQWoMXZwcxj8baQu2l5bwZuNHgO0Fe6/kI6QX/8Gy23L7uQNBR+NVg/2C?=
 =?us-ascii?Q?6MGt3mSCyz1w0MSlB1vqsuPlkk35xaiQdJvjboPxHQQtccXc89jCGOj5qi6v?=
 =?us-ascii?Q?H/IVEolbvxvlu9GMQOiRyxHQd9Ue9FHQSMuMqe3M69ECOyBLQdhwvf+GRXSO?=
 =?us-ascii?Q?dOJMpZKIKB2mQ+8OStj+/KxSSkPfXd9NE5lX2eyyjnakXO2siPP7lDnRCuig?=
 =?us-ascii?Q?BKngxKosS2FLqhT87sW3r9zPkKGDIN03/JVWPhZJ49G3MIs83abuvkXLVsBE?=
 =?us-ascii?Q?Oxe1Z/7e/dTciUVNn4keXAI7lff9hICD2AP15mmgFDe6VDQGdcRWYadzNwaV?=
 =?us-ascii?Q?aiYNGdRBy8Z9X+sCgRCM4ShK/fDp8jdYg93nff/XT6FMSGbZf2TYpSN1eCzF?=
 =?us-ascii?Q?C6sjGnn/sLK6cWBgriTa+1dpMXELOb1bfdvIlGBg0NIz2aj8/vQlqOnypuL8?=
 =?us-ascii?Q?7m9V2gClYLEDOGxTB1kOixcZf6lSKe0OJxFbn/67WKXQxh1U9Dgt8aGAUYdf?=
 =?us-ascii?Q?zs+WMZx8xGPPCCnmjq+jsRUDQURKzJt+6OwoosYk5Z61LDEerco5xhAqepLl?=
 =?us-ascii?Q?X7UW7mFAoCAYJIMZgtdRmMuNY2578ytBlSFT/uKSMTfA44mkn9UPBj6HKeeI?=
 =?us-ascii?Q?xpsp/4HNlwiAgrXIv6W3LsgN9T5RVlHRLVu6Zgvsygj/FUNlgyso5BZX5fH2?=
 =?us-ascii?Q?QqlJKiGd/u+EVFaQmCziAgK1UAQAF2vbgNA5mWku0dIguXzdlYJIxdVRlaMl?=
 =?us-ascii?Q?w0MUxYvgGt0eyoFigA4atckKZN7XkSufcCTTPOWIpZQlJPec4U89bA9HRMze?=
 =?us-ascii?Q?5W3BAj3S6XJijjdrfUhNAK9z90Gugf75CVY5n7hAjpvblrurscfySiksjytB?=
 =?us-ascii?Q?DUWzX4yhxlZvhktTfTOggTNNcl8hlQFWlgWAnqDJvOH75TqWHvIXfVKzCDRp?=
 =?us-ascii?Q?mYg9C0z/3+slV2Pc0tNy73fwf5GMuzq37OXZvLDqmPQnkTDL5TCHB5ZaaqDj?=
 =?us-ascii?Q?Aw/3PhtgDfCdB+yM8LaVKXHLlzNMDo3laiYMhTPU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e28cde-cd93-4172-89f7-08db0289d97c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 06:18:48.7537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlu8s0j6sMxmShFBbbVdiL+DvPTYPrEvbN5GP20GZSz/aXygWImLlA8bulCFcRf9b7yjhSQHjsv6kzfyYEqQTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6331
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 21, 2023 at 02:07:36AM +0000, Kechen Lu wrote:
>From: Sean Christopherson <seanjc@google.com>
>
>Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
>re-enable exits and/or override previous settings.  There's no real use
>case for the per-VM ioctl, but a future per-vCPU variant wants to let
>userspace toggle interception while the vCPU is running; add the OVERRIDE
>functionality now to provide consistent between the per-VM and
>per-vCPU variants.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Kechen, add your signed-off-by as you are the submitter.

>---
> Documentation/virt/kvm/api.rst |  5 +++++
> arch/x86/kvm/x86.c             | 32 ++++++++++++++++++++++++--------
> include/uapi/linux/kvm.h       |  4 +++-
> 3 files changed, 32 insertions(+), 9 deletions(-)
>
>diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>index fb0fcc566d5a..3850202942d0 100644
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -7095,6 +7095,7 @@ Valid bits in args[0] are::
>   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
>   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
>+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
> 
> Enabling this capability on a VM provides userspace with a way to no
> longer intercept some instructions for improved latency in some
>@@ -7103,6 +7104,10 @@ physical CPUs.  More bits can be added in the future; userspace can
> just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
> all such vmexits.
> 
>+By default, this capability only disables exits.  To re-enable an exit, or to
>+override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
>+in which case KVM will enable/disable according to the mask (a '1' == disable).
>+
> Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
> 
> 7.14 KVM_CAP_S390_HPAGE_1M
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 60caa3fd40e5..3ea5f12536a0 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -5484,6 +5484,28 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
> 	return r;
> }
> 
>+
>+#define kvm_ioctl_disable_exits(a, mask)				     \
>+({									     \

>+	if (!kvm_can_mwait_in_guest())                                       \
>+		(mask) &= KVM_X86_DISABLE_EXITS_MWAIT;                       \

This can be dropped or should be a WARN_ON_ONCE() because if kvm cannot
support mwait in guest (i.e., !kvm_can_mwait_in_guest()), attempts to
disable mwait exits are already treated as invalid requests in patch 3.

>+	if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {			     \
>+		(a).mwait_in_guest = (mask) & KVM_X86_DISABLE_EXITS_MWAIT;   \
>+		(a).hlt_in_guest = (mask) & KVM_X86_DISABLE_EXITS_HLT;	     \
>+		(a).pause_in_guest = (mask) & KVM_X86_DISABLE_EXITS_PAUSE;   \
>+		(a).cstate_in_guest = (mask) & KVM_X86_DISABLE_EXITS_CSTATE; \
>+	} else {							     \
>+		if ((mask) & KVM_X86_DISABLE_EXITS_MWAIT)		     \
>+			(a).mwait_in_guest = true;			     \
>+		if ((mask) & KVM_X86_DISABLE_EXITS_HLT)			     \
>+			(a).hlt_in_guest = true;			     \
>+		if ((mask) & KVM_X86_DISABLE_EXITS_PAUSE)		     \
>+			(a).pause_in_guest = true;			     \
>+		if ((mask) & KVM_X86_DISABLE_EXITS_CSTATE)		     \
>+			(a).cstate_in_guest = true;			     \
>+	}								     \
>+})
>+
> static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
> 				     struct kvm_enable_cap *cap)
> {
>@@ -6238,14 +6260,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> 		if (kvm->created_vcpus)
> 			goto disable_exits_unlock;
> 
>-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
>-			kvm->arch.mwait_in_guest = true;
>-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
>-			kvm->arch.hlt_in_guest = true;
>-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
>-			kvm->arch.pause_in_guest = true;
>-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
>-			kvm->arch.cstate_in_guest = true;
>+		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
>+
> 		r = 0;
> disable_exits_unlock:
> 		mutex_unlock(&kvm->lock);
>diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>index 55155e262646..876dcccbfff2 100644
>--- a/include/uapi/linux/kvm.h
>+++ b/include/uapi/linux/kvm.h
>@@ -823,10 +823,12 @@ struct kvm_ioeventfd {
> #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
>+#define KVM_X86_DISABLE_EXITS_OVERRIDE	     (1ull << 63)
> #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
>                                               KVM_X86_DISABLE_EXITS_HLT | \
>                                               KVM_X86_DISABLE_EXITS_PAUSE | \
>-                                              KVM_X86_DISABLE_EXITS_CSTATE)
>+					      KVM_X86_DISABLE_EXITS_CSTATE | \
>+					      KVM_X86_DISABLE_EXITS_OVERRIDE)
> 
> /* for KVM_ENABLE_CAP */
> struct kvm_enable_cap {
>-- 
>2.34.1
>
