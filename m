Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A636E66B172
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjAOOUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 09:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjAOOUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 09:20:20 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A50EC4A;
        Sun, 15 Jan 2023 06:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673792419; x=1705328419;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dFM/sYepnLSHE/gJJsIY3Mj70XJe5hpzE+gVN0ZVR/k=;
  b=lTQfqL7in3KenyCxphuggbuAYQlppLZz666e4owxVqGT4d2Sqs7SBvW8
   C32A3335W93zz+XhihtiCkTSmPeP0lzym/tXTTvEj8o1xQU/2EAF/s57O
   ShQT10adrZJUpFGToqHO3edmITLij/CHnawdYVyf/guc8+NZtGrLvEVYJ
   WG7OAbY4/aAFaz00BdYs+vRg0X3WX71CeMP+770T4oiYhFn5Q8T5OtTZT
   3rO4fGjgh4yiCSMZ2UiM8MSNg2GtrqI4LW7o+lgStoEA/I04HgvWi65UE
   5BotpPKMXiU7goaedNd84HoCX2dHVUzRHO/wmppma86JRJMKDfLm68LSd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="312147181"
X-IronPort-AV: E=Sophos;i="5.97,218,1669104000"; 
   d="scan'208";a="312147181"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2023 06:20:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="832576328"
X-IronPort-AV: E=Sophos;i="5.97,218,1669104000"; 
   d="scan'208";a="832576328"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 15 Jan 2023 06:20:18 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 15 Jan 2023 06:20:17 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 15 Jan 2023 06:20:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 15 Jan 2023 06:20:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 15 Jan 2023 06:20:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7UAp0go8NiKc+SY6qfcyLXnL0+pdpvEoNMrJL6x7HWEPlZFdrCkZ2lrWVpReccWYxw+dTR+PjxEj2beZv9JGUaVOPkJYwF2Hh2UcBv4dOWzAp4un4MNAyWQMw4/+NilZnY5PWQ2G0B0upurFZc+Zk9/BNIgZkfYXyJrLQSyfwdJU76/PW5ETS1FlrvRI0bywfFidp5giBbpDXdBBHIF0EEM+C7yw4bs6MSLJfCCeGQeUS/UpMwv4vJLV3No+T5C/+iBXVBCW0gFSWlHxJy+bzZJXN3G2l1VT690iyejBgxNX+B4FKS+H5LztNZjS1dAQXLtWo3BGjUZv+orA4Yb0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88qrKkQ2j40Y4Cz0+hKzmk+TO3oBnJCcg9+jxxA/nSw=;
 b=TZ2AeHfaeF9nuzzCppOheeS7LZCF9LE0D+iVjTgMwUYspkc2U3jCm9vW2V1JUF741vf3X9SS8B8dPIraCbGpI0+ZFPqUqpCh73VsYQ1xLCw0KsVg26+OA0B7NbLYWRROiPIGMjWUKKoffiHCnRsDpkXct4EBaAQN0RxWV1oineZPNzbCEEhz1jfxyhkf5IN5bk0G2O8iFPLnF1wTVckDbPiGNPWtAIKeWYsK5/3tOE0eSS0u6GsIH80yQE3wSiTCwUHetAUhCL7XZbPCVls52SH4Xa0hxmvlkVqQ0yuH6mrgMuBO95gDShO+HuOj0FoKAxWfJkAA+5c/fUOZuECq+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM6PR11MB4548.namprd11.prod.outlook.com (2603:10b6:5:2ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sun, 15 Jan
 2023 14:20:14 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee%8]) with mapi id 15.20.5986.023; Sun, 15 Jan 2023
 14:20:14 +0000
