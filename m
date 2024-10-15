Return-Path: <kvm+bounces-28953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DA099F8C2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 23:12:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60E1528282F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 21:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0DD1FAF1B;
	Tue, 15 Oct 2024 21:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmOl+N5R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CD51F80BC;
	Tue, 15 Oct 2024 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729026726; cv=fail; b=V5p2xNDSiGqR9GoNLybCfcRINcRI1n/9ZFZeeuR7NrbIY1pBIjxDFA5chvXPqFthqNttFWjfk3QmJfYUPcGF7tvJkKxA1ENmQYi6d5RbeTorxIfDSWYnQ+4pIqtyyGAS2LavDCrJ5nc2hd5370ZYFhEhQr6OOC71q+Sh6axa39k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729026726; c=relaxed/simple;
	bh=7W53WWxIWJZ80KmGku1KzhjO9Uwe92sjfQdUSLiisG0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I8qfLqB9UYMafBC9lTr0wjTSMiLsSixlxiwqqQKLuUV/Nq4cjEYHe/NBPmFMK6Y1MPutglAJqPPxUCr2RzL/W0Q0Vu8wrCvOge1HbjfVXh3wIgi7cVwwZGXerDgyWU9ms2vzBBLeLl0KJVVOKVXxc8BLKWP8iRgs0SqLdMf1Yro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmOl+N5R; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729026725; x=1760562725;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7W53WWxIWJZ80KmGku1KzhjO9Uwe92sjfQdUSLiisG0=;
  b=dmOl+N5RsICTvNh/vlJM7I4pK6fdllNVQ/fKUD1D3gw0jJo0HB2To6yy
   vGEZMK685BuGS7qhYWY22ZWfBnbU7xhcQVyw/dzey4IOogJ8+M10dnjdt
   Aa7EEPc+DRwiRYcTGjdWRlL4WfGM0jbGy2/BRlb2u3DwRI0Wbpt9Iowwj
   CNwzDM/GVG5oYTXCNKULV9ailn6rux1kS8pMg8j8yG+FkqV3bU+KimEFk
   0wrIIwLSDQleMFegcq21oPQWD1ej4dURScY6Ow90tRs5+scmrpGzU2lNH
   HmAOjLJ+LpNfasRk3+2THqIpQFvpPQAxkX/YYoUiO6bfcMGsN/42Z6TAx
   g==;
X-CSE-ConnectionGUID: IvNdxBjYRS612qLq7qgHFg==
X-CSE-MsgGUID: YCbwHbPPQJSc3c4aub/bSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="28646145"
X-IronPort-AV: E=Sophos;i="6.11,206,1725346800"; 
   d="scan'208";a="28646145"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 14:12:04 -0700
