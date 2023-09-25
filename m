Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF07AD7F5
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjIYM0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 08:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjIYM0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 08:26:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0756C0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 05:26:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSBb0Hl5XtrqgSibps6u2D2nuBmfDoBUUn8jpRLsuYys8ELEtRmEcluigtsG0R0J3Gw6q7JA/gyMD05cGNWLD6FyFnC8j680QJl0jpuex2NFlKyjmtY3psf3EIOoPnBZZh1Muh4MbHPFYqg+Cgc9NSIj22yhEydJtn4eIAkK5SUwg1aVBe8YrAzuzuS4VuMd314jzbT3wYIomr9CeNgj/k6ksmOA1yDAbmyn774sIU91du15vhsuQLZHHkfdEBHfVa1QKnvnb/7AGUCm2n2Qf8Nzwx71dud3k2qhIfus8WEWL8fzvYg+3jK7FPtomLXjrOQVMQM1G2w1qbnnv7YJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIFjrEiXmTZDdNg6HkvVXa9nUNCaUoWzPGq2BVq5G+k=;
 b=OXlT4DCHof8zWqcdKW4t4O8f8bdvCF8/0w+SAYcftIkw/i2gt3YJ9UwNWWVUa3whAoANMQS5dBRJZjURFgzuXxWO/73VYrAqf5snQtsF/UXCLX1TqVsitSJG39orxm9C2tn9zd4u6UO1QEnlIqTqOszhnpZBTX59Cb4NhLSKpTjVEZvj4JRGIB0HAufzu456Wu0UMQSgNh5C48Zb8oQARdOPZPIVN1sZxfCx9GuGJkhU+wFd+Tj3Ky+KxY4H2VoG/14g6dsqYjJjYzvJ77kiRt9FYfToJIX38EUMPOlfwa9jbehbpnSSvFMR4JX/+/+PtoxcTmwqshBDe5ZcIpn30A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIFjrEiXmTZDdNg6HkvVXa9nUNCaUoWzPGq2BVq5G+k=;
 b=ctRa1eMRRptZvgKn+SqRjLYhPCPRy/KE0S3IQR4Z6VDNJs6skuqkV1PbkpJrZSkx699o7V6L3GvnHTj1czO8hNrm4lE1JN7CLvLJz0H0gfwyxaFixWOIqzmf8Vj7rF5xTM3GSz6cV7z35nMsT3l8ti/n0lX3Z048orjETlkoU6XlwpCqWzMHhYVFt+/0PdyfDXzyKYgn4fFT0DDutmh84aGlCqDzWWTvW+GAJy7otWme81LFNdrNy2iaQON/I0H9i3DLGlLPQrCpH1KEQ8UAhrgvhbpb0vYK+BpRFp9WzZu+7Q7x7tK/Csv40CxbE3FSDKm4Kzwi6rhg8Ki7h9HhdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB8429.namprd12.prod.outlook.com (2603:10b6:510:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 12:26:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Mon, 25 Sep 2023
 12:26:08 +0000
Date:   Mon, 25 Sep 2023 09:26:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230925122607.GW13733@nvidia.com>
References: <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0264.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e5142a-f5ff-46ae-87a7-08dbbdc29886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5YwtFS/d+A95AvOwyuKnw3t/moT9n8haz2+LNUyKjhQw9PbOskqorlhCx/FEmwPuBzrr0sO0KUCMycIP8G1xcqGEekGjOwgxMWuSSX/5m9sl9qgn06wN2rQjJVCmCVLqF1cAqmXaHeRA4GHHYgYhk62wUw3gxoIJ5ibcIJHL5iP5H6sq0xVb+eMj5kIKkXk+9LvS3/M8HAeRBP63RFlG1XYEtcbby2PbiX6syFIJ1q6iqRoF/nT6f888mnHrj+YGpdpEI9pDV8kaGdZLWaQzM/rbbmC+xxUMPd59XflfkfDstqT0uBwApRQItEpnpOHuJLXKEFLfdYbxnbAV7fFeFURHCQ+kGBbZKCNsc5NS1XNZ1NQM2g9H/EYyr3IKWXOFGEHJXZlb9MobF7IGF1eOfWHjOXliXgxVBRj+2P0Ex4H3QC3MOhHQWngbmu8xmHOyJe3a0EP7riH/nvO1gzg6VqjBhBFI7KwsBcFzttr1lnDxRmrHaS8HHv2uWz+1B0DQNuMRim5a8F/1Cgu3CDHi+2vCg5nnxlkcgZjMmFQe9ZSQiL+y0/5d39eA8H3iNDu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(1800799009)(186009)(451199024)(2906002)(478600001)(6486002)(36756003)(26005)(86362001)(107886003)(38100700002)(83380400001)(1076003)(33656002)(6506007)(2616005)(6512007)(8936002)(41300700001)(8676002)(4326008)(316002)(5660300002)(66946007)(6916009)(66556008)(66476007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aDFHa5XJ8mQVxlTYkGhBOTs8275pBd10/97lkkSvu5s1pfkWE5c7BxaLVc4b?=
 =?us-ascii?Q?uhYXnkkhDLaDaGEr1yVFqc+kAS3XdvsrUt5dhy3m2l4wVfht8X5Y4Mvg8F6t?=
 =?us-ascii?Q?wiKx6damZJGCifgldpKirVknphiN5eD5yf1mb8t8GctvXy2Q48BX/D6d2lBV?=
 =?us-ascii?Q?pXbYaEjhnA1E1wxh68GD3zVipuNX5jg0amVVEHUroOP8VV81N4JzYNIquLeg?=
 =?us-ascii?Q?22O4bOeOYvrdH87RbOB06LderBSbdRDsyzVQTyrbPwdy+J0CqAr56miUS0mE?=
 =?us-ascii?Q?+ISByPkb6YoVQL2dbInchCtM95XZci2TCKgkAABIguOoCunvB9W+Nrpc5l3O?=
 =?us-ascii?Q?RLSQkxxK1tYINzGOpMj1zUSZQHYXoWwmmXX5bmVYK7xnZdJyKFFSDFDL59Cg?=
 =?us-ascii?Q?++Vfc4j+xSXM45oPMXPWCVAs3Tqyy7ohZoMku6XzpMNpo3iH573UZzGKNYYC?=
 =?us-ascii?Q?by6/hgZ7ujMHs2RkJhXUdLFLn9uQebUBtWuMyzxiuxgnGo4WgzhXA37ME9C1?=
 =?us-ascii?Q?26WdilgAKtPXXPFkRuL2OasajiyZ6PXUmLFXoG3Ur7vpvvd6j3U3+MQLyHQc?=
 =?us-ascii?Q?zxoM492IokvQOUSq1hXBX3ZyxaqGZJWiGXurRwdz2KUkWS2qO/mQRbiYwA1T?=
 =?us-ascii?Q?oZX/yp1s4CWgEsuQ8RMML822WTu6k0bnbk1p4eisRtyU7WXvSPefcuPjUJOc?=
 =?us-ascii?Q?jbgYcYB6HivoT+1k0696t1QYnwzDrcEiyCs2XDeY8yO+nubRth1+YUCpsLUO?=
 =?us-ascii?Q?gHAOg4L29MAReCxbCuTuR4Lc/FubfuLUyjZU8Qqu2At29bRQvhaj1S0ezuwO?=
 =?us-ascii?Q?eQUY9mvuONv7dm4RZnJaAT2aWKbTIma6qYDwGaXAQ9e7KsYbkZEnVfymIvoE?=
 =?us-ascii?Q?qgv52llOv3tY4dPWlmhbGJ0REkOTADNP3V8OLOaBQ7thws+/sHDP1+CgfJk3?=
 =?us-ascii?Q?HZRx7goN/X1ZOnq8bArTvCAvbnQVjCvm2Hf7hR4zSf3XEpep/qf/IfLSWoxT?=
 =?us-ascii?Q?bG6/eJEtjnYlMH6vRa7TNhzEZqwwdF57G/cnzSQ9AAGC0olD7wisq45TNj7U?=
 =?us-ascii?Q?cfiHL34HYCm3KgeFwv5PCsIxPjBsPdgjKl/B1S/hGCjoczMbfTATr+H8kljN?=
 =?us-ascii?Q?Rb/OzBhJGXvqlizvLv+GDEwYsENDic5DxhwUAupgXNoJl+sOJhiuQN2wG8C0?=
 =?us-ascii?Q?Q7ejDX6PdUJQbTIQHTVtzZ4Oj/HZXxHUD5wgtkg4u2CMtIt62sQQFP+Qq3Pf?=
 =?us-ascii?Q?aQz6RNcjB3kRYZTtU8jyXSWPESP2aRPok9aybw3OerawBshOpAGcASkd6fMX?=
 =?us-ascii?Q?qlLhfngRwbHgZGWPUCC5Gr9HfeQt2FcF8RRk973P/Yt8LT7asHqhZPsyj+kw?=
 =?us-ascii?Q?M4+p7yoUr1f24ymX8O4s5hgIeeqHAmBP5a3Hn/FLOiqZV1vltcxYoqrRvWH2?=
 =?us-ascii?Q?EC86dhLHtYGJsUzn8bUc4Q9UCNgTV2/s6i6MoLm2JKluJ5Q4nCwNx3c94tvy?=
 =?us-ascii?Q?ZQ5nXqOWotY7lWAWG80+GcNny38WyoRI864915vCK/qkYWjKX43SAzlqog7f?=
 =?us-ascii?Q?3Is2UjfCSmFmQTcu2/U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e5142a-f5ff-46ae-87a7-08dbbdc29886
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 12:26:08.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rh9x512++6QF9MAfbjTVyqPyz+b3iowM20anHDzB4QDPvyVKcYnlE+tPhb9wAVyf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 10:34:54AM +0800, Jason Wang wrote:

> > Cloud vendors will similarly use DPUs to create a PCI functions that
> > meet the cloud vendor's internal specification.
> 
> This can only work if:
> 
> 1) the internal specification has finer garin than virtio spec
> 2) so it can define what is not implemented in the virtio spec (like
> migration and compatibility)