Date:   Sun, 15 Jan 2023 22:20:23 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zhang Chen <chen.zhang@intel.com>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Borislav Petkov" <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 8/9] x86/kvm/vmx: Initialize SPEC_CTRL MASK for RRSBA
Message-ID: <Y8QLp33AgbDjMMh7@gao-cwp>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-9-chen.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221210160046.2608762-9-chen.zhang@intel.com>
X-ClientProxiedBy: SG2PR02CA0118.apcprd02.prod.outlook.com
 (2603:1096:4:92::34) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM6PR11MB4548:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d985ac1-561f-4387-658e-08daf7039e29
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebatkyfxc6lScd/s1iWxIFpRHZu7WQMPD+XTupv09yzeSkow2+p3iO9SnvFypGCRttxaJ6iKYtJGt7Sdo6COZ0+fta3oQC9dv2VFLFHkH2m4PJBm/RpsZWPwN23vKHL8yyyU9hUwlA3R/BbaQ7gr0b56rfVojQJE/LW6kMbQGPTNxUfwGMnEiCyco4arPtb5iJX+EpWYhlZvNzkdtS+Z6IRm3hD/DT02Rx7e7nY0zZ4cTi99KVSBPHic9KFZMpVCAN0K/IChdDL7SlPHmySWTvr40JR07W0mv9pmCJWjDPUdOXwRgTwvjkcLUkAybfZQ9nBl9quG9bvaClP4kAGJrN2Tp0/G5O7HABZihfIvtQqKjCBuzz8Jv+qXLm/pF1Nrq0iUzO7s2i2qjisPendFX2aj/mq8P1755XDL6e29eiJW+pnQr9h6Rt2xfyysMLOFo4cH0bWNHN3fieVH0t84amU2f/4TVtlVXdQXbss68GYYzwrp4rGBKNeMo89tDG51dwyGCZrGho838GNohVf9ywFdzruu/KfWlVhVQMoRGeJ9NhmEPiBqmsOP0yJy8vCus+Cme7MWYCGJPtn8jHAJSL3iPcqHNNdDfcsMAEf27lC4+MlWkdAMrPu0dKw5bVgez+6/TgWCEqhYTRPEufiOaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199015)(33716001)(6506007)(9686003)(26005)(6512007)(6666004)(186003)(6486002)(82960400001)(38100700002)(478600001)(86362001)(83380400001)(66899015)(44832011)(7416002)(8936002)(6862004)(5660300002)(66556008)(66946007)(2906002)(8676002)(66476007)(316002)(4326008)(54906003)(41300700001)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CFmhUzn5Xu+95NCspZWtgB9hgBfpi+lO3CkK8zYbma9Vb8eVOLJDW7XoNgmL?=
 =?us-ascii?Q?+/7LzU72kGtQCUee20w4VR3HuHwImfp5HdPiJgfWCb2z89eQS+6qsJ2Xy1b8?=
 =?us-ascii?Q?IjEBAz6xuNwQPnUEhleSdN2c8PaH7TdZy3oI+HVEOvy64Tthfg7M22Vrt1on?=
 =?us-ascii?Q?HCmPMi95KWZcrDIVMwnjCjOSFPcNRZO61cXiLmFKmVDR7nWgMSDtIerdetqd?=
 =?us-ascii?Q?WL08LTnoMuD2WbPsjjI1vTWvVq9Q0qsfsZ3nQpPY7V1mT7zFqj0/M0dQLpY7?=
 =?us-ascii?Q?uW4WYoGHAiQy4QED+HGj50ISPnmCPsiW9sz+/yscTZZ5wvDeoJ2t1LHr4eyT?=
 =?us-ascii?Q?PJl/A6x/1XqZ9i3GqXS9eUdS4vTco4v75WHZOItU+0jvEUvm3xLFNNUmdL11?=
 =?us-ascii?Q?RSk+mICXAxEIimgr34p9eC7Kv0v79OLG4+mwKWN6ik6RFrQevq/CFRQC9Cl1?=
 =?us-ascii?Q?thK/XrXvFPBgX1qeLVMTxlGcFu1oNfVYGvQLIltP6bLmVcDDEdpgDah29ga5?=
 =?us-ascii?Q?mr2wxamrSWzfyONrvg2aGtUOgE07mrGwTf1UGfcYhJSos3KQE1+IxppW9Rhk?=
 =?us-ascii?Q?AWiYRxr2PpLT0eijN2NaZWASlFCHPYM6DWQJPfkzXH+dKLvwjO+z2v/ojXsj?=
 =?us-ascii?Q?qEs2fvCqytVuBUcmuh5rs+yXPq9dlDasPWTwe+0s0CPDBDgWzHgMf56Q77ux?=
 =?us-ascii?Q?8EzP/8FjiWv202oHO7Vks9IlkoaR09k1c8gZih+z+P1iIxKfNjQ+AFlqp6wS?=
 =?us-ascii?Q?9eY2dKPDdXqCAHq1J48nLnSJ0VJjGNEeSm8H0t8ckZ54tPL0dBA8HngR4xpW?=
 =?us-ascii?Q?8NAQiySeYbqs53bCwsnoY06DKukEmOxmUGvmJ+I4Ldn0822jOOGYyFFLHuXX?=
 =?us-ascii?Q?cgXUW1ZY8HLlUjlF+sIrSf+/AIPg56udsToGZEkkm8duxPaUVQIfKAnUHw3B?=
 =?us-ascii?Q?mmNiw1UZIc4L/iiZsyvuIvCLh+J63Bnw+VaatD23cFucmkhoWs5W4oLdRr7D?=
 =?us-ascii?Q?+ZKb38LSyNvsjSicNw4HYbzPg8S7ypkKInbpHgmYHjuZMI0T/RmSljCm+Mr4?=
 =?us-ascii?Q?txTfcE5bes56pMxfH/sqMiEDtf0rlcdIjmjQGRGvYJIRAO5c7Gk5NkVGtf16?=
 =?us-ascii?Q?/MsiUbaI6BNpnMaprH7Aan3YXnrf+aEhJBsv/gMMF0Eta5TL0hcc98RjmNNr?=
 =?us-ascii?Q?IzRJCLjJ+cPdlTKXUzixfdJhFPnyJ48a4WCKlKLfT6dvOhobJ24uqi864f77?=
 =?us-ascii?Q?qrcaUTP4VL6wJ5EsAxi7wJPHqH2jHlQ2CoxgUE5zpZcQ29xRyaLnUO7Vs0j+?=
 =?us-ascii?Q?5LoXAh0Fi8RHFPHK3jOwaHJvkZd+VmT1u6e6Az/T+G/EWcPwvEpPN0JhOkoS?=
 =?us-ascii?Q?PEGpdLkV+w/hL1glahQvUwOfsrkeQ2e068am65eZkxS3EtS5fyGF2oLJbF8q?=
 =?us-ascii?Q?HfGiSOKjHX1hYsil2V4JahwmaqSK6eQJKzbVfhdXYkzxHnXkWIewY+S1mUA/?=
 =?us-ascii?Q?iP+NKuXcvCpNjESWqY8+AUvYz5oJxNfXPPJe6IjbZo6B8+LmiInMdwR3XXhU?=
 =?us-ascii?Q?LIPonMyidDjRMWLsHvEnhao5ZPr9X2WyY5y6jUJd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d985ac1-561f-4387-658e-08daf7039e29
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 14:20:13.9477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JllFhNlorvyX06ijUgNPy0pC2gLKH7BK80YBQWkdp31YvCIEU9TM5t/adPVzzSG8QDh8gTWERqmVzfMpstdwvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4548
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 11, 2022 at 12:00:45AM +0800, Zhang Chen wrote:
>VMMs can address mitigations issues in migration pool by applying
>the needed controls whenever the guest is operating on a newer
>processor. If a guest is using retpoline to mitigate intra-mode BTI
>in CPL0, the VMM can set RRSBA_DIS_S when the guest runs on hardware
>which enumerates RRSBA.
>
>Signed-off-by: Zhang Chen <chen.zhang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 57 +++++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 56 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 6ed6b743be0e..fb0f3b1639b9 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2007,6 +2007,20 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 			return 1;
> 		msr_info->data = vmx->msr_virtual_enumeration;
> 		break;
>+	case MSR_VIRTUAL_MITIGATION_ENUM:
>+		if (!msr_info->host_initiated &&
>+		    !(vmx->msr_virtual_enumeration &
>+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
>+			return 1;
>+		msr_info->data = vmx->msr_virtual_mitigation_enum;
>+		break;
>+	case MSR_VIRTUAL_MITIGATION_CTRL:
>+		if (!msr_info->host_initiated &&
>+		    !(vmx->msr_virtual_enumeration &
>+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
>+			return 1;
>+		msr_info->data = vmx->msr_virtual_mitigation_ctrl;
>+		break;
> 	default:
> 	find_uret_msr:
> 		msr = vmx_find_uret_msr(vmx, msr_info->index);
>@@ -2056,7 +2070,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 	struct vmx_uret_msr *msr;
> 	int ret = 0;
> 	u32 msr_index = msr_info->index;
>-	u64 data = msr_info->data;
>+	u64 data = msr_info->data, arch_msr;
> 	u32 index;
> 
> 	switch (msr_index) {
>@@ -2390,6 +2404,46 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		vmx->msr_virtual_enumeration = data &
> 						VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
> 		break;
>+	case MSR_VIRTUAL_MITIGATION_ENUM:
>+		if (msr_info->host_initiated &&
>+		    !(vmx->msr_virtual_enumeration &
>+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
>+			return 1;
>+		if (data & ~MITI_ENUM_SUPPORTED)
>+			return 1;
>+		vmx->msr_virtual_mitigation_enum = data;
>+		break;
>+	case MSR_VIRTUAL_MITIGATION_CTRL:
>+		if (!msr_info->host_initiated &&
>+		    !(vmx->msr_virtual_enumeration &
>+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
>+			return 1;
>+		if (data & ~MITI_CTRL_USED)
>+			return 1;
>+


>+		if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>+			rdmsrl(MSR_IA32_ARCH_CAPABILITIES, arch_msr);
>+
>+		if (data & MITI_CTRL_RETPOLINE_S_USED &&
>+		    boot_cpu_has(X86_FEATURE_RRSBA_CTRL) &&
>+		    arch_msr & ARCH_CAP_RRSBA)
>+			vmx->spec_ctrl_mask |= SPEC_CTRL_RRSBA_DIS_S;
>+		else
>+			vmx->spec_ctrl_mask &= ~SPEC_CTRL_RRSBA_DIS_S;

IIUC, only above chunk belongs to this patch. Other changes should be moved
to patch 7, which deals with MSRs emulation.
