Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCA839F78A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 15:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhFHNTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 09:19:55 -0400
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:50145
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232903AbhFHNTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 09:19:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKrfJqhlVKj1D7kG4bZLLTOujDFmnpZsidlIjgZH8LD3kO7jqMuq88cFbggg99KrwfXhOTO4QMKinBRcsc+GxMSdS5xrJSJI9OuylXz7OJSOZkfon7QCtZZ/V25BelIfEBoUEbdHHGBI+vD6uGVSAbjTszXCUzTacfdBh1WiAjnWtBPWezF+s+GdYxOKC4DsNPr2GbSh4jkeVAJzv+O+SzcEV5gO9IpCDbrnIn1zLaChZyiEr+NyLc1y75bnj7l6AeaAYcUdN/0ZcTA7sebaK2PZkx+PdBmAUo1H+E8U4XEfN+JpsX1+II/ML0ex/x2Kin7tqZ3PMcFKD3z8Wizd5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVe7+KyKwR45WXtbPNuPh/FDsRA9IlHLQ7a8Cj7+WjE=;
 b=jp9wlrRTuIhwEwDUfN1z24WXIKgGLS739R5/A2qAJcfR3S/Ei2UYcctyfw/aN3ThWQIdYmUqN91M0JMvWAG/fo6nHf4LUzW0j/HTa/nPsrYV49n6X+W3W2hbK1CDOh8uKv4criKlNORjihznuKQHqrP/BiP+Y5rDIlJ6kN8vbd/gX7fyHcvcvXb2fVvTcQx9f95+F1nxpsGPkw81eZpkRFgVFZfbLmsLowfNBg73kHPfxpSnfGeDCA3Tz4wgzXsjU91CRwytZEvHVS8uZShqTeS4XN5CJuIBVBFistTsPkxtogMrqMUavl6MsEdfss8OVty/OIkVzqkJSCIa0/b5wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVe7+KyKwR45WXtbPNuPh/FDsRA9IlHLQ7a8Cj7+WjE=;
 b=rfrHP3nLoZqwrnixE5DFyNNjUBHHtDVFpTr2yU+8AK34ikwRPYc5ae4nDXXmCKkzTq8UAbybrODfsXo2OUsRxbMcOzUhIpGvQPazT1/4KTyM50vXyHOyE3n8Una+9HN98u/6yQgyUOuf47MMCzzGQNeipI1GL9PelJtpg8pLUMzr8EkWREVc9j9HymAsD0nruB3mVJ5BsgNMkI/fj9pt90nI03K5a74tZI5QiP7uD0Sjdl+9YWciSFwATTJKjk6F/TCZkXvTTvCr2szvPAgrmxngXiFQCjonv4c7u8BUhaEUcOk2s6vfkfiq28HjnXu114eDbzljNlPvh/2OaXOy+Q==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 13:17:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 13:17:58 +0000
