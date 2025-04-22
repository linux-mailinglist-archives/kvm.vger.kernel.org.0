Return-Path: <kvm+bounces-43752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD135A95F83
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60B7188615A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19A21EDA3E;
	Tue, 22 Apr 2025 07:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ayyTpZv/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF4619FA93;
	Tue, 22 Apr 2025 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307113; cv=fail; b=dIqceoVHqlAdcXIWQLqXHVt8YQ2/aUlPrM3N4k2KB26ma6+pD6RflrqV4NtweCI8aL9iOITemZr867HNu+zcsBwEwCHmSoCwty0yluiTF0skr3l2WOtSCYiU+MeHkZi9RbkepE2GWll28/cd5EeSYFWouohuITCOW7A4DbHpQgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307113; c=relaxed/simple;
	bh=tNO1z9pSDPmUIwGiuOP+1QKc5Et2iFX/pbkZBYIiRyE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FZBpZC1HCYM7ZE6jSO8HbT8fFrqL8lNdPjfgybL+w6Zdjdqa5HaznOnrffG8knhb3X5mIJzweEzGcrqJ6YVg0j8pEXCgeKqy/FA9LCZR5uU+57Vx98MxdsuFrNOucBPMOdQbCXOnujgBUXkTHlWHTmGvrRfiu2gwrwLwpGufpss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ayyTpZv/; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745307112; x=1776843112;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tNO1z9pSDPmUIwGiuOP+1QKc5Et2iFX/pbkZBYIiRyE=;
  b=ayyTpZv/KHsvZgmAI2dKk7JYZrzhgVwoz3HUGCaNbJCBz3TDk/kbdDKu
   i9KZoDNs/DsYTzCDDfQdn03Biixuq+0D6630lUTsWNEZdfJ7ohcJ6FBK+
   DFabcT70nK628RcBZwCTqrKUoUCdpi7Bpu6tdW893Ixws6IPd10qT64lc
   gyI6hODpnhkW/6/iVO+3YkNV6V0xkt1VbTrkYh8DtFOpJVltnST+viL6K
   nfun8B76DMeDOSBVntFLwqihgX2tYozV3wZ1v86krODi2Iy7vojUHTLGX
   sKu++uq2S59ghZuNydHE2UwcyxYxSHIt2YGcqP86j/laC9zDxYgehxnp2
   Q==;
X-CSE-ConnectionGUID: /0N1cUSnR5eh+3cqdRUbrw==
X-CSE-MsgGUID: zFQsPH6pRA60CeSs3TUYdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="46741135"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="46741135"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 00:31:51 -0700
X-CSE-ConnectionGUID: 1qh+aaCwQbuKqHNk1Vbdlg==
X-CSE-MsgGUID: xnoRYRfYSMi6Nt7kv20R8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="137091702"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 00:31:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 00:31:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 00:31:41 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 00:31:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2hzK9bBtnduDbjeY8wb6LTDVWh6CiV7mUHdzU6Nv/AMDPLgXa0jZERDr3R0HmolwIU5xCbKO3OLbnkQKrGWlaY6Ppr+SJx2gOUeS+AJhsPkUu8TyZu7E50dBB+DrcU5/Kl3Dy4m0UHBLj+QenRWWrxAyAqpx86yA9eGapkcUf8iGZ404gAoKNw5WhUy4d52RD5eL03hR6YL9/bt+Si/dNrtlm7cIwJzA/VImxcrwzYMP68hXsRRXddXJOiMJqWG9mmwpgT/Z3y2qDXscgTCOsjBFO39azJWNE+3nM1E7R532503jEifXIaqj749D3skglwdNu1ufC+MtzB6EtxcUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xwT/JfGWJca5STsqGGWtbZly089ERXAGhEDQp+0R14=;
 b=f4fRUUjP2sGw/GSoNGRPebc9nhnUdDvpgm6s1aHr1671YmQlyo4vqNgy/CqTUP8H/vYMjFK8Or+98URGKY0mb/is4OkBKN57TBFRETY4UomusYKdF73/9h8Z7skYEuYDXf5LcIOksvK25taczURoJ5S/Rqk+GSV0fZ6epdFa6F4dM2lVSPBRfJH75Lz2mAw1YNJUUN3t6VFFidTscvOXYplcvA3JxbRhp+3opK4lYwDrjYM79mY49D86qdRcbTzzXhhAkH8k/EohRldGwhBdBMeYslHO606Yhp7ZnwTzotaaY0mQFAuWCfMr9j6cAJO4o9impzuP9P2pS677kNT4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8)
 by CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:95::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 07:30:23 +0000
