Return-Path: <kvm+bounces-61584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF6FC2251F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69A3042686D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA432334C00;
	Thu, 30 Oct 2025 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gLpTV0+5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C9F332EBF;
	Thu, 30 Oct 2025 20:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761856443; cv=fail; b=Bk5B0mgsuHygE+aDt6YE76f7PjnnI46VHADs7ONSoG1igydWGTL70AL+doGjzS1HyCJLaaD3VbJEUa1Y6dquf+Nv8xf2ijTNwTyMwg+117lgHzsZvtc1wODWnmLxTZK01D7yzpy3RxfBzpSawUEuI21L8e8Q3rQkEcTJwPSOaMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761856443; c=relaxed/simple;
	bh=BBlloIt3krevrhZWZX0R5lqcCleKmYzOY+esNOSB8I4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PbXhbHtbzRiVhAeWC9H8CaFC9ZSEOAtY/tNLfYBL++jOFL6gaVAb+Nfr5fvPE2I+cEvdKmcxNGXLNekkrRHObHGSkBScX1VofaCIL8UucGY595RIVVQzGJc7C5WvJwiPcvLSIr578hvU+fHK1xHQcrL3mR/6oKIbHvO6+jJGWqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gLpTV0+5; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761856442; x=1793392442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BBlloIt3krevrhZWZX0R5lqcCleKmYzOY+esNOSB8I4=;
  b=gLpTV0+53JMOqbsbWKokYd0E7AJmEWVUWhQZYWVI1Oyjc/6q1SmHpWuI
   /FpvClklwlLJoS7QYXei9/37ldFIj1oVfHrjWI/sOgK45RTf+EL+4tN5X
   Lq9h2mvkp7P/PTS4bxhCD83dTu7G46RjlTiMS0/CQTpvj/XpzQ+Tlz6U8
   fVq3krQmajhG8ZCMCGswOWZkZ2CPDn7sWk0KfpSdAI2bcL9OvjlseE09+
   R/19U0kc/H5TVk6HnAn8MTVZc37PefsNvVplZyIRC7SGOqCidSBZGJBU7
   pz2QRvDu+6exfPmDUhAfhwHpukG4Zu0KW5Vz+vzu0P7Nh9j/VPn6BChgI
   Q==;
X-CSE-ConnectionGUID: AufnrLrHROmE8D7jjcIENQ==
X-CSE-MsgGUID: sRPS621dSg2osxSNee3enA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64108753"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="64108753"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 13:34:01 -0700
X-CSE-ConnectionGUID: T1nii9GXTA2z4wcgW7jjAw==
X-CSE-MsgGUID: WQf5zvg7Qiiln6YF53nEsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="186791461"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 13:34:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 13:34:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 13:34:00 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.12) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 13:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGGqhjG51mSWF0ZTPh1pK3BUO1eXt2qO/UOURdnVTOfOz1Eq2jUSaSmvMqAoBcWOfKUHKeczwtqwW8mXi9KYgYMvjcT7vCN4SZbt/EJvcvbAPAjeim+5U/QJwihzMXLNKE5SoxqKgTJyTV9+5R4LyasehGdNPCq4tgvm3aD4rQpWVL9E/n6ebvgquNyd29UFzC9TMzLYYwVEOpRpqkuv/ZDtW0JrlIsYi8u1H1pVovnYYIdEWA+HXeZwVwdyHN0SZVpd8SWeTUio9xstuG572AyES1kfW9zmygRNi4sqbWHWBWfSuczYt10Jb4VEAstbZxRztkXj8wlFZoHuQpZtew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wN9NDv3OTrmO6/C6evQ0L+hjhIYvQ02yMPik0fSbl1k=;
 b=YwQTExVxKQdx1aHtMA15FICrVrdtGK2Nl3fCjdSxdPQohAiYFevI+JR582FL0Dl+dpxyr2ve+BTCJHOMLXkWktwzC/XTYUmz6yB/IiE1UWXMDy5vDU7ZmVIdnn87watVEVf143nSBZDX3Aia5fHHjaEfSHXXySfQ1eeosNZuq336YMY5Va0XQeHP93PPL98DV0EqhkOVNXhrNVMMsF4JjaQXyLz1s3X4I1hASeM0NxMKoQoVVqUadOEVzmG0OWDFMV850cc9gKqNE+bM4oMNhjCKlc/dluD+7v0Ozr++j74hF9kFDdmr0isgZfihe5P96AYHrKXiOOIisd/j2uh43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 SA1PR11MB6896.namprd11.prod.outlook.com (2603:10b6:806:2bd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.12; Thu, 30 Oct 2025 20:33:58 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 20:33:58 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v3 25/28] drm/xe/pci: Introduce a helper to allow VF access to PF xe_device
