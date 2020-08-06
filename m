Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E05223D484
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgHFATj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:19:39 -0400
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:31969
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbgHFATi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2x7I04CiEpQ5hIGWKDJ/sDeklVDKHvs7JhzXvBhTpRkhXLYm+tH1Zc/DwjhQBJwD3Bm1o1TkTkHgTcegtYc5rG9knwMlVdjbc7jlJB7nB6smAz+pREG+Sjpr7p+Xcpu92gHAiIdjwSfGm6yOIMF/0dt7uJxzBKv+W9K3LE1G/Eyh15kHmSo6dq2i4BzKJTrmSUso+K/yb7j1S6uP4pqVWQUDr/8vx3PCBMFzTN6PuaIV4zUCCCkLUzPRt8o58vkkesm/1napmHUpaQRYCXvs8TmvgcVW/E3+Wu+3v0e37OQcnS2g/6ADvWTnY716MhpaPzZyjLRnCvCYNIqZsBKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/ieMeAv+UuHyv+8RMNofaAoQw9WgzA1jEFYWwxzzVU=;
 b=L2jzjVDd1WkbOUMZy81Vp6FLDEWZULU4KhHT3ywUc078pnbUM9K4COPfwXjdEJZb4endG4a/OUZj5IU23zW/lUBkG9CGUAr4scggkZp8yHZ7bOWu9WHZOwmftUZ5Zdb89B36CKKrbpDs6SOxo57jg7k0vFCMPIcdAgXC9uyO8B/yx8+6OtUmx/oThu2HHCgmik48TyM2dQ99zkEipoEGUvOJzwHlBjd3oWRX0L3L6nP/p3FXOfoBVkPhhowNHnjeBDuJpIeO5T8dd4o5u8cQlshQtfIZOMYSw/PfkXX7LjzeAxV1FKwNEtiUVUmsibUQtM7VQmlF+I9nZ5KpEO6INg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/ieMeAv+UuHyv+8RMNofaAoQw9WgzA1jEFYWwxzzVU=;
 b=j1j7NHwxx6Qv1w0aUSmKW9agNs50jJmO7tYJVMOsIYVmQLy/uDGqJ9n0SSfiXyrYuQ7vD0GIf5y/OFAubOQvS5W93LPq5cfVikOwS43dGpseeMks6KQ6Mzp+bCevEj8DjjcA/Aplpi1S0NOItnrT41l7FZI8cUfZC0TfFGTfcFc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VE1PR05MB7375.eurprd05.prod.outlook.com (2603:10a6:800:1ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16; Thu, 6 Aug
 2020 00:19:32 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a%4]) with mapi id 15.20.3261.016; Thu, 6 Aug 2020
 00:19:32 +0000
Date:   Wed, 5 Aug 2020 21:19:27 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200806001927.GM19097@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org>
 <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <630e6a4dc17b49aba32675377f5a50e0@intel.com>
