Return-Path: <kvm+bounces-52906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27268B0A6F0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:16:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5D9F3BA430
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5EF2DCBF7;
	Fri, 18 Jul 2025 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MmFqV9jS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4C171CD;
	Fri, 18 Jul 2025 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752851742; cv=fail; b=F53biyUSiZ6UquUbAukwM5NAMA605MPiO3E5CLGm/mj9rBfkD+MdK3v2YZmTd3DP8lDlOvji5ui49N7FLUjziFl1ltHhMVgmMiQ5uERSO18QTInUo84a1WzeQ9AYgyvrlbIXdq7IA/YXdVMwby0rKEtu21tJzkhySwcjKngi9lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752851742; c=relaxed/simple;
	bh=y3a0mXq1AhEjsjb+UeTwuzP+8WBO7TYeJjFEG8/fznI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TWCFFrQTkLfd5ddUTYMHXoO7V4O3m0lYbNcs+WVJAZxigYMPhOQHYOlfRzMZ0KwqVB2974rOEOzfvehTYpOr0D0JrNNZx/AQBhpNJWjzbSQ0J6BeScpoGpv708c18BrY5wgIOM1nfFQGyg5dqKB5+KlPxGfR0R91+uMsnClP7XU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MmFqV9jS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752851741; x=1784387741;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y3a0mXq1AhEjsjb+UeTwuzP+8WBO7TYeJjFEG8/fznI=;
  b=MmFqV9jSogWB8v70dYpKXovYuAn7weZQSMryg9PLUqGGyGpALlpeYMpn
   m4Dd8947lS2xd/oDzMLO1u5TOTG7p5/w5C9Ua8p64p14mnSrsmLX4zQPA
   E+kA5Cu2yppn9ehMFV4HB/GGjsEshurT8kDtC4NxpObZlGQrPsk0fjg22
   zsKiufj1gjcFsGHNZKKkq2WYZU06g/fiondgXO3O2hD1WBIPxFoLLvFng
   gKFhVy/1PgU6wdKopf51WHCh89ShqAnEKu3Ku9aTstLkiBxn4XnctNOSR
   eaPFyoZWxdU7sypG1VOLivq9PqGthuKcRz1dr//dAyCbNb3x7tOjQeMGh
   g==;
