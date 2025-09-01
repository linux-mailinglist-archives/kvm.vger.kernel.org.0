Return-Path: <kvm+bounces-56431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1183BB3DDAA
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 11:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C57C517B6EF
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 09:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A73305058;
	Mon,  1 Sep 2025 09:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hq5n4Vsc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD33043BA;
	Mon,  1 Sep 2025 09:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756717766; cv=fail; b=dEryeLZgI0d2XUJmfSNBrkwdSElkbHmYe1PWmf2szNZ3+I+n4q5gHC0jJnbCu8tB6wbwo6Fj5bn2TdL9C0sU+UK4Td04UwE0bKoMprA3kJTt2Pa8FfQcs5nargufJSJINEHmxZ02WCiMvPo1mcGTVH6dvE5U4HdaO6pwZpQw3io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756717766; c=relaxed/simple;
	bh=m+OzoSCYUpHlNjNx1Xun10G2HabVAiNBsr/VXpc905M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rcuhKpBZbYcZl6ea/uDanSIa6PE7OBc8RvGwGfXYIkkNQrcPyQmRKmuPiNFgO+Fhb3QLfLyHYzNzTb82/Y9LPxOI5EHUfhrG8k/D7LveKggTlwBrt6cC4p/GSpA1+6nu1p/TVdddlXGr/dzekRdFeXqJnbIU4KGqAKgCk8tyExE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hq5n4Vsc; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756717765; x=1788253765;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=m+OzoSCYUpHlNjNx1Xun10G2HabVAiNBsr/VXpc905M=;
  b=Hq5n4VscGkzy37m088Ch3+PhG9jQtFT4l1pOQbval7zSnXDWekFacLUm
   zzm0BfvaSes3Kjy5emz79vKAmTnKvZit18b0mgUwhvv3zPVAsZ0AdaYTo
   CKyqPBJaxTSU/ghHwO7Qk4HcDsuOdG4bG2+ReyP4E131HX2g+4A3EpvkT
   RUnmDa9XT8R49yzvBf5jEwqX8S7wwWYqSY+UyG8rj82J4CIMCXp14SMcg
   aSoXPPyTJ5yzMvszrYUndFY4epjA68Im5BNcmN/PBJRffeMDrUYtxWhdW
   V624dPyWX697OPR6blL+Cb38RXXLl9TRd8NGkeM1daDIIRuoVRa/JAZQl
   Q==;
