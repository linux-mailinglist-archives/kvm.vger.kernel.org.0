Return-Path: <kvm+bounces-17360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEA68C4B0C
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 04:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C15028425D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 02:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41E2B64C;
	Tue, 14 May 2024 02:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XsF0jkMC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02491AD24;
	Tue, 14 May 2024 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715652095; cv=fail; b=dD3FphhEF62N0KB1P4S0PdRA+7Z85f/Gnx0SpGoeHqgd2Q4iFWRox1smLSbgjyaOSxgtWWTh1WmvSTU0dDCKTjkrApy/Zl33pWpLABJzTzjBKhcIId1crfqTckWa5sSiiuPUvfrrKDcQTIQkasEyW/QcImJtflpQc2CLuHIhuSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715652095; c=relaxed/simple;
	bh=BH+rcFjRoSkMUjz0YKdu6ZSEVqmgq+puYbXpl2H01Po=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XQRxp79kx3dn1HnRzBNPnzIMFp4DclGTks0S60zd7UcHeL08d2eGkkllIfjKlIUZJTFgNsFpuVne3ZegJc9bc8d1SQE5weX6+29T/8zHY4F5aKkg48CvJj6vC7L8nVcqTx3EGInY7PTX+SHS+yk/3tbXAwanpabLrQp4sCwT+ME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XsF0jkMC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715652093; x=1747188093;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BH+rcFjRoSkMUjz0YKdu6ZSEVqmgq+puYbXpl2H01Po=;
  b=XsF0jkMCWaD4s3r14x5GAkelCgbeuEfc/vFlhgR1J4NgqNWb/aAdQX3e
   c6ggoI6V2ls53YGqh3lwCKQAcb8Hf8mRDJxbAo5IIibzgCf4BTOT8s2/o
   cYrc86sT8+neDgrihrbkn0hL7Khd5tznZHLcpGaaWsTXGP12kSejpH5jK
   K4qlEWPjU6oWxGDhTUWcShvcsU05C7lTY2O26FjqUQRWUtCIPcSn3Celw
   vHxDqwMVrOZLrj6u3t7eofFxDCFMWM3gzRyz7EGyNlaaWeGQNeeltbZ27
   Ea7f7//Zj8Tix+dOvveqLR0TcrHxXoJXmCXoP0k687oiJorrXgNb/lgj/
   w==;
