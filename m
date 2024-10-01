Return-Path: <kvm+bounces-27790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CE598C6ED
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 22:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25F651C20C2A
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 20:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC991CCB39;
	Tue,  1 Oct 2024 20:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PvSBL3q6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F6519AA6B;
	Tue,  1 Oct 2024 20:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727815511; cv=fail; b=oiYZJe21QV+kOHBLmnx6hGf2t5v6Gf8cqgbpLCz3T/ZyaqKkFbVK2/VWBR3Yr26hNMlZcykTofCSDzrgnlOs2ldrqK4NvUc/ue36gJJydMHnOnM9f7d0aDqx8gPsZGBBhjY1ir1BAor2QlXipPiNQdA2EiJ4uHnyjU7fR5Ydy/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727815511; c=relaxed/simple;
	bh=ngCaWLHWxvko/lNDMY/Z8j4GUj+kV/Bb6ohSDwAZWp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AMdQTQGDFUkBKtqMAS6lRvnxMTAG0J32Y1CAWK6AovyPmB65feuobd/3veOecXd+sClEocqBaKMio63HvMk8+mFA27E1uFcgL5P6mCJQ3o7aeKJcaAFDb+hYJ0MMXWWJSYX5yXr9vPqsmVnr2pGQYO5aR3k8817TsQoTj/koA1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PvSBL3q6; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727815509; x=1759351509;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ngCaWLHWxvko/lNDMY/Z8j4GUj+kV/Bb6ohSDwAZWp0=;
  b=PvSBL3q6Ueu4NSS9GYzoFcIGpjg8/vxajhI8W5FOtYODu158CDjE9/6Q
   qw4v8MecHCwl8nXZC0qBW+fEK1HfMMfLuIqP1vxkXddT8gE1EJTfTpAXV
   l2ZM6fmrzhJrSnJmW9AeDtWaSyqnnbOa/Fbuu9W3LqJM8cf1gj0tc12a/
   zv5yNsUcE8I8RhOFGTmmWvaHioirOByjpv5x0bZNadRQLs/el7t9ZIeMw
   OYn4O4PpeiJg2q6k+0hNC9aiWNnwkEntIeZ/aued6GYs+Phy7hZ7P5cUu
   SyhIyGR7d59Psa8+75afjFSCMCqxFUCa4RQlJQxJFftls3WW6DB55qw/m
   w==;
X-CSE-ConnectionGUID: Y4Xcpl2hRTK/Kk5xlVZbwQ==
X-CSE-MsgGUID: 8D8A8lloSsu3p68qXom3Lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11212"; a="52378938"
X-IronPort-AV: E=Sophos;i="6.11,169,1725346800"; 
   d="scan'208";a="52378938"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 13:45:09 -0700
X-CSE-ConnectionGUID: 559eUvZPQH+FGkM8cSgtng==
X-CSE-MsgGUID: G9Csd+2vSJCjENrAg5Cz8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,169,1725346800"; 
   d="scan'208";a="78764532"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 13:45:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 13:45:08 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 13:45:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 13:45:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 13:45:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2fvzIM+bI2B2ZLX2WkpYfFQs9WIJHkL9gutBQUI0L+G7/JhQ2lPRNi8sitth7B698+wasEaD8jDp8SGqdfKVgNQ4slZz4jcR1HkfTPno81G9UxxoJRkHYL3QX2xiChRCloLc3Jt7EZNW4G/kCL+KdBXHtnd+wRVywVKvYfUMa8GYEMnAn+DLQRg5ThXDpT9/Zx/4VJdsUdn02g+6Rlm1P3rphyK8wkiglTHcqnmY9Y2ZwpgdYzWpRmO8jIFVnZ5GdwDxCjo/7klAT8OAlkD2nPPlmEGKd9DCwSeB4TOULmJewYLF9EBcaBG8L/i0biZ5yEpNGL3UeoNwU4vOqi1TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngCaWLHWxvko/lNDMY/Z8j4GUj+kV/Bb6ohSDwAZWp0=;
 b=cad9GQocxVqoEXIeJ0eujTRJmGdnTDtXWP6Rr3dYgu87hJjO/8f2qoSnRnLweaxotxMmhFdm/FO5cZ2avAvrHYxs3V1Fh6rkY/lXddZTZvwaCgTdzXBADahIFWP4yVSF0tU+93Smlt/NLYfx677RUb9JEnSTCmarCoQCc4ozLUJ2u3wiG3ItqhIin127u2/vBrWM+f5giYbIxprmIxeYgKWg0Lw33UEWiMVKXbEIuX16viS8ZISuqEWcvX2QkVXylpy9rrZ0rXkYR1F06n0o29W5/ex6bxxgytXFYZy0nT0jcbvXU2zEy7xPAm7rNryZ2rhzE8o2tkmhxu8S5//ujA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7130.namprd11.prod.outlook.com (2603:10b6:806:29f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 20:45:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 20:45:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Qiang, Chenyi" <chenyi.qiang@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHa7QnMnUIGjafPIE6UNKd4SDTD+rJFgCWAgAAubgCAACc8gIADPN8AgCmY0QA=
