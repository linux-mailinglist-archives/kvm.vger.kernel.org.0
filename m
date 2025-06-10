Return-Path: <kvm+bounces-48766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDE6AD2B5F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 03:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0713170B5F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 01:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BB61A8401;
	Tue, 10 Jun 2025 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dMb1OfVo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B207E10A3E;
	Tue, 10 Jun 2025 01:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749519498; cv=fail; b=KRTJ/2XXkqF0ewGp95iMsrWN9BsEQ1+PdA6iMMBIS6o/8cStFhy9gnVwseN8jHoCEDP90aTI6h1TusOjlFQkUE6oJa/Q92Iuw3lPpU7TmxVyawBh/d6hg0Yrbf235NOnciaqShJD1/0XjWtwLw80eB6U1kVc/0F2Z+9yxGkfPJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749519498; c=relaxed/simple;
	bh=BgWbUdUtGyI7tnAQejSI6c3UZUH/NRZSGxO1nRjEJ60=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QDo7I/KTmw3lWmclZcyCgglgMLbJQXauQqYE89E7ULUm5FyW3KV1F/pJbxKPO0tU6gcjpeoyPBv2qcT2AJbjQluResQayDJmlQjS5OkJB1QFH/Xf2tThtxDtylzud0tkE8C8NW/IIl1htZg6TadNnJSiXoYsACUxy0SX1KKAVcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dMb1OfVo; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749519497; x=1781055497;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BgWbUdUtGyI7tnAQejSI6c3UZUH/NRZSGxO1nRjEJ60=;
  b=dMb1OfVozZj0il8hKyvziKaoBW6XIt7HmwihcJWzvKB1yMpUBR90lP9O
   DZ6u8qFUuqgdNQA2F/0eyCw5o3WDUkU2NukKpz+qcIoBc/jN0eK71Mb2c
   TKjsSlBKqywgpQ0mJyY+if8vrMOajayQLW2UYeO24IXiUd/yU8bcbHDuu
   k9dQ6vx5sKURNMLwilipcpBwISeT9fZsaqRBZjVNfOXgaL8ak3Rh8fhHo
   bXXkDpsp+SLAVImUy6TyzCiF03CNfVC1ODll6QUFPiP7s4emzL5ujrHhK
   85nlIFnZmNHlVnV7CDY8vYIdzV6uRRzcgr60NUcs+hdVtz0xs8wue/vwk
   Q==;
X-CSE-ConnectionGUID: 3RAehet5RDuovfnHe/MCKQ==
X-CSE-MsgGUID: hwtINVoQTRCFD2j68i+GRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="62227378"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="62227378"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 18:38:15 -0700
X-CSE-ConnectionGUID: XR+V6fqISxuSzzxpzkjbwg==
X-CSE-MsgGUID: zy5ysFaBRCuP4PDSPGCrcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="146582669"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 18:38:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 18:38:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 18:38:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.56)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 18:38:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ujgjp2v1oCAGFwIAfoOiWkeHzlWkQQdl9Bazewcxhui/wWdSae3DQc9N7YUmEGd7iYiMaEZ2/Fr90tBKrQpH1l0f0iD7/5WH3CFawaZhpINLFxDYMH5S89+EaagUMRSefXTN70dSm/QDoZfQ0KyenMmGOPlf/myHShsLYjxnDarJrcPE6bCaFPthEGHFVGHvoXT8M9rpiukziTRAlZAixmPTO17NHiTBmHh/E7Cs9etlomg57Eb0L7O/oS8dGcOldG2KymzpPCQ4h60+aGN99J5+IePahw7sUKT4E5bV8F0le4q3aIo/FqXbV1CzBrevTSP0dKa8mZ0BPIPBhN7cNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=my+LD7K22rP2lAgpuKZjeBy00JRSunrMqKyPuVqMq7Y=;
 b=TTyP7zHExmCpk3aUmJXdyX1Yd0F/VcwFANUXdka6wRqghb0IeaNXsh/Koz/BzP0lCidQyqEzRJOl004Aofw73LvzmUdHkH7Ibh/TkdxEROVztf1KHJOyDh0j6SG77aE5z6EIne4a6fN6EUtAaLs7SzGbfH8sfvNGekbfv3soScSEOvAOdbTAu3NwoTLETUzEDJzE42MGaj1xhWimQPN7sd/V+dBXpN4+84LT2BxCZn/iWapuip6bua17oLZQOSglVXrQz90MmFRBvkGCNJn1/jkgTq/Gio9u/u4Y3cYhFbkcXxIsPkFlEDlVOczVp0talhXa8eywwNmxem3SxWijig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.27; Tue, 10 Jun
 2025 01:37:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Tue, 10 Jun 2025
 01:37:52 +0000
