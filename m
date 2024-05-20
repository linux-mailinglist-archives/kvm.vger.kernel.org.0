Return-Path: <kvm+bounces-17806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDE28CA4E0
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EE51B21C7A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B54855C2E;
	Mon, 20 May 2024 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5MHYJZc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC283E49D;
	Mon, 20 May 2024 23:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716246585; cv=fail; b=EvamQeQnuENYj+xkICooeGBriM6XrrNzBWnGjkSbtdzMY0/vxUVk87QDGA+LnrS/SlLyl23+1gxGYDGiS9/8p/AAsoHOmyRZLc/+Rz/Q2rta/ZC0Gfrgu2ndR9sfP5PwQYyTEGI9N25zyDkTn3F01pAgJHlO61sqU5pHN2H3Zdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716246585; c=relaxed/simple;
	bh=FTqUd0By5n5eZYsZAqemVQGy4svnRW4vZWPo8aaua2A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gN1wR1gazIQq3SMdj5iOwcCM0EsRukR7OgKWClf8SZz0wja4FRsc/M1VqaWTTo/2UciUOCkV6NBW1cJxuaIMVyvZEGkgThrRzPCg6Xn+4Mb0OgdGrzh3z7/G1tY1iu/Xfhb7HxvUXWLlfrD1UuPearmkNECHf6aRrt9mxL89F2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5MHYJZc; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716246584; x=1747782584;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FTqUd0By5n5eZYsZAqemVQGy4svnRW4vZWPo8aaua2A=;
  b=k5MHYJZcdYnZllhWM113GmYfHpI5FgttVT3Tsf+7PIyauWJI+F2KhNID
   x4nRqbDy9WpOf6/17nU2wfre4WYRPNELc6wgB03AsWThTxPIYeoi2dl2w
   enaOXIOoEsOJM+RfJ6f0SWscNh5qv7JXBB68nUhPt34P7/U9N4GrimBDw
   CwpvBCvGxV8dJc7iAoMMBOBjbcmtfbziJdPz6bhktEZakQUf0SihdB7Qd
   9PZZlfc85fYfmgV3T+fkWNpTI0e8d6X5BaiEGjXxfuKCiasrFoSmNdeYH
   wyiBF9eIVFy1bKZmMb6PvNvsLBAebGpXL2CAejqknB8Sc1MtWt8RMmA8L
   Q==;
