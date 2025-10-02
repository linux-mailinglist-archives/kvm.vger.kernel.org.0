Return-Path: <kvm+bounces-59440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3A1BB4B36
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 19:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE21E19C7D41
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 17:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085E52737E1;
	Thu,  2 Oct 2025 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/NrFgdO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735482AEE4;
	Thu,  2 Oct 2025 17:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759426300; cv=fail; b=DLXZ6uX2ge/P2jo7DImPTKMUQEjL9EA6reUbvMjO+IXraiiYFB7mO8hRc3s1/1tUC7z2gVldflOj5mF0nBxS+7u/h0skVKxokVGc/xW0cPsAcKQ/p3wGs2nobJwhhctRQnvu/hOxX2zp4w3PRNz79Tm6A7vSdz+qmvZG6dG4XTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759426300; c=relaxed/simple;
	bh=6BerUDB21qW5XZXg3BwAzyafhCYkcfujVTqUllrhuOs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=auj7JNLip4PPZX0GJjeL6lqCn3eDF6IGDTBaQz2m0l5bMuKhCfYvPatzAlqEAF4Tgp/Ut/k3TQkt1TQjdtV3CXK3XlU7tTBUWK76Dg9FdUGeGg+XHPHIQ30SfR9X0ebwqLTl2E5BBSewLGlJT04Ne1/PsUkyru4kxz84eaMR2Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/NrFgdO; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759426298; x=1790962298;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6BerUDB21qW5XZXg3BwAzyafhCYkcfujVTqUllrhuOs=;
  b=C/NrFgdOTGZ5+bgsEWMc7XD27LKzr2G9aCDrbqyGnR+a4VTcRKefqIWJ
   f/VlTd8rImzQR5Qz2JCXqVxcCd7fzJRSKWR+9nNPjsAJ/rqtzXGxk6Ap0
   ToymFISqVwE1SeAO8Ngg1NzxtflLsj9JMmHAbfq0OzSydihvf0KynKot/
   nftVUQz6VtzsA1X3y6qvIQAw+kPUWI4ow0MQMUnOVjURbeBRJiSrZ7IEx
   KqYKef299rKwCZebR1DyqNXtgj2rFu03WphXdJsK4FC0nfSFyOL4JRMn2
   heAVlX2qH7fxRSnx3oAEkyigRk+MrxXbzZHrcCDzMc/pfd73PSS2Cf4LB
   w==;
X-CSE-ConnectionGUID: +UI4RV3SRPSUjWwE2u/lPw==
X-CSE-MsgGUID: 4MpeWgIuRcmT09ZXcN4mvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11570"; a="61602764"
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="61602764"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 10:31:37 -0700
X-CSE-ConnectionGUID: aRFkWUGVRy2T+NmnmL/OTQ==
X-CSE-MsgGUID: jJ9msRMFS4mOv1R998/XEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="183496244"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 10:31:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 10:31:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 2 Oct 2025 10:31:35 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 10:31:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8sAjdMoRiwHNBhCcQqnZIX2SzY6kF96jySRA7PBI5b4coePTDDZwgSuGqWKDilSgj4ZXGhCso2dabMk6gvkRh/9NcWRXpovXq/eynQcUYEBXHHQTiB+jbUuHYbl2judO2M9YOrcmWx118cSI8RK9KtRImGUEqxitG7L+cxInCrrDZxIx9PJaTBcNwJIl1rhyLaA0KGHOLNSANNmCkCCyNKD8C56D1Y6EZWari3q4Gju+y8xBEJARXuFg7eQI6TATsWivc6sbGMot3XASsBiw5RZqADkzuf8+f2+ES9NCDDyHhAj0tRqygFdzuCAgDn6MGifcPB5i3U1HrTGgf1aHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPnrNftqEzCDt5H+O/8Vb9AASTBfX3D/mmkRUgxs7mA=;
 b=XfeGpzoDqxlZTXHjAoj9Zcfd5XzC8uFmQZiDKoQoVhVS9gAYGi67gWCUpDPcOgSh4iR6KR6MmayMF2e+UtUcb8HDzbrFdIL1q0zdYM1WWZkelChX1s3piCg+NrCv5o5qmnUaoxK/ly1udBqhVFAS0tbvBIqr17TYKEXWhn/LjX5W8cjHj48ew4AcydI89FZm4Q4uZrfNNTirThnF4pF72EoyV2FZNeN/3p4znpaPEw2KcGwDr7EJvbf042dA/jb/VWp5GSWJsMxRxl/b+QHUyPXO3LAPxvj2D3kwEDt2j3GjBpSa4PMazIQlICDu0FC66DYZN1RNZKY7JxNuHlGfqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by SJ5PPF5B09F0799.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Thu, 2 Oct
 2025 17:31:32 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Thu, 2 Oct 2025
 17:31:32 +0000
