Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F25269822E
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjBOReF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjBOReC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:34:02 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705B2166E4;
        Wed, 15 Feb 2023 09:33:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJRTvosAUYVfxZspv/WiM4JFnMGTunEL1fu0YCUZViITnrSHV1rteMFTDIvWAFgoJlstph4ZG7HWbHBy2WmmbvUG+kZ3IgbiZh6sgWuV0TEGeUZOKTa/tZQInq4yDe2JvRXBrCdq/6Ziaev/5ziOGgrw/5T0G9yO8OowyebZPLtrY33C2B85471oMNXTUldzBjf6x+1kSNyxhWCJyVvsd0s4XQJ/k0pfgR5U7Ulu2fKbNyv2rS2MBgAjp2mrUyQYWAyTwKvqifiCP65gjPt/k1gU1odMMnC7zqIvM9iH7B7rCNfTWNKqxUNFO5tqjvvg74NRaIdl35ARfvWsighmww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkA2t2259YW9Akt2Rk6wc1gGtT2PoBMV9w859JI33Co=;
 b=aJLwv5SwH5GHZTgDsQg3JZ+5expbX+VNNSUZm78ado1Rr42xA++qsYHXCFNQXHqjYjsc9aIaxPzIWUn4w8QcTpCzvT4bEnZ/PmAW0G0S7E1eqs14oOadfvn0ChvtzahN0PcA2J12W6zh2d+tZ5W34f1rPplp9athr/8CTMEbhg8tYMQH8ULB1P93C9qp+iFeS0u/mzWEWb9A53PVpnLPmRirFhaIq19p3d5i0yX4kKlLMR63Nt8dPkx3P+yS7DE+C7ysl79O/LXSai+MhGOkAcBNVNGkqVt07bMJQz+oA+7Qu+hqVaJL2EsPt5W4ooLbcDpfuLFes1HICc5kuZyVYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkA2t2259YW9Akt2Rk6wc1gGtT2PoBMV9w859JI33Co=;
 b=URjo8rGehSAKIHR/3PGAXs7ecrOS1Zot1Imo5kAjPBtuVxcX93u5FWSo1y7tVhCo6RZlDJHB1uyNCWNaVeOze5kSYUdecYZOopNZhe74jrf4YGQ1tUx8tbZ6O1iDP5t7s6xs8o4IVb74JfgSQdZCecDa19AkLodsrCyxEPtKF6HVehGcd3Rk2ozxZiIuPcInKS4ZXTD1kt8zM+LflxxeVIvg6DhWGdtzMIPLUkmQJli3Zxv6P1s3gndPXVIgm2JWmRp19IrU4FaFXklIZmrghP6BCpUrF4EpY15956kmHmYvdqADeAzik5MFMrRAoAgbPIbHYzHKoPY0IXX7X7UxHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB5008.namprd12.prod.outlook.com (2603:10b6:5:1b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 17:33:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 17:33:52 +0000
Date:   Wed, 15 Feb 2023 13:33:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <Y+0XfxeDwHGALzX1@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com>
 <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+zSRklKkL3rc2FB@nvidia.com>
 <DS0PR11MB75299F5D92AAC33FD8690694C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+zwSn63eA7HrefO@nvidia.com>
 <20230215083234.194d07a9.alex.williamson@redhat.com>
 <Y+0QjaIWr84eVzsp@nvidia.com>
 <20230215101935.6416b39c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215101935.6416b39c.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0151.namprd03.prod.outlook.com
 (2603:10b6:208:32f::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d82282b-ed98-4319-5f43-08db0f7ace13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2FVjk/ncw7lVrOMhfdKWsO2N6IiIHv2vG+Ga4+stGQXD3eD3Ee6uHMRKb8m/52f0m9LzV3KZ8FutY7eN3vF3k15XY150ETzjI5DiMzJLt+n9Yshu9YwNd6w3uOvyd1w+TtUAwMPoUD4JlY1/S+ERXZ/Z6GfNZAuLnamBEkwrckrYaJ/YOYtFbb51X5E1rzNiHpxeoWWO9bhpQMZ9NKWEaWSlSjVdn/6u+PooDuSXm68cBooPOakWxD7yY1v04XnQ93NIlwwC31Zj91ogVxkQgQgokqu/U5HQBdKMYpSKJpB+jGc9LFnAg5Xoa4BkJalDuKHCX8FSQGQz7l1qVe36v8ih972yvOsbRQGzhWxG7u9b6mfmYal/NlQSGyxsW9r1aD/VbF03U6/szXf6KepjFrrE7WeXxQMtB81bCUfmJH3pdmWBVV5nWytCgpyaAmF8hSjepPghm/iQF9QEp7dDqUF1ZbSngns19Ii5bxWRdAYw4+Qhuj2vh02jutpcK/YZM4cDgyCTNILYmfWB64rDxHumf2Mh+lLTwqtsMYdV2MLkkNXXV2WCq6k2A9xwISWOj83cQfXugus3QGg9UAXP5VOjmPfocTGS+1jbx6TZ9H3DXD5+4HcXe5oaSsQaRp8+nNH9Ct4hge9Mahm7ivCxBaE1XXD5EOEJqGd0KULGtk79iPilpdxAIuohQKZVVnV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199018)(83380400001)(86362001)(8936002)(2616005)(4326008)(54906003)(5660300002)(66556008)(36756003)(6916009)(66946007)(66476007)(41300700001)(7416002)(8676002)(316002)(38100700002)(6512007)(6506007)(186003)(478600001)(6486002)(2906002)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zg0ZV+bGX2xlZm9hnSMIrweXsrxerIbh9CX1iyiAGBNG9LO2BZdcU9Acp9B6?=
 =?us-ascii?Q?W0urUJcqUP8b//CMKCGX+NHEzxdD208l+FVuZ4CKKCvrH1GK953X4Eboh0Z+?=
 =?us-ascii?Q?X1GeVt6YLJK6MeBRRbh9g0j1CNbvra35QlMwuDoh1x+dp8GOKRmnoMYYVFbg?=
 =?us-ascii?Q?KsjJ2k41tPcLLcggUP/0uDgmANEr/j8jBL+jNlxGEqahCecq3cgRg5C3ms4c?=
 =?us-ascii?Q?Y/UGM7Xd344Ec7dAwFudNPCMgar8SCiTBgUcgSyVPIlQSeGSiNYejaGxY+/9?=
 =?us-ascii?Q?DS6FdWDeEu+Ho1tqXqqH96Q3yxd+na8d5w5nf7x+9gjKOTOXyhBgDRCQrzzp?=
 =?us-ascii?Q?p0uxV9Vfw0GmGfSRueQvvtF0yKMvMbvH28sCOuB7yZdvQ9VIk3EVejBWky2e?=
 =?us-ascii?Q?B2soqyTnlQSMGSa9uy0YR/Gc3DzXGG7jViMsHOvhz3T8uYEjCnygDQx5PavO?=
 =?us-ascii?Q?dm+k9Jzslf9GTxS5Upjv1NeE+MJWrhC5nWvAtNLMeCQzR9+QP3rE03CZj/kV?=
 =?us-ascii?Q?kpAEBwv4abrhxSCHON1rtOjC269D29jD0W/ERjw7Qn0XQHhXCDl5zODQHUkC?=
 =?us-ascii?Q?JoJ5ShtLaGqsxMKoEgXH6P8l7KfVmqAGHgl+ZtYvpWvwA6wy8M0Dd8VaBpQx?=
 =?us-ascii?Q?yC3RIzCpGmceWGpwhJ3+QOiwXTuCQyfGv+Z2EXd/ym1AUd81ZRP6aCdEmb9t?=
 =?us-ascii?Q?36tHi2NftARpSKUjjjBQe2ynamZjfivqapcZicwTXYtCePJIOAM4AXhM3Prs?=
 =?us-ascii?Q?2cRu8bsdq37XbV+G7XyOCDJvkxiO+EY4MuL6Z72McZSWd9Rgl3LmzigLxZwN?=
 =?us-ascii?Q?8m/xh7vMjm5JfOkevYkogZbNgk2M2WYVDfCXq9PyjXbqSZr6dhqYC8jOcL2P?=
 =?us-ascii?Q?aPe5C2mvS37mGh3sHPMZWiqExJYgIGazycWiKsW7z2VjfUI6zwYVJXuXjfSD?=
 =?us-ascii?Q?KcvIMCYlWgJHHuAQ9SI98ShW3RC3JUlCInyuGGviWvOXQKL9X8jCf/MiHzaY?=
 =?us-ascii?Q?dhoPMIR9/roKkvMX1nwnEA2l+92m/SZv0x8+tgvd5PZtIMimINWHiiUW0/cr?=
 =?us-ascii?Q?4mVnKTN2vVsiLQeUYj5YgNf7F18Ffljol0jUbdqxu6stuLt0+If0OazVSL1x?=
 =?us-ascii?Q?4MZcS8dMCmkrHIAQwfgbMmHv3Sw7268xxlarEMjUloneSjP+SrrS13/RF5W9?=
 =?us-ascii?Q?DnyuENovf3K4uoOlsQ3pW5coIaWnn9zjrRTZVZiCC2zh/zznH7uee3KM/jzu?=
 =?us-ascii?Q?+Vq1COMQvdL8mcvUM1JLM/9I+2XpbU12e1rzDcP6Jkgm2znKTrsIBiZwOeIw?=
 =?us-ascii?Q?HakR9iL0EMXcoeMb8fDc1/RI282V24aeP9fjq4LvKQR+IWeavO4hr6OI8BaU?=
 =?us-ascii?Q?qqk6wTueHUj0G6doHJ5f72IC8GuHXneASaFtcXuFjXNGu+bDzsu0+HtrmtL0?=
 =?us-ascii?Q?MxY8BTeRDXbD0wE30jT0c5L2A0dKV3Vad3nEt6F/qblCGNcdXALIZCSoHKhs?=
 =?us-ascii?Q?SaHQhG41z1U1cpwwDWEVQGoV80NkrIsrRNe9BJCkZ2Xf31a1EKPyqVsfihhp?=
 =?us-ascii?Q?yfxp2QbdB2nE3CaOwMQy5U41apEygW8UJfjuUvFI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d82282b-ed98-4319-5f43-08db0f7ace13
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:33:52.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGXe3mnonZSEa1OyOuuRLB6EUPUYc32bBy4odD2LDi0rIeIFP5isPLTCR0NU+TTQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 10:19:35AM -0700, Alex Williamson wrote:
> On Wed, 15 Feb 2023 13:04:13 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Feb 15, 2023 at 08:32:34AM -0700, Alex Williamson wrote:
> > 
> > > We've discussed this with Paolo before and I believe the bar of proof
> > > is not very high.  I suspect it's not a problem that the device itself
> > > is not yet accessible, so long as the user can prove they have the
> > > ability to access the device, such as access to a restricted file.  In
> > > most cases this isn't going to turn on wbinvd anyway since DMA will be
> > > coherent.  Thanks,  
> > 
> > Isn't that a second problem, we don't know if the device is coherent
> > until it is bound?
> 
> I think this is already accounted for in the conversion to device level
> IOMMU ops, ie. device_iommu_capable() follows the
> dev->iommu->iommu_dev->ops, where for example intel_iommu_capable() is
> only looking at the capabilities of the IOMMU managing the device.  We
> did some hand waving simplifications that was sufficient at some point,
> IIRC.  Thanks,

Oh right, I remember this now :)

Jason
