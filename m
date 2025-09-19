Return-Path: <kvm+bounces-58187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE05B8B2D2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 084C6A03087
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436702877F1;
	Fri, 19 Sep 2025 20:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0LF+P0u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FC51A2C25
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 20:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758312900; cv=fail; b=eVkSP72Vqoeb/baFediny8Aw7eWb5iAD+Lix2TM2vVzNgnJF/T//s+nSr1Feu3l/SHFlaZ01el6M792REIep1HySteqAoCui1UKQnk7F8SsfEk3EWZHsspNrWfzjFUurEOxgyLBttS30nnmOsEkWavEq5OnPGE3NITDkzQmxqF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758312900; c=relaxed/simple;
	bh=6jeMtaYG3CJJ+VXkVFuljRW0vssNoa3fJJq+xgNsIPE=;
	h=Message-ID:Date:To:CC:From:Subject:Content-Type:MIME-Version; b=hiI0qsw1O6LPvq+3s7olhH/GuhyG5unzUt7Stfag0hRlDnQiPwafEYNPH0d3z6fuF1rpGabYlWyaDnLtOm62LWjVffdQums7dPg/XrFqe+koLExtpJty60PU/OkvUtkvCINr/Qa7PKZubqYAzk1wt5reJHexTxHhwmHFPVxcfiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0LF+P0u; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758312899; x=1789848899;
  h=message-id:date:to:cc:from:subject:
   content-transfer-encoding:mime-version;
  bh=6jeMtaYG3CJJ+VXkVFuljRW0vssNoa3fJJq+xgNsIPE=;
  b=M0LF+P0u4NNURhSxCeXhLQQUrkBxsipsrS22mxnymNokU2peAMXc7uZT
   NfGxaWorj04/yyFpgzDjBOgDlHkgGRjxpYZJ+5PSgKMn12TaNQ6VajiMp
   +uk05NOg0VwS2UVyTyOJVTvfvqvMYwbsfmpV0QI/UWmTSUmSMAsqzrR1l
   IAtSC+/VM9Qm+ndp3rMbzKMKpS2jDLeLiwM33urwIrQ07MQgr+nXZnlnj
   EUU7Lv9BWsrFLsFKY1fHnPkhtSL15fOS4lxfye2c6aW2XhpWrc7LC7Nzs
   ZJlTMUrQ7DRgI58mxVxu0yiWNLGv9s+yFMNQOeCZjSPNsSHC87fEDdILS
   A==;
X-CSE-ConnectionGUID: /Zz5Ad9KRtuZOjOmBtAgeg==
X-CSE-MsgGUID: SYMZ1FHvQQGaKSlAb0O/+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="60819695"
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="60819695"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 13:14:58 -0700
X-CSE-ConnectionGUID: IUUfVZLRTYev9cnyVHqBeA==
X-CSE-MsgGUID: rj54V7m8R2+TYNdq4Ke78g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="180156319"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 13:14:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 13:14:57 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 13:14:57 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.4) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 13:14:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BiwGjQw9OMuj6jXKmDdX9YjauHMNatuDT7AyUuzHlGf8KZEsrko8F8LdEndqkgwZUg4DXUIrz2T3ae4upLAGKN8QU95x8OpNphH8PJYenEW/0eXiBn5Oro2LrIDdf/gd5OX+rUzdugj7VrOe5fQ6L69V+EvSn1sWufhhNYt7+mE7OKWxi4Ice+h0jIoGCdUzToS0PwjhicDC8P1vrGQMH3RItxjYWrPddbqeq7WytfnJicx6ZSMWnC7QjgLwoOqFcPMhJRlaD9V4BRV2m+CDtS1T+aebAXC79LBE6wmH20XbO654ab0eX8+Ge8AKNHwhImuMbLx1zIwklq871jY74Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vqx+qo7TmmBwCv3NrAEGzNo1MBjNI1PuA2OZwM9NV4=;
 b=xxVNjSiJPil+N818AwKT93Gqc4A5xPof8TVXJ9cxcny2GMjd5wvnj6VQz/UoIMDyIb9RjMaaR4IL2Lg52jAg6jgAfJL3FsFTMFY5hvhCFV2BSKKxUykMq2OExaChXfSLHr2VXMnjX51fXoz6dp55Bqo0SY6pFNHSLdOLvrK2R9gD5F2K7zmBerJtK+YtGMw6U26s0LLC+fpRG0QxMLa2r1ktDiPTR+lG6o+aslxMcYuQPxscKt+wGF0j2x1KE+9XnsTj+SfUrKWrY3/82YyzxpDj9n62tfxqrfy+Cl9OoxCpHCzukc4DgdvjwlDKGkmAiK0szwX+317yUckwgdCopw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.16; Fri, 19 Sep 2025 20:14:54 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 20:14:54 +0000
