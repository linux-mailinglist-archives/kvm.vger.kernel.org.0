Return-Path: <kvm+bounces-22536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8079D9402BF
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 02:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34BFC2826D2
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 00:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2939F23C9;
	Tue, 30 Jul 2024 00:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ElYo5pvy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220692563
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 00:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300693; cv=fail; b=JyO5vmkQa0vQg++3VuIGZTYKlLs/1RHSO/tGKuZHsquHJ3lp5Ps1sn+b3GdxJYmrf/H/C2k2En5sOD58fkuOayv+MqDXVHt3hsqhyt1ZlzcYLYWWfw9VMoxrsYGmEVi3t7mxlz1iGONU5d7l805RNoB0iazVksDEySFaEbhC1HI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300693; c=relaxed/simple;
	bh=ovKMphT+MozgzGJOO+3nopTYyTwVnY4kbJ+R9VbwTNQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aZShF4rRcWAuk+BqNlqP+yD2GjYc1LbJZY0csc3mzCLjtNnYTQaObaNou+xR4E/OTGHY6ONH4uz/OnL6LPyKvzweE0+bGhAGKNK1L5FmamW35hIuHdCy+m0/NCydM4hlxTt64moGnwv03k9xB281E2Rmg/HsX4eInPR8296yy0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ElYo5pvy; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722300691; x=1753836691;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ovKMphT+MozgzGJOO+3nopTYyTwVnY4kbJ+R9VbwTNQ=;
  b=ElYo5pvyAwHF7i2ca4+ogxZgiphCSEpMpDGTwkYekGGAnAre5ih5XJV0
   G3a2g1PRIyCjSO3n8dSc6ZoTVRoLcw3JHblnacCOoXRCVFcJyrB2HW243
   suNmHubAQ/vKnaHuAOM9TuSApyOC7nJo/xJPNaXk650MFHPQ4xUViWRRO
   FU/Xngh8OWtxcdd8h+TbdaPVX974zwSbr/XPQ6/R7AAeN2y0fzgC4+OX+
   DBemqGbdBwbZu5f/df09ua4xFWOmaxD0DPJeFxXUoSURR90jvzgJRfTBQ
   mtqksOVhB4N3s5NAAIainKMvScDtgDR1vFxyyJYABtGjFODnbxZmxKLn/
   g==;
X-CSE-ConnectionGUID: ArvhzGK2TCyJuWynypwInw==
X-CSE-MsgGUID: 5/kAo8EIRFiZPDbYiJ5DyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11148"; a="19932421"
X-IronPort-AV: E=Sophos;i="6.09,247,1716274800"; 
   d="scan'208";a="19932421"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2024 17:51:31 -0700
X-CSE-ConnectionGUID: 7btr9OLqSvm7/KdaaFt0Ag==
X-CSE-MsgGUID: kqva04l1SDihbGR2wdQ7Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,247,1716274800"; 
   d="scan'208";a="54125072"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jul 2024 17:51:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 29 Jul 2024 17:51:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 29 Jul 2024 17:51:29 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 29 Jul 2024 17:51:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qYYQE0jvu/eP+YCNDjnnfPPHXj5XhTp/UZ1MxwCmQwB4EnHT2YBbD67ecGRjxksx8C/2xTW4AVWNait2VeG3HX7lVjyxoC3Bwq3tiOnKgXRfHcYShLbAxf/Ch5dQmFNud4fFb0D2pG+LZYa1yv4iAWs/qV3KS2lgY1HQsYUnINN+b50c6XbiQ2ldK8Cand9AZhcy8MUxK8UIaxyvcQZPyean3idpeBrd/MQKPnCQDA3R9AKhvswYTRjBDsxEKDQE0PDWYFMF7lu0phcuOdu3CAYB8L8qQiRgqkXtr/WMq8VJ78ZNGvQzZXEHNHoissOmnktb4oGkzwJkBNpDFbnlhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNvTV6tfoj5XQMx79VQvdZmYsb4mfRD7d/MkqNmNr3Q=;
 b=Yu97fyy8kefou33pQEhY5P6B+uqVtiSOsDHADjSM5g8b9zk3LqHhbdLpoUBdRFQUqZw6izvdTqkiu4oi6IQ3MTU/uh6eEYqham4UPmUJUDki+TVxrzouEzkLmO7QWnrVVTyfVvzWylaXXhChETvbkU0tf59MH+ZFSGvyp19AskMtNRBSzPxID6OAQ+Jv5N2K1clGwwTN35ogOUZKdyXw4daIr5cguajhPVIReTqUDluXxdWsh2Cpn0WlV6ZkTEFOyHWAGkGdYsKyV54AMlVCnRE5r5TrNqdMcKA2KaxTi1ltT1uTC7XmIaKJ7xO0NoOiyHWYlCY6nlayaz0ndwfQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 30 Jul
 2024 00:51:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 00:51:27 +0000
