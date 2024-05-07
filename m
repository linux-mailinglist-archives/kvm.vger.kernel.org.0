Return-Path: <kvm+bounces-16936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F9438BEF5D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 00:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 644181F24ADA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 22:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D6C14B974;
	Tue,  7 May 2024 22:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="THooDmEp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F9C79CF;
	Tue,  7 May 2024 21:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715119202; cv=fail; b=jMPojX2kf985ChWNqRWVNhw63znO3KNkNdVPugdTitsdAZzy4DQ0/VpiJIwEIoyc46U0xAlyGTmnu2ghDQwcAP10oul2S46ivrymJ1uJHYzC9Aih/KFCBQ005em0/5738UpWdraN99DwxRPQkaPqTXGB8KQOI+9LT/yHpnRubKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715119202; c=relaxed/simple;
	bh=9H1jLtKHtI2b5aPtlVWurL66LyXD4H74WSUu/VZr7aM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YzWwA0Hze5i6sTX1MxShiaBux5zWQndHvwz3+FvrtMMimsfNGf6ltV1JI6CTOwl6jgxdPzheKsvqUHOknjCV9JCyYdIEgmNjqE13JBMSDSaR0HCd6sqk90qxZrllgQ90oC4ojKPwMalTFuRvM13I24zxg2btYOAWDk7sC6z6RJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=THooDmEp; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715119201; x=1746655201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9H1jLtKHtI2b5aPtlVWurL66LyXD4H74WSUu/VZr7aM=;
  b=THooDmEpG1vkGbvKFaBqMy48Vl6KkPKy93YqnFJ8BZ6OmXtaNm2Kfy75
   L4mi2/eAy+3HecjlxpH7vHUqOhxaNEUzjawklPE+atyVqv0xDlF2WDR/R
   XOiKY7mu2t4aAIcvqW/UyG79vbp8kFrW4I1E+D+uILrDC8wV56wd7FxRh
   fYDlUV6OME39nHzUnH/CtIAfKH73bymReweOXF0aFKcM99lIETtKvczqq
   nJtPnotKzKFl6DHJeK+sdKQIQ7af5+QbXT8nK49WPOphhX87QY1yOWs6i
   YnUSLAfHFH09xJOgK2tOmLW/PIPK2fi35ltD1EDZ70ZUUtA/Zg9i2pnwi
   A==;
