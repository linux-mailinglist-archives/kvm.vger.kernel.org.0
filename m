Return-Path: <kvm+bounces-58980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46044BA8E42
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0A231C237D
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640942FBE03;
	Mon, 29 Sep 2025 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cGHndxnF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12842FBDE1
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759141827; cv=fail; b=ZOHktcPk6yAaSlL5WxrFMJGjtjlM0bysBkcIqQj/aY86+N6pKKEthd7rNk5YkfM8DlQ1DTVtOfZmMQCGiLilCCUyK6nDsobdqTQqIsGnMTtQyy0m3emb8a9pTGBFW+tFnrO9QjxK6Sjtp8OnN5mslpbiKJzKRn26T4ruB9ZXP9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759141827; c=relaxed/simple;
	bh=808MMnLK355b9FtYgjBxv1gmKXU4rq1W8fZ7jyzdNnU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p+r/RP5GUTzssbAkLQKIsuucZpQG4adfY2BypfeWKFNnmtceH8rZDltw0eAiZ7uhOVi482i8dhZvpFtegD+gApOfQ0igskJ7Ae6ktc2pv2fqWJno7RZWilSkDUwf0W9dkojTrwLId5/9cFF/KJB1yeZz0DWBSjR/+aGuj5t2XLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cGHndxnF; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759141826; x=1790677826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=808MMnLK355b9FtYgjBxv1gmKXU4rq1W8fZ7jyzdNnU=;
  b=cGHndxnFlAm7tCeHT0GWy4oMaUJSuXOJ11ryEBFf/OeMYKqO1qPFq3Ut
   kn0UFAyseaAPKZtB5D7bHFLrUV+Izkmu8/kwAKQssfZNs5OWpVknYpu/k
   qn5WqFjAL2IWYNl0UqpAoGs0eUS+iqaL0fUxNJsoyh3LH23bYx6Qa75uI
   yg9BjO6VT63zr/F8WnBKUBjG8B0mso01kytOhAM5m8Fy2AfCVKvcwy4hj
   bQhThGHpEiRFkco2g3ZnsMWUzDCMGJ3aYqgBCH1TnKRkcSEmbrS9LrjQ3
   Bv2zeAjSfxGxf+UwzDVezNUg2Lfr54PYUAvkxEAonz1hqYIVDNlLYRxwr
   Q==;
X-CSE-ConnectionGUID: V55BjJXQQhq9U4VnclBs3w==
X-CSE-MsgGUID: 0TZKKKz0R8ycR6SAMRzvgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="61269195"
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="61269195"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 03:30:25 -0700
X-CSE-ConnectionGUID: nTbLt3SzRJmFqDa3bvZR9w==
X-CSE-MsgGUID: D5cRxXRyR1K/nEBQJpu3jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="178141980"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 03:30:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 03:30:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 03:30:23 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.30) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 03:30:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3aLEThZ94gBXjd9bK6YuIm5rBWABn93X9HdoeBpDdbOuTGLR8lqUCZiYJ0O7WaB1TOlDyn/HvfDaKffe43a/atRm9LoB+Wzr0hR0tYcBnCoTQAngoHJRtwN3gyIVyyRHh1QXracQn6gb40Fkol8pGTPemJe7KzadjIKNDTGQkHcEzqZleykiE9Yze8Ppb5wsef7wyUcOkOvVRQu6jrM/6sFsa9KXsl00iLOk2VUt4+W2ThnemUTZ+vSk5j6oU2zLGLfVSCs+mWQz5bDWhnFDlJDLWxWcxP6JPw7j2gOwVF7bcaMuX/wmc4EDPmzwy0ZTzicQ74Mnst7z2cd1VddKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=808MMnLK355b9FtYgjBxv1gmKXU4rq1W8fZ7jyzdNnU=;
 b=yee2jhSwFCB7O9Vtc+F78QgA+wuNeVDHCRDTc5+MvN3E/ROs1JWHGnd5Vh9okKDl+i+4K/KwytHuBaVjEF/dIK/MrML4GdvRo/IkXDEh3qLswAIaA2zPuQbh2ICJL0namrk7VjhQ//UUDW8nUPwMldOwXRJ9xjM415XivmmErLn3NC7dsldr278bs0XwI3J1UV+e5zceZsXgFOuBAzzQsisunagJ7iaoonY617fOyXysp38MTG2jzhX+rWBaV2bFf1i8r0r7+RzlrQZoIpeloNdINEspLUv6rkDNKkfx//xhp58C1o070NKNHguxaz2cqe4uR6qpcaX6eHgevWU+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM6PR11MB4531.namprd11.prod.outlook.com (2603:10b6:5:2a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 10:30:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 10:30:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcLgTMyh3xhUUVqkqcHNC9xdPIQrSpaEaAgAB4ZgCAABtjgA==
