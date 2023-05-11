Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C26FECA9
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbjEKHWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbjEKHWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:22:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC08AD03;
        Thu, 11 May 2023 00:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789692; x=1715325692;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zPnNF1GH4PL5KsRqDnQlYfS6f3oDWSOaa5SjbEVeBtM=;
  b=h8Z0Yv3OGEs49A4bsK2rZY529qSNfHJA+lTBxSJ1eYqAVfIM1IaT2zZr
   efBmIletjhzCiKHfCFJvFDEBNKNRrkh8MutcMajWWryxGwohqAuVTr70t
   8KzzuZIO+rWd6QgwoFJRNlnxpQKZM0jhlRpLBfWSuldDiM7v7tKSZcph0
   s4ckWo6KFSTXyiR7l6bYSwpDOg0luGS0mdsVjEruiIjYE5b591+QGdH8z
   0w1VSGNgb9DK2eH3hOr/MBjtL47sehp4lP4JVgm7s3Ol2odxVliuMoIek
   hdZziKyqKtMSHyEeX/JinjJ7uC4UWnLRIPW2Ad3xz6/uAy2E0m3XuLBZM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="352627034"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="352627034"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:21:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="769213220"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="769213220"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2023 00:21:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:21:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:21:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 00:21:31 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 00:21:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANEkJ9+98PgGAzYEPWr0c3BvQJPP0Zl0h2LT68U8YkJxz+2fxF4wA+5mFwaDH3potMwu5xDUhj5m8E4gm/i5UyJ/TCUlvc/WqjlcDA/ri9ymcG6+kZwKsLARc2MUoezqXrN/qtumnMvO8YWbV/VX1FeiddWGa14iUUiqay4KAlQG6Izj/g+h2FmRZSPwk+aWgGp05rOM0X3KYFcVydgVXuEISzNdFfqx02l8fT60/WbswVsnM4evObgGCKJaVnpRTXOiBrtMBkYF3Q6ji9fI/mfvB7uxDWdWkXYd6KhKDMXI+1nMyjOsRF+qulsvGi0rymr/seCH3jnvSCGfxm5Buw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUwRK6Lc+jWuegZy57aVVmynE2Dr9XvnoRHilQYaEWU=;
 b=B3jfYKfJ8rqcXx1NexhoXdJFIQ2xLl4zWvFmtDeEPOEuu0BfiG1u7R0EiiTdTBuAnkNoAd3EpfO/TYxN3SJroJDYNNU+WDnUeHrpYCnzLbkQUBzxSSUt4V2GspdeA5JeOSjT/R8yqCwPeZLbYQVvR21xXth4NGxPCYEDZzs5pp6AOBBLbSi9VCsoGWeebhT20nGuJz7wbwUhLY5tkVWdA8TWocMn8NDas+JcUWq3agOR7eDQpfdwNZSzUeFX8h/+5exr8g9BXO/5beMM8HTJ3c7f/8/CDJglh4aWDrJNKUuv/q5YMXdAgKMi2tDvkQx4eUJUyzHlrRRx9GnLO6fV7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6942.namprd11.prod.outlook.com (2603:10b6:806:2bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Thu, 11 May
 2023 07:21:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 07:21:29 +0000
Date:   Thu, 11 May 2023 14:56:22 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kevin.tian@intel.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <ZFyRlnXmEy6Enk4w@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <ZFkn3q45RUJXMS+P@nvidia.com>
 <20230508145715.630fe3ae.alex.williamson@redhat.com>
 <ZFwBYtjL1V0r5WW3@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFwBYtjL1V0r5WW3@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0131.apcprd02.prod.outlook.com
 (2603:1096:4:188::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6942:EE_
X-MS-Office365-Filtering-Correlation-Id: f471657e-4cea-4da9-aeac-08db51f0564b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ky9E12KiFqKiDy5ljsKzxhQ4oBG6qRmXary+OXXQrzTLVkMZ0fJ1AJnhgU9hCkkRlODlIVD1llY1ALNPlvUuJ7lV2DARtGy7xiAX2mEh/5NGjWSxe7svBEzlvyQXlZ8Fgyq+Ysw/hcszaqgYg60ehDdYejmQVZyEaXP21x6QSnJnIiAFAmJfeRjeOxOqIbQasFnxZ/b/gFq1gGTADh2VCUG0Hy/vK9BI206dLwrjRvOOKp58JQ3X3Q3Pu2XZpW+8f6G19DLomLAHEGW4u1Vyl/iBDabJnOXXPlGDkfMVkss7zafqIaTPnKy2nq+wzDx7DZudLHt0RjM//2JMzccO4INDqPbOBSdSy+I9ye4u1iixfjGPSHE0cOluG8DjoNcS2XHuEYOq7jRmp15OIS16UZ1kJQAXwUPJ1I9iss2I4QcWtnuZ9If7frKJ6ay6U/NNn1wqQf5Ol+K/PmkfJ/pmnivdRY9rOmd1vuNo2ewp9K00VTScYtKCknGRKWBOpGqBxaTdgWqWOC2pv/nYkFFn4HdDOdW+3RtfcUgyxMIrR2o/d/2UBsMaQRfh2CyxfEIT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199021)(66476007)(5660300002)(3450700001)(8936002)(2906002)(4326008)(66556008)(6916009)(316002)(8676002)(54906003)(478600001)(66946007)(41300700001)(6666004)(6486002)(6506007)(6512007)(186003)(82960400001)(83380400001)(26005)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b7kDvM1d5xm+SEtpwHy0DKOdeQVBX5to/m9QNC28UWnD2BwIBn2SHRDOi0Gt?=
 =?us-ascii?Q?Y2IH16g0HGjrfwdyO/LwMeUou4GE6uz786pqGr0k48OBRmqeHrjvG7v3n6gg?=
 =?us-ascii?Q?vFqdlIRofhazI+vsOP3nfCXsonJmpvnc+1GdOSvLHPpttMeoyUlch0XtedGJ?=
 =?us-ascii?Q?i2nTvEmjUi2QVVxfEBk9Mn2wbnbaGTiX0zQq1G+x91BRewQkOl+Rtzjcty75?=
 =?us-ascii?Q?BtfxqoAAcnFBsvyMti13El8NqXezby//63rFYpEYg++YfXRiJieP9R6OAT4U?=
 =?us-ascii?Q?rpVvIbN8fErJmUrv49NNzx9UZ3Fmr4ZSpFP6c3lahppAMQ9uO8woDssCcIQJ?=
 =?us-ascii?Q?rpl6elaqHnaCBfRz90EqQPu2K2cNxO2CxJcEzkcPv4tiqXPznclpm2cTAi74?=
 =?us-ascii?Q?iY4k5iC76xmYn2m+VCZaTr3U793hzMrfTDJb+BVYS2GKa6vx67iCltRzVJC8?=
 =?us-ascii?Q?QeRUJvRjKNFRevYERHmnGK3chNYUg1MffZiy1FjmgYMCDPrHINQwkW5MUnFf?=
 =?us-ascii?Q?t3lcye1AAThkk7oOodmaVI7hxNScaHpb7zLacn0gLzwTsQ+z9ME9/PZJXbxD?=
 =?us-ascii?Q?VILvcCa7wTnbSXoGPlRqse79iag3qYnAlrQXtnWEwKJMei/hTA6mlyttfLYZ?=
 =?us-ascii?Q?4nXeuJHvY5kNsdLnTZe9Nt//hO6uvrXdt03XTA5nPhCMVbq09ZJhxAZpTGUJ?=
 =?us-ascii?Q?m4VhRl4evbA6whkfaGMk/3EF8caurPr0t8AtChwT8bzMf0gm6BPJHv8DoIJw?=
 =?us-ascii?Q?u/c4Aieex7ii1w/3a1DIyzs/gB4iWDF6b0Nn5AEaRRd0obNRR9K/3RhhgAoS?=
 =?us-ascii?Q?Mebjgfi7YSPThVFL72/AVYA6CXJehGJm5yT6hsbajE3eMfXsXDJ9IIloQTaQ?=
 =?us-ascii?Q?/W+hE+CAbeBEH0v65PnembSx7QSKBRyqWBjLq7QY7XVsKePdck/EtjrhhaTv?=
 =?us-ascii?Q?nBV54eTTCNn6XpyckKWwwZ4tvBD22qFDWbNtReR3Qgt+g37BDqE0WQgHsvv4?=
 =?us-ascii?Q?yuvZNi3QPGm8Vcx3cbPE/wbDs+WgJiKGGW/clp/HxiWTwdhS6J9yk8N9eWHY?=
 =?us-ascii?Q?qiGNkHJb0+nHzGVlNOFgTzDQ6awPvBIfGrqNvcj7PeLp+gImrMY5rYqwLtQ3?=
 =?us-ascii?Q?7uJUeyadRRlU+xkl5iZyxcywCy7Qhn+iOZx/mOzKYkSi8Volx0cXgyd3Y8AA?=
 =?us-ascii?Q?2ibI/0WJqOl7OBsHQ+nw4vMK5hVdoT6MVy4MUiSE9dFSlNSgfZo/Pxo5CRhk?=
 =?us-ascii?Q?b5/9+ElzUr+iZrh8GoIlZy1smBSZ9DwKQtsvxHBVGsV7vAfxqgG2wgqtRQC0?=
 =?us-ascii?Q?v4tsC8Mq/5+GqzIn/lwebXYgacKKocAqtYLR+Rc33LxbSWAjfsjj1dvtlOoB?=
 =?us-ascii?Q?oovPl1rEsu4Ge8/kKS7TOei15aN3o0Yrb/hPfxWSppDiKaD0Swo/PB4Nq0KW?=
 =?us-ascii?Q?zt+qrFk5ED1Rf4PkyqgD8/dM3PdyE7NB6BaeGW8o8Snaju11oUZpdg+ZgI0/?=
 =?us-ascii?Q?+Q0IMAdPcrqXZQC8OK5JAYprauGsSDdXz5i64b788ew5Dk7hiGzJ2DpSjd+2?=
 =?us-ascii?Q?y6wUG+HNgREpQ6g6Vm3a6snf5G8YRjWInZMCglLc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f471657e-4cea-4da9-aeac-08db51f0564b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 07:21:28.8460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxj5gvGBcQiSlqVCepGeGVB7kdalMVr58/vKTml0PgZfYgdBFXX2IDDsnDF93jSn+jU+5/4P2sL0cHOA12qt7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6942
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 05:41:06PM -0300, Jason Gunthorpe wrote:
> On Mon, May 08, 2023 at 02:57:15PM -0600, Alex Williamson wrote:
> 
> > We already try to set the flags in advance, but there are some
> > architectural flags like VM_PAT that make that tricky.  Cedric has been
> > looking at inserting individual pages with vmf_insert_pfn(), but that
> > incurs a lot more faults and therefore latency vs remapping the entire
> > vma on fault.  I'm not convinced that we shouldn't just attempt to
> > remove the fault handler entirely, but I haven't tried it yet to know
> > what gotchas are down that path.  Thanks,
> 
> I thought we did it like this because there were races otherwise with
> PTE insertion and zapping? I don't remember well anymore.
> 
> I vaugely remember the address_space conversion might help remove the
> fault handler?
>
What about calling vmf_insert_pfn() in bulk as below?
And what is address_space conversion?


diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..1476e537f593 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1686,6 +1686,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
        struct vfio_pci_core_device *vdev = vma->vm_private_data;
        struct vfio_pci_mmap_vma *mmap_vma;
        vm_fault_t ret = VM_FAULT_NOPAGE;
+       unsigned long base_pfn, offset, i;

        mutex_lock(&vdev->vma_lock);
        down_read(&vdev->memory_lock);
@@ -1710,12 +1711,15 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
                        goto up_out;
        }

-       if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-                              vma->vm_end - vma->vm_start,
-                              vma->vm_page_prot)) {
-               ret = VM_FAULT_SIGBUS;
-               zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
-               goto up_out;
+       base_pfn = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
+       base_pfn += vma->vm_pgoff;
+       for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE) {
+               offset = (i - vma->vm_start) >> PAGE_SHIFT;
+               ret = vmf_insert_pfn(vma, i, base_pfn + offset);
+               if (ret != VM_FAULT_NOPAGE) {
+                       zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+                       goto up_out;
+               }
        }

        if (__vfio_pci_add_vma(vdev, vma)) {

