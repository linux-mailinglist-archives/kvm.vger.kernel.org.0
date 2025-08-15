Return-Path: <kvm+bounces-54778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A0DB27DDB
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 12:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C10717DED2
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 10:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854CE2FF66E;
	Fri, 15 Aug 2025 10:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eo4FSKdo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5A72FF163;
	Fri, 15 Aug 2025 10:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755252188; cv=fail; b=q1KPzs3MYRyF0wk7ZnCsgllvwQuKgAtWqKtR2oTydaDlq9yHjADYca6f25WgZoSKiWd2K+piyliFzgFzOaWwu9DdYi8qbKhFkNyqRHK7LSCUDRsrwUzty6Hrgru7I90Ysu7VetSX3pJ7tbEvhsc83b4ZYA9OU9DWgfX/pJQXGJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755252188; c=relaxed/simple;
	bh=F3X24eXy7ltT/QjrE3mX+XdHMY09px/G+DNrkSE+P/k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DXkNyy4lsiCaPdVCXK0baZJcRkVORkE1GzjddidB+gQNmxCtJecnyyADLc/SWRbJK3J9PsiLCoTQDEzpT4who8Q+tlqmZD59KieWGW1YokoZtIezWgItljCnHrBv0AIWfLX20omgRYDjdmXhr32Ur9ZapfI33646R91InpUArYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eo4FSKdo; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755252187; x=1786788187;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F3X24eXy7ltT/QjrE3mX+XdHMY09px/G+DNrkSE+P/k=;
  b=eo4FSKdofpUFcpw+/5hbgPJz669CJgx4HOClb6/31mYWUKJ9/2YqoKMz
   hH+XvDgIYOQt09XEL4h3C5VhWYxbbamnltRbWTH9M+Zvb4ZBYWk1LW78V
   W7yl0cJ8xZtyr+L/4OFACZqCIxYJgXSbxi9e99aMjcwM9BabUblQUcAaM
   WgMhMLHhCTjFv38nuL/VYEyXIUHrO2nYs/i7tyL0ec7X/RACmgHiWPh7V
   eqyJ5f6DewslTFgtmrnaevYeBrm2PTEPJ3Ldk1tMMnlIiTYZQejkV219b
   BwFLRwVtgOEzQ+Rfa1znREvY1GqFba5ARwtD3mc79novZOWJT+3UnM1wf
   Q==;
