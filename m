Return-Path: <kvm+bounces-43325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D22A893E4
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 08:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ED783B45C1
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 06:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97A827584E;
	Tue, 15 Apr 2025 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PJRZtlgw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4431C6FEC;
	Tue, 15 Apr 2025 06:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744698265; cv=fail; b=Mj5y4gHLj9e148U5GZevFemCMx4CNhN37ZfmQzHLkJBIrhd9GTuMHwzd+eA+0NCsbgzUJeRvP8aLEd7wOwdB8tjYqKGHbNoy4+lPCrmF20uv8ZFll/ungYrdJSWkcxBdLXF+HlXUtjs/5AUA1JNEuwxytKHQEtyAJgJ0ZeqRYCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744698265; c=relaxed/simple;
	bh=tJIlyu9gWY5w50GlLUHOMSx9Eb4MOtZXLzuTKK5TbSE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XjX+JX8DJz/X4gCiwcPYVEBw9yqSDDNVYIhXtB9LJFdESClo0PHGdRsKGvrLlzwl1W4a1Wkk3kDaSsvTUf66/2Od3fJvz12owiFi3Hxt97HZhTeXFW1bPBoZdf2G40NOL4OKiqfpiQgk6Gn16/WrQRfYzj1KTx0raolG3ISaaII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PJRZtlgw; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744698262; x=1776234262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tJIlyu9gWY5w50GlLUHOMSx9Eb4MOtZXLzuTKK5TbSE=;
  b=PJRZtlgw6cfRHWRKev0kJ/pEgPOsupgsXfvYroG21On+AAdTmTN2aka8
   OwglKGSs48Iisxii2jj86BEqjovUl0oW4Rv+15pVLqJrFhPW9krP40wg9
   Pm72SRn9mXUZPDFrNzb8wHllLhEmZvGJUjSpmbp9qNkbKkkW/4b6VlMYJ
   jzIYBwELN0io9ZMsPEkYGX8nmd7XrSuPyZJJj1Zn0KLT+5JjTd7UjUfB1
   285SsQ0RqygaUpK7abkVuYBZQ0H9A+WPP5ZUNKNI/cQPPTRwoHO7Oyvfa
   K95E4KwxQAHxXTmVpJ3N2JlixGIIubgY293EWXQOXX23x4e+xnk1pX+1I
   g==;
X-CSE-ConnectionGUID: vd7lLUG0QrqAWI13pLAqOA==
X-CSE-MsgGUID: ZI8PEfesQEqJs8cDzC0ULA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="45324675"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="45324675"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 23:24:21 -0700
X-CSE-ConnectionGUID: 1PkchNLfQKea+wZ7Y0npmQ==
X-CSE-MsgGUID: eM10Y7vhQ1KUqVFUKfNVRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="129991639"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 23:24:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 23:24:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 23:24:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 23:24:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pV8Eu+bHXIA3he/tXLOQiEFppwXKAC5CdNICpOXS6202WKtO3CwCfEGVrYAt/Rue1gfHASlPCRFWWll+2jd7P4NeVOXyh1hw3a+6A8jaGCYK1QUVIyVDmqy9mwus+N3X2gfcHHeSvB1/eAqvP+qE23q35qFvczo6nI8E5KXt73x81Ge/AYrPwAgqGwEsx9F7XllR25XjsYoLZmZEMoSEmMy+by20EAmc+BcM0yJNarQSiuCqxm8XyfVoF8jLl+rZ8cO+7KqliAAun2QyeBWdmxhBKf0XoUt4lrFc5/VVgHmv/Sk1vFyjZg39IPVflWp32MJEcPRYrF52PyTzLaFaeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKUoE8pmoWTLMZ6kbLyE/BS5tvxlcB3Rtxo5Sv/PZI8=;
 b=JbEci72KLzSwXyXUqn026FB9LHhjZBEISrcKD7ZYmsXvjh5pfouM6phnA8PW+TKR+fLm+0q99mBYTZTRyvK2xeH6RCJyqqt5M8mxSCR3Ufrz7DSeoF/Zb3IsJqnKkSXjzlHy3lmTpD12L3skca14s9jbYxxdikI5gN1D1ZcEBrld1avvkGvPtdIYnB9wJX0d6tsqwI55+s4/4fA4Nw5B/81jZdT7uU7mQuL2HHFXZrudcd9zq1GKjkHishSmEXclnsL1WQpJ58bHgCMmjtg0fNbIIbZIpR2DR9D+vnAZEBJeUjGO9+f5CV064/qZ4LQNIbBRtLyX+NQt9JmIQ6sJCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by PH3PPF5A636EDE4.namprd11.prod.outlook.com (2603:10b6:518:1::d21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Tue, 15 Apr
 2025 06:24:19 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%3]) with mapi id 15.20.8632.035; Tue, 15 Apr 2025
 06:24:18 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "helgaas@kernel.org"
	<helgaas@kernel.org>
