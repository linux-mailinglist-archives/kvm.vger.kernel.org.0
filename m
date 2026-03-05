Return-Path: <kvm+bounces-72930-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLGiG3fQqWmYFgEAu9opvQ
	(envelope-from <kvm+bounces-72930-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:50:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB66D217202
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F183C3028C0E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 18:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870242DCC13;
	Thu,  5 Mar 2026 18:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PztW3ZAG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9162D0603;
	Thu,  5 Mar 2026 18:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772736623; cv=fail; b=IkrHjQyRcQ/A1U93VELsK786H7mXxFfDKiSGaEbx28vDX5PJYoQtX8+HHzl89ARn3l9PqI/DrSytg/zlVH/U66pPkLuto54lXW9vaR8UzQpwBwHydBYHPqKlLk4NVN1CFmJrojhX9qpXFtFT1E2iDqm6vRvco7mPmd6K58RHRpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772736623; c=relaxed/simple;
	bh=jdhwFhSEBLR+a5aotRJppxUYYK1U8PU/ySPHZsbhUk8=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=MIgllxms0XB882IjLd5ZC96FJHJg/s1rO929siATspACoxE1LjB8ncExru0d6TRjqSM3eYE7lXufjiHwrD4o0QzsoHqCZPB7rf9nKT1jzvOITlZX8rqsBsx1qqvGqRA2T47LSHMF9Ouor34yQu2sw9hXcvcUNJdCtIsV3i3Jd2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PztW3ZAG; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772736623; x=1804272623;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=jdhwFhSEBLR+a5aotRJppxUYYK1U8PU/ySPHZsbhUk8=;
  b=PztW3ZAG76aEVgyslyJRuuwjHZPRKuo4iOnQbdzNzPHYIRe2Abi+qvKY
   5SdwfhWiL/8RQ/NXdCRuMtFv+/XmuKcncTUEXtAXqYx6SSZ2NsDsfRWhd
   dZikCHEnPI0Fuvm8NjiYvqw6DcseGjulT9h9LDdUT67yd/WSP22IrEmAv
   9aOUaWZcw32ze02Q4UuJ/5ME6TS63O4CkIC1JHa4zLBiAoCvA97a0ALNH
   ZFYUyX/eRmqNmXTH2SozVH+6PDvYU1uAh3XUgbRqxanIZo5U9jUTLrnW6
   2JglIHKaRFXSU8/GkQUizk6EaVJp+QWMh9eKnPHr0vaZKJYUtl7KRTVc9
   w==;
X-CSE-ConnectionGUID: IoEhGhhaSSeyR0k2L51sXA==
X-CSE-MsgGUID: STeem/2MQT+1mkRFg9G6MA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73957024"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73957024"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 10:50:22 -0800
X-CSE-ConnectionGUID: F1FdnZiUSlKKONvcMhE3Yg==
X-CSE-MsgGUID: FthzAV8CRjqZDA0cSiKFaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="245187990"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 10:50:22 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 10:50:21 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 5 Mar 2026 10:50:21 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.68) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 10:50:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jPh9Fn5ThnqASDMyJjH6KGMhBUdJGjGGamBJM04e0ILvt2RN/VBff71UCypToiBYNqvm0utIsiOZyZdPnafPbaPAQwo2FejxNmArRPFblnkCLuX8NG1vMnWoNVfob20i0b6rTGXhlRI4ku+e81N3eusbzLObzS6mOBAFJtMFyIBOoHd2RtBZX1OcIpdhVvA6jU7K7t45qFrmGED1kz8USZFTmnCxTsIPRMLcqAGTswdkqh8QsIkAYd+yAK5lrAC5LmNsSw8dyzgECiAI37/ux3cdlZjPGZ7qxoPOL37GX9FujLFpmnIpuWEBX1EgxprKVC5xGbh+gS5VZh6FowjbWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKzBxqar/A3lDyPvudpv63jo+fv+lORqpUUQJqN6yDA=;
 b=HFYOAdolcgigexLs8s80vI5Xj658Wma0JSCXQpkc98LASjqNYW/nWFuIMdsze9oOSBjbhSLH8otG2hp4iXrRsli/cLmf1mX0kf2O8MZGWL4jkqZaCojacpl6HZ4ft/6tgkKN3yYsPSXKAvpPgUFqD9mS66CMkkbfIIu9wa8kROXHvKTwFfOomsWrRkirxEsdw63/4McNlfc1mCiA3sNkyDnCcUVs4eQgqouMQXLeh+p/EwZgpsPTRoIQ+EPFs3VoKoVMvpCLtvidDVGlqFSFlFL0UQ7QJRT+A8PZadNErEFRsMkxaE27myOsgXGeKIIKlrgOwKgiW3s1up9El1BWCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA0PR11MB4703.namprd11.prod.outlook.com (2603:10b6:806:9f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 18:50:13 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 18:50:13 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 5 Mar 2026 10:50:12 -0800
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
	<seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, Kiryl Shutsemau
	<kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Arnaldo Carvalho de
 Melo" <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <69a9d0645bc31_6423c1006@dwillia2-mobl4.notmuch>
In-Reply-To: <177272960351.1566277.2741684808536756847.b4-ty@google.com>
References: <20260214012702.2368778-1-seanjc@google.com>
 <177272960351.1566277.2741684808536756847.b4-ty@google.com>
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA0PR11MB4703:EE_
X-MS-Office365-Filtering-Correlation-Id: 290608fd-5c24-492a-dfba-08de7ae808d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: WkluWlB9bwW2lfEeFYiVN6oaGbrWQraAPH8/Vup0ETlhjJbOv/nseC7JNC3qE+DBUhhKtyABujf7MyUrRbYW54DOBUE2iSSXFkgFKv51hxVhZpFvOgRF00bFua/Qs4Zfaug2rR8OlQv7qA68qawvc541V9WOUGhZEtQaisgGnTwTYk/OGbZcQDCAf6RwdI01zs1Q4r1igzNymNWvE8JioB1J+xQN7EsLy+fFQjriT03LwpfciAU9WcHB4Eu3niwNAo0+H0P93l/t5dJhgLtwaV7QuNsWQDW1kgCSb59rUgsMv62aHcZ8VvX6VOYmVrIJyl8YkYrAMw2E/0D4Ne1n3U3KO/tNLSRne/UMeVsyvb9IXFlyXfrs74N21U6BJ+E8SArBtXco4jUm/mfX99hychYU31Qu5dZ+YsTpi5OSlLFaw6kQL5d9w0+Z5rwX7Jutsy2Lb2WksKe+lUm2uwJKSFBBsjAibYFiH2U5dzrlOOe7azTm8Gr9IhNahaw6Koz/PCEtV4vBuHmPN57M4pckTpi6JYbbbFr0IrilUzu3+6GC16x2QT6OyBADrmCPvKogAeEzaLty6z8YslVVJjsmUIBNer1UWu9iDt2Ql50xdDzPyEQq4LGGtp9GmuL2pU89dy+nckFjupjC+iJVsjdG5Gk4ElPbNOQmQX+9z+LFT8f8Bqya0IHGPo1ipepYJBoKnKMXfwiVm03WZZzE2cDpSdgTmKmYRvJqdHV+MgleEQS7sgC+HTIB1nC2RmEX2Y+FewPPhto6qZOaWX9gMvxsgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2lOUW4veE9sZlJQN29tT1FKL1gzcVBCSlFaZzJYcjdNVDFMMkdjeEEzK0Jv?=
 =?utf-8?B?TDV5cHBuZnQxZnZHYmNKTGVNSFhuMFBmOForem5tbEprSm43RHdiSVZPajln?=
 =?utf-8?B?RUFzMzBKbitLMnpnZGV0ejJ4MlgrWXRTTnIwMmhFVXB5cmJLKzRtU2Z0ZkNi?=
 =?utf-8?B?RFZzWjVudGNoVEdtQ0pkTzNmSEJWWE1WeVU5aGdWc0hJbWhqU0Y1SzJSY0lI?=
 =?utf-8?B?aEtLaDN0bEVtMEVJNmJmamk4cFJacytlblJyVzJwdHBlYkFaWURDcHhQRVNY?=
 =?utf-8?B?aFAvUzVrMUFhKzhuek9FVnlyTlRwbDlENHRCeDVDWGpuVHJScTlJNUJGUUE3?=
 =?utf-8?B?bVl6QkNOM2tuMlhCbk13UHNZdHJ2VlQybWJoejJ2eWQwL1dTU2JqY3VIK0o1?=
 =?utf-8?B?c0ZKN0VMbms0SmNTU2ZidDFXSndDVmJxaFlNUXZpWStrOThHOEMzV0tsVS9w?=
 =?utf-8?B?eStFaE44S0lIdGxTOXJoc1NrYVBDL051T00vREpzeVgxMi9JUFdBVEp3aVp4?=
 =?utf-8?B?dldaa1BhUlFrSEh3akNvSzRDL0l1VzVUa2dRSlRZVXRGdDRDTXZFYW9NSE9q?=
 =?utf-8?B?eDMyT1ZBQ0xOb1N5bjNyaXcxZ0dnZVZIcWpDdDdOdnZOMjJpRlJPdTV6Nndv?=
 =?utf-8?B?MXVVSHF1dnFXdkZMNUdMbkFWOG8ybllkdFhDdjBVMURzUTViUDE3SEJGRnlv?=
 =?utf-8?B?ejM4SWdaUFlyS01GWjF5c0lpRm1KM0pkajNCS2FEeERzQXd3Q1JhT1IwTkdW?=
 =?utf-8?B?VmdZdFV2T1JlUUNmNDlhSElPaHY3TFM3L25RV2FiUldlZ1R1em5OQThQUllE?=
 =?utf-8?B?Ykp2bVFKLzFRQi92aWFLejBBUk56L2lKdTZaQWlVZ3hvcW45QUxaOUVrK0w0?=
 =?utf-8?B?RmhIenJUOUd3ZldpcmdITndJS0NpcUF2STBYWEk2QTZZQlg0OWhNUXl3T3dZ?=
 =?utf-8?B?SWh1RWhva3VldmVtT1c4aFd0d05xaGNYWjZVR2lFUjk4M0lHc3RYeFhUVUc2?=
 =?utf-8?B?bXlsc1hzRWxUdktPK0lNa2JtUWc5cmhBdDdqYjRZcW9ER3EwU3Vzb1FjQmRa?=
 =?utf-8?B?cG90S25ES1JBcGtUSEs2MHZQdzdNbzl1bWVHRzFTVm54d0FudGVVNmRmQ29C?=
 =?utf-8?B?QVhzOTA3V1E4T0N4bjlzaXBVbTlIS3hibWV4SnJEcloxMFRoNmVrdksvZTdw?=
 =?utf-8?B?UTg1NWJ0QUpMOHR5b05jMGhudTVzWm9nVndNUFNhY294OU1Vc09IZG9qblhR?=
 =?utf-8?B?UEs2c2JiSjZQZytydkQ3YXFyY2NjY3l5OWpWZ0w5dGhnQmFvaGtLMmtmaHkv?=
 =?utf-8?B?VERxY2N3ZUZwZE9mVGxqbEh4ZTBMNWh4S2xwaVIzbnk0Y2NkbjFYSnFWM2Y2?=
 =?utf-8?B?eDFNN0laRE5sbG0rQS9vdnBIN3JCWkJ6SExweUh3SmVPbml4QlV1Wlkvbmxk?=
 =?utf-8?B?L08xSW52cFZnWjhyVEgxVnZrUzVZWlBicnExdUpBSXNvTVFJWkhnY1NLZy8y?=
 =?utf-8?B?T3Z3bU9FN0hNR1BqWGxEb1BmZktBbURvemJLOU01UEc1cnBaZUlzOEwwQk5K?=
 =?utf-8?B?SkVicW5HWkhqN051ZDljT1FYc1J4UTFhRFVKdFNoeW9oRTZuRU5wOHJZcmZw?=
 =?utf-8?B?U0pibmxwRHA4R2sya2pDRi9jV2pkVkFraTJzOTduNk1Bb01HdWFTd1NmNG5u?=
 =?utf-8?B?bStwRHFNQ2NqZEh6RTJQS2sxOW4zSFp5MVFMWEIxQkhsZkxhcTBLMGVUUm54?=
 =?utf-8?B?U1JKT3lKbGcvRU4xanFVaDBpbjIzMlF5TXIybFVWL1ZQTkQzUnF2VUZsTldX?=
 =?utf-8?B?R0ljdGJQSHdMb0N1OWZLSlpnYXVscWRpRmZ1ZUlRVTRzUlhPb2Vzb0V6UUMv?=
 =?utf-8?B?VlhaSG1VekVMb3RkRVpBMUxhaUIvNGFBb2U4Y25NWXp2VS9BMzBsaHFxVHd1?=
 =?utf-8?B?TjJ0ajZOZDZEcktIRko3VjhOUXZJaUtxT3ZnZGs4VzEweERZRncweUpTcldT?=
 =?utf-8?B?MExWWm9jZzdPdXlVcHNnTk9FZnAyN21Mc2VzYzhlT0huK2ltM3dOMTlGb0ZU?=
 =?utf-8?B?ZGJCZEl0VzZLd0tZLzhWNmJEdTZvVU5oQUVKU3IzRlArN3NEbEwzaURtNmky?=
 =?utf-8?B?QnZES2Y0ZUpHVGhzREFPWCtEMlkwb29xVzBhOGQrUlJLLzRNZW5GRkIrL2U3?=
 =?utf-8?B?MVZPMSszTHRSQnJ1QUowU3VoeW44VTZtZTV1MDQ2dWRZdUFycG0vNU9RVHpp?=
 =?utf-8?B?SXJoNUFTSEV5SXVlM2dEQU91WXp4MzFSZTFZbGhtMTZRVGZYc2ZmTlZZb0U3?=
 =?utf-8?B?Rmlmd0xoSTVTb3pkY2xSNk96UUxrMkNHc00ycHNRRDVPS3dvK2RWdk5YVnoy?=
 =?utf-8?Q?UtGs2V0RdF8jba4o=3D?=
X-Exchange-RoutingPolicyChecked: pcyBmHX8dKdtSPVtH9sYfGKHjaDwFazpOhfKC1rdT/PqyLOPErtDnlAmVEKaXTediIGM2SUkwDpB2+G6Q2ujpKjaNPuppyu8eECpNvbqz8GIKbqNCkYqXw/6IaBpoNJu1lSdNSrs1HijAaKkOOe1rR6hEZAJAlpVdvH5MTqHuB3keYqoaCS0scXxEeZFZ6GKXEYpEhtcJt8/0HrIow0zp9UdRzw3vfL8e0ZgSClVnBpoGcwVpMVZT4eb4/1QQp7dFitqLROCLHD5bZG72Lv6pbISBZCXL2Nhs3Orarh3JtOXx5OIZcFr74PCGIBI9xw5dyEqYBuTk0aJ66g+oYhw3g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 290608fd-5c24-492a-dfba-08de7ae808d2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 18:50:13.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vWIYZ0GsPxwqRGxE/vDAutjATEZ7vNkfnCj579c3tzWKIC0Kz2KJU8PzgSJlQRUQbR0jDI1/jpJgzIraGzQFYXLnQQaeJCXXIS/w8/98HQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4703
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: CB66D217202
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,dwillia2-mobl4.notmuch:mid];
	TAGGED_FROM(0.00)[bounces-72930-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

Sean Christopherson wrote:
> On Fri, 13 Feb 2026 17:26:46 -0800, Sean Christopherson wrote:
> > Assuming I didn't break anything between v2 and v3, I think this is ready to
> > rip.  Given the scope of the KVM changes, and that they extend outside of x86,
> > my preference is to take this through the KVM tree.  But a stable topic branch
> > in tip would work too, though I think we'd want it sooner than later so that
> > it can be used as a base.
> > 
> > Chao, I deliberately omitted your Tested-by, as I shuffled things around enough
> > while splitting up the main patch that I'm not 100% positive I didn't regress
> > anything relative to v2.
> > 
> > [...]
> 
> Applied to kvm-x86 vmxon, with the minor fixups.  I'll make sure not to touch
> the hashes at this point, but holler if anyone wants an "official" stable tag.

Thanks, Sean!

Please do make an official stable tag that I can use for coordinating
the initial TDX Connect enabling series. While there is no strict
dependency I do not want it to be the case that a bisect of TDX Connect
bounces between a world where you need to load kvm_intel before the PCI
layer can do link encryption operations and keep it loaded etc.

My proposal, unless you or Dave holler, is to take the first round of
TDX Connect enabling through the tsm.git tree with acks. This round does
not have kvm entanglements, i.e. IOMMU coordination and device
assignment come later. It also does not have much in the way of core x86
entanglements beyond new seamcall exports.

