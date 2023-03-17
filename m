Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F31D6BE55A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjCQJSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjCQJRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:17:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3986F98870;
        Fri, 17 Mar 2023 02:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679044668; x=1710580668;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vnFPUNSik6INpAg3LHdFDAyYcgd0QGpx6Lm5OI9hi7c=;
  b=T8FSJ0yhhDXVDmq6/m8soAWGQl0ozkiIhtpXG14PTZNkAZL6A0zKmYBX
   QKz9mpccp8nd5Qiq8yBR8qY2ydbruSmQQrvi1S1mQJCFb60rZBrX91Y0r
   X8NRLBikFAKSnTjC+AmFHUqC0U3uAqBeTk/EIcfi5EfK4TiJo2JJkGLEh
   qMyKsKPDZDoNYtZdR68fRwQhr6/BxH6TbVSIcJNNqot6qvF/vBNQNMvqj
   WfThRWP5nGMerBEO2pxfpLgIRpCfy56xzsMHWl2My5TbZyrrcDxuUo6Xt
   anYZq/LeUyfoXXHhftOBeI/V3f6PLMyHxUJiFp2d/PKCay44m75zAkbXL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317875166"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="317875166"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 02:17:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="769298713"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="769298713"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Mar 2023 02:17:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 02:17:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 02:17:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 02:17:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 02:17:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnnhUQXfbVDSaMC9vtTwgXKFPH13Aj71bNCxnZqrtbyLUWzZi63HGMpRRILulVtCwXdSduGinoeYgjfXPeCpyF+C+ywVoaPtNOv39+uMBEzJr3Je2cSaksoA24TesdBfuAkgIHIPcE2GIJPHIWBd2YgUz6xzNoqwlizq4/kVGy854vnGRzlVzKpZpnwiVn0QghlTvqUBFPClvk86Yki0TOnohGoVaQgPwpgcWNMBVaBLuFevil+n8UcyzBKLuUrKplBpr+2Dw2Jzh2WidDiSY1GmVt9OvfedfSpie3UiqKAXe1441cNvNL2183EQTnzBIPlu7cNp8MYXjH03RTzKmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NK8MP0hYwcxGpFnhSHLT/ltk2uRq56ddvzjNoNFoEQI=;
 b=LgO94RXa/Z6zzy5R4nS6M5y/uxhQd9xmSzHfc4doUUVWvpAIv9nrJH+wD5yo9lLd/8+v+jJ2YHXVia7WMeV+U2DpTtKxMNBzcl33ttZPe4Y3lK2TTkgjebD/eHEmgm1h29K8VxrWecHgyJCXfXDq8rRp6X9div91qGg1zqgvTyKjPPE2Lxnre2VwSQqeLynAUOTWGcIcxY8lxaRzsZ3AjkKwMnuzg9omBHoIiYspI9iC6f773nwPvAlMer7VsGmQdEN96L/9Q0gxDpwnP/U7bDWxPTWuk0Y6oYuCo6OpM/E0uFekyp+BU7gD5ZV5SWOE1HaWK5AmO7ntGE9aIHlPcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.33; Fri, 17 Mar 2023 09:17:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 09:17:28 +0000
Date:   Fri, 17 Mar 2023 16:52:48 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 26/27] KVM: x86/mmu: Handle KVM bookkeeping in
 page-track APIs, not callers
