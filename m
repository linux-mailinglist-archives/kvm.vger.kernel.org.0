Return-Path: <kvm+bounces-14737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE408A664A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D72F92837F0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF48839E5;
	Tue, 16 Apr 2024 08:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q7ugUH24"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C02E205E10
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713256735; cv=fail; b=UsOz1x9NSDIqUHlWeJBx8MlD5VWTdbW3JbQRN+kwLgpDC6aej7gk97wtW5/Q5185qkLKh6c0ouemLr5c9TnrInKgiibmDa1U3v5u/0dbLFGeD79MG+esp4DLXvTn8W8VMEp/KakftecU+UmkgUYiHUvGXGEe22vLyW2s0lim4vA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713256735; c=relaxed/simple;
	bh=WI7qb+QVFYCA+ej3Dg4eW7sq/qi6ba+Dj18G5Bm+xTI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XjFjGv+NUxF9OkzjY03FDp54FTHkLO91QEpc80oVOQLgSejCj22H+x+1/vocD6s89LgYiismohe3wBUMZkZUCtTzcnJktGR93wznt9tfU3S6Y/h1+Nx1W+8KkAxINnWWcVs4ItpSHsCgV5i32JUscLql8lHX3q3NWOXIf+/C4VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q7ugUH24; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713256733; x=1744792733;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WI7qb+QVFYCA+ej3Dg4eW7sq/qi6ba+Dj18G5Bm+xTI=;
  b=Q7ugUH24kgUupMnOBa6S6uHhUmbNv7cPKAFfN/F6eTHI9BPK+Cubs+qQ
   bcd21X/Ga11MfK7POsICsgR1ef64J7oRAIKU6mRJSvUtZ+q9D3QVWJ5IH
   R7SP4K3XQmOCZPf+T3hp9EDW60VqouQGh7tm0iQWL5t4PUj3qqoaqqMGt
   sMRv4r2bZdW1wacrrlv9Wrz4Jo0+ktej5idfcFmJYYi7195Yjt5L48Csh
   OoLJNNSBfGN7S0wt9amXD4bDQUsNxrnNi2YfgNVouEIPAfhjGaFDDTVxp
   e18+CTfjGagTX6/Zs7FRYibRGtlfeYSWBMeCMtREJTl0QeOTMfdh4FcLA
   A==;
