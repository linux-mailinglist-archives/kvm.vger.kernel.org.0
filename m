Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C932D419686
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhI0Olc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 10:41:32 -0400
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:47329
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234706AbhI0Olb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 10:41:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qn89mZ0p/KaK3CfyjguwWymrqWEP0UZW1VgbFeIHfxy/KaebB4+Kj14dl90GNjwmXfHBJMlEWSG87yh/UGJ6REe8F/wJgw5laDmWaxx02P//gk1BQHqFbNGVS1mvD0bHxem+bfF5fBYD91ecZrymbMAxNIjHW2JcybtfO5lP4nqPHrYeJ4rYKLp+A61IZZGlPk1tYIw606TAt8krMw0Le5A6mtbAT4Yg4LNy3NHnmOwonXaTEsZLgCwg6UDuUHHEkzXeu9l7FWYpqYYmP8n19f8Ac8oZZ29+dADDGNeRZVULRXfLrod0Og3TRl0IZ2oOylnpRkj2pLGANvbs+k8ZDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5mT9PiB18/Cg/qE3qnXOXDPaWRAbCpDOC0LRym45un0=;
 b=Zs60U3VqnNd8scr8Ane8QUqkF8f1UkftNR8pgbOFSW85tZhf7nxQyc1nvlXsA8KvXcnNhtT9dMI4mi6nJPwbZetWzgrtSttLxlnRZT+lWJD2GVfinOBnwJkWqmHlDi7pYBWzoL5XwADriuhM1hkFbxBi7i7C71qtAu81aNP9GE1NzKA+EIFBHlH5BIfSrGYcsFnXQwZTlUZ4q/tp9t8S0AUCgHGfk9tCJ3IjFrUgSEGYZ5KNlbYoDSC/H9rrko2n7RGXzoF3jKXGc8j0xstWfYpuJVr0X6BOFdBVDTa1/0lwMfUpXZysVSlaFjQn+LAmA3iubk5bZNFXNdTInqJwEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mT9PiB18/Cg/qE3qnXOXDPaWRAbCpDOC0LRym45un0=;
 b=F9XcdiS2DyLt0LfHJ2hiRIJGc50YNyNGHrSV9bZoTqChutm/ireZOJEEqfACuYEtrw5fltlauMNyX8UmUU0mbW9B0oWUA2x45JHnuJ70F//cthIAzPUTYH8q2knv5tx6YkBWZHKxeEceMUTdB7Yl05q5EOik/ZwlUAZ4PgD0Bnc+wRLA7PfRdgNA+kEnb0+RqUlTNw/K2rv0mUzwPySlzrDsDxwXd2CL1PI/cusb/eBZxO9SE2Qzw8POC04seFgYQDee5bylRaBpvuugcw2f8RbCxl38S/wyhjpopT3PFfBc+m56SqtYtS9P1226g92doC5oa5Llzn+4VYsfQCiVJg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 14:39:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 14:39:49 +0000
