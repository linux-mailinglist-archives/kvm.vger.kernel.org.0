Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722A3229E9C
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 19:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgGVReA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 13:34:00 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:3044
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbgGVRd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 13:33:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkfwiTYWjhyE/txmZSUkFakhidmtEZLQ6h+u2QdNk9WJXOkwSOvnrOg8DVko4K2+ZHdn4wSsHLsgB3UDvvSIPlCujlKyp+Hm1Pw8GsXG30SMlIdyzK0fy8Fq5+Bne4iUqFvupf5t9pE8F9OHg0jdN1pKoQGh0N9L5KLFvbfF+3uZlUIX/IwuV6w8pom3ijGCmA/12X+j5SvRrHdiKsg6YG0uUjr+bfVzpILP5GpYZ9Pw3Wql4utCu/HoJzHsGnHwgc9Kbyo7R00efQQSSeXE8IBVmQaHGnu3jaD6UCMX3UeC/PlC4wzKoL2oCRp053Qa+bxx4GHIHSrexTgC03/ztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QK/aQQ5KfghiBYIGS5RXIXFP5KCX3wzUdti86edAXAg=;
 b=k/yPb0fwFs/nFUGx1AUy3xe4DIylPpIeV90Ch9Ct/b71bIzlli7FJNelpU/mc7iwkhM49lpmuLfIE0nzJ06VMwgABhX9HyXua6U9PSaHUqB/qRiI2Pn66480E9U1QYtUZL3tfvSFKh5Iy64cAMfhezhlnsFYto+E49nvSWJeKSpwwiGC6K4hNSX18WkrFJXvxESQqzHlXmQu5ktJu7gUwGDeBy9mBO/GPBwPbWhIAhg+jI3MR1BbtxgSSgd9zxGu45k2j1PYxcgxdhpLn6o8ekwSBmt20LeaQQyFtXf8zHXMHDJktA97XLe4TbR7wBPClTC0yNjLmwCGFv3jwYugzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QK/aQQ5KfghiBYIGS5RXIXFP5KCX3wzUdti86edAXAg=;
 b=Dhzz+EhDnLX0c78OVVVwZ+rMQp5wzq594ASGOu7A3b4Z96cDhbFfCN/RiBd7qOXLgVQX8ToRHQo7mcWX1V/F4qmgBXjdHujnJKxaRuRc1GJGXA1uXX4JMgGJwTXRrNTJJCZiFtDZQxhbr3xhc6vy2TfShoRCJDBNTKpJJpve7hc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (2603:10a6:5:23::16) by
 DB8PR05MB6665.eurprd05.prod.outlook.com (2603:10a6:10:142::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.22; Wed, 22 Jul 2020 17:33:53 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::4025:1579:1d10:fd4d]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::4025:1579:1d10:fd4d%7]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 17:33:53 +0000
Date:   Wed, 22 Jul 2020 14:33:48 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 03/18] irq/dev-msi: Create IR-DEV-MSI irq domain
Message-ID: <20200722173348.GK2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534735519.28840.10435935598386192252.stgit@djiang5-desk3.ch.intel.com>
 <20200721162104.GB2021248@mellanox.com>
 <84fd4ae2-e7ee-4f9d-7686-6a034f3e2614@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84fd4ae2-e7ee-4f9d-7686-6a034f3e2614@intel.com>