X-CSE-ConnectionGUID: n09e35YtTmu6IgZGkwF64g==
X-CSE-MsgGUID: qSXEkqFYQ++4KCXS2GbXfA==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="21553092"
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="21553092"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 15:00:00 -0700
X-CSE-ConnectionGUID: DavRqBBWSzWASEI0dAzkzg==
X-CSE-MsgGUID: +R3SvI4MQEem0QG44MDR/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,143,1712646000"; 
   d="scan'208";a="33359556"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 14:59:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 14:59:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 14:59:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 14:59:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHg4MeQAhT5vLi6pmLW2uYmhlk0CgbWJgKT9Rz3eJTx1epNg9IPHFq462znmIxoFq8ZDhDUU+ACLYnDRH9qunQiMkcDEbI/w3J7lgRdcOgp88H0kRad6T+EAq0NPF7PO7nnkXq1+U0mV29m966ZN/AFbZaLxa0CeBmQaC5NL1cuVqTA9Iye9xqJN+OYiTZJf4U88Y++TE1PkRfAFnkOotCZemE6duhK4vKfTztEm4k4GPsex4g8oJK2bXj9LeNMt+276K9QVPpvEBrGymCP/D1uwKeWo5VHDKKmA6WDvrk7AsGAMDaZ18iR3kl6yvkd7XTfnNb0bLEFpvAVeXwTZgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFujVpEQmkfMYYJ3dOSPPwm2G9r5q6jBMDBe1zA3zZM=;
 b=fMzLOeEJ0nlzkVoAOAR+dDdEdMAJqW2+7B3CdxdInbosquQmTfi+oMl7ImT6R4K31mdS9ZjKJNUQjFBsr0cJKlSKYttt4ZBYJ4WI51PEkUg8TAQ/fyw4ddzcYNd6S2J2stms8UXZpBnNWEIUMClqnoOMeBZg7I3Yr7LvfwwvmQk1J7D342vz/nUasxIxX6ZIAoGpXL5RXsrrZruS61/9r8BZ/z2MyNUtuugU64/kTCT0ru31udw/G5mKv89i0lNaExUH3A0y1jkr5Kuvb4j/NF8PwuiQ08gMxflO6yg/GxzIuF5sK7NRJVRK5PjxqMwOvQHPHctcS7QLP8PQVJWV1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8763.namprd11.prod.outlook.com (2603:10b6:8:1bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Tue, 7 May
 2024 21:59:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 21:59:55 +0000
Message-ID: <a2f7b0d6-97d8-4093-be93-6e9d3e0e0597@intel.com>
Date: Wed, 8 May 2024 09:59:46 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <Zh7KrSwJXu-odQpN@google.com>
 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com>
 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com>
 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
 <ZiEulnEr4TiYQxsB@google.com>
 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
 <ZiKoqMk-wZKdiar9@google.com>
 <0ddb198c9a8ae72519c3f7847089d84a8de4821f.camel@intel.com>
 <ZjpVslp5M0JJbPrB@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZjpVslp5M0JJbPrB@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0262.namprd03.prod.outlook.com
 (2603:10b6:303:b4::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: f7fb06a8-805c-45f7-089e-08dc6ee1076d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NmFYTmRUTGJKSnp3MHYzMzBFb2YxM1NwMGpiUW94dzVrV0V6N1cyM1MwQUc1?=
 =?utf-8?B?c2RxWVVYVGdtRVdvOGMzWTJhalgwQy9xSWdUeEJibEdKeEdEeXJKRzJwajJC?=
 =?utf-8?B?QkFHZXErMHVwYThRNjVaRDQ1Um9FdklGaVBJeXdsV0szMStMclE4VUN3b1hY?=
 =?utf-8?B?MjY0akpXSDI4cUpLWkdCSWs4dklUZHJ5bEZjU0hqZHJ5dkJZYXU1SzNPaFFE?=
 =?utf-8?B?ajRER0orS2p1VGg5WE5iWDJ3cnhmaDBjaXNxcEtLeE8rR0RTOEd1VHBUTlJG?=
 =?utf-8?B?dzlkZEtJZHZrTWw2SjZKL2VCbjhrSTlGVFpBSGlyd3hEY21YTnd4aytjWU5W?=
 =?utf-8?B?bUZvNmlOK3lZVGZ0bjFabWpNem04MlhicUhRUzBYWmhScWRNbmtkSEljazJ4?=
 =?utf-8?B?V3kydndYcGhGQVVrWExicytCbVpTRUhlUFdLbytmNXRlTGYwMG5LRVdLL3ox?=
 =?utf-8?B?dlY5T09QY0szL29kYVQzRTlOUUZveUlMV1c4a2JjSm1BSnduUDVIbFluRUx3?=
 =?utf-8?B?M2J2bkY5T1JrR3YrVGZTb2JkeWJEWGlwOHlQeXdJV0pwQ25Ub1NxdWtGWlJ5?=
 =?utf-8?B?eTZqTmttTVJaelM4RHYyaGoyTGdaRGhCNGNVaVlPTEk1V2ZIc2djY3luYUJG?=
 =?utf-8?B?T3hYbHpFOXVtN0duSjY3UmE2QTArdGUxSmw5Y1FxWlB5Q25DZlR2U2VGeVJI?=
 =?utf-8?B?QlN5Sm92K2RHNXhDbzh1QUxhLzVLWHlRYXY2MU9WWENyT3dGRFBJWmE2NzA2?=
 =?utf-8?B?c3ZXTHhZaTJPZHhzbXB4RDcxVzZMc3lpdGtTT3MvWk1HUlhqcHVHV2g5bjBF?=
 =?utf-8?B?eXhGWGpVT3JGSldQbVl6ejVhMXg5V3hEcXUzM0NJR2ZXRTc2Y21LQVFQR3NM?=
 =?utf-8?B?M2p1YzRSdC91anZuc2dUVlloc1ZzbXdKSzd1blphd2ZVaE9IVFlDMExjRGd0?=
 =?utf-8?B?cFNzNEkrZEo2azBTU3dpc3A0WGM4dHpBNEV6ejhDT1AzYzN2K3IwWDdscklo?=
 =?utf-8?B?ZFB4ZUVhQ2tOL2RLK2ZaQlR5ZnYrSFBXWTJxS200clBQU0JsOU9NejVGUzRD?=
 =?utf-8?B?VDJmdG5WN1pQS3NxVXhnekRrbGREQnF1RjFwZHRkUGlKcVgxWnRDZ2k4MndF?=
 =?utf-8?B?ZHFydkR5NEpydTBHR2RNQnhLdEJBQzcwMHh4WFZTQndQRlFqdHpCVmg4YndN?=
 =?utf-8?B?YW9RbTdrTTg5dlA5YWcvQ3BnRThpVk9PS1l0M2trNUlneGFYR214eWZ5SDVE?=
 =?utf-8?B?QVF3WTZSQ3psRXNOREd1U1BWL1kzUWlreWwyQUFETU1vSmlWOVlzSE5YK3pJ?=
 =?utf-8?B?VGhMY2JUZThmTlhZN1RzRHMzdk1UYUNyUmZKblc3RWFXN1JBSVFoUHVwbDJQ?=
 =?utf-8?B?M29yeU9VN3JtTnlJbW5HaWg2ZkZyL3JsZVRHKzFOSWVzZmdWK0VCUitMUWhE?=
 =?utf-8?B?MnN5M2JsYXB3REp3ZUFJWUFMdUZTcEVxc3V1WmZiQU1Td1ovQVZNUHJmWjc3?=
 =?utf-8?B?QWFzTlIrWkdqSkF1ZWFvZ2VycUMyVTZ4VWlacXRvbmI0bUt6N3JIK2RpdUE4?=
 =?utf-8?B?cVhkR0tPem1xRjVmYVdTcTZKUEJZUjRCbjJmRCs0QzJaMVlZUmo5RnV1Z2FE?=
 =?utf-8?Q?EjMDPr+h5sWiny8GAt8TmKiGkJS1A6NXOPlaI3CjVLs8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NElUd3c2NTR6KzBiWXh3SWxBYStjSlJKNWtJWXFFZXkvSzRFUGpWMmZra2xJ?=
 =?utf-8?B?SHh0MXI3M3BhNXNlWGpjWU42RklCWFB3WEhaOWRWd2tLVXRnNzc0eVJsVlRM?=
 =?utf-8?B?TmFablZ6NlhsU0NBeGVzalVrOGFoZjVZc1lxMVpzYVdnVmhacm05a2VNeERR?=
 =?utf-8?B?a1JHYSttQ0MwM1BRUFE3RDhtUWFGSlJaY2JuOXhuKzYvdTg3R3dWb2ljbjVI?=
 =?utf-8?B?YjhHT3JuektlR3RIWUpkMkZtUTkxS3pWdGhUU2N1L2V0am1CcXBVMWJVWGYr?=
 =?utf-8?B?Y0luRXViYWdzMVhKMWpza05LK1k0WnpNSWVNQzQ3ZHdjdXVpZHlJMEpucXhk?=
 =?utf-8?B?MlpoOGRJZ25NLzZadXRYVWFRWXBZVkdjVUpVUWNVcjY2RndDei9GcG42Mnl1?=
 =?utf-8?B?TmhScDNhMDQvUEw1ZXhuUjVUNm5sUndGbWdtM0NpYjFrSTdZU1RQVXFZTHRa?=
 =?utf-8?B?RXl0ZzJwVzhBUEJsMHNXZTFteFFiT09yY09GN0ZzUHRKbTdDWEpSOGk3ektS?=
 =?utf-8?B?MDEzWHpZTUhyOHZiVGY3STVDREx5RGdweXRtVE5wYitqNkh5bkVrVWdRbzVv?=
 =?utf-8?B?WnRiUDVZamlrK09NTlQvSjZEOVBOdnRoZnVScDUvM2RjdDVJUTI1OTl1SytN?=
 =?utf-8?B?TmEvV2ZBUVBieisvMHlxcnhZcGx2amwzMk4zYVptOC9nMHRtZnJ3U09FQ2xy?=
 =?utf-8?B?Q3lSVTUxTjVKbmtHNVpWVTdKUWRSUkFQVUVCUlIvenNVOC9VOXhNem93Qnhr?=
 =?utf-8?B?UG9yQm94UzR1YnJGRzBVOTFmZ1FpTEs2TVYrc3Q2VzNpdTE3OFpiRmhaS0cy?=
 =?utf-8?B?bXdlR3Zud1R5YVBqcFJHdVUzSUtYWVVBUGZrWXJYd1NoNDJFQlY2SnVGclhX?=
 =?utf-8?B?Q2xzbHpoTXVMWVQ0bGtlTWZkcXhJNXZKaWJ6Qk80RXZiOVc0aUJLMDhJNEs1?=
 =?utf-8?B?ZmJXbDVJR04zR1pxVVU0Q0tKWkVMaFU4TjNYQzBFTkZyUnZWdmpFYU5pMWx1?=
 =?utf-8?B?aGFUc3IrMWovYkZqQ1haTERQODdFcjJuUVJFenZXWEJvQTJ5cHRxUk9UTHZK?=
 =?utf-8?B?K3VYVFRCYmJQbUpYVDlYTitVVzdBSkpvMnBhVEtLZXlWcEhvQURQWmlXZzVa?=
 =?utf-8?B?eUtVbkQ3bXQwL3Rla3ArNGVaSFY1cCsxbXdDWWZzN1ZVUjI5K3N1QVVTWEc5?=
 =?utf-8?B?cENZaEd4L2sydmtKbCt4TStJSUoyVkE4Vk5XQ1BZWWFyaG05K3JSNjk0cDJx?=
 =?utf-8?B?VUxRNGNxSzU2M0t4amczUnhwT1ZDaWl2c2kyd29XYzFNdmpVcElGV3dJRkNL?=
 =?utf-8?B?RXZOSU5EZHN4ZC9odDI0Z3JpSDJxOFBqNlNib1IzRW9FMUdRRGlQQlgxOER3?=
 =?utf-8?B?N1BCMjBqeTUva1JBZ29Td3BqQm5CcjBEZ1FkTjNjaW5iSjdTZE5xZVZrTmFm?=
 =?utf-8?B?ZjhqWUZ5eDdpZE0zZHl4eEM3aWwveTl4QlNVZG9pS0dTN3g0SFRvVmV1L2pJ?=
 =?utf-8?B?U0ZBY01SNExydFE2RnM4dWtFRnlhKyt5WG1GdkRYYkVNaTJ0UTF2RTNBOGRh?=
 =?utf-8?B?Uk9sdkhEbjltNko4bW1ZR29jTUdXQ2ZENXc1M3NNbzFPdVM1UkF4VGQwcElC?=
 =?utf-8?B?WS9XR1MxZFVsWXN0dFJDMVJzdXpmZEdnYUdsZWxUbFNjZVlVQjBVNkNmQWkx?=
 =?utf-8?B?NjNIVDhiVjNqMzRwV3JQS2pVRTExd0g3cnMwN3kySDBDbU1HMUxOQUo0azh3?=
 =?utf-8?B?OVpQZG13Y205bnJPTVJUcjNtbW9UaVpTTDNkNzdGc0xFYnREZmFEU3FtTDBH?=
 =?utf-8?B?dWxpRy82eWo4Qlgzak1NMFBhanpJT0ZuS25XRzVFdWJGWGpna3BSRkJvOWVT?=
 =?utf-8?B?c1VGT2pUVE5LN0wyazJwSVJzQktzemxBcWVsenZwQlNyUlk3Y0lVeHhTbUVR?=
 =?utf-8?B?bXdseWRVWXJrS3VwQ0NsMkFrN0Rkd3l4cHdDNTBjSnBxc1Z0MVBrMXBMaTQ2?=
 =?utf-8?B?UGZuc0szUVB3a00xN2hFek0yUVpKd3NMbDEyaW1idWxoZlNoMkdzOW9IQnVm?=
 =?utf-8?B?ZjJhOG5lZlBsN3lnWmtvbUdDM2dEd2c2bkhBYUJ6THhnTXJSSGExN1F3STJp?=
 =?utf-8?Q?ZLBVa4O/7VL7692jo/aRAl0NE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fb06a8-805c-45f7-089e-08dc6ee1076d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 21:59:55.3048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z80P8P8EZkkv8I0hLyh8vNOOfdCT/MtZBsELHws3KRv27pxu/1p1NwBHr6OVSFHebJRwO3Tqyo/JLztkBkTVEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8763
X-OriginatorOrg: intel.com



On 8/05/2024 4:24 am, Sean Christopherson wrote:
> On Tue, May 07, 2024, Kai Huang wrote:
>>>> So I think we have consensus to go with the approach that shows in your
>>>> second diff -- that is to always enable virtualization during module loading
>>>> for all other ARCHs other than x86, for which we only always enables
>>>> virtualization during module loading for TDX.
>>>
>>> Assuming the other arch maintainers are ok with that approach.  If waiting until
>>> a VM is created is desirable for other architectures, then we'll need to figure
>>> out a plan b.  E.g. KVM arm64 doesn't support being built as a module, so enabling
>>> hardware during initialization would mean virtualization is enabled for any kernel
>>> that is built with CONFIG_KVM=y.
>>>
>>> Actually, duh.  There's absolutely no reason to force other architectures to
>>> choose when to enable virtualization.  As evidenced by the massaging to have x86
>>> keep enabling virtualization on-demand for !TDX, the cleanups don't come from
>>> enabling virtualization during module load, they come from registering cpuup and
>>> syscore ops when virtualization is enabled.
>>>
>>> I.e. we can keep kvm_usage_count in common code, and just do exactly what I
>>> proposed for kvm_x86_enable_virtualization().
>>>
>>> I have patches to do this, and initial testing suggests they aren't wildly
>>> broken.  I'll post them soon-ish, assuming nothing pops up in testing.  They are
>>> clean enough that they can land in advance of TDX, e.g. in kvm-coco-queue even
>>> before other architectures verify I didn't break them.
>>>
>>
>> Hi Sean,
>>
>> Just want to check with you what is your plan on this?
>>
>> Please feel free to let me know if there's anything that I can help.
> 
> Ah shoot, I posted patches[*] but managed to forget to Cc any of the TDX folks.
> Sorry :-/
> 
> [*] https://lore.kernel.org/all/20240425233951.3344485-1-seanjc@google.com

Oh I missed that :-( Thanks for the info!

