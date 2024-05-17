Return-Path: <kvm+bounces-17569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F7878C7FF0
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 04:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C320B21703
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 02:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677F0944E;
	Fri, 17 May 2024 02:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D+LzfpKa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457728C1F;
	Fri, 17 May 2024 02:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715913421; cv=fail; b=EBdXVuYanFycX8PHAwUXuZ4qgZeScWM1f0+VPfqc+U4xnaIi2xGGcJQjFiO9IMaPGgZlzAVZMvs2p92NOlFLk1APG7HTkzucYI2r9H3HYfncmoXLl82iY8leFNv0P/IJrvHLbUQS3iJ5o3adMZBnxbyn7Rc5kCTOBMd1NVDiJcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715913421; c=relaxed/simple;
	bh=zBFzwl9b7pU/NY/QNPs2PSyoOEV6ei8/c8b2VqBDM4c=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=SSwM7IGa90OgjdumVYIexhpGMm0RBwRvH0KNCUPgbha9qe87B1/ODa8RnPcP4NSvrPBk9860zc51t6LKUTAHZr8EyR2s4lzzGNEOUluxH3F9hyqXGa7V/4Jg+aoIFPT5+Z1KY2nA3JmWMX/sAjyGiwyicKJ4KJf9W0QSoOjWzy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D+LzfpKa; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715913419; x=1747449419;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zBFzwl9b7pU/NY/QNPs2PSyoOEV6ei8/c8b2VqBDM4c=;
  b=D+LzfpKaa6thoQ+hOF8u6c1LUC4ccMVuL2DCvhv36mQ5jQKYtibXkaBZ
   SpcPGqDZ9dOJhO8vldM5pDDjRDjrEknSe5WX6QUmpkOE5TJZdrTD8UY4m
   HJuwWfrBbl30nIfP375LXC/HXkGFjw5H9WAc7Fwyty9HKZOkb340uNjjI
   2i9bq6rXJbo5JuntfN1ubiQILZYC/HuT4VWTY9wJddZpS7HCi+Rcy3lco
   UzWaP9wWCQ1zWlnAsEgVZqWPaN7lS7hN6jzp0Cy3vJ5XPO/J7KTR0yHot
   XwmwgN13ULJ8Ny4yb8WtN4BuXHWZe/RVi6aSZG4LTv4yjpUnORvQVGyJt
   Q==;
