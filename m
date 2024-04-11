Return-Path: <kvm+bounces-14225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A638A0A96
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 995D41C2162E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46A613E88A;
	Thu, 11 Apr 2024 07:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JujqDn5i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0CA13E40B;
	Thu, 11 Apr 2024 07:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712821960; cv=fail; b=m0RTlivMTI7bIzXfmRCZQrVfxOdovUIMAZRZnmZh2XwBZcdvL5lN7uWr+hpMha8am5a/WQ5hnm+vFD/66KYdwAtoEHzoM26VUpSFdaNOnmbG7W9rUP6tOdBJrUoyuq2/hNiQ5Jc9a6bV31cOSBMbAkoKpJvO6dJIUU5XDc0Bt4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712821960; c=relaxed/simple;
	bh=AbUADMaikP4p0EzbX9IFTtExtQwoN9vjdItrY449nQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MPvQ86x1d2OMTa8WDNrdwNgUI3mK0U1cJYAuiGNeeVBC5HgHzz42NUyOeIajWnugbD8yaPmF3EepMWmWIWFOJnT3t90hd4/XxZuqHy3JUrwKVic1d54rJBwQIDvwH7IBahYJVNaDgvLCtkn4TauqOPGAru6KMeo24pWgHykyQzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JujqDn5i; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712821959; x=1744357959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AbUADMaikP4p0EzbX9IFTtExtQwoN9vjdItrY449nQE=;
  b=JujqDn5iLJE/IeexbdBaQlESkzFiuZIy+SQjIoHmFzyd9mSft00XZRQG
   5B3Tvo6fZN+8p9RHuq5MduaGWBRjMvZ7cnVWMXvq3Ba11m+VXn44neU6E
   l9I4V5sNlwi1dfLI9HND8K8yHgGgSpwGMxtwOhtbkw5nSNMPsp25LpwRj
   IZvftF0uJZv3YrNK+LMwfyhGikBZvtRiEXmThRYgfrA7fW0ST53pMfOIR
   GJ55tZyll8eoWStIkiOnroKXxmeMtfw7Zqchc8yKOK73C0DvwNGD0n4/B
   KDKiXUU9tR2uhR/Gt3Jwt3IaQno16GMG4eEftwgMNJk01FJ/HbBdzWKFl
   g==;
X-CSE-ConnectionGUID: T5P9Lsp6S16FRuxvOYCHpQ==
X-CSE-MsgGUID: 44rXf55uTlmSwDCj2vEbFw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8325575"
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="8325575"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 00:52:37 -0700
X-CSE-ConnectionGUID: rfaUQE5zQZO1IzGGgZg9Cg==
X-CSE-MsgGUID: kvSIlUTeStmWRK5eqmrByw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="25589665"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 00:52:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 00:52:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 00:52:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 00:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhPvuVifrV3+x65wE8M3p2EebJ1hFMqw2oCL6vJLZbaK1yjGKCT+FejMfIaArU5YfclWV+t27kLFqivgzxNGRGDuSseTqo7+nV4vomvM4KQgjuWH9hMNFsJicrZOnvpuL/NQ0659E91rkJiX4RePA4SsSW7Wp1h9LmWiVDAwAjL7AjcOhDB069yHDOduX2mWoGsBPSr3azd5GgIqY0gZ11yDOBApkx7v3h5mz5kq02nuqUdkqsBcGbLj/9vCLRjuTBz48lIAeuF5e9qsjroAXz+GWQyByVKpKAKMXIIwxzMCLUAw29m+ss0pTYEwhhtR8INlI4aGUC0XLOLOTRT2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTC8Z68BVerooIZ5TtFaa94sS89qQXveC6/kcqVtrZc=;
 b=kDkn0mdrOoUjdDgZNe3ptkNIl+Zcih4Kd8sVELQEkoeFlrqW2wPllA/wl4fhCihuyIxkU84SG+wEUMHhwLAAYKlIGq84UUo3BIXS8xQ+dvYD2Nl7+TJLCnyfNrNfJHu83rwgyrolNFBSt7nRYpFSWNVjwt+g8GFx/t22A9VX7OCb4hsyHH+Kc0YXzXiqdkQLpO4gxo4i3UBt9717Exd2cPiBD9qC2//7YEAv94WlRIVDjqvE+NlGJGd31HkpSfIIrZ/tEO4VCNadZlXbwhUVSCWZ57kTPbhCMC42nkvgdyBW2fi/8XBu3Gj0RIp5D6X1X8zhIY/7+Izlffr7YQydQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7078.namprd11.prod.outlook.com (2603:10b6:303:219::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 11 Apr
 2024 07:52:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 07:52:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 08/13] x86/irq: Install posted MSI notification handler
