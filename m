Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE35E6BABB9
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 10:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCOJKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 05:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjCOJJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 05:09:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4F823D9A;
        Wed, 15 Mar 2023 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678871337; x=1710407337;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NY4xfpFPYTiH5ydX7sYrVQqrtRs8ubRVth75bfZPwrE=;
  b=gYa9AeJGfNhvbqRX0hlxreMF76rdj8BEGn5eOmDH5JQpS4i3DBIvonMM
   NzHGBi3fcg47eb1fMW7jRf3o9oiMuRds/rFmGvKYJETWbeMdZo5H8oKNR
   ucBN5ydPrAPC/oCSuA+k+8ExFQ2SSMbx3XHJd1Qwj7ncr17/xxRLuftNq
   M43D8dD16NAh135vM24B3L6tMhGUgqtOfTli3C3JEIqOIEohRsLHQuQq6
   HYbFwazep4VRazdCaf58tBfHThWE9LIvl2Z7yZPdeTNT9bDIF7mvnlvHv
   M44sR6PHQA8F3b2bCXkQmWuw8JLTO/0YBMk1+qYSu9CoaD27R4qLcw5e8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339193357"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="339193357"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:08:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="789720912"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="789720912"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2023 02:08:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:08:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:08:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:08:56 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:08:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAW8OOG++xX7+EdYI/NgRpMO++IETAs+iMmWdYAYIG7+WUKuRPSjhcBp5m9bYAN3wNSlqkQIU1KmNNSlkyDAJERYQuUhkv9P1gfFFCXARFAHSe7fxgOWgSpAj4O+qscgbLsG5vkKkMEE5bBqRG+hSCBHrkloWporzdEtLmBJkZXla60rfvYXfkLxKE+UAhKzJV1qKro/IcGUSkAaeP7IlMxpuVGADxrJ9slCPmFTdIemcor5wYLNmEqtCLPMQr6knAkpJ462pv8GH0AI6VDy/smTVeJGo2s7uSaVPtlIFk5ooMrO3L0CNC9ClogbcXL/uo07mn1dkjH4SscR64vcLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wP4O4W02X7+FbB8VGJbKvjKfDzqv54RQU66G9GnjYLs=;
 b=BQ5nkG6y2zf+LuuHHWjmMzaXB2K1gRw871maEwzOvykjInRb25s8+rn1EMAwNVZGcHUOjCqjNimMdfe4OSC2zk5ZJZYZHu4SVn57p/7DblxRK0prSQaxctVUSKjU+Tf+saq0CtRzfEOLf+zKvOc0kP8Z03MwZKECXzr0778g1XlejCu7T+tnL70t6dOl6vNBfAPFyVx9pMvLmylcfiUB2KlA5ASKkOvGL/ntSLsYqcRyHhz/YX+0Mx64krUPiuB+yeG/ppJ6mJ+9k9YXYonDo0iHY7/IYrgs/axkfOr81IZ/uKKxJMJgXaXyaDiTFIvPkY3ZHXFtivhVvv7pgBc29w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7649.namprd11.prod.outlook.com (2603:10b6:8:146::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 09:08:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:08:51 +0000
Date:   Wed, 15 Mar 2023 16:44:14 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 19/27] KVM: x86/mmu: Move KVM-only page-track
 declarations to internal header
