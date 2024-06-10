Return-Path: <kvm+bounces-19148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BE8901911
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 02:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 032811F21BC0
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 00:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C774A187F;
	Mon, 10 Jun 2024 00:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JcrH70ll"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF374A29;
	Mon, 10 Jun 2024 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717980929; cv=fail; b=nEhVKY8ma7lHGj1DAb4JnjJYDzifUF4Cm4zCAaY5BhmEtKie+FCDU6qb6beR3+17x5gYHpvTgVA89vOQE5SaM3uZQOTu4bCNCTmYmUJ70JSx/58qlM6H9PVHvEWE1h6MDII6cv3ZUvk/IbXzVzDaDGBPpOD5SItfb1HPoOf+7Jk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717980929; c=relaxed/simple;
	bh=ZcS2OUVpdjHQgO2n5WniSdRJoCO9WxU3W+ZxSgVfd8E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X3EKvT8Xwl76OosHCHGyWFXHy2chqhjGyEfcwenE+d+uG4RABMH9KGT8YVlOA/wZ6gCG03/9KmHOHdoPayjL3cyeUW7hgKeCi/gcoZfUfVF1gn4sl6QDA8TwInCsPkEHT7MxTZMWfVz1O8CZXNkkh1/sJGVttAd9sfENXFLhauQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JcrH70ll; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717980928; x=1749516928;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZcS2OUVpdjHQgO2n5WniSdRJoCO9WxU3W+ZxSgVfd8E=;
  b=JcrH70llPoJTeLw6oa+9RBiuDqamlvmi+oib8t9l9uPaQigzlliS4ZNT
   ZyorESpRU54fJcyiqJezu0PJQqCVm78/REbxwDoIUxJG7CdwGxZvKPOFf
   k8lRFKUDgGAEHifxWjDiPyFoxkVsvT48xDaQGWmA3pSpTRWHq4+Z9dWU8
   NNrI93kO13BIZb2F2k1LxcroO3owlvi4cRxeeom7FYFiAY74lbNrlNq/I
   RCfYwAX9kVlsVAwR9RVO2gY8C79+ExwpFrDWBooUE3Thu5CEJ0tUMjgHJ
   SIiUr8UghLbfzdQVvy5ic2NqWksyFzCC73vQK/u2WyDDqA1lEPCGP3Ei8
   g==;
