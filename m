Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5223F228537
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgGUQVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:21:12 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:19678
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgGUQVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:21:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGUPmm9eBQilc9katYLS5zgV6gHYIk6HdnDB7LJIy0flNwoSisTHEqQNTefWzxGLQzPTRLXuIvKCWmuUges1VqY7d3tsaRS+M/HoK7QTAOUbRE9ZgwEik56s03tleNJJd5Hq4l1h5B7N13mQ9DGRrYKmfYzJNOSQ4f0yGy6C1NJ6P56yQH6juW0WjlA2fHqtSiWuFSae8U5G7xw1tn8kE4R2ghZJT5jhXCPoa97aSlXiBYRGof33B2VUUfbOFf+mNzeHzEdXK3sMV4mBsO0DM3s4vOLqWzwp5DqV8nkNlI8MIuvmzFZdBA5wJNEa5s62nWkBqd9oeM/KmxX5OPLDBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfz6R21ZR6TTgTUkkMItOt3R8yEDUpLY6PRV/yUhqJk=;
 b=Fx22qq0hx0LCbGibG2vSFPD6w786PcSHeE95knGp4BbqoKLI0k6lPYkHspQxOdx3c43ZKQE7ZvWaYQQii46aZZ+Qlik0OPZvdUJLvLYQhqiuDUBuS+tKjEAm2wKYJiTM8pWfzVK9dVvORNUHssrEZqFTEszm6lCFVt5tSfZWXdArds7czx+mT4M9scw5RhiZpkoR5KTY+PzEw89ics+tJwZ4GZF1Wl4eWPR/0hoN3B/oI/ewQiPQrRHyAvvt8R42jWq6d7dJWU8hsvZ7cI/rglCvXdY/hvhDDv5ptoJUnSsO9K7DcjfwnCiPTkLPbGsjx+4A6WxdnDQoMmZvdEQk8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfz6R21ZR6TTgTUkkMItOt3R8yEDUpLY6PRV/yUhqJk=;
 b=Dakh7lthQ93kmPlJxgYXp6/iE54EqYvtmsuMZk1XuHXgxJwiy7Qt2o8CZN0R4s5WqVYuER87iB7jU0TZWh41YOZ3YcMI86LaY+brb60IY+Ahv9o1MDD7+EGG0xDJp7n9bwO+dMSyHbdip+Q3ARIX41ELX/3tPK62JcskYBsj79w=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR0502MB3952.eurprd05.prod.outlook.com (2603:10a6:803:23::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 16:21:08 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:21:08 +0000
Date:   Tue, 21 Jul 2020 13:21:04 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
Message-ID: <20200721162104.GB2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR18CA0026.namprd18.prod.outlook.com
 (2603:10b6:208:23c::31) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR18CA0026.namprd18.prod.outlook.com (2603:10b6:208:23c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.19 via Frontend Transport; Tue, 21 Jul 2020 16:21:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jxv0q-00DGXA-Q2; Tue, 21 Jul 2020 13:21:04 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1f212e5-786c-43ac-60cd-08d82d921301
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3952:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB395227752989BA6FD8F8C84BCF780@VI1PR0502MB3952.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yixI2HbSJJeUFR/W3IQm4Oi1OPB6eTPNE081pCzA8BSXHKrivpHeOx99NtqqPr58M8yjqkqB+qm2sqJyX8GrPllXx/PbbTAo6IDk2xlkFaxlmZ8vCIDh/UZ2IeO43dHss+kXWO7Lot10Qq7JrUr/epoUAegb3QzgfFg/g49Iukr7sCf08cCPhdivIwYHUgKT9gRxKfsS60QzM0JXkAsnE4tJJ6GJBo74MkxXO0IuNer8rt0sCwgdMsokevTsMa9AOyvPI9anLR5bHJoKTAmT4qLUFhMpATco1JhnYFiVDarx4tSiO0L4BqEk+JvMWiFxbpwEozOclBxJpYSuzZR7LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(396003)(376002)(346002)(136003)(366004)(7416002)(7406005)(83380400001)(2616005)(4326008)(1076003)(8936002)(66946007)(9746002)(9786002)(66556008)(478600001)(36756003)(86362001)(316002)(5660300002)(2906002)(8676002)(6916009)(186003)(66476007)(33656002)(426003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VSvDcJQ3uZiF//WSS21AtaTHzXHSYRZchv1wXo2GtDi0I2VxeVmg9eol6hfMKiI3HpM/iCw8jnXP1KcAJIQCulk2SbGygBucyRwbPUl9/Fupdf8RVTBKb2QOTxjXU+HwhCKYpQdhMweJxD/k+KBsoZ8lpTF9DtdsxRj6CSiOUUWUKtRDgGRhxQWcSvRiZVCLzWJWqJiA4FRwuHr+uxYOH/8tKDhv7P4tOaLOrExew0URVWAYf0FuOjesOPrttE2IUqormEq6omCFlf4riQgXODHLKbBWCMWukhcaXiQfnz2nc5NNZ3I13a+IYhpwrDDR9LXBDuWYbKFPSeyiQSF8o9Div8bscF4OKGHbCsbCLn+Hec7+bAbzii1Ds2AzhSfS7J3aTcS1jJwx/NPG0Hj9cSAHLJ8iuD60Mt4o78kKwRJpGHAHJMDVDbAHMlLTfjAfxBFtBLB9M4WjCEeIIyxXAk9+JBgDslMvRxgC9wBnbEQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f212e5-786c-43ac-60cd-08d82d921301
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:21:08.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxJNC7lzLzMV8Ga/Mq6PStnmDcGUKB0egekGMAJrQDC5JoT0xzopIwx/l8lgYKHv1cYeuSjLRRyxtzdpW7Wh4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3952
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 09:02:35AM -0700, Dave Jiang wrote:
> From: Megha Dey <megha.dey@intel.com>
> 
> When DEV_MSI is enabled, the dev_msi_default_domain is updated to the
> base DEV-MSI irq  domain. If interrupt remapping is enabled, we create
> a new IR-DEV-MSI irq domain and update the dev_msi_default domain to
> the same.
> 
> For X86, introduce a new irq_alloc_type which will be used by the
> interrupt remapping driver.

Why? Shouldn't this by symmetrical with normal MSI? Does MSI do this?

I would have thought you'd want to switch to this remapping mode as
part of vfio or something like current cases.

> +struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
> +						   const char *name)
> +{
> +	struct fwnode_handle *fn;
> +	struct irq_domain *domain;
> +
> +	fn = irq_domain_alloc_named_fwnode(name);
> +	if (!fn)
> +		return NULL;
> +
> +	domain = msi_create_irq_domain(fn, &dev_msi_ir_domain_info, parent);
> +	if (!domain) {
> +		pr_warn("failed to initialize irqdomain for IR-DEV-MSI.\n");
> +		return ERR_PTR(-ENXIO);
> +	}
> +
> +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
> +
> +	if (!dev_msi_default_domain)
> +		dev_msi_default_domain = domain;
> +
> +	return domain;
> +}

What about this code creates a "remap" ? ie why is the function called
"create_remap" ?

> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 1da97f905720..7098ba566bcd 100644
> +++ b/include/linux/msi.h
> @@ -378,6 +378,9 @@ void *platform_msi_get_host_data(struct irq_domain *domain);
>  void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg);
>  void platform_msi_unmask_irq(struct irq_data *data);
>  void platform_msi_mask_irq(struct irq_data *data);
> +
> +int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
> +                           int nvec, msi_alloc_info_t *arg);

I wonder if this should use the popular #ifdef dev_msi_prepare scheme
instead of a weak symbol?

Jason
