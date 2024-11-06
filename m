Return-Path: <kvm+bounces-30855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A5C9BDFA7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E50701C22C3F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C101990A2;
	Wed,  6 Nov 2024 07:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QYt0lCi0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E88646
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879109; cv=fail; b=uJUX0WRRZxHLM8oxSyFvbbCk8Nmtth2fmw6iKu/puc/pzPKhEiFJqbur1CsEGBB138cuQDssOGPM7pg1WcaQd28ujTz180nUTmd46UmQJ2o+UylwSQ+X4Bq3Id4csXr1v0s9f8HKtUcnpCOtKxgyPm3dbO7ck/6dlhwQbwXnLwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879109; c=relaxed/simple;
	bh=o4a9l8PVhLbfHCKsxELNgfFRd0ttvMhbCW9w8U1mBog=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cb+MdZEeOPerJQznkceYUun1Eeg0b735H0wQmkLsaq+6zfjbcZ/FJM3yWsWWqDR7Iysc/INvPQxZ7+aZsb9F8hJUE/9C28nXc3cV+Pa8Zj8B2wOTow9DvXpvZ7Q5KDx7wSjwYWx1sLChm50WOEKFZvjFirJc+fRa1K4ChQKFILM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QYt0lCi0; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879108; x=1762415108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o4a9l8PVhLbfHCKsxELNgfFRd0ttvMhbCW9w8U1mBog=;
  b=QYt0lCi03FsSKqpiJPOWtruI2QuOVzsSKW1zdUhyulnFGZL3qILwIZ3e
   Nw9yV4LExibDygXOmmQxUc/pkfbspWxuwLkiz+dmaonJFiSYOmI9Jbvip
   Ykdppxlp00wMEyatFh4kZPz+wP4mWcAj4Tzv0i5blinIvtxuNYWBn8b9I
   qnIBri6ddHk15eEPtrVgoiTXiyDzduerdIksk0VrSPBGe646Gv3N/s9IV
   23IFGURPbTGThlG5lforrFNGMIl6K32SsKY5vA6N1dm9BN54v90TAYAET
   mG1jK3+WywJMjufSjRAJ/4fghLhhhT3paShA0y0/I3E8sa0dNKWXQaAMF
   w==;
