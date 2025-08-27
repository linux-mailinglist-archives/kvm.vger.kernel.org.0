Return-Path: <kvm+bounces-55874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 178C5B37F63
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0F6A6841E7
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85E3346A1D;
	Wed, 27 Aug 2025 09:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKBppzqM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314343469FB
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 09:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756288502; cv=fail; b=YBcFakuTec9tss0taIYMrw0CEqcHeeCBnQanK9vhcnsAnBWnGqfmV2ZQ6AKV0uGkzz/HTD1zeNPfXrZYlJlTTTbi5oPeZOUB/J9AGRjRqEovLykxp2DuoZWvVDM+T7xRoQz9DBaP3P1gYl6ZRBajGQTqtRDo/cQ3UBjXFRbmPDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756288502; c=relaxed/simple;
	bh=VIo15/s3XtC/yI+bBA6k1exwGL5j7Kom5Z8X4fJtYiM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H22XLeaC7ku36U01LMWj/j6e1LgCtKTD1urT8w/vMfjcI/d2j7PoJD5dKjyOWuxmjnhFPyiFPtAJ+IN3OQDHig0syoxZIyB+9oDeDUU0PPjDugYFu6U5y8DH4psdA0Q15qGbTcuhK8bEBzrIIgDmRPTscrEoOGsBNutNS2Qmr+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nKBppzqM; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756288501; x=1787824501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VIo15/s3XtC/yI+bBA6k1exwGL5j7Kom5Z8X4fJtYiM=;
  b=nKBppzqMFLLaFcJ5gbDe4EFUHTNQyjvuDjTuSzWfOEIsbw4XbpEJA5J0
   z0ZTQU3Al8UhDVtE47dQoDA3xsgIvykykzOj9VtqQAjJNXPOswir1cJLa
   wln72vzVKMKxYIDHv85+6IAkRUID9U9y0/xcnz9hZLIo+GJHgbEsvrcYh
   OCjjeMzatZ5GYk2jKZuj9MDNBXFmdO353ljx+Eb0kA8x3kXk2eFVKQHIa
   F1uq3Z7+SUcdAMX/m6m3Jv8v77XmrMyRgErrxuOQhVGMOx+IYR2H/30qo
   589e72lZxHmc1h1G7BnEAfZwaYUtftxvYP6KH44464n+PpsZvFC67APnr
   g==;
X-CSE-ConnectionGUID: RXjoRrPkRIq7BkWPYNCuaA==
X-CSE-MsgGUID: mjg2pYLUSJKuye/NUndJkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="58391426"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58391426"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:55:00 -0700
X-CSE-ConnectionGUID: h4Cx/Z3aTNmj0AS6SaEyfQ==
X-CSE-MsgGUID: tDMrr/3/RqmzbKJuzFrFRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="170202771"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:55:00 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:54:59 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 02:54:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.73)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:54:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4gyuisVSEcdlxJxmlAeKtUS3xq2W5+s/S3IMX8KpPzpTtUOY1ynageOLfkbRJz9hg+pIuXkj1DM6kDItnejBxg3ElMpWROmIPO53uwhL7PwQWjVK6UzM8ItIFS5sislO2OvleCxJHNSKK7yIpIvQdf5LUrgwXrHxizJj/sVpj2cqOoFOne6ewpFUp96KW9PMFAIJfRlxa+xsjW4K4TThzJ4V2F4+q6qUdVXnJ6zVYD4qGZN6SA9WIx0/2z6XCl86fPQUIEwy1EtQH8Mm6IqGMBmzqADjJQpgIipVQUAzyea01yrVnqEJpmI+3Ss9R4yXIU6qmK5grDiFhRP16NIMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIo15/s3XtC/yI+bBA6k1exwGL5j7Kom5Z8X4fJtYiM=;
 b=K38lLRQWZFPnVQfs4FFPd9DTtqKy6pzAK08xzT39fuhK9sMaAQQAqvwpdbQqnKpjC0vUyIlPRN431KzfQYI/vIB+rwSO1x3w+/Ugn3WdR3dfNY4Xric0/52z1KR5bB51rMM1UfpZCyBXs5ZL144ntdKxx4n3QEo5LtamLBXj6dWHRtzPv3agpKm8KKX2kdj9adtWwVmkQkeM7E5rzv2Ad/usClpJ/1HAKSa5iDNeo5KaBmzEiKVr3IiNOVXH2Jr6iAlJH3OIyjeSIcmJYUt9tUOVbfEGOPxfvXie2mctFd+rs/Eh5h0C8eFcDqrgema5K1fHsAGZSJlzSPUkQvEF4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6329.namprd11.prod.outlook.com (2603:10b6:510:1ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 09:54:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 09:54:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 2/4] KVM: SEV: Skip SNP-safe allocation when
 HvInUseWrAllowed is supported
