Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4568362CF6F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 01:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiKQAVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 19:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiKQAUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 19:20:52 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242AC54B25
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:20:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7J93Ge3IH0ThgtY/CZpkK+uNW1yZDmyOjxMvIwNJuchvMOIl3Knfqo4mHPAv8AmVjwpFTulXRptrHvtSbWUgctIrIbk4lY91zqE8W0hTYc/zcqRSfeW7DumVJoze+H8+74XLAFyVGWsL1v7NrdHlE7fv7wo8EDkRALc20uIV7mqJRBXVx+vtvZbXp+cDKClEOWinuqh13yvuma9S4tV/QFMS/yVmLFLVRccNkSgUc0FXbmzskeJ68lM1B3PDxZ2a5E6w5dm+fKmBafkxEDAII5r6+np71Npy5OWFb8edQIq7MrikgpwVTeNtm4dSY8uHIPqoIaneulb9t61FRlglw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqsmQkgY1u09dQ0Zc65pUFqneie/cT3SZELeTo+/c68=;
 b=ZhUG/AYglrEPO+w1/DFTLX2UEtuAA7hlFyqh+DBkVemKWezZxkpqp8ic07rj08h1EGgDydjLiFVkdmIXn7+xAmQIr+rGHnvsnTz2k60dfbkA1WQWssvMjPANFJauLW7MQlo9RuZ1/J+T+8np+J/sL1GXxE4tRNH6ow8yIlnhHCres75otd3AwWy5B0Nw+5PcxG7JcIED7zPS7KFasr24Pwx5mia9Mvms/XjDaNmBSQuTsr/ycG3b0MVEqT8oS285RGb1kxhAqHDSotZsV2UJP8m95GK1W3gDOJ1CWpM1SXU8drk/dhXZFz2WZaB5jCEFwYdnHl09zZ5WSSvGz9lOrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqsmQkgY1u09dQ0Zc65pUFqneie/cT3SZELeTo+/c68=;
 b=KUt1Sv7O8GsB8WoyfbFyFiclsvf+DndFplmtB7LlUk1uTWeZDlFRCyAV+6+UXjcQibok2s6/m8JWcgq04QjGZ49VxPVmLsKmo/oUlHp2hBBI/CAseTC9zhACytNKahMdyTfaJqR2sT0o/1ZlnWBRG2jXSqBYGzz/eKYNp94BHhHe+GFPzRLzNbhjLkNV/GijxFpcWKrYPStQw3v9cztbr5KXk5szMxrumVLWxYli9evebY4dI2GLSSvK5u36osoWkXIY7HRYkeWXdMnm6Scc6YQmzsGEou/o13/vHjnUxqC/vTs+tG5K6AVoPbv34W9OLLAVfiCWN1ykaR5L8e8yyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5796.namprd12.prod.outlook.com (2603:10b6:8:63::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 00:20:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Thu, 17 Nov 2022
 00:20:40 +0000
Date:   Wed, 16 Nov 2022 20:20:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 06/11] vfio-iommufd: Allow iommufd to be used in place
 of a container fd
