Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3407E6B8D2F
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 09:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjCNIXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 04:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjCNIWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 04:22:51 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3A29227E;
        Tue, 14 Mar 2023 01:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtJXkmENAC8Gbs8oww3erraRCxxXxMP6IPaW2Z58udOhRuUYEypST5Eb/jR75O78/nRCXhllojdW8CjobBalqT4WU3g7/hSE0baD3Q2LyYKEJDxzqHUTmt8pL8bjdbYBWJtfA01OeBiLRn2yuTG3BaviMp1bMZj8+Fo7fu1shUxei2oSCJxHnZQLqpw7DiUfGgGv1i36qQ35uFNFRSQ0QY9H/zbzywjtJZrKyOGy+fE1jnnG0t1tCjqkJtwzcC1bDnEDTNPp6sUazZSw/oXXbDbDt4YFJGhMO/6GXIDXb76vj3ZQHNH+MXmE9rKnkOpAC7TAryMlnomZDT0g663Q0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOSQ43L9xKmhli+kTXIlcRqOE70JR46g+bs5USMoAH0=;
 b=gbqYnw4i8MH/z8b2VFlYth7ruB7c+1agPF9IQrOk9w/kCa+g1cXIhRmr20mOvSQy5yR5rBXgXHnxP+wtIPcR3eJ3wOAjX2OfRTXI/FXGathD4SeFPTVQ5JKwF0fclS+iUOg/7T2rxx1+K1h50L7QJfyzKVt3wz5soWBeRKF1RsGTfFf4/ySo0sBRG5mRqk6qj2w0zU1vu8YVMCIeGOqTjYMi6zIqCbs23bTZuOFWac00vPizwcWtWAOQRhZVakC7wA5Y4WTPW+sAnyh/liKugBMoMW5pi+T5vn3tKCtqBWKWXKj8Kca4F4UkIHSVPT4oNydhJfXNLwtI5tA8ucunpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOSQ43L9xKmhli+kTXIlcRqOE70JR46g+bs5USMoAH0=;
 b=n2IpOhaHZ4LBpHqOFOxta4pCedrR9WgwYcmd/XxS6d0KsarHFbuXq97QorNNwywk7qIGN3QdAbvzLt0uB0qw4GWeggtOErVdIHD/vbiw/5NBv+v6ATwSK/ZXLLpqGSu3Ny5imhpnMFd+t1euNIzgt39ayxZPwnV0Oj8J50LfreDIRUMFUr2TjkaUc2Fh0Y/GTXSYZQ9qWwEHjbqd84B+EtYWIJR2WuCwQ+86e7FVrtgsbbqpAyO/PKC0oGGyg5D6hf/VVd8V4uCLwkh84q1LRX6dDe7D0nb1lH/cP9ZO50BaKcG6WvB3t88PJL4PciSk5k+QHQaCIIjTvVz87NWB1A==
