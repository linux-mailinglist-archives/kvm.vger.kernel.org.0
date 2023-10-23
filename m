Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F717D420A
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 23:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbjJWV5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 17:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjJWV47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 17:56:59 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3E110C2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 14:56:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzToJEyFS3ptLTEJE97bd0iNWsovSBB4RTh28h+9XVr3JtxiKsIzIqFYypHzpgxQDEV7knUhNy2vLi+ARlUvwTUEGAMG1SGVo7uOW6TCgdOIdGTG34d7J+kOALgNSpk946CHL14MDIUwnEYkYbAcAnRMrrbczGE057yx5XmRmw/IOnyyegoHrTqkLr0b2IlMcoELfsy74VCO4z2SM8ETF8pIi5HxNBk7I5pBzXkWBwibaplGVbOk3tqjcBcqet6HC5xg2EQwgv0TBM9uAmCHs6ZZ956BUruzZeqHwePNUvtB5GJ0xbSKpNqtsg+1IsHSfNPUitbettPXh1Ax057tAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLEE7w9rSFk1d6Cd7+IXbhm2F/AIRTCiyL3N78ydwx4=;
 b=DTsa7oOU7WqeZYkKlV0PLxCFfV6ahVS1s7RYBlmiLIDYa58wXeGsPdBhEz0e/4D3525in0NifTxPg6PXOFVB0RxIPZVkl2iLOIFHwjwvXBbJQ2F63c8oZmNuQVwiegsbkXlwuLM73X6DVCCWqAAQzoyQicwRjJ5t5Gak0TUi1h1awPB7KtOT+wYcYQZeBN4IKlicCFa/+5TYWTaQrhzaZOZZe8RlopKHCYPOihVGOtN09i9W1ExB1L68OQJ+ZbULh2elvQ4u3sdBg6SbQ5jLcaMWKJAkcaMy5fs4UKin2waT6/MZatLhkTr+1rX3jW1JxSri8vpXsNUYGslpUrHn8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLEE7w9rSFk1d6Cd7+IXbhm2F/AIRTCiyL3N78ydwx4=;
 b=NJ2Mipm1Hhgj67FClZywsaBceUFBv2AUTjpRiC5RtDGzF5gCsjWYYIIbdy2aB+U3Wla1wfkhQOpSHumvJCuaHcWipWEru4+Xc6zUAP6qZk+HWqSnLzHI4kcuUcuF0QcyPmuGYk2PVUSFd9iucXtUszQcd6mAOXkYWqzz6WAWNyTIx4YQxhcbQNXy6GU76C95jEnOUJuuHJkhmzO3lrKamIf4Z2KAKdL+u6Eoskk5Ve7JsFaZocybveXFWdTUINS+DLSta/euVJtlZlRQUywG667iyg8gF4ltPIrDLw3xhpSEu/oAQQs6mFpAM9N3U7XKbjUlvEmhSMSshypZsBo3Zg==