X-CSE-ConnectionGUID: BMGBque9RzeH3RElbP+XOQ==
X-CSE-MsgGUID: Q2FbzsT/SkmvxZRB/qAgNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,206,1725346800"; 
   d="scan'208";a="101337742"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Oct 2024 14:12:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 15 Oct 2024 14:12:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 15 Oct 2024 14:12:02 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 15 Oct 2024 14:12:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzSdhReMQeg8Ci8/3RmEf8t29I7xtoHf3uWTel5bNqe5pw1Te3J05tLhFEZXo13o/5tb+hK712sVoPclW2qX8JmScmu18Ia2v2mg2Tgoim5cjW3vh1g8GIzZ9Sjr2lUQtHAa4KljBCV+IGraKtALb49ln8+cH/66j3i1ZMclA1yHmrtuoVGwJzV6F5+pcI9eH9fuVvw4M3MJvFkfAqovJ6G9RCUj7ASKjOalisL2STU+xnO6BjgvHUPFtDJHw3/s6qbzoYiLbVFsHl8ZzyPp0ST1E4/jGDQgbqGG5VXcdZ7F1OVZYawceokpPbXO9IWdByqXpTlVHXT91Acvheh+zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duoHrPx1GvfRAT+6tIRZOoZN5bwcRFinxcmuvdnpzaE=;
 b=sN8KZWvZztbN2L8U+jk1Ii7NjwhDQxajgaC7b0898d6OwrXtadJb8+K7qhMP34Jl2tcPdUuZ5UMctUEpAXLnvSRkeOzj+I/mLlpgYGSlN1RrJYS3iWoAZbiaR0AYWPSdmzgKl93dP2j5iwv3w6jKwl24puIgAHfElFcl3E+O+yoAnv8Erg4CncpaJbSjSsqpzmRF938LC/RVYvoE6wWOmujA/7WrAUD1U/HcIDXokyAeBBhEr3mjsYAQYaKA1YMNzILnlHwG39DMG0ExD73bQXiusGbyWyDzelyTv40qdZMpaiSdkcjrj8wFapDdGFHPpeGNox78GInmBzJ5SitRWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6043.namprd11.prod.outlook.com (2603:10b6:8:62::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Tue, 15 Oct 2024 21:12:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8069.016; Tue, 15 Oct 2024
 21:12:00 +0000
Message-ID: <c9fb4377-5daf-4c22-b273-df12aa316d52@intel.com>
Date: Wed, 16 Oct 2024 10:11:52 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Dan Williams <dan.j.williams@intel.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Dave Hansen <dave.hansen@intel.com>
CC: <kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <adrian.hunter@intel.com>, <nik.borisov@suse.com>
References: <cover.1728903647.git.kai.huang@intel.com>
 <f25673ea-08c5-474b-a841-095656820b67@intel.com>
 <CABgObfYXUxqQV_FoxKjC8U3t5DnyM45nz5DpTxYZv2x_uFK_Kw@mail.gmail.com>
 <670ebca6e8aa0_3f14294cf@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <670ebca6e8aa0_3f14294cf@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB6043:EE_
X-MS-Office365-Filtering-Correlation-Id: ea0ac838-4470-4d3e-76d0-08dced5e0246
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dFNtTXFzbjVmVElacnBJK2ZVMS9LeUhYT2s0Q3Y0eFFDYVBaNE1lOHBaRjRZ?=
 =?utf-8?B?ZU5kd2FWcW5PWXU5dWRDVUU5R3ZybFl4RVNzdkJLMVhzZ0Y0UnM0dDF6YkxY?=
 =?utf-8?B?K0g2dXp6ZUtVdjB4RkJhL0x2aXljV3lCUGVPRk9pdGRXRXMwZisxSXNsbUJ5?=
 =?utf-8?B?MUU4YVhISklEWHg4Q0pMOUxvZEsrbExRN0MvMVNJWk5CODFxU0VtVlZ4R21H?=
 =?utf-8?B?Qlk1bXByVndwWE5USU5kWXkxM3VBRThsb0ZjbEJNa1Jwc2cxTWRWUnBlRmxG?=
 =?utf-8?B?elQzMEpTek9YcTVqbVdiUW1JOEtQN1FPVDZnZ3VDeTBvNnZVVGoxVE80V3FJ?=
 =?utf-8?B?QmdBTTI2T2Y2OTFTd3ptTFFsS2REYzdFR2g4enlFdXU5UjRDRldqVlk4M1JG?=
 =?utf-8?B?VUo1ZXllczBSVGNaMWtQVmx5QmxqdUhZZkIxajBYT0ZtTEhOQy9LeXYxWUhh?=
 =?utf-8?B?SnFLUW5SZlpVVVFYVTNjeForRVhhSjZOT2NLWHFra25adS9oRzlaVytpSDdz?=
 =?utf-8?B?bWNDVW5GUnFmMlpTNGE2MlM2azE5bVFGdmJqS1FxakY0bTR3dTlJN2N3RTVH?=
 =?utf-8?B?WTVtclErbVZoVXppN1lka09lTXdEbGJvcHd1Mkk2MEVOcGY0ZWVmZm1nekU4?=
 =?utf-8?B?OTZtZkU4WDdGb3pvWWVvL1Q2MkNoYVNGQnlYVGp2bVR2cGRIN1NzRjBLeTBl?=
 =?utf-8?B?akl4dExhN0poemUvQU4zTDYwOEFXR0lQU2ZDbGZqTElhWVNHSU0yemxSRHN0?=
 =?utf-8?B?dXErZHJmL2tDek00c2wxQ0RWblhWaVFPRnl1TEFubldrL2tPcSs1SmhLOHE1?=
 =?utf-8?B?ZldDUENOM1ptb3VpcEM2TlJWTUd0OUxaV3ZEVVpmSjRPYU5zNlVoaUpISzFk?=
 =?utf-8?B?YWNhbDdrVHhEcklPZFhFUm9LL2k0eVpGY2tkNFFQQlZKOFBQWU5lVnMyOHlq?=
 =?utf-8?B?aW9wenpEeEl5OVNQaTA2a2RDNXJYdk5rQThaNFJNdWxucnRzSE5JZ3F6M0lu?=
 =?utf-8?B?V2ZCbHRwZG1ZM1BnbWNjN1VXZU8zY2dGQXJMQnF2a1J2YkVnSG9ydktVeTcy?=
 =?utf-8?B?NFkyZXBCeU4zakdYK0lxdlozcDZGZUpWZ1ZPZ2p4SDN3cllRUFRTMmYwbDZt?=
 =?utf-8?B?NTIyOTZ6UVZ6eVI0MTBpaWszSFduWUJ4VHI4ejRRNkFDV20rK1RrV2JhYnBt?=
 =?utf-8?B?L1dnOWdVY21tMnh3TFZBMTVNa2Q0czg2cjlpZ210alVHQjB5U2FPTXZ2YWRL?=
 =?utf-8?B?NlFDTnhUZE5CTWFwWnVOdUpwNU55UVozNzRrZXBOUU9kdnNETjRQdGRSdjVx?=
 =?utf-8?B?Q201VUdIVXp6VFJmRGV6UW9GOTl2T1ROSzZldlJVSmVvVnUzNndSeEtIY3Ro?=
 =?utf-8?B?YWhRNmlPVzRmNURZcnpqcGVpTnVXVXVJMU9PdStWbkhhQ2tWdWRPQW85ZjhF?=
 =?utf-8?B?T3g4WHREbTJaSDZoKzRYeEgva1N4TnVuSlBCNXRQdHpSZEF2OEhGMmNRcVJ5?=
 =?utf-8?B?T0J5QmowM0w3SlR4d1hKY3pXYjMwS25tWWZiM0tpL0FKbyt0MGZYeVlRb1dQ?=
 =?utf-8?B?Q09kZzFxV1RYeW1Zczk1VTFteFlHcHBhZUVDRys0TG1jcUlFQzcrMFh6NHJj?=
 =?utf-8?B?M2tEYXJOTWZacUd4MkMyblJsODUyUnhIaVR3WTBDT3lBRmdsSzVsOEtUWUtI?=
 =?utf-8?B?RzVMbjcyeHEzVXhVM0tzdVZLbktUNzNoWUNQczFOUXpMT1JPMUx0OFNnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEszSE5kWDdtcktKYWhsTVBXNG5FQUdQV3RYYU9kUTA4YnhiV1luMnZBT0lD?=
 =?utf-8?B?WWpabHA2dS9jbTZSNHBkR0RKK2R3YmJJaENOdU1SUUZlck1SZjVHeFZyUzlC?=
 =?utf-8?B?R1ZtRmZ3NDBWRElGY3pneGliUmw5Rzk5UzhOenVyTGo4ZHZMMWJJamFpdkQ5?=
 =?utf-8?B?N2NoT3MvTktZOUMyUEt5Q2grOVlxckY0bGxHZlRnK05aQklRZlFsZjdCQnJq?=
 =?utf-8?B?dmQ5SUxCcDZCbGZQOUJFTVhibHJuQjc2L1lGODNqZFQ2NjdUZWxKNEhRWkxv?=
 =?utf-8?B?Z2JObjY3YVVndDc3a3Vrc3RCSDZ4L2xkRkdDbE1XczlMdTd6cWp4OTdMaFRn?=
 =?utf-8?B?NGxoL3I5YVVIVlZYckc4aUxEZ3o1QzZZY2ZPaVJ5THVRUkxYbHJXUEw2OHhI?=
 =?utf-8?B?aDJHeDdVRVpycWVpOEFkUE1pUnBTT0ZORGpnTmtzTjUwWmx1aXZoMzE1MTNS?=
 =?utf-8?B?MzlaUFBOQ3g2RnV0cnRUT3lZT1d6RDdGRmdMZTk2M2lCVUJ6V2FkcjIrV3Iw?=
 =?utf-8?B?TGQxL21BaHcrWUZ6WFh6RnpqR2hYVE5xRG1rQjFHSUtHVUcrSjJJNVdKL3hu?=
 =?utf-8?B?RWhBakI4TmhLaW5XaEFucHV2ajdaRE9RQVlVSXhoV1YzMUFkV0lHa01wSnRh?=
 =?utf-8?B?bFlmSXBCK3I2ZStnT05yYVlYTWhHc1NGd3VZajBrdXNwbUlKQ0oyRWg4WG5s?=
 =?utf-8?B?V2l5WmU1cHlra0FBMm42NVU3enQ5R29rSmdkRUl6c2NxM2NnSUdpT0hxdzFB?=
 =?utf-8?B?dm9hUEpVaWthcUV5Tnh6L2FFNlVRTW1iazRJcEphaFdGOHdIUHdEaW96Qzcr?=
 =?utf-8?B?enBuUTBaeVB5QVc0dVBVeWN5YTBvTHRBTFcrUC9ybS9jZVJWQjNvM09RTUFS?=
 =?utf-8?B?cVlucUQwOEVWbjVXYTk1c3dGcVB5WjJmUGg4alhDaTlxOGF4YTZCUTFJV01a?=
 =?utf-8?B?Snp1bVF4V3VpcWY4YitsbzhDL24vUUhuNXRYc01BRGQxVWQ2YlRlczZEN2kr?=
 =?utf-8?B?b3RGWG9FYU5IUzdEdnBLMUg5RWVoQy9xVXRHTFQ0dkZDZzh3VXRVUzBGV29G?=
 =?utf-8?B?SDdZK1BUSHFNUXFSNkhOazJyTzBXWS9FWVlZSTEyZEZZaG1pSThMbGtyajZl?=
 =?utf-8?B?K3NTc3FTQ29ERytIaDNVT1U3UkVrbnRPbkV0T1FPWWdjOC94RDRESnJUS2Q2?=
 =?utf-8?B?cTVuUnVQREN1TlAyTFhOcnJHVzBsUVdhQjhrZ3JmWVhHazF1a3ArbTJjQzdD?=
 =?utf-8?B?U3JDQWxSS0xjN0NmV0M3UTQ5Yk1IR0ZseGttY2U1VUNqRGo0N1VHWHZNRUZt?=
 =?utf-8?B?dEtoMDgxWVdRamNVZUdFNERQT1FQblczYUJhSjNmQ3BwbnRRc3ZTUFp0c3dy?=
 =?utf-8?B?ZkllZ2MyQllaVVYrVHZrSzQwOU85eS94OXVhQ1QwK296QnZaQ3JNRVZ2T2Vk?=
 =?utf-8?B?K3lxZ3M4THdYOU12SmFFY1QrT3hVNDdVUjN0ZkpYMmcvWnBvOWJZdDUxWVda?=
 =?utf-8?B?VmFHUGdtdEc3VkVFbGlLMHJqQXRvQmVkamI1NW1OeWNKMmpybUVHU204K2Y5?=
 =?utf-8?B?Nng4OUp2WStoK29VWDdEOHZEQWxCQ08ybVN1aTN4NHN0bTZWNHcxN1VlZ2Zi?=
 =?utf-8?B?aXFxZitNZWlkSVV5TSt0Wm8yMHlwUUptRm82NUhOVHdwOHFpelNKaExwdGpa?=
 =?utf-8?B?dFdGRzNaZzZ6WUZZYWljSFgzck84cFc5QkJxMVorakZNNm5BeFBlZDdVaW14?=
 =?utf-8?B?N1ZQaDhRemIrUzB4R2NOLzJhdmpWa2tka1pCcktLa2N5U05rOUdWQ0FpaUht?=
 =?utf-8?B?V0lBaDZ1NmlBaUVUMjRXQ0hSeEFpcWkrSE9SbGFRM2d6bGhhcFc2QUswWWdu?=
 =?utf-8?B?MTErNlVFeXNIRmJyWmpLSnNTZnY4bm9yK21iUml1d1ZxTGx1NmRhSEZURU9K?=
 =?utf-8?B?UThtNVRqbWZoY0xCLzBiU3F0UGZXTmtMeW1veC9aeE5uTVluNlRpc3RiWHhk?=
 =?utf-8?B?Y1ZBYW1EU1ZCUC9NQkNXTjNXZk42L09YUjBMS09oaW84dEQ4eU5vcGJTajJa?=
 =?utf-8?B?Vk5iQk9ySnBSYXNEcGg5Y2FkMzlyVTc5bGxPaG5VOWNJRFdkbVJHS3lFZis5?=
 =?utf-8?Q?fbNlu5+dsw5hjumg50wRrPJgH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0ac838-4470-4d3e-76d0-08dced5e0246
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 21:12:00.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yb0NSUfk1Gk+FgeZLln6uUvZLkIEkkpql7bq7yy12qSYlm+YqzIEf+eWN4KQkZAq+hDdKZyYDPAW8GY8Mgn6KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6043
X-OriginatorOrg: intel.com



On 16/10/2024 8:04 am, Dan Williams wrote:
> Paolo Bonzini wrote:
>> On Tue, Oct 15, 2024 at 5:30 PM Dave Hansen <dave.hansen@intel.com> wrote:
>>>
>>> I'm having one of those "I hate this all" moments.  Look at what we say
>>> in the code:
>>>
>>>>    * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
>>>
>>> Basically step one in verifying that this is all right is: Hey, humans,
>>> please go parse a machine-readable format.  That's insanity.  If Intel
>>> wants to publish JSON as the canonical source of truth, that's fine.
>>> It's great, actually.  But let's stop playing human JSON parser and make
>>> the computers do it for us, OK?
>>>
>>> Let's just generate the code.  Basically, as long as the generated C is
>>> marginally readable, I'm OK with it.  The most important things are:
>>>
>>>   1. Adding a field is dirt simple
>>>   2. Using the generated C is simple
>>>
>>> In 99% of the cases, nobody ends up having to ever look at the generated
>>> code.
>>>
>>> Take a look at the attached python program and generated C file.  I
>>> think they qualify.  We can check the script into tools/scripts/ and it
>>> can get re-run when new json comes out or when a new field is needed.
>>> You'd could call the generated code like this:
>>
>> Ok, so let's move this thing forward. Here is a more polished script
>> and the output. Untested beyond compilation.
>>
>> Kai, feel free to include it in v6 with my
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.om>
>>
>> I made an attempt at adding array support and using it with the CMR
>> information; just to see if Intel is actually trying to make
>> global_metadata.json accurate. The original code has
>>
>>    for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
>>      READ_SYS_INFO(CMR_BASE + i, cmr_base[i]);
>>      READ_SYS_INFO(CMR_SIZE + i, cmr_size[i]);
>>    }
>>
>> The generated code instead always tries to read 32 fields and returns
>> non-zero from get_tdx_sys_info_cmr if they are missing. If it fails to
>> read the fields above NUM_CMRS, just remove that part of the tdx.py
>> script and make sure that a comment in the code shames the TDX ABI
>> documentation adequately. :)
> 
> Thanks for doing this Paolo, I regret not pushing harder [1] / polishing
> up the bash+jq script I threw together to do the same.
> 
> I took a look at your script and the autogenerated code and it looks good
> to me.
> 
> Feel free to add my Reviewed-by on a patch that adds that collateral to
> the tools/ directory.
> 
> [1]: http://lore.kernel.org/66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch

Hi Dave/Paolo/Dan,

I'll go with this for the next version.

Thanks for all your feedback and the code you shared.  I appreciate.