Date: Thu, 2 Oct 2025 12:33:32 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Ackerley Tng <ackerleytng@google.com>, Ira Weiny <ira.weiny@intel.com>,
	Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
Message-ID: <68deb76c2dc2a_2957e22943f@iweiny-mobl.notmuch>
References: <cover.1747264138.git.ackerleytng@google.com>
 <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com>
 <diqzbjmrt000.fsf@google.com>
 <68ddb87b16415_28f5c229470@iweiny-mobl.notmuch>
 <diqzv7kxsobo.fsf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzv7kxsobo.fsf@google.com>
X-ClientProxiedBy: MW2PR16CA0039.namprd16.prod.outlook.com
 (2603:10b6:907:1::16) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|SJ5PPF5B09F0799:EE_
X-MS-Office365-Filtering-Correlation-Id: 0269ac04-5e8e-406b-62c5-08de01d9875a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rzNLJh2RAfV/lzyiBDwvUPXrGwcn2o+kvqrqIyxYi+K9PhTlb8NWyNCK9ZK1?=
 =?us-ascii?Q?5hi3DkyUi89HNZ/TVSc8zlOFp0U7ddMYpA8eDD3exTZOzqoaEsxMdLNIpTb9?=
 =?us-ascii?Q?jS00iOjVh2dwz+2rP3s/m6nDsT025krxHLqd4MJ5NbU3spKOYgadGbADIkPO?=
 =?us-ascii?Q?MfyKaSCCkBqN5GWLOe7FQ932mCUCa5HBXilyzF1af5Di9/zBDnY6JchZ8Tou?=
 =?us-ascii?Q?CbLfBQ4koHUgvDG+nAfM5pc0y72mleRuMFbu5mmLTemjFT6Ksd0+L+M857XY?=
 =?us-ascii?Q?V9IR2BcOHyNqBvwpNYnWoQLyms5927oDyYiTJ3/YxT1yAv6E7MSHH3orF9Zx?=
 =?us-ascii?Q?LoCkfajqYmTpA6luWbrvn11EUGQ08GDNpCd4RksD7Mq7I2GPpLCyaNK1Hdjw?=
 =?us-ascii?Q?+4rxVyt6JwJXJ1GrHHB/60/XyrVH223HxH0PzO+pM8l+MUWf4s1S27P4KlHZ?=
 =?us-ascii?Q?jdIO+lY3ExMSsprEzCA4onwnoiReCXdtGnKpVym8bBvO8P4Y8U7tD5ZwUwru?=
 =?us-ascii?Q?OgkYsOXVMFckiMLypxGaTZ1wk45WmMdFX3MJVHH3YbeAc3/us6hh9adCXVET?=
 =?us-ascii?Q?2rApYLYzRxFoG0avM53NkwbZ/1T9NOCxuUkW4VTDMoDXRyxg6IqOq+C0oxfd?=
 =?us-ascii?Q?UAaZM8ymx39FAHxKKO5L4dc0u2pufa0ff3PlJhJGkLUsffLc/iWxNq5ewfRL?=
 =?us-ascii?Q?Dg95poBUbTkyCP1RhSZ+GbS/if+UhToG8J5c4ENkgkpgBJXHpVD5665vkTCC?=
 =?us-ascii?Q?tTIXwpw0FkraL+IkMuox9KSKPQAWv0xOo0/eKpubfftIzE/d7SOjIRGnuU2D?=
 =?us-ascii?Q?DURPSQpq+umAidCFfIkJGwf7J3FieXRR3xBKcyJBMBEshAgDHb+iqh3IEh6J?=
 =?us-ascii?Q?WUOLw0XZ82ziyBAYFVPn6Y/Gmqz38gl94pq3HC9tadunryhr8HqZRNNZtpe0?=
 =?us-ascii?Q?e+UhlkwrMSi7b1Mmi/Kpy9Fi9FSBkC2vijA8Gx3VKFmWnESbcNALyhAHWJlm?=
 =?us-ascii?Q?aqcgkXTOpVWiVAmula1W+1VCEaFaE66NoJbzgyQTH9roF6dNkbEUxHugTPS3?=
 =?us-ascii?Q?xRNi8RSev2P6RUSKbD1Z0Hp8lflcw5LXr5XRHHmnpI1VoaIxAPOqPmFdH0C1?=
 =?us-ascii?Q?PJiV0iPFgDgThFZ4fvwZv4A6c3KNk54ipC6XDhT6MGNsZy0VcE7NJKDYSC+c?=
 =?us-ascii?Q?z48UWTxO1N1a9xdFctfL8xN0GBxCI5ebBANhribHuz0jW756IAiojV1kAIM7?=
 =?us-ascii?Q?W2DZPWvwsh0YTXXHD1bt0rEiLa+GrtoCV7zcTLa1KHGmshZfxxvpKrJBw2dC?=
 =?us-ascii?Q?Vu1Zmqk6K+p0OixqEgtD+Z/o5RGcyFy5kN3QL9rk0oWTU8hWBxNMjjFAGqHQ?=
 =?us-ascii?Q?fDOlj3syajwQxrexc3CAAWCAX5U0GHu45PxPjQsIa7NiWqoKfgTtibDTVCtK?=
 =?us-ascii?Q?H98UhTzB/g4MrwHWPgzzx+ffmIBqMQwt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GJAv5p9rWNTe2Zez4K21C+O2AmQm1ghZIkzoE/PhTHsgtuDZnu1w7rAEBci2?=
 =?us-ascii?Q?OftL2hMQOZyAKY2A5vYcSdIE9iVFj0hpRO5HPw2sL9M4datmJxFGn4ZQR/Vd?=
 =?us-ascii?Q?C83PyvBLyNRaeNvbvAu8oEuBrc8lvzxxDOw7m8isPKGRk9AE0gxOYeKPZVbn?=
 =?us-ascii?Q?3HHQ4AxsdOVgS5V8jG0S5DMWdJuQos2y8qcFINgyu6uFz9mZ7RtSUtmtuyNS?=
 =?us-ascii?Q?VmnEAaptRvURqjHYZ/yBCdsHHiE1/t4kmzgtkm5D7rqh7neRwFEejlD5V1B/?=
 =?us-ascii?Q?ZvwlG97iK1Ah4RIAhiSWPu4Px5rhnXZi1MoiyjVkdElv0UGNnwOOIfoTqami?=
 =?us-ascii?Q?zh+LILAh9CJpHDr4Kg+8/c2T99YU0SHGGA44IOLTK/LRxgZDrhINN/r2bKb5?=
 =?us-ascii?Q?O1zQUvApzwAZ+HicpJ6Wg3sxyrIlNVfXNj/G+oU2TmeaURWa5G15mywcvZP0?=
 =?us-ascii?Q?hmnRu7lTAas1oPjM0Xsggyu9vSBseq4Ud4nfUJsDBjBazS6957tROSZMUBwK?=
 =?us-ascii?Q?Zqt5+WI28kuvloeaRmbSpfDIOroH1M/7rkK9TM9ncEvwbjwnACAAn+XBHOHO?=
 =?us-ascii?Q?ATX2fEIq/oG3KOrqDNCSN5Nl9fXnRoM3M3xPFa4dMQ01tNpiJtJvRGTRqRAm?=
 =?us-ascii?Q?AC85nx9nOhY90iX7+3BHHPWPPPInGzF5/pVvgpat1ukVX/hiP5BcJX1AGIPz?=
 =?us-ascii?Q?B6wYAAy9uJw5OjJWWngMrsKxh42q3f4HEZ2aKtsmtk5wRI13lkLl1fze4emu?=
 =?us-ascii?Q?sVYK3wNu+ncGkjOKK02Nr5Sk22B8dgGjVGdnqGDRNETVy2L5ZxdG6POxwCJ6?=
 =?us-ascii?Q?NMb1tQ4C6rp/x6+MFRPnH+02M1QAu8im2EIP2L/jCh82Lq3+B7nZAEAsyRJ8?=
 =?us-ascii?Q?sF45Ph0C9eOco3cBRX2SpZQEccWPKZ9RSIF/coS9lienzbsxMFmH/wU6l8TZ?=
 =?us-ascii?Q?vvYkYww//07I7RjWJ5pnpGSgEIZPTdBR5/PW9iM35rN8ASmc5ksfdALat31A?=
 =?us-ascii?Q?eqUTgUGo2z96sKWbvaYJ0Bcw9pQfIp8zZCYeNd8ITnhu/5MscKeEyvCUdOy4?=
 =?us-ascii?Q?CP0/h8dNwFvhIJviThZaaYH+2mQftEWsFhIxAcbAcsRoKKpc2OZ4iF6yhwx1?=
 =?us-ascii?Q?AGRzu58mQmOWZBiJPRVWI/l5m7ZmijiJ7rJZDOYvHbxthaQhdWZNBk93wyUn?=
 =?us-ascii?Q?tfZf4wDzmRdwVByLgNuxEpyHCr7BgAdD4lRM8pi+1rqg5whj9jmd+cQ6qaIc?=
 =?us-ascii?Q?1S7cRSBAsL4EIIrF+u8sz7SDSTpAN3n0CjUNmHKh+GqS5x6tFIKcCPDkD6dp?=
 =?us-ascii?Q?LpHmdLjp9t71nr9RmYIrMFjkIWGZ3NaGYOkhCQ/mnaUXLHAcRLIUpQlOzyhC?=
 =?us-ascii?Q?+VFM7Aana8U0UT0tvpDGyJPrJR2cMUhv2sd2yWrspnpnfdmeWLkciR6wL4UT?=
 =?us-ascii?Q?LOPcDHxVykMyc2gcPL8Ljq+/K4Kmr1DCJ04J2/8+IqyGPLQj5eY42JSlKM5f?=
 =?us-ascii?Q?pz7eeEzc6qGyu0pyLW6LSAacv78hGo5Dy3nqMkf34/wKo5SSHOd5h4IglOJP?=
 =?us-ascii?Q?U6fbfuYhwipZHB5J0gyp5dgAI6kkcIlck9YhhgLN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0269ac04-5e8e-406b-62c5-08de01d9875a
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 17:31:32.6175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDtcSfbkZ6M5ahDYgE15zGZhLT8sfkkmjkO81WvR7o4/l0g36oJERTMZkxToJOZGB7YJLYpd7CP7w6gzH8/dtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5B09F0799
X-OriginatorOrg: intel.com

