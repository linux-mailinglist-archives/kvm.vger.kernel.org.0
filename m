Return-Path: <kvm+bounces-8187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9DCC84C2B1
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 03:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 645E1282022
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4A6F9E0;
	Wed,  7 Feb 2024 02:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lter6zSS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEB8D27D;
	Wed,  7 Feb 2024 02:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707274223; cv=fail; b=SG8OUB1E63uVEf1gHQl5ag3ewZps3EU+1O17zhQwgRPqsjnI019F9Uln/RL2Zuge7cYpon0h348V7WvcfFQrN0rXqxGsQgAJExtH8y8GjsHHEONcRyYH1z9/nakEEmSipYpgjv503qO5/LBULHqI+wtrP8NuNaXcluiigfWmy6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707274223; c=relaxed/simple;
	bh=NZ7xBpKwgJOKJkXxpNiOOCDvUbiiEOl3eAamfkPwL6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TAJe8V6G1fLdMHpkwsawjrkAGhonwe3OHkNcpph9lSa0RhGwM/OWDlcqWa/L4pxHBFfsH8L7qorytcwL5p300Sx3ccn6PAie+ntXf1iMsE502ZD/ug3r0hhyL1i1Et2RLrbii5YUJWehcZCFG7tI6vaAcPlf/wkE9FliIZT8HCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lter6zSS; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707274222; x=1738810222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NZ7xBpKwgJOKJkXxpNiOOCDvUbiiEOl3eAamfkPwL6c=;
  b=lter6zSSHyApi291SRB+K/5xFkMMozQ/+eP3xfeCCWyXQrWrbu4X9ud0
   hnFDo0csJHoAT4l23sGwa/M+GPpRUQUIZ6iBH7eg70uA0DA9JsreDXovs
   56RQ99Ga+nT3M/KRgqmloHIYCpxK2l/3C9y4v1yVZuFKQfaLI5bX62Rnx
   WIXKnp8aB3322fek+F3CRFI+SuC2hVTAX+7wa3XD/Y3fn1hEvSF4icxOQ
   5uoVx3cAlupzkqWx+6WUVPvurGVW+IXaYtn6hOFfYeOaBm9F+erl8WAqi
   SCm8rTsiwmtosXoIJ0WGwOMDMQz4P7uFyvZbnofWbPxrQI9pNnlxujiET
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="803228"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="803228"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 18:50:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1192040"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 18:50:20 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 18:50:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 18:50:19 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 18:50:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJrJEp8U+S14zCbl9UZoB7gU078emIIY8wUEPJp9Ttwu3/Cfc/wqvljAt8L3lH1PGzYQZe4zf5ZHPf9Qv3u186jcDlgoS663NWpAUQrgufbhMgvf+m4o+uUUa5hCSUYvW4NYcZ6lKu7z2dJdQSFg8QbavLrBqRM3L0z1y+Ue6lIFbpLRFsJ7Ya09ZUalWJBoPzMgwRm4ePunmWQ0p9zOw4h3gLSjpG2kPhyguMVDdifRh+TRPRqtc5FkrQ3R0BYTCBh/eQprwhUZ57aQ4eKyJ0yHamLK/SpHPnH0uEqBUkASpQCtTAlra/DGv1o7re7IhfC/nXbPs3wAfqv1SOc6OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0du1sR+WleoALCGIGEFnhrD+MnWZnt4FpnkOkQXNBfk=;
 b=S7poYSMGg6CAg0bsA/GKmMB4LKLYuDpjLFPF32bhSiGBQmzUF+6tHpGVuyvrHjeom1R1r96AtmDjeSfrly9vX8eYfTSM9Q2rXa9iTHZnc58AFnohASCiK5Ol41t1rU53jQeVAbeZ4YrI8MhpSpSQUQi+rm71QDc0qk4QHJuxZ12+MjDFaqPvgl4G6VFpkgTOidHMcxsuYRKEcj+F0YLkX32WV47M7GDAs8Cp3HPE8oug6fw3IFl7LiiMk+LIY5x1gEXt8vvLOT3HEWr9nEkKUBJrwEyNEL3/zf3baEALJ0+teBqeGqnANMRUXb8bVxn9X9Ckdslb8EwSbNR6OfvRmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7786.namprd11.prod.outlook.com (2603:10b6:8:f2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.36; Wed, 7 Feb 2024 02:50:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Wed, 7 Feb 2024
 02:50:16 +0000
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
Subject: RE: [PATCH v12 13/16] iommu: Improve iopf_queue_remove_device()
Thread-Topic: [PATCH v12 13/16] iommu: Improve iopf_queue_remove_device()
Thread-Index: AQHaWWafjR+FYFS4H0+ifBk3us7aubD+LEXA
Date: Wed, 7 Feb 2024 02:50:16 +0000
Message-ID: <BN9PR11MB527603AB5685FF3ED21647958C452@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
 <20240207013325.95182-14-baolu.lu@linux.intel.com>
In-Reply-To: <20240207013325.95182-14-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7786:EE_
x-ms-office365-filtering-correlation-id: 59b28788-55a8-4bb3-c7f7-08dc278783ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3qNTSBJiSAZiFJSrbDt1bUuT+nfqlzY/J3ENBN//11B40s86aMmIt7a/Q1C/rX+IUcaf/s4WLnAgDHi48U3FPcH8hDghgKtAqZ6HwJS6hfR3syyC6eXA708Ti1KuFv4BazGXBwHw7Lt7QJ7+sEYABBU8chbDT3CwYuswAKQm/u472Q+AaJa/nZWZAixAu+R9GuGcM3jOi+szwHF0YRvRX6/j+PLlwG5nB5izO3hfmSUmmSmTbDtr1j+gP6W0Hz8atZGVGU0lyjha3/N8EoLkbFJ8guG1LWlTRW7V6NaLK31PYN/rvyKNP2kjPEQZGeP6Sa9VYEbdXLzL/2LJSjDwtPiL3qivUk3vmmVwiGsft5HtBMcv50EfxG1CEFqUBg3A3A72Ce/5CwRadQYIXZESh7Gz3LKacu8rypKdawumZObVp2m8qtTjoVJeZc5wA5j9MUmgxmuw/o5ztC9Fl6c1q4Ss8RlGVhiJ8ZosRgEgUszoxNsVGQUB4HsdCQqYL4JsYmysigDl95Af7Mf2L7ZQ5k7skYPhhG96seJGDASi0GSjZbgnqqbD2BnuHJbU2oQNVBdL/bpgCsprXtkRDYVSeB3/3WUrZn1ELKEkcDZHzOJoVWmel/4/RWgZ9nV1nDga
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(366004)(39860400002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(7416002)(5660300002)(52536014)(2906002)(55016003)(41300700001)(86362001)(82960400001)(38100700002)(26005)(122000001)(83380400001)(33656002)(7696005)(6506007)(54906003)(9686003)(110136005)(71200400001)(64756008)(8676002)(478600001)(8936002)(66946007)(66556008)(76116006)(66446008)(66476007)(4326008)(38070700009)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OsK7klrUdRDbq/N8vjxsWrUIWzrYZDOMl/0Z1KO65aUU4J3VRupgpSlPVrsM?=
 =?us-ascii?Q?0dI8fv/Au6EAILFz+gDvgIuAIfw4xuBFCuBoLMmpuT1rJ1Ags+ICNFKmWU0l?=
 =?us-ascii?Q?wRwFnEdYdZyvBf4dd9t814kOT1U8p1jzknN7faYNE82aTpfyDD6QlZTywPq8?=
 =?us-ascii?Q?TJsYqxQPiknCYYO5Cd34fO7xCr++PBbro+uWFwDLzYW2jN2yBESW+lSnYGv1?=
 =?us-ascii?Q?pI4C5D1GO9LDNojrbNzx9+QxhK+5X7S8jJbtauyIZACNkIH6/v4SfYSKgA+X?=
 =?us-ascii?Q?USMRVGCZGJfyMILd71bL1dUd9ao0Ml/lxkVwF62+L02Bc2hH9lo/C+iNiPGU?=
 =?us-ascii?Q?ZPJlnKT1nh5NTX5AaJuhaPPjk7q3N5DknjtACqbXBP2nzBrrxILMhdnFfRCR?=
 =?us-ascii?Q?JCEi9E8ZMxJ72kZ0RtdYEjoVWWMzdzX2VH+EFVNAKCFlq86IGkgDWkRwsgk4?=
 =?us-ascii?Q?MrXmzodf4HSlUp8u4x0hn94kPEEyZI2Q6Kjkge8zCLLp8k4FU4ELTE79zfm5?=
 =?us-ascii?Q?yqdtSjXD3QQgH8Za2O3Mqoj6+qfpEdJFBH6PrFao5WZD4R1hDcchv8PjvxBm?=
 =?us-ascii?Q?lZpnqx8o/sQc6Ksezw7okfdzFHrgqKD/AClrtbFCiqRIrY6jRcB55QBmbsG1?=
 =?us-ascii?Q?VtbpyYZeROTMOL/KeoXf0MKXMBOTHGZAbWaaZrBWecrPUfihpcmQwt+fcIY2?=
 =?us-ascii?Q?s53qcMGiqHrIbIJPj4IJqT3t5oZQgeE2ApUIGTmIvlIFUM7sbkKSttoJvaZJ?=
 =?us-ascii?Q?4MBS9+CdOYg1VzRExRfX3TxS0Ca7gek853oq4HSXx/v+vNVwNgCjXsUhHtgw?=
 =?us-ascii?Q?cbaoGLSGyyu3EBPHWBle/EP5V7eDFMP1ZvQefqCccWQQeNSXdjBtEkr0+V37?=
 =?us-ascii?Q?IgriftgY1ogu7UVuDXsBIVu3m8vc22AVOt8xMexyxvr6xahtaE4/L6VoPht3?=
 =?us-ascii?Q?i938EfgnTNvXNgiBucaQdsSRuZvXuxyqR5w9sW5NdKRLL0yU0HosXjv3dnG4?=
 =?us-ascii?Q?xTYEgNs1j+QSHTl9dxrno9IunW41z89lyGQOeefAAVJt7XU8KZpc/F+BeM9H?=
 =?us-ascii?Q?jAKJhAaJwe0yFzTs8r1SqAbtglAg+fhI1XZoySZ0MQsNzfScU2HZsd52m0hY?=
 =?us-ascii?Q?ObcovRScvKVzh5qrlbCZWtRITDSQFB4GWxAo/g8eFlk9NyrPu5lNGZ+uISb8?=
 =?us-ascii?Q?g6LAmDqrmbVaO2Y2TCb//iecNw1iT/+huG9Pm9H8B2Fp4+34jrjtIdaNb52i?=
 =?us-ascii?Q?JWTQMgdXMqOHGsh1uXtmdndeidxB8Z1SwIo3WBeI9gOH3/6QcVQnIIfyH4aw?=
 =?us-ascii?Q?y9c7d5zIPWvlGhKE2feXzfCSHe4aPu5+VUcWLE6TWaTPWvHzBi8aY/JkUsiO?=
 =?us-ascii?Q?d5z/xqSiip2/EeLJynAZZzd5kjTUik2SFzKkJDOI/oVp5laiB680sz2HPr3j?=
 =?us-ascii?Q?89HLCn+WZbQkDKyyB7R1j2/n3X/R+tmLiEtoCDZN40I59wK2WAr6xqr4pE6U?=
 =?us-ascii?Q?Gm6G1oFKUFw180yD8zaFFwVxyA9u8DTAhtxPO2mjYxZ8WVW8aIPtCIRplRrR?=
 =?us-ascii?Q?iF7ojdy7xiWvO7x3TkxWWqG/4mwRBhpF4ZShg9VB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b28788-55a8-4bb3-c7f7-08dc278783ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2024 02:50:16.6495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u9njTgmWLgYBhv/dCS6/PLMA8I2Evqd4gPkOzobiZ2w1PqfOnA1/TkP9zetQAVbT52NApQpqs6gT7Xsg5RoU0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7786
X-OriginatorOrg: intel.com

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Wednesday, February 7, 2024 9:33 AM
>=20
> Convert iopf_queue_remove_device() to return void instead of an error cod=
e,
> as the return value is never used. This removal helper is designed to be
> never-failed, so there's no need for error handling.
>=20
> Ack all outstanding page requests from the device with the response code =
of
> IOMMU_PAGE_RESP_INVALID, indicating device should not attempt any retry.
>=20
> Add comments to this helper explaining the steps involved in removing a
> device from the iopf queue and disabling its PRI. The individual drivers
> are expected to be adjusted accordingly. Here we just define the expected
> behaviors of the individual iommu driver from the core's perspective.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:

> + * Removing a device from an iopf_queue. It's recommended to follow
> these
> + * steps when removing a device:
>   *
> - * Return: 0 on success and <0 on error.
> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
> hardware
> + *   and flush any hardware page request queues. This should be done
> before
> + *   calling into this helper.
> + * - Acknowledge all outstanding PRQs to the device: Respond to all
> outstanding
> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
> should
> + *   not retry. This helper function handles this.

this implies calling iopf_queue_remove_device() here.

> + * - Disable PRI on the device: After calling this helper, the caller co=
uld
> + *   then disable PRI on the device.
> + * - Call iopf_queue_remove_device(): Calling iopf_queue_remove_device()
> + *   essentially disassociates the device. The fault_param might still e=
xist,
> + *   but iommu_page_response() will do nothing. The device fault paramet=
er
> + *   reference count has been properly passed from
> iommu_report_device_fault()
> + *   to the fault handling work, and will eventually be released after
> + *   iommu_page_response().
>   */

but here it suggests calling iopf_queue_remove_device() again. If the comme=
nt
is just about to detail the behavior with that invocation shouldn't it be m=
erged
with the previous one instead of pretending to be the final step for driver
to call?

