Return-Path: <kvm+bounces-34853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12A05A06ABF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021D21672FC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A36F4EB51;
	Thu,  9 Jan 2025 02:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IW6rpHk7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1115E97
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 02:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736388687; cv=fail; b=R1nTHL6hVfMi2YPYWw5iPkW5AI6l14Kel4Kx2kJZ3zMPFrXtdCTjd3BnKGpJlqQoN3+Key2BHxQQirB+qdWOSvIFzWBww2mTKAlfNkUzKgjn8pQ6yztirPVdLYaSbKu5+Qh0j+D4GO9MQqVwGmM6ZCSHnMuukixH5bfFTleVekY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736388687; c=relaxed/simple;
	bh=feVa9DwpG+6vZ8jXHaCoIgnLSzN/9VKsdy6dw9kmwD4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XiCLk77D3E/WWvn7Th52tn/Spy3SGJDc5SHzFsWsBjdfMUcXGLmnKUQqLAcyOlAWYEVUg86tc6KJua4byc4aL1XtRFFbO2wCCAqFZZOMlXaghAvFaFfjCEc7uSPFl7pNT/2Ggzh9ZvSWqNh3HlqtPGpNdchN1sC2bDyDVb5sxJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IW6rpHk7; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736388685; x=1767924685;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=feVa9DwpG+6vZ8jXHaCoIgnLSzN/9VKsdy6dw9kmwD4=;
  b=IW6rpHk7qefK4kiTvGEoDJkMPtashq9gTtLqDR9ZbCKs3ARyC8j4bCfY
   9TdjWg+SOZZwRt8iaql1toDhD51gauS9ykOEJadzLCf11GD2ki2nqVLbm
   WJQsQVsdnuW+HxVOaBDj3yI4kbdOGbprlIVVxCfbWxZ0Z77J+UXvqp8Om
   TmooIPkSdctliJkKVpOub5RRq5jb0jsynd4RE861eBx1StDa78G5j68L8
   NsjiTrGObqWcFUVU+D4Dm24URqN8BjU9ceQPcHvyQcedAN/O3VwKC6LMw
   YGZw6YAdANDDIg9HkJhe13MchgLWYQhy0dIi6mATISV4mfol/E7IV4zhE
   w==;
