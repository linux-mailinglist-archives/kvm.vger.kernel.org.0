Return-Path: <kvm+bounces-30497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA269BB2B4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 12:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CAC4281D57
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D5E1BA89B;
	Mon,  4 Nov 2024 10:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VLkCpib7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D401A1B392D;
	Mon,  4 Nov 2024 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730717947; cv=fail; b=ChgKImfbkaweslJcjqnpEeiggiKewFoNcenVjoXH/yCWJaNibrIm4DSxC0yoPaNMFmGcxWnvjoOZCUjKmhMjdGkqOVMKYciFkaCzOAb8PEsizjbmqwlXMAaZKB916GowkH1yIgNvKkv59WLMefXr5WZTdN4HbgtEjgk04Ib09fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730717947; c=relaxed/simple;
	bh=CZHvFby1NJdukTA69hmS2JZVsBSTqtryhG7beiTSQg8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ixaZbcXXgFRoCb0xHSW3Ha/PPbxbelbnoXKFr+son2lhvIZqAMtxGhWSkytKqIPzk2o1Ljli7yXNFz7Qzf1uLAGZXDn+RuN5MwvYOFkq4irzdWe5kuhLuKb/3d4vPplVJdmMjDRbCa4IZJ5zpsTEhfaQwP9Q8N0XWtsZwyJ/nGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VLkCpib7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730717946; x=1762253946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CZHvFby1NJdukTA69hmS2JZVsBSTqtryhG7beiTSQg8=;
  b=VLkCpib7rMz93VPTjNh8XMOnm5DVVVXbHN4KdaMEvPaBRCGDsVynSC+o
   UJDgg2FQoiXLvzfgxw9WAqECwmqR2UyURgFF3ylYbsTJ+VnS905HxcidO
   TCKMNRZHFruh40SWMbtgdVbJmfaJNHAFlVP3qXqzzl3lWabZBqVpKhhBO
   Bopq1/033sLiucS3LrliaYGpm3u/LHUnqPTUXOkQNd64JkfgQmktX/cKF
   PUoU2nOnjQ2wJn2cjpFh4shot0hEJGuY73IVTpJR2Mc2v/Q1dJ1tfb8gX
   aj6eO2rzsSpNRBtZyklRR/K3fnBGiZntKR7op9J3UcXGvT+3E+AFoqSCp
   g==;
X-CSE-ConnectionGUID: G9vcOuvfSQWf4VXowmLp5w==
X-CSE-MsgGUID: rz/tI+IAQ7mz/BLbQMG94g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30585277"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30585277"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 02:59:06 -0800
X-CSE-ConnectionGUID: rKdnmWCAT1ylbt15uzzyQw==
X-CSE-MsgGUID: UPu3KIgeRuOEqIA8ut/eFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="114405359"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 02:59:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 02:59:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 02:59:05 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 02:59:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AYsj53yWXXnbfVlkYBP1tPTelBnQGqZs2VVZdYbEV5hKK8qLB8pNwuLwxkVgAIxJP4V99mBdhmIJxbRMttLvnCJOI++N28hm+/7HyOhnbuflHo7+ZX44CdzjuaSDs8AoJLKiQtAq4Kdo1kMZPzQUAPG8PESt5QdqdR4jXi83rhU7GtwjUsaZpW6n+XcwvxOhXhFJYwwGZZuNaeGXX+YXGoTiiMyF1Jq2JUhaxAwG+g3VYOs41wprrUrqq+IWbaxFdjsLXFTkB7Aa1DRciT5e3zor0/LlEoP8bctPYNDSWga7gDaBIknxlP8wlZyqBJVWhl/fLg/Xex84sRGNYQVGOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZHvFby1NJdukTA69hmS2JZVsBSTqtryhG7beiTSQg8=;
 b=AfaHVqe1a/UiDQ/t3YRci5TLWXRxNdVY9ThIG6vGHGQGFLliJC9ThwvPgF5KCDEqEwXhy731nymK8rcEYKQyhac1hV7ver0ehqfqJq3sdzQyLip2GCLFh20IZeJNqYHuc7+Ad9AkiQbqIfyk5/Hjht9LTFWoBW7ZrY2RA3bK9PcoNO8euOi+gAQnFbpxJVhRJht41VFo0e1nvPS5R4xlHUAx8Qglv00lHW7jQCFXjF+4+kOFUaEBV+mKutMI/OysxSh2dcDfHu7R1FtODMTDTf+6J6HRWwemBKbnSvdKsATwFdzTp70MZ1i5qJ07U7BhZKwIyKBJOoIJUxEKyAe6rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4610.namprd11.prod.outlook.com (2603:10b6:5:2ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Mon, 4 Nov
 2024 10:59:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 10:59:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 9/9] KVM: x86: Short-circuit all of kvm_apic_set_base()
 if MSR value is unchanged