X-CSE-ConnectionGUID: oHIV4uq+ReuajuZsRVfAPA==
X-CSE-MsgGUID: ybqrW6R+Re6qiKMRCg0pQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11875628"
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="11875628"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 19:36:58 -0700
X-CSE-ConnectionGUID: djW3NjZRTquittfXYmBi2g==
X-CSE-MsgGUID: R0yCEh8ISXiC+6Dsezg0YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="36551995"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 19:36:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 19:36:57 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 19:36:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 19:36:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 19:36:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnQ/A20CoXHmZOCdwgy11Ohojt/lf80FjCMdJ7fdo9iQEcmEOl0w5lcbv4myNi6ptg+rAfWRpbd/bBnoT4OCU5O89waAiwRptM5j5yB1C2jBp9RLgc19jiZCQteeqRPccEs0anVdZwWZD5klV+ERjnnrRWCxJ/Y/LtUXQsSy3lmjoJtC7YS39QDoastSON3rrLcNbTFZPwfLPsc60N4vTfyKVgm1By3EAff8JCKdUQMVf4woXzv09wMkOVbs+lLlI9T8MKkCzt8FrijU6EPYDPqf4C6p562u+Wesba3TthNjwI4EBVFNKwdAe7ChGkSb9zmIXHXbnA6u5t7mgzKaMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+aogx41MKbfG6wXanrOW/1kU+jAe5usZgxqot5zJpM=;
 b=lBscu3KgRiFSbZZJvfsmEX1Ffb93yePD3+xz6NN+2mKLaROfZubYB1aeOMhJZXTfE2d7dyzsnp41IIK8OS0mgSwtnM3cxcrbHFddNZAcDzVN/Q4/fDKbIGAsysaYMHCZJa00jZwWu123Id7Bvxil03+cdPWDxY7VfBLOJeB/KYRdcvF1n7ehcsp+QM3xf2g7qUEH936/labbJ5NvNYv/uKDXe1bq1YIKEAQ2m9lo0hdYMU1QDWCvIfRP88XtOsnGzUbrHXX+X10fKhq+NsylP+uXIW1q+JCA4oZ3rwldXFRGCMDvf/b/49HK23wrKmjNxbdI/qqQBfjmr0McT/tYxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7523.namprd11.prod.outlook.com (2603:10b6:510:280::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 02:36:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 02:36:54 +0000
Message-ID: <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
Date: Fri, 17 May 2024 14:36:43 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "sagis@google.com"
	<sagis@google.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@linux.intel.com>
In-Reply-To: <20240516194209.GL168153@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:303:83::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d5a1f09-1b40-409b-350b-08dc761a36a9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZU51bGZUTGhGUlcyd0IyWGV4bXgySVIvR1lTdTgrZEcveUN2ZS9mR0oxYTF0?=
 =?utf-8?B?UExKanQvRHU1aEZBSit1clNMQ0U5NEZqbnJUS1hpcjc5RkxhRkc5cTFFUHpN?=
 =?utf-8?B?WXdqdUQ1U0RsOENkUFRxT1diUWhIRk5BcFk1V3J4a1A3Um9tT01HMnFxYVpi?=
 =?utf-8?B?cTBOVTFJL0ZGMWxidDBLcG0yQmtjVFdab1FHL2tpN3lSNHFLejlqbEdEWm1O?=
 =?utf-8?B?NDJwTjhXdnU0Tmk0d1huL0VrQlkvMFVnQ096cmdDV25PQ0dOVWQwWmJqdnhW?=
 =?utf-8?B?MlUrSWNiT2dKMkJOUVB0aVhmQkwzdGpIZlVOUjNFMUhkclFHNlFNd0loVkxv?=
 =?utf-8?B?cmZjNVlDV3h3NUhkRkkwOVZmV1o1Z0RFTjltVlhGbXdnYkR0ZEFIQXZYL3dz?=
 =?utf-8?B?RWROSEQ4Y0Urd05nVzE0VzE3YzBCOFJBWEdKclBnVlpyTVMvRE1kblhEQzV1?=
 =?utf-8?B?UDFSeUpucG1qR3BRcGlpUGdDOUpkTitRSkUraVcxTyszN0tIWVM4aHpJV0FD?=
 =?utf-8?B?aHdnMW95U3J2VUZkNjRocTV4b2w1ZVlxTER6Mmd2aEl2UGR3MXFRZm5lMTdD?=
 =?utf-8?B?MkErblRuZnE1ZHNTSGhobERYTnV2T1V6T3k2WlFJOGZjU1VDUjdFclBzVlZz?=
 =?utf-8?B?aVA4SFZWam5QWElHaUNZZVdaVjJpMWhjYW5tRTBIOUJPSzR0UFo3WEZCYUg1?=
 =?utf-8?B?aXJWSTAxbkFuaEZyQ1NlSkhVVDg2bjdmQlE2T1VlVkdtMzNPcWU3eHd5bDhi?=
 =?utf-8?B?d0FaZE9ITzg0ZkxFeVMzVWFINzlZZVp0dlVBMVBUU2NIdnQwME5JY3lJZ0N1?=
 =?utf-8?B?ekhJcE1BeElWRU9uUVYxdlZmUFpkMFJwalE1SCtLdkovKzVidVVkb3llTnFS?=
 =?utf-8?B?Wjh2Q0YzNFJham43MXMwMlI3UXhMWGJoUkVRdkdHUzNsWGdEOXBnSllaU2o2?=
 =?utf-8?B?QUhCcC80SlFkZ2F2TG8wM2t0ZG5HR3c0YWp3d05FeHRoVlhsUk9pbXVvSjly?=
 =?utf-8?B?WEdDSHY1T2lKQXptdVRkOG5ybjVSOEFuMGRaZzVpcVZEWTZlb0FqTUhqL0N5?=
 =?utf-8?B?M2JPcHBuMXhQZ29mSEoyWDdZYXlOMHFRa05hOFhZbXN4d1hILzRoa2xQWGNj?=
 =?utf-8?B?d3I1SGhmdXdCc3d6NkJYNkE2MnF6VXVXc0g2UDN6NzY1YXhlQnhTQ0UxNnlQ?=
 =?utf-8?B?dHo5cGV5dmtocnZWWFkyK3ZKZlJHOFN5RVhZL29BRm1ZTWxSa0J2RjhCemN1?=
 =?utf-8?B?cHEzcFRmT1d1MEViV3FIeGl0NWZYMG9reTJRaXRNS0xES3A5NWRFMGFiYS9G?=
 =?utf-8?B?UWxPTWFLcEZWelZjYWNwTjZUWVFicHpZQUh5VDhwOUhqVWlkUzBlakYxeXY1?=
 =?utf-8?B?T2F5cnBUT3k5T0hTWWFxZDlLdXIwMy9tZklITURwYnlvNXNwTWtlSlBtVUhB?=
 =?utf-8?B?bnpGOXlmbWJWWXl3RXpFOExFMllYd0srUjk4SWtVMWdGTWJhVU1NQmQ1NFE1?=
 =?utf-8?B?VDNscmNYd1JhZlR1ZlFCZW5QVzBVU3NWbmxhbHRncmFCUU83RHZlcGlHOW81?=
 =?utf-8?B?eHVqSlZTRmtKbUUxbmpDMlFWT25LSUZrRS9yc0sydGNNUmRHQ3cvdHFlZzd1?=
 =?utf-8?B?bDRLcUE2UVNPeXJVRWxjMzRwd3Z5d0RoZ2xXRVZvNjVXZVN0bmhNYUpKd3dl?=
 =?utf-8?B?VXpuOVBqbUVUbzk5QzJqdDhqTVpXalZqcWhwYjBWWi9wTnBxY3VyQ3hBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk9vU290OXBtb3drR0tGK1U1ZjdhN3pPTForb3pYbytnMjJUMk15eHZlZzVL?=
 =?utf-8?B?ZERkc1JmSDhLeWVFZUtRc2E3a3RZZUJDVVl1aXoycU1iZlY4RkJSNWw2cWtq?=
 =?utf-8?B?ak4zSW9rSG82YVY0cGg1dEs0Wm9mNXFhR2xKdFhLcW9SRHI4Y29xckpjTkdV?=
 =?utf-8?B?RlZKcmNhVGpJNXVvME1ITDZQcWt4TDA1dUYyMTRWV24rdm1PcHBFZmlFU3dY?=
 =?utf-8?B?ZEE0RHBReVpVMmhHVENDbDRXOHJXZVRJaWs3WVpRV2tBYU1XUDgrS3JCckc5?=
 =?utf-8?B?L0ZlQXAxMDlmeVhQaWJYMGU3UlJta1FCNjJRQ1NKL1dTR3hOMTV6TFNRM2RP?=
 =?utf-8?B?MDkzVHY4bWhFaHVRNW9TMDlXMDhrS3ZLMEgwcWQ1dW1tOUVuSDBIMk51eFlw?=
 =?utf-8?B?ZUJhK05hWVNCNy8xSml0R0pObTV2SjRXdGluaC9BZ0p1MU1PMWE1Y1V2Kzkr?=
 =?utf-8?B?a0wzSStCd1FtZW5EM2NBVlZFVnd2Z2JxTjB1WWZzaWJoc0RLTjk5aDVwendJ?=
 =?utf-8?B?c0cvZzB1NlpkYUliV2h6SGhObUpzSlNyYThOa3BGMThqMmlUbkdxNnM1NCtQ?=
 =?utf-8?B?SGhyQWNNZlVpR0EvOXZYalltYzJHRzNUMUpoYWxLSHhsOVRFTU13elMwblIv?=
 =?utf-8?B?V1kzbWhhK0JVTVNLOHJMNUJ5RXhRV3F4NjhVYjJRUVpranNCaWlwY1dXZXdx?=
 =?utf-8?B?QzNZT3VTVUdvajFnd09lSVQvODloamh4SVFiZUFNejBFczJyM2R2cUpqUTFv?=
 =?utf-8?B?c2diQ08wVWtrZlR1SmdkcmZkN21zeld0V3daQWpQRUFrRlRjK3JvVEo1Tjh2?=
 =?utf-8?B?blBlQUdUQWtWM2dBMVJLNkgrUklWTS9DMWViY1E3N1YwQmtCZ295ZkZCcFIx?=
 =?utf-8?B?bzcvazFKL1E0WEJWYTZHak5HWjh3YWV5MmdqR1gwSWFMSHpaVTF1UFV0clY0?=
 =?utf-8?B?dmtaa0EraktoaTVaOTlkakl2U0hpTGd6cXptNTZvZ0ZqSmptL01QcEw4alVl?=
 =?utf-8?B?eDlmUDJzZDBTamNHTC9ra2YwNUlxVWlCUlpVTWVrVlRWZks4dkVkYzlUUmxR?=
 =?utf-8?B?eThRSDFaejE5bHVpK0NLSnhxbjR5M1V4bWpnRmF0U21uK1psNDdNMUc5WWZN?=
 =?utf-8?B?V1hxZDlKdkV2djJiQXM3KytiUEtoVWo4MmMxR3NncGhqTzgwREdHMkFtODBG?=
 =?utf-8?B?YS9mZlE3c1EybnhiMUdwVjFldkVQV1RlYkxvMisvR3ZvSExvbE1ZU1EzdEJU?=
 =?utf-8?B?TjlXZU1rWWlpUklvVWc0V2NQRTRkTDBwN3RpRG9DTEFjVVhEcnFmbm9yeXlO?=
 =?utf-8?B?Z1ZDb1hFbnZMVGp3OXRlQ01zanpnSjBQelNDQUE4N2VteHRNclZ6STQ3VXBW?=
 =?utf-8?B?TDVDZ3Z4ZitPMTEya21MNGFqMkRMREZlZnlEcFNpSnhtTTNCeXI5R1o1SXFF?=
 =?utf-8?B?UFhkUSthU3QxSHdURHNuTmxhMnNLTm9wVjZlcE5Geng5UklCQkQ1bFlZYUVV?=
 =?utf-8?B?WHRFRFJBN09yVERmaTdvY1dPd2ptQVVudEhucEJIeC90VGVBZVdnaE1vS1A1?=
 =?utf-8?B?a3FVU1NvTmJQWmUvdVY0TFZPVENYSFlOQzcwbFNNUjg0WmJETmhweXBJaEFi?=
 =?utf-8?B?clNsblZoZlR6cGtxWGNPNHVUdlBNbjJ2MHdOZFU4b3ZuNm11VFE2bFIzQVFL?=
 =?utf-8?B?U1RSeWtYeW9kQXg3RFJOekE4L1MxNSt6NGJod1IwU2lKNDlqMzFackl5dFI0?=
 =?utf-8?B?WHNyVlVFSk5FMStNSldrUjg5SW9XY3hYT1A5ZUM1Yis2ajdRMG1tZlFNNTN1?=
 =?utf-8?B?MjBrN1o3NHBtZTRjUXcycC9Nd01JZ2RSSXUzNzlUaklvcS9xYy9nbjVYUzFS?=
 =?utf-8?B?ZU44b0dDMlVaOFpNR1JBeEpLNHdhSG5sMU1rRzJacm9qbXRicGl1d3pEL2Mw?=
 =?utf-8?B?MFJUQWRXTXppUVZSU3dWMjVOVHFBQUNsVjYvSS80YTNLNDB4bjAwcmhUZUZk?=
 =?utf-8?B?NTFJSWxjRDJCKzdVVVdXb2hJZldNd1Yva0F2aDcyb0NTZDFsL29Nc1RWN1lM?=
 =?utf-8?B?aWoycXBFS2NZTFkwWEhhNWpxNnJBcUl5WFhwT2JnaUxFaG5JMzNpYVJTNUoy?=
 =?utf-8?Q?BLGJd26gIGXKokVUsuaCw1Ru8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5a1f09-1b40-409b-350b-08dc761a36a9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 02:36:53.9112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdFWcRBqrqEizvI8nk8G1QfsJYH8vmBNaWDfV6uNr4YnlsdFLEBMdw4W35dPETEAOPAMUdqH3MoRF/ZGlAkFUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7523
X-OriginatorOrg: intel.com



On 17/05/2024 7:42 am, Isaku Yamahata wrote:
> On Thu, May 16, 2024 at 04:36:48PM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> 
>> On Thu, 2024-05-16 at 13:04 +0000, Huang, Kai wrote:
>>> On Thu, 2024-05-16 at 02:57 +0000, Edgecombe, Rick P wrote:
>>>> On Thu, 2024-05-16 at 14:07 +1200, Huang, Kai wrote:
>>>>>
>>>>> I meant it seems we should just strip shared bit away from the GPA in
>>>>> handle_ept_violation() and pass it as 'cr2_or_gpa' here, so fault->addr
>>>>> won't have the shared bit.
>>>>>
>>>>> Do you see any problem of doing so?
>>>>
>>>> We would need to add it back in "raw_gfn" in kvm_tdp_mmu_map().
>>>
>>> I don't see any big difference?
>>>
>>> Now in this patch the raw_gfn is directly from fault->addr:
>>>
>>>          raw_gfn = gpa_to_gfn(fault->addr);
>>>
>>>          tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn+1) {
>>>                  ...
>>>          }
>>>
>>> But there's nothing wrong to get the raw_gfn from the fault->gfn.  In
>>> fact, the zapping code just does this:
>>>
>>>          /*
>>>           * start and end doesn't have GFN shared bit.  This function zaps
>>>           * a region including alias.  Adjust shared bit of [start, end) if
>>>           * the root is shared.
>>>           */
>>>          start = kvm_gfn_for_root(kvm, root, start);
>>>          end = kvm_gfn_for_root(kvm, root, end);
>>>
>>> So there's nothing wrong to just do the same thing in both functions.
>>>
>>> The point is fault->gfn has shared bit stripped away at the beginning, and
>>> AFAICT there's no useful reason to keep shared bit in fault->addr.  The
>>> entire @fault is a temporary structure on the stack during fault handling
>>> anyway.
>>
>> I would like to avoid code churn at this point if there is not a real clear
>> benefit. >>
>> One small benefit of keeping the shared bit in the fault->addr is that it is
>> sort of consistent with how that field is used in other scenarios in KVM. In
>> shadow paging it's not even the GPA. So it is simply the "fault address" and has
>> to be interpreted in different ways in the fault handler. For TDX the fault
>> address *does* include the shared bit. And the EPT needs to be faulted in at
>> that address.

