Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4676F11F5
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbjD1Gu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbjD1GuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:50:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36B43581;
        Thu, 27 Apr 2023 23:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682664608; x=1714200608;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GYyjodpnhRELZrA2RpETUdo/WfGjcgqd5Fy6aVABD08=;
  b=F7UAHTtnaKiHpQJeWSrufMy2UZFQqAULvOGi7vjOjnO/QzdXD6LuRZ6+
   2BWWLHV/0H9c08lLnk8Dye9auaN83Hz6fbThyjPJe/7fEmZrrG1HhmEwK
   JiIehDTy1hUeJxivgmV/8JtkB0TOhb1QFKNehkOK20Ixc/4zP9m8H1yy2
   ehuhz5f0wvfhtpDwsPazYhABQbU32X5F2wL/TaAdOPs6u1+MOkNqyNWvw
   u+7MSLB/+Pv2CYCxi89Yg2w7lxWq01vvQMULoaEK1pYyV34eTmLj+9k9e
   JRyRyF/GQW7jtZ8Ax4j+71C5eW3Uh83N7NQYD6uBLMbmxdI0gU0qSQfi2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="345120190"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="345120190"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:50:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="759522630"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="759522630"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 27 Apr 2023 23:50:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:50:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:50:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:50:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:50:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRgBQVTXMNHV07hdKJgaNqfrKI47VNmZvapJWJ9TmWQpl1v1IY7Q/Fs6TyHgx3PhBEXuV3sw4Di3C7IgxDilQTaqaNKPen2tWhD7GdAEsodUbENxSodUq90b2VrEaJ+4u1xZHkEMDE4ytV4JI3C1bSfwI9Tv4pbZkHvrpovFKuWX7dJEnt+ye9zinLs9yP64C7KdUpfKto7aFPKd/170AEBXkf50DdVrjuqGIzacXibPE4jkwbf0RC4RIJuNn9MEpBx0zovyedzGPSgSiBA5kHPl6JHhTX9dgyllX1J410wLqV/wu8bNKUm2aOL4pjCSJcQBHZm3Nu0oEcsEYwuMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHVHoemXhhbaRp/sJ9GOvI1flaOQ0CdWCP0cEmdWSOw=;
 b=E8m8HgM00kQlkTKbhdPRnyTINTsiN2d8DXaF81nHhRMZ0zuasKM1Gqj4jF2LIWLUlhFjrAh/N72wg+EQkyv8TpZYg5IjA3pRCtk1PgyszjH9BDkk6Sc4/gxDEBRMsrl+vYSyh70/iSSUVPU6q2QtKZJY/QXVnIAOFrbA+ivXGukpaD52XXBqhvNF8FQiL2SVYgQJegNKY2mQ3keM0l9KNnUeHjaPoqNop54w4a008zr6Wwsm3NtWQzua4glv9mBzju7J7l9e3WIFq/INlxrl83w7kqP2tXWLFsgsuOG4p9wdIjaS1F+n0K/KMFBor0ABbTLIXGezSl2YngSeXZ0jvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 06:50:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:50:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Topic: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Thread-Index: AQHZeS7NjeBSeWLT50GaZQKxGXZCA69ARxSQ
