Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A739791A
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhFARch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 13:32:37 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:23104
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233871AbhFARcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 13:32:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpwg/YXjzs6Q03JGvd4dXveJ+p/cxE0d8Ovy8eiKeKyQmP7Ni0TGMFVzhyuKFwhzXJiR0ZsVgjdohY/IEJL2ily3MRVJ8+ODi6RMGq1ntMtPK3cTgJyRduqfIttjj4RVHVxcytORlUjC9X0Jhge1yFwGfbiDFxIwKIx8GFTS0C3MjsRRLf2Ed44OTIP7QCbXFSt8oHsYTHy0eAbEMpWI2TI4AGvnt6UyAYujtXWX1tOJ77r2J3fL6Mru7H8qkOMuC69dOqxsk6On7c0VUOhuCG2O1VEOma/mx7zWlS3NNTBNVHnca2B8MObsgSGeZ6w09JeKdLaK31Y8ZGA0/2UUDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QwNAmBGxgXs7S+pu/e5X0ABNHiSYSjsBYkEl89XYKU=;
 b=i4ED2EXE/G/UdEMjLTeOEHse3zADQ+yciLShJBY5y0tcX+eZd+XFr8YbJZBRONd4vR2iZAb6RGqVmBXj9A/fJRXqYq5lvjUVyZg4oYYsAILamSdB4OsAOiMvmwcrH5nWne4NBkrfNfKMwBPU9jveXxJn7IHtZ8f7dn3R7rRVom1tfYNEBmctYrVWv5JCYatFLVvnC6hNFvp0AXa5gLXzRomNKpkYpH18Y9GP2qmhw4ospJg894eGjcUlSqItWcx9DHN5rE1lxYTOaYLoNGsnarLiwhuB2ddXcHIirdgB3g7IOKEj75IhppwLD/10cZWelrQ85J1163Dya7NDpBRRww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QwNAmBGxgXs7S+pu/e5X0ABNHiSYSjsBYkEl89XYKU=;
 b=MyzaLqdvxIq2rn25p0OA6+mlNbsdw8Y9bZAp0aVqgah2JHjgz6Qk9a69g3oeahMRhoWjS5C3LbdC81uYLhMQys355EMPvhDZ+Z+fOoMgS9NwsGjVWAOfdBy6josmhwvdheZE92xuIVBL08uv9P01MCwyv2IE1Fzq3K5IfKbNd2V/eqzA7rqM0W8yKB2rzzKXHUzlUM1clqaMpsm40RaoumGJRwAhy4XATFGytzhiQQr9uf0mmdCrXl6/fqV0jRcCfJ8IWjODX9KVfRGeYQn8fJR9tLqIfWS6eAOvp9qASP85m5Dv8l+re37ZMusBRJkyEG9di17v83BMYCNoeAEotg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5419.namprd12.prod.outlook.com (2603:10b6:510:e9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 17:30:51 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 17:30:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwEO8mWg
Date:   Tue, 1 Jun 2021 17:30:51 +0000
Message-ID: <PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.197.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fadf3c45-f0d2-40c4-79fa-08d9252300a9
x-ms-traffictypediagnostic: PH0PR12MB5419:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5419B4333BAF384212A47DD0DC3E9@PH0PR12MB5419.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1p5FZtPej9JS15M8X3To73AHBtoBmoLjPFzmFKhqoZrEfq9YankBXDBIsmjWBBi7DT0nNDkD5TFLPL9upDNHHVTNdOSeXJ/YnisBP0YzSRpRs5nUE8vAt5LAqP/bvmc2LeL6JIQCZs++C9v9R9f64KW7fCdZuWYqGPnstX9W7ypCmGgpkLWr9nvqm6jUaPYQbxNfEOtB/c33deqSztyJAy5ziFtQArf+DHu/UUbCDnb7FJavNCT/j9r0DSBUl9TVrYqPWCfYXw4Z+MOTGjG1XsEu5i61dR5RQg0txK9OYrwFqGgJ6/dCf0uf9W3lSseFVla9hnyiD/0sOhW6BMo15cA37wUy6OL/uY7oax6Ax9ULjy84bjJbF7TGhYJchEJEOJbI3JnOsE/xfdfsjPoelYj37qP4MINFmitV6hfciT9EKfgkuP9tCXSm0W9n5nQ7wzD7QHbdnUFklrMb0/DvOHl7rZ5kpG/ELKj7zKmLkQ61XQnKxxNHbycM3fkSK1TBOf7n1wbab2cVadSoRjJqf2OHi4IJH8Y9ccxjju1Z155T1+B3biH8J1uCMJ8DsSiZk5VSluIqiJPo6Ntguw+xPRK1foCb3wU0hPTO55BRFz0g2y/4gyMIIjZFk1L1ExxfLj4PNHL2uVNA39rwWYcMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(83380400001)(33656002)(316002)(9686003)(55236004)(26005)(71200400001)(54906003)(110136005)(4326008)(5660300002)(86362001)(6506007)(2906002)(52536014)(8936002)(8676002)(66946007)(66446008)(186003)(38100700002)(921005)(66556008)(55016002)(478600001)(122000001)(7416002)(7696005)(76116006)(66476007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FIxkAunrJrMUxBGxqN8SSFrEF9PKDLG96Jg8L9W+AM/bJFZJdbbDwqgZOYr7?=
 =?us-ascii?Q?UINvoTL3sUXu2eB8q2NWZXhBHCJTAokEqQSX1LBFBdYu7DSHbrONxklicGeh?=
 =?us-ascii?Q?oA9N7vN3GLeW+HiJZv1MuVEUqT/fcTXbJANmV/FkDxSjuxvocM75fzB0lAPs?=
 =?us-ascii?Q?+5nH2xvcy9NMQL9E53IP2kf4vXeHb7s2vnsHl5eEo5kzsbAGTHSOMsaqMCDm?=
 =?us-ascii?Q?YgDIPeTKjZcHkTMtZAqKYE1xS/1C9bhhV9mUx7dsPSKtkhaXBTGafvZQsff0?=
 =?us-ascii?Q?tJPxQZs7/xUjPJw73F5swqmU0QqA18jQYIY9dV0RAu/7aw3v67hj2YVw1XqI?=
 =?us-ascii?Q?rNI0mjqFWW955y/f7UF+be4Il+LTLslF0McyDxU7rjbylUrqwrocMBWpNWEo?=
 =?us-ascii?Q?FxhmVS/a8Pe6dGuu94pm8MfkGPcfqWvttFMA2eXGbXxy/CRyQP9+0llYmy76?=
 =?us-ascii?Q?AV/ICoCjdFhoO0NuE1Rxu6B82BnBjw6zQAkLviM7pPuaI8d2Y+MZOi78YdLj?=
 =?us-ascii?Q?qpgteNOmoFtwC13kJLScGHJPoCNX0ZoUck9v3aE1DQoGK+ADozoH/femJR1s?=
 =?us-ascii?Q?xH7pBtARJejV2TBbKzmae0QckTOpNHwj6uqVjcKndjBfASPd4+Py5nU2cdlv?=
 =?us-ascii?Q?deUOZC2GsUA7iaVeFdKnxKzLkTZuy+De6mhui173I43h608unUaxHMYa8/UV?=
 =?us-ascii?Q?Zvf0vWjxNPKvd/ROUdhPptemauLKYlDqYafocG4k4WpSeno/snYtVu2loLjT?=
 =?us-ascii?Q?z7/BO6RdCDjqMfGfkPB0X5fRCWpIf1Nc6np7O6LcKofxXmDNRB4N3w+g/2ie?=
 =?us-ascii?Q?1/aneSvYC5GiryMlZqqJbG8nKmUmcfKFQHyIyhcg7pTSf/EGT03etLIweoHJ?=
 =?us-ascii?Q?x83rj4qAF4F76Z6V/lb9zPsh/QJGhHprV/RkT5sv99KTWU9NRqG74MgYI8FF?=
 =?us-ascii?Q?9O6u4GwZcPpMPHJoX+r9Xq7M77edPTV0sQgAOWtvtDdS7Ndz7AdK85zSEWcd?=
 =?us-ascii?Q?iJkXll+9Iugc7899KKV5JrH7uJzFODiqrSOvyn7yPMIYb9/QOt6o/068edjg?=
 =?us-ascii?Q?9qsT1YxhU+jgHebpBnfMePvXwdVCtePK05uQO9LyeSor/nW4huihOExXNC42?=
 =?us-ascii?Q?eBcJKBqU73ALmneyq4FF1ofBzI5v/KwoAjQOx1b54nPcf13wwl5ZoLkBEV7z?=
 =?us-ascii?Q?PJlQ+O5EKDz8UW3AgAmT7WDHFq0yZ1hcVgc86B7sADJ+jbFHCJXxfmyxXThO?=
 =?us-ascii?Q?dO27gHGaHUnSNUzrJC6VhxgJwq2voCpRbNoGemtIwaJEKa4vq5OkTlPtHVbd?=
 =?us-ascii?Q?nqrV59vKJ8zZJIIRhayEr0p2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fadf3c45-f0d2-40c4-79fa-08d9252300a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 17:30:51.2983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FpkGxyUXwWXPh+RzItkB1EUQUbiDeZ00GxValMX7t6o8DLYzLA56sQfgczmsXnQbaqMh59fE8MlAoQbDyU2N+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5419
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, May 27, 2021 1:28 PM

> 5.6. I/O page fault
> +++++++++++++++
>=20
> (uAPI is TBD. Here is just about the high-level flow from host IOMMU driv=
er
> to guest IOMMU driver and backwards).
>=20
> -   Host IOMMU driver receives a page request with raw fault_data {rid,
>     pasid, addr};
>=20
> -   Host IOMMU driver identifies the faulting I/O page table according to
>     information registered by IOASID fault handler;
>=20
> -   IOASID fault handler is called with raw fault_data (rid, pasid, addr)=
, which
>     is saved in ioasid_data->fault_data (used for response);
>=20
> -   IOASID fault handler generates an user fault_data (ioasid, addr), lin=
ks it
>     to the shared ring buffer and triggers eventfd to userspace;
>=20
> -   Upon received event, Qemu needs to find the virtual routing informati=
on
>     (v_rid + v_pasid) of the device attached to the faulting ioasid. If t=
here are
>     multiple, pick a random one. This should be fine since the purpose is=
 to
>     fix the I/O page table on the guest;
>=20
> -   Qemu generates a virtual I/O page fault through vIOMMU into guest,
>     carrying the virtual fault data (v_rid, v_pasid, addr);
>=20
Why does it have to be through vIOMMU?
For a VFIO PCI device, have you considered to reuse the same PRI interface =
to inject page fault in the guest?
This eliminates any new v_rid.
It will also route the page fault request and response through the right vf=
io device.

> -   Guest IOMMU driver fixes up the fault, updates the I/O page table, an=
d
>     then sends a page response with virtual completion data (v_rid, v_pas=
id,
>     response_code) to vIOMMU;
>=20
What about fixing up the fault for mmu page table as well in guest?
Or you meant both when above you said "updates the I/O page table"?

It is unclear to me that if there is single nested page table maintained or=
 two (one for cr3 references and other for iommu).
Can you please clarify?

> -   Qemu finds the pending fault event, converts virtual completion data
>     into (ioasid, response_code), and then calls a /dev/ioasid ioctl to
>     complete the pending fault;
>=20
For VFIO PCI device a virtual PRI request response interface is done, it ca=
n be generic interface among multiple vIOMMUs.

> -   /dev/ioasid finds out the pending fault data {rid, pasid, addr} saved=
 in
>     ioasid_data->fault_data, and then calls iommu api to complete it with
>     {rid, pasid, response_code};
>
