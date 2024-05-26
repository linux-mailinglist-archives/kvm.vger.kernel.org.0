Return-Path: <kvm+bounces-18152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CE18CF2E0
	for <lists+kvm@lfdr.de>; Sun, 26 May 2024 10:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1768B20D91
	for <lists+kvm@lfdr.de>; Sun, 26 May 2024 08:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C680E8F5B;
	Sun, 26 May 2024 08:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/90f4xo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30FC1A2C0D;
	Sun, 26 May 2024 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716713138; cv=fail; b=rtI2dc8FNUghUrISKewn1hgNMz1y4Wwt87uCfdkhnDeVBiF1gndUlNl7aPF3JPz0jG8Mx5unhcmZW8c4lCYOgRXxhrYYuPDgsbtCB8gaDOnfY1nihox0J1OrJ5+BlAm7FnymjcOLMST7OcPrPth89m+ERSOFo9O2Iu7qRYqwl2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716713138; c=relaxed/simple;
	bh=VuBpD8VEjxeuG7jIijEDKyoMeXvPuXZj39OPHnVkplE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XYmidFtN+HBcHgyDiSXnC57UDC41I/Hh4qaHB/aav72kNVJWZ3JJOmhn4zdbnZAnlFMi+QLDi7dfDGrnWG/aPeoW5rcLA6cjgDVly2+JSK0PBN0814HfRm+ghrmQ6KgdwYD4e6BIbVqq4+MeT0bxpwzboSkLzpK3qwok/RhQyyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/90f4xo; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716713137; x=1748249137;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VuBpD8VEjxeuG7jIijEDKyoMeXvPuXZj39OPHnVkplE=;
  b=g/90f4xorc3dq1p+s4f3utahVs7QJKj9PCreIXZPh8gsenrZa+8Bpb4A
   bsFqcrkIGvqVLk7+b02uGZdPXR4QpJnJxbJlzQVSjAjfDlNd5OwShZ3q4
   f8GKoOM/M9PnrCjDJ4JrtwXEAhyI132rVQQB8adOX0BsZquMZypHvP99g
   PYQNqqpT7kkRWukJ5WkgEP0cvdojvBh6FwaoGkhdoolWoVY9haQSXX/Ve
   8KUcez/jv+b5lXa7y9gbH8AdTpJ7hW3koFHdqNRfNJI/+XgngQqS0+JNV
   qTvrMRsCM6TPQMCdecJNs1ZY+YBxrv5YFVltcpNkRjlBd1lya4Kvs0MKH
   g==;
X-CSE-ConnectionGUID: ZSSSLvLmTiKTylOXCum7rA==
X-CSE-MsgGUID: y7+4ofj+T2edf9MUF3AuQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11083"; a="16830717"
X-IronPort-AV: E=Sophos;i="6.08,190,1712646000"; 
   d="scan'208";a="16830717"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2024 01:45:36 -0700
X-CSE-ConnectionGUID: IykoprVUSUuJNvoyn8v5Cw==
X-CSE-MsgGUID: e0EPjmrgSgC16olrhKPC9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,190,1712646000"; 
   d="scan'208";a="34549967"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 May 2024 01:45:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 26 May 2024 01:45:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 26 May 2024 01:45:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 26 May 2024 01:45:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 26 May 2024 01:45:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwc9r6jLopAbfwYuHgbkgIIwipsJNnaHu2NRSojh3DDwFhRMG84ztxoeef4Gvtm/LMZCgc34J0vLQRCQ+JaWd0FMvgh3+DJNdZdBpOkOM/41F9hXt0ZrQkPsMSGb2C25Ot76xEU6Yxpbm+WvceviDAU0qY72fVqLjXjdyq3pWVMEg6B8FkUZA1g+mIy2i+6AnlsoSG/qp8DeqUrfPc4iKjRRRig+D/22eai647xU5seRZF3ZegiY2shnyJyP/AeXILg2QcPiWgLHKDEudfw2BD1QJDKXDI1/N4KrBbUCRNJ+YG5PD40a5HHjMqMrHZUqhC9/KfORuLgegBvS1025MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXhC7wyOOYktWfG2/bVwvoxcUGMRu3YEyUFFCpZZeB0=;
 b=OLt5t9TgWUEWtokFrxkiXSC8of5sKxlJ0dEK9f7Hr0PlgwcZwnmmPb1pvX6+9xk45cIrZHvsL3IJxU5u+jfMHcBzk5HfP2nPqLIiUx6obtD5QW7bohZXYBzq4fnp0xJQDJa6QZJe5zwjPSLpdmi3RRU5AUbqnhQzxbgD29ucEqj9MJHxoPy1jly0augcyfQACvOJo9NOx1kXDkuZudeZEB6FKIEjMuqsBJPQn0u1OY81HPAFZ7nO1WGWWztIb5Xr4VkYQCE40BICpM+Z68ZVxIBEzdn5xPEZce6vCsufx61n+gGUw0y/hUxPKjGhDcO/81361CmsABOVNxkCn2Mdgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.22; Sun, 26 May 2024 08:45:31 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%5]) with mapi id 15.20.7611.025; Sun, 26 May 2024
 08:45:31 +0000
