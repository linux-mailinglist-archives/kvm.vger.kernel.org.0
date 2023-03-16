Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CEF6BC270
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjCPA2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjCPA2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:28:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1159CFD4;
        Wed, 15 Mar 2023 17:28:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYf9MJOk59JySwVzu4dQxyd2SrKf5CLRV8+zAzdCym67/MTeqmr81YVIvJiHw8duWiqrLpcIQMkKpYAZQsAlNDudxO0SQeQboCJMZUzOCYOqPlKmB8jyRWzr+khKmnfthbZFq68PXbe+MlSIWnZlT4AVup9cwfdemiZTrq9Mqf4qFNwF90NWWU2Gwcdq+sMApiawQGzlg6zflWv35e8VGnhJ54+BjjPrOcurCRH0tVxTwE0IQeVfqdxcXEbAL/Yhn3Xqs4Z86vn+UPXDmu0u64qzR2r4pBzmMKUGW+/yBED3kFQ/q4psFfp5ul2AqQ55RruiVWkwvpZwFhB32nwHfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWy47GqZKWEDZcAHHZ9VMCtkQEh2YuJzZFZYivc7QLA=;
 b=Sto9sXyO2CKbKp4JXrHSs38+OMDH2Al1T+vdnEYyqdOhjmw3nIZbV+uvWnBhkFAeKy1YzDzdCARmD3JbZ8Ypo4lAiCR0zWyPXPqMyA5NwyShaRbRJc3CuvjHwJk3kKLGyFmxr7A/gQCdL9LWUsLcNfpw9RnJzO7hukUrK9JQ0SqXoTUWpwJo3i3zpoWnWeJ4PyvUAFnzyp3emeA407NViFPk9dZm9tt4UJ8uaYBIvXmQT/UE5aLxNmJUFyDI0iJsMFjM7BwCkLce1Hxh+GczacXzXd9B9TWBqcpnqNJOnGbkJ8qU5hWAJjQNQ2I5qgnR5a0lxPnUWT1Kp5n2QW+4EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWy47GqZKWEDZcAHHZ9VMCtkQEh2YuJzZFZYivc7QLA=;
 b=b6AN+j+5PmGY+/EPG8/1LA66+gP0m6FqCDk7unCmKo6+Hf2BEuDRsbDO8rwY6C3QV6DiVtXYW9rxW3MmQnhV/7AjkTNKjTGSMqqn5r1iRrYSv7mvbY/VgBfQMM/23cxV+mdILr+XQIdZgLlomvX+EKOJcjH5w6TIf5DrNJaVf1d8RCiS2DV3RXI7sULbqcBMgmq25SjT4PtNgfVoMEY+gAd6fZrRxhtwccOj/lKYWoR6NQ2qRcgn/ANFzGDW2fp/wuzYxl9cIi9kl/oM0/HCtsLDZQngF4+AB8h4iqKQmkLZjFVtApkOuFskaAxC0i+SgmeNn98vbV6M1ayBZyNrRg==
