Return-Path: <kvm+bounces-27291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CC597E709
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 10:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8766F281450
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9020F57C8D;
	Mon, 23 Sep 2024 08:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="azsqZnbJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95374DDA8;
	Mon, 23 Sep 2024 08:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078441; cv=fail; b=tDBLH2CsAwsa3hNvuz8cbJyWOOttYzksPBYBYQh/wDzCkioGTKrsEYBhTIUDDR02iDwB+hZ8bINn7YRTIexMfffk9S19wnAbWcVmoXCXPAWLaYzv2OBQzY1UB4hD8LuPctvrknHnJDvpIAX1qB0ete81in1m6nTA3T7+Z3ZSdtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078441; c=relaxed/simple;
	bh=a9QDcsaRaQsP5p9ik+zGhHO0FPYVYpGDvf7KqeBRtBU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IhLiZtstrEW2tnNcn1/WG+fDQ4OSPMMaJq7tXQ58phGO8tSzfiFSVoliHForQpnoAY2H6TjTSDbJCU7YhvLSkl8IwUGEO9e+4GrRbVtX/VVurrDO16XnlfO+O7/KOxDRrLcS3Codapn4KSrdA0MAQ65P7vhGBk07nJSuIA/OEdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=azsqZnbJ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727078440; x=1758614440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a9QDcsaRaQsP5p9ik+zGhHO0FPYVYpGDvf7KqeBRtBU=;
  b=azsqZnbJ+i0t/OH348+E2ihATWI1yAwO4NNTUqpLz4Y0h0QSZ4hjTnQP
   a5xcfICwAKBeJD2RtWLts6yy54PD/A3fJw2vTPTqozd6dvbaDVzeBSuX9
   y4d9MwFUImMErAmCv+EJr4R9IeSAtGV31N7RodFGpiCjfpdaVDqZy0VhR
   bzt5d/XSxWvnlAH4Ous55D7Fndm5keVVhpe1tNXwiMIytdUxCuLEHrju7
   79kweLKZUo8zXa5vVICjVhLAkypJMOC38mHto2cRUXjr2rreu17Hr8eIY
   87uJJgN53/ElMtoPu1End/8X5b9iGWSiOxl/qih507TjkbRIuTRTCq1Cq
   A==;
X-CSE-ConnectionGUID: jDdv1J80Qkegf0HXHrctZA==
X-CSE-MsgGUID: lev3k/z+Q/m3JGmafuW2HA==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="36584398"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="36584398"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 01:00:39 -0700
X-CSE-ConnectionGUID: xpKyUivRQ3WBHVnaAyw8gg==
X-CSE-MsgGUID: brd7LvvfQyyvg3jOBJOXhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="70581134"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 01:00:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 01:00:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 01:00:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 01:00:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 01:00:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udGFYu4EUyya2qG/B/olxaBD05E2CUKFiLhCEEdKZZRtaRCSZrHkTsvY+MNoHtfj7HmEJTd4vU/0r4b0ue0vMVTjXJ/6OLgSzUMdMh8jQ/QXUwiJdSSzNphQ0pnTgh1srKFiQwqUY/rOZzh3sdyJxI5juSIUPdvtf2OYc21xJO9OSocYhUenGE9GsvmqVJO6dwDVo2X+QUnVjGBTh9ofiNBh5MUs8F9P5w+X1LhJ0GN9FveyVBydP58FLJbDGq4gcTuX41cvutC9/NLwUvBvAA29t/039WK8PH0th9ikn1/ummzZ1Dtqkp0GdtL9OtVYk53MVpHOOuLQ8Rt286XKpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PT6TCHD5/+Zj66/scyu4N/Vyj+y1UMz1/2iLzsXWocA=;
 b=Q42emLwSXnyglDRuUUOzyJ7jTPMnfJD3YlKoHuivGmlxdInGu2n/N/RajYn2tFO7rloKl/Or2cpWJe9c+FKsNX1srerB5EZ7ShCxqmmE9HBJgEunYtMNCjxHS8W/OrnnU8ppCVUTml3gENQp1vm8E0R0sPXFvFl0vNWt9Aq7ogLlC8NPbCdMprskT77Qc1wUjJ/HH/dIYfT70hLOumH7YwwQh53ZZ2ouNFKUaU2OIvkuuaxFRaOBFY5pkWfU2lO7CS7gCvD33UufCALi8R/rS7Pp3nICdCfALShLQRNM9bj/re4Dnr0D6IMNDIIYuy7rrOROKoCNjBAJfN25MAblTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Mon, 23 Sep
 2024 08:00:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 08:00:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>, "dave@stgolabs.net"
	<dave@stgolabs.net>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "alucerop@amd.com" <alucerop@amd.com>,
	"Currid, Andy" <acurrid@nvidia.com>, "cjia@nvidia.com" <cjia@nvidia.com>,
	"smitra@nvidia.com" <smitra@nvidia.com>, "ankita@nvidia.com"
	<ankita@nvidia.com>, "aniketa@nvidia.com" <aniketa@nvidia.com>,
	"kwankhede@nvidia.com" <kwankhede@nvidia.com>, "targupta@nvidia.com"
	<targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: RE: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Topic: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Index: AQHbC61f2Lb2A3OTG02PUPPHuJaIQrJlAGMw