Message-ID: <f388d4de-4a16-4ba2-80ff-5aa9797d89ca@intel.com>
Date: Fri, 19 Sep 2025 13:14:47 -0700
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From: "Chang S. Bae" <chang.seok.bae@intel.com>
Subject: [Discussion] x86: Guest Support for APX
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0038.namprd02.prod.outlook.com
 (2603:10b6:a03:54::15) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH0PR11MB4981:EE_
X-MS-Office365-Filtering-Correlation-Id: cd0c25c4-ff1e-4a59-9260-08ddf7b9326e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dXVXcjBxSVBtR0NFRGlhWGs5b3ZCYkFCRC95WTU1L3NkQVgvUnBTeFdlRDRp?=
 =?utf-8?B?V1hXUEdwdHB3Zm5MNThlbFNXckNkLzFiTjExSVVkSkQzbGpNS0RVUjEvdlhQ?=
 =?utf-8?B?QkZxbzZ6SlFrY2prb1B1YkwxUzRkTmdIbmdROVdKc3hYNUxtQnVXTXpqNXVT?=
 =?utf-8?B?THdtbXZ5NnlSckk4MjlCa0tnbzc5VldFZHhqY2xrVjJCTVcwV1FyRC81RDlX?=
 =?utf-8?B?TGhnU243Z3hyUW04RFduQmFzWVljbis0V0lPZmJqcldnSXRLcGlENWxoOHY0?=
 =?utf-8?B?NU1JQzRMQ1BjSHBSMnFId1p4QWRqYTZCU2NpMVdTaVNmQ2lMRklrNm8rWnQ4?=
 =?utf-8?B?TzRkU1ZWTkRJaEt0UEdpTlkvYUdSRXBtTFJGbEQ5VWNFRjNPQjY3dC9KSm5n?=
 =?utf-8?B?RW1jNlFUTVRKMjNXZUc4dExxVy9CSjZhcUZWODk5d0ZUcGxraVdlYWcraUww?=
 =?utf-8?B?aFJQU2RUTytmdjBxVGZhUnFzRWp0c0tkUUJpNnRlUCtudzYwMTc2UzVucUlD?=
 =?utf-8?B?VUF0Zk45aFRCbWdhVjFLUUExeGFuQ2gvS3IwNGR3Z0k3WkJZNVd3dTAvbFZD?=
 =?utf-8?B?bmV1Y1FlVVhsMXR2a1locWtKaEQyRTdieHd0eC9PK0J6aTRubEc0R3J2cjR6?=
 =?utf-8?B?NjU4Q2ZPOElmdDJjRlRGM2pMQS83SlljNlhxMjNwTVhxc2s3RVZQQlljNTlT?=
 =?utf-8?B?aVhKVjBQcnNpZVRCZ2VMaExZVm5Bb0theG03Sm90MHFRcEtOek9hVVNyTnVy?=
 =?utf-8?B?WTQ5alFGZ0orRlIzMk55UUpEb1lOMngxQ0VsVUd2WVhXZDgzZnpQY3lqNjA1?=
 =?utf-8?B?ZWVFQ3pQWE5kVHdiK3lucUs3YnE1OGk0WHVHWExHeXhYby90QmcxOGoySWxh?=
 =?utf-8?B?SjFTdWI2YS92YVo2SDdtdGRWYjNLVjdSZVp1djk3eDY1aVhQZnkxQmRtdFpo?=
 =?utf-8?B?cDhkdHk1N0tNUkxsTzJTTWhHVExNSUZmTTN6SkVRMlBEWmQ1UXFjVkRkSENr?=
 =?utf-8?B?K2x6aUtEMDV1T2o2Uld4MUVmUENrczNCZDBkV0xhU1ZHN29abTlsVThwRHBX?=
 =?utf-8?B?Wk45WmNsWFRJK2RCSVhxbm83cnZiYlZqY2dldHBhOS8rWWIySUh3OUFnUmsz?=
 =?utf-8?B?UjVJZjBNbENtLzVURzhEVUVEdVFDSU9LakZCMTY3K0dEMmFVWDVMVXcyWTVj?=
 =?utf-8?B?VXdpWkN6RTh3QUhuMmpncWg4R3laZThEdHlwS05hTFEyOGlQaVVrSUo4b0xn?=
 =?utf-8?B?bEhDZDY1bUFVMjk5NCsweC92VkN0R2FlNGVFaWphYVBtYTFzTVBMWTRMV3pv?=
 =?utf-8?B?M1FnWFJQZHJoanI3TkJjNWdGTUZ1VWpmQ0hXYXFIeWF4T0QrRUtvTkQwcmUr?=
 =?utf-8?B?cHlEOG1lQ3pnaWJWQy80TWxHNVNsSWlZd3RqSEg5a1pYKzV4NDhzVTFLT2Ev?=
 =?utf-8?B?WklJeVllTVpYUjVTNGphc3ErNmdFL0RybHRQQjhweGgvaGZ6ZFM0TXVvUnpY?=
 =?utf-8?B?VDNRWTl5YXYwWTl6MkxEV3BOTW9SOThlcG5pZ3VYWVBSQWdJWFVEaW1kUUdB?=
 =?utf-8?B?L3MzUGRUczA4SmttZlJrK3o4SWEzWmE0NW9TYzBXRlZRZmhHVnREQjJtMVJj?=
 =?utf-8?B?alF1cTNhQmlDY0xDbnkrcmI5ZUtMdmFCdGllVTQraVJPRTVidVBYZEJHOFAz?=
 =?utf-8?B?WFRVdlhDc3NSS1N0S2JuVVhlSTRGNXd5b3lOellId3FZa1pyRmgwUkcrZ2Vi?=
 =?utf-8?B?MHFQaGVEa05FNFFDc0lrQTNKazR4bXNoL29paHRXQlVZcUVNdmxDVkl5L3B1?=
 =?utf-8?B?eEdPRjJVcFBYSzlxODkyKzF5SWFXUTd4eUw4UTlJZ0FDd0xzNGdkNWhxaXBz?=
 =?utf-8?Q?UEhrU2Qb2dYJ2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T21jMFUzMW95TW9wcXlhMDFkSSt3N21VSHAzK0RGTUpKb0hWRXhBaDEwb3Br?=
 =?utf-8?B?NXNFdkJXd1laYTZUNytmOUllODVZb1pMc1VlTnYrL0ZsTW52YnY5L0pOSEpo?=
 =?utf-8?B?ak9INGR3anp0d09mcXZiQ20xOVFDSll6VXJqZXBVT2QzNmxhcy90ZVpJMEl0?=
 =?utf-8?B?WndyUEsrWmdnalF3K1JqZVFwQ2l4L01JV2t4dk5FTXBvLzlnUFVrQm1PVnh2?=
 =?utf-8?B?U1pPRFhSZm8vdzhPT0ViSHJyT2F1MVVpSWxrYnAreFIxMUZjWjlpelJVOWpv?=
 =?utf-8?B?SS82WG5SYkNQblVjRkFTd1BidE50U2FsckZpc0lSbk10TzBjaGw5WDhBdVQ1?=
 =?utf-8?B?NlhvbWRrT0RnalZHa3BhUlcwOHZYTXdQbVM1WjdjNG1uNGIvZkhUZzVLOU1Y?=
 =?utf-8?B?dFR4aitFaFBNalp2ZmNDZWpEelk4ZzRpWmdKN1RLejZtc1Z0NHBBeU9JQ0Ur?=
 =?utf-8?B?aUluNUN5QWRuMWtseW1vVnNVR0g3amF6RXdhUkZpUS9GRFBOUzczZVB6Q3Qw?=
 =?utf-8?B?MTZUQ2JhQlZ6VDNFWEd3NThJYU9NZWE5UjFVcWdXbmUvMGxoMWVBUmFKN1dV?=
 =?utf-8?B?WGIwdi96TUQwRjE1SUlybXZ6T1B0aGRjS2pJYVUvU2JFYjNJR2tnMytTbDBE?=
 =?utf-8?B?aUhWdnFwN2VMbHdweG9UaDN5MWtYSUFXU05mT2dvYkREVGdOUUVRMnJ5eHVu?=
 =?utf-8?B?ZWYrU2VGbEpMRWhpaVdocE8vUzRva0FHUktZL0wvRUkvRlJSRmdjemZHS21B?=
 =?utf-8?B?LzRURStaeXcrQm5UQ295aFB0QUx4MTM5ajlOeHBEanFnV2tTMFBxWXFOUjU5?=
 =?utf-8?B?RGhwWTUzekQ3TmVmZExTUlJhdExsa0JwK0cvWVNQVXVrUC80NHJjUTI4Wko2?=
 =?utf-8?B?M0lnTXI0TzNvYUR2TGZsM1FhN2g5Nk9rS1ZVbWRCYTNJa2VsbFA3RmRTU0do?=
 =?utf-8?B?dUwxVFN0a2JCZVJpQXJzZ256SWxMejJ2dWVIa0h3Y040T0ltcHNQNjZpeWIr?=
 =?utf-8?B?UTJmZDBqd2hFcDk1eWo1TDg1K1EwcTBEdWI1SXhGNlJXVWtMdWh2Vk4rRVFh?=
 =?utf-8?B?SER6azhwcDNSeGZsMEZzRVpNam9Fa3VIcWlyazVGQnF6RnJyK0tSTXhhczRu?=
 =?utf-8?B?bFpuM2FRYVJDUTFuMTdSTCtpaHExV0d0WkNVWGZFQURSVURqZEpSVEJ5cllp?=
 =?utf-8?B?aUEyMHkxN2VpZlJQSHNMRGJKUk1LWExwN3kzSVF5MmJjbm05UWxjKzZlRWdu?=
 =?utf-8?B?WVlYNjV0NzJKV3VrQzNNMHQ0czBBYlJoazNjNkQwNUlUbytXUWFnUkw1L1hS?=
 =?utf-8?B?ZmFjREp4Z2s2QlRkS3FLTW1QUkJWd29KV0dUOHZvNWVOZC9Hbnp4STYrZi9U?=
 =?utf-8?B?WCs0VVI2RlpLZnlzVGsxUEZNRUtSM1kzNHZiTm9XTUtiN3lPaDArZ0owL3p3?=
 =?utf-8?B?WUlDWmw2cDR4ZTVnSDRQQm5mWHNINHhmVWpIZDZnM244eHBUd0dvWHZUZ1VX?=
 =?utf-8?B?bzA5VGZZZTNUNUpsLzBUd3AyQ21HUDFqR1o3dEpXbzdMb1RtUmtUZzkvWEJN?=
 =?utf-8?B?TGMrUWFlQ2VaVEV4UEFUZ09RSm4rODEwN2hqUWlsZ2xleThHMHRUckhtWUk2?=
 =?utf-8?B?RmptcUlycEYxTWF6QVdkN3RRRU51SXVwYi9mQ1QxNW43QjJBckJrMGhsWlNW?=
 =?utf-8?B?SmEyZFVieTdjN0FONHdBVUQzenFEb1JheVhBbGdoajlXWWVGQ3NOTXB5ZHl0?=
 =?utf-8?B?NjFFVk1ranMydXppcXhMc0p3Nnp4elprS3h0Y2xsVWRzRURIVjVXRFhXNGJi?=
 =?utf-8?B?cUJ5ditDbTFvWGxyS0Fsc242Z3M2UXUvSzBzcTU1YVpBTEd4QWRPeHJRSFhp?=
 =?utf-8?B?cTdkWWdsb2xiV3l2cWRtUy9pdk5uVlNBNjJ2TDE1ZjJGdXR4cnpmamtCTnZz?=
 =?utf-8?B?cHNBZVQ5UXROa01ZaXF3YmZxYmt6NWJ5V3Z3WEpTR3lSM1ByQTcrdGlCaXp2?=
 =?utf-8?B?NENzR3QwUkt4TldhRmtiUE54bVVLWTBDcHhjaWp5T0ltalI5dkFaRGk2YUNC?=
 =?utf-8?B?U2hwUmFuem0reTF5STZvcDZCeFIwV1dkNjcrWDFRTW1Sa1psd0phVHdmK3ZE?=
 =?utf-8?B?Zkw2RCs1T1p3MStTRFNmbUJCb005UDllTGRLT2JjOWNPc01lekV4elJ1cTN2?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0c25c4-ff1e-4a59-9260-08ddf7b9326e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 20:14:54.5258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NqVwVxZnPmrKsnWIsBajpLk5VsB00Dj3rCx1SAfBF6dNOLgTRsbZN5cQqAS6o2PaXvYmcQH5THroUZlC5r2VkG1o80XdgzVWRd6MY795A7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-OriginatorOrg: intel.com

