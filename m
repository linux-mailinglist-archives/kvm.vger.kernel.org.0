Return-Path: <kvm+bounces-38979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A0FA4176D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:34:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B36616A2EF
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 08:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4517119259E;
	Mon, 24 Feb 2025 08:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n7xR2NnQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ACB1EA91;
	Mon, 24 Feb 2025 08:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740386051; cv=fail; b=mMvsuZDBg6Ddx/nQ7MyTnhCe/9At5O/fvPBwCTRHAX7SKpdJFdrsPf0kUYZG4PqkLkHXuQl2w7cguawuxX5WaW60/u/KfuqKvDe69CrIWDjY0Xd12ST8NFTNGb5l+Y4rwqcWtB9FTlNZJrfFiUuYdmszHKrnSPsonaib8yxrGIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740386051; c=relaxed/simple;
	bh=dAVgfvAhCrFHRLG0V6jTJG7Rhtd5ikGEiRPDltpMW5o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NMOcW6vOLUYF1pTaN/beW9bwrTGjozDWveSD1Woj0i505DIx+NPQVehgldZfPrN/xWSM9zqwTv4kdzL0K3lH3DPhClRIpFbS1auq0FYWApjWqhImCD8mdJ798QPacElRipBznva8Z808q/repEAGaTXwplV7su+9KCLK9Wdd2GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n7xR2NnQ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740386049; x=1771922049;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dAVgfvAhCrFHRLG0V6jTJG7Rhtd5ikGEiRPDltpMW5o=;
  b=n7xR2NnQsVBQ7uKTv+va8Y3A/MiQsaqG6eXmmPzBGbc0nkGsPOIjOwjJ
   3JBJHfaEg1h9h3uXprFoYfEMdQfdTrXse70EzwHlYtlrAQexJqcYaUlk2
   Up2kJXbgSLYnUbppwiSJpZGpGdARcaLWrPYnDRDAvhtZRGOVmU/Wf1RQ+
   aohrMzFRCfmcFdu/y43bTX7wK1Q7krcvJN4bjygIKdrqL2SN8qZ4F1xka
   cZbBg3iaVDsorkZOqfKXVubS2MkjA7xi8IglMQwphGfBOMIKlhsAt6GBb
   jiBr215qmBCVv35C5BRD0UE3/r1HcQCLlBNEwMQfr2lK9J2HSFayrM8MT
   Q==;
