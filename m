Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD3165E394
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjAEDhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjAEDhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 22:37:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2403F48CC3;
        Wed,  4 Jan 2023 19:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672889822; x=1704425822;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BgySq6x7KRl07uyRwOVfi2wpna/2sslE/U6p6S/HT/8=;
  b=K4PiKFcQbykOLshrbM3tADcFMQ8+tzDn3xFBVfebfWwXejP/h4X/2A6I
   MKeaWBGE7CZFJXVrrFzWS6104KHXzUGF1Jee2KZkst1fZxqL/VrX+IS6O
   jyYDUeEYg8P8tzX6sVRzRcVJd57z0pmHDlFbcbB6zEQiQz0KPiuKLlFCT
   VcodGC0hluVe9sErCru6eVsrVZKP2uViI7u8IQLFJGQ3FdZ1T8SEvyH0s
   BFHv8HQn9NpPZTNnLv5gvK17CYakCcaWX+pNb8vfYCkZrOiDzuLzixq0A
   9rDB8Xu20faq6NOfZAdR0lAd9rL3txgzqz93JuRGRp6KFZxdS0YDePU4K
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="309876933"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="309876933"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 19:37:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="685951965"
X-IronPort-AV: E=Sophos;i="5.96,301,1665471600"; 
   d="scan'208";a="685951965"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 04 Jan 2023 19:37:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 19:37:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 19:37:00 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 19:37:00 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 19:36:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJmoMdFb+hbDGZVcZWqerMc61L+0qTWtqKevD7uiy8pnvUoSnDsWdCBsVhRwNw4eTWW6h/yuBH6xd384J4oPga8AZrmIhHfKZS0+KBNs37v+RDIDnj7QgOfmjsw/xkW6F8g6JMoeB6rgIlFcbe8Gdk46ptzDGezmOXW4k4tPCn77HATSp1q2YvlxxsdjYJaBqazvAwgWPNeGFqAPFHCP1HFWsnnZY3JiIHaw0hJWxufDh9ASYyw3g0pc+s5zOQNCX5xXjCMwDIVZK6c7kadkdGzoi1UTch9uyWR/JOOEfD3u2nuLGxrfbBKBVd1nNTjJ9hujxTXO6fGigydjsQg6yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/DyXqmP3F6CVlUYHLZ0WLGmypnU5HHJ8urGuEZ8Jw8=;
 b=ZjmIcuBszzxxa+En/5nmYl01QAzBR+osHTXAYE4IejD0CdPegJED1IP+TSjfLPRs4ql/k3l6DFFKwj1Ka1HFZoWQaWrBUjKjJFFrKpCiUfd6PPIdvmbIutw2EQpOllipX8L8DNFoTIT7krm+QYsJin3BdUxDYFyqtHeg9w3CqQD3B7lgZV0cOKFIEwPqNfq9svPt1CdEvxefmY1zBQ5fTaNRjpNfpOv6xdjKyt3q+tKurMbc9VofKOov5/ewx0F25xGRv3b6jA3eYWBSSPe48hTSGHeJLbRUOuskWNtXX2L12B6ZEWtW8JUnG5xFaOJEjMeNuO1yM0kbYBmgGNjZcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6149.namprd11.prod.outlook.com (2603:10b6:8:9e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Thu, 5 Jan 2023 03:36:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 03:36:57 +0000
Date:   Thu, 5 Jan 2023 11:13:41 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 00/27] drm/i915/gvt: KVM: KVMGT fixes and page-track
 cleanups