Date: Mon, 29 Sep 2025 10:30:21 +0000
Message-ID: <0d1baaecc56de2b77f82ab3af9c75a12be91d6b2.camel@intel.com>
References: <20250925101052.1868431-1-nikunj@amd.com>
	 <20250925101052.1868431-6-nikunj@amd.com>
	 <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
	 <2b2ebc13-e4cd-4a05-98bf-8ca3959fb138@amd.com>
In-Reply-To: <2b2ebc13-e4cd-4a05-98bf-8ca3959fb138@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM6PR11MB4531:EE_
x-ms-office365-filtering-correlation-id: d6ef2c4f-2f49-4452-ea15-08ddff433171
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?clVRcHd2MTJsc21maERMR3B1OU9GaVZuc1M1VzJVdWVBTlBvWnBIVWwrYnRz?=
 =?utf-8?B?NGF3ZnpXY3VrRE9WL3ZMTFVmOG1hVytYOG5uUFljbVZ3cGJJN09DSGlCSG9j?=
 =?utf-8?B?SVRrc1hmaXJQWG1LYjR1ZFhDdlFKVUpzNGlJcXlEcFFYL3JTa3JGZUpBQVo4?=
 =?utf-8?B?TlFQMW02ZE5jdEtJVjJndnA5VVdRa05sR2Ixck44M1dwcXJqU0pnNkIxeEg5?=
 =?utf-8?B?VHlFck9qQkVubDI2dFFnM2c5VmFUQmgyOTZRODE4dVB6YkF1WkZNZzZyRFNs?=
 =?utf-8?B?T2s4YlU4NUk3S0hQbUs0OWM2bVBmZHE5SGFxTlJKUGhKVXJnZUNFUVo0WSta?=
 =?utf-8?B?TGxIMWphWmdxN3kyV21lOUNOUDFvSit4eUZpcCtNdGY5U1VLMy9OZ0ZqOWc3?=
 =?utf-8?B?VGdBY3lVU1dialQ1RE45RzRWRlpwY0pkOEdJOE5PMldPVmVnNEZzejVsYTh0?=
 =?utf-8?B?ZGMyV0grWXFlaE1USkZCUzBTSzMzT2RPZ1JUemVVdEQ1WUVJMkhiNzJVWWE2?=
 =?utf-8?B?S2NZQm50L2ZVNG9iMXlNTjhRRldKUENqajJkVmc1YkV0Z0o3RW9US3d3ZDN1?=
 =?utf-8?B?VkJUYjV6SnJMWDM1eER4VmI1WHpFQllEdVBwejJadzVaS2hZbXF2cHlTczZv?=
 =?utf-8?B?RTZSYXVvcEtTVXFkOGhqTEhHMmtzdWFGM0pGaThnUXY4cHZWdDMwSWNiaDNK?=
 =?utf-8?B?dktQTllGY0lLTjRsVjdHRm96MG1lOEtMamZudkN6WnpyQXRPTFE4Nmk3OVZ0?=
 =?utf-8?B?a3BCcXlnWGVVR0lSR28yUXB0MjhubkpwbU8rb1o5a05XU2lkVEsrbXQva0hh?=
 =?utf-8?B?N01MeHNOUnFzeFc1SWo1YncyTGYzalk0L2dFOFp3clJjYTluclpXdTRVbWFs?=
 =?utf-8?B?dUlVdGVMSXkxWWxZYjY5dU9oWTJ2MU5PTUNlbkh2eGNCaDJOQUkrZERyNjN6?=
 =?utf-8?B?bTF3MUwvcFFqVlFPczlXUVlJYXY0OGU5ZkZyWXVkSTBPMURXM2l1SnA4V2Jw?=
 =?utf-8?B?V3pLa291czNJTXg2UUZ2bW9YdFp6RDM0MUZBcVJRK2RpbEIwMXptM05KRTFX?=
 =?utf-8?B?YlE0N1crUU4zQ3dtNE1QMjM4QTZ1RG9JbUo2dUhNN01NZkFqbFlGVm85elBy?=
 =?utf-8?B?YTZuTHl2ZG5CaXhOQjJxTEdETlRzanBXekZMeTNwdHN5ZlZPWVIxckYxNjBQ?=
 =?utf-8?B?U3pFVWs0U0tpcFpwaWk0UWEwS3BjeXZlSWtsRS9TdFNhZVEwUG1PWUNva0I0?=
 =?utf-8?B?OEUyWU1qb0JBMUZhUUpYbkdZYVEvL1VkNmhqUHMrV0dnbkpkY2lFclM2bmZ6?=
 =?utf-8?B?M09mVHFQbVRXUERpYXptT2FwVlZWOGRUWkRMczVXWEwwZ0J2Q0ZYSlV5VVdm?=
 =?utf-8?B?QVcvSVJQb0JzQlN4SDcwaGRJL2FnWDdYTEFuWUo4NFVmdFhOcGltSU9FdXZy?=
 =?utf-8?B?a1p6K1ZrM0htWmFKK1BNTjJWcFJ1UTFQNjdQRzVkZnVPcjM2cVFPM3h1c3RO?=
 =?utf-8?B?SFY3V2hZNWRnR0MyVVdDQkp4MDNJaWQwNFhWeGNhTkFQQk5nc1V2K1Ixc3BU?=
 =?utf-8?B?VFMzS2JQbmFqY0MvVGZsZ1lEcEFJLzMwTGt2d1FITmh1UjU2U2MveU50US9D?=
 =?utf-8?B?c3B2bTZMV3JMc2NKTm44QkpCR3FOdkl6czdzUW1EK1pRM3dBOEgzVVZpa25Y?=
 =?utf-8?B?OVUwa2dmai81SktUb1hseW52a1YyTUJSS0NBRE0vYU1PZXlRb2lWSEZPNDUy?=
 =?utf-8?B?RDN5YnViVHI1UWdnQ3NadjF0MGV0cVZLRXdnbnNRT0s5WUdPQVdNOWp4SGRC?=
 =?utf-8?B?eDZ3eCtaSkw3U2dSaXdkWGJJbWVlUUJDVU1vbk5oSm5FTndra0JMUm5xNkox?=
 =?utf-8?B?eVhteUlHZDY0ZXdhMW9mMUFSR21STlU2L2Fzd09melQ3TFZZQlhZRHFFZUJu?=
 =?utf-8?B?elo3Ty9yVlU0SFVKemk2NzdmUEs3bkRoOGRTUFZWWWdHVnpkLzFGL1hHTXR2?=
 =?utf-8?B?V2tldFNlYndjeU50eFhZZndQT2hKd1huVFFKQTZncHVRL3FZYUdOV2xmNjJK?=
 =?utf-8?Q?jTm3bL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUd6MVpkd2JUTFlhcTVMZnFST0szT2x1QjRKc25Fa2Joc1ZFSGluT2hUQ1RN?=
 =?utf-8?B?THowSGZqUCtmUXZjMDI4QkoxMlM5SCtjRGpieTI5UzYyZVRiRnZxQXUxazI1?=
 =?utf-8?B?clA5N21XMVh2MDlUWjRmcXJRRHVJTi9sdVBxZGU0MmhRZzBIbUU4V0RQbitr?=
 =?utf-8?B?bWxVb1BrNDR4UHZveUs5Wjh2T0VJdjE5OGFmeVBxbTU1dWVBbWRIZXljcHpR?=
 =?utf-8?B?WUwyLzVFb3BWb2x1MCs1VzJ5cXlBd0hSR1NuVlNqeEdQSGJCYWc3QXM5TEhN?=
 =?utf-8?B?Y1BnNTJYQ2tzS1Q2WmI3TG1tcW8rbU5XUHdEZlpsTWY4cDZ1S2owTENrWVpn?=
 =?utf-8?B?N3l4UGVoS2tzMERtOGhUdGdwbXpLelZDTHZrVFZRSHNmYTdWMHdmWjRwc3di?=
 =?utf-8?B?eU1rbUd6aVNRWkFCZFhDdkVqY25HZ0lURnJQYkl0NWI1b1dOV1BhZkd2UVRY?=
 =?utf-8?B?eVlUekowbkh2WEx4T2FtOXZ3T1N0b3JrOTRpUzdocVZmcXVXZFR5Ny9sWnZE?=
 =?utf-8?B?UnQ3bGFNUW55RUVtWkphTVE3MzZRQlcwaFdxRW1weG50ZG1YdlBabHVwSmhO?=
 =?utf-8?B?d0xqU2NjdmRDM2o0VFRRVlRCRXZXZVBHM1YvSTdVbEdTdThHY3c0dnBhNEg5?=
 =?utf-8?B?YWlYdWw4YTNaNUMyQmVmME4vMmM0VEdXK0VTYkhwOFg5a2V6LzN4b2lRNTFU?=
 =?utf-8?B?b2VkdTVaaTN2Y0VDbXRJaW41WEVBSnhnbUhZKzNUQ09qMFo5dWhBc0tCUS9D?=
 =?utf-8?B?eDQzb2pqajdOYWVqVUdqZ3dMZ3Z2MS9PWWNmR2FDYS9FaGh5NWNFODQxNEtP?=
 =?utf-8?B?bm40ZHlqRm40ZW9LZHVTQVVEdE9QMURtaUQ0L0RaeWE4c2ZvU0Q4a2EwblN4?=
 =?utf-8?B?VW5kbVAzUjIwUFJMK05nNzMxUldiUkx1dTIzZFI2VDh2eXY4bzVVSDhqS0h4?=
 =?utf-8?B?em5PVUtaNkNxUUVpaUtFaUJBc0dYLytoUzFuYzhBMjZadmZ4amxqY2pQRTla?=
 =?utf-8?B?N1lNZ3Qyc1lRUFJBMGk3RXc1c0ZVOGZsZzAvSU9JRnlEcHpjUHRrbHdTUkdu?=
 =?utf-8?B?cDJBME9VSThVTTBpYkRKVzZPUndDbFZBZ3VNanFJdjNKWDN5QzVwMlpBQ0Fo?=
 =?utf-8?B?OWlXbVMwNEh4NExsUUdvdUNKbjRlREdrMzdSVG1YZ3B6a2RiU2Ewa0tYT3Nh?=
 =?utf-8?B?UEgvYk03cG8xUHM5ZU5oUCtNdnRqaE4veGxSUXhPRVAxeDd3R2ZmTnJIck1J?=
 =?utf-8?B?anlsNzdLTGgyb1YzS2JoVDMzWUNqNUJQbmlia0RmVFhKV3ludDBhbXRZV0Vs?=
 =?utf-8?B?ZzVOUm5zUWdrSmJjMDZJMXEzZE83ejFHRG1IRm9jR2ZhZEZwNWVmcnlRaUhq?=
 =?utf-8?B?NUJmUjQyTnpXMy9DeWxsN2dBZ2RyY3Nvc2xib1NOZnZoRFQrVk9zVmwwQWI5?=
 =?utf-8?B?YlV0WEpLdkdwczZqS1RLTi9ZNS9hUFZBcDVXR00rN21DUDFjKy9tZUJOVVJu?=
 =?utf-8?B?eEVOWmJUbFJlQmZ2NkdCTk9JV3JWZjQwQmFuRE5Gb1lnbHVXRjNJMk10dkpX?=
 =?utf-8?B?RlRkMjlGWnF0TnhQVXp0NFkxVnRzUm9aZ0loY29pMkFmdTZqNk1FeW5jbnha?=
 =?utf-8?B?RGRxZE5zamJnOFJlMzBrTXdoODNKZ0FYTFh0NVVtdlZlNGdyMnhTZUFZUTJV?=
 =?utf-8?B?WXovamNlbkJBemxzZ1Ztd3B0MzJCNjRuKzVxTVBsQnk5c3h4T2tueFZKeGhQ?=
 =?utf-8?B?WnpGOUJvYmRnajBtTkhmUWNNVXNueUxnK0dVNTBKaWM3K1lYV0NwREFCODVj?=
 =?utf-8?B?K0l1Z2ZWdDEzKzlhWW9UTk5VOU1GREJrK0Y2NmdkaHRJZ3pGSmhwM1FXL0tQ?=
 =?utf-8?B?cSs2MXBWYXpWd2huRHJCNW1xcHJkdFhLSVk3MGs2MkEyRWxJcXpDVi9ZTldC?=
 =?utf-8?B?V0gzajRDQU5Jdlc5dE1FZWh3S3M1THQvT0QycFV3MXg3UUxqUFIzZ2VYaWRr?=
 =?utf-8?B?UnRRYi9FK1pOMXUxMFFOZGtkU0dXRlRHOC9kdmgxQTRVWEdPZURFU1ExZyto?=
 =?utf-8?B?eTMxUHpSRTR1MHFhajA3YUpmWDRmeGpQTnJORHBodnpkclFKYk14NmkrSnYr?=
 =?utf-8?Q?bIAFnfp0FOSRc+MbOQ63La1T/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46E1E84227A645419B980A87C41A11AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ef2c4f-2f49-4452-ea15-08ddff433171
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 10:30:21.3414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Os0AX9xuclEbV3Kz1ycaStTrqFCGxfOYMzUbrN0ep12toW77FmvOjn0gRwDmz99hdQRW5/AtNjWwOEk1w2kOIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4531
X-OriginatorOrg: intel.com

