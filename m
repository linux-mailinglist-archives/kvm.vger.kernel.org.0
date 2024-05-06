Return-Path: <kvm+bounces-16698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C30BB8BC9BF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78F022831EF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D001411CE;
	Mon,  6 May 2024 08:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UgNF/edU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1042052;
	Mon,  6 May 2024 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984878; cv=fail; b=gCwBBWLkw4RxZUn7G0FdYck+nYeggFH3w3vVinxmwSjrr2U4ogyJ+JAbAo251wsBGVbZe0A0b/gRSrvwH2tecO0fgOXKWyyIiZxqmyvjmT7t00KUHtPTNbeVU1W2hafXmJwm5Kn5ZlCHVaGz0SAWwuLQrHGy51zjlBOVl3Xogec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984878; c=relaxed/simple;
	bh=TlGbTsksq78cX7BS8yk08BL8+9P0o65f1/2NOPQ3ZJk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HbKqOaI2/MRETveEmZ7lUUnlo2g3RXwcHujuqI5fQ2uycZ69c4W7xaYT2zNiN1fgcetU3DlCikaveXi/5re4SlUG8LLu3NnBGb97W4dcoqHhJb1K3Bo6OD4Qv3GcQ8gk3KqtIgjWOj7+X4dYQgZ0RcSrl+nnRSU9i/1iz4Z8+r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UgNF/edU; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984877; x=1746520877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TlGbTsksq78cX7BS8yk08BL8+9P0o65f1/2NOPQ3ZJk=;
  b=UgNF/edUzUyayaPQ3OOREl3wHHpl5CQMO9HEZquYq4xU3c/2Pyjn/YW9
   wkTHeI8mL/3y4L9/FcDGg4dpZ4gKyLCjZkFeBFhABQRCUvpYldHh2IzDK
   IJPyK/euKmnKEBKhXPCeXLlDehYoycgWQU14AITu4FJsgiJP6jHGhSU0z
   +ac8HDeC9bfPjAatH3lO5b+HBLYBHJK290MzwlNTlZMK1vLyjPPf+fY2E
   Tmfzj9rWDnGxNUO5yAf6eO34oyWZ3UQd28qLP/X4IIRmyAnn2gVjq1ndO
   QV6joPzjI2z6ESldsgOmB/LxkvfnRmbc+8BIgtYzGJxgEfXFpGkofSAFi
   w==;
X-CSE-ConnectionGUID: J90JxiGrSrOjiVyzsWoUzQ==
X-CSE-MsgGUID: tikB1ZMVRhiCdXfTDtmEAw==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="11254515"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="11254515"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:41:16 -0700
X-CSE-ConnectionGUID: OiKZsdcQR5eaSqORd/kwpQ==
X-CSE-MsgGUID: TTqWkT1NSg6VACmJzSxl9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="51286381"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 01:41:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 01:41:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 01:41:15 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 01:41:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPlNZ/2ECh9+CvaOcPHUYO9kP3GufxpG49jDV1tm0Lm5dJ9hE2HxVv8Am1wxl7SARlx4olzjBpqSmPZEqwT6b/90WkyNF3wLISFJULtR6I5wS2pTF727SoEh8Rb5Ob3dvidC/CFP9sYWLHrsX/vV5xVvCTWus7YIxVegBWqPsH8zIPK4g/HYR3nTtUrxuHjihrMHcZsnxn/XmcgoWzslIfpdB2yX4irtNNVG+HJfLy+Iu5P93v6HA6/D9PHNanv8F4ldKwRNyakq4AI87UQUu/RjyfyswejjOOVetCzVr6KkeKbke0Q1l/34JAxSXU/YOOSs1kNvTUyv0qWp8Tbk7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GEzs1G3kmoPppA/NPGJ6lcfNiVnMTy6gjEGGbVe194=;
 b=cx2WadIaQ0rhh1FtihUQpeswfzcMe/bz/ys2bOQex86Aqe/m7Ix5fyBF9w/Da/AsqAOVx/Va95WvP5m25rLVJp7R/H6pLBfsczYZs5lzv1Fy4aqPpSDCI1cc4OsOJH5n2OZltAB0hb4DVonwVMNZ2WBNrLjLi6VH3hq8E0cBOBzfou/60aLvUOQeNWKxvhpZ96Gss4FeF2dBQGJR/UaSdM8YtTjxiHWQfEMTBC8MZmwD4XDu/h6PNHNIRG3ev5DEs3ZY5XNQJ+lLYxkS//YpgOJA2L+X/QO3fcsb4KnPjhe83fdygpIuO/2b+0sIIhtyRzS6yYwya7aiPpo2VO8hVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 08:41:13 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 08:41:13 +0000
