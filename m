Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B647BBF91
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 21:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjJFTKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 15:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbjJFTKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 15:10:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7509E;
        Fri,  6 Oct 2023 12:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696619401; x=1728155401;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6jOWf/oCpJzoU8T2GyAS82lbsZbz4+GQPPdWvqpZ0Es=;
  b=dmSFkFPfY8Ceh9cm8CI3I5AGEpwmJrXIeRvXP9xzN7N033TKg7+d0p5F
   KwaOmvqwkvp5/8V6CfMEOZR40nyxoHSdFB3WO/p7tEU0vXArVjJKK/5FZ
   E8zi0cwvuDxq4RgkeifU3e9ZRPfe7V//ud5Yi7NG95Kb9s8FX31GDZoUa
   suQcRPR1gLKvJPdEyTlWEmHMpf3+qmyLQ27TWk4woIEze8UR0qmXktlX1
   MDzbXZdiS3jXMpeeTN+jwizzxehD1Hs8rFRdGTf9vbKfdHMjZAChhaHAz
   4hMZcEtABn0lPehu8GlfFnjdTEJvbRlxQsvY3/P7Wf1iepfMN8UeliJHm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="374154754"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="374154754"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 12:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="818114883"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="818114883"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2023 12:10:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:09:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 6 Oct 2023 12:09:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 6 Oct 2023 12:09:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 6 Oct 2023 12:09:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTfz248xL5K5jCXF8YTsY/yvEFgAlxiKiWt3xnsn7LNjs/lo6WXugFkUlWUZxTdmxKQKVZb+v4KaijbkH5JXkKjesEnfuW9hMb1pKQ/4fBlQ28wUkBII+vcZAc2WuPMeOG7S9Pji5+moXYom97IqeicCP0Lr2eB4YRRrH1wrtf1g0AgcbsTMrl/KjTYg83Kglv6ifjOrEm9xXuadh/oFV0f9tWq/49Q1u9fjWsV+gXeV66lToO6sFk+dmR+85zp4WPMnCptww3R3wqtBy0SiETpVqzBpq4JHSSjH51eGTFmaJjFrPcXZ/JyiUUMsVHMyd/zKAoS/MyCIAOKuvreCew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwDzYugpp/2FfGOjsUuOI+1lc/7JHW0Zdb5769I5fQ0=;
 b=cLPzcKkvASC2fKmatDb/KXf5WpJ++yq2BuCtuuE5U2aA5ygrTS54ZJJ05hX9tuQtfF3wXIC5fK6DPzFFMuUClXi/ZlBwLF60X3pu5Mf/ld/QKi9yFDwuLa/SUl+OxRosPBYCv3HAQDoJmX4KnjZMvr6+4SkBuaNg6Z1fD+AoQunNwymvDmQupSzAapzb7bsTTSyik4YknmtWbtAqw+ilG+SkPoPM5LUVW0CrDXrFjXknqbHkWhpTdywoEiuF1EQQzNTuIfmkpulwfKOY0S5X02GiaieSUFDi8PuYJYSvnwan6/PXUMLlckuWB0LZv4XsqT+8sg6G3Q3WONer7GZxWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Fri, 6 Oct
 2023 19:09:56 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.033; Fri, 6 Oct 2023
 19:09:56 +0000
Date:   Fri, 6 Oct 2023 12:09:52 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Lukas Wunner <lukas@wunner.de>, Bjorn Helgaas <helgaas@kernel.org>,
        "David Howells" <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Wilfred Mallawa" <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: RE: [PATCH 02/12] X.509: Parse Subject Alternative Name in
 certificates