Date:   Tue, 8 Jun 2021 10:17:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210608131756.GF1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <YL7X0FKj+r6lIHQZ@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL7X0FKj+r6lIHQZ@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:208:238::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR22CA0017.namprd22.prod.outlook.com (2603:10b6:208:238::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 13:17:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqbcC-003qa5-3y; Tue, 08 Jun 2021 10:17:56 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c396d26-1071-4f7a-d451-08d92a7fd548
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50959C0A121D0E2F6575CDBAC2379@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkQnFikeF8IDdKzCmB4Y9Z74lgfmteIAe+idFdsL2E2a7M03W6NwVR20mqWNrtRsFR4fed3Kuww91WDrx7UTWc2wgu3tG7x/eX/u6J/T8FAFZ9DcpovP7GcFCb6kyaFfG1pDs3i15u/CS3GsZgpa/B48GgZMirnP8LP/g5i5a6FETGHI7EMq2gKORg8/U6PE6sKRzEl52uVY3DyFjcAkyeNoyGwJyBF4cinJ3Omh/zkAyQr86haSYQPXxnohiHmtueKtaY15jIiuC3avfWZ+e0+tikN+yp7oOOzZbZ3yFdyEhel339eTHzx5YgRSjgdXa5enYCKdu1xxVGJKXcdCMelrC2VpVXg3EuKoIPEWsovq7X5tZVbuHOzzcXfYfZNGUU7rUlCr4WIjyd2ptlqcrmHr0dcyvSwoPPwBtLqBJ65cjtYVGtTtTl3Vua2qyAFwJM9EoKD4Ixdw0ewz34mrcCAVaMY8PprInEr9j0IN1CmHzTi9Rz/dsnWUtSlb2uhpcYApz1egM2URht2aaZeNuwsf0nAXxeEZ3bp4OOJ2kOVPeMu3Ujx1jEVZKEASqcDeJOU28Q7Zx9JY3KPdbam4dznfy1KpzxSlUBBbBOKmz38=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(54906003)(86362001)(2616005)(66556008)(9746002)(4744005)(36756003)(4326008)(2906002)(186003)(6916009)(478600001)(33656002)(426003)(9786002)(66476007)(8936002)(66946007)(26005)(8676002)(5660300002)(316002)(38100700002)(7416002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LIq77WLTDKejBTSBM8JruOpDiTtL3x0iX+hmbDyxj5+vG4JTuKFpEXU9uuQ/?=
 =?us-ascii?Q?E5tLAmyXOFmSrujWhsNLLnG/c2JfKO/hiWfuWvjqGDuOZaT4gxsNiXgorNqo?=
 =?us-ascii?Q?n7tmJJJ93/dKWhmdJsNQwsfNVzgPz4t3KeV2cmqbjn/ZPGlawS+MPKH/Sx2O?=
 =?us-ascii?Q?esTLxsnqzeeOGaBLkFhdKAUSLM065dulPfcIF/z08zVpr1eWiKLdi+3Umg25?=
 =?us-ascii?Q?5krF+WhTYjQa0C2nC8k9ukQSsJm9LrTUBvzxsrMCsqRQ0n/qMDWN+4+pZTS6?=
 =?us-ascii?Q?00tHI8QVWRLUzuk2Uel6o7Dlaei14l/82UzjWTYibDmNhmYIkIxtP6a54Gtn?=
 =?us-ascii?Q?3Fqr6eeJzn7SwVr63EO1JVxDqnPPMuBDsGRn2Dui2Os/8fuUkEkMQ4pHNoWj?=
 =?us-ascii?Q?AO8OTfaTOv0rBuz7vC2OeXI7rMZyev2k5NZP9n7fjxA2hHMnun4lUFNh4/4e?=
 =?us-ascii?Q?+/1ycgVUBBO8oaOOYGYQ+6xw4s9leBlRlFygNPp01oxfZfcNc8Ni8sy0tJ3F?=
 =?us-ascii?Q?qqDCOkcT9qpPxH18TJRFNCpLY3/IhIgVxPSrCsQLJEHvE7fbg8I999ZVC6dX?=
 =?us-ascii?Q?5qD+nqWkOCIbridEnH8dknaJ6k+kVFRCaVPxugc0E8L/8Ddr/2m9rFqd8ozP?=
 =?us-ascii?Q?3Or+Q9FMq3aB1lsRciJQgRSo6ytBaFO5Jmcx7fE1+WvToiu78YmrKHIPDhze?=
 =?us-ascii?Q?ahvpEL/2ws5yJWIYJJbx1VH3jXk9GvAbaIxK5ywJ0H9G1tSHVJWNdMeHLp66?=
 =?us-ascii?Q?a6Asz3fIpEQMHIXPSYQMJtqb8zGzZou/LTYxYvET/SEYNsgbxFCQiVk5XZmG?=
 =?us-ascii?Q?xTdsZV07BNAwYfRPPoPvCya/NRp7TapXfnEv0gpbx0Flp1AFDS3TEUwdz/wz?=
 =?us-ascii?Q?i0QjbNapXz3iu6g5q5mee6gucp5ijYjM5vCw5C+qfoLZSfJ+F+OEUSLgBngV?=
 =?us-ascii?Q?N3qviL7JurA857rZDG12mT8ZL2f2gyCksAgxuxrs2jJopjMjoywqHgg/IXgx?=
 =?us-ascii?Q?W5goKNFKD/LHHdME+fiBZ/7z2FzvEpUcFVINJ1obO4iiojXT++QfE+0VLIMD?=
 =?us-ascii?Q?vxvz/7whOmu2oezXCqcP/gzs/6cn6HJ+qEjuBMMVpbK1glU3mSrNY+GfssyA?=
 =?us-ascii?Q?2/Jt5Tn4XhE3BZvdjfa83HwL3pTknJxdXwM9CLGbNL2/BQZSC+OubnmwoC6r?=
 =?us-ascii?Q?aqUQqrR4k398UYCfxZPeD7n7mucl8NFvP3sIZTlAlNPfs4RPwTZAQD5iU6o3?=
 =?us-ascii?Q?RfeGhOeN7rw3GaCcKUsELXNgcWXBhM0/iqYegdc73QxXKQGB8CrFudxiUPKD?=
 =?us-ascii?Q?b6CTKb0elMl2D/8kbP5akPCN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c396d26-1071-4f7a-d451-08d92a7fd548
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 13:17:57.9458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGWGcN+qbdR/zkI8yO6tauZ6vweERBIJyNeRoXXVVoP3SKZjfAnSj/lhLmnmCS46
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 12:37:04PM +1000, David Gibson wrote:

> > The PPC/SPAPR support allows KVM to associate a vfio group to an IOMMU
> > page table so that it can handle iotlb programming from pre-registered
> > memory without trapping out to userspace.
> 
> To clarify that's a guest side logical vIOMMU page table which is
> partially managed by KVM.  This is an optimization - things can work
> without it, but it means guest iomap/unmap becomes a hot path because
> each map/unmap hypercall has to go
> 	guest -> KVM -> qemu -> VFIO
> 
> So there are multiple context transitions.

Isn't this overhead true of many of the vIOMMUs? Can the fast path be
generalized?

Jason