X-ClientProxiedBy: MN2PR19CA0025.namprd19.prod.outlook.com
 (2603:10b6:208:178::38) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0025.namprd19.prod.outlook.com (2603:10b6:208:178::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.17 via Frontend Transport; Thu, 6 Aug 2020 00:19:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1k3Td1-0041NA-Rr; Wed, 05 Aug 2020 21:19:27 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35c259cf-ef0f-4f8e-58e6-08d8399e640d
X-MS-TrafficTypeDiagnostic: VE1PR05MB7375:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB73756B41940CD215299747C9CF480@VE1PR05MB7375.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hAZPRAlyoOS0DqCNSfPPuVELncAkDI0H2F1WKEeBVIhMyy4hPw+Y3JJAGyfmDgePCSpKlR+k+VPhbFuR3zAcSut6hWlM/QpR+GZMldJ/cICE4EK8v51a5BkOgk3xDhC862K/Wod85hS9lxA0uQeM0e4mc8sAPMAQZGnunlMbifRYuGpZwv4JtsX1x1UnoBOXkf0bKeITQMnnCMComTfKSmCrFM4/73furvcrJLRGVRZL0NHeaqOkscYWo+M1ohS5AMESQ0MSPBxayXZpUve9WY3tX50ddqGGFQQPetTfr493FgiYT4ielKsRRg9EYiZPa7b8ykEdeOmb9Pvjfm6miQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(36756003)(26005)(1076003)(86362001)(2906002)(2616005)(6916009)(5660300002)(426003)(7406005)(7416002)(9746002)(9786002)(66556008)(66476007)(316002)(54906003)(8936002)(33656002)(478600001)(8676002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VjgGJxWg8Xuwv0bjfwwW0JiN1Io2mf46DBKd6f2cJqKopkFysKaEI2HUMDTsU7oeDIBo47EJLmYWt2oNLvXFPelOoZAbKxqbn37bm1aue94TH3xPX2ofg9DJO8OcR9wGdeDeErAguC63/z6LyucDlaQB6Bnj1qXN3YfSYnCWRwDdEzW57AWHXkgY7mCc+vxCO6W7koSFXKmTTE/PZxIup3i6rlF8t47XhNepZPdu8MgRktHMdapWX3P5M7ezuG1aiNRcG9lo/NsXWUgnYY7NztTzOtkaG65wsdFeulpjWz125uK3MCGJ9QoSmY1XBS/AljQ2PlReA+yCPrImiBSiaYYgzmq32U/t9r33cqbHfJyIWbgvzA9G0Du9/ZE8HrWcb6h2AaKjgjy5RyrMzoMw/N+qHvQCpl8PWjPKomHG6k/aIaMYD8FUAi5rHwB70zjTEu5KWwmRIYj7hsBMmag6qcIti1hdTMKF1DzXBo6gkHkHvnPwrOwnZAOaJyRcNlULEzv/ydAr0MOeYoeXnW+vVCSo9ut1L9x9pyp0chR6LPjFnVop7T0gBuU0NVFSNc0fplqXhmVPjMAeeVZB7v+6E0JEEzjszNR9w7Zcoif5iEsfVN1KtrwYZfP0K1ik5IoD6hUHz8TOo3UmYB55X4N5oA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c259cf-ef0f-4f8e-58e6-08d8399e640d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 00:19:32.2195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bxv+NhQc3z/r93GlbwCk84DKYResC6dCmTJEWzqW5a3LS29wJ9ubqJsV0iSLeg6l7lLwJwzNhUI3GJS42uGI+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7375
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 06, 2020 at 12:13:24AM +0000, Dey, Megha wrote:
> > Well, I had suggested to pass in the parent struct device, but it could certainly
> > use an irq_domain instead:
> > 
> >   platform_msi_assign_domain(dev, device_to_iommu(p_dev)->ir_domain);
> > 
> > Or
> > 
> >   platform_msi_assign_domain(dev, pdev->msi_domain)
> > 
> > ?
> > 
> > Any maybe the natural expression is to add a version of
> > platform_msi_create_device_domain() that accepts a parent irq_domain() and if
> > the device doesn't already have a msi_domain then it creates one. Might be too
> > tricky to manage lifetime of the new irq_domain though..
> > 
> > It feels cleaner to me if everything related to this is contained in the
> > platform_msi and the driver using it. Not sure it makes sense to involve the
> > iommu?
> 
> Well yeah something like this can be done, but what is the missing
> piece is where the IRQ domain actually gets created, i.e where this
> new version of platform_msi_create_device_domain() is called. That
> is the only piece that is currently done in the IOMMU driver only
> for DSA mdev. Not that all devices need to do it this way.. do you
> have suggestions as to where you want to call this function?

Oops, I was thinking of platform_msi_domain_alloc_irqs() not
create_device_domain()

ie call it in the device driver that wishes to consume the extra
MSIs. 

Is there a harm if each device driver creates a new irq_domain for its
use?

Jason
