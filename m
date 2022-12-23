Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BCB654E60
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 10:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbiLWJ2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 04:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLWJ2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 04:28:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A40237206;
        Fri, 23 Dec 2022 01:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671787726; x=1703323726;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=A45r+fZqSulzcta1a4U/8ZumkyXycFUIKS48jfGr8jc=;
  b=kUzStuxwxkq95z2PH/jYmCGPFB5Y7NSQ7WRqkGbt1SAY12RnzsZufZ02
   ITpkoH2o2m/2EFGNxWNgaV2/Rdyc+kL1btlF/U8w4VhCbrsXIv4fAkc//
   UwFvX3IIr6fiwSwuOlD/KjJEtaw057qJBJYhH5w2Uku5236t9YRif3Tp4
   jffhgtkVqbnV8tIc95lDOQ6VVXYs1ML4D9uIRjVyM+AnAiPwkyMFJS+ab
   R+a9SXxUf/NhU0Vdx9wb2AvhWjpyKrQCR7JYekf8UlRBBKVERBb7kzd2U
   +mJPeUYdk8jVaxkSIU7OjIdb/iZV4JP/hGCsbr+A6mNjnE8oWqrr02KG7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="308018713"
X-IronPort-AV: E=Sophos;i="5.96,268,1665471600"; 
   d="scan'208";a="308018713"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2022 01:28:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="776311168"
X-IronPort-AV: E=Sophos;i="5.96,268,1665471600"; 
   d="scan'208";a="776311168"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 23 Dec 2022 01:28:45 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 23 Dec 2022 01:28:45 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 23 Dec 2022 01:28:45 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 23 Dec 2022 01:28:45 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 23 Dec 2022 01:28:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL7lpl3eAMiN3saqFCdvzpEv5v2EdGsIuiQZF+2pGAx0vJS5u2SlYpimrZZc36l58r0/+jYz67/Hmyp1DsBvRYNWSGdOfWfKzltZYswxCfnmyPHvbMdXCifWcF+Xc1fzdGB8kJGTjK6782updwtFMEGKBeKz+YyD01G+CLZX+FWl6BrskY8HN4cSIYqfVnJKL2Dox/a61OidegiQ6PKxnh9TcI3OQ38mIOl9XdVPAu2/aXFbYgD1nvN3JrGru0YRfiA4yZiPKfPlO0UulJUYTzlomFD7du4hzgAKPlv1DJ2wi72tVY28MVC6xeMRNnWEZFwfup64KDjLW/c051H6sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vY94zKD53p8/MegOCd0700ScIOKpu6e7dVQ8Mfx4xcg=;
 b=Cb0atYQdltruK8717wagF8Ay2kEUHjS62MALebhDpU7zKd9jTwe0LzXcFc1TUSPAkpwq8oMAPcG2P5m81EzGvl95FHFxS2WwY1Fyk9Gd9u3Oo/I8HAKfcHVLZmAaCA/pOIwe00fan3k+moXEpx+vtqjwPYrgyFsaQ93sN6zORuyKpU140a0sqwrHvCCZpdKM4iVqA+KVz0fGQIK7iN/xwaowvcFPE8bK5qGPpKzEya7tQiRUObA60yIbaP9xaf2gIioyZ6W/IaAbNQ9Nuv2YGOMt8ar4ondDVxROGQlEDoLCFVymBLzMGNpnsEjtlamaborhCvGWuCXNQCZi/4jE9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5415.namprd11.prod.outlook.com (2603:10b6:208:315::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 23 Dec
 2022 09:28:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%7]) with mapi id 15.20.5944.006; Fri, 23 Dec 2022
 09:28:40 +0000
