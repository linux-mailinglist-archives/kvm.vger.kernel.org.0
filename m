Return-Path: <kvm+bounces-17481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 423168C6F40
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8699283C40
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BBF50297;
	Wed, 15 May 2024 23:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LWrH05+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED251037;
	Wed, 15 May 2024 23:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715816324; cv=fail; b=cPn7DKwN5/dmqXMIfSbe6bjWBvo6bqNjUU0uAGogpMn04oYIUZebLXzAuFal7mdakBf/7nlNyxtWO7S1LVVOAH0M82U9r9FMpDF0LcO57lms6kqrIaaGh7Ud4W8QixnGdptZr5mE1pNIgf+RwFqLbeLKQrMouq7APob3PIQgowo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715816324; c=relaxed/simple;
	bh=eqHtWGLZQJHCT/tfer9+8O8rMrKJEnqEIaWdWP5ooPI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gvmN7VGhx63b0q50rZwb6Bu68d66S2UhYt+klbiVJFTPSrs4pRkwUjyQ3Rjx2ngh/iv1PF/SnpeURNEjL/vgu8cGfMat4PHVMgMDTB1P6/U0X4ooSNTIcHpruV+XrFwwxwK6XCELtnUhN+dQfooGgocnrJI5qW0UaO1ZpzYiiVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LWrH05+R; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715816323; x=1747352323;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eqHtWGLZQJHCT/tfer9+8O8rMrKJEnqEIaWdWP5ooPI=;
  b=LWrH05+RHAPEDrQwI3hAX2/8N4Qup74Et/dIpvv+VlkcrRLxVozFooM7
   X9W8+lIrjURK1RPqVw1t5pVd5kf7deWbSBYwdp32X35TWoqWs7A6hEDGU
   g0oPWN4l2MCS4r2JXmlyooP1Zd1a2PpagPXpq5HLDYhAvD8aJNkUvqF+b
   OaT89mIhB4MrM0q5uDv6JNM1syR2PyhmRGJtu7yF3aH97rg+Cz7wzPCX4
   QzH0dWG9kufbnjri16H/y6GAs/tKFUXUWYc8wbtmOnn7PXTY9vrElWox/
   BajGnvo8JuXnMwY6k1wUfFAYtphOgP0Fp/5JtW3N5UyBJ1jL+9GO2i0Qt
   A==;
