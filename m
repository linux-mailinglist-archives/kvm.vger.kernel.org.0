Return-Path: <kvm+bounces-14242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F3358A12C5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E612AB25FD3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE263148300;
	Thu, 11 Apr 2024 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W2H4cyVc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C671474BA;
	Thu, 11 Apr 2024 11:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712834096; cv=fail; b=TqrLy3G881wnmidPAXs6gx3tpt3GbZ1Ee4jle6kJlNcum9avrrq2377UySzgCfTF5qWvUvz7xYZzP58/3ASZsz7YrjN1Adx8U39lbdvSDO77OGJTOsquovPy9cu7GmAYR7RxA2m70x2yPqnnW2P99EJSiNTfGnhQUbb9nt0Ef10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712834096; c=relaxed/simple;
	bh=5SYU2lPlxme330IzEHo24yOwv0zZDpj9yPhSy9h4I34=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gz9CDwF3Y8WI9N/kvsNGvVvKRBYdk4JvS7f2tNpPiEnt6xuTfh7J/5iSrnt7vVUyaCay1wfbf/bimGwRyUCbSzCb5YWkMHrm+4XzJZ4YkattpQodTTzkMYEh9NeMu2UkrVg1X4Gfc0WV5bQdgCmtMiE1q1fFMSTSjqdbNVHDKKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W2H4cyVc; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712834095; x=1744370095;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5SYU2lPlxme330IzEHo24yOwv0zZDpj9yPhSy9h4I34=;
  b=W2H4cyVcBFoTi3I5ipVgQOAwmUySSGj3rJ/IJpKJdNp6y6SlMoBgGyd5
   Pnll0UpjYG44sIBOllL4Ywh+zEHg9B01RNcaNdtPnGEstQ+r2rt/2Wudo
   lOWBDLLzypIQDWq5I7lmbZolBcSw2yP9N+h1FXrhCzW3qBw+vsfsMuIGg
   5rcHwUAJvY4uqx09ZXaZLuFqpdeMBgmZMrboy14MVuYMBB8/x7dRv79Kf
   2OHpti7CHD6cF/T+IbnAviM2qWnj0jqflzXwMoFke2izR3SknC566XhqU
   XX8RglANXjrymjcq/kX55yQ+WO7WyAlLCJAiqEMkRb3aDmPFxyAnbkdio
   A==;
