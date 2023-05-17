Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF7707101
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 20:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjEQSoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 14:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjEQSoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 14:44:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E01C1BC;
        Wed, 17 May 2023 11:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nrn9xdDCU+dKtUlQKsnjMQbCnAqDZjoWZDQI26mSjvFgoxzJcdI6KlCGOHrSOHi6DVkqBJcDO7s17oBVd3uHE8yi3Sj7w9wsGjoAiHHMopXpTHTUD7dGX8hD7R0xAxX/AbZvw7qBbH1vXONsp3pkYR83M0BCn1i3Z+g+72lpx6m7Xi3nK5CPVcB7YFtcv0/7dDYlzbNDlL+xHbjXk+TUFQGfmUt0LL8IH7EUgjEutc9fsfrpAtrS372zcYxNOxdBcgCPlB4iM1E1b1OdhM2PQsgNQoFzXwpLYyPtTbRURvIlFJJ9oeVn462vFoJRAQOIG4vMGOQ4ryWNyq0PbsJnrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1p4EpK8MLmNgw52YLKwlAcDtcrydMXVoFrQTL5Kz45k=;
 b=gYsVhglR5tjZzXgWizF3UNK+Rfkl+aJGRpoVySRj9NM2DklFqYXBtCds1CF8yLu/bTz+gXpVCbPf407SF0G1LRcuidkItcR/GPjfUaOTVcnhr1Y1KetAaVCViM+ICBjbN7xMC4/pVXajeCfa2fkyxYuFJxUo8PofHsj5iLLZIcc6SoEyGbe5moo0BflHIfIy02oEiaBUERPTNx4Nm9IMmpqZ76vt/9PVR8IZjew/M8yVnpP7Kf3L0FUrQ5Jgv13IQdkmW7+RuB+hpXwtGfeQMFum5G2SJyTsJi0zGHRtnEEPaZJiazRNzfWrFLDGjWQZr8heHDVvUAb9IMms7uhcjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1p4EpK8MLmNgw52YLKwlAcDtcrydMXVoFrQTL5Kz45k=;
 b=CJ5V4IyQU1po2B8jqMHf51AO681TDsEgXNuu+c/0IT4dmCKJW7mNksJ0NbWK1cFbGTHlyK4c0PXAL+X5bGoamQ9nngaIPePUUuS9TUWcauUdZQNQNZ43Yjhx5+oxg77+j6ocjXKRcdkbLub8wRzLTOBtbaK9fZgCL6AUlEiWvG/5xihb9lzFMmQkcAvH90U5zJVYBVc7+U1VP38WzzAVIdEL4we8u54XXT7MwvIgUzcqA4kQazYj5fReJZiK9cDILGQsn/E4PWOxVGIDQ/m3mTwN+mWsuRdeNrIVPrYTNXl3mtNhh54GVoNtVykik3V6Yav6gDxYz8cNDZmBgcOzIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5344.namprd12.prod.outlook.com (2603:10b6:5:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 18:44:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 18:44:00 +0000
Date:   Wed, 17 May 2023 15:43:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Message-ID: <ZGUgb/nn/3jn51C9@nvidia.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
 <20230513132136.15021-7-yi.l.liu@intel.com>
 <20230517121517.4b7ceb52.alex.williamson@redhat.com>
 <ZGUbY6yVfbd3hRxY@nvidia.com>
 <20230517124032.4bac8e0e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517124032.4bac8e0e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:208:234::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5344:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e7c984a-e49b-4c20-ee28-08db5706add1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MaRfdQN9xfsdi8oqSEFOWSDhPdx/s5sJ+ZpxLMcMcM4fJ1Gq3ooeMNJ8c3xC/SeLyiY8kQMT3QyITJ2VtxxzrnIEadlEw2gEbPmW+oKP7jLAISg+ZaynS40jnIc/Y3dTzqLEel1xt5l5uZhWfv4eILazgoRqRFe0BYSO9V4PJkmq0ZZa91QvFicBSksVnbBEEO7y9GxeeyZsdUapQy3XpFWWbGVbs3xH7+fUy5umvbVyuQ8SEFG/cgvW37KJHaGH6ONTImMKCKkHc9RNeENLAM+na/gf1K8i9uBFZ6w2xzMMKWqOgThw7khuO600M4irYmJMzXxGkV+RBtjW9nCLMiOpIssCzHqt9Dv+5QB/CAPcMSPCD3sFNVZ9GgRtRLTFSNx0RlAh4ZEtB2AJ1zvOWsch068+09lxDUXuxLS+fJcJ6ci9xfP4XGAnyeQPv+oJqmZ2jlK6Z2P/Tw/H6ajwBPK/KYF/mQfncHUcfibYMlI/8KBDMoXFC5fK/AIhUN5PZn8zLkO8y3uPA3cwBMN8+YtFg0qQdkjTRMs+FlKbt1nGXF4KCDWjsVjpZqF/J2Go
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199021)(66899021)(83380400001)(6916009)(41300700001)(7416002)(5660300002)(8936002)(36756003)(8676002)(86362001)(316002)(66476007)(66556008)(4326008)(38100700002)(66946007)(2906002)(6506007)(26005)(186003)(6512007)(6486002)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D3cHmVdWmgaqdMIVBLaFbLhDAbKlqz1qPbZRRQzkgB9rl7W+oKxJkUGmSI/G?=
 =?us-ascii?Q?L+w52drakNEpP3VNSUGnBYcapa47xVU8V3hTEtlM3QmvJLrLJCbDCokP/lIv?=
 =?us-ascii?Q?P7UgrqlnnaWGYwuhrtUAZcgsBLykKqx8zEgDg5MC5lMvqjq8c0A7E4fsp+O3?=
 =?us-ascii?Q?LxzoHe6pIf1tConZSweGid5fwjETYBNZ63ZlcgjLRCiV+yS6W7pNwPti1ChP?=
 =?us-ascii?Q?Ghhtz0Up63uNhTzBNtqXd4A/KBHMfvg2jLV1SBpajcIsagitTYCcMFp2VXzx?=
 =?us-ascii?Q?egoYSTbRPB7GMSwFQVHwsor+DTKolYahbygavxULr9OOeKGJwI5/8xo3d1gu?=
 =?us-ascii?Q?tP9K5l7amxWlIAQUfgrH8LFQb3JODLvvNczO1ks4OoJp1zr/E/ZSAH2OEW1E?=
 =?us-ascii?Q?P8o40D7G+8XFMdMyn1T+bGn6Z6vbMPEDRzAjZBCnJWJ2w20MJL4gQYODPTBP?=
 =?us-ascii?Q?LgwUaPyJuIgvRxKWlAKgBgm0xHEO69G2ZqAt2sevaFzUBma9w3BtiUBcnFh5?=
 =?us-ascii?Q?SeyGmqnjYDY9QgHfv9nqH+eRJ75OnkuW7g1oEGLiKuI2tOY9EsN4dBNUlUwn?=
 =?us-ascii?Q?QguVtfiOBSzixrGkLGL/QsnMzRJwKW83yxUE8n6EOAGzj3NqMHNTphDIgU7m?=
 =?us-ascii?Q?45tWkZ53GDTapUZDkzdqU9IIav8nxiObj6ekkk27UYqcjwfmrj3k5trg28BL?=
 =?us-ascii?Q?XG1Qq5X+Z34Vb6nM+4a12SiRgfH2R+gBOZDD7z/Ofp6lqfIcerDwD5zY5wuj?=
 =?us-ascii?Q?3KvMwwRmvv25oTdyG27XZJOb3FjLCs1d1HtWuR5vNs4NDMf/R10/xxCQC4f6?=
 =?us-ascii?Q?7x1M6sAnbcTi5XUZu3Mdw7n1TDITNes/ZAPqXzcE2gKrrxdUZuiemlDWci8R?=
 =?us-ascii?Q?tS6uwQ1x6o01kNi4hzch8XDNZG/Tor6H1+6R93n9pi9a1CdnY21H0N7f5vB/?=
 =?us-ascii?Q?y+FKKiCHLFck9tA9aCuLW239zbUaF1zDg7gJuTJeYj1Hi4HAelbkrmtAUU1j?=
 =?us-ascii?Q?5WRfVPbGHUi9HJYorHkQ1yIuENJb9ntja+fVp03oT6UNcmegT5hqWygu5Ie/?=
 =?us-ascii?Q?/jA99xOSAIayIqs9qZQB0NF+aHb0OK0CcwekNqTjnULvK/JictmN9Lcq8D6v?=
 =?us-ascii?Q?bBpLSAnCv1//CFLEVwHqGgyV8CXM9mt2RCy/cC3ci4htbswyv7zv2eWiMhhP?=
 =?us-ascii?Q?HWdX1+B/xzt/HO7RWxv+ld+Tjc7qPJjWifnElwSlyr2qDQF4N1yJaywtwFHO?=
 =?us-ascii?Q?pWUvZ8ZHYV7zLAmewAsBMlAXg2JmagoHzfYw0O2WwPf9MXFzOcIUSDsKHr+7?=
 =?us-ascii?Q?6VNANafsS5Yfk1afmxJJoitH/UtD9QAvhgO9V5hJZkxdTqn4VDPzlGM8vxn+?=
 =?us-ascii?Q?WTrecB4YVsovFj5RJvUpADnQcjoBKdZpao7n6e3ZXL4Iq4WsqcrFyoMqZnFG?=
 =?us-ascii?Q?ZNkuCf2/eHaQ6EdZjhRe2m3S2BgJNeKGT3AHMUHYSxQ9jMD8KXOsHTdAVnYw?=
 =?us-ascii?Q?vX/ra71ggLsM1V9FMVj+JvyVGdhMjLKOGLkBEBbNbRT6TX6xSbZIjEHeMwHN?=
 =?us-ascii?Q?c4GNuruEVEnjavc65fRZFQxpTktMYvCftstcdb79?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7c984a-e49b-4c20-ee28-08db5706add1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 18:44:00.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIKKNQUcBtGJBDWg+wmVCBzVvlu4zlOczetS5KFx8q5mbxdERizFzvTrGcgKQyLt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5344
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 12:40:32PM -0600, Alex Williamson wrote:
> On Wed, 17 May 2023 15:22:27 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, May 17, 2023 at 12:15:17PM -0600, Alex Williamson wrote:
> > 
> > > > +int vfio_iommufd_physical_devid(struct vfio_device *vdev)
> > > > +{
> > > > +	if (vdev->iommufd_device)
> > > > +		return iommufd_device_to_id(vdev->iommufd_device);
> > > > +	if (vdev->noiommu_access)
> > > > +		return iommufd_access_to_id(vdev->noiommu_access);
> > > > +	return -EINVAL;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);  
> > > 
> > > I think these exemplify that it would be better if both emulated and
> > > noiommu use the same iommufd_access pointer.  Thanks,  
> > 
> > Oh, I mis understood your other remark.. Yeah good question I have to
> > study this also
> 
> I guess I also missed that this wasn't iommufd_access vs
> noiommu_access, it's device vs access, but shouldn't any iommufd_access
> pointer provide the devid?  I need to go look why we need two different
> methods to get a devid...

At least this hunk above makes sense, access and device are two
different objects with different types, so having different ID
accessors is reasonably logical.

But it is a good point that this should return the dev id of the
normal access for a normal mdev too

Ideally I'd like to see that we always return a dev id to userspace
for all vfio device types. Then we can rely on it

Jason