Date: Thu, 30 Oct 2025 21:31:32 +0100
Message-ID: <20251030203135.337696-26-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251030203135.337696-1-michal.winiarski@intel.com>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: WA2P291CA0014.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::25) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|SA1PR11MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: e6c1c1d8-c32b-4b13-6c45-08de17f3a735
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NG9tUUVEQ092R2pYTVp2Q1MrdWxzc1dDRnVWckFjV1FaMkpjUVNtcVZEbFJS?=
 =?utf-8?B?UWl2M3BCb0NsNUtWbVlDVHp2Y2VBMUlyZFhFem05QzM5YmZnVGl0K0NJd2cy?=
 =?utf-8?B?SWVXVmNRTUo2SEM4aEY1S3BGVHA2ZlJieU9Sd2YwakZtYXU4MzVlUHFNOHha?=
 =?utf-8?B?MVpOUUQzRE1LZHl4eThBdTJMTUpFeld5RWJ2YTBpbnFpL1RKUmduWWQ4Y0FD?=
 =?utf-8?B?bVc5N0J4djRLeThOa0YrZzV4S3ZGRDRFWnI4VUVkY1M2K0QzTnloZVVMU2Y5?=
 =?utf-8?B?dkRDdlRhWUtRcG9XazMxYXVkUU5pQ3dlTXpyL1RnaEY4d0FqcC9PaUtJdkt3?=
 =?utf-8?B?MmZYRWFUYkd3aTcvQlV6N20zaElWbWZscDFQc3B5aEQwMVNPY1NoQzFFZUg3?=
 =?utf-8?B?NHZMMVRZaTNrdUExb3JIYWlhYlZ6cEREQmJYQ0k2aDVsME9TM0NjQUsvQ1RJ?=
 =?utf-8?B?UlR6SFNXS1VKaWFUN2NsMnpyMkhlb3doRVBOZGkvblUzbFJUVTU4bUt5QmRn?=
 =?utf-8?B?RDZwRStxeXNLeENGSURaQnM1Qi9xdEdDZGNmSkZDSjM4S1YyVXhLQ2NUdCtR?=
 =?utf-8?B?UVZSSTQ1QzBVdUNkWG1zcTVWdGNtZmhoaTQ0UWNHOER1VjlOelg1TWJlV0ZU?=
 =?utf-8?B?ZXdJSEZOdnBJSHNBLy93T3dhSnlkR2I0RlpsUTN2cHIyd3RrVm5uS3NMZmFI?=
 =?utf-8?B?b21oYi9TUWRzWkV2ME1vcW9CUmZkUkRHalJSNmlPWmx4Szh6ODhyZWFCaTBp?=
 =?utf-8?B?amZxU2VQOGt2citUYytXNWVFSkptUEJKbDVWZ2FVb2ViaHNMdFYvbzN3MldC?=
 =?utf-8?B?b1N4MUFFNHhzQTFzZVNmQ1hyNng2WkdXbWNxR0dpeTNjei9FV09pNktSNXRL?=
 =?utf-8?B?WjIvTUl3cTB1SjU5eURMekhGU05oeTFGMWZSa2ZFdFc0djd3UVIzdVRHcERO?=
 =?utf-8?B?dDV1dkk1K3A3akhCYnJNNWZuQWhQTVZ6Yk9vOGFTaGRIR1o1VzRsVmJORVUx?=
 =?utf-8?B?a1lkdGV3M1ZkTEtzeDJWeGplZEY0TGFpTzlZRXIraDJFTWt2dGJNb0UzWlRQ?=
 =?utf-8?B?a2R3am1OTDJ5cWVicnZ5QVY4ZnE4VURCd2xsejVnaGd0WkhHMEgxZjhtZEpj?=
 =?utf-8?B?a1hLTmZRUHNXSVRISDNVdHlzcWU2Yi9vazBxVzZmRitQakhzRTJYLzhhdHlG?=
 =?utf-8?B?NXc0cGpzcjhrMmE0OWFWUjRYdlJuQmNKOENLeGZQakxGZW4rU29XTlZSWFF6?=
 =?utf-8?B?MEFMSjNHQnN4SEVnS1E2eGxpV2RmNHM5NjlPZzdPUC9seWQ3LzQra2lIQy9a?=
 =?utf-8?B?N1VOLzh4K2gycWVDdnlCY3E5WEtnMk9yZUpHTHdoKytaZ25lSkRvOXFsMXY2?=
 =?utf-8?B?REwxR3Y0Y1Q4YmY3SFdYQUtvKy9sV0EzYWEyQlQ4RGpZeldMN3Z2RXA0bDE3?=
 =?utf-8?B?eUVlTkR4a2JMKzU3Q2dmR0lVQXRUTXIvT01BZ3BmdjRoMXloYmVuOGMvWUdR?=
 =?utf-8?B?ZmFpdmVrMFB1WG1VeG80dFE1bjZPR3FwOXdPYnVoWDlxZ1NybFlkR1p2RXFQ?=
 =?utf-8?B?OXExMjJmb3JET0w0TUdvejJkNDdieVJIV21jVEY0WVE5QWx0TTlRYzVxTmRH?=
 =?utf-8?B?TEZyK1hiTU1oR2dpRmo3VXZuQ2JqelRBdE9qL29wdENCQ2hXWVlLcFhaVEFX?=
 =?utf-8?B?SHNvUEZFYnFNRjRsRFZFY29sa21ZaEVwQkZzWkZOanV6L3RPZ3ZnR2wrYy9o?=
 =?utf-8?B?SlVYSGVVcjc1a0pnQ1poNFhlbFVhczkrYjc0dW52YnZES2RWVjhpQXovWnVB?=
 =?utf-8?B?NEhwSk9sWFFCOCtPNlltRHBzVk1ERTYrZzNCdzRpekcyQTdIV3N0Q3lCTURV?=
 =?utf-8?B?YmE1bHptMURPL2tramVkUXJLOVB1Ti9SbzZiM2c4RHFWTjJha05JZTg3ZW5Y?=
 =?utf-8?B?N1B6Tk5EaTJVMzRkMXhoVFFNWEthVXdrUFo3L2h5Z2dGSGMrMGNscGlSdXd4?=
 =?utf-8?Q?ngBvvQrfd6ffAUaon3cPx2VQlv8Koc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTRhMHBFeWxPTjVOYk1peHVzampVU0NKbi83Uy8rdmdPdlYzdTFxRFRFcW9K?=
 =?utf-8?B?c3N0eEtmY1B0ak92aEhSTjRTYTF2R216QlB6RXRjN0FUck1UMW9mYlNTK1Y2?=
 =?utf-8?B?Vmp1NzN4OTFqRk4wM09zU3ViV1VXa0tHMy9iTmtKcFdqQnV5bXRTMmFROFNp?=
 =?utf-8?B?V2ZOemtBd2VDcmJuWHFWZEJBdVRndFJWdFBmWXBDemdnNkFOdXVrenY3Q3o3?=
 =?utf-8?B?WkZvdEFtaCtCellveDdCdVcwWTdPeGU0MW5QWmE5Mit1ZEdObko3YzRUdEVt?=
 =?utf-8?B?ejA3dmRVTEkyVzl0alNrS25xOU1Nc1kxRHZzU1hKRDhyQlFjenVueVlYM1hR?=
 =?utf-8?B?SVM4dStHa0pLdXZYZ0RrRjdnNXRjSXpqaXdlSHAxOTJwRlFJbVFneVBDVlJX?=
 =?utf-8?B?ZUs1Wi9mbGFYY1F4aDRDYjdZS0p6YVYxWUxhem9XMVBQQWVPR3ROdTJ3dlFP?=
 =?utf-8?B?dXR1bDVaaEo2dGpyOEl5dFpNOEk3RjZ0WktoRXgvaWYrcW8wLzNUNkhXMEhE?=
 =?utf-8?B?T1RpR0d4Nk0xV251ckU5YmordGdCckFVT0xmRTZxNFkvaWYrckhrSHd1L3lH?=
 =?utf-8?B?NnFnWDVMRm81OVBjOUxHN0h5RVM1TEJTcUlQM3pRRnZ2UnNIWEs3cmNFSFc1?=
 =?utf-8?B?dk9SWXYza3paTXJNSnNXd0hwd1ZNeDFVQ3ZibE95UG43VFBicjZmaGtVMU1H?=
 =?utf-8?B?QnN6Q3ByTGlpVVN4Z3BhQnRjd0NuK2dsVlFSTDlYbWxXZ0szdmE4bDhHZlph?=
 =?utf-8?B?czB2SEVnWjZtcnJWSS92aS8vUWxmeDFNVStlcCtocFBJejNwRGV2RHRrU1U4?=
 =?utf-8?B?OXZ2RFdGVTJPamRNd0VjdXp1RnoxOVNTbDZhdE9KYjEzNHZUN0lmVnUrZTF6?=
 =?utf-8?B?SHZUbVZienJYakw1UDJNSGdvcjhMcFU4QkF4TE9VWmZlTk0rMjNOajUxVDdl?=
 =?utf-8?B?YlZ2OWMrQVBVK2ZLMUVvY2lZSFEzMk1kcUJWMkt0U2lwUDNMNk1CQStDaGNW?=
 =?utf-8?B?T3NYTHN6cmxSWFVlUDRPUTdWOVUrdkxEZHBqVkR5WjFqUmVmbWRlRmpMVHAx?=
 =?utf-8?B?TVRRMUhWTjRLMk41YWpReERtUkttSW9PY3pwaEU1MGhpUjIxcnRQcmw5eGlq?=
 =?utf-8?B?UWRFR2FMVTk4NVpvVmRkQ2tTMmkzZWltZDJWOUdOK2tHVEhpd05NRWlwZkVv?=
 =?utf-8?B?QnhEN1BYdk16bjlvTzhBR2cxQm9kMUNWdWptRjN5NnYxSzhWZ21aT3lJdlhE?=
 =?utf-8?B?NStyVkE0UVcxSFBaMUVtT3RVSU9SRG1FakJNU2dCeUNNU1VpV0xQNnZIUXRz?=
 =?utf-8?B?SXhJQjNmRHVkWE5iWlg4NXRCZElzem1sWE9UWGE0OWJlenNEaUtJaStLR2Fl?=
 =?utf-8?B?djB6SmlDa3ViSk1ZY1hDZ3c5aCtUUHVDeVh6RG9PZnFTY0JWdzJpVFhUZ3Mz?=
 =?utf-8?B?RUs4cU5jZzB2ZmR5UTFiQWs1ME1wSCtiVmRrcFM0b2s5bzY1SGN5UWw3RmxH?=
 =?utf-8?B?V0Q3eHNVeDFudUVrajBvL0tadkphNkl2b0ZSbVptN0JQNEdOWllDRUpxUGdm?=
 =?utf-8?B?K1NuV0F1ekxKRmR6RThuYXFtQkhPWE9PaDZWaWVnUW44VEZQeDFqTDRSekNT?=
 =?utf-8?B?REpsT3puYmFCdVdRaExMaXdEWlV2OHYvQXpWb2I4Q2Z6VStuZXlNdzVMcTBN?=
 =?utf-8?B?MmFubnhXd3RWbEFpUEw2T2lxYkFiQm1wNzBhaVowM0RyN3NvdSt2d0psRU0y?=
 =?utf-8?B?RjBJYkRWR1o5UENPQ1Zic0lpMUdlWGdOUktUblByQ1J0N1dQQ0tBZjhGRkNa?=
 =?utf-8?B?MTV3d0ZxOWZyVDRpWHVHNFQ5bmMxSkJMcHU5TFNUL0NyTE53L2tDMm5WV2FG?=
 =?utf-8?B?NVJBRTR0N29DUFRSM3c4QzFQcE5MM0wxcmxUVUU3bWFRK0lYM2U0dk5GZGFr?=
 =?utf-8?B?ZSthb0xXWE5Hd3dwMGR4OGdoNnRTa0x0dElURlg3RHBvYitOM0ZKWnJ1b1Uw?=
 =?utf-8?B?OFlBMnFNZjlPcWpwZDRLRE4vV284WE1rblcxdXZtZTNMMGRFaE03QmU1S21E?=
 =?utf-8?B?NDFpejRzcTNqTnpFaVhJYVVtejhrcFNRb1pUb0E5M0hNNm1wK3ZiOUdyWGRK?=
 =?utf-8?B?cnpOaWhIcG92dytYZ05VOExxaW1zODRFZU8vQk5xNnAzQjNOUGZIYWc1WDRr?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c1c1d8-c32b-4b13-6c45-08de17f3a735
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 20:33:58.4332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Voutk2Tbe+EacTDz+zsbh/2kW2f44+oM11eKptdlNWLEYPwF1d3a+7sFZ7ku6PYmHn5cJF9dFVU/uGi1z19+a67UZ4w2uxo6oq4/MqVbhUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6896
X-OriginatorOrg: intel.com

