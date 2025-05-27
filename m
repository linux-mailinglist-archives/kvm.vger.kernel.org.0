Return-Path: <kvm+bounces-47765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3ABAC49F2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8232F7A9805
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8E4248867;
	Tue, 27 May 2025 08:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PEf0b0hL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08E2188715
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 08:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748333559; cv=fail; b=Jg8D5vXaMnI6Yx9zTOtIwzWRPp8NBxxxg7A0WYhl4RcixGIyT4jAJNykID10ISeiqTeQX9q+1JVkuigktA0Hnmy1z6myztfH3z7YojyL2d/+bcdMSfmhAHn2mG0/HsX8QGjN09OqqAOUMxG+4RLiapL+11azMhSYxwgZX2DnPmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748333559; c=relaxed/simple;
	bh=iGCkoWQY43gbn704YfMZbKnXvlUBKpF6cQC9P44gk5w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QY+hDgprFJ4Z7jEQ0X/ZFV+inVatMw59qv6mK9IgkCb7dj4crI0RvUKZ1GK4V6tpgA5mcGUiXVTaxMzfwng1sVJfAhm6UZPI5G/gwgJK8iIgUX8/qe8dgFewLXoYwmG0uisIE4MILsG6i8+sS5ejZxxUbUbCDOQeAm90JQAJ7+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PEf0b0hL; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748333558; x=1779869558;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iGCkoWQY43gbn704YfMZbKnXvlUBKpF6cQC9P44gk5w=;
  b=PEf0b0hLUHCVz0wuORzInVbzOREUyDU8uPDHxa8QtHPK9gVk5txP8VEU
   Mf1DWW1nEFyZ/XfGRN/ffCPJLIHPosnNVmpj2OJfeiRyXIxtCNQXG22lx
   T0Y8E1x9ViXAzelXAvk95Qe9aXKB9UFPNK4Qrsq75UvWY7dBzd2hPJCGB
   DpopmL5CcWQ3stQv+JXUt8EOEaESO9Zt06c2i2rGsqn4Y0QC1pTpdlivg
   OPGV4RZkDsW8UaaPK985pQVx0qM5MXTrDbLPeXascyWq6xLnDk0GL5hem
   Ts7BJJjMIVc8AMe8/qMzjtFQDDgRB3EHNHmy3+Woi4eInaH2/a87fxBSs
   Q==;
X-CSE-ConnectionGUID: kpMV/L9jQ1aLs+psuP4HPw==
X-CSE-MsgGUID: o9nthIofT/muBijCgAqWQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50367422"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="50367422"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 01:12:37 -0700
X-CSE-ConnectionGUID: 4zIKHpwaT6mKMNoMWqywtQ==
X-CSE-MsgGUID: 2k3Q+YiWRy2on22wEyh1ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="143154586"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 01:12:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 01:12:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 01:12:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.84)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 01:12:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2xmUuZeHrMoOBnlEN9oiwk7hH5yz+eXU3uGKEK9vds26MM6ZIcH/3dJ1HekaEIiGe7AAAkT0mrBbRJsU4Te54sIbFUjID2XKJv7B8WibI6GHT6fMVK4nXQAEfYfvQZ/opLrYRxNoB+g4QVI0jHduyi9UxxPRCgZhu80cUKArEalEznfurRaN2Rkd/zingsfZERicrqbe5KqUKt3b3QiZE7ObYVl8hwj9irPUAY2UzgR1aL78WpI9d3UJrQDozQnlQ6YJHJSZPG52ldWVrywtd23w6/qMrn7ua1z7S929WGI3Iybb9bivXkYDxAZ6qX53L8GNeTrQiB834YypMy5Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KukjOdzTqSqBoL6AUokLT8XflCwPHmzfYousRUdOuQ4=;
 b=pZBSJ3Mx3GEDIpGeDPHb2bQBQBSpuxhglYfPWoBDF9RWBge23c8CdbX8KWH/XCDr25v8qCmR4EPnxyZaNWEJ/08qDzwp/CeLofYWB1Izcads8odmXUk7R9wNn4fUzmVWduIy8+Ni9H/to7D8aFEfgC7w+g3ZZQYzjvlzxZSw/dazYhcaKd0RL7Fng+pk4KCCBqp1+M6YNMi51ThxcstOPnCbY2pB4w/vG0tX5Bzdhns2unM6Gui171FHdZKWnz23xIs0Q3U0X01s1jTbAwyKD+6Cv1rmaNRgfWa1qzi2jgSvpwC6lml+YSMN/1CFS5ojZvacIul50Dp8dVv2QoW0Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 BN9PR11MB5308.namprd11.prod.outlook.com (2603:10b6:408:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Tue, 27 May
 2025 08:12:34 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 08:12:33 +0000
Message-ID: <7c0f40ab-7d11-40a4-a716-565b1787394a@intel.com>
Date: Tue, 27 May 2025 16:12:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/10] RAMBlock: Make guest_memfd require coordinate
 discard
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-8-chenyi.qiang@intel.com>
 <7af3f5c9-7385-432f-aad6-7c25db2fafe2@redhat.com>
 <cf9a8d77-c80f-459f-8a4b-d8b015418b98@intel.com>
 <2e7df939-e50d-45e7-97d1-f90396db98b6@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <2e7df939-e50d-45e7-97d1-f90396db98b6@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0082.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::22) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|BN9PR11MB5308:EE_