Message-ID: <ZBQqYNKeHIHLGRLR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-27-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-27-seanjc@google.com>
X-ClientProxiedBy: SG2PR03CA0090.apcprd03.prod.outlook.com
 (2603:1096:4:7c::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 19d13eab-b844-4898-93c5-08db26c86db8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OU/8Z34KpLi4QF6MGsw/5R86Fh/he5bck2mPDToKDYMOh5LhIZiIFj27NimRsHHcBwtbDGPZQ1OORjCCHpST6b6CWIZH/nZ37vjLXywIPhyRqlvVuiETgwX1dyhN1uYbESdbxdghRqAPD1yAtNbnlYRbstaXlo3ZQ13kYv2Lg4w5+IxSr8n/AzC/A+GOqkGZCCEKkOiZHlXwteY8NiM22495Qyz1xNTFgZS/Qd18sP0GpehGLo6ypxzsHBXUhU6prbCgiDUpX/Y/q8qyUUMC71I7h15+mGn+wXRpMmkkAWEQDcRs7xlem69ou0oo5BUS8+zPxAxBznCOdYUTwrD8AroKlg9QmOi2m0Wdbv1eCdzNfOEuF0JM/RMVxcKaoZ4DNcFe8aEyCkIqZ2/Z/SGiQg87G4+TqZGVJs/1edV3N7REUEDy/x1w5L2hTJBz+OtAfZ6q4Z1uMGEJmSiQaRTTLaCCvnBagAPNrzM9lJxyUQN1S+XGYvF9Yr14L1V7R53KrPDBbE03GSFREgvcV2dSjGbv17hZE0YhvZySfrJbAk4q3SEBNcGpUkRL7wUDcSXtORH1UGRqLCRbAeHG7FItmrnNyvg8YuwRuedwuZsxOb2xDTx8DIaNXmGPnnVoVAwYwUcHIJxAlkQJySUZ55pwTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199018)(8936002)(5660300002)(4744005)(41300700001)(38100700002)(82960400001)(86362001)(3450700001)(2906002)(6506007)(54906003)(316002)(6512007)(478600001)(6666004)(26005)(6486002)(186003)(66556008)(8676002)(66946007)(66476007)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pDr03Ru1ujLZ/Pjw32DiW/3gPaQBsHSlL0muiQDAPY+do9RMtahJZnwOMUjb?=
 =?us-ascii?Q?JZ6zoTq788hxQ6tdmsVlt1GdFIdN65bSCPwkei3qziu04ECcZ2rSXBtFsrmW?=
 =?us-ascii?Q?EyD662QnM+pry4lYHtbXf9LyRxOXNqhPUDbjqpBUqUPKiqBefzkmdoW06W8p?=
 =?us-ascii?Q?ELq7PteSduAMyyQJ2h7337dMRdi+4ZvqQ6NH2Y2f5SaF+XqUc5kb72/3WXBc?=
 =?us-ascii?Q?KnA2z6r4+QUTHTlEo1sOgPw1W7RUMISCviJjJT8jPRLY2dITZTk1vFkn021L?=
 =?us-ascii?Q?j0eN8P9YgOc7Ov57vRtgKXlu+6Tb7CPbaFzR+E41LnJxMrKqUZlZSpbda/4F?=
 =?us-ascii?Q?scWWn9XrA4cxz5jRIx86Mpa3pf1KeOwtmeOgnJYheAw9dI8vRlRCs7Dm742I?=
 =?us-ascii?Q?mIcvn/JVruWZ5ryEoKuAeUArVDdASBoclgf+ku43GwUYIwQ3RbwG/mqP0Kw0?=
 =?us-ascii?Q?XodZOy3ygbWzxoRSR1ZpXnaE3DqO/6696O4YEPREraJmH/T1ba9/AowvMW3D?=
 =?us-ascii?Q?8IhQMNjllLRR0EUEsI66Ne/zK8Y/TXARB+zZCuHZlSRNiFSM/jLFY/LQGFgq?=
 =?us-ascii?Q?9HkQLriM0bVhWwuNc0AVvHBMvARIcYsX40WDwCgjrdlpG2h9HKSdETY3O/fy?=
 =?us-ascii?Q?vY7FoAQw9Vl0Vr+i+Wrcjy/R+xHm+aHUnCjJx90T86+FsjhEepYm0Wb7b34E?=
 =?us-ascii?Q?pPJG1eFbRDt39VtbvC27AvMxzWNatA84S0dgmz+5AnlW82dwAAY4ph6DFCUr?=
 =?us-ascii?Q?DPvV/o3HYQoxxZDiswReXjnhv30YPUfzPCmK993vA8ShEU6sqyA2/v+Z7RVd?=
 =?us-ascii?Q?VR6mGt0wViu7kFAU2RFV2X66WyDD8sqk+VmMYeVzDfzJkfluMyGTWyp1aNbb?=
 =?us-ascii?Q?p/hcb7cBojnDzByGquF9wKSWUsUxKewveDvd2/OZxJ+stpFTcuzKVkyFx4PP?=
 =?us-ascii?Q?+rbO1TaqPYEGTHFt5vcwghRQTsMIPNdjALeYpSTgZDn70QRLWjLs2V4yH2v+?=
 =?us-ascii?Q?bPCOyn/geMgVNQoi35RzXie02zwgi+uPSVHBi6ypgOkkl3wy85EsNnXWq/nS?=
 =?us-ascii?Q?oI8Cuy7Li9sGlp8UtZMU8R3G5ipWYqzID7PF5Y55sIDXZ3bRUpsvkzpvGP/3?=
 =?us-ascii?Q?LIpVb0UE63DXeUQpPFKMfu6KZUW3lWEwCrIgvAAp7b5MYI9onUj8wG/qf7e2?=
 =?us-ascii?Q?chNIu9GuCX3tsM6W1QYjwZkdjS6nPIR0dRkjrr2rcNOJCUL3tgRnN5u4nK55?=
 =?us-ascii?Q?Pbwm9qz0v0i+JTCl4m4C6MGZPMml3wqBv8fcArRzCZ6DmFGSfYY6VreIFaNO?=
 =?us-ascii?Q?BWD2QNRWlaUZD4YdR1hlOaNT79GsVA51NCwzC+LQU0KUmqovjG5cUaaO4o0b?=
 =?us-ascii?Q?u0abhRdVukXzO2nkztDwFjd35VPXHIwQZ+QIwuuS+XTSOVDCOlzp1Tmgr+G0?=
 =?us-ascii?Q?mSOpuQ2iBCsKnW1u+ZmljAOIbD12T4Bm8TpCeEj/hUCVZ/2RVPWjpyvHszES?=
 =?us-ascii?Q?bRQQKGYE5j4INZLy4xuT0P60/Fkv3j2ZFftGEpqm/J0dQMH/iNNnhghkLNk0?=
 =?us-ascii?Q?LAJN+hALnPv8fTYxgfX8GlJ2joS7Re+IubkG+0E0T/VN7fy5KrvkIBO+AMew?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d13eab-b844-4898-93c5-08db26c86db8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 09:17:28.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VkGk5Iz35ZOGhChibn6+Em6TaSrTRc717+9tedV3F3TYtVfk7Xad/7kYUSFWUIKlRiwgN2RuTlzh83x1ap94Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:57PM -0800, Sean Christopherson wrote:
> Get/put references to KVM when a page-track notifier is (un)registered
> instead of relying on the caller to do so.  Forcing the caller to do the
> bookkeeping is unnecessary and adds one more thing for users to get
> wrong, e.g. see commit 9ed1fdee9ee3 ("drm/i915/gvt: Get reference to KVM
> iff attachment to VM is successful").
Just realized that "iff" stands for "if and only if" :) 

