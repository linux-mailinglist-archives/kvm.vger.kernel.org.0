Return-Path: <kvm+bounces-18348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC4C8D4180
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEE701F22DDC
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 22:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BFF1CB327;
	Wed, 29 May 2024 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDlAB9JR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717381C9EDF;
	Wed, 29 May 2024 22:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717022724; cv=fail; b=pn+EWaA9bV7GXJe54+8IsgBOQRTRWX7qZdvhHZEBqK+qRyMj+VVgeteoypJnaKX8GnJ6Voothi4o+Kl6GPEQvrvL1MIDqAbjulXWmaKx7eYV0AADMQFKfWBHYqksZj1AvIwAjIyf6/SEhrfiTcXZyw7l0TKzDbvNYvp7/LEU8/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717022724; c=relaxed/simple;
	bh=sYLHcZFWtkUpMYiBWTD1BguyVQsXN1hlt7ULW7sJXt4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D+b40Y82EgatnabT8ekGI278FozAAgZVXlvPZlOMvQhIKbSA0cJ6rlBk6NKsou7ZcJ5wCn4CsZhRK0n9G7ZVoDYJK7qdk8iGV/o5YxBlIqGY4g4gAVNepmowpaotsOPJE0yzcQDFPBRQb9VLy/HKa4rXaXhQISOWKBWjP5x4cYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDlAB9JR; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717022722; x=1748558722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sYLHcZFWtkUpMYiBWTD1BguyVQsXN1hlt7ULW7sJXt4=;
  b=IDlAB9JRZW7V+cL/Sg4VPbKdFWI1IYcBthZw38ztbIhysL8BzFiBViah
   Ik0U3j/BOseJhtqyDRlNELa7zG1MYOjISD3Gjzmq3FBqNcIrWIdFG0OSj
   fIQRDOd6GWRpjTZNuGGvksfS7Oc1OrNgi6xHNpLm4Ib1vllpsOJuWgmSo
   OfIB8jtdtnCQUl8sc3WpLLyibqLngqXYCAJ3SqdUhDWNnyFgSO2OF7Qc0
   SJ4gh774F2kuWuGn7Ei0hs8rels7BTmMStXt7lL1+vqmppFE7rjZ3Kx4y
   OkBEux25OgLnzlX+n6U7JBDzkeygGvrspVP/8YEisRcLuGOM7U2xqM0Dr
   w==;