X-CSE-ConnectionGUID: FtI2SI08SbSO9G6USVXRUg==
X-CSE-MsgGUID: l/sKzU/nSrWmGou6e6j0ww==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12250483"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12250483"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:09:43 -0700
X-CSE-ConnectionGUID: lM5gcOUpRlqDqBFKFmO6rQ==
X-CSE-MsgGUID: +33NWVEsRz6pGlKugG1S2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="33127229"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 16:09:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:09:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:09:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 16:09:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 16:09:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMn72OiN1SuYZUYYD3EUL7qLJqXlpFNP+hykn/5e3Kn9cqWi8jKhmG5+Lk4o2PA2bnGAvX2mY3JbL7/6sR+Qje2ZjIthPzBYsEZzRahcTQ+B649fIn8O0KgIdfxBuC0EEHmH6eRDaQLwbZFE7t2GquZgtNbdl/+ANht85zTrAnmi/BpbjeAFVjtQmrQ+sjxu099/hPpl/JA5Lle6tNjdDfqjS2e9Jw+BVS+Rwx+n6tdpl8k9cyk/LtrO5gQTZl4fRnfQv+wbAdd4HRi/cE0KOFFmOzTolwWLJ4Ooxmea09pajLljqkQZD5nl+Glij6kLiZ4n1WoDJC7BDODa35XVhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PAHBv4+ue0zMPcYWfhtdNowZ73ZMI5qAIacd+LTLek=;
 b=A8UauQcYCj0Ml1JrVZ7E6j5rOpGG02FtHbt2yM4qwnw53InnXGjt6qYG8kPeirj5tidna0G3Yziy30PcbAu955tuxRqePE5GhvZAGkuRowLXJ9W2ZoLjh6K67IZRTIlFQBiQH95pp54p85lMAb2FVaE71kgNuB1GhHDdJaJ7cs760+ytIqp9njtHfdhbrOduy2tv2kXLO0AL8L0ek7zPLvirZdg9bKG31Vhc9zET6MoKWcbyX1q5auYXa7KhUhKL0RDHGRR5sAo9Iz2AsaUWV+Iuv8U4+SRl55GZEtDUptImW2tSBq+vbuH7pDzXykYZ1uOjkFcD8eJzjNYmFfQ3Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7924.namprd11.prod.outlook.com (2603:10b6:930:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 23:09:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 23:09:39 +0000
Message-ID: <78b3a0ef-54dc-4f49-863e-fe8288a980a7@intel.com>
Date: Tue, 21 May 2024 11:09:21 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] KVM: nVMX: Initialize #VE info page for vmcs02 when
 proving #VE support
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240518000430.1118488-1-seanjc@google.com>
 <20240518000430.1118488-3-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240518000430.1118488-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0013.prod.exchangelabs.com (2603:10b6:a02:80::26)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY8PR11MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: a0827366-a94d-4370-c16b-08dc7921ecf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WENlb2lQQTdjd0FMZ2RJR0VsYmVEOGJHaVZnRmFvMnZSYkFNSFkyU0RwN3BQ?=
 =?utf-8?B?TDFYcktBNmNqcFZ0dDJGVjFDYTFXa0lMdVRlMzVUZmV3eDM5bmFUbGpMNUdy?=
 =?utf-8?B?WDFBc2xCTTFXdHd6VUszV2E1NTRCUjZWNlZjeVdiWjZQVDNzME1ieHU3bktV?=
 =?utf-8?B?L0c2WHJ4N3dyTUJPeDFnYXRqRW8rMmIvUFRNVzJ4V3VUaUJRUzE4ZU9HMGha?=
 =?utf-8?B?YnRFYWtjRGxnK09xMzdDejhTM2FDMUN5L0lGRmk2ZFRzaFlVQXZZVkFzR0xT?=
 =?utf-8?B?alNIbk9RUzJ6cTl0NVVsT0RPcTBCSXZia0hxOVVZc0Nsb2I3MFNKbXR1N2lJ?=
 =?utf-8?B?Sm8yaTZDVlE3a0xnU25qdDMrNXVBUGk5N1NyakUwSWpFc1VMTjYrQmY3aU14?=
 =?utf-8?B?RVV1WlAvU3hSR3Q4T2FiR2Z4MWJzZlFPOE9xazlCaFgramxSNld4Z242Wkh1?=
 =?utf-8?B?YkpHRys0VjFlZ01RbDhha2tRQ1VTdUMxWmJ0MDRwMjhqS0d6cm9VL3lxeHZi?=
 =?utf-8?B?YWNrNEZDUS94NDYwWE0yd1VFRUYyRWVRdUZrRVBZc29sWWM5ekV3dnZPWklh?=
 =?utf-8?B?blFsdHA3b3F5Z253UlJNS3poNmNyTzNUT1lxazd6UGhzekpVT0taVEkwMTg4?=
 =?utf-8?B?WGI3ZjBGSkZqRWw1aktCUm4vc2w5QkNGRUZMTEtoUFhsVVdpZkxWYWduZTZl?=
 =?utf-8?B?ejBUSndtbVBjQ1VpSVVBVGNwNEpGcEw2MURVUmQyT2RjZVdyMUNzR2JKL2NN?=
 =?utf-8?B?UDVHSUY3ZXlqRFdndStTNG0waXFtT3J6dnV5SHBhUDIra2x4amhaY1B0VVFt?=
 =?utf-8?B?UlM3RUtJMitBZnBjWWhGUkR0NWYwOVRNNXg1dlBlU0E5Vndxbkd3U0R3VUFm?=
 =?utf-8?B?SVdKSFgwMTZxNFc3NzdNSVhLajZGL0I5KzFVWkd0TUtkTlR0TGtKU1hmTkZH?=
 =?utf-8?B?SG5tSnZLZ2NLY2hjSW5Ocm5CYjFUZkxjRlVsY2ZYeFpNYk84UFppNFd4UnVo?=
 =?utf-8?B?K3VvandvQjhDWnYwSXBUd3M2K0ZDZUU3blVQUnBNbTU4VnpyUmhvRDVGRFZs?=
 =?utf-8?B?NFhpRlJyT0RHWVRrQURmTUZvbjlQODJKaEdFOVZyTFhQU3FiY0pUMTk4dDdq?=
 =?utf-8?B?RVFmQlpLOG1YYzFFL1FSWlVvcHNnMlJ6L1Rsa1dqNEpwTXNXTVIzc1Y0ZFEy?=
 =?utf-8?B?a2lCRGs5QmplcmV5eUV0ZE5wMDNzUy8rVWIvMjM3alp0Qy9oeE10K0FVWGdM?=
 =?utf-8?B?blhmTmNIL3RtbDB1ODdwTlNhSmxybmJEUGhVN2NsTmU5dzVBbkdBMy94NUR3?=
 =?utf-8?B?YWJ6d3JrcVN5VEZhSWFuQTk4RHdxRU5iQm10MWVXenp1ZWx5cUtTNFJ3YXNm?=
 =?utf-8?B?WVJOK25hMmZmeEdjSzVaMzk5OVk0K0FrZHVWNWpzSHdmcmRYSFZXVmdzcmlr?=
 =?utf-8?B?VUV0WjBmTVltZmtycEZyNjU2NjZNcG0xL2gwSWUrZE4wNXJCU3VhWEpMQThQ?=
 =?utf-8?B?d0tPV1pSLzN5d0JEMGxBL2taOXY3bVJUemFnZlkwam9OM0t5V3phVTBaZ09J?=
 =?utf-8?B?V0MvS3lWb0ZXemFXdGIvNUJLeEtKd2d6TUxwV2t0dERyYndGU1VDYTgrd2JB?=
 =?utf-8?B?TCt4R01ZMWE0SzdCRis2TkxaRm01d0xuR1RmTFBBemFzZko4UnhDRUJLUURh?=
 =?utf-8?B?UjBZK1V2WHFGOGJrSHhLS3JBWEpERExUUXE0R2UwWUQreXVMV1BnNGl3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1ppaGc5cXlEcnN4eGVmb0oxK2s3VEx4a1B2QU9nM0F1K2ZEYjZsREc3SG91?=
 =?utf-8?B?M0V4TWNIMmJyS2U3UnVGb0lQM1hSU3c1eC9aaHhPVW5PamJXTkFWZEFhWnVD?=
 =?utf-8?B?aUtEeG4yR2NBempURkJ3RUQ1RjZNeUJ1MWJUMVMyVUovd1h1QXh1TUpmRlI2?=
 =?utf-8?B?bFV3SGp6MmRpVGFSNUQ0am14bnU1bi81VmFUcHd1T0dQMXFzVk5rNDkvajRG?=
 =?utf-8?B?d1lhNSsxYWV6MG9kYTRSNHpNUVd2TExUQ2JRV3hZS0FBRURLOE1wMnRJKzBP?=
 =?utf-8?B?Vm1mbUpacGwzUGw5ODRWclhzdVNDL0s5RHdoVXlhc2Q4djl6d3Q3d0M3U3FZ?=
 =?utf-8?B?aHlFRmJMVFZsWG9jcXRhZysxczlNOWtNSnJSellOM1ZrbUF6YkhUNVE2UkNE?=
 =?utf-8?B?WUtVU1l5cCsydXpOamxoN2U1WnlmMEpqUzNHUUNJQVlRRVA5UktNOFNkV1Fr?=
 =?utf-8?B?bkVrbW1DbUFBMk9aTUhHNFZwM1RyNjBOalpGMWdMeFQ1WFZRVEUrN2lNZGti?=
 =?utf-8?B?VXZrUFBZbHJma2tlaW1qR2JvRkVDU3hXMjZQdDA1UDFYQTRwVU0zOUJFRCtJ?=
 =?utf-8?B?cTBzNXV6cDUxNW1lcVR1UUNjZDlRR1FsRzgvZEE4Y21VVXJKRjFweVZvM2Jr?=
 =?utf-8?B?eG92U2pkZWFNc1JaL254dHI3SXI5eGF1MnhRMHlUc2ZacnZBbXNWQmhIczZK?=
 =?utf-8?B?Ym1uTEVMa0QvYWVLSjBtZWVoZktORy9MNE9Bdjg2N2ZFWk5MTVpMdHNueXlV?=
 =?utf-8?B?ZXQzS0dlbDNobGhOVkx1NUhwUFM4dnEwSWUrSlMvNEJhSFpMOHVYVkFSUUN1?=
 =?utf-8?B?SEQyOXdOUlk0cEp2bGV3Y21LemU5ZEtRcVU1U0hDczRoL2VNYm5rUC9Sb3BU?=
 =?utf-8?B?b3ZGWXo4NGtZSkUzdTRhRGpKZTkwTlErYnU2dUhVVXQ1bHZ5UllLNlBRYWow?=
 =?utf-8?B?RzdJRWt4QzVqYTJLZ0p6aTR1YWtaRENaOXlrWS9INmxxNjc5a0hnVG9Rd3k1?=
 =?utf-8?B?QTFhaFNxZExIRjBjdXordGUwVHFsNzdZWm85K1hvWnV4R0Y3ZlRpVEVJSFlt?=
 =?utf-8?B?dXI4cU5qVlBBMGtQeHN3WnlEZktNSTVQYXp4MDgxakN2NXIvdlhtMjB3b0xU?=
 =?utf-8?B?em8vZVpFaDZ3RUsrSi83N25hMkU0TUxvcDJ0R3RoNVI0Z3BDS1g1SXU2U2hI?=
 =?utf-8?B?c0RyWGVSRy9ZSU5oc01PK3NnY1VZZTNRSmRCdUI2N205U2pXZlVnQTFvOGdR?=
 =?utf-8?B?em5YZkp1bFp4UEtSTk9JTDh6cnY0M2QwdDVod3gxVkhReDlldWZHcTBiZFM0?=
 =?utf-8?B?MTc5eWZzWVZWNTMzVDAwcjhwVndhbDkrbUhDTk1pamJENXNIdVNleTJ2TXh1?=
 =?utf-8?B?OXE3NTY4WEJuNTQ5LzA2L3lINDArUUJKMmJFWjFFdjV3WWQ2L0xuVnZEWHlO?=
 =?utf-8?B?UGp2bE5OaUtka0twY2s4VjNPVFg0bG1MaW1nSzNUU21iKzhRYVk1NFNVeXhx?=
 =?utf-8?B?WkZCVys4enpONnF3WFg3N0cwWElxZW83SWd6dWdhNmhXN1ZZODNuQ2JGbDQ2?=
 =?utf-8?B?S2xld2xDMzVlYVc3QndYa2poSk5xbExmdnhydHQ0ZUtpSU1Bb3dGdVBmVm9z?=
 =?utf-8?B?NTRkdlVvT0kxcVZ2amhkUHFSN09hTkNoUFRQcEhLSCsrdEhJTkhJcXpZWGZh?=
 =?utf-8?B?NytJSndnUStKZ2dUL2dITVk3dmMwbVE5WVkwNTFQZjI0NFBHRFlFalZZdlFQ?=
 =?utf-8?B?RnRLMVE5ejMrUFkyUHFWNi9RVTk0dFBLeDJuODZtZHpvWnVTWXRCUEVOZkhN?=
 =?utf-8?B?czFYMVYyVldZbFJlNmxSbTVVaXN3Ri9wQTRJaFZqZDBrVmhmVzQ5MHA5N0FR?=
 =?utf-8?B?RTlnRGhJczhOcDZSUlo4SkY0a3ZjRVJ0R0taTFV0ZTRhNm9QSmg5VlJDM1V1?=
 =?utf-8?B?Y0NWZ1VHVDQyQjluVy9WbEgyRU0xbUowd1libEswMzZjWVdHeTlid2dNZU15?=
 =?utf-8?B?MEJ5Tm93NUN6VGdxWkJraVlBOHAwdjJXRk1mTjBubjVYK1JhYUpTdnYyd0JW?=
 =?utf-8?B?N01QYjBHZEd4R3VIVHZsaHVUZ056d3BabjF1TWxoZGtWVnV1NVUwZktLNXhB?=
 =?utf-8?Q?8cuux1LI0auc4iE5LSiNgXqI9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0827366-a94d-4370-c16b-08dc7921ecf8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 23:09:39.8270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDCyEcMIeOzsYeuEKuLUE+X080nD5PUiNKIZIFbr9fSkiE+ITlQj8wqf+d4y8xSUz3YJ2gQfj3hA1ePRAMFAHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7924
