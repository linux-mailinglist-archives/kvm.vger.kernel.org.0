Return-Path: <kvm+bounces-53647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F3FB1515B
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB6F1542D55
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 16:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0BA22759C;
	Tue, 29 Jul 2025 16:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuW8/amf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A6F217733;
	Tue, 29 Jul 2025 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753806751; cv=fail; b=ek7Oa10DHbZiHlDT021xGhvxZjwEi6wf23FFZaTWiqSisJGCLCUZSLtTPryJUySK8gzKHJhYCCx1rz68O5d3iuVQ6s0bu2C7l9VlbAgyH/AXu+zhftzNSWjT9Hzua03Dcku+S9n6+FY++xpPhgOoin9kIjTBSQ4sn6YvAWFlVgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753806751; c=relaxed/simple;
	bh=IZPuTIEZwhBE+7GNrrAMasZddTeXHaJSN4ThoHilGqM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SRlHyOAv7i03lbLWwzNVZR0BQgxQeyaMOZNyQxAivGZ1Uk/29shUMXpdqB3zQZ1wJo4MXlX9ssnUW9DKlAxsuqFolO4qR8ESMukAuyETYJ4AZRbdYGUDGigr0LJExTu03nhwYoBrJNVVpQX/xpo6H1pn30FZZIrDLpyYrdpEbg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuW8/amf; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753806749; x=1785342749;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IZPuTIEZwhBE+7GNrrAMasZddTeXHaJSN4ThoHilGqM=;
  b=JuW8/amf+8ukBEYCvXz8MvGRZIg6xvu3wpjbj5auhunuG370xgvrxeBM
   NSpRl66Q9aLkHymoR6b9gUfnjO3HaDDycRH7MpGKS6/hpJHb6Tgn0SjQ1
   yoyRzZyza9o2oTJsiwH07NI4QvRXmewRQf1uqOiNVSChbDoJDEkNg4HFU
   tMZgIk/ClV6t+ggJFysp8e6VVuGnCUnXG8FZfuynx+5HMwadA8kfEhg2Q
   I2pABqvB+/LLCARru6WoRUAU6/xBcnQ7CcoYFL4dgdeQyYuao2UpN1gUf
   1aJvVg49cr+CxSo4Glp/jn9Wi1MWh0MJJS2YvGi9jSVwCOKpEiicg8NKy
   A==;
