Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF316A0A65
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 14:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjBWNV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 08:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjBWNVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 08:21:54 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3F555067;
        Thu, 23 Feb 2023 05:21:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqFRxbCBJpUMsTOxiNUSbqOmXsBeJzmEQG+MO9Ead8tT0AEf1rtMGE8BoxEvCXMkHRpfwMaUIBpfYJur3GJRDlzz7f4MAMrq0DXJuK5lmL16OHtZ0yxTn4LITYdMRbLRLDBV4QgdNMRg4z8mSxlKQf5f9w2Qcb5p9Ul1xu/W6aJ4Bc4VJoY/bIQr5EfEBweFu77VLlBe3xpKDvx4AfLycEsUFuKrz5sN0G+QYA1E9349v6OYk5oJVeIme4dLGdBSGtHNApATOh5dqdxoW92MwaG/DIXJEnmDOR3CW47ps3t1nhaOzzqmCxLVhX0mPoDFMlyCPnRl4epg0SKDYP7wtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03EObfSPPoIOQSA/BvFvuRrfCC1wZBSjj2QBV3sXEz4=;
 b=TGLNbW7lxkmR6Qp3Awk1vkO4WuoUphgMQ5daKOy6RbEok1Njlm3YG+sJbk1f/ATomp0uzvjr1QcTvU4bWJyo6Fz8KKy/4A71O+NNZ7NHj3kIS83TaG+dw6LRFDW5MbFLFTIpsjAgS064bzuXX91lvOF6s8nZcBYQ6RbbVY3eLRWeZXtPKGB5rQG//DAY120+KrEy4ayCltWt3PqsV+ns30MWXr+0FSNlRboR+sCAwVuueCpXM3lvPh8lQUt1MvqeG59e8CzfxaacIOFn1iPd6aQtc5l0xg//G3VdYPLbzMcuFnwP6ExLYCPQGfD2nPEeHmeCZgKJX6HmA1lT8JxoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03EObfSPPoIOQSA/BvFvuRrfCC1wZBSjj2QBV3sXEz4=;
 b=I603RNfpD2xq5O3fpwCbI/pk/xpyW2pU16LrABTb9sNuj7a0b4q9N3qtlkAYzB9vldTAO9YIlmdDGB5Oz+qinD7FqvO3MqS+rwYj3iPmCjQtUtiXQpSjiaerY2GbvnwSLhIaJuJdEcbfti8AkPGIknuUINQoUbcAAtIx2eASVOwWtabLvpGg1sf31Kk8yAtxAJ1j9oFz8MpbpytJk+mKm9KMZE+xAKDO41mu3WWI64/yL632QzewQii/wG8260ffUdt+lM9AOE00T9b32CFftkjqoM8pRIiniwxl496XAJmTth3W1LYvR8+7/AVIMJYrXtrLoKO70kKDspale45y7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Thu, 23 Feb
 2023 13:21:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 13:21:51 +0000
