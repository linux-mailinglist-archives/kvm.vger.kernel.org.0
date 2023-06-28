Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAA7413DE
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 16:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjF1OeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 10:34:20 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:19264
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229789AbjF1OeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 10:34:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0i69RzYmGFBazGN9KjZdaD3gY24QnMThL3x3K4Um/C/zAul+0W7RqVYG77bcJuhHoP/XDxytZw8LgRuvpdqKd6euWyzYury90NW6MvFwhfbfz0k3YkqCw/gdxHJiqGsD2BTnZTMS7xK0e3/0yao30pcmH+TQKnnPFGQtWQkEhlg7VkGFc+J9Q5a9aFakNQ6Z2s4zE543CLN7CRMGQiLu5VZaUTlXDMXrDRVnn4lyNqXP1z41AWoZcClORYGOZHnb7vywrZC1obYusd2dateQyx9H1af4Q/JU07akTksu8nsXaRCsI8o+cKmS6fc4vCwIQVDgNlDYgFi+IBi3ktkSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcXbiztMJP/rWmqrr04Do02H0JLBHY0a4nb8YRqGRAE=;
 b=W4rux8L2pPCJ1ycHV8mL3B8KOUM/67/t+OXrfMAvzHI2Gi9+cd3idSC8X4Ybe3VYbBTK8+h8uUqR11DMqbVYJzdOC6HZ11+kzv6M5vhT3ENHR1nZklrdIjMf//ONT1cR7p4Lx0x7xGxCTR9To44lYn/b+IFYy0oLZkO+NpCloHk0RVAS8zUrdpimEYgFVKaQJqYPm724RtxHYai1l9r6HEBZfyW0OBdAcp/vOWzC6nITLp/wyoH27+t0nqP6qjKaHh+3jsKtLiEsuIGfBr+iHtPMrbghacGlED21UeJES0q+GO8oNKfiI9PvvkyEzUZ0G4uHybEvI92+zl7yI0QUDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcXbiztMJP/rWmqrr04Do02H0JLBHY0a4nb8YRqGRAE=;
 b=tDCHgsHYHpt6kn191/Jbna1/HkWtlq1R8/ritvWxjow5SLRzb1/oadpFflzVXfudRjirazY7syO4QMMZ3g10rJPy0nNefdqvQFxAtJAKb3cEuQzfTQscgSBxNMzcu0X8V7NflWkYRqGa6HA5T+iKy1VxmgXjXbfsDSLF9iVxwbmsQBTwHO5y+ZIsMyprSoMM1yqCV8fFwytCaDu/49vWptxq12tOR+BBRXdfPlNE2JeN9lBHQtJ6BvS7JPDVoq0PiZiK2Ad/x4mH2ycMuZNODBVfLz6hSUss2HqzR195O/H4W16C6M4SPOdHLREPuHDEhDjfJFQTw7DX/71A6x9z6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5160.namprd12.prod.outlook.com (2603:10b6:208:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 14:34:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 14:34:16 +0000
Date:   Wed, 28 Jun 2023 11:34:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZJxE5n7/3FOF+Q7q@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-19-yi.l.liu@intel.com>
 <ZJXFEbmY7BOW6QIe@nvidia.com>
 <DS0PR11MB752904E31251E05619A442B9C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZJmK6ensADJS/kms@nvidia.com>
 <DS0PR11MB75291F4581566C7B78DC110CC326A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB7529790B9BDCB83BAA20DB77C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529790B9BDCB83BAA20DB77C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: 8664ff5f-a116-427e-c797-08db77e4bfda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sttXYF63Vaj6F+UQpYsDhXyJcdnFI7YXouonx3jx96IUf2+COQ69K9KbV0aTE9c2dF7rS0hvxZSK7JKFR2xbuJ3Xgg9MS57D0vHyQwbKgQM2V4W1S585ywRWyCsDH0fP3/xBDhjIiFoeXTZFbevp0oT6ydn57qGyOPuFYzHLAVEMaeYXuAk6zk+QTxCekRiQtwPd8JNRUwi5God+c4nIJk/6XRDZTWBjNTD/tCG6/9zUDmXhz7gkN+0cfH/12JMITb037Kk8ea7McP4GLGmRk7vSEGeisO0XFvzRaZWkATTh//Vybj+Okr6ACV8L6rkqPU4+Rd1wDvX0pv05rEtrK6BjVWKy4HKOh+/yja5tjpgwzuCFMn8vuMUqM8DeAa4wEipaGTrLxFc/UGCJeZxYMnfZRoDt8/CxYU5O2OOjo/N6NZ8DYtbFce4zdLf5OGNVsyTty6F0y1DYIwa/rj1LjX5UwThDJng/wS9gF4crXcr2ObBWVgLcmT/mz5/f/l/nrTwRGoR83crRqzrG0uSWpC6OqIg+/fmBWz6hoDqbjxA9dELd8OcaT/bA4cHUE81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(6512007)(7416002)(5660300002)(66556008)(4326008)(316002)(6916009)(66476007)(478600001)(66946007)(36756003)(8936002)(8676002)(54906003)(86362001)(41300700001)(6486002)(2906002)(6506007)(186003)(26005)(38100700002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qfrQ2OabDYjPZhST75R17S9Kkvh3XDU+WdUyvpTbSgdpNR+CXXPxW7uvsw/n?=
 =?us-ascii?Q?h6MYKVsx0Usk8jJAIx/Sc9RMLb3um09SvzPI8xamxdZYsVZys4Sur7OcLZF5?=
 =?us-ascii?Q?/n6ZHDHmIZFFApx7jjbQt9JYj/+K315UagqaALZpOwduXBJyjdY7Cpim5DAe?=
 =?us-ascii?Q?ZqzJz+UL2szJsrWB3otwf8nB9nFcKKFtG16jeBPKaDufzerAbNhNzptbWHmk?=
 =?us-ascii?Q?wgkLENLCdj484qSxFyk+//tTd3g6p3vf/7PDMX5vFF2ACkN5dxeR7l5x/n8J?=
 =?us-ascii?Q?wajQBCBZp/aD26uDjAw1xSUjuQuZLC5+bOQm2Koj44WMaDGvlUSjbQ5CANd/?=
 =?us-ascii?Q?/o/Wkv+6ZEQH4JjZcmHEIjNldvivtV8hRWZvEYwxpaDGwPLb7o8HnRc1QyA3?=
 =?us-ascii?Q?mVf7Du1WVfHR2iCgwybezaHNWY36FVi6fmMNR+hx64hviD9g3+3LjB06OIeq?=
 =?us-ascii?Q?SQyYRB6DGPGZOmcfLQ51y4c6xS0PKLpc/Rys8JJPmaJsphCPeb4f+Ka9081d?=
 =?us-ascii?Q?2tRfIi+mCabEjVBJXTlRlUetnjcRofjbOkoXy5Iql6YLgGKabXriPppRFHsJ?=
 =?us-ascii?Q?RpB0RocmqKytqBa8gvIjrky0bEsP8q0TltQye4vuBV5GgJzGtxVOduK76OdZ?=
 =?us-ascii?Q?3hmpBQbaKL8hL9pEndk+vInyWHZu8LEQIGV5gVzJv3ggCAnc7v7n5e08vLjk?=
 =?us-ascii?Q?dN0WtEsiNeP9MWfQaWdMoC4Na6BZt0ZxB5+gSBjwrHtgTuymiokwoal/8vjI?=
 =?us-ascii?Q?WyJIOUSrzdjh08NUdJZEe5jWlRiaZ43JC2XNG1Ykg8E30QH5UmpfETZbmO4n?=
 =?us-ascii?Q?3WWjxfvk3rVmghRBmdy1K5Evpf+3EdvWelnKQ5aDtZCSC5pWfNkjaxLV1nbN?=
 =?us-ascii?Q?zFttw79jBDGWwo0TSuCekUkEmu1Mpors63elUuSWi51itLA6IBkBTZ5nENGp?=
 =?us-ascii?Q?FC+L+1A2JPhwtslKk4R3a3a5XpnF4aZgRIooiDhOGc3k/kAGgaBg1pheB8hi?=
 =?us-ascii?Q?JyDm1A9aRDUAjQEvT16pLDoMNSL1Fu863LYOvfqyz9RGys5ZvYyE3lC0hZ7I?=
 =?us-ascii?Q?mZ8sb1MnBmfVPQGcLe/VnKjI9025NIUsxi7mLnM2CPtoXvqM+aYTB52KbvLu?=
 =?us-ascii?Q?CxgNota+a0cczSITM4y+hkkvF8H5P2wKiNvVZtuFwXBRItCK1t2dMwcFdIzH?=
 =?us-ascii?Q?Lang8Zqizlk7MnF3L5VUV9FaY3SX1ED0QzszccQSY7D3+KFO2PLHiJAcYzWJ?=
 =?us-ascii?Q?LfPUghXCowTxiIPnnfzLzqIFysMAt55YBWwIF43l17IXKc2QT0oQElMIQzH3?=
 =?us-ascii?Q?yAT/NlSQUBVi+zx69F4zRWtV7Zsqs9pFH+LpHQ5eUKgkA7UJRU0lKJWpFuIN?=
 =?us-ascii?Q?+dfRr2H4Z4Doi+SzhjtwHg4aMWkk4p6/p7vXgU5cx0eYtz4c2u5idCiNqz3E?=
 =?us-ascii?Q?I+2HIXdUtV+s/tNEZr1/bvtNchIscAVuX27+BaoD6nuhQtnCqZ01p/7Zy3/b?=
 =?us-ascii?Q?AsqARZkL0lSc3wnj9sDDM+wh4FxQtgTYPQ5NCA1lb1tvT59j53MgoYF7+9a4?=
 =?us-ascii?Q?xbqKFoTJTHhHnM0K+dZKGs8FZ8K48Zrp97HK6KTf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8664ff5f-a116-427e-c797-08db77e4bfda
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 14:34:16.1437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a02Ci/wmWwZ+Qg4vPoPnbh1hAwq41pHyUAKxOs4F4fmvzOLkJohtg9wauQvGSV8K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5160
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 02:51:29PM +0000, Liu, Yi L wrote:
> > > >
> > > > Ah, any suggestion on the naming? How about vfio_device_get_kvm_safe_locked()?
> > >
> > > I thought you were using _df_ now for these functions?
> > >
> > 
> > I see. Your point is passing df to _vfio_device_get_kvm_safe(() and
> > test the df->kvm within it.  Hence rename it to be _df_. I think group
> > path should be ok with this change as well. Let me make it.
> 
> To pass vfio_device_file to _vfio_device_get_kvm_safe(), needs to make
> the below changes to the group path. If just wants to test null kvm in the
> _vfio_device_get_kvm_safe(), maybe simpler to keep the current parameters
> and just move the null kvm test within this function. Is it?

This does seem a bit nicer, yes

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 8a9ebcc6980b..4e6ea2943d28 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -373,14 +373,22 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>  
>  #ifdef CONFIG_HAVE_KVM
> -void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
> +void _vfio_df_get_kvm_safe(struct vfio_device_file *df)

But still avoid the leading _ here

Jason
