Return-Path: <kvm+bounces-11354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D93875E48
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29785B209FF
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CD54EB55;
	Fri,  8 Mar 2024 07:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQ3DFYdy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734474EB30;
	Fri,  8 Mar 2024 07:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882076; cv=fail; b=Wijfr9ujMO3VqijZwbJJw9VooZhccqzkCbs+uKj8UUPPWFKmwX5iAud0RaMR6B0ARZmgoshcUXeYZHBzZwA+ZP+fyCAcQPnxJGpiv4e/GzvbnhYlK54UQkiSNVvCmLjdSs+5G3Ud8W8k8vGDLHVaW8by8HMfq+ny2RvKttsE+AY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882076; c=relaxed/simple;
	bh=KcDV9cBVhl/lJxr8ZNxRF8eajj/h02dqva1Miu2BMA4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bw2/vfQm55VMZtah19O6wL6GKhNGlrsMU60Qbn7KLu23sBpX4mMo3jjJyb2RuRTqd7k/kzi+ODGYDzBAb4J5LT8lGLGqxeDlUEJzusbF04N9wJmU1KcND77/ayOEOVWi7fiW/sNZ2MjgoBRm37Pg7m4Ai/DIQbquTQbHla8z74Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQ3DFYdy; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709882075; x=1741418075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KcDV9cBVhl/lJxr8ZNxRF8eajj/h02dqva1Miu2BMA4=;
  b=FQ3DFYdy29Zeu47F7C88/yB50wMpm1e9URCzweCRgkK0uIe6JSlGINpd
   lT9MFHmWC1V97UZwM+nlfReOzooq5UTiByHRCzf43k4esiS2ka+aNc5WE
   M+Pi9xevenQ/tJ0Iz5dhRmpGCWvNlH8q9R3f6xKbfKwWujSPe5PAMm7vM
   c+6ZU7UtXJ1I+DQCHKBJrRTPCo6P7Ng+x4+bWGs1HguqK1866BHu3G7Pj
   iRIcFodw25ySozYpO8z5r0qkoMXDX5iK0Mdu+XTjqEpAuwbfQGmFWvIqS
   JxIp6xGBbpNeLxOOztb4PIFttEHw3eUSn0GXx2sqLLNqrRSGq5gPJRxAp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="8410938"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="8410938"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:14:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10426502"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 23:14:34 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:14:33 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 23:14:33 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 23:14:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S44PJi7XaLIcdJAKD44rq/w0juRSisvRbCw184jY6cxU+xG8al6eoYYzoZ80i6rAl+ytbPDWr3k/MgK+ubbrpKX+ymi15mAQq5gjIii5+nmB3OevIIkYhIqZbyro2soJe1CP60kz1sw6Mvps7YxbTRPdBRYbf34ITB5R8EaQeut9x+C1RiMwwbIJifTRGbh5uaSumgoBgtVd2/YvHQbINOXjLLbG7Gn7TyedKQXaNLASXrVjJap3rUo1B4QqjoztddM8E5vmsI9rkHY38TGaMdHsnU7g8zEH0KvvMozETEsg8J4GBZ96qygKwPPNUrazI9Cd7HXRqZwUJ8yh84H2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wc1wnNJDRllvIYnxSfH+TdH/Jax3uDrv8IXUdX33bzw=;
 b=h5CVChWnPJwijt7tjwIl1qzLP+IDmg9y36Dr+UxRggYACZAerRMJRKPSMu4GYJE5U26wc9VxtLEQiahnBz0E7cQhJzhQ58PfqW6Nwg7EozVe/XvbLtzYiDQr3KTS3JegIftliJ/dHc+ND8a5NFC0JkHqGKfn/if5iAODUREc2la2BwAIRLEKGuVNdpdu5yR50QlsEiaBUs/1ZlNgwyr8jB22ewTEPJAVChSiaLtsKAyDp6G5bZlwKdyf19Y45gjUO9aG+/WkLS5IBy8doKchcZ+YeM8aJYAA3cfu9JsuqbAErsCKWUvqXkPMF97kobxYcscabfRZTb2vePb8jeozfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5274.namprd11.prod.outlook.com (2603:10b6:408:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 07:14:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 07:14:31 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/7] vfio/pci: Create persistent INTx handler
