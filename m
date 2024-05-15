Return-Path: <kvm+bounces-17454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03878C6BC6
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C31501C22190
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55888158DB1;
	Wed, 15 May 2024 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iDm3ksVY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D97158845;
	Wed, 15 May 2024 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715796019; cv=fail; b=QrujThW6/nJMVehzE2YyP/gBKjAajacnKUGdci46tjztqoWJTUc1jYE6ee4Ab8VRp0eqS6Llbgqn3XhJu6xprjTtsqIZpbVm8fImYoJ0/l/DB9pblA0L+hbA2hBfObnX0hMTICscqOW48y4XGYSlsfa/irSuUrYDVteXq51aBWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715796019; c=relaxed/simple;
	bh=FfhI5k5dwZeg1nR88e4QljibD0RAe32i223eVLWAKiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BSgmTqk+T8rYG7fvB65hnnvCEj4r3XNxw/QPxV7WbF+/IxoZvrQJDNCa3/mCk20Sjclk0kpE1lveLsxlKZRUwXrIrjhISA4zm6GReTbPcPGYSywo9rqmHgqfX091fL5iM4QznNxmBeTIsOCZwN8FHj+Jd68YLdYWek3JKxysiIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iDm3ksVY; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715796017; x=1747332017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FfhI5k5dwZeg1nR88e4QljibD0RAe32i223eVLWAKiA=;
  b=iDm3ksVY/QxmFyRoSbweHtMNj68UMbq+8QDPdF5CsQnsv33n+pJLaBPe
   XvdRQDY5tJiXpihljaeHT9X9YZ1Qo6KdKOdu5LdromxWZICZd405ZOv29
   GxmgODhDWiMIyQf7Xu4Sg0arz9wlV95xyhYrSoI/QwdyV1E3HQCiszL0A
   bbefzrR33KiKuyrjbwbDbo4oppVxhxYHjXveV5sKZf3NpqjueTMS5Tl3V
   gHDQN8BgtLd43ZkZog/vMYFOB/TGqMjYL/myiDIJsmfx+W66BVj4X53dk
   FCbNXrukB85SvhZbW57X2LSIt+ejh/MR3AwwBEo5ozlWQOTXxmkLyySWp
   A==;
