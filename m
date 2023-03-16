Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E2E6BDAF8
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 22:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCPV2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 17:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCPV2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 17:28:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C9E61A2;
        Thu, 16 Mar 2023 14:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0RQUpL2Z75FyysM9NEBQTcAxxMvfXhf0gWQjq/LgnJ/FC7HKg93n7NMS0PBoF8/9clEden0OUcEYm6/o0AHyYWRPXbhlwuV7PqKbewNEGvoB871sm8BghZlLmGHuqe9/quRoJz5sfT5GqEkFGWgB9xKOFfn9YiNwMuNGrCF8ZvRAPjvcQawt6PwvBu46y8vdsLBVmN9mpXCjc74hui6/O2KeMWTbMo2TX8zF7reszkOQwz044apschZFr3oLL6/b2UB7mkPHVbb2xM9iou/l+6Pz8GPDxfBiOlMs/jWa96fVKXB75Pwy8bRHJtW+Zz17idR8ksoca0YPOFrkYd3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q21xCDPaEDlS4MsiZgLMmYb26w9aOTOTQbxk/6rGpDE=;
 b=PdFSerM8XzkTy40FkzCsghOXakBqe0lNUF4BUcY2AfWm8bWD9p+TX+/WRYY7B6f+/shTaXr+jHLmEpO6QYW6n6C2XEs01Kn7ok3i9G8g2H6BColN95SsukOVqFzuNbed+6A++vFYTH3K/+rkbGC2dNkdvlK6lABJDxmKmSnwu+sD6B8UFfB9Wsib8M9Obt45oX6FHF6hNJ1E/LK9nm9aI5uBLLTwSWzWs6K+q7yMjEcxs/BHiDN5XyxnJey/K8zUQIkeQTL3p5yuILXKAX2lBIT7lCvTMrUlR9GRLNdmvDbcbjEwHUIHYaeXEMG4ZIwuYJfJYJrycIW2XaTNvpqhpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q21xCDPaEDlS4MsiZgLMmYb26w9aOTOTQbxk/6rGpDE=;
 b=gFev3GKg9tf3v0jvwaD1FP8rSK0LHRHCPXljWKae3Rbh7UYGtYExrrsdMfRp2zCCiBkFDLtxwhgYeniR6DIYu4yHADzVuxEC814I7cBP7loEbH0Um/JYZXd6z5/WnpVR1LCq8j5SCZ0nrK+OO5U0Ei6Elzu23TnS7enV4hBE0YxP7LPO6OUhSAGrJuqoG9V9d8YNqwFcQ/jGpYroBft4uB5Kh0W+nFMRMRBxrOIZLdGS6eGgneVJwNgRmZeOP7pY4TnRwdMjlX1EY859hvFC1ZUWhqfdPwFl7c2YLZCVn8X9u5LIiNicI8GQH8MmI7wZwhGZ1mVqma6IvhjiAQ9oIQ==
Received: from MW4PR03CA0330.namprd03.prod.outlook.com (2603:10b6:303:dd::35)
 by SA1PR12MB7102.namprd12.prod.outlook.com (2603:10b6:806:29f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 21:27:56 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::1c) by MW4PR03CA0330.outlook.office365.com
 (2603:10b6:303:dd::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Thu, 16 Mar 2023 21:27:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.19 via Frontend Transport; Thu, 16 Mar 2023 21:27:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 14:27:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 14:27:41 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Thu, 16 Mar 2023 14:27:39 -0700
Date:   Thu, 16 Mar 2023 14:27:37 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBOJyaKcl5MCZByI@Asurada-Nvidia>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75293503F92A24A716DDE2C6C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBK74xltWbaWlftV@Asurada-Nvidia>
 <DS0PR11MB752937BCFB81A6018CAB94D2C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752937BCFB81A6018CAB94D2C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|SA1PR12MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e09cf4b-446d-4418-72cb-08db26654f1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fO029000z9NQtHjXPxvdyKABbhbbYJoqJmbTQ/F/5ymvNibOA5sA3Hzcv76qUPoxVqTLLOhkXrYOXYVPLN+YfBXDeb259HN7C8owcl+3LstbIPNrtfsDsQH3ylTNMsKvLo0s9ZkEnE8KwA8Z7+kG4InSNE/bVUSI1V1OfV4evhQ/4+H8cFldGmPCpPiGh68dEd3cWGvVeT/MLq00N8jtQleUT2mmIciMPazHn2OVDqZ15pxMLbZwrRruR2lwQykW4hZ6h+qsmWmqUZSCGtSRg8QKk4DPfKdYbXD7Ne223a5X1yek4ItfJrSpOppk7ks88C64pa+W0QzqH/imiyoFMoA/IHIvv+s5/5ep2XspzMkZzWlkrOWmFxSMrJZs6snQ0mhHEbiwAiDfoisXGgRHbqrXtSirGN21AR1ZjEBZVpqLNCtrH9RbQHIa9+iK8JE2pXTHs32AbndhJEVb5yIL3uF1EDNdUo9UulBkTMgAZMY6FvWolmqealz0z1YC84D/w1B7T7z60omjmBbnwRR3JNZxnx457JQWHuboB6BfCvplbeW3xIs/8aFzjHVX8ZsjgT26f7nTJQwFkyzCOaK9lVcIHyUESCmN2hT7CcWy5oxsrIV+LHJjpR+nsvzcHXicvAaWque5HvqImX6V3zova/8F/3IXflWVevnFWE5JEszZZNHqySbVuHqZtyn2tAwQ+jLcnIj26LwIyIfqHuNkqBG1va2iY6hFRAoz7ZkUZ1b5Y1Yym968fTkf8+dgHwk28j8zMGzMFZLSIJaTpHdiPqiCAATJuqVUWrEOTxjUJzM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(82310400005)(9686003)(7416002)(186003)(26005)(336012)(83380400001)(8936002)(33716001)(41300700001)(356005)(82740400003)(36860700001)(426003)(2906002)(47076005)(70586007)(5660300002)(966005)(40480700001)(316002)(70206006)(40460700003)(8676002)(7636003)(55016003)(86362001)(478600001)(54906003)(6916009)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 21:27:56.3133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e09cf4b-446d-4418-72cb-08db26654f1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 01:22:58PM +0000, Liu, Yi L wrote:

> > And regarding the new baseline for the replace series and the
> > nesting series, it'd be nicer to have another one git-merging
> > your cdev v7 branch on top of Jason's iommufd_hwpt branch. We
> > could wait for him updating to 6.3-rc2, if that's necessary.
> 
> Yes. I cherry-pick his iommufd_hwpt to 6.3-rc2 and then try a
> merge and then cherry-pick the replace and nesting series from
> your above branch. Though the order between cdev and
> iommufd_hwpt not perfect, we may use it as a wip baseline
> when we try to address the comments w.r.t. nesting and
> replace series.
> 
> https://github.com/yiliu1765/iommufd/tree/wip/iommufd_nesting-03162023

Nice. It looks like you integrated everything from my tree so
it saves me some effort :)

Regarding the order between cdev and iommufd_hwpt, I think it
would be Jason's decision whether to merge his changes prior
to the PR from the VFIO tree, or the other way around.

One way or another, I think the replace v5 and the nesting v2
will be less impacted, unless Jason makes some huge changes
to his branch. Let's use this tree this week to rework both
series, and rebase after he comes back and updates his tree.

Lemme know if you need a help for the nesting series or so.

Thanks
Nic
