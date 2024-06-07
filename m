Return-Path: <kvm+bounces-19065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E35C8FFFBC
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 11:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B00FF1F21E8F
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 09:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B7715B971;
	Fri,  7 Jun 2024 09:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EKBNnd1K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FBE746E;
	Fri,  7 Jun 2024 09:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717753236; cv=fail; b=dB7esynS2Qrg+g0uxS8TmJhNQRsF4Ef1ogG5LRWwptIoeLdGAxX/Kx5AeKUuU1aHMogwDt36qwBz897aVBGTZu/LeA16JWIhKZ8ETDtNIA8KydSaxiuWyBJQjlAzk+sE3+V6c98guPSMMrFQu2Z2E6d02byDD/gyj5wPSRQkaaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717753236; c=relaxed/simple;
	bh=sJmisSFiH5abTf4l7xUnZaBze65kRlOH0fKb97cvOZE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CuuuGwl0WpdYnVADKC6x8trVVlpdd23C14H792ZUiaUWeX86NQKkPyykKbr7dU+yvGMtFXMm90HmWtZEHaJitLLM8su6xXoyeswplRY0Bn3kxa2csjri6yqn0UqjUgFE4Avc/O6hKcbquUcTXiwvDCBcveEHh/E5Qe/HCHEj8iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EKBNnd1K; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717753235; x=1749289235;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=sJmisSFiH5abTf4l7xUnZaBze65kRlOH0fKb97cvOZE=;
  b=EKBNnd1KBLv4Pqg7x0O3dJay7V8gx/uZRg+Yy2g2SaYBnZYFhhpE3JmK
   krteUbD/mJ+dwUVAQ3UE9ZJDIHokhzR+KZd4avYY2HfI1GX89/suAZPlE
   vLhMDgVuhE/QEUtBU1HM+f3nFCuD1N2dtHfXWo0/xHj8nsLWEphj+sZLI
   Qd1Pjf0uGo6QIe0ufZOarviQDVgTpKGgZucIkJPjRqbNIzbUtP7c86i4P
   Z4gHiuyGKB5Rsk7bjtSobPrEMHfIOM1im8f/S9CIBCY1Oe4+2k3H41tTF
   QQROVFQJADMNKQUwmiHs4clkDfmOQNaim/j4eqegEwt7suCPX3d2cufgX
   Q==;
X-CSE-ConnectionGUID: dqOb0B7uSxyMsRAhv0sRuw==
X-CSE-MsgGUID: gZT2TmBvTb20qe818/kTdQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="14600397"
X-IronPort-AV: E=Sophos;i="6.08,220,1712646000"; 
   d="scan'208";a="14600397"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 02:40:34 -0700
