Return-Path: <kvm+bounces-11277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E83298749D6
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F4BF284606
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D7E8286B;
	Thu,  7 Mar 2024 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCldJdvY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81170CB6;
	Thu,  7 Mar 2024 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709800682; cv=fail; b=Qg+CeEW8UVPGXjzBtq9jKVIv+2gvDLBDPCnwfLe7U/h8z/KXOZwq9uC6pSFWZKShnpSy/i0ijNqH1Cvjr4B0IAz6TIFxtx0GHFuhth8HxbZu7LTFSABJxNRyAF3pejjYmEdMS02JBqNkuzqRHHSBze4yUCNFe8kC2Q0JJ/ZWJCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709800682; c=relaxed/simple;
	bh=SxU5pS1ayIX02HuU1VSeKUkDJ/AAPDrPtS8ccAJTwaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bBANWanSMQ5xES1xNarsU6jmtFbHZcE2n+MxMWJvhd89IrlTsoKpLUYNclvGiSpHX8QdPqzcVIuryHYqnQomNzo8C495zJ053wf8hpyWd3HicOm9Ax+UGLt4/Sce4L5bPbPz/KzEo6kDAWFxLVFA2O7x9Q1s7VAHIiDnkJ4grsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCldJdvY; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709800681; x=1741336681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SxU5pS1ayIX02HuU1VSeKUkDJ/AAPDrPtS8ccAJTwaY=;
  b=WCldJdvYMbxmuuiACKfzjgmTRTup7WkJpGqwISV6NXPwWlQBSI//ege1
   6S2saQ3bVcGh1A19LvuTXTp2NR9eSkcRZS8jqbzixB8KM3vJTsVTdt7Ef
   4S04UQCJDBlXiBL8fPbS9S1HRnPSL5GivxfcWLsYd7pBdRjptA7R3sDCo
   53U0IQpepBWFCARTVSW78foEXFOby07UglEu6zAs8DrTALC/eZluRhzo2
   zawE3CxjnoEsnMNVR166HRNu8YR6i/zDvPSIGMRv9FnBLQ/GgfNdGhGhv
   HwHDWOSNJBGqdoAuWbQuY660l+aEcBcYD2bp7XTqwnGz/k/eSAuQXLYj2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="21983268"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="21983268"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 00:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="40924649"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 00:38:01 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:38:00 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 00:38:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 00:37:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnK47u8Y6CPXnoUh52sSu1CFfOO0KZ2L4+rGziAjh9MXt3HAch85GARbwTFT3ymjhyOTtBVGGGrg3Boxy/R1FGu4w3jqPeMnpFLLEPCkrRxYZ0o3MRTm7GzBwdBgVq42msk4ZwlQwb0pfxMDpy9LNhAkDDeLa9vuwoWb0nrmn82/BK3m8bsKH/yMz8JnvU1lk6Rc+GavIfD/eiHL++nuWQ9vNkIzT89NRfY0MHBmLUJTMWMvfN2vhsTR2whEWnDfqw9N8ZO/9s3lYFwNueg4zXM/ygUVzjifMnjha0vs3YFoym5/b1KOlMzLVQIaqUal7htZKZW+l6B6TqGwsLP6xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4O87CvXq8MBeCXABkzx6HnDTyDvxHayh99AK8T7oWP4=;
 b=gKmGWhnR/uIkFEQ1K0QZGj9PBojjy4N63PJ006FU7DKvtS21+p2OPb0DaVSmS7b+AJKQXo5EzWp4DWWxriV+Lk2JW2qXGbbM7eUzslAF5OBFqwJ9zTGLbXt0eKmFBvSAEqsNjseTm1ayr/82pC7JyKsrDqmrfyLd1X3UyjuOHyJx2j+t3JPN6p8kM1Nsk13H/LEMKaRP61PzGHQxpu/5/TosQ299YG7Xl5VruX/CxgHHql0WYJxe2dVh9oS2sotB5S+3cXu7qr7P2oCPxDbkfItSlSnVHbgV6QT+0I9KAC1y0gZUh6EeuhNlJWJN8mGNr1JyBLQA9v23RLD0weS2yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by IA1PR11MB6417.namprd11.prod.outlook.com (2603:10b6:208:3ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 08:37:53 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01%4]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 08:37:53 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/7] vfio/pci: Lock external INTx masking ops