It's about how we want to define the semantic of fault->addr (forget 
about shadow MMU because for it fault->addr has different meaning from TDP):

1) It represents the faulting address which points to the actual guest 
memory (has no shared bit).

2) It represents the faulting address which is truly used as the 
hardware page table walk.

The fault->gfn always represents the location of actual guest memory 
(w/o shared bit) in both cases.

I originally thought 2) isn't consistent for both SNP and TDX, but 
thinking more, I now think actually both the two semantics are 
consistent for SNP and TDX, which is important in order to avoid confusion.

Anyway it's a trivial because fault->addr is only used for fault 
handling path.

So yes fine to me we choose to use 2) here.  But IMHO we should 
explicitly add a comment to 'struct kvm_page_fault' that the @addr 
represents 2).

And I think more important thing is how we handle this "gfn" and 
"raw_gfn" in tdp_iter and 'struct kvm_mmu_page'.  See below.

>>
>> If we strip the shared bit when setting fault->addr we have to reconstruct it
>> when we do the actual shared mapping. There is no way around that. Which helper
>> does it, isn't important I think. Doing the reconstruction inside
>> tdp_mmu_for_each_pte() could be neat, except that it doesn't know about the
>> shared bit position.
>>
>> The zapping code's use of kvm_gfn_for_root() is different because the gfn comes
>> without the shared bit. It's not stripped and then added back. Those are
>> operations that target GFNs really.
>>
>> I think the real problem is that we are gleaning whether the fault is to private
>> or shared memory from different things. Sometimes from fault->is_private,
>> sometimes the presence of the shared bits, and sometimes the role bit. I think
>> this is confusing, doubly so because we are using some of these things to infer
>> unrelated things (mirrored vs private).
> 
> It's confusing we don't check it in uniform way.
> 
> 
>> My guess is that you have noticed this and somehow zeroed in on the shared_mask.
>> I think we should straighten out the mirrored/private semantics and see what the
>> results look like. How does that sound to you?
> 
> I had closer look of the related code.  I think we can (mostly) uniformly use
> gpa/gfn without shared mask.  Here is the proposal.  We need a real patch to see
> how the outcome looks like anyway.  I think this is like what Kai is thinking
> about.
> 
> 
> - rename role.is_private => role.is_mirrored_pt
> 
> - sp->gfn: gfn without shared bit.

