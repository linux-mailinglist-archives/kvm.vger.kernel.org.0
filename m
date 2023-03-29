Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672DA6CEE4C
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjC2P7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 11:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjC2P6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 11:58:53 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E1865BC;
        Wed, 29 Mar 2023 08:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7McnkcppCH6eGHQkowFdqPKi92TYeXTR/sr7dkt4MmzTV6eWYnrHbpQfPwjjkEazc46NxuE+tMlv8uP4CMEws3vUc4fakH/svVBaySi0E8LM2/yvSZSr858EZO27FkKI2kZIsNfzUBGT+TpPKzUwx2OWLIXABDS0hyLMsS+GyJPMI95aPXdwmNMmJOdw9TIVLMTbs+5DMK0QEdqQJo/OYZeLTLB3WVOOecUc4rtNHU8ZTtGtt4b4JcK0R98W8iQsrzEwL/WdgNsInGuh9lfHK66UaSwV8cCAXlOeTFufRq28NR6eumS5NAh9aMuMAey+eov4ohoTp1hKMaHY7zXsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFWtCyb3wT8/JrP2TYqx1qc9e4b/oU9wpG/vP6sxLAk=;
 b=MjFvJJ2XkoJpyZgp22feWXeCkUUKLuPEmDJYf8vO6H35t8Nj19H+OZxYKpL3DN+MtNdYZFQjy4BYVic2wGtH0EeornqwuoIiWyfgMPOBTeKjfTk7Hg6KSjxs7ouUrLlEn0cTjbIL4Fi1JPPUaIYUZ3qKcHw7l1T+7ZY3Ngy7HvC49U9PEsMhNARsnsMWvbWg1ercWm+4A23AyfJNHePuHPkYBl6KkM2eQ+EryuH5wQv5rT3Or+zBZz9OY7Qkf63HQm5fiKfJYhQECkKyrY9OGFjhLmCBtqNbXfvpe0Cx1+Ye+9XcMVL7onmzM3HighZBmaB1GXlUv0oAvMJKDZsr2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFWtCyb3wT8/JrP2TYqx1qc9e4b/oU9wpG/vP6sxLAk=;
 b=OGw+tXmcU+kzspECrEzH+6W5ez7CUm6r53a17iVhaOqlkAVPS3DdgJ4dQ54JTSb0tKNga9z+B0daH4NEkcSt7EKmGuN3JzE1Er+fWT63/OPYZlZPfXokxFBzhHXr/BUs5aJiKFeCIMbkCtuq7l4b57ZKvy3H+z3Vps2jDY8BS1e/QKIYjZpUQ6sajqgDt7cOtv9Bd7+1C1ewEgxhm2tX7GzI3hWkxUBJJWpcRQr+y0I9ITjdfGrnlCwLkPQLpTRzboCY8qu9Xik+IHszuN6ampNYqEZqnEwPDuLDZ6mBZUokKHVynoiUBE2GfKfJvXxAbfGpkhWyLPbK59VEO5PZ6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6686.namprd12.prod.outlook.com (2603:10b6:a03:479::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 15:57:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 29 Mar 2023
 15:57:47 +0000
Date:   Wed, 29 Mar 2023 12:57:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCRf+OdpBVnw5ntC@nvidia.com>
References: <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230329094944.50abde4e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329094944.50abde4e.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 210e5c7b-2579-415e-2c22-08db306e5747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGzzIU3rW7Mx800khtU6H9zot0Z2GrAkryG23QpfpW2XIRBmSbQs9qREXyYBF0o6FDWUb9pZKYYxXo7oANEHrY82EH75V47ZgBDsXohFonvV2jwb4P7+cOnDLrPw/4shB0u7LzjIrpBNRIoJzPAQlpGeGLk8QXQxgA6W436ITS7cOtazRZ8Zlaezo77S7a3kWsL+psgXcGS4gNLwe5lp28+G9Br3BsUgEZ43xXZxeZh5oImwP6BZJcbTQCmwstN9W4t664X6ijZxO/+g3qQ5tT2qMgd4Ez/cs2q7dCbVe6Lwk9mu7vex45XkhCY8ZpEPY826FrUy3yPK1Qxz5+4fCjI7F0gkA20N6Md7DZ3nOI5eSkOpauTP2XyY1uPRYELV9Rgs6mgK1N+L0IvNYt0aaqOUgBh06Q9UNf51IoiOO5m9BFX7xnrs6gpyWyTrCn+EXYVuRI/zfIAaRym9aiCiZRvd3ihYW95goJbIEbf1F2TZS0mtHNF9Gk21wxISKlVkr0lrN9vskJCxF6ysz65F1VaXLQhcFBlG1A2hwzV9wLbuAMUXBI22TzR29LSpmqNL2Uyi5tDtKbSxC8bmLzva4Am8uB5Ay9M22h5W6G8AunI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199021)(26005)(6512007)(6506007)(41300700001)(186003)(6666004)(6486002)(2616005)(54906003)(316002)(66946007)(66476007)(7416002)(8676002)(4326008)(6916009)(2906002)(66556008)(38100700002)(478600001)(5660300002)(86362001)(36756003)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1pFqvHR/vNAqOy3YdfcN1Ytf5bUdG2AAJuED5rLxdx7BHDjFUzpPXulGodZ?=
 =?us-ascii?Q?NmGrswRqYr8lhNSw/Y+kQBV649g26xFzX83eRaeIxaASNkRgVaXhLTvV4VFO?=
 =?us-ascii?Q?84lsNJfI9plargfcv/2FiNJ8bLJGbVPmx/nrrXlnpncE36oUcjQOfqN98vHQ?=
 =?us-ascii?Q?/DbO0fKmcVHI/jeDcvwSasS+/sZuD3hs6DkxGPJLjaBGqdoIsxrxogxTQKyT?=
 =?us-ascii?Q?b3sL2X696fL65LXlb95Bn9oziy/ORhIo1MxkCT/kNAzbFzClt7wUc81XghCi?=
 =?us-ascii?Q?eakYL8PceUZLlLUg0N3yYX1NQpqXj3XnjnDdJlDKoPrGOrF3QRiQSOjkbbYR?=
 =?us-ascii?Q?90LHL6et/4afUnKe/aeJGKFRYHZsCy6eo+Qne5hB1SgvdCVQpUgHKWN5Mm/r?=
 =?us-ascii?Q?eU6VGWG9n5tPzcmmW2Q/MYlQu+zlVVJ9Zpc25LMzH7X7nlv0LT/rp9X0w/A0?=
 =?us-ascii?Q?CkhJeeeaTPUPpZjxTuzDBPOEs7buTQzK8uO85/vKGiAji0kg+z4jjegflYen?=
 =?us-ascii?Q?QQXtd4Nycwt5gGd58unCZFAO1i2IoGOwHcwucPnX04LEqksMfUaDLoGfZnCc?=
 =?us-ascii?Q?OJPY0Zj7JxMo6O1j/E3LZZh2cakr0ahPXRq/DgYoV/nJqPEhvplqMTyS8mmQ?=
 =?us-ascii?Q?dDtvHj6w8J3fHvOO7AVtn52DquPwZETnw3/vQTTCacLXrmqEruYTekuHiJNZ?=
 =?us-ascii?Q?nf/EFlcXAjf+JsroMSpNJp5J7H39ZLYqvnNqYgCZ+8D2XzwKZmMFv0kUZRnU?=
 =?us-ascii?Q?9DhpMfwv1x6X6Nh8vVNSI+HGVYE8ty5xv17ILgFk5zX5M3C6LjmZ41DmEobg?=
 =?us-ascii?Q?3Q1sjpZ9LQp/iNMBXUavF0gkOKyBvuFt/h5LlWLutYcfEXgAls6BN2BblrgP?=
 =?us-ascii?Q?DHCcDoS5B4PRGjfCFNWmjVyNb3nORHCMAJiz+5DGexAXC2uaFKtvEx9tKR2U?=
 =?us-ascii?Q?H3qr1KD7d9WiovxeOIFicAAYU2eeeByC7yebnYqqjsfyxgqlsTImxnsxE9MO?=
 =?us-ascii?Q?FozKX3uF7fDZH3B5iYoPvJR1dk3WgU2W928fNTQTs83nXWtRmMX4kx9ff1xv?=
 =?us-ascii?Q?tmh1LA6/rb/cUQcj0uLGtwI3fkiSVehlQ4jQRkGxWumpScYxHmeB+AESESd7?=
 =?us-ascii?Q?/Ng7Ca67yn7DaFMCp2sRaN2gyNTyYhUdtkO9Mt3sYE2wXvSbj5q0XXDkikkv?=
 =?us-ascii?Q?hTcJ4gvVWlu4PqTVn9gmQwIf8Qv0SFD4vYjjomSI+OC1m4Vq81wWv6piNmEe?=
 =?us-ascii?Q?nKSURkNrgrWWFKsi8txF0TrOLv2BJ8qvAL63yz22HknTSOWwVny00a9ZyzaL?=
 =?us-ascii?Q?KwhwfieFEehELokKuIPxwulgSbdQFqhafpMJg7YreCNbz/q8o353DeLEnh10?=
 =?us-ascii?Q?1EWUUqaVPysRgEeJTElw8wVFgR5B/e+epf7OnA3pjvms4NNgSrIJ4Ff5DDGr?=
 =?us-ascii?Q?Ib0IWSDmAgvFJUacsLxUEfH8VKjtSc9f/yFxsVWqzNbDud4a8vPkLABEifSu?=
 =?us-ascii?Q?L+A6wWGVPXLeg2Xoh0q6CBl5hv8ZKrDUS/GQCVrNYxZH0FmcIxjGCA7arpZ/?=
 =?us-ascii?Q?ClvkQORmj2oA93zpjKHQcoYZ2IsyL6hFhOJKfDfN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 210e5c7b-2579-415e-2c22-08db306e5747
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 15:57:47.4062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYDap3Je9LlXcRcQkEpMLOCj/r7D6w85BkMosAG4YkT5s7ULrUhJT8L3JyCq6OW6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6686
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 09:49:44AM -0600, Alex Williamson wrote:
 
> > We could extend bind_iommufd to return the group id or introduce a
> > new ioctl to query it per dev_id.
> 
> That would be ironic to go to all this trouble to remove groups from
> the API only to have them show up here.

Groups always had to be part of the API for advanced cases like qemu -
the point was to make them a small side bit of information not front
and center in control of everything.

> For example, devices within a group cannot be bound to separate
> iommufds due to lack of isolation, which is handled via DMA ownership,
> but barring DMA aliasing issues, due to conventional PCI buses or
> quirks, cdev could allow devices within the same group to be managed by
> separate IOAS's.  

Maybe some future kernel could do this, the API allows it at least..

> So the group information really isn't enough for
> userspace to infer address space restrictions with cdev anyway.
> 
> Therefore aren't we expecting this to be denied at attach_ioas() and
> QEMU shouldn't be making these sorts of assumptions for cdev anyway?

I guess we could make an API specifically to report same-iommu_domina
information?

I was assuming qemu would use the group for now as I don't see a
likely future when we would relax that restriction.. So I was keeping
a "add it when we need it" attitude here.

Jason
