Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B0A7AA505
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjIUW1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjIUW1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:27:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39CA4EEF
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyf66/MUETVgxz+vbMEyoSxAPnZGO0pMhfcWJM2pBcoXS9XTOx3sr836T7xUP6EYbDIdXogJpM5O+CMaVqzMM7bD+ZtbC3DGX/GpDDKpJLcHuZOa4vija0Z+/DshRH3uKHZXf/8QvvBg0fhYZTLdDrs6GNQWASskY32N0kqTj0ZWU4SHK4Wnrg4NSWXiJLWU3+vOEmb4uoXHYLHdi84vGyxY/kXAIAWrqkLC092DTcXzOgv8jjKHQXtGvJaQ5q4kUN245MrvImQQnKAVmm/XrT+n9vW/n9irsvXBSHR/aUfz1r23XBo9AlHKLImNr9uas2WxR44R8O7EkGN3W3m2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yly51yZKoLy4UV16QxN/a/cK60B6x8bjJ7h33uht9wM=;
 b=B5scfZxwpP656X7bv/CM7CgOhd9zXvOo63ywxIly7G/Bu0CLIUK2w4vFHtiUgM4SIbVFEKNh6uKifLRv/kpvMaOIzIqeKTtwORYfUtlLNYxthdNuomHb0SoMRugLzDfc4UZqlkmuZO4My4YJUNLhCpTeckB1gRQcd3o6a6e7JmTZV5sAEPAF0ttMlVqv3dhGUnjlfCixulvLDB7WlqkPDhWGg5dsF70Tx/d8zWefOdpSRq+elWk0sBLXSXUHBDKf8MYhCx1Rtx221V5DbtA6eVAiahubPH6H6XtIsi9dIEPW9fBF3Os36aqbtO2R73bwyVUVSMqlSAimtfNet129LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yly51yZKoLy4UV16QxN/a/cK60B6x8bjJ7h33uht9wM=;
 b=KII9Lt1f930ODRcUjzYADlUClUzyWalSTJ7rjsR4DA5lN4SDP66bYfh3PqBUshrz8vA7vpudU6CArcGgwuE7iFRxpu6HVCoXbRcxucc4jipm/f/Hch/s8rUDwFyjDnYp/TPr8JdXx5+kmu98SZgivsW5s15cB7vVnzhTGP3zUUsK5MLRpl9DOoTBTGtsha4ZM2KbT4V/6NGq3lcDscO1gBx9MH2x+q3ghs8l2L0sSB+6HR4/fDaFt4S4Z14eJjolA/Qo3k86B6cy2b12j1pLN9+VDlmn+Te1tcWInm7S8QRDIOkHWenhVwspKbF/xQrrJ86db4BZhjTfX/HYSjtSKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31; Thu, 21 Sep
 2023 17:07:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 17:07:12 +0000
