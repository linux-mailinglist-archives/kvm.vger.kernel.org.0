Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE5E5FA35B
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 20:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJJS2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 14:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJJS2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 14:28:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B49874DC3
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 11:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXc/wJb51hIF4Z5frYD55WaSdGZQSg1tXrPI/oE23jlWYAf/ofuEMZu3JFem0JNDzWyVeThkSPXwLM6TwK3Ddw1zIywDN5RiN8u72dZYJjit058/QaeoFmWLE3Inr4wsFdVI/MOaqDPDtp0FCz7K+Q6tiwAGz5vndwXosRJ1kRqPhd0d6ZmzUBzgCTcjarOXQawFmrdECtVcDEwZRkVT42V0YM6JayIA4hSzIo/fgm4IQMEG6zRj3dCVz4aD5XltxZC9UZ/I/GdH+XPvgZHkyRYfzvfc/Jm5dRzB6GTWWED4ed7WZRXFoNZn13/OetjCgLi9bwHvzFli1ltW3LhcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsaDn7amSYCyS0lgDfMQHHGIb56bZ2Sc4ltb7Wrq4dM=;
 b=CdFsA0OhrxXmAfGijse3eRcVRbD9tH1ct68GkKC5rz5+09/HZvaVptTaT9HOjBx+teAtAYRsHqhNPIO8Wz3uIgOw1gZpGGhb07ekAM6jF8ngWFplbPjLuTx+62TzkIgkFaUkD6oD2MLTIBIaBGYHqXXm8GUbPOL+B+TZDYzdv2DDpq7Pb4sN9Ouj6vUZSHhroxQtoNGrczWoMWuvLAwSRoCrnFI2d0e3jMzKlnJR0wcS0cK6+lhkSPoBRViksEBqkP6gwEISd6nRgk7HUMAtptW2D65TjDkoVDrB1nVdZG8b0tw1SRktfcGaiICudBrCxJc1+9aTze07NW5hh29BQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsaDn7amSYCyS0lgDfMQHHGIb56bZ2Sc4ltb7Wrq4dM=;
 b=DoGRO6a6+i0YraDb6D3K784diTOWSH9zrz/RnPON8ktyB/y2P6NuKf+GXvLEX9flmb5fq6fKi/lJKgWgidGW5olFnpXmVNGTCA5Gp6nJh05UEyPlo2WA1ox6cwruSWog0PPaO/Nv44jD/hGVUDYP+VNokLQyykp11wIKT5tB4qcW/9k30YknkjZu7tFJjUAttATgk6KFRuAXApjGEaHt8xU62/8BDxrJFwWIZRDkIv8yQZjuCX1ZVz2fze0fERQXHI/D8vGkDqcAa4e/XvxaI1FBU6SVPEH8OLA11P9AQn/b8oIJ9HA/kR4yfi/ujvfyYKQPPAMwa6dfW+hFgoyHEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4059.namprd12.prod.outlook.com (2603:10b6:5:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 18:27:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Mon, 10 Oct 2022
 18:27:57 +0000
Date:   Mon, 10 Oct 2022 15:27:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        baolu.lu@linux.intel.com, kevin.tian@intel.com, linuxarm@huawei.com
Subject: Re: [PATCH] [PATCH] Revert 'vfio: Delete container_q'
Message-ID: <Y0RkLBiZc6RWl3pB@nvidia.com>
References: <1665222631-202970-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1665222631-202970-1-git-send-email-chenxiang66@hisilicon.com>
X-ClientProxiedBy: MN2PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:208:236::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4059:EE_
X-MS-Office365-Filtering-Correlation-Id: 09db2bcc-4e9c-41b5-8665-08daaaed2729
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AOzdFnfI45d56PV+NZ3k0h52z+6xmP5/dIKdJBXzZw2gd6ciXJfHoSJYSYQF8VtarNXzfQJ7dIC58ALN1rUcgxUFRLWf4ocHAeU/XVKWeKeEqWsh+PS8lR9fGEf8EUO9UWVoP+DeM5EJYUOWYGsd4u/0AwljkMyzWhk65Dfk/ZqARhG5HrdsCq7ot8pMijekDziX+Do6+mgbtvwWHpBmO1nlHPK5V32SUwGaNlKyWJzelMKtbengFB+3lXIH6faOXi2R4WfnPrYovUc1DcIa7bYhI2SvjuuCk3mDa8oYB7Jnl0A/B7JiPVh74r9hHVe0fNw2rC8WHZnutjGr+wSNkDXdWQi3RXQMa9zSyz5NT5Qj4G5IIC1n/vGv+JpfZ9gugmiYyhqx1/exQiBYgddfUJc3tHyLlTwnE0eknD6tvfMGZDG/yrme96nOPcM8XxIoJrfqdz5e1UNTKlLp+olVHfkozXlxvrJW6wwHBapUT3ja7fPby9x3aDRkywNPC2zVN1Chxmgf5GN/+BbNJPMGLPJ1uI93GjaHtySvo8qQVuLxVM8jnRIINH71LiEPdPoV3AXkYKfxK4ZDH3wa/3C/A3zERJ8vqG2sp599lY0uxFSL3Bn4qUIzG9q73Ws/yIseC6i146KTQTAtTVND5Ao2sET82I2VJigvLwWdnpdBWcxXXiqoOcdF8DPqonOOS9oXt+abPVMlPeHqboCB5isGlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(6506007)(26005)(4326008)(38100700002)(8676002)(316002)(66946007)(66476007)(66556008)(86362001)(6486002)(186003)(2616005)(478600001)(6512007)(83380400001)(36756003)(2906002)(6916009)(41300700001)(4744005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pM0wkbSvTtVns0gmmrFb7q1t/1ePJ2v6panlV2dbNGVcblmCiK0zn7XnWknj?=
 =?us-ascii?Q?J+g6OUI9WhLwkhYqMwY3jIoDePspZpXHxl/hhzr4aGoV6Qlzt0NebLZsYzlU?=
 =?us-ascii?Q?ParnNsNlfJBp+Llh1X45MtAiMvApHwNr60gDj2WhTFFLYsxSjNPvJo4teuaL?=
 =?us-ascii?Q?OaB+Ty+9V8tk1YMB0GvLKUtpwvplkqKMb1KxV2Bg8aXvwVhXh+WB7ITWOgUK?=
 =?us-ascii?Q?w2nYtpXS119iBqpkPYNx9Cgw2mSVj6+0BseMPxKxrLZV6XfeeBQMp11q1Y7l?=
 =?us-ascii?Q?7Vp9+y7a8TuoZO16fvttb2+4Kx1hp9537mOFVoXwRDySi8WSGb16cKtbf8MT?=
 =?us-ascii?Q?LjKCyvgLxMqC9+yWrU6ocakM3FHJcEj/JofjQh9TmBNqSTfwZCGIMbPYmoXr?=
 =?us-ascii?Q?BPXcD0keF5WLp5PnRsvQdZnoJDd2egA2oksw68BkBOBQCRBVEkZrU+Hpca5G?=
 =?us-ascii?Q?iAsUf7oowvVP23sKA63XnkpaTgL9nGIuNGXZb+sHXhe8WWsqtmnBpab4Sq+O?=
 =?us-ascii?Q?jt7sbetZF+cMG1tI2MYfgxKUxHVMiF+0z2y4cdzOQaB0ERvYq6xlRb9Ey4kL?=
 =?us-ascii?Q?iIT72VKM+BqbxgjqHfhqsWtE+Iq4v0dPz4HfJ1VCOyfiKKgTbH2RTjEUiCbB?=
 =?us-ascii?Q?7Jt6OJcSvmqZFq41P0JKA6uyiwyjqF8GhgsQfhA7loNQx6X1I8xmWNHVdPL0?=
 =?us-ascii?Q?uVBbQJW4fefY7DYc5ldkFTUwAYHPNQkXaMnM0SSM9RW+KW1BJGeW1Sw1LjEC?=
 =?us-ascii?Q?DpxLN0sUbNcQsUkFcB5USsTu6h1ZWhJgqLSzVZC9MS7UnjMhQzG/M6Fjb0nP?=
 =?us-ascii?Q?9bDnYhdTKdtAGOuqhlPny4fMfrQ/Zvn7PQXjhHjOWl0toqPn8QIcoIe9n/m3?=
 =?us-ascii?Q?ALGYLSCKLkMj1aRet1vcJojYntSeE2vnb3/dHyk7sKeCoil1tWifysPRRRqo?=
 =?us-ascii?Q?LnuuEKMgFqygrwg1f0yZUPsgFQrRec86Och9Jd6VkMQweW9lY1CguShRGF/y?=
 =?us-ascii?Q?NaaBdJz5/kvIs7+HdxbeWYwarf4ar3Hdoo0TghrpJyQnxZvtdYHJNhZ1DSm9?=
 =?us-ascii?Q?/Wdcv/zPcE1JlEQ2ZP/MrCAynjd4vRu2DwahCqoi+Or/MFNeycNqfsNBKL7T?=
 =?us-ascii?Q?T4ij7vRoxzGSI6iIaPbYhzWH0DWxqDOQLAH7Tg2UxpOP3zNNEuRzrVnezyqV?=
 =?us-ascii?Q?Y+OIq6Shwj6sfMLqPeumIVlzu5zvg7GfRM7j5hnxaPR1t4e3LDQ4TPNzhWLO?=
 =?us-ascii?Q?a4znn84PrAOCnIbUc0yOfobd8nL3buY71k0A7a1Ne75kyRkacPJzEx1dFaKp?=
 =?us-ascii?Q?DzenK4KDZ7GRCM1sk0pGmNMDJtSL++ryHlPxvg+iH+pQS8YRFAVJSZQyNZGN?=
 =?us-ascii?Q?uU6xneZMxtu9AH6K3G137n/p0OmHQO1MwiTMuZhMXnR9g+gDbxCNgLpqAT71?=
 =?us-ascii?Q?RxCTgSi6CAKpW2eHItkVNxGnVH/3KVn4w8e22qi42+yerD4L03kZaQWCWjfb?=
 =?us-ascii?Q?xpQPjlBrMos+8RXN1s9P8+shUweg6Ft2NUBsvaHM9vb0Z4D8pPxihEFSSMs1?=
 =?us-ascii?Q?o408DL6yGQkKaI7lSVA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09db2bcc-4e9c-41b5-8665-08daaaed2729
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 18:27:56.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtKRPzhbj5vC+NaJZE+isfwTcgbtaQvBnLQL7nFGxYCsiffuUtl6QBEr841yySit
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4059
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 08, 2022 at 05:50:31PM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> We find a issue on ARM64 platform with HNS3 VF SRIOV enabled (VFIO
> passthrough in qemu):
> kill the qemu thread, then echo 0 > sriov_numvfs to disable sriov
> immediately, sometimes we will see following warnings:

I suspect this is fixed in vfio-next now, in a different way. Please check

> After removing container_q, arm_smmu_release_dev() caused by disabling
> sriov may occur before arm_smmuv3_attach_dev() called by echo 0 > sriov_numvfs,
> and arm_smmu_attach_dev() may refer to freed iommu_fwspec, so it causes
> above warnings.

Which is the same effective issue s390 hit already.

It is interesting that container_q was solving this, that seems to be
a inadverent side effect nobody noticed.

Jason