X-MS-Office365-Filtering-Correlation-Id: b5050948-ce1d-48f3-e8c3-08dd9cf63bad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aGRQSGZJV1d6SXRWOUF3eG9SNURlNloyTmpBTVJKaG5SNTdBV1NJZlpLWHBk?=
 =?utf-8?B?QU5VYjJtWXUxcTlkL054aFM4VUFiVnM4dWJwQmVoa294UXpueUJOazRUQnVL?=
 =?utf-8?B?anpPb05hOGxHODg2emNFdmRNeCtPWWhvTFlaT2dzZFV5WnoreklDWld5TW53?=
 =?utf-8?B?L0NxODlEdkwwWEhwSlNEMzM0WTlJR1NwZFhtYWVMeENoTnRoQm02TXpoWkgx?=
 =?utf-8?B?aFM4TWpZbVhaQWNIMGtDRGdzOEdSUmdSSU9Xb2R1QUkzMlY0YmZSQ3YwK1lw?=
 =?utf-8?B?Q3VhMUQxMThscTl4Ym9ta2NXVVdUTUZiRDczZi8xVGZTbGJOdUhjb0psNzVL?=
 =?utf-8?B?cmg3UW9YVnZwVWQxZjFvOEs0ODArT1dKbkhJVXF6K0tuUFI5bGlPQ3haRzh2?=
 =?utf-8?B?Z2wrZ2JvMXJtWGtUVjRiWnh1K0JsQU1GTzNYMU1pTVpCaHpSdEpTV05jTzBa?=
 =?utf-8?B?WXdLQWo1YXVLSzFROXdVWkZyQjRIZVJNK1BPcXJFUjlLT1pab2ZKZm9tYTI0?=
 =?utf-8?B?TTBrUVhtRmZUaERuMnE2WlRMMFZ0WHRBL2hGY2hLUDdMRVE4UUJiTnhWcHJp?=
 =?utf-8?B?YWZRMzFvUmpTWHp0WExtakR2Tlp2bnBYSC9QRzhkMG5ZMXVETXJYSEhnME1W?=
 =?utf-8?B?NC9UcHorL0t5SXMzbXFNams5RFY3MHc0eGtTS1ZYSDFpQmNSSGV0ZVJYeTZT?=
 =?utf-8?B?eENiQW95TFIramxqSDFXdUxvenAvRExzbERlVkI1Q1kzNVN1UWpSUjJ3b0dZ?=
 =?utf-8?B?ei9aZzRGQlU4WlRUT016R2pwQ1EwNGVyUklPNHVPYXZyVEpjMm1za3JjbEhZ?=
 =?utf-8?B?cncvbk8yeE00azIybzhSdUdVUTdEV0RTYlFBT2JXWFJ6WUpQQkZocktUbWpN?=
 =?utf-8?B?M1QzT3ZlZWM1SEFmQ09VV0hoN0tyWkpEUVl0ajNoSlZTcEpndGMwSThrM0NT?=
 =?utf-8?B?ZE94Z0FKTDg5WW1zSVRyTDJmaGJEb002UDNHVmVWQ2ZST0Q3cXdnZDl5VVNG?=
 =?utf-8?B?RW85cGx0K256YjEzUW5PUTd4Z2F2UnUwck9aVVRwMmQzTTN5YkkyQ2tEZE00?=
 =?utf-8?B?RWZMbnFmcTA1aTA5aHI5MkNVc2pKWVBnWW1ZU0R5Kys3QUpiNUNzY3d6UXhj?=
 =?utf-8?B?L1VCR3pJOCtBYk5NTHpKYVhQcFBCd09mZ1BSc3FRTzdZSUoreFVHMjBXSEkw?=
 =?utf-8?B?MFl0KzlyNStTN1NSZENOVFptbFY1Qm5yTWl3VzFtRWphS25EOHU4N2lCbGpo?=
 =?utf-8?B?RVZpSFk4Skt4ZVR0T1RqZlA0enRvOElpMU0rQ2pCM2NHd3VGS0hrQUcwY05D?=
 =?utf-8?B?bGQ3bzZUYzFRWUpyalV4ZnFZN1lrU21qclJWenNOcWk3SjMzdDFQS1p5RWFB?=
 =?utf-8?B?SVYyZU5pcGluVnNhY0QzZFZ5QzFTd3l6WDN6SUxNeTdmUnlyR2tvbjM5cjBS?=
 =?utf-8?B?MFlqaWVkSTNHZ1FmZ2pGZ1NnU1d5NGFLWWVxUEN6aklHWG92QnFibVd0RzNx?=
 =?utf-8?B?U0xrZzVSR2xvUEs2cGE1czN1V3FRRzNYcG1mQlp2LzQrazJDeDVrdVhQVkIy?=
 =?utf-8?B?aXYzMUJyMEthMXBCZFNTb3dONW4xbElXaXZiSHVEdkF4VzBFTzF2TzRKRXJC?=
 =?utf-8?B?TjVGTHN0MGR1L3pYMTJBUCtvZ0NmbXFDSHN3OUF5UWlCZG84a2ppSmltNjln?=
 =?utf-8?B?bldBakhsc0U1dnZ5ZTN3TXBEWkZlVkhDQVRHeTMvTEY2b0RSaDV4akhScTlQ?=
 =?utf-8?B?Ym0yL0tlMW5lRGFQZEJNbmdyWEJLV2xrbmZCOXJZWS85dEtsQkdiL25ZRU9h?=
 =?utf-8?B?bDdqcTljNENRY2ViQkY1YnNFVHJ3Tnd0N0FUMTRvSXZyeTFoUVlEMWRQVlhr?=
 =?utf-8?B?UkhVQzFFamhXUWV3bGRpRWI4V0Q5cmZvMXdQaDRGZW9oZmZKNENBUmp3WS95?=
 =?utf-8?Q?8GtbePsqtEM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFZLWEFhajMzbGdZcVdTS2VUUmR1UkJhNTJSRG80RlNUU1NCMkk0dzhoWDc0?=
 =?utf-8?B?N0ZYUlI1MEc2WXplUW1WR0NHTnNOdGdOajFBbTMzMWFSbFpYS3NrcUdQSzhI?=
 =?utf-8?B?U2pBQWJjVkNJb2lQdjVibTNFZjNGREx6WmZRelNibk1GZGFWQk56Q0FUN3Yz?=
 =?utf-8?B?cHVLMldGbzNPSlk4c1RzREg3VlpCclZpNmsxTEdzOE1DRWJIamlaRzhRMmx0?=
 =?utf-8?B?R0w3SndJdDFJZ1c1a3JKMzJvV3ByWktlS2UxOEhPZkM4ZHJkcWtMb3MwMVda?=
 =?utf-8?B?TnlOZW9BOTdxSHZqZGpOanh5TFdQcDNuZ1d2a1N4Q0w0aHZ5UE9wSjB6KzNP?=
 =?utf-8?B?cnJnRE43M0tidUVOdjd6UVVodVNZcHZkVXVBYktwUUlZR2FIQmdGb2IvbHZ5?=
 =?utf-8?B?d0dhYUlBL2RrRzJMMFNnWGtFbS9KVWR6OUJKVVlMYkdkTjMwbVJDV0U2eUdB?=
 =?utf-8?B?ZFNoYmVrdWNRV2FzOVhnUTZST1FTOVNiRG9VOHVXbmJHdzllS1VoeFVZWGJM?=
 =?utf-8?B?SmhMZkx4QVpMV2IySWNEdkxZWkhUR2cwM0FmTlVCWVMrWWxVVUptVGhYZFNm?=
 =?utf-8?B?dXQvZ0o3bVdxV2tOUHA5cmNwb1ZSaEdTcUZXS1hYdGhXYkxvbVJTVmdVcEJD?=
 =?utf-8?B?L0tRb1NoK1FTVzN0SHc4eG0vUk5Ia2lGZlh3ZjdDcTJ3Y1BMY1dGRHJlZUV2?=
 =?utf-8?B?QmxZM3lMbnBVQ21LRS9EeEIrbmlTeDNRb0VoTzcvdlRRVktRTFdHdmJqVjVr?=
 =?utf-8?B?UlI3cXhnMHIyMkNKYlhzdytrNkxqNm9lTHQyTDFBQTFrcXkvU1d5ckE3bnpP?=
 =?utf-8?B?VHZ6V3lUUVZEbmlvSjRPQ3J6MGdIMExmS3NycHY3ZGh5dzBHUjhmODFBSW9J?=
 =?utf-8?B?RzY2Y3RBblk2aDlnc3pvR2U3cW9rWm1LaldoSC9SQTdTeFdJNUVzS25ZSjhv?=
 =?utf-8?B?blBmREE4Mk1JSFBpOG1LWm9DWnF1WTk5Mjg2dzlsUnIwcUwwVlhOUXNxWTRi?=
 =?utf-8?B?OGxHdXBHYU03UFo0dWJyUWZYc3orK2VJYTBDWEMvbDRvbjl5V1BORTM4a09z?=
 =?utf-8?B?SGhPUlN0aVBUaHhHZ1JwYlR0S2tieXpnNFBHbStjSVNKMlkwRGNzVlpJV0Ro?=
 =?utf-8?B?TkZ0Q2FPL3o4NzIyUmtFNkM4VXplZTFab1Ryckc3NldUUXpuVFRXamtTREZo?=
 =?utf-8?B?blpxbVVXSnkxZHpKNlBjRTlvWDFLRDRZRW9tbDJTZWJXMXpZMmtTTEVidElB?=
 =?utf-8?B?WXlWWFhMZDJQQ3hyZnlJMVU3a1JiaEdOWUFwdjJsTStFT3RtaEdCM0lNTDNz?=
 =?utf-8?B?aTBrRVA2di9JdGhlcFQ3Y3g4c0NKWU1rQ2d0cFdnQWp1RWpkQ2hUWS9iTTJI?=
 =?utf-8?B?ajFWM0tUUkhLSlA2cnR1VGlqQmpEcGg2NytzUWhPUDc5NTFJOXZDNkRvYWwy?=
 =?utf-8?B?SWVCdHZ2S2pCaHEwTmpCVEdTN25nb2pvY1hWT2hNZkFTVnZVY1gxOUJyUm56?=
 =?utf-8?B?VXFDZ1JYRE1rMldSMjgwejh3aFAreWRQaWprM1Q4Wm1FSUo1RlRENlBkSUwr?=
 =?utf-8?B?czlveng5WVdOcUpPM3VaUW1jeHo4OGZqN1RpN0d6VE9QZi8vcEcrOWsxaCtt?=
 =?utf-8?B?aSs3b2J4QTl2M1g0aDNlQlBVRStPQTNwWVNHR2JrZDZkR0w4T2I0Vi9hOVU0?=
 =?utf-8?B?Zm5hcFY4RnN4VWJ0aUdzR3FJdUFWZU1EcUlSVXUwRG1sWVNMUHFqUS9DQkVM?=
 =?utf-8?B?czBnOXhPdVR6NnpqTnB6eW0vSXhkSGpwN0RwdkNjTGRxYjV0dEp0T29HcWo2?=
 =?utf-8?B?MG1RNjc1MDNLZVJHTWNCNFM2M1lDQ01TODA4UTVhTWdtL3FvY2FPMXZtdkdF?=
 =?utf-8?B?ZkhCbFpQVVAvNXVFQWRYT1M2L3ZLMk5BVDJMN2VHK09XQTRtZ3BNLzU1N0RX?=
 =?utf-8?B?N01wUTFkbXk3MHNqVmNKd1AxOUZBZjVkNGtWU0VLK1czYW1xQStUeDVpSDlI?=
 =?utf-8?B?RmptaUdla0o5UmJUUlBvTHJWOHlUdGtORVZKZHh4Z1ZsbHhrRTVHaFdGZ3hk?=
 =?utf-8?B?ZXdGYlFWWWRSR1pLbFY3N2JCeG5LajhMTEwxZkZ5NTFVRzhlWXV5ZTBKWnZ0?=
 =?utf-8?B?R08xL0VlNHZUNWFDUDd1TitBZjRNV3NHQlBRUnFINGk2eVlxUk9CUVpVbFZ3?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5050948-ce1d-48f3-e8c3-08dd9cf63bad
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 08:12:33.8145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNeTpdaJpSOyzmkIWHfv3fo4m+KEPoEDXhC4eu22H9tSqcJd2WITZ6dePMWSziknLYv7OciW1dE0HMOVJ8+3Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5308
X-OriginatorOrg: intel.com



