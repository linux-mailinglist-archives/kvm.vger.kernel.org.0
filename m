Return-Path: <kvm+bounces-11073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8CB872981
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 22:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C48D528F2D1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFC312C544;
	Tue,  5 Mar 2024 21:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqwQaCnM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7E026AD0;
	Tue,  5 Mar 2024 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709674560; cv=fail; b=qHlOfz8mwgCF5mgrlNHecTyTOSw0Abhrku4n19TeC4+o/SQvHjjbRzYw28UKo3mZPwwgOusmurehrskwS30wOFWmb/T1uJ0NgepHY4xW34K0+YUS0p8b1uFA7Q0JQ1Th/U5HbiJ/aDtUSB5h8pgBMYSY9ASp31sqAH5t1MW7ewY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709674560; c=relaxed/simple;
	bh=FlcjYWopeB3zfgTqa5UA9Xg3ZqGeWEN8iONoNpp/vxI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bfiWbcuRuCsxV6wzG+qnVkOOULHoUCL6kSLO+HQImqLsMFuAgWTDEssvHYDbA8nMOJLFAUnBs0JTc3Sy36lLldQu1QUEOtKnit3LlheV14YE0+agZ0aJMjHhDgWiAHSsxeTxjN2jbEXWaLTbiXynwW+7mdTmPEnoPnk/cirhgzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqwQaCnM; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709674559; x=1741210559;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FlcjYWopeB3zfgTqa5UA9Xg3ZqGeWEN8iONoNpp/vxI=;
  b=UqwQaCnMwgWOmCVTOYH52KHwprzL7Oukpp+yaYs4BD2wv8v72C30nLlw
   lyGSnJktzMmfFBjMvxptZv0s1JxUlxd8CWyNQp4Sq+/Z8zzzn0pbzSH5/
   1Gj7aIkjuKoWw7TCyOIhAtYzIM+lin4StSIbOHmzx9j0X6zTKpWq0vyDS
   4wqyLln7809t8OBhD9EXTj006Ts/BixDNs3uZ9Quk53VKLvx6xvjQHgH9
   lkT3+V5fCtWkytTtCRF12yQbCR903nEsDw4+RVStyFbhWR7hMlIRdzOPp
   xtIp84fPqXws/Qjxy5CqkEOE3G3V866s4yvz5vLb8DhTLfwwPUgaVoBj0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="29679481"