PiANCj4gSSB0ZXN0ZWQgdGhlIGFib3ZlIHBhdGNoIGFuZCBpdCBuZWVkZWQgZmV3IFNWTSBhbmQg
eDg2IGNoYW5nZXMsIGhlcmUgaXMgYQ0KPiBkaWZmIG9uIHRvcCBvZiB5b3VyIHBhdGNoIHRoYXQg
d29ya3Mgb24gU1ZNOg0KDQpBaCB0aGFua3MhICBJIGRpZCBidWlsZCB0ZXN0IGJ1dCBub3Qgc3Vy
ZSB3aHkgSSBtaXNzZWQgc29tZSBjaGFuZ2VzLg0KDQpbLi4uXQ0KDQo+IC0tLSBhL2FyY2gveDg2
L2t2bS9zdm0vc3ZtLmgNCj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uaA0KPiBAQCAtNTEs
NiArNTEsNyBAQCBleHRlcm4gYm9vbCBpbnRlcmNlcHRfc21pOw0KPiAgZXh0ZXJuIGJvb2wgeDJh
dmljX2VuYWJsZWQ7DQo+ICBleHRlcm4gYm9vbCB2bm1pOw0KPiAgZXh0ZXJuIGludCBsYnJ2Ow0K
PiArZXh0ZXJuIGJvb2wgX19yZWFkX21vc3RseSBlbmFibGVfcG1sOw0KDQpJIHRoaW5rIHRoaXMg
Y291bGQgYmUgaW4gPGFzbS9rdm1faG9zdC5oPiwgc2ltaWxhciB0byBlbmFibGVfYXBpY3Y/DQoN
ClZNWCBjb2RlIG5lZWRzIGl0IHRvby4NCg==

