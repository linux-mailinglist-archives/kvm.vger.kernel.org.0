Return-Path: <kvm+bounces-60598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF2BBF4365
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 03:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DDC9F4E9D82
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 01:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA031F7580;
	Tue, 21 Oct 2025 01:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OfxJUUcH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F3224D6;
	Tue, 21 Oct 2025 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761008433; cv=fail; b=DvE1THktNotO5SeWsrFLgorwDfz8IMhK7QP3c8RQ0KqhXZfelLzgean5gbiqaLYkZC8jR9T8V3e0qIpnyL8m0Xu+TnqpzygsYDkizh9s6n04ZsVXQ5YIW6ssX4isLnpoTXE8ouzrlYk7b1X9hEPNNqnNS2M5+5juoNfxzFyo8+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761008433; c=relaxed/simple;
	bh=enV84fIzX0U1xtU9meg9cxsAytin+TbOlYqwXSH1X7g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sqjtsMLtAa92T2hobbBQtNxLRiKzlnVAQgOq64VyXP4VQZhGPdJahxDJ1bqgwBNSEjAzZo2V/4VqiPMofwJ0zPtTWtiDH/PJ+N1GAfRd7EjPA6ZDcrJeI5ZmvxkMuA6AMbxcTAZoyFSCcC7MAE2tYku+7HkOSlXT1SVUmanJslU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OfxJUUcH; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761008431; x=1792544431;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=enV84fIzX0U1xtU9meg9cxsAytin+TbOlYqwXSH1X7g=;
  b=OfxJUUcHxedG4J+KccijOvdLLP1TMJUI5kiC1eFkr32EgFecwn0QYTaB
   NA8zKnnaPZRSVjkt8O77h+L8/+inKv7nRk4m3YcOAsru8hrmptrFZBKxU
   Y5UxPsT4/NbdLYbFBC2tJrgQiVGkQfChyai07XUamSOlYMLDWb63ApXQ2
   MeSa+regfq7mOhg1GOzWXfEPL7p7Ow7YjLRgnJTZvX8LMfEtRkuGa3Bje
   456LTLkRnIGBtfU2Y+Uhqi+d2ffL+oQwU0q8OEUn38I3CkJVPVqA5cFOg
   NnDbcjzk9zj/FxwRUHwpClIEb02LABfsNEGy4RPPHR45fU91DIalFblDn
   w==;