Thread-Topic: [PATCH 2/7] vfio/pci: Lock external INTx masking ops
Thread-Index: AQHacAtesjvk+OVhZUWmMSfK5TxB5rEr9L/Q
Date: Thu, 7 Mar 2024 08:37:53 +0000
Message-ID: <BL1PR11MB52713E13EB82604A2599616A8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-3-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-3-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|IA1PR11MB6417:EE_
x-ms-office365-filtering-correlation-id: 5542e356-db3e-4076-eff2-08dc3e81e14e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NQv7LGIHD0zcN7Ors8oVWSY0vRu4qyG42RDJxp8Hs5mRmZ7yKAdbn+B22o78+E6v/vfuY2PALsiAbPeQo9nfplSjRopZH+BT40G+HdjgRCFnawLGpITrY5vCfkerrf6vyu4jau97XD9eKu0wRnz+4zvlQPkF3fvonphN9+ijGtnRngG0v0SpPiKVNJChVra8oCbFxY9WCFMFWF/nAiyBiNvdsNv8a+Fd3tq8g79uTStptt3tLMA71IhFDusr+y1PS0MbNCC/bw21Z0irD2RFh/NVJpaQgaquQvMTRub+ybrsUF/xmC24NMQZ0oUnwRsxL9CTP3nTR1i/3MQgC+agymUHvOdrO/2SpKCpJMetdJTF5OnBjiEIsiVLyuMy4f3AAUoXFeNvmaeVcnQ7rxV4Bxy9XDxG5nrVknm3mpPPhLmE3vjodTsJvaRvercIN2P1W9jXyuYOwfSYYlU12+Yb3nTpQcpPMnHc/2Y2oAu4dEGtQXthRzInIJyJGnV0PR/3rRhxpE6Q5tPHh6xNNZfVZA0WlkTI3qUF1uU5l0H4ekXQIuDngPQtp/3F/APhBtC+EBpMr0pIxya3leqh8mBq5eq9Ke+/JgmOz9ZNl4xGFdC+x+bO0uSOltQdj7Vu+4GEZGXgz3ZPr5pViG9YJhE2kJ29aaTCfA0x9KQF1H1G8VtyPmMyHJ8tIRW1NPEKcAMSsTIGj2BCUP5JadzVId9VuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pCl6Pq421eTBgGgVGeVD/jcKImv9yNaLxqIpK2+pdlIxWIzjiPonZqCK728A?=
 =?us-ascii?Q?7RvSWbRFHH8VooDQ1k8hBZ/pbj5s7YAtVNT5rmeFpn1ip0taJLyiFgiGiK5m?=
 =?us-ascii?Q?j87rmRQ+qjsrJBjJ+G8p84HndvBdBzNp1ie+9j/DoYJQCZpyKXuiYe4FleP+?=
 =?us-ascii?Q?58PMeULB7bM96pkvJVb4hS68zeS2l7Mk+kfAWMqT5wsShRHN0Q812IQDoCGi?=
 =?us-ascii?Q?QxpWHjYMnmPj6DWsFSABtNn++wwN8aoSlRYxyV44w8gUq++AHjritiKsar8h?=
 =?us-ascii?Q?DNJoPfRpV5TCmegYnYq5CzZVvMlEEYLHZ3siU7N5c7c2rB7UlR+mqfuw/rt2?=
 =?us-ascii?Q?g+xMf5ErCL8MkTcb5iVxIpbDyNXhags1LwTOmbWQY9pVZ6j9k8X9UbK98+VW?=
 =?us-ascii?Q?cQ0vTcSmcfFuhWHIj68YbvhDjmXLUzKd3R3Ktf4iqOvILSCYeu19yp132i38?=
 =?us-ascii?Q?+qw7GJgGT5NfiNNF57bSKnP/HQ7tdSs6x/2enjMPhJC+HM/zQbrk71UsmKat?=
 =?us-ascii?Q?B+XOjMGSFlKVg8jt/sQMBX0hG3aHqR1Fv1d6sgBIsizPqAesaVMYXsJcNcbV?=
 =?us-ascii?Q?4elUPZgoKghakn5NXVSpdJWYz7R9cnsmCahsbi+38fvQDZBcOXR5A7Du2fh8?=
 =?us-ascii?Q?kq2a330QUhxoGCIRiZy9VAft7RwO5a+0McYTb4ABz0NsAFHkKa+tk7BOKkKM?=
 =?us-ascii?Q?PBMoq6LYXeDuYxmhHZwyQrK+qQvZSZ6SXkSIwhE1CfIeZ7r0QO7cdWZmuOqE?=
 =?us-ascii?Q?XoE4DCqb3QmpJvs5zfw605TjX7xujLYpOOpTHh1aqysOndfbPKJ33P6/6cQs?=
 =?us-ascii?Q?nNZSL5JI6zHv6OzlKnfBvKr/zcRYN+8GUMH1qYpDJH3VbDWEsmVJuqVwdFs5?=
 =?us-ascii?Q?UXB0Al5KBteSgHboXdiudisZrMk/jOAJoiUwkx2ZEAOeXtxnFMgxwtSLvM7s?=
 =?us-ascii?Q?SulVuknW4fcKo5wR0r5RbSju7lL7oXFYFV0c6MuW/bT8Cav/9NIEohGTn1WR?=
 =?us-ascii?Q?uzPkn+xq9YmEUMXrmo0M9UIyQGbDddd9q/6Z/En6R7LF1YlMfp37+BV0IZcd?=
 =?us-ascii?Q?m2aVlaJGAYu0oMbbNuohPPcqLelHbOtuZgAdgm8U0GpxjYFAiio/iDVxRDpo?=
 =?us-ascii?Q?/PPPKGDNuyPunaXyjP8mI1zCSHKqFHVeCebYyUzZ/WZ1FPM1lmubvQQWVIKP?=
 =?us-ascii?Q?3bqZ6CEHfZ3J6e7c5JHhN47HZA5uLZeTMmcCNg8bbWGOfQGUO8fsZH56+DVo?=
 =?us-ascii?Q?7SOyguWi00bEdvUMRpNevgAjcCirvpXsx3DjAT7yIA/tYugrUzKBz460+T+O?=
 =?us-ascii?Q?Fhhke5nCM3x+0lIyvyFI8lchRdIgi68n0IudZzN6GIcqSjnqIxGaYMuF0YFC?=
 =?us-ascii?Q?df0OL5FPYE6GOX+GFrB3g104eKOlsc12Sm588GY/suHLfHdSVAoxhMERiXRR?=
 =?us-ascii?Q?PV0qSgG/1008RaKnqF83AYX24Aq/4HFW6neTYTV8+W14BdOEqvy29zu8u6lD?=
 =?us-ascii?Q?mcxq3odpBqwQ/76ghudldvB1GWGkXLAr1peJ8oQMDnRm4qSbFdLIoUw8vxuY?=
 =?us-ascii?Q?AM3WmSzqG/8Fy5SvEdqi7RyStzarD6a1a8zufxHL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5542e356-db3e-4076-eff2-08dc3e81e14e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2024 08:37:53.1071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbwjZshfohrFeoRFHAHx3S+RvjybKsTTuN0EX4YllJXgmLe7Z2AiTdEY0Iv3VC9uXd/eCGgdfhjkwodWKjJj/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6417
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 7, 2024 5:15 AM
>=20
> Mask operations through config space changes to DisINTx may race INTx
> configuration changes via ioctl.  Create wrappers that add locking for
> paths outside of the core interrupt code.
>=20
> In particular, irq_type is updated holding igate, therefore testing
> is_intx() requires holding igate.  For example clearing DisINTx from
> config space can otherwise race changes of the interrupt configuration.
>=20

Looks the suspend path still checks irq_type w/o holding igate:

	vdev->pm_intx_masked =3D ((vdev->irq_type =3D=3D VFIO_PCI_INTX_IRQ_INDEX) =
&&
				 vfio_pci_intx_mask(vdev));

Is it with assumption that no change of configuration is possible at
that point?

