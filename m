Return-Path: <kvm+bounces-16802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A67A98BDD23
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 317301F21B30
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A5913C9A9;
	Tue,  7 May 2024 08:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OtKLIAEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBCC13C906;
	Tue,  7 May 2024 08:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715070439; cv=fail; b=ER5x5mLpXstPHVf3hNtwPtVsP7pcb+tXuNajiCrrdjWWaWqqIjU9e8hrT045khwA1/1PR/dpEf6lL/90InRgi2qkKrmgBILrDBrJMTeyqWNW5uvOgpUR89FmQRUx+Psr/G/m6m2EbjFfzvWGab/NbI0g+DpOaWTswTjPbjGv4Eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715070439; c=relaxed/simple;
	bh=za2fFwdMLJYCLlBxAdZEX8b16wtgxEmVy2MCHWBBk3o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JT8ouWrmm8FAQR5M+TIXye3xQ86Q5HLTEP385/UJDIFRo4mJb0Hwi7W4xtgzW6eQNp+7hk8hwgOskTEKKUgvfQNB3185kV3zNUth0six2gMddlmrRbPwKve2NHmf1fQyQCjrT/Ev1o3GtibXYp4CzwBNAjKSyE3dIAN76lXmFbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OtKLIAEZ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715070438; x=1746606438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=za2fFwdMLJYCLlBxAdZEX8b16wtgxEmVy2MCHWBBk3o=;
  b=OtKLIAEZuKDiL0FbUY1XkvGwytp8TmrBioDokCKEJ8K9WKUGksjZfGfi
   fbyCDlu33GAcNwZLvvzwq5CI5jK8urFTsrAtztKwkIn1Tp6G81hiR+EN/
   bAeYsEk8aq4riS9jv2ZdWfTjEeG7JY0mnhWwlWqnM62vjjkVdsB6JBjGS
   Hn4w6X1xsSMNbB8gL+wP4vkSF7hJq/8OUQcvOBfABPNtzJYA5pY+YH6a/
   t4lVAfUTP2RAJigYDqju76+fj5Fhn7AvcplqNQ2AajqcUGJMgNDf8OeF4
   OCVwZ7hqIsQzc3ByqKpRHmG8vKYLNiZO/oOJucofC5LMaxhBeiJ1vAcmR
   A==;
