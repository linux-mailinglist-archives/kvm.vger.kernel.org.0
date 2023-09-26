Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AF67AE528
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 07:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjIZFl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 01:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjIZFlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 01:41:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37D2D7;
        Mon, 25 Sep 2023 22:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695706878; x=1727242878;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=d1VXmGi2AuCJ5LnC0dQ65tOy57GB/ofjtmIpXoDErTA=;
  b=jBo/SjAWV1EhtIK8GzQ1qlOLIOuYufift24UyhN1/TyfOuTgw+cqy1pB
   JkBjvjm7QgJDMuZ/ID1xzkhyJu9AvJhqICFX4Ss8FB4HI6MbQi9iCqRU3
   esXG3NuDsD80SPCcsr8U/2jRP3lu8kRzfH2q2Vg/IR/U+3m7RGKhZ8g2q
   K9TVrDAWkMUUOg9syOXg1MXd62m98wmHSQcJZ2zFmrvcpsrpDcHpGkMkR
   4DnEtaoQeDumO4ARjzNh65Ozd+dlc7EJFmLiUwCtwizft2ENW8hXjOWEr
   kCoxgnPBYpCBKwoHe9xxOELhYH5xK72lCP0nhRXuufVo+tmjNINY9R88U
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="445622657"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="445622657"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 22:41:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="872371705"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="872371705"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 22:41:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 22:41:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 22:41:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 22:41:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 22:41:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXoW5w00KkfWUhec5rCzJCUjiA5wIr7oGHbfi85r3jCoIL6vpnYFNYFQLaww9qfSfrsBRCJb0+WkO2rOmN+BclGpox9GnDqivdAhkLwrkGkOMzp5J3RzXuyTxZe7AlURwU7hv9SWIx48FrteMcuhtkYA5YGt6r0S4Nqa7NOywde1TaB04x/DCeEfCiDEvk4dxKrtGKzGNELkdipxXU5nMvytv943oi2mU2Hc6w7HS6BDR0ezLo3F1GgH6i1PQzO3VVcPvGMtpjmKvz5WjwqB9JszXYPz/yie4DDVx1dwH2hq8G+F71+iUT1JFP2iG39sKK8L57yBerHniCRdDqZ4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7j7IZ3Z1kJEzD1EcYgmJso2uUYcMvCfVX5OfKqsYTcU=;
 b=avCsYBVOdBFr8V8nkNcm1YWx8kDaBE2uHcbx0RDUdBPx+PLxlnvp64n1bZg1zQE26Xn6xYPVu63qU8XHvbkOVanXT63UpyCgsmQv3LfZTQR8QEgEyUgBKSxeo7W/aX4KQvghh5vPaKcwAFptcG2CobHIzmGwRQgCyqOkLmXzdPm1HaZFFQaJYMj+e92mxfsEzf0+WjRGbpEHPfttSV9tU4huGvfIJ/Hw6EV5wRvwV5FM5jvGxdqnVw3mZtoSeSmOV6HhzAn2mJKKqW5l2wtHG00JvBwlm6HFLMjd+UtURzQoH/mt+T6bowWGoe8gi2b7NyWRsekuzfWD58uNVDjizw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by BN9PR11MB5497.namprd11.prod.outlook.com (2603:10b6:408:102::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Tue, 26 Sep
 2023 05:41:14 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::d35:d16b:4ee3:77e5]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::d35:d16b:4ee3:77e5%7]) with mapi id 15.20.6792.026; Tue, 26 Sep 2023
 05:41:14 +0000
Date:   Tue, 26 Sep 2023 13:36:10 +0800
From:   kernel test robot <yujie.liu@intel.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>
CC:     <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
        <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 4/4] vfio/nvgpu: register device memory for poison
 handling
Message-ID: <202309252319.hQ7rHJTJ-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230920140210.12663-5-ankita@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0101.apcprd02.prod.outlook.com
 (2603:1096:4:92::17) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|BN9PR11MB5497:EE_
