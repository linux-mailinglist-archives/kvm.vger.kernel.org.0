Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25DF41C4BE
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343801AbhI2M3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:29:49 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:56608
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343765AbhI2M3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:29:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTfv0SvTzj4Qa0pd6SDas+zSbnjGRysCHfdMuS4trU7EkrBJXrMiS1EQD2Qg8PzSl02USRL0J/tY+hNOUdOJq+mnt3OpYhxfPmdNV8d2xN3akSEYDkH0W/TKZt+HTCaoY13ouWdEYgQL16EkyxvUt1EHY/Lv8PxpvmSe9yELwYd5nNYz2uplvxoWqkNkhPe+ru6BqjP6Xr6L/Xl84bUtL9fMK1qRE2fRCaFWOijHzOk45VlU7HHiHZJORVJuSapcGOODCyjSIYxjIUpdEu5TTdTpoBtCZGR6Z3W5Yo0Nx2LF8ml/W+hNLAH7Xqti+t/JlGzzpJbojKCByX+eOr7DGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xyI+wP/gxRPXWuUhIUJj16PIvbRutaR3OSbHtgYvTA0=;
 b=oQ1pJNJ4+IZuLgOTxr4v5kxM1QJC5vI6QIGC5wHXuK+2oTssKl19IcMj5Fu2lJq721eBlALxG7iGWvHvLr+E353EwHkTP7tPoHrtXKdgCMyXYbrpiTJkNJ7Jk+pjpl9RDvqmLU1GC/+WfIPmD8JD1dZsQU2FS9/peCXdhHM0HLnulZQWhJDt7sSU4TSQQ8P/XgXWGIjbILSuTGKgvNcJIiIYkSxGX8n+bf/23l1vyNn8HmpW+niqf6Vx4xtTpxopyLHmS0vVPer911dLicpfeQUF3oCjp1sHDQUxS777K8FqCljnvqzuD6mb6ZwgCdFKcyPdnaU1NHUU9FRsvRnYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyI+wP/gxRPXWuUhIUJj16PIvbRutaR3OSbHtgYvTA0=;
 b=K9YnpGi6KComts8HE8Cdl9flKRUpEgnaWqn0tn5PYwL7qDOr6qD2OwyiJA/Cgrsgy6sehFi6TMC9yzyFmwnUVeKy44N0mNpTvxqIyIVynr5FV5Fn5Vmd5Wuka3M6A5jrcTdHXrKy0DBXkql05ZSAIqabMTx18ekO4yBiYNY4j9C0cTSZyT37iIwphqBWMlPQU2fDvbQNCrw8xh+uW4OKkcswf0ntrT8oNgwvj8v1+79PvtZzEdlD9N77NYzRz+hiczGy07RGugH6tH2mSkxKvhPax/W6dJtRuNZ9kHpMfKHpaTeOnw0SHj1KxGde3LL9z5uVAbtt2X4ZXO9EVMKi3Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 12:28:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 12:28:02 +0000
