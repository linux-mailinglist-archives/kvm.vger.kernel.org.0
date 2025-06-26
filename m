Return-Path: <kvm+bounces-50787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F66AE94F7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 06:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 063A21C26D35
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 04:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0410D21CA00;
	Thu, 26 Jun 2025 04:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i8VKSVHy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A818121882F;
	Thu, 26 Jun 2025 04:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750913299; cv=fail; b=eDrCMG/1avPDUTIGYyzXyPm0CFx/EOP44YF7hzM3DH9PcTL3Zxx51qUQlMrGjXhvW3jb52NR4xlfe1H6EiqR3uI5djwkVJhQMQvHXfLUJXiRy4NnmFHVgVcyvQ54gVWNaTfzaHEn5tuc0wXU3FFnLc91TGf1XtlEnXTRPV+ebnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750913299; c=relaxed/simple;
	bh=Y4dtYL7yVdAFFcy4KTS8SV8vFmv+hjhekbVV7dPkWxM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qz00JbnG8MNh3QCOFfnemnh7MavTJUsd62WpbRkrSHiK0eYG8mwSzaaxq9pEMBt0ap3dP0r1bi8xXODH/Cj3XDGO2k8FkUZrB3q0FtgUgutdHzYzVQ/H8uFmIAAx2NUiSmX7jWoFZ8rwk9+kiZN7qoHuT2O1RVCw/RIGqDmnD5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i8VKSVHy; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750913298; x=1782449298;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y4dtYL7yVdAFFcy4KTS8SV8vFmv+hjhekbVV7dPkWxM=;
  b=i8VKSVHyemGhc8YT2NeryIPB3TF/8sPb+VZVSyET87oIzbx68bebm1Er
   PYGeyH3zlrKcX7d7cg0w6hH3dKzzrcoZKIeMFePZ7reeCTZ3EvPY4RfyU
   AIwohgNSFNbv3RGawy/piCLmKUhf4qKFTcRLX5a0HXznxpZzrhVZxXSeX
   84h28g8QqhhLgvz1uWtQgy1RXNn5PZo6vGMg5ho1OQzFKMIfCI9ya4Nu4
   15+nAy1qHvFC1K52f0DTN27+X/aNmH6C0pJtNEO1bxlzTS0Mqi8vDdhAc
   ruOFHGCwsOw7o/jeMqUcs+tt9BVSlN3699FphTB8ZrCzNDfAXodo3BMxr
   A==;
