Return-Path: <kvm+bounces-17527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1435F8C741A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 11:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB1162812FD
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881C0143874;
	Thu, 16 May 2024 09:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RwK+mrJh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590814375A;
	Thu, 16 May 2024 09:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715852966; cv=fail; b=Q2IJ7yOSZCnLuE6cNull18Zqm7L+sCKwKsTjXG1rW7X9NhInHRx6z1ZIplMl2F7+y0FdSbSI2gt9OlDFqIqLV1j0qbzPnZKBu44NpBLR7fQa9Xwr6pPAjnXEBXU0Rv/VIcXRp6zsWryN0v5Bj7aq2VzoMD+7X2kkz5f1QIePP10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715852966; c=relaxed/simple;
	bh=PiX85THxh+jDpaxNl+KuSmffgCBnr1t6tdpzLHGLMKo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LXcOVyEz9O7Yef+N0aB82O3uL5wIacrZMTfF7oy3fNqRBjRd0yfHTj10zBRp2qc7LEK3ZXY+37AOVKGd4oAVFYF/LEkS1T+r7xP/QeUVmiT/vRq8qxMMGa3QSgxsTuA5Dh7Cf6dufc7mjB8yKFYo9r73E0mRiKpAbJqrWEh3fIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RwK+mrJh; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715852965; x=1747388965;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PiX85THxh+jDpaxNl+KuSmffgCBnr1t6tdpzLHGLMKo=;
  b=RwK+mrJhORoNS/ncN877lXbCI0yyH6DxOLSUtUYNkptN5v9zqbsxD3zw
   oN2oNj/35si46mpp9trAkddbUmLFMbYLlCFQvuKSGitsR7z04hxLlIt86
   FJdCbuY+NTF1pP0Po8QH3awJcecjZFmteHN5ebKrD14bwis/NSsC4Y1H3
   6tdFCTEHwQYLALlXb2bCnJ/nXy9WaFXmQ8iFlGNxnK4Ikc54aBafXsILn
   kVjmGiCo38z34i7SmcBB5cXCneTKidXh2V5eu6mNQoKCJtkq4KpOE/UEB
   wKJLvuQuylTJxi4DkQGr6ex1GjUcjI6tETVLAHKueZcGflo5uo1omrCYw
   w==;
