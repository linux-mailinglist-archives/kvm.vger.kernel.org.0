Return-Path: <kvm+bounces-11357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64200875E60
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 872E31C20FE2
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EC14EB5C;
	Fri,  8 Mar 2024 07:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G0OeED+V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AC14E1DC;
	Fri,  8 Mar 2024 07:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882456; cv=fail; b=evXRYHwjjXObgeLh7uoXkR4HP1JMsmJDeihKCDokdScpHoNgc84MhZ6ttpWxRoLjzztlSw9keohjpXFbOGXFcku7vCkVHPFqDeU1fQJBW+gG/Ggn8lzPpqm4iQDyEez5YbDDShDs5AQo0Cxv48APsqjv0CKkgujqXSdAQXo+WHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882456; c=relaxed/simple;
	bh=obsCMbr3VfRrGEj+lJxhbE4msoUBlKJLvKxFNwygxVc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pgfrxs3Lp69Ku9Q6U7D9X3gxFAGK7kszLmwXeDg3WykJbBKYLhj+I7lWunO5UTkx2SpDeOWKu3TjSU0BayLguuO74NmwhBwfoeXbL7ha082uUubdVI/REHevYL2cCimpyPBuR7dbM/Xa4adSJyzrysy2IEFkl+s9dd0srLsjC9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G0OeED+V; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709882454; x=1741418454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=obsCMbr3VfRrGEj+lJxhbE4msoUBlKJLvKxFNwygxVc=;
  b=G0OeED+V7+bsxhp1Q8lUpyTWFQY/+zCZb//ujYZ6MkvzTQ8TtGaj8/g5
   8I/IxvC+00kG/FhbfGgfAu7v8TMWtMbrVFjhZjqSig/9spNDajvStYbFE
   fRA7YwENEF0wEg61PBwW1y7aSkczphuny8H+C89+/mK5ojFXWWOgaL0Rm
   VCBYO/CSXaX6Syk6BQvTM8lZJbeDsZGnXSFQXhU9xa1w9j7b8rlmbkS/3
   eLEFW92VMa7cBIUWdDtJ+47gyAuPPtMPRVhKdK7eRWbOb2cReAOimfYyG
   nvQ6BYYkst3LxApNx2ruFbAhj4BH91Uc38IFapK57p30SBNZ1VPcHFXEa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4771111"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4771111"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:20:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="33530150"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 23:20:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:20:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:20:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 23:20:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 23:20:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGfK6iBiMqW71q0jqmauCk0BCARovzq7QzsqCvZq7Ln6MSzKuhNowBNuHNce8XQeEoJ8A+BnNwItKGgMyC6pE1QVoz4ByTHss6aXHtzoYvlrEkD1WTMfWE/H8zt6FEh0LMdVJ++ZnRQe3uwIlqnQ6KPcEZp6FTPQCVmf0dVMqn6FgCwIGGaZGN/IWT8yyn+oRcKOUzygQ+gNZ5MCH6jxAXgxcDCPrZDiEs9zo0vKBN88RjSG5wEH4yVozz2yJGV1LkiLf1WOaw4v0J5bEV8TiulLedmQJ2ycuUEsCQRiUdhHsPYcDvGzGEIWTgSr6MfBf4Zr2poPAvXh+hncWr0HGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODkZUdDJDJyPhYu7bPHgL6js5e+uBgKC6K1SH8JZDqI=;
 b=RVE+8S4yGKsVQBtADvUAA2oikw/N0QI5Dfk0XqydX5ELE9IJrrOZIflrmIv1HQbsLpkn06LGpNmx1oW1C5cN7xtV+JQRYNa0HF5xkh9ELQPA5RKn1qRKVRrPLv8opdvwPG+SpBnaq1TvIYVh1X5Tm76uwyuMClsKqZ0xXDvniRbDUHi0REo5crI19j+Budtyb1EwPNbfAFdRdt7We0LKXfLyXGaxgIoXUt07jYG4xo1HUycGphNIGFe2LAYmCgRHnbNJYcTzYofuLgY90cpIP9p5al/Ll/Dv8BExSXE2TcskluIlANrXFqbHBt328QJs+0XkS5E9TpudQ9sYuIjM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5274.namprd11.prod.outlook.com (2603:10b6:408:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 07:20:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 07:20:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Topic: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Index: AQHacAtu1xn5Hoku+0au9dqEK9o17bEr8fnggADG1QCAALkOQA==
Date: Fri, 8 Mar 2024 07:20:49 +0000
Message-ID: <BN9PR11MB5276AA639CD6C3D23C6C9CE48C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
	<20240306211445.1856768-2-alex.williamson@redhat.com>
	<BL1PR11MB52711AF96C93A7C2B70FE12D8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240307131716.5feda507.alex.williamson@redhat.com>
In-Reply-To: <20240307131716.5feda507.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5274:EE_
x-ms-office365-filtering-correlation-id: 36394d81-4468-4b66-89dd-08dc3f404818
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2XD0c3vErI4wMJbILMyhSt8qQa22VzYUK7UFpeA/bY6vurpPqHUo2CXRApd46qFN/ZAo/mZT0kvxNIX54dBaLFDrzXjvNvhkhcC7q/r28QRsaA3r8qr5qqUkCHwpdrp5MCRU8XteHMJbWIbfzS+am9FsnRaEFKxFl7EpOMwHkJj9BGI9c91yBxo5tbq+GjMotcoJ0OkXBaNJ9+z5BmtL/L2Z6guYZT+ZoM1epMLvpJJDB0oiJApa2F9G7aR/1va6HKz8gt23FThaubdsRitLCX/czRKdjZnUhCcWOlgCoiim67MZTgRuN9zF7cPT4EBWWg6UfCfpr6wLlU1eJYBCBoAZ2qnZ5oFQ8h/1IHAbo7ka6GvpvsGjrrh69PHIkdxftUAxQCoBasMnz3CPtLvHx/fbXDuZGK79DYcxJf5czOZFrokXQpM3ePeIc76+fVJzXLHRYCZH91lQfhEeeXeLlyVo7p7H5mHrF/csF/JZ3zDi0qIXG4jDoxTblyaQYsKb7+iRQuf7+q5dktm58jp7VYJGamALZI0sN1b9/vQFH5Gaqu2iNNzx+/djFW5avAlRNB8ZIaxvgvcAeOB6gzbeUuOs4L7NAIxz02sU+IAnUacB1c4BLCwCdL1FvYSRm9Z26KHiH/gIzaIQgskaNWQB/9UU0HIR1DVLL86MJHhxb5T+d6TcSJCSQwD4I49j29ff/Q99YjgE5LNbIt0YFjmqgiI656WVsVYybr91V+kq9dk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IFTxka29BS7wWAGPgRCaUi37IEScBl15ViiRViK4Xc4peBq7f6/5jr2hqF9I?=
 =?us-ascii?Q?Tr3VXQrKecrrDr1AXUVuZSh2N68hfFDh8F0UW3CMShigOKETvAI5ZE3Lcyzg?=
 =?us-ascii?Q?EkGWyN9xvRFzHiuvTj0ihQtMKBeD5usl30WsQvyGnaaSBhBOamjM7UU5L5lX?=
 =?us-ascii?Q?jI6NmiIZHR9jMb7QEOn1zZ97ILQu2t8OPgTmb0dXOxCKL1WGAwKpSKzkXvJ8?=
 =?us-ascii?Q?wYjv6mlPFyHIZ7O4Dj3+lXjV7PBtucw1cft7JI+xqeP23EGTrOMM7qBLnOdH?=
 =?us-ascii?Q?+OQcq5a7z59EGsltS7ieZeSFD50u4iE1f4vGO5yBp3lMB27pn1Fin27Qtq4a?=
 =?us-ascii?Q?oa/kJssSnKpKXjCBBRAvILnYjMu2OEu9SvYnizywEd1+SDFH/K6MWLo8GmeN?=
 =?us-ascii?Q?yuBeiM+zeVKU6czm8E3506uVm5JQN0BKZwBkU0yZq9n0Cn9haAdsArsS8Z0e?=
 =?us-ascii?Q?UwP9jebTVWfYGJXdzPMx8kWygUblomlGeA2wGcpYl7T6gYzFWjEYpW5J+G4L?=
 =?us-ascii?Q?NPgMO5NXArOVioEEC09O4dns+Lq6wFQWBulgtiMdFNXmiYdYYtr4OSXESgmA?=
 =?us-ascii?Q?zIq5Cvp9NgNYY3IcyJpnCKc0dEegeUojAvaIqZ9GRdEOaHtVz2G4Y84vX2cG?=
 =?us-ascii?Q?Of//GS/BW1L2UzN/lLzRATN7kL/59VtNvGeEdSrAkccHq665sY6Re+t3EZk6?=
 =?us-ascii?Q?dUI2+l+sX+vz2pYmHDvSoxeXd8RHBmngpB4UBDfy7Y0HTqXG9LMyyr+PQA3E?=
 =?us-ascii?Q?4Hm6EPbGT0z3NFVYjRtZkhJYu7685UqGrUHvdyT/sXZ8pPGal6WOosXbMVGd?=
 =?us-ascii?Q?awt0yeJKk42zcH9iuXbVn2zQ8v2amVGChWDSs+vrnawWC/k3dzOjYNGp7E3Q?=
 =?us-ascii?Q?z2AR66QKU6JuN0FMBCWXCrZOQxtxb203cqilEG9EHf0yD23e0oW5FSMl/ipt?=
 =?us-ascii?Q?wCtFUqMIx4ImqEr3VM0B26l7md7YdLQxqBILiBETX+8/qn7TvE0JM2oL9Z4P?=
 =?us-ascii?Q?dDGhrrbjKx9BD7mdUvft9mDgIc9vgPq7u97QCf/f0sxnQNUMgOmtulfp6lrc?=
 =?us-ascii?Q?5Ei0Ed2Om0NOo9dASCvxEMHs2qSJByVzCHFKo0O/GUp3YEhH/sN3kqit/szP?=
 =?us-ascii?Q?85hzHY/7BJtT/igABaPysLaq1neH9IV81FpOOLpqWsULW6ERWl6jhbzCLg1N?=
 =?us-ascii?Q?WqodmJfSkf7DcsPVv0jOkmuZq3g8XzEMV9oGLP4AtwW2Wuq0JIfIvbO3qszg?=
 =?us-ascii?Q?lHFTfNLvq0lqGfGqHoKYQf1Stf0W0vc3nZoyzoZyjkz8vgU6UgPQGVSx2Z4B?=
 =?us-ascii?Q?vtHoyoKAfZwqrHpKVhdnHO6YG/jyHH4ncwOSZfkYpzhyv9VfFKhwIxCJKx/c?=
 =?us-ascii?Q?D/W6JIh66hMcWgONtMIvXg0AvQMeC0U2xUoN6f5DqX6cloeMbNCso0Gu8nkR?=
 =?us-ascii?Q?VBHg7KKToBvuwtXuB1QZ3ayfHD9lpPrCdjWBMLopLJ+siq0if6Av7y74Nyew?=
 =?us-ascii?Q?lGLHfwurpu4sNt7xQt+wYDVQRtdSLdCwQKv7JIIML7u9LLHx/yUythZ6amf2?=
 =?us-ascii?Q?vF6ag68LF1Q/cRqvu8Zl9a/zToN5nvM64+pAFsXk?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 36394d81-4468-4b66-89dd-08dc3f404818
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 07:20:49.9255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rVZ3umjAxmNW37ivn6fZiu1juI/q8O4AK5PjlxlNbP0sLPcRLrW7wtECcHPF5s5uEnFJv+CovI8oMlBNublpfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5274
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, March 8, 2024 4:17 AM
>=20
> On Thu, 7 Mar 2024 08:28:45 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, March 7, 2024 5:15 AM
> > >
> > > Currently for devices requiring masking at the irqchip for INTx, ie.
> > > devices without DisINTx support, the IRQ is enabled in request_irq()
> > > and subsequently disabled as necessary to align with the masked statu=
s
> > > flag.  This presents a window where the interrupt could fire between
> > > these events, resulting in the IRQ incrementing the disable depth twi=
ce.
> >
> > Can you elaborate the last point about disable depth?
>=20
> Each irq_desc maintains a depth field, a disable increments the depth,
> an enable decrements.  On the disable transition from 0 to 1 the IRQ
> chip is disabled, on the enable transition from 1 to 0 the IRQ chip is
> enabled.
>=20
> Therefore if an interrupt fires between request_irq() and
> disable_irq(), vfio_intx_handler() will disable the IRQ (depth 0->1).
> Note that masked is not tested here, the interrupt is expected to be
> exclusive for non-pci_2_3 devices.  @masked would be redundantly set to
> true.  The setup call path would increment depth to 2.  The order these
> happen is not important so long as the interrupt is in-flight before
> the setup path disables the IRQ.
>=20
> > > This would be unrecoverable for a user since the masked flag prevents
> > > nested enables through vfio.
> >
> > What is 'nested enables'?
>=20
> In the case above we have masked true and disable depth 2.  If the user
> now unmasks the interrupt then depth is reduced to 1, the IRQ is still
> disabled, and masked is false.  The masked value is now out of sync
> with the IRQ line and prevents the user from unmasking again.  The
> disable depth is stuck at 1.
>=20
> Nested enables would be if we allowed the user to unmask a line that we
> think is already unmasked.

Thanks! clear to me now.

>=20
> > > Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive IN=
Tx
> > > is never auto-enabled, then unmask as required.
> > >
> > > Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >
> > But this patch looks good to me:
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >
> > with one nit...
> >
> > >
> > > +	/*
> > > +	 * Devices without DisINTx support require an exclusive interrupt,
> > > +	 * IRQ masking is performed at the IRQ chip.  The masked status is
> >
> > "exclusive interrupt, with IRQ masking performed at..."
>=20
> TBH, the difference is too subtle for me.  With my version above you
> could replace the comma with a period, I think it has the same meaning.
> However, "...exclusive interrupt, with IRQ masking performed at..."
> almost suggests that we need a specific type of exclusive interrupt
> with this property.  There's nothing unique about the exclusive
> interrupt, we could arbitrarily decide we want an exclusive interrupt
> for DisINTx masking if we wanted to frustrate a lot of users.
>=20
> Performing masking at the IRQ chip is actually what necessitates the
> exclusive interrupt here.  Thanks,
>=20

make sense. and I saw you replaced the commaon with a period in patch4.

