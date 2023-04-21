Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9556EA515
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjDUHl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDUHly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:41:54 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF39F1BD5;
        Fri, 21 Apr 2023 00:41:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbplUdWIqGlfpu3RSoWAwPJKJQtSCabBs0fi1rM6ndBS0QP3vJ/4RF4fjTjsHzOKN+hMbUQxJ1qDbqKITAqDJ6LrtH71SZetelxAXFPLjMkvxAq6OrzGMVE+Bb9m9V01eqbIJD3ZL4zfra3k8Eong8LTJ/RLNqjeG7rKOoWrVpiugExqa8Ni4NPhT3ixSy1WPxwoe+cAjzLYqXl3jNCI3cXHJn75DAQP85doYoP86JB9xM8PAtMd9UbbL8LdoD602li6yQvuS2gY+yzzNqVeWH9uyn4qGwmMzZC8BVBLIzEh60i/5h3dH43T12HCgiw/ThjehnabLJl6YKmkVTaNHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXTb00Ikx3sEtgKakVn3ifjSbqFLf1xNF3bgj43n810=;
 b=DxLX8bTupAPzyfFGHKOKj5gPy2Am8Yyh43zyF0ETLKm3v8B1MCTTod9p1zoNkk95kVDM67J1AZtE3wF5A5fMTgNQAzH1I2ahPTpJmD1JhXTWa3KP/DgzF5SIHHI3Dp67ePmxQPIAKzJvIdWIHycSaWla7UFVTEjHGMPZxzq+BpQ7GKWLLQmmbuR4bTig3/0eR+fDF3hXYtJODqy6ofYeKQnNGYKuNb+XWE1jcS1JwKjCKGoBzm0afK0uxloVMnbwWBK7ysfj8MjXWIQNTaM0z78GcrWmHlUnpI5xf8GMNrIuRQgT9+XOmUO5Yz7zzKEtMP+UWBtpKlYekSf3cc7vog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXTb00Ikx3sEtgKakVn3ifjSbqFLf1xNF3bgj43n810=;
 b=inriCS406wQz0cJZSjZHSEHeYRKTXNrjZBjpsoConAA+TAX3y1HGdILrkLRzv6L8Es/3/rfLOT1Ksu5Ni4kc58blZXcUKJSWecQ/xS1uB1/c8jQcj18bYSuQzZaq4tNSl6ye+U6OZBUi5O5p3VWjssCDs3hC/Ey9L6WZfmOxMCVaoKu6G8drdzpfrw9mmLYHf1KHaULAdcZ3EQ0nxGWhaSCmgszWaVu+Wp2XeprFjnjorWZ9lq/bWAC2tRKBy8muS2ZV5kt11HemXg6GKEXtNz5b6nDP+THXiBbWoqt8N7AXkRDIcdMEOhRGcokU4zeMVs6Lhi1uGChBRsc2sYcdng==