X-MS-Office365-Filtering-Correlation-Id: 82fb46d3-3361-437f-a093-08dbbe533248
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k8SjMCauLpu9yJCQhP01ZGKvBYesEZ5LigqN0ljq14RzATvQJdo1JVexiYp+7D+BxcrcNUa7Wk96/YkSwhBBR9t7jK4PccRhn7b9jJB1tHYU4iktjiX9CS0mztyGlPgUG/ebKgt89WDJftT1ax2QzfmdZGuNyRRbUAADJx2HPHfcnE/WOgZBkKNvwu0qi+yBUChlT4BYz2qMND21v5mG7q3iYmJUrtv0/FnLGDQX0S56UgRvwZc+J99AXd07VygOEGTnQXpQeb7FhwcJKbUd/FhY47t0P1GLslV41XI9zLxobZrUdZGViREcNY0GMWJ1pD+eKPJWX6HWwVHy5nTZ63Loh86lxQ03xYbEqMJYDgP7yAeNMtJdCq96L07oNt1dGVLfzMMkUOmhe89jxtLRTRZivFjYUqw6icJj/q/cwLQ60ZqRUe4TF6HdTbXToruIDyb58NMbMQ+44M+F+28Bu2rxQ/X1z8qZ1SgQ3q9DhJCn13S3bN8L0peK7CBCNHnyI5y5Onv2Wm0XymtMIkpN9XruZsp9VLNQ/nyUcms02cTGcsjkvx1D1UW1Io4wgE3bgxMipysZnPWT0pRvk10JcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(346002)(396003)(366004)(230922051799003)(451199024)(1800799009)(186009)(2616005)(5660300002)(4326008)(8676002)(8936002)(26005)(1076003)(7416002)(82960400001)(38100700002)(36756003)(86362001)(2906002)(83380400001)(6512007)(478600001)(966005)(6486002)(6506007)(6666004)(316002)(66946007)(66556008)(66476007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vvm5/lGMAtv4j4LxR1x0R2fLvaiDYqC4DeTCZQQZY73ros8OLvQ4gjSFKaLI?=
 =?us-ascii?Q?uIl9xzJS4xISdSAlfNk2FPP9AY6fvO+QjMAYD90GxEdEXHsAncdiUyhnLNZf?=
 =?us-ascii?Q?yzaFjFLd+wBEcsjAbVzmN+FcuiQpoIhwOwR1TbOANOhvjvDHZ3NtdgOUjVZX?=
 =?us-ascii?Q?83FDsD55Neyb6tLdb+F8boNBEbYVU3N4PGMyJ6WBIrZStG4Ws90KksBGbUaQ?=
 =?us-ascii?Q?/JmYzwwGzqVViTliLWrLP5D+71/kpfW7VpGNQmCL2qPfXU7wfQhh1P9bv/N0?=
 =?us-ascii?Q?smtmELyZFJjotP1bO+UylR57xHQhaqg+jkLYaq1lWEaAsSJTwJrGwgMr4ILp?=
 =?us-ascii?Q?Zgbjj3wB9reqbiCYQHq3Llgn3l/YbLEjR8b1p1duqDioDb0ONgG/7OfFjRg/?=
 =?us-ascii?Q?EBjNZh3iM8RZzOIJbPxntBGNbYQxTq4PG+0ju0dciwHHwU3w/TfFYh7s0qDE?=
 =?us-ascii?Q?v88+xknxHlqcjTnklCYAGHexsrXb/ZsqDLfHrjAYN2+VRcCeyWPRAhJS6itn?=
 =?us-ascii?Q?wIMXMBrdCMKaBImVg3UZ36rPicxx53D1GKR0HdOrBWdO/BVcbTlDo2z8VTyo?=
 =?us-ascii?Q?H+E64msRMY4bfIZ1Q7PRo4Agmo+cSyZV8+CU6GlmOwjbwuF9YZfZyzWjO6vr?=
 =?us-ascii?Q?ADYRbGA8D94AfO+ot1F1F/2ftu6weX/PeehAR22VEYxwPxkbPnq1+4T5iokI?=
 =?us-ascii?Q?W3fDdx77gTVd6EWaLFZ0ah6uiSRXadss7uIHW5LSITABpphX5piSbHdxfJK7?=
 =?us-ascii?Q?2DWe2Z9ZFnLUOW83OkLzfBHmjE1KhFjLKYc0dl5bXhBJc+LZEd8jNxWHj7h2?=
 =?us-ascii?Q?dOlBm2kFjFWiFjvA7dSR8rxHW88jbC1lZbA9h1YFSTRoVZ3Q6zpsTBfCALDe?=
 =?us-ascii?Q?4Bv+UvSySMKpWEkylvj9zARaU3PQIublbaDxw89ya/Dqahbr1tUPvJp4MVj0?=
 =?us-ascii?Q?qUKtHM2SM/2ZagRiHVNdfJWH5doRhHS6Kjrj0kGR9VqQ30mjMS5uF17eLYu+?=
 =?us-ascii?Q?DMmRsTYj2cfGjvX1iJj+qiQctDk58xgbKabaO+WXvjnOlFkHFvhhDOKE2FYu?=
 =?us-ascii?Q?ppGFDB7B1/vnajP+IoOvTua3lboNid1hNexdUniPwisB0+koVy1EUSpaa0Vb?=
 =?us-ascii?Q?moCRQGZJ1VObe8Ypaj2uIIcmPmSmO4ftue07UjR6ZUo7YzEZlYlwzmzENJKz?=
 =?us-ascii?Q?DXOu0jROrBdDmKtsTWQBg+LXLc0+E0bHkrxqin3KsRJSTiHfV1DLV++lL0R+?=
 =?us-ascii?Q?D1Nws6q41ScJDaiWxqTjpf/hyeZa4U4yaqIVF1ZGOpkdXhwhSnZ1wiGkVvce?=
 =?us-ascii?Q?hsFtmVHemgA/2vcw1HSRRt+2JYRKvBkUY+f9ynh7/Q488ER0Cm/FLM1AtGIg?=
 =?us-ascii?Q?DJTOZipF5i67RqqXrfZKyvcmi94OzUAnKxR5iRB7tTo1myVZ74FzqW1cRPom?=
 =?us-ascii?Q?6YoE0PhUOlCA0Pn23g8PQ7x/Gl5dLfJ8jLIo19fffD53PSs8qiEv+LiMx6Ei?=
 =?us-ascii?Q?6dmaiUipCiL2cB0xoXMJ5gtw/bD5CKHHtV0nOEFbl2r/vSHt+OoePiBXlEzV?=
 =?us-ascii?Q?u2FZh+F+ekxcyScgTaDQG066N00npRTX6lFEoSNR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fb46d3-3361-437f-a093-08dbbe533248
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 05:41:14.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wh6RTa8zVE8+7FHUqa3PJxgcbo58yLzI6yje80W6kYOvIN9KpZNLlUDX0Xo69judVKEGHxMo5I3RKAiajeo7Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5497
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on kvm/queue rafael-pm/linux-next linus/master]
[cannot apply to akpm-mm/mm-everything awilliam-vfio/next kvm/linux-next next-20230925]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ankita-nvidia-com/mm-handle-poisoning-of-pfn-without-struct-pages/20230920-220626
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230920140210.12663-5-ankita%40nvidia.com
patch subject: [PATCH v1 4/4] vfio/nvgpu: register device memory for poison handling
config: powerpc64-allmodconfig (https://download.01.org/0day-ci/archive/20230925/202309252319.hQ7rHJTJ-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230925/202309252319.hQ7rHJTJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202309252319.hQ7rHJTJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/nvgrace-gpu/main.c:27:6: warning: no previous prototype for function 'nvgrace_gpu_vfio_pci_pfn_memory_failure' [-Wmissing-prototypes]
      27 | void nvgrace_gpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
         |      ^
   drivers/vfio/pci/nvgrace-gpu/main.c:27:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      27 | void nvgrace_gpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
         | ^
         | static 
   drivers/vfio/pci/nvgrace-gpu/main.c:300:9: warning: no previous prototype for function 'nvgrace_gpu_read_mem' [-Wmissing-prototypes]
     300 | ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
         |         ^
   drivers/vfio/pci/nvgrace-gpu/main.c:300:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     300 | ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
         | ^
         | static 
   drivers/vfio/pci/nvgrace-gpu/main.c:376:9: warning: no previous prototype for function 'nvgrace_gpu_write_mem' [-Wmissing-prototypes]
     376 | ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
         |         ^
   drivers/vfio/pci/nvgrace-gpu/main.c:376:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     376 | ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
         | ^
         | static 
   3 warnings generated.


vim +/nvgrace_gpu_vfio_pci_pfn_memory_failure +27 drivers/vfio/pci/nvgrace-gpu/main.c

b59e9d949a79e1 Ankit Agrawal 2023-09-14  25  
5f3746d8629350 Ankit Agrawal 2023-09-20  26  #ifdef CONFIG_MEMORY_FAILURE
5f3746d8629350 Ankit Agrawal 2023-09-20 @27  void nvgrace_gpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
5f3746d8629350 Ankit Agrawal 2023-09-20  28  		unsigned long pfn)
5f3746d8629350 Ankit Agrawal 2023-09-20  29  {
5f3746d8629350 Ankit Agrawal 2023-09-20  30  	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
5f3746d8629350 Ankit Agrawal 2023-09-20  31  		pfn_space, struct nvgrace_gpu_vfio_pci_core_device, pfn_address_space);
5f3746d8629350 Ankit Agrawal 2023-09-20  32  	unsigned long mem_offset = pfn - pfn_space->node.start;
5f3746d8629350 Ankit Agrawal 2023-09-20  33  
5f3746d8629350 Ankit Agrawal 2023-09-20  34  	if (mem_offset >= nvdev->memlength)
5f3746d8629350 Ankit Agrawal 2023-09-20  35  		return;
5f3746d8629350 Ankit Agrawal 2023-09-20  36  
5f3746d8629350 Ankit Agrawal 2023-09-20  37  	/*
5f3746d8629350 Ankit Agrawal 2023-09-20  38  	 * MM has called to notify a poisoned page. Track that in the bitmap.
5f3746d8629350 Ankit Agrawal 2023-09-20  39  	 */
5f3746d8629350 Ankit Agrawal 2023-09-20  40  	__set_bit(mem_offset, nvdev->pfn_bitmap);
5f3746d8629350 Ankit Agrawal 2023-09-20  41  }
5f3746d8629350 Ankit Agrawal 2023-09-20  42  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

