Return-Path: <kvm+bounces-38525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84185A3AEC8
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BEA33A9AE0
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C797E105;
	Wed, 19 Feb 2025 01:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XvUS9ZSs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0E222097
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928083; cv=fail; b=YXEbeT+GwooyYv+hbxqOPoTBH9gUI+exvpArvYk2Sotn9t9WoThUf336WInTRQaU2Qp4NxfyyPDbnc/STaqskIxKjsCHFLWD1Ev70TvVLGIIEFkbViAmTKtuSmvlZy4jgiYIDJwVqwqBkKIWp9Co9GfvkPt15Ri0+N/Aro67oII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928083; c=relaxed/simple;
	bh=OOD8AACbwb0eF7iJ7NiCMXbSO0eRd3HONNwUvR5po7g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dI9n077wYsy7YlQy29gq2S1xUWbivKAv9oWi1KbsgYRGih8sDz6JAqnlyoo8SVsPaL5k8XbWfxp3Pja+K6ixgb0L0CFGrD4TiwHeE6BjQNsZurVTCZHLapnk3yAvV1MVourJgbmIDA76V74LZhxz1clHJbQBcsKtPBZHEV1C/kY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XvUS9ZSs; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739928081; x=1771464081;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OOD8AACbwb0eF7iJ7NiCMXbSO0eRd3HONNwUvR5po7g=;
  b=XvUS9ZSsjuAN6Vf/Z4FpwFcwfBPK+8t2S6r87wLEcVRsNB0hvzvGlpB/
   aI8vszZuLvbkhTPFsxLw/ThROR6lOwpDMmtPjqm9i/3F2+T5k/PGKL8yl
   zV8Vt+VSZZEnzRiOjUUAD/wFojuiUvDCYwZBmZFp32jiSGW+5yaSOE7cg
   glKQFxoYb8cp4kb8sjugJIPR5w0kWAciqLvbRsahEkkIsEyxln/Nbt+xP
   IFcitjWtD5ZeallD+dxKqVaUpVqc5sVjX94VloqjdbsnLxu16yRnRHOn/
   O9uvbg7KaO90SJOHuuqzFjRJVEUIcc8riagZmgEXWbbfYc3pJYV9uE3Os
   A==;