X-CSE-ConnectionGUID: IYd0gJSkS4SGgUP4oYvAAQ==
X-CSE-MsgGUID: AIlTB0OFSWu7+B+vhS5ezw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="34375102"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="34375102"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 11:00:17 -0700
X-CSE-ConnectionGUID: Ii1WrTyNRpm7HRBhmICNzQ==
X-CSE-MsgGUID: bFSfRjwkScKbbu9untZbEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="30978023"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 11:00:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 11:00:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 11:00:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 11:00:16 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 11:00:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIV8wzR6OsXX+gzuYZ8TVx9dNpSAiYWkvkdaC/DWtWDk6oZdxr4nAFrRkvsbUsNf7aKnr57/Ml2xYKBhJgCrpOYAJ9UVk63y5Zv4J3xqnvHat4Dzs90r29JL5/LDRmsB3gk2k/DVebe/BiZfXLy1swIwQ2i39Ee4c3TBrgoSTsQ43CKjTviGbszQptVLZZJunHw5HZc5vOjdoyXnr4x3rxUCTHf+9Y+NXqgOnAwFeKHGlXdP6t3MHtXI7uKGyy6bRULHHRYD/iWBq9QOAIkzSFqN8voXZsAbyLxA0Pfss+cwm789fO2RCEL4a2nBkRS8vvQXRRVd+Y9U0sDxNq+DwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfhI5k5dwZeg1nR88e4QljibD0RAe32i223eVLWAKiA=;
 b=SqLGMXVqcZxloibXBK0c3rW7JHABDbcPniAnS3yYlCf2sPV+ghGJnJdZByUpDqekwUMY8ToBHbewbDYakkjbjs2NweQZZFr1sgdTlPkkiwa0QnaDzP2bnvAa3fyLGgFlSOKJLeMN588GiLRyERiClnh3M76oZBBKvFNizbi0BYpVpSZI6G65ZXwVk0G7W2S9tPW4PS6oZTYnE9p2n4/VDzxjEW+p56/MjUGUOzKFh6T+rmTfiWBNFWt7hd4i8i5pt5D9LVbYEILAZm58VqOP13FuEu23bcdFKxh7LE97Db7/Ju2j/4PjCizexDwzDnSxMKR4gz0r54rmtyXTZS9i7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5323.namprd11.prod.outlook.com (2603:10b6:408:118::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 18:00:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 18:00:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GYj9AAgAAG3wA=
Date: Wed, 15 May 2024 18:00:13 +0000
Message-ID: <147b254ee819c20f7eaa881127aa2c88e05ce4b3.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <20240515173536.GE168153@ls.amr.corp.intel.com>
In-Reply-To: <20240515173536.GE168153@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5323:EE_
x-ms-office365-filtering-correlation-id: 23cb336e-d0cc-4d8c-583e-08dc7508de5f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NmFFNVlCaFBJeDBudXJRSm8vL0ZZT1pkcng0Q2l2SEpaZUthNzBoZG15Sy9h?=
 =?utf-8?B?Z3lrNGpuUUY2czVmbU9CQkh6bTl1dVRKSlpKQjNDMHNhd0dISWlKS3JRKzlC?=
 =?utf-8?B?ZE9EdHMxVnUrMWtVbVFvdXFiUmk4UWVQY2JLWnlQb2l4ekhCd2NPdkhyUEE5?=
 =?utf-8?B?YndRUzEvbFZWYngvazRXaUpHMCtIMkhud1dqVkVMZ1o3aDNKSWtkV3QzZy9l?=
 =?utf-8?B?K0hDTUFmSUFUb04yd3RoTk14ZzNOSnVHNXg4UFlpR0N1dTBNK2Y1V1VVa3Jz?=
 =?utf-8?B?SmU0ZEpGUklkREZXUmRuS21JQTNMUlkreFRUZ1pzdnBXK1YwRUpNQ3ozMkg3?=
 =?utf-8?B?WS9aSTNXOE9lL3BSZTNIL0hiS0MrL0g5REZXejRmZVpRQ3ZrWFIvS1EwZWtZ?=
 =?utf-8?B?SjlqWk1OMHc0VzdtUndNK0d2YkNjMXcxSWNMLzdIUzZHNG15S0FBSThpclBo?=
 =?utf-8?B?MzNyeFR6RHFHWjNWdlljRGNtdFcxMnhCRzUxU0ZVbFVobFYvUjdiQlJua2lK?=
 =?utf-8?B?V3RlcFFmc1FLV1FkRURHZXFSNytaNGk4N0I5bGFMQ3RvQ3ZEQWJRaCtoU2FK?=
 =?utf-8?B?RytIZlBFK1dJM2M0NDIxcmpueWtMVG4xcnkxbTV1ZVhQSWU5eXo1S2pHREdk?=
 =?utf-8?B?Nm5BdnFCcmlZK1cwVWlhOVZzYXpVVnBWa25jQVc5V2lYN3F6enZjV1d5Tjlr?=
 =?utf-8?B?dUpBcHlKZzRENVVtSkVlTitQUzlkNWlIVks2WG1YNjl1RWQyZzBtZWluNzYv?=
 =?utf-8?B?TFAzbUIzTnlGQTM1NXFPZVE4RUVDUkNFcDRMWnczY2NPL1hVZGZaUEhPbTF4?=
 =?utf-8?B?OFMxQnFJeno3RUtwMS9TUFNCeEY1Wmxpb3lKdzFDWi95T2ZNc2ZZZmFFbU9m?=
 =?utf-8?B?SGg2MnhFMnZtSWg4bTNIWENyMm4rMzFRV2VpT2hpUnptd2RqYVR3b1pqL0x5?=
 =?utf-8?B?amNtQ3J6UUxoc3lQRStpRENmZUdDY09TWlIvT1FFM1htRklpR1hXdk5NZ0ti?=
 =?utf-8?B?eG1yZ3drUHZKM2tIZmNiTW9VMFJnRFA1ZzlmcnBQbDFXazdFdkNWb29IdGd0?=
 =?utf-8?B?K1F6VFkxUVQ0YkN4bVpHbGs1cVVMSjRNYThXb01PcGM2OStEZjBRd2ZxTzFt?=
 =?utf-8?B?d0wyR2xFL3FRYXFCQ1lTNDgzcjRaSUpma29Tc2xUOEUwNlJacjJpeVcxd0o5?=
 =?utf-8?B?cDZkSlFtbzA2MWl1c1Mxa0hleDdXN0l3M3NPOVpUTTJJd3JaVFdlOHhibUg3?=
 =?utf-8?B?RU5sai9NOEsvbmZndjRVLytORVpXdWhTYTRPRGVCRUNYSGttRVVaQWoxOUds?=
 =?utf-8?B?bVJ5RkhNdDRMQ3pTV01Vd2l4WTV5REFHMGNNQ3V2U0V1WXZ5WFpSU05vWUNa?=
 =?utf-8?B?bWxVQTJteHM2MENDTVZZTmEvZEVZeC9DdVBnTHZjTlp0VjEwV2NUM21PV1cr?=
 =?utf-8?B?bktIN29aalBJeSsrM2JtYzJpeGovNGdVYllMYXpvMW9MS1UrZFFCeWZJMThN?=
 =?utf-8?B?STc4WlNaZm1iSFB6NGJmcjBqblJCbGs5Ky9ZeE14MXF4ZTRQWi9McXBiYkJp?=
 =?utf-8?B?eXJNejJtTDVtSWJNKzI5NzJvY1NpSEpFVEZzT1M4M0JiVFZWejhKY3RzRzRU?=
 =?utf-8?B?bGE5K0FVZ21wdWhUT3FiaFZKdVpGMEpJYythRTVTK0N3cEhmNXlLVElJMlNv?=
 =?utf-8?B?eU0ySW5HWDFSQVRuYTZ5eUJ3SXA2L0N1UWZITFV6aDVZb09jd2EyUWJETGNl?=
 =?utf-8?B?NlhpSFoyQTdndUd2WVlwckZOMTV0WTFDaUNqQmplWExwdU41cHNKMGJqWUdM?=
 =?utf-8?B?b1NCZVdLYjd4Skc0ckRhQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTF4Sy9GcDRubnMrNlNLT3Z0ak43KzlEQ3d0cng4UThaWURhSHNIUjNjZUFn?=
 =?utf-8?B?UUlteGI3UWZnREtSY2t3eHBqazZxVFBsQ2x4RFhkQ3NDRkVZd3VQcW9xdy9o?=
 =?utf-8?B?U0plVWtCUHRDd1pPMGMwV05KenV1N2FmZXovTm1uUk1QQWUwYjdHaTR0Qmhm?=
 =?utf-8?B?L1hLL2piSzN1bkt6aG1aU0RvZkJGQWxVMXpmZ0NnOHhXbDRma2FZZ1FsMVFw?=
 =?utf-8?B?eTB0MkZKbU9pbzkwdHVaR3l6UEkrM0MxM1dQK3FRVXM1QWFKQTE2Uk1ucVJn?=
 =?utf-8?B?UWhnYUxHWUE0N3NyelJYZDJJUVJmWlpnYWdReElMOUt1Qk0weVZmUkM5WkU1?=
 =?utf-8?B?cU0wdnhqaUFXMnhhQitsRTVLaWgwT09vVFNlQjVBaWY0dTV6Z3o3Q1NNMWU0?=
 =?utf-8?B?bnc2K0lraDZzNXBaQTBncjlzRVhaZDltcjZjM3gwRnRGZWdXODFNZFBHbzdT?=
 =?utf-8?B?WEdPS3FZZ0N3OHpLUUF4V3JmSlkrMEQydmFKdTBMMEJaeDdtb2Z3emtIV1JM?=
 =?utf-8?B?UTRmcHRTUmI3ZVdXd3NoTjg3R2srUUNibC9oTUFiUkg5cHY2UlFHd2ZlRk0y?=
 =?utf-8?B?WDRCSHY2NitqRGJKNlhvcW9NejFTSy8wdTRDYWhDaTE4eG5YUW8vYTJoQkJr?=
 =?utf-8?B?aG9ENzRldGk4YUtzUXFDY3A4bnZYMWp5UUMzckk4NndtUVZTdjZQV2xJdXVW?=
 =?utf-8?B?Zk9TZ1o0bGt4T1c1ckJRK21hNkRGNGFkeUJ5UW9OREJCbC9rNkFzbEVONUFx?=
 =?utf-8?B?NUhJeVlkT0hScllIY2JkWkhVMmdjTEhoQzJLWjQxWGY0NjhIaERxdlJ1ZHVP?=
 =?utf-8?B?VCtnL09maElhanZwUTZ5alNxRFFMaWsrNjJaOE02amw2ejE0QmZydzJGRzJp?=
 =?utf-8?B?L2E1blIrT3R2ME90QUZBY2NMMzFFZno4MmlSU0lQUkhFSGF0VCtiRWg3Y2ti?=
 =?utf-8?B?OU43WGtqOVlRR2VSZWJyVmpuRi9Qc2pJYmJvZ3JGR0JhZytYS0pkSThkOFlO?=
 =?utf-8?B?Tm1pa1RwTGR4RHZTNndnTjVBSDRCWWZndW01dkpkKy90TXgxT1NFUFFvaHd2?=
 =?utf-8?B?WEVINWo0ZkJIM1hsaXlheGhSRWcxTXR0Ylk0dDZEdWYxR1NxVklyZTB1OUxM?=
 =?utf-8?B?Sk0yd3RYZ29hMldGZTV5U213YzJvRkR4aWFiY0RvZVJkZERPM1p2QjZyY1pJ?=
 =?utf-8?B?R2oyOVI0YzFhT2taTUFCWS84ZHY2TTVFT2xUUW5OaCtkcWRRa1plblAra2Q1?=
 =?utf-8?B?TDY0VGFPVXNuelJhaFJ0anRTY2ZJcUhCYXl0LzJRNCtLTVEzYU5KOFVTOUNO?=
 =?utf-8?B?UFdkbUlPNW5LaXNjd1FPYVVmcXYwM24rTDAvdlRFSkR6ang0aXIxRVVnNXhk?=
 =?utf-8?B?OWllbXBOL2hwZHN3b3FHVmpWQU5zNll0UHdDM2V3dHAzK1oyWHdjNDR3NHNN?=
 =?utf-8?B?SDJ5NmZ5MTFrZUUrRXRlTndaOU1yNmJ6b1pvSk4zUi8xblFLaU43aXhJanVT?=
 =?utf-8?B?SzNLTWo4VS9DY1JXZi95QVZsU280SUFWZExIOHh0VHRTaFRWNmxaR3YwNWNK?=
 =?utf-8?B?MldXT0tiQkg0azNIWWx3aFErb3pNUHBCQ01zWUp2K05xUy9tdXd4NUd4WEph?=
 =?utf-8?B?T2hreWFxM1pycDFlZFZ5T2dBUFBaRWVwQzFYK1gzTUZnV0NBZTd4WU93d0gr?=
 =?utf-8?B?Y1ZSTWNsUzBnR1lUTkg4MTc2aUxTK1ZpUC9pZFlKSDZvZ0I3MnYrUndBSUNv?=
 =?utf-8?B?K2x1d1Y3UW1Kd0N0aGF1K1BvOE9JNVpta2lNRVVlRmF6TU5pcWVGbnNGMTIv?=
 =?utf-8?B?K0xlNlV0dTBadytsYkRJTGpLV1l6dnE5MzBhOXRSV0l6bWJxNERPTGZVc05m?=
 =?utf-8?B?bXFlZjNra0FsUlNEeVdLNmNpMUtnSTR4ZEZNQWUzdEw5K09ROXJOMWRXTEpI?=
 =?utf-8?B?Ny9JVnoyampQd1VKM3QvNGNlOTBvNlAycy9Sc1dDVlFzekNQVFFBZG1tV1Nx?=
 =?utf-8?B?TVB6Z21TWGw1cnE3ZmpKblYzYUdaclYxQ21YUEFydkhUR2ZKdWFtSDlYU2Nj?=
 =?utf-8?B?MEtOc1hiOE8vTkUvTWc4NFJHWS9iYXFDYmJVRG92RXpVNU9zZ0pHUEpMY2ZD?=
 =?utf-8?B?bWtzQThMVWpLUjZuaGNmUHlHRVZvdXowd0xrMWFxQjU5Zk9vSXJVVmwvYW1I?=
 =?utf-8?Q?VYOTSBjQLaCHTsSCF4rqLB8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85227E315010C841B8592BC1F5571CBD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cb336e-d0cc-4d8c-583e-08dc7508de5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 18:00:13.0469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +9OpE8zYEXp0/R1Chdu1nZo4RONcOPy/HdJ0Cybw3atoEQfpk+PMTthhCyqccyoSWxbvksNEzYql6ywvDpnv+9+m0tgvCldmISyoeWns4ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5323
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDEwOjM1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToK
PiAKPiAuLi5zbmlwLi4uCj4gCj4gPiBAQCAtNjE5LDYgKzc3Niw4IEBAIHN0YXRpYyBpbmxpbmUg
aW50IHRkcF9tbXVfemFwX3NwdGVfYXRvbWljKHN0cnVjdCBrdm0KPiA+ICprdm0sCj4gPiDCoMKg
wqDCoMKgwqDCoMKgICovCj4gPiDCoMKgwqDCoMKgwqDCoMKgX19rdm1fdGRwX21tdV93cml0ZV9z
cHRlKGl0ZXItPnNwdGVwLCBTSEFET1dfTk9OUFJFU0VOVF9WQUxVRSk7Cj4gPiDCoCAKPiA+ICsK
PiA+ICvCoMKgwqDCoMKgwqDCoHJvbGUgPSBzcHRlcF90b19zcChpdGVyLT5zcHRlcCktPnJvbGU7
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBQcm9jZXNzIHRo
ZSB6YXBwZWQgU1BURSBhZnRlciBmbHVzaGluZyBUTEJzLCBhbmQgYWZ0ZXIgcmVwbGFjaW5nCj4g
PiDCoMKgwqDCoMKgwqDCoMKgICogUkVNT1ZFRF9TUFRFIHdpdGggMC4gVGhpcyBtaW5pbWl6ZXMg
dGhlIGFtb3VudCBvZiB0aW1lIHZDUFVzIGFyZQo+ID4gQEAgLTYyNiw3ICs3ODUsNyBAQCBzdGF0
aWMgaW5saW5lIGludCB0ZHBfbW11X3phcF9zcHRlX2F0b21pYyhzdHJ1Y3Qga3ZtCj4gPiAqa3Zt
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqIFNQVEVzLgo+ID4gwqDCoMKgwqDCoMKgwqDCoCAqLwo+
ID4gwqDCoMKgwqDCoMKgwqDCoGhhbmRsZV9jaGFuZ2VkX3NwdGUoa3ZtLCBpdGVyLT5hc19pZCwg
aXRlci0+Z2ZuLCBpdGVyLT5vbGRfc3B0ZSwKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDAsIGl0ZXItPmxldmVsLCB0cnVlKTsKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFNIQURP
V19OT05QUkVTRU5UX1ZBTFVFLCByb2xlLCB0cnVlKTsKPiA+IMKgIAo+ID4gwqDCoMKgwqDCoMKg
wqDCoHJldHVybiAwOwo+ID4gwqAgfQo+IAo+IFRoaXMgU0hBRE9XX05PTlBSRVNFTlRfVkFMVUUg
Y2hhbmdlIHNob3VsZCBnbyB0byBhbm90aGVyIHBhdGNoIGF0IFsxXQo+IEkgcmVwbGllZCB0byBb
MV0uCgpUaGFua3MuIFRoaXMgY2FsbCBzaXRlIGdvdCBhZGRlZCBpbiBhbiB1cHN0cmVhbSBwYXRj
aCByZWNlbnRseSwgc28geW91IGRpZG4ndAptaXNzIGl0LgoK

