Return-Path: <kvm+bounces-47799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B473DAC52F6
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7352D9E141B
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 16:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF4F27FB37;
	Tue, 27 May 2025 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfeuQd/B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB327F73D;
	Tue, 27 May 2025 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362785; cv=fail; b=XWyfSkYYbQfiDxXragQPpi++epQC3Rbh8cFpJiN6ETBvshisTX319xhNa2oWG6EMbbtRjTrkSqrVhH1iU1ePzD9/EAPtz4qdqvYJXERac4wCglBxKhydLUQH82gjK7qOwS5IsI7YQ2Oef4HPhmwGExtDLIuOXyXS1kAgV+ORuNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362785; c=relaxed/simple;
	bh=opEQAl8AJAtFUC8NGzzCAYaClYHdWgh3/jN7Q0mw1Ws=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hn7C7up9QTUbMbnIkRuBWOtb2Px3+8r0f6Lrphcx2FDTWoLFBw95AurxuAOZG+9/wu9hA65+o42q0mjQwh4Io8hf3c28pOFvDoHrhDPQoAq2Jdvkziduxef8aSsIz57WbC5z+EZ53Z4oqQDJhTiSGV6+YMlQ6UPrN/CLmpOTuKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfeuQd/B; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748362784; x=1779898784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=opEQAl8AJAtFUC8NGzzCAYaClYHdWgh3/jN7Q0mw1Ws=;
  b=SfeuQd/BeBzKocuPMT2MSSy34efiOaOS+kEtqbhP84pHvjp/Pt52jpP4
   ifks+swCiTUGgBVR/QmSRP2gN2IQOz2L0g3xiuIxckANJ2L6VZx1GMu3w
   vn6BhgP7iVJrOgybDsMqo0Keq/epGly9NDwGF3sB7qKMhoka3Ar4NJ5+M
   YlTEM9TnaO3UupGD6zOW4dEEl+EGvGaBCk25jFRTL7N/E/WJG+A19juWN
   aIvuYz02Q0THAgP2rVuemZJ0hidIDHOs6wMefLNEgRN+OX3Mk9E/Ns03C
   UEovXhWRKJe/L2lO4p7LJfA/MihUQ0/Pv7z5SrwCejd4cYydYkM3ovbaj
   Q==;
