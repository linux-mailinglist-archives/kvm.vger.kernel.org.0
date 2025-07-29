Return-Path: <kvm+bounces-53593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC8DB145DA
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 03:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82A523B433D
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 01:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70621F3FEC;
	Tue, 29 Jul 2025 01:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNQWp1EL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF317578;
	Tue, 29 Jul 2025 01:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753753140; cv=fail; b=U/d3T1iWTlbmfvJTFCXM+SaehAbLeVpfouXp19B3IXpkHxfIaAfn5rJt92iqDC0ZhkQgYLOKNB9QKHHU9/XeVa11aULAlZs2GzY0oP4XciBIigW+CPs+HXmg+EuSP0e15DXhexLTVBj4V/S38+qwhG4/nrgI8XlgDN2UyIe0LQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753753140; c=relaxed/simple;
	bh=JjxjU/fjsVrHqWEa6px+VTuDPoTibdDlzlqpH+EjAsg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=trKPdqdCDwuEw3pZCDwo0j9PWhy9k5JtxPsvxLnl588wtAVn7dNbEwoZPcbGuTh4cg0IjYdEIa4VlX0anjyCTiSO1OOHb7SrEyG78k5PK12aQ1iE2G+k7OlcC+/e+tnNrPr4GoNuyOwoDHTQe50fxTM9f2/PecOoeCfo1ANyhMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNQWp1EL; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753753139; x=1785289139;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=JjxjU/fjsVrHqWEa6px+VTuDPoTibdDlzlqpH+EjAsg=;
  b=BNQWp1ELmeBoR+V8iQZMaO66OTqK7KRWo/FCgrjuIHDxXnKFas21wry1
   QIxyiNxr3OTZTBUc7AVhLmpWUkrBQCyHDSgCXhnQDT619TT6urx3JLT7+
   J7hlwQ5oaKO8523a+NdFC/MqKAdzKp1rNVOHwtpI+FCN9N+iZqtM7jVaV
   /8pieOi0R+Njg21Njaa4+BTq6MVhHY1PYNLhY9HIt1+3NfvbIK/NSIFxt
   15q5Zz812htAkFFjdOwzJtVPgRWtTDyJMMl9H207cMkTdS2adR39p7SoJ
   t6bTqZlkBjseeWdTt2KDTfv8elFFJuTkD8Af8aooseEWA0Z6mL9xiRM/l
   w==;
X-CSE-ConnectionGUID: 4Rv46qEzRAygI3kl4Fl6og==
X-CSE-MsgGUID: xQ+Ryx41SkyY/sPf73abLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="43619344"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="43619344"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 18:38:45 -0700
X-CSE-ConnectionGUID: 8T8z8+74Tem72Mo4KiW0/A==
X-CSE-MsgGUID: DPjgy2jmSNuYcUyE/aC8IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="167873842"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 18:38:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 18:38:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 18:38:44 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 18:38:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=InkM/2g2Rc9rfwzhmdNOCnhtrV+/1pCUIqdu7jjkEzu0hZxvANKOQIF0YIVuEdHYe4QIhwXYHFA7L0l7AhxoiFhho7WHSKy7C7KtdelBZZdv1wwZAR3C+7kKwdDsCJgoKeCMrAoOxKAcESM2/ydNxyQoAhGBBE7XQ/sr2Sh3ZnnZ9xxY46WG1wcP1NJxMiSK0CzjhkE5+TEAtjhTdZWXX5cONeCr9EzA2Q46jHjrmu5ABOOj5XkPQMs8HAzzWPO2lCyhPMsgei2cMBfsIDgYHD0PTvEOK0t5/05qeikmFRdC3+NtI5Rko6ro6SHlCWRrRfmvMhNTgNX9e/u9jDobiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ELARVwl3ByJo3h0pjJTgpAtmacLjtR6BcxBFxBDRa6k=;
 b=PdDe+/CaExHYQ5m8Pp3wa2KIHOCufQ8poWPEuLaL/r/XcYktq7CRupJGMzPCGaxQedUsNv9NUDH0A2K+ThjIzkcctfPTZil7QCAtXABIjlWhU+Pwe7CaWxFb6WvtJeGlSGfeYFZJFv7f5dwSA63ovNkzVkGb02/R3w+JOlepdtYVbq2/JZhWnwOhtAoEyi6damhFnPboPzS1YB6pR+ZnCvqfQcjS+yJ7WZG79ybthkCFsVCtjf4w6A6H3T7Yx3gUbAHderyctVbUlvbRx9X3q48stLv3ACEJGRYtA5n5uy/7fG+rs/aalC4pSQUzFFYDw8trafQs/EVM8icrIKPZrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by LV3PR11MB8554.namprd11.prod.outlook.com (2603:10b6:408:1bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Tue, 29 Jul
 2025 01:38:26 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%3]) with mapi id 15.20.8964.025; Tue, 29 Jul 2025
 01:38:25 +0000
