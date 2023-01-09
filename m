Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680CA662834
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjAIOPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjAIOPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:15:10 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBBE11C2F
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 06:15:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEDUhHWvQtsBO4SjysyY0prW6IlUDWBXfJAYEzGmQveq9YeNsgM9oCAgMN77w4lW9ksuuoMSGhJenS1Whdkc62vZtlCP2lF7eS2a/aBezcT66i8IXB/nryxKPz23fgfBmUCj33hiU6OD2trWMKOskzIamlUe6mRCIj2Cq1WOPQWQhKlu930tgQVPg0INFX8isIPm5Fy5q5Q1oHfzLM2KGpo8iyoOkNm1pplTkga/7lO3p3u5a5Z8wkGsVA47jyYD+evRWFSaaxYpEtdBaHV/2xoRpO4BNdKw56wxxUoNiODPU6R9v3scJPbJzW2nBQbgFjuTu+wttmfBhqV5odQZFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dte4pCe0Vb+nUAxdE7LelUKSlBdr39arg+xmWnpMwFI=;
 b=YtP5NfpYFDTf0dpeWTgzISbJ+AHBSfUz1SlDdW/vGKR/lAVQe61DqTRgR/mn6nyE5htd4I49DBdYA2lXBNVj5HpljRcjUhL5GsmLQcG0QDS3XBDY/r12y8ZDatkZVUMo5RxkRedtWsSralukRb1Pfz9gHK56P44tXGxegdvL8rQwYYBCMFtsOr3UvJ6SsSAW6VBN9xK0gXzJ4P+6W0yFGEZ0/JxjDQj2rv+jugEp3W89d3K9FL+sePlJHgP/9rUPO0ef/8y8yV7WtTQbD600mQMkvfY8/rd+/0e50c1d7BSE/MIjMTfVVZstZmmt/dcEvn4VAxSuhI2UprmIfMUy/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dte4pCe0Vb+nUAxdE7LelUKSlBdr39arg+xmWnpMwFI=;
 b=PhnB86g57N8c9y6rZplVuiUMfDWDrASuFchVLT9VgQPjeugSurpEJVto6Jchrg0CTt2Fv57o23ZNMRD7bqxgJmohSFVcEXPca6lme4mGn8Khy2XyZm+jh6Hc9NHGpddDrn1rhy1QFsucip9/m8QsYwSQcUZnTjBw5DnAhgXi8srGXyYDSarpRoivbvpf3KbVTUYqgo8Hu/nlwy135suU1oaiW24VTOmR+KXi9SslfihgtfYlgAI8gsLIurZmb3Hm+dDHRhIpAN1bnQeIBzFoV1vDOMTrexb2ZMV73UfNsgL0I2KUnhANIyA410JrE28m+sI8fpySxM/uaQ59C82Orw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 14:14:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 14:14:58 +0000
