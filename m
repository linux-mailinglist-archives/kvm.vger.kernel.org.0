Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECB540C5EC
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhIONJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 09:09:07 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:54113
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233291AbhIONJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 09:09:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDCGI4uEOTyO7AUlsGIANXkyllRSTmdMT8zarujNH7UxZY3xPQP0Lgal6Frpw4FQk0NfOuNj8hvFy/froi2tF/qhYA443wo+djYjV3ASjp741KCFNkcNOQqa4fVHJ/g00uGV5n0q5PHOqthKUh1VmFShI6VXHqUjJnTFCJu6EuHmnVRbahrkat5ycdoD7BwAEbfAVoJjjzv9IFiXZCDhTFOJp3656/FcpPlqxQnriEpi1jeQauIfV5CV5d76YGdc0rA8QGOhF6q9oRm2AOBRzbuoYzm+fLMlQzeyYrgX5+MjxNfjj9ijR+xXZI+amfTNtyMDrNwxh63Uqts8cVAMTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XeKXWjZ9/VpH66X9cJhZoA2GPlhvymHvHAfcQT90XOA=;
 b=jun8jO58Ur6IubQ+mSJzb+OxAPrQxmTF3qNbfCLnNVxYcMgsXRddfhyiSxmhHr79GornXIDqb4v+6inYco/dVYJ0AKhMItV7BM5GhwOt8MjM5Kn0PFpodq0k5fHiFyYIcUOenOT5GmVa46D5nOXIfd4Gnk8jsaXAQkI6MdfQcqq1h5egEyZXjf/6h7yl2GLDV/RqRIaWSdQ5/de+nxZ4aV5f2bReSVWa6iwjMXP1zPYLO0A6G/OF50HE249K1ZQXm+KLIJKZSEuDNn04hIag5+uEcV9LpJgkSjFk38M2eV1rWlqLwXsFkD/D7uWcYgpFCXMCt6qfSMyAhjgQAbTERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeKXWjZ9/VpH66X9cJhZoA2GPlhvymHvHAfcQT90XOA=;
 b=Dv9XqEdVNJIeV6h7ysQa8H1aRguyhHbIVTuCUGyd6//pIbykq75x/Z6Uh1F+G/Lo6D6kHezLDNpoW1LrYZ454nxTS9BsplMDdIuHKPxKGcZhKzvwGtW1EzdBhzSjbpp8riDxTfd8QLPZQV/obNSOpx9FWfiKFZeDLNvwFpQplfHXTgKtuKNeYJRfVRZGwrbSFMpIoETVefgShsWXKKDFYChUAUId9LyOBgUmEJJgfVQ/6tpGNGrfapy9heKlSGKdHE/knfYFMsxWqkbnyv7tSs1nHFflvB+e3Lr7G6vqVtzQcGhZ86FGx+EhjkaVpKCeIEf5QAcvh/DoJ6n+1bCnWg==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 13:07:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 13:07:44 +0000
