Return-Path: <kvm+bounces-20582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63C71919BB4
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 02:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 882A91C2247B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 00:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4A4322B;
	Thu, 27 Jun 2024 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P3mgfDAJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B66A17E9;
	Thu, 27 Jun 2024 00:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719447433; cv=fail; b=nh4n4U+X9aFlZegl574DQz5gPrEPLt58O1m3Iu+VDEnqpoJA6yl0euUf/Rn9p0bywG7J4xwTPJ+NSGnR79sfQSwDNd5Qy3cPfMxfQSwJ/i3Y5uOD4W0Xenyx7Cpgs0Ijl6uE6/YkXFjf39rervbkkgHN4j0YLoOCQjJVFb7917s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719447433; c=relaxed/simple;
	bh=OY6020+2teclU/GgNm7zcipueMfCxfOgAxJj1Q7Y7QY=;
	h=From:To:CC:Subject:Date:Message-ID:References:Content-Type:
	 MIME-Version; b=hXdyiXpQ2kUSQWIGQ3EDYrngbBW0OiJsxm1KIzIAw0x5guCsr3H80QtTLiFlQH+Inc4FBMDY/ozD6TyhBkFIzXatibYuj06WuzKrt1PZFB7D9DYnUWa9rUWNKzZRo6ejYySLZAq/p94+6xl/2qnxW3WfmkEjdsp/cPtiTMvvS20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P3mgfDAJ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719447431; x=1750983431;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=OY6020+2teclU/GgNm7zcipueMfCxfOgAxJj1Q7Y7QY=;
  b=P3mgfDAJqa1I7c8OzB0ZwtEhBLsiqzgo+nTy2YQVTCWnVIVrWF4cavb7
   ZtQRXsFJLGeno9MEq71Mj6/dtERI4diZkn0cmNQ0rx+gIWdaxoCNiwtKI
   hwvyCKPVA4zYkEXlj997NivuPcsliCwvmRgdbd00qBnXzvs1vdHC2aEii
   mzCClIS/jsp395G5mI1YJiEgtseFyw2AMKCFGDT2ZrAor1y1Er/AweuDk
   m5jGEkqSphnsESqeJF+RE0jehMFX9WyVEuxg1UJEUIvBeaajGvm5RgZyU
   ngh62FNuiePzSO/aom1kfZ2n0zVcDKh/h6jtMkE8BuWHiTUBU+XW6/43P
   A==;