X-CSE-ConnectionGUID: xbF6fH09TLGNKBBxWfJVXQ==
X-CSE-MsgGUID: 2D2YUKQ7SEqv6LEXbr9CtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="53227552"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="53227552"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:45:07 -0800
X-CSE-ConnectionGUID: xVrS86EiShGxHh3pv1yP0g==
X-CSE-MsgGUID: nAymzSONT+CYptdOhKd88g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="88965412"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:41:58 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:41:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:41:58 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:41:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F78pdG+ywortenp36AkFOKCT4/i++B3vkm8ScV5xZr6IYqBO1hBKZwpkxtH9Tzs5KN1wOpeUDjxpTrSs49Tuzj7ONuMQH4/IVg1LbkZ6NB36EAjrNg0LtPV+qb0qfuUUHCMaBbPq+X2pIwNQnG4fj+PyG3VvQgwSXgOAYRdnSj+ik0EpjWnfZXZnE3Yl7mQdzF+hC6s8g2Mi4JP1OJY4tV7iIT4eQJWZRM/20aYZvgD5ZCEeZNl+Zz7hDurYmtmBJyi9FuuaxR8aXRDwnsqhiQ0uDO30QH2KG49YEyUmZbW9xo28PXFCGv6MqN06wPkZJzZUA8soEJNI7hDwIHdXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drZcE0swAjtkjh6QrN57h0PyXsvSHVehLlsx0xeW90U=;
 b=xO/KiYMqiEggGuNKwAC/sZv6oVmCANJJDUHsUZdYdJZ0fHWCOiMZdKDB8xDRS8VI7wx9HnM6q9qWrtrLh4XWpX/lgNLhkrRbYLxpb4q3AftrpEZJo1cOJ5x4FUzwXnqqZrQmlwCxh8ZeLczTRGH7J7V1xciv7iLM70wQVE6nYhD9IPr84M4O+76lR/uzkdRi2+uTIxOJycBe4ROpC5Lq0EuhD1MyTqloSFLT861e5wQyeWRH/YAPo5rsKLutlsXpmePcxy14diGUL/P/JCBHJgqkoZZvTQFl39+MDxYDHeEY4XENy+4hp+hSzjQ/Ut0SodTP6QIOTM6bkkf4HZfMmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4998.namprd11.prod.outlook.com (2603:10b6:510:32::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 07:41:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:41:41 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
Thread-Topic: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
Thread-Index: AQHbLrwggahcyjOhz0CbdJvK653nqLKp3scQ
Date: Wed, 6 Nov 2024 07:41:41 +0000
Message-ID: <BN9PR11MB52769400A082C0CE51B48EA98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4998:EE_
x-ms-office365-filtering-correlation-id: 23e8bb29-4f78-4553-932f-08dcfe367434
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?zjxHjk8QYh8uisL+Us07yFaBUUM4oLMD5fqyPOFRSBlWvYSOEbFD1myjXrCE?=
 =?us-ascii?Q?b7s1ClL2H/c/NE4/ppEOZPYxwgOfHhqnHC+596xoy3L3Ui4Slg3sdxwLhEPN?=
 =?us-ascii?Q?izofpDIVS5oiz/dJjbXPc28q3tfBVY91n0uM/jA/n4y00THtjKKHUTx0E6GB?=
 =?us-ascii?Q?S7srp49DmtD7bDfuYjlLgvlrOFOBY8Swng7Z4IFQGJuq6OBJweB1MAjSCObh?=
 =?us-ascii?Q?nvlOntgtLxmYuLXp0vt7LLru2dzkaXL5Mw4eokbXLNnhpwYxalZVyNfaOcQ9?=
 =?us-ascii?Q?1JebvtrNnK/XzKmM1bVeqEmRYB4vGsVj+JbsLwPrOKb3qXWvW17PL5SmihVK?=
 =?us-ascii?Q?ZDVAc/OLKUQcVDDfRqClzL5TkJ2mcYBJVVfMILrfcn5dELKPHAm0jBQdlaDA?=
 =?us-ascii?Q?6jiUcqb5GuJoCORJRa4ylmhzc5cm5xo7gdSsOFH0XA0mU8f60tljjbg5N3QI?=
 =?us-ascii?Q?SbxZ0xuFYgXan1CJ1M8iGtqbClO9r7xHUFlr5QkcihDYvtmg4cOADx+n+iZ6?=
 =?us-ascii?Q?jIAPKaGsSfmOltSHZYyLhWs5i2sBG1hp8b+SQazBdcJvJJ7bCvnHbGi6uDKT?=
 =?us-ascii?Q?CYJiP39zbfocUCwXAO2Hl4RraqgEI+gp6pZpFQWr2K7Im38sU+EvFmEuPy2q?=
 =?us-ascii?Q?4q1M4K7NFiZFpOxIA7gkzZa+mJpK+CS7zQT1lJk+fCdZAZ9GiBMdBVXbKktW?=
 =?us-ascii?Q?PjONpCHYheG5naGLY2VibCXvpTeD0kFikGYe5HyUZx+EAE3ZaKuZRummnfGZ?=
 =?us-ascii?Q?FhA12Z4hvTdoK1g0SmDWrg68WC6rkzSuU7oQgp7j7g0/PcvStFRoIEPdNe+8?=
 =?us-ascii?Q?1v554jjflzlP27xrf5+ArCD9GAPiGxPYlItfLIy47KsTlckrP45dy/0+HcFX?=
 =?us-ascii?Q?o9qX5af4r+ZotMzBesQl+h+rA7zoEQRa2CMfUsOr7kxZsxv6MRkqDQmuyJNW?=
 =?us-ascii?Q?W7RrkFfhasHH5WJY0mx5oU8q+0GG2+p7qOD1CRj5RL5ezNbiTQjR60VvJRcR?=
 =?us-ascii?Q?8p3LTovI7mB6MMMoVge2IcgWqj4JNJhDdOpQc7mFn53601upoWK0gPb1JyS6?=
 =?us-ascii?Q?ZQ0IR/OAx5deKuKjdlF9DlXUsfXBft/Z5iKIaU9k/Vtxm2MzyTMH7NRkqMX7?=
 =?us-ascii?Q?oLDZWZfPi6M854gIdpggV5tYfKWLZOXhTeSRRIPy+m+1lZX8j6PiFarBedei?=
 =?us-ascii?Q?/YFgJOSk+018R7YAss6FpHZz21VlxEjEGa6UmevSscsDChpcAJBFKD07OZjJ?=
 =?us-ascii?Q?j2syuufdgnAJlEAKkCCgZK+SnEHeLKNGzenx7VtGmy3pe2HvLAKYvFxDzBx+?=
 =?us-ascii?Q?Oo4+OSr34QZW52h9KXOMLWvr+854QrAHNb3CduPL50tiwa5ldZFhqhx+l9wD?=
 =?us-ascii?Q?xg+g2Z8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?34LGPySLKEUQoDmmw0Z3KNRXXQ75Nk+pVhXjgfI/1kujjyHXtb3v+44oQiKl?=
 =?us-ascii?Q?ZubEeEyVNTX4SHzARIkgllfFXM5DMO467+6V8potXj834GLIudwHYqDRg8Cu?=
 =?us-ascii?Q?+o/M58dRcSAdkjxJO8ehfLHYg4yZd2YneQHdeee6E9V8Ug2yAMbEkLAXqoqc?=
 =?us-ascii?Q?zpD3XTZ1ighc4iOcjJ+eTVU7I3kuZOCdSg6/kUNOnZPVSl9Nb5amKYYv/UnN?=
 =?us-ascii?Q?Xix3WpfQFo8Rhit4jmBFKsaH4UdDMhwr97ZPNz9RnRBPh2ZRAh3berNGEyhv?=
 =?us-ascii?Q?tzkFw7xiM1O9LiylB7yyZQloajAI5zRFRCG9TOJUWs8fOgQ10Ui+MJHWmZQO?=
 =?us-ascii?Q?hGPd8iskx4J0v1W/gAuygb2G5um0LbiZcX5qLe5Yakmtaw3P9k4h0V+rx8ds?=
 =?us-ascii?Q?b1DKZB4qU91O6Tyfx31ZyA4CfeclhXtyUF6BV9Xfvgx8CP5pk6xrFupQgp4X?=
 =?us-ascii?Q?pgXuAJ9iMcr6z2lOiLYmXQ5hARTtdWqm8D9KOZUQLV9L8OfYZxE8aUgIt5xv?=
 =?us-ascii?Q?wVcvPwQAErqb3pQMLXSgpsAFCsmPqux8EnOgJUo/BWruwXLgnybqOft680F7?=
 =?us-ascii?Q?7doH8FPmFBW0HmW75CMFKpJf0tXo+GM7nFvDpHieNHqdYb4cBwkJtilNgc3e?=
 =?us-ascii?Q?cByzoSfmld6S488TRahCNpCofiO0ynuQ2vPLDEaf+8NgUcxdCzv5/bD1KEQy?=
 =?us-ascii?Q?bNgr3OCBmjwL5ZDkJlmdlZ+iLvU5cDcljdRyvXJEtohiSIGHssT+RyWT34fO?=
 =?us-ascii?Q?HXzkzWvt7YKru0ZfqcuiGmxO6pCpAoT7+NSde7Dui3C+ehTHY83mSQAq0Tjg?=
 =?us-ascii?Q?VJ+ubiUOSXRhVwENDFkzldNyl69jKJQ5akW7q8fzgTSoY2cMOKNiqP5LS52X?=
 =?us-ascii?Q?sCR+eRI0KmWUXu8PDURrbvBeZn6F8eAdUnJmWs+VzKoVfnfcBqoMDraUTgw7?=
 =?us-ascii?Q?XXCIlF3jKEZg+u5uVd/LQT/Vk6eTsaTQWhFRWcFP9xXDk+3X0Zk/kYTrek2i?=
 =?us-ascii?Q?+PLUR6KdLwtPBUQykwACm119LETFVSeIQbd3L+TYOQCn1TpMQrA1HN04NNJR?=
 =?us-ascii?Q?oa3zJXyYW4hlOsVsstqqKEsO3+86Bmcm7j8g9YjKkR4h98qJU6+v/njAb3on?=
 =?us-ascii?Q?edksZ7/QBRAtNJho2U1GxuYVhHVqBQf1kO3eUtT6UEsKbEdUyoysEnfjDIiY?=
 =?us-ascii?Q?JBpxEE6xboQpLkgrpshI7+6FhN6R0DjOa6c30OH1vFwjfvTiLTPBnNUZnQm4?=
 =?us-ascii?Q?q+psXBkrRa+xETEh64m5O8RWbKglcxfpKoCIUOAruK8XH1EkCK8oDFt66n4A?=
 =?us-ascii?Q?CIddKvPVRDx1XU2BCmDUh8w3XuztcTW1qQzWHDjQKbiR65D9pFHkgFGCys3l?=
 =?us-ascii?Q?fv2wT3giPbGQ6McwWBELLph32oNaXSRf4YvF3YMCw1PWVBuA1btqM26BCV7X?=
 =?us-ascii?Q?9s9kFIVVdUo4Obq4tV5fKlWboIWvIpmUcBAagVajl+tkQEOstA/55YdJ8uDP?=
 =?us-ascii?Q?TxbxxYLQ/dxiHr0CZRTee3nT/cxB262Eh8qUz4k55wlQebB69MsBiSZ2VaFK?=
 =?us-ascii?Q?X2f/s3pgpAJHzGwzhcny9JLcH9V9rIzBQ38m+bfh?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e8bb29-4f78-4553-932f-08dcfe367434
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:41:41.0978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 36VK1uPWCD4gEMgnpAsWSWgzCdSgXfZmD6HwzHqV9nfRWQCnzgsUQzKhkg784xACkucTJmbrZTuOcLJ+kg4N8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4998
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> +
> +static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t
> pasid,
> +					 struct iommu_domain *domain)
> +{
> +	struct device_domain_info *info =3D dev_iommu_priv_get(dev);
> +	struct intel_iommu *iommu =3D info->iommu;
> +
>  	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
>  	intel_drain_pasid_prq(dev, pasid);
> +	domain_remove_dev_pasid(domain, dev, pasid);

this changes the order between physical teardown and software teardown.

but looks harmless.

> @@ -4310,17 +4357,9 @@ static int intel_iommu_set_dev_pasid(struct
> iommu_domain *domain,
>  	if (ret)
>  		return ret;
>=20
> -	dev_pasid =3D kzalloc(sizeof(*dev_pasid), GFP_KERNEL);
> -	if (!dev_pasid)
> -		return -ENOMEM;
> -
> -	ret =3D domain_attach_iommu(dmar_domain, iommu);
> -	if (ret)
> -		goto out_free;
> -
> -	ret =3D cache_tag_assign_domain(dmar_domain, dev, pasid);
> -	if (ret)
> -		goto out_detach_iommu;
> +	dev_pasid =3D domain_add_dev_pasid(domain, dev, pasid);
> +	if (IS_ERR(dev_pasid))
> +		return PTR_ERR(dev_pasid);
>=20
>  	if (dmar_domain->use_first_level)
>  		ret =3D domain_setup_first_level(iommu, dmar_domain,

this also changes the order i.e. a dev_pasid might be valid in the list
before its pasid entry is configured. so other places walking the list
must not assume every node has a valid entry. what about adding
a note to the structure field?

> @@ -4329,24 +4368,17 @@ static int intel_iommu_set_dev_pasid(struct
> iommu_domain *domain,
>  		ret =3D intel_pasid_setup_second_level(iommu, dmar_domain,
>  						     dev, pasid);
>  	if (ret)
> -		goto out_unassign_tag;
> +		goto out_remove_dev_pasid;
>=20
> -	dev_pasid->dev =3D dev;
> -	dev_pasid->pasid =3D pasid;
> -	spin_lock_irqsave(&dmar_domain->lock, flags);
> -	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
> -	spin_unlock_irqrestore(&dmar_domain->lock, flags);
> +	domain_remove_dev_pasid(old, dev, pasid);

My preference is moving the check of non-NULL old out here.

otherwise looks good,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