X-CSE-ConnectionGUID: 1OkADx/WTa6xrsUO2/xzNQ==
X-CSE-MsgGUID: DyapKz9PRnadU+Vp8OplCA==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="24877072"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="24877072"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 15:45:21 -0700
X-CSE-ConnectionGUID: 9lXlcHmDRHC8cB7+eWu/Cg==
X-CSE-MsgGUID: KtMDnogVS1uWkG3mJwqBwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="35671088"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 15:45:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 15:45:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 15:45:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 15:45:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 15:45:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjAAJEPerTR+wATZQjcHzo0YY5/i3GE0j6rm/7jMsGtaYUPx7HIZSjZVvfs+QbIgrLJDgDSo4Zw3jLY1gdLvkQnSUHRs9NTLOJN7Hbeym4oWF191xy/Cf9FbjVh1YBchvKO0bVYosyld03bcVBxO8wR/9mbKj6VRm5dAR3w3lhef4uyCgg+QbPvnXp6r4C5V5wprMxIVCZG3EM+S2ztJBSOyBnIV8AX9PtyJbdE++Rj/+ecpwxtnrbdhXMNQVXoHZT+Lb4CdD36T1kz/g0HDgt9WHNoV2dqEdCW4BHnj2HuixjrQSncqwJ2ZdwJZRnqMmPaActujzus8tsENLNevGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYLHcZFWtkUpMYiBWTD1BguyVQsXN1hlt7ULW7sJXt4=;
 b=NmkrCcOiwMBKSjrRWjslF8j4nFROy0Wc3oxKHbSd7K2WljvNW2TZtfsaXELtwdbkNqZHIjd2+6GK1R9a4vAv6zy6hU+mP7k23ksatADVpxE/R0khOnkUQe3axzBVPj1pB3uTSi8EtWEOtpEOeXfuI+RPQLlN9JXv4z5KVJjrNqLNwlHZADrREcg4fV2CkkA2VcX6LQg3VulB23ZJpcfwNzVg4j3HJHMdJUe14wbYQuOuCbQnQhHz6+U2bGr0Uwidiqy4Y2bC8aSZqyhMWojvuT5RzZYnYeSS5HvoDcBHSTxYuI9wqYMcWW0D4MALSG0l2LddB23J2NrGBY4NPE/mFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7017.namprd11.prod.outlook.com (2603:10b6:806:2ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 22:45:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 22:45:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Topic: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Index: AQHaq+/EabXqSDrB20SW6NZi8wYleLGj1rKAgABjVICAATs5gIAAOfIAgAYFfoCAAqWmgIAAgYYA
Date: Wed, 29 May 2024 22:45:17 +0000
Message-ID: <291ecb3e791606c3437fc415343eb4a25e531cc3.camel@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
	 <20240522022827.1690416-4-seanjc@google.com>
	 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
	 <Zk7Eu0WS0j6/mmZT@chao-email>
	 <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com>
	 <Zk/9xMepBqAXEItK@chao-email>
	 <e39b652c-ba0e-4c54-971e-8df9a2a5d0be@intel.com>
	 <ZldDUUf_47T7HsAr@google.com>
In-Reply-To: <ZldDUUf_47T7HsAr@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7017:EE_
x-ms-office365-filtering-correlation-id: 96654c28-39e7-42a8-698f-08dc80310356
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VzB2Sk0vcEM5ZGE1dTllSUUrVUo1cDUxTnFHR0lKZVMxWGtNUVd1SDFKYk03?=
 =?utf-8?B?MFE5S2RkeXJRcSszaU9MWmxnc3l2bjRDVGtDZW5MWVdjem1OT25QYkdSeUdE?=
 =?utf-8?B?Y09aZDBuSWJDWkFRZzFjZk5xd0tjdFNRWWdNekdqOUVJUHcweThucmtkTGlq?=
 =?utf-8?B?TENNK0ZTOC9OSUtacDNmcXZYSWZvdVQvenJ2RUtXZDlTaEk2dGhxTTYyQnhL?=
 =?utf-8?B?SFcwM2swYXJTUmN5QzFyVFo5MGd3MWE0SkVIc2J0R0d5dytpaFcwcUIzWTFT?=
 =?utf-8?B?UFhxYnFMZUhxbHRlNHA2cUhwdUZRNTBLNlU4bzZuM0RDU2R6amtxSDl5Rml1?=
 =?utf-8?B?cHFKb2EvLzBiUWJhdHRlRnFiYk0vU0pWQmFRd05SLzhGa3hKd1FucXdQRzlt?=
 =?utf-8?B?dDl2OWFacU5YakNGaFpCb29QV1FoRUczMEdudnZ0Nzg2cUZXWDRHM05pTVZQ?=
 =?utf-8?B?YVUwYUR4ZGZJRDJsY2p6RGZRdkdpZXFzWmR3S2RFcUF4VFI3VCtLakpRcGFw?=
 =?utf-8?B?MjkraTJ0bU1VakJtbjdaRkVEK0U2aHBiY01nczlaVGJNZHRINlJrcGF6UExC?=
 =?utf-8?B?U1puRHVidGU4b1IvUDl1ak5aL0krWDByZDN4NUYvSEloQ0l3UUFHRFBIWDZa?=
 =?utf-8?B?MWtja00rektrbjRtYitFL2E3RDJUeXdtRkxWbExhTTVhWlFONUhhOEZ5d0t2?=
 =?utf-8?B?cmVpeFpkNkZUclowaDc3NzVnZWt1c0FTcjh0MzVzME52MHdqNFp1QWdEQ1Yy?=
 =?utf-8?B?UVNPTTFyOGRCLzFjV210Y0VQTzJUc2hMRDVCQTB5SVRqME5qU3oybUg4WFZj?=
 =?utf-8?B?VVM2Z01SUkQ1UmpXck1rdysybEdQVEhKQ0tCYlQrQm14NUo1TTY3OExzTnRR?=
 =?utf-8?B?NU42cWpzdm9kbUdpS3czamlJN0FLRTJEakdGYXBUeGRPajBiSjN2UEMxbll0?=
 =?utf-8?B?K2VTMkpvWlkwNC9KeVVIekw2eHB1eEV6VzRNanVkZVRrLzVrdE40MENHYWFF?=
 =?utf-8?B?c1RuZjY3MjhFeWVHSUttSjlTbVMxS2lYNDhYSEg3UXM2OHVCUWZIT2k5Qllh?=
 =?utf-8?B?SHVtcTVjdzd1MlRVVURSdFl6eTl0RHJ2dmpqb1pSWGVUSlFNZjNEbkJNZndj?=
 =?utf-8?B?Sk5sL2Yrc001N3NkVVhmNE9ZQzErVEFwSDhNUi95dHluMVpOWWEzaDcvMm0z?=
 =?utf-8?B?bkd3VWNtL285MDRqbzAvWVczTWNUa2RTZ21uQXk1VU1Rc3RkZDdqWFFRSmdZ?=
 =?utf-8?B?bWN1UjFGT3Q0a3FpYWZxajRnOW4xRnl6ODEvUDllU0lNekxybHIwSm55Ymo0?=
 =?utf-8?B?aVRITlR1YXI4Q1NDQjdLQWhySE5vR29nc01tOHRKaXRUVU9obDRhYkNlTWdQ?=
 =?utf-8?B?S2pFL3ZCSXpnY1B4eUpjVTMyQ3RhbFEyNmxBak1EL1NJOVVSbmNtY2s5U1pZ?=
 =?utf-8?B?VDd2Rk02WUR3VitxSEpLL24wV3ZYSUt4WFZEVjFTQjdHMWFzcEpLb1ZPY1BF?=
 =?utf-8?B?bkxtZlFYb3NHbEpKM0VLRUdWaUtyWGpKenBTS1lnOU9XYUU4Sys1VnRuUnZS?=
 =?utf-8?B?d2p2WWNaUkUwdkh3N1RoLzBMcW1uYWFnWDVPVEY1SlEzbC82RE81TUtjc2Qv?=
 =?utf-8?B?MytlanA2MGhBRWRTMHQ3QkVrTXV4L01MNElCYU1xMitXZ2JXVndRZUVpNWlC?=
 =?utf-8?B?dDhHU2JReWJ2TklXMU8wTlcveWMvZ2Jhcjd0UGZwUWtZQlRjb1ZuR2VBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzVyam9Lamx1L2lKRTdzako0cmoybFRpVlNyT3JuT3pDVWRrWEpZUlVLWUtP?=
 =?utf-8?B?ZU9zZVJuUGRiQnpRVVBDWHRHMnhJUG1QYlRCOTBxV3NBc2NuUndLdUpCcHNw?=
 =?utf-8?B?Y01ON1NoQ2RRampvbmpCZHkwdjVITk5hUXFGWnFFdy9IUUJWVERuKzMwR082?=
 =?utf-8?B?cUpMb2wxWUM1ditQMFFwaHo3OU5YdkZmM1ZLZXY3YlZldlNXL3VkYnUxMkNi?=
 =?utf-8?B?R1JUYXZXT3BsK01jMVRUN3dJczhkNlVxWklhUEE0VTg2ZWFhU1FmS3JxZzBz?=
 =?utf-8?B?N2pxRloycjVGTzVXN1oyWWVpNDkwdDROU3ZscTlFMzFtQ1RKOGZMWTB6Ulha?=
 =?utf-8?B?RFZHTGZCWkZJdTI0RGhiNXc4eCszQlh0RWhxdXRqRnVqcSsrSEpLeWl1U2pR?=
 =?utf-8?B?RVFQUWdsM2Vsa2Rvb3Z6VXE3TWkrdUxGeGRKM3pIcFdSaXRxK3ByTmR4cGI1?=
 =?utf-8?B?aUNBbklBU3NWNHB5ZS9rYjdsazNPbzNwbkhkWmhoRzlISkpEWEx5YVk0ZGc1?=
 =?utf-8?B?RnMvaitoUmt1eFNXdExUT0xSZTNDVU1CVkdzS0lTNXVucEsrK2VSMHRrWXJX?=
 =?utf-8?B?bVV3Z0E4WWIzZmR1eTZlK0VCT2NjaWM2Y1U3dk5EMEpOWHU0QVAweXJidVJh?=
 =?utf-8?B?T2FjbHErQ1lWV0N2bDFQVVgwZURwclJCUDhCUXVrSjUyTUlSSGpKeC9DenpL?=
 =?utf-8?B?bkRLRkdzc281cnpSRUgyaEZJVWcvWS9FajZOSXNzNStHcjg5Zk9tU0RHblpG?=
 =?utf-8?B?RktVTDl4b1ltNXpGK1FxaE1WSWFqQ1RkRW9iejZGWUZQdHMwY1NnZzRkMVkw?=
 =?utf-8?B?eVoyWUF4QkxLcGVRbFZRTTk2Uy91YXV1QSs0UTg1YVBBM2F4TmJKSEhmVDhh?=
 =?utf-8?B?N1pmWXM5blliWkZDUndJZVJxRk1DMXNVU0xhUEdLeHR4N3pDak9XY3pQR1Nv?=
 =?utf-8?B?ZU95NVN2aVdJZVA5THExUFVRUlE3azlER2dUYlZ2UUIyT3dRS3NEM1RLeDFw?=
 =?utf-8?B?VGhWNzVTSUJpcnN5L3BlcnhaNjl4WXFEbFJtYy84N0lwZ3dtTnBFWFpBam94?=
 =?utf-8?B?OU5KTEpBUnkzdTZCYmZsa0tBMk1HcmdQNlQyUEcyM3pkaGYwQVJ6anQrbmRm?=
 =?utf-8?B?YTNCcjB0OHBkQktFZnFJd05OSHQ4SjN2ek9EZXVSbHhYUENmN0FNUTNaTkdr?=
 =?utf-8?B?NTRLSnlQV2Y3cmI0SDlsRTFIbUJ1MlBSZjNKZ1JibnJJdUZvKzhMRVpnQ0Vu?=
 =?utf-8?B?ckpXNVhTbzV0YVphMER2WEJzUmsvNTJ5czE3YitaSXNtdEFIYWt6eWZ4bklp?=
 =?utf-8?B?WjNpSUpHOHJSbW9Cb3pKaHZZazZ6RXN1Q0dsOXhQSzdSbjJMdDBQYTZzZ0NP?=
 =?utf-8?B?aHB5YWg3SkFXbm5iSGROUEgvQTlGenhkOEJ0WmhOVDF0RUhBN2RZdUZPdEJM?=
 =?utf-8?B?UzFxbTVkZDUzOUlTRmtkQzNiYVQ1VXl4cFd3Ynl3VVh2RVdCbkhMVkFQOFBq?=
 =?utf-8?B?d1hXejgvUythVnBaSUpzMjlYMDAvekl4emc2aGpDWkpiSzk4NHE5NUV1QWhu?=
 =?utf-8?B?QUU5cUdhdktXb1Awb0cxd0J1VWdTYVpVTGVDRXpVUWExYkFoNVBCOTY2UUNH?=
 =?utf-8?B?NzRGdGp4dEpWZ1IwNUtscU5JVGlOS2ZVZmJkTFRNK1RxTEdnOHhLNzhOTUU4?=
 =?utf-8?B?VXNFWUJiOFBEVWJjSGNxaXVJL25JT1dTcVEyak5ZNVVVdnlkK2JoR2pzYnZ1?=
 =?utf-8?B?NGJKYTJzQlhkU2JacmZjdFFGTkRwSFk2L2huVkNjZ25QbUhwZStOQWdMZzNJ?=
 =?utf-8?B?WG42RHBEZnk4RnNVdzBCKyt5cStHMmRFcndqaUZGZTcwM1V3OWZ4YUd5ZEpB?=
 =?utf-8?B?REJFRWwvVVRraEtwcktNWGg4eU0zZmRveUNmUUx3TmhLeTBzaUVxcTJ2MVh4?=
 =?utf-8?B?aEEwTUVXK0JtN2RENU9hVzNqWGpTOGRHeUpmeWY3UHY4REhCVEt4RHQ2YnU0?=
 =?utf-8?B?QnBQWnBaamxnTzRoUlB2U0kxNE9Wa3MweVN0M0hjNzlQTVBNejlpWjBGbG4v?=
 =?utf-8?B?ejN0TVFiU0tTdlZnTGdHbnVmY3EyMkhDREhFMFFMeTQvNEVQRWR4SmNJVmx4?=
 =?utf-8?Q?GjL0ZTBm9TwX6FdW/uWcgp0Ph?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F68C411494FFA549B3F7BC8F1F630EA5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96654c28-39e7-42a8-698f-08dc80310356
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 22:45:17.7427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cBMG8GOhKJNgqyQt7dez9iO7s8aVDmyvL7XM+aj2HqFt2jV/TMK71taEditiBVW7g/qMOaKSEloz/TjSSIkeOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7017
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTI5IGF0IDA4OjAxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAyOCwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIDI0
LzA1LzIwMjQgMjozOSBwbSwgQ2hhbyBHYW8gd3JvdGU6DQo+ID4gPiBPbiBGcmksIE1heSAyNCwg
MjAyNCBhdCAxMToxMTozN0FNICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiANCj4g
PiA+ID4gDQo+ID4gPiA+IE9uIDIzLzA1LzIwMjQgNDoyMyBwbSwgQ2hhbyBHYW8gd3JvdGU6DQo+
ID4gPiA+ID4gT24gVGh1LCBNYXkgMjMsIDIwMjQgYXQgMTA6Mjc6NTNBTSArMTIwMCwgSHVhbmcs
IEthaSB3cm90ZToNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPbiAy
Mi8wNS8yMDI0IDI6MjggcG0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+ID4g
PiA+IEFkZCBhbiBvZmYtYnktZGVmYXVsdCBtb2R1bGUgcGFyYW0sIGVuYWJsZV92aXJ0X2F0X2xv
YWQsIHRvIGxldCB1c2Vyc3BhY2UNCj4gPiA+ID4gPiA+ID4gZm9yY2UgdmlydHVhbGl6YXRpb24g
dG8gYmUgZW5hYmxlZCBpbiBoYXJkd2FyZSB3aGVuIEtWTSBpcyBpbml0aWFsaXplZCwNCj4gPiA+
ID4gPiA+ID4gaS5lLiBqdXN0IGJlZm9yZSAvZGV2L2t2bSBpcyBleHBvc2VkIHRvIHVzZXJzcGFj
ZS4gIEVuYWJsaW5nIHZpcnR1YWxpemF0aW9uDQo+ID4gPiA+ID4gPiA+IGR1cmluZyBLVk0gaW5p
dGlhbGl6YXRpb24gYWxsb3dzIHVzZXJzcGFjZSB0byBhdm9pZCB0aGUgYWRkaXRpb25hbCBsYXRl
bmN5DQo+ID4gPiA+ID4gPiA+IHdoZW4gY3JlYXRpbmcvZGVzdHJveWluZyB0aGUgZmlyc3QvbGFz
dCBWTS4gIE5vdyB0aGF0IEtWTSB1c2VzIHRoZSBjcHVocA0KPiA+ID4gPiA+ID4gPiBmcmFtZXdv
cmsgdG8gZG8gcGVyLUNQVSBlbmFibGluZywgdGhlIGxhdGVuY3kgY291bGQgYmUgbm9uLXRyaXZp
YWwgYXMgdGhlDQo+ID4gPiA+ID4gPiA+IGNwdWh1cCBicmluZ3VwL3RlYXJkb3duIGlzIHNlcmlh
bGl6ZWQgYWNyb3NzIENQVXMsIGUuZy4gdGhlIGxhdGVuY3kgY291bGQNCj4gPiA+ID4gPiA+ID4g
YmUgcHJvYmxlbWF0aWMgZm9yIHVzZSBjYXNlIHRoYXQgbmVlZCB0byBzcGluIHVwIFZNcyBxdWlj
a2x5Lg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBIb3cgYWJvdXQgd2UgZGVmZXIgdGhpcyB1
bnRpbCB0aGVyZSdzIGEgcmVhbCBjb21wbGFpbiB0aGF0IHRoaXMgaXNuJ3QNCj4gPiA+ID4gPiA+
IGFjY2VwdGFibGU/ICBUbyBtZSBpdCBkb2Vzbid0IHNvdW5kICJsYXRlbmN5IG9mIGNyZWF0aW5n
IHRoZSBmaXJzdCBWTSINCj4gPiA+ID4gPiA+IG1hdHRlcnMgYSBsb3QgaW4gdGhlIHJlYWwgQ1NQ
IGRlcGxveW1lbnRzLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgc3VzcGVjdCBrc2VsZnRlc3Qg
YW5kIGt2bS11bml0LXRlc3RzIHdpbGwgYmUgaW1wYWN0ZWQgYSBsb3QgYmVjYXVzZQ0KPiA+ID4g
PiA+IGh1bmRyZWRzIG9mIHRlc3RzIGFyZSBydW4gc2VyaWFsbHkuIEFuZCBpdCBsb29rcyBjbHVt
c3kgdG8gcmVsb2FkIEtWTQ0KPiA+ID4gPiA+IG1vZHVsZSB0byBzZXQgZW5hYmxlX3ZpcnRfYXRf
bG9hZCB0byBtYWtlIHRlc3RzIHJ1biBmYXN0ZXIuIEkgdGhpbmsgdGhlDQo+ID4gPiA+ID4gdGVz
dCBzbG93ZG93biBpcyBhIG1vcmUgcmVhbGlzdGljIHByb2JsZW0gdGhhbiBydW5uaW5nIGFuIG9m
Zi10cmVlDQo+ID4gPiA+ID4gaHlwZXJ2aXNvciwgc28gSSB2b3RlIHRvIG1ha2UgZW5hYmxpbmcg
dmlydHVhbGl6YXRpb24gYXQgbG9hZCB0aW1lIHRoZQ0KPiA+ID4gPiA+IGRlZmF1bHQgYmVoYXZp
b3IgYW5kIGlmIHdlIHJlYWxseSB3YW50IHRvIHN1cHBvcnQgYW4gb2ZmLXRyZWUgaHlwZXJ2aXNv
ciwNCj4gPiA+ID4gPiB3ZSBjYW4gYWRkIGEgbmV3IG1vZHVsZSBwYXJhbSB0byBvcHQgaW4gZW5h
YmxpbmcgdmlydHVhbGl6YXRpb24gYXQgcnVudGltZS4NCj4gDQo+IEkgZGVmaW5pdGVseSBkb24n
dCBvYmplY3QgdG8gbWFraW5nIGl0IHRoZSBkZWZhdWx0IGJlaGF2aW9yLCB0aG91Z2ggSSB3b3Vs
ZCBkbyBzbw0KPiBpbiBhIHNlcGFyYXRlIHBhdGNoLCBlLmcuIGluIGNhc2UgZW5hYmxpbmcgdmly
dHVhbGl6YXRpb24gYnkgZGVmYXVsdCBzb21laG93DQo+IGNhdXNlcyBwcm9ibGVtcy4NCj4gDQo+
IFdlIGNvdWxkIGFsc28gYWRkIGEgS2NvbmZpZyB0byBjb250cm9sIHRoZSBkZWZhdWx0IGJlaGF2
aW9yLCB0aG91Z2ggSU1PIHRoYXQnZCBiZQ0KPiBvdmVya2lsbCB3aXRob3V0IGFuIGFjdHVhbCB1
c2UgY2FzZSBmb3IgaGF2aW5nIHZpcnR1YWxpemF0aW9uIG9mZiBieSBkZWZhdWx0Lg0KPiANCj4g
PiA+ID4gSSBhbSBub3QgZm9sbG93aW5nIHdoeSBvZmYtdHJlZSBoeXBlcnZpc29yIGlzIGV2ZXIg
cmVsYXRlZCB0byB0aGlzLg0KPiA+ID4gDQo+ID4gPiBFbmFibGluZyB2aXJ0dWFsaXphdGlvbiBh
dCBydW50aW1lIHdhcyBhZGRlZCB0byBzdXBwb3J0IGFuIG9mZi10cmVlIGh5cGVydmlzb3INCj4g
PiA+IChzZWUgdGhlIGNvbW1pdCBiZWxvdykuDQo+ID4gDQo+ID4gT2gsIG9rLiAgSSB3YXMgdGhp
bmtpbmcgc29tZXRoaW5nIGVsc2UuDQo+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgcHJvYmxl
bSBvZiBlbmFibGluZyB2aXJ0IGR1cmluZyBtb2R1bGUgbG9hZGluZyBieSBkZWZhdWx0IGlzIGl0
IGltcGFjdHMNCj4gPiA+ID4gYWxsIEFSQ0hzLg0KPiANCj4gUHJhdGljYWxseSBzcGVha2luZywg
SW50ZWwgaXMgdGhlIG9ubHkgdmVuZG9yIHdoZXJlIGVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIGlz
DQo+IGludGVyZXN0aW5nIGVub3VnaCBmb3IgYW55b25lIHRvIGNhcmUuICBPbiBTVk0gYW5kIGFs
bCBvdGhlciBhcmNoaXRlY3R1cmVzLA0KPiBlbmFibGluZyB2aXJ0dWFsaXphdGlvbiBkb2Vzbid0
IG1lYW5pbmdmdWxseSBjaGFuZ2UgdGhlIGZ1bmN0aW9uYWxpdHkgb2YgdGhlDQo+IGN1cnJlbnQg
bW9kZS4NCj4gDQo+IEFuZCBpbXBhY3RpbmcgYWxsIGFyY2hpdGVjdHVyZXMgaXNuJ3QgYSBiYWQg
dGhpbmcuICBZZXMsIGl0IHJlcXVpcmVzIGdldHRpbmcgYnV5LWluDQo+IGZyb20gbW9yZSBwZW9w
bGUsIGFuZCBtYXliZSBhZGRpdGlvbmFsIHRlc3RpbmcsIHRob3VnaCBpbiB0aGlzIGNhc2Ugd2Ug
c2hvdWxkIGdldA0KPiB0aGF0IGZvciAiZnJlZSIgYnkgdmlydHVlIG9mIGJlaW5nIGluIGxpbnV4
LW5leHQuICBCdXQgdGhvc2UgYXJlIG9uZS10aW1lIGNvc3RzLA0KPiBhbmQgbm90IHBhcnRpY3Vs
YXIgaGlnaCBjb3N0cy4NCj4gDQo+ID4gPiA+IEdpdmVuIHRoaXMgcGVyZm9ybWFuY2UgZG93bmdy
YWRlIChpZiB3ZSBjYXJlKSBjYW4gYmUgcmVzb2x2ZWQgYnkNCj4gPiA+ID4gZXhwbGljaXRseSBk
b2luZyBvbl9lYWNoX2NwdSgpIGJlbG93LCBJIGFtIG5vdCBzdXJlIHdoeSB3ZSB3YW50IHRvIGNo
b29zZQ0KPiA+ID4gPiB0aGlzIHJhZGljYWwgYXBwcm9hY2guDQo+IA0KPiBCZWNhdXNlIGl0J3Mg
bm90IHJhZGljYWw/ICBBbmQgbWFudWFsbHkgZG9pbmcgb25fZWFjaF9jcHUoKSByZXF1aXJlcyBj
b21wbGV4aXR5DQo+IHRoYXQgd2Ugd291bGQgaWRlYWxseSBhdm9pZC4NCj4gDQo+IDE1KyB5ZWFy
cyBhZ28sIHdoZW4gVk1YIGFuZCBTVk0gd2VyZSBuYXNjZW50IHRlY2hub2xvZ2llcywgdGhlcmUg
d2FzIGxpa2VseSBhDQo+IGdvb2QgYXJndW1lbnQgZnJvbSBhIHNlY3VyaXR5IHBlcnNwZWN0aXZl
IGZvciBsZWF2aW5nIHZpcnR1YWxpemF0aW9uIGRpc2FibGVkLg0KPiBFLmcuIHRoZSB1Y29kZSBm
bG93cyB3ZXJlIG5ldyBfYW5kXyBtYXNzaXZlLCBhbmQgdGh1cyBhIHBvdGVudGlhbGx5IGp1aWN5
IGF0dGFjaw0KPiBzdXJmYWNlLg0KPiANCj4gQnV0IHRoZXNlIGRheXMsIEFGQUlLIGVuYWJsaW5n
IHZpcnR1YWxpemF0aW9uIGlzIG5vdCBjb25zaWRlcmVkIHRvIGJlIGEgc2VjdXJpdHkNCj4gcmlz
aywgbm9yIGFyZSB0aGVyZSBwZXJmb3JtYW5jZSBvciBzdGFiaWxpdHkgZG93bnNpZGVzLiAgRS5n
LiBpdCdzIG5vdCBhbGwgdGhhdA0KPiBkaWZmZXJlbnQgdGhhbiB0aGUga2VybmVsIGVuYWJsaW5n
IENSNC5QS0UgZXZlbiB0aG91Z2ggaXQncyBlbnRpcmVseSBwb3NzaWJsZQ0KPiB1c2Vyc3BhY2Ug
d2lsbCBuZXZlciBhY3R1YWxseSB1c2UgcHJvdGVjdGlvbiBrZXlzLg0KDQpBZ3JlZSB0aGlzIGlz
IG5vdCBhIHNlY3VyaXR5IHJpc2suICBJZiBhbGwgb3RoZXIgQVJDSHMgYXJlIGZpbmUgdG8gZW5h
YmxlDQpvbiBtb2R1bGUgbG9hZGluZyB0aGVuIEkgZG9uJ3Qgc2VlIGFueSByZWFsIHByb2JsZW0u
DQoNCj4gDQo+ID4gPiBJSVVDLCB3ZSBwbGFuIHRvIHNldCB1cCBURFggbW9kdWxlIGF0IEtWTSBs
b2FkIHRpbWU7IHdlIG5lZWQgdG8gZW5hYmxlIHZpcnQNCj4gPiA+IGF0IGxvYWQgdGltZSBhdCBs
ZWFzdCBmb3IgVERYLiBEZWZpbml0ZWx5LCBvbl9lYWNoX2NwdSgpIGNhbiBzb2x2ZSB0aGUgcGVy
Zg0KPiA+ID4gY29uY2Vybi4gQnV0IGEgc29sdXRpb24gd2hpY2ggY2FuIGFsc28gc2F0aXNmeSBU
RFgncyBuZWVkIGlzIGJldHRlciB0byBtZS4NCj4gPiA+IA0KPiA+IA0KPiA+IERvaW5nIG9uX2Vh
Y2hfY3B1KCkgZXhwbGljaXRseSBjYW4gYWxzbyBtZWV0IFREWCdzIHB1cnBvc2UuICBXZSBqdXN0
DQo+ID4gZXhwbGljaXRseSBlbmFibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIG1vZHVsZSBsb2Fk
aW5nIGlmIHdlIGFyZSBnb2luZyB0bw0KPiA+IGVuYWJsZSBURFguICBGb3IgYWxsIG90aGVyIGNh
c2VzLCB0aGUgYmVoYWl2b3VyIHJlbWFpbnMgdGhlIHNhbWUsIHVubGVzcw0KPiA+IHRoZXkgd2Fu
dCB0byBjaGFuZ2Ugd2hlbiB0byBlbmFibGUgdmlydHVhbGl6YXRpb24sIGUuZy4sIHdoZW4gbG9h
ZGluZyBtb2R1bGUNCj4gPiBieSBkZWZhdWx0Lg0KPiA+IA0KPiA+IEZvciBhbHdheXMsIG9yIGJ5
IGRlZmF1bHQgZW5hYmxpbmcgdmlydHVhbGl6YXRpb24gZHVyaW5nIG1vZHVsZSBsb2FkaW5nLCB3
ZQ0KPiA+IHNvbWVob3cgZGlzY3Vzc2VkIGJlZm9yZToNCj4gPiANCj4gPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vWmlLb3FNay13WktkaWFyOUBnb29nbGUuY29tLw0KPiA+IA0KPiA+IE15
IHRydWUgY29tbWVudCBpcyBpbnRyb2R1Y2luZyBhIG1vZHVsZSBwYXJhbWV0ZXIsIHdoaWNoIGlz
IGEgdXNlcnNwYWNlIEFCSSwNCj4gDQo+IE1vZHVsZSBwYXJhbXMgYXJlbid0IHN0cmljdGx5IEFC
SSwgYW5kIGV2ZW4gaWYgdGhleSB3ZXJlLCB0aGlzIHdvdWxkIG9ubHkgYmUNCj4gcHJvYmxlbWF0
aWMgaWYgd2Ugd2FudGVkIHRvIHJlbW92ZSB0aGUgbW9kdWxlIHBhcmFtICphbmQqIGRvaW5nIHNv
IHdhcyBhIGJyZWFraW5nDQo+IGNoYW5nZS4gwqANCj4gDQoNClllcy4gIFRoZSBjb25jZXJuIGlz
IG9uY2UgaW50cm9kdWNlZCBJIGRvbid0IHRoaW5rIHdlIGNhbiBlYXNpbHkgcmVtb3ZlIGl0DQpl
dmVuIGl0IGJlY29tZXMgdXNlbGVzcy4NCg0KDQo+IEVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIHNo
b3VsZCBiZSBlbnRpcmVseSB0cmFuc3BhcmVudCB0byB1c2Vyc3BhY2UsDQo+IGF0IGxlYXN0IGZy
b20gYSBmdW5jdGlvbmFsIHBlcnNwZWN0aXZlOyBpZiBjaGFuZ2luZyBob3cgS1ZNIGVuYWJsZXMg
dmlydHVhbGl6YXRpb24NCj4gYnJlYWtzIHVzZXJzcGFjZSB0aGVuIHdlIGxpa2VseSBoYXZlIGJp
Z2dlciBwcm9ibGVtcy4NCg0KSSBhbSBub3Qgc3VyZSBob3cgc2hvdWxkIEkgaW50ZXJwcmV0IHRo
aXM/DQoNCiJoYXZpbmcgYSBtb2R1bGUgcGFyYW0iIGRvZXNuJ3QgbmVjZXNzYXJpbHkgbWVhbiAi
ZW50aXJlbHkgdHJhbnNwYXJlbnQgdG8NCnVzZXJzcGFjZSIsIHJpZ2h0PyA6LSkNCg0KPiANCj4g
PiB0byBqdXN0IGZpeCBzb21lIHBlcmZvcm1hbmNlIGRvd25ncmFkZSBzZWVtcyBvdmVya2lsbCB3
aGVuIGl0IGNhbiBiZQ0KPiA+IG1pdGlnYXRlZCBieSB0aGUga2VybmVsLg0KPiANCj4gUGVyZm9y
bWFuY2UgaXMgc2Vjb25kYXJ5IGZvciBtZSwgdGhlIHByaW1hcnkgbW90aXZhdGlvbiBpcyBzaW1w
bGlmeWluZyB0aGUgb3ZlcmFsbA0KPiBLVk0gY29kZSBiYXNlLiAgWWVzLCB3ZSBfY291bGRfIHVz
ZSBvbl9lYWNoX2NwdSgpIGFuZCBlbmFibGUgdmlydHVhbGl6YXRpb24NCj4gb24tZGVtYW5kIGZv
ciBURFgsIGJ1dCBhcyBhYm92ZSwgaXQncyBleHRyYSBjb21wbGV4aXR5IHdpdGhvdXQgYW55IG1l
YW5pbmdmdWwNCj4gYmVuZWZpdCwgYXQgbGVhc3QgQUZBSUNULg0KDQpFaXRoZXIgd2F5IHdvcmtz
IGZvciBtZS4NCg0KSSBqdXN0IHRoaW5rIHVzaW5nIGEgbW9kdWxlIHBhcmFtIHRvIHJlc29sdmUg
c29tZSBwcm9ibGVtIHdoaWxlIHRoZXJlIGNhbg0KYmUgc29sdXRpb24gY29tcGxldGVseSBpbiB0
aGUga2VybmVsIHNlZW1zIG92ZXJraWxsIDotKQ0KDQo=

