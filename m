Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8177277B39A
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbjHNIM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbjHNIMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:12:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1966010F0;
        Mon, 14 Aug 2023 01:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692000751; x=1723536751;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JSd5OCGXliyYuzz/GopF8FCtalbnrAsgERmxWH0fvq4=;
  b=dmzZ8To2lReF6+uWvP/TWkw/nmBBWSb+555jj8C/OLdaDbb+Ao/WXctM
   xqMbCJzQmVCsIgiDS3qoTJNfVQN0kUj8dpfrsNafr/4+II1kaP/PFd8cP
   u6xn1pS0s01E02Unph94EN7cNgqkAeTrl74nj/nnAmG+HrmU10GSBeVxm
   XR2R7x5ZMSFnVKSBEyPrve9cvHS4XeO9OydMKfm8pHuf883YHEc+SrR5K
   4hUl9GOxblO49JrwJPCCN/fip2MiazGyhFlLx80E0Vo934G/6mZKwHdfn
   dSt24wHDn3c8Wzy1yr4OaYx7f7MjfWa0GvI0QRUNBvZYh4V9NHnMC91JH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="402972158"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="402972158"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 01:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="823373331"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="823373331"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Aug 2023 01:12:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 01:12:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 01:12:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 01:12:14 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 01:12:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFfW2HvN6ePJ9E8kmuZEiT4wTVdHIUUaiD0VlLpAPk6kRBxPDqMu+PGm/RyKZMRvmgWghwH2avs2ufoiNOUCB5rVdKCBlHKBKdCNKLeUqzq7eOHQn76MHLzGv426Em0oEmpCXOLqO2ISLyPomCZ1nVDzVJbUgZahiH0bJw0cfFD6MaOor7Jd8jTW2bCj1mTKZdaIZ9f9tk2lKoSOlNyEu7EH1NlB3cjm0rBbSg/j4dKA4hqmBhjPjhTFzheq070teu25wYHSYW98ffWySEPpIJgzElxlw5OADPUICoqv1suUGMjXtKF1+UUvFm19nULxhg3APaRaPj1xkvqK53Me/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CImVrTU0qgsMu3DKXSc5ZHHj30pxc5vpv3yycexHfoE=;
 b=kGQJgzbfi+iaNrM5LbZoRAaqA/Tw8wDGQhNrH1kZ7qsZfj7e+NRUmTGx8GMu7tv24DudO1847M0wWz2UI/D/K3zBDATcvwj5n/IzAhFBk9WKnNIevKXujBpTMf0Qmo5IQEfoME/gRCAiBgUNiv8HaWimzq0nZSW+/NF1Cxy9s24qKEQNI1QMR78ojvadsfQAm+VhsSkHVikZBnnJNe4yFMBiBUBM7ar1fDYSYiOeAkwNgFR3GKRjeyyQRxrIguDEb0YyGSClSv7u3wSZIR5OoFnCP7hxI3kq+OP1GglTv9cMk2tGXV5+PCDzsgE4nTuqiPojhQFNs3QRUchKq0Jxmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7533.namprd11.prod.outlook.com (2603:10b6:806:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 08:11:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Mon, 14 Aug 2023
 08:11:56 +0000
Date:   Mon, 14 Aug 2023 15:44:54 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        bibo mao <maobibo@loongson.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <jgg@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNnbdlKb6Y4L4vMx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
 <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
 <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com>
 <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: e39d5f31-95ac-4a4e-3957-08db9c9e2023
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVtStQ7k2QUvP2K56QKBe5/DQrXL4+hqxZLqjKzOsdlkY1jpfV6a/+aK6QelacS59aXDY/URuymFvRJV/Tz1fzaSdNbLAY1GwJp6/45J/ovBa7XJ3/c0akrfdgxNve6yyLShQd4Q5WkYfZ0dd8nYy7i+849TN/DFYLkPpIklVNYt00revro6PXZSRduqJqNgmAj+s1aqOuVfiqwQsD0ipySCPv2NkxJjN+8BHJip0zVKcoPWrx+PllrT6kq4PpPuUlRqmDsMw8iEFHjhqwT2IcgQVdhnpWfWqcD+y1Y9e0lMV06Si6f1DMDdKEjBiQcfZV0ZNwB7g2VgbCm6Xv5ps4IJPo7ksBkBu1BS9XppsON7oKng3uL8MkEnDjRPGCciPxQy/S/V7ii7iLTKtibsvOKXsNVPXqZjXjIH2XVMiFfpsn9ihWfXzMpmPS+Vd/JSK/TEgaxmHk69CeMvzWjOqBKi993bjjlmtBB7Wm8Qpbx5oqjLPWPjhu3m3AlpoJqeJp2KTh+cHicEL0x6Y+Im7rbB3lS/wrG5OAkFqiclS3vuYz7EQKUMOs2/5mLC3UjTrSYQtI3Qo7dUeCcG0nUhKr5ze4qvTmr2bXp0cCV2vxrRJZzjUW2Gs2s9vVWkKDyrhZLwIdy5X7LfTC51zZNs5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199021)(1800799006)(186006)(38100700002)(110136005)(6486002)(478600001)(921005)(82960400001)(7416002)(5660300002)(2906002)(4744005)(3450700001)(86362001)(66476007)(66556008)(66946007)(41300700001)(8936002)(8676002)(316002)(6506007)(26005)(83380400001)(6512007)(83996005)(2101003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dh+bCkXevfxNjjzdFjTgIzUXge8qD3LFncRZGd16hHCpX3DZjOr692wI+JRk?=
 =?us-ascii?Q?KcbGkevDKQHwBjOJJ3ODAUFcX9XWMijDY+gD4GXMQy3KcURdG4lVnpHwLQRB?=
 =?us-ascii?Q?xtHSQmowDmLtOGpYmqeTS6Oi3E3WRxQIkKtcEvZVauCcUcp0ZUmRaK6h2/Ne?=
 =?us-ascii?Q?OpxpqaEbGASyOoVG5lNIiFMYVX08dPGoMvGjTYw8r+bCYXLc/6otq5TD1ugD?=
 =?us-ascii?Q?TeZN2GJAksoEcwMVC8iqs00NJFpWtLstJLjEUMcYSBxyAU+qQBJ0S1+oRQIG?=
 =?us-ascii?Q?gZ186SKjafmDGhzDXAFyFWOvWRho8FkQh8cBu8NOgwE1D3lG23/J68+lkBId?=
 =?us-ascii?Q?3OLs0dWWU3TIERZe6Syi992N87r2hBGKCw2nr9cB9MJYz6b98oSkySTWG+IC?=
 =?us-ascii?Q?cP0w39tdwcdGeVNOfdhrpSzls31XmyVE4cFN7Oj1Xa5rkkFPDbiGMVF1dE0/?=
 =?us-ascii?Q?A0EM9pctBh10PkIiffFQdW7O3Lv1kcd2o6XKh12/fPwx1CvYV+p2Gf+gbRY7?=
 =?us-ascii?Q?Zr9We97db+RGpLRTfv87Diywp5z8Bk/dbnHu35c9GwBdWsreLDSa+eA8omp1?=
 =?us-ascii?Q?KnomGIjgeeDjgkRlre+Y8aOUUbkNkiTfGG+E81q9Tdag4A3/Hj81uPt0kM8h?=
 =?us-ascii?Q?0eLldjGrfD/4lhe7Otp0jUyW41qd5mBB+tHGx1QA6rmnORPmCYLt0UinG4gS?=
 =?us-ascii?Q?xR8G7XZf2Sqkt26IzSN+zN2tOFjsJiwjanOo5toMI8xrNqEA210uDMY1xqeq?=
 =?us-ascii?Q?5PPqmfonWFiyaqZOWeAsV0ubSnXH2zl9ztae8U0XFsltDJZzDacKDVe2F4AO?=
 =?us-ascii?Q?zv+QuJYjEsGh7u0950GqXjTN9iWr6it5JmvnC2hoBTRQAy8Kq4fheKZ9+lGD?=
 =?us-ascii?Q?F6iYA93Ioh6G7S3Xlqxdk1Q8RUE/lTsScfnzhofWe49J4fwtAH5H0fXy5XD9?=
 =?us-ascii?Q?3TGLfKFeaEqhZYD9kuwqWIEMsLycraBYXq3hLDlYBSoQmmBY1Kawsnj264mL?=
 =?us-ascii?Q?pxLPmcfNSkb+Wzta5ZXGV9gMF81BBc+y64APwihjUXZ4BEmcOlKnEwHgWEkx?=
 =?us-ascii?Q?Eq9tKrCTv8qLgy6r7puwyMdLCHHjP1AQ5tCjfoGDtA6JV7Epnu+YdVPT6M9I?=
 =?us-ascii?Q?nVcEXpVCLAaMdpezCLdt1M5dNIuR94mrbCDpdsWHClSg96EA4QTTTQKYAQTQ?=
 =?us-ascii?Q?biRgog0RsMufCwzlPTxFo5dxQ2JlX7gD7lp0bLXyrTkH/fq0bglZBR0QK/GY?=
 =?us-ascii?Q?mhRllGMn1l1QHqfQ79jesTLf+FdCtYeDAicEqpBy/1IS4ZvGFb+OybO2CQl5?=
 =?us-ascii?Q?KFAMECrs16AGtH6uR0f09k6Xv8ey+lCQBu9z6mUwWypbxJA6Wm1MlxVQAJLo?=
 =?us-ascii?Q?LQXaGCGyn8kagPD4lsoPizlxc2tyFvRyz6Squa1Zz/XuONc1raHafcmD3N0Z?=
 =?us-ascii?Q?GgDynlOmTsMmzIXo3R68BZa3J0/zA38x0ZzTL9s68GV1MZpSpXeUijN4fbMx?=
 =?us-ascii?Q?BAJWYw1+QrCeUkzGYUQNlyh7IGUARVTPHIGMiA5imokML6T1U9ZlkVXdDBGH?=
 =?us-ascii?Q?d9HDwTJVPHOIm3y4jbWmh8P5AHAbWTxWwPiwsl9r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e39d5f31-95ac-4a4e-3957-08db9c9e2023
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 08:11:56.3475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfQ5g2AcwzcZQA/U0p6JsXfWYRAiuWfhI2CV5EOBLnWNXFY3KCK90eGoe+5E74Az9TpEEHspPqwfrF0UpsMjjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7533
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 02:52:07PM +0800, Yan Zhao wrote:
> I wonder if we could loose the frequency to check for rescheduling in
> tdp_mmu_iter_cond_resched() if the zap range is wide, e.g.
> 
> if (iter->next_last_level_gfn ==
>     iter->yielded_gfn + KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
> 	return false;
Correct:

@@ -712,7 +713,8 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
        WARN_ON(iter->yielded);

        /* Ensure forward progress has been made before yielding. */
-       if (iter->next_last_level_gfn == iter->yielded_gfn)
+       if (iter->next_last_level_gfn >= iter->yielded_gfn &&
+          iter->next_last_level_gfn < iter->yielded_gfn + KVM_PAGES_PER_HPAGE(PG_LEVEL_2M))
                return false;

        if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {


This can reduce kvm_flush_remote_tlbs() a lot in one kvm_unmap_gfn_range() in KVM x86 TDP MMU.


