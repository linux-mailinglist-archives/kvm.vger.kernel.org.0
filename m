Return-Path: <kvm+bounces-6726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2181C83895B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:44:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 915CE1F2AC03
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 08:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ABD56B90;
	Tue, 23 Jan 2024 08:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZHOvsSIV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C15647B;
	Tue, 23 Jan 2024 08:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705999463; cv=fail; b=D9vE5Wb69Hz/uSaj4ZHtmEJcUvbdR3/gDPbtzYVVnarG4VkHSQMxuYBXs7YgsOMBaqU/8aBNhJKkK9FUNBMe4nUTmIR0PoJ+sKv+CNCePis0AE4L7JD6CQV36BABy9DHYfIsQAWfZtkeN4znCMfzgAMwhNiqbI1vZpzcWUj7a7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705999463; c=relaxed/simple;
	bh=jodc1euybWxDRa4F7gB42ICIexova8iu1LGNH2125zA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S48TBMAXcSB5LvnIu/4usDQ/VT7ZNBHgyVRm9lSyuiJOPyih9VT+A0lAslCuAlf8FDMfPRPZZ3D0tKqU9uXhRDNC3nN8kqf7PKhIPvAPoCxICbcHKf7YNk+Gme7fqJIZTBpz1VP9AUghDD9AwLjCvGNBB/aviwOL4FOJPsebeQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZHOvsSIV; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705999462; x=1737535462;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jodc1euybWxDRa4F7gB42ICIexova8iu1LGNH2125zA=;
  b=ZHOvsSIVv95kb16/U4TfwfOFE+sHpucSt2RTa26STX0iLKNU2KqYDzyJ
   qaBohA3GqXOQlFzT1O6AVK5qMMDp3pd/kOkAMMns7vgCpP6ek0JWAh4xR
   7CsxZpebMjmUY32I+k1B8Bn+C7+kEaCRrquAaOuKFfw9nFq9VCjIod6p/
   wfDM04bITJX2Y7gm/2E1YBz4KfRw6oWl+k6fg4XGXPxHjEHObjfKlo+5F
   Wqzsr9V/Ba7vEI2/rnKaWigcW52Jg3Dtv9kQ/cGC9rjDNBt8Yq6SXJtjm
   VpRgmHqt/+MxwdtOPXxOnpju+OLeJfp3d66EMmhvU1MjWpM5H8p37kfkb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="20025572"
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="20025572"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 00:44:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="34334015"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2024 00:44:22 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Jan 2024 00:44:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Jan 2024 00:44:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Jan 2024 00:44:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4x3NGltNeVijb9l43riwkHJ3bRNIUCUS2/2/QpJHUk9BKMSeDTwfY09ui8Lp3nCZXBMCwoOPYC/S5VbqoAcq/40m/UQHAxkDk1/s3enFPofPI3FMxvavrdepaGXYX4Hg4UF2yx/56VP+om0sG+L7LfdI3vrrXhpOwc0/fVUkfSwfszG+D3mhB3ddSyVuegHywvbddmOxpdF3cS04bsjXkQjQWKMo4s1ktMWsl0vUygII2zVKUm9cP1LavVXe8/B2NbkgjlSzGapjkFe+/EkC9CRdi3D2IrTdA5E0Smrc6hud+2HNRLNhDn9y5uP3JrbxykTKKESgoQX5PXM0L0iig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Os9ZnjgqjNOFjM//r/RfO6D2IPqMEviCYwH/EuFDLpg=;
 b=iP0gsMqh82PK7AoLVf3efVAo7bgusk0FGfd4tZyLj+j/nbHp68Nx6n1NwxccmxYig95o86o7NsjWfrR+obtcAY5pHC+q3ATguIiEqD/XlndeUx5HrUCXz0msiWdyUfSA465LvJtGZ73oEvQ3VzU9ySCIGgwyojAfPG/S4J8Pqp27UMurgrflCuOk3eRXB/Pc+KzVH9ZVHn3nr+yQygD9juikTz58kZoKS7IlhxnZIsro3Bn7jKMPkTsxHIJjMVcrgLZotqMaXdgxF/aPHYbt6ZTN7PYAcGffO0QHNxig2wBdi0/3gTqzZkXGJcv8+UJVgFE4Woey80USmAdg72tLWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB7558.namprd11.prod.outlook.com (2603:10b6:8:148::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.22; Tue, 23 Jan 2024 08:44:05 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::c44a:5272:200c:4904]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::c44a:5272:200c:4904%3]) with mapi id 15.20.7202.035; Tue, 23 Jan 2024
 08:44:05 +0000
