Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B674670D3A9
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 08:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbjEWGNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 02:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjEWGNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 02:13:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78849119;
        Mon, 22 May 2023 23:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684822414; x=1716358414;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ungdmk4jQC/ZFVg29//oZlARrI4jit+81syYN7a0qEM=;
  b=ZVzjD9sbkGn3FjA7U9CVGncfTR98Gvw7//yWOKpOGKqWYOlzs/cmYWiT
   3lZMfM2WayZfMOvVyltAqFPfqXmZgNqBeou+zMz/mgn52/9pQVpYdl+N2
   5qrgWgDBZ5a4bdPB7plhnWPBt4dei4kLAxMUigJVzNbUJdToQ4Pdj/4Ap
   ymKmXCU7fzla1YAE6AEu3ZUPeDbuWwYhYMvmr9TuWJZHnLmuU1CnFpDhE
   REZiJUxJKkXw/m/XJCMgWWP7kEUEwvbAFvQP1JVvyjGB2ZRkMp8WAkaRM
   cnvIhBrimegfxpQp2bjJzPXYExp0tNJlXcG99qdl8HwiTXavPvLV81sQj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="418850169"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="418850169"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 23:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="827964801"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="827964801"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 22 May 2023 23:13:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 23:13:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 23:13:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 23:13:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 23:13:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fos2oTqbtPw2MMrEh2Sv4H7uO4lxTBN6lQA1n75C4qWgpJcZBLDK59ybDb/7CAUjCqC4oHz0bTMNdVzrzioxcVC8anI5TRnHDF1Aitu4WJltRg/OuewE9EAA1/7y4eJJZ1mEGHxXeMtJnxcICmVA3rhLfE9m0pShvVYVBj64+ljxjZftzXQHy9l8R9MxdYrkgiqiS2nCqrg3Hqf54rBA7MvdHpnmythPiLs7iEzHG2n882XZ/0FgdFkyeVF/bHW4pMwzAIxM0Rdi+8yMAPKx0nntyoVNxo3ss6uF0CrJdiRZxFyLtM8jNO68Rm89iIwr01DNjaeiMiKWEK6Hc8y3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzMw34Z9m7qQzH46UlYFTG5g7Sck5NNynIBDSUyGhgQ=;
 b=fkEkKZuC1kLIPBeOuyHeWbc+Nugc00lw+iviCtX8YdAqWmTCBHZ6LQRF355KVTCeE6hFY3FwACA6RLjFpMINUYACNIZ6AUa3LVkERanYDeomalK5nrGadsYicuLS54OCz1VxKm8UgR726AJOGz8i5fP4aKC2cMnlfx77hbfJIyiTiMC41yV+t848VGGWLUT0Vi5x8h/VUMBeS/OLx8Rl4xHteuwdCbVt1dsNRmlFA97r1YDoJm97vN5jnvkSTeOjQQAbvasfUQPwF6kZXMW71p6Q+Jy0Re9v5T+0EX06Hjcyhn4EV0U/s6jN6KY3PEkr6NWDY8a//Qie2Acs+RH9oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14)
 by MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 06:13:31 +0000
Received: from PH7PR11MB5957.namprd11.prod.outlook.com
 ([fe80::c190:aae6:9019:1ac8]) by PH7PR11MB5957.namprd11.prod.outlook.com
 ([fe80::c190:aae6:9019:1ac8%6]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 06:13:30 +0000
Date:   Tue, 23 May 2023 13:48:22 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kevin.tian@intel.com>, <jgg@nvidia.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] vfio/type1: check pfn valid before converting to
 struct page
Message-ID: <ZGxTpo1Zmi54UYFE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230519065843.10653-1-yan.y.zhao@intel.com>
 <20230522130030.44c6c5c2.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230522130030.44c6c5c2.alex.williamson@redhat.com>
