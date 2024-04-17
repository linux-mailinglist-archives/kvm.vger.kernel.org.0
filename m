Return-Path: <kvm+bounces-15029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3B48A8F20
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA8871F22203
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CE18563E;
	Wed, 17 Apr 2024 23:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ln8e7hBY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6C5481B5;
	Wed, 17 Apr 2024 23:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395399; cv=fail; b=i/ZmQrf0I1B5Tncw0UnwdrnoE8hsWt1s5XrwtFTbQw8Vnbbr3Htrri0Q8Uy1ojm4oYq28jcRn93wHDhEhPVLb2RqhhctdhI/4gIMmRKP1okFrFuOSYsRah/DvJSCuL4RjPDie6O+zdlAdJVpXdBwDpYJbtGbaxSBUk1ygXpJoQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395399; c=relaxed/simple;
	bh=JrMgCkJM9M1B/UqmbQYKAzaJo4yFN/LSihpVM72AWtI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=odhU/JK3fBWSLEMQnxhxS+B2lX5WFFFWpD/0MhWQVIqJs6BxoIOYAj6V89FLP9cOQq6A8nShFcnMqIjwOxYYrF9bmSdkef6KpB8qjgS9GsUYouchDS6uPuyqNn/CEhWtPW2L/3cBB/X4QJUOPhZSEr3VF+IKz/gEsh7FxMYCs4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ln8e7hBY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713395398; x=1744931398;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JrMgCkJM9M1B/UqmbQYKAzaJo4yFN/LSihpVM72AWtI=;
  b=Ln8e7hBY3J8L8iuVQWxrd0e54QXYZCfA15i468rg6RzpyJqJJ4gf3bph
   D2dHQU7xvMMzqwoCwiPOZVj6OtFOPgykhOqnW5pkPLt1eaPvVDkYgT+dI
   mt8iyKOErfe4kHrF8K4wrqFdlGs8Qo1QFkTAByBM7VHBePr1YUa3nP3O+
   3uhLGSdamEX8UwrRa6e+9/whS1s9PsTW9NJUA1tF6MvS9cyuRPVSbNLaC
   5pr9J1suPeqU+XoD76OSjzIjjyyYrYxYbQbITHUMLqsCJUqcmzOWAc+6S
   YYtv3/1I5DrSirfOlNo4i+12LM5FsUrTiOznL1ETS0mTpMwR0V7c3pO3N
   g==;
