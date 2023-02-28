Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B36A5AEF
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 15:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjB1OiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 09:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjB1OiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 09:38:22 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBDEB455;
        Tue, 28 Feb 2023 06:38:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qr9nqUDMQB3lQQH+i2fPGj2uWkYam4gO2bhebFI1KE33mg7z1Ol8Li2DKdJF0Hm2jikau2Qf8tdgMP2CsAQJnZXVttm+exkbNCKXRxTQWmAxKVCAhdaMs+ha/ipvWI53ovSSBHibuAu6q3YSr9ttvAdNz0YcLPwQ2rAJ7/FMQnSkBgYPHymh94o4HWNKJoQKEpnwRC8tiNcR205TPbma/fa7wpWGzlRcHL76L+ebvH+ebHLu31xn+sOd3h9eZeQvFvWdonIFLQ+LkIvBXxRDuSH2ql4ENCPDTrCXgBQa8JvgLrmnB5CIJkqA0+oxb7+EMD/iGAGHtqxfbhVk5japEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TD9viIIRckV7vKa79YnLRCq2ivSlMT+Jz2wcDu+6ZEw=;
 b=BNq2hnqnQFDUnZ1Qhmsz+Arw7n/GUFG4Praxsug6rFOLf7AvDObsmN9Ga2MnHNZoOP7VItc/r6qH4pqCNieASezFCyH9FiwYtcZvfNjqBNsFEAubYZGEpRM6tmT0X6POSGwqwXLbcMMFc7ZKMcrbNBoinC5FUDWLY6DQbQz/HiYGzmxJFlMd5J6ze1ajw/QmeKddIB2BJlDZD2EhWq2fJJIVxJNy3ajpR5gLH/8Bg7CWTZ6zwP0uxbwDU46VMTSGXB3TBzX+Hs8BDz8ru+ahiDD9TTx695OQohGvFzOl9u75xkWOt8YwDsR2rB0VL7TjyETAgdO9aoZ0mFdH+E02YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD9viIIRckV7vKa79YnLRCq2ivSlMT+Jz2wcDu+6ZEw=;
 b=cmIZWfXqLRTzNI+OHtqd9KBfBaKD4d2NTfFlYoXS06eagUDU7aIffRhVs8HigQ9NTTP2mKbhpIu4x/wSKNMGnhuusYOOcnNj7QpCsSVKfaaYCmw7yg9pGga4OH1/oJnjkx3zABS3vBvceznRNHcYVtd7qBKy9rYu6hkNceRWlRDvxAb8NoimCv3nX75K8I7gGY397kfCL52SZLwE4bYKjqc3+gEXp3tJn2hP00RpRx85dh1sL1WJHyliSia6X9xqeZ8fbPq2Vhnwx7G67rANXb58qBkceyHNQ2o8C6Q0TVDR0EGidbMnOBDRwy0b2huPdBH0zu15s2ay/1Sd5Efsqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5763.namprd12.prod.outlook.com (2603:10b6:208:376::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Tue, 28 Feb
 2023 14:38:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 14:38:18 +0000
Date:   Tue, 28 Feb 2023 10:38:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Message-ID: <Y/4R2SRFKoRFg4qK@nvidia.com>
References: <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
 <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4FDP8H1qRdgVrL@nvidia.com>
 <DS0PR11MB75293E34AB7C53F7ABFC0E36C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75293E34AB7C53F7ABFC0E36C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0426.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5763:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c950111-13d7-43bb-1251-08db19996f08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jq+G11e/ESsSKtR7a1unYMItNsm/bdmP7r67J1vOdL6N92B6D2aRJnwMMUDua+lJTrxExGpVp2q7rr9XgrorCnjt2kR3esCRJb19r8VpYH6UYmgncq6Rf+eJj3G83Js2N4TJiIC3azf59V3vMdtCOqJ4ty5gawxUimWbFYGH/wntqCSyje4Vpt/YLw/jvObYrxqLF9Dgtbq48N+UqElcvqBMYNvfSoVgtuCqSU+ZA3KX/S+J3N16dxNPolDG03T52ANAADNeSWY3pXIJa21YwLQ0IIaYyiqtEuuigCqojJTIdvlxtA+r2R0qSdE5BkKXnTO341EoAEmayMdAMHkDDEXvNaZ/N5hu+cF9J7WpJwfOpfZEVZIk/vI155GfrLYMnw4icdiMHh5obi55C/4fcC7QkZagnowK2QS6yC5wLY59wJffP8DA3SobgTygsxzB+rSnL0EPqMqk65LKnxFhLrTQUG9+9sJbqGzVEnpTrSRKb2NnM8tLajHpWErxf5OlH7JiYX/emtanTyiKkmgi5uNvMrQcPa/FEBFBL3bLxFAOUxV3rpJ8Mw/wEnxjKKgS99YWCkiP9tO/z9bxwbRiCu5HDOib128bDjqkiLpZ4+x4ptxqk+Ymy5BtbXd0bbCP5ZbOFtKaCuxyZLJq34TmwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199018)(186003)(2906002)(38100700002)(83380400001)(4326008)(8676002)(6916009)(7416002)(5660300002)(6512007)(41300700001)(8936002)(66476007)(66946007)(26005)(66556008)(6506007)(2616005)(478600001)(54906003)(36756003)(86362001)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?23dIALyJFV4uMNofe+pratJkutyOBwdUq6oyUI4GAlOmKrJUHAeyS/7KRahW?=
 =?us-ascii?Q?atdrgbf5xYWXUbYFO06cVlH+ITTGbMld4Zx5RjJ5l+dpTNhbSYBxjDz5gnfh?=
 =?us-ascii?Q?JQLoeEs7KZ2Vs5GSOixim3i32xD+JDBC+g6adh8wMvPvIWfIffL0Eak5RBBO?=
 =?us-ascii?Q?qE+LcuekG7KT7ddEeg34hcEiZ66KOuXWyeoOeRwNo2qbd6vEzZvKPNdQILrp?=
 =?us-ascii?Q?dzN2rmQgCEOQXVr7nyVB4MI6ij4zncKzuX2KNxHYxsM4frKkEJBaTfpwwS0J?=
 =?us-ascii?Q?W9ibwlFWwPpbOdKp0tLl/oRZGLOiDUp5MuH+3bQIFbCOcZuWe1F7q5jUZ0ud?=
 =?us-ascii?Q?XFvnIOvtSiQAmXEMGndsdhJ+4C+J3/oEdpqdztpHg1LaKzus+R9FynjPucCg?=
 =?us-ascii?Q?x1CRrrBCdHYE4ufewOXAwxd3pnHT1W1121vXC11XQdxC2KwNsat1lqEACzod?=
 =?us-ascii?Q?CcuvtUXQ2dE7JQ0fYInBOFP0uJGJYtIRkoaj6VTG8S3JwgHtKQLIwRXsQ7RB?=
 =?us-ascii?Q?41d9I1I1DqZeNbDq4eQ+QFliHFYwBIEqXDWi7ID0CdSs3cDX+ch0ih7Ds55S?=
 =?us-ascii?Q?zt/fxfnv/6rF2EvD07WLw/kltts9uATN9otlSbEcuCgYJ4veOnlTZFMCVA8z?=
 =?us-ascii?Q?JG8/n7C7Xtg5+fpbp3eJH92wp5z1jyyBg9ZZ0J4PqsVxXbXb9HPIavuw8WDT?=
 =?us-ascii?Q?q9FKPNl/UQSyxoktpc372ipnw0S8CXQreKyGRuMI8cfga6oOaftM01fHpi9x?=
 =?us-ascii?Q?GzBoOmq63saMVlc7q8GLLZsm8OF6rBLTcdIjJPd21ZF8LoNs08Xki+uGHB5F?=
 =?us-ascii?Q?LFJH7miSbeCwGGM8Q7g39mLQa8XYg+Qlnp3zRCF6bEhZBM5QzSyRkdmOJpC8?=
 =?us-ascii?Q?HYMDfkVyeLrgbgToJMKfAMjES04w9jop3anxa/Y92Xhk8wDxuPf/oBhSIQZo?=
 =?us-ascii?Q?P8Y4cYEvytIPHraKqtBayv+fm1kGxwX5+MsHRddh0YDXhDX9/+GiAx35mlXH?=
 =?us-ascii?Q?p4V03zMMB0Fep+7uyxEgF8S9uvcxu0SUFjUwC4Dz6c6cVpHwRUzfJSrTweH2?=
 =?us-ascii?Q?e+Jvoq+iOP3kXDuUSx/Jc969micN8kL1Gi2r7ixY+4L9EnIzohbxoBZq7Mmk?=
 =?us-ascii?Q?tfuyNLtQV8GIiR/41MCToOzm2hS+PxfuYmNAEV6M5SjdwDLrMN2at+oXhgHS?=
 =?us-ascii?Q?SviGzfFj5G3W4Ejy8yp2KufaXgrqbqc1TYP6idG05oihYLSnokIT8G0wIp3U?=
 =?us-ascii?Q?Pew4udAupI+tPWnb+yS0JAp8Q+X7Nh7DNsfn0ustFWbFLoiZeX/wn+CZmYAO?=
 =?us-ascii?Q?27ICZyUiTydV9xYVHUzavOqB5yk7QKPXg/5yGDoi43KGrT2oNOH4NnGWf4O9?=
 =?us-ascii?Q?2txmK4kxKN9pt9pewxEcVSxPM5PAZnbdaIhiUNwr4SZyHtfyPKma565aU2eE?=
 =?us-ascii?Q?oL96af+OJxbV3X87n3KfHDCTke1+FRFBl301OUjGaN6rXakh9OipMooRKoci?=
 =?us-ascii?Q?U4X9BmuNxMO/6fKdQtrfotceMn2ru2GumGxmyi4/y7+WXOU2Ve/VqsUdx1hz?=
 =?us-ascii?Q?N+YkGO6nnpdaTBuSboN//46N1ftIe+CV8WqO5pfC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c950111-13d7-43bb-1251-08db19996f08
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 14:38:18.8109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSmL4V5ELkw+5ogLG08c6+Qy6KvUzhUPJdBh0AR8WzTa9cW1KFjCZSXGOLO2y7VY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5763
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 02:01:36PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 9:44 PM
> > 
> > On Tue, Feb 28, 2023 at 01:36:24PM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, February 28, 2023 9:26 PM
> > > >
> > > > On Tue, Feb 28, 2023 at 01:22:50PM +0000, Liu, Yi L wrote:
> > > >
> > > > > > A null iommufd pointer and a bound df flag is sufficient to see that
> > > > > > it is compat mode.
> > > > >
> > > > > Hope df->is_cdev_device suits your expectation.:-) The code will look
> > > > > like below:
> > > >
> > > > Yes, this is better.. However I'd suggest 'uses_container' as it is
> > > > clearer what the special case is
> > >
> > > Surely doable. Need to add a helper like below:
> > >
> > > bool vfio_device_group_uses_container()
> > > {
> > > 	lockdep_assert_held(&device->group->group_lock);
> > > 	return device->group->container;
> > > }
> > 
> > It should come from the df.
> > 
> > If you have a df then by definition:
> >   smp_load_acquire(..) == false     - Not bound
> >   df->device->iommufd_ctx != NULL   - Using iommufd
> >   df->group->containter != NULL     - Using legacy container
> >   all other cases                   - NO_IOMMU
> > 
> > No locking required since all these cases after the smp_load_acquire
> > must be fixed for the lifetime of the df.
> 
> Do you mean the df->access_granted (introduced in patch 07) or a new
> flag?

yes

> Following your suggestion, it seems a mandatory requirement to do the
> smp_load_acquire(..) == false check first, and then call into the vfio_device_open()
> which further calls vfio_device_first_open() to check the iommufd/
> legacy container/noiommu stuffs. Is it?

Figuring out if an open should happen or not is a different operation,
you already build exclusion between cdev/group so we don't need to
care about the open path. 

> df->group->containter this may need a helper to avoid decoding group
> field. May be just store container in df?

At worst a flag, but a helper seems like a good idea anyhow, then it
can be compiled out

Jason