X-CSE-ConnectionGUID: KVanxWxMR3qNLpUAaEFM1g==
X-CSE-MsgGUID: idqGDblsR1CpzoCEzLduUw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10779286"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10779286"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 01:26:42 -0700
X-CSE-ConnectionGUID: 9sNv/EBCS8Cb/+j7G1S37Q==
X-CSE-MsgGUID: IMDSDoPmRRGU3+uYHXOnFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="33271421"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 01:26:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 01:26:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 01:26:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 01:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxZw492UT1ElA3BYX+gsVV2d5bAmnrbJepl3hH4cPANEkPeNZtqsiQfjxvyJWbBsp4X4xXgulSG1UJYjuLN0A5ugYiEYO0nxUnlNPoMtvqxRcK7ZKZtOhbzrfsArgXM6W2zn1dNEh/xOp42QreojeAiOjD6KGJwBPc5jtimCAqsx1AZxbc/tbwpL1GK1rygRrXDo+bTsuKIs9+lDYhPYrKpX/EXwh+HqymnQb+iBcEYu5uo9P6moE8vHHYkpF1Ab9luR8SkjQxG1BgtvIvLiYa/4YojH3hZc++7RuixrQNqUJY+op+Iw3RWY1q1XThtlZzDfUb1KGhckHh6/C8tJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJiY02D17b+6Pp4Zg9CSqx87ln8FVFJvvhKKXlFtUa8=;
 b=aZq94g8B8e1xLUg+edgsrx7zJ3oMVeWMdUiRxobI8hrv7HM+3cxwJDKZBVXJGZcH4jyVhM4/Ysehe/U6XsiAYhnnqozdvYuIn4nOwmJeFSW9F+3iHPZvZMqpuXIkb4QPmitcXUGaaS8/2X1NLLq5Q6cJmJsdlrAEUa1us7UFXS4uMOqZQBQNZV5R7XDW4SBoUFzeGqUxHNMfLKR2Ee3lcqv4+GnyASlmd10BLs4O+btdmJeXB9NwOHZp4XyF+/dBPUEvDnMMzXQeGw4HCFLP6IZStRm4+2GLSQtDNSmNc37uzqF9AkC2Hjda1Obt7JJIpvOOJrk4y3W8qDxG5c69Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6171.namprd11.prod.outlook.com (2603:10b6:208:3e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.34; Tue, 7 May
 2024 08:26:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 08:26:38 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Thread-Topic: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Thread-Index: AQHaoEaluFlXp2ccfkynqcQr/+5ZoLGLbskw
Date: Tue, 7 May 2024 08:26:37 +0000
Message-ID: <BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507061924.20251-1-yan.y.zhao@intel.com>
In-Reply-To: <20240507061924.20251-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6171:EE_
x-ms-office365-filtering-correlation-id: bb03a302-c1b4-4e71-1a20-08dc6e6f6a25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|7416005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?Li62sNZJtDjr7j1dKlkpz7739sxszap+FDXK8uhe9rHYfb5Z4A9uKLgZ0fJl?=
 =?us-ascii?Q?mn/sSod0yA0A5dvVIYWrrGYicRdiigmhZnX+eE44bGF9uCz7lMF5eWtISdL1?=
 =?us-ascii?Q?TO7/l9L1c14odbWoDKXrfZVhp1reQ1Z1XajbZVBjNX0Zt5PzlN3E8G/Yezdx?=
 =?us-ascii?Q?BdKFR4e93lF8pseFC8X7wa0y239bJM939UEBhs6jI23peJmj6hkMNCO7XUwJ?=
 =?us-ascii?Q?S3exQbYkP3rLxWCAbjnXuPgpoRl7934/VAD51SYlxgnWhwYuSVgNI1Y9JpML?=
 =?us-ascii?Q?+D24qUwsBQIqC6ifATmouEg2EwzZWnIkQvOgYMgU/iRR8lOJ2lNMT5WVW2rI?=
 =?us-ascii?Q?N68iMGiIxiMt2ReX4ZA3TxhaC9TiOZoHQgu5NSL5OZjhN5F6ECih/4GnWyx9?=
 =?us-ascii?Q?wr5BWLCX05FyVtN4A3HxgFcNRpPeK4tO5tn0eMYwLaPDdGjBIM2kLZ9g7NCO?=
 =?us-ascii?Q?nkRR+GSF58RxdI6uLzM4K3LfXAT5wAD3zG+G8tudug9BA48W0s0SRkaXDnrO?=
 =?us-ascii?Q?X6jBN8pmIe8+Vi91Kq5Nf7rwMsOCqFgOdn+D9y+tmNo+r9di+HxlLHknWGpC?=
 =?us-ascii?Q?OwM2TKGc5QqpvIgWvRGlbflzq/xoeWctRRKp93kNI/gR5OoAOzMe5xXjaeh2?=
 =?us-ascii?Q?PGluyGgm+Li2HjYxu7lkK+W5KNLa6DWw7h6LL4FWWDrq98W8jasIm3z4sjf4?=
 =?us-ascii?Q?UFYxXQ8E9AxcN2o0tgLSYDKhqebCnrJrNxC+O/AglbUdW7wVtVCLYpQwMYvX?=
 =?us-ascii?Q?wTr/1aeMXKgqCM0FV8Iz0EwdM0EELbT45AjjReKK989SIcoCERCx7VlOKNyv?=
 =?us-ascii?Q?ESYPONudBJOg5uCMrSFkdwZMkDhxsYIFbfM5ruEAvCYgULgcJlZqJP2HpTV9?=
 =?us-ascii?Q?d+IplcDeMFBerIkvNPE6gIAOWmmPsHuBNrM8Ptw1bGjtBVXkRIZLqr1HL/mj?=
 =?us-ascii?Q?/gan/YXRK3u1WodnjUjxD21+kW8VEl5YbzR+7AxeU10fGr40TgrcPAmy7czR?=
 =?us-ascii?Q?JvUJBUqYqC0cJPFl21RxBv/efzaz971lg3eS+CvlHB94ZPXcCXoUw0q0GiBe?=
 =?us-ascii?Q?K2F3qZ1r1lnVMOyIkSvhs2PFvpQAQIgyPX7rXZC/i0DeosByIgzRIZt1YeyI?=
 =?us-ascii?Q?P9KVMbHS+pLohowlQCoNFEIWQVKl0TpynsOnWp8ABJhUNqJElQ4UEox6IOmb?=
 =?us-ascii?Q?pwov1iCmtVHscRKhYjVlFKxS3NJXNpfxAZUkecttm/LN8Rh10HDMnA+4Qzv9?=
 =?us-ascii?Q?+0djH9s74b4AkumBmGwXyFgsjTl9yz5ZqOm533UR3hwaFxURru0PL77W9MKs?=
 =?us-ascii?Q?KHgrpVB0prZ8XZqeA73/GL9n+zPyfeKc/bknJx+hZMJhtQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3cX+e2A7AHwhZ1znJyo70tYOCXFZz5RQ63Pn+PUiZ2qWtyhcN4vPNo8MmLMa?=
 =?us-ascii?Q?Bhe/fwXw+6PwHYC2jCQkBFFLwDDnd6Kmk2qe72dXKo579V4m9DvCLAasjuol?=
 =?us-ascii?Q?TqyRzE2fnT7wfHZ3Svnng1YbovBunIq1uWJY2T4rhkCzlDFbYMdVYlF1Lfvb?=
 =?us-ascii?Q?zwjFIwjrdCxo9YRZ7xdmEoMjhfx6/AyqYRQcQC9rhFcRl82IKP+XDE+gzloB?=
 =?us-ascii?Q?m7lZ25g/2kg3/PJwRwagl49fJnUaokhj/mSjoNRSV90fXtQD4EmX0S+ZgHKt?=
 =?us-ascii?Q?4KnWf4sMjPblENTXfYvxUnM2DzVgQYAnP6R8sMAiiPiyPINyPxwxkTcMojGx?=
 =?us-ascii?Q?AMnfRPw1QVOndsezigJLt9/S4f2N09xaAb10MtHYQtR8gn8khWP0Wxza+Nig?=
 =?us-ascii?Q?6M4+Es3Xmcrexib51fly85xjQBX1uoOmlKEFzpPyPCxFWa+JWWje0vMlLZV9?=
 =?us-ascii?Q?AB7ywVb+EK6a4DS9K2/QZ0wgqIYwNva3Dok4bx5ZV2gddQfpctUorE8SAGf1?=
 =?us-ascii?Q?eP5tHQlt3TH48UJhB2U7zHRTVwZEXsFOG8UeaKJqpqpUBKAkCtaQ2X9+ZEZ1?=
 =?us-ascii?Q?A7S+06AHPojnYCwWvwh+a+Nzx+8q4pUVywK3a3yna45FNd8KmUL5nOzTPrwB?=
 =?us-ascii?Q?UmRTXR/kDcV3xm024OKIF7d3lY4VQzPltygOmx+RSpbd0wcpXa3t+JJ9KEA8?=
 =?us-ascii?Q?xV8iSYvFNW/iirXpLkFQwgDJZR+hQNrM7hY81VJoEHL4mEnj+90LfSCeQSbC?=
 =?us-ascii?Q?Jt1+nmV7Cdv9DE73NQFWwFKqs1YzgmkyVrcD2nhkaz2Ms377YZtyG/Jhv8O+?=
 =?us-ascii?Q?+qGzDuyAjb/s5K+6K7l+Ssyh2flNlT5kp0dIW5GOhU4KHV/GjduAuHn+D//H?=
 =?us-ascii?Q?yF5OKkq3hITO9OC4xPGp+vWmY6Ve234oSq0zMoqPpDZA63jYmnugVcJfoBtW?=
 =?us-ascii?Q?qtEQ/wOeQWcqAITQA3NBIDrVlD2l4Um0OBHQyk9zRhJtf79GAqyipEiv9wXe?=
 =?us-ascii?Q?Pv4U10nH41pR8MomyFpz1F0Xn7ihg/5rKsS6w3Q3iukcCZ2cMAhLbZBCB/7M?=
 =?us-ascii?Q?EzYyBrrEXuRai2lQcwEQAFdMkWCDL/D4PqX9y/zPnbghDzTr7EB2aZNG5kdM?=
 =?us-ascii?Q?KelxzPExZHJl07UUm/YncIVO8Yhd8OefcC5FSYIZKX3yvEd2wcXUu70CvMSj?=
 =?us-ascii?Q?Se5MPw7FnIEyEibGIYx0F06h/oxke3KWCPq0DVSptvkTkAnveEPbQz2b/NxV?=
 =?us-ascii?Q?dUlLDxdvaLoOJqkTCi478j22cSmSVu1mMBFEz/0pm8VM/8DYnIVKYO3QDF4+?=
 =?us-ascii?Q?iLQDBJ6RM7lEBEK14RyRt5zrWRiMRIt4EkMe3ydVZNAHs8GIzWwWwno7z63W?=
 =?us-ascii?Q?4OOzuUrXsfqmrG+AUpDHd+JnfyC1P5JlSpGC7pTNexJ2lcQyt3sLT98q8YDR?=
 =?us-ascii?Q?eYG+Iuta2w2YuPiJelV2hVAHO8Oca0smd88S44C/QoTITWusswy9AhwxWBvi?=
 =?us-ascii?Q?dY/H53elL4BUh4BH5XFPXtdBvYMCmdocn1znZkfmsOOhxeflNBPsp20ngfUS?=
 =?us-ascii?Q?eyJ7uyj0kMapLlLcGYM3CE7RG5UJdGyt4b/ffIX+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bb03a302-c1b4-4e71-1a20-08dc6e6f6a25
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 08:26:38.0769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xaDCPSNtP6Ovmj78VwYqcBU99bt9DgRzJvTRDqGZQOpfDSexmk5M1U9dLUaziuBBTINLfsNyqgOJImeIsSbAjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6171
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Tuesday, May 7, 2024 2:19 PM
>=20
> However, lookup_memtype() defaults to returning WB for PFNs within the
> untracked PAT range, regardless of their actual MTRR type. This behavior
> could lead KVM to misclassify the PFN as non-MMIO, permitting cacheable
> guest access. Such access might result in MCE on certain platforms, (e.g.
> clflush on VGA range (0xA0000-0xBFFFF) triggers MCE on some platforms).

the VGA range is not exposed to any guest today. So is it just trying to
fix a theoretical problem?

> @@ -705,7 +705,17 @@ static enum page_cache_mode
> lookup_memtype(u64 paddr)
>   */
>  bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
>  {
> -	enum page_cache_mode cm =3D lookup_memtype(PFN_PHYS(pfn));
> +	u64 paddr =3D PFN_PHYS(pfn);
> +	enum page_cache_mode cm;
> +
> +	/*
> +	 * Check MTRR type for untracked pat range since lookup_memtype()
> always
> +	 * returns WB for this range.
> +	 */
> +	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
> +		cm =3D pat_x_mtrr_type(paddr, paddr + PAGE_SIZE,
> _PAGE_CACHE_MODE_WB);

doing so violates the name of this function. The PAT of the untracked
range is still WB and not immune to UC MTRR.

> +	else
> +		cm =3D lookup_memtype(paddr);
>=20
>  	return cm =3D=3D _PAGE_CACHE_MODE_UC ||
>  	       cm =3D=3D _PAGE_CACHE_MODE_UC_MINUS ||


