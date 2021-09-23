Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E8B41684D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 01:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbhIWXH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 19:07:58 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:37866
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236363AbhIWXH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 19:07:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibt+0Zp/cUDsw42LKEBZ4zEoN1LE1O7oCmxOv4E3l4O9nnZCyt2gCVaVZkcxoYMms3QoPtWj0WWDKRxyBUepaOSFUVjxhFBeMtblQ91dW0scL00C/MzDeTW2nNMXWmr545gBa7FH2vvvsqDnogYeO9GVRwI1+2LFdQgLH5YqeqwyUWMZ59bVgjqubVMgizefEOPvMacOGwNLUdpCaSdnuwxjt3XdtC2doaLlW55pKUDk4wH7+nlGFb2uwhXgGSYmtgtCysjm+MXMJSHUiE+fBQ6GjrSGrWHVlrKB+efrsxELeDbPmcsr2xuFCDD9IvY8AnSq/Xr88XzD1DPu0to3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KaPvStTxyex03I+tpkcRTeZ+OLyfS+nZz/mDHFtQpwg=;
 b=XHMlKuJqYxK5DfPA3al8on0MLnnPjOiK/6+sQ+2vBWX8pfVIw+LjwQXFTtzG4mTmD5G5xC7WGDNwueahvAMyIvluP5Dl3Dqt8GIjfm2Zg52JVMq8n1OEMovMTnP0O5gOZZ90nUqD1XOcbML9Cci92O2zaAK6N2SJnFRA88TCT44ekGDI7nkbxwpL0qjlM+5VrKtmcnEQtb8pXJDZhfFxMvtbgsjeW7e+xojFXgp4bMWwVH85wBvo18RvdpCzKa2IjNHkq8H28VmyVN8Gpl7yqsoabpNNQy5ATEfQ2EqR2AaNDEcz4TBwDZnwz2BrXw921fI71cUEySeNu8BUbiAc2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaPvStTxyex03I+tpkcRTeZ+OLyfS+nZz/mDHFtQpwg=;
 b=osMlkCGKjy37Z7mFumBBfggFgyDRJVXHkqakw08yTfb7kMyRfbnloS1A6cOzQZCGz3qUglQq3eh2+FJaZI6Hz2NpdtKQ7J1s8p93P/U9WeVQmC8cNrFJNorxgZWQjDfXZSq24cbM9PIMJGNlhbsxit1JZeIVgpbm2h58/Zjq6Mwce8uyo1IYyF/4jNU2Z6B9Gwyton4yBOQaetIPeb8Yv/ZgMMbOPyrcLMHzijInrpjVB7lqYzhdiIFOPiSilMcjblwTBVEcMvHEte2fKVIXbWAHRmADXPvWTNqXZvSUghjulwW6EKIeSOrjHOyD4CrWRWGSXCIfQaqix7rdir2+ZA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 23:06:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 23:06:23 +0000
