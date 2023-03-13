Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F986B711E
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 09:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjCMI0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 04:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCMI0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 04:26:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD52131E25;
        Mon, 13 Mar 2023 01:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678695995; x=1710231995;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OauyA6OgtywmxWEy/gkShGZgmpNZpVxfVg5d/ahaYE8=;
  b=GLXOHHj6AJqaf67lSVEb6g/+o6nf0Y9jTjulBbzt0Zc7yVybgHNJaODk
   0n0F8Q5nio3QlUGuZ/GvlVvSenCFXJI0QL7Ac59BotPr0Msd3acCA84Bg
   f91GUQr7LtU8xezIOMymIn9oHWgSLXpKIazKnuMK2DrRdhAJZFW5/uZs+
   XTEyjT+x55iwRR6W3sBT81NBKcOiSkfc8YbleM1KUmDMVN5+1oeR0etVB
   73KXkHmq6yAfLoGY/UX9JW8UA2eszD8yVnx3D/V0tR+H92Au/YDMQbej/
   i7fK9k4KGuxhaKzOTPfHK/PtJKGMPYa0U90AvCEP+5gIAhWdM5bazl0Rv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337112821"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="337112821"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 01:26:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="680942310"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="680942310"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2023 01:26:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 01:26:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 01:26:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 01:26:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 01:26:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Obflagf3V4aLNxRWZ59imdwowAWx2oHoTleI4Vb6NXOzeOBysl+rYjrZg8QWG9G8/n6MV7obaXihBnMW2aIc0xTncqLiG2V2UMx2jpVgZWakm3OI6oZuCfxdks+Nuhza6ZcsDUXThaVCIBJRFH3tS5zFRfZQBSajEidmNw+e93Oldqx0VZh+gyRBhndL+r4jyLsXaeLEoA9NelPBu8eBI+dGHZ8IROdtZD4mbDvoXo/AJdv7CNSlz5wBKg2tNEcf4cq8+CRp94U9wkuqSMCcITD/3NDUpvGUE377j+ncpsyzEb2R2f/7IAQmAdpEQE3l03+/OKXeUFF207P4wKEKMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kI5bcABtk3lCE5O1j7OWlIujpNHAah4/TKB11XxWjqg=;
 b=adNiSxwo+1wHuyMMqRRFJ0S12aGdXZcNhWoMY6iUpG82/kTK6CCSsrGSShLAztfgJ59IVrUoCmUTMQpdzCUQL4CgAvlLuWFLuEof0lHNomynTUci9zpdO7sNtbdSTYzebBpb0/kKRDQvkxid8Vp2Y4cFJOrUtGneuaE1r4U+YmiDyTtAu1F6td87yoJxkwiojRwiW2EWbPaT/T9oc+zweZ6VHY0t/QG8Gv3i8sNrwYaolq11LTytYj5mmE1FXvRqNbK+vgdyOTm4GwkWArzNx9UJduYVuniD3/98g6tcLEO+TKtYWmvWUpjL7XsxASutlC6J1nENtJi4mlCjwyARUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 08:26:30 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 08:26:30 +0000
Date:   Mon, 13 Mar 2023 16:26:54 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 03/18] x86/reboot: Harden virtualization hooks for
 emergency reboot
