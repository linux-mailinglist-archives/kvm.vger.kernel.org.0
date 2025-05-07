Return-Path: <kvm+bounces-45675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E4FAAD27F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3307F3B9CF6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D6C824A3;
	Wed,  7 May 2025 01:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbNQIzZI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D9CC2FA;
	Wed,  7 May 2025 01:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746579849; cv=fail; b=ISK8E3uwtBejKawPfX8xwYayrAQCg/G8nOlGqawphl+in3UtvqnIY+1m+XjUGiQdoHfLn0dndI5zC7Ly3pVd8anXHTZS+At4z588RO2Ixdi+7EcV74IZzSeC3UTnAcfbA4vNO2TIJ9sE5u322JbbYkvDegtv8y5uTjBL5+7Q3j8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746579849; c=relaxed/simple;
	bh=dvVBCmpQZwuB3ntjEtAN4HlOwpwrJNvYEXF27gCKCKI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NSae3mjgUkAn89Y4Ad9yCgrqZ1soMyBjetb1chbqIfYEqhsOC76ueebe9ZToBn/YjRm+1fnnOQzyhjjQlnE4diMgIUtA7CUNq7F6vvS8zwtB4m9rxEBzI8dBUJCFiyXueGHc1niiVyGd4JV/EuAuOwc/q/63XdsXjWI4HHdKVME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VbNQIzZI; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746579848; x=1778115848;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dvVBCmpQZwuB3ntjEtAN4HlOwpwrJNvYEXF27gCKCKI=;
  b=VbNQIzZI52KkX/CNvEGZJd1MA3grl8B3U3hqrMZ/xn9uQVkyYnjnZBQc
   H3P5yffYWRnc3Whk64zTZ6yLeqepzV8bh0TB6gtHyRnZdh1giLG2bw/AC
   J0MImFqVKoUQrm22qyqHSQYSbW0vkqLCDs9TFybNfjI0S6ITJkEFbsuEz
   PnUocVl2T/mTXJMVKDmxVyDveMXrJY9KzGyd3hpGldF5od3ip29RVJF2l
   Z+CPkSZo36T7evuxgj7EhZuWHCqU2H+SVhO9R7oH+JYLFk87n+7N84a78
   T4xL8x8fUjCF4pqs2MSLusy+PKj/crjlZdAdL/HWQY2im7zWbQWryBqkr
   w==;
