Return-Path: <kvm+bounces-8089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD3884AFF8
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E08B62863E3
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46002C877;
	Tue,  6 Feb 2024 08:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TnIKQq1U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CB01DFCD;
	Tue,  6 Feb 2024 08:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707208345; cv=fail; b=iSNH/vGgiNQcOxpvxfGzkLlRdJBH354r2+5briebje1Y8kd0Ukp/DjUkDJl9D+1FuuZopFaBLLeluVDshBOXrQ6Olq4i0qB7Xr4e7RIqs3JlF2NITPt1vip6NBDkxRYJ6qTKmc3k/uUgMeBp/fYA7BMYHxPgJKuxQs+3lfW4VZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707208345; c=relaxed/simple;
	bh=NcSsCos5n5qRI5sF2KtP/5QUup4pUVZ992gVEkV/i4Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UL0ZMLjbJUy1nsBWNOLk6ZQ/0QFyPNnX9F51SZLBmzqEY91PFV/BvEg9SOQVFp7PkZLmXxDcn+CTqorzGHsD8ccxyVvcxumMs2J0/OdXVgr9CFBQdHTYGqPLakWZXApPb1CsXsiaWNMPwhqGCbO+Nftm/NnqYWxSI9MVbiVcvT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TnIKQq1U; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707208342; x=1738744342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NcSsCos5n5qRI5sF2KtP/5QUup4pUVZ992gVEkV/i4Q=;
  b=TnIKQq1U7IArynBsDgmueUibSVl+ddF1vUma3pMylxxY0bnWzpudgfwr
   x78E43pw5q7vhvbq7yaHVvCjpkrwnoZQJoZqbruBG3yYhlvkVOsi62TEe
   mvLlP0Bun/NalXIbtcVzt3U3lIbjl1N0RMG0ptqV0iRQcUyHotdlWvb86
   +4xv/y3PVFl9VEnN68bCS7ue6zOg2tyPS022Aa/+Uer4X4oo6xTAYE2gj
   ZXipEsBJSDpjFiVlihW0BDtrpyFX26KRjeD70raEitCdO74uCCmMi8/AF
   /0F4NHVSOceo/SzlH4qeAMWo+R1zVztpbU1SQ7kuzIP+JikIdYSPCwa5A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="852053"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="852053"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:31:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="984220"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 00:31:59 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:31:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 00:31:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 00:31:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFMBXhd2puie1n+vHoVc3gcIU1UVpXHMBO60xubIeIItbiwoTqg9ruHYLeYWcrMHX1aVyEiIhDlZ621jmV9oi4ayvhX0pH6e1Sf2F0AdqnNTPjG51W9j7Y0l4IOs4NwwBpC3k9RcXr1wZh4/PA9b1gx7Z6QHbaVko63buOZIWy0SUzAktAi4NnSA8yvmw2oZmO7ongR5CAM2fysxXP6iRNbtVR6xd0YOa2IzEKd/Kq25E78wLoBzf5Z/UeRXFgWT0oxouDm4Uw6z4QI2bLGQna2iL38jTuqqtVDmGZVga1LS354fpgy27NwWdVX7oyj26MCupBJ/eHEL4ME5UspyRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcSsCos5n5qRI5sF2KtP/5QUup4pUVZ992gVEkV/i4Q=;
 b=DwcpFh2qtKXPDoTPZQvKAC5LUQOew2+wML+enDFC1WAqrzMPkf4ITN+9bxAQziZyKybUp8ZjuTImr+rd45XXkpQhg3p1IybYtpOHckF5Qa0xjoKatBGviPqYoSWFogcPdRIkiGPBgaWiMmUUsI47daDKuLnn2Hem8rxlEHvCeH0OZtftirVJLnGVbD08fO0wh47hsARxsxIAQUXP9tGFALottNyRnK79eD4phxZTzejQj7SD3QWxhiNRHKr8kTPfumq9k4Z+z/lfjcrxvE8teGhK+2WsC/KxOwSdvyCXTpAFniyZyIYVHX9XlPGoWEWxieiLQv6g/tkMdsUs1w2GIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6296.namprd11.prod.outlook.com (2603:10b6:8:94::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Tue, 6 Feb
 2024 08:31:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 08:31:51 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, Joel Granados <j.granados@samsung.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v11 14/16] iommu: Track iopf group instead of last fault