CC: "naravamudan@nvidia.com" <naravamudan@nvidia.com>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "raphael.norwitz@nutanix.com"
	<raphael.norwitz@nutanix.com>, "ameynarkhede03@gmail.com"
	<ameynarkhede03@gmail.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "cp@absolutedigital.net" <cp@absolutedigital.net>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Revert "PCI: Avoid reset when disabled via sysfs"
Thread-Topic: [PATCH] Revert "PCI: Avoid reset when disabled via sysfs"
Thread-Index: AQHbrYLZ1vhoqLsNKkeBIOrVFdxUfLOkQt/w
Date: Tue, 15 Apr 2025 06:24:18 +0000
Message-ID: <BL1PR11MB527186F68B0F087D7F4B22988CB22@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20250207205600.1846178-1-naravamudan@nvidia.com>
 <20250414211828.3530741-1-alex.williamson@redhat.com>
In-Reply-To: <20250414211828.3530741-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|PH3PPF5A636EDE4:EE_
x-ms-office365-filtering-correlation-id: dbf5143a-1620-4d9b-4763-08dd7be62752
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?juZ0EHR0IMXwUt5rMN6sthh2ABfnbjAMaZbj8zGv5KVRRFy/TozhjxV+cN1I?=
 =?us-ascii?Q?8OpYTsncgqotVg46OU1sgo4ZHNjDAw3cVx6QqJpkp7CqaoaYyHy7tjATIvqJ?=
 =?us-ascii?Q?c8uiwGVfjtvCdig/kewmFY2IZ5oV3XqGX7HE3PSPVtDi4rQVgWzBeO+E1Pbw?=
 =?us-ascii?Q?kYjzE0DnTKy+0KC4kPjBDaVhHaKKkRsLZhU15sksefrmFK1wlxBDN2L9tA0X?=
 =?us-ascii?Q?YHeYco+3NXvNU5lv8vnUxgUDS97mlIbjt9xyw4u7Xe9zYg3YWuCwLRUIYqr+?=
 =?us-ascii?Q?LOc84+xy1ugRuxYndHxl8jppjGZvwpOZfBjnE/bq+zI8UFOMCtibHuDB36kF?=
 =?us-ascii?Q?3QupSjl+xz0ikbtnr6jOHsnj7G5V7G49X+u/Ym63DEROWk+Po7OB3fBxb8E1?=
 =?us-ascii?Q?2nS/DtFOltFz5voVBLvGOp1hRmtLAXyLIkBWqPiyopj9Fq0JPb0hhJ5HqIHB?=
 =?us-ascii?Q?nn/21Wjcragd1VdHG56/Hxpwzk3G+YJgYPFBI7tWf8W6U4Wc1BTr2r6flhbH?=
 =?us-ascii?Q?HjURIkVEeXO22AtQYaLhNWrt6Jv/T9pYTFhLCh8itMHQKd49vFpYEprqMVSS?=
 =?us-ascii?Q?Izll2075YeWmXLr9/mfJ7RHBoReyHKSzrSi0gpbTV/JBVG2pOak86Oe+d1zT?=
 =?us-ascii?Q?Jrn7Cn0p9TXQ0jN0ZWrC/63tajpr9bwaY6MOoSNYCqZ3h+0GU6DWpBz444Vg?=
 =?us-ascii?Q?wmUQXMmecPj00uDd+3CSOd2DKGW0ORLWHvbxrnr9rSY92Y0bz8FtODUg04Oh?=
 =?us-ascii?Q?wlzcOoT3RRvfHj/SN2U4nKVo3Xf1m+MCoEQg9fI7PJb0DrD3nUwqF/BX2pjg?=
 =?us-ascii?Q?7pdzyRIG7Eiai/RwFE+FWWeCpmrLoLzFBQ2mo89hhNfF/b7GOJtOQ/eYpvpN?=
 =?us-ascii?Q?FtRY/ZyUvwak33I/OkNx/S9rWr8LoxQu9oY7c4bBFZq5LqFA8r+CeiPmdcFe?=
 =?us-ascii?Q?ZFx6CYbSwmkSQ3wYDkZ19BnXap+sxK+NUObayVsJKg5ixuOKtYxhMV5ra2Kr?=
 =?us-ascii?Q?HLs9DcH9A9xY3IUanrVMULmsy43IBcL1MUu27qVTMbofx2xpvPO0tpJm6XG6?=
 =?us-ascii?Q?2OySN/0yKuU9cdUbAIsV7oQJp8QxNxfO7Febmvlm8FJB2nLqea2d8CGtzyPv?=
 =?us-ascii?Q?LyFMmeDoFKiWT466hbb5VaH8v+czInpBRp+dDumXRqMQYnYgCayl4OWiG5sQ?=
 =?us-ascii?Q?Bf5I1nFQnjq4jfPm4w2/bIZRhmp/e3oGZAX7Bgffsvxr5tV6v1+yuuzG9spv?=
 =?us-ascii?Q?fxrGhXfzpXdO9nQE1wkFDdAcph2SIWYR2iFfqiyT3f2P/xVucnzRaDqhKInf?=
 =?us-ascii?Q?7gwTF/ev1GN/2rDqVGYJyljszBmsoMJlQZQK8T0u/4LdzZNSFrb+9mnvi6M4?=
 =?us-ascii?Q?6H+KnBFcJiSpgCPq4z8HWcKwEUvl9Urp0LJPUBk/3zdX0zkQ7kmXa/P9r0xB?=
 =?us-ascii?Q?kqK8oXr2ttpzkBW5sPKA1ncWqHn3DTWaqpVLefdh1VdVHRlaaO03aYD2ZlUM?=
 =?us-ascii?Q?OY5GMQjmFrLqY7w=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BnBEXUjnsXdZIaGQKL1RBZcRnPHP5KFX0xjFPbXoTqzeyrIepZ8ptOVTd2/X?=
 =?us-ascii?Q?rAL0ujAK5oJyQ5+H4f6dZpDgtnuLQ7Hq09A+0XpwA0Cpps6oEIuniZjGXIQ+?=
 =?us-ascii?Q?b0N3GtwWZLudfDMsfQ1wr74p3mDY84liv8AylhB/f/Qg/+WPqW5hnkS4YMuT?=
 =?us-ascii?Q?vpHi3fw2Ny5UHM8FG26Sd7JjDsOE4QM8zJxA+IpJiEzTLDiGSrRbtWKqvZ2o?=
 =?us-ascii?Q?sCcR4dgap6VPd+THsjSRHo82wH3xjg8QCknnn5r1C0s0TFiDe/aQq6C34np8?=
 =?us-ascii?Q?jXJ5XFXZuH/KsJPaROTT/Yv16Y3Mmw4AO71fJcwMVYkw/xFQsLqlv6KltX/l?=
 =?us-ascii?Q?bNNZdLRnkOjACkgNA6o+U6hSKSa9kebIvgkgauaXO+ph5Xsttg/TikMXOmG7?=
 =?us-ascii?Q?ZXYPxLb0Q59l4oBZlOGdDRumVTSCIvOI9mwmTM+f1eigWlIk0HXKtxz5RroH?=
 =?us-ascii?Q?n4xczgR7C7nlbiey6IicNoSxgL4Vm0MYjokIeplyukj7AoDAKSSqm3m1wVip?=
 =?us-ascii?Q?7d/NboK82136+CkgU6a1i2CcaN9+TzpTocqeFpC//74Nq5ZMlntxWSxZFQcg?=
 =?us-ascii?Q?Y7oNILKBv+cZanCQvgTU9WDt8fw/e8Usz5OwEjFD1W1xUmLo+TFWSe5GgSqE?=
 =?us-ascii?Q?NcPDospAO8Vmr0EhZNzx2wbF6Ma5NnfTfJmuEKa23Qzcae4kkcTCoiIIuTCb?=
 =?us-ascii?Q?T1qCGvsg83z73bhXBgIVhl3GeVcpG+Wt/RHAAbBhdsRwNVn+oPy3nl77SSx9?=
 =?us-ascii?Q?D7o/6+dI0RPnvQUNNrwnb8F4qC4vAoT+c3PoOy5xaUMeXTUXxzMI8P2NdnJ2?=
 =?us-ascii?Q?FjAp1uCoyGIBwnR6CVce90qct8QUM9emIVp3fJypEa1mknswaApuJpF2G0q9?=
 =?us-ascii?Q?y1FO0cwzGg+aGMmLXlqtsYItj3zFf1Zcw5SevPXq6I7CBJG903i3cBLbj/8S?=
 =?us-ascii?Q?1rInZ+rA+xRJLMiudf5JXguNxqJtWCNn/9bnsQvaui2UYC5XaAG2/pP+gYV1?=
 =?us-ascii?Q?zFuHEyEQaecWuqqgMjen1TOz+jTSiaVaMHr8jlgM4kcob9Ktb9cNfMxSoh17?=
 =?us-ascii?Q?TK/G+FwM/+fUde72m0yxSL63ZigttlfT2e+ZsGnMUKeHas7zgjw0PqVLqBnJ?=
 =?us-ascii?Q?d9mCg0eqdypnu8h6GCY75sM2ORB+D6ij5VUuc48V9IsUd2mHSZaYzTGSxUnb?=
 =?us-ascii?Q?9pZbKyHHEJUooGHbUvQb0C9ssCiMvwyZ0QMsBhhif4x0NV3LF6YzhqD61jAr?=
 =?us-ascii?Q?q3AdBZAvmyyoeFnyUJeKwEEeZdNw9bqJhR9V4aDSvJ5cjZWGRCk/Cm+Rlq6k?=
 =?us-ascii?Q?U1bg5ARi5LGBPpI8oHzvgAC1dJEKnVM/xYLVhC0IErkdjaMw7sV/iJWPGZNL?=
 =?us-ascii?Q?Cp/r5doCqqaHEFCVTM9t1wcLHVTdk03rrTCjWfhGUzUNGs7E49AqVE+/QlxC?=
 =?us-ascii?Q?XcxZv9o+0VH45fkbD0Bhux++cOl/DzZQ1FupC5/2WvWmXM0+C84XnhXHZTvD?=
 =?us-ascii?Q?70U5RGzO/1LeCOfV6MIBYFDrBGl6llpYXmT1J7OwQ2niiwK0S/qkUD8quToH?=
 =?us-ascii?Q?DhXCdpKSwk59AMnuZJNhQe8OkKcJuzXmTVgY/ErG?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf5143a-1620-4d9b-4763-08dd7be62752
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 06:24:18.8458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N9Z6LZguanA3/ST24kWb883aeVbvl9Oo57g274uiBR4cr3iDmvau2AZtcNcg+jibt8NMOM1I8zWEDxNXyE2Vnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5A636EDE4
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 15, 2025 5:18 AM
>=20
> This reverts commit 479380efe1625e251008d24b2810283db60d6fcd.
>=20
> The reset_method attribute on a PCI device is only intended to manage
> the availability of function scoped resets for a device.  It was never
> intended to restrict resets targeting the bus or slot.
>=20
> In introducing a restriction that each device must support function
> level reset by testing pci_reset_supported(), we essentially create a
> catch-22, that a device must have a function scope reset in order to
> support bus/slot reset, when we use bus/slot reset to effect a reset
> of a device that does not support a function scoped reset, especially
> multi-function devices.
>=20
> This breaks the majority of uses cases where vfio-pci uses bus/slot
> resets to manage multifunction devices that do not support function
> scoped resets.
>=20
> Fixes: 479380efe162 ("PCI: Avoid reset when disabled via sysfs")
> Reported-by: Cal Peake <cp@absolutedigital.net>
> Link: https://lore.kernel.org/all/808e1111-27b7-f35b-6d5c-
> 5b275e73677b@absolutedigital.net
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