Received: from PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301]) by PH7PR11MB6054.namprd11.prod.outlook.com
 ([fe80::a255:8692:8575:1301%2]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 07:30:23 +0000
Message-ID: <0a175c77-9911-47a4-ad4e-8bed07fb9cf4@intel.com>
Date: Tue, 22 Apr 2025 10:30:12 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>
CC: <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250417131945.109053-1-adrian.hunter@intel.com>
 <20250417131945.109053-2-adrian.hunter@intel.com>
 <CAGtprH8EhU_XNuQUhCPonwfbhpg+faHx+CdtbSRouMA38eSGCw@mail.gmail.com>
 <aAL3jRz3DTL8Ivhv@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <aAL3jRz3DTL8Ivhv@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: WA2P291CA0022.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::24) To PH7PR11MB6054.namprd11.prod.outlook.com
 (2603:10b6:510:1d2::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6054:EE_|CO1PR11MB4787:EE_
X-MS-Office365-Filtering-Correlation-Id: eb2b16b8-68f9-4cc8-c5c9-08dd816f8b17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SFVBV1BIdkx5RWhHOEpqQ3llbkMrM0xRUmYwdEFZS09VMWgxS2IxSTJLaFJl?=
 =?utf-8?B?Qm1pdmtHN2Fhck10Mm1WZVRmMVkzS1dndWVGcFZXdTVMRFlBdFlXOEZIUllm?=
 =?utf-8?B?MXU3Z2llNmJtd01waDBJK1RUTjVMWFhNMlZsSnNmcTEyc29oWXB2YTM4UVlu?=
 =?utf-8?B?bXdjSG1pOGRXaitVOFRRdW8wdHRVYkJoWXJsTVZVR2xETVAwd2VGRkZwOHZr?=
 =?utf-8?B?cldRektieU9nS2xySEFoZE1XcXh2YUxSSlhET0FxSVlVMWlJVjdJSkxpeUx2?=
 =?utf-8?B?bzJiYTc1OFZpbzN1ajR5dkxwczlPVzlBajBZVVJVL3JxU3d6TDNUSkg0aFBM?=
 =?utf-8?B?RHBYQnR4bGdRTFdyRzA0K3pyYWhBazV4SnA5NlJ4NXNsUXR0M0tEZU1HZFlj?=
 =?utf-8?B?bU9UR1JZKzBmQ0dtZk1XY0p3YzNhVG9uUU1lamxKRkcwUTZ5bGV4VDJhU29L?=
 =?utf-8?B?NTAwc082anFtQUdlcDZKT1h6Yjk4NWFkbEU3Ym5DREdsYnhnSmdpa2xiM0RB?=
 =?utf-8?B?MWNtQlF6VGlKbEpzQWRLbXZSbEN5WUVwanlVQVdKNi85dENmS3k0TkYraWw2?=
 =?utf-8?B?TlpCSDQ4ZlNNb00rN2tGcWlMaGJuNlo0V21hdWNTQjFVcXN3OVAyUmN5ek84?=
 =?utf-8?B?UnRBbERvbVczNFJjalRKWkF4SGkyOFQ0bXFFYWgwSkpZTDFxWnhxRkVUdzJp?=
 =?utf-8?B?NndvVnNrZjZkaWRmNEZHYUpXNHltb0w0ZytQbE5Cd0ZaQmFlNGVUMll3amg3?=
 =?utf-8?B?QnFoWFRRNWVSTHZMUWpPejBrM1ZRREk1ZUw5Q1JENWpZVVBEd2hPOUZoVEdU?=
 =?utf-8?B?d01SbHRIUkhWUzdFUVhyUHVmK2t2ZW45NG9Tb0VKWDYraVNmVTNsWGJoQUt5?=
 =?utf-8?B?bDRqeGpVSjFhWitmVjFndmdpemJGS0VuVUpHVlhqWDlqN052REltVmhZSHBW?=
 =?utf-8?B?ZGtENS84RzljdDh0alV0eDh0KzhONEJINjdzYWQ0OXUxNzE4VmRFekdkakZw?=
 =?utf-8?B?cmNhYXc0T1Q4SGZ3L3g4L3UvODY2bWFDcTJBK2dxVmxObjkxbTF0VzE0RUQy?=
 =?utf-8?B?a0NpNTBCUStlaVB6U0NpL3NkQTlnL0J5UG5XSVphdE92b210Q2ZlU29zUHhS?=
 =?utf-8?B?YW15L0c5akc1T0VpZ3k2dCszS0NyRVEyVVk1Z0JHekROZ2VwNzFyWjdLUlhR?=
 =?utf-8?B?U3VBa1AxUkd3dEY3RElGVDZyT2NxYnJIVW4zRjAyYXl3QmNtaHRNNUJiOFJ2?=
 =?utf-8?B?Wlc3cGJiWW9NZ1hNNVg4QXZpVzNUbE9lMEtDUjJDZ0tkQjhWcU9BS0duVWpm?=
 =?utf-8?B?VG5ETWxUR29RbUlCRDFkb3lzS0RMb09mWlpWbDhueDNFVSt0UmtTQzJtSkNq?=
 =?utf-8?B?TjdoMGU2akF2dmhiVTREZUVlbTVaOTVmeXBRT1MzMGhEZW1GamtOQWRkbEFC?=
 =?utf-8?B?N0NYUENZTWZLTEc3MEVhTDNrZUtPREgrQVZkaW5aMG1Gd282OFVTTzZMYlVi?=
 =?utf-8?B?VlhJbW9POHNacW1Jbnl4ckhjYjlmMkJPZW9jaCtHVGo3VWlSVEE3ekt3aFU3?=
 =?utf-8?B?azNibDRYTVkvOXVscHQ1VUNBZjdoZHZYbUdXOWlHMFNWK0dLdFZBbkpmUzRx?=
 =?utf-8?B?eTkwU05RM05qRDlWM29OMklCZ1ZsTk00a0VTczJSWFZqZzlaaUR3ZVpmZzVy?=
 =?utf-8?B?Y21JZHdVamd2ZzFreHloS2lSWEl4QVNjYnR0VGFiSjJMalJHbTB1QkN3OU5a?=
 =?utf-8?B?c3UxM1NOd2hmb1kwczBGYkxlR29YYk16dUsvanZtaTRMR3lxMW1UMVg4S0hl?=
 =?utf-8?B?ZVFQVG9IaGlKTWtlcW1vbzRRS3RVQWRqd1h4Vlc4MlBwNzZ5ZDFvRndSTHc0?=
 =?utf-8?B?UExsNVptRHF0Z29SZllXanJoeHYxcDAyUHY1WFhUTk5mR0VLWkh6Y24yK1pP?=
 =?utf-8?Q?grIhlBarFoA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6054.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjNUZnJQSUgzYzJjekNBK1JGY1hWL1FVUHNkbGVCNmttc3hhVWNmeVhiZmJ4?=
 =?utf-8?B?K1VVV0JPQ0paY2dpTEptYUR3ei93bFUyVlM3c3lFUC9kTElIVzRWVCt3UTdv?=
 =?utf-8?B?RDg5WVAvRTFWSU4xSEVybjV4V3lHUS9WN3p6Ynk0bHFIQUJZU29NME5OVGhi?=
 =?utf-8?B?LzNEM2VxS1Znd3RvN1ExWGpvTlY3Ym1Zc3IvTWR6VjBCc2Z4Sy9sZEp3WHoy?=
 =?utf-8?B?K1lpdXlLRkl0aVpDSDNDSG9RMERiZWs4clN1ZnhDNERjMTBYNDN1UDNtRjd4?=
 =?utf-8?B?QXU3NTBSNzZ3dEJaUjV0TWlydDNDR21KTE9tU29KVzBxTk9BSXkrY1ZWYjhP?=
 =?utf-8?B?VGJ5Mnd4aTBUOUZ3TnJkR3VIbnpReDRWd0VWazBFWkZFdlJXQ0h5VlF4N1hl?=
 =?utf-8?B?WGNEZEpZZFpiZlY4cGh1MXBTNkZHd0UzcXp2S09BZGtPSU44NWlqbUVqVXJx?=
 =?utf-8?B?bDJrajVYUWY3MjRQcEhUZjA3T3dBMVJLb25RK2lueXVaRjZzN29aRVRESVdm?=
 =?utf-8?B?aEZoMit5RWpGSjZ0a2lieW91ZHJEYS95NzVQZk9KaDVJR29oUTRaTGpzcUhm?=
 =?utf-8?B?aWZtdXZINDRwaTFxRVNFSVJEZ0tLWGp5dHZmbmxWN2VTRUFZRjNlTi9xWnpx?=
 =?utf-8?B?ZG9vcEp3KzlXNGFwMWtTUUFuWFRocCszVExjSGRqVEoybDNiREp1WE5Kbld3?=
 =?utf-8?B?VXNmaUl3Y1lMT1NVWE5ZdUxrOS85dUZPSFp0V2FSQTVuUCt0S1Y0WlhuTmI0?=
 =?utf-8?B?anNwRGkrcGpvOUUxYUVyMTlxNjdpb0dOR3c1a3hyNk1pdmd5SEIzbW0vMi9U?=
 =?utf-8?B?ZktCWUxSSVEwTWVlSWl4OE5KQWtOWTUyZWwzQitWck5kRzkraTR2ek5uVXFN?=
 =?utf-8?B?eDRLZExyZDlvRTFjQ2lINUR4bzZTUjF3aWNSOVFhMDR5VXdMa0hLSFVhNzlt?=
 =?utf-8?B?SjFUdkpMZzNRckhybmFzbWJDbmIvZnJ2dkE1b1RJTXZFQk5VcUpPQ0x6dmZW?=
 =?utf-8?B?cTMxQldOSFA4SlFneGIyVFAxY1hDL1ZiMTJqRmNnZmc0MUJvaHFoZGgxSEc4?=
 =?utf-8?B?a3RycWM0WXJFWkZCVlBPOWhGWkZCZUE3R2lid2xNRnluV1JrVjlWS1l2c3Fu?=
 =?utf-8?B?UEZqRUMxQ3hiZ0UrQlNjcWQweFZ3SG9HUEJ5NVYzMHUxTDVmRDh0QnZBZTls?=
 =?utf-8?B?RERWYXhrb3N1eGZvVkwxZWZudTc3dE0zaTZaTjE4bll2UVJXTFNMR09MZzFK?=
 =?utf-8?B?MkhrQlFmLzRkbjdTTkpxZjUveEIvTlJQbnNIYUw5eEk5YWc3cnp1T09NQW1R?=
 =?utf-8?B?UzhjRFNQVGdXMlBCMjQzMVFNcFRrdDdhczNTeTQ4Z3FmOHpid00rZ2xCS3Jk?=
 =?utf-8?B?ZFVERW8ydEp2NzliclJwWndXOXgwcXMvTExxV2hmYW5Sams3Wk1uMWJxTFFL?=
 =?utf-8?B?amhpQ3JiZFZQNG1kQ2RIYUF2VHhtUU1pRjFVMHZBNkRQb2JVNGo5UjRScXA1?=
 =?utf-8?B?M0sxbkE3UFlRY2pucnNid0xVemUweUliU0FwampPdkVyL2FlNERBOWRCb0NN?=
 =?utf-8?B?eFB0YTVUVFIyQkY5aG1wYmJVM1h6QXNNQkx6S28rQlBmRFJtNHRuWXRraEtz?=
 =?utf-8?B?OXVKZUJzZjBiczJZbzU3cjdpNGdwb3ByL2VYenVKVXlKTklscWE5ZDNxNVZr?=
 =?utf-8?B?SEZFSGRoUHVPZ3hlMzFoK1RsK00wY01WNzMrcjNBdjhpdmJRSkZocjkzSEdI?=
 =?utf-8?B?RWRrQ2FWK3ZRQVo3aGs3aXZoU1V4c3YwamdENVZWMk0ydjFOVEVWWkpmeDJx?=
 =?utf-8?B?b1hkNjVkS1o0MnRkUkVoRTlrZFpNdXNKaEJKNDhnZnF0aXpLZndQMnFEdUhQ?=
 =?utf-8?B?U3R4THpveU56Tjh5dDF1WWRiRUJxRWQ5STZaZU9vWWd5b09wZDI5MWlmMGNL?=
 =?utf-8?B?eTAvOTc3QU05TzlQY0JrRlQ2Y1RmRmMyVzNvVitKTE5mS3plSzlyV0NIeStJ?=
 =?utf-8?B?ZEZaVDNib2lFN25JL0RwUGxlM0RUdktlaEpRNTJhSWNMR1dGbnBLaDREZ1ha?=
 =?utf-8?B?VXZlRk5mdnNrNUErd3lJNnRjbUZTdTZiNTdRWTFVdFJQaUtiNWQ3ZU5NdG1j?=
 =?utf-8?B?UlNqYW5XL1NYWEtEWVZZUEFNL0NKaE1iekU5b3o3UUpYd09XbTBmQ0NURDhj?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2b16b8-68f9-4cc8-c5c9-08dd816f8b17
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6054.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 07:30:23.4643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m2BCnUFtHt9ntj5pekqK+/afZWafgf8Telei1OdGYT7oaOPT0nP9d4zmVl3QirH7mzpJGr7qPikr2TTGT66ZYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4787
X-OriginatorOrg: intel.com

On 19/04/25 04:08, Sean Christopherson wrote:
> On Fri, Apr 18, 2025, Vishal Annapurve wrote:
>> On Thu, Apr 17, 2025 at 6:20 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>>
>>> ...
>>> +static int tdx_terminate_vm(struct kvm *kvm)
>>> +{
>>> +       int r = 0;
>>> +
>>> +       guard(mutex)(&kvm->lock);
>>> +       cpus_read_lock();
>>> +
>>> +       if (!kvm_trylock_all_vcpus(kvm)) {
>>
>> Does this need to be a trylock variant? Is userspace expected to keep
>> retrying this operation indefinitely?

No issue was seen in testing with a QEMU hack with no retrying.
Presumably if user space is not doing anything with the TDX VM at
the same time, then there should not be contention.

KVM_TDX_TERMINATE_VM is optional so it is not necessary to wait
indefinitely.

> Userspace is expected to not be stupid, i.e. not be doing things with vCPUs when
> terminating the VM.  This is already rather unpleasant, I'd rather not have to
> think hard about what could go wrong if KVM has to wait on all vCPU mutexes.