X-CSE-ConnectionGUID: O/qnW6uKSJumDweddo4HLQ==
X-CSE-MsgGUID: GwM+eCooT7acNrj699UKGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,220,1712646000"; 
   d="scan'208";a="38123921"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 02:40:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 02:40:33 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 02:40:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 02:40:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 02:40:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AT3DL5ynwGsKLxvrjCrCjb3Hpp7b8KjkGJgGxvv8VaGbK/J3zpGcsfXEVQuRmAuZyDycK0An361dBhxFhze8nfHgFtPsL5Wa4WTmYmhMlnnqp1pfjsrBWd0fSu9Rk6YeKB/7GDAB5aJn2Ozozt/5JVBQFkBIcCujn4mIapeBEOdyIOLp55HatWiXBo9AHZ4VpFN/To2gShAUbKhGjmx/UMhSiBLIwpGG/ZYqBFAQS0KSBQ/t+tDjyEwNmN2gTSkmsdbGX1G54U9Dca617WkpSAtFvrVHiGouqrmHCTaWfvwpT1a/nA1zWqwdq3gNhpIGM9x83R7OfA8Lf4ijNRG0Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yysGlRDsiWDCLPPBYU71TmuFrxH1douE/PpFlYCeogI=;
 b=cIXUlaB/RDrLRBZe+JzMGdCTx7BivozfSoYFIrpqCyGaAVRTlDQ8990WUDaAcFNxT6Pp/iUcuDqZ+N0AJDs7A3szdJeIdMx4nnDsA08uMFyxNymkH8ay5NdCHxx/ni2qiIo7U0S1F9TrmT7wDch1k+YdZU1WFQTJmRQsYCTWA+XWpS5tKP3TX8n/V+bWBHbcphwIXBGuMj2WqX3ynw1WUMrBEMG4uVbnbHA/rqNQRGzsFuwgkU3DKALGwYtBvy5pPSN6lLTuXlw3PYltazFABb4RSgh/o+EBJHz6dI2QPbzSBkXhOMgUJK/NmC3FHujXVa1oJ91SLsgKRpbrTfmDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6798.namprd11.prod.outlook.com (2603:10b6:806:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 09:40:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 09:40:23 +0000
Date: Fri, 7 Jun 2024 17:39:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Christoph Hellwig <hch@infradead.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <ZmLVSU39rJBzQFX0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
 <20240521160016.GA2513156@nvidia.com>
 <ZlV7rlmWdU7dJZKo@infradead.org>
 <Zlt6huNJeW8ekJlE@nvidia.com>
 <ZmEjavnYePBLDbrS@yzhao56-desk.sh.intel.com>
 <20240606115503.GZ19897@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240606115503.GZ19897@nvidia.com>
X-ClientProxiedBy: SI2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:194::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6798:EE_
X-MS-Office365-Filtering-Correlation-Id: 053ee7a2-a4d0-4779-a6d9-08dc86d5dace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vmEn58LmMe1L3et8lfEGfqHFq4cmIX4B1OZIGFu1DfG8PFYOPleM4MSgN2xP?=
 =?us-ascii?Q?c+7/BmYsaWo6ZWkhLJ2UU7lrZvUv649rGtqXioPtkadpGdHWgExxte8EUg/N?=
 =?us-ascii?Q?/U/NiIxetxe3C4SpMJW9Mrrb45mn99Xzr1s0a3rx1sm+Y8VRiPI9lrn3EtXh?=
 =?us-ascii?Q?jxgWR1qyubTwUerFNIIrTAj7VOPaxcsWLJAUxV+jnLiBkyfEiNi4eV/GmNio?=
 =?us-ascii?Q?gmGWftY8G6AQYPI0J1IwSq5X7yfVFu9zCg/LtbRodoUZn59jzPokB8jp2qmD?=
 =?us-ascii?Q?4ypVI0+rw9x3t0Y4JGOQJ12BtCnVxbgQB1Bgux2uJzpjhvyVuy3/xMXOx/0+?=
 =?us-ascii?Q?1O8KxRhHImDj9uIW9X7zR8bVAZiJOMmmA2Ght8FhVknzV6Vk8U4Wmuz1AC1z?=
 =?us-ascii?Q?kRTCprx/b4KPBfXhhyGgykMkbxrp5e/0VU8gS3fiDhvZmqAOuAFfcYorNssT?=
 =?us-ascii?Q?AVJ5g737ImJ+z4YlKLFq6NoBidRKSGdoPA73nHxqQXISUcTA49kvXzDkrDWG?=
 =?us-ascii?Q?cw54uimUBmDMYWJmXgEBsACPP/tOp4gZVUPD7v9q7ONCe+6rPsNKe1TY+UFl?=
 =?us-ascii?Q?2R8rW9ake4pQ4rzccofwsjxAFkON8r/9967g3kTjshb8zuD5yrbdXr7hd434?=
 =?us-ascii?Q?n15jfOFviWEfatQ7OWrAXwcZMsZsWnoxk6XRizTLgw5XGm91VCVSccWZEank?=
 =?us-ascii?Q?AWv382T5VN8aTWnYf7bs1VbNVHaht2cT5BXSrU0USwUP5Eu3QB5T+GiiAWRd?=
 =?us-ascii?Q?x73WZbmex8myDnzoba24hTkwgSi+duQW9S/cYf5v6Sqtk25IM5oMgRUx24zF?=
 =?us-ascii?Q?LGcjjelGtdZv6BxzmVb2DBS0xjPFFPUqI+FSBdENzYT+7jiPBcS3tjtur1Sd?=
 =?us-ascii?Q?iVBBB9QncRV435IJMJMIqtV9cdJyDPxPCiV3VdaHl9S/vgqlDGEr418oWQ+b?=
 =?us-ascii?Q?LDHRZ1YIbEytx1jNdWaJeGPNZOjMydiYUKl98VosrlZpHXos577lXoQVMgsL?=
 =?us-ascii?Q?Ky6mMqrC6LLahCnprji8abW98BkVU2CL0+C9R5dxPf71/XqQqk54G5KcVtnm?=
 =?us-ascii?Q?kDkD61MGSTqDahNHjwbVlsSoiENBo0iAdTIFoDPx8xO944GiH4F/AxbwvmoH?=
 =?us-ascii?Q?aZPyl3d5OrQv2yJ8UIcbHRQdwZrkoQsXxTXR/PoofT2UEm6TuiRsk7L1aEmz?=
 =?us-ascii?Q?eAAu9iRr9cz5Ikief0iqnVFoY4VawdSn48Z9IpqjcFdrfJRoqJBbYnPR5XuR?=
 =?us-ascii?Q?W/paHTe5mXKrVCrAq6oqI6BnwnsBSBEgXzc364qBFRbQWcssvZztNUbh8G42?=
 =?us-ascii?Q?xlr2AXfPYyWCnKDdpAuDdEVD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xulCcF7NURQOFDydLYx3SIG9/frlbGl3hpCkWQapzZaNVeBvECvwHvtm4JBV?=
 =?us-ascii?Q?D48LgEuyRLM/kdN6EiJXS8E0olUnw0UP+SiULtgIJlBbXaSoBNU9ONxAxf1A?=
 =?us-ascii?Q?1dm0gITnn6B7u2k8vqSgEocKeQDNvlST51BQDwwzG5lxWZLV3+FRsUHA6yTG?=
 =?us-ascii?Q?dD63qME4WAGISXuADXz85LVQcOMWGDV7AZR5UTKjkrLmOO8lBxbbgL/7zdsC?=
 =?us-ascii?Q?+7PbBVgGU60qWf8IODd/WxVE31sqPTC+uaSgfpVO51EusRrHYffr8tOXRLK4?=
 =?us-ascii?Q?jVR9f/Zok6tnKbIjqOM1GjrVMokCuzKd9n6tu7BRT8S3+Mhe5QPC2+XCDADD?=
 =?us-ascii?Q?vNyp6zsX8WCAQ34Qcusz89mhGFGcYDK+pv85AjXsNDBRVyIVMoNWtiszbTjx?=
 =?us-ascii?Q?GibyToKdSutYIueSRc4bHMiNZXscmKAHViLgBKWpvOrdHYXe9ksw+viIYfkC?=
 =?us-ascii?Q?Q16/BxhUE/jNpQjdUmqXQ1G/WMTuNx24VeFOkwNVl/mG+DXlqiNwc5y6gexy?=
 =?us-ascii?Q?64MJCYKovMwcJ6AurhRruPPCCjS/ji/BxC3lKMnHdvbpR/fuDZZsJcC1ETax?=
 =?us-ascii?Q?tXBHB3TZSWDucAoxrTptRo71Q2BZ/QGXqm7KWeZyzrDOap78BM2cbZa1S60C?=
 =?us-ascii?Q?ONEy9/PsGbOBcwSmLRPbitCA1GMPe48wHSqltfGo2vzwvFAVjZjPv4wDxYgp?=
 =?us-ascii?Q?hi1b1/6D2foerzZLmdh3O/5iWbkh47Lgv7N/4gnPsNkd1xXMjWP1OIWdgcj/?=
 =?us-ascii?Q?ci0N6F6NpXMhx1r6PsNcWsWazfriClnZCh8XGcobdeOcm3IL9KBE2SzJSwtw?=
 =?us-ascii?Q?DP3WTHYK95UrZ7VWJNq8xxNiY2wyZI5A1BFf4sc1m2q7szuNxZkUJTr8uohq?=
 =?us-ascii?Q?r4G7CYo1rjwIE+YDIWEwYkzYmUewO2wpN0+7eLdD2Bog9fAX77L7bTntvxfx?=
 =?us-ascii?Q?6UTdlmqYwNUjkEjzLRJ8Z29rrIEMN/KcZNDcv3+NsSxE+dQSSFCC1e4idP9C?=
 =?us-ascii?Q?kgAsXHBRzE4ifTXtfceJHzuch0apWEIkX2qw354sy6m63mYePjIohmAF9GR+?=
 =?us-ascii?Q?OfdSla0rsM3/VRJtHVZ7E5OZZ1RHGtvEm4+ov63FXdPGQKkGIk4bHSi62Iom?=
 =?us-ascii?Q?sS2PAYRNCez6ihkha8sHhG/3R6NE4OI+vJnE8q401eiu01sr6L10cl/oeL5g?=
 =?us-ascii?Q?Rq9nI44fWvrCpSRQZVQL9/cfFmjZoexvC+FfriFhRSkVWKsNtDmKPYVMRiU/?=
 =?us-ascii?Q?XRFy7ub17bdoSHd8n3KBSvOtxewjhiefnUddG6xyn3TuDUq2NdIjn7pXsZft?=
 =?us-ascii?Q?E4KS5vhKgXp8hhLaVuZwAFfPfBU3FNBfVVk6UaYAGgqgr34dd3E7XDjlnKxJ?=
 =?us-ascii?Q?NhnGVVu5dFblYyqrUZANNxsFUe8/kpRM7srAAZceOD/YwHqJq6L8BrBvOWAi?=
 =?us-ascii?Q?tzMFnZiCHK9XC3l0qdwMo+aBarLF/qWfl15rUpZtQmalrpZKiUdVXwKafF9W?=
 =?us-ascii?Q?yUrrcHIaSwgbb7OQErwdSDMemEyFzC+0oa7zYYzITAopzHkHhg3TZMPgxdrO?=
 =?us-ascii?Q?w0yKvO17UHlFC9Mi5uW3Zn+giIEmyMpgXptcV49h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 053ee7a2-a4d0-4779-a6d9-08dc86d5dace
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 09:40:23.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MA+LJcEauHP0s1/SqixBUXS0msM6uguI+Cr1ppqRNlMrlHfxifx8i0QchY9n3X7VlRDYQackb6DwUUUpdBk1pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6798
X-OriginatorOrg: intel.com

On Thu, Jun 06, 2024 at 08:55:03AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 06, 2024 at 10:48:10AM +0800, Yan Zhao wrote:
> > On Sat, Jun 01, 2024 at 04:46:14PM -0300, Jason Gunthorpe wrote:
> > > On Mon, May 27, 2024 at 11:37:34PM -0700, Christoph Hellwig wrote:
> > > > On Tue, May 21, 2024 at 01:00:16PM -0300, Jason Gunthorpe wrote:
> > > > > > > Err, no.  There should really be no exported cache manipulation macros,
> > > > > > > as drivers are almost guaranteed to get this wrong.  I've added
> > > > > > > Russell to the Cc list who has been extremtly vocal about this at least
> > > > > > > for arm.
> > > > > > 
> > > > > > We could possibly move this under some IOMMU core API (ie flush and
> > > > > > map, unmap and flush), the iommu APIs are non-modular so this could
> > > > > > avoid the exported symbol.
> > > > > 
> > > > > Though this would be pretty difficult for unmap as we don't have the
> > > > > pfns in the core code to flush. I don't think we have alot of good
> > > > > options but to make iommufd & VFIO handle this directly as they have
> > > > > the list of pages to flush on the unmap side. Use a namespace?
> > > > 
> > > > Just have a unmap version that also takes a list of PFNs that you'd
> > > > need for non-coherent mappings?
> > > 
> > > VFIO has never supported that so nothing like that exists yet.. This
> > > is sort of the first steps to some very basic support for a
> > > non-coherent cache flush in a limited case of a VM that can do its own
> > > cache flushing through kvm.
> > > 
> > > The pfn list is needed for unpin_user_pages() and it has an ugly
> > > design where vfio/iommufd read back the pfns seperately from unmap,
> > > and they both do it differently without a common range list
> > > datastructure here.
> > > 
> > > So, we'd need to build some new unmap function that returns a pfn list
> > > that it internally fetches via the read ops. Then it can do the read,
> > > unmap, flush iotlb, flush cache in core code.
> > Would the core code flush CPU caches by providing page physical address?
> 
> Physical address is all we will have in the core code..
> 
> > If yes, do you think it's still necessary to export arch_flush_cache_phys()
> > (as what's implemented in this patch)?
> 
> Christoph is asking not to export it, that would mean relying on the
> iommu core to be non-modulare and putting the arch calls there with a
> more restricted exported API - ie based on unmap.

Got it. Thanks for explanation!
> 
> > > I've been working towards this very slowly as I want to push this
> > > stuff down into the io page table walk and remove the significant
> > > inefficiency, so it is not throw away work, but it is certainly some
> > > notable amount of work to do.
> > Will VFIO also be switched to this new unmap interface? Do we need to care
> > about backporting?
> 
> I don't know :)
>  
> > And is it possible for VFIO alone to implement in the current proposed way
> > in this series as the first step for easier backport?
> 
> I think this series is the best option we have right now, but make the
> EXPORT a NS export to try to discourage abuse of it while we continue
> working
Will do. Thanks!