Date:   Wed, 15 Sep 2021 10:07:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        mgurtovoy@nvidia.com, linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20210915130742.GJ4065468@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: YT2PR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT2PR01CA0025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 13:07:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mQUda-000sKs-Il; Wed, 15 Sep 2021 10:07:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34a5d676-0f5b-44b9-2ea7-08d97849ceaf
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5221607F89B35E1A8D05A247C2DB9@BL1PR12MB5221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRDggiiMzG+VjlKJIiQYi2OD0nhnbi8/DZCW5Zt8HoD/ZP9QxjP6e0Ur+FBVta16RXVzfty8kWXK8pkcI883hY8pDCTZUsd1R0wRWcZoPa7/Fb0/WNG+dwdsATLZjSTtCWl5x4MC3JrDFqbse/yQfurdGa/SNA3b9fuQ420rUe1a849kHp4tG7RagwtWmG4fA7JUb7tqx5uoMQWFazy4iWAsnhWgMaV8+xmfkZG+dafRDcATkg9P01EaF5BSzt3lSkLCadKr1J9dNucc9EDkSmtj68d5+/vEOnm+etMTYJpazoN4+jRBkaR+Vmd6Wljnv9QVtNoaSsmQbRPP+FoYG+ClnKhBXZktRgEH280Cpt+RcB54Jbo7NUW8+8xmm0tvSL6T7fdQ0t/c/rMy3UTks2YoTT6CRyRsS3Ulj5+0xWKCt0/m/YlsJU/gAuRb65N7WSYGBhaHQAbiJ2anKzgzUBOp4PBM0f+KTg4w9RJ3M1ThsjsD9CgMMSQQN2YtvQ1J2QC5eSpSrdZYy4SQCl5wtZft8/0YbofpFtsPUg4erEaAY6G9+983WjBxBbHa+4HWswNTmE3PcH1k21ZLJ1uwuQB6n1s5X1EcPUcyARJGFrEI1RuZJDiW9xLOS6yV7BdMIHtAvQhBo0mxypGXfcC3Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(9746002)(2616005)(9786002)(186003)(66476007)(36756003)(7416002)(2906002)(26005)(33656002)(426003)(508600001)(316002)(8936002)(1076003)(38100700002)(83380400001)(5660300002)(66946007)(6916009)(86362001)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjJka2RpZGZRRzNGaEc3Z1ZZS2ZRcU8xV0dmZ1Npb3NwQTlVYWg4ZW1zNnBq?=
 =?utf-8?B?UjRGbWlsTkwwM1VBUCsxTWVjZERhWlNzVVFoam94WlZZNjZlUWgrdXJnNlVL?=
 =?utf-8?B?RFAwL1pxNEt5ZGwveGlmcmhBU3RFZVdxTjA2N2RmTnljZ2k0UTh0bDdWL2o2?=
 =?utf-8?B?M3A3NENaN0dRNFNQUHNxZmNKUCsrckJJWjR5T0xSakdHVEdlZkJROGZMVFJI?=
 =?utf-8?B?YklHVURPU3hMa3RaMlBmUEdaTEFLRTVxRFNCZElsSFFBTVhpVG5LQW5oaWQ1?=
 =?utf-8?B?VVpNbU96MTBwQWlkMTlCb0JsTlVyYmJlVVpVS1ZjMW81c0ZlWWtnR05zWnRB?=
 =?utf-8?B?VUpua2Zvb3NWK1NFWlQ4ZU5aZW5nU0pUVnFOcXZsN0R4T05hTm5waEs0R0JK?=
 =?utf-8?B?cmVLRmdkMDFpaHpkR1BpSGpGVFlQWHlVQWJQZlFHWVY4ajhmMVM1U05vR1hz?=
 =?utf-8?B?K3p3TGpkUGxmVWxkRE1RZU9kS1J5RXM2SkVaQldLTEdUdk9ObXpXamRONERD?=
 =?utf-8?B?ZnFiMG1IN29EUHBtNmxhZWZGc3J5Sk1QOHFzWTdQeHJvZjNTRnRicDhzZUNm?=
 =?utf-8?B?QkR1dTB1SzBZVlE0QWx0VmV3MWRMNHBaVmpOQW9sSUcxRHBnMk1qMnZFaVhC?=
 =?utf-8?B?TjVRRkRVdGE4NGxReno0QWZxRnVWSEJycUZldjY5NGlvQWplaWlkeCtZN2Zp?=
 =?utf-8?B?RFZ3TXdaVHRscXhnQWJwZThkMFdkdVY1SHNxZE85OVdMYzRJSVNvMTlMTFdO?=
 =?utf-8?B?ME1zYVRTNTdXT2VDdmJDRW9DU1RrS3JyRDczcnBZMFhaQWNwa3FXaC9Qajdn?=
 =?utf-8?B?eWlDUFlrOXVqSy85VHBvdTNKaG1LUThmc0UxOG1VRU1idWQ4L01iL1crdzEx?=
 =?utf-8?B?Q3ZzYmFvazE4bzh5N0NObEdrREFHUjl0NnRYbitkQURTMXdGUEM4aGRmSm1q?=
 =?utf-8?B?bXROOVBMdGJpWk5URDZKYjdsSUM5dE1wb3ltYTVkZExiQUlLaVhTMjJ3MHRU?=
 =?utf-8?B?aXVhYkRCL0ZOREFCaGJ3QnZzZ3NwNUxhdUNUc2dCVUcrV2ZRL3RqclpkRHd6?=
 =?utf-8?B?bDZDMElJNzErTzhhZ1RxRkFVcVExRGtXOUhoTkFGdlRnUmZrQXVJRnljZ1V2?=
 =?utf-8?B?K2tpRER3cGh6RTZYcjFTU1FVK201R0V4ZU1ubEIycWdNWkxmUnBiV3B1L3dH?=
 =?utf-8?B?aHlCTUlGVWdySEpuZVI4UEliK1p2NEF4TWtTR3hia05CUktTcmY2NjFVak5Q?=
 =?utf-8?B?M29DYTRmdndWL1hvNHhqMVpzaXBvcSthZTRXNUhVYjNQREVaanl2aFlLd2NJ?=
 =?utf-8?B?Sy9qZXRYVW9jbjBFNkhuM3hiRmY4UW00TjRMUk15UCtKWkRCZXFOZ254WEVZ?=
 =?utf-8?B?VE0xOGtCcGl6Vmd4Q2l0em9IUExhNkZ1L3Bjc3R4WWdOT3ZyYUdUcDlKL3N0?=
 =?utf-8?B?dk5KV0ovbVVHbjR6RjgwNFNTWVAxd2Vva3c1WXNGV2oyNXhYSk5ia3VxZnlC?=
 =?utf-8?B?ZnBjRStuY0xacmVMUTdqM3hTUDFxN1dmVlZNcHoyajZLWEVZczRoRkYzcGNT?=
 =?utf-8?B?YXVJYzNlbzJ4dzIwekI0NytYWU9WcEdpdTlHSkwvK3dXcEdKV0twSFF0SXBI?=
 =?utf-8?B?bHlteHkvc3FTT0haZTJGSW5zRGN4TkdvaytVSktUZHEydk52bjB6N20vb0lL?=
 =?utf-8?B?SG53YVI2M0dmZFg4eWFpMDRvbW5yb1Y0S0hTMGRXMkNBN2dRdkNjM0p2ejR4?=
 =?utf-8?Q?7XfgkLcZ/EFiaYX5ymnR/7Tf/14ZELsptydknMh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a5d676-0f5b-44b9-2ea7-08d97849ceaf
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 13:07:44.7558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0crbqdhCbn7NdvdDHXLXAUXQ687INzM/GNOJJa2jyUwBOIc6H00H6t6K/sNC1cL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5221
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 10:50:37AM +0100, Shameer Kolothum wrote:
> +/*
> + * HiSilicon ACC VF dev MMIO space contains both the functional register
> + * space and the migration control register space. We hide the migration
> + * control space from the Guest. But to successfully complete the live
> + * migration, we still need access to the functional MMIO space assigned
> + * to the Guest. To avoid any potential security issues, we need to be
> + * careful not to access this region while the Guest vCPUs are running.
> + *
> + * Hence check the device state before we map the region.
> + */