X-CSE-ConnectionGUID: 4W9mq3NfQWGKAN80VDYLow==
X-CSE-MsgGUID: SuzTORm3TZmISdxYAtBiIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11775083"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11775083"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 19:01:33 -0700
X-CSE-ConnectionGUID: NlTNNKMNTluKQmGndsZeWQ==
X-CSE-MsgGUID: qqkaxkC3TaW5aAvIx4IGDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="34969912"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 19:01:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 19:01:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 19:01:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 19:01:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqH5QIDAted9cG6Ss8ecwj7cqOQTsNlr+R40JMcuMzGQ8cUwQFwT4I/WeNZ5wla6LchCE+bxDYgzf1zzv9CBoYHubr+VAxYCyIVP9kgvM/v0LD/0R2RQVflHI3D7MkcuCYZv4bCOxteKIcFF6Y5hAtNva2cQW5ivFCpbxKO+KLrET6L3xAtSW51jFt1f+iSHPXpUR1oCfWg78Gw0Zl28IfAzjWyomm34GGkLjyUWv7XUABEDgkTMVJziEsi1yAkNE3mnmwQ2fwHxUq47BFygUC96DSoJFRTlgAvRUbyqWVgVoygE9FSPsyCM3Jem5jIOfbQof/DG+qLGMbwUzcRAlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3a4apGWZ67BmWv0twpU2zjuSsQHtUzqUDqsP/9nXuWw=;
 b=F6gwrLBGyu3kAUNyAh2HCFAJayy1MZbPRy97v2fVLKg3rvtOqwrpj+v/yuKVs0dYbApTTr8KKc/TKkVraiKG6drFVMRZ+GPn6br6P2Z9cJ6Vqnuahj2orxClVBEOZhOCNzLOfrIavfpqG67vQzQhPrTMb52BQnMWELsd1cRuyoycsnA2mH2ygP3bxCeqLrNlB72GB4s2LygpSr3dtsd4JZ4G9ZsAwSXod019b/LLlMQScv0iXVjli4W3/ISXaIJrQ3n6vbdj8JhXfmViBCNgkPYLxGI5durcgYtSQI3l3DrxXAxToFDZzntxi1ON6cBi5u21/9Sxo61okUc8sxzzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6497.namprd11.prod.outlook.com (2603:10b6:510:1f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 02:01:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 02:01:22 +0000
Message-ID: <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
Date: Tue, 14 May 2024 14:01:12 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: Sean Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Erdem Aktas <erdemaktas@google.com>, Sagi Shahar
	<sagis@google.com>, Bo2 Chen <chen.bo@intel.com>, Hang Yuan
	<hang.yuan@intel.com>, Tina Zhang <tina.zhang@intel.com>,
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com>
 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
 <Zj1Ty6bqbwst4u_N@google.com>
 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
 <20240509235522.GA480079@ls.amr.corp.intel.com> <Zj4phpnqYNoNTVeP@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zj4phpnqYNoNTVeP@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 2985b9f4-db1d-430c-ba11-08dc73b9c11c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WVRvR0c5Tk43eGMvZE96Qk5Pc3B3TUxoQnNocWExYUtWWTJHVC9Ia001ekEv?=
 =?utf-8?B?Q0VyZTM4ditnanI4VmxhY0pzQXBTWS9wY0Q4byt0WEhQRG5SRHN6RFlXd2xh?=
 =?utf-8?B?RFl4UVRTOC9zZXY4RjFxbElubjJ3MERadURXMDBzKzZ2ZWVpSy9jTEh1Rmpq?=
 =?utf-8?B?MnhPbFVDWVowUXR0YmlWVUhpcDJMTmJtNjB2cnJ5RjcrZFhPYUdIVlg3QnZv?=
 =?utf-8?B?WEJyenJmelYzVVc2ZXFMdFgzK2FUTXp1RERMYXJlTkoxdE00d1lrV3lJd3V3?=
 =?utf-8?B?NHVIR2pGVmZkVVA0SHFnWU9uTlZDWUpEOStYWGh1ekNHNkdsQkI5aXFrQUhz?=
 =?utf-8?B?elUzQW1aNC9mQUdtUnI3eTdTcVB0dzlBVndRVnlBK2ZWZExsaVo4MGRBTkpN?=
 =?utf-8?B?TTZxWlBEN2I3U0JBUngyeEpwb0tvL2YxZGdHZm1ISmtSa3VOSmVIanZXWnRq?=
 =?utf-8?B?RDRoWldnV3QyRGFpeUkyUWZyOGtoVXM3eW0rbUY5ZG1URFhMak42eHlTOEd2?=
 =?utf-8?B?WWxuSERqWS9iREk1c3gvN1VueWpiQnBFZWhjMEhybElxcyttNmpFRE5iZkpE?=
 =?utf-8?B?NjJlTnR6Ynh2MnJ0Z0QyZzN3QmQ0MzlDbGo5TlM2MDBpTXJ6TjAyVEpCQ1oz?=
 =?utf-8?B?YkhTbEdIL3gvM0ptdlVOWVIrV2hnRjY2N1p3aDdhdEQ5Ui81NjROZGRxL21a?=
 =?utf-8?B?OVFnNFE0dkZEbmVnUmxTZkJyYzM5L05MczdGb2ZFcDhwZUNjaGRJczRCUGc1?=
 =?utf-8?B?dnVMYk5Kdk93NFg5MGwveEozc09Uck5kTGFJNnBmcGo4amlRRURySDRtKzh0?=
 =?utf-8?B?YStwakZsTzZrVVZiTGtmS3FmVmJTcDJQd0FLOWQ4WmdKZlYrbFdGVGJZcStY?=
 =?utf-8?B?MzBFQjY1VVBudjU2M0NwdHNjbkE5cm9CcmpUTGpjQzJ4aklhYkQwTnh1SUxQ?=
 =?utf-8?B?NzVPcjFvVHU2UUU2Q2grNktwNkdNWnFzNmhZbU42MVc1cFYyZFFNS2FUZ1ly?=
 =?utf-8?B?V2dLRUh3WkJzb3BXbXdJTCt0cUJoVVZZUnFscEZJeENGN2g5V3pFZk4wd3p4?=
 =?utf-8?B?ZGdqR21pVGtZTGpYaGdIcUhJUFhMOURoM05QaCs5OENYMHAwYjBZVWZzREE4?=
 =?utf-8?B?bER1MFA2RXBVN3RVVnRMT01UMTc0cDlKVU5kYUt5SFFhdVZvdkhjNnFoREFx?=
 =?utf-8?B?NUZsR0JSRDUyM2lDTmlSRDMwQXkybzVCNXpwVjVrNzArMHFQWURiRlUvMk4v?=
 =?utf-8?B?eGRRSCs2T0NabU8vb1M2UDNIaGFiWjk3V1NJbVdXbWJuaEJLYmtwamFsZi95?=
 =?utf-8?B?dUhLL0FoRnhKK1l6WkhnL2xZTE1za0lyN1lBOTRNc1Z2Y1NJbS91NUdHSWU1?=
 =?utf-8?B?V00xdE4xSFA3aThtaXdQZ1VCbG1PaVhndU5zdGVtOW8ycEx0cWpOc1NsVlNG?=
 =?utf-8?B?azc1dkRNeWJKbEFleENHaEQvZmkreUJaWXNSZzMyTE9oTEQxUkJTTTF1T1JR?=
 =?utf-8?B?bE40V281ajJWWVdDYnVTa3k2c2VzZEVmSnpjUkVEQS83bkduM3hLTzM3VnEr?=
 =?utf-8?B?djZLdVZScVFqMlZUMU5Sb0Vsc2RrWk1tTzNRUmt3aitSOVpsTUI4ZXZJTW1R?=
 =?utf-8?B?STBabnFVNEdBZmhkK0Q5RSs2KzNFaDk3L1gxUEV2UXdTSzg0NlN0dHgwRXFJ?=
 =?utf-8?B?dEJBOGdLbmVmUG11SDJwYnQ3UnpSTmwvUlIzdTkwbURWU0RBVkt5VE5RPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1NCdHBTME5XTW9kSVg3VlhGME9tRCtHOTJxNVZkeXdSRmJHWjkwVzVqdG9E?=
 =?utf-8?B?RUhQakhVdk5xczFXQkJIM0krWkd5NWM5UHJZMjBRdkpPeWVPMFkzTkRVdHpO?=
 =?utf-8?B?SEI3VzA0c1RkMFhnUWFrbHVDaERvWWJQVFZFTC9FVkkwMmVKVWZVWFAvbnc2?=
 =?utf-8?B?MVE3NGJwcXFrMHF1UFNKeXlmdVI5ek1mRzJnNEh5UEJPRTNBRTdveFN4WW15?=
 =?utf-8?B?U0NrbUc1ekpEbml0eDNxWTVGQ2J4QldZcU9vWDVOdUlhYkxjN0M4aU8velY0?=
 =?utf-8?B?M2E2UDFTa0ZJWHg0cFRteFZvSGsxYTNKV0txQkhFdDhUdThpZGZnM3BHKzcx?=
 =?utf-8?B?RHNrbWJPWmF0eXBmSXFyMXU2Yzl0eUNySXhpbjQzRDBoWWJ4TU5RRzZoc0F6?=
 =?utf-8?B?VHVKTWRsNGNuMTBpeFg4cERyR05NN3hOUTV4clZVRzk0QU5VZTV1UHpqSTJW?=
 =?utf-8?B?TXQxU1UrOGNaeFl1SEl5RjdzaFVWSzQ2bVZZQlM4WEQ1cVFoYStha1V4QXNm?=
 =?utf-8?B?d0IyUmJMOFhhRW5qcmtrSW0yNWtnby9UTUdyUE1pZTBBNUR1TEdhR2t2U0hv?=
 =?utf-8?B?YWNsUVpoZUFLQVdDd3RUcXkycURWL3dJOU5FOUVXTzJaM3Y4eGZjc3lQNnRJ?=
 =?utf-8?B?akYrV2tUWXFBUjE0ajhSZzEvVGRINnBkdGxvTGU5MHhXalhwdlMxakE1M3ZS?=
 =?utf-8?B?ZXE2SGtFRDhNNjdJLzlKZHMyVTYrT3M2TnQzYjJkYUxXVFBPTjFQY2xoc2pw?=
 =?utf-8?B?ZUFMbU8vdlB1am9NSDFaZzBVdS82ZFhVOWxpTEx0R05rbFhBbHp3emMrNy9B?=
 =?utf-8?B?bDdWZ0xzUEczVnhBd2dScTE4clhGcGgzM2tjTXlmVWRUS2RvQkduRmlSMkhJ?=
 =?utf-8?B?ek1BN2xRd2drUzBxTm9paWFNdWpqUFFaZDJZTDlReHBzVjdVMlluQXlBY3hw?=
 =?utf-8?B?ZTJrT1hhZ2RWMndOQzVXY1ByMzliV2JRK2Y4REVDWHI5aU5TNjQ2L0lvR1gw?=
 =?utf-8?B?ZUgxRm80Ui9Qbys1eEpleFUxZHY5NHZINmZpZnNoRVl3MUNaR3M4Uzc0aGdk?=
 =?utf-8?B?UFh6VHBuZlllZEM0bytQZ2FmMFZPOWFOT3p6cENQTmROS1d1Njl4U3h6Mkp0?=
 =?utf-8?B?clBYL3RjZDdJR3NhWU5CdUx3UzhaUEp1YmRBemtmSVg4VDh0bXQvT1hSWGkr?=
 =?utf-8?B?UTllMkgxZGsreGNRcUlDLzFOd1pUMUI4YUwwd0FQdDI0cFU2K0praTNtdGNH?=
 =?utf-8?B?TUZJVUMxWVFOSTJabUJmYlUybXBtaFVCRVlqekVhL2hGZlJpZGJ4emxaSklQ?=
 =?utf-8?B?eWlmTjlaRUFSeWRudTV2bnk3L0dLQTYwbEVyTkdoNERSQkZSYmQ0QkVESTZL?=
 =?utf-8?B?cTFvMmUzMjZDektTYnBSdVhXbW9zSUhXVGFBWFBvSzJ5bDFEMWN5ZldlZldt?=
 =?utf-8?B?S1R1MFFBRVc5cCtrTzZkV1ZNRFhZUUR2SjJ0b2Yrd1YwQm1BSjlXMUovMUtC?=
 =?utf-8?B?QUVzS25mWi9vT2RhWEJRcjlCQzNDMitheWovUTlrcDFKWGFMbTNJR3E0aXUw?=
 =?utf-8?B?eHZkWXA0S0pDeFV4aE5aUE1UNk1ubmZwbFN5eVRrT3doL2tGOFllRUNSVWI2?=
 =?utf-8?B?WmxNZnpsQWlqZTFQa05XUDRxeWl1NUZtZktUN1lxRTNzY1JXdWs3cW1xYWZk?=
 =?utf-8?B?bmtEWjRnNWtScEplNUF3b0wySW5IcHpLMy9LVDJzSmRsdTN2RFJjN2t5R1J4?=
 =?utf-8?B?NjZUVkdZdStSTXdNZjBHazZMYm43S2RaYTRsSUZIcEE5Z0ZjQklyVHVDbk8v?=
 =?utf-8?B?eGcycUFmY2tveXBkT0h2cm1FaEZSNk1nN2J6R1ZneFNlbEdaMURON2Q4OHRl?=
 =?utf-8?B?ZGFjSllkTFdyRlJQZnI0QnFwREVCbjVzd01zYzBZcXlYZE82bXFSWEpIRC9k?=
 =?utf-8?B?TmhrTUNWL0RSUFk0YUpkODZ3bDl5bTNIVUdWSE4wKzdGN2N2K29DZUZQeTY0?=
 =?utf-8?B?R1lFcHFwYWJNMUN5S2dOVVpRQzZSMDgwWE9nNzBQUDY5eXg4N05xMlh3dDJ3?=
 =?utf-8?B?RDhndnNPY3UwUkh5eGJQWW5CaEtZejU5L3VLR09XT1ZnZVB3eE1nQ2NkNHFk?=
 =?utf-8?Q?emSFo9HXpjLf+lQh4EkD6b1Ud?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2985b9f4-db1d-430c-ba11-08dc73b9c11c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 02:01:22.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nv6MAS1/UeXcq2v1qCvTMqObR0UVqv/sxr6vSWwSmRkTswUctrsdrLvBfoGRGw7gZg57OlAxBEktpcqQQFQAcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6497
X-OriginatorOrg: intel.com



On 11/05/2024 2:04 am, Sean Christopherson wrote:
> On Thu, May 09, 2024, Isaku Yamahata wrote:
>> On Fri, May 10, 2024 at 11:19:44AM +1200, Kai Huang <kai.huang@intel.com> wrote:
>>> On 10/05/2024 10:52 am, Sean Christopherson wrote:
>>>> On Fri, May 10, 2024, Kai Huang wrote:
>>>>> On 10/05/2024 4:35 am, Sean Christopherson wrote:
>>>>>> KVM x86 limits KVM_MAX_VCPUS to 4096:
>>>>>>
>>>>>>      config KVM_MAX_NR_VCPUS
>>>>>> 	int "Maximum number of vCPUs per KVM guest"
>>>>>> 	depends on KVM
>>>>>> 	range 1024 4096
>>>>>> 	default 4096 if MAXSMP
>>>>>> 	default 1024
>>>>>> 	help
>>>>>>
>>>>>> whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
>>>>>> a 16-bit unsigned value:
>>>>>>
>>>>>>      #define TDX_MAX_VCPUS  (~(u16)0)
>>>>>>
>>>>>> i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
>>>>>> And _if_ it becomes a problem, we don't necessarily need to have a different
>>>>>> _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
>>>>>> being <= 64k.
>>>>>
>>>>> Actually later versions of TDX module (starting from 1.5 AFAICT), the module
>>>>> has a metadata field to report the maximum vCPUs that the module can support
>>>>> for all TDX guests.
>>>>
>>>> My quick glance at the 1.5 source shows that the limit is still effectively
>>>> 0xffff, so again, who cares?  Assert on 0xffff compile time, and on the reported
>>>> max at runtime and simply refuse to use a TDX module that has dropped the minimum
>>>> below 0xffff.
>>>
>>> I need to double check why this metadata field was added.  My concern is in
>>> future module versions they may just low down the value.
>>
>> TD partitioning would reduce it much.
> 
> That's still not a reason to plumb in what is effectively dead code.  Either
> partitioning is opt-in, at which I suspect KVM will need yet more uAPI to express
> the limitations to userspace, or the TDX-module is potentially breaking existing
> use cases.

The 'max_vcpus_per_td' global metadata fields is static for the TDX 
module.  If the module supports the TD partitioning, it just reports 
some smaller value regardless whether we opt-in TDX partitioning or not.

I think the point is this 'max_vcpus_per_td' is TDX architectural thing 
and kernel should not make any assumption of the value of it.  The 
architectural behaviour is:

   If the module has this 'max_vcpus_per_td', software should read and
   use it; Otherwise software should treat it as U16_MAX.

Thus I don't think we will need a new uAPI (TDX specific presumably) 
just for TD partitioning.  And this doesn't break existing use cases.

In fact, this doesn't prevent us from making the KVM_CAP_MAX_VCPUS code 
generic, e.g., we can do below:

1) In tdx_vm_init() (called via KVM_VM_CREATE -> vt_vm_init()), we do:

	kvm->max_vcpus = min(kvm->max_vcpus,
				tdx_info->max_vcpus_per_td);

2) In kvm_vm_ioctl_enable_cap_generic(), we add support to handle 
KVM_CAP_MAX_VCPUS to have the generic code to do:

	if (new_max_vcpus > kvm->max_vcpus)
		return -EINVAL;

	kvm->max_vcpus = new_max_vcpus;

However this means we only allow "lowing down" the kvm->max_vcpus in the 
kvm_vm_ioctl_enable_cap_generic(KVM_CAP_MAX_VCPUS), but I think this is 
acceptable?

If it is a concern, alternatively, we can add a new 
'kvm->hard_max_vcpus' (or whatever makes sense), and set it in 
kvm_create_vm() right after kvm_arch_init_vm():

	r = kvm_arch_init_vm(kvm, type);
         if (r)
                 goto out_err_no_arch_destroy_vm;

	kvm->hard_max_vcpus = kvm->max_vcpus;

So it always contains "the max_vcpus limited by the ARCH 
hardware/firmware etc".

And in kvm_vm_ioctl_enable_cap_generic(), we check against 
kvm->hard_max_vcpus instead to get rid of the limitation of only 
allowing lowing down the kvm->max_vcpus.

But I don't think this is necessary at this stage.

