Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEA45F663E
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiJFMky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 08:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbiJFMkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 08:40:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD7375384
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 05:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVeAnMCunUGrPGfYsjmoKAxTv+EhCuRVVBJ18PixJx/7g8NTOKlZ75NXvkbP+79KD7qWhrV8AsbdQF8v/gq7RAejm6leWijeg6z7X6BgmCTivG1qngcmIV8HCZ5g3bFlwU5EUuJRG6p76O/ACDvxvX5s1CG9+MxaTpqbaQP29ayfkWtEJCVqfUzHudTWZNlBm2v0F0baEAKCjBoxizCBse+WQ9ct+jXvRy4THrnYZT2soNLfvQ6xjq3no/fJ6G30AQHTwx59I6rhe1WhEhPQ9HvIbL+q1jzs77PskyX6wBeJcU16zmPK0cZWU7a+1zrsCRx6Wb7tZABWTyc70ZWtxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKjEG6xVl40Qm1MPbJzocAw9/s0T4K/UUFPicy1L3fw=;
 b=ZlRJIF1vPXg2CaU06AZLzRi8aF1g49FZ8VeRFDoqJ5P26jEY7huEZpdQpSiXVRDvGC0VU14aSOBxL9YfEcoBW22WRRtRZI6IbeQ0kZ5ku4o90UwkgIWtQkGWZ8ssoePeteI163dceVSHXeFtTfR6AWy7HaOUMvNXv/YU8RVWngWmN/j23iTzqeUcLC3RdI9S7poNYzSocMRj1pK0tRqCOxw6L1uCHSw6GVMMnBTTy3XjSjO9AbGbsiKpgq+2AOK+mpLJPwoZFZpQntvbnS/OADMEw4UWXFwVh4NR4jB+VnYkHgxOwhQPlKx+kPvNtQJdpvPrWa8ExL/kIabJkePP8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKjEG6xVl40Qm1MPbJzocAw9/s0T4K/UUFPicy1L3fw=;
 b=LUGnz8AKDDI/n1iJVsg5Y2hB8+vShrTKYjlMDj/6xJ8uuAAhDZGRGEI1IMgd3zKYApbEnWuU99iZvDi7BmpuobEWTG1gNic7HHITCeUT3EVtjRNlOGUUL+Y3wRWIEnMZhpSHBtbhYBEoNms+ijZ50/d3TFKOwdrnce97GBpwQ25GvIgBitfeLQKb/dsOBATXT21VZFeIx4RqST+4W6XMrumr9sEbTQzdj2VfYeDJBNk0WRHlUNACB8L/o7ASHT/seKfwDuwYRezqBXS5hJKjQQdHUK55XXGO6Pdg/R4ukMZkuKMw9hS8HjiQtXPGrKrOfNjkdWUI7zm7bVtgYBpGag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 12:40:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 12:40:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 0/3] Allow the group FD to remain open when unplugging a device