Date: Sun, 26 May 2024 16:45:15 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Chao Gao <chao.gao@intel.com>
CC: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang
	<kai.huang@intel.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Fengwei Yin <fengwei.yin@intel.com>
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Message-ID: <ZlL2m3PKnYqc3uHr@chenyu5-mobl2>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
 <ZgTgOVNmyVVgfvFM@chao-email>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZgTgOVNmyVVgfvFM@chao-email>
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DS0PR11MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c95d23e-e3be-4fe1-955e-08dc7d603318
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g/e1rb1NGqih8RY90+BZhahE+5b9hkN0WoFNp6Q8C/noTEgS0dEMqANgm2r2?=
 =?us-ascii?Q?RCfxTHF0HdtdNqmtKxLWxPahsSnfFwYPRVX6fX67wfdxQQ83QQT0HbyXsxFz?=
 =?us-ascii?Q?9ZIDaDTJ5o3RGP42KaRys2wnnfzENdyqlNXWcEgwEasVe7Iqv7knvb1bxwrY?=
 =?us-ascii?Q?YkF6FuIqGd8iA6QMVVOV7YnB24w//AhQu++jrfyzS84FjzvxiG0ZSSXQXHLo?=
 =?us-ascii?Q?O6Le5tDjZmpUbWpWuspDNwv3jX3hnhZ0/CIzThKMhfCGyGgE88R4SNNE8MMc?=
 =?us-ascii?Q?vsd9ODe86J5OLm/DjTYA5KBG16TQXfUBz1FuaKZpL6mkShmc4gu/N5hizo5a?=
 =?us-ascii?Q?qbYjfjiLKtHRYgY2jTDR+/cvK2dgv26Xzx6SaY9PGnb7vITYFr2nDzXJJX9K?=
 =?us-ascii?Q?xNH5S14KVHBxOpw+Jj4kiCWawUd2SpuySCaOLpvbKVJnvMzyW+JED9/r/EE9?=
 =?us-ascii?Q?ZDX5cPkGwiLDYv91cZT1a5j3mqHZmXg30D6bK/BtRO37RW0xLDzEOA9zuZmy?=
 =?us-ascii?Q?Yo6RSNzt4BG8jPkfiiCxEK1z8UB7L6uz01llhIdZ96IUtvP5MOFbbakFOkB7?=
 =?us-ascii?Q?P/ZmiiOE2gCmcgXRa/LeJWMt/09nDcfdpAeN230TSDyDE2CD3GskEVsdmrZ+?=
 =?us-ascii?Q?gEtKQVQRb5NtI21OdFM81Cja1XHTaY5Zs6uQbz/6oODGCzbteYqeuPS9vnZO?=
 =?us-ascii?Q?+QF5HX/ENcaqMuQspUItoKHUPjDNRyawqxeHMEO/xl8ZMrWFLY/N8YetJqKu?=
 =?us-ascii?Q?AFKONnYsNXhp9n7rmLxWw9r5VL+tU2lBCgYqmsQEBJ6ZpRZizZWoMwmNGcoD?=
 =?us-ascii?Q?ZLgI8iJTEavWORDw5HS2NIFGN/DM7Ph71mJ2/EQoY13BmRsiIFR6wPteKhFA?=
 =?us-ascii?Q?9W9xaI80wkKZAGYdoFp9UvlB+1nlG/PGhGnEXIkjBmeyQ4SYbj3rgxgeHOk4?=
 =?us-ascii?Q?f+w3F4SImcyacYu/YgvTcWQWAt0a6EtVKtLrnLJFYDIgSY/pe/UJUBepz2F0?=
 =?us-ascii?Q?DKn5YxZpLaRNsdG9ZfYdV7jYq9CMEq7BMjDEMmPF9dB3cSquPb3ydlwhe6Qq?=
 =?us-ascii?Q?1MCUFEOIjdcoLWGcyIWfdY0/CJ9SFnZ2TfgtHNynQ+EXd0PSDbeCyFc19o9N?=
 =?us-ascii?Q?xXTL/XvaauPdLHDtRU9igT120fVR23X3Nlyx2LSbvwYm/69d9FXnaC/12jsL?=
 =?us-ascii?Q?tOxwo9FcENwT6GgNo6WJhT+hgcUvc/yMi1dfN3evNCaZIbtjrTJXIFWo7M6l?=
 =?us-ascii?Q?XxIog3h/kN3iTphEBlHfnJLaE0x/jrI9Pcix6fpmYw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1TXViiINB49payY3Ypvvtc3u2OxSHvl3uG/Qq40gSX/h6WrM5RzRV3uZ2FoX?=
 =?us-ascii?Q?CQ0mQERTAGBEGLcq5JZxla8C3EtIdmC8jOVJ1OwD58LAsqYIkZADbLRmMR0K?=
 =?us-ascii?Q?fIV0JpmiCGn3TiZOfJg+cEa64WI02mbby6mqQgaBDQxxuzgNd9gic/rgoP+m?=
 =?us-ascii?Q?c5aYVx0SlMlC6OVFIaXhfrYPg2pNX05L8c8xb//NGa+wLT+8o9dvQVP7CKKs?=
 =?us-ascii?Q?vQmsa5df6O96IaTWJN3aGaDqCiMOWX7LRQi+19b3ANRK+U+GCJJ+ROAlDeGR?=
 =?us-ascii?Q?uKf5LaRihJO/OtYhGxSCLYX8ksbkEVbVTUZYEW00MFKL2QAxMYPEVVIPDtHg?=
 =?us-ascii?Q?0SZRJHUp3itym+MGCRCcb/wtYOkgUkVThZgDb/dbi47Jx3Ln2OlHsbBACP5V?=
 =?us-ascii?Q?bFoF8fdx0Z370vHmxydFm5D69rcmX7FiGuhTU8kxhRhy+fQGNADn4K1tp4Ve?=
 =?us-ascii?Q?maxBOPaugt+2ov/rGdmkhiNckSDveuJAl6qBfn/2Ah43DV5qBOTpNpEpWmM3?=
 =?us-ascii?Q?G301ytuS8sgZgJjHqIxOrqvONPQcjiGE5WWrswh4MvCFCu/WQ5th5950x1Ly?=
 =?us-ascii?Q?DyrvmwRgs1fjq+59Z2gDcgByZmnWsu0ulsuWaS5dqrZL2BVsIJYE4VWGZPvO?=
 =?us-ascii?Q?j8heALugUaXsmUc/GkO46sIzSOU/z14bzehaRp3geIp4FhQDhsq/augvVzRT?=
 =?us-ascii?Q?Nx5Sqr+W1ZneqFqOS2yH3PEnPSdJvg/D01oLX3gysYEI/P58Qky/VIzHxoA7?=
 =?us-ascii?Q?Pi5jJo5DBkSBxqZ+kH3M0BxckccMugQuMDhZwwRegpCF3s9oc/VPbd+Clw0K?=
 =?us-ascii?Q?p9HUVWSCIcDEBcPCzU4pBcD8yQGZbwyiKvuL3plOH0xfLE45hbSxpeZ7sdOL?=
 =?us-ascii?Q?jCcIaG02qCKdV3JJ0maYfYW6p1fXEI3gs30hQBE8APcBeFL0tOzTSQuFhPqB?=
 =?us-ascii?Q?RyOZp1mIB/ZAaO0mhzwpllRKitMOk5DM0GbdAPijJ4azRRCBnfX6W/9dP8hP?=
 =?us-ascii?Q?272a/m7tWRaMYWqNOwxUz7D0N0QMrIUddhg1nq1DNYNFMHunVoNLuO/TZaTC?=
 =?us-ascii?Q?OM1dbM+tnF12OtcRaEE5NeI0DKusl8u/Z8cmsGkxfQnhhpX+Q/jiCl1Qnpuf?=
 =?us-ascii?Q?HHrjOIel1HcSDcJPWvPN+SDVK9kCl/W6jSIrDJpeeTh/EWLqKQpawg25cTod?=
 =?us-ascii?Q?iFc/IFOhFgLEDXSgn5WPMT5TCXsnYnNSJoAm2gmOeVzj0J+3l8DC/lHGrdUF?=
 =?us-ascii?Q?2mR34S64nPZg0gaHJwQrdH4X5ZGK0+z/h0pU3YMJ3KFSlbtfIOlLyJ93R1OH?=
 =?us-ascii?Q?+tttfQa6jK4xgSAW67cafKVube+J2bnXLRP6qUWVsHZE+7JclE0ujRUd/eMv?=
 =?us-ascii?Q?rWxLO9i+3CdulFW0wmsB27EUFh9jnCTmA8OJFiZoc16LCmhO90Xb41IfBroX?=
 =?us-ascii?Q?y2yXxh2MHyMgw+BtvYm5X17QfoqCCnlgQkGqoYxhAP02yZvXfcRIZeKoLzj0?=
 =?us-ascii?Q?uuetmREb+udMqT4s7uV3R3tM/9Z3bBELRNufZxCRSC3Y7JE087sKasjacU5n?=
 =?us-ascii?Q?0FqxbO/4/+ROv+3dYAFP+EYhjTFKLb2wepk6wb1B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c95d23e-e3be-4fe1-955e-08dc7d603318
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2024 08:45:30.9973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: br0LlDaWVsO+M8/Cjf0fGxmsBz/afCP0LMetKWgZan0NCGEW9zpad/rU0tz/E+eqwYs6RpsOAawSQGD+K65NRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7736
X-OriginatorOrg: intel.com

