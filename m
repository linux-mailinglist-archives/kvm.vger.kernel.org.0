Return-Path: <kvm+bounces-17141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DD58C19DE
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 01:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7BDD1C2204D
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 23:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA0E12E1E5;
	Thu,  9 May 2024 23:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ok/rt+QN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFAE86245;
	Thu,  9 May 2024 23:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715296800; cv=fail; b=lHlUQzYaB23CCrY9599i5QsBENzxPliMZaL05iyqpQfv//ZA9ucbXawVY2bVYidpEbhAkRrnmmv5JsIXKrj8gOaFSDGDZkArk5OqACKuR+PWNURwVD0FjSL1IK2bYeUy9cC8A4WjShgWbGcfL322Eran2Z2c33OTq5bzDisoXZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715296800; c=relaxed/simple;
	bh=J9T07FVr8CPsZcAM6fQHjhAuSUSfUrA/vmayi1tkl5k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=btUBYOKO2aNYF7hi3JbaSBgmtknkN99zNUNrbS+SOaomdW6QH9HeRsbMKejxMbYejapTPYkd/rHBINR2UXAwdQz/pCWr6jAQKAa43qQ5Flfe+qoI5AvoVSqNgjw9WFbTvjnFPurJtvfMJXIETBLAndQ36UEfk6jc7i9n2CA3qso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ok/rt+QN; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715296798; x=1746832798;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J9T07FVr8CPsZcAM6fQHjhAuSUSfUrA/vmayi1tkl5k=;
  b=Ok/rt+QNPONaPvBOTE0ZJ1jSRFnfPTgnL1HKIbFZBTMFY53hP0ryTp3p
   ekLdZmxRumd80b7JHPGm8sX3Sl9kQZaTZS1d9YwMxb4FKJhFl2j44oisa
   idt5XaT+q4hqmOd9eWq0OL5/UqJnDaZTv9Qt2ZyZQh6OVoXxkkR8Q7ucu
   rX+XTeBwJ9DyhXTGl6fpiW/yOnYBgO85usnskgHD2JkZFQM5pfMcFf/Lc
   veghMVyMaQYI42a3qEA/DaA2euEYK2h/Y+znPqUYXGlEIJxWU26RJnUus
   Ybsh3oFLsMWMVZibu7D2OXGbIgepuRbWB6hODm1kDGzvFTQBciZuFr7o4
   w==;