Message-ID: <65205b80a3d6f_ae7e729495@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <704291cbc90ca3aaaaa56b191017c1400963cf12.1695921657.git.lukas@wunner.de>
X-ClientProxiedBy: MW4PR04CA0323.namprd04.prod.outlook.com
 (2603:10b6:303:82::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN2PR11MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 7692e18c-6361-4e5f-b8d9-08dbc69fd3d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhlKK0JhTAgGPfdXayzJ5NMd5q3K5uwE5JwHbvp5aJE+qztJS4hoyz6Bvk3m+n4rMGBv/MdavkZ6IH+VElaPYpOhZQDyphMKI3fMzmdvyR7z6eLXq0IgigrD5g7lqABMU5/Vdltzpv9YDsr8gyE6GXKBM79QagOeizcQdhXlcnSFFZEwKJgMurawX2sTpD6TIeVZb+ysBBHhhZILDgvk364YBKUN0XzORqdxFvrK6rHkV6ZXHuCewn7I/bWaKxByQqWySJ8qcrmsR6E1RuHEaNbwAkkKL0ObSFCbX5v7xMr+BCIwFKcckYUmTlQiLuTn2+4dkWpBARNEfjVk+/razZqzEDqOnPQ1D21N67qZc3mFkeBsmL8SSsdaMYqEFlw5RAgrNXvhFcnvAi5eFPq8v2gGyARdiXBFKJKbmcC31Ye5pUsV5XWH084l/9fxEktZJQllhcDVSqlEzreOA23Sw/gkGuxtvzQSQy0ISJ64GfBgPScXthCf1wFVbs/mpkFIr12K1B8awc+XfZ7sGxHm2NPeQ9jwsc8IvlH5k7I+PXsg6tOdNX/d2/gUndPFIfslGAerXiKwDwloM8/CpKASdLplEKEHa64OLcL29UQY4h8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(376002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(5660300002)(26005)(8936002)(4326008)(8676002)(2906002)(82960400001)(7416002)(4744005)(86362001)(921005)(38100700002)(478600001)(6486002)(316002)(6506007)(9686003)(66556008)(110136005)(6512007)(54906003)(66946007)(66476007)(6666004)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C5AhTv2GJ5Hhqw+j1GmmF+OVObZlNd11npBy+n5/Rg759BpIwcV+/jRF8Dxn?=
 =?us-ascii?Q?QP5GGfDkHgY64sJt2RaLfPJohWcAEQEH7aENrfSBIWDTYTSYckwpoWfNHvzl?=
 =?us-ascii?Q?x/VaQlFbEmk/retvlH1ByoYu1+/5A57yDfBJh6g2CxAdzeUZKrp3dgLPkEQD?=
 =?us-ascii?Q?egoSdhEdFxdEi2nHKlciKXTpgVEXZ8aX5g14A84BKiVZLoTfu0I/CDSxZxK/?=
 =?us-ascii?Q?4LlySPz1Agh1LgSjy8Qu558SkZ+206qCyYzczID5UuuQkUfLC4OAsTm5egYH?=
 =?us-ascii?Q?NMJPSboyir9XiC+CWgR2Phi84Wjgyy0vaghDA/vULDuXNISxXvQQLg39wfcK?=
 =?us-ascii?Q?RdMKhCugHT6jWAV7DZh7rVmGvz1HhiKK21etttOeWKnzUfNBWTYoQmcKPkUp?=
 =?us-ascii?Q?+jqBw+gHFqBU/72GO4u2ztk2FtsWyFzfkYr+A1W0SbHMbbPOj/Nki5wBaWgO?=
 =?us-ascii?Q?T4yKxWkj/D6IFOjKUwQAVUrL50mt5nidOWDkCyY5O+lx+/Qgu5G5yGoRrUbG?=
 =?us-ascii?Q?1nGkaAtqBakQsTJSBg7JjBpjrA3QNvCdiz2zm+ffkLmN4IhDb4Vi03hbi/U/?=
 =?us-ascii?Q?Bgvot1EBV+c71gdVQOc0EoefASDentF9QJPDzC4YVD5PJZ8KnENlV1AeItik?=
 =?us-ascii?Q?14K6njE0oQ0qM00Kao2YaYcuC+mvaKR70YhIWEBIxBBAgOrCdci4kuLQ5iXg?=
 =?us-ascii?Q?FBpEc23vaO4z1HbSXuDElXITm9SiAdbqlg8WuT6vgM1/TYalKrkwZP2k5vZO?=
 =?us-ascii?Q?bovqRLHPSMOQkhoGxyIs6XI5OyS6f/j9uZaniCV5xYm1LAV1OlyjZYmTLmiD?=
 =?us-ascii?Q?GWu9qscU6XtwmXh58PPFFW3sZnmuV/hKxDStWp9tkMve0OaazWEbpsbX9GJf?=
 =?us-ascii?Q?un8NPG65Ma4BXE+CW8XSvtykqLQedp0qvS60KhirQTyEeTuZvoJKPcqsw1iz?=
 =?us-ascii?Q?FwEbY7XO3Yi2174w/aUrfqMayCHgwo8G0YBSX/s0A2BtT10Z44QcKlNv1AEk?=
 =?us-ascii?Q?WHQeLkvnBFaHR/gFmP/vo7lZZtgiif6q97axiGREnLLEaP5uE9GWcbDhFRIH?=
 =?us-ascii?Q?Pwve+f/qByDQK0R2N4UKxAyN8yQ4DiCzwH9dXBO5iAuNYrH+aTzbuHm0KW0T?=
 =?us-ascii?Q?iTeZzKA/+dC+EKVUETIkwqjR3gfqEWmjmkc0tc7Hg88vf0dmTWxdV6fFn3Ny?=
 =?us-ascii?Q?q2ki+dwp11J3VwyMxwUPKILTL+dR/c+8AugBBtzuEuHVYBPGrswXvoPz5+qj?=
 =?us-ascii?Q?6Hzllx86fDRQ1SyTtK2/uUAr2vjO3iThkO+/ldWGGIpteDvFv1eOQfJZBCBr?=
 =?us-ascii?Q?UTDeIL7QeujAZiyL6MydY8QSDHbUCll6KRYzmlNK4+1qQYrT8tH+Smj2fLfB?=
 =?us-ascii?Q?QlGxrISM4FZbSCnnu7gGZXgeYGToYlj0SNcGjt7ASEdExTdIVDg3J73+fcML?=
 =?us-ascii?Q?vK3+zs0Lls91PayYpg+WF2Fq15KEeidDk/zWqTyZ1/5FyEel9bdMN2KSdVs7?=
 =?us-ascii?Q?UQobWMU7s9MZy2XBLGB0+E4E19d3jooLEY5e9Cv/e33vUEzFsbr2gwwDw3CS?=
 =?us-ascii?Q?N4PpaQ076tepFLVFwa2LTGCYdp49pBOWmu1H9zRrkQ2c4U6+IkU6O8LceuvV?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7692e18c-6361-4e5f-b8d9-08dbc69fd3d6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 19:09:56.0566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzUj17zWqkDdq32NckbCUUM8LMrpU1N5B1qpqwUVy8yPd/5s4/V7YUH/xhJ79Lo+uDmLNWBwEIFGRjCz4h3+SzIYLEm+vaPYyL4/3prUyT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
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

Lukas Wunner wrote:
> The upcoming support for PCI device authentication with CMA-SPDM
> (PCIe r6.1 sec 6.31) requires validating the Subject Alternative Name
> in X.509 certificates.
> 
> Store a pointer to the Subject Alternative Name upon parsing for
> consumption by CMA-SPDM.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 15 +++++++++++++++
>  include/keys/x509-parser.h                |  2 ++
>  2 files changed, 17 insertions(+)

Looks ok to me,

Acked-by: Dan Williams <dan.j.williams@intel.com>
