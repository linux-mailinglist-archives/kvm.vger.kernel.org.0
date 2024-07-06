Return-Path: <kvm+bounces-21058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EFF9294AA
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 17:57:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85BB2B22778
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 15:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D6113A87E;
	Sat,  6 Jul 2024 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQV0jkms"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A3F4C79
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720281455; cv=fail; b=QgqDHp90Dxj2N3vebCopdm6cuMpWKwvcRkSLTrTz9AMi3wXpIZFRvaNQmfPWcrvvK9e3d3hh3opafa/Y4pfsEWLgVTFpdWx6OSCQxi+PEPGHjzAs6WBTTGRPLtSFTMqA14UvBEM3Yqmuet88cPiiJLYIPdV+QvRhfKK/7GnO5iU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720281455; c=relaxed/simple;
	bh=JCVAqvM2MDEV5uhfJYEeAC65NhVV/ZjqwifeLyQnE2k=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ThdKJx4PB5vI6O3f+OYwUQQloazgzOCKG4RnARm3fayv4eetyhjipanMN+5/Jfw1eDIlGKBqnyICLvb12IT2RzB6Er9FmPXv/bQbj7OwaMFCHkxbKT1Ps7FHHrSWUSvllKK9I0A/78OtmKxoSe6xNV5tgVvAvoG1ha2eCxPkU0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQV0jkms; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720281454; x=1751817454;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=JCVAqvM2MDEV5uhfJYEeAC65NhVV/ZjqwifeLyQnE2k=;
  b=BQV0jkmsqL0lrlqUb/sggbyTOnNTQeFdwE9QV62U3sIB9TvjdL7M8BQ6
   LMG7zNHTqiLpMjlpcEaCme0vApDjSaYEy216JCMbdcXaGA43j0Kyt0Rkr
   OehVA553YRgGblaAkSZfRrfiZVI465kKlzitOAOODi/mzt9PeCP2wH0dQ
   IhBiLjEoZVMfPlYS3GjLhuttAcFvND+Aoidf05pnMpC0hTRqalS81gqfG
   7mCTenyb9tk305Rrcsg6fKYWGglo6OGm8FT8S5DExZbsYtULZ6m4AaKXF
   sPqIyCSOLv/hYCJ2rgZHSmRSTARL3zNnw0ztkDe0ek/HUpKjzp5hCu73K
   w==;
X-CSE-ConnectionGUID: 0FiZMnwqSQ2MQVAG83FQNg==
X-CSE-MsgGUID: /E7vgaYpTKia+ALkrVz4XQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11125"; a="17183019"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17183019"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2024 08:57:33 -0700
X-CSE-ConnectionGUID: D1EZDpYlRMWhB51z9AFR9w==
X-CSE-MsgGUID: sx7SEKJQSy+UBd1DHAwvfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="47089368"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jul 2024 08:57:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 6 Jul 2024 08:57:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 6 Jul 2024 08:57:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 6 Jul 2024 08:57:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOCPCUubaWwefyg4ycf4re68Or/jdU6CiwOiaJwgzlkCF8MKJWZTjSBegNPzky424BMEVmalFe1cFexgMunnZLprOgBto9U14vml/DwV5RHWPvxElfL65Nn3g7Dq2Q4bscKSKyg/NkVmTRaqUekLWOgEVD5HH8SDTS8aTwozBdDlUPBvVKUqedlZkMyZjNQr6vt8j4ouIBAqFvr5JrvHyA+8MMQA6U1xU8o3PI3GlEUiJRjnXroDPm3RkO1gP2k3YBbuzKuPp2QbvQEuX8wvlfqv6gdBEvOzVOehSAMbTqMqrTB0W5aL9nRWxEmphsi4Pag0ViRYClkL8jDIxBhCrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VaVpg81DQv3oKH+IVy7oIzxWLWbsMqEM5+7SAg87UR4=;
 b=bzU0lzjzeZ/UzAWZxvVtxw4elOAv/nmaSEYXVaZs+hosmsEeIMUifIrDMdGjdoTOh8h+W6KCy2brmu9uS16s5c9LA8NXk5M8n/TryigerdF99IG9OGbck0yzhLNxnvW8Od7xjfqHIu5rYWazfcJbR/12AIOkHWYUtXyx4ybB6bVNvZ8xe/ACrBkYnBO/6kQjN6QKtRGYBuw89M9mvBCTMUOavLwhjEBMb8TLTKto9kk1vK11RPQSyGbNrcHMDf9X+mBREl/ftRF2xs2EhnAon6EmmRVGsTjb+GH8Cd0qIgoAc2QCIY2LD6h2qe46kNnqXFtI9CIK6Q/GR911WjhA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DM4PR11MB5231.namprd11.prod.outlook.com (2603:10b6:5:38a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Sat, 6 Jul
 2024 15:57:30 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c%4]) with mapi id 15.20.7719.028; Sat, 6 Jul 2024
 15:57:30 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "eduardo@habkost.net"
	<eduardo@habkost.net>, "hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: RE: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Thread-Topic: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Thread-Index: AQHaz7q9ZjMUH5bzOkKKsRzdx5eB4w==
