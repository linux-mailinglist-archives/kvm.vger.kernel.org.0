Return-Path: <kvm+bounces-29078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE3669A23C8
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4916EB260DC
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263761DDC3F;
	Thu, 17 Oct 2024 13:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DXhvRs6T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271321DDC25;
	Thu, 17 Oct 2024 13:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729171686; cv=fail; b=OD/BTt6grGFA0e9lsNZyr9HKmVenPVNF8UlfUZyEwSztm/J9QumsMlwqVQBBzezjyzD6K9acENanKWtf9dxZIrJCyy8vwXXju0bJMAfV40+ENVqvbrqc8SyV0Ok42DHacv8DmsVvVO1x5b+XsjkOk1TFBOyKb64BCSKDv8q/Th0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729171686; c=relaxed/simple;
	bh=oSPAuwMFqnZZJzMN38bLgultfdUf5iTjTtuJ72QOV3U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sTGOKMLio/14Uqv45MHlcEBCY1vmbY+cQ7hVwiR5wW05PzuHX2v2UWTBRZvZ0Xi5TXvYwIRU5aszzVYO+dNla7F+MX0Uj49svi1z9AbEEVvq+UQHdYJa+alYCP8kmyxHovTE7KkJYYcOpoyFgT00NzzItBvJ92kVG0cJNLsk2ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DXhvRs6T; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729171683; x=1760707683;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oSPAuwMFqnZZJzMN38bLgultfdUf5iTjTtuJ72QOV3U=;
  b=DXhvRs6TQ+nQ2a4Z6KLoOWss8ZSlsQTIphcboi2CYyQuXIVCekWnB9Wl
   qJqf3zDuhfe3dC6vA153C+J9430rCAwYJ/kHDaX8QG3Yc/vkctCvOVJgR
   K9nvgcKoQOulr+TcqWz26ONqo7FCWWFqxia85vbV3pp9QowmAu11AoJgT
   u8fqniIcGDv5EF16XHCa5JLFfQBIe3S3eW54VNQnR0Z5awesw2TYJ3QSr
   +aBy0Jb9C7jCvM8EyKoVsQSroDg9iqOTu9nX1nP03RRklsqxYJezpeRON
   VxbWozGc51wGKhnFpPPw9IovRf/mxjYswGQ2BiYtoTyxYWEGpMJ/BtEI5
   g==;
