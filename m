Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97A715B2B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 12:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjE3KN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 06:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjE3KNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 06:13:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A30FE;
        Tue, 30 May 2023 03:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685441605; x=1716977605;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=sGOaa5NIcPUweykvboKVN9QH9xK2skqZKEUhtdtmvGs=;
  b=aeaQeNNq4SVifBIWW/mAH/VhVRAZsNVdqV3kDV6sp6rrr4390DXqrj5x
   cCf7xMR7Wf9HvWJFaN/JZ8ND3AkyZnv0o6rWPV4GxPoF3IVwbMRNU8HAm
   65poNuEO2BI6bxOSgmb7l7erhp8tNWLCRnRmAH/N915PfjXvvY2eTKnaj
   WwVQAORMvJpps1x9/C24Iec2weXlu8PpvTfGyJMK0I7UitUAiaifew0DL
   hL6ouTY2aoOi6k1Gtzcf7WkRwsNTaghRDNmAIx4guqY63yRRCdjFv8k5p
   UtBgfCggdGwQEXGu3dUItTQOjUg8x+S4VaFD1OGs8GWVFrkU/8u69D9Zc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="352374037"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="352374037"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 03:13:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="656795060"
X-IronPort-AV: E=Sophos;i="6.00,203,1681196400"; 
   d="scan'208";a="656795060"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 30 May 2023 03:13:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 03:13:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 03:13:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 03:13:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 03:13:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlN4EhaBdoZXJ+SVpjxNMPH/W9KBKe5aCU/nrtxeuVT0IDLjJ8veibLYAC1pCOwAx7gQ5dDiWMoLllNbbJvLCFlVYUDEqDXqJ4tHczedDU5K8xqef2emnth76Z+p6LAgE0eD07DLvRdSgUPRfB4iel75PlcWILeriZglQTcNQ/WpIqtRGH95Csxem9Nqow+kxIfohauhM2NecyOSMGvlR1X8UoExXaV589EJbX/AZcyoU7BpVVmkMiX+gdGxs4RbK/Qd29nIU05iJRoeEcvwHgYiyh0ukX+90Xm3Et/hNM99QaJxm6lFihf1Ywvbfj+hvU1kv5WKzXqZI7L7JvnU4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oZvjb5XMRwAjJbQX05XuOywgdbUHikA2QZXc65lH+U=;
 b=eyQEHWcAlwLqQoprPNXl6Lq+M2MyQahbufVlb10t8+zR4lpuvVMLKwfVo5a2wH4ZDkjfyh+bzTN33AMgah/rf3eha8Glvcq6SSbtoaWu7C1qocyxV9Nri0mVoxnygdXxF4MWoUMDwhaKiHQ8xxEmIKLw24RBVJNnjJUXLSHs5R3pCvXlApMNvX2dlHXJKITPiHlsm7UkCsnGPYK8eWXyfDi8x/ohi2HKBPFc+gnxEkcJRWebaA3U5CNz9baepJBowVEiHqnm4JZmIOptDn8/V1QjLteKWAXV5vxrAinb9vfcROMcTBI+NPOQS//S65RYihFXPwLYbjUSxhfdIjgfrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7290.namprd11.prod.outlook.com (2603:10b6:930:9a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Tue, 30 May 2023 10:13:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af48:a141:6dd6:25e%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 10:13:20 +0000
Date:   Tue, 30 May 2023 17:48:10 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to
 indicate memtype changes
Message-ID: <ZHXGWsw3ARk2OOjX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email>
 <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com>
 <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
 <ZG4kMKXKnQuQOTa7@google.com>
 <ZG807ECX4TeBcE61@yzhao56-desk.sh.intel.com>
 <ZG+Epwp75nJ7tpXM@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG+Epwp75nJ7tpXM@google.com>