Thread-Topic: [RFC PATCH 2/4] KVM: SEV: Skip SNP-safe allocation when
 HvInUseWrAllowed is supported
Thread-Index: AQHcFdP714/Q88e1kUqqVYxi9qUV37R0ts2AgABTwACAATsPAA==
Date: Wed, 27 Aug 2025 09:54:55 +0000
Message-ID: <d3f9c3f09fbbe2523329c57c0c911ac8afc9c2b8.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-3-nikunj@amd.com>
	 <668a279d908bfdac33a0e64838d4276ec43fcce0.camel@intel.com>
	 <eef0e010-181b-491d-9b5e-91bc35bf566c@amd.com>
In-Reply-To: <eef0e010-181b-491d-9b5e-91bc35bf566c@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6329:EE_
x-ms-office365-filtering-correlation-id: 68efe082-ec97-4ef9-e2d6-08dde54fc6c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZEgyN2xiVm5TY254MHVyODZYSmRIaWl3RUk4LzBBRzA2R2RVNVFYTGgvTmV2?=
 =?utf-8?B?S0xXNWY2a1pjM0JEUEJiWmRtbGxzSmd0UmR5blRaMGhFZlFoZStFSHl1RnU0?=
 =?utf-8?B?aDBGZzRqckZ4ZmpQZlVUMmVNMThZU1Y1NU9Fc2RMalJ2QkpGSGcxeFYvd1Fa?=
 =?utf-8?B?V3F3c3d4VnN1UnVyNkoyNkFoU09YUDVWV0dLRDV2ekc2WjY0amptS3JxM2Ev?=
 =?utf-8?B?NzhsT3RqT0pwS05pVy9vUGVJWGJoYWdBc0VCZm4yM2FWbTZqT1A1SnJiRHlk?=
 =?utf-8?B?S0dxUzJ6QzJSQUEydzBCeFBVMkxwelc5YlhxYzFIZjdVaHdPbE52ZmNjaFBr?=
 =?utf-8?B?by9NcnpSL0lCV2kvbWNISkR6NmszQzlQZGRVZDBvNiticy8vd0xsRHQwWUlD?=
 =?utf-8?B?bW8wY1NzbXNicXEyL0orRCtwaWVJcGVXSklJVDJBZnpmUytQbHlnWlJncGVy?=
 =?utf-8?B?K0p0SGdtc0k4VE1SWGRXVU9keTFubHYrTVJvZjMxSG1JMm5oN3poOUozaUNp?=
 =?utf-8?B?azZLZmNOV09WTThEUHg3bjMzWG9sbmw2ZmtnTGFVcHdHaVhzcm5FSTVKa2Fo?=
 =?utf-8?B?NE1DR24yNlgxRzJhK3lFcWhCLzl1aitKNHZtQlBrUFdaSGgydUFLOG1JNUUy?=
 =?utf-8?B?MnJRZytNSENRT1c2R09hWlBTaXkxdWtDTU5nNGJqTElHVGgwOTY1OFhwanph?=
 =?utf-8?B?RnJ3SnRBMlJkRy9KZTZzdmV4ZXpMeFpPdDhrTDAwSlQxc09WaWlBTU9QSE96?=
 =?utf-8?B?bWMwQjFWUWEycTRDc2VhZGtrcDE3ZkJ2USs2Vk1jZXlvMXJSWnpxc3pzMXk4?=
 =?utf-8?B?TklST1h6aXltZUNvZS9FekJrYWFOM0Qwdm91OVhZZjAxWjNBTEQyei91Ly9Q?=
 =?utf-8?B?U3laMlRGb25uWkNzVzVxcjJlTlJzRHNUZENib0oyUFBwcFlyMjMzaEhUQUMz?=
 =?utf-8?B?SzFYbHN0bGlWMWJBcUMwcXRDTmNkWTNWOFdsbUZaY1p1R0hyVWNEamFQNEpY?=
 =?utf-8?B?N2pMY1I5T01qV1NIS1FHbGpqR1ZmK1B4cjMxVmdWSk5UTzAxYVY2Z0pjWDdL?=
 =?utf-8?B?dHRQUUdMWmdzb1A3RXVpanBFVFlBcDVodTRrV3ljUjVGQWg4bVh0L2VSQnF5?=
 =?utf-8?B?NEJtaHZ3Z2hFOTRwQVBUN0hkdmp2U1FoRTdqZ2srZk9MSjlCODNobGROQ21X?=
 =?utf-8?B?NkJMR2R6UzA3WU1QemZjT2VISThZcDlkQktjZHRuMnpDdy9iVlBObGdkMWJm?=
 =?utf-8?B?amthVURwblJUMGJHNXR4c0UzTUJPTm8vdzdsRjZRUW00TDllM1pXL1c0eEFC?=
 =?utf-8?B?L3dsYlh2VE5teHdmaXFkaUZQTDkxSDN1emtRT1UvdytQNUpUdUVidUJQZWNQ?=
 =?utf-8?B?aitFelBaVmNCb3pobVdYaVhqU0haaTZiTjBIL05wKzBIVXhKQ0dWRWxQYmxX?=
 =?utf-8?B?OVZidnB6OENZSkh2UEtKL1liZVpzcjRoMlZtQU9RL1dybTQrUXByV2p1YWov?=
 =?utf-8?B?TW5JWSsxWjdUck03N3BjLzc4UWVJKzlPOTNjVCtYYmUwSjFJWXdCbzk5RkI1?=
 =?utf-8?B?R2xNSXIyRityVG84K1ZUSk5IaGwvaDNTcUtyby81Y3VoTnI5bFc4R3JhbUlp?=
 =?utf-8?B?TWFNaHQrZkFEdTNHa1RYWk9qNUtydDBPMDF2R2g1NGo2amFVWHN5N09jUHVY?=
 =?utf-8?B?VGIvbUI5MzU5OFdhdnU1ZlB0b2h4dm5LbWUxOXhwNFdlMTM3ejJGQ2Rwa0lw?=
 =?utf-8?B?bnFXbEZRWUh1ZEh1dE5oUUwrUGVUNERQcU5yQUFFcUxUNnVWV3IwQkRGMVNp?=
 =?utf-8?B?aTlGdmVOUG4xVm45bE94SngyWHVJSGpWZEo1RFZyZ21aMzljQ1BoSXQ3V2ZI?=
 =?utf-8?B?ZUtieVRNeHprQWIycW5pdnhBRDh1MW5wOGo0UmU5YnRFYm16cWx5bTRjWWFJ?=
 =?utf-8?B?VUtyOXoyWVhKUFc4ZUtaQUNJL1BiczdGZjUrYkRVZ0tiekdsMEVic203QkRq?=
 =?utf-8?Q?QpFvw6N7ia+IgBgIRelnxxXStbjrG0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmVseXRhVVNHQlVlS3lYMU95YVMySHdla3Roa3ZsblVGQXNTOEFnVkRFQVZC?=
 =?utf-8?B?UnpITmswZVBraFlEaUgvaUtKc0pRZndRUSsrTldpdVJoVUF0NGE0SS9MNkJa?=
 =?utf-8?B?WVIzM0JSb0ZxNzZYSno1WUVmWWJYRU1VMDczOHZETWtFMlRIcGRoTDJGbGd6?=
 =?utf-8?B?em5KdTViQUdLVXpPaDFGS05YaEVrVmRLcnpmb2t4cGo4M1YySDg2aVZQSkdv?=
 =?utf-8?B?RlpyOXd6SzlHOTBZSUlNUTE2eHFQaW1wdzFvQTVVZ0xVZlhJMk80cUJOQWFO?=
 =?utf-8?B?TWtSVCs0Y3RGNXc2SWFLOEt0QzRxVy9hV2FJQUVyTHZJdjEwcDZwMVhWeExD?=
 =?utf-8?B?eWV1S0dPUXR5anZ0eGVaV3NMcjZXMitPSnJnT0RwSTBSelJDbnU2bS9HVnlP?=
 =?utf-8?B?MTNwUHR5Nnk1TmxYMml2ZDFLTG1sRkxPVmtLTnNiMi8wQ3c4Nm1Ja1JCYis3?=
 =?utf-8?B?UXEzRlQ1NmN0RDdmV1pIbnlZamg5Nk96RVVzNHZDY2VhQk0zMmRITjV1TWVO?=
 =?utf-8?B?eDhtM25ralJrRllmN1ZBVlRnUEJ2WWFEVzhQSTgrd2pkKzhQRDYzVUZ4K0Vo?=
 =?utf-8?B?Y2dSd2NKeVhlc2tXSllYY0I4bUM0VUo2Tk1XVTNNMGxQdjdreDFQQnlRZEp2?=
 =?utf-8?B?dWdSOXZ6K3E1VVdHSHRZSU42RE01amVsMGlFMXplQVdtMkZ4WmZPaE1senNF?=
 =?utf-8?B?bU9RUEtpQ25CWEloVFF6cDltcE1tUzI0QU43OTRoUm9yQTA4ZDJ5TW1BUTBL?=
 =?utf-8?B?NlMzMU1kVVZMblh5Y1lRWHJJWlh3S004dHU0Zko3VTV0YUwvKzUvOUlLWG1y?=
 =?utf-8?B?dXZxcExvaVJWVFhjQ2NLVUVXZ1EyZ3JiQVcxT3hjRVNtNjV4MitucC9TZU5P?=
 =?utf-8?B?azY2MXVUU1d5REt3M01rWjJ0S2NObk9HRVA5Q2J6SFc3aXd4T0YvS1pNSG5M?=
 =?utf-8?B?MU9uaERoNTZ0YzFmKzFSUm1TNEVIYThJOVZKdlNsTnJ5SkFOanRvV0YvaDQ5?=
 =?utf-8?B?UW9semNPNGZNNklvakVXdjQ3VFMzbEdvWkJzd0N1NU81MFF2MFcwYkZZQVlw?=
 =?utf-8?B?SE4wUkdidURxYVZDMGQ2NGpPRGdOQ0hMNWRoZjBFWElrRmJhdmlPbmdPVVpY?=
 =?utf-8?B?TnkxUXZqRnptazI0TnRjY0FuWElXL1B6OXFSaTZaV0g2TU9SUHdsNmc2dmIz?=
 =?utf-8?B?WTMrQ1BWbm5TQ2xVSXRsdVV6U0Nmc01QNkE2ZjV3cUhUaFkwMXc4dEZFdEEv?=
 =?utf-8?B?L2FOeHZEcmhrdWVHak9La3R4NXBqNmpSQ1RtNUhrNUFoNmhZdnFiaUw2WnF1?=
 =?utf-8?B?ZW9oTWg3WGJLZm9BbktVeE1waEMycWZ2ZGszRzRDbU1NNVN0WE45WldHcC9p?=
 =?utf-8?B?RVFvZllDVGNjSzg2eHJsS3FaalNMZlRwQmF0NW1xWmxWejBUaldJVTY3K0NM?=
 =?utf-8?B?Tml5UUR2QjhmaitWUEZLVjZvWlJZb3R5VXFKMXhsSStIZTNtYjV6TUZUZXhp?=
 =?utf-8?B?K05ERnpxQURyM1UzbzVrVzRpSzhEMFd1NzY0QUdKN0JMRmtQZTlxTkJ0RU1K?=
 =?utf-8?B?MUNRZjZ2SFFsMTRBOFZUM2E1WlRQbm5PV0pMQWN0VXF3c1B4dGIrTjlQdXlI?=
 =?utf-8?B?VXNBWVY2V2ZTMEhEWGZGZy8xTENhZVZ0cSs2YXMrRjlYR3J5Q2t0dDAwajdI?=
 =?utf-8?B?S2tDcjVWQ21HTlYrbXBmUFlqYWNsWVZVNGJoQWlweDVWb2o3OG9ndit6QWNY?=
 =?utf-8?B?Nzg3ZjJvSWJxVlB5TnJzVkl5Sis3QzdWVlRhWnFkTW1PRCtIOFBkbWsveCtE?=
 =?utf-8?B?TW5maTJmcXhNRE1YWkNMREU4TncwVzVKV09FUENoOUZ5cFFDa0JOLzltL2lZ?=
 =?utf-8?B?ejVSam43Z3BQUUdxdTIxZmZ3QVNSb2ozMzBTSmJVazBnaEdWTUk1KzBSOGxB?=
 =?utf-8?B?RUI5Zm5ZUWErekI3U3VSdUNWd09FUjg3TnM0SlJNaFpFcWhVQzVoRDNIcVFB?=
 =?utf-8?B?Rmk3WHJrSUxOZFg3ZnczeEc0SUwyU1ZyWU1uZXNiWXJVN2ZPcGZSeXNjdzBL?=
 =?utf-8?B?bGRrNkxlVjR2RysxRGZ5WllUdWxrOTBrL1NhVGtCL2k4Y0dCV1U5ZTBNRVJk?=
 =?utf-8?Q?dYp/tly1CGqRMucPh75l6zM9f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54C8BC8CD989584199CA929AAD366718@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68efe082-ec97-4ef9-e2d6-08dde54fc6c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 09:54:55.6728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aG5KXvMp6GNI58RT5smGdfI0J+4vbcvhiWwhGIZGndCiJZAdNZ7qa3ftpXOQdL/0a0rumvDW6UzsBKu5w4oWLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6329
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDIwOjM3ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA4LzI2LzIwMjUgMzozNyBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMjUtMDgtMjUgYXQgMTU6MjAgKzAwMDAsIE5pa3VuaiBBIERhZGhhbmlhIHdyb3Rl
Og0KPiA+ID4gV2hlbiBIdkluVXNlV3JBbGxvd2VkIChDUFVJRCA4MDAwMDAxRiBFQVhbMzBdKSBp
cyBzdXBwb3J0ZWQsIHRoZSBDUFUgYWxsb3dzDQo+ID4gPiBoeXBlcnZpc29yIHdyaXRlcyB0byBp
bi11c2UgcGFnZXMgd2l0aG91dCBSTVAgdmlvbGF0aW9ucywgbWFraW5nIHRoZSAyTUINCj4gPiA+
IGFsaWdubWVudCB3b3JrYXJvdW5kIHVubmVjZXNzYXJ5LiBDaGVjayBmb3IgdGhpcyBjYXBhYmls
aXR5IHRvIGF2b2lkIHRoZQ0KPiA+ID4gYWxsb2NhdGlvbiBvdmVyaGVhZCB3aGVuIGl0J3Mgbm90
IG5lZWRlZC4NCj4gPiANCj4gPiBDb3VsZCB5b3UgYWRkIHNvbWUgdGV4dCB0byBleHBsYWluIHdo
eSB0aGlzIGlzIHJlbGF0ZWQgdG8gUE1MPw0KPiANCj4gUE1MIHdvcmtzIGZpbmUgd2l0aG91dCB0
aGlzIGFuZCB0aGUgY2hhbmdlIGlzIG5vdCBsaW5rZWQgdG8gUE1MLiBUaGlzIGNhbiBnbw0KPiBh
cyBhIHNlcGFyYXRlIGZpeC4NCg0KSSBzdXBwb3NlIGl0J3MgYmV0dGVyIHRvIHNlbmQgaXQgb3V0
IGFzIGEgc2VwYXJhdGUgb25lIGlmIFBNTCBkb2Vzbid0IG5lZWQNCml0IHRvIHdvcmsuDQo=

