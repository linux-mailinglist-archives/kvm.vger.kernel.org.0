Return-Path: <kvm+bounces-63094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99880C5A8A3
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:26:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 538E93A2EE2
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93A0328608;
	Thu, 13 Nov 2025 23:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jhgpdsqo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458BA2F6186;
	Thu, 13 Nov 2025 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076374; cv=fail; b=gw7h2pgQH9qqc5Yg1eLpEnDjnMWu5q/zUXq+VvHOoyxR+ly/b8r073gsZ4wDMx9iKleF0E8DuLHOqLos9AZP5X/l2hD93Us4QiHgsgbJZKwUoVEJBNxgyL/Ahb0ypJzTZKey8h70J5Wu5tdFV/E0HcX5hXhXKfClLlJ7fFNApzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076374; c=relaxed/simple;
	bh=xRF3wcL7y0k+8hwIzFpXBzg7XtTo0x41NeqmluR+2c8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TyMIpnc8wDlBNh24DjzwM+/VGLcWw2KhlVvBGAx4dkqausbduaEEww1Vxpn/u0esIe5GWk4MZde7riHmAAS68ZDGU7FyqpVZIpap/ZXmZmS+ZfuXk+p21zjR8VBq7y1jCLbYmHM+df+nBWZeA0P9nfoaVKCYc5Kaip2Jq3vKedg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jhgpdsqo; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076373; x=1794612373;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xRF3wcL7y0k+8hwIzFpXBzg7XtTo0x41NeqmluR+2c8=;
  b=Jhgpdsqoo2YTTt+kaCmDl+vOH6zZfbMH9aO0o20y4IqOzYVXYPDR58RS
   kcEpuPVq89/2c7WhSsakXAclqCXOsxB58K4BC7nyE7AgGjR0I3wSm0KyN
   v2B1eyJrbRUXs2/tGUb77PqJgMbkIAPU8J4QfWwOZVef1oLIowKrt9OlT
   c3Xw0lIBp92LDn5Nkg6Djc/g4ZplcORwUeRyO+FDao4ztNq2yDVgQL6ob
   b47nEg5ukFRfpAqugmo9r/6OBwlFWysGfr2QCCC0UhMfzbSsh6/bMRQ1/
   q9k36WNmcayDGQVWqY9NgJIj+ty8HnY880RqQpI2LFDVToQTvlio6/Ky1
   g==;
X-CSE-ConnectionGUID: GjkW3c69SHK/p3isYEPomQ==
X-CSE-MsgGUID: Ff8F059SRYmNztCGB4LqjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="75777939"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="75777939"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:26:13 -0800
X-CSE-ConnectionGUID: D++AKAp7QjOIkCemtJPgvg==
X-CSE-MsgGUID: UITcPsXyReqKJAXfcqOFdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="194067004"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:26:12 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:26:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:26:11 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.31) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:26:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQRL2P2ptpu0nFhapK8GOixkwVO/0P5vhsEkTWqdfgpy8ZgLuVh8a7CksZeO/DddPONmGExAxXFLSRAz/UPB6baJhQ/Iv0dHlywYj0QsNRqjlQ6ROZWQu+txfll3pQP8sZuegLV7zeOj0xs1xL8gbICR+Me8eT+uWMg6ScrWKyYy6w/isJKjNhUOsOqWSj/QHoJJ61DsVTM4LwPmC/2acV2jPf+iAkrePrcnJcOpDRiOQ0sAgGYca0ureOaaLG35VKicRi8sCvsrZk8ayvLBY1EghoR+8JOhdD3tIU1uru2GayNOHkVb/41yqFxIMXWYsKznSxDiQdK8ZeVmzto48g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgyQBp5pGOPGZ7/3VsiqE/RO2TbFCDViH3bys727e14=;
 b=IQvl5zWD33NvRyxbyFk49IY+ZY3Ba1B0rN5cjtmmgTVKeNze6es7qA6j3L8+gW36IhmA3GGpBHLB4sy3YirfTbptSKM+p4XV25vQaYlAhcO0YtmovD5XuAWxPBS8PaRiD1l4T1yKC5uhh4zH+6Z3oBLKQ/2ukn056j7fuGMwxkplZJJYrCnP3u4TvEyo2orQDW7mrlWNghCl0Ru2tZkHk5WvOvEjX04ZS3pDpu583NJoXkKt7GpvHNxwDKfXoo1oEBnpvu/v+zz0rPw3RJccP07Ozy+wG+hOjQKrGuioWVkXD+bg3Hw0nz+uC4l6bUiS74vyRx6BqLogwNa8Ii3jIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:26:08 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:26:08 +0000
