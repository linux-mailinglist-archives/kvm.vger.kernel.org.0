Return-Path: <kvm+bounces-18003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 464D48CC9C9
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED67D281EE4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEFB14C5B5;
	Wed, 22 May 2024 23:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="brTHu6RF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6B5824B1;
	Wed, 22 May 2024 23:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716421263; cv=fail; b=jkDrJmXpsyuHIc3EeJ4aKDcAhhXTn7+9oHK6DYlWHz2y2rWs/gsXJmx1jWKBzbDdaYnj0ozskRVQJWvlhGUEryFV0REGT1Jv2WRh0w+ekH7Gt9pQo5BEoR142/0bWCpY/poR7QHfKxNli9GWi6aPaOgVPhjOxwcX5KSuNzA+1vs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716421263; c=relaxed/simple;
	bh=M/4Ac0OXGk+GkZSfWzxzK/c1VSidE+JQIbZx3oT023I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LF5ComhF/5W9Y9NvSI17PxM5UD5eCNe1LnlxYsr2JXVM/1CJgDK6lh7J4Zt2HUdGTX0SXcxjS0vUJy0nLVExuOqIRObxWZAVeTJ0eKOkSljszmmKLfxPLodkM/kdZ/6geFvl9A57MQUg4fXZBroA+QBZWuFIWYcEb4eUJ+s1h6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=brTHu6RF; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716421262; x=1747957262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M/4Ac0OXGk+GkZSfWzxzK/c1VSidE+JQIbZx3oT023I=;
  b=brTHu6RFgqQdyqVwhDqF1yZC76RMk3ffTOSeKMexun5giPXp5E+V65nY
   HFeWTFIZrtcv/pJlXI2tOlC98v3Ou8j79gcO+d9PgnO+aROmuCW/76yBr
   mtRVYxzbCjgckHi0TuA7yr+o3M53dFc1nJrU/UpLvBOEfb2qPxj+bCwRp
   jAB0qOtRS6mgGqtaKeFtMIod3kPqjgizkzW8vkQpyhssFEo4HDKB9ijOf
   wE/aSXLNUOidCpcr9rt32Mmue9Fk4i002tBTqxYsvIuoqNFomiQdAIjNT
   mZse7lcB9IiJkOXIIL+JI1FfSr/O33+qNweA/LBNfuJmSFNGmC+GQjgPs
   w==;
