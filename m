Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E5333112
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhCIVjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:11 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:47776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232043AbhCIVjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:39:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gf1OATYsYMr8ATpEyOjo6YKeEnqLk4JskbcmAS8KGFHejzQERzIFekUx1lZtVQYxoHdUdVpj+PuvGIzeClBZygVmqqdGnAqDJvQXXLWvju3Sth4NSLBaow2KL6Nz6ai/j4kDjGnvxk3O0y7V7zGWIRYlDsGBlOPP5BGcQAU3wQc0XznmlDSy1aG8v0xqqGmvuwm4ZEbSKN6dXHHAWTZYtll27bjLZjcJh8QX16UM4zZmjxtaDvI2jjuLIOGF1ypfK9Jbc1v/CRBirbfd2I1Bf5smXDMgOkQgbScBWRaUEWxW961GgmPd8ZsL+H34dh7pMFAb7niLqI4nAdr5II0u2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvO+FoZzOybXRfTmpQKM5Y49hQtyJSNJ/qn+TKPJP3U=;
 b=PQ2MIWZKJWd4oy0SBjo73pMExXDnYcfEgnhXbw++rmtitOGKPgE3mfH8qOpsiif4L8qHEnv8iHIgq5b66rzzOSoGRT7zW44c0u0Xg82WaWz+e/dV0FOeCSR7jU0r0bOWVkNMsBlkhuHWuY8dfPjqXBVn5PxQ+UsBbbUM9LDGjQhgh/ntHaO9YBl3CUVcI29vYEowR8s6s+m0LkLMh4FNIj1H19palQjIS5IvW7EPhcWwo2YWNcW6lKhu0l/m5SBUtdthSFzMMcjVS1mMjq10InVLKfywymdQZSgQiGflrHH5OPcAHbOZmLwa4fsR/NvQh1gss2bqTXOB6L9FDP98hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvO+FoZzOybXRfTmpQKM5Y49hQtyJSNJ/qn+TKPJP3U=;
 b=Ok+uwZfmE8Zn81Gn2I0RG8Q2CaHzzYDDHIv34RlL/rdUi1LW+ELiYLiny+b58FXSx3uurwdnDkakV+tb/wE+/ZA0los9ZkvnsNOJc0plD1o4SgbQ6/G2ryTmImel9uxRIcItZZxoBaxoJftJDd7uXs5rsYMLDqxTtthfz0M7Z4aa0taVJk4DYgpumvoCUPk+c/qMD2n3O/LL5EdL/coxweckTcjl1zlqJCvl9r8O6BA6k6hwNxuAc9dVJtDucdsPdCyagfNHcklNhjwMPbkLGQo2L03Jymp4nzSIdQPxIxv7C2h90FJw11v4+khSR46Y/PA5PP5OaRbOZP6+vJsmbg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:58 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 07/10] vfio/mdev: Make to_mdev_device() into a static inline