Date: Tue, 1 Oct 2024 20:45:03 +0000
Message-ID: <bac64e4015b62110d6a0ff2793145856bcfab63c.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
	 <43a12ed3-90a7-4d44-aef9-e1ca61008bab@intel.com>
	 <ZtaiNi09UQ1o-tPP@tlindgre-MOBL1>
	 <dd48cb68-1051-48ec-ae29-874c2a77f30f@intel.com>
	 <Ztl6bg2vfah35Zlj@tlindgre-MOBL1>
In-Reply-To: <Ztl6bg2vfah35Zlj@tlindgre-MOBL1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7130:EE_
x-ms-office365-filtering-correlation-id: 97d748bc-21d5-441c-8529-08dce259ecd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N2UvL0R0R3FwVDNENlRQQ3lGcjdTUU9CT3gycENlRERjaE9EL2Z0aUo5eEpy?=
 =?utf-8?B?YW5MT0NzMU9hMFU4OHNrM09YV1ZYRldGYzVTc0pad083SjlCa0p2UXozZVd1?=
 =?utf-8?B?L1cyM2ZmN01sTzhZT0lhdkhDWCtzeHROVmY4Sk1yZGtKbVhaOUpJQzluNnR6?=
 =?utf-8?B?THpDNkR2QVorNm85NXl6dHA5TzA2Ty8vK0lYZnFSUHoxMHBLUDV6Z2RYdTFt?=
 =?utf-8?B?QU82RXk2MnhieCtQSG1qOTdBbWZZbk56Q1VxT0NOeURaVllacjBCcHU2WUtD?=
 =?utf-8?B?QnhRMUtSU2lPdUtwbUZpNGtMaVIzY2hINEtCbmxyZkg0bUNsVDRReWx6MEJE?=
 =?utf-8?B?dmY1ZWdGSFlHRXFNVGF2enZNYXhjaWU1cjNNMjQvYUhzdnlTM0VMcFVnYlZL?=
 =?utf-8?B?WTZwQVV4VmVmb1VycHhGR0dadHVoajJ4b1VQUWk1ekZ3L1o3Vm9HRUliOVpR?=
 =?utf-8?B?U2NEY1RLUURCRjZNaEZVY3RTMVJTc2ZMcnRjZTJzWDgwV2swZmVsaUdNVW1p?=
 =?utf-8?B?eGFSSFZDMkp2cVNVSWtneTZQSjhaMisxQTRsMVU2ZmQvNUNGRWpFeFRQK2xI?=
 =?utf-8?B?UVN1bUUvUGFLSUZ5Y3FtNTREYmROTWtaMGVZdHc1UzJVTkJhK0FXdlU2YnR2?=
 =?utf-8?B?WXpHVUJycEJDamVRWDROYjFLTUs4N1p0M0ZkeDMzRElCSUtRa3lqUXFFZlVl?=
 =?utf-8?B?NzNOMmZIb01DSXBnYTNHY0gxTS8ydy9SVkF5Wm94ZXpmb2UzMlU0VVAzQ2Nr?=
 =?utf-8?B?SElac1RYb3pOcXM4VW5taGJWU3I1cnQwaTZuejMzc25SZG45azdaLytWeUg5?=
 =?utf-8?B?Tnh6Sk1hYTBneG9YcnNhY2gzdXVNZlNXZk1vaTFGL0xsODdtY3RZN1p3S3VH?=
 =?utf-8?B?VTB2ZVZsOVp4SW9yb0twdDc0NzhXNXQ4OVJSRitiVitsMzQzYUdRczEzM3pY?=
 =?utf-8?B?Q01BeEJJSytSOThTYlpPenBRSGhCWHJvYlowOFJabzR5VkdFcXlWUE5waFJ6?=
 =?utf-8?B?LzhvRXRaYTNoNWxqMlFQeHNRQ1hNTjZQOVVUYUwyMFppclBYYytrN2xQZ3Zu?=
 =?utf-8?B?WUxIRGdVUi9DR215MVdmSzhHSzNkaG1UaFk3anJNNTF3THFqcHBoRTBsV1Rn?=
 =?utf-8?B?NnRpVHRsMkRzM1I4ZFRSakJsdnAvTFAySGJseFoxYUNBVkNpR0c3QmNwUTVQ?=
 =?utf-8?B?enpWNHVQNWpZL09hbW9lUGlBM2ZHWGQ0d1VxMGNWRnJ6ckcyQUs3U1plU0Np?=
 =?utf-8?B?bDBMQUJ3NFlsSHhRZExJdDJRTTlaMytsbUZsVU1vUUljNjg5T0s1QlBCMEc2?=
 =?utf-8?B?SlJaMk1kcEdicmtFSW53R1ZlaWlEZnJUUStHSGQ0ci9ORXVINHRvUHRTQ3U4?=
 =?utf-8?B?MHAyM1ZyTGgwQVU5L2dpZzc5N1dTNThueXpNd3JQRm1wUkNVWXg0N3h3dXhY?=
 =?utf-8?B?VVRWdDRKNGtURkdySlpneWdEQlhmejZCeStyZTFMcHR2VWM2czY5clFuOGha?=
 =?utf-8?B?NmU1RFhwVEtEKzZLZmxJNFRZcWhVUVZ4bkxnQ1JtRkNGbFJNdVM1ejJEMXpL?=
 =?utf-8?B?U2RJNEhrWlZNR29YWks1b21Pb1ZnS01JZkd3MklYc0ZvdEZRaGpFK3JZUG56?=
 =?utf-8?B?WCtHa2FiSkpqSVdCVnFySWNza2xMRGVyNEROekhMb3JkUDhjUVBFYmtnSEFF?=
 =?utf-8?B?RTZYQmRXajNHY1J3RmZNYlllVVlxUmIrcFVJMVJKemRZSjJqMGVRRWVHcTN6?=
 =?utf-8?B?R1AvalVIbnFPTE5RYlpDVG9xd2w2ZlRzMlFBNGY1UFl1d29xSmsvVDFDeXdi?=
 =?utf-8?B?WUpCQWRjWmdTWHRORnM0Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUZUbkhTU2picUJZK3A2bHV6QjZVQVJXTmRRVW9TVzQ5UGZWUkJsTFB1QVlC?=
 =?utf-8?B?WU1SWHMrNy9GZTBlQ2toUkcvbVNKLzdxMXFjWUJwS2EwTTVrZ08rL1QxSmRz?=
 =?utf-8?B?QXJqZnhhcDdFKzJmRXhMcVEwdmxFbHJYUHIvRDRCNkFtWi9yMDdhWUp3MXo1?=
 =?utf-8?B?VEZvRE1IdmJ5c0Z4Y2tORUt1RDkzeXdZODBoUjRuMHZlWnBYMGFXRjZhcUp6?=
 =?utf-8?B?NUdCSUNUdXdKUVp5S25MWlo2RkF1UG84dGhyS0k4RHpGbjlyZ05TSWMrVVg3?=
 =?utf-8?B?V053Q2UrRTU2c01uWFVsLzJJQTR3S0dLZTJITHl2WW1NUUpGV05tWHFYT1do?=
 =?utf-8?B?ajlOL1hvZmF4SlQrREc3dWtsKzFJZU1ORGloNGRiN0NoTHF4YUlWS2I1UWtB?=
 =?utf-8?B?cW5oU0VJbXBpaGgzWS9QUFZmZkFObGxCQVJmK0tXVkxXZVlBQyswZklZem5T?=
 =?utf-8?B?RmN4S0E3RllwM0EyckFqZlg3UWVHLzAweFpXUDA4VmpLRGZaRElPU3k0WkhR?=
 =?utf-8?B?bm1BUU8wVUE1a1AwWmFpY3p1bGtZZ1FBOFNKWklRc09sQ0lnaDM3S0FOeG90?=
 =?utf-8?B?Q3VHQng4d29TNGQvWDlCK3JqZjlyM1RRb0FHTmVLa3BLdi9Kd2x5WnhibEZh?=
 =?utf-8?B?SEN2Rkd6b1pDWFNqMGNZSyt1VVplRCtyQVNkNCtIZGlTWVVqTEN5aUxkUVQ1?=
 =?utf-8?B?NVR1TVNId2lpNmRwQlZ6eTZJOHdTa2VKVFA1UW56SEpOSm4rKzd3V2ZWSG9i?=
 =?utf-8?B?RWFzZ3lwT2R5ZHFZVnk4QURmT0gyeTBpdDE4THhLSVFXTUtkSFUraXAxeFJ3?=
 =?utf-8?B?R08yMm9CVU12bnI3Yll2QlV5SkFodXFBV0p3KzVVb3ZkbzNacFI4UGVHU0Ja?=
 =?utf-8?B?RkR3bE5EVWovam80cU5PRE5aWlIvZUE0NlZacXU3SjNuNkdWSzZvTk45WkVH?=
 =?utf-8?B?T3RuMWloSHhiQjJ3TkkvcDljSWF6ZzQwUVF2OE52Mk5ZYklzQmJVVUFPM2Ri?=
 =?utf-8?B?bjB6ZVJEejB3UkQzOFJ6c3BBNzNmKzRwNi83MDFGL2pFSTk2WTV5UGZpRUlM?=
 =?utf-8?B?d3hZR2ZjRkJSMzM2SnQydjVjVHgzdC9oSlIvNHFDbk16L1NRZE9weWY0N3V0?=
 =?utf-8?B?MVhlckZQdHV5c2hHQ2p2SzZnTitJTzNhTHhmb3VqTjl6aGxiR0x2alBrb2lJ?=
 =?utf-8?B?aTVVUG81cHpHbzBVSlQyanFnWWp3UGNQS01UcGZSejJuYU0yQldQeUp4azZ4?=
 =?utf-8?B?Z0FOUjJUanlNMDh4a2kwWjVodncra0orZklrT1FrblFsSENQZkhGQ3VHdCto?=
 =?utf-8?B?RW5HTUpOWTRkZVR0V1Q3eGRmWUJPeUVSSUlybzEwaktUUU5wOURjbnBDckVT?=
 =?utf-8?B?VWExWkNvOXJIeDVKVmVWM1ZZNmZhUTd4dVVPOXpQdy9PMmNxR3dZdDRqYWJN?=
 =?utf-8?B?VVdKc1psRWpsZzRoK0V1QlZWc3hIK2RhSVNrVEZvWDdNckNtNlFub05CUDNX?=
 =?utf-8?B?bFZKTDJaT2h2N3pEQXBwOFNnUXRkSTl1OGlWR1VCWHBXamtVTGJIRW9zMmlD?=
 =?utf-8?B?aDVNdm9hayt3M2ludDVRalR1WUVXampSNVYrbVBWWjQ3SlAvTVZHZ2JnSFcx?=
 =?utf-8?B?MUt2YnlTMkZXOTlMeU81ZlM4Wi91RlNpamJpS3Z2bGpHRUx5TU9KY0JYdDlT?=
 =?utf-8?B?bjBEM2diaHZmSHdwYzgzYkNBQzZXTDc4OElqYldPTnM5RnkwZlc1Ung5eGJz?=
 =?utf-8?B?U1BKTVdlaEs1VFVsQ2psczBpRng0akhLVyt2Y0hEdlkxZXFYeDczSXZRbDVS?=
 =?utf-8?B?UjBXYU9ObGsyNmtRWTgvVVZVZnNRcDA3S2o5OHZuSXV2d0QvVmVxcHFvREw3?=
 =?utf-8?B?RlJqVnMrN0RCMFp1Kzlva1JkS0IveXU0UGRjNll0V3hadXFzMll1dDRTams0?=
 =?utf-8?B?ZXBINmlaS0FKdDdtTHZpdFE0LzdnaXZJbTRvMWo0VjJzcW5lbnMwcDNoZmR4?=
 =?utf-8?B?M09LWVVmWVRUMDcySVVna1NhTlcxOWRIUE8vOGUvdFZZQllpcGpBVzhIaGVq?=
 =?utf-8?B?aU91VGxxRzU2TlJOdXJ0bUlXWGd0MGR6ZUp2bkh6ZjVJRlN2WXBmL29kdHUv?=
 =?utf-8?B?UkhkeHlVUlRDZmtneVpMM29BTE5hVzFtVkU4enJtNGRhZFJnMlp6NE1XMVBv?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DC3E50937DB8540BA91C46E3484EBC3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d748bc-21d5-441c-8529-08dce259ecd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 20:45:03.2426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /BC5/wDb2f9mUY/XkLDFf6ILyJ/6EnEhhTKYUglVonqucMb14jIXzvndmBfyFAsWo5zYXGT0b1c/7NgJqVeTpKl6BbRS7ZRUQohaRGP5UiY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7130
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTA1IGF0IDEyOjMxICswMzAwLCBUb255IExpbmRncmVuIHdyb3RlOgo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14
L3RkeC5jCj4gPiBpbmRleCBjMDBjNzNiMmFkNGMuLmRkNmUzMTQ5ZmY1YSAxMDA2NDQKPiA+IC0t
LSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMKPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4
LmMKPiA+IEBAIC0yNDc2LDggKzI0NzYsMTQgQEAgc3RhdGljIGludCBfX3RkeF90ZF9pbml0KHN0
cnVjdCBrdm0gKmt2bSwgc3RydWN0Cj4gPiB0ZF9wYXJhbXMgKnRkX3BhcmFtcywKPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBSZXR1cm4gYSBoaW50IHRvIHRoZSB1c2Vy
IGJlY2F1c2UgaXQncyBzb21ldGltZXMgaGFyZAo+ID4gZm9yIHRoZQo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHVzZXIgdG8gZmlndXJlIG91dCB3aGljaCBvcGVyYW5k
IGlzIGludmFsaWQuCj4gPiBTRUFNQ0FMTCBzdGF0dXMKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKiBjb2RlIGluY2x1ZGVzIHdoaWNoIG9wZXJhbmQgY2F1c2VkIGludmFs
aWQgb3BlcmFuZAo+ID4gZXJyb3IuCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICoKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBURFhfT1BFUkFORF9JTlZB
TElEX0NQVUlEX0NPTkZJRyBjb250YWlucyBtb3JlIGluZm8KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKiBpbiByY3ggKGkuZS4gbGVhZi9zdWItbGVhZiksIHdhcm4gaXQgdG8g
aGVscCBmaWd1cmUKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBvdXQgdGhl
IGludmFsaWQgQ1BVSUQgY29uZmlnLgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqLwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKnNlYW1jYWxsX2Vy
ciA9IGVycjsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChlcnIgPT0gKFRE
WF9PUEVSQU5EX0lOVkFMSUQgfAo+ID4gVERYX09QRVJBTkRfSURfQ1BVSURfQ09ORklHKSkKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcl90ZHhfZXJy
b3JfMShUREhfTU5HX0lOSVQsIGVyciwgcmN4KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBnb3RvIHRlYXJkb3duOwoKQ3VycmVudGx5IHdlIGZpbHRlciBieSBzdXBwb3J0ZWQgQ1BV
SUQgYml0cy4gQnV0IGlmIHdlIGRyb3AgdGhhdCBmaWx0ZXIgYW5kIGp1c3QKYWxsb3cgdGhlIFRE
WCBtb2R1bGUgdG8gcmVqZWN0IChiYXNlZCBvbiBkaXNjdXNzaW9uCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2t2bS9DQUJnT2JmYnlkLWFfYkQtM2ZLbUYzalZnclRpQ0RhM1NIbXJtdWdSamk4QkIt
dnM1R0FAbWFpbC5nbWFpbC5jb20pCgouLi50aGVuIEkgZ3Vlc3MgdGhpcyBjb3VsZCBiZSB1c2Vm
dWwgZm9yIHVzZXJzcGFjZSBkZWJ1Z2dpbmcuIEknZCBzYXkgbGV0J3MKbGVhdmUgdGhpcyBmb3Ig
YSBmb2xsb3cgb24gcGF0Y2guIEl0J3Mgbm90IGNyaXRpY2FsIGZvciBub3cuCg==

