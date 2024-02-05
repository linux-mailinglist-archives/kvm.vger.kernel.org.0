Return-Path: <kvm+bounces-7974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61426849528
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7267FB2100E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017F6111B5;
	Mon,  5 Feb 2024 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LSrkl86O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7083111198
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707120861; cv=fail; b=IcIk2hCKk+aOzBsb/d7pu1ZN7uLL+Cz9+Wokxi+n/YeY/uY72HAGJA9+HXntmv0z/sWN3vLnyCYW1z5VTQOeJaKP8LuptdA02wnb9hIUCBuEY4lL4jKBHT696Fc1w+AwaGNIb2oUjnOavngIISn2Q1ceCxMk/lJu7h6qbJgyQyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707120861; c=relaxed/simple;
	bh=CDGImt4KGpiGJfXf8j0bGAdT62QZk9pFrytMOTNtyPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TBmLR1iJ/UrcLulY5luSHy4ik5cTHsQE7uuShSYQgZkDxhml79GeYXmUtKYwgwFWALzrg2wlI7Xmzzjg3AkFCrH2HIR2M9efT3Ph6FBC7dSN8PAkDdIMI+Uanxt3FUp0jnXJvzd/sjlt9+l5yZw48b1jYtyIygFbosZrAEuc9dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LSrkl86O; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707120860; x=1738656860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CDGImt4KGpiGJfXf8j0bGAdT62QZk9pFrytMOTNtyPU=;
  b=LSrkl86ONxBJhQUHWZ4XzEduCdlf/5mQxNs6CovIW/Ap7v5RjoDAsZ68
   yDa41uq+xEgxEMw1X/y5k6LeQEO8nNbKzi4Ug1JtTZMYRkt2E5/eIDV4n
   axrh5a9BfcaFP1pkDotM1SxDILiCr6eDfMpM39wNrlQNxd9K+zPjJWjOO
   ox6OFYFcxhVISw6oASdvYWoZ5eNC2YBPxsgK7tDOL5flpSz72kMtQyT0s
   3C1Xw3aSoTj2eMnyeQPzxZScsg9Ll2AVmK+9XVqMsk3Qy0+VZimGXzQza
   zxk8DIIRfDBDxk+LzB8+DWB3tysCAD+WUnAJT26M6QBTLZEubFJ9jbmyx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="17888334"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="17888334"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 00:14:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="823797584"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="823797584"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 00:14:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 00:14:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 00:14:14 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 00:14:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tgu+JqO5AFVPE7iUazz++pW/PQ+XHmFjEzqNESYKPsOGn0pXAoZXO1RQsivgG3ZFN11TlfHPCF5F3e6u50UYPhYvmlj5S3/Tv3h5xX+VC3z1vs/IXu48PCEbgEjkkQyV+JvwQhcYj3qUiePCRLfYuByx7OEdAfGWMTMUyK0t83PomU+2IfzHS0h3tBrPDojISspSuf2P0Cv5HBuC8WudB89yTOb2yrM1bLqd2RRhg6C0cnSKPbSPH4J8ZTgKJ6E3JNHV2JZTJhsbi430ljNBOk62VW9cJbIFRQappfoRaFvshH1mgC2jlnkO57H7fhtU31dB6LsBvisiUQU8q8tTqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDGImt4KGpiGJfXf8j0bGAdT62QZk9pFrytMOTNtyPU=;
 b=HU4XQwSsdUykeekRGRLJy/e3kMaKg1VPHBniAQlShAFfbHB6uG2BV2c1H+ZgAHKwaOhYlWgTDrKr9pLg1qIcPRAoG9XE/xuEDd9bU3/Ddmh0+OjreL2UFqOUlICS9ln70DPAknizxmaT6hqDtT2ObaHYeDs+KP9zo2Mr7OjOAWUAf+46JfAFInlpMpupMyl/djcHFWOHyQ//eNHXwwmkgjLSRASD0/glFWFUGyhqJVLqW8HsuJzc1MYoRAl0gg4cvXj8Gp+L9PQ5OKmIwYfzRB+HvKhMCXvnHGjFlE1gA0RLITEuRpyWxnNqQ1mD29UrH2prq+tcwdOTHs1a/9CC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5461.namprd11.prod.outlook.com (2603:10b6:208:30b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 08:14:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 08:14:13 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH vfio 5/5] vfio/mlx5: Let firmware knows upon leaving
 PRE_COPY back to RUNNING
