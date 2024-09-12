Return-Path: <kvm+bounces-26605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A098D975E0D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 02:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A516285B5F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B957846D;
	Thu, 12 Sep 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TiduW9sE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA7D1C36;
	Thu, 12 Sep 2024 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726101588; cv=fail; b=uN19FAv+ZVYUtwzw+XYTvnr1euv+m9XgxV/cFIthtzsYgB7+IKg2d/xjGy04URgf7x4zr92E1qX1JLjsuvcvFCBi4HZnC+BwEO5D/mm2nzPRFVf2nCAWxd4fU0bxdLhOqK+e071/r6c0QFxD8G2CfahQMqn6PqkRxaDlk4cgQao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726101588; c=relaxed/simple;
	bh=VAgNWD3ctbizQdUhDLMGfoNaJ9FPu7WZhgg5iKW73v0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p/KTduMXDaz8Fpr/p2CPsfc5LThXDd8HJ3m13XGUDDgPNH8hvs9g5qiew2Um7hfdShxRDRCpzLOVxIB1bX2tOBfRGjUYiESiX1xVVzsyn6SoGTj55KLBiiU/1TDpluCCge7+dYPz+2PuK6ejWmzZA/tITZsO5072FuxQdXpQS+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TiduW9sE; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726101587; x=1757637587;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VAgNWD3ctbizQdUhDLMGfoNaJ9FPu7WZhgg5iKW73v0=;
  b=TiduW9sEyWRITmdD5tqZhdKhP3tQ+AU4oPjWR8vwGkIrDolyM3WxSTpk
   +8RsBqy2tZCNL0aWbsG139pM00g1Ijdx5E9p5af5lFa+7tdnSFKoRTsHO
   C0r7w3+cXogyEFqfLNF2yra4uMdRRzrB/Icfp2ec3agwKnj0QzAiAn6hB
   9e3ZenaRhKZhNHLEvhx8nFHnazeMsiXZzJ6e/vo5WCnb6m8P05oHc2yW+
   STMB46zZPv+l2Lt8TpvCDwpEGU7SUYV6p/K+fuJWYGVvGuKSWn6tyKUlc
   hK3fcedV/eRQKr1gTfOauC5Jz9u0RzDcBPw+aZ6vHOjlGSGjGqrNcE2SY
   Q==;
