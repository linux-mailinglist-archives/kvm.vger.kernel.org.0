Return-Path: <kvm+bounces-42794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A25C3A7D363
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80CE1188C738
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 05:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDAC155A4D;
	Mon,  7 Apr 2025 05:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uo7sTbKO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B0E1367;
	Mon,  7 Apr 2025 05:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003041; cv=fail; b=U/1w5F8GxX2GEXuIYMD0UadkuFxteNY19ugtz5yvWSsczkQzmSj5VdyEBeDSLhhOPixh1hQS3CKsC9++nc+vt8lCmG1RNpYYcTGWnAvzAfs1xRASyREUs97O5190YWe6PPogBRCtd6gd+pzDJgwKcXzElrvomhNMu5pMXraIM40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003041; c=relaxed/simple;
	bh=RA83Q5KUMl9GzDotn9XzG8aaJcfrKp2GmRqlcKpx3UQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BgZF0JMWmEk1psLTxfdBKFnLaFVkicvyEg2LfyOVJguMvnjaxMIPBQDLq+sQuHuSlO1Bj51owB0Tt3d1qn53X/2LIVuYuR9nspTdd1xL2hDKY5QsbUZDc1MJRrvO3Zodn2GB4GU2Xkd9C03k3x4FXtnZnpnqYNs5OworicLkdPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uo7sTbKO; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744003040; x=1775539040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RA83Q5KUMl9GzDotn9XzG8aaJcfrKp2GmRqlcKpx3UQ=;
  b=Uo7sTbKOBQfvMGVi9mdE0H4AthZhDReIZHEUm53zzcL6auRK63nVUvRM
   ahDqH5aJxEiVuxfZMFZ8m1jixWWFtjjHlv5ZI6FoiaHwBOUZGL34vYpir
   7EdsVBGt5rKh34K+EZ/440MVtZsL7ndCcivPueU2vMDpvkbiDDNCEzaLG
   d/50vPw41tpQtcS1+odPLnyRqPGcIoACNoI75IwRwLpZF7Hk/x4Zn5DqF
   l59laVkxhPWwuCMcGJ/xY0muakY64L0Td85LQCpEIIgU5KEQibXk5Xgqi
   LWdXj0b/JpSbZO2WM8l7yswaXOPU0JOtIFbefIXbI5BXhau5Q/zQ7Y9DV
   A==;
