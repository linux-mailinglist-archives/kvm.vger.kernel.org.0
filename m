Return-Path: <kvm+bounces-56021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01C98B391F1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972291C21D2B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81478241674;
	Thu, 28 Aug 2025 02:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQr4MDAw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B992F270EC3;
	Thu, 28 Aug 2025 02:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349792; cv=fail; b=gC9lATNT7KCRmWr94JKJXWZvE7uvI1SIzYwguWKquu7vVD4zN7VpO9Yn0aFqXNIvo57ky6AfVEFjrEcmpJ0+vGd3djo1Bofd6tqX/AgWUiosIEjwmO6BBBuwBGDfLsXcUBkiCnsw/6PKZu6OqROc6sglVC5qaWnzWSC+dJPAlzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349792; c=relaxed/simple;
	bh=N3pZHe5OzAqcx2bsMNRCsI4qSAkH7agxuGb3bueoTOQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hD4cvu6a3FB79HtSmd5DNdJO+PgNg+JMviUfSjAY8CQBd1Z67Krde6IBUFmI3XTYRjD/CYAoL7eTd12oIsRo1X6svikB8tB2eKznnCrkwjBhhF2YPxO8eQWqBnXKRK2h37LzzXEI93Kd0lWf38CxKgeMNVvJie/A0YOREbF/W2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQr4MDAw; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756349791; x=1787885791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N3pZHe5OzAqcx2bsMNRCsI4qSAkH7agxuGb3bueoTOQ=;
  b=MQr4MDAwCuTeRMxC015MqkZr7CLhsdJ3BcveVQJJKHToDjqoT71OGUhF
   l291+6r0BaPMKoEDs2uWagkfM1Aik6QxNasUou7yHwZUGglxEI5sFBPfM
   uwLFmETmOlHnHUpuV8ZJFmBX6bS6mPJ6vi24Ta4+sGav5m3nAqwuqiDXw
   oIQWNUPyNMzsK0GKPdEeiI5fZpo+7l9s6NdYsUssr10rErjaaDLKYWBg4
   YmwAsouDA4+zwFyi4QRsF3IpBico8RIpPzooM7GaOkrx7BFPg0ARHOjoP
   G4ou4H0e9yvVu5O3zS0rK00Y3gZh2k2ZReyruZkS++oSb5FL1MPk8qQ8/
   A==;