Message-ID: <ZA7eTpG5tpo5yIo3@gao-cwp>
References: <20230310214232.806108-1-seanjc@google.com>
 <20230310214232.806108-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230310214232.806108-4-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:3:17::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SN7PR11MB7420:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c89a0c-f774-4f9a-5168-08db239ca58a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: idD7naYyeAD219UobyTJzzi8g+3NbnXcjUsR3AtItThCpeXd1hhPZghQ8SNZDw37N/zSEncTePt6ca2WTO0WthbiI3WwyMxQFueQ65+5ThnbP69jkv8J7TgXzWVfZ6tV/eWIVYofWs/bG9PaMO2sMqLwfyxaFeOXOX4WmzL1Az4p+DRDEkSvBqAHleQn+kCQqI3yOh2HXGMQpUMG9XVJaByL46nRSv6lgjund3rKnFREthjcm+c1AgouSnRD77h2clrNEFbFjpKdCsJpqKRUnTYjXTwO0Lja1k+DsUC/n85ZBNaU6gqR+hJ2wG5DfDlYo45LW1SPnDtGGWszBubEla+3aBOH1Bru4Amaohxg2oWhezv3fRQYvz8BOsGFnG2XUb01RdgPQnlqSvLUfn+H0jsaxByTgulc4e+z02PvIsmBxWrM66IMUTjFNOsLMppOemOPBh2hs4gw1CuFkV0p113F1dHy7wtsvuXEqyb/HC8XB1N9vsdsIes2E+3qIRXIJ7G9QYuxiHBEfm7+kkLU3K+x9zUNA6oZyOsObwmy2Vp4Rv/x7s7Cbuo2Zno3HW3leBSbbHFny4fYo4xR23lPMTSu+jhMoYb2H5KVu1nCEBsvDG5qxGzHmk9X1/4Y7F3O43uyZAD6FO8OaM2ILLd0pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199018)(54906003)(41300700001)(478600001)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(6916009)(33716001)(86362001)(38100700002)(82960400001)(6512007)(26005)(6486002)(6666004)(9686003)(186003)(7416002)(5660300002)(44832011)(2906002)(316002)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PvDoX0lB8s1sH8LX5Pb3jR4wBMm0Q6JfQlxmnJF7BfLNAd9+80nSt2REJoMU?=
 =?us-ascii?Q?ltN/9GfhwiSRhRQWmpX7O55Mk2uCYAcSt9SF4IsilAW3Gef1ETRnL+lEDH9i?=
 =?us-ascii?Q?ike61s4mnGkM+y8rJ4uPT0+riwOzTHE/2/E/DneNqd1pm3sS5JG8ED/vYFNV?=
 =?us-ascii?Q?n6wui8A9kWP4D516vzMc6QJZD3iGmpaJ1KGjm/E0euHyj+TGMp6NSLpn79JI?=
 =?us-ascii?Q?4aB89izlEOXV9B7wsrhz1i2WMx6ajTgICHJAjVPetyzTHM+67+36GUX2Y61d?=
 =?us-ascii?Q?P+KefeWP+aHwqWBIbNH1Y9QhNXG9IGuALZPHRl3qBAquTozjn2Qf/G71j4Qq?=
 =?us-ascii?Q?Z4Ja+WvXbHOszveo9H1w6MrDjk2w89SS+c0Jm+1WRAWAE7VBj5bqRnde6OQN?=
 =?us-ascii?Q?DH7BEebuSrOBdNwuCQytl7kTD/uhu7XdX7UnOVldYTJv3DT9tG3AiPvouMx/?=
 =?us-ascii?Q?a1mYIqn37qRO02xzNX7MkLqb/LwbcNaUObnT+nJcxIU+hsE5quvuZ0OratFa?=
 =?us-ascii?Q?EZnW+EOLvdLal34NtUePLsdDxOfFVQhYdZFtxA8EvH3xxVggqZQqFJPQfGzw?=
 =?us-ascii?Q?KR5uAmPRm6RUoZvtSrVXSqA0feb+J2+T1MYQTgAxlKzfFIlsJjCvMlfn9zUX?=
 =?us-ascii?Q?SF/QHnJ8hXENmMRBwl69Fm6i4uiXgzJUOyLBx7hQpnCfDGSKEwEGo4LFUOTp?=
 =?us-ascii?Q?O7cmgUcHIVjwwjtSxnyCCeE9239czjcVTI8oIe5G3wdAOm25B7y5ezxBK53V?=
 =?us-ascii?Q?SGrSZFfJkIRquOpuFLFxr1ERi6RBUpc+0KnTba3vVrrWW36uSi3PB6W5ZoM8?=
 =?us-ascii?Q?99CS4WdT8Bd25r/ZDHRZ/rJLNKD+TLOphYWWoknxmw93MKg1/QLz2yWToJ8S?=
 =?us-ascii?Q?6AD0Geg28X+dcA14tlWHTE42DLQ5rgKyGRJObHLJxlqd8OFnjvHETlakwWgC?=
 =?us-ascii?Q?M9ETjF2c/Mlvk3f0dwqjdvgHRtZl9zhfxCFPgER44lUG68EL9GaCCE3xHrXh?=
 =?us-ascii?Q?xqNYOvAydargILAuYDg5z7nME1dS+kxOKApRI7P8aClll9ApY6zqGqVEp6UQ?=
 =?us-ascii?Q?s14OM73HFJfViaO4NpcyZFmuK0mhyAaxOwT0rEl6jP0wxuD5zJJtNIcNVXTX?=
 =?us-ascii?Q?0lAZ8lMEk5n2LueLpsIXvPhuG/BekngyWRzaEbP9C/49WBF20mxzZbYv2BlZ?=
 =?us-ascii?Q?/52am+w+RO1Eja6pBYSIu8ynu5m6zl9vGUnsQpVpwGGmwVIdhVWaWBocpc4c?=
 =?us-ascii?Q?YO5cl4khXwhVD7XNJupMjOOQDttG1osga43QcZkYi4jFgf8v/WvViP32W3j8?=
 =?us-ascii?Q?65jsHqSTJyNXKJSpju4gWY+kxAHPe/GfKQx+BQ8MRw4DKc8Q5QL0cYLbDcdu?=
 =?us-ascii?Q?RrpAiMo3abVnSomVYvQaQiCT3geAaW/o6ipHJlrGckjnqR22XDS4L9Jt9AAb?=
 =?us-ascii?Q?eoEeFElLUB3MGwV9sS2bHYFCtaTaffhC6lmEHe5Zmx23BcsWlrHkIBaGD0LM?=
 =?us-ascii?Q?+itinhSk86D9BpQ8bf14WuPiRw0/ileD+pJxXMczd7cNv1nxv+kc/DAJrT2v?=
 =?us-ascii?Q?f63mdU/vWb5M7WMee8zoKMenGEQvOHxvbOvJLoIc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c89a0c-f774-4f9a-5168-08db239ca58a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 08:26:30.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ps40XnSN1BQNdxzsUeYyQ1CBxjmupJj8HtIGhusthHjtvTGM+GXVGN+McP4a8Mxd94B/Jd9Ml+yEBiH3DqJstg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7420
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 01:42:17PM -0800, Sean Christopherson wrote:
>+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
>+{
>+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
>+		return;
>+
>+	rcu_assign_pointer(cpu_emergency_virt_callback, callback);

Was it intentional to not call synchronize_rcu() (in the original
code), different from the un-registration path?

>+}
>+EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
>+
>+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
>+{
>+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
>+		return;
>+
>+	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
>+	synchronize_rcu();
>+}
>+EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
> 
> static inline void cpu_crash_vmclear_loaded_vmcss(void)
> {
>-	crash_vmclear_fn *do_vmclear_operation = NULL;
>+	cpu_emergency_virt_cb *callback;
> 
> 	rcu_read_lock();
>-	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
>-	if (do_vmclear_operation)
>-		do_vmclear_operation();
>+	callback = rcu_dereference(cpu_emergency_virt_callback);
>+	if (callback)
>+		callback();
> 	rcu_read_unlock();
> }
> #endif
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 302086255be6..41095fc864f3 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8551,8 +8551,7 @@ static void __vmx_exit(void)
> {
> 	allow_smaller_maxphyaddr = false;
> 
>-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
>-	synchronize_rcu();
>+	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
> 
> 	vmx_cleanup_l1d_flush();
> }
>@@ -8602,8 +8601,7 @@ static int __init vmx_init(void)
> 		pi_init_cpu(cpu);
> 	}
> 
>-	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
>-			   crash_vmclear_local_loaded_vmcss);
>+	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
> 
> 	vmx_check_vmcs12_offsets();
> 
>-- 
>2.40.0.rc1.284.g88254d51c5-goog
>
