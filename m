Return-Path: <kvm+bounces-71194-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKXREUfulGnUIwIAu9opvQ
	(envelope-from <kvm+bounces-71194-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:40:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2281518FA
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9617B303FACA
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C15315D5A;
	Tue, 17 Feb 2026 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T2ExyTvz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D6B279DC0;
	Tue, 17 Feb 2026 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771367896; cv=fail; b=bgrFHSApC6Nlh5yrR/FE71pVyOmeyqs6ZFmN6H92uc5rE8YGpW/YSr8v+X905ZOZvi3fSkdoB/Sxz0+YaLBDVQVXU2vmRn7D88BH977OA27xOM+I+sOECkuNcUTzl6q47cuSLVKREsH1hFoSC8TATCl6hu2sUvZIq3uHW/1vgFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771367896; c=relaxed/simple;
	bh=HHOHpnJ6TZCr4ayx9gwVNaSJaYxeKuPAuoTIZvQ1qS8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NRioFwHilCtZtDilUZTYyOPvBUkRRKPpqZCTyjktZGj4HzHX7A8Vv0V+7Pzg+Olsq9v+XcS6/FLbkzWCgz2DxeGFe3UzrxfEHGbF1aZfFJ+B0SdKfFopyLv9aqouESCd6ZGDU9JVhXWnvBH66Z6TCdHIUGZ8UH7kcJeC5nzJyTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T2ExyTvz; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771367894; x=1802903894;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HHOHpnJ6TZCr4ayx9gwVNaSJaYxeKuPAuoTIZvQ1qS8=;
  b=T2ExyTvzJrB/WfVYOiOFdl1ZPSeacX4DX7kQKJfwjUjqEuF66SI85ZFu
   FCzXklVd6VZ3F2wQ1+dwuoMmMX/1LH6B2jcNOvMDuQXJ7WqfeusfrAiba
   mbmaFpLmLqT9P7soIWjMiFDmHUdg5uIOPE/tDJgCVdyzNnqzHnzS/BUDZ
   c/xxt82ggnaL8q16ArjQfgdhriKj4qMBlFRPJ3VuSGS0bZ+hdCfTHnRos
   UH844NU5EUpfDmy9oWQurBbNajyrVffNK1T4curF3I8lgMONCzaFxJXja
   RK8AeDSNpzm8IbuMj8aK4QtupBEzWuBA8UkRHFJWwTRSsv3x5udECfPl0
   Q==;
X-CSE-ConnectionGUID: pvRHaP2zRU6vwoCiFndzAg==
X-CSE-MsgGUID: vIF4S2EHQO63A/Dvc7Ds2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72539762"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="72539762"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 14:38:13 -0800
X-CSE-ConnectionGUID: P/j1IgEpQBOhMf7eLFk4Kw==
X-CSE-MsgGUID: ayDVVk2qR/mnVavC7ahuNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="213867758"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 14:38:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 14:38:12 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 14:38:12 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 14:38:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBGJapjYKqfk/aykuwbOu18ipFRdF8axVw3rRO8cTDfjxWHAEofTsqUrHIxKVHERxBaLhraaWkqCKLkWeMR7QUC3puEDlr4ouvCqshHcyhhdn31OWs0sakBlQ5fQBZLmr1/2ZL05RijntBnLBh4M7KMgHuCoxSYf5nDf/c0GClaqLet8/JKu5qHclZqxrqZnScmMg3YthBem9lVWc4tCGBNEYIseGHCa6q/40Tz7x6e1JcP1qPxPFMlLrcpyEtBiJ2coyp7QJtHMIZyPwJriipmP6G7Hmy6UurBTKoxncCiOImyLx5UodMQnbR/gDrsLX+W8QP5TJhHJ3SZWKdtgVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SL8J8/UGg9zKq83OXjvhMUQ8Xu0+i6K+2fs2qOcVVVM=;
 b=MQtIZLiWwZ83A3aprxaIEZbPRViTMeJ+XJkHfHfOq32/qOCCkAlz9JDkeaq/IKjAGWyIpO21krrH3tgL6ekVzLMvMqlsCmLiiiLRffB/crPXSwNolcZBuAQQmFUq2fLqC1uS7szT+xKNitMbr6/tL4aKHMzpHIlxzn4E9sMAooPUHAVe8rxRtAJt7Jhc1uuxgnRlNVpSuWOSGK/KYs8K6lgbXunv0h07XduAn6But2TteRZHJLbajRZkoRWJ8Up+E4FSlY+5+8qL+Lo7fHlDPL/46r7RW5Gl2J8Sgi94oFygG/leFloJ1i5IPKtOFUprzAzk8cKysKk9F1LCVv4t1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by PH8PR11MB8037.namprd11.prod.outlook.com (2603:10b6:510:25d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 22:38:08 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%5]) with mapi id 15.20.9611.013; Tue, 17 Feb 2026
 22:38:08 +0000
