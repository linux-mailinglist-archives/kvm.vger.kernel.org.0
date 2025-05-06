Return-Path: <kvm+bounces-45589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB93AAC32D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 13:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 997BC1C07D65
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462CC27CB2E;
	Tue,  6 May 2025 11:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mJU+wIMb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C827CB07;
	Tue,  6 May 2025 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746532693; cv=fail; b=cNKFDAvMwoFfd/v95BnNQ0bMreVf4AonVVbHCwzdNqYI2fsHqXJ9kyyFp6e9Ut+f9HpwAn9EeWT5Nilo/JQwBw+8Kn2PpdUzkjnl9nNr87Qs9TS/sT/HqtHY02A6q62LQM2Ir0GzsplZsAlCGLcdGxhOT2lOgXa2y1wmbC/J0zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746532693; c=relaxed/simple;
	bh=uJvBORdjMdPPZc5naPtG2ELhLu/9sT7wj00OVXOsYxI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vDKbume/9fehKMLh5Mg2Tx7rCNgYx71SCUrRHowxNyl2gs2tOu4Kehs53UxVppabl5mcc0rzr9mSsR48XCqS4RXAtwII+B1b8+hQRF7gCjir5CrgVlO3HAQrfw/YC6JboF+izvhbGUVGDNqzKQuvbqaWfmmrNx2M8BD4e8KJRUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mJU+wIMb; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746532691; x=1778068691;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uJvBORdjMdPPZc5naPtG2ELhLu/9sT7wj00OVXOsYxI=;
  b=mJU+wIMblTR2Yw5ymU5zB44wFMW7P9RjkOAZd7XIje8u8ffH7t/d67tW
   m8RB9/tngUF+r/pJDNMXEfIhutnBXus9xDMYfVsBNnUUIVlGKC1Rlj7yP
   BU04KiMsDXc9nyt7C8ixx9kWJy1SOyJwIZ2OFipZ0qtIEwU5wD4/WQ3Ge
   jAB9ujn/LL9DhPsUXnXCB32xyWrWhJKVkws3LKEp+wGZbCPq1t4SXNrjE
   wosqH7BTfjDhmgR9KmBepof72f7n545iAHcQfbRpnM4e0Wwh9+5zNX4JW
   yayLn4W1JF4peERKbcdR5NHU583sKrM89Y8kxUUdLXae2GFOt2DkszNX0
   A==;
X-CSE-ConnectionGUID: WXpds4zURKqLCv79c3pTrQ==
X-CSE-MsgGUID: +OQRGT3CSiiKkzWRvrTbIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="48324602"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="48324602"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 04:58:10 -0700
X-CSE-ConnectionGUID: AuqmrXVfSyyE6eAjE5/M2A==
X-CSE-MsgGUID: CBZZGB49TqO+93NW9/DqWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135574811"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 04:58:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 04:58:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 04:58:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 04:58:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFNRL2VhUNYJnfwY+IkV2Q0Qzes9eRRaaajVCk5BGizo6h37ofPkm7tT0mXoUffoV75oKjXhZGskYLHhnMNeeX89T6hhgU1iTtchEljMtVohRfsHMtcpYjGi8I2uhJSNTbUDvBw3otYvl7Q9mqqjhZzh+fKRWwr/DXdooVv/1aJfivVQcLRcFU9aJVDqPtriuWj8UxkWQtcqndL53uwM4BBON2BM7kzz52VqdqCdtwrPXp2oqkpKmf1goCKU0LOYikthQ591KvS/0iVDhfLbn7WRNRqBZMvj7OJKVzHX/WcRP0q0Afn/L2RSrrXt7uDGgDf35oHwqa541E/Q+UAW8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TKUe6qreuXaGFuDvYK/jA1QRBA0cbR5nJ3I+wUg7rU=;
 b=EllX7BINezf1PjtFpYDFGytcdhOcAYNSsEfDb8Xqlg9IQ532X3xK5YcW1DTfIFEC/DR1+QvoGiZKrtnhXJbknQAmucHPiSvCBsSEtMUiEVixqnvX0DHEJ1zEnq40QydSYYrFddAeVnAhMgzsJvUo6Z3nL//N4qU/AnzLwICaNSYYbMI61A9DHmoVbFw0rXzpzD+ILbRusGM85NFjVyla8TwUrWwT1FuB2RXjA3FHwsngbBcArUe1p6J+wsLQtn21X07v+cryQjRJbbtv4fUbeJLnKjyHTTySRLSe40jZgGM/pfrARNmgqhoyHFuHRst+9d4klfj8OeLq1bUs0iNUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6056.namprd11.prod.outlook.com (2603:10b6:510:1d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Tue, 6 May
 2025 11:57:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Tue, 6 May 2025
 11:57:18 +0000