X-CSE-ConnectionGUID: M22uzhbuTPmMQZ/xZH1fRQ==
X-CSE-MsgGUID: uYLdsbVjQLCVREUnrvxRJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11227"; a="28748636"
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="28748636"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 06:28:02 -0700
X-CSE-ConnectionGUID: f80V/sdoS3+fscfqbiVI3g==
X-CSE-MsgGUID: yZO0X8WuQoWYyC9142cY6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="83374944"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Oct 2024 06:28:02 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 06:28:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 06:28:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Oct 2024 06:28:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 17 Oct 2024 06:28:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 17 Oct 2024 06:27:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCrzC32quZhzE+Wdl5hW1z8DDEekM0/xJ8Mnz6SpxQarS66wP7TDP7ZNErYIycf0ulsPz7GVJnNa8MgGKVD6ORVXiIX2bJaPjE6JzwOxjCb5oz9Wdm7NZMy1IF57cM43prANqXl7+mAPN3rvSosFvYGA4mzJBcSaRFElgpLRHy3anPcrGBHPfFY7533tTX5dj4Vv8jhvlIu6tEyhZ3QevmkqEitt3631sDhKb0X0EwbHREAH7rLsACzGHHhQXheB370JoN5A72SssBxfGfNvDECmCubHt3o/MdyXmBLEvw1kCLiAAAWfWDWtiCIAgqVTrYSS2cr83lLJqtLjDRTwag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMkqXh59BRArMF95+FS1VkD0rZUyxHOz8CitKxFPQ6c=;
 b=B0O/z3l5fapCQG3ta0s09hwU77bXbU9CQmu3CJn26Bx90t6O3rlcVfDI/i1lWfmuMZw5Hk6zAyvMjMYe2JzHjEKLkWpif+VjoPlBkWbE+VOUbrZUPc/fYreDdQdkJK55+mNCLkP8bADWyPEtJfAji6EDYwPLrvQrMgJVL8+iHEj1LXVPeA0AXEPTs1LQROIWZBQnTpjEedBbRHS4A2G+kKFzEAKVEeayz1B7vTGQgV9eFx8CPn2jP4lQwfyOafXjy4R4VFutq5LUuJ4vl1QjI6ZEYoX2Cafwh5EhSE9v/6GuOG/FC8SqiakzR+q+TTChUJB8rURglmDd3uC8cbOnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8447.namprd11.prod.outlook.com (2603:10b6:806:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 17 Oct
 2024 13:27:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8069.020; Thu, 17 Oct 2024
 13:27:54 +0000
Date: Thu, 17 Oct 2024 21:27:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Markku =?iso-8859-1?Q?Ahvenj=E4rvi?= <mankku@gmail.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <janne.karhunen@gmail.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <x86@kernel.org>
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Message-ID: <ZxEQz6uGqNtNs5Ph@intel.com>
References: <Zu0vvRyCyUaQ2S2a@google.com>
 <20241002124324.14360-1-mankku@gmail.com>
 <Zv1gbzT1KTYpNgY1@google.com>
 <Zv15trTQIBxxiSFy@google.com>
 <Zv2Ay9Y3TswTwW_B@google.com>
 <ZwezvcaZJOg7A9el@intel.com>
 <ZxAL6thxEH67CpW7@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZxAL6thxEH67CpW7@google.com>
X-ClientProxiedBy: SG2PR04CA0205.apcprd04.prod.outlook.com
 (2603:1096:4:187::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: 55c15fb4-5e8c-4afa-5d4d-08dceeaf81cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gnmU6Kl8kDaC6lshswykh3uR5BEXMgdACJ8VtTcNp/gALxA67s4vzWiBWp9R?=
 =?us-ascii?Q?vtuKxgG3Xp3xD64C3aW79fRZlP2I7CPffs9KH/GlSFbtJDklKsZ4XaFWzBBz?=
 =?us-ascii?Q?7Jgawgak+A9N5jghWKclxIWQs6QyYzK4fUJ7axNWKq0VzKPiFCEO41WspY9q?=
 =?us-ascii?Q?ts9R/4CaklyBPo914FhgmhQgam1IoX/29sjLpfMTc0t3fdqn5bdfDPlWGSNv?=
 =?us-ascii?Q?ZpV3S6ASh51fRwLCg8Kak7YgNPthZ5R21sGFtCjgghetiQecKj6dqrkmVay0?=
 =?us-ascii?Q?8XGkVljbfDe7Xv1asxE2VVCNe4k2F/Be+ZwFrwOKyEfz8RBzu10guXvDP2Ua?=
 =?us-ascii?Q?X5A1p2lpKUkWSb94+8v/csOgPVQ9CG6wlCuDYgO90dfmjT3+8c54OAALX7yg?=
 =?us-ascii?Q?Qxlj/q2K5JvJHavshPsHzPOvLnb2vLtEdd29D8WYa7msSZFYe1gX//WtcChX?=
 =?us-ascii?Q?SwOO9a+xb7dP0baLAwMMmCqCQMSeMHc3C2Cmqv2H+25WxwBZneSpuYGJ+GOd?=
 =?us-ascii?Q?VBJAb7CytwDPfIDlfcrzI4f8CDcV0jARYPpMegq/a5Y2MDcPIlv04+eCMI5O?=
 =?us-ascii?Q?Kj1jaj6NMikHzcZc/YWrRwCpy7zzq8m/OItNHpPpMUQMlbgrZbvJqGUQMDlX?=
 =?us-ascii?Q?sW48FB6/xP0EuaaIFUVjLOxguu3TMQSsAfxUMbYrsp+3hzd9PDCSwPH0I0fK?=
 =?us-ascii?Q?RIR1452mfKh2PBOuf+MF/ctj1KqbhGTBxVGyagcufoADeTiFiDwxsJwOFMvq?=
 =?us-ascii?Q?cfA0QaZAoQWNWOPHQk/U5aQLEDgWe/wOQOhA2Puix2M0nWOD5QBPQVgljXe9?=
 =?us-ascii?Q?P77Btsu2cRQE89IojsOkWOGusZDPzJ6N43mLBq7HnyVToY6WafmJhcl7UOr8?=
 =?us-ascii?Q?uGUa9v4Ypyk19Yc+uWPoqN/DZbHBOfMFTRbnpBOIhZejaxOjq3MJ93TzrrkW?=
 =?us-ascii?Q?wQ0vZk2UIxonUCBd2gbcgqWfQhTfJ97JpoA4e984+E15DXO0dFhNSGiBRTLT?=
 =?us-ascii?Q?ICsw7cIkjYwp57qsnPN4GCXEW5qHUS3KMCVIZOBE2w2vqFyJETcLxlBLLaxS?=
 =?us-ascii?Q?u2cx19XzzUXdttRI3PuGudjSTXPaTPINXynXNdRqVNrZXDgZQrCzMPWlp03D?=
 =?us-ascii?Q?U9KPqsjZEUPXSw58M7LZo/qWGL3tgwT79M1z2vUqkSFjY19H9PoCzrpOXGjf?=
 =?us-ascii?Q?3vcC3GUzxfFxJmrwIkICQTdQJyr6J5/4jRGMtab0b65cvsqWS2qtd8v5wSyf?=
 =?us-ascii?Q?OLZMwTuKQwp1BPNqJmOTPsZY4/TFs+heyUDEkN0NbNy/gBFRvdBqnc/XcYxx?=
 =?us-ascii?Q?iLQiUFoZOQAEf9QKSZm3vZHf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+f4pcVttwh5AUVNfY3E6lqxobMIAlKnk8n81BPYiPdYcuin+b3jebCiwyGar?=
 =?us-ascii?Q?kSGjB7WIIxPEU3F4rUZkb7xo9PakCk/pmjVVhdPlvl5Cc2iL30Ta7nA8WRrE?=
 =?us-ascii?Q?+CANLD/Z/1CspUJRpo49reaTIXGzD6KUbMDI/v+2lF31jjrowKZjPlqWw3Lf?=
 =?us-ascii?Q?jIbU/5R1KaAHsH6+IaLS7r/l1B6r7Wtdw/UqXk1UNwC8Jx1tGsEMfQDdNnuM?=
 =?us-ascii?Q?S0mNOlN5xNn/GG0TewzNJNF+ah3mrwkW2UeZMJxA/h5xoEESRDO/oW4aUGla?=
 =?us-ascii?Q?8gXP8tKurvh/VbZZehypVsq4uvMGROM3hQAVU6Xx3SmZtAiFFMjLry7sghGk?=
 =?us-ascii?Q?3P5pWHmSi8ZeNM0frQFP87syBG2M/ZjVlAU3OM/qpKe9tDfzxXAIs5mLFkjg?=
 =?us-ascii?Q?sOEffT7H9AgG0XZf4ATxKjZggZ3WbCIJFQ1NXn95KUm/qY9KRJWOulus5yZE?=
 =?us-ascii?Q?GmkXn6UhyvMj48KkefCkUiye8B6hxWykRZWYf4PXndplNmH1KmvTl1+l+YXh?=
 =?us-ascii?Q?yboqWeRoeY1ypx0lMHLYa/TUegLkn9G1IsryYgHoXmC3W0IS3mS26ohUCB42?=
 =?us-ascii?Q?r7gQTtsS5ne0Fcl7rvlyo4ifQbDy+xx2KNRSE1JWtlOqNMr1G3VBAkgf2haX?=
 =?us-ascii?Q?qD+I1N+KOQewYBytrHITqA3XBUo4dObTlgMSZ90isIiIAnyZUIIYWs/gdjD2?=
 =?us-ascii?Q?4AKhOZ7O4T3x8lvl/Ab0fWSW89XQ6R9+cx5a6Mao/t9XRqZx6LdrR9zYnq2D?=
 =?us-ascii?Q?K49IZ8jv5yQ28SIH464fAiGu7OtqxNN6ataIGY+jMgmd23hbiaL8RQG7pqnI?=
 =?us-ascii?Q?yMRenPr3ft9DzuZb7TaqR0s2cMpf6GBF7Zd1vHKVVHiJFAxaqJxQwdvqEiW7?=
 =?us-ascii?Q?7ca98pVWql37HWkjyumOLtO9mX4z5NPbLmpQHBJkVmhqfeaWstsDeGIupzvX?=
 =?us-ascii?Q?TRizU7aU71qRLeP/wnAPM1VKUlg+14Q7lGzQAFeqZVC/byEV3pu42c9T0Cx5?=
 =?us-ascii?Q?Yb4R9Kc0mJ/QVuqIAGD+2+Dugdil+Ia7EHF3+DH5kxeN54AD/9uIn6JUWJOI?=
 =?us-ascii?Q?TGh/t92i4RDmx54wiVH8NDMV+X5Pz2gTr8oncSOXZmgR0OgevSKBcXfOG6LD?=
 =?us-ascii?Q?m9g/7vlnPkJV/TlQEShQb7IiIrQ6kVns+EtCYSm/tTJXIoCQn47ZloNBkqHY?=
 =?us-ascii?Q?DmalezFBnoEw9yuALIhJude7spxy4tioQrrSG8L7DNJGU4I2WrfFVT+J2z6T?=
 =?us-ascii?Q?A5ilaYS3tywKYzah2iQDXAvcLX4o4D4yN1gkCAAO7MVE8CMQgOcItUXSVCkK?=
 =?us-ascii?Q?IxwVrj7sCKXBHe2i+kEPIH/3yey4GeQmhJWvn2QF+QEHd4IzYDCHaZ6DvGJ9?=
 =?us-ascii?Q?U7N+hRwSWpXEQXLwyvS4/PXI6BNJONOmkrCX4CBuZbTgxu8NCCwnjlJSE5uL?=
 =?us-ascii?Q?n6daHDf7o4UAH++BChQj8WOg5T4+Bb5rud4rF+G7MV4xYz1JTefZv7LsiTG5?=
 =?us-ascii?Q?e6OqI5TIcdRw1rasvFYS83jOcx2t1+VyoLhhI0nT+cLSjJCq4YlrTQZ+4Ca2?=
 =?us-ascii?Q?5+esxiLXwJmj8QVdT3FErwDSK8bQzkzY6GqfE99Q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55c15fb4-5e8c-4afa-5d4d-08dceeaf81cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 13:27:54.5342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35Staf8Cq2KDsRmPxH8+DR740MPXIGynMRzrXNEBIBXmgN81GBwt8SY+L07P/0lpvmiB47rp+YL0XJO8No689A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8447
X-OriginatorOrg: intel.com

>
>I don't think we need a new request for this, KVM can refresh SVI directly in
>nested_vmx_vmexit(), e.g. along with change_vmcs01_virtual_apic_mode and friends.

Agree.

>
>> +	}
>> +
>>  	vcpu->stat.guest_mode = 0;
>>  }
>>  
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 5bb481aefcbc..d6a03c30f085 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -800,6 +800,9 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>>  	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>>  		return;
>>  
>> +	if (is_guest_mode(apic->vcpu))
>
>As above, I think this needs to be
>
>	if (is_guest_mode(apic->vcpu) && !nested_cpu_has_vid(get_vmcs12(vcpu)))
>
>because if virtual interrupt delivery is enabled, then EOIs are virtualized.
>Which means that this needs to be handled in vmx_hwapic_isr_update().