Thread-Topic: [PATCH v2 08/13] x86/irq: Install posted MSI notification
 handler
Thread-Index: AQHah6hfZiCSRy/rT0igaUfC7YsDdrFiuYWA
Date: Thu, 11 Apr 2024 07:52:28 +0000
Message-ID: <BN9PR11MB5276C4932F6CFD217CC50AD78C052@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-9-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20240405223110.1609888-9-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7078:EE_
x-ms-office365-filtering-correlation-id: 197fd6fe-3abf-47b6-d986-08dc59fc55d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQGI1oKQfXX0eOEhwnfkUVsMXth/3uQsj1Y5vvDBEffGk2vCeMlxYfg6MdXVbcm6U4AVVY2H5miE+y3NqJmdvzKYDl+OUrRVmjy2wehTe3qbreyam0WhyRFJSI0CzxbMRDIRiIeCLCI3g0oiJc1fNNQCKYaGxRccCVfSfGQOHfZLkeo+leyWTEbpPJktCi9nOsAB2mLB4TR1sk/iqrjy0qmymdfSfbU8ybr3xgGrrYi8DnvPGl4MJv5S6RVkqgNjozqEIBZtmlBfvkbH6elsE7w0DNvyol3Wv51zJ003G87NM7ZF1MWeVKiPgwuKrNTv9apCqGpkJqztHKxEaXPXqvElPjvYozfVRc6/gZWlhvfBp0w7FFRJxbR+YjfjsQLgi6ZA5LumQMCULIlZi8FrclPBZctatxh2phOayeTuON8XOigjCJLaDytX44ChfuxtxAWJf9DxQWonpQL4XdZFYdZ0vQpHQq1Jzl4ud08t/nHkDOPUPS6pAGjGSoQiko4Lvd38jVKT81EKcDzPzUPrZrwOdTPA3RmPpWteEkqzEVUsQHdkkDQspKqiNgEOKi4E5BDECZWoyPpOqga1LPGP9hmA8OeXSG7hAWhUWhCnmhwgUz5ML6QLSXP9D0Hd8w/rvfpfNQFKPDnL3dt9Wz113qbYqhKwwkp9qHkgdK4aHq1hzJQY+3HrZDQUEsBGRbL4JScFi4Q6sT/ir6MQo/VPXYzi/UT7Nup8fd5qoQZgags=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6+FjnbMCa6UoRUR8XQfSH+u1nFykDLe/ghxthzn5EKq7qm/V06RkJxzOUTQ+?=
 =?us-ascii?Q?cXBRqE/lL0mZ3WSUp61bYZh2ykKRFkx2wr1wDc1IHFVvbrGk3rbZ17XWh+l2?=
 =?us-ascii?Q?19il2onVeYr9R+fnXunVmME5utCAL+PNY6a/kTr3g70P2R+LImkRdl+L6NSb?=
 =?us-ascii?Q?Nw+YHXImex6reSf5tGfQGdDEDvGbNTmJjeIlqeWvH83hwPrFE5DwMxHAs3HK?=
 =?us-ascii?Q?IzEw8Q+HTpY+ez5GWISGCZvltg1KakqzaEj1r5vzmlSa5uXwOt7tIxNjTLI2?=
 =?us-ascii?Q?gEOislJ1wmS99EigD11y2pVv/u6wFUfuKF5xlJo5vrpwJ+J1EIX73QUlwnWP?=
 =?us-ascii?Q?rwlShikXAhwM8z0hr4QbFJcJW/DxZmp9FKFQnhWwZSyzXGcyzUBXkaenVMRz?=
 =?us-ascii?Q?1yHs8nIiA8rv/mu3hrwv6DR6XXDFKLqQpBwgcjrBcI1Yv2IXw1Iid8i0GRWO?=
 =?us-ascii?Q?I1QfTYS5ddg3PljvtXW9mdK/Oi5XoajXRgf+rjxcXgp3nE8mXMpFQryuFgRH?=
 =?us-ascii?Q?x8O8T9x3V/4VDek6DR+R0aL+wRbBLyP5qUxHo5BghKAIPg7KCXTaDNdHuKPQ?=
 =?us-ascii?Q?dvCZWrJ1EbzpcTh2n/6YzSB2bNJDWnjBA68ewHjpRtHYXVM6OYWJXMfcpEk9?=
 =?us-ascii?Q?M1rqesClPTGzdMNNYJgYk3B4keneX2wxCOXlMfwZvGTgN6a/o/xf5YG0HkWy?=
 =?us-ascii?Q?STj4v6lePV9tUYH1DzzxtOiAyyvkB7f74t5e1y+/DVr5hEw7YKUa1CcAcXdV?=
 =?us-ascii?Q?RK2Ig5XOvLHAAc3CLdYXD7/9x8d6pSa8Ua/lrksdGmn02wMPo2bTstGWOSKx?=
 =?us-ascii?Q?pDAsj6FaqJuipgeyCtfDFQ3EckY0I8tl5RQS+3xThfI7F79aRHn/UFWyDlN/?=
 =?us-ascii?Q?ZG4QLs86kc1ipxtN191uzYwi6JqjBcybct1xKv3Y1RtjKesJTkz1kt39qMme?=
 =?us-ascii?Q?Gm7x7txhL6buTMBt1cEoa37dcAQ6dlkARx5Q6JME7XKTAxkXWCALL9wqvR8z?=
 =?us-ascii?Q?H4ck2tr57gqnCDuTqspMKhgRp+rohVqOGhDctaOW7R1vWWWSr1XDBcRvMOr2?=
 =?us-ascii?Q?nOavaUou7g2eSt44iHpuWxWlzeIBVOHoqDDyIa1CqbujDelLlUGDnZ4aeBLn?=
 =?us-ascii?Q?VbTV2p4Ja+qxZYGB3GW7V9AgR2KVtLlRrbx59i0APohYe64zIXLBo5UfhcFV?=
 =?us-ascii?Q?xz1GY5ULlTxluOdVWyADrDyO06XnFxd5Passr852pwHhGc86/NGVXLeYi0+/?=
 =?us-ascii?Q?c/jL1oF66D9KIyXTUI6AlfHtA94Nk18cH6iKXL9g5B4yz4eJxacOvKhz9Fre?=
 =?us-ascii?Q?DC/CZM2X7x0NvrC6vX7kZxvq5agVchtpCXKsyBlsiRl4xZyx5d9cuV7Zb+FO?=
 =?us-ascii?Q?YHPVmkfOtjAp2UiA2jyxAIQfwqc1aR0Av77AaIGVnK0iNfxvwiKolPslDiou?=
 =?us-ascii?Q?iKWWN5iLJHKcf2rXZd0Dqzyx7Q++Yi3/aU1HMt0/5SrVMw/mwNqyLGuMjAy3?=
 =?us-ascii?Q?cQxM2gbJ8lspsNaAWAzFFqVaOgrHIPrhhYLbUkigUjFNrRqW2lmXLp21Vn2A?=
 =?us-ascii?Q?8qByeSc2uTJYGzILAlDEwtVJ4azD3GsjGnm4GtdQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 197fd6fe-3abf-47b6-d986-08dc59fc55d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 07:52:28.5993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUW/szwC1ouo2qhdTe3rkQj5pnAPqFuuyg1zPaZ9F+EbQtvUllLlpIy6uhGFAfPQqkSyJk9MHNDZlKqMCN49MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7078