Thread-Topic: [PATCH 4/7] vfio/pci: Create persistent INTx handler
Thread-Index: AQHacAtpqLYEq0v3LUa1TvP7mKsB87Etb6lA
Date: Fri, 8 Mar 2024 07:14:31 +0000
Message-ID: <BN9PR11MB52762A02AC3802CB2D550B8B8C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-5-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-5-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5274:EE_
x-ms-office365-filtering-correlation-id: 8a5e5621-6c99-48fe-e943-08dc3f3f6684
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9nbOdKh/+TVUsMlh8ntqYXVKr8y94xvQoeC4k3bg42dj098reOYKq8q1hueLDoO7+aBDITs4u3BZJIYLlsNL0+vTs4OBRg+uXHpLLCfbnTEKrnso/4sqdZx2xTpuM6uYnVbJtFglCPeMdQV6b1dzr2hiPlJ/6PsoS9YDb6oIMNdz9IPRo3DFDdSwLW8LSJaGDCXI2zm/EtK5zUfQJT674Dkt//huWpsXhU3Hex/+23Sk5OReQkzpfck43IECRrCDzg/QI5H0jQIKGG5ePZxC8SfUUcL/4uwPiU+V0SFpt6EHK4DOuCphT5grV5dB4HwcLgXd6L7EONxF1ukc8xz766vxGuSnTkZQz3HnB9PCIrhIm/0zcBUwalHeqVSeeRiWBdIzzOYBjt/f1GRBVcwoKwdSsnocJnO9oQpr3O/TKHYmHOysTeuQLFCTnhf1L2NN08ctJ9FeRfi/R9NkYx5R0S50EihaB/6QJVF6gaxxo0S/vPz3gdZpQPhRcBSevq3Hrmwanq6rqwyIMYMCCbZHG8QF+PasLlPEbugxMxpzBW1SFmBgy2uc+sF3jqUlOoajmKEadh6CEOqvzvXS9K4YNSyQFJ/VVyEZtmE5bEwSgkOMez/2qUtB9xPiwcRDNPy+52cEcEjpYcMOA3Vh218j8Awp7ZXvdNqr9hIEnkbEcurnYkQOtH9EeC8oiSCuHHxcpumswhWMax23uZk+tWH6sN3eP9L8RXWSH6AfzIihVs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8dr6kPE4TDOSaHgF9Zu/jA6x6KKgxFcj/roNQ5l7YOQcNc+jP2UR620zVLJF?=
 =?us-ascii?Q?UWbCCsBFtLYlyDBrqZZ1aAlHFUW3Y7LEeDfzpBTOh1aUiEsa7P2Ival5llOB?=
 =?us-ascii?Q?c+KQoq3zDY0Y6C+NJwL4MmAfRDPmE+Sm/IFcOSeSyEM05PFHcHj0CuIQ9lux?=
 =?us-ascii?Q?COHFrDlI022RzerG6/Q7x4sDH8+Zs4LQ1JtDC03fI5X+L9NMJGs1E/yLsOy0?=
 =?us-ascii?Q?RU3crpskc9bzyw62Cc86joRB/3JdgPmAYlf9Ix8IAY884qzTZ5kzdUJr3sU7?=
 =?us-ascii?Q?D0+JzuBf4S+T8W9jA55Og9Th8k+pgh4hXMIPShUkF+gduSH/QB6lYxuTUUsX?=
 =?us-ascii?Q?G5K0GtRdyN6ZVdZnV3U06ZeRlhlMMHSSkx9qqvVxSOs78YTjxZyj0PFEqxtd?=
 =?us-ascii?Q?a3ZqewRCMBzZ94WXAF/Ig2TpD1m0LsmkDPo7nIT6CefOG85qofW1zENfn7fW?=
 =?us-ascii?Q?dtfpcyv8lzW2j1nOZTuBdk1KloPHyTU4PhQ1bxUIPtnT66iHQUjjuzmZtCAw?=
 =?us-ascii?Q?cG2UnGnenyXGSAtwdOX0FQvE4dgYRAU3Hjc6zcIw7wLNbK7Orh/c4UC5BBsQ?=
 =?us-ascii?Q?FkB5eo7fiS7AVcxk0pChUCjcIaq9F4G7DFrRWpfaH1hycLa7AvdrhidbSbVb?=
 =?us-ascii?Q?0XUwdXHEwRvfc50OdDJhwoU8UhRCIqrrVxY4bLn3taIqnc1kzQj0ycup3gBC?=
 =?us-ascii?Q?Q3ImgWO4AzRARb5I0BVjtaU0hNfygeY0yCnwMRkW+s1T74axhCyJqihyLrIx?=
 =?us-ascii?Q?nu1aikwy0hvGyspAPeWx8CkJWsaUO+mqxCBE23fW82KtkS9g4h1F6N92plw8?=
 =?us-ascii?Q?WwmmAUFBmdErFu5LToonCCJ2kyQ6GFGz32kpRhzcSChI0tzCi+PDsQxp9I7J?=
 =?us-ascii?Q?yZ+mgHKkn1+pitL2dFwAkxAf+dgd3Qlcm+NoBfkzhxa3N5vbRir0DaVpe1/f?=
 =?us-ascii?Q?ZGdoHWWaFF/G5jBYym+mvXil0k0NN6vNFEwd1EYN+gc+eFKaWSWfhAMRuuqn?=
 =?us-ascii?Q?vn9X9jeurMBb8hTPNMLBOlkVAhQRkkw5cSZ2MquaMF3JKf/LtrMbNR126PTT?=
 =?us-ascii?Q?XAd/8Ir6xmpjWoyy+zQuPoLHOQ8JxISUn/Ochep6KfMTPPjiOaBe9yqrTuJT?=
 =?us-ascii?Q?aSUuBRRxn/d6cZAZx/jJfKB80qW/anzUcCm4kf0LRl9CKi1tX8VOg6j8D+DU?=
 =?us-ascii?Q?Iwiy34JB3/3RETSnrtj5U+TtNzYFs4lhKFtU88bX0jjRyxW/X7kuYOmYYrLV?=
 =?us-ascii?Q?tshhZGbEUN7C4UnM+TWIbkTvYyAc2IVe1kz4U3j5/vdj8zBgRm5v1hCF73fo?=
 =?us-ascii?Q?3zkkQ4+jcehF4LVYZ+v/Qz4nkHa/Q0u2FpLaHpYPSOlQWBXi2uokZRZhVlHY?=
 =?us-ascii?Q?vDc8i1Udfge5385XHtO5fQBmFs71E/dvcEfwPq8oPg5NLSxlB7dI98fBYkgb?=
 =?us-ascii?Q?lEOIuEoBWqnWERLUJMTs7oIQ/m9ZyTXmdf7/bekdq1/nTD5LnJpq8nHSHMcK?=
 =?us-ascii?Q?OjA19JARRs+eDvWlwmBFNaGTXU1qoJi7Ocob6xS9yedjIPropbHac95bXC4m?=
 =?us-ascii?Q?SfFHmBF34mhuFqxzBa8fmmXtyoCkEm+wtUqTUhyE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a5e5621-6c99-48fe-e943-08dc3f3f6684
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 07:14:31.4611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mfJfrItGzSCPxQzphTmOeMo5ZizGqx3UoUxV0SppKUDGTaaBs9QC41AtiBZ7d5VEGqdl+KsS8AkxV22SwNBckg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5274
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 7, 2024 5:15 AM
>=20
> A vulnerability exists where the eventfd for INTx signaling can be
> deconfigured, which unregisters the IRQ handler but still allows
> eventfds to be signaled with a NULL context through the SET_IRQS ioctl
> or through unmask irqfd if the device interrupt is pending.
>=20
> Ideally this could be solved with some additional locking; the igate
> mutex serializes the ioctl and config space accesses, and the interrupt
> handler is unregistered relative to the trigger, but the irqfd path
> runs asynchronous to those.  The igate mutex cannot be acquired from the
> atomic context of the eventfd wake function.  Disabling the irqfd
> relative to the eventfd registration is potentially incompatible with
> existing userspace.
>=20
> As a result, the solution implemented here moves configuration of the
> INTx interrupt handler to track the lifetime of the INTx context object
> and irq_type configuration, rather than registration of a particular
> trigger eventfd.  Synchronization is added between the ioctl path and
> eventfd_signal() wrapper such that the eventfd trigger can be
> dynamically updated relative to in-flight interrupts or irqfd callbacks.
>=20
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