X-CSE-ConnectionGUID: M6q9yea9Swm1igqAUQemdg==
X-CSE-MsgGUID: YjhrzUZtSKavGE3IpHEmsg==
X-IronPort-AV: E=McAfee;i="6600,9927,11098"; a="14426612"
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="14426612"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2024 17:55:27 -0700
X-CSE-ConnectionGUID: Gh5PaikRS2Wo1smE7P2nlQ==
X-CSE-MsgGUID: a/97jJ2IRDqqdteVhb3VLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,226,1712646000"; 
   d="scan'208";a="38741525"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jun 2024 17:55:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:55:26 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 9 Jun 2024 17:55:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 9 Jun 2024 17:55:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 9 Jun 2024 17:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOH5omjK6nh+JdJ0tOpYWNnKJcDx/Qc3yJyWiK8qLHV1p5Gs5GJpQMKctaQLarMLpnBN6k7SxlWQZE8g/aGMNsabOGCt0Ly+i4aotJ/7TUSdnn4OvIcdsJb1azVA9pEMxbS518b4WFTcFAD+zk7OnMe5TJJj+WrYbZT1z/7G7/LbqJGv6xIiF+srUFqsiS+eQFhQfrpi9p2/VPCapm6joCS8s/Jt4GFLHuqnrDfi0ttVecoF3kEMGIYNXHFO1cPyM8WfbG27121654wpb9asgvoHLYsDLme/UvzDI3/FS26zzFrSTgT1t6+AtcDiC7vPF0+1A7oqqlVCmSjzXSWAkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcS2OUVpdjHQgO2n5WniSdRJoCO9WxU3W+ZxSgVfd8E=;
 b=a53qFGislKzvsgxlAthYu3QbeYdxVj7a9uuwAePWFMdKpHjnUcRACUmhXn2dhEboRbTKbrS1ci23VsrbjNySLSovb5+cejfDLsimGbw+EgBjIenVbqnVnOrjgcSxo3FGvOIzSSYPhjM0v6Qk89eMtvwuq/hia2OGXTPn/v0x0p3z2ooF+7A/lVCijziLlSnGSsWp/3jxng9Ytv87U5oSOeoQkczWuSxmD17Bn+gcqhtDAtslC48d1K0x7iicjUDc120UcOkG8Tm9xBYUyzj7L5LSrg1YlfJLUvcGH69SgSi0k0ASdaVM6hYfWcBCEuai0ZEEAxzcYISEnNkvKWqh4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6507.namprd11.prod.outlook.com (2603:10b6:208:38e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 00:55:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 00:55:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [PATCH v3 2/8] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Thread-Topic: [PATCH v3 2/8] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Thread-Index: AQHauTfNLoH5m5p6NUOBUXWKJSY7BLHAL02A
Date: Mon, 10 Jun 2024 00:55:24 +0000
Message-ID: <c365bb0dc968b93f6df689ee2a0ffc4c19b7d79d.camel@intel.com>
References: <20240608000639.3295768-1-seanjc@google.com>
	 <20240608000639.3295768-3-seanjc@google.com>
In-Reply-To: <20240608000639.3295768-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6507:EE_
x-ms-office365-filtering-correlation-id: fcf8846b-9e46-4386-6c81-08dc88e802dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VkxPcGFvN0cxdmIzL3FFcXl6eVUyQXpOZmc0aThNbStqczdRSmFDeVFiUWFw?=
 =?utf-8?B?Q013NVZPVDQ4MHhoUUhPRXp5VGpwNzM4TjNZSlZqRVh2S3B2ekx6ZStveUJl?=
 =?utf-8?B?TXgxSEZHMy82UTN5T0dna0FMeWJnLzNrcVA4RExSc2JnVTd6ZWhSWDBhU2gr?=
 =?utf-8?B?UFVKWkxUZE8vU1hHK3M1RklMRDFTc0txbnA3a0x4UHFrQkFmS001d0lIczI1?=
 =?utf-8?B?bCt5QzdlV3dSdVhYTWEzQ1NvTE9mUU1sazVRaG1NUEU2NkNoMmZMUi9LRjgz?=
 =?utf-8?B?azVlcjN4UUY5QUg5TEJKT0w4UUFtOFVuaFMxNFdtbklHQnZJekhLckVNSC9U?=
 =?utf-8?B?ZmZtK3FscG9mOHd0WnZDK0RHQ1V1dFUwT1BlVDRROWpPVnlramI0N2NucG5G?=
 =?utf-8?B?dXNTbmFWYzFGNHNrQUgxNEgyZ01ZRnphekE5cUF2TExZUjlDWjcwM3hJMUl0?=
 =?utf-8?B?VWJBMGdKQ1Z0ckt0cEZ3S0txems3VGlxSXNuRWcrSnNyemlWM3dSQzl3aWh3?=
 =?utf-8?B?ZXpiL3pabE5UVzhaNGVzbVA2M052UTYxai84Y3doTnRqczh4RjBxd1JTS0Vq?=
 =?utf-8?B?ZVlNT2hXZUpjeS95c3U3dEFvaGM3alZsNTkxMlNGb0xaYmcyNHVsVENBa3o4?=
 =?utf-8?B?U0JWL2owNjBzcFBVdm1Ja0RKNmhvRHZIb05JTGRvbE1selhwYlFWakx2SXVu?=
 =?utf-8?B?SlVlKyt1M21hMlBXb0Uvd2ljZzhEdk9HV2lHKzhFVFkyQU9BcmZLNmJFbWVD?=
 =?utf-8?B?ZkxuaEJTTUhPS0RIamE1Q3F2bkwyN0JYa0k1MTBRaFJRUjkvb2FIL3BacWNE?=
 =?utf-8?B?RWo0UDYxSDdyNjRJdGJudThxWFJnT2E1Zlh0bWpOa3dCK3IrbExVeE94RkZ6?=
 =?utf-8?B?U0w4ZVFFWTZvckJBRHJFMzM4cUw1TnhnYlowMllFTWVpcFpkank3Z1lNcGhG?=
 =?utf-8?B?OUc3dlpQZVNzWHAwL3ZLMGtCMGpoN3RiN0lBeUQyckJSQU9CcUVSS1B2dmtS?=
 =?utf-8?B?ZUlROFBabWpwRG1JL3dnWUhmQWZoY09hbnVrb0VRZE16MVNvMWFtT0crUnZX?=
 =?utf-8?B?bTZMbjljUHNhSkJZbmhBcmRQN0ttdFNldnd1elBjb3FlRkFoZ0F2c2J0ajdl?=
 =?utf-8?B?U2Q0N1NzWGM0d25sZHpveFFkVGxDck1sTHVsSDhTZFpMdXlwWVlIb2RqVEJ2?=
 =?utf-8?B?eVBzTmo5YVp2MFFLYTd3YTVOZUJNWk5UWU5RcDBOcW9OODUzVTlmZXFCS1Vl?=
 =?utf-8?B?RE9ZZlJZWU9aVU53SU9Ed3hDaE8vVHIzUnZGUDZVUzlOUTRlN293VEVxZUt2?=
 =?utf-8?B?RFJIanRndkFGb3cvN1V6ekRlRzFXd3M2a1JhNk1uakU4eldlRkZEbTFxdERS?=
 =?utf-8?B?bEM2Q0VXQXpwWXFsbld6eUl0U3Z1Q2JSVWlMdEVtUnVIcTM1S2V3aDZNUmxo?=
 =?utf-8?B?enpCMjU4eDYzaExVSkdrekt2MitOTGR3bE9tMGIvanB1aEhuT2ViVzMwaUpi?=
 =?utf-8?B?YkNLdGI1c2ZOcjU2RWswSm1DWURDdHh6akVOSUJYMmFTV3RMUENUem9YMUtz?=
 =?utf-8?B?UUg4bXlzaTlnUC9pajA2QWwvTTQ2RUxJRWtXdzBqa3d3UHJuOHdlOUJUbGcx?=
 =?utf-8?B?bGttd2lsSncwRDA2Z3RGM1gyUEVuMTI1UG5UdVcxaEdTd3dUUkZ6WFF0Njd6?=
 =?utf-8?B?Q2M5SFBUSENhd0dvZnNDZ3poWkp6bC85U2gvYUtja0dZM3dzdlJzVURzcnBD?=
 =?utf-8?B?UytOVUg5NStiZ0IwWm9iM3l1Z3Y5ZmJoRlhreEREZjJvYSt4RTJGK090c0N6?=
 =?utf-8?Q?BGZFFjSU55x018BZ35Ywtq459RqEjuDzSHl/A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmF4RmhqdmdEelhmVmdUYkM3UGlTVUh3L1plaFk5V2NvcjduQjJYbUlSRnpK?=
 =?utf-8?B?dExzWi9OaDN1RXRMYmFGSGhCY2lWQTQ2NTk4aENERHNYcERBWjdNM0Z1MVBK?=
 =?utf-8?B?anRkYWZOU0RScDBXZE1EaXYxQXlCY3V4THR6eVJRMHg1N2FJMmhmejJmR0I2?=
 =?utf-8?B?UzJoYkZBYXBma3hPaFlnaU9BWHE3YXIrRytpejdQZkRseXowZTN6Q1lBNm9C?=
 =?utf-8?B?dldNZzc1NFhDeEpJcDFUL0xHOVE5NDErOTFRZTdoUXpLMlZNbWgrQUpzZkxv?=
 =?utf-8?B?VVVGRERPZ0l5QXBDZ29GZjRWeUFRTHAwT1VlbkQzZFhZVENaOTlDSE1PU0JG?=
 =?utf-8?B?bElWT1ZMOHVtV3BpdzljemlRRkhkWXV4dHlVNXFYeFJvQXVGM0pQZlpmTzhZ?=
 =?utf-8?B?WkVQWTlaVEIxWTJNa0JCdTAzb3Vta2tGbXFFNzE1TEQ2TjlMNGR5L0J6SGUw?=
 =?utf-8?B?R1hMS2lFUlZDN1F1ZW9ZZ3lPaHVHZnpxNjNmMm9Ja3B5NGR2QThXZFlDSGZH?=
 =?utf-8?B?OC9zV2tWTHl2dVRoTmJQSlkwakJsUlVEbjBjWjBEa2dqOEhkOEsvZit0MWVz?=
 =?utf-8?B?Nzh3dmxBVCtUUlNQK2ZSNXJUWGVId3RRc0p6NkVSV3VrSk1mejlyd3REc3M4?=
 =?utf-8?B?K1pPMW9ielFyVHgrNHFrN2xISjZHZ2Nvc0Y3WkZCeldlcWdzS1JYUmhpTnpi?=
 =?utf-8?B?V1hOTURTeURxSXpUKzNVbEZwOVEwZFVVeFBaejRLQnZ6RUFTMEttWVY5UlMw?=
 =?utf-8?B?SE1WZDU5L3ZsY2UrRThrMVVQK2pLSG5MajFucFAzclkrZ2pMNk9Lb2U4Ymtw?=
 =?utf-8?B?Z1lraE8reWRScnZ5Vy9Sa3JRNi9kYWRwTjQyTTUxU0lOR3dhbGRTWTJ2c3BG?=
 =?utf-8?B?cXlWcnJvalJFQXpkNUZxcjl5SVNqa2x5Q2dqK3V5d1hTc0dMNVE3R1ZLbmFP?=
 =?utf-8?B?QjB0WHpLWWdQOUVUc0dnTE1oRmJFUHNOd05DOUs3c1ZHMFZWbldHc0xDS21Y?=
 =?utf-8?B?ZUJPclZiellZcmc5WnBJaEM5RW5WR2U0ZG9HZ0N0NlBXU0hkVERTT0M5NUlK?=
 =?utf-8?B?ajZ6aWlHcjcxS2JDZjAvVW1yZHFGekJtZ3ZEdWNUaTRKTjR3OEJNK3VUT2Yz?=
 =?utf-8?B?VTd1cGpta0Jucy9Ia2NXQVJOZzhUSTBieXpNQ2NZT1ErT2FrVXJqS2dBbzIw?=
 =?utf-8?B?YU9qY2NWTmNzSHpSQVRVSWYrZitjZjh2ZHJwSXA4V0dOdFd2Qk9qU2ZGVGxC?=
 =?utf-8?B?aWRSdlNaMjJtUmNJaG9BTGdQTGlXdUZBSTYrQy9DT1JvNHowVEkzS0txekRH?=
 =?utf-8?B?aDYyY1N3d0dYSFpUNDZnY3E3b3p0TjlqL0UxMTEzOVM4dk9yNk9PdHVrcHZh?=
 =?utf-8?B?TDBKSVIyWHBGaUN2TmYzRlRYMHlzOGh4aFU0TEU0VkNvR3VqYTcrOWZEOWRX?=
 =?utf-8?B?RXlWbzhaV05Bd2VpVXFJUTYwK01ndEhOQnE5Ty9nZHBDNjJFbWFzbEZtMU5x?=
 =?utf-8?B?Yjl1M0gvQXZEMFVPa0YrUVQzM1F5Z0E0QVJxSHBEVXNmWmpwS1BzNmtuQXZR?=
 =?utf-8?B?N1lyRXpuamd4YjgrRjFYNmZPKzh2aTJDeGl0UEVxREh3ZTdQTjZsd3dxWWxs?=
 =?utf-8?B?eU5QWDM2UXk5OExMNmNNbUVTUkVWNjJVOWlRbmlQS2k2LzBrQjZDc0RVSXV4?=
 =?utf-8?B?WURtUWV2STduYTY0bVM0NG8vWVY1aXMrazRWeGZBRW81VTFpU0x5VmZRTUp2?=
 =?utf-8?B?SzhqZERYU3pZSEtoRGlsZ01xem4rdzB3RDlXQXJQNGJoQ3U3VDhvNHpZLzY2?=
 =?utf-8?B?cTd1YTVQQzNiYjQ2UmRtVHd0aTJqMFc1TlJoL2Z1R3VlMHRnRlV6YU5DU29h?=
 =?utf-8?B?WTBGRHRyRFJPK2l5MHVVRi9NQTlkSWVFZ3gwYVl0T0YrU0pmVmdqU2dwOC9P?=
 =?utf-8?B?L2grcW1QOVlENmNZOUhncThaRmNjSy9QQXBsRHdHTnJKbUY3SG92d3lvNDUw?=
 =?utf-8?B?K2VpWno5QVJVc21nM3FYQ1Y4V0FUeVRjVzV4aER3QVRFZTQyOGx1U3FKWlZR?=
 =?utf-8?B?b1F3S3VESzZXYlIvSWhlTWE1R0xHUjdoSWV6TEY0dmJWdWNGcWV0bkh2OTFq?=
 =?utf-8?Q?lMKSkXqaqxSHWmNvoAn1kiXR2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1BB00CE32940C47816E5CB2C93553F5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf8846b-9e46-4386-6c81-08dc88e802dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 00:55:24.1404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j4fBR7CMkegSccl1FPtH5H8C79Tdl0kwOyyXOfSHHzG1XirA4lKaaBUKeVB8LCX+Tf+MHRWv7RnBud4y2jvycw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6507
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZWdpc3RlciBLVk0ncyBjcHVocCBhbmQgc3lzY29yZSBjYWxsYmFjayB3aGVuIGVu
YWJsaW5nIHZpcnR1YWxpemF0aW9uDQo+IGluIGhhcmR3YXJlIGluc3RlYWQgb2YgcmVnaXN0ZXJp
bmcgdGhlIGNhbGxiYWNrcyBkdXJpbmcgaW5pdGlhbGl6YXRpb24sDQo+IGFuZCBsZXQgdGhlIENQ
VSB1cC9kb3duIGZyYW1ld29yayBpbnZva2UgdGhlIGlubmVyIGVuYWJsZS9kaXNhYmxlDQo+IGZ1
bmN0aW9ucy4gIFJlZ2lzdGVyaW5nIHRoZSBjYWxsYmFja3MgZHVyaW5nIGluaXRpYWxpemF0aW9u
IG1ha2VzIHRoaW5ncw0KPiBtb3JlIGNvbXBsZXggdGhhbiB0aGV5IG5lZWQgdG8gYmUsIGFzIEtW
TSBuZWVkcyB0byBiZSB2ZXJ5IGNhcmVmdWwgYWJvdXQNCj4gaGFuZGxpbmcgcmFjZXMgYmV0d2Vl
biBlbmFibGluZyBDUFVzIGJlaW5nIG9ubGluZWQvb2ZmbGluZWQgYW5kIGhhcmR3YXJlDQo+IGJl
aW5nIGVuYWJsZWQvZGlzYWJsZWQuDQo+IA0KPiBJbnRlbCBURFggc3VwcG9ydCB3aWxsIHJlcXVp
cmUgS1ZNIHRvIGVuYWJsZSB2aXJ0dWFsaXphdGlvbiBkdXJpbmcgS1ZNDQo+IGluaXRpYWxpemF0
aW9uLCBpLmUuIHdpbGwgYWRkIGFub3RoZXIgd3JpbmtsZSB0byB0aGluZ3MsIGF0IHdoaWNoIHBv
aW50DQo+IHNvcnRpbmcgb3V0IHRoZSBwb3RlbnRpYWwgcmFjZXMgd2l0aCBrdm1fdXNhZ2VfY291
bnQgd291bGQgYmVjb21lIGV2ZW4NCj4gbW9yZSBjb21wbGV4Lg0KPiANCj4gTm90ZSwgdXNpbmcg
dGhlIGNwdWhwIGZyYW1ld29yayBoYXMgYSBzdWJ0bGUgYmVoYXZpb3JhbCBjaGFuZ2U6IGVuYWJs
aW5nDQo+IHdpbGwgYmUgZG9uZSBzZXJpYWxseSBhY3Jvc3MgYWxsIENQVXMsIHdoZXJlYXMgS1ZN
IGN1cnJlbnRseSBzZW5kcyBhbiBJUEkNCj4gdG8gYWxsIENQVXMgaW4gcGFyYWxsZWwuICBXaGls
ZSBzZXJpYWxpemluZyB2aXJ0dWFsaXphdGlvbiBlbmFibGluZyBjb3VsZA0KPiBjcmVhdGUgdW5k
ZXNpcmFibGUgbGF0ZW5jeSwgdGhlIGlzc3VlIGlzIGxpbWl0ZWQgdG8gY3JlYXRpb24gb2YgS1ZN
J3MNCj4gZmlyc3QgVk0sIGFuZCBldmVuIHRoYXQgY2FuIGJlIG1pdGlnYXRlZCwgZS5nLiBieSBs
ZXR0aW5nIHVzZXJzcGFjZSBmb3JjZQ0KPiB2aXJ0dWFsaXphdGlvbiB0byBiZSBlbmFibGVkIHdo
ZW4gS1ZNIGlzIGluaXRpYWxpemVkLg0KPiANCj4gQ2M6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRl
bC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29n
bGUuY29tPg0KPiAtLS0NCj4gDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo=