On 2024-03-28 at 11:12:57 +0800, Chao Gao wrote:
> >+#if IS_ENABLED(CONFIG_HYPERV)
> >+static int vt_flush_remote_tlbs(struct kvm *kvm);
> >+#endif
> >+
> > static __init int vt_hardware_setup(void)
> > {
> > 	int ret;
> >@@ -49,11 +53,29 @@ static __init int vt_hardware_setup(void)
> > 		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> > 	}
> > 
> >+#if IS_ENABLED(CONFIG_HYPERV)
> >+	/*
> >+	 * TDX KVM overrides flush_remote_tlbs method and assumes
> >+	 * flush_remote_tlbs_range = NULL that falls back to
> >+	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
> >+	 */
> >+	if (vt_x86_ops.flush_remote_tlbs ||
> >+	    vt_x86_ops.flush_remote_tlbs_range) {
> >+		enable_tdx = false;
> >+		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
> >+	}
> >+#endif
> >+
> > 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > 	if (enable_tdx)
> > 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> > 					   sizeof(struct kvm_tdx));
> > 
> >+#if IS_ENABLED(CONFIG_HYPERV)
> >+	if (enable_tdx)
> >+		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
> 
> Is this hook necessary/beneficial to TDX?
>

I think so.

We happended to encounter the following error and breaks the boot up:
"SEAMCALL (0x000000000000000f) failed: 0xc0000b0800000001"
0xc0000b0800000001 indicates the TDX_TLB_TRACKING_NOT_DONE, and it is caused
by page demotion but not yet doing a tlb shotdown by tlb track.


It was found on my system the CONFIG_HYPERV is not set, and it makes
kvm_arch_flush_remote_tlbs() not invoking tdx_track() before the
tdh_mem_page_demote(), which caused the problem.

> if no, we can leave .flush_remote_tlbs as NULL. if yes, we should do:
> 
> struct kvm_x86_ops {
> ...
> #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(TDX...)
> 	int  (*flush_remote_tlbs)(struct kvm *kvm);
> 	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
> 					gfn_t nr_pages);
> #endif

If the flush_remote_tlbs implementation are both available in HYPERV and TDX,
does it make sense to remove the config checks? I thought when commit 0277022a77a5
was introduced, the only user of flush_remote_tlbs() is hyperv, and now
there is TDX.

thanks,
Chenyu