X-ClientProxiedBy: YT1PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::21) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by YT1PR01CA0142.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Wed, 22 Jul 2020 17:33:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jyIcm-00E0df-PO; Wed, 22 Jul 2020 14:33:48 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9bd56ec5-b6ba-4c5c-a5e0-08d82e65672c
X-MS-TrafficTypeDiagnostic: DB8PR05MB6665:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR05MB666598F4D8823851EF4A7F02CF790@DB8PR05MB6665.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zzTL9rpKq886d4sS75g0m65pWKOk3wbbdmJopoyr6nm/Zii93mVqLjMZMD42JtO3Kx6AJF+YOLwYOMSiDhYHeWgzcZKk0T5yFvP5/lN1FSjE9TdylpX+prGr4lFuMBGafaOWglmec7zOSLkrVk6qIYl/5KDOXP2yAKbGrMG4tboSWlWIsp1X0+7/uDwrl+VMwQu5fY9Y16MRo4Ji2cZc2fNUI8AZ3MQ74nEyXDX5DAeZy59nHx6eH9/nGt1zIjlXlASb4sHDmK5saW0JNWSEl293/w/2VgIA2fmNoYh3ycEid5OoXX6kiP+g5zSsLWee
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4138.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(36756003)(426003)(7406005)(8936002)(86362001)(33656002)(478600001)(7416002)(8676002)(53546011)(4326008)(5660300002)(186003)(83380400001)(2906002)(26005)(6916009)(9786002)(9746002)(316002)(66946007)(66476007)(66556008)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bDY4fLXCzs+XRAXXjiY+E7u4NShSjmUvXeCCjhWvZU74uU50+9hO0XHCldas08ObPOCQYFwGT4SgEie1JLm/4P/OeZkbIDMzAJHFXq56OBZA1yK0tUDTZx4oR0r5I3t+vGhGEEVcvErlGMrGGGeho0rPi58jNjXvwyXY7cKMTuP9EGidVUeXas+4h53EwMpGMlZBbAJcQSDPgYdEqKcGNT5WQwXs9t7zCBjAIX43/vwtcyrTxCOUlgKovws55Bj/MplX5AuiLuBmHN5dItpk17rfpIYwaOVO2pQE4ni1sLzhZKsuRx+kbFznssM/B27PPpYkNcwq9TAkg84SY/6hnhrucIgWcfS5Cw7IO8dx6q/BAOX414isoTLr0TzDjzDE30qV4vkCEKZ8OyluYRGDu3o4A3XVezdJGpKl9DmQGP+f6I9W6ORXMuGu0YiQLYMbaSkLmT+qQ+5g2ASEIZH8QLccaAhiKsyaWEojY/N1fLI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd56ec5-b6ba-4c5c-a5e0-08d82e65672c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4138.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 17:33:53.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXAuRvREi9c0Oak/Tqo+b/TZD9d6SHP3WF9qJ49Vfy/v+yl4IvFY2O685EdspaSCj1aOnu7fXxm1VgegHzXioA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6665
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 10:03:45AM -0700, Dey, Megha wrote:
> Hi Dan,
> 
> On 7/21/2020 9:21 AM, Jason Gunthorpe wrote:
> > On Tue, Jul 21, 2020 at 09:02:35AM -0700, Dave Jiang wrote:
> > > From: Megha Dey <megha.dey@intel.com>
> > > 
> > > When DEV_MSI is enabled, the dev_msi_default_domain is updated to the
> > > base DEV-MSI irq  domain. If interrupt remapping is enabled, we create
> > > a new IR-DEV-MSI irq domain and update the dev_msi_default domain to
> > > the same.
> > > 
> > > For X86, introduce a new irq_alloc_type which will be used by the
> > > interrupt remapping driver.
> > 
> > Why? Shouldn't this by symmetrical with normal MSI? Does MSI do this?
> 
> Since I am introducing the new dev msi domain for the case when IR_REMAP is
> turned on, I have introduced the new type in this patch.
>
> MSI/MSIX have their own irq alloc types which are also only used by the
> intel remapping driver..
>
> > 
> > I would have thought you'd want to switch to this remapping mode as
> > part of vfio or something like current cases.
> 
> Can you let me know what current case you are referring to?

My mistake, I see Intel unconditionally globally enables IR, so this
seems consistent with Intel's MSI

> > > +struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
> > > +						   const char *name)
> > > +{
> > > +	struct fwnode_handle *fn;
> > > +	struct irq_domain *domain;
> > > +
> > > +	fn = irq_domain_alloc_named_fwnode(name);
> > > +	if (!fn)
> > > +		return NULL;
> > > +
> > > +	domain = msi_create_irq_domain(fn, &dev_msi_ir_domain_info, parent);
> > > +	if (!domain) {
> > > +		pr_warn("failed to initialize irqdomain for IR-DEV-MSI.\n");
> > > +		return ERR_PTR(-ENXIO);
> > > +	}
> > > +
> > > +	irq_domain_update_bus_token(domain, DOMAIN_BUS_PLATFORM_MSI);
> > > +
> > > +	if (!dev_msi_default_domain)
> > > +		dev_msi_default_domain = domain;
> > > +
> > > +	return domain;
> > > +}
> > 
> > What about this code creates a "remap" ? ie why is the function called
> > "create_remap" ?
> 
> Well, this function creates a new domain for the case when IR_REMAP is
> enabled, hence I called it create_remap...

This looks like it just creates a new domain - the thing that makes it
remapping is the caller putting it under the ir_domain - so this code
here in base shouldn't have the word 'remap' in it, this is just
creating a generic domain.

It also kinda looks like create_dev_msi_domain() can just call the
above directly instead of duplicating everything - eg why do we need
two identical dev_msi_ir_controller vs dev_msi_controller just to have
the irq_set_vcpu_affinity difference?

Jason