Date:   Tue,  9 Mar 2021 17:38:49 -0400
Message-Id: <7-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR19CA0062.namprd19.prod.outlook.com
 (2603:10b6:208:19b::39) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0062.namprd19.prod.outlook.com (2603:10b6:208:19b::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVJ2-Tc; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 994d12cc-88ae-4e27-ab0f-08d8e343be41
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1243A41399C9A7013C706456C2929@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwbnYQx0aECaQwkfsCPwiW2VD2VAEdh4jNbu6AdpYufsRLYELGUk0gRjZpEu3vOBoGzNBCfzYIjgbs3uocm6mQMPx8ddpmqF1nFzEl+87IMow7c/58CUIEdi08SfnV98wglgLH8VUoL+HEs3cUgk9mFBQ5tVEVT7Vp0YRSRpMbTTrNYlBBkQBdJVbgTZ8fqXje+OsWoVLgYwJnilyQmLUe0JN7iNv5p3kMBZ2rPCv5HsgtfyOkIAHQ8AWC/ECH+T/nmWSHQKZaTzJflrgImnkCqqOXmze4Pe/VbG5tlF0/k1v7J//jgLCq7Vf3xiqHcnh7K1WaM4NPTIP5dvlXrzCc6xitr9wvbsnPPnmeqBvAxXpgl3ncWTjXYvJepYiodxkEiqJqk1UkMFg388hyzJyMMY/ZM+orQUMgHSkkq2QkhA40EmrLg27+KKBhJwMuykWDubQFSG9G4VkwtXUz8m3J4OvZHZCchzpSddz4Vq1ILf1GY+VnfKtGBKMoX94fVHmNlCnbpzN7GWbX/rIQyV8mF/lz4kEY7E+TEbtfoy27F9/PtrFrMeqdk6bPlMjyth
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2616005)(83380400001)(426003)(66556008)(9786002)(66476007)(9746002)(107886003)(4744005)(66946007)(6636002)(8936002)(186003)(2906002)(86362001)(8676002)(26005)(36756003)(6666004)(54906003)(4326008)(316002)(5660300002)(110136005)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h+9qe4zeIHPKhhXd8jFi6akrI79sxd7LOrc19Ef52NRxCNEUOUXg3EavKoQj?=
 =?us-ascii?Q?sHr0SkbOMADbelANnfXN23SMbXEEmQcPFFoWIwY8UyRg3tZnrGSJMi3skx9O?=
 =?us-ascii?Q?4226PbQJ7IeAxm573eaSt2dp9ksOzXQ4pw79fdDvbTWvqaeRMlGDiK+36S4c?=
 =?us-ascii?Q?ark4oQ1yHOgpTdbchsj3FGljKsHwn7XM+5hatZeXoWXnJ0zn+xxYtuRNqHii?=
 =?us-ascii?Q?Fik2FSu3I+iQ2+D4i8wwyERXDpbMV9zNhjWNJUNNEjPiNlhscLx8A5QmGpwr?=
 =?us-ascii?Q?yeDdI68ZBCu8aJjVdbDlgUaNx3n0+HyuJvO7oZ7hYUsVeR+qX5h/UXy4o+e3?=
 =?us-ascii?Q?d0/b9evLJfhaadnV9izVl+/bv4Qp1OXoDKNTtPFHSUJ4mTzBnq5y5TLYxVfn?=
 =?us-ascii?Q?VZTDmyJrAI9IUcXUIzF3542ZAgBpPBYQ0LmzKyv/LVPMDntdZv+XCIbw+6aL?=
 =?us-ascii?Q?QSyE54Xd7LnUzu3+N64/A7mIuLA+JN+h+Rqulkg3f2TkgSGmyblpU2hM5OKy?=
 =?us-ascii?Q?iXECmYcdOkm+q5Aym2QXiWMJRfSWRSbR+6lQYqeMJ6WQdGXQ82PSTrrrgQSC?=
 =?us-ascii?Q?rye91SEj8KcfHZPf0hxB5G7ah+IeVpgnb1YdWYSZFX70LRUpBro87jmGtMpm?=
 =?us-ascii?Q?m3DKGB0E7XXGR+Q6JiUPSIoGd7OFzUATuUvvbdGpvRySMO2xl6C6NbMaXgBj?=
 =?us-ascii?Q?bCEPtzBV6DWH4peEEKYcSEtObg2MQOLI1gXIZYBqlTrGy2IU3/ssKvKn7b9V?=
 =?us-ascii?Q?/vgSGrrTiJ11XHxqmDYD9LfAIHvaBvBOUHOcbuhKTE5iAtTm3ll7lLT0BugC?=
 =?us-ascii?Q?zNp+VkEgqWHThRMSoXUtbIzgIq4URiFxQnq35jEd6pwCFSXLOp/eBYSpUxS9?=
 =?us-ascii?Q?Yd0XeHrMSTKBNgUweyMbWgHNUcZFUSfFlZq0QiyskMQNjgp4wsBRNt+QGLMM?=
 =?us-ascii?Q?udaGtRQBGDMMRdLaPDlzy0Wxxx9ULZ0O1fvUhfqB6D91CrYpAmJA7NBz+0D1?=
 =?us-ascii?Q?okcr3avof3q89iBRr+6SJ2r+emCG5fYnOeJMdTT0J001JrIXCF967qqV/2DG?=
 =?us-ascii?Q?a6uVbK4/smfLYg/AaEF8x7TOo62dFvCVTOXeVmRmF2+ZJJPgpE6WYSAWUlyB?=
 =?us-ascii?Q?fadHe5cdL9gJwq+zpu+sq4vWYXUWMWZ9TqdlGmVHkru28FGfkx9Ss33qsZKD?=
 =?us-ascii?Q?XAF1twmQcbFJo943x/vMxerjbyPjFBDLNd9b3rcTErQx80KM6ettR6TK6Frh?=
 =?us-ascii?Q?vmuK8gYjcMMr3xCIfrEzZbfdSJLq7/LtPkJgSpqS7PEcOE9P7uwaeS6rMbem?=
 =?us-ascii?Q?lvvuxxL3nbJ2c7GitRzk8mQ4MqD4D1CW6PcTCX7um3no5g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 994d12cc-88ae-4e27-ab0f-08d8e343be41
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:57.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Pw9jdcNLp6KHRFyH0aOH+putVOOzR2rn2rerjxLf9pYfwjs6c3/loOY61GkdDie
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The macro wrongly uses 'dev' as both the macro argument and the member
name, which means it fails compilation if any caller uses a word other
than 'dev' as the single argument. Fix this defect by making it into
proper static inline, which is more clear and typesafe anyhow.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_private.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf3c..74c2e541146999 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -35,7 +35,10 @@ struct mdev_device {
 	bool active;
 };
 
-#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
+static inline struct mdev_device *to_mdev_device(struct device *dev)
+{
+	return container_of(dev, struct mdev_device, dev);
+}
 #define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
 
 struct mdev_type {
-- 
2.30.1

