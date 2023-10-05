Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AA57BA04A
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbjJEOez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbjJEOdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 10:33:05 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3C823D3F
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 04:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZ2u88FmfsHy8qxEAu3+FX8JG2yBrTxU5AjTaxu3+370Y4K8TvWlydd2m2vPF235n1CSAn7L46Y0I3hTkn7OyhmT3L+9g/1SgySAYnO9CSeEwa0fEYNgZOP4ZNtpACSt5zPX8RAWuvDZiLpOQTSe51B1KOpJ2QplwmrmWmhgx/Fc0ppbIYFH/DuesG+5cACFiYwmLzHJef7jq/2sZAxDHCodvqJcQ8BhuCBuUbPCs00EFjOfhtpaOnBwf6iPxS0Y3E5dWbFesW7lTHvie26W7gQwDDC5EHLHZyaJC4R8S+J4oEGS25qr8or9OY9qgiS7pEI0JpqvJLh+64izsygueg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHPHchZ2dJxkKHqULfWVuOgoMfsai81QC+pgKC1Sz04=;
 b=L/w8qHKSDKKFFFAqgeGVRCESKH7YthQcuROfHQCXlXYDfOHO/ltKml/z9aL3DfXtPmQ/YE+E+lsfQtmxfW9L1+3f9dWJaL/mqefA5TrwqZWseJ4lmcGgGDrmne8IduV0rv1IJpSeGa1Diptq5Nec3cCnbQ12atCUO+uQALfqmSJ1c4yxQ8+SvYMlqpLN//BmX6XpG+GMecyL9G19Lc8XM/If7VmWq2f9rSNJbYTK3WNaiU7qIGl/zewjffVcg+Nnw+TZjAfYdcLkifXFPbw3x9JU0K8n38wrwgR+1D+L3NP6GAVXoSlkD8o+7CjdyJCzuiDUBFGpoA80+zY9a62yuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHPHchZ2dJxkKHqULfWVuOgoMfsai81QC+pgKC1Sz04=;
 b=aKIYvhPRlRoba/FItLJsIBjIWDZKrvxGocbzl7fG++9suNQpPwJGHJqgcNwULp8hV1ECz2dw2oyRp3nRmByo5L25G1eDEOreDiwgoIxlyBCm+1KZUh07DMZtmsjLY0Z7hkm/i2iPAV5k1BuPFU3iGPi4tU93chmq8aGfVFQLXgVaHOJTkpd9u2VskaN2oeUJJYWgKXafk2uInzx7LWlpK4FeFyi88YkN/mdrv9eGYKk9qguVJ9mL2i7aEPCLaNpPlHu3+UxM1AcrJe6nMBfLjmNZUbFyDCRnD9+G8fhFpDjhhkQTLUTMRThBRJfjL2og/mqNa6de84J8U4I1TOrd2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6579.namprd12.prod.outlook.com (2603:10b6:208:3a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.35; Thu, 5 Oct
 2023 11:10:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6838.030; Thu, 5 Oct 2023
 11:10:07 +0000
Date:   Thu, 5 Oct 2023 08:10:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231005111004.GK682044@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR54shUxqgfIjg/p@infradead.org>
X-ClientProxiedBy: SJ0PR03CA0353.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6579:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a1f501a-7553-4997-7a92-08dbc593a209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dBznlo/Qa9mcSdKmSDAcHNLSwo7dIWTgvQxQQjxmgHz9w6TrX2YCi19KAli7/x9mRuUtRemREUBfcEN+dDQiebTOei69khw22YWMHI9G0Gj3AGOtTrgULUcRIRZ4JExECxK2jSIcGRKQdOOR/zOAsSDNGMCl8QQm8ITogpP9KyTbWuxLvD2lV9Op0pBz4b1j8Ix3nw/4sPAtgci0fc/At4dFQrxf7yt8hapKstTeDb2XkVlGg/NVqqJUHEEj+RyTnUKI+9BqeWgnOA8O1T40vBt1WcnE/FjZqFkMAQE5Du4zP1KIljSy9r4kZy4knV6nTMM/nFhg3GKh4Q3ia9Wg2dSKwUnZzkNVMsaRzA/ono29RrfHcd4ILqddEpEqEbESCfBXw+6Gf+L2RO6PJ6hQg6woOiavaDjqUCUE4X3lE1EiMfB4joFEpZv9T+ccY9mnQQrOghokejyi1ui0w/7F2rZat1hBuVN5jYqkTXDcNe7eGdt5ip6R319moG0gbERoUNkC0HIXh7esslMKZEqxaNjQ+TvtgPAeBmoDW8GtP4syYxzUAIcM880KT30MryhNhEG0o3bJ16vj3GlnA+y0cAyDlcpkHYH0WMGEuVaJSm04uOtRVGT4firVl3HNJmjH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(2616005)(66946007)(54906003)(66556008)(66476007)(6916009)(316002)(41300700001)(1076003)(107886003)(6512007)(33656002)(26005)(6666004)(36756003)(6506007)(478600001)(6486002)(38100700002)(86362001)(83380400001)(2906002)(4326008)(8936002)(8676002)(5660300002)(27376004)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZsM4jd+KwMTaKAkGN0fB9OJTumC6pvBDFRFcwxvG6uxnvvMYYXg2tRgcMMHD?=
 =?us-ascii?Q?wyLMUU4N0wI/mv7hbFExEdYW2t7IdNckMwoB5xiQYlwGXKJDlJVGbE7sPvuW?=
 =?us-ascii?Q?A0QTSUj/rVwIN1KxqLXQQxSnrQlqPSgBUzOhf7U+2gWsotPNXSGsSFdYK7EH?=
 =?us-ascii?Q?8wZ3qWmYtbxGHNSOtchFvgPkuXoaCURkqDXn9Kbku6DdKPJHt9X4qgEPML/x?=
 =?us-ascii?Q?b3qhsaFSfPv2jl23+j8QMAA27XeFWReq5yw9iCtQiwXUgXSXh2nycx2Rotme?=
 =?us-ascii?Q?TNtHqcs6yb0+1hMmDo4UEiKwRJCNEc/sTokUr+YtpedmfiWGve/jpVexGzSG?=
 =?us-ascii?Q?mpeCCZ7nEpnX2Qp/3TBJcICwYzEy9u5qSWc4grLpn9+yIU7G51caV/su3EiT?=
 =?us-ascii?Q?Zlf2Cp30v22kYET1Ar/m8kXDfwx7JcSXUp1HptLFligKd09ekySJPEZTuNmM?=
 =?us-ascii?Q?DLsy3YOIDPM6OHLqOGzyMDSrZsZropPB4oPfZirkzzSYAyqRa0PHKKBFz1YD?=
 =?us-ascii?Q?QS4kDUtcBw4Rok0aCq9tBPC2/jdNa2HAt4ezAF71BeQ7/GPIfHWXP7vRQmiD?=
 =?us-ascii?Q?YamfiN4auDG7fuVrT1dC8mi6F9NKwCYbdi4rJ05EqdsoeFrKAHmds90GR/eV?=
 =?us-ascii?Q?62hj+H5YvzsiMAhl++PijyfTgd7GFiGQ8HXmcYvZ8K0bZik7Ja54JE3cstL6?=
 =?us-ascii?Q?t4lUsRfnZ9Qa6yajciGsYelD54OHYVQMY1nVTmBr2acUFCOQj8SeZ+M87XUH?=
 =?us-ascii?Q?LEulPfehMwR3JCjXGxxhuTPle2Mm60pGUxtgy9UVHaTvD1SA8WGItrqDpzdg?=
 =?us-ascii?Q?1djT/fSs35KwVeJ91t9IW+wf/dwjeuhzF++ZNn5sPyHJ+5UxXo/Cbs3bE7mU?=
 =?us-ascii?Q?PkDwW/ps51OwSI3AvBsCp0f4YV3tMMWst5q8+H++UodCS0xvaIdwWiUZnkTT?=
 =?us-ascii?Q?oNrXZM3dhKk5hobuiI06nISJqsoXGlZEfuikd3n6PSjEqQXuNi2SDzLx4NEN?=
 =?us-ascii?Q?njnMKlA7bQ4k+D1eBHTonTF2fSPuBXZph8Y3tJkVosHVPjirPkG+47umWVL5?=
 =?us-ascii?Q?07dyP+cMwkRNeK/wwT/gKownQ7D9voB9TtAVUhkbbklbcKzqp6PBVx6p9t/T?=
 =?us-ascii?Q?QBqoiFBF5Ok7p0E+kqbKM1mIatiCdIaZFzAvRzMXBX0hZzvLLsWugWUzVBLG?=
 =?us-ascii?Q?WvPJsiSs02PD1RjhSSsfAehCrR6rd+spwn0oT7hEv2CJDzw/veVmiQKoTCHI?=
 =?us-ascii?Q?Hlw8WHSbPLw9kUCQg+ihhguyvrdE5FtOAYN1nopqcXmmgW7ZonjPUsOxVy8a?=
 =?us-ascii?Q?cMyYImSxCbY7e32gzqrOjzEWDI53DBG0DmdrnLhRWa02JAYZ6IpsmOPbPh+q?=
 =?us-ascii?Q?PqXyoMF+Iau1ntnArnVBjPzNr8AecZEOHf4PTi2xEWLj2ey/h49R8uDoXZlE?=
 =?us-ascii?Q?sl1ZAdnqjMN/b1J6P4iqBkidp+/LeEt4lwNQcc/oU6sHacQ6VXCuLeS8rh4P?=
 =?us-ascii?Q?abkfW3HSApf6iplkNUyBMpv9Cg/LlOQwhMQ0q9U7ptwGqB86bmR/EWRdJY59?=
 =?us-ascii?Q?PVQDGGTnwVSHbHuIxKZrf75klSp6wHjH3cZFbz/2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1f501a-7553-4997-7a92-08dbc593a209
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 11:10:07.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzPhgPjdCTvod2pX+/4dHUAv7DfN6BwOVTfmfPUFCd4pF7JEudc6LqrC6Pe9rN4D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6579
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023 at 01:49:54AM -0700, Christoph Hellwig wrote:

> But for all the augmented vfio use cases it doesn't, for them the
> augmented vfio functionality is an integral part of the core driver.
> That is true for nvme, virtio and I'd argue mlx5 as well.

I don't agree with this. I see the extra functionality as being an
integral part of the VF and VFIO. The PF driver is only providing a
proxied communication channel.

It is a limitation of PCI that the PF must act as a proxy.

> So we need to stop registering separate pci_drivers for this kind
> of functionality, and instead have an interface to the driver to
> switch to certain functionalities.

?? We must bind something to the VF's pci_driver, what do you imagine
that is?

> E.g. for this case there should be no new vfio-virtio device, but
> instead you should be able to switch the virtio device to an
> fake-legacy vfio mode.

Are you aruging about how we reach to vfio_register_XX() and what
directory the file lives?

I don't know what "fake-legacy" even means, VFIO is not legacy.

There is alot of code in VFIO and the VMM side to take a VF and turn
it into a vPCI function. You can't just trivially duplicate VFIO in a
dozen drivers without creating a giant mess.

Further, userspace wants consistent ways to operate this stuff. If we
need a dozen ways to activate VFIO for every kind of driver that is
not a positive direction.

Basically, I don't know what you are suggesting here. We talked about
this before, and my position is still the same. Continuing to have
/dev/vfio/XX be the kernel uAPI for the VMM to work with non-mediated
vPCI functions with live migration is the technically correct thing to
do.

Why wouldn't it be?

> Similarly for nvme.  We'll never accept a separate nvme-live migration
> vfio driver.  This functionality needs to be part of the nvme driver,
> probed there and fully controlled there.

We can debate where to put the files when the standard is done, but
the end of the day it needs to create /dev/vfio/XXX.

Jason