X-CSE-ConnectionGUID: nequERcXTICPg/ADfTtXow==
X-CSE-MsgGUID: u9D7RGIFSViGbcTtQ3UdOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="48083638"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="48083638"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 22:17:19 -0700
X-CSE-ConnectionGUID: YEqiUp5ARUOfZ2yKNG27jg==
X-CSE-MsgGUID: WvcvkbTBQ1Kle74a7yhUlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="132990541"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Apr 2025 22:17:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 6 Apr 2025 22:17:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 6 Apr 2025 22:17:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 6 Apr 2025 22:16:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e11koatZK7toql0nYsW8OxOzIdkh8goZWaWbvSyHAEJyc4a9Z4OfX09TJVi5ip6ylbWH8pSmMgDi9DXTSKUkIJxLBa9gZXq6A6+rFYgJQvaTJmYYzNt6OozHEkKsTeniJlPi+jwBY1NiFPtBIUKRiN5PkmgQAe5B3tBHyDigwUMqurn5hZpuq+caBwm3jlIk67AVty/JsVCYyc5GYGdivuNT1s7upTVMSnSAMP+7E4hZ30o3mNcquAI8IdP3kKVHxUPtd9e4VfpuHuIdVLl6eApCyG4/o8Pyd7sgakcdsne4l4RPylUS3Wb0+FuO0fhQ2TGFYf5g4WMmAqWhpJUZqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RA83Q5KUMl9GzDotn9XzG8aaJcfrKp2GmRqlcKpx3UQ=;
 b=pOwl31EQoyyWdTRGy4ybT5bfJlTXNIq4JMzt7vW1lDj2WQHmOWCaApgPRNUvFi6lOWubA8fubNcs3+QVcl65Le/Y34SW5PK/+YbMw/MaHT13IgGEanKd7kpx4vg7JDTjicTxq/TL6zqZCz0RerC8LmfSqk1sPV8iMfx5M1tMhg8YIf9WQp6ch068ggA/GF8RhTLZpLZTqXQ6GJJLPZq/FQ83bKPTZ03JC42aUCLd6Py9JX4keDdQHuB6t15KokZSIvCPZmOP7pyyYtaGtSWwfHJqZcVpxRpRlpOmIzwDHiedcpygHrKTuiXlwi4sBdFItJyqJYMbpIVa30SVd2uRkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM3PR11MB8716.namprd11.prod.outlook.com (2603:10b6:0:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Mon, 7 Apr
 2025 05:16:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Mon, 7 Apr 2025
 05:16:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Philipp Stanner
	<pstanner@redhat.com>, Yunxiang Li <Yunxiang.Li@amd.com>, "Dr. David Alan
 Gilbert" <linux@treblig.org>, Ankit Agrawal <ankita@nvidia.com>, "open
 list:VFIO DRIVER" <kvm@vger.kernel.org>, Dhruv Tripathi
	<Dhruv.Tripathi@arm.com>, "Nagarahalli, Honnappa"
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKIOMwFCrbJIEmx0MTBFQvwabNjFiyAgACMrACAAC5ngIAAUDEAgAsZQcCAAsKCAIAl8RYQ
Date: Mon, 7 Apr 2025 05:16:23 +0000
Message-ID: <BN9PR11MB5276A08041ED09F4B215D50F8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250304141447.GY5011@ziepe.ca>
	<PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
 <PAWPR08MB89092CC3B8587E9938CCAA0C9FD22@PAWPR08MB8909.eurprd08.prod.outlook.com>
In-Reply-To: <PAWPR08MB89092CC3B8587E9938CCAA0C9FD22@PAWPR08MB8909.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM3PR11MB8716:EE_
x-ms-office365-filtering-correlation-id: 40c73c73-6cf8-4030-a605-08dd759356f3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?1Rf4l21guosKodLlBE81ShZaMIRgXurNtwJ3lrvbOg/McTNQhdb4Ab0jF0eR?=
 =?us-ascii?Q?AXyF3AKqz432jE/jbw0lO+hwbK+EwAyrJPu7houD6r4CZDm0qLWTTBqlVJ85?=
 =?us-ascii?Q?Dh5UKWlo/Npkvk7T9Ottt+fTfDsVWoOV2JqJqXnFDdkyhShgqo8rpY9/nqRj?=
 =?us-ascii?Q?pO3m281rD9Oefo26P1iZHj7wRVQSp4A/W9BjLYNHDH+2gv5tmiYNsDvAYNY+?=
 =?us-ascii?Q?JFa/wg/7n7XBtMyLnImV6DCUp045XYEvsMDXc5xACshRBx69dj87aGGjwA2f?=
 =?us-ascii?Q?pYUJUU18lZVyfB6kPq2yD0uwlZqz45IoFVY3VQ82uMmIkrW+NJNBO5I7boha?=
 =?us-ascii?Q?L58sIP2fafbyQw6YsRB/ccjIlVt0Omlm8YGnE4ftk28lSRwxju6fUMFqZ37a?=
 =?us-ascii?Q?kNwmLhzFyXNiQ9cUdEmcHEG6JImHbfUc8E7rq3+UbPY+IeKNZaZT+pqYlmhd?=
 =?us-ascii?Q?tGegcPLGIJhyEcQs2/oTcHuJgoVYTfpqEOK+J9NNwRIUIdeORViribKoPHL4?=
 =?us-ascii?Q?wk/tBqalQQz6qEe13yDOelPBTBE0r9Lw7C6lzsU6yrpfRGlaVbhHgAZr1IVl?=
 =?us-ascii?Q?44PwvouJFAKQuinl8cbaScnk4/2pVQ2ckzyl/HZ24byC/VTYPNsitXy0T503?=
 =?us-ascii?Q?mBKfwFbsd2bLLbZknG44sWHdpttpAULZOrRwSQwqcd1kf3oY9VtkFqS7v/Cs?=
 =?us-ascii?Q?nAYCwWpoc4YxyfKY/P/D48SDQChXYP9Qp37F8O5j6KSO/XA1YyHlcYPpvxi3?=
 =?us-ascii?Q?jMM5LpaZFl6uECkjB+jp0XLw/nSRd6cj0GBBrsJoeImJh3+dXazvWoxAFORT?=
 =?us-ascii?Q?GCD9lcwrutIv0ctjwN1d4pePv79luuv35ycGJ5vivBvAr7DfnIMV8AMyxv5t?=
 =?us-ascii?Q?O5OlLD6Waon5/T4NKfhAaOcC6wsfsqyCWdUzSWNWUqbfjiPl4fgYH+j/oKYk?=
 =?us-ascii?Q?VyreXXdP3dd9aaTNzQH9aiHv0YAm8fp0A5nlZpJ1IW2MainEdacmu/veCa1y?=
 =?us-ascii?Q?rHyUsApmAm7p+AIKLXEIiWigjNu75OAla6v+veWQkZPUfWLqepMCcuR4P1+U?=
 =?us-ascii?Q?xF872882sg+b9uh5gSUD6S7nUdxXG5dIZRBkrFzaUSdDoejkDGk9OPZ3aKTv?=
 =?us-ascii?Q?TY3ff0D4JeXeBENk+oQ18oFc1Hh3ihqNC+eM8UwZ+DgXTCpM6E6pCafwzY7h?=
 =?us-ascii?Q?qMWbN3BPlNRppQ+DWNyINjejz05JJ1En/RCMzVqA/5h/oz3IisqUaudFWUsr?=
 =?us-ascii?Q?8VN02T8dlEbrp/ObAHUKLFbHp347i5r73V8nGi3jADhwSGW7WehfzaGM3W9L?=
 =?us-ascii?Q?WHx0sPRJa1oD8kjl86deOCFMTwOsJnBPN8Bp968R0Y7NyAxX/SPba46vBdiV?=
 =?us-ascii?Q?BNlDC4tLeBfXXyVCR1lluWZu2VzwvD0xjHk8qAKPTaDYkakR59HEgMnoqaQu?=
 =?us-ascii?Q?utagyKt0WsN3VZfj6w8uV+TV1ZaJF3yI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RhvuUcC6N9x6rpHXcQiwAxFYWYgZ4AW9/1eWk6f5CvjWihDTw9/c250gtaVL?=
 =?us-ascii?Q?Xt8YIksaJQR8wRqhy6ic72sviEyHqpjt06jXR3Aqq216NjvPd+nB1wxXIroh?=
 =?us-ascii?Q?GkJ80Yb9W7wvxl4fhiZsY0h8JO/c2gvmRTm/jECmfzRRIxITc2LIJvn9e5Pt?=
 =?us-ascii?Q?DKQkMd/tu6MJcYZoSwefQLq3xeDgdhKNzb92HSrDw8O47JIrU4rAQFVloqdh?=
 =?us-ascii?Q?Ih5H86GS9YMWJM9AGcrrlweL+uvuHXD9Cz0GAaRpHGIxBbzWFSbBTJLrXM8z?=
 =?us-ascii?Q?GoOH7B4D7eKowTgzIjPL8WdEKxAJEHpZl0zRCvnl3QAi/NxduBuKkuMl4sbp?=
 =?us-ascii?Q?1Vt8FPZ1DgR4Qeh1fi+4wDbN9m0YulzVG8pKLuGIp+64XMlkeihAtuRNbKA1?=
 =?us-ascii?Q?IlZ0I+pJJ26bf7SC9p1uLLol5+euOwa5vyo9Y0Gygvyt4s1z0N9bE9uqmSKT?=
 =?us-ascii?Q?J/xmvivdLQzNI4oWgG8EvVodnHgaa7LAE0kxXaLOZOlARt8CKqCYI1utpTEU?=
 =?us-ascii?Q?+bW4jOKbWZuNcBp/yh4L3WSvKdHip0SF3gKJIjcL+stO6EL9Lj06OZvFWVTp?=
 =?us-ascii?Q?ZLye8lUTuOSenqElmBxo/6/046RzEP3/egdI8VJURjRF1grx777A8HDOQyDO?=
 =?us-ascii?Q?14NSFPtVvc/AL/WdMqP3PMMNbsD0dUIEUt3sr1DsKn3OAAqXFto2C6ABDyjS?=
 =?us-ascii?Q?RUQahAzVzoIt5P8KYyOUJm/jI6QNPxcJRTg+u4ZZ+fjO9C6OIEzaeR+cfrUR?=
 =?us-ascii?Q?hSN15CQVJuUFEfFInptSq3/7SE0rcLAbB640QnzOQ66MOpeOfrQNQzr+YIf2?=
 =?us-ascii?Q?HR8oOUDTCfOM7sPjCDLthRl6qk2gJmCdyZeB6jxwp7m+abs6HZOik4YAP2tn?=
 =?us-ascii?Q?ur/m3EzDSUNZq+aonqFjjLTvMdUu/f9BDHt5MJuJSR51rWw5ThECl69/8unj?=
 =?us-ascii?Q?SYhcNhRRljpYgZts3480Sri1NIbsQhn1i+LygjKE2pY+t4/PSwu7wAKn/HN+?=
 =?us-ascii?Q?gMCK7XVTrla6vr/GL8FEiwA0B5nm9VEG5CDw7gRsUPfanqd4haABB4w8iEru?=
 =?us-ascii?Q?FGKu2GB8Xfp8pQWUm4BVaguMm8rzOabaUfsv+RZg7SOBJTqznJvlF+lIt1r3?=
 =?us-ascii?Q?VC0+iWDtjZfQqYaAPD006GthrFKxbWy5T0mhAIacTaBEiL6I4tquZLWMY85f?=
 =?us-ascii?Q?IWndLx49mOip8YHusvD9hiPj4gQOY5V3byhcJF3Lum2Mv/Nvt3G1Z5TVbi+s?=
 =?us-ascii?Q?0kl3qf6T/WTDN4vUXterG18BBYdhEAI24pAZ7kjTkLOjB7PJrkk70vwMAQrR?=
 =?us-ascii?Q?vEPulir+TyGm2HxEi3MxVoPv0qrGBnV1/k5bPV1HBF7MFPDgnauGNoDOIkeF?=
 =?us-ascii?Q?00TbgZyW1kwd89CzqbDfd3qcKPiPH7YJPIPLvnFRcxd8q5RcHwjNvih2Yr1M?=
 =?us-ascii?Q?ijqqmbG9jpWBuMJK4BGMyq0DtsSbhQomP4Hshk2N6WTDzTjE/roYEdsak1xi?=
 =?us-ascii?Q?rd8E2a52/rCd9AzcDXkLg8p4jgJJH3pM1W7OfPJk8LwozAx3FamrjogOeNUf?=
 =?us-ascii?Q?OCg8fA1b5Qo8dvc2Fc+aKfdxWIGpIoHOFyVwFKOe?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c73c73-6cf8-4030-a605-08dd759356f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2025 05:16:23.5564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WwTUW4wwkb94z6cqPJ5RFf49tZTfmkAygDOX/WKqnmm9mlhGKRbdpsrqtQpeU0CXtWjx3/i/owCXnpHfhNCdWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8716
X-OriginatorOrg: intel.com

> From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
> Sent: Friday, March 14, 2025 9:49 AM
> > >
> > > Having said that, regardless of this proposal or the availability of =
kernel
> > > TPH support, a VFIO driver could enable TPH and set an arbitrary ST o=
n
> the
> > > MSI-X/ST table or a device-specific location on supported platforms. =
If the
> > > driver doesn't have a list of valid STs, it can enumerate 8- or 16-bi=
t STs
> and
> > > measure access latencies to determine valid ones.
> > >
> >
> > PCI capabilities are managed by the kernel VFIO driver. So w/o this
> > patch no userspace driver can enable TPH to try that trick?
>=20
> Yes, it's possible. It's just a matter of setting the right bits in the P=
CI config
> space to enable TPH on the device.
>=20

No. Before this patch the TPH capability is read-only to userspace,
enforced by vfio-pci. So there is no way that an user can toggle
the TPH cap by itself!