X-CSE-ConnectionGUID: mne2EzWHRUaYpxTX17SnyA==
X-CSE-MsgGUID: cTCHpFdDTUSaQrv3oTs3QQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11751690"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11751690"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:38:42 -0700
X-CSE-ConnectionGUID: Rba3B1WSRweE1bGmplo8GQ==
X-CSE-MsgGUID: /dNINQuMS3Of7KN92AVakw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31353602"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:38:42 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:38:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:38:41 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:38:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MN2BmUdOxo4ct/G6spRZ2fZwPOKpsv2Mruuikkji8YG4z15JiVYiRtGTwewiBeJ3EPXDiomWYJaLTiSpu8shT96SEfpJZ4B8/ELOqeoxW2eGvffty5fMXCn8isAMM0uFg4G/gwQ67EDQ/DUspPOENPkgs5dua/x8rn5mEQpryL5zVEnYh38g2h+Htwr4wYTc1UKvaTjyOxQ6lmGO7yuDPqFc+R6qRxk4NI2qcogWOh0FjB8Cu+r4mpqOnKbzhJhzmR8N+rJChi2sc3fWRa9ET1d4TgUy+rbbYF8l7E/2LYUE2SS+4I3vYfWuQlUbzuyO17bLwiCt79M/qs/zUaiKcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkKzgVll0hf8MCVsWmLF7YyJxlLKFS+aHjqfZwQZgnE=;
 b=C7GzABITfCdWZcaSjJlaz9vMBOGIkjdtrPIyYNZfn7/cM/I2SPH+lXMk/0EvcsIwn3e4uXoEyomKq46KDNvc1VpiA7K6mlDX44eFmM9TxlO8SrPNyZJxKVD56eVA7IORiuC0NWM4AI77cXo3oOxUCo5Ghkn4kcM5mY++Nim3XvyzzUBA05DALpZX+ETDqVzwZQNqwBRppul9AtESoBdWPQSl1t8SX3+6FLUeowZaQnuNCmKjKbjhW81uUsIBX8Ntnq3wqf8Q9tuFyK/QhHb/dDydDh0koVSMO8JVgcy69+YguowVD1AnsMazsmFPbg8mqgQFpdhocMHYDIFzVr0gDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7562.namprd11.prod.outlook.com (2603:10b6:510:287::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:38:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 23:38:38 +0000
Message-ID: <66afc965-b3f5-41e5-8b8e-d19e7084b690@intel.com>
Date: Thu, 16 May 2024 11:38:30 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com> <20240515162240.GC168153@ls.amr.corp.intel.com>
 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
 <d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0347.namprd03.prod.outlook.com
 (2603:10b6:303:dc::22) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b2e01a3-c9ea-4b5d-b9ec-08dc7538253b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TFl1eS9KSGxOMDBWOGo3MFBFMUtMOGZUVldmWlJlRnk5ajZoTVkyZmVZaFhj?=
 =?utf-8?B?cjJOWjE2OFkzSUI2NllKeVlHWjZqeUtSbm56YnNsRisvb0xNQmVtSkthWGVK?=
 =?utf-8?B?TDEySDR3cE9FM0YvUkROVlREUE5aU0lrbEs0dGpkNUNXTXNCNGVXTW9TMXZy?=
 =?utf-8?B?RjlLNEJyd01aekIybzlyMVo0QkpuSVhUa3RlaHpzVGNnZFJ1ZFFkY0N4V0dw?=
 =?utf-8?B?MUErRTdnN1ZSSHJDYXZpMkJVYmc0Umk4N3dVZUk5U215aGlqMTZDTndqK05H?=
 =?utf-8?B?VXVzNUFFV3lxRGVSbmNhcXUvVnRuWHYwOWRnai9Hd3NFQU5wRW5sbWNjWkVF?=
 =?utf-8?B?aFdSSlZwRXcranlYUFlLZWVJcjNNV3BFRG1SZjRvdExwUk1JYWcreXp3Q2tK?=
 =?utf-8?B?eUJOTlBVWmFDY1dnbnhWWEZ0N24zbmN6ZzJkY2UvNEYxSi9LcnVJb3RhWFhL?=
 =?utf-8?B?dzRJVkNLNWVNY00xcWl4bUNONTlZSVhOVGxtb3VnSGZYSThDQWNTc083WmE5?=
 =?utf-8?B?U0J0RVAwL082WDhyYTVBK1pPRVFyYVhiRHMyTjVweWFNeUVibEgxV29nalc5?=
 =?utf-8?B?dWs4V2svNm51eVNuNjQzdUNIeHFWMjMzN1lsVGZtQngyYzVudUZvRm9Ublo1?=
 =?utf-8?B?V2lwVzRTQVRrb3BQdzFuQmk4YjJiT3R0RWthWWd5SkJLbTJMdXJDVm44amhL?=
 =?utf-8?B?bnVMOTRkR2ZON0dWc2svTUx2NXliTm9sUUU3Ri9UNk94WHRtOFRqMGRETmwz?=
 =?utf-8?B?UEo2ZmdRZ2VlQkhFTEN0L003RnRvV2FrckhrTU5IejE1QVVTVnkydjcvajlD?=
 =?utf-8?B?NUxud2lHamJySnFvVS9pM2dJSWhrYTRUeXdtTVZTZHpoRUNMdUVzR25ZbnJv?=
 =?utf-8?B?eGhadyszV0JadnRQZUQ3ZEdCSURHMWljTk1PbzNKK3RHcURJOXQxa1RzK0VT?=
 =?utf-8?B?R0FUYnh1ZXI1ZnJWMittNkhmSXlVMWp6NVFOZ3RSVTYxdUswWExxa1YxbXcr?=
 =?utf-8?B?K1I0NEpHenFDZHROQUdHVVNHRCt3cVFMZjc1SjZRUVV1ekVvbEdaVHQvY2Yv?=
 =?utf-8?B?RXpIMlBEMmtvMUhIYjlWMVJ0clg5YlRzUDhIQVdhenNVUWJ1dStJUzBWY0px?=
 =?utf-8?B?eXJ2ME5tQjBVSnJzU0VpT2Q4MVpRMjF4ZmRYUFJ6ZDlPaXA4d1NaSkd4NURS?=
 =?utf-8?B?cjlYU2tTYUpSUmwyT0pNVWN6ZTNuSWlveG5SNnZRZFQzbittZlFTbjdybCtQ?=
 =?utf-8?B?VmZCUVE4azNYbGsvR0tZVE5USzNYazFGUUJESWN5YXVyYlhUZUZITFpteDBM?=
 =?utf-8?B?MjlOVWFCMTV1WVdDQW1Xd1VUZmpvVjRVb3BLQUJCRjFHSUU0RCsrTlorRHM1?=
 =?utf-8?B?ZVhNcStDTTc5V1hFQk55SEFmMXE1SVVKRkoxa0xJT1N2ZGNBcFlxM3lyaDI2?=
 =?utf-8?B?OFVZMklyb3RlbGJFYWh3T0lsN1RrMXhFUVBwM1A1UjZINno4RVNTcExQWE1n?=
 =?utf-8?B?NkIycXRyc0JCditPOUdlOEhuQVp2enYwVGRCYXNZa1hXME42NENadmZSRUpY?=
 =?utf-8?B?N1VGNjlGZmVuZzB6N1VKR1oyT3RvcGoxL1FEVW5KeEhWa2R2bGpQTVdJNlZD?=
 =?utf-8?B?M1hBZGQxZnBJSTlRQVRKbkN3MVNrcW8vOWhYbk9sRzNXbm1TTVczU0IwcUY4?=
 =?utf-8?B?NmhnNzBaSHU0bTFpcEhjelpXeC9KOXAvSEU2UnFOYjQxQWhzTllRNVB3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHA3THk5T1Q2bTdoMlJtd1Jlb2w1aUxwZzY1bGhyNUp0eTZ2cGFkS2NtYVRY?=
 =?utf-8?B?MW5seVJGcUVTUHFDRzQ1dG1kVU9jU1MvZXkwR3Ftd24xcG9TWXg1bmtVT1ZC?=
 =?utf-8?B?bHNzWUVka1c5VmlKcHNwL0U3MVlheWw1TXd3UG11M2k3cndyZHBhVmxnNldr?=
 =?utf-8?B?YWQvVERVWWVORXhKaXRkb0ttRTNBclY4M2xxOWZzOHJEdDZJYnhEL1ZsSXJi?=
 =?utf-8?B?aVRodjhGTVJwQkprRHl4dE1nN2I0ZWdEb0tIMm1YM283UjBkRFVoMkJrOVVa?=
 =?utf-8?B?eGdCREVrcEFWclFEblBJeUNZMVN3cm90b3dxQTJBWDJPQkJnMGZHQ0lKOTZl?=
 =?utf-8?B?M1d4VmR0SHEvVVoyR2t4VDlHV3NjKzhGMW9UWUJYcVJPVG9IaFFzeXdPNW03?=
 =?utf-8?B?Y2NIMXQxYkkwQVd4MFE3cDA1OXJZNDA1RlpVaFN4K21hV1ZMcUZVY1c5YmNQ?=
 =?utf-8?B?YzdidFMwSGFqNGpMN0VjSVdLOWlSNlVteGRVOFFyK0VhS1IwVlpYWTAyRmFQ?=
 =?utf-8?B?eHdjNyttaE5rY1RUWWJkMDkwTmlzaGFRem5yKzRNY1FRNk9hUzdHcGdPd2tQ?=
 =?utf-8?B?UDNXZXFySDZsUlh1R1pBanVMZ1RNVG5Halh5SVRKazNxTXgxYVU4T2Qza29J?=
 =?utf-8?B?d2FDbTJKNUtrZDlxbTc1Mm9zMkcwcHVsbkJYRUVKZDVZT0E5RTFyUVNjeDRP?=
 =?utf-8?B?WG9vZlYzaEhVWnNVZkg3blF1NElQdlA2U1FQdXBNM2RlNWJQSTk3S2ZYa1k2?=
 =?utf-8?B?Y0YyVzBZVUtjSmhVWHhvTXBjK0hmWHVhamVTTTg4RlJYa2libi9ralF0NWIy?=
 =?utf-8?B?Z0RvdHMwR2pONkZZaTBoL3hJbThqVG5VOWpuTEtQTWo0UHJGVDhGcUxmMmx1?=
 =?utf-8?B?UGtEUUcrcU96UEZDcWNQS205MGgwSFQzL0lKK0sreEpNS0RHc2p3aloxTisz?=
 =?utf-8?B?b3dwYmZWMlNVd3hna2xQMDdwTGpzdHBXZVM2R3p6djRQYWhqZGtyL0VORnZZ?=
 =?utf-8?B?bVV0ZU05aGRrT3ZoUzVGamFiOCtrWDBtd3JzMTRXN2VJVzFUMkV5TGFsSWtD?=
 =?utf-8?B?ZG83YkdoOWFEaCtOUlV3S1NFcU10U1Frdm1RWXhIRVRsaC9La1NSeGZidXFP?=
 =?utf-8?B?aEg0b1psM3BxbWV0YWExbkpPRUJlMjJpUVlVZHhPMDlQSlM5Z1U1YllDVCsv?=
 =?utf-8?B?aVZJUlZYbnZ2UGxrQytscmFKVzlOeU5qOFlHV21vRTYzQkwvbTAwYWJrcjcy?=
 =?utf-8?B?UmxHSkg4dmN0aFBXclVMQVpjYUlxYmtmTThzUENvbm5Ga1NrR3VWRzNxLzAr?=
 =?utf-8?B?Q01SYnhsdGNNcE5JNXhxMEUrNXVqRkh1NHU5NldGVHk1SUtRUFh0L3RiMGJ4?=
 =?utf-8?B?NWVOMnNNSUV4bFF2VlIrWmhtbHNTTkJWZG5IbTlkdks5QUduWmlBbXRQdEgw?=
 =?utf-8?B?c1JHOUJBVmlaSklIQXRrMWZVNXRoY1I0V3B0V3R3SWlheEp1SzUzdGsxR0xH?=
 =?utf-8?B?UXhyYjZVVzNlUVg2NFRrbk5DM3h6dThZNk1hOHVmT2R2enk0RnU5L2UrQ3A4?=
 =?utf-8?B?UUZ5MnNuQXg2ak5zTXg1dFJ4Y0dOckwvUjNRQ1NUckdsVGEyL2lUVVIxWVhR?=
 =?utf-8?B?YUtERWRadk05M1J1YWNEY0h1TjlTV3JMYWRzenpzSGUyUDhqdVNZeklOKzlw?=
 =?utf-8?B?TVcrTXdPL2tjWFRENGJRZXg5eFV2aURYWDRsTmo5R2N4a3B4Z081U0tZaTE1?=
 =?utf-8?B?d1d5aTM4cDl4UHprRXFzM05peHNyZ1FnamoydCttU3BwK0VkV090UTc2a3dQ?=
 =?utf-8?B?S2Z6cTZiUzBLbzRaK2tYNnVUdm56ajZvY284SFhZcC9HOWlIVENwRHM4bEEw?=
 =?utf-8?B?UDdpU09hTitzMUJEak13M1ZKQnI0SGR5Nno3dE5QNHVjNWNweG0vSnFZWndK?=
 =?utf-8?B?LzJjaGtMdzFRa2VlSEo4dm1FZ2NVT3pVRmNGem5HcExaRndQZmRtNnR2TUVr?=
 =?utf-8?B?UEpPN2ZMRFlEd3R4UDVFdGVNeGlDSXcweTlRYnYvU2haSWl3a2h5bitsc0dX?=
 =?utf-8?B?bXJXSlJmc1E2R0d4b1pKSXZyVG9RTGoxQTBMWkl4b3VPQWt5dXIvMlRJbFFL?=
 =?utf-8?Q?ARnNR0XRfDK/p405BWc/fi+Ck?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2e01a3-c9ea-4b5d-b9ec-08dc7538253b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 23:38:38.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HHdt0lEYuGtjrrdxLBbWA4y2Qd96Jg7Dp3FrFOx7JMlJ3obhO8r0P6nYww4CDk2ErCnwSUWYjyaUkyn63RQSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7562
X-OriginatorOrg: intel.com



On 16/05/2024 11:14 am, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 10:17 +1200, Huang, Kai wrote:
>>> TDX has several aspects related to the TDP MMU.
>>> 1) Based on the faulting GPA, determine which KVM page table to walk.
>>>       (private-vs-shared)
>>> 2) Need to call TDX SEAMCALL to operate on Secure-EPT instead of direct
>>> memory
>>>       load/store.  TDP MMU needs hooks for it.
>>> 3) The tables must be zapped from the leaf. not the root or the middle.
>>>
>>> For 1) and 2), what about something like this?  TDX backend code will set
>>> kvm->arch.has_mirrored_pt = true; I think we will use kvm_gfn_shared_mask()
>>> only
>>> for address conversion (shared<->private).
> 
> 1 and 2 are not the same as "mirrored" though. You could have a design that
> mirrors half of the EPT and doesn't track it with separate roots. In fact, 1
> might be just a KVM design choice, even for TDX.

