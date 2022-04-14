Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFFF501B3A
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243078AbiDNSsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245503AbiDNSsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E879DDBD22
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJvwGT5ZUJPWRUwClfxoE9O8hqGif2S2Sy2lggPZEE1ln24+oPxbprS96fRG3+o/QofhJMGA9G/OV5/xVRyTByg1+8jQrl62VoaITV7bMVvkSuC6gZETVvD8yI1JVqgpWWUlX0l+oLukx9MwfFoK+9X6OufoPLTpmmGZy2ZW5UH8OQWBKPoAU5Wp5X4k+IjXDuL6JCnZ2/cqy+89YOW3p31ubgyerCpkTUKNSltVxQPOWLqy0Wfq80SJg61eQzo7OYoLESUuasVjN7n3ZxNrAdMtkMTfO+PKWZyyIzoe4QsO7kWIOtCc3IywONiHBDiQ60h3YJcjK03sE1e4zv4mvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQt8umRay2WuS9Yu9n4/k+6jtNtcp8HxB5m2Q1sz0q0=;
 b=QcxDoBNNpZtA2WtxBSEIHfTb+hqLeEmvZkwXw/ILMWDG/TLf1SlTSSHIdnV5Lx19ufF4WkuEAFK4FkEuel6sRhiRxMTTn9DHkHezBQndPIYxyc500C6UiulPETA4E6odUnXMf1essMF1ufhPBZYsIo+QJHC/9KuXZEh1n7OcV/uQ560jF/V5paFaESYTFQrf0+lLVjwiG2du7mPjlE/kT1e0FaYXPAh2t1gGP7Uo1xfmIGGIwoT3YkYEo1cQvxemVEbqhOHiT+a8+eUFRNgpRkTUIEuSjbZW1uX88pCEQGzR+unDTzz/Vv+HR2JEg3BG68D7HeHglIqiwM1aYLBZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQt8umRay2WuS9Yu9n4/k+6jtNtcp8HxB5m2Q1sz0q0=;
 b=b8Tg8ffMF5rgU5CHScnPNuyGUCPzU2Hu1cHKoSqF9Hf+V95wkdDcEmNsk3lec0RhAjlc2VLBYKmd8Mlyy8nHtnFk/4vqqkqGNXdzh6e0qEyS9NHmm9yf63NvEimfxkcqdNNM1nWF9U3l2i6KnPubeHWEahnRzGE30cJmqmOdkvXHYSzCzevwxvUlukkvjApu6/mLKhHPXxAPZG3Dw0rm5JBjKbreWmY+nnUqBGjmgyOm19FE1gybHV8ZBKHoLu1hxQi4cIAnwSkf00J55VVyYA/cUH8yFYRPfWoysvdaLIlNI5fLuGNuFRzylNZgSJwmC0euqX7x3vKeO/gnC+Ijjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 00/10] Remove vfio_group from the struct file facing VFIO API
