Return-Path: <kvm+bounces-11274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC33874999
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A5BE1C21EFD
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E826663413;
	Thu,  7 Mar 2024 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kg+BdGho"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501B63A8E4;
	Thu,  7 Mar 2024 08:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709800130; cv=fail; b=bym4O/gbYcMyz2pEy77CHChfnADwDVN9aInGDK0FBx3/+oygLSw7Gne2+ps91Bu6IKtn0uAxvps8eSjJ7ceY22ZSgrE1Lys79Omt6zzvVRWlp6oXnMQXmQtH14dkUEq2diSjLTe7mQMb4Q+435OuLfS77FFiBm7YFwMR4FYoSeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709800130; c=relaxed/simple;
	bh=BEMJR5n/0cYg6dKLi4w4MH8dHeOhAhdfpRC4oDRmyl0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AUrmO3LwrWP42oHwWsRxYxXpW1kVRtpTnQprxmuYU2cQVwUHYxt5TlW+/YPPy0+xhb7NQRTLRFBL/VAMTYp3Hm3SRRxmf9xUFPwmz6DJJCpstJkPSy56SccoCJ2q1lfDs1z5+ND0jraD5LBqlwEGlK9bpwxHFY/7iAqY60rlt+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kg+BdGho; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709800128; x=1741336128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BEMJR5n/0cYg6dKLi4w4MH8dHeOhAhdfpRC4oDRmyl0=;
  b=kg+BdGho64vqKx/EnESHSrDGsA0XGWwtX+jWe+po8y1n7Mhd+0fVDvCg
   iB5GA8E/n5zPnXEYzFDY331gL6h8yjXncJzCWDmFGmOngqNA4K/LswLnH
   QcpcnahnXt9q9OqZZdI1AeaHkoF7qnT7gYPxcCVWzrQZ6Aj3YGUuVRgeo
   zfVs75qe1Vr/A74qzN8nQeJjrXCLQR2S2SWJX1aYlRMHom6SsTTsgpRfg
   XJle5mokkeoHvl/UscOunjJ6ahS6E/wDT4Xps1HAsZlG5+U9hH66CUEba
   WGBUFRGxfE9+IcNmSE2PfPtafMEMgh94jPv5uIb4riVZTK5uzVfjUOWJA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="26931102"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="26931102"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 00:28:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="10465648"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 00:28:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:28:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:28:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 00:28:47 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 00:28:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVoyfVlky0OQYawP7dDcdI4FTDRG6eWTr+viZQ9d9zgQi1rawZmxiL11vS3zMPtYAVgz3ictgh4lps/n3zuhYsLY4MbuLFPevgq1gVId6+xAO9FTcHqg+XI5BPzBXtGpD1mjESsqFBQCT10x7r3XuA0FCV2jxK14bqmnYW3lNtpQPSxT3aJsuZLL5WaRtYq1L7MfS8qgA/sxJBzC4JoRuuWZBT5vt2Ph0HggtcpBGLPEpkigKZiMT0CBKLEjisRnPY08JWMvB+YcRSdGAQv6URU/U4/evYGw8yeSZzdYhBUkT7DkO0tcczp5c03BDEKGNd9tTE+LZd6xLcNqECTa1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ol9c7h+CQ76nfINcj3WDDbb1aBo4FZsdTKJ5TYUAFLw=;
 b=KWkKk5pVYs7RhCIJ8pWRQScJdFKF7N4qGFUdggF1/wVqoul0FVpwwQPeeXqRMkHJMGDVicpPRtAVvC0GZsw3YCF/FNOtI8JZlr/SWRnFvLpoGxFsciXXw1lv2fXT6CTRSRuS5QHNxOfNc5YgrSulN4EeKZyo8ZlgmcPu44dh6Rc1RYiTkVdH0bkr+M0AFo/4Tbe5DQbMGam7t4zXeYD9u6zIDKyeutpjOfGn81VVp43iTjSjYuL82eWgRwuvYuynazupdEjiX+DcHsuaA6F9tqk6huSxMHBq4IYEP6Laxpgbo21Dc4mdzJ79vhn+4PkwFLX8ehwfTIG0JJjQoZLyQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DM4PR11MB6095.namprd11.prod.outlook.com (2603:10b6:8:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Thu, 7 Mar
 2024 08:28:45 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01%4]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 08:28:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Topic: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Index: AQHacAtu1xn5Hoku+0au9dqEK9o17bEr8fng