X-CSE-ConnectionGUID: em8ptlxGRPi6LNvZSnSahg==
X-CSE-MsgGUID: FHRd+qUPT1y4uYTwqr3Zkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20339976"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="20339976"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 16:09:57 -0700
X-CSE-ConnectionGUID: LtNjAHBwSgShVAb4FEZ9Hg==
X-CSE-MsgGUID: xSbN353VTcyb5ohM/pEEJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="22869806"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 16:09:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 16:09:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 16:09:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 16:09:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 16:09:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmDV5GaaxvE1Gr0URXY/t9zmvbRxweuM5kYIMoCZvFeGh93vJKYwd+N5bmI+9z2m8i4P1KPxqcEl+sJvnf+E8EDhSd/skzgTmtAelB1kKtVrBMijmEJKt6jng1jBNOrL0uzpRkxAcXo1SjJ2O4KwMnKoZgGNXnS5d7Cjl8Jat6I8yEhdpuujymVqEylDigDHygjh35GNUhYFSJk7Ah3+XGzUu36ESBDYLJ5x+CUKT8IX+HHZr09OLX0aum0ongivz5Gf059OTlLLfd8/JbNp6FQ4BkflXjmOxYvjHgsr+87KgoO41lq9mWzLlSXPCvbM07RBHVV4yNjAg5d1iCgc9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jt4jYFFUOFKQkU4Uc7DgRtrDyFcX0JVIYPo2oBaiP4=;
 b=X4MymsV0Zb5gPwWGU71dq/tabYuf/Wo3NYkmnvWM1h3ro6BwJPsQHPCSKT4rHKHSLb6XrfysLPZr6ZB6sAOpTwYBzxb0WtHrCbHbOAX25Spf56N/bozH1tcK45TWoU8/D9sk2gY9U3/nFV+023hN1paDEQwoxqaeBoI2x/jkrgmf4JkHPmcBuTrrRpF+1KHM8gxgBxCjVLkVmqOX8FPys7naWeMZXNWSU4qWHyZQvplzww2Bj8YFdo1BMnXSxfTnmkiT2JKKkDuErjRavxQGu1N5tRyhIFMbVcqYpJZsEd54GDXXYpwxUL8n44Io9Zw+R7gT0FRcE+4wWjHhjawGog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8239.namprd11.prod.outlook.com (2603:10b6:610:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Wed, 17 Apr
 2024 23:09:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 23:09:51 +0000
Message-ID: <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
Date: Thu, 18 Apr 2024 11:09:41 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
 <20240322212321.GA1994522@ls.amr.corp.intel.com>
 <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com>
 <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com>
 <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com>
 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zh_exbWc90khzmYm@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: ccdba919-d775-4e26-f85c-08dc5f337c84
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /c4m9/+Ectjo/5QEOvsveC9LP3SuqRNXkDGZMDahzeOqh5/lXUUDejcrb0CN+I040Vda66cxncPhsAA9Mouau+0ywdVdXvWP3nycoYxA/bN5GnptzN2BFyq/rSr9seTyPI0wEvlztGx3aOCbflu61+aZwCzDpikuoDhD7JcbkPezX1IkbW9fapg3bUPQhK0sxkjaSLcUoSDDxjp2fsj3S9Odo0m9agAE1N32AUQRcZEDDXc69MbFinu+YYWPXseOBoQNo1vqUdhrommA41oCPXaFhlZxTP6+0doUkWv3dElAFdSzCkoTB//5rSLEaP9BVTXbtQntu/06ZutVbQr9s8gERi/pzekCjOoEn3r1x+WDZ6/IYe8QbF5XUxia+UpJTKcmKthifl4O/xox6NZvSQ2P4shXsPJN/UU12+c1iMHvQnwYtNW7hCEuXBgbFYqjXgI7pbX6G7OyR+CYrpzf/rmovRun+W+k2T/+fbSyDccggaDUWTiz8fHyYNS5l7dFzW+mHAiBOz73EF+udmn9xcmFuI4cDjW8wMGbXDX2BBeUQCZ8aQffFUcddI8VIX1yLrxB5iYkBQxykSBlnxMNIL7Z7Pgbqr7j64o0FCJzNe992QQFWylMhga29hPg+cYSQCKWZMgoAaK6DHF4TpRGbjgNsZtGGxKAzMh/arFeDu0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXZVZzZrSDZ6ZGVYWk1tV2daZkJuZUkrekFhUHVXQ1NuY2tCQ20rOWNlZkI2?=
 =?utf-8?B?SkczYVhINHM1SThUREJvMEc5eHpRQUdnMUlwQjAwb3FvV0dUS2xpb1JnK0lx?=
 =?utf-8?B?VnF5elFwZVdYOVpBNmFhU2RrczRwN3didk5OaVNRU2kxN2NMVDZITnZZV0JX?=
 =?utf-8?B?Q2VxbmMrckRDM0JXdVdzYVNaenUzRkpqVlRqTEdhaGY3bFRQTEN0UjdnbkFS?=
 =?utf-8?B?L0VNeUxPZVJLdk51MnNzVTF6dWpwK1NJdVRSZ0hEY2t0U0o1MTVFamNmK2l2?=
 =?utf-8?B?anlobWdPMmYrOWhNMTJpMkZFSXIybDRFU0Y0bzVQNnJFWENndm92cHp5RmRB?=
 =?utf-8?B?cjJxNll3R1BUTE53Y3J3QVdjczZGcENQeDlGT2ZISkZJbHRSMjh3SVR1d0NJ?=
 =?utf-8?B?NTdpN1BNeXAzMHRBWmVnQ2hZbjg4bTdLV2x6dnBBU3N1N040bnZib1YwUXYz?=
 =?utf-8?B?MEtrNVFvYzZVbzRoVVI4WTZCK1kxNE5JbVV6c0ZyWjBiTWovZi81SU9ubFhp?=
 =?utf-8?B?OU1BeGZZZHAycGh5K0s0SjNHS1hIcG40dW5ETFJMdzZlZmp2eVFhMVp1cTRz?=
 =?utf-8?B?UnNNQmdjTVZzUkUrMzhsTFJIa3BVSjlPTjJ4NlJGQm91TENmdGJCSk1kMWlJ?=
 =?utf-8?B?R0dOcXM5VTUzTnRBUUErenNwMUFQSEplcjJGM0RMVFpYc1ZRalZlU090K3Zy?=
 =?utf-8?B?MlFDUWMrbmQwOUkrSzZkdVpqS0FsM1V0KzRYczNYSG9uK0lOdkRvWDNNL1pH?=
 =?utf-8?B?bC9xd0hIL3JjdERWdmVpZksxTVNOY29Hc0RWQWxwOTFiVHdEcUVrOHoxUkVo?=
 =?utf-8?B?NGwzR1FmY29ZMFU3YUVzWkdYYWppUnI1Zm9OeXREVkl1UTYwenVIa3A0cG5D?=
 =?utf-8?B?bk9WQXNlU0dlN2RLaXczWFc5TTkzN2lmT3NLMnBnSnd2bENMQXJVZnZkUEt2?=
 =?utf-8?B?b3RtWk9iUVlEQTA2LzRoY1FCdEg4TGlSVUJHaTlIQlRadnZwaTUxak51WXI0?=
 =?utf-8?B?bEtPcHIrS1NYOE52dDF6Nk5XUEZ4TnF5c2N6SDdhTWZBN3dRSXFJdEFnU0ZM?=
 =?utf-8?B?WGl1Zkdya1JlWVlZS2RWejY5QkFOKzFxRGNIZ2pUWXR6Ly9MYmlwZ0xGK0Fn?=
 =?utf-8?B?ZXJUMGhZeHhxQjQyK1JpV1FXT2NTYi9EdWxGdHRLN2U3bWVPZjRZRWdBZDZn?=
 =?utf-8?B?TFczTmJ0bXBSSmhXRlladGdzdDIwRm5aamx2REZjRU9aVE15bHR2UmM5TUw3?=
 =?utf-8?B?NFBabStDWndUbUpnTkRCR2lhTVdxTTFnaklrcm5TdXZwTmNmazdqcWhGZllO?=
 =?utf-8?B?OVdiL01iZGNpcHBoc3d1azhzb3FDdUZVaEpLWExmM1pXN0xSKzVIWHUyWGpY?=
 =?utf-8?B?Mkdoc0ZkbVM0MVZvZDdTcFRtVys4SG5ZYk10TDlQVGpOWTVMeTBOeVMzUzdS?=
 =?utf-8?B?cTZ0L3N6VUlTV1B1TFJHN3NVM08zQnE4N29BUHRKRjd5TFhtZzhoVlZLNjVC?=
 =?utf-8?B?S3h6UzZQckNNTVdNZElVcjRpMmc4SHM0a0ZWMFJLeVk0VDJkYVUvVTJEUXA1?=
 =?utf-8?B?NU5rWkJiRk10emlHVDJRYk1XVXBXcVMvNTN4WFNac2NieXA1b3N5YW8rZjVo?=
 =?utf-8?B?a0tXWEhUcXlDb3dmT25ZYTNJeGJlb3VWUWg0a0c1d3ZNMzNja1lES0NuWDhj?=
 =?utf-8?B?QjB2Ly9Vd1c3M3FNWDVpWjNwQnVsSC9mYnB0YVAyUGRNOU81RTJsYmMrZytv?=
 =?utf-8?B?MFJ2U3ZBa3pTR1hEenlhWkx2WlgwVmhtTGtGRU9hUUd4bFJMUEt1TzVKelhL?=
 =?utf-8?B?cW4zeFB5Yk13VmZMM0tRTk04SzNBeUpjK0lETEFaeUFRc1krSXlSQnN1cmp6?=
 =?utf-8?B?bFJsUTFwcUpDejNIbk00YnlFUkV4WVdERU8xYjVoQjlMdlFVTGk3SmJtanRn?=
 =?utf-8?B?c25XYzhIaVJXNUZIUjViK2lUc3J1SzVtcy9Oc0ZNalcvQkxJb0NyMk5xRGhX?=
 =?utf-8?B?Vnd0N2NKeUF3dlFlYm9iSWJoM0xWMzg3ZitPQlVEL3ZDcmxTMnIrVlpxYUZz?=
 =?utf-8?B?ZGpuSWluZXFpL1F0aFlFVE9zYzdOVThPQVV6bGREbTNWNUFpbDU4UXNEckRp?=
 =?utf-8?Q?XDbUivy7F05Qi5BgiWxEeBdvE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ccdba919-d775-4e26-f85c-08dc5f337c84
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 23:09:51.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9O1qJoUJkjWWCGqa7XLVsulqEs3gBdQHDPzZzfBiEnlQyC86KQYLdf+BJG1NFQQ2hTvkuUcZdIV42DFtXbLDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8239
X-OriginatorOrg: intel.com



On 18/04/2024 2:40 am, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Kai Huang wrote:
>> On Tue, 2024-04-16 at 13:58 -0700, Sean Christopherson wrote:
>>> On Fri, Apr 12, 2024, Kai Huang wrote:
>>>> On 12/04/2024 2:03 am, Sean Christopherson wrote:
>>>>> On Thu, Apr 11, 2024, Kai Huang wrote:
>>>>>> I can certainly follow up with this and generate a reviewable patchset if I
>>>>>> can confirm with you that this is what you want?
>>>>>
>>>>> Yes, I think it's the right direction.  I still have minor concerns about VMX
>>>>> being enabled while kvm.ko is loaded, which means that VMXON will _always_ be
>>>>> enabled if KVM is built-in.  But after seeing the complexity that is needed to
>>>>> safely initialize TDX, and after seeing just how much complexity KVM already
>>>>> has because it enables VMX on-demand (I hadn't actually tried removing that code
>>>>> before), I think the cost of that complexity far outweighs the risk of "always"
>>>>> being post-VMXON.
>>>>
>>>> Does always leaving VMXON have any actual damage, given we have emergency
>>>> virtualization shutdown?
>>>
>>> Being post-VMXON increases the risk of kexec() into the kdump kernel failing.
>>> The tradeoffs that we're trying to balance are: is the risk of kexec() failing
>>> due to the complexity of the emergency VMX code higher than the risk of us breaking
>>> things in general due to taking on a ton of complexity to juggle VMXON for TDX?
>>>
>>> After seeing the latest round of TDX code, my opinion is that being post-VMXON
>>> is less risky overall, in no small part because we need that to work anyways for
>>> hosts that are actively running VMs.
>>
>> How about we only keep VMX always on when TDX is enabled?
> 
> Paolo also suggested that forcing VMXON only if TDX is enabled, mostly because
> kvm-intel.ko and kvm-amd.ko may be auto-loaded based on MODULE_DEVICE_TABLE(),
> which in turn causes problems for out-of-tree hypervisors that want control over
> VMX and SVM.
> 
> I'm not opposed to the idea, it's the complexity and messiness I dislike.  E.g.
> the TDX code shouldn't have to deal with CPU hotplug locks, core KVM shouldn't
> need to expose nolock helpers, etc.  And if we're going to make non-trivial
> changes to the core KVM hardware enabling code anyways...
> 
> What about this?  Same basic idea as before, but instead of unconditionally doing
> hardware enabling during module initialization, let TDX do hardware enabling in
> a late_hardware_setup(), and then have KVM x86 ensure virtualization is enabled
> when creating VMs.
> 
> This way, architectures that aren't saddled with out-of-tree hypervisors can do
> the dead simple thing of enabling hardware during their initialization sequence,
> and the TDX code is much more sane, e.g. invoke kvm_x86_enable_virtualization()
> during late_hardware_setup(), and kvm_x86_disable_virtualization() during module
> exit (presumably).

Fine to me, given I am not familiar with other ARCHs, assuming always 
enable virtualization when KVM present is fine to them. :-)

