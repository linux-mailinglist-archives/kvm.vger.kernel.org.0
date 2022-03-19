Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EAC4DE6EF
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 09:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbiCSIQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 04:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiCSIQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 04:16:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAE821D7FF
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 01:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647677691; x=1679213691;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Rz5l1xUdqu5g+JBV/l5W5/vpj6GAKUk3ylQ/U+VVyp0=;
  b=Omlnc9GH+v1XOM5tV0VUCPgWow7Xadac8eNi1GKU8I9WFvv7HnSNIHOG
   JZ5XG1NZyuXKKyGhdymtwM7S/7HUXLAb4wKvT8zm6NV/KDVXbBTjf7O2o
   mXKF3bXyp1UD48EpKdUhv+AfmCUMuNakYxh3KvwoM9l0nEoEjlOIyeHzW
   NN0nuOe8OQwQFYj1YPjsXV9G9xDBPl0cxYk2cUvlvhfArZ9nK5Mu5q4Hm
   2PBKWCMpeUyLusK8xmorx8h3axdRsiWvzxd306i+thZJq6wwefHv9Lvv2
   0pEmnyLabeEFY0QGGqn2qwkwk3hceFYPgTEbJJCUsLMzEIqi3tBqEpo0s
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="239444692"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="239444692"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 01:14:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="542288486"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 19 Mar 2022 01:14:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 01:14:50 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 01:14:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Sat, 19 Mar 2022 01:14:50 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Sat, 19 Mar 2022 01:14:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoEs2C3O8ARwQPT2Qm4By2YnOE6KFtcMabSXb+4VU2KQt5aD1ZYjouhCuQ1I2BB/fSTuxvAquxvq8e18QMWRP5dLjvXBw2n5UsLk2YJ5NfXAXcD9wY9+jlntROSze98cIxhmNvFZq5mXLoi9JWSvIRhwcndx/x+qoMWuzTUG6ra06R1lwEbWUrji1G8Ye07IdwGXNZctgnuQ/0WSfn6wTChWUsWK92rDeUH0y9hqmaUbhzqn5YdDoNh/t6tpd46BacLsX4/q8d4H+0DSbYxNyl8TxKARbbCabcapAcKkwZkRk9k7u8XLTUHtqRKSGBmpZ9cIjGx93SOHT7AZLFM6MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Phehyn8b4yQrxSi9jvhzKjgTWqL3929B1ZkCVdOATqk=;
 b=Y3tnK2SDu5QUWUIDGv48mh2yU/7zUir3zEy04uftJBFh/XIu5n8yWuWGBXuPxt5PGeQ6Vj0oXy3lAm6lowd3J53GaxJDJBumx6UfzdGpy70Rl8NCd01mj4GLc42zgnMC5u4G66oFVCGK81UQ/NabzYVWOyxtqmpZLAT2zppbh/GQuu0O5RwIDqZu7RMXBa9MpdRp/AF8pL4Elt5bf+tsnCtWzNjcmUmpVws+QQdDh2khAsnN7G8MyclfXud9eqXYWUUzseoY3cPs9fu69sWyuvx3sbQPLHmA97mx5wAD7JL7dVzd9gDspRaqUBCwPJwm40zWmVGGo5FyYctXhoIg+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1971.namprd11.prod.outlook.com (2603:10b6:404:ff::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Sat, 19 Mar
 2022 08:14:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.019; Sat, 19 Mar 2022
 08:14:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "John Levon" <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: iommufd dirty page logging overview
Thread-Topic: iommufd dirty page logging overview
Thread-Index: Adg5jKKwvNkxolKnRPWJ5nYfZVngmwABAPgAAEWHdcAAB6sPAAAoLtSwAABPxRA=
Date:   Sat, 19 Mar 2022 08:14:48 +0000
Message-ID: <BN9PR11MB527648E10AEA8C4C341B1FF98C149@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318124108.GF11336@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38134fe9-d7c9-48fe-28b3-08da098088f1
x-ms-traffictypediagnostic: BN6PR11MB1971:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB197101EAD8B2774E6D6A36D78C149@BN6PR11MB1971.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RNJ3jHFyOdYQFnwzITOgln6b/WHSqoMQkHX2aP/TzZoDs0uRECOdnPzOxR2QXa/vu7cESHY/aF19tPt/nwflMj6mm67LaEmn21IYRaqr8xE2MO5iIQb9TdHrWIUQ4Vm2eE8UXXEL98LiFTIYjHzRgcEtzN7XQxgCyHTAgiGHUhQS+4RRb79I7TGrITC2CI6CYBHEao+3KByA4dEDkS5h5P3SzgEK+hWw6Zf7IF7aFO+uPMV5tcZDSsnNfwGHcOmeszvKFxsahVX/veu9pQ7n15CbutSEOFxA3+wiIVFIYB8Fu10PC6nDzWbUr9XzPagV5YRbt3/pvCaRv4EE7IuUdeOVCR9xv9Upc77VHGyB6OioUZq4ZRuDGqmBzXRXBNGTiTDrik/nFYHj3jxP5QEctrw7d0Uzo8uOZ1htor682xVmHy1EfbLlFIRUuAnmJSYDoXFye2ywNuK49Wih/YiRDYmgSU7AnMAExbR+5ry7GQzvyV/ilzv51WtVSr+KPdgpwCbPAzgyjPzidA51n6gXRebHs+7vh+5tATmNTOSasmKRGHQIaZkdoDpoRIfCpDhW8WfT2fvq9OqajcEa5iU45vlQc9h4ewJFGllFpeXHyqm0cRueaVRfHYZyYO++KEQLwMwYhEj4BJgTWmvcKysEGVTZu0lsQbgSvYKSI45vgY6JNjfay117IaDuNLgx2RAoASzWlagk7EhKuXJPfT9SWkBoz5s1mTKho1TxrfxYGxs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(9686003)(122000001)(82960400001)(38100700002)(4326008)(76116006)(8676002)(66946007)(64756008)(66446008)(66476007)(66556008)(38070700005)(6506007)(33656002)(7696005)(26005)(6916009)(186003)(508600001)(54906003)(83380400001)(8936002)(86362001)(5660300002)(52536014)(7416002)(55016003)(107886003)(71200400001)(316002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yc9QokbklKBAwcRjF7T8pxx55GDUzQ9/Xq/YusPIrfJOIOskOUC74+lOaOPB?=
 =?us-ascii?Q?J5NppsUhujfY+1au/+O9OTS24Xs6s++Mtv4pYLtOis3A2ctFUD+DKldRB+vd?=
 =?us-ascii?Q?9JW+aS40kzVZf8eQdRCQLvIudoPV1jD4uZjSXCfd1F7/tG3nAHLUPO/FkkA/?=
 =?us-ascii?Q?v/K8lpWkUJXGT7U2bMdqDyxUfq9S/AgUk3TQ1vPpBdt+RiM0E6pvBOSRzrFd?=
 =?us-ascii?Q?67As/0SheL8cBSOEdmuH+TmF6p7Crq/pIbNCaVbefed+VqGJUN5XDn1RExo9?=
 =?us-ascii?Q?Pe9xp7TWu+vj5OsJkxOhaox3WgOnlwaMQQREwlvFE0SVpCrU9V8qwNkibFjG?=
 =?us-ascii?Q?RNljXLMbU70Ba0fmzA254YYLPAsOFlmo0JTR6hrdnA7S/MB4XNqot4agaHrF?=
 =?us-ascii?Q?NK8d30iHU5V+sx7iFH858psICNNk/amXNYktilB9zgzvUmrN1FWqWR4flMjB?=
 =?us-ascii?Q?+Y9gk1RGoaHL6JFryZVXR4u7l7LHR1Lpv9KrZ7nHbflrwxUqK2ukdXOZwNqk?=
 =?us-ascii?Q?65W6KG3npdfcgX3+EOT27l872GMyNHbzImDdI0ziQ+7/bCyjx4wXd7/piZvA?=
 =?us-ascii?Q?X69F1ErjFIVGuNOcPqF92DW13H7VnSswAM1QjcAtUwPRC6KjxoL/Pbt9XaIE?=
 =?us-ascii?Q?xb81ccmy9WxQgVs7qlvtLeucn4QK9aV+1IPDFRe9swoJKd6XfFaMA5Dskt+p?=
 =?us-ascii?Q?Cgk+8psA7aTZ+QpUZd/YAfLCBfXpKa14ujMEdVErNAobnwSZnk6z87p32eUc?=
 =?us-ascii?Q?pmbkZqoSbXIN8eULicyJA30Puiz3c4zmTa7aTxt3xQG9G3Ds8gjDisO63bxi?=
 =?us-ascii?Q?S/mzgO+ASOP3d+ccl0cjMJ/auWGpQgbdUcQ0L8ZYZbexODlE0gBJvNwSgnzq?=
 =?us-ascii?Q?irgsSWgD63LWBVy8xYtacE4beOu2AUZLNWbHUFr6c1bk68qc0ls/RtwfUHen?=
 =?us-ascii?Q?FH7mmaJrhiCv/lUB0lDSc4dI1avmLDEtIr/GKRDewnAzC/4Y8Gc9j7CSqtb1?=
 =?us-ascii?Q?QEi7XWmWnRioiiII9oNf1gyHdyW/wsYBYJZ8nSGJdImafZSfowOvHeixtgTd?=
 =?us-ascii?Q?KA3C+mjRaS+vvKFOI+YRlShf3zJDd0odHTMawGuB4vYTywVIKusthrdxZzai?=
 =?us-ascii?Q?hE7t16K16dly/lDgxLWPttWJ7hx2z+u9kl4EgukCeqPfbsQp0ln9oQUx9t+w?=
 =?us-ascii?Q?ODrxn2o+GH14WKvgJtTmL5lbBEjl5PR/gTmCbR3BU0kwPL5d4sl6nOO+lqPg?=
 =?us-ascii?Q?tFNdJFgY4+AORdZjNLRMme1LvIS8EjD9+FK+PtK0M1ceVufLsb90BHr7l0Ac?=
 =?us-ascii?Q?TwDrr+xXXGlSfe05amktj3QFMHAa04QFEUFZuCbFZeIusGZG64rnTX2SQMqT?=
 =?us-ascii?Q?tdA4DiJGUB9anKBWAR8X2IsQkgLxTZ1zpO1e5D182WHrO4BmkKo+p/YGAvYj?=
 =?us-ascii?Q?lHUtZuP1vhjVFmFcOIWz7PXBKSm3bb4k?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38134fe9-d7c9-48fe-28b3-08da098088f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2022 08:14:48.3379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OWoKcgIyPdy1/QaJaOwO3iCfU86HUBK04PCskJK9wPY0yE6LdqPN0Nd+VR98Jm9KsBrIaPwWlS+3Gs+iHYifiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1971
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Saturday, March 19, 2022 3:55 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, March 18, 2022 8:41 PM
> >
> > On Fri, Mar 18, 2022 at 09:23:49AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Thursday, March 17, 2022 7:51 AM
> > > >
> > > > > there a rough idea of how the new dirty page logging will look li=
ke?
> > > > > Is this already explained in the email threads an I missed it?
> > > >
> > > > I'm hoping to get something to show in the next few weeks, but what
> > > > I've talked about previously is to have two things:
> > > >
> > > > 1) Control and reporting of dirty tracking via the system IOMMU
> > > >    through the iommu_domain interface exposed by iommufd
> > > >
> > > > 2) Control and reporting of dirty tracking via a VFIO migration
> > > >    capable device's internal tracking through a VFIO_DEVICE_FEATURE
> > > >    interface similar to the v2 migration interface
> > > >
> > > > The two APIs would be semantically very similar but target differen=
t
> > > > HW blocks. Userspace would be in charge to decide which dirty track=
er
> > > > to use and how to configure it.
> > > >
> > >
> > > for the 2nd option I suppose userspace is expected to retrieve
> > > dirty bits via VFIO_DEVICE_FEATURE before every iommufd
> > > unmap operation in precopy phase, just like why we need return
> > > the dirty bitmap to userspace in iommufd unmap interface in
> > > the 1st option. Correct?
> >
> > It would have to be after unmap, not before
> >
>=20
> why? after unmap a dirty GPA page in the unmapped range is
> meaningless to userspace since there is no backing PFN for that
> GPA.
>=20

Let me make it more specific by taking vIOMMU as an example.
No nesting i.e. Qemu generates a merged mapping for GIOVA->HPA
via iommufd.

iommufd unmap is caused when emulating virtual iotlb invalidation
request, *after* the guest iommu driver clears the guest I/O page
table for the specified GIOVA range.

The dirty bits recorded by the device is around the dma addresses
programmed by the guest, i.e. GIOVA.

Now if qemu pulls dirty bits from vfio device after iommufd unmap,
how would qemu even know the corresponding PFN/VA for dirty
GFNs given the guest I/O mapping has been cleared?

This might not be a problem for dpdk when the mapping is managed
by the application itself thus that knowledge is not lost after iommufd
unmap. But concept-wise I feel pulling dirty bits before destroying
related mappings makes more sense as translating dirty bits to
underlying PFNs is kind of an usage of the mapping.

Thanks
Kevin