X-CSE-ConnectionGUID: bi9J08CLQp2Ed/5iLyKXqQ==
X-CSE-MsgGUID: Ln06BEaGQu2BfjSpMVdkmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="52920513"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="52920513"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 21:48:18 -0700
X-CSE-ConnectionGUID: mvSlGrm5QUi2JALGNL7h0A==
X-CSE-MsgGUID: Z/v7vJ2jThyJlbHFzI/0qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152024993"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 21:48:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 21:48:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 21:48:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 21:48:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gB/QuhuIxsAgeVGUnRSBNzw1yGinrBez0WdEvRH+6kx52BYXzSzeW4A24eQYTtwjhJgXWcJMc/Irv1hV7pyyNFrfdl8KiESvlQBAHcdCF8aOLr9P6Rx0KTbgYlJRAWE/v8Rzw8g5ZLxJ0WHCBv77vADBgigCsExogCEuzLZerbW3Kf/068qWGxRfmTuMYy6kzy+v+Q7KNc4ivNSlHy3KyiBituDkh8byXtoQztSQwDcIgrG7oZ29PK6A9i8iUjZn2e2v9G2thAQvq30LSCsFy7sV9HPf2lPuCeRonAZ9MJ6tG5ejCm+kQGjDbbVl4VGqn2IEmtGjsxu3kXKTmE7m/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4dtYL7yVdAFFcy4KTS8SV8vFmv+hjhekbVV7dPkWxM=;
 b=nxtiC1jJ1jrBqGCgkeEyzuAKnIIJvwlPJP1hOrBKrYiskOCIKmmJRsaKaTz/z9V6wUr7UCb9lTNXXYP91w69Jjw5qw28PoxlPgBYrY35MoF0BCCgXPQfLq7UJnJdHTRXmxc+LAYnk3luKh792Q1TSO5us5+RTZU1RpEEzLM/f4DVNCIzbnD/w0YaIBt3ETqtxkqnosWE1vSafdYDUr+hlTzHhmLUPchCZKib/Pa4nbOXDJha/Fmb/iJVaCpRhzbWxdx79YWbRBBBRMxpY94HgnTG6MfXIrAqwZ5926VOad184zslSEtpeWX2bvO9km1Zjj9qVY+aZawf9PhhsnaUjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ2PR11MB7672.namprd11.prod.outlook.com (2603:10b6:a03:4cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Thu, 26 Jun
 2025 04:48:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 04:48:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [PATCHv2 03/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHb2XKrD1/c0Ot3oUKBt4hkqezw2bQUtooAgABBkIA=
Date: Thu, 26 Jun 2025 04:48:06 +0000
Message-ID: <8b25febfa5bd5ffcf2f092fd9a8914b4e6b2b5a3.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
		 <20250609191340.2051741-4-kirill.shutemov@linux.intel.com>
	 <104abe744282dba34456d467e4730058ec2e7d99.camel@intel.com>
In-Reply-To: <104abe744282dba34456d467e4730058ec2e7d99.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ2PR11MB7672:EE_
x-ms-office365-filtering-correlation-id: 655cc968-43e7-494c-b1c5-08ddb46ca49f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a3RXc2QzVnN3Si9rMGkrbDduNnpnaThRUTFsNkZleWk4QzhBMld4ZHh4bGVV?=
 =?utf-8?B?NnJXRGNPbmI2bXJIZjJMMmZVVUVZTVNwNFdDeGpLbFpPOUtWMUhRVXE5eTZC?=
 =?utf-8?B?MUd3ZHVxYkZXSldIdVErWU92VmJMSkx3UUdJcDhJRG1HZy9DMWxrclFXK0wx?=
 =?utf-8?B?TXBmeVNVZEI2ZGFUTmFGS2pTU3MvUHFVNHdjTVJqYVlIUzBXT29mOWdxVmF3?=
 =?utf-8?B?eVMvbWZqSDVSWlk4ZDREYTQ0VFFIRWM4d3draGNwaTZaUkFDaTBDZGZlNGZZ?=
 =?utf-8?B?cWhJSmJJMktGcTlpRVRKM1ZKWnRMNHlqNEEzQUFDMFMxNTltZGJDM0duSTYx?=
 =?utf-8?B?K2pYOEFKaFcydEVNN1Z3VlQyeG45Vy9aSDYzbUtnZ1FyU1BXcnVpMGprZDdj?=
 =?utf-8?B?OW9qVW56Qi9MTDVFNDhKaHdkS0F3YkIzak8yNGZWSlhZOFRvV0pBUFNFSlVB?=
 =?utf-8?B?cGFwY3kzaUQwNU96THVvMjRGekVHNCtZeVkzL01JSlFWYXZpdHR6eWxWdEl1?=
 =?utf-8?B?LzJZYWlHdDV5N3RSZnRwSE1Nc2JObHQ5emRrVFE2TXN3R2NVa21Za1VjVklF?=
 =?utf-8?B?NmJ0OFFtQXh5YlprK0dDQUxzNWM0UTdwZURzblF6MHJoK1UvQWJDcTRMa2pq?=
 =?utf-8?B?ZFY4MEFPem5MdHhFSXpBL0M5RDljT2xUekpJUmNkMXA3ZlFlK1czM1ZZbHJn?=
 =?utf-8?B?Q25rS1NiM2c3eU50Y3FNTkpzbVpubTdBV0ZtSG90YzR4VXpsU1gzWUxjcXZ0?=
 =?utf-8?B?T1ZEOUV1MU83eERUMmxSTGRqbGkwOGQxT3lHeHoyWFUxNlBIdDlqaW1UUHRN?=
 =?utf-8?B?c0lWeWU5dC9NYnBtSlI1NVg1bm5IR0E4TnZTdUdEQnh5N1QvZ0tyVjZBYTNH?=
 =?utf-8?B?SjVmSEcyOVdZVVFkclZDa2hMZnJOamVvMC9NUTFteW9oMVE2RmRSZUxNVElt?=
 =?utf-8?B?SldLN3A1NXphT1hZc2hGR2dqblBsTVExc1lRSldlek5tQi9oQjJNNmM4M2tY?=
 =?utf-8?B?bURud2h3TnA2R0FZcmN4MU9WaGZHSllka093WGJ4Y3dCcnJRa2tzV1hOZmhh?=
 =?utf-8?B?Yys2b0FJdUJmL0x1QThIUUFKMXlkRHNwSzYwS25TZWtVS1VmblNJWUh1YkhF?=
 =?utf-8?B?bGJUVjZsem9kZVNiYjR3b2EwZGVSZTFyalE0MGhuU05UMllwMkxxRkxBVEQ0?=
 =?utf-8?B?N3d3UmdNYWp4RGVHaEwwZmNPdzY3eWF4Zmtmd1hiUEZacVA0dk1KYUJRamRr?=
 =?utf-8?B?QjZydHNDV1N5eUZOcmxiWktPRmFNNnlLZmNnSnV5aEIybHg0WVFNQXhQdnZa?=
 =?utf-8?B?eURkdWFoR2hFdzZsdkR3djg0c0NkQWRLUjVPM1VDdWhXR3ZVdEM2Sng3WEQx?=
 =?utf-8?B?aS9MZ29McVRsUURSbk1rbUl1SGhtYzBKanN4NWtPdDF0L2pRY0FZZXZmTFc4?=
 =?utf-8?B?d0RRY2gwNWdtNSttdXdPUHBBN2JLZk1CMXAzV2lnNDZwU0R3a0szWHRoVHNL?=
 =?utf-8?B?TlNTRU82eFFXcU1NMWlNZ3ZkNU8yNFZiL3YvNVBxTVhCL2RONWJtOXZ0UFR5?=
 =?utf-8?B?ODZQdXFqTExib2owK0lrWndzNC82SXVRVCs2OEluY2UxTDVkVGs5Y1Q2bStL?=
 =?utf-8?B?bVd5SkpQTXFxaUJiclZadTUrZEx0ZDRkc1oxdTdZNXZ6YW5HeVBpZDFWczV2?=
 =?utf-8?B?OUtqc3cyMnhFY3EyVm1FYk0xYXRzQ3BkR0R1WmNtdFNtcVNRN04zK05ZQmFK?=
 =?utf-8?B?ekN1ZVhpZ1I2a1RjLzBkQVdoR0Y2WWdjV2lCTWhneG0xN2trdDlLaWVHeVNu?=
 =?utf-8?B?aDlUM1NkUUNGVVpwTDV2RVVNTjNROW44bGE0YTBSdjZoMkw1WXlFWlh1b01P?=
 =?utf-8?B?Zy9XVEp2RFFUSlVmSGtaUWxsNmFMNDVkS2RUcFJHVUFxZmNqWWxyMlc3a2hC?=
 =?utf-8?B?cllDUU4wdGVJcjhjeHV5NG55VDRDaWZjZFh1NzV1K2U0RXNqNXl5bXgzd2FJ?=
 =?utf-8?Q?IBt8hs4V/HxFTlS8rVGmRWX9iwYWv4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDcrZC9QdUszZGg0SDFoR2tkeFRBN2lUZGVJdmxFaW1aVHNWUndLMWswMzh6?=
 =?utf-8?B?b3Btbks5SHN5dWpPeTF6VFQ0RFdQV054R1pXMEVzQlg1SXZyemdFUnV4c054?=
 =?utf-8?B?SUxldDNKdHl0SmtvSFVYcjVNZkZLQS92MEJ4cVpRKzdveTE5S0hXMzVHUlJr?=
 =?utf-8?B?UjZpOXBLVE52NUFDMGI3ckpCSWxuMXZYSGErZzhQckpRK043akNBZVkwc2tV?=
 =?utf-8?B?OVZKTHd3K1BXS3ZIQU9vUk03cUNEYmsyV1lzV2RleUthc0d4dUdqaDMxWVJy?=
 =?utf-8?B?YkdZTUFDc1dGRGpqSWdIWDN2akNiMlhMQlp6c2NJZVJ1dVR0dFhOM3k1d0JK?=
 =?utf-8?B?OXdBa1FOYTc3elZuTHFobmFZZHFLU25RSTJTaFRNNG1RVVpYOVFRM2tuelZJ?=
 =?utf-8?B?dTM1Z0NvZTR3VGltMU5kMXNlNkFpNk0zNlY3VlcwM3NTeCtXVWFod3IveS9G?=
 =?utf-8?B?K0FTMG1tekwvVS9yMkpNVDh6aXU1YjlFNkptRWphSUNrUWo3bDh1ckJUQncy?=
 =?utf-8?B?Z1dFOWNKK2Q5UXRwKzB1dkVCeFZRQnh6SWw5eDEzeC91MHRVTVYrMHpIcisx?=
 =?utf-8?B?QVJlKzJCM295L1lsdnd5YU1CTUZua1gvcGRnc2tGdzN4WmJYVndKNkVqc0tt?=
 =?utf-8?B?R08ra1FzdkQ0cXhlY1dvUlNITXRDeTc0TDR0MlJmSVRXZ3hOMkF2czJSdy9n?=
 =?utf-8?B?bVUxWlBNa0Q0TFQvbDJrRXFhUnRPV2NjM1djLy9sWXZsbmJHa2dhWWhuMHVQ?=
 =?utf-8?B?TVgyZm9RYTMxSmVEOFVaSU5URG5PR1l3VmppRmRheW5qQzUyQUp3bzNzK1Ry?=
 =?utf-8?B?U3VLaDJ2aHNmS21JcWI3ckptTmdQQlhCTmxOU2V3Yjh4d0YraEJiWEU2Nmox?=
 =?utf-8?B?WDB0cDZjNm41RiszOEdhSDNoejFxUWpqQkc0VEYyYktIVlZQSXdHZ0xJVnR1?=
 =?utf-8?B?d2dSbmtrWkNsc0tQeHJMT0tIdTNNbGZmajZaaUFFZzZTYitwWnVNcGo1eWJS?=
 =?utf-8?B?c2EzMmJpOEJENkUzOE5sN3AveWFybDdzaDU2RFBGcmxWUjVLVXVHNTlnWjA0?=
 =?utf-8?B?NTBFRHRvOFIrMVBxOGx2eE9HR1JJQ3dCOVZXZmxFU1kzQllIK1pxSGZGMkJL?=
 =?utf-8?B?OXFJZzhFMWs4OVNXblNVcWRWTFlIams4RmkyRFdqbzFVaHdVOVNmNGlBbkJt?=
 =?utf-8?B?SmVQNXlDdGRISXk0VTVZUVJRUzJoVFBxR2hPZ2VMTGI5VzRLbE56U1RhM0NF?=
 =?utf-8?B?eWdoVTZKMFJjdG1BLzhiYWtEemFxOFk1bG1kUkZrdkVBRkxmcWZHTDBvUlVU?=
 =?utf-8?B?SzUrc2tsT1FyOWtqcGN4U2N0SWdmbkxMNUE4SkdOYU1uZmNRYXJwazZVcnlF?=
 =?utf-8?B?bDVFeHBNdGx5VjRPQzBxeExrbkVUL1dmRjBwQzVQd0d6d1gzMzdGMWc1eVV4?=
 =?utf-8?B?RnhiWmhtRTFvZjEzSVZlVE1GRUxqVG5peVIyRUFXcmx2N00zb0xkQk4xUEZm?=
 =?utf-8?B?N2t5b0xMOVZXVEowTU5GNi9SdEo0UGVtaEhVYzFkaW4wdE80QmdDS3Vhb1Zm?=
 =?utf-8?B?dWNWRFdkSCs0T1M1VGFOM0tINWRpRlBCZFhMd0ZQckV4cnlsRUJGa2xxMi9Y?=
 =?utf-8?B?b1QwYlh5NDZzcHFybURQUE15cnB4TjVOVFhnNkZnMlpEeHd3ZnBMazJ4eHIr?=
 =?utf-8?B?UDBmaWM1VkdzQWx1U3d6SHBsUnNtdWNZNnFHRndTNWhSTEQ0M3F0LzhhcUFp?=
 =?utf-8?B?VlJOMi9mZW5sMGowbWdUaTJwQ3FFU0tJL1g2RW9EQjNxQTczeXpseGdqUThF?=
 =?utf-8?B?ZURPZjYzSjBsTElPUWdDY0E5V01UdC9vS3d6dmlMdWZUOGZ3MVQ5KzMxOGFa?=
 =?utf-8?B?R0xjQkEzb1hPdHh3THV1aFUvc21tb2dPZFVndHlVYUpLVmhzd2FGeGdNcXVh?=
 =?utf-8?B?TTBFUUpSOUNYN2ZCSFdMMWsrNnRFcTU0Q2FpY05PdnhGOE5tcFlXd2NESVM2?=
 =?utf-8?B?aXhCdTRDL2EzMDF5UDZpSnVOWEczVG9naE5BQWowcHZIOWRtbCtqaElxSXhT?=
 =?utf-8?B?OSt1R0FhMmpyZ1RNN1k1R2E2SzFrUnNFSGx2b0t5R0FaZDNBSTZuRDBsZHFt?=
 =?utf-8?B?dHdLSkJmWVYrZ2g1cFJNMWFZV2pyMURhMXhrci9YYktGVGlaSjRlTmwzdzM3?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84FCDEC9A5B36B4887B2E869431B5C6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 655cc968-43e7-494c-b1c5-08ddb46ca49f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 04:48:06.7596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H5YDWOUA8vp+3bteiPDfNVNKWH+xK4uDZw/yZ8pdyeNLdsdT5UyOFr1RGQweikfSznewnSx7V9uf/20kPxItuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7672
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDAwOjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsJICovDQo+ID4gKwlhcmVhID0gZ2V0X3ZtX2FyZWEoc2l6ZSwgVk1fSU9SRU1BUCk7DQo+IA0K
PiBJIGFtIG5vdCBzdXJlIHdoeSBWTV9JT1JFTUFQIGlzIHVzZWQ/wqAgT3Igc2hvdWxkIHdlIGp1
c3QgdXNlIHZtYWxsb2MoKT8NCg0KU29ycnkgcGxlYXNlIGlnbm9yZSB0aGUgdm1hbGxvYygpIHBh
cnQuICBJIGxvc3QgbXkgYnJhaW4gYSB3aGlsZSA6LSgNCg==