Date: Tue, 10 Jun 2025 09:37:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via
 sysfs
Message-ID: <aEeMY7czgden2lmX@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-6-chao.gao@intel.com>
 <b7e9cae0cd66a8e7240e575e579ca41cc07f980d.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b7e9cae0cd66a8e7240e575e579ca41cc07f980d.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0048.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BN9PR11MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: 113cd2ef-cfd2-43c5-ce7e-08dda7bf6a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pyau1Mw1A9DKkxRJSxFKYPypIpenMA3PZNPRRxkpH1jhHElD1/vWJE0dHC5O?=
 =?us-ascii?Q?jjSeP3vIFdTDXKhUibaX8tkVYMfSUf6DsE8yDXi+IWwbJBTwi646hjeGJ8bQ?=
 =?us-ascii?Q?d3XnhPiXqFWGDarovWZfH/ARvGPHXS4iwGQ9ksrzodWbF/FhBhx/KOKJES4j?=
 =?us-ascii?Q?eBQW37uBgUCAhqKRchyzhGx+TAcOa1yWqTXKt+KtuaApYw7s01V0eXNr/ZqR?=
 =?us-ascii?Q?+P1FsO7xN2FjO+Cdwd148iXLy/8VvFCi7KOKyfYd9mvtLMvxKKkXcJ2FmclL?=
 =?us-ascii?Q?vgbWx7RZPsZppAt1xEpzLz4ZuLn7oguUibuLQ+YpC3SP3EB7RSJcpnMjOdWd?=
 =?us-ascii?Q?L+7eAFToTfYV1Y22sWh/Ge4wqTLFZl5rGONAaKB/q9k7hQf7w10XMW81Y71j?=
 =?us-ascii?Q?IQ8//KcyCJfOgOaKvAuJcSN3YVTpX3dMYTpPrBob/opi4isTyJPXPsPMALAW?=
 =?us-ascii?Q?luMcm0KexvEogzjs+YJdofPaVq7YwQM0pml+6sf53BWcgGwlZyq7W8/qa/jn?=
 =?us-ascii?Q?F03Zk/cDVa82pzyd+M3yRP+lHCHUPDIfzIfalK+bIL0d0+9GZgW08HUE+ETm?=
 =?us-ascii?Q?XBQziR3y7NoLJ0povSeA8xMivRDzMq8cPmLZVzTMWm00mCiZqBaoar5l4OzF?=
 =?us-ascii?Q?bGZ5oYqJwLBIj4ueoeUoZ32Ft/mmQaA8fwGTdb4GGExAJC2c0ma7AztQoLXw?=
 =?us-ascii?Q?McbF72uQ36RaXa5gpMDhONsftS8jiljKu9KhHhF0PQIvpGqV239FMCKOffL8?=
 =?us-ascii?Q?TvDWbYQD0RNKSLqNaB8R5BT7WGxJNlKZ4ny3Fm4YxgaRgDi/a+RUuLcwsaA2?=
 =?us-ascii?Q?MOppmORDNu+uPud8xaWz4nSptd2EI/UxxBI81ULc9B+nd3mznZwA+2AeAtsY?=
 =?us-ascii?Q?PyWSwD6bJH6jzQ1VhapCGxVp8p9Hk115vllwCOFP8TKz2X2Mz/zOQEB57aBU?=
 =?us-ascii?Q?24Td4R+kjoDLQCM9i2Rlc3bxYV3vSw5+5GJ1QMnvijxxFKQDtj/WN//XclTm?=
 =?us-ascii?Q?E9INyKccWyoNaNTyhSJujIs2MVll/CzF3AyHVLgmBhOhfaUyamtcw5SA+4Tk?=
 =?us-ascii?Q?sHwv9Ym6w8kXiB3Mkc0YBe75Y2A5qsST9qfWJpEIrXqdtAzgrZuliKbLhN35?=
 =?us-ascii?Q?317gkFS1CDdZypMM9q4mY27OXaxnYu3U/XAgKSuLg4yvk3GgLHsnmXT0syNy?=
 =?us-ascii?Q?/tzSF1BLZ5qB2hyZJOMgkK2gGqFpzKb5fu+UL6w+DixgEgl6/26vNWRecoP4?=
 =?us-ascii?Q?MZnGjUJsBm1FRhB0vaJCayc+kURo+A02NCiruRE+k4xtNT/YcJDNW6acptbm?=
 =?us-ascii?Q?tZaKs9+dgargSk+P9s8j/Cbt+HNjjJ3dlFLmnGSqr24RdU64qUnahnWFdVN1?=
 =?us-ascii?Q?mAzPZ1d3DrueA3zwIhGsfGitS0G2l0h7VodgE2KnFgwrhP6Az+n2Vofh9rsB?=
 =?us-ascii?Q?XIcrrZ2ul5A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y6XRD4pAGqc/Bmv6ZgR1EIuEI88OX6lsP64hu5ROdUCYnHYiRxhDX0oBBqBK?=
 =?us-ascii?Q?G1Ltsu2+b7ESMZqFMU0ngznZSNC5RwpssQUPj62vAFG3Co4rLRdIwHLb1cvm?=
 =?us-ascii?Q?37vFioRNbTzJZ8ZLy0OOXLe65ksxVgc9+BHI6XNa6T1RHE83osI5Nj02hG3z?=
 =?us-ascii?Q?AVid2OzjKfSiI/V4K5sCf4Dvlke+zb6TOc/0o7xkV56U/9JZxdAOItsmoOFI?=
 =?us-ascii?Q?PLPmH7x3uthRQynWd14jaU45CebCQ7d5zx/LcFzz4oQD3dD/lGv7gbEE519f?=
 =?us-ascii?Q?CI0gBLfcK+O/cL1bIBYivsGvBwgAFY35L+cqFhrnPHQWocIGiqhsKL6wDiDx?=
 =?us-ascii?Q?3UNKsoS4N20jso/PWPVuxryx8FF8i5aFNFTGtoDhHIq9BpghBhwDNhwonsrw?=
 =?us-ascii?Q?BD/ZXYy1wwhHo+DcHd+I9dCk9a3wiW2yv0z4XQTaLdcJeArDFAfidyuk1B/9?=
 =?us-ascii?Q?Hk4vigL5oz35546t5mw24gCSAu9ravtXPsJ4eO0kHH8d2ZyIR7CTY0hhkbma?=
 =?us-ascii?Q?Wr5HhLdAypY/G80shWvyXuuulEldx6irN0TmeEbWT39bSVcOQu9D/ZMizzv2?=
 =?us-ascii?Q?tmkkEHyFhF/dDkvFFSqnRyNGSyXne2pzO6XAn9BYYZmqztsD7VZtIVAVg1rg?=
 =?us-ascii?Q?qcfv0ueRGZ/tTMSsGTsFJD0tjErvnEJLdwGSi5JnNffzElkgN0QNONskk7zD?=
 =?us-ascii?Q?WUdTtltPAIL9SuAmVTR3PgGjVWtLAnN24zdw1WUn4p5Ws/kUfVmT2C/WndBH?=
 =?us-ascii?Q?8/XSpZqSsxcSeoLhqq1wr8KoVHaQQZNI1+u1aQ1ZvznW4er5qnAcxTANbeRS?=
 =?us-ascii?Q?uTJY1zqqu1r5i2+FCe9Oy79qxeTGCDARTbda13gbgBY+Hi12NNK66An/DN4v?=
 =?us-ascii?Q?/OelB7FB1+DQg7CRlMc5vcKvKWk9idbp84odlbX7pnozByS8GmgdbJZ1Wlsm?=
 =?us-ascii?Q?d9IdBa2x4GFbhYaCLb694iPTIhNvhP+5iKsNLLvGY/M549TRdTQQ57nufX+C?=
 =?us-ascii?Q?Anep7L6hkV7uXHJLJElPDRIWHsqkmTgAdZUEWpAVGiUN90WUf5hbSKuurYi0?=
 =?us-ascii?Q?eoxgvD9+b/4VIb9CNfJ/abNwHWlRK0QjOc7wk8eEMIOzA2PLzvILWnXB8iw0?=
 =?us-ascii?Q?bvJ4sMaJcj8/LyNUNZf2FIWUP98Dh+1DYwnUjCOgxvSZpAvoVXWWFlY0KVbd?=
 =?us-ascii?Q?DO4iFsDrXkiBGGxnWsQXdggNEJ1yr6C3hYrbYtxtRCjxlneC3CKS1Ypst+NI?=
 =?us-ascii?Q?Lkmf6BlFUIKr9Bw0zFKtQs7khQUZsE5wFwa/9lnHAsWy5V8aTXy/4RHfylmu?=
 =?us-ascii?Q?SdQdAubjvfXodYuzvIUt30mHlGGW+V23Z6OYgscJB1qpohphsbJoseGue18L?=
 =?us-ascii?Q?ZDol80AG7idzZPp426dodGVqEEXJFlNYjsAhXZmI9U2k4DWouehiKdUoDlUc?=
 =?us-ascii?Q?GXqS1ChNH0kIMyVnDXgBGGuHb/NVrC13O41v9sIZLmd3FTkvLWLZ562l9i0L?=
 =?us-ascii?Q?2zFipaqRL/QEP5/ZsTPTIziCYvhvkAAZoWSn0hX/JxMfysqTUC0QAKMO3YiC?=
 =?us-ascii?Q?9MJFHY49w87FeVSQqH7FOtX6pjgBlDkBZcSHU5w9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 113cd2ef-cfd2-43c5-ce7e-08dda7bf6a89
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 01:37:52.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjJDdrq/61j7phS0sE+5iQbJ0x+GRP4behxPz2J5U/LGR30x+XOuusuWAKk17qTIZv3svLqUg0mXVY+cqAJR9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com