Date: Thu, 7 Mar 2024 08:28:45 +0000
Message-ID: <BL1PR11MB52711AF96C93A7C2B70FE12D8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-2-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-2-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DM4PR11MB6095:EE_
x-ms-office365-filtering-correlation-id: 50a8e5d0-73b6-4dd5-c680-08dc3e809aab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4+gApPbtpkO7HhC+rExH3wXoi4s3MV3c9YBYznFDNty0BzYoXbjzGzO4LQNw1eP+FxXU85voidMMWNAdCbkVIjUvE/F5nyRyuzUdadYS5pYAZ/izUYXjfeBrWJwVl2QfKLMSqemGbXLNjLWLylNTe8dsJR0pEifxognW+01uSMNDY6UxBb/xI2gLVcBINRLUQ//POuztLYN0unk2a36Sk7owuL/b7x5QRAFIaoNMML0XRmc/ZRYswFsTeiTrQwqBod2OPi6aiJktsDZ50MNXl3el5ruGiT0uiMtq6r0NVu0irWG5ICdZ1gSs7bO/V4yHqDGzh9X5Jmup0essfo+WZQPJOkCI8dDG5Q2ARsr7nL7FAT96qBvise4D2Sta51b45rl5dxd1zbVTefeezC0kQyYDwsEYj1QJDXbPHeW4ytUneoEeDV+J4FrPlTnLTvRC91K6djI14e+UG75l2sODi3RGp/tk+t576j2W4n7G83QBsIk+WEO0hOXAkmtNvFH+b9A/oaSaQ0r3I2/8nbtX1ny7/SsQGg8qpS/zma0YiEKXWi7Vy8sgdJXLF9novC6zb1kc//CMbCY7jqsuCYcC2c77e+DH89LL6HbotBMgsYdb2hokvLnRTlNQd84CYuePbBUGhfA+WAewFFAieW0PC3mOE0e3cUU6H86n0PYdcl2Zw5HbrEHtQUVthwGajLQBKx98I1XQlKlkos4V97GUyVCscFsZCrKRPhbK63ioTEQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kMFVBOT/03qHL9VjO1yOVgCHA7UeBz5HSppQ6wYoRGDEC9ezdOpDPhLali7g?=
 =?us-ascii?Q?NL0FJ+OnrIS0DhexdT4qw4dXr3ocptEceTfQxbKN52rptqW0jFtfqMP5/ST2?=
 =?us-ascii?Q?pCojpMY8AfVm9CUu0cDHdveyBJ3hPGejucvUefp/nQz4TeDEGcYuGax7rFg6?=
 =?us-ascii?Q?6RP3pMhV4r0vM4n/IlIvfp3QxUSWDNW/5MbTpadDpUfIlTm7YUZUXLX9HsaW?=
 =?us-ascii?Q?ndlcvWn1dTQ8+ainPtvPxWsCgkZn31usFmj5g8MKwROanSLJ3YJpOzEYtuKs?=
 =?us-ascii?Q?YfMeU05lsRf3ozMhYu2PqoITbSRFiGTQdBxxb9ugFM0HlYKszzROpY39vqEt?=
 =?us-ascii?Q?Psz4ciVDm1isvaFCY4F/rjdlYSR3bF7DHB4603Es6ZPNhZD9XXLqAwLm5Hf3?=
 =?us-ascii?Q?olJ92D+Q6fi7FzddD2HMllsTZeuRrQw4Xzg3WjW7n1uCkZuYiSbbWu9Ha+Ft?=
 =?us-ascii?Q?3/AzKbhKXP113VVZkqhP3VGfHgZm65A9Y8zdNLV/8zHw8H658h4vK1GbMw5t?=
 =?us-ascii?Q?3khACIldDHEDCYoXuFBzuLNKp6csFhAnvF27YTpvFytmbaoLR99O5VRt1w1M?=
 =?us-ascii?Q?Ra3rCd2LdHOZJjHpW7Z8Ldeoufy9LaE012rHV5dsZoeLq0BC91vUrQW7a2ga?=
 =?us-ascii?Q?WVtYdWaDWrwiHzT2Sq3g9t1Tn6OtA412JVA5U/QjVuyPWnByGrKeN5dsPf+N?=
 =?us-ascii?Q?j+S+QqSzWet4QSrH5CucD/+hJChk2n8yoMy1G6U+Vk8Hr9cNuD0t18rdS2GP?=
 =?us-ascii?Q?72khIp3qqjnq76NarDIr2m6uCaHyl4EWjx+bzMp1sy/Qu6uWoNmihPqovuGW?=
 =?us-ascii?Q?sz/AArewtLMXBD4Q+E9Fc55pc25NEP2umPWn6Pb/ohuzQZ9qfdet2DbER+Ju?=
 =?us-ascii?Q?zMKjLM3wbdDR0T8Clu9Ct+otGtaewR1Lo1gUF1DDQ5mgxukmMLGHtrbWs54i?=
 =?us-ascii?Q?/zVvOTfHcGUv7R/hgRY6FEyTvmHNvSWR1oHrJL6N4ZlgYEgWMYK1PpNzAFUM?=
 =?us-ascii?Q?Q2RWmhGbuFefDCvfCrKV5mtjJYQbPJGVR4FboRRaRTdEKICm8S8YJE1kCJiN?=
 =?us-ascii?Q?hhoREssjq0jk5vc4mWCV4P5P8K4vSynyadwwq01JfRfcwCZaEJfMq5jjiihc?=
 =?us-ascii?Q?3wNnpphCPNvJY7XcLRdW0aEjp4T/lxhiVZdStTjIJBK/u1sTmOzwmH/CYtV+?=
 =?us-ascii?Q?pev3VX088LfK2ki1xtauQAu7r43cnsBqMIcQ8/PTPjF6Hi6pyY6355+zZjYu?=
 =?us-ascii?Q?G8/mKspQuCjf05PUhMknDpQfwVHnpWTAjUBfeA45ufE+nTpUxt+9nyzGNBWH?=
 =?us-ascii?Q?cUZNh6dKjrz2M3KcgFaz7mGqX/2p5GmZHxRzP29mXtikb7Moa8OUaD+LQ+NC?=
 =?us-ascii?Q?uSN3ML+O+br71CiTKynItdiB6XiRZvKPLt89L7ETJc922iua70c5MEEkx3GE?=
 =?us-ascii?Q?xSyf4WOhnhyjYst8yEOwqcba3rtS0ciJnOmGgq0HxFt4c+6Zn6TR+8xK2i2p?=
 =?us-ascii?Q?sSNvwm2S6PmCJDAgyWinngOsSZujUy2Kd+f55mGHmXbJAIo0zETtQ1YmEC5n?=
 =?us-ascii?Q?dlIC/fL6JehKe59X+gqPrgLBuMn+1flb6jqDaFdF?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a8e5d0-73b6-4dd5-c680-08dc3e809aab
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2024 08:28:45.0978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gMOUN8qKGXnmh41LW0MyFxl6i2ZdcmfF//Pz6XHcUVwnTQq/iHzbzyB/dSDWllobdccW5yBzXsdo+6655qsDzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6095
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 7, 2024 5:15 AM
>=20
> Currently for devices requiring masking at the irqchip for INTx, ie.
> devices without DisINTx support, the IRQ is enabled in request_irq()
> and subsequently disabled as necessary to align with the masked status
> flag.  This presents a window where the interrupt could fire between
> these events, resulting in the IRQ incrementing the disable depth twice.

Can you elaborate the last point about disable depth?

> This would be unrecoverable for a user since the masked flag prevents
> nested enables through vfio.

What is 'nested enables'?

>=20
> Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
> is never auto-enabled, then unmask as required.
>=20
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

But this patch looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

with one nit...

>=20
> +	/*
> +	 * Devices without DisINTx support require an exclusive interrupt,
> +	 * IRQ masking is performed at the IRQ chip.  The masked status is

"exclusive interrupt, with IRQ masking performed at..."