X-ClientProxiedBy: SG2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:3:17::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: 81761329-8ca2-4dc9-3184-08db60f67e1d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +YCcRu29kr3+qDty3A9Ij+HbGcnCkg2SqjxrdAxCE3D0s4Qx8XPiiXaY8365oaV67x1W1FOsytOVztmbwCXwMKHTwbj/CgLNIxyDn81B3tvAxDO8xnOP5wuJtiAg+HgxS3uYAkRJgGjXMJbg8FuDD63RboLtf0MgG/8hJPhy1haohKB3lgN6FfCqBZtUGjjs+oNFCm2CODkjLRWbMDZf7xzM0kvvA1LzT6eVWWQyOlwwkJZ/stZq8FjQAM4xWjiEWLwhGJU4lfrXFPlPY+DsszIy1pUHUYOrXMA0sZnazYkrPGh768Eg/jKPTN0R1cnZWjfhTwehAAVL5uWtFAwrSUFVRACnnpN/4W+HPkUql55+RLa08JOZRh6Dw/ck8VAfsdSWVU09KgAS1HuXaVaoMo6iNE0Mym+VayxDDJoS15EFgphSXxcVLSqrKkcjgMNpVLsHh66Rft6xozlb/vLGxPCvb5cHK8Q7Hma9sK5mZhkHAG/t2YENHiegU/Ii9ejDtanUpHt2QPv/woYu1acGLS6u5Vu6/I6lgZ3iCFyatTkeNkESZGE+nRDPD6uTgaXk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(186003)(38100700002)(41300700001)(83380400001)(6506007)(6512007)(26005)(6486002)(6666004)(478600001)(4326008)(66556008)(82960400001)(66946007)(66476007)(6916009)(316002)(5660300002)(8676002)(8936002)(2906002)(86362001)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACaO/5vHmrea3QZY2in2tFaeSJTNTHWQj5hXdvh9loXHfZaMjV1USeQ+SuWM?=
 =?us-ascii?Q?lNIGYqTXp82SZekhIMNME1o6XK8LIQ3vrBJAWwqfimiHGr91QWZn+s0yd66k?=
 =?us-ascii?Q?xSln4py+/B+DgsCFBv97QfGOTKbTWQWcW94hy27TNCbb8V1IyEquarEObzFx?=
 =?us-ascii?Q?9whtowBs2fDR8F9CAs/DB9Bl+dSXTa3Pnc6OonbY6SVItY2mO8uQrNinAmtc?=
 =?us-ascii?Q?9535zVc3jPjq35A+PdIfBVFIo6fuJqN9fQreHHUM4smyFWnQIIvz4tlX55h4?=
 =?us-ascii?Q?MZiXUXIz6tCjA3Bhw0UITx0q5mYXHJu2gGVt8VOvs9LTrXIUqDTrqpCeGZap?=
 =?us-ascii?Q?gzJj+/7rVzSTMIwtIB8/rfSXSuuyI1RPA7/TK4p3CjcAtLh0Fi1XlUfjuqOz?=
 =?us-ascii?Q?qza83TKHIeEwQ9Xt1gCvzpFBug1/bVitw8DgzX/NVit9LIoJASTbKybcZkED?=
 =?us-ascii?Q?97almq3pEGaG/MMdxBXiFwqLuNeH8eTkJbK+S0AWtjDu4MzKJsV6plwi+0X8?=
 =?us-ascii?Q?ot3P4kmjjG26oSDXowl3lEvu5mxXlPzuh0OgIud5liug0o7nwZM/vXfo84hl?=
 =?us-ascii?Q?WyPdCYAqW7PkR5NmqWiSb92Aksbr6VjjoCyx38/DicMUC6aK6Yu+ztefBnEx?=
 =?us-ascii?Q?OLxQWGhELf5PxfKelsaLEARfC2tVOhQVp6cLBOCnl8Qv4qB3EdilQogDhhqk?=
 =?us-ascii?Q?/v5NVB7t0G46+f2Q1ZSSNpI8OmIJn7OdpfHWByUesssv57tUFAfojV6iMZkp?=
 =?us-ascii?Q?Vtq6PLz+2w4170WWvtv6vzetafXdG3LzAVL40Q6hNegbx+J/kFDHXCEA1VjY?=
 =?us-ascii?Q?KhzRb8w9lJfxYMknz7jIy6PYNEYbafbTm4hCscVkBk5d3MLyANiOo6kN9CbP?=
 =?us-ascii?Q?x/qJ1jwHqFL6m+2TDp3JqrJyPN05Dw1VX3o/TT5LAcdOrRsIpsZEuJ9mIyJQ?=
 =?us-ascii?Q?JmaJKGp3J+osa2+3LvMg2IF5DoDcLI7QwGaAgPqEP0vdg+HervIhx57jXAHX?=
 =?us-ascii?Q?a3nXrtdQo3yMgh2UFkdVujjWNdyv3rT0nVFTC3Wuol1nBmZNxy6wSTs91ylI?=
 =?us-ascii?Q?PQf1SaHPB8JFtCKiFUJzFWGvpQNFZ+BvSVe917okc7QbpDOyHSIZ2II+YEK0?=
 =?us-ascii?Q?7zsg9iM6zdUO8KP4HPrwxuMYTEeFIV+a3kPq72euWKLp160YE6o/A/D7Nm1q?=
 =?us-ascii?Q?gJERAlESPeH1S0x2RaeqHQs3GXx+SBXOgYi+0HTYe2A27NUsBEpq4wwIfSy5?=
 =?us-ascii?Q?ZrV+yzyCJzyumRdLxDA7ls8ORQ08IFkVR7PQFoFpF25dd02CtV5uKvNqNQC2?=
 =?us-ascii?Q?b/XrDteyqjD8VVW5xz0K+DkvJiBhIVGmTt6QsmQ4XfCok7yVgZJ3FHrWPyj9?=
 =?us-ascii?Q?CYvRBCn7TMqHi32ADdO9MUeTwvZ5BAHWhkV4B4MPsKG7W6OjUXa9EiW3Rv3f?=
 =?us-ascii?Q?ZS1LBlA/p/FxtnZvjQ704zJGxmhUGoDjYN+NIs429ohsceDazJIsqf1khEE0?=
 =?us-ascii?Q?At+Yj/Twtoi2bPIgkypphAB2px9o9SKb7UVm1stwKrES+Ou4MKMLIORqMzp4?=
 =?us-ascii?Q?NWtyu/61g3eSYgqxPnnDertw90XBnT8tNOrUJrEX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81761329-8ca2-4dc9-3184-08db60f67e1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 10:13:19.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBTwJVfM0aBnTPn8ZLFQeKKrKtWqczT95p5ZFzZKKIAaGjTCtoTDl/bfDllrFOWV/WeLnmRjev3vbKC6oorbBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7290
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023 at 08:54:15AM -0700, Sean Christopherson wrote:
> > > static void kvm_noncoherent_dma_start_or_end(struct kvm *kvm)
> > What does start_or_end or first_or_last stand for? 
> 
> Start/End of device (un)assignment, or First/Last device (un)assigned.  Definitely
> feel free to pick a better name.
Hi Sean,
start_or_end gave me a first impression that it stands for gfn_start, gfn_end.
so currently I changed it to start/stop to avoid confusion.