X-CSE-ConnectionGUID: 4L+m6Ld1RN6eGBhA1cNh0A==
X-CSE-MsgGUID: +0GCMQd9Rc2odu5chsqliQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="19628234"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="19628234"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 04:14:54 -0700
X-CSE-ConnectionGUID: Tqq97iAqStih+LmkcaLLxQ==
X-CSE-MsgGUID: MyyTExhLTjeTVhnnYm/Olw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="58289714"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 04:14:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 04:14:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 04:14:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 04:14:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 04:14:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoDepLymW+17uNuV6HW4SDbmhqv0wWwcuxZIrJ1dKVeztal0DC44mdXe4+3hWsMzYH4o8/v+B+MKnmywcRA+5gJo+RdYd0sbS+/Eqg7USYazmY1CWaLlQxH2xeirsbufUobqJqw81EVmav3wlnrYiHQNuRh2PhWS6FOrelHKqz2RL9zLSiKmig+pxT/HB55EtECc1NMbmu2ox8gtBgP7zmxS5GBMHsnmOwUOv/Ywa/6+JisdxZBLY+DkzIFlJ2sbiMa68Ud27MJ85ruUQqwbbyNsY7EeEbN+mtCcywz+5YGMvzd3INpwonbU7+wh/3xnOhYpjhhOXoioBleLEt42gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SYU2lPlxme330IzEHo24yOwv0zZDpj9yPhSy9h4I34=;
 b=V8v1QJXR7b7CBUeWc2hcyClS4UQFGOcdL13JGlI8ZryksG31yOHZ1Y4WWszqEG59W/gfVwj9TnoRqsHARRaSkyI+hwEYTyOGE4kYaLezkUAqmqZJmGjqj1TbDBlPgUOPZFA2lBgJhuujgpH/gcaZ7AOY21p4WEPuo3o4V/CRPT7EPnw10U6woKjHaPCRzYAhAEbeLFIfroIywYqAelVJREugSD5IouWHXJulYFp80BUmIBES1MwHzmfqD6yt/MsXln4LaJNKURJWkfNg58Rxl9bkKMgko6TuaoSC+4MU4v25RLenTKsGk1GaLeo5EGf9nltoDu0jHNsMVFnYAwsmkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4831.namprd11.prod.outlook.com (2603:10b6:a03:2d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 11 Apr
 2024 11:14:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 11:14:50 +0000
Date: Thu, 11 Apr 2024 19:14:38 +0800
From: Chao Gao <chao.gao@intel.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: Alexandre Chartre <alexandre.chartre@oracle.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<daniel.sneddon@linux.intel.com>, <pawan.kumar.gupta@linux.intel.com>,
	<tglx@linutronix.de>, <konrad.wilk@oracle.com>, <peterz@infradead.org>,
	<gregkh@linuxfoundation.org>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <nik.borisov@suse.com>, <kpsingh@kernel.org>,
	<longman@redhat.com>, <bp@alien8.de>, <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <ZhfGHpAz7W7d/pSa@chao-email>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
X-ClientProxiedBy: SG2PR02CA0134.apcprd02.prod.outlook.com
 (2603:1096:4:188::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4831:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a33589-6438-4bc9-5574-08dc5a189ad7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4fFuAw01jnQ1lKl3jOX1KUAbshvxPmivEQaRJd6HoQ7gVyUO81R92lE9OA59Ox1fSVhCVyFpsZIWOFohVq52271+QN4aaNqwaX4lsZSyl6wXjRn7A+oHwO+F+4lFbyYglOr9mD8ZK7QV4a5pXkvkNdkmHvJmnwBcKJt0SE8xRtnL+b3GbqpPGu2bgXhAJ/IMkVV7+GbxXoaC0J799cHUUmHMIRrItWNF7C8ndGH7NO1Ra9UtszxS6V0uQennhdw3bKoU2wm/IxuPu3GJGthU+vzMCXEetIqyMkm8bbdNyC5r/TdvY3FSPLGYPWsHSohONzJIZFLM15xcvEx/EwWV86iDDjKlYNIRUZBNdOCcoZZrzGSW7zBRXESHL7joaygWiJz2IgxddGwuPzJBF4KjwI5FM2CvNKS3hSD0jySvLxPItVbI88BSux3Ofx+SGwiJIHd1+ii1pxt0quHm7+ACdUPVGVcVGzns5K5mAk3n9BOWMkiKJ9K1WUmDSSgzgjw+8KjTvJQl2tNacVtU0nghrqI3dck5mxtIBGbKmjkYUvHS1ha4iH9G8LgkbczUDsRTV38a2wBrEbyBX6f20TBwuSMKl8zRDZH8Dt0baJGLy2DoSDyhHdT+pkTK3RT6taCfk3NWRR84/qaZ7S1Io17rjXEIq9caALJqHqcDwHhUZ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nwhO6nD2CLPrnPSqHgjjwPqdEqMufP68NChFvx0DmFssattNYl7YqWRiewwJ?=
 =?us-ascii?Q?DeFgZtRWAfNn7Uqd90XQF/SHQqhiV4Q655KzIQz7/Wq+VYXESX9vnbpWRvyt?=
 =?us-ascii?Q?ZVcNzyL/EqEjvJplFkWIEKBqCw1/lN4D8HDcf4Y3DfS58nd2+eMGb29eohPE?=
 =?us-ascii?Q?727DjiD5GZVI61GZwtVttA/H/MpsRFSc1+hvZD9Bgja2iV9h9n4kkOB+IUVO?=
 =?us-ascii?Q?D0LbDf0fLvIAXdcDLVgmYhWinu48r+aK10SgckB1yyGBHxmfuFOGqS8wb9Q7?=
 =?us-ascii?Q?IIGQUfW3CKNVsfosBV9ksG8qBnxZEe3U5+ddoYbTR0QJh65zCh72UpFdZ6NQ?=
 =?us-ascii?Q?NStseqKRKqrVm3yfyrAY9/P0IKsJc10m+k0Pii3JqZL65nudtGtzkPUcFwui?=
 =?us-ascii?Q?S8Fob/wa1dXIeNT6F2TNiCL4WzOsjkKzcmdXCIZopNh6J5v6aFOgbmDTOwT1?=
 =?us-ascii?Q?xKaOF+akTe0r5XLUIMET7l6H9jlemv39SFbOwWyKLQsEWMdLvhRfVMBobgws?=
 =?us-ascii?Q?xSuBdNXjB2pyONqRnczbeCqE9LppajT4Q9ytb4owGMTJhyJhwBJ8ta3hOAKe?=
 =?us-ascii?Q?fUvaQ1pOpgnrVvE1SiT5jY/vGiT6VIEHApDx4+YBJo8Arz1MCGEXKF/Ln/9m?=
 =?us-ascii?Q?u8ES1hv47X7dglEUPoiM20q8doqENBzcyf87F8OxybHiqylCyl8W7DrACI1C?=
 =?us-ascii?Q?vjWpqd6QPX1iQwn0PajMZV5lyAHxj8IcG6uL5809qOng3bgrr4z/X71MJKaD?=
 =?us-ascii?Q?vG0uVnpUzZWz5iDNqrbcIOEvqlogA/omEQ2j9NxZxveKf6PzEqrvlFrGV0vr?=
 =?us-ascii?Q?7hF1ZKgF7wzX3JCUhWGXB+XcSF+VcgyCcx6EIaqi83KGOiuuX+4rSkRxgAGW?=
 =?us-ascii?Q?sU7/To0xCZwpFltHZcrYM55pZt5hCpM/7xAFq/L0+eUEJohdYc5QmTQwvRFN?=
 =?us-ascii?Q?1R9w4oLS64AiiOtDgJQVNaYXaJs5CwPX8bxC8rBTPdZYTIz2ZzWAXzdMajlp?=
 =?us-ascii?Q?HWQ48w3vXPmzQh8dOghNLyVV/qYmlhw2pEzZtJoN/+M5laxnjecvfZuD9DQ7?=
 =?us-ascii?Q?HjBPk+fUyF93kbGfD9z36I4rVDFa6fNBwl9r8l8dycO6WQ/T+tXXVimuRElx?=
 =?us-ascii?Q?9b6yCFMlZXfpB3Il9VKJq+ytH+QNr/7YjIPX8Uv2NildFaiF/FkUi7bXmJVC?=
 =?us-ascii?Q?9Qo0ccmti/b+ds1SFs2bkNpA/N/DgjOo+Ghhgo4y7XE0sW2lCRWdmb/O2AzX?=
 =?us-ascii?Q?q8D8A+iqBi1aSroYFzvDkNczbiXM9XninVDDkMQhnkyz5aVDoyLpTwnur8Vc?=
 =?us-ascii?Q?wSMqi4nSDB8njXzf1utguY9Jud5l8PlIeJoSTcpV9X05bNDgiSd9U6Xb9x0n?=
 =?us-ascii?Q?s9ywbM9htPT+IiLljKFA5CCptbWPx6K2bZxAlcxQzAweCtgwu6VhGE6eWsvC?=
 =?us-ascii?Q?9qvsoeRJhEZQoVZHsDP0V7ABYRjDHqrHMC+kE75Pqq2oiqgv27lBireBlgkb?=
 =?us-ascii?Q?kwzIL/9vMjjdewneR47mlAVUHmSsSGvDDm5PWcsgpGi4Q3+QyJhaRGHp3xQU?=
 =?us-ascii?Q?l4Y3m/Lvzdg6Ru/G7WLehPggepP+jD9/TaVug68r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a33589-6438-4bc9-5574-08dc5a189ad7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 11:14:50.4289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQpbx0vee8TPZ5kxtp2Y3JEIat+PdXGYsYp5v+1XOUzbqtXrNj3VKC4oE2AKC0uUDWE5I8tMmhSgcskTLlQw9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4831
X-OriginatorOrg: intel.com

>> The problem is that we can end up with a guest running extra BHI
>> mitigations
>> while this is not needed. Could we inform the guest that eIBRS is not
>> available
>> on the system so a Linux guest doesn't run with extra BHI mitigations?
>
>Well, that's why Intel specified some MSRs at 0x5000xxxx.

Yes. But note that there is a subtle difference. Those MSRs are used for guest
to communicate in-used software mitigations to the host. Such information is
stable across migration. Here we need the host to communicate that eIBRS isn't
available to the guest. this isn't stable as the guest may be migrated from
a host without eIBRS to one with it.

>
>Except I don't know anyone currently interested in implementing them,
>and I'm still not sure if they work correctly for some of the more
>complicated migration cases.

Looks you have the same opinion on the Intel-defined virtual MSRs as Sean.
If we all agree the issue here and the effectivenss problem of the short
BHB-clearing sequence need to be resolved and don't think the Intel-defined
virtual MSRs can handle all cases correctly, we have to define a better
interface through community collaboration as Sean suggested.