X-CSE-ConnectionGUID: XKxf6jj6ToyGCXlLfu89qQ==
X-CSE-MsgGUID: eNlXzjk3SMiHEZrm3Xh/aA==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50241980"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="50241980"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 09:19:43 -0700
X-CSE-ConnectionGUID: ey4lK51RRnyag1u+t1Gohw==
X-CSE-MsgGUID: cpq1WDcRSWmlg/fUjLu32w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="146755362"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 09:19:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 09:19:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 09:19:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.44)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 09:19:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=feKYLoS3pq0vao8BsxwAuWU4KVSDsBiFq0baNX9MC8EwqYTsYTLgzXfn8hjs637IsOS8PcYv28vqA+HPK/2LD2yQVV368eEiCyTuVKUscTBhd4l6EpbbXSQKvbiL69EhKaC6sgJHNQ+cF6LtFUMzNaWhkdZL0MVcXpOl3+5R2dh74hq0h1TEhbNgyJ9V8uf3m2hGQh+AQVnR5cEhr4pCGOPTO1meZbBmwHeacgKsLryz49FmwQt80Mwf3yfm56oPg4O9NfbK0nT/kmVTuXBkz4fF4wqUdF7yFZs0J7xj001UuCoC5Xhzfjp0qRHaFm8ru7RZPv1ksco+2Q0eCGKJQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opEQAl8AJAtFUC8NGzzCAYaClYHdWgh3/jN7Q0mw1Ws=;
 b=WGuHXLj2UlQk8+EU8dHWttJtq55BWzrMLN5W9MZ8n7yHx2eYlW597YQ4baa57TBQHvH9is/rF1sWs184QIgovNYfbexA9FGC5KjDU5XW5LMsFzsfL5njxhbK6lx6WXbfZtyvIMO5A6X506uFI3WAGdWZp3rP7gJRbDcHIEF9S7d2zhgW36/OZ1dl+i21pshhH0tSDO/arMtL1Y7/Nvu+PfFr98qrkw16/5Dnw8YOga5Pnne7OqwvlTfI4bUg5r0kZnLv6VbuN05hBt/mFr587O7TVq0q7ZRoKWIWYhjMjjyW6IYO+PcEXqYS9XA3wj3HB9qm/z0kvyoIUkHN1RQJWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6991.namprd11.prod.outlook.com (2603:10b6:806:2b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Tue, 27 May
 2025 16:19:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8746.035; Tue, 27 May 2025
 16:19:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, lkp <lkp@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>
Subject: Re: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Thread-Topic: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Thread-Index: AQHbzyMjacMDwqy4N0G0bONhNXai1A==
Date: Tue, 27 May 2025 16:19:36 +0000
Message-ID: <dc0fd831ac82f313ce9bf8bc3180b7beef565821.camel@intel.com>
References: <20250526204523.562665-1-pbonzini@redhat.com>
	 <aDXEG5tXRfsSO0Hf@google.com>
In-Reply-To: <aDXEG5tXRfsSO0Hf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6991:EE_
x-ms-office365-filtering-correlation-id: 510bf0df-4756-41b5-dd6c-08dd9d3a45fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YzZzRkNiWVJJaE13cDNJeXVuUkViRTRDNC9tb0dEMlYzdlBnTzFLeXRNbnBW?=
 =?utf-8?B?OGFGMG5iaytyQVd3czQvU1BpRFVncHRrSGRDcEwraEVBUHVaamtQYXlKNWU4?=
 =?utf-8?B?SHltOFFyN0x0a1JkNWRtMWpGV0JOVmFsanBmY2xpb3E0cytEa2JxRHEyRng0?=
 =?utf-8?B?OUdTeDNrejBqUHN5cUR2SkVENm9FckVzU2lJVnpYRU0vUUZjMW1tbFNEZXVt?=
 =?utf-8?B?MjJzQXQ3NFB0WXRUZit3K2ljd2dWaXFUd3poSVIzV3RIUkpZTFNPdW1keE5Y?=
 =?utf-8?B?b05xTkI1VUU2MG5HM1ZwMnZCYWk3RUorVFNCeXNKNzFMM21rVWN5ejRoUXND?=
 =?utf-8?B?TCtYbDVDOTBPMVRkUVBjb3Z0bzE1NUNNS3dGV2J1SVgwek9La0tTMFkzcVhC?=
 =?utf-8?B?ZGNnOEZISmk2VjNPd0tESEpIYVMvTFQ2MlRkU3hTNDltR3Y4TVc3UkRFMTBS?=
 =?utf-8?B?VlBSQnluU3FJd2FZWFBub1g5WmV3RlRrR2QwOEx6UEJoWE4rUUNoVWxrYnFt?=
 =?utf-8?B?UTFQMjVSSTlNSmVvbXV2UU5WN09BSnY3ZVN5c0xuS09MSUtEVCt4WWNaVTJW?=
 =?utf-8?B?QU9hYXRJa2x4emxpRjcrRXpOOXprNEpaQUtITnFBNUgrSHhPVGF3STFkczA5?=
 =?utf-8?B?S3NGTW9PdElNYTJOT1pnTXNnL24xaXZjbnZRaExPRC9oaDNzS1I3ZC9MNnY3?=
 =?utf-8?B?ZmFGa0pRYXFXVjJ0eWhkdFpHS2Vsdk1zMGlhdDZ0WDBGd0IwNks0SUJOOGpL?=
 =?utf-8?B?OVJOcE5rOVBXbXNuTlNCMUNqRld5N0JOQWpYVlBRTmN5RGpsQjlydG5VQzJm?=
 =?utf-8?B?cTVITUtONUdCSG1nN3plU1ZNWEVXN2E0QUxxZlQyVVNsYnBiOThPMzlpWDlI?=
 =?utf-8?B?dkVQK3JQVTQrYUpmK2NsZ2luZHQ4QzJrcCtrdkYvU2M3dUx3RW16djlmWk5K?=
 =?utf-8?B?UzNVaEFPY3NlWnY0WUh5Y1JZRzUwR0k1NlJvNmIvMEJGb2ExVEZ2VVY5NnNW?=
 =?utf-8?B?Y3hrdUVKbFRNWFdBS1NZSXNucGFrRnhMaElGaWZwS3pHb1d1RldtUGZYUkRi?=
 =?utf-8?B?S2wxRzBqUkMvTnFSeG1DWHNMSkVmNXdOUVMzaVdlelBNQ3JYQXRsRUttVW1I?=
 =?utf-8?B?Wk52M2hYSEZmV2VKNnNjazBCRENWZDBIK0lLT0w1a1RhZTlFT3VKclRoVzZs?=
 =?utf-8?B?M1VHakJNWDFYbE16c3NzcnZqMmlnOWY4bGVYbXIxcUJ3OHQ1bHFpcUNWbHlW?=
 =?utf-8?B?SFFXV3NFaVVSNnlZeklWMkc5dHM1M2R2d2xvMDlneE1SS3BlVzQ2eFVGUWZ0?=
 =?utf-8?B?cjJSZW1IMGJOSTdtajRpaHpHYzZvYWJ1WXFQMjdWelBHOGY3WUsvbVk2UEJM?=
 =?utf-8?B?L0ZhTjlkOEJ5dVVUZ2tkdklNRmNxZ3ozTHcwZ1hSSnBuZXVGSTNvSUszTUFP?=
 =?utf-8?B?bUV4REw3NTVQdjlOQTljUUlaZ2ZBNWsxYTJST2FybVQzaXR6T0lrV1EwTW91?=
 =?utf-8?B?amVkc29yV3hwSVZUWTRGV1pyT2ZETnNuaTFlYTFoZ3JSc0dsSXQ4UWE4Yi9F?=
 =?utf-8?B?KzBwY1BhWStzTlRCZ3Mwb1BWcklicmJJSExPMExBV0hIS3EvejBOOXpZWUQv?=
 =?utf-8?B?QnNFTUp3VitwcVovSWpTZUp1NXoxYnZob3d6SWVSMXoyMk1LSkZSK3lVdWR5?=
 =?utf-8?B?NTVBd3JudEJBVDJWNllXUHM2NFk2ejF4VjR2Q3hzZmdNdDk2NmZTZzdKaFlp?=
 =?utf-8?B?STlXWWo1bTdlRzVVL3o2b1RZRVEyZkU1TUZaaEdldXVnMlZNbmhIbXBxYTM5?=
 =?utf-8?B?LzRQMlBxM3NhWkNWbEI5bVU2dDNxWG9zVmRNNUFvMnV2K0lMbXo4bTJwcmQ2?=
 =?utf-8?B?OFVxU0ZMb0d2K2dJNFdkRlZHNWhCWjd4UEZpL3IzUStNKzJ0N3ZHNzMyQzNY?=
 =?utf-8?B?V3BCR2t2dHBwYWZVYTdMaktEcUorcDUrSldkMndJb1BiQm1EOVZ5dnVMa2JT?=
 =?utf-8?Q?7z0P+ZstuDTJR+ws/p32cpLvr4wQQI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODVTbWsxYUhNTFltRDBDNTl1SklrMTNJWGsvRS9UWSt6SUMwNjlHbE02N1RD?=
 =?utf-8?B?UGNrUXkrY2JHRGtoRXpVQ2VleXk4L2FKT3ZVeE0xNlpXMktrUTFUMkJOMG8y?=
 =?utf-8?B?T1RZSVNZdVFubFUvc2FtQXpGN3hXVEhpS1RKektGQlRPV3FiOUhyZ1RZUHNV?=
 =?utf-8?B?WVM5RjdVeW95TW1iaThmUWNSVVlQektoOFN0blpCS2EwSkZ2ZVY5bmd5WWdN?=
 =?utf-8?B?b1JuTHlIdzM1OWQ0M1ZRTExwQ2ljaUpyNmR0TWJsUWRMM3lxNm8zMVYrblRN?=
 =?utf-8?B?dzBvQU5kNEpucVJzUkkxa3VERlhXRHR6WDVneEo5VnBzWVAxY3llNW15endW?=
 =?utf-8?B?dGthZGt2enMwdDgrL09VYTF6elhsWEFScVBXM3BZaFEzRnNMaFp3OWRkRy9L?=
 =?utf-8?B?cEN6MUlxMXcvdlNJUnNONGJkTEs2MGFYY2kvSGsrZjZveEg5dzlRTXVNZi94?=
 =?utf-8?B?bk1oYmVpVEMvVm5md3loYmdmVUJaUkw0eWQybFNZY3Q1cDIweFM0S1BwNzhz?=
 =?utf-8?B?U1BYcWRYb1pld2pFTkRvSzlYdTdEOUNQQ0ovc0Z0blBqaVpZNk04VThSQUtw?=
 =?utf-8?B?Tis3cTJiajJCbXVVYUd4emtRcTJ4aUJFcjhRWUx4Qkl6eXRKTzJRZjFKV25i?=
 =?utf-8?B?azh0MWxNWXVuWHFJUmRBSWV0a3NIc2k1Qmlhayt1VGtyWFZpcFBMWXJ6eXRQ?=
 =?utf-8?B?V1RCQW1wWEFQL0JqbUI4aVpha3hzU0NBSGVmeWVrOXBkbjhscHFzM01zemU3?=
 =?utf-8?B?MWVJUGY5cDJiRXlYd3pmRDZ3VHNYMnpTS05tZlBDOE42UjM2cXhaYWFzUnlj?=
 =?utf-8?B?aHFYbmdzd1FlS25NelBkUllQVVQzVktCVm01eXdKMW8rekxaVSt2ZzJ6U05W?=
 =?utf-8?B?cStUNTJ1VDRpNm5jcXVFai82blVYdVdydDN3Y2pEOEkyT1lRdjdVTncrSTF6?=
 =?utf-8?B?anZWaUpFM0d1Ym1IQmgydWhFSFN0YkZyWmg0ditSQ0lHNDRmSHowYWVqUVhD?=
 =?utf-8?B?Z0lyMlR5NVVsNytkQkp6QndWT2Mxa0lYcllocFBCU0FvWnRlQjBTN2RaZ3JX?=
 =?utf-8?B?Q2dmMmR6NlVIYmcrVU1RcWZLbmZVK3VkRjFmWVRvZjRWUlNnTWpRbEhNRTN3?=
 =?utf-8?B?T2FxcVVSSXhVQUVncitHWkNBUmJmU3JBMW5sQ09idDNvZzRma0s0ODJMRXFD?=
 =?utf-8?B?ejB3a0w1THltSlBsNlNSckJNKzAzMHZ3QWdJZTlBL1NoaGR1NWZmRXdXdE9z?=
 =?utf-8?B?KzhicFNESzhQS1RPR1M4b0E3M2pqSFJBVTIyRUJaK3RPbnNXR0lYZHFkaEFz?=
 =?utf-8?B?TU1OYU9GVjh1Q3dtYnRuMk8xcnhOY2RtbTRTemdVVDVRMlJSdDBDcVV3UjZx?=
 =?utf-8?B?WEE0K09sM1hyU096MXB2M0JuODNwdlpOZG1wOC8yRDVMMmZydm5XNURROFh2?=
 =?utf-8?B?SGtaRkoxUk1GQW5mMVpyNGhNTXRhTEU0VGttY1A2UnhXdGpTYVZjZjhQMTdD?=
 =?utf-8?B?VTR1a0FsZlJ6ODdqdncyYUsrb3hydUNGbmRKdFpEK2NXeWM2dUhZUHNvOEd5?=
 =?utf-8?B?SzMybkRtOXgycUJTK2FhYk5qNGREZGhzcU5GSDRieVR3T3NYa1lRTFdwVmpy?=
 =?utf-8?B?bVhaRy9CWXQvZ3NCVHpDcXpvQzNZQVBFL3VwOExPRGhnUVdyZjdGaElKVGl6?=
 =?utf-8?B?aTFOR0Qxd01JTVBCM0tIUW9OZkhwbDhWNjBVTXBSWXd6TDZrdVMxZFprZVpC?=
 =?utf-8?B?YnNYWHNYTWdnWXRsTVVTMnZySkt4Q3FjOFFBWmlmcUx4Y3lPSTVYbE5UQXVD?=
 =?utf-8?B?UmRCRms1b2ZDVlkwcXFXU0FhZHhCTTkrRER3SjByb3FQNVJibXlTTmszZXZB?=
 =?utf-8?B?TUR6V21hRm8vVzRWYU8yN1FnZUtjb0JOMzFqVEsxT2pjRWRqVHpmaThaNSs3?=
 =?utf-8?B?djcxVW9qSHZrZWJ6NGV2OVN0TTdoZE5MZVFOTDJMeEY5Mk1xN2hLTStDZlRB?=
 =?utf-8?B?a01QODZubGNuVndKZHlKRk5WRXIxRGJFREtNc1Zkci82SzJWdnVwdWFDSU5j?=
 =?utf-8?B?UFdUTEQ0QlRnRndwcVlxS296M2c5dnBTSStXSWpremsrSDJQNEd5bEhQd2k2?=
 =?utf-8?B?d0N3UCtLVHZ4WFFEeUNJa216NDZCUWgzZVQrQXBCOVZvbjhFMkxURzVub3gv?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <060CA0D56D0269498A392BC39AC402B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510bf0df-4756-41b5-dd6c-08dd9d3a45fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 16:19:36.3908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wcfhyiEIP1H20mX1ezPkkplX18B2RufoOYZ1m2i6zGfa5uw+EQpv/FuK97Nccs9UPPQG02s7fVK/ChE/XET0PKGFrAABDbB73bhgRMXPdm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6991
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTI3IGF0IDEzOjU0ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGUgInN0YW5kYXJkIiBrZXJuZWwgd2F5IG9mIGhhbmRsaW5nIHRoaXMgaXQgdG8g
bWFyayB0aGUgb2ZmZW5kaW5nIGhlbHBlcg0KPiBfX2Fsd2F5c19pbmxpbmUsIGkuZS4gdGFnIHRk
eF90ZHZwcl9wYSgpIF9fYWx3YXlzX2lubGluZS4NCj4gDQoNCkl0IGxvb2tzIGxpa2UgX19mbGF0
dGVuIHdhcyBhZGRlZCBhZnRlciBhIHZlcnkgc2ltaWxhciBzaXR1YXRpb246DQpodHRwczovL2xv
cmUua2VybmVsLm9yZy9sa21sL0NBSzhQM2EyWldmTmVYS1NtOEtfU1VoaHdrb3IxN2pGbzN4QXBM
WGp6ZlBxWDBlVURVQUBtYWlsLmdtYWlsLmNvbS8jdA0KDQpTaW5jZSBmbGF0dGVuIGdpdmVzIHRo
ZSBpbmxpbmUgZGVjaXNpb24gdG8gdGhlIGNhbGxlciBpbnN0ZWFkIG9mIHRoZSBjYWxsZWUsDQpj
bGFuZyBjb3VsZCBoYXZlIHRoZSBvcHRpb24gdG8ga2VlcCBhIG5vbi1pbmxpbmUgdmVyc2lvbiBv
ZiB0ZHhfdGR2cHJfcGEoKSBmb3INCndoYXRldmVyIHJlYXNvbmluZyBpdCBoYXMuIFRoZSBub24t
c3RhbmRhcmQgYmVoYXZpb3IgYXJvdW5kIHJlY3Vyc2l2ZSBpbmxpbmluZw0KaXMgdW5mb3J0dW5h
dGUsIGJ1dCB3ZSBkb24ndCBuZWVkIGl0IGhlcmUuDQoNClRoZSBkb3duc2lkZSBpcyB0aGF0IHdl
IHdvdWxkIG5vdCBsZWFybiBpZiBzb21lIGNvZGUgY2hhbmdlZCBpbiBwYWdlX3RvX3BoeXMoKQ0K
YW5kIHdlIGVuZGVkIHVwIHB1bGxpbmcgaW4gc29tZSBiaWcgcGllY2Ugb2YgY29kZSBmb3IgdGhl
IHJlY3Vyc2l2ZSBiZWhhdmlvci4NCg0KT3ZlcmFsbCBJIGxpa2UgdGhlIGZsYXR0ZW4gdmVyc2lv
biwgYnV0IHRoaXMgd29ya3MgdG9vOg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQppbmRleCA1Njk5ZGZlNTAw
ZDkuLjM3MWI0NDIzYTYzOSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
Yw0KKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQpAQCAtMTUwMSw3ICsxNTAxLDcg
QEAgc3RhdGljIGlubGluZSB1NjQgdGR4X3Rkcl9wYShzdHJ1Y3QgdGR4X3RkICp0ZCkNCiAgICAg
ICAgcmV0dXJuIHBhZ2VfdG9fcGh5cyh0ZC0+dGRyX3BhZ2UpOw0KIH0NCiANCi1zdGF0aWMgaW5s
aW5lIHU2NCB0ZHhfdGR2cHJfcGEoc3RydWN0IHRkeF92cCAqdGQpDQorc3RhdGljIF9fYWx3YXlz
X2lubGluZSB1NjQgdGR4X3RkdnByX3BhKHN0cnVjdCB0ZHhfdnAgKnRkKQ0KIHsNCiAgICAgICAg
cmV0dXJuIHBhZ2VfdG9fcGh5cyh0ZC0+dGR2cHJfcGFnZSk7DQogfQ0KDQoNCj4gwqAgRGl0dG8g
Zm9yIHRkeF90ZHJfcGEoKS4NCj4gRXNwZWNpYWxseSBzaW5jZSB0aGV5J3JlIGFscmVhZHkgImlu
bGluZSIuDQoNCkkgZG9uJ3Qgc2VlIHdoeSB0ZHhfdGRyX3BhKCkgaXMgcmVxdWlyZWQgdG8gYmUg
aW5saW5lZC4gV2h5IGZvcmNlIHRoZSBjb21waWxlcj8NCg==