X-CSE-ConnectionGUID: VeoEaXGPT4eivVYZSu229w==
X-CSE-MsgGUID: I1ubugkgQBO0vRptpYd0xw==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11114065"
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="11114065"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 16:19:57 -0700
X-CSE-ConnectionGUID: ovx2kkEVTXWCjsOrtX4jeA==
X-CSE-MsgGUID: qpP9eeuFQWeDYa3Yb0zTHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="29354584"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 May 2024 16:19:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 16:19:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 9 May 2024 16:19:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 16:19:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EI/rsJ8XKBUNClgLY9lLkWWI27/sjh3J9eZ4Pq1r3TtKozbKaIJ9ieLd515hsvhZ8DnGHRWUH+vhu/nJlpHfaxu4SFqdLlnvNabSrVjkhGb/O0BDJ7iySMC9voVmFI02LCXT0VryEd6qT5crRZ4bGtKBgLeb7DohFLAqYjsmNxZdcViEX7Fz7UAYQh0Yy8f2qrRMbjnfCgAZl8tHSBHEuLm5Q1wBc+cz0aWUVfNt39TyeIXTQ/jxgzuczlZqt/GTWvAUeplBB+/9Ek8M1foKkXUzkRdsDBCOoVAI7T/dYEpFmXiqSP4ECK0dkiEBzFExAZgZejWtJdCD+a9YGDgDXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LLKJjSXW/Ypmcztq4qGGXUKtJ7KC6eDwpNgdDgiAqI=;
 b=MkayAfbzOubdZrXgRmJc9NNVO9lJLmjXRIPfekVal1z3MWv0YunsWdRqzW2zdWC5ggH1EQuy801+rNfS/3XaUU4bGxvAXRRhg4nhBLGJf9WxZM5vYUxkkUA6N0BH6tURVLeC9aSoRnKcLfi+WMqITW3ZwMB6KdfU0pPjCzza42yngtoVV7ryqzVOIhqjIIyWVKWgHHu/Km8qrRjnV1j9eeHdSQ3T1GCBQtwGIGmbq6OKIEnCJOEH7oMlEBgkcYj6h+JzGgx+x+74nVkaizHJpL4bpli2ng58aR1gZpse1SyEF6TcC23XUyH+nGi9mhL7pMdhlRgQ/O/zojtafmRcsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6067.namprd11.prod.outlook.com (2603:10b6:8:63::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Thu, 9 May
 2024 23:19:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.048; Thu, 9 May 2024
 23:19:53 +0000
Message-ID: <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
Date: Fri, 10 May 2024 11:19:44 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: Sean Christopherson <seanjc@google.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com>
 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
 <Zj1Ty6bqbwst4u_N@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zj1Ty6bqbwst4u_N@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:303:86::19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: edff1b02-7582-4a4c-cde6-08dc707e884c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z1BLMms3NEpEV2VPby9NcVNBdkdFMm56b0p6dnNQVXhWUldpUlMzdnloemUw?=
 =?utf-8?B?YzlEUVBtanZlZmgzeUlYVW1FeGdNVjJPY0F1c0dHWDZtUXU1WGM5bTYrMmg2?=
 =?utf-8?B?SEFTZUxrSlBVTytSNzFFUTN6RDVRaWJaSDNoYmxpQ0tPbjhGVFgxTUdnUFNU?=
 =?utf-8?B?QjJiSzFKTnpPSUpIb0ZmS3RYZzB4d1dOd0lySUFQQkxkQ3A1VzN3WHUydmhX?=
 =?utf-8?B?NGZacVRHNzQ5VGRXYkcvSkZDektFWlJtOVBVNWQvSHpyZ0JPVXhjZmxTMnF1?=
 =?utf-8?B?OEVJV3E5SnA5NzlCVk1PUzM4YWNBTWFrVjYvdDlkQzBvRlZ5bGVScnM3RlBG?=
 =?utf-8?B?aEZ4Z21uWkhEbm1YbFYyeHpRSUVKUEtoNHVkb1BDdGNWWWM0RkVKWjhITnJE?=
 =?utf-8?B?WUVMOGpwSStHSGdXVldpMXM3N1I3WEdqbE5Ub2t5cnR5MlJ1VHBjNkh5a0lP?=
 =?utf-8?B?SktqREJNQ3NiVFJlcmdhRmVzNDlKbzJVdy9OU3hrbU1KUnF1cjFwZHlYUmRt?=
 =?utf-8?B?eE9QdERBVmdPUlk5TTF3S1BkZXNHK2tJYzlHd1NZWW41VStBMkhIN3lmcTdH?=
 =?utf-8?B?ZDVzYkNXMzFhOWZNZ3NybUxKL1NDTklJY3dDbDYwcHZRZmRsV1VqWnhvMGwx?=
 =?utf-8?B?RTlWdm9MdGFmZ0REYWk2QnFOelY3c09veFRBVzVKa241TUlZejg5QXJETFJR?=
 =?utf-8?B?bnRYUXlCaVl1Qi9yVWcrald4T1p4bFFIWjhOZjZJNEF0N0c1L1BGTVZmM1dJ?=
 =?utf-8?B?TkprcE5Gai81bHRoRmJzcGNNVnBtRTRpM3g2L3o2dVB2aDJLRFR2aHJ5cHFq?=
 =?utf-8?B?M3ZPbVAwMDBFOG4xQ2xoSVBSc0lvM1ZnTXliMk1ncGtNLzVQcFFiWWdwTjVL?=
 =?utf-8?B?bGNJdnJLbzdaMHYrN2lPNmtDOVhqTnk5U2ZUVEltbkdlTTRkUWg3bGp3cFRY?=
 =?utf-8?B?bk1VZU0rQWdYN0hIUFFiNktKTFpmUi93YkJxaERBSWQ3OTU4OVVtaXRySGll?=
 =?utf-8?B?UEx6T3pZNVFSTTFiZ1orbm04SlFNUW5aQStXUGwxc0g5MWxTUHRvNkhObGdE?=
 =?utf-8?B?TUVFU3orbzljVy9seFpyQkJ6eEUxZGxONzc5SkZ5eXgzamJ4dWg1QktmVW01?=
 =?utf-8?B?dVRzRXZleXY4ZmFzZFhJclVnSW9kK3RFbUlHbVhVbmJ3WFVuNmhZR0dJZzFu?=
 =?utf-8?B?SVVVSUpHV3ZiRFhNVjA1SHZVT1A3YjlTdDI1QkZaS1VZNEw3bmdJenZCc2ph?=
 =?utf-8?B?U0NmbW93NTFYU0xjank1VFQ2dlZHaE51NjhlenUvTk9Rc3V4MzNGODYrRFFJ?=
 =?utf-8?B?bXl0cFdLK05SQjlTdkFUb2EzODVkd05hWGpmbGpJUXBvRW1GUGx2SlFRUHNi?=
 =?utf-8?B?ZmFTemdQbzc4UzFHL0VUOERsbnVmUUJXWjV5bGtRVmlpNHV3Z1JnWXlyME53?=
 =?utf-8?B?V1lzSGFyZzlIV2pCQkhRTmFWTnhUK3QzNEhkQjZWMERySnJIM2Y4UWpXRmNB?=
 =?utf-8?B?VFRrclg5UWh5QUNERExjcEE5VkphMU9WRUxUN3BGNTdqK05Qak5pVUkxbmtR?=
 =?utf-8?B?SG15OTRkWFBVWTlxZlVwdWdReTRDYm9Ub20wblEyV2pLWUdzMklXQzBwTklV?=
 =?utf-8?B?WjJUY2V0S08wazBENVFOYXpUblJUQU1TQzhoWE1IbHZCbkF4ZHRwOWpIbWRX?=
 =?utf-8?B?QzFSNHBtRUFRVjQyR25GRFo2dERTc0NkdTQ5WU8rV2VvMllEVjVPb1hRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEViN2NjMVRSbFkzcmd1YURuei9NRkkzcUY1bVlTQlJEc0ZQcVY4cjVhK0hx?=
 =?utf-8?B?TTIzL1lWM3hJazVEK0lpdFo2ZlA3UGJwbytVb1lYeXFUSHYvRVBmUURJOWlF?=
 =?utf-8?B?L1BUYWYwc2c1MGVteCs5TEQ2a3h4MndMUEhCQzEzV2tjL05XaUZuYjBlRVFn?=
 =?utf-8?B?WkRBTVFlalh0OUJ6Q0lsMUNxYWtTdXV5cCtEa2VoajhHYUNkSUlYanNLSU5B?=
 =?utf-8?B?aWdOK2hZamRlV2R6NGJpRDdCSTF0ZUN3N29GTE5yaUNKSVF3UUxwYTNtenlI?=
 =?utf-8?B?cW1EN2VKTFBFeFgyYnBxTTQwcHphU1dDTFBsUDlVa1FMRHNTZ1BvdC9tMk9a?=
 =?utf-8?B?REdVYkF0WFhNN3RQRUpCaklBOUtFdTJDbmVuSUk1VnB4eVg1Z3ZpenlEeTNm?=
 =?utf-8?B?c2x6MUZCREhPSHp5WWE2QVJJN3RDY0twVkRXWVZSamxtVStnRkNsZ0p2MTFB?=
 =?utf-8?B?VzVXMGUrQkFERmtpdzdLNm16RS9LTDJ2OFR6ZmJnUUthS0hJSTF0YURjNU8y?=
 =?utf-8?B?cUU5Rm82eDk3VHRHeStsbFdjTktieXNkSHorSGdDTWgwL0wxQzFzVzFRS0Rj?=
 =?utf-8?B?ZkFyVkNiYnorbHZ0NXdIMzBlOVJmTzRjaDJ1ckxlUXZrQWluSlBveFdaV2Iw?=
 =?utf-8?B?VE9SNUc3MVNmR2wvQ2pybktYZFlLakk3Zks2VUUwM2JiWkY2NlFaUUtXZnp3?=
 =?utf-8?B?cThlT3BCRm5YWTFVTlF3ZkcwaTAzVFdqZWhEMHBzMzdlRnl1WGhVWUZWQUFw?=
 =?utf-8?B?VS9WdzJKczRkTXFlUyt4bUdneWpLNHEySVgrWWF2MlJ5bE9Ba1VZb2V3RVM2?=
 =?utf-8?B?NkdRdnoyVkltNWFaLytpOU1wNndYTU9xaWZJdWdtcDhHQUsrTlZQVnZ6Vzhu?=
 =?utf-8?B?SEpNaEV5ZkNuSVVKNzgvdXUrUEVXZlg1R1VyWEgzNFU2bHVPR01Xaks1eWVU?=
 =?utf-8?B?RW9uQmlCcTV0YWRYaktKUGx2SmllTFBTMkFGTy8yanRocWd6THNsUTBkcW1Z?=
 =?utf-8?B?SlFTQ0NlejNWOVhubzVKNnFjSFlsck1TZWM2SlhHNVRQa29pbDZHdG1pZWU4?=
 =?utf-8?B?R0FjYklxY2Y2Y0Y1UnJJQUR3UTNMNUlWUVhkWUc2eUdma3dVRlIwNUo0Q0F0?=
 =?utf-8?B?VERPaGp0Qm53TS96emF0Qkp5UVZDNURzcVRXWkZqTnhiMURINDJ1REVBVXRM?=
 =?utf-8?B?emNvR3NQbENhUXg3SzZ5enBnMVcwTjFteVlpcTE3cFpORTNaMnVra2FaVzI4?=
 =?utf-8?B?S1VvSlFLeEdhVmxSVUY5STNNYjFMWm5INzd2NldYbWgyR3p0ZVVmR2s4VVdX?=
 =?utf-8?B?V3dVWGRMblp2S0tmS2YyNVhSdEFtZmNlRWtSYUM0K3RSL0dSSXRTYlprN3V1?=
 =?utf-8?B?dnVmSEw3RnBrUlQ4S2pWUUhRWW9yVVlHeEcwVS9wYnRicnZibHoyRUdtQUZV?=
 =?utf-8?B?MVl5MTkyZDNFSDl2MUNBbm05R1h6Zk5PSGhoM01wYTJKNVY0VUNtZDdQRGxD?=
 =?utf-8?B?ZEoyck9RVFRrb21GQVU0Qk1xWjNBQ2hQUXFEZ1BMTXRSUkZ0VzY1STZsR3BL?=
 =?utf-8?B?L1NyNFBnSFlzbUdrdjU5L2dRMFRTZHl1N1dDejRlWnhxcWRSY2ZYSlh4QmFO?=
 =?utf-8?B?MjZkb0dIajhTdVJ2eDByQ1BqZmZpMzBVSkZUL2g5M1hWUWo3NHVwdVZHMnRi?=
 =?utf-8?B?azd2S2ZNcWxDTFI4WmNGQm11WWE0L0w4d1RJbm1ZL3BucWtyN2R0S2R1UWVn?=
 =?utf-8?B?VVBCdUZDQjQvYWN4Q3FzcE8wVVF0aTlIaktKWWY1MXExQlZzL1ZkSm8xWldz?=
 =?utf-8?B?Y1gzdWFGK00vQWkwaXlTWU5KNVVxVWFERzZFSU9YemV1bm5ZbTIrTENzSkox?=
 =?utf-8?B?alpzdTkrRFgrdHEwQmY5V25oTHRVWDBFMTF2eEI4cHZteTRsV0Y3cE43MGla?=
 =?utf-8?B?N0U3NStGYjhJcjkrSmpTVVk4MmFHZCtIRldjUkFKbW44V3hYZy9sbGM0T2dI?=
 =?utf-8?B?NU05dU5tdHFWTUM4ZXdSTW8xU0ZBYmMyY1pESzNMSDQzZy9teVM3ZUVoR0lN?=
 =?utf-8?B?MHpoamdRcHEzQngrb1hwRE15eVAxZmZmNFZzMk5oZSt2clpCREdKcWVmdTRv?=
 =?utf-8?Q?NmJM9JVKtAS9enKOpQCx89Zfy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edff1b02-7582-4a4c-cde6-08dc707e884c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 23:19:53.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHEz+rzH13nQPCylPdSunJA/TdwemPn5KrAXDr+l1U50ev5IOJa5ITZZbSy9jxbt0zV+BOwhoc77snww47OQGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6067
X-OriginatorOrg: intel.com



On 10/05/2024 10:52 am, Sean Christopherson wrote:
> On Fri, May 10, 2024, Kai Huang wrote:
>> On 10/05/2024 4:35 am, Sean Christopherson wrote:
>>> KVM x86 limits KVM_MAX_VCPUS to 4096:
>>>
>>>     config KVM_MAX_NR_VCPUS
>>> 	int "Maximum number of vCPUs per KVM guest"
>>> 	depends on KVM
>>> 	range 1024 4096
>>> 	default 4096 if MAXSMP
>>> 	default 1024
>>> 	help
>>>
>>> whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
>>> a 16-bit unsigned value:
>>>
>>>     #define TDX_MAX_VCPUS  (~(u16)0)
>>>
>>> i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
>>> And _if_ it becomes a problem, we don't necessarily need to have a different
>>> _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
>>> being <= 64k.
>>
>> Actually later versions of TDX module (starting from 1.5 AFAICT), the module
>> has a metadata field to report the maximum vCPUs that the module can support
>> for all TDX guests.
> 
> My quick glance at the 1.5 source shows that the limit is still effectively
> 0xffff, so again, who cares?  Assert on 0xffff compile time, and on the reported
> max at runtime and simply refuse to use a TDX module that has dropped the minimum
> below 0xffff.

I need to double check why this metadata field was added.  My concern is 
in future module versions they may just low down the value.

But another way to handle is we can adjust code when that truly happens? 
Might not be ideal for stable kernel situation, though?

> 
>> And we only allow the kvm->max_vcpus to be updated if it's a TDX guest in
>> the vt_vm_enable_cap().  The reason is we want to avoid unnecessary change
>> for normal VMX guests.
> 
> That's a frankly ridiculous reason to bury code in TDX.  Nothing is _forcing_
> userspace to set KVM_CAP_MAX_VCPUS, i.e. there won't be any change to VMX VMs
> unless userspace _wants_ there to be a change.

Right.  Anyway allowing userspace to set KVM_CAP_MAX_VCPUS for non-TDX 
guests shouldn't have any issue.

The main reason to bury code in TDX is it needs to additionally check 
tdx_info->max_vcpus_per_td.  We can just do in common code if we avoid 
that TDX specific check.