Date:   Thu, 21 Sep 2023 14:07:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921170709.GS13733@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921125348-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ba60f5-a60c-4cf5-bca1-08dbbac53278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4npoSjWRW2Qj2x/FfkJWW34l+Goevhu8bEOK0VaCY/R69R+BYFBt8K0lOBFlLRjPDvnraP/BnK0F0uvxoeuuVPfFb2ZKS0v2PXuhrfZC0FMv/LHVlA9QENIJjL8p+JsV80aG6LMjtzX9QxJ/synQFxcdr4YsQK2UzOi5w7pml4qZ9i2FuSiYhPQcuge/Kxd6PhEEmCQlFDnHlFfek/4YtEmthZNYr/nz85gC4F7JtK1HL73+X4SojyEk6eNLkH1/HYkbqJipC/o1tNdSVCfrdYZ0P74k47CVd+uElxqeBkEJVRI0h2+hM44tQKrcv8yLEVkwTLOp4C5BxDw5xTi7U9oPHd9u2O2VJBSGCRNYWEq6ZR6cc/NEwBNOFei+CbPtTW81GR5YFYQ/PEi2mo3oZscr/3xTPyfyqXBH9nPipgb5T6Skf8MfeYSbKyatazpxGjSf98+t/WD9/QkkglYkX2O9DptWtLSl6uLBbSAEu8EE16EgfKanf1zQsQf19q1zxBZDcRZS9k8w8G7kO2zEBeZBvEji7q7tzjjHZ07v/X0aU/uLvWpmoKyI2eogRW1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(39860400002)(376002)(1800799009)(186009)(451199024)(316002)(33656002)(41300700001)(36756003)(66476007)(66556008)(54906003)(66946007)(6916009)(86362001)(8676002)(4326008)(5660300002)(8936002)(83380400001)(2906002)(38100700002)(478600001)(26005)(2616005)(107886003)(1076003)(6512007)(6666004)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1HE9Zed3LMkYASnVXs1U2yZy2Q924y6EL10+4qQcY/L4tuvGVtI84mq+8AE?=
 =?us-ascii?Q?WZAAlpPxTsEc1YbU8uONl7Q05q1NR2XZucuI4P9Ldn9zrMPCui1qgs6Mshea?=
 =?us-ascii?Q?gVSGEAw8ud6bvbwV5ck+GaX+R1BIJf4VJADJksKHofxM6kk1RDAAWhHFKS9X?=
 =?us-ascii?Q?iPfde+y2DsGXOiuU9yowSbZCMQM8GZWAw2xGpFcnRZhjjsiWIGJBMdTtm1dM?=
 =?us-ascii?Q?nSRSmTxGx7Mbh5VRB7mKk1yIv+geZUmWRz0Pea6+xh0ZNoK68bkfl7I0ze/K?=
 =?us-ascii?Q?/lISs3vH0T6d5eQEqhukYEbHXgI+jJT6MmkILpUcvwk3elYw/d3siwJyDFay?=
 =?us-ascii?Q?qStOnBYJhxhly4hXAQs5ewjFTtuy79lY9TtQpYkicrQZhWsRYaybXAuUZ1fs?=
 =?us-ascii?Q?8egW3evmOodTY3FTzVprM9Uizs7gjEN8vexyXsMyEkb/RksTGR30j1uavR5m?=
 =?us-ascii?Q?O5+533CBM3i//49fBj8YQwXJOhKsXoU9/Z86FLcfK6k15FXgmSo9bG6LUNXR?=
 =?us-ascii?Q?3+9Pqj+gxJy4Aiuq0znUqYPV0EY1YThM8/oySTdaAQmUN7bagNlkABO/EYlM?=
 =?us-ascii?Q?UbBRFheAVkKZJ3nST86FooD/YhC5CkwPUen0+qTY9ZGAAt8fCMNK6VTGWpYU?=
 =?us-ascii?Q?6lrL05QglrxVtrxYFQLiZ/y0fls7jnw6MRyU49Y7hbujvxLqA+Ivj57Okkjl?=
 =?us-ascii?Q?Z+NuNH2NrceLJng/l9W8fkjJYL1Rsq2Wi2Q4LnALvXV/j3a+UDE5POoNi9TO?=
 =?us-ascii?Q?7chVVUepUTnHVjcZ1emoFutUkVtL92TiZ43+psbrk2bgrssmAv2WnGwQPRj1?=
 =?us-ascii?Q?nZ2Zl3fmCWo6/SACXGpDYhA4d9/YdRusOGOtSwlWKQuBK6nxTCgxshf3PMng?=
 =?us-ascii?Q?DXovf9EkUjxAUt8Dqxwd8KUiGlT7Cpn/nzmQ1192nDuzGGLGh0DkEkQ83JZi?=
 =?us-ascii?Q?F64HNnQD5HPNK2tg2EaahNYY+sIVWf0rNnHmX5KC5ouTy/IPvCB6k+hgTyrU?=
 =?us-ascii?Q?qXimXt7v9xBsF+U840wvsjXjXeBXZXm6PMeLokcIy/NVosAcB3EM7YyO6FBe?=
 =?us-ascii?Q?i72bGxt+AY+YJsb+7KH+MtuJYhoEwbjOtG1SJi5Y974B2yf8Svbudlz4b9VT?=
 =?us-ascii?Q?6/trFFKGgloH4uABsvA3e4DabCSIQ/gHTPnf1CfyTfBofChuBUx8Ex0D2wAh?=
 =?us-ascii?Q?/be23z7X8s/Zi2cKPaiIweFN7USYGMnBCO5INfLF6ffubctaAXN56lC3z/yY?=
 =?us-ascii?Q?q0HQ7rr31WlmglbokS1D9ht+hkZF25NNTHwxn6n8HZmnumg+JDWjPRk9de8x?=
 =?us-ascii?Q?+OejN4aP14FkE/w5tK4CMCOBT4X6s4GewrRAkx4h7Bi5Le9WjNn5I6TEPJDm?=
 =?us-ascii?Q?XY8ag+KUs4CsrSDqsb/TmbIgyFQk8BHTa/T+kb2NtrEGOaDa48LbMJ0ZO57m?=
 =?us-ascii?Q?W7brE27LYSqH86wyUAwY6z1ZAerGIDit9k9PZp+8AkDuSkwvrrRgepa1hPPU?=
 =?us-ascii?Q?02mFpp+ogYKaTNoOGDflN3S1zzWBNl/AWneTMtNKqF+nuFaZeHsKJODMe1hM?=
 =?us-ascii?Q?klSSX1D062E/zo1KgjxenkFdSRYH4bBg5GvxnM14?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ba60f5-a60c-4cf5-bca1-08dbbac53278
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 17:07:12.2812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkP5ESsd0TVnPL1uAThkPf0xz2LXBjgUgTZuQUToqiNpZbW8Z8TWA+UgsF5rrKbJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 01:01:12PM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 01:52:24PM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 21, 2023 at 10:43:50AM -0600, Alex Williamson wrote:
> > 
> > > > With that code in place a legacy driver in the guest has the look and
> > > > feel as if having a transitional device with legacy support for both its
> > > > control and data path flows.
> > > 
> > > Why do we need to enable a "legacy" driver in the guest?  The very name
> > > suggests there's an alternative driver that perhaps doesn't require
> > > this I/O BAR.  Why don't we just require the non-legacy driver in the
> > > guest rather than increase our maintenance burden?  Thanks,
> > 
> > It was my reaction also.
> > 
> > Apparently there is a big deployed base of people using old guest VMs
> > with old drivers and they do not want to update their VMs. It is the
> > same basic reason why qemu supports all those weird old machine types
> > and HW emulations. The desire is to support these old devices so that
> > old VMs can work unchanged.
> > 
> > Jason
> 
> And you are saying all these very old VMs use such a large number of
> legacy devices that over-counting of locked memory due to vdpa not
> correctly using iommufd is a problem that urgently needs to be solved
> otherwise the solution has no value?

No one has said that.

iommufd is gaining alot more functions than just pinned memory
accounting.

> Another question I'm interested in is whether there's actually a
> performance benefit to using this as compared to just software
> vhost. I note there's a VM exit on each IO access, so ... perhaps?
> Would be nice to see some numbers.

At least a single trap compared with an entire per-packet SW flow
undoubtably uses alot less CPU power in the hypervisor.

Jason
