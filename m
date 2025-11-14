Return-Path: <kvm+bounces-63185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE4AC5BC67
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 08:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 77D293475D4
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 07:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E872D2EFD9F;
	Fri, 14 Nov 2025 07:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SkWvPSR8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6836027D77D;
	Fri, 14 Nov 2025 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763105104; cv=fail; b=Vnw7zTveeJWt1rnsGZnrMARaCwYQZHzARnYQTIhDpsv3YlFZfUuGxenMum0w2umnEiN4TQsKIHi1Nu6Nwo7w608S/Lkn7zjw853/lhJRt+ZT5wq4lRlESe9q2JNsmC+OgzAixFRRPcFAxJwchDNR/roAxc8GYXlG6fk+5aMsaU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763105104; c=relaxed/simple;
	bh=5TWFfTBJAsp8RdGc04F6suzHiCZNwH56EO3Zaa+4oSE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kAzkK2nbk02txIyn08G4TGd7g5pA80iBMOugTNiiT0MmVF7XE1XQqsMhgkUmjeS3f9wmXnGAsK4YSm+33p3W19v94tmORGLUlo/o5SdNtkeCH0ARmZOfHnIyiXNsu/MpHHVG8ks2vo/Nng84Hn0UOJ3GifLxwi9A4o3DSzsSSLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SkWvPSR8; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763105102; x=1794641102;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5TWFfTBJAsp8RdGc04F6suzHiCZNwH56EO3Zaa+4oSE=;
  b=SkWvPSR82Y/FS3YxBwe4VQ1J07JwTpxjT9KKB6wyCVOxH0bioGfghHx9
   7glwHVVhUzKuN2O+MG9REnLaB4LoOHYiaBXb+YwCknZgvajp95L0j8k0i
   gI50sY6XTWr4ny11U0xT9vey1jb2Z2R8rSCO8DMXqZNy953f+ZDmFkCR8
   rKJDuoedsv3fr9OpvFFIIdKk7bp2vpWtmKaI6xZuVyXYF5kzEKe6RaiMW
   lH5iLfMAvp2BZ3UOFqpK2a9SdTSPuvraKPRfzR3y9gaQ38mvZijf4bJcG
   6281JlUBvofz4rMi/r3cIZJrSyn/SkYoBenAZFJGYOj0n2vHRDPZ3mMUm
   w==;