I think we can treat 'tdp_iter' and 'struct kvm_mmu_page' in the same 
way, because conceptually they both reflects the page table.

So I think both of them can have "gfn" or "raw_gfn", and "shared_gfn_mask".

Or have both "raw_gfn" or "gfn" but w/o "shared_gfn_mask". This may be 
more straightforward because we can just use them when needed w/o 
needing to play with gfn_shared_mask.

> 
> - fault->address: without gfn_shared_mask
>    Actually it doesn't matter much.  We can use gpa with gfn_shared_mask.

See above.  I think it makes sense to include the shared bit here.  It's 
trivial anyway though.

> 
> - Update struct tdp_iter
>    struct tdp_iter
>      gfn: gfn without shared bit

Or "raw_gfn"?

Which may be more straightforward because it can be just from:

	raw_gfn = gpa_to_gfn(fault->addr);
	gfn = fault->gfn;

	tdp_mmu_for_each_pte(..., raw_gfn, raw_gfn + 1, gfn)

Which is the reason to make fault->addr include the shared bit AFAICT.

> 
>      /* Add new members */
> 
>      /* Indicates which PT to walk. */
>      bool mirrored_pt;

I don't think you need this?  It's only used to select the root for page 
table walk.  Once it's done, we already have the @sptep to operate on.

