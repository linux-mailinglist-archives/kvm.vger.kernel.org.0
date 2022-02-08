Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42CA4ADC6D
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379891AbiBHPWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiBHPWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:22:32 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE93C061577;
        Tue,  8 Feb 2022 07:22:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1spJ3UsAo7kPAggLcAZ+rvayhrL20tUZudTn6Srfqy9+4mWThLCMCt7D+z/UEN1CnsY5sDT/IrvyyezZ2P3X1Na4kYifjjALcCXAfZjc64HaT7ksniEAzyu3I/FtfYiwuWhXyl3rg2D6rztiz1yZjV5cVeIoXRPNPmO0CcjKJwUNbCJlvO/MtQa1/x5t8Faqy+NHi6srNBfDZFZ3461bQdZ06Iv3kIjWil+0eLmEpjFK3Hk3hv6turl20dgfeZMsww5hoLyCxh7Xf1+/QBn3gUvB5Po7I+K7ikvjnS5c8v0ge5UWufLcy1id4ONPdHSw/YboRZJA5sOy9qHmSrF7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgL0r9lVRQ6uIGixB0r9AW7W+zjJj4BQ1aqRCBEbUNQ=;
 b=hr3moFBaPc1CQBawiF5KnIo/VEoK2UEkJH/QRp6LERLQsh+6hjoohvQqis7edr7TjhWFaYd4rWg2PpgpmNOdkjkVMxy9DTkHczZXUrzbVmpE+yyT4TLI3DgGNX6eOBwUxFfjPFIX1KzrmnTackBfyfTfDD05GfuQ27oM7bUI+BL+5/S9IiGiM0ilpsonWHFU7KyuhxsbCewr/SA5DHlTSlkgZyYLtdW+aEJ7zu+IftfeIGy8oFSngcrGY+79LDTBJzj2oNzVHVex7TAY6p6DiJI5a9FSvdYO9bfOM+Ywr0Qip1LoXGruF07ZnO4fPk9/LT2wJvbJFQ57A3K+uymr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgL0r9lVRQ6uIGixB0r9AW7W+zjJj4BQ1aqRCBEbUNQ=;
 b=ui+LH+B20y+TlMNtd6chKgPi59mFZ1Ac2iPQTOJ9ejAr2t69PoYnB6ZhJv7Yp5QyIWI81sZuSUDVCyXoUaRh1SSsw/+zCMsjZj2/4UurjXthUGI88Ys36s+opd926KgVw7VcOkvJJkKb7gYjvzVfL9HZrO2eigHICf5WDRsgHd5LMaLIFajfC8m8kLh+mgWk6FkFFEn1BxsAEwzm5g5bOv1DXum4WBFhWzDcpQ5uQbYnleLBzQmXN0u9WNSO3un0fCs5NkNOE96eGN+j/vQ/Kjiy3B+Ocj9XawHwRCqJp0CDf9c/Du7zWnNNUx0io2SBYppedI+f5gLERvBLDiV2Ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5470.namprd12.prod.outlook.com (2603:10b6:a03:3bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 15:22:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 15:22:28 +0000
Date:   Tue, 8 Feb 2022 11:22:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220208152226.GF4160@nvidia.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: MN2PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:208:120::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f509760b-7d42-46d9-746d-08d9eb16d127
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5470:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5470B6CA5AF216E124A1979DC22D9@SJ0PR12MB5470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vfsm6MFZaXbhzU2x4colg4zROJG4lJx/1wxzJeIRMxQQMGsaGS7QuUBXAosxKSx7ZpROBtnpGWVOpj5haQRxP1PBzw1fcVMwPDCatpQm/PL2xIgZnrhjPoFlDjBmmUz6FbPG7UDfud5CpuBdsaVGeT1xz/VicBi7kWmtCWXmoqX5RE83KAAX73keDnANFGkhVKaQSWleDAaL7poD4gvl6PXxphXQaLNQPzIJPjro+e9B29NXq2rb41HwnVJkIuwGvPyaU4aGVKrx6dCGDNzNrM2x5q/GH8WSOk84fAYbqifqann5a/nd8Ue015cd3yGRCNPxAijheWZJ2+GqTaOgmV+uH/Cfis9E71zsZ0t/uNxQ1X2zWb8vp/j4yrGnyhG3yOhdA0zHIimnpGG55iBCRo048lrhKXQznMvBE7fgelsDEdwKaizL8Ns3UnzP8o/uvY2ih9wNPWQ00UibvGqbb3GTd0ZGw2rl8IckBEU9sNHYSNunxNRopsAw8cCYz27QEhinHhqq7HTHwziIY3wPvckfJ0VtQ891JTgujix09H0FYQ3J9c+NNgx6grGJhAw9X8fZt7XKeNvK6Px3VtbkhbGMYobvL8v9ZgbFu/PCqK8ec9gY3uBKvLE+c/iiHRmzLKrYLSWWNq/j7BhPoNYZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6486002)(6916009)(508600001)(2616005)(316002)(33656002)(5660300002)(66946007)(1076003)(186003)(36756003)(38100700002)(66476007)(66556008)(6512007)(26005)(8936002)(8676002)(4326008)(86362001)(83380400001)(7416002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ENdg58BygNGUHNyC09+k3bfvFVF8UEXED6YU/m2L+4CwgM2CZVaoMlOO19k+?=
 =?us-ascii?Q?m+J7/p7a15vi6HcbfloSs597Riubh/v4eZcS8Jd57R3OdxAW4fPQM1GdDvZP?=
 =?us-ascii?Q?QWJT/giRlcSli3n2201nV59kGEt/pZXHcmuPMyxlS7ZnoIMfjamhAfGM345D?=
 =?us-ascii?Q?iajiSZSJ2Vte1RPJP1cnmwrO7nIK/g0OlOFTJRMLE/LSdvMJDYrWWPBON0pK?=
 =?us-ascii?Q?TzFgCcfGMerNwiqD6In0eIpyHByK1tYJIteimAS/QqOxeK3OqaulC7EKb6wq?=
 =?us-ascii?Q?sMkJMt7mvrQ/Yez1ZnbBE60FJhaVlJySXAxCg/WaB7GDuav8pIykjpbaZq8h?=
 =?us-ascii?Q?VwIlRUWh4/wfHTVFLohyLDDTQ31kqEZhju1w8NCA9Ye0vat4WAwNqEyLjWLB?=
 =?us-ascii?Q?y+zKVelCuPLfWpWqzM2CpvAmhf2KwoWqlHvQKcc+WBr4bnsv5Se/GspPqSYv?=
 =?us-ascii?Q?swKlgXkvQI9NAIQalKjjkhuAk7OF/9vqDjk9S6v16zRNKmFQj1CeNzpfbIWz?=
 =?us-ascii?Q?yPga82erzhDUcXm+8ujb1Uu72CQNPF0PfWyVECcL9VADjMul9OWxK/0BmP+2?=
 =?us-ascii?Q?O/Yyeg+HTgFs+AAxE9EIt/NKs8qMUOL51zK6gyqHAXQhlmb2TK1fLgJYwRqc?=
 =?us-ascii?Q?alc4AnAQ/t6PcNI2l41jEf6/BRHtQlUMB+Kg/Lz9gLWROivvMCuH3P7bV60d?=
 =?us-ascii?Q?Mc0beukbNf9DORjHNzo16JX8MV/RZk0dBqcb8u5d0PSmcwwCERm64h3tk8Tv?=
 =?us-ascii?Q?r4FwESvMpWtYiwerFHFL2rQDbrTELs6sad9GGlGTV1AfKwCi/Uc5wqEDjvGN?=
 =?us-ascii?Q?0y51pKNNiOX5HfgPp7oCiSMJlwBJj1h1bP1l2uc5zRODFJvpDqeutLA03HWM?=
 =?us-ascii?Q?n4Abu36VVTMvAxzMmuBwKFSct9V+HxXy0cnRaFZwyYzr8fvqOQf1iiJEhwiW?=
 =?us-ascii?Q?xV9BuJjRWI5mFdX9GXE3sYprSCeQfcUAAGkZCqt7DieqrkyjaA7UP9sNjb8q?=
 =?us-ascii?Q?i+CVl9sD9n0iy++8VD3D0NvzN6KzukmdmSvOECtoxRxYMVbd6d6v9T0Y6B4j?=
 =?us-ascii?Q?RUagh93yd7yUopFRoBji2fEH8cIW7whi/LIj7r30TYEIl1ANfCHRNG83pWhx?=
 =?us-ascii?Q?oUA/Vlitd1164b/NUOU2OHLJ9NQAlOJfDM4ti8Ix/2JFi1A3vZpqTFhgwze1?=
 =?us-ascii?Q?UgP90SLfCaOZ6lK31BgZ2XebljAzzL7DaP71pZOdsdUdVPGC0mWipbq8txIo?=
 =?us-ascii?Q?jJK4tITgEQ5KgO5PExdh1oEZTnlGpEMnzEQTIzqy+nbVSj1s3R7LOXYRBVqX?=
 =?us-ascii?Q?MsJrqyaccfXoCyF+DLXAfNhmp8Lv7ho6xrJHpL4yytCqYaoKcyM+VdWmE0K0?=
 =?us-ascii?Q?5Aqn+Q8IpWz/8mn1oNiAyBov6qQerZkmCsdfuDKIT/4UbyX8dXWVqHEoQn1W?=
 =?us-ascii?Q?ZqDVMthMCKQ0VBD83y71yjVJYfv9C3Kje+RAoLvP4Vt1g+bLQmbkvPFab5Mz?=
 =?us-ascii?Q?6GsILCXRYP0DH+SzIV5183Y+T1DkN8lH5Go5E7HayFE/O93+XRrESYnl/MGW?=
 =?us-ascii?Q?MTgI6G9/LlXuThwKOck=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f509760b-7d42-46d9-746d-08d9eb16d127
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 15:22:28.4386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hV7D9Qn2gCtG6kWeey7P/jI2Zp7wbvRIHid+r0HkoDdTXDgkLiFdtJQwYkw+GLmz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5470
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 01:34:24PM +0000, Shameer Kolothum wrote:

Overall this looks like a fine implementation, as far as I can tell it
meets the uAPI design perfectly.

Why did you decide not to do the P2P support?

> +static struct file *
> +hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> +			     u32 new)
> +{
> +	u32 cur = hisi_acc_vdev->mig_state;
> +	int ret;
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) {
> +		ret = hisi_acc_vf_stop_device(hisi_acc_vdev);
> +		if (ret)
> +			return ERR_PTR(ret);

Be mindful that qemu doesn't handle a failure here very well, I'm not
sure we will be able to fix this in the short term.

> +static int hisi_acc_vfio_pci_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> +	struct pci_dev *vf_dev = vdev->pdev;
> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +
> +	/*
> +	 * ACC VF dev BAR2 region consists of both functional register space
> +	 * and migration control register space. For migration to work, we
> +	 * need access to both. Hence, we map the entire BAR2 region here.
> +	 * But from a security point of view, we restrict access to the
> +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> +	 * override functions).
> +	 *
> +	 * Also the HiSilicon ACC VF devices supported by this driver on
> +	 * HiSilicon hardware platforms are integrated end point devices
> +	 * and has no capability to perform PCIe P2P.
> +	 */
> +	vf_qm->io_base =
> +		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> +			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> +	if (!vf_qm->io_base)
> +		return -EIO;
> +
> +	vf_qm->fun_type = QM_HW_VF;
> +	vf_qm->pdev = vf_dev;
> +	mutex_init(&vf_qm->mailbox_lock);

mailbox_lock seems unused

> +	hisi_acc_vdev->vf_id = PCI_FUNC(vf_dev->devfn);

Does this need to use the pci_iov_vf_id() function? funcs don't need
to be tightly packed, necessarily.

This should be set when the structure is allocated, not at open time.

> +	hisi_acc_vdev->vf_dev = vf_dev;
> +	vf_qm->dev_name = hisi_acc_vdev->pf_qm->dev_name;

Also unused

> +	hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +
> +	return 0;
> +}
>  
>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>  					size_t count, loff_t *ppos,
> @@ -129,63 +1067,96 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>  
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
> -	struct vfio_pci_core_device *vdev =
> -		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
> +			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
>  	int ret;
>  
>  	ret = vfio_pci_core_enable(vdev);
>  	if (ret)
>  		return ret;
>  
> -	vfio_pci_core_finish_enable(vdev);
> +	if (!hisi_acc_vdev->migration_support) {

This should just test the core flag and get rid of migration_support:

		hisi_acc_vdev->core_device.vdev.migration_flags =
			VFIO_MIGRATION_STOP_COPY;

> +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.h
> @@ -0,0 +1,119 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2021 HiSilicon Ltd. */
> +
> +#ifndef HISI_ACC_VFIO_PCI_H
> +#define HISI_ACC_VFIO_PCI_H
> +
> +#include <linux/hisi_acc_qm.h>
> +
> +#define VDM_OFFSET(x) offsetof(struct vfio_device_migration_info, x)
> +
> +#define HISI_ACC_MIG_REGION_DATA_OFFSET                \
> +	(sizeof(struct vfio_device_migration_info))
> +
> +#define HISI_ACC_MIG_REGION_DATA_SIZE (sizeof(struct acc_vf_data))

These three are not used any more

> +struct acc_vf_data {
> +#define QM_MATCH_SIZE 32L
> +	/* QM match information */
> +	u32 qp_num;
> +	u32 dev_id;
> +	u32 que_iso_cfg;
> +	u32 qp_base;
> +	/* QM reserved 4 match information */
> +	u32 qm_rsv_state[4];
> +
> +	/* QM RW regs */
> +	u32 aeq_int_mask;
> +	u32 eq_int_mask;
> +	u32 ifc_int_source;
> +	u32 ifc_int_mask;
> +	u32 ifc_int_set;
> +	u32 page_size;
> +
> +	/* QM_EQC_DW has 7 regs */
> +	u32 qm_eqc_dw[7];
> +
> +	/* QM_AEQC_DW has 7 regs */
> +	u32 qm_aeqc_dw[7];
> +
> +	/* QM reserved 5 regs */
> +	u32 qm_rsv_regs[5];
> +
> +	/* qm memory init information */
> +	dma_addr_t eqe_dma;
> +	dma_addr_t aeqe_dma;
> +	dma_addr_t sqc_dma;
> +	dma_addr_t cqc_dma;

You can't put dma_addr_t in a structure that needs to go
on-the-wire. This should be u64

> +};
> +
> +struct hisi_acc_vf_migration_file {
> +	struct file *filp;
> +	struct mutex lock;
> +	bool disabled;
> +
> +	struct acc_vf_data vf_data;
> +	size_t total_length;
> +};
> +
> +struct hisi_acc_vf_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 migration_support:1;
> +	/* for migration state */
> +	struct mutex state_mutex;
> +	enum vfio_device_mig_state mig_state;
> +	struct pci_dev *pf_dev;
> +	struct pci_dev *vf_dev;
> +	struct hisi_qm *pf_qm;
> +	struct hisi_qm vf_qm;
> +	int vf_id;
> +
> +	struct hisi_acc_vf_migration_file *resuming_migf;
> +	struct hisi_acc_vf_migration_file *saving_migf;
> +};
> +#endif /* HISI_ACC_VFIO_PCI_H */