Thread-Topic: [PATCH vfio 5/5] vfio/mlx5: Let firmware knows upon leaving
 PRE_COPY back to RUNNING
Thread-Index: AQHaU55d0ikioHyVTkOv13yGyPfC7rD7bq0Q
Date: Mon, 5 Feb 2024 08:14:13 +0000
Message-ID: <BN9PR11MB5276E2C0F1FF06570C30AD338C472@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-6-yishaih@nvidia.com>
In-Reply-To: <20240130170227.153464-6-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5461:EE_
x-ms-office365-filtering-correlation-id: ae26abaa-6ea8-44a8-3ec4-08dc26227026
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7p8bMbWoTOZdeOFEt9H+ECxSTJVDOAYDRmqqbqINev7jrcF6xFb2CiLs3fx+fsKaHM6DHUYCZcTiAzAzdPlA8qhABx8HAW+T5AdpOclbr+kehD/XTmzZLRuf6yeBM4DKvlgGUqG9pXn5MMaeqm+itXhReQqBZrVcIAzp5Q6vZBT9ckGM3mPSDOz6iHryKxBF4smmVIcl+cBYv79qJoiCZGfBSq64vigHV3HVPJeBI6Lv9qI0RBkm7cJDpEiyCksCX7kFjqy7T+ZweJzdNktVoZbxwdNuSLD49rS9MUufRru29Qc2CoRxrHBu3DwG4N1JynHdYzH50nLqnVb0K5LMEbfOgFDdk55r8YvAjRq/LPCdbKDd35zGMuwewH9vaAyUjl/E/YaDrmQ4xU/R1g6ziTaQKTMYE7IdvdE3ACfcSeQUJAksbvBvcHjqxyS3ztiMAJC3p/ZZmiRTPXgpkrb3Xazr8UH+UJbrAvAZXgCnT9s2cDVUbeYLuaTwNks3huYdXRWyWjuRLM0t6EClkX/WeZhHNHN8Xx+T+lKlng8wlnvPu/1/YlcZaMUFomxETM0b7F8XEUN+Jrhxqx5Q4jTynbPPu/1sJnXt4K5hzRoS3sAnjo84Y3lREXeieo/VVnS9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(86362001)(55016003)(33656002)(82960400001)(122000001)(38100700002)(41300700001)(26005)(83380400001)(66946007)(76116006)(4326008)(8676002)(8936002)(38070700009)(478600001)(2906002)(5660300002)(52536014)(66446008)(64756008)(66556008)(66476007)(316002)(4744005)(54906003)(110136005)(7696005)(9686003)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jQytvLxIPpnYLqqJEaeSv29QJMOnuGITz/NIc0m6Wu7fpgbrfP0W38VogBBP?=
 =?us-ascii?Q?HfHoe9BNtjOO+8nLumT5AHS16A30HxgaoNeOf2aX5SeNrqwWUUAc+HHfMJ6q?=
 =?us-ascii?Q?YAr0v7NgSwMzNaE8cF29IBugby5FWy1U+/MLWWCHXrzfN6l9g8Eu4mUWVwzq?=
 =?us-ascii?Q?3yMcIOGEUG4ylRZNA7NpkaNFhejpqXojoW+tWrh7fj2xIYyutbI5RhwePm7r?=
 =?us-ascii?Q?efn8wBs/aX+IZKp43gqTtNhlzcnwsSy43UOwfG0b6yEDXfd9i7RGGLgfOqqs?=
 =?us-ascii?Q?Iqyi9wM5P9SCUGzrHciFztEP1vnaPnt9gOp90pwCo2XkvkiHi5u/Y6OOgmBy?=
 =?us-ascii?Q?E71/JVZTX1OXuMBH6rrVoxuVt6x3Q6oX/I0cd0tW8wXEFciykC3jhxDKn2yb?=
 =?us-ascii?Q?rfuOY/MuTveF8mkBbVoKThtm8VvM8MN0aj/xMDMKNF8hDWObjJ4lxq73eJ0F?=
 =?us-ascii?Q?+ikjfkKWLO6bL27/8VgZMnTXJm+gsq1jETBH8CP6jgPHz23VJ6NlsUB68fld?=
 =?us-ascii?Q?xTKaemAD20VGs1GabRZNDSigBMmI25RbnI2OS4PkdlAhOGaj892kHPCtSBvf?=
 =?us-ascii?Q?dKZThskrcV1GX2xst7yDmMMIujficTdzxEVdyl+aQAYyof7cJ/wkSvw7Y4dY?=
 =?us-ascii?Q?MZyGKzE5L6D0vq+HBxNYk+pPsbbxiw2K92slb9bYjbkjA08MXaa6fG6jGnGK?=
 =?us-ascii?Q?2X9FUSvQ/P/jlh9nAyk1gSLo0YjzEpkD5LxJCcuFQTtNoAFZEjyetvxoUHAP?=
 =?us-ascii?Q?U2WDSwHmoVJH+In/JCYRLD9ez0j9g/0uQJQ4rfMaFNiumDU/j+1XRA4ToleD?=
 =?us-ascii?Q?OKIcGBKRcdtzdnpoGg3tQoh0tHyqfaiQRk6mvvHlfzgNWjAbnpVypeaFlA67?=
 =?us-ascii?Q?5eH9K4CTcWbuCdmmbEZpkMcr7jzqfquh+c4035dF+ksIvCO7Ew8+hnUGctKg?=
 =?us-ascii?Q?2foaQaD8z3VZKGXpGYscqY7De3HwngeMSkexzFplQrl0WAJvJyPWYlocyWxM?=
 =?us-ascii?Q?ufmDhGv+oVTJgE+izQKnRvBWJSoSVr3J02bmzHjnjN6v5zjXAVNFijx8Noip?=
 =?us-ascii?Q?1/pH8s4VyNZRe0hXo6Emxf3CPu2Hdr4f99vBWkXRa/cT0j09vKsMNc/AOUbB?=
 =?us-ascii?Q?SrYIshr0KenWULtmhUIzmRViyq6Z9rPABuMKL4wI8iBWvtDn4NLxejKBarzo?=
 =?us-ascii?Q?fZ3LLcoUigpUIs5C4s/+6MVhjPplabXQWQPHpLq/jVCXLe9RkEllf08rqvOK?=
 =?us-ascii?Q?CLPT7/erTVr6QfX4qZUAvM4Y/NHNW+1WkY9pEiYJeh6xuL8FH1hl4GhYwI6A?=
 =?us-ascii?Q?XfIz3ptw4Jbh6OOrrpM+PWebh0y+lmFJLcTci2j4w/6RHz/Ter7padUpI/o0?=
 =?us-ascii?Q?xXjqrtfNX23YYEook9xR/0NjCAY+6Fw+FliINH/Mt0EyfKCW1J8MJbjSPhry?=
 =?us-ascii?Q?Stem/jFf2STah0jC57Pvy9EjSvdKWYSAoBPBna5Md92WDByBrUVPemvC1uDI?=
 =?us-ascii?Q?le7CS4/vbXeQ5cUBClAK3g82M3+Z/CdsCYrWoTuAJN+jKMU/wOfhbw4e8b7+?=
 =?us-ascii?Q?Idm0sJwMVxbJlbXWfX2ywiaRqWB85JFgr2RZRBMS?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ae26abaa-6ea8-44a8-3ec4-08dc26227026
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 08:14:13.1957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ojVm/Hio7E7rlLCZO4IauX92QyneV4+AedgGfHmML/qtqgQT/J5A5thH1pmsbr0z6Rs5Z8l1T9hjViYf5X++w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5461
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Wednesday, January 31, 2024 1:02 AM
>=20
> Let firmware knows upon leaving PRE_COPY back to RUNNING as of some
> error in the target/migration cancellation.
>=20
> This will let firmware cleaning its internal resources that were turned
> on upon PRE_COPY.
>=20
> The flow is based on the device specification in this area.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

if fw internal resource is not cleaned will it lead to an immediate error
upon next migration attempt or a failure after many attempts until
internal resources are used up?

if the former it might worth a 'Fixed' tag.


