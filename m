Return-Path: <kvm+bounces-10206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C65AD86A7B3
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 05:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C958289608
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 04:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263C820DEA;
	Wed, 28 Feb 2024 04:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ns+6vK9o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6218E03;
	Wed, 28 Feb 2024 04:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709096133; cv=fail; b=vBeVIn1MA8z6IvYI6AfV4y09aXvOmtkS4CNta7L1avqZFK25QtJtN8JHCKSW/DYY5K8CTMK+XS1g+wwOtanAzlwwtC8bC4y+aWvaOfGZSXJc7BPbmZWGn8Q2xIZDOxQvcbWStgg+TmE2pv3f3sYolNcJLIT1kn+BI3YVE6lvGKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709096133; c=relaxed/simple;
	bh=Y2lx2Jxs24uY3+KwGeF9xU2WnAYb/42OXjEn5eeRTB0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pm6kEdXGy463AWtO7lvqyCD2V3KUPEBYxKuujSbvRXe4MpwWDivjXyhoJt4YoNgX77M+YhRRBvcEArGKS0PmE3UmJ8l78LtuDXvu/kFsy/mJ/wZzEOFWcXeyAMRX1CPjEBdl8GBJT1+T7dZG1u8wnv7mEPqtU4FjN3GqkOVKjms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ns+6vK9o; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709096132; x=1740632132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y2lx2Jxs24uY3+KwGeF9xU2WnAYb/42OXjEn5eeRTB0=;
  b=Ns+6vK9oVGSXdEsipXUUzHgZYEzt2gUDdM1wEPyT/nm27xlB1qEZieL1
   XshaiboYH0pVLIbBC9ESFxucppZ17EaCar5iRRQeVWD31WtTagLu6IOq5
   O8sV0ehTuD7ZUKXKXOVqSo+sjsAf8iuZfFKYGVH4lil8ASO1Hi3p8C5Mm
   isW99cWcknLccmu0HYW6Mjvq/hvwN5koNymwTZaRry+mFfjsWT6enBfEB
   o+EK196CGme3CaIG3Uy3or/gmEltmhRtnWqvGVf8FGmJBdsveIpeZhisI
   oe2kAK7+2lpbE4NiWsQMwFyLAQ67JrxH1m/VzOk0HG4pnqrgZgeCc0jN3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3640042"
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="3640042"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 20:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="7341871"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Feb 2024 20:55:31 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 20:55:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 27 Feb 2024 20:55:29 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 20:55:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWMQbh1T8d1bP0aPgo4blmhRGrKjGjofDaOT9LCoI/oIH++e6//iqUHVv0egcbG9DUeQrujNU8ZR1smhfMPI6m4i9D/jlw/eHSh/2tOHnRqrJ3DHjuncSfAhcg5JeJNKK5YvmxiHzkWWlJPk3w64AIxAs/OZKP/rWqIvSvkfM3TM9m0AGSce9BTrSKS7PB/J+JPGEg7WXSMs3h4MEdLfCEMnHP+pMwwnRDX0I4gICDaSCB6KIB0ByTtwDIYjhCNplz3hZI4gXS/T1N/8t3ed2Gm0o9fG0HBVmePTcXt97JZIc1aBGDKYXWsoDacbEKXzH0Ptbf3SIRa4hs/mn327GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2lx2Jxs24uY3+KwGeF9xU2WnAYb/42OXjEn5eeRTB0=;
 b=cvLszUdyMBU6xxc3l+pUDhC8tE2xZMwwWkfHiULpDjoT1gbP+z0K7jvbts4A3KniSLx1DzHChS536H3zQfb/W/RqY/uGzhxVBFPQsT9bhSgnmYRHBuZTRRXGlWrIdFXaWp5pYhxQEnRN3W7y3pdG1Rtm3P/HPhdN2N1bLtdYBjpOc0HIR9verOz8zTszUr/ER2i2CyxrBuO+eE8CLx3dmbVerYuckM4B7HZt1A0/nkC9+idIKpACOks3VA36pLaXEhTPzgcurVTPdUClRxa3/Wh2ykEJW5UZPGp+85AuzbM+XZIGXwMPsUAJuvxVKUOsmlggRbOpPDqy3Ql0hSpQ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4781.namprd11.prod.outlook.com (2603:10b6:a03:2d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.25; Wed, 28 Feb
 2024 04:55:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80%7]) with mapi id 15.20.7339.024; Wed, 28 Feb 2024
 04:55:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 vfio 1/2] vfio/pds: Always clear the save/restore FDs
 on reset