Message-ID: <Y3V+V9vxqhabkNcC@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <6-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221116163133.7303b0ed.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116163133.7303b0ed.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:91::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: f7aba110-688f-45a5-ed90-08dac8318f15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsOxhFLNDBr/cYd40UhpVS1QT61Zcz4Z5b3RG355/EA/szPvFKgCLRPFsHCheso6VxPL+D/NlqagahknJN0f//h4CbMpJ0YBOzza5HEH1AVrQQZEIIL4P4YBqWJu5MDNWxKqURa3fxFLDyotnNXMpQ6dkJahj02k/DAi9ugFypEMt97wZJ3nMM8v9uL5E+ORPW+YQNKQz93XwovqyHDqVV09E8HKBSkXOlX1I4gS7fJz0y8iUhRjH2c9eLyTW0nWWolqlcQK+aLfjNOG5071uXEa2RSJDac3TKkpVh5UtWIs3XFyVAhTaPYB8XhePoQRZI7Jrvu4GXlcKI5LJwBvcybYlTQkZWd2C9RbAog6DG6ObaYYhQ/UOKcg+LVZ6KhG3pvNJCHaTSrLqx9vokScLw/nWHeInYjxtzRCPVBCQ4SRqrxO4iUWwnrdJLmhGjq3FsMj8F3+i8kR7JiL52L3AU1w6ogE2rb61z8bHQ6e8Fktk/Oug7m/krVGJa/bD8kn9vEGTkvJx1fBF7SustsRvkvUW1Ak3CRlhGYqebS4pCrzGd4xSVW/adGq8ArNTS7H3pHl62/RFsjvR9HNfSDDKYphhteZfXatF/y3XYCYvRvxVDWuCG4OFeFWkAe9UAkGb5QZEMWuw6LmfxL+DVML9genwOpD0psDEOslAiO6nZazFfFpyqHQr+gTQfwPBzuQXLPzOGa+m1BWBvrJs0iDNSI+p6rqcQyYgBHsL0r2y9N79913m+g9/q5LxHd2aiPz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199015)(2906002)(38100700002)(8936002)(7416002)(5660300002)(478600001)(4326008)(6486002)(6506007)(6512007)(83380400001)(41300700001)(26005)(36756003)(66476007)(66556008)(8676002)(66946007)(54906003)(86362001)(186003)(2616005)(6916009)(316002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V6u3rxny3NnrhuMRtuOKb1F3tQV7iIUP11QSoM09Cggwq7SHAqADSpf3p6J5?=
 =?us-ascii?Q?oeRtam9YpkcXNvp7oG2YClZ8CZdBeAXR4Ezuy+gUV+Hjz91l/+Y72Q+c8Abf?=
 =?us-ascii?Q?EvmAhIzI0ZdX4og84+6w+izC9DipkWqA/TjK9HogKZP/7QNiIqY4wEaVvjSd?=
 =?us-ascii?Q?jUCi7iC1jl/+drsQbaHyh90Dmj0/UDycJ501BuV5w6/LMR2MK5J2aDPA6Cmh?=
 =?us-ascii?Q?4h/K09zxnRs25rhUdyQW8o78/7ZSlXd+N4NBiA49vliHDp9gqB3aH47dAYfh?=
 =?us-ascii?Q?EHdrH3tlXA/W3+RS2o06T//w0iarwcHLARYfFlHcXwnHJgi02DuJxwsTh3dk?=
 =?us-ascii?Q?xzyAIakjxufJUeNHjSvMjBchtQIZA3pA8JNRc26st8Q7ESgoisxbKsHPR78k?=
 =?us-ascii?Q?QJamIYbe+ESWrmMYrIvFGaWWnfd2452Z4t6TM0GqZdF20okUbnO0QeSxN7Yt?=
 =?us-ascii?Q?ps6XupmENf6p11pFt5kBXez+R5jpZjIpf6bve2kpeP8t0DBAr1jaTkYgp0w4?=
 =?us-ascii?Q?IsGfCb2QBgMMmykaBteySrxdY7Oz5xizLLDeLkBV61oE5onEmgont5aRShjE?=
 =?us-ascii?Q?mBDnUxtsaxn6339maxlgGUTODpzEAUnExGGRdK3z42i7upSkh5SgwTtt1OcO?=
 =?us-ascii?Q?hOZKTZs804XVxMXEvEHqG4iYBwRNGHUsXT0gZFLyksSG2H1cTaG0vfpc0i/e?=
 =?us-ascii?Q?enWBd76aTb0tzescRoWxyLEaiLZ5R8gi3si9QweNNQGIPIyhvnFWvFNmtjx2?=
 =?us-ascii?Q?Vog6GHWKXDPR5tXr+nL9y1looAFw97I/5x2m0s3McyY3SciOUifowC656aD0?=
 =?us-ascii?Q?WBq+pYUNOaJt50qwCDGtY+HKVI2Cz5iPdKMTB6WKRnsZh8vjZRvxgMImcyUC?=
 =?us-ascii?Q?qK2VLw1Hr9ZdhyiJ5IXlQtUn7YYobourOc3pP2DqnJxhcYXpCVta4PzgFCLS?=
 =?us-ascii?Q?6QcyYpebbhpd80Fi4AGM6xCbYdu/0EXLhvOa3EtUp6ykkm5p3uwtL3tNGPY+?=
 =?us-ascii?Q?e8iHiS9URt5XBnjTt/uan+6Cxi0HRq64wJGlSaEmGw6/MOp6P5FU3xZ/n62U?=
 =?us-ascii?Q?VqfK3uJeghe93qTOy7oyd0qkWTNolypktfpJ0ryED8rnFla6CWVOoM+bYJG8?=
 =?us-ascii?Q?qsBX4/aja5nFScUzTW2Dz+aNWUlocaZKec1C98vFW2rqvkAdFbZLz4ByVrx1?=
 =?us-ascii?Q?E3kVsVJwLiXh5ykXE51kenfg/HZkurEwOdt/ht0hC3Z+4GU1pPPe0XslzZX9?=
 =?us-ascii?Q?tq1BoPrMPpQ3SKsF0pkFbKPiSSg2xULMMhuEUWxzPdGeFiKlwNT5iFiAbCSD?=
 =?us-ascii?Q?eFtsfFq8I/qgpW+4EHH5PhyiY6RhqpRLu89yCKHdHw1/6KeIMKx8XH10XFrh?=
 =?us-ascii?Q?Z+lXKdzUUtnoC3PUizqVUaJiUEYq8+Cdv+LgPnXypHOnWhAPElH6AfRuY/1Y?=
 =?us-ascii?Q?aX/gFK5IpAGJQ745/Dtb44dCLKVVyvWFzv1BN/tKJLXMibC8sBZ/VMoM43mQ?=
 =?us-ascii?Q?H1VWtmXwTwhLfdcxnouQ1agHcY6pYnGYiC+0i3YGbH+yA877fDxJhODY+Gg5?=
 =?us-ascii?Q?wbVSW80vVuaJe++13jc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7aba110-688f-45a5-ed90-08dac8318f15
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 00:20:40.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKH37K9KUj16QvwLVrTWaLLQXZRe5UFlVOH7zAYROxzj1zBn/RnSWmSVNMKR0Ivw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5796
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 04:31:33PM -0700, Alex Williamson wrote:
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 5c0e810f8b4d08..8c124290ce9f0d 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/interval_tree.h>
> >  #include <linux/iova_bitmap.h>
> > +#include <linux/iommufd.h>
> >  #include "vfio.h"
> >  
> >  #define DRIVER_VERSION	"0.3"
> > @@ -665,6 +666,16 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> >  /*
> >   * VFIO Group fd, /dev/vfio/$GROUP
> >   */
> > +static bool vfio_group_has_iommu(struct vfio_group *group)
> > +{
> > +	lockdep_assert_held(&group->group_lock);
> > +	if (!group->container)
> > +		WARN_ON(group->container_users);
> > +	else
> > +		WARN_ON(!group->container_users);
> 
> I think this is just carrying forward the WARN_ON that gets replaced in
> set_container,

Yes, I've carried this invariant forward through a few series now

> but I don't really see how this bit of paranoia is ever a
> possibility.  

Right, it is an invariant assertion, it should never trigger and we've
never seen it trigger. I think at one point it was harder to see that
this is impossible so an assertion must have been added

> 	WARN_ON(group->container ^ group->container_users);

Ah, this needs a "logical xor" which is a bit obscure. In C I guess
this is the common way to do it:

	/*
	 * There can only be users if there is a container, and if there is a
	 * container there must be users.
	 */
	WARN_ON(!group->container != !group->container_users);

I'm also happy to delete it, not sure it is a valuable invariant.

> > @@ -900,7 +945,14 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
> >  		return -ENODEV;
> >  	}
> >  
> > -	if (group->container)
> > +	/*
> > +	 * With the container FD the iommu_group_claim_dma_owner() is done
> > +	 * during SET_CONTAINER but for IOMMFD this is done during
> > +	 * VFIO_GROUP_GET_DEVICE_FD. Meaning that with iommufd
> > +	 * VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due
> > +	 * to viability.
> > +	 */
> > +	if (group->container || group->iommufd)
> 
> Why didn't this use the vfio_group_has_iommu() helper?  This is only
> skipping the paranoia checks, which aren't currently obvious to me
> anyway.

Yes, it was missed, I fixed it

Thanks,
Jason