Date: Mon, 23 Sep 2024 08:00:33 +0000
Message-ID: <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6936:EE_
x-ms-office365-filtering-correlation-id: 3142b71d-6b2b-4983-50d7-08dcdba5cd17
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?d1MMF2lW2zfqi+XksKAAQhEyoDOVYLUfd6gfSxB995Dz9m65BhUf5ERQYSfp?=
 =?us-ascii?Q?AY4Dc/lmIUntTYlejIZLvRmkD5yGaFOJ7wx9POaEYKpOo9L/Em/016W+q5oY?=
 =?us-ascii?Q?SvcN63K2s4u9xqebJ/n1IEt018m43kpXGQNC4d2+Bv8f5r3+LF+On1SxTBbA?=
 =?us-ascii?Q?/q1dR9QFLj1OifIQxS61F7HMHNk2sI+E0iuIEvhdRwIzJ9SHrfFa05dhNrXr?=
 =?us-ascii?Q?3ibHqqTY/f6/59lHoA2y6QF4GOVlY/ga0HgCBPbyahSRn9c6ALLcXU+58LaX?=
 =?us-ascii?Q?z5+elsOAmuFUDrqCDoOt/LclLNQxClfGsSqLHpW1s+s/g8yshOMhKfu/QJoS?=
 =?us-ascii?Q?CmXHRKAC5vxlWRT7Z5fBqGsUuoxhCvgGpUmPKsvxzY1VnaTe9dbZcLaU6vtQ?=
 =?us-ascii?Q?qHTVYOnhkEVWfcLCcq5ISNslZTk8ho+nScZqF1FvD0xg99SeQhr1Fyxgo6yG?=
 =?us-ascii?Q?zMTgJwDwxGRMgMwE2CYcVRLKEBlHwfKwjHYBppeOVE76IO5Q3jt9PqopQA4D?=
 =?us-ascii?Q?fovQfHmMBVe7ERklwHXCVUWsaiabrjZ+zKPlIOlTAwtEk/UNM3zY4WyN56td?=
 =?us-ascii?Q?gqxcCTtgdMPJDe5HVCRieGHUQ6E4nq2vvVW2e7FyDva2g4MsWWtCE9h8AXd2?=
 =?us-ascii?Q?ISVhJTyagqYUGKxhPvr8LfhrQ1yjZ+lbbmg6rKwmR7c1QSZRs5eo/8YKU6A2?=
 =?us-ascii?Q?+5a98B1YR8Sh2cMMqcjAe2WRYnuJVshZRdbyJs3hpTlXuNyjmR2k4BnmEaC+?=
 =?us-ascii?Q?epjWXQLXBdFHsJV2EwVKzJGdqdH64TzQBEbsTiz+22j0WAtjeBsyLwWjMpOs?=
 =?us-ascii?Q?kzeTiPWd/Pixiz8sioLiOdRObNlq+QKTXI7Z82bLRQkaufwoquMlwpHN2EUW?=
 =?us-ascii?Q?6Qu4zlhb2vNWHC6Mwgmq5DEN7J+1fn4mk4HB1uY6OgW+jiqsLk7BQuFceZFR?=
 =?us-ascii?Q?5v/AgFkxTRi5ZWQ6hJDocoYRtmNqi6NsFi2GSt47LhPY1WjQ6SaNp3+z7mtW?=
 =?us-ascii?Q?ygBmuA2zS7rYKIG0ukiJF31LzvUXyX5gQ4UpV4AmmMPoDlc6VwJG8GamTVN/?=
 =?us-ascii?Q?6ozxC87O1dfgcWSylq/dnSxAh4Ky1tG4ehMDRkwdJsn3VkaarcwOmlY1Yxgr?=
 =?us-ascii?Q?74hvQmU0GL1uvg/Jp7OlDsZdmPTlmq/z9baYMvUXZjZoJZ6Jl86LJL5sPhWe?=
 =?us-ascii?Q?1b689P0O0tdARu1W/oE4vxCHNLebO5ewPP2dq0sWsr9/wW9RhVtwSaRIhE3Y?=
 =?us-ascii?Q?4ysQI8LaSo0mH8RcYGJ62knI25J6JoXdxv666jnrAU5ZzowIL/F0wUmFZStK?=
 =?us-ascii?Q?MFURDXQp3QR3cavibcwiomwuaX7Q+jDyv16z18bqcxLjZg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c4W6f3RijKfnSqRQJUdwDYb2KZXxGJdResaSlAs3uf+FEOtMU6mVlWw3KPyM?=
 =?us-ascii?Q?sJpaGHaMrJ3Tc4gjmXBtqYBLIXJxe9fSfxZu95FdPafoLXPcHjoQEdN8a3VG?=
 =?us-ascii?Q?7kdHYZNLRvRfj1XjvbX7froA+izfE3RAymc98rDSaKyEQBWbtpL4oyc6qPsz?=
 =?us-ascii?Q?O0Bpvd+4N1ZEVroo8Sspv9DizJgpF/Las4pH2XlCgmXJsOm2YL/4/qHN9mxe?=
 =?us-ascii?Q?rmALW1eG79K7VUgF1lfycyuNhzhq87Wcwb/LikxkyS1x9MB2gECNnfljXLD7?=
 =?us-ascii?Q?0Er4wK3yL3QoR23gwQ4tMBWyFD8kQktYLy+bgOeQhHpDAqOku0gd9xYX4Zng?=
 =?us-ascii?Q?X1jts/1KaB+FQFrXwh1/b+O8wUxXlV35uNps2BZvr3S6lyS/B8H5QsNuTzX5?=
 =?us-ascii?Q?HAJcx5xabqK7ijjQEMnKIB5DhXFxuCh/nco2EhnWm28rdG6EZa053LAT2Bw3?=
 =?us-ascii?Q?Cb5f2WQUrn64A/NaCyy16jETuLZL85T0aVPZWQCZwpLAD4ytVEBy+PW21y1P?=
 =?us-ascii?Q?EohUT8lGhEu1w165Fhhb7MmgmG6PAYlzbBSNVjBejzt3YYs5lJRWxbRao6kK?=
 =?us-ascii?Q?T58stEucdqhYgH7XZuvKnQDi1pVbKpVDUHzsDDD7zodlNDK0bkK7zKbJK4L0?=
 =?us-ascii?Q?m31fF8NJHo2UD1IAKnmXI/me69ojBNqQdDVe0VP5I0q8mUC8mxYhhmfWTsiI?=
 =?us-ascii?Q?TvYJLVaH5yp/kcZ6Q0jH+XOIzMQZX5/3QOP4JnjEKGLV870yt6+AEQG9PF5G?=
 =?us-ascii?Q?sLX8+bPIvn/d1kB99SXSn2nG1FE1m4o8xWD04pEFdqlBMZl3Dnk5baLe7J++?=
 =?us-ascii?Q?irnSSaxdgU9VTfBbjSDcVkmnJwMy0I+Tah06qwGqOIHlpQja3qInWbakK+xW?=
 =?us-ascii?Q?rZWnUEkU0uRMk3H5SRWvZnbtXaLYNSkcmQZcXfSG4oVOSvAynKRxbgksI/ye?=
 =?us-ascii?Q?UdEcr9lzfQXut6b/McmzkZTc1PlyyMDdk7uEHBIxZHzP7BFfiYe1utyygtCx?=
 =?us-ascii?Q?g1N8I6Y7zCBNcPn6CMu731iBj/W7Zf0rjywrFJ6/ulgo8+Tx0a0aNAV56yra?=
 =?us-ascii?Q?sey/qVYmSHJLwKYZwyyOr8MxCT86e5DX9S/IIH61XEjvwmW64fAdb93UNpGH?=
 =?us-ascii?Q?ZTNrZvtq90kuD3/lrTs9PPnY/FSkwCmnH3KLeMCTDtp8kWPKvulM5amdZlmT?=
 =?us-ascii?Q?cwQUxJAU+tNUiZEaVPmZJqtAHHt9GCgE+5u4UTJTJRIe9TejTxvrwYkuCIJT?=
 =?us-ascii?Q?pcvFLfVbwnTY8IvCDb3REvlcLvITYKh9I19mnifrMQUGRkH7MY72vscszQ11?=
 =?us-ascii?Q?ICa07y+VPJrHbVCHVZMxDoV07ZufYeH0e3e2h2kT2yC2m5JZpo3NC9jE5Lk6?=
 =?us-ascii?Q?R2c1wbMSVCtxBt4YEMgznpq8siW1fhD0QPZO+a50NrXPO3O/1wIVVWd8O7vu?=
 =?us-ascii?Q?i9nLvYBcykBnF4O0mAXjLuWEBoku4s0bPn0Sw3/YfFZg/hXON/HyXKmVESnE?=
 =?us-ascii?Q?59X9A9+GAyIAae7uaK5DTDRsmtRbZt276dniPhqCXa964qET3b5QRmI5Ybxu?=
 =?us-ascii?Q?nZ7PUTSNXlnGZuCS9zqBL8+erOM0f5R4plLZMiL6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3142b71d-6b2b-4983-50d7-08dcdba5cd17
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 08:00:33.6378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QqzZPDmOWPSDqx2TFVZFULz5As2ljG6pGEzrTaj/9m3OfXGGIhbGsx8rtpZ6FJHk92NjHtAmEwn2hqnpJWzkrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6936
X-OriginatorOrg: intel.com