X-CSE-ConnectionGUID: k2Nq5tdoSw65mUAgGj8SSA==
X-CSE-MsgGUID: c536t4wvQV+C2vsEvMEVCQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23356761"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="23356761"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 02:49:24 -0700
X-CSE-ConnectionGUID: zrlvBx8UQ+aPGMjnwfAMVg==
X-CSE-MsgGUID: Dkm/0QAhSJqQvUR7IuTY0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="31302778"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 02:49:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 02:49:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 02:49:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 02:49:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyoUgS7pHKWOdCX2D38bcV8MLA/FMBd30fIau1+cd8i+0+8snCU/qSIoYqXUpmDTIXxdDn+Pu5vPy9yImP+KYSYjZsFF3YUpuLSMX7jHmRf/E3s89hvZ0IAnAC4Lwamqw+TpMHU8hjpLa/W2qLMHq8TzUG9uVL1pujyXE9lBTP3Klv7tgjV0JlPsE5Koq9oScIW4y2bg0l9ZNN07381IDPfYLWtds6HrhNQxxr3S8UmJhBhE4uORFSo2As3SHQm4/PFvPvBHY5PKDQWvoysCE+2vah3+J4aID0In/3FjFeVXIxDJCd5/lA5fbZLNSjgCGheQiT2FLqQxLauPtVI3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSCtruBL5yGO6NBxp6ioDOJUCWQUojBHkYSZ762nuk8=;
 b=GRBLoeL8fXcpKEh+OYqCFW/4zr4DbPPoxAguYElNlv/L3SWdaJoj9JNetY7H2Sbs7t6lpdDqmLQmC7BD24MxnV9+stofRM/7OqOCk8dbLVj2Fv9Cm6Fe64BhHX4JPuSGXLTiXm1+1jlToe6l7G6BP92Elo3WKgv5DBZdmwfDObOSslwfRkZ/CAnjuBoyFq4CYLblst5TE8/TQc1fz2G1hszp2tRXvUNl9EotHviLJObI1j3VC8ZRH2BKRAhrVYqhvc5K8yhEfdTj6AIvbC0PqYZ1hoQzglwMkZhSm6l3kZVmDorBLyxCh3Jubsquqn9I78RHKejq+7GMnAE1I4oIFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB5802.namprd11.prod.outlook.com (2603:10b6:806:235::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 09:49:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 09:49:09 +0000
Date: Thu, 16 May 2024 17:48:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZkXWZKKgBLB44fkQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <BN9PR11MB5276C9F1281F689B32440B558CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C9F1281F689B32440B558CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ffb492-64a0-4d31-023f-08dc758d6f31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oMdceM0+WYUpBxBFFY/wSJSg8Qg2dft2HVsqA3WLhfvYUFvDtufIZF2sPbe9?=
 =?us-ascii?Q?8hD/XWPSGrQPsHqS9sd+PoXt3V1xeiwmHDXTrYZSwZfxFukB7PFRABVvQKg2?=
 =?us-ascii?Q?+jEpMaULgmL9bTuR/rM5tqXf5/Ffbgg5lRs/j/uLXbJTaVG1KYJwM0gu9+xb?=
 =?us-ascii?Q?PcaEwRBBLxUVAbRcYp6tOtWokcB5H2b/c7DDn38e75srM2+SC9vNhXvJ0mx0?=
 =?us-ascii?Q?jcPqVFfON6LfeelQ48sxZxaSA5xia/Op5qScisHJq3MSZ5KqUn+cHQMiRQPq?=
 =?us-ascii?Q?AObfmxE8v/DJaEcusKH+TbEcFw7d6yw8HHnPgjgdI7J3gEgEHnxRWQnZM1F9?=
 =?us-ascii?Q?rUCVzgOC7JPtJxB1sHFMTjN4brYG+Cj7QHtIpBbIKmmzLiCJXTSKaIcHTngn?=
 =?us-ascii?Q?5xUBGIHtzBbzZeilNcIOxIfd5Y80VZyHVXGjm98q6vbe0717hc6ThVNYQoVb?=
 =?us-ascii?Q?Q2kk4TEUgKU8WGeWHuaeR2kWJnXWISZinXJakbU5cKr9Pf0w+eUIu+m6b4mt?=
 =?us-ascii?Q?y/RXw5euQpT7PIlj+DInpKRdmKbNkSQQyMM9qXH/8qAKpYPJMEGs+v102imx?=
 =?us-ascii?Q?BoItVh3mS1ycqRC4CgHbT2LSlkzsjqUfv3B8xv1Fx8W3y9070rbVm6KeQr18?=
 =?us-ascii?Q?12+BAkygUaleGEtEfgn4kmr+Mj+77KVqXtZnta+cKEXoD6L2mMAgsFlTIYVx?=
 =?us-ascii?Q?I5CP3CLyU0VD/kRjK6YCx/V8ihZOdIV2t3mxTrQrAxb6cL+j9N2q3IKVEDl9?=
 =?us-ascii?Q?/yhoTv4dBpvQnH9Gv6H3EEvXdGs0eFUwwJNkJHYTCaTeyu4AVJn9CtHaS/0H?=
 =?us-ascii?Q?5eYSMS10zXrqttDXcUr4lWp3AQ5IYOiytBJLXPw/S/7Rf45WCOzkG8axjp2E?=
 =?us-ascii?Q?MrAQmxgvCNtSq01IHywKE/XOKCPnr/UlimNweMiCJrUFd26gBF0JBu9O9jLT?=
 =?us-ascii?Q?1UcrhA/NtcGwOuJW5Xj6NiLK+g4HYkczEs9dkPwh7AtNuFB+p/k1Dn5dgZ+y?=
 =?us-ascii?Q?77a507Pm9oVRnJDykirDqNccQk7iGtzN35CSFzTpMkgPfwGKxao0imjEbuby?=
 =?us-ascii?Q?cUCxycx7EIgbRoR3fLP2aV053xx9osf6iCU+Z8VX9EA1qBR+rYXvI660MJzd?=
 =?us-ascii?Q?FWbJJ3FHWfqaeWIkw9ULFKpzyN2D+V3xCPEJa2tVkQgx1OWCQ8DpWs3HoPoT?=
 =?us-ascii?Q?+iCZ2NZTQD7htm772V0pYZLWC4NPgxEnViyrzbs/QmeWZtjGYUp1K9Npp1kM?=
 =?us-ascii?Q?mEcUx4Kdc4LZ6YZFMyxBJIQB22pXR3XhPyZCxXBkmw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6rN4LFCd91DHFERM9w8Tk0K+/D390wxSFc3EUvFrUb4BaC4Yazu2601H8lRL?=
 =?us-ascii?Q?YPn+MDh5RGe8EjpvSl7KdAhrB5gr9+cl9bZFggi4OAL85C4TZSvtOolEgos1?=
 =?us-ascii?Q?Zve50CLv8Nt+WzfKgsksddIJErlZr5dJE1jVfv+rz10ua6BkNokFA/lliIaZ?=
 =?us-ascii?Q?JqVrsq99NWR2QY9XIQZG6Tipaga6YEQp9qoLKjWotf2tofUVKremWLT/TEUg?=
 =?us-ascii?Q?iwPiQGmfBLs/1n/e400SskJf779QTR+aGsk9ldsnIPT+CTJvok9nYs5NJB07?=
 =?us-ascii?Q?m5kt4TjIMzcawIyMK9JZtEAp+aSe1gWEn+55bmutL+RW7xTo+t72nF7siFQw?=
 =?us-ascii?Q?L9S5uDyQLo75FZE0TtgKDatdOfrDxfzN+DkVQKXjoJRu6ht4ezS7fbehgNOP?=
 =?us-ascii?Q?oF/GRKtN3QgqsajKovug1SEieJ8ZnYlOIjGDZGHiU5z/NyKfGLLd1IP6hRLd?=
 =?us-ascii?Q?oWSRlT3IdJCPSvtD1ZobsIoPK9Wr2gUNWyMjuc6HNtZYcUWdn2zHpIfEdtBP?=
 =?us-ascii?Q?SA0MQoJNjmmgEG/682mmRcHH675+VIG4fN06HQhUle/ikdnF6ckW9GBl4Zan?=
 =?us-ascii?Q?iCpkxFbQGN2IOsyJ/b7f4nsTnHHH6rQ1SGNUHMXPWAc3859ZJ2XUBagFsodA?=
 =?us-ascii?Q?UgLOa9VkHdecld8XLGrPgLzW0kV6zrCNAXOBCbn0U0cGYAIS1RuMHVksIChB?=
 =?us-ascii?Q?ugitoUuA/PJ52u2N4hYn2dbX/Ap1oAJNMHPfIuVXR8FvOMMXwjlc/M3NFs6X?=
 =?us-ascii?Q?FaDhhU/tqJ8LOoBHJOE0pM6IUSQN7aVixhu8qTfgHj3AoqvXhedPYsN5/XRr?=
 =?us-ascii?Q?IUzZHD0pptiGCIdwZ/x6+tXc2JM86KbvdjtF2YYcT7ikSid4mbCe7hrO7YUR?=
 =?us-ascii?Q?95eJXbztGCIjDXqb/ART3lsHvGnH59Mi5PHZhuxcsifPrDcVMrIYMz5MoYaQ?=
 =?us-ascii?Q?DioDCTa/X6oQnxwelScskHfLtebR3B+OEJ7b4YQJWEw6oOnirAe7MTcGgvFQ?=
 =?us-ascii?Q?CUl3b9ywVWj8qjeT75ZpVHB/M1KHn0Ty5G464LzXLwykCaGdHQHhhurByOB/?=
 =?us-ascii?Q?c3AHJJ/ny4kLbwrLO8tdw1qxbBF5OgIo8drmWTaP0RGE+HSm7aqXKxE+SRBe?=
 =?us-ascii?Q?fZsr2UvtwgwlePOINF2ect8vuEZghEB160Bx3rnNZGw/fEq6dGBrVHNEidLP?=
 =?us-ascii?Q?30ffEUccfjjRCUXxURxt4tKXHl8tb5gHY1Vvtn3T6RKHUbfBRfEtsL1ytd0U?=
 =?us-ascii?Q?K/QbkhHxSnsAlAIQDTNVEpvvHIKnTKeHIl1CDwxhgwSOh30j6FAwZhvMT2EH?=
 =?us-ascii?Q?XqqsQWH6ZGmH33QX+w//+K5RXh5tOIaYjC8KgwPGz9tQhkduoMLCmOUz7D0c?=
 =?us-ascii?Q?aNr84884m3c+XMrJBbGugV8LiewtJ1DkIVR1HuwdOuDvTosmr9HMAxFVs/2G?=
 =?us-ascii?Q?hsP/+lrHIM/QzP/CiZz0/8aDdYX95clS6SeGWYkgQL88xozhduFqd7b841PW?=
 =?us-ascii?Q?MSRF+nSI7GH9SRBGdDzM1HRVPNHm5FPA8FAkNyLaC/j5YflV+06zqqzrAR1X?=
 =?us-ascii?Q?xtAGYLJgSx+XOI867Z5iv77qfYQbIG6Nfi/Xt97n?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ffb492-64a0-4d31-023f-08dc758d6f31
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 09:49:09.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJQS63KmS1MNLWfCoWavJLGKkB1X9UJ4RHcTookauOBDVbOhQDGqNIOmsOvnnGtSHQF3AeLeSHnJClVfwLQfgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5802
X-OriginatorOrg: intel.com

On Thu, May 16, 2024 at 04:38:12PM +0800, Tian, Kevin wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Thursday, May 16, 2024 10:33 AM
> > 
> > On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> > > On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> > >
> > > > > So it has to be calculated on closer to a page by page basis (really a
> > > > > span by span basis) if flushing of that span is needed based on where
> > > > > the pages came from. Only pages that came from a hwpt that is
> > > > > non-coherent can skip the flushing.
> > > > Is area by area basis also good?
> > > > Isn't an area either not mapped to any domain or mapped into all
> > domains?
> > >
> > > Yes, this is what the span iterator turns into in the background, it
> > > goes area by area to cover things.
> > >
> > > > But, yes, considering the limited number of non-coherent domains, it
> > appears
> > > > more robust and clean to always flush for non-coherent domain in
> > > > iopt_area_fill_domain().
> > > > It eliminates the need to decide whether to retain the area flag during a
> > split.
> > >
> > > And flush for pin user pages, so you basically always flush because
> > > you can't tell where the pages came from.
> > As a summary, do you think it's good to flush in below way?
> > 
> > 1. in iopt_area_fill_domains(), flush before mapping a page into domains
> > when
> >    iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
> >    Record cache_flush_required in pages for unpin.
> > 2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency.
> >    flush before mapping a page into a non-coherent domain, no matter where
> > the
> >    page is from.
> >    Record cache_flush_required in pages for unpin.
> > 3. in batch_unpin(), flush if pages->cache_flush_required before
> >    unpin_user_pages.
> 
> so above suggests a sequence similar to vfio_type1 does?
Similar. Except that in iopt_area_fill_domain(), flush is always performed to
non-coherent domains without checking pages->cache_flush_required, while in
vfio_iommu_replay(), flush can be skipped if dma->cache_flush_required is true.

This is because in vfio_type1, pages are mapped into domains in dma-by-dma basis,
but in iommufd, pages are mapped into domains in area-by-area basis.
Two areas are possible to be non-overlapping parts of an iopt_pages.
It's not right to skip flushing of pages in the second area if
pages->cache_flush_required is set to true by mapping pages in the first area.
It's also cumbersome to introduce and check another flag in area or to check
where pages came from before mapping them into a non-coherent domain.



