Return-Path: <kvm+bounces-8295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A00884D9EA
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 07:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC53D1F23CEE
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 06:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8794767E76;
	Thu,  8 Feb 2024 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/oWI4c3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E591B67E68;
	Thu,  8 Feb 2024 06:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707373159; cv=fail; b=crpag4BuBWdS+7RYpmGCj/P8AWmwd8cOpoNY9ZyW/65KACFNYExpc2q/aQXwFn0SDKfT2HN/fug/7apavAQwY7KEyqKDbiNqJH9huZkm3emhxnIS/k0nRHjihKbbFr+YdZJ3iUmut95qD7RnDVuRQ6j7nI4dqFsDAQDmZCWgot4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707373159; c=relaxed/simple;
	bh=VHsP27U0Tu1RSj0Tg+8eA/YKqq+byi8ZSKyUVhIosO4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qWub9x4Rfr0l4dzrpjxjo+LNRBhaQrPHj545HX4ToqoyJBffJmNSUBDeFq18trmZ/EHKMY/CaxDGB6LOxpCN9w+Yt8KTST2vjDXj/xcnnMWaXxWwjyLjKMezAX46kizt+54bZactwlqXC0HUXZ87sVUQbColfqogQMd2Yx167ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/oWI4c3; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707373158; x=1738909158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VHsP27U0Tu1RSj0Tg+8eA/YKqq+byi8ZSKyUVhIosO4=;
  b=l/oWI4c3p1Q9QSs1jHU6cwofMfu4L5ocytznSjXHxTl7CqPoKAgfFREA
   u5mJyz95h6J92oXQDTBcsxrrAwZY5pjfMZl67yfyFLFa6R03ixA6e3RGF
   iiAVpGNRVkDULM87G4G8usCQ6Le+PoBaFiF+NdHP5bKPgu2MwgA68Pz08
   fpci7sA0m8RgJTZzujn+sCIHRKYz8+tprPMXBbdYwUdZgNQ0hQYt0IiON
   ur8ZQHJlEaJ7m+78SaXDaft0LhJeMSFqCkLd/eYRFbUhcV8mJ4YZew7F7
   Erx4+50H6308xE3w27+7RPIdU6m4odR11i6GXpJnUg8RJaQj7uGejOeuF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="26596355"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="26596355"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 22:19:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="6180086"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 22:19:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 22:19:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 22:19:14 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 22:19:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7UIpo3L7JTFiQHDF7kOFpCKfefbsFHa++Fpi14hxm8pC8vxlhvtmoFTaLlEnVY0frMKnzdVEWEF0r3pL0XRftz1fosfklgkDrRqsvMhavcqgNq8sININnMMAqp0AzLFN+XemAT0Rw7YKHLc5EvhrBxI1V2vLIa5velEFmhPn7810yjHyrTGsZquSUANdrP8Rm4O7wmGmqaTDPDonj471TaXuMq/5zPPHVsCQPvw9ApfOQLx87F4pClWmTIB4PHorSGI/vBHAwttLtSYOQPlPTXzGY6Z49YNCpYD+bjO6V/FyNKWAhLT6feGLyiH6YFGAkC6TR6VxL4Tm/RKWzJGKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnQFGgfQLyQAWFCexpsrx2XH+lps/v6lumme/095a30=;
 b=VuKE46cE+FTt3FZjzZrXTGKR0+UExGg1gXJd5hqq3s8RrIPZJgRdtj/QDEKlIJzuae5BhZSPRlGINZDemqFu4pH5Lo5jH3nXVSJhT9pmxnPRDVNQpx/OdNI7lkWPh4hrY9htBQmAHAv9UCQ86j0qqp7gpvzGJjEIWNHP6PHmYTfDPrwrz6UQbglTxYx5RZxZ00EuGkjQEIYA/PNM6rVbMnOkEFS64m0vHmORnTyhjhyNI0wq76W4R0OakJuHrBl+V70+fyMPnX3bNR9PuVmsswLnwbZaFpvsEpqlHaCn7DdyZsxXmLnDR5Q1Q8HQdbdIRG05/TJp060wROqgFnnWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 06:19:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.038; Thu, 8 Feb 2024
 06:19:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, "mst@redhat.com" <mst@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "clg@redhat.com" <clg@redhat.com>,
	"oleksandr@natalenko.name" <oleksandr@natalenko.name>, "K V P, Satyanarayana"
	<satyanarayana.k.v.p@intel.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, "rrameshbabu@nvidia.com"
	<rrameshbabu@nvidia.com>
CC: "aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "vsethi@nvidia.com"
	<vsethi@nvidia.com>, "Currid, Andy" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>, "mochs@nvidia.com"
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH v17 2/3] vfio/pci: rename and export range_intesect_range
Thread-Topic: [PATCH v17 2/3] vfio/pci: rename and export range_intesect_range
Thread-Index: AQHaWIdb3fVc1Z5CCE2afKbt+x6ZX7D/+wYA
Date: Thu, 8 Feb 2024 06:19:11 +0000
Message-ID: <BN9PR11MB5276BB50143B801E8F02D9958C442@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
 <20240205230123.18981-3-ankita@nvidia.com>
