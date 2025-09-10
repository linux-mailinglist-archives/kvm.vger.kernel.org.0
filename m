Return-Path: <kvm+bounces-57192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62092B5151D
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AF35443B1A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F913176F2;
	Wed, 10 Sep 2025 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YKGZCT6/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6436D30AD10;
	Wed, 10 Sep 2025 11:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757502679; cv=fail; b=XShWqpZaWpiyUgCbUObSC3pxaa8MIVP+PozoIb3Zp9Zv68rUU6vgHQ61rYT7Z9RrCBHWrH2zOhctRBDCpK7hHo77HLBf+ycTQB+R4di/Mq35Gy4L1oT8bml7fug4WZ0aZpCaiW6PFt9A92+O1mBMZPOd8ci5PmIsgrEHdcOYH44=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757502679; c=relaxed/simple;
	bh=EGOfaTfMKd1th0WwKk698kzRFp1GecqjPor3uTjt2w8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rxS0iVSMVMPB2AMUYEFhL8CobvzO+awyY1mYLKtAMhjZbj8ErM9MwCYpjVKdgL5uUKM/XXrmjYm8lzic6HPjp/f/i0Ie90vlMs9e5BxRSciOxVBVEyVhSnpWxm7Ia3BYx4PglzPSDo4U+wOBjuqFpRZOggKSV2HfYSuAASb3SiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YKGZCT6/; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757502677; x=1789038677;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EGOfaTfMKd1th0WwKk698kzRFp1GecqjPor3uTjt2w8=;
  b=YKGZCT6/XkSY81Gia85x/4VqR5ySb9ahjBaM0XL8yy/yNIFp785b9tt9
   WoAD1GM91z5RgdXwG83mNw9j5+eFrgj4A+XCU8iq26SNeV2kGIfqlVyCG
   EBEyI2Iq5sEAS3h4/Wmr8Y1bKoYHWg1jjB2OuFmQCkY/VeBtNxGqNBkGN
   5Dg0xq5mMyF9CCeBViEFfLrYfvUTnUNbWgbqxGXgT+ZX4Kkt/GxLimev7
   x92jI+4iNpBzlNzPpA8cDtXPW2HE696oNLwDkNjTavCvmo45U9tNoq7kz
   wLJQyA+bma1iFRTxyDV6zIwhKXRMBiferqqtMMewyfGaY8YZx7iduIvaa
   A==;
