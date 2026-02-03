Return-Path: <kvm+bounces-69989-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPhWD+7PgWl1JwMAu9opvQ
	(envelope-from <kvm+bounces-69989-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:37:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5CEBD7CBA
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 39CB33003341
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 10:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CE1274643;
	Tue,  3 Feb 2026 10:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4j3cZw3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA126A1A7;
	Tue,  3 Feb 2026 10:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770114986; cv=fail; b=pdmtefjFz0Y0XfIlgiK3NnG25m/lA//s0c9f5cFb3aTQW/JIjjulsvlPubuB/iAM4F8aWX/khED8E67vA0Fl58utSpvwsrh8rUE59VT3N3TRH/9tu1kjx3ZaM3S/G1PkyPbYnaBeUjRqwQJkowKeZoA1a4BRYGlBnPNUyq16kH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770114986; c=relaxed/simple;
	bh=b2SG7t4fjzsMPk2UvSm50td7aH2TN68FO34COVaw71Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WRopx6FmHM3gWoCSK4ekfi3M1Ouems+geH0TYpXugYQ2HK0bV1uCcMzXAMpzbv+vvj24kOv3mzXA/0bMJcFYAdma3QLh8Uuifdt2Q9AxueQ6LsaSbMJnlJvkVi7tzj4S3cNb23RBWuY4a5D5KlRcQMiJQjc+4FWmRPuAm7TYLXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4j3cZw3; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770114985; x=1801650985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b2SG7t4fjzsMPk2UvSm50td7aH2TN68FO34COVaw71Q=;
  b=E4j3cZw3h90TbCinQYPKgs6zZaiA0mSlgXAnXx8/xvHtumqVMKYhXg96
   0lHA1lDqFuXmg08y4FBiikD9Hna+f1l2OTzpSah+y1nygITyqSC3LQ9FX
   ZxchFqamCZQMPRvdvGguJOlBncXfGHbcE7VnxnhzvyFRMofMSEsM9Esp7
   fj/QlQ46a+iCepcxOvLBGz51+RbbGlU5UxCMUn1i6h5i3a5Uaqfi+R18p
   B7P3eFbHK0yWP4iQ+D4HEABiFaQzNTBKHlWIIWQEwxnkBRyIbqP0F/8D6
   0VdlO4bEuK+5hDJ9zP/f/L7sWsODKug9d+PaE551yeGqia6VdSMLbm9ss
   w==;
X-CSE-ConnectionGUID: axcjNwRoRy2X+R9TcrPI1Q==
X-CSE-MsgGUID: VVlskJIjRH2h0Bo1N6ph1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="75139634"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="75139634"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:36:24 -0800
X-CSE-ConnectionGUID: 4aWmdOB2QHyRIqPY5YTjXA==
X-CSE-MsgGUID: ziy1EWwhRByLp6C2n+zJtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209902053"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:36:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:36:23 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 02:36:23 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.10) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:36:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=InvAckqMSoaczhsSj+l9Hyxgpn7hnReqr9hJZCLXBBhqF0P6BZmsSjJmzvS7B1jRstxDTSnz/J8WC9wTZSbgv1F7qNvx2SMH+LrWKfgGJLJHftgFyoQ1KMFjuJLCV1PimvigCRC5pnIptz1G/XnEcm6sv6XUKsLfMc38ZePovxDGq5Qw/1Nt09ygYxm4EI0BNM+CkO+KGlD4NjnN72BFXlb1d+29XfE5Xz0Eg3kRm+QgYtPa6wtDU8s9Cxg2WwAKMw2jh3TV4iw4ja+7AyLBggmTBNVZDBM3AMILN7PWKdyXODqmyldPcAgY1e8eBcrd4wjSfMnLXjNfwKRkeRqBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2SG7t4fjzsMPk2UvSm50td7aH2TN68FO34COVaw71Q=;
 b=FJJLaGx6dgxfYtJfwWyWgwbadiJz4j+tPG205JPy0F5ei7ozryul7mTFCG0e5JUK7SDNpZumBYPfvYCnzTgIjI4/5MV3wywIVyyjPopgqoU5qhY1kX8nmKyuWuoBvEMJIzqEBr32+mmi5uwwz1RdD1xBrUOJCCow3KBKYPfTfQJFObZb3qy5G1PePLJCvxKIhxVM+4JKGiwkgy5WuYdXnVZq+v+6155q1em9+qbcL0Bbnw/Bw5oJqgKf5SGlOfwql6UGCMbN3nWljZE2NqRQeAFNRox6kKwtxvYgkiVkxOjd4KDvIsxSTfJHQoXJMQRXiNOPA2ZpTZIwbHTNnI/ibw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH7PR11MB6955.namprd11.prod.outlook.com (2603:10b6:510:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 10:36:15 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 10:36:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 03/45] KVM: TDX: Account all non-transient page
 allocations for per-TD structures
Thread-Topic: [RFC PATCH v5 03/45] KVM: TDX: Account all non-transient page
 allocations for per-TD structures
Thread-Index: AQHckLzOP3azn81YCkKfsGqBZvJosLVw0FsA
Date: Tue, 3 Feb 2026 10:36:14 +0000
Message-ID: <fd2a286aec5fc94d0ccfa8c13819b322b5b52aa1.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-4-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH7PR11MB6955:EE_
x-ms-office365-filtering-correlation-id: 9136e4d6-e4d8-471a-37c3-08de63100e37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YllZQ3ljSUMwNGpmRGV6L1M0K0RYQ0dFY0FLRmg0VmgzU0I0SFhRWGJRcThi?=
 =?utf-8?B?QTNKRHN4MzhlUHd0ZURJSllRQ0RmQzRkRllQeHFIa3pJMEFzdXczWkNKNUV2?=
 =?utf-8?B?N3Z3QkFmQ1BFRUpkdlhhMENQQ0kwQzZVNnRRdkgzQi9WN1VVTzhIeXBUMGQv?=
 =?utf-8?B?QXZKallmdEVDTGUzcUd3S1Z5WCt1QW5IbU5McFBnNThoUStiOEtoTkNod3Js?=
 =?utf-8?B?bFVDSmw5NFlUc1BaVVZQQ3BtWmFDcU90WVRlQU1NS1VTUWZwWk5lclhjeWVs?=
 =?utf-8?B?aFRDdWw2TGJKSTNQSVpRcG5JZStkM05meGcwUXM5cVNld2Nya082VkEybXo3?=
 =?utf-8?B?ejVFcElXTTk4b1huNlM4OGlKdWNPakJOVTJlZTgxU3c4R29maHUvdUZ4WnZt?=
 =?utf-8?B?NGFRVWpmVlJOdXJ3UXdDN2ZjWkwyVjdHTWxQR0Q3aVJZdVg2TmxBYjBFU0Fn?=
 =?utf-8?B?aE1zL0dReHhsalp6TU52b05ORDN5MythVmt4ZS9Dc3lnODBWNUdvRFl2c2Va?=
 =?utf-8?B?dzc1Y2dOT1dvWW5KVEN1QkN2ZEl2Q0pJSUcwRG40d2NwRTdoM2k2eDY4eklU?=
 =?utf-8?B?R1ppVy9IWEtZb3VhMURqSlg1dWQ5RksyMnYzVWwrZWkvaGFCa3RWMmZMckRW?=
 =?utf-8?B?cDEzNENKaVdjTTkwZlpDNGVNOXhZL0lGd1ZnbndvSUNoaGEyT3B4MG1UbWRL?=
 =?utf-8?B?WlU2MXdBWGkxY1BmeDNkYU5SbE96RUFZaWtpT253Qk5jZ1hCY2RlaFdsYjFm?=
 =?utf-8?B?SUp3dFN5U0hwS1ovZVBTSzFGNDluOTJrMGxkb0J0V09WWEpuazlKbVZad2Zu?=
 =?utf-8?B?VHZHb2R0NXZzY01BdTk5dTdaclhQTnl0Z0RlWG5HU29yaHpvSncwSWRmZXg4?=
 =?utf-8?B?VmRmMnVpMjB3U0h3VVZ5b1haWjhrcmdMTUQ3elJqS0hpdDhrZGgxY3MvakNu?=
 =?utf-8?B?R2llbi9pR2t6bzJiVW5kdGxzK0phZy9LSk93Rlp3Qys2OGxQcUJEb2tJQW4v?=
 =?utf-8?B?M0plLzhYVFAvLzJmeFRkYllOZ1NuMmZoWGxUTXdYbEJhZWRkdDBBTWhud2wy?=
 =?utf-8?B?UDVmZEl0djhUUDEzT3VuVFFBbjRNbFNYUXFuWWh5QmVrSVN5Z254Q00yWGtx?=
 =?utf-8?B?UEc1bVZJN01aUVpqOXhZOWhWREc0NG45WlhQb2NPeDdJbmF0dVhpaVpySUIw?=
 =?utf-8?B?cW5SaVh5aEw4TUtRa2tDN0lBalVqV0ZBeHMwRVdScVp2ZitYdkdQaDJ1QTNy?=
 =?utf-8?B?dFM0Rk1SYmZzLzI2RDI3SHFXTjBOamR5djdlcEZwQUxpYURCT1RGQUZ6ZnBU?=
 =?utf-8?B?WG56eDlxeVdPUGdtblRySzZWb0lBVjdic2ZBS3YyVC83dVhmTXA5Vyt2cUVs?=
 =?utf-8?B?Z0ZkRlJSSDhqK3NvMXdoQlRhMFd5bE1KL3NyaE9UNFBTTXh1cVQvN3c5ZXZM?=
 =?utf-8?B?emplNExEZzF3d3BibHZka2FEVU1nZzhvTHdRdlZNbERmblFhMm9ETEJXWHlF?=
 =?utf-8?B?NXRlQkdFMWRaY2pKNkZyN0xxSjg2Z3ZINXJxL0FmS2J2NjJobGN3akZud1Bs?=
 =?utf-8?B?b21yd0dHcmdyeDBwREh3T2ZuNTBCR2MvKzY3QmFVYVpmR3cwUzVZU2prQTdE?=
 =?utf-8?B?YytOdXZTcTVSRVBWY01DaGtEV3JTaEZVdmZJSHZKbUFLRG92ZXhISmVCWW9s?=
 =?utf-8?B?RzY0WUFmTVdWMm5SSXh2aGtWUC9xMVVLeTk2cUhndUpzY29Sc3pvYXgxWnRn?=
 =?utf-8?B?akVvOHdwNGtScDFEYVllOWw5M292anNpSkNHaXRIQnltS20zTlpCbmNkT29m?=
 =?utf-8?B?Z0FuVzhpRDBIcDRWanFpMEV3Zkg1a3pwTVRjWmF3bTc5UTBXVEFWVEpYMWJJ?=
 =?utf-8?B?RW1GUXhEeVVVbW9PM004UStMSkdnNUxGaWFLUzRGNS9kY3NnY3RCR3UrbTNZ?=
 =?utf-8?B?cFN6RXJSK2NEWFdiQ2FkemZsaXZBdmp0VUpqM0VEbDVvdWNSQkVocGJXY3Ir?=
 =?utf-8?B?Z3VIM0t5TEZsdkVLZDhMaUdjUUs2MjVSTW5UOFRXbHM5T2JPS0ZXZkwzbkdX?=
 =?utf-8?B?emxuM2VwNlRkajB1OWQ4UnljL3NNWjE5ZlErY3JwNUVIY0F5ektMVjZlZVRK?=
 =?utf-8?B?M2h0UFVYY3FDZHgxZTdyTHd1c0E0cVZSL1F1NHdjSkhnZDN1ajdnc2pqNDJr?=
 =?utf-8?Q?JNcn4NexW6OXQEVgndiHOD4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1cwRTFGcU9PbDlnVlRZdCtpNlhURlUrMjlKZ08vUENwaVVzUDYxUHoxQkxC?=
 =?utf-8?B?bUpTMEhEaEpXK0FLMXJva2tzdE9sdmZ1cE1YSjBXejNEcGNxTTJHS2tSWHR3?=
 =?utf-8?B?NkJQUitFUXF5c1ByTUZNVThPMmhxa0xEemtFQmh0Y3FTMHNEQzY5ZzVNNDF2?=
 =?utf-8?B?eUxUbERUOGpEdnozbkdEeHkxdDBQOE5OZ2VDQjI1MlVyU1NGOUYxN0lycTBI?=
 =?utf-8?B?WU9zS1JwTmswak5YL0pHRi9DVHhWdmhsNVQ5QXJNOXYzY3ppNEZ6WkxHTy9h?=
 =?utf-8?B?aFFreGJVa0hJVkdrcmNWeXhiTWVOMGJsNXlubU1vU3dKWlN3SitXZEN2b2l5?=
 =?utf-8?B?SEJvZVZtZU9taDZXVmNudTJEdFhvU1llNFZGSWIrNWhGL3cvTVRQUUFidmph?=
 =?utf-8?B?Qjd2dE4vdHlCeEQvV0ZNWno0ZGE4a1podXFLeXkvMlJoWTRscjZCb2l3ZUF5?=
 =?utf-8?B?dCtOQ3oxTmVkWHlqNTVIYXNDcjYvVWU3cUN6VFpLeG9mYXF3Rm5FY1VTWXJu?=
 =?utf-8?B?aWZqQ3Fvek80QzB4dTYzekQyUERvc3gzb1VVRlNnNDJrQVdtZGgvWURyTHNC?=
 =?utf-8?B?YVFwSVVZVzRBTDBheFNIcStuK2JLT0NXNkRZS2lQa1NLV0R6YzlaeDZTVUwv?=
 =?utf-8?B?bEU5dkJyVGVrZm53WnFKcTQveFp2Y1JJWWxrZSswU0xObGVnUTV5ZUJIMEJP?=
 =?utf-8?B?NUovekhybE5MRWtkS05QczUyUy9wU2hPcktWZ0wvWm1EUGJreVN5NlY1aHly?=
 =?utf-8?B?WlorUzhIcmUrVU5VUUs1N1BMSTM5dlNVVVpYZG14RSthUlk2OGZBMTJya0Zj?=
 =?utf-8?B?Q1J3MGdnT0N3WHMwN09zVHpsSkJtczBJYVUycVNkc1JNWTNDZ0FEdUtPOHRO?=
 =?utf-8?B?OHBSNnFINnlLVmFrQTAvbTU2cFJtOENkVzdmREhIQjBoMUUzdGxmcjFSUUpB?=
 =?utf-8?B?RkhWUFRpK0xLZ3FicHVRYjNwZTJ3Q0xHRlZrR1NuekZKSVV5QzJrS2lFU0pU?=
 =?utf-8?B?MlU3YXdlMFltNGt0YnM5K2NPRFBOS2NOSFh4RUo1QlZRWFl3L2NvSnBVQTRS?=
 =?utf-8?B?NXhuN3FNbXJuQUR3SlhnKzVjYThIcEZrSHBzYk9JclFXOEdWcE5MbnA0c3Uv?=
 =?utf-8?B?Qms1WE9xbFo3TldxbXc1OCsrUnBIeEx6YkVLcFVKeEZUeUM0WXlMajNiUEFI?=
 =?utf-8?B?Q1ZJZXlRczZaYXd1WnJLT01NRDJWUW5CWExuaThRSXFqc28zVFcrRENoK1d6?=
 =?utf-8?B?ZGFXTTFLa2xNSHpqUWNrVDlXcDVPY0dCajE2K0grOXJjU0Q3WDNTWTlEYWhB?=
 =?utf-8?B?TTZQSG5XT3FPbktRaVlkakNoQnhKamtjY3JjVlBYelFUKzBKWm11MnVrWFdt?=
 =?utf-8?B?blBUdW5lVnVqRHVuTmprRHUzMGhOL3dPS1F5S1cxT3lsQ1F4MGdUY1QvS3Jk?=
 =?utf-8?B?bnlLM09kK1lBYUdQM2tVbzFmQkZjOE5NbDdVY3JPMjZnTDBpbUNPRFU4TFZD?=
 =?utf-8?B?cG9xbmxyNDAwUGJGRXJqWEM1Z1d5WGo1cG1LNXRDNEhXTGdaQjZDSi8vWHV0?=
 =?utf-8?B?ZGZTbHFaeFRLdTZpd3hXUlFUcG8rMWt2MUFSblBBaFhGRERYWG1YTTZwb3Fj?=
 =?utf-8?B?VWFwdGZpQzdQeXdLZHhPR09jSUM3ZDNjUzVEU05VYXpHbkl6NGo0R0hKMzFE?=
 =?utf-8?B?UFZQa01HU3VCQzFuV3pldUpNUG9TZDBpemg1clNPNWNkUjIrNmJSMUYvSmdJ?=
 =?utf-8?B?SWljZzJnSGRTMjB4OGVDNUtocjdmZTBoNk1RTjhVL3FjcTFxSlAzeG9NbnZj?=
 =?utf-8?B?T1d2YXdCMk5TOWl6QWJRQ3NINkc5cDN0bHRrekp3eXJISWdJVmhoR2dTKzhj?=
 =?utf-8?B?aGtwQ1ViNWM5dEgrUEpSV3A3V2E0U1ViRCt4VzRJdEhVeHJ4Qm9aTXQ5Y1VT?=
 =?utf-8?B?MitBNzNVTjlZRVJaY3dwQmlha3N0YUJKNjRjUmxqQUExNWVWZ3pRTUdGaGhK?=
 =?utf-8?B?T3FvV09BSEMxY2hRTjc1UWdpRk5TR1hORDRSNUsrMGR4NU9NMUQvamdnRE93?=
 =?utf-8?B?aGp2WUUvM1dyd2UrWmdySFQ2Tnc4azk4Wm81VjFQd2hMYmJiYmVKUHdvcmpq?=
 =?utf-8?B?N1RCSWRoM1RDRVpEMm5VUm1xaUxtZXhOQWovc3NJNEVlS0pxTWlhZ1duQXZq?=
 =?utf-8?B?ZVpXRnJpaGFZN2VLS2VvektvSnpnem4rWEo0Z2JMVVNUT1orL0M1SlNOSGd6?=
 =?utf-8?B?WGVWQ2hHN1F0cVhMSlkwQytqbnl0Q2JCRVp2M0EvaXBmS3gzc29qZUxIZDdL?=
 =?utf-8?B?aFB3WVVKWm9KQWtoVEtsa3oxckdScmhMWVl0T1RPemJpYUltZHNPQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEADE5652205A24D8F793BB562550505@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9136e4d6-e4d8-471a-37c3-08de63100e37
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 10:36:14.1699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EvXjxD6DVzs4Chm5Hf7ef8jquAgw111mSbRY2SQVCFUfdjXuYnB77/WMmgnODHGcJiV4ZVpCrOymAANOSP2T/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6955
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69989-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D5CEBD7CBA
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBY2NvdW50IGFsbCBub24tdHJhbnNpZW50IGFsbG9jYXRpb25zIGFzc29jaWF0ZWQg
d2l0aCBhIHNpbmdsZSBURCAob3IgaXRzDQo+IHZDUFVzKSwgYXMgS1ZNJ3MgQUJJIGlzIHRoYXQg
YWxsb2NhdGlvbnMgdGhhdCBhcmUgYWN0aXZlIGZvciB0aGUgbGlmZXRpbWUNCj4gb2YgYSBWTSBh
cmUgYWNjb3VudGVkLiAgTGVhdmUgdGVtcG9yYXJ5IGFsbG9jYXRpb25zLCBpLmUuIGFsbG9jYXRp
b25zIHRoYXQNCj4gYXJlIGZyZWVkIHdpdGhpbiBhIHNpbmdsZSBmdW5jdGlvbi9pb2N0bCwgdW5h
Y2NvdW50ZWQsIHRvIGFnYWluIGFsaWduIHdpdGgNCj4gS1ZNJ3MgZXhpc3RpbmcgYmVoYXZpb3Is
IGUuZy4gc2VlIGNvbW1pdCBkZDEwMzQwN2NhMzEgKCJLVk06IFg4NjogUmVtb3ZlDQo+IHVubmVj
ZXNzYXJ5IEdGUF9LRVJORUxfQUNDT1VOVCBmb3IgdGVtcG9yYXJ5IHZhcmlhYmxlcyIpLg0KPiAN
Cj4gRml4ZXM6IDhkMDMyYjY4M2MyOSAoIktWTTogVERYOiBjcmVhdGUvZGVzdHJveSBWTSBzdHJ1
Y3R1cmUiKQ0KPiBGaXhlczogYTUwZjY3M2YyNWUwICgiS1ZNOiBURFg6IERvIFREWCBzcGVjaWZp
YyB2Y3B1IGluaXRpYWxpemF0aW9uIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4g
U2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+
IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

