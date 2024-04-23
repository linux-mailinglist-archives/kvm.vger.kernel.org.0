Return-Path: <kvm+bounces-15667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 685568AE8E0
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D545287CD4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046ED137920;
	Tue, 23 Apr 2024 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K0Ht0ZhG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD819137770;
	Tue, 23 Apr 2024 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713880752; cv=fail; b=ZpPsT6ZoL40nQ2jFq7RIQfmpR5X9temiuGntBC14mq59rURa559HlNQYxiMvjjoF5DptQJSeAaC0pvhneyKpxtu+Qq3c2q/MnXtfloj75OqLytEXwdgKCn15H2R1ss6b0HYTQ6Bu6pjTba5EiS7eoJLzT9efwKdTQCJpMSBe7+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713880752; c=relaxed/simple;
	bh=jr2IdlT/4QQ6EurqYUtI4UIVA73O89aULgOnWNmVLS0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r/9MvYx7GZzg3F/9cnocj6fAwZRgqw6JTXJW1DN4ZT90mOMmtXBombQ8K4IfAdlBVox0jZ5oc87lqkpeN04xBFby6+u5SqByLlkjWzKpTFiQVuHAvsNXwTAS4fteytLYqeeO7hxrl8nLudOWIpLeVPr5tEvucYYccmUQbkWbCIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K0Ht0ZhG; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713880751; x=1745416751;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jr2IdlT/4QQ6EurqYUtI4UIVA73O89aULgOnWNmVLS0=;
  b=K0Ht0ZhGSxITvXNYuJBe2Yw++xSgtYVYFYD3XGKADgS63MwT/8qOL/v+
   +yM2IvRFwCr+4MHnhx0mfcUvUMMkkVuMYAo+fAdsuWmtjHJqBVipv+HzT
   3hLoXhavq3N3PMGQ8PLIt5uhW0Xe3P4Zvq+BVmp+8YuyaatYNV1vax4aL
   hsgXiuY+3QHVdV7a8zxZmy56X/wKPW035Bh82KA2obZ1C9e+DE3f53V7D
   xeLv0xyZc7K4NyqyU5vI+cOM54r9t9lc6fpMpW/S153OUOi0rr3s5glMo
   NfB4WwQhw2mG73dZFkLKJeQHF0pqJRnAMFIEhVhgQlzX1ECOELkHcUkkI
   A==;