X-CSE-ConnectionGUID: Zx65vTYDRkuAN3CDqS3tKw==
X-CSE-MsgGUID: H8f7SBqTRS2rh2LOyyDQLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="73538534"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="73538534"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 09:32:29 -0700
X-CSE-ConnectionGUID: pUxNygS/S1ahmjL7PH+/vQ==
X-CSE-MsgGUID: Cm2zqFr2RJuJvKhhOhVVpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163527293"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 09:32:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 09:32:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 09:32:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 09:32:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGyowd0qsvr3yxJQBBXy5TSS+40sviiaE2ze06AzrT3M+GNIAY614PrEiqe1PGV6nAYA9//llXHnUdidJL4K8D6ZfRZrxLio9e5xUBb89KNlNVgcLpV5EU/uOFO2D0yyeEfFApiLpGNSsBuSvsnb8OXcfG+C9d1O6fmyxIU8CDIKjGpkFltOlZBlUEyPP38KM9kmzn+EzejOS/gZLEa7rRbDansHe+zbShqv/x4sNj+QVfWQvWEU3+UaPUWRsqBlr4zkIrvOOvVyGZCBV3trBVx9FtcfFX3CzbOWm78brCPSTRZGDkydNxxmE0epa4+IPuTM9hwLu9CqFlAm9SS3qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8va2MZ5gCtJV8zwzBulJXeFJ3MaV5VqviwluLrTL/U=;
 b=TV/7EqP67xQxS7dnxEoOFY2waIq1vr3Vs0LE8pMLTYY9WetRAMrtEUE91gNWR7jQXEhL5KTwmVGe6QUIBDpPEO4sy/u43byjkXC4nGagj2PEa1DeDZrV915jEQwz5mBO3jB6huzGTe2jkytNEDi3EEJ8r7wBsR6KG9odINCMbsjvi0e74duW3pLHGWz0T99W5Ipmr1wVwQhM1dWw56jhYn/r6fmOdvEu7MWRqWXkhdkRDuF7QfcnLiFmsyD3kiUhVFFJBeV1t1pB5b5CMJFP/n9xTZntbBjv/8JZp6fTRxwyFuUkjwpTXo60U7GF8XMfQfac4LDwl5k+yebSp/V4QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by LV1PR11MB8843.namprd11.prod.outlook.com
 (2603:10b6:408:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Tue, 29 Jul
 2025 16:32:09 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 16:32:09 +0000
Date: Tue, 29 Jul 2025 11:33:40 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
	<ira.weiny@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
References: <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
 <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
 <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MW4PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:303:b9::26) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|LV1PR11MB8843:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7c5fda-f220-4b49-7cc0-08ddcebd76da
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d3BPMDhSVTUreHNhd0hPRzNQTmFzTGo5L1laQVY0WkRZQnBidSttTXBwWWEx?=
 =?utf-8?B?d3dFU29JRWM2NzgrQmlwNUZKRWowVGRzTVdIZlNzVTJQRC9vRkxsTDV5MEpo?=
 =?utf-8?B?dmJUWkFvTnR1NTNlRW05RWZvaWhoa09jNmN2all0R1RsQ0RGTlBZdFV4Unkx?=
 =?utf-8?B?Y1hoaWY2SXMvcHhOYzVKQXRVQk84Q1B5YWNQeTkzcDdVN2Zibm15elQ4WVc4?=
 =?utf-8?B?MVBtNnJJQXExUm13T0p0M3FKa2ZraW4xaTBJSHV5N2phaTVMR1VIbFgxTWNp?=
 =?utf-8?B?c3czRWJneWsrZFdGdGxOWnN4cjArR0l1UTBudUs0NFp6RlIwQjlVNHpadElF?=
 =?utf-8?B?WDZFMVhZMkVWbXM1UCtmQzhCQzhHdXVzNmU0U0FvTnQvNnhQM0dadHY4Qk11?=
 =?utf-8?B?T2k3WWtZVEtuR21ITS81UnphcUN3L3VYb2k1UnltcFZ0NHdxV1pqVUN2R2dD?=
 =?utf-8?B?aG85bmJQOWFyV0s5c3RrSmZENkMxbXQ5QVlGejVXalpiK2thdkozMDE0SFc2?=
 =?utf-8?B?TWJBRFdDbjJEVHFmSGJ2ME5lLy9TdXlkUXROSDg1Nk50S0pOZEVRemEzeFZV?=
 =?utf-8?B?cE5tVkN1SHJnSTFkR0MxWVppeitmL29Md3FRVTRVMThESmZSTUwrQXd6RHBp?=
 =?utf-8?B?VlRJZHdEZHgvNzEydzVVQnhMbll3bFR5KzB5dzVMN2dOeEs0UmJMR0l6Z1Zu?=
 =?utf-8?B?eGV4a0ZGV01KM3FuWGZiRVNkNSt3UGUzWkZuallWMUp5cVV1enh1RnNQRjR5?=
 =?utf-8?B?eEE5S2NXSHhpU2lBVmJDS0FhOERMUmpUUTRlNldDaEN1a3lqNzRWUS92ZVlY?=
 =?utf-8?B?cTc1dXpOdmJHSGxFRU5pVUYwL1gwVk82THY5Z2RxQU11NUdZYzlMV0lUNElF?=
 =?utf-8?B?dnVLcmZSN29QOUl2UEp4ZkVpWmtaZ0F3a2hBWXVRdWdRRG9GOXZCQWs5a0Zz?=
 =?utf-8?B?VHJZUXZBODBPNGg3MlpWYm1nWlF2dFBWNjk2d1dqMm1KRmNWOFF6dldlZXlp?=
 =?utf-8?B?K244UXJ3Sy9OTHYzcjMyNEJ6bHVYdzBMZUVPUGNpL0FENnBZN1h5SjNJRnh5?=
 =?utf-8?B?c291OGJWakE4SGhPY2UrMTVpUUNJcmhhSkFSWFA4a1dkdE5zSGw1TEhURlpx?=
 =?utf-8?B?UHBkZVYzeXBxSE9OcnJRbDVYL0RJTU91UG5CRUVSdE13RzU1SFdiZ0tEWnVj?=
 =?utf-8?B?MTdSZUxOT3BQd3FPblZyVzFxTG1GNldyWjJVNFQyREw0U2Z2Ukl5eU9MRG1q?=
 =?utf-8?B?RzR6SGdORGpndjNZR1BSczFZODNPOTZtbWRXcjZua0YyMmM3VDlHN05KVUVH?=
 =?utf-8?B?a0Z5OUU3SFFDUXp0MThsaTZrQzQzSXVwUTA1a1cwdDE0THE4YVJCREcraGZD?=
 =?utf-8?B?RjBWaFNVaUZHU0hSUmRIaG05VjhWRlpOWWl6S1Jjc0VvUWtING40dTl4OEgw?=
 =?utf-8?B?cGFmejQ0RUl6bU1la2xnbnNiZ1JGU25HSEQ4dW5hanFQRUJFbXlTRksyVjhC?=
 =?utf-8?B?Q09RQWlGWDJWSS91N2dqcG1KbDhmNFZ2M1lHcWRKd25VYlpZWHVNYmhGcGZz?=
 =?utf-8?B?UERuc2VhcmYxSGYxSWdSN09KYmFxQlYwT1JUNFEwOUFzek9xMzRDVVA1Rk11?=
 =?utf-8?B?ZGMxRjVmWEtPamlYUHNsdzVXTU92T3pFeGZJeGVNUnBPTTB0cVZiYTFhUWdi?=
 =?utf-8?B?ZXprelJqd2c3dE5sYWc0dWo3NGV1UWNtMm90WTcvNnhaR3NlbzdIbk50TVlU?=
 =?utf-8?B?TDAvcVkyTkFhL09oYUxrdmdORG5vUjRPL1MrUXFnZG43UEtHdERmS3dQTlNm?=
 =?utf-8?B?bkJDenBPbWlCR1BxZ1VoN0psRWl2SytqcGxCU0lINEJ2ejVNelV5cGNjYmZD?=
 =?utf-8?B?NmFMbkRWNmZ4ekRBSzMvV1c0MkZDZ1pQOGo5NDMyNW8zVWJyRXowOEJSMmow?=
 =?utf-8?Q?KFHYJAauL/A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2hJVTd3cklxRXdJcTkrbU02Zm04Z1FtR3NRREdLbmJJTXFQdHV1Qng1Q3Zl?=
 =?utf-8?B?dmFWQzBVTHc4cW93R0pKNW4zeXV0THh1NjU4czNLc0JUa3dOVWJCK250Y3FJ?=
 =?utf-8?B?UDdUTzhmd1FFcFhmYVI3bFI2OUxRUVlvU2MxODY4elZwdkdLMTN1Q2RyOVVC?=
 =?utf-8?B?ZTRRRzVXSmc5WncyZHltb29HNTVQUTlIZC9hMmZUZk5BZUQrd0JDSjRWSWtB?=
 =?utf-8?B?anMrS2pmMTdvanVOMWhWTmJsTnlqQ2lZVWx6S1dOTGdPSXRYQUhwdWltMFZ1?=
 =?utf-8?B?SmduYmkwVmtmbkwxT1o3TzVEcmlZZmhVdFBiM3l5UGNzOGMwWXQxQU4wcmZl?=
 =?utf-8?B?clB1bGdlajkwZDJDU3NqRWZZTDQycVB4aC9FSTFQbXpDSWI5MVlwNWFMYzB4?=
 =?utf-8?B?UlJBOG9jbUQ2bkJMeTNvb2x6QWdOTGpIcUlkblg2ODZYYzFPSFlidUowMkw5?=
 =?utf-8?B?eTNnMDVsVEgra2xzV0xmRUNOQi9BeEM1OTJNNGpMTEZoU252a2taR3d5M3hl?=
 =?utf-8?B?MUh5dVc0amtCbTJPeFRIMUIwYkM5QldaNnk5TFdBRXhSWlBqMmlsQ1RTRHRT?=
 =?utf-8?B?TUlzZ1hiNkk4RUp0M09SZERLcndLNHJsVzJ0Q002cTd0RmZ5OVk3ZXlQaHJJ?=
 =?utf-8?B?U1dxaXFFT3VXZ0cvREY2Sm52d1N5SHJrY3JMdXIzTm9rbHhabjNqcHVZMU9Q?=
 =?utf-8?B?U3pVME9uZll5UUhxbUx6QjFiV2FyVVRnZitqRk1Cem9xbTlrdGJZWmlUR0sr?=
 =?utf-8?B?UFFObTBDTkgzWTdjNlZ2Y3JNNHhZaUtrN2xZZi9FN3VlRzhmdDJYc0JXSXY0?=
 =?utf-8?B?NUZpZWFDQ1djQUoyZGM0M1ZpYXZCQStKU0Q5WUlYcTE5SDNQOW5EV2I0a3o1?=
 =?utf-8?B?dWhXM3l3aTZUSDRXOFgrdzhmY3FXOWNFVVlibWpyc2ZwbnRPeTRSVU1aTXQ2?=
 =?utf-8?B?eTZZRFF3UmwwbXg0czNTU3ZzQXNHUVNnTXI5S1VMZDdMY3htdkQxcU5yc2pk?=
 =?utf-8?B?clZCVmJBbDhmVEw1TXNUblEreEtrY2xXZlJOMWNLdER3a3crOEMrcTQwYjAv?=
 =?utf-8?B?bEtEVVBnL0lPckp2dm1sTkMxcVVtY2IySjJTRjU0NTFLeVhwSnl1K0N5NnNI?=
 =?utf-8?B?LzlGNERNOXoxQzhXeFloSWw0ZmtUUkFyNzlnOXVZdHZ1OE43QW1LM1RzOTcr?=
 =?utf-8?B?c2drWnVBT1FrNWNjK28rQzV4UEIrMHNvcDc2Z2lkaCtaL3IxMXNoUStJeUl1?=
 =?utf-8?B?dlh2MkZQV0JvdUlTV2haWEg3Sm9ZUU1pOWVmaEZLakdzamRwRklhZU1WWTlK?=
 =?utf-8?B?WUcvMkw1VGMrOHpoRWRGUTdnZitUVnVZb1BlMTRWemVWQjJ0aFJ5TU5lc3hr?=
 =?utf-8?B?ZXJDRlBmYUNET2Z5RmZNS0VvSXF5NTdBSWpJajJkYXArdldrMjlqcDVOVWRJ?=
 =?utf-8?B?L1BoTnJyQkJsM1U2eXVlRFgyeG9MeUZuL1FJSHQ3TFBQVTVFNVYrRFBLMHpU?=
 =?utf-8?B?Wk82RUU1ZmVnYjVIODY5SENVLzFRN0ZMdE02MDhNQXdKQnhmdWRFc3FCRHRq?=
 =?utf-8?B?M284aUhOeEZ4Q0VXbE1LbkZUWU0rRWtuWlZFbzRISFN2bjd0VHZFVGFQOWNl?=
 =?utf-8?B?WFoxSU5CQ1BwMGFmNGdYZk02dE55bElMRnlHaU95aEp5L3pJU0ZwaXBWa09S?=
 =?utf-8?B?OEt5RGt0UjcyR0tudXFlL2NYN3dJZ3pUS1FLTWprbjIrMTVyS290bWxjenhS?=
 =?utf-8?B?TmtIVDU0cTZDczFjSzBaZ29aNjFrQnoxK3NzNkVoeGt2Z0V2SnNFaVlPc2RR?=
 =?utf-8?B?cW1IcXAycmRwdWluR1NZak8wN1FDMXBCUzdXbVdtNWJpMXFTM3B3T3J4WTJN?=
 =?utf-8?B?aytSaExPRnJ2bnV4QXNLcHA3b01renByRTUzUDVSMUZkNStpb1JSd0RYeWt6?=
 =?utf-8?B?V09WK2syYVN2Zm03S3hiejNVc29WajErRC9zS0IrVHlONXFjQks1Z0tueU9G?=
 =?utf-8?B?OVFtRGZ5UWRzcWFPYWNLWU9MT3l4djlxK1dQUEZCbjhsUTVSZ1hZMytFaE92?=
 =?utf-8?B?TCtDYzlCNEErUXk4N29DeGw2TUpMYUxzcXllOEFjZnpoV2ZoMHhIZXhZT2M5?=
 =?utf-8?B?U1lxL2o4TU1zbEhJZHVIZEM5WDF4aHBJV3EwQkRFckd2VmZVUzBXT1NIdG9C?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7c5fda-f220-4b49-7cc0-08ddcebd76da
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 16:32:09.6229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMCkQHztlkZ31D/7JwHvj4MWtRPgNNt2abCUosoYo0oB7vVJWhuT50XvZYcqg7tWLKvjZGAdkxPVDCXawC8rpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8843
X-OriginatorOrg: intel.com

