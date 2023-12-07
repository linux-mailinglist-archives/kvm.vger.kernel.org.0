Return-Path: <kvm+bounces-3824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7618082E0
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 09:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A8B41C21B93
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFCE2E641;
	Thu,  7 Dec 2023 08:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHjMXZ+D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042BE171E;
	Thu,  7 Dec 2023 00:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701937380; x=1733473380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a3P1ITBA2KcXu7C6krGKaYwwSWVlPYDFSmgk28x0pqY=;
  b=SHjMXZ+DhAJzLuZSTe2fO+I8W/bRA+IagLSOo/ZOMgKqBZUKplBhkEKc
   bN3QrzO8m3/zlMYiMMru81yjGziOhPsBEWR8cXbDnbVann7bxXtljeEKN
   idVnw7pAfrrpNaFu8nPpx9F3zgKgDDb1Cq2EYp8wjs7C+0/jth2b9GXX2
   BOy+GbeoahOV5jt5ZDQ57rK3+S8UHP88USXLK8M5YPWUbWpzi14q1UFka
   FdkYCufRWjwpOHVOVX1+X6DF+YiR7beuFXfbFnd8pxfXlf81c6z9fsYqS
   9MUYIhKiFS/9rJlhWhrpxo7FlMSL2z26HRKGSo5L/nvCnA4h10BoZmuPb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1301298"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1301298"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 00:22:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="747892097"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="747892097"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2023 00:22:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Dec 2023 00:22:57 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Dec 2023 00:22:57 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Dec 2023 00:22:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSUs6QP9OYLdiJDvp4O0Hdemvf/XxUd5xjsRTIBigzRLTlyqsJKjk/hZqPiEj+73zrbYHhLzt1V1hIeIYiIclRRPAT5k60SukiqjKptd8l2Q9D17us+v7YXsxxk0outQXKICjINBrSVk/2o+VdxY+FDqzaiY9hWSRdTkI7R2OqTpfF8ks3vC5toMDMGH2fUabjBkQ7hKMWgJ/HUgTbob22l9Eso3YmNmvElsMT6lxLZnwHiNfg/5d9tvqxdcu6Q3dccOpQwCZHr1UnKrZBslcK01gKpWiWNFWgdjnQEUeZyyyKyB/BDhHw75FWaOfW2H4L8HFWTXRmXhslGEMT6mHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iw3UioT8Om7/YvfzM5ex+BlSD9f60YIc2e+EVX0dipU=;
 b=VTCf67gg/CKgfl/+palzC+MbENR+U/B67IDEZWx87fzc5x6rHFT483G7Ry1AlT7Owuw5YPQZ8qj+HreQTDmNb1B3IhrsL8gudcd9LomDRUGAnEfr5Ked7HAzGSHJcggorNco/5rTlWfcrLS1Trv2/qADhfIRdsahdmdKhzpsXCyPDI1GfU/80xRjnOOlKFVEYq5XKrLoO2KplCBs3muUTWvPmUh/1UhHTEgQNarFayobK8kB3BDAG2VSgqm1Xg9uE0AYhNMvrMcRGnIYzlVoTz3gnTDFpCzzmMG9SHKcCMessWOC+T0FGg61/djFvxh99qVHASviNJjWVCHm2lK6aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6465.namprd11.prod.outlook.com (2603:10b6:208:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Thu, 7 Dec
 2023 08:22:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 08:22:54 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Cao, Yahui" <yahui.cao@intel.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Liu, Lingyu" <lingyu.liu@intel.com>, "Chittim,
 Madhu" <madhu.chittim@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH iwl-next v4 09/12] ice: Save and load TX Queue head
Thread-Topic: [PATCH iwl-next v4 09/12] ice: Save and load TX Queue head
Thread-Index: AQHaHCWC7v6C8L+qAkCS0WhagKZWcrCdjVyQ
Date: Thu, 7 Dec 2023 08:22:53 +0000
Message-ID: <BN9PR11MB52766AECA2168F37AEF6995D8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-10-yahui.cao@intel.com>
In-Reply-To: <20231121025111.257597-10-yahui.cao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6465:EE_
x-ms-office365-filtering-correlation-id: af2e0029-7b23-43e5-e577-08dbf6fdb567
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rRj9+n0u6dLRiciKWzvjrSKvEy3dZ5nGAZObu7gPvsxkA9kl9yTu/rhqUG9ne0MZKTdAN/EhdAsAex0AwF3CriodktofWEu2/bQwFaEFjnxOBSHYRUrJSqaiv639aFHiaIOK1M3X2aTzvykwA77fISXdxg0xjmt8xk3N2NcHaBg4barJzMU3qZwKLIMLCHjuOwoBey2+UnYYD2dZTxjqvNs+Xh1XKj53CiFyAHBd75LQTeQIfZkFSzwX6fk9gj0PnjddLxpIJSLlELoANwRo7tBdMijvXcdrq1aSd5ftAMRJOFEn+Huh3GYidn0s58Bd/EsmWNvBDnN3DgYVR+Agu95j/ZZBc2yaB19kPPVAhRt4Ya7IO/ldNF0sv5vMVDTITfcjqoGW0fqWfVozixA8Ag21e3ox4M6qedejLBkvadYJxvNMcj+PzRaWEiOlZcsIMP9E7tLYYkAjsMwG310S4xhXcm2tJqw7tYLogLgfWpqEZjUZ++ViC14QgGgr4kOa+vyoiudtZZhq+8XoLKNj0/wRVom8uvi1SX33vruCCwhjvpQH+r07xuy81AeBIlLp4l00C9ONKPuCq92h09RrrlwQlJHoCd2yYDgSpvclaXRTATR/+QjB84SxHmZtmRm2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(136003)(376002)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(110136005)(316002)(66556008)(66446008)(66946007)(76116006)(64756008)(54906003)(66476007)(6506007)(9686003)(71200400001)(41300700001)(26005)(7696005)(478600001)(33656002)(38070700009)(38100700002)(86362001)(122000001)(82960400001)(83380400001)(52536014)(7416002)(2906002)(5660300002)(55016003)(8936002)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TjSZ1e5bzDrWFqhzALMlK3KA/C3XcUko2JU3V5gO9TCJk+Ke7rqKFphDqQRq?=
 =?us-ascii?Q?WrM6T/dPps2G64nSsqKk5L9X33Qda0HQmaJYUkWUHk5tOjyP4XiIZDDPDK4M?=
 =?us-ascii?Q?+bnW7156LHC2gZHDJQkAi9/tEDoRkL3OiWnpAj94lMOIIhQrTqeK+QpEuBCT?=
 =?us-ascii?Q?rUjcfD8PbazViLaEOfD93mmTwn0TL5SNnIuQs9Yr/fX3gF0b1NQMy47qSNHe?=
 =?us-ascii?Q?P+8DbhkgiLsD/EGbGB/0GmgwI+JVISMSw5lPFXahcxjTEoNzCWOOseVGrnWZ?=
 =?us-ascii?Q?ruTjul3liudh9p2pDdIdgJnvttdOLsa6uLsLlArswMQrxKvxnV08FnGCz2wi?=
 =?us-ascii?Q?hfoipAYY6GUqMY5o2vU+IptQnm5d4DtXqJwVm0swkPOa8HNRUW8rYZg2YZew?=
 =?us-ascii?Q?rIlqux48ajc94sKmBCi8UB93+mYEll3Z3mb8ndkDO8vMbfeB/i0/OXjsDAaI?=
 =?us-ascii?Q?3krU0RK0PR7GwF6rH3jsF5YAWM8fz+QmC7+fD0jqKvBC+fWz/i3lQSB2STGR?=
 =?us-ascii?Q?/HCO/P6Ckf4Z0kOiIIWVVjH4n4GSXtejwKPgYr1VV9ggg5NlKVyS/x+LK47Y?=
 =?us-ascii?Q?fVH32vAhB6Kq0tBzNuYuqajwhwhcpeqWx2Jda0yGP0fl0igm7FToZCeGqyrd?=
 =?us-ascii?Q?+66L/w9U7zd/2rkprSy8nJbPN78VGQxG612cSHi5qahXQ375zYFAP8PLIDC2?=
 =?us-ascii?Q?JMteuXj0THzmweLH+hdHzTlUHALgP2rnhOsNFluq7QFpu6556UX/qfzA7LxY?=
 =?us-ascii?Q?5gs9FfnQIKhyddu4+rS3cXl2ctV7c4vqni1rNMUoxYbYutKa4VyL6WpwNZFE?=
 =?us-ascii?Q?v5sFM27oQuXspPukBpAGwi9mReTTciJ+CgijaV6D5AAiVp1eHc68kRJ7REbq?=
 =?us-ascii?Q?ii/+XcWlRloBZOVcznI6oODkflNUJ3rscpGNvPRzxrhdx8+PETuK/IzlGM2E?=
 =?us-ascii?Q?XJETfPDIRA+wpVbHnp4w9UQbl4Z+91ga6bVyE4eXLcatJ1DNqXCWnjiHPYYo?=
 =?us-ascii?Q?kJNDJnCxOkGcQRQN9sFlri8Psvru8OIId5866Cv23Afuj0lF1KM6u8np7fhY?=
 =?us-ascii?Q?l52nESUAzKlf54MgVl8bJY5/vU0LTdEk5w5I3tB6o+nIH9pG7U4FooipLmJF?=
 =?us-ascii?Q?gANs2fmT+x8rvmdY1BW5RKal00wIi8U/aj5dblGQCutGMbH1GADRKT5ty7x6?=
 =?us-ascii?Q?W3AsPGTp6LRD/EfUNSD30dxQrZ4znd/rIMcIDN+AJEnwc6aCBPQMGMyIYm94?=
 =?us-ascii?Q?mO6E07X3FFHwszktIli0r0J2eKBxJ+5XLKeHkyCdi8UDTpBjl5PrNmBCjbyW?=
 =?us-ascii?Q?cCVg9P7g7wCJ8AKGpHlaytp9nx4gzJaYjyjRPn/ekd6Lgvdclq2+zoOOgWrK?=
 =?us-ascii?Q?Nty4BBKMI4wWUtPXgQ+Q2Q/03Sh0Y0Fu8WmxANJz2yZkw/Wf7acUZE2550w8?=
 =?us-ascii?Q?NtGxZz5d0oy5zoXgzRjL9NMvxOB5hPQRKzjEBVz1Kyn/1owKwQTjqF0/UY+X?=
 =?us-ascii?Q?ah9ftyK1O7CRxsI3x6sXKli0ge+bDPLm0UqSOvvHCIsJX3esgPyMZP75irZx?=
 =?us-ascii?Q?hoxv2NRdXr3fDstdSD4NQnRrlsfqK8rvpb/LHzSi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af2e0029-7b23-43e5-e577-08dbf6fdb567
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 08:22:53.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYQpUt0LL5E6SnzRE7ccEspw/sSkFSF/OVLDOSSFCJYP/N7U92aaNWkGgANJBgfthXy+iwKFZQ4zZi4E5SmJBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6465
X-OriginatorOrg: intel.com

> From: Cao, Yahui <yahui.cao@intel.com>
> Sent: Tuesday, November 21, 2023 10:51 AM
>=20
> To advance TX Head queue, HW needs to touch memory by DMA. But
> directly
> touching VM's memory to advance TX Queue head does not follow vfio
> migration protocol design, because vIOMMU state is not defined by the
> protocol. Even this may introduce functional and security issue under
> hostile guest circumstances.

this limitation is not restricted to vIOMMU. Even when it's absent
there is still no guarantee that the GPA address space has been
re-attached to this device.

>=20
> In order not to touch any VF memory or IO page table, TX Queue head
> loading is using PF managed memory and PF isolation domain. This will

PF doesn't manage memory. It's probably clearer to say that TX queue
is temporarily moved to PF when the head is being restored.

> also introduce another dependency that while switching TX Queue between
> PF space and VF space, TX Queue head value is not changed. HW provides
> an indirect context access so that head value can be kept while
> switching context.
>=20
> In virtual channel model, VF driver only send TX queue ring base and
> length info to PF, while rest of the TX queue context are managed by PF.
> TX queue length must be verified by PF during virtual channel message
> processing. When PF uses dummy descriptors to advance TX head, it will
> configure the TX ring base as the new address managed by PF itself. As a
> result, all of the TX queue context is taken control of by PF and this
> method won't generate any attacking vulnerability

So basically the key points are:

1) TX queue head cannot be directly updated via VF mmio interface;
2) Using dummy descriptors to update TX queue head is possible but it
    must be done in PF's context;
