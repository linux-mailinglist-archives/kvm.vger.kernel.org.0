Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F77E419867
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhI0QCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:02:19 -0400
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:28768
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235396AbhI0QCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:02:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUiHgMxlB4t5PSstKHAYZgL9UvIghVbs8TT+8wCYK7TvPqN8U3ZZ7BgeEQGBUvagGPHZ72MnbEDSiHPl3Z6FkbdtMdXOeqTVpW5tu1JJ0Zbw7xxCF9r/rETQvAsex4ndM6U+ZYWX/y2k3ggYxW39bgeg/K1Qy0I5fGt1jdiM0g9r3qOKocFa4wLsR8fcUEzqk29caC7jlkb5CU+4ogIN3ZwHEsZPJbUxD7dXyQRDN272TjDnMpJ4hO9E7kB+mtnDi21yUJoy13OwHx9ZKrpuQlE4dN3WxJfAhBbc9xY/VmFyZenbXWa+H7dtgSP5zIU1P2/te5qPjEKLRzKEurciPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uZ+yhnFuKUsTlHbfCmy3xE2movGasZL6QHGeWVeAJ9M=;
 b=GoG7U6FFK/bUfRFVlQlmUnQEzEumDrgOfTWLVKnHpqppeUY/tHktz80cECzoJ5m8v9TlYUauLQA4IHF5HMo1ODedIcbTHIphOFcBPW6k5mnU/Tm+Z6wnCL5ijun7Hcqxg3Xr3YSO3QzJ84XnORD5L/CbbgbT//S/Ehn5MQDfULLX/x6VMs7/HM0ARas9bJic+5wANY1HYs0x0OZcDICtpEiiKtG+xaeiY4Ntath0mkI4GPpFgFJ0tyGj0x8TaWFB/eNhk6axXmGax9U193lkJvi2oOhjpodLq2IwWTpEddMvkW5QPhwVIa6CGBTTJe2MmSPkTTEZHfdr7ppbUGwcYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ+yhnFuKUsTlHbfCmy3xE2movGasZL6QHGeWVeAJ9M=;
 b=uQTAPzQZ0lpaf+GBRiOD8pTE+vga+lgkXthbrGuCD21+9I7eWTT0Mv1Gg4bdnQMciH8OvaiRSfoBDut5xSmV2pFAwaNvgWTpE5O/YedRUvHOHsLKT6Hv4Qzs4pq+fy8Hq33NUSKB5u1R7W9Rv/IUR8S4nyQ9eDTUKFf6UDdSf1P3sfn4uAbG4ETHP4j2pqv6TuOWlWSfoRA4X8/FDMn7KfsEU2p+ZvXLy4+GMQM351J5UEU51fwCYKOOumIgV824xEw0gjNwrF5VceX6M1T7oweArm067MbIGhwge7Xib4uPMnM0zNJyalB0w9D+7qX2WycU0dPhE4dxUG2cPNPpIg==
Received: from MW4PR03CA0182.namprd03.prod.outlook.com (2603:10b6:303:b8::7)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 16:00:31 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::e9) by MW4PR03CA0182.outlook.office365.com
 (2603:10b6:303:b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend
 Transport; Mon, 27 Sep 2021 16:00:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 16:00:30 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 09:00:28 -0700
Received: from localhost (172.20.187.5) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep 2021 16:00:27
 +0000
Date:   Mon, 27 Sep 2021 19:00:23 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <YVHqlzyIX3099Gtz@unreal>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210927150119.GB964074@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daa283ea-ac40-412b-9bc8-08d981cfee7c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5245:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5245543B18A9D102C63AEC97BDA79@DM4PR12MB5245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CM9JYz2mTjx/qU2hqXNr6k2BKU+yJba2eVk5PhcQvnGYSh4K7wdF2Fg4bEBqscUAXKa2nEtXOvuwV0YQ4idfd7dagRnKTcsc3eKGAm3ljhpXzukC3kg5aHJFfEpGQTEJwD/fDvkpVkK7m7hw8ey5VV+aNnHDgTrDNmUGxkRZgMUWp4zJDKLP0TXkg0GGkmjeSE/5dcrdvoRxErlFc2WWzeXtQ9d+5dsBj5YV2+L1KYfcCI9WtG8F0DRxRTbf7RMGuXKgU0JXGtpgx+1po1lSqglPy0ud6k7vWY46AYa156ch1kn6f+eicRkt8P1kKD4pvVVF72Vf5xxrW4tRpHla1q1L5dQzMvBqkF8TL550k4QNqDtATo2wJ3wyPZLeuW5bhYvX9bGZk2USDwETx5rFuYwu3Xm1xyFiGF7FKFjV8/MIpGmFMFroe4BINBQAy6ioUQhlZUQapb2RbcvCOp4aG9w/eHFV69v7y1e/HvrgzAYI2knyKafTvVcolza2tZdBHh2EShzhGTC87tOyQ1MSf5Be4APy/ay3lpibBuqUpsVk0/cXk3A19M4LipC6gf5LHZOyX8bkk1cvswDyBCG1BbWZUtdKI6shbyJ1MRweOqj8vmL9NAN2/7bov52rIZBMfW7FofiAy4oLgPqUTOvgRpTV8e8HTRInDz/Mi+/ccPET2ZkNuAr4tpzNN3V0EhyuL7ec/+F4wIA/f81i0d9Lw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(9686003)(508600001)(83380400001)(70206006)(70586007)(16526019)(26005)(186003)(8936002)(7636003)(6636002)(356005)(54906003)(36860700001)(336012)(4326008)(6862004)(33716001)(47076005)(8676002)(5660300002)(2906002)(86362001)(6666004)(316002)(82310400003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:00:30.7883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: daa283ea-ac40-412b-9bc8-08d981cfee7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 12:01:19PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 27, 2021 at 01:46:31PM +0000, Shameerali Kolothum Thodi wrote:
> 
> > > > > Nope, this is locked wrong and has no lifetime management.
> > > >
> > > > Ok. Holding the device_lock() sufficient here?
> > > 
> > > You can't hold a hisi_qm pointer with some kind of lifecycle
> > > management of that pointer. device_lock/etc is necessary to call
> > > pci_get_drvdata()
> > 
> > Since this migration driver only supports VF devices and the PF
> > driver will not be removed until all the VF devices gets removed,
> > is the locking necessary here?
> 
> Oh.. That is really busted up. pci_sriov_disable() is called under the
> device_lock(pf) and obtains the device_lock(vf).

Yes, indirectly, but yes.

> 
> This means a VF driver can never use the device_lock(pf), otherwise it
> can deadlock itself if PF removal triggers VF removal.

VF can use pci_dev_trylock() on PF to prevent PF removal.

> 
> But you can't access these members without using the device_lock(), as
> there really are no safety guarentees..
> 
> The mlx5 patches have this same sketchy problem.
> 
> We may need a new special function 'pci_get_sriov_pf_devdata()' that
> confirms the vf/pf relationship and explicitly interlocks with the
> pci_sriov_enable/disable instead of using device_lock()
> 
> Leon, what do you think?

I see pci_dev_lock() and similar functions, they are easier to
understand that specific pci_get_sriov_pf_devdata().

Thanks

> 
> Jason