X-CSE-ConnectionGUID: rQLApSb6R6G/Ge4MODXmKQ==
X-CSE-MsgGUID: SqyYtghxRkmIuY+u5U4U1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76656603"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="76656603"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 23:24:58 -0800
X-CSE-ConnectionGUID: QKAJY218QSGQkS0dfu1kvA==
X-CSE-MsgGUID: a1tQyRHLSsGT28zoxjr3tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="220366971"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 23:24:59 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 23:24:57 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 23:24:57 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 23:24:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOgMRzrxSNjqkA0io064xLCPL42NrFgVRksCIBsnSFFRP3J1NprGn06jGpozaUHOiG2OLuvxKBpHO1R6rt0OOQTv83ilGKRIQarkYOOSvtfLOiUvAuKxpEkBlJTjtciFUc8God4u+khPBTccExcbPj1hVA9jLvKw2ylISQrI/AGuEdBVRxpJrYbSgeVZ016UdHJ1G4CbZpFk0QdVR2zQUXovCZeUHhKhvE4iwdu4fz+upUG1bWikRUPoCqUjkdVEgD1psrhqbDbuaLrHNHRmdqdimVCZDC/vfZXFP50+om5kMKVI8UGUIUrSY71h/wTkud0LCJcVIHN8Ej5fDGmsYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLM9eWnKqOPnOTUWQ1WhfezB5Zu4jWa6bnnYFb+HUiA=;
 b=XYweyTARKdkHgWuKBlbly/WhLGNBSQ4UHVENpIK6a3GsEsrbPwZPcH2v9Hqoz9FFkaMRm4AMxsL50++PMC3klXkzrzSXzos8SfmmyWVdBadv1rXGk64Ma0bpZAdVnwoMlLbt8koGZDh0c7HvLlZyqVfoGypAZYP1KwjC7ibwv/rKBSbCFIRmjCaOoTorPsQNUfTylE5ELnCJlr4uEcW6zzh00bvtw5PyAP0nsNjPGc2DmWYv5iHoiEI4nL3X+um6lfcYLEBCB2O+CPW2rks71OUry9vwaS7gDF8nfbuXqULnkk1Hs+tO6VOAfop8Zu6X+8X0O9UUXnwiVbBDSL5SUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PPF341F90799.namprd11.prod.outlook.com (2603:10b6:f:fc00::f19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 07:24:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 14 Nov 2025
 07:24:54 +0000
Date: Fri, 14 Nov 2025 15:22:44 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aRbYxOIWosU7RF1K@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
X-ClientProxiedBy: KU3P306CA0013.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PPF341F90799:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f94778-b356-4eef-5da5-08de234ee818
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+h/RqookOVUseRF8l10EnbVaODvCFqLiNiSeNixb9Wt/mEDckJrDZKZ0/JBx?=
 =?us-ascii?Q?C8Cf2gmu2AaT+2T021vWnpwmQ1p2grNoQBHfQt4qVEJYP6f+Rt1HIP1JYjFh?=
 =?us-ascii?Q?+CkgG0eagpeky4ViCzlvuapN41XIHWKfME1nQsAUeO9ew/ugtAK3jrhBiFGY?=
 =?us-ascii?Q?G/xsfbdfCIgT+qbAEksM3IKsRp4uoBWuUQ3DkjaGneYezRJ8CfgfRvyX1Tp+?=
 =?us-ascii?Q?NWQM7TfG/lcC0cMcxSq92yLKbzr7Cb7pjQkY2KbHxyUGDHda8q6Gkw3Gvjpw?=
 =?us-ascii?Q?vTzCGS3V3mnnPr0JzdU5VYkd4GvnFQzmWtezK9diWglHk3QYjIoce5dwBdLM?=
 =?us-ascii?Q?ooEcxYSjyrZNLRdINnCe+W907EJMkYYpe0Lr8MGy5YOPGMJKV8cJV8/O/rFD?=
 =?us-ascii?Q?uDrV26HGPdJMhZmuCx8nHKxbt0brbwXBV+XrJeNnwRAwLBEyo7ibzN/rsZ3Z?=
 =?us-ascii?Q?uzz0iimtrn9fnTYjmHZDpCmZvap3LyFTAifVdpn2j/laowKOB5QUUPDPihsZ?=
 =?us-ascii?Q?YcOgEd+NHTsmRumhDTJrkP2bgNq0rygg9UEXT1cKVkk8E9DEs7BIZFGTQotM?=
 =?us-ascii?Q?eAFEUF7fYqE6nuwdqeQwDFMKogktgqNfsFTAWuBctuStkRCNTwExd14pZ8so?=
 =?us-ascii?Q?gF9Zf1HBb9vS/qrSGtp88mHIQjP4e1s+8kSy6fiScI8VgVxjjxdI9nNB3ECP?=
 =?us-ascii?Q?9mG7G5BnSWoxEEjOJA+LN3hD2ykbjrKQ7BFiqSu4Vy78QxMS4m5+1G6pV9EL?=
 =?us-ascii?Q?i+C0gKoxwzmGe+yEyTkTiLOv+CO/gxwXeT/nBkkq/kF/NgJaBssOSdHVNBRu?=
 =?us-ascii?Q?yXVQ0Rdc25SAQZyXzzyMv3TkzzJsGymK57QNyqqrTvn+g0ts4sGnvP9aUkki?=
 =?us-ascii?Q?98aovhfL8jNar+FZ8GnerbVvtk1f4cZtibQMnbUzky3TeAhqpe1mtzmDau7D?=
 =?us-ascii?Q?qoFfACSBdfZGV6FIkzOyhQJ6EMeh9rnFqMN2sQsSYl583Wtw/Kw3fdEXPnMy?=
 =?us-ascii?Q?GqyYDzw9z1yk3maJum9xXZEs032IJ7IbUm73ndjDq/gz/poepN87/CdG+qxy?=
 =?us-ascii?Q?zMOwgBIUwrIPCfdxxRAZGJitEmnJntd0JcCg5s+chJKmUfoJ+1icY3jTeVur?=
 =?us-ascii?Q?J5OX+7e5Cgijk0VSRI/7RKppm56mj4h/guSNaALTX5M3pDgK+dOVsPAiBGHP?=
 =?us-ascii?Q?dc4f/PYXdTGFkV8AGZE3/LLBwVLgRKdkDjYkHspiWFZ/qgsn5YnG3ysnZBfq?=
 =?us-ascii?Q?olOxDCVQBv6k5+4lv8gyyRgW8V1l8fppt7jU9yUZU5gBw1UN7xOYLESLs1H7?=
 =?us-ascii?Q?cOpl7fc3NJIn9/9FEE8qGjTkq6GgmkiQnIkWwLgaydf5AQrxjogdchANmyUd?=
 =?us-ascii?Q?0Hcsi4gJU8HlVKr/o9e5UryU9xTLkAbJau/c0Fc5NjEQMs0abTTgcowYNwiZ?=
 =?us-ascii?Q?HTPz4kYn8X9HJJrUk+MDkXUgVVetS7vk0sdAUA2aTfNrnRtRk9Utmw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u8DGE9ZyZBF1cucuzXD/S2mme4DP2xBLKZdSg1P+40Dt8V5RTblMjJJ0lPcM?=
 =?us-ascii?Q?H+QByaRvGfqh8KzgFxMQgm8ECJlIfrs+4R093Vdgc3BOsvS/gJB9LyPBWRbi?=
 =?us-ascii?Q?/1uW60Fo3WP6X0vwiy9jfA2Jwd2X1YTkrQ3NmfgpI23xxp08fefDIJJ0Cz7O?=
 =?us-ascii?Q?DjeThNxsMTdKFU7r+jINmb7XBbf9r1iUAOCSomy7KmgIbPQ19q3m+3WGyucn?=
 =?us-ascii?Q?uyPqJHZ6wxvQu5ctlUQgpaFQ4P33NwqmeHHlIlW4kAukL4SjO5xkK+Df+aZC?=
 =?us-ascii?Q?qsuB7ChUlGUXCpkI5bDUvemuyHWdOpX/vj2/5gvZdNIrgIx150p2bsaXit7C?=
 =?us-ascii?Q?WaouP+EQtFMupJsnIiCr5/IHDhzPM1Dc+C2CRfmshNXpn3RzoQOEXa4UbrjD?=
 =?us-ascii?Q?H0iot1oB0BziVDmlS5yxz+PjZz8S6TDTESIbCeUdCAg/s0C1RNBNyP/X2PKv?=
 =?us-ascii?Q?tchmP/tCSmZ3YKw4O3YXFbnTBRSaK6GDgzV2JgnxTYCLyTnBUP3530wHbaYD?=
 =?us-ascii?Q?oyGRq+YX1wjcAqrt9rfO+jo9QFiYrmW7VmbxSvHIovizrSZ0GGPx816qT79k?=
 =?us-ascii?Q?A9NDwNmYAMoevF9KAqazJ9TV85lW1dxzPAP/Csnet0GSnhhieATEv0kiebkV?=
 =?us-ascii?Q?yJEmFQoDoL5O7WdYN+g9Ir9VCekmjBkDNJdaJ6aOCI7Pq3Fpr5uqdxzQLAu0?=
 =?us-ascii?Q?n7jGBHR2GxtJKFKU1iPZzabCHNTQvKkSh0Dz1arORi7Rwj90aLmuWPMdCnfC?=
 =?us-ascii?Q?MF16St23R2V3QdS6pl35DhCs+uPSM683Aa+bNwYZSkPYAH+a9sKLcdOcF+9I?=
 =?us-ascii?Q?WVlvAQDETo3bBNvv6Si9BhieegfAGsSmgA3/Ev0A5htkekrU2janCAAfRaXp?=
 =?us-ascii?Q?qY9BNvhWLBRrdnce8vV2oPBhsSBYz98Jeh+Q+lTXtNiV/2gdx/FUw38avJJa?=
 =?us-ascii?Q?Hwlhs17ZeiM4SVKjsGiZC9GP3Pm24BD+ecTg37/ykVkKOlWvsPez+n63k6vt?=
 =?us-ascii?Q?dIhAjf2uxmxqO+fA0S2iyCtNpQhKJyZUOb/Ao00Qrliu3qbsnkofFcRCyh0J?=
 =?us-ascii?Q?G7nTB0hrRuZAAzKpDkjoMRu/BkpjCrcTL3tU4Y0rJK1Aek6Qkx91kTOgt15y?=
 =?us-ascii?Q?E7cpK8HTU9BYMgiKmNuZvhvaVfLKeKfA+j4HeiIOVHofPjZqIVSgk1UYFtP0?=
 =?us-ascii?Q?ZPdgVeLKK3+WUxH5L6ZBwjHiC/KjBZ1yk4sefJ9nNfQPTaiQs2+0h3Qg792q?=
 =?us-ascii?Q?YSwSmlw7QTrYw5y83vXWCdzMjZnE71j5Fsef9UMKb+po2dMHcud7ZDB3kRbp?=
 =?us-ascii?Q?D2xgYBPwy12JQ0qFagUk7G8qVjt5O6e5XXQQkY8y52Z6d5D9jdzX6OjYP8Xz?=
 =?us-ascii?Q?SarnP2Sb6ePKKqWeBivxdb8bXwcfr8BomjBJOfFPqyZpNly9Czz1p5uIR13M?=
 =?us-ascii?Q?ldAG8dS9hn4B8p10FPb2fd/TTLdH2HymdWAolV4+x8h+nBMYm47N7ii4EkXG?=
 =?us-ascii?Q?su4wTW2vVyvqgdhyMMNAQwJ2XqLljN4gFlQaquJTh8NWYtKXVTTtFs75Tls6?=
 =?us-ascii?Q?IAvvc2Km6tDoXRAk2miwzTaZXC8/ArHYSkzZIzy/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f94778-b356-4eef-5da5-08de234ee818
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 07:24:54.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMl8xunudesu18Y+7chBYLDBlKWFYo5jJyIkNNfQv+HxtUEdz4J63S5vDMl+BOohZkeenKIW6xEPxHpPbLQtPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF341F90799
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 07:05:28PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:44 +0800, Yan Zhao wrote:
> > TDX requires guests to accept S-EPT mappings created by the host KVM. Due
> > to the current implementation of the TDX module, if a guest accepts a GFN
> > at a lower level after KVM maps it at a higher level, the TDX module will
> > emulate an EPT violation VMExit to KVM instead of returning a size mismatch
> > error to the guest. If KVM fails to perform page splitting in the VMExit
> > handler, the guest's accept operation will be triggered again upon
> > re-entering the guest, causing a repeated EPT violation VMExit.
> > 
> > The TDX module thus enables the EPT violation VMExit to carry the guest's
> > accept level when the VMExit is caused by the guest's accept operation.
> > 
> > Therefore, in TDX's EPT violation handler
> > (1) Set the guest inhibit bit in the lpage info to prevent KVM MMU core
> >     from mapping at a higher a level than the guest's accept level.
> > 
> > (2) Split any existing huge mapping at the fault GFN to avoid unsupported
> >     splitting under the shared mmu_lock by TDX.
> > 
> > Use write mmu_lock to pretect (1) and (2) for now. If future KVM TDX can
> > perform the actual splitting under shared mmu_lock with enhanced TDX
> > modules, (1) is possible to be called under shared mmu_lock, and (2) would
> > become unnecessary.
> > 
> > As an optimization, this patch calls hugepage_test_guest_inhibit() without
> > holding the mmu_lock to reduce the frequency of acquiring the write
> > mmu_lock. The write mmu_lock is thus only acquired if the guest inhibit bit
> > is not already set. This is safe because the guest inhibit bit is set in a
> > one-way manner while the splitting under the write mmu_lock is performed
> > before setting the guest inhibit bit.
> > 
> > Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
> > Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2
> > - Change tdx_get_accept_level() to tdx_check_accept_level().
> > - Invoke kvm_split_cross_boundary_leafs() and hugepage_set_guest_inhibit()
> >   to change KVM mapping level in a global way according to guest accept
> >   level. (Rick, Sean).
> > 
> > RFC v1:
> > - Introduce tdx_get_accept_level() to get guest accept level.
> > - Use tdx->violation_request_level and tdx->violation_gfn* to pass guest
> >   accept level to tdx_gmem_private_max_mapping_level() to detemine KVM
> >   mapping level.
> > ---
> >  arch/x86/kvm/vmx/tdx.c      | 50 +++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx_arch.h |  3 +++
> >  2 files changed, 53 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 035d81275be4..71115058e5e6 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2019,6 +2019,53 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
> >  	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
> >  }
> >  
> > +static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	struct kvm_memory_slot *slot = gfn_to_memslot(vcpu->kvm, gfn);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	struct kvm *kvm = vcpu->kvm;
> > +	u64 eeq_type, eeq_info;
> > +	int level = -1;
> > +
> > +	if (!slot)
> > +		return 0;
> > +
> > +	eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
> > +	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
> > +		return 0;
> > +
> > +	eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> > +		   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> > +
> > +	level = (eeq_info & GENMASK(2, 0)) + 1;
> > +
> > +	if (level == PG_LEVEL_4K || level == PG_LEVEL_2M) {
> > +		if (!hugepage_test_guest_inhibit(slot, gfn, level + 1)) {
> > +			gfn_t base_gfn = gfn_round_for_level(gfn, level);
> > +			struct kvm_gfn_range gfn_range = {
> > +				.start = base_gfn,
> > +				.end = base_gfn + KVM_PAGES_PER_HPAGE(level),
> > +				.slot = slot,
> > +				.may_block = true,
> > +				.attr_filter = KVM_FILTER_PRIVATE,
> > +			};
> > +
> > +			scoped_guard(write_lock, &kvm->mmu_lock) {
> > +				int ret;
> > +
> > +				ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
> > +				if (ret)
> > +					return ret;
> > +
> > +				hugepage_set_guest_inhibit(slot, gfn, level + 1);
> > +				if (level == PG_LEVEL_4K)
> > +					hugepage_set_guest_inhibit(slot, gfn, level + 2);
> > +			}
> > +		}
> > +	}
> 
> Also, could you also clarify what's the current behaviour when the exit
> doesn't have any level information?
An EPT violation exit seen by KVM for TDs is emulated by the TDX module. The TDX
module provides VMM with more detailed info through the exit's extended exit
qualification.