Dear KVM maintainers,

We'd like to seek clarification on how to approach guest support for a 
new feature. Specifically, this concerns Advanced Performance Extensions 
(APX). As you might notice, host support was merged in v6.16, and we are 
now working on the KVM side.

At first glance, guest enablement seemed straightforward: advertise 
CPUID, rely on the existing XSAVE infrastructure in the host, and ensure 
conflicting MPX are rejected.

Then, we've noticed your policy statements [1,2] during the discussion 
of supervisor CET guest support, which I think makes clear the 
expectation that a VM should be architecturally compatible before a 
feature is exposed to guests.

Since APX introduces new general-purpose registers (GPRs), legacy 
instructions are extended to access them, which may lead to associated 
VM exits. For example, MOV may now reference these registers in MMIO 
operations for emulated devices. The spec [3] lists other instructions 
that may similarly exit.

Now, interpreting your policy in this context, it seems that enabling 
APX for guests needs to support the full set of possible APX-induced exits.

We may proceed with posting an RFC version that emulates all of them and 
gather feedback. But as we internally discussed, we think it would be 
better to clarify the scope up front, if possible, to avoid unnecessary 
churn.

At the moment, we also noticed another interesing precedent case: 
MOVDIR64/MOVDIRI. These instructions can optimize MMIO operations by 
bypassing caches, yet KVM emulation does not support them [4]. It is 
unclear if this was a deliberate decision or simply something not 
implemented yet -- picking up the set [5]. If it was intentional, that 
suggests we may need to define a more selective approach to APX 
emulation as well.