Message-ID: <dea1ddfa-3f70-49ac-99b9-1077b031451c@intel.com>
Date: Tue, 23 Jan 2024 16:43:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 060/121] KVM: TDX: TDP MMU TDX support
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <a47c5a9442130f45fc09c1d4ae0e4352054be636.1705965635.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <a47c5a9442130f45fc09c1d4ae0e4352054be636.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:54::23) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb0296b-6f47-45f8-ac95-08dc1bef74ad
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrabTqlnWGtW/enx1A2lW1eRD5DNxcPjPm6wvmxbhGVRItlQTGYbIb9PgA5xCtkjWOvKbwCv+SZkuacGsnJFT/XB3KtE2GZNekBv92KmaTWNT36aJg0YVjy2jRHPSX9jl3Qi0a3UHzTymtU8WEHRMuUtbWLjBrkgsNqhYG5D5J696OKTe+CYW5bakNH5bXIySEE7MonI2qegpyQA2R8vheTzdFIuNDxcLq48H2HfSDHh46Mm0O3ywYunGZuAvgIYH8tNA+WAQaao2D5za2Sft+vubdj0RRxAu9qOTW5b5L0BiysMJiVD9Z99GDr0JUc4ohsPQBgtc5EgY576cCArDfTT3QQp8S1PKmlwtfuPcaNSvU7wFnhlqNtWW2CAdnIU3HNeog6yvd2/59KAz6CzGzAjNa4H6u7eMCFy3GB9NGtwohcX7WQobwCZjAoRR9/ZZN/+u3sjBLgW1tsD7yHBvCUb2zrwMl2axOoDTk5Zt39GbzRI37WXbIoqwmSQjILbcKyM70058F5vcCMqsv32tw2P+LLx1ZYQOP0ka29ALLjvVHYWVYMr4yLF49ByGmo3xObRwFG5GsfQzhnKf0sTElN1FCoJ7yIHWxm/PQJhr1kCBcLtdx7Kgkwk7lESzgxO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(366004)(396003)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(2906002)(44832011)(5660300002)(31696002)(86362001)(36756003)(478600001)(82960400001)(38100700002)(966005)(6486002)(53546011)(6506007)(83380400001)(107886003)(41300700001)(6512007)(26005)(2616005)(6666004)(66476007)(316002)(54906003)(4326008)(8676002)(8936002)(66556008)(66946007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q05MaGYwbGJTSmhmQjZWcHVueGFFYlZvdnpFSVUzb3pINndlcVF5UFdyTmxH?=
 =?utf-8?B?VE9tSHNJWGZta043Z0lJNHRySWNZT0VtTjdabnpRaC9ibGZzU3RTa0Jud1Bs?=
 =?utf-8?B?M3RyYjNsTHJpc0Y3aTBIQVczc0pXeFd1VGt1L3F0c0o0UDZMeEVCR3dwMDFt?=
 =?utf-8?B?T2pnSjg4YmdNb0tocFF5a2ZnL1NsSnVsTUkrV0Voa3RZbnVZWnQ1WE9wVWZU?=
 =?utf-8?B?SXZ6aEZSd0tNNitNbG15WE1OU3ZDVHZnYTdSSWF5UXdiZmdmeVEzV0VBOUVj?=
 =?utf-8?B?OWtIcWZLSW4zOVhkWkZBSDlnV0pBTFJtVkxaK1ZJVmJIRDNpeFRJbEEvaEVt?=
 =?utf-8?B?TEtjZ1FrS0J1MnFqaGdWSDk5allEOFFlck9jaUpnNVJzT0RLcGUwd1IyY1ZU?=
 =?utf-8?B?R25GNFlKY2lhTXd4YitkMXoxd3NkRm5OTUlPS0QvcjV2YXdPc0J4eEI2Rmcx?=
 =?utf-8?B?a0Fud0ZrcGdYSk1MeEJhcFBSVUhocEZqeXA5VFUyTnJwY01FcXFtZWxlNWtF?=
 =?utf-8?B?SFFqQU1wZmkrUjlJUTJzMXNPUE9IdEZ2dXJTYi9BVVRodmVEQklYUjRlQkdF?=
 =?utf-8?B?eFFYWU80VnZIb3hOZ2JwV2hndDFIeG1ldEJsYnlwTnRkK29KdFBCdzFsRWQy?=
 =?utf-8?B?RWwwclRsNGs0ektoVE9kUDlCbGc5anE0RGtxSTNXakpwT0J3bHVhUzNUanZH?=
 =?utf-8?B?VytoMERBVmRkcTRUSHpiUHVnNkdJR3NkRWdSemU3cVpXazU2ZU1ndjdycVpW?=
 =?utf-8?B?Nk9LVk5OaEVBaGFQNGROMlEwemtkVnJHMUQwbXRRNmV1Y2RySm1WbGVxSkJ4?=
 =?utf-8?B?VkQ4ZXZVVGFXSVUxclk4bWJDd0FPR015WWdKSWtMendtT1YzVWYyNnZUWmMy?=
 =?utf-8?B?WmRWY0lnaTNMSDVrWTJpTTd4UjcrVEhya0RYNkdibGVGd05hN0IwbEYvN0hF?=
 =?utf-8?B?YUljNXUwWjNHUUFyYlNzdVhLZlRPTmJkUlR1UVV2eXA2OVdjT3BKak9KOG1D?=
 =?utf-8?B?ZHVESW1XMTBQaFc2UDd4OVhOV2Z3Y3dOcDdWWkNuRUJmbExXNy9ZRFREY0JI?=
 =?utf-8?B?bU5XZTlCbGVBaGRHZEVJemIwWW1qT0xQaTJGMDB1TVlWQ3FqRHl4QkE2UjNs?=
 =?utf-8?B?SDVxU0REaUQrYkEwZVNSYU9SRVQ5bVNLYmZSNkN6QjkwN09sMGthaENMcEs3?=
 =?utf-8?B?RlVTcjBOajc1ZmpTc0szWFpvUDhGSEtlcW95TVNrZm9aVms4ZWtZUThiQitt?=
 =?utf-8?B?VCtMZEtiQk1Bd3pTYXdMeHU5Q2k3ZzdBdXFHRDl0b0dqeUkrTE1wdlBYa3Zo?=
 =?utf-8?B?R2ZweGdkWld5dTN5QVh4NUFrRnppM0FBTnowdTB0TDNzUWUwTG80ZE82Rjdw?=
 =?utf-8?B?QkdaOVFxOG9IaXU0ZGtRQzZOWjgrNS9uN3l0M25EZTN2WUtib3FzM2pQQnhy?=
 =?utf-8?B?V3pBQVBjZDJ3ZVkxTWFmeDMzVnlHWUhsRVhRbjdLaFRHaE10b3A4WjlWaEpK?=
 =?utf-8?B?WlFHYkZZNU91U1k4WGNCd0RJYjltaE96b0hUZkdvUTBnYjhZbFp5bXRRTmUw?=
 =?utf-8?B?NGJPa0lIdVN2cWE4VWFEMDc4Uk4wZ0IwcythbWdkNDd6cVl2RWpKTU95UWpT?=
 =?utf-8?B?dnA3ZXlGR1JNVzRkMk9pbkF1TllseElCODN3QWU1TGVXaGZjSlQyak1iNVR1?=
 =?utf-8?B?bytzQTVEZ2h6emhLbEJwNFNxa3FkUWNiU1dNN2V1OGRlZ3dROFYxb09nWXFF?=
 =?utf-8?B?SlFpZ0UxU3ZHbXBuNlVPZmhQZU93MWRaMGh6VzYrUmJSU3B2ajV2Skc2UGY1?=
 =?utf-8?B?QzNSU25rK1R4T0ZjT2U3TGdtb1JCclBZeFVuYnJ6TTJQSGtLSjUvcFQweUV3?=
 =?utf-8?B?SHdyS0JIOG0vYjhEY3VmcE5FSFhtWGZOK0srb25kWjdGeE0wVmhjMDNTTHYr?=
 =?utf-8?B?MjFOaUF4OFp4clNNaEZkc1Y5UGZUU1FOMU5MYjZDRHl5bGNpTzVzUEh3U2or?=
 =?utf-8?B?eTN6bGFVNkhBZmRPeEVUakZVNEtjMWdJUGNIVFVUanJwN21NU1hzVjNCc2xk?=
 =?utf-8?B?Mk9Hek1QZUFGWXQzWUNqQ1MzZlB5eFVaSzB0S3NtRU05NkV6eWNjWHdHQXc0?=
 =?utf-8?B?bWxHNnNPeXA4U1ZLanR0MFRQdCtreGY4ZzZURitjb2U3cGtoeVBpSHlwT2xZ?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb0296b-6f47-45f8-ac95-08dc1bef74ad
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 08:44:05.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lC8gS1rZZDOlLCWPIaN3oIpZIqPQ9zcj9bQPBHntIOTS3sK0UhE93EJliUwFetn1xTOUrcKGMROHNkgIZH+z8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7558
X-OriginatorOrg: intel.com



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implement hooks of TDP MMU for TDX backend.  TLB flush, TLB shootdown,
> propagating the change private EPT entry to Secure EPT and freeing Secure
> EPT page. TLB flush handles both shared EPT and private EPT.  It flushes
> shared EPT same as VMX.  It also waits for the TDX TLB shootdown.  For the
> hook to free Secure EPT page, unlinks the Secure EPT page from the Secure
> EPT so that the page can be freed to OS.
> 
> Propagate the entry change to Secure EPT.  The possible entry changes are
> present -> non-present(zapping) and non-present -> present(population).  On
> population just link the Secure EPT page or the private guest page to the
> Secure EPT by TDX SEAMCALL. Because TDP MMU allows concurrent
> zapping/population, zapping requires synchronous TLB shoot down with the
> frozen EPT entry.  It zaps the secure entry, increments TLB counter, sends
> IPI to remote vcpus to trigger TLB flush, and then unlinks the private
> guest page from the Secure EPT. For simplicity, batched zapping with
> exclude lock is handled as concurrent zapping.  Although it's inefficient,
> it can be optimized in the future.
> 
> For MMIO SPTE, the spte value changes as follows.
> initial value (suppress VE bit is set)
> -> Guest issues MMIO and triggers EPT violation
> -> KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
> -> Guest MMIO resumes.  It triggers VE exception in guest TD
> -> Guest VE handler issues TDG.VP.VMCALL<MMIO>
> -> KVM handles MMIO
> -> Guest VE handler resumes its execution after MMIO instruction
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> v18:
> - rename tdx_sept_page_aug() -> tdx_mem_page_aug()
> - checkpatch: space => tab
> 
> v15 -> v16:
> - Add the handling of TD_ATTR_SEPT_VE_DISABLE case.
> 
> v14 -> v15:
> - Implemented tdx_flush_tlb_current()
> - Removed unnecessary invept in tdx_flush_tlb().  It was carry over
>   from the very old code base.
> ---
>  arch/x86/kvm/mmu/spte.c    |   3 +-
>  arch/x86/kvm/vmx/main.c    |  71 +++++++-
>  arch/x86/kvm/vmx/tdx.c     | 342 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     |   2 +-
>  arch/x86/kvm/vmx/tdx_ops.h |   6 +
>  arch/x86/kvm/vmx/x86_ops.h |   6 +
>  6 files changed, 424 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 318135daf685..83926a35ea47 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -74,7 +74,8 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  	u64 spte = generation_mmio_spte_mask(gen);
>  	u64 gpa = gfn << PAGE_SHIFT;
>  
> -	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
> +		     !kvm_gfn_shared_mask(vcpu->kvm));
>  
>  	access &= shadow_mmio_access_mask;
>  	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index e77c045dca84..569f2f67094c 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -28,6 +28,7 @@ static int vt_max_vcpus(struct kvm *kvm)
>  
>  	return kvm->max_vcpus;
>  }
> +static int vt_flush_remote_tlbs(struct kvm *kvm);
>  
>  static int vt_hardware_enable(void)
>  {
> @@ -74,8 +75,22 @@ static __init int vt_hardware_setup(void)
>  		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
>  	}
>  
> +	/*
> +	 * TDX KVM overrides flush_remote_tlbs method and assumes
> +	 * flush_remote_tlbs_range = NULL that falls back to
> +	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
> +	 */
> +	if (vt_x86_ops.flush_remote_tlbs ||
> +	    vt_x86_ops.flush_remote_tlbs_range) {
> +		enable_tdx = false;
> +		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
> +	}
> +
>  	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
>  
> +	if (enable_tdx)
> +		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
> +
>  	return 0;
>  }
>  
I hit some build issues when CONFIG_HYPERV=n:

error: ‘struct kvm_x86_ops’ has no member named ‘flush_remote_tlbs’
error: ‘struct kvm_x86_ops’ has no member named ‘flush_remote_tlbs_range’

I think it should be related to the commit
https://lore.kernel.org/all/20231018192325.1893896-1-seanjc@google.com/



