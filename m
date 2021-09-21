Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D31413E2A
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 01:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhIUX5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 19:57:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:4790 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhIUX5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 19:57:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223529940"
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="223529940"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 16:56:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,311,1624345200"; 
   d="scan'208";a="533499833"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 21 Sep 2021 16:56:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 16:56:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 16:56:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 16:56:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko6DgvZmzGgZ85QiBibKWZJv8zjFuHaSP6D/IlhncyRhI0+PaQHdhcRo6vxEiojIH+TL6GgbGyOWPdMAsR2EZ9F/+WWaclB4ByLhOlQGpsBvPwCed8hwv7mVgd2utkuaNFEhJhVc5GCN/1TtN+pmUP6VYdDD5+ZWjHDwDhCuN7e+0Ya5WwwdW/5OVkDxsi8eZCpa10yPv0nUCivd9EmIZf3c2Y9DxXbExQ65bmwh0C0wbeYx/dPzFUw7UPZ/5zx642WLpY/R+nrjsiRMdjuL/TgLH5AIAHV4SwoCTQjeETeibj6uhmeo9QVepynEhe/w8WMAsN3poHn3BhHrVQdVhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YZJCGR+ZAXiL2Kp+7TlxbNkx0Lw5h8j8iwq6vcpm5dY=;
 b=AtBwBmHqBMlS06C8PPg635sY81qkOum5WFjbSZmDkh5Za/lOlvXBchbfcYDk3ii1EVulNwlsrf77/efzf7t9Ic27rBKteGlUUi4rD6E8WKAbEuuq/1ZJAJAU9KxsfeMYfoQl+DoaDkLpvnvxGt3u8DpVGT0Eqc35vaf+ynb4kD2AeD93we9OnOdmust5C4/cQr1ZwAvbcrtOVlLClxnlAqiXOCayKp0ynLKBWreYd5xP4D3hdFKwtFW0KTBy58PVAzVo4KT2aBlZHX7a7U1HshZPmXcezCiBQQ4z615Bu5qNmtjnretmFWsG3Dwu7yNB87KgN50oAJS210XRATxDEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZJCGR+ZAXiL2Kp+7TlxbNkx0Lw5h8j8iwq6vcpm5dY=;
 b=TAYbqBls1LX9dU2HHTL4Bni1my8QxctNbkLB/ebpyO9gnfJmul/Q2+DRkNXwnmMG6ZMj1W7KRLsBbMyWcr51euIhcwHo7e2OLTnUTEhVAKcdVn6DcdFW4wV6W+MW3nfiUzavpEoPgRKt7x6jTkHdJcta5Nt8TlSu6A6kfyAOl+k=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB2018.namprd11.prod.outlook.com (2603:10b6:404:4a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Tue, 21 Sep
 2021 23:56:06 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 23:56:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Topic: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Index: AQHXrSFvz6zvm2xHBUaW/Kl+BWVvQauuqGKAgACCWyA=
Date:   Tue, 21 Sep 2021 23:56:06 +0000
Message-ID: <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921155705.GN327412@nvidia.com>
In-Reply-To: <20210921155705.GN327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 929ec524-fb3d-4899-a949-08d97d5b60c5
x-ms-traffictypediagnostic: BN6PR11MB2018:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB201814A23D61B188AA9A2AC38CA19@BN6PR11MB2018.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qgVl3NlSL7WULDSbVqMFBmTRXa5tqvhnp8m2MfE0/az2KAzXbvg1LMISL+Lt2haGLKQzESIt9d/tVXZ+M4WwXxnzKeLg0swNyiNdmFqeB7C6kl8QyHQOskG9Z8x/Yfz8gOt/w25NhqabtduV6qYuID1YYshQ59bZlFvfjKMDZFaY0jurAv1gghvyoe7kxLBUuqtxWyfQ9EUH053eX9JKdin+Wwc+hm+S9fmv/H6Slil+pTahFAwEEvWaItB39gMv4onc59ORONM6YNTrq2tnaWPMRtciZ5G+Q/hwbKjwUxSEOlocqCLdevwcE6IfY9+Wm1D2RRiiI+PYIyCR1E3PvCRjRs3bAjeT+DSS1JyQmHTEwRyGqXhfYyuckms5fUGHe6jVTIVlZAEZsV2Fp1CuvXcliBx1Iks+GMEN66/dfThynPSQi8qZksjqKnuLCib7+1HBzUVJzH8nEZgUihnzhpPrdxXUrn/IwBHLOUnluSs5qLstZZjG6tXcq0IenFyfMVW6pZoBl6Ygy7wqjQa3VBbRFkYpSrQZK1jmn0FzrPTsi+6gLrjjjICQAZHEIqM7YNNbQKNnTp/hoRFBx1bzlXh/Tp5gIrAZBgDJgoHuGx/YCtqXEsSfCeEbHEXsuUberDXIZsiK6Vn2YaAxBx+qCSqxIOjkOhidQI841qG3CvCMwHzLBVtH+dLCzy1vfOVLjc8x+/CneYss6qBrKD6mWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(33656002)(4326008)(508600001)(26005)(122000001)(7696005)(71200400001)(110136005)(38100700002)(5660300002)(66556008)(9686003)(8936002)(186003)(86362001)(54906003)(7416002)(2906002)(66476007)(66446008)(64756008)(6636002)(83380400001)(8676002)(76116006)(316002)(6506007)(52536014)(66946007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Urv1aMhxGgcWkF8iDxXX/OiYCox1FJ2V/osZL4hbktVMPhtzPObcEnh7Nq2?=
 =?us-ascii?Q?q6Q+qnnGgcEW1PJzKNqQf/rWJHN1rtHFz8iDUJ7nu2ErarNGDcWZlLnVQSuW?=
 =?us-ascii?Q?gN65G5map6GcOIXADBrNKzE4I2BrH5l5nAil7zjiRMFUH7tfZSSjNi8j9PUN?=
 =?us-ascii?Q?bOkZrc4duu28RV2PZyQLNtGt0A4kYW5izGu7DU9Up/UkH8Wwfb9sNQzGdJm4?=
 =?us-ascii?Q?YlcfDkjvVnlxqNMHmvDMOiWeJVNEUu3ul8u7doGgmem52JVYnw5ggSl45l0/?=
 =?us-ascii?Q?T5PhldkeustHw4PNYtzvoEl3Z16AckaYkixzSOW5rk94m20pwO6iFaNOlzPs?=
 =?us-ascii?Q?UH9YdWj1Ktegp9ycCmtTsOsIAB7BBdUdPRDeKcvkSnwwup7Omb2ihyaVF0BC?=
 =?us-ascii?Q?W8j8lQ12EqhYBgvoFyOKsXdq7MS0ErTqjtp26ozOc/uQy36lkprBbn8eyaJw?=
 =?us-ascii?Q?0owGrb16q17R9uSYrjhciyci5HFKKoOqUpjQdRXfcng9hQUrryCKJ0UzPcZ+?=
 =?us-ascii?Q?Oz2s3/c8vMYGBjmSrFYjfNtdLVh7RVVx9yNZIaetgoV9SM/cXr5WinaQ3SGJ?=
 =?us-ascii?Q?3sg/JN0M9SnbflmVerPBac4YFMn/z5qU42yJos3lHagzgyXE8FZV8qxCRgzs?=
 =?us-ascii?Q?TMwaZyBHyO+Fq9xDuY6SYS6M1psdBNGNwcn1WrH6kbNiXM2i6oKGyK2CWIEa?=
 =?us-ascii?Q?Ca5zAohxyiXlEAYg0jVLBj7rvEOpgfShPVbjlagX9YhM/ImHWNEiRUCMSPQR?=
 =?us-ascii?Q?SSMOFk5oMRp1ZDNsY0/oAUvO1NkKmmq+cO/UNKDrUl2LKHwBajC+hzNTLvgN?=
 =?us-ascii?Q?SCym2t5dOp38X+nJfwtiJUOM2pJD8DpPTz/0E5Uqvq7idiWodg1TL9KM/zWb?=
 =?us-ascii?Q?7g17mooZA7RetY5yY8IghsCbY4Zih5NkgU1Hbxu6qXO8wfYtyb4qh968SwRL?=
 =?us-ascii?Q?F6xYBzHOxJgl/DYo6zInlXH8bJbZy+Y4VYQZRpjlNj0WRXE00TDIYL6XVgMr?=
 =?us-ascii?Q?AFl7Bdn6jI3Akobgr1NN9GO6cRTCqEGODxjloos3d+RPhzVMjSr0tjeWQEX8?=
 =?us-ascii?Q?3aVB4TfdSicvtTYHjQHdtxqt+Bk4ARnmNJIsPgULflptl3BV4NePVNHpOm/a?=
 =?us-ascii?Q?dz/6GFCqnbeysNffE1nGc0f9bOoPTLt2Oaki/MxKWiB8JXUH+9NxQ3KWxqfE?=
 =?us-ascii?Q?00fMHG7pqRG9fIQQNTisYop+WSW2cOoBQ+e9W+INmTZtbjx6ldum7EKB+oko?=
 =?us-ascii?Q?pX422O6K1oz3Pib2fDO9BXLlNKHFYfLHq7iYl4TwLt+PDAh37MREJ7WDYbCi?=
 =?us-ascii?Q?oCI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929ec524-fb3d-4899-a949-08d97d5b60c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2021 23:56:06.7000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SfquCW+fxlGZQ7IQXTuItZXV4BDMElcFx2eKb1rs9WoAJ0otHQU2Cn+dyLnqKkSU2TizClh9yGAwF1HAUd6jWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2018
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, September 21, 2021 11:57 PM
>=20
> On Sun, Sep 19, 2021 at 02:38:30PM +0800, Liu Yi L wrote:
> > This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
> > userspace to directly open a vfio device w/o relying on container/group
> > (/dev/vfio/$GROUP). Anything related to group is now hidden behind
> > iommufd (more specifically in iommu core by this RFC) in a device-centr=
ic
> > manner.
> >
> > In case a device is exposed in both legacy and new interfaces (see next
> > patch for how to decide it), this patch also ensures that when the devi=
ce
> > is already opened via one interface then the other one must be blocked.
> >
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio.c  | 228 +++++++++++++++++++++++++++++++++++++++----
> >  include/linux/vfio.h |   2 +
> >  2 files changed, 213 insertions(+), 17 deletions(-)
>=20
> > +static int vfio_init_device_class(void)
> > +{
> > +	int ret;
> > +
> > +	mutex_init(&vfio.device_lock);
> > +	idr_init(&vfio.device_idr);
> > +
> > +	/* /dev/vfio/devices/$DEVICE */
> > +	vfio.device_class =3D class_create(THIS_MODULE, "vfio-device");
> > +	if (IS_ERR(vfio.device_class))
> > +		return PTR_ERR(vfio.device_class);
> > +
> > +	vfio.device_class->devnode =3D vfio_device_devnode;
> > +
> > +	ret =3D alloc_chrdev_region(&vfio.device_devt, 0, MINORMASK + 1,
> "vfio-device");
> > +	if (ret)
> > +		goto err_alloc_chrdev;
> > +
> > +	cdev_init(&vfio.device_cdev, &vfio_device_fops);
> > +	ret =3D cdev_add(&vfio.device_cdev, vfio.device_devt, MINORMASK +
> 1);
> > +	if (ret)
> > +		goto err_cdev_add;
>=20
> Huh? This is not how cdevs are used. This patch needs rewriting.
>=20
> The struct vfio_device should gain a 'struct device' and 'struct cdev'
> as non-pointer members
>=20
> vfio register path should end up doing cdev_device_add() for each
> vfio_device
>=20
> vfio_unregister path should do cdev_device_del()
>=20
> No idr should be needed, an ida is used to allocate minor numbers
>=20
> The struct device release function should trigger a kfree which
> requires some reworking of the callers
>=20
> vfio_init_group_dev() should do a device_initialize()
> vfio_uninit_group_dev() should do a device_put()

All above are good suggestions!

>=20
> The opened atomic is aweful. A newly created fd should start in a
> state where it has a disabled fops
>=20
> The only thing the disabled fops can do is register the device to the
> iommu fd. When successfully registered the device gets the normal fops.
>=20
> The registration steps should be done under a normal lock inside the
> vfio_device. If a vfio_device is already registered then further
> registration should fail.
>=20
> Getting the device fd via the group fd triggers the same sequence as
> above.
>=20

Above works if the group interface is also connected to iommufd, i.e.
making vfio type1 as a shim. In this case we can use the registration
status as the exclusive switch. But if we keep vfio type1 separate as
today, then a new atomic is still necessary. This all depends on how
we want to deal with vfio type1 and iommufd, and possibly what's
discussed here just adds another pound to the shim option...

Thanks
Kevin