If an EPT violation exit is emulated due to the guest's ACCEPT operation, the
extended exit qualification is of type TDX_EXT_EXIT_QUAL_TYPE_ACCEPT. Since an
ACCEPT operation must provide a valid level (otherwise, the TDX module just
fails guest ACCEPT without exit to VMM), the extended exit qualification info
must carry a valid level too: either PG_LEVEL_4K or PG_LEVEL_2M.

So, if KVM sees an exit with no level info, the extended exit qualification is
not of type TDX_EXT_EXIT_QUAL_TYPE_ACCEPT in the first place. It could be of
type NONE or type PENDING_EPT_VIOLATION depending on whether the guest is
configured with pending_ve_disable or if the gpa is private. This kind of exit
is caused by guest accessing a memory without first accepting it.


> Will 'level == PG_LEVEL_4K' in this case?  Or will this function return
> early right after check the eeq_type?
The function will return early right after check the eeq_type.

> It's not mentioned anywhere in the changelog.  The cover letter vaguely
> says:
> 
>   This mechanism allows support of huge pages for non-Linux TDs and
>   also removes the 4KB restriction on pre-fault mappings for Linux
>   TDs in RFC v1.
> 
> But it's not clear to me how this is solved.

I'll add a comment to tdx_check_accept_level() and update the patch log to make
the picture clearer.

Thanks for pointing it out.