X-IronPort-AV: E=Sophos;i="6.06,206,1705392000"; 
   d="scan'208";a="29679481"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 13:35:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,206,1705392000"; 
   d="scan'208";a="10094788"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2024 13:35:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 13:35:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Mar 2024 13:35:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Mar 2024 13:35:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Mar 2024 13:35:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPTZcImc69BN0XFy2RQ+NCO1TQFH0CuD/DQyADXkfPA37F2eqZdn72Y/8xaZ3H6ZUAvuev4mtXOZaQ3y/JnLIwYn1wm33npyV986AlV22tbMUfZ8PDJIuomdOFJqmzZ+YKvnNwMDlUBlKeBYAIyri5aU7i5Ffj1/zyF3K5LE6U2L7tw6SGF9OSbabIoqqNvC9a6z7J2jhcipfjqcieZZJOyKVGRdFOm8O9dyk4X9LQ7sZD2Sh7gOOKmbCe4OAuKP5YbRC5MW70K5Rw0qD4BYExXl3uX0Xu7esr1kWYKLmWiFQDYHHNzfDVCi0k64sVAj1xXRyhpbwqCZpgvP0yQ4+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pi94OEQBkUp4RESNWg0UXzkU+RPCz8Nf+iXsp7zvMUc=;
 b=Yvuld/H0rX9UHaRB4zdG4ykfwdpjVDlX+SyErJCPBDky2xpigpA39JDF/khmAf4KDgJfCiUCxvtIuKJWSxKLrSPyT+u+SCaBWPZc+H5h9hyjOZHKy8GiS5kFns30Hf0ZO3LIBeL5tALdrr/6c4R/IceGpH/wdwe59ITAiuZIX+rUJesJu0L+gIlsqIV3W0hpeRtKeoNovAgzP26ySvNISAw3kD1hLqNblawDZeNa7jpDn8G7P9pQa+RQokXAJsReai1vD6qP+Xw1rYUFm7REn05LFIvo3+4vyOlWbh1dwV0KqtZla4olqCovr2Q+XIzqap2KysN23H38vLz3i+nV4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7572.namprd11.prod.outlook.com (2603:10b6:510:27b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Tue, 5 Mar
 2024 21:35:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Tue, 5 Mar 2024
 21:35:52 +0000
Message-ID: <75adc31d-6632-4ea1-8191-dad1659e7b33@intel.com>
Date: Wed, 6 Mar 2024 10:35:43 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 008/130] x86/tdx: Warning with 32bit build
 shift-count-overflow
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>
CC: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a50918ba3415be4186a91161fe3bbd839153d8b2.1708933498.git.isaku.yamahata@intel.com>
 <2f6897c0-1b57-45b3-a1f1-9862b0e4c884@intel.com>
 <jvyz3nuz225ry6ss6hs42jyuvrytsnsi2l74cwibtt5sedaimb@v2vilg4mbhws>
 <20240305081219.GC10568@ls.amr.corp.intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240305081219.GC10568@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:303:b8::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c7e238-f215-4686-0483-08dc3d5c3b79
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HckqxUui5yeE50tYevjz5scAzlt5Hm3yZgkUYG911jiwNr+72bRXXaQ4Rn6fyMwZ5VTdqSjZ0jJyRja6cnQj7QXpg/e7BM9zu/SRXQ5cRNBkPymktS1slKscx38MH/FAqEHrEYe1Kk7epIPoNjnbo0ZrY+c6vMP+ZKpz5rFgKpMgVS1gDC7m2dkx9hOvz89Aw5znpglh77KFUEf/hAdompYhe6gH9cM6ro+VVL8fKJOqTMMYwK/Ib/VXRs/4D723R8FM+s2TWr0lhxVbxEPTO75YvK3EF6Dntoz9ZUAq2avfnOn5orsiDW8YiRUYe2/ELal+r6DkoN8Edy6IFogccaulzd1NoVdwZLZh0lZsIXEHnESgDv//mQJtUTKUhcmN07WznAycV0XL+bwTxsYbctDLIzxA4CrRZQruswD4kItvlxRqgdT4oxjHelj3J5RTvgGWdl3Ay2NYy4XM6Mwi5CAULtUynQWOXWXfFX/8lChjdHJA8gB5gs3auUr6CHPmMyGS2YnAnuM/4Pc+8iuNhxAtR2SbcdgB8LLIHH4l6wUVUPOJWQi7P9c3H7bphRthAj7xQBWMJKECgf8sUTgi97/w3TZ437ue4lJUOarM2XOPfR3fP/hdEErT7pUwh9Eh99U1b8r6cOWc4919r+xM5lOTtOGBxx7E3gC5LzzzyXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHhMaVAyYyttV3lwZjJtNnI1cFRuRHFrdlAxYkVHME1iNVNnd3lMNlAvTUpM?=
 =?utf-8?B?TGNZSlo0Z0hkWDhHL1Qwa3BBNjVCMTZhRGs4N2V5UTlnT0F2MGs4aUZpcFBD?=
 =?utf-8?B?dkczM2RSenFkQjV6Z2ZkSnQ4VWs1V1FuSXo3Q1ptR0FTbGpqUThrTmE0SzdE?=
 =?utf-8?B?NGEzbGtVakxCQWNaa1hwd0dXMkRPOEFyQzBGa0VwdU1NdkxtVGVvZ3pqR1hE?=
 =?utf-8?B?NStzMUlIb0cvNkxKVVlKMDJMcUR1YU9CMy9WT0F2TzBOWWI2Y0xlK0pHMWlj?=
 =?utf-8?B?a2JSbytRa1lmaXdqR21nNllLaFZNSC9IdWtQNkFrelhiZmt6aXVvTXNmYm1i?=
 =?utf-8?B?RDBVV1hWaFNmODk2ekxWSDBYK0ZnczZib3RyREtiUS9XeHRscy9ubGlTNVUz?=
 =?utf-8?B?S2V1dXN1VHc5dCtKRlNIWnVWdmpyMXp3OUkrMWZTdjhWNVVyWkhOY0N3RGxt?=
 =?utf-8?B?eXRRSTIwZXB2SjNxdzZzQk9Vbm9GcGNINjZKeXRlaUd0RDNxNEFnODBSVFI0?=
 =?utf-8?B?MXZjMG1kOUZpRlk5QUxpYnJQV2ttamIxa0NOSnNGWE1Jc3BjSy9ORTlFKzhm?=
 =?utf-8?B?MG9tenRlZDR2S0ZNNGdMeWdlZU10RDlqbFZMYWYySHNmQUxocGN6THd6ck13?=
 =?utf-8?B?Rktabk56eW5QanhVMXRIdmdodUxqaUtoeUt1Y2R1T04vSnpnWExmTVZzRXoy?=
 =?utf-8?B?RHpkWmpuWE4wOXNUTFRtVTF6bUp5VnFyR0ZzNmtRaFZReG12N0RWb1NRN0Nq?=
 =?utf-8?B?L0V3WWZOVWtqR2FBQm9WNWdlbmdxU3VTUWgvSXN2WUZwNjZuMGxYVWwwaEVU?=
 =?utf-8?B?c2JONlBtTWVUOWNVbkluaFlVc0lrT3Q0WlcwcFcyeEpVUnJGS0Erem9yeTZH?=
 =?utf-8?B?Sk9FNXVOM3B1WXhLUCtLT083MUxMR3Q4K3gzcThhdXdzTUwvODJTcUtMVTdL?=
 =?utf-8?B?QW55Vld5Y1U5dE9SMStMVk9kb0FNOW1SSmRGOHVJT1VVMjFjVmZuZmF6RWhY?=
 =?utf-8?B?Z2h4QzNwQTl0V3Jtc1FzVEdSNHNFK3hvcmpKaUtYckFkaEhZcWlWU0ZpMEtL?=
 =?utf-8?B?NVF5Wmc0T0J6Y3lwWDU5Wmdxd2FvdmtVbmxtcGpwcVJMa202eFp1TlgvQ01a?=
 =?utf-8?B?QnBJa1dBcm0vZVBzaE83Um5jS1J0YVpSK3F3MnBzQTFKUFdieHNlbnlmcHV1?=
 =?utf-8?B?UEl2QU1KMzlVc0pVRWkwYTdoUUd0azlvajRqaGgvTmNiQkVLYjRhd1Q1QVNU?=
 =?utf-8?B?QzdiOEhTMzdjMjJhVUdwWUM1Ynk2VmdsZ3lEU3M0SFJ4VEFtd2NqUjFHMEpu?=
 =?utf-8?B?QWdiSGpZS1dUVi84Q0xWc1ZWcUlsekc1RCs0N1BpWnNuODJXZGRyVkVhYk9J?=
 =?utf-8?B?eHY2dEhJVmhDYlRjMDhsT2ZjMUV0WHB6UGxOZ1doMnhNQ0JVck02bm9uSkRz?=
 =?utf-8?B?UU5JTHdNVjFpL0lsSE5OQ1J4bjd6VFVkOFlVbTM1dVdjZGEvaHZ2ZGMrWStk?=
 =?utf-8?B?NnVORi9DOVhtN0YvU1k1TUdpZUVZN0hIWGs1ajdaNXdSZy9QaHlBajJZTkx3?=
 =?utf-8?B?SUE4N2w2dUtrb2FvUGhvUkRXWjE3UnBvdjJoNEphaXh4cE83VHZKbTB0dTZy?=
 =?utf-8?B?OHYxVjhmbllDOWNVVEhyUlZndEYyWVMxUjMzZk5lbGJ5Z1QvcEdkdDFtbUlT?=
 =?utf-8?B?RHZleXljS0NKb2RZVDRKRzNrdk4xZXRNaXBSeERkWkRhOVlQNFBPS2hGZXBT?=
 =?utf-8?B?cHZtdjc1SEx2aGxaZmtySzh3aDJtVmhjeFQ4em1FR1gvRldvVGtZNDErdCtZ?=
 =?utf-8?B?dXhMMjNmbE9pdnd3ckdkZGJzYmMvMzZLVjgzZ1c5RmJlMTZFT3A1VG9mVVJr?=
 =?utf-8?B?dlp0aGQ3UGFsYWhyMFJ1Smk0Qml0clh0WmR3cGpXdldxTFhBazVTaHZ6ZDQz?=
 =?utf-8?B?dFBaSGczMXJ3UUFuSjc1UFNCZzhpNzltaGxYNXllNVZ2YW1uOGJVa0U1U0p1?=
 =?utf-8?B?eWJxRDRFYlF4bWN2V0JLaTFIbjJkMDNTT0YwQks1RWp4Z2ZHRUtRajAvdWx4?=
 =?utf-8?B?eXEwc3diNTFaMkc5QkRmazhsNVFmYVhrM0dWR0kremkxR3hmRUZPbTI2NUNY?=
 =?utf-8?Q?NdGaKJr/pOw90Ecj87xhPh1Os?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c7e238-f215-4686-0483-08dc3d5c3b79
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 21:35:52.5466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qwtxV7L5MDfsAn/C6aFYqUuGu1X6Zjthx0eYykp5qPqdJzG8TOry7Lhl0NFRcfjGbzNv+DOtibgy/eFRSdxbuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7572
X-OriginatorOrg: intel.com