X-CSE-ConnectionGUID: 9JsEMO4cSg6dZAkizXX7jA==
X-CSE-MsgGUID: 64TpTS/rQbW46pWR0mTzJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74474868"
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="74474868"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 18:00:30 -0700
X-CSE-ConnectionGUID: rigKMJeLQXStsMhgPptRgg==
X-CSE-MsgGUID: SzzMkHbTRtuKMKFARHvRhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="207141346"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 18:00:29 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 18:00:29 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 20 Oct 2025 18:00:29 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 18:00:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibL8ApI1w5sE/tpnhJQst850JXAbcUJWPL1AEmai+Kvq7Oonnd6D6yKMZn7WlwMTO3QDMt1NZbp6XP578g50UAt0zDQLr7U63TyJYXewpnmDosotjOH1bjkHJFbeiR5y5imvsPPyPgqrr6IuzozTv34AkgBERN9BuIYN6kQGiCKKnTdDMq804wYE84TVDeFBTHLbfmWMXzlPeaNJnivW8hC18RYSq2F0Pe7O9n5Z2YasE3pFvoWYtH1XTqHGsF2dvi8OSO02XBKGUhyeuq5lHTQgM+mx+9G5E0CSHPyGdaum8Tv//Qw6Kg65nffd70JESN3Hf8IJ5vqAaQWQBEqS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFBoZ0N4b+HeHBE1NULwmlRFMMh97pXDts+KI/o4fic=;
 b=mSN/ohuO0o6LWqEQpA2XB0HZRQggC7fQ2DbddZKmuU165ne90DLCrf3RJBO1QTdeiO41IuUPRwbMQnC/KE6n5Lxv2DY9R84lSapcJHW4+8xJuLptOeaIF989jCXdmapruAy0vmbXZgi/jVBygkfnpQ6WeTOLuVU6uXUr04maoToqtAwRrj59f8MMw61cCoGn5tgsu/vgvVYXTFVWrM3vCyYSf+y9/Ra7R2DlqB7YUrfCTo+bGoGj7T04KCQqEIHh0d9IEyko3CXwCJ0CNrXWO6OucjUvhNJi6Hi64v2d8qluf/jJxUMkj7UKDp2YIhjy2XTq0HzGS7591elq/A4lDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPF1A07FAA60.namprd11.prod.outlook.com (2603:10b6:f:fc00::f0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 01:00:27 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 01:00:26 +0000
Date: Tue, 21 Oct 2025 03:00:23 +0200
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, Matthew Brost <matthew.brost@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>
Subject: Re: [PATCH 17/26] drm/xe/pf: Add helpers for VF GGTT migration data
 handling
Message-ID: <j4o3s67polhkv6yf25sovuntambga6ic32iq3i6j4wmenkacs7@gi64crxi3o5b>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
 <20251011193847.1836454-18-michal.winiarski@intel.com>
 <83f83d86-a89d-4315-aa01-9c48e782bd60@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83f83d86-a89d-4315-aa01-9c48e782bd60@intel.com>
X-ClientProxiedBy: BE1P281CA0265.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::19) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPF1A07FAA60:EE_
X-MS-Office365-Filtering-Correlation-Id: 685b0f42-6441-4236-f055-08de103d38d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VXJwdmJURExmdjVxcjdJT0IxZFQrK1luWXhUbmxpZXVjbFBSQU8xNnVBOTNH?=
 =?utf-8?B?WDl2UE1LMDU2cy9Bd0FlRkd6MUt1UDdOQ1hUSTNvZFpwdHVJSTZjWFlUVnln?=
 =?utf-8?B?Q0djcm53T0lhdDJkL2ZxZ1luMkk5ejlJMDhhVnZONUp4WlFjR01rdDZuVWZ2?=
 =?utf-8?B?Z0M1bndjeTF6UEZDblVBOVBHenlFb1pyKzJjYitXTXF5SVdabFhNK1E2ZVd6?=
 =?utf-8?B?WVNvTzNxRGQ0YjZGRks0OVl2ZWZUTDFJM01YdFA3cTVPWms3SkdSdEthZVBk?=
 =?utf-8?B?QjFtYWJ4Slc0TDA0YTBIL0lsbWJ3NGRybGs0cUExQUhpa3M2TUt4T3J1T1gz?=
 =?utf-8?B?WHUrenovR0k3cjh5ZGs3SDNSSW9EVU4yM2RDMHk5eDZMdlFBdkxPeUJROXhF?=
 =?utf-8?B?dHp1dHRwaEZaWUVnT0IrQ3dLR05seTdzK0ZvWmtJRVdoZ24xMHZMc1BHREhG?=
 =?utf-8?B?a0Y2KzV2Rll3REhnbmJENEVZeGpQWWkxM08yUzFuV0tGWDhDenFRd1RFRjEv?=
 =?utf-8?B?MzA2cmJKRC9HR3E0K0FSc3ZZYklOby9LUEhRM0t4K0VhMmJIcllrWGlpT0Yx?=
 =?utf-8?B?WWtrVGMxK3A2b1lWcXplaDBaZEoyNnV0aVFtcWxJTU0xVjh5NTk1UE5PSWE1?=
 =?utf-8?B?U3hYbE5IQXdUUFV0bkYwb2hUbkFYb1lya2s5TnJVRVR0OXNFelZFcW1Pdzkx?=
 =?utf-8?B?WkZaR3JCbGhFS2FzQkx6bmhIazdmRDVvR01kSkM0dE1VYnBHc1lidzRXOUFR?=
 =?utf-8?B?S1F2YW1aQkhhMUlMdlcvSWp4U21JYUY5TWJ6SFVoUVdaVlVPdmkxU1o3MmVW?=
 =?utf-8?B?dlMrbko5WnpxaVZTMGczZUJXWlpNditWOVlXQ1IxYmZGMWtTWnRPaW9CVExr?=
 =?utf-8?B?ZmllSWpyc1diRUMrWG1vK0NSazlUNVowVE9CTlFZbnVnZjFyVXUwVkpJM2lp?=
 =?utf-8?B?T2t6THVobFBDcThsSnY1Y3UxR1ZaWnlnejFiY1J2WllMdldqaWg1bkxiQjdF?=
 =?utf-8?B?ZEh0bmgyYXg1MFZKMmF5djRNT25Hd3BSWmZERm1RV0xBblZXaTNzc0dXUjQ0?=
 =?utf-8?B?VHo2dUVtVDdMQ0tYcHM5SlFSclh6cEE4ZTdWNVZWMmMyUWZ3K1pBTkdxd1pi?=
 =?utf-8?B?YnRwVEVNTmRqZDVXeC92SWFxTkdWRVRtL2k0THdLRFBzS0lDV1Q1bVFobjZj?=
 =?utf-8?B?bW1SdnVPUWFuY2F6MmlYRytaMW1hNVFUL1JmeGRZWHpUSDU0SWkxWExUNTA3?=
 =?utf-8?B?MUJ1eEEzUDJOazhWZ0RUeGxuWisrVG9Ba0lUczNFUWhhQ2pUdGcrMkF1Zm5B?=
 =?utf-8?B?dnk2TmZpZUpJN3MrNmVXNytOWFJtYlhtZmk1Y3I3WEZUSEJtMDhUSitiQ3BF?=
 =?utf-8?B?S3BGWjZZUFJoWExWOU85SXp3YUNzVFJ0WWtZcEJsNGY1WXAyRzQyTHZLOUE1?=
 =?utf-8?B?ZVVlUzlOTVNJWFdaOG9hVUtSdUcvSXAycGtsQmFnMWtFai9iMWpKNzdzTy9w?=
 =?utf-8?B?b0svOTY2elpQYjhRYTVZWVlIOVRYWlBYcWM3cSsxWjVQTGhhK0JSNWZKb3E1?=
 =?utf-8?B?VC9kMzZ1U2tyN2N2WU40YnhvUnIrbWZFZklHUVU0c291UC91OVBlQ1V0NEtk?=
 =?utf-8?B?ZlljWjdlTFNFc2dQY05sS2gzUWlYc2trNEFlUjB5RjV5aWVTYjdNd09xWVRF?=
 =?utf-8?B?dXFLZ3BKRGVZNVhDbHJ3WHQraEZWTE9QT2RFWjF6VDQreW9uN3h2RDUxZjZw?=
 =?utf-8?B?UXhTempNS1NMTmNheDVwbFlXeDlBTWVyVC94ajNMM2NWRmkrcmtINTFySFky?=
 =?utf-8?B?MXMzUUhCVng0eWd2NDVkSTFzcVAydXRkV3dEdG9SeFBzVFBIV0doVEYvRHND?=
 =?utf-8?B?Y1pWZ21qZHgzamJyWk5QUE1CdkhFbHkvWEdpajlTd29ta3YvSmJkNHZNZXc2?=
 =?utf-8?Q?v9d/AOEkA1RJSVMKKOrQoBIifqXmNpix?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDlpVWk3ZUxQNytWVnprTW8vcXZNT3RWYWo4bDdSQzlKdFJ4cFRISkllVWxO?=
 =?utf-8?B?UlNPRE1IeUord3BDUzlneUdleVlMZDdHTFpHbkpEbkdJbjJ1Sm5aUlRuTFF4?=
 =?utf-8?B?Wk5kUTc3SkRzRmUxbVROVVE1TDJSNWJ6ZlVWR0t5RE9SUTVBMkJTTVdET0p1?=
 =?utf-8?B?QXpMKzcwdEtyRVRVVzdqVEtVWWZEQis0emZJU2NYdjJTU3JHa0dId1V6OStC?=
 =?utf-8?B?MW00TW5xTTcwL21ra09GTzcwYW1sNHFPS2pVVGlKZWhPNUkrdUtVWG9ObmdE?=
 =?utf-8?B?YW9NZEVVUlZ1TFZzRVpFVHMydW1RcVdQT0pvL21lbi9vY01nc052ZUJjbHB5?=
 =?utf-8?B?U3lOVzdnZEFjNzFxNzArVFFKeVJ6bmY1TGJvcFBxTDZxQVlnWjM2bjByYzgx?=
 =?utf-8?B?Ym9Ob3pNUFNuc083WXFvQnF1bXZYZSs4emxERUZkdEJTRTlaUUVUUmpoQ1lL?=
 =?utf-8?B?SStKWU1wVC9ac0l6cnh5eGRCNkVaaTlNdXo2MGt0d1FyVGRtSW1SSG9JZ3Vi?=
 =?utf-8?B?VjgrZHZCNFZWUnp5NkNadUxma2hsb3Z3Rzh0eUFxRi9RZFkxakpSMitmYTFX?=
 =?utf-8?B?VkxSMWlBOVRMUkU5alRRRmoxanJ0ejdXVU5VYUprMnNMeDVIYlJpR3hDa3VK?=
 =?utf-8?B?c2VId3FyeTZlVmdHTGFVR0JMb2kzVEQzdHNvOE02SVNPdm8rWVZXZzNiaFJN?=
 =?utf-8?B?aXJIOFAyeWJkTnVaYzdPb3U4bW1RaTVGTFY4WmwrMy9OK0M4MnNDQVZoK3J0?=
 =?utf-8?B?MWdhNGRvM20ya08zVGN3VEZlL2xJNnhucWpkSGYvdUNYMUpISWpsdkhrdGM1?=
 =?utf-8?B?ckh3aThGcEZ4Qm1HV0g4a0hQamRUV0x0ckdSbTc2NVV0QTVXeS9oTC9RUGto?=
 =?utf-8?B?WGcrMDdBNUZPVDNzeFh0VGZYMlNvdXdtVERyMnJFR3h0WThqd0JKdjZpZGZS?=
 =?utf-8?B?SzdpbzNhak5DKzVpc1JDUU1nbytLT3dYQjY2WS9RdFNIRmFseWRWY3B4Uy9Q?=
 =?utf-8?B?bldyczJIdm5hZ3k2U3p3SFBaS3N5bTJ4SUpwaVJtbVlFcjNyOHdqR0hGbVl6?=
 =?utf-8?B?ajJCcHdhQUZpOVVGamE5SnAwQmw1c1RsUk9hMkVUWGpleFJiMGVWWEFhc2FN?=
 =?utf-8?B?SHNGMVdiQUN5NkFuNDEvbEl2SlA2VjR2S29GSTJiRjUwK2hHdExmUjJhMzdV?=
 =?utf-8?B?ajZQVWhzeXAwd2dyUkl1c04rQktUODV6R2lQcEl0MlZsRUZiZ0pJbDJEMWtF?=
 =?utf-8?B?T3laR2h6VzkxR1cyUHplSzA0SkVaL3ErSjR4Qk8xRmRmS2ZNeitLekhxSVBT?=
 =?utf-8?B?MktGSGcwN2lPc1ZZcmtwV3YxTjVTRlFHL3NONlFDaUtvTktJQm95NW5Pc3dW?=
 =?utf-8?B?cWxjbHhETHRTelIyMFR5V2w2aTRtOVlKTmVUUy9aOS9xNHBxN0VBVklodndM?=
 =?utf-8?B?NDNtNnVSME8zVVR6T1RucS9Lb3Y4anAxZXFzOGhGL0dBczNoQVV4ZExHK290?=
 =?utf-8?B?WmVzR1pwMTY4R0pQclozb2d1OU5CVnh2REZqZkR2Z3g0aHVkeXUwU0d4aHlj?=
 =?utf-8?B?a1I4T2xMdWxHWlArQ21acDFZKytBUHl1RSs0MGVLZFAwOTRGUi9RWFFOL2Jo?=
 =?utf-8?B?RE1zMzFUcFhVK3VKZnBJempGZmNHRVhTcEhiRUJnWGhFYnpTTHp5V2hCYTR0?=
 =?utf-8?B?UVNtWEYwM1VDMTVkVmhxNEQ3bXBzcUVWam03bTVzY3hORXlRNGxRYU9kWUVW?=
 =?utf-8?B?Q0UxYSt2enE3WHl0cFNxQmJCUFRjNmVGc0J6bDM1ck5QTlRYcmtxdEdoY2dT?=
 =?utf-8?B?cW1YdVM2YWxBMkZjTC92S295QWdlbmd0YWp1UFZhNzJoYVZTaUZweTE1bUt0?=
 =?utf-8?B?WWJ0YmZtRXNBczc2d3lNcWVnYkp0SEJaSE1qV2tTUFFpbTZwanU1V3FsODJs?=
 =?utf-8?B?dzlpTmFSOUNFVmpFT0xROW0zb1dKWTcwYVI0cDF5WDFUSjhCa3FwRHY5UzB0?=
 =?utf-8?B?Y0pWUjRwaEFabW9Ed00zclhKMUZlb2FRRXRYRmdvNW1XK0dDNlZQOWJ5Wm5v?=
 =?utf-8?B?OWNaR3hQanZPcXBPWFc2VlpHd0c0VFJERy9IWkRGTXY2MnJYZWduWFd1dmt0?=
 =?utf-8?B?bFJNaFdvNmUyTlNneVFldmVKeVllcUdtaU5EeTU3MlZxT0tTNFVUR0trSnlV?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 685b0f42-6441-4236-f055-08de103d38d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 01:00:26.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmawtOsMo1XnnJmwDjyuinYyRgbt9DZiOZqrbdvPeVmGOYvBGNf9sNfrZ90zw1lf8Uo5+uV4vz31C0DHntKR2tM/hl75oEWP57wQsIKZD/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A07FAA60
