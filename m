Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D805B3C70C0
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 14:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhGMM55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 08:57:57 -0400
Received: from mail-dm6nam10on2065.outbound.protection.outlook.com ([40.107.93.65]:45536
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236164AbhGMM55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 08:57:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7RBKh5/NH08afdc1xJsvu/EPLC/dX7ligrkrfpY8iF8M42uYYbe9Y7lj8oLWr6CRBGJmU+x/Vut6jBcvTsja5MbQk5zIDiDMtWVCHoHZndTi0zxHc+7vsAhdCVPUGv/lrCKLxTeI3JOEshgQkDFituaRdGBmwc0ur+0mp6YF0YPYmS9q564da0UMU3uKwl4QQxvFuxm82JkPRzi7OR3RxO0Qd4D7CU5+7JKjlcAxCSMOfd9xidgA/lYhbVHs7jNFMKbGoDteGN0SytkF3HgosPx1HvKhPVjpdNm/L9ASH41avDpmOtwXW0e7fUD0wQP8ml9NtZfzvY2pGtWMODZUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vf/2XGY5MSWjJIy8lTxwZ9//N3r/9BuNCcomhWAMSWQ=;
 b=Si//v5xs41vReixdPVp3yAsTyBgwq9feVPjMlzxUU5+Be3J2Gx1+LFk/9Dl/dEdixesD1o2B/Jylvtz1hqsFzJMIoCN/lGQrrRMMeGxVoOSH0B/hRPENDnIL7RMO2BG4wkCUMOlUeYhEVmdUDBAVqOZ/mQK49YlILKJFkcKRwc/+5pNLzPxmfGaOOfkL/1KtVN2kMlKkEmyHFm0AElzIehZP5AzUo45U6rrVVAdbybFupI+9uoq+t42VSTCW5d6pD3dORlGGs08eTc3NktmE6QhtuzNsPc6QEdKSALBzyuCm41YqUAcxQJGuT9ZrZZAti+5os8RXd5ofCjnooyjIUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vf/2XGY5MSWjJIy8lTxwZ9//N3r/9BuNCcomhWAMSWQ=;
 b=iT4667cDzWBGyDMqr0aG+6VEQRpFlwzpzlJhoBgiXHU56alNQf1xH5HtZMBWrWtiZ1wiF2dRCIl4x1XFHos0uHjM34o+gUJUJ/pdiT336JunpALk/NNdqNFZaT6CK0eHpXueyNL6BnF62HCeTlq+dwLTsd3bdPVA/lJmZ+K5u2ZAqPiEI4dVDec9mm8sTxQolzgF7tjtNSzeSg4tM4QPVkJ7fwUPWJ8zCp+SYDQnzetW7qLOBiEfZO0XNaRyZU7ixwbNhBwY45cDgN7iwrDO3xr+gMTyMnpz0EsHsKUkGzhxw84LHLhfmPhKmrZElRJJgCZy/cxxEsWDo4+bugqZiw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5046.namprd12.prod.outlook.com (2603:10b6:208:313::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 12:55:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 12:55:05 +0000
Date:   Tue, 13 Jul 2021 09:55:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210713125503.GC136586@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH2PR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:610:5b::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR07CA0039.namprd07.prod.outlook.com (2603:10b6:610:5b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 12:55:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m3HwF-001LuE-M9; Tue, 13 Jul 2021 09:55:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a092589c-b40a-4489-4652-08d945fd6f8f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5046D40A6852FE4252401A13C2149@BL1PR12MB5046.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1jTjkVnMlnHJiPePy78CbRjAgLjU3JDkkJyRu/efNOm+cyjZqt7itKmz/wz+2EEjnF/Vnp54CXXCVO+3EP5ONMax8iNUkLICWD0ENkGVsu7CO/hU5bCYdnxhqgRyYreX6Hi70hrXQoaRUWooht6j7r4b/zgM4IZS9Ro2jF5aXBdo9C2SyJmbSoH6+oF5Hi/euwPEGJEd1qFI5kOtLYRp94RmgrC6ytlZUDM7D6YW2Y8AifiiI/LIMKtocJvOnaCFjKfuuT2ayoj2S/AX20DU6NPyqX16+kqNYCtbtEJpeJQ7ikMIRqWTNrknlS7HsEaxC1N0GpBG9o8BSO2PWcK/ZSDP7Q5PlbYpZzRuPz2yybgEEanBFORQKMpqkn5HEufiuywiPO5XsJnK+W1+xk6s1dCXV2+oL5U2ZhMY25dwIIAO37yXhLiX/S0vBlLFBVyKFkGC1ENPNtjv2cI30AYz2VCiEv8hf/U71NoGT3jey1uLG9tRdGuGc9NqPMkM1AcFKrqmBLPU2/5WpR3VT4vQn0I08mwOFGnyTFtiim4Rnc37+WSf1+KvMp/o0Y4UhloDYOI/kQQZn7Oa9s1QYrmtpiyYOwhFQCTJtu9U9I3obreDJI+lrjc3+0rsZmj8Fqc1Gyk/PHmJCwTNLyfZO0NPrYkXY4XLFOpBGtG0avB92Z8ocBihKHQnvinVAcTJG6ebl0JTSECPatfNBgXYQAmvIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(2906002)(186003)(38100700002)(1076003)(66946007)(66556008)(66476007)(8676002)(7416002)(426003)(9746002)(5660300002)(9786002)(33656002)(8936002)(26005)(316002)(86362001)(54906003)(2616005)(83380400001)(4326008)(478600001)(6916009)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fy20S+QdnVfiEm8Ozh1V9P691DrR3lTwUZR6EilK2n6RjjpdMp2PgDKtpKlh?=
 =?us-ascii?Q?k4+g3uYJQDCJ1IL1Zoi/NakQwI70Aav4DyyCncarVGnHx6CWo6zzpcm/cLSD?=
 =?us-ascii?Q?759g1yRPb1KL82OifQYCiFJtaBGbzblLWj1TrjtSmiarrvF9Ktv0yGjTZYK6?=
 =?us-ascii?Q?oWJVI2IEJiQW/3XLNqTdm4XgI2sDV1ZR3BCdSoulpFgXvceWgqhc0eMn3Kol?=
 =?us-ascii?Q?l/PGoPbEKctX/+5/5s3Yte96a5km1fcLC0XA5JtdjPxFec9QsTbwUdDnyyIj?=
 =?us-ascii?Q?IFNT1n3LLVzveg3lHWMYoG42RJmmAeB1Bb4yf0dlb3DdXh0UpsJu6GfDOUwe?=
 =?us-ascii?Q?21ceegeu2n0G9LRu8kcU0OZOnW1lIkjjAXWIt8g6QRUfeqo1EqxU9Dvi2a3P?=
 =?us-ascii?Q?iQ8KyFQPcmhyXpafLd5lhoGtAbaTuC3XxVlYIOs+mOG/1kjn9q7z0nzNxp7n?=
 =?us-ascii?Q?rSvUW5fkTz9VUViiU89nEcaIH6VNMwnFuxAd/DRBjBEFyi0R458r5fTfv0jm?=
 =?us-ascii?Q?eacaMW7Qwyu2Pj+JaabG/8BRN9dviaSjhGbXFKRzv/Ig6A0m3t6u3upUER3I?=
 =?us-ascii?Q?JcG/QjKPkQS6PG9GPgR2raIYiiGlGcxB3O9rcSrPt+Ku5MdB+Whvq9uy9oxZ?=
 =?us-ascii?Q?yn/JOsZTEcz1WdXw4VuasLzK20ujl0nKBkPvbyh4/2ja7bT2F8TAdXERCxT8?=
 =?us-ascii?Q?TQwxoRl0sp5xONB3DhWhAKan8l/hOuWG3RU/SUNVu/CrsnxTIK54OdQ6MZiK?=
 =?us-ascii?Q?U85PcZeGJX3gDxa8jsAJmmfyDHqiOnquG+ZP5u9N4tEIOM2soWvehYdXWtMK?=
 =?us-ascii?Q?bpCObiN4r+/g9BYQHlhQXOHZHthW8YdRhLZas1ww3jrW/Ei7Zm3cPSDoKdcd?=
 =?us-ascii?Q?bAtiXbHdpumYYAKPw6wH7AzM3+S2OtjUG+/fgD2IbrTNrQV7BWwpyGgiZqLD?=
 =?us-ascii?Q?ji47/AfqkH2p6rwYF5pSvQqgjSD6OL6I45DghiGBCYrIOiVEor+/0hT+W8Y5?=
 =?us-ascii?Q?AWVY/hkVE0aCtVlzv8IvOHh8pHLlDCWiTTQFvCQJ5Tf40ocRfoE5ZR1bOfPy?=
 =?us-ascii?Q?/wtGodkzgMBf48Qx6nKojJRSE7T5TuhZIclb1ded5zTaZ5K9YrNGrgs6muEs?=
 =?us-ascii?Q?KkfQRdjNBTKEQ2KvpkXJRwTvTIkU6FLfNhXESbsX/k/upzejvBdu8oPtqZg+?=
 =?us-ascii?Q?wgCMxirf33Lydbf4aBGxywRtBVSaNaxNhbVZhxSO/l9eYP6ctresR+m2+36Z?=
 =?us-ascii?Q?iX3eAIIidRn953rsjaWvaTEys5PRAQS6OUcZFFPifHAqV9du31v5OjScjFcv?=
 =?us-ascii?Q?CKKd8dgiWD5Ye5KNXSADwRgX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a092589c-b40a-4489-4652-08d945fd6f8f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 12:55:05.4789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCwiRlh34J3NmxS5COGaGahTLrAYXEO5U83i+RvvdkdA2b2rMvn0oFfFC9+bCMz5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 11:56:24PM +0000, Tian, Kevin wrote:

> Maybe I misunderstood your question. Are you specifically worried
> about establishing the security context for a mdev vs. for its
> parent?

The way to think about the cookie, and the device bind/attach in
general, is as taking control of a portion of the IOMMU routing:

 - RID
 - RID + PASID
 - "software"

For the first two there can be only one device attachment per value so
the cookie is unambiguous.

For "software" the iommu layer has little to do with this - everything
is constructed outside by the mdev. If the mdev wishes to communicate
on /dev/iommu using the cookie then it has to do so using some iommufd
api and we can convay the proper device at that point.

Kevin didn't show it, but along side the PCI attaches:

        struct iommu_attach_data * iommu_pci_device_attach(
                struct iommu_dev *dev, struct pci_device *pdev,
                u32 ioasid);

There would also be a software attach for mdev:

        struct iommu_attach_data * iommu_sw_device_attach(
                struct iommu_dev *dev, struct device *pdev, u32 ioasid);

Which does not connect anything to the iommu layer.

It would have to return something that allows querying the IO page
table, and the mdev would use that API instead of vfio_pin_pages().

Jason