X-ClientProxiedBy: SG2PR03CA0106.apcprd03.prod.outlook.com
 (2603:1096:4:7c::34) To PH7PR11MB5957.namprd11.prod.outlook.com
 (2603:10b6:510:1e0::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5957:EE_|MW4PR11MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 51973526-a432-463e-20ec-08db5b54d48b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5kdUve+o2yDOu3xxQsfr3VBv4iVZPTn3tHwYIf1PPeP6orULQkU14dzEXMKtHfORJl3keSzvfImP9J8d4MvSaDUOz7nfUbQB1M585o4kb6CQhOfYCA2zpPpgc+GXU6IYWLUK2KvEMssvoBpco59ZNHUKwhhhccYvxn+qeHymtB4P5Avrn/qrQxL6m9z4CKupLzIH3ExMiKWxu2zOtXbSepiz+UHVX6vCs3zajowdVrA1H2rfdZcwcoPqmj9rPZEdmJQ2R23nRwX2Ha3mM5GLTiEmKYkSbqLC8L0LJLCCHkaPFxLFHW5MeJsB5wouVOLiBec4TFQlFPY2yaLDzVd3zixs/x1dKKt90fPJ+4ogB3A3cZycqGu7Ve96XQQbStM1nUmgO8bikBsammJyzG/DSKLW09Y2mo4u5o5fR/j5d4NPFJiTutNRcSBG7az5YCtsrsDk7gwIZvkwugoGVrlAwMulXaHo+a7jqMyJSQJIWBk33/lx8ylHRTQUNe232i8QgRcZuDD3ePWyRcnt5PPoweeWgU9GorHe9jwihDjuJL1AvjECVXCg06f/5XEnOlH5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5957.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(8936002)(8676002)(5660300002)(83380400001)(186003)(6506007)(6512007)(38100700002)(86362001)(26005)(82960400001)(41300700001)(6486002)(66476007)(66556008)(66946007)(6666004)(316002)(4326008)(6916009)(478600001)(2906002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OoTOHMZXMi9s/fmWZ2bNje/O9btyOJnAv6JX5Z2xvD3KET87+eLasgbp/DAp?=
 =?us-ascii?Q?hEvillUGMysGPVdIKkJn2Kh/vu0dckkAV1KIWS916lHohKokUHR91nnHToj6?=
 =?us-ascii?Q?f9/z42NurHuJZImsxUtu2LE2/8GgidscqyBl8d0CQc2Q4Wl6mvylvpEkA49I?=
 =?us-ascii?Q?9Y1yC4WlImKk74LDDOIsth//SH6qjWs02z56OMhlxFoihsp0AXXsMy8Hhfcl?=
 =?us-ascii?Q?VHM1ZyJF+wH8AW0dGOzSQTV5Ey/s3hKp7/R7ucENAyrl1dJp6XeyW7pe6RGQ?=
 =?us-ascii?Q?jZBrJ8xJzbTJEsMu7lDceedyzMgpXX1HzATjDUA7RJUN/WY2ZJkmkCmAO6wB?=
 =?us-ascii?Q?9+BPGws/xWId7TQKy8RTEaE6jVAoCpCgW7hlEzCjlVUb2mIPkbLxkleIxF5k?=
 =?us-ascii?Q?sygMMR9/ov6fsGA4RZ8Lk/eCT20pC5zC/uCbqR++0bqa5jccjclxkmYh1GkV?=
 =?us-ascii?Q?YwlSmR47dg87XgXldRacr5Dh7JfOtyaoE+GY/gxpBXyxs53RWke/bIIdjxX9?=
 =?us-ascii?Q?Lbo72exY79hsTSj/62bR3m5i7eOPZasurcBNZ4V0jMWFIHztzpIBjK34aYAS?=
 =?us-ascii?Q?Xgb9nYfW94OH7KQUeYpJZFPqojiPQdaPr1RfTZIC3+V5CZ8ohs4hm0/rcXAo?=
 =?us-ascii?Q?vwxln0aoP4723wv0upIgdiSgGFtxFG7Vb4GxfXS9m+n/l1Flg296tzzNUyJb?=
 =?us-ascii?Q?5ekyctwMSCK94+5LjilyyIA1IcYb2FO2zszTkHCg8G9qnqqff8v3Faf5OhgD?=
 =?us-ascii?Q?3hkJsMyhVi6Rox6HzZmoqhrG9/1DDX9kp33SaJrws0LpQ6VCyHIEvsrRBIYY?=
 =?us-ascii?Q?qoqZYsf4qW3ZoXzR1ehuxUtF2x+/dMkmaCwLW655fsCYmWTBD/bCaIXS5t62?=
 =?us-ascii?Q?Kivp4JZgdVn6fN1eJWD+f248rWM1YhYgEWq3un7WlBUS83J3rKBi1LgcluiJ?=
 =?us-ascii?Q?Ma6ZU7hhn8fpE+WhQ0vkc9wHOBfenQQWYVjn62D++XxL2ue6hBfn666/6uEu?=
 =?us-ascii?Q?P/CWRlRozqXM1Y7fEvdKwTLo2JOO+zHy51WHrbkCgdwVB8AA7rb/u9fpaxzg?=
 =?us-ascii?Q?C3ehri8Nsn/yha0YoXcwQfGQ5a4EdkfTEOy8FmaEJcgKTb336AE1UoQEJbJS?=
 =?us-ascii?Q?c4rzLr3UjP5FJICHSBwaWjMtoJQrRxruUOz0HE1aDov+MlpoZ36WB+sVU0Rw?=
 =?us-ascii?Q?a5VOIeS0kV05G1XaY+Wy8OtOYG28MUNzCW3UXbYY3vTFVNktVE/ZZMt+uO7n?=
 =?us-ascii?Q?lZZZCmW44CwljpnteJ+y2/lb7kMag+COQvEkc//DtRgMELmbkUFRWE2CMnmD?=
 =?us-ascii?Q?HuEx39onYWdEMVx0z7ob/gjSNO6C/igh6YqqWtxMJk7Ub2MIN265aCwDXNn6?=
 =?us-ascii?Q?7MBQsbvztODRI2yF9ZsmV/ZM0UGmiO+mmYeMEuFC0jRrjGNHjZwrY4PHEHoc?=
 =?us-ascii?Q?5zPxrVI61JFGIgem91Uuv/OTC7EweEUtroT3OdW0ybVUbvD63G4pw+vBRbST?=
 =?us-ascii?Q?KOjizI/PFYEDW4tKVTC9Trwx9AYR/pqhHsKr29TGfdG0sUbryzhKXFbmdH2H?=
 =?us-ascii?Q?Bm6q1SIhsqmNPaC9pHpmPcTCFFKLSjM8bo/ioVLe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51973526-a432-463e-20ec-08db5b54d48b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5957.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 06:13:30.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWWHkwr+fKgU4gMjxzewsz+REYCEVPD8B6dd0npvtWElMEwkwAui1O1Kpq2Inc/4U9GPiN+IEptJGm8VZ77IAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 01:00:30PM -0600, Alex Williamson wrote:
> On Fri, 19 May 2023 14:58:43 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > Check physical PFN is valid before converting the PFN to a struct page
> > pointer to be returned to caller of vfio_pin_pages().
> > 
> > vfio_pin_pages() pins user pages with contiguous IOVA.
> > If the IOVA of a user page to be pinned belongs to vma of vm_flags
> > VM_PFNMAP, pin_user_pages_remote() will return -EFAULT without returning
> > struct page address for this PFN. This is because usually this kind of PFN
> > (e.g. MMIO PFN) has no valid struct page address associated.
> > Upon this error, vaddr_get_pfns() will obtain the physical PFN directly.
> > 
> > While previously vfio_pin_pages() returns to caller PFN arrays directly,
> > after commit
> > 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()"),
> > PFNs will be converted to "struct page *" unconditionally and therefore
> > the returned "struct page *" array may contain invalid struct page
> > addresses.
> > 
> > Given current in-tree users of vfio_pin_pages() only expect "struct page *
> > returned, check PFN validity and return -EINVAL to let the caller be
> > aware of IOVAs to be pinned containing PFN not able to be returned in
> > "struct page *" array. So that, the caller will not consume the returned
> > pointer (e.g. test PageReserved()) and avoid error like "supervisor read
> > access in kernel mode".
> > 
> > Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> > Cc: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > ---
> > v2: update commit message to explain background/problem clearly. (Sean)
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 493c31de0edb..0620dbe5cca0 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -860,6 +860,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >  		if (ret)
> >  			goto pin_unwind;
> >  
> > +		if (!pfn_valid(phys_pfn)) {
> 
> Why wouldn't we use our is_invalid_reserved_pfn() test here?  Doing
> so would also make it more consistent why we don't need to call
> put_pfn() or rewind accounting for this page.  Thanks,
> 
I actually struggled in choosing is_invalid_reserved_pfn() or
pfn_valid() when writing this patch.

Choosing pfn_valid() is because invalid PFN obviously cannot have
struct page address and it's a bug fix.

While declining reserved pages will have the IOVA range supported by
vfio_pin_pages() even more reduced. So I don't know if there's enough
justification to do so, given that (1) device zone memory usually has
PG_reserved set. (2) vm_normal_page() also contains reserved page.

Thanks
Yan

> 
> > +			ret = -EINVAL;
> > +			goto pin_unwind;
> > +		}
> > +
> >  		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
> >  		if (ret) {
> >  			if (put_pfn(phys_pfn, dma->prot) && do_accounting)
> > 
> > base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
> 
