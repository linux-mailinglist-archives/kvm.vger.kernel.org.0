Return-Path: <kvm+bounces-11356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1866875E50
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7001B1F230F6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2640A4EB50;
	Fri,  8 Mar 2024 07:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+LT6sfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AD8E555;
	Fri,  8 Mar 2024 07:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882239; cv=fail; b=YWObAzxg7cOsLkXtBlop/TL81Xl9XNGNOqfKdGhHopvRLN0N/jH4o2TKB4v0W9TVOevFf3AcLeCZzZEA7LJgIIdyO6gv7qFLKHG1bzkz3AN2wA4tsw4u9OSN/nyFjxwscP/jYYAZQzuDJdIv8J60K/Vp/jQZNZ7Zb9LnDgT50Jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882239; c=relaxed/simple;
	bh=mVGncoc+KIUU5xoAzmSqHDyxvloQzPJu8QESBdCVfUg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aqJJ6voggtLjtlpLRlziKXYryhtNCTT0ooiJo6Hy2yIH5sDniTR0/PdwuSih/xMKWFHZleWH5mkUBByjFRabJRSo3w5bo5J+xumpH+fdtr89P51vIxxEAXbm3UHfOEkW3T8n048ZzJac5Y/WAvsTiwo1Enw9HoEn0NUGKA7w8ME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+LT6sfZ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709882237; x=1741418237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mVGncoc+KIUU5xoAzmSqHDyxvloQzPJu8QESBdCVfUg=;
  b=b+LT6sfZN6VBgeRUMsNmQBNqfK9CVQwvhK5znvrNHZRQUIl5NONfjRRD
   oAmc5SbBC18hPS9R8pMzsnOu+jCwyA0k303wpp8ikajwQAY6xZB4wXrud
   BmSP3uLnxLzN6QIB3Xb5aDD8NM9MFLsex/ee5od8d+eS5/YRazhlDjk4B
   S/DGC0/n9w/lbiUjO9UG31Gm+TdK0PVNI+nG7C22BBbrCJYGROQmGEn0m
   6TfyfD3268qyIqZiBQk95k2Y1862Uro99CXLFfxLtc2qMqmWeu99HuCXF
   s0FNvn/NYugOsXgG/EfuUrQmseg0cWSmcLfFQKBQUti+ksaNVJxS4hLaf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4716328"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4716328"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:17:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10267745"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 23:17:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:17:15 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:17:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 23:17:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 23:17:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfjNq5EWGoXPOdAM4UGymDydnRzi3bltORcfvCCazpF3IduA0Q0ceqcavvJiCqssaX5RaAd61HQ2xDJ//JCe0YRKZUadGpi9L7kip+XfCOYn6jJ9hg+LlNerDBtm3GqoimYHgUzMNqFUHapeAoEJQtnw1ppNGdQMj+YMAAVOk4ISntfADWFE1bv42Jgh31PGBli2Oqz6yBj+sBIAVxcR+BBEJRxv7TDrjDsCh3TuZyRa+HSrAHnALtrtoVI26YqrX9zlOgz6Zxc2K5IWZ/rPl6oRAkPHhhmLH4QTzwHIwz6MtwMe8kHj9gLFh+hpD7YkolA18E82+CVONqAqISdn4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlqCjxn6eoFINiphhz1+1btpBUOnMtYZwa60rZLqGUA=;
 b=lZnv6g6G+JLKxvpaDzpyDivY4/BGC3iAK1TZLa062kfM+yNXvNDg843mtLPtSNxXWGNhITEJleP9mXm8RuSsB/a89aNf1LGKitbQ3HKasIrEXP1XhSlggOfYjIMZI5iLSDATA9eISBr9dINqRa+omG/5Y5Q7sBxzV4q1JGgwqdOwFmJRKBDMZkJtNowFty4gmqggoI3N2INFxfmKzjk5SiJSPJKHcGUj8nq2Ehv1U5OWRqyomJjT+foVup6Q6GllyWSSRa1aZkOb6iCzsthLOTEiewhO5QWMU06mqHa95iF1MXc+VlXpACl2+alsu5DjmeJ3DFNfY1rRR4s9ZL6Wyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5274.namprd11.prod.outlook.com (2603:10b6:408:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 07:17:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 07:17:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/7] vfio/pci: Lock external INTx masking ops