Message-ID: <2f761cff-33f4-4434-a900-f87b6cf72016@intel.com>
Date: Mon, 6 May 2024 16:41:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 21/27] KVM: x86: Save and reload SSP to/from SMRAM
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-22-weijiang.yang@intel.com>
 <ZjLHIwCsLoatrxQ4@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLHIwCsLoatrxQ4@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0057.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7880:EE_
X-MS-Office365-Filtering-Correlation-Id: dae693ce-be1a-4d9d-4e11-08dc6da848ff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MXVZbDkzcnZBOExpQWhwckRDSGozQ1ZYQW1TZVJvQUcrSEY0dTZweTJwQ2h1?=
 =?utf-8?B?cEZ4dTgwWFJFbFlZcHNZaThxNXJueisyTHNQUVVqTlViRTIvRTBCKzVqZy95?=
 =?utf-8?B?YkdPVmhYWUFEdlBua0tZY0pXdFpCRURRdmxRaUwwZzNHT05xQVZIRG5Zc0J4?=
 =?utf-8?B?VGNZeVBlQnhnUFVYVHFYU1ZuMjZXM3ZNamYwNU56NmNlUHdhbVA0U3VBbHJt?=
 =?utf-8?B?ZXlLa1dOVGNkUjRRWWcyY1ZnbVVqa2kycjkrVHc2Y3ZEck00Zm9ySU9QcHZ6?=
 =?utf-8?B?ZjhlYXNKaFh0VWxqak9BVC9FMzlPaGExek1hZnhoVUdEMEMrQmxwcWN2SG9z?=
 =?utf-8?B?NVNUdWlhRGJuQW1nWlFmT1JUSUJwQnFCSzF4Y01NeWxLeksvQnVHTkFxN1pt?=
 =?utf-8?B?RWNHbnUvekFERWtSYzhGTXRKejBsR0hPa0ZWNUV1ZkV0YkFGdWJzejg1dVVp?=
 =?utf-8?B?T08zS3k1amdrR0c1SmpGWnJwTmV4d2JOY1FjQnVSakhQRDJpdE10VWhxQzdp?=
 =?utf-8?B?bFdmY0pSenRFL1VTdFdDZnZSRGhpUEFFNE1ZRmNTYVJPYkdOZXgyNmR6NCsy?=
 =?utf-8?B?M2tRMzlPRFVybmpFUGVTOVpwb0l4MXJuMHNka0RQbDllQUVxWXhDZ0ZjWGlI?=
 =?utf-8?B?bXprMDE3eU5OdlQxWDJXZjRDRDhKZDNnSGg5TktHa01xQnF6Uk5jV3ZYakth?=
 =?utf-8?B?YWlCM2ppQ1JHSW9xZVVGS0dXbFpzaXhib2ZsdEhOMEJBTVlMVDc5STBYQTNy?=
 =?utf-8?B?alBRUXpBN085Q2VKbEZwekNXY1VDOHJHQlB3TGxWVEZaY2tZZjFidU5ERytW?=
 =?utf-8?B?bjA0WitBMEZZSjY2RG1WN1lMaytkRGxsY2srMkJ1bTBmUW9kYm50clBtY2Q5?=
 =?utf-8?B?QjdnQ1JzSUtOYmxBMFBEdGVGa3V3UVhMd0dqSHFOcHhGMDFGUVhkdHc2aWNG?=
 =?utf-8?B?citDNHY3dVJ5dWlUYm1FeTZHY1owd0RTUk1FTExSa2dEa2xZNVlrcklaWUVK?=
 =?utf-8?B?cTVqT2FXcFh6WnhCVXM3WHNsWW54YlpHMTdjRE1rdmNYQlVWcUpTSTVVZk8w?=
 =?utf-8?B?Wklrd3VSbjMvNnVOelpmcEFNNVBtMGJoNWUxOG5rRExXOFhBekZwSVdMN2dj?=
 =?utf-8?B?M25pS3FNRUxCOGlaa1RlWEc5M1JqQ3NyU1NKVElxYzlXc3BRdkcwR0ZYeDkr?=
 =?utf-8?B?WENYenRSZEc4RmFFcVhXVERJSENNZndHMXp0SElBY0tGNU9weHVoZkhqMExG?=
 =?utf-8?B?ZUZJcDhpVEdmb2F1Z3g1NUZYQkdtZzdiRFQ1LzJQVHczczhqSnhLTzRZSXVi?=
 =?utf-8?B?a0g2UzJOQ2xCNHZOdDVnQmJiWWQ4SmE4aysrajBSWjhNdmx3WWloeFVtWTJD?=
 =?utf-8?B?Vi8yRW11ZEFVU1JLRVpvTlNjUmFpNFhWMnBUWnJJL2doSVZ3ZEMrTGRVRGZM?=
 =?utf-8?B?c01FWXY4b2RhRTBJOGlSVjU0ZXFoZ3lWckRDM0FWQnNJOXhVQUVKTTh6TmxP?=
 =?utf-8?B?TlU4a2hmM2wwMkNyRDJUV2ovTVdiR1o3MmF1TFhLQ1gvanprTHFJckk0UW1Q?=
 =?utf-8?B?cy93aFcwc1JOVTFpNjh1YWVZUHRSc2xBY095bFlKSnJhd2dsRGRyUytXaDVh?=
 =?utf-8?B?c3ZHd21BdStQTWFMbDZSbHRpWWdla3AzUGxkelJ1b0FZQ3FQTHVFZXpmTzha?=
 =?utf-8?B?elF4b3doUjZMSnZESk4wc3ZHQitHZzZ2YmhtRnI3RXZGbTExYVYvcWVBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cThydmhaVUdhV1ZsRlBZTVlySnZXaGR3UkxYWm5CUGtnYmFoRXJKaklrTkNP?=
 =?utf-8?B?c0JsMmZhOTlZaTN0c1lld1MxTzhQcnhYL0Fsc28vSTFVWUwzaEg0RGZkeFBq?=
 =?utf-8?B?eHFKc0ZpVWFIU3htM2NjUXd1UnBGWnJ4T0VhWXMzem43ZVB1bVNMVjdhYmFS?=
 =?utf-8?B?dVdlaEF6ZzhqYzZDQnhDL3JIUHpWZWYrY3RtdE9YNWdRVzRNaDhDNTBna3o1?=
 =?utf-8?B?Z3RHUEdUNWs1cE1LaWlFVkkvQ1c0b1p0Y0syeEpOUUkyaHNsYXRKcDdwWUJO?=
 =?utf-8?B?dG5qYjZTSmgrYkVkMXJIdkRTV2FhOC9JaWpGdFBlRGEranBGSDI5MVdTOCtQ?=
 =?utf-8?B?SHJLZU5HQWdLZG1kdmpvVkIzSWhvQmM3aW0rUzduNlA4T0RueWsxMGpUKzBD?=
 =?utf-8?B?REcxL1ArMEJNc0E5WWhVZGtxS2hBT0R2TWVHS3lFRnE5NkFkTkpOMENUUHBk?=
 =?utf-8?B?R1lZMmZ0MzhWbHlCMjFzQzB2UWpWWldmV0xWeW8yY1dqNnpGTWFLQW9IamZG?=
 =?utf-8?B?VHhLOUEzSkVDZUF4UTV3Wm9zY0EvL1JJZjhvNHIrSDZOSG9aNG52WFBDSkc2?=
 =?utf-8?B?bkdMTEYwUzJVWVhMdkVOUmd4VFZ3cEdGV0tzSGhSeW0zaTcrY2VxTCtETi9h?=
 =?utf-8?B?QSt2ekpXRVY5UTA4S29aU0QxSHVjaGF5dkUzMTlzRmQ1ZDJqclFaMUZWL0pB?=
 =?utf-8?B?K0dCeXBWZ29HVTdsNVFxazB1Yjk1bCtEQkoreXg4cUdFeDRoUyt4V3o1V1E0?=
 =?utf-8?B?Y0lzQ0d3bGJCaE5LRmpnZUVvT3VhTS9rUFhRMDJJa1AzU1hwQUJVWmltTk5z?=
 =?utf-8?B?MDNEQWsyam9uenJsUlV6VStWWitzNEFYL1RmZUx1VnJsQ3JGV3RXNTF3UFdZ?=
 =?utf-8?B?aDF6c0MrRGtwb3UySXd0NjlCU1dHZVdvTGIvTm9TL0NFYjYreFpMMGVzRHp1?=
 =?utf-8?B?YUFPQko2Y1pXRWg0K05wWEppOTJtQ3cyNnRFSDg1VkkzdlFoM0k2em5TdjIr?=
 =?utf-8?B?b0dYSG9QMDNlSVo3S2RUWlEzcmRmTmFod0wzazRKUXZhZEw4cEt5emxqTi8z?=
 =?utf-8?B?aVhkdjRPSi9ERXBkK09hQk4xVjBlNzA4Z0QrTDhpbnhOUzVORk12aEVyY1Jp?=
 =?utf-8?B?OVR4bXZranJhZDBmaTVNQUpndDF0QmFhejBPcnkzSEJ2WmJGa3E0ZTFObzBB?=
 =?utf-8?B?VGZkQkhGaXVLN2ZISnNlTzIyWWVzWWg3Zm05T0p2OGxjU0RkYkJET1IwT2ZL?=
 =?utf-8?B?WTVtcG5UZFYvc2EvMXZWd3NoK2pQK1gzQkdMS1VDZG1nMmhMNjFBTkI5NWpi?=
 =?utf-8?B?TG5FSW9KbzRnaVA3RmRxOU1sSHFrT1hnTXFQVEpoMWRMWUthcUZSTTMyNDNw?=
 =?utf-8?B?ZEFRV085ZnJYNzhkSkNSa0VTUzNicDE1S1BraEZhTVIxZUVoR2RrWDFSMHNt?=
 =?utf-8?B?U29mSWlTRzl5L0J4cG02L2ZKaFE1UlRxRHJEODFIU3lSM3dQSUxTWmlnWC9Z?=
 =?utf-8?B?Z25UdDBkKzROQ0lWSWpvL2ptMFl0WDZNVzV5SmdKbDBCcHVHUFRUSTdsSkxy?=
 =?utf-8?B?b3dPaEdTZjZmNU1xMmNlMUYvaXR1OElEbmRoSG9HTEsrYVg3UW1tQUhrbkRF?=
 =?utf-8?B?T3RtSXJiTkszQjdIRWUrTmE1MElyZWNIb2pMY1dNMmlmK3pKdGNoT0UxUGZ3?=
 =?utf-8?B?cHdOSGIvUHBPaDZ6bjdRYXlPVERtSGdRTVRKVm5wdkpiZUsvR3dwd1ZnaE9L?=
 =?utf-8?B?bkl5UURpUXBMQTFJTVQxK1I3bklLRVZaZU5TSzNLTGx4OFF4ZFAxSTFkQ3kz?=
 =?utf-8?B?SitRQXlRL2thbDRRYzBIeXp0RzNlRDlRWGd5MWRFTzBtSDIrYjB3NTRTOUh3?=
 =?utf-8?B?WUp3VUxYcjdZdkRpOHVTUHZIdU5EclArZ1o1Sk95UlFUMFN2bloxbXB2b0xt?=
 =?utf-8?B?MXJvYzRjMVZsdThQVzZ0YWZRTFFFcTFSMk5YdlNTTUFKNmJkemZobERrSEN1?=
 =?utf-8?B?VjU3MnFsV3drVHNtV1NZQlNjQzF0MDhnaUtQT2cvTnE2UlFJdktFd1h5dlF3?=
 =?utf-8?B?d3poUGR4clRFRVJ2d0tvbkdUR0tzbXp6V2RxOW1WYXRFQVQzc1N4dmVpTEVK?=
 =?utf-8?B?aXFQUmlxZGM5K1hQUTRsNmF5TEhvSUVFcStCdDJVaEl5bGtiWFRoUTF5SmVN?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dae693ce-be1a-4d9d-4e11-08dc6da848ff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 08:41:13.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlAjodsmc/pslEFBqw8wefbjmUCnF7kPzSsBVGag0mQAWVIQA37rjZPp3buMgE4fwfK+XC5NIkfCIRJv+2jWog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7880