Date: Sat, 6 Jul 2024 15:57:29 +0000
Message-ID: <SA1PR11MB6734CC22FDFD4F85E7887553A8D82@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DM4PR11MB5231:EE_
x-ms-office365-filtering-correlation-id: 80c124e5-5bb7-4ea6-7de3-08dc9dd45724
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?s9kSXlhs2yxjuGBBnIF8TWpLiBUZtcMojI2NBF1FL782FQVTDSpt7sMOQg?=
 =?iso-8859-1?Q?hh5y+OdnUmIvM8NeYVa6zSHreTl1yB6vwBGRm//Qpo3MV/sRHXCffNWsDt?=
 =?iso-8859-1?Q?3V6oxkPLm3Wq3v9Q2Kj72IhGSj1Kd7xCyOvxTOCG/B1YUmyQxTXS1EbFWL?=
 =?iso-8859-1?Q?vkZU771mS6OYuhUW3gZvJVShBHf7dgvWhpqGnj2YQMLDy8BMnViCIRtQi1?=
 =?iso-8859-1?Q?aKGCqgUrGffd4QhMu1yxdfkuzdXC0t4sAOpqRo+cmvjjHIgiVMRfccf/LB?=
 =?iso-8859-1?Q?EL2vovAaePwA/TXww6VqK7XxeYAIk0JPppxAd58OqSxA1+xnrEQwFYwU6b?=
 =?iso-8859-1?Q?erHHviR2zB7FPMObq/0RM4NPRrtKBeFkoTnwcOpPTN/g56dSDhC4o0gwwL?=
 =?iso-8859-1?Q?I7cQLY9tMstMQVtgVOBo5XKNlBusP+Hlt0QRnl3LEGsEks1wKeIjCECSJB?=
 =?iso-8859-1?Q?XzqaQJVrbtri4SPv+X2JOzhw7R6uIvO+k7z/EHugfxIIuouxtWtdh285hb?=
 =?iso-8859-1?Q?Tm6OjZutGpQ5V+3fBJNPgR+/TTBtlytiJMWkhhuecdxAySwriM4OhaD5qD?=
 =?iso-8859-1?Q?Bf2RUSM5PDmXLx4fbG2T9LxW/DsFWzy1D2726A/+cWObL+4DdsV9fWmjR4?=
 =?iso-8859-1?Q?sQ/Qo9dO+DawQBOiPfqeExJRh595/fu9zME8YdHGxUbTaP92heep/X9KRa?=
 =?iso-8859-1?Q?EZOOfmCcn74+4zNgE/czeOCTUCXGHWF6UQbaW8DfKidOWiuW43gBVkbvON?=
 =?iso-8859-1?Q?EmEoYdrYAy5Cb7u4VyS6dOvJ1y90naBD+dj3YAsBfCbruivH9p2VymcL3b?=
 =?iso-8859-1?Q?qojlb0opzlum0MbpHHFOKLyOAYLy7CutDlKjm+98N9Q5aKMMfTUzwwUlIM?=
 =?iso-8859-1?Q?zQMVh4IdUUg1ck5Bmctk1yQ090D8B8Zd2jeU+5B/q6mSx9N0rDZv5G4e5E?=
 =?iso-8859-1?Q?1r07iW0zttVP5T3XxXho4d6YocNnctpf46Eygvpp5yZBy7aR/bkI7Vz4pi?=
 =?iso-8859-1?Q?BV7n4QO3cRb2fAzNIbjhHappFIzRhj9cwbubwbos5bCMmTr7nhG8W6+RPR?=
 =?iso-8859-1?Q?9Vk2hZkcqSHMMu0NS0aNDvaE2wrApiQcgMqiRWk2V1IG0ZnP2S2L8thmlU?=
 =?iso-8859-1?Q?J6hFwq1YKRYJpvBZQ40Rl3XbAjicl4mQsZq80acT/aEW2b9IhSY6CCzI2C?=
 =?iso-8859-1?Q?qHftEIDtziPSXD064vmZlScUPyuEuQNy55Br5VIGrGkNd5YALEBORshuRZ?=
 =?iso-8859-1?Q?Y4OxR7OCp1dTEA3ThwOlivEVii1g7Il66lj9CGfx6ZVgCjPUztAwOqaLIR?=
 =?iso-8859-1?Q?EJvPjLuxj9nHaRDk+8RICq5W0NTzIw8JKjGX3cN7ZhtM7f59BUh9dv7Yh9?=
 =?iso-8859-1?Q?bNe61YaoNbuajJMqXLNyhoagLF3UTlMWamk/jk4ozK1gccqqyMzxJK5TyV?=
 =?iso-8859-1?Q?R2zTx7caacvEBuBCytzTJz1xFBvMxWqZV0eBMw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0C6rymdL21AL12jE6I5rQ+EQxlbXbKRUDJeBFbJ+kJ5aSHK9nT1ezrMPpK?=
 =?iso-8859-1?Q?ovYjv1XXMM8uw3EIkNJo+FK6AWZrW0avAlEj3Tea9x95XwzvZgYwymngUJ?=
 =?iso-8859-1?Q?M6k2ELQeU3WBJGPQaq4tPB9J260arObRCdA/ydsXnAunq1CTsmIQQzFay8?=
 =?iso-8859-1?Q?QHhEtMV7iVAHYjmIlxPleKOqlSsXpIX9zi/hRZR0TYiiVq3/p5IJ14tHhi?=
 =?iso-8859-1?Q?c7NJmVLStRdt+YqZJPfde34ctQXnZKDdcvk6XgDWe0wTAVBdsp32tzx7QH?=
 =?iso-8859-1?Q?0aRwqJKV/Qh+qUeH0KSYL4DGKpDjgE6ssC0GOK3ukLFKu0HYAqMTriKEUl?=
 =?iso-8859-1?Q?aifOdoNNgl9NQMbxRdIqRXNGgXJiHDvWzaW/IpSPjYlkJvGu0PV1M6X6zX?=
 =?iso-8859-1?Q?ZH14MehxFnmLff54x5NHUds34DVkqy941kdU9kIrVE46c/KQe1Y++Bc9kX?=
 =?iso-8859-1?Q?R/Wle4mVksnOohQcRZT/7wtJR9qsPExhbUS0QoAHoFpHmXDuF3+uiBRjbJ?=
 =?iso-8859-1?Q?TqD6IwuGh3DGQIj3yL6Eg7ctyMPF+JRQGteZ5Wo/5Pfk/4Vw1Ld9j5MV2y?=
 =?iso-8859-1?Q?PeJpTwQ1N+fIihOf6prQkdT0vYHRZkzcoxxJ/xTF41JTyIVQ/vtJoCM/ke?=
 =?iso-8859-1?Q?+W8hqrPar6TLK08hgpW//sLplwXf+YYVRoUzy5WYAuusAGoaYfegOFG9bZ?=
 =?iso-8859-1?Q?zgPZemRicmKVWKfivUMFHK6e8vk3T8CJuqHuSjJfYty1S/6g8To/GAaDeN?=
 =?iso-8859-1?Q?3t/Y1UQVHBLHn2iMSVuHjAoKLZTSk6nzSbLvjpEE4PY4OB1WOEnlSL7JRN?=
 =?iso-8859-1?Q?yYwF+OsXY+w8SBXOmFptVgutjji0Gi7fIduSTqyKmz/NznBghcwLJK+Uft?=
 =?iso-8859-1?Q?qvOaBj1axSmNHyIpmb7AklyApY/uTutDAEj6zcA/KGxsRQLhEJGy2UU5/M?=
 =?iso-8859-1?Q?JlWPnw3Mnwh+f2TDIwfkv+opgAUeEVPXTQ1787xWbl1vM2C6mpbEt6QPdR?=
 =?iso-8859-1?Q?ZS07KKllJEGLy//NEEBYRZxOZHik4V0kMJYIsY1GFwkNmmbiXWJOli1Pf9?=
 =?iso-8859-1?Q?2T5DLj1SkWOKHfrlyPykwO3JAmv25EFZnlG1v2cCSyS+AS89B/EzWko3bY?=
 =?iso-8859-1?Q?4+uF/kz8DkXwZmrAgLWhA3dWV194WaAS5cXzdiosDkyXVNe+pPm3Z6wSHc?=
 =?iso-8859-1?Q?GCGUvWE6LNyF+TtwJ41RjLRQK509vDVRO77GupgkS6AnDl9tIhW4LT0OaK?=
 =?iso-8859-1?Q?oVH0L6mOm/urZkD7kSgB5q9zhh3kxnDXPGPSBkmYqFW4ZC+VCR7W+8cIEZ?=
 =?iso-8859-1?Q?JM0TIf5Id77vOKD0Oja2T+/89Qnh8snJVIHz2qUnemPgKh8A0zLOyZ4fpm?=
 =?iso-8859-1?Q?DdTOwTH/iPYUt3cIOXZpfyWmoppJhQ1nKhGUYd+VQsE7t/r54s512Jmtbs?=
 =?iso-8859-1?Q?ao0953bd1bhxqUzjNpQue3OSYiXWgz1HU/ZmsDkxxIWSDXUpiLwzzUKBD8?=
 =?iso-8859-1?Q?gpDQMmMlrVfr2CS5Aih9y0H00yRqyH/sufxs1PDaR0fpcmptg3waI09b1G?=
 =?iso-8859-1?Q?VNrm67KEQqnkKlD9gDGmdOrOnnFSJavqNvAQPiIVHzYTQFdT8yrUIM9BtO?=
 =?iso-8859-1?Q?qFYZMw/buZKU0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c124e5-5bb7-4ea6-7de3-08dc9dd45724
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 15:57:29.9823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LMFNSqbTaVygkv2i90wwkOeFHCyO79p6TKVU7+vQagvT8ELCx9e0xTnj3csmmdq4MgWYXkr742f5NbAtxTo16A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5231
X-OriginatorOrg: intel.com