X-CSE-ConnectionGUID: NvtRbxhYQXq68bhxdeBzNA==
X-CSE-MsgGUID: kQp+GRxPR5WLVd7SVTiDcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="70397327"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="70397327"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 02:09:24 -0700
X-CSE-ConnectionGUID: dZbICqYgTsaSQKggxB8HnA==
X-CSE-MsgGUID: LldKHpSkROCm4iGDJYLmJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171409737"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 02:09:23 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 1 Sep 2025 02:09:22 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 1 Sep 2025 02:09:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 1 Sep 2025 02:09:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZoQM8O9mNthcJ1wh9AEOGUs98L+qwLEXNszA8yFAvnm9wG5P16oP52h66phH6d/mAnBjjTgSF5731RgnRLpOOzS26qT4kcJNKzp6jQolmwcy+XCRVxk72z/4dqsQaM/EaB+CuxGNH0/quALDWheJLN8N9MjW0m7jgiumyF34f4p9sUVplKeLONlOswm93vfCpMU7Oa4qw4hVCdkITPZ14mv7KXlxKhtAzOw+oSxAZQb7f0wVB97FCSIBAqtv7vtuct/PKa+fMzN7Oy8ZJYhUxjhq8Q7FjQ3/vdMJM2g0GoYqL3CJn9OnfqVqB8A3lbgBnP7LSEf6OpDcRJse7qoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oM4AAi42f401f6XA/8JMoslRu3wrVRrA/HCn/garMvg=;
 b=y1FHlPiCMYkfL1CGjtbcIhA+DlPNA6KAdNFcSRvIONyiN8jxf4TzseL01RdsfT42LCJ/D+Gx9HwO/j4ZCh1cGuXiKOOLClc7u9WMdJyL0EAzkO+4xqP3k8c616bjjcOd4TLZiI5wI0Pix4f8Cbfad7Ir6qJYPm2yKkj8JhizJ0BIDAwLuu8yqYpWUMqYR1Met8QnoKhCmq0L9PlZYBmBOzd1HnAFiQqs51zcqPho3TRpclHN2ga0zE72M/SwoxRLYTD33QNDcDYGvH4TgVJ28fIFxHie6wGw/oC3etMjGoeLCXEYBpucrYPiwtgHxeH0j7rLL4WO1SPdumcDUId/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV2PR11MB5973.namprd11.prod.outlook.com (2603:10b6:408:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.25; Mon, 1 Sep
 2025 09:09:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Mon, 1 Sep 2025
 09:09:19 +0000
Date: Mon, 1 Sep 2025 17:08:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094149.4467-1-yan.y.zhao@intel.com>
 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0046.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::15)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV2PR11MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: aceeac26-c6d1-4082-bcdd-08dde9373b9b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WylBj7AG1KJpN//jGJ1XFvtVd2U4e8Q4VQLkHJI+RxLdO/GwSjxzszbNPyPx?=
 =?us-ascii?Q?0s8g0meibiABcIryi6FvcbbushX3necuQrTO/bNPVEk3FHctDltNgqYJewsw?=
 =?us-ascii?Q?sf5pMwPZHwDDbM3n0joliI94wuuym6FsvyVrlZoqVUWLLJb8Jk47OJniyKQ2?=
 =?us-ascii?Q?OkwJcEOYj8A2Oisj9e5RU5qPT79oar4AXefRWLv2uVXtW2S7biQbp2c2oDho?=
 =?us-ascii?Q?OCGLNxBosR/G+ZjoEEiMlFR1hIb5ysmj66GGI/QBKOVti+V2pPIj9adgekfh?=
 =?us-ascii?Q?8akyRrxowRKqD8psq3B/ZnkvDTuKA9kj86xf818gjyoK90vj4ZKBmpWaVjem?=
 =?us-ascii?Q?0Jk1KAEhdlJqOLH3os5mFygp+lVA2KrRlWHVgGdUq0WVKknAjLdhOlkQPY8i?=
 =?us-ascii?Q?BksJMuQnYqb65+p25ZRqT9CfTzkEjMCtLc6ju1RMIjJczTNdAVwscyzqSiKx?=
 =?us-ascii?Q?UsVGtIja81SWvFBXJv+WutmU9zLidFj6jiEJdgxV6uoZUZ8KFRdZZ6pSKr2K?=
 =?us-ascii?Q?/KmLURNhgd5jgXIdEM7nHAji/+qXpH/wlFcdE2OP6C/p2GbBkBdwq7H9lxX9?=
 =?us-ascii?Q?2+HshF0T59J84Jx3o86cBQxSReZt5KGDgWHDxT0xHb+bCGHhg2z4EIhlmVeT?=
 =?us-ascii?Q?zRebM+EvsziBwBNedg4hno6OgWa6ULQV5Yea4BRnh+H/cXC2k/HmudyRkoAQ?=
 =?us-ascii?Q?8cWmY2tUzLsGE28GZQTukDTe0zc7zt1EXmHdopSu+uILMJ+nQ3MgSrz2lzCU?=
 =?us-ascii?Q?XuS9teCig6l14dpoNYKBNqs2U6Edsrk/L+SdWrKUbooT3TedDQauS3R9Tc2k?=
 =?us-ascii?Q?j8wQobllOlJUMIWJ/JxSzq31iW4DkGjYaMfHef0HmBWscpbhGSpqTS9yZdVv?=
 =?us-ascii?Q?tXW+HJtTa9gkqRkQu1V9VFAzO1KFvOyXWdXwdcBk4Nld0nghKgeBpMtdaVA+?=
 =?us-ascii?Q?zZfRAbVL/VVkOOQ6Jciv3b/zKphpcdyIoXQMpjJYLFjObS1uf7eB3aGI/Jn3?=
 =?us-ascii?Q?FyL1x+aNKyBpRZ9L74Zf4izr/XoSR5HRrHcPCNLnuvadDUykOOn2RB2uKi8J?=
 =?us-ascii?Q?tkMsjw9CcYO/wLmUSqt/e6zOql1w5u4LsiM4mf3Um8c5VCUQx2cCd5LIFHrF?=
 =?us-ascii?Q?u5H0RRZppE66AIK2tv5+euewWRNhoIAQLg4+B4f1cDwuOoV6iYsk7fr8GaKe?=
 =?us-ascii?Q?TpFEqqq7Yuj/KNexewxJklbNr0vALo4+aqPr1DgXHRyVthZayE8l4pQjG1UG?=
 =?us-ascii?Q?NGytGtzniiDYRofNX1TYZcNoOhjnq/yGHR7aq9PtgCQtvjZZHEbBDmQ03Dzl?=
 =?us-ascii?Q?VtOHs9bRq8bhGqueEG2S+3lIlaWfG0xbAvR6NaE9t4d1dZL6Df0kfu+BXBzp?=
 =?us-ascii?Q?gpYv/zw6Jqm9IuSMI6hzQ9AR3cLiWyM6nyd1W8wf1qNw7JFpUw6lxkAXpJxv?=
 =?us-ascii?Q?3MZKC6c6iE4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JyPLhEQsEgRRoB6BuDC0VKtjgX3PiZVSfSx3qc83SHZN1Vpny3chlnOk8QXz?=
 =?us-ascii?Q?k+yLCRIDj2s/1FG1qkNgR+7qERIO4o4QAb12MbWBmVXSvfkU71yhYTwvpwDO?=
 =?us-ascii?Q?rKIOB0cmQZ4QugUW1+CfAxa9qLQR/r0VLPL3I8tW0NE6ggwZNRJPqqkHCrz1?=
 =?us-ascii?Q?hxcGVw5DQb3b8r/Z1JsjM3KCsvQ986svPgko2jUElind74wTMTppxD7d+ans?=
 =?us-ascii?Q?SY3hqeCrdQQuz74qK2jGqe14Ob/pjZkwcgkBcrCOukfA3xprK5kBjuEWxxay?=
 =?us-ascii?Q?mjpJZrUF4VdYH+4BOXTxCXvaLCuUf0/trQxvqj2fRlcqQ/XEUXiEFgVXUNF2?=
 =?us-ascii?Q?Lid1fhAIKPt3O8xxbC3muOXXz/zpU/JJFb0FNE+FA2EVeRU8DsLPk2c9K+vw?=
 =?us-ascii?Q?fd8vf52ze+/qmXBbxwhds6xMVJb75UtEJxjSW5UM2k5nm+86wTaOEqqgs9Cn?=
 =?us-ascii?Q?l1OSktUWKL1VFgjuHSTY2slCxme+Rovu+OWH0yZm0LOqEWoVeEMZq6vZyaYp?=
 =?us-ascii?Q?HHFnDyEiVOl6v5GnjKEO3FQ+UvEQ1yBfzAQe3ehtUxe5dvjT9y/NlCY/6zgs?=
 =?us-ascii?Q?syYODlLcQQ45frvaeKW+AusqDVMHyAQdzx5b/l15aXAhEjsVju3pORfK3+zn?=
 =?us-ascii?Q?noyfrjTQL2mXiLLGOT6H2W8eI24frLEGUWjtnZHT1JvPquWX+7JKr50OatFu?=
 =?us-ascii?Q?pGfYvyPstVYWjsQgwviyMtovcZ5HUtxl9dUYu58gF+U2WcRK/fXCGutjJYKq?=
 =?us-ascii?Q?kFbD0AeiB1Dj2uANmLF716FWrk13icHkT1YaUknw4ofeThI61Ci8nvSL2Yba?=
 =?us-ascii?Q?wh/p1Q1UCiUaOGJ0SVORKwk8q4PWfkCO1jBgVjR/jPpQu3AOeYYy/dgHZdJU?=
 =?us-ascii?Q?rSzuHJjyxMaJy9I1um8cB7uGmezYpktHDNqHC9gsRuSMjoBwGhQsbVQiVHwD?=
 =?us-ascii?Q?3E7AwsbQvHsSKpBnFA4eql2ErJcdr2UOKFyVi0xWwJ0GN7j7AmrJl3IrOQe3?=
 =?us-ascii?Q?bb5EppBfV1xFFot/UDmCQjwKNemuo4Lw1QmB5R2UCRdd9QYEU5hSoaTIRXRg?=
 =?us-ascii?Q?2JpAUGBSbxTmLmpvyM3XZuk/lUeyxqo9A8X9oU6fLlwVjJhv4FQReMsabDpM?=
 =?us-ascii?Q?+dvZI52FlLEFX0jmSILE05IoElsiLjn94i/3tSV5AsHHmMDxDbFK7PwzS+jY?=
 =?us-ascii?Q?I29jimW8khWhMIt0m+X5RCwmnEYBBElGQ/M+loWI/vLMXcTLQCp2tksdzsXh?=
 =?us-ascii?Q?K1U3rD47qwJILmlVh9bWkK7D1fESJ5PrBIWMOkbVSnLuveoOg2zaEfzHQRTM?=
 =?us-ascii?Q?M7TgATNKvZRQXQvjAvMisOqQKlqK7OP8xn+wFYqvevtH2/EnZYQhe9kefsQN?=
 =?us-ascii?Q?PArN1yXY4bMFolDM1K6MzlPXYL9JblXbl24iVNQwmf8jdbPkEtsew7o/YyBK?=
 =?us-ascii?Q?uCnV2jYufa63In3ScFF978uun3UnfsK/KFccb82D+lWVolcPkHGb2o6D9a0P?=
 =?us-ascii?Q?z8asbko9Vlamu7GW1hIaycJkfTEqwTCFX6tkUOue5fmKOvF+Bvb7pr9xEt6B?=
 =?us-ascii?Q?ftDzeNl9NRz9q3wbbTVRisw/HG7U357vcu6k8bSC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aceeac26-c6d1-4082-bcdd-08dde9373b9b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 09:09:19.1291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fHODEjGxJ8rQEN5tlH+++7FSzXyLdSYEyfF+XD5esRMX9xW5O3H0ouYWb7jhWm6I9/3DYVgArGDaepLODsnf1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5973