X-OriginatorOrg: intel.com

On 5/2/2024 6:50 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
>> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
>> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
>> one of such registers on 64-bit Arch, and add the support for SSP. Note,
>> on 32-bit Arch, SSP is not defined in SMRAM, so fail 32-bit CET guest
>> launch.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 11 +++++++++++
>>   arch/x86/kvm/smm.c   |  8 ++++++++
>>   arch/x86/kvm/smm.h   |  2 +-
>>   3 files changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 2bb1931103ad..c0e13040e35b 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -149,6 +149,17 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>>   		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>>   			return -EINVAL;
>>   	}
>> +	/*
>> +	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
>> +	 * state is not defined for 32-bit SMRAM.
> Why?  Lack of save/restore for SSP on 32-bit guests is a gap in Intel's
> architecture, I don't see why KVM should diverge from hardware.  I.e. just do
> nothing for SSP on SMI/RSM, because that's exactly what the architecture says
> will happen.

OK, will remove the check. I just wanted to avoid any undocumented hole if SHSTK is
exposed in CPUID.

>
>> +	 */
>> +	best = cpuid_entry2_find(entries, nent, 0x80000001,
>> +				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>> +	if (best && !(best->edx & F(LM))) {
>> +		best = cpuid_entry2_find(entries, nent, 0x7, 0);
>> +		if (best && (best->ecx & F(SHSTK)))
>> +			return -EINVAL;
>> +	}
>>   
>>   	/*
>>   	 * Exposing dynamic xfeatures to the guest requires additional
>> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
>> index 45c855389ea7..7aac9c54c353 100644
>> --- a/arch/x86/kvm/smm.c
>> +++ b/arch/x86/kvm/smm.c
>> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>>   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>>   
>>   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
>> +
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
>> +			   vcpu->kvm);
>>   }
>>   #endif
>>   
>> @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>>   	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>>   	ctxt->interruptibility = (u8)smstate->int_shadow;
>>   
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
>> +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
>> +			   vcpu->kvm);
>
> This should synthesize triple-fault, not WARN and kill the VM, as the value to
> be restored is guest controlled (the guest can scribble SMRAM from within the
> SMI handler).
>
> At that point, I would just synthesize triple-fault for the read path too.

Ah, yes, will fail with triple-fault in next version, thanks!

>


