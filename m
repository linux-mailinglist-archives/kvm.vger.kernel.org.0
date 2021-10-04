Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D7421A2E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbhJDWif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:38:35 -0400
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:61568
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236525AbhJDWid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 18:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwnOkvJkT5CP29/x/c0L6YuDm8vkc2Mlk+CGcnTHQEgxTAiwG7ZoT8DYoT/z7fBkbc4Lgzckbannws7I+qSQf79N1Ccyvnjt69TO66qMJHNqYnJyTdq279wrGPaeOf7JtDp4bE0Vj4PAk009INO1V9oy2hK7qK6eu3n7zaKn3cagA1OCvHNiZk4I98gwVuoX9L9e8PycwpJk6SxEVdulBWK6TIrewPRLbFfGUNhCCaf9eIqweC5axqaV7QLv5dl6H4+3zkTTgWNUAaYg1Uw/u7D7LT5KpILVLn+IB6nqzglUSBXJY7wkF41aCUVnHX2LavOBioNjeb7D9pvEPujKkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7PqFPO5HVUHX6gL5JMlFomTGMBJpcKgg87kr2i6F98=;
 b=Y4tD6UFZyza0MZuP/b2YeMnP3BOSUnc+C8xR2sp1hHtfF+3ZIM/2ZZeVGRK9WkGq4zK1R2BWHhJPoN8muC2a3QOQX3gyd2NLlxUi+7gATQIzLVGec5AtL11Ub6pnPMKuQxT5jjn4ZdRAkinOUEjsjGm7HGkk+ManbgwP9P96fRxwn3C0TPR6oTDTJydFmXh1gYtQ66vJUlnbcSJvivwP7MiQvp4PlK8bP8RPuykbObdUnezoiOELmTABc2kHOcW16v5ynTDogLZmYPS4UYSgz7CglrXEW1tgsXGbZbfZZgSuMWZc0n7lfBUhIgiiY7nB4e/hn22XSQIQ7u0CxUyxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7PqFPO5HVUHX6gL5JMlFomTGMBJpcKgg87kr2i6F98=;
 b=rs2GVrzSphO5hHL128GXo7+3foG+bGM6r7C1FWKAVPA+ObCoiz+j3afkny33V5OAREtdrdfFA641zdnZiyQNHeruCIdPi3w3HlOLn4DsKF+GL0vcwYrVQo8HhKCqJV9VCGb05/mLzTcxwRNCyjazaITxB44yzns8drDJmPGahILicZPto1hYEPhfSfJnnNR2Ak3R/o57ogTDrLMKnU1F9CmvwM/rIDp8mUi1Q9YP7vpwkfd90PD9lAMMgmC/SHJkmV2P4xyOxzvmuD7Y9EBGOY1gnRbb5uqgWLHmewdUF51B3D08CC+hbl443XLdlmNTKtomzVYOxFrU0HemdKkYgA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Mon, 4 Oct
 2021 22:36:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 22:36:42 +0000
Date:   Mon, 4 Oct 2021 19:36:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 3/5] vfio: Don't leak a group reference if the group
 already exists
