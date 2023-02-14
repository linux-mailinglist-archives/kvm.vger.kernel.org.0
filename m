Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB56971C7
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 00:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjBNXZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 18:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjBNXZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 18:25:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2198112F19;
        Tue, 14 Feb 2023 15:25:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/zPofueFtAHvXR4dcLP+Xchpl9CAqwtMgGfiVtXIj7DqTmPtBG5LJMKJ/DiC8LQI4/OLfxX1rrdQxNbHNv0RGNPx0f1B/IP7A4wxbND7O8Bg/fys3FDTsbM/iwkUxZPPXHbBMhCAiPwLp0Na+rTSloTW0Zuyvsyj+Fl+cxYNeCO46IE/O4eq9cTqzYbxiobvBSlRBbxh8KoDTWd3H3gbRWqGnrTnVIbLmCjzPNcvW9Ij0b3KfdcfSeois9Id81svR7GljxP/y4A7YzDHTlO74nGiqtDJYAbxgQBFqU4JKWHcLDDnYMxg7KJuw2KMnGJg0QK0HdvD4MHRTw1q0/yIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYV0j875FIgx84L/glqkjYlCXnIV088yIK2lb2ndl9A=;
 b=j5fNQzpq85TJeRY4tjRMGuZ7nMUpvtFD6s/5MLGfkm1UxcctEwl8+IbCLds1cki1/g5Eqz4MJ+t+TVeogn9dtnVoLANENPpG0dMsT/75iFRZmSOZlyOwWFN7GfWwbs84bHV3xdUJ+B09mzArXL1xyOGcHe/OuXU54zrROCfQgboJ0Hni2FAqzz6WPCxxCHInzwGs3PXF+qZPprG+FCvQhsq3uXKm7uHx8gHBSgPCoP7t1SkWh+GKxrNGNI4zUk0ObTBHsXNDJa2tq1nN7De6Bj3bupO85T3ckx7hITI9MJ2l5t/hGztxmya0jYUNek3bf4JhiHorXOjj2TqNGYww/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYV0j875FIgx84L/glqkjYlCXnIV088yIK2lb2ndl9A=;
 b=pZ7+hEelqjQpOFRzO0ZlyGZ5pM6dIMD995wJJxrwn+tozc4fbCmqW43jywXuktFGSE8KAnVQ6Ebj+s5V4ouoEOZCOLjlf5CoXOxtfTMXaCQyz06jVfzdJnWpuULcMpPAkVhGm6Kn9AXUndjGDEcK2jXuiJbqNKsOzUbRoqgDl7DGSrGOXOSaJ66t5cgmmodHyXkxz9rUZkTKC/LQRRudJZ+d/I+qcdrPmIqtgT+uG6wYfche0PzzH9UHEzsqBQz2iTByPSRxFNS966RCsFbFjyaXbb078pC1Vy2UPrE9LfVvgR8zHjazBhthH0QfLVV+8RfFq2HG3v+mkzNE+qE99Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 23:25:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 23:25:21 +0000
