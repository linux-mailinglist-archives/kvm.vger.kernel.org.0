Return-Path: <kvm+bounces-21278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D7E92CCE1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AB5F28155E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C73A127B57;
	Wed, 10 Jul 2024 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mdbfTwHU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D87086AEE
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720599863; cv=fail; b=EUMR061Uoir2orCZ6n8hLvUtnopOec2k52+ooisngNnR/rtsHDvevMwuovdtPQRolOQ4fWhSyFBJiUGlyMA+g7cLVCFjV2hQJTHl4nASZIlnTA1Ze2Nc8fPTIUSnagaSO5awX0zOZp49hFUhXSVIvPjxY7t6jQ5NHKEPOqPs6hY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720599863; c=relaxed/simple;
	bh=wiG6L6fnYHXC0slZfpxcoK1bvgNXdb0lr5S3W3lYHo0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WjW4y1mKGlFQJr9vV/rJaPF2/NxHbq3KrEbXvGKufysoVoVjugIfpmUCYo+Yxf6MZh09lqSbMMAK6xRhuGb5CNdcJUBsYxVnMrSoEJha2V6xN2ObA7xurSm8UeCmyuNt5C2ostyDVkLfQ107qjivzRhr8cuVcG0Hzn6LRkah6uU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mdbfTwHU; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720599861; x=1752135861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wiG6L6fnYHXC0slZfpxcoK1bvgNXdb0lr5S3W3lYHo0=;
  b=mdbfTwHUAdKhW7z01xjmS5uSuDitYw1iEonHE/3s96M+C/e72Nq27GBg
   sVNiIzSxX/CyP1X5VwtzgoVuhoim3UqZJW0aWPPpEs0Mr+j1B1fxwgX+v
   PBFUPrfr56s0zHsG25E1cEKqEQnGyvNuio1wqkTkPyoUxIUbcTjEpHIwa
   8VH/K/eDTRUxN6e7H/Rni3R647AmDuqqZYYy5Maht/fikGNqHUejQk9Xf
   BCwKIezUdN8ya/5ZmI9Uy6CY0Vt7IKA1PPz4dhGlPysqAcDvVGfFEb0ac
   GmPJU1X0emZr0sgHArgTplpkguk/BBF/yZL3IYnTM5uwHR6/Tj4ReGgLs
   A==;