X-CSE-ConnectionGUID: o+0O6LWiSz+j7kZ9+qm0GQ==
X-CSE-MsgGUID: 99ff+SlQQoeKPCPy8RgeMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="40664999"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="40664999"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:21:21 -0800
X-CSE-ConnectionGUID: RLWBC7q5TQWfYihExiiaEg==
X-CSE-MsgGUID: bKHJUkwaQQOaf33ijuw7bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="114304419"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:21:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Feb 2025 17:21:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 17:21:20 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 17:21:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZrrN++YSKtz0ponevM8M0ckHmCwyeN6g2eMQvkBWJRqLd4sphBVadEY7FGAnlya24V0hUaqJWKR8Aru+F+DEeZvPyiby2QUKBG6gmSOYm9qMbLvfjL/AqxJlAczBV0El9XvDVLb4DSMTAaH0rxRBW9d1QQPGz6DKZDcIwuUs8Dz13XlCjBlCPOvKimtIu1CfBZOOOA06q7PqimCWhp8bhcHXyu0IsctNklBNhmFooN/SoUUTH+UbvAHdN8EtE3IqbQzes1aZW5ExTHmSeEvxHnubp92mCVFqsfC7uufLz7PN7dAHPc6vSJ5nIz7UcY5YLSz/upwb30k1FbzJCy0D4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OJB3b8rMi1d+uIhN2FJcJ7RfE1F0c5lvvVPNt9NFMc=;
 b=BUV819L+bRszoSl991a8tSTSNtA2FUbTBkCgNwAmE93CzlLwSX03xFHLxxnax/kSEudWykEgmhy6yHlXs3kkkhlyoXA0eFJJfRsGn4y/ZvjOJuJhpO57UDtQZlytDMecMvHH2fYvK5JDAuXmvZeCWED+NGZegXFy+M1JK6Uh+4H8KmLMjqZ2Ji/pL8xhhlheG72LOh9No11g1guJj97EuUFtdXbVmaWS8UWs9XLlG4PBkwLNMZkjz9frJJl+XQUyg1SPCQY2FPgEhpTjiv4IRMj+DYi5HQw4/P4c7RpiskRzxOcvLWJHw35iq8sXANjpxxS3IRc9JWAl8VEWAtHGxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8383.namprd11.prod.outlook.com (2603:10b6:610:171::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.16; Wed, 19 Feb 2025 01:20:50 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 01:20:50 +0000
Message-ID: <c5682028-b84c-4b4c-8c4d-f3b43d412e83@intel.com>
Date: Wed, 19 Feb 2025 09:20:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-4-chenyi.qiang@intel.com>
 <60c9ddb7-7f3e-4066-a165-c583af2411ea@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <60c9ddb7-7f3e-4066-a165-c583af2411ea@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8383:EE_
X-MS-Office365-Filtering-Correlation-Id: d481379d-b42f-4469-abcf-08dd5083a53d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q2I1T1hJTU8vbS9oVGNDT08wK0VObmsrTW5vTUNMWDltejNnN2JlVy9XTFpy?=
 =?utf-8?B?Y2VrTDl6K0c3ejRWV0w3TTlEMGRIdXlldTE1WGJ6eENkY20xekVtWFlkejY1?=
 =?utf-8?B?RDMyb3h0RjFBTHc5d3ZPT2lqWDlxR21PY1hsYThLTWxLbHV1VTZDWXhRcVp3?=
 =?utf-8?B?M2o0Z09nYmJJM1MxYkdsdTErWUZQN1FkZFFhd0h4Zm1hV2FSd1UwclRLK2hU?=
 =?utf-8?B?TWlWRVZ4dC9xeEpGRnFNZC9UdWN6Rm04Q0xnOUgvYjNZc1BnSVNmK05lTU1t?=
 =?utf-8?B?QXZQMml4MEJPZlVadmY4ZXF4U2R3eHMzYVFqN0R4bS9La0Jiak81WVArV1Vm?=
 =?utf-8?B?SEozQmZJMjVBamJ4TXNQNWUrWDY4RCtmZFVZQ3RodXFVbk52ZElSSmxRRVh0?=
 =?utf-8?B?UkRHdVB6QTEyc3IvMXViMG1uMUFjQXlQYmFkTTdmMzZCK2tPZkI0NlpZdDhu?=
 =?utf-8?B?M1RXVlc0b3BweVAxajlndG1tYWxNS2xacE1uOTZCOW1ENEprTlhEcWpaZUNn?=
 =?utf-8?B?RFZuSVlDV251WDJmYlZnUFZRYU1nOExaQnF3Q2JzVFhBTEJ1R1hxdUJ4NnRj?=
 =?utf-8?B?RFkwamUxWDRKeS9vMld5aFBMRzhEdzZJbDNEdURyMGFlQ0ZucnJlVnhPR2V4?=
 =?utf-8?B?UE5OdWpjUy84WE1UVFU2dlJGMEdYNWxCWUJVM28yYlh2TUxNYzJNMFFGY2kw?=
 =?utf-8?B?STQrSGw4aVRtbW9LYnQrc1hXdkJEOTdHZTZkVkJXSVIrMUM3MS9ZQkRBQW1E?=
 =?utf-8?B?OEc3SFp0QkkyK1VtLy9COFNiOEszbmhEZk5oQWJJc0FmalFoeGJnUGFlbjBB?=
 =?utf-8?B?V2lYT2pIb0NnL2ZreFI3akZsaVpETnhNVU1vbS82MGkvYWdCTDZLVHJRQlpY?=
 =?utf-8?B?ZVRFcDg5cTV3V1RsNm5nR2xLM2swVUZQYlp2SGV4Yk9PblloVldoS0dtSUsy?=
 =?utf-8?B?U1NVRzVsQzc2RExCVDRJTW15RnM2VEhoVjE3R0JEY3hBQVYrMDdIOFN4bm9L?=
 =?utf-8?B?endEd0oxdThlWldCcGJlT3NKaU5naXZqaHJDZmhTTDJoTGRYcjUvaXkrSGRv?=
 =?utf-8?B?TXM3T1NvU2hpQjYrK0N1OWJvTGFqOFZMbXkvZ2FlUVNOVkFiVFNlamxBcXhj?=
 =?utf-8?B?TFBnVDM5ZXA1bWdjZ0hwQlhaYWRQS0I1dVIzV3FyOC80L3N2S1FYU21WTFUr?=
 =?utf-8?B?dEtRYTlOckJvV1crNTdTR3pnLzFubk9xK3g4UUpUWlR5R3Z2cjJPRHJPZTlT?=
 =?utf-8?B?QlUxa2NheTdnQmJ3WkNMRzNDTHljYkFKSklaaWpQWDNWV3YrYkIrMDYvRGpy?=
 =?utf-8?B?T1IyaE9sRzJ6cTFUYnNwR0NsOElwMHpubVZBWmNCR0MwTkhacWdiaG9yTkZV?=
 =?utf-8?B?VzJFNmtlN3dYMVRJbUZPRTZYYVZmUjBBQW1EdXZhQ1VUN2xBQTJNUy9Ub1Fm?=
 =?utf-8?B?Ni9aZTJBWk5ycXJKeE1FZEEvUzZZK0FxYzdNN2R6Rjh4bHlMZE9ZS1k5a3JG?=
 =?utf-8?B?WXJUKzFmTHpkWGR4cm16bTlOaWdZOEZEYlhjTXh5OFYzVEl0ZnpSY3NVdjBx?=
 =?utf-8?B?QXBicDE1OVNMNStpTnJ6VTdWVStvRUhyeldtMmZyUFV6Wm9FSkQ4b2cwSFhq?=
 =?utf-8?B?UnVaU0pVNW9zVFozemUxZTV4bkwwZ25DSjladkFRRzZsL2VEM1poS3p5cVJ1?=
 =?utf-8?B?U1hsV0NEU3pubUkwaERhRUMwYWpVb29kSEF4bytJL2NIOXd0dU9HM0w1cG5K?=
 =?utf-8?B?OWkzMWU1ZXFxUUMwUXFDMWI4ZlVLa25PSy82RjRSeTQweC9lL1dJMlVlMy9O?=
 =?utf-8?B?ZGxsZlRLNHlud2w3a1h5akRkcVN6ZUI0NUtEd1l1aUFkTkpDdks0SEUzV0Za?=
 =?utf-8?Q?VWJB/+4fbbmND?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHdLbkxHLzhGSU9FZ1NEM1YyYm5NWEZjQ1hUcXZ3emlra29IMlQ0dGtNdjM0?=
 =?utf-8?B?R1NqNHR2QkNpZHpDcjc5UlVvSTBmU29ZRUtmZDE1UjJ0NFF3L1VXenBtb1hB?=
 =?utf-8?B?Wms0Q3VQWmhmVGl4dld4VWlkSmtrbkh1cFdLQkErV1AvM1liMytjWjR4bEtR?=
 =?utf-8?B?dGswMnBrbjU3MzZrZUFubzlWZEkyVkVoUk9PSmRZYlZ3SnU2R0VxSDgwWG5v?=
 =?utf-8?B?cnpCQ3BtWW5KWFFEY3RmcTU5U2JMV2JYYS95Y095ejI5QkcvU2F3V0pxTFpC?=
 =?utf-8?B?cEdOOWg5bGVJVGgvY1l1c3JrMzF5czYzMjJYazlITWg1b2puaDQ1R2xIY1RM?=
 =?utf-8?B?U3FLaklCZkdIZDc0NDlqTmpFZkNmeGRJZTZYcUZwWlFVektOWC9JZWlHWUQ2?=
 =?utf-8?B?a2tFVW1uUEtLWHlIdzVSZ3NRMFkvZHY0bCt3Yi8vWlhPRXdOcXZ5YVl2bno2?=
 =?utf-8?B?TGZGK3BGSnJ3RFhmaGE2RVVHeklraEI2VzFxR3QrbDBqai8rMHVXZDJmNnps?=
 =?utf-8?B?NWdVOWxFblFQUURZTXRKYlRJa0xVeWtURE1ibVJ3N3JUd2hiTFA5dWo3T1Rn?=
 =?utf-8?B?OGhFT3FBQ3J0K3JlNlpIaGlmdnJ5dU1vbHpSdnAvb20xWndtV2w2SnNwMWFB?=
 =?utf-8?B?Q1VtMjVVOCtnUnRqT3FUQ1RqRzlyV1RFRkd5ZVgrUXlBSFprUG4rNEZLU2gx?=
 =?utf-8?B?TjIwNmdZV0lORllBTXpzN1R3bUpMWDFmOXdQL1pTRld0TmlFSG1oVXAzSGIz?=
 =?utf-8?B?K2hMUXUySlBBbWNhbGlGVTRQVHNSQy81dWxaRGczcy82WDNLVFI3QjdOZ0NW?=
 =?utf-8?B?SXZTM1VLY3drOGRBSnl1Z0lONi9YWW1HbFFjM0dsSm1WdmZXcGEzQjMrUXd3?=
 =?utf-8?B?eEhIOXBlSnFoWE5xcmtUZitBYzMrRHgxK1I0VmJ6cXhsWFcyaE5ReVJxSnNr?=
 =?utf-8?B?Y2RXcTAxNk5UVDhhamFVYi9VeTdBeW9BL2thNDREVFl0Mm8vY1l5NTV4VVdZ?=
 =?utf-8?B?MHlKMUYxVWcyZHhvc1RsUlZsV2lIdjJtSnZiNmJGK2IxK09FaGNDcm9qQVFh?=
 =?utf-8?B?VEo5cnZjRDdwK0FHeDlxWTlFMmVDcU1ZbmpJMmxWd3I2SmNkalh3MnAwZU50?=
 =?utf-8?B?ekt0VFQ3bEEvOXVkSHplbGZ0Ynd2cFNPM3o0eWFVaUc4RkF0OW5PQjd1VlEz?=
 =?utf-8?B?NnoyQnp3bWxyZU9jQVpIa0hUanA2ZjNoNlNPd3pwSGpFeFhyckREa2dpdmFz?=
 =?utf-8?B?NkF5YzJUMFRya1EyZmVkMm9GY3VYSWpNWHIzbC8xWGsxWWpuMURPNVE1eHo5?=
 =?utf-8?B?bHd6MFNEZ21KQ0ZObWtQNmxELzNyczV5YXBaWjkvQ3ZmcUFtVC9ZYmNMenZK?=
 =?utf-8?B?eldnVUUvL1kzK08rZjlrcThvWlB1VUhVU1plZERxek9qVFh4dlhSU2VOcTV0?=
 =?utf-8?B?QXFYUVhQTG5ONDNOSElDc2Rjb2RHQjkvektSL2hEcVRCMHNUcmpoWmhxMmxM?=
 =?utf-8?B?dUJ4NlBMa09ncHRab2labnFEWitreVZNVHQrUHRXdjV2aTdiYnVZMUloeGph?=
 =?utf-8?B?eUlGMk5ZUVNWWTllRWF4WkJQTDBaTHBkT1NWdFpRRHNTSnVtQ1NjUDBBYVYy?=
 =?utf-8?B?U21aYS9McXJQTmdOeEtROXpQVFd6NTB5eDNQRXhML0Y4cW9Jd00vMGdFWHF5?=
 =?utf-8?B?bkdyVENiUm0rUWZDbXVPWEU0SFF0cXhMZE05TXBmeVFkZkhJak1YamxwRDRj?=
 =?utf-8?B?RExBd05mOGI0SmNGUnZVYUpBYlhjMHpmTUZma2gwbThkenBKcERGcmVoeFZ0?=
 =?utf-8?B?OUpXSk80VkJ1WjY3aU1EcUZWMjhleGlRTklBK1BTMVVKcGg0ZnVUT3g4SGt0?=
 =?utf-8?B?ZWkxczVIUW84cTRNbW9rNmFocVI0ZzBzT0xkOGlBSWRHMnMwYldndWFzK3JD?=
 =?utf-8?B?dnlhaXdYK0kxQ1o5V1M4UDYzai9UN0xFZ0JHR293aDRWcGVpTFBaSVJ5OC9D?=
 =?utf-8?B?YUs4bk9BcHVQZllMejJnSWxUdXRKbjN3NmlQUmd2aEJkNmU3UDgzdWVWODlm?=
 =?utf-8?B?eVpTMC8zWFJKbHY5cGI4dlpnR3JCRVEyYndaWm9DVC9NUmRFL0NudHdRZkky?=
 =?utf-8?B?MUVEME1MbnNiYUwxZldJMHhyOTlUUnlHODNZR3E1OVNicnZrVGNuZUJ5RitZ?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d481379d-b42f-4469-abcf-08dd5083a53d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 01:20:50.3208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUZxRcg0QcTaMF7xq3lo8R0VE0CcbcmFev9qY+dljvyODgS6pSOJDB8dLi2cs3F2/A9RyUu6Ro6CI1p5ZzXsuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8383
X-OriginatorOrg: intel.com



On 2/18/2025 5:19 PM, Alexey Kardashevskiy wrote:
> 
> 

[..]

>> diff --git a/include/system/memory-attribute-manager.h b/include/
>> system/memory-attribute-manager.h
>> new file mode 100644
>> index 0000000000..72adc0028e
>> --- /dev/null
>> +++ b/include/system/memory-attribute-manager.h
>> @@ -0,0 +1,42 @@
>> +/*
>> + * QEMU memory attribute manager
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>> +
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
>> +
>> +OBJECT_DECLARE_TYPE(MemoryAttributeManager,
>> MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
>> +
>> +struct MemoryAttributeManager {
>> +    Object parent;
>> +
>> +    MemoryRegion *mr;
>> +
>> +    /* 1-setting of the bit represents the memory is populated
>> (shared) */
>> +    int32_t bitmap_size;
> 
> unsigned.
> 
> Also, do either s/bitmap_size/shared_bitmap_size/ or
> s/shared_bitmap/bitmap/

Will change it. Thanks.

> 
> 
> 
>> +    unsigned long *shared_bitmap;
>> +
>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>> +};
>> +
>> +struct MemoryAttributeManagerClass {
>> +    ObjectClass parent_class;
>> +};
>> +
>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>> MemoryRegion *mr);
>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
>> +
>> +#endif
>> diff --git a/system/memory-attribute-manager.c b/system/memory-
>> attribute-manager.c
>> new file mode 100644
>> index 0000000000..ed97e43dd0
>> --- /dev/null
>> +++ b/system/memory-attribute-manager.c
>> @@ -0,0 +1,292 @@
>> +/*
>> + * QEMU memory attribute manager
>> + *
>> + * Copyright Intel
>> + *
>> + * Author:
>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory
>> + *
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "system/memory-attribute-manager.h"
>> +
>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
>> +                                   memory_attribute_manager,
>> +                                   MEMORY_ATTRIBUTE_MANAGER,
>> +                                   OBJECT,
>> +                                   { TYPE_RAM_DISCARD_MANAGER },
>> +                                   { })
>> +
>> +static int memory_attribute_manager_get_block_size(const
>> MemoryAttributeManager *mgr)
>> +{
>> +    /*
>> +     * Because page conversion could be manipulated in the size of at
>> least 4K or 4K aligned,
>> +     * Use the host page size as the granularity to track the memory
>> attribute.
>> +     * TODO: if necessary, switch to get the page_size from RAMBlock.
>> +     * i.e. mgr->mr->ram_block->page_size.
> 
> I'd assume it is rather necessary already.

OK, Will return the page_size of RAMBlock directly.

> 
>> +     */
>> +    return qemu_real_host_page_size();
>> +}
>> +
>> +
>> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager
>> *rdm,
>> +                                              const
>> MemoryRegionSection *section)
>> +{
>> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    uint64_t first_bit = section->offset_within_region / block_size;
>> +    uint64_t last_bit = first_bit + int128_get64(section->size) /
>> block_size - 1;
>> +    unsigned long first_discard_bit;
>> +
>> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap,
>> last_bit + 1, first_bit);
>> +    return first_discard_bit > last_bit;
>> +}
>> +
>> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s,
>> void *arg);
>> +
>> +static int memory_attribute_notify_populate_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    return rdl->notify_populate(rdl, section);
>> +}
>> +
>> +static int memory_attribute_notify_discard_cb(MemoryRegionSection
>> *section, void *arg)
>> +{
>> +    RamDiscardListener *rdl = arg;
>> +
>> +    rdl->notify_discard(rdl, section);
>> +
>> +    return 0;
>> +}
>> +
>> +static int memory_attribute_for_each_populated_section(const
>> MemoryAttributeManager *mgr,
>> +                                                      
>> MemoryRegionSection *section,
>> +                                                       void *arg,
>> +                                                      
>> memory_attribute_section_cb cb)
>> +{
>> +    unsigned long first_one_bit, last_one_bit;
>> +    uint64_t offset, size;
>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    int ret = 0;
>> +
>> +    first_one_bit = section->offset_within_region / block_size;
>> +    first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>> >bitmap_size, first_one_bit);
>> +
>> +    while (first_one_bit < mgr->bitmap_size) {
>> +        MemoryRegionSection tmp = *section;
>> +
>> +        offset = first_one_bit * block_size;
>> +        last_one_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>> >bitmap_size,
>> +                                          first_one_bit + 1) - 1;
>> +        size = (last_one_bit - first_one_bit + 1) * block_size;
> 
> 
> What all this math is for if we stuck with VFIO doing 1 page at the
> time? (I think I commented on this)