X-CSE-ConnectionGUID: SQ96s25XR0KADNvYgCJonQ==
X-CSE-MsgGUID: R5AeHVmCQyeUc8JvN3nkwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="61208366"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="61208366"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 03:03:06 -0700
X-CSE-ConnectionGUID: IRlEBdt0QLKkryJv+26Lgw==
X-CSE-MsgGUID: y51Tek5tS6CVbPWdGasfsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166955839"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 03:03:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 03:03:05 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 03:03:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.78)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 03:03:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEyTxmVNup4VsQrF9lKgBMemXt9kG1G9MXhYhs6sOS50xe3FnZhOyN8T0QagkyB7YDcUdHbdkhHOJo7IiExrBq1r4Fpg0ZVXWtI0DWII7aVX5TkNoWN1buXXiM+1uozXhaPTezbhdA7pKr29DIp+/csePIRRyU8haTiHPtcgaShsQ26jPL1rJnjjokcUX0CSbKwdZYzS55u8ndgrtInLiqnrynVxcaROzm8dQm/Z6/Z6Oa8YNnrKCBrHHT0j4GIf1CZ9+gWcz/WevaMm6qNg557R3U58HVoDHWtjEj9k3SNFA8mFa5m9FS33Fc/+5Rf1Klie/HvaYwdqFUalepLslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTfRu3wGrbc7LJkvRRfj5Is/tZENngSpKoadEXXCh08=;
 b=B2SyYFY0YkEvf3uT28FH2UCSrxAqcdtozWEX7GDj1yVv26lfOkeGOOX+Ew6nRrBOhZx94eOSCUsEmPqgNYPCYBr1DWSxKm3HljANYOsZp/MYfSl7otj7capZoM8emUcUv7F/nQfGznyZEERdXh8yespPvcQ7km9cP4hUJhriKUAdaRrkC1R03N8Wg9GuTMsOiduvOTSx8e/4P7GsrppRDpqQM0Cf2bT6V7q1lUDUxE97SkTikw/hF/PrT8HwY3uNvv8dcTeuf0asmEZV0m0q4QPh0F9m2aBR8iocg01tigYhpi36kJWeKVvW6Ycz/0Q+mElA26yDALTslocdOHidpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB6741.namprd11.prod.outlook.com (2603:10b6:a03:47a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 10:02:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 10:02:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "clg@redhat.com"
	<clg@redhat.com>
Subject: RE: [PATCH 2/2] vfio/platform: Mark for removal
Thread-Topic: [PATCH 2/2] vfio/platform: Mark for removal
Thread-Index: AQHcBvQgdFlUbujsI0uZE1ML7e+VBrRjiYyg
Date: Fri, 15 Aug 2025 10:02:58 +0000
Message-ID: <BN9PR11MB527625D5F0C46C7A447C4D7B8C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-3-alex.williamson@redhat.com>
In-Reply-To: <20250806170314.3768750-3-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB6741:EE_
x-ms-office365-filtering-correlation-id: 97e09899-78c1-468d-8e1b-08dddbe2e97d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ocs4b/btuxCpfUhnD5GZ+Ii/G+xTSJ8PWjC55lNaU9zGLohH5l/73W6TPGCu?=
 =?us-ascii?Q?WcKrI4qC0LX3/6OdpMl1LbQY9oRRBlGKUrfoVL3IvmEOd/z9oSt2UL9uQTbt?=
 =?us-ascii?Q?3kn0QQmb5ZGxMh59hKDFnVGGrQlRgCLAmnVPGf6KZvBySOvuv8evM/O42bZI?=
 =?us-ascii?Q?9AORDUK2K81EZ3vI4ZZSGDToiPGbtkBCmu1783n46o/zVIWZfhiRjhg727oD?=
 =?us-ascii?Q?4Z5AmKfymBpoXUmA2d7byGU6pSqKvXHm5at4h73nTcOZ2I4ncgMnPv0yzAF3?=
 =?us-ascii?Q?A+IIt2x4wirSVcV253FBGd9V3Sfg3lSrUt7qd0UFFrKos6gN0EFWpnzfqWEA?=
 =?us-ascii?Q?FB3pUk599rlVPTCdgDLxoViDQT683L+SL+hCtrCPZJg3o+iqTnnpdt4T0iP7?=
 =?us-ascii?Q?dTn9Lg3FlmQeVH3Mg2NAF6qUlmiH7I1/NuNqk4rtk53M5S0y3X/wbk/H/nwo?=
 =?us-ascii?Q?LsFYutxGtPyalWyPnVx75EHZLdI+DJaXdvPMpvVZjEl0MNCetDSXj0DzJ7Bg?=
 =?us-ascii?Q?J0uT6qQuNmpozNwZgoxDQd5wgJaG80UjWJ8BVEZDIltt+1r91k6YQbG4COea?=
 =?us-ascii?Q?kCJdbh3s7Iwzu8Ld8NbW0ec4FQ/1CUwYqzhEm/NsL4b9FMJkzDP/LvxZMRba?=
 =?us-ascii?Q?WM7HoEmev7FSo2VCnTeb1p6qILaRZN6RpptZIIerlcIz8zg4rjeRij4I816p?=
 =?us-ascii?Q?Mny3EocsNqhJBWhBQst9Pt7e3ikGVnhkgvLIgBKRNRuPh0Z6KZ/XMSftmL+K?=
 =?us-ascii?Q?hXIjKyyrqsub108MfiXbfkFb6IeQXXy0kts06Aw6exq+KgpX8W+EeBuYifE8?=
 =?us-ascii?Q?gfUICUEsjO+1YCWY19zvu1SV6Wjo3elrNyPmCRmbdzHwZdonxZ+6wdI0+YtN?=
 =?us-ascii?Q?8/U7m5V+O53aQm/s86Yx4AQwHAnb1MmFzQ3Lpwr6GNt5aFuyYgaRAypeeyh4?=
 =?us-ascii?Q?OGLUgcECb3VUJJG4zZIj9llZ20UElZWTdkQarmY49xIIKGkYuDer0Smlg3lx?=
 =?us-ascii?Q?vTmBbuKz8lw/YwL8iSJQBzGHgneUfacFpTeeUkGK1rLKLRWiKinNsLvZHCoL?=
 =?us-ascii?Q?rNFDZ3C34sJAVonMRsuA9ndGvAlzpQp9JSkRAEQxXokxpY+jNp0Aq3zRC9+s?=
 =?us-ascii?Q?oe6SpR2FeEJEx7lOLKvgFkXnrv8F36eFWIy+7LNaA/A9hce3JUqYyKaw7TV+?=
 =?us-ascii?Q?1TAZlgBW0Af6VnuY00mxClEcpj4yJthLGAMFqhTcpJmHRcaMMJZLKIDqhsWO?=
 =?us-ascii?Q?qpHR7rb7GakJ5n74F0VFUgO8PZxMtWtUiexBXMSKP7oJGeZ+YIgz9rujkYsG?=
 =?us-ascii?Q?+m0U2iXB3BFtk+88PTsSYm/o2+I7CRfyEFiSy8Nwm6j/2/s6D53rI98yD3Rv?=
 =?us-ascii?Q?k/7GM9tf9oarbIzCg8mIsyLcpJNkEZ4Lkhj6oAezCcZ78Qqf1gYkvL+WjJRd?=
 =?us-ascii?Q?7cojpBKY0mcnWrdwVfcCwpBtsne49Izy?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JE0aYl9Z6/wTK4VMNPdADGKiI7K3NjzYY8hTVV0aX7u7FikX5kf1aLdok7Ch?=
 =?us-ascii?Q?WNRqbqw0kzjOEZZ7UHfMFv2N0JXVXA+bUgRJZyslfSnvQCMDNqCqqAucAabM?=
 =?us-ascii?Q?UY50h3jrQNqdz20elxWpztdAnlAFeMUzsFxX9d0p0jwX59noCVlOeNiGc4i7?=
 =?us-ascii?Q?zLx8Ygj1WH1zERJnRKpxK6990gV1rwME42tK5erDYPyfcAoS5x3hY5WSdx7u?=
 =?us-ascii?Q?C7p8+6DbFQXBfPFMSNd6SEjXnn0eCjkBbbO+huN/vswQ/yqWtbRD+tyNcFSE?=
 =?us-ascii?Q?5iH1DtBAHHk/Ni8xYT+wF0OoIplIhLgmP5mD+xT5jjfx0ACoUeHSm4DhBHM5?=
 =?us-ascii?Q?2S24M95NIHXnHQ+5KT8kVWpmrskbgIo07lQZvMQhfHdEHRCLlY+Vhyh/HfdK?=
 =?us-ascii?Q?8sV+2zV7pq07pmVrggDLndeEknsiP2dvIVvBAi+t/OaBPu05C8FdwQ3kM1NC?=
 =?us-ascii?Q?Fbdfx2rDrILD9CpmcV8nYax90Rk9aNtawpSSm75kavF8ij5zJr5N1jpo7J2z?=
 =?us-ascii?Q?Dg34hp6LFTKsKVOO0CzYTTJFU7GagUBh6qmX+25cGaAbEx4vgledFr8HPcxM?=
 =?us-ascii?Q?BXMQOtySpZ6NPBXa5cJXG4TNEXlNO1LpAxVpHlQxI7bV79BE9tPKGkg0ppZp?=
 =?us-ascii?Q?Ue7utJGFOirkGIbY3oRg+nOKPhl5hJpI224vUw/21tGG2P9255Ohx9Rqkkck?=
 =?us-ascii?Q?NAkazlzXUcCzi42GkBEawDo5okhZa0pyrj7uCfHQqeIzy/ghqNkmP+zFWnyC?=
 =?us-ascii?Q?mzGXa6+8lfl9qIi+XPcOs5RxklY2rVSr6U636d2qhuG/Ct5k9A5m5d4hvXmW?=
 =?us-ascii?Q?VJHk8gcXfwKbaARv0kF4O3tRKKmGHt2LAZ3Xqy8Iz1EK0iNlxbx3vcbcQ/QS?=
 =?us-ascii?Q?81LbcU291xGaZLmkkHsC/0aljL2NgqoJB+FxCvcOyE1q0kRaDdXoSeR8UBv/?=
 =?us-ascii?Q?pwF+UxNxbrhjgXDCK+Z2fZdG+fygW/QhX/m0erdmAN46oC9M31QFiGvOOxTw?=
 =?us-ascii?Q?/x0Y89DSpzCe59XCEfX8uAJg5gWXyP/KLSj60RlDgK7P3AC2R/seoNMUbrd+?=
 =?us-ascii?Q?DElXFBWMVz1DgcfDSpVkMIQHRsoxbP80zvfw/PQASC0u92jwjaI6OZfEGcKO?=
 =?us-ascii?Q?aZk65XbM0T0TFKtMPGIqtWoNpxsGbLCQLKeqek4XTy1sZxoxtoVW6bgTjEP2?=
 =?us-ascii?Q?l7Yc10NDlYafii00gOjGb1eOa7fjagDxr0gV2SrRD7dF51R4b87n/OMbrPNk?=
 =?us-ascii?Q?svEMpylI2+ifvJNFSYlv8W2vDtS948a271d/uQggTriy0EcqMJrgd3fSfMjd?=
 =?us-ascii?Q?2xCrd9NAlMp52GwlxCLO/RuDS4iEkmnBTN1fOKnXwPbTaQ2TRay2tIoK8Fbs?=
 =?us-ascii?Q?dQzrmWr2hVrskf3Sd1d5SofMptTKJigwWfjbdyxH02SRLAzaY1BRfr/wwC/U?=
 =?us-ascii?Q?dLlbxDOWDxATItN2t0Wh9UmbvYyquiJ2uoqhO28mWXagZB0TRgmG2d98Yq3v?=
 =?us-ascii?Q?lM49LXf65dzKJVEvQh01OIFLRLtAe1ohioJr2KmDum6nKfkDZLOH4/Uw3K9y?=
 =?us-ascii?Q?e1MgoN07l/wgW1F3H5fL6Ahldy5fgcK0FaOp/vKQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e09899-78c1-468d-8e1b-08dddbe2e97d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 10:02:58.2797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKo++MplInlkUQkj9AdxmV0eaohZ9GKF7Bv3pU2mcnHbzCCiGbbEia8q/39wS9RKP1c8vVQGbnNg67ipWYbLAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6741
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, August 7, 2025 1:03 AM
>=20
> vfio-platform hasn't had a meaningful contribution in years.  In-tree
> hardware support is predominantly only for devices which are long since
> e-waste.  QEMU support for platform devices is slated for removal in
> QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
> driver and difficulties supporting new devices at KVM Forum 2024,
> gaining some support for removal, some disagreement, but garnering no
> new hardware support, leaving the driver in a state where it cannot
> be tested.
>=20
> Mark as obsolete and subject to removal.
>=20
> Link: https://lore.kernel.org/all/20250731121947.1346927-1-
> clg@redhat.com/
> Link: https://www.youtube.com/watch?v=3DQ5BOSbtwRr8
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