X-OriginatorOrg: intel.com



On 18/05/2024 12:04 pm, Sean Christopherson wrote:
> Point vmcs02.VE_INFORMATION_ADDRESS at the vCPU's #VE info page when
> initializing vmcs02, otherwise KVM will run L2 with EPT Violation #VE
> enabled and a VE info address pointing at pfn 0.

How about we just clear EPT_VIOLATION_VE bit in 2nd_exec_control 
unconditionally for vmcs02?  Your next patch says:

"
Always handle #VEs, e.g. due to prove EPT Violation #VE failures, in L0,
as KVM does not expose any #VE capabilities to L1, i.e. any and all #VEs
are KVM's responsibility.
"

> 
> Fixes: 8131cf5b4fd8 ("KVM: VMX: Introduce test mode related to EPT violation VE")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d5b832126e34..6798fadaa335 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2242,6 +2242,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>   		vmcs_write64(EPT_POINTER,
>   			     construct_eptp(&vmx->vcpu, 0, PT64_ROOT_4LEVEL));
>   
> +	if (vmx->ve_info)
> +		vmcs_write64(VE_INFORMATION_ADDRESS, __pa(vmx->ve_info));
> +
>   	/* All VMFUNCs are currently emulated through L0 vmexits.  */
>   	if (cpu_has_vmx_vmfunc())
>   		vmcs_write64(VM_FUNCTION_CONTROL, 0);

