Return-Path: <kvm+bounces-17991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8EEC8CC91B
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAA1D1C212B3
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E391114901F;
	Wed, 22 May 2024 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CGmb+PWq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2196148840;
	Wed, 22 May 2024 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417292; cv=fail; b=FEHk9SwY59aHWViKVU+nqr7OerFL+GFV2AgfEbI14JoWBP7RmlVWImr1pxxqwChwn3X251QN1eolK6oGe2/u5lIucv38JgRaDbNTPqCJdSdJEcbcY2YhxpsLRzR8Ivn2lj0FFEbtOVcYsVGJFBAH4xB4NIrFrzVjqiFtY8eklWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417292; c=relaxed/simple;
	bh=BOhwTeyEmqFCpHVtz9ySTkRNF7usRs82eDwAKdkxdlI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O8SmHi/VNytbqqlemS0lxN298AmOHSRX4FCnw5NcjsYg0kkOl15zfK4HFLOnvdyZk7j5en+QHf7pBtYka50e4Nl+pubrUjlchaVhmtULG7DyvMr9VVKI0qinBsxBfnB5/QnWbIqZTm9XNiaGQIFcKixMzEHbuf7PQWBORj4T/bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CGmb+PWq; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716417291; x=1747953291;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BOhwTeyEmqFCpHVtz9ySTkRNF7usRs82eDwAKdkxdlI=;
  b=CGmb+PWqameqaeIPMimnROooxsHICxyxchU36KSqpfcz0oLp7lu0wv7D
   2SuZVfUdD/Ef5m22gAFJNqjKoDnmSzewo3W+VfWIEmHU3Zb801F3wX/XI
   FJBrzKmOzIQXXshjRIAjKSuaIALfHAWuyisKjDHMDXX98CTmw3ZBIhjyz
   AQ83thbZ5k22C8s6I04EfBeDZzsF3mWyui7O6Q9wvmE7mBhOIQQQl5P0s
   8/1+GEP6SG10RVb17VLXPZtnVGe4v7tP7NzKWEHDFo/7z4VPNpbUymuQ2
   rUUIxGPR5p/Vs2Rwyds0Daw2v4FStj0i1Jrzy0KnBdVtY/g3/jxvnC9Wx
   w==;