I am not sure whether I understand this correctly.  If they are not 
tracked with separate roots, it means they use the same page table (root).

So IIUC what you said is to support "mirror PT" at any sub-tree of the 
page table?

That will only complicate things.  I don't think we should consider 
this.  In reality, we only have TDX and SEV-SNP.  We should have a 
simple solution to cover both of them.

> 
> What we are really trying to do here is not put "is tdx" logic in the generic
> code. We could rely on the fact that TDX is the only one with mirrored TDP, but
> that is kind of what we are already doing with kvm_gfn_shared_mask().
> 
> How about we do helpers for each of your bullets, and they all just check:
> vm_type == KVM_X86_TDX_VM
> 
> So like:
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index a578ea09dfb3..c0beed5b090a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -355,4 +355,19 @@ static inline bool kvm_is_private_gpa(const struct kvm
> *kvm, gpa_t gpa)
>          return mask && !(gpa_to_gfn(gpa) & mask);
>   }
>   
> +static inline bool kvm_has_mirrored_tdp(struct kvm *kvm)
> +{
> +       return kvm->arch.vm_type == KVM_X86_TDX_VM;
> +}
> +
> +static inline bool kvm_has_private_root(struct kvm *kvm)
> +{
> +       return kvm->arch.vm_type == KVM_X86_TDX_VM;
> +}

I don't think we need to distinguish the two.

Even we do this, if I understand your saying correctly, 
kvm_has_private_root() isn't just enough -- theoretically we can have a 
mirror pt at a sub-tree at any level.