Received: from CY5PR15CA0110.namprd15.prod.outlook.com (2603:10b6:930:7::29)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 21:56:55 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:930:7:cafe::88) by CY5PR15CA0110.outlook.office365.com
 (2603:10b6:930:7::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33 via Frontend
 Transport; Mon, 23 Oct 2023 21:56:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 21:56:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 14:56:40 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 23 Oct 2023 14:56:39 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 23 Oct 2023 14:56:39 -0700
Date:   Mon, 23 Oct 2023 14:56:37 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     <iommu@lists.linux.dev>, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
Subject: Re: [PATCH v5 16/18] iommufd/selftest: Test
 IOMMU_HWPT_GET_DIRTY_BITMAP
Message-ID: <ZTbsFfDRGvQ4CqMn@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-17-joao.m.martins@oracle.com>
 <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
 <0a641e15-a6e4-4113-932d-ba2caa236653@oracle.com>
 <ZTbZiKhkrSaxpqNU@Asurada-Nvidia>
 <455beefa-9b1c-427a-a33f-a64f8e764f8e@oracle.com>
 <219f2d71-858e-4fa5-9ab0-f1efb515d066@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <219f2d71-858e-4fa5-9ab0-f1efb515d066@oracle.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|LV2PR12MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ccf837-6459-469b-9d56-08dbd412f894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtaGi4eGxuI+/X6jv4yPY0ys0fXZDs+lI9nj7j+TRcFq+ncFnWAYWxe7IYb+cAkCQ+CT7LSvw0wSRh+1TKfzKWTGHgQaKenAWUJOhmAHs4rT7xUNBJcviKMpZd7ZL0MwETRikeRkAMGfbIEs8D9irm6wipPfF4gKkgb3YUnWZeFjKyX1WBBfej1zkVZpFoPLkVDA6lbSlraBLuMfCKvOkc9SzeFqrB2c2Vr2s8wFTRulVBcULdSNjDC3y45y90uV6MsuWM4BISMPg7A7v58wPj+JWlW4DVDlfzrDbL93z2VAD1KpZ04blTh+PsTIiGLXbhyEgHz+M2gCq2T15YAzz7Wym8Ka/F3FGXylZ8s2/xM9FaDrqKbOOwYfDrvX0gCHrBLvS61Z/X46mx/pKNYOenAOoFdi+o99ddXVmsjWSZdbGkd2us+a0ncGf/Pp4illZEWEpakq8XFJ9ENtdZIV4mJaSzli8HFvQCANRJFN4gQ4C+ncEknQmwfKpYRTgpPqj+Raib4dVPpImbIlGU0WwNHxfR645mNR+U9hDYnI2u4VeWDPUfKyHy5XMZjpXNiRcaK3Cp3c6dsnW0sl18Wox6KB35Bw5fOmvsWn997rxSKj4SbSxddJYjqg2ztcK8tDnqoYtoY8njIOr2ofMuKXnbH14Vt+kuja5j8nKeD4N77GfS+leNr0xcqqKPkSHlN0KSE1bqHdXJhkjdVNEI1fQQtj08VKu+pStNBfVfN9IMwk9eFh9WGFo4Y3zPg/JDiJtVpdh2AcBOhmh9YUhTFBYQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(82310400011)(186009)(64100799003)(1800799009)(451199024)(46966006)(36840700001)(40470700004)(26005)(33716001)(2906002)(36860700001)(86362001)(40460700003)(41300700001)(7416002)(5660300002)(8936002)(4326008)(8676002)(478600001)(7636003)(70586007)(82740400003)(54906003)(6916009)(70206006)(316002)(356005)(83380400001)(55016003)(426003)(40480700001)(47076005)(9686003)(336012)(14143004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 21:56:54.6952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ccf837-6459-469b-9d56-08dbd412f894
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 10:46:19PM +0100, Joao Martins wrote:

> > You are probably just not copying it right.
> >
> > The bitmap APIs treat the pointer as one big array of ulongs and set the right
> > word of it, so your copy_from_user needs to make sure it is copying from the
> > right offset.
> >
> > Given that the tests (of different sizes) exercise the boundaries of the bitmap
> > it eventually exposes. The 256M specifically it could be that I an testing the 2
> > PAGE_SIZE bitmap, that I offset on purpose (as part of the test).
> >
> > Let me play with it in the meantime and I will paste an diff based on yours.
> 
> This is based on your snippet, except that we just copy the whole thing instead
> of per chunk.  Should make it less error-prone than to calculate offsets. Could
> you try it out and see if it works for you? Meanwhile I found out that I was
> checking the uptr (bitmap pointer) alignment against page_size which didn't make
> sense.

This fixes everything, per my test results. Let's have all of
these incremental fixes in v6.

Cheers
Nicolin

> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index 8a2c7df85441..d8551c9d5b6c 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -1098,14 +1098,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
> unsigned int mockpt_id,
>                               unsigned long page_size, void __user *uptr,
>                               u32 flags)
>  {
> -       unsigned long i, max = length / page_size;
> +       unsigned long bitmap_size, i, max = length / page_size;
>         struct iommu_test_cmd *cmd = ucmd->cmd;
>         struct iommufd_hw_pagetable *hwpt;
>         struct mock_iommu_domain *mock;
>         int rc, count = 0;
> +       void *tmp;
> 
> -       if (iova % page_size || length % page_size ||
> -           (uintptr_t)uptr % page_size)
> +       if (iova % page_size || length % page_size || !uptr)
>                 return -EINVAL;
> 
>         hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
> @@ -1117,11 +1117,24 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
> unsigned int mockpt_id,
>                 goto out_put;
>         }
> 
> +       bitmap_size = max / BITS_PER_BYTE;
> +
> +       tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
> +       if (!tmp) {
> +               rc = -ENOMEM;
> +               goto out_put;
> +       }
> +
> +       if (copy_from_user(tmp, uptr, bitmap_size)) {
> +               rc = -EFAULT;
> +               goto out_free;
> +       }
> +
>         for (i = 0; i < max; i++) {
>                 unsigned long cur = iova + i * page_size;
>                 void *ent, *old;
> 
> -               if (!test_bit(i, (unsigned long *)uptr))
> +               if (!test_bit(i, (unsigned long *)tmp))
>                         continue;
> 
>                 ent = xa_load(&mock->pfns, cur / page_size);
> @@ -1138,6 +1151,8 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
> unsigned int mockpt_id,
> 
>         cmd->dirty.out_nr_dirty = count;
>         rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +out_free:
> +       kvfree(tmp);
>  out_put:
>         iommufd_put_object(&hwpt->obj);
>         return rc;
