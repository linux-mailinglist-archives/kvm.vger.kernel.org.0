Return-Path: <kvm+bounces-10029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F26E868ABD
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A0B9B25AF0
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D25D62177;
	Tue, 27 Feb 2024 08:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTALnUV+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BDE612C5;
	Tue, 27 Feb 2024 08:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709022422; cv=fail; b=nDQPGuNMVFfmxj1jN4PdjioNfSh0/kb9eyZLakoL4Qvx4mgnHhrJnKx26mM9orAf81mmLJ1wTbeNDTVWLfjXlp+GvvcmcNIQVMhTY10yBC61u2DSNOsCTrReu2NeAjqBgqbSFN8G43QprDiTtA/ctlBt4ruCIpsIX/Cl01ZUzLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709022422; c=relaxed/simple;
	bh=lXcKkzo/Y2x/2MI77oGK3GnMp645PebW2uMlwYtFq9Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qqGy39kM8UaXzRFHqJ+z9WKdXpK+m6vbkJzvbFCaUyPNaR7WiWKN45mNSz6BRLmPhk4dC0cYtcQQdV7lF54wOg7UFVB+triVm8Jsc5SHJEdrBYnGyyJnoIwDM7pkN8GCjJiPSERSQnHuoEWKRnOO2piNWm2b+TN9bNb228kVvkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTALnUV+; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709022421; x=1740558421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lXcKkzo/Y2x/2MI77oGK3GnMp645PebW2uMlwYtFq9Q=;
  b=JTALnUV+qFeMtBGTv5LuihA1altuB8HEjEr5h78+iv2LbXuYWCGf9//6
   9FHCL9lYe4ThiJNDQf4TDqng+Z8lglhfbQaMNfk79QWevQdpGHOLpiNwx
   64VCHz1S4hsLMkgJmDE+lud5Fr9U/2uTFWPckvts86QppNZGiZVcn0NuX
   3cTsPiuKE3CdnromD+5tu/RDfUPmKIRPhtua/5a3InhfLA68q78wNqXf9
   vx7dRDYObfywbWuvtx4YCBjZXaXi1gEYUKAOlXyyyp0P8/N5sUTYxtvm2
   dx3P6LhWF/N2dJU1JO5w4GXdMeRwNLa5Eg4AXAKmO3NXL1n8ISG0t9mhv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3510520"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="3510520"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 00:27:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="11542223"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Feb 2024 00:26:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 00:26:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 27 Feb 2024 00:26:59 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 00:26:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AReUoNYTzN6B60lnive0lfH8TIRKflvvXfjZaBQjZhhvGsSWjK3Kf9oF3C3em+btSQZYAkfZXG77ePmbc2216bPeYf3YkGgF6S4rRyZRRvZpdKOoGEzb0hYP6Vt2o9aGVgOiMxmpRD9EY/EP8WEIEHG1+GZgaacO+e8tX9d8B+Id4dfv6eLq7ABPuvgEDh2VT7SViO6HnbeeT2beumK2KswXTgdau91HrMhEn6MF0XK3GPJ/3q/dFc5Mv6YrN0+GAfwM09b/qqzITVL1EKVAsJ8EU9Cs5VXF98IluJPjFeuGwGNWypioR2kk7E2GRtl1jVJQFz8cISc2innfXYYrcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXcKkzo/Y2x/2MI77oGK3GnMp645PebW2uMlwYtFq9Q=;
 b=JGOxIcWjIi9NWWCu87TarYcmuN7Zise4O4qKUVGTLjwSpQZaRlTWRlwT4uWeTLdmkJIYXqgDI079P09URddsXO8wqQsG1I+pH913hGXwyMxR9lW08l78mLF/7iLVjIRrL+HwjEddC6w/asHAuhGJi+9IhQJaX24xPT+pJUWRXVyJeAWqQYgpKgzS4GuWVq5pKzpiDxVjAOfvVu7Pdv4T89Z9fsIgVH0u3eMspxbHLfJ65UBeO/AhwG7r3n2IN3j1+1NeefnakS4hSqot2Y35BTTEEk/C4hgHtmRLcWZd9ZbkVZ8A6rrf3iExP6m1QQYZyQChiXbEPOwRcNPw1I57Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7326.namprd11.prod.outlook.com (2603:10b6:8:106::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.22; Tue, 27 Feb
 2024 08:26:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80%7]) with mapi id 15.20.7339.024; Tue, 27 Feb 2024
 08:26:56 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: RE: [PATCH] MAINTAINERS: Re-alphabetize VFIO
