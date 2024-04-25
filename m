Return-Path: <kvm+bounces-15930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF0D8B242E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E15461C21791
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC3214A4D7;
	Thu, 25 Apr 2024 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="geF9EnD2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687BE41A91;
	Thu, 25 Apr 2024 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714055853; cv=fail; b=k8fGWx/eeWol+8iGSNucsu9tEOsSiLXSN/Qa57tL5xwuboUKGXvmFB1Sgx5x1fhPSPhcue3MvrRih/R4EekS9xYOacDfHURA1c/HfPvdjSkwackzrTDviMfK06Va1LoySFq1ZoSeMMUPvusNcrlgUKgcnCOBX6Vsdfi1mS5wpPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714055853; c=relaxed/simple;
	bh=mGX582fpdp/KwRvGXaI9X+Cf3rhAyCS8r3XTDipVroo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fqJIxnHmEljifkE3g/iJSRMV0XKytn7WAUr+0dfyWRG3sCQyqwe/CDFCN00lY70OlEWWyCV8ctCI+BLbByPn7Zxtm6U3MF4yvXDRlTfSUZNEUpv2DsPSsfV19W8e2rtMPD7wU3t638r/y2T5dUJ1fiL46CCm+lyfzyRDFzlBxew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=geF9EnD2; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714055850; x=1745591850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mGX582fpdp/KwRvGXaI9X+Cf3rhAyCS8r3XTDipVroo=;
  b=geF9EnD26hvbGZR6Xf2Ni/jzjijZ3f9wTWa1IinR0Vcma4EkTgWJY1EO
   6lta3B/UVPkOfQpsOZxH3QjDmX76HP2JjyoqF/+ajqKdbQDXTK3+NRsax
   e/h+Xi6i1em2Vs0rScLO0mvRvoc1dISLSCcoizAtPSXEX3XjuIFd1bcRk
   d+2Xh34whz9va97nhoq/GJVPhthOVQgypTVIafNHQv1U0+UpZD2R4/UdY
   WcN8V3r9yHMDFRnyaY4l1fr98GgOT1mwZJ4f+qMFxyCr+O8Al0bF4wAuE
   G6iYrn+jq8UkJ8Op8iPtKd7bXB13yydMadosXxCxYOljrHmsvjgGRxJB3
   w==;