Two questions below:

> +int kvm_x86_enable_virtualization(void)
> +{
> +	int r;
> +
> +	guard(mutex)(&vendor_module_lock);

It's a little bit odd to take the vendor_module_lock mutex.

It is called by kvm_arch_init_vm(), so more reasonablly we should still 
use kvm_lock?

Also, if we invoke kvm_x86_enable_virtualization() from 
kvm_x86_ops->late_hardware_setup(), then IIUC we will deadlock here 
because kvm_x86_vendor_init() already takes the vendor_module_lock?

> +
> +	if (kvm_usage_count++)
> +		return 0;
> +
> +	r = kvm_enable_virtualization();
> +	if (r)
> +		--kvm_usage_count;
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(kvm_x86_enable_virtualization);
> +

[...]

> +int kvm_enable_virtualization(void)
>   {
> +	int r;
> +
> +	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
> +			      kvm_online_cpu, kvm_offline_cpu);
> +	if (r)
> +		return r;
> +
> +	register_syscore_ops(&kvm_syscore_ops);
> +
> +	/*
> +	 * Manually undo virtualization enabling if the system is going down.
> +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
> +	 * possible for an in-flight module load to enable virtualization
> +	 * after syscore_shutdown() is called, i.e. without kvm_shutdown()
> +	 * being invoked.  Note, this relies on system_state being set _before_
> +	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
> +	 * or this CPU observes the impedning shutdown.  Which is why KVM uses
> +	 * a syscore ops hook instead of registering a dedicated reboot
> +	 * notifier (the latter runs before system_state is updated).
> +	 */
> +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
> +	    system_state == SYSTEM_RESTART) {
> +		unregister_syscore_ops(&kvm_syscore_ops);
> +		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
> +		return -EBUSY;
> +	}
> +

Aren't we also supposed to do:

	on_each_cpu(__kvm_enable_virtualization, NULL, 1);

here?

>   	return 0;
>   }
>   