Thread-Topic: [PATCH v2 9/9] KVM: x86: Short-circuit all of
 kvm_apic_set_base() if MSR value is unchanged
Thread-Index: AQHbLIz6CLwV6m8H8kK14eedJ+4EVLKm+AAA
Date: Mon, 4 Nov 2024 10:59:02 +0000
Message-ID: <004816c9b56ac5b9a56592578caa3a5941045788.camel@intel.com>
References: <20241101183555.1794700-1-seanjc@google.com>
	 <20241101183555.1794700-10-seanjc@google.com>
In-Reply-To: <20241101183555.1794700-10-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4610:EE_
x-ms-office365-filtering-correlation-id: 04fa213b-9e75-416d-971b-08dcfcbfb180
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Rk1jRFBRaFlpaDJXT01JbGJKZmZvRGgrTzh4aitUUENTbzlDNkRJOER2RTQ4?=
 =?utf-8?B?ZkVrdURCd2VtMWJ5MkxBNHhsbWdacXdSWlErRExQVlVybUdZSUZlSXloeTdP?=
 =?utf-8?B?TTVyTEZIWEk3SnJIYy9pZFV3WXN2QzJCZzk4akFidGhHbU8vWXpyMXJYejZN?=
 =?utf-8?B?ZmxyaVNRS2FOYkJQV2t2ZDJuWEJ4OVMvb0RRZEZHNXNjeTNkSnoxVnlCVlFO?=
 =?utf-8?B?c2ZwWjcwa09rV0N0VUFOREhBcGF0K3VSSkI0WGZ2R25YYXg3dU5WVlM1VzVW?=
 =?utf-8?B?YURaSEpBbXpJTkR3UWVrcGdYSnlZY2lidHBPZ1liU1BEZDNodElJTUpkSHJI?=
 =?utf-8?B?QTQyOGlOVWdadGppWTcvWEFNQW5iZHowRERUdkd3aDJTOHdkS2ZkUE51RGpE?=
 =?utf-8?B?N1BZSTFyb3QzOXI1T0x2K3I3ODZ5NEwyeUdJV1ovSGpabE16N2lJZW12eXJn?=
 =?utf-8?B?Ym1UR2VNU2dhbCtnZU1wZGRBc1I4ZFUxV1p2RTlUbkJDZlp5K0JTck9hOGlI?=
 =?utf-8?B?dXJGR1o4YlErSDRJR3ptMWxVTS9McmIveDZqNDM3MzJPRnhIRjBveEhsSkNG?=
 =?utf-8?B?WU9QY0UyZXBSRDk1UUhpWGkwOXV2cDJxTXpnUFk0VmdiZm1wNTQrZmVBQS9n?=
 =?utf-8?B?QlRGVnJsbEUvVnpVMW5DY1RjdkZQc0V1ajdMRnNBVDJKeEl1NHlZRFdFMFF6?=
 =?utf-8?B?K3RQeEhjWUJ5YlVIN2pQRXZWWFJsV1EzSHVsN2l4RUhFUlFZRnhKREhKS1Vq?=
 =?utf-8?B?NXRCWDVTSU9VamlkUjBPWFdhNkNTQ0NvR3NyMHdBT2dEalBpNnZwMGkxUjlz?=
 =?utf-8?B?K0dQS3VzTkpVVVdIVDVPbWZiUjVIOU5taFBpS1hNTEZZRzd1OEZlaE94SFBt?=
 =?utf-8?B?WmxLZ1dHZmVYWGFkb1hsaEtnb0N1UWRJWnE5aS92bnAxWDVqRmdLaVJrOVpr?=
 =?utf-8?B?OGdGd1RZVHFieHptRDdWcVlPVTR1eVhsQUxDZTlKOWdVa2I2enZzdGdBL3FQ?=
 =?utf-8?B?QnQrTmVyZHYwRlhMVXEraGlKZktVcHRFdTZYRFRQT1JwTS8rOUFSQ0dsQyto?=
 =?utf-8?B?NHRxbVpPVTRMdUVTRll0QmxDNmQ0bFJwMmhWYUJTWFV4bzhrbFNQK1pJOWkv?=
 =?utf-8?B?UlJqQXFTSVVMbXp0UUR0bFJMeThwZmIrTVljYjhVczd6RlhpeERzT1FSRnFt?=
 =?utf-8?B?RVBOZm5tbXhhZy9mT3FVcVNoS2tzdzRpaWN2ZkRVeitPWnJML0I3eGloWWI2?=
 =?utf-8?B?Yzlxa1V2d1VpcDMzZk10NnNwVmVlRUhpdTFBU1NoeEtPZFhLUWdUdXdpcFNk?=
 =?utf-8?B?QU1JMkV1S2psUHB4UW9saDRQM0YxcmQvTUExU2hDWk41SzlHUXA3WENjbFAy?=
 =?utf-8?B?UUpOZmhBMGo0MWdBeTJqQ1RRbXR3WitNSEhmTEo0eDJrVHR6a01FZk9XUlJj?=
 =?utf-8?B?Sk1ydW80UEFzMU9yR3NsNHhkNjdKcGx2bXlmUVRidEhBaUNucDhjQjBxTjZL?=
 =?utf-8?B?dWI4TUpKZjBjejFHZXVlM3Jia1pibmJLcWtYWjRrQ0Q5ZE43UFYrUXZUd0Mr?=
 =?utf-8?B?L0Nqc3FoZFVsK2JXa2JpOUhVd3p6ZXM5ald4Uk9UVVlYR2dySURhd21QRUU3?=
 =?utf-8?B?MlUxNHoySjluSi9kSW5JVVEyMjBFTDFRUVJqd1JBM3hYeElBU3BOeUhvWlFI?=
 =?utf-8?B?cE5PNlUzN1hBUnBiNjFVcXorVGFjYzVvV2NlQnptMGdTOHZyeU1jVEdhNWdr?=
 =?utf-8?B?cm1UVTdoNkxScERFam9pODlpenFhOVdRK3JMK1ZBS1BiTmdSQVlscDZSb3oy?=
 =?utf-8?Q?fBRC7uGeUm80de4+Mc4kCbV8QMSrMCR5kD4z8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzZDT1FCdmhOSVV1Q1RTZUpNdVNpRzBxV3ZEVFc2YUsvRDRzVjdZNDV5Mng3?=
 =?utf-8?B?RlcxWUZGV3djaGVFeGFCQkpNM2JxWmhRbjk1eUxzc1VOK0h0aGtGMklNcDM2?=
 =?utf-8?B?UXRkRXMydit2MjJCTW1kbkpvRmZ3bGFJMGs1RDJWaTA2dGJkS212MmZJWEd6?=
 =?utf-8?B?endHUDJiMEd6SEZadzVVUmlsNi84dDJZUHBNeTdkOHpUazRDQnZ5VmprenR1?=
 =?utf-8?B?NFp5RnludkEzcXFnc1c4OU10RjgwYldjakpkcTc2dVZhblFxVWxZQ3B2OERl?=
 =?utf-8?B?Qis0SS9yYkZXOGZEN3ExQTlVK0lnMFhDT0dXOU5nRjZyb3Zad1gvanRNT2NM?=
 =?utf-8?B?dXByOEUrYlNET3JOQzdqOVNPUkRCODcveVc5bUM4clVZcXNKcUFaTVpKemFh?=
 =?utf-8?B?cE9UWWZDdFMraHVOdW5IckxUMFExa3hHb3RmWnJGU2owWWNkK0MycytBSXQ4?=
 =?utf-8?B?am9sTldEczY2aEFweDU4YXFGZnEwK3lmVHkzeWwyd3k3cE9XWmR5MkFUc0M1?=
 =?utf-8?B?QnBteVJwb1NwMEI2RFl0RUZ3MzJIOW1MNmZlMlhtSW1aUjNwK3kzaTU1b29J?=
 =?utf-8?B?WGk4REs5OS9tMkJHTDBnUHM1NEJ4MDJkK2pWWldDZi8rMFM0MHo0S3dLNmxE?=
 =?utf-8?B?VVV5YmIwSXI3VGEwdnBnVDZiejdTSSswZVJ5Y2k4VWphcHlUUENITDZmUGJ2?=
 =?utf-8?B?aUN1SFBEYmlSL1VSVlM2TnhvbnZVK1pWL0JOS1VrUlRGOXMyVXorNUVQVy9F?=
 =?utf-8?B?cjQwT1c2TTVHakl2VXBHVEFEaXVZcWFoMUlvTXlxZkR1NFhYSENtMWZPa3Mz?=
 =?utf-8?B?NGl5T3A0cDNHSTZLQXBETnBjOFUzZ20yYi9xaW5wU2hrVkxPNDd5T3ZwRlUz?=
 =?utf-8?B?ZUl4NndzN1B4UEl3UkVTRU03ZURta0NUd0xpM1pQWkNPRmN4TjMvVldNblFR?=
 =?utf-8?B?WUZVWDV6N1BkTXo4VHlYQnN6WDFaY28vNWw5M0VTTnYzbHlUQXNya1ArMTdM?=
 =?utf-8?B?SkpqSk55L0FMYUlxam5NU3hibHg1OEM2YzZoN29ZSnFrSTFKYVZuTzhHL3A5?=
 =?utf-8?B?R2ZvMmxPQ2g4c09VZTBDdEcrY09hWUcyRTJkTkZ3QUtlZXcrUy9remlLUUFT?=
 =?utf-8?B?cWJHWlU4dk9ZSS80c1VEOGFhdEZPZ2lsdDRLY1RUQldsZ1kwR212MGR4MmQ4?=
 =?utf-8?B?SWVxSEZTNzY0QUdYWWVBTEtNSVVDZXEybDJOdGtYQWtPSVpmd1RJbkl4L28x?=
 =?utf-8?B?cUQ3VkZjN0gxRkRNWC9OZjdhN1U3cGdjQmxsa3R4RWl1blpubVJrSzVxM0tF?=
 =?utf-8?B?dWZEM2JiSmRMM3pSY0I1VENBL3RFK2MvUFRzUlZpMHpFeTVIU1Yybkp2YmhH?=
 =?utf-8?B?eUR3QXM4a1AvMEZaNEdDb3BXVHFLcS9GYzA3NkRCZm5VS1A5VlRiUGp5bGxz?=
 =?utf-8?B?M29jRG9qVEtrY3FlWHFpdUFCQkZyRXNnT0hxVS9aTTZnbVh5ZnZSY2d1czEz?=
 =?utf-8?B?QTdyVnkrcm9wc3VYU0RpRHVBMGV3RXJEVUNaL1hkdXpxNUtFZ1E0SjFNN0dO?=
 =?utf-8?B?NkhwQWdpbTdQVlZueWVBa1NKQWVmejRSa09OdVdKM0tObHpnTVNsSnBHckFs?=
 =?utf-8?B?c3BOL1BYay9yUUVLSTJtSjNjZ290R3lkVWRrVHJ2YTZDVTFNWE1SVzJUbmVP?=
 =?utf-8?B?YncvL29OWlA5QWYvMzJuUzJiYnV4SDd4OU5VU29tem94TnpNY1VZYWZ0OVMv?=
 =?utf-8?B?UXcwNDN2S1A2ZlphMktsbmdpRFNUdmNZdWllMkVxczVSa0xOTWIxTWZRQUVn?=
 =?utf-8?B?MnNnNStnM05oTFRQRHJIdzFJeEtKQlVlejlBTHIxQkp6MWh3b1Fmam1LZGhw?=
 =?utf-8?B?b0hERG5vbGJ1THN5WVFpek9PcXBsMGZ3MEJ3dlR2Q2NtaFgvTkpoaFJvNlN4?=
 =?utf-8?B?OEhtbXZsa3Z3YkhmSFJWVWlvekE0Y3NZUlY3bXdHTzVXVlNwMnI2MGJJb05z?=
 =?utf-8?B?U2hoVVBaUkFZRHhNWUJYcXkvMXZ3dE5CeHlpdUJzakJ3dU1WYXo0U3JBWnN4?=
 =?utf-8?B?amZES0Q0Wm5jY2JtOXNZNjRJaVFmclBMcVlwNzlBZC84eFczdW8raThUU2VC?=
 =?utf-8?Q?No8x3E5FzdnOTCZIZsikisCYx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4236F782E7F194B8D61120165AA96C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fa213b-9e75-416d-971b-08dcfcbfb180
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 10:59:02.6492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sb4EWd0Bi4VJc0DaO9RDq8KxOsM4F3oYdoSiGHYVP3RyF3v6Q2USpNgRbWZxyHg/B/Zm72RYkUpBkANsjVM1jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4610
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTAxIGF0IDExOjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEbyBub3RoaW5nIGluIGZyb20ga3ZtX2FwaWNfc2V0X2Jhc2UoKSBpZiB0aGUgaW5j
b21pbmcgTVNSIHZhbHVlIGlzIHRoZQ0KPiBzYW1lIGFzIHRoZSBjdXJyZW50IHZhbHVlLCBhcyB2
YWxpZGF0aW5nIHRoZSBtb2RlIHRyYW5zaXRpb25zIGlzIG9idmlvdXNseQ0KPiB1bm5lY2Vzc2Fy
eSwgYW5kIHJlamVjdGluZyB0aGUgd3JpdGUgaXMgcG9pbnRsZXNzIGlmIHRoZSB2Q1BVIGFscmVh
ZHkgaGFzDQo+IGFuIGludmFsaWQgdmFsdWUsIGUuZy4gaWYgdXNlcnNwYWNlIGlzIGRvaW5nIHdl
aXJkIHRoaW5ncyBhbmQgbW9kaWZpZWQNCj4gZ3Vlc3QgQ1BVSUQgYWZ0ZXIgc2V0dGluZyBNU1Jf
SUEzMl9BUElDQkFTRS4NCj4gDQo+IEJhaWxpbmcgZWFybHkgYXZvaWRzIGt2bV9yZWNhbGN1bGF0
ZV9hcGljX21hcCgpJ3Mgc2xvdyBwYXRoIGluIHRoZSByYXJlDQo+IHNjZW5hcmlvIHdoZXJlIHRo
ZSBtYXAgaXMgRElSVFkgZHVlIHRvIHNvbWUgb3RoZXIgdkNQVSBkaXJ0eWluZyB0aGUgbWFwLA0K
PiBpbiB3aGljaCBjYXNlIGl0J3MgdGhlIG90aGVyIHZDUFUvdGFzaydzIHJlc3BvbnNpYmlsaXR5
IHRvIHJlY2FsY3VsYXRlIHRoZQ0KPiBtYXAuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0v
bGFwaWMuYyB8IDcgKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBi
L2FyY2gveDg2L2t2bS9sYXBpYy5jDQo+IGluZGV4IDdiMjM0MmU0MGU0ZS4uNTlhNjRiNzAzYWFk
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiArKysgYi9hcmNoL3g4Ni9r
dm0vbGFwaWMuYw0KPiBAQCAtMjU4Miw5ICsyNTgyLDYgQEAgc3RhdGljIHZvaWQgX19rdm1fYXBp
Y19zZXRfYmFzZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB2YWx1ZSkNCj4gIAl1NjQgb2xk
X3ZhbHVlID0gdmNwdS0+YXJjaC5hcGljX2Jhc2U7DQo+ICAJc3RydWN0IGt2bV9sYXBpYyAqYXBp
YyA9IHZjcHUtPmFyY2guYXBpYzsNCj4gIA0KPiAtCWlmIChvbGRfdmFsdWUgPT0gdmFsdWUpDQo+
IC0JCXJldHVybjsNCj4gLQ0KDQpDb3VsZCB5b3UgY2xhcmlmeSB3aHkgdGhpcyBpcyByZW1vdmVk
PyAgQUZBSUNUIGt2bV9sYXBpY19yZXNldCgpIHN0aWxsIGNhbGxzDQpkaXJlY3RseS4NCg0KPiAg
CXZjcHUtPmFyY2guYXBpY19iYXNlID0gdmFsdWU7DQo+ICANCj4gIAlpZiAoKG9sZF92YWx1ZSBe
IHZhbHVlKSAmIE1TUl9JQTMyX0FQSUNCQVNFX0VOQUJMRSkNCj4gQEAgLTI2MzIsNiArMjYyOSwx
MCBAQCBpbnQga3ZtX2FwaWNfc2V0X2Jhc2Uoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdmFs
dWUsIGJvb2wgaG9zdF9pbml0aWF0ZWQpDQo+ICB7DQo+ICAJZW51bSBsYXBpY19tb2RlIG9sZF9t
b2RlID0ga3ZtX2dldF9hcGljX21vZGUodmNwdSk7DQo+ICAJZW51bSBsYXBpY19tb2RlIG5ld19t
b2RlID0ga3ZtX2FwaWNfbW9kZSh2YWx1ZSk7DQo+ICsNCj4gKwlpZiAodmNwdS0+YXJjaC5hcGlj
X2Jhc2UgPT0gdmFsdWUpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICAJdTY0IHJlc2VydmVkX2Jp
dHMgPSBrdm1fdmNwdV9yZXNlcnZlZF9ncGFfYml0c19yYXcodmNwdSkgfCAweDJmZiB8DQo+ICAJ
CShndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfWDJBUElDKSA/IDAgOiBYMkFQSUNf
RU5BQkxFKTsNCj4gIA0KPiAtLSANCj4gMi40Ny4wLjE2My5nMTIyNmY2ZDhmYS1nb29nDQo+IA0K
DQo=