Message-ID: <2216d4f6-cdb3-4403-9685-5622830a0177@intel.com>
Date: Thu, 13 Nov 2025 15:26:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 12/20] KVM: x86: Support REX2-extended register
 index in the decoder
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-13-chang.seok.bae@intel.com>
 <3d93c8bc-8f13-42e1-a9e1-0d27d7e8603b@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <3d93c8bc-8f13-42e1-a9e1-0d27d7e8603b@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::16) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: 61402d28-9903-453e-c229-08de230c0639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TFdlRE0zYTVNa1pNdHVuWC9uRVVmUys4SXA5TDBJaTJDaEd6Sy9TOVRNWkRw?=
 =?utf-8?B?R2lrd3p2YzRCWXJ6ZHNVdFNQaHVJUlhhNzVhRDFPb0pDd2Rwa05RVzhXeHV1?=
 =?utf-8?B?d1dIU01UK2RJT1QxNzhlQ1FKUDVyM3gxRlNxNzNpWVdmZDNzQVlWc2lxamxW?=
 =?utf-8?B?M3c3SkZHRVNqQTJWd011dEo0V1c0QXQ4VVZKUXlQT3N5a2ExcnpoOThIa01w?=
 =?utf-8?B?SHhENTFCZUdEbElHR3JMOWJHVGxBYzlwTGRCUHkzbFQ1Zmt6T0RnNVNMRHgr?=
 =?utf-8?B?dWRLb2ZzRGMvQ3RmT2NicGdwcHVmU1IwQTFUQ1RuSmphUHpvaHFkbCtkdWF4?=
 =?utf-8?B?QlkwR1BQSWlNL1dxUytuOXBHMkNKUDMrZnYxbmROSm5iNXpxL1RKRnhYY0g3?=
 =?utf-8?B?eGFtUllvSEM0cmZWdEpFZmg5YmtFQmJVQ1BYdHdxODhJbGZseVBveUJQQjhF?=
 =?utf-8?B?OEYxZEYrYysrTmdnaDIrdnVVcVVsYUtKWGlEUzdaNWoxQ2h0N0dLbG10ZXUy?=
 =?utf-8?B?S2I3SmljSzU1VE1TS09sbGZQYkR0azdDTDNnUlN5Zmw1eFRSNkYzNFBxNm01?=
 =?utf-8?B?S3lvaU1yUHZla2Zpd0VRb3M3TVNZSi94eDNhYXhtU2VobzFFNmRmNDdoZTlo?=
 =?utf-8?B?LzE1U0tmQlJuaVB3N20rcXY3Y29RSFNkWEJ6eTk3YUtpL04yeTdRb1BPVDdM?=
 =?utf-8?B?bmFCRi9oR0VWTDgrdVVsQ2VXcnJEa29qNXNiZ3hmY0NMbDRZYkFySW5laVll?=
 =?utf-8?B?cDRhQWNMbEpWczVZVHl5RWEzYTlLRzU0Wi9YWXVpQ2NxWFFaYnNYUC9SckFR?=
 =?utf-8?B?d0FNSnVjbG53RUh2OUgxK0RMdnF5ZmcxMjRjN0ROY2YrYnJIZDlBenVtS1lN?=
 =?utf-8?B?UjFGaEh3ZDMwRFFDVURNc3VPQndwcGVSWmp5QU1VZ3llL2diSjduRldRTE5r?=
 =?utf-8?B?cnVJaWZ6dElSbThEdWZVWWk1V2FtZWNiYWo0VThLcHNiaTZtaHV4Mlg4QTEv?=
 =?utf-8?B?UjcwSG8xaFNUU1ZSd3c1Q05lclJVZzVodXV6WHpHMjNoR2ZsWU9UU3hRNzVy?=
 =?utf-8?B?RTBBMjdsSlBOSDJsQ2cvVTliNGpRZHlrWS8rOUZnbWlYRDF1N0dUWVZWOGZT?=
 =?utf-8?B?T2RXdHNlQ282RUZOQXBhM1RoZkRocFRISy85dHI2Y0dRVGpQelRydTV6L1JP?=
 =?utf-8?B?dXlZYzhTZ2xpYmc0NlB6QUJnZ3doVlM1YnJOWWlCL3lUWUVQZHZqUkpQanRG?=
 =?utf-8?B?QnA1dFBTQ1Y0NTlpMWVxcDhXK3FhWlJ0VngvZmhFem9YeWttdFdvRFNWT09p?=
 =?utf-8?B?a010MlBxT1BQWDdSeTFtWVNMU3E3ZVhVazRRSzFJVG0rTTNVWmt6QnNBZ0k4?=
 =?utf-8?B?ZXZKQU5nQjYveFo0a09ITjhaaTFoSDdVVzlHejlTdjgxOGQwZVJyclhVK1Vo?=
 =?utf-8?B?MFFQZENxaWoxWmpKWW1LMHJ6dHFwenoyaXZBT3pZcUh5b080MVFaNXpvcnRI?=
 =?utf-8?B?NGZnaUhFVlJZcmdnYnRnQUk3LzNwKzBURCtEK2hUSXpXcXlDUTB4QnQ4aHBl?=
 =?utf-8?B?bHZlWW9obXY4RDRtN0tjTmtOdU9nUEJaRWhQd09MRWcyZXIvN3VSQjhMYWV2?=
 =?utf-8?B?b0haYklmdWJCYnR4b0RGRkcwZVAya3pFR3E3QVZEQnp3M0dKMFo3RDExK1pS?=
 =?utf-8?B?b2t3RFNoVm9XTXErQlArazBQMnphOGRBYTZocFJyOG10azFHYXhTajJPaUhn?=
 =?utf-8?B?dWtqYUZiS3pLVDltK1dzeFVGRHg5Y2hhMnUrRjRmd0R4amRZbHFUY0pIZkRS?=
 =?utf-8?B?YmVINm9Sd3E2K1psaVErNUFVTHlCSjRJc3puVGR6N2FkL1d6ckNEclRtYjdZ?=
 =?utf-8?B?VHVqYlQ2NWJ0T0QxVUxkekJuSXlrakFPVWplNzFucElpVWVIcXZKQXlFRkRC?=
 =?utf-8?Q?Dh1xfz/g5dJ6U45ptDEFe1V9IZoF7Kl7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVB6RWY2T3lMOVp3ZCtCU2F6V0dTMS9qNU9USUVJd3FIa0ZRSys1YytjQnhS?=
 =?utf-8?B?eFVhaURFR2xGdUJwa0hteFhYV3VBR25EQml2MVdxdmV4SmxHbzNFN1hjbEZZ?=
 =?utf-8?B?Mm9CQWpNamw4MjJUem8wNm9qYnV2TE9LemRwTjFRaWZ4enVBZlFjb3VhSUR3?=
 =?utf-8?B?VU9HTmd1dHk2N01ETXU4Vmt1R0ZqVXBESllXTWYxUzVFY2FaUXpKRnhXK0tJ?=
 =?utf-8?B?N1J6MHFuY0ZZNTRNdldnMXNJd0t3aTdqbUE1anRaekl2TXVqb041My9laEVx?=
 =?utf-8?B?K1M3ZzBGK1dJb1ZNMkx0STJEY3doUlZmNHUvSU1BNnZPNDZvL1JzakdCT0Zl?=
 =?utf-8?B?MDlQKzhLdTBQRmdFSENreThORlRoOHJUT291ZDdJUHovSTFSQy83TlBNL0Uv?=
 =?utf-8?B?T29qc1k3c3Fub2tVdlVtbjg0Y2dpNkFQejRYRHRud2xhR29PMzhRZTZxRC9P?=
 =?utf-8?B?VHJLaGdZQk1Sd01FZFJtZkVrQTVHTEsreURGWXM1cHF3akFCdW1EZWVwSVRy?=
 =?utf-8?B?UDFOZDRuL21yNDh4d1pORkZWLytyTW52TThscVpGaTFKVzR2bXR4dXFSRHJt?=
 =?utf-8?B?RWVhdEY1UmxIM0d1RzdsdWhnbjV0VFpHMDB4cmFMWldWeEhmK0JyYjc0cUZQ?=
 =?utf-8?B?ZTJhZjFzSXVSVW9BaENuUW4yS29YR1RrYU4zU2FUcFhzNnVRREh6UndheHo5?=
 =?utf-8?B?cGc4c0lJTFpLWld4UG1rRlp3SFJmd3c3aEd3YksvUXh5bUZGYWFNNzhRTzlW?=
 =?utf-8?B?WWlSZzBNK1YyVjZDMnBoTTIybVJ4aUJYV0Y3NnNyNk85dXllS0l5VVhPc3c4?=
 =?utf-8?B?cjJFcGM2VCsyZWdqbzJ0VERieW4vN3ZOSzdSL1M2L2poQ2hiR1BDVG9pNlg0?=
 =?utf-8?B?N0o3MkFTQWY0OEZqanR3bkkzdXFldkdKV1dBUXlmSXFERnZHL0lYNUl3Vy9D?=
 =?utf-8?B?S0pXUGRydENwV0NNQXJFNzhCOVUvamE2TWN3UHJQRlp6Y3hZOER2TWpVbVN4?=
 =?utf-8?B?U2x5V0tRcG5rNzRTalk3RnArQmNxYUtrZXpuT3Jvek5BYm1DUFNNVGk0dm9R?=
 =?utf-8?B?M21wUUhWL01KUzFQenhiNnh6bVEvTUdXV2l2cTRuc1pJNGkyTnpZVWNtMVVO?=
 =?utf-8?B?aWpJbzJJNy9WcWlLb08wR2M0c3oxN0VOSTJMYWcweDV1eURKa21kU2ozOWtI?=
 =?utf-8?B?REtlQlpmV0x4TkxNV0pZSnJQalhVV1NpRS9VblBVU05qWHhHNFhKVlV1ekor?=
 =?utf-8?B?Y3p4eFRTZnRsY2I3WmorQWJjb1REZ01zT1BuZ1pYSkNiUmVBZ1NsY3ZZbkpH?=
 =?utf-8?B?R1ZVTmYxNUo1eVlsSkhYUWJvSTBhMDhUVWZDWDcwUGp4d0NoTCt1eUNGS2xl?=
 =?utf-8?B?b1d2cDhob3Jib2NrMzFOZ3c5eXZHc21GYXJGQzRQTmFYVHFGckVNeTBtUjlz?=
 =?utf-8?B?b25rYTgvNEM5cmlEbEZBcUNPcG92SDFuOWpXbFltZ2pXcFdTR1dTWFNPL2M0?=
 =?utf-8?B?Q3ZJOVV4ei93c0FPN1BwK002M0YxSFRoSTY1NUZ2YXovY2E2MFIwL1lic0lE?=
 =?utf-8?B?NjVPMTRRQlhSM3p0dmEyczdXYXE4bG91UVRYblZUMW5LQlFRbmR1R3BtR3k1?=
 =?utf-8?B?Z0lBM2lSeUFvVzBneWNVemQrS0VzSnNJdWFaaDcxYWNibVFlTnduSG05bTdE?=
 =?utf-8?B?czJ4M2grNHF2OUtVS0hOMHkwRStzbmw3VG8xcmFhUjlOS3lKSXl3VVJIaTNT?=
 =?utf-8?B?NDFvdVVHYzJTRHRMbG12S1FyU2daMkxFVlBrWWgyQ2p0UWxQbWRkNjQwR3RB?=
 =?utf-8?B?V2hUdVJhUFRWNjhjWjI4MlREaGFobUhoc2NVWjVjOVVGYjczRTlMMGs1RFdo?=
 =?utf-8?B?aG91WDlvZm1qOE1GblF6RmJ6c0cxQXNTOHB6L2loOUVGRGpGOHNWb0MwQlgx?=
 =?utf-8?B?ajZLZ1h1WDI3RkFXK3ZFbXNoZ2x6MHNGTG9QQzVJNnhHajdDQUpYUHF1YjU1?=
 =?utf-8?B?R3hGTE52b2p5K3FWMlp3ZDJxUkpEUmM0UXdyQ0JEazZ1OWlVTVY3QTRrYVJh?=
 =?utf-8?B?Y0FSbEI5eTdlRm5lY0FxWWtjTkpDN0VPN2JzeGFFRXpvUTBWcHlYT2hvSng0?=
 =?utf-8?B?NU5kQjZnQ0NxSjFvVnNwQzhIWVZwQ09pcmhINzhKUThSY2xmZ0lvYk9IQVF4?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61402d28-9903-453e-c229-08de230c0639
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:26:08.6564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTKfKKgtoJpksYiXOJhcHSRWNtBP+a5q0+0YcQKtG8NFnWnhSBZigrytwfdJu9D4g+ZYHyJR/kwlqtTO2Hwq0KTVKAK36pLQnQJKWwyoel0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