Received: from CY5PR17CA0040.namprd17.prod.outlook.com (2603:10b6:930:12::34)
 by CH2PR12MB4972.namprd12.prod.outlook.com (2603:10b6:610:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 08:21:03 +0000
Received: from CY4PEPF0000C981.namprd02.prod.outlook.com
 (2603:10b6:930:12:cafe::a) by CY5PR17CA0040.outlook.office365.com
 (2603:10b6:930:12::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 08:21:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000C981.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Tue, 14 Mar 2023 08:21:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 01:20:49 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 14 Mar
 2023 01:20:49 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Tue, 14 Mar 2023 01:20:48 -0700
Date:   Tue, 14 Mar 2023 01:20:46 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <joro@8bytes.org>, <robin.murphy@arm.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <chao.p.peng@linux.intel.com>,
        <yi.y.sun@linux.intel.com>, <peterx@redhat.com>,
        <jasowang@redhat.com>, <shameerali.kolothum.thodi@huawei.com>,
        <lulu@redhat.com>, <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBAuXo166M+z8b3z@Asurada-Nvidia>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZAtqlnCk7uccR5E7@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C981:EE_|CH2PR12MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b29f08-7e0e-40a0-e9f0-08db24650cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BgX/sDdNk4ydL1kLFNbnU3DkjHt3JacsxGvzDwrwSZwVyQG1qqtCZU9mh9zzUOp9KZ6IRzGxYdp8HTfDoKPgWM+YMHiijTMXfY9eh3vYJd7yMkcHRMv8neGbnORfjKktu6Ha2ndQRzasvML17THMHU7xEOj7x3AcsrnnumxomipzAlDYQamh5PYZ75qzFCCPnFZ4lns7W1Hp+AlGW0XWUO8vINKwYFluFhwuOvgX7N/D20gepMx9po5Qgz+BbrbchavCa1axzhwEfi8D5Ig9cTbpp9QkGdMkpqxuy7ye3dLhzKUKkiB9Te8bBgHsaQrHqBRufd51vi4kcCnj13r/Xu0pzdKK3ZAbRD61qaRKsvYY5l38PLcSejNU5t/dYP0KwNn42OwL4x+QEM75Tukhn16u1WN2vj2YJZJvsuQ+6avCCPnvi8U7KFSuh3/4nRbTsltOOG+OmX2Yk0PzVRPIoxu5nqo+vnR4yjqEXOcNGKNkbB1Jh8e/s3baaIGekhyR7u3Iwp+/wV4YYATVp0TXC78syfTiC1rteMKqNzhrtg3TbXRJYclgdjEIPyZXTkf2dbxJJdhXdsL+gJZV8ITnaECBw39TNZCWDLRiTL22juouf9dcBroPImKoPioGawMAoY+GBuVzlM+ZZNhdOOgbkfUaw4Ap0k8gdJSfR7n2hBpvGQJwLHRDFH795lHFOkar0X8zRDtmXWPsqAhAneWAZlpiZcHXn/HTKMsIy+lwBrwwf+RmpV//M8pWOs2jpTuYuS3OTfeBz4DAbNzuUtnCg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(40470700004)(36840700001)(46966006)(356005)(82310400005)(86362001)(33716001)(36860700001)(7636003)(82740400003)(55016003)(40480700001)(40460700003)(110136005)(4326008)(8676002)(70206006)(70586007)(8936002)(41300700001)(54906003)(6636002)(478600001)(316002)(7416002)(5660300002)(2906002)(47076005)(426003)(336012)(83380400001)(9686003)(186003)(26005)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 08:21:02.6088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b29f08-7e0e-40a0-e9f0-08db24650cc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C981.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4972
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 01:36:22PM -0400, Jason Gunthorpe wrote:
> On Wed, Mar 08, 2023 at 05:13:36AM -0800, Yi Liu wrote:
> 
> > +int iommufd_access_set_ioas(struct iommufd_access *access, u32 ioas_id)
> > +{
> > +	struct iommufd_ioas *new_ioas = NULL, *cur_ioas;
> > +	struct iommufd_ctx *ictx = access->ictx;
> > +	struct iommufd_object *obj;
> > +	int rc = 0;
> > +
> > +	if (ioas_id) {
> > +		obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> > +		if (IS_ERR(obj))
> > +			return PTR_ERR(obj);
> > +		new_ioas = container_of(obj, struct iommufd_ioas, obj);
> > +	}
> > +
> > +	mutex_lock(&access->ioas_lock);
> > +	cur_ioas = access->ioas;
> > +	if (cur_ioas == new_ioas)
> > +		goto out_unlock;
> > +
> > +	if (new_ioas) {
> > +		rc = iopt_add_access(&new_ioas->iopt, access);
> > +		if (rc)
> > +			goto out_unlock;
> > +		iommufd_ref_to_users(obj);
> > +	}
> > +
> > +	if (cur_ioas) {
> > +		iopt_remove_access(&cur_ioas->iopt, access);
> > +		refcount_dec(&cur_ioas->obj.users);
> > +	}
> 
> This should match the physical side with an add/remove/replace
> API. Especially since remove is implicit in destroy this series only
> needs the add API

I assume that the API would be iommufd_access_attach,
iommufd_access_detach, and iommufd_access_replace(). And there
might be an iommufd_access_change_pt(access, pt, bool replace)?

> And the locking shouldn't come in another patch that brings the
> replace/remove since with just split add we don't need it.

Hmm. The iommufd_access_detach would be needed in the following
cdev series, while the iommufd_access_replace would be need in
my replace series. So, that would make the API be divided into
three series.

Perhaps we can have iommufd_access_attach/detach in this series
along with a vfio_iommufd_emulated_detach_ioas, and the locking
will come with another patch in replace series?

Thanks
Nic