Sorry, I missed your previous comment. IMHO, as we track the status in
bitmap and we want to call the cb() on the shared part within
MemoryRegionSection. Here we do the calculation to find the expected
sub-range.

> 
>> +
>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +            break;
>> +        }
>> +
>> +        ret = cb(&tmp, arg);
>> +        if (ret) {
>> +            error_report("%s: Failed to notify RAM discard listener:
>> %s", __func__,
>> +                         strerror(-ret));
>> +            break;
>> +        }
>> +
>> +        first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>> >bitmap_size,
>> +                                      last_one_bit + 2);
>> +    }
>> +
>> +    return ret;
>> +}
>> +

[..]

>> +
>> +static void
>> memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
>> +                                                    
>> RamDiscardListener *rdl)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    int ret;
>> +
>> +    g_assert(rdl->section);
>> +    g_assert(rdl->section->mr == mgr->mr);
>> +
>> +    ret = memory_attribute_for_each_populated_section(mgr, rdl-
>> >section, rdl,
>> +                                                     
>> memory_attribute_notify_discard_cb);
>> +    if (ret) {
>> +        error_report("%s: Failed to unregister RAM discard listener:
>> %s", __func__,
>> +                     strerror(-ret));
>> +    }
>> +
>> +    memory_region_section_free_copy(rdl->section);
>> +    rdl->section = NULL;
>> +    QLIST_REMOVE(rdl, next);
>> +
>> +}
>> +
>> +typedef struct MemoryAttributeReplayData {
>> +    void *fn;
> 
> ReplayRamDiscard *fn, not void*.

We could cast the void *fn either to ReplayRamPopulate or
ReplayRamDiscard (see below).

> 
>> +    void *opaque;
>> +} MemoryAttributeReplayData;
>> +
>> +static int
>> memory_attribute_rdm_replay_populated_cb(MemoryRegionSection *section,
>> void *arg)
>> +{
>> +    MemoryAttributeReplayData *data = arg;
>> +
>> +    return ((ReplayRamPopulate)data->fn)(section, data->opaque);
>> +}
>> +
>> +static int memory_attribute_rdm_replay_populated(const
>> RamDiscardManager *rdm,
>> +                                                 MemoryRegionSection
>> *section,
>> +                                                 ReplayRamPopulate
>> replay_fn,
>> +                                                 void *opaque)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == mgr->mr);
>> +    return memory_attribute_for_each_populated_section(mgr, section,
>> &data,
>> +                                                      
>> memory_attribute_rdm_replay_populated_cb);
>> +}
>> +
>> +static int
>> memory_attribute_rdm_replay_discarded_cb(MemoryRegionSection *section,
>> void *arg)
>> +{
>> +    MemoryAttributeReplayData *data = arg;
>> +
>> +    ((ReplayRamDiscard)data->fn)(section, data->opaque);
>> +    return 0;
>> +}
>> +
>> +static void memory_attribute_rdm_replay_discarded(const
>> RamDiscardManager *rdm,
>> +                                                  MemoryRegionSection
>> *section,
>> +                                                  ReplayRamDiscard
>> replay_fn,
>> +                                                  void *opaque)
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>> opaque };
>> +
>> +    g_assert(section->mr == mgr->mr);
>> +    memory_attribute_for_each_discarded_section(mgr, section, &data,
>> +                                               
>> memory_attribute_rdm_replay_discarded_cb);
>> +}
>> +
>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>> MemoryRegion *mr)
>> +{
>> +    uint64_t bitmap_size;
>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>> +    int ret;
>> +
>> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>> +
>> +    mgr->mr = mr;
>> +    mgr->bitmap_size = bitmap_size;
>> +    mgr->shared_bitmap = bitmap_new(bitmap_size);
>> +
>> +    ret = memory_region_set_ram_discard_manager(mgr->mr,
>> RAM_DISCARD_MANAGER(mgr));
> 
> Move it 3 lines up and avoid stale data in mgr->mr/bitmap_size/
> shared_bitmap and avoid g_free below?

Make sense. I will move it up the same as patch 02 before bitmap_new().

> 
>> +    if (ret) {
>> +        g_free(mgr->shared_bitmap);
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
>> +{
>> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
>> +
>> +    g_free(mgr->shared_bitmap);
>> +}
>> +
>> +static void memory_attribute_manager_init(Object *obj)
> 
> Not used.
> 
>> +{
>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
>> +
>> +    QLIST_INIT(&mgr->rdl_list);
>> +} > +
>> +static void memory_attribute_manager_finalize(Object *obj)
> 
> Not used either. Thanks,

I think it is OK to define it as a placeholder? Just some preference.

> 
>> +{
>> +}
>> +
>> +static void memory_attribute_manager_class_init(ObjectClass *oc, void
>> *data)
>> +{
>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>> +
>> +    rdmc->get_min_granularity =
>> memory_attribute_rdm_get_min_granularity;
>> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
>> +    rdmc->unregister_listener =
>> memory_attribute_rdm_unregister_listener;
>> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
>> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
>> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
>> +}
>> diff --git a/system/meson.build b/system/meson.build
>> index 4952f4b2c7..ab07ff1442 100644
>> --- a/system/meson.build
>> +++ b/system/meson.build
>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>     'dirtylimit.c',
>>     'dma-helpers.c',
>>     'globals.c',
>> +  'memory-attribute-manager.c',
>>     'memory_mapping.c',
>>     'qdev-monitor.c',
>>     'qtest.c',
> 