In-Reply-To: <20240205230123.18981-3-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6733:EE_
x-ms-office365-filtering-correlation-id: 78b3457a-6903-4bde-5b76-08dc286ddd8a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mpLnyl7sTqkN6R2b2Tz8z+ar28vdkSWrCiipPVIpWGM42uEYAhw1ykC26wfWzlUbhvaAvKjcxTHzChCvURIDGbAdok/0SwEi7mLRj2OVPU151fYShuqbKfnI2bCTCa4BXFhO1yzJR6inaZXr3RQRBt9O4k2Oakby06EMC4hSGg9V8ks9BfrvRqdnKuv0OEKcpyuuT5ETqB0M9bB3a0fYTjCSXR4PTkrn3pVyObIMsOk8+GzNzhAnclyuW4iimTBxsD8+/peBIxTLSkxxvC6cJp6My3WUnaTTjjrjxbvtdYbYTlEHHqp9k45xkdncKent8zSf0uwMYFYPdp3uGTvJlta/FJZQtcpbWMemFS4S2APoOfc7yHbdnrDvgPEEb/eh2xLIBIib/4s60GxbrpKwanWy9OfxWQ5AdL/nsLHfzl3Opwy3+D2mK8Ly4wyGP7A3Mo3u7TqXjeevqS5+ZXSWlvrTSPc7KwCggWATAyShBKbdHgZrBI8Lj52aU1rqE6RK6NeU9g7CK8gy5M/7/ic3fy21EgXjusS7yhEoUbn8A16B2IFvc+e5/x9FC4J/HtanBO65g5ikT1OyzCMpw+xTr2QECWQ+zE4pv12VjGUm8kkhUCTfbeAUGS+tz4cw4OWw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(366004)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(66899024)(41300700001)(66946007)(8936002)(76116006)(66476007)(478600001)(110136005)(54906003)(9686003)(6506007)(33656002)(38070700009)(8676002)(64756008)(66446008)(71200400001)(66556008)(316002)(52536014)(4326008)(82960400001)(7696005)(26005)(38100700002)(122000001)(86362001)(83380400001)(7416002)(5660300002)(2906002)(55016003)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aAa+dzPFKf8of+UaMQ1fMYCHa+/SiCb24+8gam9c/XRyhy112J1lL/4vawd/?=
 =?us-ascii?Q?yXWz7+vVKYz4skMBeHfnd0L0kHk54S7ccW45je0u9zYVhM3BiXENwET1Qw8v?=
 =?us-ascii?Q?tOIWcC14L4GqUSRig5DgZzmnx6OsMltR7PWzSt9BKDUtXWLop6kBW3ST5xUp?=
 =?us-ascii?Q?7uvOQ+046GqaDKEZm0zQ1MTJZoHIONTLlIpu66tOyWnekf4b8SWxWomLWY3k?=
 =?us-ascii?Q?K62sibaYzsXd+0wHCrnbvSuO4rWUfbPFNw5xD8Nstz/c2I1qGMXeW33zWvKD?=
 =?us-ascii?Q?U3hUZfv5HcV07jNVhhkFdDPRxctcBQ5h6NYCDRB5OVjpxC3tQL2IlQErz01f?=
 =?us-ascii?Q?cu2qNVFaAnL4uqoyMxld6TCMGHvCObAKI6buvqfmvsIscX2nO55zxkrWrO5T?=
 =?us-ascii?Q?ykbQnrbTu6YoGJOdt3J0YhllA8oZT2ZH6T8amW+p7bCOHFKIxNFOgFoGNjTg?=
 =?us-ascii?Q?TN4FCMiAkk3tOjXO/V64EbbayHMJePT6QicXY2yFYJhWsZWsXWIMbnEG6cG5?=
 =?us-ascii?Q?ABy60ZBjiFRfLjJmpDqkpL/mjG9fHlzVGjg62FiXjitFWAh4QAs0hKJ6GMhp?=
 =?us-ascii?Q?d7h7Z/RUireO8EWcz0BtKwvYq+J/rFW9l9Xrt6up/cI/OumjCOvOjgq3ygrr?=
 =?us-ascii?Q?bVAiFJfekRC1HJom9MIh9i69tQSkjtOzBxyiXh5RP/ILZS0quAkkFSBbhDtx?=
 =?us-ascii?Q?WiApTCpH+cwkWZUFVGpjACZRokvCckfJUtKb6ZTtztyIPxjM+tWK6wltIyTg?=
 =?us-ascii?Q?W37dSGd71Y6MgI5wob3tfquaAkDuyz/xiQZyQWDDiww0iNPSogs4u6Pkmxd7?=
 =?us-ascii?Q?QrWGa6wow0h1RTgTNX2ypfoHbCT1MBd2jIlOjj7arev0VQgHDF1B3kR6r7vU?=
 =?us-ascii?Q?/1retgb0YLleLVeTbr19BDV4aPXSNZLe7xkK1bGKzraU4a1rpcB/nRiYXA6K?=
 =?us-ascii?Q?pNQ+FNru0oxKANNLL/GgCjVFyBHaKEsJI04SyBuV6egvjzC+y1LIgTFizBY7?=
 =?us-ascii?Q?SI4pqSQCmhA7BR28W3H+cSZ3T/27GB2JcFqR653xQeEksTVr6UAviYNzODnY?=
 =?us-ascii?Q?DqnBKbJV4Qu95MQtkY35/TfNJZWzw9pZZm53KhhMRWqUyK45GTnD//WQ5WoB?=
 =?us-ascii?Q?BdSVUf7KDxWC7akFXl4Rv5oRWNIGDkRCZXOjuCG+bVr3O6iSQhmCwms3esqy?=
 =?us-ascii?Q?ab/aTrPcyGzoe94IPL1OhHMV1yscMoiay9dRrVEG7jO8yx0KY4RNe4J5fG9y?=
 =?us-ascii?Q?5sXvxT0soj6SaQXhIYLuKFc5GJ9ycvXmAnC5C7zyxjJfZmVCbuHC22DT5kWQ?=
 =?us-ascii?Q?CAYVTNsbNZz7yEBZ9cVwCAfCAQatFcrCKTXJFjZrVJgG8Gbf+luVM6bg20Cl?=
 =?us-ascii?Q?ni/+SlvKT9sWe65UPMhQnSyIgHCA30E1qPlWZMRBHuEcfPYq8HZTJjprv5EQ?=
 =?us-ascii?Q?iFOLinn2dCUQx88d6VbajaPFAPO1Gys+DmXyqnYrq8DQPhTyRl4tR2Z3riNT?=
 =?us-ascii?Q?J+nhwfmPqSkIWxgb9lJn2mS32EKtLMXUaxikLVrN0pcksRR2I88iTj3de7pw?=
 =?us-ascii?Q?a2jABpz+PqKQfiCL9MuBYlMKVCGu32scwf+G7P4E?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b3457a-6903-4bde-5b76-08dc286ddd8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2024 06:19:11.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AhQ2wIKoe9K3F+FtHP8TPKdtGvNze2LheQyjiHMtr3YECxXTSlIxXvJ/Tv6y5amPqWNh2WeEC2+tArfESerf9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6733