X-CSE-ConnectionGUID: sVNmw0vcQQm5z0++cF8xVw==
X-CSE-MsgGUID: GLNxbuLLR5W++LVQb0Wdsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="17769007"
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="17769007"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 01:24:21 -0700
X-CSE-ConnectionGUID: v0ERfth+Sai0V+eE0yTaqw==
X-CSE-MsgGUID: AzvwcTMWSm+S0+DmjZ+KqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,197,1716274800"; 
   d="scan'208";a="48231660"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jul 2024 01:24:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 10 Jul 2024 01:24:19 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 10 Jul 2024 01:24:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 10 Jul 2024 01:24:19 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 10 Jul 2024 01:24:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHEDouNz+6J7czE032UkrGzckDWukWuBX8L7SEVN4o4wpgCwtfNQX4934I95iE2Xm9ZlOIOyU32n+Psqb2C1hExumJ8z00oGYPdpD625cAXR/TsyAZOHvgbtus1ALbBqEH2paaFqZpoHHooMG36U6lHaxC+jrokQ71w+9mA44XZ2LYuQ6VhQRfwUJwnAEs9JxNHY58Ue0uy6ZGaWkD4Ayw1ET4pZCbjpsZZDa9CHRKlxM5aVhJfttChFC4p7Ji2UuCSvBJLv7FtuZUoITrfWtpKL8h0ON67/YmzERRdZzgTmCRPZZaKEZ9yhzEzaE3zP85ojPImg+w6sxkDWqm+WFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86nvymGsMWnkPFWWuIicas1eKB3UjiqcQ1DaWDMbhJY=;
 b=ZbPvtD7cuYJhQ0pH0c+vpaPh8bRzem8PpnsQUHfifT/6fu1F3otBlGasZfqkWunMkQkJ6DV/FM8H9AKg+OcYmD4nlg+mlMqVx7Qgynkm6m4Tzk56iMxs3ZCKvIRiWP8+IcUmu6Ekc8nJMbwnlcUNTJKfhtlvpNACaH8aBSCogdXmH6vu5jesAi1SXXCa5GhcKpU+ERa2f/peR+GPsSLU4qJlulcuK1UmhTwlwxzUcenPT1jKwZDxoYTCdwr3qs5m5v5WDacsaTaryvStoz+fDpHrUBUw+CTsp8m9TivUOj4gwmJTv5PYd1BHStysHS/5kxdqQ4SHxLkF/4qe8BHntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5151.namprd11.prod.outlook.com (2603:10b6:a03:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 08:24:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7762.016; Wed, 10 Jul 2024
 08:24:16 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Thread-Topic: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
Thread-Index: AQHayTj2wpmFdPKSj0OJ4Op2lJVMhLHvsdBg
Date: Wed, 10 Jul 2024 08:24:16 +0000
Message-ID: <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
In-Reply-To: <20240628085538.47049-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5151:EE_
x-ms-office365-filtering-correlation-id: b6ae715b-716b-476c-908d-08dca0b9b031
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?0z9+36/dLet6x5CQWDuzfUn0MMwlFYCFI0vkJbF+OIIIdDjo/hUIY0XaqGWU?=
 =?us-ascii?Q?uOy/Q+Pzhlu4DLKeT/McWCHuktvU6ov6mTQCenXRaMU/ofNmfn+8E2E/47HE?=
 =?us-ascii?Q?RS04bfOagNZNZ4QAoLQKrUn+xxrKpy5OUUGV/zMk81jqm5oD0l3fnp2Z4pp4?=
 =?us-ascii?Q?M9Paootyfn+EY7k6TZhsFvKl+POzmINfc3PohECAaE8AZs/ebRkfXn1o4o0O?=
 =?us-ascii?Q?x2Se8K7oHTer6Bbc17xqIyCQ/TxnoR0iLXIPf2R8ByAkz6l4RFk+F2noM+l/?=
 =?us-ascii?Q?io79ff9uazF21/pOimnnkNqK/0bMJXq4pGPLxcwfBs6LxcbmRf/a7frwPK7W?=
 =?us-ascii?Q?j7nAeV+rT5Gm8+FagkhpBBXdOwqKHQLCe9W/ozc9Xufgt/V+5Wr2lMx5wvKG?=
 =?us-ascii?Q?++eEMCIh7vR69NB2vxiOnegXhCMenAPaFDXxYge5QZHXMuIjiq9v97gDTj2M?=
 =?us-ascii?Q?n+yrZ7oRU2FLfCexKahGi04GVAfOucQRyJE5hNRc1L+p7f45fSoeiT7C2vDH?=
 =?us-ascii?Q?wAhNFA9/ONOnruBTlaxlFN3Aujb6CcOCpEKuDRS4+NEgvFY/ILkDGUh9aXZq?=
 =?us-ascii?Q?WvO0VE7nsrHigSU1Q6RSwxg897M1i6UHknhWcb9L6exAq34SU2wEuepn4AxE?=
 =?us-ascii?Q?hl6oPnSexBc4XFiO/7f6C4jMEO2q6+Mdrx026fhist+o+0kf2vFQmiZ3KazM?=
 =?us-ascii?Q?6ffBEnanpurXFlDwc8+4jT9vpDme2GhYGzsmy8nCmJmssJC+cEdoFGHXjqbV?=
 =?us-ascii?Q?/ayCi/03w2oRVEdWzdYoXPbmywdwDXChBkfOLAVNf+9CscSWG9PgEQqdGtq9?=
 =?us-ascii?Q?FoXxkc0TTmHKWPCwQDcPLmy/0/JJ0jTvfYqxlDVZLQ2eEzjjxNvIluVBat2D?=
 =?us-ascii?Q?g3NJ2VTQsW3xDZolD8kaAoTLV2KGo2Uesjk9hpHgf5PG7tx1Agpjx7Lhtwbt?=
 =?us-ascii?Q?2ma3TT7DT+2O2obyxMPHbMW6R0PbyASj9VxZeTRghq1NE1Dnj/yXzNr9V715?=
 =?us-ascii?Q?oeWRBr9AeYgzeht4zEgwrEShnjKC1EwIvOD6EgdgibzJWXgFFGjLb34IGqTq?=
 =?us-ascii?Q?noYSc09lNxImJla68N61Kzd1ur+pb0N8jJMN8sqEe8+cNFie4iSTq1v5WAoi?=
 =?us-ascii?Q?oKxLBgFA0otrw5xH0xb4l4YlKYkrUHkZiaHmdhB662S34mm2F5jhyPr14NG4?=
 =?us-ascii?Q?uJBix6uUlVYiZbcoN88AuasiB5jwBDzYnyl47atWayYfZOOKgYajA5E2F/z1?=
 =?us-ascii?Q?ZE7Cu02x8U1AB41m+n+9gscVTopkAKCPCMgNKHvIZ1hjR3bJNUyXotcVm2ha?=
 =?us-ascii?Q?gYlT+XnqhAtRdJCAefqM3xwgN3t6g5oyA6KB4RnJCFPHdxnDnJgysaZ/oeJc?=
 =?us-ascii?Q?1skBUBI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dWSasdbTEcnr3lEVvIB/Bf5bV41f7AmkunvPkAapPsX2q1bHBMmtmRdU0fM/?=
 =?us-ascii?Q?15oNfIw7O+Qhlca2LZOJUwwfNz3ljMOnoBIZxTUULfXZZKe9PQTS5mV2C6uE?=
 =?us-ascii?Q?aSei+qIcuIkIFH4yjbvJkUlJeQgPhCEb/rsHNvC21oWSRIGfCn2CnDL3K7AY?=
 =?us-ascii?Q?Qm6haVUid4fUzu3YPsjHpFinfb+m9mY+pG7J0Ol8gpvdNB0Mp3T7yomAUaHh?=
 =?us-ascii?Q?sJBFEe8VDWj46dqILPMDYtOE+HAKWR+FNgc1wZJP0vjbY78OOoxdmW/R0ej0?=
 =?us-ascii?Q?hA3spq94DZgWP41HZy/WI89v33R97XK3b2qxrTqjAr3K46pMtz5ciqBI7gR2?=
 =?us-ascii?Q?q12jyZWGuoSrX8kUOgynvICwz1xXx5Eoafiis227ogQB/87CrD161nb0SJqP?=
 =?us-ascii?Q?xOTcBtFi6/t3VtWrz5I4iFaRrYdQKZrQC4GwbyPoSy5dYLmWX/Za3mERjav0?=
 =?us-ascii?Q?U/EeRNirVW6WaShMsXDM05baA2gysoN85y/bo7UTLSRXHy9yNnEHu1LhtRJC?=
 =?us-ascii?Q?4flSfgqNkraKduiPBDoqEgciMIDgPg+o1aEx52FIAzfHl4Tj+Ee3ZKTe8/eG?=
 =?us-ascii?Q?cgAPWZ7qmJn3r1IrN84wE8Vx3ZmF1jY7u1GMolePNMVnNxa2BEYP98Nu9Xw4?=
 =?us-ascii?Q?9yrf7o7klFkMkb1DtXWwueuhNDyDaNpkcS+qU73lhoOU5MFxr4ZnYwD/d4nx?=
 =?us-ascii?Q?sLTA6tubKbjddHA6CidyFJTnJ8lmq1Xh4HHS3rrR2qN0TSokiiS9cBDm6xR+?=
 =?us-ascii?Q?3qTpWORRUfIsiX1MkoDm9RPy8hk9qbK9+pT/x23esGQJoInW1fUYeA7iWOVp?=
 =?us-ascii?Q?++bSx29BibuCKaXpT+g1uW9YWDMA9lxcnz7MpSaPdBQ7ok63qOSKXuxz78Rw?=
 =?us-ascii?Q?H7Uz2y1cr5iN1Y1UClP9+i8gYlhKdJU/09UAfBwnPKevPVUPTuvPcS/aXH4z?=
 =?us-ascii?Q?zRnIjW9hYGQ4Mz7A1JJRKYBHxqI/nAMwhzlwJLSYkzWbF8CdX4hGhwBo1N+F?=
 =?us-ascii?Q?sSbLd1usbJCIEHfLVA/YjAkBOj4NrihqpH1SiVTrV5J24rtCJbgH1HzGDwlE?=
 =?us-ascii?Q?NNwOmcmO8E0vXAVmQWmmPK/zVyf/iPf54/ZiVg7HKXZiZNFrL5rYs/90hEXV?=
 =?us-ascii?Q?EX2Y+lykZ/I5HZD7psVajEkYFVWwojtJUmOEFAtWztyF+XLdVKhAnj/Byw12?=
 =?us-ascii?Q?dkPya9IV9k9TeIukQjHrnH7PWnJdYHOQXKh+IGoTGeuKw2ZUkkDiUG5JdoQL?=
 =?us-ascii?Q?dD1PvHX6hbqE6EToL2P7VSGXV0WtWovq8jJ9HRR+euYDSqXFjyUgADl58kFV?=
 =?us-ascii?Q?kIvO/YluAR04fP1+JFczbYQCOPzJEX6A2jwEJx5pHNQjQFiIaqyVK4GxwCuY?=
 =?us-ascii?Q?QPDDM74AgRfTRmAtAavmI6lVi4VlKjGBhpQNsJ6AYcQ7tlrHmAG6S84dfLWj?=
 =?us-ascii?Q?e2z6tppVi2kHP1egNnV3qzX/kNSm9npa4vcLvTemitluQwi59e9PRzlU2Grl?=
 =?us-ascii?Q?DAZT64h8SBPgKF25WCIwQ0OIVaG/05ry/ZNNEqhax4Lxiix4aykwszTaUM1S?=
 =?us-ascii?Q?S6IvqeeZgLaHfE4P1M5XHwdCrG4auvqOn8077oHh?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ae715b-716b-476c-908d-08dca0b9b031
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2024 08:24:16.5026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u6JDL81yTwwt2TqjtdzPJj3xyOKp++L8MWkwXfXXzy3iU2Pxrc+hjScFXmMTlv8q/YDismYWczhKMbFMiPQ/7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5151
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, June 28, 2024 4:56 PM
>=20
> This splits the preparation works of the iommu and the Intel iommu driver
> out from the iommufd pasid attach/replace series. [1]
>=20
> To support domain replacement, the definition of the set_dev_pasid op
> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
> should be extended as well to suit the new definition.
>=20
> pasid attach/replace is mandatory on Intel VT-d given the PASID table
> locates in the physical address space hence must be managed by the kernel=
,
> both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
> which allow configuring the PASID/CD table either in host physical addres=
s
> space or nested on top of an GPA address space. This series only extends
> the Intel iommu driver as the minimal requirement.

Looks above is only within VFIO/IOMMUFD context (copied from the old
series). But this series is all in IOMMU and pasid attach is certainly not
optional for SVA on all platforms. this needs to be revised.

>=20
> This series first prepares the Intel iommu set_dev_pasid op for the new
> definition, adds the missing set_dev_pasid support for nested domain, and
> in the end enhances the definition of set_dev_pasid op. The ARM and AMD
> set_dev_pasid callbacks is extended to fail if the caller tries to do dom=
ain
> replacement to meet the new definition of set_dev_pasid op.
>=20
> This series is on top of Baolu's paging domain alloc refactor, where his
> code can be found at [2].
>=20
> [1] https://lore.kernel.org/linux-iommu/20240412081516.31168-1-
> yi.l.liu@intel.com/
> [2] https://github.com/LuBaolu/intel-iommu/commits/vtd-paging-domain-
> refactor-v1
>=20
> Regards,
> 	Yi Liu
>=20
> Lu Baolu (1):
>   iommu/vt-d: Add set_dev_pasid callback for nested domain
>=20
> Yi Liu (5):
>   iommu: Pass old domain to set_dev_pasid op
>   iommu/vt-d: Move intel_drain_pasid_prq() into
>     intel_pasid_tear_down_entry()
>   iommu/vt-d: Make helpers support modifying present pasid entry
>   iommu/vt-d: Make intel_iommu_set_dev_pasid() to handle domain
>     replacement
>   iommu: Make set_dev_pasid op support domain replacement
>=20
>  drivers/iommu/amd/amd_iommu.h                 |   3 +-
>  drivers/iommu/amd/pasid.c                     |   6 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
>  drivers/iommu/intel/debugfs.c                 |   2 +
>  drivers/iommu/intel/iommu.c                   | 117 ++++++++++++------
>  drivers/iommu/intel/iommu.h                   |   3 +
>  drivers/iommu/intel/nested.c                  |   1 +
>  drivers/iommu/intel/pasid.c                   |  46 +++----
>  drivers/iommu/intel/pasid.h                   |   5 +-
>  drivers/iommu/intel/svm.c                     |   9 +-
>  drivers/iommu/iommu.c                         |   3 +-
>  include/linux/iommu.h                         |   5 +-
>  12 files changed, 132 insertions(+), 74 deletions(-)
>=20
> --
> 2.34.1