X-OriginatorOrg: intel.com

On Mon, Oct 13, 2025 at 02:17:56PM +0200, Michal Wajdeczko wrote:
> 
> 
> On 10/11/2025 9:38 PM, Michał Winiarski wrote:
> > In an upcoming change, the VF GGTT migration data will be handled as
> > part of VF control state machine. Add the necessary helpers to allow the
> > migration data transfer to/from the HW GGTT resource.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/xe_ggtt.c               | 92 ++++++++++++++++++++++
> >  drivers/gpu/drm/xe/xe_ggtt.h               |  2 +
> >  drivers/gpu/drm/xe/xe_ggtt_types.h         |  2 +
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 64 +++++++++++++++
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h |  5 ++
> >  5 files changed, 165 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
> > index aca7ae5489b91..89c0ad56c6a8a 100644
> > --- a/drivers/gpu/drm/xe/xe_ggtt.c
> > +++ b/drivers/gpu/drm/xe/xe_ggtt.c
> > @@ -138,6 +138,14 @@ static void xe_ggtt_set_pte_and_flush(struct xe_ggtt *ggtt, u64 addr, u64 pte)
> >  	ggtt_update_access_counter(ggtt);
> >  }
> >  
> > +static u64 xe_ggtt_get_pte(struct xe_ggtt *ggtt, u64 addr)
> > +{
> > +	xe_tile_assert(ggtt->tile, !(addr & XE_PTE_MASK));
> > +	xe_tile_assert(ggtt->tile, addr < ggtt->size);
> > +
> > +	return readq(&ggtt->gsm[addr >> XE_PTE_SHIFT]);
> > +}
> > +
> >  static void xe_ggtt_clear(struct xe_ggtt *ggtt, u64 start, u64 size)
> >  {
> >  	u16 pat_index = tile_to_xe(ggtt->tile)->pat.idx[XE_CACHE_WB];
> > @@ -220,16 +228,19 @@ void xe_ggtt_might_lock(struct xe_ggtt *ggtt)
> >  static const struct xe_ggtt_pt_ops xelp_pt_ops = {
> >  	.pte_encode_flags = xelp_ggtt_pte_flags,
> >  	.ggtt_set_pte = xe_ggtt_set_pte,
> > +	.ggtt_get_pte = xe_ggtt_get_pte,
> >  };
> >  
> >  static const struct xe_ggtt_pt_ops xelpg_pt_ops = {
> >  	.pte_encode_flags = xelpg_ggtt_pte_flags,
> >  	.ggtt_set_pte = xe_ggtt_set_pte,
> > +	.ggtt_get_pte = xe_ggtt_get_pte,
> >  };
> >  
> >  static const struct xe_ggtt_pt_ops xelpg_pt_wa_ops = {
> >  	.pte_encode_flags = xelpg_ggtt_pte_flags,
> >  	.ggtt_set_pte = xe_ggtt_set_pte_and_flush,
> > +	.ggtt_get_pte = xe_ggtt_get_pte,
> >  };
> >  
> >  static void __xe_ggtt_init_early(struct xe_ggtt *ggtt, u32 reserved)
> > @@ -914,6 +925,87 @@ void xe_ggtt_assign(const struct xe_ggtt_node *node, u16 vfid)
> >  	xe_ggtt_assign_locked(node->ggtt, &node->base, vfid);
> >  	mutex_unlock(&node->ggtt->lock);
> >  }
> > +
> > +/**
> > + * xe_ggtt_node_save - Save a &struct xe_ggtt_node to a buffer
> > + * @node: the &struct xe_ggtt_node to be saved
> > + * @dst: destination buffer
> 
> correct me: this is buffer for the PTEs
> 
> > + * @size: destination buffer size in bytes
> 
> and this is size of above buffer
> 
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_ggtt_node_save(struct xe_ggtt_node *node, void *dst, size_t size)
> > +{
> > +	struct xe_ggtt *ggtt;
> > +	u64 start, end;
> > +	u64 *buf = dst;
> > +
> > +	if (!node || !node->ggtt)
> > +		return -ENOENT;
> 
> hmm, non-NULL node must be initialized by xe_ggtt_node_init() which sets the .ggtt so this second check is redundant

Ok.

> 
> > +
> > +	mutex_lock(&node->ggtt->lock);
> 
> 	guard(mutex)(&node->ggtt->lock);

Ok.

> 
> > +
> > +	ggtt = node->ggtt;
> > +	start = node->base.start;
> > +	end = start + node->base.size - 1;
> > +
> > +	if (node->base.size < size) {
> 
> so that's looks wrong, we are about to save 64bit PTEs of that node
> 
> we should compare size of all PTEs not the size of address space allocated by this node

I'll replace it with

if (xe_ggtt_pte_size(ggtt, size: node->base.size) > size)
	return -EINVAL;

> 
> > +		mutex_unlock(&node->ggtt->lock);
> > +		return -EINVAL;
> > +	}
> > +
> > +	while (start < end) {
> > +		*buf++ = ggtt->pt_ops->ggtt_get_pte(ggtt, start) & ~GGTT_PTE_VFID;
> > +		start += XE_PAGE_SIZE;
> > +	}
> > +
> > +	mutex_unlock(&node->ggtt->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * xe_ggtt_node_load - Load a &struct xe_ggtt_node from a buffer
> > + * @node: the &struct xe_ggtt_node to be loaded
> > + * @src: source buffer
> > + * @size: source buffer size in bytes
> > + * @vfid: VF identifier
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_ggtt_node_load(struct xe_ggtt_node *node, const void *src, size_t size, u16 vfid)
> > +{
> > +	struct xe_ggtt *ggtt;
> > +	u64 start, end;
> > +	const u64 *buf = src;
> > +	u64 vfid_pte = xe_encode_vfid_pte(vfid);
> 
> try to define vars in reverse xmas tree order

Ok.

> 
> > +
> > +	if (!node || !node->ggtt)
> > +		return -ENOENT;
> > +
> > +	mutex_lock(&node->ggtt->lock);
> 
> use guard(mutex)

Ok.

> 
> > +
> > +	ggtt = node->ggtt;
> > +	start = node->base.start;
> > +	end = start + size - 1;
> > +
> > +	if (node->base.size != size) {
> > +		mutex_unlock(&node->ggtt->lock);
> > +		return -EINVAL;
> > +	}
> > +
> > +	while (start < end) {
> > +		ggtt->pt_ops->ggtt_set_pte(ggtt, start, (*buf & ~GGTT_PTE_VFID) | vfid_pte);
> > +		start += XE_PAGE_SIZE;
> > +		buf++;
> > +	}
> > +	xe_ggtt_invalidate(ggtt);
> > +
> > +	mutex_unlock(&node->ggtt->lock);
> > +
> > +	return 0;
> > +}
> > +
> >  #endif
> >  
> >  /**
> > diff --git a/drivers/gpu/drm/xe/xe_ggtt.h b/drivers/gpu/drm/xe/xe_ggtt.h
> > index 75fc7a1efea76..469b3a6ca14b4 100644
> > --- a/drivers/gpu/drm/xe/xe_ggtt.h
> > +++ b/drivers/gpu/drm/xe/xe_ggtt.h
> > @@ -43,6 +43,8 @@ u64 xe_ggtt_print_holes(struct xe_ggtt *ggtt, u64 alignment, struct drm_printer
> >  
> >  #ifdef CONFIG_PCI_IOV
> >  void xe_ggtt_assign(const struct xe_ggtt_node *node, u16 vfid);
> > +int xe_ggtt_node_save(struct xe_ggtt_node *node, void *dst, size_t size);
> > +int xe_ggtt_node_load(struct xe_ggtt_node *node, const void *src, size_t size, u16 vfid);
> >  #endif
> >  
> >  #ifndef CONFIG_LOCKDEP
> > diff --git a/drivers/gpu/drm/xe/xe_ggtt_types.h b/drivers/gpu/drm/xe/xe_ggtt_types.h
> > index c5e999d58ff2a..dacd796f81844 100644
> > --- a/drivers/gpu/drm/xe/xe_ggtt_types.h
> > +++ b/drivers/gpu/drm/xe/xe_ggtt_types.h
> > @@ -78,6 +78,8 @@ struct xe_ggtt_pt_ops {
> >  	u64 (*pte_encode_flags)(struct xe_bo *bo, u16 pat_index);
> >  	/** @ggtt_set_pte: Directly write into GGTT's PTE */
> >  	void (*ggtt_set_pte)(struct xe_ggtt *ggtt, u64 addr, u64 pte);
> > +	/** @ggtt_get_pte: Directly read from GGTT's PTE */
> > +	u64 (*ggtt_get_pte)(struct xe_ggtt *ggtt, u64 addr);
> >  };
> >  
> >  #endif
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> > index b2e5c52978e6a..51027921b2988 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> > @@ -726,6 +726,70 @@ int xe_gt_sriov_pf_config_set_fair_ggtt(struct xe_gt *gt, unsigned int vfid,
> >  	return xe_gt_sriov_pf_config_bulk_set_ggtt(gt, vfid, num_vfs, fair);
> >  }
> >  
> > +/**
> > + * xe_gt_sriov_pf_config_ggtt_save - Save a VF provisioned GGTT data into a buffer.
> > + * @gt: the &struct xe_gt
> > + * @vfid: VF identifier
> > + * @buf: the GGTT data destination buffer
> > + * @size: the size of the buffer
> > + *
> > + * This function can only be called on PF.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_gt_sriov_pf_config_ggtt_save(struct xe_gt *gt, unsigned int vfid,
> > +				    void *buf, size_t size)
> > +{
> > +	struct xe_gt_sriov_config *config;
> > +	ssize_t ret;
> 
> int
> 
> > +
> > +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> > +	xe_gt_assert(gt, vfid);
> > +	xe_gt_assert(gt, !(!buf ^ !size));
> 
> there seems to be no "query" option for this call, so both buf & size must be valid
> 
> > +
> > +	mutex_lock(xe_gt_sriov_pf_master_mutex(gt));
> > +	config = pf_pick_vf_config(gt, vfid);
> > +	size = size / sizeof(u64) * XE_PAGE_SIZE;
> 
> ?? something is wrong here - why do we have to change the size of the buf?

Should be simplified after tweaking the logic with size conversions
to/from PTE.

> 
> > +
> > +	ret = xe_ggtt_node_save(config->ggtt_region, buf, size);
> > +
> > +	mutex_unlock(xe_gt_sriov_pf_master_mutex(gt));
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * xe_gt_sriov_pf_config_ggtt_restore - Restore a VF provisioned GGTT data from a buffer.
> > + * @gt: the &struct xe_gt
> > + * @vfid: VF identifier
> > + * @buf: the GGTT data source buffer
> > + * @size: the size of the buffer
> > + *
> > + * This function can only be called on PF.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_gt_sriov_pf_config_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> > +				       const void *buf, size_t size)
> > +{
> > +	struct xe_gt_sriov_config *config;
> > +	ssize_t ret;
> > +
> > +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> > +	xe_gt_assert(gt, vfid);
> > +	xe_gt_assert(gt, !(!buf ^ !size));
> > +
> > +	mutex_lock(xe_gt_sriov_pf_master_mutex(gt));
> > +	config = pf_pick_vf_config(gt, vfid);
> > +	size = size / sizeof(u64) * XE_PAGE_SIZE;
> > +
> > +	ret = xe_ggtt_node_load(config->ggtt_region, buf, size, vfid);
> > +
> > +	mutex_unlock(xe_gt_sriov_pf_master_mutex(gt));
> > +
> > +	return ret;
> > +}
> 
> ditto

Ok.

Thanks,
-Michał

> 
> > +
> >  static u32 pf_get_min_spare_ctxs(struct xe_gt *gt)
> >  {
> >  	/* XXX: preliminary */
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> > index 513e6512a575b..6916b8f58ebf2 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> > @@ -61,6 +61,11 @@ ssize_t xe_gt_sriov_pf_config_save(struct xe_gt *gt, unsigned int vfid, void *bu
> >  int xe_gt_sriov_pf_config_restore(struct xe_gt *gt, unsigned int vfid,
> >  				  const void *buf, size_t size);
> >  
> > +int xe_gt_sriov_pf_config_ggtt_save(struct xe_gt *gt, unsigned int vfid,
> > +				    void *buf, size_t size);
> > +int xe_gt_sriov_pf_config_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> > +				       const void *buf, size_t size);
> > +
> >  bool xe_gt_sriov_pf_config_is_empty(struct xe_gt *gt, unsigned int vfid);
> >  
> >  int xe_gt_sriov_pf_config_init(struct xe_gt *gt);
> 