X-OriginatorOrg: intel.com

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Tuesday, February 6, 2024 7:01 AM
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> range_intesect_range determines an overlap between two ranges. If an

s/intesect/intersect/

> overlap, the helper function returns the overlapping offset and size.
>=20
> The VFIO PCI variant driver emulates the PCI config space BAR offset
> registers. These offset may be accessed for read/write with a variety
> of lengths including sub-word sizes from sub-word offsets. The driver
> makes use of this helper function to read/write the targeted part of
> the emulated register.
>=20
> Make this a vfio_pci_core function, rename and export as GPL. Also
> update references in virtio driver.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 45 +++++++++++++++++++
>  drivers/vfio/pci/virtio/main.c     | 72 +++++++++++-------------------
>  include/linux/vfio_pci_core.h      |  5 +++
>  3 files changed, 76 insertions(+), 46 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_config.c
> b/drivers/vfio/pci/vfio_pci_config.c
> index 672a1804af6a..4fc3c605af13 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1966,3 +1966,48 @@ ssize_t vfio_pci_config_rw(struct
> vfio_pci_core_device *vdev, char __user *buf,
>=20
>  	return done;
>  }
> +
> +/**
> + * vfio_pci_core_range_intersect_range() - Determine overlap between a
> buffer
> + *					   and register offset ranges.
> + * @range1_start:    start offset of the buffer
> + * @count1:	     number of buffer bytes.
> + * @range2_start:    start register offset
> + * @count2:	     number of bytes of register
> + * @start_offset:    start offset of overlap start in the buffer
> + * @intersect_count: number of overlapping bytes
> + * @register_offset: start offset of overlap start in register
> + *
> + * The function determines an overlap between a register and a buffer.
> + * range1 represents the buffer and range2 represents register.
> + *
> + * Returns: true if there is overlap, false if not.
> + * The overlap start and range is returned through function args.
> + */
> +bool vfio_pci_core_range_intersect_range(loff_t range1_start, size_t cou=
nt1,
> +					 loff_t range2_start, size_t count2,
> +					 loff_t *start_offset,
> +					 size_t *intersect_count,
> +					 size_t *register_offset)

based on description it's probably clearer to rename:

range1_start -> buf_start
count1 -> buf_cnt
range2_start -> reg_start
count2 -> reg_cnt
start_offset -> buf_offset

but not big deal, so:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