On Tue, Jun 03, 2025 at 07:49:17AM +0800, Huang, Kai wrote:
>
>> 
>> Note changes to tdx_global_metadata.{hc} are auto-generated by following
>> the instructions detailed in [1], after modifying "version" to "versions"
>> in the TDX_STRUCT of tdx.py to accurately reflect that it is a collection
>> of versions.
>> 
>
>[...]
>
>> +static ssize_t version_show(struct device *dev, struct device_attribute *attr,
>> +			    char *buf)
>> +{
>> +	const struct tdx_sys_info_versions *v = &tdx_sysinfo.versions;
>> +
>> +	return sysfs_emit(buf, "%u.%u.%u\n", v->major_version,
>> +					     v->minor_version,
>> +					     v->update_version);
>> +}
>> +
>> +static DEVICE_ATTR_RO(version);
>> +
>
>Then for this attribute, I think it is better to name it 'versions' as well?

Using 'versions' for sysfs might be confusing, as it could imply multiple TDX
modules. It makes more sense to me that each module has __a version__ in the
x.y.z format.

And the convention for sysfs file names is to use 'version'. E.g.,

# find . -type f -exec grep 'version_show' {} + |wc -l
185
# find . -type f -exec grep 'versions_show' {} + |wc -l
0

Concatenating major_version/minor_version is kinda common inside the kernel,
but 'versions' is not typically used as a sysfs name.