X-CSE-ConnectionGUID: vj/8uEY3QCOD/a8RCIQ5BQ==
X-CSE-MsgGUID: p3q+qlEqQfu5BXva97okwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16776466"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="16776466"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 17:17:11 -0700
X-CSE-ConnectionGUID: d54zfQ1bQbWEu6JYzcGs7g==
X-CSE-MsgGUID: jeOTp27oRjqv9tz9X6enyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="49350810"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 17:17:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 17:17:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 17:17:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 17:17:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaxadKokKWVLHTkcmUPCHSpAHYV8BlhmHls7fnDHj1YW5PHXAOMTOhgcJkai6E2bGnBa0FYGxM/q/+eMAl/OvJdCqmlHP7c0uOI7Y1U7gHE2qGFwxUnWR6cWMCM7gRSxOJFHfQiz/4GvkoJ1HYL3r5z0W6sZ97f3J7X8/qRrGMuFdaHhDkUJqTfYxUcykzQHhfPP6xXbycoXsNB5kJDGdbbiJDmxKrJRj9r/uM5/aqRqrjkTkDOFZr0d0xVLTRtdpPCiOKpA1oonkd7vtnos5SsdaMhmv/ls3/mV+oBLSWZcNe33J84BzDKbPSQs1Pp9w+BJBFaWgNB7VZ/Oo9lsOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxNunW1AN8herM3Pp5pXS9bNy6T0nuxb5H5QB8cMclw=;
 b=eVE7sZpIUPF3hTatNWEzBLHnLa3VXCiYx1KNmlj2OF8OZvhvA0EmIZMYiGoo732Zlt2k4OngZzkMMx1RskyIxZH6uNL5ceUFmXuDOdBS3+D0jdygdqod6tJZISbd5ikoXYNHVUtoiZZvf3zJTJU39r/mjKWiIJp8HTmjp4fEscHogEJhY3emrzINaQHBw1mXSzGk96YSIr/fanOd1HCBvSyWAQKuUZR3wt4Uxn+Fnu/lWbKRrGeKBBtIczyoz/DArewIu+Mbl7G93uBpIwiQBhNC1Y3DZ4phMWXDAtfX6N+ethJSbE1NZi5enF6E3FnD0fLO22pIsZfex/RBst90Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6360.namprd11.prod.outlook.com (2603:10b6:8:bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 00:17:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7698.032; Thu, 27 Jun 2024
 00:17:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>
Subject: RE: [PATCH] vfio: Reuse file f_inode as vfio device inode
Thread-Topic: [PATCH] vfio: Reuse file f_inode as vfio device inode
Thread-Index: AQHawJxm3I/CN7lO/0SZyxULdM6QfbHaGjEAgACpYlCAAAdKQA==
Date: Thu, 27 Jun 2024 00:17:02 +0000
Message-ID: <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6360:EE_
x-ms-office365-filtering-correlation-id: 952300da-6139-43b3-a87b-08dc963e7831
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?nArg/4wvDF8WdMyTLLBLwlgei8Arwm2GdFzd/GYsB0sGm14qLslUcla0IZxo?=
 =?us-ascii?Q?Pq/hngEoh5w5zYToTepwGTceDGw7dyFGcZZHdfltgLxyrd6yjZaKCJ83p2Bq?=
 =?us-ascii?Q?ypZiCFIM9zKfQXsx3L0QJOGxl1gfbX5WAaOVbGZphu8+RDsKXB4QwK3FZLjx?=
 =?us-ascii?Q?jpsR/wc66qFcdxv/zmEALOUu7lIKq7ssBFgc1l22GhvBeK3VaccB6p1HkhfK?=
 =?us-ascii?Q?n4MgEkpkLURPTNkyMtrzcFfkyFuTMkNLCzwDyhWoo0zrFIbnKgtWR36IgGOo?=
 =?us-ascii?Q?Efp52SSd8NPdk2hTzU3A5cbFf/U/yYfyvxhnFMX4Ak4GfL/zYG+cTrdPjQWq?=
 =?us-ascii?Q?X9fM3RDrH/b1oqI3I1RcFctluGOtLAzkQJA6bsdeDIuycq6MMnRi2KQHJK3e?=
 =?us-ascii?Q?ZCpIpRY3fpbsByJkHMcdQWi641gs/0miymaOza1Y8OMFB3Y9TgHNWAmoit5T?=
 =?us-ascii?Q?XG1uhkb6p0ByswtKDkC85Pw3+OBBBfdpSqyXNZubRswVL/3SK19JDUl0RXjf?=
 =?us-ascii?Q?l8gBBCpzN/MTFer0zJrKjEOEAfqGC0RVbuiyWyN1/Trpubovc3Nqv8Qc58X4?=
 =?us-ascii?Q?RT8NSe3lCIVOyoSsvwx/dBz/hdS/tABgce15X7s3eSqTfyZjflB2qhik3H60?=
 =?us-ascii?Q?rcUoB9XHQ8tcDFOVSpyPlgq9jRMwkXtIOrqWE3n0nkUTk+52iyc0Z3zoELuP?=
 =?us-ascii?Q?Dfx1PciZIV67RlbA3zObt9ZBJkFz9pAtJYjleQWycZ/pwtNoRbZ/hizXNwa7?=
 =?us-ascii?Q?ECdm0dLc0BkjVSkLyl2esdnnimZAezFe0L2h2fsrB50Kv5TdsONY3khALBs0?=
 =?us-ascii?Q?84qQ2PvfUWdPVx5wIJuNE8LKxR1PQjHi73O1Sa2sQItf1PuJ9Idi2jlEJweY?=
 =?us-ascii?Q?FGztZQW/yjlMM0weuRXOcU9FgomUM0imfFrG8VJtqT9qnMMxj+YoBV9qBFp/?=
 =?us-ascii?Q?w2SqINU10+0SGau2RoCRK8FA25whXnSVvrzZo4DWVSTNI784uRJpYbUSmLvh?=
 =?us-ascii?Q?xNaW05DSeXkOi9/L3HFi2NoHh581y1quXxFy97+RXadIDx8mcxRxnm9684FD?=
 =?us-ascii?Q?QYTthO6mCEV2cmxSN6D2d8tMGPvW+etdKO2OyxLqZL95LJclXMyiAvIANC+U?=
 =?us-ascii?Q?SKmIE0ZwFGN8KY7h33wkSaBKQgAXSVo4JiCZcNbvUyUyvCFwTubNK0PohSJj?=
 =?us-ascii?Q?fXta7KT46wJlKJfh4ByDK/nJ371ST9myUP1owPuV6Osn1mqWfvp9UNwnFfjX?=
 =?us-ascii?Q?xtHYKi1EEen4kiR+UwKUw9jP4v2qrX3KZ6ZE/7i9ylpAZubrob1eoVlbFUfW?=
 =?us-ascii?Q?APB3CYCB7TfoeOwbySJIhiANLk8s52iA+ZGY62QBVvfNvtogjJewah2o/Sfi?=
 =?us-ascii?Q?5uCpVV6Dn3aq6EGf172+1cwQHlCOguW5pk6CkPD0XvAZ/g/pSg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ffzpJzgOG4jiuyUhpJTwxYv4i07G496NE4MOOm/VCHz3sUMHvnGriiVyOjJ+?=
 =?us-ascii?Q?2frskkL0dUL1HDaIF3iSg/NQEv/1rW449iFV/HTsayMjlOplrYtZNl2zyFDL?=
 =?us-ascii?Q?LjWpqLaOcnJAv6N2t5oXZc/kalwDH2EE02EVxqPrm7QfKzYocqF1ZlCIGIKA?=
 =?us-ascii?Q?KfWAM2ypzAabGijcueWW5pz9rt5ggoyhbvx9zn/bccyBSHdXZbGpzK2EpRnF?=
 =?us-ascii?Q?fLMBJV5fFM/gPJakhy+5klnOVSA9lIkIYMIEFqbnma8bGZM6lCaJZmiJfHrT?=
 =?us-ascii?Q?/98rTOs2r9C660QiXlBvUhZDBF5iC9PXzE+NtgjZnVGwI2c8Ni3gC4uysLSE?=
 =?us-ascii?Q?z1LZ+u1FinPcMkarjt31FpcSc1hDgqkN4S/2+8mtKCUz5xOXaQhvENu1/vW7?=
 =?us-ascii?Q?RVxpM/qx18Y/5Dgc6N6ItqDsWeKvvITfSxrL5pv9qUQryKoWSsf8yI/6CBd0?=
 =?us-ascii?Q?z3qtRG+uyiUdz12brJu/Wgl76/fQKDjW48Q+vAvVcqa+Ugd1tAypg4xsTjDX?=
 =?us-ascii?Q?Kl5+lhcLunXjoWVLo35/GN4b2RiRU8HysDi9tTXE/TuyGPTpD9F62YWeTvEp?=
 =?us-ascii?Q?W5Zzf8U5mcgpqG51QhnATebgNTDcS1t0YjLMxSoE0bT861ROM5R5pZBoYdEs?=
 =?us-ascii?Q?GK5bapeSREI1dbFTX1Dsm0c362bIh+1s4HHd3VHWdcdVjtrAMeomRG7YoOj1?=
 =?us-ascii?Q?qkx/oRTO6VqcVTaPaFS9CE9PHgP3dQ3z0VqzSy4ufAshQc+cT4DiESh6zIH1?=
 =?us-ascii?Q?bGL9gHrL9aUjWUpb/j8jlEWlxnXC4tt8MY1krofVZ+0Tk31sCW0w29S3bSaH?=
 =?us-ascii?Q?nxyiqtEj2CyAplQlqiHhOedULODpELaqJk2BmSkfj80ZsEbt4NlYlru4FPuD?=
 =?us-ascii?Q?ljyKJiqpS3BNcsmV28/uhXT27cV6Kbse/WriV/Mv797ilwAECNO8s5VHa2F+?=
 =?us-ascii?Q?MxJwAG6NeuhJ8b2dMLy3eezSaUyBUxrTeXnyIFnYpZpadKcWwdRmd7NpjhJQ?=
 =?us-ascii?Q?zfA8PPr2pMY5mwewEH4deoeUWLs6ls+sZM5oE9XWdYk/+B3N5qWok+2y/5Pc?=
 =?us-ascii?Q?byOL1gEzqhkkFcJBRIvtP2f7tGnShW51fkOLsNs7dfO0t50iFcHdB10iqzhf?=
 =?us-ascii?Q?0EMrY1H+Ce4hRciWtM5NDHY/D1OobelVknEJ/vRznOOCXivQb1dmLcYnkmK0?=
 =?us-ascii?Q?E9O4I+LTh0cuHYU3r+oskjePgPJ+yfafhfhGqffekpWpv7LiIoTNH/xuLUir?=
 =?us-ascii?Q?NkZJQm6czjx/EFbSM39DNF3U2Jd0ApDY47Iwl0Ny+KlOIqMF/cIUH+Uta5qk?=
 =?us-ascii?Q?8VrVFSskJv1C2J4J2jBJIVVEz4lkJdgDopX2INxcbWJFF+STLF5tMyseH/91?=
 =?us-ascii?Q?FO53FPIC9jbUj7rG+Q6YaQ/4X9WK81P6LhwTnBc93uvf05ujKaG9tLjSnZ3Q?=
 =?us-ascii?Q?rydY2tkKJBhK8qoTyo7oFFciNpaLfVq1N1xI0lgKJ5woUr+Rrv5eJ36kVgNH?=
 =?us-ascii?Q?h1Aj2idMnm0ArFImJuOpK/rwhhYcZpLTUYO5Q5R5ruv1UYJVv197EqcYoMU2?=
 =?us-ascii?Q?1lknMLQ+P3htCZ7BHxCXy7ElYAuL2qH2hDo1JUau?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 952300da-6139-43b3-a87b-08dc963e7831
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2024 00:17:02.7927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QgqjlH7Wtnmmm3yh/4SWLn0OjTAwYkoL9FkuFQsUfRzt2dBML8B2tp2kIIUqP20h/kgbsu0nUn9BYp5Q1QZClw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6360
X-OriginatorOrg: intel.com

> From: Tian, Kevin
> Sent: Thursday, June 27, 2024 7:56 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 26, 2024 9:35 PM
> >
> > On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
> > > Reuse file f_inode as vfio device inode and associate pseudo path fil=
e
> > > directly to inode allocated in vfio fs.
> > >
> > > Currently, vfio device is opened via 2 ways:
> > > 1) via cdev open
> > >    vfio device is opened with a cdev device with file f_inode and add=
ress
> > >    space associated with a cdev inode;
> > > 2) via VFIO_GROUP_GET_DEVICE_FD ioctl
> > >    vfio device is opened via a pseudo path file with file f_inode and
> > >    address space associated with an inode in anon_inode_fs.
> > >
> > > In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per
> device"),
> > > an inode in vfio fs is allocated for each vfio device. However, this =
inode
> > > in vfio fs is only used to assign its address space to that of a file
> > > associated with another cdev inode or an inode in anon_inode_fs.
> > >
> > > This patch
> > > - reuses cdev device inode as the vfio device inode when it's opened =
via
> > >   cdev way;
> > > - allocates an inode in vfio fs, associate it to the pseudo path file=
,
> > >   and save it as the vfio device inode when the vfio device is opened=
 via