On 5/03/2024 9:12 pm, Isaku Yamahata wrote:
> On Fri, Mar 01, 2024 at 01:36:43PM +0200,
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
>> On Thu, Feb 29, 2024 at 11:49:13AM +1300, Huang, Kai wrote:
>>>
>>>
>>> On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> This patch fixes the following warnings.
>>>>
>>>>      In file included from arch/x86/kernel/asm-offsets.c:22:
>>>>      arch/x86/include/asm/tdx.h:92:87: warning: shift count >= width of type [-Wshift-count-overflow]
>>>>      arch/x86/include/asm/tdx.h:20:21: note: expanded from macro 'TDX_ERROR'
>>>>      #define TDX_ERROR                       _BITUL(63)
>>>>
>>>>                                              ^~~~~~~~~~
>>>>
>>
>> I think you trim the warning message. I don't see the actual user of the
>> define. Define itself will not generate the warning. You need to actually
>> use it outside of preprocessor. I don't understand who would use it in
>> 32-bit code. Maybe fixing it this way masking other issue.
>>
>> That said, I don't object the change itself. We just need to understand
>> the context more.
> 
> v18 used it as stub function. v19 dropped it as the stub was not needed.

Sorry I literally don't understand what you are talking about here.

Please just clarify (at least):

  - Does this problem exist in upstream code?
  - If it does, what is the root cause, and how to reproduce?