X-CSE-ConnectionGUID: Vxuz3DqQTL6O/6fOD1mt1Q==
X-CSE-MsgGUID: Nh/MwtNQTmOLAb1ZF91MuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="62011782"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="62011782"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:11:25 -0800
X-CSE-ConnectionGUID: CpGszwxGSOmJ3IvwNzcQvg==
X-CSE-MsgGUID: BZVL99qvS5eIZzIzZlzZIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="126564237"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 18:11:24 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 18:11:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 18:11:23 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 18:11:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyqtcuY30sJZWnWazvwkhu2IfvJhPcLVd0gs/AmXeKVVHTGUcFMyqcM1ssHidO90JLteg/J0ppmLH/l2VW0+25WbANzrHvfWcGmUFfPMgWa3Xg8JvrHCQZtAFbdf1TJRoZjKkBPlux9ZYeommAL1x/Gs1ZzyHfbvBDi0CeZfnVW/UVVuwARUUaHT6iom8a0tOU5+e40VRNGxdqqmi3kU4KVSt7vrZzItR3djRki9T753sKPrsBDRn+Gtcv28qtUdbxPm9M/97/I+fgxO1emVSaDdsxsOx2lQkmrVjLj6EjFMelKJLtZF00V7hi9hlf/PIVRNjxiEMumFQoLgh+KSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8c21ddyjBfJDORx5e6m4GhyZqmFe2imTYuTS/aplL0=;
 b=Tsu0uS7AXZkkXgUTfNPKGwTMqK/gB2wDzzl8edzgqOyIlnUGx+XnPrlWyg1cKPbvUUIyC9qSueaBMxhurVR5VZMBxXZpmWQoF0b/S+AQY5Z0ZkVxtlFmpfCXdMsOqOPB+l5tBLUWD4zGOFvflsK7DzDgadjPuJd9WQjS5vMl2+cFP4FyqTzeBDHNdGqsjifm7CaV5/GXAc8sMq2lipCbj4QdcswbLDvYmLPxc+WRUl2ZCL6t5+BaQi9yJ/Vm0T8zwy7jsA/VJFIbGf8muVWm78kSq4htdmf0Er2QvgWGlUlODQIZk+mIcMUmMhhz4JHKVJua6q6KcDolnelB7oxMBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA0PR11MB4622.namprd11.prod.outlook.com (2603:10b6:806:9c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Thu, 9 Jan 2025 02:11:21 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8314.018; Thu, 9 Jan 2025
 02:11:21 +0000
Message-ID: <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
Date: Thu, 9 Jan 2025 10:11:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0010.APCP153.PROD.OUTLOOK.COM (2603:1096::20) To
 DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA0PR11MB4622:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d4451e1-ac43-4433-dec5-08dd3052e8c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z0ZKQVl6c2hiNm1wZ0ZQMk1TUWdha2JtSEcycms0STBzWkhtTURKbi9RYktp?=
 =?utf-8?B?Qkh0aG11MG9ZOWdxMHVGbW9aOTdtV25yQ0daSkNyODI4d1hpVnREb3Q3RnVz?=
 =?utf-8?B?RmsvNUNpMzQySjUvcEpPbmdoR3ZwUk9zSVJJZU5EYzBRQjFHZkMweVN2QlNo?=
 =?utf-8?B?TU5NYWFWNXA5ZE5KTmpMdGxYY0ErWVVKR2MxNk1mZWtCalFmLy8wTjFFUU5Z?=
 =?utf-8?B?aU45cHdmWW1BL1dBVmZsVTZxblN1MzY1Nmlyd0YyWXpvRWlsaXhjOTNtSFNO?=
 =?utf-8?B?UUp3UllDdGcxaGI3a0VpV2NQT2RlaHYwaU9SaEFIUFdwL3Vxdlp1MHZ0dmNy?=
 =?utf-8?B?VzJCNTFFTWZIcVdVdkpnRjVSbVA5NkJOa3dsYkYveUJFeVdCT3h0Z3F3WFlp?=
 =?utf-8?B?R3N2bGlrN1d6M1RZL2RFZkxMSDZQRWxROEVBNTJLL25UeHUveHZLZWpTSFZW?=
 =?utf-8?B?emVqRU9UcVVtRHB2Z0cwTExZN1ZkcW9UNHpWWGtYb0FTc3RVSkR6NHBaYzdK?=
 =?utf-8?B?VUQzT2JINE9JRDNWa0ZzQVBvZEwvT1FlbVVLVHoxc1lLUGZVOTVlNnVSY3hZ?=
 =?utf-8?B?QmdGdWgyUWNUYTVYZTJmeGlGcFE3UVlHb2JNdHdmS3JXN0tjNWkyZDYvSUQx?=
 =?utf-8?B?RTVibWxvV3I5dVg3cktxZlo1OEFVZWJIYkwvUEFaU005WXZmRG5iY1hrQmNF?=
 =?utf-8?B?STBZV3V5allHN0VqZFA5N0JkNG1ubCtCVXNraVRLUnVvVTBWZHFTcUg0Y3hq?=
 =?utf-8?B?M0QxdXpDK3EvSlJxWFlvdm42ck8xckFLeEEzblIxVjY5dmxwd09yYU1yeWhH?=
 =?utf-8?B?QTZrYVNEdkx4K2ZycENPMHpRYUtSU29tSzlCbTBJOWoyYmZwTEw2WEVSSTZU?=
 =?utf-8?B?MXFybWlvQmJUdGNsTWlBUmhKK1g3WFFnTEFJZWhOeG0zcCtYT1FZamRhZ1V0?=
 =?utf-8?B?Uk43ai9pSy9vWTVEcGpKWk1jQWhZSGJZM1pzRjk2TTZBTUZPMFAyUXQ5dDhs?=
 =?utf-8?B?TEtIVi9oKzlxRW5QOGpYMEx6eElneUdmamNGTWRTQ3JQSUZqVnprYzh5RzY3?=
 =?utf-8?B?alpXRVlidUFEckFmMlVVdmJuaFhDNS9RZzNVOW84WERLc21lVzVNQzlYNVhk?=
 =?utf-8?B?UU14QStaMHNJSzFTU1lCdjU4SzNoTHUrS3ByZjF5ajAvVzJrS0dNS2NKL2t1?=
 =?utf-8?B?b3QvRXRFajhBY080ODVkZHR5bXFiQVhwZU9qcVFDeE1Jc0hKM0ttK0RpZHlN?=
 =?utf-8?B?bEZJZmNkdHljcUlxc0hQVjdiRXpsd0s4WWdYSXZFZWZlTUhiR0h1eU9KZzR6?=
 =?utf-8?B?K2w1b2N6Sk1pR05MbHZOQjV6TDhtandSUzJiV0w3YzBYUlBHcVRiRzZsVTAx?=
 =?utf-8?B?NUErSjZ0WWdBQWVqUXgrbFU2MUxOWXJmTHprZ1FCeVRvWHI3MHZvSExuVFZW?=
 =?utf-8?B?dElISkl0amRwbDkxRGd2c3R6aktvWEttekJZb1ZaNERMeEltcmY2R1ZJeklx?=
 =?utf-8?B?dmpDcEVDbSsrZDhhRVNxaHB6eFhRVFFBNGlyeExjSHBZbU5GbFB5ZGtvY2oz?=
 =?utf-8?B?d0cveEFNREdtcFpzM3NyVnEvRVA0Q2tCNlU3TmV2ZXJiMFM5L05iQ0RlY1dl?=
 =?utf-8?B?ZDVFU0ZhbEZzTGJ5WElqcFAxcytMWDFnbzl0ZmtoeGprczNCbk8xeFZyL2s1?=
 =?utf-8?B?TW1NV0Q3eTFEZldvUFJiZXhka0xQeHRMQWxIQzA0aHN5M2dOOXA2V1JKVERh?=
 =?utf-8?B?RnAzdXlnZ3ZCSmVZRGtKdDYxemVHWkZ4eGlyQWJwcDFzZ3BUWUVDUEViZ2xQ?=
 =?utf-8?B?QnMzcFE4bWpPZ0dFVWRzNWs1TmVZK2ROWndLRjVvTTlHK0lOSWVOa21oVlZj?=
 =?utf-8?Q?rEDjqpyFzQDcz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnQ5U0RpT01pRGRMZWkxYmlpd2VCOW4rZzhKUStMemwvdFhLS29MTTlqYUlh?=
 =?utf-8?B?alV6UnIrN3luK1BnMzBrVVd6dTU2YmJkelZyZC9iY0d1WDl5bDhreGdhR0JV?=
 =?utf-8?B?bU0xTGF0Yzk3SGUvaU5ybzVtelBLS0VZYUNCODlGTks1RWtPVUhaYjBoaWdJ?=
 =?utf-8?B?cW1RZS82cm1yeXJxNkprMmhrMU1BVXdjSjhhak5XSHU2MU9uQlIzUkhIbXQw?=
 =?utf-8?B?RjkwSjJ5eXIwMHVEWGZWVmpzWWFvc3BJY0NSUDBBSjRCamZhdE1MYjd6RlJx?=
 =?utf-8?B?akQwUExVTG5RY01GaDY3cFBIUkVhYXR6cGwvOVp2NExwaEtBRG5SdklVbklj?=
 =?utf-8?B?SGJhcnZYK0NwSDVDd2RCUFI3K0E0ZUdRNnovSyt6MWxTbTN6YXZ5dUJoblp4?=
 =?utf-8?B?YWtDUGdjREJDWVUzYnlzVWRLVW9Qa1gzdUpmRmRwN1lLQm9Nb0Z2YjdQd2hm?=
 =?utf-8?B?elpvY09ETnBBVU1xR2N0czlDeFdoTmVJdnd2Yk0xbXppeTBHYThBcGQ4anly?=
 =?utf-8?B?MzFoYmI2RWJ2bDloRDcvaDZHNVJOY1ZWclpIdmM4L2xycm1JTHF5b1lrNnBW?=
 =?utf-8?B?QVZQODFmQmdWTUdQakhKbFVQdmRsZGZEMnRhZm1BZGx0aFpGWHdFVk9Ra2Fy?=
 =?utf-8?B?b3QwS0RiQnhacXlyTlBIZHFBbHQ4YkJ3WWIySlFQYzJDVnkrbjVBaGhhWXJP?=
 =?utf-8?B?ZDg3bHlXMXFDV01WaUwxQmttcit4Z0pEVytnc1hHQmV0c0t4TjExTXBUMzdp?=
 =?utf-8?B?SXA4TEFIV3lXNk9heUM1aCswQ0VoZ1FZQTIzVE9KbXJ5QW1CTE1FY2JHQVBt?=
 =?utf-8?B?UEttR243emRHRVBhNVAwQmtQSFNndVYwdmkzdEZ5N1l2TWszWkVVNGVmL0ZM?=
 =?utf-8?B?cDgrbGtxY3dCL3RuWGxndEdHTXlJWFFzNysxbGNjdTVTQ2huZlpoNnNKZjNR?=
 =?utf-8?B?eWhxc2ZDMHp6c1VZVS8zUmlQTnBoRXp5dXBoY1Z3bE1ITHFEbFY5RnlINk1R?=
 =?utf-8?B?Yk1CUTkwS3FnWDBaaXQzRG9aenBXMnVROS8yQVk1Wmp1anVVYkYzOHBzQ3dl?=
 =?utf-8?B?emVpdFQrZ1dtZmdFUU1POFNQV2FpZ0lNNkNkWm9pSlZFSm1pU3lLWDRPMFRx?=
 =?utf-8?B?aDkydENCZ2dyejZ3ZVhMN0UxZHU5b3k3UlZBVjBwb1VYV1NzT1AzUkNSTTda?=
 =?utf-8?B?dTE4Tm1UUUVsNFlOaE5iTCtDUDFHcE5HWGgrNmRnSk9zTHJiOVdrckRTM241?=
 =?utf-8?B?RDdpcGFPMERsVDRmblYzSTFmTXFNQVdtbmVVK1JQeEgzWVNORDY4Yk1hRnoz?=
 =?utf-8?B?U3J3aEZaVlVBZzZxT0ZCRjYvOHdqUEE1OENmOGZLUHJBRXhvdnZzMG02dzNl?=
 =?utf-8?B?L0gyVFh1QU0yOXBXKzNXVEJadGs0MEZSZWZhR1NiSzFKeWNYOVdLbEdFZDFK?=
 =?utf-8?B?czVDTVJVVWVTelRxcmFvZ1ZGYTVJSzgzNlBtS0tUbUQ1V1R1eTE2cGcrTUdE?=
 =?utf-8?B?NzdrcFQ1OHY5MENKSXY2cHNtVDUvYWkyT1hRdk96UHJMU1pkaEZCNGo2RlpG?=
 =?utf-8?B?cmw3cjlQNTZDanRuT0Q1R0NGWk9rNDJKUms0cHRSd2MvVXdmZVlYdndtc3hW?=
 =?utf-8?B?NE15dHp2N1A1S1FhQmRheVB4MUhBQzdCdCtjamUzYloyQjI4QTJBVUp5dWtR?=
 =?utf-8?B?aU5wTVRSeVMrTk5mbHZ2QWhUSlRXOFBSMkZIek9TTG01QUNKbUVzclFISVFO?=
 =?utf-8?B?SGN1T0R1R1duSVdXanZoUk42M1NuQnJ2YzhEakpnU0VLMG85eTlDbktpTmN6?=
 =?utf-8?B?K0ptcUZuVXFVV3JLbjU3TGl5cm50ckZSc0dQT052Q2J2TmZ4T3Bnb1FYVEJx?=
 =?utf-8?B?ZFVhZGRuQldLVytqcEFCdzA0M1ZOUWJJdG5UMU1KZ21pOHBkdVZzTXJwbEd3?=
 =?utf-8?B?bDdVQUZtRGtwcWtEUFJvWEc2L1BxbGIyQVRRLzVpZXk5ZmF1bUJxTVg2VmdS?=
 =?utf-8?B?b2oyNWVYdDFwWWtuNlNiUjVqMFcyVnJaTy9MMzU2MXVmc1h5NzFLbWZSS1NK?=
 =?utf-8?B?dnBEYW8vRDhUNmVrd2lkRkw2RzBIWXExMFZBMFNQa3R1cEo4cFoydzVMSm5q?=
 =?utf-8?B?eUZmanhpK0FLdDZTY01LdTVFa051Ym1kR1lVVjlKc0VEK000VG1iYkQ5aGo4?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4451e1-ac43-4433-dec5-08dd3052e8c7
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 02:11:20.9379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3LHR1x33v5/52NsXKIn1uoXiqR575atYVQpjdKhBy4oeF0xeIfmWLwvR8RGrpQzZNigWddG/XEYdbQEj3si1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4622
X-OriginatorOrg: intel.com



On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 8/1/25 21:56, Chenyi Qiang wrote:
>>
>>
>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>> operation to perform page conversion between private and shared memory.
>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>> device to a confidential VM via shared memory (unprotected memory
>>>> pages). Blocking shared page discard can solve this problem, but it
>>>> could cause guests to consume twice the memory with VFIO, which is not
>>>> acceptable in some cases. An alternative solution is to convey other
>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>
>>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>> back in the other, so the similar work that needs to happen in response
>>>> to virtio-mem changes needs to happen for page conversion events.
>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>
>>>> However, guest_memfd is not an object so it cannot directly implement
>>>> the RamDiscardManager interface.
>>>>
>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>
>>> This sounds about right.
>>>
>>>> guest_memfd-backed host memory backend can register itself in the
>>>> target
>>>> MemoryRegion. However, this solution doesn't cover the scenario where a
>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>>>> the virtual BIOS MemoryRegion.
>>>
>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>
>> virtual BIOS shows in a separate region:
>>
>>   Root memory region: system
>>    0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>    ...
>>    00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
> 
> Looks like a normal MR which can be backed by guest_memfd.

Yes, virtual BIOS memory region is initialized by
memory_region_init_ram_guest_memfd() which will be backed by a guest_memfd.

The tricky thing is, for Intel TDX (not sure about AMD SEV), the virtual
BIOS image will be loaded and then copied to private region. After that,
the loaded image will be discarded and this region become useless. So I
feel like this virtual BIOS should not be backed by guest_memfd?

> 
>>    0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>> @0000000080000000 KVM
> 
> Anyway if there is no guest_memfd backing it and
> memory_region_has_ram_discard_manager() returns false, then the MR is
> just going to be mapped for VFIO as usual which seems... alright, right?

Correct. As the vBIOS is backed by guest_memfd and we implement the RDM
for guest_memfd_manager, the vBIOS MR won't be mapped by VFIO.

If we go with the HostMemoryBackend instead of guest_memfd_manager, this
MR would be mapped by VFIO. Maybe need to avoid such vBIOS mapping, or
just ignore it since the MR is useless (but looks not so good).

> 
> 
>> We also consider to implement the interface in HostMemoryBackend, but
>> maybe implement with guest_memfd region is more general. We don't know
>> if any DMAable memory would belong to HostMemoryBackend although at
>> present it is.
>>
>> If it is more appropriate to implement it with HostMemoryBackend, I can
>> change to this way.
> 
> Seems cleaner imho.

I can go this way.

> 
>>>
>>>
>>>> Thus, choose the second option, i.e. define an object type named
>>>> guest_memfd_manager with RamDiscardManager interface. Upon creation of
>>>> guest_memfd, a new guest_memfd_manager object can be instantiated and
>>>> registered to the managed guest_memfd MemoryRegion to handle the page
>>>> conversion events.
>>>>
>>>> In the context of guest_memfd, the discarded state signifies that the
>>>> page is private, while the populated state indicated that the page is
>>>> shared. The state of the memory is tracked at the granularity of the
>>>> host page size (i.e. block_size), as the minimum conversion size can be
>>>> one page per request.
>>>>
>>>> In addition, VFIO expects the DMA mapping for a specific iova to be
>>>> mapped and unmapped with the same granularity. However, the
>>>> confidential
>>>> VMs may do partial conversion, e.g. conversion happens on a small
>>>> region
>>>> within a large region. To prevent such invalid cases and before any
>>>> potential optimization comes out, all operations are performed with 4K
>>>> granularity.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>>    include/sysemu/guest-memfd-manager.h |  46 +++++
>>>>    system/guest-memfd-manager.c         | 250 ++++++++++++++++++++++
>>>> +++++
>>>>    system/meson.build                   |   1 +
>>>>    3 files changed, 297 insertions(+)
>>>>    create mode 100644 include/sysemu/guest-memfd-manager.h
>>>>    create mode 100644 system/guest-memfd-manager.c
>>>>
>>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>>> guest-memfd-manager.h
>>>> new file mode 100644
>>>> index 0000000000..ba4a99b614
>>>> --- /dev/null
>>>> +++ b/include/sysemu/guest-memfd-manager.h
>>>> @@ -0,0 +1,46 @@
>>>> +/*
>>>> + * QEMU guest memfd manager
>>>> + *
>>>> + * Copyright Intel
>>>> + *
>>>> + * Author:
>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>> + *
>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>> later.
>>>> + * See the COPYING file in the top-level directory
>>>> + *
>>>> + */
>>>> +
>>>> +#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
>>>> +#define SYSEMU_GUEST_MEMFD_MANAGER_H
>>>> +
>>>> +#include "sysemu/hostmem.h"
>>>> +
>>>> +#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
>>>> +
>>>> +OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass,
>>>> GUEST_MEMFD_MANAGER)
>>>> +
>>>> +struct GuestMemfdManager {
>>>> +    Object parent;
>>>> +
>>>> +    /* Managed memory region. */
>>>
>>> Do not need this comment. And the period.
>>
>> [...]
>>
>>>
>>>> +    MemoryRegion *mr;
>>>> +
>>>> +    /*
>>>> +     * 1-setting of the bit represents the memory is populated
>>>> (shared).
>>>> +     */
>>
>> Will fix it.
>>
>>>
>>> Could be 1 line comment.
>>>
>>>> +    int32_t bitmap_size;
>>>
>>> int or unsigned
>>>
>>>> +    unsigned long *bitmap;
>>>> +
>>>> +    /* block size and alignment */
>>>> +    uint64_t block_size;
>>>
>>> unsigned?
>>>
>>> (u)int(32|64)_t make sense for migrations which is not the case (yet?).
>>> Thanks,
>>
>> I think these fields would be helpful for future migration support.
>> Maybe defining as this way is more straightforward.
>>
>>>
>>>> +
>>>> +    /* listeners to notify on populate/discard activity. */
>>>
>>> Do not really need this comment either imho.
>>>
>>
>> I prefer to provide the comment for each field as virtio-mem do. If it
>> is not necessary, I would remove those obvious ones.
> 
> [bikeshedding on] But the "RamDiscardListener" word says that already,
> why repeating? :) It should add information, not duplicate. Like the
> block_size comment which mentions "alignment" [bikeshedding off]

