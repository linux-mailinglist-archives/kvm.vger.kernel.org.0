Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1D564A462
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 16:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiLLPrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 10:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiLLPrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 10:47:11 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A66A9FE7;
        Mon, 12 Dec 2022 07:47:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxKZgmKSXq2M/suZASO8vTwDGKB6ZeeViMs7nOKsI5U8th8Eav4WVd15TKcw5eklzDKQAMdKFOWg+fYfByoDK9gmbOHUQZPtE4xRqlDJqQax3h7xbyff15NGkj+ep5OtVHKtNFenDEDz7Cd2HVhTm7ywW7Xbm2ve9abmXqVT/ERkQ5wDkAEJsfxdqWC5hVN26JmaSiOqtAdrpNrC4zg2zybDMVpfjJO7pqa3He8D3WxQD2a8OXjdK3SBeGX7hvhdVIdJarVm9hZVmNAxj1UZgUcNzB3XgW5q7QpFFpTAFNzfCFa7IiHZyxlueQnBT3N6GjFJwJbZALo8DqR++CD8yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4n4RZv5YB822kKYa3QAvLwmjbjundOrjw0zfuuI/bC4=;
 b=CEl+OTpjC5PbSV/y92q1nXVMHP34F8wcrUT6G3dGRfX+4rmLOUsT82QT9amNSBeFeN5HK8JvVpY3YD0H7jij9fQMIghhcYfuCFOoaO7mMzUwfuL+FpG/SXbNAw4ZLRkriObrDo5SXubPFBntpA8qE9REJE1m3S9V7ts16aAkSLm0BdSVraLpF2jpBN1ScqUsGrCbA6ir2k9N55aVNGDi/7hw49btaaizdX4SJYb4EUto6SxwlxFm5sfJhDqDO/Oh1XUa36DGEWHRasj2M/6pPmg+vwroCjDd6yozYPbz6X6R2bkBETR5EKtp5PnfH7cd0yWFtUdGSazsGYp8TIxU7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4n4RZv5YB822kKYa3QAvLwmjbjundOrjw0zfuuI/bC4=;
 b=fYE8ms/0PkSyRhy1caRxZs9Vb0ZNIjYMTlNTaKbQDHSvEGyZRLvmdcBXG+h+XoqjHW/vbARLAnXKP6jn0NAJ/bB38LA3N80hfEPPFEkQ/PR7n8rOLECRTgryj52xfiSTmP0PBVApjWYEeWRXXmhdhqv9z/TxkxRmOqFpk73RbfMGPWya1RJf2RIFhKN660TLh4yMl8weZlyGZuXugDmuC4yZFb2g/NwwpIfaYIlKct2I/8tKLmpwUmiyu0wrRxP8z7CPZ4oVRF4veFF6CMsM0phqeqojj+20Vj9Rc/oZg0nEio3UTLecnEOwDkI6vvKA7twL2wbI6aACxm3AoNPSXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7339.namprd12.prod.outlook.com (2603:10b6:930:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 15:47:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 15:47:08 +0000
Date:   Mon, 12 Dec 2022 11:47:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
Message-ID: <Y5dM+VnqRjTefGH1@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y5NKlf4btF9xUXXZ@nvidia.com>
 <5e7dbc83-a853-dc45-5016-c53f1be8aaf8@arm.com>
 <Y5NyeFyMhlDxHkCW@nvidia.com>
 <87edt4bqhl.ffs@tglx>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edt4bqhl.ffs@tglx>
X-ClientProxiedBy: BL1PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b4252b-b58f-4cf6-8fe4-08dadc581f24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ju5+n17civQV+6eezQZarlWxFDfHhnG1E5PnzCn8u8Te2gSYFfVwOJqL2fwU9ir1oOnl2M/7V3NkhjrYVKszvWG8XjbiwIl8gxFzmAFgWwiZoRuD4Hm7qmvTFs734mCk/spt/8EBNAXeGbINnCu0QU29mdymLwSOn45hmwC/7CSFB+lyGFw/P02Vdf1DQX2+WXAeiDITf183pgji/zDcVOVbtJkqKGBiMcRrxAFDL9lOl6UhdTdzeHbnlDV6t+pemdZGVujeJfj6PenV3sF09tuXIZdLyOjMhymtJc78R1tRn5mvPylKmTduYHCbcpGAxyVXUTFF+uRXNSN6YvEggFr37O6+M2PKTahaQdeJgCFWV5gUjOPH7oHZ9rqezplErRIhXfDdc089wr/SS33ncMQtxACul+TsU60CcxDz0R2TTCz/F1hhvDseqUlV+5yOxavpy5B4yZFGQXsxQFYWrEMZ2aGsONGcko6shp7qamFE5jiM7+J97LoELZC+mPu/Ay0RAghmZkRRRq8sWUuoVP3onKJYpqDh2Wx8pcfLJ1nWLu3WlP2IuKBBaTFhBshToUW//TtYFxP1zzKrBAKlacf9eVdIh1eqvDF9q4GhvpkoT6XHW4j9dy9gPSZ560vm8SFL3g501xjFQw3aJ5mJ3cUhDziahNA6AkUnDsm/DSbpgOPpruBn6gx5HrVE3Ci7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(6486002)(6666004)(36756003)(38100700002)(86362001)(83380400001)(41300700001)(66476007)(6916009)(316002)(66946007)(4326008)(66556008)(54906003)(8676002)(5660300002)(7416002)(4744005)(2906002)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GFwCJMinhRqi9KP9nJMYnx3pyUsS+IfkQD0IyLf5JAsCtEDnf+wwp8aBTohA?=
 =?us-ascii?Q?0w7FfywdxElVFLP9+bb460mFEdvo9OgAcjdNCB3nDKtSL24+PAVkPzuSJmRw?=
 =?us-ascii?Q?4FeZOq9fl3FwuPidLpdt42rEgc/phMntiKOGpcq3m/YIbt994L1MZgY8ZmEg?=
 =?us-ascii?Q?4UwHgvH9rmIG/jzbeXMhn/Sc8ikxofgVPLO1mAReVjZHUT9uegFwNmQJzPtO?=
 =?us-ascii?Q?4u6iE1mNvpTAzx+APfldaGtqgPsRWjrTe2lgaVTCbY5tw7viCEjNa1M982/l?=
 =?us-ascii?Q?6nYj3910yXO0OzZ7+k9D1aeFQhrhvw7n3CvFIzefCoxYNgrDy0Jz7hp6LV3M?=
 =?us-ascii?Q?Pn9raQ4YKED4SU3HVGuj5Q46B9J2x2UMmtf2IU6TdKSUpYVWWRvd9JV/BiYc?=
 =?us-ascii?Q?I4g6OVhuZ7F2PX0ratctWWrrJysvF0sahrLMmjnI45au9qU2wrM4FZ65gmft?=
 =?us-ascii?Q?QEt9iVvR/tghJV9Gfx8tzn2O5JJWwmrx4fc/FwK3VOKcaIpJsSNqEhFfG1Lu?=
 =?us-ascii?Q?2j+7yzuw+xQ8hPfvMpOgOKoJszCPQ7OGJLpI+hbEsmCvU/qlF2x701I2t/Ua?=
 =?us-ascii?Q?sstFpbTsQYKg0ItKPV1F0aAULSlQt3z5V51JKwAeKfTfB/c6eQ0aeeFeLezj?=
 =?us-ascii?Q?a8gAdczghVz5Wlx3AmhyucLbk1TunI1CESpBzYciNW03mCeaNn9S8jlcufY3?=
 =?us-ascii?Q?lKwcnaBMabp3ttSqounALBigejvqdr7cWV7F/fh6ruikRMoKmPr+TAmDpGin?=
 =?us-ascii?Q?sl4VQkrzUK6LdbdJpxy7QO5ybWjwJqei/0DLLzhD2mrsfsGR5tGD/0KmOW+w?=
 =?us-ascii?Q?kGm1pelnHXueDAuBqtmejm5iDFuNXNTpeDCRfTbePY7r26D+0hlt+pJHMnW8?=
 =?us-ascii?Q?nmgg30/evDiazZWizuKilkdFYoTDMbktPTHkRLxVdM9hFQSXTH0W1AN+nzGO?=
 =?us-ascii?Q?AAqlwbvWlCK4WME9Z3uJCfl6swWzPszQ3+T2mopchEfkTcoOOutC6IEa8qN5?=
 =?us-ascii?Q?hI5ypIrhnbrCFDGdLYxvEbx+AM0fLgYogK7Z/A80vm+9z4EAZEQLEZkqqWQt?=
 =?us-ascii?Q?wyemVVe+B8kD1D5vQGRo3PlvZMEMw5bLJTCww9n2ZUNpdKQjwZMAm+HBJvCw?=
 =?us-ascii?Q?lOVe4LPExjtDI61bjXJoTi/OvKns2keVi63i3nCEzYZjBs8be3PNDI/xYjPG?=
 =?us-ascii?Q?zDwMLGD0ebCoNJ6jD7/LTBDkcdJoU6JjZ4kJ87pDSSooDSGhmrH3zlTVptDL?=
 =?us-ascii?Q?FviTfuyA3AMZsJjEvcec3b8RmTcsGH2BILerHmeFR1Ntgu5OrbLaw/whlLcx?=
 =?us-ascii?Q?9DnHr+p1MoV7xv2tnTINqV5qaU8LDcpLhciSMuEmKoxEHII6WcE5ep7++0in?=
 =?us-ascii?Q?4LNCFbv2Kj07s4CYFzNzCM4Wgl/FIVbqfSj7LnWWW0SGQJCcEjZwIxlbWXao?=
 =?us-ascii?Q?F6KD+Ofrbc+Cpu3CoIAqKWthVGC1SKHbrWdXxQ6BLCcD1npbn0p9iMBd9pHY?=
 =?us-ascii?Q?Q8/B+51o5uu4/p3k4T2zEhx8si3XFU9HnSmxLzDN0oicunYzTELs3mTX5epY?=
 =?us-ascii?Q?QOa+LcjTUe9S74iTCkw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b4252b-b58f-4cf6-8fe4-08dadc581f24
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 15:47:08.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/cO+ajS/chcs3f8ZE5VDEy0sLEYJc3OAb0zOvszd8TzR0PvyJEwPsnJKtA0+WTf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7339
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 04:17:58PM +0100, Thomas Gleixner wrote:

> Obvioulsy unless it's done somewhere early in the PCI discovery,
> i.e. before the discovery associated the domain pointer.

I thought the problem is more that the iommu drivers change the
assigned irq_domain:

void intel_irq_remap_add_device(struct dmar_pci_notify_info *info)
{
	if (!irq_remapping_enabled || pci_dev_has_special_msi_domain(info->dev))
		return;

	dev_set_msi_domain(&info->dev->dev, map_dev_to_ir(info->dev));
}

Which is ultimately called by 

	bus_register_notifier(&pci_bus_type, &dmar_pci_bus_nb);

And that compares with the iommu setup which is also done from a
bus notifier:

		nb[i].notifier_call = iommu_bus_notifier;
		bus_register_notifier(iommu_buses[i], &nb[i]);

So, I think, there is not reliable ordering between these two things.

At least that is why I was convinced we should not do the idea I
shared :)

Thanks,
Jason