Message-ID: <20211004223641.GO964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <3-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <20211004162543.0fff3a96.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004162543.0fff3a96.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:208:2be::11) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0186.namprd13.prod.outlook.com (2603:10b6:208:2be::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Mon, 4 Oct 2021 22:36:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXWZd-00ArQH-CH; Mon, 04 Oct 2021 19:36:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1afb3565-e569-441e-e84a-08d987877040
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51743766591C8C57AE2A8A42C2AE9@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8GLE3Yi5wBSMSsjRlAiIKislDnd/qDcMT6NB9R6Js2/V0qZSxordc96HoyvP+GpsTsgtB8N6/hbd44yXh1f/WTiJsVSbRBlu1QgKPiKqB/wbjgJNCr5Ju0bfT6edloCKxnGC7w8YGSgH5N5eYaDqzUxtg4o5HLmLto+NtBMtHBE/1O4ifrrDHbAtgH6ZTa9M0x3tX7bIrOg2uq9oy4c7mf8rMvwHzi48b3+n/VrE+Q6bDLJtC7GbbyWw1RWTaOkpNDreEFvOvFh4d9Nmlr+NT4GsAJ9CF3vHsrFFFP05DESINPMD1hXpWu1kL4IG271+NUri3jnrIwwf3gTrlD1JVDZn5nIEQ17O7CPSvT9uk123a8nD3EORikVVC9arXEVgp/v8F5tKuqd1tOswniEjzUAE8Fimr4R9NDzEtNhNZkAbVymyT3W+5jtQRYcNYs5DRn3NLFslaeO22ZhrsqcdzBwu4rcV4unw161kzbtkTMh7R97rz9IRW3+cGF7GbT2gSrI/S+WikqGaP6YNKXc9xYpUquJYCJ9gT5cTQHoLDLF0IIjy23MG0pW6usgOMp/2qMj90IciK9OvSZTDuvJ35umg06K6dqvyP3FH83BR8TNu/dyKb/d6S5J+1NEfli1hMeuPfRvkjSg1mLRAl8tPtnAEF7FfEtwQOJZ5kdIaK7wqECqqdIEfL/iP9CdMy7Qy17ticxe6mysJdkD+UAfPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(26005)(8936002)(4326008)(2906002)(1076003)(316002)(2616005)(54906003)(6916009)(66556008)(8676002)(426003)(83380400001)(186003)(9786002)(9746002)(5660300002)(36756003)(33656002)(86362001)(38100700002)(508600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c8V1kJf8fKu3KX4EZem+lWVy9MEFEP2tZzwcFd3qaG6w+8XzAAo8oBEJ9yoT?=
 =?us-ascii?Q?10gfmGRJUMYf56kb7uYibcI2IPWurCkoILPfBWq1UsEOY/BISeKFYllVDxJm?=
 =?us-ascii?Q?HK/AT+aT3shEemxvNXynOnmJPtrDG8EGYkp9/ZFNk1AGJYGMS3Of6NhLfhA+?=
 =?us-ascii?Q?6C43F2RyfKfbIYqrf+lDtEx2zZUxOVrilahMavLkQO1EmkSb9h5Ue+4j4j0J?=
 =?us-ascii?Q?LguwetCHh4iZtZZMEr6Wxk1ZV3z08edieOEibaVhDJdoT71XEjBm89CLDk/X?=
 =?us-ascii?Q?1h2sEPcRrliEWUy52BjkPGJWX7gtN3wcUzpi/fkhcNq1nVUyMoInI1g65Wgr?=
 =?us-ascii?Q?Fi+VNfGm97J8HceH9QKnB7KTwhRkbyINY5uhN8NrIygj+ygskTxE1324HDCN?=
 =?us-ascii?Q?XcXu+TVu9wKEZDs6nxKyS2F+AGazzxR+iMAFnt0jLzm11k0/CtKuMqipKGGg?=
 =?us-ascii?Q?3uzHm1Rb6JWZDK/eq3l1TZ8iSiJ10QdmMB8R7jlKKCf/i4AYRrc3spPG3C1S?=
 =?us-ascii?Q?Pm0fwvId+wYGljble+lo1+XH/e1js9UPvBBZSE3LXBGpIAJ6nHiFud/6YTaX?=
 =?us-ascii?Q?kw0iMnOthSpcWJlRtIal5BdqSlfeU/wtWlkbu30LGhjFDwPg4rdi4zBOGK4V?=
 =?us-ascii?Q?KGpkt1mCJxEedGodn9uo14OaTC7FMScki4Hb/DwuAGII7MKxVKpMWvd03zlL?=
 =?us-ascii?Q?PW0DJf1y9ZCsEKHaAoKGS2rcBTWms/u6uUqxdpufjyggFam7d0Mj1qS7aiBe?=
 =?us-ascii?Q?Q6gh7yCRtnfAmg2L/QAwaYv2BX2woJ/elIQQl660Xe29fdbcFx5iluOSyclH?=
 =?us-ascii?Q?AjeW8yISXNipzs6RGrMeXIkf3HtkLAOrUich8ojJAdjbSXdpVLrYC1a5uaoQ?=
 =?us-ascii?Q?reYAvh67VkhIbXNVrxsKvnbhnR3yO5yyg/r7rHgCqElhZNSXD6uhUf1NLfqV?=
 =?us-ascii?Q?vM+CFZXYCyLnOIhrjdbwKuF43D4gL2IyT0j+gD91WT5uEW5h/ILiZtS6wuAu?=
 =?us-ascii?Q?ABCz9bebOEgBb1JGjLbmggz7dUJixeRgEd6AvLnbyazpVRNfy6djN2EFTBRL?=
 =?us-ascii?Q?op6WbVam54LEs44AEQUm3mZgEWaixyUPJNF507wk8mq9Va5csXajhfQiI3Je?=
 =?us-ascii?Q?wF66er7vNUIF36lBVXsyMWXeCYFqIuIGl4fx5B5Pr0rKIfT9UziHqraOXOFF?=
 =?us-ascii?Q?onICgUl/wxcR8AxC0oQOLxhK+2PjAhm1woRk5YGHeeSv6dtwLV0CwXTAWdf1?=
 =?us-ascii?Q?olf4zjpPXcsLOahpH9OUhPXLowBMbcUi6dJ8UXCT2LFXWaC0cokaWOwybZS8?=
 =?us-ascii?Q?CrEC1Czyc8MloDsnufgThEQlNNX8JaX+9IXSl67Q602Yjw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afb3565-e569-441e-e84a-08d987877040
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 22:36:42.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EbTMHIyvwBjJYrjg4+P5o2ATUTbBSv6q3uTDTwU9H9N23nnuQAJI0KQXBaKDzEB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 04:25:43PM -0600, Alex Williamson wrote:
> On Fri,  1 Oct 2021 20:22:22 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > If vfio_create_group() searches the group list and returns an already
> > existing group it does not put back the iommu_group reference that the
> > caller passed in.
> > 
> > Change the semantic of vfio_create_group() to not move the reference in
> > from the caller, but instead obtain a new reference inside and leave the
> > caller's reference alone. The two callers must now call iommu_group_put().
> > 
> > This is an unlikely race as the only caller that could hit it has already
> > searched the group list before attempting to create the group.
> > 
> > Fixes: cba3345cc494 ("vfio: VFIO core")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 1cb12033b02240..bf233943dc992f 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -338,6 +338,7 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
> >  		list_del(&unbound->unbound_next);
> >  		kfree(unbound);
> >  	}
> > +	iommu_group_put(group->iommu_group);
> >  	kfree(group);
> >  }
> >  
> > @@ -389,6 +390,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> >  	atomic_set(&group->opened, 0);
> >  	init_waitqueue_head(&group->container_q);
> >  	group->iommu_group = iommu_group;
> > +	/* put in vfio_group_unlock_and_free() */
> > +	iommu_group_ref_get(iommu_group);

      ^^^^^^^^^^^^^^^^^

> >  	group->type = type;
> >  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> >  
> > @@ -396,8 +399,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> >  
> >  	ret = iommu_group_register_notifier(iommu_group, &group->nb);
> >  	if (ret) {
> > -		kfree(group);
> > -		return ERR_PTR(ret);
> > +		group = ERR_PTR(ret);
> > +		goto err_put_group;
> >  	}
> >  
> >  	mutex_lock(&vfio.group_lock);
> > @@ -432,6 +435,9 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> >  
> >  	mutex_unlock(&vfio.group_lock);
> >  
> > +err_put_group:
> > +	iommu_group_put(iommu_group);
> > +	kfree(group);
> 
> ????
> 
> In the non-error path we're releasing the caller's reference which is
> now their responsibility to release,

This release is paried with the get in the same function added one
hunk above

> but in any case we're freeing the object that we return?  That
> can't be right.

Yes, that is a rebasing mistake pulling this back from the last patch
that had a "return ret" here, thanks

> > @@ -776,10 +780,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> >  
> >  	/* a newly created vfio_group keeps the reference. */
> 
> This comment is now incorrect.  Thanks,

Indeed

Jason