Date:   Wed, 29 Sep 2021 09:28:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 08/20] vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20210929122801.GQ964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-9-yi.l.liu@intel.com>
 <YVQBFgOa4fQRpwqN@yekko>
 <BN9PR11MB54331D06D97B4FC975D8D23B8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54331D06D97B4FC975D8D23B8CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0081.namprd13.prod.outlook.com (2603:10b6:208:2b8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 12:28:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVYgr-007Yhm-Mk; Wed, 29 Sep 2021 09:28:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b20dbf65-da1d-4ad9-4ea0-08d9834494ac
X-MS-TrafficTypeDiagnostic: BL1PR12MB5141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5141B116D87B0E2822A397EBC2A99@BL1PR12MB5141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fr6pKw5Hkh6LQUvF3KkKBavmoSDQyilEsm6nzMIDgaoF3iQwPXq9uSuc1KBMcFXF0d+LDG0RG6TvRtIrPvmqrWZNULbGZ0EzEcK6KOYueiaPnICkfSS3/+7sLR2h7Q/YPLagn2R/CV0kGhvmItdl2cg5w4mA3cauneTXDLDJLQierTrziF3u+juJFwqSDb2eYyKtfVBTRPNbYHl3kreKu0iA2+deGlgTZKyMlXQuo1E8J4kA2K35jsLatUOwV8AiVk01rYmuhaMHYEPijs1Knm6MrRXr8x2gOeyPcj+djYdh5XKxL2+XClFImNerPkRfpINz3dSuxIqZLAM1OOHM8f7nTlPpBQ/5lPLxDKU/8ZQggO48iG6IH+KRFQLbNs5BUAm9lBJY/6/HTM6ywzmAR7eAdzcopIHViOMuE2gSNszm3QRizINPcvViBuuobfZnL++9YVJIMG1G/jOaZQx7x476CvYiLbMkmQrckJuCBOaIZZuNhZTxpt6AErUe8UnPEk2EZ96udYvTiWuuPecHZ+M1Qcst/wxMd4mCSPsAXzCpOGlPrcE9dRtT/qfZULL2zWX/aZz15LnQxOfasFoUbF0bYwW4XI/PhIiFQfLI7C772E5yuZdH4aK+lEKI6dFK0+f52yDiaKIwZTZB185/nYykmHggfPAiEiKQ03pkSBb6M+1nFwpgCFTbBNYsYibNu0iyiMvTHunbvaYSCqF/4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(38100700002)(8936002)(2616005)(36756003)(33656002)(66556008)(9786002)(54906003)(9746002)(83380400001)(186003)(66946007)(66476007)(426003)(86362001)(316002)(107886003)(26005)(6916009)(5660300002)(8676002)(1076003)(7416002)(4326008)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HbB6DNQO58Ol2DFY0q+tSvnjTj+wLGVZtvlXw5Qa14AWMOng5KJJUOeUEPJ+?=
 =?us-ascii?Q?kuVgBFq63IOitC43nNE4ZgNCUafsibLJLwYVkIJ4pzr7GdpXpxzG7/MXuQ0n?=
 =?us-ascii?Q?Z6cEJ8Hrot0BIPTROkrGCbCWRpoC/w7/D26KV3dxF5hr89cnJlJ4e7IRhaAh?=
 =?us-ascii?Q?JbYGZjMh1soA7+6FnMO3joJl2N3WjcIQiNd/rIUnrLZ2ReDpd7BAsTBFalbF?=
 =?us-ascii?Q?LhcAzVtwf6uuhCvFNhSMyJQAQvY3np67VXts7jUKD4lMSCQkKpRgGER7Ns8o?=
 =?us-ascii?Q?gikhE0gQXLFW/hB9Wd57jv1wJJ10GNatqve/YE6fpKl0VvAm+v5+lQWnRVLu?=
 =?us-ascii?Q?Ohm4JDNW1Pl1VpjbuWG5wU5NMFuHm6lYbtDohZVN3aANaE2Byw8AEv/eXmyD?=
 =?us-ascii?Q?He3fjUF9OakfkKlZddeDZOrZ8PF9H9cSuqYRV+JN5dInGUAfUySXX9MUSlmx?=
 =?us-ascii?Q?mIfS3vziOxWRLEl5TZZkQ/BMi0ikRJ+atyOMQ1okheFTS89B434RE7IyGeUx?=
 =?us-ascii?Q?UGOqvUyKNftLVaQkYnfA0xDlmPRj0Aksep3efcOZdxEaVfrbYm9F5vVcyW9Q?=
 =?us-ascii?Q?ukQ6fvJgH5bTpFDMaudYDDbMmvvK4e+n0T2cb7C1fUrW69zGpAkgzFq4XbJp?=
 =?us-ascii?Q?ftyavvuZDRwKr7wUGF7oLSUsd8dFbSPKfDZqRZZrCLO2A8XKjMUNdqyETkvz?=
 =?us-ascii?Q?JGhXypwqdAmkNHltB6TYY4TzXKeCjfb8duQM/0N+4PIx5Y/oX/RionCfBwuZ?=
 =?us-ascii?Q?I1UdaEO8AVBboiURJGDTqKZw3tTEU3uGJl4du8RPlAXygr4BikBrzT/o7e6o?=
 =?us-ascii?Q?BydXKg8TiTFepIZjL9QL3ZP26oF/rYbm3zmBjoA1xALvnzOe38lxvbivJbju?=
 =?us-ascii?Q?LdSfmvbVIjTJdz90Cx5w68+pNfBks27XOHI9X/wM3zew+GI4pOjnyfYXwM+4?=
 =?us-ascii?Q?RZmQEXkPuh6XbAHyqp05yZzHjQkUI8zvT8b09T5URUVuIMC1qtRFiQpQ3sJV?=
 =?us-ascii?Q?2FObxRLFB5nO+0jQACWfvzEjUsl/gCJbEjngNQ7otmU3jb+/QnjLFXuKRSTU?=
 =?us-ascii?Q?G/0Oy2O4EG4XbT7qcm+TPgeGXBYpjwHOu3rayp+ZpDU/L0++XwngJ5zZ1B1i?=
 =?us-ascii?Q?qvB1pw5nlW7g+WRaI86kwvWbghkQu+XaXls0wjRqVq70+TXlYHb6DBp+8AyX?=
 =?us-ascii?Q?XS55o1CzpXITXyqdvYL0Kd22y74CZBNaYpdXJxholwHZegoT+XdoGDmPAYsD?=
 =?us-ascii?Q?C6XPFZMiliFfz9krw/RIM5HL63ulSODbViDIVwI42Yn0V5KVuCAesDn0XlRD?=
 =?us-ascii?Q?g3K9xOMleh+X/i/kVXORKzBx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20dbf65-da1d-4ad9-4ea0-08d9834494ac
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 12:28:02.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZX7COAawrmfobsw8VOb4KG30Hc7lMa8JlY5Rv1+FCf8ahPZVxpBvk8+oJxaHtnV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 06:41:00AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Wednesday, September 29, 2021 2:01 PM
> > 
> > On Sun, Sep 19, 2021 at 02:38:36PM +0800, Liu Yi L wrote:
> > > This patch adds VFIO_DEVICE_BIND_IOMMUFD for userspace to bind the
> > vfio
> > > device to an iommufd. No VFIO_DEVICE_UNBIND_IOMMUFD interface is
> > provided
> > > because it's implicitly done when the device fd is closed.
> > >
> > > In concept a vfio device can be bound to multiple iommufds, each hosting
> > > a subset of I/O address spaces attached by this device.
> > 
> > I really feel like this many<->many mapping between devices is going
> > to be super-confusing, and therefore make it really hard to be
> > confident we have all the rules right for proper isolation.
> 
> Based on new discussion on group ownership part (patch06), I feel this
> many<->many relationship will disappear. The context fd (either container
> or iommufd) will uniquely mark the ownership on a physical device and
> its group. With this design it's impractical to have one device bound
> to multiple iommufds. 

That should be a requirement! We have no way to prove that two
iommufds are the same security domain, so devices/groups cannot be
shared.

That is why the API I suggested takes in a struct file to ID the user
security context. A group is accessible only from that single struct
file and no more.

If the first series goes the way I outlined then I think David's
concern about security is strongly solved as the IOMMU layer is
directly managing it with a very clear responsiblity and semantic.

Jason