Thread-Topic: [PATCH 2/7] vfio/pci: Lock external INTx masking ops
Thread-Index: AQHacAtesjvk+OVhZUWmMSfK5TxB5rEr9L/QgADFPYCAALcQwA==
Date: Fri, 8 Mar 2024 07:17:12 +0000
Message-ID: <BN9PR11MB527641E05DF98A579889B5788C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
	<20240306211445.1856768-3-alex.williamson@redhat.com>
	<BL1PR11MB52713E13EB82604A2599616A8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240307132129.0585a4aa.alex.williamson@redhat.com>
In-Reply-To: <20240307132129.0585a4aa.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5274:EE_
x-ms-office365-filtering-correlation-id: e4eb73b0-658d-444c-af21-08dc3f3fc67b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KPO+9fmEjTj47ab7CrJfyZDzesCA+s26rkcsBCK/87lIsbIfGxEhMgUMEEBJwNgT0o80ozARJ7t/AM7keiTAkNO7vBuUPsN/Wv8O7AxBfFWipU6TFs5a1URrXNZFw87PJxt+MDMO2uyeDecZdKAMTdKBuM6uvITt2e0raqTIL0AUEdgan7nxwgrkuMzrCvsXVhXMKzz936Z3S0LKKQYM2wAKYOeXK1RnNnot1x4HO4YEYp0twDgBhvSwCDLC5w6dol31C+CwbVaaJgjA5M5vM4VByLfgZgdQ7DkCuxtAu0I/MoPytmEu/En3n8FQ+dXGuPlADKzXdZTyvlJ5a/wxDPOAePKYul1s3EvQTA/biX5UiT0ZS1iJuZDah/QnEeMoZnyligZt2N8dTfmIX9GYpqZsPsgGn4+yySuB6rbL+Mohr+EVNwKB0VJ0RMM6MyQGGVJDC/b71d/N+GYc/My0RAMoOBVT2KAI53kja4B4sz3pYBlinQyHBxCQQQ4C4eTKBlAGZYQuVfX7ZwzBl2Qh4690wMmqxa2SAlxOxBs5lzPTrIITgpHT/dNfkiUjy32N3AWa30k6+atSOz7+CFvQ0PpOaFukJ/3iXWnqrSJ2O2H+r3dxSyryqvDyJnqCB8RXJbaj+VZNz0vmZj9KMma2eoDtVyMfvLHaQiBJYvhrkSsJZt/+c6mqkv4LyHxjGITLcbCphC4RfzDO2Cp4cn/w+o4GBqsiCK9R7SZwJ46qLj4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AoBTcHwuckgF5JhKYgtnYA1XFDxyjU14OSn3yJ5g8a0S8RbqwpIWa/zoI+Tc?=
 =?us-ascii?Q?UuV6GjkRHSh90lWyyo1xi9Wh+S8ELY2u+gqAzxOmlTD6dpYsu3ACTaFhe93F?=
 =?us-ascii?Q?dGefG3rB1/oHILs+JuJ+8NUJtjd68PuLkIQHetbKMD96aREXyAcwkc/Y4Tlo?=
 =?us-ascii?Q?Nq0IzcEse6h0tE5IG+fDZbp2LemQYqqnCxCmQFLt77bzjmxFexluiBXMPKda?=
 =?us-ascii?Q?aIlpcZTWQZvabNlFU+7DRfdd8HY0WmKRjxK8+SuU3foQwAH0ya9VkedB6oco?=
 =?us-ascii?Q?NhXi2sFeInt3bqmHgXgMQ6qci3WGGyshUBY74+Bq5pwFgOekLLKQxHR5QMGH?=
 =?us-ascii?Q?g9v4ctHAOhmG73dhQK1pvc9oHdDv0iTdOPVeszwYlWM1wj8YJWZpOVf06zYM?=
 =?us-ascii?Q?GW+jwButYNiSl5rUYO4vLEVZrZPQyCeSzuhZRBYThHJA1EudUnU4Gbt5zrCl?=
 =?us-ascii?Q?9X/MzF1wXYjFeMvZQadE97ALEMHiLUT8O22exhsSED1oKk+p/14MxXynU7PL?=
 =?us-ascii?Q?OCUtCMqsyUUleNGGnYO4KA2md0AgL+ochhK737vAfevsfJN2jR/LSkiP8j1K?=
 =?us-ascii?Q?CGYDMUjKi3AyJZ7fQZxF5k5AnX1WzDd6/KZ6BBx8Rm6NE4xAbv7CDyOBqnB0?=
 =?us-ascii?Q?q//qxNZj74KokUpEqiTjlKVS1m9sNKkeMe7N7H9KZiJdZclZzRwto2W3Vilj?=
 =?us-ascii?Q?iNul2Cdh4CatZ85PKLhugQizrU+ZsQ3Lhxx+PZAFyU9Msm0aTUCZG5x1uVXe?=
 =?us-ascii?Q?GA4bqN2qaO1f4KUhQX3v5tpitSTtRaw1Rda66sbO4ie6q12vx3ou1D8Q562G?=
 =?us-ascii?Q?k0hKQNAYUcyoR0j379PzpqBCxuA0WG3eqWtx/fgaXHjBqtaHe+8kDojTHKu3?=
 =?us-ascii?Q?W4xm2Jp54Kdh6cgdFiTnlL4SQob0RPb9LAuIeLw16kJVYBni2TQhFvh9zkTo?=
 =?us-ascii?Q?zKexcdYHXPQ3ueZjvD39LteiN2ETlnn9yV0nmneMq8bICF+/dT2NN7UNWcWg?=
 =?us-ascii?Q?1RvxazYYzyUwMMsH6OoAWopx+aQMSVMKvb4DKF5JCVw2RryJtOnhvEYIR0xQ?=
 =?us-ascii?Q?w8Ew/DyxOYoCuYszWqWlLsJQB6OQopkJj+dWJXN2xUkJ1BLVX+MWN5DDqMHm?=
 =?us-ascii?Q?OU3liEt3G7N9Tdde6NrotCWLcmZuE5cncRjNKKmi3j81QKCaaaQbOcJe6gBz?=
 =?us-ascii?Q?stpsxYIQ4Q9vurFNhpLCYLoIdVW7VXOJo+RpdtoCZTvXlb0Sw/TLU3KV2kB3?=
 =?us-ascii?Q?JGkEEYss1uki2vkukZeFlf3U8uLqI4nTtqyqvtM6ZQ4xV1ceQmMJD2KPQ7Ar?=
 =?us-ascii?Q?EvFwQSfRgNQYEeobmYLJSif9RnS92KKz4WrfL38RIFu0JTYz1xw4vqjPIpP7?=
 =?us-ascii?Q?3GthxNNKYEnQDxHisRT57Xoq30rwHHdAU7IUEGXLjJ9RgSXGIPpd/XjSq2wM?=
 =?us-ascii?Q?nOy/meYurkBBEajIkOGtG8veKngOJ/38pGXYSiJ8G/QnRYoAGRgIoAMWjcgB?=
 =?us-ascii?Q?KvmQ2AUZnx03am4TU7BJgFk8wnQ1irT7dmgwE6RyChrM1wG+Yn8JibEZAk8/?=
 =?us-ascii?Q?s0jV1NmCz0XZsKAhwtM6hVXkID3hCDjWggn/L0eD?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e4eb73b0-658d-444c-af21-08dc3f3fc67b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 07:17:12.5146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sbq4Cr2TT8DYfEdYtplBsz6eJlFs/GyTSC6kvrtXQqLqveMOdYE/QHFTnGkO/kaQ6G7wWSoLMfZx3i1UzahewA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5274
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, March 8, 2024 4:21 AM
>=20
> On Thu, 7 Mar 2024 08:37:53 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, March 7, 2024 5:15 AM
> > >
> > > Mask operations through config space changes to DisINTx may race INTx
> > > configuration changes via ioctl.  Create wrappers that add locking fo=
r
> > > paths outside of the core interrupt code.
> > >
> > > In particular, irq_type is updated holding igate, therefore testing
> > > is_intx() requires holding igate.  For example clearing DisINTx from
> > > config space can otherwise race changes of the interrupt configuratio=
n.
> > >
> >
> > Looks the suspend path still checks irq_type w/o holding igate:
> >
> > 	vdev->pm_intx_masked =3D ((vdev->irq_type =3D=3D
> VFIO_PCI_INTX_IRQ_INDEX) &&
> > 				 vfio_pci_intx_mask(vdev));
> >
> > Is it with assumption that no change of configuration is possible at
> > that point?
>=20
> Yes, I believe this is relatively safe because userspace is frozen at
> this point.  That's not however to claim that irq_type is absolutely
> used consistently after this series.  I just didn't see the other
> violations rise to the same level as the fixes in this series and
> wanted to avoid the distraction.  I've stashed a number of patches that
> I'd eventually like to post as follow-ups to this series.  Thanks,
>=20

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

