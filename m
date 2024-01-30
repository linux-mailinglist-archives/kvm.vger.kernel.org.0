Return-Path: <kvm+bounces-7480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD14A8427A1
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 16:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1FB31C213AA
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 15:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8771272BD;
	Tue, 30 Jan 2024 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OuMqjvcA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C491272BB;
	Tue, 30 Jan 2024 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706627141; cv=fail; b=MkjItsqmXUKaVEKA1xMM9XCQSJZGX3SMOZsNgahqvO30Vl5nCiSzDD9ER38Y5vW38dZGgqQ1CtCfCy6s/K0ZuTf84t2x8L1QX4Xb3FPKre5U2zLuMWf1wNeH64QCScKW1DMW0q2DfNUCnTrckipOMRNzTo6EVBfdqCmce7Z5k04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706627141; c=relaxed/simple;
	bh=WNvsp6GDhFNMG1jhBYsxi/g//2ESE7SWFAM6yiuXvpM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g+mqGQDJv+E0uCl2rKlXVYy/4dDO1qbeAWZqqvBkC5A5PrUGPOOZ1l4ZCpQaPAf9eihoh4CEiSsbXNmtCEvj6I2Xp+LC0CHFmVT8ruyMGCjdnUYDw+9vNOSy1t1e3dtUS4mbt8VRFYoFI7czSH8u1BzGJbyBakrBRl3ia7pJVxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OuMqjvcA; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706627140; x=1738163140;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WNvsp6GDhFNMG1jhBYsxi/g//2ESE7SWFAM6yiuXvpM=;
  b=OuMqjvcAPST4ZPHUpsV+Jlj8g2Hpr5QB+m04Wf7at7YN0h2ySr+m2Dcr
   QNufVB9och/Cs2eeZfSWxbn6jkJmN2ywavpfEiSgZPXtmGBPLc1xmVz3X
   cBtySKpAk+6albOGqYwmDWiJ922+Fw3Wm1+hv8r3LZ15gurSS/PrsYNV9
   EusIMWv45SZJW+O2pR+w/0HUTG337hQ/VzNS8UVidx6/DlsH3LvAkCIUq
   K+fPsZ/aF4CEy80K3KUkz+Yy9xGmzMDryomaKiwy4Wrsg+T61gius8Dwf
   g5GlES4xQvEyiwT7o0XIiFhpevtkaB5Qz0OlhQSh5eFXQMHyAxl961KIU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="10049117"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="10049117"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 07:05:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="3741156"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 07:05:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 07:05:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 07:05:29 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 07:05:29 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 07:05:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJ39sSHvwJy1cc4QDzmHEuGK8MurNknc7pfhF3WY6i0sOU5u8XBWevcFw6wp4J2pdBGu6aCjujvEO2BMCnftRoV8SNONWe1eZ0e7g/0VeL5IiOCHnbIe2AoVsG0Lq/aMW6iSFKCuJtcsb2+w5tUSDsKM/No1qmKnCzIpEJ/ePIunIn1Mz5eQvKfuvls+7tyu3RCZuyy0lfDFL3ryuJb9h8+O/IrpzVRoPA5daeY46DXNBiYfZ+VNACxMfMcNa77/3NyglnDXci1/u4BIzLLnCJczhcodE9i+C9HS+aZWHGFbwB4igbe7f1P6UADwmjS8yi1h4wXPnobodg6lmjgERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNvsp6GDhFNMG1jhBYsxi/g//2ESE7SWFAM6yiuXvpM=;
 b=INzDHS2Om33IdCofquj8W1a5m8SSN2qJTsYfRhCBYoVL+pI1q+B3iifLHSzUP8/L+3BNpOdbs26m9Bf/U+aDLLqxMPVTEKlxvyJK4jBKOvmisJEyN/IrMAeLfPAWFeC3TxXMS4rlWyTOji2KjSUR94ajg314IEnX2pXr/Xl8Mq7RhpQhYiQsgyRa55PWHT3+X2vuj/oaAEoVIRP9IDCJ1+KJSZNzmLhGgBVaa9C1c3ZqRNMHfAm445PJbB14Izs4hW2nMV19o829ZZLsFmCNlEonCMZlxs36e1yaIkv8aKIMPXG4L4BSOVRaIjPcvmmprEfixo1Q1xtfa4UnHTVZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5454.namprd11.prod.outlook.com (2603:10b6:5:399::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 15:05:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 15:05:26 +0000
Message-ID: <0b7be62b-73b4-4ae7-b8d4-88e83f0d03b8@intel.com>
Date: Tue, 30 Jan 2024 23:05:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/27] Enable CET Virtualization
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
	"john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <01235a152b201705bf59088d36eb820f5b35b8de.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <01235a152b201705bf59088d36eb820f5b35b8de.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0205.apcprd04.prod.outlook.com
 (2603:1096:4:187::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 89a51d69-eb77-4027-9d09-08dc21a4e402
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lU9Ij6WCDbQRCckEL9gm89rT1ZsWs+yHjPgT01SoPOZqKXMYlbAxWUibD9+ev4dQEWH+QwkcN6wdDzuYl6Ba22bNPmq9YtiNlzb5eobMcQZZDYIN410aQGuFm3O9KAJGTrc3oFeRnCr5gxoWjQ41CBExRDFwOW37qq2fm/voAZ2FtzwMICuO18qWsDYzXpKwWrZ0NS64CLSY9oFzQV4azWukCp+4HDk7zFf7gFhb+eXTd513rP16hVsSNsrA6DUw8oJvrTHBpsgE4/ge1nwc/1jxYKnjJzwbWlxTm9MHZPVcknZUCLA3iQtJMFA/xbZgBWVe3oHxv80ZBcm/va+tW/AjotePBkdg6/yYaG943wvZRo+wQaUqHWR+JQMwDpiS+YEGsn8KPVPMn6miMsPoT98pjbEYTtru1alhtooPN01syoScLAmtz7EzuXhXPs/UqYyWGXVG0Oz/lwWVj1Nm2LTQGj76HMKIUAQ27KTiNp39cC3ow6miPr0c0xKQmQps+UN9OkQrFCil+TjnfrsyGhumsDS+yCxgB7v4/sQNSWXCGEALx77K73wg3x/iwcw3e9cUIUZsTBnMsFFLuNu1nC5T5yOe0ursqIYm79sk16TTkDmTiGavl4Ge0hvFWco5Z/6h3yO2RYm85gD7uTDRuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(39860400002)(366004)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(41300700001)(26005)(2616005)(31686004)(6666004)(6486002)(36756003)(6512007)(53546011)(6506007)(478600001)(38100700002)(82960400001)(86362001)(4326008)(5660300002)(66476007)(6636002)(37006003)(54906003)(66556008)(66946007)(558084003)(31696002)(6862004)(8676002)(8936002)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjJZb1NVUE05dXhyYUVwNEpaOU4yOFJ1MU52WWdBN2RSZzZqQUVQR1hIK21F?=
 =?utf-8?B?YURsNERBaDJKcjFTNVhTWkJNTk5LQXhhWHhXdjNTU0pFOENtTVhuNXF0R3B2?=
 =?utf-8?B?VVNaNGFqTmZ6ajlQL3NKKzJPeXhYZlUzT1prazZoRUJkc21DSWlPckpGT3FI?=
 =?utf-8?B?MXE2ejFyR2dEREdWdzFpSkxqR1p1blhCb1ZlTERMaGlsdEF2bFdINnE1NGto?=
 =?utf-8?B?QUYvQTlOZHZKTkxDQzM1aHRRS3BVd291Wm1kSGh2TTY0dU43SUNJSzhaYWxV?=
 =?utf-8?B?Tm5BdERtZDlqVE1aVzZ4dU0rYm11d08zYm9tNmg5dE5oTjNhTnZvcmVjLzF0?=
 =?utf-8?B?MFhuZm5zWllVSUlwUTY2QVdEekIrekZEdmlPM050L1B3WmswN1YrYVRsRlNv?=
 =?utf-8?B?WUZnTU9IV0pXa1FZZWxlenVKQmhLNExjWFp4MnVxYTN3Mjk5bVIvWDJmemtM?=
 =?utf-8?B?YVEyeTBYMkdEWWovcWJaa0pXRzJjRlJYek1VUUllOW1xV2ZuUjVvV0VuQU1O?=
 =?utf-8?B?cERtUWxDc2xEbzdyMGRrb3BVbmhCbUQ4ZlJ6b2ZhZ29XUU4wYjZ3cWtQSEZ2?=
 =?utf-8?B?eXQzN0lHUDRSdzF3cXlYaUJkUjlWU1pYdFV0OXljTUFZdmJkM0NMakJRV3Vh?=
 =?utf-8?B?L2tTSzZIUjRtRnhMV2RQbzhsT3VCVVh2dHFOaFBTRlpHUXFzckR3NHNvRGY5?=
 =?utf-8?B?dDRzdHhocDM2RnBRTFZmN3dKdGYwa0o0QWZTUis0dE0yc1lOOGh0SU9YWEVV?=
 =?utf-8?B?bUZteW4zRkxaNVhKUlVSalg4ZTNqaVpCMEJnQ2ZubXJKYm9YV1B3OHV1RWFs?=
 =?utf-8?B?VGlWZHVGRElJYmpLMTNFK1o3NHhEVlMrUURENU9ZTjBMdW9oa2xOVWRXYkQ1?=
 =?utf-8?B?dURhQnJGT213cmZQbTQzakxpL1h0aHNGNGo2dlFCc2VWT2JVWVpmTWdoaTBu?=
 =?utf-8?B?cXc0N1dBQVQyVXF5VWlZU3l4OXlKZXhMYmJXclFaWTQzT1Y5UUE4bElLSzJv?=
 =?utf-8?B?L0lQdFdjcTZoYlNKSmg1REJHditRbC81djE1dVhuQTVUaDhJSnVFNlk0RDhw?=
 =?utf-8?B?b0VpUnEyZHpvSWNUZS9lcmlxWXFCZVBFYXB2dFVDaUk3ejFldmJocjBUdkg1?=
 =?utf-8?B?eW5IM1d0RlR1cUlzQ3hjMUhReG8yb2ZmajMwVGd1Sm9UVGtFVEtEelZFeUZZ?=
 =?utf-8?B?NDE0RjdPMXQ0eG5WRWk3eFhoS3NNNndvRjJYVnNNUXQxNElTZjQ4NUxRQTNJ?=
 =?utf-8?B?QU53OXNLckZLSSt6bEhhYlFIUFB3SHViNkxHdG92RHBDNkdRWGlnc09UbEow?=
 =?utf-8?B?UEgveGdhNXRLbjRwdTBKc2pmMzZWVTl3UTk3WjR5cWJpejNlZkVlTTlhSUFt?=
 =?utf-8?B?N2pJbUJYNzNkemo5SXJIb1hwcFp1REkzRk9vd1lqWDBra1RIQklPVEhSOE04?=
 =?utf-8?B?V1AydS9Nb0xoeitXVTJTTFVBN3Z3NitHaDF6MkZtUnlZZHZwNWtiaE1rcjRS?=
 =?utf-8?B?MlRJaEFFcHh6ZFhUZFNLejkxVHl3K2JOejU4czZKRTRkVXkxaTVXU1U5ZVgr?=
 =?utf-8?B?amFmNk9uQi9ZTmNwY0dZOTE5Y2pNb0tHT29ib3NGeTJEa1hRTnBnVXFHbE9s?=
 =?utf-8?B?VEJJcVU3eDhJaDB3TGRNRFNiWCtSVDlxcUE0OXhDVVpCQmxKblJpVE53NkVv?=
 =?utf-8?B?eG9EQ0NvT3VxS1Y3VFRsekE2cEpGSHk3QnRoMGRWUkVUeGhUZzFNd2xVaEpI?=
 =?utf-8?B?SXlZZ2RWL3pidW9IMGFycU1hbTNScTgwSTRybjJoOFRkMkJMOWphdExlcklZ?=
 =?utf-8?B?ZFhRaU5veWlMa3REdnJyYjFrUTlRVkJuZlZLNkhMajR5QXhWblIrb1VtWFU2?=
 =?utf-8?B?Q1JGL2VWS0pVeEdHc2RDOXVaUEdjRnRsaHFOMUZuSEJZQXQxYXEwdHFidzlJ?=
 =?utf-8?B?QnBHazEvTi9aTm00SzkzRzZINDlZc2NNSk9uajcxdXhpbkFVOTNhc3l2NVNT?=
 =?utf-8?B?WGc3ZkN5MGxpM0lrdktvOGp1NW1VZzlqQXBSUlcycW13RjZ5NVl2aFY1aGJX?=
 =?utf-8?B?K1Njc0NyTVBFLzhyNUt5Mmx4dm1RTzg3blo0b082RjFOUElFUnZhYTlmZmRH?=
 =?utf-8?B?OXNNV2Y3NmtzS21IR3lXcVZoY3pseGM3VHg0bzRENFNqTjgyMng5bFAxOC9w?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a51d69-eb77-4027-9d09-08dc21a4e402
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 15:05:26.4504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZN0OOXCGqkH3ehxKYrCVBGIYhScIUaYIL7T0Eba7n9d5XDFHTn5SxAvBQW14JHuNNX9FyHYTp3XoFhsq4FYlIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5454
X-OriginatorOrg: intel.com

On 1/30/2024 9:40 AM, Edgecombe, Rick P wrote:
> On Tue, 2024-01-23 at 18:41 -0800, Yang Weijiang wrote:
>> This series passed basic CET user shadow stack test
> I retested this with some heavier userspace shadow stack activity and
> didn't see any problems.

Appreciated for your time and efforts!