On 11/11/2025 8:53 AM, Paolo Bonzini wrote:
> 
> Replying here for both patches 10 and 12, because I think you can merge 
> them in one, 

Done

> I'd prefer to avoid bitfields.
> 
> You only need a single enum:
> 
> enum {
>      REX_B = 1,
>      REX_X = 2,
>      REX_R = 4,
>      REX_W = 8,
>      REX_M = 0x80,
> };
> 
> for REX_W/REX_M you access them directly, while for RXB you go through a 
> function:
> 
> static inline rex_get_rxb(u8 rex, u8 fld)
> {
>      BUILD_BUG_ON(!__builtin_constant_p(fld));
>      BUILD_BUG_ON(fld != REX_B && fld != REX_X && fld != REX_R);
> 
>      rex >>= ffs(fld) - 1;    // bits 0+4
>      return (rex & 1) + (rex & 0x10 ? 8 : 0);
> }
> 
>>       } else {
>>           reg = (ctxt->b & 7) |
>> -              (ctxt->rex.bits.b3 * BIT(3));
>> +              (ctxt->rex.bits.b3 * BIT(3)) |
>> +              (ctxt->rex.bits.b4 * BIT(4));
> 
> +              rex_get_rxb(ctxt->rex, REX_B);
> 
> and likewise everywhere else.

Neat! This looks much better. Thanks for the suggestion.