X-OriginatorOrg: intel.com

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Saturday, April 6, 2024 6:31 AM
>=20
> +
> +/*
> + * De-multiplexing posted interrupts is on the performance path, the cod=
e
> + * below is written to optimize the cache performance based on the
> following
> + * considerations:
> + * 1.Posted interrupt descriptor (PID) fits in a cache line that is freq=
uently
> + *   accessed by both CPU and IOMMU.
> + * 2.During posted MSI processing, the CPU needs to do 64-bit read and
> xchg
> + *   for checking and clearing posted interrupt request (PIR), a 256 bit=
 field
> + *   within the PID.
> + * 3.On the other side, the IOMMU does atomic swaps of the entire PID
> cache
> + *   line when posting interrupts and setting control bits.
> + * 4.The CPU can access the cache line a magnitude faster than the IOMMU=
.
> + * 5.Each time the IOMMU does interrupt posting to the PIR will evict th=
e
> PID
> + *   cache line. The cache line states after each operation are as follo=
ws:
> + *   CPU		IOMMU			PID Cache line state
> + *   ---------------------------------------------------------------
> + *...read64					exclusive
> + *...lock xchg64				modified
> + *...			post/atomic swap	invalid
> + *...-------------------------------------------------------------
> + *

According to VT-d spec: 5.2.3 Interrupt-Posting Hardware Operation:

"
- Read contents of the Posted Interrupt Descriptor, claiming exclusive
  ownership of its hosting cache-line.
  ...
- Modify the following descriptor field values atomically:
  ...
- Promote the cache-line to be globally observable, so that the modificatio=
ns
  are visible to other caching agents. Hardware may write-back the cache-li=
ne
  anytime after this step.
"

sounds that the PID cache line is not evicted after IOMMU posting?