And I think you can just get @mirrored_pt from the sptep:

	mirrored_pt = sptep_to_sp(sptep)->role.mirrored_pt;

Instead, I think we should keep the @is_private to indicate whether the 
GFN is private or not, which should be distinguished with 'mirrored_pt', 
which the root page table (and the @sptep) already reflects.

Of course if the @root/@sptep is mirrored_pt, the is_private should be 
always true, like:

	WARN_ON_ONCE(sptep_to_sp(sptep)->role.is_mirrored_pt
			&& !is_private);

Am I missing anything?

> 
>      // This is used tdp_iter_refresh_sptep()
>      // shared gfn_mask if mirrored_pt
>      // 0 if !mirrored_pt
>      gfn_shared_mask >
> - Pass mirrored_pt and gfn_shared_mask to
>    tdp_iter_start(..., mirrored_pt, gfn_shared_mask)

As mentioned above, I am not sure whether we need @mirrored_pt, because 
it already have the @root.  Instead we should pass is_private, which 
indicates the GFN is private.

> 
>    and update tdp_iter_refresh_sptep()
>    static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
>          ...
>          iter->sptep = iter->pt_path[iter->level - 1] +
>                  SPTE_INDEX((iter->gfn << PAGE_SHIFT) | iter->gfn_shared_mask, iter->level);
> 
>    Change for_each_tdp_mte_min_level() accordingly.
>    Also the iteretor to call this.
>     
>    #define for_each_tdp_pte_min_level(kvm, iter, root, min_level, start, end)      \
>            for (tdp_iter_start(&iter, root, min_level, start,                      \
>                 mirrored_root, mirrored_root ? kvm_gfn_shared_mask(kvm) : 0);      \
>                 iter.valid && iter.gfn < kvm_gfn_for_root(kvm, root, end);         \
>                 tdp_iter_next(&iter))

See above.

> 
> - trace point: update to include mirroredd_pt. Or Leave it as is for now.
> 
> - pr_err() that log gfn in handle_changed_spte()
>    Update to include mirrored_pt. Or Leave it as is for now.
> 
> - Update spte handler (handle_changed_spte(), handle_removed_pt()...),
>    use iter->mirror_pt or pass down mirror_pt.
> 

IIUC only sp->role.is_mirrored_pt is needed, tdp_iter->is_mirrored_pt 
isn't necessary.  But when the @sp is created, we need to initialize 
whether it is mirrored_pt.

Am I missing anything?

