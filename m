Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9B85F7968
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJGOEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJGOEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:04:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDE313E22
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrcxqTWj8UCQAbtssPmM2xKnx4prRfAO8bCva1nMZjC5w1Usp0J5r9Duivnzc/Xy9AT48LUICI3nYUmKdQhhI89wWCfVAgSHOPptvR44lEF1CBZSMiThXHzFe7HDpuK1dkjW60dQ9DaRgI0N87MMr2bSIzJnjvBeyhVcO+ZkBHfi6TH0kLdn79Tmi1imB/HtsCFH6dhEpqTmr/s6uUa36ISDdkR2Rckd2wiFScz3iVnL6c2SSzxGZr/3QEQvl40RQNWn1mt3/sAj9Iudyf9ZsjGsPYZnjZk59OEz4Hk8YgcXAKFHScdmVAiga3MeLD6wVxtX4AhRyzRyIGuOGwd9fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjd+/zfLZVAX0Hl8CwrYctJeKfe4YO4+XRX5ErcgCAw=;
 b=TZaYAOVOQxDSW0Dc0fN+yDQGmAw7md+0DeK67jDeYe7vtb+Tz+s7l9Ai6vIqxdamPdgberLISGNjhGkfeiT+hfyu2EMjDtWu/+EfpUMlgjulu7T+36NJ3eBRJgIE6J9Jr2liaOkU5QZ1JSKXOD2WmygE0Gl5fB/KVyJy3goNWYh3UheYeZRyTxrHyFufWhGjT/NuStDrlLc3DXrXUP+ppiySQBe1/vQF1SG+9pbS0VpqDYwgYaxl3ivQfiW9pVW9QA8ctF/WQPC+OQstb719eFRuzN1EF+yi+WdKUQnnAWtxBEfUvfrbkHe19B2OcuW613bJ7tVuMcan7UODVdXY6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjd+/zfLZVAX0Hl8CwrYctJeKfe4YO4+XRX5ErcgCAw=;
 b=awtnXqPK2JFleFEvqNu+nQrRg9+pT7AkiOORD4AL51zQoQ+5TJ2oRjFCDhelcTmNW3vNqKaPB6QMIhly0HNJRpSImlV1GS9XzOxQ613HBWqJb3XVsq6FMvNCdyxwjr+YORH5J8twiRUScYfBLr8uTssns8m2nruirDDJMwI7vr2ps/C2wYcCJCq+QOl0XaNCZ5uB39C3q+FvXT4clj/0ckqgA2c4PdyHrJuZJJQHGqa7e/QBA9hWO7X+usWDH8H6BUaXX1B90GyNmR7iINNjK63sM/TueULFOZBna1zN6ZQg1WlqjCnGucIauK1ZVp334REFemzhm8u1w5Oxu4XtwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Fri, 7 Oct
 2022 14:04:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Fri, 7 Oct 2022
 14:04:42 +0000
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
Subject: [PATCH v2 0/3] Allow the group FD to remain open when unplugging a device
Date:   Fri,  7 Oct 2022 11:04:38 -0300
Message-Id: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0082.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b37599-dd32-4135-48c0-08daa86ce1e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pt6pLQO4tJQHn3mcO+IN2Dw+3Jrf9oiGRQvAJz2jn4F/wUKZyMJB/00zFfIbpfLThiHqTzNaUzE9DFrXlcfoVsl8DM9N/3L+QxubuWydLfiVl7AzRE1nxjyQD+g+4UPZ9EcWKdU0ISrpnDfaBj0yDdG7XqcAZsyPkIULwGOSkTIwSngFppYW2RZfqgj68Np4VNvnFMBljgKFvGQr9d9dDAliLDmIvph1V+MCsnElBDkhUXs+AJbr2NpiI9ZH3rp96i9Aa7PR96ndQhdR4b7JyuUeDy1tUlzL3E+kaG23aUEknO4Eb9SuPhFSxbGH8+R84Yrsqxq66iy6FdTNrOKSVL+VanAa3gpNcdL0IpxXmvNX+ux5bKuoJTkJL1pEMupCkBKqM9B4X1DtPU+XCJt6bjwefJ1yibUi+yyxF1HFs+Lv/Cl4+BKIcsgqAurWRMvoMIsTYWAdFj6VWjUCFwfjk1E+Hgn5vsrk3J0dRDdAFRqUWaMiMwZ93pQ13Gdz9P0gedfpFzZl/szyE6Q0Q2oBdDuWK+gpULstY3Pn17CJvCjIHdEPNlBbRzBFZU4t+LQ4J1NYrJL7J3zLxA2AG5Fq5U6sWLOnnQq7gcehgWBHZ44fK8Q2BjF3jGHaFi1w6tQzsM97ouaJzjZADv4hnR5JT1jZlKJJy/6PLnj+GSE6e3X+lAt4ZaK+rBoNzPpdUD8TYn/OiJyCccRb2e6HV7krrX1eV95TXok0lUWfWaSf9t1dzTs3u2SXkTveOF/6ZOk4CUtm6MmaSE2mF3o15sGcgx1DchmXAnKh4W3fqUVR0Ee90kRzxMRaCp80VTMUdDEdpprB8cgAobLwnF0VD2Dq5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(110136005)(316002)(5660300002)(54906003)(966005)(7416002)(36756003)(6666004)(66946007)(4326008)(66476007)(66556008)(41300700001)(6506007)(26005)(2616005)(6512007)(186003)(8676002)(2906002)(8936002)(38100700002)(83380400001)(478600001)(86362001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HwulmxxhpN1M7r0ATcI1LPu3z71keNHQfUniPnAgkvoUlJea96aqUgAazpf1?=
 =?us-ascii?Q?Ii5mmupcwaZ58SpAME6SNnvnY78LIib+pQcDVoUu6eXAR+82Oxsj7LLxbpTB?=
 =?us-ascii?Q?hiuQo8w0MxUzYWBs9uvrpsNFfU+89/U2Q9g/g3T5Q2TILnh2PqQ5fWf6dpYr?=
 =?us-ascii?Q?G+r1kE3AURvdoz389lAlTtJmSq4t997DjoFWU7g20HGVFMFEorrWO29NrgQW?=
 =?us-ascii?Q?vGrAZ7fePZsnkaVzQz7m66R2vqCTITR1dEcHoMltK9F7LFcIsHiAtcFBengL?=
 =?us-ascii?Q?zEKqgT3Ii+fLixgD3AWRe1oHEBrk7DTtidHRy8P9HrUxSDJJObIBs1++TFCT?=
 =?us-ascii?Q?j/Iuo29GIIC1CwzexH7OSXlBUKdpi/QcnWdsTwTvBAf7yuEBMu18FKLFWDsf?=
 =?us-ascii?Q?dFsD7al1Jf98MZfpBEjlW+AlbO+p9YyjNoEriL7lkoRwYGIx2SbG+fH7kEIw?=
 =?us-ascii?Q?/js2rjQsR38t8jC3p3Tt3K8uFEpOabtABF8trdUPMjSJQYxqcmvSy1EGxvEV?=
 =?us-ascii?Q?U43Jd3efBoC9PzjSK7YlUmza9Hu4b+Lj/J29Xs9vZgiyA/8qfT1jc4BVVrq/?=
 =?us-ascii?Q?miHfkxDX+j2mWgABjaXgGnH3IFPPY94x49qvXrwtTh+oUx+KCceh84GdakMp?=
 =?us-ascii?Q?MWfCdO0PkbdFZAqQIXwjZzlXah6AVQyNBBHORa9UueT7VBQlGzYbvVqGTWqa?=
 =?us-ascii?Q?rosjJtaMDGftGUdtblRgu68R99G7vJ5ZBD830M27Xj3joHZNFr3+VvG+ItMp?=
 =?us-ascii?Q?V8Oz26s7LrRUVfD0YJVjJLT7kfS2ODlyZdJJe77MGYANL2UQ5v/U4hcpGYQT?=
 =?us-ascii?Q?ht4SeqSRToK+T3MJLS+gSPJptTL0bpoXKHnnduPZnbljxRDWCplAHBRs7yp4?=
 =?us-ascii?Q?9wbS/uEeuAa5+6TN26RNZR5EgQoAwnmPGvNbKcn8fD+lmffIehWVnso7tAL4?=
 =?us-ascii?Q?3cmVHhZGbwdkN5th0WvnfkVRJbeRqHDID//rOhU0mq3l3Cb59m7uE2yLTHEe?=
 =?us-ascii?Q?/riPfoR3bw9nETxYW03zorxbGYesvVGyUENzzZB4isr/ml7ieXfpB5Rdw6wP?=
 =?us-ascii?Q?VBWf6DRNwZEf5T+B9fEmdi9PNBYhZML17kQ/sH4MA+oO8//trUQp1yuL+0uI?=
 =?us-ascii?Q?+Q9yynW/6kl6S02t79AqQ8q4TNNWVxz7JY7WNeC4ycKRLMWXoMMUE8PzBWqV?=
 =?us-ascii?Q?+K/XAsUbWwvF26aYEnACM8fzuGyjCUFgDQ1UY4B/LeHucNYYNvmtkU5CNlwa?=
 =?us-ascii?Q?75oEyfvUUmTStbGOmdGyB71tGXvf9rnOBx0BjwDJ5idB5ovM+lX2t0ITWqkg?=
 =?us-ascii?Q?+gzF7S1r47e9EGyNGzLIwhHP28xHbkjzvJcOH5DoRDemtXqdlBiP50d9kCtj?=
 =?us-ascii?Q?AlrzNCth9igTPGO/AUjJmG4ErdpJn1nwfBSYPaVTV33KpCWfZxfwuQ4ednzn?=
 =?us-ascii?Q?pv2DVR0ggQwuhuFgN/dSwEvZLzYVZnBsBdLXlvlzPImSKHR7lLdPhQYo3siY?=
 =?us-ascii?Q?v6KXbzguCuKS6phDqyHOeW7Fwcf+vhmVTtRSq1ePGIIyaoS/0sFEYfa0wkW/?=
 =?us-ascii?Q?tFN828NlAz2SrDkfAJbpOaa9hdJHK2Qv/FuOeIYK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b37599-dd32-4135-48c0-08daa86ce1e6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 14:04:42.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bUlNDUuMvRQbTKISPzQI8ONjw9xMOa+km7HNvgegcLa98Rj+kQ+slRV7XSO534u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
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

v2:
 - Use vfio_file_is_group() istead of open coding
 - Do not delete vfio_group_detach_container() from
   vfio_group_fops_release()
v1: https://lore.kernel.org/r/0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com

Jason Gunthorpe (3):
  vfio: Add vfio_file_is_group()
  vfio: Hold a reference to the iommu_group in kvm for SPAPR
  vfio: Make the group FD disassociate from the iommu_group

 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 drivers/vfio/vfio.h              |  1 -
 drivers/vfio/vfio_main.c         | 85 +++++++++++++++++++++++---------
 include/linux/vfio.h             |  1 +
 virt/kvm/vfio.c                  | 45 ++++++++++++-----
 5 files changed, 95 insertions(+), 39 deletions(-)


base-commit: c82e81ab2569559ad873b3061217c2f37560682b
-- 
2.38.0