3) FW provides a way to keep TX queue head intact when moving
    the TX queue ownership between VF and PF;
4) the TX queue context affected by the ownership change is largely
    initialized by the PF driver already, except ring base/size coming from
    virtual channel messages. This implies that a malicious guest VF driver
    cannot attack this small window though the tx head restore is done
    after all the VF state are restored;
5) and a missing point is that the temporary owner change doesn't
    expose the TX queue to the software stack on top of the PF driver
    otherwise that would be a severe issue.

> +static int
> +ice_migration_save_tx_head(struct ice_vf *vf,
> +			   struct ice_migration_dev_state *devstate)
> +{
> +	struct ice_vsi *vsi =3D ice_get_vf_vsi(vf);
> +	struct ice_pf *pf =3D vf->pf;
> +	struct device *dev;
> +	int i =3D 0;
> +
> +	dev =3D ice_pf_to_dev(pf);
> +
> +	if (!vsi) {
> +		dev_err(dev, "VF %d VSI is NULL\n", vf->vf_id);
> +		return -EINVAL;
> +	}
> +
> +	ice_for_each_txq(vsi, i) {
> +		u16 tx_head;
> +		u32 reg;
> +
> +		devstate->tx_head[i] =3D 0;
> +		if (!test_bit(i, vf->txq_ena))
> +			continue;
> +
> +		reg =3D rd32(&pf->hw, QTX_COMM_HEAD(vsi->txq_map[i]));
> +		tx_head =3D (reg & QTX_COMM_HEAD_HEAD_M)
> +					>> QTX_COMM_HEAD_HEAD_S;
> +
> +		/* 1. If TX head is QTX_COMM_HEAD_HEAD_M marker,
> which means
> +		 *    it is the value written by software and there are no
> +		 *    descriptors write back happened, then there are no
> +		 *    packets sent since queue enabled.

It's unclear why it's not zero when no packet is sent.

> +static int
> +ice_migration_inject_dummy_desc(struct ice_vf *vf, struct ice_tx_ring
> *tx_ring,
> +				u16 head, dma_addr_t tx_desc_dma)

based on intention this reads clearer to be:

	ice_migration_restore_tx_head()


> +
> +	/* 1.3 Disable TX queue interrupt */
> +	wr32(hw, QINT_TQCTL(tx_ring->reg_idx), QINT_TQCTL_ITR_INDX_M);
> +
> +	/* To disable tx queue interrupt during run time, software should
> +	 * write mmio to trigger a MSIX interrupt.
> +	 */
> +	if (tx_ring->q_vector)
> +		wr32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx),
> +		     (ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S) |
> +		     GLINT_DYN_CTL_SWINT_TRIG_M |
> +		     GLINT_DYN_CTL_INTENA_M);

