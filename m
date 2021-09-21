Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A44C41365F
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 17:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhIUPnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 11:43:20 -0400
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:63201
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234164AbhIUPnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 11:43:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mixHylHuImoarzezI2SwjCT59+ATn4WfJQTFN/IskG0FE0Xpq0TH0KkouTvv4UyamPjz64LKwMdivHazKDTlxeqrD6ImO9BT5HS1FLmltnrYk1Ew9VfhBahKNOTAxypBnQcQXJE2MVmMLpbX4qJbm3qQWKyCUqLjSqoVL1vaFocW13zdhfGbUp9P2rkXo1pTvfXR3SnpeauKSvlAmiYsllM3G3YoAr2dlID7ze0GBiqs4TUU+9dtyQRoK5+2LOC4bHVA+wWGvh8PDkwO6FfqvbuylNBqbTeS+v+nNtczPmI/2uzIJSDUgsX3NWVskbZi4DLoVrPuMXFomjZXGFyZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jIxSM94+E+xXvDRL1GTcsZbEjHR1uu6VEWmOspluNZ8=;
 b=ABxiVBzD6Ubmw8NhUUZaNOa5dlMZrXtR7+LV6tpm0e5uEuW6iLBuNCYSAwTMMUyVWCYwNNzTswsuO3GzRvqsgc40HLMzcZ8iTxT6BFlUJgwnGzquAtDO8JLkUdOkIADGKT7Zy0dLsK8GOPuYRrd3PGttw7udD2IsdDI983FsKh+vRY7xnZIcRNfuvotiwalKQzXy6iVZD8dNppa/3zUTWJF0UKZ667Eyqvd+UZKRa/GIsS3oMTy2eDurBVOKE8hzh4N21UnRXJtpOce/eVvvO2eZDJqCBL5jJFKcLFQqmz9H3ny3eHiVNpq5XVf6hOSXEiml/YKKxn+vv7BcRZNmRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIxSM94+E+xXvDRL1GTcsZbEjHR1uu6VEWmOspluNZ8=;
 b=tqbfp19BmOTrlk/qrR4+lX4AF/joojidzJUV5UwiQ2+djBbzk3f/5iNcVIR1zEgksaNgqNGKHpNsUO0nT/0Mu2ctLOzo+9EFUV+xIwjDsbn8Qf4vAaUl4IMrKWPbWqLsP9emNahxzdXWn1wDU17Ye7G6r+MuiSTfry3qXvgilmowg6F/ze66ODd8TXf4Q0wDnsyNo0ZO0JQdRtZIOuMhDROAsAM8yI+Ru5eZCVxE65NuBvw2hjf+Dfl2SQNieg+E1URnHq7bbWG+xA1NR6Xv0+smd5g93Ij+7iX3Cc1iawZrm+KD34p5cTLedDJxpGAS51163SKKaokjhjx0HEYNWg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 15:41:39 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 15:41:39 +0000