Date:   Mon, 27 Sep 2021 11:39:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210927143947.GA964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927115342.GW964074@nvidia.com>
 <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927130935.GZ964074@nvidia.com>
 <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:208:160::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR13CA0016.namprd13.prod.outlook.com (2603:10b6:208:160::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Mon, 27 Sep 2021 14:39:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUrnH-006MQB-VU; Mon, 27 Sep 2021 11:39:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1ba7ce4-c579-4150-7177-08d981c4a881
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB525651A982451D28C717630AC2A79@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2Hsj26+VN6W8NDmV+EmF/cMlqa4pLvpqkAh1zByvgKqUBNQrulbfBLXTF5/YBuATIjtNdKIbr3fCE2XmuP0yfZrfu3s7eqY0+O1D9n/wDu1FoZlUeLkjmM4ZnPxB7WV+wnJr1bJ8cNpzwt18PgWrZqPcgUMxA/E3j1sc69gZn/3IpagHv/Ptk6PGxp+ZfnPgK9qiGVDmMyGlrxMHJTW5BTiSSRWMxdPZ/932UV/gr74vjV1+Jtjh0o1Y4q9jOS5Oah1tsH6nmLOz2zt6pGMYG3nEaPn3j7yTzk1Tkr3XapEqYcttebKbcy4sXrPQfwtzfLl+ql2O5emsYPXbtipcTZqXKn01+okFvy1XM19fG6T9zyflIxXaKrIBNM6J/hTreBgyL9+FrE7QEf0ufLfX2HCmD5vsy/f08P4FvOl/G04HXdZNAQ1WQ9EMAfx0U1ivaCq68YOMAOiijrxExoiU1NQWuBAeL3Bg3ibiYevAcmx8aI9X/NQpge8X69nkJCwZI/ThiUStKqu+pyntjgY7wfPmrkpJCNDIpHgYIXjXbxwCPkxh0fLCjzgH7Z+xAQX7qye2JdJd/iyRwNb2U5lpwMprNOwWgJKjUbAuIKqlTQ4rXPu23rpDAsFcTmTgKhzLZq+s5EKve2yBNKoHxRZrltzXqneDgCzHRUCSbYZWXUd8JPQZQj0E/jZRhCiLOWQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(36756003)(86362001)(426003)(4326008)(83380400001)(2616005)(186003)(26005)(508600001)(316002)(33656002)(5660300002)(8676002)(38100700002)(8936002)(54906003)(4744005)(66946007)(9746002)(9786002)(66556008)(66476007)(2906002)(7416002)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tb+v8KPwhRmF1sO9p7noh99xjBwY8xEvQh5GdDTMpuO8K9VbGtaj+yQW5cQ5?=
 =?us-ascii?Q?g7WZkqWB96quK+gqLZR2nSAeOlfRsooRuFwZIoXoZrGjbqcOYQj8MyuZpeAG?=
 =?us-ascii?Q?n8h+xz/DkWQf7lH7KJGDli1W9TiLQE2CfAmwnpgsjNj9/sWFsUy7epR4b8MK?=
 =?us-ascii?Q?Yc8uXtQxZ2UcFm4Bs5pzmJKIWlX8wIVnlMKCOiW1qn9GI7vUMF5dLkKZoald?=
 =?us-ascii?Q?w29hNqwF3Buk5Cjufa3CUAQ6kVpWrYGYauC2j7Twluu0KYmSuXRMGnndada8?=
 =?us-ascii?Q?9MqXF8mVyB8IUz2CbQo0DcPLJFTq5/xnl/FzWIEftTbxKffl1C/9cuFkCU2B?=
 =?us-ascii?Q?jTdwSYzEEYj1PBPdw9skr1DDf8bUY/s2WLc+yIjj3greDFA3vadrgulM+3dY?=
 =?us-ascii?Q?wpxbRhdvAEzF7MkEYRPxzVEydPRs/MzE4gdsG2HMh1UT8Lbdi8oq0Qu0nemd?=
 =?us-ascii?Q?kG5UyXuei4QtgzfNwqZFVNhzIXA6J9cGn7sW6/sy28vibucoWfF1+wzTUkLx?=
 =?us-ascii?Q?iMV906jt0NRQG9c9WLB/eiHE8RK0G8P7jAdK3dOnSBZNzyN24lO2EYAPKag3?=
 =?us-ascii?Q?YN3ktRjedr4tUyXAKCXcAajfgMpM1LBE9LgQfbUJRamfhWdH+JmpJdcYZrWu?=
 =?us-ascii?Q?WzSMAnegyMhaYyYBB08k8eNB9oZPW5Eh0kIxn8pPcTIh4jG79Rbn3t9Z8WQx?=
 =?us-ascii?Q?BOsOL/M55mi1n3bOXI6Io50UydEpAaD/BWXhAjKlUCTrUJByfpoLv2rxkQn4?=
 =?us-ascii?Q?RdSzCvj8lWyCWlXQ39ZHeDAN5jEqGriEa7tXweajGW0tKl7GcKLUMyDgJlNZ?=
 =?us-ascii?Q?inr4mHAlZRva7vXK6obqcgWz7y6/9Ol9b1SbamK7Eat1jLeE3348sH2up+BL?=
 =?us-ascii?Q?qhJVO8LS9YYqrNbIEs8ebSnWz7Xe/rvp2ZLpxuWalTZ4vnk0UuCuvV1aTj9O?=
 =?us-ascii?Q?2S5+r3L+Z/ZYufbSRWH6clhsMRShRI5GueZe4TUgo6OI1LrqfkKVooH74p9T?=
 =?us-ascii?Q?2uomqH93oSdxKJh1sMVBAwSfWzcfZJOHAA76rlSK4le4kEq+KLDtYfA0z7YF?=
 =?us-ascii?Q?I8P/H6edr8aAX4FA9BOBIff+uS6gTYOKLtp49XygGLKnpc2xMeIyFt5JAM3p?=
 =?us-ascii?Q?mKDlaExb/Ut9fC+UN+6IXxt63wM3bz+Caw7PyIpBtc4CbVfD/fQ572YGr/1U?=
 =?us-ascii?Q?UWEoPXN6+VFIppahEild3+D+UBeAcva1HE2xim9pxfawcSYVXyq3jg9WQNq4?=
 =?us-ascii?Q?34GUI/EfAm8rMGIP3peleEaYfvZ8tVXEyAw00KP6ZHMc2PUEkOqhqGG/l23I?=
 =?us-ascii?Q?ERKqQ2BLDdAPqH5nzesoOQ9+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ba7ce4-c579-4150-7177-08d981c4a881
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 14:39:49.3161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zd5E1+qhj4GH0tMju1wAjWClkdRuUhqPjqMgAl+xILtxoeYw1AYuFPQVL/Y6gBi8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 01:32:34PM +0000, Tian, Kevin wrote:

> but I'm little worried that even vfio-pci itself cannot be bound now,
> which implies that all devices in a group which are intended to be
> used by the user must be bound to vfio-pci in a breath before the 
> user attempts to open any of them, i.e. late-binding and device-
> hotplug is disallowed after the initial open. I'm not sure how 
> important such an usage would be, but it does cause user-tangible
> semantics change.

Oh, that's bad..

I guess your approach is the only way forward, it will have to be
extensively justified in the commit message for Greg et al.

Jason
