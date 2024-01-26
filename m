Return-Path: <kvm+bounces-7129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC3F83D741
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:06:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ACE029BD39
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1257679E4;
	Fri, 26 Jan 2024 09:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n0zQ4Lv/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B7467743;
	Fri, 26 Jan 2024 09:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706260454; cv=fail; b=FW8TLxD7ww0yhT8AMBkBbduMbNT2VjmcwOUXbxSMECjYtl74Pt7te/6k/P4+eDatlTpya6EOQC7iKEce9kq4IhLDXqJI/3eocRGvvHm8cjyzWH9dHAE/Is6YWuFcl/nHjeqVf6/B1wKxb8Q6CXjLrtM4IZnBI1PINBtaUzzFGLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706260454; c=relaxed/simple;
	bh=KQP/GTq1/C5cagNXSGA1oHGz28zgInC4LC+CMkUb9y0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nqS8xOw1277Kb5DDgZW2FXpLhr1svCcS7LFgasi9skIirIS7dBqMNGUQFwK+xB3eEQ51HQuTa3qDTsk/mBNUjDaULPThYONO3ZFDT3dQtuzY3y2OCcB51cX2RLqwzoCH03/h0vTRbOR9wG2Mx+3GU+vm5rf8derOR554BTQq4RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n0zQ4Lv/; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706260453; x=1737796453;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KQP/GTq1/C5cagNXSGA1oHGz28zgInC4LC+CMkUb9y0=;
  b=n0zQ4Lv/+56pu7iz5JWVtFRpXcfoSiqWaBDaqgwbOOg+8TAP+g1vw7CL
   5jS71evWp85FcfHE3KqV8Mujp5mFXOFYSX/BStsiPshEK7tltWLLoHJ1N
   9wUj8zRxq/ivkozRg5FhSJ4NxRQ5yA0lfoN2Z28FvfLuXWwgMemDDhqGc
   F5YY1dWliBFGewpIwWSfBS1Rh48KZBbLj5tRLwVwMbN6ukqhzoD6I0KkR
   Nn7j7T/oy7besRE8TtA9B7yX9f6glkLPu33mcqEkWBMCdrM/Vl0DHkEkD
   ssTD5kE6dMO+r8qS/R+lmD8yA30ojV+6a73nESfL7tNFILBL0neXazI/y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9541720"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9541720"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 01:14:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="35374467"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 01:14:11 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:14:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:14:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 01:14:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 01:14:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIZknrJaS2mAiUlhnNSTI5rmuNQxW2B/iiMDWAqGAMgfvRsMWUTUD2tirgqWIgoXFZ5Zkr3VtW6KYmIBJmm3tNP9S2AiBKS1ATTFgYCu46Bv0biZNKa3SarnqVx4zKfgThRjAUeYcNcPd9yp+Kmha3/FbH2HDpl77EUTDOaoiSxSNt6+jBqoE4Unm5c/eRKe9oQdyuaLu4m4agD+pYicvf6hHKCrdBIh/tRQiS19duLANUHC1GN0n5j67egaxbVZ7TcElCG9sx+GZfgvyfb5Gwe+o8KK6KnTchTWLByiNdlHhzvRJ4K1REk3VaxShjsnqfy1hqwMhgtGlRFXVo+nXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0wYQQI7ed8QSQEiiHdDovn4fSmrZr80YuDckn94EMgo=;
 b=WAb7upXDkUbnQ/M9ULtqtNHJ5F7hRMEWP0XxjxnGh8CxMQigTRBuLjF+panU9cr3dYVDFqP08EYChjxBV9nTYx48VvrpEkL7lEGz/Vjc9dO1ONdJkybsz09JUxi8sXL5XxWVu2IP35kn5S5FOwreoXlfgWXPehbE7jkfI+kYD9MQcE05PkoW3LbEjwDDX1ZUjTsjoQKpNBKwRQ/w6MlE4Nft9CaS5plqMyxxyhAut/zay44domTQYfW+wJYqFW+wzriQUTsmzOxaI7MgUWwPVngrbVEXkagifVxutazBdyD0DAyLs2ErtscsC2usRyFWaQ4shpNkal4lwkI4AW8Y9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7396.namprd11.prod.outlook.com (2603:10b6:930:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 09:14:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 09:14:03 +0000
Message-ID: <8cd0d61c-0008-4ddc-a93c-771c8c2c47e8@intel.com>
Date: Fri, 26 Jan 2024 17:13:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/27] KVM: x86: Refine xsave-managed guest
 register/MSR reset handling
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-11-weijiang.yang@intel.com>
 <ZbI1NqPLpnSZc6g9@chao-email>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbI1NqPLpnSZc6g9@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7396:EE_