Date:   Tue, 14 Feb 2023 19:25:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y+wYX34sPvPQmGSr@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-6-yi.l.liu@intel.com>
 <20230214152627.3a399523.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214152627.3a399523.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:207:3d::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: ea66af39-3561-4593-f5a7-08db0ee2bd7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: piY0gMNEX6Hp1GBXHNfTBd3/SI+PruU+lXQuxiWtef2LuxG8t+j8ZrhtCuT/dLktZd54gRywFC10J4YJdMuF77rkqc+L2SNKnuCsAmZoebMSubzsSX8N2/C5/KHMp1HZTFHBk2oxEKJwqtnXIT3R8gvrAM9CC9cvhPMdHxDJtk5iMtV2hZzFanCAzcHki11kbndKj7Tj2f8uDjo2sOhiUIqxtDt0xTb37uDQUGJssPTlCydJZXqhGrcprlypG2iWHekQmq9zmJ4bA76moAU8Sa5kTti+n02BQXuPvjeECWKtqSf0TRpgzrF2TK2mcqwoOlde5z4XOliZd1W40ERwLGp9n7U7ZMCuocq3Q10qVzuS/bD0hp0Wv+nBQ9UmTdr3dz/mhRlj4LkLaZ/mgwJ1CjhUz1Lvo9WgSVMuZCJYFgZBbWq30AOx6oAZR8FMxuBz5Kd99ywM+PluFzRsNpLQTtYFvFVh8iyMhCAIWVE4ELFz8PvQNK0eAQdQUP+XY085EBzK0G3r3x+HEbumiLGG/pbQ08J9xFp46LNjyXM3uIIggQw/uJQD6xFn45I8M/H3pqGhoWDjqKI0O0btTEVFC77I28lW6bo30SdsUXyHkyS72T759U0KcrmySW+7OTsMTFz9EuiHOxQDYrI7do9ZWO+iglDjqd56g28Gs0ch0cWKrNj4R6K3KPUtUzSXbcyW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199018)(36756003)(2616005)(83380400001)(38100700002)(316002)(41300700001)(5660300002)(4326008)(7416002)(8936002)(2906002)(6512007)(26005)(6506007)(186003)(8676002)(86362001)(6486002)(6916009)(66946007)(66556008)(66476007)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68C8e/nRtgMDdzHof9HIez3/QSHvsrB6MiSfgsn/VXbMQadsrZmkm4NUiebz?=
 =?us-ascii?Q?d16cqQk9o8NHN1IN4mVhbP+96R9jy6w7rDt4mfLdAcuM/t3bJlM17BOWm63i?=
 =?us-ascii?Q?UeHp2UjJTxhwoeZ0uBDsS/JlrMDjHsPPBQVaFdu2lz6yJiM3EYS9r4oYiKzW?=
 =?us-ascii?Q?xZ1d5w/dLwmJxJ2jeCa6SHsRxTUdfsie6CUnLifAnJSJF1OAe/iE9HbOE3YM?=
 =?us-ascii?Q?L54oJUOLONqpTPeYumFX/BLfYu8R2f8h/p7WbHTCRIAVgSsDIsTjg9y8Cy2E?=
 =?us-ascii?Q?j9+MeLIWmpZBnjUtdsGVxxiJCiE5vEtq+hB2wkvbnEIrUmFxuuwB4WYsrLns?=
 =?us-ascii?Q?jIjN5/UnfJs3pRdWdDR/5uUza0oSLcO0wy2/yzcb1UDBVzBDV/yiQQsIlJOI?=
 =?us-ascii?Q?QnAA+8ZDHY2thnbJK7VRIK4qhy40rga99TVBpdQVl7uY8aHLtdl51aOzjO5B?=
 =?us-ascii?Q?n0V/tUhYg78CAedxFhk4D/DW0aR4rLrCpQvRoO7OAmpJ8uQjiltQ/HCeg1KD?=
 =?us-ascii?Q?7PmeMOxEN++ncSb+7WtT+XzRajlUd73EnWhYvcHsqr9yqVBhhSKHUMTAsMUH?=
 =?us-ascii?Q?dBIG9ae5W9YLXsgtWoGoUL/IhaoILm1SBrnNiSCcjA+IWl589FgmPy+8Dei6?=
 =?us-ascii?Q?tAyiuV7lJKTpnkBJ09HvdasmwV4cDsxZBnKChbo6p5iqVrV6IX0vpx2du4AS?=
 =?us-ascii?Q?p4hbpq5Y6D5Q8LibnRYG6Clx628qROMccaApjYs2wCHgwUK4SER1byeMjRVE?=
 =?us-ascii?Q?rZODGo7DYgV73C8wumBwBz2ySV9Bl+aKLvcAo9gVzBlivOAD+Z0LSRupahpu?=
 =?us-ascii?Q?Neuu/obi3F2lodUWmowL/Bg8xjgghy6H+hSTB53quNQlYOp1VXLbPokV4fVR?=
 =?us-ascii?Q?ebi4/ZVXisLmkwU8eVC0g55VrilJ+YTtk53rSEIh0rfB5U4jSM5MyPUzNHo0?=
 =?us-ascii?Q?Q9gUgLHfAG+T3X9fEMoXMt2FbOzRWjb+TaKk8ipluw5rloCoOUJME7c8krO7?=
 =?us-ascii?Q?sZCKkiOc6HeAbVZT7BR6d7cqh96xCiwc8TTmLnBIKUOWvAw8q3HeZaG6LcAF?=
 =?us-ascii?Q?rPpM3rSEWi34Fq/9qPivnhLGnjtRjiOuGVVjSMVcdf0kutvIXlIZFfCWqHHj?=
 =?us-ascii?Q?wT9ydnXdYpafwaSKJ/6N6lpsn8FnCzH/IN7Htu6hU5GkAOjafoJrH1z4KmQw?=
 =?us-ascii?Q?rlt6E3CcnKh/yGnkBAHompz8LDzBhMsY/os/zSq6FvCLOpunvFgZHrwondIv?=
 =?us-ascii?Q?deFQrJ551hC2poSVUU8y9IUhwhXX0o8/ZUd8ZWGPQ+LFOEJw8r3GDsr/shYo?=
 =?us-ascii?Q?WtP1fgTMiZ5E60lVC3Bzx9JYldN66eAoQ4d2GEYjOanhAuEEvF00COKnoLU5?=
 =?us-ascii?Q?Pb9W2fw/VizH837uJrEWPA5kaPoNzy+aMzAql8Vz5AeJdJSWxoiHPPQn2id0?=
 =?us-ascii?Q?oOcDjlYkrU1lScRVG4bZ2DuasehXTqPmAVPe9BnR0WQrV0NmIMjmocc+kjaB?=
 =?us-ascii?Q?AtGjvBuxZTFKHr0p4SUzVnpCjnk7efUKHnaJVeOTNM1yTWCmXZz4l4cobA7j?=
 =?us-ascii?Q?g8oITEyjKWjmfXD+TOl1HN2A5Tn6X2ndNbb2i3m+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea66af39-3561-4593-f5a7-08db0ee2bd7e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 23:25:20.9231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /oDt4r4s6faqcAQiGB0ZIQYMnXx1NQMi52tswsGqz2d4OjzlgdpigIRJH8pJpoMS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 03:26:27PM -0700, Alex Williamson wrote:
