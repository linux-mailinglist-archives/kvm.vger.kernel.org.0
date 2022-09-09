Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0208E5B3F14
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 20:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiIISwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 14:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIISwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 14:52:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86481130D11
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 11:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJkP8jAqGmE67pGiZB0ve3G0ZFLrtc5H5+gSsl4LwNnB2tAuCV1DazB1DGh0PHr53HB79Vx1piXW42DvW5Rm+SzVd/jSG2r2fDYudwFDKszzSqu74TU+8EdsG/aJONmhDkiZEIRM3vIpxCnUsoT5y3MXru7p3E4CnT0Rvx8FyXOkY8OviVIvOP9vEd2+O3jjY9kTBaeFBHiwAunT/oBpFnNpZr0c17fyur6oORNPS7Jtj7Q8lOAKApb02NxpM49lWzo0Sz7ljzyN67zAwyjdkB9pTHI9KUo9nGWCK6iqteuRl4Fvqtj1NlYtGDuIN8sMH8/J5C+kZkA+d138bFJJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EKaKBwgVpnJJ0Cv0tc3TIVv4qJHVIbaqU/VPDpBCTxo=;
 b=QLwM4CkUC/AMT2J95a3Rx9vmpP8jma3MbpRUSVcXbbYgnH2z/Zti0xZm7MYCTiax0j2zNGBm01vzxaBPrd3eKQx1fi3+Ujhmhv0LpxK3lgVGl2FF+FE/MZlukyb5qMcgjlo37iRV4tKF9bEYfwhdw5F3r0ggnwWAY5Cu766bNv/gKfRwH73gPvsJ0jt5kfUqSJ5ZstAX3pd9E3wxpIbNVLWX3BX9/fDO3sUZtF3kNsT2DV4h5dsTocP568v0JvOr/gZpAtq3ro1ZWqpI5HrpmrXrhcVSzm7aLsQJczYGklNUK6T7KmMSo2J4Rhy3EEPQoT/S/P+sB4P4XO+W5NYsYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EKaKBwgVpnJJ0Cv0tc3TIVv4qJHVIbaqU/VPDpBCTxo=;
 b=kVqMAttXllCPFCX7hvrcrlR9+BHPgufsc17YfzEpliCuVL1gURpyTh4lSP0Ai1Eaw529s6J4+1cjujHH3/aSBSOh7+1f4VzixRRYSjEdv6hqkklnUf5LWx1nK7YcaOa4N9m/peSBKSI62UBf6HQFNAjvsfWiNzvWetJZJg1cD4M96LQzDao6RFtRBOB/XgiQMIx+W9eAfW7Yi5GflTHxOAIdnZa5+Qg3dmd5qkoeh2+jMU7qpZSw4hh+WLccoR9Djst94H+quRFP3R3xh4EBfPoJ7txqHVTF7xzM4x1mtW/MmMS9QI94MxvNp5lkzi4qpnE4pZbPIlkiYFJxO04jrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB6687.namprd12.prod.outlook.com (2603:10b6:a03:47a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 18:52:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 18:52:27 +0000
Date:   Fri, 9 Sep 2022 15:52:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 02/13] iommufd: Overview documentation
Message-ID: <YxuLaxIRNsQRmqI5@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <Yxf2Z+wVa8Os02Hp@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxf2Z+wVa8Os02Hp@yekko>
X-ClientProxiedBy: MN2PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:208:234::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB6687:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b325d2-0001-4a7e-9129-08da9294710e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pb9EThHTHcdqVKUaayK3WosTK2jSUgGu2gcZB2tQICga0IQbqYKJBe3ZEDD0U/iDR6hSpyw8dHdySUsU5CRlf5GlAnkcQ3saNc52MvSKw2JD/KRFxZEPx60yM2oGNnQcZLJJZ72avMvSIa4kXaRb4MQzpzLJeaTcHuqD7CzhDCkYA8bJ22i+sMfECIjVPwP/mRfQXkYWJctjtzjuciNNgfhM6SJRa92Ox1wwHeydC6co3XBi9ZyN2AVTlX6zc7OCxjGABhJc7e7G4n05mb5xdXcWTZjWkNtkZrd4jz2YPVofcnn40h/hcfrsrvVZY7Fpmiia/Ot8qWBgR/dbExYgv1H6E/Uj/6e3LSQYmzYoy+bCn3ieCqo/tbnRl46i+/F1IFPuom+ajD2mq9+3mDoN5uksuSh9uL3ksn1gK6w81e/VbdWa7hTQkX4jgzFZN5RqyGEeKUEsq25aNJhvw7aaS5eNN5ALzGH18RUR0hkcpn4/dwirggPJ9WaZTReI52Yv/Vth1yro9XcIqF7hjwVA9voFpcsHmnINAr9vWYg/IB1GJBVy399Q8tFwi1bXIfKeqv/8XIZq6WRRDHSyilwagMkUywYXLZoTlolxF75nRmA4YogWD4beQQn/3c557rocY/qDqIxMh9jhpqCoCtsPznS42CLdZ0JMZbQINDV4QaFJuTybTHngzr3PWVHZ/LONW+3viq88gxynp6Fbf0PRHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(38100700002)(316002)(6916009)(54906003)(186003)(5660300002)(8676002)(2906002)(66556008)(66476007)(8936002)(66946007)(4326008)(2616005)(41300700001)(7416002)(6486002)(478600001)(83380400001)(6506007)(6512007)(26005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mOAcAtptPw2cQjOYzYhAwgmD1Dp2se1bAQygkt8GwKRBma1ixbkxOfnv6MKc?=
 =?us-ascii?Q?PBVcebYjnNcWZt6S+OOIIaCXUqoNqIup9+6YMWYHvlx+tWCIrXuMPcNDJEQi?=
 =?us-ascii?Q?XC3iSYp4iUgXefe6SgbkF02IvBEXqib+k7ORluv5cBZ516ccUZcFGnP0/0qr?=
 =?us-ascii?Q?HUEjRxpXTxJgpql9JJGHUKMD9Y+BGjxm83AenuUdY25v6/t/hVnYUO7FsZTs?=
 =?us-ascii?Q?4uqQWIDESraS13zAk8dyvgsbUzq/Xm+P6iIYiY0Xr+KIs4VAyfUMK1S/BW9I?=
 =?us-ascii?Q?UbmB0M0+6lsNWhD7vzDkwC8vlfbMb0+snJ0GHgHekw2NJlylZvfH5sMpqzcI?=
 =?us-ascii?Q?ThC9RQt3V+sd1doXCpJAsgZRnW3YodMoY3INCQe5YK3H6ip+6bGkWfnOpbIP?=
 =?us-ascii?Q?NNdqQuiiNfjEh4qLIdd3Bwalml/TrCYBvlBTWgJ27w2XX1/dSKrRkpZM5VKm?=
 =?us-ascii?Q?bP9ksOROEmzC1h5R7yNTSQudGNLFSIj7NokZr+YdYXw2b7dyI5BUy1Zb+NdE?=
 =?us-ascii?Q?z7L0MX7pv+BEZYKDS/62uguUfAA/sNe0qoTrr/zSkgAXkCEkUqSltxi48FHI?=
 =?us-ascii?Q?Sz9ODAjkmbyMfbxhR7TRkOBLeCoI1SIXpOLUIxQQh7RVsTdPllWYCljL6qse?=
 =?us-ascii?Q?BpI5gLDhjmtSE+gbwPsEMFrl/HEbYnVlhb6bjV68O2BGi15Qi3k+GTwob4Lr?=
 =?us-ascii?Q?XFawqPEfzL3GSKpLlLvaKGw4BufHONkYr/aj6pqYfZGbPJZMuroAhJY3HJYG?=
 =?us-ascii?Q?Wa6UNabPU2m2dG8Rz4L72EH2DoWnKiGZWd4QDtXvaIquFhdNIRiCUHbGXHZA?=
 =?us-ascii?Q?KqZIVFP037NY1FMqRAhSLmNmwcKvnlds4lv+dDlFzkRaS3OVU7PS60NKkR7/?=
 =?us-ascii?Q?KjXiKPXfUZ+hYb/+mFUOfS7Uw7LIBfKeuGGKEczLZWbsQPFHIvRJzwCu2Fo6?=
 =?us-ascii?Q?e+zqMZ+8QibV3IxFdzTIm/25OHdDifx4BQ5ZrfR3gpB8LdX8mpQxvzAW3k0+?=
 =?us-ascii?Q?EWyhbTj4UpLyFp+EBethtO9JAk/UfuBsXkJfLcs2piqcmZcFKxwteLQeEsB9?=
 =?us-ascii?Q?SXdWEw6NOMWUWRJuGe9gCclNrFn6Fac5SMvfZPPSG2sFQDKRMlkCxQsFKl3G?=
 =?us-ascii?Q?70AfrOFileSVcq6ktcJjQ0fgakox+Cyl+al74dnsX4+gzKapzLeP+geQhfX8?=
 =?us-ascii?Q?Kr13yB+x+6PoCbDiVyyiD4kc0iC75H8Rfl4rnJrnjy+mHNyJ7DeMa0fv+A9n?=
 =?us-ascii?Q?lIfrPIw2+nWU0MN5sGLHshE6jrzrHIDkZ/FwREvVtbxBaXq6PbtVOet+db5p?=
 =?us-ascii?Q?/A4hTsSR0EAfajvYbdQxmRJNEHCU5yZ5Oe6TrjIT+20sLWP/bCXJH+YAOL8Q?=
 =?us-ascii?Q?AUzXZqK3npltohg4kYWVIgMc+AczGGv9invqB8G5iHQvSHmx9bBh63dDiVd1?=
 =?us-ascii?Q?5eKNdOURewIPmDCbP3qeheNd425ve2ExgEqo6grC+4n95S1lQa+RqdRttvXJ?=
 =?us-ascii?Q?IdNqHCEraFx/uxgFSN5sJ1hjRc4nqAZOqVdKThJx/bGGT5UVtJtwAXHRq9mb?=
 =?us-ascii?Q?pmO4/iLfdSXoueYV7+8B1IZOhyRpzmI2U8g1R8sr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b325d2-0001-4a7e-9129-08da9294710e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 18:52:27.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcxZvHx/+SAuoEMdVwgwm4gpGvtNRsigY3OXv/ScSP4+JQK2HW3A1DLqIpMq0F8Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6687
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 11:39:51AM +1000, David Gibson wrote:

> > +expected to deprecate any proprietary IOMMU logic, if existing (e.g.
> 
> I don't thing "propietary" is an accurate description.  Maybe
> "existing" or "bespoke?

How about "internal"

 These drivers are eventually expected to deprecate any internal IOMMU
 logic, if existing (e.g. vfio_iommu_type1.c).

> > +All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
> > +
> > +Linkage between user-visible objects and external kernel datastructures are
> > +reflected by dotted line arrows below, with numbers referring to certain
> 
> I'm a little bit confused by the reference to "dotted line arrows": I
> only see one arrow style in the diagram.

I think this means all the "dashed lines with arrows"

How about "by the directed lines below"

> > +The iopt_pages is the center of the storage and motion of PFNs. Each iopt_pages
> > +represents a logical linear array of full PFNs. PFNs are stored in a tiered
> > +scheme:
> > +
> > + 1) iopt_pages::pinned_pfns xarray
> > + 2) An iommu_domain
> > + 3) The origin of the PFNs, i.e. the userspace pointer
> 
> I can't follow what this "tiered scheme" is describing.

Hum, I'm not sure how to address this.

Is this better?

 1) PFNs that have been "software accessed" stored in theiopt_pages::pinned_pfns
    xarray
 2) PFNs stored inside the IOPTEs accessed through an iommu_domain
 3) The origin of the PFNs, i.e. the userspace VA in a mm_struct

Thanks,
Jason
