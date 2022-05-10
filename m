Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92F5227CA
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiEJXsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 19:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiEJXsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 19:48:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD825C64D
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 16:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkPmHVDiY/0UjKwU11D3uzBAFd2uKextO3W319K+S65Tb5KNEEza/lyIjnfQvYZYvtpuoI8h/AeZzxh0LKVDWH5gnBiTZ59uvmwNRkFBUJ7CNPhxWsoUZt/ldpdIcsrUPFGxxWjfRi6uqdZj06jChJZpNpI5ruMMBYduJvI9+ePbV1eNgR+fHOpXUfIslDG+0TRD4RVQU6EovRsyfUVcKTdxGAwzm4ENswURuwZToHwHExM32pyGQz91hp/q6Zp4EGc2disATP4KjmhBY49K5fvI80OmQYzPGth0SaKI/RRGM/ZOKukGZgFt+9VBK6khZnCARkUsn/I9hJ6jByAl9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/E9/8824Hr4ide/EA2xHbzqri+pWFS44fkyWBfpQ54s=;
 b=K3bhvIHkvsrtIAfKdawWZE9i8mzRP7RS5249yVutM6srlJ2vluQbXPhW9QHL5g+AflnEQL2fE7wExKMTPAxHktd7qHRQUcNhdAkCZcsSExKUh/jCSv+qxGGiZ4+JotO57Rwr2gd0d3G+T6D4nUcP9NqKJn+fFmBYPPYv/f59llswNS54ric7LJuofNaKOSeLWVjUOIBF0gWSbqPKSNiYnITUhMS3PFeaRAUfnLDrVwXr6fUw+RY2b/6os1X0htGxBfWaptecEtXZAce5AerLq3J5PzjEb4MYCSFCdoUUcRO1oCluqFuDcFFfWSrSp3FBvB6DITD07xNmPscdcv6Mxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E9/8824Hr4ide/EA2xHbzqri+pWFS44fkyWBfpQ54s=;
 b=jIWYA/RzHwzpZ0K7UdkfJdvtERwYOAHMqWA6Cg7L0B93VuuV2o8IFMgi8+yiPfEnuD8v8298tFSrjoT8CcrK28d/+JH9eRAKhKaHn51bSrtrXTZnQid6cARBmPXNq1DfXBJWkK15TI0jtv2jzvZpGsZkX8f5kAUmzN0XyxVY6G2qomUKnN2EVI0xeSwAywm94oJ9hjM+Nk/3LotkuoM3IrSMvFFn/R1jDTkjatC94eyjnUwM5p9JmNaY9CUqOOXzFsrlsUU41sEW2656w0j45tBv9zD+g3Fq4X6eiY0S8bl3bJ2G2OlYCTe6DQl7GFp5r07t1syarYr7VFR67eAONw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1917.namprd12.prod.outlook.com (2603:10b6:300:113::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 23:48:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 23:48:20 +0000
Date:   Tue, 10 May 2022 20:48:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/6] vfio: Split up vfio_group_get_device_fd()
Message-ID: <20220510234819.GS49344@nvidia.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <3-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <20220510135956.7b894c27.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510135956.7b894c27.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 673c5ea8-ebf3-46a8-9be2-08da32df902f
X-MS-TrafficTypeDiagnostic: MWHPR12MB1917:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB191704918EF54776431613C1C2C99@MWHPR12MB1917.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IYk4/fR3LZYRelfPaG48YVyOC6UyrunJ/OBnzNvK5uQ4XaN86eUuMcX2XILKmyOoKy4XwLpTdIbhLYSwsMzZvZD79MFUZxfiENL472oIoDu8tnScOKvgvACp4PAhiGyKf/aJP1kWJ3FBsb2g87ZW0LJhMbWQ08sFMWM7/wupqqKwQG77zPM4sLAJgKI721XIH5oD0gi5gh7mLo3E2QNKpVvVHofnBR0CB1UHV1bnTwc9BmEoYDwfE9zeHcxPshzvw98hhcQfl+xldGXsQcrJbHgIIp1nGegGB0pg+LuuiNMdhfG1nqKbx7jw/Q0One179YdmZ3kzsfLRjSly37mUJayXRW8SNm2XCnSFdVJnQ+bqq2Q1GNuwFU1OEoQYaWBgq3svbDR6QdiOI0euTa/HhPzrHAbJsIkuL0jhkwJbjyLFEVxZAIsC0Y0pOvGF9FPcmCS7z+ZJHFC6IKXfcsBJLXp/0D0oOf+gg9HvmRDLD7HkFufCK60LuV/p2+fWw8e8l0xVkxLXEH/8Em+WIV6rRBQOq7tSOJQK2a/0TJXMw2gT3evfyVAgS22LuLZ25Jm1psjGtpF1Ja+Ug1rGxM+2u9G5Iec1LcRdWXXd/oL/U/wM6df7TYgbAggWdGMgn2tvmJFwOl/ZEqCiMYI2FBSfww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(1076003)(6506007)(186003)(6512007)(38100700002)(54906003)(316002)(86362001)(5660300002)(6486002)(4326008)(8936002)(36756003)(66556008)(66476007)(2906002)(66946007)(33656002)(6916009)(83380400001)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1+4YOiXu+HCb9fkbluPL93Ic4FydWHWe8L3+PwdW9T+XyhjZOVTeUD2vSqyS?=
 =?us-ascii?Q?29fzccBKJ+1rWjSgqI6o132oBWGVacXTd+xAL08XVJ4b3Zz4RLSkMA4t+i4p?=
 =?us-ascii?Q?i8icSLdxcfXrm1jtt92XwIVXOG+UdMpOHHFF+PG8+AmlNpoajhQwgFONYZtg?=
 =?us-ascii?Q?4s9lUoKRcVukkp4xb2sT65vngGRETRJtUVFE/MfyDBjPgkKx7TjtZJ+IT3w4?=
 =?us-ascii?Q?s60Jo0Fc1CRhTdfZ8QCTstWvRVlu1+C5WnTM/1U1dVuTjy46TFhMqodxesii?=
 =?us-ascii?Q?3qyseuPkkS92iIdlpiFYltDr1V0znTHYfcLoiKc/ecyyOziLaEiOsWqrlEMx?=
 =?us-ascii?Q?mbeehL/thdva9+SHEXdSYBviNn7co5YptAuqxQ3E3KFB2VPDiJs4sPaRj+bb?=
 =?us-ascii?Q?LcK9YelrsaDvuk8YlSyKNznf1jBsmHnwgNDeIG29aMlcu0lTS7oHj6Nkhc0B?=
 =?us-ascii?Q?hzRXOCvjJNdIOeAKe8r6lfzQlisE+IyyKvrg6M6tMeSWrKQt5UK6RckEnIWg?=
 =?us-ascii?Q?69GDu+Hg7B4HJwpM4KLL5Nz1gCUnhK6AmX55C1YV7FL2HRXU3OSSyJfSVma5?=
 =?us-ascii?Q?afMfik6uGdvQspI3pmsuPoJAVaXrs6sE0ISuCIEnyhoO5DRHNbr03q3/GOVL?=
 =?us-ascii?Q?avFCD3rdEJzLjosQZGB2gzXt6ircvympL/NzeDNHhqsbBLnPipSml3kmcH5n?=
 =?us-ascii?Q?eLDuIgY27XJo4p798K/+rhBTI7BH9ROfwX9PEKg8ENO6yay4VhoCBO330fYQ?=
 =?us-ascii?Q?jeO3s50wGHZGMIXkdH8Lvg9+MMiX/QgiM44fQ0L3FHvHjHCub+EAngrTjl4W?=
 =?us-ascii?Q?5+M86zMyd5uW6SIMG4jb1IUeNZLFxrihHIe6iJR4oEjas0HUMHgNOgoOK/nM?=
 =?us-ascii?Q?bwBB2ocetuc6ByflpVVqrYvM0iRq/CLtrI6PAvE73WviFD673lrheIIQGv7E?=
 =?us-ascii?Q?qvyVVKZ+PiUAzo4DSQUoRHs4kYQ8a4wLNcsVuD68sp76RoJB40PHEjVwRZpA?=
 =?us-ascii?Q?0/DG2BfbsQ4m8aZXOP52fqOn64WiR2X5b5g7/CLxHj2H9qps9Un+AIIcnYLd?=
 =?us-ascii?Q?XPrailm86UuUyQoxuZ1rhQE0lpepeTErJF63sJy9pLGcNKdmXUV5IDgrAVFa?=
 =?us-ascii?Q?6+F9phS50RCVEnmcLSN0D5Hl2E+fe2nQ2nf/vTusLBxjdsr/dpnBerlRnMW+?=
 =?us-ascii?Q?/xkk9XqiiRxmEVq+I07pMz5Iyk7kenc/Qy6XwqgXnWrc9fJWjtnJlECZUNE+?=
 =?us-ascii?Q?CwVNYYfy/GGBHhQpCTz17cqw0pAyoWV2DyO5u8s/eR6ymgXhuNb1o0RLYPW0?=
 =?us-ascii?Q?OK7Gds4Wj4HxQoO2tpWleXaP+cFnkQrKIBnco2Qx5rWVheX2Js4hvT4OI653?=
 =?us-ascii?Q?yCVt11zebzZE0mGS8kl+rKVfwbQE38YJXtzAYd7DWRI3Bqa6An0rMxpRYJT7?=
 =?us-ascii?Q?fZYNzvwKfPsf5QE/nUhLaEIXs+JlKsgM01kDJeaTo55uLiEuN1lMLdGGPNvO?=
 =?us-ascii?Q?tXgqZ83yYL3VHL97Qnl+Mg3vGXYFacU0PsrFu2UbS34lytMv2Ts8WKjZ5ehY?=
 =?us-ascii?Q?4OycMCGC4P8ow4tD5sBjew+c6aa+J1XX6xTrhuGbOwmg+TTbuHdkFC4BYRpo?=
 =?us-ascii?Q?muMuwXZ+PhH59OxUmus3kE+B8AEcIwu1Ax6AT28kbqxTRR3B0LdVQagSmaVT?=
 =?us-ascii?Q?qTD/ipynP7reE4WRgOtJ/zApdGjZpefmb6cBDqkEKqvyEt5WGNqZMbOzrutD?=
 =?us-ascii?Q?WHOu4KG1ew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673c5ea8-ebf3-46a8-9be2-08da32df902f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 23:48:20.6043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBX7HrKwThz9Z/f8pAy592fXbfZxjU75g4lBos/S4yKfGkI6eVRqyPNk+QcK/2ZD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1917
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 01:59:56PM -0600, Alex Williamson wrote:
> On Thu,  5 May 2022 21:25:03 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > The split follows the pairing with the destroy functions:
> > 
> >  - vfio_group_get_device_fd() destroyed by close()
> > 
> >  - vfio_device_open() destroyed by vfio_device_fops_release()
> > 
> >  - vfio_device_assign_container() destroyed by
> >    vfio_group_try_dissolve_container()
> > 
> > The next patch will put a lock around vfio_device_assign_container().
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 89 +++++++++++++++++++++++++++++++--------------
> >  1 file changed, 62 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index a5584131648765..d8d14e528ab795 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -1084,27 +1084,38 @@ static bool vfio_assert_device_open(struct vfio_device *device)
> >  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
> >  }
> >  
> > -static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
> > +static int vfio_device_assign_container(struct vfio_device *device)
> >  {
> > -	struct vfio_device *device;
> > -	struct file *filep;
> > -	int fdno;
> > -	int ret = 0;
> > +	struct vfio_group *group = device->group;
> >  
> >  	if (0 == atomic_read(&group->container_users) ||
> >  	    !group->container->iommu_driver)
> >  		return -EINVAL;
> >  
> > -	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> > -		return -EPERM;
> > +	if (group->type == VFIO_NO_IOMMU) {
> > +		if (!capable(CAP_SYS_RAWIO))
> > +			return -EPERM;
> > +		dev_warn(device->dev,
> > +			 "vfio-noiommu device opened by user (%s:%d)\n",
> > +			 current->comm, task_pid_nr(current));
> 
> I don't see why this was moved.  It was previously ordered such that we
> would not emit a warning unless the device is actually opened.  Now
> there are various error cases that could make this a false warning.

I have another patch that moves all the container code into another
file and then optionally doesn't compile it - this is one of the
functions that gets moved.

When container support is disabled things like group->type get ifdef'd
away too so leaving this behind creates some mess and breaks up the
modularity.

I don't think it is worth suppressing an unlikely false message to
break the modularity - at the end someone did try to open and use a
device that is dangerous - it is not completely false.

Jason