this needs more explanation as it's not intuitive to disable interrupt by
triggering another interrupt.

> +
> +	ice_for_each_txq(vsi, i) {
> +		struct ice_tx_ring *tx_ring =3D vsi->tx_rings[i];
> +		u16 *tx_heads =3D devstate->tx_head;
> +
> +		/* 1. Skip if TX Queue is not enabled */
> +		if (!test_bit(i, vf->txq_ena) || tx_heads[i] =3D=3D 0)
> +			continue;
> +
> +		if (tx_heads[i] >=3D tx_ring->count) {
> +			dev_err(dev, "VF %d: invalid tx ring length to load\n",
> +				vf->vf_id);
> +			ret =3D -EINVAL;
> +			goto err;
> +		}
> +
> +		/* Dummy descriptors must be re-initialized after use, since
> +		 * it may be written back by HW
> +		 */
> +		ice_migration_init_dummy_desc(tx_desc, ring_len,
> tx_pkt_dma);
> +		ret =3D ice_migration_inject_dummy_desc(vf, tx_ring,
> tx_heads[i],
> +						      tx_desc_dma);
> +		if (ret)
> +			goto err;
> +	}
> +
> +err:
> +	dma_free_coherent(dev, ring_len * sizeof(struct ice_tx_desc),
> +			  tx_desc, tx_desc_dma);
> +	dma_free_coherent(dev, SZ_4K, tx_pkt, tx_pkt_dma);
> +
> +	return ret;

