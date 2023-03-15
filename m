Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89896BA7DD
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjCOGdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjCOGdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:33:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B354D62849;
        Tue, 14 Mar 2023 23:32:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noQVJ9ls3NoY9ddTjR7pC1CdEfGAe1JO6q+iISAc6fBOVwacZc6fueDwKCf758tnyvhFlXq+VDJqglBa9v5A7W0jclhIuM38YJsIlzHzCxtcuvHP2k3nZl6sCZCZMR4CHwJVoV9CyT/vAITmEvtWQ9qoLNNaeBedAatuj0gLQn6dwI63YFCCauhNiu9fA2WScuRWOjyAwZVLbtNoqX4i+tDWY8SqJX6w9Co7WEfcXJefycIXhR4Sq9NR029veXD8X2EoB6cNWSNAejvSRO53BarP4zQDEqWtRBj4MhWAXs9PJ7CRRUjX/l1nxHQoDKKG51xJkEXRIXpV11BKk/nFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k96EtWaruqsmv/TPv7Rv3RjMr9nvigqzuOzu3pw9kU0=;
 b=oL4gANAe2oVoIPb2FCJuXCB79E2NF2CC4gXEH5n4nTCPV04215h2QixV2u26OqsMUV490usFDJWtRABxBw17lwPe/Qo1WcRAwa1lAdikfoqw+ErlYMSGJnXcguLHLMI/NBEEbrLdmf0zCp1eCBqnkck/xvLmskvtWCWlSx57FALxfG1FMgI8Q6aM5b7bYEJqgaYsRSILI4C6/MGSh9cA54lj2PdGbknciNICmEJsq+N7pj/qy0enDU+S86GwmdB2EGhOMW5RUdazuufe0j0ajqVlveY3eZJ1uvrCp9i+oGvoK8GWkGZNZur3hM/ZSbJSPmBU9+wkFKmF4a48R/0WNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k96EtWaruqsmv/TPv7Rv3RjMr9nvigqzuOzu3pw9kU0=;
 b=R3mM6gTPauwonUJDAmAomXt2KBCcC9GMa+RT0GLws9zxR8aAf4A7wkbaB0WGtx+M1MNFcnAO5rnzcfdtJcrQhAqe+lzJ4yrqHS/XrhTaJaTtrf+859vyiosHdmsBNyTMVbTvgHPbiQ5oP4LUqfQ2xtU14VtgNyMFNjSslneYyPEB9v96fzwXulR/Uho2uixRoCWKM5u4URsvupDnQ7X2SPq09HIuBOSXWdjZ+UUhdQSxSPLH3mF24wePHajpmy1KOaI4/maUSrL7pR3c8XYjGeASV9uVPWtMome+s28RTSN2bqP5KWwvTI/GyrZQjopnFNyH1nx34bsd2xsW1LWA1Q==
Received: from DS7P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::32) by
 MW3PR12MB4475.namprd12.prod.outlook.com (2603:10b6:303:55::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Wed, 15 Mar 2023 06:32:56 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::21) by DS7P222CA0026.outlook.office365.com
 (2603:10b6:8:2e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Wed, 15 Mar 2023 06:32:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.11 via Frontend Transport; Wed, 15 Mar 2023 06:32:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 23:32:42 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 14 Mar
 2023 23:32:41 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Tue, 14 Mar 2023 23:32:40 -0700
Date:   Tue, 14 Mar 2023 23:32:39 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT031:EE_|MW3PR12MB4475:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cf99567-1e70-4b78-44fe-08db251f1ca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TykJXdQSUQi2UyqrsWIfBmasoLSAOZZQdK/Uw5xUynEeXLtYi+k1zwcRJWg1TnVzZaDZupZGwX9WHQhESaD3Jrddo1/M5gWQ8WSbo9HVnmYuA4o52G+WolBarFeUkoL8J++HbSfhMbcf0t3dKsll5pq7IfOn7zGgyDvTBJoxQBoZscgWs3FTti8e6zYvwOBHCuzK4acoKnasg7xKmdxpJHc+VMoLrs0quYddeZILSg9a5vNAYrfrqsbBKOBouV3a7YZ6Plvfeot43gMpXUctCNb6PIO66VfKsN9v//ixo5N6N65EN1w7gefERh8OnrYfUlOhaw4i0bDy75G6yml7xnNx81irS6D3pxkvyBKUOtOLcZjvOK+lYB2w8fd/n47gzC5bwllbQaoAWNrSibnQZz247TGEauwpO9f2GZ6IUH9/XX29OdlK1YbeO3ocB2aCl6hxskU0btEeeDGiDP8kVbIFGXQnWmCcRFmSFLM0PEi8YlobnaeOJmRoc6VF4L9l4Fs5jAijvFJGLLTgkcWT2R8uG6LZ2rmIchR50KDrWrza6XGGFUn7hDBIrls+hAmhynr+DTbvTFL21a8OxYfEURrmfwaVDQcONMmdf1UaohU60hhkfhowgs400FeQzIWikUKYHXQXb2dfG4el8idJSI5yVDfsgdR5f5XCDbutinV66TVnTaqCyQW9XeUPF98GZH2fyDBIsNowZYPvjaoAKdSjNJ9v/x6Gmq/bwzhbri8vePFdEZ2TbE47bSf4WoLW
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(40470700004)(46966006)(36840700001)(2906002)(7636003)(82740400003)(83380400001)(40460700003)(7416002)(5660300002)(41300700001)(6916009)(70586007)(8936002)(4326008)(40480700001)(70206006)(356005)(8676002)(55016003)(36860700001)(316002)(86362001)(54906003)(82310400005)(478600001)(426003)(186003)(47076005)(336012)(9686003)(33716001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 06:32:55.6654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf99567-1e70-4b78-44fe-08db251f1ca8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4475
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 06:15:23AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Wednesday, March 15, 2023 9:01 AM
> >
> > Hi Jason/Kevin,
> >
> > >
> > > Perhaps we can have iommufd_access_attach/detach in this series
> > > along with a vfio_iommufd_emulated_detach_ioas, and the locking
> > > will come with another patch in replace series?
> >
> > I recall that we previously concluded that the unbind() is safe
> > to go without doing access->ops->unmap, because close_device()
> > would be called prior to the unbind().
> >
> > But, to add the vfio_iommufd_emulated_detach_ioas() in the cdev
> > series, we'd need the access->ops->unmap call, and the locking
> > and "ioas_unpin" too in the detach and attach APIs, right?
> 
> yes. We need locking since detach can happen any time with
> cdev while driver is conducting pinning.

So, this preparatory series will add a pair of simple attach()
and detach() APIs. Then the cdev series will add the locking
and the ioas_unpin stuff as a rework of the detach() API.

> > I tried a bit of some update, across this series, cdev series,
> > and the replace series. Though we might be able to simplify a
> > bit of this patch/series, yet it doesn't seem to simplify the
> > changes overall, particularly in the following cdev series for
> > having an unmap() call and the locking.
> >
> > Then the replace API would mostly overlap with the attach API,
> > by only having an additional detach(), which means actually we
> > only need an iommufd_access_attach API to cover both cases...
> 
> there is a subtle difference. to match the physical path:
> 
> for attach we expect the existing access->ioas is either NULL or
> same as the new ioas.
> 
> for replace access->ioas must exist.
> 
> they need different condition checks.

I think they can be something mingled... the sample code that
I sent previously could take care of those conditions. But, I
am also thinking a bit that maybe attach() does not need the
locking? I can do a separate replace() function in this case.

Thanks
Nic
