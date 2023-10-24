Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F17D5A34
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343937AbjJXSLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbjJXSLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:11:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B88E10E
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 11:11:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRlVIzhKOyU0KP3R0jIG3/gM+aeYPpV0tMC5uMO2uQaLiaJdbF2NdgXhZ4Jtuks8mh5fkCbASX7F77JW/rwaR/d7rZwaqoPh74vI6rAnsS6zVgBLc6dA8EBSU5S2+6vPbOdleOhy75yS9FUWE4xWkx4JfckhfU8Nh4q7kJhMyl4dq6o4CJ+8mRoBd8Vm1qWLjBPSbnihGYxCRUhalbZhpcQRY7Qf7SLbJoOAgAXoF67ozWYGjeZj+M+eAUyNf5E0QIBq/VPV170f056dXINDvmXYg6xS2JzEAECYxQoVnGIjdcvsHYJEim+ymD7tc5UJMQTqGZPOzd6CjS2kLCEvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0INx/E552W2WTUj5wmxslLlhVn6UFk859EalHUcfcc=;
 b=FzHjL+jLTkhtnHSU8UNlD8spMNHhBZxeI4QP1OiGrLzbLD0ozEjBDTaRCvL+BGZ4MBFLE1KG9htKVoclAjUFJGXDzDQUIUHCathFTQNgkEctHJ206bX1yOaC17shfgrWMiugOBmNlCmdnwJ1MgbF1MiSl9O0OmqhedVdsBuMsErv1jgr1PFeDWypK3eT39be9Dm9bCCN0XE1oh/AmYCMp7kdzEkhmtHx1a94hxHHiUQf2IfzNJ6RBWekXExztX0HZaSycPDBY/dmp1HwTR8EaUcpFUy9sM3V023QMnPDiLiqN8kAs5MayJzDiA0Q337LBC2lgjdNCkk2EK0jAw66ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0INx/E552W2WTUj5wmxslLlhVn6UFk859EalHUcfcc=;
 b=Iuml+/X7L6bY+gsr32Saz4F3lSHvE/k+fPlBlS0WYqga0S+I8yEJ6B+ssVLZDZzULnEt5dD21ootMZ0v1eku8qJNesdRvyXFDBppsi1d6RJZJXbkc699wwPSGHCk95JKC/H47Z4rUkCMOD/fSpnvs8oo9DUfr0moxVsUCYlRdDXHCcbkixhC68elnoYPh2ecMcrgxaQ33nwuIxwKrgv/OGt0k7XFfsOjMAJBZGwa2lqUVBr/l3D5Blw7GWwVY5PC680Ct7HmMUeTf0hm7aXRO4KSFcAw/a3dEfcdRVEa9JFdKjTbHU6QfuwvPO74AsTrGO9kd3ZeMaWR4P6tvcaX9g==