>> The bits in the secondary vmexit controls are not supported, and in gene=
ral the same=0A=
>> is true for the secondary vmexit case.  I think it's better to not inclu=
de the vmx-entry-=0A=
>> load-fred bit either, and only do the vmxcap changes.=0A=
=0A=
> Right, we don't need it at all.=0A=
=0A=
Hi Paolo,=0A=
=0A=
We actually do need the following change for nested FRED guests to boot:=0A=
=0A=
diff --git a/target/i386/cpu.c b/target/i386/cpu.c=0A=
index 227ee1c759..dcf914a7ec 100644=0A=
--- a/target/i386/cpu.c=0A=
+++ b/target/i386/cpu.c=0A=
@@ -1285,7 +1285,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] =3D =
{=0A=
             NULL, "vmx-entry-ia32e-mode", NULL, NULL,=0A=
             NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat",=
 "vmx-entry-load-efer",=0A=
             "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NUL=
L,=0A=
-            NULL, NULL, "vmx-entry-load-pkrs", NULL,=0A=
+            NULL, NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred",=0A=
             NULL, NULL, NULL, NULL,=0A=
             NULL, NULL, NULL, NULL,=0A=
         },=0A=
=0A=
Or do you think it's not the root cause?=0A=
=0A=
Thanks!=0A=
    Xin=