X-OriginatorOrg: intel.com

On Mon, Sep 01, 2025 at 04:55:30PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:41 PM, Yan Zhao wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Introduce SEAMCALL wrapper tdh_mem_page_demote() to invoke the SEAMCALL
> > TDH_MEM_PAGE_DEMOTE, which demotes a huge leaf entry to a non-leaf entry
> > in the S-EPT.
> > 
> > SEAMCALL TDH_MEM_PAGE_DEMOTE supports the demotion of 2MB or 1GB huge leaf
> > entries.
> > 
> > The "gpa" and "level" parameters enable the SEAMCALL TDH_MEM_PAGE_DEMOTE to
> > walk the S-EPT for the huge leaf entry that needs to be demoted.
> > 
> > The "page" parameter specifies a 4KB page that will be used in the demotion
> > operation to be added as a page table page in the S-EPT.
> > 
> > Invoke tdx_clflush_page() on the 4KB page being added as a page table page.
> > This function performs CLFLUSH operations on certain TDX-capable platforms,
> > or conservatively on all TDX-capable platforms, to prevent dirty cache
> > lines from writing back later and corrupting TD memory.
> > 
> > tdh_mem_page_demote() may fail. Callers can check function return value and
> > retrieve extended error info from the function output parameters "ext_err1"
> > and "ext_err2". e.g., due to S-EPT walk error or arriving interrupts.
> > 
> > The TDX module has many internal locks. To avoid staying in SEAM mode for
> > too long, SEAMCALLs return a BUSY error code to the kernel instead of
> > spinning on the locks. Depending on the specific SEAMCALL, the caller may
> > need to handle this error in specific ways (e.g., retry). Therefore, return
> > the SEAMCALL error code directly to the caller without attempting to handle
> > it in the core kernel.
> > 
> > Do not handle TDX_INTERRUPTED_RESTARTABLE because SEAMCALL
> > TDH_MEM_PAGE_DEMOTE does not check interrupts (including NMIs) for basic
> > TDX (with or without Dynamic PAMT).
> 
> The cover letter mentions that there is a new TDX module in planning, which
> disables the interrupt checking. I guess TDX module would need to have a
> interface to report the change, KVM then decides to enable huge page support or
> not for TDs?
Yes. But I guess detecting TDX module version or if it supports certain feature
is a generic problem. e.g., certain versions of TDX module have bugs in
zero-step mitigation and may block vCPU entering.