X-CSE-ConnectionGUID: sHw/Lt1NTKC/aVTIfj18IQ==
X-CSE-MsgGUID: nCpKeLucRnWO1QVAfg4w9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="20103687"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="20103687"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 01:38:52 -0700
X-CSE-ConnectionGUID: v2d2lPKpR7WYtgjurlnf7A==
X-CSE-MsgGUID: iVuAdk1FQ4auxNZtY3ZcAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22227599"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 01:38:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 01:38:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 01:38:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 01:38:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 01:38:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcD8FTGeN89m1BwaJKxsnnYvr0aj2FAHYEoFhYUJRX0FeGlDA+EJiWy/5byfpGd0FZ6X3+gdJZwOHdnqitkSqClfBOCuisIvV7+DAUKmALv7sZmnsD6ygdX6kH+DUdP+oCwhm9KltRvwveaBgOsLr5Q/PdoJp3VZN1dRpGC+NVF1MzQxQ8UZ7TVtwSzcXqJFctHlCy+QQNPoioMVrAytx7nt8NEBvMg/dzADHBovT8IlvNAhD0tmIQkrNZ9qWADJAjj5cXQAFBdv9cqrtT45UVIzl3Y+P6Oz00IXxbq2+WTkjhmMhPrLh+JBiymsjWSv6uoSGoGDmTbAWdQ9CaS6cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcvkFiaVosYlqbHOID9nblFtrZ61Mu6RR9Vl07alxqY=;
 b=jqNS3ZAf/xoKQWlxWUnj3/u32vQzwpmusO99GvKKwbt3qpVagswl3C+MDyx7+cXGdII6wd2+Fwb4fP+UWDL9G3m+RPgBUaazLQcrhbRY7EgspetmnW+nfp8U2vVCqYjEWq+IlULvL1uGzTYOy0SZ3B687+O8Pj2gbZOYel5H2/mmgAn51RD56yJThEtj7n3dptpDXIl95vvwCGyeMKbCQx1F6KEpGV+mFwpfOBw14TgGg53TAIxqdyG1vBqp0Q6RQ/Zsm662Jidtyl4gcE5pOBhSmvyyEsG55H4CvXCspFvwHtsRyaFgw/IPAgRhdzsYm+37ShgwElp17p/3g/VDMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8484.namprd11.prod.outlook.com (2603:10b6:408:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 08:38:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 08:38:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhw
Date: Tue, 16 Apr 2024 08:38:50 +0000
Message-ID: <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
In-Reply-To: <20240412082121.33382-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8484:EE_
x-ms-office365-filtering-correlation-id: 06f0ad5d-2cdb-441b-3472-08dc5df0a400
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JWTJxKlbk0CXeeSmkX2KND8tSs1O7cgq6tDH45Tg1DfCHHBFQk2sS5QvwHXfPwOqlugLeXUhTpuU0IVoA3ty1MfiEUCwV3J94FZxvvdhWkP0hsaWVk6znw9MhMQhrQLyCJf1qNWlgyCCcTBVfOqSbGES55PO/6utE9THhm/cgo80faL6HE3zOXHzd2dulEKevjdXtoS1pv/jRC8Pg91oVcD6JTffP54gKXmWm4B/1AxM/uwNDvjBYZm5Qsj9/V6g0q44BILRb2fpgdsb7f85DeSl8vG5n2347nhwncLaOpnrCyDjsrDXmVT707h9/fEcnMinIIePtMrg414KcwVBFK8rTB5OMbZo2UrjQXEtet05IDfqnZ+45sNAwwFLVxTi9ZWY4HKrU6bUUvromf9H/Ch21z6t4S+qehxMW2CAutPZr35MPQ8wCh1t5v5bWtiDEAxDwJZ7wkzTAq18e9t9wYBZdcGmF2gwhV28Q0Yi1TeYIr50dvazPIglTXZjBkq7XQ5wbbtVW8dqpFt+sHWiGM0BLqrrm40VofDx7wPYxEKz0cl1W4QWc/ivFkRRBXe5e+uPUL/aSxFj/zk7C+034tysJCoxSMkd3Y3b9ej8afhmvWG3xw4CXR0qdZVKzf6y8IZKS72qQiwDfQAkdWHxVl53IUfaABw9iZfSt7Xm444hWCDZHxXseQPZ9l272roF1kMIN7SCBnQJaBAbymGImUf/hPM1crH4QPlaZTY0wVY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NukG+MkdorFtkKbLK6SAPBLkUtB17adT7WniulKwKJpM32gkSVtZGTk5xEdh?=
 =?us-ascii?Q?0K683jYh3zZfgWg5B8C5sqWm1xSEK4UNv5tWSdgNREMYiRWUNnixWgwsNHlv?=
 =?us-ascii?Q?+hT9t5t7xbV6i7Fa/Y9WwPr2TBk7HW7nzSjlHW4W3zxpxYTH0Kh61tEUnqS7?=
 =?us-ascii?Q?A3UHjZ8F1aOc4kffDTF04fnrfoYfHfFjXYBxBwVzWY+8wIqvTJ0KlMbeRThv?=
 =?us-ascii?Q?UnUHRFSwh7HkVLRnDnk5GECVttfZwkfz85VCV39i6bcu/HX9Luv4MFzexuIS?=
 =?us-ascii?Q?novu9vp3sQXv495mAx8eahf/0Cawc9ASaPGRMNVO0ScBaRXQmJfMQ3dysoxY?=
 =?us-ascii?Q?0pBC0aiEdBJi8PtbIr4Jb4CC2nJ/OLnOoYa/qXj/qZXjfnOH6SY4LDbiuW9j?=
 =?us-ascii?Q?XepA7ojZQgfaNt4keLQlWhAcbaSUfipEjSWIuJJUeHQpst0BX7UI1W2eNTRK?=
 =?us-ascii?Q?h/gqnGilamAt6DwZ8xhQbVLg9eQX+l+dqtygKWaa+Jxo7uoX4z5jp2Um0RIX?=
 =?us-ascii?Q?BeYBXYXkaE8IV0qFN0bTtfc92d7v8Eubi2eDGYr6VEQyt9l4Lvg3T0e9EpxH?=
 =?us-ascii?Q?/pzaCrPizaNJqPDtu7o7Em67vAjAT/Uay2kF/bOV6J09/ZGwRWbF3kEkGrBV?=
 =?us-ascii?Q?kdWfSJp1yVZ/ITzZmI06/H7+Xy8WMSx/uxnnOgkSkM+WCCgsDdM8FDcJs/wU?=
 =?us-ascii?Q?zPYik52YSemw4clNhss5thPH+Y9TCsGL3vWSv2Z0wx3tCmEOVX7OmezeZwPt?=
 =?us-ascii?Q?cysqU8YbYE+pWUEB554c/0qjdP0IZOGQa7Kwc7Zq3xDBbbJOQD7qKNkMGz26?=
 =?us-ascii?Q?AzGFNuQBMYm0hHXrFHUGUZuahufRdvJDbc9YCsZPts3J2KXqjyt6pqYhRm2Y?=
 =?us-ascii?Q?T7Oc8Mkmrig2t1g+1fhXUXHupp6GwSDj2iPK8DPO03qHhKfJ78Q5Pa6RqpdF?=
 =?us-ascii?Q?NbYdVM/cQc0vNqjqotmXRk4pZn3i7Vw43AuAGYnIZhxvYOhV26YR6MAn0xBv?=
 =?us-ascii?Q?G8iVKUC1GN+PsfxqcNboknnZdXNoqyAyxU6UkHcgpraiXb08cAELvrUGpbTw?=
 =?us-ascii?Q?lXm4hRDmfWPTxyW5vGfZ7FQxFbFXBgaWUTk9bDma45BJi0KWR3mZbUbGUlJQ?=
 =?us-ascii?Q?U4KNtgL1UiqFgbdkONIs8knPQCBct7FKJvPGPwjvuOvnSbUtBLM+j07Ipalw?=
 =?us-ascii?Q?d8coFCe8gKY07yO8LSWPkFi0aN7k5d3lrbXSVNJtZJU4QZ2SWaGJelnyOkNB?=
 =?us-ascii?Q?fy3xcA/XSiehvH4EIxtDyz1pGMqGTFruIYoP8G82gEydxdKaIB47BQbg64lD?=
 =?us-ascii?Q?UAfADQ4LO5g5Ai8TZb1Jy7Aqx32VfU7KeRqlDLXSuQW7NP/Gwd+GwI4epH1Y?=
 =?us-ascii?Q?PamSUDodGwq5w6fWL6Q2AHlULMOs4wsohGqdFmabfHAYWUaFXp79RTjx3A6g?=
 =?us-ascii?Q?B7tHLWAwCoO8u0qu1erkNlbuQsu2aC8+wRCl+wgb6Ynz1LAF1xjKH7M9A64B?=
 =?us-ascii?Q?ErAVIvmIcxKs4V3ubXiTrqJqDI4GjoJbOLmipEY2Vxq09ufSe4qDz1IknqmQ?=
 =?us-ascii?Q?O3jRb+fP8bumby41mDgDwDahm8d6LUY3dKOo8Dq9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f0ad5d-2cdb-441b-3472-08dc5df0a400
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 08:38:50.4292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWgLkCan6JPqsEJ4CEDAAQEt0p7arcVqqA7XO7P0F2g9sprdK0JvuIQsSRMSHBlJOFHHSc9MxZsyxGikB9nDRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8484
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:21 PM
>=20
> A userspace VMM is supposed to get the details of the device's PASID
> capability
> and assemble a virtual PASID capability in a proper offset in the virtual=
 PCI
> configuration space. While it is still an open on how to get the availabl=
e
> offsets. Devices may have hidden bits that are not in the PCI cap chain. =
For
> now, there are two options to get the available offsets.[2]
>=20
> - Report the available offsets via ioctl. This requires device-specific l=
ogic
>   to provide available offsets. e.g., vfio-pci variant driver. Or may the=
 device
>   provide the available offset by DVSEC.
> - Store the available offsets in a static table in userspace VMM. VMM get=
s the
>   empty offsets from this table.
>=20

I'm not a fan of requesting a variant driver for every PASID-capable
VF just for the purpose of reporting a free range in the PCI config space.

It's easier to do that quirk in userspace.

But I like Alex's original comment that at least for PF there is no reason
to hide the offset. there could be a flag+field to communicate it. or=20
if there will be a new variant VF driver for other purposes e.g. migration
it can certainly fill the field too.