Got it. Thanks!

> 
>>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>>> +};
>>>> +
>>>> +struct GuestMemfdManagerClass {
>>>> +    ObjectClass parent_class;
>>>> +};
>>>> +
>>>> +#endif
>>
>> [...]
>>
>>             void *arg,
>>>> +
>>>> guest_memfd_section_cb cb)
>>>> +{
>>>> +    unsigned long first_one_bit, last_one_bit;
>>>> +    uint64_t offset, size;
>>>> +    int ret = 0;
>>>> +
>>>> +    first_one_bit = section->offset_within_region / gmm->block_size;
>>>> +    first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>>> first_one_bit);
>>>> +
>>>> +    while (first_one_bit < gmm->bitmap_size) {
>>>> +        MemoryRegionSection tmp = *section;
>>>> +
>>>> +        offset = first_one_bit * gmm->block_size;
>>>> +        last_one_bit = find_next_zero_bit(gmm->bitmap, gmm-
>>>> >bitmap_size,
>>>> +                                          first_one_bit + 1) - 1;
>>>> +        size = (last_one_bit - first_one_bit + 1) * gmm->block_size;
>>>
>>> This tries calling cb() on bigger chunks even though we say from the
>>> beginning that only page size is supported?
>>>
>>> May be simplify this for now and extend if/when VFIO learns to split
>>> mappings,  or  just drop it when we get in-place page state convertion
>>> (which will make this all irrelevant)?
>>
>> The cb() will call with big chunks but actually it do the split with the
>> granularity of block_size in the cb(). See the
>> vfio_ram_discard_notify_populate(), which do the DMA_MAP with
>> granularity size.
> 
> 
> Right, and this all happens inside QEMU - first the code finds bigger
> chunks and then it splits them anyway to call the VFIO driver. Seems
> pointless to bother about bigger chunks here.
> 
>>
>>>
>>>
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        ret = cb(&tmp, arg);
>>>> +        if (ret) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        first_one_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>>> +                                      last_one_bit + 2);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int guest_memfd_for_each_discarded_section(const
>>>> GuestMemfdManager *gmm,
>>>> +                                                  MemoryRegionSection
>>>> *section,
>>>> +                                                  void *arg,
>>>> +
>>>> guest_memfd_section_cb cb)
>>>> +{
>>>> +    unsigned long first_zero_bit, last_zero_bit;
>>>> +    uint64_t offset, size;
>>>> +    int ret = 0;
>>>> +
>>>> +    first_zero_bit = section->offset_within_region / gmm->block_size;
>>>> +    first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm->bitmap_size,
>>>> +                                        first_zero_bit);
>>>> +
>>>> +    while (first_zero_bit < gmm->bitmap_size) {
>>>> +        MemoryRegionSection tmp = *section;
>>>> +
>>>> +        offset = first_zero_bit * gmm->block_size;
>>>> +        last_zero_bit = find_next_bit(gmm->bitmap, gmm->bitmap_size,
>>>> +                                      first_zero_bit + 1) - 1;
>>>> +        size = (last_zero_bit - first_zero_bit + 1) * gmm->block_size;
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        ret = cb(&tmp, arg);
>>>> +        if (ret) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        first_zero_bit = find_next_zero_bit(gmm->bitmap, gmm-
>>>>> bitmap_size,
>>>> +                                            last_zero_bit + 2);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static uint64_t guest_memfd_rdm_get_min_granularity(const
>>>> RamDiscardManager *rdm,
>>>> +                                                    const
>>>> MemoryRegion *mr)
>>>> +{
>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>> +
>>>> +    g_assert(mr == gmm->mr);
>>>> +    return gmm->block_size;
>>>> +}
>>>> +
>>>> +static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
>>>> +                                              RamDiscardListener *rdl,
>>>> +                                              MemoryRegionSection
>>>> *section)
>>>> +{
>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>> +    int ret;
>>>> +
>>>> +    g_assert(section->mr == gmm->mr);
>>>> +    rdl->section = memory_region_section_new_copy(section);
>>>> +
>>>> +    QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
>>>> +
>>>> +    ret = guest_memfd_for_each_populated_section(gmm, section, rdl,
>>>> +
>>>> guest_memfd_notify_populate_cb);
>>>> +    if (ret) {
>>>> +        error_report("%s: Failed to register RAM discard listener:
>>>> %s", __func__,
>>>> +                     strerror(-ret));
>>>> +    }
>>>> +}
>>>> +
>>>> +static void guest_memfd_rdm_unregister_listener(RamDiscardManager
>>>> *rdm,
>>>> +                                                RamDiscardListener
>>>> *rdl)
>>>> +{
>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>> +    int ret;
>>>> +
>>>> +    g_assert(rdl->section);
>>>> +    g_assert(rdl->section->mr == gmm->mr);
>>>> +
>>>> +    ret = guest_memfd_for_each_populated_section(gmm, rdl->section,
>>>> rdl,
>>>> +
>>>> guest_memfd_notify_discard_cb);
>>>> +    if (ret) {
>>>> +        error_report("%s: Failed to unregister RAM discard listener:
>>>> %s", __func__,
>>>> +                     strerror(-ret));
>>>> +    }
>>>> +
>>>> +    memory_region_section_free_copy(rdl->section);
>>>> +    rdl->section = NULL;
>>>> +    QLIST_REMOVE(rdl, next);
>>>> +
>>>> +}
>>>> +
>>>> +typedef struct GuestMemfdReplayData {
>>>> +    void *fn;
>>>
>>> s/void */ReplayRamPopulate/
>>
>> [...]
>>
>>>
>>>> +    void *opaque;
>>>> +} GuestMemfdReplayData;
>>>> +
>>>> +static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection
>>>> *section, void *arg)
>>>> +{
>>>> +    struct GuestMemfdReplayData *data = arg;
>>>
>>> Drop "struct" here and below.
>>
>> Fixed. Thanks!
>>
>>>
>>>> +    ReplayRamPopulate replay_fn = data->fn;
>>>> +
>>>> +    return replay_fn(section, data->opaque);
>>>> +}
>>>> +
>>>> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager
>>>> *rdm,
>>>> +                                            MemoryRegionSection
>>>> *section,
>>>> +                                            ReplayRamPopulate
>>>> replay_fn,
>>>> +                                            void *opaque)
>>>> +{
>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>> opaque };
>>>> +
>>>> +    g_assert(section->mr == gmm->mr);
>>>> +    return guest_memfd_for_each_populated_section(gmm, section, &data,
>>>> +
>>>> guest_memfd_rdm_replay_populated_cb);
>>>> +}
>>>> +
>>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>>> *section, void *arg)
>>>> +{
>>>> +    struct GuestMemfdReplayData *data = arg;
>>>> +    ReplayRamDiscard replay_fn = data->fn;
>>>> +
>>>> +    replay_fn(section, data->opaque);
>>>
>>>
>>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
>>
>> It follows current definiton of ReplayRamDiscard() and
>> ReplayRamPopulate() where replay_discard() doesn't return errors and
>> replay_populate() returns errors.
> 
> A trace would be appropriate imho. Thanks,

Sorry, can't catch you. What kind of info to be traced? The errors
returned by replay_populate()?

> 
>>>
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager
>>>> *rdm,
>>>> +                                             MemoryRegionSection
>>>> *section,
>>>> +                                             ReplayRamDiscard
>>>> replay_fn,
>>>> +                                             void *opaque)
>>>> +{
>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>> opaque };
>>>> +
>>>> +    g_assert(section->mr == gmm->mr);
>>>> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
>>>> +
>>>> guest_memfd_rdm_replay_discarded_cb);
>>>> +}
>>>> +
>>>> +static void guest_memfd_manager_init(Object *obj)
>>>> +{
>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>> +
>>>> +    QLIST_INIT(&gmm->rdl_list);
>>>> +}
>>>> +
>>>> +static void guest_memfd_manager_finalize(Object *obj)
>>>> +{
>>>> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>
>>>
>>> bitmap is not allocated though. And 5/7 removes this anyway. Thanks,
>>
>> Will remove it. Thanks.
>>
>>>
>>>
>>>> +}
>>>> +
>>>> +static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>>> *data)
>>>> +{
>>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>> +
>>>> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>>> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
>>>> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
>>>> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
>>>> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
>>>> +}
>>>> diff --git a/system/meson.build b/system/meson.build
>>>> index 4952f4b2c7..ed4e1137bd 100644
>>>> --- a/system/meson.build
>>>> +++ b/system/meson.build
>>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>>      'dirtylimit.c',
>>>>      'dma-helpers.c',
>>>>      'globals.c',
>>>> +  'guest-memfd-manager.c',
>>>>      'memory_mapping.c',
>>>>      'qdev-monitor.c',
>>>>      'qtest.c',
>>>
>>
> 