Message-ID: <Y7ZAZRK9NEvfV+J2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <Y6VvVrYURd/an3Zp@yzhao56-desk.sh.intel.com>
 <Y7TP2R01VAbmmfcT@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7TP2R01VAbmmfcT@google.com>
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf3ccdf-b47a-48bd-37a7-08daeece189a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bK7Rfjrw1HvSy/JezbIvsj0JmH7ySf5k42rXL/pEfORZM7q9oKaC7n6LIBkv0TgX2n8hFcdsplgLY+bJTjwFVzrKeiKTxmz09Y9NEKNBeQN1Bif/Ik8dhq9ZsEZGofaX8KPLTdCTn98+O5NyMcPrSPvAgpOsMIyhDSOKPenwMGJfkYlg+e55V0dGHlKLB0rQWfWAQI5P793XgnVXWKOQKp28IHbe0BfjMdzHc2QJdMequum2OWj9hr3wKhlLv1GWEXWoMfmNhsN45o7NeonvCVitDQt+gwHzr0+Z006XtSoWpndmkf+pa9u/sktr9MWb1MVUDrPNRPTamm6ezwEyH5tRgP/OH9UeKmyZl1cGdhzjATtay82lg+6w6hjC0f/jUPajKV879uWDDzd5xA8RbfsWdvd6qGzCEsqLZbklXtrYpr/uWNKjSmWHoRliRVr7nDrhAoyvdA8eSIsSeNRFMkX679Uv+SUdwmioNUqdbHDImlTb5Qh+KnC7astpxlPsMUpIEVEgMnUf1PXtfhjVuRTohCOmjqqjCp7xKwI2nNSlWOPIBGrB+/mzxPC05xij8h/HE0fStZeS5yZ1lbB87MXVcW5R+/pLfayYpY8OfTB99cBkXSBAOfEkKd7a/M1xqeg0Poubt+iSHEEwSARaal96JcVd+VN1DTSwKv6/Epqo4tVaX751at9c2neqJeOnqpKSjwCuzr1vQybPad4kX0tQp1iNWxIkWGTZoYCZMmU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(8936002)(38100700002)(2906002)(5660300002)(41300700001)(83380400001)(86362001)(3450700001)(54906003)(966005)(66946007)(6916009)(6486002)(82960400001)(66556008)(478600001)(6666004)(4326008)(66476007)(316002)(26005)(8676002)(186003)(6512007)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HkIodUZLjV9YALDx8ADLZBIMENo6Nn8jy4vCUpyG6fagLmOPmUCSKS8+l5o/?=
 =?us-ascii?Q?i8dJj2P8mD0zYLsz5F478PnbYmrRB1UPo044ofsgC04iEYwrDZR2LSHp7U9u?=
 =?us-ascii?Q?hjf07Da/TqyCzbUgS6slssiLEbwj0y6m8T6vZ4g9dECryDV/pGWkSg+sKqNP?=
 =?us-ascii?Q?7mwBBkapQC/I7WtACeVJ6sS7XLzCykX23Y7M7c5Dh7HyXgWo8JTfrIb9ws1V?=
 =?us-ascii?Q?Ud4GG2Y46x42QBCokkNYsvM0CZFwMxt6P3J8nquVSOosM01cmbISSLZzeyiO?=
 =?us-ascii?Q?h1D/r5TE/lzkcwEO2c4ougLZP9jpts3n8tKYtezPW7mLO2BvR4TxWFhKDx87?=
 =?us-ascii?Q?IMfBDv+auN5bizx65OaUF6ke4TkpbYPa9wFRIFG+l4WZcpFhh2j4b+I0EZKm?=
 =?us-ascii?Q?FfD0m0e3TIGeGtDUgVHYsFSGiPF/PcSqH/iF510nqc4PB2Xjd3pigNuJZgls?=
 =?us-ascii?Q?o0G80H0BxFf3zrW6Ys+gGGRI8Cs7NhuW+XRwutw/iBViksQyZI1cMTLTDJAM?=
 =?us-ascii?Q?6KIF5K216XnX2B3vJ4EkapqNBqpPiz1XpKouo/zGu1VUFAOt5kuKEPaAZ4Wm?=
 =?us-ascii?Q?Bt/G3I14Bju3ql/7DD+dIZVzm/kG3/N/VCeM0DmKkUPOBgZy4CDUrGZcBe2/?=
 =?us-ascii?Q?Jt5zj7G6K523gffeDVNvuQyXfmaSwDfe53LHGl/33ENL/7VtH7xfD0CsRIN6?=
 =?us-ascii?Q?bWQ5emcXU7xc3lqJulfFSXjgdBs4KflW92nlVQCX68bov51OAqkCav0pJ3G5?=
 =?us-ascii?Q?cZGJ42ECs8CzY1xKlFXrtIzuFFsWCC8Fj5W+2b6WGTSPtF5KmgA3KstDGoQD?=
 =?us-ascii?Q?JKuTU/MJwui1/SJxulvGEb7Ie3XyrukUkvRNvn6VRSe4aRDLDRUeOkTnZSEk?=
 =?us-ascii?Q?M+2Km/89euBdVF+f/h/XxtKsAp24WmUbqaRVEJjO1/PdTsXX95Fo30mk6D4H?=
 =?us-ascii?Q?BNAtPprDctObe6N4d/KCkwzDlut6A54cNcR8/E413ZdDPjGnIc+Y8VNHvYdt?=
 =?us-ascii?Q?pGnSiOZjvVeqLag/X+VoXcs4/0+fUgsgeaF9kk6g+tGcPIQ8O78FsGNFs8PD?=
 =?us-ascii?Q?RFHCLhBWsE5guiMD4hOoH85T9kJL+aT5wraHrgnXKNW0IlugbquDxmP1ady0?=
 =?us-ascii?Q?jZxxSXCGgbuA5xCfBxneZgrp8b/91kcP+dTf2Adg3sgKJw+ivnOF2fzrBwpO?=
 =?us-ascii?Q?F6IkUqnMioS6Ai+b9P9plH6AZGbo4a6sHCKk9eGErCM7CEfPSz8yaC4zKMFV?=
 =?us-ascii?Q?xLDe/tkhaLI3x4o/DCtFi4SXH83NIffEjfwXR7MH/w7ewp5h9cKYCbB/x5ku?=
 =?us-ascii?Q?PpCpZugorban2AxCh5N9/b+/CkcTZGLk+PKll16T2yJPHUKC92qcDKe9l7mA?=
 =?us-ascii?Q?PZhnS31aebnL/thzE0/G2OO5O+ozlZk7Q4NRAUgwLUWjMvgUJjaFNQ0olQRN?=
 =?us-ascii?Q?QSrMYqchszljrYib9Lg63JJyVWYu6FfvEkZKmMx+z487Ia6RGGHMMkS/ahJ9?=
 =?us-ascii?Q?7xsNnR0zUAWAilwb+jfQ0pZhtQjGeDqmPrmcLNiknQa0pBRPwQsN17EyKnMB?=
 =?us-ascii?Q?xSjWX5jc7PiFmhvi1yJWbn4ksKJPNoMnW5uzsAMjAhxepdwOYw5rIsiL/EHO?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf3ccdf-b47a-48bd-37a7-08daeece189a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 03:36:57.1498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: olks6nUL1cDvorkWgJmsoc934iyUWwR8+3Lp7YaBLU5zn56zANYGHdV6OdyjITn35VpRSNULuccxXiNK4EuOPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6149
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