X-MS-Office365-Filtering-Correlation-Id: 36773d7e-c57e-452c-1e85-08dc1e4f23af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V14z+84Wwwe83vjgFNkFyFxp4Y4zt+W5B9A/oMFVqMwbglJigpKyu+0++rPCtHuoJjRUiXRrf8+VL7Ga34zZf6KQ06lJGmWctOo/Kph11oo3EYfB/BRXrLyzgyTFBvUUgVyeCfhfQTGOsfDRUssdDnsq5Pf2l8fnJDoulw4vwkBq/6vPDOR6KdjAHw5T67owAizBgh8cS/2Rwqjp5+eShZ5WeerxgSpK2VIRELH2o7rZ6WvYQr1CvFD2CFcNHReGQ5jyQiWPgtZrEoE+H6NBgC6o1zXpMVGYiBnL3QUP5jN2074YqkKGvLXFWNzEqkOnUW+zVZBkblavh9IN2jlTXKLawv2JitTo8HCLu33bMxFrRc0q5o7y1FrhA5g8MvJos8Vx1OnTtG2fVpudTKC0JaiaO66Cm+4NpCMy3DF9bb5w29d7IrF1ZzRHUWpcgMtvlArMd0yxrcJEWkysSnMwM04iz6y5a/wNfzxST6GVlvA6eMC5sDgQ/N4M9KbMCiOe9Qb+xOtn6LJjARRcEr75R+/mVIAtpdWQmFG38Bc0LfNwIJlio9O1ccgE7h8wIqTje1sDKtWG52AkhUSBsDtftSrLKzWAWFKFXg09p/cmNeobjshAF/5yqaxO2K4Uot2QJG+KW+4FmvgUPLvOOibN7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(66556008)(37006003)(6636002)(66476007)(316002)(82960400001)(8676002)(2906002)(31686004)(53546011)(6486002)(8936002)(6506007)(36756003)(6862004)(4326008)(41300700001)(31696002)(86362001)(38100700002)(5660300002)(66946007)(26005)(83380400001)(2616005)(6512007)(478600001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkZrZy81OHVtMisramJ6K1BjUDI4K0hMNFdzRlprOFhHL3NoZytDRnBYK0xq?=
 =?utf-8?B?T3RJSGNhS3RvM2FwL093RlNVbEdGZDF5L3BhUjJzNDhIOExWcEhYNXNOU3pq?=
 =?utf-8?B?WEtxMVdzeUpCWVZuMC9PTHJyanljOVVhV3pSRnZzZHh3bFNBSEZiWTBqSm40?=
 =?utf-8?B?MXBlWlRlcjBpUHp3S25UWmNldXZsN3lla2dmMytVWXMvanM2RTdBdVJrUTI3?=
 =?utf-8?B?WWx4RUc4ZFFmYS90YXZPUUU0ekFNTGpaSTdpNHBacGVFcitORFgyWXJaM1I1?=
 =?utf-8?B?Q3JUb3E1aEtHVXFrcHAya0kwMkdFaElLVDhFWldndVVxenVkK29xQlI4ZlNw?=
 =?utf-8?B?WUJvZFE1QmJsb1FmRm5saGwyVzZnNUtvZEpWSjJDOUNEVCs2WjQ1VjhvbGZ3?=
 =?utf-8?B?WE81ZnkzOU5ZOUU1VFFOeGdGZFFnS1Q0WndxTkh2Q3RLNG5VM0xXQ21RaitY?=
 =?utf-8?B?THZBT252MllHdnJqS0tiT0Y4elBJdWZVN2d6bEhUNUx2SlBNa2t5YkFURy9H?=
 =?utf-8?B?UC9XcVFTSEJ4RjllaGZ6THIrNzRQMUtYaUdyNGN5SUhKdXBtNitOdE9Ed0VL?=
 =?utf-8?B?Y0pZUHJwOTVzbGNLR1A0aS9WVldOZ1JKSU5SVng5dThqYWtTRHJPbTJicVNp?=
 =?utf-8?B?QjU2cU9WSnFYSm9la3U5S2lYQ25XL3RiKy9lUVAyNDFBcFp6VDBZcjUzSHpa?=
 =?utf-8?B?cEs1SkQ3NzduaWZ5aXJLa3VrWHYwYmhmMzVmSDRMMEt1RjFMZFBOY0ZGZnh0?=
 =?utf-8?B?U0YyQUprcVJLVXVORGF0N3FWdngwOEoxeEJCUFNKWERqeERLMUsrS3JzNk53?=
 =?utf-8?B?ZzNWaGtBd0dKc2N1SXlnVVBXVnBaY3V5bWZpSmZSZnJGcHU5bC9pN092YjZW?=
 =?utf-8?B?LzdWcy9JSnBTWStvVVozYVpuWW1FRklKdndHblZzOXJiRzRxcU9TYW1KblE0?=
 =?utf-8?B?N2FWWGJFblI4M0JSWE1vdm1oeTByMmxmdGUyWUhMUXhiY0RKWHpOWGUweXBX?=
 =?utf-8?B?OHBYNVlRWVRQWHVCQlJBMzlQUUlxRmxWVzhhbnJqbmdoMGs0MCtvazE0QzZp?=
 =?utf-8?B?RXJueFhZTy9hSVpOR3B0QkpuYzRsa2RHbWpyZm15UHdBekFzKzhobG83c0lW?=
 =?utf-8?B?cGZ5NWVjZlB1QUJIV2hLVzFDTEI4ZzQrd3NHV2dSUXRnSkl1TFdhcS96UGp0?=
 =?utf-8?B?MkNIcDJZdmlBa0o3dVgzai9wT0E3V3FhVXlGRGpOM29xUXJqQzNCYVg4L2N2?=
 =?utf-8?B?TnpWbmpmM1cvR1ZpZFQwUytmb1haek8xYlZ1WkJlZS9BbWlraXhkamUyMDZy?=
 =?utf-8?B?eWlhVUxWRkpwT3llMVh3WmJIN0NuK2pyV3FpT09wdDRpbzRMTWpZYjJrYlh0?=
 =?utf-8?B?TTJUODI0NDJ0SDFMQityenFCYWVKT1VuNFFoNVowdWl1N3Zsc3NGWnVhTm1F?=
 =?utf-8?B?R1htWDBmN2UvcnNWYXU5bTY2NVk5dzFaN0dERElKNWRPV21xZ2pkajUwMXhY?=
 =?utf-8?B?WGZaMVg0bFlqVWl5aXBtNy9GN2k0aFFXVVNYTklzN1FCOWVka2s3YW9XejNt?=
 =?utf-8?B?Wm1PTEFGWGtCNlBuenZKYVZhV1FZclR1L0VUV2pJUStiUkRhbEZRWVAxVzM0?=
 =?utf-8?B?RjNJcmtNZFVRYTB4SkJ4SmNyeXF4R1RzSDFBWWwyN3ROdmQyWXRkaExiOHJa?=
 =?utf-8?B?Q05jVkVNMTBPdE9vaDlkYVJYQ2dtWDZjVkY0Ritvd1ltZHloRzZHTVREa2JL?=
 =?utf-8?B?WUhhSlc3b3lndlV4bGhRdm0wQ1c1Q0U3SUVoNjV0NTFaRmhGYWRjdFhqOVdD?=
 =?utf-8?B?clV1SUs5U3Q4bzRpbXA2cm5QR1dybFNJcXlzcWxPTTVsZzRrRGZqVzJFV2hi?=
 =?utf-8?B?WkFtaFF2UVdmWmNzSUhVRldPbUxWZFU5ZUhVaEUvRG5mZURLVkNrelFieUpE?=
 =?utf-8?B?dG11ZXJOQzA2b0d6TGNLRWllbU1tQzc2Z0dSWDYwbzdsVFkwZnpDZWtPQVJ0?=
 =?utf-8?B?aGtKdkFmYmY3RHduaFdMS0xFaEJvV1M1TUdMMnl6MDMwaXdudDVJajlXNmZo?=
 =?utf-8?B?a3YzZForUnpUYjhMTlU4Uis3cGl4Tlo1bEFZelBudFdXbWhpZG80VjhnV2ZX?=
 =?utf-8?B?Yk5BMzFKaTNlS0VBSmtlS1pIWVZteUFtOUlXeUtSc3lSRWl0NENpTUw0U2RX?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36773d7e-c57e-452c-1e85-08dc1e4f23af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 09:14:03.4063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91foQQfUlJv7vzmvMwE0JQuqakWNdG7Iaa582weaV78SFq1wCTGYy7lvuXU0Bm/IDAszdBlW1/I+lh9D2fJFUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7396
X-OriginatorOrg: intel.com

On 1/25/2024 6:17 PM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:41:43PM -0800, Yang Weijiang wrote:
>> Tweak the code a bit to facilitate resetting more xstate components in
>> the future, e.g., adding CET's xstate-managed MSRs.
>>
>> No functional change intended.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>> arch/x86/kvm/x86.c | 15 ++++++++++++---
>> 1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 0e7dc3398293..3671f4868d1b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12205,6 +12205,11 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>> 		static_branch_dec(&kvm_has_noapic_vcpu);
>> }
>>
>> +static inline bool is_xstate_reset_needed(void)
>> +{
>> +	return kvm_cpu_cap_has(X86_FEATURE_MPX);
>> +}
>> +
>> void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> {
>> 	struct kvm_cpuid_entry2 *cpuid_0x1;
>> @@ -12262,7 +12267,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> 	kvm_async_pf_hash_reset(vcpu);
>> 	vcpu->arch.apf.halted = false;
>>
>> -	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
>> +	if (vcpu->arch.guest_fpu.fpstate && is_xstate_reset_needed()) {
>> 		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
>>
>> 		/*
>> @@ -12272,8 +12277,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>> 		if (init_event)
>> 			kvm_put_guest_fpu(vcpu);
>>
>> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
>> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
>> +		if (kvm_cpu_cap_has(X86_FEATURE_MPX)) {
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_BNDREGS);
>> +			fpstate_clear_xstate_component(fpstate,
>> +						       XFEATURE_BNDCSR);
>> +		}
> Checking whether KVM supports MPX is indirect and adds complexity.
>
> how about something like:
>
> #define XSTATE_NEED_RESET_MASK		(XFEATURE_MASK_BNDREGS | \
> 					 XFEATURE_MASK_BNDCSR)
>
> 	u64 reset_mask;
> 	...
>
> 	reset_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
> 			XSTATE_NEED_RESET_MASK;
> 	if (vcpu->arch.guest_fpu.fpstate && reset_mask) {
> 	...
> 		for_each_set_bit(i, &reset_mask, XFEATURE_MAX)
> 			fpstate_clear_xstate_component(fpstate, i);
> 	...
> 	}
>
> then in patch 24, you can simply add CET_U/S into XSTATE_NEED_RESET_MASK.

Yes, the proposal looks good to me, will apply it in next version, thanks!