Date:   Fri, 23 Dec 2022 17:05:26 +0800
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
Message-ID: <Y6VvVrYURd/an3Zp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221223005739.1295925-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0187.apcprd06.prod.outlook.com (2603:1096:4:1::19)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5415:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eb1eede-b9c6-434d-8488-08dae4c813ff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+dbvzo2E8TG1qVVE2Wp8+w491sGeJ1cnU5qfpF6VzRlVsV3PMvtgK4yhMlHUWwpqa1T1r68JDxTpNZ2FxRyXeKZqAq8oqslbn1hiTqPbG1HYnThsBcuAt0Zu3iROTV3f5tr5fcTTbm2ZqFoWsUmpW4QIwgzndnd2m3xHh8gf0IAxYSM2vCAONNXVEFFfrtplUVV0BZazjfkFlYhgx3+dIrSJ4rOp3cfTGqM6Mlqm1UO9V8CC85ytIrVIx4/RZ9GXfdG+EnZ1UwewO+QIQLuAiaF3/Llt7jgSe6E0Vwu13gI+xplNrJgp3KvKai7B/UNFLCpYb5fdWJZJ0QUZ81Jnh33WYgNomQyJIpogxtA90YWDg4qgn6SlQkRCah3NWl5tXdGh4nxj2mimCL00YYCWLc7B2YnuBch36t6NTaXqiolP+zBzQO6IKMUvnKQ7o6WiNxkrW7fGgwVs5gKk98xvKbQFGVpnH0zivjRgoPcl1qYoObk+ceDsrbfJAPR10Qqklt5S+JnBBN2GvOsla1sgvxpfW+13jKeuOzjwB6qHUetd/FZr1HW/OwlhahXUbjXZhZ5CaifyHEg4/69F2fzm5Q4uOypMpBBAuqVC0DQ5rB4P3pUey5rdXJ3jiKY4Gf4A+pDJnIl3+ppFqcyXqD+TUQdXTpp8D1QOcm5n1rYMb/6xTnRFQhXKc69lQKKUDqu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(8936002)(6512007)(54906003)(6916009)(26005)(41300700001)(186003)(4326008)(66556008)(66476007)(66946007)(8676002)(316002)(86362001)(38100700002)(83380400001)(5660300002)(82960400001)(478600001)(2906002)(6486002)(6506007)(3450700001)(966005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+PQeDjW/fnuIZfDUX1nXeppf8JHgpRv9+ZtgTIn1SoiSvUuSdmfXAZfqOOIc?=
 =?us-ascii?Q?PgX9ET5DCjfDLLfUKjYWsbJ1lLOEWph3iV6tRRFlde1XFfkb7JaBKXleyvlF?=
 =?us-ascii?Q?Knz4Y2brlUZKzzU9+/v9bAjpIPWn2vrVe4sUVPxMOFCXG7gMtLN+vHNefwMB?=
 =?us-ascii?Q?WmrX2i5wbeFvN2xlz5eRFFy0nEqQcrD0sNBl7lcxxsiK0s1r/W6uJ6Kwtpyu?=
 =?us-ascii?Q?rJtGf4Dh1ImTkoqkO6GcEKaq/LfYkeJnW+K5HnC5uLshA/5PVdJrQVKsFw4y?=
 =?us-ascii?Q?Lob9AzKHSqneK8g8M+wNoWEbJx7enDG5YsYUFcn5JxmNREYHUpoDPuGxqP5U?=
 =?us-ascii?Q?vdaOZstR2FZBEW0pwrpbTLaA6kok3OzqtJa17Qc3CRulW1O05lK3GtO/XrHx?=
 =?us-ascii?Q?Qm5/X6TrdFka2WwcazlHB3FCYvJXuLsmTfJOnWD8HmSRVYtRQjhRyMjM2S08?=
 =?us-ascii?Q?C69zhyYMXswmHVmWDBSpVNBVJhzkCCNC+kUpTHR5PdUeJXjR8Q3XMrg28P3G?=
 =?us-ascii?Q?ys/c20Ip47K6E2Iq8/cBlv9O7Zy1DBZsj0Yfcsuj6N1zg0GL+/A/F9RZXTEJ?=
 =?us-ascii?Q?qAgJ8+8EfQX+mruV004oiifALgSJYKUaBt1iHPoua/NILz324P6HGy0sG6SL?=
 =?us-ascii?Q?cfY1snzloBBjlAHgk1x0lXChgSMloOZc7s2DXbjMuD8k9Z2sbmfLykSDkzFG?=
 =?us-ascii?Q?JR669Bz38Y0h+xEHfS+CJVWvorzjMyhshBBF8Cvd0W7qYIdPpsstLGFY+twY?=
 =?us-ascii?Q?yFOFJ6SQxWqygPTJfh0CkaNA+Ejv4lccf8DXzhhAox6fh3WE0TWLk6l5quVJ?=
 =?us-ascii?Q?R9fOC4LcdS4Dkhd37iyqU97noULyJIywNDm1vie1caWPVb66PWg3RFAEgnra?=
 =?us-ascii?Q?FS7gpBQp5idOCTUPzEuxEapsW7OWtQ0OnuZ6zMACzQgSPhwTieU7bgWpWpwU?=
 =?us-ascii?Q?+qibCExN9zPdfn4o0SXbIkwCz8k9yJbP9/bKm9XhyEe9QIlPfYocEh6rK7H3?=
 =?us-ascii?Q?3yVgIvGJ8B8HJaa25cTMpgk6+v4kExD8oTWcNhe+kxkWtczqTWmSEyUTThhY?=
 =?us-ascii?Q?wnkRHbu3FZhfxTxILa4UH3KAvAyxaRUa+bn1DarVJ1ux2ct4nKhXg/MP/j6l?=
 =?us-ascii?Q?LNw/48N2/yIuNTeoPRsstQ67dv1GC2P1DLzWomOzYJEGhNKVX0KC9xBdm7Xf?=
 =?us-ascii?Q?j3H4MQBzoEdrw7polqT5B0fH3j2Tmdfqf2Uhrm+1oAKIl67z/+WTh1rGlSks?=
 =?us-ascii?Q?52/MT1iS6EQ7gy6GHNlnZXIpYu0CM/UHMsS1D77xis+vqBNUwcbfW/J7X/fA?=
 =?us-ascii?Q?kS4PudaHaGYfEcn1W0VSU3CzMnxDt8BAXVei8fDbMMRK3lWiXqDBRZ8WC450?=
 =?us-ascii?Q?Q6vDxzEGWAlI2DnghY+hiNFPGXx1cZzVoAwzWq/yz7MIqT3jM3lnqQW8Qsku?=
 =?us-ascii?Q?iAFq3fur+OQsyonGtHPFpp4S3Y6qvAdVgZz6E61meK1VxzkPkmpIKyqPj/Rb?=
 =?us-ascii?Q?sWzPzToY9VXh0Ihwxn4iFU7CPwqO2mUznMrqo2MCo7b8TOskYPbXZhP9I6dg?=
 =?us-ascii?Q?4lCPKzjwC8FGFnvMjXVQhGhfjDBQpX+m+9yOhoxoQ7SbR/ZMUsr1meNsMxJp?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb1eede-b9c6-434d-8488-08dae4c813ff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 09:28:40.8494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CK86Uytd5vr4+0rko7DYDHVqHJ8iuUGWet7I5z5qMAs6PmlgvFYL8ek71Xs3wrTKrgS/4WJEjUGZCtiyRch3/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5415
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

On Fri, Dec 23, 2022 at 12:57:12AM +0000, Sean Christopherson wrote:
> Fix a variety of found-by-inspection bugs in KVMGT, and overhaul KVM's
> page-track APIs to provide a leaner and cleaner interface.  The motivation
> for this series is to (significantly) reduce the number of KVM APIs that
> KVMGT uses, with a long-term goal of making all kvm_host.h headers
> KVM-internal.  That said, I think the cleanup itself is worthwhile,
> e.g. KVMGT really shouldn't be touching kvm->mmu_lock.
> 
> Note!  The KVMGT changes are compile tested only as I don't have the
> necessary hardware (AFAIK).  Testing, and lots of it, on the KVMGT side
> of things is needed and any help on that front would be much appreciated.
hi Sean,
Thanks for the patch!
Could you also provide the commit id that this series is based on?
I applied them on top of latest master branch (6.1.0+,
8395ae05cb5a2e31d36106e8c85efa11cda849be) in repo
https://github.com/torvalds/linux.git, yet met some conflicts and I
fixed them manually. (patch 11 and patch 25).

A rough test shows that below mutex_init is missing.
But even with this fix, I still met guest hang during guest boots up.
Will look into it and have a detailed review next week.

diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index a7ac2ec00196..c274b6a05555 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -331,6 +331,7 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
        vgpu->id = ret;
        vgpu->sched_ctl.weight = conf->weight;
        mutex_init(&vgpu->vgpu_lock);
+       mutex_init(&vgpu->gfn_lock);
        mutex_init(&vgpu->dmabuf_lock);
        INIT_LIST_HEAD(&vgpu->dmabuf_obj_list_head);
        INIT_RADIX_TREE(&vgpu->page_track_tree, GFP_KERNEL);


Thanks
Yan