Ackerley Tng wrote:
> Ira Weiny <ira.weiny@intel.com> writes:
> 
> > Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >
> > [snip]
> >

[snip]

> >> 
> >> I'd prefer not to have the module param choose between the use of
> >> mem_attr_array and guest_memfd conversion in case we need both
> >> mem_attr_array to support other stuff in future while supporting
> >> conversions.
> >
> > I'm getting pretty confused on how userspace is going to know which ioctl
> > to use VM vs gmem.
> >
> 
> It is confusing, yes!
> 
> > I was starting to question if going through the VM ioctl should actually
> > change the guest_memfd flags (shareability).
> >
> 
> At one of the guest_memfd biweeklies, we came to the conclusion that we
> should have a per-VM KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING, which will
> disable the use of just KVM_MEMORY_ATTRIBUTE_PRIVATE for the
> KVM_SET_MEMORY_ATTRIBUTES ioctl, and
> KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING is the only way to enable
> conversions for a guest_memfd with mmap() support.
> 
> IOW, KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING makes userspace choose
> either
> 
> + Using guest_memfd for private memory and some other memory
>   (e.g. anonymous memory) for shared memory (aka legacy dual backing)
>     + And using KVM_SET_MEMORY_ATTRIBUTES VM ioctl for conversions
>     + And using mem_attr_array to track shared/private status
> 
> + Using guest_memfd for both private and shared memory (aka single backing)
>     + And using the guest_memfd ioctl for conversions
>     + And using guest_memfd shareability to track shared/private status
>     
> Since userspace has to choose one of the above, there's no point in the
> VM ioctl affecting shareability.
> 
> Sean's suggestion of a module param moves this choice from VM-level to
> KVM/host-level.