> > index 857d6ba349e1..d869913baafd 100644
> > --- a/virt/kvm/vfio.c
> > +++ b/virt/kvm/vfio.c
> > @@ -286,18 +286,18 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
> >  	int32_t fd;
> >  
> >  	switch (attr) {
> > -	case KVM_DEV_VFIO_GROUP_ADD:
> > +	case KVM_DEV_VFIO_FILE_ADD:
> >  		if (get_user(fd, argp))
> >  			return -EFAULT;
> >  		return kvm_vfio_file_add(dev, fd);
> >  
> > -	case KVM_DEV_VFIO_GROUP_DEL:
> > +	case KVM_DEV_VFIO_FILE_DEL:
> >  		if (get_user(fd, argp))
> >  			return -EFAULT;
> >  		return kvm_vfio_file_del(dev, fd);
> >  
> >  #ifdef CONFIG_SPAPR_TCE_IOMMU
> > -	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
> > +	case KVM_DEV_VFIO_FILE_SET_SPAPR_TCE:
> >  		return kvm_vfio_file_set_spapr_tce(dev, arg);
> 
> I don't see that the SPAPR code is so easily fungible to a device
> file descriptor.  The kvm_vfio_spapr_tce data structure includes a
> groupfd, which is required to match a groupfd on the file_list.  So
> a SPAPR user cannot pass a cdev via FILE_ADD if they intend to use
> this TCE code.

SPAPR cannot use cdev at all, cdev mode only works with iommufd.

So with my other remark about blocking unbound cdevs, in SPAPR mode
you can never open a cdev and make it bound thus
kvm_vfio_file_iommu_group() and others will return NULL always for
cdev.

Thus AFAICT this is all fine.

Yi, you should also add some kconfig stuff to ensure that SPAPR always
has the group interface compiled in.

> That also makes me wonder what we're really gaining in forcing this
> generalization from group to file.  

I think it is just less code overall. Otherwise we need to needlessly
double quite a lot of stuff, rather pointlessly, IMHO.

I'm still thinking about proposing to just delete all this SPAPR
stuff. Power still hasn't had the patches applied to make it work
again so it seems to all be dead.

Jason