Message-ID: <bfc925eb-276a-4ccd-9178-60ad89843afc@intel.com>
Date: Tue, 30 Jul 2024 12:51:19 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for
 temporary variables
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "flyingpenghao@gmail.com"
	<flyingpenghao@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"flyingpeng@tencent.com" <flyingpeng@tencent.com>
References: <20240624012016.46133-1-flyingpeng@tencent.com>
 <171961453123.238606.1528286693480959202.b4-ty@google.com>
 <b999afeb588eb75d990891855bc6d58861968f23.camel@intel.com>
 <Zqe1t_tc8LWNv39J@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zqe1t_tc8LWNv39J@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0072.namprd08.prod.outlook.com
 (2603:10b6:a03:117::49) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|LV3PR11MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ebea85b-b883-410c-c0a9-08dcb031be17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T0VDektwZGhiaDU4NlpSaVJZSWMzRGMzMmljbDJ1RldsQXVBd2lEazdJMVgx?=
 =?utf-8?B?Rnd4Y3J3TldMMUNrMUhqblFnVzR5SXdPQ2FjMFBOSUNIS1c5VGVIMGc4OXdk?=
 =?utf-8?B?eis4eVUxWlFHSmdTK0ZaZzZBWjA2emJOZVpoVjJ1SHRPckVBWEk4RTZvU1JT?=
 =?utf-8?B?VlNuc0x3L3NlQjZLeEFaZmJCakVsZDlBRStsczN4TU5hZWQycS9PMUIyWWN5?=
 =?utf-8?B?cExRTk5lbW9EWGxSTEZuN3kxS1pLS3BzU3BZS3V0UUpmWmc2ZmVkd0o4RnV0?=
 =?utf-8?B?bTVwL1VXTTRiYjE3eVEwK2pmMlN5S2lxWW1zMlE4N2FQeUJZZzloNHg3aDRK?=
 =?utf-8?B?d1krQkp2SWpudWpLZ0MvT2RaRUlpRk5wa3MzV0xqR1ZIcHZmcDF2WWhtUU5R?=
 =?utf-8?B?NUVFY3JRZ05UMW1pUkxGeExZS0VPdFVNaWdHM0xuNGtCbGVLT3k0ZnRZdkt1?=
 =?utf-8?B?eFVtWlorK1VSaWNtZ0xEY0xVMjJ6dktBRnZKZDljazJvZlNnTjYyWmJ3UVZH?=
 =?utf-8?B?eE9hZG5uQ0JjV2pLdnZneDFkNTVscE93bEZ6UFRDSk9TVHhTYlNIdGRGbnVh?=
 =?utf-8?B?b1YyemEzN0NHVjFuSXlmeTg3ODBaRDNES3gxakthN2dyRU1XN3N5NCt2Q3kr?=
 =?utf-8?B?YzczUXB3N3NDbXN4MnJ6MEFtNlZ3OWRjUXdaTUk3aTZlck1kTTc4amxYd2hn?=
 =?utf-8?B?d3lTaEc1ZkM0OGVUUW9SQThUdEJqK3JBSzRUZE0xYVo3SDZKOFQvNUhtZ2lS?=
 =?utf-8?B?TGhXM3V5ZDRFTUVCUUcrODVyNGtQenh0dTFpVnFVdDBhYTBidHNoNFdIdzBG?=
 =?utf-8?B?dXlEcGJ0YWxwa2pic3phblUwd0VrUzNxelNWWVptcmFSbHdOTjVnclFwRG9L?=
 =?utf-8?B?V2EwL2pSOVk1UVVJUFRTK1BkQVpUcjdId1ZlZVJiU054MUpSMHZnYWtoL205?=
 =?utf-8?B?bmhiZ2FLSTcvVWdINkJqaEtXN3l6ZWk4empkOUsxa3ZlN0hvUWNJcEVWaGl4?=
 =?utf-8?B?YzY0eW1aWmxqbDJiU2VPUDFJZlNFRVo0UzlEditKOE5XS1hBb0hHcFJhd1pm?=
 =?utf-8?B?TnRXalJNUWxLRTdESHlCZ3liSlRBREN6S3luYWN5a0daazlKWnNlTmxhdXR6?=
 =?utf-8?B?MGNSb0ZBSGRzTHhxVVZHOFpRV3JtRDUxcUE3blExNlR4M25ub1ZURklLTG9y?=
 =?utf-8?B?dnQvYWhIbWUzSk1tREdiYjdyaHMvcGxFQVJHbExJODNqZ1g2bmRhbEk4QWM2?=
 =?utf-8?B?MEIvdjgrQWFaVHkzUys4dVFCeFVKS3hpN1I0SEhPWVdZM1RIUGU3ajRRaTBQ?=
 =?utf-8?B?TmluWXRUSGlFamRqb0lHeUN0a3lmc0JyczA0VklhNEl4bTdCT3VwbEkrT3Fu?=
 =?utf-8?B?S3dmRFBQcXgvMXR3ZFlZdEhxM3RTUmoyN2d4MWdSSk5JcmFSc09PQnpydVlp?=
 =?utf-8?B?SE9uMHd1VG9GUHNGRUZlbW9uUnZoMHNzNzJHYjArU1RBWmJaQTdlcEpwWlZG?=
 =?utf-8?B?Q0tLU1ExblpIcDdaWE04R2Vra0ZKZlRFU3RWUXhFbVVmTXRZTTdFTzVsV0wx?=
 =?utf-8?B?dU9tekY4cStrMFBsVjhSQ1diQUt0RGtaTFlkL2UvUDJmSjRYZFRPYjRxUnhq?=
 =?utf-8?B?dW8yenB0U29CMS9ZS2wwby9jK2Y3Z3NvL2dVNmV4V0FvQTRJRXpsaTdncXJR?=
 =?utf-8?B?SkVFTlNGUXpmcGt4U1BoVWY5cVFzenRMLy9iRWowTjN5U1gvL3NzbTVrYkdv?=
 =?utf-8?Q?GACuZygsZa0zt/bzhw3jZOCHQMs1TArwbmr7LIK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXBSSFVRNzlRKzFRWFpuUmlEVlp6eGRQZ3RBdTBOUC8xN3BGUUpBNFpJV0JG?=
 =?utf-8?B?NlMzN1Z2NEpqbEd0UlNwbWorcXdZOG9IRTJUMitxbGRpc25CSVNhWEh6VGV4?=
 =?utf-8?B?b2xLYVcvb0dnRTBYUC9Yb0lQbzNZMlR1WHJUKzdVd3V3SHBIUVRGS3k4UFIv?=
 =?utf-8?B?SHdBVW5ONG45MGNqbkZieTZIek9nZm9qSzlsK09DYnlDemR2SWZCZzJ1WnVy?=
 =?utf-8?B?cWRYQVFwVUg0K1o0L1BQVkNqeVB6cjM0Q0xsUWh4d203V25kdTU4MXp1RU9R?=
 =?utf-8?B?cnBwMm5ZL2lON0tDeU5FYmE3cmhSSUluWWZNNTQrMDZYK2pnaVRxay96YlJa?=
 =?utf-8?B?K0ZjUlczNklGODBUNWF4Y2UxSCtwWWRLMFBVaUVxMlpnWWV5NGdWRW1NRmpF?=
 =?utf-8?B?U0RqSWRZWlFCZmpvYXo5UjlWL3N0dC9FSXdiR0pJTHBhclpxWUQ4MjZQTHVI?=
 =?utf-8?B?OVE1anVlK1Qwb1FwSklVbTVFK0JlNjBtcTBWOWFWVXJHYnkyRk9zRjhib1JJ?=
 =?utf-8?B?dng5MFh4QU1CSGY4SWVTdkc1cHQ5SldsQ3dkb2REWk9DbkEvamFWeGt2bVJU?=
 =?utf-8?B?YnZGWER4TGQwZFp0Sm0wZmFVamoramFaMW9qcjYwSnY5UlFReGFHQlZjMDd3?=
 =?utf-8?B?OWdiQXo2SkJrOHduU1hUM2Qra284dmlVZGkyaUxhVHF4MW1EYmNoRU80bHpr?=
 =?utf-8?B?bjZkb3FUVW0ySXh0SGxub3lncXZ1WHFBRURGc0FLbkphTXJnZ1JQeUNZem1C?=
 =?utf-8?B?NlJXZUp4akVkd2M2QnF4VXZYYjkrVVNPUWdtaXZhUllpZm1MWHU1UXFTU3Rh?=
 =?utf-8?B?bFJFU0lWWUg2WUI2UVB4VmgyQlpVQ2xoWjRsTmxyN0srcVYxZ1g2TW9rZG5W?=
 =?utf-8?B?ZFFjclJQc0cvTWcvekVwYUduRG9XZjkvWkVMU0paRHVFZm12d08wSmVMUVEr?=
 =?utf-8?B?ZnJuV1NjYlFwWTFWeGczcllMdURFdUpZM3M0ZkY5UzlsczYxMFNaeEpqMVNU?=
 =?utf-8?B?cnhTUVVDWVBtT2VTMGE5cUQwcXl6bGlCRDhpbko3MWZzbzZtREhuWDgzSGgz?=
 =?utf-8?B?d3JLenJEcnB5WGxzRmdreXB3aWhEUkltMmlHMVp2VE1rMUszbGo5b2dPZVZN?=
 =?utf-8?B?NHJTZ3o3MkxLYTBIZmJLOU5hd2d0dERET1BOaUJQc2lmSVJYL2tRMkt3dXRZ?=
 =?utf-8?B?MGdKNGNRMGhaalZKU3VVdlhvSWFFNllkOVJEbXRHT1dUVUNtNjY1ZCt3b1Yv?=
 =?utf-8?B?RGo0OE5VK3VOVmppZ0RLK3Z2Z1MrWXdEVDQyeFhMNUhHdEY1T3kvS2lWbTk0?=
 =?utf-8?B?ZkVSOWNiWHlQYkpPMFJ4bkZxcCtQZWlrU2JJOGlxdTVkTFNHeWlvNTRsWUpT?=
 =?utf-8?B?aTVMcyt5NlZIMHhOa0E1VFlJRFlUcm0yZEp4aG8xRWpOVlFKOFFqVjI4cnRp?=
 =?utf-8?B?T0RhZVpvWjdpQy9vV1pQYm9IUDQ0TE5VZjgybE5NUUE5RUovYVg2UzhLSzkr?=
 =?utf-8?B?WTlaNEp3b2FBTGwrTWFseUVoYWNxZkJhZ05PMVpnajRXMmdwV2VVVXhVUkwx?=
 =?utf-8?B?aTg2WXhnK0JFYUJ0cHVKc2ErenBQTW5IN3lJWXJNY0gyUDdzcTl3cWFJcFQy?=
 =?utf-8?B?cHJIREs4cWtWeU1sZEhSTFVzbzhWUDVZTk1Qb3BzcW51Q1NIMzZ1cmdEeGVK?=
 =?utf-8?B?TTcxU3UzenhSUnZkK0YyMFdkOGpsK0xSblpYcUU0ZnUzazg4dWMvdlp1aFNI?=
 =?utf-8?B?T3BLcysxa3NQMXZBQjBtem5OTm5sSUVCT0V5WlhZVUlKb1JBc2RQR0tzS2hH?=
 =?utf-8?B?RjhUb1ptb0EzVmxiVmtzbjJBa3JLN203dzJiOGxFL1NaY29VK1BVYyttRksy?=
 =?utf-8?B?Lzd6eHpnZG5Gc0kwT1B4dmtZTzZLbG9iWERtYzJTSTNJMDltZjNscmo0YTJN?=
 =?utf-8?B?YTNzVjg3b1IwM0gzVWJDMFlwSHVWaTJ6d2JmQ2lHWnNuZlJPL1IwRWh1VFRx?=
 =?utf-8?B?TVNWcWdqbkVzS1o4UFUxMUMrS1gzS1A2TFRzWWhiK1ViRUpQK2pNSVBNMHBr?=
 =?utf-8?B?TytDWEk5YUZHTkVpQWo2TmZ4di9nSnVYUEttREZGb1AxQm5KQ2hqZG9EcmZH?=
 =?utf-8?Q?t0F/WNVNADVHaIWNPe/1h/aHi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebea85b-b883-410c-c0a9-08dcb031be17
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 00:51:27.0672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9A+s2Co+iO6ntaeYT4IcRkX+1NdE5LtGYdESpZno9ZrhMkAFX4Pg75owwCdztAT1KSF+A93ityHZSUXnIb/Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8768
X-OriginatorOrg: intel.com