Ok I remember this discussion but I was not clear on the mechanics.  This
helps clarify things thanks!

> 
> > In a prototype I'm playing with shareability has become a bit field which
> > I think aligns with the idea of expanding the memory attributes.
> 
> I guess this is tangentially related and could do with some profiling,
> but we should be careful about adding too many states in the maple tree.
> 
> Conversion iterates over offset ranges in the maple tree, and iteration
> is faster if there are fewer nodes in the maple tree.
> 
> If we just have two states (shared/private) in the maple tree, each node
> is either all private or all shared.
> 
> If we have more states, private ranges might get fragmented based on the
> orthogonal bits, e.g. RWX, which could then impact conversion
> performance.

I'm thinking along these same lines yea.

> 
> > But I've
> > had some issues with the TDX tests in trying to decipher when to call
> > vm_set_memory_attributes() vs guest_memfd_convert_private().
> >
> 
> Hope the above explanation helps!
> 
> + Legacy dual backing: vm_set_memory_attributes()
> + Single backing: guest_memfd_convert_private()
> 
> I don't think this will change much even with the module param, since
> userspace will still need to know whether to pass in a vm fd or a
> guest_memfd fd.
> 
> Or maybe vm_set_memory_attributes() can take a vm fd, then query module
> params and then figure out if it should pass vm or guest_mefd fds?