Date: Tue, 29 Jul 2025 09:37:50 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>, <ira.weiny@intel.com>
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
Message-ID: <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
 <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
 <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|LV3PR11MB8554:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ba38c10-f6a2-4afb-5b1d-08ddce409c8a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eXIvTVh2QjFxckdjZEFINnJweVh0KzY5NWNkcnJzL09qUGZ4aEVPemwxaUV4?=
 =?utf-8?B?Y1pXNG1jVmNpZVFlWDBVeHBRUTQ5QlNrZDk4VFBOSm80b1E2QU1aZjY0T0Iy?=
 =?utf-8?B?cWZVWURVa0pPS2kxTmhvSVJCcVNZdDZ5NFFhZnNvb1gyWTF2K1ZqRWMwR292?=
 =?utf-8?B?TmJoT1ZjZWJ6V2UyOThBbVVqbDF3R2RSNnNzdmdaaEx5SHJ3aUJXV0JtSzVV?=
 =?utf-8?B?REZnWkFMWm9qMG9NSGFTOG5Ic0JJZWtLVEhjRCtZRTIwYXpFdHBVTnlkb3RZ?=
 =?utf-8?B?bDFhQ0Y2d3NlZFJkeW41WTNHTlYydEJSNjR2czlJZkkrVnlOL3JrZENPcTF2?=
 =?utf-8?B?ZjRNREhwOC9zeUtsTjE1dzUzQjhOQ0RZKzZsVUs1elVScnRXSUNFNEVsdVRS?=
 =?utf-8?B?T2dPUVcvM0JFQ3p3R2tRZ1NOZERvMUhnVy83dmNjSm9tY2NNVGErY3RrZGV1?=
 =?utf-8?B?Um9BT2hwenRrRXBMRU5tUFF6V1JPcm1CN3p4RUhYcTR0dm92SHBhMlpzRnYr?=
 =?utf-8?B?REpkekZBN0FrOXBHNlR4WHBlQnRwV3I2KytWd0drSWpwUWZnbjVXQVhHUjk4?=
 =?utf-8?B?MjI4WnZUWHVxT2hETGFva0ZzNks5UXdLQk9KMFQvaG1QUE8wN0ZocGU1NUlR?=
 =?utf-8?B?NnB3NnRudzRkTnB1cFgrSDBNK3ZsVXdlUTJ1UFY3Um0yNFl6ZmxNY25lRDhy?=
 =?utf-8?B?RFF2a2VDYlRxc2FnRnN0bmxhc2pTRmZ2dnlTQ1FjSDlLOS9qQWdwb01zd2hl?=
 =?utf-8?B?TWI4NnpkR2NoYjVMc28vZEVmZmZCZFdBeERiRGJWeDVsbmhaVThQZG5jdElB?=
 =?utf-8?B?bEJRMUVVYm52dm55d1RiNUJNU2w3d0haSVZUdjFhUm1iQTI0clF5SUpGcGlL?=
 =?utf-8?B?MnBIdS9uSUk5NDFHMUQ0c3ZxR204Ump5b0cwekt2SWV2ZzY0QmhZSkRISUc2?=
 =?utf-8?B?WnpnY3E3MFZaRXluNlE3S2lOaEszbUNCK3gxRUl5QU5NaVBWeVByNmRCYmdZ?=
 =?utf-8?B?SHhzdmVrT2gvbm5ZazAvQzVRREI1OHdOcjFLLzlWNDZsQTU0SXpXOHlJQllP?=
 =?utf-8?B?bERjakRmQ0liWGl6eDFiNUhmN3EyekNZczZQd2IvN1BsYkxpT2tyOFgvay9y?=
 =?utf-8?B?Z015bXpvUTAzM3l0Zkh1cC9JWGtxaGVJVEN6bUt0dUZpM1ZLS25PS0JyRUUv?=
 =?utf-8?B?R3I5Um9ZbzR4OWpFZkpoOGtoNDU5YXRXd0ljMnVOdGpETk45VkZERng2VXlB?=
 =?utf-8?B?bFhxSVFnazJLVEIrNGU5TUU1UG93L2Z2dE12Y1dveHlYcWNNWTlHb3lYUTVt?=
 =?utf-8?B?RzBreWRpQzRQOW9HWVZrb0IvWDkyVmp6bGRYQXJCeW0vcGd3UkdrU1creUsz?=
 =?utf-8?B?UFI1ZEovOXJoc0dZRzM3RFlrRzYzbXNacFV3eGJyQTM5bGc3ODFJMlZucFNG?=
 =?utf-8?B?M1RqQ3ppeUhhVTZ0QmU3Z25uUHJiYk9rYlhWbVVodnB3WjEzSEZsUWh5TjJp?=
 =?utf-8?B?N1NiMC9salNQOWZ6dEVVUVY5WGhyUkZxdzBlWWpsc1ZRN1RqNkxsVGZHenB3?=
 =?utf-8?B?L0REaEN5bERVODYvb0wyZzBVay9FVHZHN2FpRzU5VjF2TEZTZEJpRzJHWTdW?=
 =?utf-8?B?SXJoZ0NoSk5neVIzNjdQQnJ0Y2M1b2cvYlNyZ3JZa3BuQU9zbWlFWmZ2T05Q?=
 =?utf-8?B?VURtaWVHYmdYNHk4bEVveXcxbHJsNWNwd0JtbU5maFI0K2NWZ0swUTB5V0J2?=
 =?utf-8?B?SGQ4Y3JQazdHTHNjYUgyRXZoTmV3YjU0ZTdhZG5rWGhMaW1UdWU0eU1xRklk?=
 =?utf-8?B?TjVsWFdWdDNtRHNyUEw3S3JabEl5VE9FZjVteGxRUHozaWxjNWwrbm9tV0dl?=
 =?utf-8?B?M3JGT0RIVkhUR2l1MmtNSXRpZDhmaVJpTi9iTDROcHZMUWJ6ODF0QWZFUStZ?=
 =?utf-8?Q?vU2rdYLgYhY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2lyQW0xVzdtUGNxWlN1bHdXQXA2cXY3YVk1N01GSGhRSVlib2N2dU05OExP?=
 =?utf-8?B?TzE2bXV2VkFVay9kYUhHWGE5Z1BBL0xsTzRWZ3ZjK1o5RWxjeFBkTWpVWUlW?=
 =?utf-8?B?L21HbTRSQVNQcklBYzR4TWwrMkFZV1hGeGE2N0VpSjBLandhSWVNYU9zcXpN?=
 =?utf-8?B?Rnk3QnR0UHdDaHJ1a2gwY0hSQTFCY0Y0UjBlZ1QyL1pCYnFVN1pQNFVZcXQx?=
 =?utf-8?B?cE1YSWk1SmJ0bmJsTkR6NkRyNWpObEY0b2c4eEZwV1EvRFFTazdoVkxPaE9N?=
 =?utf-8?B?WVpUZXR4bHBKR2x6eVgraGxHbEE1MWZ6UUtjNFR3RkFVclZpUkoycWhoMmlm?=
 =?utf-8?B?RlU4SUFkNmR3V3cxL3l1QnZpUnN0cUE0ODFvVCtTUGhFT2dTSmQvSW4xeDEv?=
 =?utf-8?B?YXdNZkVSZDVFVWUrWDVyVUs2YjZ6R3ZabTRLcW5xOVE5V0dVeUVrS1BKYUF6?=
 =?utf-8?B?U1lyZ3NLL29yOGV1c0J3TFZST3pGbks3ZzRBVmpqeDlUckZ0dHVzSE1Wb2h0?=
 =?utf-8?B?djBlNXRrMXRBRTY3V2dmbEJUQUJGQTJVcHdkWVFYYS94dEJ3NVlobHBzRXFa?=
 =?utf-8?B?cEthMUVZZVNpTlhONHpqYWhwMHdvNExyS1djQW1nYkN2V1hxWTdiZktrWEh4?=
 =?utf-8?B?SG5MRWh4ODltWE9XRnk1YUE1dDNBMDdqcWNUNnRrWkhtbnB0VjFzYkx5Vlhv?=
 =?utf-8?B?K05ORCt4NzhvMDA0QTJVQUhsTVpsN3JzRjU5Z0xrc3FMSnI4ZFhRbmZXdmlO?=
 =?utf-8?B?NDVtRWZTY1pQZlJpN2Vxait4YkFZOVhjWUxmUXZJb0hiaUdRMFVFRFg0dzBU?=
 =?utf-8?B?K1NiUHMvazVjdm5VNUlQZVJ5RDZzVU4rUnBxVXRBZDFwRUpobDdWWFVWT1Fv?=
 =?utf-8?B?a0UrcW1SZFJEQU44blJuNmxBM2tHUXpNa3hhYmkwM2FscmMzL2F6aVpLb1F6?=
 =?utf-8?B?NWE0OGs2QzV5bkdVZGYvV0k5ZFREcG5WTHp4R0oxMVRYbENkSUMzaXVONXkr?=
 =?utf-8?B?TVhob3dZejZCSjhCeENNbHhmYy9TdDhCMnRsaUtMZHlLcWorck1rbkRWUWIz?=
 =?utf-8?B?U0wrYkRaWk5ZVEszdXZFQzEzQ0NnK3dRalV4L0Fwa3lSUTNPRnhMSEF6ZDIr?=
 =?utf-8?B?RU9lUFkvV2pOZ3pMbzUzK1JIMFhXMk5ybUl0eGhIbEtBSm1WelZJWFFUdG9V?=
 =?utf-8?B?c3lMalN6c1l6YzlyL0EvdUhOc2ZsMXRDeEpLQ2w1MGtmem9yNlJvNXZSd0g3?=
 =?utf-8?B?dHRsTHlKaTNSMjF3bDJ0bUlmZkNUZ1REWXNhcFdMU2I1YmlDNFYyWmVSQWFZ?=
 =?utf-8?B?RDRFdHJYdUcrQ1haVUZXZjRKWUhyM01qVm9sYnFEY0l6R3RsNjBPeGJYODR6?=
 =?utf-8?B?TTJEM1REcGhLNzdQRjFtU3c4c1dyMVdjZUdadW90L0ZTL0g4K044SXQ1TE85?=
 =?utf-8?B?MHhzR20zaEh4SEp5a21sSWFOcysvUlQ2OU5aT0dyUW9ER0R1cS9sVXJSRlVM?=
 =?utf-8?B?RmtMZkppUVBzK2NpaEZuSUZEODc2OW1PNUxFU0VOWmVIZ3ZZV2RUeFZCbWhy?=
 =?utf-8?B?L3BISm9oMUwydHF0bkpHR3AzTG1pVkJMcmsvdC9aVVhVeW51emVEUTZoZW92?=
 =?utf-8?B?dVpZNDg5bzY4RFpOelZZWi9mcGlZQS85RU55SkpGRXozRW4xcTBQbXNRbTN2?=
 =?utf-8?B?NFlhUGc0ZlNlcGFPRnVyYThkSHdWVys2S0NEMjRCMGR4cDdiUEVta1ZNdDFV?=
 =?utf-8?B?OEFIcVM1VktVdktybFE4TXdCdzhXb21mbjJyanRxcXJuTDdLa29aRHpmZTRJ?=
 =?utf-8?B?alNtWHhIbUVrZnlSc21FUWQvNHlRbDhJSDJneVZ5NFJvYUJremR6MkxzdFBq?=
 =?utf-8?B?QUZuUDlsQXJFR0dRbzE0YUhidkVwdU9QSXNZKy9pMDBlYStsZmRRY3R5YjU0?=
 =?utf-8?B?UVBwY0UvQWxBSnAxN2svMDNibHk1NmFCbFRzaWlvM2t6VWhBaldrU3NNcjJH?=
 =?utf-8?B?dGxzdkc5N0pKQ1IzUGU5UHRYNE9YeW8yZHppTEhsVWtQYWZVdkdJWDFWTnF0?=
 =?utf-8?B?YWdMT21WbzZYVmlpRGlja1VOdm1udlFsb0RSSFdCbURleUY2NlQ5aXdvT1RT?=
 =?utf-8?Q?QdR1+Fsx4mLAsLNXkI3bGevmc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba38c10-f6a2-4afb-5b1d-08ddce409c8a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 01:38:25.8103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vlAMUwxGza155ul74YwIFzaCcYYyuhq7ADDidhi5oapFmcd5tp7xHf2OD9G5uwEdhoIwR4JgnsK61yjle0C3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8554