+static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
+{
+       /*
+        * Only necessary to zap KVM TDP if guest MTRR is honored.
+        * As whether a VM has noncoherent DMA can affect whether
+        * KVM honors guest MTRR and the resulting memory type in TDP,
+        * specify its value as true here to test if guest MTRR
+        * is honored after the assignment starts or
+        * was honored before the assignment stops.
+        */
+       if (kvm_mmu_honors_guest_mtrrs(kvm, true))
+               kvm_zap_gfn_range(kvm, 0, ~0ULL);
+}

And I combined the __kvm_mmu_honors_guest_mtrrs() into
kvm_mmu_honors_guest_mtrrs(). Not sure if you like it :)

+/*
+ * Returns if KVM honors guest MTRRs
+ * @override_vm_has_noncoherent_dma: Allow caller to override non-coherent DMA
+ *                                   status returned from
+ *                                   kvm_arch_has_noncoherent_dma()
+ */
+bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm,
+                               bool override_vm_has_noncoherent_dma)
+{
+       bool noncoherent_dma = override_vm_has_noncoherent_dma ? true :
+                              kvm_arch_has_noncoherent_dma(kvm);
+
+       /*
+        * If the TDP is enabled, the host MTRRs are ignored by TDP
+        * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
+        * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
+        * from the guest's MTRRs so that guest accesses to memory that is
+        * DMA'd aren't cached against the guest's wishes.
+        *
+        * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
+        * e.g. KVM will force UC memtype for host MMIO.
+        */
+       return noncoherent_dma && tdp_enabled && shadow_memtype_mask;
+}
+

Thanks
Yan