Date:   Thu, 14 Apr 2022 15:45:59 -0300
Message-Id: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67ff8c6a-4e77-4ad3-aec3-08da1e470c13
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB535092483A458F8F32EC2A12C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DFxK3V8K8wxq0+K+8O7obmf1oAsCceq63R/nY1UEjn3O/QcNc5pwL2OZJw/fApH9RqTDgRvlhnAOfF0UdnsINnbVxiQgoZEmtStx76+Qb+/9WzKpnfH2LvG6z4HBj6QIfG5SmmMFrG9h+lgFyq34FXnJhHh3LXT9nVD4AA4Ir91AXRUdeyJ0urgmCbsHigzpXBDxVF3T94SFZf9G+JE0QfqMKqR/XgOpOvL/TR6zkO8eWWQmjFMqD3KmWXI/gm5Q51ZLzbzf/ZPNMVn4MN5rUoIGIDE5PFmAm4t9WzpuwhuQgD2XfPjL8ULUTmvWt2BrtssROi+wC/gtMPV4FRWXxKz1CPVJ4y3z+i6e+MNTYzJRSwK1yUm11saHJmBojiQntFMJRRw9nUVU3w1btLsVuicMog0d9rD9tREwgti7e1tPYp0j1yb2Nvc00O2hXz0TzNxV26bkazULuc7RCifu1cBTiFpvo9aAtK3B/xOEhz480qzgyE+VM1rkz6yn71wErJSpZZOOi1uGqyIl0ymjXD7+RkPMWOQl1lH9R56N0apH7hmr+G+hq1WYtHbZUVBcHlpGUMqBBErOKnACVIqP/VMJS18Iu+/zHqEVeDE2kMihwGxk9sAcHCzZgjnvau//k0oUTcPRyEHjGCu+6VoEmqHk2s8tOP0l1rVmot/wLo9RbOlIbG7nrYEpAKmkV1N9aw8QjKXjJghGXzqxheFH52c4i1KPMvc9nBjCXMReOFtMjzM8iVjyRoxHSiTNU4j8V7rwsXSB9e8EgZYgyS54bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(966005)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6lT8BjZFPIfZN76podcpBk5VW13mX4wc9qy5UgE6jx/UHN64V7IuRLxWFZwZ?=
 =?us-ascii?Q?isL+C2pdOVZgPPqLba3iISWCG//xbokRR+Katrh9e9k/wBl4cYfwP+79+bW1?=
 =?us-ascii?Q?oHpU4hV0xT+kpryjmvxZEh/bwWkuFs39w6OVQ83PkFAQZuifurl/iYwGEwgK?=
 =?us-ascii?Q?MkgN6BhkJxXVoJaIrGCGc8T6Cp3WfDlw74EHDf6aEhagAXNLRMDEcI1eQgDW?=
 =?us-ascii?Q?zJRYNl8iZOB5sGKbA6DfTLRp5O6SKlF4WG6UGxU841Im2Abwcu6kON17VwmL?=
 =?us-ascii?Q?XiVPepDfAhq/JEwqKg63OINUl+CEMP5NLmvmc3PUyvLdZd+kwsbe/+KLrvU6?=
 =?us-ascii?Q?vyFnRb7yWIsG4w6tDGAxDwLMkveKdbic7C98hCYce9auMC3cQxP90HRpJhN2?=
 =?us-ascii?Q?Y+Oy4IMfuvQol8wQNEO7WwIUDm4WDfIBRoKuVi3P5FjpQprPuW/NuWovRSh1?=
 =?us-ascii?Q?5fV/qBXBYQwG86xezQi2Ej7srjj/aONkxL7Y6ZMtAWU/Hx3wU9062B8lSXB1?=
 =?us-ascii?Q?IPmf1zD0UvXQKDzT7scz7Bu1LzSnO0r+tf9QmD3QKn/Cb9WJqNVYaabZaHak?=
 =?us-ascii?Q?HlU/qqUZ3h0w4pz6wP4JsxRC0VM43XXa6IEGQSzCMmRWmEjqeU0rVCaFhTO5?=
 =?us-ascii?Q?ItMSkDBkIo+M5dWb8Rdkf5vzfAC4DkPsGnwMYpeOiKoq67mcXXlJZ7QYBWqQ?=
 =?us-ascii?Q?S23qoVnp7+ZlkVtbdDBC2VOg/P91DqowPMcTA30f4+X/9SGKoh3M8RyWS/f4?=
 =?us-ascii?Q?+p8LpnRYzdu7w8sD7CnncqeqS5x08fUCKCFrctOfqXSxGMbZ/zHWMaM7c6sW?=
 =?us-ascii?Q?BUqGZ5yK1d46G2UGFuqwoN2//sPw35ALHICk+mHysWvOtW6wSaivsKJZfh4U?=
 =?us-ascii?Q?oOGplmoeqv2/cr3DRujaYZVKH0oyM2I0OtyClu2W1CvPAr+rokcH4Wm4fi0u?=
 =?us-ascii?Q?8bfkpxMrUS696S/lCVOdCCkb6NGmlKOY+ih7moNdirkJWR+EWg7/zgmX+mz8?=
 =?us-ascii?Q?o1FTnQAX13xyNit/jHruca9nwLJtuZLiN3HOcQp8p0LveLfm/SLhQPUP1TSj?=
 =?us-ascii?Q?QGmoifCMj26OYNUbVdJBZ8m91K9qM77HqNq80fXGENmzYJ0dZdKfFlBSk8kI?=
 =?us-ascii?Q?sv98AkX0JpXNuoelnHh6lAv79DEq25xEVoI+koKTxDi2Xo6j5lg4ABN0PMmB?=
 =?us-ascii?Q?GY2+P99Kts3j0hVnY65K3bXCFp5ZEG47bJdp2C2pgeyK3G+YqdQz7D1KncZg?=
 =?us-ascii?Q?q3eE0OI2V3ZV4XylilGpd/fNL4u9ZLv6KSPbW+BpC1miok0pFGEcPpKMi+Hw?=
 =?us-ascii?Q?04f6k4nI/tsQqG37S/e6E4GbCOCK8uaTTqMnJ+Oano9WNRePLp231w7kpi/h?=
 =?us-ascii?Q?dDiWo7CWE2eiiBMj0NNbOcEtsJvpD63yHmQdVlp11ypI7+AnD2aPGccSxILF?=
 =?us-ascii?Q?V08eEDBxxzB7aNAyp0UfacyrmIWn7z3uF8q+wirshR19WULaH/T+JBFljR5s?=
 =?us-ascii?Q?gFdvDSbmcWYnhRoojvXQ3RlAPkwCtfPdvnnPfBxbXJmyiPxrKu+Jyk75XtPn?=
 =?us-ascii?Q?KhkBJkwbNCGrGowfndqPXzcZKeJpgo3Z4EB2DzTTVa5628Hv3X3F1y2LMPpT?=
 =?us-ascii?Q?ebAZc0OuPWSfVuTthnNbeTXM5yIpwM2VB/EsrAZD+b5TvlSXrv9fMoA8FvDh?=
 =?us-ascii?Q?rxnYmOiUAsk6/bqzYHM2l9rc3IRz7ZWrWMG9M1PxZn8aEfovEQ6ZvbizLeCE?=
 =?us-ascii?Q?XiJjUYDmNQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ff8c6a-4e77-4ad3-aec3-08da1e470c13
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:12.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h89JL/NATJJ0X2q2Z5BBzAOgaemhumD6wYUyDWGkv7ZOnwXPXCPfThRh2XwCkB7i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the other half of removing the vfio_group from the externally
facing VFIO API.

