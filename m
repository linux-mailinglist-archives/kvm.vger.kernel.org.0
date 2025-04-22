Return-Path: <kvm+bounces-43756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08BC0A960B3
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1DF51886BDF
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B7C238C2F;
	Tue, 22 Apr 2025 08:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UuFYVmsH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD51A0731;
	Tue, 22 Apr 2025 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745309667; cv=fail; b=erz1bVTPnhEot/H5RGlzGYG6Eli3yu9US7enbGUK/SfMkX/pqJA9nChV0KyaSRBB9sFlJYgo5/d4469nDHyda6pwUkf+KzxD86tsYKwmt2vnUAqCxnCm2worNUPhmy4zVIt7yhr224ctWKc86j2F+K0dJMzPNkLFCAkXzDNnF10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745309667; c=relaxed/simple;
	bh=c/wu91UlQuGeOx6Dw5OJQRSCvx+BCBJBQLCdk05qgBU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o/DZ1l5uclK8rUzdbCVfQibilSARvRRyp+3C+/dH7+SviWaoew3Kh+yWQirtsrt4gvRRG9436e82/lqeAFSWMMyYjD25fw8zUlDMxOO3ldapWzgd+nP/OiLwAYhVN4ksgQCZ9++4f5LCjVW6FE5eittlfiMCZeHzCoeYIOyRhr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UuFYVmsH; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745309665; x=1776845665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c/wu91UlQuGeOx6Dw5OJQRSCvx+BCBJBQLCdk05qgBU=;
  b=UuFYVmsHk+stlXnRsXhIqO48TyeRZ452Rp0GWM8yBNIF2DnZpVkWE4cO
   htF6hIjhWOV1E1vbSyD9r0S/5DN9WQMUwARQ0auOUqhz1dMD+SV8Gu9rA
   vN3iak+Ir9D/5Cad2rB6gumVo3TSUVU+8eTg34hLmPdRdUGBloGCQGGwx
   OW/tGCKWus6YdUftC75QkTgjthtLfl8Brb2BAdVqYiSCt/IGGKV8c1KdF
   fmwzBR+pRex9jHNUyp4lL/1ejOi8p4fokB0IQGMDkdXydQoeat1X2Lkez
   pdad0WkTQQ4rJSOx/fA1gDBk6ZkxUcexNwkzqktrej2IZtTOJjkcfux2f
   w==;
