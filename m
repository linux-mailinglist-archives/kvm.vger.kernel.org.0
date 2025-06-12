Return-Path: <kvm+bounces-49212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C84E0AD65A5
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DE5D189F495
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DD81C3BEB;
	Thu, 12 Jun 2025 02:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnXOLpB1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDB4145A05;
	Thu, 12 Jun 2025 02:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695280; cv=fail; b=i6mUqs388d7awpk49fjexJzPRSLrV5vGtIfX7ESAqtlSg4wa1dqSJ8INeWNRcZdDpKuE6bdz9ZtZqNeKpzHSv6+Ik7oRj/M3hJbWpPPfoOOWsgjsnJeTuOAPdy0MD40YefvPCVJ959SjwzE5sKH4O5L78aXz3otNqL3DCXK+pkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695280; c=relaxed/simple;
	bh=DNt2rvblSX8/TdFG3bvhsl7gDmO3v/z9En5cIUg/2hk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ko/BKAdNM+MKy/Ncg0klxWkEHS/1sKaR4Lx7JKBcDhkwCX0Wp+3+Xqme7KZQvSot7WX7D+FO2QVWjCbz/Bshs4WV/wFwyHjB9VsKyL0XsFlub+P1zxGrRDOYG9qiwarCtktBuHjBBRm1T4C1Fm2d3W8UyEMMSQugo94M11iOaSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnXOLpB1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749695280; x=1781231280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DNt2rvblSX8/TdFG3bvhsl7gDmO3v/z9En5cIUg/2hk=;
  b=fnXOLpB1ivCuVsGZQzIchdSihqtZZMLaNZ9CSWqAKPuJ8w1nQDSlDPhw
   aR88Pl4Q+pbNhg801/nIrdHGDFwgwt8UaCalMizi+jsUvd1NsWWYD0kN2
   sGC1RSHl2D8RTerQlw5Zw1sqOpGkb6aNNLH/7C2bB6jFtNoIBKZpcYXsQ
   nNWPRiZLhb71ZPks5b7JjtW5e1C9gTRlaJDS8kJzrlce3iQlg0rI9BGjA
   snwbPcNqry/mSpbWA2setedGj5HvSZTEV2J0XUWh1xfangNoK5F7h4gyk
   nHIXFP2Rmfw1J22fpME+i9bDOWaMhKmE/QOXMD0f/VBCXH1DpJvOluAsH
   Q==;
X-CSE-ConnectionGUID: hwkSa8uRTFa0vNvx2r0zww==
X-CSE-MsgGUID: xD0u5AmNRfySxBhnQ79LuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="52002084"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="52002084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:27:59 -0700
X-CSE-ConnectionGUID: i1t2qelyRh6pHx9WhK8u/A==
X-CSE-MsgGUID: KSssDwaERQegwCPH4PJxPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152371117"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:27:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:27:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 19:27:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.76)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:27:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GoeztAF2ARA2TvAO8wP1WpxD1Rn3xf+eH2d8/ojlIz59J0SaEPFqRv+TL/0cYt9bTtSTFwjcEDqct4jblrbv6bCQyHxYBNiVU52r+Frap6mKnws3AoqLZTEVuuyzF6c3UcpEYqtB//t1K+NMfHUu5sPfpoTJS79mruuUMVEnLq74/qXROyDWU78vIKYIwLKXktj7yYe7lVSFFekGCZJY9iZAdkPg9uRQXijpBlCJ9hjiAkLLkD8wrFK9zZqbRo3CClJXfOBpu8XUNGe/YQ5Cp4E9AxbEHQner9uTaAU3RZlb5DZ0JCeC3IDuJrEC0cqIRtXhwwtS0eHIaVpZne2qbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNt2rvblSX8/TdFG3bvhsl7gDmO3v/z9En5cIUg/2hk=;
 b=ZHcrSZVZsI8WqNIUtjRBKMLtTFa2pVutU7sNUIsc2CTEp5d++D8vcw9A+imNZmwCkUtsaqNejx5L2edDMDe5bpxhDll0aAhrgGIGDSc433pO+GdBaXmDiIrCVFc3lOg9lGw/YmDbbepgkLlbifg1eD4Sne6rst2pEVtJrdZesBElk9gJiCU518J2yll2PZtciOA3AoRIdSGkTQOdsTm19oZetK5NrW6nAYiw9puHBGHzK47r5g9tEet96sRtuSj7LEYt8jex24ZPjJml9FNiyx9ZQ9JF//1I2JtvWWqWAysgQiYuPU3ZAWb+p6g5CoVrEedU12RpNPOU5FgrkihPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM6PR11MB4577.namprd11.prod.outlook.com (2603:10b6:5:2a1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Thu, 12 Jun
 2025 02:27:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 02:27:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/18] KVM: x86: Move kvm_setup_default_irq_routing()
 into irq.c