X-CSE-ConnectionGUID: gLXueeLzQN+C/phYslvU8g==
X-CSE-MsgGUID: xwvCUhwrQ6SfJtIrMMt4Iw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12817282"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12817282"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:34:50 -0700
X-CSE-ConnectionGUID: pGkfrvWIRyyjwfcfzAvzYw==
X-CSE-MsgGUID: ihVWqaWXTPSEkRyiedWuxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33902284"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 15:34:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 15:34:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 15:34:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 15:34:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHBgAFE4CRHi+85qDeBlAkMMkpT3s55DmBYKmcEYHWx+wPtxubwlP6pudVWUDoYA6zlUI6eFCh5eE+992q3lnfXi5KgylXY+Q93c9P2IN0JUIzzq21xfQaVBegYyzbtbnTyGGLtSX52upJyEbi2ATVGFvYg8NdJBCsko/IVIrmFjGySHLXHc7t4efmSlAAO44ZHczKcpgaLvWHd6zBn2bWb51/tVPcX8lUdSxF2/XU+2bNuyIYk0nQ90f5qqXY/hV8atLUvHYcvNAm2wioicjfUDU4VbMkeoHI0aPfMrxoyRWD3SSkvhq4hq/HMeSWyof8419iicuoHIxzEVb/8eZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgRsqzb8g2rHNo2YABMSOeGT3gCYs5IDQZkeBp9PMOQ=;
 b=FD1u5+U0uq/3ntcKMUCTaXEDPbi6fBaRPqK9pqpgbOgKTp6rwqqgv22EGVHqxj6G2unOWi+UD/h42dKWDGfGEwBhw7T7GAQOuP6PpQ7vcuVu4b5GoZMtFMA9+3Nj3ZQTqMBFlUTvPnrLSHVfDeiSjCbd2kjKEkAyyqy9G9vQS/oAT229iAHYgOjHvCEhSY6zXhAC+eoTiTBaqcu19nxLOmqphKpOuqlgivbozZgDwqvsb6BgUBqcPK7LLdpMsoIopWnV/aGLGiGw39zQldEw2HFYD3ke/2ENJ5JjwsFFxudNClxU7/+5zO/NykICAg2LDsSBPdA8GLrcmffA+FBDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB8015.namprd11.prod.outlook.com (2603:10b6:510:23b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 22:34:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 22:34:47 +0000
Message-ID: <5df7b14f-9108-4aa1-b343-aebcb7e13a96@intel.com>
Date: Thu, 23 May 2024 10:34:41 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] KVM: Rename functions related to enabling
 virtualization hardware
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-3-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240522022827.1690416-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0173.namprd05.prod.outlook.com
 (2603:10b6:a03:339::28) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a1be155-2952-484c-fd1e-08dc7aaf62e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bzc2WWgwa0pjemlyeEtZQ1R1ZWNnU1VrOXlOeUxwL09hbVBXbGg0QnZqUUxv?=
 =?utf-8?B?Umw5NENMQ3JYYndad0Q2WXg2SjR3TW5pTlIwaTlZK3lkaVcxeE83QTRpNG9C?=
 =?utf-8?B?U1JQdHRBajVsVWxtdHFvTnE1eEpBcHJYNVVVemUxK0JnbDkzbVJ1YUxIR3oz?=
 =?utf-8?B?RDBUeWJ6VGU0WFRId2tFTkcyQU5KUWFzRWtxKzlDSVRvOUQrYUttNklrc2t2?=
 =?utf-8?B?bjF4dkhRVkZyUVRoOTV0QVloS2VRa0NqTU5HQkxJc09MYW9ZOU1PUzRYOWNQ?=
 =?utf-8?B?UHV3VzZPSm9qdEpvVm51TmtZeWFTL2lhVi94eXpxb3BGK1hxSVhUQTRhZlho?=
 =?utf-8?B?aWlzTUpHb0MyamFZYjlMTkFJN1ZiWkNQM3FKNmxFczV2RzJXY3pKc2N2cVVk?=
 =?utf-8?B?cW1aSENIeWpGd3ZnOGlwM0FEUFRlNWJEd2hlRGRSRHo0ZjJwb3VHWmhoZGJM?=
 =?utf-8?B?RW5XWUordUtQYTVSTXVMTG1lUUk4bTlBRUFZMzdGektsR1lNdDZIZk5YeTMx?=
 =?utf-8?B?dmYvcUY5OEFRUnpGUWhOYWYxNlBHT2lVYVNENFcvS29KdHpicFBMU014NG1V?=
 =?utf-8?B?aG1HZHh3SkdOUWVmMHFiNTdKdU5sK2IxYnppY3ZDcEFacGVvczhKQVNmR1R4?=
 =?utf-8?B?RHIvOHE3OEI2ckZtc042RTZuY09GR2hrb0M3Qld5NFlQdFo0ZURWOFJwMFJs?=
 =?utf-8?B?aUlZaG95eXdiTmcwMU5pUGlQVUp3eTFZb1BtVVkvUG0xNnhPODBWNS9BZTA5?=
 =?utf-8?B?VmdaS3Q5c0xBLzZVVEx1K0tCK1ZtekZwQWw2N2diZGFCME1VRkRmRUl0b1NY?=
 =?utf-8?B?UzZmOWk1U2ZtbW5CNng2MTdVTzF5blAwMnNTaVpzdEVZY3pJaVlDQy9pVVdE?=
 =?utf-8?B?TitTUEdOU3BJOENnVmNJWlFoUXNLcXVTU0pOZEtPeW1laW1IQ0J3ajhxZURw?=
 =?utf-8?B?anlFUVdTMW90K0k3Uks2KzNPUy8wd2R6SUg1MFBEM0hCQ1pUTWdaYVcrWGdP?=
 =?utf-8?B?K3pRb3hvSkc5ems1UzRYaXNSYUNkNERTQWppdTU0M1RNNFdFMXZWTlJoUThU?=
 =?utf-8?B?c2ZJYUpxL0RxSndtbDV3akdiZVNjRGIwOXpyWXFic3BJM2RMdUhWZ0tJcG5o?=
 =?utf-8?B?aGxDWEVjR05oU0VIczNoNWRoT3R2ZXplRzk2a2pWUFkxaWhiTk9VS0RjdUZJ?=
 =?utf-8?B?TWZEQTlucU5hOW9VeExsdnJJK05oOFlqZUhVUmc1T3dxQkVvYkFTSDgxOTZF?=
 =?utf-8?B?SWJlNjNoYnFGY0g1UnFnaS80dXdPUDBydS8yRDQ0cSthMDc0Rmw0bEk4VFNp?=
 =?utf-8?B?Ukl0MUxZMlJ0Q2RzbndiV3gvMmRFQXpYY25wUitEcTg5a2pYTG1DK01QNHps?=
 =?utf-8?B?WHZaSjlLNlNISC9tV1RJSkMwNWpZY0t6N0pGWDBUT2xWd2hCSkRtaVA4MjI3?=
 =?utf-8?B?K2I3TjFUVmNDUlBZQTZVZktkV1d5Sk1yYWpHeTMyT2JnVHEraUxJZGY0MTVa?=
 =?utf-8?B?SHR6NHV4S3JlOXRnOGNzeXBCQ1k4bjJCbGxoRWpRNllJTDBhZW5ZV0RIanQv?=
 =?utf-8?B?ZHRFS2gxd3ptbDdpTWJzTlpkaGJiMkYrU00zU2hrdEY3VlZIOEx6TS80V2pE?=
 =?utf-8?B?SE50V0xFRnZWRXpMWXJZL3B0bUM2Y3kva0d4UlFvMzNYSlVCRkpaWlpuSlp1?=
 =?utf-8?B?Y3hTT1hIdnBJSWxmTXJyZGVhWWl3R1lqdHRQWk9STkdrNjBOMGpIMTVRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlBvRGxIU2M2cGIyWXc1eUdZQ282bFc0ZlF1cms3NXJlM0paQVdRZFFvWkVP?=
 =?utf-8?B?bmFKUmQzQlVyekU2anNlcHpmcVFXM2lCWktzVEtXTkRtM1lGbjJhbjJrQ0RX?=
 =?utf-8?B?RUxDTkh6bFdEeW4wTUNHVzJrMmRUMmV2QTUybEI4M002Rm1rbTVFd09KMEpR?=
 =?utf-8?B?QndZd1JYSXRBZmVSTGFIYmZieENVZlRGRHZaQWhxTGJXYVNnbFhRWGkwL3Y2?=
 =?utf-8?B?YVdUQ1JUSk5CV1F5dVQwVm5CWXJjbE1tL0lRVm1ydVNwV2h5M1lRL3dEWENF?=
 =?utf-8?B?bVlLdFFOQ1hEWjZiejZIdjFYTC91TFFvazM0OTVWamJxdXloT1JYKzZsNHM3?=
 =?utf-8?B?YkcxMnVldHFLdldyN0xVQXZLUnJ6dkFaOHNGbmhTcy9IMG9UdnhZUWs1Qno2?=
 =?utf-8?B?QnVRbThWT0kvc0ZXR2xnVGRmQTlKU1djM2Z4YjZFQ0ZVeGQzL21ONHlmU01D?=
 =?utf-8?B?WTZMcW9wd2ZmRlc0UTZKaVVrc1MweitTQndRZUNZVVRxV1ZwbzNIVkJhQUZo?=
 =?utf-8?B?cDBaRGpWbGg5YTRaaFNHY21hN1FiWG9RbVkzUXN5eUc4TXBSeGI5Zk52Tll0?=
 =?utf-8?B?TGlTcFhISE80bktUbVpTRjk4bnVPMEZuUnF4TnVKSVZTaTh6QkZML1kxazRm?=
 =?utf-8?B?YU4yM2pseWwwbVZKY1NabjlnNXV2cWtvdUpFZXM2ejJ2T200R0hWNkprWjlz?=
 =?utf-8?B?azgzdW5mcmpWUFYvYTNCRGVIdlZtOW9tbXZoWjh5cFJQcGhCWmNFRitIdVA2?=
 =?utf-8?B?bXRvL1pxVU94M1pwMEtxdTRLK3BDSnRQRC9ZKzdRUGEzK1YrWEpEZ3d6bkI0?=
 =?utf-8?B?S093aFpvamYvVEQ3Y2JqTElQN05LZ1hNTEZ0ZFVCN0ZMYmxyMjd6d1YwQ3lY?=
 =?utf-8?B?U0xCMmt5MjlMMS91U2ZQMEptTXh2ZHpaaTdHQlN3a05ycjFGV2JRWmhyMytM?=
 =?utf-8?B?a1p1ZVVXZ1ZYQ0hNc1krMlJpa05RL2lmWjRZM1dRb0pJRkNYSGlMK2Q2K090?=
 =?utf-8?B?NDhaWlMybW5YVnlnbEZjUFdEMTVUZVgwOGx5ak5BTUNLc0VLL2x0Mk9YUW0x?=
 =?utf-8?B?WUxtTVlQMTNVdTkySmNPaW1sY0pFdXB3VE1GRk5QV1dTUkFFUlVRR1E3Wmxs?=
 =?utf-8?B?K1hBOFQra3NLTkRkQVJ6ZlJ0R2hLbEdmaDJrVndqMFIxeTc5NXRzT2Rtekox?=
 =?utf-8?B?MUlBcnVweTBGeFFuQjJjMEFzWitoT01ZY1M2aHFqSWUwYWtwT3JZakhzREc5?=
 =?utf-8?B?Ymd1YTBOYXM3VGFlU2hVRGFZSEcrV01NM2pRQnlIakNiQTV6Qi83Z2dSMEF1?=
 =?utf-8?B?dTUyYmlIeXROTXJWOXR1RFFZdnJCR28wV0R1ZGVPYzdmdm0zNVVHYkZZY1dq?=
 =?utf-8?B?K3hmT0IwUnpoOVdQOFFzYkJ4eVpEQ2M4UjJFUHZ5SVdVcUlEdlZGOE5Sait3?=
 =?utf-8?B?akF2bndhMVl0RVIra0plUGVzUysySklTMDZPVDFHN3pRWkg4elR6enhNMTVa?=
 =?utf-8?B?TlI0VkxkZ051cXk5em43SVRXUGpSZHVpczFRai96S1BUOUZvc0hQVXQySmxh?=
 =?utf-8?B?T0ZvekdaeXRKTTFXc1IrRGk0RWZTdHNkR2NHeWRGcGtsUGw2eTBZNTd5NUdy?=
 =?utf-8?B?Vm5ZdVl2aVViaEpadjArMzN1WUo4YSs1Ym1tbzlBS1BUUWxhejNDUW9FVGV1?=
 =?utf-8?B?WmRrUmpHMWVRdURXTmRDaDhHSzlXY1U0d20rSE5valJzSUVhQ0s1OUlQUDZI?=
 =?utf-8?B?QVRkNk9wbmExVjAwby9uVTZkM0JMNVBxdS9RZUxXbkFrUVRqL1luc1FSdWE0?=
 =?utf-8?B?UncxVDdXQ3R2MnBjRU5SNVVtZlJRM2NFZ3JIRktJWWtYM3dscU1yVjlzZ3Z3?=
 =?utf-8?B?L1JUSzV3TTdTdnpPNTlIUWVlMzZMdVNZWEk1U1NLN2lvQlFMZU8yakdjMm0z?=
 =?utf-8?B?YWE2Uk1tZ1RlUk1SZXlUMFJENHlmUFRvNGhEZnBSb21WcFNIZmFrY1N3S2JJ?=
 =?utf-8?B?MmZ4bXhIQWU0Q2xsMWNybU4vdmNZbWQxOEl2d1MrNjFQWHpFeVFhTzJmQ04y?=
 =?utf-8?B?d3lNSkd1TmFwTkhjRVZTMEpCaGRqS2JLQTVSUlRFa1FjTWVLWEFNTlE0a2ln?=
 =?utf-8?Q?LjppMP9RoRRU4+vdEWCQOtZTW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1be155-2952-484c-fd1e-08dc7aaf62e6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 22:34:47.8678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dh7f19E9eICibPLJ3t3EBpUKGWzEmMr4HVjDi8tDnMQGXavWlgs2c0Lrv9olr3nI2Fqj8kOOh/6N7DIBTjBwvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8015
X-OriginatorOrg: intel.com



On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> Rename the various functions that enable virtualization to prepare for
> upcoming changes, and to clean up artifacts of KVM's previous behavior,
> which required manually juggling locks around kvm_usage_count.
> 
> Drop the "nolock" qualifier from per-CPU functions now that there are no
> "nolock" implementations of the "all" variants, i.e. now that calling a
> non-nolock function from a nolock function isn't confusing (unlike this
> sentence).
> 
> Drop "all" from the outer helpers as they no longer manually iterate
> over all CPUs, and because it might not be obvious what "all" refers to.
> Instead, use double-underscores to communicate that the per-CPU functions
> are helpers to the outer APIs.
> 
> Opportunistically prepend "kvm" to all functions to help make it clear
> that they are KVM helpers, but mostly there's no reason not to.
> 
> Lastly, use "virtualization" instead of "hardware", because while the
> functions do enable virtualization in hardware, there are a _lot_ of
> things that KVM enables in hardware.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Kai Huang <kai.huang@intel.com>