X-CSE-ConnectionGUID: CIcIZZRnQ9+0rkt2hkuSVA==
X-CSE-MsgGUID: aUzoMUZpQ0KnzSSx1ZVGnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="41145986"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="41145986"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 00:34:08 -0800
X-CSE-ConnectionGUID: YTPTejtqR5azHPsyvb1DYA==
X-CSE-MsgGUID: yuSNgEZ1TKi67zp/L68Uwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="115790931"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Feb 2025 00:34:08 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 24 Feb 2025 00:34:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Feb 2025 00:34:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Feb 2025 00:34:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qItCu8iuTIGhlmXLQxxNas3e61uv0V/W0yPJaZiTv9W/ESw6dAaRLmV9OzuqO78HTSNqglIeqfiIhwpBNsL8MhuIepdvpSxMDiJIzLRkYdoETWWVU5twchLlFLzqb1Vjf4oJuGqjRDQ2ESVeL2PKmF1C8mUtzzHyBhTt1xTxO+YqIS1IXxTMl5lO4kIu8ZuKcZelt6gM8PmJ17PsiO/grSrfzSLq7Nq8BZxCCbDmwfoP1NPYQ0UdQV7Wwd4Vb4mN/nGd/qWPzqawUJjWmbCGFp12mltQ7nVPg/P1sa4Suj8/w8KJC6zfh65Yj5bA3cfY3Np7nAnOa8pL1ynqVEhZgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyhVY0mJkOapj5jGNCYcFe9H/BKw/YN2P3hXVI47xE0=;
 b=jHpwvUZg0v3NCPzpkFWBraWp7sfC+78egKHWVCDurANqO7yM+A16AInNpbKDkXwDwl0ejj1sOcTquugCB0xQ0YPFJIO5AoIjgK9N+GWXkpJ87JjJVmTfOV8zWyeJH5ESqE3NUCditgE6aRjtGoilcyQRzWVnFBZBGmX9Egi6qFhXJJe7cl+ANsJCBwE9zXe4bMyh7wyjQ/LU9Rpr3cJDVMOa0m4EQFaotc8zt46NWMnt5AKpPuJc5CcW9cNpmAtgRLsThTkS32F5XgzJ2hrIENhnmt/Mbuyhw3iTUlxkNserwBcqGfSQxr9spO8+f832c+D02BOzhcqmLokt5SFfUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4996.namprd11.prod.outlook.com (2603:10b6:303:90::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Mon, 24 Feb 2025 08:33:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 08:33:59 +0000
Date: Mon, 24 Feb 2025 16:32:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
Message-ID: <Z7wuq9hQS33z7Lvl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
 <20250220170604.2279312-21-pbonzini@redhat.com>
 <Z7fO9gqzgaETeMYB@google.com>
 <Z7fSIMABm4jp5ADA@google.com>
 <5da952c534b68bba9fbfddf2197209cb719f5e41.camel@intel.com>
 <Z7kqnDDTSlfv38Pf@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z7kqnDDTSlfv38Pf@google.com>
X-ClientProxiedBy: SG2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:3:17::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4996:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e0c21de-739e-40cd-ab03-08dd54adfc4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?UvSyYmhqo6K8kHIOIQKz98cbiJrEvcqNnXW88F7z2CMZ3A7cf2+M7QRXWA?=
 =?iso-8859-1?Q?fmDvIINo4kpvjpB8PyL+NOUC2n7rzpqD4L45u/zL3OKUer5BcwvkVyuj7m?=
 =?iso-8859-1?Q?jw2+lq03z0ecqHrPi5bTxEKjpgj96pye4iA6w1aLm1KIdgY1q/s2SMzeE9?=
 =?iso-8859-1?Q?9gdcvf5BzGD0ZaC0nFEc8EFMEW9fDeET9oStum2u4CYuRnPyT/F+mJvrPg?=
 =?iso-8859-1?Q?caauxZa9Lc/GmFeXSi37cCfJCoq2zLNZcWgetdDk4my+nb5PMMs3Ciy7bU?=
 =?iso-8859-1?Q?HSZDjaUmVc/kOgoxUZVJYBbY73x0CL7fFH8jC/5Okl1v+NCpucq663vm74?=
 =?iso-8859-1?Q?X9JUmaNczlw0azu+neais4AalGdntSF1/SmwFcyZtysETOrxJY+H1oCdXB?=
 =?iso-8859-1?Q?yqtv0MxS9LZqfIddUZUii+Ouaz5JsEIG0rARH7GIGedHaQI1s3V2dhKofJ?=
 =?iso-8859-1?Q?qMn8vcfEVw8LmtlLvPggdISxojzf9nSpyCy91hw/J48IEAesIpUZThoRkc?=
 =?iso-8859-1?Q?SYJC7x87ePezXdwxEJvF9hada7lWhjc7K76M8ZWenAMmXtDFhno17J7PUi?=
 =?iso-8859-1?Q?5zJKKAmOmC7ELErM6c0BqT+Hl33yrmMuW1oGvJYXtb3gpQFMGI8YMbI66j?=
 =?iso-8859-1?Q?4qkgquJN3GkArzSwcEDOr9LDt6ZsjJC6N0QEjPufwaEg73pn2YxBSgX6m5?=
 =?iso-8859-1?Q?sCttnhpfTGnwqatXNlO8H3lfpyMNquB6xXjoxrTED6VDj2TONBmok1T7As?=
 =?iso-8859-1?Q?imq7WLmU0CBxhxS6lN4hUOq5LJloK+GcZc9oycTuW3Qa7scCZjQDbF/CBB?=
 =?iso-8859-1?Q?S/G74EeXcW+DhkDwEuo90cRlRvymJt2rEb1c9VCtn+ZgIJRyPdVvTkTbvo?=
 =?iso-8859-1?Q?DJD2IDJyZJDQVpJJiZB253hKVvYkP/9FUACaE6tHrpsZ4oHRSILDybzT0B?=
 =?iso-8859-1?Q?oYCfe6jhooBivBuyfW/1m6iypMNvNmajYO+ilp1GNsGiGWPpjiFyNHhgpR?=
 =?iso-8859-1?Q?9drVdg/OHIHa2fxzdIM0hdyX9hIzLAGl+LIlFJmT7aMUWoV1TYBaiTipyd?=
 =?iso-8859-1?Q?IPB1CiEvumWnyFP7CJqUQ1426XI8/213PFO5TRxeKzW6ciRAgAJ6Cvfrku?=
 =?iso-8859-1?Q?ZB4CPybe7ROkfANNYqgPAYR1lc5c35Z/T7fPthj1DwugFSxpQ2JaTnUDdk?=
 =?iso-8859-1?Q?ZEurWAoRfS4DjZMjQRRlZhFoD8k4aBHFI04ypM16/3yZ5A7eITEVgE4/FS?=
 =?iso-8859-1?Q?A9GS7q/jRZpsSPeMMEjfPXlB3PBjBOioqlR+1TViGgRC3y1LN0hS1FfF3t?=
 =?iso-8859-1?Q?OZpJCvUYqWM4/Q0RatGcuBRaej7QOLq8J8pqa55QI0cDWLLLDlK+Wl/XKc?=
 =?iso-8859-1?Q?/YwY0YzJy+iKLyt2+ahhTC+Agq/tv1gVSH4MD8ca6bE6p48KhiWEZNy7nR?=
 =?iso-8859-1?Q?3nFnW38R9krsWa+0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?jcD4QDuu2dUtoCGDxHOYv07H8JZXuPmBYZR1GAExsPEfaM6w0Zlb32e1pp?=
 =?iso-8859-1?Q?bK9IjORXqVRPxe6cdJ14kp5J3TiDjGaWhKkYk5DpjxEiOLjI6cg+0DQrXn?=
 =?iso-8859-1?Q?VI8t+C2WWvhyyFj+Qjgk36ayK+Zi+SdYaZJtcS0+ZJewQI4Qibhs1jHYLT?=
 =?iso-8859-1?Q?zTkzJBmyCRYqZn/7N844Cci/8ni+IOCfUhQVcj9yO9aKZCSY2pie/hTb3Q?=
 =?iso-8859-1?Q?tsXkQGLRl3VxgLPJZf9LAfrZmNgqFDSMtfUYLBA0kDJqfdv085WnNnPRur?=
 =?iso-8859-1?Q?TCsEaCWWDkNNMZl3Plfgw+SZ0bcGOQ0Wn7ilzXufp5lfO1uLVjxS5yrfID?=
 =?iso-8859-1?Q?C7EUTlxC1FrOiVuMYDz/etaNpSpypg/4CKQG+DmH8dYLxAL7WMCmZ3ABRu?=
 =?iso-8859-1?Q?DNMMf1gtDteNeFo6iEqQlE7CHFcuEOd5pkyqsKIXl0VZfZNt5AM8nvleQa?=
 =?iso-8859-1?Q?na7+aPOg6AzzszPuOomCDt/t58SauBj8f06adN6A1HPLRQh9N6g3i72Akl?=
 =?iso-8859-1?Q?OSQWPWh3i4+udcP4IbiUMiDKA6v2alcRh0WWaUIxsPYyd7FUu+s8tiwpdW?=
 =?iso-8859-1?Q?YSyf3aSo40plCKymMus3LbO5jdqG5c/utm2zmCHeGDpetHjCtnYPuCrTS9?=
 =?iso-8859-1?Q?eQVXtD9TG0y5k35AKordIxaRsmS/S4nCB3cViezMpHZJKwmrxhgh28rLK6?=
 =?iso-8859-1?Q?AWlw5+BQgYJwDkbceJ6sJnZvDBx7fk9gEmn6WOxN73j/dXwt7Z5Xa/HNqE?=
 =?iso-8859-1?Q?/UVV31xxwVC3dSznMj2mRu+cWRv18UK3COkwXMXETVmAXdAtL3GfW2MP8P?=
 =?iso-8859-1?Q?+viZoThhL2JNnzJFIJoSb0E9FmhwxbvhNgLragvvvH24BwTYABMwLMUIgd?=
 =?iso-8859-1?Q?zSu46iVvIdDhOi9c4+xdCwJ7eWf+1996xUGnGkwDXMIoa/i7r/U1dBe1+X?=
 =?iso-8859-1?Q?Igixb47FTu3VPQzoSwZjHaJ4WpeX8BI4BWLF9J/UacmhC5RX3KmK9p14Km?=
 =?iso-8859-1?Q?QSIS9NDONMTIBt+oStObK2ICJAfVCk6+BLKyLHF9F4yuhDDHEadYv0/+Rb?=
 =?iso-8859-1?Q?lGqM2flPrQ6RQsEY4r8n48svyrUbnkB5Qg4PNoBqZLmCOp1N8H+kTlNH05?=
 =?iso-8859-1?Q?3sTQUFK/soK7+QHCsV5cCBIK7pZMFIHo+lkW+shIge801DtQrtfuCnB2Mu?=
 =?iso-8859-1?Q?N4euGpw/MdkIO5N2o/GLW+sxGxQu6/r2S6NZG3YErMdezFe63X+5cTeRpd?=
 =?iso-8859-1?Q?3S50wsN4jPXATjXpgqwgpToVWlTnmhGbToyXuYC9offdmcQxyVnIR6QKQL?=
 =?iso-8859-1?Q?UjY8URSu8LaJre29sg4xlgzfIRb6tp4Xdlg0UTbUrQoUuVlH5vs/ZGFw0X?=
 =?iso-8859-1?Q?lmmxV6XLwCQjq7hkxMoSIDGVof6d0HZLQNC3FSMydo+CIPlcihO2l86JbJ?=
 =?iso-8859-1?Q?82Ci/o5/6mUNtUt+3591WyIgSWjVTagQy8D/Ysydg54Uz/oN+8x8W6P/Zo?=
 =?iso-8859-1?Q?gE52gtq20z5KbrhImTO5O6giKjqSSUNTqR4ZwbyHwJ81G1oCXZE3qMjHjX?=
 =?iso-8859-1?Q?IAhkPasCifpA7Wxy3OTYjxO9YhiB1lcDgzqF/+MPLOyVMVQ3lg02UdaTFI?=
 =?iso-8859-1?Q?dMw10pzBhwrixeM9fWTjEKUzjbtoY06mxr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0c21de-739e-40cd-ab03-08dd54adfc4b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 08:33:59.8647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3GkILfG5Ib5/fdyGs6S+5xH8g4ZsiW7CnHlhk2S+VjcRF0E3rvtUxH3DXkdGsx/1RRmbYhlnrcU/zurRBtO3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4996
X-OriginatorOrg: intel.com

On Fri, Feb 21, 2025 at 05:38:36PM -0800, Sean Christopherson wrote:
> On Sat, Feb 22, 2025, Rick P Edgecombe wrote:
> > On Thu, 2025-02-20 at 17:08 -0800, Sean Christopherson wrote:
> > > Argh, after digging more, this isn't actually true.  The separate "unload MMUs"
> > > code is leftover from when KVM rather stupidly tried to free all MMU pages when
> > > freeing a vCPU.
> > > 
> > > Commit 7b53aa565084 ("KVM: Fix vcpu freeing for guest smp") "fixed" things by
> > > unloading MMUs before destroying vCPUs, but the underlying problem was trying to
> > > free _all_ MMU pages when destroying a single vCPU.  That eventually got fixed
> > > for good (haven't checked when), but the separate MMU unloading never got cleaned
> > > up.
> > > 
> > > So, scratch the mmu_destroy() idea.  But I still want/need to move vCPU destruction
> > > before vm_destroy.
> > > 
> > > Now that kvm_arch_pre_destroy_vm() is a thing, one idea would be to add
> > > kvm_x86_ops.pre_destroy_vm(), which would pair decently well with the existing
> > > call to kvm_mmu_pre_destroy_vm().
> > 
> > So:
> > kvm_x86_call(vm_destroy)(kvm); -> tdx_mmu_release_hkid()
> > kvm_destroy_vcpus(kvm); -> tdx_vcpu_free() -> reclaim
> > static_call_cond(kvm_x86_vm_free)(kvm); -> reclaim
> > 
> > To:
> > (pre_destroy_vm)() -> tdx_mmu_release_hkid()
> > kvm_destroy_vcpus(kvm); -> reclaim
> > kvm_x86_call(vm_destroy)(kvm); -> nothing
> > static_call_cond(kvm_x86_vm_free)(kvm); -> reclaim
> 
> I was thinking this last one could go away, and TDX could reclaim at vm_destroy?
> Or is that not possible because it absolutely must come dead last?
Hmm, below change works on my end.

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 50cf27473ffb..79406bf07a1c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -21,7 +21,7 @@ KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
-KVM_X86_OP_OPTIONAL(vm_free)
+KVM_X86_OP_OPTIONAL(vm_pre_destroy)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8d15e604613b..2d5b6d34d30e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1677,7 +1677,7 @@ struct kvm_x86_ops {
        unsigned int vm_size;
        int (*vm_init)(struct kvm *kvm);
        void (*vm_destroy)(struct kvm *kvm);
-       void (*vm_free)(struct kvm *kvm);
+       void (*vm_pre_destroy)(struct kvm *kvm);

        /* Create, but do not attach this VCPU */
        int (*vcpu_precreate)(struct kvm *kvm);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 1fa0364faa60..a8acf98dfadd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -76,18 +76,19 @@ static int vt_vm_init(struct kvm *kvm)
        return vmx_vm_init(kvm);
 }

-static void vt_vm_destroy(struct kvm *kvm)
+static void vt_vm_pre_destroy(struct kvm *kvm)
 {
        if (is_td(kvm))
                return tdx_mmu_release_hkid(kvm);

-       vmx_vm_destroy(kvm);
 }

-static void vt_vm_free(struct kvm *kvm)
+static void vt_vm_destroy(struct kvm *kvm)
 {
        if (is_td(kvm))
-               tdx_vm_free(kvm);
+               return tdx_vm_free(kvm);
+
+       vmx_vm_destroy(kvm);
 }

 static int vt_vcpu_precreate(struct kvm *kvm)
@@ -914,7 +915,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {

        .vm_init = vt_vm_init,
        .vm_destroy = vt_vm_destroy,
-       .vm_free = vt_vm_free,
+       .vm_pre_destroy = vt_vm_pre_destroy,

        .vcpu_precreate = vt_vcpu_precreate,
        .vcpu_create = vt_vcpu_create,

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ae96449e6e2..cb2672a59715 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12889,6 +12889,7 @@ EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
        kvm_mmu_pre_destroy_vm(kvm);
+       static_call_cond(kvm_x86_vm_pre_destroy)(kvm);
 }

 void kvm_arch_destroy_vm(struct kvm *kvm)
@@ -12908,7 +12909,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
                mutex_unlock(&kvm->slots_lock);
        }
        kvm_unload_vcpu_mmus(kvm);
-       kvm_x86_call(vm_destroy)(kvm);
        kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
        kvm_pic_destroy(kvm);
        kvm_ioapic_destroy(kvm);
@@ -12919,7 +12919,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
        kvm_page_track_cleanup(kvm);
        kvm_xen_destroy_vm(kvm);
        kvm_hv_destroy_vm(kvm);
-       static_call_cond(kvm_x86_vm_free)(kvm);
+       kvm_x86_call(vm_destroy)(kvm);
 }

 static void memslot_rmap_free(struct kvm_memory_slot *slot)