Message-ID: <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
Date: Tue, 17 Feb 2026 14:37:49 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>, "Moger,
 Babu" <Babu.Moger@amd.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
References: <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aZThTzdxVcBkLD7P@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:303:85::21) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|PH8PR11MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e749a6b-299a-4efa-1f3b-08de6e7538fa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bXhBTUphT0IxSVZqQURJUk5wK0ZOaEFZZm9La1RTcVB2cE9hYzRCeXcwTmNq?=
 =?utf-8?B?bFZtZHhCNFpiNllVUDg2cXQ5aTRLUTJiZmlDdXNsVlFoN1NFaVlsR0tEU1JU?=
 =?utf-8?B?ZGs4Qkw2Y2Z3dlo2UExiSFJ1RjdXaUF4bVUyUDN0eUt3ZkJpbTRCVVlwQzJy?=
 =?utf-8?B?OEZHbnhpeUZHc1JrMVJvVHZGMkRNYkczQUtCNWtGS056RU5lYWpuTzJTbzVs?=
 =?utf-8?B?MEFtMFp1eDRVZGN4QkJUY3VSTVFXYWxScjBIYkRpZXBRMmIvdld2Y0x2YnF6?=
 =?utf-8?B?ZzRaY3lnV3MvNlBSOHdsNmFDWmwxZzJvb3F4YTZUekp4emJTbGdVcmE1Zmw5?=
 =?utf-8?B?NU9SeC9DZ0k5b3Y1RXZOZjNYdXNhNlF4T3BOaEQ0aWROYXZ5bGVzNW1CUE5C?=
 =?utf-8?B?eVA0SXl5by9BVjAyNzMwOUNTZW9BZ0RGVWx1bzN4VjJaUnNsa2ErY1FRc2tx?=
 =?utf-8?B?dlZZNzNDQnUvZkcwcXhNc3B5WnFTRG93YW1QMzdOMjBTR3JFWWQ0MThLU0p1?=
 =?utf-8?B?emFJUzRubUJRU0dSRjZWRzg4SG9NOWJMK2RoZkhpSy9OL0ZSaWtRMXNJNk85?=
 =?utf-8?B?bjFSRVRVSkpReEwrbGFqNER5OVJ2UU9vaEs5NXJpMzJPVHE5T1BIRnp6YjVx?=
 =?utf-8?B?S3FSWWY5YTlON09VN1pNbjNkelB1UXA4eEFUTE9UcERjQW9WKzdWY3Z6ZWkx?=
 =?utf-8?B?K2pTYUtodkpIb1NCSllWRXoySEdCTkN2bHh0cFdqQys3MmhNWjhTNHQ2cGFy?=
 =?utf-8?B?eHArbk1HOUpKbm4xN2Y2OWVSYUR2QytFZFZ1RlkyWW1Uek8zeWJNZlMyMmUy?=
 =?utf-8?B?T3N3QU84RjRlQ3E3ZGFRYzV1WE1GWnlpRnpRTHhEOUhYeThRMUM0NVhUMjBa?=
 =?utf-8?B?QmkvU3lHaE5zUkk2MEtCSWNsNWJ4RDJtZTQvRHZFdS94MnBCM2srSmJFT2F4?=
 =?utf-8?B?YW9QT0FhdmFzNGZ1anV4OVl6dENKU0g0R1NoRkptMUJjVnV3S0dHelp2R1V2?=
 =?utf-8?B?OXQzWU1IMDRnNW1RbGtZNGI0TmpnWWpLQlRLS29sc05BMmVrTGVhQ2FVWUs0?=
 =?utf-8?B?bGtObnd2VnNxRFo3UUoxTFVheXc3bS9EOHFZZDRYTDVOdEF6L1JEcDZ5TFdS?=
 =?utf-8?B?Wmh6cjRJWTg2NFQ5bkROczNmcVc4SUlOUWZuVk1Yd3ozQmpGSUN5VFdVUTBm?=
 =?utf-8?B?V21jNkI4UnpuTXFMeHZDZk5YTk5pZkZ6T1RRUTNqRWZFZVFsM2E5WDZTTkh4?=
 =?utf-8?B?Sk5CQWpoVExmODNRelBuRElrbi9vbmdobmpVc2NTRjYwZVE0Qkx2Zlh6TG9Z?=
 =?utf-8?B?M2hwMDVNb0s3Y1IrZ3F1ZGttVGNSaDM2YzYxYUNCQmRhYmJRSmZKWWgrbHNB?=
 =?utf-8?B?RDBVRDV1M3BDQ1NYeGFXNDUwN2U3U2R2amI2MXV4cEwzN2docmc2eEd4ZkEv?=
 =?utf-8?B?YmdKS2tWSFdFeFNzSEZlSmdUT1NtRUp0Q3czSm0rdUdObnZKMjFiRU1EcDBj?=
 =?utf-8?B?ZVMwZmZnajNaRVZoLzJFeVIvVmt2SHR0aXAwTk1XUEtwdFFJaTJBZVhrWjYx?=
 =?utf-8?B?UWlMTUdvM2ZzcTFEMFpIZ3BjcHZLZ2U4UXUyUDdQM21oSmFGS0RMS3ZSUXlx?=
 =?utf-8?B?bzNNUi9BQVhKVTlCK0RoWnJQUnRxRnBOb1RKYWVIZlRpcCtjT04zUXI4ajdP?=
 =?utf-8?B?Yit3ZnU2b3MwNnFPKzdtbHE0YXJqcGxiTVZDZENXZmJuRzIwS2pwd1BEaStJ?=
 =?utf-8?B?eTY1MjlJZnpCaGhLTHBNU084amp2S3FpU0syQncxaTFUV2RiRS9HLzNncnE3?=
 =?utf-8?B?M1o3cC94TFppQmV1c1BTOW9xYXVCNkdReGdaUFJoQUxIN051MDZjNkNEejhJ?=
 =?utf-8?B?bVcxdFM2cmUzajQ3ZDlLeUxCbUNiM2QyVGduelFjYm5IUzVSNy9vcDNpMUJU?=
 =?utf-8?B?c0JvajVicFhmS1hWLzczaUFmVStNdmthYnBYUUNURVJURE9IS1huMi90bGxF?=
 =?utf-8?B?eHN0MEpaQlhTRFF3aUMvcnp2RXliNXg1dVlkZERmV05HdWdBWFRDZTd0Q25V?=
 =?utf-8?B?OWdGcmQrdk9RU2hVY2tkWEk4elBDT09YRWVBZzhmYSswNFJuR0F3cjR3aGtC?=
 =?utf-8?Q?3QgY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGVYeEc0aFM3elVwNkZ3MFg5UEdrc1pmSkpGdDRqRS9BcGdqZWYwc1Z5N3d6?=
 =?utf-8?B?eWk3TXpzTnBEMUszdktrZVNRaE5TRStHM2x2VnV5aHdoR3JzTXVaK2JlaWU2?=
 =?utf-8?B?UTRVVjVYQy83RUVveVNiY3YwVlRndGxFcE53cEZoWTlSVjJlajdUMkM5SlU1?=
 =?utf-8?B?bkNzOCtIQmJoL05jR2lMTXRTUHpYQUsyclBqWHRraEY2SlVoc1RjY1h4SXNP?=
 =?utf-8?B?U2kyaGdaM1oycHFhWFRXU0R0MllyZ3VDVmVNUzZDTzhqZFhOcWIwK1RaT0VY?=
 =?utf-8?B?aFNwQXIybTNlN2pwSTJyUkZFN08vY3gxS1Jib3Y3VDIzbHNNQjRPZ2tOQnRC?=
 =?utf-8?B?RU56VU9TcXhCUDFaTmMrWEpBdk92OExxTENobHZsY2ZZRWFRRm1JYUFJcUZy?=
 =?utf-8?B?K3Frc0t3VlVIMUJDRmd1WXFHRDdRL09UOWtIWDdCMFpXNUNxcExMR1lUeENh?=
 =?utf-8?B?Y3VweTlRTVFIZUJycll4MHlwbmdyN3c2Q3FsSFhYeXQxNnJWeUcrQ0Z4cFdk?=
 =?utf-8?B?VThONjduUVNZaDBpa0J1dnhSRzhrcXhhK2U0UUlZVXNaWjJ6aDl0cnhPTmRM?=
 =?utf-8?B?ZktWejFTWURRZVE2SWx4aElwSUc3SkxLa3c0ZFZyTDZBM3VoYjY0VytMdVZr?=
 =?utf-8?B?eUx6Lzc3YjVRbWZXdzJ5bENXS0gzcmEyNTFjcWdwYVAwcWx3N0swTlVscjFr?=
 =?utf-8?B?VmFLdHFKUER0cEI1dFhsakgxb1RjSEgvQmZTVjFFZWNKRlBoZ2gvYnhnV0xp?=
 =?utf-8?B?QlM4bFBMZ2JDd1ltM2FaZ0dFL0UrblUyM2F1T20ralBYTDQvSldiUjNmY1di?=
 =?utf-8?B?UDJXMWVtSDNFRWl3TWdiOTdwbi9tUDdxUk1KS1RjZndlazZKN2ExcTFOWnFp?=
 =?utf-8?B?MERsMlFSN1B5TjlwOE9IZXBud1RNL2FSek9PRjZVWXhvenVpMmE4Tm5zWllJ?=
 =?utf-8?B?dVgwOUlGSmVYUC96YW1uWlpYZXQxbmc0SEVyM1ozZitBWEhOSDNmajFlODBI?=
 =?utf-8?B?Nk5HeGRyRUp4Y2tmbkhLMmJWOTUxbC92Z3ZRcEhZY3lGMFRzK0EwOVEvcFR2?=
 =?utf-8?B?NW1mUkczN3VHc0xFUFFybzFyNFhwM2lra0dOc0VVUEk2dnUwdWVoMGZ3MXdY?=
 =?utf-8?B?RjZCMUJXNDFEQVkwZ3AwRTJubVJLQmFJOG1jV1dTV0dqa05ZWlk4RG8wdDdy?=
 =?utf-8?B?czgrRHFkQjZQSE9ialZ1ZjIxMjZ1bnZTWDZzYm1qMVVXVXREQU9DMk5IT3M1?=
 =?utf-8?B?TGYwVEMrLzk1MkhxcmhsZCtOK29laU15NnB6RWsxTVpFMTNyTWwxOHUweFJB?=
 =?utf-8?B?WnBqZ0ZrZVgwT1lZM3I4b253THorL1RjNldwb0RtVUZEZTRDeU1iWDFFTCtj?=
 =?utf-8?B?dG55Ky9laTE3TGY5a2JzTWhBL09OS2FLVGU2MlkwYkJmSkVmaW01Q29OOUdU?=
 =?utf-8?B?QURiSTBhSi9iVnJFcC9yWkZ1Q1RlNjRJdmUybUlsbUh4WGpKZWltcmt3RUVM?=
 =?utf-8?B?ZFdkak5VUHNjWkg2NXg0NDdaVm5xYTlRYVplRmhocFhYQTZwejFHeU9SRlNZ?=
 =?utf-8?B?OU9WWTI2dHNVejgvL0R1VlhTYTJDMCtWMDhGV0lBN2wxZzIrZ3FCQVhnWmZv?=
 =?utf-8?B?dEVnT2dXUSt4U0VlbW04Y29NNXp1bENrQTJUL1pVOGJNSU1RUXpSSDZob2dP?=
 =?utf-8?B?SjNYZnlzRjVJWWc2S1JDMEw4WitqNXhQWit5djY0dENFYks5YWJlRjh1b3JP?=
 =?utf-8?B?OVYyYkJGOUgweXI5SWJuR1h6TFR3dndiUVJBSW55dHFmUzNSRWZSSHB4bUVK?=
 =?utf-8?B?eUZLY3B1Q242cEVSbWY4SWNFV01DVmlqdUpBMDlCUU9ESGtWL3NjWDVEQlFm?=
 =?utf-8?B?VTNwUlhBQmRkT25GSjdBeWFjblFSRGE5NTNSL2RVTithazlVOGVXVlJ6YlpK?=
 =?utf-8?B?OUlFbTRsT2xvZWF4bndoaXFIbHg0bDZYK2E4eFIrVVBCekFKRndVZmtrVnk1?=
 =?utf-8?B?TmoxM28ySFJDOHcrSmpDckNUY0p3UDFDRDdvaDFsYnJxdWY2c0tHMll3YW1Q?=
 =?utf-8?B?SGtXb3dFbW9HTlVVZ2ZhOWZMaEZXc3FVd0pHdXh6clVqT3RYTU5oaGJXckFR?=
 =?utf-8?B?VUh3YVFKR0hlTzRKZ29Jcm1lVmpUTmVRdG92NWdkcXJPSTh5OWdQQnVzUXpl?=
 =?utf-8?B?SVIvK3NqN0kvV2VQNEdkYWs5ZTF6QUhKV3M1TXhGUDZTcElRTHFMZzk4dTZE?=
 =?utf-8?B?bC9veGEraXR5eWgyT2o1M3FWWWI3dnlzTkswNzhNTnBlNjNWT29DU0RJcFR4?=
 =?utf-8?B?L2RaK1F1amZOUVB1dG1pdVIxb0xLaUJaZ2d3bkZ4UDdQT1JKR1dLVTkwcUNs?=
 =?utf-8?Q?VezONWnXXp7MghRA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e749a6b-299a-4efa-1f3b-08de6e7538fa
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 22:38:08.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FT7ky4H0nk92xYiBTkDQb3ETQLL+gdwi0Ep47u3SbkX0lYQn4pKCBo2qQcw6sUwivdD4mScn9gEeFcbKrbDOJj3WQ+xOTJsumD0iEnZQik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8037
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71194-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: DD2281518FA
X-Rspamd-Action: no action