X-CSE-ConnectionGUID: IRssYnmJSYu9EKA5oYEtug==
X-CSE-MsgGUID: Yqa4tUsJRLuNb4yl7+SXCg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9611145"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9611145"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 07:37:20 -0700
X-CSE-ConnectionGUID: UIfSHT0gSHeyucc1oHzI3Q==
X-CSE-MsgGUID: xGSDDml/R4eGMN0Ibufpog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25187440"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 07:37:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 07:37:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 07:37:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 07:37:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKon6pwH2N1iY3kKago7jJSraXJ9YG1nGZoGZGwZ8JC+v4pSRfFRLdx+CWosWSALj5fru6I6EyZ+63Xn2bQzIFqaMjXSeqfq3SOGaNDPISCysGO6NM4RJChvRBGEh11rtU6CHWZZWBEllQRoe4L29bFFpLhZxdyCT9jwPKSX64xe9N6JvCuwPs/dCTJQggzfhk36mEkZNrgaRXUJ8UjXpRPk+LPl/VyG9r+efyxZczuGw/tq/dobwlBdbcbOTuGSVQ5MKLrbA9vYqxo2MjZmpROURsfkF/cs3TB3GWJ8IfBx6rNcMOBqtsB2ep1uZp88MBKlYKjuj9rPI3GSzJILwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFEv72RmZQ7YwDuIb+zLqDbmo/W0jjrz8cAUn74eiQ8=;
 b=GQyZTY7fvR1Waw5Rg3YuK0EqOOWrg4g5PIwraKw4YZB5cQU6PDuhe1F3ciWwKqE0uSSH+wH8ynhkj0JD1WoIMBqoGliMR/Gc/zy9YmV3lu+0WV26Hro34vC/U9XioxdLQdP9HVkm3/N2XfnIlKrPlWB8AH1w4V9ALc2XUb375KT4kdBdBmuIEv0kvgqQRRV53E6g1z9UYq2oqGwA/2jSoyRI/sJaY1SHfrnVmQ0Q/Dl/ncvOb07XkvItHSfUhXOWqcq4ES3+6EQuriCbIlzqsS+ISTUBPE8gju2dow/7bzK2h3gdmwcUywp+hTvkrcnI5Pt76FER2oamoR0SjsNiZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DS7PR11MB6102.namprd11.prod.outlook.com (2603:10b6:8:85::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Thu, 25 Apr 2024 14:37:14 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 14:37:14 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values,
 e.g. EFER, XCR0, etc...
Thread-Topic: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values,
 e.g. EFER, XCR0, etc...
Thread-Index: AQHalcvRIagHuf/K/kmJgZMA6+igorF4N0TQgADRuICAAAC28A==
Date: Thu, 25 Apr 2024 14:37:14 +0000
Message-ID: <DS0PR11MB6373C82CB77354EFD779E0C3DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240423221521.2923759-1-seanjc@google.com>
 <20240423221521.2923759-2-seanjc@google.com>
 <DS0PR11MB6373B95FF222DD6939CFEFC6DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZipjhYUIAQMMkXci@google.com>
In-Reply-To: <ZipjhYUIAQMMkXci@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DS7PR11MB6102:EE_
x-ms-office365-filtering-correlation-id: b2d19ca6-e82c-41a4-8324-08dc653532e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?us-ascii?Q?ry4/QZ8+cwwiZ15Abtf4txa4gZXvb5Ycf8w1CGYWSma3D9vvMFpDtiPIvQsr?=
 =?us-ascii?Q?omRdvf5aV0O6gaWl9oxzUFjk8fjtoQFBx8RXZhQTSA6KVRRgMUr2jI5zfcJ8?=
 =?us-ascii?Q?5PIhRiU/8qSc3ZMuGXP0Ve2A5O7Y1p2SZvKHoynmHHNXUXVCgRgtD7jHfliH?=
 =?us-ascii?Q?VyAe8IoLQ8iY7x68lEjfyPJmvoATTTBQ4fwqNho2SdCNpe5DYxuXjCMnK7vR?=
 =?us-ascii?Q?48IFA+z4Sk0G8V9AoATauIAXFeLsHWjIILxe9mhVfvCUNmIacAJWpOxIa6tk?=
 =?us-ascii?Q?czqxVDEYScPl+5O3F98PMy5ti7HAh0oCGZXiAuUQ8ByFzDw3lI76mrFjGcA9?=
 =?us-ascii?Q?xLNQDOgjikph8wuyYyk91V5Q3GMZHQ8HYO+CyUlYsezJy2u2C1nbCuwKvucu?=
 =?us-ascii?Q?5PM3I9FGbBfMsOYu+jifowCzGVYnswzbFJuPHXxdvX5kUyhjOBBPX5z9g9Uc?=
 =?us-ascii?Q?aU7aRZnkrgC+uaGdXSpGyxgM0VkKQJt7wtNwdgw/nE8xnnsQavXAS4AWi8Go?=
 =?us-ascii?Q?VedT+nDRLsGYkLSw3Wh2V8if1cmRWzRVlR4Svblu8vIPV1eydGTK76WAenND?=
 =?us-ascii?Q?ZnY8a1lLgzdhR6yjjpKWePjX+WB4/8T81tpZ3mEBmXbRdyIHD48beP1SrG65?=
 =?us-ascii?Q?8zvjA0/OnnCHsAkDOBS2YsQt/HaAdzfB/pOSipu7xwaCVSa3Mse6KoHsgsxE?=
 =?us-ascii?Q?EfQMNjdturxETits8ZczLEh0TpXByaFCQ4kA86sloPTrVeN3YLCpvAlSXLP+?=
 =?us-ascii?Q?/xWhf9QFfL8WYa8E1uA9rCvYV8p+jj9aPra50k1w3apYLh0b/ojFI9cTe0yc?=
 =?us-ascii?Q?Zm8uTi8gG3DNFMqrjLa1VubZML1LBxfHi90yjhDsFgWvbFFcCTwKrb7qBrTO?=
 =?us-ascii?Q?15jCtUtzAjytvtID4m3Ne1I7zaYFjdWsYOwdzqeOEeEK1O6F1uqsrmrRneg9?=
 =?us-ascii?Q?jPgDb78gyvRlyFIZt3zBAFOS8e4yi6IODzBAHFXo2XCMWhnqXDWJ7sMEIE+r?=
 =?us-ascii?Q?l8bRbjq4SraXVX+deX/oWQYlN/hT4jsEqtBLZBxh0NECc/j9UfmzO313gipD?=
 =?us-ascii?Q?FzSzd/1Omu9cS5NezYCSJjSG3j6nHwI88ldSag5p6fRSyOJ2NPo3hjupVhHD?=
 =?us-ascii?Q?ZAfD7UAeXVXHJOcz/IJs5Bg/dP1TF7TL/Ia4ImiUyyoKD3n/WwxkRJbU3o9O?=
 =?us-ascii?Q?k2pkeS+BWoeKxgt/VYz4Jy6oPYMoR0ABWB5xvvYQCNcUXvidjeZTzLkIYxxO?=
 =?us-ascii?Q?xKxSZZbwru5p8K64bPBi+ZxQnhr9UfWGTt45hcuyFJyT9ubFo8ll6Ge2oDqA?=
 =?us-ascii?Q?eFUZHaNAlbv622h6bxdhL/5U67tWtTRBeKx0AE6XKy8ZxQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FllzNEDzBgNFXZ6KVlmnyDi/RhkivifkjPFJJFf1mM4VB5x544k8Mgv2C0+3?=
 =?us-ascii?Q?2nZtJUorPSRwSs1AdB04dT7/VFKXZ05QidnEcm6Va6UY4Wve+VTMEj8JiOW+?=
 =?us-ascii?Q?X5hA3bF4HmbJuV/z0HKrj4dXPWqSklSIl6qto8pzLH4spuNW148ZK2KC3W1S?=
 =?us-ascii?Q?vriyNi4o9sQG2X3hWpdxL3SM8fQGrijxB+iQmkrOSbOXNoBnqs/IVcohP2gu?=
 =?us-ascii?Q?N6o/iYTV7w416HAbn+MJOyfw6QaufACgYBsmKmNHxLqDvihA2H2oIhj+Kurv?=
 =?us-ascii?Q?aStzEaLP3kRQGFRdgVf0ZqwOcbee3z7vSz9o8T0DBCYU4Iaimhx0RIiCmbFe?=
 =?us-ascii?Q?44BxuqG4V5lQPwRHqF1AVB9nh1ALwGKIxx9Ylrn+TztaWas7IK5dxv/CKfc4?=
 =?us-ascii?Q?OSg/hn0tgjFPmdywOAdEyISxUkzvqGobF2um9FRCGp+iavyDB+SSFon30iRa?=
 =?us-ascii?Q?65Pdt9sNd42a+YxHen9PEq/vCHo/cwZyG9PykOt9Askjw9kxKlnYP2Z8wTj0?=
 =?us-ascii?Q?ahcuO7K0bHRcT8VhOcLUY+aQBLRcQyluVh79k9DNFtzN7mGQPUQN+JdVdli4?=
 =?us-ascii?Q?pKLTsxehBasuihs7hP2QzXRLAwC4ayqRY7/z+6O2iKNFL5P8nOV+85rcK935?=
 =?us-ascii?Q?UsYel+3ppYDaAm2gdvyN/GIadWaH1WpR+pOgQCBc3z2NH2sv8CrQOvA7nwIa?=
 =?us-ascii?Q?cUsdpxKM8sVnXDzCK9wdn+VWq+oHFIudq5zBEZssZ5cFQnuspRB0J2lEWMN+?=
 =?us-ascii?Q?QZa/mEhYeMv+F5m8RDETMJkQrTtib+6Iq8asFacckYzT1IrmbQwA5gVT7bpq?=
 =?us-ascii?Q?cGI9jVuLdhdqvgqbOj4I2DBiN4z/YVgTRlItnFoD/J83BsvKH/FfIMjb2AcS?=
 =?us-ascii?Q?iectcRM0dvJDGYvuWR6pAcdGZUeoHR76ou5KhhKvtH1drUWtbLGLa4zykVne?=
 =?us-ascii?Q?Y2dt3PJb7/QH7QHD6bzAkrhuuwjtA0GVgFwqDXviqyqdBVR1AE4QPDyd1d/N?=
 =?us-ascii?Q?vaaV2WWkhTm3UcjfGhGZOKvH0Ula+/JdMbFzGyLnNVDXD+UmTn/vyNorrkDI?=
 =?us-ascii?Q?V9QH5tQCsuaekgMdiwSMFFi4KWXAEvayE9kCLQo+sVKCbbPjAi9RY3JB8P9G?=
 =?us-ascii?Q?U6t4UPUB0kl+29ZDVYb95ZtEk8L8G+lurTA6XakUjQaCSyRgwTvtd16/wO6B?=
 =?us-ascii?Q?AI/aLASYX8hV8QAyW5CXHemC4L2vdZzLJxEnvK4NXqXdV5nrfuNn3k8+6OVD?=
 =?us-ascii?Q?jgc2w8ZBMrCiWKhtUm65yqUvjry5yCh7FBE4FB+RMK/Yku+vvGdYMz9/IO98?=
 =?us-ascii?Q?mW2HiRWYP1D//rVDbn9PUsDvdnY6/G6LbTb9bJiVHkKKBXlotFdyGHeb54iH?=
 =?us-ascii?Q?N8oSynTGadEgTYwmXBJYNBfJ3ttAHJczP7pg9118xpltOW39H1eZE/3H1SAj?=
 =?us-ascii?Q?b7IhgQbEF+KVblAeA+oeZrpj+IXutzGzPeGKFPl7c121nY9/5ckujVst8qZ8?=
 =?us-ascii?Q?DNbeE0VtL57kkbywxIzmn1uM55Ga0Swm6y7axKoDlmKxnm+kTzhpKsPHRxNi?=
 =?us-ascii?Q?t2008UeVmKttHrpj2uPGj6iuicMAYUm6uVps7XlU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d19ca6-e82c-41a4-8324-08dc653532e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 14:37:14.1004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cT6Kn+ip1ijB3auVNadMgrJkYZNl7Q3dOBPSWYUgoQcMZYtoYHgRuD7BNDOYLtB0dC3gcre6SRf2zhRjk9xW+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6102
X-OriginatorOrg: intel.com

On Thursday, April 25, 2024 10:10 PM, Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Wei W Wang wrote:
> > On Wednesday, April 24, 2024 6:15 AM, Sean Christopherson wrote:
> > > @@ -403,7 +403,7 @@ static void vmx_update_fb_clear_dis(struct
> > > kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
> > >  	 * and VM-Exit.
> > >  	 */
> > >  	vmx->disable_fb_clear
> > > =3D !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) &&
> > > -				(host_arch_capabilities &
> > > ARCH_CAP_FB_CLEAR_CTRL) &&
> > > +				(kvm_host.arch_capabilities &
> > > ARCH_CAP_FB_CLEAR_CTRL) &&
> >
> > The line of code appears to be lengthy. It would be preferable to
> > limit it to under
> > 80 columns per line.
>=20
> I agree that staying under 80 is generally preferred, but I find this
>=20
> 	vmx->disable_fb_clear =3D (kvm_host.arch_capabilities &
> ARCH_CAP_FB_CLEAR_CTRL) &&
> 				!boot_cpu_has_bug(X86_BUG_MDS) &&
> 				!boot_cpu_has_bug(X86_BUG_TAA);
>=20
> much more readable than this
>=20
> 	vmx->disable_fb_clear =3D (kvm_host.arch_capabilities &
> 			 	 ARCH_CAP_FB_CLEAR_CTRL) &&
> 				!boot_cpu_has_bug(X86_BUG_MDS) &&
> 				!boot_cpu_has_bug(X86_BUG_TAA);
>=20
> We should shorten the name to arch_caps, but I don't think that's a net
> positive, e.g. unless we do a bulk rename, it'd diverge from several othe=
r
> functions/variables, and IMO it would be less obvious that the field hold=
s
> MSR_IA32_ARCH_CAPABILITIES.

Yeah, the above isn't nice and no need to do bulk rename.
We could just shorten it here, e.g.:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4ed8c73f88e4..8d0ab5a6a515 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -393,6 +393,9 @@ static __always_inline void vmx_enable_fb_clear(struct =
vcpu_vmx *vmx)

 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx=
 *vmx)
 {
+       u64 arch_cap =3D kvm_host.arch_capabilities;
+
        /*
         * Disable VERW's behavior of clearing CPU buffers for the guest if=
 the
         * CPU isn't affected by MDS/TAA, and the host hasn't forcefully en=
abled
@@ -402,7 +405,7 @@ static void vmx_update_fb_clear_dis(struct kvm_vcpu *vc=
pu, struct vcpu_vmx *vmx)
         * and VM-Exit.
         */
        vmx->disable_fb_clear =3D !cpu_feature_enabled(X86_FEATURE_CLEAR_CP=
U_BUF) &&
-                               (kvm_host.arch_capabilities & ARCH_CAP_FB_C=
LEAR_CTRL) &&
+                               (arch_cap & ARCH_CAP_FB_CLEAR_CTRL) &&
                                !boot_cpu_has_bug(X86_BUG_MDS) &&
                                !boot_cpu_has_bug(X86_BUG_TAA);


>=20
> > >  				!boot_cpu_has_bug(X86_BUG_MDS) &&
> > >  				!boot_cpu_has_bug(X86_BUG_TAA);
> > >
>=20
> > > @@ -325,11 +332,8 @@ int x86_emulate_instruction(struct kvm_vcpu
> > > *vcpu, gpa_t cr2_or_gpa,
> > >  			    int emulation_type, void *insn, int insn_len);
> fastpath_t
> > > handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> > >
> > > -extern u64 host_xcr0;
> > > -extern u64 host_xss;
> > > -extern u64 host_arch_capabilities;
> > > -
> > >  extern struct kvm_caps kvm_caps;
> > > +extern struct kvm_host_values kvm_host;
> >
> > Have you considered merging the kvm_host_values and kvm_caps into one
> > unified structure?
>=20
> No really.  I don't see any benefit, only the downside of having to come =
up
> with a name that is intuitive when reading code related to both.

I thought the two structures perform quite similar jobs and most of the fie=
lds in
kvm_cap, e.g. has_tsc_control, supported_perf_cap, could also be interprete=
d
as host values?

