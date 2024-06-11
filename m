Return-Path: <kvm+bounces-19357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0357E904643
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 23:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A3951C234B0
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 21:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA0315382E;
	Tue, 11 Jun 2024 21:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NV7b20SP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D376171C4;
	Tue, 11 Jun 2024 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718141639; cv=fail; b=cnhMahebEzKdA7/MtY3AiRmTqHmGczGv5eZuqxZXDVZleFu3GwEysQg11r7vekIfL6R2SAGe52ArAqCmTC4vj3Wg1qSAMjmdrS9nuaVh2/R+sReq7DHCCx+pnmOnkdEnYBOmCLgm/uzZ7HSFJRnQX7XipU99TqfxXOFeDOVNGuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718141639; c=relaxed/simple;
	bh=vEBIY0y4mPQMMCQcy+0AFSPgb0jvwHbDta/Yq1blLPc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kbJfWkVt5u4sCgbS3unyXVov/oYeFtVNxvWqYyxJcQX90rUgfbPzQJz3BpWJpCuc2aZ6/A/Fjisr1kaBUTHDFJ4HdSr+R1zZPE/4t7f37hHqzKDXhcYOtcSOPARKlu7qsnmJjBB387ZHdMJSQRbPhSNkr1Xw308AXiz+O8jhJHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NV7b20SP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718141638; x=1749677638;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vEBIY0y4mPQMMCQcy+0AFSPgb0jvwHbDta/Yq1blLPc=;
  b=NV7b20SPnvHoQLKOFgUqErMcg2IXW7+Ijfl/9/qNMahY6JbDOmrtP9Jm
   WsWBxorgFexVw/OrV0qbpGrlPm/mJDFH6jWhK4Itud/eZjiV0zlkYhpXN
   lx70mUapl4Tpug14++aoPqCF03i+liaIXDkh0GEgzgVkYaZyFV+xb/2YM
   om4GLssORAAYjtJIkHAhswdF8yBdj1+obezUOdBxFik2mlJtyrwIi41F7
   U+VbfRiFFHRs1M0Mrc/Llej0eNy3KEdpB68jxwz/IObJwbkDFNmOvVq0R
   VFfpeALbxNY9Xqt2K5klQ6uw5Ab+TECNTNsHgq7XferoCZqvH4Hs2XhJN
   Q==;
