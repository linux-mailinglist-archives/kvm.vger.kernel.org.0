Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47452BF79
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 18:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiERPik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiERPii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:38:38 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2063.outbound.protection.outlook.com [40.107.102.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C098DDED;
        Wed, 18 May 2022 08:38:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgCHZW2glbcTIXfsU1cHB4lEWC09LWAc4QHOScScrR060WEGX6vQ98wBeQCqecnczDOfruOCLvjW9UpoD97huEigKv4bAo60s3z20IBUviZKADqhlfTtk3We5xC2qqovl9QvbYVp4P+hl6IjR3E17OSShJLVHETEf8oyy+Lc5+7MUyd1ts19OxrtPBxo/cYW3SvgeQbzi6rKyYHRf08KVQJ7tmIQCPAZzd+XMwZI3lLf3GOUjpDga06ZM7EoCy4tOP1r3lKPcx140Mm6DdjVs1bUzEoEmLaoSfrPPzecoEC9TIL8fiebhP3eEVnUFkW2Al9SL4wjIDA5L0+n7AJbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBbkK9VgXWmlIxgYtUWpWpBdjch31Cirzl6AheYvsxY=;
 b=KDHIu8mpFXZcS3y+Nz2wmbI9MVsDgKYvTp5NcvYJhOnF5ZkOup5P4kzPRdsl/Sfc9udbX2tnNcOoUrQK4fAg2tKcgdElGREGQQi7aIIVEfMTiumNUvN8dQOHDB6ey6kkGQInyVQGUg8/mV98gPVEJzSpbIhl7Z14deVJpHZq0NkaEtVrdOf86r02Fik3xBp22WXXnG6GLcIEsoXmqEJAyUwQPEkZxfxLxf248JWx2gFE8AmmUxfi4QjO5wFKImMtLt9qoclvZ/H+2rg7i0qTy46vzLRc8MTXxATCtf7nOqAa4YKncMbzPC6Z25cOPcLWTAa6nZvroj3B6iRnJ6fC5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBbkK9VgXWmlIxgYtUWpWpBdjch31Cirzl6AheYvsxY=;
 b=BqX/hN0whGXzlSjX50ZXT4lLCjRXrMsEdNNJaOfX+zcK7g84IgXfSi0D1laffbuPtMhTqzjyaA8QOlsw7EMMtDgLbL17Xtj75AI+a6oqglTlA5cfjnz47kR8Oa318RWJtUwDvpugZuB+fmojRZPM2ZaMYFB1Usu0E5yr2gkfPv3Uy85exCTgdIyOvgNo6oFv2XNv8zZteiAULuYMcunn/WaIDTw1d0ILVWMWh41PjxTt1+Ir5TFcmLPlP3c7O3xVtoT8q7o3iOD5tzxHLkrtN5OacVOXAYqJ4pcJmc+jdLPuMGiAKR+FWBAZBpxe/+WQKiDQK9JjEfijWMnZxhjbCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1423.namprd12.prod.outlook.com (2603:10b6:300:14::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 15:38:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 15:38:33 +0000
Date:   Wed, 18 May 2022 12:38:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220518153832.GJ1343366@nvidia.com>
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
 <2e51b388-48d0-4689-07f4-65f607dbce59@linux.ibm.com>
 <20220518151247.GI1343366@nvidia.com>
 <34c5fd53-c75c-cb96-c627-9d30b8c45c37@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34c5fd53-c75c-cb96-c627-9d30b8c45c37@linux.ibm.com>
X-ClientProxiedBy: BL0PR0102CA0021.prod.exchangelabs.com
 (2603:10b6:207:18::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b18c7a-b2ff-42d5-d928-08da38e477ab
X-MS-TrafficTypeDiagnostic: MWHPR12MB1423:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB142308308072E34022B205FBC2D19@MWHPR12MB1423.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pfljtfeJJU5z2DK9bPDkLBlNLsSwsFrLy9KN4dLpAf77ov7nbPjjMyc3IRFoCNMD1FDF+YWlgQ481dX9++okSUaATEZI4fZGRhHwD2GFGNrWjyjI/C+0Mf9XvJke9wlf/ivDKBMsqgnizXhmso7OS37x4/HU5Q/8jVJfrywEsGDU+a0iynXvLcOkH2RckYTWYl9Yr8EpMU2OPhxv95v5NN+g6M2b97KQ7hjx2vgT6vmMDVuBicUY4a4kuEzVH+rCW9HEWdy9WO2occIl21/kc3Loc85SuIZk/unClb9lmX6O6bt79xpYCoXj8MqGAaFXPvLc2ZVMWc0QF5BCXpb7kscAvtt6G+XbFFxLysOgvee1syFgWKlGMLaoGnAvxdQiRmvubsVrCoMjHbo+5p6mwwJXzY5/aOpE2U47zFC9l4lXEedJ+rMnroIvf9xN1Rwj0cTHR9imsaPSbOQhE4CGrcmJKsBMbcB3mCFJBcwbYNtuNp+MSXeGjf/bWpP4Z/RPuu/MUsZT9sLbkwqcNzkYw3TvWE++iI2EYkRSPCytFH9GFlSeL6lpUoeMFj6ghiNC5w9p37V75DpAUEnGFRwQOLc3PielPC8V0WYTJhlJjjrUM7KV8CwNHCt9RkBp6IVPD3bnugkCrBO+m+TZUYtCRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(6916009)(36756003)(508600001)(26005)(86362001)(6512007)(53546011)(6506007)(5660300002)(66556008)(66476007)(66946007)(7416002)(4326008)(8676002)(33656002)(38100700002)(8936002)(2906002)(186003)(2616005)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m+izraPsjI2KtyefV7eoAYgmN3PqoRdq1lUbPyFWfQhKQvAB/1oN2dW1iei7?=
 =?us-ascii?Q?hSBJTI5uAcpCKM3O9a20JN0tJtuiYgL6aURqW2OQi/o+iJZ05xzhycPEaRu+?=
 =?us-ascii?Q?bPA71165RrIVuPZy4gkWCji7U5VLkW0nggTbqze33sWQH2Vz2AwxQw6vxTcx?=
 =?us-ascii?Q?wuDUvpCh+E/fXsEbWrJUkeuDY5zeJFYIBJEnkrBSfags/HELC2NLR16y65lz?=
 =?us-ascii?Q?gVVe9ALec+oaM+DuKvcTgup/JMyZnFixAwEP8SeCdMIkdpI4k9SC6TlYX0Gf?=
 =?us-ascii?Q?+tAMfAX4KZk2vcgalki9gv4bbZd82l1/lgn6uIADxtDewbp0eu2/baY+Zcxo?=
 =?us-ascii?Q?8MH+RNgTZ99wDMVMdfvEgjIqFqrP+w1NxSgPKxvZ2idZ/w+bXUmEF26iDHCA?=
 =?us-ascii?Q?IbsPlbfs9vQ4lJz+G26WbJafHBcPpANw8NzjOLjpIUM8iQeixRQTvPpkmtcO?=
 =?us-ascii?Q?PsWg/0lSvjiUtwuGthO4cR1Ak0tR7QxgtEEYKmKYDHPKjukzC7VmJ8MVV5v8?=
 =?us-ascii?Q?1zm5gv3aF9dvokGe6EcvFP6fuJ9D7dO02p4BVtYfVCKpWdmLLW9QtjF3uXJd?=
 =?us-ascii?Q?EFu4iOwgYTB9Yd+GRA1bKEHJ0dKYMUDT41Yrb2b5b0Q/FarpieeDn+VVF9f7?=
 =?us-ascii?Q?qn5Sd824xMMlypJwkG8EtGXIEoq+nYwSvel7okZUim5D6gCKLm3RkTYnjRnt?=
 =?us-ascii?Q?3L7LS6ovr39VZPgyaIXRwE5vQsXl6dARYMYPo8OwJW3wmSXoGd86HADyAplT?=
 =?us-ascii?Q?wqK8C/q4wC86Mc4TAo4H+XG+mg6syD0Y+RMZaQXej14R7GhzaB5EKSakYsxM?=
 =?us-ascii?Q?/74BlkEKvc+0VNFFRlrtZ/hlo8HPwErZe2yVNqg22qhR/e3iHBeannWzqlzn?=
 =?us-ascii?Q?dcrMFRJ7K8PgSDelr055XrvgfwzOQo5u6eOXLKfFiEuEIzBi86oKS3lzDQ0N?=
 =?us-ascii?Q?RcPtPpcJZu84jIL5f/UH+8e3bNcXCtWv+DBIoi+uwFFaisMxcUhI433qW987?=
 =?us-ascii?Q?tl+rZ6vdzANZRNxHOYgWpl1IGhDapDoiTIryf6PkDJyBSXWFFfGfmIcqJlEk?=
 =?us-ascii?Q?kHMkb+8aljxZKmyis4EBe2eh3EEQF36c7QwxLMv9Bz8ZGNhsDPgumNea6C76?=
 =?us-ascii?Q?Svct4qZYkNeCvDUvD9u0v+Ln6OxAG2v5xjzeb8WGdCnFq/yXjU2uboxbuT1M?=
 =?us-ascii?Q?N38rqp5HuR8JZFfWYZr/sibm2S2J0veMfJYfuFHxj5q7IT7CWPUK3QQvK+yk?=
 =?us-ascii?Q?4mRW0+vMA9BhAjEeI5spnTJkuOP4c6mZYI9ygULtS7am2uIrqnSrIFTHMEGt?=
 =?us-ascii?Q?Y5tMkM9FeaM3rksm3VJa1onLwnAoppo4xgUAomrUzPaUTOJJbz4tg3Cf7Vg+?=
 =?us-ascii?Q?Q7xx00kV7LRkvTbvt2xczSQPt3r/Es8R7+z68l02ZZEzStCToONUFIkM3wpr?=
 =?us-ascii?Q?Bya9Bgd3VyWw1kw2bYZ4wuc0yi1czrS27TZVrcj6s6ELaeO5ZFZVPhJUuTid?=
 =?us-ascii?Q?D2shVRQDPGJiK3413lBuXqmtIPUzw/QxDwxemfFkn5632PdXNU+WKYpOCiku?=
 =?us-ascii?Q?y8c/lEOeXr+VZPnBXXjQVHYV//XT/gaK1/h+kvbTQc+mmVhtgGJE+AGmgBzu?=
 =?us-ascii?Q?cH+Y/lUInrX2a/yKLtp3iOlHJyuwc0WGV7GY5G4rPUbIEgegpPWvfOecnZ5q?=
 =?us-ascii?Q?bS/61JuWxoe3isxAU6N0wqVolU2QBjwgZyXVGXiSX8XP415QL8la5vHzg0zw?=
 =?us-ascii?Q?T7xrvS91yw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b18c7a-b2ff-42d5-d928-08da38e477ab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:38:33.8889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO+fugJOV8//MieqEs/TvQ2znIb/YcQhdjgLXEFo/iQVGnZR7C9jTGmou4IWPnBA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1423
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 11:33:37AM -0400, Matthew Rosato wrote:
> On 5/18/22 11:12 AM, Jason Gunthorpe wrote:
> > On Wed, May 18, 2022 at 10:37:48AM -0400, Matthew Rosato wrote:
> > > On 5/17/22 2:08 PM, Matthew Rosato wrote:
> > > > Rather than relying on a notifier for associating the KVM with
> > > > the group, let's assume that the association has already been
> > > > made prior to device_open.  The first time a device is opened
> > > > associate the group KVM with the device.
> > > > 
> > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > 
> > > ...
> > > 
> > > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > > index cfcff7764403..c5d421eda275 100644
> > > > +++ b/drivers/vfio/vfio.c
> > > > @@ -10,6 +10,7 @@
> > > >     * Author: Tom Lyon, pugs@cisco.com
> > > >     */
> > > > +#include "linux/kvm_host.h"
> > > >    #include <linux/cdev.h>
> > > >    #include <linux/compat.h>
> > > >    #include <linux/device.h>
> > > > @@ -1083,6 +1084,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
> > > >    	mutex_lock(&device->dev_set->lock);
> > > >    	device->open_count++;
> > > > +	down_write(&device->group->group_rwsem);
> > > > +	if (device->open_count == 1 && device->group->kvm) {
> > > > +		device->kvm = device->group->kvm;
> > > > +		kvm_get_kvm(device->kvm);
> > > 
> > > Did some more compile testing, since vfio has no hard kvm dependency,
> > > kvm_get_kvm and kvm_put_kvm are an issue if KVM is a module while vfio is
> > > built-in...
> > 
> > Ugh, my other plan was to have the driver itself capture the kvm, ie
> > we lock the group_rwsem to keep the group->kvm valid and then pass the
> > kvm to open_device in some way, then the driver can kvm_get_kvm() it
> > 
> 
> Hrm... If we did that we would have to re-evaluate some other usage of the
> rwsem e.g. if driver open_device calls vfio_register_iommu_notifier it will
> try to get the rwsem but it's already locked.

Ugh, yes, it means removing the other notifier callback too, which I
was expecting to do as well

Maybe we could split the lock for just this patch though.

> > Alternatively, I don't know why kvm_get_kvm() is an exported symbol
> > when it is just calling refcount_inc() - inlining it would be an
> > improvement I think.
> 
> I think that would work for kvm_get_kvm, but kvm_put_kvm (which we also
> need) calls kvm_destroy_kvm after the refcount_dec and that can't be inlined

Indeed.

Jason