X-OriginatorOrg: intel.com

On Mon, Jul 28, 2025 at 05:45:35PM -0700, Vishal Annapurve wrote:
> On Mon, Jul 28, 2025 at 2:49 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Fri, Jul 18, 2025 at 08:57:10AM -0700, Vishal Annapurve wrote:
> > > On Fri, Jul 18, 2025 at 2:15 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > > > > >         folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > > > > > > GFN+1 will return is_prepared == true.
> > > > > >
> > > > > > I don't see any reason to try and make the current code truly work with hugepages.
> > > > > > Unless I've misundertood where we stand, the correctness of hugepage support is
> > > > > Hmm. I thought your stand was to address the AB-BA lock issue which will be
> > > > > introduced by huge pages, so you moved the get_user_pages() from vendor code to
> > > > > the common code in guest_memfd :)
> > > > >
> > > > > > going to depend heavily on the implementation for preparedness.  I.e. trying to
> > > > > > make this all work with per-folio granulartiy just isn't possible, no?
> > > > > Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
> > > > > should return is_prepared at 4KB granularity rather than per-folio granularity.
> > > > >
> > > > > So, huge pages still has dependency on the implementation for preparedness.
> > > > Looks with [3], is_prepared will not be checked in kvm_gmem_populate().
> > > >
> > > > > Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
> > > > > as prerequisites for TDX huge page v2?
> > > > So, maybe I can use [1][2][3] as the base.
> > > >
> > > > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> >
> > From the PUCK, looks Sean said he'll post [1][2] for 6.18 and Michael will post
> > [3] soon.
> >
> > hi, Sean, is this understanding correct?
> >
> > > IMO, unless there is any objection to [1], it's un-necessary to
> > > maintain kvm_gmem_populate for any arch (even for SNP). All the
> > > initial memory population logic needs is the stable pfn for a given
> > > gfn, which ideally should be available using the standard mechanisms
> > > such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> > > already demonstrates it to be working).
> > >
> > > It will be hard to clean-up this logic once we have all the
> > > architectures using this path.
> > >
> > > [1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=tPz=NcrQM6Dor2AYBu3jiZdo+Lg4NqAk0pUJ3w@mail.gmail.com/
> > IIUC, the suggestion in the link is to abandon kvm_gmem_populate().
> > For TDX, it means adopting the approach in this RFC patch, right?
> 
> Yes, IMO this RFC is following the right approach as posted.
Ira has been investigating this for a while, see if he has any comment.