X-CSE-ConnectionGUID: u6ANbQSZR4eCigRhfgrWhQ==
X-CSE-MsgGUID: cF5qi6OURGCpdCow3womUQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14713236"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14713236"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 14:33:57 -0700
X-CSE-ConnectionGUID: FZ+NYHPKRIyqQMsu/IFO4A==
X-CSE-MsgGUID: vbT3zFegR0e7yjBNWDOK7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="44114909"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 14:33:57 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 14:33:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 14:33:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 14:33:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewzit4OpfvLMqDayQ4z6ZnbyPv1uNIt91bH4jCpEuWvpuqHlx+nXqEBz960xEHDFsiDsdtCYmXZUDLj2TYWLhDYj2K+a8V+ZMDfbeaPMVIK0krrlXj3GLzyOPRUX90mFIfAH9dTa2sLw/GH6OJHDA+0PWIk/N8K4CQnWtV6aFCHlpHdbQLCUMLAPFN4KK7pT3sMVfbHaL9OnEaxHmqWnbSrsRacNDKe21wzbDpdSeuONV46OIhgsErUS1/vFLRYz2A/D9iaDcx1fwSuhBsiimkhtU55lnLvj/2LULx1CNoBOkA8OB5uX0tUgl0dEAPgOecX7mfHgEbTLtgygssHYwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VONLMqnJYLf7SIKaEqZ0dVYF77s9u+3YyE+ixi8gwoA=;
 b=EOTdTGxtViG7+Lb20CErlWy0KYlVkJ0EnxDLwyxKXm4tOGOXewZWff9XAHzkbNdMvA/1BFUj5MU0pu5p7C8DdNdr429SIS+g1Lsgz+SJGJpYBhK5d5gqRlrF1ZvtBF34IgeqXv2cUY3vJLEmSm2PxIfqAJcQmQIF4xYHwdEgf9X89UXum9JqrU8HW9bQz2oLZoypPLO9cPGkbiTB3sf/YkpcFIVmTTKdeXxtEE3V1Bzip7besLQAs9uUV8jxAHUYeccdeGwKEVVXYDmGCLjokODzJ4JQnS0VqCADMbyLrux3A4SmPWVb2oLSji3K192A4u0EyyT8CM6ww9oBuE/+Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8025.namprd11.prod.outlook.com (2603:10b6:806:2dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 21:33:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 21:33:53 +0000
Message-ID: <a44d4534-3ba1-4bee-b06d-bb2a77fe3856@intel.com>
Date: Tue, 11 Jun 2024 14:33:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1718043121.git.reinette.chatre@intel.com>
 <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
 <ZmeYp8Sornz36ZkO@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZmeYp8Sornz36ZkO@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0294.namprd04.prod.outlook.com
 (2603:10b6:303:89::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f38d228-bf81-47cb-3c60-08dc8a5e3105
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|376006|366008|1800799016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ckRlRjBSVzRMYi85TkVIZklyNTYveFE1SGFCbWFqTjcza3RYRTZEak9vMXJw?=
 =?utf-8?B?bGwwcytOaFhrb3dJTWNGM252Z2I2ZjNPdEpHcFBuQlZXYkd2QU1kR0V6dVph?=
 =?utf-8?B?eGNKekVTdHVMbTVzTmthU0V1VjVEbHNZcHpQYk83R1J6K2E0Qyt2alFNM2xW?=
 =?utf-8?B?a3pnVGt5RWJ3V2Z3YWxxcnhtZENYNEplM0F3a3dFam5oL1IzR0lXK2RiOWQv?=
 =?utf-8?B?ODkvRm9FWkV1djhoM2hlMHY5aGt2aDRYV1hOenJnZERFeWpLSUtHNTlob0ov?=
 =?utf-8?B?S3lmRXBTOHVoK3BKYjhSenhCcEZ5WlNTWmwrT1psbEExL1ppQmFxcDJLcHlS?=
 =?utf-8?B?b1FRMnRVNURGMVhET3lHWkNHWEw0ZitrcFZVblN0UkNFcldoZS85djNUQVRs?=
 =?utf-8?B?dkxjMnNzdEJtM0N2SnJGQUNFK0lGSDRrL0pRUU1BZnVNNDIvM3JNU1VVWXUz?=
 =?utf-8?B?TjdTMU8yQXZFa2dDZk5pQlBQQTFOUVpaSFYvcnZ3VGpQQTlqSjQxTGhMei9i?=
 =?utf-8?B?YkdRbzZXTnhkZG5yWE9VOVpzN3c4UjhIVUxRUlVmVHVsYjBVQnVwZy9jT1Vp?=
 =?utf-8?B?OFBqK01CU0h3U3I5Znd6Nkx1WnVZTjRkWXZlTURxem9mY0NJS1RpdzFrNFZE?=
 =?utf-8?B?YW1HbE1FT21zcGdxWmxWWDhxeVViVnovQjRuT2FvZlorRnBNM2Juem1jV3hU?=
 =?utf-8?B?ZU50U0xsbklaQU1BdnJVRzlSSGNDdFBMZFNHYlU5VzV1djF6eklPclpyT3d3?=
 =?utf-8?B?OTZkQklVdmJXemJJQzkvdUFkb0Q0d1plTmRIdzNPS2Q1ajVDSW9zMDdFMjFB?=
 =?utf-8?B?Tm5DeVpmamoySHYvQkFiOE82V00xdEl4Vk84T1RTWXlYQnlEUGhGU2kwRTZ3?=
 =?utf-8?B?UDJKa0dNSVA0SWV5OTVIZTQ0L0xsSTdZVE1pVlVSMmt5V3ZzeGRYRlR6SlNz?=
 =?utf-8?B?WU9acHRpRGVZS1lZZHJwQzYwOXZkdkk2cnhaZG5RT1FicmdPMlFRNWxTTGhy?=
 =?utf-8?B?ZElORmt4NjVFTWRSakpzT29kaVBuQlFVZXVSVW9xOWFwQ0NicnpKNGFkbDlZ?=
 =?utf-8?B?N3VhN0NBdklPRkRycGJLWW9hS3A4Ny9MZWtXTkR0L1RJWHVCRUNFOWY5SDNt?=
 =?utf-8?B?TFJ5ZmlhSWI4Q25TWTN0RnFJVjNENHhDbE45azZwaWdDQ3J5UnQ1TWFqSitT?=
 =?utf-8?B?TllqMzdhM2xTTTJ3MHNKTCtkVUpaTlJsek1xcElqTTdBcWpjc3ZDb1hYR1hN?=
 =?utf-8?B?SlBwSVFWV1dCdlVpMENBYVdqNTRrWm5iZDliQ2RGNFo1dUt3Ylh2ZEJJaC9M?=
 =?utf-8?B?SlBXaHZ3MVM0U0V3blRRWkg3MG0zdGV2R3hkZ3lOTTRJRHN5a2kwdXRQYmp2?=
 =?utf-8?B?azVMU1NaWFFyNENIMitPREJCWVptRWpVVkhZN0VUeFJmbldqdUJWenR4K1hF?=
 =?utf-8?B?Vy9Ldi9STjlxa3NTUkxneklLbjV0azkrZHpDc09Eb21zS2RWb295YWd1VFRh?=
 =?utf-8?B?ay8yVktnWXk1R0F1Rmowai8xMDJnRTZCLzVma3M1QjV2N3lXNkJCM2VnTWF0?=
 =?utf-8?B?b3QwLzVpU1QrbU9URlFKWjZOODVrcCtuQUFQSi91QklxWkNnc1BGdEZmRk5y?=
 =?utf-8?B?WmRlYzdidjRkMmt0a0lEVE1lcDJXRXF5MkF2V09CNW1IMDg5eHBCUjhYVTJN?=
 =?utf-8?B?REJ6cHYzVWhLMktvUHBUdllodTNVRlpmaU1vR2ZEYVc0bFZnZ2VJNmtiYUd1?=
 =?utf-8?Q?0lga2MAUBlBVsio/nsIX44mx+Q4WQrPfeYpoG8B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(366008)(1800799016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a09GdVphMk4zZG1UZ28zcG9FWjVuVmhuWmw2R0NwL3JteGgvQU1Ldk4wNXRa?=
 =?utf-8?B?eG9IODJYWkxGaHJWK2tiRytJbGhVZ2N4L25INExEQUpidW1SMUVSTGRHY1h4?=
 =?utf-8?B?bmxTQ3ZFNVJDNWVycUN4aTlDUVJZNVdtaFB0MDU5T294bTNLblBwV3RmRm4x?=
 =?utf-8?B?NUc2TXdkbTBpc2FWWUNMejdTdStTSGNUQVNMMzBIcEc4NmpXSHB6UmdwN01W?=
 =?utf-8?B?cGtuZXQvb1pTZ2lVczhJNHhrelYzR3BrV3MxeTZnYkZxWC9oZGs1Z09kZHVk?=
 =?utf-8?B?cXdiU08ybmJVOHhET3EzdVo2S1YzTmdHL0xvUkh5ZUNKWURpMnQrYkJkbjhQ?=
 =?utf-8?B?Zm96ck1JK3hsWXdDKzhDM21DdzJmMm8xOWJBOWhKTEl1U25RaDdvZWZTc0RC?=
 =?utf-8?B?UE1qaitibjA2dGdZUFErbmhrQnZCb1E4RElucnJxM0JiWldTS1FZM3dOSHBH?=
 =?utf-8?B?cnBPbWVDSVY2Ynd6MG84NVdTTmxzbkNCdkVsTVNKbVpOSGxqQWZPbkRxTGxT?=
 =?utf-8?B?K1FXcTZVT1BsbUw0SW5WYktYUXA0aVU2QkNDNk1Xb2kyOUFIbk5CS2Z6MGRO?=
 =?utf-8?B?V1lJTEh3eUVwQ1J5S2F2bXlOb3VJK0o2ZHZpTFFIWk9GQVNKNjlyNHNRK1RN?=
 =?utf-8?B?NS93Mm5ERzdrWDVwdU5wWkUrK0lFeVgxOWtWWVQ3WTQ0eCthWExJTDZjbDRB?=
 =?utf-8?B?bDI1SkxxZVp6eS9KUHVVNmNPaGpBcnphR2ZFYUNYOUhJRlZGc0lGZjFib0Vv?=
 =?utf-8?B?NTZ1OVFhZVF2ZG1GRmdFZG0yNmNtY1JjTmNjZk9zMjBEdDlBS3EvSUk0TUJL?=
 =?utf-8?B?ZUl2SVZxdXl1NW9LV2ljbWFZWlMzN09oaHlOd0l5SUYzVkdYMkNTczlPNDMz?=
 =?utf-8?B?aXJObXZ0b2QySzZKWnJxRmkvUGF4OFFFUnBPT3RHQmQvVXJYWVU4L0NzcmtU?=
 =?utf-8?B?a01SbFZ1U2pxbk93YTM4a1VnNFFqS2hGQnRONFRrUzRHak9KM2QwbGU3RXNs?=
 =?utf-8?B?RCttbzlFUmNrNWFIRVFLSUxHZVpSOFc0OXBidURseTJ2YXNLNVB5b2ttRnZR?=
 =?utf-8?B?UlZENkhlWEFXd2dCSEJJWkFIbE4yaGo0bDBmbFl2WkdlWkNRM1dJbnZOYnFF?=
 =?utf-8?B?SmY0RDJ3M09SK04zRnlLd1g4am1nTXNkbnhKaStEYTVZclkxQWp0ZzVmVnFO?=
 =?utf-8?B?SHlOSmpmbFJSekxTV1FTakgrWC94LzJCd2lNbnJZYUQ5OUkvSTkvMTVjeUts?=
 =?utf-8?B?ejdsSlYxS214ODBOK3BzWms5THJnVWNFYzNyMm9Oa2pBTXB4cDJxcVBtTzVG?=
 =?utf-8?B?eFNVaFNzUW50SkxuNFI0d1V6TThkNEpSOENCMjVadGlRT2s5VW9venRBNmtI?=
 =?utf-8?B?RFVoRDUrM3hkSGtrUXQ1ZVhDS2JkRTcrS0FRZlVaNmczT3pjUytjZzFoMjU4?=
 =?utf-8?B?VkR2dVNzVjdKUExacEpJZTMzWFRXTGtZU3FHUHB0V2wxUkpHTk1xOGtTQmFp?=
 =?utf-8?B?TXZzMCtvbmROL1FKOUJxTVFqanFhSlhMbmhsOHZQM2R4UEZJMng3NVJ4aFBl?=
 =?utf-8?B?ZjlXMThzYmpva1pnMTJQMkhrVGFYNGw5eC9IV1VGSXowMFYwY3gwTVo4Yndm?=
 =?utf-8?B?Y3RYVWFBTFN6bFEvcWdVRnRaYVEvdnA5aHNKTG9zemJTSmJFUjdudmZzQm94?=
 =?utf-8?B?dXlGblY0YmRJakE1THdaS2ZhclcvV1FDS2dmTzVXUVZvaW1PdmxpOG03S0hk?=
 =?utf-8?B?M2ZWS1N1WUo1dGl6bVA0Z2U3elBrQVZKTjBsa01VWEU3WnlGeGloUWlLVkRq?=
 =?utf-8?B?YnZEV2ZrWTNEc0Iva3RtRlBCd3JUNVJQL3NZdVN3TGhicDc2YzhyeFc2bzln?=
 =?utf-8?B?OUU1TG92bDdaeU1QcFI2YVZkc0xwbWR2VFpOVFQ1WnVIZVZsWko1SzdzOGF6?=
 =?utf-8?B?bW8vZk9JazIwbmxXb2k5dEdTWTA3QitBQ01qREdrTFJBTjNtem1tZllUN1Yy?=
 =?utf-8?B?RE5Kb2ljUTlqVmlXVGRWWEhHL1ZCS3dXM3FrOUZoN1lhaXpsVkxvRDBlb3VG?=
 =?utf-8?B?ODV1aHpWMk5wKzFkbFduUm9lSWtQVVZJRTJHSWZTWmpoY3hrTVc4S0tDQ0k0?=
 =?utf-8?B?WThXQlJVM0NqMU9TS25JNzR6clY4K3FKWFh4MUF3YnI3MU5wYWViWTVWNUhj?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f38d228-bf81-47cb-3c60-08dc8a5e3105
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 21:33:53.5776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3JWHaI1A+/eBdoHuV7R2rJcu6j1dgNivqmgBKfUr2sTblv7cR5HwcbMz2kf1raWEOZ1oSlksS55GcQa4lkNXiUFi9aOvJvgaGukyahV4Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8025
X-OriginatorOrg: intel.com

Hi Sean,

Thank you very much for your detailed feedback.

On 6/10/24 5:21 PM, Sean Christopherson wrote:
> On Mon, Jun 10, 2024, Reinette Chatre wrote:
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> index 8eb57de0b587..b473f210ba6c 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> @@ -23,6 +23,7 @@
>>   
>>   extern bool host_cpu_is_intel;
>>   extern bool host_cpu_is_amd;
>> +extern unsigned int tsc_khz;
>>   
>>   /* Forced emulation prefix, used to invoke the emulator unconditionally. */
>>   #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
>> @@ -815,6 +816,20 @@ static inline void cpu_relax(void)
>>   	asm volatile("rep; nop" ::: "memory");
>>   }
>>   
>> +static inline void udelay(unsigned long usec)
> 
> uint64_t instead of unsigned long?  Practically speaking it doesn't change anything,
> but I don't see any reason to mix "unsigned long" and "uint64_t", e.g. the max
> delay isn't a property of the address space.

I assume that you refer to "cycles" below. Will do.

> 
>> +{
>> +	unsigned long cycles = tsc_khz / 1000 * usec;
>> +	uint64_t start, now;
>> +
>> +	start = rdtsc();
>> +	for (;;) {
>> +		now = rdtsc();
>> +		if (now - start >= cycles)
>> +			break;
>> +		cpu_relax();
>> +	}
>> +}
>> +
>>   #define ud2()			\
>>   	__asm__ __volatile__(	\
>>   		"ud2\n"	\
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> index c664e446136b..ff579674032f 100644
>> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
>> @@ -25,6 +25,7 @@ vm_vaddr_t exception_handlers;
>>   bool host_cpu_is_amd;
>>   bool host_cpu_is_intel;
>>   bool is_forced_emulation_enabled;
>> +unsigned int tsc_khz;
> 
> Slight preference for uint32_t, mostly because KVM stores its version as a u32.

Changed it to uint32_t.

> 
>>   static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
>>   {
>> @@ -616,6 +617,8 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
>>   
>>   void kvm_arch_vm_post_create(struct kvm_vm *vm)
>>   {
>> +	int r;
>> +
>>   	vm_create_irqchip(vm);
>>   	vm_init_descriptor_tables(vm);
>>   
>> @@ -628,6 +631,15 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
>>   
>>   		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
>>   	}
>> +
>> +	if (kvm_has_cap(KVM_CAP_GET_TSC_KHZ)) {
> 
> I think we should make this a TEST_REQUIRE(), or maybe even a TEST_ASSERT().
> Support for KVM_GET_TSC_KHZ predates KVM selftests by 7+ years.

Changed it to a TEST_ASSERT() right at the beginning of kvm_arch_vm_post_create().

> 
>> +		r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
>> +		if (r < 0)
> 
> Heh, the docs are stale.  KVM hasn't returned an error since commit cc578287e322
> ("KVM: Infrastructure for software and hardware based TSC rate scaling"), which
> again predates selftests by many years (6+ in this case).  To make our lives
> much simpler, I think we should assert that KVM_GET_TSC_KHZ succeeds, and maybe
> throw in a GUEST_ASSERT(thz_khz) in udelay()?

I added the GUEST_ASSERT() but I find that it comes with a caveat (more below).

I plan an assert as below that would end up testing the same as what a
GUEST_ASSERT(tsc_khz) would accomplish:

	r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
	TEST_ASSERT(r > 0, "KVM_GET_TSC_KHZ did not provide a valid TSC freq.");
	tsc_khz = r;


Caveat is: the additional GUEST_ASSERT() requires all tests that use udelay() in
the guest to now subtly be required to implement a ucall (UCALL_ABORT) handler.
I did a crude grep check to see and of the 69 x86_64 tests there are 47 that do
indeed have a UCALL_ABORT handler. If any of the other use udelay() then the
GUEST_ASSERT() will of course still trigger, but will be quite cryptic. For
example, "Unhandled exception '0xe' at guest RIP '0x0'" vs. "tsc_khz".
  
> E.g. as is, if KVM_GET_TSC_KHZ is allowed to fail, then we risk having to deal
> with weird failures due to udelay() unexpectedly doing nothing.
> 
> 
>> +			tsc_khz = 0;
>> +		else
>> +			tsc_khz = r;
>> +		sync_global_to_guest(vm, tsc_khz);
>> +	}
>>   }
>>   
>>   void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
>> -- 
>> 2.34.1
>>

Reinette