Thread-Topic: [PATCH v11 14/16] iommu: Track iopf group instead of last fault
Thread-Index: AQHaU1R69Srcwc/GAk+an+ZmIUzfr7D9Bxtw
Date: Tue, 6 Feb 2024 08:31:51 +0000
Message-ID: <BN9PR11MB5276D08766EF06B55F471EDC8C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-15-baolu.lu@linux.intel.com>
In-Reply-To: <20240130080835.58921-15-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6296:EE_
x-ms-office365-filtering-correlation-id: c42c7936-d9c4-4861-06aa-08dc26ee1141
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OMhpZQz8pyZx82szFefjwwt2oNBu51tFEpYBG7AjkUTr7bd1Ru3fVl/W1F9Klfa2XoEYjwnZeHfgfAaQXrI3Z0ji7VG6mAh7mpKDWDytg0OBwmkTKw7dze+zt/1ZV7/uZVX+Wg2xJNl3QFtk+aFh1vPbiSP1nEFlonLNjdURcPdjjWEjtLytu4+HWJoSNfpbb9AGGl+kvMbLoREmvlUkTPfp6Rl0+BVhs+oB2fXpBgIE2uu4z6GB6biHliUV2zxtfRvS8oFhpgpbSVpsx6oTYPJVbjqlItn8cvOcEJroiHOP9IuOTfH7qhe73XCtvfBI/tz4yYnwVnoO7Ib+suapJtQYtQN9ll+YiiZhnX5Qzmlp7p2U0/EWjlSqKQgPUHVwk0FD4bLHpGdq6gaH9iD0qLjLKev0KAqoeONvlEhDHpHDd7h/Kbv8eG7qxs8NtlYNUrbw6AD93qmrZRhA3IsXqRTv3mTY9YmCBnwN96ybGDJIYXV5sT71coARR0aiPRFzeim1GbhnEwnML6hbyvKLlAgI3QO4dg2hH28jwdKHdJRRxZg8+Ex/40KVBAO4txKUsZN3c9m14J7VBKNXXcF29c/zJdZ1Lbbcj417rW+Xf4cRIW3zOJ1kITt2JMstaAYb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(376002)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(55016003)(33656002)(38070700009)(478600001)(86362001)(9686003)(41300700001)(7416002)(82960400001)(83380400001)(26005)(66446008)(316002)(71200400001)(66556008)(2906002)(66476007)(6506007)(5660300002)(8936002)(110136005)(8676002)(66946007)(64756008)(52536014)(38100700002)(7696005)(122000001)(76116006)(54906003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LEdT4SfViL3MKcqryNYqBR6ijN9HupH0jtPRenBxKorlZAppKctNHXkFjQZY?=
 =?us-ascii?Q?hKQL35Cexny4xoXMGrGSAuxq3D0x/fwMYBekTQuzf9oGV+FgYtID2v6mGNq1?=
 =?us-ascii?Q?ldExNKakdnhxoQIOLREWncIsR/k6GfU+CvGnxBxwZ+NILbmAIgeab5h1Bz3A?=
 =?us-ascii?Q?aDfSJqIrff2Vi8TyTPFkHmzmup5p8Wm9cMYfNMIH5PWfQ2DwcCFWb6rhwZ0q?=
 =?us-ascii?Q?zlgK9YteASn9Zhdt8cZRUG0i78PDzqhzwlMzATsTZ7lt08/LLFzllpoDvqWW?=
 =?us-ascii?Q?qoZUp2eEfrx5YWCPrWiP8870a7OlSjvZJi7xOxibFtxmFpnLdcdfqnp8FahH?=
 =?us-ascii?Q?L2h5XuNHo30SIqzuRulPqACaVkrGsUnWhhAJqTrIAtblBevNZiISDzPLuus6?=
 =?us-ascii?Q?hUxta8wRY1PSNI31Rw6/1/L+rWpjmz5bzs8irs2QK+H1QotzClv1bWYhJMoC?=
 =?us-ascii?Q?gxEa0goHq5Sa/k76rYAKU2/QraT5mIok4TXR+EJnKZUrLrLaEBh4R9RNMJAb?=
 =?us-ascii?Q?eHIf3TbFJIRzrGIpocIDqdGRO5YszokK/474E0sD6vkt0wSPirRN/5V19BhS?=
 =?us-ascii?Q?dcfU8v0zzpj57xhZZSh8bwq+Kweb+cFYx7YehJ5UAwLsfh45sPclTiREfpIT?=
 =?us-ascii?Q?lDhnl1gvo63A9ICEPtvEwQOZjx5H+gWfF8bFolSLubUqbnA33wgotMJilEwD?=
 =?us-ascii?Q?eC5OpA40xbUUEQBx9FiPBBAiF6wiy/4QIWR+98BwXPvrEOU5nJloEjNEBbc3?=
 =?us-ascii?Q?MOqT/b1pmHeEEVnRgH8uVbVvTIBxLXNynnDiHVZYeuUSAk6uip3HA0z4ooTJ?=
 =?us-ascii?Q?+Up8RvDq/7ejJmaNiljWIwgFmdwzeP4Z0FzNZd/EVDoWKrkud5tN0LmaV06+?=
 =?us-ascii?Q?gi0MpRSVK3U0Ic85Xxy+dIFs9D7ZVjY+2e6xTbGq40eJuVS1VpIl1d0k40+Z?=
 =?us-ascii?Q?0Atp4LoPY7ObK1WkNqUvXR192Gg9pVy62yLKRyBCfeJ6J0k6+HJ3sIW6zXOU?=
 =?us-ascii?Q?z6vgzjwEOvFc6gsTw9ehNaHTKsnFXTIU14EuyoR7xZWDtFzp//CRHf5Z829a?=
 =?us-ascii?Q?+yZGu9jgEf1Lc5heb7jp/Ol4hRBq/9LD836kviHmN9vLudDZ28qSxNsPfH2I?=
 =?us-ascii?Q?0U+8sQcMouYQDigSbYjGqmrVIorKJsocYdeyRjBHZsHKmpRwViX8aIwRyEch?=
 =?us-ascii?Q?GSF/FLUzUmmo9VdXHr8856GqkoSZ9Ur7vNwNEt1PGtcrGIhzJyh4Y3YD2REc?=
 =?us-ascii?Q?7dUuzJnO/YJPKwtu/ksabDajBOXwbyfiNxfQCMTc3TlNmJ3Vr7XSZJ4hVlwb?=
 =?us-ascii?Q?Z780X/wHo2zWXgxq7zNHjpUdqh9aWGxSs6RGgVlKkCUrhpdtZMZcNLqtcc9u?=
 =?us-ascii?Q?8mw8EV6S4TeRLKBxANh4slTSzWRjQeEz4c2gn/MZrOGUKf8zuEw4NeHNsLJg?=
 =?us-ascii?Q?jX/K+9Bq+sk6k2gWI7ZnOK00YKJlbFrtvFGN9vXWrfDsn8u817yZ84z58uF2?=
 =?us-ascii?Q?LsRpDHD2AyPKqxV43ZPp3TJhJ7PC8dko4KKTRwKq4Qe4ZWF1gw6Zzfjxsf2i?=
 =?us-ascii?Q?/Kns+ZTL4ZX4D0tz629SrurLZCa6spSm6PpGcYjM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c42c7936-d9c4-4861-06aa-08dc26ee1141
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 08:31:51.2932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: btNSiemUFGoY/XOWXuhH2hsfJw2+fHbOsK/0T4kW6j43Hn52y+Bjxkwa1biS5wo7Zzm/BwcrbRxnJspICV76aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6296
X-OriginatorOrg: intel.com

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, January 30, 2024 4:09 PM
>=20
> Previously, before a group of page faults was passed to the domain's iopf
> handler, the last page fault of the group was kept in the list of
> iommu_fault_param::faults. In the page fault response path, the group's
> last page fault was used to look up the list, and the page faults were
> responded to device only if there was a matched fault.
>=20
> The previous approach seems unnecessarily complex and not performance
> friendly. Put the page fault group itself to the outstanding fault list.
> It can be removed in the page fault response path or in the
> iopf_queue_remove_device() path. The pending list is protected by
> iommu_fault_param::lock. To allow checking for the group's presence in
> the list using list_empty(), the iopf group should be removed from the
> list with list_del_init().
>=20
> IOMMU_PAGE_RESP_PASID_VALID is set in the code but not used anywhere.
> Remove it to make the code clean. IOMMU_PAGE_RESP_PASID_VALID is set
> in the response message indicating that the response message includes
> a valid PASID value. Actually, we should keep this hardware detail in
> the individual driver. When the page fault handling framework in IOMMU
> and IOMMUFD subsystems includes a valid PASID in the fault message, the
> response message should always contain the same PASID value. Individual
> drivers should be responsible for deciding whether to include the PASID
> in the messages they provide for the hardware.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