Hi Tony,

On 2/17/26 1:44 PM, Luck, Tony wrote:
>>>>> I'm not sure if this would happen in the real world or not.
>>>>
>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
>>>
>>> Indeed. This is all getting a bit complicated.
>>>
>>
>> ack
> 
> We have several proposals so far:
> 
> 1) Ben's suggestion to use the default group (either with a Babu-style
> "plza" file just in that group, or a configuration file under "info/").
> 
> This is easily the simplest for implementation, but has no flexibility.
> Also requires users to move all the non-critical workloads out to other
> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
> 
> 2) My thoughts are for a separate group that is only used to configure
> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
> are used for all tasks when in kernel mode.
> 
> No context switch overhead. Has some flexibility.
> 
> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
> group in addition to belonging to another group than defines schemata
> resources when running in non-kernel mode.
> Tasks aren't required to be in the kernel group, in which case they
> keep the same CLOSID in both user and kernel mode. When used in this
> way there will be context switch overhead when changing between tasks
> with different kernel CLOSID/RMID.
> 
> 4) Even more complex scenarios with more than one user configurable
> kernel group to give more options on resources available in the kernel.
> 
> 
> I had a quick pass as coding my option "2". My UI to designate the
> group to use for kernel mode is to reserve the name "kernel_group"
> when making CTRL_MON groups. Some tweaks to avoid creating the
> "tasks", "cpus", and "cpus_list" files (which might be done more
> elegantly), and "mon_groups" directory in this group.

Should the decision of whether context switch overhead is acceptable
not be left up to the user? 

I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
the needed registers will only be updated if there is a new CLOSID/RMID needed
for kernel space. Are you suggesting that just this checking itself is too
expensive to justify giving user space more flexibility by fully enabling what
the hardware supports? If resctrl does draw such a line to not enable what
hardware supports it should be well justified.

Reinette