Yan Zhao wrote:
> On Mon, Jul 28, 2025 at 05:45:35PM -0700, Vishal Annapurve wrote:
> > On Mon, Jul 28, 2025 at 2:49 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > On Fri, Jul 18, 2025 at 08:57:10AM -0700, Vishal Annapurve wrote:
> > > > On Fri, Jul 18, 2025 at 2:15 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >
> > > > > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > > > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > > > > > >         folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > > > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > > > > > > > GFN+1 will return is_prepared == true.
> > > > > > >
> > > > > > > I don't see any reason to try and make the current code truly work with hugepages.
> > > > > > > Unless I've misundertood where we stand, the correctness of hugepage support is
> > > > > > Hmm. I thought your stand was to address the AB-BA lock issue which will be
> > > > > > introduced by huge pages, so you moved the get_user_pages() from vendor code to
> > > > > > the common code in guest_memfd :)
> > > > > >
> > > > > > > going to depend heavily on the implementation for preparedness.  I.e. trying to
> > > > > > > make this all work with per-folio granulartiy just isn't possible, no?
> > > > > > Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
> > > > > > should return is_prepared at 4KB granularity rather than per-folio granularity.
> > > > > >
> > > > > > So, huge pages still has dependency on the implementation for preparedness.
> > > > > Looks with [3], is_prepared will not be checked in kvm_gmem_populate().
> > > > >
> > > > > > Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
> > > > > > as prerequisites for TDX huge page v2?
> > > > > So, maybe I can use [1][2][3] as the base.
> > > > >
> > > > > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > > > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > >
> > > From the PUCK, looks Sean said he'll post [1][2] for 6.18 and Michael will post
> > > [3] soon.
> > >
> > > hi, Sean, is this understanding correct?
> > >
> > > > IMO, unless there is any objection to [1], it's un-necessary to
> > > > maintain kvm_gmem_populate for any arch (even for SNP). All the
> > > > initial memory population logic needs is the stable pfn for a given
> > > > gfn, which ideally should be available using the standard mechanisms
> > > > such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> > > > already demonstrates it to be working).
> > > >
> > > > It will be hard to clean-up this logic once we have all the
> > > > architectures using this path.
> > > >
> > > > [1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=tPz=NcrQM6Dor2AYBu3jiZdo+Lg4NqAk0pUJ3w@mail.gmail.com/
> > > IIUC, the suggestion in the link is to abandon kvm_gmem_populate().
> > > For TDX, it means adopting the approach in this RFC patch, right?
> > 
> > Yes, IMO this RFC is following the right approach as posted.
> Ira has been investigating this for a while, see if he has any comment.

So far I have not seen any reason to keep kvm_gmem_populate() either.

Sean, did yall post the patch you suggested here and I missed it?

	https://lore.kernel.org/kvm/aG_pLUlHdYIZ2luh@google.com/

Ira