So, maybe it deserves a separate series?

> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Refine the patch log (Rick).
> > - Do not handle TDX_INTERRUPTED_RESTARTABLE as the new TDX modules in
> >    planning do not check interrupts for basic TDX.
> > 
> > RFC v1:
> > - Rebased and split patch. Updated patch log.
> > ---
> >   arch/x86/include/asm/tdx.h  |  2 ++
> >   arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
> >   arch/x86/virt/vmx/tdx/tdx.h |  1 +
> >   3 files changed, 23 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index f968b736871a..d2cf48e273d5 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -178,6 +178,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
> >   u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
> >   u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
> >   u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
> > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> > +			u64 *ext_err1, u64 *ext_err2);
> >   u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
> >   u64 tdh_mr_finalize(struct tdx_td *td);
> >   u64 tdh_vp_flush(struct tdx_vp *vp);
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 580f14f64822..d941f083f741 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1825,6 +1825,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
> >   }
> >   EXPORT_SYMBOL_GPL(tdh_mng_rd);
> > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> 
> Nit: Is it better to use a var name that clearly tell that the page is used as a
> table page?
Yes, Thanks!
I also plan to do it (as well as for that tdx_spte_demote_private_spte() as
mentioned in
https://lore.kernel.org/all/aKKp3fyoYgaaqidm@yzhao56-desk.sh.intel.com).


> > +			u64 *ext_err1, u64 *ext_err2)
> > +{
> > +	struct tdx_module_args args = {
> > +		.rcx = gpa | level,
> > +		.rdx = tdx_tdr_pa(td),
> > +		.r8 = page_to_phys(page),
> > +	};
> > +	u64 ret;
> > +
> > +	tdx_clflush_page(page);
> > +	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
> > +
> > +	*ext_err1 = args.rcx;
> > +	*ext_err2 = args.rdx;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(tdh_mem_page_demote);
> > +
> >   u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
> >   {
> >   	struct tdx_module_args args = {
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> > index 096c78a1d438..a6c0fa53ece9 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.h
> > +++ b/arch/x86/virt/vmx/tdx/tdx.h
> > @@ -24,6 +24,7 @@
> >   #define TDH_MNG_KEY_CONFIG		8
> >   #define TDH_MNG_CREATE			9
> >   #define TDH_MNG_RD			11
> > +#define TDH_MEM_PAGE_DEMOTE		15
> >   #define TDH_MR_EXTEND			16
> >   #define TDH_MR_FINALIZE			17
> >   #define TDH_VP_FLUSH			18
> 
> 