On 30/07/2024 3:31 am, Sean Christopherson wrote:
> On Sat, Jun 29, 2024, Kai Huang wrote:
>> On Fri, 2024-06-28 at 15:55 -0700, Sean Christopherson wrote:
>>> On Mon, 24 Jun 2024 09:20:16 +0800, flyingpenghao@gmail.com wrote:
>>>> Some variables allocated in kvm_arch_vcpu_ioctl are released when
>>>> the function exits, so there is no need to set GFP_KERNEL_ACCOUNT.
>>>
>>> Applied to kvm-x86 misc, thanks!
>>>
>>> [1/1] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables
>>>        https://github.com/kvm-x86/linux/commit/dd103407ca31
>>>
>>> --
>>> https://github.com/kvm-x86/linux/tree/next
>>>
>>
>> Hi Sean,
> 
> Sorry, lost this at the bottom of my inbox.

Thanks for getting back to this. :-)

> 
>> I thought we should use _ACCOUNT even for temporary variables.
> 
> Heh, that's what I thought too.
> 
> [*] https://lore.kernel.org/all/c0122f66-f428-417e-a360-b25fc0f154a0@p183
> 

Thanks for the info.

Looking at Paolo's reply and by applying this patch, it seems we agreed 
we can just use GFP_KERNEL (e.g., GFP_USER isn't needed too)?

Anyway I've sent a patch to change handle_encls_ecreate():

https://lore.kernel.org/kvm/20240715101224.90958-1-kai.huang@intel.com/T/