X-CSE-ConnectionGUID: ZUb+D3H9QJaUI4n7NkdFMA==
X-CSE-MsgGUID: /VcYHU/gT4ef+k9VZoIGig==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="20882997"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="20882997"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 06:59:10 -0700
X-CSE-ConnectionGUID: PbfKnwrWTt2yay4d43p8vQ==
X-CSE-MsgGUID: rHzeFoqsT7SEBE+SNPF0ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="47653591"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 06:59:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 06:59:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 06:59:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 06:59:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 06:59:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2A5dr2fAxQ2JMTCt7a5aNvGcZvrQCXhtQM8W3rplxuDk8Mrzc64q8j0Ro34m4DAEf3muXHXFXvMGh0d2ANaJNi3Jl0xNV0BZXxjjn/6lGZIIp2K/U0/g7t/hK+1dM1StXz6WS2cmYigmSxEfX52zGK0neAEsmjNqOsWO+VE5PQ+1ASXoIqQHve22iwCB2z9zi/RXxBJgHUXl52ZWb/1ebB5NqHGjIbBY1cRFrbPheEqxAsgAr0Y4cUJmZFvnPkmwNGozH4gM+KBqfpndPHF+fY2641bilps8DU+udO+25nPX3ajMxyJdATOUDMSUVV3bBDTmpA7zU3umHRwY4Lziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jr2IdlT/4QQ6EurqYUtI4UIVA73O89aULgOnWNmVLS0=;
 b=lMK9705mlRzGlVkuu7msRRCuwnHYYhHJSOVRwyorrLx0Utb+4XrmuqMhao2pCexyfUz4IZmwWA35VTKjTRCCkGQoeWmC2VfP1u2CTcw7sDqFjTSbrrEfJtxDt9P/1l/QWTNPZZikx8Zw0gSpYL5U+aV0kchEMBqQdkr3Qv3Z1OYR5MzPktTgO5JHeOAkfesmvviutZENq1gd+ZY0rWM1UYNeVTSXqPLgdKKxScJAwv9Lju50oTopszkonKMmFLCYXJq4uJATEZgM6TXcTYQJmQBVOVN1UKVqo2l1QLSZlqXb3dW0GASQIgRTWSAht9qXhYoU50AQFEShBIoYz6LxcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6194.namprd11.prod.outlook.com (2603:10b6:208:3ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Tue, 23 Apr
 2024 13:59:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:59:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Topic: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Index: AQHaaI22CHOAd5HudEy66qf/I7Hhk7FC3swAgAGlYYCAMbeBgA==
Date: Tue, 23 Apr 2024 13:59:04 +0000
Message-ID: <25d2bf93854ae7410d82119227be3cb2ce47c4f2.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
	 <dd389847-6f67-4f5d-8358-5d6b6a493797@intel.com>
	 <20240322224531.GB1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240322224531.GB1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6194:EE_
x-ms-office365-filtering-correlation-id: ba83ad5b-1ac2-4700-abe3-08dc639d89a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?d3pKOEl6d1ZPZG85MHp4dno1cGVQb2RnZ05lZVlhVy81Nk5QV0RKdVdRM1Fn?=
 =?utf-8?B?bHdrQk1TWHhURms0eWNpc29wWVNucDZadVljSnRXRENDOEVyZzJUMFFsZzhu?=
 =?utf-8?B?WjVYOXFCem9LU2xMY3hRVWFnOFVMOXJRbGdjNFhwdHJmeWNodEQ2amwxbFlS?=
 =?utf-8?B?bUJyT3JGSlIzSDdzTDFmM2g4QmpLZUUvQ0s4Q2lNNjJML2JvT0w3Q3UxMjdV?=
 =?utf-8?B?Um1CRlh3N3F4TjJRSjJ4TjhtSEZQRGVqdWJVeU9Ic3NCcE5zS0tyRXN2SkxD?=
 =?utf-8?B?c1A3MnJXZnNwaFBvWmxlUjdIb09jOUtwek1pRDZoS0h0TUFlSmV2TjRieVdm?=
 =?utf-8?B?UDlUT3FGb1JIVzJ4clh2UU9oUytIY2s3QWVVa2NPQXlESHlPUUE1SkhDQk1P?=
 =?utf-8?B?UVl4bXpWR2IyWVVQT3NWd0NkZ01UUEdWMHhxd2NodzNiWjE0N2U0M2JwZVlH?=
 =?utf-8?B?NC9TZVFxZmRTei9HaENLQ0FUL29DdjA5TmNjdjI3VzdlbDdaa2x4SnA2Z0o4?=
 =?utf-8?B?Q2ZrTnhuSXl1T0lPck5XWHFBcnJXbExEV1RMS1plMlZpVHh1aTJabUZGZmJB?=
 =?utf-8?B?THI5WkFiRi8yUC9wd1pzYlkwVkllOHRHODJuTFpRQjVER0FjM2k0eHJ3QkZJ?=
 =?utf-8?B?YmlvRzJ4aEtIaEkvQTNhektOSW5DcHVvbkhZODM3cVhacDJQN05QeXZiSjFD?=
 =?utf-8?B?TFp0anNTNVdZR0dSakJhZVNiNmFOUFVReWJjVEx5blptMi9ZWEdlZFBxUlMv?=
 =?utf-8?B?M1pkSUJsNHQ0bHZnWWsxNi9wSHVZWXhyU0JtSk54M1lqb2VvbG5QS2dGR291?=
 =?utf-8?B?WEVZZHFvL3NLLzhyRk9IazZqbnRGN3R0RWtKZm9RQVRtTGt0UlNQSXU1L083?=
 =?utf-8?B?cTlWYVZCUEt1ZVFrVVFQUDlzOWJxTTJjbTN2YmRWVW1jQnhwUEkzcUw5eVNC?=
 =?utf-8?B?QTEzZUZYLzR2Q0JuUmNxL3NvSGUwek82Nkpnb3FzZzM1Z1o5czN5d1FnQ2Vp?=
 =?utf-8?B?Q2VhTTljSHFxTWphZTc3eitSTnpPRmp2RUdEZzA4RDBKdTJpR3NOU3BvNkc4?=
 =?utf-8?B?a2VySURITHZYZ1h2WGl1UWt4WUZlcDlIcFBmc0pCcWtnQm54bkpuYVhIenhB?=
 =?utf-8?B?ZE1mN3JJc3h3U1ppbDhsQ2ZIM3dsRHU5cnJZOU5ZRlN6MmNmV2tVb3R6NlNm?=
 =?utf-8?B?cTZQWkVmTHY3ZkZ1aXZPZitPZGM3ZzRZREpib3dXaUJuRWZwaFdueFlweFdK?=
 =?utf-8?B?RWFLNkRmcVJUa3ZNZXhmNjRJbzY4S0lZdFNCODY0WHJQVE9lb1gyMU1SV2VF?=
 =?utf-8?B?RG1lR3JJT0R2L2pIOGlSWjhNdndUR1F3QTZTRWwzUllGVjFDQnQ5azhUY2wr?=
 =?utf-8?B?akYzaFE2TVdNS0wyL0dJNUhMbG5JcVN4K0NWLzFIY2U2MXkvTGtJV3FFN1Jj?=
 =?utf-8?B?c1ZxNkhDdWFDQjZUWmxydDVKU3hEbEs5TEZ4NzNaK2M1YWJnS0JtNExQMi9p?=
 =?utf-8?B?eUhtQ1JlNThvSm9yaGVUWWwzWkJ4T3hkZEZJTHRsOVdlVDV1SUZUckNHMUJh?=
 =?utf-8?B?NXJoUWlPc0c4YVlPWk1GRlVJeTFCbjcrTFN5OXVoRVpScVowc21yb0J3eW5j?=
 =?utf-8?B?SE5jcWhuV0ZxYmNpSU9leU1hTHVrTVMrNjRsaE4rTUtIaThQM3E2Wk9nOUo3?=
 =?utf-8?B?YjBWTDFVbUFnc2JGS2FoSE1nOUFrVmMrMlB2NjZ5cHVKci9iWXQ4cUgzS0lG?=
 =?utf-8?B?ZGtWWGU1TE8xQVdEbHdWYTg0THVmVlJCMTl5c2UwVGVicURTWEp1R2RieFdU?=
 =?utf-8?B?RnZDTG5tVFphT2M1OWRZQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUVJVFZpcmJudGF0ZEs0cjd6TXQ3VGpNMnF1QTlnMVpNSEFwSzIwa1FiTTZa?=
 =?utf-8?B?YzIyT2ZoTm9tYnlrL2FEWTQwdWtZV3VvZzZJYWlNcG1Qa3d2MXhrSzk4Qklr?=
 =?utf-8?B?ekFROUZnQnJWMkVaMUNVdGhJa0JHSXhQVldDam5LbHdiR296Y1plVGdCRUNy?=
 =?utf-8?B?YjBIZ25VTE5KS29WRlhCKzlsU0ZjdnJDUng2UkNBZEMwZzNKcm9zbWVQZ2Ns?=
 =?utf-8?B?VDRtVUYzZkRmUFp2QTNOcTNlUTRnS2hMQVpjUHl3dGhrU1FCanpGRlh6U2lH?=
 =?utf-8?B?ZzZUQUt6eGFkREVmV2drM1JLaWZKVTBBUXpyZ1NoQUlPVEdYVERjQjhuNm9q?=
 =?utf-8?B?QXVOeEV6dkpxcEo0RkxPRGdSbloveFBkVTF0M3ltMk9yZW93aEo0VTc5SE1m?=
 =?utf-8?B?OTEvWmg3amlsVHV6Mis1dzVOMSszWThSSkVGUnY2bmFJRk0rUnZhU1dnbEI1?=
 =?utf-8?B?a0YycVpqZXVGRU1yWXFqTFpoUVoveVFlU2tVUHlOVExvZzg2eS9CT251RUdG?=
 =?utf-8?B?Nm5ka1Z5YXZ4bHgvbVNvTks5ZS9tS2hvTDBMOUVlamVRcHhLMzNma0lUZjV3?=
 =?utf-8?B?bmRnMDZzM0VSaFZsK2ZsbnBuc1VGcXI3bmdLL041OEcweTluYlRYWmJmS1lo?=
 =?utf-8?B?UEpqMXUxcUR3VjI4R2hUQ2VHVEMrcG83ZVJZamFVR0JTbGwvM3Fnazk3UndW?=
 =?utf-8?B?eHJIL0dLL0pFSFdyaGl5N21BYVJhL0NRU1RPR25jTmIyS1NwUVJQMm5Vemcy?=
 =?utf-8?B?U21zdGhCMTFvV0YyalYrMXFvTFBTbnB3cCtmMU1KRzJYMzhxNThOQW1Wd1BV?=
 =?utf-8?B?dmdtZG5DNzdVUzFNcTFGY1NjQlg1WkhLZkVBeUNRb3ZPWHU4Y3FnUWpiT2NX?=
 =?utf-8?B?bnQ3bzNiaE9GTlVqQlhCZGdTbnJWV2dBZ2RUR1Q1bHI1WDNBK1kzeTJYeGRk?=
 =?utf-8?B?SXBXZVF6N093MFlKUHNnS2UwenBsbDV4M0JicDBKNExpcjNrU25yMWtvTitl?=
 =?utf-8?B?cUNuWXV2aXcrRlVQNHVpdDVHTUtoaW1EYUoxdjViTG4xNk1LYTM3Y0d3L3g5?=
 =?utf-8?B?ZE5zM3lON1Y2bWpJejRzc3Y3Tm5DU2l6ZUgvWXc3OXFyRjRza3VPYjFPdFVZ?=
 =?utf-8?B?SjFyaU5kUzcvTzNURU5YQWpNRWhUYW1zL04rYzhVcTNDbWZ0VG8wV1oraDBl?=
 =?utf-8?B?c0NVZi9rVXM4TlZwTS9uUXV4cTlIQXhQQWdEbFQ3L1V2dUlBaDJWZWN5Vjlm?=
 =?utf-8?B?NXFzY0hmaGxtNjE5S0k5Wk5BSkNrU2VEQWQxNzJXeHZhK2x2OVdrbUZkempi?=
 =?utf-8?B?Q3VIc21JZitObmZGUERIc0lhMGZpUzhnY0hnbDkzMHMzVFJydjR1RUxCcm12?=
 =?utf-8?B?M0ZRTWJ4dCszUU45c1RuV0tqN2thd3JrVWJnY2lKQU5Id3FlK1hmQUNjajln?=
 =?utf-8?B?UDB3YWtqbDdzY1NBajdvZ25DMVJvUGlRRTA5SHp5L0hiakoxdVpXK0NMZ1lN?=
 =?utf-8?B?ajkrdkVVc3MrNzhST0d2RDlmbDlVVHV5bnBGSVJDMVYxY3dmalE2NkdodTAy?=
 =?utf-8?B?ejlHYUs4UzFnK0V2RmFkVTdkYWVMM2Y3Qmk3WDEwYjBrV3FQRVNtVUIwRFMy?=
 =?utf-8?B?MGE5VmF2bmU3eVgwa3hycjhlWmgxME1zU1FTeFZlN0hKUUprVGxsbDVRV3M1?=
 =?utf-8?B?bEJndnA3Z1hSUUJ6b296OFNaOFdZVjl1UW93aDlzSUdxc1NZSVM4eXFmcnNE?=
 =?utf-8?B?ZVR2Z0hId004YUVYeTZBSTdwUmhiNDk2U2hUSkdxSGhSK0svc2FFY3ZSTWNm?=
 =?utf-8?B?b3hjNEtXelhjeGdJTVpoZzBhcFA4bHhJcVo5cS9XWFpvV0pDelBrU3RhbHY3?=
 =?utf-8?B?ZncyTTdqOG5TTWxMVGRXdGJLLzZYVjdEdnhZMTVheE1Vc29SQzdMUXVYdlNw?=
 =?utf-8?B?VHA5RU1CWkdLTHZzYWtHVithUU1nZGNWQnc0Q3RVNitsbzNvZWlCbmV3Rk5m?=
 =?utf-8?B?bTFYRXFYcU0zZU9VZTRENmRzYTg0ZFlHK0lRUlFYUDNGRVlMQ3VxN2RzVDJ5?=
 =?utf-8?B?dVZsbjY1RFFQNFhUczAzU2J1M2ZIZDFBOThJZGVrVHlyeDJqb3YyM3pZd1Vm?=
 =?utf-8?B?YkFEL004ZFFVWmJKRytxYXVGMVRCMEdmT3Evbjc1SW1LT0YyaVlEL2YzcE1Y?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1F390B649D8124EA5C75A4E602D0162@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba83ad5b-1ac2-4700-abe3-08dc639d89a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 13:59:04.9786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUPBY2CNa0VHzmb8DxvzzeOM2UJLUeyePhyzVk5zq+DnG6B7AGIGuiCF1tslR0ftGdkqm3OF7vbEyQuE4sYptA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6194
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDE1OjQ1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gSG1tLCBub3cgSSBub3RpY2VkIHRoZSB2bV9zaXplIGNhbiBiZSBtb3ZlZCBoZXJlLsKgIFdl
IGhhdmUNCj4gDQo+IMKgCXZjcHVfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgdmNwdV92bXgpOw0KPiDC
oAl2Y3B1X2FsaWduID0gX19hbGlnbm9mX18oc3RydWN0IHZjcHVfdm14KTsNCj4gCWlmIChlbmFi
bGVfdGR4KSB7DQo+IAkJdmNwdV9zaXplID0gbWF4X3QodW5zaWduZWQgaW50LCB2Y3B1X3NpemUs
DQo+IAkJCQnCoCBzaXplb2Yoc3RydWN0IHZjcHVfdGR4KSk7DQo+IAkJdmNwdV9hbGlnbiA9IG1h
eF90KHVuc2lnbmVkIGludCwgdmNwdV9hbGlnbiwNCj4gCQkJCcKgwqAgX19hbGlnbm9mX18oc3Ry
dWN0IHZjcHVfdGR4KSk7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2dF94ODZf
b3BzLnZtX3NpemUgPSBtYXhfdCh1bnNpZ25lZCBpbnQsIHZ0X3g4Nl9vcHMudm1fc2l6ZSwNCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzaXplb2Yoc3RydWN0IGt2bV90ZHgpKTsNCj4gCX0N
Cg0KSG1tLi4gQWZ0ZXIgcmVhZGluZyBhZ2FpbiwgSSBkb24ndCB0aGluayB3ZSBjYW4/DQoNCklu
IHlvdXIgY29tbWVudHMgdGhhdCB3YXMgcmVwbGllZCB0byBCaW5iaW46DQoNCi8qDQogKiB2dF9o
YXJkd2FyZV9zZXR1cCgpIHVwZGF0ZXMgdnRfeDg2X29wcy4gIEJlY2F1c2Uga3ZtX29wc191cGRh
dGUoKQ0KICogY29waWVzIHZ0X3g4Nl9vcHMgdG8ga3ZtX3g4Nl9vcCwgdnRfeDg2X29wcyBtdXN0
IGJlIHVwZGF0ZWQgYmVmb3JlDQogKiBrdm1fb3BzX3VwZGF0ZSgpIGNhbGxlZCBieSBrdm1feDg2
X3ZlbmRvcl9pbml0KCkuDQogKi8NCg0KWW91IHNhaWQgdXBkYXRlIHRvIHZ0X3g4Nl9vcHMudm1f
c2l6ZSBtdXN0IGJlIGRvbmUgaW4gdnRfaGFyZHdhcmVfc2V0dXAoKS4NCg0KQnV0IEkgdGhpbmsg
d2Ugc2hvdWxkIG1vdmUgdGhlIGFib3ZlIGNvbW1lbnQgdG8gdGhlIHZ0X2hhcmR3YXJlX3NldHVw
KCkNCndoZXJlIHZtX3NpemUgaXMgdHJ1bHkgdXBkYXRlZC4NCg0KCS8qDQoJICogVERYIGFuZCBW
TVggaGF2ZSBkaWZmZXJlbnQgVk0gc3RydWN0dXJlLiAgSWYgVERYIGlzIGVuYWJsZWQsDQoJICog
dXBkYXRlIHZ0X3g4Nl9vcHMudm1fc2l6ZSB0byB0aGUgbWF4aW11bSB2YWx1ZSBvZiB0aGUgdHdv
DQoJICogYmVmb3JlIGl0IGlzIGNvcGllZCB0byBrdm1feDg2X29wcyBpbiBrdm1fdXBkYXRlX29w
cygpIHRvIG1ha2UNCgkgKiBzdXJlIEtWTSBhbHdheXMgYWxsb2NhdGVzIGVub3VnaCBtZW1vcnkg
Zm9yIHRoZSBWTSBzdHJ1Y3R1cmUuDQoJICovDQoNCkhlcmUgdGhlIHB1cnBvc2UgdG8gY2FsY3Vs
YXRlIHZjcHVfc2l6ZS92Y3B1X2FsaWduIGlzIGp1c3QgdG8gcGFzcyB0aGVtIHRvDQprdm1faW5p
dCgpLiAgSWYgbmVlZGVkLCB3ZSBjYW4gYWRkIGEgY29tbWVudCB0byBkZXNjcmliZSAid2hhdCB0
aGlzIGNvZGUNCmRvZXMiOg0KDQoJLyoNCgkgKiBURFggYW5kIFZNWCBoYXZlIGRpZmZlcmVudCB2
Q1BVIHN0cnVjdHVyZS4gIENhbGN1bGF0ZSB0aGUgDQoJICogbWF4aW11bSBzaXplL2FsaWduIHNv
IHRoYXQga3ZtX2luaXQoKSBjYW4gdXNlIHRoZSBsYXJnZXLCoA0KCSAqIHZhbHVlcyB0byBjcmVh
dGUgdGhlIHZDUFUga21lbV9jYWNoZS4NCgkgKi8NCg==