On Wed, Jan 04, 2023 at 01:01:13AM +0000, Sean Christopherson wrote:
> On Fri, Dec 23, 2022, Yan Zhao wrote:
> > On Fri, Dec 23, 2022 at 12:57:12AM +0000, Sean Christopherson wrote:
> > > Fix a variety of found-by-inspection bugs in KVMGT, and overhaul KVM's
> > > page-track APIs to provide a leaner and cleaner interface.  The motivation
> > > for this series is to (significantly) reduce the number of KVM APIs that
> > > KVMGT uses, with a long-term goal of making all kvm_host.h headers
> > > KVM-internal.  That said, I think the cleanup itself is worthwhile,
> > > e.g. KVMGT really shouldn't be touching kvm->mmu_lock.
> > > 
> > > Note!  The KVMGT changes are compile tested only as I don't have the
> > > necessary hardware (AFAIK).  Testing, and lots of it, on the KVMGT side
> > > of things is needed and any help on that front would be much appreciated.
> > hi Sean,
> > Thanks for the patch!
> > Could you also provide the commit id that this series is based on?
> 
> The commit ID is provided in the cover letter:
> 
>   base-commit: 9d75a3251adfbcf444681474511b58042a364863
> 
> Though you might have a hard time finding that commit as it's from an old
> version of kvm/queue that's probably since been force pushed.
> 
> > I applied them on top of latest master branch (6.1.0+,
> > 8395ae05cb5a2e31d36106e8c85efa11cda849be) in repo
> > https://github.com/torvalds/linux.git, yet met some conflicts and I
> > fixed them manually. (patch 11 and patch 25).
> > 
> > A rough test shows that below mutex_init is missing.
> > But even with this fix, I still met guest hang during guest boots up.
> > Will look into it and have a detailed review next week.
> 
> Thanks again for the reviews and testing!  I'll get a v2 out in the next week or
> so (catching up from holidays) and will be more explicit in documenting the base
> version.
That's fine and it's a pleasure to me :)