Date:   Tue, 21 Sep 2021 12:41:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20210921154138.GM327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-2-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0085.namprd13.prod.outlook.com (2603:10b6:208:2b8::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Tue, 21 Sep 2021 15:41:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mShtq-003V0Q-Cx; Tue, 21 Sep 2021 12:41:38 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed06cd25-d775-467d-601b-08d97d164d7e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5157:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5157537A91B1B36640A47FDEC2A19@BL1PR12MB5157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQ21ZTJKiLEmRGOZfLO6j4JGIEWBNlTBg+IR6dbMmPPYSi4uRjqtBOIOtyTB9TGzTt4CyDvzS00YL1k9O6gutxXzlAwOrSLL0VsC3EY1TgRqlS61lmHi5c1RQP31+DWUwZqGjSR7ozGjc2qCV7TKHf/M5BOR4uevNe9ovkA6eec1doPERaMark4fQyD5Micau32fRnC6/mOJldPfl7yaSOn4MW4ypvrjjBBDXQr2vaHwdZrkr2CGwToymfgdm7tSwXunseG/QALkaizxHPTT6PgcmuHcvjfkk6F3m/baoS2th2ybKHKv+mzSqgpMV0DBQxW4LZeiSk7K+MQPhjQlkLY/o5WkwufZo+g1zIDj3aFpUsleazqjL1WcZsi0+gL3wJXjMU2tbvvFc8XIwGaKkcWW9cueSPse2SkwVYFPJBXedQbwLQ1xSUDE8NfVglELSCig3mKLHl44wbqjnka6N1XfbDYzbmP0Ne1qLMPk4ldIerCiQWMzjhrERXTz2MqIoGtpp1Bs/qomRzl/okVTDem+6RYF6/qz0xfJrU90JH1dYmCUAtO5pqP3R5nnO0EQLE0Ss1quwKtOS3KZqOvU5coiNIfFIL9H0ctSU9zXTa2ZKzMhUyxf3hkpLska4oxzf4wXzer9PsY3HqnJDHlAoGp1DlIl7xhdfn2YlBR0NP+GLwUsX6W4k0K7/dDOE2+3b0ikpMS3InErUYneQfvBdnXK5GxJoAKzOEePwIkaPlFJ0+2hfWb6uaK3BZ9j2Buj1h0E6I1BzE0N3VcJiM22SA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(26005)(186003)(9746002)(107886003)(5660300002)(9786002)(966005)(38100700002)(316002)(66946007)(66476007)(83380400001)(33656002)(36756003)(508600001)(1076003)(426003)(8936002)(66556008)(6916009)(4326008)(2906002)(2616005)(8676002)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p4N2/kzxcnNYCLp14JKx30+zDbWg/6LdFh+gzZEuNGShGswxuFwoqz8M2Haa?=
 =?us-ascii?Q?FNURdHYZobsbjzXCnX7EbSaTdP3D9/1mSkcY8NHsTn4STFYfooeeiTGS0DQE?=
 =?us-ascii?Q?WnLqi0UIfSWWMvom+D9n3+JsiErfjfcXLwVJxnAD4mPGHSCNhKLUvZED23YR?=
 =?us-ascii?Q?C3u2VSRB5MnXsS408lRjMohKN6Y/1PKyjvGjPkWKUNcoCFcfGnbhOPklRAlf?=
 =?us-ascii?Q?ZIA7BdyvfWzhjkDl+nACbUaoTnfjPzM4418LadEeXww/rSmkuYQdVF/AMUAW?=
 =?us-ascii?Q?sGic1OcqH7MaPWyp1r/4ZSHTUErmzWswxNYmCz1d6jvGqt/HHPYOaqbQao3E?=
 =?us-ascii?Q?zP+MAtIXmxdhegeLwUbR6iOrQrB/1tsZc/5tMUPYtO9t34iBCBUEjxf46TXN?=
 =?us-ascii?Q?BueEHV6NT95nyZgvgZWzaJxNqI1VKIRwNSBw7g2EFRbE7Jm7LYbycQdfQwcU?=
 =?us-ascii?Q?DjdINhcNsxhHwBWL98EmS/wLxXhQTuZPtbhAwvWqGN+j/UwKYi0HVuWBioZ1?=
 =?us-ascii?Q?mJ1P5uyg0Sgw0Sfk2sVr1xpKIRS2+rUuU2evqvu6kbgCpG9HX3a42VGTXk+z?=
 =?us-ascii?Q?s/G1NsbMGu87WJN7l18XdqRSvYsBea5u2XDgE19drjnXr+GydWCKAkK/6OqN?=
 =?us-ascii?Q?oKVhB51fg7XBQkNergxfWt8w4dAiOE1jOnAggNLSyFWuMqVuQfGwUqrcDBHU?=
 =?us-ascii?Q?qaNmwGu6GoMqxxwGLdZ0/Zm663JUp0XYEPmQaow1KQanWerON0IfRqRQYXmD?=
 =?us-ascii?Q?iJh2MJwLiooffL6uvCTS9dauE6TdDLKlwLW5KCUXPdrmUFndQcZJshT6JVvl?=
 =?us-ascii?Q?OxZXVdw4QMSHVOezm94lL1vIyUJUymItR2oYsvzNeTTzmeCA+LtI9kIMSCJR?=
 =?us-ascii?Q?PHAnwcB0EFKPj7INZIZa6GTWFjdWJ2XikzqDtfvEL11KQJuKVAKs4+K52nWW?=
 =?us-ascii?Q?5jw4vg9Ub64Vjq9Twz4ZK9OJCtyF+yvFWDbVDerp3rjD2D/X6HSzqmYnt4Ts?=
 =?us-ascii?Q?tQF5YvYEwO+L5MuPCutrVHVAGIb5cBgqaG7UIqzZUUgaHOknetQ3UfgDljur?=
 =?us-ascii?Q?XjHVq5A5L+eGqG0qgRAQ2O7IwnJXYsbTPwg7tV4Z3FEVzP68Gjf6bYFEBxR6?=
 =?us-ascii?Q?PlNnOKshcnCCwnU/3cNqyAPzndWNj2qrrje4XvYYZGE38zHZCxqyZ/En7CYg?=
 =?us-ascii?Q?Rncc6DKy4iws4pHF2vXJb0lnaGlczRN5GrejQjBJ4R5malQ6DuTem97wLnbh?=
 =?us-ascii?Q?H+IHpqHJz1f+NHmoK627U1Rr3gm1k7SNADE37hr8+zDATMVQmJmb8DLqlbW1?=
 =?us-ascii?Q?BKb4qbej1uVxMF0ZChHKoqjw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed06cd25-d775-467d-601b-08d97d164d7e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 15:41:39.5592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wyRo61G1sb2p5FbKlgXnyrGsnuKUSlsxXps6w5QG1wpGaclcumki2ZqCUToUgL3E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:29PM +0800, Liu Yi L wrote:
> /dev/iommu aims to provide a unified interface for managing I/O address
> spaces for devices assigned to userspace. This patch adds the initial
> framework to create a /dev/iommu node. Each open of this node returns an
> iommufd. And this fd is the handle for userspace to initiate its I/O
> address space management.
> 
> One open:
> - We call this feature as IOMMUFD in Kconfig in this RFC. However this
>   name is not clear enough to indicate its purpose to user. Back to 2010
>   vfio even introduced a /dev/uiommu [1] as the predecessor of its
>   container concept. Is that a better name? Appreciate opinions here.
> 
> [1] https://lore.kernel.org/kvm/4c0eb470.1HMjondO00NIvFM6%25pugs@cisco.com/
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>  drivers/iommu/Kconfig           |   1 +
>  drivers/iommu/Makefile          |   1 +
>  drivers/iommu/iommufd/Kconfig   |  11 ++++
>  drivers/iommu/iommufd/Makefile  |   2 +
>  drivers/iommu/iommufd/iommufd.c | 112 ++++++++++++++++++++++++++++++++
>  5 files changed, 127 insertions(+)
>  create mode 100644 drivers/iommu/iommufd/Kconfig
>  create mode 100644 drivers/iommu/iommufd/Makefile
>  create mode 100644 drivers/iommu/iommufd/iommufd.c
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 07b7c25cbed8..a83ce0acd09d 100644
> +++ b/drivers/iommu/Kconfig
> @@ -136,6 +136,7 @@ config MSM_IOMMU
>  
>  source "drivers/iommu/amd/Kconfig"
>  source "drivers/iommu/intel/Kconfig"
> +source "drivers/iommu/iommufd/Kconfig"
>  
>  config IRQ_REMAP
>  	bool "Support for Interrupt Remapping"
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index c0fb0ba88143..719c799f23ad 100644
> +++ b/drivers/iommu/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_HYPERV_IOMMU) += hyperv-iommu.o
>  obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
>  obj-$(CONFIG_IOMMU_SVA_LIB) += iommu-sva-lib.o io-pgfault.o
>  obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
> +obj-$(CONFIG_IOMMUFD) += iommufd/
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> new file mode 100644
> index 000000000000..9fb7769a815d
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config IOMMUFD
> +	tristate "I/O Address Space management framework for passthrough devices"
> +	select IOMMU_API
> +	default n
> +	help
> +	  provides unified I/O address space management framework for
> +	  isolating untrusted DMAs via devices which are passed through
> +	  to userspace drivers.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
> new file mode 100644
> index 000000000000..54381a01d003
> +++ b/drivers/iommu/iommufd/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_IOMMUFD) += iommufd.o
> diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
> new file mode 100644
> index 000000000000..710b7e62988b
> +++ b/drivers/iommu/iommufd/iommufd.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * I/O Address Space Management for passthrough devices
> + *
> + * Copyright (C) 2021 Intel Corporation
> + *
> + * Author: Liu Yi L <yi.l.liu@intel.com>
> + */
> +
> +#define pr_fmt(fmt)    "iommufd: " fmt
> +
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mutex.h>
> +#include <linux/iommu.h>
> +
> +/* Per iommufd */
> +struct iommufd_ctx {
> +	refcount_t refs;
> +};