For the tests that might help for sure.

Generally I'm hesitant to introduce module parameters as they are pretty
big hammers to change behavior.  But if it makes things easier and is
acceptable then I'm not going to complain...

> 
> >> 
> >> [...snip...]
> >> 
> >> >>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >> >>  				    pgoff_t index, struct folio *folio)
> >> >>  {
> >> >> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> >> >>  
> >> >>  	filemap_invalidate_lock_shared(inode->i_mapping);
> >> >>  
> >> >> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >> >> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
> >> >
> >> > I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
> >> > underlying memory from being converted from shared=>private after checking that
> >> > the page is SHARED.
> >> >
> >> 
> >> Conversions take the filemap_invalidate_lock() too, along with
> >> allocations, truncations.
> >> 
> >> Because the filemap_invalidate_lock() might be reused for other
> >> fs-specific operations, I didn't do the mt_set_external_lock() thing to
> >> lock at a low level to avoid nested locking or special maple tree code
> >> to avoid taking the lock on other paths.
> >
> > I don't think using the filemap_invalidate_lock() is going to work well
> > here.  I've had some hangs on it in my testing and experiments.  I think
> > it is better to specifically lock the state tracking itself.  I believe
> > Michael mentioned this as well in a previous thread.
> 
> Definitely took the big hammer lock for a start and might be optimizable.
> 
> Considerations so far: when a conversion is happening, these have to be
> locked out:
> 
> + Conversions from competing threads

Agreed.  And this needs filemap_invalidate_lock() as well as the maple
tree lock.

Call this item 1.

> + Allocations in kvm_gmem_fault_user_mapping(), because whether an
>   offset can be faulted depends on the outcome of conversion

Agreed.  And this needs filemap_invalidate_lock() as well as the maple
tree lock.

Call this item 2.

> + Allocations (fallocate() or kvm_gmem_get_pfn()) and truncations,
>   because conversions (for now) involves removing a folio from the
>   filemap, restructuring, then restoring to the filemap, and
>     + Allocations should reuse a folio that was already in the filemap
>     + Truncations remove a folio, and should not skip removal of a folio
>       because it was taken out just for conversion

I don't think this is required...

> + memory failure handling, where we don't remove folios from the
>   filemap, but we might restructure, to split huge folios to just unmap
>   pages with failed memory

... nor this.  These don't change the sharability maple tree.

These operations don't change or need to know the shareability AFAICT.

Merging a folio would have to check the maple tree to ensure we don't
merge incompatible folios...  But that is a read check and should be easy
to add.

> I think essentially because conversion involves restructuring, and
> restructuring involves filemap operations and other filemap operations
> have to wait, conversion also takes the filemap_invalidate_lock() that
> filemap operations use.

I could be convinced otherwise but I'm thinking the overhead of another
lock for the sake of simplicity is a good trade off.  I don't think any of
the conversions are a fast path operation are they?

Ira

[snip]