X-CSE-ConnectionGUID: A9/3XNG1SxmR5hAXJBcGvA==
X-CSE-MsgGUID: Xq3RadDWSvanxMY2zv7Dqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47988269"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47988269"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:04:07 -0700
X-CSE-ConnectionGUID: 47fLrhh/RBqhskqlK78q0A==
X-CSE-MsgGUID: t6BRsikgSRWn6PA1bElS9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,267,1739865600"; 
   d="scan'208";a="135683585"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:04:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 6 May 2025 18:04:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 6 May 2025 18:04:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 6 May 2025 18:04:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBTQFY70avEm/EqphB2TPfto5da4273GTl4QBw7QQstFq+WXr3hnAWmFMrib4rr0x4qlJA7YxGkFVOtbzKaLTofCB5TzjtqiezRdki1+NAzwBxNO9zwCO0AaO90vX2Uix5akU+mH4Ust2uTiiLQdW3X4ZS8p3dTGbnIQd/OcthJIJIS8yW/gozrtSy+LS+icV9U3acLE55ch552dEBHsHOEv8f7YGM2UIeIme/blczmub1d4hXFJ/tu2jleHTtfiJPdgIeZi0HOtsKQ5duwNCh8ecg1A1ZCFqZZ5yqkzGam2N+mCh1wIZ/IDDeNvWR3q3bBDO9F2if20rBjq9Puvsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TOziXu55XYLWpTYZtH7nnsUBt3KqqYEXROh7jXbzi8=;
 b=kRjev4AVw+4IFCj3QQYzyBaNANCZbfrOrWcbQv5taOTgJSTpJIuyl8OzJMMHK9bLB3ai7EKLq1lsHtto6f6EjNMn3K7aFDhz+OxC+hdytKJ0XUyz4GonAYKCNo95En3TKqMnMvNKVq+lx5iBJvSP0gv5hjhi6F0ergSTkOksWSkFYatuLOJR1TxtGSce2Dovk6xRhaJAGIyaSeXreVIR4aCs+v2i6XnYHmDtUf/qIoRJUDQlZsTw6tHKkz5utDakLNS94WoN2XDcUl/mlWZat+isIrsFcITn75CWVkiRHLBObU+zYYSIEKDXre+P9xNOjqEjRphdki8OhangikD2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7020.namprd11.prod.outlook.com (2603:10b6:806:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 01:04:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8699.024; Wed, 7 May 2025
 01:03:59 +0000
Date: Wed, 7 May 2025 09:01:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <aBqxBmHtpSipnULS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0048.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: 57d6262c-3951-435d-c7ee-08dd8d030cd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pzT1iU2xtqRhIWDX+8a2403p3XwjHMbbZ5c/ui6v9Rd2UUkLh6NCPKSzG0E5?=
 =?us-ascii?Q?lELWc3fOcf5NpQE0tHg1cjSeODL01pbA05UjROAMXfMh2BvrBi+plMmF17JB?=
 =?us-ascii?Q?eUb0KrCmSsjQf0Of0Jp0NDupylQq9AVQVZhvSjh05QojvNLL9UBrlMmYNhvJ?=
 =?us-ascii?Q?KMIvWsY80x+WCVeqA+3lcGmE2QK52qS58WWfHmv+I3Ges6i8tyHlf3Nle7XZ?=
 =?us-ascii?Q?E6OeqkXCtQrljLgdEHxuwXnBepN1yKS/QhJIV4DZt1Thk329kYMfrJK/NXuB?=
 =?us-ascii?Q?8tOLAKEpo5S5YWUItRkzCxaSEfJ3+I2+s+Q2AwaqYIbRXCFt1ZgAE/shWUQ8?=
 =?us-ascii?Q?Zl/cEnd5JIaR//kE5DCEejJ2THB2wUNDQfnJe5ZhqN7qu1BylJIW2Zr1IBnn?=
 =?us-ascii?Q?dRcHq7th/L43ys7J5QEv2tjvoCcpww7dQvxcgZMUc9kONhnVhPw0CqSwTIfZ?=
 =?us-ascii?Q?eMk0drS+lCAruzxk4nmSrRw83rO8ZwxppBn+PL3ZAA1GOChbrz4mN42V3Niq?=
 =?us-ascii?Q?o2RPBsBiZfnSdkwWU1xfJLwqZiAZP9XpQJLHOo9eBzIh6nbT2QUW0oKDGJqx?=
 =?us-ascii?Q?3fJrm5FrF463e1oUk+1gYGJvZBoYPSTsdwJEAXYk2ZiPyhEuMpKQgzeuleik?=
 =?us-ascii?Q?et01CMneiEJQfbYqY+2nBGpn4x+ea5p6R2ggyiGtm+bSW6xHRsFDXMEfPl+J?=
 =?us-ascii?Q?CsA67qTzkITr34WfZ5o/oUGHadAqCjcvGSxso+QUFzGkpu7hDGY5vrvRu7qu?=
 =?us-ascii?Q?72WiF6MjFiVSt5Ogpm9UqGLQaLBCOJMfHgXxL+fr+erw3L4BfyGo+lxA8Lar?=
 =?us-ascii?Q?nuTf8hxutptrtisy3uiRTspWuSzkVCCPQ5jaPbIzJPTRgPSO2XKVHel9FFXd?=
 =?us-ascii?Q?RdaT1lg+4QS0Y1ook3Wk5Ms5YlxSIg1XUuo61DnistiVyLECGVN2YSy+u+Vq?=
 =?us-ascii?Q?pjUt0jv9d2AIlu40LvtlELnI9qRYDNgrreUMBjnacY79IuMc2Owh57PBJpRm?=
 =?us-ascii?Q?lB+nTOqDiS8XMXDEqjYZXEkYpLS20sTu2y3HTmfmufeNjEbmLyit8uRJAhp5?=
 =?us-ascii?Q?EYtkRaa5lVvY9VzlTEzJgJQ2esImN5RuCoXD83BXwdcorhuJKbBHqUX+2Qse?=
 =?us-ascii?Q?BdQDyPqV0GU6FWMtPigFR0j9rjgv9zvupXt8iaFf2swcHzqdcHOCKP0OKuFg?=
 =?us-ascii?Q?qbbVjVjLKQ753x3mHVZfsdEHMaIXCm82fpgUbC0tzW8YhKcqidLaEcpBn79a?=
 =?us-ascii?Q?QPE0Xn+xjXEnJ2kn26xOLlhy/FcMZG4dWqUcsIyBntlY3YRdcw7QsHQjZoze?=
 =?us-ascii?Q?V7UgPD08pMibE4cHOAn9ehNLFtwKs3RDlGFMgLcvTiHsFkugBdNGz6fycuOp?=
 =?us-ascii?Q?/Aox6kAXwstTQ6tzL9/BAC1G68X49YJ20xHPzRrXg5ymUAV/bLxuwhd5brIR?=
 =?us-ascii?Q?eCFu/ngGaFs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V2/jX8rzar2GUKtyALj+7uYu4GS5LAfIOWjhWPlQxdwPXfr4uSvJdZKoUDul?=
 =?us-ascii?Q?kdXFwi4+4aVQZ9k0Tsyt7Hyoh/UPRn2BeTh9Y0YXj5iBs5tlr0vG1oWVVkHt?=
 =?us-ascii?Q?E+2SR6fB+IdmsfRMkte6QDleolomzV3NhHRFV4qESTuz8lqsQ3HGYLHwfvLF?=
 =?us-ascii?Q?x+s6vA3ar2/VObUh8UvNSn8ZBhMbNgUa2TIgpkKcV3em2FXbhDq/zai5orrL?=
 =?us-ascii?Q?v/tZTsU4BAiCIpjO3cd+K8oMaYO6xwFr/tsL9qoT2Oh0IGd8mP70hgtS1dP7?=
 =?us-ascii?Q?gdig3+AJ/jCdxYuLUVxnH7wF3gJObI6Z1BJ+qcSEyObV8cBVuT1Q2ipSursy?=
 =?us-ascii?Q?p+AACTYoD/Z2JVq6erRUkIidzsM1BwKqlA+N/gLeSAUx7rKIJtJIbfQLmGS8?=
 =?us-ascii?Q?6PiWlTVWG2EAr4rs1thzSUBG+fzzvKsAyNnMGyf0715KOTCncpp7mmuSrF9U?=
 =?us-ascii?Q?96FrZoYq5gz9bgf7cGwVkcA8uiJ7Prm54rBz1GZXgTEXZU5eii/Yuth6/Crb?=
 =?us-ascii?Q?0ouogLbrKdgBhBOYYP7VZYx5UXEx1YLY17ztshpLaOy/nr6v8V+Z/StLmaRo?=
 =?us-ascii?Q?1SyVRzqFrOPI90hRvZxZwJBzKToELqbMBZQXpr+OoZ4vJWb0NinjX+bHk3RH?=
 =?us-ascii?Q?To6qVB0y5+NCo6wHHKgN/24veNdJ3e0SIDcoSAtFvd56gBaXXPZ0aoVJj/M3?=
 =?us-ascii?Q?gJOS8ZG/Fl1quyAdliMj6J36x91v6fDxmQDoo7SdSubt+NJXVosVNczGfJpV?=
 =?us-ascii?Q?JkevUF/uyoLy8QAXBl2SU3cs+OX5AyPxtarhii6tgx0nHJLQxLrVx2V5OSD9?=
 =?us-ascii?Q?1g+Atv9Hn5tWJoFvijFezG8oUOercD4dOHwD16/tmLzOlBs4CB6iCBFaE0/2?=
 =?us-ascii?Q?nzFox96y6uB0egrxKyEDj7jzch/exfR2MqBUd7AWqA3ZKn62VvELDDphWbl/?=
 =?us-ascii?Q?DmrEPJCmh9R/3h66/Z3l7BFgNsB/DfjzhiSEzMfcs0kUTtI4bqZmxX2OOF8E?=
 =?us-ascii?Q?LgdpW6806I9g77PTBAn7eNDF6FZ7sGG4J/M9Dxji/QhB43EdaILPlU8vBdiw?=
 =?us-ascii?Q?CfHG8yRv6uE9tEUkZch7Deo9NAVm2Yelmp5zOT+Uc7IS/Qez1Vb3DoS4PFHL?=
 =?us-ascii?Q?V3hrLJSf+/I8REamVNnk9wKHCRV0KRDU++ggbhotROUFFrKWhbQhNia0978Z?=
 =?us-ascii?Q?o86e/2QK3HHqTTWTopQM/xo9Of4ciF/sCiiGRmJ7pav0r531lYQbSx+5KA54?=
 =?us-ascii?Q?grpYqH6gy1159KLGpLDxDBaQp8n4ytXRKfzdJKD7RmDg5h1hYv0+D+I0sV9y?=
 =?us-ascii?Q?DUisfBq0nlzcgpmOyHtu5Kkia8oRWumr5/oUeH84GRebFJDKcGfx631NDAVF?=
 =?us-ascii?Q?+Z/1Mh5tQGQtByez+2j0S2R7/hgQHbyObrTDKoDLJ7jbBMr5hk0TG97pRx52?=
 =?us-ascii?Q?z3sQMUnJeqLDx3iqfMurnO/IZ2gJ5AK3V9Db7YhykFsIZ08mIImDSQGIj2MD?=
 =?us-ascii?Q?wlcN+ThEZNiGqmVjVcsnGJtO8yG3sKUyCXWEvsvPdYT50Ub43Nw/FrD6oJqJ?=
 =?us-ascii?Q?G2PsfI5Xes5/gdS/Q5EtdDlxBLuDtKDTfPetN8Y6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d6262c-3951-435d-c7ee-08dd8d030cd9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 01:03:59.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edQwjl8yzjxYjyjBvjYaZAB6ZUuZr+jfGEn43/eW0MikqvbVE2o4OIuMi8t4mSTAqVnyHm5NJ/AMGK/dAcDdlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7020
X-OriginatorOrg: intel.com

On Mon, May 05, 2025 at 08:44:26PM +0800, Huang, Kai wrote:
> On Fri, 2025-05-02 at 16:08 +0300, Kirill A. Shutemov wrote:
> > +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > +			struct list_head *pamt_pages)
> > +{
> > +	u64 err;
> > +
> > +	hpa = ALIGN_DOWN(hpa, SZ_2M);
> > +
> > +	spin_lock(&pamt_lock);
> 
> Just curious, Can the lock be per-2M-range?
Me too.
Could we introduce smaller locks each covering a 2M range?

And could we deposit 2 pamt pages per-2M hpa range no matter if it's finally
mapped as a huge page or not?

