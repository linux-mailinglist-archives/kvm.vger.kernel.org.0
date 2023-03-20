Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7572F6C25D2
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 00:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCTXlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 19:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjCTXlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 19:41:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97091CAFB;
        Mon, 20 Mar 2023 16:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzvCminZJ0kTJT/l+po7uWerkA4qbPjjBmvzpjxjwHGXXBcam4RIF8IyBpPeNZ3Y5teNUmVO3Ai2JTOnHh57YdBh2T/PBZH/oBJCRnvnjxjrWLr7/FsCnXl3ETssNtRXV6VX25zQbkVvFQ/lo4pR3BaDGpgZE6EkDQa8SOVvlbL7uIIJvGRfi+9zp0jCXR6jcUTHBA521PqJjvkuwDHfkvRMjrdqZruQzvGmytyc0ewfYM4AnhHx2pbN9oPrmV2XXSLpC4FAMfUXHh8tbKowEw0YAoiFq8FxpP+OGZWaJ085j1mpLCbvgLieSlfvtWbF4MHJRmaTi5Zl5iBhEvDFUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qhe3nrmRO2ghRihe4zlCxwNH9E5dpz+43A+o4eYuHvM=;
 b=kLcJlox8hH2wapJxlI/cK/ggSoODbuGVjPzajO6UeTCa3JCpP9TLb0XO2d3yxQcRjKUliAdAPAHXoHwtddvZl2SnrqGLQypzJG12rcE1KyOTmkpoOh2Q/zOWRR3ZYL/EInGdVWxuUKpmO3rzdw2QjueuMbYB1OVHvh/Fw3LoWwgqcKo0xcXYvuGlsZVuuXsTpn0re45xnHI+BVefUcdmIxNCW8TMYOkGM8eooPCGQAOpPBeTPfyzcsTFWt+ynTeng8+lb4mFQvM9nlEICW5jKAE9z5i8vCx0ZTMdUIngpVkhuGaX2VacQUiUkjLmifJ4YLd4v837/IBkOSluJrjWDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qhe3nrmRO2ghRihe4zlCxwNH9E5dpz+43A+o4eYuHvM=;
 b=UtxB+Nw1Kt1xweg2Z1qMAYP6YAJpFPUU23w1W8p8v5/SwDHmZAjGPjfyuywBFN9NbPnG80Hq5aMVXGdFcQQnQQn0qcGpsifQ0WTT8OFwCeXg4X0hZW9IJb00M5oUMVXvD0jPtmfR9uHY0ClF4ZYsk0gUb/06YkSBU7Ol9ItiyPSNB63KYlLI5/TgxsXDosBvuZuGQvkEXnEoj0Rs5+zxCcbpILAEAOYJnXVxEiTTUbslCvK3OXRdsTDSTtIyWHye6LtB9i9ZgAf2kgIsiByntyHEVkNXkCEiBKxSNv+fOggj1olAm4l4Lab8tJZUhNNkuFlLSaaObPoIV9szpNPJvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB8558.namprd12.prod.outlook.com (2603:10b6:8:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 23:39:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 23:39:09 +0000
Date:   Mon, 20 Mar 2023 20:39:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBjum1wQ1L2AIfhB@nvidia.com>
References: <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316124532.30839a94.alex.williamson@redhat.com>
 <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320165217.5b1019a4.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:208:23c::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB8558:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d48bc62-43b6-4c78-508f-08db299c4d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fgiDtZM7aMLvYRcUvZzDRJWdIbPFPLJd9Fi1tsWrwcLH11rvgWkHYLER3pFZUOHgTWj9uFpNWSZtvEV7Qwr7d6yXqXtbFQvb2pn+S1ZVQhCumVfazIXAeDxARZfQ+0/PquJ8c342chhgzZ6AOUnlpAvOkZ5ZX2aZEvel4/Rb8klLpvoRjoMZlKyJpQUoybOKfOP7cJ6iZRRb4b9VdBkQKr/gUH3336I7Lg9sSFB2ihIyHPLut9Zb3YXh9YGdvmS684x8Q6eGGEhSfsbi06j1OUnlj9vpaZ0a9nHadn+Q+5suXytMuSUgVrNTnRO61mtTMLiEVH8csdgvDvjqF7GsDaG6ACW2gM5oXunFXUdGTeyvHQR4rzIGGYckRbnqG8beAkb+27Wgo6irqXaHNpCSuuORSgWbha/d5qtE8WzF3tyt+TpmXWVASM974mDqVmAGVkWfs/sBvzKHP5kVxG2MPYQxDBiz2gCeb0RDaTv7iX6GFy7fTAPajXPHzP9Izl/03X5vAKp5OUAL1Hz6U7aTYI8Qfzc8a26z4wy++r98NxOWzP/PybnljVMUSU+KbT31dNE3CcKiCCmyEJozT8BFPX4nvnDYz22wC1Hhi24r5vxbl5jDkEreid7rMh9mV5s5ZIyRNh1sxq1uMWhpEJMiqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(451199018)(8936002)(7416002)(5660300002)(41300700001)(36756003)(86362001)(38100700002)(2906002)(4326008)(6916009)(6486002)(478600001)(83380400001)(2616005)(186003)(6506007)(26005)(6512007)(54906003)(316002)(8676002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wVD57qqq8p0yR+Nz+HkOQrx6OOZu9gfP2oH6iXLDHNK1JA0UeZgYlvMXAhI3?=
 =?us-ascii?Q?zucbnr8TmAequPRLw1wpJ95mXBoTHjXIoL5FlA1VD9xyU4n0susII1f6pDA2?=
 =?us-ascii?Q?Zj6hs+tAeeXDlHTrlUZPZwOqyzYDiWOmtoh9Cw9WLpbvdGMxRCT3jbHXOyjj?=
 =?us-ascii?Q?EYxmSkA3Befm+RQg4CiZlPSYyQArGYytBfhbaQDoncSkwBkv6R/zyoswtIwN?=
 =?us-ascii?Q?RWKib5X6bH5BTcEHZoEo5yCGduwCoomlFz8hmG2c15Kn/Jb4hi8YpEbdhHSa?=
 =?us-ascii?Q?d1q1Cpa1urth8O97GulEoUdLKL/oXzY3b26gCN93oha2YciA4vQfF7b7sIwT?=
 =?us-ascii?Q?MmWCW2xJta1yw0X5NGChPkGEbJt6loA190GmFskc32nKhXK0DwGkqbfDOogK?=
 =?us-ascii?Q?kHruMlAWyj943rgackSzqNWu16EiwutTcl/gY1lG0NYVXSFnctHLVUPDjYqo?=
 =?us-ascii?Q?cUfpKRlAzS1bf0v6Iimc+QgCbi7c2FUgtgn7RqT2VVOqQhQKLATjI19kKusd?=
 =?us-ascii?Q?pF5wL90cxs6Cz93+ZTDLjbMh3Rqy9O/tn8lCQWqdSpNyovOAZnY2IFxLpwvi?=
 =?us-ascii?Q?nBVT+OQpYuByW+SeqZVMOUqf47rCgkkPUe/uCufWBrUwUMTLRq2BRy9MOlpO?=
 =?us-ascii?Q?5YQBjBWFlR6qD9u10VK+DB4P6YtD8fd5xGl5q/ZYt4cprQ+T1YwqsuRof+8I?=
 =?us-ascii?Q?4Smi9CXV/ZV0TsVUorOjpNcevriMH2qobzBu+x748GNECq/wx4+ix6MKtmyt?=
 =?us-ascii?Q?yBBxyacyTgzv9AlcXohWWK6u7aFs+qHoJJ7dUdqzGNpfqU5PxAamDwbkl01O?=
 =?us-ascii?Q?tW9rzLvU++P3Hy2B+6+XN7UvDjt4Qptww16wUZxqC3Z4FRP2MPgjjwxCowIX?=
 =?us-ascii?Q?e4UOUNszvTBzygr/QxzEi5s1bxmFJG55JQ46oKSLF3hTdnCRfzA4ONBJA/4g?=
 =?us-ascii?Q?vTm+gJXkg0CKVXXfYC9iBQOn9eA9DU8gLaTT9hGJpHABgVzJ5o4ZDaxKJ+ta?=
 =?us-ascii?Q?ucSRkFT6Pd/J2mDlLBErbwUzuYFwraXm3EQci/jVlUDZpZB54MDYi404WB9R?=
 =?us-ascii?Q?sA5lC52ixVCCpOlUQggZqHSNPbYFAqy7UWRQriSy0pwwtwk46GjMA8lz4ltU?=
 =?us-ascii?Q?HRIXI0E/qVe32aFpxQaoWIVt5SW5ISKRwliSIRGDjYGNzrbMUfj1XHwpIvOJ?=
 =?us-ascii?Q?Jhqq7k5hglQpj+mayDbOwJ1EEklWDb+VkAX9L7Im5GTt8/SOz4O8ekt1zq5X?=
 =?us-ascii?Q?AAMPMbMHSQ+wA1I9c94+30P0DzpyEovJbmxj1aYWSrY6+RGNpqudK9ksSiHm?=
 =?us-ascii?Q?ykMvvyLIMzdWo2Ylwd3hBT/SAGxUBzQcH3FQmyeqNH53FpCejendesi++c87?=
 =?us-ascii?Q?QyqYcCw2uAdZwipLX4RPuerOd5+TcMRoYJ9+42nf0EE8Rugdpn1YMseMJRH7?=
 =?us-ascii?Q?lssHcWl+DezLxiy672YpCL6axuca4UaQLmWK0OP4RYLG2eOeZ82G+jls1zlC?=
 =?us-ascii?Q?U86juoxCJl95DvejGgXI2ayTT2+B0Sw2uXjNJOlt83wc6ONdq6p6qnyV6bT2?=
 =?us-ascii?Q?nd6XEiEroH5upa8FVoCagR6IysnWG+t2+7MfZ1NR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d48bc62-43b6-4c78-508f-08db299c4d18
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 23:39:08.9851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfEijqFnnafr4BM7+aN+e9hszR/hPGr5GWgK+NmQUVgQkFY3UTlA6TN/CicPgm+Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8558
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 04:52:17PM -0600, Alex Williamson wrote:

> > The APIs are well defined and userspace can always use them wrong. It
> > doesn't need to call RESET_INFO even today, it can just trivially pass
> > every group FD it owns to meet the security check.
> 
> That's not actually true, in order to avoid arbitrarily large buffers
> from the user, the ioctl won't accept an array greater than the number
> of devices affected by the reset.

Oh yuk!

> > It is much simpler if VFIO_DEVICE_PCI_HOT_RESET can pass the security
> > check without code marshalling fds, which is why we went this
> > direction.
> 
> I agree that nullifying the arg makes the ioctl easier to use, but my
> hesitation is whether it makes it more difficult to use correctly,
> which includes resetting devices unexpectedly.

I don't think it makes it harder to use correctly. It maybe makes it
easier to misuse, but IMHO not too much.

If the desire was to have an API that explicitly acknowledged the
reset scope then it should have taken in a list of device FDs and
optimally reset all of them or fail EPERM.

What is going to make this hard to use is the _INFO IOCTL, it returns
basically the BDF string, but I think we effectively get rid of this
in the new model. libvirt will know the BDF and open the cdev, then fd
pass the cdev to qemu. Qemu shouldn't also have to know the sysfs
path..

So we really want a new _INFO ioctl to make this easier to use..

> We can always blame the developer for using an interface incorrectly,
> but if we make it easier to use incorrectly in order to optimize
> something that doesn't need to be optimized, does that make it a good
> choice for the uAPI?

IMHO the API is designed around a security proof. Present some groups
and a subset of devices in those groups will be reset. You can't know
the subset unless you do the _INFO thing.

If we wanted it to be clearly linked to scope it should have taken in
a list of device FDs, and reset those devices FDs optimally or
returned -EPERM. Then the reset scope is very clearly connected to the
API.

Jason