I'm not sure if nested_cpu_has_vid() is necessary. My understanding is that
when a bit in the vCPU's vISR is cleared, the vCPU's SVI (i.e., SVI in vmcs01)
may be stale and so needs an update if vmcs01 isn't the active VMCS (i.e., the
vCPU is in guest mode).

If L1 enables VID and EOIs from L2 are virtualized by KVM (L0), KVM shouldn't
call this function in the first place. Because KVM should update the
'virt-APIC' page in VMCS12, rather than updating the vISR of the vCPU.

>
>Hmm, actually, there's more to it, I think.  If virtual interrupt deliver is
>disabled for L2, then writing vmcs02 is pointless because GUEST_INTR_STATUS is
>unused by the CPU.
>
>Argh, but hwapic_isr_update() doesn't take @vcpu.  That's easy enough to fix,
>just annoying.
>
>Chao, can you provide your SoB for your code?  If you've no objections, I'll
>massage it to avoid using a request and write a changelog, and then post it as
>part of a small series.

Sure.

Signed-off-by: Chao Gao <chao.gao@intel.com>

Thanks for your help.

>
>Thanks again!
>
>> +		apic->vcpu->arch.update_hwapic_isr = true;
>> +
>>  	/*
>>  	 * We do get here for APIC virtualization enabled if the guest
>>  	 * uses the Hyper-V APIC enlightenment.  In this case we may need