VFIO provides an API to manipulate its struct file *'s for use by KVM and
VFIO PCI. Instead of converting the struct file into a ref counted struct
vfio_group simply use the struct file as the handle throughout the API.

Along the way some of the APIs are simplified to be more direct about what
they are trying to do with an eye to making future iommufd implementations
for all of them.

This also simplifies the container_users ref counting by not holding a
users refcount while KVM holds the group file.

Removing vfio_group from the external facing API is part of the iommufd
work to modualize and compartmentalize the VFIO container and group object
to be entirely internal to VFIO itself.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_kvm_no_group

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (10):
  kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
  kvm/vfio: Reduce the scope of PPC #ifdefs
  kvm/vfio: Store the struct file in the kvm_vfio_group
  vfio: Use a struct of function pointers instead of a many
    symbol_get()'s
  vfio: Move vfio_external_user_iommu_id() to vfio_file_ops
  vfio: Remove vfio_external_group_match_file()
  vfio: Move vfio_external_check_extension() to vfio_file_ops
  vfio: Move vfio_group_set_kvm() into vfio_file_ops
  kvm/vfio: Remove vfio_group from kvm
  vfio/pci: Use the struct file as the handle not the vfio_group

 drivers/vfio/pci/vfio_pci_core.c |  43 ++--
 drivers/vfio/vfio.c              | 156 ++++++------
 include/linux/vfio.h             |  17 +-
 virt/kvm/vfio.c                  | 405 ++++++++++++-------------------
 4 files changed, 278 insertions(+), 343 deletions(-)


base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.35.1