In certain scenarios (such as VF migration), VF driver needs to interact
with PF driver.
Add a helper to allow VF driver access to PF xe_device.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_pci.c | 17 +++++++++++++++++
 drivers/gpu/drm/xe/xe_pci.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index aeae675c912b7..3e7b03c847a42 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -1224,6 +1224,23 @@ static struct pci_driver xe_pci_driver = {
 #endif
 };
 
+/**
+ * xe_pci_get_pf_xe_device() - Get PF &xe_device.
+ * @pdev: the VF &pci_dev device
+ *
+ * Return: pointer to PF &xe_device, NULL otherwise.
+ */
+struct xe_device *xe_pci_get_pf_xe_device(struct pci_dev *pdev)
+{
+	struct drm_device *drm;
+
+	drm = pci_iov_get_pf_drvdata(pdev, &xe_pci_driver);
+	if (IS_ERR(drm))
+		return NULL;
+
+	return to_xe_device(drm);
+}
+
 int xe_register_pci_driver(void)
 {
 	return pci_register_driver(&xe_pci_driver);
diff --git a/drivers/gpu/drm/xe/xe_pci.h b/drivers/gpu/drm/xe/xe_pci.h
index 611c1209b14cc..2bb2e486756db 100644
--- a/drivers/gpu/drm/xe/xe_pci.h
+++ b/drivers/gpu/drm/xe/xe_pci.h
@@ -6,6 +6,9 @@
 #ifndef _XE_PCI_H_
 #define _XE_PCI_H_
 
+struct pci_dev;
+
+struct xe_device *xe_pci_get_pf_xe_device(struct pci_dev *pdev);
 int xe_register_pci_driver(void);
 void xe_unregister_pci_driver(void);
 
-- 
2.50.1


