Return-Path: <kvm+bounces-14717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 821FD8A61D4
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC64F1F23A4D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E727381BD;
	Tue, 16 Apr 2024 03:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuS7ucZw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007E33839D;
	Tue, 16 Apr 2024 03:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713239276; cv=fail; b=LX4dcy1qM4ftUxajtGAD7HXATzb3C1viEEMb/qBrerL7Fl/KQ4JmsdKIdFd1o9bAGhXc8YAFfQTVJ5QMTsxwbgooX/swn5RvmYoxWNn1x39u5aPTdqGMuDTC9CJ+5wHdnAV/CDTX2ZKfea7CFU/0/mhH3a3KhU+JgTFS+ev2840=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713239276; c=relaxed/simple;
	bh=EBYXNbFqDrq7DGMFyp9+kM0gYQ2iFJb+u2Z0s2IQMI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fW6tl6zZ9vta4Kn7QA1rKBWyhyJGGIo4h1kvc38uyF0eDGgPA45gVFzl00WeajImCN/MGdYrYvcudHCB8SeniMB5pf7qp9FZ/OzlzpbGNIXt70+5CPNDWGlfu9d9mfIsAQ9Pz0dqClCEMh3M2FFY6q+tJMlC3D/lDCJvmmVLwtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuS7ucZw; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713239275; x=1744775275;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EBYXNbFqDrq7DGMFyp9+kM0gYQ2iFJb+u2Z0s2IQMI4=;
  b=JuS7ucZw+6InGsUxCNWtWh1218kP6eZ2gc6zBMXMWRK6NvcVhbApr6aY
   XrQcHvRcRZtlvrTNN7e5ZuIqtwNtP43mvPFjZdgZOyykK4482unvAX1r9
   tF9OxwXKq0sGh1UagGJT1j9aFazguQPbvPlZpqSzXjd3prYyDcO4BbBq3
   6+ZeJ2ii/zGwe7VoTJUyW9i7ZL4YNVlSTOiMK3t7154y7YyFIcpJpTFCT
   ZIPwvBXYyhHoZSsBJavu/q0FrlfoMjHZKQ9VK7VHkdiTZl8dMEX6zoWrj
   a1P/3wEtuTHafPdJpyfIMTpDsdI054G7zrNpWuhb3KS/UcrCSZMbDwf5d
   Q==;