Date:   Mon, 9 Jan 2023 10:14:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Message-ID: <Y7whYf5/f1ZRRwK1@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-12-yi.l.liu@intel.com>
 <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:236::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 063de3a3-c82a-43d5-428a-08daf24be3d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+CfXgeoKOHObT+IfvBnlXpBfyHlfXBvkbz67ib/lRhzHITZDa9sBahjQqfMwEIriZzdfSe/Fu+yT4jIbQhV28rTuZqZFuuABGjh1PUrreh+krstrkYvsX5uRr9tc3hYajKBwS3jby20/ENUHhybSrttdlqL2glTcMN3uWVuQ22FeJgzBwTVPTl8mEGW9oCoO4yisY+uKhAmcsz2cFXJbXR3b+0ialHhT25aotOZo14g7JAA3zhgWH/kJq6T9eLo++Nn0cwoS3gxI21Ne4t8NejouaolOZKjc06nYpOZ+QHLxFEFdpubVJCv92CcDUcNh0Hb1Kg5P3/3Ew0jVrJJySPJex+72ac8HYy5WxrVnpG5sTg+A97tAMJAKDQARJ6MfpfinKAtmBwdaTGi6ng5MBl4evEUPO3aWkGeBBSvzM1x+8SfFuVCUuOU5/We2yR/tvR0DNHIEHPgJwavy0hJ0sO+WWVNAZNN2svlw9j9I+39heq4f1HiNTmqtwsEs4DfqRubsQw57Lt7Qd5MHrQ5+6rbAirx6oXTMqoF3MwHevGLvS/8yhJm5fGy8+x4wt8TgzgKC5QZ/rDFQPTnKWVdo14IatC6oOglXqgsa6vTOEgZvCLw2RiZtcZOGAM/UWtescRBxXS9yHcGaIZOwfGZ3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(36756003)(8936002)(5660300002)(2906002)(7416002)(41300700001)(316002)(4326008)(66556008)(66476007)(66946007)(8676002)(6916009)(54906003)(186003)(6512007)(38100700002)(26005)(2616005)(83380400001)(86362001)(478600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4XrowE4rQaDKrGRzxyiYdR3fd36NVY0Uglm7BW/3opLONL+yacpT9dbIDrx1?=
 =?us-ascii?Q?dTOn4VtbvCh5bjAEd8sldGj9SnVTCfMJR7Pew5CMUAq2WwHYGwTYvZu/U5FS?=
 =?us-ascii?Q?XHlkJT+WdDWb4KNQJlbhHa1xt15lC2deiLcAeW4yKKHtUI5Frp+OU41FoqyE?=
 =?us-ascii?Q?zTFwWUbKBZGmbweL344t44E+xYer6EQcaN545xDCmaQftm4v7SOpP3vlERzH?=
 =?us-ascii?Q?5Sk+tCi2L2agPgnIz+ciqFOEsbR2sMFyWrp/3HpU72Be8ZC/RPPkV+PWRCJv?=
 =?us-ascii?Q?+AzSQJ+acyv/5itFUNH8QndpUbNDaK0vZNLfg/ehBYedyZOOIZJkPjOtB5v+?=
 =?us-ascii?Q?iEkqyj8MpMHghm4YbFOX76X9o9lVet95fbkMB2H6NbZZpLo2Dm2/DkMrWpcb?=
 =?us-ascii?Q?Iu5ksxiMlbISG0GmzLNoBcAKcF0F8ZMqIWaqtmGXUYHYFLir0POuOKPrGAgW?=
 =?us-ascii?Q?ZbtjS2FN0IFpue/igUuF+cxwkFpI4PgkdaTbWIbeVDpXiqOmzOM1sGuKgUxQ?=
 =?us-ascii?Q?uT2iQ8IQXEoYScG9B5q0HijndN7IZnG/WlYjLV4XkpPPS1OAc0dsLQNC2oBc?=
 =?us-ascii?Q?C9xJZSt8RxQqiZQTZFE4ugYFsewk15iv6CYLbT5fzchgsKDmo9i2rhE7qncC?=
 =?us-ascii?Q?5uK3EotXGHfOFVx98FCDjssqM5881GSoNrB62f5/SS7ZknIsBWbefoEYXuHG?=
 =?us-ascii?Q?YK/imKQqjfVFpIoejhnLDKN4pn/F72CUmOCzBwCaC4cJSRtJbL5ckd+SiuBx?=
 =?us-ascii?Q?7+9rbqxUHYeIDRk4TlJ6C/KtZlXsUt97TCHEyW4LOMG2R9rMNqtGDlrT9FNy?=
 =?us-ascii?Q?KSeg2u7UDvb+nIXme2jSx8KqUwTmiG7wJonjbqeEsrjF43DUL8k6FyqDde5S?=
 =?us-ascii?Q?B+TB8h68kLSkxYyoRvYI1SBGB1Bmy6DC34N2dAFPcE8AiCwXd5ZaXOWkUol5?=
 =?us-ascii?Q?qZr6baSEvqbtP2ZFcgPZ3wPJh7tvfWZqhH1OUrhGUZh4+QpPl/q3Kq2+Z0kh?=
 =?us-ascii?Q?Vn43HTR/L2jp/6hg5JPx/XQmnkAdq896Ubh72YGEjriavxBqqQxiyIqYbXnj?=
 =?us-ascii?Q?cmF/L895JW+IBTWNAYHNTliTIH0NvUDW2kgF3NGbJZyryJ2aRQ/mAsFyJ/3q?=
 =?us-ascii?Q?VUmUm5sHZhOGlvNLTIN/IXptvZWI9X32IQ5IQ9YOUgHITFX5DjDhLk0GZxc3?=
 =?us-ascii?Q?E2qd/vbOBsz6BixgGETTkV1d50px8Qd5oYjdA8MO42zV4zstPViBRS/iZM2G?=
 =?us-ascii?Q?MbU6H9U4eyHWUCHemjX3DaXpZwFvn4s5Ien//qfB4MOoF8FtplO9jSAJg1lS?=
 =?us-ascii?Q?eHzOo+b+wINZvRzSnFeAWY2f1zqrFnpbqtV6Xsn8FJlqa0S3E3zIkHaNDhgW?=
 =?us-ascii?Q?3lsdy2msjazlnoa5vcTpHOEOFi6H6MA2fmlCKu3FN0giwR/O/WKtwp6OQT2Q?=
 =?us-ascii?Q?OShNnvXanDr7aLUrXdizLBAdlrBkjzV0KZAZUIFyWUB4tW9giXXettZcPzVl?=
 =?us-ascii?Q?7McFxlJIRrCN/9ihMOnIxap5CjtNJNnHQz2Wwejczf5GSBMkoGZu4mEUV74s?=
 =?us-ascii?Q?/cf4/OPOMqfZdts6aRWfL8tZuYmCvk2eCY40vB1b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063de3a3-c82a-43d5-428a-08daf24be3d8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 14:14:58.6509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncI3lJLJsfAPkidguv5hWUPszmmmdItB7caFQCuq/gx038MK7jilFPLB5Dho3fSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 07:47:03AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, December 19, 2022 4:47 PM
> > 
> > @@ -415,7 +416,7 @@ static int vfio_device_first_open(struct
> > vfio_device_file *df,
> >  	if (!try_module_get(device->dev->driver->owner))
> >  		return -ENODEV;
> > 
> > -	if (iommufd)
> > +	if (iommufd && !IS_ERR(iommufd))
> >  		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
> >  	else
> >  		ret = vfio_device_group_use_iommu(device);
> 
> can you elaborate how noiommu actually works in the cdev path?

I still need someone to test the noiommu iommufd patch with dpdk, I'll
post it in a minute

For cdev conversion no-iommu should be triggered by passing in -1 for
the iommufd file descriptor to indicate there is no translation. Then
the module parameter and security checks should be done before
allowing the open to succeed with an identity translation in place.

There should be a check that there is no iommu driver controlling the
device as well..

Jason
