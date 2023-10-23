Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB777D280F
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 03:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjJWBhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Oct 2023 21:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjJWBhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Oct 2023 21:37:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BFAF1
        for <kvm@vger.kernel.org>; Sun, 22 Oct 2023 18:37:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjxpP4cO2f6jRUlzWR0nFmNI3vNiFk8HoNs1MqAonrilpLK4OvJH/QEqgX06yHIljMNMnHOur+u+7rRZTznYc2BDewuffufnGaQ7qMZ63MP8nuwxK3DLvN08NKQa+PdQ5carTD0wbPcqE0P2gS49vbMjG1pZcpW5RmHTTLBqU2TSL+N28rVADFyUDr+F17nXXQjXCsEtJy5A4kmLH2fnuljHx3LxVqExzUM61iXgbhNv/d/OFvBzsG0h4RVwsVKIZMg7sA/S8EPN/9dBTU6ARi9uwfJSimXAzmbRNtLNBgPrFHCEGWqwzQB6yBpY2cnxEaIhCiNM1SSHMfETGsGhGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sIUGJ/DwEuMlY/pMBPwWjVZPK83b9v9modSQbQMMOY=;
 b=MFIYfMKQ0zF4wwNjPOLdBa9KYHt3/wJ5Juv9fP3crCWwhUOR9d3jZKrqhIm7r1BPXLMWpi59cW0Fii4dFxMHNsVqQ53CYk3CwQNaOA/UbiwyvCRPvWP6e593UJALD1R77dZN5Kfx5SGbHDKfR36hkGLEQ0EHmDrimBuBXLSg2UtbEgUtxPlXYsTZ9+W852s4XF50bWYXnyB3aGtiHcH9GTKZ6XmDnCsVG0CsmR1McMdqV60C5c5Li8QL21SbN5hCcHHrvUWAUf8eUSIXQThLsdznFRRhuZljWTf5aCjoQ55YiDwmWxyeQA3kNxpapJ/IHyaO3ULRL+5qwG7pO4n4Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sIUGJ/DwEuMlY/pMBPwWjVZPK83b9v9modSQbQMMOY=;
 b=pvuASusjGGSH/xKt6W/43TSJHW38T5xAAyOFqemUuWBg0VoYz9jYW3q/m8V94ZyWcK3HvEXWVIBBDqnRLrKw+EWd9Fz3NFs3GrNRjXQL39Eq4w//774iYG2SkxOLw8BejJm+61SG9/LAAb4iJFh3Km46tSMrXVPIWt4/USDrcJpQNejW5j/FeT/E0e3v0PBI1WD8dyXBxVC6SUVXRMQCMGZC/UIxs5X3Dw6UnmI+7jv9WgitpvTFtmkA3gENHu6RS+YmV6eLSwx+HiLnx9lIz62okBwsvmyh14YjFG8Apd4j2+RjyJ/8uukV0mLybDcJgJ5o2rBYyh6JwEUBzo4bVg==
