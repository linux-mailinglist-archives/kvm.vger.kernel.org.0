Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72B235595D
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 18:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbhDFQka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 12:40:30 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:23733
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232042AbhDFQka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 12:40:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIqXZWQeB+rYDzb4MCls+mnE8AkbtxFdI+F6gNjwxLD/quFj8FLSFSFrMW6jju9+kCgJ7y99XnyxKcb7RlZn0UKazliwEeo7dmaY7iWCFvD0adtShYz5bFDmZel9/75DcPhChDNXjwEnG8A9yBeGcFBTwZrSBPKTnodtQOzVOMCPQ4dVU7o6WIP3qVuG2qc5T93s/kWhf0Cqok3V+lzcWMXRnawXQm5XEGnaqMHtYArl5lGLPXr32JySeYGHk9Fw5frDcgktYu8VyB159cPEvACu4qYvoBs7YlmwOzxh3LguEqTPRKrOpQ54A55FvWgbbavjB2T/EiSLXeVWtBnDxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyXnekj/DWlX5yVosDD1+ETi3yfZVn9VsLPR2ubE6D8=;
 b=hw3fwp/lLGY+hbyw7ty8tHLlYvWQ4E6RfvlxtXqT8Aqc83MWfqLLFrydSQoIM2dsGEu9v/ncsjo5wQzY2qdF8MdlqhOY+Sr59oL1BzDGXjuwFg17lHTQ1tOYgmFPOSSr0cM6suwlT0NriGr9Jff6Z199PCEeiCBMHd9qp/PaqdYJzHmdCkDE5bCyytI1stvSx0T9IfhDANJqaBwyqUSq3yV77+nbceJlsIIBMa35ZbwcUZJCrzpr/OY8LC1MFG8qt0ia2eKC+p29rrElfGr6QFKFnphoh0MFzpqd63cQOs+rqpQSxDqGR1iM9XXgZYGvcrO5DPvBR55ILB3mM7yWcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyXnekj/DWlX5yVosDD1+ETi3yfZVn9VsLPR2ubE6D8=;
 b=cqtk5/xTqXMMWs+3E2IhkuOR+aKOkWMXOm8P3TVSpx5wCoa1lD0ygzL2xRe9LrPOKjUQ+V1V/pD5nW09Y6TIOr/iLpctVUsnjTKCz/F5tl/xtbVMcldjaCEGCLkOi81SfQ5377kd7BqlYT3fCFRegiQ7eqnZfX0zuDHjmjdjbBY1UyU5GMYiXYXnrYbB0zvV35bE27T7KW0SRSqfITZHbMryycErxF4ew2o2/Hq7NCW051foSq8TySPhhf1ssoRMzlMET6TXSjCqNQ0jhzH3Gjdu4zdZsj1EIc5Uad8wFhGJpWWwVuWQbbcg2jZNbzvQGyK2yf/NbYvDpf6tvv0CSA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1657.namprd12.prod.outlook.com (2603:10b6:4:d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.32; Tue, 6 Apr 2021 16:40:20 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 16:40:20 +0000
Date:   Tue, 6 Apr 2021 13:40:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Message-ID: <20210406164018.GB282464@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <20210323192040.GF17735@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323192040.GF17735@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR0102CA0053.prod.exchangelabs.com
 (2603:10b6:208:25::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0053.prod.exchangelabs.com (2603:10b6:208:25::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Tue, 6 Apr 2021 16:40:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTokU-001LLD-V1; Tue, 06 Apr 2021 13:40:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 385e06df-6ccb-41e3-a64d-08d8f91aaae5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB165784941E4C20FD0F00A865C2769@DM5PR12MB1657.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvNbwUHYHz9KmhRp1IQ5d2gJwNS8ZMBayyZjMZYLNCrpY6DSgipGP/yza0HvpFgprc+eR25SY2evFoa/zKTvWw7SudzImF3a7QORLpq5N/PnuNH0iP1dMf+SBMvdSAk6Le0EtfaHFyjtiATLErVQGTpP5ZL76Bq0KJo1j0vsjh8AddWQKamo2g7nI1OU+E9Y+HkXMBP9w5rekIVpvjwYxzjmmjmwtE4Ulc5pCtKL1Ee5DZeanTLwhK5rLzUtDlY/dM4eQQ67vpMurxK99MOwf3JzWptqAr4Vo1fH1ZxbtqrEDyvcsjJd576o7xzXmeSCuxoIZJ+BQVvEdJYv6JqE+w20+0emQFIQah0lUdvW1ypkp5MGYvC8h8ELViBMh+kUOX+KW1Cz2v7y/djq1FyoZ6IFP4a59H4VlT615BU4GTpskH2wp0UI+pBV0fWfK1j+l5w1N2oCz8KxacRJ8SfvCaf8qGfOCHh062A8xer5+9v23mgZjf/2AhXfNVL0x/IZLukINLGk/+RJpBjfuKV5vgFeeFPZbu4RDp4+nbfa+2yvm+VDbt7I9U8RzSP/HdWEqrPOu8xqpjsRS7uYzyixpeoNRYgXEuckOd1BwquTOJqJHYFK1/AR6tVP/vHhrgOhRrJG1rSlcyBoF+z3BCNFfR26gaZXk6sxX1ykSsXNbs4wgO6J/+mt08wHRtTNsDWM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(38100700001)(54906003)(2616005)(2906002)(26005)(6916009)(426003)(186003)(66556008)(66946007)(66476007)(1076003)(5660300002)(316002)(4326008)(107886003)(8936002)(478600001)(86362001)(9786002)(9746002)(33656002)(8676002)(36756003)(83380400001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g3lIyR+JpkA+wsLk0BGqXk2+kNGC7jN7hn7RkDBR/P866Y7a4DuzL0UmKYI1?=
 =?us-ascii?Q?RA9NiiOh4hu4nfx/DMbjESItnf4DilLnGXpGtQU5/3eZh4kz09BICb9rMtVM?=
 =?us-ascii?Q?7bxJd01OHnA7f8hzceVGUIxto9Ir4mvWOtd3TqdhdKJtFaKLuxsJDNrA1j5J?=
 =?us-ascii?Q?yhBFDfxmB41RiJVDD7PmJ+sNGnazYww62ODHz4d8DcpcChMfG21yJJymCGIW?=
 =?us-ascii?Q?rIC4fCvYc2WRpMnE5xcGCfxo8tpXyFo+bbQLx0rVUXJqPB98u7hEVpcAy4nL?=
 =?us-ascii?Q?A/qeHl4nLecZdl7TYeJ15nFdm0oUaDITDt0kg6SFfdSmMVK51RZfeQeaR9Ef?=
 =?us-ascii?Q?8EelZFPDgx4oWlyTy9NKEbq7Ig9kELGtmqAO7Xx+OQbVI1wSIVF7A0ag1wFG?=
 =?us-ascii?Q?XX74gb6nmOGVQ2uKfEfKyl4pcVA56zivdkIvNyNN9t76e+X93CXRA0ygu7Tc?=
 =?us-ascii?Q?grThnbkD04u/y++3h2uELEf4iWozTbZN/36tKr5SxD21yjQjOlSXQTfcWFVB?=
 =?us-ascii?Q?tPqJxjI7J9VxLEztja0poLZh96m28ZrsGOd+aOn8eW1foazDkLU1Na5PDd9c?=
 =?us-ascii?Q?fRrRA8puosHsUkM1WP3tl+cc8+t3csu4znu51ElXtO3WX6c30ObNwm/i6vfk?=
 =?us-ascii?Q?YxHD1IV51Rt6V8pqq+DOXjyzxrfRbkGiCzns9lnrnmMwDeDTG/+h9//w2els?=
 =?us-ascii?Q?c4z17HpdzyenalEZdaEOpH5AO2E0c0THDLex7QdHEp8F9Lvk0AyPNF0Isgu5?=
 =?us-ascii?Q?uMy0abUOfTD/cg72JL3VsbxJn/b4a1qzkS9/e488DDZgJvEGhFpYW3Bu6iVS?=
 =?us-ascii?Q?NclYSfM2CAlJsm3pvpti7H5nSyTSFJnP8M+ejhdqiSMV1wkAgniqUprUVHBz?=
 =?us-ascii?Q?hr5Q0yK9cHB1ql4lTCgaev7chq5ENsTZGFWadCXFbF1cyMTfDyDUMrfCK3PP?=
 =?us-ascii?Q?NNZEh8+8Qoocqu8cAG8cKswNcqgsYq/wyfC5E6EvVlrwqTUiZidEwGnsnFhk?=
 =?us-ascii?Q?Xglz60w0UJR4mFqqKwLNeZmzUkMu1o89QsB1eCspLofda43C1mYTFeAzI2np?=
 =?us-ascii?Q?ZDmIRUs7qiyOczqBkrv1lWRV18HVq2B0Ly/4hbhJerSDlV7RgslmE4e2rj/I?=
 =?us-ascii?Q?ERN20Sg6W169Qyk7su6DUHABOb3SS3397jp+UmZZ/8yfGwJjJtgSZpk/7gfg?=
 =?us-ascii?Q?eDMiD8UTAUZeiZsJzMYcJgW+VnDF9vcRdWkcQoX8mdJYvM8z94HA1gJsD2B8?=
 =?us-ascii?Q?22yw/iuQyr1l9mfvoTlgh5MYJm48PR/k2CD8eBBs8KfEzd5wVbFE8UvokdkZ?=
 =?us-ascii?Q?bV601gMCZROYunV1H83OAPLg5MMkPY0csMR6oOkRn2i9Og=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 385e06df-6ccb-41e3-a64d-08d8f91aaae5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 16:40:20.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lVfRlRk6VmWYdLCm1gEIzw7wOOpnoWAR83USe5NbTEDF5DYcO9T9gSPGPQMZntF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1657
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 08:20:40PM +0100, Christoph Hellwig wrote:
> >  	up_read(&parent->unreg_sem);
> > -	put_device(&mdev->dev);
> >  mdev_fail:
> >
> >
> >
> > -	mdev_put_parent(parent);
> > +	put_device(&mdev->dev);
> 
> That mdev_fail label is not very descriptive, what about free_device
> instead?

It is all a bit off normal, lets just fix it all in this patch too,
there is alot more changing in this function in later patches that
will all read better:

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 517b6fd351b63a..f7559835b0610f 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -263,20 +263,20 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	/* Check if parent unregistration has started */
 	if (!down_read_trylock(&parent->unreg_sem)) {
 		ret = -ENODEV;
-		goto mdev_fail;
+		goto out_put_device;
 	}
 
 	ret = parent->ops->create(&type->kobj, mdev);
 	if (ret)
-		goto ops_create_fail;
+		goto out_unlock;
 
 	ret = device_add(&mdev->dev);
 	if (ret)
-		goto add_fail;
+		goto out_remove;
 
 	ret = mdev_create_sysfs_files(mdev);
 	if (ret)
-		goto sysfs_fail;
+		goto out_del;
 
 	mdev->active = true;
 	dev_dbg(&mdev->dev, "MDEV: created\n");
@@ -284,13 +284,13 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 
 	return 0;
 
-sysfs_fail:
+out_del:
 	device_del(&mdev->dev);
-add_fail:
+out_remove:
 	parent->ops->remove(mdev);
-ops_create_fail:
+out_unlock:
 	up_read(&parent->unreg_sem);
-mdev_fail:
+out_put_device:
 	put_device(&mdev->dev);
 	return ret;
 }


Thanks,
Jason