> From: Zhi Wang <zhiw@nvidia.com>
> Sent: Saturday, September 21, 2024 6:35 AM
>=20
[...]
> - Create a CXL region and map it to the VM. A mapping between HPA and DPA
> (Device PA) needs to be created to access the device memory directly. HDM
> decoders in the CXL topology need to be configured level by level to
> manage the mapping. After the region is created, it needs to be mapped to
> GPA in the virtual HDM decoders configured by the VM.

Any time when a new address space is introduced it's worthy of more
context to help people who have no CXL background better understand
the mechanism and think any potential hole.

At a glance looks we are talking about a mapping tier:

  GPA->HPA->DPA

The location/size of HPA/DPA for a cxl region are decided and mapped
at @open_device and the HPA range is mapped to GPA at @mmap.

In addition the guest also manages a virtual HDM decoder:

  GPA->vDPA

Ideally the vDPA range selected by guest is a subset of the physical
cxl region so based on offset and vHDM the VMM may figure out
which offset in the cxl region to be mmaped for the corresponding
GPA (which in the end maps to the desired DPA).

Is this understanding correct?

btw is one cxl device only allowed to create one region? If multiple
regions are possible how will they be exposed to the guest?

>=20
> - CXL reset. The CXL device reset is different from the PCI device reset.
> A CXL reset sequence is introduced by the CXL spec.
>=20
> - Emulating CXL DVSECs. CXL spec defines a set of DVSECs registers in the
> configuration for device enumeration and device control. (E.g. if a devic=
e
> is capable of CXL.mem CXL.cache, enable/disable capability) They are owne=
d
> by the kernel CXL core, and the VM can not modify them.

any side effect from emulating it purely in software (patch10), e.g. when
the guest desired configuration is different from the physical one?

>=20
> - Emulate CXL MMIO registers. CXL spec defines a set of CXL MMIO register=
s
> that can sit in a PCI BAR. The location of register groups sit in the PCI
> BAR is indicated by the register locator in the CXL DVSECs. They are also
> owned by the kernel CXL core. Some of them need to be emulated.

ditto

>=20
> In the L2 guest, a dummy CXL device driver is provided to attach to the
> virtual pass-thru device.
>=20
> The dummy CXL type-2 device driver can successfully be loaded with the
> kernel cxl core type2 support, create CXL region by requesting the CXL
> core to allocate HPA and DPA and configure the HDM decoders.

It'd be good to see a real cxl device working to add confidence on
the core design.