Date: Tue, 6 May 2025 19:55:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: KU2P306CA0009.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eda7573-0b3d-4708-d832-08dd8c952695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PXFeOg14Bp6NAZms9FabD8uoIyuWF8C51cjocxbox+wKkNNB4y/5a4ic5KZn?=
 =?us-ascii?Q?2oww+uIpOvG9jdUXcemUY7dVj1PCb2ByNFixo6oDxRFV0Yd3g0OMTLUB+BGW?=
 =?us-ascii?Q?0fHN4dAPh0gNOaRixOr0OGeuw+Btk8T7m6QB79SyZaYYqKGnliEfyUXsFC6L?=
 =?us-ascii?Q?is/OwgkDSp09+/qw+4Hi4eNcGTKsNj+mOLXvfVlQsJRnq9mc77QRUI0OKsx8?=
 =?us-ascii?Q?ePVwjsrgX99fN1ch5wDX/yNxrXzc07PzrN2+EK2QS3u1AM1Hk/uy6XS+FKiq?=
 =?us-ascii?Q?6HC9UTN9GOLAtGdugw6ulJXhNXBKk8yxZHf8ZRpL7c+MDQEK4yRGWrwu/87e?=
 =?us-ascii?Q?MdJ9q0+ej/OYCmOSr9NIVhc46sWLPdCpOpkQJh1yl7XYVEeoqjiURdK/y5Xz?=
 =?us-ascii?Q?1IgualnA4BuwYCojDyMsdV4i2vfOZbKTmLeiKtZUaZRH3HXm1hMm52rbxIe+?=
 =?us-ascii?Q?3jP4KSNZ4rjcJB7gCj9s/hdJZCtYZTvfiGsfSL5s7wLAEl4RQox7KMRpmQVL?=
 =?us-ascii?Q?sNb/OZ74TSvujucz3hMaqJ/4hFpOww6B3JczLhr6lK9jVAXC3N2HNC1Xz97E?=
 =?us-ascii?Q?8r7XOnM4BK1D/kX/eohIyrPiB47O6zSOViK/UcevhurKlUYP/t6zRAxDmgu7?=
 =?us-ascii?Q?Fa5y5bNE4QrxQoLAUeR0Dez0goMvIAl0RbpxFtnDgi6+vFLfzwglMcDpz5er?=
 =?us-ascii?Q?5kbdwXddPz7uUV9ZsUWf45fuGo124hhu9eSEgysNqfKSaPV2oX7qxfccXKPg?=
 =?us-ascii?Q?AOR5D98yj1UxPsV4Cfj1IXtojv8yaES8LzaIlvQH+c9frKvEYkQnq/4CNRIn?=
 =?us-ascii?Q?4O8s/CKjPex2+9psL7Mcadta7Ui3f16VRxhI+fU1ANV9TX9qugAoPWUW/Tqu?=
 =?us-ascii?Q?JP84TlY3HE/anekIsMkKWSp1BWmbZzPY572wlQYJBT5p9qq9KxyBoyI6FYlo?=
 =?us-ascii?Q?aNY0ii3WHajQPEFz2oUwww3Hfk+TcRfaokOxf6VRfacIUukKuikh5AVfRtUT?=
 =?us-ascii?Q?uTF1n/2rxZ7vpmGJR/1zJEeguHj+aVZBiwPZ1DUAejdJ1a/PEnRb7glqVWtc?=
 =?us-ascii?Q?CH12e2BjelSwaVrfF9UocnQ0qzFgsMBUg8qasFBeNqDoo2pkWHWOdexSz277?=
 =?us-ascii?Q?76iVsMC2M7uJAdS1bm10voizz3wXb4Z4ZeeXUUPj3KFta8qY1A4B6YyhvZ8J?=
 =?us-ascii?Q?fSCCRp5wsxCZarEO1ggllc72HqcQN6lL9aJXN/cZOknZhjwoXiaC26yd0VeA?=
 =?us-ascii?Q?lI+ayqrQuPuabPcid/d91AHti5d/9VV93ZG7FZdBkWU6/+6dUgCMx2MUCKtz?=
 =?us-ascii?Q?92clDb5PlLWZf44zIzx0jt66pNz8FIzzH9a834r6b3dGRwM1Yh8XpHjLIN/H?=
 =?us-ascii?Q?04UjhhBgJJ0EBNwSoQcNQkjxhrrwTRwJeciY6TkzNMXBirQZKoRA96l3GgIc?=
 =?us-ascii?Q?OF3aeuh7uUQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bV72K1QmfTh0KBgY71m9JKbb2hkIaRvvIDp9OSWc9f8okwYUv6ULblEew4gR?=
 =?us-ascii?Q?op85opTPI1gf7iYYtPP4YZkxLSYw7oqBWdhSD+cdiAdkchsrz/oWZ3KBkM9/?=
 =?us-ascii?Q?F6qnYc0jjY0FoNvOy5qr8bjNyp2Cq+uI+Pe+9SsZ0j7FNQR5bIePlMt0bpf5?=
 =?us-ascii?Q?MBuJwDhMTdO+oToasXrbhPNEgIFSzPq2aI3Gu9xaMB2+8AFUTQioe95argyL?=
 =?us-ascii?Q?Jwrs5Ag+X5kororOZHScMkCkN8ayWYCH9maLvuDGS95Gp+U2Dl7S5yYmB8WC?=
 =?us-ascii?Q?/HIDJM37VX9HLvI5xbe/PS1zS4KVfNW6E44z1CRcNgGn2J43MLRXn8PmsHsU?=
 =?us-ascii?Q?kE6y6BgsVygOzOANSR/y2wK7Rx4MPJaBskPqQ5QkEjFZyuMV+wwJnIWOUZAv?=
 =?us-ascii?Q?Np4v6K5hYnYHsL+e2xRdKfXVbIn8W0qZe//c0wPf6TyDSTU7off0tALEAYIg?=
 =?us-ascii?Q?d1CaUQZRJK/TKT6iKTqWDubXp8J66qsSvgXSMjMPYRmC2q0VaPUzRneDxGpe?=
 =?us-ascii?Q?kY+ufzlLn58nXyg9NqUtwqSAxIPgGHFgsuScQiI+r2djS6nZKO+t27v2ZvbK?=
 =?us-ascii?Q?a5tMdgVgGJdpF2hz9Rh0s24ppkGQd5kfdfOa6kQ4nJPe6wY/3MxxLDVPeNLp?=
 =?us-ascii?Q?rc+aoAc0U5ldf6kTPyHtZZACMpp6LhqGVsq6q1STRXwUhQYrI2qaZymBs6df?=
 =?us-ascii?Q?a5NldgC9sErWAIIiutiu6JK5GW2qePnloEo5ImDCPDRg+JgklaeagPUnYxyG?=
 =?us-ascii?Q?X1vcWSeH43E/6GPZjgOLocOi4wjbZWRJv5DTPxRmbWT0syvkAWn0AMn8PqY4?=
 =?us-ascii?Q?CjjhkiQzjhIbjgyCE8eVAu2VMDerY+puS3SJaDS/18HLw9CEk5ugBFB5OvHQ?=
 =?us-ascii?Q?ox4CZ2AzAYK5EDBTqVoYKXaPRJM3zr2zhH2J/0z0Vluc0GVHzgXw1qkDJ+lI?=
 =?us-ascii?Q?ZRIpGHaA67BnIJM7jY1/nOVC2xAYubnP7+tk5zNAI9FHEOy+C7D2+TOdhnpa?=
 =?us-ascii?Q?tc/YdnYa3qOP6kTYpvhX1Kfz/jEJFG8Mp19ELIKZbfmmZJ1cAJTHVReGXczw?=
 =?us-ascii?Q?3/0fYdFeHoLStB+rvwsoOq8uG3fWAXehY8BzC1nyvu0PEBaEaeb09mB5O6j+?=
 =?us-ascii?Q?dGOeYUgFPdUgxUUhJF1vN4v7SAxLuMGDl5Y0KBTigAV2BgxOTv2TTlz3cyZV?=
 =?us-ascii?Q?KNOEAYzJ+lQ40FQmKQ0rn5wqIVedeTq9ogGvv8sW5gd6zuDV3OJYb3Z5nnIm?=
 =?us-ascii?Q?f28fUsffR6lk6rLvyyonkSLMozoM/M/71v1imyZWN+JsYTVpXfUH2CPy6IoH?=
 =?us-ascii?Q?gt0pHmQuIv+AHG8jdwbOnVA/0yL2MZlhkzZqi9VfNnRF5P0AJbuqGwD9Gvmj?=
 =?us-ascii?Q?z2PFwWESpdxPRJ3GxUQnsDXijg/BOSUlSMTM4SydOma3a93ZL87w+9FvUkTB?=
 =?us-ascii?Q?Qypaa6J/A+VKtQ3Gb5awDPVI03/3bT1pF/tsqZpW+BdR67GfwUjcLmuf2DIq?=
 =?us-ascii?Q?MR+6romTgqcXSgFotnQdvM8XmtMjntQ4tUauF81lcqaBbu2JzQ/1jVfYbrdl?=
 =?us-ascii?Q?NDBoWgBqIIBj/CqqIirFNZotqFgV20jDTNwgBSKi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eda7573-0b3d-4708-d832-08dd8c952695
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 11:57:18.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBZIxxNKfjQmZA1qu3aNk6Jx73lgAjzE2Yw3LPfEB8shSjFGge29EKsZGGYzfvSRKIL9oWmDC432djygvVWMvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6056
X-OriginatorOrg: intel.com

