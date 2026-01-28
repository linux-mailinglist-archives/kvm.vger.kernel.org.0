Return-Path: <kvm+bounces-69322-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBzwAJ+KeWk4xgEAu9opvQ
	(envelope-from <kvm+bounces-69322-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 05:03:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1169CE9B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 05:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DC8613009F21
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF5032E732;
	Wed, 28 Jan 2026 04:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="czIaxauC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D4227815D;
	Wed, 28 Jan 2026 04:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769573011; cv=fail; b=nqaCMAocsAIwBLWoT8G5sygA7fdUCB43vz1eokUuQ5e/CA/TQIoDKiFl51nb4eapppMxRBGEBx18dpx5YPti/W5CvD3rCix84jU1O1JqyzpQQ+qCGpU4Az7UsqdwiCDCarMQX3uCKVeFTD3DYruP6pB9NMeEX+VADyZNOHpEbKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769573011; c=relaxed/simple;
	bh=qlnx/03rVZyqLPkY2oLAs5a2xhf8YHlYfDx4lCPkI0g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lhQfRDQZlUZO3neAFbyKVdXT1U89siaRy7qT43eVOy8w2/dXzbcKGZqstY66F8TZjViTPtmTiyh/HqiuOBybyl2YhvsEEZPvKJAKm9mWpfkMVcm6JglQOTKFhNT1U9f0nbOTZTkIlWoY2F9JJ0qENRW7b30n8bjfBAsQgpoZsiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=czIaxauC; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769573011; x=1801109011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qlnx/03rVZyqLPkY2oLAs5a2xhf8YHlYfDx4lCPkI0g=;
  b=czIaxauC0f4Vq+U64dr3knCkl85X5qpRF5gngXw3LgK6NEoV2Cv8Ov+2
   cVcbw4XZ7nckUHmb+xQ90uKDeUZqo8lhYWuqgHxffiVhkQ/5uxvux4S8h
   7l2onGDOkm45oyI1TGZfKp4L+1LmWgz8FDTFhK1qoqCpzRrQkl5rR7lK8
   v9cyRa9e3c1FOTOYa9tbtRvOMsDA5gR5Q+SXFzKtBb4xUmcw8f0xdL0Bk
   PuN7cUaCLiPOhipEFivg3l51cw1GRi2RzfhUW3jv0cZOBzonfCyGQ0vvy
   peM4IvEP5Z6SSeCFppsZgJDMNUDh7vr32FnJFVg2XFEin0Zjddegai/pq
   Q==;
X-CSE-ConnectionGUID: RL+rTOrpT3CB2+j1MB+iKw==
X-CSE-MsgGUID: nDgPn0hMR9eJUjF83bnGJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70683192"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70683192"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 20:03:30 -0800
X-CSE-ConnectionGUID: EDV7cbvSSIOWvuutLBeK9A==
X-CSE-MsgGUID: 8IG750LaRriXbycoPG0Ajg==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 20:03:29 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 20:03:28 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 20:03:28 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 20:03:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pd8sJgp8jEy4p+M69CVw0rrcjU0xmT3cnQUctDEMyH9DL6SJy7haRv4+DivwQ0NlTSGwFcYgPZHm6byobY+G6NXkE0tdtzqFp2Ge3o1SmM7pHbnVRdQDA/ed3gnzON98utacFx0jECzkqr0bkbGKJUQfhhWkMCdRjbvElzjEwmeigGReAhmd0hXk+J4Kf7SlTmrl3z3FiCXUmfKkdBrAVMW/jvsxqnnbnP1tyvXlaZIM+hrC56gQIXQJ6Z11pheBlhwINXIg4OV/TxDZplGufbH4pcF7Or4xnzmmUh4Vlas+GWUyv4BSjEpsiVAjS0gBmMUTQ2CkOAYmfWsgNqBglA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlnx/03rVZyqLPkY2oLAs5a2xhf8YHlYfDx4lCPkI0g=;
 b=EIwAZYlhP6iIyRgq7dj/dv5KSXd5Ls7vu8AqE5RQHwB9BpsKveLA8hwaXDcSRZ7kZpMt9ctmt214w6nqpAgx8FDt7/yi4YX/WY+Kb8OLI6q5wBvJyY3qV4y6j1FP7X8ppRQzMWYDrQIWo5xZKcoCSQV399wFXamP5vcetvcy4hF8x4nQnr5J8oHpGFNrdP98wigYJ1CtnhvkG4Q1PE4TT4Aa/kPg3H4ra+pPipE0fwvRc7cPiG0P4kH9eTAQDAN/zus8A9Wkw+gK7rUH631IlJ5UyTpnhjNZC7AY4J3wkZawjb3lq5GInw5wLeJvDryrrdc0USzjWShyCCFwaDYh6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PPFD320E2257.namprd11.prod.outlook.com (2603:10b6:f:fc00::f51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 04:03:25 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 04:03:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a module
 update request
Thread-Topic: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Thread-Index: AQHcjHkYth7yej19Fki+xmlQ4+sdCLVm/SQA
Date: Wed, 28 Jan 2026 04:03:25 +0000
Message-ID: <e229343797319f6d316432055bb52aaa637d5d6f.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-14-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-14-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PPFD320E2257:EE_
x-ms-office365-filtering-correlation-id: 51635619-11bc-4c0b-6ebe-08de5e222f82
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cmwvZmNjYVNiWFBCbDN2TXRUZi9IY28vQVh0cm01ZFVVclpFVnlKY29GRUhW?=
 =?utf-8?B?a0xja2ovMWNlNW10SklabDQ1VXgrMll0bUY4UURMYUowUEViTUIvVDhyUDdh?=
 =?utf-8?B?aFhadTNLSVRoa1l5OVF6d28zMTBVaDlTL2hlSUQvYjRueU1wdmd6VkY5VEJQ?=
 =?utf-8?B?Q3o1R0NZZHkvbFZ1VTk3enFLUThsYjdNZXdydnRlY1cvaGJuSTRtMnBZTGlp?=
 =?utf-8?B?cWVubUFkaXJmdDlGUUZXWFRMNVJMYTA5WXppV01mU0RMT0V0M0w2a2JnTEFY?=
 =?utf-8?B?NWdtQ1F2NU1nZTNpci9xb2lYZjFvbVUyU1NMQi91ZW81S3VmbTQ4MDdybnRT?=
 =?utf-8?B?Qm9pRFozc3ZROWF3WjlzOE9YaUJoSGgvSnAvSC9Md0dlVFA5UVlIRnV5bkZt?=
 =?utf-8?B?cnBBVGdpc1NicWRCdFluanhBeW5ZQi9uOElwRG1CSHJ6elZsYVVvZ1c1S3Ft?=
 =?utf-8?B?SlpSb1d4K1NiaVI0Mm1naUllWEJ3cmJXdVlBSzZIN0FRSnNxNS9Nc0NYSnZR?=
 =?utf-8?B?N0JYZmZlaXIrMWxDOTJmelBWUTlhUzlYZVlsR2dLazVzK1JqTkFWbVBNanV3?=
 =?utf-8?B?em1DVURiZW96SmVzWXRYZlcrdW1ES2p2dHBRVFNmU2JnUTlaLzltTFlXMS9P?=
 =?utf-8?B?RVNWd3JWa3pmUFNlZVNSd2ttTlM1S2xqMGtLTmMzS0I0MDEvOEQvOWRqT0dv?=
 =?utf-8?B?bVFYY0ljWS92ZjVsck9oQytIeVpWNDlGWGNIcGtmRDM1dkZQc1NzYXlpZGFK?=
 =?utf-8?B?TXBLVzFGbmVyb2hwSmREUHpkNUZiaXh2UmJKZFVLU3ZxY0s5cmpjMXh2dHl1?=
 =?utf-8?B?Ky9MVHZXdXhJYlFib0w2dElGbEhxR2pRQ05SL3ZXOXJjZW9nanAwUnNUdEF4?=
 =?utf-8?B?N3FhbW1TNHVpekIwOWJEbktwcjdsZ1FPb1ZqVFBISzQwU05IOFpvSnR5bC9V?=
 =?utf-8?B?U2dqaEJKRUxqWDNtaWJ6bGNONUlrdzZkSzA4SGpYQlVQUjZqZlB1VXZDcHlh?=
 =?utf-8?B?ekRmSUNQN0NNQ0xVbGRZSkhhYzJPNTNLQWE0bURHeXdIWFNRWnFzS0dQYnRz?=
 =?utf-8?B?YzJCbjFmYU5hVlpzMUswYTB4dWdRcHc2NnlJeFh4bzhWTUx0dGpXaEIzaFE1?=
 =?utf-8?B?UWYrcVphNzlsNlkzVm9NU0hkaXNtZWVTa3lDLzl3S0w5WVpYZ016M1FleTVn?=
 =?utf-8?B?NzlLbzJIdXZIUTRqeWs4VStnZFpCY2hIRDBtcysyRmZLMDExd0ExaS91VklG?=
 =?utf-8?B?M25iaHNFdDVoaHdBVEVBdFVNYm9ta3QyTGxyczNYRzRBN0dYMmdqejZtOHpH?=
 =?utf-8?B?VTF4c1lENWh5dXlud0c0clJZZ3EzbXh6VG9jbnpSdXQ1U2xMakhuQXZjV0o5?=
 =?utf-8?B?TVA5RUw3ckdKUlVHUlhLWGo3SEFoYTdKNG9nMmlnaUNFTG9xeTJHTDVaQWNr?=
 =?utf-8?B?d3lhRnNMOHRmUVhlT2QyVXRFZjhoL0NwV1FCeFZkQ25hMjdsNngyT01yd3pW?=
 =?utf-8?B?ZjFRM3ZWSWFoamFQMklqc3RabWJiazAreHMzSm5PR25HSU9nd05SRENmQTd2?=
 =?utf-8?B?N285cHc3M2tBTndXNEtWckxOdmN3TkdDTloveG95ZklwbWdFSDdqMk9mOXdL?=
 =?utf-8?B?MXFXa2s5WEpOYndvTnZZZUlBSldEVGRYVmdMMS9TUG5OcjAxWmxDTzYxb0FZ?=
 =?utf-8?B?QnpCeUlSSEdHdGRtVUNxKzR3aE5JU2Ivby9wWlR2TG42bSs3MElzRGdwL3dJ?=
 =?utf-8?B?dm1CVWZLRjNRb1NHTmZkZGNkMkt1M0x3U0pPR2tVdStLTm9meDJ3K2VQL2xw?=
 =?utf-8?B?L04vY1hzQTBLcHFmQzh5bWRtcUY3WTVmYjZEdUVpVHVyMkd0c3dYTG5zM1dR?=
 =?utf-8?B?YXh5WGxtZTJEekhRL3RmSzhibWZEV1kzeWVTZHIrUSt6QWJpbmtBQzdLcGh4?=
 =?utf-8?B?SDhwRmZVRTBGNTkwODF1UFNtdjd3OEptMlU0dktpdjROTDJxMzB2dmtjMmli?=
 =?utf-8?B?elEram1zNHhCUVQxV1NQb3pmbGRoUk9QZ0RQMkIyait2V0poOUdUV2o4NXM1?=
 =?utf-8?B?emhYYitlU0pUekxBVGc4Ris0OEg0SEZjV1hQQXF1YVhvODNlRDdaYitEV2w5?=
 =?utf-8?B?azJUSUdjWlUwY1hrVXpYSzNISkJ5U1pPTGpnTUFmdmZ2T0VBNFFXYTJjUDZN?=
 =?utf-8?Q?KK01o1q6Mig3GtXQ9/jm5cE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjN0TUI0Rkx2dGRDVGNUYTBvMEs5SDJ5cmtTTDhNS1hzT1NobXp6ZkZZNXRq?=
 =?utf-8?B?RExRSWRRc1VJb25wSHo1UVVaQTZVYndqZXNCaTR5LzBJcWxwczZxdk0xSlhB?=
 =?utf-8?B?NFlId0lURWdiY0Q4ZzA3S0VxUXd6OHdKSjNXRzBrRGd2aUhtZ0Y4eXlSNlBR?=
 =?utf-8?B?M25Dbm5sanpKYVBxQ2dQMDgweUQ1SjViSFlUZTZIalFPQkl1alB6dGVLTjNH?=
 =?utf-8?B?Slk3ZmMwQ2E0eCtPSDRlVVltYnF0OUp2eVJRTUlWS3E0Z1dyRWZLZjVNaGtT?=
 =?utf-8?B?VnhBWDhXd3pYK0NkQzhpQUdkM05aL1hmaFkyYTg4aHkvV1p4RkwxTFlTU0dP?=
 =?utf-8?B?MGEwNzJDb1J6c0NldFNEWVU5c1pORm5YU215QjdzYmI3SHZtREZEckNaVDhH?=
 =?utf-8?B?RU9XaXVLdEJWRDhLSXlwZmRveFVPamo5bzF2TWZUWi9yaktRMmFXUTdJQ2ZI?=
 =?utf-8?B?M083bU5lM3I3amJXWHdJYmlsNi9CRHdoeTZkRCtPSGdoUG9wMHZMR05HZnph?=
 =?utf-8?B?elh3ZFJNOE9JZitKODdiU2hxNkVWVW9UU1A5aWVHQ25PMENCbTF6SU8vSVBa?=
 =?utf-8?B?bzBTN0FqU01JVU42cU42bE8vcGFva2todXhwb2I3UWg3WmwrNlEyUFZwdksx?=
 =?utf-8?B?N3lZVW9tWUhack02bnNPdDd1cWFGUTg4MndhVDBSc05hekR3eUpmeFVhejll?=
 =?utf-8?B?eHdLUjZIcXlIUHRXUXhETnV3bTFBbGdqNm9JN3Q3UE1tUkdJZTc0RkU4YkpD?=
 =?utf-8?B?OXNyam0xUktaR2RVWEJ3a0JadGlFQzJJbzUxTW4xVjZES0pNc1NWNkF4eHB2?=
 =?utf-8?B?bitFVVRLdm5acWtKWXV4eW5uRmFVaDc0endXbnJ2b0NQMG80ODdkdndiTUxC?=
 =?utf-8?B?bXRwdm9HWTJJWW5kK2pDMmtuSFdiM0t0QnhmcHRMeTNMVHNiU0NNdnhDbjlX?=
 =?utf-8?B?Z0JER0IzRUllMWRmeXpzeEFkcnh4ZjlzNzhRWXdiYnZPVi91c0xaajhoMUFj?=
 =?utf-8?B?Zmhsa3VRTmVQSkU0aWQzSmxQTHpHYjBoTmFkaTVHd2hoUFJMUisvYzJnNG1W?=
 =?utf-8?B?RVgzdjJRMmZIZ3hWcGJObDNIZVplRXRtTUJ6cFRlQUYwVWF5QTR1WCtMMW5Y?=
 =?utf-8?B?ZTZSN3BXSFVQK24zMUpmYnJxUUJVTU41VVA5OXBhSW1CMzVBbVRNTCtQT3Mw?=
 =?utf-8?B?N3RqcUQxRlhhZmVYRXU3bmhYRVE3Wk9qNU12TUFCYW4zSUR6MUQvR1NwcmIw?=
 =?utf-8?B?R25IeGdyR3ZuZmNxMkpEeEtMdjBvbjB4NE5WRklkbm1TcW5wUTBPV0Vkc1NX?=
 =?utf-8?B?R01ocXZoWFlVYVpwWS96ZVBZRUhxaHA1a2RoVmtIRkV6c1lqd0JOaEZ0ZDl2?=
 =?utf-8?B?RS9pRFBBRjBVUmZHblpveW1PWTJHTGd3Y3dQRisvQ3BkWVhCRmE0Z083cUpB?=
 =?utf-8?B?djVGYlBqd3lXU2p2bUdwRzZ3cEduWDFTaXVxNUR3T3kxMlpYZTNpZEVDWVhj?=
 =?utf-8?B?QTFJckZhSGc0ZU9WQ053T3FKSHVlS0FFV1ZlcFZFd1htN1Vob2JGTTBkTEF2?=
 =?utf-8?B?TUFMMVpsNzVSME1zOVVacmZoZGNWTVA4VmtPMkhyOFNxejhnRHhBNCtZZ1Bs?=
 =?utf-8?B?UC9RM2JaalI1MnNFUjYwem5yVzgzSFppeWxuN3Z0T1VQQy82aUNLQ1dHQ3pw?=
 =?utf-8?B?TGRuRjQyUHlMcHVoc1dPYkZMbXQzakQ2RWVNb3pUTTQwdWYyOHQ0clJUdWs3?=
 =?utf-8?B?NUkyb0dFclJiODFQVlhNWUtMam5qcndOdStReVpJK0RYVURNR2dUWVZCQlhU?=
 =?utf-8?B?V0hGMHJ5ZGFQYW1rbm8xa0k2QXB2Y3NxVWd1MWd6aEpDNWVjeDBSQmtjckxI?=
 =?utf-8?B?SjluZDFaRG43M1hEZ0NscTVmNGFhVHFyT0VlM0NWUmxocWE3WjY3d0M5eXNM?=
 =?utf-8?B?eTRPZ3RubSt2ZG5mdVlzZ0I3UEVLVHFUUGpjRUlIbVNuK0ZDK1E4MnRybjVn?=
 =?utf-8?B?L0FQTHZaaE5TTFYweUZ3SFRZbnd1MDExdVFsRHdkS3poR0RJbjU0NDh3OXBL?=
 =?utf-8?B?Vnp5VjlJUTlEU3FyelNWbjdla2lrVisvbDdGVmdueU1JTURXMzZJVzBPYXFL?=
 =?utf-8?B?eWo0WExhSWVMQng1L2hsd1VmZE84VnZpenNiNXB5OThldUJjd2tZM2JBdFRI?=
 =?utf-8?B?S0FRUGVwNEtrL0YrcHVrUTRveVlrSGFMaEpMekU2V3RWdXI2czRVSEczVHl2?=
 =?utf-8?B?dWtlRHNFT1lORmJudk1hT2JsdXlTTkNzbnVMelNZSkpMSDkyTWw1bjhHTWI1?=
 =?utf-8?B?djVnZGFEcS8vQllJTDA4SVZWMncweFQ2aDV2Vko1MEczZU45eU9iQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02EE26A57BD4A540BDFCFAA8BC1F37CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51635619-11bc-4c0b-6ebe-08de5e222f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 04:03:25.1458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6EuNroIh0/YNaE/KhNWdiL2zHTcXC+qUOkBsAI4heXn4q4oI/lz1T0B8HODqRpmMUVT1k2HxlflfmvZu8FDwpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD320E2257
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69322-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5B1169CE9B
X-Rspamd-Action: no action

DQo+ICsvKg0KPiArICogQWxsb2NhdGUgYW5kIHBvcHVsYXRlIGEgc2VhbWxkcl9wYXJhbXMuDQo+
ICsgKiBOb3RlIHRoYXQgYm90aCBAbW9kdWxlIGFuZCBAc2lnIHNob3VsZCBiZSB2bWFsbG9jJ2Qg
bWVtb3J5Lg0KDQpOaXQ6DQoNCkhvdyBhYm91dCBhY3R1YWxseSB1c2luZyBpc192bWFsbG9jX2Fk
ZHIoKSB0byBjaGVjayBpbiB0aGUgY29kZSByYXRoZXIgdGhhbg0KZG9jdW1lbnRpbmcgaW4gdGhl
IGNvbW1lbnQ/DQoNCkkgc2VlIHlvdSBoYXZlIGFscmVhZHkgY2hlY2tlZCB0aGUgb3ZlcmFsbCAn
ZGF0YScgYnVmZmVyIGlzIHZtYWxsb2MoKSdlZCBpbg0Kc2VhbWxkcl9pbnN0YWxsX21vZHVsZSgp
IHNvIHRoZSAnbW9kdWxlJyBhbmQgJ3NpZycgKHBhcnQgb2YgJ2RhdGEnKSBtdXN0IGJlDQp0b28u
ICBCdXQgc2luY2UgaXNfdm1hbGxvY19hZGRyKCkgaXMgY2hlYXAgc28gSSB0aGluayBpdCdzIGFs
c28gZmluZSB0byBkbw0KdGhlIGNoZWNrIGhlcmUuICBXZSBjYW4gYWxzbyBXQVJOKCkgc28gaXQg
Y2FuIGJlIHVzZWQgdG8gY2F0Y2ggYnVnLg0KDQo+ICsgKi8NCj4gK3N0YXRpYyBzdHJ1Y3Qgc2Vh
bWxkcl9wYXJhbXMgKmFsbG9jX3NlYW1sZHJfcGFyYW1zKGNvbnN0IHZvaWQgKm1vZHVsZSwgdW5z
aWduZWQgaW50IG1vZHVsZV9zaXplLA0KPiArCQkJCQkJICAgY29uc3Qgdm9pZCAqc2lnLCB1bnNp
Z25lZCBpbnQgc2lnX3NpemUpDQo+ICt7DQo+IA0KDQpbLi4uXQ0KDQo+ICsJcHRyID0gbW9kdWxl
Ow0KPiArCWZvciAoaSA9IDA7IGkgPCBwYXJhbXMtPm51bV9tb2R1bGVfcGFnZXM7IGkrKykgew0K
PiArCQlwYXJhbXMtPm1vZF9wYWdlc19wYV9saXN0W2ldID0gKHZtYWxsb2NfdG9fcGZuKHB0cikg
PDwgUEFHRV9TSElGVCkgKw0KPiArCQkJCQkgICAgICAgKCh1bnNpZ25lZCBsb25nKXB0ciAmIH5Q
QUdFX01BU0spOw0KPiArCQlwdHIgKz0gU1pfNEs7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIHBh
cmFtczsNCj4gK30NCj4gDQoNClsuLi5dDQoNCj4gKy8qDQo+ICsgKiBWZXJpZnkgdGhhdCB0aGUg
Y2hlY2tzdW0gb2YgdGhlIGVudGlyZSBibG9iIGlzIHplcm8uIFRoZSBjaGVja3N1bSBpcw0KPiAr
ICogY2FsY3VsYXRlZCBieSBzdW1taW5nIHVwIGFsbCAxNi1iaXQgd29yZHMsIHdpdGggY2Fycnkg
Yml0cyBkcm9wcGVkLg0KPiArICovDQo+ICtzdGF0aWMgYm9vbCB2ZXJpZnlfY2hlY2tzdW0oY29u
c3Qgc3RydWN0IHRkeF9ibG9iICpibG9iKQ0KPiArew0KPiArCXUzMiBzaXplID0gYmxvYi0+bGVu
Ow0KPiArCXUxNiBjaGVja3N1bSA9IDA7DQo+ICsJY29uc3QgdTE2ICpwOw0KPiArCWludCBpOw0K
PiArDQo+ICsJLyogSGFuZGxlIHRoZSBsYXN0IGJ5dGUgaWYgdGhlIHNpemUgaXMgb2RkICovDQo+
ICsJaWYgKHNpemUgJSAyKSB7DQo+ICsJCWNoZWNrc3VtICs9ICooKGNvbnN0IHU4ICopYmxvYiAr
IHNpemUgLSAxKTsNCj4gKwkJc2l6ZS0tOw0KPiArCX0NCj4gKw0KPiArCXAgPSAoY29uc3QgdTE2
ICopYmxvYjsNCj4gKwlmb3IgKGkgPSAwOyBpIDwgc2l6ZTsgaSArPSAyKSB7DQo+ICsJCWNoZWNr
c3VtICs9ICpwOw0KPiArCQlwKys7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuICFjaGVja3N1bTsN
Cj4gK30NCj4gKw0KPiArc3RhdGljIHN0cnVjdCBzZWFtbGRyX3BhcmFtcyAqaW5pdF9zZWFtbGRy
X3BhcmFtcyhjb25zdCB1OCAqZGF0YSwgdTMyIHNpemUpDQo+ICt7DQo+IA0KDQpbLi4uXQ0KDQo+
ICsJaWYgKCF2ZXJpZnlfY2hlY2tzdW0oYmxvYikpIHsNCj4gKwkJcHJfZXJyKCJpbnZhbGlkIGNo
ZWNrc3VtXG4iKTsNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ICsJfQ0KPiArDQo+
ICsJcmV0dXJuIGFsbG9jX3NlYW1sZHJfcGFyYW1zKG1vZHVsZSwgbW9kdWxlX3NpemUsIHNpZywg
c2lnX3NpemUpOw0KPiArfQ0KDQpJdCdzIHdlaXJkIHRoYXQgd2UgaGF2ZSBkbyB2ZXJpZnkgY2hl
Y2tzdW0gbWFudWFsbHksIGJlY2F1c2UgaGFyZHdhcmUNCm5vcm1hbGx5IGNhdGNoZXMgdGhhdC4N
Cg0KSSBzdXBwb3NlIHRoaXMgaXMgYmVjYXVzZSB3ZSB3YW50IHRvIGNhdGNoIGFzIG1hbnkgZXJy
b3JzIGFzIHBvc3NpYmxlIGJlZm9yZQ0KYWN0dWFsbHkgYXNraW5nIFAtU0VBTUxEUiB0byBkbyBt
b2R1bGUgdXBkYXRlLCBzaW5jZSBpbiBvcmRlciB0byBkbyB3aGljaCB3ZQ0KaGF2ZSB0byBzaHV0
ZG93biB0aGUgZXhpc3RpbmcgbW9kdWxlIGZpcnN0IGFuZCB0aGVyZSdzIG5vIHJldHVybmluZyBw
b2ludA0Kb25jZSB3ZSByZWFjaCB0aGF0Pw0KDQpJZiBzbyBhIGNvbW1lbnQgd291bGQgYmUgaGVs
cGZ1bC4NCg0KQWxzbywgaXQncyBhbHNvIHdlaXJkIHRoYXQgeW91IGhhdmUgdG8gd3JpdGUgY29k
ZSBmb3IgY2hlY2tzdW0gb24geW91ciBvd24uDQpJIGd1ZXNzIHRoZSBrZXJuZWwgc2hvdWxkIGFs
cmVhZHkgaGF2ZSBzb21lIGxpYnJhcnkgY29kZSBmb3IgdGhhdC4NCg0KSSBjaGVja2VkIGFuZCBp
dCBfc2VlbXNfIHRoZSBjb2RlIGluIGxpYi9jaGVja3N1bS5jIGNvdWxkIGJlIHVzZWQ/DQoNCkkg
YW0gbm90IGV4cGVydCB0aG91Z2gsIGJ1dCBJIHRoaW5rIHdlIHNob3VsZCB1c2Uga2VybmVsIGxp
YiBjb2RlIHdoZW4gd2UNCmNhbi4NCg0K