The prior patch prevents mapping this area into the guest at all,
right?

So why the comment and logic? If the MMIO area isn't mapped then there
is nothing to do, right?

The only risk is P2P transactions from devices in the same IOMMU
group, and you might do well to mitigate that by asserting that the
device is in a singleton IOMMU group?

> +static int hisi_acc_vfio_pci_init(struct vfio_pci_core_device *vdev)
> +{
> +	struct acc_vf_migration *acc_vf_dev;
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct pci_dev *pf_dev, *vf_dev;
> +	struct hisi_qm *pf_qm;
> +	int vf_id, ret;
> +
> +	pf_dev = pdev->physfn;
> +	vf_dev = pdev;
> +
> +	pf_qm = pci_get_drvdata(pf_dev);
> +	if (!pf_qm) {
> +		pr_err("HiSi ACC qm driver not loaded\n");
> +		return -EINVAL;
> +	}

Nope, this is locked wrong and has no lifetime management.


> +	if (pf_qm->ver < QM_HW_V3) {
> +		dev_err(&pdev->dev,
> +			"Migration not supported, hw version: 0x%x\n",
> +			 pf_qm->ver);
> +		return -ENODEV;
> +	}
> +
> +	vf_id = PCI_FUNC(vf_dev->devfn);
> +	acc_vf_dev = kzalloc(sizeof(*acc_vf_dev), GFP_KERNEL);
> +	if (!acc_vf_dev)
> +		return -ENOMEM;

Don't do the memory like this, the entire driver should have a global
struct, not one that is allocated/freed around open/close_device

struct hisi_acc_vfio_device {
      struct vfio_pci_core_device core_device;
      [put acc_vf_migration here]
      [put required state from mig_ctl here, don't allocate again]
      struct acc_vf_data mig_data; // Don't use wonky pointer maths
}

Then leave the releae function on the reg ops NULL and consistently
pass the hisi_acc_vfio_device everywhere instead of
acc_vf_migration. This way all the functions get all the needed
information, eg if they want to log or something.

The mlx5 driver that should be posted soon will show how to structure
most of this well and include several more patches you'll want to be
using here.

Jason
