Return-Path: <kvm+bounces-3643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A84658062C3
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 00:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE387B2120F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E3741212;
	Tue,  5 Dec 2023 23:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gEvQ5dcC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46030120;
	Tue,  5 Dec 2023 15:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701817901; x=1733353901;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FEiwVoMjtr/9HH+TNv5nMVsA9bg9zsnik0gar7NDCKI=;
  b=gEvQ5dcCne0OsaiWkYuYRePjv5amyS6SJm3kPxdsM0ssoDD8aIdQVKNF
   zJ8MSeZngqHEdX+DkqVDy31TMJgT2PXH3vgtveoLk4E5retLk4adEKsu3
   YECWnRhRjsvKfOcFQAlGWPAMJUUu+Of1P5/feDPi6qmPnBnb6TxnoHbLP
   JHMM3vmZaWwS8DWHeJ9tBWvfWxbPtFOyS8eyP5/TegLRtLbhireps0GpH
   QakZXsGbnF9Zxgr0pZZMrXI6Ysv1dIboOmTK8zHG2rPh8WXchzN66gkJV
   Am3mmFLw+vVbmOk/8VCtcyKjZsh3rUxvIbSaJP/8eWFB+gmeRIgVN9SUR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="396766459"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="396766459"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 15:11:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="771091214"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="771091214"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 15:11:40 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 15:11:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 15:11:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 15:11:39 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 15:11:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVEN94BNZEsqS+4H4pgnPe1ev8CXjuYX697jWnnDqDWrozQofYaHAimi6U1Azg9HZRgrk9MewPoVxc+qJrT4DFDNS4VnUKyRRpqgucG1ID282eg+RH+Fcp0EgYV59pebgmaPOy8KAvDZN84z1iBrJWrW0SrVGJ7avdCs/562zA8BiD2LGrOdEFuRBTYsY3AMgf7mDRgc5ZXifHFfDxJNTQXg9lPpf3nD+3pxaReslUvckFpxm49zsNYrgo1MEtKqyA2N2+6A2ATv+MC0JtwZAb4K5GfdJryLSDoJI4QRVMT2dgCG/TdmrqNd9VMtMum3m9zZWZejth8BRuv8aAW5bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0lL9utMbn/uyp5GBaNk5//QndzjR07pxk/lf/iXpc4s=;
 b=TOodwkTcPcQSKwmgmAUbT3xNWuU7BHnO55hVd617luakFIIsthGOTq00ec2X/GWZ/cpjpXGOf791P5jzvmWvSTwvARjHyj+/hwwy9fJPfPYuB4LGj5AHawGSOFXzme/OhASBlN1swE7Qm4ipxr9D31STmHo42S8ODk3sm+NrjE5G0ysq7DxHl65as5i5QdJN4EFZztG/gLrP0jOVT5b7iGnKmmfmjdoAdd3hG9SJtbhiRj+rQQSuZTHP8cAPnLggCl4qV8ubM8OCrR6BCS1/TPaIv/t7dW6cvjUTqJWP9f59x7QE7TtkW/o6wMMrq9bShZx4i+L4GQ6OnBAgL3oGfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB7142.namprd11.prod.outlook.com (2603:10b6:510:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 5 Dec
 2023 23:11:36 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 23:11:35 +0000
Date: Tue, 5 Dec 2023 15:11:30 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, <dan.middleton@intel.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
Message-ID: <656fae221bf90_45e01294d2@dwillia2-xfh.jf.intel.com.notmuch>
References: <ZS614OSoritrE1d2@google.com>
 <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com>
 <20231110220756.7hhiy36jc6jiu7nm@amd.com>
 <ZU6zGgvfhga0Oiob@google.com>
 <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
 <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
 <CAAH4kHb7cfMetpC=AYy=FjTTve6g0W8NZdeSwQ8uVxkqi2491Q@mail.gmail.com>
 <656f82b4b1972_45e012944e@dwillia2-xfh.jf.intel.com.notmuch>
 <CAAH4kHb9O9FeaTmNuNAkhrdrDLJPo8qgD5vNow3w-sY-DA4Ung@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAH4kHb9O9FeaTmNuNAkhrdrDLJPo8qgD5vNow3w-sY-DA4Ung@mail.gmail.com>
X-ClientProxiedBy: MW2PR2101CA0002.namprd21.prod.outlook.com
 (2603:10b6:302:1::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: 1132f261-ff9a-4ae0-99af-08dbf5e786cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: foLDqGQtKwoF3bGTbLVvQ66dW+oecTefgBu1s5RTqa6KuzGCTGFb+BUa4d/ZD5NeHakgpaLPTyUmDDNVLWMBwpK4b1EaROJgO9dbm3K2l297L9GLk0JGOcgrDKdLGoKjKvhtAVvBLUTQvqw9CldUElyhSKfltrorFLmK7YKIia7Npqb76v5Hmt5h9SCfTBs5WA6r36Pc3at8sJXAE6mbAUuBQOzRKvolhBfgAI/1Vz987Xa3FacOp2/qh0CNczlETjjQHn/r4/yOyK8HuxNzhEZMFDWqfZzwWLFVE8tRNW2tK3Xq72pnjUIBhm7hxsl/I56IORg+aDsa0fyLJZUg4X9SvLpVjtq3M2Cp38OY4AznbuJUOHuCXVd7hcN6bnss0yXNQjCZuUsKntCb6Haix8STFD4t5REfm5MUivf2+D4gAeLb1vVh8A2aYpNEk4bK0U4C0fusfQLxNUdYkKmORNRrBtBnIqRgE0emBLtYZxF+baVmCe+sHV3xAGTVvueFEksg1CyK913W0nn6bT/bHwRh1hrU/HwJhHzHdoFOccg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(7406005)(7416002)(5660300002)(2906002)(6666004)(9686003)(6486002)(6512007)(38100700002)(966005)(316002)(110136005)(82960400001)(8936002)(478600001)(53546011)(4326008)(66946007)(54906003)(6506007)(83380400001)(26005)(86362001)(66476007)(41300700001)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTdNNU1Ea3VuYk1JK1VuWnB2b2tNd1ViZFA3cjhLSXRsdHVNM2F6YkFtcDBq?=
 =?utf-8?B?YU8xb1pDWTI2QjY1T05yeFdRUlQveFAvMCtvRi9QYTdwNWhBdXJFSUFKdFcw?=
 =?utf-8?B?VFZWUWR2ZHVyRms2TWV0REd3ZkhEeXJGaHZ4ckVJQ0Y5ekg2UC9OVkFrd0Zw?=
 =?utf-8?B?YVZMNnQ2RnRSYWR0S3M1ZVJiOHYrL2lBZVAraVFURk4zei9raW9KSm8wWS9V?=
 =?utf-8?B?VjlxMkRJRHZBWEV4M0JlWHd0eVJJanh3Q2M4eHdSTWFUY010SHBNOUlaQTk4?=
 =?utf-8?B?cEtISTNEWnZ3ZStEUFpIYlk2NDhFVm1NTlRzSUdNNGFWK0Zlalh4VURFZmcy?=
 =?utf-8?B?eFF0WlpuL3pxMzJHeTZhdVZsbXRRSEZETGFQSkFpV0NjMW1PTmcvc3MwOEFF?=
 =?utf-8?B?VWV6dG1Ca0ZFZERjR3JUVXZZZndpM0dJTGhBQnRaNDh6Q1h6V3JWZ1Z4ZVB5?=
 =?utf-8?B?MFlqdmtzUGF2VEM4Q01SVi9SaWZialZKbzRwS2YwTnhRcWx0SWFBK3N0aWl0?=
 =?utf-8?B?MW45UXY0SU01UE54S3BYeEt2VTEzUGRNVzRvdWxSN2psUk51V1JQZTFmZGkz?=
 =?utf-8?B?amJ3VjhNNDdKRFYzaG5JT1lUdnBESmxpREpYMEk3M2xzWlhIM09qaVJWS1cr?=
 =?utf-8?B?S3NIdUk5d3RPdzhEczZVb0lLN3ovZUVLZlNPQW5LdzRwVS9jc0t3NkVSZ0Uw?=
 =?utf-8?B?b0pxbzk5bDZuT3BMTDcwZnNWTXhqVVVxYkZ4b1k1MlJJZlhqYS9OVmNTbzRF?=
 =?utf-8?B?aTBDS1BjZlUxajd1N3NKZHIyVGxhdnoyM3NDYnhIMUVlSEk3VDlqS2R6dFRv?=
 =?utf-8?B?RmtUWFN4ZHRqRmxkT2s4MzFONGRUMXBqd2YvRnZ1bHJmOE1qK3Y1bXU3UjVB?=
 =?utf-8?B?K3NXc2ZOcndScUxuMXVlSGJaVWtYTFdEOHV5ZXFlaC9iSDN2UG0wNzM3MHky?=
 =?utf-8?B?R0Z6VDR1Y0I4YmVaazNEaExvME5nenEvQUNJeDRNSUp4NU1mcENiOUJBc3Uy?=
 =?utf-8?B?aWpvVzBqTVlDMVlWUnFOY200WG8vdmpzSzhzejEzVmVVRU5ScFE2WFhERnJ0?=
 =?utf-8?B?bS9VQWNseEppQUdSNlFpVUQ2V2M2cUxjZExGb05PdzM0eWNRRlBvRlVvTHdh?=
 =?utf-8?B?c05zMUt3TEpZRVMrZlBXZWRrd29Ra3A2U010ZlZ5MldxUkpVczVQU2hxUWlD?=
 =?utf-8?B?eHBEZzczZUlFaS8xQXNPVlAyWk15dGxlWHo4RjhxcGZDTUl4MXVIYzhuNnJG?=
 =?utf-8?B?cXZvejNXRG44cDFLWGdGektZS0MvNXdwWkNoRUk5QzFCWGJlcDNSNGU0NEkr?=
 =?utf-8?B?NzVRMWdna2E2eUdkVnhPZkVaS2NJQmh2cWhsTm5hbzY4QlZ4bzZ4YjVBZE9t?=
 =?utf-8?B?N2dEY2xoTC9ob0pseWpRbm1nRVNKMytLMzlhOXppMWQ3eGVlZUZYa1VZWmdM?=
 =?utf-8?B?cXBiRUVUWmdvMEV0ditjRmcxYmJORTFjbWhvRnk5cDVhaUJFQlhtd2Y0Sllt?=
 =?utf-8?B?Vm5xdmtWMnpINnZiTWdIVjJXZkR6d2FkNCtFTm56ajVSc1NsSkxnaFVUaGFQ?=
 =?utf-8?B?SjFLMVlnMStCNThEaExxM1VwelAvSXBtMlB1dng3Qk5ZVG9OdXIrWU5rS3d5?=
 =?utf-8?B?MXJkb3AxaENTK0I5L3NrSEM1ZHdsRk5BekI5T3YrdWxRcThpNENGc3RpN2Iw?=
 =?utf-8?B?STkwRVpDL0RjM0pYV3VrZFMzTTdXVlEwaVJNeEJNNFZXclhtRlVtTGZBWGpN?=
 =?utf-8?B?WVNkSGVJV2tqRFQ0Q2xXRFdaUStzQW9Ka0pRTG5PUC8wc241Vm5Dek9NcW5q?=
 =?utf-8?B?VGVjUFFFbzNWcWw5VzJ1U01PV0o5L1lJNjdIeEdLZUNDRlJ5N0pLUFJZWDA4?=
 =?utf-8?B?R3Q0ZUE1aWt1R05BcnBWMy9tK1ExNHVHMm4wWlZUcm0yS0N4elZxV3RBV045?=
 =?utf-8?B?OC9nSnBMMmxER2V5bUlNazBZSE5ML3NHeGw2SDNFS1dteFpWVHRCY2RtT0Ew?=
 =?utf-8?B?RHNlbEFCNjdqYktwKzhOcFhxbjdyVVVNMDJwNlBNeHNzS01uMkF3Q2s3SGhq?=
 =?utf-8?B?REhCdmFXMzNrTGNjeUNzN08wZDNPeGM4TCtHMzBPTFU0UUorSzUzZ1c4Ynpu?=
 =?utf-8?B?V29GV1dyeEVaOW4wVE5Sck1Bb2MySTZaa2g3SzBiamw5MzA2SzVNWFk4Z0No?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1132f261-ff9a-4ae0-99af-08dbf5e786cd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 23:11:35.3690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvCJnY0XNFt17GRw7ikruh+CkOtYrgImIibjRX6E59c0D2S7khlKhYSaf1MYmnsE9wrUJRE4+0yOwulfdeKqiWg7cQc0dTk/VqG/7pPtJIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7142
X-OriginatorOrg: intel.com

Dionna Amalie Glaze wrote:
> On Tue, Dec 5, 2023 at 12:06 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > [ add Ard for the SBOM sysfs ABI commentary ]
> >
> > Dionna Amalie Glaze wrote:
> > [..]
> > > > > My own plan for SEV-SNP was to have a bespoke signed measurement of
> > > > > the UEFI in the GUID table, but that doesn't extend to TDX. If we're
> > > > > looking more at an industry alignment on coRIM for SBOM formats (yes
> > > > > please), then it'd be great to start getting that kind of info plumbed
> > > > > to the user in a uniform way that doesn't have to rely on servers
> > > > > providing the endorsements.
> > > > >
> > > > > [1] https://uefi.org/blog/firmware-sbom-proposal
> > > >
> > > > Honestly my first reaction for this ABI would be for a new file under
> > > > /sys/firmware/efi/efivars or similar.
> > >
> > > For UEFI specifically that could make sense, yes. Not everyone has
> > > been mounting efivars, so it's been a bit of an uphill battle for that
> > > one.
> >
> > I wonder what the concern is with mounting efivarfs vs configfs? In any
> > event this seems distinct enough to be its own /sys/firmware/efi/sbom
> > file. I would defer to Ard, but I think SBOM is a generally useful
> > concept that would be out of place as a blob returned from configfs-tsm.
> >
> > > Still there's the matter of cached TDI RIMs. NVIDIA would have
> >
> > I am not immediatly sure what a "TDI RIM" is?
> >
> 
> I might just be making up terms. Any trusted hardware device that has
> its own attestation will (hopefully) have signed reference
> measurements, or a Reference Integrity Manifest as TCG calls them.

Ah, ok.

> 
> > > everyone send attestation requests to their servers every quote
> > > request in the NRAS architecture, but we're looking at other ways to
> >
> > "NRAS" does not parse for me either.
> >
> 
> That would be this https://docs.attestation.nvidia.com/api-docs/nras.html

Thanks!

> > > provide reliable attestation without a third party service, albeit
> > > with slightly different security properties.
> >
> > Setting the above confusion aside, I would just say that in general yes,
> > the kernel needs to understand its role in an end-to-end attestation
> > architecture that is not beholden to a single vendor, but also allows
> > the kernel to enforce ABI stability / mitigate regressions based on
> > binary format changes.
> >
> 
> I'm mainly holding on to hope that I don't have to introduce a new
> runtime dependency on a service that gives a source of truth about the
> software that's running in the VM.
> If we can have a GUID table with a flexible size that the host can
> request of the guest, then we can version ABI changes with new GUID
> entries.
> It's a big enough value space without vanity naming opportunities that
> we can pretty easily make changes without incurring any guest kernel
> changes.

So it's not only SBOM that you are concerned about, but instead want to
have a one stop shop for auxiliary evidence and get the vendors agree on
following the same GUID+blob precedent that is already there for the AMD
cert chain? That sounds reasonable, but I still feel it should be
limited to things that do not fit into an existing ABI namespace.

...unless its evidence / material that only a TVM would ever need.