Thread-Topic: [PATCH v2 vfio 1/2] vfio/pds: Always clear the save/restore FDs
 on reset
Thread-Index: AQHaad2jJNcjBgqFYkuS9gCWwg3GnLEfMNhA
Date: Wed, 28 Feb 2024 04:55:27 +0000
Message-ID: <BN9PR11MB527658407AFC552ADEF6E3ED8C582@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
 <20240228003205.47311-2-brett.creeley@amd.com>
In-Reply-To: <20240228003205.47311-2-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4781:EE_
x-ms-office365-filtering-correlation-id: 05081f59-f8db-4dde-383a-08dc38197b73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GuzEMza//hHPq6xlJ+8e7Enl8xBqv0lIIBZMqq8hngmg28sxYJU7jJUE/BiS8viVQkd5M7w6tjhbRGBNZs/Z9bxOJ19bLwcj8rf7I+vNeVx7WVbUs0BW5uoC36lLiSE2GAg9WiBJn88bNmCdJEIgtMIpQ0ezZoNy8QerUmvqBvNHgm86l60XtGCPgyHSdfl18rGGhddyDX5ViNywQfREg76k/dyzJvml54BAwix2oEk698H+uvDZuG/DNchhtOwBohd8lRNHvHMYwsKq7rcxFsMRnbaKWbDCdrixD2QHd7RyDq2FVzfXiTqk+Bwzf9Ummt08PTAJrgqiS+00nx/gIGQWcytJNGAG+g/omV5ZpgWB+TF+v3PGfe8sLptNzVvJukJZftIFKJPs3uh6mMtj1MJAZeyvOKAazi2dwozUwLVw6jCrrs2wJdX5P1aKZ1xQbaOeeGJppIb91eMCHU3Rb5a0aRHhoqRM2MTG87tE6Y0An7CRihxWqycXNLv561rakgxJcBv52bg3TvOq33BCdOBDFyYbVl5ZYy5TDQZu8ke8IIlV8avLq3gMG0K8EHZuuBS+7eHsGmDFVNN1SifwUkB+PnW9bZL90OUOKd5U5BNYqj4HSzn2oM5PwAfacgsHfL8UMN20Gw7FKcLtutKknwGByZlve2GJBM9cpS0dDoGnsdW+pE/anrT2N9v6yE6rDdvoV4EYe9qr8VtB3ywPLGc6Fw9McYGXuVvsiQROwkQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XTwjXGCODOZRHB9xxXStcKWu6CGjcG8zh/Omix3qmNHv9QmATujUWs+eqD7N?=
 =?us-ascii?Q?NRk9dwfW14rHXl+oAaxa5Zjtqtn88d6ZCNmCV4DwukgaYyeT7tsBAQnAL2IK?=
 =?us-ascii?Q?5O9LMu1RhfdVHbjkFzyUoSzDmoL4t/n1r0DaCsnNmQd7LnJ1C6crAFRBvAyO?=
 =?us-ascii?Q?lKnkdZlZNlJwabVGG8MfXleFt4mVEVYdG35OPXMjsWKPspVmFthX9Hm0v+aQ?=
 =?us-ascii?Q?94k7Kest7TLb9vpgemcJ2QthlVQmryGShGHnb+I/OBo3UTf4r2bZgSEVvPQQ?=
 =?us-ascii?Q?LPGuqHCElbigweOLoAq/suMIRmcNUn5gx6CCI9FwNnlxYra8OIkdErP6DNe7?=
 =?us-ascii?Q?T2XnaiZuhruQSgtyFzHxXrFmjl0yIEGnFJaAUB17yjjT7hLgqGKDLR1K4cVo?=
 =?us-ascii?Q?UpS6pGFfQFJoPhUSfE1rg0NvpOWaIIlf1TuP8cLMJ3nbvLKB+Rws1d2kcK11?=
 =?us-ascii?Q?Jh7Eq/fBFqvwTJTDJ27nUF9Fhhm65QAiEXq2zxN7NnvaxzN0nqxj7o560jKB?=
 =?us-ascii?Q?1ZEe2T8zMnY4mVgKVYaCCWb0eWF6KQYirhni/+qJwAmkzWBp/ntm9dkR3u7W?=
 =?us-ascii?Q?rw9Y4z5e4hKTKdia8QRpAgVuannt3MX5CVgqC7oush4a4udmwSUr3Gi/CVLH?=
 =?us-ascii?Q?dxZVi/DR705HCxJMd/8LDByiAdUZ5f3kDLPtVmwNung4rmSl16YZ7h4kRfD+?=
 =?us-ascii?Q?SkwkapoOCpHan6HcsV9rOkrKQ6S5Qyj+npg02N/e9PSJH9o/1mIK14sJ6g0N?=
 =?us-ascii?Q?vMcTPVH/lDToVTXMXI+0FKhC5UuujtF3zKIQo5ytWStGRQ3rROhBmwUaMTfa?=
 =?us-ascii?Q?M63Np3VxMD9HmB5gsrkMwXhiDDcCPRVaKVZ6cfLFEWWQd5hGJS33zHEItv1g?=
 =?us-ascii?Q?6MoCEmwZZR2jbQpUBRGFpzU8CQQDv5VJ2hqU34rNlwU+CnFMW0t9x/NzGvCl?=
 =?us-ascii?Q?KYwXqYgX9xL9r2u9yrb7wVWnBk1tTbNaIftm5Eii/NdbmiQKRlHWxQbWVseS?=
 =?us-ascii?Q?nLYtLH0uFYOmIzpQ/RZICFhobfNetqo92b0QlJioIDHiRhDDYDFry8f4vwlI?=
 =?us-ascii?Q?DpArM0757wQuMtJ9RyZCemQ0tcI47qMAlwixMHbp7bm9ysVVTdNlwSU1SfX5?=
 =?us-ascii?Q?Szb1r9ZAqt1DnvSvSXoHHlo95jC39GaLlEncMSONlXnN2CJAwaatpQoNu+Ok?=
 =?us-ascii?Q?Gdp8EGDv2JQbl7R4nU2vlUxp6+/fVIuzpf9rvL5KleL1AudoYoAAvdyr3DMX?=
 =?us-ascii?Q?IrAazII3OtltTV3D4JKpYMElAs0Z+Yreaye5rauAaxndE+XOAlFucX6KkskU?=
 =?us-ascii?Q?G3bjt3olXpATB7//ToQvfTj6785kDUg1Hb+lopVr17HNyM7iV/43072DH2iF?=
 =?us-ascii?Q?Q+kU1bHkdhcH30ZlAwHJL5cIH6gNzSXhOjv9rAQEsIZ8xnr8rsBrP0F+G2JD?=
 =?us-ascii?Q?IR5xDiHVg0dFciyarTQJkePlW3dgREGvFQqQzJqyL2fXx3pYLNY2pBaZjGOg?=
 =?us-ascii?Q?ZcWNgWGKo/JUkBhSe4yF8PUMPo6XAJhRlw4iHMyAQUzzM4LHCpMCChHP9TQY?=
 =?us-ascii?Q?dORawC4FLviNYiD+yZN0mMmWm3lv6yXyM8G+7/RJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 05081f59-f8db-4dde-383a-08dc38197b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 04:55:27.5663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YLvT9Fq+WSHHMUzWU9RW/HM5eObUjcBDPe4My8EPy8YrCh3qPOIc6wJZu5+2UI4xhNsvsao9P8CmbZAQmbni4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4781
X-OriginatorOrg: intel.com

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Wednesday, February 28, 2024 8:32 AM
>=20
> After reset the VFIO device state will always be put in
> VFIO_DEVICE_STATE_RUNNING, but the save/restore files will only be
> cleared if the previous state was VFIO_DEVICE_STATE_ERROR. This
> can/will cause the restore/save files to be leaked if/when the
> migration state machine transitions through the states that
> re-allocates these files. Fix this by always clearing the
> restore/save files for resets.
>=20
> Fixes: 7dabb1bcd177 ("vfio/pds: Add support for firmware recovery")
> Cc: stable@vger.kernel.org
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