Received: from BL1PR13CA0353.namprd13.prod.outlook.com (2603:10b6:208:2c6::28)
 by MN2PR12MB4519.namprd12.prod.outlook.com (2603:10b6:208:262::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 07:41:50 +0000
Received: from BL02EPF00010207.namprd05.prod.outlook.com
 (2603:10b6:208:2c6:cafe::ec) by BL1PR13CA0353.outlook.office365.com
 (2603:10b6:208:2c6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.15 via Frontend
 Transport; Fri, 21 Apr 2023 07:41:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010207.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.16 via Frontend Transport; Fri, 21 Apr 2023 07:41:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 00:41:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 00:41:34 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 00:41:33 -0700
Date:   Fri, 21 Apr 2023 00:41:32 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Message-ID: <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010207:EE_|MN2PR12MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e8cde0-7c01-4a90-c922-08db423bde72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S44CAo3hzqVOMkIJmOTX+P7IR8fuFsvGanDdjJzBQtFOoLP/+T/KsZNRWboCeowbS01pD4kYZW5AbE3egtBbZ1Plm+vORK3JA3l/vZFmjUh+TqmEMD8t8lQSWAgmacx/caoFA65jhI/zfqnJZYEJOs0Z8EJteJ4KsPyik53ZNWGggz687AQBdACGaJS9Rud6QVGtE1ypplJOtyuYX5crde0jb6U8RoEr+aHpWj4IUwxvJ0fNZPeH19lGo2Xd9JyYU+AlIA0E3jYMOKv9GpaKvyfTjfysqfiWfSu+NaMgNtgbK+RgdpXSvP+o0NKwjKUatV5zZGeGeXOscWB+QG9mrNg2BI21t13jf/JjtVTI0VCUHJihnov2+Xk4/S/TlSfHY4dGMO4K8815kTWkOZQCLPO8gwX64fCBXTDBcT2I84kGXpQTyzu5dNVG0M/iy30JXZ9v3+tIdV7+EBvD2sajkWFjohsiVmed1XwxpEWe6cUYnx92ETR0HotRXoyiVgCP0eLXbGr5P7qvZSXv0bjcxv9bBxnR7DvgsW9FV7tC2Tplmi8Y5qZE9KjX9By3qxx9ZKyYl5g72QnZAIKesJ2JOuLNpeMUQAj/XOTf6jtnB117zHfLCBxAlh+uHZ1kwmqRB0V6bvFCANG9Q9lAk5LTf5mBJEuVcQ1mC5+SkoHT+Q86TUoDjkeoWURBGbCRUcm6oSM5ljb+4/xBqB4wtZqbjUejsNDseX6fQgjvzqYGSsq1pVx/uuCAhzIssbL1VeEhGwpSXxPdMYbqsDyPPm0TJ2Rj/c6yvk7/+MSlSfbh3yNmnP4xQmXHPESQbe4cevlyDFXeOOCfuW8fL/lf8obIW5ik1I1NygtgCLlUNhxcJsbCMrnEGL4yfylDOUilTObR
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(70586007)(33716001)(40480700001)(6916009)(26005)(4326008)(186003)(9686003)(316002)(82310400005)(55016003)(8676002)(8936002)(2906002)(86362001)(5660300002)(7416002)(40460700003)(478600001)(41300700001)(54906003)(47076005)(36860700001)(83380400001)(426003)(336012)(82740400003)(356005)(7636003)(70206006)(966005)(341764005)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 07:41:50.3749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e8cde0-7c01-4a90-c922-08db423bde72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4519
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

On Fri, Apr 21, 2023 at 07:35:52AM +0000, Tian, Kevin wrote:
> External email: Use caution opening links or attachments
> 
> 
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Thursday, April 20, 2023 3:48 PM
> >
> > This is a pair of new uAPI/ops for user space to set an iommu specific
> > device data for a passthrough device. This is primarily used by SMMUv3
> > driver for now, to link the vSID and the pSID of a device that's behind
> > the SMMU. The link (lookup table) will be used to verify any ATC_INV
> > command from the user space for that device, and then replace the SID
> > field (virtual SID) with the corresponding physical SID.
> >
> > This series is available on Github:
> > https://github.com/nicolinc/iommufd/commits/set_dev_data-rfc-v2
> >
> > Thanks!
> > Nicolin
> >
> 
> there is no changelog compared to v1.

Weird! How could it be missed during copy-n-paste..
I recalled that I had it but seemingly lost it after an update.

It is in the commit message of the cover-letter though:
https://github.com/nicolinc/iommufd/commit/5e17d270bfca2a5e3e7401d4bf58ae53eb7a8a55
--------------------------------------------------------
Changelog
v2:
 * Integrated the uAPI into VFIO_DEVICE_BIND_IOMMUFD call
 * Renamed the previous set_rid_user to set_dev_data, to decouple from
   the PCI regime.
v1:
 https://lore.kernel.org/all/cover.1680762112.git.nicolinc@nvidia.com/
--------------------------------------------------------

> Could you add some words why changing from passing the information
> in an iommufd ioctl to bind_iommufd? My gut-feeling leans toward
> the latter option...

Yea. Jason told me to decouple it from PCI. And merge it into
a general uAPI. So I picked the BIND ioctl.

Thanks
Nic