Message-ID: <ZBGFXrpSXpF5NUlV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-20-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-20-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7649:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d842227-b818-4440-13e9-08db2534e48b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPXz18qk8V62eygpy8WYTRihMGL8Sru+1sOOZscnAh5e6bvURHiapSLGBAy2vHg1gtGPrA/CV2gRnOSHBLuLiCzQjwGlRZ8FD/oy5CSR2Pw6k018la513pNSfDLEHdrSibwZpzvwKTeGEUNjUwLilUPKJqHlk/DmXMyxrTIVfo7Je3r2oHjz7+POdZD1r3yvaufXhUxRLgs3ZwTTN0uoVJ7qwEQpzx+NDfpXooLQ8kNJbxK9vig2EvnDEnH35rBOM6T+eF37aJpeSOrIGmic/p6c3o/Bc0Xowcis88vZoJg8+P+POPC4E/1/kTUezoNVLa0PVszKA94MTkyPqn1DoAbb60MpECiv+fgtBQTRwf5BWSUU1HZTiCZwMjMMzr7HH98eRt6TWfs4Tgy1dg9B/ttHFtXjLbmVT8pokYL+6rTjcgYDpRyW9N9rq8sYc55XPpG0f+Yd3KlLMnaVLih1lS9tgbvXW/my38PhJRUrZY1p16F44S+WjSgCyEc2rcURwdFqR4kPUCvn1ppYANfvuufErn8Xk62gXKub8ez8y96yTaAO3N+Ja7Xe4GXp3Ic4hElvNhMpTRsUI7PUP1Zq6sLmFn2dI0/vDC9v5ILezcqDpQfxLni3Bq3r3Sz5CmSk/UdPrNK04TTJoptrT4L78g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(38100700002)(2906002)(82960400001)(3450700001)(316002)(478600001)(6666004)(6512007)(6506007)(54906003)(86362001)(26005)(41300700001)(4326008)(66556008)(66476007)(8676002)(6916009)(66946007)(8936002)(6486002)(186003)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MTSQBuwd8bv/nIUeertNd9laLRWlw5gjlYx4ipbcPasN9h5YK8GGAXuSoN1F?=
 =?us-ascii?Q?LqNn69B7xeYENGEKMaRaRqtri7jkOLZebvNgNA2FZ1zz4PCdYUcbHmIUB1jh?=
 =?us-ascii?Q?GvyGghVrtg6sJWSM7gd7Bqmj8II0wAHW4eC/kl32tUqynSEPBAX2+FR+aZIg?=
 =?us-ascii?Q?GkYKRSjz0dp7NEBBFyagnGWJSw9NvYdA7aF94MAvqZ8dBIDFeP++RSPczsms?=
 =?us-ascii?Q?IY1eQS8vVn7/Ab9VFxj612s+FTGeKSKAlwqI2Uo5IFv1eVj8R5BfNE8h0MWq?=
 =?us-ascii?Q?yjZfFBpA2LuT81Dq3Glm++uf56M4iV8dfIdHB3sop7icSd2EMwwoOdZM1lcN?=
 =?us-ascii?Q?L5YzR8JXiMQZ0iaNKB2llc3sSgeImcKZ8N8ks0aKJTRxNM+rVksSIACLJoAG?=
 =?us-ascii?Q?mrHQtqfcm1eatTRHU8wByz64I1DtLaKkTBpsF+YiUCDkrl0Do8jg9Xaa3WQE?=
 =?us-ascii?Q?xdGvnvS5z5WTE2/r2uMh0frqVIP0jypAtDros2xoC4L8uH6AFhCg3N0ZNngd?=
 =?us-ascii?Q?IyyRzX7SpmU06KFR6Z+IrsC1ACh7re/eUlXuxev0FwWjxcr5Ze5GPlnwwjNU?=
 =?us-ascii?Q?eA2rwuLy47JgDGWg4eBkQEngJXYaUVzM28Bz/dlG7+hZEbETRj4ry6RyhZOm?=
 =?us-ascii?Q?/N/4CgclnKaQdO9CPE+pT6EIm+T3PcNltrve7BvH4XxCC3ERtvny21hiYF4H?=
 =?us-ascii?Q?yxaCtz+mZDMl0CDASynrvvDV1fEOMW83Zbxrb4w4uYOOGIAKFTAf8srfBHWZ?=
 =?us-ascii?Q?uvQfssQFQyBwVDMbEzF5+Vpj4eM+EGrezkkXGFZ7bKIHYBnDnhlBqJKnB/i5?=
 =?us-ascii?Q?8HktnRYcF0KjwSzL8NNYjHqZ3XBh9JiNMOeq/JetDEW2L+7uce1CEwMKblZJ?=
 =?us-ascii?Q?VkWuLnHhwLJDXrXWBxUlR60+5VnrBocTLxw35pvAbmB5XkuBKZtk042K1NBl?=
 =?us-ascii?Q?jKyMhDk5fwIrQAzcW/eTZP76gJd62W+db5hNtyAZdMNDqkULQIiXVLN6wUMs?=
 =?us-ascii?Q?m3a9LxNNoF5Q9glffIbW8u4Vj/ytulg3qOI6n9/KtBZ5mQv1JEn+NDmMnGJj?=
 =?us-ascii?Q?GZbBuIW/yd4ynC0LeCHvdMl3ugbhifVTVqRelvGEEBw8mwcgY7+3XgMd4K+7?=
 =?us-ascii?Q?KtH/l5/mmvwb/VdzBPdYyxXnCv42tzJ7Zwczm/Fx05R9nxVjWOI3M3P102zk?=
 =?us-ascii?Q?oanESQvMccVkte6J2/aUmHE5MCNgu05I0BoZHSMJ8KpIWNdeSfSJnG/8Bnz3?=
 =?us-ascii?Q?8CJy6SFs6yADLQUf2cVHexf61gcN1Hc2WkMq+lJtE6tLoZlJEHz1xNeKdFGH?=
 =?us-ascii?Q?AMrj4F+LwYTV6ZN+FtHcZWsSSncjizxBKCfMoFhlU8oHincBsAfxYH2aEyFN?=
 =?us-ascii?Q?HP+e+7dpiXd99VrbQU+9p9evVufbWqBMX9iKmtdl1JHD3DINHUqUYNLqoI/R?=
 =?us-ascii?Q?KgqJZGfMBGGeMO7VPnql5HRg/2YjFW35RP9hk0jPjmgRPtZlbDJeVdy4Zu+6?=
 =?us-ascii?Q?m/g5Mg6AgKf+lyUM9/da3kO0xqLf2x3LM1BD7JGY5/nx5TxZ4B72q8t0CLAo?=
 =?us-ascii?Q?hP1saeGnTKH7VozCRSVmQNw3U3LoL20wlg0rs2Qo+TFcSg9s4bloWH+aSEcW?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d842227-b818-4440-13e9-08db2534e48b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:08:50.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYthy5EuaIlbvpMMr0A9GP96MOXodWivWR3EiiI7jHYqH14259jiYUAUgBDP51ziQSlEl/1l/mvgnqho0U1aIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7649
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:50PM -0800, Sean Christopherson wrote:
> Bury the declaration of the page-track helpers that are intended only for
> internal KVM use in a "private" header.  In addition to guarding against
> unwanted usage of the internal-only helpers, dropping their definitions
> avoids exposing other structures that should be KVM-internal, e.g. for
> memslots.  This is a baby step toward making kvm_host.h a KVM-internal
> header in the very distant future.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_page_track.h | 26 ++++-----------------
>  arch/x86/kvm/mmu/mmu.c                |  3 ++-
>  arch/x86/kvm/mmu/page_track.c         |  8 +------
>  arch/x86/kvm/mmu/page_track.h         | 33 +++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c                    |  1 +
>  5 files changed, 42 insertions(+), 29 deletions(-)
>  create mode 100644 arch/x86/kvm/mmu/page_track.h
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index e5eb98ca4fce..deece45936a5 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h

A curious question:
are arch/x86/include/asm/kvm_*.h all expected to be external accessible?

Thanks
Yan