Date:   Fri, 28 Apr 2023 06:50:01 +0000
Message-ID: <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BY1PR11MB8126:EE_
x-ms-office365-filtering-correlation-id: a77df410-10c4-4b9d-71c6-08db47b4ca00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dzt1vF0cb08GLETzKgQwC5+Kq9XKhmG0lWrS4NnotLYtdU5BiUtnYrazxKACMd16Ygi9b53PXhRHc5IGhWLsVgErl8EK8FZ2laTe4QMDl/3+Y5DYxefidYVJBghs/+Tx0CtkJLkjcl1hLxa7A9esnwCfeUunkofaEtzlLuTAoTxRhYZCe65C1V0MCYxkzyCXVxEz97WApgcmk5z2XW7SPwcqXQ1Td9yUbtaSLW1PzMG846IKbb/KNvbxxWTMpjc8VSXC/C1W2KcD1HUimV9GhINA+SeFQoCJpeQ8WzBvYlE1k4zQ83dCTJ269F2kKM+kB9IhhKzJsbsMKAm7Cjns89oXlcSiNal06Cw6ZFMZ9PGbObeQvbhqHj3YRcnHT5nC/ECjVJ9fzyiNfg+NnBAdpP9LhOMQ6H2FYxznZ2rJTYrjXumV1439AK0IIp74hDe+VvTAqB9/Y6v5gCvcfs8PXjit/2xJoSBY/k/ShGYOYyqbjIq7wrkdHJc09Ns6VAbnkQ0cMWngk4cbpi3Hg5H1dz4zintSXf3jSCUAlq1mgVzlWCvduTjxrflrvhLvvkDHTRXB5YqubLHXijd2RvneSjEGvMxib1wCjH6sHbG69fVSf4N35Yegis1oE+9j4Y8A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(66446008)(66556008)(316002)(66476007)(4326008)(110136005)(76116006)(66946007)(54906003)(55016003)(5660300002)(82960400001)(52536014)(41300700001)(8936002)(64756008)(8676002)(38070700005)(2906002)(38100700002)(122000001)(186003)(26005)(6506007)(9686003)(83380400001)(33656002)(86362001)(478600001)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4ONkRR2gxpkwrdOWzKUfljuLf+rNGxbMyhk04uARta4dNIPp3g+qyzYJVNJy?=
 =?us-ascii?Q?AEgCyGApfYJF5wrL+yZGD03Piww5ooYHzX3DeVyEdwNBDT32pU+VPoc+F3O2?=
 =?us-ascii?Q?qDF+x0HZXDEJhasrZz8mq7P612i5wSit5Zln1uwXRH15tNxOZ4gRGjsuvWDq?=
 =?us-ascii?Q?nU9HMi5wlbDlmHrVnMUmK8IMedisPkp2yyfCy/EHMazQMMffKsAKs+4V3h25?=
 =?us-ascii?Q?0yzxS8zNqgGe9qKL5Mn+JuuQ7JnBHj9IrCM+oWJ6rjOPOhbuvJ75F6YlwqhX?=
 =?us-ascii?Q?oif7mqhG0GRVHACkdjDtDj6IWsLBa6uuCkCnK9HSgqUCkwdRhRjgKuiVq5jV?=
 =?us-ascii?Q?7BBkORfew9KkXaOAPar0Op4SLMRMF1j4V60j72HtJNekFf+SNRB4Id+1A11g?=
 =?us-ascii?Q?ft8IJxLlGn68zWF0BVkcULCDMR5UGruElbxLl9BY5+idbwSdek7Cj1gaRyzy?=
 =?us-ascii?Q?rY2ExpCm+UsKYdlxN8glfyMKknWzdufhk/L0CyYTNuS/p9Opg4jCJiRjspYd?=
 =?us-ascii?Q?mWQZpE/Gu7CCExMM0e8cFZkHE3nRcRwX2s6EczMUGJxhHk4mxWUrlcnOrXAo?=
 =?us-ascii?Q?0zJK30m1/1U51JUIpPXGooMeLJsrqdV/NV5mFI332MT5xif3VPtkpmDzxY7m?=
 =?us-ascii?Q?JOlVL8OqWHsT0/lhlHBuByt/ha4HKMA/3VSgePyj/4MbOBf2ZvHtfOnB2iZX?=
 =?us-ascii?Q?/QBgiQ3IzkxbXE/5BfYH3Fg+7KwVehPmwzlknG7r7cK1uKkaicF5bcIZZv6d?=
 =?us-ascii?Q?I3wSL0dYSuYPA7To4nj+B0Eec59BERWTSVWKaPNdsiubNELXlwoiw/jpHMLB?=
 =?us-ascii?Q?S1FAsYnyF+rjKf3DRlzt4ghj+FE2M4jBgAh3UdOi6YSp5gLKkUzuBEYKfVfT?=
 =?us-ascii?Q?YPK6MyG2iPffnPvdWL8lnrqJ+RG9N+cr05lYLFDKRz46MrrdKPz6W8ui88Eb?=
 =?us-ascii?Q?Ff1POB/pxmHgF2HJp0i7cDlLOEDflLlgMkMA4HKRincHUlqD/TjP8anDhQIS?=
 =?us-ascii?Q?zY/zRBP2Qz2DZC5VVKJl7b2WsLXDgoLKxGmGEz1bMRXQxSAAKYoWxD093OHF?=
 =?us-ascii?Q?D/55dA2n9e3KzSg2IQg0A7hXCgqSAD1PRCF5CTrQ884cGQFljwQidc9HR+6Z?=
 =?us-ascii?Q?jMjyH93roAH6EIH47tMGQH18l77mhQmLS2REaj+46utUW0CZnc2FxfzTa51Y?=
 =?us-ascii?Q?mZl1KpTPzd7NHbiOduVSdce/61On+8etGy1srfFB0V/fJURuoZV9PRRjbWk5?=
 =?us-ascii?Q?UFWp2esdANytiXL0/C93w1Nc4jEh+utrWXfilxuVrLoM8M1bzepB7vn37K5k?=
 =?us-ascii?Q?nwKSwY9G6uiqvp7/iBxsMqJkcBqYwvdxO4FPOjWv0g53L68z21QnggvnAVLX?=
 =?us-ascii?Q?fmsubEDLGAAtki00Dk1dxWPnOn3o0J3v//vOm03uUyQEcXmMRyYT3OvkPPGb?=
 =?us-ascii?Q?oo5SpK6ivovvBySZCzOBCYrycYUeVM8dGoCRAJVYUoNcz7Hkp+9wasqF/UIZ?=
 =?us-ascii?Q?r0fNgH3NF+79r7zXwq/P7PVIE1EuvF05SlvH5dN1NnZr6UqRS/eIAuOiq0qV?=
 =?us-ascii?Q?MTxkix9mxLsNYuWyG8OxgrQrHnYknMonM2bOJIWx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77df410-10c4-4b9d-71c6-08db47b4ca00
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:50:01.1731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3/QHHhogde/o4KjVTld8AT6OaLwauhGAKx0ONq/aXXmpVdtJM51wS/6WTmS7v46PMsrqnC4ELZYJptgU/pI7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> pci_msix_alloc_irq_at() enables an individual MSI-X interrupt to be
> allocated after MSI-X enabling.
>=20
> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
> the time a valid eventfd is assigned. This is different behavior from
> a range provided during MSI-X enabling where interrupts are allocated
> for the entire range whether a valid eventfd is provided for each
> interrupt or not.
>=20
> The PCI-MSIX API requires that some number of irqs are allocated for
> an initial set of vectors when enabling MSI-X on the device. When
> dynamic MSIX allocation is not supported, the vector table, and thus
> the allocated irq set can only be resized by disabling and re-enabling
> MSI-X with a different range. In that case the irq allocation is
> essentially a cache for configuring vectors within the previously
> allocated vector range. When dynamic MSI-X allocation is supported,
> the API still requires some initial set of irqs to be allocated, but
> also supports allocating and freeing specific irq vectors both
> within and beyond the initially allocated range.
>=20
> For consistency between modes, as well as to reduce latency and improve
> reliability of allocations, and also simplicity, this implementation
> only releases irqs via pci_free_irq_vectors() when either the interrupt
> mode changes or the device is released.