Received: from BN6PR17CA0037.namprd17.prod.outlook.com (2603:10b6:405:75::26)
 by MW6PR12MB8705.namprd12.prod.outlook.com (2603:10b6:303:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 00:28:12 +0000
Received: from BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::f9) by BN6PR17CA0037.outlook.office365.com
 (2603:10b6:405:75::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Thu, 16 Mar 2023 00:28:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT079.mail.protection.outlook.com (10.13.177.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.17 via Frontend Transport; Thu, 16 Mar 2023 00:28:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 17:28:05 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 15 Mar 2023 17:28:05 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 15 Mar 2023 17:28:04 -0700
Date:   Wed, 15 Mar 2023 17:28:03 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBJikzhnIrEa0nN1@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
 <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFj8AZ4gWOW1PQs@Asurada-Nvidia>
 <BN9PR11MB5276FDB32A40B521C0E351E68CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75295B8B4352698CB165B300C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52761ADF0DBE0D81AD856BB58CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52761ADF0DBE0D81AD856BB58CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT079:EE_|MW6PR12MB8705:EE_
X-MS-Office365-Filtering-Correlation-Id: d9b6156e-1504-429b-cc41-08db25b55337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Spmhp2sJ8GhnHP/Iei+BjxLT+mlxWZk4BpW2WwLvKdRlCt1+joDHevJp8vXmq8BL09WS9ymfNp6mvSL8oNE10HLimU4v9a/SgH6CwT3nxKsu5thSmN2vJREp2i+512lI9wDb5Rx5T8m401+yjsG6H7gyjflE+pyjDUL28T+1r8URcx+JZWHtM1s0R1FTD3j93UmC+nbOHwrHZh/AICoUXKHRsrAIS4eI5MaOIFBsts3FRDE8ojlXAr/J2dEdwv1cn8hB6LkGTFfTtXSIZYjoBQ9DoEsbd96cygO9KsPeoWDf1MIeuMSbmnwk6WD5x9pypV7yzy2n/hDGo/cT3K+2P9A/T8k+c1UczMBRONe/T/Yk0LDbepItAjgRAF9lCT8AniuDtGGzHdJcisfTU8z72YKhaamVYfiKUCcoy0bCyUkpygicbaHoR+CA0/r9YtFsaSxpluF0kItvFJPzxX+hiIzxVwMskjqR6evt5gW/5i8H000S0i1BwK8EPs9pz31S7IEEba7gFl9CI3YnLl6EV9dgZYPxaRxMmS9LVxnXDbu+PrMVRjSYRLYSn7A8fCuJNxn5kFiH/2DeCwJ345YRDJF/d7JW81cm5xEz6gDQwiu35v8cawGEvEkZE5p9mfYFkiRV4Aj9B+5KnYF54/QTmpR0DBnEAg6lgvL+sVjkXhCOKjqNxDAutKSub7+xGoM0VzXSNDPI+CyYbGFggMxY5QCc7nzPsYwQ0V0BCCysTepwkVFc5KcF/SD5fzwvPZvy
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(83380400001)(478600001)(426003)(47076005)(336012)(186003)(9686003)(54906003)(70586007)(70206006)(316002)(8676002)(6916009)(41300700001)(4326008)(36860700001)(8936002)(5660300002)(7416002)(40460700003)(26005)(7636003)(2906002)(82740400003)(356005)(55016003)(33716001)(86362001)(82310400005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 00:28:11.6656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b6156e-1504-429b-cc41-08db25b55337
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8705
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 12:17:11AM +0000, Tian, Kevin wrote:

> > > > > > > > @@ -449,33 +450,18 @@ iommufd_access_create(struct
> > > > iommufd_ctx

> > > > > > > >       refcount_inc(&access->obj.users);
> > > > > > > > +     mutex_init(&access->ioas_lock);
> > > > > > > >       access->ictx = ictx;
> > > > > > > >       iommufd_ctx_get(ictx);
> > > > > > >
> > > > > > > this refcnt get should be moved to the start given next patch
> > > > > > > removes the reference in the caller side.
> >
> > This change is ok but seems not necessary.
> >
> > Yes, vfio_iommufd_emulated_bind() will not have reference on the
> > ictx after the next patch. However, it gets reference only because it
> > wants to store it in vfio_device. Now, it does not store it. So no get.
> > I think the caller of vfio_iommufd_emulated_bind() should ensure
> > the ictx is valid. Also check the physical device bind. So maybe not
> > necessary to get ictx before calling iommufd_access_create(). This is
> > the same with the vfio_iommufd_physical_bind() which calls
> > iommufd_device_bind() without ictx get, and iommufd_device_bind()
> > also gets ictx in the end.
> >
> 
> You are right. I overlooked the fact that ictx is already held by the
> caller of bind.

I am dropping it then :)

Nic