there is no err unwinding for the tx ring context itself.

> +
> +	/* Only load the TX Queue head after rest of device state is loaded
> +	 * successfully.
> +	 */

"otherwise it might be changed by virtual channel messages e.g. reset"

> @@ -1351,6 +1351,24 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8
> *msg)
>  			continue;
>=20
>  		ice_vf_ena_txq_interrupt(vsi, vf_q_id);
> +
> +		/* TX head register is a shadow copy of on-die TX head which
> +		 * maintains the accurate location. And TX head register is
> +		 * updated only after a packet is sent. If nothing is sent
> +		 * after the queue is enabled, then the value is the one
> +		 * updated last time and out-of-date.

when is "last time"? Is it even not updated upon reset?

or does it talk about a disable-enable sequence in which the real TX head
is left with a stale value from last enable?

> +		 *
> +		 * QTX_COMM_HEAD.HEAD rang value from 0x1fe0 to 0x1fff
> is
> +		 * reserved and will never be used by HW. Manually write a
> +		 * reserved value into TX head and use this as a marker for
> +		 * the case that there's no packets sent.

why using a reserved value instead of setting it to 0?

> +		 *
> +		 * This marker is only used in live migration use case.
> +		 */
> +		if (vf->migration_enabled)
> +			wr32(&vsi->back->hw,
> +			     QTX_COMM_HEAD(vsi->txq_map[vf_q_id]),
> +			     QTX_COMM_HEAD_HEAD_M);