Received: from CY5PR17CA0037.namprd17.prod.outlook.com (2603:10b6:930:12::16)
 by DM4PR12MB6613.namprd12.prod.outlook.com (2603:10b6:8:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 18:11:42 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:930:12:cafe::95) by CY5PR17CA0037.outlook.office365.com
 (2603:10b6:930:12::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19 via Frontend
 Transport; Tue, 24 Oct 2023 18:11:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Tue, 24 Oct 2023 18:11:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 11:11:25 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 24 Oct
 2023 11:11:24 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 24 Oct 2023 11:11:23 -0700
Date:   Tue, 24 Oct 2023 11:11:22 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Joao Martins <joao.m.martins@oracle.com>, <iommu@lists.linux.dev>,
        "Kevin Tian" <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
Message-ID: <ZTgIyu6/PS0fpo+B@Asurada-Nvidia>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <20231024155512.GK3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231024155512.GK3952@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|DM4PR12MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 4175ddec-df24-4636-7cf7-08dbd4bcacce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvCxxR83BPqtVqBxYZ+o6ZaeTGUduivp0ISu4LNo1XiMkx0V/MfgYlU/DdtzBvH0lT05F9k6KqPmxPkCj4jQVRWafPQwPSFZBbIY5geceQlso+XN/FqhM7fBUZtR7r+FVdjdX7xCcV3WSS5Lb3LE/8uOTD+x+cB+eOXjc9oS7FXN6spWSvY44+8bvH5TyMrerJDXlHqn3/ps/GDRtYY5ydtDs7wWsDPvcCdFTBnlzWkBp3DdNsNKlRq5k+FiBVaECllnedfTpTCGzz99HrY7LYoZvIFYx45mEsfbefPeV/ASKLKsGjr30t9zvRAWFo2H9p2lN5gAqkHbtyCvEJAjJpw5MFI6jWjSv4egdFClvMONOZw5oZpqM/vT9Bq6VuzXu92qcg/UDuUbfLUpBzB5a/8d6ZX2oO649WcHb/BWIulBAEysM/QFRnlV+G3+133gNO4vB8yBRE9HilyYr1fzwQg4i1SJeT9Dr40yn577fLVFbxnm2melQR98LL+2kApKQ/HcRgyazvV7R683B0J06cAAvwWye+vURYuZJoLs9eRb8xnSdyzNJBR6NKLR+HGJc/jS9r+pfVMaF6ZzpYU+EeLYx8EeNBjikSXKY2dztRBZrfYpNcqKFTdAVjSdhp07dTm6keXlm/itHNnBXqnJ+guS1e6DTr3OLEkAdN1mLFB4USsF5l4VuwdjnQAa4O0eNYYRVQkDKCV/+w6Wf4+CTF+n+fuDzLQEqJlN3jbE0M+GEZKA5QjUV/7rANhSfv6Sqfo9P6oBke2RthslytsxhK9RNRF9cc0XLgYiVc1Q03vQO1ILaotAMxCPFgN+KmjK
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(396003)(136003)(230922051799003)(64100799003)(82310400011)(451199024)(1800799009)(186009)(40470700004)(36840700001)(46966006)(86362001)(33716001)(966005)(83380400001)(70586007)(70206006)(5660300002)(54906003)(40460700003)(7636003)(55016003)(356005)(2906002)(336012)(8676002)(7416002)(26005)(6862004)(316002)(6636002)(426003)(4326008)(47076005)(478600001)(41300700001)(9686003)(8936002)(82740400003)(36860700001)(40480700001)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 18:11:42.0117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4175ddec-df24-4636-7cf7-08dbd4bcacce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6613
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 12:55:12PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 24, 2023 at 02:50:51PM +0100, Joao Martins wrote:
> > v6 is a replacement of what's in iommufd next:
> > https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
> > 
> > Joao Martins (18):
> >   vfio/iova_bitmap: Export more API symbols
> >   vfio: Move iova_bitmap into iommufd
> >   iommufd/iova_bitmap: Move symbols to IOMMUFD namespace
> >   iommu: Add iommu_domain ops for dirty tracking
> >   iommufd: Add a flag to enforce dirty tracking on attach
> >   iommufd: Add IOMMU_HWPT_SET_DIRTY_TRACKING
> >   iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
> >   iommufd: Add capabilities to IOMMU_GET_HW_INFO
> >   iommufd: Add a flag to skip clearing of IOPTE dirty
> >   iommu/amd: Add domain_alloc_user based domain allocation
> >   iommu/amd: Access/Dirty bit support in IOPTEs
> >   iommu/vt-d: Access/Dirty bit support for SS domains
> >   iommufd/selftest: Expand mock_domain with dev_flags
> >   iommufd/selftest: Test IOMMU_HWPT_ALLOC_DIRTY_TRACKING
> >   iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY_TRACKING
> >   iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP
> >   iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
> >   iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR flag
> 
> Ok, I refreshed the series, thanks!

Selftest is passing with this version.

Cheers
Nicolin