A private_data of a struct file should avoid having a refcount (and
this should have been a kref anyhow)

Use the refcount on the struct file instead.

In general the lifetime models look overly convoluted to me with
refcounts being used as locks and going in all manner of directions.

- No refcount on iommufd_ctx, this should use the fget on the fd.
  The driver facing version of the API has the driver holds a fget
  inside the iommufd_device.

- Put a rwlock inside the iommufd_ioas that is a
  'destroying_lock'. The rwlock starts out unlocked.
  
  Acquire from the xarray is
   rcu_lock()
   ioas = xa_load()
   if (ioas)
      if (down_read_trylock(&ioas->destroying_lock))
           // success
  Unacquire is just up_read()

  Do down_write when the ioas is to be destroyed, do not return ebusy.

 - Delete the iommufd_ctx->lock. Use RCU to protect load, erase/alloc does
   not need locking (order it properly too, it is in the wrong order), and
   don't check for duplicate devices or dev_cookie duplication, that
   is user error and is harmless to the kernel.
  
> +static int iommufd_fops_release(struct inode *inode, struct file *filep)
> +{
> +	struct iommufd_ctx *ictx = filep->private_data;
> +
> +	filep->private_data = NULL;

unnecessary

> +	iommufd_ctx_put(ictx);
> +
> +	return 0;
> +}
> +
> +static long iommufd_fops_unl_ioctl(struct file *filep,
> +				   unsigned int cmd, unsigned long arg)
> +{
> +	struct iommufd_ctx *ictx = filep->private_data;
> +	long ret = -EINVAL;
> +
> +	if (!ictx)
> +		return ret;

impossible

> +
> +	switch (cmd) {
> +	default:
> +		pr_err_ratelimited("unsupported cmd %u\n", cmd);

don't log user triggerable events

Jason
