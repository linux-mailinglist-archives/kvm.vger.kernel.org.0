Return-Path: <kvm+bounces-18357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 479338D43C6
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 04:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A653828398E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 02:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0818A1C68F;
	Thu, 30 May 2024 02:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PRhm3/go"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE761BC44
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 02:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717037234; cv=fail; b=af+mk8FEqDuG2hI8MF3h7GFOYEw7HEj/ieOBwOB+cIt45uCUO4Q5nI1P+6kv0+N7dQsFF+4vxbqXefOL/4EVV4XEmw9x6bEa5mvYcIUSIRgT5fSMDDhd3OhCS0hHX0rXpjZVTGMm6g8TBxIhn8wwg1v12w6ej+o01oYpxFGPui8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717037234; c=relaxed/simple;
	bh=9KrANczW5/a7dq943UBY6bNQ2CEAJstkbr9CDBN2P10=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XVNIIMtMhXwCTKzKhkyx3t+nk1ElY+JdXHMGZFE8WehRs9xOcNVoarbD2h76l1tjSEDr0dEY1PsdHJFKmoUHE7H5fobdeYEKGtYj0JaA52c3DLiRbaR5GuS9oVq0TZq6HFjVMwz3HO2avM6mg0/jbuwUYeajAlo0gc91tMgUKa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PRhm3/go; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717037233; x=1748573233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9KrANczW5/a7dq943UBY6bNQ2CEAJstkbr9CDBN2P10=;
  b=PRhm3/gombW2avpq+fwClrEhTNNdQSNqb/HR/wCZnCc6WjyQEzq4Xchf
   Ue+OaHyTeDWifHa9KnIo3AGlo0SdWPGltYGZY6Srgsv6rOOdOnbk57MPq
   VEA6QfnpPiXXZKOokYH78NoJa314w1PYLxZENMrB2K1wB8X5Qrxfj9Npe
   bzdbVbv5mHnDIwQSqYUzKyakHVFI0/POYusUdq9l8qJly+uJM/PFMVIy1
   piXzycDUh6g8siix09te+NCrUNIrtUNK1zm/3sRx2MIGMQZ4JSJRTY4kM
   pMHxNa8KRq62VsaQHfDeK69UKORzRgwms5TQVHKqoBqIxsR/MdM98iXGC
   w==;