X-CSE-ConnectionGUID: qzC39+PTS2S8RVmFFGAwhQ==
X-CSE-MsgGUID: ZgbxQF0jTHCulWz4bZFLhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58708640"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58708640"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:56:29 -0700
X-CSE-ConnectionGUID: bMV4RnfhQlGmJ+6ZcHfU/A==
X-CSE-MsgGUID: 4kJW41xYSnKNpMICXLllqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169292756"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:56:29 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:56:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:56:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.45)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:56:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4bIa8eXkfxGmQ/n1xgyeLe/n1HHJ7tcz5EbPev4sWuxmC4mJgsnJB1bu1HpiFeCE9bIFCcxP1C9svpHZtrcN6Fzn5Tn4Ogg2bM7CL9deDoeKVCrh1DARDqiYFPW35qy/kT8TvfTTtCYtS7olMkudRR/v24KhE5jPwojPKpHgaMoWfWtxPwzVmtum7uO7HQEWpaAtGE8gxYSJuqd+sug1zSbmSoZTh9PwY1r2zbtBQ6hdiH8IZqD9WVTc7SGyoUJXmdYzwB1hsZQFE4eUBITfutivCf0XC56oWhXZiOGiwl+l+DnQ7OzFNMJ8zBEKWu6ppG0AAJv8ZMNUTws4jrz9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3pZHe5OzAqcx2bsMNRCsI4qSAkH7agxuGb3bueoTOQ=;
 b=yNCMDtXVApBYoiM5t8LXDtCKaZ9VOmUVJ9olMF/qTeNGjHh32JpHf8Dy9KC0DGD8afZT1YFDKwyjKsugbt/hZrNcklzPHW1Xzh2a24zMXsz4HfvN7FcCcn950lpvlYIk4fk8bH4Z1Sx3OJzZEGhcTwLGCyiw8P4q3bxMFK8bPSjc4KIWE68GAP/CsLcGTKeqbPDwVB4XMyxQkHqY8M61fufQilxMw3Po8CtDO7y8atOM/Dw0wiuh4RffvW01PhjfoPMtiulnty3JXwvvKaqrkmT1xGba23kCBEP1a9lxnyrmEH2ZXc5D4Y1lqFmb+isbttRsgXvmZCtlW02SmXy8Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4556.namprd11.prod.outlook.com (2603:10b6:303:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 28 Aug
 2025 02:56:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 02:56:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Thread-Topic: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Thread-Index: AQHcFuZhH5ivTN1080yMH+cPgFIX9bR3YNiA
Date: Thu, 28 Aug 2025 02:56:18 +0000
Message-ID: <afacb9fb28259d154c0a6a9d30089b7bb057cd61.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-9-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4556:EE_
x-ms-office365-filtering-correlation-id: 9808366b-bb4f-4dd8-3c99-08dde5de75f3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dy8yV0tLdEZaS3ZXUk40Z3pSdGFseDcrR0JYMlBOVkZMcmttdElORWZMbjht?=
 =?utf-8?B?RW1IdHozUmQvc1ZlcmZCUFNMUW4wNm1IMGNjcGhSQlovbXhVeGdJbWFnNmgv?=
 =?utf-8?B?Wmg3c09adTZodW5TTnd2ZTJYRTJDaytOd1dRa3BRQVFkdWxtd2Exa1VkOEti?=
 =?utf-8?B?bVRhWnJVYyt3VmxLM2dWdUNCaWtxS1BVL21mQnJkVEpPTVFxcCtVMjdtRjlt?=
 =?utf-8?B?ZWJzbVNZeUFxMGRtUGU2UFlPb2hHTytGVk91S1kyRWlhR2RIc0R4WWQ0RE85?=
 =?utf-8?B?eVNwV05nMzd2K0gyRkN2aDBPL0txQVZVQkdrOUNzQVZXVVZpNnZPaGJ4Y2dB?=
 =?utf-8?B?aS9XdC9tN04wQmlTenZqUFhXaVN1QnptN0MwaU5ZZjBWTjcrT2RSc0ZXcDht?=
 =?utf-8?B?OXRBS3pUVHUvalE4U25lK3hVdXFyV3ZzWVN3MWNYZFBXdklYcHd5QmQ5NmRy?=
 =?utf-8?B?RXRGNUFrc3oyR0dHNmlpNEZFb2ZKd2ZuczRNd1FsNWw5ZDNPbGVYcDFlUzNH?=
 =?utf-8?B?elI4dDdsUFdiVXR1L0dZeTJXQlJPR2hxVjZ6YzRUQUlCWTlidWw5bk5WQXlK?=
 =?utf-8?B?c2w5OXNXUk5DOTlDRXFXTDFzMU5zSW9GcW1tVHZPN3NzYjV1U2ZjbGQ3K2Y2?=
 =?utf-8?B?NzZIdHcxSklxT1IwcGN1dDd5S2xjbStaZUduNytmM0JJSFFsdVhXYTZ2SkVL?=
 =?utf-8?B?K1JyWEJNL0pYVTVFeEZ6UVVZRnYyWUg4SWlLYUZ3Qjg1Q2o0S1ZNdThvSGtP?=
 =?utf-8?B?TXAvV0cyZ0tJTll1VnZiajJLYWdLVkNiVG91bGZsMzBaVmUybWRUbUxldlZS?=
 =?utf-8?B?UGlXMmJjNHMzdll4aVV5Q3R6OThVNEZHQm1nUlZrQmIzS0Ewdy9EQ2JoTGh1?=
 =?utf-8?B?TFR3UythbjN3QXMwTm53Zkp2R2lqb3JJVFdyTUpZYmFLT0t5b3FTbDQvbVcz?=
 =?utf-8?B?RVNZanBWUy9LR3hmV0k4ZEI1N2lVWGk4ZFdZc2ZRaHpRc08weVpYblBCYXpO?=
 =?utf-8?B?RFBGcGtkRFBPd0lsbzNiaFA1WEN5cHUram9hK0l6RGFHOUxxbll5cmJoN2ww?=
 =?utf-8?B?V2NqRnFnN1V0aVhjWHVjWnBoSnFqeXRxYTJzY0Z3aXJSdjRJTUl3UDQ5RzRO?=
 =?utf-8?B?NDNaQ1RVM0pUTTVDa2YrR0h6QzhUWVo0S3dWeHg2Q2hNa01TbjJ1WUhmWFJE?=
 =?utf-8?B?bGJjSEMxVzBYalJ0U0FWTWJuak9Dbm1OcklvcHN6Y25rbXhCUS9BY2N3ZHpy?=
 =?utf-8?B?Q0psYmJlL3B2NXZjVVZTdXNzNS9SL0QraThTdTlvK1pFYkhReUVldGJzMTE0?=
 =?utf-8?B?dzRicHZqY1ZBVTNLY0VtMllXNFNFRTNyNXZSV3R3R0ZRYjJxaDJNWXVuZGJl?=
 =?utf-8?B?ZS8wdkhhY0tNMjBZK0YyWm13TjFJeFZkUUlkR1dSdXhidjdYbitGdkVRaElT?=
 =?utf-8?B?L1BnVlc4WUxNTDVGVk5uSEZzcjVicTF5dlRwNDJIZ0NpaVhMQVN3blV6K25F?=
 =?utf-8?B?QmpuUlc5WmlQZ2wvR3ZGcTZEaVpMZEhmQmxzcHdsMkZQWkhQbmhNZFErSUFY?=
 =?utf-8?B?OU9DSUVVUVZ4RmpwWm9yOEpwaG5GUEsvaUlwekoyR2s5eVZoQ2VpdTljeU9n?=
 =?utf-8?B?c3N3TncvRkFpbkkwMkZtcnkxN1hBb3oyazdwQUo2YVBRNzhDVFl0YWM1Z1B4?=
 =?utf-8?B?YThranFjVnptemFjeTNKa0d1blNwWEtyczlGc2x5TGg3bGcrNHRlYUhKMlNW?=
 =?utf-8?B?TTVsb0U5YkhDTWllMWhIcVRwb3JZdHd2aUJNM0F5aERuaTlsMUxVaFhFekVu?=
 =?utf-8?B?ZlFKK091di80NTZCS0lUYzlIVU1jMkFsbVY5RTNaN3BEN0xwL2hxbURHV2Rt?=
 =?utf-8?B?M2JnUGR1c3dzTkN6TkNkU0JBb0dMU0pKOW5mcFRwNlNaZXUvNkxkUXUwNWRh?=
 =?utf-8?B?MG1ScFJDN3F5ak9aRUZ1UHZGUWlBbW1DTWpCL2lFSXF4Mkl5ZVRqZmtEWWda?=
 =?utf-8?B?TjRkQnpRQ1FBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3Q0N2tCa2h2M0E0SkNpT0FVZE4xSlhxblZrVVluWTBOMFZIZTBhQ3dtWUlQ?=
 =?utf-8?B?dEhadFJiSDBUdU1wZlBZMFJJMFZoVzE1azNvSzdMaFVQNGJWNW9MeTRaamNU?=
 =?utf-8?B?Y2lUdkdUcTlVdlJVYVNxSnR5OW9DUTRORjRVakNkZE5rNGFEdjR4L3lISmdt?=
 =?utf-8?B?UWVHR09MR2pxT2J5SVYvWGNpNDZyekRHdGpqcDR5ai85TGpTTlU1SkdqdWt0?=
 =?utf-8?B?aSt4WGRKYk45NHdEWUMwd3crOXZjZkpUWUh1Y1pjRkllT3RQSWNGZy9tM1NU?=
 =?utf-8?B?OVd5WkVjSzlISjRLang0eU9hOGVrWUJqTGpVdUlNRm5nQTBiUlhHcnFSVG42?=
 =?utf-8?B?eTROS0NUd2Q2Vk85cDJmVW84Y3V2WGZQU2JCTUNLZUhIemhNbkhCaTAvZWZr?=
 =?utf-8?B?ZDRFeUVybDkrd0NFU1Bxb1VJeXpaVEdXZ3BWQ2ttVG55eVZpSGcxZXNxY3Bi?=
 =?utf-8?B?UUQ0WUFoUnBqMW5tUEE3cDlkSTExQ0dkcTdxR3NyVUZtU0oycWJTUDRpMkp0?=
 =?utf-8?B?TVYzdFZHUmtUcThGVnFTVFNzMldMdFlwZlpsR0VUQTdCdlpqN0RFRGJOaWtQ?=
 =?utf-8?B?Ti9XdlBvcVZGaUhkOENZSHBPT3NJYlpnaEZYam5ldHFKbzdWMlJRVkxaTVA5?=
 =?utf-8?B?aHRhT3ZkbndGczZlVnR3SG5ZWkVOcjI1cUhKQWxZTnZPTG02R3AxWHZ0ZmFi?=
 =?utf-8?B?RDFtcnBCbHJmcGR3bC9lazBpQnNmbTVERlJNVHhVSmhkTnVNZkV5WEY0Ly9Y?=
 =?utf-8?B?U3Y1aWRzT3VTdmJySUpqU3R4Y0oyMGlMSi9CeUZueEsyUDczNFplVk1xKzUz?=
 =?utf-8?B?M3FuREh6Y3YwRUpCU3BpUEdPdXRYSm1zOWVyUll6WlZUa3dQYzRXcTlKYXhx?=
 =?utf-8?B?OVNDb0p5VWFNR0ZQZFUvN3lWRDRGM1dKVVJoMWlCZ0ZWSzVXZk1BaWtDc3RP?=
 =?utf-8?B?a0R1ZzAzNUN1ak5ObG1UeWxsWnY2K21GQkNLZ1dKNkxqdklzY2VCODNyVjBh?=
 =?utf-8?B?KzFiVTJxaE9lNVNPOTU0aHIzN1hrcmxycWU0WHBva1Z4YzcrK2F5S0owQU9B?=
 =?utf-8?B?Zkg2ZTZObEJycWhHVnhEczU1cHRIbVJxN2hZWlNDQnRlc09YTG9NY1JRbmdw?=
 =?utf-8?B?TGN3d25HKzZTMktUZHA5Z3E4VEtscWVXL3hKbDdBamMzUEtKdHViNUNkZnc0?=
 =?utf-8?B?NldPenljNlllZXQ0WWtVZWhVMDdvdVZiN2h1emYzWWxxMDd0eWcwZG5sN0lU?=
 =?utf-8?B?U2dWWDA0WkNBb1dVeWVtZUlidjlwcXNTdnNrNW9qSDM5aTQwVFI0Q2pncXV4?=
 =?utf-8?B?V1FyNlc3eXhYcms4L2c1YWxEcDJMMHVGRVdrUUJDWUh1V1E1Q1pPejgxU29V?=
 =?utf-8?B?N3BjaVpiTFJYd0ViSkN4M0d3b01rVUFML1NFWkN2Y3lHY1BnRlJLTkhpMGNY?=
 =?utf-8?B?Yi9aVjg4aVZxajAyY1FTOS9CcE15ODRncjNTQkRlMFkxYWxraXVrQm1aSkJu?=
 =?utf-8?B?Y2ltK3BKdDhaU1IyNEcxS2ZnaVVtZVJ1ckJPL3RNRzlaeS8vMEpzMlBCQTFo?=
 =?utf-8?B?NkNDdVBxZUp5M0hEZ1ZiajU1RzRTYkYvclV4eVFJZDFuamorNldqNzdPYkNM?=
 =?utf-8?B?VmRzcTFRTzd1OGdWU0Q2ZjVvc3J0b0FxZ25Jd1BOeW85UU14MHc3eFRFS3pn?=
 =?utf-8?B?SEo3Rmd3M2JsYnp5Qk1hNkhTUWp5L1ByZFJiNU5ac2NSM2RVU3JrbHdtVVBQ?=
 =?utf-8?B?SExZczlIdUlVZk1PV3AzdXQ4TllsRzdoeURDRUtadnYyK2l1eG4xRWc5VFky?=
 =?utf-8?B?Ymp3NkNHM01ITWxpcnc2UWNUczZnZ1BwNnVpcTJPb3k0SncxZlo0Rlg4aEJJ?=
 =?utf-8?B?c3Bpb3h2aVFTSEJqeVZtWHpXWkZxbDZTVGNBQ1VOVkk3YVZhZDZ1RWhDcWhT?=
 =?utf-8?B?ZUlEODR3UFVXc09MYjJQS2xSNzd0N0kxTGlkNUw2ODFtTyt3RjJZNWYzVXAw?=
 =?utf-8?B?RUFQQkp5UmQ4WitZdVgxTjJ3MytHa2lwbWdFVTF6R0N6UjJSUHdQWndhUzJK?=
 =?utf-8?B?TXg5SlpRc1JHVTVwMGZzOVFQbDVNOW4xbnZJRDh5NzRWVU1jTW1KOVBmclZG?=
 =?utf-8?B?T1FIMFhUWm1TSkZRR3RCSElMNWF6UkgyM3RHMjVPc2dWYTR6OGdBdjh6UlM5?=
 =?utf-8?Q?0LBCbapjFPMLIw/ge4Ss+p0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <091E9F84465C8A49BF4391E3F82AF410@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9808366b-bb4f-4dd8-3c99-08dde5de75f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:56:18.0467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CV2zEwR79+vVRZQXJgPE/0BrAYwLcZarWLtoiVBjLlpFGMkdX7TQ7Y5zbtEaoTZPh9a7VcdjYTdWwzcXL40hGPh7T/WoYVPfmtRoCrnkYP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4556
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgYXRvbWljNjRfZGVjX3JldHVybigpIHdoZW4gZGVjcmVtZW50aW5nIHRoZSBu
dW1iZXIgb2YgInByZS1tYXBwZWQiDQo+IFMtRVBUIHBhZ2VzIHRvIGVuc3VyZSB0aGF0IHRoZSBj
b3VudCBjYW4ndCBnbyBuZWdhdGl2ZSB3aXRob3V0IEtWTQ0KPiBub3RpY2luZy7CoCBJbiB0aGVv
cnksIGNoZWNraW5nIGZvciAnMCcgYW5kIHRoZW4gZGVjcmVtZW50aW5nIGluIGEgc2VwYXJhdGUN
Cj4gb3BlcmF0aW9uIGNvdWxkIG1pc3MgYSAwPT4tMSB0cmFuc2l0aW9uLsKgIEluIHByYWN0aWNl
LCBzdWNoIGEgY29uZGl0aW9uIGlzDQo+IGltcG9zc2libGUgYmVjYXVzZSBucl9wcmVtYXBwZWQg
aXMgcHJvdGVjdGVkIGJ5IHNsb3RzX2xvY2ssIGkuZS4gZG9lc24ndA0KPiBhY3R1YWxseSBuZWVk
IHRvIGJlIGFuIGF0b21pYyAodGhhdCB3YXJ0IHdpbGwgYmUgYWRkcmVzc2VkIHNob3J0bHkpLg0K
PiANCj4gRG9uJ3QgYm90aGVyIHRyeWluZyB0byBrZWVwIHRoZSBjb3VudCBub24tbmVnYXRpdmUs
IGFzIHRoZSBLVk1fQlVHX09OKCkNCj4gZW5zdXJlcyB0aGUgVk0gaXMgZGVhZCwgaS5lLiB0aGVy
ZSdzIG5vIHBvaW50IGluIHRyeWluZyB0byBsaW1wIGFsb25nLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KDQpSZXZp
ZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KDQpU
aGlzIGFyZWEgaGFzIGdvbmUgdGhyb3VnaCBhIGxvdCBvZiBkZXNpZ25zLiBJbiB0aGUgdjE5IGVy
YSBQQUdFLkFERCBnb3QNCnBlcmZvcm1lZCBkZWVwIGluc2lkZSB0aGUgZmF1bHQgYnkgc3R1ZmZp
bmcgdGhlIHNvdXJjZSBwYWdlIGluIHRoZSB2Q1BVLiBUaGVuIHdlDQpzd2l0Y2hlZCB0byBoYXZp
bmcgdXNlcnNwYWNlIGNhbGwgS1ZNX1BSRV9GQVVMVF9NRU1PUlkgbWFudWFsbHkgdG8gcHJlLXBv
cHVsYXJlDQp0aGUgbWlycm9yIEVQVCwgYW5kIHRoZW4gaGF2ZSBURFggY29kZSBsb29rIHVwIHRo
ZSBQRk4uIFRoZW4gbmVhcmVyIHRoZSBlbmQsIHdlDQpzd2l0Y2hlZCB0byBjdXJyZW50IGNvZGUg
d2hpY2ggZG9lcyBzb21ldGhpbmcgbGlrZSBLVk1fUFJFX0ZBVUxUX01FTU9SWQ0KaW50ZXJuYWxs
eSwgdGhlbiBsb29rcyB1cCB3aGF0IGdvdCBmYXVsdGVkIGFuZCBkb2VzIHRoZSBQQUdFLkFERC4g
VGhlbiB0aGUNCnZlcnNpb24gaW4gdGhpcyBzZXJpZXMgd2hpY2ggZG9lcyBpdCBldmVuIG1vcmUg
ZGlyZWN0bHkuDQoNCm5yX3ByZW1hcHBlZCBnb3QgYWRkZWQgZHVyaW5nIHRoZSBLVk1fUFJFX0ZB
VUxUX01FTU9SWSBlcmEuIEkgcGVyc29uYWxseSBkaWRuJ3QNCmxpa2UgaXQsIGJ1dCBpdCB3YXMg
bmVlZGVkIGJlY2F1c2UgdXNlcnNwYWNlIGNvdWxkIGRvIHVuZXhwZWN0ZWQgdGhpbmdzLiBOb3cg
aXQNCnNlZW1zIGxpa2UgaXRzIG9ubHkgcHVycG9zZSBpcyB0byBnZW5lcmF0ZSBhIEtWTV9CVUdf
T04oKSBpbg0KdGR4X3NlcHRfemFwX3ByaXZhdGVfc3B0ZSgpLiBJIHdvbmRlciBpZiB3ZSBjb3Vs
ZCBkcm9wIGl0IGFsbCB0b2dldGhlciBhbmQNCmFjY2VwdCBsZXNzIEtWTV9CVUdfT04oKSBjb3Zl
cmFnZS4gSXQgc2VlbXMgd2VpcmQgdG8gZm9jdXMgaW4gb24gdGhpcyBzcGVjaWZpYw0KZXJyb3Ig
Y2FzZS4NCg0KWWFuLCBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0K