> > >   VFIO_GROUP_GET_DEVICE_FD ioctl.
> > >
> > > File address space will then point automatically to the address space=
 of
> > > the vfio device inode. Tools like unmap_mapping_range() can then zap =
all
> > > vmas associated with the vfio device.
> > >
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  drivers/vfio/device_cdev.c |  9 ++++---
> > >  drivers/vfio/group.c       | 21 ++--------------
> > >  drivers/vfio/vfio.h        |  2 ++
> > >  drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++---------=
--
> > >  4 files changed, 43 insertions(+), 38 deletions(-)
> > >
> > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > > index bb1817bd4ff3..a4eec8e88f5c 100644
> > > --- a/drivers/vfio/device_cdev.c
> > > +++ b/drivers/vfio/device_cdev.c
> > > @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode
> > *inode, struct file *filep)
> > >  	filep->private_data =3D df;
> > >
> > >  	/*
> > > -	 * Use the pseudo fs inode on the device to link all mmaps
> > > -	 * to the same address space, allowing us to unmap all vmas
> > > -	 * associated to this device using unmap_mapping_range().
> > > +	 * mmaps are linked to the address space of the inode of device cde=
v.
> > > +	 * Save the inode of device cdev in device->inode to allow
> > > +	 * unmap_mapping_range() to unmap all vmas.
> > >  	 */
> > > -	filep->f_mapping =3D device->inode->i_mapping;
> > > -
> > > +	device->inode =3D inode;
> >
> > This doesn't seem right.. There is only one device but multiple file
> > can be opened on that device.
> >
> > We expect every open file to have a unique inode otherwise the
> > unmap_mapping_range() will not function properly.
> >

Can you elaborate the reason of this expectation? If multiple open's
come from a same process then having them share a single address
space per device still makes sense. Are you considering a scenario
where a vfio device is opened by multiple processes? is it allowed?

btw Yan's patch appears to impose different behaviors between cdev
and group paths. For cdev all open files share the address space of
the cdev inode, same effect as sharing that of the vfio-fs inode today.
But for group open every open file will get a new inode which kind of
matches your expectation but the patch simply overrides
vfio_device->inode instead of tracking a list. That sound incomplete.

>=20
> Does it mean that the existing code is already broken? there is only
> one vfio-fs inode per device (allocated at vfio_init_device()).
>=20
> And if we expect unique inode per open file then there will be a list
> of inodes tracked under vfio_pci_core_device for unmap_mapping_range()
> but it's also not the case today:
>=20
> static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
> {
> 	struct vfio_device *core_vdev =3D &vdev->vdev;
> 	loff_t start =3D
> VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
> 	loff_t end =3D
> VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
> 	loff_t len =3D end - start;
>=20
> 	unmap_mapping_range(core_vdev->inode->i_mapping, start, len,
> true);
> }