In summary, we'd like to clarify:

   * Should we target complete emulation coverage for all APX-induced
     exits (from the start)?

   * Or is a narrower scope (e.g., only MOV) practically a considerable
     option, given the limited likelihood of other exits?

   * Alternatively, can we even consider a pragmatic path like MOVDIR* --
     supporting only when practically useful?

Thanks for your time and consideration. We'd appreciate your guidance on
this.

Chang

[1] Link: 
https://lore.kernel.org/all/2597a87b-1248-b8ce-ce60-94074bc67ea4@intel.com/

On 8/28/2023 2:00 PM, Dave Hansen wrote:
 > On 8/10/23 08:15, Paolo Bonzini wrote:
 >> On 8/10/23 16:29, Dave Hansen wrote:
 >>> What actual OSes need this support?
 >>
 >> I think Xen could use it when running nested.  But KVM cannot expose
 >> support for CET in CPUID, and at the same time fake support for
 >> MSR_IA32_PL{0,1,2}_SSP (e.g. inject a #GP if it's ever written to a
 >> nonzero value).
 >>
 >> I suppose we could invent our own paravirtualized CPUID bit for
 >> "supervisor IBT works but supervisor SHSTK doesn't".  Linux could check
 >> that but I don't think it's a good idea.
 >>
 >> So... do, or do not.  There is no try. :)
 >
 > Ahh, that makes sense. This is needed for implementing the
 > *architecture*, not because some OS actually wants to _do_ it.

[2] Link: https://lore.kernel.org/all/ZNUETFZK7K5zyr3X@google.com/

On 8/10/2023 8:37 AM, Sean Christopherson wrote:
 >
 > As Paolo alluded to, this is about KVM faithfully emulating the 
architecture.
 > There is no combination of CPUID bits that allows KVM to advertise 
SHSTK for
 > userspace without advertising SHSTK for supervisor.
 >
 > Whether or not there are any users in the short term is unfortunately 
irrelevant
 > from KVM's perspective.

[3] Architecture Specification for Intel APX: Table 3.10: Intel APX
Interactions with Instruction Execution Info or Exit Qualification
Link: https://cdrdv2.intel.com/v1/dl/getContent/784266

[4] The MOVDIR64 opcode is "66 0F 38 F8 ..." but opcode_table[] in
     emulate.c looks currently missing it:

         /* 0x60 - 0x67 */
         I(ImplicitOps | Stack | No64, em_pusha),
         I(ImplicitOps | Stack | No64, em_popa),
         N, MD(ModRM, &mode_dual_63),
         N, N, N, N,

[5] 
https://lore.kernel.org/lkml/1541483728-7826-1-git-send-email-jingqi.liu@intel.com/