Received: from BN9PR03CA0229.namprd03.prod.outlook.com (2603:10b6:408:f8::24)
 by CH2PR12MB4938.namprd12.prod.outlook.com (2603:10b6:610:34::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Mon, 23 Oct
 2023 01:37:02 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::b0) by BN9PR03CA0229.outlook.office365.com
 (2603:10b6:408:f8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Mon, 23 Oct 2023 01:37:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 01:37:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 22 Oct
 2023 18:36:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 22 Oct
 2023 18:36:39 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Sun, 22 Oct 2023 18:36:38 -0700
Date:   Sun, 22 Oct 2023 18:36:36 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <iommu@lists.linux.dev>, Kevin Tian <kevin.tian@intel.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Message-ID: <ZTXOJGKefAwH70M4@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231021162321.GK3952@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|CH2PR12MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: a63965c2-f861-47aa-8d19-08dbd3688e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MH+YdofEQnvraN/+Q2Ec/RTQ+QVnm4jPy1Pv3/BVPvz1yfZI6ka++6zVqyUjkeDNIJKAxXaUaWgyTnx3+O8Ex1XL8yi0LLrKCbUx5NWGH7TylPsgpJs/MkJqesrhbUTebk9vqCt8YAi5s7SXW+CqW/jXacb7ZjlIDxNxLRge5Eq+QhAxXw2XPYUx9W7QIfOgYKYVTdT9EOT3azAkHNqi529Ai+LAsTOskPamZK0sy42X7dMltSJxTRpOLMFRCpxWpEbctBk3GcAxRXelND7nUUiAI+I8s0B1Oq98EQS114aXb0gXtZKTMLSe8V9ZEZ5TSfmwXoWZhZ+m9pISW32HODgYHzwHLlZKwGfkffoxhm9UQ7D4gtbFzyDmR5rYN9XvzgLlraWbCsNhFqlYl5tNW4Y4gi+PdQxlbm6uU0ElSZzEAKG+YeQr2ezFsVaJG85bQyrmay1JLdJQr46MEMM/Kg8SxwdWl4Q2iYJ5J5d1CBfpizMHOSQUzP4rlKF5xQPIOr6Dt8mjpi5m6cEsaKeQWuara2nqe5aMcl+cRbWxe+e/4ktqFGspqJcYBdaDuneOltLiZYgnYsNgkxd/8vSsAAS/L+TdjFoTU9fkbFrKs7Chw92Vgme3HDYEgNZFL9it04Jl6vMvmLisj1lEQq/QyeWYHTmTLE9R+cteKbBqaDL5IsuMGPrdC/fAH6Q6LHk3z+PhDcfN8523l+Ao1PyKsiNUmJ+NWSCOIVZeC6RDw9y9+9HKAc3zcw+mXMcgSoRG1tp+2opE0L55FSkausfnOw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(230922051799003)(64100799003)(186009)(82310400011)(451199024)(1800799009)(40470700004)(46966006)(36840700001)(40480700001)(5660300002)(40460700003)(8936002)(8676002)(4326008)(47076005)(83380400001)(7416002)(2906002)(26005)(336012)(426003)(82740400003)(86362001)(9686003)(33716001)(7636003)(356005)(36860700001)(55016003)(54906003)(478600001)(6636002)(316002)(110136005)(70586007)(70206006)(41300700001)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 01:37:01.9485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a63965c2-f861-47aa-8d19-08dbd3688e52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4938
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 21, 2023 at 01:23:21PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 20, 2023 at 11:27:46PM +0100, Joao Martins wrote:
> > Changes since v4[8]:
> > * Rename HWPT_SET_DIRTY to HWPT_SET_DIRTY_TRACKING 
> > * Rename IOMMU_CAP_DIRTY to IOMMU_CAP_DIRTY_TRACKING
> > * Rename HWPT_GET_DIRTY_IOVA to HWPT_GET_DIRTY_BITMAP
> > * Rename IOMMU_HWPT_ALLOC_ENFORCE_DIRTY to IOMMU_HWPT_ALLOC_DIRTY_TRACKING
> >   including commit messages, code comments. Additionally change the
> >   variable in drivers from enforce_dirty to dirty_tracking.
> > * Reflect all the mass renaming in commit messages/structs/docs.
> > * Fix the enums prefix to be IOMMU_HWPT like everyone else
> > * UAPI docs fixes/spelling and minor consistency issues/adjustments
> > * Change function exit style in __iommu_read_and_clear_dirty to return
> >   right away instead of storing ret and returning at the end.
> > * Check 0 page_size and replace find-first-bit + left-shift with a
> >   simple divide in iommufd_check_iova_range()
> > * Handle empty iommu domains when setting dirty tracking in intel-iommu;
> >   Verified and amd-iommu was already the case.
> > * Remove unnecessary extra check for PGTT type
> > * Fix comment on function clearing the SLADE bit
> > * Fix wrong check that validates domain_alloc_user()
> >   accepted flags in amd-iommu driver
> > * Skip IOTLB domain flush if no devices exist on the iommu domain,
> > while setting dirty tracking in amd-iommu driver.
> > * Collect Reviewed-by tags by Jason, Lu Baolu, Brett, Kevin, Alex
> 
> I put this toward linux-next, let's see if we need a v6 next week with
> any remaining items.

The selftest seems to be broken with this series:

In file included from iommufd.c:10:0:
iommufd_utils.h:12:10: fatal error: linux/bitmap.h: No such file or directory
 #include <linux/bitmap.h>
          ^~~~~~~~~~~~~~~~
In file included from iommufd.c:10:0:
iommufd_utils.h:12:10: fatal error: linux/bitops.h: No such file or directory
 #include <linux/bitops.h>
          ^~~~~~~~~~~~~~~~
compilation terminated.

Some of the tests are using kernel functions from these two headers
so I am not sure how to do any quick fix...

Thanks
Nicolin