Date:   Thu, 23 Sep 2021 20:06:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Message-ID: <20210923230622.GT964074@nvidia.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-14-hch@lst.de>
 <20210923165924.2d8100ff.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923165924.2d8100ff.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0031.namprd15.prod.outlook.com
 (2603:10b6:207:17::44) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0031.namprd15.prod.outlook.com (2603:10b6:207:17::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 23:06:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTXnK-004cYw-KC; Thu, 23 Sep 2021 20:06:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4653523c-ac03-437d-f967-08d97ee6c364
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5304FE887677F539C6CBF33CC2A39@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7i6S1hdFpJM6NpGf0ETM9JY+vNcKUIervq7ya4iHmhnOKlHMSeYvpBKeXvNKw3gISP/uHVXZpXLJA2gQFHAQjqHz7Kl2mASvVj9l+2k9GixTwtMyXEUgpya8MSQgI+pYu6XFQL/TtxEg2PrU48WbWMCBxgjLKSDjsW/lu/y446J5Rm6Em+xNWstSIl8ACyVlEfQf/6lNO/Tw5AKl3/x5tTRnY4aTsof+vABQnAy/neYW20jD8IEKtd3pMZxN+msNkjPyXsNk0zGnhNweobUxWFeE0NkB7i01+F0eTYNQZ1ZbKnsaceFDlniapDCRxnHh1T/ljzqVwzF9L6QyejTQQBu3mERpqeSu3MlYEvhUQ7AdPlS8RAf1WQdnxrKwrPZS0Pp2M2J89WZpZR2AuHGEgP4NMo2fzWMzw6rCsQJFp5qtDCygrOM2v1zwjXccPWsni7Loz0r/ux858vMQoH1ctETossYbZpve7R47+14ExSinmRKvVBuOjCSUwzfA1lH+CmcfPoIYR8Ssd1nVl1Vo8I2RNaHySJOTdU8yPo3PNqvZHNTg5MrLCPzAwCKDfZ/Pp7HyrUBX9ape5g2WqqPa3Ud13VQu3Qxn3DLbjSnRLZYTE6WBYo5f5bOXWQFFnXYTaIuiPWw6zBnvCUBwbdNBvm3PqYlN81nCLuhab58HgF3hUXGkX6JjDd9WA4xEkys7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9746002)(86362001)(8936002)(1076003)(4326008)(4744005)(2616005)(38100700002)(186003)(9786002)(66946007)(508600001)(66476007)(426003)(6916009)(83380400001)(66556008)(26005)(2906002)(33656002)(5660300002)(316002)(8676002)(36756003)(54906003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZrGi7O6nNDBxHAf/MctUDrTbKUo1SQwXW8+vTtSN01EKZUnePnn5aKzw7Jc?=
 =?us-ascii?Q?5u1IJw87gUytkKZAxx/pzPCKaTkMG9JU7136E40b1NHyC+ukaY+QDmR7BTFB?=
 =?us-ascii?Q?eSatiVTACiJf3c+MluHZeoHp9JhT6ZNc77R85Vr4Rawowcc5Iy1FWMY7bLYO?=
 =?us-ascii?Q?vMGlwkzGC/6rnPl/KiPh45pi9f75+muf20LAo0IyhPeb8jQry76xYtFzBbNn?=
 =?us-ascii?Q?5ahdEmSsBv+OOVLNHF1hqevDEk7pVgwk28bem6apXfiZcvIv243PKTmKmBJh?=
 =?us-ascii?Q?neQfKuUar2V47ib75ATKluzxtmQmDxj0t+RkAgi27fmXU1G8OcruqfR4bX1I?=
 =?us-ascii?Q?72vDxckG80UDdkr7NX3Q05NQ8iZS1t0ueyPAooO1DeT4QP68GE5XUi4gLyLu?=
 =?us-ascii?Q?Zsbwee5N/W8Tnqc/q8Dd/RT62Y2vZxfuIRYqluzGhn+AflTr4/MXF7zvRyIp?=
 =?us-ascii?Q?oY60pdTDuL7t3sP3oFSrrPlNzNcSmf+BbGhhy/+6FSOVmg2afgj+OXihWwzF?=
 =?us-ascii?Q?yQW9Y3XRBrw6P1hXkOx0vOSYxwBFzz5HRK5iUW2UNfaB9vAXZwKt4QIuFpkK?=
 =?us-ascii?Q?hszLBRXe1J0E6ikH6Pyw2PunQ0FPiEzFNKJ328idbS5H0HXVMLPYYN8dZOLa?=
 =?us-ascii?Q?US3BSKMF6gGCbmok2q9fNN8veMx0e4bazcF4+DEVcyn7hj+rSmS3oDx7YnhT?=
 =?us-ascii?Q?nbubvwPNhOYcV0nCBXXachbkoJb+3XY2PMeY9Z2IoL7bVeUiq8l24rJFn9gE?=
 =?us-ascii?Q?g+21oLOWJhCGhbp/QQEGH6VPbJPYXBtsaMB67bVRlh/PVuZ66vBUXPiKzSJH?=
 =?us-ascii?Q?ARjuy52BCUfAHYPxfza4OULo5fjYdIh9hWmdJPrbZrziF494vuTVerGEJkTf?=
 =?us-ascii?Q?NdKnkqaX+nb3RZMadJ0CyJV8pAj3kbYhH6Dw4nDaUwP+jl4g+ctpef3yCpcN?=
 =?us-ascii?Q?AdNu5PCNcS6uAmja0QzafNSBhxWHY7MaCrvfLFaCrL66ixgPxkYhszq4xCfW?=
 =?us-ascii?Q?LIwKtKs/L7/EZR18m8drpDvrhsRZxIDIoiYxpelApj0fnmUcGAjs/cdbwNOO?=
 =?us-ascii?Q?0ZUVeqMdq2WiZX95XN7MS+5lklVBPppm0HAcpos4JA8XTUUDY7OFSFIpcEwK?=
 =?us-ascii?Q?qIUevaXhV4ufKW8rsJTYd7VOnWb/Qauv0NYfwflaqJytbsDVDgUMYtaNZS7b?=
 =?us-ascii?Q?Fwla1sRlKzMDNFIQ+CXUEGkgAit07fHvRQyGJE0XZzASfdVrygkw2iVjRItO?=
 =?us-ascii?Q?17pvGQrDB13r3EpAPAahs795uYxRwDwm0xDCqQ/lBTQP0uT/CFD6NJQqTvFg?=
 =?us-ascii?Q?dT6fh7tze3QF34bdM/qWZAnI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4653523c-ac03-437d-f967-08d97ee6c364
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 23:06:23.6642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nc8tfVEmayYWdajznB8ZZgoPx4NaFAeucQksl2wf2GT70aWRC1aG/HYnQSuqAHaj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 04:59:24PM -0600, Alex Williamson wrote:

> I think this dropped the call to vfio_update_pgsize_bitmap(), which
> would leave iommu->pgsize_bitmap = 0 for a container hosting only mdev
> devices, which leads us to undefined behavior when we're using ffs on
> it to validate maps, unmaps, dirty bitmap support, etc.   Did I miss
> this getting moved elsewhere?  Thanks,

I think you are right, but I'd suggest to add a call in
vfio_iommu_type1_open() so that the pgsize_bitmap is never invalid in
the first place.

Calling vfio_update_pgsize_bitmap() in places that don't change the
domain_list is pretty confusing.

Jason