X-CSE-ConnectionGUID: bJyi60T5TbOI5txiav7aLg==
X-CSE-MsgGUID: TzhyA0oKQyKJe0YJLK2zOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12557976"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12557976"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:41:02 -0700
X-CSE-ConnectionGUID: JKBPjnieTFmW4Pd6tyD6oQ==
X-CSE-MsgGUID: wzHtcfbGTHSXmNqdt4Yl2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="64691949"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 16:41:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:41:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 16:41:00 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 16:41:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yt0GaEMbkKZIt+jh+5BNwZ6IDQkVCfaNgF961rpONSWwuH7iAHe5YG3rBJAuDxumGHh9IA3ZG9FFGBBySsLV7a67cxt6MtN2whDYLg22lWQD61ZFA9WaBvX3mlw3tgWmVzszCJrOOu8sCLzaaIQbm6Cr8A7/j+Y/D5V2kx6XnpnWV4BxdCmwjXWLEspy7Fes4KabhUABciixaC4mBXaW0LLYZ7moBJkoTiJ74ua2we7NMEubdMMBmSI9Op8FiF4QVg+LbFy42VJ9/olKh93mUI9ER0hoG7z+eOP3qWaZFv9YiP7NwuWCSYcJpF59YzMMcRRJ9qc4/GDiYjFulVmcFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlpM1lZrH7G7gfgo14/xzYTilnHF0u+5p3UZOurokpQ=;
 b=nKpvgfzXXYPzpqqgf5Nh22HavdqbugM1Q1Pb+utbpyu/BiIeM7UHVOTTo7yO7fxlJ4P9hixiQ2r7VLm626guMGOge0KtHwX1ZvExLCgEdugmhKqITIPthHK6Pk0ysGO5EE3oWnyguu1cSkEmpULzZN0Ov5zlv0E/PZI7jpog1Ie5LGpQ+6rloP0dhok38S/Uxsrd38kBEvxBs43nUG0jvU6VlbdyzPqtwOBkRRhwqmw6rrvzvWzwXoRHK2xzpLQrFDZ8n5S0aIxgvtW/oOpQW+tHS6pvLjiteZzb0fmff2i3/W3I3oOvAhi61iO3cg0wKgaEOtTNOs8yHjn918AOYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8727.namprd11.prod.outlook.com (2603:10b6:408:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 23:40:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 23:40:59 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "Vetter, Daniel"
	<daniel.vetter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATCszCAANP1gIABWkKAgAPDRsCAAnQoAIAAA/SAgAADhwCAAB2LgIAABQiAgAC9HuCAAG5egIAAtd9QgAADQICAAADyYA==
Date: Wed, 22 May 2024 23:40:58 +0000
Message-ID: <BN9PR11MB5276C2DD3F924ED2EB6AD3988CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522122939.GT20229@nvidia.com>
 <BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522233213.GI20229@nvidia.com>
In-Reply-To: <20240522233213.GI20229@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8727:EE_
x-ms-office365-filtering-correlation-id: f2b18265-5a2c-45c7-0af0-08dc7ab8a1fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?vhLu5I3e9fnOMmnBYA+n2MiEhm2Y/t99bUHxsaK4NbCvuc39jLKi0qrFnYt2?=
 =?us-ascii?Q?yXIrtJTRy+sJ8EZ0tqK5S1xCY7HhacRo/2TkrFshqy0mN/6Z7rWxQG6Q+2NJ?=
 =?us-ascii?Q?E2xDkQllcVp6pZzuSSiVOPwKA7hiuhXBpxPZr84Y40J+UPyEk6SjpOPHVEAe?=
 =?us-ascii?Q?tteTJNSqx2OCis0kgkjFT8vkIajMQFa9TA5wRedJFgHNNc4mYnDdEKUgenxf?=
 =?us-ascii?Q?qFQ4ttLB/ZOKAiOIypLeH7yURRfZvL0RnLJJD5kQ+GXP5gyEhfefAovzHK1N?=
 =?us-ascii?Q?8WVHX+QnCVUxfq/JbPD5yXad5Mt7LdhaQ3z3MJffzLDp7oM6ZEEk7RlIxUAj?=
 =?us-ascii?Q?y7swcZ9h6yY22MBjwcxcc5F1Rw5+ZAAaIC8Iv2bSbGnIH7wRpPahYQo9TkhE?=
 =?us-ascii?Q?qkkjD2cEX5zVqdEnOze0b5+ELJRORKU9sgDXQhjbKi3GiMNLt0TWHUaCaV4E?=
 =?us-ascii?Q?6bS03jfqOogJs1HrMNQjRvgHeXjzHXzc0UMjVUdI8O1OhED3qyFbCS5tnGsx?=
 =?us-ascii?Q?WyULr8xe89zYxFXfClc/dOFPrh3gsCbgZSS/m9Kl/KN0XQMgk2fSayWhXCUV?=
 =?us-ascii?Q?lfmltwB+vJCF/7P0oHgnmP33Jp7VLQBkM4Hy+EF1hBseDoJ2lAMgWUvgzPPi?=
 =?us-ascii?Q?NrFTe2vck33HcmdmD56DpfPrjknXyvj81RP6BEd7oVtLsqGAvYfLYiuZNaFB?=
 =?us-ascii?Q?H+7ZpP/zwjpMHNFvueFVZC5bxB/Osy2RJ1cNyxdVOIwshRjGbzOfX4D0OYCC?=
 =?us-ascii?Q?bxU0Z5T7tv53NgHFLmbJmJ6KHD5+76TjQsWHGTrEDgQcsYmjncqhaJgirPz7?=
 =?us-ascii?Q?6ROjVxBNZgp5sUe0pCN+I8G8kW15wXnitvOt5g0xeK1DzzCZWOSp0Z8Ln4VD?=
 =?us-ascii?Q?/wKRKNnbfrO9zxaM2HVqxOAU5pkt9N3pjpT9SX4iDDGMUX5eBM2cCfLRwLVB?=
 =?us-ascii?Q?BWa5GloViNJPd2UDatsTMa6cS4e9xwVpM1HEXEaWlZsXLgpNQV97QCfzJvft?=
 =?us-ascii?Q?YVG1bMwgYaBBMU4PL7oEPJ5b++HmApGmKXw003MY1hciVxwMGziTJ3LQHFXs?=
 =?us-ascii?Q?RhhfTOKuxvgpviqVd+mHoqcxDtWxdJoSHvl07GSTJEuf1fdteHbj+buseIfh?=
 =?us-ascii?Q?HRbQ+Y+fBSnFWN0pi/sVSwmFCm12bokWsghkOf9BBOTQuG+I8Fe2yT0soZne?=
 =?us-ascii?Q?ztY3y0Mgipan1wwkxpe1Xu8ATqZGq8HkOWcwOyrTuDSbWAeytl7qaXNljwVF?=
 =?us-ascii?Q?B9kw/NjuP5qL5OE+ys0JdXoNRD+Dtqcb+9BxiXuM1XOhaRtcWPsYhuIHVYQx?=
 =?us-ascii?Q?l+UchQK3l4llvYs9UFoo3s/gNJcE0UcgpjDCzKSs3BjTVA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VFe7WvT6MpVmvdzdW1yWWbI0lscYJUJwttdNvU5juhvAl+50b4js6Yqhof7+?=
 =?us-ascii?Q?k7PoPxUQzf+Tp/gzwEiqcqmTGjY6b3zgHHeSi9cUgS1qLHvUtkdnTLGod8jZ?=
 =?us-ascii?Q?LM4aUnYNAWJqOiP4UBmVp2SBycUYpHTlLcBUccagm9lpqQ4ZNYoXNWdoZ1kV?=
 =?us-ascii?Q?Yz37++BOtG51P4pKPVe5ex9fxOBNcaZEF2fW0xntI9M/PdrhgrfJo2vL5AuY?=
 =?us-ascii?Q?ODnleo9RLOnHmaQPNW7xzrdRISuFZe4MxX8itN4WFfEJz8nbp0pp2ptyZ8fz?=
 =?us-ascii?Q?HD8oq4g19sgMpF3IJVuHEcmw7KICgYWEwKE997mYlD8+R3p6gIJlPdmKOfUl?=
 =?us-ascii?Q?xJX6mGBlaOMkHb082kSbqxAslsfGl8fndD9HeVUUY1p6mTMGxW5UXPBUT5pV?=
 =?us-ascii?Q?hVpXZE1NJ5A6SkdGVm0zqTVJmcjgxnDH20BNQp4eaw5kktxTf6Jg9vBCmDiL?=
 =?us-ascii?Q?kwB7hSH3Bt5M6KDcGSIF+Czu2ex6+wwsWrM0jQKkuEQI5qOSK5LzDEB3t3XK?=
 =?us-ascii?Q?S+kGcYFmoHYkN+X8D7X5uiSNT+BkuhV+CU41D4jeHHyq5xK/IY18WpDLB0Hd?=
 =?us-ascii?Q?Fwgs00X01Ahf5RUt7mAXnTi9S/A7vC+NWNE2VL/HFGSKA2d1YNlMedaHA0pg?=
 =?us-ascii?Q?2mPTskMoEWH1NpDFylzibTOfSd+L95DA6Z2DXFeszTZoz7un1mnkteHFjmcZ?=
 =?us-ascii?Q?Sf3f1FNr78rbO1KWnHeJlCjgusjM2x3gidEWsaf94Kuzm6cAp7sbRgL06QPI?=
 =?us-ascii?Q?cjFZdUvMrUp2hWRxUIxnVJZjwDXdfCnrpT6Fm7U4OPH4PCjldSK0FHuT84+G?=
 =?us-ascii?Q?YeHPL3zFJ2v/z/4r0TyyBtgepx/vxR1wrNWCLFZBbA0CtKayU/o81LTwJoE7?=
 =?us-ascii?Q?Vt8SUwlcriroK4hulgEZWLVOQvuc5oU3KJ3kXB00D67R3/tGEF7KH+A3BVVb?=
 =?us-ascii?Q?heaatDxuV1C6E3rAPEvMtCXX0FAMaVrHYcghy4l9r1/ZKjRCJpP9bFoTI8/H?=
 =?us-ascii?Q?czED6LsIiPvraMagex5a2off/XdwBn7qLdLK8bEpiv7hkGJ3Kpj/SIR990Ix?=
 =?us-ascii?Q?NUwF9R50SifmE26Nvlqq2Nkvjt/5go86DZJH4SoegHjyu3KQ4HD3JPFF60Sr?=
 =?us-ascii?Q?Ko4TupBVACuTwN+ohVWZF5d/Bmmcp69Jl7Gw8P0cyth7LggnPestiueSsPgV?=
 =?us-ascii?Q?Y1H+57rwyJ70kcrbRE6tOVaamViJRD9rlqy1uu9VVD3w/U8qGcikb4K0C3je?=
 =?us-ascii?Q?QzFq4MLNa7eEDiItTj8K0qdPcpAKEfjF0XGlc0EMQovxfD4cR7yPD1T3z09m?=
 =?us-ascii?Q?Ke83iubuKFFaQZ12ZocOaIOCxMYCwdy+nou/rk4iShu1SNhSh1DQbeyO7Xct?=
 =?us-ascii?Q?zhGfPkAxixQjsx/u5dZkucnevXSNrHB/6NLXU18LSXR5f+GNNCaX5atyyQPw?=
 =?us-ascii?Q?LyQa3YMWTrXGrmOqgYLNNWpECSfTtkxtnp4RHb15zy69FzaJCgtc/y92rN5+?=
 =?us-ascii?Q?A61EgJ5UBeZL+sr0efLoi6h9O3cy3raSKzOrcwFChetzNbgJRbFtq2WPBs2C?=
 =?us-ascii?Q?NzeP+w3wTfyzVqErHWbhIXt9rADQVnqmDB+spboZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b18265-5a2c-45c7-0af0-08dc7ab8a1fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2024 23:40:58.9939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d18nMh7MqBHs3jluvMmzqAtvidNXdWCZZP3UNb+QXiEfYpOxbrnVyerkIYetmdQ+2dPhZCw1THpx4BNWwNXubQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8727
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, May 23, 2024 7:32 AM
>=20
> On Wed, May 22, 2024 at 11:26:21PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, May 22, 2024 8:30 PM
> > >
> > > On Wed, May 22, 2024 at 06:24:14AM +0000, Tian, Kevin wrote:
> > > > I'm fine to do a special check in the attach path to enable the flu=
sh
> > > > only for Intel GPU.
> > >
> > > We already effectively do this already by checking the domain
> > > capabilities. Only the Intel GPU will have a non-coherent domain.
> > >
> >
> > I'm confused. In earlier discussions you wanted to find a way to not
> > publish others due to the check of non-coherent domain, e.g. some
> > ARM SMMU cannot force snoop.
> >
> > Then you and Alex discussed the possibility of reducing pessimistic
> > flushes by virtualizing the PCI NOSNOOP bit.
> >
> > With that in mind I was thinking whether we explicitly enable this
> > flush only for Intel GPU instead of checking non-coherent domain
> > in the attach path, since it's the only device with such requirement.
>=20
> I am suggesting to do both checks:
>  - If the iommu domain indicates it has force coherency then leave PCI
>    no-snoop alone and no flush
>  - If the PCI NOSNOOP bit is or can be 0 then no flush
>  - Otherwise flush

How to judge whether PCI NOSNOOP can be 0? If following PCI spec
it can always be set to 0 but then we break the requirement for Intel
GPU. If we explicitly exempt Intel GPU in 2nd check  then what'd be
the value of doing that generic check?