X-CSE-ConnectionGUID: fjCZrSaUTwu7MhlB1Ye4vQ==
X-CSE-MsgGUID: BJe18OSeTBiBpcXt9tJP+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="26170923"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="26170923"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 20:47:54 -0700
X-CSE-ConnectionGUID: 04qKRXp7Rpewi3cZN2y07w==
X-CSE-MsgGUID: ak7YSUSVS+6Mai7PbSAjVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22193975"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 20:47:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 20:47:53 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 20:47:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 20:47:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 20:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdEhkaVmVMYDF1mHAaZbZIsUSgNQ3dmSjwegiy8GhXM7dEGEKnO3Ydh2xlWAyELCdYBHuXmHT5rkjeDoMSiB7iKTkZ90Sw8XHaxTkpqAkZX0Oar9sOQm9NIAFZhBu+NI9RjCLFsrgaPNYOQUZcxoHrB0VvxKmyK/wWRTL8+CZVlsKyfL+KrWUbXBP6wEg7zxat7svsjzsoUVSt1nE0Zn0r5KELPVxSknLqQzIdmHHz1NdYFOv96SdwGI1LaylsuqrbCbLzvUsk3tZ6XxlcPa1GF6b9OaEBx6qzfDWh8WSuMluxHKUCDlHQTNGn+Oz9+JtcTl7zFsfCvd2gNDiOlp2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cy1G/t3Zo6Iqs/KT9pmcDkzy6i42fjF6EJWQkvfc3o8=;
 b=YnqVEmYofdVROeekFgDe94X9spCbnzbnWTyTf/7bYvWCjaN3w5us8394CioacLEYFOA2wl35eeSGO1gC35yBQceqaJDimvkDOSqyYNl+O+9wam5WSxvIqtQWcJB5Iz9zvy5i8PRz3f/a46EWY1EGxfm7BW+pp3HXgADA9UA4+cTWWFu73nCsyfvFf0i6J/hhiPPaKjYBV4rd0YwUW1jculx/LE/EK32EqC6CXw/tI9juTzpwu1A2uc6NLVQxOnh9C71aatOtb2WAIoO307ZxnNvYf5qpcZiQQpMd6DnVy2QU1Br5D8bkeU37wEorocSe52HnmK70UVeTAwrkC5qf4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6010.namprd11.prod.outlook.com (2603:10b6:208:371::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.28; Tue, 16 Apr
 2024 03:47:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 03:47:48 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, Lu Baolu
	<baolu.lu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>, "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 10/13] x86/irq: Extend checks for pending vectors to
 posted interrupts
Thread-Topic: [PATCH v2 10/13] x86/irq: Extend checks for pending vectors to
 posted interrupts
Thread-Index: AQHah6hgttNy4xVG0Emr3Eje1s1aQLFkZmJAgACXWICABVSIQA==
Date: Tue, 16 Apr 2024 03:47:48 +0000
Message-ID: <BN9PR11MB5276129A5784849F2D06104D8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-11-jacob.jun.pan@linux.intel.com>
	<BN9PR11MB5276215478903C50701D05498C042@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240412112331.5a3c1d18@jacob-builder>
In-Reply-To: <20240412112331.5a3c1d18@jacob-builder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6010:EE_
x-ms-office365-filtering-correlation-id: 567dbb34-a5d0-4ea1-fc73-08dc5dc7fbfd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cU3ss7HcUPCaguc1J46E3DgEoM7SKkk6J65IiYzH6RDdGfur73Qo4jJOlSiVnKQQpNsZN40QDSQyvSnvOG1SWaAnESb2sS0b/k4uOmg6jQVVeqH0I2/3H1SogjBevsvXBZiSwbZYjAiE65wW6v3Z8dQmCgqblX35wakhFfwTULzYZKUA7uohDpIDYBYH1HN7sGX0LwAzJrJ03Yzb1MVY1UEQ/XrVAdOoMF3JtHMB1QQhHzTgja+nDOYXxRCEfIE7Vov2AQ2phz74oSK4SjAR2q9NjqNGtO8r6reP5cL45rDPjJNgfNKcJEg5ZhwEtnE+wrA4+k3Fh8a8Cgmg9qQVKGA/UytNm79ZHA60+ea08xK4ZxQzFxMpND3Nf6S3ZOuu1y4PtanZgR0IJXc92jAm02BNBfObNrQBer8ARs3AChgSl2VKiR/OTn1gir4XV1Faw/7C0Zj7Lo3o9sCz56k+blVYFwpeb5Z2RpF1Bk3SKE1+uzQ1im+eYG8psAMHb0b6VAUzBJMYxXjY/60+XI/9PuKUXkNIbScR/H+ejqIg7kdQncUVu5sUOcqKv+PhLwcMSveM+Zmph/CGnFSfecA3Qm9md393eYJ+kpRohS5BQSPU99qY3xt4tKPBU8/uJOZzBDXEaW5ycGi9DxWiBVWwl1fdy2IN4mqiJyMgfsflU9hwuiUoLui3moUxJMHNHCfldvJ9UUUZ2eN2UbTIFAI17egEo++xzu4LMoBAi71p7lk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cPE49uNt0sfPmju6T15djiUPBzN9SMqDId845QGTJIfiNt8YWBI3it3CRnJZ?=
 =?us-ascii?Q?VpNyG/zYCgeItL/opzsXnbKi3rXmioP2VrLjHibjMQfzBLmqHa7OxQ5BHJfH?=
 =?us-ascii?Q?HuhK1AZ+QvdHkVS/ruq8KkivRQVaypWREmQpa9jCgHe7oregx6Oc3PDI/amE?=
 =?us-ascii?Q?/jk47UT5IQgKRSrwre0TP9NuEdUXRhy7tXfiY3wEnE5DeBMGZrjwMeAcjBnt?=
 =?us-ascii?Q?FUdMUgHLJrE+3QXT4nvv6CqD2PdFDmOvI0Gt7xTIJkHAMbU9kBsGwmrycxsy?=
 =?us-ascii?Q?nYfhqHTGrOf75lkyQ9ypaC+rNsbzPTIKByN4OzfeBQs6DypblIg8jeRU4wo1?=
 =?us-ascii?Q?RhNZZQzaP3sGr9/PoH+w+eKsj9YOhoKyGpiMn0FKWzb9QndDNivEpZ4HBc48?=
 =?us-ascii?Q?4Rj+KoQmR4Mvcs4oJByAZP56rFdVDTwoWj/t/KS2m/lRARayQ1QSCFNllbBQ?=
 =?us-ascii?Q?ZOi7fFbTaoe6dgMF7PhYZMQacFb/r6gKqF28Dw0v4lIBZd4WixX0bIo2O9/s?=
 =?us-ascii?Q?iv14LQcis8Ctdb0LpswUR9CkvLYSJfFwpP1z5GJGDPBMnSYlVLY3Ye15A/2c?=
 =?us-ascii?Q?oyFZAhkKXhFNwnuze3xNYu9HNHXpOfo8uafDIK2c3xOWcnpy3GnkVX9eRM5Q?=
 =?us-ascii?Q?ROfJdEgDxDrispZbf1RSoS2qmVPhWW+PkM+QDAlaOUAoXfhetYL2xr9aEGgt?=
 =?us-ascii?Q?IPq9rmXww77Lv+BlWaRlxVqWRHfnnDfCR3TD0+Hf6rBG4AqxiQ8iMoR1HPcl?=
 =?us-ascii?Q?3+G11EloRnr5+8lo81LHwrtbBL+V50uMZGBCKnwqu3/D0hOMbtKXLo70wMxX?=
 =?us-ascii?Q?G9ZCq/i5htuIKX04rrOgppgoj1QG6o8zv1yAUSrQnBzD5JBwVVJqgyB8q+f5?=
 =?us-ascii?Q?vvqG+3MNzOVp7+hnHfV5SpCwmpv0elQMXGV+vPQOWdEgqXGza2Vju4tsde6+?=
 =?us-ascii?Q?i5q7uStoGocEfZpydqs6W9QCCQev8GMvEhsUTEdnGnApSqJKGSy+JVnXTmkN?=
 =?us-ascii?Q?yUBqX5EdNC/0ZjDC14tIIEyiCg4DPRb4MK2WiXq7M1ufHwKYS5lSYtdxXFXr?=
 =?us-ascii?Q?34Vy2xtxHmb3FaK3YHk7e2lRcY+TMjwx8OOtNV9MnF8op0LtinNtBtWSbaW0?=
 =?us-ascii?Q?3sLsiWo3dghfsTi8beZYNzCi2HrNKLWu7DPUchfVeqSnCLmSIhfIo5Aosu+b?=
 =?us-ascii?Q?X/NlsLjd4ZCDh0oaJ3mWl4z31Avg5Wfwb6ZGlwCMusAHSMYYhlxiT+67okqG?=
 =?us-ascii?Q?MuGYuJVrqi1dG0/dOOFanTxRy3Q981owlAyWFN7jh/w6XjmSSjmp4LoaiUrf?=
 =?us-ascii?Q?0FlD6iUI6OdnZW73/4IDGKJ32n79/3Ev1R2kwaMnbOuULULaJCgSLMaaqXLH?=
 =?us-ascii?Q?+N4XoHzijN6QSQr+26PZbqxqV5pAfobntZaFnHpRf7sIZujsVDXHdveT+xK/?=
 =?us-ascii?Q?5CEbNo3srfY85b02uldEVJ47t+3B5L7/o0amRH2VSVSJJMMbZeLbjVISqSpD?=
 =?us-ascii?Q?HZpoRMNbzXicU0XQeB0DpoedxoTSg+Txy7vqTapYoWbE0LDpTCGmvEg++0x3?=
 =?us-ascii?Q?SqBbzSKbfwBChaAQTp/Nv2gfIwEmZ2g+h9Gxu8tG?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 567dbb34-a5d0-4ea1-fc73-08dc5dc7fbfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 03:47:48.6975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTHMJCqReRjpIrhvJYS7d2/TXv3a28bNmO0LAQRkB6tBLaOKKr8P5diOoadbwOjYcxIQHr8HVR6oC99RQ1F+kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6010
X-OriginatorOrg: intel.com

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Saturday, April 13, 2024 2:24 AM
>=20
> Hi Kevin,
>=20
> On Fri, 12 Apr 2024 09:25:57 +0000, "Tian, Kevin" <kevin.tian@intel.com>
> wrote:
>=20
> > > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Sent: Saturday, April 6, 2024 6:31 AM
> > >
> > > During interrupt affinity change, it is possible to have interrupts
> > > delivered to the old CPU after the affinity has changed to the new on=
e.
> > > To prevent lost interrupts, local APIC IRR is checked on the old CPU.
> > > Similar checks must be done for posted MSIs given the same reason.
> > >
> > > Consider the following scenario:
> > > 	Device		system agent		iommu
> > > 	memory CPU/LAPIC
> > > 1	FEEX_XXXX
> > > 2			Interrupt request
> > > 3						Fetch IRTE	->
> > > 4						->Atomic Swap
> > > PID.PIR(vec) Push to Global
> > > Observable(GO)
> > > 5						if (ON*)
> > > 	i						done;*
> >
> > there is a stray 'i'
> will fix, thanks
>=20
> >
> > > 						else
> > > 6							send a
> > > notification ->
> > >
> > > * ON: outstanding notification, 1 will suppress new notifications
> > >
> > > If the affinity change happens between 3 and 5 in IOMMU, the old CPU'=
s
> > > posted
> > > interrupt request (PIR) could have pending bit set for the vector bei=
ng
> > > moved.
> >
> > how could affinity change be possible in 3/4 when the cache line is
> > locked by IOMMU? Strictly speaking it's about a change after 4 and
> > before 6.
> SW can still perform affinity change on IRTE and do the flushing on IR
> cache after IOMMU fectched it (step 3). They are async events.
>=20
> In step 4, the atomic swap is on the PID cacheline, not IRTE.
>=20

yeah, I mixed IRTE with PID.