X-CSE-ConnectionGUID: Pi4B+qClRKyKanCCtF5Kxw==
X-CSE-MsgGUID: hbhT7jsoTZqFtXf6WzTYRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11496"; a="72715103"
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="72715103"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 08:15:39 -0700
X-CSE-ConnectionGUID: ag6VMur8QxmPZJm60ipXsw==
X-CSE-MsgGUID: wmd3Ipx4SOqt+cCVuR6cdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="163604635"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 08:15:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 08:15:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 08:15:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 08:15:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLKA4P6VRLkY0y4oTGz1vlYXEWX3P+Hw27rPHaqdIXXt2N8oPWD60fgrF1nCoFqFnDcTSsoCTXF93I8sIKK3fLpA8YQKyw/2qRohgPqhl2A3x179qGvuNJ0gnKsAKw4Im+6EFepKXs6eAgBAt4jfdv6RIcoEy3Lk3bimv+UFl95qJCBIujl6Glggy1BC4cjYri1MAlw4VILTgMAkdL353hVkDwGrvfSYV36/CXcuf48ZmB5x9g7fcD81Se0V3+inciLvFPTmaYVFsjzJpvVaXEiOMp7o+A7dHNO11FrogWX6mfDvZucqfWdwKWVnSsrVnkWxiEBB2SpJBuFkKNn8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJrQw5PKYDgnqZNASrjepWyJz2Znmwh60YuWgTE8SHY=;
 b=QHuYQF7s+WoAhceQY2yn4eteGDDCm0kmgOmZlU20+lLt2/d0OOpk0C3i04zwPmvFkGvGa30dICOl9t51f4eccMHFR7tcPrd702GgbwR5LCK9Ugp88HpvDFUT90Xqbo+7I/CvAriSv9cuvi3x4RqEy7PlwSIBODlcIQJR9qxWiHhAy3xiMlbTR7M0F+4XsWyhiNlQEZv9q8ZZUlNk+SdxMLC4H4jU/E0eS/iyUdE9NJm5uxPqWGDW8czUxNqCgoNIpvVX7E+OfoJaexIeBbE/bl9GdPwM+rNYIXmvd+G1KYEWssTYWoG3HAO+NqKjRz4Pl7IDfsMmNz6O+7HNlHverg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB9136.namprd11.prod.outlook.com (2603:10b6:208:574::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Fri, 18 Jul
 2025 15:15:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8943.027; Fri, 18 Jul 2025
 15:15:33 +0000
Date: Fri, 18 Jul 2025 23:15:20 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jason Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Kirill A. Shutemov" <kas@kernel.org>, "Xin Li (Intel)" <xin@zytor.com>, "Rik
 van Riel" <riel@surriel.com>, "Ahmed S. Darwish" <darwi@linutronix.de>, "open
 list:KVM PARAVIRT (KVM/paravirt)" <kvm@vger.kernel.org>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
Message-ID: <aHplCKOxhBL0O4xr@intel.com>
References: <20250718062429.238723-1-lulu@redhat.com>
 <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
 <aHopXN73dHW/uKaT@intel.com>
 <CACGkMEvNaKgF7bOPUahaYMi6n2vijAXwFvAhQ22LecZGSC-_bg@mail.gmail.com>
 <aHo7vRrul0aQqrpK@intel.com>
 <aHpTuFweA5YFskuC@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHpTuFweA5YFskuC@google.com>
X-ClientProxiedBy: SG2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:3:18::24) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: 69fa7e9c-7f51-49e5-bda9-08ddc60df092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?y6UdF76+eewA2Zdpec0MYnji7PUrYr7aRh5UiwFNyhzwu1ZCNxeZLTeIophP?=
 =?us-ascii?Q?f5zzfNE1m6acJgLIBkw6VYQm9BVyYVFehuc+zsx2zWnX5TuNJnC06natNAWO?=
 =?us-ascii?Q?1DwKN7P1OZQnJHLluUAPotVE4OQGRWoVf+6SnJKh75cJ0iERFeTziKRhWGGD?=
 =?us-ascii?Q?35Xr840L0+az4OH0LblbrVFWvkH8PxATJhc0NYCFEYvK6T2i3rtZroX+2iYL?=
 =?us-ascii?Q?OxgQnLAXpfvy7gAubeh1waCyi29AENMAwHojI92Kg8p83I5Uj9Dfd4YiM8gE?=
 =?us-ascii?Q?MsQ+weNgzy2x2rtl83nZMTXoy6HF7Y5ibt21LppxEbPDr//exw00Ln/jFOVf?=
 =?us-ascii?Q?jGrgCJ7dPNkvts2bGqHiz+VDeAIgBEle9Fhwqn2x3GKFhKs6VlBLKgK5hVQY?=
 =?us-ascii?Q?qOWCFLUCPXick2/p6vysucdCx6oi8M+gs/0NvOXowzub3EbuHLN9J2YpZkw/?=
 =?us-ascii?Q?/8C5pZ0NJjn1cUbgd9XbTZuGES42FNoxbMaREVtvLDOKWotTFyJYXTcGHaDD?=
 =?us-ascii?Q?83jyeKF+8FdU8fHvt128EHzhibZs5pNAXF+meTFQeQuwMtdi9lNnArzEvyb5?=
 =?us-ascii?Q?Siav5hFRxUC2IGg45qEpt6KVS53H9vlGVYTuricwhDHLQuKTdcfZoRL31dRO?=
 =?us-ascii?Q?fKObg4Ga/uwJiI8GkFcHFIJ4jsXiZLFc0jf5dgA/FFs9CHrOKe61jNvKDNkP?=
 =?us-ascii?Q?wIkRwx5Die+HpDGJo2AYB49GLbv0/L2AgSVoNDCrPBnW9SuO6jTbf/g7b0zi?=
 =?us-ascii?Q?tIB6Ik9n2H+Pxi8JjWP9UhRKpsbmIRAhBFbMRboVHtfdd9y5JAIgWNPKkM2y?=
 =?us-ascii?Q?7AlAjLz6iXSBSIniHcnEU4VwjeQlUgqrTIFjC5BkjRq9GOnL7z6b7LKU8Ml4?=
 =?us-ascii?Q?oDCi8W1iMvytg67JA2H5kL3533J4q0tyoEXtCTHDHZf/pIaPbfm6VCBzqViN?=
 =?us-ascii?Q?EYhAFjTn7OOlCMm2o2UumZZDCUNBHOjrcTki2WK/fDPsLLnmtppOxbBEc75J?=
 =?us-ascii?Q?u8kuJr0CeMplRest0f6SZaNMZgbOHwygtTK3HOgXwq0HbbWNFKvV59jcVKku?=
 =?us-ascii?Q?arIJL5Ar4LNfQtKktN08nKGfw5vW0J8sCGRCxkSPfDjC+972wh2dkGlDBzBL?=
 =?us-ascii?Q?roPgE9FgYHWFW0Ye4zbAGyH7Y8n4EhyNrm2ApujUkfY1FBoiX+xf4OT/VfXZ?=
 =?us-ascii?Q?GAclevourzOxGyxrt1WkJDdnp5xwNFQfnpa3QJcNH40sktjYrpK67ziM3ni5?=
 =?us-ascii?Q?q8eB63s20gM2pz9JnfigLcWh6q7NtdF+n0sUZaga45LKI3JnajVJqk7uCDde?=
 =?us-ascii?Q?cRhMuyqp6djyEIhGh6g5gGm809aZs9PXnHTrMiV8cUylziWfzAVbskcReCml?=
 =?us-ascii?Q?8MFfKfilxkYOcHmLv4RASk+CT9XPUR8pBm5iUt0/pAAjhPofrEQsBwiT8gXt?=
 =?us-ascii?Q?63uKVgtv2Ug=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZvhfR3gxfzY720Hk5jN10+kD13K6OlQSgZLPatvvhuFF+RJG2O1tRf83/fFg?=
 =?us-ascii?Q?KO+K2w47uqsSzdt192mMt7T1i5X05ijPM8W3T+Uf38cZP5IygvD/r39/2Ddo?=
 =?us-ascii?Q?VMJ1LSwSF67SmNZ7KXdy3RGNCGH61zwULvyRQY8pvzYRn5bxeDUaOxUQdOkZ?=
 =?us-ascii?Q?ZPz3ACJ8u7nX6ck4adti/+qn9noJ3Hly9y85la7rGBS9mb3VvEII+lwX0Fy1?=
 =?us-ascii?Q?sP7mecZkfxSOUJC4A4/XNaL71mxiZPG4PPTvk80QNU0PS5lQFYaJhTCo7v8M?=
 =?us-ascii?Q?6gwx02GIE5UKzY2sWcGcfS609Hkt8i1I0DR8PuZgFEzPuYgaLGhMnApCZA+9?=
 =?us-ascii?Q?zs/a3l3OHNHJI1BHecrUWzqVAVa4Fmo5pZPYIthZcTTgyPPPe+nCf+NZFp71?=
 =?us-ascii?Q?PpLDF+tf+5o8EP1wEk2OAbZmf04/OT49DMT5JpOdsqjyKL3dQFTOIDGzzhBe?=
 =?us-ascii?Q?xzh0UdJ33T8clOpe0BPIULoCO+yaMXNaLMpYDysJNiWvRdG8n6PPoXQHTwGz?=
 =?us-ascii?Q?4sC7t7cG58SdC2Y2DbaJ4hOpmxHDtntUR6dhTJnzl48N+LQlYbYW1oXSdwGc?=
 =?us-ascii?Q?mfxXjrizYGLFZWV6rU2eJvshNZxSbsuDJDLoLMZmj3dFhPqEurQpCcx7Z8ge?=
 =?us-ascii?Q?1XCO9afxJYRN7wdYfqjY4v1T3mI8Y/I/th1alfoDsB3vmIkTRW+GbRHRv3Im?=
 =?us-ascii?Q?tRCK/kDAxtuH5xUH2kFuauI7t6WEyQqVy0D8GfWpOK7UFLJh7hBFyUVtTKw1?=
 =?us-ascii?Q?FNBzIuj23hjERTEn4LxDheLaVkwmsyiPFelryKO2iiaSuozyhWac13Dy4CaU?=
 =?us-ascii?Q?D8XPORK5mhiFsC91ReloB1Md/q1GU0S8Hk2mnqj21sYBY9Hl5baPd+4Dh7uI?=
 =?us-ascii?Q?rQNLtBgbqQXT1m9ViHwle5ktByugsbzEg7CIg5xUjlek/fKmgKopiMiqmM9v?=
 =?us-ascii?Q?+ChBkobsoLGEwy7cyGdgqz7Fd9QKbGxcHqz5bcOVN0LRyLNQlklwahoh58bL?=
 =?us-ascii?Q?+e0GERj/J0XXXcuUv+AMNJgaLuSmlUWv+LJlfi/ufodlNJcerA6XMLnaGZQa?=
 =?us-ascii?Q?w7TWvdGlg2anaH3GABGBKVzv8/1JFcExRUpG6PEEvbg+/TzvyjSQSIe4Ou75?=
 =?us-ascii?Q?3zzKNEWkzCCRDK0j98Rj0dGGXzDd84XWTNT62WCFeqtEYiK1M07PELFCDlh0?=
 =?us-ascii?Q?MZ0PR3WGOF/4UuLVlhweEA/udiYNJ4Dcm0Xb8qsIDw/0jj4vkfVr1aveav2R?=
 =?us-ascii?Q?bkbhOa+KcJ0kecpRvu498lb1luaWTu3y2KgCUVA0ufm0YjvmjTgkSpopw0Pp?=
 =?us-ascii?Q?HWLD4c68LWYk6pbLhTIMTnzn0+D0uPcjGILj/2bYTeo7k/oXUn9oq/Z/3QFi?=
 =?us-ascii?Q?xIUksYMJr6ywsaBieNBvIJQpaZil4ZFH+4ZKKRwwcz/AKkD3wAoNtXVHaoFG?=
 =?us-ascii?Q?UpqtdboVYPI3waRyl4QvyzgOXfk37D8IYe9OxuY7lCRecbOATBHuwV2xTTuI?=
 =?us-ascii?Q?S+2vxdG4yU5zg/Jj8/Hf4FvDZPEiDMBrJoSFomtyG1ipdirB8SL0rOeR/fgS?=
 =?us-ascii?Q?8Z2z6swuVqHxwPcoCEdjfDMVYtr7tE8dFUdiLRz5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 69fa7e9c-7f51-49e5-bda9-08ddc60df092
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 15:15:33.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oc4e0Xtko04mKYDYipcuU54e3pHRYHjNczD4ymgsjv7OzcvV3F2sO7uP3j2I0dil8Wqe+nq+7QcUt3KFg1tO4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9136
X-OriginatorOrg: intel.com

