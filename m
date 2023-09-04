Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4F79123B
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 09:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349102AbjIDHbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 03:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238624AbjIDHbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 03:31:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B28189;
        Mon,  4 Sep 2023 00:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693812700; x=1725348700;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=z4qZkGetAxjNG3TiCOl9hQdpGFUmxKBHz5gDZIw6zP4=;
  b=T8hFaZWkNTlwJ5/nSs/TrovGQuy7hl2fYojlqvcC2bDARHN3aKr/n0vU
   f+7kjsgarwJHJ7XxLd7urrqgoE+v3sGdHcECSfA8u8BIEV8c2Jd6B/Hin
   hddGDVkGZrW5ps6WqA8tKwspP1PTSnCHgN5hmq4jDibS+cJZJy4s7FQG1
   CPknaOv/PDYrGW9SbW34KFbP+UN0F3d1ns0ZYzjZ6RdxJ3ouOS/QBKTga
   MRG/TtsQfhRXcrmWtC5dI623muYvUy93XUe7iAugV+JpAzLE1LOp+lW/d
   x5fkAopMm0L1F2/L/swHEPItH02VUJKG3nbkWgThwXmTdKIp26cqPJGf8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="356854484"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="356854484"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 00:31:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="810818249"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="810818249"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 00:31:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 00:31:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 00:31:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 00:31:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 00:31:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKvkcm0I/Qe9hVZQ/Vl483zoUcihrGbFgOpGe9BpdT5qcFz2jTzAZjnTavviySL9mIuBb6aDPLDQC/j0wb+n9lw0hFEsRKECYtBa7xHNRiSY/cni9yvrrlWJsUCuKBz3cN5mWFQznoeLUSDFEaag1sonB5XZ5IphYuWqWIoyCbhZznz3Q3uM4TAep7BybHpjGQ7On96jTkUnaN6MgG6MB2PwYI3K9AhQjx6PDeFSa9KX965xJ59kP07NtC6EngoDRosG/n8wx1UxS+nyUaJWhpY8+8kNfe+8x8IuUEPqlkIxQw1805Qk6xcphNYr+YCPlC3oH/6lhKydkL1IqGn7Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4qZkGetAxjNG3TiCOl9hQdpGFUmxKBHz5gDZIw6zP4=;
 b=Ez606uObsTsxVfsIHWAqEmiMiYHOqBOHrn9Z2hadfAPf/kPM6G/C6NmOGDKmKv2mMyR3T0WBjSUcH53RTaH+wfAqULWzka1xJf7wgfZVLubX0aYf0/rvXzvCUdk3koL7RliGWVs3K7nNe0Bb5fG3FwMmlw/OrZiM2r1z77yjBbayI9dbwWFx3hIsCNG8Lup590EQUo4m1h2L04OzPfog5Km3YsFMxgd2OdJmaK2+qt4O4YwZX+v+GVsZbFwMGuhbQZUAUelR9HqFOoBiPjFG/aZHHZEF/FObpUoCUnkr464ynEJcsBITo8sKVa2XP9OuSqiGcnmtut/Oy1FtrlYoZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6073.namprd11.prod.outlook.com (2603:10b6:208:3d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 07:31:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 07:31:29 +0000
Date:   Mon, 4 Sep 2023 15:03:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     liulongfang <liulongfang@huawei.com>
CC:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZPWBVxs77rtDWfvx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <a14ced20-9d4b-cc76-dcba-c14164e84aa1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a14ced20-9d4b-cc76-dcba-c14164e84aa1@huawei.com>
X-ClientProxiedBy: KL1PR0401CA0027.apcprd04.prod.outlook.com
 (2603:1096:820:e::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 831a7b89-40ad-46c1-d5e7-08dbad18f44f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yizzzEBhSDodb50nTgRO2ZItsFpiy3mp/LnatUKSBIbw+PsS88MzmG3qojK2bL7jrXahQE10rhcOcKrwf7efAX4bpVF6/mU55kVNBYI6sNQYriCGCFldHdg9NtNmEsoOM7YTWfmxmbywsA/Q5WABm16HrH0b+zC2hHpmeJoMW3Rfx8/EA/sKHhRR8PWPRVWogLvgA4ojiz9/IpNHII1Ks/zDrUdzNOoiyU5G4faz3i8TR9YNH572RAWnRx+85jub2BNr6yjKUFYLtggPUbeg/BCZXG0b8JTHxLP1lXSP+m1D3rdNxL5JtbnUPCBpyCMAjnweE25lm6nliKFkNykEUlRGobBzJ1TCkGDPmGL+Fw82NWWyT4TCZB7xgrpumFcilK9SVLvMz/nmJxzV0i4zCsrfBFIAK60an9Fglzbk/+sXkepbcTG4zH9qeMyY5r38JoakSheEexsJLrsWgQAWOgF7vNkA7mzriCkjKOm2Szszhr20l9DsLyCo8U6CztHttLiEr57YmsMtY0DGD21CYQAB4gJ764pIAbI/fQofxUbYiDc5sRbfugs72SGAHHgj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(376002)(136003)(186009)(1800799009)(451199024)(6506007)(41300700001)(6512007)(7416002)(4744005)(2906002)(86362001)(38100700002)(316002)(6916009)(54906003)(478600001)(82960400001)(66476007)(66556008)(66946007)(6486002)(6666004)(3450700001)(8676002)(4326008)(8936002)(26005)(5660300002)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ATiJmMW3gAzmKWcyT8F1NFTQd9nJLdVepFVAbdW4Wa+vbFTI5yJlhhmaWhwl?=
 =?us-ascii?Q?4b7vnXkHJ7EPkDEb3qqAKjh54kNYJ+mAfgh453JzgLXwXigR3yJmE80LwsBX?=
 =?us-ascii?Q?mNV4mLdPPxLHBGoZNTsSoPP6udByXTAnga8e006eGrSLS6p+j8csTQ1X0lMn?=
 =?us-ascii?Q?IADKfccWFWE0Vj0vBdLrcCSb3NWk88lgGoKsgqgOAJoPTC9KA/uTrsSWW8qg?=
 =?us-ascii?Q?nkGlK1Q4UFhu+rOWUDSyqeD8z8i5Gteaw2XbvbbBf04+CQLytp9xKko/oYRc?=
 =?us-ascii?Q?DxlpVMmDK1yBxKsKBF5MigODPXTqBVrucTU5L11q2v1tbtq8TPco5XiWFMR5?=
 =?us-ascii?Q?IFZm+4dr9fc4qqv8TEunKo9DInYf2VO578x8RTTCJ0xfebPJar8xKajN49m3?=
 =?us-ascii?Q?2MYf1JnIPPtlFdIXCeCBqnnzhSeImjnvUPfIaSNOmoxmVDRuhjWzqRDV0KBB?=
 =?us-ascii?Q?TN5ayXlrK2xLzHMHDfPzwe/76YtGcBc/8MkhiDcJHgE5DjSRgBNVzggmPpeU?=
 =?us-ascii?Q?sboMKQ1ID/9rsSH55MOtwG0gMQh6NJoJ2Wy3zAAzAkDAI7VWB9zBMMw9to2D?=
 =?us-ascii?Q?wf76qCIeGRMiUafTFTOxCutN1wIrlcygWftzQHUZRlFNfspoAh8CXgEZtSek?=
 =?us-ascii?Q?g5eiw+ZcvuEHojGNf1Q/LKYd9px96DqHk0tLpvmxCK/07ghFpJX8P622emKf?=
 =?us-ascii?Q?URQL998+PkXNKRXX8gB590Zr1lHsUBgBxU8fOis6QKfBLzih1uViOvc/Tavm?=
 =?us-ascii?Q?z5p7wVMnoKM7ewHmtC7GxzQGo84cCcceocFCubifT3faYv9r9b3aYXJSAYv7?=
 =?us-ascii?Q?uMy3x8yUTBw+/jc3pMTLe1B6JM1gEoAQa0Lq8hFtT1ZLVXCL/uxx06JwxV/n?=
 =?us-ascii?Q?scSYmlt/cNt9Wdv+QFSV1VYWfpHAxugBwXjXvqMHZurnPOXGNbt3MvQX1Jka?=
 =?us-ascii?Q?Sz1FJO0aC9GHc2v+8DBtmS/MpcqSloj7hUc+lonJoivh6W4I+qbu7K28HDM9?=
 =?us-ascii?Q?fUEov1L4OURmnTOnj1VO4x0KbLdXTavvCFK3qH8ew3tpVeoZloRnHLAYsVNL?=
 =?us-ascii?Q?M7h+tW7mO6A0VdNaxBzdtKwsv5cDUtyazW0UiHu7YCdcW2Tv0HIR9LMNScVP?=
 =?us-ascii?Q?zreTmmVBGXPii9BQkjkp+jDo/FYOrYR2OV+3Ty+vyucZbvoTaQN0IdDIbiAO?=
 =?us-ascii?Q?OCg9xA1TM5Co8nNuZrAQKNg2XhUnExsawLuJVQmxAvoDQG8GUnbgY4oHtG+V?=
 =?us-ascii?Q?PjW/f6cOTJuynU5GI737UqfLeGfktuQa3ZgXbSwxK7mQ0DDN8QUwLkF2xZ59?=
 =?us-ascii?Q?xoCn+KOWYSPzHxce7311ruJqzmjVEfGnTDan6vdD8lPbZVPXlziYXwnjWsv3?=
 =?us-ascii?Q?EJDlcnK4PmPHAKcSYeAPkwE2zsPiMpxpKIaT+dKZGB2Jyiikxp7BdOxy4SHH?=
 =?us-ascii?Q?3iR/OfFSYbSLEfcBSZRDj/nmI0o9s+256ot5FTtsJF9nuOP0ORFNPbwBo/qt?=
 =?us-ascii?Q?D786ImO8sIoDbL5fsuW4tKEztVP6rvQuLY9QaMR5Z4SQ7Ol7+o6EIB6duKOl?=
 =?us-ascii?Q?fWAtyMaqbEMMjODcgnmg9PSirwTJyI3QOyKYyAK/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 831a7b89-40ad-46c1-d5e7-08dbad18f44f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 07:31:29.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TblLltxnE1L6HhbPSzPNvG2KxSfli65HCBwKLvWa7zUn96tPC25ty1zbq8dSw1muEXF4S5YZJeuStVuLxctt4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6073
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I have a question. The numa id of the cpu can be reconfigured in the VM.
Are you talking about vNUMA and the numa balancing in guest?

> Will the page table migration operations initiated by the numa balance in the
> VM and the numa balance in the host conflict with each other after this setting?
There's no page table migration in host. Only page table is modified and
page is migrated in a single host.
Live migration also doesn't copy the secondary page tables (i.e.
EPT/NPT) to the target. Instead, it's rebuilt in the target side.
So, I don't quite understand your question here.