Date:   Thu,  6 Oct 2022 09:40:35 -0300
Message-Id: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0083.namprd02.prod.outlook.com
 (2603:10b6:208:51::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 396aaf4c-bcc6-4ddf-6eee-08daa797f96f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: njUChcD7hfZ85LSVUgjj+3njMrc9snIwVsyIWKRF94mdI2uqqSu2pBAKBYQ7MZeDgK//tfU+aIRBlWpDX4YNWLdNJpmyoHWOZtmCxMzltgNRaSTl7/YXmt8pi9XP78rX5ePW2O/40LSHbd9w6s1LMvqzpGmY/lekw0jrG7xJpnMX5E3NCHeRbteaw3JI2tmit6wAJcRwZ591ExKW23WRSIiudYLrQ9hhw0rMkJ+wP+whOR1QYYAMCS4lJQ6T8TZV1JLDhp0x1DViCB8dAElTeIAH4UJoFAf9N176lvWMs43Gw/WJSwG2Hn3h2LXzIW2qLIs6tav7J+OjZ7sHRlWi5TIcYy2h1C3l0ZiPITh6CDhgsrPTLWz3OsxBKHrB9bfEDZ2nMLH4gwRicpfH5k1tdB4BGMSk8/6TUWKIBeum3XaLg3G3AOKXcMxsSp+IHsSaCZHslaSQ/mZXNahfxCxyJaoHK4HhGtM4L4WO1IHAY5vIojDHktXSDhpGQjTvT8hpys4PjpgLVZGZmLApNQmE35FOfMThppqqnUor4+0hSYvZFyiy5MT6vlW2qJ33hpJ7dp6quY57DoWqQpkjhPRsKDjfin4173nIxk5K26tmCW57hMdDLpzpfvRD+oAduCHipwd1USXgaiCFsT+bFKeXI7WTqvfC0buqFmDkOoUWlXNz7wduuyLf+Ikaxq/MFrhSdJwZubWjbEUenexD5xgahN07HXcaKg5O39KbsjPT8ALUCG+Ty4Z+F9hFJm6VkqPE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199015)(2616005)(2906002)(38100700002)(54906003)(66556008)(66476007)(4326008)(110136005)(8676002)(316002)(8936002)(41300700001)(186003)(83380400001)(66946007)(6512007)(7416002)(26005)(6506007)(86362001)(5660300002)(6666004)(6486002)(36756003)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cctoQSX65iKzQZDsG1y+FydXRkcXLo8lL17mJ8LlcLBKv9dCQ/pVO4Il6WYC?=
 =?us-ascii?Q?kk6z+8vjTnJbC5ll+tqrlzNJk/yXnU+sOronNhk02RXyJUPMrK49iBDDFfI7?=
 =?us-ascii?Q?TfueazC8/5KoBirPV9PRyIsU2f2B7Y5386XEbg+ge6e4vKEwuYarhqWSmz5T?=
 =?us-ascii?Q?DphsKxkkJTsLZ5I1WI27sbSdD1+gMvmDLmlf8coXb+L9VLPcVUP76wpk+Wcg?=
 =?us-ascii?Q?RVMhl8KbMLomeBDF+CqgEsYCDbns8/VvWJ5Hao79/XbFal6ZHu6GrzvVGqN2?=
 =?us-ascii?Q?xYt9Km9dJO5RIZcIsUOiFH++Xs3SMLYIkz3pVQmuxFThu3Gm8Ffjc698hSbK?=
 =?us-ascii?Q?vG/S/aYh5ekMmXo6fc/qRryU0CnBrhW51Yc7g0pOXw7Q77AOHYdrFJHC2aFR?=
 =?us-ascii?Q?/X1F0i+sV9M54izJdVgjY7hM/AYcUrwDUM4+4/GFUOs8ojLZMYT0wHi2PmFR?=
 =?us-ascii?Q?ryzxpQiw6LBdDmYChTpETVJvXdE7OigIIl9fR1MSnD9Xw7Rn/+JGkCvTQDfa?=
 =?us-ascii?Q?RCOM9Djf2N728uO/A2LlHTHRQeu0B+J4XtVz3G1e47kxITniUD56I45YJpkC?=
 =?us-ascii?Q?NqBEF8x1wyWii/RU/bz2aBHIDDPRJfNPWiNfAm9EfzqVbpQx5lkJwxOWakh9?=
 =?us-ascii?Q?qtMDBcmfYIY+Gmax1v03XRRqZSmu49Ga1jgY8kGj0olLp+fknsJoeVI+NIUL?=
 =?us-ascii?Q?404i4yzLPxN35mk121yE4KloUe75ekkhsR0GLiCD0Kd4v11OxoVnQc5rm6rL?=
 =?us-ascii?Q?DG3VSJSzD/X8RaKY5ey7FLRZjQw9Lzqie8oDy776+1hhr8kguOQd7Q7xyRyv?=
 =?us-ascii?Q?4vnO8yzX9VbFqvoR4xozmcSA/q4P9cIgdByxpE80XiZSqGQiPI3EujPzWoPO?=
 =?us-ascii?Q?71LASB1N1i4ONhNVwHh6CDrUchkcHl8/Sz5PkqS9Md1wg5vVIMQDpOqJ4COV?=
 =?us-ascii?Q?v9JachZw5BdMNb/flVHFBFMZScAuXnC0++RSAko+p0uFPnzg/RZhYXrngG/0?=
 =?us-ascii?Q?q+9o9mga0rWbJ9CKNl1knV9I23IsefSnF/SdyEy82JjRVhCR1m4ZtN7PMCHQ?=
 =?us-ascii?Q?WOjlVcJ7QtKkBnw+BZo5hCzPYoZ3sa9pBvhZSwVRRNhL2dEtfrmLUGecIyL3?=
 =?us-ascii?Q?v1A9G6hCuqyLTNYbev0bpTchlsD+Rak73qZWMVOqE28b9V3fsNE+tCvxoE0h?=
 =?us-ascii?Q?OVxlYy9PRocLoXNKYnREs726UrHpstBwf1Xt4ClEq7hJ8kGhZdrDVmqhsQag?=
 =?us-ascii?Q?nPrxCaH/ptaCvbh6ydu6TUzu5UY6tbOZUcr83iE1vIZayQJZs8hGaJptAih1?=
 =?us-ascii?Q?nY8aBwEL2N4nCkqPlnGtRy+uqsQhBzxs7Bc5fVI+yPWhb60+WbcR4sxFSr0V?=
 =?us-ascii?Q?CFTzd4b4P7WCd4Y+Tx7Fur8wRFL+G5cLq2LOzRcdAnjJE20qDOnviT60y0YM?=
 =?us-ascii?Q?baWnOeh7CL1W6H+tLMVNvOh0VirtP+PZKDmDWPnJqTvNHyavSnQ//L/IbM0D?=
 =?us-ascii?Q?6NxZxRZUUxA2mu5XwYhoCbze45rLtTvEf40uUaT+7mI5NY0iShd0WZ4pplJo?=
 =?us-ascii?Q?EoiNh9+ST28mJVMQF+c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396aaf4c-bcc6-4ddf-6eee-08daa797f96f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 12:40:39.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYfoA7etwlSO5WNKHx8QhzAk0dHrw/rrNWjvEwlw1mxNpL0w6xRRxblOopOS0E/s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Testing has shown that virtnodedevd will leave the group FD open for long
periods, even after all the cdevs have been destroyed. This blocks
destruction of the VFIO device and is undesirable.

That approach was selected to accomodate SPAPR which has an broken
lifecyle model for the iommu_group. However, we can accomodate SPAPR by
realizing that it doesn't use the iommu core at all, so rules about
iommu_group lifetime do not apply to it.

Giving the KVM code its own kref on the iommu_group allows the VFIO core
code to release its iommu_group reference earlier and we can remove the
sleep that only existed for SPAPR.

Jason Gunthorpe (3):
  vfio: Add vfio_file_is_group()
  vfio: Hold a reference to the iommu_group in kvm for SPAPR
  vfio: Make the group FD disassociate from the iommu_group

 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 drivers/vfio/vfio.h              |  1 -
 drivers/vfio/vfio_main.c         | 90 +++++++++++++++++++++-----------
 include/linux/vfio.h             |  1 +
 virt/kvm/vfio.c                  | 45 +++++++++++-----
 5 files changed, 94 insertions(+), 45 deletions(-)


base-commit: c82e81ab2569559ad873b3061217c2f37560682b
-- 
2.37.3

