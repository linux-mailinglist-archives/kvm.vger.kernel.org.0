Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADD939E738
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 21:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFGTJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 15:09:57 -0400
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:36288
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231424AbhFGTJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 15:09:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8xBY6+S6/Xejnp2TFKSTEj+nLVOExso5dhDEriXILk9aidTRm2DcLYnTzEtcKG06B4RGV6KC24/kw6pMaY/KcLb0PJH6SrKoY4nRHXUBWdWP0hnRHL6sQNuhk+k7CvEIBXAWjykiiP8vk8WWEpQ7EHovMRmgN+YTqi142eOAW6QhAdJEiWZ8YmKExd5Fqg/nA2ALkWhC8Kome+QmXdDy9vocDiABkQCZBDwuBMbPwAxkODCe6IIplt5E0wc2XAv496BRW8ToYK7ES03oobJIsVaFi+QL9fzJlItxW1GTV7t5+Q/+EI2AF3jA5lqogX+yez4hEKvSa+gc1cWqMXJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuaHi4Hpy5FeWArPvXOevTmSZrN90JFd6S3gW+vJ4Us=;
 b=oC2L0AvLc1Zvs6+uFCVLemhF/8sPPrqXx4SReJQC02zti/c1Iap7GdnFnZKSJE/b1GqnhaLXbwu8GVdG8CrUpkCjYWl0qSOXimJ045CKurV90s9jbk7csI/GdVzzE4248uj4k44hPjyru4IOgb5DwlW9Cap18zwIVu09kUrvIbCsySI/JVfAE+LlwBDP5/XGFTBGQFsKoHZQaWK9RtgvKNqx65qNJxM780rxgG26PZPaYAFuU43k3eUxGU+ztZmsS3Zko/Zp8osVy4t3tWKdyTnczPFpzLs5YAi1ZHcqHh4yrmfbAdfZo+1BevDNuXTFYz7vkhpwK3OLGeWx2yY0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuaHi4Hpy5FeWArPvXOevTmSZrN90JFd6S3gW+vJ4Us=;
 b=SxvdYw9rlJH9qruFMhkP72mLGP7r7a7dDc03cU+neZjk6KIA6M6XbxaEf04KodFayeFeHvBYaxfgXhTQXbu1P/xReRjj3IuzvRDIEkJyGf21VI6VXtEfsEsZ+sj/GoQJX046VNskeFsKUEB5DPkkzfOOKR73m8ReRQd3Yx4y0MDWYnYB4KfGOlIwTX/FQd6mDuIvMDKpdFVj2lsf8aYY/RUR3CnjktoSkNgPrwMWWcTzBMWCaVt0ZqZmCuwTQT+7KumaMv7lhnUKbniTWe+soTe9zkfXxKn2PJj/NX4S3ccOOV3ohfsvhMELar8Dmb8WY7DtT8j2V8vxiULzsrVRNg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5125.namprd12.prod.outlook.com (2603:10b6:208:309::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 19:08:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 19:08:03 +0000
Date:   Mon, 7 Jun 2021 16:08:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210607190802.GO1002214@nvidia.com>
References: <20210604155016.GR1002214@nvidia.com>
 <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <20210604230108.GB1002214@nvidia.com>
 <20210607094148.7e2341fc.alex.williamson@redhat.com>
 <20210607181858.GM1002214@nvidia.com>
 <20210607125946.056aafa2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607125946.056aafa2.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1P223CA0004.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Mon, 7 Jun 2021 19:08:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqKbS-003Q1K-PO; Mon, 07 Jun 2021 16:08:02 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21ea0d23-1f83-4f46-b0db-08d929e79360
X-MS-TrafficTypeDiagnostic: BL1PR12MB5125:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51257261D46FA69851D01B37C2389@BL1PR12MB5125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XbxrB5H2J9DrAZ28X/908WtZ3+WFCWi55CnyGXoqiXug1B8yv8uvK8kg9gzDZ+Hq9klzVdeoVBjxlUMLDc1dYZbLmKgbOwXi/r166cBvPEIxVTVes6Ha/ayd6JeXlz/c3b1oYpXY54cCfsZO2BGTMyZFMzsaCkcwyjvQcvH0PMUHTFu33zU7k4Hhd2e1CpA+70CsL4dimzKj89/xyfBL9B85gfr3n6xKliIEh9iarfBQlY8Yr+wikO9g/jwP4foJG6ymwLJA5Wt7DFn/82xnd8xT5DpCYWy60v+waFPTr+npnLCwJgll7nd4ycXDETedMLyoTiqH+1l5Sok87fhOYTCADTZ5DAiJP5K4CIcWzHjurUQ2vU/1KMMQMIHPTZiEhyzAXqM+ey0mQOAfMspM1m0XFaI2rb/fN+8bamU4+rRMLDoVsW7Zx+AL4qwn6TPSkGSwUFXEMhHGE6L7aECgIzfuytP5aA8rJc0XsnfKCCDDVIMGhByMojKNsr8mwOERUr043NDRGl3Z9wPTs0V30BjAFXG7QT/yJI/xH1povk1gY18QRipryFdS/wple5pAiP6H8WI4a0QMahvjLL9eD7Tc6hwdIBSb8VkjOac5COg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(4326008)(54906003)(1076003)(316002)(5660300002)(38100700002)(426003)(2616005)(66476007)(36756003)(83380400001)(26005)(186003)(8676002)(7416002)(66556008)(8936002)(6916009)(9786002)(86362001)(66946007)(33656002)(9746002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S7xRadJwX757Ze7fh0C51RL+b+/tt60MDTXiKcInkqzOhuu93GsfUjC4Z5i2?=
 =?us-ascii?Q?JtW4WzZd3D3GXZrNwq/ieQSnaIOTI9E8xLQfZpLOu5z4Hpm1a83LVtNvwWBt?=
 =?us-ascii?Q?7fFzENSlj42fE48vsko/2Nr9DGdpS25xWzMwWG+hCbyFRYL32dOZ/n2QjYnI?=
 =?us-ascii?Q?5cDWek/ojX4HKXAkg4kBTEspiZ5oZoA6/jWKEy4VIqmdtgyKUFXnVqU0KaXK?=
 =?us-ascii?Q?A6wJTWSU138GXOxfkt8A9SRe8HpFVJetnss0m0Ix+N7CTHQAoPdi9KC+n9r2?=
 =?us-ascii?Q?P5IrjQRlbGaTpFuLUu1jjJo0P0buA7ruxumYuiUEWxs1fOiUsOYl7j5kdY72?=
 =?us-ascii?Q?Z2iBF2UbuVzYBnUllgDc5Ob9WT9Z1oSLbDIs1YprLffTcJLSvgPQhfnSiQ+V?=
 =?us-ascii?Q?ngP16WPWxvTAR7ksCs38waxyvJjb+3Py6leIFW+HcxDYrEP6dy8bWC+uxMiT?=
 =?us-ascii?Q?THTM+5XCZgKzKhMYu409YUUgJ3KC1PsX9zZrqjfj3g0a3yLxHNYRAyPWlVlO?=
 =?us-ascii?Q?kiFgFfLQZnqUHGdrWRzlLNn1NkVUL1hvvmOaY9B0tDgAFgjYoK329AdFkBpF?=
 =?us-ascii?Q?7k6Q2Gn+Hlwhr37Qe98WQlfEkmTHOBPZ39TvJ9CQUUKRvDiAyjxoM8BNqJHQ?=
 =?us-ascii?Q?WXmXKCb6LVlLiZDwg9JWIufgqpO/dgCdcdVkZPuZYEYy82nFp00QagcCBgF2?=
 =?us-ascii?Q?JCDcxMDogieBwY1pdQGgWPcXnYmRGENZzeafrpIcpo8ClkZclvQXqL4cgB+C?=
 =?us-ascii?Q?qhKRjAWoCcKrjo30fail0piV3g5txUs4exZH2k2qR3F63IqQYOsT04cCjcKj?=
 =?us-ascii?Q?pzf1GBxADjtEJCyxtYU1OZufhHaxaI9xsZWBAMQxyhhsLoZJNLFpn9O3rL/C?=
 =?us-ascii?Q?O3QIgWk5vN8n0wVjSAYbL/GF/25o3wF+QHnraqi76jlcRrfVqldoaCyW1Ca5?=
 =?us-ascii?Q?MlnYJxRPLplmSX76bmYdt4G5mwgJnFMWXZzGOmi3cgV4M1p6iCYaUGkUGkjy?=
 =?us-ascii?Q?PRmWlLSkQltOw+M2e1C4IklrRhfB5z3ejRs0pgHXkq8m/cwT6eBVVU6GvfPM?=
 =?us-ascii?Q?nzNt8vOI+yID7+I6WZqQ72ExPsrhe1Rp8ne0SBVQpgr5kLF4teviDRT/eq3n?=
 =?us-ascii?Q?zWwQXUGiw+9chSE6dcaX1f5IQXJ5XRJno4s4ZcBOYaUzSKHecKFT7S2mqVsa?=
 =?us-ascii?Q?ev3g6VUegFqUyOQ9ZAphlQjAHjVFT3sp167IJAFpynbIrXY69BKfDxuJZ62d?=
 =?us-ascii?Q?oANWfMcQNL1R3w6BdwnZok2mAB9N7s/EoHu2jeG7u2cBoHUNhXHapJzEEmMS?=
 =?us-ascii?Q?rIMnHEzJFKmaA85YxVsJyDnP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ea0d23-1f83-4f46-b0db-08d929e79360
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 19:08:03.8349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXVm9rNdKrqr1JhYHV8u0ECc7sFD5a3F/LOaD9kfiRWYvFrU94d+bSqq81izCqMr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 12:59:46PM -0600, Alex Williamson wrote:

> > It is up to qemu if it wants to proceed or not. There is no issue with
> > allowing the use of no-snoop and blocking wbinvd, other than some
> > drivers may malfunction. If the user is certain they don't have
> > malfunctioning drivers then no issue to go ahead.
> 
> A driver that knows how to use the device in a coherent way can
> certainly proceed, but I suspect that's not something we can ask of
> QEMU.  QEMU has no visibility to the in-use driver and sketchy ability
> to virtualize the no-snoop enable bit to prevent non-coherent DMA from
> the device.  There might be an experimental ("x-" prefixed) QEMU device
> option to allow user override, but QEMU should disallow the possibility
> of malfunctioning drivers by default.  If we have devices that probe as
> supporting no-snoop, but actually can't generate such traffic, we might
> need a quirk list somewhere.

Compatibility is important, but when I look in the kernel code I see
very few places that call wbinvd(). Basically all DRM for something
relavent to qemu.

That tells me that the vast majority of PCI devices do not generate
no-snoop traffic.

> > I think it makes the software design much simpler if the security
> > check is very simple. Possessing a suitable device in an ioasid fd
> > container is enough to flip on the feature and we don't need to track
> > changes from that point on. We don't need to revoke wbinvd if the
> > ioasid fd changes, for instance. Better to keep the kernel very simple
> > in this regard.
> 
> You're suggesting that a user isn't forced to give up wbinvd emulation
> if they lose access to their device?  

Sure, why do we need to be stricter? It is the same logic I gave
earlier, once an attacker process has access to wbinvd an attacker can
just keep its access indefinitely.

The main use case for revokation assumes that qemu would be
compromised after a device is hot-unplugged and you want to block off
wbinvd. But I have a hard time seeing that as useful enough to justify
all the complicated code to do it...

For KVM qemu can turn on/off on hot plug events as it requires to give
VM security. It doesn't need to rely on the kernel to control this.

But I think it is all fine tuning, the basic idea seems like it could
work, so we are not blocked here on kvm interactions.

Jason