On 5/27/2025 3:42 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 27/5/25 15:47, Chenyi Qiang wrote:
>>
>>
>> On 5/26/2025 5:08 PM, David Hildenbrand wrote:
>>> On 20.05.25 12:28, Chenyi Qiang wrote:
>>>> As guest_memfd is now managed by RamBlockAttribute with
>>>> RamDiscardManager, only block uncoordinated discard.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>> Changes in v5:
>>>>       - Revert to use RamDiscardManager.
>>>>
>>>> Changes in v4:
>>>>       - Modify commit message (RamDiscardManager-
>>>> >PrivateSharedManager).
>>>>
>>>> Changes in v3:
>>>>       - No change.
>>>>
>>>> Changes in v2:
>>>>       - Change the ram_block_discard_require(false) to
>>>>         ram_block_coordinated_discard_require(false).
>>>> ---
>>>>    system/physmem.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index f05f7ff09a..58b7614660 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block,
>>>> Error **errp)
>>>>            }
>>>>            assert(new_block->guest_memfd < 0);
>>>>    -        ret = ram_block_discard_require(true);
>>>> +        ret = ram_block_coordinated_discard_require(true);
>>>>            if (ret < 0) {
>>>>                error_setg_errno(errp, -ret,
>>>>                                 "cannot set up private guest memory:
>>>> discard currently blocked");
>>>> @@ -1939,7 +1939,7 @@ static void ram_block_add(RAMBlock *new_block,
>>>> Error **errp)
>>>>                 * ever develops a need to check for errors.
>>>>                 */
>>>>                close(new_block->guest_memfd);
>>>> -            ram_block_discard_require(false);
>>>> +            ram_block_coordinated_discard_require(false);
>>>>                qemu_mutex_unlock_ramlist();
>>>>                goto out_free;
>>>>            }
>>>> @@ -2302,7 +2302,7 @@ static void reclaim_ramblock(RAMBlock *block)
>>>>        if (block->guest_memfd >= 0) {
>>>>            ram_block_attribute_destroy(block->ram_shared);
>>>>            close(block->guest_memfd);
>>>> -        ram_block_discard_require(false);
>>>> +        ram_block_coordinated_discard_require(false);
>>>>        }
>>>>          g_free(block);
>>>
>>>
>>> I think this patch should be squashed into the previous one, then the
>>> story in that single patch is consistent.
>>
>> I think this patch is a gate to allow device assignment with guest_memfd
>> and want to make it separately. 
> 
> It is not good for bisecability - whatever problem 06/10 may have - git
> bisect will point to this one.

Bisecability seems not a strong reason, since what problem of patch
04,05,06 may have, git bisect will point to this one as they won't take
effect until allowing coordinated discard

> And it is confusing when within the same patchset lines are added and
> then removed.
> And 06/10 (especially after removing LiveMigration checks) and 07/10 are
> too small and too related to separate. Thanks,

Fair enough. I'll squash it. Thanks for elaboration.

> 
>> Can we instead add some commit message
>> in previous one? like:
>>
>> "Using guest_memfd with vfio is still blocked via
>> ram_block_discard_disable()/ram_block_discard_require()."
>>
>>>
>>
> 