X-CSE-ConnectionGUID: dfMX8La/TtaWKGCx5qAFjQ==
X-CSE-MsgGUID: ekNqeREzSiSm00N2RFbfaQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="17320759"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="17320759"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 19:47:12 -0700
X-CSE-ConnectionGUID: 0PTgDoH5RTewm0NRPm0GFA==
X-CSE-MsgGUID: fFUCvZojT6SVHFdGnmaUUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="35708888"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 19:47:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 19:47:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 19:47:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 19:47:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 19:47:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsOIwp6dSIX8tTgCLwToDVmkW91ccQ/h7mF4Hwr1eudNcCbNg+gBLfTYo+m08VlbAQ9FAzUjm+em+WeRTUBvb6Pp2A3boDqFdrg+Lf6eX7zXuPakDqo6KscKCPZsnrx9Gxe0W/uZrRsItaYUnfvsqOHIEAjq+b94ffm91zzsmoIkZ2vWXzU2mzF0EVmoIn34tqVtYWndwViv33BTQ2gGMJqA1R5JCPGnxsp6h4QiFiMnElM2ZcdOT9LKTp31X4Ts95jLYG2g0Sc+gJvO9DhqWGUfZpHu5tGkbjsxxHP9uG02x9SmqlXKu6aYbk8FoOFlRqZdhVK6F1xiQKhr7eFE6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgsQnYhqr+cxIlqb7ibBpMMdm7pB20QRlx0p1RU7P5I=;
 b=GCL2Ve5ZwqlK6U9PvQ7pNESDPCgO2BG2q8pv6QMo8mk8PLbl86FF+PfWru+dYAgrsc8kkYqCudYWIIE2miAmiOPs7s1ao7rz5c8Z/Td54TlCkVO0tptOLtzryJI7/hnxnamJ/55LsqpLpyxKKXRSgsBpu8n/fPiXRBQl+VTB84uLOGPuOdN3g02SBQyYgt7wofr27VS6mhctI81z1e4sQ5SIgK/S8E30my1nHw1PxkWgW12wRv8XSeHtihpnPOXZMfRsAyfnr6h0TH5wkpOxYxM1xbEinpU03XG/o5p0rSOLnUBUSHW3ro5li4xXwP2rHF45w0l3peVk3LkUwGzzPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7347.namprd11.prod.outlook.com (2603:10b6:610:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Thu, 30 May
 2024 02:47:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7633.018; Thu, 30 May 2024
 02:47:03 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>
Subject: RE: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Thread-Topic: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Thread-Index: AQHarUtexRr63CDGcEKkpW21XYaJoLGu7g9AgAAnqYCAAAbTgA==
Date: Thu, 30 May 2024 02:47:03 +0000
Message-ID: <BN9PR11MB5276289D3F06F90E3F9E71618CF32@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
	<20240523195629.218043-3-alex.williamson@redhat.com>
	<BN9PR11MB52769DB022895F3D310F52458CF32@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240529202201.7b55549b.alex.williamson@redhat.com>
In-Reply-To: <20240529202201.7b55549b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7347:EE_
x-ms-office365-filtering-correlation-id: b0442c87-8af9-4b25-adc9-08dc8052c9a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?4xxfZA6XDkKqwM1nBtPNQ6P7HRd8+dxn0gxV7X1PtU76CElFgGZ1uQznDdLv?=
 =?us-ascii?Q?SFALqll5t7apKplM3R8cvLW179CLJxQJcpmyiRs2QNQhkY5kkumcuozOo5cD?=
 =?us-ascii?Q?FoxjhAbF971LemMLVbD2If9SiYSZM2xEhMCH0rq92WwXXq+5kXBLXaDRh3zf?=
 =?us-ascii?Q?mNjhqPSy5js+gbyEQ10zR7RMYokVGBtZsLl0HPUunvR8wqSULHmxHIYB6Zey?=
 =?us-ascii?Q?hTIgDQ8Ch04stg4lr6OUlJU5JguIYcqDI/rT9rt5aR0tVWWqpgL5uGrTXDYY?=
 =?us-ascii?Q?yN3X2Ro0ZWpkMfq/YVCzZrrphUe2+6K9AajkBXXkPEXbWXu/M2YVUAzo77wC?=
 =?us-ascii?Q?Nd4zqzirFbiFm735/eg3AwXSMW0i0o77EbLcbV+jA9AkeT607X6P7aKX7c/E?=
 =?us-ascii?Q?JjdMqTxK6t31nnyf7OVzkg+UUo7GV6FuRqtXOh19msDk0M22lWmIcJsz4mn+?=
 =?us-ascii?Q?ZMQGcU1n+hcdWQ2ARqBULBevhsuUmDRTkva10vAa7zW29MWyqZW+7Jr/Hh0K?=
 =?us-ascii?Q?l8aKV1AdYAxoylC/UW7grgpz73ofhY8l+J/jcrFzMPBeNYlItA/wFjLoXTDD?=
 =?us-ascii?Q?xgBfDThP4RZF3t2VZPMkAri1Ux9xmQ9NliJvsfzDqLFOLcQYmILm74VBH9KL?=
 =?us-ascii?Q?7W6zXDL887aWK18WunSL0tCs2Y+5oq1hBlmUTqAG4K6qVouagfh9BiDoY358?=
 =?us-ascii?Q?ImzFHJ6Z/CJ8okbDsG0C16Bcx9BwxYzBmXxYO7/URUhMc+IrM6pebGzVxdkc?=
 =?us-ascii?Q?ihcELclasKcTpmMW7u3Rg+X5LDmHM9IWkR2sS2LE3r03MlW+gOXsjOS4XD8l?=
 =?us-ascii?Q?G7qWVbzf+ykSe1JHWUoiG2vkBvF6mrGd7sPeGc666Gj9fX8MkiYp/CtUtaSp?=
 =?us-ascii?Q?FTEAUKSPpAOncpSccyP/y7ekR9wBseV/6yjfkEk1no2Iohb58A18AovptPQ1?=
 =?us-ascii?Q?mQ56/JDBiU9W+aUpLlBCV/LKcZzl8NLQ7gAH/e4aA0PaUmOaeQn5Jo/QKKWA?=
 =?us-ascii?Q?Vv+kdwrsWA+4HT9iD3aaoi5lRzTLdYfTuqFKkEmroFwmHqo0aV+n35vpltA7?=
 =?us-ascii?Q?yZDDAqSgepU6xbE8drkpi01jdJ+FiqCzcr4uHeXN5XjBqS6PuvRfvDix3ziS?=
 =?us-ascii?Q?tUR/r0S81sx18mBvS2yBsE6/NRReUuucToQujNfx6u1BMxj/o14CCVLOPxfZ?=
 =?us-ascii?Q?tRMNqQaWsfs5LlFC09cA/TKp4uPPqkfZ04WL485nLdhX5DitCPXot7FRmMOB?=
 =?us-ascii?Q?wcGPWpQdsh/8S6zyHlowvODY35a6fgYtgBs9n+18itJn27u34q0XuN9YkTx2?=
 =?us-ascii?Q?wrKIT5+scWFnxL4sSrtuxfTyQ64buXxH7JtmMGuSQlo9mg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nAhDOdkHWBmLjoB/YnI5xS4/vfSB+2PTeVxxNc0D27LQQ7R41cDvmOPpUn3y?=
 =?us-ascii?Q?0p57ZsrlQvGdDvdGe0jb4yqN/t0QdvJiL7lSoL1ZVxhmewLi4mdQdzG4/72S?=
 =?us-ascii?Q?Oz4zEHE4t9SWWRp7H1Es/i6VdhMcQxOSsfuPpTiSQzZvnhb7PQM8O88I1PbL?=
 =?us-ascii?Q?gj12csSVo1GEy3b25Zy8l8fWjw37rHp/XkFNdahl2OBYcubTcpjdNYSu9Gb+?=
 =?us-ascii?Q?f3ZXcyMAXjO/eYAE2+0Y0cG2Q5LVI1NBrmzDaeezk+oYQsbFPVGy11RN7G/G?=
 =?us-ascii?Q?QwOiaMyHtaKbzDoYpzsC9mKDkq1DwMyzrvckYFZopOS/NIduC635zYgwZFM2?=
 =?us-ascii?Q?T+5bd0lvuJSqbqGF5/0LfdoGOwddclfQDOJtOqHC5SlEG6f0dUE/NERb6tP/?=
 =?us-ascii?Q?Miua4Fso/W2YS4IpsdyK0rdys/i6IbFG9Gla1sgkyek0IvDX+wW7FnmY8vw4?=
 =?us-ascii?Q?zmfmxGulZ/hLSE+mZxQcwM7Y/YycPd5E5+YtcoV1733LrG1EYwW0oteaB+Ie?=
 =?us-ascii?Q?I8B/o/3+wtimmdDENEh5TNuW9oBt/IBzDrM6C6bTG9/DUpwlPXHgBOCYdHnj?=
 =?us-ascii?Q?d6f2N0QDAD0XI7O0AwOE0s3oKhTOH8KRAh2isXDJYlBN7X/ze0JzFM7wF3b1?=
 =?us-ascii?Q?+m3WwmhToLwVUiu6ZBrfWbHu0HC/yaTfg3lylgG8OZ25JZdRd4FRwSzO8J4+?=
 =?us-ascii?Q?/oaL/AX4Zb48koMwbNbLAVdUX4GPuEwSg9lb+cBX86G5Ify2kX04RihH0VeV?=
 =?us-ascii?Q?OK+Lynw60XtoARLvjl9Vz0hTgJ5Ibc+PE6eimDP85hf0CBi6jGjUnVGLklhP?=
 =?us-ascii?Q?Q8jHKvYZekmgJuu1Nxz81x+MHLPjLHRKfiXZZlu2Pfq60TkWyNvc/U4re33z?=
 =?us-ascii?Q?P3fS41dFNPFDzsQ1RFV007gfrEme0/SnikDpj0QbtSLgrO38oqGWGmb+zHTt?=
 =?us-ascii?Q?rJNh6QU2NtYFuZJ4Ne4OtDlhvI9UvKhDcqIQxNhLLA7MgPkDRjP2E1Vs0nYi?=
 =?us-ascii?Q?n7hiqYlOOvepnfVmunkDj7cDZ59X1M89uwtojKrNjbov4WteIAGV9XKcfoQG?=
 =?us-ascii?Q?zWzIqWq/qW6s7KhckFBiIm9A0e2xb6RaOCYP3CbivLAZ9uGxpPQxVKbdyp+g?=
 =?us-ascii?Q?bZl7dWfZaGIjo+mhDsB3Xdfb3zESpkK1XkXi097mBE9+TZsiiMNXTXkw94tj?=
 =?us-ascii?Q?oNWQUlO6KRKpisMxYXPLPWc4d3naC2RJsPirKQGbABgQQUKxQp8YZmRrWbqG?=
 =?us-ascii?Q?k1JOcyHyaiXYIqMyhvw40nXh1BXx1hQyzhVFwZBTm6BDPHU2tc8FfbpQmKDy?=
 =?us-ascii?Q?FwkXvz3dShWotsg8JTsp2yFjI1mWNzqBcp5Br4eA+GrM7KUwo+JYaT4bJftq?=
 =?us-ascii?Q?SvnXtIBYO9ufkkhm7onL4qy91g6Bn5Q5dg7eEEsSRfd3r4IDOk8uBJlEdwCK?=
 =?us-ascii?Q?w8ZcBoakipCdqgupAduewtObC3MR0z3CcLr/lrpQQGR0nRe0yern58um1zY/?=
 =?us-ascii?Q?RYeYORiprdt0WiT+aG2FJ1TkQyR0iEBsQsKsTq6hHe4DucjjiUWZawo0m7vL?=
 =?us-ascii?Q?vBnpV2NjGH21I+ZLzWrPIMf+GGU/HSvaCphEpmdw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b0442c87-8af9-4b25-adc9-08dc8052c9a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2024 02:47:03.7781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2CRbIrDMN+a8xPwwqZtm2kZkCS07BTWmK5eICsYoEsVsZX944pJSZdtXoZnOcsCj7tsX7TUJS/7yFDcBneUCuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7347
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, May 30, 2024 10:22 AM
>=20
> On Thu, 30 May 2024 00:09:49 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, May 24, 2024 3:56 AM
> > >
> > > -/* Caller holds vma_lock */
> > > -static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
> > > -			      struct vm_area_struct *vma)
> > > +static int vma_to_pfn(struct vm_area_struct *vma, unsigned long *pfn=
)
> > >  {
> > > -	struct vfio_pci_mmap_vma *mmap_vma;
> > > -
> > > -	mmap_vma =3D kmalloc(sizeof(*mmap_vma), GFP_KERNEL_ACCOUNT);
> > > -	if (!mmap_vma)
> > > -		return -ENOMEM;
> > > -
> > > -	mmap_vma->vma =3D vma;
> > > -	list_add(&mmap_vma->vma_next, &vdev->vma_list);
> > > +	struct vfio_pci_core_device *vdev =3D vma->vm_private_data;
> > > +	int index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> > > PAGE_SHIFT);
> > > +	u64 pgoff;
> > >
> > > -	return 0;
> > > -}
> > > +	if (index >=3D VFIO_PCI_ROM_REGION_INDEX ||
> > > +	    !vdev->bar_mmap_supported[index] || !vdev->barmap[index])
> > > +		return -EINVAL;
> >
> > Is a WARN_ON() required here? If those checks fail vfio_pci_core_mmap()
> > will return error w/o installing vm_ops.
>=20
> I think these tests largely come from previous iterations of the patch
> where this function had more versatility, because yes, they do exactly
> duplicate tests that we would have already passed before we established
> this function in the vm_ops.fault path.
>=20
> We could therefore wrap this in a WARN_ON, but actually with the
> current usage it's really just a sanity test that vma->vm_pgoff hasn't
> changed.  We don't change barmap or bar_mmap_supported while the
> device
> is opened.  Is it all too much paranoia and we should remove the test
> entirely and have this function return void?

yes this sounds reasonable.

>=20
> > > @@ -2506,17 +2373,11 @@ static int vfio_pci_dev_set_hot_reset(struct
> > > vfio_device_set *dev_set,
> > >  				      struct vfio_pci_group_info *groups,
> > >  				      struct iommufd_ctx *iommufd_ctx)
> >
> > the comment before this function should be updated too:
> >
> > /*
> >  * We need to get memory_lock for each device, but devices can share
> mmap_lock,
> >  * therefore we need to zap and hold the vma_lock for each device, and
> only then
> >  * get each memory_lock.
> >  */
>=20
> Good catch.  I think I'd just delete this comment altogether and expand
> the existing comment in the loop body as:
>=20
>                 /*
> 		 * Take the memory write lock for each device and zap BAR
> 		 * mappings to prevent the user accessing the device while in
> 		 * reset.  Locking multiple devices is prone to deadlock,
> 		 * runaway and unwind if we hit contention.
>                  */
>                 if (!down_write_trylock(&vdev->memory_lock)) {
>                         ret =3D -EBUSY;
>                         break;
>                 }
>=20
> Sound good?  Thanks,
>=20

yes