Thread-Topic: [PATCH v2 08/18] KVM: x86: Move kvm_setup_default_irq_routing()
 into irq.c
Thread-Index: AQHb2xjgsjEmh8nodUWBiAE/QyEbELP+zN4A
Date: Thu, 12 Jun 2025 02:27:29 +0000
Message-ID: <3ea1d6b073505ac75af2dffd7776ccb00969841f.camel@intel.com>
References: <20250611213557.294358-1-seanjc@google.com>
	 <20250611213557.294358-9-seanjc@google.com>
In-Reply-To: <20250611213557.294358-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM6PR11MB4577:EE_
x-ms-office365-filtering-correlation-id: cf4e749b-3472-48cb-cd4c-08dda958adac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N0xOUkFlQlNkWXg0dys3SDFCd29NTmZuVHp0S2RVSGJON3cxNExhRk5xU0Rn?=
 =?utf-8?B?ZWtzRW1hd3U1VVZGeTExTkhNQ3JLbVNVVVZJYnVRWWdIWTZZcGxJSExpWGpT?=
 =?utf-8?B?RHNZM2t0dkdjWDNoRitMTVYrK2pEZVhPZ2pqWW5wUTBiV2wvK1gwNmg3bzdB?=
 =?utf-8?B?a0k1YlZZRVN2aUYxVzRmSmFHVzRPMDdYdlpBRHRlZVVzaDNLc0ZDMWsyRW5k?=
 =?utf-8?B?SkxNOFkwNTlCMW02STBDVkEyN3hhOFhzUmFNZ291TmJ4UHN1MU94SEZUaU9D?=
 =?utf-8?B?YWlwNzFCSFZ1NlloNXVSOG9LNWhGY2RrR2N0elVpMG5Sc1o4bk5Ecm9SYml4?=
 =?utf-8?B?TmcrUE8veER4T0RTZHpUd3NQbzlUVVJFNTRRQlJodzduMDVobDI2NEErN1FV?=
 =?utf-8?B?S2kzLytqL3AxMmJsL2JvUHdtQTJXZVgyRm1iWVhweEUvaUVKVnFTS1d0T2s5?=
 =?utf-8?B?K2dQOGZxRlh3Q1IvVWNRbEgwUGZWa2RydUdPanduTGw4MWltSThONEorbUN0?=
 =?utf-8?B?dnVwSUFlUWsxQ1BUNE1SQk80bGtGYjA0ZmQzN2ZPaVEzS29zWGRmVWhnSVho?=
 =?utf-8?B?VGRaVTNETk1TeHlLc1MyTjBDbloyWnRzdFo1am51cnlucERwSWpLMmg0NXVq?=
 =?utf-8?B?Z3lLWkEzREQ5TGhoK2twUzBiNmtPUU12YlVkWUdpMFJkRWViaFlzTHJUbTdj?=
 =?utf-8?B?S0x1cnZNWDdOS3BJMHExVFZBcytZbWRrLzBRY0VVQ3NCY0tXd21qRERaVFBZ?=
 =?utf-8?B?WkJTRFA4d21mYjFFeFdOSVNqY0VJTDF2VVZwRjV3dXZ6V0t2ZFBTVWVsZEhP?=
 =?utf-8?B?ME4waW1aVEp3VTViYkdkejd3cmR6WmZmakFHemt6NU83ajZ0WE5ScnYyTUdi?=
 =?utf-8?B?RmhMRWJtVCtNZE94cjJPb0QrcS9EeTFhWksvV0IwQnVmamUzOGRxWXRBOG1G?=
 =?utf-8?B?dzMyNC84Q3RzaDVqYloycFEwT0NnYmc0V0FlNWFDZmo0dzE0VnlNRkY3am5k?=
 =?utf-8?B?VWV4U25hZk5wVkpTWlVXQXYwSlFYUkpRaVZMQjJVaXl0WHB1aGVUaEVvaHI3?=
 =?utf-8?B?Tld4UGpBM3poeXdBTGhFeEdOMzVQWWx3TU9TQTk2NHpabWJrYXpkaXJLWmNv?=
 =?utf-8?B?QnpURGtJaEFpZ0p1ZkVDRlh3Y1ZmQmJtZTh4SnlzWGJ6OHdmY3NHSzlHSU05?=
 =?utf-8?B?S2ZPU1gzWEtMbHVOWG5YVEtYNXJ5VnFncmV5c1h3Y2tjYS9Yd0lVLzlFZVNS?=
 =?utf-8?B?V3hGTVY2d2duaVBRN0RZMldoL3ZNSGNRWlMyV05TVTZtcjVLWWRXRnNZdEFj?=
 =?utf-8?B?RlpKMkxveFU1bFZlL3VDNUJOTDRkSkRWVEpiTFV0NElLeXhJYUtSUFpVczd0?=
 =?utf-8?B?cWhYZWRndSs4TE16eXVjNWkrZ21DaERoL21qSHgvQkpVRzNaczYyd2h5bVlZ?=
 =?utf-8?B?MVVDWEtMYUVvb3RhRlQ2UWQ1bXlJL3V3V3ZEd3lHUE4vOUxtUExVVDdWOE84?=
 =?utf-8?B?KzFrc05sTmJqR054cTlUdldvWHRhR2xDbTRpZ3hPZll6RExoN0xxc3FrSDJx?=
 =?utf-8?B?YXJzVXNPMkFQeUtScldjOE9LVDJJdDBqeDltdDlZL1pBV3ovNldTNGhzN0pE?=
 =?utf-8?B?MEFmMVg3bUVLTzVZeHczWWMvc0dCZG1TMURvSG5hcTR4VTBveVFFN3k5RjBW?=
 =?utf-8?B?OXNmdmlZb0wxT0krcWlTNmpER2xYK25rdkx2YlhYRHhNK09RR0FCSG0xOTN0?=
 =?utf-8?B?WGFuM2JHSnNCM1lZUHcxVmZQcDVLK3A3dVJ3WkI0VDlHdEprd1FMQklqTGIw?=
 =?utf-8?B?L1JOY1M0U1ZkZ2JNQTE5N1EyR29tZkpuRHZBTlBjM2wrb0FtNDF0OE5HYWMr?=
 =?utf-8?B?KzhPcllqcWJHajhRUy9kdXdYMjJrVE5PZy9Cc1FFQ1ZEd1E1NW9LNW9DQUhw?=
 =?utf-8?B?SUdsUWU4QjdNR2pqanRvWHRQUjh4RElvQk5QNVZGc0J3eHdVSGQxU291eldH?=
 =?utf-8?Q?JekzCdSwLP9IaBsm5k/7RPxK9sUes8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qkh1U2gyMjh6dXhLSU9FcXgyRHIyVWxHRHFkQVkxZDE0aTV5eGhhczFLSlQ3?=
 =?utf-8?B?MXZQZlZKNmhOSWFYY1F5R0NnemcyMDRtdVl3Z1cwalNNN1pmOEFsd2tlRzAv?=
 =?utf-8?B?Z2NNSVRobDhrYWVLRVRMRlRiRjV2SzIwU1ZrZndFQ0NpMGtvT3c1K1hGZnZZ?=
 =?utf-8?B?VTlFdnNodG51QUtxZ3diWGRMeXR4UzFhUHhTeXhmeHp4OWRCZytkRURWalhw?=
 =?utf-8?B?UFc3WmNKdklGbXBpaEhTLy9NUGFuQ1hUZDBYUjkxemZ2NzdXMlBrYmtZOENE?=
 =?utf-8?B?d1FraVNSOFdWRndraVE0Vks3R2QyNEovZDhnNVd2MnN3amxCcnZQZXBNY2xM?=
 =?utf-8?B?cmJseE9NSW5mcjhCVndEKzM4MjNpbVVialFCWlhpNDFLeHpiV1VQMEZMV0Z4?=
 =?utf-8?B?emVMK2lJcnlmKzBkWGo1b3EwNzcrZWRCMXNKaXkyVksxcmtBbnVuSXVlU1Fa?=
 =?utf-8?B?bG9JSjVjVE9xbjArRnR6UmVaUVl1bk40cHBKSmd2N3FWaWw0d0dvbGlwRUMz?=
 =?utf-8?B?VDl5bnVraStnWGdsejN6RWFsaFNGVXFGWmpBTVo2eVdzRkU5bTFnbTNicHJo?=
 =?utf-8?B?RTVNZ1pwV2k5c0tYK3ptSUhhUktTRy9zM2JpSk9aQjRuUzBuS1FibjY0SWF1?=
 =?utf-8?B?N1FsbWN1WmcxNW9SRWFUemRDQWtFMUswNFhVdFF6VVUvMklOTVV1OUJ6NVhZ?=
 =?utf-8?B?Yktma3NyNTZ0QWNNb3dsL01Qb092TnVidkhJSkM1L3podi9QRHI4a3RFM3NR?=
 =?utf-8?B?R2oyMzZBUlVEN0Y2REZhUXFTenhVald0dzlzeVcvUHFGOGFmMUJVQ2UyV004?=
 =?utf-8?B?MGpya3Q2c0xveHgzeGJQdWxuK3M4cElHbnZkRERNVU9VZ09WOFRCdHIxK3ZM?=
 =?utf-8?B?U1lRT2YvWmU1d3ltWm50alp4VzZMRC9EcW01K1F5VVJrblNOU29PcnA1bGJp?=
 =?utf-8?B?RXBvMGFJOXVSMGJQNCt0QTNIcGtSZTA3VjBBcERiT1I2aWZqUGlKMUNKQnpa?=
 =?utf-8?B?ckRQbjg4c2dRQnQ2VmdaWDIrNkY3bkVJYTlBWWZhanRnTXZ1aHA0SDFpU3dF?=
 =?utf-8?B?Q3pvSnpXU0ZCT01zVTcybEpxUHV0aW95MFNNZEVwNFlFd3pDWWttRC9pUmlx?=
 =?utf-8?B?YXBDenhmTythY1FGKzZtQUZ3SWRDR0JWT0JhN01nMjkxTVA4ZmNYL2pWUVFX?=
 =?utf-8?B?NVIxbUxqNVo1b1AySXliTENVczJKNmhmUmtUaHg3R0hDc3ZOR3YyaERacE9E?=
 =?utf-8?B?cUtianltNENURWd1RVNER3ZSSGYxVG4wNUpKQUJUbS9mZktkQzhNd0Rqc1Rr?=
 =?utf-8?B?VU9lU04yS0JYcWowcXhGbTJqaisvZUI1WWpHTkZkM00rZjZaQmJmNzRpT2t1?=
 =?utf-8?B?cFJsVWpLQ2RTcUFRcEpTSG1KbWxmYTkrek9uRWFGTmxkc0ErQUpvL05tMS9q?=
 =?utf-8?B?cm9TUnRxckF5YmhvOWd3bkZaSTBQdDAzRURYc3FvbDY1VVJ2NmpXVE92WWwz?=
 =?utf-8?B?bCtENzdpckZ1clVIWWJJU2JCMTh3WEtrbXk3bnR4M0F0VnZERVFEYlpHY0JP?=
 =?utf-8?B?aHZwRTB4WE9EQmUwa0ptdERzRWs0UU5YdTV3VVEzczErY3hoeUNCbFViQ0NJ?=
 =?utf-8?B?b05sUm9Way9kRzBCWHUyTzFvQmxjRERMb2hWSWYyNXBpR0JjYmNvYnl5cFht?=
 =?utf-8?B?TnJmSGVjSGJGbTdkZzE5MGc1endxWThoQjRQSXlSU09jZ3NZOVlYTmxHbWNN?=
 =?utf-8?B?V3RhbXBaVmVmdkh0Z0NZQTI0cUFEWllPRHhOaWl0aHA5VDdHSzIxR1NaNElM?=
 =?utf-8?B?WkdxUytEeStHanFueWVtWjdUajNVRnBCemZmc1NrMXFzSS9rN1dFai9WSlhZ?=
 =?utf-8?B?M3hueW1XVi9La3o3RGdMeElRK0lIbHV3V3EwYWxPV01lK283WWVvUlNnalIr?=
 =?utf-8?B?c2srbjAxMnlUbGVRMFoyS0thdi9rSWliek55cWQ5ZkVaTlVxcWcybmo4ODVZ?=
 =?utf-8?B?Q1ZzUm9pb2M0ZW0yaVN3dWw0d2RtdGlkbnZPSUlQdmRJbXRqUHpYQnZRU2Nv?=
 =?utf-8?B?b0QwZngvbUdKWG5NSmtCb0kvQnJ5dkp1ZnFZcWE5bnJSN3JVUTR1MHEyRlBT?=
 =?utf-8?Q?QxeH/2amOItgahx1GVSXI3PMz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FB959D6DF429D4FB5E747E84AFD9696@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4e749b-3472-48cb-cd4c-08dda958adac
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 02:27:29.1905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dsjD3jM7Zxr6v8R+YCP8Ef/wXYTydedN0aaG18i58jlwAyoAy7wZ2+s3W6xUSW7xaJAini8MRbccOmS9zAmArw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4577
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDE0OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSBkZWZhdWx0IElSUSByb3V0aW5nIHRhYmxlIHVzZWQgZm9yIGluLWtl
cm5lbCBJL08gQVBJQyBhbmQgUElDDQo+IHJvdXRpbmcgdG8gaXJxLmMsIGFuZCB0d2VhayB0aGUg
bmFtZSB0byBtYWtlIGl0IGV4cGxpY2l0bHkgY2xlYXIgd2hhdA0KPiByb3V0aW5nIGlzIGJlaW5n
IGluaXRpYWxpemVkLg0KPiANCj4gSW4gYWRkaXRpb24gdG8gbWFraW5nIGl0IG1vcmUgb2J2aW91
cyB0aGF0IHRoZSBzbyBjYWxsZWQgImRlZmF1bHQiIHJvdXRpbmcNCj4gb25seSBhcHBsaWVzIHRv
IGFuIGluLWtlcm5lbCBJL08gQVBJQywgZ2V0dGluZyBpdCBvdXQgb2YgaXJxX2NvbW0uYyB3aWxs
DQo+IGFsbG93IHJlbW92aW5nIGlycV9jb21tLmMgZW50aXJlbHkuICBBbmQgcGxhY2luZyB0aGUg
ZnVuY3Rpb24gYWxvbmdzaWRlDQo+IG90aGVyIEkvTyBBUElDIGFuZCBQSUMgY29kZSB3aWxsIGFs
bG93IGZvciBndWFyZGluZyBLVk0ncyBpbi1rZXJuZWwgSS9PDQo+IEFQSUMgYW5kIFBJQyBlbXVs
YXRpb24gd2l0aCBhIEtjb25maWcgd2l0aCBtaW5pbWFsICNpZmRlZnMuDQo+IA0KPiBObyBmdW5j
dGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bn
b29nbGUuY29tPg0KPiANCg0KQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNv
bT4NCg==