Yes, and that is what is happening. Realistically the "spec" isjust a
piece of software that the Cloud vendor owns which is simply ported to
multiple DPU vendors.

It is the same as VDPA. If VDPA can make multiple NIC vendors
consistent then why do you have a hard time believing we can do the
same thing just on the ARM side of a DPU?

> All of the above doesn't seem to be possible or realistic now, and it
> actually has a risk to be not compatible with virtio spec. In the
> future when virtio has live migration supported, they want to be able
> to migrate between virtio and vDPA.

Well, that is for the spec to design. 

> > So, as I keep saying, in this scenario the goal is no mediation in the
> > hypervisor.
> 
> That's pretty fine, but I don't think trapping + relying is not
> mediation. Does it really matter what happens after trapping?

It is not mediation in the sense that the kernel driver does not in
any way make decisions on the behavior of the device. It simply
transforms an IO operation into a device command and relays it to the
device. The device still fully controls its own behavior.

VDPA is very different from this. You might call them both mediation,
sure, but then you need another word to describe the additional
changes VPDA is doing.

> > It is pointless, everything you think you need to do there
> > is actually already being done in the DPU.
> 
> Well, migration or even Qemu could be offloaded to DPU as well. If
> that's the direction that's pretty fine.

That's silly, of course qemu/kvm can't run in the DPU.

However, we can empty qemu and the hypervisor out so all it does is
run kvm and run vfio. In this model the DPU does all the OVS, storage,
"VPDA", etc. qemu is just a passive relay of the DPU PCI functions
into VM's vPCI functions.

So, everything VDPA was doing in the environment is migrated into the
DPU.

In this model the DPU is an extension of the hypervisor/qemu
environment and we shift code from x86 side to arm side to increase
security, save power and increase total system performance.

Jason
