Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056CC7257A0
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 10:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239520AbjFGI2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 04:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238263AbjFGI2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 04:28:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0FEE49;
        Wed,  7 Jun 2023 01:28:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZ0fLDNjPGKQkwbSxdOfXR3JAmgr3NQsB0SVHhLS6gkcvk8mSi8DIVqJMDdn0zoHzZ6m1buH8Xopv7Bp59nQW4Eavw95GdTUwWe/kQTNcwTL5H6Dn2PRk609856MSn8uhqrfpQ7nt0UtvJKIHsrkj6D4iLPUtSMr+yn+y7//8ONOwyP8mKcf8zBuUPwiBtR/ZaGY27s9NyqbBxy0HQ+VVIYQaB7Gs72RKYBKE4BdrAKK5kncU4NGxmJpu1WBRnvACL4clGhIkXFETnsiXEYlo1dzlkQv0C96Eiovi/9MMr15SBYq3GMLVKxfPntSkSGB3s4jqp0x978MpDsyNDF2Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CaYIxssfxfHh2QEB13/cmS5a8wYMWFbsQoAgjU1O6Xw=;
 b=dYvSamxhE3Lo/A9X4k+P5HW8ZmlERBZuRAhwHtZPC5Gcui9FroAYupxth4UAEAlPt1NUHfEZMEiFkrtbE0VxwCFrVwYY+CYTVNOerbG7T6ryx6EWIttYQdjqQupyAMtUoxRywfbLguYdA7A2C40+hRZz2VIRF6rs9d7YAOLjWY1+tCiMeDBTwc0uCu9t+Q39oZ4yGRVF++ueYxrcXl3QtrhvZcHEhh5LbYYtyikYkh6Bh+LF1i1qIKuZv9w9XQX9tUMMsy5nF4nqLLA3McbCzxdxuflLFbAeqSPM3KawrXQehu2wSS9TJDji/QwmhJEVYzOnM5FpIgCY/cdYJMtmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CaYIxssfxfHh2QEB13/cmS5a8wYMWFbsQoAgjU1O6Xw=;
 b=ed3hzXy0O0dExY5ia3y2rBZTeV50yp0eCjs4/+gvI5K/Z8aaQ5YEpf/TJJ/wFjsu8+Zuo886atIGQ92fM8SStKxYAQDYdR7WQE3l1yolW97LNab0HPb6QkA28G0nJxfI/VFw296PRAALjQ9kzTEQPF4w8Kd8Yf0RpQGhfCck4kS2IKEQ6keXXIuDEg2d/UMssdoqEDUvoKGjWP9DgvHEECkwc/AS5AJUZriXt7NxmSH27nYRmKb15xd0iGaUihTXZB6BM0Alc+TvdOJL7UolZP3aWcn1m7dT5XMg/iDHIInwalvzzurvZNfp/+4HRrMpg4dtHLRzWKLlD2cKZvqgZQ==
Received: from BN9PR03CA0367.namprd03.prod.outlook.com (2603:10b6:408:f7::12)
 by SN7PR12MB7418.namprd12.prod.outlook.com (2603:10b6:806:2a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 08:28:02 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::5b) by BN9PR03CA0367.outlook.office365.com
 (2603:10b6:408:f7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Wed, 7 Jun 2023 08:28:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.22 via Frontend Transport; Wed, 7 Jun 2023 08:28:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 7 Jun 2023
 01:27:48 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 7 Jun 2023
 01:27:47 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 7 Jun 2023 01:27:46 -0700
Date:   Wed, 7 Jun 2023 01:27:45 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>, <yanting.jiang@intel.com>,
        <zhenzhong.duan@intel.com>, <clegoate@redhat.com>
Subject: Re: [PATCH v12 00/24] Add vfio_device cdev for iommufd support
Message-ID: <ZIA/gV2w4btZCJir@Asurada-Nvidia>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-1-yi.l.liu@intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT029:EE_|SN7PR12MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3f35dc-6b6f-4b11-8a78-08db67311bc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6pmS8SbD21czLk8r9tb/CQ0V92oKG3HMAR2bthdijXvicetKMJoZM4Q5gDNvSdQmwIJiQw0WahK/lQ1fXXKJgSXeTO/VU/6w3BmJQo2gbflyF8/xBrdufyu8CqT7Yc0jLH5HhSKRIXaIJdOo0KzfVh29+/wfB0uf4fyLZkWfUsjYOyD04OYM9Y43h9tSA9exD0ipNMjC9XJZz9P+Nlx4DNRM+i+J3I+t8cbw7GzVJH/ZNVa0ofJbx+kYdjRT5ccB9hFKmpO9HbjR+aa9s5cUnMhWgRWR8pForsVmoaHegm5KC5vn7+debwHwQA5OWXl3LuWqEdGh+CyVTBFvFA/aDgHiofzSybLffQUyaoX0uZK4kSFAsg6IsVdGgLcLsE3gshwo9lgzofF5CJVuXIAyR3vGSJz00APTAx/qne4cdIuqrrjI6DCuklPrd66CEAgdRxUEDxVzLVLT+JytdqoJlxThtiEkWnwJ43IEMpFBvTrDuPaUX6wFxQ9jKcDpzUyRvJbKgmCfV/m1eC1k/a3tR7zZSu2YUR9wiTqq0HJg4U/j5SQFNffjejtixyTOGv2CqzjTJk5B9uBd7EYysmbfdz07BWMw1iJJitr0S2H1BbqxGn/R+YlRZQhTyYXsV8F2TbeUXHAskxK8d9ZUpxxYhs4qiprnizi1o1DmPv6eodR9r78ZuMk29Ukb4iAwtMnpXAaIJGzdHiPmBDmuYnm/jloNM0BFrSCYcUpplV0LoyyiCI1R+gWefM+4SjagcqT5BX8Q/mxP706MyoDrUg2AUt1Pdtdkv6UhvS0gA9fH3Bc2MVfdRNJz+03qs3QO8T9z
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199021)(36840700001)(40470700004)(46966006)(83380400001)(2906002)(40460700003)(47076005)(336012)(426003)(82310400005)(86362001)(33716001)(7636003)(356005)(82740400003)(36860700001)(40480700001)(55016003)(966005)(316002)(5660300002)(41300700001)(8676002)(8936002)(4326008)(54906003)(478600001)(70206006)(70586007)(6916009)(9686003)(26005)(186003)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 08:28:01.8277
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3f35dc-6b6f-4b11-8a78-08db67311bc9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7418
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

On Fri, Jun 02, 2023 at 05:16:29AM -0700, Yi Liu wrote:

> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. After this, adds a mechanism for
> blocking device access before iommufd bind. Then refactors the vfio to be
> able to handle cdev path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between the group
> and the cdev path, only allow single device open in cdev path; vfio-iommufd
> code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
> into two steps. Eventually, adds the cdev support for vfio device and the
> new ioctls, then makes group infrastructure optional as it is not needed
> when vfio device cdev is compiled.
> 
> This series is based on some preparation works done to vfio emulated devices[2]
> and vfio pci hot reset enhancements[3].
> 
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
> 
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
> However, the noiommu mode test is only done with some hacks in kernel and
> qemu to check if qemu can boot with noiommu devices.
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v12
> (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)
 
Rebased our nesting branch, and tested with an updated QEMU
branch on ARM64 (SMMUv3):
https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-06052023-cdev-v12-nic
https://github.com/nicolinc/qemu/commits/wip/iommufd_nesting-06062023

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Thanks
Nicolin