X-CSE-ConnectionGUID: VnLt+50iSFOmMtU/VhcLPA==
X-CSE-MsgGUID: 82KpddL3R3SNHnMPL4nYsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="27851705"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="27851705"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 17:39:46 -0700
X-CSE-ConnectionGUID: KuGRmQu/Q2WZWLxAEWTHaA==
X-CSE-MsgGUID: RtD2lRMNSy+LDD/m1WlMtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="98241685"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 17:39:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 17:39:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 17:39:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 17:39:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 17:39:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ECEzYFuKpexd4phLqkwivt1sr0PJwWKLuNM1vUbQlzkR/nfP2duDAU0nmu/eFYQhh8cnFT2picL6ETEY1VwNjsmgF3p/yxvp1eHlcdVjvy28hJlV2RpkZJu4Tf+uXW6mp6FN9bBrZ53KiDC6RZ815fpTMiIjz6iCxLc18r7FmHGbA96tZMuxFxxhRqWoJUwhfSqwd8MHmyBJdaCYn7RUpiMdBQaitDu8yEVsh+dskbKJCp77aU48zl5QnL22y92MbJHg0IjR1nt78U2nd844IB1QCXWX04oGxd/iCzAY/dQeQtWnT5gOom5w1A5RjKjxRZy7ayYRjO4dBEhzMtl9Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rxJTd/+rzIjG98LNpAlDxE+LoDa8tRM6930OxSJDAs=;
 b=GS6vQGBMMaM5Qe2uHO8A6aJH1mWGK6Z4vb4zL5Hd8/+R7J+4/YrWAPsJZWIP1iK24UQx0tmsqV+ioDbJ61T8eUaisuLfQFdTEW1UAdLxWiS0ufjo7yF8DSGp7joyxoECquEN5T+eEB4K1m+y5dUj0nRIzS44Hnoi5rRu/tqRCn5boF0lFnLNQzlV7xCkX1SKoGGk+rPDbJ5wTpJcqnnE2oqucfWWhjtJ/z2aV9VlT2DNiQ70cPA95VaELgMEfD22HMIjcixhJQPeWtc7hHuNeNYebTS5TLvgJQOuk7u/MolqTSRWR50w1+Xna5lewuIssAfVjOibswsfdNcTCdqn9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7630.namprd11.prod.outlook.com (2603:10b6:8:149::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Thu, 12 Sep
 2024 00:39:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 00:39:43 +0000
Message-ID: <8761e1b8-4c65-4837-b152-98be86cf220d@intel.com>
Date: Thu, 12 Sep 2024 12:39:36 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <dmatlack@google.com>, <isaku.yamahata@gmail.com>, <yan.y.zhao@intel.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-6-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240904030751.117579-6-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7630:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd09cbe-96f0-4421-fe76-08dcd2c364b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TUF6YWdWZm82cWptcFhZK3lNYjVHeE5pM0JEU29mV0p2dUV4cmJjL0FGS1Zn?=
 =?utf-8?B?QXVrYXYwMVhqNlN0Y3kyV1p4UXVnMzJxSm5ZOFJqOFNmMGFMWHpuckFMOVRr?=
 =?utf-8?B?RkptRFRzSU9DWEtodGMyNlRlQ1hIYjgvWCtuT2JwMmJPWVRPSndLa244Q3lF?=
 =?utf-8?B?dXU3aW10b1JicVZSM1diMnhmamxNbHlXYkxlUzdiMGdPZDAxSkRXUTl3ZmhR?=
 =?utf-8?B?ZHZhT1F4U1gwSnkwWjBOZ2hlM0g1cmRQb0cxeTdiVHRodDJ0bDQzR3N4czVD?=
 =?utf-8?B?ZThoVit3SEd3am8xMWp1MGpOVy9XQUV1OW9xYjVxT3ZQekRFSkpWWUdTelU2?=
 =?utf-8?B?ejNoaWg1NmFFTUxtQ1ZNKzNKWVlyczRhS2hlVU5OdUpOQzEwNFhiV29pZFpm?=
 =?utf-8?B?Y0dLRjFoZWJqTkV3aVNMT2pjZW5kLzFBWEttdDJyK3FsdlZ2NTZ1U09ZZTJZ?=
 =?utf-8?B?TWNBYUF3MFhPU0R6UGR3UERiMmIrakZad2FnRlVhdGs5d1VMQ0tBUENzd1cv?=
 =?utf-8?B?UVpUK3R1dDR0ekdULy80bmp2MEluTDhMRC9zMndiQ0F4azViVHpoSDBpNDJL?=
 =?utf-8?B?OHhFb3NBZzZIbGY3NGVCV0l5NWkrcHN0RDd4RS9GSFBXbXRmNkZjM1FsWjBY?=
 =?utf-8?B?ZFR4TWdQSnJyT1V3REtPd25ETm9jcjRVZWtwZ0hKUE42Q0JnL0V3cDJvOFgx?=
 =?utf-8?B?eWQycnAzMW91L3IwTm1ncXgzclNYdXEvclNVNTdkRnZ2Y3hPUVNpQXA3T3lO?=
 =?utf-8?B?dkhxVzh3WVhhY1FabnpzU1VhbXQ4SWlsNjdwSmVURndiQUV5V29remo1Yy91?=
 =?utf-8?B?aklUNEVRbm4wMGt2RjdTUkZkWThXdVBEQytZVmdWWEZ3VjRUVHdKS0YwcXho?=
 =?utf-8?B?SzR2Y04reU9mdXNzbUNXKzdxLzRkZHBmNUk5Y3dFQnJ4dG95ek1BaGM1NjB6?=
 =?utf-8?B?MGNVQktIZU9WSTdDYWFpT2dvcXNhMGJTUjJJK056WkpVUVlEanA3LzhUSnEv?=
 =?utf-8?B?dVJhNm4wRkh6YzdQbGtCelh4Zk56aStNYnpZdUg1RDJBOHVFTWhFa2l6YkZJ?=
 =?utf-8?B?S1ordllsNWtYMjlUeUd4eWxza1Jlc1ZBc25CaDBiVFpaR3lFaDViNGh1V0NU?=
 =?utf-8?B?UmhkU2JoQy9ObWVXUXp5dTN0MTgxNnNwbEcxQ1JUOFVYT2RjdHE5S3FuaExh?=
 =?utf-8?B?R1dKNWl4UFU1akNnYXBzTExnTDVFNWpqQ25JN1VnbXk0OFRrWnRQOGppZFph?=
 =?utf-8?B?UHpmWVhMQ2hJVWFsaUo3U3VqQllQa2dNYWM0WWYrd2ZBS3NnU0lJZUwydU5H?=
 =?utf-8?B?QisxREJKb1lFZTl3NUE0L0c3U2dPc3lYSmVCdlFHUWlaYUVnN0tMTmRCM0F6?=
 =?utf-8?B?VnlyazU2UCtjT2xSSGdUMTVLcExmZHUxUUJieUNZclltZGVTMTdiR0ZaSktF?=
 =?utf-8?B?cCtnZGJqR0xxM2FEUUNLVFF1cllPcTRGNG4yelQ3N1cvNGg0TDI5ckpDdDJz?=
 =?utf-8?B?RHoxQlZQVDM2SS9MVGtMemFKSE1nenJETEFSUXVDK21JRDRJR0V2dDdZeHZy?=
 =?utf-8?B?ckVuUXduTUEvNzgxbFN4NTJFV1pFUzllcU0rOHk0SlV3Qlp6dGsxenRySi9x?=
 =?utf-8?B?QTNqQjBCVDBjRWJwb1VhelFtbFlYdEo2c2JxRmFMQmQreTZLcXp2RWMzeUxp?=
 =?utf-8?B?SWFxN3pmcUNRUWdhWjVZbVdRRnhZUTV3Q1JGL1Y3d0gvR0xjbXpVangra014?=
 =?utf-8?B?MXhETC9ob2w2TFFEZksySDVQNTRFeXNpemowR1NQQkJ2ck5xT0svMHNzNjF2?=
 =?utf-8?B?MjJnaFFFRlV3QVViZlpldz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVA4SStmc3pwQmxyNmNaYWR5N2wxczBONEVNVVdXbmlObndQOWI0VG41Zzl1?=
 =?utf-8?B?TG9rVk9zTnNiTnFoZnR1UFJPYnBBN2U4L0IwYkZ6anl2Z1V5SzVLRlBzVjNo?=
 =?utf-8?B?TVYwYi9POW9vRG9kOFJMS2JEUzJMc3JyNUduUEZJUVhKcmdtOEpTQ3JOMFFn?=
 =?utf-8?B?MGdjUzB6QmNvSnp2N3Z5U1k3TWFQZmNtUk1XSTZkOElCYW5LVEh4TnpVWC9t?=
 =?utf-8?B?eVRmSncrTXNwV09FSkdSOHFKMHlUVklDY1hWc1ZUS1gzcXl2clYzWk1yY2NI?=
 =?utf-8?B?ZjdBRFZoVTBxcmVTREFUa0RsZ1JVM2pWL3FxQW94bFE0aGxySFF5Uy8vQWlt?=
 =?utf-8?B?VDlHZk5qQkR6cXJiV2xrc0M1UldrOHFIQjNTN2NLc1dyMkZEQ1pvb3UyT2xj?=
 =?utf-8?B?eG5qbHFXNDhnQXdWcE1sT1BXRkhhTnVPaHJEcWNnSG5TRWlhUjFjWUY5MVBI?=
 =?utf-8?B?WW1RamxQL1MvSWpUalFmM0YxQmY2TFRaeFhhMFg2K0REeTdpM3NpSmlDN0xY?=
 =?utf-8?B?emJFc3Z4WUNDNjFMK2RSV2RvQ3c3NW0wNWtTUWlac3BCa1ZZWXovTzFJWWZE?=
 =?utf-8?B?WUJDYmcxdDZpd2FaUFN6UUxiQzJCUm0yVXFvU1F6ZXEycE9zU2JRYlljSkww?=
 =?utf-8?B?c3dPT0ZJUFROZ01IS1B0aGJwNmZXRUVWSkVxNS8rTHprdTRLekNLV0RFRVpv?=
 =?utf-8?B?YWlGeUE1MWhWb1RwaTBiNUZNTVpyVWRqTWJtZ1dIcTFBUHgzanRYSlFzYVFx?=
 =?utf-8?B?dU84bkpWMmhtTlR1aTZoSVNvbHVlWUhIeVFDMEJVcjRGUmVML2lTM2lpM3Bk?=
 =?utf-8?B?QmdEUDdhbC9rQ3E2SWpOdXMrc25yeXEzS0ZJd2FzZ2ZxZFE4OHplVUZ2akNq?=
 =?utf-8?B?aXJ3Q1pXODZFWDc4dCtMMFA4aUhRTDg2NmkzYW15UENjaUZDMFNHNzRweDFs?=
 =?utf-8?B?Y1ROYUZWYVorWWpGdzRaS3NWalprcmw3TlRDKzZvMFJTTFpsdUpuc1ZCWDFI?=
 =?utf-8?B?SFBrSndGRHpNdTVrV0xITmNUbEtKcXpKejd6bmNkTFRzSVBrMDRXTXdwR2o1?=
 =?utf-8?B?UC9xdzZmWkhZME8zNzNoZ3doZzVYdzlza24xTHJZb21LbW9vL3BHQ1B6Z3Fa?=
 =?utf-8?B?QURLZHFwUzgxRldYZ1NmQWUzN1k4UHd5anBhd1NGQWxCa0c1QnYreU5xcDly?=
 =?utf-8?B?dGdEV0ZYSFM2WUF4WU5ERWNkOGJsZllabStPb3lIR1hhOGk2WEtlN3hKWC9Q?=
 =?utf-8?B?SzMzYng1VVdCVFc4WlBtTWdSUmZxVDdiTDVqTXdYN0ZaSit3NlpuOXlCdG9J?=
 =?utf-8?B?QW5QNVpBNDRhMy9UUGN2TitxcmhSb0FVWFZzSzRGWjc1aHV4a0hyQ1ZxcW9X?=
 =?utf-8?B?S2VFUCtkUXZMVlBNcVZPZGJmRVdsQkNNTllmRnZRb29kZ091Y1ZHTnJ1ek9r?=
 =?utf-8?B?M3hXRkZjaUt6SlFKbDhoKzJVamNOZ3U4amRSSUUvaFF3SE14NHRVV3J1UVN5?=
 =?utf-8?B?N3VkM3U0aHo3QVlsSVk1OE1qcDZoL3A3a2lFUWxDTTk5emNoUDAvMmRTd0FO?=
 =?utf-8?B?bzIveEhRdkl0KzFCSkRCS1VGN2V3MjdvQWwvUjZKOGd5NzZkeGRpdjNtR3FQ?=
 =?utf-8?B?cGxuZUN5UXhLcFVORlY3K1ZBZGVWcDJmUlFPYThUc25qaXR0YjkxRG9ZNlQ0?=
 =?utf-8?B?aWhpcXhWL3RYYjNmV0J5eVZjS3ZRQ1p5MXZDdU42ay8yb2VwcXdoM2xmLy9Z?=
 =?utf-8?B?ZlQ4dThPb0hFaGl4RnVMc3JlQksxMjJSUFQreXBrb3lvWkJKK04rNmhEL0dy?=
 =?utf-8?B?Z3d5OHU4bFB4MVovN3pvZWt4bytnbXljMVNPYnZBU1hNWmM5RGYzcWdnV1V1?=
 =?utf-8?B?Z1JFY2tMb2VEd0VWKzk3UHFHeitYZlBETFh4U1JiMlh5dTREeUZzMlYwYlpL?=
 =?utf-8?B?bDVkOHRhQ2hyWlFuVnppdXJ3UUJqQnBjTk1LMGtyYWJOd2NDeXBJZElBRjhX?=
 =?utf-8?B?b0hQZklCUEEvQUxaZUk5Ry9pTzh1eFc4NWZhSE9RR2ZzazVTLzNheldnV0ZJ?=
 =?utf-8?B?eUhhRXQ5VkJVZXlJeDJmQ3UwRDR6aE4yeklaVXdjVUlnV3NkOTF0am54VDR2?=
 =?utf-8?Q?eVY3lBQsvcIfeY0FiN099+vUG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd09cbe-96f0-4421-fe76-08dcd2c364b0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 00:39:43.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imJOMHR4G7Q/g55RyRyK3JU8WOFkJYQjfu42hyyzrZfk/VbCYkmBCHeG4xaj3dxUeRVwu/c1KAK2JApg4EQk0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7630
X-OriginatorOrg: intel.com



On 4/09/2024 3:07 pm, Rick Edgecombe wrote:
> Teach EPT violation helper to check shared mask of a GPA to find out
> whether the GPA is for private memory.
> 
> When EPT violation is triggered after TD accessing a private GPA, KVM will
> exit to user space if the corresponding GFN's attribute is not private.
> User space will then update GFN's attribute during its memory conversion
> process. After that, TD will re-access the private GPA and trigger EPT
> violation again. Only with GFN's attribute matches to private, KVM will
> fault in private page, map it in mirrored TDP root, and propagate changes
> to private EPT to resolve the EPT violation.
> 
> Relying on GFN's attribute tracking xarray to determine if a GFN is
> private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
> violations.
> 
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Split from "KVM: TDX: handle ept violation/misconfig exit"
> ---
>   arch/x86/kvm/vmx/common.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 78ae39b6cdcd..10aa12d45097 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -6,6 +6,12 @@
>   
>   #include "mmu.h"
>   
> +static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
> +{
> +	/* For TDX the direct mask is the shared mask. */
> +	return !kvm_is_addr_direct(kvm, gpa);
> +}

Does this get used in any other places?  If no I think we can open code 
this in the __vmx_handle_ept_violation().

The reason is I think the name kvm_is_private_gpa() is too generic and 
this is in the header file.  E.g., one can come up with another 
kvm_is_private_gpa() checking the memory attributes to tell whether a 
GPA is private.

Or we rename it to something like

	__vmx_is_faulting_gpa_private()
?

Which clearly says it is checking the *faulting* GPA.

> +
>   static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   					     unsigned long exit_qualification)
>   {
> @@ -28,6 +34,13 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
>   			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>   
> +	/*
> +	 * Don't rely on GFN's attribute tracking xarray to prevent EPT violation
> +	 * loops.
> +	 */
> +	if (kvm_is_private_gpa(vcpu->kvm, gpa))
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   