X-CSE-ConnectionGUID: OIBlTgn0SlGQ9GUyI4EmvQ==
X-CSE-MsgGUID: g03wy6QlRLeFTHtQ+FLdXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="71224032"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="71224032"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:11:16 -0700
X-CSE-ConnectionGUID: A+zMeBQXRISe1Zecx+c+Gg==
X-CSE-MsgGUID: dd4KIGy/S2KoLXnFWd9mAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173814273"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:11:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:11:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 04:11:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:11:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mf2JhZRHzfX9yRQaUA+kQ5vQ+xQq9tthmE5tlKTSzxGfeoYYc1nIMyPnVMzNKzxuIBTC9fPtD4Kp900iB5P0IjLQ5CCTDjb0hamOHYlfq9me7TkzV25ZZXQLbHjp1MucNhwcpYvWsOUZEwqrvvCWNKE/uSCIHKjbKCqbEi7WiW88yri/p6PFKK+xIS1Tlas8lU5W59eCRWXnbHLN/5M60IvYoJkBhZxa77kJV5m5yvB+EzKgeb0PbygOOEAJH9xoXKqhwdqgfgo3gTXHrIMdlUb2jjs5cg+LLeqdMtAIFxZWduZ3iugu1VWF5/L4yKeZUp1YaAOsTjWtYjutpPYPzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl9p6U7spL2k5i2oKLzZNj5Dx+9uFalO4AlFLH8B0T8=;
 b=ywgm2lvqoWN0qMG7AK8kugAy+oaQCZaetdc3p24kPfgffxMznzX2S0OA7lt7l9EvHjHE7s4w1SGy/EfdSwpNY8AlpzNPBIyQz/9iZR0bhw8KNK7epJ2FujOn0+zp1m0uguk5oe0agAGqqv3kqMCxFRkjacsKP+O8oywvce1J0L98rKk/CPhAQqHq2FIU2TU7kQyeHg54VaYHYhfNRE/wqpnHvpxLOvD4Zi+rTN7GHHx8EL8GVmhDJFF+hpT1yWbNHkokn9RM+cwM+DoGLwsRsaUl20qWp37LDY8N8zgY4Xwqla8KuIjwi0IfVhmDSyRHezAkqnejtNf9QHTKbiv+uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN6PR11MB8194.namprd11.prod.outlook.com (2603:10b6:208:477::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 11:11:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 11:11:11 +0000
Date: Wed, 10 Sep 2025 19:10:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "xin@zytor.com" <xin@zytor.com>,
	"brgerst@gmail.com" <brgerst@gmail.com>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pavel@kernel.org" <pavel@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "kprateek.nayak@amd.com" <kprateek.nayak@amd.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Message-ID: <aMFcwXEWMc2VIzQQ@intel.com>
References: <20250909182828.1542362-1-xin@zytor.com>
 <20250909182828.1542362-2-xin@zytor.com>
 <1301b802284ed5755fe397f54e1de41638aec49c.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1301b802284ed5755fe397f54e1de41638aec49c.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN6PR11MB8194:EE_
X-MS-Office365-Filtering-Correlation-Id: 6349b2d0-8463-45a2-08ef-08ddf05ac002
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DkNiQbp9zlXYCdmKDbX2H0EZRIgiyyDwHJXeA6G1NSMsi6oOXG+LdMMjqb/i?=
 =?us-ascii?Q?ey8Xx3euLKkDNtkVe8dxBj3HtM++kO9p9gbEja/QNh9dN+al+dW6cx/iRtTJ?=
 =?us-ascii?Q?UjZSNd9IiM9mUZM4zuYpaA20nOlISfbpOrg/DG/dfWPJ6ztMiE6Vgn/mbaLK?=
 =?us-ascii?Q?cFTMiGu8tWJmo+RAW3ADz/4I8ztUnRCU/foWIzSe7BljWZOQE0M4pKgyY+PH?=
 =?us-ascii?Q?SOh7fJmQgsWZ2uwC0sm7vrC+RdXaQSKXbb2WyOkz8h8DiKbrB2iAt/XhdCt1?=
 =?us-ascii?Q?Mnf+Cc0v45d5oDPYoCUGiQpyUBrKfdImbpEEaIs61RrocXJKcVGlTrws8+EW?=
 =?us-ascii?Q?rYlcXctJS9M1u1bT4ycXADB0xQGOzFyBot2fhMNOVVJX2hJ1oCb7w/ugjjek?=
 =?us-ascii?Q?93DUhRC/JDHSidGE8nk79TNkwCVZs2BcJdzieTnknudZFfj6UYw2dEQRp8rI?=
 =?us-ascii?Q?jC72Hhf6IWrJ61F0oJqZlw7ATZHp3oj86smXq+mDpxK464XBUV1NLj/NOc9u?=
 =?us-ascii?Q?2QYAUkeRfkkZqulIdBwtd2NIlRKP4Tv/24cgtpPjeBUxtepz53IHOX0SZpcH?=
 =?us-ascii?Q?KbarH+Nvo7hJOIM8z36Hcz5kGQqsn4p/OJYWc7zAsKzlAkRL75+e0yRcAuq8?=
 =?us-ascii?Q?qp2t+S+zEKavAHD0NCs2exWh0Wb80fIx8nt/hBqO4OyF9iaSZRSXESMLRf1m?=
 =?us-ascii?Q?uVzeSx6hGQhAhhe28WoU1jXqIniM5Wo8gjI9VGZiqst/b7j88sKaIq0Ey4eG?=
 =?us-ascii?Q?BVkkQ4+ljx6G0XJMaRin3E1VNjDgU+t0caWiCk+hVn5uwArNK+oeYSQkjVxB?=
 =?us-ascii?Q?5vntVng9LKVlYmKkdYFchf13+a/O9phaELKyyvNLJ3R77C2ry1d4vu+a+pWq?=
 =?us-ascii?Q?ZqMlqMtLaXEhFMBInjx+fYz4jYyyT5ya6wocjLNvY2JwRqDiub4T3rftivdT?=
 =?us-ascii?Q?ulGvzWcAx90/CLZutbzvg41dmWsuvBZKOV7MLFttMzxqcPPAmKLEvzHRd+6t?=
 =?us-ascii?Q?fZbT85RW8e6dEN4NeaJHFxQXjUZchbywIqhOio49foCRrPB3NgbXfqdHbWqM?=
 =?us-ascii?Q?DOVyKypCH0cJwJjycFevy7nAJYPOhuzc3jKnRpCvFmQBio3qwn0tcbm+3qlh?=
 =?us-ascii?Q?cqYvSeMVzwOS1UbpDM7xnWatI9U6PTyaMwjgYtUyDWyeVsbgP/YQGclyXPtp?=
 =?us-ascii?Q?Csrf6H6+RwH1VOK+pbbliJvvt7idI8hMAijn2OpHUi41krEa3uaddMqxNXFT?=
 =?us-ascii?Q?z04xfdFBr20qZP/A/EEAVTtoSPG55xnpYFhD4253z/cKULfF/rzGsjxJF9RJ?=
 =?us-ascii?Q?KFm/qpwlqsxwX9edi6R+82xSL+fhuKnuatCTJsYIna8SuB7vNVhAXBgcGSf+?=
 =?us-ascii?Q?s4TXaDxMPuq4QJ4wB0/2jDaJaEoC6cPofLRA6LD3IWi4hjWJQnO9tM/9r9Q3?=
 =?us-ascii?Q?mRKnSKOuJkI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2tLbk/j9qCmlhlhdKsq5W4Z/jefFhU1rsFZ+wvZOZCKlXkOPSP8EgL46RW8S?=
 =?us-ascii?Q?snCTjwFnYbnZWv9HpPOOITUfpvwbWMBsQzGlTyEQ9y4AlTE2lrdUl5Fq1Woy?=
 =?us-ascii?Q?5PyVzpSngua3/oLd0i/7XUbHTUKgsWL/F9M7FETos4z+5tJFmjC+6BYw90ob?=
 =?us-ascii?Q?F1hWeMfJLcww9Zk1ZD1gmuNQn+hqFzaSa37dWvpQ2w6Ynkn6hswt1Lp/LC1u?=
 =?us-ascii?Q?3tS/tY3nz8YGXe52d4uqN4NjPkYQC/zT5VySc19WZd7z4Nssz6Us7qhV4Nh2?=
 =?us-ascii?Q?5TXnaFUEkGIN6HIWoAroelMZ7tpDN5AEiHDAi4rji6QnZbxcFgHXT6OBTEkb?=
 =?us-ascii?Q?hwpYZO/Jf81iAnzRegsE1le2OTO7qHJSIFpF9Y9+ojvGY7Jw0IC2mCdPQzPS?=
 =?us-ascii?Q?AUTEO2Hfi+G0sZhJcanO2cFGZnoa90UxnVQsqtA5FRlzp1AYyv4hexRfivS5?=
 =?us-ascii?Q?wrPM/wdRybrrEOt0kQPJ5RzPhKfphfUczIrqHiSkCSk+U7EuoQONImdmxk+5?=
 =?us-ascii?Q?PpD3aqnAxmT267SkkFlHyuov2yq1fI6BU4NKArqy54aL0lYFU8qJnxsTv2Gd?=
 =?us-ascii?Q?CUTIGAVXFEmzcb2k4FaNVt+Ct0LkHoSvWmNZP8Hcf7KtVdGEp+a1+9F0bqhz?=
 =?us-ascii?Q?m+ggL0h43Z5gSOauyhk35qcFXOVCOqHNaWED2+HSPg5YJ00jgkgkf+crXxrO?=
 =?us-ascii?Q?zNk0+Huy4aw2JmuL6NNC+OkLPS2xoz/QqnGNTesnWFueXf6FF3PTXhZNJ1R4?=
 =?us-ascii?Q?MgN+3ylcBkOqbUflobWrViz6v9H6JCPP1Ak+lvZxIDkvruxlHM0aAXdefNgR?=
 =?us-ascii?Q?KKVlTQYG+a5dLcEWYLieexAqTnZWDgWHab+PBzH33J65gQghi5q1JyYRr2cK?=
 =?us-ascii?Q?MvxsAQ2sMpcIAlwAmsSqhuPeDq2ZsOcw+toy/khI6PCbX2Hbn9fQwT5nhdr9?=
 =?us-ascii?Q?UBOPxN4Ha/4HW1umlBQgDe1cOJafv0c2d2+zriseAbRIOUk7ebm08b3WaLZL?=
 =?us-ascii?Q?uBxaJ2q2Mka6ukgLdPZ0Cd/d/IbCnvF/3rll0OEoPpwRBTrnUvwFoo+gIUHn?=
 =?us-ascii?Q?aOU/AjESqBGff44s4MZWIihaok+Wj5dBLSl/wg6IYkp4Vx4TZA2/+r/4zC0C?=
 =?us-ascii?Q?X33Jwe7ZGIGWVdUlYBOvVLUvduN+FeaiASrbcsM4MfnG5AD3RXHT4gUlIIWe?=
 =?us-ascii?Q?XNmLgNARZe6mEdi/E+5icjnZ8E+ZZxUHM1vk/758KsZZEVrKdjMCcSt77U0Y?=
 =?us-ascii?Q?qNK/R0nGC3nw6hSDpzG64r1qRIm1gFQ8G4VeApmioZpyIF8On3coy6YmGvPa?=
 =?us-ascii?Q?5MMglqNWsN6sU6VT8Wkg0/lJt7hv9KfltSsbCUkKjNFy0vAo6RopC6v1mxY+?=
 =?us-ascii?Q?79BlGD0GMBwSpeBf9Uco+3YBjA5+vQJrJI9KHvKhzmFNRhEvykD6yAVkZHOG?=
 =?us-ascii?Q?yURVW77KJVXlp30fMhUTrUONUKH57+zShBrsAhGXfVrJXJ6Qre3tO/e6WvOA?=
 =?us-ascii?Q?6QERKpe2rJL1dtBsCoWrNgVrfvfjFyA5yn5/OCCyWbz7U0lHtfBPmlGiTHx6?=
 =?us-ascii?Q?ajlEVFahw1Ie13JujcV4u08x/5W6LaEsjm95rDiW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6349b2d0-8463-45a2-08ef-08ddf05ac002
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 11:11:11.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mfh0Dsr2YFmPiCHhSoO7xTvyVQzym2FMg2d6UZQvGfaR+ZKsnbkEmRL7fjIc/MpOBmZcTo0UDD+nuDJL9cjYHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8194
X-OriginatorOrg: intel.com

>> @@ -2551,6 +2636,12 @@ void __init arch_cpu_finalize_init(void)
>>  	*c = boot_cpu_data;
>>  	c->initialized = true;
>>  
>> +	/*
>> +	 * Enable BSP virtualization right after the BSP cpuinfo_x86 structure
>> +	 * is initialized to ensure this_cpu_has() works as expected.
>> +	 */
>> +	cpu_enable_virtualization();
>> +
>> 
>
>Any reason that you choose to do it in arch_cpu_finalize_init()?  Perhaps
>just a arch_initcall() or similar?
>
>KVM has a specific CPUHP_AP_KVM_ONLINE to handle VMXON/OFF for CPU
>online/offline.  And it's not in STARTUP section (which is not allowed to
>fail) so it can handle the failure of VMXON.
>
>How about adding a VMX specific CPUHP callback instead?
>
>In this way, not only we can put all VMX related code together (e.g.,
>arch/x86/virt/vmx/vmx.c) which is way easier to review/maintain, but also
>we can still handle the failure of VMXON just like in KVM.

KVM's policy is that a CPU can be online if there is no VM running. It is hard
to implement/move the same logic inside the core kernel because the core kernel
would need to refcount the running VMs. Any idea/suggestion on how to handle
VMXON failure in the core kernel?