It improves the reliability of allocations from the calling device p.o.v.

But system-wide this is not efficient use of irqs and not releasing them
timely may affect the reliability of allocations for other devices.

Should this behavior be something configurable?

>=20
> +/*
> + * Return Linux IRQ number of an MSI or MSI-X device interrupt vector.
> + * If a Linux IRQ number is not available then a new interrupt will be
> + * allocated if dynamic MSI-X is supported.
> + */
> +static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
> +			      unsigned int vector, bool msix)
> +{
> +	struct pci_dev *pdev =3D vdev->pdev;
> +	struct msi_map map;
> +	int irq;
> +	u16 cmd;
> +
> +	irq =3D pci_irq_vector(pdev, vector);
> +	if (irq > 0 || !msix || !vdev->has_dyn_msix)
> +		return irq;

if (irq >=3D 0 || ...)

> +
> +/*
> + * Where is vfio_msi_free_irq() ?
> + *
> + * Allocated interrupts are maintained, essentially forming a cache that
> + * subsequent allocations can draw from. Interrupts are freed using
> + * pci_free_irq_vectors() when MSI/MSI-X is disabled.
> + */

Probably merge it with the comment of vfio_msi_alloc_irq()?

> @@ -401,6 +430,12 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_core_device *vdev,
>  	if (fd < 0)
>  		return 0;
>=20
> +	if (irq =3D=3D -EINVAL) {
> +		irq =3D vfio_msi_alloc_irq(vdev, vector, msix);
> +		if (irq < 0)
> +			return irq;
> +	}
> +
>  	ctx =3D vfio_irq_ctx_alloc(vdev, vector);
>  	if (!ctx)
>  		return -ENOMEM;

This doesn't read clean that an irq is allocated but not released
in the error unwind.