>> >> >> From: Jason Wang <jasowang@redhat.com>
>> >> >>
>> >> >> We used to have PV version of send_IPI_mask and
>> >> >> send_IPI_mask_allbutself. This patch implements PV send_IPI method to
>> >> >> reduce the number of vmexits.
>> >>
>> >> It won't reduce the number of VM-exits; in fact, it may increase them on CPUs
>> >> that support IPI virtualization.
>> >
>> >Sure, but I wonder if it reduces the vmexits when there's no APICV or
>> >L2 VM. I thought it can reduce the 2 vmexits to 1?
>> 
>> Even without APICv, there is just 1 vmexit due to APIC write (xAPIC mode)
>> or MSR write (x2APIC mode).
>
>xAPIC will have two exits: ICR2 and then ICR.

ah, yes.

>If xAPIC vs. x2APIC is stable when
>kvm_setup_pv_ipi() runs, maybe key off of that?

But the guest doesn't know if APICv is enabled or even IPI virtualization
is enabled.

>
>> >> With IPI virtualization enabled, *unicast* and physical-addressing IPIs won't
>> >> cause a VM-exit.
>> >
>> >Right.
>> >
>> >> Instead, the microcode posts interrupts directly to the target
>> >> vCPU. The PV version always causes a VM-exit.
>> >
>> >Yes, but it applies to all PV IPI I think.
>> 
>> For multi-cast IPIs, a single hypercall (PV IPI) outperforms multiple ICR
>> writes, even when IPI virtualization is enabled.
>
>FWIW, I doubt _all_ multi-cast IPIs outperform IPI virtualization.  My guess is
>there's a threshold in the number of targets where the cost of sending multiple
>virtual IPIs becomes more expensive than the VM-Exit and software processing,
>and I assume/hope that threshold isn't '2'.

Yes. Determining the threshold is tricky, and it's likely not a constant value
across different CPU generations.

>
>> >> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> >> >> Tested-by: Cindy Lu <lulu@redhat.com>
>> >> >
>> >> >I think a question here is are we able to see performance improvement
>> >> >in any kind of setup?
>> >>
>> >> It may result in a negative performance impact.
>> >
>> >Userspace can check and enable PV IPI for the case where it suits.
>> 
>> Yeah, we need to identify the cases. One example may be for TDX guests, using
>> a PV approach (TDVMCALL) can avoid the #VE cost.
>
>TDX doesn't need a PV approach.  Or rather, TDX already has an "architectural"
>PV approach.  Make a TDVMCALL to request emulation of WRMSR(ICR).  Don't plumb
>more KVM logic into it.

Agree. It should be an optimization for TDX guests, regardless of the
underlying hypervisor.