Date:   Thu, 23 Feb 2023 09:21:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Message-ID: <Y/dobS6gdSkxnPH7@nvidia.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
 <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:91::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4373:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca57987-41a0-473b-bd35-08db15a0ecdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYXGORKk3z7sJhJgdujtYuT3sqOy87gZFm8hxvzbrOvYv90fECb/RCwYZK4sHMjHWGieclZ84mHTKWnrs+alwBBZKD0NRkhoKEGAMjZ5QIU4mPAB7fYv/OjIsTlJVWZX7h5rvw03t9TcZ3k+k6hJG6hNO72yVK67syzhtIZ3sMBB7Ji70DzIohkuwm3McsjJQDL1bFGnsz4rBe7R9bPbKAzyTbDbXXjshQR9XPkaRCVST0X9bcxVMX+Okv8eUFb1VGBPwbz3YUDnQDtOXw7BMbq/HviItJ0aNNn1EYh5sVk6hD6NSK19q32FHT24vUhajAV0KHPpfhhdOtJQ/pnUiZGtlrnDwCp15HeMdpWmlzxkaaCZSTthVwb03z8yEn2yBHjQhk+g/46CXDeKaeStVYF542oiRSn/t7Xfoc5TPiCH7k1XsvHXHuheXaJpOk68apttZkR9UzxtPv1OcDBGkVpMNWwIYbTgnsC7LaP4AO0erEPdYEZuuUYU4jH2FwHcYVNIBfjr8x2V2vUGtqAoMrv+mJa+tjEbA4UeuFcZNeJocEVFinomUwd1SOGhaPJzOyGdLgwZiIewG14WNxCRQZrKlmXpoKhB2mrF8Wa16lz83xAxAdq7DUoLkbvv2TM6OGaV60+dU/MHHn6VgwkOnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199018)(66476007)(41300700001)(8936002)(6486002)(83380400001)(5660300002)(7416002)(86362001)(4326008)(6916009)(6512007)(2906002)(66556008)(26005)(8676002)(66946007)(186003)(54906003)(2616005)(478600001)(316002)(6506007)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L6dRJbnpIBgqrzCi+DqB87l2gu78GBu/fJ6j9WMyV73vwzcl/GlAKTqv7piF?=
 =?us-ascii?Q?04HFojQerhFc804Hs0SnkifohusGq9OCh9bYv15uhXzsmx/sb9ZueC/3wy23?=
 =?us-ascii?Q?J9p7MYrD4UkmmVd8T9idBbdE0+q5MLPGRwSxuSdjJswDBNxhK1q9bEJdPyzk?=
 =?us-ascii?Q?csO4HrY2GpU1WLM0tukLelGb++m7d2EJVUrS0wVh2JP3xHQt3VFUun641jLo?=
 =?us-ascii?Q?OZQ37pv5A+1OgpPLHj/bfaXTPNPcgDwAv0DwKdXBw7UbRQXFHz5PsESIiI46?=
 =?us-ascii?Q?HE5qAHJZow+abWeEqrfhGU0my6El0oOJf/wQ8GuarMIBdamZbB1p3IUHcyrr?=
 =?us-ascii?Q?X2ekhFXxRwNqImRsWKHhk6yO1FM2whEiw4mhYYtO0WLyJs8/Ux3fXnwg5XgL?=
 =?us-ascii?Q?ip3PDpkud4prpqJy4wNRBBPpR2B/RSdU0KePpsr7rD6fEu/R25Bam1BzvgZ6?=
 =?us-ascii?Q?PwD6lKSB02jIKL3y4xVeByJS3gzYDb+ewX2M1shg6v8P9ac+wc+uza5sJBvP?=
 =?us-ascii?Q?bZ4uFBEpwKV9q5qEvNp7xlfHejrfRH/UT5sSZ3oeo2fkVYLhNkpBIR8nOwbj?=
 =?us-ascii?Q?fscaKp/P3fBEQsfDMUjs796Uxd6E+xWjdn/hZeok7/3YI9Tc9Eez7rwnkruN?=
 =?us-ascii?Q?q3GDSDSjDPiMgstSk/jINTZzZIY1a8FsgoIp3UCLnPwAAgJiln1UL7+XAvMe?=
 =?us-ascii?Q?TTnrtDB+OFUN5kO33uP0rFIgrR0dTh8nB3bMyqlNDS33aSx8WwIxsD/LowUE?=
 =?us-ascii?Q?EHPKMHCJeD7by7T5rlaE7ytZfxJfOqvWWS42nTOfVq6EWX+w9YJWTQLpkuVj?=
 =?us-ascii?Q?MzLyk91ZD3NgcRseGnuTFrlLlKHsuCaKPk0BNIVXK9mtWqF61HrvRrwfIR62?=
 =?us-ascii?Q?99sVlI6S6PPEvvxgxruUEjm1YvCIYV4gzhzM29FolHXK/s/DTPAw81jXVPhT?=
 =?us-ascii?Q?zS4KA/gvwF1EdbS2loUZKsfFoyj2h5YVyzCLuvdl2aea9q8MIsk5GsUQ+K5v?=
 =?us-ascii?Q?rceHO/qSDI4LSTcYF7lEPIPL620QIYckBGmdYzNwsvA1iq8Td2UrZmvROoKG?=
 =?us-ascii?Q?f+3lK3r2bDynSGNZlTkwinFZ4dv3fCc2L9pScJBplHLViayCBllKk0NCzBcS?=
 =?us-ascii?Q?yewSzW4LDi03Y5f/uhwRcvtlxFa64Fo1AU+i3GwY4WX4TWE18ylC8hq+qeOB?=
 =?us-ascii?Q?bdMmIJax9mJp+qO13WCJgLGlro2XfptgN4yvJzDGZLBq+miASbUOjrYtLOBF?=
 =?us-ascii?Q?3t2Wd/JlcrXX2BrDXTY4g/+qtcKmjPhA9KlFRsIfnVxX3z7psmpSZl7CR0Ll?=
 =?us-ascii?Q?EUgUZXIh4noBfZiR4MRrot8jNy+lIbc3sj2WJiuF2/53n4zhD1BkTbVxVs7T?=
 =?us-ascii?Q?bCUEcy8x+ZeF79Y8N+AhCt2S04wcSNC+iTKMAvwc2Q2+zPAbtpAgY6Xpdn+U?=
 =?us-ascii?Q?9ufBWp1gkwne0yUmzAnb6ZnJH4wQYDCmMWEvNdpE7u1gZTCOt8dEFusyEQ17?=
 =?us-ascii?Q?wpbBQGEv49V/SNNR+7YaqPsUbxvLSlWYby08TxPAPaGVe1IDOWnn4t6ykCmI?=
 =?us-ascii?Q?gUrxg1V4zHPzcYCVJUP8rOsVPqFhX1B1biS5xDLv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca57987-41a0-473b-bd35-08db15a0ecdd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 13:21:51.7973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyMfA1Jj7snSuVDDtepAYWjhYs7F4MAMVLBqNhwo7GZARFufMPQsil7s5ePbA8E5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4373
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023 at 07:55:21AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Thursday, February 23, 2023 1:18 AM
> > 
> > > > static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> > > >                                struct vfio_pci_group_info *groups)
> > > > {
> > > >  	unsigned int i;
> > > >
> > > > 	for (i = 0; i < groups->count; i++)
> > > > 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> > > > 			return true;
> > > > 	return false;
> > > > }
> > > >
> > > > Presumably when cdev fd is provided above should compare iommu
> > > > group of the fd and that of the vdev. Otherwise it expects the user
> > > > to have full access to every device in the set which is impractical.
> > 
> > No, it should check the dev's directly, userspace has to provide every
> > dev in the dev set to do a reset. We should not allow userspace to
> > take a shortcut based on hidden group stuff.
> > 
> > The dev set is already unrelated to the groups, and userspace cannot
> > discover the devset, so nothing has changed.
> 
> Agree. But I envision there might be a user-visible impact.
> 
> Say a scenario where group happens to overlap with devset. Let's say
> two devices in the group/devset.
> 
> An existing deployment assigns only dev1 to Qemu. In this case dev1
> is resettable via group fd given dev2 cannot be opened by another
> user.

Oh, that is just because we took a shortcut in this logic and assumed
that if the group is open then all the devices are opened by the same
security domain.

But we can also more clearly state that any closed device is
acceptable for reset and doesn't need to be presented.

So, like this:

		if (cur_vma->vdev.open_count &&
		    !vfio_dev_in_groups(cur_vma, groups) &&
		    !iommufd_ctx_has_device(iommufd_ctx, &cur_vma->pdev->dev)) {
			ret = -EINVAL;
			goto err_undo;
		}

Jason