Thread-Topic: [PATCH] MAINTAINERS: Re-alphabetize VFIO
Thread-Index: AQHaWI7QWpTYXQ6UkU6Dx2WHlj8GvbEd/C1A
Date: Tue, 27 Feb 2024 08:26:56 +0000
Message-ID: <BN9PR11MB5276436E2BE43EDD9409AE738C592@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240205235427.2103714-1-alex.williamson@redhat.com>
In-Reply-To: <20240205235427.2103714-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7326:EE_
x-ms-office365-filtering-correlation-id: 84c05632-a380-4696-bc0c-08dc376ddc23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qWAB/ryz+3BAAQMhkZqaoZ8c6n3mtxsvYaxTZ/kX60EN8NUF0fML5BcEldoNLz7yIrwP12Qfqetf3LtSeFgjWVC5vfBr6xoCO/2enfhFvQdyuwH0sEu3Fuh6RZBb3fdaEia35bVhfkVYEF1uAGWCr+A5Y6Fu6L++5InzWE3Gn98vo4kq3Dn0bE+zgfBWjOo+i4TTqdtkN1en6lJyNuo1tbF6wo2P5sfgcYXKf/iaFGBKOrR2v2N9IqJMqQ680pY5GHBUC/7PDtpQrFLXShddDcxAkcYfvwg1H/0MGobKvnZQbJlHtwBlFZXF1OEFkRi59APhnvtnc9+T+oYHmbNEvE9/aKEDz7cuLhfulAK+0XwMwno2tn6biHkVF860QAlI71QiUcJhG7PiYYBie9KtDW/czGEUY87fTM9TtRfe9aUPkVI8WYfTwP3MHKFyb9qD1bNVf8BN/ES5peeH9gh/Bqrv9jMfwUcjTc0pIpeZdUPDGTcRkDQRQJWQ6w86TTbe0295ycINYFuo5q7ysoOCu4uuGPIucV6Yao4yIR1VrDW6wKc3/faH0mc5IcD1K2uvT7w6izVodtICQqth/60f0Iy3lYiHCxf0aVlnSB120SBlIeCN1kuIMC8uBIHTDFNN4UbwZIqo5jYWr4UTlKmy60gPl1SjEin02Uv79fouUWp0AktUPYtm4x52evhshWoIpvNFwGGULIaou+f2xk/QUI1V/wwmbdp80VxUqJVBL7w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yFE1R9shklUhmbkWT0/xxz8nT9c5yTxvnB1Qj8e/A9t6n+D7vZTKZ/BXHXC6?=
 =?us-ascii?Q?EPUeYnEjDRwR3ZXqz1MVuioMebren8f1GRnY2IM/bLlfnEXp0aDhwptDy/bl?=
 =?us-ascii?Q?vQT2RgcXoBLirM9TW6cH27Dl5Wl7Bc1i+cufKmPWYX0RRdjkKO+cKZvZRQOf?=
 =?us-ascii?Q?VVosRv8DWMjFX8aBvNQ5f3C4OJIKTPwaJqvjAM+4EARhxwG10ZH1xP9WiVQ5?=
 =?us-ascii?Q?7Id34puYRxs2pX/dK9d8bG345T+pGwmOITjbOUFbvminGHxVi0xzPtlcK/gF?=
 =?us-ascii?Q?0O3FijoSfLaUeQBTe/yJdwV8Np4UWHV7RiO53WboI+BwiLq16n7lbAe88jLZ?=
 =?us-ascii?Q?wTqJvRJw8V5/X3PD4SeZakGsbbEjdt25mcEJxis/EEJsPEg5QJOcfZydvkiA?=
 =?us-ascii?Q?ea+VtXTLfczbYtaU/Gd6AnQqM+vEGU0Zl6h5nFjFLweZ9IJYCoYCi4Nyd0ge?=
 =?us-ascii?Q?V8w6UWlksqmbnXzrUs++z0dE7duUmew9nQqZd917huwacpZjc5xs89AfJGr3?=
 =?us-ascii?Q?29jPdSSI1rpt/JlJ+L3RCM51b+Lnepl3E4v/0Kh/So1GXTeCH6eT0Fdj8JQW?=
 =?us-ascii?Q?PiTTC7Sb5n22qEE5w54/CDGS84+6vnR7X64yolSIEmKeFLfmN0JBOG+1pgeM?=
 =?us-ascii?Q?qGQKlvl3Rj9w36JFsqmPfKLaqW/26cYRw3LfUWQ0+K5Ku1DqOCSe3DxT0/5K?=
 =?us-ascii?Q?Er8qdyPbYhZLf2d4tERwJmLAY8cGMyTY/pVXgpoXeuFWy2pmo4lXU2dpnM0r?=
 =?us-ascii?Q?d6/FdeNpfVq6pMNfls+6K9QjTjvrXzOgKZBZ4QjQvsUs8APAAcc+hC9+juk9?=
 =?us-ascii?Q?/nDWO/DLluLXH2bz+6CJyUuSiND4WFf2g/RlXlH2y/ifOC4kP3C4vN7eIPNk?=
 =?us-ascii?Q?fGhB3AO7Y7yX1bzmwnotwWRoNrickAwt6h4JNmP484+FpSfnX1+8t9VYhLJD?=
 =?us-ascii?Q?lN6fA7fx+fohXYsgomgPC0qO/Vs2A0hoXvuZC2ylVmCBqy12URFR6wIK4rFH?=
 =?us-ascii?Q?OaeYRpnaOLr4ZRWevsdFz0rGXEz7zJYDwOdUI727ft5mePbv7Rux+sC2L+8E?=
 =?us-ascii?Q?DKWvCbeo8vLVGjghsNwZwGCmJK0RhVJP24/FvzssaGES0HurQzKvL1YqOO79?=
 =?us-ascii?Q?puSUME0mYgHwNtX/q4mQj1U4+4o7DrluVyZ7Z9FcjemIHVoPbO0W5PQ90zm1?=
 =?us-ascii?Q?LQDWdr4x6VZ1CQIlGTueX3bv6AgD8hzmIFTe5ndkhn0BReldr0So0E8iTvUY?=
 =?us-ascii?Q?r+2WeZH/tZdhu8fl40FiQRWoQ0Sk7SIGEfgWE+m5jKLg1zcWGIj7eTcYh92H?=
 =?us-ascii?Q?eyhWLaJbJ3RRUttUknXApTEH4L5mxWWXlLtW1Sk2Ok6re2G5XEoKsJlDF3WE?=
 =?us-ascii?Q?mhWrleiSHM4bdpV5e1VtuNCKPqrSbipl7F/3psNS1XGx9iItPM1N5lgoj4nU?=
 =?us-ascii?Q?LKQjBRTUS7BjruX6giP10SSTKlJOUw3vtXbwDR1C0YmFfQ45x1C0L8RqvTNg?=
 =?us-ascii?Q?EaWFPK8I5MaTfqqN+TqmCl4FNfHWWacMDKGI7FagJiXlIam4elOSxM9kqiZA?=
 =?us-ascii?Q?uaT1VkBiWd3S8++9P4adSyzou/ZjQoOwsZdAJkxi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c05632-a380-4696-bc0c-08dc376ddc23
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2024 08:26:56.3935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iWZXWYTjSk9AnNugzDy39wFm9rAU8uI1MsaqTRQjH+VASsl9i1oaegL+z5IQUwv2hutYjSFmAeJx1bZ4fw3TUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7326
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, February 6, 2024 7:54 AM
>=20
> The vfio-pci virtio variant entry slipped in out of order.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