X-CSE-ConnectionGUID: vrhTHk6zSWGYkc1T6CurWQ==
X-CSE-MsgGUID: qZczwHEwRLSfRPp0x1yf9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="64268085"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="64268085"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 01:14:19 -0700
X-CSE-ConnectionGUID: kCxPs0HnQs2zpP/LmfYgHw==
X-CSE-MsgGUID: OAbNwHgCSf6ASzlekAPaGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="132907038"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 01:14:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 01:14:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 01:14:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 01:14:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bA67FjjWk0I9cGEmXRzouJj2vy00/MyU8bK28qWa53hZBQ0pLKP+91oTZPAllOtMKsV/4xxOpkXDFxu/QTLiSckv/JwU/Ow7fZ42U0wEjrZ0sH5UqD3R152+HhD8i9Oi454I4UKY8n2I/p6vL5LY3+Ea2uf01tccyCPcd9zCow3kV+GT3Dky4hbVqLUEl3SSMVQqrEKqzciPtXB3U/hnBsZUS6TKXlSpjQBPWF83NSC4WUmrudfBJYEdCKdiRMDjwARpE48glKDlj5TVoQ5Sq3jczqPhc+5ikENnbV3HgENj2O+0anqb0pjkYkJ3rHJFrci8Kk1unAHnFUj04K043g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNRuX2Or+dNCQnhM2i/YVvqabxf79xReKjyXID34gF8=;
 b=fdMNCKRu5n4z2GM4+h4oNMpeNQQPcgSkLLxJM9pNsBjOxBGRjxeDI4gvp2gzWQw+hNI0jdjBTSNzxYfFTS4FnExU2kBnGPkLFXvuID0tjqESz1dV2uiiyA7MS49YvEOIopCgOMJsEifUcoFp9R3FA51A6BdZ85uQoQFweJY+x6u5RNsZ6G9MHhTEgQjRI95kt8cx51dZfJmtu7caVdkCMCzh3z+p6RPWQunKKKqzZ2gZC3fWeAS8ywLddXwZbO3F5VB+ASPmvj4Mw6fIZiDm4ltqjKtMYQIiv3b0gNzHtzH/GBPJD1huTHeC3O3KqWfxsC3ITsVC85mQM+kal/lhnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8)
 by SJ1PR11MB6274.namprd11.prod.outlook.com (2603:10b6:a03:457::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 08:13:42 +0000
Received: from PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301]) by PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301%2]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 08:13:42 +0000
Message-ID: <910152f4-22b4-4b8d-b3e4-8e044a4d73c9@intel.com>
Date: Tue, 22 Apr 2025 11:13:33 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250417131945.109053-1-adrian.hunter@intel.com>
 <20250417131945.109053-2-adrian.hunter@intel.com>
 <aAL4dT1pWG5dDDeo@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <aAL4dT1pWG5dDDeo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: WA2P291CA0005.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::11) To PH7PR11MB6054.namprd11.prod.outlook.com
 (2603:10b6:510:1d2::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6054:EE_|SJ1PR11MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: 346007c6-62e0-4870-f311-08dd81759801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WmtnSlpYNUEzRHc5ZnFJekhicjl3Uk9jUGd6YktVSDBFbGNPQjhjditjcGFI?=
 =?utf-8?B?a0ZDT0NYOVdJZ0hCU1c5U1RabWdWZElydUV1czNGdHhxVGQ3bFBwV0ZJSzlG?=
 =?utf-8?B?WHRDSnAvV2o1VVhXRW9pNnR0RlZwMmo2WjJpanVoVXRPYUJuMDlDdjNGY3p3?=
 =?utf-8?B?Z0NGdTJmN1lCcmxSbFJFaVBqYVhrb2ZZeW44M0RtNWV4Zm1IU0Q5V1ZmQWZM?=
 =?utf-8?B?TnJjUEViSWhwVUpFQlgzajhUZXgxYjdaUVdZUUZWUHI3NTI0NE1UVDZVRVE3?=
 =?utf-8?B?MEQyb3VDeHF6aDdETGRIaHZ3VlB5Ny9xckp2REcwNHZ6RUVNNVdFeHVBTFJr?=
 =?utf-8?B?b0lVd3B3UlJHdkpwMEphZldmYXB4Tm9lSEdVYlFWRUUydjkrU3BLYURHR2F3?=
 =?utf-8?B?UXRsc2FzNjRSOVZnMnE5c2RiTUhRSDloVUhZczhlZm1TQktnK09nenhLdGtH?=
 =?utf-8?B?Z0NvQkJkejIvSUlPejg2TWZZcUczZzFEanZTSnEwbHl2Wkp1MUx4aFVqYVda?=
 =?utf-8?B?b1pyV051VVhvT0c0Rm1WbzQ3ZCtjOURCVmpHc0xqK0huUVJ2YThVV3NnZnFN?=
 =?utf-8?B?RkZieE0ySlJnQllPc3o3dkgwMk41R2hNeHVQYUtodEIvMnJsWkE3cFRMNGcz?=
 =?utf-8?B?Sk16R090ZytZaWV4dG0vMzBMZ2duOUlWck52aHBMUFBkc3hLZ1ROSzZQQUNx?=
 =?utf-8?B?Qm5QMFhqZUZGWG44QVEwSGZlVTZROUtKcTBQNzA4aEZ2OWR0b2RlUlNwU3py?=
 =?utf-8?B?SXd0ZFErQUtaUTc4TjJmWmtVT1VEUitsc0Q3VWN1OWNzdThhVzV5NjB6RkEv?=
 =?utf-8?B?SDlzUDdaOUNsK0FCNUhnRTNtOC80ZzhsSUhXSGhkV3Z2MmtaY3pCbDhFL1Fy?=
 =?utf-8?B?dmQvQ3JGQ3BGRDJMeG5WWkdpZE05cC95OGlUbFI4cXNHemZLMWxVNmlDVUNP?=
 =?utf-8?B?YU5BVlQ5M29MMzJXbm5CWjJQY0JmUmpNcm1GOFc3NG02VUtyMVN2c3VLTnk2?=
 =?utf-8?B?dm9NWkFka2lPTGRoN0RDZzVJWm5oZnZ3WjhNWFN4M1RTd0k1TEJMU1YwRDdV?=
 =?utf-8?B?dWNyOEVsOWtBL2Rvdk9yUURuKzZVMCtpMUlJL3dtUGtYSC9oN3VOckZJZnJa?=
 =?utf-8?B?bzhCaFhwd2pIdUxZSEx3WEl2WGx5ZVZTNzlxY2p1bmlydTZkMytsUk1pU3dj?=
 =?utf-8?B?dCtUbTBMTWtIRS9BUVZCd25ISFBXRTBTT1d3UW1BQ2h2VWFmalRUK09UMmRx?=
 =?utf-8?B?NEZBK3F2VWFhajBENVVEKyt5YU43dURrWERDUS9QcUJoeFVoVWE2Q3lpdVpo?=
 =?utf-8?B?MllVcm9Jd0tNUm5BU3V5OCtjT0twSTh4QzVDaVB0YnpkSWl4RytvZnV1MThx?=
 =?utf-8?B?TUk0VWlMbjEwYXFxbkdQenFxbGg3bXVvUmhmNFZ1VlpwV3BmalNWdFVRUG5S?=
 =?utf-8?B?cloyVGpNMlV6WEI3eFdZbHQzRHNKdlRQcmhucGtHVDU4Z2Q0REs3WnZqME1O?=
 =?utf-8?B?YVdEaklKZXVHNGxIejc5RWV6MnZGZzNuSkloK1NuOVdxZmF3UXhJUUhtK1lP?=
 =?utf-8?B?ak5VM3JMZ3dRd2RtQ2NMUDRJem0rMElhem82TEZNMjlWV3R0M0s1VFpzMVlG?=
 =?utf-8?B?Y1Bka3NuWW12d2k0aHJtbmlTcUxXUmFudGF6MVZvbENNdDNmZEdJcU1OVWdi?=
 =?utf-8?B?RzMvNWZmRmJjMzVUMVdxRnZkS3hYK0ducXdTUTN3Ry9yNmphSktISWgxb3VB?=
 =?utf-8?B?Y1lCRGJBb0QyTEo2Q21McHZ5UDAwWWhKejBJdmtnNzIxd2J3R0VRdTNJRTlB?=
 =?utf-8?B?endKMjYxblRuWjJKS016alFUSUFSZUVTbWEyQ04rMlRYWFkyemNIbkdWVDVK?=
 =?utf-8?B?RHBLM0t3azJuLzdhcmVhcEhZUGl5Mk4vVFZQUTR3eTEyc2xVa1djUzU4cE42?=
 =?utf-8?Q?SHPx6QyC5N0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6054.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzV5Mzlhb0tkM3R3MFBzNFFqQVNtLy81cDM4Rkh1aFBnd3ZhM3h5NmNFL0Iz?=
 =?utf-8?B?dzhEWEJwbGwrdDFnRFozZFJCTCtPd1JHKy83S1hOZGZORG1yK2U1QTI3YTVW?=
 =?utf-8?B?UXhIRjhSVkpSanhncm1QN0J1MjdGMWxSdlo0NVVJdVlVVytoeHVXbFl4Y2ha?=
 =?utf-8?B?aFdZSnFYVFd3VHVzS3dlOEJ1cGdkamtLejdQQ0RzZHd0VDJhZ0Yzd0xmMVJq?=
 =?utf-8?B?MmlEaFVxMEdNTzcyS3IzTmtLV3ZDK29lLzJmYWFDaHA5Tk5Vc2FLYnZVczA2?=
 =?utf-8?B?YnQyeWlNakZ2elZQWlhsbU5wMVlGbXR0OVZZQWpHVEtDWkVkMVo4K3Y5M0x1?=
 =?utf-8?B?blpEOWZGLzlqV2RQeGJoSExnV0R5aEU0bVVGMHFWU0ZzM01LbUhMQjdidWZU?=
 =?utf-8?B?bjlGRDRMUHVTdVVjMW1XT2lXWktWZThVUkdaOEJJaU1ZTDh0RXhldXNnNmNt?=
 =?utf-8?B?QkZvKzBFd0VCUXJ2ZXgrbVZ2eWMvUE5pZVYwa3pXT2w4bFpZaHRhVXZldTNE?=
 =?utf-8?B?TlJ0SGdqTHJxT1lCM2VvVGxQdmJkcmgrL0dQbUp3VUwxWi9lMU1OeW8wN3dt?=
 =?utf-8?B?Q0hoQU9pWHR2UEs2UTcwaGw3RVJqNjZMaFQ2Tm9uZnJ1S3d3Q01iOGYvUnI5?=
 =?utf-8?B?R2RxbEFXWGpCdU9LOW85MllMQVZYcXl2UGR3OGZjVW50MXIwQmVCbER5dks4?=
 =?utf-8?B?WlF6OVJiV3BiZ3RqQzZxZWlyRWVmKzl4UFJvOE5aWkl4RUJpeVBKUTJvTDJa?=
 =?utf-8?B?dmRaM3YyaGYzMWwxZ1pxNTY1VCsrQ1FaZ2wxVE1CUDQvK3dBdGJqcUgyOCs3?=
 =?utf-8?B?eUlON1A2MWtjMkJ6Y0lBK2RGcU8yTnhzKy8rRzJ2MEh6ZkdVbFIxZVFkQlg1?=
 =?utf-8?B?SVl4VjJkYzkyUDlJSFhYN3lWb3pncFBzbm96NG5QWlh6aWhNWXhITU9EWVNP?=
 =?utf-8?B?VHEvdm5IUGNBbzlqaW5NNFR5bnkzWWxSYjN2RDdFcGtrSS9wMlc5SVNRYU9L?=
 =?utf-8?B?UTVndUc0dnVYcE5mdXVrN0FYUHVNWUc5Q0d1UUhmcFlWTXNqRThTSDVxSFpP?=
 =?utf-8?B?UmI3cGNQc0RCaUVUYldHajY1L2JadUdEZlppRmkyRU1RUzRGM0dwN3pXRzJ6?=
 =?utf-8?B?NU5jVXZyZXlMOVpNVElXc3dLNFFSRXF5ZUpzMnQ5N1Nad2ovQjUrVkNEK3dJ?=
 =?utf-8?B?M3lMZ3JJSm9uMFlGbExYOTBRcjlxUGtFSHBxVFJMbk0zUU1HenRkemJLTmhy?=
 =?utf-8?B?V1hiK1FRTU9UQkxFQWx0cVNrbFVtaDVOT3hXc3pXck04clFFeDVyYXF2QzJZ?=
 =?utf-8?B?Wnd1MWErVzBacnFtbzVWWTBZTDEwbFY1bjZCY2pCSElsVlVLVXNSWGloZDZW?=
 =?utf-8?B?Njl6UXVRU1BXZGhtdWFLMit2UWFMalA4cTArTGVqVVRKYXhPYldGNjVHYUlL?=
 =?utf-8?B?aWlmWVV2blVjTGdiLzdGbTUvREdPR0NaaWV6MTZYNDQ1VVViYUV5alYzZ2xi?=
 =?utf-8?B?VzF1ckJ3biszVWNmS3VvdG8yRldoMDh5Z2RYbGV0WkR5SGRTVlRIUkVZME9k?=
 =?utf-8?B?NHVMYWN0WXRYQ1hnb3hHeXE0THE3Z3JzVDZUYTZPT2VQM3czRWlhd3pJZ1NN?=
 =?utf-8?B?dzA1WHhFTnNCY2RQMUdUQklRdTcwNUxOT2dVWmI3VEpOWGNFTFYwRTF1Vi9O?=
 =?utf-8?B?VDlVWTZzZGh0dFF1cmZHbVV6ek10YXhDR1ZkMHJYWTd2bzdXYncxUm93T3JG?=
 =?utf-8?B?cWNwV3BsVWFZbjlaRmJtM3A4VWQyZGtSRFJPV05zT2ZacWIxTDhBZExsajNP?=
 =?utf-8?B?bmVia0Y3S2V5MXRtdUVsNjFRcDRsTEx4OWpHNDEvMFNoQ3pRMWxCL2hKdlF6?=
 =?utf-8?B?WVhLVUtTWlRJZjJUd2tTSUxidjg4bmJRMVVJM1Q1OU1XQldndlJrVFRURW1K?=
 =?utf-8?B?TklodGJyL0dVQ3F4VmFWaEJLanhhVzBXL2JZUVlpb1pNVzFIQVkrMmRERkgw?=
 =?utf-8?B?NmVBQlZkZTdoTkRjR3FNU2I5S2psSnlVSERkUXBMZitMbk45bk5vUTJlcTlV?=
 =?utf-8?B?Rm5kV3hWR2NpYWN4dUVlbkpQY21nNXYvRjJTZHRyc1VqdmlPWG96RXdXTzZp?=
 =?utf-8?B?ZWxJeDlVSVlZbzI4c292WklNcTFJVnZLc3N2d2F6ZkR3WHBiSkJma1ZwSXFK?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 346007c6-62e0-4870-f311-08dd81759801
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6054.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 08:13:42.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uHKxn/5xJmjuy7HnmlfdLskZpMBPMPDSTpFTVUfoXmXgiqAz2CS/EDEdZOrjSowAb5lNkKoN08vhYzZ0NBBFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6274
X-OriginatorOrg: intel.com

On 19/04/25 04:12, Sean Christopherson wrote:
> On Thu, Apr 17, 2025, Adrian Hunter wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
>> which enables more efficient reclaim of private memory.
>>
>> Private memory is removed from MMU/TDP when guest_memfds are closed. If
>> the HKID has not been released, the TDX VM is still in RUNNABLE state,
>> so pages must be removed using "Dynamic Page Removal" procedure (refer
>> TDX Module Base spec) which involves a number of steps:
>> 	Block further address translation
>> 	Exit each VCPU
>> 	Clear Secure EPT entry
>> 	Flush/write-back/invalidate relevant caches
>>
>> However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
>> where all TDX VM pages are effectively unmapped, so pages can be reclaimed
>> directly.
>>
>> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
>> reclaim time.  For example:
>>
>> 	VCPUs	Size (GB)	Before (secs)	After (secs)
>> 	 4	 18		  72		 24
>> 	32	107		 517		134
>> 	64	400		5539		467
>>
>> [Adrian: wrote commit message, added KVM_TDX_TERMINATE_VM documentation,
>>  and moved cpus_read_lock() inside kvm->lock for consistency as reported
>>  by lockdep]
> 
> /facepalm
> 
> I over-thought this.  We've had an long-standing battle with kvm_lock vs.
> cpus_read_lock(), but this is kvm->lock, not kvm_lock.  /sigh
> 
>> +static int tdx_terminate_vm(struct kvm *kvm)
>> +{
>> +	int r = 0;
>> +
>> +	guard(mutex)(&kvm->lock);
> 
> With kvm->lock taken outside cpus_read_lock(), just handle KVM_TDX_TERMINATE_VM
> in the switch statement, i.e. let tdx_vm_ioctl() deal with kvm->lock.

Ok, also cpus_read_lock() can go back where it was in __tdx_release_hkid().

But also in __tdx_release_hkid(), there is

	if (KVM_BUG_ON(refcount_read(&kvm->users_count) && !terminate, kvm))
		return;

However, __tdx_td_init() calls tdx_mmu_release_hkid() on the
error path so that is not correct.

> 
>> +	cpus_read_lock();
>> +
>> +	if (!kvm_trylock_all_vcpus(kvm)) {
>> +		r = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	kvm_vm_dead(kvm);
>> +	kvm_unlock_all_vcpus(kvm);
>> +
>> +	__tdx_release_hkid(kvm, true);
>> +out:
>> +	cpus_read_unlock();
>> +	return r;
>> +}
>> +
>>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>>  {
>>  	struct kvm_tdx_cmd tdx_cmd;
>> @@ -2805,6 +2827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>>  	if (tdx_cmd.hw_error)
>>  		return -EINVAL;
>>  
>> +	if (tdx_cmd.id == KVM_TDX_TERMINATE_VM)
>> +		return tdx_terminate_vm(kvm);
>> +
>>  	mutex_lock(&kvm->lock);
>>  
>>  	switch (tdx_cmd.id) {
>> -- 
>> 2.43.0
>>