On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> The functions kvm_x86_ops::link_external_spt() and
> kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> When using TDX with Dynamic PAMT enabled, the assigned memory must be
> covered by PAMT.
> 
> The new function kvm_x86_ops::phys_prepare() is called before
> link_external_spt() and set_external_spte() to ensure that the memory is
> ready to be assigned to the virtual machine. In the case of TDX, it
> makes sure that the memory is covered by PAMT.
> 
> kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> is available, allowing the implementation to allocate memory from a
> per-VCPU pool.
> 
Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?

> The function kvm_x86_ops::phys_cleanup() frees PAMT memory in case of
> failure.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>  arch/x86/include/asm/kvm_host.h    |  3 ++
>  arch/x86/kvm/mmu/tdp_mmu.c         | 47 +++++++++++++++++++++++++++---
>  3 files changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 79406bf07a1c..37081d04e82f 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -99,6 +99,8 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
>  KVM_X86_OP_OPTIONAL(set_external_spte)
>  KVM_X86_OP_OPTIONAL(free_external_spt)
>  KVM_X86_OP_OPTIONAL(remove_external_spte)
> +KVM_X86_OP_OPTIONAL(phys_prepare)
> +KVM_X86_OP_OPTIONAL(phys_cleanup)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6c06f3d6e081..91958c55f918 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1813,6 +1813,9 @@ struct kvm_x86_ops {
>  	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>  				    kvm_pfn_t pfn_for_gfn);
>  
> +	int (*phys_prepare)(struct kvm_vcpu *vcpu, kvm_pfn_t pfn);
> +	void (*phys_cleanup)(kvm_pfn_t pfn);
> +
>  	bool (*has_wbinvd_exit)(void);
>  
>  	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 405874f4d088..f6c836b2e6fc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1137,6 +1137,26 @@ void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
>  	}
>  }
>  
> +static int tdp_mmu_install_spte(struct kvm_vcpu *vcpu,
> +				struct tdp_iter *iter,
> +				u64 spte)
> +{
> +	kvm_pfn_t pfn = 0;
> +	int ret = 0;
> +
> +	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(spte)) {
> +		pfn = spte_to_pfn(spte);
> +		ret = static_call(kvm_x86_phys_prepare)(vcpu, pfn);
> +	}
> +	if (ret)
> +		return ret;
> +	ret = tdp_mmu_set_spte_atomic(vcpu->kvm, iter, spte);
> +	if (pfn && ret)
> +		static_call(kvm_x86_phys_cleanup)(pfn);
> +
> +	return ret;
> +}
> +
>  /*
>   * Installs a last-level SPTE to handle a TDP page fault.
>   * (NPT/EPT violation/misconfiguration)
> @@ -1170,7 +1190,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  
>  	if (new_spte == iter->old_spte)
>  		ret = RET_PF_SPURIOUS;
> -	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> +	else if (tdp_mmu_install_spte(vcpu, iter, new_spte))
>  		return RET_PF_RETRY;
>  	else if (is_shadow_present_pte(iter->old_spte) &&
>  		 (!is_last_spte(iter->old_spte, iter->level) ||
> @@ -1211,7 +1231,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   * Returns: 0 if the new page table was installed. Non-0 if the page table
>   *          could not be installed (e.g. the atomic compare-exchange failed).
>   */
> -static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> +static int __tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  			   struct kvm_mmu_page *sp, bool shared)
>  {
>  	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled);
> @@ -1230,6 +1250,25 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  	return 0;
>  }
>  
> +static int tdp_mmu_link_sp(struct kvm_vcpu *vcpu, struct tdp_iter *iter,
> +			   struct kvm_mmu_page *sp, bool shared)
> +{
> +	kvm_pfn_t pfn = 0;
> +	int ret = 0;
> +
> +	if (sp->external_spt) {
> +		pfn = __pa(sp->external_spt) >> PAGE_SHIFT;
> +		ret = static_call(kvm_x86_phys_prepare)(vcpu, pfn);
> +		if (ret)
> +			return ret;
> +	}
> +	ret = __tdp_mmu_link_sp(vcpu->kvm, iter, sp, shared);
> +	if (pfn && ret)
> +		static_call(kvm_x86_phys_cleanup)(pfn);
> +
> +	return ret;
> +}
> +
>  static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  				   struct kvm_mmu_page *sp, bool shared);
>  
> @@ -1288,7 +1327,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
>  			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
>  		} else {
> -			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
> +			r = tdp_mmu_link_sp(vcpu, &iter, sp, true);
>  		}
>  
>  		/*
> @@ -1514,7 +1553,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * correctness standpoint since the translation will be the same either
>  	 * way.
>  	 */
> -	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
> +	ret = __tdp_mmu_link_sp(kvm, iter, sp, shared);
>  	if (ret)
>  		goto out;
>  
> -- 
> 2.47.2
> 

